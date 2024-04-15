package com.icompia.util;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.cfg.ConfigurationException;
import sepoa.fw.log.Logger;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDate;
 
public class CommonUtil {
	public static String getConfig(String s) {
		try {
			Configuration configuration = new Configuration();
			s = configuration.get(s);
			return s;
		} catch (ConfigurationException configurationexception) {
			Logger.sys.println("getConfig error : "
					+ configurationexception.getMessage());
		} catch (Exception exception) {
			Logger.sys.println("getConfig error : " + exception.getMessage());
		}
		return null;
	}
	
	public static String nullToEmpty(String str) {
		String rtn = "";
		try {
			rtn = JSPUtil.nullToEmpty(str);
		} catch (Exception e) {
			//e.printStackTrace();
			rtn = "";
		}
		return rtn;
	}
	
	//[R101806291967] [2018-07-27] 2018년 우리은행 전자금융기반시설 취약점 분석평가 취약점 조치 요청(전자구매시스템 추가)
	// - SQL에서 의미를 가지는 특수 문자(', %, !, --, # 등)가 포함되어 있을 경우 빈공백으로 대체 
	public static String nullToEmpty2(String str) {
		String rtn = "";
		try {
			rtn = JSPUtil.nullToEmpty2(str);
		} catch (Exception e) {
			//e.printStackTrace();
			rtn = "";
		}
		return rtn;
	}

	public static int getComboIndex(String strLB, String strCode,
			String lineSeparator) {
		int iIndex = strLB.indexOf(strCode);
		if (iIndex < 0) {
			return 0;
		}
		String strTemp = strLB.substring(0, iIndex);
		return countMatches(strTemp, lineSeparator);
	}

	public static int countMatches(String str, String sub) {
		if ((isEmpty(str)) || (isEmpty(sub))) {
			return 0;
		}
		int count = 0;
		int idx = 0;
		while ((idx = str.indexOf(sub, idx)) != -1) {
			++count;
			idx += sub.length();
		}
		return count;
	}

	public static boolean isEmpty(String str) {
		return ((str != null) && (str.length() != 0));
	}

	public static String[] getTokenData(String tokendata, String delm) {
		return getTokenData(tokendata, delm, false);
	}

	public static String[] getTokenData(String tokendata, String delm,
			boolean last) {
		List list = new ArrayList();
		int start = 0;
		int end = 0;
		while (true) {
			end = tokendata.indexOf(delm);

			if (end < 0) {
				if (!(last))
					break;
				list.add(tokendata.substring(start));
				break;
			}

			list.add(tokendata.substring(start, end));
			tokendata = tokendata.substring(end + 1, tokendata.length());
		}

		return ((String[]) list.toArray(new String[list.size()]));
	}

	public static int getComboIndex(String[][] cbo, String cbo_value) {
		int idx_rtn = 0;

		for (int i = 0; i < cbo.length; ++i) {
			if (cbo_value == null)
				break;
			if (!(cbo[i][1].equals(cbo_value)))
				continue;
			idx_rtn = i;
			break;
		}

		return idx_rtn;
	}

	public static String getServerDate() {
		String add_date = SepoaDate.getShortDateString();
		String add_time = SepoaDate.getShortTimeString();
		return add_date + add_time;
	}

	public static String combinationArr(String[] arr, String delm) {
		String rtn = "";
		if (arr == null) {
			return "";
		}

		int iArrLength = arr.length;

		if (iArrLength == 0) {
			return "";
		}

		for (int i = 0; i < iArrLength; ++i) {
			if (i == iArrLength - 1) {
				rtn = rtn + arr[i];
			} else {
				rtn = rtn + arr[i] + delm;
			}
		}

		return rtn;
	}

	public static String lpad(String str, int length, String repChar) {
		for (int i = str.length(); i < length; ++i) {
			str = repChar + str;
		}

		return str;
	}

	public static String[] StrToArray(String str, String str2) {
		StringTokenizer st = new StringTokenizer(str, str2, false);
		int cnt = st.countTokens();
		String[] value = new String[cnt];

		for (int count = 0; count < cnt; ++count) {
			value[count] = st.nextToken().trim();
			if (value[count].length() == 0) {
				value[count] = " ";
			}
		}
		return value;
	}

	public static String[] parseValue(String value, String dl) {
		String token = dl;
		if (value == null)
			return null;

		Vector v = new Vector();

		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while (token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if (end_token_count == -1) {
				token_flag = false;
			} else {
				String subvalue = value.substring(start_token_count,
						end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue);
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}

	public static String getCtrlCodes(String ctrl_code) {
		StringTokenizer st1 = new StringTokenizer(ctrl_code, "&", false);
		int count1 = st1.countTokens();
		String purchaserUser_seperate = "";

		if (count1 == 0)
			purchaserUser_seperate = ctrl_code;
		else {
			for (int i = 0; i < count1; ++i) {
				String tmp_ctrl_code = st1.nextToken();

				if (i == 0)
					purchaserUser_seperate = tmp_ctrl_code;
				else
					purchaserUser_seperate = purchaserUser_seperate + "','"
							+ tmp_ctrl_code;
			}
		}
		return purchaserUser_seperate;
	}

	public static String RepToStr(String foo, String pos, String neg)
			throws Exception {
		if ((foo == null) || (foo.equals("null")) || (foo.equals(""))) {
			foo = "";
		} else if (foo.equals("true"))
			foo = pos;
		else if (foo.equals("false"))
			foo = neg;

		return foo;
	}

	public static String urlDecode(String str, String enc) {
		String rtn = "";
		try {
			rtn = URLDecoder.decode(str, enc);
		} catch (Exception e) {
			//e.printStackTrace();
			rtn = "";
		}
		return rtn;
	}

	public static String urlEncode(String str, String enc) {
		String rtn = "";
		try {
			rtn = URLEncoder.encode(str, enc);
		} catch (Exception e) {
			//e.printStackTrace();
			rtn = "";
		}
		return rtn;
	}
	 
	public static String getRandomString(int randomStringLength, String type){
		String[] num = null;
		String[] numberType 		= {"0","1","2","3","4","5","6","7","8","9"};
		String[] stringType 		= {"A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z"};
		String[] numberStringType 	= {"A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"};
		if("N".equals(type)){
			num = numberType;
		}else if("S".equals(type)){
			num = stringType;
		}else if("NS".equals(type)){
			num = numberStringType;
		}else{ num = numberStringType; }
		
		String[] history = new String[randomStringLength];
		int count1 = history.length;
		boolean cont = true;
		String randomString = "";
		for(int i=0; i<count1 ; i++) {
			while(true){
				cont = true;
				int randomNum=(int)(Math.random()*num.length);

				history[i] = num[randomNum];

				for(int j=0; j<i ; j++) {
					if(history[j].equals(history[i])){
	                        cont = false;
	                        break;
					}
				}
				if (cont) break;
			}
			randomString += history[i];
		}
		
		return randomString;
	}
}
