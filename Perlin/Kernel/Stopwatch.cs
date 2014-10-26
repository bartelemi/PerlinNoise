using System;
using System.Timers;

namespace Perlin.GUI.Kernel
{
    /// <summary>
    /// Provides calculation of elapsed time.
    /// </summary>
    class Stopwatch
    {
        #region Fields
        private readonly Timer _computationTimer;
        private DateTime _computationStartTime;
        #endregion // Fields

        #region Properties
        public delegate void UpdatedEventHandler(TimeSpan updatedTime);
        public event UpdatedEventHandler Updated;
        #endregion // Properties

        #region Constructor
        public Stopwatch(TimeSpan refresh)
        {
            _computationTimer = new Timer(refresh.TotalSeconds);
            _computationTimer.Elapsed += (obj, events) =>
            {
                if (Updated == null)
                    return;
                Updated(DateTime.Now - _computationStartTime);
            };
        }
        #endregion // Constructor

        #region Timer start/stop
        public void Start()
        {
            _computationStartTime = DateTime.Now;
            _computationTimer.Start();
        }

        public void Stop()
        {
            _computationTimer.Stop();
        }
        #endregion // Timer start/stop
    }
}
