;;;;;;;;;;;;;	
;; STRUCTURES

	;; Pixel structure
	PIXEL STRUCT
		_blue		BYTE  ?
		_green		BYTE  ?
		_red		BYTE  ?
	PIXEL ENDS

	;; Thread parameters structure
	PARAMS STRUCT
		_imgPtr			DWORD  ?
		_offset			DWORD  ?
		_width			DWORD  ?
		_wholeHeight	DWORD  ? 
		_height			DWORD  ?
		_color			PIXEL  {? ? ?}
		ALIGN 4
		_effect			DWORD  ?
		_octaves		DWORD  ?
		_persistence	REAL8  ?
		_threadId		DWORD  ?
		_threadsCount	DWORD  ?
	PARAMS ENDS

	; Reset alignment
	ALIGN 8