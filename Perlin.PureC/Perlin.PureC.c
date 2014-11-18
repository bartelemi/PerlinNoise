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
	PerlinNoise2D(NoiseArrayDynamic, params);
	CreateBMP(NoiseArrayDynamic, params);
}

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params)
{
	printf("Not implemented.\n");
}


static void normalize(double v[2])
{
	double s = sqrt(v[0] * v[0] + v[1] * v[1]);
	v[0] /= s;
	v[1] /= s;
}

PERLINPUREC_API void Init(size_t width, size_t height)
{
	int i, j, k;

	srand((unsigned)time(NULL));

	p = (int*)malloc((B + B + 2) * sizeof(int));
	g2 = alloc2DArray(2, B + B + 2);
	NoiseArrayDynamic = alloc2DArray(width, height);

	for (i = 0; i < B; i++)
	{
		p[i] = i;

		for (j = 0; j < 2; j++)
			g2[i][j] = (float)((rand() % (B + B)) - B) / B;

		normalize(g2[i]);
	}

	while (--i)
	{
		k = p[i];
		p[i] = p[j = rand() % B];
		p[j] = k;
	}

	for (i = 0; i < B + 2; i++)
	{
		p[B + i] = p[i];
		for (j = 0; j < 2; j++)
			g2[B + i][j] = g2[i][j];
	}
}

PERLINPUREC_API void Finalize(size_t height)
{
	free(p);
	free2DArray(g2, B + B + 2);
	free2DArray(NoiseArrayDynamic, height);
}