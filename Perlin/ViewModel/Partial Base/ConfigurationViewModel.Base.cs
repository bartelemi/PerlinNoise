using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class ConfigurationViewModel : ViewModelBase
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
        #endregion // Number of threads

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
        #endregion // Noise effect

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

        #endregion // Noise color

        #region Thread autodetection
        private bool _isAutodetectionChecked;
        public bool IsAutodetectionChecked
        {
            get { return _isAutodetectionChecked; }
            set
            {
                if (value == _isAutodetectionChecked) return;
                _isAutodetectionChecked = value;
                OnPropertyChanged();
            }
        }
        #endregion // Thread autodetection
        #endregion // Properties

        public ConfigurationViewModel()
        {
            InitializeCommands();
        }
    }
}
