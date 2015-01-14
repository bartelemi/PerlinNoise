.686
.387
.model flat, stdcall
 option casemap : none
.xmm

Public RandSeed

.const

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Perlin Noise arrays consts
		B			equ		1000h			; Array size
		BMask		equ		0FFFh			; Array size mask

.data
	;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initialization arrays
		p		        DWORD	0			; Helper array
		g2		        DWORD	0			; Noise generator initialization array
		NoiseArray		DWORD	0			; Array for generated noise values
	
	;;;;;;;;;;;;;;;;;;;;;;;;				
	;; Mersenne twister data
		TWOPOW32        REAL8   4294967296.0		; double(2^32)
		ONEDIV2POW32M1  REAL8	03df0000000100000r	; 1.0 / (double(2^32) - 1.0)
		sLock			DWORD	0

.data?
		RandSeed		DWORD	?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; External includes
	include \masm32\include\Kernel32.inc
	include \masm32\include\MSVCRT.inc
	include \masm32\include\Masm32.inc
	
	include \masm32\macros\macros.asm

	includelib \masm32\lib\Kernel32.lib
	includelib \masm32\lib\MSVCRT.lib
	includelib \masm32\lib\Masm32.lib

.code
	;;;;;;;;;;;;;;;;;;;;;;;;
	;; Include other modules
		include DataStructures.asm
		include Helpers.asm
		include Random.asm
		include PerlinNoise.asm
		include Bitmap.asm
	
	ALIGN 16

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Initializes program arrays
	_Init PROC USES ebx ecx edi w : DWORD, h : DWORD

		LOCAL tmp     :  DWORD


		; Initialize random number generator with processor tick count
			XCHG	 rv(GetTickCount), tmp
			CALL	 Randomize

		; Allocate memory for arrays
			MOV		 eax, B		; eax <- B
			INC		 eax		; eax <- B + 1
			SHL		 eax, 3		; eax <- (B + 1) * 2 * sizeof(DWORD)
			MOV		 tmp, eax	; tmp <- eax
			XCHG	 rv(crt_malloc, tmp), p
			
			XCHG	 rv(crt_malloc, tmp), g2
			MOV		 esi, g2	; esi <- address of g2
			MOV		 ebx, tmp	; ebx <- (2B + 2) * sizeof(DWORD)
			SHR		 ebx, 2		; ebx <- 2B + 2 - index count of g2
			@allocRow:
				DEC	   ebx							; Go to next index
				INVOKE crt_calloc, 2, sizeof REAL8	;
				LEA	   ecx, [esi + 4*ebx]			; Load address of next element
				MOV	   [ecx], eax					; Store allocated memory under address stored in tmp
													;
			    TEST	ebx, ebx					; Test if it was last index
				JNZ		@allocRow					; Loop

			MOV		 eax, h							; eax <- width
			MUL		 w								; eax <- width * height
			XCHG	 rv(crt_calloc, eax, sizeof REAL8), NoiseArray
			
		; Initialize xmm registers
			MOV		 eax, B					; eax <- B
			PINSRD   xmm4, eax, 00b			; xmm1[0-31] <- B
			PINSRD   xmm4, eax, 01b			; xmm1[32-63] <- B
			CVTDQ2PD xmm4, xmm4				; Convert B to REAL8
			SHL		 eax, 1					; eax <- 2B
			DEC		 eax					; eax <- 2B - 1
			PINSRD   xmm5, eax, 00b			; xmm2[0-31] <- 2B - 1
			PINSRD   xmm5, eax, 01b			; xmm2[32-63] <- 2B - 1
			CVTDQ2PD xmm5, xmm5 			; Convert (2B - 1) to REAL8

		; Initialize arrays for generating Perlin Noise
			MOV edi, p						; Load address of p
			MOV esi, g2						; Load address of g2

			MOV ecx, B						; Copy value of B to ecx
			@InitArr_L1:					;
				DEC		 ecx				; Go to next index
				MOV		 [edi + 4*ecx], ecx	; p[i] <- i
											;
				CALL RandInt32				; Generate random number for g2[ecx][0]
				PINSRD   xmm0, eax, 00b		; Store result in xmm0[0-31]
				CALL RandInt32				; Generate random number for g2[ecx][1]
				PINSRD   xmm0, eax, 01b		; Store result in xmm0[32-63]					
				CVTDQ2PD xmm0, xmm0			; Convert both results to doubles
				ANDPD    xmm0, xmm5			; Both and (2B-1) (== modulo 2B)
				SUBPD	 xmm0, xmm4			; Both minus B
				DIVPD	 xmm0, xmm4			; Both divide by B
											;
				MOVAPD   xmm2, xmm0			; Store vector for later use
				MULPD    xmm0, xmm0			; Calculate square of each value
				PSHUFD   xmm1, xmm0, 4Eh	; Store vector for calculations
				ADDPD    xmm0, xmm1			; Add squares of vector components
				SQRTPD   xmm0, xmm0			; Calculate square root of added components
											;
				DIVPD    xmm2, xmm0			; Calculate v[0]/len(v) v[1]/len(v)
				MOV		 edx, [esi + 4*ecx]	; Load address of vector
				MOVUPD   [edx], xmm2		; Store result in vector
											;
				TEST	 ecx, ecx			; Test if ecx == 0
				JNZ		 @InitArr_L1		; Loop

			MOV ecx, B						; Copy value of B to ecx
			@InitArr_L2:					;
				DEC	 ecx					; Go to next index
				CALL RandInt32				; Generate random number
				AND  eax, BMask				; eax <- rand() % B
				MOV  edx, [edi + 4*eax]		; edx <- p[rand() % B]
				MOV  [edi + 4*ecx], edx		; p[ecx] <- p[rand() % B]
				MOV  [edi + 4*eax], ecx		; p[rand() % B] <- p[ecx] = ecx
											;
				TEST   ecx, ecx				; Test if ecx == 0
				JNZ	   @InitArr_L2			; Loop
			
			MOV ebx, B						; Copy value of B to ecx
			ADD ebx, 2
			XOR ecx, ecx
			@InitArr_L3:					
				MOV	   edx, B				; edx <- B
				ADD	   edx, ecx				; edx <- (B + ecx)
											;
		  		MOV	   eax, [edi + 4*ecx]	; eax <- p[ecx]
				MOV	   [edi + 4*edx], eax	; p[B+ecx] <- eax
											;
				MOV	   eax, [esi + 4*ecx]	; Load address of vector
				MOVUPD xmm0, [eax]			; xmm0 <- g2[ecx] 
				MOV	   eax, [esi + 4*edx]	; eax <- g2[B+ecx]
				MOVUPD [eax], xmm0			; g2[B+ecx] <- g2[ecx]
											;
				INC	   ecx					; Go to next index
				CMP    ecx, ebx				; Test if ecx == ebx
				JNE	   @InitArr_L3			; Loop

		XOR eax, eax
		RET
	_Init ENDP
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Generate noisy bitmap with applied effect
	_PerlinNoise PROC USES ebx args : PARAMS
		
		INVOKE PerlinNoise2D, args	; Generate noise array with parameters
		INVOKE CreateBMP, args		; Create bitmap from noise array
		
		XOR eax, eax
		RET
	_PerlinNoise ENDP

	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Cleans up memory
	_Finalize PROC USES ebx

 		INVOKE crt_free, NoiseArray
		INVOKE crt_free, g2
		INVOKE crt_free, p
		
		XOR eax, eax
		RET
	_Finalize ENDP

END