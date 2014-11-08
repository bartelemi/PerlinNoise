#include "stdafx.h"
#include "Helpers.h"

void printThreadParamInfo(ThreadParameters params)
{
	printf("Thread ID: %d", params.threadId);
	printf(" of %d.\n", params.threadsCount);
	printf("Image %d x %d px\n", params.width, params.wholeHeight);
	printf("Image pointer: %p\n", params.imagePointer);
	printf("Current image offset: %d\n", params.offset);
	printf("Color: R%u G%u B%u\tEffect: %d\tPersistence: %f\n", 
		   params.color._R, params.color._G, params.color._B, params.effect, params.persistence);
}

void PrintBMPInfo(const char* bmpName)
{
	FILE *f;
	HEADER header;
	INFOHEADER info;

	fopen_s(&f, bmpName, "rb");
	if (f != NULL)
	{
		fread(&header, sizeof(HEADER), 1, f);
		fread(&info, sizeof(INFOHEADER), 1, f);
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
		printf("\tSize: %u\n", info.bmpSize);
		printf("\tWidth: %d\n", info.bmpWidth);
		printf("\tHeight: %d\n", info.bmpHeight);
		printf("\tPlanes: %hu\n", info.bmpPlanes);
		printf("\tBit count: %hu\n", info.bmpBitCount);
		printf("\tCompression: %u\n", info.bmpCompression);
		printf("\tSize image: %u\n", info.bmpSizeImage);
		printf("\tX DPI: %d\n", info.bmpXPelsPerMeter);
		printf("\tY DPI: %d\n", info.bmpYPelsPerMeter);
		printf("\tColor used: %u\n", info.bmpColorUsed);
		printf("\tColor important: %u\n", info.bmpColorImportant);

		fclose(f);
	}
}

void SaveArrayToFile(double **array2D, int width, int height, const char* fileName)
{
	unsigned i, j;
	FILE *f;

	fopen_s(&f, fileName, "wt");

	if (f == NULL)
		return;

	for (i = 0; i < height; i++)
	{
		for (j = 0; j < width; j++)
		{
			fprintf(f, "%+.5f ", array2D[i][j]);
		}
		fprintf(f, "\n");
	}
	fclose(f);
}

double** alloc2DArray(int width, int height)
{
	int i;
	double **pointer = (double**)calloc(height, sizeof(double*));

	for (i = 0; i < height; i++)
	{
		pointer[i] = (double*)calloc(width, sizeof(double));
	}

	return pointer;
}

void free2DArray(double** pointer, int height)
{
	int i;
	for (i = 0; i < height; i++)
	{
		free(pointer[i]);
	}
	free(pointer);
}

void printPointer(unsigned int* p)
{
	printf("Wskaznik: %p\n", p);
}