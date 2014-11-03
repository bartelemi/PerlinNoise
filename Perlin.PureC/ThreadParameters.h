#pragma once

typedef struct ThreadParameters
{
	unsigned int* imagePointer;
	int offset;
	int width;
	int wholeHeight;
	int height;
	int color;
	int effect;
	int octaves;
	double persistence;
	int threadId;
	int threadsCount;
} ThreadParameters;