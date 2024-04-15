/* TOBE 2017-07-01 온라인 MSG */

package com.tcJun2;

import sepoa.fw.log.Logger;

import com.tcLib2.*;
import com.tcComm2.*;

public class MSG_0000
{
    public  static String    PGMID = "MSG_0000";
    public String sThread = "";
    public String logname = "";
    public  int       iTLen = 0;
    //TO-BE 2017-07-01 추가 iTlen2
    public  int       iTlen2 = 0;
    public  int       iOrgLen = 0;
    public  int       iBioLen = 0;

    public MSG_0000()
    {
    }
    protected String getStr(byte[] buff, int pos, int len, String FieldName) throws pvException
    {
        String s="";
        try {
            s = new String(buff, pos, len);
        }   catch (Exception e) {
            s = "";
            //pvUtil.msglog(ONCNF.LOGNAME, "getStr() : " + FieldName + "|" + new String(buff, pos, len) + "|");
        }
        return s.trim();
    }
    // euc-kr, utf-8 ...
    protected String getStr(byte[] buff, int pos, int len, String FieldName, String code) throws pvException
    {
        String s="";
        //pvUtil.msglog(ONCNF.LOGNAME, "getStr(1) : " + FieldName + "|" + new String(buff, pos, len) + "|");
        try {
            s = new String(buff, pos, len, code);
        }   catch (Exception e) {
            s = "";
          //pvUtil.msglog(ONCNF.LOGNAME, "getStr() : " + FieldName + "|" + new String(buff, pos, len) + "|");
        }
        return s.trim();
    }
    protected void objToArry(byte[] buff, int pos, String src, int len, String FieldName) throws pvException
    {
        try {
            if  ( (src == null) || (src.length() == 0)) {
                fillChar(buff, pos, ' ', len);
                return;
            }
            int size = (src.getBytes()).length;
            System.arraycopy(src.getBytes(), 0, buff, pos, size);
            fillChar(buff, pos+size, ' ', len-size);
        }   catch (Exception e) {
            //e.printStackTrace();
            throw new pvException(PGMID, "0060", "objToArry(): " + FieldName , e.getMessage());
        }
    }
    // euc-kr, UTF-8 ...
    protected void objToArry(byte[] buff, int pos, String src, int len, String FieldName, String code) throws pvException
    {
    	int size = 0;
        try {
            if  ( (src == null) || (src.length() == 0)) {
                fillChar(buff, pos, ' ', len);
                return;
            }
            size = (src.getBytes(code)).length;
            System.arraycopy(src.getBytes(code), 0, buff, pos, size);
            fillChar(buff, pos+size, ' ', len-size);
        }   catch (Exception e) {
            //e.printStackTrace();
            throw new pvException(PGMID, "0070", "objToArry():" + FieldName+": code="+code + ": size = "+size+ ": src=" +src, e.getMessage());
        }
    }
    protected void fillChar(byte[] buff, int pos, char ch, int size)
    {
        for (int i=0;i<size;i++) {
            buff[pos+i] = (byte)ch;
        }
    }
}
