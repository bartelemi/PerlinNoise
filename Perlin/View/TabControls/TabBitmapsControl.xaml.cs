using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;
using Perlin.GUI.Properties;
using Perlin.GUI.ViewModel;

namespace Perlin.GUI.View.TabControls
{
    /// <summary>
    /// Interaction logic for TabBitmapsControl.xaml
    /// </summary>
    public partial class TabBitmapsControl
    {
        #region Constructor
        public TabBitmapsControl()
        {
            //_bitmapList = new FileList(FileType.Bitmap);
            InitializeComponent();
            DataContext = new BitmapsViewModel();
        }
        #endregion // Constructor

        #region Events
        private void BitmapsTab_Loaded(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as BitmapsViewModel;
            if (vm != null)
            {
                vm.TabLoaded();
            }
        }

        #region Main image navigation
        private void PreviousButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as BitmapsViewModel;
            if (vm != null)
            {
                vm.DisplayPreviousImage();
            }
        }

        private void NextButton_click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as BitmapsViewModel;
            if (vm != null)
            {
                vm.DisplayNextImage();
            }
        }
        #endregion // Main image navigation

        #region Preview images navigation
        private void PreviousPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as BitmapsViewModel;
            if (vm != null)
            {
                vm.DisplayPreviousPreviewImages();
            }
        }

        private void NextPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as BitmapsViewModel;
            if (vm != null)
            {
                vm.DisplayNextPreviewImages();
            }
        }
        #endregion // Preview images navigation
        #endregion // Events
    }
}
