using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using Perlin.GUI.ViewModel;

namespace Perlin.GUI.View.TabControls
{
    /// <summary>
    /// Interaction logic for TabConfigurationControl.xaml
    /// </summary>
    public partial class TabConfigurationControl
    {
        #region Fields
        private readonly Regex _regex = null;
        #endregion //Fields

        #region Constructor
        public TabConfigurationControl()
        {
            _regex = new Regex("[^0-9.-]+");
            InitializeComponent();
            DataContext = new ConfigurationViewModel();
        }
        #endregion // Constructor

        #region Events
        private void PreviewPersistenceInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !IsTextAllowed(e.Text);
        }

        private void PastingPersistenceHandler(object sender, DataObjectPastingEventArgs e)
        {
            if (e.DataObject.GetDataPresent(typeof(string)))
            {
                var text = (string)e.DataObject.GetData(typeof(string));
                if (!IsTextAllowed(text))
                {
                    e.CancelCommand();
                }
            }
            else
            {
                e.CancelCommand();
            }
        }

        private bool IsTextAllowed(string s)
        {
            return !_regex.IsMatch(s);
        }

        #endregion // Events
    }
}
