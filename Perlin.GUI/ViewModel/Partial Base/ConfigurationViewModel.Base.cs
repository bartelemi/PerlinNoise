using System;
using System.IO;
using System.Windows.Media;
using Perlin.GUI.Helpers;
using Perlin.GUI.Kernel;
using Perlin.GUI.Models;
using System.Windows;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class ConfigurationViewModel : ViewModelBase
    {
        #region Fields
        private PerlinDllManager _perlinDllManager { get; set; }
        private readonly Stopwatch _stopwatch;
        private readonly int _maxFileSize;
        private readonly int _minFileSize ;
        #endregion // Fields

        #region Properties

        #region GenerationTime
        private TimeSpan _generationTime;
        public TimeSpan GenerationTime
        {
            get { return _generationTime; }
            set
            {
                if (value.Equals(_generationTime)) return;
                _generationTime = value;
                OnPropertyChanged();
            }
        }
        #endregion // GenerationTime

        #region Program state
        private GeneratorState _programState;
        public GeneratorState ProgramState
        {
            get { return _programState; }
            set 
            { 
                if(value == _programState) return;
                _programState = value;
                OnPropertyChanged();
            }
        }
        #endregion // Program state

        #region Generated file array
        private byte[] _generatedFileArray;
        public byte[] GeneratedFileArray
        {
            get { return _generatedFileArray; }
            set
            {
                if(value == _generatedFileArray) return;
                _generatedFileArray = value;
                OnPropertyChanged();
            }
        }
        #endregion // Generated file array

        #region Main

        #region Generating library
        private Library _generatingLibrary;
        public Library GeneratingLibrary
        {
            get { return _generatingLibrary; }
            set
            {
                if (value == _generatingLibrary) return;
                _generatingLibrary = value; 
                OnPropertyChanged();
            }
        }
        #endregion // Generating library

        #region File type
        private FileType _fileType;
        public FileType GeneratedFileType
        {
            get { return _fileType; }
            set
            {
                if(value == _fileType) return;
                _fileType = value;
                OnPropertyChanged();
            }
        }
        #endregion // File type

        #region Number of threads
        private int _numberOfThreads;
        public int NumberOfThreads
        {
            get { return _numberOfThreads; }
            set
            {
                if (value == _numberOfThreads) return;
                _numberOfThreads = value;
                OnPropertyChanged();
            }
        }
        #endregion // Number of threads

        #region Size
        private int _height;
        public int Height
        {
            get { return _height; }
            set
            {
                if (value == _height) return;
                if (value > _maxFileSize) value = _maxFileSize;
                if (value < _minFileSize) value = _minFileSize;
                _height = value;
                OnPropertyChanged();
            }
        }

        private int _width;
        public int Width
        {
            get { return _width; }
            set
            {
                if (value == _width) return;
                if (value > _maxFileSize) value = _maxFileSize;
                if (value < _minFileSize) value = _minFileSize;
                _width = value;
                OnPropertyChanged();
            }
        }
        #endregion // Size
        #endregion // Main

        #region Generator
        #region Number of octaves
        private int _numberOfOctaves;
        public int NumberOfOctaves
        {
            get { return _numberOfOctaves; }
            set
            {
                if (value < 1) value = 1;
                if (value > 50) value = 50;
                _numberOfOctaves = value;
                OnPropertyChanged();
            }
        }
        #endregion // Number of octaves

        #region Persistence
        private double _persistence;

        public double Persistence
        {
            get { return _persistence; }
            set
            {
                if (value > 0)
                {
                    _persistence = value;
                    OnPropertyChanged();
                }
            }
        }
        #endregion // Persistence
        #endregion // Generator

        #region Bitmap options
        #region Noise effect bitmap
        NoiseEffects _noiseEffectBmp;
        public NoiseEffects NoiseEffectBmp
        {
            get { return _noiseEffectBmp; }
            set
            {
                _noiseEffectBmp = value;
                OnPropertyChanged();
            }
        }
        #endregion // Noise effect bitmap

        #region Noise color bitmap

        private System.Windows.Media.Color _noiseColor;
        public System.Windows.Media.Color NoiseColor
        {
            get { return _noiseColor; }
            set
            {
                if (value == _noiseColor) return;
                _noiseColor = value;
                OnPropertyChanged();
            }
        }

        #endregion // Noise color bitmap
        #endregion // Bitmap options

        #region GIF options
        #region Noise effect GIF
        NoiseEffects _noiseEffectGif;
        public NoiseEffects NoiseEffectGif
        {
            get { return _noiseEffectGif; }
            set
            {
                _noiseEffectGif = value;
                OnPropertyChanged();
            }
        }
        #endregion // Noise effect GIF

        #region Noise color GIF
        NoiseColorGIF _noiseColorGif;
        public NoiseColorGIF CurrentNoiseColorGif
        {
            get { return _noiseColorGif; }
            set
            {
                _noiseColorGif = value;
                OnPropertyChanged();
            }
        }

        #endregion // Noise color GIF

        #endregion // GIF options
        #endregion // Properties

        #region Constructor
        public ConfigurationViewModel()
        {
            _minFileSize = 10;
            _maxFileSize = 20000;

            InitializeCommands();
            InitializeProperties();

            _stopwatch = new Stopwatch(TimeSpan.FromMilliseconds(10));
            _stopwatch.Updated += updatedTime => { GenerationTime = updatedTime; };
        }

        private void InitializeProperties()
        {
            ProgramState = GeneratorState.WaitinfForUserAction;

            GeneratingLibrary = Library.PureC;
            GeneratedFileType = FileType.Bitmap;
            Width = Height = 1000;

            NumberOfThreads = 1;
            NumberOfOctaves = 6;
            Persistence = 1.0;

            NoiseEffectBmp = NoiseEffects.SinOfNoise;
            NoiseColor = new Color();
            NoiseColor = Color.FromRgb(50, 100, 200);
        }

        #endregion // Constructor

        #region User interface handling
        private void SaveFile(string path)
        {
            try
            {
                File.WriteAllBytes(path, GeneratedFileArray);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        #endregion // User interface handling
    }
}
