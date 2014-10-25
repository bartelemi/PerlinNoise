using Perlin.GUI.Helpers;
using Perlin.GUI.View.TabControls;

namespace Perlin.GUI.ViewModel
{
    public partial class MainWindowViewModel
    {
        #region Commands
        public RelayCommand GeneratePelinNoiseCommand { get; private set; }
        public RelayCommand<bool> IsThreadAutodetectCheckedCommand { get; private set; }
        public RelayCommand SaveGeneratedImageCommand { get; private set; }
        #endregion // Commands

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
            
        }

        private void InitializeGeneratePelinNoiseCommand()
        {
            
        }
    }
}
