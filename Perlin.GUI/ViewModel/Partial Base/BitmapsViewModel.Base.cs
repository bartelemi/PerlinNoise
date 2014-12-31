using Perlin.GUI.Helpers;
using Perlin.GUI.Models;

namespace Perlin.GUI.ViewModel
{
    public sealed partial class BitmapsViewModel : ViewModelBase
    {
        #region Fields
        private readonly FileList _bitmapsList = null;
        #endregion // Fields

        #region Properties
        private string _bitmapPath = null;
        public string BitmapPath
        {
            get { return _bitmapPath; }
            set
            {
                if (value == _bitmapPath) return;
                _bitmapPath = value;
                OnPropertyChanged();
            }
        }

        public bool IsListFilled
        {
            get { return (_bitmapsList.Length > 0); }
        }
        #endregion // Properties

        #region Constructor
        public BitmapsViewModel()
        {
            InitializeCommands();
            _bitmapsList = new FileList();
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
                BitmapPath = _bitmapsList.Peek();

                // TODO: add loading for preview images
            }
        }

        #region Main image displaying
        internal void DisplayPreviousImage()
        {
            if (IsListFilled)
                BitmapPath = _bitmapsList.Prev();
        }

        internal void DisplayNextImage()
        {
            if (IsListFilled)
                BitmapPath = _bitmapsList.Next();
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
