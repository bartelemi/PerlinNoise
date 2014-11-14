using System.ComponentModel;

namespace Perlin.GUI.Models
{
    public enum NoiseEffectsBmp
    {
        [Description("Szum")]
        Noise,
        [Description("Sin(szum)")]
        SinOfNoise,
        [Description("Sqrt(|szum|)")]
        SqrtOfNoise,
        [Description("Eksperymentalny-X01")]
        Experimental_1,
        [Description("Eksperymentalny-X02")]
        Experimental_2,
        [Description("Eksperymentalny-X03")]
        Experimental_3
    };
}
