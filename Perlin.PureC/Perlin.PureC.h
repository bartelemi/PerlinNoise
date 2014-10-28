#ifdef PERLINPUREC_EXPORTS
#define PERLINPUREC_API __declspec(dllexport)
#else
#define PERLINPUREC_API __declspec(dllimport)
#endif

#include <time.h>

PERLINPUREC_API void GeneratePerlinNoiseBitmap(ThreadParameters params);

PERLINPUREC_API void GeneratePerlinNoiseGif(ThreadParameters params);