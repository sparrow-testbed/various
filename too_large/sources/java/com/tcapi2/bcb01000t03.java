/* TOBE 2017-07-01 자본예산 계좌유효성 및 계좌이체 EAI */

package com.tcApi2;

import java.io.*;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;

import sepoa.fw.db.ConnectionContext;
import sepoa.fw.db.ParamSql;
import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.SepoaService;
import sepoa.fw.srv.ServiceConnector;

import com.tcJun2.IF_BCB01000T03_S;
import com.tcJun2.IF_BCB01000T03_R;
import com.tcJun2.eaiCom;
import com.tcComm2.ONCNF;
import com.tcJun2.IF_OT0000E;
import com.tcLib2.I_Wms;
import com.tcLib2.pvException;
import com.tcLib2.pvUtil;



public class BCB01000T03 extends SepoaService implements I_Wms {

	public IF_BCB01000T03_S    SEND      = null;
    public IF_BCB01000T03_R    RECV      = null;
    public IF_OT0000E          eRECV     = null;
    public static String       PGMID     = null;
    public eaiCom              eaiCom    = null; //TOBE 2017-07-01 EAI 공통처리부
    
    byte[] s_data = new byte[TCP_BUFSIZE];   
    byte[] r_data = new byte[TCP_BUFSIZE];
    
    public String    send_msg      = null;
    public String    pay_send_no     = null;
    
    public BCB01000T03 () {    	
        this.SEND     = new IF_BCB01000T03_S();
        this.RECV     = new IF_BCB01000T03_R();
        this.eRECV    = new IF_OT0000E();
        PGMID = "BCB01000T03";
        this.send_msg        = "";
        this.pay_send_no        = "";
        
        
		

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
    	SEND.sysHdr.INTF_ID                	     =  "EPSER0000020"           ;   //(문자	12        )  인터페이스 ID            
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
    	SEND.trnHdr.TRN_CD                 =  "BCB04000T";             //(문자	9   )  거래코드                   
    	SEND.trnHdr.SRVC_ID                =  "BCB04000T03";           //(문자	11  )  서비스ID                   
    	SEND.trnHdr.FUNC_CD                =  "00";                    //(문자	2   )  기능 코드  (00:실행,20:조회,30:등록)                
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
    
    
	@Override
	public int sendMessage(String EventCode, String servAddress, int servPort){
		int rtn = 0;
		if(EventCode.equals("BCB01000T03")) {
			ConnectionContext         ctx      = null;
//			System.out.println(pvUtil.logTime()+PGMID+" +----------------------------------------+");
//			System.out.println(pvUtil.logTime()+PGMID+" + setMessage() : EventCode ("+EventCode +")   +");
//			System.out.println(pvUtil.logTime()+PGMID+" +----------------------------------------+");

			
			
			/* ASIS 2017-07-01
			SEND.comHdr.SYS_ID = "03080";
			//SEND.bizHdr.MDI_GRP_CD = "87";
			//SEND.bizHdr.MDIKD_SRNO = "01";
			
	     	SEND.comHdr.ADT_TYPE   = "4";          // TCP Adaptor   
	     	SEND.comHdr.SYS_ID     = "03080";      // ex)
	     	SEND.comHdr.DEST_HOST  = "01010";      // ex)
	     	SEND.comHdr.COMP_POS   = "1";          // 1:업무서버,2:GW(업무서버 Adaptor),3:GW(JCW),4:GW(HOST Adaptor), 5:HOST   
	     	SEND.comHdr.CTRL_FLAG  = "2";          // 1:업무서버에서 HOST와의 세션(LU) 연결 요청  
	     	SEND.comHdr.RET_CODE   = "00000000";
	     	SEND.comHdr.PROD_GB    = "T";          // P:운영데이타 , T:테스트데이타.
	     	SEND.comHdr.SNRV_GB    = "1";          // 1:SEND_RECV, 2:SEND_ONLY, 3:RECV_ONLY
	     	SEND.comHdr.RQRS_GB    = "1";          // 1:MOD_REQ, 2:MOD_RES, 3:MOD_ACK
	     	SEND.comHdr.EXT_SIZE   = "00000";      
			
		    SEND.bizHdr.MDI_GRP_CD               = "87";                //(2)  C매체그룹코드-->'예)  0101WEB단말'                                                              			
		    SEND.bizHdr.MDIKD_SRNO               = "01";                //(2)  재산관리:8701->                                                                            			
		    SEND.bizHdr.UPCODE                   = "87";                //(2)  C거래업무코드거래업무코드(2)  +기능코드(2)  +화면일련번호(2)  ]                                              			
		    SEND.bizHdr.FC_CD                    = "01";                //(2)  00:B/S전문, 01:계좌유효성 및 이체, 이체 일계:870100,가수가지:870200,지급결의:869100,환입결의:869200-> "01"                                       			
		    SEND.bizHdr.SC_SRNO                  = "03";                //(2)                                                                                         			
		    SEND.bizHdr.FKEY_CD                  = "00";                //(2)  C기능키코드실행-'00',조회-'20'...                                                               			
			
	        SEND.bizHdr.TRN_SCRT_CD              = "13A0Y99 ";         //(8)  거래보안코드                                                                                 
	        SEND.bizHdr.LANG_DSCD                = "K";                //(1)  언어구분코드-->'K'한글,'E'영어                                                                   
	        SEND.bizHdr.MOD_DSCD                 = "0";                //(1)  모드구분코드-->'0'당일,'1'마감후,'2'전일,'3'전일마감후                                                   
	        SEND.bizHdr.AGNBR_RGS_YN             = "";                //(1)  대행점등록여부                                                                                
	        SEND.bizHdr.PBNPB_YN                 = "";                //(1)  유무통여부                                                                                  
	        SEND.bizHdr.ACT_BIOAUT_YN            = "";                //(1)  계좌생체인식여부                                                                               
	        SEND.bizHdr.OPR_BIOAUT_YN            = "";                //(1)  조작자생체인식여부                                                                              
	        SEND.bizHdr.MGR_BIOAUT_YN            = "N";                //(1)  책임자생체인식여부   "N"                                                                           
	        SEND.bizHdr.CAN_TRN_YN               = "N";                //(1)  취소거래여부                                                                                 
	        SEND.bizHdr.EDBR_RGS_YN              = "";                //(1)  연수점등록여부                                                                                
	        SEND.bizHdr.VIR_TMS_YN               = "";                //(1)  가상전송여부                                                                                 
	        SEND.bizHdr.FILLER01                 = "";                //(1)  예비                                                                                     
	        SEND.bizHdr.FILLER02                 = "";                //(1)  예비                                                                                     
	        SEND.bizHdr.NXT_TRN_YN               = "N";                //(1)  다음거래여부-->'N'다음Transaction없음,'Y'다음Transaction으로이동                                       
	        SEND.bizHdr.NXT_TRNO                 = "";                //(6)  다음거래번호(거래업무코드(2)  +기능코드(2)  +화면일련번호(2)  )                                              
	        SEND.bizHdr.MGRAPV_DSCD              = "1";                //(1)  책임자승인구분코드-->'1'표준(책임자승인거래아님)  ,'2'항시승인,'3'조건부승인                                        
	        SEND.bizHdr.MSG_TPCD                 = "1";                //(1)  메시지유형코드-->'1'일반입력방식,'2'책임자승인요구(조건부승인)                                                  
	        SEND.bizHdr.TRM_RTN_SQNO             = "";                //(5)  단말거래순번-->00001~99999(단말별)                                                              
	        SEND.bizHdr.TBA_NO                   = "00";                //(2)  TAB번호                                                                                  
	        SEND.bizHdr.SCRN_CTL_YN              = "1";                //(1)  화면제어여부-->'1'기존화면유지,'9'기존화면clear                                                        
	        SEND.bizHdr.MAS_INOPT_DSCD           = "0";                //(1)  대량입출력구분코드-->'0'표준(대량입력거래아님)  ,'M'대량입력,대량출력,'E'대량입출력마지막전송DATA                           
	        SEND.bizHdr.MAS_INOPT_SQNO           = "";                //(4)  대량입출력순번-->0001~9999                                                                    
	        SEND.bizHdr.MOV_ACNO                 = "";                //(20)  기동계좌번호-->기동계좌인경우만set                                                                  
	        SEND.bizHdr.SVR_LU_NO                = "";                //(8)  서버LU번호-->단말서버LUNumber                                                                  
	        SEND.bizHdr.SBBR_CD                  = "";                //(5)  대체점코드-->대행점,연수점등록시대체점코드                                                                
	        SEND.bizHdr.PRC_TPCD                 = "O";                //(1)  처리유형코드-->'O'온라인,'F'오프라인                                                                
	        SEND.bizHdr.NML_CMPL_YN              = "N";                //(1)  정상완료여부-->'Y'정상commit,'N'Doesn'tmanagecommit(현재미사용)                                     
	        SEND.bizHdr.ORGTR_NO                 = "";                //(6)  원거래번호-->타시스템발생거래시원거래번호                                                                 
	        SEND.bizHdr.SYS_ID_NO                = "";                //(4)  CICSSYSID-->'0304'                                                                     
	        SEND.bizHdr.SYS_SRNO                 = "";                //(10)  시스템일련번호                                                                               
	        SEND.bizHdr.ERRCODE                  = "0000000";                //(7)  오류코드                                                                                   
	        SEND.bizHdr.PBOK_ISU_SRNO            = "";                //(3)  통장발생일련번호                                                                               
	        SEND.bizHdr.LU0_YN                   = "N";                //(1)  입력매체LU0사용여부                                                                            
	        SEND.bizHdr.TGT_MDI_KDCD             = "";                //(4)  Deliverychannel역할                                                                      
	        SEND.bizHdr.OBK_CD                   = "";                //(2)  기동계좌가타은행계좌일경우                                                                          
	        SEND.bizHdr.FILLER                   = "";                //(42)  FILLER                                                                                
            */
			

	    
	        try {
			    	/*----------------------------------------*/
			    	/* String Data to Byte Data conversion    */
			    	/*----------------------------------------*/
		    	if(SEND.bioHdr.iBioLen > 0){
//		    		SEND.getBCB01000T03B(s_data,"UTF-8", SEND.bioHdr.iBioLen);  //AS-IS [R102104204668] [2021-06-30] 전자구매 자본예산대금지급 취소시 일일감사 개선
		    		SEND.getBCB01000T03B(s_data,"EUC-KR", SEND.bioHdr.iBioLen); //[R102104204668] [2021-06-30] 전자구매 자본예산대금지급 취소시 일일감사 개선
		    	}else{
//		    		SEND.getBCB01000T03S(s_data,"UTF-8");  //AS-IS [R102104204668] [2021-06-30] 전자구매 자본예산대금지급 취소시 일일감사 개선
		    		SEND.getBCB01000T03S(s_data,"EUC-KR"); //[R102104204668] [2021-06-30] 전자구매 자본예산대금지급 취소시 일일감사 개선
		    	}
		    		
		    		//SEND.get(s_data,"UTF-8");
	    	
		    	
		    	
		    }
		    catch (pvException ne) {
//		    		ne.printStackTrace();
//		    		System.out.println(pvUtil.logTime()+PGMID+" :0000: DATA FORMAT ERROR !!.." +ne.toString());
		    		return(ONCNF.D_EFORMAT);		    		
		    }
		    /*--------------------------*/
		    /* send to pvOnse Gateway   */
 		    /*--------------------------*/
	        Socket socket = null;  InputStream in = null; OutputStream out = null;
			try {  
				/* tcp connect */
			    socket = new Socket(servAddress, servPort);	
			    socket.setSoTimeout(1000*90); //TOBE 2017-07-01  15 -> 90
			    /* tcp data recv */
			    in = socket.getInputStream();				    
			    /* tcp data send */
			    out = socket.getOutputStream();
			    //ASIS 2017-07-01 int slen = SEND.comHdr.iTLen + SEND.bizHdr.iTLen + SEND.bioHdr.iBioLen + SEND.iTLen;			//common(34) + header(200) + content() + list() + im(5)
			    //TOBE 2017-07-01
			    int slen = SEND.sysHdr.iTLen + SEND.trnHdr.iTLen + SEND.bioHdr.iBioLen + SEND.iTLen;			//common(34) + header(200) + content() + list() + im(5)
			    
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
			    //out.flush();
				    			        
			    
//test start 
//System.out.println("debug:BCB01000T03:length:"+slen);
ByteArrayOutputStream f = new ByteArrayOutputStream();
f.write(s_data,0,slen);
//System.out.println(f.toString());
/*byte b[] = f.toByteArray();
for (int i=0; i<b.length; i++) { 
	System.out.print((char) b[i]); 
} */
//System.out.println(); 
//test end
	out.flush();
/*

BufferedReader reader = new BufferedReader(new InputStreamReader(in));
System.out.println("return start");		    
System.out.println(reader.readLine()); //다시 수신해서 화면에 출력한다.
System.out.println("return end");		    
*/




				    int rcvSize = in.read(r_data);
				    if(rcvSize != -1) {
					    try {
					    	//전문을 보내기전에 로그테이블에 남기자
					    	send_msg =  f.toString();
					    	//String send_msg = f.toString(); 
							Map<String, String> param     = new HashMap<String, String>();
							param.put("IF_NAME", "BCB01000T03");
							param.put("SEND_NO", pay_send_no); 
							param.put("CONTS", send_msg);
							Object[] obj = { param };
							SepoaOut value = ServiceConnector.doService(info, "IF_001", "CONNECTION", "insert_if_msg", obj);
							ByteArrayOutputStream bos = new ByteArrayOutputStream();
					    	bos.write(r_data);
//					    	System.out.println("receive:"+bos.toString());
//					    	System.out.println("debug:BCB01000T03:ERR:"+RECV.TRN_SRNO);
					    	
					    	/* ASIS 2017-07-01
					    	RECV.set(r_data, r_data.length,"EUC-KR");
					    	// 전문응답 오류이면 .. 
					    	System.out.println("debug:errcode:"+RECV.bizHdr.ERRCODE);
					    	if(!RECV.bizHdr.ERRCODE.trim().equals("")){
					    		eRECV.set(r_data, r_data.length,"EUC-KR");
						    	return(ONCNF.D_ECODE);
					    	}
					    	*/
					    	
					    	/*else if(RECV.bizHdr.ERRCODE.trim().equals("")){
					    		System.out.println("debug:BCB01000T03:SUC:"+RECV.SEQ_NO);
					    		return(ONCNF.D_OK);
					    	}*/
					    	
					    	
					    	//TOBE 2017-07-01 수신파싱
					    	pvUtil.msglog(ONCNF.LOGNAME,"recv data : [" + new String(r_data)+"");
					    	
					    	RECV.setR(r_data, r_data.length,"EUC-KR");
					    	
					    	RECV.sysHdr.log(ONCNF.LOGNAME, "R");
					    	RECV.trnHdr.log(ONCNF.LOGNAME, "R");
					    	RECV.msgHdr.log(ONCNF.LOGNAME, "R");
					    	RECV.log(ONCNF.LOGNAME, "R");
					    	
					    	//TOBE 2017-07-01 메세지코드 (오류발생시 에러코드, 정상처리시 정상코드)
					    	pvUtil.msglog(ONCNF.LOGNAME," + RECV.msgHdr.MSG_CD = '"+RECV.msgHdr.MSG_CD +"'");
					    	
					    	//ASIS 2017-07-01 if(!RECV.bizHdr.ERRCODE.trim().equals("")){
					    	//TOBE 2017-07-01
					    	if(!"N".equals(RECV.sysHdr.RSP_RST_DSCD.trim()) ){
					    		Logger.sys.println(">>>>> 19");
					    		//ASIS 2017-07-01 eRECV.set(r_data, r_data.length,"EUC-KR");
					    		eRECV.setR(r_data, r_data.length,"EUC-KR");
					    		Logger.sys.println(">>>>> 20");
						    	return(ONCNF.D_ECODE);
					    	}
					    	
					    	
						} catch (pvException e) {
							Logger.sys.println(">>>>> 21");
//							e.printStackTrace();
//							System.out.println(pvUtil.logTime()+PGMID+" :0100: DATA FORMAT ERROR !!.." +e);
							return(ONCNF.D_ERR);
						}
				    }
				    else {
				    	Logger.sys.println(">>>>> 22");
//					    System.out.println(pvUtil.logTime()+PGMID+" :0200: TCP DATA RECV ERROR !!..ret = "+rcvSize);
				    	return(ONCNF.D_ERR);
				    }			    
			} catch (Exception e) {
				Logger.sys.println(">>>>> 23");
//					e.printStackTrace();
//					System.out.println(pvUtil.logTime()+PGMID+" :0300: Exception !!.. " + e);
					try {
						if(socket != null && !socket.isClosed()){ socket.close(); }
					} catch (Exception ie) { rtn = -1;
//						ie.printStackTrace();
//						System.out.println(pvUtil.logTime()+PGMID+" :0400: Exception !!.. " + ie);
					}
					return(ONCNF.D_ENETWORK);
			} finally {		
				try {
					if(in != null){ in.close(); } if(out != null){ out.close(); } if(socket != null && !socket.isClosed()){ socket.close(); }
//					socket.close();
				} catch (IOException ie) { rtn = -1;
	//				ie.printStackTrace();
	//				System.out.println(pvUtil.logTime()+PGMID+" :0500: IOException !!.. " + ie);
				}
			}
			return(ONCNF.D_OK);
			
		}
		else{ 
			Logger.sys.println(">>>>> 25");
			return(ONCNF.D_ERR);		
		}
	}
		
}