// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the PERLINASSEMBLY_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// PERLINASSEMBLY_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef PERLINASSEMBLY_EXPORTS
#define PERLINASSEMBLY_API __declspec(dllexport)
#else
#define PERLINASSEMBLY_API __declspec(dllimport)
#endif

// This class is exported from the Perlin.Assembly.dll
class PERLINASSEMBLY_API CPerlinAssembly {
public:
	CPerlinAssembly(void);
	// TODO: add your methods here.
};

extern PERLINASSEMBLY_API int nPerlinAssembly;

PERLINASSEMBLY_API int fnPerlinAssembly(void);
