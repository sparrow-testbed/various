package com.tcComm2;


import java.io.*;
import java.util.*;

import com.tcLib2.pvUtil;

//import com.pvLib.pvUtil;


public class pvEnv
{
    private Vector<String> buff = new Vector<String>();

    public pvEnv(String fname) throws Exception
    {
        ReadFile(fname);
    }

    public static void LoadEnv()
    {
        try {
//            pvEnv env               = new pvEnv ("C:\\workspace\\wooriwms\\conf\\global.conf");
            pvEnv env                 = new pvEnv ("/app/wmsgw/conf/global.conf");
//            ONCNF.DRIVER          	= env.ReadString ("DRIVER");
//            ONCNF.CONNECTION      	= env.ReadString ("CONNECTION");
//            ONCNF.DBNAME          	= env.ReadString ("DBNAME");
//            ONCNF.DBID            	= env.ReadString ("DBID");
//            ONCNF.DBPWD           	= env.ReadString ("DBPWD");   
                        
            ONCNF.LOGDIR            = env.ReadString ("LOGDIR");
            
            ONCNF.THREAD_IN_COUNT   = env.ReadInt ("THREAD_IN_COUNT");
            ONCNF.THREAD_OUT_COUNT  = env.ReadInt ("THREAD_OUT_COUNT");
            ONCNF.SVR_OUT_PORT    	= env.ReadInt ("SVR_OUT_PORT");
            
            ONCNF.TCP_BANK_ADDRESS 	= env.ReadString("TCP_BANK_ADDRESS");
            ONCNF.TCP_BANK_PORT    	= env.ReadInt("TCP_BANK_PORT");
            
            ONCNF.TCP_BUFSIZE       = env.ReadInt("TCP_BUFSIZE");  
            ONCNF.BNK_LANG_CODE    	= env.ReadString("BNK_LANG_CODE");
            ONCNF.WMS_LANG_CODE    	= env.ReadString("WMS_LANG_CODE");

        }   catch (Exception e) {
            //e.printStackTrace();
        	pvUtil.msglog(ONCNF.LOGNAME," :LoadEnv: Exception : "+e.getMessage());
        }
    }

    private void ReadFile(String fname) throws Exception
    {
        BufferedReader in = null;
        String  str;
        try {
	        in = new BufferedReader (new FileReader(fname));
	
	        //System.out.println("WOORI wmGateway Config File Loading ...");
	        while ((str = in.readLine()) != null) {
	        	if(str.indexOf("=") < 0) {continue;}
	            buff.add(str);
	            //System.out.println(str);
	        }
        } catch (Exception e) {
        	str = "";
        }
        finally {        
        	if(in != null){ in.close(); }
        }
    }

    public String ReadString(String keyname) throws Exception
    {
        int     i = 0;
        String  val = null;

        for (i = 0 ; i < buff.size() ; i++) {
            String tmp = (String)buff.elementAt(i);
            if  (tmp.substring(0, keyname.length()).equals(keyname)) {
                val = tmp.substring((tmp.indexOf('=')+1));
                break;
            }
        }

        if  (val == null) {
            throw new Exception("0010"+ "00001"+ keyname + " Not Found"+ "");
        }

        return val.trim();
    }

    public int ReadInt   (String keyname) throws Exception
    {
        int     i = 0;
        String  val = null;

        for (i = 0 ; i < buff.size() ; i++) {
            String tmp = (String)buff.elementAt(i);

            if  (tmp.substring(0, keyname.length()).equals(keyname)) {
                val = tmp.substring((tmp.indexOf('=')+1));
                break;
            }
        }

        if  (val == null) {
            throw new Exception("0020"+"00001"+ keyname + " Not Found"+ "");
        }

        int v = 0;
        try {
            v = Integer.parseInt(val.trim());
        }   catch (Exception e) {
            throw new Exception("0030"+ ":00002"+ keyname + " Value not Numeric"+ "");
        }
        return v;
    }

    public boolean ReadBoolean (String keyname) throws Exception
    {
        int i = ReadInt(keyname);

        if  (i == 0) {
            return false;
        }
        else {
            return true;
        }
    }
}

