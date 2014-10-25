using System.Windows.Controls;

namespace Perlin.GUI.Models
{
    public class TabItem
    {
        public string HeaderText { get; set; }
        public string HeaderImageSource { get; set; }
        public UserControl UserControl { get; set; }
    }
}
