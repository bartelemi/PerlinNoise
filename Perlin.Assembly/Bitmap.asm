CODE SEGMENT
	;;;;;;;;;
	;; PROTOS
		
		FillHeader		PROTO w : DWORD, h : DWORD
		WriteFileHdr	PROTO pointer : DWORD, w : DWORD, h : DWORD
		CreateBMP		PROTO noiseArray : DWORD, params : THREADPARAMS
		GetColor		PROTO value : REAL8, min : REAL8, max : REAL8, color : DWORD 
		GetPixelValues	PROTO x : DWORD, y : DWORD, min : DWORD, max : DWORD, noiseArray : DWORD, params : THREADPARAMS 
		SinNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		SqrtNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		Experimental1	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		Experimental2	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		Experimental3	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		ScaleToChar		PROTO x : REAL8, min:REAL8, max:REAL8


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns filled BMPFILEHEADER
	FillHeader PROC w : DWORD, h : DWORD
		
		LOCAL fSize : DWORD


		MOV edx, w	    ; Compute file size in bytes
		IMUL edx, 3	    ; 
		MOV eax, edx    ; sizeof(BMPFILEHEADER)
		AND eax, 3      ; +(height * (width * 3
		MOV ebx, 4      ; +((4 - ((width * 3) & 3)) & 3)))
		SUB ebx, eax;	;
		AND ebx, 3;		;
		ADD edx, ebx;	;
		IMUL edx, h     ; 
		ADD edx, 54		;
		MOV fSize, edx  ; And store result in var

		INVOKE crt_malloc, 54	; Allocate memory for header

		; Fill bitmap file structure
		XOR ebx, ebx
		MOV WORD PTR[eax + ebx], 4D42h    ; Load signature 'B''M'
		ADD ebx, 2
		MOV edx, fSize
		MOV DWORD PTR[eax + ebx], edx     ; File size
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0       ; Reserved 0 and reserved 1
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 54      ; Offset
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 40      ; BMP size
		ADD ebx, 4
		MOV edx, w
		MOV DWORD PTR[eax + ebx], edx     ; BMP width
		ADD ebx, 4
		MOV edx, h
		MOV DWORD PTR[eax + ebx], edx     ; BMP height
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 180001h ; BMP planes and bit count
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0       ; BMP compression
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0		  ; BMP image size
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0EC4h	  ; BMP x-axis DPI
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0EC4h	  ; BMP y-axis DPI
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0		  ; BMP colors used
		ADD ebx, 4
		MOV DWORD PTR[eax + ebx], 0		  ; BMP important colors

		RET
	FillHeader ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Write file header
	WriteFileHdr PROC pointer : DWORD, w : DWORD, h : DWORD

		INVOKE FillHeader, w, h
		memCopy eax, [p], 54
		INVOKE crt_free, eax

		XOR eax, eax
		RET
	WriteFileHdr ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Creates BMP using data from NoiseArray
	CreateBMP PROC noiseArray : DWORD, params : THREADPARAMS 

		LOCAL pixel     :  PIXEL
		LOCAL min, max  :  REAL8
		LOCAL i, j, k   :  DWORD
		LOCAL pixSize   :  DWORD
		LOCAL nPad		:  DWORD
		LOCAL pad		:  DWORD
		LOCAL pointer   :  DWORD



		XOR eax, eax
		RET
	CreateBMP ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns new pixel 
	;;
	;;
	;; Returns pointer to new PIXEL in eax
	GetPixelValues PROC x : DWORD, y : DWORD, min : DWORD, max : DWORD, noiseArray : DWORD, params : THREADPARAMS 

		LOCAL pix			  :  DWORD
		LOCAL value           :  REAL8
		LOCAL minAfterEffect  :  REAL8
		LOCAL maxAfterEffect  :  REAL8

		INVOKE crt_malloc, 24	; Alloc memory for new pixel
		MOV pix, eax  			; Init pixel
		; Init value
		; Init minAfterEffect
		; Init maxAfterEffect

		LEA eax, [value]			; Load pointer to value
		LEA ebx, [minAfterEffect]	; Load pointer to minAfterEffect
		LEA ecx, [maxAfterEffect]	; Load pointer to minAfterEffect
		
		MOV edx, params._effect
		DEC edx
		JNZ @F 
		
		INVOKE SinNoise, eax, ebx, ecx, x, y
		@@:	
			DEC edx
			JNZ @F 
		INVOKE SqrtNoise, eax, ebx, ecx, x, y
		@@:
			DEC edx
			JNZ @F 
		INVOKE Experimental1, eax, ebx, ecx, x, y
		@@:
			DEC edx
			JNZ @F 
		INVOKE Experimental2, eax, ebx, ecx, x, y
		@@:
			DEC edx
			JNZ @F 
		INVOKE Experimental3, eax, ebx, ecx, x, y
		@@:	

		INVOKE GetColor, value, minAfterEffect, maxAfterEffect, pix

		MOV eax, pix			; Move pointer to pixel to eax for return
		RET
	GetPixelValues ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	SinNoise PROC value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD

		XOR eax, eax
		RET
	SinNoise ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	SqrtNoise PROC value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD


		XOR eax, eax
		RET
	SqrtNoise ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental1 PROC value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
		
		XOR eax, eax
		RET
	Experimental1 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental2 PROC value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	
		XOR eax, eax
		RET
	Experimental2 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental3 PROC value : DWORD, min : DWORD, max : DWORD, x : DWORD , y : DWORD
	
		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	Experimental3 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Scaling x in [min; max] -> [a; b]
	;; Where we need to calculate min and max
	;; and a = 0, b = 255 (unsigned char)
	;;
	;; Formula:
	;;        (b - a)(x - min)
	;; f(x) = ----------------  + a
	;;           max - min
	;;
	;; Result in eax.
	ScaleToChar PROC x:REAL8, min:REAL8, max:REAL8

		MOVLPD  xmm0, REAL8 PTR [x]		; Store x to lower quadword of xmm0
		MOVHPD  xmm0, REAL8 PTR [max]	; Store max to upper quadword of xmm0
		MOVDDUP xmm1, REAL8 PTR [min]	; Store min to lower and upper quadword of xmm1
		SUBPD   xmm0, xmm1				; xmm0[63-0] <- (x-min);  xmm0[127-64] <- (max-min) 
		MOVHLPS xmm1, xmm0				; xmm1[63-0] <- (max-min)
		DIVSD	xmm0, xmm1				; xmm0[63-0] <- (x-min) / (max-min)
		MOV eax, 255					; eax		 <- 255
		CVTSI2SD xmm1, eax				; xmm1[63-0] <- 255.0
		MULSD xmm0, xmm1				; xmm0[63-0] <- 255.0 * (x-min) / (max-min)
		CVTSD2SI eax, xmm0				; eax		 <- (int)(255.0 * (x-min) / (max-min))
		RET
	ScaleToChar ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns colored pixel
	GetColor PROC value : REAL8, min : REAL8, max : REAL8, color : DWORD
	
		INVOKE ScaleToChar, value, min, max
		TEST eax, eax
		JNE CalcColor
			INC eax

		CalcColor:
			SHL eax, 8
			MOV ebx, eax
			LEA esi, [color]

			MOV ecx, [esi + 16]
			INC ecx
			DIV ecx
			MOV [esi+16], eax
		
			MOV eax, ebx
			MOV ecx, [esi+8]	
			INC ecx
			DIV ecx
			MOV [esi+8], eax

			MOV eax, ebx
			MOV ecx, [esi]
			INC ecx
			DIV ecx
			MOV [esi], eax

		RET
	GetColor ENDP
CODE ENDS