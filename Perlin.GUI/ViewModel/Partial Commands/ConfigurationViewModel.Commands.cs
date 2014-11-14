using System;
using System.IO;
using Perlin.GUI.Helpers;
using Perlin.GUI.Kernel;
using Perlin.GUI.Models;
using Microsoft.Win32;
using Perlin.GUI.Models.RunParameters;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class ConfigurationViewModel
    {
        #region Commands
        public RelayCommand GeneratePelinNoiseCommand { get; private set; }
        public RelayCommand<bool> IsThreadAutodetectCheckedCommand { get; private set; }
        public RelayCommand SaveGeneratedFileCommand { get; private set; }
        #endregion // Commands

        #region Initialize commands
        private void InitializeCommands()
        {
            InitializeGeneratePelinNoiseCommand();
            InitializeIsThreadAutodetectCheckedCommand();
            InitializeSaveGeneratedFileCommand();
        }

        private void InitializeSaveGeneratedFileCommand()
        {
            SaveGeneratedFileCommand = new RelayCommand(() =>
            {
                var isBitmap = (GeneratedFileType == FileType.Bitmap);
                var fileExtension = isBitmap ? ".bmp" : ".gif";

                var saveFileDialog = new SaveFileDialog
                {
                    FileName = string.Format("PerlinNoise_{0}", DateTime.Now.ToString("yyyy-MM-dd HH#mm#ss")),
                    DefaultExt = fileExtension,
                    Filter = (isBitmap ? "Bitmap files (*.bmp)|*.bmp"
                                       : "GIF files (*.gif)|*.gif")
                                       + "|All Files (*.*)|*.*",
                    InitialDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location)
                                       + (isBitmap ? @"\output\bitmaps" : @"\output\gifs"),
                    CheckPathExists = true,
                    ValidateNames = true
                };

                var result = saveFileDialog.ShowDialog();

                if (result.HasValue)
                    SaveFile(saveFileDialog.FileName);
            });
        }

        private void InitializeIsThreadAutodetectCheckedCommand()
        {
            IsThreadAutodetectCheckedCommand = new RelayCommand<bool>(isChecked =>
            {
                if (isChecked)
                {
                    NumberOfThreads = System.Environment.ProcessorCount;
                }
            });
        }

        private void InitializeGeneratePelinNoiseCommand()
        {
            GeneratePelinNoiseCommand = new RelayCommand(async () =>
            {
                _perlinDllManager = new PerlinDllManager(new GeneratorParameters()
                {
                    GeneratedFileType = FileType.Bitmap,
                    GeneratingLibrary = Library.PureC,
                    NumberOfThreads = NumberOfThreads,
                    NumberOfOctaves = NumberOfOctaves,
                    Persistence = Persistence,
                    Width = Width,
                    Height = Height,
                    GeneratingBitmapParameters = new BitmapParameters()
                    {
                        NoiseColorBmp = new RGBColor()
                        {
                            R = NoiseColorBmp.R,
                            G = NoiseColorBmp.G,
                            B = NoiseColorBmp.B
                        },
                        NoiseEffectsBmp = NoiseEffectBmp
                    },
                    GeneratingGifParameters = null
                });

                ProgramState = GeneratorState.ComputingFile;
                _stopwatch.Start();
                GeneratedFileArray = await _perlinDllManager.GeneratePerlinNoiseFileAsync();
                _stopwatch.Stop();
                ProgramState = GeneratorState.GeneratedFile;
            });
        }
        #endregion // Initialize commands
    }
}
