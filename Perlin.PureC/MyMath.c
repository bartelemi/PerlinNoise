#include "stdafx.h"

double Power(double base, int exponent)
{
	int i;
	double tmp = base;
	for (i = 0; i < exponent; i++)
	{
		tmp *= base;
	}
	return tmp;
}

double CosineInterpolation(double a, double b, double x)
{
	double ft = x * 3.1415927;
	double f = (1.0 - cos(ft)) / 2;
	return ( a*(1.0 - f) + b*f);
}

long Sqrt(long i)
{
	long int r = 0;
	long int rNew = 1;
	long int rOld;

	do
	{
		rOld = r;
		r = rNew;
		rNew = (r + (i / r));
		rNew >>= 1;
	} while (rOld != rNew);

	return rNew;
}

void MaxMinFrom2DArray(double **arr, size_t width, size_t height, double *min, double *max)
{
	size_t i, j;
	(*max) = (*min) = arr[0][0];

	for (i = 0; i < height; i++)
	{
		for ( j = 0; j < width; j++)
		{
			if (arr[i][j] < (*min))
			{
				(*min) = arr[i][j];
			}
			else if (arr[i][j] > (*max))
			{
				(*max) = arr[i][j];
			}
		}
	}
}