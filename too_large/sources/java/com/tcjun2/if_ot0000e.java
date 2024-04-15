/* TOBE 2017-07-01 온라인 오류 */

package com.tcJun2;

import com.tcLib2.*;
import com.tcJun2.*;


public class IF_OT0000E extends OUT_MSG {
	public String	 START_FLAG        = "";
	public String	 ERR_CODE          = ""; // 거래번호
	public String	 MESSAGE           = ""; // 오류프로그램
	public String	 MESSAGE2          = ""; // 오류식별자
	public String	 TRAN_GBN          = ""; // 오류코드
	public String	 END_FLAG          = "";
	
    public static String PGMID = "IF_OT0000E";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {

            "START_FLAG",     
        	"ERR_CODE",   
        	"MESSAGE",                  
        	"MESSAGE2", 
        	"TRAN_GBN",   
        	"END_FLAG",                   
    };
    private int[] iLen = {4,7,80,20,1,5};

    public IF_OT0000E()
    {
        iTLen = 117;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        START_FLAG    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
        ERR_CODE      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MESSAGE       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
        MESSAGE2      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
        TRAN_GBN      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        END_FLAG      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
		
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

		START_FLAG   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		ERR_CODE     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		MESSAGE      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		MESSAGE2     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		TRAN_GBN     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		END_FLAG     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       

    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        objToArry(buff, pos, START_FLAG 	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, ERR_CODE    	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, MESSAGE    	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, MESSAGE2      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRAN_GBN    	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, END_FLAG   	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   

    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, START_FLAG 	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, ERR_CODE   	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MESSAGE    	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, MESSAGE2   	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRAN_GBN   	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, END_FLAG   	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
    }
    
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + com.START_FLAG  = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],START_FLAG )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + com.ERR_CODE    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],ERR_CODE   )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + com.MESSAGE     = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],MESSAGE    )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + com.MESSAGE2    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],MESSAGE2   )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + com.TRAN_GBN    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TRAN_GBN   )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + com.END_FLAG    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],END_FLAG   )+"]");        
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }

 
}