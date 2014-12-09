CODE SEGMENT

	;#define at2(rx,ry) ( (rx) * q[0] + (ry) * q[1] )
	at2 MACRO rx, ry, q, res
		
		PUSH esi
		PUSH edi

		MOV eax, q
		MOVLPD  xmm0, REAL8 PTR [rx] ; xmm0[0-63]   <- rx
		MOVHPD  xmm0, REAL8 PTR [ry] ; xmm0[64-127] <- ry
		MOVAPS  xmm1, [eax]			 ; xmm1[0-127]  <- q
		MULPD   xmm0, xmm1			 ; xmm0[0-63]   <- rx * q[0]; xmm0[64-127] <- ry * q[1] 
		MOVHLPS xmm1, xmm0			 ; xmm1[0-63]   <- ry * q[1]
		ADDSD   xmm0, xmm1			 ; xmm[0-63]    <- rx*q[0] + ry*q[1]
		MOVLPD REAL8 PTR [res], xmm0 ; Store result in variable

		POP edi
		POP esi
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
		
		PUSH esi			  ; Store esi
		PUSH edi			  ; Store edi

		;Calculate tmp
		MOVD  xmm0, B    	  ; Load init array size to xmm0
		ADDSD xmm0, i		  ; xmm0 stores tmp whole time

		;Calculate b0
		CVTSD2SI eax, xmm0	  ; Calculate (int)tmp and store in eax
		MOVD     xmm1, eax	  ; Store (int)tmp for later use
		AND		 eax, [BMask] ; Make sure that value of b0 isn't bigger than array size
		MOV		 b0, eax	  ; Store into b0

		;Calculate b1
		INC eax				  ; Increment value of b0
		AND eax, [BMask]	  ; Make sure that value of b1 isn't bigger than array size
		MOV b1, eax			  ; Store value into b1

		;Calculate r0
		SUBSD  xmm0, xmm1	  ; Calculate tmp - (int)tmp
		MOVLPD REAL8 PTR [r0], xmm0		  ; Store value into r0

		;Calculate r1
		XOR    eax, eax		  ; eax  <- 0
		INC    eax			  ; eax  <- 1
		MOVD   xmm1, eax	  ; xmm1 <- 1
		SUBSD  xmm0, xmm1	  ; xmm0 <- r0 - 1
		MOVLPD REAL8 PTR [r1], xmm0		  ; Store value into r0

		POP edi				  ; Resotre edi
		POP esi				  ; Restore esi
	ENDM


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns noise value for point (x, y)
	;;
	;; Result returned by val pointer
	Noise PROC x : REAL8, y : REAL8, val : DWORD
		LOCAL q					  :  DWORD
		LOCAL bxy				  :  DWORD
		LOCAL i, j				  :  DWORD
		LOCAL bx0, bx1, by0, by1  :  DWORD
		LOCAL a, b				  :  REAL8
		LOCAL u, v, t			  :  REAL8
		LOCAL rx0, rx1, ry0, ry1  :  REAL8

		; Initialize variables
		 Setup x, bx0, bx1, rx0, ry1
		 Setup y, by0, by1, ry0, ry1

		; Init i
		 MOV ecx, bx0
		 LEA ebx, [p + 4*ecx]
		 MOV i, ebx

		; Init j
		 MOV ecx, bx1
		 LEA ebx, [p + 4*ecx]
		 MOV j, ebx

		; Calculate easing function value for dot product of x
		 EaseCurve t, rx0
								 
		; Calculate first vector on x-axis
		 MOV eax, i
		 ADD eax, by0
		 MOV ebx, [p + 4*eax]
		 LEA ecx, [g2 + 8*ebx]
		 MOVUPS xmm0, [ecx]
		 MOVUPS q, xmm0
		 at2 rx0, ry0, q, u

		; Calculate second vector on x-axis
		 MOV eax, j
		 ADD eax, by0
		 MOV ebx, [p + 4*eax]
		 LEA ecx, [g2 + 8*ebx]
		 MOVUPS xmm0, [ecx]
		 MOVUPS q, xmm0
		 at2 rx1, ry0, q, v

		; Interpolate vectors on x-axis and store result in a
		 LineraInterpolation a, u, v, t


		; Calculate first vector on y-axis
		 MOV eax, i
		 ADD eax, by1
		 MOV ebx, [p + 4*eax]
		 LEA ecx, [g2 + 8*ebx]
		 MOVUPS xmm0, [ecx]
		 MOVUPS q, xmm0
		 at2 rx0, ry1,q, u

		; Calculate second vector on y-axis
		 MOV eax, j
		 ADD eax, by1
		 MOV ebx, [p + 4*eax]
		 LEA ecx, [g2 + 8*ebx]
		 MOVUPS xmm0, [ecx]
		 MOVUPS q, xmm0
		 at2 rx1, ry1, q, v

		; Interpolate vectors on y-axis and store result in b
		 LineraInterpolation b, u, v, t

		; Calculate easing function value for dot product of y
		 EaseCurve t, ry0

		MOVQ xmm0, t
		MOVQ REAL8 PTR [val], xmm0

		XOR eax, eax
		RET
	Noise ENDP
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initializes noise array with noise values, 
	;; according to params (octaves, persistence)
	PerlinNoise2D PROC noise : DWORD, params : THREADPARAMS
		LOCAL i, j, k, t :  DWORD
		LOCAL x, y       :  REAL8
		LOCAL amp, freq  :  REAL8
		
		; Initialize k-loop variables
		 MOV eax, params._octaves 
		 MOV k, eax				 ; k stores k-loop max value
		 XOR ebx, ebx			 ; ebx stores k-loop current value

		NoiseLoopK:
			MOV eax, 2			; Base to eax
			PINSRD xmm4, eax, 0 ; Copy base to xmm1
			Power xmm4, k		; Calculate 2^k
			MOVSD REAL8 PTR [amp], xmm4 ; Store result in amp xmm4

			MOVSD xmm5, REAL8 PTR [params._persistence]
			Power xmm5, k		; Calculate persistence^k
			MOVSD REAL8 PTR [freq], xmm5 ; Store result in freq xmm5

			; Initialize i-loop variables
			 MOV eax, params._offset
			 ADD eax, params._height	
			 MOV i, eax				 ; i stores max value of i-loop
			 MOV ecx, params._offset ; ecx stores i-loop current value

			NoiseLoopI:
				; Initialize j-loop variables
				 MOV eax, params._width
				 MOV j, eax				; j stores max value of j-loop
				 XOR edx, edx			; edx storec j-loop current value

				NoiseLoopJ:
					MOV eax, 100		
					PINSRD xmm1, eax, 0					; Insert 100 to xmm1[0-31]
					PINSRD xmm1, eax, 2					; Insert 100 to xmm1[64-95]
					CVTDQ2PD xmm1, xmm1					; Convert integer to doubles

					PINSRD xmm2, DWORD PTR [i], 0		; Insert i to xmm2[0-31]
					PINSRD xmm2, DWORD PTR [j], 2		; Insert j to xmm2[64-95]
					CVTDQ2PD xmm2, xmm2					; Convert integer to doubles

					INVOKE RandomNumber, NSeed	
					PINSRD xmm0, eax, 0					; Insert first random to xmm0[0-31]
					
					INVOKE RandomNumber, NSeed
					PINSRD xmm0, eax, 2					; Insert second random to xmm0[64-95]

					ANDPD xmm0, xmm1					; Modulo 100
					DIVPD xmm0, xmm1					; Divide by 100 to make it dot product
					ADDPD xmm0, xmm2					; 

					LEA eax, [t]
					INVOKE Noise, x, y, eax

					; x = frequency * (i + ((rand() % 100) / 100.0)) 
					; y = frequency * (j + ((rand() % 100) / 100.0))
					; noiseArray[i][j] += amplitude * noise2(x, y) <- mamy w eax wskaŸnik na wynik Noise(x, y)

					INC edx
					CMP edx, j
					JNE NoiseLoopJ
				INC ecx
				CMP ecx, i
				JNE NoiseLoopI
			INC ebx
			CMP ebx, k
			JNE NoiseLoopK



			

		XOR eax, eax
		RET
	PerlinNoise2D ENDP

CODE ENDS