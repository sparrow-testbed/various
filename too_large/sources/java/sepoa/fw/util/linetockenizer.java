package sepoa.fw.util;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Vector;

public class LineTockenizer
{
    String filename;
    SepoaStringTokenizer st1;
    SepoaStringTokenizer st2;
    String tocken;
    boolean valid;

    public LineTockenizer(String s)
    {
        valid = false;
        filename = s;
        initial();
    }

    public boolean isValid()
    {
        return valid;
    }

    public void initial()
    {
        FileReader filereader = null;

        try
        {
            File file = new File(filename);

            if (file.exists())
            {
                filereader = new FileReader(file);

                int i = 0;
                int j = (int) file.length();
                char[] ac = new char[j];
                i += filereader.read(ac, i, j - i);

                String s = String.valueOf(ac);
                st1 = new SepoaStringTokenizer(String.valueOf(ac), "\n", false);
                valid = true;
            }
            else
            {
                valid = false;
            }
        }
        catch (IOException ioexception)
        {
        	valid = false;
        }
        finally
        {
            try
            {
                if (filereader != null)
                {
                    filereader.close();
                }
            }
            catch (IOException ioexception1)
            {
            	filereader = null;
            }
        }
    }

    public String nextLine()
    {
        if (st1.hasMoreTokens())
        {
            tocken = st1.nextToken();
            st2 = null;
            st2 = new SepoaStringTokenizer(tocken, "\t", false);

            return tocken;
        }
        else
        {
            return null;
        }
    }

    public String[] nextLineArgs()
    {
        if (st1.hasMoreTokens())
        {
            tocken = st1.nextToken();
            st2 = null;
            st2 = new SepoaStringTokenizer(tocken, "\t", false);

            return nextTocken();
        }
        else
        {
            return null;
        }
    }

    private String[] nextTocken()
    {
        Vector vector = new Vector();
        int i = 0;

        while (st2.hasMoreTokens())
        {
            tocken = st2.nextToken();

            if (tocken != null)
            {
                tocken = tocken.trim();

                if (tocken.length() > 0)
                {
                    if (tocken.substring(0, 1).equals("\""))
                    {
                        tocken = tocken.substring(1, tocken.length() - 1);
                    }

                    vector.addElement(tocken);
                    i++;
                }
            }
        }

        String[] as = new String[vector.size()];
        vector.copyInto(as);

        return as;
    }

    protected void finalize() throws Throwable
    {
    }
}
