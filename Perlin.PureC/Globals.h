#ifndef GLOBALS_H_
#define GLOBALS_H_

/*********************************************
					CONST
**********************************************/
	//Number of prime numbers in array
	#define PRIMESCOUNT 256

	//Size of result array
	#define SIZE 500

	//Step for points iteration e.g. STEP = 15 means: x = 0.00, 0.15
	#define STEP 0.1

/*********************************************
			FILE NAMES DEFINITIONS
**********************************************/
	//File names
	extern const char* firstGeneratedNumsFileName;
	extern const char* secondGeneratedNumsFileName;
	extern const char* thirdGeneratedNumsFileName;
	extern const char* primeNumsFileName;
	extern const char* outputBitmapFileName;

/*********************************************
				GLOBAL VARIABLES
*********************************************/
	//Init
	extern __int32 numberOfFirstOctave;
	extern unsigned char basicOctaveCount;
	extern double persistence;

	//Prime number generator variables
	extern unsigned firstSmall;
	extern unsigned firstMedium;
	extern unsigned firstBig; 
	extern unsigned skipSmall;
	extern unsigned skipMedium;
	extern unsigned skipBig;

/*********************************************
					ARRAYS
*********************************************/
	//Prime numbers for generating pseudorandom noise
	unsigned primeNumbers[PRIMESCOUNT][3];

	//Result noise array
	double NoiseArray[SIZE][SIZE];
	double PointArray[SIZE][SIZE];
#endif
