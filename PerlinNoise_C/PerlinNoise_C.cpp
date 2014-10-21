// PerlinNoise_C.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "PerlinNoise_C.h"

// This is an example of an exported variable
PERLINNOISE_C_API int nPerlinNoise_C = 0;

// This is an example of an exported function.
PERLINNOISE_C_API int fnPerlinNoise_C(void)
{
	return 42;
}
