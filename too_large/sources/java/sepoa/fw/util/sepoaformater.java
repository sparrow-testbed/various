package sepoa.fw.util;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.log.Logger;

public class SepoaFormater implements Serializable
{
    private static final long serialVersionUID = 2050771179360458623L;
    
	static final String OUT_OF_BOUND_STRING = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.";
    int total_count;
    int page_count;
    Vector m_values;
    String[] m_columns;
    Hashtable ht_col_idx;

    public SepoaFormater(String s) throws Exception
    {
        total_count = -1;
        page_count = -1;

        String s1 = getConfig("sepoa.separator.field");
        String s2 = getConfig("sepoa.separator.line");
        m_values = new Vector();

        String s3 = "^^^";
        int i = s.indexOf(s3);

        if (i > -1)
        {
            String s4 = s.substring(i + 3);
            i = s4.indexOf(s3);
            total_count = Integer.parseInt(s4.substring(0, i));
            page_count = Integer.parseInt(s4.substring(i + 3));
        }

        int j = initial(s, s1, s2);

        if (j == 1)
        {
            throw new Exception("\uB370\uC774\uD0C0 \uD3EC\uB9F7\uC774 \uC815\uD655\uD558\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.");
        }

        if (j == 2)
        {
            //System.out.println("<SYSTEM>SepoaFormater - \uB370\uC774\uD0C0\uAC00 \uC5C6\uC2B5\uB2C8\uB2E4.");

            return;
        }
        else
        {

        	initial2();
	
            return;
        }
    }

    public SepoaFormater(String s, String s1, String s2) throws Exception
    {
        total_count = -1;
        page_count = -1;
        m_values = new Vector();

        String s3 = "^^^";
        int i = s.indexOf(s3);

        if (i > -1)
        {
            String s4 = s.substring(i + 3);
            i = s4.indexOf(s3);
            total_count = Integer.parseInt(s4.substring(0, i));
            page_count = Integer.parseInt(s4.substring(i + 3));
        }

        int j = initial(s, s1, s2);

        if (j == 1)
        {
            throw new Exception("\uB370\uC774\uD0C0 \uD3EC\uB9F7\uC774 \uC815\uD655\uD558\uC9C0 \uC54A\uC2B5\uB2C8\uB2E4.");
        }

        if (j == 2)
        {
            //System.out.println("<SYSTEM>SepoaFormater - \uB370\uC774\uD0C0\uAC00 \uC5C6\uC2B5\uB2C8\uB2E4.");

            return;
        }
        else
        {
            initial2();

            return;
        }
    }

    public SepoaFormater(String[][] as)
    {
        total_count = -1;
        page_count = -1;
        m_values = new Vector();

        if (as == null)
        {
            return;
        }

        if (as.length < 1)
        {
            return;
        }

        if (as.length > 1)
        {
            for (int i = 1; i < as.length; i++)
            {
                m_values.addElement(as[i]);
            }
        }

        m_columns = as[0];
        initial2();
    }

    protected void initial2()
    {
        ht_col_idx = new Hashtable();

        for (int i = 0; i < m_columns.length; i++)
        {
            ht_col_idx.put(m_columns[i].toUpperCase(), Integer.toString(i));
            ht_col_idx.put(m_columns[i].toLowerCase(), Integer.toString(i));
        }
    }

    protected int initial(String s, String s1, String s2)
    {
        if (s == null)
        {
            return 1;
        }

        String[] as = parseValue(s, s2);

        if (as == null)
        {
            return 1;
        }

        Vector vector = new Vector();
        m_columns = parseValue(as[0], s1);
        vector.copyInto(m_columns);

        int i = 0;

        for (int j = 1; j < as.length; j++)
        {
            String[] as1 = parseValue(as[j], s1);

            if (m_columns.length != as1.length)
            {
                i = 2;
            }

            m_values.addElement(as1);
        }

        return i;
    }

    public int getRowCount()
    {
        return (m_values == null) ? 0 : m_values.size();
    }

    public int getColumnCount()
    {
        return (m_columns == null) ? 0 : m_columns.length;
    }

    public String[] getColumnNames()
    {
        return m_columns;
    }

    public String[][] getValue()
    {
        String[][] as = new String[m_values.size()][((String[]) m_values.elementAt(0)).length];
        m_values.copyInto(as);

        return as;
    }

    public String getValue(int i, int j) throws Exception
    {
        if ((i < 0) || (i >= m_values.size()))
        {
            String s = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.\n";
            s = s + "row index\uB294 0\uACFC " + (m_values.size() - 1) + "\uC0AC\uC774\uC758 \uAC12 \uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4.";
            throw new Exception(s);
        }

        if ((j < 0) || (j > ((String[]) m_values.elementAt(0)).length))
        {
            String s1 = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.\n";
            s1 = s1 + "column index\uB294 0\uACFC " + (((String[]) m_values.elementAt(0)).length - 1) + "\uC0AC\uC774\uC758 \uAC12 \uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4";
            throw new Exception(s1);
        }

        String[] as = (String[]) m_values.elementAt(i);

        if (as[j] == null)
        {
            

            return "";
        }
        else
        {
            return changeNormalString(as[j]);
        }
    }

    public String getValue(String s, int i) throws Exception
    {
    	return changeNormalString(getRawValue(s, i));
    }

    public String getRawValue(String s, int i) throws Exception
    {
        if ((i < 0) || (i >= m_values.size()))
        {
            String s1 = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.\n";
            s1 = s1 + "column index\uB294 0\uACFC " + (m_values.size() - 1) + "\uC0AC\uC774\uC758 \uAC12 \uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4.";
            throw new Exception(s1);
        }

        String s2 = (String) ht_col_idx.get(s.trim().toUpperCase());

        if (s2 == null)
        {
            //System.out.println("filed\uBA85 " + s + "\uC740 \uC5C6\uC2B5\uB2C8\uB2E4");

            return "";
        }

        int j = 0;

//        try
//        {
            j = Integer.parseInt(String.valueOf(s2));
//        }
//        catch (Exception exception)
//        {
//            
//        }

        String[] as = (String[]) m_values.elementAt(i);

        if (as[j] == null)
        {
            

            return "";
        }
        else
        {
            return as[j];
        }
    }

    public String changeNormalString(String data) throws Exception
    {
        data = SepoaString.replaceString (data , "&#38;"        , "&"    );
        data = SepoaString.replaceString (data , "&#36;"        , "$"    );
        data = SepoaString.replaceString (data , "&#34;"        , "\""   );
        data = SepoaString.replaceString (data , "&#37;"        , "%"    );
        data = SepoaString.replaceString (data , "&#39;"        , "'"    );
        data = SepoaString.replaceString (data , "&#40;"        , "("    );
        data = SepoaString.replaceString (data , "&#41;"        , ")"    );
        data = SepoaString.replaceString (data , "&#43;"        , "+"    );
        data = SepoaString.replaceString (data , "&#47;"        , "/"    );
        data = SepoaString.replaceString (data , "&#59;"        , ";"    );
        data = SepoaString.replaceString (data , "&#60;"        , "<"    );
        data = SepoaString.replaceString (data , "&#62;"        , ">"    );
        data = SepoaString.replaceString (data , "&#63;"        , "?"    );
        data = SepoaString.replaceString (data , "&#124;"       , "|"    );
        data = SepoaString.replaceString (data , "&#45;&#45;"   , "--"   );
        data = SepoaString.replaceString (data , "&#64;"        , "@"    );
        data = SepoaString.replaceString (data , "&#92;&#39;"   , "\\'"  );
        data = SepoaString.replaceString (data , "&#92;&#34;"   , "\\\"" );
        data = SepoaString.replaceString (data , "&#10;"        , "\r"   );
        data = SepoaString.replaceString (data , "&#13;"        , "\n"   );
        data = SepoaString.replaceString (data , "&#92;"        , "\\"   );
	    data = data.replaceAll ("&lt;", "<");
		data = data.replaceAll ("&gt;", ">");
		data = data.replaceAll ("&amp;", "&");

		return data;
    }

    public double getDouble(String s, int i) throws Exception
    {
        String s1 = getValue(s, i);
        double d = 0.0D;

//        try
//        {
            if (s1.equals(""))
            {
                s1 = "0.0";
            }

            d = Double.parseDouble(s1);
//        }
//        catch (Exception exception)
//        {
//            
//        }

        return d;
    }

    public long getLong(String s, int i) throws Exception
    {
        String s1 = getValue(s, i);
        long l = 0L;

//        try
//        {
            if (s1.equals(""))
            {
                s1 = "0";
            }

            l = Long.parseLong(s1);
//        }
//        catch (Exception exception)
//        {
//            
//        }

        return l;
    }

    public String getValue(String s, String s1)
    {
        int[] ai = (int[]) null;

//        try
//        {
            ai = getColumnIndex(s, s1);
//        }
//        catch (Exception exception)
//        {
//            
//        }

        if ((ai == null) || (ai.length == 0))
        {
            

            return null;
        }

        StringBuffer stringbuffer = new StringBuffer();
        Object obj = null;

        for (int i = 0; i < ai.length; i++)
        {
            if (i != 0)
            {
                stringbuffer.append("\t");
            }

            stringbuffer.append(m_columns[ai[i]].toUpperCase());
        }

        Object obj1 = null;

        for (int j = 0; j < m_values.size(); j++)
        {
            stringbuffer.append("\t\n");

            String[] as = (String[]) m_values.elementAt(j);

            if (as == null)
            {
                

                return null;
            }

            for (int k = 0; k < ai.length; k++)
            {
                if (k != 0)
                {
                    stringbuffer.append("\t");
                }

                String s2 = as[ai[k]];

                if (s2 == null)
                {
                    
                    s2 = "";
                }

                stringbuffer.append(s2);
            }
        }

        return stringbuffer.toString();
    }

    public String[][] getArrays(String s, String s1)
    {
        int[] ai = getColumnIndex(s, s1);

        if (ai == null)
        {
            return null;
        }

        StringBuffer stringbuffer = new StringBuffer();
        String[][] as = new String[m_values.size()][ai.length];
        Object obj = null;

        for (int i = 0; i < m_values.size(); i++)
        {
            String[] as1 = (String[]) m_values.elementAt(i);

            for (int j = 0; j < ai.length; j++)
            {
                as[i][j] = as1[ai[j]];
            }
        }

        return as;
    }

    private int[] getColumnIndex(String s, String s1)
    {
        if (! s.substring(s.length() - s1.length()).equals(s1))
        {
            s = s + s1;
        }

        String[] as = parseValue(s, s1);
        int[] ai = new int[as.length];
        Object obj = null;

        for (int i = 0; i < as.length; i++)
        {
            String s2 = (String) ht_col_idx.get(as[i]);

            if (s2 == null)
            {
                

                return null;
            }

            ai[i] = Integer.parseInt(s2);
        }

        return ai;
    }

    public String[] getValue(String s)
    {
        for (int i = 0; i < m_columns.length; i++)
        {
            if (m_columns[i].equals(s))
            {
                String[] as = new String[m_values.size()];

                for (int j = 0; j < m_values.size(); j++)
                {
                    String[] as1 = (String[]) m_values.elementAt(j);
                    as[j] = as1[i];
                }

                return as;
            }
        }

        return null;
    }

    public Vector getAllColumnValue(String s)
    {
    	Vector column_vec = new Vector();
        for (int i = 0; i < m_columns.length; i++)
        {
        	if (m_columns[i].equals(s))
            {
                String[] as = new String[m_values.size()];

                for (int j = 0; j < m_values.size(); j++)
                {
                    String[] as1 = (String[]) m_values.elementAt(j);
                    column_vec.addElement(as1[i]);
                }

                return column_vec;
            }
        }

        return column_vec;
    }

    /**
     * @param column_name
     * @param value
     * @param row number
     * @throws Exception
     */
    public void setValue(String s, String s1, int i) throws Exception
    {
        if ((i < 0) || (i > m_values.size()))
        {
            String s2 = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.\n";
            s2 = s2 + "row index\uB294 0\uACFC " + m_values.size() + "\uC0AC\uC774\uC758 \uAC12 \uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4.";
            throw new Exception(s2);
        }

        for (int j = 0; j < m_columns.length; j++)
        {
            if (m_columns[j].equals(s))
            {
                String[] as = (String[]) m_values.elementAt(i);
                as[j] = s1;
            }
        }
    }

    public void setValue(int i, int j, String s) throws Exception
    {
        if ((i < 0) || (i > m_values.size()))
        {
            String s1 = "\uC785\uB825\uD558\uC2E0 \uAC12\uC758 \uBC94\uC704\uAC00 \uAE30\uC874\uAC12\uC758 \uBC94\uC704\uBC16\uC5D0 \uC788\uC2B5\uB2C8\uB2E4.\n";
            s1 = s1 + "row index\uB294 0\uACFC " + m_values.size() + "\uC0AC\uC774\uC758 \uAC12 \uC774\uC5B4\uC57C \uD569\uB2C8\uB2E4.";
            throw new Exception(s1);
        }

        for (int k = 0; k < m_columns.length; k++)
        {
            String[] as = (String[]) m_values.elementAt(i);
            as[j] = s;
        }
    }

    public void setValue(String s, String s1)
    {
        for (int i = 0; i < m_columns.length; i++)
        {
            if (m_columns[i].equals(s))
            {
                for (int j = 0; j < m_values.size(); j++)
                {
                    String[] as = (String[]) m_values.elementAt(j);
                    as[i] = s1;
                }
            }
        }
    }

    public void addValue(String[] as)
    {
        insertValue(as, m_values.size());
    }

    public void insertValue(String[] as, int i)
    {
        if (as == null)
        {
            

            return;
        }

        if (as.length != m_columns.length)
        {
            

            return;
        }

        if ((i < 0) || (i > m_values.size()))
        {
            
            

            return;
        }
        else
        {
            m_values.insertElementAt(as, i);

            return;
        }
    }

    public void removeValue(int i)
    {
        m_values.removeElementAt(i);
    }

    public void removeAllValue()
    {
        m_values.removeAllElements();
    }

    public void setFormat(int i, String s, String s1) throws Exception
    {
        setFormat(m_columns[i], s, s1);
    }

    public void setFormat(String s, String s1, String s2) throws Exception
    {
        if (s2.equals("Date"))
        {
            for (int i = 0; i < m_columns.length; i++)
            {
                if (m_columns[i].equals(s))
                {
                    for (int l = 0; l < m_values.size(); l++)
                    {
                        String[] as = (String[]) m_values.elementAt(l);
                        String s3 = checkDate(as[i], s1);

                        if (s3 == null)
                        {
                            
                            
                            throw new Exception("null");
                        }

                        as[i] = s3;
                    }
                }
            }
        }

        if (s2.equals("Number"))
        {
            for (int j = 0; j < m_columns.length; j++)
            {
                if (m_columns[j].equals(s))
                {
                    for (int i1 = 0; i1 < m_values.size(); i1++)
                    {
                        String[] as1 = (String[]) m_values.elementAt(i1);
                        String s4 = checkNumber(as1[j], s1);

                        if (s4 == null)
                        {
                            
                            
                            throw new Exception("null");
                        }

                        as1[j] = s4;
                    }
                }
            }
        }

        if (s2.equals("Time"))
        {
            for (int k = 0; k < m_columns.length; k++)
            {
                if (m_columns[k].equals(s))
                {
                    for (int j1 = 0; j1 < m_values.size(); j1++)
                    {
                        String[] as2 = (String[]) m_values.elementAt(j1);
                        String s5 = checkTime(as2[k], s1);

                        if (s5 == null)
                        {
                            
                            
                            throw new Exception("null");
                        }

                        as2[k] = s5;
                    }
                }
            }
        }
    }

    public void setFormat(int i, int j, String s, String s1) throws Exception
    {
        setFormat(m_columns[j], i, s, s1);
    }

    public void setFormat(String s, int i, String s1, String s2) throws Exception
    {
        if ((i < 0) || (i > m_values.size()))
        {
            throw new Exception("null");
        }

        if (s2.equals("Date"))
        {
            for (int j = 0; j < m_columns.length; j++)
            {
                if (m_columns[j].equals(s))
                {
                    String[] as = (String[]) m_values.elementAt(i);
                    String s3 = checkDate(as[j], s1);

                    if (s3 == null)
                    {
                        
                        
                        throw new Exception("null");
                    }

                    as[j] = s3;
                }
            }
        }

        if (s2.equals("Number"))
        {
            for (int k = 0; k < m_columns.length; k++)
            {
                if (m_columns[k].equals(s))
                {
                    String[] as1 = (String[]) m_values.elementAt(i);
                    String s4 = checkNumber(as1[k], s1);

                    if (s4 == null)
                    {
                        
                        
                        throw new Exception("null");
                    }

                    as1[k] = s4;
                }
            }
        }

        if (s2.equals("Time"))
        {
            for (int l = 0; l < m_columns.length; l++)
            {
                if (m_columns[l].equals(s))
                {
                    for (int i1 = 0; i1 < m_values.size(); i1++)
                    {
                        String[] as2 = (String[]) m_values.elementAt(i1);
                        String s5 = checkTime(as2[l], s1);

                        if (s5 == null)
                        {
                            
                            
                            throw new Exception("null");
                        }

                        as2[l] = s5;
                    }
                }
            }
        }
    }

    protected String checkDate(String s, String s1)
    {
        if (s == null)
        {
            return s;
        }

        if (s.length() != 8)
        {
            return s;
        }

        try
        {
            Integer.parseInt(s);
        }
        catch (Exception exception)
        {
            return s;
        }

        String s2 = s.substring(0, 4);
        String s3 = s.substring(4, 6);
        String s4 = s.substring(6, 8);
        int i = Integer.parseInt(s2);
        int j = Integer.parseInt(s3);
        int k = Integer.parseInt(s4);

        if ((i < 1000) || (i > 9999))
        {
            return s;
        }

        if ((j < 1) || (j > 12))
        {
            return s;
        }

        String[] as =
        {
            "31", "28", "31", "30", "31", "30", "31", "31", "30", "31", "30",
            "31"
        };

        if ((((i % 4) == 0) && ((i % 100) != 0)) || ((i % 400) == 0))
        {
            as[1] = "29";
        }

        if ((k < 1) || (k > Integer.parseInt(as[j - 1])))
        {
            return s;
        }

        if (s1 == null)
        {
            return s2 + s3 + s4;
        }
        else
        {
            String s5 = dateFormat(s2, s3, s4, s1);

            return s5;
        }
    }

    protected String dateFormat(String s, String s1, String s2, String s3)
    {
        s3 = s3.toUpperCase();

        if (s3 == null)
        {
            return s + s1 + s2;
        }

        int i = s3.indexOf("YY");

        if (i == -1)
        {
            return s + s1 + s2;
        }

        int j = s3.indexOf("MM");

        if (j == -1)
        {
            return s + s1 + s2;
        }

        int k = s3.indexOf("DD");

        if (k == -1)
        {
            return s + s1 + s2;
        }

        int j2;

        if (i > j)
        {
            if (j > k)
            {
                int l = i;
                j2 = j;

                int k2 = k;
            }
            else if (i > k)
            {
                int i1 = i;
                j2 = k;

                int l2 = j;
            }
            else
            {
                int j1 = k;
                j2 = i;

                int i3 = j;
            }
        }
        else if (i > k)
        {
            int k1 = j;
            j2 = i;

            int j3 = k;
        }
        else if (j > k)
        {
            int l1 = j;
            j2 = k;

            int k3 = i;
        }
        else
        {
            int i2 = k;
            j2 = j;

            int l3 = i;
        }

        String s4 = s3.substring(j2, j2 + 2);
        Vector vector = new Vector();

        for (SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s3, s4, false);
                sepoastringtokenizer.hasMoreTokens();
                vector.addElement(sepoastringtokenizer.nextToken()))
        {
            ;
        }

        String[] as = new String[vector.size()];
        vector.copyInto(as);

        String s5 = "";
        String s6 = "";
        String s7 = "";
        String s8 = "";

        if (as.length == 2)
        {
            if (as[0].indexOf("YY") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("YY"));
                s6 = as[0].substring(as[0].indexOf("YY") + 2);
            }

            if (as[0].indexOf("MM") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("MM"));
                s6 = as[0].substring(as[0].indexOf("MM") + 2);
            }

            if (as[0].indexOf("DD") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("DD"));
                s6 = as[0].substring(as[0].indexOf("DD") + 2);
            }

            if (as[1].indexOf("YY") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("YY"));
                s8 = as[1].substring(as[1].indexOf("YY") + 2);
            }

            if (as[1].indexOf("MM") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("MM"));
                s8 = as[1].substring(as[1].indexOf("MM") + 2);
            }

            if (as[1].indexOf("DD") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("DD"));
                s8 = as[1].substring(as[1].indexOf("DD") + 2);
            }
        }

        return s5 + s + s6 + s1 + s7 + s2 + s8;
    }

    protected String checkNumber(String s, String s1)
    {
        if (s1 == null)
        {
            return s;
        }

        if (s.equals(""))
        {
            return s;
        }

        try
        {
            Double double1 = new Double(s);
            DecimalFormat decimalformat = new DecimalFormat(s1);
            String s2 = decimalformat.format(double1);

            return s2;
        }
        catch (Exception exception)
        {
            return s;
        }
    }

    protected String checkTime(String s, String s1)
    {
        if (s == null)
        {
            return s;
        }

        if (s.length() != 6)
        {
            return s;
        }

        try
        {
            Integer.parseInt(s);
        }
        catch (Exception exception)
        {
            return s;
        }

        String s2 = s.substring(0, 2);
        String s3 = s.substring(2, 4);
        String s4 = s.substring(4, 6);
        int i = Integer.parseInt(s2);
        int j = Integer.parseInt(s3);
        int k = Integer.parseInt(s4);

        if ((i < 0) || (i > 24))
        {
            return s;
        }

        if ((j < 0) || (j > 24))
        {
            return s;
        }

        if ((k < 0) || (k > 24))
        {
            return s;
        }

        if (s1 == null)
        {
            return s2 + s3 + s4;
        }
        else
        {
            String s5 = timeFormat(s2, s3, s4, s1);

            return s5;
        }
    }

    protected String timeFormat(String s, String s1, String s2, String s3)
    {
        s3 = s3.toUpperCase();

        if (s3 == null)
        {
            return s + s1 + s2;
        }

        int i = s3.indexOf("HH");

        if (i == -1)
        {
            return s + s1 + s2;
        }

        int j = s3.indexOf("MM");

        if (j == -1)
        {
            return s + s1 + s2;
        }

        int k = s3.indexOf("SS");

        if (k == -1)
        {
            return s + s1 + s2;
        }

        int j2;

        if (i > j)
        {
            if (j > k)
            {
                int l = i;
                j2 = j;

                int k2 = k;
            }
            else if (i > k)
            {
                int i1 = i;
                j2 = k;

                int l2 = j;
            }
            else
            {
                int j1 = k;
                j2 = i;

                int i3 = j;
            }
        }
        else if (i > k)
        {
            int k1 = j;
            j2 = i;

            int j3 = k;
        }
        else if (j > k)
        {
            int l1 = j;
            j2 = k;

            int k3 = i;
        }
        else
        {
            int i2 = k;
            j2 = j;

            int l3 = i;
        }

        String s4 = s3.substring(j2, j2 + 2);
        Vector vector = new Vector();

        for (SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s3, s4, false);
                sepoastringtokenizer.hasMoreTokens();
                vector.addElement(sepoastringtokenizer.nextToken()))
        {
            ;
        }

        String[] as = new String[vector.size()];
        vector.copyInto(as);

        String s5 = "";
        String s6 = "";
        String s7 = "";
        String s8 = "";

        if (as.length == 2)
        {
            if (as[0].indexOf("HH") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("HH"));
                s6 = as[0].substring(as[0].indexOf("HH") + 2);
            }

            if (as[0].indexOf("MM") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("MM"));
                s6 = as[0].substring(as[0].indexOf("MM") + 2);
            }

            if (as[0].indexOf("SS") != -1)
            {
                s5 = as[0].substring(0, as[0].indexOf("SS"));
                s6 = as[0].substring(as[0].indexOf("SS") + 2);
            }

            if (as[1].indexOf("HH") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("HH"));
                s8 = as[1].substring(as[1].indexOf("HH") + 2);
            }

            if (as[1].indexOf("MM") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("MM"));
                s8 = as[1].substring(as[1].indexOf("MM") + 2);
            }

            if (as[1].indexOf("SS") != -1)
            {
                s7 = as[1].substring(0, as[1].indexOf("SS"));
                s8 = as[1].substring(as[1].indexOf("SS") + 2);
            }
        }

        return s5 + s + s6 + s1 + s7 + s2 + s8;
    }

    public void print()
    {
        if (m_columns == null)
        {
            

            return;
        }

        if (m_values == null)
        {
            

            return;
        }

        for (int i = 0; i < m_columns.length; i++)
        {
            
        }

        
        

        for (int j = 0; j < m_values.size(); j++)
        {
            String[] as = (String[]) m_values.elementAt(j);

            for (int k = 0; k < as.length; k++)
            {
                
            }

            
        }
    }

    public String getConfig(String s)
    {
        try
        {
            Configuration configuration = new Configuration();
            s = configuration.get(s);

            return s;
        }
        catch (ConfigurationException configurationexception)
        {
            Logger.sys.println("SepoaStream getConfig: " + configurationexception.getMessage());
        }
        catch (Exception exception)
        {
            Logger.sys.println("SepoaStream getConfig: " + exception.getMessage());
        }

        return null;
    }

    public String getString()
    {
        if (m_columns == null)
        {
            return null;
        }

        if (m_values == null)
        {
            return null;
        }

        String s = getConfig("sepoa.separator.field");
        String s1 = getConfig("sepoa.separator.line");
        String s2 = "";

        for (int i = 0; i < m_columns.length; i++)
        {
            s2 = s2 + m_columns[i] + s;
        }

        s2 = s2 + s1;

        String s3 = "";

        for (int j = 0; j < m_values.size(); j++)
        {
            String[] as = (String[]) m_values.elementAt(j);
            String s4 = "";

            for (int k = 0; k < as.length; k++)
            {
                s4 = s4 + as[k] + s;
            }

            s3 = s3 + s4 + s1;
        }

        return s2 + s3;
    }

    protected String[] parseValue(String s, String s1)
    {
        if (s == null)
        {
            return null;
        }

        Vector vector = new Vector();
        boolean flag = true;
        int i = 0;
        int j = 0;

        while (flag)
        {
            j = s.indexOf(s1, j);

            if (j == -1)
            {
                flag = false;
            }
            else
            {
                String s2 = s.substring(i, j);
                j += s1.length();
                i = j;
                vector.addElement(s2);
            }
        }

        String[] as = new String[vector.size()];
        vector.copyInto(as);

        return as;
    }

    public int getIndex(int i, String s) throws Exception
    {
        String[][] as = new String[m_values.size()][];

        for (int j = 0; j < m_values.size(); j++)
        {
            String[] as1 = (String[]) m_values.elementAt(j);
            as[j] = as1;
        }

        return SepoaString.getIndex(as, i, s);
    }

    public void replace(String s, String s1, String s2) throws Exception
    {
        for (int i = 0; i < m_columns.length; i++)
        {
            if (! m_columns[i].equals(s))
            {
                continue;
            }

            replace(i, s1, s2);

            break;
        }
    }

    public void replace(int i, String s, String s1) throws Exception
    {
        for (int j = 0; j < m_values.size(); j++)
        {
            String[] as = (String[]) m_values.elementAt(j);

            if (as[i].equals(s))
            {
                as[i] = s1;
            }
        }
    }

    public int getTotalRowCount()
    {
        return total_count;
    }

    public int getPageCount()
    {
        return page_count;
    }
}