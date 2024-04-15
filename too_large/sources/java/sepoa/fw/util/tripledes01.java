package sepoa.fw.util;


import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;


import sepoa.fw.srv.Base64; 

public class TripleDes01 {

	/*public static void main(String[] args) {
		// TODO Auto-generated method stub

	}*/
	  
	public TripleDes01(){}
	
	public static String encrypt(String message) throws Exception{
		  
		String base64EncString  = "";
		String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
		  
		  //MessageDigest md        = MessageDigest.getInstance("SHA-1");
		  //byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
		  //byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
		  byte[] keyBytes           = secretKey.getBytes("utf-8");
		
		  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
		  Cipher cipher = Cipher.getInstance("DESede");
		  cipher.init(Cipher.ENCRYPT_MODE, key);
		  
		  
			try{
			byte[] plainTextBytes  = message.getBytes("utf-8");
			byte[] buf             = cipher.doFinal(plainTextBytes);
			byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
			base64EncString        = new String(base64Bytes);
			}catch(Exception e){
//			  e.printStackTrace();
				base64EncString = "";
			}
			return base64EncString;
	  }
	  
	   public static String decrypt(String encryptedText) throws Exception{
		  String base64DecString  = "";
		  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
			
		  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
	   
	      //MessageDigest md        = MessageDigest.getInstance("SHA-1");
	      //byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
	      //byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
		  byte[] keyBytes           = secretKey.getBytes("utf-8");
		  
		  try{
			  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
			  Cipher decipher     = Cipher.getInstance("DESede");
			  decipher.init(Cipher.DECRYPT_MODE, key);
			  
			  byte[] plainText    = decipher.doFinal(message);
			  base64DecString     = new String(plainText,"UTF-8");
			 
		  }catch(Exception e){
//		      e.printStackTrace();
			  base64DecString = "";
		  }
		      
		  return base64DecString;
	  }
	  
	   
	   public static String decryptText(String encryptedText) throws Exception{
			  String base64DecString  = "";
			  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
				
			  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
		     byte[] keyBytes           = secretKey.getBytes();
			  
			  try{
				  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
				  Cipher decipher     = Cipher.getInstance("DESede/CBC/PKCS5Padding");
				  decipher.init(Cipher.DECRYPT_MODE, key);
				  
				  byte[] plainText    = decipher.doFinal(message);
				  base64DecString     = new String(plainText,"UTF-8");
				 
			  }catch(Exception e){
//			      e.printStackTrace();
				  base64DecString = "";
			  }
			      
			  return base64DecString;
		  }
		   
	   
	   
	   
	   
}
