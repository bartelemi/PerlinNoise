/*
	PRAWDOPODOBNIE WSZYSTKIEMU JEST WINNY GENERATOR LICZB LOSOWYCH
	PROPONOWANE ROZWI¥ZANIE: ZAIMPLEMENTOWAÆ MERSENNE TWISTER
	WWW: http://en.wikipedia.org/wiki/Mersenne_twister
*/

#include "stdafx.h"
#include "Perlin.PureC.h"

PERLINPUREC_API void GeneratePerlinNoiseBitmap(ThreadParameters params)
{	
	srand((unsigned int)time(NULL) * params.IdOfThread);
	
	printf("ThreadId %d ->\tCalculating values using Perlin Noise", params.IdOfThread);
	//PerlinNoise_2D();
	printf(" - DONE.\n");

	printf("ThreadId %d ->\tGenerating bitmap", params.IdOfThread);
	//CreateBMP(NoiseArray, outputBitmapFileName);
	printf(" - DONE.\n");
	//PrintBMPInfo(outputBitmapFileName);
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}