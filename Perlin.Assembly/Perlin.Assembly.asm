.686
.387
.model flat, stdcall
option casemap : none
.xmm

.const
	ALIGN 16

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
;; External includes
	include \masm32\include\Windows.inc
	include \masm32\include\Kernel32.inc
	include \masm32\include\MSVCRT.inc
	include \masm32\include\Masm32.inc
	
	include \masm32\macros\macros.asm

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

		MOV	   eax, vector
		MOVUPD xmm0, [eax]	; Move two values of vector to xmm0
		MOVAPD xmm2, xmm0	; Store vector for later use
		MULPD  xmm0, xmm0	; Calculate square of each value
		MOVAPD xmm1, xmm0	; Store vector for calculations
		ADDPD  xmm0, xmm1	; Add squares of vector components
		SQRTPD xmm0, xmm0	; Calculate square root of added components
							;
		DIVPD xmm2, xmm0	; Calculate v[0]/len(v) v[1]/len(v)
		MOVUPD [eax], xmm2	; Store result in vector

		XOR eax, eax
		RET
	Normalize ENDP
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initializes program arrays
	_Init PROC USES ebx ecx edx edi w : DWORD, h : DWORD

		LOCAL tmp     :  DWORD

		; Initialize random number generator with processor tick count
			XCHG	 rv(GetTickCount), tmp
			INVOKE	 init_genenerator, tmp

		; Allocate memory for arrays
			MOV		 eax, B		; eax <- B
			INC		 eax		; eax <- B + 1
			SHL		 eax, 3		; eax <- (B + 1) * 2 * sizeof(DWORD)
			MOV		 tmp, eax	; tmp <- eax
			XCHG	 rv(crt_malloc, tmp), p
			
			
			XCHG	 rv(crt_malloc, tmp), g2
			MOV		 esi, g2	; ebx <- address of g2
			MOV		 ebx, tmp	; edi <- (2B + 2) * sizeof(DWORD)
			SHR		 ebx, 2		; edi <- 2B + 2 - index count of g2
			@allocRow:
				DEC	   ebx							; Go to next index
				INVOKE crt_calloc, 2, sizeof REAL8	;
				LEA	   ecx, [esi + 4*ebx]			; Load address of next element
				MOV	   [ecx], eax					; Store allocated memory under address stored in tmp
													;
			    TEST	ebx, ebx					; Test if it was last index
				JNZ		@allocRow					; Loop

			MOV		 eax, w		; eax <- width
			MUL		 h			; eax <- width * height
			XCHG	 rv(crt_calloc, eax, sizeof REAL8), NoiseArray
			
		; Initialize xmm registers
			MOV		 eax, B
			PINSRD   xmm1, eax, 00b
			PINSRD   xmm1, eax, 01b
			CVTDQ2PD xmm1, xmm1
			SHL		 eax, 1
			PINSRD   xmm2, eax, 00b
			PINSRD   xmm2, eax, 01b
			CVTDQ2PD xmm2, xmm2

		; Initialize arrays for generating Perlin Noise
			MOV edi, p						; Load address of p
			MOV esi, g2						; Load address of g2
			
			MOV ecx, B						; Copy value of B to ecx
			InitArr_First:					;
				DEC		 ecx				; Go to next index
				MOV		 [edi + 4*ecx], ecx	; p[i] <- i
											;
				INVOKE   RandInt32			; Generate random number for g2[ecx][0]
				PINSRD   xmm0, eax, 00b		; Store result in xmm0[0-31]
				INVOKE   RandInt32			; Generate random number for g2[ecx][1]
				PINSRD   xmm0, eax, 01b		; Store result in xmm0[64-95]					
				CVTDQ2PD xmm0, xmm0			; Convert both results to doubles
				ANDPD    xmm0, xmm2			; Both modulo (B+B)
				SUBPD	 xmm0, xmm1			; Both minus B
				DIVPD	 xmm0, xmm1			; Both divide by B
											;
				MOV		 edx, [esi + 4*ecx]	; Load address of vector
				MOVUPD	 [edx], xmm0		; g2[ecx] <- xmm0 
				MOV		 tmp, edx			; Store address in variable
				INVOKE	 Normalize, tmp		; Normalize vector
											;
				TEST	 ecx, ecx			; Test if ecx == 0
				JNZ		 InitArr_First		; Loop

			MOV ecx, B						; Copy value of B to ecx
			InitArr_Second:					;
				DEC	   ecx					; Go to next index
				INVOKE RandInt32			; Generate random number
				AND    eax, BMask			; eax <- rand() % B
				MOV    edx, [edi + 4*eax]	; edx <- p[rand() % B]
				MOV    [edi + 4*ecx], edx	; p[ecx] <- p[rand() % B]
				MOV    [edi + 4*eax], ecx	; p[rand() % B] <- p[ecx]
											;
				TEST   ecx, ecx				; Test if ecx == 0
				JNZ	   InitArr_Second		; Loop
			
			MOV ecx, B						; Copy value of B to ecx
			ADD ecx, 2						; Increase ecx by 2
			InitArr_Third:					;
				DEC	   ecx					; Go to next index
				MOV	   ebx, B				; ebx <- B
				ADD	   ebx, ecx				; ebx <- (B + ecx)
											;
		  		MOV	   eax, [edi + 4*ecx]	; eax <- p[ecx]
				MOV	   [edi + 4*ebx], eax	; p[B+ecx] <- eax
											;
				MOV	   eax, [esi + 4*ecx]	; Load address of vector
				MOVUPD xmm0, [eax]			; xmm0 <- g2[ecx] 
				MOV	   eax, [esi + 4*ebx]	; eax <- g2[B+ecx]
				MOVUPD [eax], xmm0			; g2[B+ecx] <- g2[ecx]
											;
				TEST   ecx, ecx				; Test if ecx == 0
				JNZ	   InitArr_Third		; Loop

		XOR eax, eax
		RET
	_Init ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Generate noisy bitmap with applied effect
	_PerlinNoiseBmp PROC USES ebx args : PARAMS
		
		INVOKE PerlinNoise2D, args	; Generate noise array with parameters
		INVOKE CreateBMP, args		; Create bitmap from noise array
		
		XOR eax, eax
		RET
	_PerlinNoiseBmp ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Cleans up memory
	_Finalize PROC USES ebx

		INVOKE crt_free, p
		INVOKE crt_free, g2
		INVOKE crt_free, NoiseArray

		XOR eax, eax
		RET
	_Finalize ENDP

END