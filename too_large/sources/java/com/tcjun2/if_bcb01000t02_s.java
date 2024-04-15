/* TOBE 2017-07-01 자본예산 BS처리 송신 */

package com.tcJun2;

import java.util.List;

import com.tcLib2.*;
//import com.wmJun.LIST_OT0101R;

//AS-IS : IF_OT870100S
public class IF_BCB01000T02_S extends OUT_MSG {
	
	public String DAT_KDCD            = "";               //데이타헤더부 : (문자3)  데이터종류코드	       
	public String DAT_LEN             = "";               //데이타헤더부 : (숫자7)  데이터길이	   
	public String BGT_TRN_DT          = "";               // 1 .  S8    예산거래일자                                        
	public String MERE_TRN_DSCD       = "";               // 2 .  S4    동부동산거래구분코드                                    
	public String MERE_TLM_DIS_SRNO   = "";               // 3 .  N5    동부동산전문구분일련번호                                  
	public String TRN_BYDY_SRNO       = "";               // 4 .  N5    거래일별일련번호                                      
	public String NML_CAN_DSCD        = "";               // 5 .  S1    정상취소구분코드                                      
	public String ORTR_LOG_KEY_VAL    = "";               // 6 .  S56   원거래로그키값                                       
	public String BIZ_DSCD            = "";               // 7 .  S2    업무구분코드                                        
	public String TRM_ITLL_BRCD       = "";               // 8 .  S6    단말설치점코드                                       
	public String MOD_DSCD            = "";               // 9.   S1    모드구분코드                                        
	public String TRM_NO              = "";               // 10.  S12   단말번호                                          
	public String OPR_ENO             = "";               // 11.  S8    조작자직원번호  
	public String RLPE_ENO            = "";               // 12.  S8    책임자직원번호  (1차책임자)                                       
	public String RLPE_ENO2           = "";               // 13.  S8    책임자직원번호2 (2차책임자)
	public String RLPE_APV_CD         = "";               // 14.  S7    책임자승인코드                                       
	public String CHRG_ENO            = "";               // 15.  S8    담당직원번호                                        
	public String NSLIP_YN            = "";               // 16.  S1    무전표여부                                         
	public String NPRT_YN             = "";               // 17.  S1    무인자여부                                         
	public String XCHPY_YN            = "";               // 18.  S1    교환지급여부                                        
	public String MD_GRCD             = "";               // 19.  S4    매체그룹코드                                        
	public String BKW_ACNO            = "";               // 20.  S20   전행계좌번호                                        
	public String TRN_AM_1            = "";               // 21.  D15   거래금액_1                                        
	public String TRN_AM_2            = "";               // 22.  D15   거래금액_2                                        
	public String TRN_AM_3            = "";               // 23.  D15   거래금액_3                                        
	public String DACC_CST_DSCD       = "";               // 24.  S1    일계조립구분코드                                      
	public String KGP_DACC_CST_CNT    = "";               // 25.  N3  KGAAP일계조립건수                                   
	public String GAAP_DACC_CST_CNT   = "";               // 26.  N3  GAAP일계조립건수   
	
	public String CMN_CAN_RSN_DSCD    = "";               // 27.  S2      취소사유구분코드
	public String TRN_CAN_RSN_TXT     = "";               // 28.  S100   취소사유내용   
	
	public String DACC_CST_CNT        = "";               // 29.  N5    일계조립건수  	
	public String TEMP                = "";				  //가변영역
	
	/* 반복부
	public String DACC_CST_DSCD        = "";               // S1      일계조립구분코드                                            
	public String MERE_SUMR_CD         = "";               // S1      동부동산집계코드                                            
	public String DACC_BRCD            = "";               // S6      일계점코드                                               
	public String ACC_DSCD             = "";               // S2      계정구분코드                                              
	public String UNI_CD               = "";               // S2      합동코드                                                
	public String FND_NO               = "";               // S13     펀드번호                                                
	public String BSIS_DSCD            = "";               // S1      BS/IS구분코드                                           
	public String ACCD                 = "";               // S11     계정과목코드                                              
	public String ACI_DSCD             = "";               // S2      계정과목구분코드                                            
	public String RAP_DSCD             = "";               // S1      입지급구분코드                                             
	public String RAP_STCD             = "";               // S1      입지급상태코드                                             
	public String SLIP_SCNT            = "";               // N6      전표매수                                                
	public String CSHTF_DSCD           = "";               // S1      현금대체구분코드                                            
	public String EXU_AM               = "";               // D15     집행금액                                                
	*/
	
    public static String PGMID = "IF_BCB01000T02_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
    		"DAT_KDCD",  
    		"DAT_LEN",  
    		"BGT_TRN_DT",
    		"MERE_TRN_DSCD",
    		"MERE_TLM_DIS_SRNO",
    		"TRN_BYDY_SRNO",
    		"NML_CAN_DSCD",
    		"ORTR_LOG_KEY_VAL",
    		"BIZ_DSCD",
    		"TRM_ITLL_BRCD",
    		"MOD_DSCD",
    		"TRM_NO",
    		"OPR_ENO",
    		"RLPE_ENO",
    		"RLPE_ENO2",
    		"RLPE_APV_CD",
    		"CHRG_ENO",
    		"NSLIP_YN",
    		"NPRT_YN",
    		"XCHPY_YN",
    		"MD_GRCD",
    		"BKW_ACNO",
    		"TRN_AM_1",
    		"TRN_AM_2",
    		"TRN_AM_3",
    		"DACC_CST_DSCD",
    		"KGP_DACC_CST_CNT",
    		"GAAP_DACC_CST_CNT",
    		
    		"CMN_CAN_RSN_DSCD",
    		"TRN_CAN_RSN_TXT",
    		
    		"DACC_CST_CNT",
    		"TEMP",
    		/*
    		"DACC_CST_DSCD",
    		"MERE_SUMR_CD",
    		"DACC_BRCD",
    		"ACC_DSCD",
    		"UNI_CD",
    		"FND_NO",
    		"BSIS_DSCD",
    		"ACCD",
    		"ACI_DSCD",
    		"RAP_DSCD",
    		"RAP_STCD",
    		"SLIP_SCNT",
    		"CSHTF_DSCD",
    		"EXU_AM",
    		*/    		
    };

    //ASIS 2017-07-01 private int[] iLen = {3,7,8,4,5,5,1,56,2,6,1,12,8,8,8,7,8,1,1,1,4,20,15,15,15,1,3,3,5,10000,};    
    //TOBE 2017-07-01
    private int[] iLen = {3,7,8,4,5,5,1,56,2,6,1,12,8,8,8,7,8,1,1,1,4,20,15,15,15,1,3,3,2,100,5,70000};
    
    public IF_BCB01000T02_S()
    {
        //iTLen = 453;
    	//TOBE 2017-07-01  iTLen = 10233; // TEMP
    	iOrgLen = 335;
    	iBioLen = 669;
    }
    
    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;
		
        DAT_KDCD            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        DAT_LEN             = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        
        BGT_TRN_DT          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        MERE_TRN_DSCD       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        MERE_TLM_DIS_SRNO   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        TRN_BYDY_SRNO       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
        NML_CAN_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ORTR_LOG_KEY_VAL    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        BIZ_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRM_ITLL_BRCD       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MOD_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRM_NO              = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        OPR_ENO             = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLPE_ENO            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLPE_ENO2           = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RLPE_APV_CD         = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CHRG_ENO            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        NSLIP_YN            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        NPRT_YN             = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        XCHPY_YN            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MD_GRCD             = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        BKW_ACNO            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_AM_1            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_AM_2            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_AM_3            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DACC_CST_DSCD       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        KGP_DACC_CST_CNT    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        GAAP_DACC_CST_CNT   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        
        CMN_CAN_RSN_DSCD    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_CAN_RSN_TXT     = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        
        DACC_CST_CNT        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TEMP                = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        
	    /* 반복부
	     DACC_CST_DSCD   = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     MERE_SUMR_CD    = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     DACC_BRCD       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     ACC_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     UNI_CD          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     FND_NO          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     BSIS_DSCD       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     ACCD            = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     ACI_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     RAP_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     RAP_STCD        = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     SLIP_SCNT       = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     CSHTF_DSCD      = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     EXU_AM          = getStr(buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++; 
	     */        
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        BGT_TRN_DT            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MERE_TRN_DSCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MERE_TLM_DIS_SRNO     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_BYDY_SRNO         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        NML_CAN_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ORTR_LOG_KEY_VAL      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BIZ_DSCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRM_ITLL_BRCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MOD_DSCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRM_NO                = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        OPR_ENO               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_ENO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_ENO2             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_APV_CD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CHRG_ENO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        NSLIP_YN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        NPRT_YN               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        XCHPY_YN              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MD_GRCD               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BKW_ACNO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_AM_1              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_AM_2              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_AM_3              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DACC_CST_DSCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        KGP_DACC_CST_CNT      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        GAAP_DACC_CST_CNT     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        CMN_CAN_RSN_DSCD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_CAN_RSN_TXT       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        DACC_CST_CNT          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TEMP                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        
        /* 반복부
        DACC_CST_DSCD     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MERE_SUMR_CD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DACC_BRCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACC_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        UNI_CD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FND_NO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BSIS_DSCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACI_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RAP_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RAP_STCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SLIP_SCNT         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CSHTF_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        EXU_AM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        */
        
        
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, DAT_KDCD            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, DAT_LEN             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        
        objToArry(buff, pos, BGT_TRN_DT          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, MERE_TRN_DSCD       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, MERE_TLM_DIS_SRNO   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_BYDY_SRNO       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, NML_CAN_DSCD        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, ORTR_LOG_KEY_VAL    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;    
        objToArry(buff, pos, BIZ_DSCD            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRM_ITLL_BRCD       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, MOD_DSCD            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRM_NO              ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, OPR_ENO             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, RLPE_ENO            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_ENO2           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_CD         ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, CHRG_ENO            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, NSLIP_YN            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, NPRT_YN             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, XCHPY_YN            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, MD_GRCD             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, BKW_ACNO            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_1            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_2            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_3            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, DACC_CST_DSCD       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, KGP_DACC_CST_CNT    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, GAAP_DACC_CST_CNT   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
        
        objToArry(buff, pos, CMN_CAN_RSN_DSCD    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
        objToArry(buff, pos, TRN_CAN_RSN_TXT     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
        
        objToArry(buff, pos, DACC_CST_CNT        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        objToArry(buff, pos, TEMP                ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;  
        
        //반복부
//        objToArry(buff, pos, DACC_CST_DSCD   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, MERE_SUMR_CD    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, DACC_BRCD       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, ACC_DSCD        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, UNI_CD          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, FND_NO          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, BSIS_DSCD       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, ACCD            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, ACI_DSCD        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, RAP_DSCD        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, RAP_STCD        ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, SLIP_SCNT       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, CSHTF_DSCD      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
//        objToArry(buff, pos, EXU_AM          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++; 
        
        
    }
    
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, DAT_LEN             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        
        objToArry(buff, pos, BGT_TRN_DT          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, MERE_TRN_DSCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, MERE_TLM_DIS_SRNO   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_BYDY_SRNO       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, NML_CAN_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, ORTR_LOG_KEY_VAL    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;    
        objToArry(buff, pos, BIZ_DSCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRM_ITLL_BRCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, MOD_DSCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRM_NO              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, OPR_ENO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, RLPE_ENO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_ENO2           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_CD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, CHRG_ENO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, NSLIP_YN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, NPRT_YN             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, XCHPY_YN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, MD_GRCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, BKW_ACNO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_1            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_2            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TRN_AM_3            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, DACC_CST_DSCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, KGP_DACC_CST_CNT    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, GAAP_DACC_CST_CNT   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        
        objToArry(buff, pos, CMN_CAN_RSN_DSCD    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
        objToArry(buff, pos, TRN_CAN_RSN_TXT     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++; 
                
        objToArry(buff, pos, DACC_CST_CNT        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        objToArry(buff, pos, TEMP                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;  
        
         //반복부
//        objToArry(buff, pos, DACC_CST_DSCD   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, MERE_SUMR_CD    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, DACC_BRCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, ACC_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, UNI_CD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, FND_NO          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, BSIS_DSCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, ACCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, ACI_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, RAP_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, RAP_STCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, SLIP_SCNT       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, CSHTF_DSCD      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
//        objToArry(buff, pos, EXU_AM          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
            
    }
    
    public void log(String name,String msg) {
    	sThread = msg;
    	logname = name;
    	log();
    }
    public void log() {
    	
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD                         = "+DAT_KDCD       	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN                          = "+DAT_LEN       	               );
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + BGT_TRN_DT                       = "+BGT_TRN_DT       	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + MERE_TRN_DSCD                    = "+MERE_TRN_DSCD    	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + MERE_TLM_DIS_SRNO                = "+MERE_TLM_DIS_SRNO	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_BYDY_SRNO                    = "+TRN_BYDY_SRNO    	               );    	
    	pvUtil.msglog(logname, sThread+PGMID+" + NML_CAN_DSCD                     = "+NML_CAN_DSCD     	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + ORTR_LOG_KEY_VAL                 = "+ORTR_LOG_KEY_VAL 	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + BIZ_DSCD                         = "+BIZ_DSCD         	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + TRM_ITLL_BRCD                    = "+TRM_ITLL_BRCD    	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + MOD_DSCD                         = "+MOD_DSCD         	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + TRM_NO                           = "+TRM_NO           	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + OPR_ENO                          = "+OPR_ENO          	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_ENO                         = "+RLPE_ENO         	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_ENO2                        = "+RLPE_ENO2       	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + RLPE_APV_CD                      = "+RLPE_APV_CD      	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + CHRG_ENO                         = "+CHRG_ENO         	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + NSLIP_YN                         = "+NSLIP_YN         	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + NPRT_YN                          = "+NPRT_YN          	               );
    	pvUtil.msglog(logname, sThread+PGMID+" + XCHPY_YN                         = "+XCHPY_YN         	               );  
        pvUtil.msglog(logname, sThread+PGMID+" + MD_GRCD                          = "+MD_GRCD          	               ); 
        pvUtil.msglog(logname, sThread+PGMID+" + BKW_ACNO                         = "+BKW_ACNO         	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_AM_1                         = "+TRN_AM_1         	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_AM_2                         = "+TRN_AM_2         	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_AM_3                         = "+TRN_AM_3         	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_CST_DSCD                    = "+DACC_CST_DSCD    	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + KGP_DACC_CST_CNT                 = "+KGP_DACC_CST_CNT 	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + GAAP_DACC_CST_CNT                = "+GAAP_DACC_CST_CNT	               ); 
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + CMN_CAN_RSN_DSCD                 = "+CMN_CAN_RSN_DSCD	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TRN_CAN_RSN_TXT                  = "+TRN_CAN_RSN_TXT	               );     	
    	
    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_CST_CNT                     = "+DACC_CST_CNT     	               ); 
    	pvUtil.msglog(logname, sThread+PGMID+" + TEMP                             = "+TEMP             	               ); 
    	
//    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_CST_DSCD                = "+DACC_CST_DSCD	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + MERE_SUMR_CD                 = "+MERE_SUMR_CD 	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + DACC_BRCD                    = "+DACC_BRCD    	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + ACC_DSCD                     = "+ACC_DSCD     	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + UNI_CD                       = "+UNI_CD       	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + FND_NO                       = "+FND_NO       	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + BSIS_DSCD                    = "+BSIS_DSCD    	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + ACCD                         = "+ACCD         	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + ACI_DSCD                     = "+ACI_DSCD     	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + RAP_DSCD                     = "+RAP_DSCD     	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + RAP_STCD                     = "+RAP_STCD     	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + SLIP_SCNT                    = "+SLIP_SCNT    	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + CSHTF_DSCD                   = "+CSHTF_DSCD   	               ); 
//    	pvUtil.msglog(logname, sThread+PGMID+" + EXU_AM                       = "+EXU_AM       	               ); 
    	
    	
//    	System.out.println( sThread+PGMID+" +------------------------------------------");
    }
    public void print() {
    	int rtn = 0;
//    	System.out.println( sThread+PGMID+" + DAT_KDCD                         = "+DAT_KDCD          	               );    	
//    	System.out.println( sThread+PGMID+" + DAT_LEN                          = "+DAT_LEN          	               );    	
//    	    	
//    	System.out.println( sThread+PGMID+" + BGT_TRN_DT                       = "+BGT_TRN_DT       	               );    	
//    	System.out.println( sThread+PGMID+" + MERE_TRN_DSCD                    = "+MERE_TRN_DSCD    	               );
//    	System.out.println( sThread+PGMID+" + MERE_TLM_DIS_SRNO                = "+MERE_TLM_DIS_SRNO	               );
//    	System.out.println( sThread+PGMID+" + TRN_BYDY_SRNO                    = "+TRN_BYDY_SRNO    	               );
//    	System.out.println( sThread+PGMID+" + NML_CAN_DSCD                     = "+NML_CAN_DSCD     	               );
//    	System.out.println( sThread+PGMID+" + ORTR_LOG_KEY_VAL                 = "+ORTR_LOG_KEY_VAL 	               );
//    	System.out.println( sThread+PGMID+" + BIZ_DSCD                         = "+BIZ_DSCD         	               );
//    	System.out.println( sThread+PGMID+" + TRM_ITLL_BRCD                    = "+TRM_ITLL_BRCD    	               );
//    	System.out.println( sThread+PGMID+" + MOD_DSCD                         = "+MOD_DSCD         	               );
//    	System.out.println( sThread+PGMID+" + TRM_NO                           = "+TRM_NO           	               );
//    	System.out.println( sThread+PGMID+" + OPR_ENO                          = "+OPR_ENO          	               );
//    	System.out.println( sThread+PGMID+" + RLPE_ENO                         = "+RLPE_ENO         	               );
//    	System.out.println( sThread+PGMID+" + RLPE_ENO2                        = "+RLPE_ENO2        	               );
//    	System.out.println( sThread+PGMID+" + RLPE_APV_CD                      = "+RLPE_APV_CD      	               );
//    	System.out.println( sThread+PGMID+" + CHRG_ENO                         = "+CHRG_ENO         	               );
//        System.out.println( sThread+PGMID+" + NSLIP_YN                         = "+NSLIP_YN         	               );
//    	System.out.println( sThread+PGMID+" + NPRT_YN                          = "+NPRT_YN          	               );
//    	System.out.println( sThread+PGMID+" + XCHPY_YN                         = "+XCHPY_YN         	               );
//    	System.out.println( sThread+PGMID+" + MD_GRCD                          = "+MD_GRCD          	               );
//    	System.out.println( sThread+PGMID+" + BKW_ACNO                         = "+BKW_ACNO         	               );
//    	System.out.println( sThread+PGMID+" + TRN_AM_1                         = "+TRN_AM_1         	               );
//    	System.out.println( sThread+PGMID+" + TRN_AM_2                         = "+TRN_AM_2         	               );
//    	System.out.println( sThread+PGMID+" + TRN_AM_3                         = "+TRN_AM_3         	               );
//    	System.out.println( sThread+PGMID+" + DACC_CST_DSCD                    = "+DACC_CST_DSCD    	               );
//    	System.out.println( sThread+PGMID+" + KGP_DACC_CST_CNT                 = "+KGP_DACC_CST_CNT 	               );
//    	System.out.println( sThread+PGMID+" + GAAP_DACC_CST_CNT                = "+GAAP_DACC_CST_CNT	               );
//    	System.out.println( sThread+PGMID+" + DACC_CST_CNT                     = "+DACC_CST_CNT     	               );
//    	System.out.println( sThread+PGMID+" + TEMP                             = "+TEMP             	               ); 
    	
//    	System.out.println( sThread+PGMID+" + DACC_CST_DSCD                = "+DACC_CST_DSCD	               ); 
//    	System.out.println( sThread+PGMID+" + MERE_SUMR_CD                 = "+MERE_SUMR_CD 	               ); 
//    	System.out.println( sThread+PGMID+" + DACC_BRCD                    = "+DACC_BRCD    	               ); 
//    	System.out.println( sThread+PGMID+" + ACC_DSCD                     = "+ACC_DSCD     	               ); 
//    	System.out.println( sThread+PGMID+" + UNI_CD                       = "+UNI_CD       	               ); 
//    	System.out.println( sThread+PGMID+" + FND_NO                       = "+FND_NO       	               ); 
//    	System.out.println( sThread+PGMID+" + BSIS_DSCD                    = "+BSIS_DSCD    	               ); 
//    	System.out.println( sThread+PGMID+" + ACCD                         = "+ACCD         	               ); 
//    	System.out.println( sThread+PGMID+" + ACI_DSCD                     = "+ACI_DSCD     	               ); 
//    	System.out.println( sThread+PGMID+" + RAP_DSCD                     = "+RAP_DSCD     	               ); 
//    	System.out.println( sThread+PGMID+" + RAP_STCD                     = "+RAP_STCD     	               ); 
//    	System.out.println( sThread+PGMID+" + SLIP_SCNT                    = "+SLIP_SCNT    	               ); 
//    	System.out.println( sThread+PGMID+" + CSHTF_DSCD                   = "+CSHTF_DSCD   	               ); 
//    	System.out.println( sThread+PGMID+" + EXU_AM                       = "+EXU_AM       	               ); 
    	    	
//    	System.out.println( sThread+PGMID+" +-----------------------------------------");
    
    }
}