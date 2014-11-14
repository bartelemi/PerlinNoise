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
        //[DllImport("Kernel32")]
        //public static extern void AllocConsole();

        //[DllImport("Kernel32")]
        //public static extern void FreeConsole();

        public MainWindow()
        {
            //AllocConsole();
            InitializeComponent();
            DataContext = new MainWindowViewModel();
        }
    }
}
