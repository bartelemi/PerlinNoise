CODE SEGMENT
;//////////////////////////////
;// MATHEMATICAL FUNCTIONS
;//////////////////////////////
	;// Returns value of (3x^2 - 2x^3) for x = t
	EaseCurve PROC FAR x : REAL8
		
		;//t = ((t) * (t) * (3.0 - (2.0 * (t))))

		XOR eax, eax
		RET
	EaseCurve ENDP

	;// Precise linear interpolation
	LineraInterpolation PROC FAR v0 : REAL8, v1 : REAL8, t : REAL8
		
		;// (v0, v1, t) => ((v0) + (t) * ((v1) - (v0)))

		XOR eax, eax
		RET
	LineraInterpolation ENDP

	;//Calculates square root of number
	Sqrt PROC FAR x : DWORD

		XOR eax, eax
		RET
	Sqrt ENDP

	;// Calculates base^exponent
	Power PROC FAR base : REAL8, exponent : DWORD

		XOR eax, eax
		RET
	Power ENDP

;//////////////////////////////
;// ARRAY FUNCTIONS
;//////////////////////////////
	;// Allocs 2-dimensional array and initializes it with 0's (calloc)
	Alloc2DArray PROC FAR w : DWORD, h : DWORD

		XOR eax, eax
		RET
	Alloc2DArray ENDP

	;// Frees 2-dimensional array
	Free2DArray PROC FAR pointer : FAR PTR REAL8, h : DWORD
	
		XOR eax, eax
		RET
	Free2DArray ENDP

	;// Finds min and max value in array2D
	MaxMinFrom2DArray PROC FAR arr : FAR PTR REAL8, w : DWORD, h : DWORD, min : FAR PTR REAL8, max : FAR PTR REAL8

		XOR eax, eax
		RET
	MaxMinFrom2DArray ENDP
CODE ENDS