/* TOBE 2018-11-01 UMS SMS 문자 발송 수신 */

package com.tcJun2;

import com.tcLib2.*;

public class IF_UMSCALLTLK_R extends OUT_MSG {
 
    public String  DAT_KDCD   = ""; //데이타헤더부 : (문자3)  데이터종류코드        
    public String  DAT_LEN    = ""; //데이타헤더부 : (숫자7)  데이터길이    
    public String UMS_TRNO    = ""; //UMS거래번호     19
    public String UMS_RST_CD  = ""; //UMS결과코드      4
    public String UMS_RST_MSG = ""; //UMS결과메시지  100
  
    
    
    
 
    public static String PGMID = "IF_UMSCALLTLK_R";  
    public String sThread = "";
    public String logname = "";
    
    private String FieldNames[] = {
            "DAT_KDCD"     ,     //데이타헤더부 : (문자3)  데이터종류코드        
            "DAT_LEN"      ,     //데이타헤더부 : (숫자7)  데이터길이    
            "UMS_TRNO"     ,     //UMS거래번호     19
            "UMS_RST_CD"   ,     //UMS결과코드      4
            "UMS_RST_MSG"        //UMS결과메시지  100

    
    
    
    };
    
    private int[] iLen = { 3
    		,7
    		,19 
    		,4 
    		,100 
};

    public IF_UMSCALLTLK_R()
    {
        iTLen = 133;
    }
    
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;
        DAT_KDCD     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN      = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        UMS_TRNO     = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;     //UMS거래번호     19
        UMS_RST_CD   = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;     //UMS결과코드      4
        UMS_RST_MSG  = getStr(buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;     //UMS결과메시지  100
        
    }
   
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        objToArry(buff, pos, DAT_KDCD           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, UMS_TRNO           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, UMS_RST_CD         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        objToArry(buff, pos, UMS_RST_MSG        ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;        
        
        
        
    }
    
    public void log(String name,String msg) {
        sThread = msg;
        logname = name;
        log();
    }
    public void log() {
        int i=0;
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
        
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_KDCD      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_KDCD       ) +"]");
        pvUtil.msglog(logname, sThread+PGMID+" + DAT_LEN       = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],DAT_LEN          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + UMS_TRNO      = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UMS_TRNO          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + UMS_RST_CD    = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UMS_RST_CD          ) +"]");        
        pvUtil.msglog(logname, sThread+PGMID+" + UMS_RST_MSG   = ("+pvUtil.getNum(iLen[i], 3)+")[" + pvUtil.getFormat(iLen[i++],UMS_RST_MSG          ) +"]");        
        
        
        
        

        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
   
}
