/* TOBE 2017-07-01 경상비 세금계산서 조회 수신 */

package com.tcJun2;

import com.tcLib2.*;


//AS-IS : IF_OT8601R
public class IF_BEB00730T01_R extends OUT_MSG {
	public  String   DAT_KDCD                 = "";  //데이타헤더부 : (문자3)  데이터종류코드	       
	public  String   DAT_LEN                  = "";  //데이타헤더부 : (숫자7)  데이터길이	   
	public  String	 TLM_DSCD                 = "";  //1. S3   전문구분코드     
	public  String   NXT_PAGE_EXST_YN         = "";  //2. S1   다음페이지존재여부  
	public  String	 GRID_ROW_CNT             = "";  //3. N6   그리드열건수     
	
    public static String PGMID = "IF_BEB00730T01_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"TLM_DSCD",     
    		"NXT_PAGE_EXST_YN",     
    		"GRID_ROW_CNT",                   
    };
    private int[] iLen = {3,7,3,1,6,};
    
    public IF_BEB00730T01_R()
    {
        iTLen = 20;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        DAT_KDCD              = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DAT_LEN               = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        
        TLM_DSCD              = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        NXT_PAGE_EXST_YN      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
        GRID_ROW_CNT          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;   
		
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
      
        DAT_KDCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		
		TLM_DSCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		NXT_PAGE_EXST_YN     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		GRID_ROW_CNT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       

    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;  
        
        objToArry(buff, pos, DAT_KDCD              	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN               	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        
        objToArry(buff, pos, TLM_DSCD              	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, NXT_PAGE_EXST_YN    	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, GRID_ROW_CNT       	,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;

    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;  
        objToArry(buff, pos, DAT_KDCD           	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN            	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        
        objToArry(buff, pos, TLM_DSCD           	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, NXT_PAGE_EXST_YN   	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, GRID_ROW_CNT       	,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD            = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_KDCD           )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN             = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],DAT_LEN            )+"]");
        
    	pvUtil.msglog(logname, sThread+PGMID+" + TLM_DSCD            = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],TLM_DSCD           )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + NXT_PAGE_EXST_YN    = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],NXT_PAGE_EXST_YN   )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" + GRID_ROW_CNT        = ("+pvUtil.getNum(iLen[i], 3)+")["+pvUtil.getFormat(iLen[i++],GRID_ROW_CNT       )+"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
 
}