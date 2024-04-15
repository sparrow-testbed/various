package sepoa.fw.util;

import java.text.DecimalFormat;

public class ParamUtil
{
    public static String getReqParameter(String Req, String ifNulltoReplace) throws Exception
    {
        if ((Req == null) || Req.equals(""))
        {
            return ifNulltoReplace;
        }
        else
        {
            return Req.trim();
        }
    }

    public static String getReqParameter(String Req)
    {
        if ((Req == null) || Req.equals(""))
        {
            return "";
        }
        else
        {
            return Req.trim();
        }
    }

    public static String[] getReqParameter(String[] Req, String ifNulltoReplace) throws Exception
    {
        String[] arrBuf = {  };

        if (Req == null)
        {
            return arrBuf;
        }
        else
        {
            arrBuf = new String[Req.length];

            for (int i = 0; i < Req.length; i++)
            {
                if ((Req[i] == null) || Req[i].equals(""))
                {
                    arrBuf[i] = ifNulltoReplace;
                }
                else
                {
                    arrBuf[i] = Req[i].trim();
                }
            }
        }

        return arrBuf;
    }

    public static String[] getReqParameter(String[] Req)
    {
        String[] arrBuf = {  };

        if (Req == null)
        {
            return arrBuf;
        }
        else
        {
            arrBuf = new String[Req.length];

            for (int i = 0; i < Req.length; i++)
            {
                if ((Req[i] == null) || Req[i].equals(""))
                {
                    arrBuf[i] = "";
                }
                else
                {
                    arrBuf[i] = Req[i].trim();
                }
            }
        }

        return arrBuf;
    }

    public static int getIntParameter(String Req, int ifNulltoReplace) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return ifNulltoReplace;
            }
            else
            {
                return formatFloat.parse(Req.toString()).intValue();
            }
        }
        catch (NumberFormatException e)
        {
            return ifNulltoReplace;
        }
    }

    public static int getIntParameter(String Req) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return 0;
            }
            else
            {
                return formatFloat.parse(Req.toString()).intValue();
            }
        }
        catch (NumberFormatException e)
        {
            return 0;
        }
    }

    public static double getDblParameter(String Req, double ifNulltoReplace) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return ifNulltoReplace;
            }
            else
            {
                return formatFloat.parse(Req.toString()).doubleValue();
            }
        }
        catch (NumberFormatException e)
        {
            return ifNulltoReplace;
        }
    }

    public static double getDblParameter(String Req) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return 0;
            }
            else
            {
                return formatFloat.parse(Req.toString()).doubleValue();
            }
        }
        catch (NumberFormatException e)
        {
            return 0;
        }
    }

    public static long getLngParameter(String Req, long ifNulltoReplace) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return ifNulltoReplace;
            }
            else
            {
                return formatFloat.parse(Req.toString()).longValue();
            }
        }
        catch (NumberFormatException e)
        {
            return ifNulltoReplace;
        }
    }

    public static long getLngParameter(String Req) throws Exception
    {
        try
        {
            DecimalFormat formatFloat = new DecimalFormat();

            if ((Req == null) || Req.equals(""))
            {
                return 0;
            }
            else
            {
                return formatFloat.parse(Req.toString()).longValue();
            }
        }
        catch (NumberFormatException e)
        {
            return 0;
        }
    }
}
