CODE SEGMENT
;//
	FillHeader PROC w : DWORD, h : DWORD

		MOV eax, w
		ADD eax, h
		XOR eax, eax
		RET
	FillHeader ENDP

	;//
	FillInfoHdr PROC w : DWORD, h : DWORD
	
		MOV eax, w
		ADD eax, h
		XOR eax, eax
		RET
	FillInfoHdr ENDP

	;//
	WriteFileHdr PROC p:FAR PTR REAL8, w:DWORD, h:DWORD

		MOV eax, w
		ADD eax, h
		XOR eax, eax
		RET
	WriteFileHdr ENDP

	;//
	CreateBMP PROC noiseArray : FAR PTR REAL8, params : THREADPARAMS 

		XOR eax, eax
		RET
	CreateBMP ENDP

	;//
	GetPixel PROC x : DWORD, y : DWORD, min : FAR PTR REAL8, max : FAR PTR REAL8, noiseArray : FAR PTR REAL8, params : THREADPARAMS 

		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	GetPixel ENDP

	;//
	SinNoise PROC value : FAR PTR REAL8, min : FAR PTR REAL8, max : FAR PTR REAL8, x : DWORD, y : DWORD

		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	SinNoise ENDP

	;//
	SqrtNoise PROC value : FAR PTR REAL8, min : FAR PTR REAL8, max : FAR PTR REAL8, x : DWORD, y : DWORD


		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	SqrtNoise ENDP

	;//
	Experimental1 PROC value : FAR PTR REAL8, min : FAR PTR REAL8, max : FAR PTR REAL8, x : DWORD, y : DWORD
		
		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	Experimental1 ENDP

	;//
	Experimental2 PROC value : FAR PTR REAL8, min : FAR PTR REAL8, max : FAR PTR REAL8, x : DWORD, y : DWORD
	
		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	Experimental2 ENDP

	;//	
	Experimental3 PROC value : FAR PTR REAL8, min : FAR PTR REAL8, max : FAR PTR REAL8, x : DWORD , y : DWORD
	
		MOV eax, x
		ADD eax, y
		XOR eax, eax
		RET
	Experimental3 ENDP

	;//
	GetColor PROC value : REAL8, min : REAL8, max : REAL8, color : PIXEL
	
		XOR eax, eax
		RET
	GetColor ENDP

	;//
	GetColorReversed PROC value:REAL8, min:REAL8, max:REAL8, color:PIXEL
	
		XOR eax, eax
		RET
	GetColorReversed ENDP

	;// Scaling x in [min; max] -> [a; b]
	;// Where we need to calculate min and max
	;// and a = 0, b = 255 (unsigned char)
	;//
	;//Formula:
	;//(b - a)(x - min)
	;//f(x) = ----------------  + a
	;//max - min
	ScaleToChar PROC x:REAL8, min:REAL8, max:REAL8

		
		XOR eax, eax
		RET
	ScaleToChar ENDP
CODE ENDS