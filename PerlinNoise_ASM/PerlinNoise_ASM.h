// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the PERLINNOISE_ASM_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// PERLINNOISE_ASM_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef PERLINNOISE_ASM_EXPORTS
#define PERLINNOISE_ASM_API __declspec(dllexport)
#else
#define PERLINNOISE_ASM_API __declspec(dllimport)
#endif

// This class is exported from the PerlinNoise_ASM.dll
class PERLINNOISE_ASM_API CPerlinNoise_ASM {
public:
	CPerlinNoise_ASM(void);
	// TODO: add your methods here.
};

extern PERLINNOISE_ASM_API int nPerlinNoise_ASM;

PERLINNOISE_ASM_API int fnPerlinNoise_ASM(void);
