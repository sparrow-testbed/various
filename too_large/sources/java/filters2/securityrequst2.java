package filters2;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.apache.commons.lang.StringUtils;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.SepoaString;

public class SecurityRequst2 extends HttpServletRequestWrapper
{
  private static Pattern XSS_SCRIPT_PATTERN_1 = Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE);
  private static Pattern XSS_SCRIPT_PATTERN_2 = Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
  private static Pattern XSS_SCRIPT_PATTERN_3 = Pattern.compile("</script>", Pattern.CASE_INSENSITIVE);
  private static Pattern XSS_SCRIPT_PATTERN_4 = Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
  private static Pattern XSS_SCRIPT_PATTERN_5 = Pattern.compile("eval[\\s]*\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
  private static Pattern XSS_SCRIPT_PATTERN_6 = Pattern.compile("expression[\\s]*\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
  private static Pattern XSS_SCRIPT_PATTERN_7 = Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE);
  private static Pattern XSS_SCRIPT_PATTERN_8 = Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE);
  private static Pattern XSS_SCRIPT_PATTERN_9 = Pattern.compile("<(body|embed|frame|script|link|iframe|object|style|frameset|meta|img|div)[\\s]*[^>]*[\\s]*>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);
  private static Pattern XSS_SCRIPT_PATTERN_10 = Pattern.compile("on[a-z]+[^\\S\n]*=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);	

  public SecurityRequst2(HttpServletRequest request)
  {
    super(request);
  }

  public String[] getParameterValues(String parameter)
  {
    String[] values = super.getParameterValues(parameter);
    if (values == null) {
      return null;
    }
    int count = values.length;
    String[] encodedValues = new String[count];
    for (int i = 0; i < count; i++) {
      encodedValues[i] = stripXSS(values[i]);
    }
    return encodedValues;
  }

  public String getParameter(String parameter)
  {
    String value = super.getParameter(parameter);
    String orgValue = value;
    value = stripXSS(value);

    return value;
  }

  public String getHeader(String name)
  {
    String value = super.getHeader(name);
    return stripXSS(value);
  }
/*
  private String stripXSS(String value) {
    if (value != null)
    {
      value = value.replaceAll("", "");
      value = XSS_SCRIPT_PATTERN_1.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_2.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_3.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_4.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_5.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_6.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_7.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_8.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_9.matcher(value).replaceAll("");
      value = XSS_SCRIPT_PATTERN_10.matcher(value).replaceAll("");
    }
    return value;
  }
*/
/*
private String stripXSS(String value) {
	if (value != null)
	{
		value = value.replaceAll("", "");
	    value = XSS_SCRIPT_PATTERN_1.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_2.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_3.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_4.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_5.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_6.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_7.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_8.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_9.matcher(value).replaceAll("");
	    value = XSS_SCRIPT_PATTERN_10.matcher(value).replaceAll("");
	}
	return value;
}
*/
private String stripXSS(String value) {
	if (value != null)
	{
		value = value.replaceAll("", "");
		while (XSS_SCRIPT_PATTERN_1.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_1.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_2.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_2.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_3.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_3.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_4.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_4.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_5.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_5.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_6.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_6.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_7.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_7.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_8.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_8.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_9.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_9.matcher(value).replaceAll("");
		}
		while (XSS_SCRIPT_PATTERN_10.matcher(value).find()) {
			value = XSS_SCRIPT_PATTERN_10.matcher(value).replaceAll("");
		}
	}
	return value;
}

}