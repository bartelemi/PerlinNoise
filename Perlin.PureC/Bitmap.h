#ifndef BITMAP_H_
#define BITMAP_H_

#include "stdafx.h"

#include <stdio.h>
#include <string.h>

/***********************************
			DATA STRUCTURES
***********************************/

#pragma pack(push, 1)

	// File information
	typedef struct BMPFILEHEADER {
		unsigned short int bmpFileType;
		unsigned int bmpFileSize;
		unsigned short int bmpFileReserved1;
		unsigned short int bmpFileReserved2;
		unsigned int bmpFileOffsetBits;
	} HEADER;

#pragma pack(pop)
#pragma pack(push, 1)

	// Bitmap information
	typedef struct BMPINFOHEADER {
		unsigned int bmpSize;
		int bmpWidth;
		int bmpHeight;
		unsigned short int bmpPlanes;
		unsigned short int bmpBitCount;
		unsigned int bmpCompression;
		unsigned int bmpSizeImage;
		int bmpXPelsPerMeter;
		int bmpYPelsPerMeter;
		unsigned int bmpColorUsed;
		unsigned int bmpColorImportant;
	} INFOHEADER;

#pragma pack(pop)

	// Struct containing info about single pixel
	typedef struct Pixel {
		unsigned char _R;
		unsigned char _G;
		unsigned char _B;
	} Pixel;

/***********************************
		FUNCTION PROTOTYPES
***********************************/
	//Returns filled BMPFILEHEADER
	HEADER* FillHeader(int width, int height);

	//Returns filled BPINFOHEADER
	INFOHEADER* FillInfoHeader(int width, int height);

	//Creates BMP using data from NoiseArray
	void CreateBMP(double array2D[SIZE][SIZE], const char* outputBMP);
	void CreateBMP2(double **array, int width, int height, int offset);


	//Map double value to Pixel
	Pixel GetPixelFromDouble(double value, double min, double max);
	Pixel GetPixelFromDouble(double value, double min, double max, int x, int y);

	

#endif
