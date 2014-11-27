#ifndef BITMAP_H_
#define BITMAP_H_

#include "stdafx.h"

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

	// Bitmap information
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

/***********************************
		FUNCTION PROTOTYPES
***********************************/
	// Returns filled BMPFILEHEADER
	HEADER* FillHeader(int width, int height);

	// Returns filled BMPINFOHEADER
	INFOHEADER* FillInfoHeader(int width, int height);

	// Write file header
	void WriteFileHeader(void *pointer, int width, int height);

	// Creates BMP using data from NoiseArray
	void CreateBMP(double **noiseArray, ThreadParameters params);


	// Returns new pixel 
	Pixel GetPixel(int x, int y, double *min, double *max, double **noiseArray, ThreadParameters *params);

	// Returns colored pixel
	Pixel GetColor(double value, double min, double max, Pixel color);

	// Returns colored pixel with negative of given color
	Pixel GetColorReversed(double value, double min, double max, Pixel color);

	// Noise effects
	void SinNoise(double *value, double *min, double *max, int x, int y);
	void SqrtNoise(double *value, double *min, double *max, int x, int y);
	void Experimental1(double *value, double *min, double *max, int x, int y);
	void Experimental2(double *value, double *min, double *max, int x, int y);
	void Experimental3(double *value, double *min, double *max, int x, int y);

	// Scales double value to unsigned char 0-255
	int ScaleToChar(double x, double min, double max);

#endif
