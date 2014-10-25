using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;
using Perlin.GUI.Properties;

namespace Perlin.GUI.View.TabControls
{
    /// <summary>
    /// Interaction logic for TabBitmapsControl.xaml
    /// </summary>
    public partial class TabBitmapsControl : INotifyPropertyChanged
    {
        #region Properties
        readonly FileList _bitmapList = null;

        string _bitmapPath = null;
        public string BitmapPath 
        {
            get { return _bitmapPath; }
            set
            {
                if (value == _bitmapPath) return;
                _bitmapPath = value;
                OnPropertyChanged();
            }
        }
        #endregion // Properties

        #region Constructor
        public TabBitmapsControl()
        {
            InitializeComponent();
            _bitmapList = new FileList(FileType.Bitmap);
        }
        #endregion // Constructor

        #region Events
        private void BitmapsTab_Loaded(object sender, RoutedEventArgs e)
        {
            if (_bitmapList.Length > 0)
                BitmapPath = _bitmapList.Peek();
        }

        #region Main image navigation
        private void PreviousButton_Click(object sender, RoutedEventArgs e)
        {
            if (_bitmapList.Length > 0)
                BitmapPath = _bitmapList.Prev();
        }

        private void NextButton_click(object sender, RoutedEventArgs e)
        {
            if (_bitmapList.Length > 0)
                BitmapPath = _bitmapList.Next();
        }
        #endregion // Main image navigation

        #region Preview images navigation
        private void PreviousPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            
        }

        private void NextPreviewButton_Click(object sender, RoutedEventArgs e)
        {
               
        }
        #endregion // Preview images navigation
        #endregion // Events

        #region INotifyPropertyChanged
        public event PropertyChangedEventHandler PropertyChanged;
        [NotifyPropertyChangedInvocator]
        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion // INotifyPropertyChanged
    }
}
