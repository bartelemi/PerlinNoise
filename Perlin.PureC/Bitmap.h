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
		unsigned short int bmpFileType;		// 2 bytes
		unsigned int bmpFileSize;			// 4 bytes
		unsigned short int bmpFileReserved1;// 2 bytes
		unsigned short int bmpFileReserved2;// 2 bytes
		unsigned int bmpFileOffsetBits;		// 4 bytes
	} HEADER;								
#pragma pack(pop)

#pragma pack(push, 1)
	typedef struct BMPINFOHEADER {
		unsigned int bmpSize;				// 4 bytes
		int bmpWidth;						// 4 bytes
		int bmpHeight;						// 4 bytes
		unsigned short int bmpPlanes;		// 2 bytes
		unsigned short int bmpBitCount;		// 2 bytes
		unsigned int bmpCompression;		// 4 bytes
		unsigned int bmpSizeImage;			// 4 bytes
		int bmpXPelsPerMeter;				// 4 bytes
		int bmpYPelsPerMeter;				// 4 bytes
		unsigned int bmpColorUsed;			// 4 bytes
		unsigned int bmpColorImportant;		// 4 bytes
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
	// Returns filled BMPFILEHEADER
	HEADER* FillHeader(int width, int height);
	INFOHEADER* FillInfoHeader(int width, int height);
	
	// Creates BMP using data from NoiseArray
	void CreateBMP2(ThreadParameters params);

	// Write file header
	void WriteFileHeader(char *pointer, int width, int height);

	// Map double value to Pixel
	Pixel GetPixelFromDouble(double value, double min, double max);
	Pixel GetPixelFromDouble(double value, double min, double max, int x, int y);

#endif
