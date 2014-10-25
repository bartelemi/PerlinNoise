using System.ComponentModel;

namespace Perlin.GUI.Models
{
    public enum NoiseEffects
    {
        [Description("Zwykły szum")]
        Noise,
        [Description("Sin(szum)")]
        SinOfNoise,
        [Description("Sqrt(szum)")]
        SqrtOfNoise,
        [Description("Inny efekt")]
        OtherEffect
    };
}
