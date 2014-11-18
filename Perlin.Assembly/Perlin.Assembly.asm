.686
.387
.model flat, c
.xmm
.data
.code

FillHeader PROTO NEAR C, width:DWORD, height:DWORD
FillInfoHeader PROTO NEAR C, width:DWORD, height:DWORD


_Init PROC
XOR eax, eax
RET
_Init ENDP

_Finalize PROC
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

;////////////////////////////////////////////////////////
;//		BITMAP
;////////////////////////////////////////////////////////

;//
FillHeader PROC NEAR C, width:DWORD, height:DWORD
	
	XOR eax, eax
	RET
FillHeader ENDP

;//
FillInfoHeader PROC NEAR C, width:DWORD, height:DWORD

XOR eax, eax
RET
FillInfoHeader ENDP

;//
WriteFileHeader PROC USES pointer : FDBLPTR, width : DWORD, height : DWORD

XOR eax, eax
RET
WriteFileHeader ENDP

;//
;// CreateBMP PROC USES noiseArray : DOUBLE, params : ThreadParameters

;//	XOR eax, eax
;//	RET
;// CreateBMP ENDP

;//
;//GetPixel PROC USES x:DWORD, y:DWORD, min:FDBLPTR, max:FDBLPTR, noiseArray:FDBLPTR, params:*ThreadParameters 

;//	XOR eax, eax
;//	RET
;//GetPixel ENDP

;//
;//SinNoise PROC USES value:FDBLPTR, min:FDBLPTR, max:FDBLPTR, x:DWORD , y:DWORD

;//	XOR eax, eax
;//	RET
;//SinNoise ENDP

;//
;//SqrtNoise PROC USES value:FDBLPTR, min:FDBLPTR, max:FDBLPTR, x:DWORD , y:DWORD

;//	XOR eax, eax
;//	RET
;//SqrtNoise ENDP

;//
;//Experimental1 PROC USES value:FDBLPTR, min:FDBLPTR, max:FDBLPTR, x:DWORD , y:DWORD
;//	
;//	XOR eax, eax
;//	RET
;//Experimental1 ENDP

;//
;//Experimental2 PROC USES value:FDBLPTR, min:FDBLPTR, max:FDBLPTR, x:DWORD , y:DWORD
;//	
;//	XOR eax, eax
;//	RET
;//Experimental2 ENDP

;//	
;//Experimental3 PROC USES value:FDBLPTR, min:FDBLPTR, max:FDBLPTR, x:DWORD , y:DWORD
;//
;//	XOR eax, eax
;//	RET
;//Experimental3 ENDP

;//
;//GetColor PROC USES value:DOUBLE, min:DOUBLE, max:DOUBLE, color:Pixel
;//
;//	XOR eax, eax
;//	RET
;//GetColor ENDP

;//
;// GetColorReversed PROC USES value : DOUBLE, min : DOUBLE, max : DOUBLE, color : Pixel

;// XOR eax, eax
;//	RET
;// GetColorReversed ENDP

;//
;// Scaling x ∈[min; max] ->[a; b]
;// Where we need to calculate min and max
;// and a = 0, b = 255 (unsigned char)
;//
;//Formula:
;//(b - a)(x - min)
;//f(x) = ----------------  + a
;//max - min
;//
ScaleToChar PROC USES x : DOUBLE, min : DOUBLE, max : DOUBLE

XOR eax, eax
RET
ScaleToChar ENDP


END
