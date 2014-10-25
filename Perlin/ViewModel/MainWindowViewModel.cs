using Perlin.GUI.Helpers;

namespace Perlin.GUI.ViewModel
{
    class MainWindowViewModel : ViewModelBase
    {
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


    }
}
