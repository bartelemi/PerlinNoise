using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;

namespace Perlin.TabControls
{
    /// <summary>
    /// Interaction logic for TabGIFsControl.xaml
    /// </summary>
    public partial class TabGIFsControl : UserControl, INotifyPropertyChanged
    {
        #region Properties
        FileList _gifsList = null;

        string _gifPath = null;
        public string GifPath
        {
            get { return _gifPath; }
            set
            {
                _gifPath = value;
                OnPropertyChanged();
            }
        }
        #endregion

        #region Constructor
        public TabGIFsControl()
        {
            _gifsList = new FileList(FileType.Gif);
            InitializeComponent();
        }
        #endregion

        #region Buttons events
        private void GIFsTab_Loaded(object sender, RoutedEventArgs e)
        {
            GifPath = _gifsList.Peek();
        }
        private void NextButton_click(object sender, RoutedEventArgs e)
        {
            GifPath = _gifsList.Next();
        }

        private void PreviousButton_Click(object sender, RoutedEventArgs e)
        {
            GifPath = _gifsList.Prev();
        }

        private void NextPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void PreviousPreviewButton_Click(object sender, RoutedEventArgs e)
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
