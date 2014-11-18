#include "stdafx.h"
#include "Helpers.h"

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