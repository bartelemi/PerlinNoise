;;;;;;;;;
;; PROTOS
		
	WriteFileHeader	PROTO filePtr : DWORD, w : DWORD, h : DWORD
	CreateBMP		PROTO args : PARAMS
	GetColor		PROTO value : REAL8, min : REAL8, max : REAL8, color : DWORD 
	GetPixelValues	PROTO x : DWORD, y : DWORD, min : DWORD, max : DWORD, args : PARAMS 
	SinNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	SqrtNoise		PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental1	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental2	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	Experimental3	PROTO value : DWORD, min : DWORD, max : DWORD, x : DWORD, y : DWORD
	ScaleToChar		PROTO value : REAL8, min : REAL8, max : REAL8


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Creates BMPFILEHEADER and saves to file pointer
WriteFileHeader PROC USES ebx filePtr : DWORD, w : DWORD, h : DWORD

	; Compute file size in bytes
		MOV  eax, w	    ; eax <- width
		MOV  ecx, 3		; ecx <- 3
		MUL  ecx		; eax <- width * 3
		MOV  edx, eax	; Store in edx
		AND  eax, ecx   ; sizeof(BMPFILEHEADER)
		INC  ecx		; +(height * (width * 3
		SUB  ecx, eax	; +((4 - ((width * 3) & 3)) & 3)))
		DEC  ecx		;
		AND  ebx, ecx	;
		ADD  edx, ebx	;
		IMUL edx, h     ; 
		ADD  edx, 54	; sizeof(BMPFILEHEADER)

	; Allocate memory for header
		INVOKE crt_malloc, 54	

	; Fill bitmap file structure
		MOV WORD PTR[eax + 0], 4D42h		; Load signature 'B''M'
		MOV DWORD PTR[eax + 2], edx			; File size
		MOV DWORD PTR[eax + 6], 0			; Reserved 0 and reserved 1
		MOV DWORD PTR[eax + 10], 54			; Offset
		MOV DWORD PTR[eax + 14], 40			; BMP size
		MOV edx, w							; edx <- width
		MOV DWORD PTR[eax + 18], edx		; BMP width
		MOV edx, h							; edx <- height
		MOV DWORD PTR[eax + 22], edx		; BMP height
		MOV DWORD PTR[eax + 26], 180001h	; Planes and bit count
		MOV DWORD PTR[eax + 30], 0			; Compression
		MOV DWORD PTR[eax + 34], 0			; Image size
		MOV DWORD PTR[eax + 38], 0EC4h		; X-axis DPI
		MOV DWORD PTR[eax + 42], 0EC4h		; Y-axis DPI
		MOV DWORD PTR[eax + 46], 0			; Colors used
		MOV DWORD PTR[eax + 50], 0			; Important colors
	
	; Copy header to file and free memory
		memCopy eax, filePtr, 54
		INVOKE crt_free, eax

	XOR eax, eax
	RET
WriteFileHeader ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Creates BMP using data from NoiseArray
CreateBMP PROC USES ebx ecx edx args : PARAMS 

	LOCAL min		:  REAL8
	LOCAL max		:  REAL8
	LOCAL pad		:  DWORD
	LOCAL nPad		:  DWORD
	LOCAL pointer   :  DWORD
	LOCAL offsetEnd :  DWORD

	; Initialize local variables
	 ; Calculate pad size
		MOV eax, sizeof PIXEL					; eax <- sizeof(PIXEL)
		MUL args._width							; eax <- width * sizeof(PIXEL)
		AND eax, 3								; eax <- (width * sizeof(PIXEL)) & 3
		MOV ebx, 4								; ebx <- 4
		SUB ebx, eax							; ebx <- 4 - eax
		AND ebx, 3								; ebx <- (4 - eax) & 3
		MOV nPad, ebx							; Store pad size to local var
												;
		INVOKE crt_calloc, nPad, sizeof BYTE	; Allocate memory for row padding
		MOV pad, eax							; Store allocated memory pointer
												;							
		MOV eax, args._offset					; Calculate end of image offset
		ADD eax, args._height					; eax <- offset + current height
		MOV offsetEnd, eax						; Store value in local variable

	 ; Calculate offset to image for current thread
		MUL args._offset
		ADD eax, 54
		ADD eax, args._imgPtr
		MOV pointer, eax

	; Get min and max from generated noise array
		MOV    eax, args._width
		MUL    args._wholeHeight
		LEA    ebx, [min]
		LEA    ecx, [max]
		INVOKE MaxMin, NoiseArray, eax, ebx, ecx
	
	; Check if current thread has Id==0 and if so create file header
		MOV    eax, args._threadId		
		TEST   eax, eax
		JNZ    @Skip
		INVOKE WriteFileHeader, args._imgPtr, args._width, args._wholeHeight

		@Skip:	

		MOV edx, pointer
		MOV ebx, args._offset	; ebx stores current index of column loop
		@ColumnLoop:

			XOR ecx, ecx			; ecx holds current position in noise array
			@RowLoop:
				LEA     edi, [min]			; edi <- pointer to min
				LEA     esi, [max]			; esi <- pointer to max
				INVOKE  GetPixelValues, ebx, ecx, edi, esi, args
				memCopy eax, edx, sizeof PIXEL

			ADD edx, sizeof PIXEL
			INC ecx
			CMP ecx, args._width
			JNE @RowLoop

			memCopy pad, edx, nPad
		
		ADD edx, nPad
		INC ebx
		CMP ebx, offsetEnd
		JNE @ColumnLoop	

	INVOKE crt_free, pad
	XOR eax, eax
	RET
CreateBMP ENDP

ALIGN 16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns new pixel 
;;
;;
;; Returns pointer to new PIXEL in eax
GetPixelValues PROC USES ebx ecx edx x : DWORD, y : DWORD, min : DWORD, max : DWORD, args : PARAMS 

	LOCAL pmin			  :  DWORD
	LOCAL pmax			  :  DWORD
	LOCAL value           :  REAL8
	LOCAL minAfterEffect  :  REAL8
	LOCAL maxAfterEffect  :  REAL8


	MOV eax, min						; Copy value of min
	MOV pmin, eax						; Store value of min in local variable
	MOV eax, max						; Copy value of max
	MOV pmax, eax						; Store value of max in local variable
										;
	MOV eax, x							; eax <- x index
	MUL args._width						; eax <- x * width
	ADD eax, y							; eax <- x * width + y
	MOV esi, NoiseArray					; esi <- base address of NoiseArray
	MOVSD xmm0, REAL8 PTR [esi + 8*eax]	; Init value
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

	LEA ebx, [args._color]
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

	XOR      eax, eax					; eax  <- 0
	CVTSI2SD xmm0, eax					; xmm0 <- 0.0
	MOV eax, value						; eax <- pointer to value
	MOVSD    xmm2, REAL8 PTR [eax]		; xmm2 <- value
	MOVSD	 xmm3, xmm2					; xmm3 <- value
	CMPSD    xmm0, xmm3, 010b			
	PEXTRD   eax, xmm1, 00B				; Extract low dword of result to eax
	NOT      eax						; Reverse eax
	TEST     eax, eax					; Test eax for 0
	JZ @Positive
		SUBSD xmm2, xmm3
		SUBSD xmm2, xmm3

	@Positive:
	 MOV eax, min
	 MOVSD xmm0, REAL8 PTR [eax]
	 MOV eax, max
	 MOVSD xmm1, REAL8 PTR [eax]
	 MULSD xmm2, xmm1
	 SQRTSD xmm2, xmm2
	 MOV eax, value
	 MOVSD REAL8 PTR [eax], xmm2

	 MOV eax, max
	 MULSD xmm1, xmm1
	 MOVSD REAL8 PTR [eax], xmm1

	 MOV eax, min
	 SUBSD xmm1, xmm1
	 MOVSD REAL8 PTR [eax], xmm1

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
ScaleToChar PROC value : REAL8, min : REAL8, max : REAL8

	MOVLPD   xmm0, REAL8 PTR [value]; Store x to lower quadword of xmm0
	MOVHPD   xmm0, REAL8 PTR [max]	; Store max to upper quadword of xmm0
	MOVDDUP  xmm1, REAL8 PTR [min]	; Store min to lower and upper quadword of xmm1
	SUBPD    xmm0, xmm1				; xmm0[63-0] <- (x-min);  xmm0[127-64] <- (max-min) 
	MOVHLPS  xmm1, xmm0				; xmm1[63-0] <- (max-min)
	DIVSD	 xmm0, xmm1				; xmm0[63-0] <- (x-min) / (max-min)
	MOV      eax, 255				; eax		 <- 255
	CVTSI2SD xmm1, eax				; xmm1[63-0] <- 255.0
	MULSD    xmm0, xmm1				; xmm0[63-0] <- 255.0 * (x-min) / (max-min)
	CVTSD2SI eax, xmm0				; eax		 <- (int)(255.0 * (x-min) / (max-min))
	
	RET
ScaleToChar ENDP

ALIGN 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Returns colored pixel in eax
GetColor PROC USES ebx value : REAL8, min : REAL8, max : REAL8, color : DWORD
	
	XCHG   rv(crt_malloc, 24), edi		; Alloc memory for new pixel
	INVOKE ScaleToChar, value, min, max	; Scale given value
	TEST   eax, eax						; Test if returned value is equal to zero
	JNZ @CalcColor						; If it's not, then continue
		INC eax							; Else eax <- 1

	@CalcColor:
		SHL eax, 8						; eax <- value * 256
		MOV ebx, eax					; ebx <- value * 256 (for later use)
		MOV esi, [color]				; esi <- address of color
		XOR ecx, ecx					; ecx <- 0
										;
		MOV cl, BYTE PTR [esi + 2]		; cl <- blue value 
		INC ecx							; ecx <- blue value + 1
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							; 
		MOV BYTE PTR [edi + 2], al		;
										;
		MOV eax, ebx					; eax <- value * 256
		MOV cl, BYTE PTR [esi + 1]		; cl <- green value
		INC ecx							; ecx <- green value + 1
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							;
		MOV BYTE PTR [edi + 1], al		;
										;
		MOV eax, ebx					; eax <- value * 256
		MOV cl, BYTE PTR [esi]			; cl <- red value
		INC ecx							; ecx <- red value + 1
		XOR edx, edx					; edx <- 0 before div
		DIV ecx							;
		MOV BYTE PTR [edi], al			;
		
	MOV eax, edi
	RET
GetColor ENDP