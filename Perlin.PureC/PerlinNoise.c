#include "stdafx.h"

static const int N = 0x1000;
#define setup(i,b0,b1,r0,r1,tmp)   \
	(tmp) += i;                    \
	(b0) = ((int)(tmp)) & BMask;   \
	(b1) = ((b0)+1) & BMask;       \
	(r0) = (tmp) - (int)(tmp);     \
	(r1) = (r0) - 1.0;

#define at2(rx,ry) ((rx) * q[0] + (ry) * q[1])

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
	int bx0, bx1, by0, by1, bxy;
	double rx0, rx1, ry0, ry1, *q, a, b, u, v, t = N;
	register int i, j;
	
	setup(x, bx0, bx1, rx0, rx1, t);
	setup(y, by0, by1, ry0, ry1, t);

	i = p[bx0];
	j = p[bx1];

	t = EASE_CURVE(rx0);
	bxy = p[i + by0]; 
	q = g2[bxy];
	u = at2(rx0, ry0);

	bxy = p[j + by0]; 
	q = g2[bxy];
	v = at2(rx1, ry0);
	a = LERP(u, v, t);

	bxy = p[i + by1]; 
	q = g2[bxy]; 
	u = at2(rx0, ry1);

	bxy = p[j + by1]; 
	q = g2[bxy]; 
	v = at2(rx1, ry1);
	b = LERP(u, v, t);

	t = EASE_CURVE(ry0);
	return LERP(a, b, t);
}

//double noise2(double x, double y)
//{
//	int bx0, bx1, by0, by1, b00, b10, b01, b11;
//	double rx0, rx1, ry0, ry1, *q, sx, sy, a, b, u, v, t = N;
//	register int i, j;
//
//	setup(x, bx0, bx1, rx0, rx1, t);
//	setup(y, by0, by1, ry0, ry1, t);
//	sx = EASE_CURVE(rx0);
//	sy = EASE_CURVE(ry0);
//
//	i = p[bx0];
//	j = p[bx1];
//
//	b00 = p[i + by0];
//	b10 = p[j + by0];
//	b01 = p[i + by1];
//	b11 = p[j + by1];
//
//
//	q = g2[b00];
//	u = at2(rx0, ry0);
//
//	q = g2[b10];
//	v = at2(rx1, ry0);
//
//	a = LERP(u, v, sx);
//
//	q = g2[b01];
//	u = at2(rx0, ry1);
//
//	q = g2[b11];
//	v = at2(rx1, ry1);
//
//	b = LERP(u, v, sx);
//
//	return LERP(a, b, sy);
//}