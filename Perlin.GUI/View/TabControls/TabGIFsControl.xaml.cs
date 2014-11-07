using System.Windows;
using Perlin.GUI.ViewModel;

namespace Perlin.GUI.View.TabControls
{
    /// <summary>
    /// Interaction logic for TabGIFsControl.xaml
    /// </summary>
    public partial class TabGIFsControl
    {
        #region Constructor
        public TabGIFsControl()
        {
            InitializeComponent();
            DataContext = new GifsViewModel();
        }
        #endregion

        #region Events
        private void GifsTab_Loaded(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GifsViewModel;
            if (vm != null)
            {
                vm.TabLoaded();
            }
        }

        #region Main GIF navigation
        private void PreviousButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GifsViewModel;
            if (vm != null)
            {
                vm.DisplayPreviousImage();
            }
        }

        private void NextButton_click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GifsViewModel;
            if (vm != null)
            {
                vm.DisplayNextImage();
            }
        }
        #endregion // Main GIF navigation

        #region Preview GIFs navigation
        private void PreviousPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GifsViewModel;
            if (vm != null)
            {
                vm.DisplayPreviousPreviewImages();
            }
        }

        private void NextPreviewButton_Click(object sender, RoutedEventArgs e)
        {
            var vm = DataContext as GifsViewModel;
            if (vm != null)
            {
                vm.DisplayNextPreviewImages();
            }
        }
        #endregion // Preview GIFs navigation
        #endregion // Events
    }
}
