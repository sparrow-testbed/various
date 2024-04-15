package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.penta.scpdb.*;  /* TOBE 2017-07-01 DAMO SCP Class 로딩 -scpdb.jar (암호) */
import com.tcApi2.BEB00730T01;
import com.tcApi2.BEB00730T02;
import com.tcApi2.BEB00730T03;
import com.tcApi2.CMT90020100;
import com.tcApi2.CMT90040100;
import com.tcApi2.ICAA9010200;
import com.tcComm2.ONCNF;
import com.tcJun2.LIST_BEB00730T01_R;
import com.tcJun2.LIST_CMT90020100_R;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.ArrayOfString;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0037Response;

import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;
import sepoa.svc.common.constants;

public class pay_bd_ins2 extends HttpServlet{

	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        SepoaInfo   info  = sepoa.fw.ses.SepoaSession.getAllValue(req); // 세션 Object
        GridData    gdReq = null;
        GridData    gdRes = new GridData();
        String      mode  = null;
        PrintWriter out   = null;
    	boolean   isJson = false;
    	String      signerStatus = null;
    	
        
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        
        try {
        	out   = res.getWriter();
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		Map<String, String> header = this.getHeader(gdReq, info);
       		
       		signerStatus = header.get("signer_status");
       				
       		
       		if("getItemList".equals(mode)){	
       			gdRes = getItemList(gdReq, info); 				// 품목 조회
       		}else if("setApproval".equals(mode)){
       			gdRes = setApproval(gdReq, info); 				// 결재처리
       		}else if("getBEB00730T01".equals(mode)){
       			gdRes = getBEB00730T01(gdReq, info);   			// 세금계산서 조회
       		}else if("setBEB00730T02".equals(mode)){
       			Logger.sys.println("PAY_DTMN_DT ");
       			gdRes = setBEB00730T02(gdReq, info);  			// 경비지급결의
       		}else if("setSignerUpdate".equals(mode)){
       			//[R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청
       			if(!constants.DEFAULT_ACC_JUMCD.equals(info.getSession("DEPARTMENT"))){
       				throw new Exception("권한이 없습니다.");
       			}
       			gdRes = setSignerUpdate(gdReq, info);   		//책임자 지정       			
       		}else if("setBEB00730T03".equals(mode)){       			
       			//[R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청
       			if(!constants.DEFAULT_ACC_JUMCD.equals(info.getSession("DEPARTMENT"))){
       				throw new Exception("권한이 없습니다.");
       			}
       			
       			//ASIS 2017-07-01 gdRes = setBEB00730T03(gdReq, info);   			//경비집행
       			
       			//TOBE 2017-07-01
       			if  ("M".equals(header.get("app_status_cd"))) // 지급결의
           		{
       				gdRes = setBEB00730T03(gdReq, info,signerStatus);   			//경비집행
           		}
       			
       			if("true".equals(gdRes.getStatus())){
       				if( ("1".equals(header.get("signer_status"))) || // 5천만원이상
       	       				("2".equals(header.get("signer_status"))) )  // 2억원이상
       	       			{
       	       				gdRes = setICAA9010200(gdReq, info);   			//TOBE 2017-07-01 책임자승인명세
       	       			}
       			}       			
       			//isJson = true;
       		}else if("updateSpy2glSigner1".equals(mode)){
        		gdRes  = this.updateSpy2glSigner1(gdReq, info);
        		isJson = true;
        	}else if("getEps0037".equals(mode)){ // 책임자 승인 목록
        		gdRes  = this.getEps0037(gdReq, info);
        		isJson = true;
        	}		
        }
        catch (Exception e) {
        	gdRes.setMessage(e.getMessage());
        	gdRes.setStatus("false");
        }
    	finally {
    		try{
    			if(isJson){
    				if(out != null){ out.print((gdRes.getMessage() != null)?gdRes.getMessage():""); }
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
    
    private EPS0037 getEps0037WebserviceEps0037(GridData gdReq, SepoaInfo info) throws Exception{
    	EPS0037             eps0037            = new EPS0037();
    	Map<String, String> header             = this.getHeader(gdReq, info);
    	String              jumjumcd           = null;
    	String              mode2              = null;
    	String              id                 = this.getWebserviceId(info);
    	
    	mode2 = JSPUtil.CheckInjection(gdReq.getParam("mode2"));
		jumjumcd = info.getSession("DEPARTMENT");
    	
    	eps0037.setMODE(mode2);
    	eps0037.setJUMJUMCD(jumjumcd);
    	eps0037.setUSRUSRID(id);
    	
    	return eps0037;
    }
    
    private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE", houseCode);
		param.put("INF_TYPE",   "W");
		param.put("INF_CODE",   infCode);
		param.put("INF_SEND",   infSend);
		param.put("INF_ID",     id);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
    
    private void insertSinfep0037Info(SepoaInfo info, String infNo, EPS0037 eps0037) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              mode      = eps0037.getMODE();
		String              jumJumCd  = eps0037.getJUMJUMCD();
		String              usrUsrId  = eps0037.getUSRUSRID();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE", houseCode);
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("JUMJUMCD",   jumJumCd);
		svcParam.put("USRUSRID",   usrUsrId);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0037Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(); 
		}
	}
    
    private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private void updateSinfep0037Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = null;
		Object[]            obj       = null;
		String              houseCode = null;
		String              code      = null;
		String              content   = null;
		
		try{
			param = new HashMap<String, String>();
			obj   = new Object[1];
			
			houseCode = info.getSession("HOUSE_CODE");
			code      = response[0];
			content   = response[1];
			content   = this.getStringMaxByte(content, 1000);
//			Logger.sys.println(">>>>> updateSinfep0037Info 01");
			if("200".equals(code)){
				param.put("RETURN1", code);
				param.put("RETURN2", content);
				param.put("RETURN3", "");
//				Logger.sys.println(">>>>> updateSinfep0037Info 02Y");
			}
			else{
				param.put("RETURN1", code);
				param.put("RETURN2", content);
				param.put("RETURN3", "");
//				Logger.sys.println(">>>>> updateSinfep0037Info 02N");
			}
			
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
//			Logger.sys.println(">>>>> updateSinfep0037Info 03");
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0037Info", obj);
//			Logger.sys.println(">>>>> updateSinfep0037Info 04");
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
        
    private String getEps0037Webservice(GridData gdReq, SepoaInfo info) throws Exception{
    	String[]        arrayOfStringArray = null;
    	String          code               = null;
    	String          result             = null;
    	String          infNo              = null;
    	String          status             = null;
		String          reason             = null;
    	EPS_WSStub      epsWSStub          = null;
    	EPS0037         eps0037            = null;
    	EPS0037Response eps0037Response    = null;
    	ArrayOfString   arrayOfString      = null;
    	
    	try{
    		epsWSStub = new EPS_WSStub();
    		eps0037   = this.getEps0037WebserviceEps0037(gdReq, info);
    		infNo     = this.insertSinfhdInfo(info, "EPS0037", "S");
        	
        	this.insertSinfep0037Info(info, infNo, eps0037);
        	
        	eps0037Response    = epsWSStub.ePS0037(eps0037);
        	arrayOfString      = eps0037Response.getEPS0037Result();
        	arrayOfStringArray = arrayOfString.getString();
        	code               = arrayOfStringArray[0];
        	result             = arrayOfStringArray[1];
        	
        	if("200".equals(code)){
        		status = "Y";
        		reason = "";
        	}
        	else{
        		status = "N";
        		reason = result;
        	}
    	}
    	catch(Exception e){
    		arrayOfStringArray = new String[3];
    		
    		this.loggerExceptionStackTrace(e);
    		
    		status = "N";
    		reason = this.getExceptionStackTrace(e);
    		reason = this.getStringMaxByte(reason, 1000);
    		result = reason;
    		code   = "900";
    		
    		arrayOfStringArray[0] = code;
    		arrayOfStringArray[1] = reason;
    		arrayOfStringArray[2] = "";
    	}
//	    Logger.sys.println(">>>>> getEps0037Webservice 01");
    	this.updateSinfhdInfo(info, infNo, status, reason, " ");
//	    Logger.sys.println(">>>>> getEps0037Webservice 02");
	    this.updateSinfep0037Info(info, infNo, arrayOfStringArray);
//	    Logger.sys.println(">>>>> getEps0037Webservice 03");
    	if("200".equals(code) == false){
    		throw new Exception(result);
    	}
    	
    	return result;
    }
    
    private String getStringMaxByte(String target, int maxLength){
    	byte[] targetByteArray       = target.getBytes();
    	int    targetByteArrayLength = targetByteArray.length;
    	int    targetLength          = 0;
    	
    	while(targetByteArrayLength > maxLength){
    		targetLength          = target.length();
    		targetLength          = targetLength - 1;
    		target                = target.substring(0, targetLength);
    		targetByteArray       = target.getBytes();
    		targetByteArrayLength = targetByteArray.length;
    	}
    	
    	return target;
    }
    
    private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
    
    private String[] getEps0037GdResSplit(String result, String deli) throws Exception{
    	String[] resultArray   = null;
    	String   delimeter     = null;
    	char[]   tempCharArray = new char[1];
    	
		tempCharArray[0] = (char)9;
		delimeter        = new String(tempCharArray);
		result           = result.replace(deli, delimeter);
		resultArray      = result.split(delimeter);
		
		return resultArray;
    }
    
    private String getEps0037GdRes(GridData gdRes, String result) throws Exception{
	    String              rowInfo        = null;
	    String[]            rowArray       = this.getEps0037GdResSplit(result, "!|");
	    String[]            columnArray    = null;
	    Map<String, String> columnInfo     = null;
    	int                 i              = 0;
	    int                 rowArrayLength = rowArray.length;
	    
	    String retVal                      = "";
	    
	    
    	for(i = 0; i < rowArrayLength; i++){
    		columnInfo = new HashMap<String, String>();
    		
    		rowInfo     = rowArray[i];
    		columnArray = this.getEps0037GdResSplit(rowInfo, "@|");
    		
    		columnInfo.put("CODE", columnArray[0]);
//    		columnInfo.put("TEXT1", columnArray[1]);
    		columnInfo.put("TEXT2", columnArray[1]);
//    		columnInfo.put("JUMJUMCD", columnArray[3]);
//    		columnInfo.put("TEXT4", columnArray[4]);
//    		columnInfo.put("TEXT5", columnArray[5]);
//    		columnInfo.put("STSSTSCD", columnArray[6]);
    		
    		gdRes.addValue("SELECTED", "0");
    		gdRes.addValue("CODE", columnInfo.get("CODE"));
//    		gdRes.addValue("TEXT1", columnInfo.get("TEXT1"));
    		gdRes.addValue("TEXT2", columnInfo.get("TEXT2"));
//    		gdRes.addValue("JUMJUMCD", columnInfo.get("JUMJUMCD"));
//    		gdRes.addValue("TEXT4", columnInfo.get("TEXT4"));
//    		gdRes.addValue("TEXT5", columnInfo.get("TEXT5"));
//    		gdRes.addValue("STSSTSCD", columnInfo.get("STSSTSCD"));
    		
    		if(i+1 != rowArrayLength) {
    			retVal = retVal + "{CODE:'" + columnInfo.get("CODE") + "',TEXT2:'" + columnInfo.get("TEXT2") + "(" + columnInfo.get("CODE") + ")'},";
			} else {
				retVal = retVal + "{CODE:'" + columnInfo.get("CODE") + "',TEXT2:'" + columnInfo.get("TEXT2") + "(" + columnInfo.get("CODE") + ")'}";	
			}
//    		Logger.sys.println(">>>>> ccc " + i + " : " +  retVal);
    	}
    	
//    	Logger.sys.println(">>>>> ccc rowArrayLength : " + rowArrayLength);
    	
    	return retVal;
    }

	private GridData getEps0037(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData gdRes        = new GridData();
	    String   gdResMessage = "";
	    HashMap  message      = null;
	    String   result       = null;
	    String   retVal       = null;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes  = OperateGridData.cloneResponseGridData(gdReq);
	    	result = this.getEps0037Webservice(gdReq, info);
	    	isStatus = true;
	    	if(isStatus){
	    		retVal = this.getEps0037GdRes(gdRes, result);
		    	
//	    		Logger.sys.println(">>>>> bbb 01");
		    	gdResMessage = "[" + retVal + "]";
//		    	Logger.sys.println(">>>>> bbb 02");
	    	}
	    	else{
	    		//gdResMessage = value.message;
	    		gdResMessage = "[]";
	    	}
	    	
//	    	Logger.sys.println(">>>>> bbb 03");
	    	gdRes.addParam("mode", "query");
//	    	Logger.sys.println(">>>>> bbb 04");
	    }
	    catch(Exception e){
	    	this.loggerExceptionStackTrace(e);
	    	gdResMessage = (message != null)?"[" + message.get("MESSAGE.1002").toString() + "]":"[]";
	    	gdResMessage = e.getMessage();
	    	isStatus     = false;
	    }
	    
//	    Logger.sys.println(">>>>> bbb 05");
	    gdRes.setMessage(gdResMessage);
//	    Logger.sys.println(">>>>> bbb 06");
	    gdRes.setStatus(Boolean.toString(isStatus));
//	    Logger.sys.println(">>>>> bbb 07");
	    return gdRes;
	}
	
	
//	@SuppressWarnings({ "rawtypes" })
//	private GridData getZiphangcd(GridData gdReq, SepoaInfo info) throws Exception{
//	    GridData      gdRes        = new GridData();
//	    String        result       = null;
//	    SepoaOut      value        = null;
//	    HashMap       message      = null;
//	    String        gdResMessage = null;
//	    Object[]      obj          = null;
//	    Map<String, String> header = this.getHeader(gdReq, info);
//	    int           rowCount     = 0;
//	    boolean       isStatus     = false;
//	    String        apvrncd        = gdReq.getParam("apvrncd");
//	    String        user_trm_no    = gdReq.getParam("user_trm_no");
//	    String        txtBrowserInfo = gdReq.getParam("txtBrowserInfo");
//	    
//	    try{	
//	    	message  = this.getMessage(info);
//	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
//	    	isStatus = true;
//	    	
//            header.put("apvrncd"       , apvrncd);
//            header.put("user_trm_no"   , user_trm_no);
//            header.put("txtBrowserInfo", txtBrowserInfo);
//            
//	    	if(isStatus){
//	    		result    = this.et_getZiphangcd(header, gdRes, info);
//
//	    		Logger.sys.println(">>>>> bbb 01");
//		    	gdResMessage = "[" + result + "]";
//		    	Logger.sys.println(">>>>> bbb 02");
//	    	}
//	    	else{
//	    		//gdResMessage = value.message;
//	    		gdResMessage = "[]";
//	    	}
//	    	Logger.sys.println(">>>>> bbb 03");
//	    	gdRes.addParam("mode", "query");
//	    	Logger.sys.println(">>>>> bbb 04");
//	    }
//	    catch (Exception e){
//	    	gdResMessage = (message != null)?"[" + message.get("MESSAGE.1002").toString() + "]":"[]";
//	    	isStatus     = false;
//	    }
//	    Logger.sys.println(">>>>> bbb 05");
//	    gdRes.setMessage(gdResMessage);
//	    Logger.sys.println(">>>>> bbb 06");
//	    gdRes.setStatus(Boolean.toString(isStatus));
//	    Logger.sys.println(">>>>> bbb 07");
//	    return gdRes;
//	}
    
    
//    /**
//     * 책임자 승인 목록 
//     * et_getZiphangcd
//     * @param  gdReq
//     * @param  info
//     * @return GridData
//     * @throws Exception
//     * @since  2017-07-01
//     * @modify 2017-07-01
//     */
//    private String et_getZiphangcd(Map<String, String> header, GridData gdRes, SepoaInfo info) throws Exception {
//		String APV_RNCD          = null;
//		String data_tot_size     = null;
//		String result            = "";
//		
//		String              BKCD         = null;
//		String              BRCD         = null; 
//		String              TRMBNO       = null;
//		String              USERTERMNO   = null;
//		String              TERMNO9      = null;
//		String              addUserId    = null;
//
//		Configuration conf       = new Configuration();
//	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
//	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
//	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
//		
//	   	APV_RNCD                 = header.get("apvrncd");
//	   	
//	   	if(header.get("user_trm_no").length() >= 12){
//			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
//			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
//			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
//		}
//
//	   	CMT90020100 n01 = new CMT90020100();
//	   	
//	   	data_tot_size    = String.format("%07d", n01.SEND.iTLen-10); // 데이터부 데이터길이 -10
////	    System.out.println("data_tot_size:"+data_tot_size+"|");
//		
//		n01.SEND.DAT_KDCD   = "DTI";           //데이타헤더부 : (문자3)  데이터종류코드	      
//		n01.SEND.DAT_LEN    = data_tot_size;   //데이타헤더부 : (숫자7)  데이터길이
//		
//		n01.SEND.RLPE_APV_DSCD   = "B";           //1.   S1         책임자승인구분코드
//		n01.SEND.APV_AVL_RLPE_CN = "00";          //2.   S2         승인가능책임자수
//		n01.SEND.GRID_ROW_CNT    = "01";          //3.   S2         그리드열건수 
//		n01.SEND.APV_RNCD        = APV_RNCD;      //4.   S10        승인사유코드 
//		
//		n01.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
//		n01.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
//		n01.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
//        n01.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
//		
//		try {
//			int iret = n01.sendMessage("CMT90020100",send_ip,send_port);
//			Logger.sys.println(">>>>> app 05");
//
//
//			
//			//TOBE 2017-07-01 추가 온라인 전문 로그
//			if(iret == ONCNF.D_OK) {
//				this.insertSinfhdBCB01000T(info, "CMT90020100", "Y", n01.RECV.msgHdr.MAIN_MSG_ADD_TXT); //interface 입력
//			} else {
//				this.insertSinfhdBCB01000T(info, "CMT90020100", "N", n01.RECV.msgHdr.MAIN_MSG_ADD_TXT); //interface 입력
//			}
//			
//			
//			if(iret == ONCNF.D_OK) {
//				Logger.sys.println(">>>>> app 06");
//				n01.ORECV.log(ONCNF.LOGNAME, "R");
//				Logger.sys.println(">>>>> app 07");
//				if(n01.ORECV.R_CODE.trim().equals("0000000")){
//					for(int i = 0; i < n01.ORECV.list_cmt90020100_r.size();i++) {
//						
//						Logger.sys.println(">>>>> app 08");
//						LIST_CMT90020100_R list = (LIST_CMT90020100_R) n01.ORECV.list_cmt90020100_r.get(i);
//						Logger.sys.println(">>>>> app 09");
//						gdRes.addValue("RLPE_EMNM"        ,  list.RLPE_EMNM        );  // S8   책임자행번	      
//					    gdRes.addValue("RLPE_FNM"         ,  list.RLPE_FNM         );  // S30  책임자성명	      
//					    gdRes.addValue("RLPE_LVJP_NM"     ,  list.RLPE_LVJP_NM     );  // S40  책임자직급명	    
//						gdRes.addValue("RLPE_IPAD"        ,  list.RLPE_IPAD        );  // S39  책임자IP주소	    
//						gdRes.addValue("RLPE_STS_INF"     ,  list.RLPE_STS_INF     );  // S1   책임자상태정보	  
//						gdRes.addValue("RLPE_TRM_NO"      ,  list.RLPE_TRM_NO      );  // S12  책임자단말번호	  
//						gdRes.addValue("RLPE_BRCD"        ,  list.RLPE_BRCD        );  // S6   책임자점코드	    
//						gdRes.addValue("RLPE_MTBR_DIS"    ,  list.RLPE_MTBR_DIS    );  // S1   책임자모점구분	  
//						gdRes.addValue("TGT_MD_DIS"       ,  list.TGT_MD_DIS       );  // S1   대상매체구분	    
//						gdRes.addValue("RLPE_GDCD"        ,  list.RLPE_GDCD        );  // S2   책임자등급코드	  
//						gdRes.addValue("RLPE_APV_SENU_2"  ,  list.RLPE_APV_SENU_2  );  // S1   책임자승인차수_2	
//						gdRes.addValue("RLPE_GRP"         ,  list.RLPE_GRP         );  // S1   책임자그룹	      
//						
//						if(i+1 != n01.ORECV.list_cmt90020100_r.size()) {
//						    result = result + "{managerNo:'" + list.RLPE_EMNM + "',managerName:'" + list.RLPE_FNM + "(" + list.RLPE_EMNM + ")'},";
//						} else {
//							result = result + "{managerNo:'" + list.RLPE_EMNM + "',managerName:'" + list.RLPE_FNM + "(" + list.RLPE_EMNM + ")'}";	
//						}
//						Logger.sys.println(">>>>> app 10");
//						
//					}
//				}
//				else{
//					Logger.sys.println(">>>>> app 11");
//					gdRes.setMessage(n01.ORECV.R_CODE.trim());
//					Logger.sys.println(">>>>> app 12");
//				}
//			}
//			else {
//				Logger.sys.println(">>>>> app 13");
//				throw new Exception();
//			}
//		}
//		catch (Exception e) {
//			Logger.sys.println(">>>>> app 14");
////			e.printStackTrace();
//		}
//		Logger.sys.println(">>>>> app 15");
//    	return result;
//	}
    
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getItemList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaFormater       sf         = null;
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	    int                 rowCount   = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "TX_012", "CONNECTION","getItemList", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for (int i = 0; i < rowCount; i++){
			    		for(int k=0; k < gridColAry.length; k++){
			    			if("SELECTED".equals(gridColAry[k])){
			    				gdRes.addValue("SELECTED", "0");
			    			}
			    			else{
			    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
			    			}
			    		}
			    	}
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
    @SuppressWarnings({ "rawtypes"})
    private GridData setApproval(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
        	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
        	Object[] obj = {allData};
    		value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setApproval", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes" })
	private GridData getBEB00730T01(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
//	    SepoaFormater sf           = null;
//	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
//	    Object[]      obj          = null;
	    Map<String, String> header = this.getHeader(gdReq, info);
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{    	
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
//	    	value    = ServiceConnector.doService(info, "p1003", "CONNECTION","getCatalog", obj);
	    	
	    	String[] data = {"WOORI"};
	    	Object[] obj = {data};
	    	SepoaOut value = ServiceConnector.doService(info, "AD_102", "CONNECTION","getDis", obj);
	    	SepoaFormater wf = new SepoaFormater(value.result[0]);
	    	String RCPE_BZNO                = "" ;
	    	if(wf.getRowCount() > 0) {
	            for(int i=0;i<wf.getRowCount();i++){
	            	RCPE_BZNO                = wf.getValue("IRS_NO"               , 0) ;	    			
	            }
	        }
	    	
//	    	isStatus = value.flag;
	    	isStatus = true;
	    	
            header.put("SPLPE_BZNO", JSPUtil.CheckInjection(header.get("irs_no")));
            header.put("INQ_BAS_DT", SepoaString.getDateUnSlashFormat(JSPUtil.CheckInjection(header.get("std_date"))));
//          header.put("RCPE_BZNO" , "1058528542" );
            header.put("RCPE_BZNO" , RCPE_BZNO );
            //2018102819 - 리얼 우리은행 공급자사업자번호   ASIS 2017-07-01
            //1058528765 - 테스트 우리은행 공급자사업자번호 ASIS 2017-07-01
            //1058528542 - 테스트 개발 우리은행 공급자사업자번호 TOBE 2017-07-01 (변원상C) <= 이게 맞을듯
            //1248193139 - 테스트 개발 우리은행 공급자사업자번호 TOBE 2017-07-01 (박정수C)
	
	    	if(isStatus){
	    		gdRes    = this.et_getBEB00730T01(header, gdRes);
		    	gdResMessage = message.get("MESSAGE.0001").toString();
		    	
		    	//TOBE 2017-07-01 추가 온라인 전문 로그
		    	Logger.sys.println("BEB00730T01 gdRes.getStatus() : " + gdRes.getStatus());
		    	if(("-1").equals(gdRes.getStatus())) { //정상
		    		this.insertSinfhd(info, "BEB00730T01", "Y", gdResMessage); //interface 입력
		    	} else { //실패
		    		this.insertSinfhd(info, "BEB00730T01", "N", gdResMessage); //interface 입력
		    	}
	    	}
	    	else{
	    		//gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}

	/**
     * 전자세금계산서명세조회 
     * et_getBEB00730T01
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    private GridData et_getBEB00730T01(Map<String, String> header, GridData gdRes) throws Exception {
		String SPLPE_BZNO        = null;
		String INQ_BAS_DT        = null; 
		String RCPE_BZNO         = null;
		String UID               = null;
		String data_tot_size     = null;
	    
		String              BKCD         = null;
		String              BRCD         = null; 
		String              TRMBNO       = null;
		String              USERTERMNO   = null;
		String              TERMNO9      = null;
		String              addUserId    = null;

		Configuration conf       = new Configuration();
	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
		
	   	SPLPE_BZNO               = header.get("SPLPE_BZNO");
	   	INQ_BAS_DT               = header.get("INQ_BAS_DT");
	   	RCPE_BZNO                = header.get("RCPE_BZNO");
	   	UID                      = header.get("req_user_id");
	   	
	   	/* ASIS 2017-07-01
	   	if(header.get("user_trm_no").length() >= 9){
			BKCD       = header.get("user_trm_no").substring(0,  5);
			BRCD       = header.get("user_trm_no").substring(5,  6); 
			TRMBNO     = header.get("user_trm_no").substring(6,  9);
			USERTERMNO = header.get("user_trm_no").substring(9,  10);
			TERMNO9    = header.get("user_trm_no").substring(0,  9);
			addUserId  = header.get("user_trm_no").substring(10, 18);
		}
		
	   	BEB00730T01 n01 = new BEB00730T01();
		
//		data_tot_size    = String.format("%05d", n01.SEND.iTLen-20)+"000000";		    					  //00433000000
		//ASIS 2017-07-01 data_tot_size    = String.format("%05d", n01.SEND.iTLen-20);		    					  //00433000000
	   	
		
		
		/* ASIS 2017-07-01
		n01.SEND.IMHD = "<IM>";    	// C4    전문내용시작태그     	
		n01.SEND.IMFL       = data_tot_size;                                        // C11  FILLER    IM제외 전문길이(5) + '000000'	//"00041";                                        // C11  FILLER    IM제외 전문길이(5) + '000000'
		n01.SEND.TRDT       = "";//SepoaDate.getShortDateString();                       // 2.  C8    거래일자  "20141216"
		n01.SEND.MSG_DSCD   = "010";   // 세금계산서 명세조회
		n01.SEND.SPLPE_BZNO = SPLPE_BZNO;    
		n01.SEND.RCPE_BZNO  = RCPE_BZNO;     
		n01.SEND.INQ_STA_NO = "00001";
		n01.SEND.INQ_END_NO = "00100";
		n01.SEND.INQ_BAS_DT = INQ_BAS_DT;	
		n01.SEND.IMED       = "</IM>"; // C4    전문내용종료태그     						
		
		n01.SEND.bizHdr.BK_CD         = BKCD;                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "20644"                                               
		n01.SEND.bizHdr.BR_CD         = BRCD;                //(1)  WooriDevice.dll에서단말번호가져옴-> "C"                                                            
        n01.SEND.bizHdr.TRM_BNO       = TRMBNO;              //(3)  PDA의단말번호는'20481'->  "004"                                                                   
        n01.SEND.bizHdr.USER_TRM_NO   = USERTERMNO;          //(1)  사용자단말번호 "5"                                                                                
        n01.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호 행번
		*/
		
	   	int rtn = 0;
		
        /* TOBE 2017-07-01 */	   	
	   	if(header.get("user_trm_no").length() >= 12){
			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
		}

	   	BEB00730T01 n01 = new BEB00730T01();
	   	
		n01.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n01.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n01.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n01.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호

	   	data_tot_size    = String.format("%07d", n01.SEND.iTLen-10); // 데이터부 데이터길이 -10
	    //System.out.println("data_tot_size:"+data_tot_size+"|");
		
		n01.SEND.DAT_KDCD   = "DTI";           //데이타헤더부 : (문자3)  데이터종류코드	      
		n01.SEND.DAT_LEN    = data_tot_size;   //데이타헤더부 : (숫자7)  데이터길이
		
		n01.SEND.TLM_DSCD   = "010";           //1. S3    전문구분코드 , 010: 세금계산서 명세조회
		n01.SEND.INQ_STA_NO = "00001";         //2. N5    조회시작번호
		n01.SEND.INQ_END_NO = "00100";         //3. N5    조회종료번호   
		n01.SEND.SPLPE_BZNO = SPLPE_BZNO;      //4. S10   공급자사업자등록번호  
		n01.SEND.SUPPE_BZNO = RCPE_BZNO;       //5. S10   공급받는자사업자등록번호  
		n01.SEND.INQ_BAS_DT = INQ_BAS_DT;	   //6. S8    조회기준일자  
		
		
        n01.pay_act_no = header.get("RCPE_BZNO");
        
		try {
			int iret = n01.sendMessage("BEB00730T01",send_ip,send_port);
			if(iret == ONCNF.D_OK) {
				n01.ORECV.log(ONCNF.LOGNAME, "R");
				
				if(n01.ORECV.R_CODE.trim().equals("0000000")){
					for(int i = 0; i < n01.ORECV.list_beb00730t01_r.size();i++) {
						LIST_BEB00730T01_R list = (LIST_BEB00730T01_R) n01.ORECV.list_beb00730t01_r.get(i);

						/* ASIS 2017-07-01 
						gdRes.addValue("SELECTED"     ,  "0"                   );
						gdRes.addValue("TAA_APV_NO"   ,  list.TAA_APV_NO       );
						gdRes.addValue("ISU_DT"       ,  list.ISU_DT           );
						gdRes.addValue("RGS_BRCD"     ,  list.RGS_BRCD         );
						gdRes.addValue("RGS_DT"       ,  list.RGS_DT           );
						gdRes.addValue("RGS_SRNO"     ,  list.RGS_SRNO         );
						gdRes.addValue("EXE_AM"       ,  list.EXE_AM           );
						gdRes.addValue("SPL_AM"       ,  list.SPL_AM           );
						gdRes.addValue("TAX_AM"       ,  list.TAX_AM           );
						gdRes.addValue("RGS_DSCD"     ,  list.RGS_DSCD         );
						gdRes.addValue("PAY_RSN"      ,  list.PAY_RSN          );
						*/
						
						/* TOBE 2017-07-01 */
						gdRes.addValue("SELECTED"     ,  "0"                   );
			            gdRes.addValue("TAA_APV_NO"   ,  list.NTS_BILL_APV_NO  );  //2.  S24     국세청계산서승인번호      
			            gdRes.addValue("ISU_DT"       ,  list.EVDCD_ISSU_DT    );  //4.  S8      증빙서발행일자            
			            gdRes.addValue("RGS_BRCD"     ,  list.BGT_BRCD         );  //3.  S6      예산점코드                
						gdRes.addValue("RGS_DT"       ,  list.TXBIL_RGS_DT     );  //5.  S8      (세금)계산서등록일자      
						gdRes.addValue("RGS_SRNO"     ,  list.TXBIL_RGS_SRNO   );  //6.  N5      (세금)계산서등록일련번호  
						gdRes.addValue("EXE_AM"       ,  list.BGT_EXU_AM       );  //7.  D19     예산집행금액              
						gdRes.addValue("SPL_AM"       ,  list.SPL_AM           );  //8.  D19     공급금액                  
						gdRes.addValue("TAX_AM"       ,  list.EVDCD_TAXM       );  //9.  D19     증빙서세액                
						gdRes.addValue("RGS_DSCD"     ,  list.EVDCD_DAT_DSCD   );  //10. S1      증빙서데이터구분코드      
						gdRes.addValue("PAY_RSN"      ,  list.XPN_PAY_RSN_TXT  );  //11. S100    지경비지급사유내용        
						
					}
				}
				else{
					gdRes.setMessage(n01.ORECV.R_CODE.trim());
				}
			}
			else {
				throw new Exception();
			}
		}
		catch (Exception e) {
//			e.printStackTrace();
			rtn = -1;
		}
		
    	return gdRes;
	}


    @SuppressWarnings({ "rawtypes" })
	private GridData setBEB00730T02(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Map<String, String> header = this.getHeader(gdReq, info);
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	    boolean       isStatus2    = false;
	    String        resultFlag   = null;
	    
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	Object[] obj = {header};
	    	value    = ServiceConnector.doService(info, "TX_012", "CONNECTION","getSpy2List", obj);
	    	isStatus = value.flag;
			
	    	gdRes.addParam("mode", "doSave");
	    	
	    	
	    	
	    	if(isStatus){
	    		
	    		//gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		//gdRes.setStatus("false");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 1){
		    		
		    		header.put("VENDOR_CODE"          ,  sf.getValue("VENDOR_CODE",0));
		    		header.put("STD_DATE"             ,  SepoaString.getDateUnSlashFormat( sf.getValue("STD_DATE",0)) );
		    		header.put("DEPOSITOR_NAME"       ,  sf.getValue("DEPOSITOR_NAME",0));
		    		header.put("BANK_CODE"            ,	 sf.getValue("BANK_CODE",0));
		    		header.put("BANK_ACCT"            ,  sf.getValue("BANK_ACCT",0));
		    		header.put("SUPPLY_AMT"           ,  sf.getValue("SUPPLY_AMT",0));
		    		header.put("TAX_AMT"              ,  sf.getValue("TAX_AMT",0));
		    		header.put("TOT_AMT"              ,  sf.getValue("TOT_AMT",0));
		    		header.put("BMSBMSYY"             ,  sf.getValue("BMSBMSYY",0));
		    		header.put("BUGUMCD"              ,  sf.getValue("BUGUMCD",0));
		    		header.put("ACT_DATE"             ,  SepoaString.getDateUnSlashFormat( sf.getValue("ACT_DATE",0)) );
		    		header.put("EXPENSECD"            ,  sf.getValue("EXPENSECD",0));
		    		header.put("SEMOKCD"              ,  sf.getValue("SEMOKCD",0));
		    		header.put("SAUPCD"               ,	 sf.getValue("SAUPCD",0));
		    		header.put("DOC_TYPE"             ,	 sf.getValue("DOC_TYPE",0));
		    		header.put("PAY_TYPE"             ,	 sf.getValue("PAY_TYPE",0));
		    		header.put("PAY_REASON"           ,  sf.getValue("PAY_REASON",0));
		    		header.put("TAX_NO"               ,  sf.getValue("TAX_NO",0));
		    		header.put("NTS_APP_NO"           ,  sf.getValue("NTS_APP_NO",0));
		    		header.put("ACC_TAX_DATE"         ,  SepoaString.getDateUnSlashFormat( sf.getValue("ACC_TAX_DATE",0)) );
		    		header.put("ACC_TAX_SEQ"          ,  sf.getValue("ACC_TAX_SEQ",0));
		    		header.put("APP_STATUS_CD"        ,  sf.getValue("APP_STATUS_CD",0));
		    		header.put("ADD_DATE"             ,  sf.getValue("ADD_DATE",0));
		    		header.put("ADD_TIME"             ,  sf.getValue("ADD_TIME",0));
		    		header.put("ADD_USER_ID"          ,  sf.getValue("ADD_USER_ID",0));
		    		header.put("ISU_DT"               ,  sf.getValue("ISU_DT",0));
		    		header.put("SEBUCD"               ,  sf.getValue("SEBUCD",0));
		    		header.put("ZIPHANGCD"            ,  sf.getValue("ZIPHANGCD",0));
		    		header.put("VENDOR_NAME"          ,  sf.getValue("VENDOR_NAME",0));
		    		header.put("IRS_NO"               ,  sf.getValue("IRS_NO",0));
		    		
		    		String  rtn   = this.et_setBEB00730T02(info, header);
			    	//gdResMessage = message.get("MESSAGE.0001").toString();
		    	    
		    		
		    		if(rtn.length() > 3 && !"ERR".equals(rtn.substring(0,3))){
		    			header.put("PYDTM_APV_NO", rtn);
		    			
		    			value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setPydtmApvNoUpdate", obj);
		        		isStatus2 = value.flag;
		        		resultFlag = "Y";
		        		
		        		if(isStatus2) {
//		        			gdResMessage = message.get("MESSAGE.0001").toString();
		        			gdResMessage = rtn+": 지급결의승인번호가 발급되었습니다.";
		        			//gdRes.addParam("mode", "beb00730t02");
		        			
		        		}
		        		else {
		        			throw new Exception();
		        		}
		    		}else{
		    			gdResMessage = rtn;
		    			resultFlag = "N";
		    			//gdRes.addParam("mode", "beb00730t02");
		    		}
		    		
		    		
			    	//TOBE 2017-07-01 추가 온라인 전문 로그
			    	this.insertSinfhd(info, "BEB00730T02", resultFlag, gdResMessage); //interface 입력
		    		
		    		
		    	}else{
		    		throw new Exception();
		    	}
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	gdRes.setSelectable(false);
	    	isStatus     = true;	
	    }
	    catch (Exception e){
	    	
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    finally{
	    	gdRes.addParam("mode", "beb00730t02");
	    	gdRes.setMessage(gdResMessage);
	    	gdRes.setStatus(Boolean.toString(isStatus));
	    }
	    return gdRes;
	}

	/**
     * 경비지급결의 
     * et_setBEB00730T02
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    private String et_setBEB00730T02(SepoaInfo info, Map<String, String> header) throws Exception {
		
    	String result               = null;
		String data_tot_size       = null;
		
		String              BKCD         = null;
		String              BRCD         = null; 
		String              TRMBNO       = null;
		String              USERTERMNO   = null;
		String              TERMNO9      = null;
		String              addUserId    = null;
		
		Configuration conf       = new Configuration();
	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
		
	   	
	   	
	   	/* ASIS 2017-07-01
	   	if(header.get("user_trm_no").length() >= 9){
			BKCD       = header.get("user_trm_no").substring(0,  5);
			BRCD       = header.get("user_trm_no").substring(5,  6); 
			TRMBNO     = header.get("user_trm_no").substring(6,  9);
			USERTERMNO = header.get("user_trm_no").substring(9,  10);
			TERMNO9    = header.get("user_trm_no").substring(0,  9);
			addUserId  = header.get("user_trm_no").substring(10, 18);
		}
	   	   	
		BEB00730T02 n02 = new BEB00730T02();

		data_tot_size    = String.format("%05d", n02.SEND.iTLen-20);		    					  //00433000000

		n02.SEND.IMHD = "<IM>";    	// C4    전문내용시작태그     	
		n02.SEND.IMFL       = data_tot_size;                                        // C11  FILLER    IM제외 전문길이(5) + '000000'	//"00041";                                        // C11  FILLER    IM제외 전문길이(5) + '000000'
		n02.SEND.TRDT       = "";//SepoaDate.getShortDateString();                       // 2.  C8    거래일자  "20141216"
		n02.SEND.MSG_DSCD         = "020";
		n02.SEND.MSG_UNQ_ID_NO    = header.get("pay_act_no");		        //"0202015000000004";
		n02.SEND.BGT_YR           = header.get("BMSBMSYY");			        // "2015";
		n02.SEND.BR_CD            = header.get("BUGUMCD");			        //"20644";
		n02.SEND.DTM_DT           = header.get("ACT_DATE");					//"20150114";
		n02.SEND.XPN_CD           = header.get("EXPENSECD");				//"211200";
		n02.SEND.TAITM_CD         = header.get("SEMOKCD");					//"211202";
//		n02.SEND.TAITM_CD         = header.get("SEMOKCD").length() == 0 ? header.get("EXPENSECD") : header.get("SEMOKCD");					//"211202";
		n02.SEND.BIZ_CD           = header.get("SAUPCD");					//"900";
		n02.SEND.DTM_DSCD         = "1";					                //"1";
		n02.SEND.CSHTF_DSCD       = header.get("PAY_TYPE");					//"2";
		n02.SEND.EXE_AM           = String.format("%013d",Integer.parseInt(header.get("TOT_AMT")));					//"0000002570454";
		n02.SEND.XPN_CRT_DSCD     = header.get("DOC_TYPE");					//"9";
		n02.SEND.XPN_ACT_RPSPE_NM = info.getSession("NAME_LOC");			//"장태준";
		n02.SEND.XPN_ACT_PE_CN    = "0000";									//"0000";
		n02.SEND.TXBIL_PT_GBN     = "2";									//"2";
		n02.SEND.XPN_DTL_CD       = header.get("SEBUCD");					//"2163010101";   //추가 XPN_CD = 20150114
		n02.SEND.XPN_PLC_CD       = header.get("ZIPHANGCD");				//"2000695";				//추가
		n02.SEND.PAY_RRCV_RSN_TXT = header.get("PAY_REASON");				//"테스트..";
		n02.SEND.MAKE_CN          = "01";									//"01";
		n02.SEND.SER_NO           = "001";									//"001";
		n02.SEND.PAY_AM           = String.format("%013d",Integer.parseInt(header.get("SUPPLY_AMT")));				//"0000002336778";
		n02.SEND.ADD_TAX          = String.format("%010d",Integer.parseInt(header.get("TAX_AMT")));					//"0000233676";
		n02.SEND.TRF_BK_CD        = header.get("BANK_CODE");				//"020";
		n02.SEND.TRF_ACNO_TXT     = header.get("BANK_ACCT");				//"1002467114810";
		n02.SEND.WCRT_ISU_DT	  = header.get("ISU_DT");					//"20131231"; //추가 ISU_DT
		n02.SEND.BIZ_NO           = header.get("IRS_NO");					//
		n02.SEND.BIZ_NM           = header.get("VENDOR_NAME");				//"테스트업체";
		n02.SEND.RCPCO_BIZ_NO	  = header.get("");					        //"";  //추가
		n02.SEND.RCPCO_NM	      = header.get("");					        //"";  //추가
		n02.SEND.RCP_RSN_TXT      = header.get("");					        //"";  //추가
		n02.SEND.RCPPE_NM         = header.get("");					        //"";
		n02.SEND.RGS_DT           = header.get("ACC_TAX_DATE");				//"20150106";		//"20131231" RGS_DT
		n02.SEND.RGS_SER_NO       = header.get("ACC_TAX_SEQ");				//"00206";		//"00703"
		n02.SEND.IMED             = "</IM>"; // C4    전문내용종료태그     	
		
		//n02.SEND.bizHdr.UID       = header.get("ADD_USER_ID");
		
		n02.SEND.bizHdr.BK_CD         = BKCD;                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "20644"                                               
        n02.SEND.bizHdr.BR_CD         = BRCD;                //(1)  WooriDevice.dll에서단말번호가져옴-> "C"                                                            
        n02.SEND.bizHdr.TRM_BNO       = TRMBNO;              //(3)  PDA의단말번호는'20481'->  "004"                                                                   
        n02.SEND.bizHdr.USER_TRM_NO   = USERTERMNO;          //(1)  사용자단말번호 "5"                                                                                
        n02.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호                                                             
        */
	   	
	   	
        /* TOBE 2017-07-01 */	   	
	   	if(header.get("user_trm_no").length() >= 12){
			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
		}

	   	BEB00730T02 n02 = new BEB00730T02();

	   	
	   	data_tot_size    = String.format("%07d", n02.SEND.iTLen-10); // 데이터부 데이터길이 -10
		
		n02.SEND.DAT_KDCD   = "DTI";           //데이타헤더부 : (문자3)  데이터종류코드	      
		n02.SEND.DAT_LEN    = data_tot_size;   //데이타헤더부 : (숫자7)  데이터길이
		
		n02.SEND.TLM_DSCD               = "020";                        //1.   S3         전문구분코드                
		n02.SEND.TLM_UNQ_IDF_NO   	    = header.get("pay_act_no");     //2.   S16        전문고유식별번호            
		n02.SEND.BGT_YY                 = header.get("BMSBMSYY");       //3.   S4         예산년도                    
		n02.SEND.BGT_BRCD               = header.get("BUGUMCD");        //4.   S6         예산점코드                  
		n02.SEND.PAY_DTMN_DT            = header.get("ACT_DATE");       //5.   S8         지급결의일자                
		n02.SEND.BGT_XPN_CD             = header.get("EXPENSECD");      //6.   S6         예산경비코드                
		n02.SEND.BGT_ITTX_CD            = header.get("SEMOKCD");        //7.   S6         예산세목코드                
		n02.SEND.BGT_BZN_CD             = header.get("SAUPCD");         //8.   S3         예산사업코드                
		n02.SEND.BGT_DTMN_DSCD          = "1";                          //9.   S1         예산결의구분코드            
		n02.SEND.CSHTF_DSCD             = header.get("PAY_TYPE");       //10.  S1         현금대체구분코드            
		n02.SEND.EXU_AM                 = String.format("%015d",Long.parseLong(header.get("TOT_AMT")));    //11.  D15        집행금액                    
		n02.SEND.EXPD_EVDC_DSCD         = "0"+header.get("DOC_TYPE");   //12.  S2         지출증빙구분코드 (2017-07-01 ASIS '9' -> TOBE '09')            
		n02.SEND.XPN_PAY_RSN_TXT        = header.get("PAY_REASON");     //13.  S100       경비지급사유내용            
		n02.SEND.ELT_TXBIL_PTPY_YN      = "N";                          //14.  S1         전자세금계산서분할지급여부 (2017-07-01 ASIS '2' -> TOBE 'N')  
		n02.SEND.XPN_BGT_DTLS_CD        = header.get("SEBUCD");         //15.  S10        경비예산세부코드            
		n02.SEND.EXU_TGT_PLC_CD         = header.get("ZIPHANGCD");      //16.  S7         집행대상장소코드            
		n02.SEND.GRID_ROW_CNT           = "00001";                      //17.  N5         그리드열건수                
		n02.SEND.BGT_PAY_DTMN_SRNO      = "001";                        //18.  N3         예산지급결의일련번호        
		n02.SEND.SPL_AM                 = String.format("%015d",Long.parseLong(header.get("SUPPLY_AMT"))); //19.  D15        공급금액                    
		n02.SEND.VAT                    = String.format("%015d",Long.parseLong(header.get("TAX_AMT")));	 //20.  D15        부가세                      
		n02.SEND.RCV_BKCD               = header.get("BANK_CODE");      //21.  S3         입금은행코드                
		n02.SEND.RCV_BKW_ACNO           = header.get("BANK_ACCT");      //22.  S20        입금전행계좌번호            
		n02.SEND.EVDCD_ISSU_DT          = header.get("ISU_DT");         //23.  S8         증빙서발행일자              
		n02.SEND.PYCO_BZNO              = header.get("IRS_NO");         //24.  S10        지급처사업자등록번호        
		n02.SEND.XPN_PYCO_NM            = header.get("VENDOR_NAME");    //25.  S100       경비지급처명                
		n02.SEND.RPTNL_BZNO             = header.get("");               //26.  S10        접대처사업자등록번호        
		n02.SEND.RPTNL_NM               = header.get("");               //27.  S40        접대처명                    
		n02.SEND.RPTN_RSN_TXT           = header.get("");               //28.  S100       접대사유내용                
		n02.SEND.ALL_RCVDP_TXT          = header.get("");               //29.  S4000      전체접대받는자내용          
		n02.SEND.RCVDP_CPE_CN           = header.get("");               //30.  N6         접대받는자인원수            
		n02.SEND.ALL_RCPPE_TXT          = info.getSession("NAME_LOC");  //31.  S4000      전체접대자내용              
		n02.SEND.RCPPE_CPE_CN           = "000000";                     //32.  N6         접대자인원수                
		n02.SEND.TXBIL_RGS_DT           = header.get("ACC_TAX_DATE");   //33.  S8         세금계산서등록일자          
		n02.SEND.TXBIL_RGS_SRNO         = header.get("ACC_TAX_SEQ");    //34.  N5         세금계산서등록일련번호
		
		n02.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n02.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n02.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n02.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
		
        n02.pay_act_no = header.get("pay_act_no");
        
		try {
			int iret = n02.sendMessage("BEB00730T02",send_ip,send_port);
			if(iret == ONCNF.D_OK) {
				n02.RECV.log(ONCNF.LOGNAME, "");	
				//ASIS 2017-07-01 result = n02.RECV.PYDTM_APV_NO;
				//TOBE 2017-07-01
				result = n02.RECV.PAY_DTMN_APV_NO; //5. N7   지급결의승인번호
				
			}else if(iret == ONCNF.D_ECODE) {
//				System.out.println("ERRCODE = "+n02.RECV.bizHdr.ERRCODE+ONCNF.D_ERR);
//				System.out.println("ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE);
				//ASIS 2017-07-01 result = "ERR:["+n02.RECV.bizHdr.ERRCODE+"]"+n02.eRECV.MESSAGE;
				//TOBE 2017-07-01
				result = "ERR:["+n02.eRECV.msgHdr.MSG_CD+"]"+n02.eRECV.msgHdr.MAIN_MSG_TXT;
			}else {
//				System.out.println("sendMessage call error !!.." + iret);
				result = "ERR:sendMessage call error !!.." + iret;
			}
		}
		catch (Exception e) {
			result = "ERR:sendMessage call error !!..";
			//e.printStackTrace();
		}
		
    	return result;
	}

    
	/**
     * 책임자 지정 
     * setSignerDefine
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-03-19
     * @modify 2015-03-19
     */
    @SuppressWarnings({ "rawtypes"})
    private GridData setSignerUpdate(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	Map<String, Object> header  = null;
    	
    	try {
    		message  = this.getMessage(info);
        	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
        	Object[] obj = {allData};
        	
        	header        = MapUtils.getMap(allData, "headerData");
        	
    		value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setSignerUpdate", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "setSignerUpdate");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }

    

    
	/**
     * 1차책임자승인 
     * updateSpy2glSigner1
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-03-19
     * @modify 2015-03-19
     */
    @SuppressWarnings({ "rawtypes"})
    private GridData updateSpy2glSigner1(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	//Object[] obj          = null;
    	String   gdResMessage = null;
    	String   payActNo   = null;
    	String   payActBio   = null;
    	String   txtMnno      = null;
    	String   rcvMsg       = null; 
    	String   id           = null;
    	String   resultFlag   = null;
    	//ASIS 2017-07-01 BioGW    bio          = null;
    	String   bioEnc       = null;
    	String   gate_tot_size = null;
    	String   data_tot_size = null;
    	boolean  isStatus     = false;
    	Map<String, Object> header  = null;
    	
    	try {
    		
    		message    = this.getMessage(info);
    		payActNo = JSPUtil.CheckInjection(gdReq.getParam("PAY_ACT_NO"));
    		txtMnno    = JSPUtil.CheckInjection(gdReq.getParam("TXT_MNNO"));
    		payActBio = JSPUtil.CheckInjection(gdReq.getParam("PAY_ACT_BIO"));
    		id         = info.getSession("ID");
    		
    		Logger.debug.println("payActNo : >" + payActNo + "<");
    		Logger.debug.println("txtMnno : >" + txtMnno + "<");
			Logger.debug.println("id : >" + id + "<");
			//Logger.debug.println("payActBio : >" + payActBio + "<");
    		


        	/*------------------------- TOBE 2017-07-01 암호화 ---------------------------*/
			bioEnc = bioEnc(payActBio);
        	/*---------------------------------------------------------------------------*/
        	
    		
    		//ASIS 2017-07-01 bio = new Bio.BioGW();
    		//TOBE 2107-07-01
    		CMT90040100 bio = new CMT90040100();
    		
			
			//TOBE 2107-07-01
			gate_tot_size    = String.format("%08d", bio.SEND.sysHdr.iTLen+bio.SEND.trnHdr.iTLen+bio.SEND.iTLen + 2 -8); // 전문전체길이+(종료'@@') -8
			data_tot_size    = String.format("%07d", bio.SEND.iTLen-10); // 데이터부 데이터길이 -10		
				
		   	bio.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
	    	
		   	bio.SEND.trnHdr.TRM_BRNO      = txtMnno.substring(0, 6); //단말점번호    
		   	bio.SEND.trnHdr.TRN_TRM_NO    = txtMnno;                 //단말번호
		   	bio.SEND.trnHdr.DL_BRCD       = txtMnno.substring(0, 6); //취급점번호    
		   	bio.SEND.trnHdr.OPR_NO        = id;                      //조작자번호
	        
		   	bio.SEND.DAT_KDCD               = "DTI";                 //데이타헤더부 : (문자3)  데이터종류코드	       
		   	bio.SEND.DAT_LEN                = data_tot_size;         //데이타헤더부 : (숫자7)  데이터길이
		   	bio.SEND.CRTF_DSCD              = "2";                   //1.   S1         인증구분코드 (1:비밀번호, 2:지문, 3:본출납지문)               
		   	bio.SEND.RLPE_ENO   	        = id;                    //2.   S8         책임자직원번호          
		   	bio.SEND.SHA256_RLPE_APV_PWNO   = "";                    //3.   S64        SHA256책임자승인비밀번호              
		   	bio.SEND.RLPE_GDCD              = "10";                  //4.   S2         책임자등급코드 (10:책임자)          
		   	bio.SEND.MSG_CD                 = "";                    //5.   S10        메시지코드       
		   	bio.SEND.FPCTF_ENCY_DAT_TXT     = bioEnc;                //6.   S1344      지문인증암호화데이터내용           
		   	bio.SEND.SPR                    = "";                    //7.   S100       예비   
			
			
		   	bio.send_no = JSPUtil.CheckInjection(gdReq.getParam("PAY_ACT_NO"));
		   	
			Configuration conf = new Configuration();
			
			String send_ip = conf.get("sepoa.interface.tcpip.ip");
			int send_port  = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
			ONCNF.LOGDIR   = conf.get("sepoa.logger.dir");
			
			
			
			
			/* ASIS 2107-07-01
			rcvMsg     = bio.getEmpInfo(txtMnno, id, payActBio, "", "4");
    		Logger.debug.println("rcvMsg : >" + rcvMsg + "<");
    		*/
			
			Logger.sys.println("CMT90040100 PAY_BD_INS2  2");
			
			int iret = bio.sendMessage("CMT90040100", send_ip, send_port); //개발
			Logger.sys.println("CMT90040100 PAY_BD_INS2  3");

			//if(iret == ONCNF.D_OK) {
				rcvMsg     = bio.getrcvTxt();
	    		resultFlag = bio.getResultFlag();
			//}

    		
    		if("Y".equals(resultFlag)){
    			isStatus = true;
    		}
    		else{
    			isStatus = false;
    		}
    		
			Logger.debug.println("rcvMsg : >" + rcvMsg + "<");
			Logger.debug.println("resultFlag : >" + resultFlag + "<");
			Logger.debug.println("isStatus : >" + isStatus + "<");
			
			this.insertSinfhd(info, "CMT90040100", resultFlag, rcvMsg); //interface 입력
			
			Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
			header.put("pay_act_no", payActNo);
	    	
			Object[] obj = {header};
        	
    		if(isStatus) {
    			//obj      = this.updateSpy1gInfoBeforeSignObj(gdReq, info);

            	
        		value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "updateSpy2glSigner1", obj);
        		isStatus = value.flag;
        		
        		if(isStatus) {
        			gdResMessage = this.successJson();
        		}
        		else{
        			throw new Exception(message.get("MESSAGE.1002").toString());
        		}
    		}
    		else{
    			throw new Exception(rcvMsg);
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = e.getMessage();
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    
    
    
	/**
     * 경비집행 
     * setBEB00730T03
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    @SuppressWarnings({ "rawtypes" })
	private GridData setBEB00730T03(GridData gdReq, SepoaInfo info, String signerStatus) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Map<String, String> header = this.getHeader(gdReq, info);
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	    boolean       isStatus2    = false;
	    String        resultFlag   = null;
	    
	    String           payActNo   = null;
	    String           payActBio   = null;
	    String           txtMnno      = null;
	    String           executeNo      = null;
	    
	    double                    exe_try_term = 0.0;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	//===================================중복 실행 체크1============================================    		 		    		
    		TimeUnit.MILLISECONDS.sleep((long)(Math.random() * (2000 - 0 + 1) + 0)); // 2000 millisecond ~ 0 millisecond
    		//=========================================================================================
	    	Object[] obj = {header};
	    	value    = ServiceConnector.doService(info, "TX_012", "CONNECTION","getSpy2List", obj);
	    	isStatus = value.flag;
	    	gdRes.addParam("mode", "dosave");
	    	gdRes.setSelectable(false); // dosave insert update delete 용
			
	    	if(isStatus){
	    		
	    		//gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		//gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		    	if(rowCount == 1){
		    		header.put("BIO_STR"              ,  header.get("pay_act_bio"));
		    		header.put("PAY_ACT_NO"           ,  "030"+sf.getValue("PAY_ACT_NO",0).substring(3));
		    		header.put("BMSBMSYY"             ,  sf.getValue("BMSBMSYY",0));
		    		header.put("BUGUMCD"              ,  sf.getValue("BUGUMCD",0));
		    		header.put("PYDTM_APV_NO"         ,  sf.getValue("PYDTM_APV_NO",0));
		    		header.put("EXPENSECD"            ,  sf.getValue("EXPENSECD",0));
		    		header.put("TOT_AMT"              ,  sf.getValue("TOT_AMT",0));
		    		header.put("ADD_USER_ID"          ,  sf.getValue("ADD_USER_ID",0));
		    		header.put("TAX_NO"               ,  sf.getValue("TAX_NO",0));
		    		header.put("EXECUTE_NO"           ,  sf.getValue("EXECUTE_NO",0));
		    		//USER_TRM_NO
		    		
		    		//===================================중복 실행 체크2============================================
		    		value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "updateSpy2glExeTryDt", obj);
		    		isStatus2 = value.flag;	        		
	        		if(!isStatus2) {
	        			throw new Exception();
	        		}	        		
		    		exe_try_term = Double.parseDouble(sf.getValue("EXE_TRY_TERM",0));    		
		    		if(exe_try_term < 90 ){		    			
//		    			Logger.info.println("중복집행TRY / 경상비 지급번호 - " + header.get("pay_act_no") + " / 실행TRY텀 - " + exe_try_term);
//		    			throw new Exception("중복집행TRY - 2분후 다시 시도 해 보세요.");		    			
		    			Logger.info.println("중복집행TRY / 경상비 지급번호 - " + header.get("pay_act_no") + " / 실행TRY텀 - " + exe_try_term);
		    			throw new Exception("중복집행TRY / 경상비 지급번호 - " + header.get("pay_act_no") + " /클라이언트 - " + JSPUtil.CheckInjection(header.get("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 실행TRY텀 - " + exe_try_term);
		    		}
//		    		if(exe_try_term >= 90 ){
//		    			throw new Exception("집행완료 / 지급번호 - " + header.get("pay_act_no") + " /클라이언트 - " + JSPUtil.CheckInjection(header.get("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 실행TRY텀 - " + exe_try_term);		    			
//		    		}
		    		//==========================================================================================
		    				    			    	
		    		if (header.get("pay_act_bio").length()>0){
		    			value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "getUserTrmNo", obj);
		    			SepoaFormater sf1 =   new SepoaFormater(value.result[0]);
		    			header.put("USER_TRM_NO"          ,  sf1.getValue(0,0));
		    		}else{
		    			header.put("USER_TRM_NO"          ,  header.get("user_trm_no"));
		    		}
					
		    		//header.put("USER_TRM_NO"          ,  header.get("user_trm_no"));
		    		
		    		if("2".equals(header.get("signer_status"))){			//TOBE 2017-07-01 2억이상   ,ASIS 1억 이상
		    			//header.put("STATUS_CD", "40");    //TOBE 2017-07-01 1차책임자 승인
		    			header.put("APP_STATUS_CD", "A"); //TOBE 2017-07-01 경비집행
		    		}else if("1".equals(header.get("signer_status"))){		//5천만원 이상
		    			//header.put("STATUS_CD", "30");    //TOBE 2017-07-01 책임자지정
		    			header.put("APP_STATUS_CD", "A"); //TOBE 2017-07-01 경비집행
		    	   	}else{												    //5천만원 미만
		    	   		header.put("STATUS_CD", "90");    //TOBE 2017-07-01 집행완료
		    	   		header.put("APP_STATUS_CD", "F"); //TOBE 2017-07-01 집행완료
		    	   		
		    	   		value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setExecuteNoUpdate", obj);
		        		isStatus2 = value.flag;
		        		
		        		if(!isStatus2) {
		        			throw new Exception();
		        		}
		    	   	}
		    				
		    		String  rtn   = this.et_setBEB00730T03(info, header);
			    	//gdResMessage = message.get("MESSAGE.0001").toString();
		    		
		    		if(rtn.length() > 3 && !"ERR".equals(rtn.substring(0,3))){
		    			header.put("SLIP_NO", rtn);
		    			
		    			value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setSlipNoUpdate", obj);
		        		isStatus2 = value.flag;
		        	    resultFlag = "Y";
		        	    
		        		if(isStatus2) {
//		        			gdResMessage = message.get("MESSAGE.0001").toString();
		        			gdResMessage = rtn+": 경비집행이 성공적으로 처리되었습니다.";
//		        			gdRes.addParam("mode", "beb00730t03");
		        		}
		        		else {
		        			throw new Exception();
		        		}
		        		
		        		
		        		//TOBE 2017-07-01 5천만원 미만일 경우 책임자승인명세가 필요 없으므로 집행완료로 상태를 변경 한다
		        		if( (!"1".equals(signerStatus)) &&  // 5천만원이상
		        			(!"2".equals(signerStatus)) )   // 2억원이상
		           			{
		        				value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setSlipNoUpdateF", obj);
		        				isStatus2 = value.flag;
		        				resultFlag = "Y";
			        		
		        				if(isStatus2) {
		        					gdResMessage = "집행완료가 성공적으로 처리되었습니다.";
		        				}
		        				else {
		        					throw new Exception();
		        				}
		           			}
		        		
		        		isStatus     = true;	
		    		}else{
		    			isStatus     = false;	
		    			gdResMessage = rtn;
		    			resultFlag = "N";
//		    			gdRes.addParam("mode", "beb00730t03");
		    		}
		    		
		    		
			    	//TOBE 2017-07-01 추가 온라인 전문 로그
			    	this.insertSinfhd(info, "BEB00730T03", resultFlag, gdResMessage); //interface 입력
			    	
		    		
		    				    		
		    	}else{
		    		throw new Exception();
		    	} //END if(rowCount == 1)
	    	}
	    	else{
	    		isStatus     = false;	
	    		gdResMessage = value.message;
	    	} //END if(isStatus)
	    	
//	    	gdRes.setSelectable(false);
//	    	isStatus     = true;	
	    }
	    catch (Exception e){
//	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
//	    	isStatus     = false;	  
	    	gdResMessage = e.getMessage();
	    	isStatus     = false;	  
	    }
	    finally{
	    	gdRes.addParam("mode", "beb00730t03");
	    	gdRes.setMessage(gdResMessage);
	    	gdRes.setStatus(Boolean.toString(isStatus));
	    }
	    return gdRes;
	}
    
	/**
     * 경비집행 
     * et_setBEB00730T03
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2015-01-15
     * @modify 2015-01-15
     */
    private String et_setBEB00730T03(SepoaInfo info, Map<String, String> header) throws Exception {
		
    	String result        = null;
        String biz_tot_size    = null;
        String              BKCD         = null;
        String              BRCD         = null; 
        String              TRMBNO       = null;
        String              USERTERMNO   = null;
        String              TERMNO9      = null;
        String              addUserId    = null;
        String              bugumcd      = null;
		Configuration conf       = new Configuration();
	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
	   	
	   	bugumcd         = header.get("BUGUMCD");
		
	   	String paySendBio = null;
        paySendBio = header.get("BIO_STR");
        
	   	/*
	   	if (bugumcd.equals("20644")){
			addUserId  = header.get("ADD_USER_ID");
		} else {
			if(paySendBio.length()>0){
				addUserId  = header.get("EXECUTE_NO");
			} else {
				addUserId  = header.get("USER_TRM_NO").substring(10,  18);
			}
		}   
	   	*/
        
        
        /* ASIS 2017-07-01
	   	if(header.get("USER_TRM_NO").length() >= 9){
			BKCD       = header.get("USER_TRM_NO").substring(0,  5);
			BRCD       = header.get("USER_TRM_NO").substring(5,  6); 
			TRMBNO     = header.get("USER_TRM_NO").substring(6,  9);
			USERTERMNO = header.get("USER_TRM_NO").substring(9,  10);
			TERMNO9    = header.get("USER_TRM_NO").substring(0,  9);
			addUserId  = header.get("USER_TRM_NO").substring(10,  18);
		}
		
	   	BEB00730T03 n03 = new BEB00730T03();
		
		
		

        
		if(paySendBio.length()>0){
			n03.SEND.bioHdr.IBIO =  paySendBio;                        // 1.  C669    지문정보
			n03.SEND.bioHdr.iBioLen =  669;
        }
		
		
		if("2".equals(header.get("signer_status"))){				//1억 이상
			n03.SEND.RE_UID      = header.get("signer1_no"); 			//집행자						
	        n03.SEND.TEMP		 = header.get("signer2_no")+"          "+"100030520";			    //집행자 
	   	}else if("1".equals(header.get("signer_status"))){		//5천만원 이상
	   		n03.SEND.RE_UID         = "        "; 							
	        n03.SEND.TEMP			= header.get("signer1_no")+"          "+"100030014";			    //집행자 
	   	}else{												//5천만원 미만
		    
	   		n03.SEND.RE_UID         = "        "; 							
	        n03.SEND.TEMP			= "                           ";			
	   	}
		
		//n03.SEND.bizHdr.UID    = header.get("execute_no");                //(8)  PDA조작자번호88799999     
		
		n03.SEND.IMHD           = "<IM>";										//추가2015-03-24
		n03.SEND.TRDT           = "";												//추가2015-03-24
		
		n03.SEND.MSG_DSCD         = "030";
		n03.SEND.MGS_UNQ_ID_NO    = header.get("PAY_ACT_NO");		//"0302015000000006";  
		n03.SEND.BGT_YR           = header.get("BMSBMSYY");			//"2015";              
		n03.SEND.BR_CD            = header.get("BUGUMCD");			//"20644";             
		n03.SEND.PYDTM_APV_NO     = header.get("PYDTM_APV_NO");		//"0000770";           
		n03.SEND.XPN_CD           = header.get("EXPENSECD");		//"216300";           
		n03.SEND.EXT_AM           = String.format("%013d",Integer.parseInt(header.get("TOT_AMT")));			//"0000018920000";     
		
		//n03.SEND.RE_UID         = "        "; 									//추가2015-03-24
        //n03.SEND.TEMP			= "19010045      100030001";			//추가2015-03-24
        n03.SEND.IMED           = "</IM>";									//추가2015-03-24
        
		//n03.SEND.bizHdr.UID       = header.get("ADD_USER_ID");
    	n03.SEND.bizHdr.BK_CD         = BKCD;                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "20644"                                               
        n03.SEND.bizHdr.BR_CD         = BRCD;                //(1)  WooriDevice.dll에서단말번호가져옴-> "C"                                                            
        n03.SEND.bizHdr.TRM_BNO       = TRMBNO;              //(3)  PDA의단말번호는'20481'->  "004"                                                                   
        n03.SEND.bizHdr.USER_TRM_NO   = USERTERMNO;          //(1)  사용자단말번호 "5"                                                                                
        n03.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호                                                           

        String gate_tot_size = String.format("%05d", n03.SEND.comHdr.iTLen+n03.SEND.bizHdr.iTLen+n03.SEND.iTLen+n03.SEND.bioHdr.iBioLen);
    	String enabler_tot_size = String.format("%05d", n03.SEND.bizHdr.iTLen+n03.SEND.iTLen+n03.SEND.bioHdr.iBioLen);
        
    	n03.SEND.comHdr.TOT_SIZE = gate_tot_size;
    	n03.SEND.bizHdr.INLEN = enabler_tot_size;
        */
        
        
        /* TOBE 2017-07-01 */	   	
	   	if(header.get("USER_TRM_NO").length() >= 12){
			BKCD       = header.get("USER_TRM_NO").substring(0,  6);      //점코드
			USERTERMNO = header.get("USER_TRM_NO").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("USER_TRM_NO").substring(12);         //조작자번호
		}

	   	BEB00730T03 n03 = new BEB00730T03();
	   	
		if(paySendBio.length()>0){
			n03.SEND.bioHdr.IBIO =  paySendBio;                        // 1.  C669    지문정보
			n03.SEND.bioHdr.iBioLen =  0;  //TOBE 2017-07-01 지문헤더 불필요 (669 => 0 변경)
        }
		
		
		
		/* TOBE 2017-07-01 불필요
		if("2".equals(header.get("signer_status"))){				//TOBE 2017-07-01 2억 이상  (ASIS 1억) 
			n03.SEND.RE_UID      = header.get("signer1_no"); 			//집행자						
	        n03.SEND.TEMP		 = header.get("signer2_no")+"          "+"100030520";			    //집행자 
	   	}else if("1".equals(header.get("signer_status"))){		//5천만원 이상
	   		n03.SEND.RE_UID         = "        "; 							
	        n03.SEND.TEMP			= header.get("signer1_no")+"          "+"100030014";			    //집행자 
	   	}else{												//5천만원 미만
		    
	   		n03.SEND.RE_UID         = "        "; 							
	        n03.SEND.TEMP			= "                           ";			
	   	}
	   	*/
				

	   	String gate_tot_size    = String.format("%08d", n03.SEND.sysHdr.iTLen+n03.SEND.trnHdr.iTLen+n03.SEND.iTLen+n03.SEND.bioHdr.iBioLen + 2 -8); // 전문전체길이+(종료'@@') -8
        String data_tot_size    = String.format("%07d", n03.SEND.iTLen-10); // 데이터부 데이터길이 -10
        
        n03.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
    	
		n03.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n03.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n03.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n03.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호

		n03.SEND.DAT_KDCD             = "DTI";                                                          //데이타헤더부 : (문자3)  데이터종류코드	      
		n03.SEND.DAT_LEN              = data_tot_size;                                                  //데이타헤더부 : (숫자7)  데이터길이
        n03.SEND.TLM_DSCD             = "030";                                                          //1.  S3     전문구분코드                 
        n03.SEND.TLM_UNQ_IDF_NO       = header.get("PAY_ACT_NO");		                                //2.  S16     전문고유식별번호                 //"0302015000000006";  
        n03.SEND.BGT_YY               = header.get("BMSBMSYY");			                                //3.  S4      예산년도                         //"2015";              
        n03.SEND.BGT_BRCD             = header.get("BUGUMCD");			                                //4.  S6      예산점코드                       //"020644";             
        n03.SEND.PAY_DTMN_APV_NO      = header.get("PYDTM_APV_NO");                                     //5.  N7     지급결의승인번호                 //"0000770";           
        n03.SEND.BGT_XPN_CD           = header.get("EXPENSECD");		                                //6.  S6      예산경비코드                     //"216300";           
        n03.SEND.EXU_AM               = String.format("%015d",Long.parseLong(header.get("TOT_AMT")));	//7.  D15     집행금액                     		//"0000018920000";     
        n03.SEND.RLPE_ENO             = header.get("signer1_no");                                       //8.  S8     책임자직원번호               
        n03.SEND.RLPE_ENO_2           = header.get("signer2_no");                                       //9.  S8     책임자직원번호2               

		
        n03.pay_act_no = header.get("PAY_ACT_NO");
        
        
        /* TOBE 2017-07-01 불필요
    	if(n03.SEND.bioHdr.iBioLen > 0){
	    		biz_tot_size    = String.format("%05d", n03.SEND.iTLen - 20 -27);		    					  //00433000000
	    		//TOBE 2017-07-01 불필요 n03.SEND.bizHdr.MGR_BIOAUT_YN =  "Y";                        // 1.  C669    지문정보
	    		//TOBE 2017-07-01 불필요 n03.SEND.bizHdr.MGRAPV_DSCD =  "2";
			}
			else{
				biz_tot_size    = String.format("%05d", n03.SEND.iTLen - 20 );		    					  //00433000000
				//TOBE 2017-07-01 불필요 n03.SEND.bizHdr.MGR_BIOAUT_YN =  "N";                        // 1.  C669    지문정보
				//TOBE 2017-07-01 불필요 n03.SEND.bizHdr.MGRAPV_DSCD =  "1";
			}        
	        
	        //TOBE 2017-07-01 불필요 n03.SEND.IMFL           = biz_tot_size;
	    */
		
		try {
			int iret = n03.sendMessage("BEB00730T03",send_ip,send_port);
			if(iret == ONCNF.D_OK) {
				n03.RECV.log(ONCNF.LOGNAME, "");	
				
				result = n03.RECV.SLIP_NO;
				
			}else if(iret == ONCNF.D_ECODE) {
//				System.out.println("ERRCODE = "+n03.RECV.bizHdr.ERRCODE);
//				System.out.println("ERR:["+n03.RECV.bizHdr.ERRCODE+"]"+n03.eRECV.MESSAGE);
				//ASIS 2017-07-01 result = "ERR:["+n03.RECV.bizHdr.ERRCODE+"]"+n03.eRECV.MESSAGE;
				//TOBE 2017-07-01
				result = "ERR:["+n03.eRECV.msgHdr.MSG_CD+"]"+n03.eRECV.msgHdr.MAIN_MSG_TXT;
			}else {
				//System.out.println("sendMessage call error !!.." + iret);
				result = "ERR:sendMessage call error !!.." + iret;
			}
		}
		catch (Exception e) {
			result = "ERR:sendMessage call error !!.." ;
			//e.printStackTrace();
		}
		
    	return result;
	}

    
    
    
    
    
	/**
     * 책임자승인명세
     * setICAA9010200
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2017-07-01
     * @modify 2017-07-01
     */
    @SuppressWarnings({ "rawtypes" })
	private GridData setICAA9010200(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Map<String, String> header = this.getHeader(gdReq, info);
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	    boolean       isStatus2    = false;
	    String        resultFlag   = null;
	    
	    String           payActNo   = null;
	    String           payActBio   = null;
	    String           txtMnno      = null;
	    String           executeNo      = null;
	    
	  	
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	
	    	Object[] obj = {header};
	    	value    = ServiceConnector.doService(info, "TX_012", "CONNECTION","getSpy2List", obj);
	    	isStatus = value.flag;
	    	gdRes.addParam("mode", "dosave");
	    	
	    	if(isStatus){
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		    	if(rowCount == 1){
		    		header.put("BIO_STR"              ,  header.get("pay_act_bio"));
		    		header.put("PAY_ACT_NO"           ,  "030"+sf.getValue("PAY_ACT_NO",0).substring(3));
		    		header.put("BMSBMSYY"             ,  sf.getValue("BMSBMSYY",0));
		    		header.put("BUGUMCD"              ,  sf.getValue("BUGUMCD",0));
		    		header.put("PYDTM_APV_NO"         ,  sf.getValue("PYDTM_APV_NO",0));
		    		header.put("EXPENSECD"            ,  sf.getValue("EXPENSECD",0));
		    		header.put("TOT_AMT"              ,  sf.getValue("TOT_AMT",0));
		    		header.put("ADD_USER_ID"          ,  sf.getValue("ADD_USER_ID",0));
		    		header.put("TAX_NO"               ,  sf.getValue("TAX_NO",0));
		    		header.put("EXECUTE_NO"           ,  sf.getValue("EXECUTE_NO",0));
		    		header.put("COMPLATE_DATE"        ,  sf.getValue("COMPLATE_DATE",0));
		    		header.put("COMPLATE_TIME"        ,  sf.getValue("COMPLATE_TIME",0));
		    		
		    		
		    		
		    		if (header.get("pay_act_bio").length()>0){
		    			value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "getUserTrmNo", obj);
		    			SepoaFormater sf1 =   new SepoaFormater(value.result[0]);
		    			header.put("USER_TRM_NO"          ,  sf1.getValue(0,0));
		    		}else{
		    			header.put("USER_TRM_NO"          ,  header.get("user_trm_no"));
		    		}
		    		
		    			    				
		    		String  rtn   = this.et_setICAA9010200(info, header);
		    		
		    		if(rtn.length() > 3 && !"ERR".equals(rtn.substring(0,3))){
		    			
		    			value    = ServiceConnector.doService(info, "TX_012", "TRANSACTION", "setSlipNoUpdateF", obj);
		        		isStatus2 = value.flag;
		        		resultFlag = "Y";
		        		
		        		if(isStatus2) {
		        			gdResMessage = "집행완료가 성공적으로 처리되었습니다.";
		        		}
		        		else {
		        			throw new Exception();
		        		}
		        				        		
		    		}else{
		    			gdResMessage = rtn;
		    			resultFlag = "N";
		    		}
		    		
			    	//TOBE 2017-07-01 추가 온라인 전문 로그
			    	this.insertSinfhd(info, "ICAA9010200", resultFlag, gdResMessage); //interface 입력
		    				    		
		    	}else{
		    		throw new Exception();
		    	}
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.setSelectable(false);
	    	isStatus     = true;	
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    finally{
	    	gdRes.addParam("mode", "ICAA9010200");
	    	gdRes.setMessage(gdResMessage);
	    	gdRes.setStatus(Boolean.toString(isStatus));
	    }
	    return gdRes;
	}

	/**
     * 책임자승인명세
     * et_setICAA9010200
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2017-07-01
     * @modify 2017-07-01
     */
    private String et_setICAA9010200(SepoaInfo info, Map<String, String> header) throws Exception {
		
    	String result        = null;
        String biz_tot_size    = null;
        String              BKCD         = null;
        String              BRCD         = null; 
        String              TRMBNO       = null;
        String              USERTERMNO   = null;
        String              TERMNO9      = null;
        String              addUserId    = null;
        String              bugumcd      = null;
        
		//TOBE 2017-07-01 거래로그생성번호 L4 + 지급번호(6~17)
		String              trnLogCreNo   = new StringBuilder().append("SGF").append(header.get("PAY_ACT_NO").substring(5,16)).toString();  
		String              rlpeApvTrnNm  = null;
		String              isApvRncd     = null;

        
		Configuration conf       = new Configuration();
	   	String send_ip           = conf.get("sepoa.interface.tcpip.ip");
	   	int send_port            = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
	   	ONCNF.LOGDIR             = conf.get("sepoa.logger.dir");
	   	
	   	bugumcd         = header.get("BUGUMCD");
        
        
        /* TOBE 2017-07-01 */	   	
//	   	if(header.get("user_trm_no").length() >= 12){
//			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
//			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
//			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
//		}
	   	if(header.get("USER_TRM_NO").length() >= 12){
			BKCD       = header.get("USER_TRM_NO").substring(0,  6);      //점코드
			USERTERMNO = header.get("USER_TRM_NO").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("USER_TRM_NO").substring(12);         //조작자번호
		}

	   	ICAA9010200 n04 = new ICAA9010200();
	   	
		
		
		if("2".equals(header.get("signer_status"))){	    	//TOBE 2017-07-01 2억 이상 
			isApvRncd = "BOCOM00520"; //TOBE 2017-07-01 책임자 승인 사유 코드 (2억원 이상) 
	   	}else if("1".equals(header.get("signer_status"))){		//5천만원 이상
	   		isApvRncd = "BOCOM00014"; //TOBE 2017-07-01 책임자 승인 사유 코드 (5천만원 이상) 
	   	}else{												//5천만원 미만			
	   	}		

	   	String gate_tot_size    = String.format("%08d", n04.SEND.sysHdr.iTLen+n04.SEND.trnHdr.iTLen+n04.SEND.iTLen + 2 -8); // 전문전체길이+(종료'@@') -8
        String data_tot_size    = String.format("%07d", n04.SEND.iTLen-10); // 데이터부 데이터길이 -10
        
        n04.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
    	
		n04.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n04.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n04.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n04.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호


		n04.SEND.DAT_KDCD           = "DTI";                                          //데이타헤더부 : (문자3)  데이터종류코드	       
		n04.SEND.DAT_LEN            = data_tot_size;                                  //데이타헤더부 : (숫자7)  데이터길이	   
		
	    n04.SEND.WCAD_TLM_LEN       = "";                                             //1 .  N4	우리카드전문길이         
	    n04.SEND.TRNSCT_CD          = "";                                             //2 .  S9	트랜잭션코드             
	    n04.SEND.BGN_CHR            = "";                                             //3 .  S3	개시문자                 
	    n04.SEND.TLM_NO             = "";                                             //4 .  S4	전문번호                 
	    n04.SEND.TLM_UNQ_NO         = "";                                             //5 .  S12	전문고유번호           
	    n04.SEND.MTMS_DTM           = "";                                             //6 .  S14	전문전송일시           
	    n04.SEND.RSCD               = "";                                             //7 .  S2	응답코드                 
	    n04.SEND.MMBHC_NO           = "";                                             //8 .  S2	회원사번호               
	    n04.SEND.SPR_1              = "";                                             //9 .  S18	예비_1                 
	    n04.SEND.SYS_BZCD           = "SGF";                                          //10.  S3	시스템업무코드           
	    n04.SEND.BAS_DT             = SepoaDate.getShortDateString();                 //11.  S8	기준일자                 
	    n04.SEND.TRN_BRCD           = BKCD;                                           //12.  S6	거래점코드               
	    n04.SEND.TRN_LOG_CRE_NO     = trnLogCreNo;                                    //13.  S14	거래로그생성번호       
	    n04.SEND.TRN_TM             = header.get("COMPLATE_TIME");                    //14.  S6	거래시각                 
	    n04.SEND.TRM_NO             = USERTERMNO;                                     //15.  S12	단말번호               
	    n04.SEND.TRSCNO             = "SGF";                                          //16.  S5	거래화면번호             
	    n04.SEND.BIZ_TRN_CD         = "BEB00730T";                                    //17.  S9	업무거래코드             
	    n04.SEND.RLPE_APV_TRN_NM    = "경상비지급";                                     //18.  S50	책임자승인거래명       
	    n04.SEND.INP_MD_KDCD        = "EEPS1";                                        //19.  S8	입력매체종류코드         
	    n04.SEND.TRN_TYCD           = "27";                                           //20.  S2	거래유형코드(27:고정)
	    n04.SEND.TRN_STCD           = "1";                                            //21.  S1	거래상태코드(1:정상,2:취소)
	    n04.SEND.OPR_NO             = addUserId;                                      //22.  S8	조작자번호               
	    n04.SEND.RLPE_ENO           = header.get("signer1_no");                       //23.  S8	책임자직원번호           
	    n04.SEND.RLPE_APV_MENS_CD   = "F";                                            //24.  S1	책임자승인수단코드(F:지문)
	    n04.SEND.RLPE_CMN_MSG_CD_1  = isApvRncd;                                      //25.  S10	책임자공통메시지코드_1 
	    n04.SEND.RLPE_CMN_MSG_CD_2  = "";                                             //26.  S10	책임자공통메시지코드_2 
	    n04.SEND.RLPE_CMN_MSG_CD_3  = "";                                             //27.  S10	책임자공통메시지코드_3 
	    n04.SEND.RLPE_CMN_MSG_CD_4  = "";                                             //28.  S10	책임자공통메시지코드_4 
	    n04.SEND.RLPE_CMN_MSG_CD_5  = "";                                             //29.  S10	책임자공통메시지코드_5 
	    n04.SEND.RLPE_CMN_MSG_CD_6  = "";                                             //30.  S10	책임자공통메시지코드_6 
	    n04.SEND.RLPE_CMN_MSG_CD_7  = "";                                             //31.  S10	책임자공통메시지코드_7 
	    n04.SEND.RLPE_CMN_MSG_CD_8  = "";                                             //32.  S10	책임자공통메시지코드_8 
	    n04.SEND.RLPE_CMN_MSG_CD_9  = "";                                             //33.  S10	책임자공통메시지코드_9 
	    n04.SEND.RLPE_CMN_MSG_CD_10 = "";                                             //34.  S10	책임자공통메시지코드_10
	    n04.SEND.RLPE_CMN_MSG_CD_11 = "";                                             //35.  S10	책임자공통메시지코드_11
	    n04.SEND.RLPE_CMN_MSG_CD_12 = "";                                             //36.  S10	책임자공통메시지코드_12
	    n04.SEND.RLPE_CMN_MSG_CD_13 = "";                                             //37.  S10	책임자공통메시지코드_13
	    n04.SEND.RLPE_CMN_MSG_CD_14 = "";                                             //38.  S10	책임자공통메시지코드_14
	    n04.SEND.RLPE_CMN_MSG_CD_15 = "";                                             //39.  S10	책임자공통메시지코드_15
	    n04.SEND.RLPE_CMN_MSG_CD_16 = "";                                             //40.  S10	책임자공통메시지코드_16
	    n04.SEND.RLPE_CMN_MSG_CD_17 = "";                                             //41.  S10	책임자공통메시지코드_17
	    n04.SEND.RLPE_CMN_MSG_CD_18 = "";                                             //42.  S10	책임자공통메시지코드_18
	    n04.SEND.RLPE_CMN_MSG_CD_19 = "";                                             //43.  S10	책임자공통메시지코드_19
	    n04.SEND.RLPE_CMN_MSG_CD_20 = "";                                             //44.  S10	책임자공통메시지코드_20
	    n04.SEND.PTN_BKW_ACNO       = "";                                             //45.  S20	상대전행계좌번호       
	    n04.SEND.TRN_BKW_ACNO       = header.get("BANK_ACCT");;                       //46.  S20	거래전행계좌번호       
	    n04.SEND.ITCSNO             = "";                                             //47.  S11	통합고객번호           
	    n04.SEND.BKW_ACNO           = "";                                             //48.  S20	전행계좌번호           
	    n04.SEND.TRN_KRW_AM         = String.format("%015d.000"
	    		                         ,Long.parseLong(header.get("TOT_AMT")));   //49.  D19	거래원화금액(18,3)           
	    n04.SEND.TRN_FC_AM          = "000000000000000.000";                          //50.  D19	거래외화금액(18,3)           
	    n04.SEND.ACCT_DT            = header.get("COMPLATE_DATE");                    //51.  S8	회계일자                 
	    n04.SEND.MOD_DSCD           = "0";                                            //52.  S1	모드구분코드(0:당일마감전)             
	    n04.SEND.SLIP_NO            = "";                                             //53.  S16	전표번호               
	    n04.SEND.DACC_BRCD          = BKCD;                                           //54.  S6	일계점코드
	    n04.SEND.CUS_NM             = header.get("VENDOR_NAME_LOC");                  //55.  S50	고객명 (공급업체명)                 
	    n04.SEND.RLPE_ENO_2         = header.get("signer2_no");                       //56.  S8	책임자직원번호_2         
	    n04.SEND.SPR                = "";                                             //57.  S1895	예비                 
	 
		try {
			n04.send_no = header.get("PAY_ACT_NO");
			int iret = n04.sendMessage("ICAA9010200",send_ip,send_port);
			if(iret == ONCNF.D_OK) {
				n04.RECV.log(ONCNF.LOGNAME, "");	
				
				result = "SUCCESS";
				
			}else if(iret == ONCNF.D_ECODE) {
				//TOBE 2017-07-01
				result = "ERR:["+n04.eRECV.msgHdr.MSG_CD+"]"+n04.eRECV.msgHdr.MAIN_MSG_TXT;
			}else {
				result = "ERR:sendMessage call error !!.." + iret;
			}
		}
		catch (Exception e) {
			result = "ERR:sendMessage call error !!.." ;
		}
		
    	return result;
	}

    
    
    
    
    
   
	private String successJson() throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		String       result       = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'000'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String failJson(String message) throws Exception{
		StringBuffer stringBuffer = new StringBuffer();
		String       result       = null;
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"message:'").append(message).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }

    
    
	/*------------------------- TOBE 2017-07-01 암호화 ---------------------------*/
    private String bioEnc(String strBio) throws Exception {
        String strPlain = null;   //지문
        String strEnc   = null;   //암호화
        String strDec   = null;   //복호화 
        
        strPlain = strBio;
        
	    try {
	         Logger.sys.println("DAMO PAY_BD_INS  1");
	
        	 int ret;
             /* DAMO SCP : config file full path */
             String iniFilePath = "/app/damo3/scpdb_agent.ini"; //Unix/Linux Server
             //String iniFilePath = "C:\\app\\damo3\\scpdb_agent.ini"; // Windows Server
           
//             Logger.sys.println("DAMO PAY_BD_INS  2");
             /* DAMO SCP */      
             ScpDbAgent agt = new ScpDbAgent(); 
           
//             Logger.sys.println("DAMO PAY_BD_INS  3");
           
             /* DAMO SCP : initialization */ 
             /* return : 0,118(success) */
             ret = agt.AgentInit( iniFilePath );
             
//             Logger.sys.println("DAMO PAY_BD_INS  4");
           
           
             if ( ret != 0 && ret != 118 )
             {
//           	 Logger.sys.println("DAMO PAY_BD_INS  5");
             Thread.sleep(2000);
             throw new Exception("AgentInit ret( 0,118(success) ) : " + ret );
             }
//             Logger.sys.println("DAMO PAY_BD_INS  6");
        
             /* DAMO SCP : reinitialization */
             /* return : 0(success) */
             Thread.sleep(2000);      
           
//             Logger.sys.println("DAMO PAY_BD_INS  7");
           
             /* DAMO SCP : create context */
             byte[] ctx;
             ctx = agt.AgentCipherCreateContextServiceID( "EPS", "Account");
           
//             Logger.sys.println("DAMO PAY_BD_INS  8");
           
             /* 암호화 /복호화 */
             strEnc = agt.AgentCipherEncryptString( ctx, strPlain );  //지문 암호화
             //Logger.sys.println("EncryptString    : " + strEnc);
             strDec = agt.AgentCipherDecryptString( ctx, strEnc );    //복호화
             //Logger.sys.println("DecryptString    : " + strDec);
//             Logger.sys.println("DAMO PAY_BD_INS  9");
           
            }
            catch (ScpDbAgentException e1)
            {
//              System.out.println(e1.toString());
//              e1.printStackTrace();
                Logger.sys.println("bioEnc ScpDbAgentException : " + e1.getMessage());
            }
            catch (Exception e) {
//              e.printStackTrace();
            	Logger.sys.println("bioEnc Exception : " + e.getMessage());
            }
            finally {
            	Thread.sleep(2000); //try{Thread.sleep(2000);}catch(Exception e2){}
            }
		return strEnc;
	}
	
    /*------------------------- TOBE 2017-07-01 온라인 전문 로그 ---------------------------*/
    
    private String insertSinfhd(SepoaInfo info, String infCode, String infSatus, String infReason) throws Exception{
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		Map<String, String> infMap    = new HashMap<String, String>();
		boolean             flag      = false;
		
		infMap.put("HOUSE_CODE",     houseCode);
		infMap.put("INF_TYPE",       "T");
		infMap.put("INF_SEND",       "S");
		infMap.put("INF_ID",         info.getSession("ID"));
		infMap.put("INF_CODE",       infCode);
		infMap.put("INF_STATUS",     infSatus);
		infMap.put("INF_REASON",     infReason);
		
		obj[0] = infMap;
		value  = ServiceConnector.doService(info, "TX_011", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}   
    /*---------------------------------------------------------------------------*/
}