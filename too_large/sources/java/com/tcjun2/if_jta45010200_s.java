/* TOBE 2017-07-01 재무회계 일계처리 송신 */

package com.tcJun2;
import com.tcLib2.*;
public class IF_JTA45010200_S extends OUT_MSG {
    public String  DAT_KDCD             = ""; //데이타헤더부 : (문자3)  데이터종류코드        
    public String  DAT_LEN              = ""; //데이타헤더부 : (숫자7)  데이터길이    
    public String  SLIP_NMGT_DSCD       = ""; //전표채번구분코드          
    public String  TRN_STCD             = ""; //거래상태코드              
    public String  BKCD                 = ""; //은행코드                  
    public String  TRN_EVNT_CD          = ""; //거래이벤트코드            
    public String  MAIN_ACC_DSCD        = ""; //주계정구분코드            
    public String  MAIN_ACCD            = ""; //주계정과목코드            
    public String  UNI_CD               = ""; //합동코드                  
    public String  FND_PDCD             = ""; //펀드상품코드              
    public String  CNSC_SQ_NO           = ""; //공사회차번호              
    public String  TRN_RCKN_DT          = ""; //거래기산일자              
    public String  CSNO                 = ""; //고객번호                  
    public String  BKW_ACNO             = ""; //전행계좌번호              
    public String  PDCD                 = ""; //상품코드                  
    public String  BDSYS_DSCD           = ""; //사업부제구분코드          
    public String  ATM_THRW_FD_DSCD     = ""; //자동화기기투입자금구분코드
    public String  TRF_AM_VRF_YN        = ""; //대체금액검증여부          
    public String  NXDT_XCH_OBC_YN      = ""; //익일교환타점권여부        
    public String  PLRL_APPV_YN         = ""; //복수결재여부              
    public String  CAN_TGT_TRN_LOG_SRNO = ""; //취소대상거래로그일련번호  
    public String  FILLER               = ""; //예비                      
    public String  TXT_LOOP_CNT         = ""; //반복부조립건수            
    public String  ACCT_DT              = ""; //회계일자                  
    public String  DL_BRCD              = ""; //취급점코드                
    public String  MNG_BRCD             = ""; //관리점코드                
    public String  PSTN_CCT_BRCD        = ""; //포지션집중점코드          
    public String  IOFF_DSCD            = ""; //본지점구분코드            
    public String  ACC_DSCD             = ""; //계정구분코드              
    public String  ACCD                 = ""; //계정과목코드              
    public String  JRNL_AM_TYCD         = ""; //분개금액유형코드          
    public String  ACI_DTL_DSCD         = ""; //계정과목상세구분코드      
    public String  ADJ_JRNL_DSCD        = ""; //조정분개구분코드          
    public String  RAP_DSCD             = ""; //입지급구분코드            
    public String  SLIP_SCNT            = ""; //전표매수                  
    public String  CUCD                 = ""; //통화코드                  
    public String  TRF_KRW_AM           = ""; //대체원화금액              
    public String  CUR_KRW_AM           = ""; //통화원화금액              
    public String  BCHK_KRW_AM          = ""; //자기앞수표원화금액        
    public String  OBC_KRW_AM           = ""; //타점권원화금액            
    public String  TRF_FC_AM            = ""; //대체외화금액              
    public String  TRF_FC_XC_KRW_AM     = ""; //대체외화환산원화금액      
    public String  PSTN_FC_AM           = ""; //포지션외화금액            
    public String  PSTN_FC_XC_KRW_AM    = ""; //포지션외화환산원화금액    
    public String  TRN_WTHO_SB_RT       = ""; //거래대본점매매율          
    public String  IOFF_SB_DSCD         = ""; //본지점매매구분코드        
    public String  FILLER2              = ""; //예비필드                  
  
    public static String PGMID = "IF_JTA45010200_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
             "DAT_KDCD",             //데이타헤더부 : (문자3)  데이터종류코드       
             "DAT_LEN",              //데이타헤더부 : (숫자7)  데이터길이         
             "SLIP_NMGT_DSCD",       //1 .  //전표채번구분코드                           
             "TRN_STCD",             //2 .  //거래상태코드                               
             "BKCD",                 //3 .  //은행코드                                   
             "TRN_EVNT_CD",          //4 .  //거래이벤트코드                             
             "MAIN_ACC_DSCD",        //5 .  //주계정구분코드                             
             "MAIN_ACCD",            //6 .  //주계정과목코드                             
             "UNI_CD",               //7 .  //합동코드                                   
             "FND_PDCD",             //8 .  //펀드상품코드                               
             "CNSC_SQ_NO",           //9 .  //공사회차번호                               
             "TRN_RCKN_DT",          //10.  //거래기산일자                               
             "CSNO",                 //11.  //고객번호                                   
             "BKW_ACNO",             //12.  //전행계좌번호                               
             "PDCD",                 //13.  //상품코드                                   
             "BDSYS_DSCD",           //14.  //사업부제구분코드                           
             "ATM_THRW_FD_DSCD",     //15.  //자동화기기투입자금구분코드                 
             "TRF_AM_VRF_YN",        //16.  //대체금액검증여부                           
             "NXDT_XCH_OBC_YN",      //17.  //익일교환타점권여부                         
             "PLRL_APPV_YN",         //18.  //복수결재여부                               
             "CAN_TGT_TRN_LOG_SRNO", //19.  //취소대상거래로그일련번호                   
             "FILLER",               //20.  //예비                                       
             "TXT_LOOP_CNT",         //21.  //반복부조립건수                             
             
             "ACCT_DT",              //22.  //회계일자                                   
             "DL_BRCD",              //23.  //취급점코드                                 
             "MNG_BRCD",             //24.  //관리점코드                                 
             "PSTN_CCT_BRCD",        //25.  //포지션집중점코드                           
             "IOFF_DSCD",            //26.  //본지점구분코드                             
             "ACC_DSCD",             //27.  //계정구분코드                               
             "ACCD",                 //28.  //계정과목코드                               
             "JRNL_AM_TYCD",         //29.  //분개금액유형코드                           
             "ACI_DTL_DSCD",         //30.  //계정과목상세구분코드                       
             "ADJ_JRNL_DSCD",        //31.  //조정분개구분코드                           
             "RAP_DSCD",             //32.  //입지급구분코드                             
             "SLIP_SCNT",            //33.  //전표매수                                   
             "CUCD",                 //34.  //통화코드                                   
             "TRF_KRW_AM",           //35.  //대체원화금액                               
             "CUR_KRW_AM",           //36.  //통화원화금액                               
             "BCHK_KRW_AM",          //37.  //자기앞수표원화금액                         
             "OBC_KRW_AM",           //38.  //타점권원화금액                             
             "TRF_FC_AM",            //39.  //대체외화금액                               
             "TRF_FC_XC_KRW_AM",     //40.  //대체외화환산원화금액                       
             "PSTN_FC_AM",           //41.  //포지션외화금액                             
             "PSTN_FC_XC_KRW_AM",    //42.  //포지션외화환산원화금액                     
             "TRN_WTHO_SB_RT",       //43.  //거래대본점매매율                           
             "IOFF_SB_DSCD",         //44.  //본지점매매구분코드                         
             "FILLER2"              //45.  //예비필드                                   
    };
    
    private int[] iLen = { 
             3  
    		,7 
    		,1 
    		,1 
    		,3 
    		,20
    		,2 
    		,11
    		,2 
    		,13
    		,9 
    		,8 
    		,9 
    		,20
    		,13
    		,2 
    		,2 
    		,1 
    		,1 
    		,1 
    		,56
    		,20
    		,3 
            ,8 
    		,6 
    		,6 
    		,6 
    		,3 
    		,2 
    		,11
    		,4 
    		,2 
    		,1 
    		,1 
    		,6 
    		,3 
    		,18
    		,18
    		,18
    		,18
    		,19
    		,18
    		,19
    		,18
    		,13
    		,1 
    		,20
};

    public IF_JTA45010200_S()
    {
        iTLen = 447;
        iTlen2 = 208; 
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
        DAT_KDCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SLIP_NMGT_DSCD        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_STCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BKCD                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_EVNT_CD           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_ACC_DSCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_ACCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        UNI_CD                = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;  
        FND_PDCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;       
        CNSC_SQ_NO            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRN_RCKN_DT           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CSNO                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BKW_ACNO              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        PDCD                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BDSYS_DSCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ATM_THRW_FD_DSCD      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRF_AM_VRF_YN         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        NXDT_XCH_OBC_YN       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        PLRL_APPV_YN          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CAN_TGT_TRN_LOG_SRNO  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FILLER                = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TXT_LOOP_CNT          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACCT_DT               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DL_BRCD               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        MNG_BRCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        PSTN_CCT_BRCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        IOFF_DSCD             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ACC_DSCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ACCD                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        JRNL_AM_TYCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ACI_DTL_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        ADJ_JRNL_DSCD         = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        RAP_DSCD              = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        SLIP_SCNT             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        CUCD                  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRF_KRW_AM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        CUR_KRW_AM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        BCHK_KRW_AM           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        OBC_KRW_AM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRF_FC_AM             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRF_FC_XC_KRW_AM      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        PSTN_FC_AM            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        PSTN_FC_XC_KRW_AM     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        TRN_WTHO_SB_RT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        IOFF_SB_DSCD          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        FILLER2               = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++; 
        
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, SLIP_NMGT_DSCD       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_STCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, BKCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_EVNT_CD          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_ACC_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_ACCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, UNI_CD               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FND_PDCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CNSC_SQ_NO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_RCKN_DT          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, CSNO                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BKW_ACNO             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PDCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, BDSYS_DSCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ATM_THRW_FD_DSCD     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRF_AM_VRF_YN        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, NXDT_XCH_OBC_YN      ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, PLRL_APPV_YN         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CAN_TGT_TRN_LOG_SRNO ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FILLER               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TXT_LOOP_CNT         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, ACCT_DT              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DL_BRCD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MNG_BRCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, PSTN_CCT_BRCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, IOFF_DSCD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACC_DSCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, JRNL_AM_TYCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACI_DTL_DSCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ADJ_JRNL_DSCD        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RAP_DSCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, SLIP_SCNT            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CUCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRF_KRW_AM           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, CUR_KRW_AM           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BCHK_KRW_AM          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, OBC_KRW_AM           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRF_FC_AM            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, TRF_FC_XC_KRW_AM     ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PSTN_FC_AM           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, PSTN_FC_XC_KRW_AM    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_WTHO_SB_RT       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;               
        objToArry(buff, pos, IOFF_SB_DSCD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FILLER2              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,String msg) {
        sThread = msg;
        logname = name;
        log();
    }
    public void log() {
        int i=0;
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN              ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_NMGT_DSCD         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_NMGT_DSCD       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_STCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_STCD             ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + BKCD                   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BKCD                 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_EVNT_CD            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_EVNT_CD          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MAIN_ACC_DSCD          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MAIN_ACC_DSCD        ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MAIN_ACCD              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MAIN_ACCD            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + UNI_CD                 = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UNI_CD               ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + FND_PDCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FND_PDCD             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + CNSC_SQ_NO             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CNSC_SQ_NO           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_RCKN_DT            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_RCKN_DT          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + CSNO                   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CSNO                 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BKW_ACNO               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BKW_ACNO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PDCD                   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PDCD                 ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + BDSYS_DSCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BDSYS_DSCD           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ATM_THRW_FD_DSCD       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ATM_THRW_FD_DSCD     ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRF_AM_VRF_YN          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRF_AM_VRF_YN        ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + NXDT_XCH_OBC_YN        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],NXDT_XCH_OBC_YN      ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PLRL_APPV_YN           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PLRL_APPV_YN         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + CAN_TGT_TRN_LOG_SRNO   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CAN_TGT_TRN_LOG_SRNO ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + FILLER                 = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FILLER               ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TXT_LOOP_CNT           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TXT_LOOP_CNT         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ACCT_DT                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACCT_DT              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DL_BRCD                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DL_BRCD              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + MNG_BRCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MNG_BRCD             ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + PSTN_CCT_BRCD          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PSTN_CCT_BRCD        ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + IOFF_DSCD              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],IOFF_DSCD            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ACC_DSCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACC_DSCD             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ACCD                   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACCD                 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + JRNL_AM_TYCD           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],JRNL_AM_TYCD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ACI_DTL_DSCD           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACI_DTL_DSCD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + ADJ_JRNL_DSCD          = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ADJ_JRNL_DSCD        ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + RAP_DSCD               = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RAP_DSCD             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + SLIP_SCNT              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SLIP_SCNT            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + CUCD                   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CUCD                 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRF_KRW_AM             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRF_KRW_AM           ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + CUR_KRW_AM             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CUR_KRW_AM           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + BCHK_KRW_AM            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BCHK_KRW_AM          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + OBC_KRW_AM             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],OBC_KRW_AM           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRF_FC_AM              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRF_FC_AM            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRF_FC_XC_KRW_AM       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRF_FC_XC_KRW_AM     ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PSTN_FC_AM             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PSTN_FC_AM           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + PSTN_FC_XC_KRW_AM      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],PSTN_FC_XC_KRW_AM    ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + TRN_WTHO_SB_RT         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],TRN_WTHO_SB_RT       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + IOFF_SB_DSCD           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],IOFF_SB_DSCD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + FILLER2                = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],FILLER2              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}
