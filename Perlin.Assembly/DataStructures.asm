CODE SEGMENT

	;// Pixel structure
	PIXEL STRUCT
		_blue	BYTE ?
		_green	BYTE ?
		_red	BYTE ?
	PIXEL ENDS

	;// Thread parameters structure
	THREADPARAMS STRUCT
		_imgPtr			DWORD  ?
		_offset			DWORD  ?
		_width			DWORD  ? 
		_wholeHeight	DWORD  ?
		_height			DWORD  ?
		_color			PIXEL  {? ? ?}
		_effect			DWORD  ?
		_octaves		DWORD  ?
		_persistence	REAL8  ?
		_threadId		DWORD  ?
		_threadsCount	DWORD  ?
	THREADPARAMS ENDS

	;// Algin data structures to 2 bytes since FILEHEADER is 14 bytes 
	ALIGN 2

	;// File information
	FILEHEADER STRUCT
		_fileType		WORD   ?
		_fileSize		DWORD  ?
		_reserved1		WORD   ?
		_reserved2		WORD   ?
		_offset			DWORD  ?
	FILEHEADER ENDS


	;// Bitmap information
	FILEINFOHEADER STRUCT
		_bmpSize			DWORD  ?
		_bmpWidth			DWORD  ?
		_bmpHeight			DWORD  ?
		_bmpPlanes			WORD   ?
		_bmpBitCount		WORD   ?
		_bmpCompression		DWORD  ?
		_bmpSizeImage		DWORD  ?
		_bmpXPelsPerMeter	DWORD  ?
		_bmpYPelsPerMeter	DWORD  ?			
		_bmpColorUsed		DWORD  ?					
		_bmpColorImportant	DWORD  ?
	FILEINFOHEADER ENDS

	;// Reset alignment
	ALIGN 4

CODE ENDS