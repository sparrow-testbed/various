/* TOBE 2017-07-01 경상비 경비집행 수신 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT8603R
public class IF_BEB00730T03_R extends OUT_MSG {
	public String    DAT_KDCD               = ""; //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN                = ""; //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 TLM_DSCD               = ""; //1. S3    전문구분코드     
	public String	 TLM_UNQ_IDF_NO         = ""; //2. S16   전문고유식별번호
	public String	 SLIP_NO                = ""; //3. S16   전표번호         
	
    public static String PGMID = "IF_BEB00730T03_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
        
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"TLM_DSCD",      
    		"TLM_UNQ_IDF_NO",      
    		"SLIP_NO",              	                    	 
    };
    private int[] iLen = { 3,7,3,16,16,};

    public IF_BEB00730T03_R()
    {
        iTLen = 45;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
       
        DAT_KDCD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
        DAT_LEN            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		
		TLM_DSCD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		TLM_UNQ_IDF_NO     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		SLIP_NO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;   
        objToArry(buff, pos, DAT_KDCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        
        objToArry(buff, pos, TLM_DSCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_UNQ_IDF_NO     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SLIP_NO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
           
    }
    
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD         = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_KDCD        )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN          = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_LEN         )+"]");
        
    	pvUtil.msglog(logname, sThread+PGMID+" + TLM_DSCD         = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TLM_DSCD        )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TLM_UNQ_IDF_NO   = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TLM_UNQ_IDF_NO  )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_NO          = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],SLIP_NO         )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" +-----------------------------");
    }
    
}