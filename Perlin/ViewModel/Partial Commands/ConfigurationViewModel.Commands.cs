using Perlin.GUI.Helpers;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class ConfigurationViewModel
    {
        #region Commands
        public RelayCommand GeneratePelinNoiseCommand { get; private set; }
        public RelayCommand<bool> IsThreadAutodetectCheckedCommand { get; private set; }
        public RelayCommand SaveGeneratedImageCommand { get; private set; }
        #endregion // Commands

        #region Initialize commands
        private void InitializeCommands()
        {
            InitializeGeneratePelinNoiseCommand();
            InitializeIsThreadAutodetectCheckedCommand();
            InitializeSaveGeneratedImageCommand();
        }

        private void InitializeSaveGeneratedImageCommand()
        {

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
