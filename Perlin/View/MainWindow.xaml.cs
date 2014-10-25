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
        [DllImport("Kernel32")]
        public static extern void AllocConsole();

        [DllImport("Kernel32")]
        public static extern void FreeConsole();

        [DllImport("PerlinNoise_C.dll")]
        public static extern void DisplayHelloFromDLL();

        public MainWindow()
        {
            InitializeComponent();

            /*AllocConsole();
            Console.WriteLine("Hello from C#!");
            DisplayHelloFromDLL();
            Console.ReadLine();*/
        }
    }
}
