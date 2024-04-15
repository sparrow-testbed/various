package sepoa.fw.util;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class pwdPolicy {
	
	public static String isNewValidPwd(String str_id, String str_pwd )
	{
//		if ( str_pwd == null || str_pwd == "" || "".equals(str_pwd) ) 
//		{
//			return "비밀번호를 입력하세요.";
//		//} else if ( str_pwd.matches("\\s") ) {
//		} else {
//			// 공백사용 불가
//			if(isStringExist("^[\\s]{1,1}$", str_pwd) == true)
//			{
//				return "비밀번호에는 공백을 사용할 수 없습니다.";
//			}
//		}		
		if ( str_pwd != null && !"".equals(str_pwd) ) 
		{
			// 공백사용 불가
			if(isStringExist("^[\\s]{1,1}$", str_pwd) == true)
			{
				return "비밀번호에는 공백을 사용할 수 없습니다.";
			}
		} else {
			return "비밀번호를 입력하세요.";
		}
		
		int cnt = 0;
		for( int i=0; i<str_pwd.length(); ++i)
		{
			if( str_pwd.substring(0, 1).equals( str_pwd.substring(i, i+1) ) ) ++cnt;
		}
		
		if ( cnt == str_pwd.length() )
		{
			// 동일문자 사용금지....
			return "보안상의 이유로 한 문자로 연속된 비밀번호는 허용하지 않습니다.";
		}
		
		if (str_id.equals(str_pwd))
		{
			return "아이디와 동일한 비밀번호를 사용하실수 없습니다.";
		}

		// 영문, 숫자, 특수문자가 아닌 것은 사용 할 수 없음.:8~10자리 채워서
		String isPW = "^[A-Za-z0-9`\\-=\\\\\\[\\];,\\./~!@#\\$%\\^&\\*\\(\\)_\\+|\\{\\}:\"<>\\?]{8,10}$";
		Pattern pattern = Pattern.compile(isPW);
		Matcher matcher = pattern.matcher(str_pwd);
		if( !matcher.matches() )
		{
			return "비밀번호는 8~10자의 영문 대소문자와 숫자, 특수문자를 사용할 수 있습니다.";
		}
		
		int nPassLen = str_pwd.length();
		boolean nPassFlag01 = false;
		boolean nPassFlag02 = false;
		boolean nPassFlag03 = false;
		
		String isPW1 = "^[A-Za-z]{1,1}$";
		// 영문자 사용했는지...
		nPassFlag01 = isStringExist(isPW1, str_pwd);
		
		String isPW2 = "^[0-9]{1,1}$";
		// 숫자 사용했는지...
		nPassFlag02 = isStringExist(isPW2, str_pwd);
		
		String isPW3 = "^[`\\-=\\\\\\[\\];,\\./~!@#\\$%\\^&\\*\\(\\)_\\+|\\{\\}:\"<>\\?]{1,1}$";
		// 특수문자 사용했는지...
		nPassFlag03 = isStringExist(isPW3, str_pwd);
		
		if (nPassFlag01 == true && nPassFlag02 == true && nPassFlag03 == true )
		{
			// 	isPW 에서 최소 8자리는 이미 체크 했으므로 통과	
		}
		else
		{
			if (    ( nPassFlag01 == true &&  (nPassFlag02 == true || nPassFlag03 == true)  )
			     || ( nPassFlag02 == true &&  (nPassFlag01 == true || nPassFlag03 == true)  )
			     || ( nPassFlag03 == true &&  (nPassFlag01 == true || nPassFlag02 == true)  )
			   )
			{
				if ( nPassLen < 10 )
				{
					return "패스워드는 영문 대소문자, 숫자, 특수문자중\\r\\n2가지 조합일경우 10자리\\r\\n3가지 조합일경우 8자리 이상으로 구성하셔야 합니다.";
				}
			}
		}

		
		return "";
	}
	
	// 해당문자가 사용되었는지 여부
	public static boolean isStringExist(String isPW, String strString)
	{
		boolean retFlag = false;

		for( int i=0; i<strString.length(); ++i)
		{
			if ( Pattern.matches(isPW, strString.substring(i,i+1)) )
			{
				retFlag = true;
				break;
			}
		}
		return retFlag;
	}
}
