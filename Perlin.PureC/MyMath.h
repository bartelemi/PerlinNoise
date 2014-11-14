#ifndef MYMATH_H_
#define MYMATH_H_

#include "stdafx.h"

/**************************************
		MATHEMATICAL FUNCTIONS
**************************************/
	// Returns value of (3x^2 - 2x^3) for x = t
	#define EASE_CURVE(t) ((t) * (t) * (3.0 - (2.0 * (t))))

	// Precise linear interpolation
	#define LERP(v0, v1, t) ((v0) + (t) * ((v1) - (v0)))

	//Calculates square root of number
	long Sqrt(long i);

	// Calculates base^exponent
	double Power(double base, int exponent);

	//Cosine interpolation
	double CosineInterpolation(double a, double b, double x);

/**************************************
			ARRAY FUNCTIONS
**************************************/
	// Finds min and max value in array2D
	void MaxMinFrom2DArray(double **arr, size_t width, size_t height, double *min, double *max);
	
#endif
