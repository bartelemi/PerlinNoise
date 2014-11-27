using System.Windows;
using System.Runtime.InteropServices;
using Perlin.GUI.ViewModel;

namespace Perlin.GUI.View
{   
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            DataContext = new MainWindowViewModel();
        }
    }
}
