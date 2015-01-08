;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MATHEMATICAL FUNCTIONS

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates ease curve value for x = t
	;; t = (3t^2 - 2t^3)
	;;
	;; Only for REAL8! (doubles)
	EaseCurve MACRO res, x
		
		MOVDDUP  xmm0, REAL8 PTR [x]    ; xmm0[0-63]   <- x, xmm0[64-127]   <- x
		MOVAPD   xmm1, xmm0				; xmm1[0-63]   <- x, xmm1[64-127]   <- x
		MULPD    xmm0, xmm1				; xmm0[0-63]   <- x*x, xmm0[64-127] <- x*x  
		MOV      eax, 2					; eax		   <- 2
		PINSRD   xmm2, eax, 00b			; xmm2[0-31]   <- 2
		CVTSS2SD xmm2, xmm2				; xmm2[0-63]   <- 2.0  (conversion) [OLD: MOVLPD  xmm2, [two]]
		MULSD    xmm1, xmm2				; xmm1[0-63]   <- 2.0 * x
		MOV      eax, 3					; eax		  <- 3
		PINSRD   xmm2, eax, 00b			; xmm2[0-31]   <- 3
		CVTSS2SD xmm2, xmm2				; xmm2[0-63]   <- 3.0  (conversion) [OLD: MOVHPD  xmm2, [three]]
		MOVLHPS  xmm1, xmm2	   			; xmm1[63-127] <- 3.0  
		MULPD    xmm0, xmm1    			; xmm0[0-63]   <- x*x*x*2.0 , xmm0[64-127] <- x*X*3.0
		MOVHLPS  xmm1, xmm0    			; xmm1[0-63]   <- x*x*x*2.0
		PSRLDQ   xmm0, 8	   			; xmm0[0-63]   <- x*x*3.0
		SUBSD    xmm0, xmm1	   			; xmm0[0-63]   <- x*x*(3.0-(x*2.0))
								 		;
		MOVSD    REAL8 PTR [res], xmm0	; store the result back to the variable 

	ENDM

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Precise linear interpolation
	;; res = ((v0) + (t) * ((v1) - (v0)))
	;;
	;; Only for REAL8! (doubles)
	LinearInterpolation MACRO res, v0, v1, tmp
		
		MOVSD xmm0, REAL8 PTR [v1]	; xmm0[0-63] <- v1
		MOVSD xmm1, REAL8 PTR [v0]	; xmm1[0-63] <- v0
		MOVSD xmm2, REAL8 PTR [tmp]	; xmm2[0-63] <- t
		SUBSD xmm0, xmm1			; xmm0[0-63] <- v1 - v0
		MULSD xmm0, xmm2			; xmm0[0-63] <- t*(v1 - v0)
		ADDSD xmm0, xmm1			; xmm0[0-63] <- v0 + t*(v1 - v0)		
		MOVSD res, xmm0				; Store the result

	ENDM
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates base^exp and returns in res
	;;
	;; Params:
	;;	base - REAL8 in xmm register (not xmm0)
	;;  exp  - general purpose register or immediate
	;;
	;; Result in xmm0
	Power MACRO base, exp
		
		XOR eax, eax		; eax <- 0
		INC eax				; eax <- 1
		CVTSI2SD xmm0, eax	; xmm0 <- 1.0

		MOV eax, exp		; eax  <- exponent
		MOVSD xmm1, base	; xmm1 <- base

		@@:
			MULSD xmm0, xmm1	; xmm0 <- xmm0 * base
			DEC   eax			; Decrement counter
			TEST  eax, eax		; Test counter for zero
			JNZ   @B			; Continue if counter is greater than zero

	ENDM

;;;;;;;;;;;;;;;;;;
;; ARRAY FUNCTIONS

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Finds min and max value in arr and stores them into given
	;; max and min pointers.
	;;
	;;
	MaxMin PROC arr : DWORD, n : DWORD, pmin : DWORD, pmax : DWORD

		LOCAL pmin_tmp		:  DWORD
		LOCAL pmax_tmp		:  DWORD

		MOV edx, arr							; ebx <- array base
		MOV eax, pmin							;
		MOV pmin_tmp, eax						; Store pointer to min in local variable
		MOV eax, pmax							;
		MOV pmax_tmp, eax						; Store pointer to max in local variable
												;
		MOVSD xmm0, REAL8 PTR [edx]				; xmm0 <- array[0]
		MOVSD xmm1, xmm0						; xmm1 <- array[0]
												;		
		MOV eax, n								; eax <- n
		TEST eax, eax							; Test for array size of 1
		JZ @MaxMinFinalize						; Go to end if array size = 1
												;
		XOR edi, edi							; edi <- 0
		INC edi									; edi <- 1 (second index in array)
		@MaxMinLoop:
			MOVSD xmm2, REAL8 PTR [edx + 8*edi]
			CMPSD xmm0, xmm2, 001B				; Test for "less than xmm0"
			PEXTRW eax, xmm0, 0
			NEG eax
			JZ @NewMin
			
			MOVSD xmm3, xmm2
			CMPSD xmm2, xmm1, 001B 				; Test for "more than xmm1"
			PEXTRW eax, xmm1, 0
			NEG eax
			JZ @NewMax

			@NewMin:
				MOVSD xmm0, xmm2				; Load new minimum value
				JMP @NextStep

			@NewMax:
				MOVSD xmm1, xmm3				; Load new maximum value

			@NextStep:
				INC edi
				CMP edi, n
				JNE @MaxMinLoop

		@MaxMinFinalize:
			MOV   edx, pmin_tmp
			MOVSD REAL8 PTR [edx], xmm0			; *min <- found min value
			MOV   edx, pmax_tmp
			MOVSD REAL8 PTR [edx], xmm1			; *max <- found max value

		XOR eax, eax
		RET
	MaxMin ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Copies len bytes from src to dst
	memCopy MACRO src, dst, len 

		PUSH esi ; preserve ESI
		PUSH edi ; preserve EDI
		PUSH ecx ; preserve ECX
		CLD 
		MOV esi, src ; source
		MOV edi, dst ; destination
		MOV ecx, len ; length 

		SHR ecx, 2 
		REP MOVSD

		MOV ecx, len ; length 
		AND ecx, 3 
		REP MOVSD

		POP ecx ; restore ECX
		POP edi ; restore EDI
		POP esi ; restore ESI 
	ENDM