package wise.util;
import sun.misc.*;
import java.io.*;

/**
* * Filename  : Base64Util.java
* Class     : Base64Util    
* Function  : Base64 Encoding/Decoding을 수행하는 클래스 
* Comment   : 
* History	: 2000-08-16 2:48오후                 	
* 
* @version  1.0
* @author carouser
*/
public class Base64Util {
	
    public Base64Util() {}

    /**
     *	Base64Encoding을 수행한다. binany in ascii out
     *
     *	@param encodeBytes encoding할 byte array
     *	@return encoding 된 String
     */
    public static String encode(byte[] encodeBytes) {
        
        BASE64Encoder base64Encoder = new BASE64Encoder();
        ByteArrayInputStream bin = new ByteArrayInputStream(encodeBytes);
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        byte[] buf = null;
        int rtn = 0;
        try{
            base64Encoder.encodeBuffer(bin, bout);
        } catch(Exception e) { rtn = -1;
//            System.out.println("Exception");
//            e.printStackTrace();
        }
        buf = bout.toByteArray();
        return new String(buf).trim();
    }

    /**
     *	Base64Decoding 수행한다. binany out ascii in
     *
     *	@param strDecode decoding할 String
     *	@return decoding 된 byte array
     */
    public static byte[] decode(String strDecode) {
        
        BASE64Decoder base64Decoder = new BASE64Decoder();
        ByteArrayInputStream bin = new ByteArrayInputStream(strDecode.getBytes());
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        byte[] buf = null;
        int rtn = 0;
        try {		
            base64Decoder.decodeBuffer(bin, bout);
        } catch(Exception e) { rtn = -1;
//            System.out.println("Exception");
//            e.printStackTrace();
        }

        buf = bout.toByteArray();

        return buf;

    }
}

