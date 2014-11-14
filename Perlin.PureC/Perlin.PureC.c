/*
	PRAWDOPODOBNIE WSZYSTKIEMU JEST WINNY GENERATOR LICZB LOSOWYCH
	PROPONOWANE ROZWI¥ZANIE: ZAIMPLEMENTOWAÆ MERSENNE TWISTER
	WWW: http://en.wikipedia.org/wiki/Mersenne_twister
*/

#include "stdafx.h"
#include "Helpers.h"
#include "Perlin.PureC.h"

#include <time.h>

PERLINPUREC_API void GeneratePerlinNoiseBitmap(ThreadParameters params)
{
	double **NoiseArrayDynamic;
	srand((unsigned)time(NULL));

	printf("Alokuje pamiec             - %d\n", params.threadId);
	NoiseArrayDynamic = alloc2DArray(params.width, params.height);
	printf("Skonczylem alokowac pamiec - %d\n", params.threadId);

	printf("Tworzenie szumu            - %d\n", params.threadId);
	PerlinNoise_2D(NoiseArrayDynamic, params);
	printf("Skonczylem szum            - %d\n", params.threadId);

	printf("Tworzenie bitmapy          - %d\n", params.threadId);
	CreateBMP2(NoiseArrayDynamic, params);
	printf("Skonczylem bitmape         - %d\n", params.threadId);

	printf("Zwalniam pamiec            - %d\n", params.threadId);
	free2DArray(NoiseArrayDynamic, (size_t)params.height);
	printf("Skonczylem zwalniac pamiec - %d\n", params.threadId);
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}