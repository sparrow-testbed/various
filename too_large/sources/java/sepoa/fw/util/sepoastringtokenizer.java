package sepoa.fw.util;

import java.util.Enumeration;
import java.util.NoSuchElementException;

public class SepoaStringTokenizer implements Enumeration
{
    private int currentPosition;
    private int maxPosition;
    private String str;
    private String delimiters;
    private int delimLen;
    private boolean retTokens;

    public SepoaStringTokenizer(String s, String s1, boolean flag)
    {
        delimLen = 0;
        currentPosition = 0;
        maxPosition = s.length();
        delimiters = s1;
        retTokens = flag;
        delimLen = s1.length();

        if (maxPosition < delimLen)
        {
            str = s;

            return;
        }

        if (s.substring(maxPosition - delimLen, maxPosition).equals(delimiters))
        {
            str = s.substring(0, maxPosition - delimLen);
            maxPosition = str.length();
        }
        else
        {
            str = s;
        }
    }

    public SepoaStringTokenizer(String s, String s1)
    {
        this(s, s1, false);
    }

    public SepoaStringTokenizer(String s)
    {
        this(s, " \t\n\r\f", false);
    }

    private void skipDelimiters()
    {
        for (;
                ! retTokens && (currentPosition < maxPosition) && (checkToken(currentPosition) >= 0);
                currentPosition += delimLen)
        {
            ;
        }
    }

    public boolean hasMoreTokens()
    {
        skipDelimiters();

        return currentPosition < maxPosition;
    }

    public String nextToken()
    {
        skipDelimiters();

        if (currentPosition >= maxPosition)
        {
            throw new NoSuchElementException();
        }

        int i = currentPosition;

        for (;
                (currentPosition < maxPosition) && (checkToken(currentPosition) < 0);
                currentPosition++)
        {
            ;
        }

        if (retTokens && (i == currentPosition) && (checkToken(currentPosition) >= 0))
        {
            currentPosition++;
        }

        return str.substring(i, currentPosition);
    }

    public String nextToken(String s)
    {
        delimiters = s;

        return nextToken();
    }

    public boolean hasMoreElements()
    {
        return hasMoreTokens();
    }

    public Object nextElement()
    {
        return nextToken();
    }

    public int countTokens()
    {
        int i = 0;

        for (int j = currentPosition; j < maxPosition;)
        {
            while (! retTokens && (j < maxPosition) && (checkToken(j) >= 0))
            {
                j++;
            }

            if (j >= maxPosition)
            {
                break;
            }

            int k = j;

            for (; (j < maxPosition) && (checkToken(j) < 0); j++)
            {
                ;
            }

            if (retTokens && (k == j) && (checkToken(j) >= 0))
            {
                j++;
            }

            i++;
        }

        return i;
    }

    public int checkToken(int i)
    {
        int j = -1;
        int k = delimiters.indexOf(str.charAt(i));

        if ((k == 0) && ((maxPosition - i) >= delimLen) && str.substring(i, i + delimLen).equals(delimiters))
        {
            j = k;
        }

        return j;
    }
}
