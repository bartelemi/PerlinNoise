/* coherent noise function over 1, 2 or 3 dimensions */
/* (copyright Ken Perlin) */

#include "stdafx.h"
#include "PerlinOriginal.h"

#define B 0x1000
#define BM 0xfff

#define N 0x10000
#define NP 12   /* 2^N */
#define NM 0xffff

static int p[B + B + 2];
static double g2[B + B + 2][2];

#define setup(i,b0,b1,r0,r1)\
	(t) = i + N;\
	(b0) = ((int)(t)) & BM;\
	(b1) = ((b0)+1) & BM;\
	(r0) = (t) - (int)(t);\
	(r1) = (r0) - 1.0;


double noise2(double x, double y)
{
	int bx0, bx1, by0, by1, b00, b10, b01, b11;
	double rx0, rx1, ry0, ry1, *q, sx, sy, a, t, b, u, v;
	register int i, j;

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

static void normalize2(double v[2])
{
	double s = sqrt(v[0] * v[0] + v[1] * v[1]);
	v[0] /= s;
	v[1] /= s;
}

void init(void)
{
	int i, j, k;

	for (i = 0; i < B; i++) 
	{
		p[i] = i;

		for (j = 0; j < 2; j++)
			g2[i][j] = (double)((rand() % (B + B)) - B) / B;

		normalize2(g2[i]);
	}

	while (--i) 
	{
		k = p[i];
		p[i] = p[j = rand() % B];
		p[j] = k;
	}

	for (i = 0; i < B + 2; i++) 
	{
		p[B + i] = p[i];
		for (j = 0; j < 2; j++)
			g2[B + i][j] = g2[i][j];
	}
}