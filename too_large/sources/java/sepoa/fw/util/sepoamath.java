package sepoa.fw.util;

import java.math.BigDecimal;
import java.text.DecimalFormat;

public final class SepoaMath
{
    private SepoaMath()
    {
    }

    public static double getRound(double d, double d1)
    {
        double d2 = 0.0D;

        if (d1 == 0.0D)
        {
            return d;
        }

        if (d1 == 1.0D)
        {
            return (double) Math.round(d);
        }
        else
        {
            double d3 = Math.pow(10D, d1 - 1.0D);
            BigDecimal bigdecimal = 
            	(new BigDecimal(String.valueOf(d))).multiply(new BigDecimal(String.valueOf(d3)));

            return (double) Math.round(bigdecimal.doubleValue()) / d3;
        }
    }

    public static double getCeil(double d, double d1)
    {
        double d2 = 0.0D;

        if (d1 == 0.0D)
        {
            return d;
        }

        if (d1 == 1.0D)
        {
            return Math.ceil(d);
        }
        else
        {
            double d3 = Math.pow(10D, d1 - 1.0D);
            BigDecimal bigdecimal = (new BigDecimal(String.valueOf(d))).multiply(new BigDecimal(String.valueOf(d3)));

            return Math.ceil(bigdecimal.doubleValue()) / d3;
        }
    }

    public static double getFloor(double d, double d1)
    {
        double d2 = 0.0D;

        if (d1 == 0.0D)
        {
            return d;
        }

        if (d1 == 1.0D)
        {
            return Math.floor(d);
        }
        else
        {
            double d3 = Math.pow(10D, d1 - 1.0D);
            BigDecimal bigdecimal = (new BigDecimal(String.valueOf(d))).multiply(new BigDecimal(String.valueOf(d3)));

            return Math.floor(bigdecimal.doubleValue()) / d3;
        }
    }

    public static String SepoaNumberType(double d, String s)
    {
        String s1 = "";
        DecimalFormat decimalformat = new DecimalFormat(s);
        s1 = decimalformat.format(d);

        return s1;
    }

    public static String SepoaNumberType(String s, String s1)
    {
        String s2 = "";
        double d = 0.0D;

        try
        {
            double d1 = Double.parseDouble(s);
            s2 = SepoaNumberType(d1, s1);
        }
        catch (NumberFormatException numberformatexception)
        {
            s2 = s;
        }

        return s2;
    }
}
