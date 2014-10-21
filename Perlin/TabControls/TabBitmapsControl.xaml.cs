using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Text;
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

namespace Perlin.TabControls
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
            set { SetField(ref _bitmapPath, value, "BitmapPath"); }
        }
        #endregion

        #region Constructor
        public TabBitmapsControl()
        {
            _bitmapList = new FileList(FileType.Bitmap);
            InitializeComponent();

            if (_bitmapList.Length == 0)
            {

            }
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
        protected virtual void OnPropertyChanged(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
                handler(this, new PropertyChangedEventArgs(propertyName));
        }

        protected bool SetField<T>(ref T field, T value, string propertyName)
        {
            if (EqualityComparer<T>.Default.Equals(field, value))
                return false;
            field = value;
            OnPropertyChanged(propertyName);
            return true;
        }

        #endregion
    }
}
