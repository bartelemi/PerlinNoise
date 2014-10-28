#pragma once

typedef struct ThreadParameters
{
	unsigned int* ImageByteArrayPointer;
	int CurrentImageOffset;
	int ImageWidth;
	int ImageHeight;
	double Persistence;
	int NoiseColor;
	int NoiseEffect;
	int IdOfThread;
	int NumberOfThreads;
} ThreadParameters;