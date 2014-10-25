namespace Perlin.GUI.Models.RunParameters
{
    class GeneratorParameters
    {
        public int NumberOfThreads { get; set; }
        public Library GeneratingLibrary { get; set; }
        public FileType GeneratedFileType { get; set; }
        public BitmapParameters BitmapParameters { get; set; }
        public GifParameters GifParameters { get; set; }

        public override string ToString()
        {
            return string.Format("NumberOfThreads: {0}, GeneratingLibrary: {1}, FileType: {2}",
                                  NumberOfThreads, GeneratingLibrary, GeneratedFileType);
        }
    }
}
