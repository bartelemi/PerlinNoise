.686p
.387
.model flat, stdcall
option casemap:none
.xmm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Includes
;;;;;;;;;;;
;;;; Libs
;;;;;;;;;;;
	include \masm32\include\Windows.inc

	include \masm32\include\Kernel32.inc
	include \masm32\include\MSVCRT.inc
	include \masm32\include\Masm32.inc

	includelib \masm32\lib\Kernel32.lib
	includelib \masm32\lib\MSVCRT.lib
	includelib \masm32\lib\Masm32.lib

	include \masm32\macros\macros.asm

;;;;;;;;;;;
;;;; Own
;;;;;;;;;;;
	include DataStructures.asm
	include Helpers.asm
	include PerlinNoise.asm
	include Bitmap.asm

.data
	B		DWORD 1000h		;// Array size
	BMask	DWORD 0FFFh		;// Array size mask

	;// Initialization arrays
	p		           DWORD  0
	g2		           REAL8  0.0
	NoiseArray		   REAL8  0.0

.code

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Normalizes REAL8 2D vector 
	Normalize PROC vector : DWORD

		XOR eax, eax
		RET
	Normalize ENDP
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initializes program arrays
	_Init PROC FAR w:DWORD, h:DWORD	

		mov eax, w
		mov eax, h
		XOR eax, eax
		RET
	_Init ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Generate noisy bitmap with applied effect
	_PerlinNoiseBmp PROC params : THREADPARAMS
		
		INVOKE PerlinNoise2D, NoiseArray, params
		INVOKE CreateBMP, NoiseArray, params
		XOR eax, eax
		RET
	_PerlinNoiseBmp ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Generate noisy GIF - not implemented
	_PerlinNoiseGif PROC

		XOR eax, eax
		RET
	_PerlinNoiseGif ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Clean up memory
	_Finalize PROC FAR h:DWORD

	
		mov eax, h
		XOR eax, eax
		RET
	_Finalize ENDP

END