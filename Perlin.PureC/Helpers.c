#include "stdafx.h"
#include "Helpers.h"

void printThreadParamInfo(ThreadParameters params)
{
	printf("Thread ID: %d", params.threadId);
	printf(" of %d.\n", params.threadsCount);
	printf("Image %d x %d px\n", params.width, params.height);
	printf("Image pointer: %p\n", params.imagePointer);
	printf("Current image offset: %d\n", params.offset);
	printf("Color: %d\tEffect: %d\tPersistence: %d\n", params.color, params.effect, params.persistence);
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

void SaveArrayToFile(double array2D[SIZE][SIZE], const char* fileName)
{
	unsigned i, j;
	FILE *f;

	fopen_s(&f, fileName, "wt");

	if (f == NULL)
		return;

	for (i = 0; i < SIZE; i++)
	{
		for (j = 0; j < SIZE; j++)
		{
			fprintf(f, "%+.5f ", array2D[i][j]);
		}
		fprintf(f, "\n");
	}
	fclose(f);
}