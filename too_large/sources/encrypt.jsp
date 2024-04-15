<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@page import="java.security.Key"%>
<%@page import="javax.crypto.Cipher" %>
<%@page import="javax.crypto.spec.SecretKeySpec" %>
<%@page import="javax.xml.bind.DatatypeConverter" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%!

private static String algorithm = "AES";
private static byte[] keyValue;

        // Performs Encryption
        public static String encrypt(String plainText, String xValue, String cmpIp) 
        {
        	try{
				Key key = generateKey(xValue, cmpIp);
				//System.out.println("Encrypt Key=" + DatatypeConverter.printHexBinary(key.getEncoded()));
				Cipher chiper = Cipher.getInstance(algorithm);
				chiper.init(Cipher.ENCRYPT_MODE, key);
				byte[] encVal = chiper.doFinal(plainText.getBytes());
				String encryptedValue = new BASE64Encoder().encode(encVal);
				return encryptedValue;
        	}catch(Exception e){
        		return "false";
        	}
        }

        // Performs decryption
        public static String decrypt(String encryptedText, String xValue, String cmpIp)  
        {
        	try{
				// generate key 
				Key key = generateKey(xValue, cmpIp);
				//System.out.println("Decode Key=" + DatatypeConverter.printHexBinary(key.getEncoded()));
				Cipher chiper = Cipher.getInstance(algorithm);
				chiper.init(Cipher.DECRYPT_MODE, key);
				byte[] decordedValue = new BASE64Decoder().decodeBuffer(encryptedText);
				byte[] decValue = chiper.doFinal(decordedValue);
				String decryptedValue = new String(decValue);
				return decryptedValue;
        	}catch(Exception e){
        		return "false";
        	}
       	}

//generateKey() is used to generate a secret key for AES algorithm
        private static Key generateKey(String xValue, String cmpIp) throws Exception 
        {
			xValue = xValue + Integer.toHexString(Integer.parseInt(cmpIp)) + Integer.toOctalString(Integer.parseInt(cmpIp));
    	 	xValue = xValue.substring(0,16);
        	keyValue = xValue.getBytes();
			Key key = new SecretKeySpec(keyValue, algorithm);
			return key;
        }
        // 명칭을 DECODEER 함.
       public static String decode_name(String value )  
        {
        	String rtn = "" ;
        	try{

			if(value.startsWith("=?UTF-8?B?")){
				String base64Value = value.substring(10,value.indexOf("?=") );
				BASE64Decoder decoder=new BASE64Decoder();
				String decodeString = new String( decoder.decodeBuffer(base64Value), "UTF-8" );
				//System.out.println("[Parsing_Before => " + value);		
				//System.out.println("[Parsing_After =>" + decodeString);
				rtn = decodeString;
			}
        	}catch(Exception e){
        		return "false";
        	}
		return rtn ;
       	}

        
%>