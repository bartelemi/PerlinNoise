#ifndef GLOBALS_H_
#define GLOBALS_H_

/*********************************************
					CONST
**********************************************/
	//Size of result array
	#define SIZE 500	// do wywalenia

	//Step for points iteration e.g. STEP = 15 means: x = 0.00, 0.15
	#define STEP 0.1

/*********************************************
					ARRAYS
*********************************************/
	//Result noise array
	double NoiseArray[SIZE][SIZE];
	double PointArray[SIZE][SIZE];

	double **NoiseArrayDynamic;
	unsigned char **fileArray;
#endif
