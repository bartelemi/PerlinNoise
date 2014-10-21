#include "stdafx.h"
#include "Bitmap.h"
#include "MyMath.h"

//Returns filled BMPFILEHEADER
HEADER* FillHeader(int sideSize)
{
	HEADER *header = (HEADER*)malloc(sizeof(HEADER));
	(*header).bmpFileType = 0x4D42;
	(*header).bmpFileSize = sizeof(HEADER)     //File header
		+ sizeof(INFOHEADER)				   //Bitmap header
		+ sideSize*sideSize*(sizeof(Pixel)     //Pixels
		+ (4 - (sideSize * 3) % 4) % 4);	   //Padding for data
	(*header).bmpFileReserved1 = 0;
	(*header).bmpFileReserved2 = 0;
	(*header).bmpFileOffsetBits = 54;
	return header;
}

//Returns filled BPINFOHEADER
INFOHEADER* FillInfoHeader(int sideSize)
{
	INFOHEADER* infoHeader = (INFOHEADER*)malloc(sizeof(INFOHEADER));
	(*infoHeader).bmpSize = 40;
	(*infoHeader).bmpWidth = sideSize;
	(*infoHeader).bmpHeight = sideSize;
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

void CreateBMP(double array2D[SIZE][SIZE], const char* outputBMP)
{
	FILE *output;
	fopen_s(&output, outputBMP, "wb");

	if (output != NULL)
	{
		unsigned i, j;
		double min, max;
		unsigned char bmppad[3] = { 0, 0, 0 };
		Pixel pixel;
		HEADER* header = FillHeader(SIZE);
		INFOHEADER* infoHeader = FillInfoHeader(SIZE);

		fwrite(header, sizeof(HEADER), 1, output);
		fwrite(infoHeader, sizeof(INFOHEADER), 1, output);

		free(header);
		free(infoHeader);

		MaxMinFrom2DArray(array2D, &min, &max);

		for (i = 0; i < SIZE; i++)
		{
			for (j = 0; j < SIZE; j++)
			{
				pixel = GetPixelFromDouble(array2D[i][j], min, max, i, j);
				fwrite(&pixel, sizeof(Pixel), 1, output);
				fwrite(bmppad, (4 - (SIZE * 3) % 4) % 4, 1, output);
			}
		}
		fclose(output);
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

//Blue
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

//Orange noise
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

//Green noise
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
	//if (val < 0) val = -val;

	chVal = ((val - sin(min)) * 255) / (sin(max) - sin(min));
	newPixel._R = chVal;
	newPixel._G = chVal / 2;
	newPixel._B = chVal / 4;
	return newPixel;
}

void PrintBMPInfo(const char* bmpName)
{
	FILE *f;
	HEADER header;
	INFOHEADER infoHeader;

	fopen_s(&f, bmpName, "rb");
	fread(&header, sizeof(HEADER), 1, f);
	fread(&infoHeader, sizeof(INFOHEADER), 1, f);

	if (header.bmpFileType != 0x4D42)
	{
		printf("Invalid file format.");
		return;
	}

	printf(bmpName);
	 printf("\n File header:\n");
		printf("\tFile type: %hu\n", header.bmpFileType);
		printf("\tFile size: %u bytes\n", header.bmpFileSize);
		printf("\tReserved1: %hu\n", header.bmpFileReserved1);
		printf("\tReserved2: %hu\n", header.bmpFileReserved2);
		printf("\tOffset bits: %u\n\n", header.bmpFileOffsetBits);

 	 printf(" Info header:\n");
		printf("\tSize: %u\n", infoHeader.bmpSize);
		printf("\tWidth: %d\n", infoHeader.bmpWidth);
		printf("\tHeight: %d\n", infoHeader.bmpHeight);
		printf("\tPlanes: %hu\n", infoHeader.bmpPlanes);
		printf("\tBit count: %hu\n", infoHeader.bmpBitCount);
		printf("\tCompression: %u\n", infoHeader.bmpCompression);
		printf("\tSize image: %u\n", infoHeader.bmpSizeImage);
		printf("\tX DPI: %d\n", infoHeader.bmpXPelsPerMeter);
		printf("\tY DPI: %d\n", infoHeader.bmpYPelsPerMeter);
		printf("\tColor used: %u\n", infoHeader.bmpColorUsed);
		printf("\tColor important: %u\n", infoHeader.bmpColorImportant);

	fclose(f);
}