package sepoa.fw.util; 

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;
import java.util.Vector;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

import javax.servlet.http.HttpServletRequest;

public final class SepoaString
{
    private SepoaString()
    {
    }

    public static String validNumber(String str) {
        if (str==null || "".equals(str)){
        	str = "0";
        }
        return str;
    }
    
    public static String formatNumByCustoms(String format_string, double d)
    {
        String s = format_string;
        return (new DecimalFormat(s)).format(d);
    }

    public static String encodeUrl(String src)
    {
        String src1 = src + "";
        StringBuffer tgt = new StringBuffer();
        String c = "";

        for (int i = 0; i < src1.length(); i++)
        {
            c = src1.substring(i, i + 1);

            if (c.equals("#"))
            {
                tgt = tgt.append("%23");
            }
            else if (c.equals(" "))
            {
                tgt = tgt.append("+");
            }
            else if (c.equals("+"))
            {
                tgt = tgt.append("%2B");
            }
            else if (c.equals("="))
            {
                tgt = tgt.append("%3D");
            }
            else if (c.equals("&"))
            {
                tgt = tgt.append("%26");
            }
            else if (c.equals("%"))
            {
                tgt = tgt.append("%25");
            }
            else if (c.equals("#"))
            {
                tgt = tgt.append("%23");
            }
            else if (c.equals("\""))
            {
                tgt = tgt.append("%22");
            }
            else if (c.equals("\'"))
            {
                tgt = tgt.append("%27");
            }
            else if (c.equals(";"))
            {
                tgt = tgt.append("%3B");
            }
            else if (c.equals(":"))
            {
                tgt = tgt.append("%3A");
            }
            else
            {
                tgt = tgt.append("" + c);
            }
        }

        return tgt.toString();
    }

    public static String setIrsNoStr(String src)
    {
    	if(src.length() == 10){
    		src = src.substring(0, 3) + "-" + src.substring(3, 5) + "-" + src.substring(5, 10);
    	}
    	return src;
    }
    
    public static String get8859_1(String s)
    {
	   String ret = null;

	   try
	   {
	      ret = new String(s.getBytes("8859_1"));
	   } catch(Exception e)
	   { ret = null; }

	   return ret;
	}

    public static Vector getStcParser(String str)
    {
        SepoaStringTokenizer st = new SepoaStringTokenizer(str, "\n", false);

        String temp_str = "";
        int cnts = st.countTokens();
        Vector v_result = new Vector();

        for (int j = 0; j < cnts; j++)
        {
            temp_str = st.nextToken().trim();

            if ((temp_str != null) && (temp_str.length() != 0))
            {
                v_result.addElement(temp_str);
            }
        }

        return v_result;
    }

    public static String getTagParser(String str)
    {
        String ws_result = "";

        if (str != null)
        {
            ws_result = SepoaString.replace(str, "--", "");
            ws_result = SepoaString.replace(ws_result, "<", "&lt;");
            ws_result = SepoaString.replace(ws_result, ">", "&gt;");
        }

        return ws_result;
    }

    public static String getTagReplace(String str)
    {
        String ws_result = "";

        if (str != null)
        {
            ws_result = SepoaString.replace(str, "<", "(");
            ws_result = SepoaString.replace(ws_result, ">", ")");
        }

        return ws_result;
    }

    public static String getSubString(String str, int start, int end)
    {
        int rSize = 0;
        int len = 0;
        int ll = 0;
        StringBuffer ss = new StringBuffer();

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }

            if ((len > start) && (len <= end))
            {
                ss.append(str.charAt(rSize));
            }
        }

        return ss.toString();
    }

    public static String changeHtmlSpecialTag(String _original_data)
    {
        StringBuffer da = new StringBuffer();
        String oData = "";
        String rData = "";

        for (int i = 0; i < getLengthb(_original_data); i++)
        {
            oData = getSubString(_original_data, i, i + 1);

            if (oData.equals("\""))
            {
                rData = "&quot;";
            }
            else if (oData.equals("&"))
            {
                rData = "&amp;";
            }
            else if (oData.equals("<"))
            {
                rData = "&lt;";
            }
            else if (oData.equals(">"))
            {
                rData = "&gt;";
            }
            else
            {
                rData = oData;
            }

            da.append(rData);
        }

        return da.toString();
    }

    private Vector getSplitString(String t1, int length)
    {
        Vector rt = new Vector();
        String ui = t1;

        int le = getLengthb(ui);

        while (le > 0)
        {
            rt.addElement(getSubString(ui, 0, length));
            ui = getSubString(ui, length, le);
            le = getLengthb(ui);
        }

        return rt;
    }

    /**
     * @param original_string
     * @param remove_char
     * @return
     */
    public static String removeStringHead(String original_string, String remove_char)
	{
		String rtn_string = "";

		if(original_string.indexOf(remove_char) == 0 && original_string.length() > 1)
		{
			rtn_string = removeStringHead(original_string.substring(1), remove_char);
		}
		else if(original_string.indexOf(remove_char) == 0 && original_string.length() == 1)
		{
			rtn_string = "";
		}
		else
		{
			rtn_string = original_string;
		}


		return rtn_string;
	}

    public static int getLengthb(String str)
    {
        int rSize = 0;
        int len = 0;
        int ll = 0;

        for (; rSize < str.length(); rSize++)
        {
            if (str.charAt(rSize) > 0x007F)
            {
                len += 2;
            }
            else
            {
                len++;
            }
        }

        return len;
    }

    public static String getLpad(String padStr, int size, String padChar)
    {
        StringBuffer str = new StringBuffer();
        int len = getLengthb(padStr);

        if (len < size)
        {
            for (int i = 0; i < (size - len); i++)
            {
                str.append(padChar);
            }

            str.append(padStr);
        }
        else
        {
            str.append(padStr);
        }

        return str.toString();
    }

    public static String getLpadTrim(String padStr, int size, String padChar)
    {
        StringBuffer str = new StringBuffer();
        int len = getLengthb(padStr);

        if (len < size)
        {
            for (int i = 0; i < (size - len); i++)
            {
                str.append(padChar);
            }

            str.append(padStr);
        }
        else
        {
            str.append(getSubString(padStr, 0, size));
        }

        return str.toString();
    }

    public static String getRpad(String padStr, int size, String padChar)
    {
        StringBuffer str = new StringBuffer();
        int len = getLengthb(padStr);

        if (len < size)
        {
            str.append(padStr);

            for (int i = 0; i < (size - len); i++)
            {
                str.append(padChar);
            }
        }
        else
        {
            str.append(padStr);
        }

        return str.toString();
    }

    public static String getRpadTrim(String padStr, int size, String padChar)
    {
        StringBuffer str = new StringBuffer();
        int len = getLengthb(padStr);

        if (len < size)
        {
            str.append(padStr);

            for (int i = 0; i < (size - len); i++)
            {
                str.append(padChar);
            }
        }
        else
        {
            str.append(getSubString(padStr, 0, size));
        }

        return str.toString();
    }

    public static String[] parser(String s, String s1)
    {
        Vector vector = new Vector();

        for (SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s, s1, false);
                sepoastringtokenizer.hasMoreTokens();
                vector.addElement(sepoastringtokenizer.nextToken()))
        {
            ;
        }

        String[] as = new String[vector.size()];
        vector.copyInto(as);

        return as;
    }

    public static String getWiseParse(String s, String s1, String s2)
    {
        String s3 = s1 + "=";
        String s4 = null;
        boolean flag = false;
        boolean flag1 = false;

        if (s.length() > 0)
        {
            int i = s.toUpperCase().indexOf(s3);

            if (i != -1)
            {
                i += s3.length();

                int j = s.indexOf(s2, i);

                if (j == -1)
                {
                    j = s.length();
                }

                s4 = s.substring(i, j);

                if (s4.length() < 1)
                {
                    s4 = null;
                }
            }
        }

        return s4;
    }

    public static String E2K(String s)
    {
        String s1 = null;

        if (s == null)
        {
            return null;
        }

        try
        {
            s1 = new String(s.getBytes("8859_1"), "KSC5601");
        }
        catch (UnsupportedEncodingException unsupportedencodingexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String UTF_8(String s)
    {
        String s1 = null;

        if (s == null)
        {
            return null;
        }

        try
        {
            s1 = new String(s.getBytes("8859_1"), "UTF-8");
        }
        catch (UnsupportedEncodingException unsupportedencodingexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String K2E(String s)
    {
        String s1 = null;

        if (s == null)
        {
            return null;
        }

        s1 = "";

        try
        {
            s1 = new String(s.getBytes("KSC5601"), "8859_1");
        }
        catch (UnsupportedEncodingException unsupportedencodingexception)
        {
            s1 = s;
        }

        return s1;
    }

    public static String[] StrToArray(String s, String s1)
    {
        SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s, s1, false);
        int i = sepoastringtokenizer.countTokens();
        String[] as = new String[i];

        for (int j = 0; j < i; j++)
        {
            as[j] = sepoastringtokenizer.nextToken().trim();

            if (as[j].length() == 0)
            {
                as[j] = " ";
            }
        }

        return as;
    }

    public static Vector StrToVector(String s, String s1)
    {
        SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s, s1, false);
        int i = sepoastringtokenizer.countTokens();
        Vector as = new Vector();

        for (int j = 0; j < i; j++)
        {
        	as.addElement(sepoastringtokenizer.nextToken().trim());
        }

        return as;
    }

    public static String getStackTrace(Throwable throwable)
    {
        ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream();
        PrintWriter printwriter = new PrintWriter(bytearrayoutputstream);
        throwable.printStackTrace(printwriter);
        printwriter.flush();

        return bytearrayoutputstream.toString();
    }

    public static String str2in(String s, String s1)
    {
        String s2 = "";
        SepoaStringTokenizer sepoastringtokenizer = new SepoaStringTokenizer(s, s1, false);
        int i = sepoastringtokenizer.countTokens();
        String[] as = new String[i];

        for (int j = 0; j < i; j++)
        {
            as[j] = sepoastringtokenizer.nextToken().trim();

            if (j == 0)
            {
                s2 = "'" + as[j] + "'";
            }
            else
            {
                s2 = s2 + ",'" + as[j] + "'";
            }
        }

        return s2;
    }

    public static String replace(String s, String s1, String s2)
    {
        int i = s.indexOf(s1);
        StringBuffer stringbuffer = new StringBuffer();

        if (i == -1)
        {
            return s;
        }

        stringbuffer.append(s.substring(0, i) + s2);

        if ((i + s1.length()) < s.length())
        {
            stringbuffer.append(replace(s.substring(i + s1.length(), s.length()), s1, s2));
        }

        return stringbuffer.toString();
    }

    public static String replaceString(String original, String source, String dest) throws Exception
    {
        StringBuffer buf = new StringBuffer(original);
        String tmp = original;

        int index = 0;

        while ((index = tmp.indexOf(source, index)) != -1)
        {
            tmp = new String(buf.replace(index, index + source.length(), dest));
            buf = new StringBuffer(tmp);
            index = index + dest.length();
        }

        return tmp;
    }

    public static String nToBr(String s)
    {
        String s1 = replace(s, "\n", "<BR>");

        return s1;
    }

    public static String nToBrBr(String s)
    {
        String s1 = replace(s, "\n", "<BR><BR>");

        return s1;
    }

    public static String dFormat(Object str) {
        if (str==null || "".equals(str.toString())) return "0";

        DecimalFormat df = new DecimalFormat("#,###,###,###,##0");
        String temp = str.toString();
        String retstr = null;

        try {
          retstr = df.format(Long.parseLong(temp));
        } catch(Exception e) {
          retstr = "0";
        }

        return retstr;
      }

    public static String formatNum(int i)
    {
        return (new DecimalFormat("###,###,###,###,##0")).format(i);
    }

    public static String formatNum(long l)
    {
        return (new DecimalFormat("###,###,###,###,##0")).format(l);
    }

    public static String formatNum(double d)
    {
        return (new DecimalFormat("###,###,###,###,##0")).format(d);
    }

    public static String formatNum(double d, int i)
    {
        String s = "###,###,###,###,##0";

        for (int j = 0; j < i; j++)
        {
        	if(j == 0)
        	{
        		s = s + ".";
        	}

            s = s + "0";
        }

        return (new DecimalFormat(s)).format(d);
    }

    public static String formatNumNoZero(double d, int i)
    {
        String s = "###,###,###,###,##0";

        for (int j = 0; j < i; j++)
        {
        	if(j == 0)
        	{
        		s = s + ".";
        	}

            s = s + "#";
        }

        return (new DecimalFormat(s)).format(d);
    }

    public static String dateStr(String s)
    {
        if (s.trim().equals(""))
        {
            return s;
        }
        else
        {
            String s1 = s.substring(0, 4) + "/" + s.substring(4, 6) + "/" + s.substring(6, 8);

            return s1;
        }
    }

    public static String getTimeColonFormat(String time_value)
    {
    	if(time_value == null) return time_value;

        if (time_value.trim().length() == 6)
        {
        	String s1 = time_value.substring(0, 2) + ":" + time_value.substring(2, 4) + ":" + time_value.substring(4, 6);

            return s1;
        }
        else if (time_value.trim().length() == 4)
        {
        	String s1 = time_value.substring(0, 2) + ":" + time_value.substring(2, 4);

            return s1;
        }
        else
        {
            return time_value;
        }
    }

    public static String getTimeUnColonFormat(String time_value)
    {
    	if(time_value == null) return time_value;

        if (time_value.trim().length() == 8 && time_value.indexOf(":") > 0)
        {
        	String s1 = time_value.replaceAll(":", "");

            return s1;
        }
        else if (time_value.trim().length() == 5 && time_value.indexOf(":") > 0)
        {
        	String s1 = time_value.replaceAll(":", "");

            return s1;
        }
        else
        {
            return time_value;
        }
    }

    public static String getDateSlashFormat(String date_value)
    {
    	if(date_value == null) return date_value;

        if (date_value.trim().length() == 8)
        {
        	String s1 = date_value.substring(0, 4) + "/" + date_value.substring(4, 6) + "/" + date_value.substring(6, 8);

            return s1;
        }
        else
        {
            return date_value;
        }
    }

    public static String getDateUnSlashFormat(String date_value)
    {
    	if(date_value == null) return date_value;

        if (date_value.trim().length() == 10 && date_value.indexOf("/") > 0)
        {
        	String s1 = date_value.replaceAll("/", "");

            return s1;
        }
        else
        {
            return date_value;
        }
    }
    
    
    public static String getDateDashFormat(String date_value)
    {
    	if(date_value == null) return date_value;

        if (date_value.trim().length() == 8)
        {
        	String s1 = date_value.substring(0, 4) + "-" + date_value.substring(4, 6) + "-" + date_value.substring(6, 8);

            return s1;
        }
        else
        {
            return date_value;
        }
    }

    
    public static String getDateUnDashFormat(String date_value)
    {
    	if(date_value == null) return date_value;

        if (date_value.trim().length() == 10 && date_value.indexOf("-") > 0)
        {
        	String s1 = date_value.replaceAll("-", "");

            return s1;
        }
        else
        {
            return date_value;
        }
    }

    
    public static int getIndex(String[][] as, int i, String s)
    {
        for (int j = 0; j < as.length; j++)
        {
            if (as[j][i].equals(s))
            {
                return j;
            }
        }

        return -1;
    }

    public static String[] OrgValue(String[] as)
    {
        int i = 0;

        for (int j = 0; j < as.length; j++)
        {
            if (as[j] != null)
            {
                i++;
            }
        }

        String[] as1 = new String[i];

        for (int k = 0; k < i; k++)
        {
            as1[k] = as[k];
        }

        return as1;
    }

    public static String[][] OrgValueArray(String[][] as, int i)
    {
        int j = 0;
        Vector vector = new Vector();

        for (int k = 0; k < as.length; k++)
        {
            if (as[k][0] != null)
            {
                j++;
                vector.addElement(Integer.toString(k));
            }
        }

        String[] as1 = new String[vector.size()];
        vector.copyInto(as1);

        String[][] as2 = new String[j][i];

        for (int l = 0; l < j; l++)
        {
            for (int i1 = 0; i1 < i; i1++)
            {
                as2[l][i1] = as[Integer.parseInt(as1[l])][i1];
            }
        }

        return as2;
    }

    public static int get36ToDecimal(char thirty_six) throws Exception
    {
        int _decimal = 0;

        switch (thirty_six)
        {
        case '0':
            _decimal = 0;

            break;

        case '1':
            _decimal = 1;

            break;

        case '2':
            _decimal = 2;

            break;

        case '3':
            _decimal = 3;

            break;

        case '4':
            _decimal = 4;

            break;

        case '5':
            _decimal = 5;

            break;

        case '6':
            _decimal = 6;

            break;

        case '7':
            _decimal = 7;

            break;

        case '8':
            _decimal = 8;

            break;

        case '9':
            _decimal = 9;

            break;

        case 'A':
            _decimal = 10;

            break;

        case 'B':
            _decimal = 11;

            break;

        case 'C':
            _decimal = 12;

            break;

        case 'D':
            _decimal = 13;

            break;

        case 'E':
            _decimal = 14;

            break;

        case 'F':
            _decimal = 15;

            break;

        case 'G':
            _decimal = 16;

            break;

        case 'H':
            _decimal = 17;

            break;

        case 'I':
            _decimal = 18;

            break;

        case 'J':
            _decimal = 19;

            break;

        case 'K':
            _decimal = 20;

            break;

        case 'L':
            _decimal = 21;

            break;

        case 'M':
            _decimal = 22;

            break;

        case 'N':
            _decimal = 23;

            break;

        case 'O':
            _decimal = 24;

            break;

        case 'P':
            _decimal = 25;

            break;

        case 'Q':
            _decimal = 26;

            break;

        case 'R':
            _decimal = 27;

            break;

        case 'S':
            _decimal = 28;

            break;

        case 'T':
            _decimal = 29;

            break;

        case 'U':
            _decimal = 30;

            break;

        case 'V':
            _decimal = 31;

            break;

        case 'W':
            _decimal = 32;

            break;

        case 'X':
            _decimal = 33;

            break;

        case 'Y':
            _decimal = 34;

            break;

        case 'Z':
            _decimal = 35;

            break;
        }

        return _decimal;
    }

    public static String getDecimalTo36(int decimal) throws Exception
    {
        String _thirty_six = "";

        switch (decimal)
        {
        case 0:
            _thirty_six = "0";

            break;

        case 1:
            _thirty_six = "1";

            break;

        case 2:
            _thirty_six = "2";

            break;

        case 3:
            _thirty_six = "3";

            break;

        case 4:
            _thirty_six = "4";

            break;

        case 5:
            _thirty_six = "5";

            break;

        case 6:
            _thirty_six = "6";

            break;

        case 7:
            _thirty_six = "7";

            break;

        case 8:
            _thirty_six = "8";

            break;

        case 9:
            _thirty_six = "9";

            break;

        case 10:
            _thirty_six = "A";

            break;

        case 11:
            _thirty_six = "B";

            break;

        case 12:
            _thirty_six = "C";

            break;

        case 13:
            _thirty_six = "D";

            break;

        case 14:
            _thirty_six = "E";

            break;

        case 15:
            _thirty_six = "F";

            break;

        case 16:
            _thirty_six = "G";

            break;

        case 17:
            _thirty_six = "H";

            break;

        case 18:
            _thirty_six = "I";

            break;

        case 19:
            _thirty_six = "J";

            break;

        case 20:
            _thirty_six = "K";

            break;

        case 21:
            _thirty_six = "L";

            break;

        case 22:
            _thirty_six = "M";

            break;

        case 23:
            _thirty_six = "N";

            break;

        case 24:
            _thirty_six = "O";

            break;

        case 25:
            _thirty_six = "P";

            break;

        case 26:
            _thirty_six = "Q";

            break;

        case 27:
            _thirty_six = "R";

            break;

        case 28:
            _thirty_six = "S";

            break;

        case 29:
            _thirty_six = "T";

            break;

        case 30:
            _thirty_six = "U";

            break;

        case 31:
            _thirty_six = "V";

            break;

        case 32:
            _thirty_six = "W";

            break;

        case 33:
            _thirty_six = "X";

            break;

        case 34:
            _thirty_six = "Y";

            break;

        case 35:
            _thirty_six = "Z";

            break;
        }

        return _thirty_six;
    }

    public static String[][] splitDataByColumnAndRow(String origin_string, String field, String line)
    {
		String[][] resultArray = null;

        try
        {

   	    	sepoa.fw.util.SepoaStringTokenizer st = new SepoaStringTokenizer(origin_string, line);
   	    	

   	    	int st_count = st.countTokens();
			resultArray = new String[st_count][];
            int i = 0;

            while(st.hasMoreElements())
    		{
    			if(i == st_count) break;

    			String token_string = (String) st.nextElement();
    			
    			
    			

	    		sepoa.fw.util.SepoaStringTokenizer st_dt = new SepoaStringTokenizer(token_string, field);
	    		int j = 0;
	    		String[] data = new String[st_dt.countTokens()];

	    		while(st_dt.hasMoreElements())
	    		{
	    			String dt_token_string = JSPUtil.nullChk((String) st_dt.nextElement());

	    			if(dt_token_string.equals("null"))
	    			{
	    				dt_token_string = "";
	    			}

	    			
					data[j] = dt_token_string;
					j++;
	    		}

	    		resultArray[i] = data;
	    		i++;
			}
		}
        catch (Exception e)
        {
        	resultArray = null;
        }

        return resultArray;
    }

	public HttpServletRequest getRequest() {
		// TODO Auto-generated method stub
		return null;
	}

	public static byte[] setCompressing(String param) {
		//StringBuffer returnCompress = new StringBuffer();
		byte[] output = new byte[param.length()];
        int ret = 0;
		try
		{
			byte[] input = param.getBytes("UTF-8");

			// Compress the bytes

			Deflater compresser = new Deflater();
			compresser.setInput(input);
			compresser.finish();
			int compressedDataLength = compresser.deflate(output);

			/*
			for (int i=0; i < compressedDataLength; i++)
			{
				returnCompress.append(output[i]);
			}

			returnCompress = new String(output, 0, compressedDataLength, "UTF-8");
			*/

		} catch (Exception ex) {
			ret = -1;
		}
		return output;
	}

    public static String setDeCompressing(byte[] param)
	{
    	String outputString = "";
    	//String parser = "";
    	//byte[] un_byte = null;
		try
		{
			/*
			for (int i=0; i < param.length(); i++)
			{
				parser = param.substring(i, i+1);
				un_byte[i] = (Byte.decode(parser)).byteValue();
			}
			*/
			Inflater decompresser = new Inflater();
			decompresser.setInput(param, 0, param.length);
			byte[] result = new byte[param.length * 5];
			int resultLength = decompresser.inflate(result);
			decompresser.end();

			// Decode the bytes into a String
			outputString = new String(result, 0, resultLength, "UTF-8");
		} catch (Exception ex) {
			
			return outputString;
		}
		return outputString;
	}
    
    /**
     * 
     *  (ex. getNullSplit("박^*)세^*)준^*)","^*)")
     *  총 4개의 배열 추출 마지막 빈값
     *  문자내 빈값까지 추출
     *  작성자 : 박세준 
     * @param str
     * @param regex
     * @return outputString
     */
    public static String[] getNullSplit(String str, String regex){
    	String data[] = new String[300];
		int i = 0;
		int j = 0;
		while(true){
			if(str.length() == 0){
				data[i] = "";
				break;
			}else if(regex.length() == 0){
				data[i] = str;
				break;
			}
			if(str.indexOf(regex) == 0){
				data[i] = "";
				str = str.substring(regex.length());
			}else{
				if(str.indexOf(regex) == -1){
					if(str.length() != 0){
						data[i] = str;
					}else{
						data[i] = "";
					}
					break;
				}else{
					data[i] = str.substring(0, str.indexOf(regex));
					str = str.substring(regex.length() + str.indexOf(regex));
				}	
			}
			i++;
		}
		
		for(j = 0; j < data.length; j++){
			if(data[j] == null){
				break;
			}
		}
		String return_data[] = new String[j];
		for(int k = 0 ; k < j; k++){
			return_data[k] = data[k];
		}
		return return_data;
	}
    
    /** 문자 암호화
     * 
     * @param originalStringData
     * @return */
    public static String encString ( String originalStringData , String type ) {
    	return originalStringData;	// 창성은 암호화 안함    
//        if ( originalStringData.trim ( ).length ( ) == 0 ) {
//            return originalStringData ;
//        }
//        
//        String changeStringData = "" ;
//        int bFirst = 1 ;
//        byte [ ] errbyte = new byte [ 6 ] ;
//        try {
//            
//            changeStringData = originalStringData ;
//            //CubeOneAPI coc = new CubeOneAPI ( ) ;
//            //coc.coinit ( bFirst , "API" , "SA" , "" , "" , "" , "" , "" , "" , "" , 100 ) ;
//            //changeStringData = coc.coencchar ( originalStringData , type , 10 , "" , "" , errbyte ) ;
//            
//        } catch ( Exception e ) {
//            e.printStackTrace ( ) ;
//            changeStringData = "false" ;
//        }
//        
//        return changeStringData ;
    }
    
    /** 암호화 문자 복호화
     * 
     * @param originalStringData
     * @return */
    public static String decString ( String originalStringData , String type ) {
    	return originalStringData;	// 창성은 복호화 안함
//        if ( originalStringData.trim ( ).length ( ) == 0 ) {
//            return originalStringData ;
//        }
//        
//        String changeStringData = "" ;
//        int bFirst = 1 ;
//        byte [ ] errbyte = new byte [ 6 ] ;
//        try {
//            
//            changeStringData = originalStringData ;
//            //CubeOneAPI coc = new CubeOneAPI ( ) ;
//            //coc.coinit ( bFirst , "API" , "SA" , "" , "" , "" , "" , "" , "" , "" , 100 ) ;
//            //changeStringData = coc.codecchar ( originalStringData , type , 10 , "" , "" , errbyte ) ;
//        } catch ( Exception e ) {
//            e.printStackTrace ( ) ;
//            changeStringData = "false" ;
//        }
//        
//        return changeStringData ;
    }
    
}
