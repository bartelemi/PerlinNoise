namespace Perlin
{
    public enum FileType
    {
        Bitmap,
        Gif
    };

    class FileList
    {
        private readonly string _workingPath = null;
        private readonly string[] _filePathList = null;
        private int _currentFileIndex = 0;

        public int Length
        {
            get { return _filePathList.Length; }
        }

        public FileList(FileType ft)
        {
            switch (ft)
            {
                case FileType.Bitmap:
                    _workingPath = System.IO.Directory.GetCurrentDirectory() + @"\output\bitmaps";
                    _filePathList = System.IO.Directory.GetFiles(_workingPath, "*.bmp");
                    break;
                case FileType.Gif:
                    _workingPath = System.IO.Directory.GetCurrentDirectory() + @"\output\gifs";
                    _filePathList = System.IO.Directory.GetFiles(_workingPath, "*.gif");
                    break;
            }
        }

        internal string Peek()
        {
            if (_filePathList.Length > 0)
            {
                return _filePathList[_currentFileIndex];
            }
            else
            {
                return null;
            }
        }
        internal string Prev()
        {
            --_currentFileIndex;
            if (_currentFileIndex < 0)
                _currentFileIndex = _filePathList.Length - 1;
            return Peek();
        }

        internal string Next()
        {
            ++_currentFileIndex;
            if (_currentFileIndex > _filePathList.Length - 1)
                _currentFileIndex = 0;
            return Peek();
        }

    }
}
