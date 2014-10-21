using System;
using System.Collections.Generic;
using System.Linq;
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
using System.Runtime.InteropServices;

namespace Perlin
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
