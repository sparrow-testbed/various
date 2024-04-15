/* TOBE 2017-07-01 시스템 헤더 */

package com.tcJun2;

import com.tcLib2.*;
import com.tcComm2.*;

public class sysHeader extends MSG_0000 {
	
	public String    ALL_TLM_LEN            	     =  "";                      //(숫자	8         )  전체전문길이             
	public String    VER                    	     =  "";                      //(문자	4         )  버전                     
	public String    TLM_ENCY_DSCD          	     =  "";                      //(문자	1         )  전문암호화구분코드       
	public String    ORG_GLBL_ID            	     =  "";                      //(문자/숫자 조합	32)  원글로벌ID               
	public String    GLBL_ID                	     =  "";                      //(문자/숫자 조합	32)  글로벌ID                 
	public String    GLBL_ID_PRG_SRNO       	     =  "";                      //(숫자	4         )  글로벌ID 진행일련번호    
	public String    CHNL_CD                	     =  "";                      //(문자	3         )  채널코드                 
	public String    CHNL_DSCD              	     =  "";                      //(문자	3         )  채널구분코드             
	public String    CLNT_IPAD              	     =  "";                      //(문자	39        )  클라이언트IP주소         
	public String    CLNT_MAC               	     =  "";                      //(문자	12        )  클라이언트MAC            
	public String    ENV_INF_DSCD           	     =  "";                      //(문자	1         )  환경정보구분코드         
	public String    FST_TMS_SYS_CD         	     =  "";                      //(문자	3         )  최초전송시스템코드       
	public String    LANG_DSCD              	     =  "";                      //(문자	2         )  언어구분코드             
	public String    TMS_SYS_CD             	     =  "";                      //(문자	3         )  전송시스템코드           
	public String    MD_KDCD                	     =  "";                      //(문자	8         )  매체종류코드             
	public String    INTF_ID                	     =  "";                      //(문자	12        )  인터페이스 ID            
	public String    MCA_CHNL_SESS_ID       	     =  "";                      //(문자	25        )  MCA 채널세션 ID          
	public String    INTF_SYS_NODE_NO       	     =  "";                      //(문자	5         )  인터페이스시스템 노드번호
	public String    REQ_SYS_CD             	     =  "";                      //(문자	3         )  요청시스템코드           
	public String    REQ_SYS_NODE_ID        	     =  "";                      //(문자	3         )  요청시스템노드ID         
	public String    TRN_SYN_DSCD           	     =  "";                      //(문자	1         )  거래동기화구분코드       
	public String    REQ_RSP_DSCD           	     =  "";                      //(문자	1         )  요청응답구분코드         
	public String    TLM_REQ_DTM            	     =  "";                      //(문자	17        )  전문요청일시             
	public String    TTL_USG_YN             	     =  "";                      //(문자	1         )  TTL사용여부              
	public String    FST_STA_TM             	     =  "";                      //(문자	6         )  최초시작시각             
	public String    VLD_TIM                	     =  "";                      //(숫자	3         )  유효시간                 
	public String    RSP_SYS_CD             	     =  "";                      //(문자	3         )  응답시스템코드           
	public String    TLM_RSP_DTM            	     =  "";                      //(문자	17        )  전문응답일시             
	public String    RSP_RST_DSCD           	     =  "";                      //(문자	1         )  응답결과구분코드         
	public String    MSG_OCC_SYS_CD         	     =  "";                      //(문자	3         )  메시지발생시스템코드     
	public String    MSG_CD                 	     =  "";                      //(문자	10        )  메시지코드               
	public String    LST_CHNL_TYCD          	     =  "";                      //(문자	3         )  최종채널유형코드         
	public String    CHNL_TLM_CMNP_LEN      	     =  "";                      //(숫자	4         )  채널전문공통부 길이      
	public String    SPR                    	     =  "";                      //(문자	127       )  예비                     
	
    
    private static String PGMID = "sysHeader";
    public String sThread   = "";
    public  String  logname  = ONCNF.LOGNAME;
    
    private String FieldNames[] = {
    		"ALL_TLM_LEN",
    		"VER",
    		"TLM_ENCY_DSCD",
    		"ORG_GLBL_ID",
    		"GLBL_ID",
    		"GLBL_ID_PRG_SRNO",
    		"CHNL_CD",
    		"CHNL_DSCD",
    		"CLNT_IPAD",
    		"CLNT_MAC",
    		"ENV_INF_DSCD",
    		"FST_TMS_SYS_CD",
    		"LANG_DSCD",
    		"TMS_SYS_CD",
    		"MD_KDCD",
    		"INTF_ID",
    		"MCA_CHNL_SESS_ID",
    		"INTF_SYS_NODE_NO",
    		"REQ_SYS_CD",
    		"REQ_SYS_NODE_ID",
    		"TRN_SYN_DSCD",
    		"REQ_RSP_DSCD",
    		"TLM_REQ_DTM",
    		"TTL_USG_YN",
    		"FST_STA_TM",
    		"VLD_TIM",
    		"RSP_SYS_CD",
    		"TLM_RSP_DTM",
    		"RSP_RST_DSCD",
    		"MSG_OCC_SYS_CD",
    		"MSG_CD",
    		"LST_CHNL_TYCD",
    		"CHNL_TLM_CMNP_LEN",
    		"SPR",    		
    };
    private int[] iLen =   {8,4,1,32,32,4,3,3,39,12,1,3,2,3,8,12,25,5,3,3,1,1,17,1,6,3,3,17,1,3,10,3,4,127,};

    public sysHeader()
    {
        iTLen = 400;
        
    }

    public void setData(byte[] buff, int pos) throws pvException
    {
        int i   = 0;

        ALL_TLM_LEN            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        VER                    	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TLM_ENCY_DSCD          	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ORG_GLBL_ID            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        GLBL_ID                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        GLBL_ID_PRG_SRNO       	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CHNL_CD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CHNL_DSCD              	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CLNT_IPAD              	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CLNT_MAC               	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        ENV_INF_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        FST_TMS_SYS_CD         	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        LANG_DSCD              	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TMS_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MD_KDCD                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        INTF_ID                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MCA_CHNL_SESS_ID       	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        INTF_SYS_NODE_NO       	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        REQ_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        REQ_SYS_NODE_ID        	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TRN_SYN_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        REQ_RSP_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TLM_REQ_DTM            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TTL_USG_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        FST_STA_TM             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        VLD_TIM                	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RSP_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        TLM_RSP_DTM            	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        RSP_RST_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MSG_OCC_SYS_CD         	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        MSG_CD                 	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        LST_CHNL_TYCD          	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        CHNL_TLM_CMNP_LEN      	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;
        SPR                    	     = getStr (buff, pos, iLen[i], FieldNames[i]);  pos += iLen[i]; i++;                
    }
    // code: euc-kr, utf-8 ...
    public void setData(byte[] buff, int pos, String code) throws pvException
    {
        int i   = 0;

        ALL_TLM_LEN            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        VER                    	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_ENCY_DSCD          	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ORG_GLBL_ID            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        GLBL_ID                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        GLBL_ID_PRG_SRNO       	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CHNL_CD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CHNL_DSCD              	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CLNT_IPAD              	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CLNT_MAC               	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        ENV_INF_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FST_TMS_SYS_CD         	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        LANG_DSCD              	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TMS_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MD_KDCD                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INTF_ID                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MCA_CHNL_SESS_ID       	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        INTF_SYS_NODE_NO       	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        REQ_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        REQ_SYS_NODE_ID        	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TRN_SYN_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        REQ_RSP_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_REQ_DTM            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TTL_USG_YN             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        FST_STA_TM             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        VLD_TIM                	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RSP_SYS_CD             	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        TLM_RSP_DTM            	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        RSP_RST_DSCD           	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MSG_OCC_SYS_CD         	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        MSG_CD                 	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        LST_CHNL_TYCD          	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        CHNL_TLM_CMNP_LEN      	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;
        SPR                    	     = getStr (buff, pos, iLen[i], FieldNames[i], code);  pos += iLen[i]; i++;                
    }

    public void getData(byte[] buff, int pos) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, ALL_TLM_LEN                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, VER                          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_ENCY_DSCD                ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, ORG_GLBL_ID                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, GLBL_ID                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, GLBL_ID_PRG_SRNO             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_CD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_DSCD                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CLNT_IPAD                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CLNT_MAC                     ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, ENV_INF_DSCD                 ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, FST_TMS_SYS_CD               ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, LANG_DSCD                    ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TMS_SYS_CD                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MD_KDCD                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, INTF_ID                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MCA_CHNL_SESS_ID             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, INTF_SYS_NODE_NO             ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_SYS_CD                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_SYS_NODE_ID              ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_SYN_DSCD                 ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_RSP_DSCD                 ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_REQ_DTM                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TTL_USG_YN                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, FST_STA_TM                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, VLD_TIM                      ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RSP_SYS_CD                   ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_RSP_DTM                  ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, RSP_RST_DSCD                 ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_OCC_SYS_CD               ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_CD                       ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, LST_CHNL_TYCD                ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_TLM_CMNP_LEN            ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                          ,  iLen[i], FieldNames[i]); pos += iLen[i]; i++;           
    }
    
    // code: euc-kr, utf-8 ...
    public void getData(byte[] buff, int pos, String code) throws pvException
    {
        int i=0;
        
        objToArry(buff, pos, ALL_TLM_LEN               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, VER                       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_ENCY_DSCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ORG_GLBL_ID               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, GLBL_ID                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, GLBL_ID_PRG_SRNO          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_CD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_DSCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CLNT_IPAD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CLNT_MAC                  ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, ENV_INF_DSCD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FST_TMS_SYS_CD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, LANG_DSCD                 ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TMS_SYS_CD                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MD_KDCD                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INTF_ID                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MCA_CHNL_SESS_ID          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, INTF_SYS_NODE_NO          ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_SYS_CD                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_SYS_NODE_ID           ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TRN_SYN_DSCD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, REQ_RSP_DSCD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_REQ_DTM               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TTL_USG_YN                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, FST_STA_TM                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, VLD_TIM                   ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RSP_SYS_CD                ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, TLM_RSP_DTM               ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, RSP_RST_DSCD              ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_OCC_SYS_CD            ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, MSG_CD                    ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, LST_CHNL_TYCD             ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, CHNL_TLM_CMNP_LEN         ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;
        objToArry(buff, pos, SPR                       ,  iLen[i], FieldNames[i], code); pos += iLen[i]; i++;             
    }
    public void log(String name,String msg) {
    	sThread = msg+" ";
    	logname = name;
    	log();
    }
    public void log() {
    	int i=0;
    	pvUtil.msglog(ONCNF.LOGNAME, sThread+PGMID+" +------------------------------------------");
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.ALL_TLM_LEN        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ALL_TLM_LEN       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.VER                = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],VER               ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TLM_ENCY_DSCD      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TLM_ENCY_DSCD     ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.ORG_GLBL_ID        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ORG_GLBL_ID       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.GLBL_ID            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],GLBL_ID           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.GLBL_ID_PRG_SRNO   = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],GLBL_ID_PRG_SRNO  ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.CHNL_CD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CHNL_CD           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.CHNL_DSCD          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CHNL_DSCD         ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.CLNT_IPAD          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CLNT_IPAD         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.CLNT_MAC           = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CLNT_MAC          ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.ENV_INF_DSCD       = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],ENV_INF_DSCD      ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.FST_TMS_SYS_CD     = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],FST_TMS_SYS_CD    ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.LANG_DSCD          = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],LANG_DSCD         ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TMS_SYS_CD         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TMS_SYS_CD        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.MD_KDCD            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MD_KDCD           ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.INTF_ID            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],INTF_ID           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.MCA_CHNL_SESS_ID   = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MCA_CHNL_SESS_ID  ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.INTF_SYS_NODE_NO   = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],INTF_SYS_NODE_NO  ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.REQ_SYS_CD         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],REQ_SYS_CD        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.REQ_SYS_NODE_ID    = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],REQ_SYS_NODE_ID   ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TRN_SYN_DSCD       = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TRN_SYN_DSCD      ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.REQ_RSP_DSCD       = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],REQ_RSP_DSCD      ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TLM_REQ_DTM        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TLM_REQ_DTM       ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TTL_USG_YN         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TTL_USG_YN        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.FST_STA_TM         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],FST_STA_TM        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.VLD_TIM            = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],VLD_TIM           ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.RSP_SYS_CD         = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RSP_SYS_CD        ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.TLM_RSP_DTM        = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],TLM_RSP_DTM       ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.RSP_RST_DSCD       = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],RSP_RST_DSCD      ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.MSG_OCC_SYS_CD     = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MSG_OCC_SYS_CD    ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.MSG_CD             = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],MSG_CD            ) +"]"   ); 	
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.LST_CHNL_TYCD      = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],LST_CHNL_TYCD     ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.CHNL_TLM_CMNP_LEN  = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],CHNL_TLM_CMNP_LEN ) +"]"   );
        pvUtil.msglog(logname, sThread+PGMID+" + sysHeader.SPR                = ("+pvUtil.getNum(iLen[i],3)+")["+ pvUtil.getFormat(iLen[i++],SPR               ) +"]"   );            
        pvUtil.msglog(logname, sThread+PGMID+" +------------------------------------------");
    }
}