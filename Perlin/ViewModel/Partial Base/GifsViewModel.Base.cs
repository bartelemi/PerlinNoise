using Perlin.GUI.Helpers;
using Perlin.GUI.Models;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class GifsViewModel : ViewModelBase
    {
        #region Fields
        private readonly FileList _gifsList = null;
        #endregion // Fields

        #region Properties
        private string _gifPath = null;
        public string GifPath
        {
            get { return _gifPath; }
            set
            {
                _gifPath = value;
                OnPropertyChanged();
            }
        }

        public bool IsListFilled
        {
            get { return (_gifsList.Length > 0); }
        }
        #endregion // Properties

        #region Constructor
        public GifsViewModel()
        {
            _gifsList = new FileList(FileType.Gif);
            InitializeCommands();
        }
        #endregion // Constructor

        #region Change view
        /// <summary>
        /// Launched each time this tab is loaded
        /// </summary>
        internal void TabLoaded()
        {
            if (IsListFilled)
            {
                GifPath = _gifsList.Peek();

                // TODO: add loading for preview images
            }
        }

        #region Main image displaying
        internal void DisplayPreviousImage()
        {
            if (IsListFilled)
                GifPath = _gifsList.Prev();
        }

        internal void DisplayNextImage()
        {
            if (IsListFilled)
                GifPath = _gifsList.Next();
        }
        #endregion // Main image displaying

        #region Preview displaying
        internal void DisplayPreviousPreviewImages()
        {
            if (IsListFilled)
            {
                ;
            }
        }

        internal void DisplayNextPreviewImages()
        {
            if (IsListFilled)
            {
                ;
            }
        }
        #endregion // Preview displaying
        #endregion // Change view
    }
}
