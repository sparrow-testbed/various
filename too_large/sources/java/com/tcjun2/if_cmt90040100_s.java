/* TOBE 2017-07-01 책임자 지문 송신 */

package com.tcJun2;

import com.tcLib2.*;


//AS-IS : IF_OT8602S
public class IF_CMT90040100_S extends OUT_MSG {
	
	public String    DAT_KDCD               = ""; //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN                = ""; //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 CRTF_DSCD              = ""; //1.   S1         인증구분코드                
	public String	 RLPE_ENO   	        = ""; //2.   S8         책임자직원번호          
	public String	 SHA256_RLPE_APV_PWNO   = ""; //3.   S64      SHA256책임자승인비밀번호              
	public String	 RLPE_GDCD              = ""; //4.   S2         책임자등급코드          
	public String	 MSG_CD                 = ""; //5.   S10        메시지코드       
	public String	 FPCTF_ENCY_DAT_TXT     = ""; //6.   S1344      지문인증암호화데이터내용           
	public String	 SPR                    = ""; //7.   S100       예비             
	
    public static String PGMID = "IF_BEB00730T02_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"DAT_KDCD",
    		"DAT_LEN",    		            
    		"CRTF_DSCD",           
    		"RLPE_ENO",   	       
    		"SHA256_RLPE_APV_PWNO",   
    		"RLPE_GDCD",           
    		"MSG_CD",              
    		"FPCTF_ENCY_DAT_TXT",    
    		"SPR",                 
    		         
    };
    
    private int[] iLen = { 3,7,1,8,64,2,10,1344,100,};

    public IF_CMT90040100_S()
    {
        iTLen = 1539;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;        
        CRTF_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_ENO         	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        SHA256_RLPE_APV_PWNO = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_GDCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		MSG_CD               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		FPCTF_ENCY_DAT_TXT   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		SPR                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
				     	
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;          
        objToArry(buff, pos, CRTF_DSCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_ENO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SHA256_RLPE_APV_PWNO ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_GDCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, MSG_CD               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FPCTF_ENCY_DAT_TXT   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
         
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
    	pvUtil.msglog(logname, sThread+PGMID+" + CRTF_DSCD                          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CRTF_DSCD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_ENO   	                    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_ENO   	       )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + SHA256_RLPE_APV_PWNO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SHA256_RLPE_APV_PWNO  )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_GDCD                          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_GDCD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + MSG_CD                             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MSG_CD                )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + FPCTF_ENCY_DAT_TXT                 = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FPCTF_ENCY_DAT_TXT    )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + SPR                                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPR                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}