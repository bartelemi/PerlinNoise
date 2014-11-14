#include "stdafx.h"
#include "PerlinOriginal.h"

//double Noise2D(double x, double y, __int32 octave)
//{
//	__int32 temp = (x + y) * 101;
//
//	__int32 firstNum = primeNumbers[octave][0];
//	__int32 secondNum = primeNumbers[octave][1];
//	__int32 thirdNum = primeNumbers[octave][2];
//
//	temp = (temp << 17) ^ temp;
//	temp = (temp * (temp * temp * firstNum + secondNum) + thirdNum);
//	temp &= 0x7FFFFFFF;	
//	return (1.0 - ((double)temp / 1073741824.0));
//}

//double Smooth(double x, double y, __int32 octave)
//{
//	double corners = (Noise2D(x - STEP, y - STEP, octave)
//				   + Noise2D(x + STEP, y - STEP, octave)
//				   + Noise2D(x - STEP, y + STEP, octave)
//				   + Noise2D(x + STEP, y + STEP, octave)) / 16.0;
//	double sides = (Noise2D(x - STEP, y, octave)
//				 + Noise2D(x + STEP, y, octave)
//				 + Noise2D(x, y - STEP, octave)
//				 + Noise2D(x, y + STEP, octave)) / 8.0;
//	double center = Noise2D(x, y, octave) / 4.0;
//	return (corners + sides + center);
//}

//double InterpolatedNoise(double x, double y, __int32 octave)
//{
//	//printf("x: %.3f\ty:%.3f\n", x, y);
//	__int32 integer_X = (__int32)x;
//	__int32 integer_Y = (__int32)y;
//	double fractional_X = x - (double)integer_X;
//	double fractional_Y = y - (double)integer_Y;
//
//	double v1 = Smooth(integer_X, integer_Y, octave);
//	double v2 = Smooth(integer_X + 1, integer_Y, octave);
//	double v3 = Smooth(integer_X, integer_Y + 1, octave);
//	double v4 = Smooth(integer_X + 1, integer_Y + 1, octave);
//
//	double i1 = LERP(v1, v2, fractional_X);
//	double i2 = LERP(v3, v4, fractional_X);
//	return LERP(i1, i2, fractional_Y);
//	//double i1 = CosineInterpolation(v1, v2, fractional_X);
//	//double i2 = CosineInterpolation(v3, v4, fractional_X);
//	//return CosineInterpolation(i1, i2, fractional_Y);
//}

void PerlinNoise_2D(ThreadParameters params)
{
	int i, j, k;

	init();
	for (k = 0; k < params.octaves - 1; k++)
	{
		double amplitude = Power(2, k);
		double frequency = Power(params.persistence, k);

		for (i = 0; i < params.height; i++)
		{
			for (j = 0; j < params.width; j++)
			{
				NoiseArrayDynamic[i][j] += amplitude * noise2(
					frequency * ((i + ((rand() % 100) / 100.0))),
					frequency * ((j + ((rand() % 100) / 100.0)))
					);
			}
		}
	}
}