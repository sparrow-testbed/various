package sepoa.fw.util;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import sepoa.fw.srv.Base64;

//3DES 암호화로 암호화복호화를 한다.

public class CryptoUtil {

	  private static Key key = null;
	  
	  static{
		  if(key == null){
			  //key 초기화
			  KeyGenerator keyGenerator;
			  try{
			    keyGenerator = KeyGenerator.getInstance("TripleDES");
				//keyGenerator = KeyGenerator.getInstance("l9pjOOQv72lLOnprDc5ppRL7");
				   
				keyGenerator.init(168);
			    key = keyGenerator.generateKey();
			    
			  }catch(NoSuchAlgorithmException e){
//			    e.printStackTrace();
				  key = null;
			  }
		  }
	  }
	  
	  public static String encode(String inStr){
	    StringBuffer sb = null; int rtn = 0;
	    try{
	    	
	      Cipher cipher = Cipher.getInstance("TripleDES/ECB/PKCS5Padding");
	      cipher.init(Cipher.ENCRYPT_MODE, key);
	      
	      byte[] plaintext = inStr.getBytes("UTF8");
	      byte[] ciphertext = cipher.doFinal(plaintext);
	      
	      sb = new StringBuffer(ciphertext.length *2);
	      for(int i=0;i<ciphertext.length;i++){
	        String hex = "0"+Integer.toHexString(0xff & ciphertext[i]);
	        sb.append(hex.substring(hex.length()-2));
	        
	      }
	      
	    }catch(Exception e){
//	      e.printStackTrace();
	    	 rtn = -1;
	    }
	    return (sb != null)?sb.toString():"";
	  
	  }
	  
	  
	   public static String decode(String inStr){
	    String text = null;
		    try{
		      byte[] b = new byte[inStr.length()/2];
		     
		      Cipher cipher = Cipher.getInstance("TripleDES/ECB/PKCS5Padding");
		      cipher.init(Cipher.DECRYPT_MODE, key);
		      
		      for(int i=0;i<b.length;i++){
		        b[i] = (byte)Integer.parseInt(inStr.substring(2*i,2*i+2),16);
		      }
		      byte[] decryptedText = cipher.doFinal(b);
		      text = new String(decryptedText,"UTF8");  
		     
		      
		    }catch(Exception e){
//		      e.printStackTrace();
		    	text = null;
		    }
		    return text;
	  
	  }

		public static String encryptText(String message) throws Exception{

			  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
			  String base64EncString  = "";
			  
			  //MessageDigest md        = MessageDigest.getInstance("MD5");
			  //byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			  //byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			  byte[] keyBytes           = secretKey.getBytes("utf-8");
			
			  //byte[] iv = new byte[8];
			  byte[] iv = {'%', '1', 'A', 'z', '=', '-', '@', 'q'};
			  IvParameterSpec ivSpec = new IvParameterSpec(iv);
			  
			  
			  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
			  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			  cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
			  
			  
//				try{
				byte[] plainTextBytes  = message.getBytes("utf-8");
				byte[] buf             = cipher.doFinal(plainTextBytes);
				byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
				base64EncString        = new String(base64Bytes);
//				}catch(Exception e){
////				  e.printStackTrace();
//				}
				return base64EncString;
		  }
	   
	   
	   public static String decryptText(String encryptedText) throws Exception{
		   String base64DecString  = "";
		   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
		   //String encryptedText =  "eeiMsD7il6zC2Y5umwz9/qzON7fzmGTl";
		   
//		   if(test != null){
//		   encryptedText = test;
//		   }
		   
		   byte[] message          = Base64.base64Decode(encryptedText.getBytes());
		   byte[] keyBytes           = secretKey.getBytes();
//		   byte[] iv = new byte[8];
		   byte[] iv = {'%', '1', 'A', 'z', '=', '-', '@', 'q'};
		   IvParameterSpec ivSpec = new IvParameterSpec(iv);
		   
		   SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
		   Cipher decipher     = Cipher.getInstance("DESede/CBC/PKCS5Padding");
		 //  Cipher decipher     = Cipher.getInstance("DESede");
		   
		   decipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
		   
		   byte[] plainText    = decipher.doFinal(message);
		   base64DecString     = new String(plainText);
		      
		   return base64DecString;
		   }
	   
		public static String getSHA256(String str) throws Exception{
			String rtnSHA = "";
			
			try{
				MessageDigest md = MessageDigest.getInstance("SHA-256");
				md.update(str.getBytes());
				byte byteData[] = md.digest();
				StringBuffer sb = new StringBuffer();
				
				for(int i=0;i<byteData.length;i++){
					sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
				}
				
				rtnSHA = Base64.base64Encode(sb.toString());
				
			}catch(NoSuchAlgorithmException e){
//				e.printStackTrace();
				rtnSHA = null;
			}
			
			return rtnSHA;
		}
		
		public static String encryptText2(String message) throws Exception{

			  String secretKey = "27pjOOQv32lLOnprDc9ppRL3";
			  String base64EncString  = "";
			  
			  //MessageDigest md        = MessageDigest.getInstance("MD5");
			  //byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			  //byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			  byte[] keyBytes           = secretKey.getBytes("EUC-KR");
			
			  //byte[] iv = new byte[8];
			  byte[] iv = {'%', '1', 'A', 'z', '=', '-', '@', 'q'};
			  IvParameterSpec ivSpec = new IvParameterSpec(iv);
			  
			  
			  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
			  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			  cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
			  
			  
//				try{
				byte[] plainTextBytes  = message.getBytes("EUC-KR");
				byte[] buf             = cipher.doFinal(plainTextBytes);
				byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
				base64EncString        = new String(base64Bytes);
//				}catch(Exception e){
////				  e.printStackTrace();
//				}
				return base64EncString;
		  }
	   
	   
	   public static String decryptText2(String encryptedText) throws Exception{
		   String base64DecString  = "";
		   String secretKey = "27pjOOQv32lLOnprDc9ppRL3";
		   //String encryptedText =  "eeiMsD7il6zC2Y5umwz9/qzON7fzmGTl";
		   
//		   if(test != null){
//		   encryptedText = test;
//		   }
		   
		   byte[] message          = Base64.base64Decode(encryptedText.getBytes("EUC-KR"));
		   byte[] keyBytes           = secretKey.getBytes("EUC-KR");
//		   byte[] iv = new byte[8];
		   byte[] iv = {'%', '1', 'A', 'z', '=', '-', '@', 'q'};
		   IvParameterSpec ivSpec = new IvParameterSpec(iv);
		   
		   SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
		   Cipher decipher     = Cipher.getInstance("DESede/CBC/PKCS5Padding");
		 //  Cipher decipher     = Cipher.getInstance("DESede");
		   
		   decipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
		   
		   byte[] plainText    = decipher.doFinal(message);
		   base64DecString     = new String(plainText);
		      
		   return base64DecString;
		   }
		
}
	

