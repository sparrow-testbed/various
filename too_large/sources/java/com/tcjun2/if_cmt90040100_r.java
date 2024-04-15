/* TOBE 2017-07-01 책임자 지문 수신 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT8602R
public class IF_CMT90040100_R extends OUT_MSG {
	public String    DAT_KDCD              = "";   //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN               = "";   //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 RAS_CD                = ""; //1. S8    송수신코드   
	public String	 RST_TXT               = ""; //2. S234 결과내용 
	
    public static String PGMID = "IF_CMT90040100_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"RAS_CD", 
    		"RST_TXT",     		
    };
    private int[] iLen = { 3,7,8,234,};

    public IF_CMT90040100_R()
    {
        iTLen = 252;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;		
        RAS_CD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RST_TXT             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;   
        objToArry(buff, pos, DAT_KDCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;         
        objToArry(buff, pos, RAS_CD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RST_TXT             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
                
    }
    
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD          = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_KDCD         )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN           = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_LEN          )+"]");        
    	pvUtil.msglog(logname, sThread+PGMID+" + RAS_CD            = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],RAS_CD           )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RST_TXT           = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],RST_TXT          )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
  
}