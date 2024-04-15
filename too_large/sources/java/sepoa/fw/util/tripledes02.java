package sepoa.fw.util;


import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.KeySpec;
import java.util.Arrays;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESedeKeySpec;
import javax.crypto.spec.SecretKeySpec;









import sepoa.fw.srv.Base64; 

public class TripleDes02 {

	/*public static void main(String[] args) {
		// TODO Auto-generated method stub

	}*/
	  
	public TripleDes02(){}
	
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
				base64EncString  = "";
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
			  base64DecString  = "";
		  }
		      
		  return base64DecString;
	  }
	  
	   
	   public static String encryptText(String message) throws Exception{
			  
			String base64EncString  = "";
			String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
			  
			  MessageDigest md        = MessageDigest.getInstance("md5");
			  byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			  byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			  //byte[] keyBytes           = secretKey.getBytes("utf-8");
			
			  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
			  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			  cipher.init(Cipher.ENCRYPT_MODE, key);
			  
			  
				try{
				byte[] plainTextBytes  = message.getBytes("utf-8");
				byte[] buf             = cipher.doFinal(plainTextBytes);
				byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
				base64EncString        = new String(base64Bytes);
				}catch(Exception e){
					base64EncString  = "";
				}
				return base64EncString;
		  }
	   
	   public static String decryptText(String encryptedText) throws Exception{
			  String base64DecString  = "";
			  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
				
			 
			  try{
				  
				  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
				   
			      MessageDigest md        = MessageDigest.getInstance("md5");
			      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			      
//				  byte[] keyBytes           = secretKey.getBytes("utf-8");
				  
				  
				  for(int j=0,k=16;j<8;){
					  keyBytes[k++] = keyBytes[j++];
				  }
				  
				  KeySpec keySpec = new DESedeKeySpec(keyBytes);
				  //SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
				  SecretKey key   = SecretKeyFactory.getInstance("DESede").generateSecret(keySpec);
				  
				  Cipher decipher     = Cipher.getInstance("DESede/CBC/PKCS5Padding");
				  decipher.init(Cipher.DECRYPT_MODE, key);
				  
				  byte[] plainText    = decipher.doFinal(message);
				  base64DecString     = new String(plainText,"UTF-8");
				 
			  }catch(Exception e){
				  base64DecString  = "";
			  }
			      
			  return base64DecString;
		  }
		   
// Base64
		public static String encryptText02(String message) throws Exception{
			
			String base64EncString  = "";
			String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
			  
			 //MessageDigest md        = MessageDigest.getInstance("md5");
			 // byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			 // byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			 byte[] keyBytes           = secretKey.getBytes("utf-8");
			
			  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
			  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
			  cipher.init(Cipher.ENCRYPT_MODE, key);
			  
			  
				try{
				byte[] plainTextBytes  = message.getBytes("utf-8");
				byte[] buf             = cipher.doFinal(plainTextBytes);
				byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
				base64EncString        = new String(base64Bytes);
				}catch(Exception e){
					base64EncString  = "";
				}
				return base64EncString;
		  }
		  
// Base64	   
	   public static String decryptText02(String encryptedText) throws Exception{
		   String base64DecString  = "";
		   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
				
			  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
//			  byte[] message          = encryptedText.getBytes("utf-8");	//sepoa base64참조
		   
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
				  base64DecString  = "";
			  }
			      
			  return base64DecString;
		  
		  }
	   
	 //none Base64
	 		public static String encryptText02No(String message) throws Exception{
	 			String base64NonString  = "";
	 			String base64EncString  = "";
	 			String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
	 			  
	 			 //MessageDigest md        = MessageDigest.getInstance("md5");
	 			 // byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
	 			 // byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
	 			 byte[] keyBytes           = secretKey.getBytes("utf-8");
	 			
	 			  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
	 			  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
	 			  cipher.init(Cipher.ENCRYPT_MODE, key);
	 			  
	 			  
	 				try{
	 				byte[] plainTextBytes  = message.getBytes("utf-8");
	 				byte[] buf             = cipher.doFinal(plainTextBytes);
	 				//byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
	 				//base64EncString        = new String(base64Bytes);
	 				//base64NonString          = new String(buf,"UTF-8");
	 				base64NonString          = new String(buf);
	 				}catch(Exception e){
	 					base64NonString  = "";
	 				}
	 				return base64NonString;
	 		  }
	 		  
	 //none Base64	   
	 	   public static String decryptText02No(String encryptedText) throws Exception{
	 		   String base64NonString   = "";
	 		   String base64DecString  = "";
	 		   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
	 				
//	 			  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
	 			  byte[] message          = encryptedText.getBytes("utf-8");	//sepoa base64참조
	 		   
	 		      //MessageDigest md        = MessageDigest.getInstance("SHA-1");
	 		      //byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
	 		      //byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
	 			  byte[] keyBytes           = secretKey.getBytes("utf-8");
	 			  
	 			  try{
	 				  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
	 				  Cipher decipher     = Cipher.getInstance("DESede");
	 				  decipher.init(Cipher.DECRYPT_MODE, key);
	 				  
	 				  byte[] plainText    = decipher.doFinal(message);
//	 				  base64DecString     = new String(plainText,"UTF-8");
	 				  base64NonString     = new String(plainText,"UTF-8");
	 				 
	 			  }catch(Exception e){
	 				 base64DecString  = "";
	 			  }
	 			      
	 			  return base64DecString;
	 		  
	 		  }
	 	   
		public static String encrypt03(String message, String secretKey) throws Exception{
			  
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
					base64EncString  = "";
				}
				return base64EncString;
		  }
		  
		   public static String decrypt03(String encryptedText, String secretKey) throws Exception{
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
				  base64DecString  = "";
			  }
			      
			  return base64DecString;
		  }

		   
			public static String encrypt03No(String message, String secretKey) throws Exception{
				  
				  String base64EncString  = "";
				  
				  MessageDigest md        = MessageDigest.getInstance("md5");
				  byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
				  byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
				  
				  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
				  Cipher cipher = Cipher.getInstance("DESede");
				  cipher.init(Cipher.ENCRYPT_MODE, key);
				  
				  
					try{
					byte[] plainTextBytes  = message.getBytes("utf-8");
					byte[] buf             = cipher.doFinal(plainTextBytes);
//					byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
//					base64EncString        = new String(base64Bytes);
					//byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
					base64EncString        = new String(buf, "UTF-8");
					}catch(Exception e){
						base64EncString  = "";
					}
					return base64EncString;
			  }
			  
			   public static String decrypt03No(String encryptedText, String secretKey) throws Exception{
				  String base64DecString  = "";
//				  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
				  byte[] message          = encryptedText.getBytes("utf-8");	//sepoa base64참조
			   
			      MessageDigest md        = MessageDigest.getInstance("md5");
			      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
			      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
			  
				  try{
					  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
					  Cipher decipher     = Cipher.getInstance("DESede");
					  decipher.init(Cipher.DECRYPT_MODE, key);
					  
					  byte[] plainText    = decipher.doFinal(message);
					  base64DecString     = new String(plainText,"UTF-8");
					 
				  }catch(Exception e){
					  base64DecString  = "";
				  }
				      
				  return base64DecString;
			  }
		   
	   
				public static String encrypt04(String message) throws Exception{

					  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
					  String base64EncString  = "";
					  
					  MessageDigest md        = MessageDigest.getInstance("MD5");
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
							base64EncString  = "";
						}
						return base64EncString;
				  }
				  
				   public static String decrypt04(String encryptedText) throws Exception{
					   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
			 			
					   String base64DecString  = "";
					  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
				   
				      MessageDigest md        = MessageDigest.getInstance("MD5");
				      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
				      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
				  
					  try{
						  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
						  Cipher decipher     = Cipher.getInstance("DESede");
						  decipher.init(Cipher.DECRYPT_MODE, key);
						  
						  byte[] plainText    = decipher.doFinal(message);
						  base64DecString     = new String(plainText,"UTF-8");
						 
					  }catch(Exception e){
						  base64DecString  = "";
					  }
					      
					  return base64DecString;
				  }

					public static String encrypt04No(String message) throws Exception{

						  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
						  String base64EncString  = "";
						  
						  MessageDigest md        = MessageDigest.getInstance("MD5");
						  byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
						  byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
						  
						  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
						  Cipher cipher = Cipher.getInstance("DESede");
						  cipher.init(Cipher.ENCRYPT_MODE, key);
						  
						  
							try{
							byte[] plainTextBytes  = message.getBytes("utf-8");
							byte[] buf             = cipher.doFinal(plainTextBytes);
							//byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
							//base64EncString        = new String(base64Bytes);
							base64EncString        = new String(buf,"UTF-8");
							
							}catch(Exception e){
								base64EncString  = "";
							}
							return base64EncString;
					  }
					  
					   public static String decrypt04No(String encryptedText) throws Exception{
						   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
				 			
						   String base64DecString  = "";
//						  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
						  byte[] message          = encryptedText.getBytes("UTF-8");	//sepoa base64참조
					   
					      MessageDigest md        = MessageDigest.getInstance("MD5");
					      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
					      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
					  
						  try{
							  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
							  Cipher decipher     = Cipher.getInstance("DESede");
							  decipher.init(Cipher.DECRYPT_MODE, key);
							  
							  byte[] plainText    = decipher.doFinal(message);
							  base64DecString     = new String(plainText,"UTF-8");
							 
						  }catch(Exception e){
							  base64DecString  = "";
						  }
						      
						  return base64DecString;
					  }
				   
				   
				// Base64
					public static String encrypt05(String message) throws Exception{
						
						String base64EncString  = "";
						String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
						  
						 //MessageDigest md        = MessageDigest.getInstance("md5");
						 // byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
						 // byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
						 byte[] keyBytes           = secretKey.getBytes("utf-8");
						
						  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
						  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
						  cipher.init(Cipher.ENCRYPT_MODE, key);
						  
						  
							try{
							byte[] plainTextBytes  = message.getBytes("utf-8");
							byte[] buf             = cipher.doFinal(plainTextBytes);
							byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
							base64EncString        = new String(base64Bytes);
							}catch(Exception e){
								base64EncString  = "";
							}
							return base64EncString;
					  }
					  
			// Base64	   
				   public static String decrypt05(String encryptedText) throws Exception{
					   String base64DecString  = "";
					   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
							
						  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
//						  byte[] message          = encryptedText.getBytes("utf-8");	//sepoa base64참조
					   
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
							  base64DecString  = "";
						  }
						      
						  return base64DecString;
					  
					  }

				   
					public static String encrypt06(String message) throws Exception{

						  String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
						  String base64EncString  = "";
						  
						  MessageDigest md        = MessageDigest.getInstance("MD5");
						  byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
						  byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
						  
						  SecretKey key = new SecretKeySpec(keyBytes, "DESede");
						  Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
						  cipher.init(Cipher.ENCRYPT_MODE, key);
						  
						  
							try{
							byte[] plainTextBytes  = message.getBytes("utf-8");
							byte[] buf             = cipher.doFinal(plainTextBytes);
							byte[] base64Bytes     = Base64.base64Encode(buf);								//sepoa base64참조
							base64EncString        = new String(base64Bytes);
							}catch(Exception e){
								base64EncString  = "";
							}
							return base64EncString;
					  }
					  
					   public static String decrypt06(String encryptedText) throws Exception{
						   String secretKey = "l9pjOOQv72lLOnprDc5ppRL7";
				 			
						   String base64DecString  = "";
						  byte[] message          = Base64.base64Decode(encryptedText.getBytes("utf-8"));	//sepoa base64참조
					   
					      MessageDigest md        = MessageDigest.getInstance("MD5");
					      byte[] digestOfPassword = md.digest(secretKey.getBytes("utf-8"));
					      byte[] keyBytes         = Arrays.copyOf(digestOfPassword, 24);
					  
						  try{
							  SecretKey key       = new SecretKeySpec(keyBytes, "DESede");
							  Cipher decipher     =  Cipher.getInstance("DESede");
							  decipher.init(Cipher.DECRYPT_MODE, key);
							  
							  byte[] plainText    = decipher.doFinal(message);
							  base64DecString     = new String(plainText,"UTF-8");
							 
						  }catch(Exception e){
							  base64DecString  = "";
						  }
						      
						  return base64DecString;
					  }
}
