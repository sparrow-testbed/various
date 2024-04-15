package wise.util;
import java.io.*;
import java.security.*;

import sepoa.fw.srv.Base64;

public class WiseEncrypt
{
	  public String getMD5(String input) throws Exception
	  {    	    
	      /*
		  byte[] plainText = null; // 평문
	      byte[] hashValue = null; // 해쉬 값
	      
	      // 해싱할 문자열을 입력 받아 바이트로 변환 한다.         
	      plainText = input.getBytes();
	      
	      // MD5알고리즘을 사용한 메시지 다이제스트를 생성해 해쉬값을 얻는다.
	      MessageDigest md = MessageDigest.getInstance("MD5");
	      hashValue = md.digest(plainText);
	      String rtn = new String(hashValue);
	      rtn = Base64Util.encode(rtn);    
	      return rtn;
	      */
		  
			if( input == null ) throw new Exception("Can't conver to Message Digest 5 String value!!");
			byte[] ret = digest("MD5", input.getBytes());
			String result = Base64Util.encode(ret);    
			return result;
	      
	  }
	
	    public static byte[] digest(String alg, byte[] input) throws NoSuchAlgorithmException {
	        MessageDigest md = MessageDigest.getInstance(alg);
	        return md.digest(input);
	    }	  
	  
}
