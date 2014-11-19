.686
.387
.model small, c
option casemap:none
.xmm

;/////////////////////////
;// Includes
;/////////////////////////
	include DataStructures.asm
	include Helpers.asm
	include PerlinNoise.asm
	include Bitmap.asm

.data
	B		DWORD 1000h		;// Array size
	BMask	DWORD 0FFFh		;// Array size mask

	;// Initialization arrays
	p		           DWORD  ?
	g2		           DWORD  ?
	NoiseArrayDynamic  DWORD  ?

.code

	_Init PROC FAR w:DWORD, h:DWORD	

		MOV eax, w
		ADD eax, h
		XOR eax, eax
		RET
	_Init ENDP

	_Finalize PROC FAR h:DWORD

		MOV eax, h
		XOR eax, eax
		RET
	_Finalize ENDP

	_PerlinNoiseBmp PROC

		XOR eax, eax
		RET
	_PerlinNoiseBmp ENDP

	_PerlinNoiseGif PROC

		XOR eax, eax
		RET
	_PerlinNoiseGif ENDP

END