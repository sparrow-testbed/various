/* TOBE 2017-07-01 경상비 지급결의 송신 */

package com.tcJun2;

import com.tcLib2.*;


//AS-IS : IF_OT8602S
public class IF_BEB00730T02_S extends OUT_MSG {
	
	public String    DAT_KDCD               = ""; //데이타헤더부 : (문자3)  데이터종류코드	       
	public String    DAT_LEN                = ""; //데이타헤더부 : (숫자7)  데이터길이	   
	public String	 TLM_DSCD               = ""; //1.   S3         전문구분코드                
	public String	 TLM_UNQ_IDF_NO   	    = ""; //2.   S16        전문고유식별번호            
	public String	 BGT_YY                 = ""; //3.   S4         예산년도                    
	public String	 BGT_BRCD               = ""; //4.   S6         예산점코드                  
	public String	 PAY_DTMN_DT            = ""; //5.   S8         지급결의일자                
	public String	 BGT_XPN_CD             = ""; //6.   S6         예산경비코드                
	public String	 BGT_ITTX_CD            = ""; //7.   S6         예산세목코드                
	public String	 BGT_BZN_CD             = ""; //8.   S3         예산사업코드                
	public String	 BGT_DTMN_DSCD          = ""; //9.   S1         예산결의구분코드            
	public String	 CSHTF_DSCD             = ""; //10.  S1         현금대체구분코드            
	public String	 EXU_AM                 = ""; //11.  D15        집행금액                    
	public String	 EXPD_EVDC_DSCD         = ""; //12.  S2         지출증빙구분코드            
	public String	 XPN_PAY_RSN_TXT        = ""; //13.  S100       경비지급사유내용            
	public String	 ELT_TXBIL_PTPY_YN      = ""; //14.  S1         전자세금계산서분할지급여부  
	public String	 XPN_BGT_DTLS_CD        = ""; //15.  S10        경비예산세부코드            
	public String	 EXU_TGT_PLC_CD         = ""; //16.  S7         집행대상장소코드            
	public String	 GRID_ROW_CNT           = ""; //17.  N5         그리드열건수                
	public String	 BGT_PAY_DTMN_SRNO      = ""; //18.  N3         예산지급결의일련번호        
	public String	 SPL_AM                 = ""; //19.  D15        공급금액                    
	public String	 VAT                    = ""; //20.  D15        부가세                      
	public String	 RCV_BKCD               = ""; //21.  S3         입금은행코드                
	public String	 RCV_BKW_ACNO           = ""; //22.  S20        입금전행계좌번호            
	public String	 EVDCD_ISSU_DT          = ""; //23.  S8         증빙서발행일자              
	public String	 PYCO_BZNO              = ""; //24.  S10        지급처사업자등록번호        
	public String	 XPN_PYCO_NM            = ""; //25.  S100       경비지급처명                
	public String	 RPTNL_BZNO             = ""; //26.  S10        접대처사업자등록번호        
	public String	 RPTNL_NM               = ""; //27.  S40        접대처명                    
	public String	 RPTN_RSN_TXT           = ""; //28.  S100       접대사유내용                
	public String	 ALL_RCVDP_TXT          = ""; //29.  S4000      전체접대받는자내용          
	public String	 RCVDP_CPE_CN           = ""; //30.  N6         접대받는자인원수            
	public String	 ALL_RCPPE_TXT          = ""; //31.  S4000      전체접대자내용              
	public String	 RCPPE_CPE_CN           = ""; //32.  N6         접대자인원수                
	public String	 TXBIL_RGS_DT           = ""; //33.  S8         세금계산서등록일자          
	public String	 TXBIL_RGS_SRNO         = ""; //34.  N5         세금계산서등록일련번호      	

    public static String PGMID = "IF_BEB00730T02_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
  
    		"DAT_KDCD",
    		"DAT_LEN",    		
    		"TLM_DSCD", 
    		"TLM_UNQ_IDF_NO", 
    		"BGT_YY", 
    		"BGT_BRCD", 
    		"PAY_DTMN_DT", 
    		"BGT_XPN_CD", 
    		"BGT_ITTX_CD", 
    		"BGT_BZN_CD", 
    		"BGT_DTMN_DSCD", 
    		"CSHTF_DSCD", 
    		"EXU_AM", 
    		"EXPD_EVDC_DSCD", 
    		"XPN_PAY_RSN_TXT", 
    		"ELT_TXBIL_PTPY_YN", 
    		"XPN_BGT_DTLS_CD", 
    		"EXU_TGT_PLC_CD", 
    		"GRID_ROW_CNT", 
    		"BGT_PAY_DTMN_SRNO", 
    		"SPL_AM", 
    		"VAT", 
    		"RCV_BKCD", 
    		"RCV_BKW_ACNO", 
    		"EVDCD_ISSU_DT", 
    		"PYCO_BZNO", 
    		"XPN_PYCO_NM", 
    		"RPTNL_BZNO", 
    		"RPTNL_NM", 
    		"RPTN_RSN_TXT", 
    		"ALL_RCVDP_TXT", 
    		"RCVDP_CPE_CN", 
    		"ALL_RCPPE_TXT", 
    		"RCPPE_CPE_CN", 
    		"TXBIL_RGS_DT", 
    		"TXBIL_RGS_SRNO",
    		         
    };
    
    private int[] iLen = { 3,7,3,16,4,6,8,6,6,3,1,1,15,2,100,1,10,7,5,3,15,15,3,20,8,10,100,10,40,100,4000,6,4000,6,8,5,};

    public IF_BEB00730T02_S()
    {
        iTLen = 8553;
    }
    
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        TLM_DSCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_UNQ_IDF_NO   	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        BGT_YY               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		BGT_BRCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		PAY_DTMN_DT          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		BGT_XPN_CD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		BGT_ITTX_CD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		BGT_BZN_CD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		BGT_DTMN_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		CSHTF_DSCD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		EXU_AM               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		EXPD_EVDC_DSCD       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		XPN_PAY_RSN_TXT      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		ELT_TXBIL_PTPY_YN    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		XPN_BGT_DTLS_CD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		EXU_TGT_PLC_CD       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		GRID_ROW_CNT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		BGT_PAY_DTMN_SRNO    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		SPL_AM               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		VAT                	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		RCV_BKCD           	 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
		RCV_BKW_ACNO         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		EVDCD_ISSU_DT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		PYCO_BZNO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		XPN_PYCO_NM          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RPTNL_BZNO           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		RPTNL_NM             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		RPTN_RSN_TXT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		ALL_RCVDP_TXT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RCVDP_CPE_CN         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		ALL_RCPPE_TXT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
		RCPPE_CPE_CN         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		TXBIL_RGS_DT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
		TXBIL_RGS_SRNO       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
		     	
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, DAT_LEN              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        
        objToArry(buff, pos, TLM_DSCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, TLM_UNQ_IDF_NO   	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_YY               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_BRCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, PAY_DTMN_DT          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_XPN_CD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_ITTX_CD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_BZN_CD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_DTMN_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CSHTF_DSCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, EXU_AM               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EXPD_EVDC_DSCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, XPN_PAY_RSN_TXT      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ELT_TXBIL_PTPY_YN    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, XPN_BGT_DTLS_CD      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EXU_TGT_PLC_CD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, GRID_ROW_CNT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BGT_PAY_DTMN_SRNO    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPL_AM               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, VAT                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RCV_BKCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RCV_BKW_ACNO      	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EVDCD_ISSU_DT     	  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PYCO_BZNO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, XPN_PYCO_NM          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RPTNL_BZNO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RPTNL_NM             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RPTN_RSN_TXT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ALL_RCVDP_TXT        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RCVDP_CPE_CN         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ALL_RCPPE_TXT        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RCPPE_CPE_CN         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, TXBIL_RGS_DT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TXBIL_RGS_SRNO       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        
    }
    
    public void log(String name,String msg) {
    	sThread = msg+ " ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN                            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN                    )+"]");
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + TLM_DSCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TLM_DSCD                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + TLM_UNQ_IDF_NO   	                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TLM_UNQ_IDF_NO   	         )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_YY                             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_YY                     )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_BRCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_BRCD                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + PAY_DTMN_DT                        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PAY_DTMN_DT                )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_XPN_CD                         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_XPN_CD                 )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_ITTX_CD                        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_ITTX_CD                )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_BZN_CD                         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_BZN_CD                 )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_DTMN_DSCD                      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_DTMN_DSCD              )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + CSHTF_DSCD                         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CSHTF_DSCD                 )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + EXU_AM                             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],EXU_AM                     )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + EXPD_EVDC_DSCD                     = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],EXPD_EVDC_DSCD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + XPN_PAY_RSN_TXT                    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],XPN_PAY_RSN_TXT            )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + ELT_TXBIL_PTPY_YN                  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ELT_TXBIL_PTPY_YN          )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + XPN_BGT_DTLS_CD                    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],XPN_BGT_DTLS_CD            )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + EXU_TGT_PLC_CD                     = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],EXU_TGT_PLC_CD             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + GRID_ROW_CNT                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],GRID_ROW_CNT               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_PAY_DTMN_SRNO                  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGT_PAY_DTMN_SRNO          )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + SPL_AM                             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPL_AM                     )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + VAT                                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],VAT                        )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RCV_BKCD                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RCV_BKCD                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RCV_BKW_ACNO                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RCV_BKW_ACNO               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + EVDCD_ISSU_DT                      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],EVDCD_ISSU_DT              )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + PYCO_BZNO                          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PYCO_BZNO                  )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + XPN_PYCO_NM                        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],XPN_PYCO_NM                )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RPTNL_BZNO                         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RPTNL_BZNO                 )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RPTNL_NM                           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RPTNL_NM                   )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RPTN_RSN_TXT                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RPTN_RSN_TXT               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + ALL_RCVDP_TXT                      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ALL_RCVDP_TXT              )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RCVDP_CPE_CN                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RCVDP_CPE_CN               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + ALL_RCPPE_TXT                      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ALL_RCPPE_TXT              )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + RCPPE_CPE_CN                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RCPPE_CPE_CN               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + TXBIL_RGS_DT                       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TXBIL_RGS_DT               )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" + TXBIL_RGS_SRNO                     = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TXBIL_RGS_SRNO             )+"]");
    	pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}