#include "stdafx.h"

#define N 0x10000
#define setup(i,b0,b1,r0,r1)\
	(t) = i + N;\
	(b0) = ((int)(t)) & BMask;\
	(b1) = ((b0)+1) & BMask;\
	(r0) = (t) - (int)(t);\
	(r1) = (r0) - 1.0;


void PerlinNoise2D(double** noiseArray, ThreadParameters params)
{
	int k;
	size_t i, j;

	for (k = 0; k < params.octaves - 1; k++)
	{
		double x, y;
		double amplitude = Power(2, k);
		double frequency = Power(params.persistence, k);

		for (i = params.offset; i < params.height + params.offset; i++)
		{
			for (j = 0; j < params.width; j++)
			{
				x = frequency * (i + ((rand() % 100) / 100.0));
				y = frequency * (j + ((rand() % 100) / 100.0));
				noiseArray[i][j] += amplitude * noise2(x, y);
			}
		}
	}
}

double noise2(double x, double y)
{
	int bx0, bx1, by0, by1, b00, b10, b01, b11;
	double rx0, rx1, ry0, ry1, *q, sx, sy, a, t, b, u, v;
	register int i, j;
	double two = 2.0, three = 3.0;
	setup(x, bx0, bx1, rx0, rx1);
	setup(y, by0, by1, ry0, ry1);

	i = p[bx0];
	j = p[bx1];

	b00 = p[i + by0];
	b10 = p[j + by0];
	b01 = p[i + by1];
	b11 = p[j + by1];

	sx = EASE_CURVE(rx0);
	sy = EASE_CURVE(ry0);
	

#define at2(rx,ry) ( rx * q[0] + ry * q[1] )

	q = g2[b00]; u = at2(rx0, ry0);
	q = g2[b10]; v = at2(rx1, ry0);
	a = LERP(u, v, sx);

	q = g2[b01]; u = at2(rx0, ry1);
	q = g2[b11]; v = at2(rx1, ry1);
	b = LERP(u, v, sx);

	return LERP(a, b, sy);
}