#ifndef PERLINNOISE_H_
#define PERLINNOISE_H_

#include "stdafx.h"

// Initializes noise array with noise values, 
// according to params (octaves, persistence)
void PerlinNoise2D(double** noise, ThreadParameters params);

// Returns noise value for point (x, y)
double Noise(double x, double y);

#endif
