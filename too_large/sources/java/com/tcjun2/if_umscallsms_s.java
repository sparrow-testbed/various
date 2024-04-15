/* TOBE 2017-07-01 UMS SMS 문자 발송 송신 */

package com.tcJun2;

import com.tcLib2.*;

public class IF_UMSCALLSMS_S extends OUT_MSG {
 
    public String  DAT_KDCD           = ""; //데이타헤더부 : (문자3)  데이터종류코드        
    public String  DAT_LEN            = ""; //데이타헤더부 : (숫자7)  데이터길이    
    public String  UMS_TRNO           = ""; //UMS거래번호         VARCHAR(19 )
    public String  UMS_TMPL_CD        = ""; //UMS템플릿코드       VARCHAR(15 )
    public String  DEPT_SBR_CD        = ""; //부서부점코드          VARCHAR(6  )
    public String  RSV_DT             = ""; //예약일자            VARCHAR(14 )
    public String  SMS_LRCL_BZCD      = ""; //SMS대분류업무코드   VARCHAR(10 )
    public String  SMS_MCLF_BZCD      = ""; //SMS중분류업무코드   VARCHAR(10 )
    public String  CSNO               = ""; //고객번호            VARCHAR(20 )
    public String  ACT_CDNO           = ""; //계좌카드번호        VARCHAR(40 )
    public String  ACT_ISU_BR         = ""; //계좌발급점          VARCHAR(10 )
    public String  RECP_TEL_NO        = ""; //수신전화번호        VARCHAR(16 )
    public String  DMSG_TEL_NO        = ""; //발신전화번호        VARCHAR(16 )
    public String  SMS_TP             = ""; //SMS유형             VARCHAR(1  )
    public String  SPR_TXT_1          = ""; //예비내용_1          VARCHAR(50 )
    public String  SPR_TXT_2          = ""; //예비내용_2          VARCHAR(50 )
    public String  CUS_NM             = ""; //고객명              VARCHAR(20 )
    public String  ACNO               = ""; //계좌번호            VARCHAR(20 )
    public String  COP_NM             = ""; //기업명              VARCHAR(50 )
    public String  STL_AM             = ""; //결제금액            VARCHAR(20 )
    public String  BAL                = ""; //잔액                VARCHAR(20 )
    public String  CRTF_NO            = ""; //인증번호            VARCHAR(10 )
    public String  MPNG_1             = ""; //매핑_1              VARCHAR(50 )
    public String  MPNG_2             = ""; //매핑_2              VARCHAR(50 )
    public String  MPNG_3             = ""; //매핑_3              VARCHAR(50 )
    public String  MPNG_4             = ""; //매핑_4              VARCHAR(50 )
    public String  MPNG_5             = ""; //매핑_5              VARCHAR(50 )
    public String  MPNG_6             = ""; //매핑_6              VARCHAR(50 )
    public String  MPNG_7             = ""; //매핑_7              VARCHAR(50 )
    public String  MPNG_8             = ""; //매핑_8              VARCHAR(50 )
    public String  MPNG_9             = ""; //매핑_9              VARCHAR(50 )
    public String  MPNG_10            = ""; //매핑_10             VARCHAR(50 )
    public String  MPNG_ALL_TITL      = ""; //매핑전체제목        VARCHAR(160)
  
    public static String PGMID = "IF_ICAA9010200_S";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
            "DAT_KDCD"     ,     //데이타헤더부 : (문자3)  데이터종류코드        
            "DAT_LEN"      ,     //데이타헤더부 : (숫자7)  데이터길이    
            "UMS_TRNO"     ,     //UMS거래번호         VARCHAR(19 ) 
            "UMS_TMPL_CD"  ,     //UMS템플릿코드       VARCHAR(15 )
            "DEPT_SBR_CD"  ,     //부서부점코드        VARCHAR(6  )
            "RSV_DT"       ,     //예약일자            VARCHAR(14 )
            "SMS_LRCL_BZCD",     //SMS대분류업무코드   VARCHAR(10 )
            "SMS_MCLF_BZCD",     //SMS중분류업무코드   VARCHAR(10 )
            "CSNO"         ,     //고객번호            VARCHAR(20 )
            "ACT_CDNO"     ,     //계좌카드번호        VARCHAR(40 )
            "ACT_ISU_BR"   ,     //계좌발급점          VARCHAR(10 )
            "RECP_TEL_NO"  ,     //수신전화번호        VARCHAR(16 )
            "DMSG_TEL_NO"  ,     //발신전화번호        VARCHAR(16 )
            "SMS_TP"       ,     //SMS유형             VARCHAR(1  )
            "SPR_TXT_1"    ,     //예비내용_1          VARCHAR(50 )
            "SPR_TXT_2"    ,     //예비내용_2          VARCHAR(50 )
            "CUS_NM"       ,     //고객명              VARCHAR(20 )
            "ACNO"         ,     //계좌번호            VARCHAR(20 )
            "COP_NM"       ,     //기업명              VARCHAR(50 )
            "STL_AM"       ,     //결제금액            VARCHAR(20 )
            "BAL"          ,     //잔액                VARCHAR(20 )
            "CRTF_NO"      ,     //인증번호            VARCHAR(10 )
            "MPNG_1"       ,     //매핑_1              VARCHAR(50 )
            "MPNG_2"       ,     //매핑_2              VARCHAR(50 )
            "MPNG_3"       ,     //매핑_3              VARCHAR(50 )
            "MPNG_4"       ,     //매핑_4              VARCHAR(50 )
            "MPNG_5"       ,     //매핑_5              VARCHAR(50 )
            "MPNG_6"       ,     //매핑_6              VARCHAR(50 )
            "MPNG_7"       ,     //매핑_7              VARCHAR(50 )
            "MPNG_8"       ,     //매핑_8              VARCHAR(50 )
            "MPNG_9"       ,     //매핑_9              VARCHAR(50 )
            "MPNG_10"      ,     //매핑_10             VARCHAR(50 )
            "MPNG_ALL_TITL"      //매핑전체제목        VARCHAR(160)

    };
    
    private int[] iLen = { 3
    		,7
    		,19 
    		,15 
    		,6  
    		,14 
    		,10 
    		,10 
    		,20 
    		,40 
    		,10 
    		,16 
    		,16 
    		,1  
    		,50 
    		,50 
    		,20 
    		,20 
    		,50 
    		,20 
    		,20 
    		,10 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,50 
    		,160
};

    public IF_UMSCALLSMS_S()
    {
        iTLen = 1087;
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
        DAT_KDCD            = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN             = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        UMS_TRNO      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        UMS_TMPL_CD   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DEPT_SBR_CD   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RSV_DT        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SMS_LRCL_BZCD = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SMS_MCLF_BZCD = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CSNO          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACT_CDNO      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACT_ISU_BR    = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RECP_TEL_NO   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DMSG_TEL_NO   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SMS_TP        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPR_TXT_1     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPR_TXT_2     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CUS_NM        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ACNO          = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        COP_NM        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        STL_AM        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        BAL           = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CRTF_NO       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_1        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_2        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_3        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_4        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_5        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_6        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_7        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_8        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_9        = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_10       = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MPNG_ALL_TITL = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;        
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, UMS_TRNO      , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;   
        objToArry(buff, pos, UMS_TMPL_CD   , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DEPT_SBR_CD   , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RSV_DT        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SMS_LRCL_BZCD , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SMS_MCLF_BZCD , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CSNO          , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACT_CDNO      , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACT_ISU_BR    , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RECP_TEL_NO   , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DMSG_TEL_NO   , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SMS_TP        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR_TXT_1     , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR_TXT_2     , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CUS_NM        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ACNO          , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, COP_NM        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, STL_AM        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, BAL           , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CRTF_NO       , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_1        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_2        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_3        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_4        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_5        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_6        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_7        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_8        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_9        , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_10       , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MPNG_ALL_TITL , iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
    }
    
    public void log(String name,String msg) {
        sThread = msg;
        logname = name;
        log();
    }
    public void log() {
        int i=0;
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD             = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN              = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" +  UMS_TRNO       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UMS_TRNO            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  UMS_TMPL_CD    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UMS_TMPL_CD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  DEPT_SBR_CD    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DEPT_SBR_CD         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  RSV_DT         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RSV_DT              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  SMS_LRCL_BZCD  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SMS_LRCL_BZCD       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  SMS_MCLF_BZCD  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SMS_MCLF_BZCD       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  CSNO           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CSNO                ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  ACT_CDNO       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACT_CDNO            ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  ACT_ISU_BR     = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACT_ISU_BR          ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  RECP_TEL_NO    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],RECP_TEL_NO         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  DMSG_TEL_NO    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DMSG_TEL_NO         ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  SMS_TP         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SMS_TP              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  SPR_TXT_1      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPR_TXT_1           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  SPR_TXT_2      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],SPR_TXT_2           ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  CUS_NM         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CUS_NM              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  ACNO           = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],ACNO                ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  COP_NM         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],COP_NM              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  STL_AM         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],STL_AM              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  BAL            = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],BAL                 ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  CRTF_NO        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],CRTF_NO             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_1         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_1              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_2         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_2              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_3         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_3              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_4         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_4              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_5         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_5              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_6         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_6              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_7         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_7              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_8         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_8              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_9         = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_9              ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_10        = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_10             ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +  MPNG_ALL_TITL  = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],MPNG_ALL_TITL       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}
