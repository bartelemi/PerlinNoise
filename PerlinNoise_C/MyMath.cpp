#include "stdafx.h"
#include "MyMath.h"

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

void MaxMinFrom2DArray(double array2D[SIZE][SIZE], double *min, double *max)
{
	unsigned i, j;
	*min = array2D[0][0];
	*max = array2D[0][0];

	for (i = 0; i < SIZE; i++)
	{
		for (j = 0; j < SIZE; j++)
		{
			if (array2D[i][j] < *min)
			{
				*min = array2D[i][j];
			}
			else if (array2D[i][j] > *max)
			{
				*max = array2D[i][j];
			}
		}
	}
}

void SaveArrayToFile(double array2D[SIZE][SIZE], const char* fileName)
{
	unsigned i, j;
	FILE *f;

	fopen_s(&f, fileName, "wt");

	if (f == NULL)
		return;

	for (i = 0; i < SIZE; i++)
	{
		for ( j = 0; j < SIZE; j++)
		{
			fprintf(f, "%+.5f ", array2D[i][j]);
		}
		fprintf(f, "\n");
	}
	fclose(f);
}