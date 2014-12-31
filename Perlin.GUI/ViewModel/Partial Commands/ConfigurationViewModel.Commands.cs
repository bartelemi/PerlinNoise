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
                var fileExtension = ".bmp";

                var saveFileDialog = new SaveFileDialog
                {
                    FileName = string.Format("PerlinNoise_{0}", DateTime.Now.ToString("yyyy-MM-dd HH#mm#ss")),
                    DefaultExt = fileExtension,
                    Filter = "Bitmap files (*.bmp)|*.bmp"
                           + "|All Files (*.*)|*.*",
                    InitialDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location)
                                     + @"\output\bitmaps",
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
                    GeneratingLibrary = GeneratingLibrary,
                    NumberOfThreads = NumberOfThreads,
                    NumberOfOctaves = NumberOfOctaves,
                    Persistence = Persistence,
                    Width = Width,
                    Height = Height,
                    BitmapEffect = NoiseEffectBmp,
                    Color = new RGBColor()
                    {
                        R = NoiseColor.R,
                        G = NoiseColor.G,
                        B = NoiseColor.B
                    }
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
