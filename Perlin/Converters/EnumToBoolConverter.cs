using System;
using System.Globalization;
using System.Windows.Data;

namespace Perlin.GUI.Converters
{
    [ValueConversion(typeof(Enum), typeof(bool))]
    public class EnumToBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null || parameter == null)
            {
                return false;
            }
            else
            {
                var inverse = false;
                var enumValue = value.ToString();
                var targetValue = parameter.ToString();

                if (targetValue.StartsWith("!"))
                {
                    inverse = true;
                    targetValue = targetValue.Substring(1);
                }

                var outputValue = enumValue.Equals(targetValue, StringComparison.InvariantCultureIgnoreCase);
                return inverse ? !outputValue : outputValue;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null || parameter == null)
            {
                return null;
            }
            else
            {
                var useValue = (bool)value;
                var targetValue = parameter.ToString();
                if (useValue)
                {
                    return Enum.Parse(targetType, targetValue);
                }
                else
                {
                    return null;     
                }
            }
        }
    }
}
