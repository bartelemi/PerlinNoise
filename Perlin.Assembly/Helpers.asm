CODE SEGMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MATHEMATICAL FUNCTIONS

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates ease curve value for x = t
	;; t = (3t^2 - 2t^3)
	;; Only for REAL8! (doubles)
	EaseCurve MACRO t
		
		PUSH esi			  ; preserve ESI
		PUSH edi			  ; preserve EDI

		MOVDDUP xmm0, [t]     ; xmm0[0-63]   <- t, xmm0[64-127] <- t
		MOVAPS  xmm1, xmm0    ; xmm1[0-63]   <- t, xmm1[64-127] <- t
		MULPD   xmm0, xmm1    ; xmm0[0-63]   <- t*t, xmm0[64-127] <- t*t  
		MOV     eax, 0x02h	  ; eax			 <- 2
		MOVSS   xmm2, eax	  ; xmm2[0-63]   <- 2
		CVTSS2SD xmm2, xmm2	  ; xmm2[0-63]   <- 2.0  (conversion) [OLD: MOVLPD  xmm2, [two]]
		MULSD   xmm1, xmm2	  ; xmm1[0-63]   <- 2.0 * t
		MOV     eax, 0x03h	  ; eax			 <- 3
		MOVSS   xmm2, eax	  ; xmm2[0-63]   <- 3
		CVTSS2SD xmm2, xmm2	  ; xmm2[0-63]   <- 3.0  (conversion) [OLD: MOVHPD  xmm2, [three]]
		MOVLHPS xmm1, xmm2	  ; xmm1[63-127] <- 3.0  
		MULPD   xmm0, xmm1    ; xmm0[0-63]   <- t*t*t*2.0 , xmm0[64-127] <- t*t*3.0
		MOVHLPS xmm1, xmm0    ; xmm1[0-63]   <- t*t*t*2.0
		PSRLDQ  xmm0, 8		  ; xmm0[0-63]   <- t*t*3.0
		SUBSD   xmm0, xmm1	  ; xmm0[0-63]   <- t*t*(3.0-(t*2.0))
								 
		MOVSD [t], xmm0		  ; store the result back to the variable 
		POP edi				  ; restore edi
		POP esi				  ; restore esi

	ENDM

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Precise linear interpolation
	;; res = ((v0) + (t) * ((v1) - (v0)))
	;; Only for REAL8! (doubles)
	LineraInterpolation MACRO res, v0, v1, t
		
		PUSH esi			  ; preserve ESI
		PUSH edi			  ; preserve EDI

		MOVSD xmm0, [v1]	  ; xmm0[0-63] <- v1
		MOVSD xmm1, [v0]	  ; xmm1[0-63] <- v0
		MOVSD xmm2, [t]		  ; xmm2[0-63] <- t
		SUBSD xmm0, xmm1	  ; xmm0[0-63] <- v1 - v0
		MULSD xmm0, xmm2	  ; xmm0[0-63] <- t*(v1 - v0)
		ADDSD xmm0, xmm1	  ; xmm0[0-63] <- v0 + t*(v1 - v0)		

		MOVSD [res], xmm0	  ; store the result back to the variable 
		POP edi				  ; restore edi
		POP esi				  ; restore esi
	ENDM

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates base^exponent and returns in result
	Power PROC FAR base : REAL8, exponent : DWORD, result : REAL8

		MOV ecx, exponent	  ; ecx		   <- exponent
		MOVSD xmm0, [base]	  ; xmm0[0-63] <- base
		MOVSD xmm1, [base]	  ; xmm1[0-63] <- base

		IterPower:
			MULSD xmm0, xmm1  ; xmm0[0-63] <- xmm0[0-63] * base
			DEC ecx
			TEST ecx, ecx
			JNZ IterPower

		MOVSD [result], xmm0  ; store the result back to the variable 
		XOR eax, eax		 
		RET
	Power ENDP

;;;;;;;;;;;;;;;;;;
;; ARRAY FUNCTIONS

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Allocs 2-dimensional array and initializes it with 0's (calloc)
	;; Returns allocated memory pointer in eax
	Alloc2DArray PROC FAR w : DWORD, h : DWORD

		;MOV ecx, w		 ecx <- width
		;MOV edx, h		 edx <- height

		INVOKE crt_calloc, edx, 4
		MOV ebx, eax

		xor ecx, ecx

		IterAlloc:
			INVOKE crt_calloc, ecx, 8
			MOV [ebx + 4*edx], eax

			INC ecx
			CMP ecx, h
			JNE IterAlloc
		
		RET
	Alloc2DArray ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Frees 2-dimensional array
	Free2DArray PROC FAR pointer : DWORD, h : DWORD
	
		XOR eax, eax
		RET
	Free2DArray ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Finds min and max value in array2D
	MaxMinFrom2DArray PROC FAR arr : DWORD, w : DWORD, h : DWORD, min : DWORD, max : DWORD

		LOCAL minimum  : REAL8
		LOCAL maximum : REAL8

		MOV ebx, arr		; ebx <- array base
		MOV ecx, w			; ecx <- array width
		MOV edx, h			; edx <- array height
		DEC ecx
		DEC edx

		MOV minimum, REAL8 PTR [ebx+8*ecx+edx] ; minimum  <- array[height-1][width-1]
		MOV maximum, REAL8 PTR [ebx+8*ecx+edx] ; maximum  <- array[height-1][width-1]

		MOVSD xmm0, REAL8 PTR [ebx+8*ecx+edx]
		MOVSD xmm1, REAL8 PTR [ebx+8*ecx+edx]


		XOR eax, eax
		RET
	MaxMinFrom2DArray ENDP
	
	OPTION PROLOGUE:NONE 
	OPTION EPILOGUE:NONE 
	MyMinMax    PROC    p:dword, n:dword

			MOV     ecx, [esp+8]    ;n
			MOV     edx, [esp+4]    ;p
			FLD     real8 PTR [edx]             ; set st(1) to MAX value        
			FLD     st(0)                       ; set st(0) to MIN value
			SUB     ecx, 1                      ; points to the last value
	  L0:
			FLD     real8 ptr [edx+ecx*4]
			FCOMI   st, st(1)                   ; compare st(1)=MIN with st(0)
			JAE     L1
			FXCH    st(1)

			FSTP    st
			SUB     ecx, 1
			JNZ     L0                          ; if ecx>0 loop to L0        
			RET     8
                
	  L1:   FCOMI   st, st(2)                   ; compare st(2)=MAX with st(0)
			JBE     L2
			FXCH    st(2)

	  L2:   FSTP    st
			SUB     ecx, 1
			JNZ     L0                          ; if ecx>0 loop to L0        
			RET     8
	MyMinMax    ENDP
	OPTION PROLOGUE:PrologueDef 
	OPTION EPILOGUE:EpilogueDef


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Copies len bytes from src to dst
	memCopy MACRO src, dst, len 

		PUSH esi ; preserve ESI
		PUSH edi ; preserve EDI

		CLD 
		MOV esi, src ; source
		MOV edi, dst ; destination
		MOV ecx, len ; length 

		SHR ecx, 2 
		REP MOVSD

		MOV ecx, len ; length 
		AND ecx, 3 
		REP MOVSD

		POP edi ; restore EDI
		POP esi ; restore ESI 
	ENDM
CODE ENDS