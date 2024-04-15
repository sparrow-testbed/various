/* TOBE 2017-07-01 응답전문 - 메세지 헤더 (정상시) */

package com.tcJun2;

import com.tcLib2.*;
import com.tcComm2.*;

public class msgHeader extends MSG_0000 {
	
  public String    DAT_KDCD                          =  "";                      //(문자  3   )  데이터종류코드      
  public String    DAT_LEN                           =  "";                      //(숫자  7   )  데이터길이          
  public String    SPR                               =  "";                      //(문자  288 )  예비              
  public String    TRN_CTN_DSCD                      =  "";                      //(문자  1   )  거래계속구분코드    
  public String    LQTY_PRC_ERR_LCA                  =  "";                      //(숫자  5   )  대량처리오류위치    
  public String    CPNT_REPT_CN                      =  "";                      //(숫자  2   )  컴포넌트 반복 수    
  public String    SCRN_ID                           =  "";                      //(문자  11  )  화면ID             
  public String    SCRN_CPNT_ENG_NM                  =  "";                      //(문자  50  )  화면 컴포넌트 영문
  public String    MAIN_MSG_INF_REPT_CN              =  "";                      //(숫자  2   )  주메시지정보반복수  
  public String    MSG_CD                            =  "";                      //(문자  10  )  메시지코드 (n)     
  public String    CCTN_TRN_SCRN_NO                  =  "";                      //(문자  5   )  연결 거래화면번호 (n)
  public String    MAIN_MSG_TXT                      =  "";                      //(문자  200 )  주메시지내용 (n)  
  public String    MAIN_MSG_ADD_TXT                  =  "";                      //(문자  200 )  주메시지 추가 내용 (n)
  public String    MAIN_MSG_ATRB_INF                 =  "";                      //(문자  4   )  주메시지 속성정보 (n)
  public String    ERR_LCA_TXT                       =  "";                      //(문자  100 )  오류위치내용 (n)  
  public String    ADI_MSG_REPT_CN                   =  "";                      //(숫자  2   )  부가메시지반복수    
  //public String    ADI_MSG_CD                        =  "";                      //(문자  10  )  부가메시지코드 (n) 
  //public String    ADI_MSG_TXT                       =  "";                      //(문자  100 )  부가메시지내용 (n)
	
    
    private static String PGMID = "msgHeader";
    public String sThread   = "";
    public  String  logname  = ONCNF.LOGNAME;
    
    private String FieldNames[] = {
    
        "DAT_KDCD",                 
        "DAT_LEN",                  
        "SPR",                      
        "TRN_CTN_DSCD",             
        "LQTY_PRC_ERR_LCA",         
        "CPNT_REPT_CN",             
        "SCRN_ID",                  
        "SCRN_CPNT_ENG_NM",         
        "MAIN_MSG_INF_REPT_CN",     
        "MSG_CD",                   
        "CCTN_TRN_SCRN_NO",         
        "MAIN_MSG_TXT",             
        "MAIN_MSG_ADD_TXT",         
        "MAIN_MSG_ATRB_INF",        
        "ERR_LCA_TXT",              
        "ADI_MSG_REPT_CN",          
        //"ADI_MSG_CD",               
        //"ADI_MSG_TXT",              
    		    		
    };
    //private int[] iLen =   {3,7,288,1,5,2,11,50,2,10,5,200,200,4,100,2,10,100,};
    private int[] iLen =   {3,7,288,1,5,2,11,50,2,10,5,200,200,4,100,2,};

    public msgHeader()
    {
        iTLen = 890;
        
    }

    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        DAT_KDCD              	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        DAT_LEN               	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SPR                   	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_CTN_DSCD          	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        LQTY_PRC_ERR_LCA      	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CPNT_REPT_CN          	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SCRN_ID               	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SCRN_CPNT_ENG_NM      	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MAIN_MSG_INF_REPT_CN  	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MSG_CD                	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CCTN_TRN_SCRN_NO      	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MAIN_MSG_TXT          	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MAIN_MSG_ADD_TXT      	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MAIN_MSG_ATRB_INF     	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ERR_LCA_TXT           	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ADI_MSG_REPT_CN       	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        //ADI_MSG_CD            	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        //ADI_MSG_TXT           	           = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
               
    }
    // code: euc-kr, utf-8 ...
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        DAT_KDCD              	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        DAT_LEN               	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPR                   	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_CTN_DSCD          	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        LQTY_PRC_ERR_LCA      	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CPNT_REPT_CN          	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SCRN_ID               	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SCRN_CPNT_ENG_NM      	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_MSG_INF_REPT_CN  	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MSG_CD                	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CCTN_TRN_SCRN_NO      	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_MSG_TXT          	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_MSG_ADD_TXT      	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MAIN_MSG_ATRB_INF     	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ERR_LCA_TXT           	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ADI_MSG_REPT_CN       	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        //ADI_MSG_CD            	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        //ADI_MSG_TXT           	           = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;              
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, DAT_KDCD              	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN               	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                   	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_CTN_DSCD          	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_PRC_ERR_LCA      	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CPNT_REPT_CN          	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_ID               	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_CPNT_ENG_NM      	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_INF_REPT_CN  	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_CD                	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CCTN_TRN_SCRN_NO      	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_TXT          	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_ADD_TXT      	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_ATRB_INF     	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, ERR_LCA_TXT           	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, ADI_MSG_REPT_CN       	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        //objToArry(buff, pos, ADI_MSG_CD            	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        //objToArry(buff, pos, ADI_MSG_TXT           	           ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;          
    }
    
    // code: euc-kr, utf-8 ...
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, DAT_KDCD              	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, DAT_LEN               	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                   	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_CTN_DSCD          	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, LQTY_PRC_ERR_LCA      	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CPNT_REPT_CN          	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_ID               	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SCRN_CPNT_ENG_NM      	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_INF_REPT_CN  	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_CD                	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CCTN_TRN_SCRN_NO      	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_TXT          	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_ADD_TXT      	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MAIN_MSG_ATRB_INF     	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ERR_LCA_TXT           	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ADI_MSG_REPT_CN       	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        //objToArry(buff, pos, ADI_MSG_CD            	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        //objToArry(buff, pos, ADI_MSG_TXT           	           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;           
    }
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(ONCNF.LOGNAME, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.DAT_KDCD              = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],DAT_KDCD             ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.DAT_LEN               = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],DAT_LEN              ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.SPR                   = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SPR                  ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.TRN_CTN_DSCD          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_CTN_DSCD         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.LQTY_PRC_ERR_LCA      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],LQTY_PRC_ERR_LCA     ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.CPNT_REPT_CN          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CPNT_REPT_CN         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.SCRN_ID               = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SCRN_ID              ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.SCRN_CPNT_ENG_NM      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SCRN_CPNT_ENG_NM     ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.MAIN_MSG_INF_REPT_CN  = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MAIN_MSG_INF_REPT_CN ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.MSG_CD                = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MSG_CD               ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.CCTN_TRN_SCRN_NO      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CCTN_TRN_SCRN_NO     ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.MAIN_MSG_TXT          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MAIN_MSG_TXT         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.MAIN_MSG_ADD_TXT      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MAIN_MSG_ADD_TXT     ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.MAIN_MSG_ATRB_INF     = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MAIN_MSG_ATRB_INF    ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.ERR_LCA_TXT           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ERR_LCA_TXT          ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.ADI_MSG_REPT_CN       = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ADI_MSG_REPT_CN      ) +"]"   );
        //pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.ADI_MSG_CD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ADI_MSG_CD           ) +"]"   );
        //pvUtil.msglog(logname, sThread+PGMID+" + msgHeader.ADI_MSG_TXT           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ADI_MSG_TXT          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" +-------------------------");
    }
}
