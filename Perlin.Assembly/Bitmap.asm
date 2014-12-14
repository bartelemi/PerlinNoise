CODE SEGMENT
	
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
	WriteFileHdr PROC pointer : FAR PTR REAL8, w : DWORD, h : DWORD

		INVOKE FillHeader, w, h
		memCopy eax, p, 54
		INVOKE crt_free, eax

		XOR eax, eax
		RET
	WriteFileHdr ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Creates BMP using data from NoiseArray
	CreateBMP PROC noiseArray : DWORD, params : THREADPARAMS 

		XOR eax, eax
		RET
	CreateBMP ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns new pixel 
	;;
	;;
	;; Returns pointer to new PIXEL in eax
	GetPixelValues PROC x : DWORD, y : DWORD, min : PTR DWORD, max : PTR DWORD, noiseArray : PTR DWORD, params : THREADPARAMS 

		LOACL pixel           :  DWORD
		LOCAL value           :  REAL8
		LOCAL minAfterEffect  :  REAL8
		LOCAL maxAfterEffect  :  REAL8

		INVOKE crt_malloc, 24	; Alloc memory for new pixel
		MOV pixel, eax  		; Init pixel
		; Init value
		; Init minAfterEffect
		; Init maxAfterEffect

		LEA eax, [value]			; Load pointer to value
		LEA ebx, [minAfterEffect]	; Load pointer to minAfterEffect
		LEA ecx, [maxAfterEffect]	; Load pointer to minAfterEffect
		
		Switch params._effect
			Case 1
				INVOKE SinNoise, eax, ebx, ecx, x, y
			Case 2
				INVOKE SqrtNoise, eax, ebx, ecx, x, y
			Case 3
				INVOKE Experimental1, eax, ebx, ecx, x, y
			Case 4
				INVOKE Experimental2, eax, ebx, ecx, x, y
			Case 5
				INVOKE Experimental3, eax, ebx, ecx, x, y
			Default
		Endsw

		; pixel = GetColor(val, minAfterEffect, maxAfterEffect, (*params).color);

		MOV eax, pixel			; Move pointer to pixel to eax for return
		RET
	GetPixelValues ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Returns colored pixel
	GetColor PROC value : REAL8, min : REAL8, max : REAL8, color : PIXEL
	
		RET
	GetColor ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	SinNoise PROC value : PTR DWORD, min : PTR DWORD, max : PTR DWORD, x : DWORD, y : DWORD

		XOR eax, eax
		RET
	SinNoise ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	SqrtNoise PROC value : PTR DWORD, min : PTR DWORD, max : PTR DWORD, x : DWORD, y : DWORD


		XOR eax, eax
		RET
	SqrtNoise ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental1 PROC value : PTR DWORD, min : PTR DWORD, max : PTR DWORD, x : DWORD, y : DWORD
		
		XOR eax, eax
		RET
	Experimental1 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental2 PROC value : PTR DWORD, min : PTR DWORD, max : PTR DWORD, x : DWORD, y : DWORD
	
		XOR eax, eax
		RET
	Experimental2 ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Noise effects
	Experimental3 PROC value : PTR DWORD, min : PTR DWORD, max : PTR DWORD, x : DWORD , y : DWORD
	
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
	;; (b - a)(x - min)
	;; f(x) = ----------------  + a
	;; max - min
	ScaleToChar PROC x:REAL8, min:REAL8, max:REAL8

		
		RET
	ScaleToChar ENDP
CODE ENDS