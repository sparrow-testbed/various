<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.codec.binary.Base64"%>
<%@page import="java.security.Key"%>
<%@page import="javax.crypto.SecretKey"%>
<%@page import="javax.crypto.Cipher" %>
<%@page import="javax.crypto.spec.SecretKeySpec" %>
<%@page import="javax.crypto.spec.IvParameterSpec" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%@page import="org.apache.commons.codec.binary.Hex" %>

<%!

	private static String encoding = "UTF-8";
	private static String defaultKey = "!key.woorifg.com";              // 암호화 Key정보(16자리)
	
	public static String getEncryptionKey(String xValue, String cmpIp) {
		try {
			String key = xValue + Integer.toHexString(Integer.parseInt(cmpIp)) + Integer.toOctalString(Integer.parseInt(cmpIp));
			key = key.substring(0,16);
			return key;
		} catch (Exception ex) {
			return defaultKey;
		}
	}

	public static String encryptAES(String valueToEncrypt, String encryptionKey) throws Exception {
		byte[] preSharedKey = encryptionKey.getBytes();  
		byte[] iv = encryptionKey.getBytes();
		byte[] data = valueToEncrypt.getBytes(encoding);
		SecretKey aesKey = new SecretKeySpec(preSharedKey, "AES");              
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		cipher.init(Cipher.ENCRYPT_MODE, aesKey, new IvParameterSpec(iv)); 
		byte[] output = cipher.doFinal(data);       
		String encryptedText = new String(Hex.encodeHex(output));
		return encryptedText;
	}

	public static String decryptAES(String valueToDecrypt,  String encryptionKey) throws Exception {     
		int len = valueToDecrypt.length();     
		byte[] data = new byte[len / 2];    
		for (int i = 0; i < len; i += 2) {        
		   data[i / 2] = (byte) ((Character.digit(valueToDecrypt.charAt(i), 16) << 4) + Character.digit(valueToDecrypt.charAt(i+1), 16));    
		} 

		byte[] keyBytes = encryptionKey.getBytes(encoding);
		byte[] ivBytes = keyBytes;
		IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		SecretKeySpec spec = new SecretKeySpec(keyBytes, "AES");
		Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");     
		cipher.init(Cipher.DECRYPT_MODE, spec, ivSpec);
		byte[] output = cipher.doFinal(data);
		String decryptedText = new String(output);
		return decryptedText;
	} 
	
		// 명칭을 DECODEER 함.
	public static String decodeName(String value ) {
		String rtn = "" ;
		try {
			if(value.startsWith("=?UTF-8?B?")){
				String base64Value = value.substring(10,value.indexOf("?=") );
				byte[] decodedValue = Base64.decodeBase64(base64Value.getBytes()); 
				String decodedString = new String( decodedValue, "UTF-8" );
				rtn = decodedString;
			}
		} catch(Exception e){
			return "false";
		}
		return rtn ;
	}
%>