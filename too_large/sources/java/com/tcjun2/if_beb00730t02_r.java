/* TOBE 2017-07-01 경상비 지급결의 수신 */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IF_OT8602R
public class IF_BEB00730T02_R extends OUT_MSG {
	public String    DAT_KDCD              = "";   //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN               = "";   //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 TLM_DSCD              = ""; //1. S3   전문구분코드   
	public String	 TLM_UNQ_IDF_NO        = ""; //2. S16  전문고유식별번호 
	public String	 BGT_YY                = ""; //3. S4   예산년도     
	public String	 BGT_BRCD              = ""; //4. S6   예산점코드    
	public String	 PAY_DTMN_APV_NO       = ""; //5. N7   지급결의승인번호 
	
    public static String PGMID = "IF_BEB00730T02_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"TLM_DSCD", 
    		"TLM_UNQ_IDF_NO", 
    		"BGT_YY", 
    		"BGT_BRCD", 
    		"PAY_DTMN_APV_NO",     		
    };
    private int[] iLen = { 3,7,3,16,4,6,7, };

    public IF_BEB00730T02_R()
    {
        iTLen = 46;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		
		TLM_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		TLM_UNQ_IDF_NO      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		BGT_YY              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		BGT_BRCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		PAY_DTMN_APV_NO     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 			
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;   
        objToArry(buff, pos, DAT_KDCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        
        objToArry(buff, pos, TLM_DSCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, TLM_UNQ_IDF_NO      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_YY              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_BRCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PAY_DTMN_APV_NO     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
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
        
    	pvUtil.msglog(logname, sThread+PGMID+" + TLM_DSCD          = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TLM_DSCD         )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TLM_UNQ_IDF_NO    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TLM_UNQ_IDF_NO   )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BGT_YY            = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],BGT_YY           )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BGT_BRCD          = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],BGT_BRCD         )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PAY_DTMN_APV_NO   = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],PAY_DTMN_APV_NO  )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
  
}