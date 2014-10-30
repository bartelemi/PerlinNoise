/*
	PRAWDOPODOBNIE WSZYSTKIEMU JEST WINNY GENERATOR LICZB LOSOWYCH
	PROPONOWANE ROZWI¥ZANIE: ZAIMPLEMENTOWAÆ MERSENNE TWISTER
	WWW: http://en.wikipedia.org/wiki/Mersenne_twister
*/

#include "stdafx.h"
#include "Perlin.PureC.h"
#include "Helpers.h"
PERLINPUREC_API void GeneratePerlinNoiseBitmap(ThreadParameters params)
{	
	NoiseArrayDynamic = alloc2DArray(params.width, params.height);

	printf("Generowanie id: %d.\n", params.threadId);
	PerlinNoise_2D(params);
	printf("Tworzenie bitmapy.\n");
	CreateBMP2(params.imagePointer, params.width, params.height, params.offset);

	free2DArray(NoiseArrayDynamic, params.width, params.height);
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}