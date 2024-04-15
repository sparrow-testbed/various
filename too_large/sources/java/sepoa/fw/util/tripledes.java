package sepoa.fw.util;

import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import com.oreilly.servlet.Base64Encoder;

import sepoa.fw.srv.Base64; 

public class TripleDes {
	 
	public TripleDes(){}
	
	public static String encrypt(String message, String secretKey) throws Exception{
		  
		  String base64EncString  = "";
		  
		  MessageDigest md        = MessageDigest.getInstance("SHA-1");
		  byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
		  byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
		  
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
	  
	   public static String decrypt(String encryptedText, String secretKey) throws Exception{
		  String base64DecString  = "";
		  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
	   
	      MessageDigest md        = MessageDigest.getInstance("SHA-1");
	      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
	      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
	  
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

	
}
