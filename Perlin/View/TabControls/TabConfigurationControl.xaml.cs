using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using Perlin.GUI.Helpers;
using Perlin.GUI.Models;
using Perlin.GUI.Properties;
using Perlin.GUI.ViewModel;

namespace Perlin.GUI.View.TabControls
{
    /// <summary>
    /// Interaction logic for TabConfigurationControl.xaml
    /// </summary>
    public partial class TabConfigurationControl
    {
        #region Constructor
        public TabConfigurationControl()
        {
            InitializeComponent();
            DataContext = new ConfigurationViewModel();
        }
        #endregion // Constructor

        #region Events

        private void GenerujButton_Clicked(object sender, RoutedEventArgs e)
        {

        }

        #endregion // Events
    }
}
