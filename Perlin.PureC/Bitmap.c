#include "stdafx.h"

HEADER* FillHeader(int width, int height)
{
	HEADER *header = (HEADER*)malloc(sizeof(HEADER));
	
	(*header).bmpFileType = 0x4D42;						   // 'B''M'
	(*header).bmpFileSize = sizeof(HEADER) 
						  + sizeof(INFOHEADER) 
						  + (height * (width * 3 
						  + ((4 - ((width * 3) & 3)) & 3)));
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
	double min, max;
	unsigned i, j, l;
	unsigned pixelSize = sizeof(Pixel);
	int npad;
	int width = params.width;
	int height = params.height;
	unsigned char pad = 0;
	unsigned char *pointer = (unsigned char*)params.imagePointer;
	
	if (params.threadId == 0)
		WriteFileHeader(pointer, width, params.wholeHeight);

	MaxMinFrom2DArray(NoiseArrayDynamic, width, height, &min, &max);
	//printf("min = %f\tmax=%f\n", min, max);

	npad = ((4 - ((width * 3) & 3)) & 3);
	pointer += (sizeof(HEADER) + sizeof(INFOHEADER)
			 + (unsigned char)(params.offset*(width*pixelSize + npad)));
	
	for (i = 0; i < height; i++)
	{
		for (j = 0, l = 0; l < width; l++, j += pixelSize)
		{
			pixel = GetPixel(i, l, &min, &max, params.color, params.effect);
			memcpy(pointer + j, &pixel, pixelSize);
		}
		for (l = 0; l < npad; l++)
		{
			memcpy(pointer + j + l, &pad, sizeof(pad));
		}
		pointer += (width*pixelSize + npad);
	}
}

Pixel GetPixel(int x, int y, double *min, double *max, int color, int effect)
{
	Pixel pixel;
	double val = NoiseArrayDynamic[x][y];
	double minAfterEffect = *min;
	double maxAfterEffect = *max;

	switch (effect)
	{
	case 1:
		SinNoise(&val, &minAfterEffect, &maxAfterEffect, x, y);
		break;
	case 2:
		
		break;
	case 3:
		Experimental(&val, &minAfterEffect, &maxAfterEffect, x, y);;
		break;
	case 0:
	default:
		break;
	}

	switch (color)
	{
	case 0:
		pixel = Grey(val, minAfterEffect, maxAfterEffect);
		break;
	case 1:
		pixel = Blue(val, minAfterEffect, maxAfterEffect);
		break;
	case 2:
		pixel = Green(val, minAfterEffect, maxAfterEffect);
		break;
	case 3:
		pixel = Orange(val, minAfterEffect, maxAfterEffect);
		break;
	default:
		pixel = Grey(val, minAfterEffect, maxAfterEffect);
	}

	return pixel;
}

// Sin noise
void SinNoise(double *value, double *min, double *max, int x, int y)
{
	*value = (*value) * sin(x) * sin(y);
	*max = *max;
	*min = (*max > (*min * (-1))) ? (*max * -1) : (*min);
}

void Experimental(double *value, double *min, double *max, int x, int y)
{
	*value = sin(sqrt(y + *max * (*value)));
	*max = +1.0;
	*min = -1.0;
}


//Grey noise
Pixel Grey(double value, double min, double max)
{
	Pixel newPixel;
	unsigned char chVal = ScaleToChar(value, min, max);
	newPixel._R = newPixel._G = newPixel._B = chVal;
	return newPixel;
}

// Blue
Pixel Blue(double value, double min, double max)
{
	Pixel newPixel;
	unsigned char chVal = ScaleToChar(value, min, max);
	newPixel._R = (unsigned char)chVal;
	newPixel._G = (unsigned char)chVal / 2;
	newPixel._B = (unsigned char)chVal / 4;
	return newPixel;
}

// Orange noise
Pixel Orange(double value, double min, double max)
{
	Pixel newPixel;
	unsigned char chVal = ScaleToChar(value, min, max);
	newPixel._R = (unsigned char)chVal / 4;
	newPixel._G = (unsigned char)chVal / 2;
	newPixel._B = (unsigned char)chVal;
	return newPixel;
}

// Green noise
Pixel Green(double value, double min, double max)
{
	Pixel newPixel;
	unsigned char chVal = ScaleToChar(value, min, max);
	newPixel._R = (unsigned char)chVal / 6;
	newPixel._G = (unsigned char)chVal / 2;
	newPixel._B = (unsigned char)chVal / 8;
	return newPixel;
}

/*
	Scaling x ∈ [min; max] -> [a; b]
	Where we need to calculate min and max
	and a = 0, b = 255 (unsigned char)

	Formula:
	       (b - a)(x - min)
	f(x) = ----------------  + a
	          max - min    
*/
unsigned char ScaleToChar(double x, double min, double max)
{
	return (unsigned char)(255 * (x - min) / (max - min));
}