/* TOBE 2017-07-01 책임자 승인 명세 송신 */

package com.tcJun2;

import com.tcLib2.*;

public class IF_ICAA9010200_S extends OUT_MSG {
 
    public String  DAT_KDCD           = ""; //데이타헤더부 : (문자3)  데이터종류코드        
    public String  DAT_LEN            = ""; //데이타헤더부 : (숫자7)  데이터길이    
    public String  WCAD_TLM_LEN       = ""; //1 .  N4	우리카드전문길이         
    public String  TRNSCT_CD          = ""; //2 .  S9	트랜잭션코드             
    public String  BGN_CHR            = ""; //3 .  S3	개시문자                 
    public String  TLM_NO             = ""; //4 .  S4	전문번호                 
    public String  TLM_UNQ_NO         = ""; //5 .  S12	전문고유번호           
    public String  MTMS_DTM           = ""; //6 .  S14	전문전송일시           
    public String  RSCD               = ""; //7 .  S2	응답코드                 
    public String  MMBHC_NO           = ""; //8 .  S2	회원사번호               
    public String  SPR_1              = ""; //9 .  S18	예비_1                 
    public String  SYS_BZCD           = ""; //10.  S3	시스템업무코드           
    public String  BAS_DT             = ""; //11.  S8	기준일자                 
    public String  TRN_BRCD           = ""; //12.  S6	거래점코드               
    public String  TRN_LOG_CRE_NO     = ""; //13.  S14	거래로그생성번호       
    public String  TRN_TM             = ""; //14.  S6	거래시각                 
    public String  TRM_NO             = ""; //15.  S12	단말번호               
    public String  TRSCNO             = ""; //16.  S5	거래화면번호             
    public String  BIZ_TRN_CD         = ""; //17.  S9	업무거래코드             
    public String  RLPE_APV_TRN_NM    = ""; //18.  S50	책임자승인거래명       
    public String  INP_MD_KDCD        = ""; //19.  S8	입력매체종류코드         
    public String  TRN_TYCD           = ""; //20.  S2	거래유형코드             
    public String  TRN_STCD           = ""; //21.  S1	거래상태코드             
    public String  OPR_NO             = ""; //22.  S8	조작자번호               
    public String  RLPE_ENO           = ""; //23.  S8	책임자직원번호           
    public String  RLPE_APV_MENS_CD   = ""; //24.  S1	책임자승인수단코드       
    public String  RLPE_CMN_MSG_CD_1  = ""; //25.  S10	책임자공통메시지코드_1 
    public String  RLPE_CMN_MSG_CD_2  = ""; //26.  S10	책임자공통메시지코드_2 
    public String  RLPE_CMN_MSG_CD_3  = ""; //27.  S10	책임자공통메시지코드_3 
    public String  RLPE_CMN_MSG_CD_4  = ""; //28.  S10	책임자공통메시지코드_4 
    public String  RLPE_CMN_MSG_CD_5  = ""; //29.  S10	책임자공통메시지코드_5 
    public String  RLPE_CMN_MSG_CD_6  = ""; //30.  S10	책임자공통메시지코드_6 
    public String  RLPE_CMN_MSG_CD_7  = ""; //31.  S10	책임자공통메시지코드_7 
    public String  RLPE_CMN_MSG_CD_8  = ""; //32.  S10	책임자공통메시지코드_8 
    public String  RLPE_CMN_MSG_CD_9  = ""; //33.  S10	책임자공통메시지코드_9 
    public String  RLPE_CMN_MSG_CD_10 = ""; //34.  S10	책임자공통메시지코드_10
    public String  RLPE_CMN_MSG_CD_11 = ""; //35.  S10	책임자공통메시지코드_11
    public String  RLPE_CMN_MSG_CD_12 = ""; //36.  S10	책임자공통메시지코드_12
    public String  RLPE_CMN_MSG_CD_13 = ""; //37.  S10	책임자공통메시지코드_13
    public String  RLPE_CMN_MSG_CD_14 = ""; //38.  S10	책임자공통메시지코드_14
    public String  RLPE_CMN_MSG_CD_15 = ""; //39.  S10	책임자공통메시지코드_15
    public String  RLPE_CMN_MSG_CD_16 = ""; //40.  S10	책임자공통메시지코드_16
    public String  RLPE_CMN_MSG_CD_17 = ""; //41.  S10	책임자공통메시지코드_17
    public String  RLPE_CMN_MSG_CD_18 = ""; //42.  S10	책임자공통메시지코드_18
    public String  RLPE_CMN_MSG_CD_19 = ""; //43.  S10	책임자공통메시지코드_19
    public String  RLPE_CMN_MSG_CD_20 = ""; //44.  S10	책임자공통메시지코드_20
    public String  PTN_BKW_ACNO       = ""; //45.  S20	상대전행계좌번호       
    public String  TRN_BKW_ACNO       = ""; //46.  S20	거래전행계좌번호       
    public String  ITCSNO             = ""; //47.  S11	통합고객번호           
    public String  BKW_ACNO           = ""; //48.  S20	전행계좌번호           
    public String  TRN_KRW_AM         = ""; //49.  D19	거래원화금액(18,3)           
    public String  TRN_FC_AM          = ""; //50.  D19	거래외화금액(18,3)           
    public String  ACCT_DT            = ""; //51.  S8	회계일자                 
    public String  MOD_DSCD           = ""; //52.  S1	모드구분코드             
    public String  SLIP_NO            = ""; //53.  S16	전표번호               
    public String  DACC_BRCD          = ""; //54.  S6	일계점코드               
    public String  CUS_NM             = ""; //55.  S50	고객명                 
    public String  RLPE_ENO_2         = ""; //56.  S8	책임자직원번호_2         
    public String  SPR                = ""; //57.  S1895	예비                
  
    public static String PGMID = "IF_ICAA9010200_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
            "DAT_KDCD           ", //데이타헤더부 : (문자3)  데이터종류코드        
            "DAT_LEN            ", //데이타헤더부 : (숫자7)  데이터길이    
            "WCAD_TLM_LEN       ", //1 .  N	4	우리카드전문길이         
            "TRNSCT_CD          ", //2 .  S	9	트랜잭션코드             
            "BGN_CHR            ", //3 .  S	3	개시문자                 
            "TLM_NO             ", //4 .  S	4	전문번호                 
            "TLM_UNQ_NO         ", //5 .  S	12	전문고유번호           
            "MTMS_DTM           ", //6 .  S	14	전문전송일시           
            "RSCD               ", //7 .  S	2	응답코드                 
            "MMBHC_NO           ", //8 .  S	2	회원사번호               
            "SPR_1              ", //9 .  S	18	예비_1                 
            "SYS_BZCD           ", //10.  S	3	시스템업무코드           
            "BAS_DT             ", //11.  S	8	기준일자                 
            "TRN_BRCD           ", //12.  S	6	거래점코드               
            "TRN_LOG_CRE_NO     ", //13.  S	14	거래로그생성번호       
            "TRN_TM             ", //14.  S	6	거래시각                 
            "TRM_NO             ", //15.  S	12	단말번호               
            "TRSCNO             ", //16.  S	5	거래화면번호             
            "BIZ_TRN_CD         ", //17.  S	9	업무거래코드             
            "RLPE_APV_TRN_NM    ", //18.  S	50	책임자승인거래명       
            "INP_MD_KDCD        ", //19.  S	8	입력매체종류코드         
            "TRN_TYCD           ", //20.  S	2	거래유형코드             
            "TRN_STCD           ", //21.  S	1	거래상태코드             
            "OPR_NO             ", //22.  S	8	조작자번호               
            "RLPE_ENO           ", //23.  S	8	책임자직원번호           
            "RLPE_APV_MENS_CD   ", //24.  S	1	책임자승인수단코드       
            "RLPE_CMN_MSG_CD_1  ", //25.  S	10	책임자공통메시지코드_1 
            "RLPE_CMN_MSG_CD_2  ", //26.  S	10	책임자공통메시지코드_2 
            "RLPE_CMN_MSG_CD_3  ", //27.  S	10	책임자공통메시지코드_3 
            "RLPE_CMN_MSG_CD_4  ", //28.  S	10	책임자공통메시지코드_4 
            "RLPE_CMN_MSG_CD_5  ", //29.  S	10	책임자공통메시지코드_5 
            "RLPE_CMN_MSG_CD_6  ", //30.  S	10	책임자공통메시지코드_6 
            "RLPE_CMN_MSG_CD_7  ", //31.  S	10	책임자공통메시지코드_7 
            "RLPE_CMN_MSG_CD_8  ", //32.  S	10	책임자공통메시지코드_8 
            "RLPE_CMN_MSG_CD_9  ", //33.  S	10	책임자공통메시지코드_9 
            "RLPE_CMN_MSG_CD_10 ", //34.  S	10	책임자공통메시지코드_10
            "RLPE_CMN_MSG_CD_11 ", //35.  S	10	책임자공통메시지코드_11
            "RLPE_CMN_MSG_CD_12 ", //36.  S	10	책임자공통메시지코드_12
            "RLPE_CMN_MSG_CD_13 ", //37.  S	10	책임자공통메시지코드_13
            "RLPE_CMN_MSG_CD_14 ", //38.  S	10	책임자공통메시지코드_14
            "RLPE_CMN_MSG_CD_15 ", //39.  S	10	책임자공통메시지코드_15
            "RLPE_CMN_MSG_CD_16 ", //40.  S	10	책임자공통메시지코드_16
            "RLPE_CMN_MSG_CD_17 ", //41.  S	10	책임자공통메시지코드_17
            "RLPE_CMN_MSG_CD_18 ", //42.  S	10	책임자공통메시지코드_18
            "RLPE_CMN_MSG_CD_19 ", //43.  S	10	책임자공통메시지코드_19
            "RLPE_CMN_MSG_CD_20 ", //44.  S	10	책임자공통메시지코드_20
            "PTN_BKW_ACNO       ", //45.  S	20	상대전행계좌번호       
            "TRN_BKW_ACNO       ", //46.  S	20	거래전행계좌번호       
            "ITCSNO             ", //47.  S	11	통합고객번호           
            "BKW_ACNO           ", //48.  S	20	전행계좌번호           
            "TRN_KRW_AM         ", //49.  D	19	거래원화금액(18,3)           
            "TRN_FC_AM          ", //50.  D	19	거래외화금액(18,3)
            "ACCT_DT            ", //51.  S	8	회계일자                 
            "MOD_DSCD           ", //52.  S	1	모드구분코드             
            "SLIP_NO            ", //53.  S	16	전표번호               
            "DACC_BRCD          ", //54.  S	6	일계점코드               
            "CUS_NM             ", //55.  S	50	고객명                 
            "RLPE_ENO_2         ", //56.  S	8	책임자직원번호_2         
            "SPR                ", //57.  S	1895	예비                 

    };
    
    private int[] iLen = { 3,7,4,9,3,4,12,14,2,2,18,3,8,6,14,6,12,5,9,50,8,2,1,8,8,1,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,20,20,11,20,19,19,8,1,16,6,50,8,1895};

    public IF_ICAA9010200_S()
    {
        iTLen = 2512;
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
        DAT_KDCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        WCAD_TLM_LEN        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRNSCT_CD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BGN_CHR             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_NO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_UNQ_NO          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MTMS_DTM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RSCD                = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
        MMBHC_NO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
        SPR_1               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        SYS_BZCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BAS_DT              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_BRCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_LOG_CRE_NO      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_TM              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRM_NO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRSCNO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BIZ_TRN_CD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_APV_TRN_NM     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INP_MD_KDCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_TYCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_STCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        OPR_NO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RLPE_ENO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_APV_MENS_CD    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_1   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_2   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_3   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_4   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_5   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_6   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_7   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_8   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_9   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_10  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_11  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_12  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_13  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_14  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_15  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_16  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_17  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_18  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_19  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_CMN_MSG_CD_20  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        PTN_BKW_ACNO        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRN_BKW_ACNO        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ITCSNO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        BKW_ACNO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRN_KRW_AM          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRN_FC_AM           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ACCT_DT             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        MOD_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        SLIP_NO             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        DACC_BRCD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        CUS_NM              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RLPE_ENO_2          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        SPR                 = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, WCAD_TLM_LEN       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRNSCT_CD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, BGN_CHR            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_NO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_UNQ_NO         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MTMS_DTM           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RSCD               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MMBHC_NO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR_1              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SYS_BZCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, BAS_DT             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_BRCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_LOG_CRE_NO     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, TRN_TM             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRM_NO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRSCNO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BIZ_TRN_CD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_APV_TRN_NM    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INP_MD_KDCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_TYCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_STCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, OPR_NO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_ENO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_APV_MENS_CD   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, RLPE_CMN_MSG_CD_1  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_2  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_3  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_4  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_CMN_MSG_CD_5  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_6  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_7  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_8  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, RLPE_CMN_MSG_CD_9  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_10 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_11 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, RLPE_CMN_MSG_CD_12 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_13 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_14 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_15 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, RLPE_CMN_MSG_CD_16 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_17 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_18 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_CMN_MSG_CD_19 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, RLPE_CMN_MSG_CD_20 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PTN_BKW_ACNO       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_BKW_ACNO       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, ITCSNO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BKW_ACNO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_KRW_AM         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_FC_AM          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, ACCT_DT            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MOD_DSCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SLIP_NO            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DACC_BRCD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, CUS_NM             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RLPE_ENO_2         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;                
    }
    
    public void log(String name,String msg) {
        sThread = msg;
        logname = name;
        log();
    }
    public void log() {
        int i=0;
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],WCAD_TLM_LEN       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRNSCT_CD          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + WCAD_TLM_LEN         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],WCAD_TLM_LEN       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRNSCT_CD            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRNSCT_CD          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + BGN_CHR              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BGN_CHR            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TLM_NO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TLM_NO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TLM_UNQ_NO           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TLM_UNQ_NO         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MTMS_DTM             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MTMS_DTM           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RSCD                 = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RSCD               ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MMBHC_NO             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MMBHC_NO           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SPR_1                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPR_1              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SYS_BZCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SYS_BZCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BAS_DT               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BAS_DT             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_BRCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_BRCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_LOG_CRE_NO       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_LOG_CRE_NO     ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_TM               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_TM             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRM_NO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRM_NO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRSCNO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRSCNO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BIZ_TRN_CD           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BIZ_TRN_CD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_APV_TRN_NM      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_APV_TRN_NM    ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + INP_MD_KDCD          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],INP_MD_KDCD        ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_TYCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_TYCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_STCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_STCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + OPR_NO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],OPR_NO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_ENO             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_ENO           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_APV_MENS_CD     = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_APV_MENS_CD   ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_1    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_1  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_2    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_2  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_3    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_3  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_4    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_4  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_5    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_5  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_6    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_6  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_7    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_7  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_8    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_8  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_9    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_9  ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_10   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_10 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_11   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_11 ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_12   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_12 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_13   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_13 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_14   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_14 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_15   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_15 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_16   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_16 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_17   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_17 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_18   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_18 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_19   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_19 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_CMN_MSG_CD_20   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_CMN_MSG_CD_20 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PTN_BKW_ACNO         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PTN_BKW_ACNO       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_BKW_ACNO         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_BKW_ACNO       ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + ITCSNO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ITCSNO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BKW_ACNO             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BKW_ACNO           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_KRW_AM           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_KRW_AM         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_FC_AM            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_FC_AM          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ACCT_DT              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACCT_DT            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MOD_DSCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MOD_DSCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_NO              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_NO            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DACC_BRCD            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DACC_BRCD          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + CUS_NM               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CUS_NM             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RLPE_ENO_2           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RLPE_ENO_2         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SPR                  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPR                ) +"]");        

        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}
