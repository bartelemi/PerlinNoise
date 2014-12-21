;============================================================
; Function: init_genenerator
;      Initializes state[N] with a seed.
; ARGS: 
;    seed: The seed. Must be a 32-bit integer. 
; Output: None 
; Precondition: None
;============================================================    
init_genenerator PROC USES EDI seed : DWORD
 
	MOV  eax, seed
	MOV  _state, eax            
    LEA  eax, _state
	MOV  edx, 1     
 
	ALIGN 4
@loop_init_genrand:
	MOV  ecx, DWORD PTR [eax] 
	MOV  edi, ecx             
	SHR  edi, 30              
	XOR  edi, ecx             
	IMUL edi, 1812433253        
	ADD  edi, edx             
	MOV  DWORD PTR [eax+4], edi  
	ADD  eax, 4                  
	INC  edx                     
	CMP  eax, OFFSET _state + ((N-1) * sizeof DWORD) 
	JL   @loop_init_genrand
 
	MOV _left, 1
	MOV _initf, 1
 
	RET
init_genenerator ENDP 
 
;============================================================
; Function: next_state
;      Generates the next internal state for the random generator.
; ARGS: None 
; Output: None 
; Precondition: None
;============================================================    
next_state PROC uses ESI
 
	LEA esi, _state
 
	CMP DWORD PTR _initf, 0
	JNE @dont_call_initgenrand
		INVOKE init_genenerator, 5489
 
@dont_call_initgenrand:
	MOV _left, N
	MOV _next, esi
 
	MOV ecx, N-M+1-1 
 
	ALIGN 4
@next_state_loop1:
	MOV edx, DWORD PTR [esi]    
	MOV eax, DWORD PTR [esi+4]  
 
	AND edx, UMASK
	AND eax, LMASK
	OR  edx, eax    
 
	SHR edx, 1            
 
	AND eax, 1  
	NEG eax                
	SBB eax, eax
	AND eax, MATRIX_A
	XOR edx, eax
	XOR edx, DWORD PTR [esi + (M * SIZEOF DWORD)] 
	MOV DWORD PTR [esi], edx 
	ADD esi, 4            
	DEC ecx               
	JNE @next_state_loop1
 
	MOV ecx, M-1        
 
	ALIGN 4
@next_state_loop2:
	MOV edx, DWORD PTR [esi]    
	MOV eax, DWORD PTR [esi+4]    
	AND edx, UMASK
	AND eax, LMASK
	OR  edx, eax            
	SHR edx, 1     
	AND eax, 1        
	NEG eax
	SBB eax, eax
	AND eax, MATRIX_A
	XOR edx, eax
	XOR edx, DWORD PTR [esi + ( (M-N)*SIZEOF DWORD )] ; note: M-N will be negative, so that gives [ESI+(-908)] -> [ESI-908] with standard M and N
	MOV DWORD PTR [esi], edx
	ADD esi, 4    
	DEC ecx
	JNE @next_state_loop2    
 
	MOV edx, DWORD PTR [esi]    
	MOV eax, DWORD PTR _state    
	AND edx, UMASK
	AND eax, LMASK
	OR  edx, eax            
	SHR edx, 1     
	AND eax, 1        
	NEG eax
	SBB eax, eax
	AND eax, MATRIX_A
	XOR edx, eax
	XOR edx, DWORD PTR [esi+( (M-N)*SIZEOF DWORD )] ; see note above
	MOV DWORD PTR [esi], edx    
 
	RET
next_state endp
 
;============================================================
; Function: RandInt32
;      generates a 32-bit random number on [0,0xffffffff] interval.
; ARGS: None 
; Output: an integer, the result is placed in the EAX register. 
; Precondition: One of the initialization functions must have been called.
;============================================================    
RandInt32 PROC
 
	DEC DWORD PTR _left
	JNE @L1_RandInt32
		INVOKE next_state
 
	@L1_RandInt32:
		MOV eax, DWORD PTR _next
		MOV ecx, DWORD PTR [eax]   
		ADD eax, 4
		MOV DWORD PTR _next, eax    
 
		MOV eax, ecx
		SHR eax, 11
		XOR ecx, eax
 
		MOV edx, ecx
		SHL edx, 7
		AND edx, 09d2c5680H
		XOR ecx, edx
 
		MOV eax, ecx
		SHL eax, 15
		AND eax, 0efc60000H    
		XOR ecx, eax
 
		MOV eax, ecx
		SHR eax, 18
		XOR eax, ecx    
 
	RET
RandInt32 endp