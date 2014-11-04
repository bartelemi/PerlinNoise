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
	//printf("Alokuje pamiec             - %d\n", params.threadId);
	NoiseArrayDynamic = alloc2DArray(params.width, params.height);
	//printf("Skonczylem alokowac pamiec - %d wskaznik: 0x%p\n", params.threadId, NoiseArrayDynamic);

	//printf("Tworzenie szumu            - %d\n", params.threadId);
	PerlinNoise_2D(params);
	//printf("Skonczylem szum            - %d\n", params.threadId);

	//printf("Tworzenie bitmapy          - %d\n", params.threadId);
	CreateBMP2(params);
	//printf("Skonczylem bitmape         - %d\n", params.threadId);

	//printf("Zwalniam pamiec            - %d\n", params.threadId);
	free2DArray(NoiseArrayDynamic, params.height);
	//printf("Skonczylem zwalniac pamiec - %d\n", params.threadId);

	PrintBMPInfo("C:\\Users\\Bartek\\Desktop\\br.bmp");
	printf("\n\n");
	PrintBMPInfo("C:\\Users\\Bartek\\Desktop\\br2.bmp");
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}