using System.Runtime.InteropServices;

namespace Perlin.GUI.Models.RunParameters
{
    [StructLayout(LayoutKind.Sequential)]
    public struct ThreadParameters
    {
        public unsafe uint* ImageByteArrayPointer;
        public int CurrentImageOffset;
        public int ImageWidth;
        public int ImageHeight;
        public int CurrentImageHeight;
        public RGBColor NoiseColor;
        public int NoiseEffect;
        public int NumberOfOctaves;
        public double Persistence;
        public int ThreadId;
        public int NumberOfThreads;
    }
}