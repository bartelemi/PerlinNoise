#include "stdafx.h"

/*********************************************
			FILE NAMES DEFINITIONS
**********************************************/
	const char* firstGeneratedNumsFileName = "First256.txt";	// do wywalenia
	const char* secondGeneratedNumsFileName = "Second256.txt";	// do wywalenia
	const char* thirdGeneratedNumsFileName = "Third256.txt";	// do wywalenia
	const char* primeNumsFileName = "PrimeNumbers.txt";			// do wywalenia
	const char* outputBitmapFileName = "output\\test_034.bmp";	// do wywalenia

/*********************************************
				GLOBAL VARIABLES
*********************************************/
	//Init
	__int32 numberOfFirstOctave = 59;	 // do wywalenia
	unsigned char basicOctaveCount = 10; // do wywalenia
	double persistence = 1.0;			 // do modyfikacji - przychodzi z ThreadParameters

	//Prime number generator variables
	unsigned firstSmall	 = 13500;		// do wywalenia
	unsigned firstMedium = 750000;		// do wywalenia
	unsigned firstBig	 = 1376000000;	// do wywalenia
	unsigned skipSmall	 = 1500;		// do wywalenia
	unsigned skipMedium  = 25000;		// do wywalenia
	unsigned skipBig	 = 2000000;		// do wywalenia

