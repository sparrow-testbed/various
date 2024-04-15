/* TOBE 2017-07-01 경상비 세금계산서 조회 수신 그리드 IN */

package com.tcJun2;

import com.tcLib2.*;

//AS-IS : IN_OT8601R
public class IN_BEB00730T01_R extends MSG_0000 {
	public String	 INQ_NO                  = "";   //1.  N5      조회번호          
	public String	 NTS_BILL_APV_NO         = "";   //2.  S24     국세청계산서승인번호    
	public String	 BGT_BRCD                = "";   //3.  S6      예산점코드         
	public String    EVDCD_ISSU_DT  		 = "";	 //4.  S8      증빙서발행일자       
	public String	 TXBIL_RGS_DT            = "";   //5.  S8      (세금)계산서등록일자     
	public String	 TXBIL_RGS_SRNO          = "";   //6.  N5      (세금)계산서등록일련번호   
	public String	 BGT_EXU_AM              = "";   //7.  D15     예산집행금액        
	public String	 SPL_AM                  = "";   //8.  D15     공급금액          
	public String	 EVDCD_TAXM              = "";   //9.  D15     증빙서세액         
	public String	 EVDCD_DAT_DSCD          = "";   //10. S1      증빙서데이터구분코드    
	public String	 XPN_PAY_RSN_TXT         = "";   //11. S100    지경비지급사유내용      
		
    public static String PGMID = "IN_BEB00730T01_R";  
    public String sThread = "";
    public String logname = "";
   
    private String FieldNames[] = {
   
    		"INQ_NO",        
    		"NTS_BILL_APV_NO",        
    		"BGT_BRCD",        
    		"EVDCD_ISSU_DT",        
    		"TXBIL_RGS_DT",        
    		"TXBIL_RGS_SRNO",        
    		"BGT_EXU_AM",        
    		"SPL_AM",        
    		"EVDCD_TAXM",        
    		"EVDCD_DAT_DSCD",        
    		"XPN_PAY_RSN_TXT",            	
    };
    private int[] iLen = {5,24,6,8,8,5,15,15,15,1,100,};
    
    public IN_BEB00730T01_R()
    {
        iTLen = 202;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;
        
		INQ_NO            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		NTS_BILL_APV_NO   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		BGT_BRCD          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		EVDCD_ISSU_DT     = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
		TXBIL_RGS_DT      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		TXBIL_RGS_SRNO    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		BGT_EXU_AM        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		SPL_AM            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		EVDCD_TAXM        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		EVDCD_DAT_DSCD    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
		XPN_PAY_RSN_TXT   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;  
		  		
				
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

		INQ_NO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		NTS_BILL_APV_NO     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		BGT_BRCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		EVDCD_ISSU_DT       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		TXBIL_RGS_DT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		TXBIL_RGS_SRNO      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		BGT_EXU_AM          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		SPL_AM              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		EVDCD_TAXM          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		EVDCD_DAT_DSCD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		XPN_PAY_RSN_TXT     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        objToArry(buff, pos, INQ_NO             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, NTS_BILL_APV_NO    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, BGT_BRCD           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, EVDCD_ISSU_DT      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TXBIL_RGS_DT       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TXBIL_RGS_SRNO     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;   
        objToArry(buff, pos, BGT_EXU_AM         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SPL_AM             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, EVDCD_TAXM         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, EVDCD_DAT_DSCD     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, XPN_PAY_RSN_TXT    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, INQ_NO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, NTS_BILL_APV_NO 	 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_BRCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EVDCD_ISSU_DT      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TXBIL_RGS_DT       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TXBIL_RGS_SRNO     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_EXU_AM         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPL_AM             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EVDCD_TAXM         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EVDCD_DAT_DSCD     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, XPN_PAY_RSN_TXT    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,int i,String msg) {
    	sThread = msg;
    	logname = name;
    	log(i);
    }
    public void log(int j) {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" "+j+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + INQ_SRNO    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],INQ_NO           )+"]"    );    
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + TAA_APV_NO  = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],NTS_BILL_APV_NO  )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RGS_BRCD    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],BGT_BRCD         )+"]"    );     
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + ISU_DT      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_ISSU_DT    )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RGS_DT      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],TXBIL_RGS_DT     )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RGS_SRNO    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],TXBIL_RGS_SRNO   )+"]"    );     
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + EXE_AM      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],BGT_EXU_AM       )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + SPL_AM      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],SPL_AM           )+"]"    );     
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + TAX_AM      = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_TAXM       )+"]"    );     
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + RGS_DSCD    = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],EVDCD_DAT_DSCD   )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" + PAY_RSN     = ("+pvUtil.getNum(iLen[i],3)+")["+pvUtil.getFormat(iLen[i++],XPN_PAY_RSN_TXT  )+"]"    );
        pvUtil.msglog(logname, sThread+PGMID+" "+j+" +------------------------------------------");
    }
}