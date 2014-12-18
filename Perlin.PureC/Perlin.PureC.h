#ifdef PERLINPUREC_EXPORTS
#define PERLINPUREC_API __declspec(dllexport)
#else
#define PERLINPUREC_API __declspec(dllimport)
#endif

#include "stdafx.h"

PERLINPUREC_API void Init(size_t width, size_t height);
PERLINPUREC_API void Finalize(size_t height);
PERLINPUREC_API void GeneratePerlinNoiseBitmap(ThreadParameters params);
