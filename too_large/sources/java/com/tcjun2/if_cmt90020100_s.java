/* TOBE 2017-07-01 책임자 승인 목록 송신 */

package com.tcJun2;

import com.tcLib2.*;

public class IF_CMT90020100_S extends OUT_MSG {
	
	public String    DAT_KDCD               = ""; //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN                = ""; //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 RLPE_APV_DSCD          = ""; //1.   S1         책임자승인구분코드                
	public String	 APV_AVL_RLPE_CN   	    = ""; //2.   S2         승인가능책임자수          
	public String	 GRID_ROW_CNT           = ""; //3.   S2         그리드열건수              
	public String	 APV_RNCD               = ""; //4.   S10        승인사유코드       
	
    public static String PGMID = "IF_CMT90020100_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"DAT_KDCD",
    		"DAT_LEN",    		            
    		"RLPE_APV_DSCD",           
    		"APV_AVL_RLPE_CN",   	       
    		"GRID_ROW_CNT",   
    		"APV_RNCD",           
    };
    
    private int[] iLen = { 3,7,1,2,2,10,};

    public IF_CMT90020100_S()
    {
        iTLen = 25;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;        
        RLPE_APV_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        APV_AVL_RLPE_CN      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        GRID_ROW_CNT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		APV_RNCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
				     	
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;          
        objToArry(buff, pos, RLPE_APV_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, APV_AVL_RLPE_CN      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, GRID_ROW_CNT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, APV_RNCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
         
    }
    
    public void log(String name,String msg) {
    	sThread = msg+ " ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD              )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN                            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN               )+"]");   	
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_APV_DSCD                      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_APV_DSCD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + APV_AVL_RLPE_CN   	                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],APV_AVL_RLPE_CN   	       )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + GRID_ROW_CNT                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],GRID_ROW_CNT  )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + APV_RNCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],APV_RNCD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}