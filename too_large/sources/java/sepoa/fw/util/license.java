package sepoa.fw.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class License
{
    public License()
    {
    }

    private static String toHex(byte[] buffer)
    {
        StringBuffer sb = new StringBuffer();
        String s = null;

        for (int i = 0; i < buffer.length; i++)
        {
            s = Integer.toHexString(buffer[i] & 0xff);

            if (s.length() < 2)
            {
                sb.append('0');
            }

            sb.append(s);
        }

        return sb.toString().toUpperCase();
    }

    private static byte[] toByte(String strHex)
    {
        String strTemp = strHex;
        byte[] bt = new byte[strHex.length() / 2];

        for (int i = 0; i < bt.length; i++)
        {
            String pi = strTemp.substring(0, 2);
            strTemp = strTemp.substring(2, strTemp.length());
            bt[i] = (byte) Integer.parseInt(pi, 16);
        }

        return bt;
    }

    public static boolean isEqual(String key, String val)
    {
    	boolean rtn = false;
    	
        try
        {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(val.getBytes());

            rtn = MessageDigest.isEqual(toByte(key), md.digest());
        }
        catch (IllegalStateException e)
        {
        	rtn = false;
        }
        catch (Exception e1)
        {
        	rtn = false;
        }

        return rtn;
    }

    public static String getLicenseValue(String val)
    {
    	String rtn = "";
        try
        {
            byte[] now = val.getBytes();
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(now);

            rtn = toHex(md.digest());
        }
        catch (IllegalStateException e)
        {
        	rtn = "";
        }
        catch (NoSuchAlgorithmException e)
        {
        	rtn = "";
        }

        return rtn;
    }

//    public static void main(String[] args)
//    {
//        if (args.length != 1)
//        {
//            
//
//            return;
//        }
//        else
//        {
//            
//            
//
//            return;
//        }
//    }
}
