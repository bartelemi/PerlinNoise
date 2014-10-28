/*
	  PRAWDOPODOBNIE WSZYSTKIEMU JEST WINNY GENERATOR LICZB LOSOWYCH
	  PROPONOWANE ROZWI¥ZANIE: ZAIMPLEMENTOWAÆ MERSENNE TWISTER
	  WWW: http://en.wikipedia.org/wiki/Mersenne_twister
*/

#include "stdafx.h"

#include <time.h>

/*********************************************
				MAIN PROGRAM
**********************************************/
int main(char* argv[], __int32 argc)
{
	printf("*** Perlin Noise -- 2D textures ***\n");
	printf("*******  Bartlomiej Szostek *******\n\n");

	srand((unsigned int)time(NULL));

	printf(" ->\tCalculating values using Perlin Noise");
	PerlinNoise_2D();
	printf(" - DONE.\n");

	printf(" ->\tGenerating bitmap");
	CreateBMP(NoiseArray, outputBitmapFileName);
	printf(" - DONE.\n");
	PrintBMPInfo(outputBitmapFileName);

	//SaveArrayToFile(Noise2D, "array_per_5_00.txt");

	return 0;
}