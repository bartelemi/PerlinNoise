#pragma once

#include <stdlib.h>

// Struct containing info about single pixel
typedef struct Pixel {
	unsigned char _B; 
	unsigned char _G;
	unsigned char _R;
} Pixel;

// Struct containing info about current thread params
// Same as in GUI project
typedef struct ThreadParameters
{
	unsigned int* imagePointer;
	size_t offset;
	size_t width;
	size_t wholeHeight;
	size_t height;
	Pixel color;
	int effect;
	int octaves;
	double persistence;
	int threadId;
	int threadsCount;
} ThreadParameters;