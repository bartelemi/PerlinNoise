#ifndef PERLINNOISE_H_
#define PERLINNOISE_H_

#include "MyMath.h"
#include "Globals.h"

//Perlin Noise functions
double Persistence(double x, double y);
void PerlinNoise_2D();
double Noise2D(double x, double y, __int32 octave);
double Smooth(double x, double y, __int32 octave);
double InterpolatedNoise(double x, double y, __int32 octave);

#endif
