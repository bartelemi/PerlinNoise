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

;;;;;;;;;;;
;;;; Own
;;;;;;;;;;;
	include DataStructures.asm
	include Helpers.asm
	include PerlinNoise.asm
	include Bitmap.asm

.data
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initialization arrays
		p		        DWORD  0
		g2		        DWORD  0.0
		NoiseArray		DWORD  0.0
	
	;;;;;;;;;;;;;
	;; IMMEDIATES

		B				DWORD  1000h	; Array size
		BMask			DWORD  0FFFh	; Array size mask

.code
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Normalizes REAL8 2D vector 
	Normalize PROC vector : DWORD

		MOV eax, vector
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
		
		INVOKE PerlinNoise2D, NoiseArray, params	; Generate noise array with parameters
		INVOKE CreateBMP, NoiseArray, params		; Create bitmap from noise array
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