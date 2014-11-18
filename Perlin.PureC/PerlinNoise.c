#include "stdafx.h"
#include "PerlinOriginal.h"

void PerlinNoise2D(double** noiseArray, ThreadParameters params)
{
	int k;
	size_t i, j;

	for (k = 0; k < params.octaves - 1; k++)
	{
		double x, y;
		double amplitude = Power(2, k);
		double frequency = Power(params.persistence, k);

		for (i = params.offset; i < params.height + params.offset; i++)
		{
			for (j = 0; j < params.width; j++)
			{
				x = frequency * (i + ((rand() % 100) / 100.0));
				y = frequency * (j + ((rand() % 100) / 100.0));
				noiseArray[i][j] += amplitude * noise2(x, y);
			}
		}
	}
}