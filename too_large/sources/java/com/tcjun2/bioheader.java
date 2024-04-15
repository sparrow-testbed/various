/* TOBE 2017-07-01 바이오(지문) 헤더 */

package com.tcJun2;

import com.tcLib2.*;

public class bioHeader extends MSG_0000 {

    public String    IBIO             	     =  "";                      //(669) BIO 지문 정보

    
    private static String PGMID = "bioHeader";
    public String sThread   = "";
    public  String  logname  = "";
    
    private String FieldNames[] = {
            "IBIO",
    };
    private int[] iLen =   {669,};

    public bioHeader()
    {
        iTLen = 669;
        
    }

    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        IBIO             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
      
    }
    // code: euc-kr, utf-8 ...
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        IBIO             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, IBIO                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
    }
    
    // code: euc-kr, utf-8 ...
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, IBIO                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    public void log() {
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + biz.IBIO                = "+IBIO                   );
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");

    
    
    
    
    }
    public void print(String msg) {
    	sThread = msg;
    	log();
    }    
    public void print() {
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + biz.IBIO                  = "+IBIO                );
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
}