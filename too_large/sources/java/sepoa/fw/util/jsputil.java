package sepoa.fw.util;

import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.StringTokenizer;
import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;

public class JSPUtil
{

    public JSPUtil()
    {
    }

	public static String getString(String src, String defValue) {
		if (src == null || "".equals(src)) return defValue;
		return src;
	}

    public static String ignoreSeparator(String s, String s1)
    {
        String s2 = "";
        for(StringTokenizer stringtokenizer = new StringTokenizer(s, s1); stringtokenizer.hasMoreTokens();)
            s2 = s2 + stringtokenizer.nextToken();

        return s2;
    }

    public static String CheckInjection(String result)
    {
        if(result != null && CommonUtil.getConfig("sepoa.not.lang.flag").equals("true"))
        {
            String originString = result;
            String cnt = CommonUtil.getConfig("sepoa.not.lang.count");
            int rowcnt = 0;
            if(checkNull(cnt) != null)
                rowcnt = Integer.parseInt(cnt);
            for(int i = 1; i < rowcnt + 1; i++)
            {
                String delword = CommonUtil.getConfig("sepoa.not.lang" + i);
                if(result.toUpperCase().indexOf(delword) != -1)
                {
                    int instr_location = result.toUpperCase().indexOf(delword);
                    String temp_str = result.substring(instr_location, instr_location + delword.length());
                    result = replace(result, temp_str, "");	//temp_str�� �����Ѵ�.
                    //System.out.println("\uD30C\uB77C\uBBF8\uD130\uAC12 " + originString + "\uC740 \uBCF4\uC548\uC810\uAC80\uC5D0 \uC704\uBC30 \uB429\uB2C8\uB2E4");
                    //System.out.println("\uD574\uB2F9 \uD30C\uB77C\uBBF8\uD130 \uAC12\uC744 " + result + "\uB85C \uBCC0\uACBD\uD569\uB2C8\uB2E4");
                }
            }

        }
        return result;
    }
    
    public static String CheckInjection2(String result)
    {
            String targetList = CommonUtil.getConfig("sepoa.target.html.encode");
            if(targetList != null) {
            	String[] targetArray = targetList.split(",");
            	StringBuffer to = new StringBuffer();
            	for(String target : targetArray) {
            		byte[] bs = target.getBytes();
            		for(byte b : bs) {
        				to.append("&#").append(b).append("&&");
            		}
            		result = StringUtils.replace(result, target, to.toString());
            		to = new StringBuffer();
            	}
            	result = StringUtils.replace(result, "&&", ";");
            }
            
        return result;
    }
    
    //[R101806291967] [2018-07-27] 2018년 우리은행 전자금융기반시설 취약점 분석평가 취약점 조치 요청(전자구매시스템 추가)
  	// - SQL에서 의미를 가지는 특수 문자(', %, !, --, # 등)가 포함되어 있을 경우 빈공백으로 대체 
    public static String CheckInjection3(String result)
    {
        if(result != null && CommonUtil.getConfig("sepoa.not.str.flag").equals("true"))
        {
            String originString = result;
            String cnt = CommonUtil.getConfig("sepoa.not.str.count");
            int rowcnt = 0;
            if(checkNull(cnt) != null)
                rowcnt = Integer.parseInt(cnt);
            for(int i = 1; i < rowcnt + 1; i++)
            {
                String delword = CommonUtil.getConfig("sepoa.not.str" + i);
                if(result.toUpperCase().indexOf(delword) != -1)
                {
                    int instr_location = result.toUpperCase().indexOf(delword);
                    String temp_str = result.substring(instr_location, instr_location + delword.length());
                    result = replace(result, temp_str, "");	//temp_str?? ???????.
                    //System.out.println("\uD30C\uB77C\uBBF8\uD130\uAC12 " + originString + "\uC740 \uBCF4\uC548\uC810\uAC80\uC5D0 \uC704\uBC30 \uB429\uB2C8\uB2E4");
                    //System.out.println("\uD574\uB2F9 \uD30C\uB77C\uBBF8\uD130 \uAC12\uC744 " + result + "\uB85C \uBCC0\uACBD\uD569\uB2C8\uB2E4");
                }
            }

        }
        return result;
    }

    public static String convertFormat(String data)
    {
    	if(data == null || "".equals(data)){
    		data ="";
    	}else{
    		if(data.length() == 1) data = "0"+data;	
    	}    	    	
    	return data;
    }	 	  
    
    public static String convertNumber(String value)
    {
        if(value == null || "null".equals(value))
            value = "0";
        else
        if(value.trim().equals(""))
            value = "0";
        return value;
    }    
    
    public static String convertStr(String value)
    {
        if(value == null || "null".equals(value))
            value = "";
        return value;
    }        

    public static String checkNull(String value)
    {
        if(value == null)
            value = null;
        else
        if(value.trim().equals(""))
            value = null;
        return value;
    }
    public static final boolean isValid(String foo)
    {
        return foo != null && foo.length() > 0;
    }

    public static String isBlank(Object foo)
    {
        return StringUtils.isBlank(String.valueOf(ObjectUtils.defaultIfNull(foo, ""))) ? "&nbsp" : String.valueOf(foo);
    }

    public static String ko(String foo)
        throws Exception
    {
        return foo != null ? CheckInjection(new String(foo.getBytes("8859_1"), "euc-kr")) : "";
    }

    public static String nonNullKo(String foo)
        throws Exception
    {
        if(foo == null)
            return foo;
        else
            return CheckInjection(new String(foo.getBytes("8859_1"), "euc-kr"));
    }

    public static String[] koForArray(String foo[])
        throws Exception
    {
        String tmp_init[] = {
            ""
        };
        if(foo == null)
            return tmp_init;
        for(int i = 0; i < foo.length; i++)
            foo[i] = new String(CheckInjection(foo[i]).getBytes("8859_1"), "euc-kr");

        return foo;
    }

    public static String nullToEmpty(String foo)
        throws Exception
    {
        if(foo == null || foo.equals("null") || foo.equals(""))
            foo = "";
        return CheckInjection(foo);
    }
    
    //[R101806291967] [2018-07-27] 2018년 우리은행 전자금융기반시설 취약점 분석평가 취약점 조치 요청(전자구매시스템 추가)
  	// - SQL에서 의미를 가지는 특수 문자(', %, !, --, # 등)가 포함되어 있을 경우 빈공백으로 대체 
    public static String nullToEmpty2(String foo)
            throws Exception
    {
        if(foo == null || foo.equals("null") || foo.equals(""))
            foo = "";
        return CheckInjection3(foo);
    }

    public static String nullToRef(String foo, String ref)
        throws Exception
    {
        if(foo == null || foo.equals("null") || foo.equals(""))
            foo = ref;
        return CheckInjection(foo);
    }

    public static String RepToPN(String foo, String pos, String neg)
        throws Exception
    {
        if(foo == null || foo.equals("null") || foo.equals(""))
            foo = neg;
        else
            foo = pos;
        return CheckInjection(foo);
    }

    public static String attachBracket(String str)
    {
        if(isValid(str))
        {
            str = ">" + str;
            StringBuffer sb = new StringBuffer(str);
            for(int i = 0; i < sb.length(); i++)
            {
                char t = sb.charAt(i);
                if(t == '\n' && i != sb.length() - 1)
                    sb.insert(i + 1, '>');
            }

            return sb.toString();
        } else
        {
            return str;
        }
    }

    public static String attachBR(String str)
    {
        if(str == null || str.length() == 0)
            return str;
        StringTokenizer st = new StringTokenizer(str, "\n", false);
        String res;
        for(res = ""; st.hasMoreTokens(); res = res + st.nextToken() + "<BR>\n");
        return res;
    }

    public static String paramCheck(String _param_string)
    {
    	return CheckInjection(nullChk(_param_string));
    }

    public static String nullChk(String s)
    {
        String rtn = "";
        String encoding_set = "";

        try
        {
            Configuration config = new Configuration();
            encoding_set = config.getString("sepoa.was.encoding");
        }
        catch (ConfigurationException e1)
        {
        	rtn = "";
        }

        if (s == null)
        {
            rtn = "";
        }
        else
        {
            try
            {
                rtn = URLDecoder.decode(URLEncoder.encode(s, encoding_set), encoding_set);
            }
            catch (UnsupportedEncodingException e)
            {
            	rtn = "";
            }
        }

        return rtn;
    }

    public static String fillZeroFront(int i, int j)
    {
        String s = "";
        String s1 = String.valueOf(i);
        for(int k = 0; k < j - s1.length(); k++)
            s = s + "0";

        s1 = s + s1;
        return s1;
    }


    public static String replace(String s, String s1, String s2)
    {
        int i = s.indexOf(s1);
        StringBuffer stringbuffer = new StringBuffer();
        if(i == -1)
            return s;
        stringbuffer.append(s.substring(0, i) + s2);
        if(i + s1.length() < s.length())
            stringbuffer.append(replace(s.substring(i + s1.length(), s.length()), s1, s2));
        return stringbuffer.toString();
    }

	public static String convertDate(String dataData, String addChar){
		String convert_year="";
		String convert_month ="";
		String convert_day="";

		if(addChar == null || "".equals(addChar)){
			addChar = "/";
		}

		if(dataData != null && dataData.length() ==8){
			convert_year = dataData.substring(0,4);
			convert_month = dataData.substring(4,6);
			convert_day = dataData.substring(6,8);
			dataData = convert_year+addChar+convert_month+addChar+convert_day;
		}
		return dataData;
	}
}
