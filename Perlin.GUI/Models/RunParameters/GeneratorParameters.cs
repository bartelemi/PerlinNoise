using System;
namespace Perlin.GUI.Models.RunParameters
{
    class GeneratorParameters
    {
        public int NumberOfThreads { get; set; }
        public double Persistence { get; set; }
        public Library GeneratingLibrary { get; set; }
        public int NumberOfOctaves { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public RGBColor Color { get; set; }
        public NoiseEffects BitmapEffect { get; set; }
        public override string ToString()
        {
            return string.Format("NumberOfThreads: {0}, GeneratingLibrary: {1}",
                                  NumberOfThreads, GeneratingLibrary);
        }
    }
}
