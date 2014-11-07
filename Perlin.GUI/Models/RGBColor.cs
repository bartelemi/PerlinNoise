using System.Runtime.InteropServices;

namespace Perlin.GUI.Models
{
    [StructLayout(LayoutKind.Sequential)]
    public struct RGBColor
    {
        public byte B;
        public byte G;
        public byte R;
    }
}
