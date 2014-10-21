#include "Globals.h"

/*********************************************
			FILE NAMES DEFINITIONS
**********************************************/
	const char* firstGeneratedNumsFileName = "First256.txt";
	const char* secondGeneratedNumsFileName = "Second256.txt";
	const char* thirdGeneratedNumsFileName = "Third256.txt";
	const char* primeNumsFileName = "PrimeNumbers.txt";
	const char* outputBitmapFileName = "output\\test_034.bmp";

/*********************************************
				GLOBAL VARIABLES
*********************************************/
	//Init
	__int32 numberOfFirstOctave = 59;
	unsigned char basicOctaveCount = 10;
	double persistence = 1.0;

	//Prime number generator variables
	unsigned firstSmall	 = 13500;
	unsigned firstMedium = 750000;
	unsigned firstBig	 = 1376000000;
	unsigned skipSmall	 = 1500;
	unsigned skipMedium  = 25000;
	unsigned skipBig	 = 2000000;

