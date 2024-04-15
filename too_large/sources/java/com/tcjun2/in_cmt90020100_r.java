/* TOBE 2017-07-01 책임자승인목록 수신 그리드 IN */

package com.tcJun2;

import com.tcLib2.*;

public class IN_CMT90020100_R extends MSG_0000 {
	
    public String    RLPE_EMNM          = "";   // S8   책임자행번	      
    public String    RLPE_FNM           = "";   // S30  책임자성명	      
    public String    RLPE_LVJP_NM       = "";   // S40  책임자직급명	    
    public String    RLPE_IPAD          = "";   // S39  책임자IP주소	    
    public String    RLPE_STS_INF       = "";   // S1   책임자상태정보	  
    public String    RLPE_TRM_NO        = "";   // S12  책임자단말번호	  
    public String    RLPE_BRCD          = "";   // S6   책임자점코드	    
    public String    RLPE_MTBR_DIS      = "";   // S1   책임자모점구분	  
    public String    TGT_MD_DIS         = "";   // S1   대상매체구분	    
    public String    RLPE_GDCD          = "";   // S2   책임자등급코드	  
    public String    RLPE_APV_SENU_2    = "";   // S1   책임자승인차수_2	
    public String    RLPE_GRP           = "";   // S1   책임자그룹	      
		
    public static String PGMID = "IN_CMT90020100_R";  
    public String sThread = "";
    public String logname = "";
   
    private String FieldNames[] = {
   
            "RLPE_EMNM",      
            "RLPE_FNM",       
            "RLPE_LVJP_NM",   
            "RLPE_IPAD",      
            "RLPE_STS_INF",   
            "RLPE_TRM_NO",    
            "RLPE_BRCD",      
            "RLPE_MTBR_DIS",  
            "TGT_MD_DIS",     
            "RLPE_GDCD",      
            "RLPE_APV_SENU_2",
            "RLPE_GRP",             	
    };
    private int[] iLen = {8,30,40,39,1,12,6,1,1,2,1,1,};
    
    public IN_CMT90020100_R()
    {
        iTLen = 142;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;
        
		RLPE_EMNM        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_FNM         = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_LVJP_NM     = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_IPAD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
		RLPE_STS_INF     = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_TRM_NO      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_BRCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_MTBR_DIS    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		TGT_MD_DIS       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_GDCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
		RLPE_APV_SENU_2  = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		RLPE_GRP         = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		  		
				
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

		RLPE_EMNM         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_FNM          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_LVJP_NM      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_IPAD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		RLPE_STS_INF      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_TRM_NO       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_BRCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_MTBR_DIS     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		TGT_MD_DIS        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_GDCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RLPE_APV_SENU_2   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_GRP          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        objToArry(buff, pos, RLPE_EMNM         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_FNM          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, RLPE_LVJP_NM      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, RLPE_IPAD         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_STS_INF      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, RLPE_TRM_NO       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_BRCD         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_MTBR_DIS     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, TGT_MD_DIS        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, RLPE_GDCD         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, RLPE_APV_SENU_2   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_GRP          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, RLPE_EMNM         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_FNM       	 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_LVJP_NM      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_IPAD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_STS_INF      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_TRM_NO       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_BRCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_MTBR_DIS     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TGT_MD_DIS        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_GDCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_SENU_2   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_GRP          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,int i,String msg) {
    	sThread = msg;
    	logname = name;
    	log(i);
    }
    public void log(int j) {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" "+j+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_EMNM        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_EMNM        )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_FNM         = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_FNM         )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_LVJP_NM     = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_LVJP_NM     )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_IPAD        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_IPAD        )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_STS_INF     = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_STS_INF     )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_TRM_NO      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_TRM_NO      )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_BRCD        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_BRCD        )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_MTBR_DIS    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_MTBR_DIS    )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + TGT_MD_DIS       = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],TGT_MD_DIS       )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_GDCD        = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_GDCD        )+"]" );  
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_APV_SENU_2  = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_APV_SENU_2  )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RLPE_GRP         = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],RLPE_GRP         )+"]" );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" +------------------------------------------");
    }
}