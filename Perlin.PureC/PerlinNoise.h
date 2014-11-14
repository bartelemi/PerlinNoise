#ifndef PERLINNOISE_H_
#define PERLINNOISE_H_

#include "stdafx.h"

//Perlin Noise functions
void PerlinNoise_2D(double** noiseArray, ThreadParameters params);
double Noise2D(double x, double y, __int32 octave);
double Smooth(double x, double y, __int32 octave);
double InterpolatedNoise(double x, double y, __int32 octave);

#endif
