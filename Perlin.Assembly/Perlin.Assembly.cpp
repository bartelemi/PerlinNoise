// Perlin.Assembly.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "Perlin.Assembly.h"


// This is an example of an exported variable
PERLINASSEMBLY_API int nPerlinAssembly=0;

// This is an example of an exported function.
PERLINASSEMBLY_API int fnPerlinAssembly(void)
{
	return 42;
}

// This is the constructor of a class that has been exported.
// see Perlin.Assembly.h for the class definition
CPerlinAssembly::CPerlinAssembly()
{
	return;
}
