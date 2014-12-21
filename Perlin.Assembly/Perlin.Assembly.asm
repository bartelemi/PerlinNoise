.686p
.387
.model flat, stdcall
option casemap:none
.xmm

.const
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Perlin Noise arrays consts

		B			equ		1000h		; Array size
		BMask		equ		0FFFh		; Array size mask
										
	;;;;;;;;;;;;;;;;;;;;;;;;;;				
	;; Mersenne twister consts					
										
		N           equ		624			; degree of recurrence: number of 32-bit integers in the  internal state array.
		M           equ		397			; middle word, or the number of parallel sequences, 1 <= m <= n.
		MATRIX_A    equ		09908b0dfH	; constant vector a: coefficients of the rational normal form twist matrix.
		UMASK       equ		080000000H	; most significant w-r bits
		LMASK       equ		07fffffffH	; least significant r bits

.data
	ALIGN 16

	;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initialization arrays
		
		p		        DWORD  0		; Helper array
		g2		        DWORD  0		; Noise generator initialization array
		NoiseArray		DWORD  0		; Array for generated noise values

.data?
	;;;;;;;;;;;;;;;;;;;;;;;;				
	;; Mersenne twister data

	    _state    DD    N     DUP (?) ; internal: random generator state.
		_initf    DD    ?             ; set if the internal state has been initalized.
		_left     DD    ?             ; number of generation left before a new internal state is required.
		_next     DD    ?             ; holds pointer to the next internal state.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Includes
	include \masm32\include\Windows.inc
	include \masm32\include\Kernel32.inc
	include \masm32\include\MSVCRT.inc
	include \masm32\include\Masm32.inc

	includelib \masm32\lib\Kernel32.lib
	includelib \masm32\lib\MSVCRT.lib
	includelib \masm32\lib\Masm32.lib

.code
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;; Include other modules
		include DataStructures.asm
		include Helpers.asm
		include MersenneTwister.asm
		include PerlinNoise.asm
		include Bitmap.asm
		

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Normalizes REAL8 2D vector 
	Normalize PROC vector : DWORD

		MOVAPS xmm0, [vector]	; Move two values of vector to xmm0
		MOVAPS xmm2, xmm0		; Store vector for later use
		MULPD  xmm0, xmm0		; Calculate square of each value
		MOVAPS xmm1, xmm0		; Store vector for calculations
		ADDPD  xmm0, xmm1		; Add squares of vector components
		SQRTPD xmm0, xmm0		; Calculate square root of added components

		DIVPD xmm2, xmm0		; Calculate v[0]/len(v) v[1]/len(v)
		MOVAPS [vector], xmm2

		MOV eax, vector
		RET
	Normalize ENDP
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initializes program arrays
	_Init PROC FAR w:DWORD, h:DWORD	

		LOCAL s     :  DWORD
		
		; Initialize xmm registers
			MOV eax, B
			PINSRD   xmm1, eax, 0
			PINSRD   xmm1, eax, 2
			CVTDQ2PD xmm1, xmm1
			SHL eax, 1
			PINSRD   xmm2, eax, 0
			PINSRD   xmm2, eax, 2
			CVTDQ2PD xmm2, xmm2

		; Initialize random number generator with processor tick count
			INVOKE GetTickCount
			MOV s, eax
			INVOKE init_genenerator, s

		; Allocate memory for arrays
			MOV eax, B
			INC eax
			SHL eax, 3		; eax  <- eax * 2 * sizeof(DWORD)
			MOV s, eax
			INVOKE crt_malloc, s
			MOV p, eax
			
			SHL s, 2
			INVOKE crt_malloc, s
			MOV g2, eax

			MOV eax, w
			MUL h
			SHL eax, 5
			INVOKE crt_malloc, eax
			MOV NoiseArray, eax

		; Initialize arrays for generating Perlin Noise
			MOV edi, OFFSET p
			MOV ecx, s
			SHR ecx, 2
			InitP_First:
				MOV eax, ecx
				STOSD
				DEC ecx

				INVOKE   RandInt32		; Generate random number for g2[ecx][0]
				PINSRD   xmm0, eax, 0	; Store result in xmm0[0-31]
				INVOKE   RandInt32		; Generate random number for g2[ecx][1]
				PINSRD   xmm0, eax, 2	; Store result in xmm0[64-95]			
				CVTDQ2PD xmm0, xmm0		; Convert both results to doubles
				ANDPD    xmm0, xmm2		; Both modulo (B+B)
				SUBPD	 xmm0, xmm1		; Both minus B
				DIVPD	 xmm0, xmm1		; Both divide by B
				
				MOV		 eax, ecx		; Copy current index
				SHL		 eax, 4			; Calculate offset for g2[ecx][0] element
				LEA edx, [g2 + eax]		; Get addres of g2[ecx][0] element
				MOVUPS	 [edx], xmm0	; Copy xmm0 to g2[ecx]

				INVOKE Normalize, edx 
			JNZ InitP_First

		XOR eax, eax
		RET
	_Init ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Generate noisy bitmap with applied effect
	_PerlinNoiseBmp PROC params : THREADPARAMS
		
		INVOKE PerlinNoise2D, params	; Generate noise array with parameters
		INVOKE CreateBMP, params		; Create bitmap from noise array
		XOR eax, eax
		RET
	_PerlinNoiseBmp ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Cleans up memory
	_Finalize PROC FAR

		INVOKE crt_free, p
		INVOKE crt_free, g2
		INVOKE crt_free, NoiseArray

		XOR eax, eax
		RET
	_Finalize ENDP

END