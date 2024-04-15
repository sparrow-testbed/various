/* TOBE 2017-07-01 재무회계 일계처리 수신 */

package com.tcJun2;

import com.tcLib2.*;

public class IF_JTA45010200_R extends OUT_MSG {
    public String  DAT_KDCD             = ""; //데이타헤더부 : (문자3)  데이터종류코드        
    public String  DAT_LEN              = ""; //데이타헤더부 : (숫자7)  데이터길이    
	public String SLIP_TRN_DT	     = "";    //전표거래일자		     8   
	public String SLIP_NO	         = "";    //전표번호		         16
	public String SLIP_RGS_SRNO	   = "";    //전표등록일련번호	   3 
	public String TRN_LOG_SRNO	   = "";    //거래로그일련번호	   56
	public String REPT_UD_CST_CNT	 = "";    //반복부조립건수		   3 
	public String FX_TRN_LOSS_AM	 = "";    //외환거래손실금액		 18
	public String FX_TRN_PFT_AM	   = "";    //외환거래이익금액		 18
  
    public static String PGMID = "IF_ICAA9010200_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
    		        "DAT_KDCD",
    		        "DAT_LEN",
    		        "SLIP_TRN_DT",     //전표거래일자		     8       
    	            "SLIP_NO",         //전표번호		         16 
    	            "SLIP_RGS_SRNO",   //전표등록일련번호	   3  
    	            "TRN_LOG_SRNO",    //거래로그일련번호	   56 
    	            "REPT_UD_CST_CNT", //반복부조립건수		   3  
    	            "FX_TRN_LOSS_AM",  //외환거래손실금액		 18 
    	            "FX_TRN_PFT_AM"   //외환거래이익금액		 18 
    };
    
    private int[] iLen = { 3,7,8,16,3,56,3,18,18};

    public IF_JTA45010200_R()
    {
        iTLen = 726;
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD	     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;        
        DAT_LEN	     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;                
        SLIP_TRN_DT	     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SLIP_NO	         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SLIP_RGS_SRNO	   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_LOG_SRNO	   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        REPT_UD_CST_CNT	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FX_TRN_LOSS_AM	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FX_TRN_PFT_AM	   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;

        objToArry(buff, pos, DAT_KDCD	       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN	       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, SLIP_TRN_DT	   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SLIP_NO	       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, SLIP_RGS_SRNO	   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_LOG_SRNO	   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, REPT_UD_CST_CNT   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FX_TRN_LOSS_AM    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FX_TRN_PFT_AM	   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,String msg) {
        sThread = msg;
        logname = name;
        log();
    }
    public void log() {
        int i=0;
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD	    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD	         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN	    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN	         ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_TRN_DT	    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_TRN_DT	         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_NO	        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_NO	             ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_RGS_SRNO	  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_RGS_SRNO	       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_LOG_SRNO	    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_LOG_SRNO	         ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + REPT_UD_CST_CNT	= ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],REPT_UD_CST_CNT	     ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + FX_TRN_LOSS_AM	  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FX_TRN_LOSS_AM	       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + FX_TRN_PFT_AM	  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FX_TRN_PFT_AM	       ) +"]");

        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
}
