namespace Perlin.GUI.Models.RunParameters
{
    class GeneratorParameters
    {
        public int NumberOfThreads { get; set; }
        public Library GeneratingLibrary { get; set; }
        public FileType GeneratedFileType { get; set; }
        public int NumberOfOctaves { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public BitmapParameters GeneratingBitmapParameters { get; set; }
        public GifParameters GeneratingGifParameters { get; set; }

        public override string ToString()
        {
            return string.Format("NumberOfThreads: {0}, GeneratingLibrary: {1}, FileType: {2}",
                                  NumberOfThreads, GeneratingLibrary, GeneratedFileType);
        }
    }
}
