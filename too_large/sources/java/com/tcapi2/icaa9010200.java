/* TOBE 2017-07-01 책임자승인명세 EAI */

package com.tcApi2;

import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;

import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.srv.SepoaService;

import com.tcComm2.ONCNF;
import com.tcJun2.*;
import com.tcLib2.*;


public class ICAA9010200 extends SepoaService implements I_Wms  {
	  
    public IF_ICAA9010200_S  SEND      =  null;
    public IF_ICAA9010200_R  RECV      =  null;
    public IF_OT0000E        eRECV     =  null;    
    public static String     PGMID     =  null;
    public eaiCom            eaiCom    =  null; //TOBE 2017-07-01 EAI 공통처리부

    public String    send_msg          = null;
    public String    send_no           = null;

    byte[] s_data = new byte[TCP_BUFSIZE];   
    byte[] r_data = new byte[TCP_BUFSIZE];
    public ICAA9010200 () {    	
        this.SEND    = new IF_ICAA9010200_S();
        this.RECV    = new IF_ICAA9010200_R();
        this.eRECV   = new IF_OT0000E();
        PGMID = "ICAA9010200";
        this.send_msg        = "";
        this.send_no         = "";

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
    	SEND.sysHdr.INTF_ID                	     =  "EPSER0000022"           ;   //(문자	12        )  인터페이스 ID            
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
    	SEND.trnHdr.TRN_CD                 =  "ICAA90102";             //(문자	9   )  거래코드                   
    	SEND.trnHdr.SRVC_ID                =  "ICAA9010200";           //(문자	11  )  서비스ID                   
    	SEND.trnHdr.FUNC_CD                =  "30";                    //(문자	2   )  기능 코드  (20:조회,30:등록)                  
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
       
	public	int sendMessage(String EventCode, String servAddress, int servPort ) {
		if(EventCode.equals("ICAA9010200")) {
					
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
		    	pvUtil.msglog(ONCNF.LOGNAME," :0100: DATA FORMAT ERROR !!.." +ne.toString());
		    		return(ONCNF.D_EFORMAT);		    
		    }
		    /*------------------------------*/
		    /* send to WOORI BANK Gateway   */
 		    /*------------------------------*/
		    Socket socket = null;

			try {  
					/*-----------------------
					 *  TCP Connect 
					 *----------------------*/
				    socket = new Socket(servAddress, servPort);					    
				    socket.setSoTimeout(1000*90); //TOBE 2017-07-01  15 -> 90    
				    /* TCP DATA SEND */
				    			   				    
				    OutputStream out = socket.getOutputStream();
				    InputStream in = socket.getInputStream();
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
				    //test start 
				    //System.out.println("debug:ICAA9010200:length:"+slen);
				    //ByteArrayOutputStream f = new ByteArrayOutputStream(); 
				    //f.write(s_data,0,slen);
				    //System.out.println(f.toString());
				    //test end
				    out.flush();
				    						    				  
				    int rcvSize = in.read(r_data);
				    if(rcvSize != -1) {
				    	
					    try {
					    	//전문을 보내기전에 로그테이블에 남기자
					    	send_msg =  s1;
					    	//String send_msg = f.toString(); 
							Map<String, String> param     = new HashMap<String, String>();
							param.put("IF_NAME", "ICAA9010200"); 
							param.put("SEND_NO", send_no); 
							param.put("CONTS", send_msg);
							
							Object[] obj = { param };
							SepoaOut value = ServiceConnector.doService(info, "IF_001", "CONNECTION", "insert_if_msg", obj);
							
					    	//ASIS 2017-07-01
					    	//RECV.set(r_data, r_data.length,"EUC-KR");
					    	//pvUtil.msglog(ONCNF.LOGNAME," + RECV.bizHdr.ERRCODE = '"+RECV.bizHdr.ERRCODE +"'");
					    	
					    	//TOBE 2017-07-01 메세지코드 (오류발생시 에러코드, 정상처리시 정상코드)
					    	RECV.setR(r_data, r_data.length,"EUC-KR");
					    	pvUtil.msglog(ONCNF.LOGNAME," + RECV.msgHdr.MSG_CD = '"+RECV.msgHdr.MSG_CD +"'");
					    	
					    	// 전문응답 오류이면 .. 
					    	//ASIS 2017-07-01 if(!RECV.bizHdr.ERRCODE.trim().equals("")){
					    	//TOBE 2017-07-01
					    	if(!"N".equals(RECV.sysHdr.RSP_RST_DSCD.trim()) ){
					    		//ASIS 2017-07-01 eRECV.set(r_data, r_data.length,"EUC-KR");
					    		eRECV.setR(r_data, r_data.length,"EUC-KR");
					    		eRECV.log(ONCNF.LOGNAME, "");
					    		
						    	return(ONCNF.D_ECODE);
					    	}
						} catch (pvException e) {
							pvUtil.msglog(ONCNF.LOGNAME," :0100: DATA FORMAT ERROR !!.." +e);
							return(ONCNF.D_ERR);
						}
				    }
				    else {
				    	pvUtil.msglog(ONCNF.LOGNAME," :0200: TCP DATA RECV ERROR !!..ret = "+rcvSize);
				    	return(ONCNF.D_ERR);
				    }				    
			} catch (Exception e) {
					pvUtil.msglog(ONCNF.LOGNAME," :0300: Exception !!.. " + e);
					return(ONCNF.D_ENETWORK);
			}	
			finally {
				try {
					if(socket != null){ socket.close(); }
				} catch (IOException ie) {
					pvUtil.msglog(ONCNF.LOGNAME," :0500: IOException !!.. " + ie);
				}
			}
			return(ONCNF.D_OK);
		}
		else{ 
			return(ONCNF.D_ERR);		
		}
	}
		
}