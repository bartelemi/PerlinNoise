;;;;;;;;;
;; PROTOS
		
	FillHeader		PROTO w : DWORD, h : DWORD
	WriteFileHdr	PROTO filePtr : DWORD, w : DWORD, h : DWORD
	CreateBMP		PROTO args : PARAMS
	GetColor		PROTO value : REAL8, min : REAL8, max : REAL8, color : DWORD 
	GetPixelValues	PROTO x : DWORD, y : DWORD, min : DWORD, max : DWORD, args : PARAMS 
	SinNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	SqrtNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental1	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental2	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental3	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	ScaleToChar		PROTO x : REAL8, min:REAL8, max:REAL8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns filled BMPFILEHEADER
FillHeader PROC USES ebx w : DWORD, h : DWORD
		
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
WriteFileHdr PROC filePtr : DWORD, w : DWORD, h : DWORD

	INVOKE FillHeader, w, h
	memCopy eax, filePtr, 54
	INVOKE crt_free, eax

	XOR eax, eax
	RET
WriteFileHdr ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Creates BMP using data from NoiseArray
CreateBMP PROC USES ebx ecx edx args : PARAMS 

	LOCAL min		:  REAL8
	LOCAL max		:  REAL8
	LOCAL rowSize   :  DWORD
	LOCAL nPad		:  DWORD
	LOCAL pad		:  DWORD
	LOCAL pointer   :  DWORD
	LOCAL offsetEnd :  DWORD

	; Initialize local variables
			MOV eax, sizeof PIXEL					; Calculate pad size
			MUL args._width							;
			AND eax, 3								;
			MOV ebx, 4								;
			SUB ebx, eax							;
			AND ebx, 3								;
			MOV nPad, ebx							; Store pad size to local var
													;
			INVOKE crt_calloc, nPad, sizeof BYTE	; Allocate memory for row pad
			MOV pad, eax							; Store allocated memory pointer
													;
			MOV eax, [args._imgPtr]					; Load address of pointer to bitmap
			MOV pointer, eax						; Copy pointer to picture array
													;							
			MOV eax, args._offset					; Calculate end of image offset
			ADD eax, args._height					;
			MOV offsetEnd, eax						; Store value in local variable
													;
			MOV eax, sizeof PIXEL					; Calculate size of single row
			MUL args._width									; eax <- width*sizeof(PIXEL)
			ADD eax, nPad							; eax <- width*sizeof(PIXEL) + nPad					
			MOV rowSize, eax						; Store value in local variable

	; Check if current thread has Id==0 and if so create file header
			MOV    eax, args._threadId		
			TEST   eax, eax
			JNZ    @Skip
			INVOKE WriteFileHdr, pointer, args._width, args._height

	@Skip:
	; Get min and max from generated noise array
		MOV    eax, args._width
		MUL    args._wholeHeight
		LEA    ebx, [min]
		LEA    ecx, [max]
		INVOKE MaxMin, NoiseArray, eax, ebx, ecx

	; Calculate offset to image for current thread
		MOV eax, sizeof PIXEL 
		MUL args._width
		ADD eax, nPad
		MUL args._offset
		ADD eax, 54
		ADD pointer, eax							
			
		MOV ebx, args._offset
		@ColumnLoop:
			XOR ecx, ecx	; ecx holds current position in noise array
			XOR edx, edx	; edx holds current position in image array
			@RowLoop:
				LEA     edi, [min]
				LEA     esi, [max]
				INVOKE  GetPixelValues, ebx, ecx, edi, esi, args
				MOV     edi, pointer
				ADD		edi, edx
				memCopy eax, edi, sizeof PIXEL
			INC ecx
			ADD edx, sizeof PIXEL
			CMP ecx, args._width
			JNE @RowLoop

			memCopy pad, pointer, nPad
			MOV     eax, pointer
			ADD     eax, rowSize
			MOV     pointer, eax

		INC ebx
		CMP ebx, offsetEnd
		JNE @ColumnLoop	

	XOR eax, eax
	RET
CreateBMP ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns new pixel 
;;
;;
;; Returns pointer to new PIXEL in eax
GetPixelValues PROC USES ebx ecx edx x : DWORD, y : DWORD, min : DWORD, max : DWORD, args : PARAMS 

	LOCAL _x			  :  DWORD
	LOCAL _y			  :  DWORD
	LOCAL pmin			  :  DWORD
	LOCAL pmax			  :  DWORD
	LOCAL value           :  REAL8
	LOCAL minAfterEffect  :  REAL8
	LOCAL maxAfterEffect  :  REAL8

	MOV eax, x							; Copy value of x
	MOV _x, eax							; Store value of x in local variable
	MOV eax, y							; Copy value of y
	MOV _y, eax							; Store value of y in local variable
	MOV eax, min						; Copy value of min
	MOV pmin, eax						; Store value of min in local variable
	MOV eax, max						; Copy value of max
	MOV pmax, eax						; Store value of max in local variable
										;
	MOV eax, x							; eax <- x index
	MUL args._width						; eax <- x * width
	ADD eax, y							; eax <- x * width + y
	SHL eax, 3							; eax <- (x * width + y) * (sizeof REAL8) - current array offset
	MOV esi, NoiseArray					; esi <- base address of NoiseArray
	MOVSD xmm0, REAL8 PTR [esi + eax]	; Init value
	MOVSD value, xmm0					; Store value in local variable
										;
	MOV eax, pmin						; eax <- address of min
	MOVSD xmm0, REAL8 PTR [eax]			; Init minAfterEffect
	MOVSD minAfterEffect, xmm0			; Store value in local variable
										;
	MOV eax, pmax						; eax <- address of max										
	MOVSD xmm0, REAL8 PTR [eax]			; Init maxAfterEffect
	MOVSD maxAfterEffect, xmm0			; Store value in local variable
										;
	LEA eax, [value]					; Load pointer to value
	LEA ebx, [minAfterEffect]			; Load pointer to minAfterEffect
	LEA ecx, [maxAfterEffect]			; Load pointer to minAfterEffect
										;	
	MOV edx, args._effect
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

	LEA ebx, args._color
	INVOKE GetColor, value, minAfterEffect, maxAfterEffect, ebx

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
ScaleToChar PROC x : REAL8, min : REAL8, max : REAL8

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
;; Returns colored pixel in eax
GetColor PROC USES ebx value : REAL8, min : REAL8, max : REAL8, color : DWORD
	
	XCHG rv(crt_malloc, 24), edi		; Alloc memory for new pixel
	INVOKE ScaleToChar, value, min, max	; Scale given value
	TEST eax, eax						; Test if returned value is equal to zero
	JNE CalcColor						; If it's not, then continue
		INC eax							; Else eax <- 1

	CalcColor:
		SHL eax, 8						; eax <- value * 256
		MOV ebx, eax					; ebx <- value * 256 (for later use)
		MOV esi, [color]				; esi <- address of color
		XOR ecx, ecx					; ecx <- 0
										;
		MOV cl, BYTE PTR [esi + 2]		; cl <- blue value 
		INC ecx							;
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							;
		MOV BYTE PTR [edi + 2], al		;
										;
		MOV eax, ebx					;
		MOV cl, BYTE PTR [esi + 1]		; cl <- green value
		INC ecx							;
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							;
		MOV BYTE PTR [edi + 1], al		;
										;
		MOV eax, ebx					;
		MOV cl, BYTE PTR [esi]			; cl <- red value
		INC ecx							;
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							;
		MOV BYTE PTR [edi], al			;
		
	MOV eax, edi
	RET
GetColor ENDP