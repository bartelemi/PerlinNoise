using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Perlin.Extensions;

namespace Perlin.TabControls
{
    /// <summary>
    /// Interaction logic for TabConfigurationControl.xaml
    /// </summary>
    public partial class TabConfigurationControl : UserControl, INotifyPropertyChanged
    {
        #region Properties

        #region Number of threads
        private int _numberOfThreads;
        public int NumberOfThreads
        {
            get { return _numberOfThreads; }
            set
            {
                _numberOfThreads = value;
                OnPropertyChanged();
            }
        }
        #endregion

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
        #endregion

        #region Noise effect
        NoiseEffects _noiseEffect;
        public NoiseEffects NoiseEffect
        {
            get { return _noiseEffect; }
            set
            {
                _noiseEffect = value;
                OnPropertyChanged();
            }
        }
        #endregion

        #region Noise color
        NoiseColor _noiseColor;
        public NoiseColor CurrentNoiseColor
        {
            get { return _noiseColor; }
            set
            {
                _noiseColor = value;
                OnPropertyChanged();
            }
        }

        #endregion

        #endregion

        public RelayCommand<bool> AutodetectionRelayCommand { get; private set; }

        #region Constructor
        public TabConfigurationControl()
        {
            InitializeComponent();
            
            AutodetectionRelayCommand = new RelayCommand<bool>(isChecked =>
            {
                if (isChecked)
                {
                    NumberOfThreads = System.Environment.ProcessorCount;
                }
            });
        }
        #endregion

        #region Events

        #endregion

        #region INotifyPropertyChanged
        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion

        private void GenerujButton_Clicked(object sender, RoutedEventArgs e)
        {
            
        }
    }
}
