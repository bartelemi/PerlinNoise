#include "stdafx.h"

// Returns filled BMPFILEHEADER
HEADER* FillHeader(int width, int height)
{
	HEADER *header = (HEADER*)malloc(sizeof(HEADER));
	(*header).bmpFileType = 0x4D42;						// 'B''M'
	(*header).bmpFileSize = sizeof(HEADER)				// File header
						  + sizeof(INFOHEADER)			// Bitmap header
						  + width*height*(sizeof(Pixel) // Pixels
		                  + (4 - (width * 3) % 4) % 4); // Padding for data
	(*header).bmpFileReserved1 = 0;						// Reserved 1
	(*header).bmpFileReserved2 = 0;						// Reserved 2
	(*header).bmpFileOffsetBits = 54;					// Offset for data
	return header;
}

// Returns filled BPINFOHEADER
INFOHEADER* FillInfoHeader(int width, int height)
{
	INFOHEADER* infoHeader = (INFOHEADER*)malloc(sizeof(INFOHEADER));
	(*infoHeader).bmpSize = 40;
	(*infoHeader).bmpWidth = width;
	(*infoHeader).bmpHeight = height;
	(*infoHeader).bmpPlanes = 1;
	(*infoHeader).bmpBitCount = 24;
	(*infoHeader).bmpCompression = 0;
	(*infoHeader).bmpSizeImage = 0;
	(*infoHeader).bmpXPelsPerMeter = 0x0EC4; // DPI
	(*infoHeader).bmpYPelsPerMeter = 0x0EC4; // (0x03C3 = 96 dpi, 0x0B13 = 72 dpi)
	(*infoHeader).bmpColorUsed = 0;
	(*infoHeader).bmpColorImportant = 0;
	return infoHeader;
}

void WriteFileHeader(unsigned int *pointer, int width, int height)
{
	HEADER* header = FillHeader(width, height);
	INFOHEADER* infoHeader = FillInfoHeader(width, height);

	memcpy(&pointer, &header, sizeof(HEADER));
	memcpy((&pointer + sizeof(HEADER)), &infoHeader, sizeof(INFOHEADER));
}

void CreateBMP2(ThreadParameters params)
{
	Pixel pixel;
	unsigned i, j, k, l, padSize, pixelSize;
	double min, max;
	unsigned char bmppad[3] = { 0, 0, 0 };
	unsigned int *pointer = params.imagePointer;
	int width = params.width;
	int height = params.height;
	int offset = params.offset;
	
	if (params.threadId == 0)
	{
		WriteFileHeader(pointer, width, height);
	}

	pixelSize = sizeof(Pixel);
	padSize = (4 - (width * 3) % 4) % 4;
	
	MaxMinFrom2DArray(NoiseArrayDynamic, width, height, &min, &max);

	for (i = offset, k = 0; i < (offset + height); i++, k++)
	{
		for (j = 0, l = 0; j < (width * (pixelSize + padSize)); l++)
		{
			printf("(%d, %d) ", k, l);
			pixel = GetPixelFromDouble(NoiseArrayDynamic[k][l], min, max, k, l);
			memcpy((&pointer[i]+j), &pixel, pixelSize);
			j += pixelSize;
			memcpy((&pointer[i]+j), &bmppad, padSize);
			j += padSize;
		}
	}
	printf("Skonczylem.\n");
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