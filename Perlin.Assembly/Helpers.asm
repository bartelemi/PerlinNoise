ALIGN 16
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MATHEMATICAL FUNCTIONS

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates ease curve value for x = t
	;; t = (3t^2 - 2t^3)
	;;
	;; Only for REAL8! (doubles)
	EaseCurve MACRO res, x
		
		MOVDDUP  xmm0, REAL8 PTR [x]    ; xmm0[0-63]   <- x,   xmm0[64-127]   <- x
		MOVAPD	 xmm1, xmm0				; xmm1[0-63]   <- x,   xmm1[64-127]   <- x
		MULPD    xmm0, xmm0				; xmm0[0-63]   <- x*x, xmm0[64-127]   <- x*x  
		MOV      eax, 2					; eax		   <- 2
		CVTSI2SD xmm2, eax				; xmm2[0-63]   <- 2.0
		MULSD    xmm1, xmm2				; xmm1[0-63]   <- 2.0 * x
		MOV      eax, 3					; eax		   <- 3
		CVTSI2SD xmm2, eax				; xmm2[0-63]   <- 3.0
		MOVLHPS  xmm1, xmm2	   			; xmm1[63-127] <- 3.0  
		MULPD    xmm0, xmm1    			; xmm0[0-63]   <- x*x*x*2.0 , xmm0[64-127] <- x*x*3.0
		MOVHLPS  xmm1, xmm0    			; xmm1[0-63]   <- x*x*x*2.0
		SUBSD    xmm1, xmm0	   			; xmm1[0-63]   <- x*x*(3.0-(x*2.0))
								 		;
		MOVSD    REAL8 PTR [res], xmm1	; store the result back to the variable 

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
									;		
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
		
		XOR      eax, eax	; eax <- 0
		INC      eax		; eax <- 1
		CVTSI2SD xmm0, eax	; xmm0 <- 1.0
		MOVSD    xmm1, base	; xmm1 <- base

		XOR eax, eax
		@@:
			CMP   eax, exp		; Test counter for equal exp
			JE    @F			; Continue if counter is different from exp
			MULSD xmm0, xmm1	; xmm0 <- xmm0 * base
			INC   eax			; Increment counter
			JMP   @B			; Loop
		@@:
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
		MOVSD xmm5, xmm0						; xmm5 <- copy min
		MOVSD xmm6, xmm0						; xmm6 <- copy max
												;		
		MOV  eax, n								; eax <- n
		DEC  eax								; eax <- n-1
		TEST eax, eax							; Test for array size of 1
		JZ   @MaxMinFinalize					; Go to end if array size = 1
												;
		XOR edi, edi							; edi <- 0
		INC edi									; edi <- 1 (second index in array)
		@MaxMinLoop:
			MOVSD  xmm2, REAL8 PTR [edx + 8*edi]; Load next element
			MOVSD  xmm3, xmm2					; Store current value for later use
												;
			CMPSD  xmm1, xmm2, 001B 			; Test for "more than xmm1"
			PEXTRD eax, xmm1, 00B				; Extract low dword of result to eax
			NOT    eax							; Reverse eax
			TEST   eax, eax						; Test eax for 0
			JZ     @NewMax						; If eax == 0 than comparison successfull
												;
			CMPSD  xmm2, xmm0, 001B				; Test for "less than xmm0"
			PEXTRD eax, xmm2, 00B				; Extract low dword of result to eax
			NOT    eax							; Reverse eax
			TEST   eax, eax						; Test eax for 0
			JZ     @NewMin						; If eax == 0 than comparison successfull
			JMP	   @NextStep					; Go to next iteration
						
			@NewMax:
				MOVSD xmm1, xmm3				; Load new maximum value
				MOVSD xmm6, xmm3				; Copy new max
				JMP @NextStep					; Go to next iteration

			@NewMin:
				MOVSD xmm0, xmm3				; Load new minimum value
				MOVSD xmm5, xmm3				; Copy new min				

			@NextStep:
				MOVSD  xmm0, xmm5				; Restore current min
				MOVSD  xmm1, xmm6				; Restore current max
				INC edi							; Increment counter
				CMP edi, n						; Compare with array size
				JNE @MaxMinLoop					; Loop

		@MaxMinFinalize:
			MOV   edx, pmin_tmp					; Get address of pmin
			MOVSD REAL8 PTR [edx], xmm0			; *min <- found min value
			MOV   edx, pmax_tmp					; Get address of pmax
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