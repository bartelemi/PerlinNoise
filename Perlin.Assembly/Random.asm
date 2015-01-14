OPTION PROLOGUE:NONE
OPTION EPILOGUE:NONE

;============================================================
; Function: LockRnd
;      Locks sLock variable.
; ARGS: None 
; Output: None 
; Precondition: None
;============================================================
LockRnd PROC USES edx
	
	XOR edx, edx	; edx <- 0
	INC edx			; edx <- 1, value to set lock

	@SpinLockRnd:
		MOV eax, sLock
		TEST eax, eax
		JNZ @SpinLockRnd
		LOCK CMPXCHG [sLock], edx
		TEST eax, eax
		JNZ @SpinLockRnd

	XOR eax, eax
	RET
LockRnd ENDP

;============================================================
; Function: UnlockRnd
;      Unlocks sLock variable.
; ARGS: None 
; Output: None 
; Precondition: None
;============================================================
UnlockRnd PROC
	
	XOR eax, eax
	XCHG eax, [sLock]

	RET
UnlockRnd ENDP

RandInt32 PROC
	
	CALL LockRnd
	MOV eax, RandSeed
	MOV ebx, 41c64e6dh
	MUL ebx
	ADD eax, 3039h
	AND eax, 7ffffffh
	MOV RandSeed, eax
	MOV ebx, eax
	CALL UnlockRnd
	
	MOV eax, ebx
	RET
RandInt32 ENDP

Randomize PROC

	RDTSC
	MOV RandSeed, eax

	RETN
Randomize ENDP

;=========================================================================
; Function: RandReal
;     Generates a random number on [0,1) real interval
; ARGS: None 
; Output: a double precision (REAL8 / QWORD) number. 
;    On function exit, the output is placed in xmm0 low quadword.
; Precondition: One of the initialization functions must have been called.
;=========================================================================    
RandReal PROC
	
    CALL     RandInt32
    CVTSI2SD xmm0, eax
    TEST     eax, eax
    JNS @integer_not_signed
    ADDSD    xmm0, TWOPOW32 ; make sure it's >= 0

	@integer_not_signed:
     MULSD   xmm0, ONEDIV2POW32M1
 
    RET    
RandReal ENDP

OPTION PROLOGUE:PROLOGUEDEF 
OPTION EPILOGUE:EPILOGUEDEF