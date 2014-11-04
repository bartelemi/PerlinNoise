#include "stdafx.h"

// Returns filled BMPFILEHEADER
HEADER* FillHeader(int width, int height)
{
	HEADER *header = (HEADER*)malloc(sizeof(HEADER));
	
	(*header).bmpFileType = 0x4D42;						   // 'B''M'			- 0-1
	(*header).bmpFileSize = (sizeof(HEADER) + (height * (width * 3 + (4 - ((width * 3) & 3)) & 3) ));
	(*header).bmpFileReserved1 = 0;						   // Reserved 1		- 6-7
	(*header).bmpFileReserved2 = 0;						   // Reserved 2		- 8-9
	(*header).bmpFileOffsetBits = 54;					   // Offset for data   - 10-13

	(*header).bmpSize = 40;
	(*header).bmpWidth = width;
	(*header).bmpHeight = height;
	(*header).bmpPlanes = 1;
	(*header).bmpBitCount = 24;
	(*header).bmpCompression = 0;
	(*header).bmpSizeImage = 0;
	(*header).bmpXPelsPerMeter = 0x0EC4;				// DPI
	(*header).bmpYPelsPerMeter = 0x0EC4;				// (0x03C3 = 96 dpi, 0x0B13 = 72 dpi)
	(*header).bmpColorUsed = 0;
	(*header).bmpColorImportant = 0;
	return header;
}

void WriteFileHeader(unsigned int *pointer, int width, int height)
{
	HEADER* header = FillHeader(width, height);
	memcpy(pointer, header, sizeof(HEADER));
	free(header);
}

void CreateBMP2(ThreadParameters params)
{
	Pixel pixel;
	unsigned i, j, k, l, pixelSize;
	double min, max;
	int width = params.width;
	int height = params.height;
	int offset = params.offset;
	unsigned char pad = 0;
	int npad;
	char *pointer = (char*)params.imagePointer;
	
	printPointer(pointer);

	npad = (width * 3) & 3;
	if (npad)
		npad = 4 - npad;

	if (params.threadId == 0)
	{
		WriteFileHeader(params.imagePointer, width, params.wholeHeight);
	}

	pointer += 54;

	printPointer(pointer);

	pixelSize = sizeof(Pixel);
	
	MaxMinFrom2DArray(NoiseArrayDynamic, width, height, &min, &max);

	for (i = offset, k = 0; k < height; i++, k++)
	{
		for (j = 0, l = 0; l < width; l++, j += pixelSize)
		{
			pixel = GetPixelFromDouble(NoiseArrayDynamic[k][l], min, max, k, l);
			//printPointer(*pointer >> i*(width + npad*sizeof(pad)) + j);
			memcpy(pointer + (i*(width + npad*sizeof(pad)) + j), &pixel, pixelSize);
		}
		for (l = 0; l < npad; l++)
		{
			//printPointer(pointer + i*(width + npad*sizeof(pad)) + j + l);
			memcpy(pointer + (i*(width + npad*sizeof(pad)) + j + l), &pad, sizeof(pad));
		}
	}
}

//Grey noise
/*Pixel GetPixelFromDouble(double value, double min, double max)
{
	Pixel newPixel;
	double val = (value - min) / (max - min) * 256;
	if (val > 256) val = 256.0;
	else if (val < 0) val = 0.0;
	newPixel._R = newPixel._G = newPixel._B = (unsigned char)val;
	return newPixel;
}*/

// Blue
/*Pixel GetPixelFromDouble(double value, double min, double max)
{
	Pixel newPixel;
	double val = (value - min) / (max - min) * 256;
	if (val > 256) val = 256.0;
	else if (val < 0) val = 0.0;
	newPixel._R = (unsigned char)val;
	newPixel._G = (unsigned char)val / 2; 
	newPixel._B = (unsigned char)val / 4;
	return newPixel;
}*/

// Orange noise
/*Pixel GetPixelFromDouble(double value, double min, double max)
{
	Pixel newPixel;
	double val = (value - min) / (max - min) * 256;
	if (val > 256) val = 256.0;
	else if (val < 0) val = 0.0;
	newPixel._R = (unsigned char)val / 4;
	newPixel._G = (unsigned char)val / 2;
	newPixel._B = (unsigned char)val;
	return newPixel;
}*/

// Green noise
/*Pixel GetPixelFromDouble(double value, double min, double max)
{
	Pixel newPixel;
	double val = (value - min) / (max - min) * 256;
	if (val > 256) val = 256.0;
	else if (val < 0) val = 0.0;
	newPixel._R = (unsigned char)val / 6;
	newPixel._G = (unsigned char)val / 2;
	newPixel._B = (unsigned char)val / 8;
	return newPixel;
}*/

// noise
Pixel GetPixelFromDouble(double value, double min, double max, int x, int y)
{
	Pixel newPixel;
	unsigned char chVal;
	double val = sin(x + max * value);

	chVal = ((val - sin(min)) * 255) / (sin(max) - sin(min));
	newPixel._R = chVal;
	newPixel._G = chVal / 2;
	newPixel._B = chVal / 4;
	return newPixel;
}