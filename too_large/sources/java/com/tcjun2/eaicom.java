/* TOBE 2017-07-01  EAI 공통부 (시스템헤더 값 세팅) */

package com.tcJun2;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Map;
import java.util.Random;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;

import com.tcComm2.ONCNF;

import sepoa.fw.log.Logger;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.cfg.Configuration;

@SuppressWarnings("unused")
public class eaiCom {
	
	public eaiCom() {
		int rtn = 0;
		try {

			this.getHostInfo();
		    				
			this.getConfig();
					
			}catch(Exception exception){
				rtn = -1;
//				exception.printStackTrace();
			}	
	}
	

    private Log logger = LogFactory.getLog(getClass());	
    private static String PGMID = "EAI_Header";
    public String sThread = "";
    
    public String sHostname = "";
    public String sHostIP   = "";
    public String sHostMac  = "";
    
    /*----------------------------------------------------*/
	/* EAI Header 전문 필드 정의 - 1.SH.시스템헤더부(SIZE:400) 설정*/
    /*----------------------------------------------------*/

    //전문전체길이
    public String ALL_TLM_LEN = "";
    
    //버전
    public String VER = "3110";
    
    //전문암호화구분코드
    public String TLM_ENCY_DSCD = "1"; // 1: 사용안함

    //원글로벌ID  [전문 작성일(8) + Hostname(8) + 거래시분초(8) + 관리번호(8)] (20170727020644DD0089175700000030)
    //2018-02-07 밑에서 산출 : public String ORG_GLBL_ID = new StringBuilder().append(SepoaDate.getShortDateString()).append("epsdev00").append(SepoaDate.getShortTimeString()).append("00").append(getMgmNo()).toString();
    public String ORG_GLBL_ID = "";
    
    //글로벌ID (20170727020644DD00891757000000030) 외부로 나갈때 계정계에서 연번채번으로 쓰는것으로 우리는 변동이 없음
    //2018-02-07 밑에서 산출 : public String GLBL_ID = ORG_GLBL_ID;
    public String GLBL_ID = "";
    
    //글로벌ID 진행일련번호
    public String GLBL_ID_PRG_SRNO = "0001";
    
    //채널코드 INT:EAI
    public String CHNL_CD = "INT";
    
    //채널구분코드 INT:EAI
    public String CHNL_DSCD = "INT";
    
    //클라이언트IP주소 (10.181.47.150)
    public String CLNT_IPAD = "";
    
    //클리아언트MAC (E8039A67CF6D)
    public String CLNT_MAC = "";
    
    //환경정보구분코드 (P:운영 D:개발 T:테스트 Y:연수)
    public String ENV_INF_DSCD = "";
    
    //최초전송시스템코드
    public String FST_TMS_SYS_CD = "EPS";
    
    //언어구분코드
    public String LANG_DSCD = "KR";
    
    //전송시스템코드
    public String TMS_SYS_CD = "EPS";
    
    //매체종류코드
    public String MD_KDCD = "EEPS1";
    
    //인터페이스ID
    public String INTF_ID = ""; 
    
    //MAC 채널세션 ID
    public String MCA_CHNL_SESS_ID = "";
    
    //인터페이스시스템 노드번호
    public String INTF_SYS_NODE_NO = "";
    
    //요청시스템코드
    public String REQ_SYS_CD = "EPS";
    
    //요청시스템노드ID
    public String REQ_SYS_NODE_ID = "001";
    
    //거래동기화구분코드 (S=Sync ,A=Async응답있음, X=Async응답없음)
    public String TRN_SYN_DSCD = "S";
    
    //요청응답구분코드 (S=요청 , R=응답)
    public String REQ_RSP_DSCD = "S";
    
    //전문요청일시 (20170722184157000)
    public String TLM_REQ_DTM = new StringBuilder().append(SepoaDate.getShortDateString()).append(SepoaDate.getShortTimeString()).append("000").toString(); 
    
    //TTL사용여부
    public String TTL_USG_YN = "N";
    
    //최초시작시각 (171717)
    public String FST_STA_TM = SepoaDate.getShortTimeString(); 
    
    //유효시간
    public String VLD_TIM = "000";
    
    //응답시스템코드
    public String RSP_SYS_CD = "";
    //전문응답일시         
    public String TLM_RSP_DTM = "";
    //응답결과구분코드     
    public String RSP_RST_DSCD = "";
    //메시지발생시스템코드 
    public String MSG_OCC_SYS_CD = "";
    //메시지코드           
    public String MSG_CD = "";
    //최종채널유형코드     
    public String LST_CHNL_TYCD = "";
    //채널전문공통부 길이  
    public String CHNL_TLM_CMNP_LEN = "";
    //예비                  
    public String SPR = "";
    

/**
 * hostname 8자리
 * @return
 */
    public void getHostInfo() {		
	try {
		InetAddress local = InetAddress.getLocalHost();
		sHostname = local.getHostName();
		sHostIP = local.getHostAddress();
		
		if(sHostname.length() > 8) {
			sHostname = sHostname.substring(0, 8);
		}else if(sHostname.length() < 8) {
			int iSize = 8 - sHostname.length();
			
			sHostname = setRPad(sHostname, ' ', iSize);
		}
		
		NetworkInterface network = NetworkInterface.getByInetAddress(local);
		byte[] mac = network.getHardwareAddress();
		
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < mac.length; i++) {
			sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "" : ""));
		}
		
		sHostMac = sb.toString();

		
		//원글로벌ID  [전문 작성일(8) + Hostname(8) + 거래시분초(8) + 관리번호(8)] (20170727020644DD0089175700000030)
		ORG_GLBL_ID = new StringBuilder().append(SepoaDate.getShortDateString()).append(sHostname).append(SepoaDate.getShortTimeString()).append("00").append(getMgmNo()).toString();

		//글로벌ID (20170727020644DD00891757000000030) 외부로 나갈때 계정계에서 연번채번으로 쓰는것으로 전자구매는 변동이 없음
		GLBL_ID = ORG_GLBL_ID;

		//클라이언트IP주소 (10.181.47.150)
		CLNT_IPAD = sHostIP;
		
		//클리아언트MAC (E8039A67CF6D)
		CLNT_MAC = sHostMac;
		
		
	}catch(UnknownHostException e) {
		sHostname = "        ";
	}catch(SocketException e) {
		logger.debug(e.getMessage());
	}
}

    
    
    public void getConfig() {
    	int rtn = 0;
    	try {
    		
    		Configuration conf       = new Configuration();
    	   	
    		// EAI 설정 //환경정보구분코드 (P:운영 D:개발 T:테스트 Y:연수)
    		
			String send_ip     = conf.get("sepoa.interface.tcpip.ip");
			
			//System.out.println("eaiCom send_ip : " + send_ip);
			
			if ("weaiapd.woorifg.com".equals(send_ip)) {
				ENV_INF_DSCD = "D";
			} else if ("weaiapt.woorifg.com".equals(send_ip)) {
				ENV_INF_DSCD = "T";
			} else if ("weaiapp.woorifg.com".equals(send_ip)) {
				ENV_INF_DSCD = "P";
			}

			//System.out.println("eaiCom ENV_INF_DSCD : " + ENV_INF_DSCD);
			
		}catch(Exception exception){
//			exception.printStackTrace();
			rtn = -1;
		}	
    }
    
    

/**
 * 관리번호 체번
 * @return
 */
public String getMgmNo() {
	String sRetNo = ""; 
	String sRanNo = "";
	
	try {
		Random rd = new Random();
		sRanNo = String.valueOf(rd.nextInt(10000000));
		
		if(sRanNo.length() < 7) {
			sRanNo = setLPad(sRanNo, '0', (7 - sRanNo.length()));
		}
		
		
		sRetNo = new StringBuilder().append(sRetNo).append(sRanNo).append("0").toString();
	}catch(Exception e) {
		sRetNo = "99999999";
	}
	
	return sRetNo;
}


/**
 * 문자열 좌측에 len길이만큼 pad 문자 추가 함.
 * @param src
 * @param pad
 * @param len
 * @return
 */
protected String setLPad(String src, char pad, int len) {
	StringBuilder sbRet = new StringBuilder();
	
	for(int i = 0; i < len; i++) {
		sbRet.append(pad);
	}
	
	return sbRet.toString() + src;
}

/**
 * 문자열 우측에 len길이만큼 pad 문자 추가 함.
 * @param src
 * @param pad
 * @param len
 * @return
 */
protected String setRPad(String src, char pad, int len) {
	StringBuilder sbRet = new StringBuilder();
	
	for(int i = 0; i < len; i++) {
		sbRet.append(pad);
	}
	
	return src + sbRet.toString();
}


}