using System;
using System.IO;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;
using Microsoft.Win32;

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

        }
        #endregion // Initialize commands
    }
}
