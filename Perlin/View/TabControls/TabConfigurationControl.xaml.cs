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


        #endregion // Events
    }
}
