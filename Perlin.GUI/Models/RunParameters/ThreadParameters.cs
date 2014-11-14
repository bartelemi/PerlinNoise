using System;
using System.Runtime.InteropServices;

namespace Perlin.GUI.Models.RunParameters
{
    [StructLayout(LayoutKind.Sequential)]
    public struct ThreadParameters
    {
        public unsafe uint* ImageByteArrayPointer;
        public int CurrentImageOffset;
        public unsafe uint ImageWidth;
        public unsafe uint ImageHeight;
        public unsafe uint CurrentImageHeight;
        public RGBColor NoiseColor;
        public int NoiseEffect;
        public int NumberOfOctaves;
        public double Persistence;
        public int ThreadId;
        public int NumberOfThreads;
    }
}