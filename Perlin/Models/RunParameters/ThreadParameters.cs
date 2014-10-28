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
        public double Persistence;
        public int NoiseColor;
        public int NoiseEffect;
        public int IdOfThread;
        public int NumberOfThreads;
    }
}
