CODE SEGMENT

	;// Initializes noise array with noise values, 
	;// according to params (octaves, persistence)
	PerlinNoise2D PROC noise : DWORD, params : THREADPARAMS

		XOR eax, eax
		RET
	PerlinNoise2D ENDP

	;// Returns noise value for point (x, y)
	Noise PROC FAR x : REAL8, y : REAL8

		XOR eax, eax
		RET
	Noise ENDP

CODE ENDS