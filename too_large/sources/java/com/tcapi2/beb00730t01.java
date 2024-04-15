/* TOBE 2017-07-01 경상비-세금계산서조회 EAI */

package com.tcApi2;

import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.OutputStream;
import java.io.InputStream;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.SepoaDate;

import com.tcComm2.ONCNF;
import com.tcJun2.*;
import com.tcLib2.*;




@SuppressWarnings("unused")


//ASIS 2017-07-01 OT8601 => BEB00730T01 세금계산서조회
public class BEB00730T01 extends SepoaService implements I_Wms  { //TOBE 2017-07-01 추가 SepoaService 
	  
    public IF_BEB00730T01_S  SEND      =  null; 
    public IF_BEB00730T01_R  RECV      =  null;
    public IN_BEB00730T01_R  IN_LIST   =  null;
    public IF_OT0000E        eRECV     =  null;
    public Ex_BEB00730T01_R  ORECV     =  null;
    public eaiCom            eaiCom    =  null; //TOBE 2017-07-01 EAI 공통처리부
    public String    send_msg          = null;
    public String    pay_act_no        = null;

   
    public static String PGMID =  "BEB00730T01";
    
    
    byte[] s_data = new byte[TCP_BUFSIZE];   
    byte[] r_data = new byte[TCP_BUFSIZE];
    
   
    public BEB00730T01 () {    	
        this.SEND    = new IF_BEB00730T01_S();
        this.RECV    = new IF_BEB00730T01_R();
        this.ORECV   = new Ex_BEB00730T01_R();      
        this.eRECV   = new IF_OT0000E();
        this.IN_LIST = new IN_BEB00730T01_R();
        this.send_msg        = "";
        this.pay_act_no      = "";
        
    	
    	/* ASIS 2017-07-01 */
    	/*-----------------------------*/
    	/* Gateway Adaptor Header 정의   */
    	/*-----------------------------*/
    	/*
    	String gate_tot_size = String.format("%05d", SEND.sysHdr.iTLen+SEND.trnHdr.iTLen+SEND.iTLen);
    	String enabler_tot_size = String.format("%05d", SEND.trnHdr.iTLen+SEND.iTLen);		    	
    	//String enabler_tot_size = "03715";
     	SEND.sysHdr.TOT_SIZE   = gate_tot_size;
     	SEND.sysHdr.ADT_TYPE   = "4";          // TCP Adaptor   
     	SEND.sysHdr.SYS_ID     = "03080";      // ex)
     	SEND.sysHdr.DEST_HOST  = "01010";      // ex)
     	SEND.sysHdr.COMP_POS   = "1";          // 1:업무서버,2:GW(업무서버 Adaptor),3:GW(JCW),4:GW(HOST Adaptor), 5:HOST   
     	SEND.sysHdr.CTRL_FLAG  = "2";          // 1:업무서버에서 HOST와의 세션(LU) 연결 요청  
     	SEND.sysHdr.RET_CODE   = "00000000";
     	SEND.sysHdr.PROD_GB    = "T";          // P:운영데이타 , T:테스트데이타.
     	SEND.sysHdr.SNRV_GB    = "1";          // 1:SEND_RECV, 2:SEND_ONLY, 3:RECV_ONLY
     	SEND.sysHdr.RQRS_GB    = "1";          // 1:MOD_REQ, 2:MOD_RES, 3:MOD_ACK
     	SEND.sysHdr.EXT_SIZE   = "00000";      
		*/
		/*-----------------------------*/
    	/* Enabler I/O Header  정의    */
    	/*-----------------------------*/
    	/*
        SEND.trnHdr.HEAD_STA_TAG             = "<IH>";              //(4)  헤더선언부헤더                                                                                
        SEND.trnHdr.INLEN                    = enabler_tot_size;    //(5)  N전문전체길이-->헤더+전문길이                                                                      
        SEND.trnHdr.MDI_GRP_CD               = "90";                //(2)  C매체그룹코드-->'예)  0101WEB단말'                                                              
        SEND.trnHdr.MDIKD_SRNO               = "06";                //(2)  재산관리:8701->                                                                            
        SEND.trnHdr.UPCODE                   = "86";                //(2)  C거래업무코드거래업무코드(2)  +기능코드(2)  +화면일련번호(2)  ]                                              
        SEND.trnHdr.FC_CD                    = "73";                //(2)  일계:870100,가수가지:870200,지급결의:869100,환입결의:869200->                                        
        SEND.trnHdr.SC_SRNO                  = "00";                //(2)                                                                                         
        SEND.trnHdr.FKEY_CD                  = "00";                //(2)  C기능키코드실행-'00',조회-'20'...                                                               
        SEND.trnHdr.BK_CD                    = "20644";                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  )                                                
        SEND.trnHdr.BR_CD                    = "C";                //(1)  WooriDevice.dll에서단말번호가져옴->                                                             
        SEND.trnHdr.TRM_BNO                  = "003";                //(3)  PDA의단말번호는'20481'->                                                                     
        SEND.trnHdr.USER_TRM_NO              = "5";                //(1)  사용자단말번호                                                                                
        SEND.trnHdr.UID                      = "";                //(8)  PDA조작자번호 행번                                                                     
        SEND.trnHdr.TRN_SCRT_CD              = "IA73    ";//"13A0Y99 ";//IA73    ";    //(8)  거래보안코드                                                                                 
        SEND.trnHdr.LANG_DSCD                = "K";                //(1)  언어구분코드-->'K'한글,'E'영어                                                                   
        SEND.trnHdr.MOD_DSCD                 = "0";                //(1)  모드구분코드-->'0'당일,'1'마감후,'2'전일,'3'전일마감후                                                   
        SEND.trnHdr.AGNBR_RGS_YN             = "";                //(1)  대행점등록여부                                                                                
        SEND.trnHdr.PBNPB_YN                 = "";                //(1)  유무통여부                                                                                  
        SEND.trnHdr.ACT_BIOAUT_YN            = "";                //(1)  계좌생체인식여부                                                                               
        SEND.trnHdr.OPR_BIOAUT_YN            = "";                //(1)  조작자생체인식여부                                                                              
        SEND.trnHdr.MGR_BIOAUT_YN            = "N";                //(1)  책임자생체인식여부                                                                              
        SEND.trnHdr.CAN_TRN_YN               = "N";                //(1)  취소거래여부                                                                                 
        SEND.trnHdr.EDBR_RGS_YN              = "";                //(1)  연수점등록여부                                                                                
        SEND.trnHdr.VIR_TMS_YN               = "";                //(1)  가상전송여부                                                                                 
        SEND.trnHdr.FILLER01                 = "";                //(1)  예비                                                                                     
        SEND.trnHdr.FILLER02                 = "";                //(1)  예비                                                                                     
        SEND.trnHdr.NXT_TRN_YN               = "N";                //(1)  다음거래여부-->'N'다음Transaction없음,'Y'다음Transaction으로이동                                       
        SEND.trnHdr.NXT_TRNO                 = "";                //(6)  다음거래번호(거래업무코드(2)  +기능코드(2)  +화면일련번호(2)  )                                              
        SEND.trnHdr.MGRAPV_DSCD              = "1";                //(1)  책임자승인구분코드-->'1'표준(책임자승인거래아님)  ,'2'항시승인,'3'조건부승인                                        
        SEND.trnHdr.MSG_TPCD                 = "1";                //(1)  메시지유형코드-->'1'일반입력방식,'2'책임자승인요구(조건부승인)                                                  
        SEND.trnHdr.TRM_RTN_SQNO             = "";                //(5)  단말거래순번-->00001~99999(단말별)                                                              
        SEND.trnHdr.TBA_NO                   = "00";                //(2)  TAB번호                                                                                  
        SEND.trnHdr.SCRN_CTL_YN              = "1";                //(1)  화면제어여부-->'1'기존화면유지,'9'기존화면clear                                                        
        SEND.trnHdr.MAS_INOPT_DSCD           = "0";                //(1)  대량입출력구분코드-->'0'표준(대량입력거래아님)  ,'M'대량입력,대량출력,'E'대량입출력마지막전송DATA                           
        SEND.trnHdr.MAS_INOPT_SQNO           = "";                //(4)  대량입출력순번-->0001~9999                                                                    
        SEND.trnHdr.MOV_ACNO                 = "";                //(20)  기동계좌번호-->기동계좌인경우만set                                                                  
        SEND.trnHdr.SVR_LU_NO                = "";                //(8)  서버LU번호-->단말서버LUNumber                                                                  
        SEND.trnHdr.SBBR_CD                  = "";                //(5)  대체점코드-->대행점,연수점등록시대체점코드                                                                
        SEND.trnHdr.PRC_TPCD                 = "O";                //(1)  처리유형코드-->'O'온라인,'F'오프라인                                                                
        SEND.trnHdr.NML_CMPL_YN              = "N";                //(1)  정상완료여부-->'Y'정상commit,'N'Doesn'tmanagecommit(현재미사용)                                     
        SEND.trnHdr.ORGTR_NO                 = "";                //(6)  원거래번호-->타시스템발생거래시원거래번호                                                                 
        SEND.trnHdr.SYS_ID_NO                = "";                //(4)  CICSSYSID-->'0304'                                                                     
        SEND.trnHdr.SYS_SRNO                 = "";                //(10)  시스템일련번호                                                                               
        SEND.trnHdr.ERRCODE                  = "0000000";                //(7)  오류코드                                                                                   
        SEND.trnHdr.PBOK_ISU_SRNO            = "";                //(3)  통장발생일련번호                                                                               
        SEND.trnHdr.LU0_YN                   = "N";                //(1)  입력매체LU0사용여부                                                                            
        SEND.trnHdr.TGT_MDI_KDCD             = "";                //(4)  Deliverychannel역할                                                                      
        SEND.trnHdr.OBK_CD                   = "";                //(2)  기동계좌가타은행계좌일경우                                                                          
        SEND.trnHdr.FILLER                   = "";                //(42)  FILLER                                                                                
        SEND.trnHdr.HEAD_END_TAG             = "</IH>";           // (5) *헤더부종료태그
        */
        
        

        //TOBE 2017-07-01 공통처리부
        this.eaiCom = new eaiCom();
        
        /*----------------------------------------------------*/
    	/* EAI Header 전문 필드 정의 - 1.SH.시스템헤더부(SIZE:400) */
        /*----------------------------------------------------*/
    	String gate_tot_size = String.format("%08d", SEND.sysHdr.iTLen+SEND.trnHdr.iTLen+SEND.iTLen + 2 -8); // 전문전체길이+(종료'@@') -8		    	

    	SEND.sysHdr.ALL_TLM_LEN            	     =  gate_tot_size            ;   //(숫자	8         )  전체전문길이             
    	SEND.sysHdr.VER                    	     =  eaiCom.VER               ;   //(문자	4         )  버전                     
    	SEND.sysHdr.TLM_ENCY_DSCD          	     =  eaiCom.TLM_ENCY_DSCD     ;   //(문자	1         )  전문암호화구분코드       
    	SEND.sysHdr.ORG_GLBL_ID            	     =  eaiCom.ORG_GLBL_ID       ;   //(문자/숫자 조합	32)  원글로벌ID
    	SEND.sysHdr.GLBL_ID                	     =  eaiCom.GLBL_ID           ;   //(문자/숫자 조합	32)  글로벌ID
    	SEND.sysHdr.GLBL_ID_PRG_SRNO       	     =  eaiCom.GLBL_ID_PRG_SRNO  ;   //(숫자	4         )  글로벌ID 진행일련번호    
    	SEND.sysHdr.CHNL_CD                	     =  eaiCom.CHNL_CD           ;   //(문자	3         )  채널코드                 
    	SEND.sysHdr.CHNL_DSCD              	     =  eaiCom.CHNL_DSCD         ;   //(문자	3         )  채널구분코드             
    	SEND.sysHdr.CLNT_IPAD              	     =  eaiCom.CLNT_IPAD         ;   //(문자	39        )  클라이언트IP주소         
    	SEND.sysHdr.CLNT_MAC               	     =  eaiCom.CLNT_MAC          ;   //(문자	12        )  클라이언트MAC            
    	SEND.sysHdr.ENV_INF_DSCD           	     =  eaiCom.ENV_INF_DSCD      ;   //(문자	1         )  환경정보구분코드         
    	SEND.sysHdr.FST_TMS_SYS_CD         	     =  eaiCom.FST_TMS_SYS_CD    ;   //(문자	3         )  최초전송시스템코드       
    	SEND.sysHdr.LANG_DSCD              	     =  eaiCom.LANG_DSCD         ;   //(문자	2         )  언어구분코드             
    	SEND.sysHdr.TMS_SYS_CD             	     =  eaiCom.TMS_SYS_CD        ;   //(문자	3         )  전송시스템코드           
    	SEND.sysHdr.MD_KDCD                	     =  eaiCom.MD_KDCD           ;   //(문자	8         )  매체종류코드             
    	SEND.sysHdr.INTF_ID                	     =  "EPSER0000016"           ;   //(문자	12        )  인터페이스 ID            
    	SEND.sysHdr.MCA_CHNL_SESS_ID       	     =  eaiCom.MCA_CHNL_SESS_ID  ;   //(문자	25        )  MCA 채널세션 ID          
    	SEND.sysHdr.INTF_SYS_NODE_NO       	     =  eaiCom.INTF_SYS_NODE_NO  ;   //(문자	5         )  인터페이스시스템 노드번호
    	SEND.sysHdr.REQ_SYS_CD             	     =  eaiCom.REQ_SYS_CD        ;   //(문자	3         )  요청시스템코드           
    	SEND.sysHdr.REQ_SYS_NODE_ID        	     =  eaiCom.REQ_SYS_NODE_ID   ;   //(문자	3         )  요청시스템노드ID         
    	SEND.sysHdr.TRN_SYN_DSCD           	     =  eaiCom.TRN_SYN_DSCD      ;   //(문자	1         )  거래동기화구분코드       
    	SEND.sysHdr.REQ_RSP_DSCD           	     =  eaiCom.REQ_RSP_DSCD      ;   //(문자	1         )  요청응답구분코드         
    	SEND.sysHdr.TLM_REQ_DTM            	     =  eaiCom.TLM_REQ_DTM       ;   //(문자	17        )  전문요청일시             
    	SEND.sysHdr.TTL_USG_YN             	     =  eaiCom.TTL_USG_YN        ;   //(문자	1         )  TTL사용여부              
    	SEND.sysHdr.FST_STA_TM             	     =  eaiCom.FST_STA_TM        ;   //(문자	6         )  최초시작시각             
    	SEND.sysHdr.VLD_TIM                	     =  eaiCom.VLD_TIM           ;   //(숫자	3         )  유효시간                 
    	SEND.sysHdr.RSP_SYS_CD             	     =  eaiCom.RSP_SYS_CD        ;   //(문자	3         )  응답시스템코드           
    	SEND.sysHdr.TLM_RSP_DTM            	     =  eaiCom.TLM_RSP_DTM       ;   //(문자	17        )  전문응답일시             
    	SEND.sysHdr.RSP_RST_DSCD           	     =  eaiCom.RSP_RST_DSCD      ;   //(문자	1         )  응답결과구분코드         
    	SEND.sysHdr.MSG_OCC_SYS_CD         	     =  eaiCom.MSG_OCC_SYS_CD    ;   //(문자	3         )  메시지발생시스템코드     
    	SEND.sysHdr.MSG_CD                 	     =  eaiCom.MSG_CD            ;   //(문자	10        )  메시지코드               
    	SEND.sysHdr.LST_CHNL_TYCD          	     =  eaiCom.LST_CHNL_TYCD     ;   //(문자	3         )  최종채널유형코드         
    	SEND.sysHdr.CHNL_TLM_CMNP_LEN      	     =  eaiCom.CHNL_TLM_CMNP_LEN ;   //(숫자	4         )  채널전문공통부 길이      
    	SEND.sysHdr.SPR                    	     =  eaiCom.SPR               ;   //(문자	127       )  예비                     

        
        
        /*--------------------------------------------------*/
    	/* EAI Header 전문 필드 정의 - 2.TH.거래헤더부(SIZE:300) */
        /*--------------------------------------------------*/
        
    	SEND.trnHdr.TRM_BRNO               =  "";                      //(문자	6   )  단말점번호                 
    	SEND.trnHdr.TRN_TRM_NO             =  "";                      //(문자	12  )  거래단말번호               
    	SEND.trnHdr.DL_BRCD                =  "";                      //(문자	6   )  취급점코드                 
    	SEND.trnHdr.OPR_NO                 =  "";                      //(문자	8   )  조작자번호                 
    	SEND.trnHdr.RLPE_APV_DSCD          =  "N";                     //(문자	1   )  책임자 승인 구분코드       
    	SEND.trnHdr.AVLPE_RSP_RTCD         =  "N";                     //(문자	1   )  승인자 응답 결과코드       
    	SEND.trnHdr.RLPE_APV_SQCN          =  "";                      //(문자	1   )  책임자 승인 차수           
    	SEND.trnHdr.SCRN_ID                =  "";                      //(문자	11  )  화면ID                     
    	SEND.trnHdr.TRN_SCRN_NO            =  "";                      //(문자	5   )  거래화면번호               
    	SEND.trnHdr.TRN_CD                 =  "BEB00730T";             //(문자	9   )  거래코드                   
    	SEND.trnHdr.SRVC_ID                =  "BEB00730T01";           //(문자	11  )  서비스ID                   
    	SEND.trnHdr.FUNC_CD                =  "20";                    //(문자	2   )  기능 코드  (20:조회,30:등록)               
    	SEND.trnHdr.CAN_TRN_DSCD           =  "N";                     //(문자	1   )  취소거래구분코드           
    	SEND.trnHdr.INP_TLM_TYCD           =  "N";                     //(문자	1   )  입력전문유형코드           
    	SEND.trnHdr.OUP_TLM_TYCD           =  "N";                     //(문자	1   )  출력전문유형코드           
    	SEND.trnHdr.LQTY_DAT_PRC_DIS       =  "";                      //(문자	1   )  대량데이터처리구분         
    	SEND.trnHdr.TLM_CTIN_SRNO          =  "0000";                  //(숫자	4   )  전문연속일련번호           
    	SEND.trnHdr.LQTY_INP_CTIN_YN       =  "N";                     //(문자	1   )  대량입력연속여부           
    	SEND.trnHdr.NXT_PAGE_RQU_YN        =  "N";                     //(문자	1   )  다음페이지요구여부         
    	SEND.trnHdr.SMLT_TRN_DSCD          =  "N";                     //(문자	1   )  시뮬레이션거래구분코드     
    	SEND.trnHdr.ACC_MOD_DSCD           =  "0";                     //(문자	1   )  계정모드구분코드           
    	SEND.trnHdr.DL_OPNG_DSCD           =  "D";                     //(문자	1   )  취급개설구분코드           
    	SEND.trnHdr.TRN_LOG_KEY_VAL        =  "";                      //(문자	56  )  거래로그키값               
    	SEND.trnHdr.CC_ONL_STCD            =  "";                      //(문자	1   )  센터컷 온라인 상태 코드    
    	SEND.trnHdr.DL_RSP_INP_RCOVR_DSCD  =  "";                      //(문자	1   )  취급응답입력복원구분코드   
    	SEND.trnHdr.FROT_RSP_OUP_WAIT_STCD =  "N";                     //(문자	1   )  대외응답 출력대기 상태 코드
    	SEND.trnHdr.TRF_NACRD_YN           =  "";                      //(문자	1   )  대체 불일치 여부           
    	SEND.trnHdr.RST_RECP_TRN_CD        =  "";                      //(문자	9   )  결과수신거래코드           
    	SEND.trnHdr.RST_RECP_SRVC_ID       =  "";                      //(문자	11  )  결과수신서비스ID           
    	SEND.trnHdr.EXNK_DSCD              =  "N";                     //(문자	1   )  유무통 구분코드            
    	SEND.trnHdr.PBOK_SRNO              =  "";                      //(문자	4   )  통장 일련번호              
    	SEND.trnHdr.MSK_NTGT_TRN_YN        =  "";                      //(문자	1   )  마스킹비대상거래여부       
    	SEND.trnHdr.RLY_TRN_DSCG_YN        =  "";                      //(문자	1   )  중계거래복호화여부         
    	SEND.trnHdr.SPR                    =  "";                      //(문자	127 )  예비    
        
    }
     
    
    
    
	@SuppressWarnings("unchecked")
	public	int sendMessage(String EventCode, String servAddress, int servPort ) {
		
		if("BEB00730T01".equals(EventCode)) {
					
			pvUtil.msglog(ONCNF.LOGNAME," +----------------------------------------+");
			pvUtil.msglog(ONCNF.LOGNAME," + setMessage() : EventCode ("+EventCode +")   +");
			pvUtil.msglog(ONCNF.LOGNAME," +----------------------------------------+");
					
		    try {
			    	/*----------------------------------------*/
			    	/* String Data to Byte Data conversion    */
			    	/*----------------------------------------*/
		    		SEND.get(s_data,"EUC-KR");				    
		    }
		    catch (pvException ne) {

		    		//ne.printStackTrace();
		    	pvUtil.msglog(ONCNF.LOGNAME," :0100: DATA FORMAT ERROR !!.." +ne.toString());
		    		return(ONCNF.D_EFORMAT);		    
		    }
		    /*------------------------------*/
		    /* send to WOORI BANK Gateway   */
 		    /*------------------------------*/
		    Socket socket = null;  InputStream in = null; OutputStream out = null;

			try {  
					/*-----------------------
					 *  TCP Connect 
					 *----------------------*/
				    socket = new Socket(servAddress, servPort);					    
				    socket.setSoTimeout(1000*90); //TOBE 2017-07-01  15 -> 90  
				    /* TCP DATA SEND */
				    			   				    
				    out = socket.getOutputStream();
				    in = socket.getInputStream();
				    int slen = SEND.sysHdr.iTLen + SEND.trnHdr.iTLen + SEND.iTLen;
				    
				    
				    /////// SEND DATA 보기 //////////////

				    try {
						SEND.set(s_data, s_data.length,"EUC-KR");
					} catch (pvException e2) {
						//e2.printStackTrace();
						pvUtil.msglog(ONCNF.LOGNAME," :EUC-KR: Exception : "+e2.getMessage());
					}
					
				    SEND.sysHdr.log(ONCNF.LOGNAME, "S");
				    SEND.trnHdr.log(ONCNF.LOGNAME, "S");
				    SEND.log(ONCNF.LOGNAME, "S");
				    
				    
				    //TOBE 2017-07-01 종료부 : 마지막에 '@@' 붙이기 
				    ByteArrayOutputStream f1 = new ByteArrayOutputStream(); 
				    f1.write(s_data,0,slen);
				    String s1 = f1.toString()+"@@";
				    s_data = s1.getBytes();
				    slen = s1.getBytes().length;
				    
				    pvUtil.msglog(ONCNF.LOGNAME,"send data : [" + new String(s_data)+"");
				    
				    out.write(s_data,0,slen);    
				    out.flush();
				    
				    /*----------------------------
				     * TCP Object receive Open		
				     *----------------------------*/				    
				    pvUtil.msglog(ONCNF.LOGNAME," +---------------------------------");
				    pvUtil.msglog(ONCNF.LOGNAME," + TCP SEND OK !!..rlen="+slen +" (GW --> BANK)   ");
				    pvUtil.msglog(ONCNF.LOGNAME," +---------------------------------");								    
				    
				    //ASIS 2017-07-01 int Hdr_size = RECV.sysHdr.iTLen + RECV.trnHdr.iTLen + RECV.iTLen;
				    //TOBE 2017-07-01
				    int Hdr_size = RECV.sysHdr.iTLen + RECV.trnHdr.iTLen + RECV.msgHdr.iTLen + RECV.iTLen
				    		;
				    int jAddCount=0;
				    int totListCount = 0;
				    ORECV.list_beb00730t01_r = new ArrayList<LIST_BEB00730T01_R>();  /// 
				    ///////////////////////
				    //// 연속전문 처리 ////
				    ///////////////////////
				    while(true) {
					    	pvUtil.msglog(ONCNF.LOGNAME," +----------------------------------------");
					    	pvUtil.msglog(ONCNF.LOGNAME," + TCP RECV (GW <-- woori)   ");
					    	pvUtil.msglog(ONCNF.LOGNAME," +----------------------------------------");
					    	
					    	pvUtil.msglog(ONCNF.LOGNAME," + Socket Recv Ready ... ");
				    		int	rcvSize = in.read(r_data,0,Hdr_size);				    						    	
						    
						    if(rcvSize != -1) {								    	
						    		///////////////////////////////
						    		int JunSize = 0;
						    		try {
								    	//TOBE 2017-07-01 추가 전문 로그
								    	send_msg =  s1;
								    	Map<String, String> param     = new HashMap<String, String>();
										param.put("IF_NAME", "BEB00730T01"); 
										param.put("SEND_NO", pay_act_no); 
										param.put("CONTS", send_msg);
										
										Object[] obj = { param };
										SepoaOut value = ServiceConnector.doService(info, "IF_001", "CONNECTION", "insert_if_msg", obj);

										//ASIS 2017-07-01 RECV.set(r_data, r_data.length,"EUC-KR");
						    			//TOBE 2017-07-01
						    			RECV.setR(r_data, r_data.length,"EUC-KR");
						    			
										JunSize = Integer.parseInt(RECV.sysHdr.ALL_TLM_LEN);
									} catch (pvException e1) {
										//e1.printStackTrace();
										pvUtil.msglog(ONCNF.LOGNAME," + :0100: pvException !!.. "+e1 );
									}
						    		pvUtil.msglog(ONCNF.LOGNAME," RECV.sysHdr.TOT_SIZE = "+JunSize);
						    		//////////////////////////////////
									if(rcvSize < JunSize) {
											pvUtil.msglog(ONCNF.LOGNAME," + Socket.recvSize = "+rcvSize +"/"+ JunSize+"");
											int rSize = pvUtil.Socket_AddRecv2(in, r_data, rcvSize, JunSize);
											rcvSize = rSize;
											pvUtil.msglog(ONCNF.LOGNAME," + Socket_AddRecv.rSize = "+rSize +", JUN.SIZE = "+ JunSize+"");
									}				    	  			    	  
						    	    ///////////////////////// 															
								    try {
								    	/* RESPONSE DATA LOGING */
								    	pvUtil.msglog(ONCNF.LOGNAME," + RECV DATA rlen="+rcvSize +" JunSize="+JunSize);
								    	//ASIS 2017-07-01 RECV.set(r_data, r_data.length,"EUC-KR");
								    	//TOBE 2017-07-01
						    			RECV.setR(r_data, r_data.length,"EUC-KR");
								    	RECV.sysHdr.log(ONCNF.LOGNAME, "R");
								    	RECV.trnHdr.log(ONCNF.LOGNAME, "R");
								    	RECV.msgHdr.log(ONCNF.LOGNAME, "R");
								    	RECV.log(ONCNF.LOGNAME, "R");
								    	
								    	
								    	///// Enabler 
								    	int iListCount = 0;
								    	
								    	
								    	//ASIS 2017-07-01  if(!"".equals(RECV.trnHdr.ERRCODE.trim())								    	  ){
								    	//TOBE 2017-07-01
								    	if(!"N".equals(RECV.sysHdr.RSP_RST_DSCD.trim()) ){

								    		//ASIS 2017-07-01 eRECV.set(r_data, r_data.length,"EUC-KR");
								    		//TOBE 2017-07-01
								    		eRECV.setR(r_data, r_data.length,"EUC-KR");
								    		
								    		eRECV.log(ONCNF.LOGNAME, "R");

									    	/// GATEWAY --> API 
								    		ORECV.R_CODE    = eRECV.sysHdr.RSP_RST_DSCD;
									    	ORECV.E_MESSAGE = eRECV.START_FLAG+eRECV.ERR_CODE+eRECV.MESSAGE+eRECV.MESSAGE2+eRECV.TRAN_GBN+eRECV.END_FLAG;
									    	pvUtil.msglog(ONCNF.LOGNAME, " : #### DATA RECV ERROR !!..");
									    	break;
								    	}
								    	else {
									    	iListCount = Integer.parseInt(RECV.GRID_ROW_CNT); ///
									    	totListCount = totListCount+iListCount;
					    	
								    	}
		
								    	pvUtil.msglog(ONCNF.LOGNAME," list Count = "+iListCount+", totListCount="+totListCount);
								        try {
								        	/* ASIS 2017-07-01
							        		int jHeader = RECV.sysHdr.iTLen + RECV.trnHdr.iTLen + RECV.iTLen;
							        		int hsize = RECV.sysHdr.iTLen+RECV.trnHdr.iTLen+RECV.iTLen;
							        		pvUtil.msglog(ONCNF.LOGNAME," sysHdr.iTlen="+RECV.sysHdr.iTLen + ", trnHdr.iTlen="+RECV.trnHdr.iTLen + ", RECV.iTlen="+RECV.iTLen +", totsize="+ hsize );
							        		*/
								        	
								        	/* TOBE 2017-07-01 */
							        		int jHeader = RECV.sysHdr.iTLen + RECV.trnHdr.iTLen + RECV.msgHdr.iTLen + RECV.iTLen;
							        		int hsize   = RECV.sysHdr.iTLen + RECV.trnHdr.iTLen + RECV.msgHdr.iTLen + RECV.iTLen;
							        		pvUtil.msglog(ONCNF.LOGNAME," sysHdr.iTlen="+RECV.sysHdr.iTLen + ", trnHdr.iTlen="+RECV.trnHdr.iTLen + " msgHdr.iTlen="+RECV.msgHdr.iTLen + ", RECV.iTlen="+RECV.iTLen +", totsize="+ hsize );
							        		
							        		for(int i = 0; i <  iListCount; i++){
									        		
										  	    	IN_LIST.setData(r_data, jHeader + i * IN_LIST.iTLen, ONCNF.BNK_LANG_CODE);
										  	    	
										  	    											  	    											  	   										  	 
										  	    	IN_LIST.log(ONCNF.LOGNAME, i, "R..");							        	
									        	
										    	    LIST_BEB00730T01_R jun = new LIST_BEB00730T01_R();
		                                            
										    	    /* ASIS 2017-07-01 
										    	    jun.INQ_SRNO     = IN_LIST.INQ_SRNO              ;
										    	    jun.TAA_APV_NO   = IN_LIST.TAA_APV_NO            ;
										    	    jun.ISU_DT       = IN_LIST.ISU_DT                ;
										    	    jun.RGS_BRCD     = IN_LIST.RGS_BRCD              ;
										    	    jun.RGS_DT       = IN_LIST.RGS_DT                ;
										    	    jun.RGS_SRNO     = IN_LIST.RGS_SRNO              ;
										            jun.EXE_AM       = IN_LIST.EXE_AM                ;      
										            jun.SPL_AM       = IN_LIST.SPL_AM                ;        
										            jun.TAX_AM       = IN_LIST.TAX_AM                ;          
										            jun.PAY_RSN      = IN_LIST.PAY_RSN               ; 
										    	    jun.RGS_DSCD     = IN_LIST.RGS_DSCD              ;
										    	    */
										    	    
										    	    /* TOBE 2017-07-01 */
										    	    jun.INQ_NO          = IN_LIST.INQ_NO            ;  //1.  N5      조회번호                  
										    	    jun.NTS_BILL_APV_NO = IN_LIST.NTS_BILL_APV_NO   ;  //2.  S24     국세청계산서승인번호      
										    	    jun.BGT_BRCD        = IN_LIST.BGT_BRCD          ;  //3.  S6      예산점코드                
										    	    jun.EVDCD_ISSU_DT   = IN_LIST.EVDCD_ISSU_DT     ;  //4.  S8      증빙서발행일자            
										    	    jun.TXBIL_RGS_DT    = IN_LIST.TXBIL_RGS_DT      ;  //5.  S8      (세금)계산서등록일자      
										    	    jun.TXBIL_RGS_SRNO  = IN_LIST.TXBIL_RGS_SRNO    ;  //6.  N5      (세금)계산서등록일련번호  
										            jun.BGT_EXU_AM      = IN_LIST.BGT_EXU_AM        ;  //7.  D19     예산집행금액                  
										            jun.SPL_AM          = IN_LIST.SPL_AM            ;  //8.  D19     공급금액                        
										            jun.EVDCD_TAXM      = IN_LIST.EVDCD_TAXM        ;  //9.  D19     증빙서세액                        
										            jun.EVDCD_DAT_DSCD  = IN_LIST.EVDCD_DAT_DSCD    ;  //10. S1      증빙서데이터구분코드      
										    	    jun.XPN_PAY_RSN_TXT = IN_LIST.XPN_PAY_RSN_TXT   ;  //11. S100    지경비지급사유내용 
										    	    
										    	    ORECV.list_beb00730t01_r.add(jun);	
										    	    jAddCount++;
									        }
									        pvUtil.msglog(ONCNF.LOGNAME, "debug268:"+ORECV.list_beb00730t01_r.size());
								        }
								        catch (Exception e) {        	
//								        	e.printStackTrace();
								        	pvUtil.msglog(ONCNF.LOGNAME," :0200: Exception : "+e.getMessage());
								        }						
								        
								        //TOBE 2017-07-01
								        pvUtil.msglog(ONCNF.LOGNAME,"recv data : [" + new String(r_data)+"");
								        
								        pvUtil.msglog(ONCNF.LOGNAME," +-------------------------------------");
								        pvUtil.msglog(ONCNF.LOGNAME," +  Tcp Response OK !!.. rlen="+rcvSize );
								        pvUtil.msglog(ONCNF.LOGNAME," +-------------------------------------");				    			
									} catch (pvException e) {
										//e.printStackTrace();
										pvUtil.msglog(ONCNF.LOGNAME," :0100: DATA FORMAT ERROR !!.." +e);
										return(ONCNF.D_ERR);
									}
						    }
						    else {
						    	pvUtil.msglog(ONCNF.LOGNAME," +-------------------------------------");
						    	pvUtil.msglog(ONCNF.LOGNAME," +  Tcp Response ERROR !!..rlen=" +rcvSize );
						    	pvUtil.msglog(ONCNF.LOGNAME," +-------------------------------------");
						    	return(ONCNF.D_ERR);
						    }		
						    ///////////////////////////////
						    ////  연속데이타가 있을경우 ...
						    ///////////////////////////////
						    if(RECV.NXT_PAGE_EXST_YN.equals("Y")) {
						    	
						    	pvUtil.msglog(ONCNF.LOGNAME,"jAddCount = "+jAddCount+" RECV.NXT_PAGE_EXST_YN = "+RECV.NXT_PAGE_EXST_YN + "  RECV.GRID_ROW_CNT = "+RECV.GRID_ROW_CNT);
						    	
						    	pvUtil.msglog(ONCNF.LOGNAME, "totListCount+1 ="+(totListCount+1));
						    	
						    	SEND.INQ_STA_NO = String.format("%05d",totListCount+1);
						    	SEND.INQ_END_NO = String.format("%05d",totListCount+100);
						    	
						    	pvUtil.msglog(ONCNF.LOGNAME,"SEND.INQ_STA_NO : "+ SEND.INQ_STA_NO);
						    	pvUtil.msglog(ONCNF.LOGNAME,"SEND.INQ_STA_NO : "+ SEND.INQ_END_NO);
						    	
							    try {
							    	
							    	SEND.get(s_data,"EUC-KR");
								} catch (pvException e2) {
									//e2.printStackTrace();
									pvUtil.msglog(ONCNF.LOGNAME," :EUC-KR: Exception : "+e2.getMessage());
								}						    	
							    try {
							    	
									SEND.set(s_data, s_data.length,"EUC-KR");
								} catch (pvException e2) {
									//e2.printStackTrace();
									pvUtil.msglog(ONCNF.LOGNAME," :EUC-KR: Exception : "+e2.getMessage());
								}
							    SEND.sysHdr.log(ONCNF.LOGNAME, "S");
							    SEND.trnHdr.log(ONCNF.LOGNAME, "S");
							    SEND.log(ONCNF.LOGNAME, "S");
							    
							    
							    //TOBE 2017-07-01 종료부 : 마지막에 '@@' 붙이기 
							    ByteArrayOutputStream f2 = new ByteArrayOutputStream(); 
							    f2.write(s_data,0,slen);
							    String s2 = f2.toString()+"@@";
							    s_data = s2.getBytes();
							    slen = s2.getBytes().length;

							    //// 연속데이터 요청 전문 송신 ////
							    out.write(s_data,0,slen);     
							    out.flush();
							    /*----------------------------
							     * TCP Object receive Open		
							     *----------------------------*/				    					   
							    pvUtil.msglog(ONCNF.LOGNAME," +---------------------------------");
							    pvUtil.msglog(ONCNF.LOGNAME," + TCP SEND OK !!..rlen="+slen +" (GW --> woori)   ");
							    pvUtil.msglog(ONCNF.LOGNAME," +---------------------------------");								    
							    						    							    
						    }
						    else {
						    	pvUtil.msglog(ONCNF.LOGNAME,"jAddCount = "+jAddCount+" RECV.NXT_PAGE_EXST_YN = "+RECV.NXT_PAGE_EXST_YN + "  RECV.GRID_ROW_CNT = "+RECV.GRID_ROW_CNT);
						    	ORECV.R_CODE = "0000000";
						    	ORECV.R_COUNT = String.format("%04d",jAddCount);
						    	break;
						    }
				    }
				    //// END OF WHILE ////
				    
			} catch (IOException e) {
					//
					pvUtil.msglog(ONCNF.LOGNAME," :0300: IOException !!.. " + e);
					return(ONCNF.D_ENETWORK);
			}	
			finally {
				try {
					if(in != null){ in.close(); } if(out != null){ out.close(); } if(socket != null && !socket.isClosed()){ socket.close(); }
				} catch (IOException e) {
					//e.printStackTrace();
					pvUtil.msglog(ONCNF.LOGNAME," :0500: IOException !!.. " + e);
				}	
			}
			return(ONCNF.D_OK);
		}
		else{ 
			return(ONCNF.D_ERR);		
		}
	}

		
}