#include "stdafx.h"

// Returns filled BMPFILEHEADER
HEADER* FillHeader(int width, int height)
{
	HEADER *header = (HEADER*)malloc(sizeof(HEADER));
	
	(*header).bmpFileType = 0x4D42;						   // 'B''M'
	(*header).bmpFileSize = (sizeof(HEADER) 
						  + sizeof(INFOHEADER) 
						  + (height * (width * 3 
						  + ((4 - ((width * 3) & 3)) & 3)) ));
	(*header).bmpFileReserved1 = 0;						   // Reserved 1
	(*header).bmpFileReserved2 = 0;						   // Reserved 2
	(*header).bmpFileOffsetBits = 54;					   // Offset for data
	return header;
}

INFOHEADER* FillInfoHeader(int width, int height)
{
	INFOHEADER* header = (INFOHEADER*)malloc(sizeof(INFOHEADER));
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
void WriteFileHeader(unsigned char *pointer, int width, int height)
{
	HEADER* header = FillHeader(width, height);
	INFOHEADER* info = FillInfoHeader(width, height);

	printf("\tFile type: %hu\n", (*header).bmpFileType);
	printf("\tFile size: %u bytes\n", (*header).bmpFileSize);
	printf("\tReserved1: %hu\n", (*header).bmpFileReserved1);
	printf("\tReserved2: %hu\n", (*header).bmpFileReserved2);
	printf("\tOffset bits: %u\n\n", (*header).bmpFileOffsetBits);

	printf("\tSize: %u\n", (*info).bmpSize);
	printf("\tWidth: %d\n", (*info).bmpWidth);
	printf("\tHeight: %d\n", (*info).bmpHeight);
	printf("\tPlanes: %hu\n", (*info).bmpPlanes);
	printf("\tBit count: %hu\n", (*info).bmpBitCount);
	printf("\tCompression: %u\n", (*info).bmpCompression);
	printf("\tSize image: %u\n", (*info).bmpSizeImage);
	printf("\tX DPI: %d\n", (*info).bmpXPelsPerMeter);
	printf("\tY DPI: %d\n", (*info).bmpYPelsPerMeter);
	printf("\tColor used: %u\n", (*info).bmpColorUsed);
	printf("\tColor important: %u\n", (*info).bmpColorImportant);

	memcpy(pointer, header, sizeof(HEADER));
	memcpy(pointer + sizeof(HEADER), info, sizeof(INFOHEADER));
	free(header);
	free(info);
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
	unsigned char *pointer = (unsigned char*)params.imagePointer;
	
	printPointer(pointer);

	npad = (width * 3) & 3;
	if (npad)
		npad = 4 - npad;

	if (params.threadId == 0)
	{
		WriteFileHeader(pointer, width, params.wholeHeight);
	}

	pointer += (unsigned char)54;

	printPointer(pointer);

	pixelSize = sizeof(Pixel);
	
	MaxMinFrom2DArray(NoiseArrayDynamic, width, height, &min, &max);

	for (i = offset, k = 0; k < height; i++, k++)
	{
		for (j = 0, l = 0; l < width; l++, j += pixelSize)
		{
			pixel = GetPixelFromDouble(NoiseArrayDynamic[k][l], min, max, k, l);
			//printPointer(*pointer >> i*(width + npad*sizeof(pad)) + j);
			memcpy(pointer + (unsigned char)(i*(width + npad*sizeof(pad)) + j), &pixel, pixelSize);
		}
		for (l = 0; l < npad; l++)
		{
			//printPointer(pointer + i*(width + npad*sizeof(pad)) + j + l);
			memcpy(pointer + (unsigned char)(i*(width + npad*sizeof(pad)) + j + l), &pad, sizeof(pad));
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