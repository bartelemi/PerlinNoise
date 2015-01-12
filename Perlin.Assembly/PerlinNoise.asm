ALIGN 16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; at2(rx,ry) ((rx) * q[0] + (ry) * q[1])
at2 MACRO res, rx, ry, q
				
	MOVLPD  xmm0, REAL8 PTR [rx]	; xmm0[0-63]   <- rx
	MOVHPD  xmm0, REAL8 PTR [ry]	; xmm0[64-127] <- ry
	MOVUPD  xmm1, [q]				; xmm1[0-127]  <- q
	MULPD   xmm0, xmm1				; xmm0[0-63]   <- rx * q[0]; xmm0[64-127] <- ry * q[1] 
	MOVHLPS xmm1, xmm0				; xmm1[0-63]   <- ry * q[1]
	ADDSD   xmm0, xmm1				; xmm0[0-63]   <- rx * q[0] + ry * q[1]
	MOVSD   REAL8 PTR [res], xmm0	; [res]		   <- result
	
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializes variables for calculating Perlin noise for (x,y)
;;
;; Initialization as follows:
;; tmp = B + i;                    
;; b0  = ((int)(tmp)) & BMask
;; b1  = (b0 +1) & BMask   
;; r0  = tmp - (int)(tmp)   
;; r1  = r0 - 1.0
Setup MACRO i, b0, b1, r0, r1
		
	; Calculate tmp
		MOV		 eax, B					; eax <- B
		CVTSI2SD xmm0, eax				; Convert B in xmm0 to double
		ADDSD    xmm0, i				; xmm0 stores tmp whole time

	; Calculate b0
		CVTSD2SI eax, xmm0				; Calculate (int)tmp and store in eax
		CVTSI2SD xmm1, eax				; Store (int)tmp for later use
		AND		 eax, BMask				; Make sure that value of b0 isn't bigger than array size
		MOV		 b0, eax				; Store into b0

	; Calculate b1
		INC		 eax					; Increment value of b0
		AND		 eax, BMask				; Make sure that value of b1 isn't bigger than array size
		MOV		 b1, eax				; Store value into b1

	; Calculate r0
		SUBSD	 xmm0, xmm1				; Calculate tmp - (int)tmp
		MOVSD    REAL8 PTR [r0], xmm0	; Store value into r0

	; Calculate r1
		XOR      eax, eax				; eax  <- 0
		INC      eax					; eax  <- 1
		CVTSI2SD xmm1, eax				; xmm1 <- 1.0
		SUBSD    xmm0, xmm1				; xmm0 <- r0 - 1.0
		MOVSD    REAL8 PTR [r1], xmm0	; Store value into r0

ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns noise value for point (x, y)
;;
;; Result returned in xmm0[0-63]
Noise PROC USES ebx ecx edi esi x : REAL8, y : REAL8 
	LOCAL i, j				  :  DWORD
	LOCAL bx0, bx1, by0, by1  :  DWORD
	LOCAL a					  :  REAL8
	LOCAL b					  :  REAL8
	LOCAL u					  :  REAL8
	LOCAL v					  :  REAL8
	LOCAL t					  :  REAL8
	LOCAL rx0				  :  REAL8
	LOCAL rx1				  :  REAL8
	LOCAL ry0				  :  REAL8
	LOCAL ry1				  :  REAL8

	; Initialize variables
		Setup x, bx0, bx1, rx0, rx1
		Setup y, by0, by1, ry0, ry1

		MOV edi, p		; edi stores base address of p
		MOV esi, g2		; esi stores base address of g2

	; Init i
		MOV ecx, bx0
		MOV ebx, [edi + 4*ecx]
		MOV i, ebx

	; Init j
		MOV ecx, bx1
		MOV ebx, [edi + 4*ecx]
		MOV j, ebx
								 
	; Calculate first vector on x-axis
		MOV ecx, i				; eax  <- i
		ADD ecx, by0			; eax  <- i + by0
		MOV ebx, [edi + 4*ecx]	; ebx  <- p[i + by0]
		MOV ecx, [esi + 4*ebx]	; ecx  <- g2[ebx] (address of row)
		at2 u, rx0, ry0, ecx

	; Calculate second vector on x-axis
		MOV ecx, j				; eax  <- j
		ADD ecx, by0			; eax  <- j + by0
		MOV ebx, [edi + 4*ecx]	; ebx  <- p[j + by0]
		MOV ecx, [esi + 4*ebx]	; ecx  <- g2[ebx] (address of row)
		at2 v, rx1, ry0, ecx

	; Calculate easing function value for dot product of x
		EaseCurve t, rx0

	; Interpolate vectors on x-axis and store result in a
		LinearInterpolation a, u, v, t

	; Calculate first vector on y-axis
		MOV ecx, i				; eax  <- i
		ADD ecx, by1			; eax  <- i + by1
		MOV ebx, [edi + 4*ecx]	; ebx  <- p[i + by1]
		MOV ecx, [esi + 4*ebx]	; ecx  <- g2[ebx] (address of row)
		at2 u, rx0, ry1, ecx

	; Calculate second vector on y-axis
		MOV ecx, j				; eax  <- j
		ADD ecx, by1			; eax  <- j + by1
		MOV ebx, [edi + 4*ecx]	; ebx  <- p[j + by1]
		MOV ecx, [esi + 4*ebx]	; ecx  <- g2[ebx] (address of row)
		at2 v, rx1, ry1, ecx

	; Interpolate vectors on y-axis and store result in b
		LinearInterpolation b, u, v, t
		
	; Calculate easing function value for dot product of y
		EaseCurve t, ry0

	; Final interpolation on both parts of vector
		LinearInterpolation t, a, b, t

	XOR eax, eax
	RET
Noise ENDP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializes noise array with noise values, 
;; according to params (octaves, persistence)
PerlinNoise2D PROC USES ebx ecx edx args : PARAMS
	LOCAL i_max		:  DWORD
	LOCAL x			:  REAL8
	LOCAL y			:  REAL8
		
	; Initialize variables
		MOV eax, args._offset							; eax <- offset
		ADD eax, args._height							; eax <- offset + height
		MOV i_max, eax				 					; i_max stores max value of i-loop
														;
		MOV esi, NoiseArray								; esi <- base of NoiseArray

	XOR ebx, ebx			 							; ebx stores k-loop current value
	@NoiseLoopK:
		INC ebx											; Loop starts from 1
		; Calculate 2^k
		 MOV      eax, 2								; Base to eax
		 CVTSI2SD xmm5, eax								; Move eax to xmm4 and convert to REAL8
		 Power    xmm5, ebx								
		 MOVSD    xmm5, xmm0 							; Store amp result in xmm5
		
		; Calculate persistence^k						
		 MOVSD    xmm6, REAL8 PTR [args._persistence]	; Load value of persistence
		 Power    xmm6, ebx								
		 MOVDDUP  xmm6, xmm0			 				; Store freq result in both quadwords of xmm6
		 
		MOV ecx, args._offset 							; ecx stores i-loop current value
		@NoiseLoopI:
				
			XOR edi, edi								; edi stores j-loop current value
			@NoiseLoopJ:
				CALL	RandReal						; Generate random dot product for y	[0; 1)
				MOVLHPS xmm0, xmm0						; Move result to upper quadword of xmm0
				CALL	RandReal						; Generate random dot product for x [0; 1)
														;
				PINSRD   xmm1, ecx, 00b					; Insert i to xmm1[0-31]
				PINSRD   xmm1, edi, 01b					; Insert j to xmm1[32-63]
				CVTDQ2PD xmm1, xmm1						; Convert i and j from integers to doubles
														;
				ADDPD    xmm0, xmm1						; xmm0[0-63] += i; xmm0[64-127] += j
				MULPD    xmm0, xmm6						; Multiply upper and lower doubles by freq
														;
				MOVLPS   x, xmm0						; Store calculated x in local var
				MOVHPS   y, xmm0						; Store calculated y in local var
														;
				INVOKE   Noise, x, y					; Calculate Noise value for given (x,y) [result in xmm0]
				MULSD    xmm0, xmm5						; Noise * amplitude				
														;
				MOV	     eax, ecx						; eax <- current i index
				MUL      args._width					; eax <- i * width
				ADD	     eax, edi						; eax <- (i * width) + j 
				MOVSD    xmm1, REAL8 PTR [esi + 8*eax]	; xmm1 <- NoiseArray[i][j]
				ADDSD    xmm0, xmm1						; xmm0 <- xmm1 + NoiseArray[i][j]
				MOVSD    REAL8 PTR [esi + 8*eax], xmm0	; NoiseArray[i][j] <- new value

				INC edi
				CMP edi, args._width
				JNE @NoiseLoopJ
			INC ecx
			CMP ecx, i_max
			JNE @NoiseLoopI
		CMP ebx, args._octaves
		JNE @NoiseLoopK

	XOR eax, eax
	RET
PerlinNoise2D ENDP