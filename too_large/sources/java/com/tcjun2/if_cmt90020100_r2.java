/* TOBE 2017-07-01 책임자 승인 목록 승인사유 그리드 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT8602R
public class IF_CMT90020100_R2 extends OUT_MSG {
	public String    GRID_ROW_CNT_2     = "";   // N2   그리드열건수_2	  
    public String    APV_RNCD           = "";   // S10  승인사유코드	    
    public String    APV_RNCD_TXT       = "";   // S100 승인사유코드내용	
    public String    ATNT_MSG           = "";   // S100 주의메시지	      
    public String    ADI_INF_DIS        = "";   // S1   부가정보구분	    
    public String    ADI_INF            = "";   // S70  부가정보	        


	
    public static String PGMID = "IF_CMT90040100_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"GRID_ROW_CNT_2",  
    		"APV_RNCD",  
    		"APV_RNCD_TXT", 
    		"ATNT_MSG", 
    		"ADI_INF_DIS",
    		"ADI_INF",
    		
    };
    private int[] iLen = { 2,10,100,100,1,70,};

    public IF_CMT90020100_R2()
    {
        iTLen = 283;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        GRID_ROW_CNT_2       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        APV_RNCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;		
        APV_RNCD_TXT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ATNT_MSG             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
        ADI_INF_DIS          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ADI_INF              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;   
        objToArry(buff, pos, GRID_ROW_CNT_2       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, APV_RNCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;         
        objToArry(buff, pos, APV_RNCD_TXT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, ATNT_MSG             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ADI_INF_DIS          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, ADI_INF              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
                
    }
    
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + GRID_ROW_CNT_2     = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],GRID_ROW_CNT_2    )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + APV_RNCD           = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],APV_RNCD          )+"]");        
    	pvUtil.msglog(logname, sThread+PGMID+" + APV_RNCD_TXT       = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],APV_RNCD_TXT      )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ATNT_MSG           = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],ATNT_MSG          )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ADI_INF_DIS        = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],ADI_INF_DIS       )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ADI_INF            = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],ADI_INF           )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
  
}