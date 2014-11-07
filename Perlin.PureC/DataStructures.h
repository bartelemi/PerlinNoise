#pragma once

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
	int offset;
	int width;
	int wholeHeight;
	int height;
	Pixel color;
	int effect;
	int octaves;
	double persistence;
	int threadId;
	int threadsCount;
} ThreadParameters;