#include "stdafx.h"

HEADER* FillHeader(int width, int height)
{
	HEADER *header = malloc(sizeof(HEADER));
	(*header).bmpFileType = 0x4D42;
	(*header).bmpFileSize = sizeof(HEADER) 
						  + sizeof(INFOHEADER) 
						  + (height * (width * 3 
						  + ((4 - ((width * 3) & 3)) & 3)));
	(*header).bmpFileReserved1 = 0;		  
	(*header).bmpFileReserved2 = 0;
	(*header).bmpFileOffsetBits = 54;

	return header;
}

INFOHEADER* FillInfoHeader(int width, int height)
{
	INFOHEADER* header = malloc(sizeof(INFOHEADER));
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

	memcpy(pointer, header, sizeof(HEADER));
	memcpy(pointer + sizeof(HEADER), info, sizeof(INFOHEADER));

	free(header);
	free(info);
}

void CreateBMP2(ThreadParameters params)
{
	Pixel pixel;
	double min, max;
	int i, j, l;
	unsigned pixelSize = sizeof(Pixel);
	int width = params.width;
	int height = params.height;
	int npad = ((4 - ((width * pixelSize) & 3)) & 3);
	unsigned char *pad = calloc(npad, sizeof(unsigned char));
	unsigned char *pointer = (unsigned char*)params.imagePointer;
	
	if (params.threadId == 0)
		WriteFileHeader(pointer, width, params.wholeHeight);

	MaxMinFrom2DArray(NoiseArrayDynamic, width, height, &min, &max);

	// Move pointer by current thread offset
	pointer += sizeof(HEADER) + sizeof(INFOHEADER) 
		     + ((params.offset)*(width*pixelSize + npad));

	for (i = 0; i < height; i++)
	{
		for (j = 0, l = 0; l < width; l++, j += pixelSize)
		{
			pixel = GetPixel(i, l, &min, &max, &params);
			memcpy(pointer + j, &pixel, pixelSize);
		}

		memcpy(pointer + j, pad, npad);
		pointer += (width*pixelSize + npad);
	}
}

Pixel GetPixel(int x, int y, double *min, double *max, ThreadParameters *params)
{
	Pixel pixel;
	double val = NoiseArrayDynamic[x][y];
	double minAfterEffect = *min;
	double maxAfterEffect = *max;

	switch ((*params).effect)
	{
	case 1:
		SinNoise(&val, &minAfterEffect, &maxAfterEffect, x, y);
		break;
	case 2:
		Experimental(&val, &minAfterEffect, &maxAfterEffect, x, y);
		break;
	case 3:
		Experimental2(&val, &minAfterEffect, &maxAfterEffect, x, y);
		break;
	case 0:
	default:
		break;
	}

	pixel = GetColor(val, minAfterEffect, maxAfterEffect, (*params).color);

	return pixel;
}

// Sin noise
void SinNoise(double *value, double *min, double *max, int x, int y)
{
	*value = sin((*value)) * sin(x) * sin(y);
	*max = *max;
	*min = (*max > (*min * (-1))) ? (*max * -1) : (*min);
}

void Experimental(double *value, double *min, double *max, int x, int y)
{
	*value = 10 - sin(y + *max * (*value));
	*max = +11.0;
	*min = 9.0;
}

void Experimental2(double *value, double *min, double *max, int x, int y)
{
	*value = sin(sqrt(y + *max * (*value)));
	*max = +1.0;
	*min = -1.0;
}

Pixel GetColor(double value, double min, double max, Pixel color)
{
	Pixel newPixel;
	unsigned int chVal = ScaleToChar(value, min, max);
	if (chVal == 0) ++chVal;
	newPixel._R = ((256 * chVal) / (color._R + 1));
	newPixel._G = ((256 * chVal) / (color._G + 1));
	newPixel._B = ((256 * chVal) / (color._B + 1));
	return newPixel;
}

Pixel GetColorReversed(double value, double min, double max, Pixel color)
{
	Pixel newPixel;
	unsigned int chVal = ScaleToChar(value, min, max);
	newPixel._R = ((256 * color._R) / chVal);
	newPixel._G = ((256 * color._G) / chVal);
	newPixel._B = ((256 * color._B) / chVal);
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
int ScaleToChar(double x, double min, double max)
{
	return (int)(255 * (x - min) / (max - min));
}