package sepoa.fw.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public final class SepoaDate
{
    private SepoaDate()
    {
    }

    public static void isDate(String s, String s1) throws ParseException
    {
        if (s == null)
        {
            throw new NullPointerException("date string to check is null");
        }

        if (s1 == null)
        {
            throw new NullPointerException("format string to check date is null");
        }

        SimpleDateFormat simpledateformat = new SimpleDateFormat(s1, Locale.KOREA);
        Date date = null;

        try
        {
            date = simpledateformat.parse(s);
        }
        catch (ParseException parseexception)
        {
            throw new ParseException(parseexception.getMessage() + " with format \"" + s1 + "\"", parseexception.getErrorOffset());
        }

        if (! simpledateformat.format(date).equals(s))
        {
            throw new ParseException("Out of bound date:\"" + s + "\" with format \"" + s1 + "\"", 0);
        }
        else
        {
            return;
        }
    }

    public static String getDateString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);

        return simpledateformat.format(new Date());
    }

    public static String getFormatString(String s)
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s, Locale.KOREA);
        String s1 = simpledateformat.format(new Date());

        return s1;
    }

    public static String getFormatString(String s, String s1)
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s1, Locale.KOREA);
        String s2 = simpledateformat.format(s);

        return s2;
    }

    public static int getYear()
    {
        return getNumberByPattern("yyyy");
    }

    public static int getMonth()
    {
        return getNumberByPattern("MM");
    }

    public static int getDay()
    {
        return getNumberByPattern("dd");
    }

    private static int getNumberByPattern(String s)
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat(s, Locale.KOREA);
        String s1 = simpledateformat.format(new Date());

        return Integer.parseInt(s1);
    }

    public static String getShortDateString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMdd", Locale.KOREA);

        return simpledateformat.format(new Date());
    }

    public static String getShortTimeString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("HHmmss", Locale.KOREA);

        return simpledateformat.format(new Date());
    }

    public static String getTimeStampString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd-HH:mm:ss:SSS", Locale.KOREA);

        return simpledateformat.format(new Date());
    }

    public static String getTimeString()
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("HH:mm:ss", Locale.KOREA);

        return simpledateformat.format(new Date());
    }

    public static int getFirstMonth(int i, int j, int k)
    {
        Calendar calendar = Calendar.getInstance();
        Calendar calendar1 = Calendar.getInstance();
        calendar = Calendar.getInstance();
        calendar.set(1, i);
        calendar.set(2, j - 1);
        calendar.set(5, 1);
        calendar1 = calendar;

        int l = calendar1.get(1);
        int i1 = calendar1.get(2) + 1;
        int j1 = calendar1.get(5);

        return calendar1.get(7) - 1;
    }

    public static int getDaysInMonth(int i, int j)
    {
        Calendar calendar = Calendar.getInstance();
        Calendar calendar1 = Calendar.getInstance();
        calendar = Calendar.getInstance();
        calendar.set(1, i);
        calendar.set(2, j);
        calendar.set(5, 0);
        calendar1 = calendar;

        int k = calendar1.get(1);
        int l = calendar1.get(2);
        int i1 = calendar1.get(5);

        return i1;
    }

    public static String addSepoaDateYear(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMdd");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(1, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String addSepoaDateMonth(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMdd");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(2, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String addSepoaDateDay(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMdd");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(5, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String addSepoaDateTimeHour(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMddHHmmss");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(10, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String addSepoaDateTimeMinute(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMddHHmmss");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(12, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String addSepoaDateTimeSecond(String s, int i)
    {
        String s1 = null;
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyyMMddHHmmss");

        try
        {
            Date date = simpledateformat.parse(s);
            calendar.setTime(date);
            calendar.add(13, i);
            date = calendar.getTime();
            s1 = simpledateformat.format(date);
        }
        catch (ParseException parseexception)
        {
            s1 = s;
        }

        return s1;
    }
    
}

