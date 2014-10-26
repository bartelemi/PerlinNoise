using System.Collections.ObjectModel;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;
using Perlin.GUI.View.TabControls;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class MainWindowViewModel : ViewModelBase
    {
        #region Properties
        public ObservableCollection<TabItem> TabItems { get; set; }
        #endregion // Properties

        private void InitializeTabs()
        {
            TabItems = new ObservableCollection<TabItem>
            {
                new TabItem()
                {
                    HeaderText = "Konfiguracja",
                    HeaderImageSource = "../Resources/Images/Tab icons/Config.png",
                    UserControl = new TabConfigurationControl()
                },
                new TabItem()
                {
                    HeaderText = "Podgląd obrazów",
                    HeaderImageSource = "../Resources/Images/Tab icons/Bitmap.png",
                    UserControl = new TabBitmapsControl()
                },
                new TabItem()
                {
                    HeaderText = "Podgląd animacji",
                    HeaderImageSource = "../Resources/Images/Tab icons/GIF.png",
                    UserControl = new TabGIFsControl()
                }
            };
        }

        private int _selectedIndex = 0;
        public int SelectedIndex
        {
            get { return _selectedIndex; }
            set
            {
                if (value == _selectedIndex) return;
                _selectedIndex = value;
                OnPropertyChanged();
            }
        }

        public MainWindowViewModel()
        {
            InitializeTabs();
            InitializeCommands();
        }

    }
}
