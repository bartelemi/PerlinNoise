#include "stdafx.h"

/**************************************
	     MATHEMATICAL FUNCTIONS
**************************************/
	// Returns value of (3x^2 - 2x^3) for x = t
	#define EASE_CURVE(t) ((t) * (t) * (3.0 - (2.0 * (t))))

	// Precise linear interpolation
	#define LERP(v0, v1, t) ((v0) + (t) * ((v1) - (v0)))			

	// Calculates base^exponent
	double Power(double base, int exponent);

/**************************************
		    ARRAY FUNCTIONS
**************************************/
	// Allocs 2-dimensional array and initializes it with 0's (calloc)
	double** alloc2DArray(size_t width, size_t height);

	// Frees 2-dimensional array
	void free2DArray(double** pointer, size_t height);

	// Finds min and max value in array2D
	void MaxMinFrom2DArray(double **arr, size_t width, size_t height, double *min, double *max);

