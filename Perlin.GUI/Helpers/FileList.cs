using System.IO;
using Perlin.GUI.Models;

namespace Perlin.GUI.Helpers
{
    class FileList
    {
        #region Fields
        private readonly string[] _filePathList = null;
        private int _currentFileIndex = 0;
        #endregion // Fields

        #region Properties
        public int Length
        {
            get { return _filePathList.Length; }
        }
        public string CurrentLocation { get; private set; }
        #endregion // Properties

        #region Constructor
        public FileList()
        {
            string workingPath = null;
            CurrentLocation = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            workingPath = CurrentLocation + @"\output\bitmaps";
            _filePathList = Directory.GetFiles(workingPath, "*.bmp");
        }
        #endregion // Constructor

        #region Image navigation
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
        #endregion // Image navigation
    }
}
