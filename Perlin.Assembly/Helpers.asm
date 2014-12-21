CODE SEGMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MATHEMATICAL FUNCTIONS

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates ease curve value for x = t
	;; t = (3t^2 - 2t^3)
	;;
	;; Only for REAL8! (doubles)
	EaseCurve MACRO res, x
		
		PUSH esi			   ; Preserve ESI
		PUSH edi			   ; Preserve EDI

		MOVDDUP  xmm0, REAL8 PTR [x]     ; xmm0[0-63]   <- x, xmm0[64-127]   <- x
		MOVAPD   xmm1, xmm0    ; xmm1[0-63]   <- x, xmm1[64-127]   <- x
		MULPD    xmm0, xmm1    ; xmm0[0-63]   <- x*x, xmm0[64-127] <- x*x  
		MOV      eax, 2	   ; eax		  <- 2
		PINSRD   xmm2, eax, 0  ; xmm2[0-31]   <- 2
		CVTSS2SD xmm2, xmm2	   ; xmm2[0-63]   <- 2.0  (conversion) [OLD: MOVLPD  xmm2, [two]]
		MULSD    xmm1, xmm2	   ; xmm1[0-63]   <- 2.0 * x
		MOV      eax, 3	   ; eax		  <- 3
		PINSRD   xmm2, eax, 0  ; xmm2[0-31]   <- 3
		CVTSS2SD xmm2, xmm2	   ; xmm2[0-63]   <- 3.0  (conversion) [OLD: MOVHPD  xmm2, [three]]
		MOVLHPS  xmm1, xmm2	   ; xmm1[63-127] <- 3.0  
		MULPD    xmm0, xmm1    ; xmm0[0-63]   <- x*x*x*2.0 , xmm0[64-127] <- x*X*3.0
		MOVHLPS  xmm1, xmm0    ; xmm1[0-63]   <- x*x*x*2.0
		PSRLDQ   xmm0, 8	   ; xmm0[0-63]   <- x*x*3.0
		SUBSD    xmm0, xmm1	   ; xmm0[0-63]   <- x*x*(3.0-(x*2.0))
								 
		MOVSD REAL8 PTR [res], xmm0	   ; store the result back to the variable 
		POP edi				  ; Restore edi
		POP esi				  ; Restore esi
	ENDM

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Precise linear interpolation
	;; res = ((v0) + (t) * ((v1) - (v0)))
	;;
	;; Only for REAL8! (doubles)
	LineraInterpolation MACRO res, v0, v1, tmp
		
		PUSH esi					; Preserve ESI
		PUSH edi					; Preserve EDI

		MOVSD xmm0, REAL8 PTR [v1]	; xmm0[0-63] <- v1
		MOVSD xmm1, REAL8 PTR [v0]	; xmm1[0-63] <- v0
		MOVSD xmm2, REAL8 PTR [tmp]	; xmm2[0-63] <- t
		SUBSD xmm0, xmm1			; xmm0[0-63] <- v1 - v0
		MULSD xmm0, xmm2			; xmm0[0-63] <- t*(v1 - v0)
		ADDSD xmm0, xmm1			; xmm0[0-63] <- v0 + t*(v1 - v0)		
		MOVSD REAL8 PTR [res], xmm0	; Store the result back to the variable 

		POP edi						; Restore edi
		POP esi						; Restore esi
	ENDM

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates base^exponent and returns in result
	;; 
	;; Params:
	;;	base	 - xmm register with base number value
	;;	exponent - DWORD value of exponent number
	;;	result	 - REAL8 PTR to result variable
	;Power PROC base : REAL8, exponent : DWORD, result : DWORD

		
	;	MOVSD xmm0, base	  ; xmm0[0-63] <- base
	;	MOVSD xmm1, base	  ; xmm1[0-63] <- base

	;	IterPower:
	;		MULSD xmm0, xmm1  ; xmm0[0-63] <- xmm0[0-63] * base
	;		DEC ecx
	;		TEST ecx, ecx
	;		JNZ IterPower

	;	MOVSD REAL8 PTR [result], xmm0  ; store the result back to the variable 
	;	XOR eax, eax		 
	;	RET
	;Power ENDP
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Calculates base^exp and returns in res
	;;
	;; Params:
	;;	base - xmm register (not xmm0)
	;;  exp  - general purpose register or immediate
	;;
	;; Result in xmm0
	Power MACRO base, exp
		
		MOV ecx, exp	  ; ecx  <- exponent
		MOVSD xmm1, base

		@@:
			MULSD xmm0, xmm1
			DEC ecx
			TEST ecx, ecx
			JNZ @B
	ENDM

;;;;;;;;;;;;;;;;;;
;; ARRAY FUNCTIONS

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Allocs 2-dimensional array and initializes it with 0's (calloc)
	;; Returns allocated memory pointer in eax
	Alloc2DArray PROC FAR w : DWORD, h : DWORD

		MOV eax, w		; eax <- width
		IMUL eax, h		; eax <- width * height

		INVOKE crt_calloc, eax, 8
		
		RET
	Alloc2DArray ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Finds min and max value in array2D
	MaxMinFrom2DArray PROC FAR arr : DWORD, n : DWORD, min : DWORD, max : DWORD
	
		MOV ebx, arr					; ebx <- array base
		MOV ecx, n						; ecx <- array size
		
		DEC ecx							; ecx points now last element of the array
		MOVSD xmm0, REAL8 PTR [ebx+8*ecx]; xmm0[0-63] <- array[n-1]
		MOVSD REAL8 PTR [min], xmm0		; minimum <- array[n-1]
		MOVSD REAL8 PTR [max], xmm0		; maximum <- array[n-1]
		CMP   ecx, 0						; test for array of size = 1
		JE MaxMinEnd					; jump if array of one element

		TEST ecx, 1						; if n is odd than: ZF <- 1
		JNZ MaxMinLoop					; if n is odd than ok

		MOVSD xmm1, REAL8 PTR [ebx + 8*ecx]		; xmm1[0-63] <- array[n-2]
		MOVSD xmm2, xmm1
		CMPSD xmm2, xmm0, 001b



		MaxMinLoop:
			MOVDQA xmm0, [ebx + ecx]
								
			

			DEC ecx
			DEC ecx
			JNZ MaxMinLoop

		MaxMinEnd:		
			XOR eax, eax
			RET
	MaxMinFrom2DArray ENDP
	
	OPTION PROLOGUE:NONE 
	OPTION EPILOGUE:NONE 
	MyMinMax    PROC    arr:dword, n:dword

			MOV     ecx, [esp+8]    ;n
			MOV     edx, [esp+4]    ;p
			FLD     real4 PTR [edx]             ; set st(1) to MAX value        
			FLD     st(0)                       ; set st(0) to MIN value
			SUB     ecx, 1                      ; points to the last value
	  L0:
			FLD     real4 ptr [edx+ecx*4]
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