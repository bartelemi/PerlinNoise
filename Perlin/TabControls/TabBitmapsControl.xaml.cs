using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;

namespace Perlin.GUI.TabControls
{
    /// <summary>
    /// Interaction logic for TabBitmapsControl.xaml
    /// </summary>
    public partial class TabBitmapsControl : UserControl, INotifyPropertyChanged
    {
        #region Properties
        FileList _bitmapList = null;

        string _bitmapPath = null;
        public string BitmapPath 
        {
            get { return _bitmapPath; }
            set
            {
                _bitmapPath = value;
                OnPropertyChanged();
            }
        }
        #endregion

        #region Constructor
        public TabBitmapsControl()
        {
            _bitmapList = new FileList(FileType.Bitmap);
            InitializeComponent();
        }
        #endregion

        #region Buttons events
        private void BitmapsTab_Loaded(object sender, RoutedEventArgs e)
        {
            if (_bitmapList.Length > 0)
                BitmapPath = _bitmapList.Peek();
        }

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

        private void PreviousPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            throw new NotImplementedException();   
        }

        private void NextPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            throw new NotImplementedException();   
        }
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
    }
}
