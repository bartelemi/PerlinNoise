#include "stdafx.h"
#include "Helpers.h"

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


double** alloc2DArray(size_t width, size_t height)
{
	size_t i;
	double **pointer = (double**)calloc(height, sizeof(double*));
	for (i = 0; i < height; i++)
	{
		pointer[i] = (double*)calloc(width, sizeof(double));
	}
	return pointer;
}

void free2DArray(double** pointer, size_t height)
{
	size_t i;
	for (i = 0; i < height; i++)
	{
		free(pointer[i]);
	}
	free(pointer);
}

void MaxMinFrom2DArray(double **arr, size_t width, size_t height, double *min, double *max)
{
	size_t i, j;
	(*max) = (*min) = arr[0][0];

	for (i = 0; i < height; i++)
	{
		for (j = 0; j < width; j++)
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