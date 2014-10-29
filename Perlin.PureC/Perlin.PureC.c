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
	int i;
	/*int randomnumber;
	srand((unsigned int)time(NULL) * params.threadId);
	randomnumber = rand() % 10000;
	printThreadParamInfo(params);
	printf("Random number: %d\n\n", randomnumber);*/

	printf("Generowanie.\n");
	PerlinNoise_2D(params);
	printf("Tworzenie bitmapy.\n");
	CreateBMP2(params.imagePointer, params.width, params.height, params.offset);

	//printf("ThreadId %d ->\tCalculating values using Perlin Noise", params.IdOfThread);
	//PerlinNoise_2D();
	//printf(" - DONE.\n");

	//printf("ThreadId %d ->\tGenerating bitmap", params.IdOfThread);
	//CreateBMP(NoiseArray, outputBitmapFileName);
	//printf(" - DONE.\n");
	//PrintBMPInfo(outputBitmapFileName);

	for (i = 0; i < params.height; i++)
	{
		free(NoiseArrayDynamic[i]);
	}
	free(NoiseArrayDynamic);
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}