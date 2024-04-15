/* TOBE 2017-07-01 거래헤더 */

package com.tcJun2;

import com.tcLib2.*;
import com.tcComm2.*;

public class trnHeader extends MSG_0000 {
	
	public String    TRM_BRNO                    	     =  "";                      //(문자	6   )  단말점번호                 
	public String    TRN_TRM_NO                  	     =  "";                      //(문자	12  )  거래단말번호               
	public String    DL_BRCD                     	     =  "";                      //(문자	6   )  취급점코드                 
	public String    OPR_NO                      	     =  "";                      //(문자	8   )  조작자번호                 
	public String    RLPE_APV_DSCD               	     =  "";                      //(문자	1   )  책임자 승인 구분코드       
	public String    AVLPE_RSP_RTCD              	     =  "";                      //(문자	1   )  승인자 응답 결과코드       
	public String    RLPE_APV_SQCN               	     =  "";                      //(문자	1   )  책임자 승인 차수           
	public String    SCRN_ID                     	     =  "";                      //(문자	11  )  화면ID                     
	public String    TRN_SCRN_NO                 	     =  "";                      //(문자	5   )  거래화면번호               
	public String    TRN_CD                      	     =  "";                      //(문자	9   )  거래코드                   
	public String    SRVC_ID                     	     =  "";                      //(문자	11  )  서비스ID                   
	public String    FUNC_CD                     	     =  "";                      //(문자	2   )  기능 코드                  
	public String    CAN_TRN_DSCD                	     =  "";                      //(문자	1   )  취소거래구분코드           
	public String    INP_TLM_TYCD                	     =  "";                      //(문자	1   )  입력전문유형코드           
	public String    OUP_TLM_TYCD                	     =  "";                      //(문자	1   )  출력전문유형코드           
	public String    LQTY_DAT_PRC_DIS            	     =  "";                      //(문자	1   )  대량데이터처리구분         
	public String    TLM_CTIN_SRNO               	     =  "";                      //(숫자	4   )  전문연속일련번호           
	public String    LQTY_INP_CTIN_YN            	     =  "";                      //(문자	1   )  대량입력연속여부           
	public String    NXT_PAGE_RQU_YN             	     =  "";                      //(문자	1   )  다음페이지요구여부         
	public String    SMLT_TRN_DSCD               	     =  "";                      //(문자	1   )  시뮬레이션거래구분코드     
	public String    ACC_MOD_DSCD                	     =  "";                      //(문자	1   )  계정모드구분코드           
	public String    DL_OPNG_DSCD                	     =  "";                      //(문자	1   )  취급개설구분코드           
	public String    TRN_LOG_KEY_VAL             	     =  "";                      //(문자	56  )  거래로그키값               
	public String    CC_ONL_STCD                 	     =  "";                      //(문자	1   )  센터컷 온라인 상태 코드    
	public String    DL_RSP_INP_RCOVR_DSCD       	     =  "";                      //(문자	1   )  취급응답입력복원구분코드   
	public String    FROT_RSP_OUP_WAIT_STCD      	     =  "";                      //(문자	1   )  대외응답 출력대기 상태 코드
	public String    TRF_NACRD_YN                	     =  "";                      //(문자	1   )  대체 불일치 여부           
	public String    RST_RECP_TRN_CD             	     =  "";                      //(문자	9   )  결과수신거래코드           
	public String    RST_RECP_SRVC_ID            	     =  "";                      //(문자	11  )  결과수신서비스ID           
	public String    EXNK_DSCD                   	     =  "";                      //(문자	1   )  유무통 구분코드            
	public String    PBOK_SRNO                   	     =  "";                      //(문자	4   )  통장 일련번호              
	public String    MSK_NTGT_TRN_YN             	     =  "";                      //(문자	1   )  마스킹비대상거래여부       
	public String    RLY_TRN_DSCG_YN             	     =  "";                      //(문자	1   )  중계거래복호화여부         
	public String    SPR                         	     =  "";                      //(문자	127 )  예비                       
	
    
    private static String PGMID = "trnHeader";
    public String sThread   = "";
    public  String  logname  = ONCNF.LOGNAME;
    
    private String FieldNames[] = {
    		"TRM_BRNO",
    		"TRN_TRM_NO",
    		"DL_BRCD",
    		"OPR_NO",
    		"RLPE_APV_DSCD",
    		"AVLPE_RSP_RTCD",
    		"RLPE_APV_SQCN",
    		"SCRN_ID",
    		"TRN_SCRN_NO",
    		"TRN_CD",
    		"SRVC_ID",
    		"FUNC_CD",
    		"CAN_TRN_DSCD",
    		"INP_TLM_TYCD",
    		"OUP_TLM_TYCD",
    		"LQTY_DAT_PRC_DIS",
    		"TLM_CTIN_SRNO",
    		"LQTY_INP_CTIN_YN",
    		"NXT_PAGE_RQU_YN",
    		"SMLT_TRN_DSCD",
    		"ACC_MOD_DSCD",
    		"DL_OPNG_DSCD",
    		"TRN_LOG_KEY_VAL",
    		"CC_ONL_STCD",
    		"DL_RSP_INP_RCOVR_DSCD",
    		"FROT_RSP_OUP_WAIT_STCD",
    		"TRF_NACRD_YN",
    		"RST_RECP_TRN_CD",
    		"RST_RECP_SRVC_ID",
    		"EXNK_DSCD",
    		"PBOK_SRNO",
    		"MSK_NTGT_TRN_YN",
    		"RLY_TRN_DSCG_YN",
    		"SPR",    		    		    		
    };
    private int[] iLen =   {6,12,6,8,1,1,1,11,5,9,11,2,1,1,1,1,4,1,1,1,1,1,56,1,1,1,1,9,11,1,4,1,1,127,};

    public trnHeader()
    {
        iTLen = 300;
        
    }

    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        TRM_BRNO                    	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_TRM_NO                  	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DL_BRCD                     	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        OPR_NO                      	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLPE_APV_DSCD               	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        AVLPE_RSP_RTCD              	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLPE_APV_SQCN               	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SCRN_ID                     	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_SCRN_NO                 	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_CD                      	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SRVC_ID                     	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        FUNC_CD                     	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CAN_TRN_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        INP_TLM_TYCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        OUP_TLM_TYCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        LQTY_DAT_PRC_DIS            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TLM_CTIN_SRNO               	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        LQTY_INP_CTIN_YN            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        NXT_PAGE_RQU_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SMLT_TRN_DSCD               	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ACC_MOD_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DL_OPNG_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_LOG_KEY_VAL             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CC_ONL_STCD                 	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DL_RSP_INP_RCOVR_DSCD       	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        FROT_RSP_OUP_WAIT_STCD      	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRF_NACRD_YN                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RST_RECP_TRN_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RST_RECP_SRVC_ID            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        EXNK_DSCD                   	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        PBOK_SRNO                   	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MSK_NTGT_TRN_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLY_TRN_DSCG_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SPR                         	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;                
    }
    // code: euc-kr, utf-8 ...
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        TRM_BRNO                    	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_TRM_NO                  	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DL_BRCD                     	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        OPR_NO                      	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_APV_DSCD               	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        AVLPE_RSP_RTCD              	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_APV_SQCN               	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SCRN_ID                     	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_SCRN_NO                 	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_CD                      	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SRVC_ID                     	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FUNC_CD                     	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CAN_TRN_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INP_TLM_TYCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        OUP_TLM_TYCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        LQTY_DAT_PRC_DIS            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_CTIN_SRNO               	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        LQTY_INP_CTIN_YN            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        NXT_PAGE_RQU_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SMLT_TRN_DSCD               	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACC_MOD_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DL_OPNG_DSCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_LOG_KEY_VAL             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CC_ONL_STCD                 	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DL_RSP_INP_RCOVR_DSCD       	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FROT_RSP_OUP_WAIT_STCD      	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRF_NACRD_YN                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RST_RECP_TRN_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RST_RECP_SRVC_ID            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        EXNK_DSCD                   	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        PBOK_SRNO                   	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MSK_NTGT_TRN_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLY_TRN_DSCG_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPR                         	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;                
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, TRM_BRNO                          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_TRM_NO                        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_BRCD                           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, OPR_NO                            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_DSCD                     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, AVLPE_RSP_RTCD                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_SQCN                     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_ID                           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_SCRN_NO                       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_CD                            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SRVC_ID                           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, FUNC_CD                           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CAN_TRN_DSCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, INP_TLM_TYCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, OUP_TLM_TYCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_DAT_PRC_DIS                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_CTIN_SRNO                     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_INP_CTIN_YN                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, NXT_PAGE_RQU_YN                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SMLT_TRN_DSCD                     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, ACC_MOD_DSCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_OPNG_DSCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_LOG_KEY_VAL                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CC_ONL_STCD                       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_RSP_INP_RCOVR_DSCD             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, FROT_RSP_OUP_WAIT_STCD            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRF_NACRD_YN                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RST_RECP_TRN_CD                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RST_RECP_SRVC_ID                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, EXNK_DSCD                         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, PBOK_SRNO                         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MSK_NTGT_TRN_YN                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLY_TRN_DSCG_YN                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                               ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;           
    }
    
    // code: euc-kr, utf-8 ...
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, TRM_BRNO                       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_TRM_NO                     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_BRCD                        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, OPR_NO                         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_DSCD                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, AVLPE_RSP_RTCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_SQCN                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_ID                        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_SCRN_NO                    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_CD                         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SRVC_ID                        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FUNC_CD                        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CAN_TRN_DSCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INP_TLM_TYCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, OUP_TLM_TYCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_DAT_PRC_DIS               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_CTIN_SRNO                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_INP_CTIN_YN               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, NXT_PAGE_RQU_YN                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SMLT_TRN_DSCD                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACC_MOD_DSCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_OPNG_DSCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_LOG_KEY_VAL                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CC_ONL_STCD                    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_RSP_INP_RCOVR_DSCD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FROT_RSP_OUP_WAIT_STCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRF_NACRD_YN                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RST_RECP_TRN_CD                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RST_RECP_SRVC_ID               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, EXNK_DSCD                      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PBOK_SRNO                      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MSK_NTGT_TRN_YN                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLY_TRN_DSCG_YN                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;             
    }
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(ONCNF.LOGNAME, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRM_BRNO                = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRM_BRNO               ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRN_TRM_NO              = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_TRM_NO             ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.DL_BRCD                 = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],DL_BRCD                ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.OPR_NO                  = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],OPR_NO                 ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.RLPE_APV_DSCD           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RLPE_APV_DSCD          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.AVLPE_RSP_RTCD          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],AVLPE_RSP_RTCD         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.RLPE_APV_SQCN           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RLPE_APV_SQCN          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.SCRN_ID                 = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SCRN_ID                ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRN_SCRN_NO             = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_SCRN_NO            ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRN_CD                  = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_CD                 ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.SRVC_ID                 = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SRVC_ID                ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.FUNC_CD                 = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],FUNC_CD                ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.CAN_TRN_DSCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CAN_TRN_DSCD           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.INP_TLM_TYCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],INP_TLM_TYCD           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.OUP_TLM_TYCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],OUP_TLM_TYCD           ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.LQTY_DAT_PRC_DIS        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],LQTY_DAT_PRC_DIS       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TLM_CTIN_SRNO           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TLM_CTIN_SRNO          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.LQTY_INP_CTIN_YN        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],LQTY_INP_CTIN_YN       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.NXT_PAGE_RQU_YN         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],NXT_PAGE_RQU_YN        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.SMLT_TRN_DSCD           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SMLT_TRN_DSCD          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.ACC_MOD_DSCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ACC_MOD_DSCD           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.DL_OPNG_DSCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],DL_OPNG_DSCD           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRN_LOG_KEY_VAL         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_LOG_KEY_VAL        ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.CC_ONL_STCD             = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CC_ONL_STCD            ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.DL_RSP_INP_RCOVR_DSCD   = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],DL_RSP_INP_RCOVR_DSCD  ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.FROT_RSP_OUP_WAIT_STCD  = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],FROT_RSP_OUP_WAIT_STCD ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.TRF_NACRD_YN            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRF_NACRD_YN           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.RST_RECP_TRN_CD         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RST_RECP_TRN_CD        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.RST_RECP_SRVC_ID        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RST_RECP_SRVC_ID       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.EXNK_DSCD               = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],EXNK_DSCD              ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.PBOK_SRNO               = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],PBOK_SRNO              ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.MSK_NTGT_TRN_YN         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MSK_NTGT_TRN_YN        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.RLY_TRN_DSCG_YN         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RLY_TRN_DSCG_YN        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + trnHeader.SPR                     = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SPR                    ) +"]"   );            
        pvUtil.msglog(logname, sThread+PGMID+" +-------------------------");
    }
}