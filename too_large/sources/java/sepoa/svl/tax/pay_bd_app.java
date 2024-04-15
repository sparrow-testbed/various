package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
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

import com.penta.scpdb.*; /* TOBE 2017-07-01 DAMO SCP Class 로딩 -scpdb.jar (암호) */
import com.tcApi2.BCB01000T02;
import com.tcApi2.BCB01000T03;
import com.tcApi2.CMT90040100;
import com.tcApi2.CMT90020100;
import com.tcApi2.ICAA9010200;
import com.tcJun2.LIST_BCB01000T02_S;
import com.tcJun2.LIST_BEB00730T01_R;
import com.tcJun2.LIST_CMT90020100_R;
import com.tcComm2.ONCNF;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0033_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub.EPS0015;
import com.woorifg.wpms.wpms_webservice.EPS0015_WSStub.EPS0015Response;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub.EPS0016;
import com.woorifg.wpms.wpms_webservice.EPS0016_WSStub.EPS0016Response;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017;
import com.woorifg.wpms.wpms_webservice.EPS0017_WSStub.EPS0017Response;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub.EPS0018;
import com.woorifg.wpms.wpms_webservice.EPS0018_WSStub.EPS0018Response;
import com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033;
import com.woorifg.wpms.wpms_webservice.EPS0033_WSStub.EPS0033Response;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.ArrayOfString;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0019_1Response;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0034Response;




import sepoa.fw.cfg.Configuration;
import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.CommonUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class pay_bd_app extends HttpServlet{
	
    /* TOBE 2017-07-01 총무부 글로벌 상수 */
    String default_gam_jumcd   = sepoa.svc.common.constants.DEFAULT_GAM_JUMCD;
    String ica_igjmCd = null; /* 책임자승인명세RDW에 보낼 일계점 */
    
	private static final long serialVersionUID = 1L;
	
	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info   = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq  = null;
    	GridData  gdRes  = new GridData();
    	String    mode   = null;
    	boolean   isJson = false;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("selectSpy1lnList".equals(mode)){ // 자본 예산 지급현황 상세 리스트
    			gdRes = this.selectSpy1lnList(gdReq, info);
    		}
    		else if("updateSpy1glDelYn".equals(mode)){ // 문서 파기
    			gdRes  = this.updateSpy1glDelYn(gdReq, info);
    			isJson = true;
    		}
    		else if("paySendApp".equals(mode)){			// PAY_SEND_TYPE : N(일반전송 B/S전문, 계좌유효성 확인 이체전송),  Y(책임자 전송 B/S전문, 계좌유효성 확인 이체전송)
    			gdRes  = this.paySendApp(gdReq, info);
    			isJson = true;
    		}
    		else if("payCancelApp".equals(mode)){			// 실행취소 PAY_SEND_TYPE : N(일반전송 B/S전문, 계좌유효성 확인 이체전송),  Y(책임자 전송 B/S전문, 계좌유효성 확인 이체전송)
    			gdRes  = this.payCancelApp(gdReq, info);
    			isJson = true;
    		}
    		else if("updateSpy1glStatusCd03".equals(mode)){		// 반려처리 	
    			gdRes  = this.updateSpy1glStatusCd03(gdReq, info);
    			isJson = true;
    		}
    		else if("updateSpy1glManualAccountKind".equals(mode)){ // 수동완료 처리
    			gdRes  = this.updateSpy1glManualAccountKind(gdReq, info);
    			isJson = true;
    		}
    		else if("updateSpy1glManualAccountKindCancle".equals(mode)){ // 수동 취소 처리
    			gdRes  = this.updateSpy1glManualAccountKindCancle(gdReq, info);
    			isJson = true;
    		}
    		else if("paySendAppCancle".equals(mode)){		        //회수    			
    			gdRes  = this.paySendAppCancle(gdReq, info);
    			isJson = true;
    			
    		}
    		else if("updateSpy1glRtnSignerNo".equals(mode)){		//취소 책임자 등록
        		gdRes  = this.updateSpy1glRtnSignerNo(gdReq, info);
        		isJson = true;
        	}
    		else if("updateSpy1glCancelback".equals(mode)){		//취소 반려
        		gdRes  = this.updateSpy1glCancelback(gdReq, info);
        		isJson = true;
        	}
    		else if("updateSpy1gInfoBeforeSign".equals(mode)){ // 1차 승인 처리
    			Logger.debug.println("updateSpy1gInfoBeforeSign mode Start !...........");
        		gdRes  = this.updateSpy1gInfoBeforeSign(gdReq, info);
        		isJson = true;
        		Logger.debug.println("updateSpy1gInfoBeforeSign mode End !..........." + gdRes.getMessage());
        	}
    		else if("updateSpy1gInfoBeforeSignReject".equals(mode)){ // 1차 반려 처리
        		gdRes  = this.updateSpy1gInfoBeforeSignReject(gdReq, info);
        		isJson = true;
        	}
    		else if("getCMT90020100".equals(mode)){ // 책임자 승인 목록
        		gdRes  = this.getCMT90020100(gdReq, info);
        		isJson = true;
        	}
    		else if("webSendBs001".equals(mode)){			// PAY_SEND_TYPE : N(일반전송 B/S전문, 계좌유효성 확인 이체전송),  Y(책임자 전송 B/S전문, 계좌유효성 확인 이체전송)
                Logger.sys.println("TEST_KIM mode = [" + mode + "]");
    			gdRes  = this.webSendBs001(gdReq, info);
    			isJson = false;
    			
    		}

    	}
    	catch (Exception e) {
    		gdRes.setMessage("ERR: " + e.getMessage());
    		gdRes.setStatus("false");
    		Logger.debug.println(e.getMessage());
    	}
    	finally {
    		try{
    			Logger.debug.println("isJson : " + isJson);
    			Logger.debug.println("gdRes.getMessage() : " + gdRes.getMessage());
    			
    			if(isJson){
    				out.print(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {
    			this.loggerExceptionStackTrace(e);
    		}
    	}

    
    
    
    }
    
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked", "unused" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
    private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
    
    private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_TYPE",       "W");
		param.put("INF_CODE",       infCode);
		param.put("INF_SEND",       infSend);
		param.put("INF_ID",         id);
		
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
    
    private String insertSinfhdBCB01000T(SepoaInfo info, String infCode, String infSatus, String infReason) throws Exception{
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
    
    @SuppressWarnings("unused")
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if("".equals(str)){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
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
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
    
    private Object[] selectSpy1lnListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result     = new Object[1];
    	Map<String, String> header     = this.getHeader(gdReq, info);
    	Map<String, String> headerInfo = new HashMap<String, String>();
    	String              houseCode  = info.getSession("HOUSE_CODE");
    	String              paySendNo  = header.get("PAY_SEND_NO");
    	
    	headerInfo.put("HOUSE_CODE",  houseCode);
    	headerInfo.put("PAY_SEND_NO", paySendNo);
    	
    	result[0] = headerInfo;
    	
    	return result;
    }
    
    private GridData getCatalogGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
    	String[]            gridColAry       = this.getGridColArray(gdReq);
    	String              colKey           = null;
	    String              colValue         = null;
    	int                 i                = 0;
	    int                 k                = 0;
	    int                 rowCount         = sf.getRowCount();
	    int                 gridColAryLength = gridColAry.length;
	    
    	for (i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			colValue = sf.getValue(colKey, i);
    			
    			if("SELECTED".equals(gridColAry[k])){
    				gdRes.addValue("SELECTED", "0");
    			}
    			else{
    				gdRes.addValue(colKey, colValue);
    			}
    		}
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes" })
	private GridData selectSpy1lnList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.selectSpy1lnListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "TX_009", "CONNECTION", "selectSpy1lnList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.getCatalogGdRes(gdReq, gdRes, sf);
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
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
	
	private Object[] updateSpy1glDelYnObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		String              paySendNo  = gdReq.getParam("PAY_SEND_NO");
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              id         = info.getSession("ID");
		Map<String, String> resultInfo = new HashMap<String, String>();
		
		resultInfo.put("HOUSE_CODE",     houseCode);
		resultInfo.put("PAY_SEND_NO",    paySendNo);
		resultInfo.put("CHANGE_USER_ID", id);
		
		result[0] = resultInfo;
		
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
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glDelYn(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	
    	String  bmsBmsYy  = gdReq.getParam("BMSBMSYY");
    	String  bmsSrlNo  = gdReq.getParam("BMSSRLNO");
    	String  appAppNo  = gdReq.getParam("APPAPPNO");
    	
    	try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1glDelYnObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_010", "TRANSACTION", "updateSpy1glDelYn", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    			
    			this.getEps0019_1WebService2(info, bmsBmsYy, bmsSrlNo, appAppNo);
        		
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	
	private String[] getEps0019_1WebService2(SepoaInfo info, String bsmBsmYy, String bmsSrlNo, String appAppNo) throws Exception{
		EPS_WSStub      epsWSStub       = null;
		EPS0019_1         eps0019_1         = null;
		EPS0019_1Response eps0019_1Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          status          = null;
		String          reason          = null;
		String          code            = null;
		String          infReceiveNo    = null;
		String[]        response        = null;
		//StringBuffer    stringBuffer    = null;
		
		try{
			epsWSStub = new EPS_WSStub();
			
			infNo   = this.insertSinfhdInfo(info, "EPS0019_1", "S");
			eps0019_1 = this.getEps0019_1WebServiceEps0019_1(info, infNo, bsmBsmYy, bmsSrlNo, appAppNo);
							
			this.insertSinfep0019_1Info(info, infNo, eps0019_1);
			
			eps0019_1Response = epsWSStub.ePS0019_1(eps0019_1);
			arrayOfString   = eps0019_1Response.getEPS0019_1Result();
			response        = arrayOfString.getString();
			code            = response[0];
			infReceiveNo    = response[3];
			
			if("200".equals(code)){
				status = "Y";
				reason = "";
			}
			else{
				status = "N";
				reason = response[1];
			}
		}
		catch(Exception e){
			response = new String[3];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
		
		//stringBuffer = this.getEps0019CodeJson(response);
		
		return response;
	}
	
	 private EPS0019_1 getEps0019_1WebServiceEps0019_1(SepoaInfo info, String infNo, String bsmBsmYy ,String bmsSrlNo, String appAppNo) throws Exception{		
			EPS0019_1 eps0019_1  = new EPS0019_1();
			String  id       = this.getWebserviceId(info);
			
//			MODE          작업구분         string / (고정형)1 D 예산 품의정보 삭제 필수 
//			BMSBMSYY  예산연도         string / (고정형)4  
//			BMSSRLNO  예산일련번호    string / (고정형)5   필수 
//			APPAPPNO  승인번호          string / (고정형)3   필수 
//			USRUSRID    사용자행번       string / (고정형)8   필수 
//			INF_REF_NO 인터페이스번호 string / (가변형)15 전자구매에서 생성한 인터페이스번호 필수 

			
			eps0019_1.setMODE("D");
			eps0019_1.setBMSBMSYY(bsmBsmYy);
			eps0019_1.setBMSSRLNO(bmsSrlNo);
			eps0019_1.setAPPAPPNO(appAppNo);
			eps0019_1.setUSRUSRID(id);
			eps0019_1.setINF_REF_NO(infNo);
			
			return eps0019_1;
		}
	 
	 private void insertSinfep0019_1Info(SepoaInfo info, String infNo, EPS0019_1 eps0019_1) throws Exception{
			Map<String, String> svcParam  = new HashMap<String, String>();
			String              houseCode = info.getSession("HOUSE_CODE");
			String              mode      = eps0019_1.getMODE();
			String              bmsBmsYy  = eps0019_1.getBMSBMSYY();
			String              bmsSrlNo  = eps0019_1.getBMSSRLNO();
			String              appAppNo  = eps0019_1.getAPPAPPNO();
			String              usrUsrId  = eps0019_1.getUSRUSRID();
			
			Object[]            obj       = new Object[1];
			SepoaOut            value     = null;
			boolean             isStatus  = false;
			
			svcParam.put("HOUSE_CODE", houseCode);
			svcParam.put("INF_NO",     infNo);
			svcParam.put("INF_MODE",   mode);
			svcParam.put("BMSBMSYY",   bmsBmsYy);
			svcParam.put("BMSBMSYY",   bmsBmsYy);
			svcParam.put("BMSSRLNO",   bmsSrlNo);
			svcParam.put("APPAPPNO",   appAppNo);
			svcParam.put("USRUSRID",   usrUsrId);
			
			obj[0]   = svcParam;
			value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0019_1Info", obj);
			isStatus = value.flag;
			
			if(isStatus == false) {
				throw new Exception(); 
			}
		}
	
	private Map<String, String> selectSpy1glInfo(SepoaInfo info, String paySendNo) throws Exception{
    	Map<String, String> result     = new HashMap<String, String>();
    	Map<String, String> svcObjInfo = new HashMap<String, String>();
    	Object[]            svcObj     = new Object[1];
    	String              houseCode  = info.getSession("HOUSE_CODE");
    	SepoaOut            value      = null;
    	SepoaFormater       sf         = null;
    	
    	svcObjInfo.put("HOUSE_CODE",  houseCode);
    	svcObjInfo.put("PAY_SEND_NO", paySendNo);
    	
    	svcObj[0] = svcObjInfo;
    	value     = ServiceConnector.doService(info, "TX_010", "CONNECTION", "selectSpy1glInfo", svcObj);
    	
    	sf = new SepoaFormater(value.result[0]);
    	
    	result.put("HOUSE_CODE",          sf.getValue("HOUSE_CODE",          0));
    	result.put("PAY_SEND_NO",         sf.getValue("PAY_SEND_NO",         0));
    	result.put("VENDOR_CODE",         sf.getValue("VENDOR_CODE",         0));
    	result.put("DEPOSITOR_NAME",      sf.getValue("DEPOSITOR_NAME",      0));
    	result.put("BANK_CODE",           sf.getValue("BANK_CODE",           0));
    	result.put("BANK_ACCT",           sf.getValue("BANK_ACCT",           0));
    	result.put("PAY_AMT",             sf.getValue("PAY_AMT",             0));
    	result.put("SIGNER_FLAG",         sf.getValue("SIGNER_FLAG",         0));
    	result.put("SIGNER_NO",           sf.getValue("SIGNER_NO",           0));
    	result.put("SIGNER_BIO",          sf.getValue("SIGNER_BIO",          0));
    	result.put("WORK_KIND",           sf.getValue("WORK_KIND",           0));
    	result.put("BMSBMSYY",            sf.getValue("BMSBMSYY",            0));
    	result.put("SOGSOGCD",            sf.getValue("SOGSOGCD",            0));
    	result.put("ASTASTGB",            sf.getValue("ASTASTGB",            0));
    	result.put("MNGMNGNO",            sf.getValue("MNGMNGNO",            0));
    	result.put("BSSBSSNO",            sf.getValue("BSSBSSNO",            0));
    	result.put("APPAPPYY",            sf.getValue("APPAPPYY",            0));
    	result.put("BMSSRLNO",            sf.getValue("BMSSRLNO",            0));
    	result.put("APPAPPNO",            sf.getValue("APPAPPNO",            0));
    	result.put("APPAPPAM",            sf.getValue("APPAPPAM",            0));
    	result.put("JUMJUM_CD",           sf.getValue("JUMJUM_CD",           0));
    	result.put("IGJM_CD",             sf.getValue("IGJM_CD",             0));
    	result.put("BDSBDSCD",            sf.getValue("BDSBDSCD",            0));
    	result.put("BDSBDSNM",            sf.getValue("BDSBDSNM",            0));
    	result.put("USE_KIND",            sf.getValue("USE_KIND",            0));
    	result.put("DEAL_AREA",           sf.getValue("DEAL_AREA",           0));
    	result.put("DURABLE_YEAR",        sf.getValue("DURABLE_YEAR",        0));
    	result.put("DEAL_DEBT",           sf.getValue("DEAL_DEBT",           0));
    	result.put("ACCOUNTKIND",         sf.getValue("ACCOUNTKIND",         0));
    	result.put("DEAL_KIND",           sf.getValue("DEAL_KIND",           0));
    	result.put("TRM_RTN_SQNO",        sf.getValue("TRM_RTN_SQNO",        0));
    	result.put("USER_TRM_NO",         sf.getValue("USER_TRM_NO",         0));
    	result.put("STATUS_CD",           sf.getValue("STATUS_CD",           0));
    	result.put("ADD_DATE",            sf.getValue("ADD_DATE",            0));
    	result.put("ADD_TIME",            sf.getValue("ADD_TIME",            0));
    	result.put("ADD_USER_ID",         sf.getValue("ADD_USER_ID",         0));
    	result.put("CHANGE_DATE",         sf.getValue("CHANGE_DATE",         0));
    	result.put("CHANGE_TIME",         sf.getValue("CHANGE_TIME",         0));
    	result.put("CHANGE_USER_ID",      sf.getValue("CHANGE_USER_ID",      0));
    	result.put("TCP_STATE",           sf.getValue("TCP_STATE",           0));
    	result.put("WEB_STATE",           sf.getValue("WEB_STATE",           0));
    	result.put("MANUAL_ACCOUNT_KIND", sf.getValue("MANUAL_ACCOUNT_KIND", 0));
    	result.put("DEL_YN",              sf.getValue("DEL_YN",              0));
		result.put("BSTRCD1",             sf.getValue("TEXT3",               0));
		result.put("BSTRCD2",             sf.getValue("TEXT4",               0));
		result.put("ACTRCD1",             sf.getValue("TEXT5",               0));
		result.put("ACTRCD2",             sf.getValue("TEXT6",               0));
		result.put("ACC_NUM",             sf.getValue("ACC_NUM",             0));
		result.put("BEFORE_SIGN_NO",      sf.getValue("BEFORE_SIGN_NO",      0));
		result.put("TRN_LOG_KEY_VAL",     sf.getValue("TRN_LOG_KEY_VAL",     0)); //TOBE 2017-07-01 로그키값
		result.put("VENDOR_NAME_LOC",     sf.getValue("VENDOR_NAME_LOC",     0)); //TOBE 2017-07-01 공급업체명
		result.put("IRS_NO",              sf.getValue("IRS_NO",              0)); //TOBE 2021-01-01 공급엄체사업자번호
		result.put("CCLT_RSN_DSCD",       sf.getValue("CCLT_RSN_DSCD",       0)); //취소사유구분코드
		result.put("CCLT_RSN_CNTN",       sf.getValue("CCLT_RSN_CNTN",       0)); //취소사유내용
		result.put("EXE_TRY_TERM",        sf.getValue("EXE_TRY_TERM",        0)); //실행TRY텀(초)
		result.put("CCLT_TRY_TERM",       sf.getValue("CCLT_TRY_TERM",        0));//취소TRY텀(초)
		
    	return result;
    }
    
    @SuppressWarnings("unused")
	private List<Map<String, String>> selectSpy1lnList(SepoaInfo info, String paySendNo) throws Exception{
    	List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
    	Map<String, String>       svcObjInfo = new HashMap<String, String>();
    	Map<String, String>       resultInfo = null;
    	Object[]                  svcObj     = new Object[1];
    	String                    houseCode  = info.getSession("HOUSE_CODE");
    	SepoaOut                  value      = null;
    	SepoaFormater             sf         = null;
    	int                       sfRowCount = 0;
    	int                       i          = 0;
    	
    	svcObjInfo.put("HOUSE_CODE",  houseCode);
    	svcObjInfo.put("PAY_SEND_NO", paySendNo);
    	
    	svcObj[0] = svcObjInfo;
    	value     = ServiceConnector.doService(info, "TX_010", "CONNECTION", "selectSpy1lnList", svcObj);
    	
    	sf = new SepoaFormater(value.result[0]);
    	
    	sfRowCount = sf.getRowCount();
    	
    	for(i = 0; i < sfRowCount; i++){
    		resultInfo = new HashMap<String, String>();
    		
    		resultInfo.put("HOUSE_CODE",     sf.getValue("HOUSE_CODE",     0));
    		resultInfo.put("PAY_SEND_NO",    sf.getValue("PAY_SEND_NO",    0));
    		resultInfo.put("PAY_SEND_SEQ",   sf.getValue("PAY_SEND_SEQ",   0));
    		resultInfo.put("TAX_NO",         sf.getValue("TAX_NO",         0));
    		resultInfo.put("TAX_SEQ",        sf.getValue("TAX_SEQ",        0));
    		resultInfo.put("JUMJUJMCD",      sf.getValue("JUMJUJMCD",      0));
    		resultInfo.put("IGJMCD",         sf.getValue("IGJMCD",         0));
    		resultInfo.put("PMKPMKCD",       sf.getValue("PMKPMKCD",       0));
    		resultInfo.put("CNT",            sf.getValue("CNT",            0));
    		resultInfo.put("AMT",            sf.getValue("AMT",            0));
    		resultInfo.put("APPAPPAM",       sf.getValue("APPAPPAM",       0));
    		resultInfo.put("DOSUNQNO",       sf.getValue("DOSUNQNO",       0));
    		resultInfo.put("ADD_DATE",       sf.getValue("ADD_DATE",       0));
    		resultInfo.put("ADD_TIME",       sf.getValue("ADD_TIME",       0));
    		resultInfo.put("ADD_USER_ID",    sf.getValue("ADD_USER_ID",    0));
    		resultInfo.put("CHANGE_DATE",    sf.getValue("CHANGE_DATE",    0));
    		resultInfo.put("CHANGE_TIME",    sf.getValue("CHANGE_TIME",    0));
    		resultInfo.put("CHANGE_USER_ID", sf.getValue("CHANGE_USER_ID", 0));
    		resultInfo.put("MODEL_NO",       sf.getValue("MODEL_NO",       0));
    		
    		result.add(resultInfo);
    	}
    	
    	return result;
    }
    
    private void updateSpy1glWebState(SepoaInfo info, String paySendNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("HOUSE_CODE",  houseCode);
			param.put("PAY_SEND_NO", paySendNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "TX_010", "TRANSACTION", "updateSpy1glWebState", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private EPS0015 getEps0015Eps0015(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
		Map<String, String>          gridInfo      = null;
		EPS0015                      eps0015       = new EPS0015();
		String                       appAppYy      = glInfo.get("APPAPPYY");
		String                       pumPumNo      = glInfo.get("BMSSRLNO");
		String                       appAppNo      = glInfo.get("APPAPPNO");
		String                       appAppAm      = glInfo.get("APPAPPAM");
		String                       irsNo         = glInfo.get("IRS_NO");
		String                       verdorNameLoc = glInfo.get("VENDOR_NAME_LOC");
		String                       mdlMdlNM      = null;
		String                       Spec          = null;
		String                       id            = this.getWebserviceId(info);
		EPS0015_WSStub.ArrayOfString jumJumCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkPmkCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkSrlNoArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString mdlMdlNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString cntArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString amtArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString buyBuyNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString etcEtcNyArray = new EPS0015_WSStub.ArrayOfString();
		int                          gridSize      = lnList.size();
		int                          i             = 0;
		
		appAppAm = appAppAm.replace(",", "");
		
		for(i = 0; i < gridSize; i++){
			gridInfo = lnList.get(i);             
			mdlMdlNM = gridInfo.get("MODEL_NO");
			mdlMdlNM = this.nvl(mdlMdlNM, " ");
			
			jumJumCdArray.addString(gridInfo.get("JUMJUJMCD"));
			pmkPmkCdArray.addString(gridInfo.get("PMKPMKCD"));
			pmkSrlNoArray.addString("1");
			mdlMdlNmArray.addString(mdlMdlNM);
			cntArray.addString(gridInfo.get("CNT"));
			amtArray.addString(gridInfo.get("AMT"));
			if(verdorNameLoc != null && verdorNameLoc.length() > 10){
				verdorNameLoc = verdorNameLoc.substring(0,10);
			}
			buyBuyNmArray.addString("("+irsNo+")"+verdorNameLoc);
			
			Spec = gridInfo.get("SPECIFICATION");
			Spec = this.nvl(Spec, "");
			if(!"".equals(Spec)){
				Spec = Spec + "-";
			}
			etcEtcNyArray.addString(Spec + gridInfo.get("REMARK"));
		}
		
		eps0015.setMODE("C");
		eps0015.setBNKCD("20");
		eps0015.setPUMPUMYY(appAppYy);
		eps0015.setPUMPUMNO(pumPumNo);
		eps0015.setAPPAPPNO(appAppNo);
		eps0015.setAPPAPPAM(appAppAm);
		eps0015.setJUMJUMCD(jumJumCdArray);
		eps0015.setPMKPMKCD(pmkPmkCdArray);
		eps0015.setPMKSRLNO(pmkSrlNoArray);
		eps0015.setMDLMDLNM(mdlMdlNmArray);
		eps0015.setCNT(cntArray);
		eps0015.setAMT(amtArray);
		eps0015.setBUYBUYNM(buyBuyNmArray);
		eps0015.setETCETCNY(etcEtcNyArray);
		eps0015.setUSRUSRID(id);
		eps0015.setINF_REF_NO(infNo);
		
		return eps0015;
	}
    
    private Map<String, String> insertSinfep0015InfoSinfEp0015Info(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		Map<String, String> sinfEp0015Info = new HashMap<String, String>();
		String              houseCode      = info.getSession("HOUSE_CODE");
		String              mode           = eps0015.getMODE();
		String              bnkCd          = eps0015.getBNKCD();
		String              pumPumYy       = eps0015.getPUMPUMYY();
		String              pumPumNo       = eps0015.getPUMPUMNO();
		String              appAppNo       = eps0015.getAPPAPPNO();
		String              appAppAm       = eps0015.getAPPAPPAM();
		String              usrUsrId       = eps0015.getUSRUSRID();
		
		sinfEp0015Info.put("HOUSE_CODE", houseCode);
		sinfEp0015Info.put("INF_NO",     infNo);
		sinfEp0015Info.put("INF_MODE",   mode);
		sinfEp0015Info.put("BNKCD",      bnkCd);
		sinfEp0015Info.put("PUMPUMYY",   pumPumYy);
		sinfEp0015Info.put("PUMPUMNO",   pumPumNo);
		sinfEp0015Info.put("APPAPPNO",   appAppNo);
		sinfEp0015Info.put("APPAPPAM",   appAppAm);
		sinfEp0015Info.put("USRUSRID",   usrUsrId);
		
		return sinfEp0015Info;
	}
    
    private List<Map<String, String>> insertSinfep0015InfoSinfEp0015PrList(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		List<Map<String, String>>    sinfEp0015PrList     = new ArrayList<Map<String, String>>();
		EPS0015_WSStub.ArrayOfString jumJumCd             = eps0015.getJUMJUMCD();
		EPS0015_WSStub.ArrayOfString pmkPmkCd             = eps0015.getPMKPMKCD();
		EPS0015_WSStub.ArrayOfString pmkSrlNo             = eps0015.getPMKSRLNO();
		EPS0015_WSStub.ArrayOfString mdlMdlNm             = eps0015.getMDLMDLNM();
		EPS0015_WSStub.ArrayOfString cnt                  = eps0015.getCNT();
		EPS0015_WSStub.ArrayOfString amt                  = eps0015.getAMT();
		EPS0015_WSStub.ArrayOfString buyBuyNm             = eps0015.getBUYBUYNM();
		EPS0015_WSStub.ArrayOfString etcEtcNy             = eps0015.getETCETCNY();
		String[]                     jumJumCdArray        = jumJumCd.getString();
		String[]                     pmkPmkCdArray        = pmkPmkCd.getString();
		String[]                     pmkSrlNoArray        = pmkSrlNo.getString();
		String[]                     mdlMdlNmArray        = mdlMdlNm.getString();
		String[]                     cntArray             = cnt.getString();
		String[]                     amtArray             = amt.getString();
		String[]                     buyBuyNmArray        = buyBuyNm.getString();
		String[]                     etcEtcNyArray        = etcEtcNy.getString();
		String                       jumJumCdArrayInfo    = null;
		String                       pmkPmkCdArrayInfo    = null;
		String                       pmkSrlNoArrayInfo    = null;
		String                       mdlMdlNmArrayInfo    = null;
		String                       cntArrayInfo         = null;
		String                       amtArrayInfo         = null;
		String                       buyBuyNmArrayInfo    = null;
		String                       etcEtcNyArrayInfo    = null;
		String                       houseCode            = info.getSession("HOUSE_CODE");
		Map<String, String>          sinfEp0015PrListInfo = null;
		int                          etcEtcNyArrayLength  = etcEtcNyArray.length;
		int                          i                    = 0;
		
		for(i = 0; i < etcEtcNyArrayLength; i++){
			sinfEp0015PrListInfo = new HashMap<String, String>();
			
			jumJumCdArrayInfo = jumJumCdArray[i];
			pmkPmkCdArrayInfo = pmkPmkCdArray[i];
			pmkSrlNoArrayInfo = pmkSrlNoArray[i];
			mdlMdlNmArrayInfo = mdlMdlNmArray[i];
			cntArrayInfo      = cntArray[i];
			amtArrayInfo      = amtArray[i];
			buyBuyNmArrayInfo = buyBuyNmArray[i];
			etcEtcNyArrayInfo = etcEtcNyArray[i];
			
			sinfEp0015PrListInfo.put("HOUSE_CODE", houseCode);
			sinfEp0015PrListInfo.put("INF_NO",     infNo);
			sinfEp0015PrListInfo.put("SEQ",        Integer.toString(i));
			sinfEp0015PrListInfo.put("JUMJUMCD",   jumJumCdArrayInfo);
			sinfEp0015PrListInfo.put("PMKPMKCD",   pmkPmkCdArrayInfo);
			sinfEp0015PrListInfo.put("PMKSRLNO",   pmkSrlNoArrayInfo);
			sinfEp0015PrListInfo.put("MDLMDLNM",   mdlMdlNmArrayInfo);
			sinfEp0015PrListInfo.put("CNT",        cntArrayInfo);
			sinfEp0015PrListInfo.put("AMT",        amtArrayInfo);
			sinfEp0015PrListInfo.put("BUYBUYNM",   buyBuyNmArrayInfo);
			sinfEp0015PrListInfo.put("ETCETCNY",   etcEtcNyArrayInfo);
			
			sinfEp0015PrList.add(sinfEp0015PrListInfo);
		}
		
		return sinfEp0015PrList;
	}
    
    private void insertSinfep0015Info(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		Object[]                  svcParamObj      = new Object[1];
		Map<String, Object>       svcParamObjInfo  = new HashMap<String, Object>();
		Map<String, String>       sinfEp0015Info   = this.insertSinfep0015InfoSinfEp0015Info(eps0015, info, infNo);
		List<Map<String, String>> sinfEp0015PrList = this.insertSinfep0015InfoSinfEp0015PrList(eps0015, info, infNo);
		SepoaOut                  value            = null;
		boolean                   flag             = false;
		
		svcParamObjInfo.put("sinfEp0015Info",   sinfEp0015Info);
		svcParamObjInfo.put("sinfEp0015PrList", sinfEp0015PrList);
		
		svcParamObj[0] = svcParamObjInfo;
		
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0015Info", svcParamObj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
	}
    
    private String[] getEPS0015Result(EPS0015 eps0015) throws Exception{
		EPS0015Response              eps0015Response = new EPS0015_WSStub().ePS0015(eps0015);
		EPS0015_WSStub.ArrayOfString arrayOfString   = eps0015Response.getEPS0015Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
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
    
    private void updateSinfep0015Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0015Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String[] getEps0015(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0015  eps0015      = null;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0015", "S");
    		eps0015 = this.getEps0015Eps0015(gdReq, info, infNo, glInfo, lnList);
    		
    		this.insertSinfep0015Info(eps0015, info, infNo);
    		
    		result       = this.getEPS0015Result(eps0015);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}else if("713".equals(code)){ // "이미 등록 되었습니다."
    			status = "Y";
				reason = "";
				
				result[0] = "200";
				result[1] = "실행성공";
				result[2] = "";				
    		}else{
    			status = "N";
				reason = result[1];
    		} 		
    	}
    	catch(Exception e){
    		result = new String[3];
    		
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			infReceiveNo = "";
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0015Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0016 getEps0016Eps0016(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	EPS0016                      eps0016      = new EPS0016();
    	Map<String, String>          gridInfo     = null;
    	String                       appAppYy     = glInfo.get("APPAPPYY");
    	String                       bmsSrlNo     = glInfo.get("BMSSRLNO");
    	String                       appAppNo     = glInfo.get("APPAPPNO");
    	String                       appAppAm     = glInfo.get("APPAPPAM");
    	String                       dosUnqNoInfo = null;
    	String                       updjbmtInfo  = null;
    	String                       id           = this.getWebserviceId(info);
    	EPS0016_WSStub.ArrayOfString dosUnqNo     = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString updjbmt      = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString etcEtcNy     = new EPS0016_WSStub.ArrayOfString();
    	int                          gridSize     = lnList.size();
    	int                          i            = 0;
    	
    	appAppAm = appAppAm.replace(",", "");
    	
    	for(i = 0; i < gridSize; i++){
    		gridInfo     = lnList.get(i);
    		dosUnqNoInfo = gridInfo.get("DOSUNQNO");
    		updjbmtInfo  = gridInfo.get("APPAPPAMDT");
    		
    		dosUnqNo.addString(dosUnqNoInfo);
    		updjbmt.addString(updjbmtInfo);
    		etcEtcNy.addString(gridInfo.get("REMARK"));
    	}
    	    	
    	eps0016.setMODE("C");
    	eps0016.setBNKBNKCD("20");
    	eps0016.setPUMPUMYY(appAppYy);
    	eps0016.setPUMPUMNO(bmsSrlNo);
    	eps0016.setAPPAPPNO(appAppNo);
    	eps0016.setAPPAPPAM(appAppAm);
    	eps0016.setDOSUNQNO(dosUnqNo);
    	eps0016.setUPDJBMT(updjbmt);
    	eps0016.setETCETCNY(etcEtcNy);
    	eps0016.setUSRUSRID(id);
    	eps0016.setINF_REF_NO(infNo);
    	
    	return eps0016;
    }
    
    private Map<String, String> insertSinfep0016InfoSinfEp0016Info(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	Map<String, String> sinfEp0016Info = new HashMap<String, String>();
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              mode           = eps0016.getMODE();
    	String              bnkBnkCd       = eps0016.getBNKBNKCD();
    	String              pumPumYy       = eps0016.getPUMPUMYY();
    	String              pumPumNo       = eps0016.getPUMPUMNO();
    	String              appAppNo       = eps0016.getAPPAPPNO();
    	String              appAppAm       = eps0016.getAPPAPPAM();
    	
    	sinfEp0016Info.put("HOUSE_CODE", houseCode);
    	sinfEp0016Info.put("INF_NO",     infNo);
    	sinfEp0016Info.put("INF_MODE",   mode);
    	sinfEp0016Info.put("BNKBNKCD",   bnkBnkCd);
    	sinfEp0016Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0016Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0016Info.put("APPAPPNO",   appAppNo);
    	sinfEp0016Info.put("APPAPPAM",   appAppAm);
    	
    	return sinfEp0016Info;
    }
    
    private List<Map<String, String>> insertSinfep0016InfoSinfEp0016PrList(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	List<Map<String, String>>    sinfEp0016PrList     = new ArrayList<Map<String, String>>();
    	EPS0016_WSStub.ArrayOfString dosUnqNo             = eps0016.getDOSUNQNO();
    	EPS0016_WSStub.ArrayOfString updjbmt              = eps0016.getUPDJBMT();
    	EPS0016_WSStub.ArrayOfString etcEtcNy             = eps0016.getETCETCNY();
    	String[]                     dosUnqNoArray        = dosUnqNo.getString();
    	String[]                     updjbmtArray         = updjbmt.getString();
    	String[]                     etcEtcNyArray        = etcEtcNy.getString();
    	String                       dosUnqNoArrayInfo    = null;
    	String                       updjbmtArrayInfo     = null;
    	String                       etcEtcNyArrayInfo    = null;
    	Map<String, String>          sinfEp0016PrListInfo = null;
    	String                       houseCode            = info.getSession("HOUSE_CODE");
    	int                          etcEtcNyArrayLength  = etcEtcNyArray.length;
    	int                          i                    = 0;
    	
    	for(i = 0; i < etcEtcNyArrayLength; i++){
    		sinfEp0016PrListInfo = new HashMap<String, String>();
    		
    		dosUnqNoArrayInfo = dosUnqNoArray[i];
    		updjbmtArrayInfo  = updjbmtArray[i];
    		etcEtcNyArrayInfo = etcEtcNyArray[i];
    		
    		sinfEp0016PrListInfo.put("HOUSE_CODE", houseCode);
    		sinfEp0016PrListInfo.put("INF_NO",     infNo);
    		sinfEp0016PrListInfo.put("SEQ",        Integer.toString(i));
    		sinfEp0016PrListInfo.put("DOSUNQNO",   dosUnqNoArrayInfo);
    		sinfEp0016PrListInfo.put("UPDJBMT",    updjbmtArrayInfo);
    		sinfEp0016PrListInfo.put("ETCETCNY",   etcEtcNyArrayInfo);
    		
    		sinfEp0016PrList.add(sinfEp0016PrListInfo);
    	}
    	
    	return sinfEp0016PrList;
    }
    
    private void insertSinfep0016Info(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	Object[]                  svcObj           = new Object[1];
    	Map<String, Object>       svcObjInfo       = new HashMap<String, Object>();
    	Map<String, String>       sinfEp0016Info   = this.insertSinfep0016InfoSinfEp0016Info(eps0016, info, infNo);
    	List<Map<String, String>> sinfEp0016PrList = this.insertSinfep0016InfoSinfEp0016PrList(eps0016, info, infNo);
    	SepoaOut                  value            = null;
    	boolean                   flag             = false;
    	
    	svcObjInfo.put("sinfEp0016Info",   sinfEp0016Info);
    	svcObjInfo.put("sinfEp0016PrList", sinfEp0016PrList);
    	
    	svcObj[0] = svcObjInfo;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0016Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEPS0016Result(EPS0016 eps0016) throws Exception{
		EPS0016Response              eps0016Response = new EPS0016_WSStub().ePS0016(eps0016);
		EPS0016_WSStub.ArrayOfString arrayOfString   = eps0016Response.getEPS0016Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0016Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0016Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String[] getEps0016(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0016  eps0016      = null;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0016", "S");
    		eps0016 = this.getEps0016Eps0016(gdReq, info, infNo, glInfo, lnList);
    		
    		this.insertSinfep0016Info(eps0016, info, infNo);
    		
    		result       = this.getEPS0016Result(eps0016);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}
    		else{
    			status = "N";
				reason = result[1];
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
	    	status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0016Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0017 getEps0017Eps0017(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	EPS0017             result             = new EPS0017();
    	String              pumPumYy           = glInfo.get("APPAPPYY"); 
    	String              pumPumNo           = glInfo.get("BMSSRLNO"); 
    	String              appAppNo           = glInfo.get("APPAPPNO"); 
    	String              appAppAm           = glInfo.get("APPAPPAM"); 
    	String              jumJumCd           = glInfo.get("JUMJUM_CD");
    	String              bdsBdsCd           = glInfo.get("BDSBDSCD"); 
    	String              trnTrnGb           = glInfo.get("DEAL_KIND");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              bdsBdsNo           = null;
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 bdsBdsNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	bdsBdsNo = bdsBdsCd.substring(bdsBdsNoStartIndex, bdsBdsCdLength);
    	
    	result.setMODE("C");
    	result.setPUMPUMYY(pumPumYy);
    	result.setPUMPUMNO(pumPumNo);
    	result.setAPPAPPNO(appAppNo);
    	result.setAPPAPPAM(appAppAm);
    	result.setJUMJUMCD(jumJumCd);
    	result.setASTASTGB(astAstGb);
    	result.setUNQUNQNO(bdsBdsNo);
    	
    	//TOBE 2017-07-01 ASTASTGB 자산구분이 20:건물일때는 , ACTACTGB 계정구분02 업무용건물로 변경 , 그외는 임차점포시설물 밖에 없다 
    	if (("20").equals(astAstGb)) {
    	    result.setACTACTGB("02");
    	}else {
    		result.setACTACTGB("03");
    	}
    	result.setCHGCHGAM(appAppAm);
    	result.setTRNTRNGB(trnTrnGb);
    	result.setUSRUSRID(id);
    	result.setINF_REF_NO(infNo);
    	result.setETCETCNY(lnList.get(0).get("REMARK"));
    	
    	return result;
    }
    
    private void insertSinfep0017Info(EPS0017 eps0017, SepoaInfo info, String infNo) throws Exception{
    	Object[]            svcObj         = new Object[1];
    	Map<String, String> sinfEp0017Info = new HashMap<String, String>();
    	SepoaOut            value          = null;
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              mode           = eps0017.getMODE();
    	String              pumPumYy       = eps0017.getPUMPUMYY();
    	String              pumPumNo       = eps0017.getPUMPUMNO();
    	String              appAppNo       = eps0017.getAPPAPPNO();
    	String              appAppAm       = eps0017.getAPPAPPAM();
    	String              jumJumCd       = eps0017.getJUMJUMCD();
    	String              astAstGb       = eps0017.getASTASTGB();
    	String              unqUnqNo       = eps0017.getUNQUNQNO();
    	String              actActGb       = eps0017.getACTACTGB();
    	String              chgChgAm       = eps0017.getCHGCHGAM();
    	String              trnTrnGb       = eps0017.getTRNTRNGB();
    	String              usrUsrId       = eps0017.getUSRUSRID();
    	boolean             flag           = false;
    	
    	sinfEp0017Info.put("HOUSE_CODE", houseCode);
    	sinfEp0017Info.put("INF_NO",     infNo);
    	sinfEp0017Info.put("INF_MODE",   mode);
    	sinfEp0017Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0017Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0017Info.put("APPAPPNO",   appAppNo);
    	sinfEp0017Info.put("APPAPPAM",   appAppAm);
    	sinfEp0017Info.put("JUMJUMCD",   jumJumCd);
    	sinfEp0017Info.put("ASTASTGB",   astAstGb);
    	sinfEp0017Info.put("UNQUNQNO",   unqUnqNo);
    	sinfEp0017Info.put("ACTACTGB",   actActGb);
    	sinfEp0017Info.put("CHGCHGAM",   chgChgAm);
    	sinfEp0017Info.put("TRNTRNGB",   trnTrnGb);
    	sinfEp0017Info.put("USRUSRID",   usrUsrId);
    	
    	svcObj[0] = sinfEp0017Info;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0017Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEPS0017Result(EPS0017 eps0017) throws Exception{
		EPS0017Response              eps0017Response = new EPS0017_WSStub().ePS0017(eps0017);
		EPS0017_WSStub.ArrayOfString arrayOfString   = eps0017Response.getEPS0017Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0017Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0017Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String[] getEps0017(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0017  eps0017      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0017", "S");
    		eps0017  = this.getEps0017Eps0017(gdReq, info, infNo, glInfo, lnList);
    		astAstGb = eps0017.getASTASTGB();
    		
    		this.insertSinfep0017Info(eps0017, info, infNo);
    		
    		if(
    			("10".equals(astAstGb) == false) &&
    			("20".equals(astAstGb) == false) &&
    			("30".equals(astAstGb) == false) 
    		){
    			status = "N";
				reason = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0017Result(eps0017);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = "서블릿에서 에러가 발생하였습니다.";
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0017Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0018 getEps0018Eps0018(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	EPS0018             eps0018            = new EPS0018();
    	String              pumPumYy           = glInfo.get("APPAPPYY");
    	String              pumPumNo           = glInfo.get("BMSSRLNO");
    	String              appAppNo           = glInfo.get("APPAPPNO");
    	String              appAppAm           = glInfo.get("APPAPPAM");
    	String              jumJumCd           = glInfo.get("JUMJUM_CD");
    	String              bdsBdsCd           = glInfo.get("BDSBDSCD");
    	String              trnTrnGb           = glInfo.get("DEAL_KIND");
    	String              durTerMy           = glInfo.get("USE_KIND");
    	String              useUseVl           = glInfo.get("DEAL_AREA");
    	String              totBcbAm           = glInfo.get("DEAL_DEBT");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              unqUnqNo           = null;
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 unqUnqNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	totBcbAm = totBcbAm.replace(",", "");
    	unqUnqNo = bdsBdsCd.substring(unqUnqNoStartIndex, bdsBdsCdLength);
    	
    	eps0018.setMODE("C");
    	eps0018.setPUMPUMYY(pumPumYy);
    	eps0018.setPUMPUMNO(pumPumNo);
    	eps0018.setAPPAPPNO(appAppNo);
    	eps0018.setAPPAPPAM(appAppAm);
    	eps0018.setJUMJUMCD(jumJumCd);
    	eps0018.setASTASTGB(astAstGb);
    	eps0018.setUNQUNQNO(unqUnqNo);
    	eps0018.setACTACTGB("03");
    	eps0018.setCHGCHGAM(appAppAm);
    	eps0018.setTRNTRNGB(trnTrnGb);
    	eps0018.setUSRUSRID(id);
    	eps0018.setDURTERMY(durTerMy);
    	eps0018.setUSEUSEVL(useUseVl);
    	eps0018.setTOTBCBAM(totBcbAm);
    	eps0018.setINF_REF_NO(infNo);
    	eps0018.setETCETCNY(lnList.get(0).get("REMARK"));
    	
    	return eps0018;
    }
    
    private void insertSinfep0018Info(EPS0018 eps0018, SepoaInfo info, String infNo) throws Exception{
    	Object[]            svcObj         = new Object[1];
    	Map<String, String> sinfEp0018Info = new HashMap<String, String>();
    	SepoaOut            value          = null;
    	String              houseCode      = info.getSession("HOUSE_CODE");
    	String              infMode        = eps0018.getMODE();
    	String              pumPumYy       = eps0018.getPUMPUMYY();
    	String              pumPumNo       = eps0018.getPUMPUMNO();
    	String              appAppNo       = eps0018.getAPPAPPNO();
    	String              appAppAm       = eps0018.getAPPAPPAM();
    	String              jumJumCd       = eps0018.getJUMJUMCD();
    	String              astAstGb       = eps0018.getASTASTGB();
    	String              unqUnqNo       = eps0018.getUNQUNQNO();
    	String              actActGb       = eps0018.getACTACTGB();
    	String              chgChgAm       = eps0018.getCHGCHGAM();
    	String              trnTrnGb       = eps0018.getTRNTRNGB();
    	String              usrUsrId       = eps0018.getUSRUSRID();
    	String              durTerMy       = eps0018.getDURTERMY();
    	String              useUseVl       = eps0018.getUSEUSEVL();
    	String              totBcbAm       = eps0018.getTOTBCBAM();
    	boolean             flag           = false;
    	
    	sinfEp0018Info.put("HOUSE_CODE", houseCode);
    	sinfEp0018Info.put("INF_NO",     infNo);
    	sinfEp0018Info.put("INF_MODE",   infMode);
    	sinfEp0018Info.put("PUMPUMYY",   pumPumYy);
    	sinfEp0018Info.put("PUMPUMNO",   pumPumNo);
    	sinfEp0018Info.put("APPAPPNO",   appAppNo);
    	sinfEp0018Info.put("APPAPPAM",   appAppAm);
    	sinfEp0018Info.put("JUMJUMCD",   jumJumCd);
    	sinfEp0018Info.put("ASTASTGB",   astAstGb);
    	sinfEp0018Info.put("UNQUNQNO",   unqUnqNo);
    	sinfEp0018Info.put("ACTACTGB",   actActGb);
    	sinfEp0018Info.put("CHGCHGAM",   chgChgAm);
    	sinfEp0018Info.put("TRNTRNGB",   trnTrnGb);
    	sinfEp0018Info.put("USRUSRID",   usrUsrId);
    	sinfEp0018Info.put("DURTERMY",   durTerMy);
    	sinfEp0018Info.put("USEUSEVL",   useUseVl);
    	sinfEp0018Info.put("TOTBCBAM",   totBcbAm);
		
    	svcObj[0] = sinfEp0018Info;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0018Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEPS0018Result(EPS0018 eps0018) throws Exception{
		EPS0018Response              eps0018Response = new EPS0018_WSStub().ePS0018(eps0018);
		EPS0018_WSStub.ArrayOfString arrayOfString   = eps0018Response.getEPS0018Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    private void updateSinfep0018Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0018Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String[] getEps0018(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0018  eps0018      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0018", "S");
    		eps0018  = this.getEps0018Eps0018(gdReq, info, infNo, glInfo, lnList);
    		astAstGb = eps0018.getASTASTGB();
    		
    		this.insertSinfep0018Info(eps0018, info, infNo);
    		
    		if("30".equals(astAstGb) == false){
    			status = "N";
				reason = "임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0018Result(eps0018);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0018Info(info, infNo, result);
    	
    	return result;
    }
	
	private String getTcpReturnCodeBoolean(String returnMessage) throws Exception{
		String result = returnMessage.substring(0,3);
		
		if("SUC".equals(result)){
			result = "Y";
		}
		else{
			result = "N";
		}
		
		return result;
	}
	
	private void paySendAppBCB01000T03A(SepoaInfo info, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN) throws Exception{
		String returnMessage  = null;
        String returnCode     = null;
        
		returnMessage = this.setTcpBCB01000T(info, "tcpBCB01000T03", "A", spy1List, glInfo, HoisuYN, "@@" ); //계좌유효성검사 //TOBE 2017-07-01 추가 "@@" 인자수 맞추기위함 미사용
		returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
		
		this.insertSinfhdBCB01000T(info, "BCB01000T03A", returnCode, returnMessage); //interface 입력
		
		if("Y".equals(returnCode) == false){
			throw new Exception(returnMessage);
		}
	}
	
	private void paySendAppBCB01000T02Y(GridData gdReq, SepoaInfo info, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN, String statusCd) throws Exception{ //TOBE 2017-07-01 추가 상태코드
		String returnMessage  = null;
        String returnCode     = null;

		returnMessage = setTcpBCB01000T(info, "tcpBCB01000T02", "Y", spy1List, glInfo, HoisuYN, statusCd); //BS정상전문 TOBE 2017-07-01 추가 상태코드
		returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
		
		this.insertSinfhdBCB01000T(info, "BCB01000T02Y", returnCode, returnMessage); //interface 입력
		
		if("Y".equals(returnCode) == false){
			throw new Exception(returnMessage);
		}
		glInfo.put("STATUS_CD", "10");
		
		//ASIS 2017-07-01 전표번호 glInfo.put("BS_NUM", returnMessage.replaceAll("SUC:", ""));
		//TOBE 2017-07-01 전표번호,로그키값
		Logger.sys.println("n02.returnMessage          : " + returnMessage);
		Logger.sys.println("n02.result.BS_NUM          : " + returnMessage.substring(4 , 8));
		Logger.sys.println("n02.result.SLIP_NO         : " + returnMessage.substring(8 , 24));
		Logger.sys.println("n02.result.TRN_LOG_KEY_VAL : " + returnMessage.substring(24, 80));
		
		glInfo.put("BS_NUM"         , returnMessage.substring(4 , 8));
		glInfo.put("SLIP_NO"        , returnMessage.substring(8 , 24));
		glInfo.put("TRN_LOG_KEY_VAL", returnMessage.substring(24, 80));
		
		this.updateSpy1glBSNum(gdReq, info, glInfo); //TOBE 2017-07-01 텔러번호4,전표번호16, 로그키값56
	}
	
	private void paySendAppBCB01000T03Y(GridData gdReq, SepoaInfo info, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN) throws Exception{
		String returnMessage  = null;
        String returnCode     = null;
        try{
			returnMessage = setTcpBCB01000T(info, "tcpBCB01000T03", "Y", spy1List, glInfo, HoisuYN, "@@"); //계좌이체 //TOBE 2017-07-01 추가 "@@" 인자수 맞추기위함 미사용
			returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
			
			this.insertSinfhdBCB01000T(info, "BCB01000T03Y", returnCode, returnMessage); //interface 입력
			
			if("Y".equals(returnCode) == false){
				throw new Exception(returnMessage);
			}
			
			glInfo.put("ACC_NUM", returnMessage.replaceAll("SUC:", ""));
			glInfo.put("TCP_STATE", "Y");
			glInfo.put("STATUS_CD", "20");
			
			this.updateSpy1glTcpState(gdReq, info, glInfo);		// 계좌이체 결과 저장
        }catch(Exception e){
        	throw new Exception(returnMessage);
        }
	}
	
	private void paySendAppEps(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> spy1List) throws Exception{
		String   workKind     = glInfo.get("WORK_KIND");
		String   dealDebt      = glInfo.get("DEAL_DEBT");
		String   resultCode   = null;
		String   paySendNo    = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
		String[] result       = null;
		
		if("1".equals(workKind)){
			result = this.getEps0015(gdReq, info, glInfo, spy1List);
		}
		else if("2".equals(workKind)){
			result = this.getEps0016(gdReq, info, glInfo, spy1List);
		}
		else if("3".equals(workKind)){
			result = this.getEps0017(gdReq, info, glInfo, spy1List);
		}
		else if("4".equals(workKind)){
			if(dealDebt.equals("")){
				result = this.getEps0017(gdReq, info, glInfo, spy1List);
			}
			else{
				result = this.getEps0018(gdReq, info, glInfo, spy1List);
			}			
		}
		
		resultCode = (result != null)?result[0]:"";
		//resultCode = "200"; // TOBE 2017-08-24 웹서비스 오류로 일시적 추가 로직 오픈시 필수 제거
		if("200".equals(resultCode)){
			this.updateSpy1glWebState(info, paySendNo);
		}else{
			throw new Exception("[웹서비스 처리안됨] " + ((result != null)?result[1]:""));
		}
	}
	
	private void paySendAppUpdateSinfep0016Info(SepoaInfo info, List<Map<String, String>> spy1List) throws Exception{
		Object[]            obj     = new Object[1];
		Map<String, Object> objInfo = new HashMap<String, Object>();
		Map<String, String> header  = new HashMap<String, String>();
		
		header.put("SPY_CHECK",     "Y");
		header.put("PROGRESS_CODE", "E");
		
		objInfo.put("header",   header);
		objInfo.put("spy1List", spy1List);
		
		obj[0] = objInfo;
		
		ServiceConnector.doService(info, "TX_010", "TRANSACTION", "updateIcoytxdtSpycheck", obj);
	}
	
	private void updateSpy1glExeTryDt(SepoaInfo info,  Map<String, String> glInfo) throws Exception{
    	SepoaOut value        = null;
    	Object[] obj          = new Object[1];
    	boolean  isStatus     = false;
    	
    	obj[0]   = glInfo;
		value    = ServiceConnector.doService(info, "TX_011", "TRANSACTION", "updateSpy1glExeTryDt", obj);
		isStatus = value.flag;

		if(isStatus == false){
			throw new Exception();
		}
    }
	
	private void updateSpy1glCcltTryDt(SepoaInfo info,  Map<String, String> glInfo) throws Exception{
    	SepoaOut value        = null;
    	Object[] obj          = new Object[1];
    	boolean  isStatus     = false;
    	
    	obj[0]   = glInfo;
		value    = ServiceConnector.doService(info, "TX_011", "TRANSACTION", "updateSpy1glCcltTryDt", obj);
		isStatus = value.flag;

		if(isStatus == false){
			throw new Exception();
		}
    }
	
    private GridData paySendApp(GridData gdReq, SepoaInfo info) throws Exception { //정상전송
    	GridData                  gdRes        = new GridData();
    	String                    gdResMessage = null;
    	String                    paySendNo    = null;
    	String                    paySendBio   = null;
    	String                    statusCd     = null;
    	String                    accountKind  = null;
    	String                    txtMnno      = null;
    	Map<String, String>       glInfo       = null;
    	List<Map<String, String>> spy1List     = null;
    	boolean                   isStatus     = true;
    	int                       spy1ListSize = 0;
    	double                    exe_try_term = 0.0;
    	
    	String HoisuYN = "N";  // Y : 회수 , N : 회수아님
		String returnMessage  = null;
	    String returnCode     = null;
	    String[] result       = null;
    	
        try {
			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
			paySendNo    = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
    		paySendBio   = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_BIO"));
//    		txtMnno      = JSPUtil.CheckInjection(gdReq.getParam("TXT_MNNO"));       		
//===================================중복 실행 체크============================================    		 		    		
    		TimeUnit.MILLISECONDS.sleep((long)(Math.random() * (2000 - 0 + 1) + 0)); // 2000 millisecond ~ 0 millisecond
    		glInfo       = this.selectSpy1glInfo(info, paySendNo);
    		this.updateSpy1glExeTryDt(info, glInfo);		//실행TRY일시 저장
    		exe_try_term = Double.parseDouble(glInfo.get("EXE_TRY_TERM"));    		
    		if(exe_try_term < 90 ){
    			Logger.info.println("중복실행TRY / 자본예산 지급번호 - " + paySendNo + " / 실행TRY텀 - " + exe_try_term);
    			throw new Exception("중복실행TRY / 자본예산 지급번호 - " + paySendNo + " /클라이언트 - " + JSPUtil.CheckInjection(gdReq.getParam("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 실행TRY텀 - " + exe_try_term);
//    			throw new Exception("중복실행TRY - 2분후 다시 시도 해 보세요.");
    		}
//    		if(exe_try_term >= 90 ){
//    			throw new Exception("실행완료 / 지급번호 - " + paySendNo + " /클라이언트 - " + JSPUtil.CheckInjection(gdReq.getParam("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 실행TRY텀 - " + exe_try_term);    			
//    		}    		
//========================================================================================= 
    		spy1List     = this.selectSpy1List(info, paySendNo);
			spy1ListSize = spy1List.size();
			statusCd     = glInfo.get("STATUS_CD");
			accountKind  = glInfo.get("ACCOUNTKIND");
			
			glInfo.put("PAY_SEND_BIO", paySendBio);
			glInfo.put("TXT_MNNO",     txtMnno);
			
			if(spy1ListSize == 0){
				throw new Exception("Not Exist glInfo");
			}
			
			if(
				("1".equals(accountKind)) &&
				(
					("00".equals(statusCd)) ||
					("03".equals(statusCd)) ||
					("85".equals(statusCd)) ||
					("70".equals(statusCd)) ||
					("10".equals(statusCd))
				)
			){
				this.paySendAppBCB01000T03A(info, spy1List, glInfo, HoisuYN); //계좌유효성검사
			}
			
			if(
				("00".equals(statusCd)) ||
				("03".equals(statusCd)) ||
				("70".equals(statusCd)) ||
				("85".equals(statusCd))
			){
				this.paySendAppBCB01000T02Y(gdReq, info, spy1List, glInfo, HoisuYN, statusCd); //BS정상전문 TOBE 2017-07-01 추가 상태코드
				
				statusCd = "10";
			}
			
			if(("10".equals(statusCd)) && ("1".equals(accountKind))){
				this.paySendAppBCB01000T03Y(gdReq, info, spy1List, glInfo, HoisuYN); //계좌이체
				
				statusCd = "20"; //TOBE 2017-07-01 추가 이체완료
			}
						
			
			//TOBE 2017-07-01 추가 책임자 승인 명세 (정상)

			if( (("10".equals(statusCd)) && ("2".equals(accountKind))) ||  //10:BS등재건이면서 이체대상이 아니거나
				 ("20".equals(statusCd)) ) {                               //20:이체완료된건
				
				if(paySendBio.length() > 0){ 
					returnMessage = this.tcpICAA9010200(info, "Y", spy1List, glInfo, HoisuYN); //책임자승인명세
					returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
					
					this.insertSinfhdBCB01000T(info, "ICAA9010200Y", returnCode, returnMessage); //interface 입력
					
					if("Y".equals(returnCode) == false){
						throw new Exception(returnMessage);
					}else {
						glInfo.put("STATUS_CD", "24");                      // 24:책임자전송완료
						this.updateSpy1glTcpState(gdReq, info, glInfo);		// 책임자승인명세 결과 저장
					}	
				} 
				statusCd = "24";
			}
			

			//TOBE 2017-07-01 추가 재산관리 입지대사				
			if("24".equals(statusCd)){
				returnMessage = this.tcpBCB01000T02(info, "tcpBCB01000T02", "Y", spy1List, glInfo, HoisuYN, statusCd); //TOBE 2017-07-01 추가 상태코드
				returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
			
				if("Y".equals(returnCode) == false){
					throw new Exception(returnMessage);
				}else {
					glInfo.put("STATUS_CD", "27");                      // 27:입지전송완료
					this.updateSpy1glTcpState(gdReq, info, glInfo);		// 입지전송완료 결과 저장
					statusCd = "27";
				}
			}	
			
			
			this.paySendAppEps(gdReq, info, glInfo, spy1List); //웹서비스
			this.paySendAppUpdateSinfep0016Info(info, spy1List);

			gdResMessage = this.successJson();
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.failJson(e.getMessage());
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
	}
    
    private void payCancelAppBCB01000T02N(GridData gdReq, SepoaInfo info, List<Map<String, String>> spy1List, Map<String, String> glInfo, String statusCd, String HoisuYN) throws Exception{
    	String returnMessage = "";
    	String returnCode    = "";
    	
	    returnMessage = this.setTcpBCB01000T(info, "tcpBCB01000T02", "N", spy1List, glInfo, HoisuYN, statusCd); //TOBE 2017-07-01 추가 상태코드
	    returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
	    
		this.insertSinfhdBCB01000T(info, "BCB01000T02N", returnCode, returnMessage); //interface 입력
	
		if(!"ERR".equals(returnMessage.substring(0,3))){
			glInfo.put("RTN_BS_NUM", returnMessage.substring(4,8));
			glInfo.put("STATUS_CD", statusCd);
				
			this.updateSpy1glBSNum(gdReq, info, glInfo);	 
		}
		
		if("Y".equals(returnCode) == false){
			throw new Exception(returnMessage);
		}
    }
    
    private void payCancelAppBCB01000T03N(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> spy1List, String statusCd, String HoisuYN) throws Exception{
    	String returnMessage = "";
    	String returnCode    = "";
    	
    	returnMessage = setTcpBCB01000T(info, "tcpBCB01000T03", "N", spy1List, glInfo, HoisuYN, "@@"); //계좌이체취소 //TOBE 2017-07-01 추가 "@@" 인자수 맞추기위함 미사용
    	returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
		
		this.insertSinfhdBCB01000T(info, "BCB01000T03N", returnCode, returnMessage); //interface 입력		
		
		glInfo.put("tcp_state", "N");
		glInfo.put("STATUS_CD", statusCd);
		
		if("Y".equals(returnCode) == false){
			throw new Exception(returnMessage);
		}
		
		this.updateSpy1glTcpState(gdReq, info, glInfo);		// 계좌이체 취소결과 저장
    }
    
    private EPS0015 getEps0015Eps0015R(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
		EPS0015                      eps0015       = new EPS0015();
		String                       appAppYy      = glInfo.get("APPAPPYY");
		String                       pumPumNo      = glInfo.get("BMSSRLNO");
		String                       appAppNo      = glInfo.get("APPAPPNO");
		String                       appAppAm      = glInfo.get("APPAPPAM");
		String                       id            = this.getWebserviceId(info);
		EPS0015_WSStub.ArrayOfString jumJumCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkPmkCdArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString pmkSrlNoArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString mdlMdlNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString cntArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString amtArray      = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString buyBuyNmArray = new EPS0015_WSStub.ArrayOfString();
		EPS0015_WSStub.ArrayOfString etcEtcNyArray = new EPS0015_WSStub.ArrayOfString();
		
		appAppAm = appAppAm.replace(",", "");
		
		eps0015.setMODE("R");
		eps0015.setBNKCD("20");
		eps0015.setPUMPUMYY(appAppYy);
		eps0015.setPUMPUMNO(pumPumNo);
		eps0015.setAPPAPPNO(appAppNo);
		eps0015.setAPPAPPAM(appAppAm);
		eps0015.setJUMJUMCD(jumJumCdArray);
		eps0015.setPMKPMKCD(pmkPmkCdArray);
		eps0015.setPMKSRLNO(pmkSrlNoArray);
		eps0015.setMDLMDLNM(mdlMdlNmArray);
		eps0015.setCNT(cntArray);
		eps0015.setAMT(amtArray);
		eps0015.setBUYBUYNM(buyBuyNmArray);
		eps0015.setETCETCNY(etcEtcNyArray);
		eps0015.setUSRUSRID(id);
		eps0015.setINF_REF_NO(infNo);
		
		return eps0015;
	}
    
    private void insertSinfep0015InfoR(EPS0015 eps0015, SepoaInfo info, String infNo) throws Exception{
		Object[]                  svcParamObj      = new Object[1];
		Map<String, Object>       svcParamObjInfo  = new HashMap<String, Object>();
		Map<String, String>       sinfEp0015Info   = this.insertSinfep0015InfoSinfEp0015Info(eps0015, info, infNo);
		List<Map<String, String>> sinfEp0015PrList = new ArrayList<Map<String, String>>();
		SepoaOut                  value            = null;
		boolean                   flag             = false;
		
		svcParamObjInfo.put("sinfEp0015Info",   sinfEp0015Info);
		svcParamObjInfo.put("sinfEp0015PrList", sinfEp0015PrList);
		
		svcParamObj[0] = svcParamObjInfo;
		
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0015Info", svcParamObj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
	}
    
    private String[] getEps0015R(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0015  eps0015      = null;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0015R", "S");
    		eps0015 = this.getEps0015Eps0015R(gdReq, info, infNo, glInfo, lnList);
    		
    		this.insertSinfep0015InfoR(eps0015, info, infNo);
    		
    		result       = this.getEPS0015Result(eps0015);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}else if("714".equals(code)){ // "이미 취소 되었습니다."
    			status = "Y";
				reason = "";
				
				result[0] = "200";
				result[1] = "실행성공";
				result[2] = "";				
    		}else{
    			status = "N";
				reason = result[1];
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			infReceiveNo = "";
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0015Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0016 getEps0016Eps0016R(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	EPS0016                      eps0016      = new EPS0016();
    	String                       appAppYy     = glInfo.get("APPAPPYY");
    	String                       bmsSrlNo     = glInfo.get("BMSSRLNO");
    	String                       appAppNo     = glInfo.get("APPAPPNO");
    	String                       appAppAm     = glInfo.get("APPAPPAM");
    	String                       id           = this.getWebserviceId(info);
    	EPS0016_WSStub.ArrayOfString dosUnqNo     = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString updjbmt      = new EPS0016_WSStub.ArrayOfString();
    	EPS0016_WSStub.ArrayOfString etcEtcNy     = new EPS0016_WSStub.ArrayOfString();
    	
    	appAppAm = appAppAm.replace(",", "");
    	
    	eps0016.setMODE("R");
    	eps0016.setBNKBNKCD("20");
    	eps0016.setPUMPUMYY(appAppYy);
    	eps0016.setPUMPUMNO(bmsSrlNo);
    	eps0016.setAPPAPPNO(appAppNo);
    	eps0016.setAPPAPPAM(appAppAm);
    	eps0016.setDOSUNQNO(dosUnqNo);
    	eps0016.setUPDJBMT(updjbmt);
    	eps0016.setETCETCNY(etcEtcNy);
    	eps0016.setUSRUSRID(id);
    	eps0016.setINF_REF_NO(infNo);
    	
    	return eps0016;
    }
    
    private void insertSinfep0016InfoR(EPS0016 eps0016, SepoaInfo info, String infNo) throws Exception{
    	Object[]                  svcObj           = new Object[1];
    	Map<String, Object>       svcObjInfo       = new HashMap<String, Object>();
    	Map<String, String>       sinfEp0016Info   = this.insertSinfep0016InfoSinfEp0016Info(eps0016, info, infNo);
    	List<Map<String, String>> sinfEp0016PrList = new ArrayList<Map<String, String>>();
    	SepoaOut                  value            = null;
    	boolean                   flag             = false;
    	
    	svcObjInfo.put("sinfEp0016Info",   sinfEp0016Info);
    	svcObjInfo.put("sinfEp0016PrList", sinfEp0016PrList);
    	
    	svcObj[0] = svcObjInfo;
    	
    	value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0016Info", svcObj);
    	flag  = value.flag;
    	
    	if(flag == false){
			throw new Exception();
		}
    }
    
    private String[] getEps0016R(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0016  eps0016      = null;
    	
    	try {
    		infNo   = this.insertSinfhdInfo(info, "EPS0016R", "S");
    		eps0016 = this.getEps0016Eps0016R(gdReq, info, infNo, glInfo, lnList);
    		
    		this.insertSinfep0016InfoR(eps0016, info, infNo);
    		
    		result       = this.getEPS0016Result(eps0016);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}
    		else{
    			status = "N";
				reason = result[1];
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
	    	status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0016Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0017 getEps0017Eps0017R(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo) throws Exception{
    	EPS0017             result             = new EPS0017();
    	String              pumPumYy           = glInfo.get("APPAPPYY"); 
    	String              pumPumNo           = glInfo.get("BMSSRLNO"); 
    	String              appAppNo           = glInfo.get("APPAPPNO"); 
    	String              appAppAm           = glInfo.get("APPAPPAM"); 
    	String              jumJumCd           = glInfo.get("JUMJUM_CD");
    	String              bdsBdsCd           = glInfo.get("BDSBDSCD"); 
    	String              trnTrnGb           = glInfo.get("DEAL_KIND");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              bdsBdsNo           = null;
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 bdsBdsNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	bdsBdsNo = bdsBdsCd.substring(bdsBdsNoStartIndex, bdsBdsCdLength);
    	
    	result.setMODE("R");
    	result.setPUMPUMYY(pumPumYy);
    	result.setPUMPUMNO(pumPumNo);
    	result.setAPPAPPNO(appAppNo);
    	result.setAPPAPPAM(appAppAm);
    	result.setJUMJUMCD(jumJumCd);
    	result.setASTASTGB(astAstGb);
    	result.setUNQUNQNO(bdsBdsNo);

    	//TOBE 2017-07-01 ASTASTGB 자산구분이 20:건물일때는 , ACTACTGB 계정구분02 업무용건물로 변경 , 그외는 임차점포시설물 밖에 없다 
    	if (("20").equals(astAstGb)) {
    	    result.setACTACTGB("02");
    	}else {
    		result.setACTACTGB("03");
    	}
    	result.setCHGCHGAM(appAppAm);
    	result.setTRNTRNGB(trnTrnGb);
    	result.setUSRUSRID(id);
    	result.setINF_REF_NO(infNo);
    	
    	return result;
    }
    
    private String[] getEps0017R(GridData gdReq, SepoaInfo info, Map<String, String> glInfo) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0017  eps0017      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0017R", "S");
    		eps0017  = this.getEps0017Eps0017R(gdReq, info, infNo, glInfo);
    		astAstGb = eps0017.getASTASTGB();
    		
    		this.insertSinfep0017Info(eps0017, info, infNo);
    		
    		if(
    			("10".equals(astAstGb) == false) &&
    			("20".equals(astAstGb) == false) &&
    			("30".equals(astAstGb) == false)
    		){
    			status = "N";
				reason = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "토지, 건물, 임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0017Result(eps0017);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = "서블릿에서 에러가 발생하였습니다.";
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0017Info(info, infNo, result);
    	
    	return result;
    }
    
    private EPS0018 getEps0018Eps0018R(GridData gdReq, SepoaInfo info, String infNo, Map<String, String> glInfo) throws Exception{
    	EPS0018             eps0018            = new EPS0018();
    	String              pumPumYy           = glInfo.get("APPAPPYY");
    	String              pumPumNo           = glInfo.get("BMSSRLNO");
    	String              appAppNo           = glInfo.get("APPAPPNO");
    	String              appAppAm           = glInfo.get("APPAPPAM");
    	String              jumJumCd           = glInfo.get("JUMJUM_CD");
    	String              bdsBdsCd           = glInfo.get("BDSBDSCD");
    	String              trnTrnGb           = glInfo.get("DEAL_KIND");
    	String              durTerMy           = glInfo.get("USE_KIND");
    	String              useUseVl           = glInfo.get("DEAL_AREA");
    	String              totBcbAm           = glInfo.get("DEAL_DEBT");
    	String              astAstGb           = bdsBdsCd.substring(0, 2);
    	String              unqUnqNo           = null;
    	String              id                 = this.getWebserviceId(info);
    	int                 bdsBdsCdLength     = bdsBdsCd.length();
    	int                 unqUnqNoStartIndex = bdsBdsCdLength - 5;
    	
    	appAppAm = appAppAm.replace(",", "");
    	totBcbAm = totBcbAm.replace(",", "");
    	unqUnqNo = bdsBdsCd.substring(unqUnqNoStartIndex, bdsBdsCdLength);
    	
    	eps0018.setMODE("R");
    	eps0018.setPUMPUMYY(pumPumYy);
    	eps0018.setPUMPUMNO(pumPumNo);
    	eps0018.setAPPAPPNO(appAppNo);
    	eps0018.setAPPAPPAM(appAppAm);
    	eps0018.setJUMJUMCD(jumJumCd);
    	eps0018.setASTASTGB(astAstGb);
    	eps0018.setUNQUNQNO(unqUnqNo);
    	eps0018.setACTACTGB("03");
    	eps0018.setCHGCHGAM(appAppAm);
    	eps0018.setTRNTRNGB(trnTrnGb);
    	eps0018.setUSRUSRID(id);
    	eps0018.setDURTERMY(durTerMy);
    	eps0018.setUSEUSEVL(useUseVl);
    	eps0018.setTOTBCBAM(totBcbAm);
    	eps0018.setINF_REF_NO(infNo);
    	
    	return eps0018;
    }
    
    private String[] getEps0018R(GridData gdReq, SepoaInfo info, Map<String, String> glInfo) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String   astAstGb     = null;
    	String[] result       = new String[3];
    	EPS0018  eps0018      = null;
    	
    	try {
    		infNo    = this.insertSinfhdInfo(info, "EPS0018R", "S");
    		eps0018  = this.getEps0018Eps0018R(gdReq, info, infNo, glInfo);
    		astAstGb = eps0018.getASTASTGB();
    		
    		this.insertSinfep0018Info(eps0018, info, infNo);
    		
    		if("30".equals(astAstGb) == false){
    			status = "N";
				reason = "임차점포시설물만 거래가능합니다.";
    			
    			result[0] = "901";
    			result[1] = "임차점포시설물만 거래가능합니다.";
    			result[2] = null;
    		}
    		else{
    			result       = this.getEPS0018Result(eps0018);
        		code         = result[0];
        		infReceiveNo = result[3];
        		
        		if("200".equals(code)){
        			status = "Y";
    				reason = "";
        		}
        		else{
        			status = "N";
    				reason = result[1];
        		}
    		}
    	}
    	catch(Exception e){
    		status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0018Info(info, infNo, result);
    	
    	return result;
    }
    
    private void updateSpy1glWebStateR(SepoaInfo info, String paySendNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("HOUSE_CODE",  houseCode);
			param.put("PAY_SEND_NO", paySendNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "TX_010", "TRANSACTION", "updateSpy1glWebStateR", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private void paySendAppEpsCancle(GridData gdReq, SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> spy1List) throws Exception{
		String   workKind   = glInfo.get("WORK_KIND");
		String   dealDebt    = glInfo.get("DEAL_DEBT");
		String   resultCode = null;
		String   paySendNo  = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
		String[] result     = null;
		
		if("1".equals(workKind)){
			result = this.getEps0015R(gdReq, info, glInfo, spy1List);
		}
		else if("2".equals(workKind)){
			result = this.getEps0016R(gdReq, info, glInfo, spy1List);
		}
		else if("3".equals(workKind)){
			result = this.getEps0017R(gdReq, info, glInfo);
		}
		else if("4".equals(workKind)){
			if(dealDebt.equals("")){
				result = this.getEps0017R(gdReq, info, glInfo);
			}
			else{
				result = this.getEps0018R(gdReq, info, glInfo);
			}
		}
		
		resultCode = (result != null)?result[0]:"";
		//resultCode = "200"; // TOBE 2017-08-24 웹서비스 오류로 일시적 추가 로직 오픈시 필수 제거
		if("200".equals(resultCode)){
			this.updateSpy1glWebStateR(info, paySendNo);
		}
		else{
			throw new Exception("[웹서비스 처리안됨]  " + ((result != null)?result[1]:"") );
		}
	}

    private GridData payCancelApp(GridData gdReq, SepoaInfo info) throws Exception { //취소전문
    	GridData                  gdRes        = new GridData();
    	String                    gdResMessage = null;  
    	String                    paySendNo    = null;
    	String                    paySendBio   = null;
    	String                    accountKind  = null;
    	String                    statusCd     = null;
    	String                    txtMnno      = null;
    	Map<String, String>       glInfo       = null;
		List<Map<String, String>> spy1List     = null;
		boolean                   isStatus     = true;
    	int                       spy1ListSize = 0;
    	double                    cclt_try_term = 0.0;
    	
    	String HoisuYN = "N";  // Y : 회수 , N : 회수아님
		String returnMessage  = null;
	    String returnCode     = null;
	    String[] result       = null;
	    
        try {
			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
			paySendNo    = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
    		paySendBio   = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_BIO"));
    		txtMnno      = JSPUtil.CheckInjection(gdReq.getParam("TXT_MNNO"));
    		
//===================================중복 취소 체크============================================    		 		    		
    		TimeUnit.MILLISECONDS.sleep((long)(Math.random() * (2000 - 0 + 1) + 0)); // 2000 millisecond ~ 0 millisecond
    		glInfo       = this.selectSpy1glInfo(info, paySendNo);
    		this.updateSpy1glCcltTryDt(info, glInfo);		//취소TRY일시 저장
    		cclt_try_term = Double.parseDouble(glInfo.get("CCLT_TRY_TERM"));    		
    		if(cclt_try_term < 90 ){
    			Logger.info.println("중복취소TRY / 자본예산 지급번호 - " + paySendNo + " / 취소TRY텀 - " + cclt_try_term);
    			throw new Exception("중복취소TRY / 자본예산 지급번호 - " + paySendNo + " /클라이언트 - " + JSPUtil.CheckInjection(gdReq.getParam("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 취소TRY텀 - " + cclt_try_term);
    			//throw new Exception("중복취소TRY - 2분후 다시 시도 해 보세요.");
    		}
//    		if(cclt_try_term >= 90 ){
//    			throw new Exception("취소완료 / 지급번호 - " + paySendNo + " /클라이언트 - " + JSPUtil.CheckInjection(gdReq.getParam("HHMMSS")) + " / 서버 - " + SepoaDate.getTimeStampString() + " / 취소TRY텀 - " + cclt_try_term);    			
//    		}    		
//========================================================================================= 
    		    		
    		spy1List     = this.selectSpy1List(info, paySendNo);
			spy1ListSize = spy1List.size();
			accountKind  = glInfo.get("ACCOUNTKIND");
			statusCd     = glInfo.get("STATUS_CD");
			
			glInfo.put("PAY_SEND_BIO", paySendBio);
			glInfo.put("TXT_MNNO",     txtMnno);
			
			if(spy1ListSize == 0){
				throw new Exception();
			}
			

//			자본예산대금집행이 계좌이체(안함)건 취소시 BS취소가 안되는 오류발생 
//////////////////////////////////////////////////////////////////////////////////////////////
//			if(("1".equals(accountKind)) && ("40".equals(statusCd))){
//				this.paySendAppBCB01000T03A(info, spy1List, glInfo,HoisuYN); //계좌유효성검사
//				this.payCancelAppBCB01000T03N(gdReq, info, glInfo, spy1List, "50",HoisuYN);
//				
//				statusCd = "50";
//			}
//			
//			if("50".equals(statusCd)){
//				this.payCancelAppBCB01000T02N(gdReq, info, spy1List, glInfo, "60",HoisuYN);
//			}
///////////////////////////////////////////////////////////////////////////////////////////////			
			
			if("1".equals(accountKind)){ // 계좌이체건인 경우				
				
				if("40".equals(statusCd)){ //취소요청상태
					this.paySendAppBCB01000T03A(info, spy1List, glInfo,HoisuYN); //계좌유효성검사
					this.payCancelAppBCB01000T03N(gdReq, info, glInfo, spy1List, "50",HoisuYN); //계좌이체취소
					
					statusCd = "50";
				}
				
				if("50".equals(statusCd)){ // 이체취소상태
					this.payCancelAppBCB01000T02N(gdReq, info, spy1List, glInfo, "60",HoisuYN); //BS취소
					
					statusCd = "60"; //TOBE 2017-07-01 추가
				}
				
			}else if("2".equals(accountKind)){ // 계좌이체(안함)건인 경우
				
				if("40".equals(statusCd)){ //취소요청상태
					this.payCancelAppBCB01000T02N(gdReq, info, spy1List, glInfo, "60",HoisuYN); //BS취소 
					
					statusCd = "60"; //TOBE 2017-07-01 추가
				}
				
			}
			
			
			
			//TOBE 2017-07-01 추가 책임자 승인 명세 (취소)
			
			if("60".equals(statusCd)) {                                    //60:BS취소 (50:이체취소->60:BS취소 순으로 일어난다)
				returnMessage = this.tcpICAA9010200(info, "N", spy1List, glInfo, HoisuYN); //책임자승인명세
				returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
				
				this.insertSinfhdBCB01000T(info, "ICAA9010200N", returnCode, returnMessage); //interface 입력
				
				if("Y".equals(returnCode) == false){
					throw new Exception(returnMessage);
				} else {
					glInfo.put("STATUS_CD", "64");                      // 64:책임자전송취소
					this.updateSpy1glTcpState(gdReq, info, glInfo);		// 책임자승인명세 결과 저장
					statusCd = "64";
				}
			}
			
			
			//TOBE 2017-07-01 추가 재산관리 입지대사 (취소)
			if("64".equals(statusCd)){
				returnMessage = this.tcpBCB01000T02(info, "tcpBCB01000T02", "N", spy1List, glInfo, HoisuYN, statusCd); //TOBE 2017-07-01 추가 상태코드
				returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
			
				if("Y".equals(returnCode) == false){
					throw new Exception(returnMessage);
				}else {
					glInfo.put("STATUS_CD", "67");                      // 27:입지전송완료
					this.updateSpy1glTcpState(gdReq, info, glInfo);		// 입지전송완료 결과 저장
					statusCd = "67";
				}
			}	
			
			
			this.paySendAppEpsCancle(gdReq, info, glInfo, spy1List);
			
			gdResMessage = this.successJson();
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.failJson(e.getMessage());
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
	}
    
    
    
    private List<Map<String, String>> selectSpy1List(SepoaInfo info, String paySendNo) throws Exception{
    	List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
    	Map<String, String>       svcObjInfo = new HashMap<String, String>();
    	Map<String, String>       resultInfo = null;
    	Object[]                  svcObj     = new Object[1];
    	String                    houseCode  = info.getSession("HOUSE_CODE");
    	SepoaOut                  value      = null;
    	SepoaFormater             sf         = null;
    	int                       sfRowCount = 0;
    	int                       i          = 0;
    	
    	svcObjInfo.put("HOUSE_CODE",  houseCode);
    	svcObjInfo.put("PAY_SEND_NO", paySendNo);
    	
    	svcObj[0] = svcObjInfo;
    	value     = ServiceConnector.doService(info, "TX_011", "CONNECTION", "selectSpy1List", svcObj);
    	
    	sf = new SepoaFormater(value.result[0]);
    	
    	sfRowCount = sf.getRowCount();
    	
    	for(i = 0; i < sfRowCount; i++){
    		resultInfo = new HashMap<String, String>();
    		
        	resultInfo.put("HOUSE_CODE",          sf.getValue("HOUSE_CODE",          i));
        	resultInfo.put("PAY_SEND_NO",         sf.getValue("PAY_SEND_NO",         i));
        	resultInfo.put("VENDOR_CODE",         sf.getValue("VENDOR_CODE",         i));
        	resultInfo.put("DEPOSITOR_NAME",      sf.getValue("DEPOSITOR_NAME",      i));
        	resultInfo.put("BANK_CODE",           sf.getValue("BANK_CODE",           i));
        	resultInfo.put("BANK_ACCT",           sf.getValue("BANK_ACCT",           i));
        	resultInfo.put("PAY_AMT",             sf.getValue("PAY_AMT",             i));
        	resultInfo.put("SIGNER_FLAG",         sf.getValue("SIGNER_FLAG",         i));
        	resultInfo.put("SIGNER_NO",           sf.getValue("SIGNER_NO",           i));
        	resultInfo.put("SIGNER_BIO",          sf.getValue("SIGNER_BIO",          i));
        	resultInfo.put("WORK_KIND",           sf.getValue("WORK_KIND",           i));
        	resultInfo.put("BMSBMSYY",            sf.getValue("BMSBMSYY",            i));
        	resultInfo.put("SOGSOGCD",            sf.getValue("SOGSOGCD",            i));
        	resultInfo.put("ASTASTGB",            sf.getValue("ASTASTGB",            i));
        	resultInfo.put("MNGMNGNO",            sf.getValue("MNGMNGNO",            i));
        	resultInfo.put("BSSBSSNO",            sf.getValue("BSSBSSNO",            i));
        	resultInfo.put("APPAPPYY",            sf.getValue("APPAPPYY",            i));
        	resultInfo.put("BMSSRLNO",            sf.getValue("BMSSRLNO",            i));
        	resultInfo.put("APPAPPNO",            sf.getValue("APPAPPNO",            i));
        	resultInfo.put("APPAPPAM",            sf.getValue("APPAPPAM",            i));
        	resultInfo.put("JUMJUM_CD",           sf.getValue("JUMJUM_CD",           i));
        	resultInfo.put("IGJM_CD",             sf.getValue("IGJM_CD",             i));
        	resultInfo.put("BDSBDSCD",            sf.getValue("BDSBDSCD",            i));
        	resultInfo.put("BDSBDSNM",            sf.getValue("BDSBDSNM",            i));
        	resultInfo.put("USE_KIND",            sf.getValue("USE_KIND",            i));
        	resultInfo.put("DEAL_AREA",           sf.getValue("DEAL_AREA",           i));
        	resultInfo.put("DURABLE_YEAR",        sf.getValue("DURABLE_YEAR",        i));
        	resultInfo.put("DEAL_DEBT",           sf.getValue("DEAL_DEBT",           i));
        	resultInfo.put("ACCOUNTKIND",         sf.getValue("ACCOUNTKIND",         i));
        	resultInfo.put("DEAL_KIND",           sf.getValue("DEAL_KIND",           i));
        	resultInfo.put("TRM_RTN_SQNO",        sf.getValue("TRM_RTN_SQNO",        i));
        	resultInfo.put("USER_TRM_NO",         sf.getValue("USER_TRM_NO",         i));
        	resultInfo.put("STATUS_CD",           sf.getValue("STATUS_CD",           i));
        	resultInfo.put("ADD_DATE",            sf.getValue("ADD_DATE",            i));
        	resultInfo.put("ADD_TIME",            sf.getValue("ADD_TIME",            i));
        	resultInfo.put("ADD_USER_ID",         sf.getValue("ADD_USER_ID",         i));
        	resultInfo.put("CHANGE_DATE",         sf.getValue("CHANGE_DATE",         i));
        	resultInfo.put("CHANGE_TIME",         sf.getValue("CHANGE_TIME",         i));
        	resultInfo.put("CHANGE_USER_ID",      sf.getValue("CHANGE_USER_ID",      i));
        	resultInfo.put("TCP_STATE",           sf.getValue("TCP_STATE",           i));
        	resultInfo.put("WEB_STATE",           sf.getValue("WEB_STATE",           i));
        	resultInfo.put("MANUAL_ACCOUNT_KIND", sf.getValue("MANUAL_ACCOUNT_KIND", i));
        	resultInfo.put("DEL_YN",              sf.getValue("DEL_YN",              i));
//    		resultInfo.put("HOUSE_CODE",          sf.getValue("HOUSE_CODE",          i));
//    		resultInfo.put("PAY_SEND_NO",         sf.getValue("PAY_SEND_NO",         i));
    		resultInfo.put("PAY_SEND_SEQ",        sf.getValue("PAY_SEND_SEQ",        i));
    		resultInfo.put("TAX_NO",              sf.getValue("TAX_NO",              i));
    		resultInfo.put("TAX_SEQ",             sf.getValue("TAX_SEQ",             i));
    		resultInfo.put("JUMJUJMCD",           sf.getValue("JUMJUJMCD",           i));
    		resultInfo.put("IGJMCD",              sf.getValue("IGJMCD",              i));
    		resultInfo.put("PMKPMKCD",            sf.getValue("PMKPMKCD",            i));
    		resultInfo.put("CNT",                 sf.getValue("CNT",                 i));
    		resultInfo.put("AMT",                 sf.getValue("AMT",                 i));
    		resultInfo.put("APPAPPAMDT",          sf.getValue("APPAPPAMDT",          i));
    		resultInfo.put("DOSUNQNO",            sf.getValue("DOSUNQNO",            i));
//    		resultInfo.put("ADD_DATE",            sf.getValue("ADD_DATE",            i));
//    		resultInfo.put("ADD_TIME",            sf.getValue("ADD_TIME",            i));
//    		resultInfo.put("ADD_USER_ID",         sf.getValue("ADD_USER_ID",         i));
//    		resultInfo.put("CHANGE_DATE",         sf.getValue("CHANGE_DATE",         i));
//    		resultInfo.put("CHANGE_TIME",         sf.getValue("CHANGE_TIME",         i));
//    		resultInfo.put("CHANGE_USER_ID",      sf.getValue("CHANGE_USER_ID",      i));
    		resultInfo.put("MODEL_NO",            sf.getValue("MODEL_NO",            i));
    		resultInfo.put("REMARK",              sf.getValue("REMARK",              i));
    		resultInfo.put("SPECIFICATION",       sf.getValue("SPECIFICATION",       i));

    		result.add(resultInfo);
    	}
    	
    	return result;
    }
    
    private Object[] updateSpy1glStatusCd03Obj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridDataInfo = new HashMap<String, String>();
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    id           = info.getSession("ID"); 
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    paySendNo    = gdReq.getParam("PAY_SEND_NO");
    	
    	gridDataInfo.put("ADD_USER_ID", id);
    	gridDataInfo.put("HOUSE_CODE",  houseCode);
    	gridDataInfo.put("PAY_SEND_NO", paySendNo);
    	
    	gridData.add(gridDataInfo);
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glStatusCd03(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1glStatusCd03Obj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1glStatusCd03", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    
    
    private void updateSpy1glBSNum(GridData gdReq, SepoaInfo info,  Map<String, String> glInfo) throws Exception{
    	SepoaOut value        = null;
    	Object[] obj          = new Object[1];
    	boolean  isStatus     = false;
    	
    	obj[0]   = glInfo;
		value    = ServiceConnector.doService(info, "TX_011", "TRANSACTION", "updateSpy1glBSNum", obj);
		isStatus = value.flag;

		if(isStatus == false){
			throw new Exception();
		}
    }
    
 
    
    private void updateSpy1glTcpState(GridData gdReq, SepoaInfo info,  Map<String, String> glInfo) throws Exception{
    	SepoaOut value        = null;
    	Object[] obj          = new Object[1];
    	boolean  isStatus     = false;

		obj[0]      = glInfo;
		value    = ServiceConnector.doService(info, "TX_011", "TRANSACTION", "updateSpy1glTcpState", obj);
		isStatus = value.flag;

		if(isStatus == false){
			throw new Exception();
		}
    }

    @SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glRtnSignerNo(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes                         = new GridData();
    	HashMap  message                       = null;
    	SepoaOut value                         = null;
    	Object[] obj                           = new Object[1];
    	String   gdResMessage                  = null;
    	boolean  isStatus                      = false;
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridDataInfo = new HashMap<String, String>();
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    id           = info.getSession("ID"); 
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    rtnSignerNo  = gdReq.getParam("RTN_SIGNER_NO");
    	String                    paySendNo    = gdReq.getParam("PAY_SEND_NO");
    	String                    ccltRsnDscd  = gdReq.getParam("CCLT_RSN_DSCD");
    	String                    ccltRsnCntn  = gdReq.getParam("CCLT_RSN_CNTN");
    	
    	try {
    		message  = this.getMessage(info);
    		
        	
        	gridDataInfo.put("ADD_USER_ID"  , id);
        	gridDataInfo.put("HOUSE_CODE"   ,  houseCode);
        	gridDataInfo.put("RTN_SIGNER_NO", rtnSignerNo);
        	gridDataInfo.put("PAY_SEND_NO"  , paySendNo);
        	
        	gridDataInfo.put("CCLT_RSN_DSCD", ccltRsnDscd);
        	gridDataInfo.put("CCLT_RSN_CNTN", ccltRsnCntn);
        	
        	gridData.add(gridDataInfo);
        	
        	resultInfo.put("gridData", gridData);
        	
        	obj[0] = resultInfo;
        	
    		//obj      = this.updateSpy1glRtnSignerNoObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1glRtnSignerNo", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    
    private String setTcpBCB01000T(SepoaInfo info, String tcpName, String payType, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN, String statusCd) throws Exception{ //TOBE 2017-07-01 추가 상태코드
    	String rtn = null;
    	
    	if("tcpBCB01000T02".equals(tcpName)){ //BS전문 payType : Y-정상, N-취소		
			rtn = this.tcpBCB01000T02(info, tcpName, payType, spy1List, glInfo, HoisuYN, statusCd); //TOBE 2017-07-01 추가 상태코드
		}
		else if("tcpBCB01000T03".equals(tcpName)){	//계좌이체 payType : A-계좌유효성, Y-계좌이체, N-계좌이체취소
			rtn = this.tcpBCB01000T03(info, tcpName, payType, spy1List, glInfo);
		}
		else{
			throw new Exception();
		}
    	
    	return rtn;
    }
    
    private class BsInfo{
    	private String ikgb; // 일계조립구분
    	private String ttgb; // 집계구분
    	private String igjm; // 일계점코드
    	//TOBE 2017-07-01 삭제 일계은행코드(그룹내기관코드) private String igbk; // 일계구룹내기관코드
    	private String acgb; // 계정구분
    	private String hpgb; // 합동구분 (공백)
    	private String fnno; // 펀드번호 (공백)
    	private String bsis; // B/S=1,I/S=2 구분코드
    	private String gwcd; // 계정코드
    	private String rfcd; // 계정과목구분코드
    	private String ijgb; // 입지구분
    	private String jpct; // 전표건수
    	private String shft; // 현/대체구분
    	private String tsam; // 대체집행액
    	
		private String getIkgb() {
			return ikgb;
		}
		private void setIkgb(String ikgb) {
			this.ikgb = ikgb;
		}
		private String getTtgb() {
			return ttgb;
		}
		private void setTtgb(String ttgb) {
			this.ttgb = ttgb;
		}
		private String getIgjm() {
			return igjm;
		}
		private void setIgjm(String igjm) {
			this.igjm = igjm;
		}
		//TOBE 2017-07-01 삭제 일계은행코드(그룹내기관코드) 
		//private String getIgbk() {
		//	return igbk;
		//}
		//private void setIgbk(String igbk) {
		//	this.igbk = igbk;
		//}
		private String getAcgb() {
			return acgb;
		}
		private void setAcgb(String acgb) {
			this.acgb = acgb;
		}
		private String getHpgb() {
			return hpgb;
		}
		private void setHpgb(String hpgb) {
			this.hpgb = hpgb;
		}
		private String getFnno() {
			return fnno;
		}
		private void setFnno(String fnno) {
			this.fnno = fnno;
		}
		private String getBsis() {
			return bsis;
		}
		private void setBsis(String bsis) {
			this.bsis = bsis;
		}
		private String getGwcd() {
			return gwcd;
		}
		private void setGwcd(String gwcd) {
			this.gwcd = gwcd;
		}
		private String getRfcd() {
			return rfcd;
		}
		private void setRfcd(String rfcd) {
			this.rfcd = rfcd;
		}
		private String getIjgb() {
			return ijgb;
		}
		private void setIjgb(String ijgb) {
			this.ijgb = ijgb;
		}
		private String getJpct() {
			return jpct;
		}
		private void setJpct(String jpct) {
			this.jpct = jpct;
		}
		private String getShft() {
			return shft;
		}
		private void setShft(String shft) {
			this.shft = shft;
		}
		private String getTsam() {
			return tsam;
		}
		private void setTsam(String tsam) {
			this.tsam = tsam;
		}
		
		public void setBsInfoData(
			String ikgb, String ttgb, String igjm, //TOBE 2017-07-01 삭제 일계은행코드(그룹내기관코드)  String igbk,
			String acgb,
			String hpgb, String fnno, String bsis, String gwcd, String rfcd,
			String ijgb, String jpct, String shft, String tsam
		){
			this.setIkgb(ikgb);
			this.setTtgb(ttgb);
			this.setIgjm(igjm);
			//TOBE 2017-07-01 삭제 일계은행코드(그룹내기관코드) this.setIgbk(igbk);
			this.setAcgb(acgb);
			this.setHpgb(hpgb);
			this.setFnno(fnno);
			this.setBsis(bsis);
			this.setGwcd(gwcd);
			this.setRfcd(rfcd);
			this.setIjgb(ijgb);
			this.setJpct(jpct);
			this.setShft(shft);
			this.setTsam(tsam);
		}
		
		public String toString(){
			String       result       = null;
			StringBuffer stringBuffer = new StringBuffer();
			
			stringBuffer.append("ikgb : >" + this.getIkgb() + "<").append("\t");
			stringBuffer.append("ttgb : >" + this.getTtgb() + "<").append("\t");
			stringBuffer.append("igjm : >" + this.getIgjm() + "<").append("\t");
			//TOBE 2017-07-01 삭제 일계은행코드(그룹내기관코드)  stringBuffer.append("igbk : >" + this.getIgbk() + "<").append("\t");
			stringBuffer.append("acgb : >" + this.getAcgb() + "<").append("\t");
			stringBuffer.append("hpgb : >" + this.getHpgb() + "<").append("\t");
			stringBuffer.append("fnno : >" + this.getFnno() + "<").append("\t");
			stringBuffer.append("bsis : >" + this.getBsis() + "<").append("\t");
			stringBuffer.append("gwcd : >" + this.getGwcd() + "<").append("\t");
			stringBuffer.append("rfcd : >" + this.getRfcd() + "<").append("\t");
			stringBuffer.append("ijgb : >" + this.getIjgb() + "<").append("\t");
			stringBuffer.append("jpct : >" + this.getJpct() + "<").append("\t");
			stringBuffer.append("shft : >" + this.getShft() + "<").append("\t");
			stringBuffer.append("tsam : >" + this.getTsam() + "<");
			
			result = stringBuffer.toString();
			
			return result;
		}
    }
    
    private String getBsListDBsListOrgGwCd(String pmkPmkCd) throws Exception{
    	String result            = null;
    	String pmkPmkCdStartChar = pmkPmkCd.substring(0, 1);
    	int    pmkPmkCdLength    = pmkPmkCd.length();
    	
    	if(
    		(pmkPmkCdLength == 6) && 
    		"6".equals(pmkPmkCdStartChar)
    	){
    		result = "18351100000";
    	}
    	else{
    		result = "18364100000";
    	}
    	
    	return result;
    }
    
    private List<Map<String, String>> getBsListDBsListOrgSort(List<Map<String, String>> result) throws Exception{
    	List<Map<String, String>> resultSort = new ArrayList<Map<String, String>>();
    	Map<String, String>       resultInfo = null;
    	String                    igjmCd     = null;
    	String                    igjmCd2    = null;
    	int                       i          = 0;
    	int                       resultSize = result.size();
    	
    	for(i = (resultSize - 1); i >= 0; i--){
    		resultInfo = result.get(i);
    		igjmCd     = resultInfo.get("IGJMCD");
    		
    		ica_igjmCd     = resultInfo.get("IGJMCD"); //TOBE 2017-07-01 책임자승인명세 RDW에 보낼 일계점
    		if(default_gam_jumcd.equals(igjmCd)){ //TOBE 2017-07-01  "020644"
    			resultSort.add(resultInfo);
    			result.remove(i);
    		}
    	}
    	
    	while(result.size() > 0){
    		resultSize = result.size();
    		resultInfo = result.get((resultSize - 1));
    		igjmCd     = resultInfo.get("IGJMCD");
    		
    		for(i = (resultSize - 1); i >= 0; i--){
        		resultInfo = result.get(i);
        		igjmCd2    = resultInfo.get("IGJMCD");
        		
        		if(igjmCd.equals(igjmCd2)){
        			resultSort.add(resultInfo);
        			result.remove(i);
        		}
        	}
    	}
    	
    	return resultSort;
    }
    
    private List<Map<String, String>> getBsListDBsListOrg(List<Map<String, String>> spy1List) throws Exception{
    	List<Map<String, String>> result              = new ArrayList<Map<String, String>>();
    	Map<String, String>       spy1ListInfo        = null;
    	Map<String, String>       resultInfo          = null;
    	String                    igjmCd              = null;
    	String                    pmkPmkCd            = null;
    	String                    resultIgjmCd        = null;
    	String                    resultGwCd          = null;
    	String                    gwCd                = null;
    	String                    resultAppAppAmDt    = null;
    	String                    appAppAmDt          = null;
    	int                       spy1ListSize        = spy1List.size();
    	int                       resultSize          = 0;
    	int                       i                   = 0;
    	int                       j                   = 0;
    	int                       appAppAmDtInt       = 0;
    	int                       resultAppAppAmDtInt = 0;
    	
    	for(i = 0; i < spy1ListSize; i++){
    		spy1ListInfo  = spy1List.get(i);
    		igjmCd        = spy1ListInfo.get("IGJMCD");
    		pmkPmkCd      = spy1ListInfo.get("PMKPMKCD");
    		appAppAmDt    = spy1ListInfo.get("APPAPPAMDT");
    		appAppAmDtInt = Integer.parseInt(appAppAmDt);
    		resultSize    = result.size();
    		gwCd          = this.getBsListDBsListOrgGwCd(pmkPmkCd); // 계정과목 코드 조회
    		
    		for(j = 0; j < resultSize; j++){
    			resultInfo   = result.get(j);
    			resultIgjmCd = resultInfo.get("IGJMCD");
    			resultGwCd   = resultInfo.get("GWCD");
    			
    			if(
    				(igjmCd.equals(resultIgjmCd)) &&
    				(gwCd.equals(resultGwCd))
    			){
    				resultAppAppAmDt    = resultInfo.get("APPAPPAMDT");
    				resultAppAppAmDtInt = Integer.parseInt(resultAppAppAmDt);
    	    		resultAppAppAmDtInt = resultAppAppAmDtInt + appAppAmDtInt;
    	    		resultAppAppAmDt    = Integer.toString(resultAppAppAmDtInt);
    	    		
    	    		resultInfo.put("APPAPPAMDT", resultAppAppAmDt);
    	    		
    	    		break;
    			}
    		}
    		
    		if(j == resultSize){
    			resultInfo = new HashMap<String, String>();
    			
    			resultInfo.put("IGJMCD",     igjmCd);
    			resultInfo.put("GWCD",       gwCd);
    			resultInfo.put("APPAPPAMDT", appAppAmDt);
    			
    			result.add(resultInfo);
    		}
    	}
    	
    	result = this.getBsListDBsListOrgSort(result); // 리스트 정렬
    			
    	return result;
    }
    
    private List<BsInfo> getBsListDBsInfoList(List<Map<String, String>> bsListOrg, String payType) throws Exception{
    	List<BsInfo>        result        = new ArrayList<BsInfo>();
    	BsInfo              bsInfo        = null;
    	Map<String, String> bsListOrgInfo = null;
    	String              igjmCd        = null;
    	String              gwCd          = null;
    	String              appAppAmDt    = null;
    	String              ijgb          = null;
    	String              ijgb2         = null;
    	int                 i             = 0;
    	int                 bsListOrgSize = bsListOrg.size();
    	
    	if("N".equals(payType)){
    		ijgb  = "22";
    		ijgb2 = "12";
    	}
    	else{
    		ijgb  = "21";
    		ijgb2 = "11";
    	}
    	
    	for(i = 0; i < bsListOrgSize; i++){
    		bsListOrgInfo = bsListOrg.get(i);
    		igjmCd        = bsListOrgInfo.get("IGJMCD");
    		gwCd          = bsListOrgInfo.get("GWCD");
    		appAppAmDt    = bsListOrgInfo.get("APPAPPAMDT");
    		
    		
    		if(default_gam_jumcd.equals(igjmCd)){ //TOBE 2017-07-01 "020644"
    			bsInfo = new BsInfo();
    			
    			//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "1", "020644", "01", "10", "", "", "1", gwCd, "", ijgb, "000", "2", appAppAmDt);
    			//TOBE 2017-07-01
    			bsInfo.setBsInfoData("I", "1", default_gam_jumcd, "10", "", "", "1", gwCd,          "", ijgb, "000000", "2", appAppAmDt);
    			
    			result.add(bsInfo);
    		}
    		else{
    			/* TOBE 2017-07-01 본지점계정처리는 계정계에서 자동 처리되므로 제거 
    			bsInfo = new BsInfo();
    			
    			//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "2", "020644", "01", "10", "", "", "1", "19911100000", "", ijgb, "000", "2", appAppAmDt);
    			//TOBE 2017-07-01
    			bsInfo.setBsInfoData("I", "2", default_gam_jumcd, "10", "", "", "1", "19911100000", "", ijgb, "000000", "2", appAppAmDt);
    			
    			result.add(bsInfo);
    			*/
    			
    			bsInfo = new BsInfo();
    			
    			//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "3", igjmCd,  "01", "10", "", "", "1", gwCd,          "", ijgb, "000", "2", appAppAmDt);
    			//TOBE 2017-07-01
    			bsInfo.setBsInfoData("I", "3", igjmCd,   "10", "", "", "1", gwCd,          "", ijgb, "000000", "2", appAppAmDt);
    			
    			result.add(bsInfo);
    			
    			
    			/* TOBE 2017-07-01 본지점계정처리는 계정계에서 자동 처리되므로 제거
    			bsInfo = new BsInfo();
    			
    			//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "3", igjmCd,  "01", "10", "", "", "1", "19911100000", "", ijgb2, "000", "2", appAppAmDt);
    			//TOBE 2017-07-01
    			bsInfo.setBsInfoData("I", "3", igjmCd,   "10", "", "", "1", "19911100000", "", ijgb2, "000000", "2", appAppAmDt);
    			
    			result.add(bsInfo);
    			*/
    		}
    	}
    	
    	return result;
    }
    
    private String getBsListString(List<BsInfo> bsInfoList) throws Exception{
    	String       result         = null;
    	StringBuffer stringBuffer   = new StringBuffer();
    	BsInfo       bsInfo         = null;
    	int          bsInfoListSize = bsInfoList.size();
    	int          i              = 0;
    	
    	for(i = 0; i < bsInfoListSize; i++){
    		bsInfo = bsInfoList.get(i);
    		
    		stringBuffer.append(String.format("%1s",   bsInfo.getIkgb())); //일계조립구분
    		stringBuffer.append(String.format("%1s",   bsInfo.getTtgb())); //동부동산집계코드
    		stringBuffer.append(String.format("%6s",   bsInfo.getIgjm())); //TOBE 2017-07-01 5->6 일계점코드
    		//TOBE 2017-07-01 삭제 stringBuffer.append(String.format("%2s",   bsInfo.getIgbk()));
    		stringBuffer.append(String.format("%2s",   bsInfo.getAcgb())); //계정구분코드
    		stringBuffer.append(String.format("%2s",   bsInfo.getHpgb())); //합동코드
    		stringBuffer.append(String.format("%13s",  bsInfo.getFnno())); //TOBE 2017-07-01 9->13 펀드번호
    		stringBuffer.append(String.format("%1s",   bsInfo.getBsis())); //BS, IS구분
    		stringBuffer.append(String.format("%11s",  bsInfo.getGwcd())); //계정과목코드
    		stringBuffer.append(String.format("%2s",   bsInfo.getRfcd())); //계정과목구분코드
    		stringBuffer.append(String.format("%2s",   bsInfo.getIjgb())); //입지구분코드 + 입지급상태코드
    		stringBuffer.append(String.format("%6s",   bsInfo.getJpct())); //TOBE 2017-07-01 3->6 전표매수
    		stringBuffer.append(String.format("%1s",   bsInfo.getShft())); //현금대체구분코드
    		stringBuffer.append(String.format("%015d", Integer.parseInt(bsInfo.getTsam()))); //집행금액
    	}
    	
    	result = stringBuffer.toString();
    	
    	return result;
    }
    
    private Map<String, String> getBsListD(List<Map<String, String>> spy1List, String payType) throws Exception{
    	Map<String, String>       result         = new HashMap<String, String>();
    	List<Map<String, String>> bsListOrg      = this.getBsListDBsListOrg(spy1List); // 상세 합계
    	List<BsInfo>              bsInfoList     = this.getBsListDBsInfoList(bsListOrg, payType); // 보낼 전문 K 생성
    	BsInfo                    bsInfo         = null;
    	String                    bsList         = this.getBsListString(bsInfoList); // 문자열로 변환
    	String                    ttal           = null;
    	String                    igap           = null;
    	String                    kgap           = null;
    	String                    ikgb           = null;
    	int                       bsInfoListSize = bsInfoList.size();
    	int                       i              = 0;
    	int                       kCount         = 0;
    	int                       iCount         = 0;
    	
    	for(i = 0; i < bsInfoListSize; i++){
    		bsInfo = bsInfoList.get(i);
    		ikgb   = bsInfo.getIkgb();
    		
    		Logger.debug.println("");
			Logger.debug.println(bsInfo.toString());
			Logger.debug.println("");
    		
    		if("K".equals(ikgb)){
    			kCount++;
    		}
    		else{
    			iCount++;
    		}
    	}
    	
    	ttal   = String.format("%05d", bsInfoListSize); //TOBE 2017-07-01 3->5  일계조립건수
    	kgap   = String.format("%03d", kCount);
    	igap   = String.format("%03d", iCount); 
    	
    	result.put("bsList", bsList);
    	result.put("ttal",   ttal);
    	result.put("kgap",   kgap);
    	result.put("igap",   igap);
    	
    	return result;
    }
    
    private Map<String, String> getBsListBk(List<Map<String, String>> spy1List, String payType) throws Exception{
    	Map<String, String>       result         = new HashMap<String, String>();
    	List<BsInfo>              bsInfoList     = new ArrayList<BsInfo>();
    	BsInfo                    bsInfo         = null;
    	String                    bsList         = null;
    	String                    ttal           = null;
    	String                    igap           = null;
    	String                    kgap           = null;
    	String                    ikgb           = null;
    	String                    appAppAm       = spy1List.get(0).get("APPAPPAM");
    	String                    ijgb           = null;
    	int                       bsInfoListSize = 0;
    	int                       i              = 0;
    	int                       kCount         = 0;
    	int                       iCount         = 0;
    	
    	if("N".equals(payType)){
    		ijgb = "22";
    	}
    	else{
    		ijgb = "21";
    	}
    	
    	/* TOBE 2017-07-01 IFRS만 사용  KGAAP 제거
    	bsInfo = new BsInfo();
		
		//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "1", "020644",  "01", "10", "", "", "1", "18321100000", "", ijgb, "000", "2", appAppAm);
    	//TOBE 2017-07-01
    	bsInfo.setBsInfoData("K", "1", default_gam_jumcd,  "10", "", "", "1", "18321100000", "", ijgb, "000000", "2", appAppAm);
		
    	bsInfoList.add(bsInfo);
		*/
    	
		bsInfo = new BsInfo();
		
		//ASIS 2017-07-01 bsInfo.setBsInfoData("I", "1", "020644",  "01", "10", "", "", "1", "18321100000", "", ijgb, "000", "2", appAppAm);
		//TOBE 2017-07-01
		bsInfo.setBsInfoData("I", "1", default_gam_jumcd,  "10", "", "", "1", "18321100000", "", ijgb, "000000", "2", appAppAm);
		
		bsInfoList.add(bsInfo);
		
		bsInfoListSize = bsInfoList.size();
		bsList         = this.getBsListString(bsInfoList);
    	
    	for(i = 0; i < bsInfoListSize; i++){
    		bsInfo = bsInfoList.get(i);
    		ikgb   = bsInfo.getIkgb();
    		
    		Logger.debug.println("");
			Logger.debug.println(bsInfo.toString());
			Logger.debug.println("");
    		
    		if("K".equals(ikgb)){
    			kCount++;
    		}
    		else{
    			iCount++;
    		}
    	}
    	
    	ttal   = String.format("%05d", bsInfoListSize); //TOBE 2017-07-01 3->5
    	kgap   = String.format("%03d", kCount);
    	igap   = String.format("%03d", iCount); 
    	
    	result.put("bsList", bsList);
    	result.put("ttal",   ttal);
    	result.put("kgap",   kgap);
    	result.put("igap",   igap);
    	
    	return result;
    }
    
    private Map<String, String> getBsListBi(List<Map<String, String>> spy1List, String payType) throws Exception{
    	Map<String, String>       result         = new HashMap<String, String>();
    	List<BsInfo>              bsInfoList     = new ArrayList<BsInfo>();
    	BsInfo                    bsInfo         = null;
    	String                    bsList         = null;
    	String                    ttal           = null;
    	String                    igap           = null;
    	String                    kgap           = null;
    	String                    ikgb           = null;
    	String                    ijgb           = null;
    	String                    ijgb2          = null;
    	String                    appAppAm       = spy1List.get(0).get("APPAPPAM");
    	String                    dealDebt       = spy1List.get(0).get("DEAL_DEBT");
    	int                       bsInfoListSize = 0;
    	int                       i              = 0;
    	int                       kCount         = 0;
    	int                       iCount         = 0;
    	
    	if("N".equals(payType)){
    		ijgb  = "22";
    		ijgb2 = "12";
    	}
    	else{
    		ijgb  = "21";
    		ijgb2 = "11";
    	}
    	
    	/* TOBE 2017-07-01 IFRS만 사용 KGAAP 제거
    	bsInfo = new BsInfo();
		
		//ASIS 2017-07-01 bsInfo.setBsInfoData("K", "1", "020644",  "01", "10", "", "", "1", "18341100000", "", ijgb, "000", "2", appAppAm);
		//TOBE 2017-07-01 
    	bsInfo.setBsInfoData("K", "1", default_gam_jumcd,  "10", "", "", "1", "18341100000", "", ijgb, "000000", "2", appAppAm);
    	
		bsInfoList.add(bsInfo);
		*/
    	
    	
		bsInfo = new BsInfo();
		
		//ASIS 2017-07-01 bsInfo.setBsInfoData("I", "1", "020644",  "01", "10", "", "", "1", "18341100000", "", ijgb, "000", "2", appAppAm);
		//TOBE 2017-07-01
		bsInfo.setBsInfoData("I", "1", default_gam_jumcd,  "10", "", "", "1", "18341100000", "", ijgb, "000000", "2", appAppAm);
		
		bsInfoList.add(bsInfo);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
//      [R101905315389] [2020-02-24] [솔루션개발] (변원상)IFRS 리스자산 회계시스템	
//		복구충당(유) 발생하는 경우         
//      1. BS처리 계정처리중 복구충당부채관련은 재산관리배치에서 처리하게 변경
//      2. 웹서비스 입지대사중 복구충당부채관련 처리 제외
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//		bsInfo = new BsInfo();
//		
//		//ASIS 2017-07-01 bsInfo.setBsInfoData("I", "1", "020644",  "01", "10", "", "", "1", "18341100000", "", ijgb, "000", "2", dealDebt);
//		//TOBE 2017-07-01
//		bsInfo.setBsInfoData("I", "1", default_gam_jumcd,   "10", "", "", "1", "18341100000", "", ijgb, "000000", "2", dealDebt);
//		
//		bsInfoList.add(bsInfo);
//		
//		bsInfo = new BsInfo();
//		
//		//ASIS 2017-07-01 bsInfo.setBsInfoData("I", "1", "020644",  "01", "10", "", "", "1", "29097100000", "", ijgb2, "000", "2", dealDebt);
//		//TOBE 2017-07-01
//		bsInfo.setBsInfoData("I", "1", default_gam_jumcd,  "10", "", "", "1", "29097100000", "", ijgb2, "000000", "2", dealDebt);
//		
//		bsInfoList.add(bsInfo);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		bsInfoListSize = bsInfoList.size();
		bsList         = this.getBsListString(bsInfoList);
    	
    	for(i = 0; i < bsInfoListSize; i++){
    		bsInfo = bsInfoList.get(i);
    		ikgb   = bsInfo.getIkgb();
    		
    		Logger.debug.println("");
			Logger.debug.println(bsInfo.toString());
			Logger.debug.println("");
    		
    		if("K".equals(ikgb)){
    			kCount++;
    		}
    		else{
    			iCount++;
    		}
    	}
    	
    	ttal   = String.format("%05d", bsInfoListSize); //TOBE 2017-07-01 3->5 일계조립건수
    	kgap   = String.format("%03d", kCount);
    	igap   = String.format("%03d", iCount); 
    	
    	result.put("bsList", bsList);
    	result.put("ttal",   ttal);
    	result.put("kgap",   kgap);
    	result.put("igap",   igap);
    	
    	return result;
    }
    
	//BS전송 정상전문 Y, 취소 전문 N
	private String tcpBCB01000T02(SepoaInfo info, String name, String payType, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN, String statusCd) throws Exception{ //TOBE 2017-07-01 추가 상태코드
		String              result       = null;
		String              strTRCD      = null;
		String              BKCD         = null;
		String              BRCD         = null; 
		String              TRMBNO       = null;
		String              USERTERMNO   = null;
		String              TERMNO9      = null;
		String              strMNNY      = "0000000"; //TOBE 2017-07-01 책임자승인코드(7)   , ASIS 책임자사유(3)  [0030 + ASIS CODE]
		String              bsList       = null;
		String              TTAL         = null;            
		String              KGAP         = null;        
		String              IGAP         = null; 
		String              MGRBIOAUTYN  = "N";	//(1)  책임자생체인식여부   "N"    
		String              paySendBio   = glInfo.get("PAY_SEND_BIO");
		String              txtMnno      = glInfo.get("TXT_MNNO");
		String              endTxtMnno   = glInfo.get("TXT_MNNO");
		String              workKind     = glInfo.get("WORK_KIND");
		String              bdsBdsCd     = glInfo.get("BDSBDSCD");
		String              beforeSignNo = glInfo.get("BEFORE_SIGN_NO");
		String              trnLogKeyVal = glInfo.get("TRN_LOG_KEY_VAL"); //TOBE 2017-07-01 로그키값
		String              astAstGb     = null;
		String              addUserId    = null;
		String              mgrapvDscd   = null;
		String              ikCd         = null;
		String              nml_can_dscd = null;
		Map<String, String> spy1Map      = null;
		Map<String, String> bsListMap    = null;
		int                 totalListCnt = 0;
		String              gate_tot_size    = null;
		String              enabler_tot_size = null;
		String              data_tot_size    = null;
		String              txtMnno1      = glInfo.get("TXT_MNNO");
		String              txtMnno2      = glInfo.get("TXT_MNNO");
		String              ccltRsnDscd      = null;
		String              ccltRsnCntn      = null;
		
		try{
			// 거래코드 설정 변경 start!
			if("N".equals(payType)){ //실패전문
				//strTRCD  = glInfo.get("BSTRCD2"); // 3.  C4    거래코드    "1030"
				strTRCD = "0102";
				nml_can_dscd = "2";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				ccltRsnDscd  = glInfo.get("CCLT_RSN_DSCD");
				ccltRsnCntn  = glInfo.get("CCLT_RSN_CNTN");
			}
			else{
				//strTRCD  = glInfo.get("BSTRCD1"); // 3.  C4    거래코드    "1030"                      
				strTRCD = "0102";
				nml_can_dscd = "1";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				ccltRsnDscd  = "";
				ccltRsnCntn  = "";
			}
			// 거래코드 설정 변경 end!

			BCB01000T02 n02 = new BCB01000T02(); //전문내용
			
			//TOBE 2017-07-01 제거 String endTag = "</IM>";
			//TOBE 2017-07-01 제거 int endTagLen = endTag.length();
			
			if(paySendBio.length() > 0){
				n02.SEND.bioHdr.iBioLen = 0;  //TOBE 2017-07-01 지문헤더 불필요 (669 => 0 변경)
				MGRBIOAUTYN = "Y";
				strMNNY     = "0030001"; //TOBE 2017-07-01 책임자승인코드(7)   , ASIS 책임자사유(3)  [0030 + ASIS CODE]
				//TOBE 2017-07-01 제거 endTagLen   = endTagLen +27;
			}
			else{
				n02.SEND.bioHdr.iBioLen = 0;
				MGRBIOAUTYN = "N";
				strMNNY     = "0000000"; //TOBE 2017-07-01 책임자승인코드(7)   , ASIS 책임자사유(3)  [0030 + ASIS CODE]
			}

			if(
				("1".equals(workKind)) || // 동산 신규
				("2".equals(workKind)) // 동산 원가
			){
				ikCd      = "I"; //TOBE 2107-07-01 일계조립구분은 'I' 만 사용   , D -> I 
				bsListMap = this.getBsListD(spy1List, payType); // 동산처리
			}
			else{
				ikCd = "I";      //TOBE 2107-07-01 일계조립구분은 'I' 만 사용   , B -> I
				
				if("3".equals(workKind)){
					bsListMap = this.getBsListBk(spy1List, payType); // 건물처리
				}
				else if("4".equals(workKind)){
					astAstGb = bdsBdsCd.substring(0, 2);
					
					if("30".equals(astAstGb) == false){
		    			result = "ERR:(BCB01000T02)임차점포시설물만 거래가능합니다.";
						
						return result;
		    		}
					
					bsListMap = this.getBsListBi(spy1List, payType); // 복구충당
				}
			}
			if(bsListMap == null){ result = "ERR:(BCB01000T02)bsListMap NULL"; return result; }
			bsList       = bsListMap.get("bsList");
			TTAL         = bsListMap.get("ttal");
			totalListCnt = Integer.parseInt(TTAL);
			
			if(totalListCnt > 1000){ //TOBE 2017-07-01 30 -> 1000 
				result = "ERR:(BCB01000T02)전문 생성 한계에 도달하여 tcp 수행을 진행할 수 없습니다.";
				
				return result;
			}
			
			KGAP         = bsListMap.get("kgap");
			IGAP         = bsListMap.get("igap");
			spy1Map      = spy1List.get(0); 
			
			
			
			/* ASIS 2017-07-01 
			if(spy1Map.get("USER_TRM_NO").length() >= 9){
				BKCD       = spy1Map.get("USER_TRM_NO").substring(0,  5);
				BRCD       = spy1Map.get("USER_TRM_NO").substring(5,  6); 
				TRMBNO     = spy1Map.get("USER_TRM_NO").substring(6,  9);
				USERTERMNO = spy1Map.get("USER_TRM_NO").substring(9,  10);
				TERMNO9    = spy1Map.get("USER_TRM_NO").substring(0,  9);
				addUserId  = spy1Map.get("USER_TRM_NO").substring(10, 18);
			}
			
			String gate_tot_size    = String.format("%05d", n01.SEND.comHdr.iTLen + n01.SEND.bizHdr.iTLen   + n01.SEND.bioHdr.iBioLen + n01.SEND.iOrgLen + (n01.LISTSEND.iTLen * totalListCnt) + endTagLen); //00687
			String enabler_tot_size = String.format("%05d", n01.SEND.bizHdr.iTLen + n01.SEND.bioHdr.iBioLen + n01.SEND.iOrgLen + (n01.LISTSEND.iTLen * totalListCnt) + endTagLen);						  //00653    	
			String data_tot_size    = null;
			
			if(paySendBio.length() > 0){
				data_tot_size    = String.format("%05d", n01.SEND.iOrgLen+(n01.LISTSEND.iTLen*totalListCnt)+endTagLen-20 -27)+"000000";		    					  //00433000000
			}
			else{
				data_tot_size    = String.format("%05d", n01.SEND.iOrgLen+(n01.LISTSEND.iTLen*totalListCnt)+endTagLen-20 )+"000000";		    					  //00433000000
			}
			
			

			n01.SEND.comHdr.TOT_SIZE      = gate_tot_size;
			
			boolean isReal = Boolean.parseBoolean(CommonUtil.getConfig("sepoa.isReal"));
			
			if(isReal){
				n01.SEND.comHdr.PROD_GB = "P";          // P:운영데이타 , T:테스트데이타.				
			}
			else{
				n01.SEND.comHdr.PROD_GB = "T";          // P:운영데이타 , T:테스트데이타.
			}
			
	        n01.SEND.bizHdr.HEAD_STA_TAG  = "<IH>";              //(4)  헤더선언부헤더                                                                                
	        n01.SEND.bizHdr.INLEN         = enabler_tot_size;    //(5)  N전문전체길이-->헤더+전문길이                                                                      
	        n01.SEND.bizHdr.BK_CD         = BKCD;                //(5)  C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "020644"                                               
	        n01.SEND.bizHdr.BR_CD         = BRCD;                //(1)  WooriDevice.dll에서단말번호가져옴-> "C"                                                            
	        n01.SEND.bizHdr.TRM_BNO       = TRMBNO;              //(3)  PDA의단말번호는'20481'->  "004"                                                                   
	        n01.SEND.bizHdr.USER_TRM_NO   = USERTERMNO;          //(1)  사용자단말번호 "5"                                                                                
	        n01.SEND.bizHdr.UID           = addUserId;           //(8)  PDA조작자번호 행번                                                                 
	        n01.SEND.bizHdr.MGR_BIOAUT_YN = MGRBIOAUTYN;         //(1)  책임자생체인식여부   "N"
	        
	        if(
				("Y".equals(payType)) &&
				(Integer.parseInt(spy1Map.get("APPAPPAM")) <= 50000000 )
			){
	        	mgrapvDscd = "1";
			}
	        else{
	        	mgrapvDscd = "2";
	        }
	        
	        if(HoisuYN.equals("Y"))   // Y : 회수 , N : 회수아님
	        {
	        	mgrapvDscd = "1";
	        }
	        
	        n01.SEND.bizHdr.MGRAPV_DSCD   = mgrapvDscd;
	        n01.SEND.bizHdr.HEAD_END_TAG  = "</IH>";             // (5) *헤더부종료태그   

	        if(paySendBio.length()>0){
	        	n01.SEND.bioHdr.IBIO   = paySendBio;                        // 1.  C669    지문정보
	        }
		        
			n01.SEND.IMHD   = "<IM>";                        // 1.  C4    헤더                                    
			n01.SEND.IMFL   = data_tot_size;				 // C11  FILLER    IM제외 전문길이(5) + '000000'
			n01.SEND.TRDT   = SepoaDate.getShortDateString();// 2.  C8    거래일자  "20141216"                                     
			n01.SEND.TRCD   = strTRCD;                       // 3.  C4    거래코드    "1030"                                    
	        n01.SEND.DANO   = "00023";                       // 4.  N5    일자별번호                                      
			n01.SEND.UNNO   = "002";                         // 5.  N3    일자별하위번호                                    
			n01.SEND.JBCD   = "87";                          // 6.  C2    업무코드     20700                                  
			n01.SEND.TMJM   = spy1Map.get("JUMJUJMCD");      // 7.  C5    취급점(=단말소속점)코드 "020644"                              
			n01.SEND.TMBK   = "01";                          // 8.  C2    취금점내기관(=단말소속은행)코드                          
			n01.SEND.TRMD   = "0";                           // 9.  C1    거래모드                                       
			n01.SEND.TMNO   = TERMNO9;                       // 10. C9    단말번호         "20644C004"                              
			n01.SEND.OPNO   = addUserId;    // 11. C8    조작자행번
			
			
			if ("Y".equals(payType)){
				if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 50000000 &&  Integer.parseInt(spy1Map.get("APPAPPAM")) < 100000000){ //5천 이상 1억미만
					endTxtMnno = txtMnno;
					txtMnno    = "";
				}else if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 100000000 ){
					txtMnno = beforeSignNo;
				}else {
					endTxtMnno = "";
					txtMnno    = "";	
				}
			}else {
				endTxtMnno = txtMnno;
				txtMnno    = "";
			}
			*/
			/*
			if(
				("Y".equals(payType)) &&
				(Integer.parseInt(spy1Map.get("APPAPPAM")) <= 50000000 )
			){
				txtMnno    = "";
				endTxtMnno = "";
			}
			else if(
					("Y".equals(payType)) &&
					(Integer.parseInt(spy1Map.get("APPAPPAM")) > 100000000 )
			){
				txtMnno = beforeSignNo;
			}
			*/
			
			/* ASIS 2017-07-01
			n01.SEND.MNNO   = txtMnno;                       // 12. C8    책임자자행번                                     
			n01.SEND.MNNY   = strMNNY;                       // 13. C3    책임자사유                                      
			n01.SEND.IDNO   = "";                            // 14. C8    바이오 KEY                                    
			n01.SEND.NSLP   = "Y";                           // 15. C1  무전표여부                                        
			n01.SEND.NPRT   = "Y";                           // 16. C1    무인자여부                                      
			n01.SEND.XCHP   = "N";                           // 17. C1    교환지급여부                                     
			n01.SEND.MDKD   = "";                            // 18. C4    원거래매체종류½?드                                   
			n01.SEND.ACTN   = "";                            // 19. C20  계좌번호                                        
			n01.SEND.AMT1   = String.format("%015d",  Integer.parseInt(spy1Map.get("APPAPPAM")));             // 20. N15  거래금액1       "000000002178000"                                
			n01.SEND.AMT2   = "000000000000000";             // 21. N15  거래금액2                                       
			n01.SEND.AMT3   = "000000000000000";             // 22. N15  거래금액3     "000000000000000"
			n01.SEND.IKCD   = ikCd;                         // 23. C1    일계조립구분코드	"D"	                             
			n01.SEND.TTAL   = TTAL;                         // 24. C3    총조립건수                              "005"        
			n01.SEND.KGAP   = KGAP;                         // 25. C3  K-GAAP 조립건수                           "005"       
			n01.SEND.IGAP   = IGAP;                         // 26. C3  I-GAAP 조립건수                           "000"
			
			if(paySendBio.length() > 0){
				bsList += endTxtMnno + "          100030";
				
				if("Y".equals(payType)){
					if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 50000000 &&  Integer.parseInt(spy1Map.get("APPAPPAM")) < 100000000){ //5천 이상 1억미만
						bsList += "014";
					}
					else if(Integer.parseInt(spy1Map.get("APPAPPAM")) >= 100000000 ){
						bsList += "520";
					}
				}
				else{
					bsList += "001";
				}
			}
			
			bsList += "</IM>";
			
			n01.SEND.TEMP   = bsList;   				
			*/
			


			
			
			
			
	        /* TOBE 2017-07-01 */	   	
		   	if(spy1Map.get("USER_TRM_NO").length() >= 12){
				BKCD       = spy1Map.get("USER_TRM_NO").substring(0,  6);      //점코드
				USERTERMNO = spy1Map.get("USER_TRM_NO").substring(0, 12);      //사용자단말번호
				addUserId  = spy1Map.get("USER_TRM_NO").substring(12);         //조작자번호
			}
	

			gate_tot_size    = String.format("%08d", n02.SEND.sysHdr.iTLen + n02.SEND.trnHdr.iTLen + n02.SEND.bioHdr.iBioLen 
					                               + n02.SEND.iOrgLen + (n02.LISTSEND.iTLen * totalListCnt) + 2 -8); // 전문전체길이+(종료'@@') -8
			data_tot_size    = String.format("%07d", n02.SEND.iOrgLen + (n02.LISTSEND.iTLen * totalListCnt) -10); // 데이터부 데이터길이 -10		
				
		   	n02.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
	    	
			n02.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
			n02.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
			n02.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
	        n02.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
//			n02.SEND.trnHdr.OPR_NO        = "불고기";            //비정상테스트
	        
			if ("Y".equals(payType)){
				if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 50000000 &&  Integer.parseInt(spy1Map.get("APPAPPAM")) < 200000000){ //TOBE 2017-07-01 1억미만 -> 2억미만 변경 
					//1차 단말 조작자
					txtMnno2 = "";
				}else if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 200000000 ){ //TOBE 2017-07-01 1억 -> 2억 변경
					txtMnno1 = beforeSignNo; //1차
					//2차 단말 조작자
				}else {
					txtMnno1    = "";
					txtMnno2    = "";	
				}
			}else {
				//1차 단말 조작자
				txtMnno2    = "";
			}
			
			
			
	        if(
				("Y".equals(payType)) &&
				(Integer.parseInt(spy1Map.get("APPAPPAM")) < 50000000 ) // TOBE 2017-07-01 작다로변경 (ASIS <= 50000000)
			){
	        	mgrapvDscd = "N"; //TOBE 2017-07-01 승인유형구분  1 -> N : 승인없음
			}
	        else{
	        	mgrapvDscd = "B"; //TOBE 2017-07-01 승인유형구분  2 -> B : 사전승인
	        }
	        
	        if(HoisuYN.equals("Y"))   // Y : 회수 , N : 회수아님
	        {
	        	mgrapvDscd = "N"; //TOBE 2017-07-01 승인유형구분  1 -> N : 승인없음
	        }
	        n02.SEND.trnHdr.RLPE_APV_DSCD   = mgrapvDscd;   // 책임자승인구분코드
	        
	        if(paySendBio.length()>0){
	        	n02.SEND.bioHdr.IBIO   = paySendBio;                        // 1.  C669    지문정보
	        }
	        
	        
	        
			n02.SEND.DAT_KDCD            = "DTI";                                         //데이타헤더부 : (문자3)  데이터종류코드	       
			n02.SEND.DAT_LEN             = data_tot_size;                                 //데이타헤더부 : (숫자7)  데이터길이
			
			//TOBE 2017-08-24 오픈시 원복해야함 (계정계 테스트 서버가 특정일자밖에 인식을 못해서 밑에 하드코딩) n03.SEND.BGT_TRN_DT          = SepoaDate.getShortDateString();                // 1 .  S8    예산거래일자                                        
			n02.SEND.BGT_TRN_DT          = SepoaDate.getShortDateString();                // 1 .  S8    예산거래일자
//			n02.SEND.BGT_TRN_DT          = "20180413";
			
			n02.SEND.MERE_TRN_DSCD       = strTRCD;                                       // 2 .  S4    동부동산거래구분코드                                    
			n02.SEND.MERE_TLM_DIS_SRNO   = "00023";                                       // 3 .  N5    동부동산전문구분일련번호                                  
			n02.SEND.TRN_BYDY_SRNO       = "00002";                                       // 4 .  N5    거래일별일련번호                                      
			n02.SEND.NML_CAN_DSCD        = nml_can_dscd;                                  // 5 .  S1    정상취소구분코드 (1:정상,2:취소)                                     
			n02.SEND.ORTR_LOG_KEY_VAL    = trnLogKeyVal;                                  // 6 .  S56   원거래로그키값                                       
			n02.SEND.BIZ_DSCD            = "87";                                          // 7 .  S2    업무구분코드                                        
			
			//2017-08-31 운영자가 단말점코드로 변경 요청함 n02.SEND.TRM_ITLL_BRCD       = spy1Map.get("JUMJUJMCD");                      // 8 .  S6    단말설치점코드
			n02.SEND.TRM_ITLL_BRCD       = BKCD;                                          // 8 .  S6    단말설치점코드
			
			n02.SEND.MOD_DSCD            = "0";                                           // 9.   S1    모드구분코드                                        
			n02.SEND.TRM_NO              = spy1Map.get("USER_TRM_NO").substring(0, 12);   // 10.  S12   단말번호                                          
			n02.SEND.OPR_ENO             = spy1Map.get("USER_TRM_NO").substring(12);      // 11.  S8    조작자직원번호  
			n02.SEND.RLPE_ENO            = txtMnno1;                                      // 12.  S8    책임자직원번호  (1차책임자)                                       
			n02.SEND.RLPE_ENO2           = txtMnno2;                                      // 13.  S8    책임자직원번호2 (2차책임자)
			n02.SEND.RLPE_APV_CD         = strMNNY;                                       // 14.  S7    책임자승인코드                                       
			n02.SEND.CHRG_ENO            = "";                                            // 15.  S8    담당직원번호                                        
			n02.SEND.NSLIP_YN            = "Y";                                           // 16.  S1    무전표여부                                         
			n02.SEND.NPRT_YN             = "Y";                                           // 17.  S1    무인자여부                                         
			n02.SEND.XCHPY_YN            = "N";                                           // 18.  S1    교환지급여부                                        
			n02.SEND.MD_GRCD             = "";                                            // 19.  S4    매체그룹코드                                        
			n02.SEND.BKW_ACNO            = "";                                            // 20.  S20   전행계좌번호                                        
			n02.SEND.TRN_AM_1            = String.format("%015d"
			                             , Integer.parseInt(spy1Map.get("APPAPPAM")));    // 21.  D15   거래금액_1                                        
			n02.SEND.TRN_AM_2            = "000000000000000";                             // 22.  D15   거래금액_2                                        
			n02.SEND.TRN_AM_3            = "000000000000000";                             // 23.  D15   거래금액_3                                        
			n02.SEND.DACC_CST_DSCD       = ikCd;                                          // 24.  S1    일계조립구분코드                                      
			n02.SEND.KGP_DACC_CST_CNT    = KGAP;                                          // 25.  N3    KGAAP일계조립건수                                   
			n02.SEND.GAAP_DACC_CST_CNT   = IGAP;                                          // 26.  N3    GAAP일계조립건수
			
			n02.SEND.CMN_CAN_RSN_DSCD    = ccltRsnDscd;                                   // 27.  S2      취소사유구분코드
			n02.SEND.TRN_CAN_RSN_TXT     = ccltRsnCntn;                                   // 28.  S100   취소사유내용   
			
			n02.SEND.DACC_CST_CNT        = TTAL;                                          // 29.  N5    일계조립건수  	
			n02.SEND.TEMP                = bsList;                                        //가변영역 (전문보낼때 파싱없이 한줄로 나간다)
			
			
			//TOBE 2017-07-01 추가 재산관리 입지대사 
			if(("24".equals(statusCd)) || //스텝상 책임자전송완료 이후 (정상)
			   ("64".equals(statusCd)) || //스텝상 책임자전송취소 이후 (취소)
			   ("27".equals(statusCd))    //스텝상 입지전송완료   이후 (회수)
			  ) {
				
				//재산관리 입지대사용 파싱
				Logger.sys.println("========== bsList ============");
				Logger.sys.println("bsList : " + bsList);
				Logger.sys.println("==============================");

				List<Map<String, String>> ListbsData     = new ArrayList<Map<String, String>>();
				Map<String, String>       bsData;                               
			
				int j = 0;
				int pos = 0;

				for( j = 0; j < totalListCnt; j++) {				

					Logger.sys.println("totalListCnt : " + totalListCnt);
			    
					bsData = new HashMap<String, String>();       
					
					bsData.put("DACC_CST_DSCD",  bsList.substring(pos, pos + 1));  pos +=  1;             
					bsData.put("MERE_SUMR_CD",   bsList.substring(pos, pos + 1));  pos +=  1;         
					bsData.put("DACC_BRCD",      bsList.substring(pos, pos + 6));  pos +=  6;         
					bsData.put("ACC_DSCD",       bsList.substring(pos, pos + 2));  pos +=  2;         
					bsData.put("UNI_CD",         bsList.substring(pos, pos + 2));  pos +=  2;         
					bsData.put("FND_PDCD",       bsList.substring(pos, pos +13));  pos += 13;         
					bsData.put("BSIS_DSCD",      bsList.substring(pos, pos + 1));  pos +=  1;         
					bsData.put("ACCD",           bsList.substring(pos, pos +11));  pos += 11;         
					bsData.put("ACI_DSCD",       bsList.substring(pos, pos + 2));  pos +=  2;         
					bsData.put("RAP_DSCD",       bsList.substring(pos, pos + 1));  pos +=  1;         
					bsData.put("RAP_STCD",       bsList.substring(pos, pos + 1));  pos +=  1;         
					bsData.put("SLIP_SCNT",      bsList.substring(pos, pos + 6));  pos +=  6;         
					bsData.put("CSHTF_DSCD",     bsList.substring(pos, pos + 1));  pos +=  1;         
					bsData.put("EXU_AM",         bsList.substring(pos, pos +15));  pos += 15;
					ListbsData.add(bsData);
		    	
			        Logger.sys.println("DACC_CST_DSCD[j] : " + "["+ j +"]" + bsData.get("DACC_CST_DSCD"));
					Logger.sys.println("MERE_SUMR_CD [j] : " + "["+ j +"]" + bsData.get("MERE_SUMR_CD"));
					Logger.sys.println("DACC_BRCD    [j] : " + "["+ j +"]" + bsData.get("DACC_BRCD"));
					Logger.sys.println("ACC_DSCD     [j] : " + "["+ j +"]" + bsData.get("ACC_DSCD"));
					Logger.sys.println("UNI_CD       [j] : " + "["+ j +"]" + bsData.get("UNI_CD"));
					Logger.sys.println("FND_PDCD     [j] : " + "["+ j +"]" + bsData.get("FND_PDCD"));
					Logger.sys.println("BSIS_DSCD    [j] : " + "["+ j +"]" + bsData.get("BSIS_DSCD"));
					Logger.sys.println("ACCD         [j] : " + "["+ j +"]" + bsData.get("ACCD"));
					Logger.sys.println("ACI_DSCD     [j] : " + "["+ j +"]" + bsData.get("ACI_DSCD"));
					Logger.sys.println("RAP_DSCD     [j] : " + "["+ j +"]" + bsData.get("RAP_DSCD"));
					Logger.sys.println("RAP_STCD     [j] : " + "["+ j +"]" + bsData.get("RAP_STCD"));
					Logger.sys.println("SLIP_SCNT    [j] : " + "["+ j +"]" + bsData.get("SLIP_SCNT"));
					Logger.sys.println("CSHTF_DSCD   [j] : " + "["+ j +"]" + bsData.get("CSHTF_DSCD"));
					Logger.sys.println("EXU_AM       [j] : " + "["+ j +"]" + bsData.get("EXU_AM"));
				}
			
				
				result = this.getEps0033(info, glInfo, ListbsData, n02, payType);
				if("200".equals(result)) {
					result = "SUC:" + result;
				} else {
					result = "ERR:재산관리 입지대사 웹서비스중 오류 발생 :"+ result;
				}
				return result;  // 재산관리 입지대사인경우 리턴 ( 아래 전문 재실행 방지 )
			}
			/*------------------------------------------------------------------------------*/
			
			
			Configuration conf = new Configuration();
			String send_ip     = conf.get("sepoa.interface.tcpip.ip");
			int send_port      = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
			ONCNF.LOGDIR       = conf.get("sepoa.logger.dir");
			
			n02.pay_send_no = glInfo.get("PAY_SEND_NO");
			int iret = n02.sendMessage("BCB01000T02",send_ip,send_port);			//개발
			
			if(iret == ONCNF.D_OK) {
				n02.RECV.sysHdr.log(ONCNF.LOGNAME, "");		
				n02.RECV.trnHdr.log(ONCNF.LOGNAME, "");		
				n02.RECV.log(ONCNF.LOGNAME, "");
//				result = "SUC:"+n01.RECV.REG_YN;	
				//ASIS 2017-07-01 result = "SUC:"+n01.RECV.TEL_NO; //텔러번호 4	
				result = "SUC:" + n02.RECV.TLR_NO + n02.RECV.SLIP_NO + n02.RECV.TRN_LOG_KEY_VAL; //TOBE 2017-07-01 텔러번호4 + 전표번호16 + 로크키값56
				Logger.sys.println("n02.result : " + result);
			}
			else if(iret == ONCNF.D_ECODE) { /// 전문내용 정상 오류일경우 ...
				n02.eRECV.sysHdr.log();
				n02.eRECV.trnHdr.log();
				n02.eRECV.log(ONCNF.LOGNAME, "");		
					
//				result = "ERR:["+n01.eRECV.bizHdr.ERRCODE+"]"+n01.eRECV.MESSAGE;
				//ASIS 2017-07-01 result = "ERR:("+n01.eRECV.bizHdr.ERRCODE+")"+n01.eRECV.MESSAGE.replace("</IM>", "").trim();
				//TOBE 2107-07-01
				result = "ERR:("+n02.eRECV.msgHdr.MSG_CD+")"+n02.eRECV.msgHdr.MAIN_MSG_TXT;
			}		
			else{
				Logger.err.println("ERR:(BCB01000T02)예외응답이 발생되었습니다.!!!.." + iret);
				
				result = "ERR:(BCB01000T02)예외응답이 발생되었습니다.(" + iret + ")";
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			result = "ERR:예외오류가 발생되었습니다.";
		}
		
		return result;
	}
	
	//계좌유효성체크, 계좌이체전송
	private String tcpBCB01000T03(SepoaInfo info, String string, String payType, List<Map<String, String>> spy1List, Map<String, String> glInfo) throws Exception{
		String              result           = null;
		String              BKCD             = null;
		String              BRCD             = null; 
		String              TRMBNO           = null;
		String              USERTERMNO       = null;
		String              TERMNO9          = null;
		String              strPayAmt        = "";
		String              strTRCD          = null;
		String              strAMT3          = "0";
		String              addUserId        = null;
		String              gate_tot_size    = null;
		String              enabler_tot_size = null;
		String              data_tot_size    = null;
		String              nml_can_dscd     = null;
		Map<String, String> spy1Map          = null;
		int                 spy1ListSize     = spy1List.size();
		int                 i                = 0;
		String              ccltRsnDscd      = null;
		String              ccltRsnCntn      = null;
		
		try{
			// 거래코드 변경 start!
			if("Y".equals(payType)){ //정상전문
				strTRCD = glInfo.get("ACCTRCD1"); // 3.  C4    거래코드    "1030"
				nml_can_dscd = "1";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				ccltRsnDscd  = "";
				ccltRsnCntn  = "";
			}
			else if("N".equals(payType)){ //실패전문
				strTRCD = glInfo.get("ACCTRCD2"); // 3.  C4    거래코드    "1030"       
				strAMT3 = glInfo.get("ACC_NUM");
				nml_can_dscd = "2";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				ccltRsnDscd  = glInfo.get("CCLT_RSN_DSCD");
				ccltRsnCntn  = glInfo.get("CCLT_RSN_CNTN");
			}
			else if("A".equals(payType)){ //계좌유효성 검사
				strTRCD = "1200";
				nml_can_dscd = "1";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				ccltRsnDscd  = "";
				ccltRsnCntn  = "";
			}
			// 거래코드 변경 end!
			
			strTRCD = "0102";
			
			
			BCB01000T03 n03 = new BCB01000T03(); //전문내용

			/* ASIS 2017-07-01
			for(i = 0; i < spy1ListSize; i++){
				spy1Map = spy1List.get(i); 
						
				if(spy1Map.get("USER_TRM_NO").length() >= 9){
					BKCD       = spy1Map.get("USER_TRM_NO").substring(0,  5);
					BRCD       = spy1Map.get("USER_TRM_NO").substring(5,  6); 
					TRMBNO     = spy1Map.get("USER_TRM_NO").substring(6,  9);
					USERTERMNO = spy1Map.get("USER_TRM_NO").substring(9,  10);
					TERMNO9    = spy1Map.get("USER_TRM_NO").substring(0,  9);
					addUserId  = spy1Map.get("USER_TRM_NO").substring(10, 18);
				}
			
				if("A".equals(payType)){
					strPayAmt = "0";
				}
				else{
					strPayAmt = spy1Map.get("PAY_AMT");
				}
					
				gate_tot_size    = String.format("%05d", n01.SEND.comHdr.iTLen+n01.SEND.bizHdr.iTLen+n01.SEND.iTLen); //00687
				enabler_tot_size = String.format("%05d", n01.SEND.bizHdr.iTLen+n01.SEND.iTLen);						  //00653    	
				data_tot_size    = String.format("%05d", n01.SEND.iTLen-20)+"000000";		    					  //00433000000
			    	
				n01.SEND.comHdr.TOT_SIZE     = gate_tot_size;
		        n01.SEND.bizHdr.HEAD_STA_TAG = "<IH>";                                               // (4) 헤더선언부헤더                                                                                
		        n01.SEND.bizHdr.INLEN        = enabler_tot_size;                                     // (5) N전문전체길이-->헤더+전문길이                                                                      
		        n01.SEND.bizHdr.BK_CD        = BKCD;                                                 // (5) C단말번호점코드(5)  +단말종류(1)  +부/점별단말SEQ(3)  ) "020644"                                               
		        n01.SEND.bizHdr.BR_CD        = BRCD;                                                 // (1) WooriDevice.dll에서단말번호가져옴-> "C"                                                            
		        n01.SEND.bizHdr.TRM_BNO      = TRMBNO;                                               // (3) PDA의단말번호는'20481'->  "004"                                                                   
		        n01.SEND.bizHdr.USER_TRM_NO  = USERTERMNO;                                           // (1) 사용자단말번호 "5"                                                                                
		        n01.SEND.bizHdr.UID          = addUserId;                                            // (8) PDA조작자번호 행번                                                              
		        n01.SEND.bizHdr.HEAD_END_TAG = "</IH>";                                              // (5) *헤더부종료태그   
				n01.SEND.IMHD                = "<IM>";                                               // 1.  C4    헤더                                    
				n01.SEND.IMFL                = data_tot_size;                                        // C11  FILLER    IM제외 전문길이(5) + '000000'
				n01.SEND.TRDT                = SepoaDate.getShortDateString();                       // 2.  C8    거래일자  "20141216"
				n01.SEND.TRCD                = strTRCD;                                              // 3.  C4    거래코드   "1030"  유효성확인 : "1200"  계좌이체""                                 
		        n01.SEND.DANO                = "00023";                                              // 4.  N5    일자별번호                                      
				n01.SEND.UNNO                = "002";                                                // 5.  N3    일자별하위번호                                    
				n01.SEND.JBCD                = "87";                                                 // 6.  C2    업무코드     20700                                  
				n01.SEND.TMJM                = spy1Map.get("JUMJUJMCD");                             // 7.  C5    취급점(=단말소속점)코드 "020644"                              
				n01.SEND.TMBK                = "01";                                                 // 8.  C2    취금점내기관(=단말소속은행)코드                          
				n01.SEND.TRMD                = "0";                                                  // 9.  C1    거래모드                                       
				n01.SEND.TMNO                = TERMNO9;                                              // 10. C9    단말번호         "20644C004"                              
				n01.SEND.OPNO                = addUserId;                                            // 11. C8    조작자행번                                
				n01.SEND.MNNO                = "";                                                   // 12. C8    책임자자행번     spy1Map.get("SIGNER_NO")                                 
				n01.SEND.MNNY                = "000";                                                // 13. C3    책임자사유                                      
				n01.SEND.IDNO                = "";                                                   // 14. C8    바이오 KEY                                    
				n01.SEND.NSLP                = "N";                                                  // 15. C1  무전표여부                                        
				n01.SEND.NPRT                = "Y";                                                  // 16. C1    무인자여부                                      
				n01.SEND.XCHP                = "N";                                                  // 17. C1    교환지급여부                                     
				n01.SEND.MDKD                = "";                                                   // 18. C4    원거래매체종류코드                                   
				n01.SEND.ACTN                = spy1Map.get("BANK_ACCT");                             // 19. C20  계좌번호                                        
				n01.SEND.AMT1                = String.format("%015d",  Integer.parseInt(strPayAmt)); // 20. N15  거래금액1       "000000002178000"                                
				n01.SEND.AMT2                = "000000000000000";                                    // 21. N15  거래금액2                                       
				n01.SEND.AMT3                = String.format("%015d",  Integer.parseInt(strAMT3));   // 22. N15  거래금액3     "000000000000000"                                    
				n01.SEND.IKCD                = payType;                                              // 23. C1    일계조립구분코드		A : 유효성확인 Y : 이체                             
				n01.SEND.TTAL                = "000";                                                // 24. C3    총조립건수                              ""        
				n01.SEND.KGAP                = "000";                                                // 25. C3  K-GAAP 조립건수                           ""       
				n01.SEND.IGAP                = "000";                                                // 26. C3  I-GAAP 조립건수                           ""
			}
			
			n01.SEND.IMED   = "</IM>"; // C4    전문내용종료태그                                    
			*/
			
			


			
			
	        /* TOBE 2017-07-01 */	 
			for(i = 0; i < spy1ListSize; i++){
				spy1Map = spy1List.get(i); 
			
				Logger.sys.println("spy1List.get(i) : ["+ i + "] : " + spy1List.get(i));	
				
		   	if(spy1Map.get("USER_TRM_NO").length() >= 12){
				BKCD       = spy1Map.get("USER_TRM_NO").substring(0,  6);      //점코드
				USERTERMNO = spy1Map.get("USER_TRM_NO").substring(0, 12);      //사용자단말번호
				addUserId  = spy1Map.get("USER_TRM_NO").substring(12);         //조작자번호
			}
		   	
				if("A".equals(payType)){
					strPayAmt = "0";
				}
				else{
					strPayAmt = spy1Map.get("PAY_AMT");
				}

			gate_tot_size    = String.format("%08d", n03.SEND.sysHdr.iTLen+n03.SEND.trnHdr.iTLen+n03.SEND.iTLen + 2 -8); // 전문전체길이+(종료'@@') -8
			data_tot_size    = String.format("%07d", n03.SEND.iTLen-10); // 데이터부 데이터길이 -10		
				
		   	n03.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
	    	
			n03.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
			n03.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
			n03.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
	        n03.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
	        
	        n03.SEND.DAT_KDCD            = "DTI";                                         //데이타헤더부 : (문자3)  데이터종류코드	       
			n03.SEND.DAT_LEN             = data_tot_size;                                 //데이타헤더부 : (숫자7)  데이터길이
			//TOBE 2017-08-24 오픈시 원복해야함 (계정계 테스트 서버가 특정일자밖에 인식을 못해서 밑에 하드코딩) n03.SEND.BGT_TRN_DT          = SepoaDate.getShortDateString();                // 1 .  S8    예산거래일자                                        
			n03.SEND.BGT_TRN_DT          = SepoaDate.getShortDateString();                // 1 .  S8    예산거래일자
//			n03.SEND.BGT_TRN_DT          = "20180413";
			
//			/////////////테스트///////////////////
//			if("A".equals(payType)){
//				
//			}
//			else{
//				n03.SEND.BGT_TRN_DT          = "YYYYMMDD";
//			}
//			////////////////////////////////////////
			
			//n03.SEND.BGT_TRN_DT          = "20171106";
					
					
			n03.SEND.MERE_TRN_DSCD       = strTRCD;                                       // 2 .  S4    동부동산거래구분코드
			n03.SEND.MERE_TLM_DIS_SRNO   = "00023";                                       // 3 .  N5    동부동산전문구분일련번호                                  
			n03.SEND.TRN_BYDY_SRNO       = "00002";                                       // 4 .  N5    거래일별일련번호                                      
			n03.SEND.NML_CAN_DSCD        = nml_can_dscd;                                  // 5 .  S1    정상취소구분코드 (1:정상,2:취소)                                      
			n03.SEND.ORTR_LOG_KEY_VAL    = "";                                            // 6 .  S56   원거래로그키값                                       
			n03.SEND.BIZ_DSCD            = "87";                                          // 7 .  S2    업무구분코드                                        
			
			//2017-08-31 운영자가 단말점코드로 변경 요청함 n03.SEND.TRM_ITLL_BRCD       = spy1Map.get("JUMJUJMCD");                      // 8 .  S6    단말설치점코드                                       
			n03.SEND.TRM_ITLL_BRCD       = BKCD;                                          // 8 .  S6    단말설치점코드
			
			n03.SEND.MOD_DSCD            = "0";                                           // 9.   S1    모드구분코드                                        
			n03.SEND.TRM_NO              = USERTERMNO;                                    // 10.  S12   단말번호                                          
			n03.SEND.OPR_ENO             = addUserId;                                     // 11.  S8    조작자직원번호  
			n03.SEND.RLPE_ENO            = "";                                            // 12.  S8    책임자직원번호  (1차책임자)                                       
			n03.SEND.RLPE_ENO2           = "";                                            // 13.  S8    책임자직원번호2 (2차책임자)
			n03.SEND.RLPE_APV_CD         = "0000000";                                     // 14.  S7    책임자승인코드                                       
			n03.SEND.CHRG_ENO            = "";                                            // 15.  S8    담당직원번호                                        
			n03.SEND.NSLIP_YN            = "N";                                           // 16.  S1    무전표여부                                         
			n03.SEND.NPRT_YN             = "Y";                                           // 17.  S1    무인자여부                                         
			n03.SEND.XCHPY_YN            = "N";                                           // 18.  S1    교환지급여부                                        
			n03.SEND.MD_GRCD             = "";                                            // 19.  S4    매체그룹코드                                        
			n03.SEND.BKW_ACNO            = spy1Map.get("BANK_ACCT");                      // 20.  S20   전행계좌번호   
//			/////////////테스트///////////////////
//			if("A".equals(payType)){
//				
//			}
//			else{
//				n03.SEND.BKW_ACNO            = "111111111111111111";                      // 20.  S20   전행계좌번호
//			}
//			////////////////////////////////////////
			n03.SEND.TRN_AM_1            = String.format("%015d",  Integer.parseInt(strPayAmt)); // 21.  D15   거래금액_1                                        
			n03.SEND.TRN_AM_2            = "000000000000000";                                    // 22.  D15   거래금액_2                                        
			n03.SEND.TRN_AM_3            = String.format("%015d",  Integer.parseInt(strAMT3));   // 23.  D15   거래금액_3                                        
			n03.SEND.DACC_CST_DSCD       = payType;                                       // 24.  S1    일계조립구분코드                                      
			n03.SEND.KGP_DACC_CST_CNT    = "000";                                         // 25.  N3    KGAAP일계조립건수                                   
			n03.SEND.GAAP_DACC_CST_CNT   = "000";                                         // 26.  N3    GAAP일계조립건수       
			
			n03.SEND.CMN_CAN_RSN_DSCD    = ccltRsnDscd;                                   // 27.  S2      취소사유구분코드
			n03.SEND.TRN_CAN_RSN_TXT     = ccltRsnCntn;                                   // 28.  S100   취소사유내용   
			
			n03.SEND.DACC_CST_CNT        = "00000";                                       // 29.  N5    일계조립건수  	
			}
			
			
			
			
			
			
			Configuration conf = new Configuration();
			
			String send_ip = conf.get("sepoa.interface.tcpip.ip");
			int send_port  = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
			ONCNF.LOGDIR   = conf.get("sepoa.logger.dir");
			
			n03.pay_send_no = glInfo.get("PAY_SEND_NO");
			int iret       = n03.sendMessage("BCB01000T03", send_ip, send_port); //개발
			
			if(iret == ONCNF.D_OK) {
				n03.RECV.sysHdr.log(ONCNF.LOGNAME, "");	
				n03.RECV.trnHdr.log(ONCNF.LOGNAME, "");	
				n03.RECV.log(ONCNF.LOGNAME, "");
				
				result = "SUC:"+n03.RECV.TRN_SRNO;
			}
			else if(iret == ONCNF.D_ECODE) { /// 전문내용 정상 오류일경우 ...
				n03.eRECV.sysHdr.log(ONCNF.LOGNAME, "");
				n03.eRECV.trnHdr.log(ONCNF.LOGNAME, "");
				n03.eRECV.log(ONCNF.LOGNAME, "");
				
				//ASIS 2017-07-01 result = "ERR:("+n01.eRECV.bizHdr.ERRCODE+")"+n01.eRECV.MESSAGE; 
				//TOBE 2017-07-01
				result = "ERR:("+n03.eRECV.msgHdr.MSG_CD+")"+n03.eRECV.msgHdr.MAIN_MSG_TXT;
			}		
			else {
				Logger.err.println("ERR:[BCB01000T03]예외오류가 발생되었습니다.(" + iret + ")");
				
				result = "ERR:(BCB01000T03)예외오류가 발생되었습니다.(" + iret + ")";
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			result = "ERR:예외오류가 발생되었습니다.";
		}
		
		return result;
	}	

	
	
	
	
	//TOBE 2017-07-01 책임자승인명세
	private String tcpICAA9010200(SepoaInfo info, String payType, List<Map<String, String>> spy1List, Map<String, String> glInfo, String HoisuYN) throws Exception{
		
		String              result       = null;
		String              strTRCD      = null;
		String              BKCD         = null;
		String              BRCD         = null; 
		String              TRMBNO       = null;
		String              USERTERMNO   = null;
		String              TERMNO9      = null;
		String              strMNNY      = "0000000"; //TOBE 2017-07-01 책임자승인코드(7)   , ASIS 책임자사유(3)  [0030 + ASIS CODE]
		String              bsList       = null;
		String              TTAL         = null;            
		String              KGAP         = null;        
		String              IGAP         = null; 
		String              MGRBIOAUTYN  = "N";	//(1)  책임자생체인식여부   "N"    
		String              paySendBio   = glInfo.get("PAY_SEND_BIO");
		String              txtMnno      = glInfo.get("TXT_MNNO");
		String              endTxtMnno   = glInfo.get("TXT_MNNO");
		String              workKind     = glInfo.get("WORK_KIND");
		String              bdsBdsCd     = glInfo.get("BDSBDSCD");
		
		/*
		CASE 2억 이상 
		SPY1GL.BEFORE_SIGN_NO (1차잭임자)
		SPY1GL.SIGNER_NO 최종승인자 (2차승인자)

		CASE 5천 이상 ~ 2억 미만
		SPY1GL.SIGNER_NO 최종승인자 (1차책임자)
		*/
		String              beforeSignNo = glInfo.get("BEFORE_SIGN_NO");
		String              signerNo     = glInfo.get("SIGNER_NO");
		
		String              trnLogKeyVal = glInfo.get("TRN_LOG_KEY_VAL"); //TOBE 2017-07-01 로그키값
		String              astAstGb     = null;
		String              addUserId    = null;
		String              mgrapvDscd   = null;
		String              ikCd         = null;
		String              nml_can_dscd = null;
		Map<String, String> spy1Map      = null;
		Map<String, String> bsListMap    = null;
		int                 totalListCnt = 0;
		String              gate_tot_size    = null;
		String              enabler_tot_size = null;
		String              data_tot_size    = null;
		String              txtMnno1      = glInfo.get("TXT_MNNO");
		String              txtMnno2      = glInfo.get("TXT_MNNO");
		//TOBE 2017-07-01 거래로그생성번호 L4 + 지급번호(3~13)
		String              trnLogCreNo   = new StringBuilder().append("SGF").append(glInfo.get("PAY_SEND_NO").substring(2)).toString();  
		String              rlpeApvTrnNm  = null;
		String              isApvRncd     = null;
		String              spr           = null; //S100   취소사유내용   
		
		String              trnTm         = null;                  //14.  S6	거래시각              
		
		try{
			if("N".equals(payType)){ //실패전문
				nml_can_dscd = "2";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				spr          = glInfo.get("CCLT_RSN_CNTN");
				trnTm        = SepoaDate.getShortTimeString();
			}
			else{
				nml_can_dscd = "1";  //TOBE 2017-07-01 정상취소구분 (1:정상,2:취소)
				spr          =  "";
				trnTm        = trnLogKeyVal.substring(27,33);
			}
			
			ICAA9010200 n04 = new ICAA9010200(); //전문내용
			
			
			if("N".equals(payType)){ //실패전문
				if("1".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 동산신규 취소";
				}
				else if("2".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 동산원가 취소";
				}
				else if("3".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 건물 자본적지출 취소";
				}
				else if("4".equals(workKind)){
					rlpeApvTrnNm = "자본예산 임차점포시설물 자본적지출 취소";
				} else {
					rlpeApvTrnNm = "자본예산 취소";
				}
				
			} else {
				if("1".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 동산신규";
				}
				else if("2".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 동산원가";
				}
				else if("3".equals(workKind)) {
					rlpeApvTrnNm = "자본예산 건물 자본적지출";
				}
				else if("4".equals(workKind)){
					rlpeApvTrnNm = "자본예산 임차점포시설물 자본적지출";
				} else {
					rlpeApvTrnNm = "자본예산";
				}
			}
			
			

			spy1Map      = spy1List.get(0);
			
	        /* TOBE 2017-07-01 */	   	
		   	if(spy1Map.get("USER_TRM_NO").length() >= 12){
				BKCD       = spy1Map.get("USER_TRM_NO").substring(0,  6);      //점코드
				USERTERMNO = spy1Map.get("USER_TRM_NO").substring(0, 12);      //사용자단말번호
				addUserId  = spy1Map.get("USER_TRM_NO").substring(12);         //조작자번호
			}
	

			gate_tot_size    = String.format("%08d", n04.SEND.sysHdr.iTLen + n04.SEND.trnHdr.iTLen + n04.SEND.iTLen + 2 -8); // 전문전체길이+(종료'@@') -8
			data_tot_size    = String.format("%07d", n04.SEND.iTLen-10); // 데이터부 데이터길이 -10	
				
		   	n04.SEND.sysHdr.ALL_TLM_LEN = gate_tot_size;
	    	
			n04.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
			n04.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
			n04.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
	        n04.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
	        
			if ("Y".equals(payType)){
				/*
				CASE 2억 이상 
				SPY1GL.BEFORE_SIGN_NO (1차잭임자)
				SPY1GL.SIGNER_NO 최종승인자 (2차승인자)

				CASE 5천 이상 ~ 2억 미만
				SPY1GL.SIGNER_NO 최종승인자 (1차책임자)
				*/
				if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 50000000 &&  Integer.parseInt(spy1Map.get("APPAPPAM")) < 200000000){ //TOBE 2017-07-01 1억미만 -> 2억미만 변경 
					//1차 단말 조작자
					txtMnno1 = signerNo;
					txtMnno2 = "";
					isApvRncd = "BOCOM00014"; //TOBE 2017-07-01 책임자 승인 사유 코드 (5천만원 이상)														
				}else if (Integer.parseInt(spy1Map.get("APPAPPAM")) >= 200000000 ){ //TOBE 2017-07-01 1억 -> 2억 변경					
					txtMnno1 = beforeSignNo; //1차
					//2차 단말 조작자
					txtMnno2 = signerNo;
					isApvRncd = "BOCOM00520"; //TOBE 2017-07-01 책임자 승인 사유 코드 (2억원 이상)
				}else {
					txtMnno1    = "";
					txtMnno2    = "";	
				}
			}else {
				//1차 단말 조작자
				txtMnno2    = "";
				isApvRncd = "BOCOM00001"; //TOBE 2017-07-01 책임자 승인 사유 코드 (취소)
			}
			
			
			
	        if(
				("Y".equals(payType)) &&
				(Integer.parseInt(spy1Map.get("APPAPPAM")) < 50000000 ) // TOBE 2017-07-01 작다로변경 (ASIS <= 50000000)
			){
	        	mgrapvDscd = "N"; //TOBE 2017-07-01 승인유형구분  1 -> N : 승인없음
			}
	        else{
	        	mgrapvDscd = "B"; //TOBE 2017-07-01 승인유형구분  2 -> B : 사전승인
	        }
	        
	        if(HoisuYN.equals("Y"))   // Y : 회수 , N : 회수아님
	        {
	        	mgrapvDscd = "N"; //TOBE 2017-07-01 승인유형구분  1 -> N : 승인없음
	        }
	        n04.SEND.trnHdr.RLPE_APV_DSCD   = mgrapvDscd;   // 책임자승인구분코드
	        
	        
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
		    n04.SEND.TRN_LOG_CRE_NO     = trnLogCreNo + nml_can_dscd;                     //13.  S14	거래로그생성번호       
//		    n04.SEND.TRN_TM             = trnLogKeyVal.substring(27,33);                  //14.  S6	거래시각  
		    n04.SEND.TRN_TM             = trnTm;                                          //14.  S6	거래시각  		    
		    n04.SEND.TRM_NO             = spy1Map.get("USER_TRM_NO").substring(0, 12);    //15.  S12	단말번호               
		    n04.SEND.TRSCNO             = "SGF";                                          //16.  S5	거래화면번호             
		    n04.SEND.BIZ_TRN_CD         = "BCB01000T";                                    //17.  S9	업무거래코드             
		    n04.SEND.RLPE_APV_TRN_NM    = rlpeApvTrnNm;                                   //18.  S50	책임자승인거래명       
		    n04.SEND.INP_MD_KDCD        = "EEPS1";                                        //19.  S8	입력매체종류코드         
		    n04.SEND.TRN_TYCD           = "27";                                           //20.  S2	거래유형코드(27:고정)
		    n04.SEND.TRN_STCD           = nml_can_dscd;                                   //21.  S1	거래상태코드(1:정상,2:취소)
		    n04.SEND.OPR_NO             = spy1Map.get("USER_TRM_NO").substring(12);       //22.  S8	조작자번호               
		    n04.SEND.RLPE_ENO           = txtMnno1;                                       //23.  S8	책임자직원번호           
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
		    n04.SEND.TRN_BKW_ACNO       = spy1Map.get("BANK_ACCT");                       //46.  S20	거래전행계좌번호       
		    n04.SEND.ITCSNO             = "";                                             //47.  S11	통합고객번호           
		    n04.SEND.BKW_ACNO           = "";                                             //48.  S20	전행계좌번호           
		    n04.SEND.TRN_KRW_AM         = String.format("%015d.000"
				                             , Integer.parseInt(spy1Map.get("APPAPPAM")));    //49.  D19	거래원화금액(18,3)           
		    n04.SEND.TRN_FC_AM          = "000000000000000.000";                          //50.  D19	거래외화금액(18,3)           
		    n04.SEND.ACCT_DT            = trnLogKeyVal.substring(19,27);                  //51.  S8	회계일자                 
		    n04.SEND.MOD_DSCD           = "0";                                            //52.  S1	모드구분코드(0:당일마감전)             
		    n04.SEND.SLIP_NO            = "";                                             //53.  S16	전표번호               
		    n04.SEND.DACC_BRCD          = ica_igjmCd;                                     //54.  S6	일계점코드
		    n04.SEND.CUS_NM             = glInfo.get("VENDOR_NAME_LOC");                  //55.  S50	고객명 (공급업체명)                 
		    n04.SEND.RLPE_ENO_2         = txtMnno2;                                       //56.  S8	책임자직원번호_2         
		    n04.SEND.SPR                = spr;                                             //57.  S1895	예비    (취소사유내용)             
		 
			
			Configuration conf = new Configuration();
			String send_ip     = conf.get("sepoa.interface.tcpip.ip");
			int send_port      = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
			ONCNF.LOGDIR       = conf.get("sepoa.logger.dir");
			
			n04.send_no = glInfo.get("PAY_SEND_NO");
			int iret = n04.sendMessage("ICAA9010200",send_ip,send_port);			//개발
			
			if(iret == ONCNF.D_OK) {
				n04.RECV.sysHdr.log(ONCNF.LOGNAME, "");		
				n04.RECV.trnHdr.log(ONCNF.LOGNAME, "");		
				n04.RECV.log(ONCNF.LOGNAME, "");

				result = "SUC";
			}
			else if(iret == ONCNF.D_ECODE) { /// 전문내용 정상 오류일경우 ...
				n04.eRECV.sysHdr.log();
				n04.eRECV.trnHdr.log();
				n04.eRECV.log(ONCNF.LOGNAME, "");		
					
				result = "ERR:["+n04.eRECV.msgHdr.MSG_CD+"]"+n04.eRECV.msgHdr.MAIN_MSG_TXT;
			}		
			else{
				Logger.err.println("ERR:(ICAA9010200)예외응답이 발생되었습니다.!!!.." + iret);
				
				result = "ERR:(ICAA9010200)예외응답이 발생되었습니다.(" + iret + ")";
			}
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			result = "ERR:예외오류가 발생되었습니다.";
		}
		
		return result;
	}
	
	
	private Object[] updateSpy1glManualAccountKindObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result       = new Object[1];
		Map<String, Object>       resultInfo   = new HashMap<String, Object>();
		Map<String, String>       gridDataInfo = null;
		List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    paySendNo    = null;
		String                    id           = info.getSession("ID");
		
		gridDataInfo = new HashMap<String, String>();
		
		paySendNo = gdReq.getParam("PAY_SEND_NO");
		
		gridDataInfo.put("HOUSE_CODE",  houseCode);
		gridDataInfo.put("PAY_SEND_NO", paySendNo);
		gridDataInfo.put("ADD_USER_ID", id);
		
		gridData.add(gridDataInfo);
		
		resultInfo.put("gridData", gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glManualAccountKind(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
	    
	    try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1glManualAccountKindObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1glManualAccountKind", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	private Object[] updateSpy1glManualAccountKindCancleObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              id         = info.getSession("ID");
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              paySendNo  = gdReq.getParam("PAY_SEND_NO");
		
		resultInfo.put("CHANGE_USER_ID", id);
		resultInfo.put("HOUSE_CODE",     houseCode);
		resultInfo.put("PAY_SEND_NO",    paySendNo);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glManualAccountKindCancle(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
	    
	    try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1glManualAccountKindCancleObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1glManualAccountKindCancle", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	//회수
	private GridData paySendAppCancle(GridData gdReq, SepoaInfo info) throws Exception {
    	GridData                  gdRes        = new GridData();
    	String                    gdResMessage = null;  
    	String                    paySendNo    = null;
    	String                    paySendBio   = null;
    	String                    statusCd     = null;
    	String                    txtMnno      = null;
    	Map<String, String>       glInfo       = null;
		List<Map<String, String>> spy1List     = null;
		boolean                   isStatus     = true;
    	int                       spy1ListSize = 0;
    	String                    accountKind  = null;
    	
    	String HoisuYN = "Y";  // Y : 회수 , N : 회수아님
    	String returnMessage = null;
    	String returnCode  = null;
        
        try {
			gdRes        = OperateGridData.cloneResponseGridData(gdReq);
			paySendNo    = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
    		paySendBio   = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_BIO"));
    		txtMnno      = JSPUtil.CheckInjection(gdReq.getParam("TXT_MNNO"));
    		glInfo       = this.selectSpy1glInfo(info, paySendNo);
    		spy1List     = this.selectSpy1List(info, paySendNo);
			spy1ListSize = spy1List.size();
			statusCd     = glInfo.get("STATUS_CD");
			accountKind  = glInfo.get("ACCOUNTKIND");
			glInfo.put("PAY_SEND_BIO", paySendBio);
			glInfo.put("TXT_MNNO",     txtMnno);
			
			
			if(spy1ListSize == 0){
				throw new Exception();
			}
			
			
			//TOBE 2017-07-01 추가 재산관리 입지대사 (회수)
			if("27".equals(statusCd)){
			    //차세대 대응 개발 - 동산신규 자산등재(진행,완료) 여부 : (200)진행,완료가 아님, (그외번호)진행,완료,에러 ///////////////////////
				String  workKind     = glInfo.get("WORK_KIND");
				String  bmsBmsYy  = gdReq.getParam("BMSBMSYY");
		    	String  bmsSrlNo  = gdReq.getParam("BMSSRLNO");
		    	String  appAppNo  = gdReq.getParam("APPAPPNO");
		    	String[] result = new String[3];
		    	if("1".equals(workKind)) {           // 동산 신규
			    	result = this.getEps0034WebService(info,bmsBmsYy,bmsSrlNo,appAppNo);
			    	if("200".equals(result[0]) == false){
						throw new Exception(result[1]);
					}
		    	}
		    	////////////////////////////////////////////////////////////////////////////////
				
				returnMessage = this.tcpBCB01000T02(info, "tcpBCB01000T02", "N", spy1List, glInfo, HoisuYN, statusCd); //TOBE 2017-07-01 추가 상태코드
				returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
			
				if("Y".equals(returnCode) == false){
					throw new Exception(returnMessage);
				}else {
					glInfo.put("STATUS_CD", "24");                      // 24:책임자전송완료
					this.updateSpy1glTcpState(gdReq, info, glInfo);		// 입지전송완료 결과 저장
					statusCd = "24";
				}
			}	
			
			
			//TOBE 2017-07-01 추가 책임자 승인 명세 (회수)
			if("24".equals(statusCd)) {                                    //24:책임자전송완료
				if(paySendBio.length() > 0){ 
					returnMessage = this.tcpICAA9010200(info, "N", spy1List, glInfo, HoisuYN); //책임자승인명세
					returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
					
					this.insertSinfhdBCB01000T(info, "ICAA9010200N", returnCode, returnMessage); //interface 입력
					
					if("Y".equals(returnCode) == false){
						throw new Exception(returnMessage);
					} else {
						glInfo.put("STATUS_CD", "20");                      // 20:이체완료
						this.updateSpy1glTcpState(gdReq, info, glInfo);		// 책임자승인명세 결과 저장
//						statusCd = "20";
					}
				}
				statusCd = "20";
			}			
		
			if(  ("20".equals(statusCd)) && ("1".equals(accountKind))  ){			
				this.paySendAppBCB01000T03A(info, spy1List, glInfo, HoisuYN); //계좌유효성검사
				this.payCancelAppBCB01000T03N(gdReq, info, glInfo, spy1List, "10", HoisuYN); //이체회수
				
				statusCd = "10";
			}
			
			this.payCancelAppBCB01000T02N(gdReq, info, spy1List, glInfo, "97", HoisuYN); //BS회수 TOBE 2017-07-01 (ASIS "00") 
			
			gdResMessage = this.successJson();
    	}
    	catch(Exception e){
//    		e.printStackTrace();
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.failJson(e.getMessage());
	    	isStatus     = false;
    	}
    	finally{
    		gdRes.setMessage(gdResMessage);
    		gdRes.setStatus(Boolean.toString(isStatus));
    	}
    	return gdRes;
	}
	
	private Object[] updateSpy1glCancelbackObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		String              paySendNo  = gdReq.getParam("PAY_SEND_NO");
		Map<String, String> resultInfo = new HashMap<String, String>();
		String              id         = info.getSession("ID");
		String              houseCode  = info.getSession("HOUSE_CODE");
		
		resultInfo.put("CHANGE_USER_ID", id);
		resultInfo.put("HOUSE_CODE",     houseCode);
		resultInfo.put("PAY_SEND_NO",    paySendNo);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1glCancelback(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1glCancelbackObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_010", "TRANSACTION", "updateSpy1glCancelback", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	private Object[] updateSpy1gInfoBeforeSignObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridDataInfo = new HashMap<String, String>();
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    id           = info.getSession("ID"); 
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    paySendNo    = gdReq.getParam("PAY_SEND_NO");
    	
    	gridDataInfo.put("ADD_USER_ID", id);
    	gridDataInfo.put("HOUSE_CODE",  houseCode);
    	gridDataInfo.put("PAY_SEND_NO", paySendNo);
    	
    	gridData.add(gridDataInfo);
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1gInfoBeforeSign(GridData gdReq, SepoaInfo info) throws Exception{
		
		Logger.debug.println("updateSpy1gInfoBeforeSign Start !!...........");
		
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	String   paySendBio   = null;
    	String   txtMnno      = null;
    	String   listSignYn   = null;
    	String   rcvMsg       = null; 
    	String   id           = null;
    	String   resultFlag   = null;
    	//ASIS 2017-07-01 BioGW    bio          = null;
    	String   bioEnc       = null;
    	String   gate_tot_size = null;
    	String   data_tot_size = null;
    	boolean  isStatus     = false;
    	
    	
    	try {
    		message    = this.getMessage(info);
    		paySendBio = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_BIO"));
    		txtMnno    = JSPUtil.CheckInjection(gdReq.getParam("TXT_MNNO"));
    		listSignYn = JSPUtil.CheckInjection(gdReq.getParam("LAST_SIGN_YN"));
    		id         = info.getSession("ID");
    		
    		Logger.debug.println("txtMnno : >" + txtMnno + "<");
			Logger.debug.println("id : >" + id + "<");
			//Logger.debug.println("paySendBio : >" + paySendBio + "<");
			
			//paySendBio = paySendBio.replace("+", " "); //TOBE 2017-07-01 계정계 암호화 오류로 테스트때문에 사용 오픈시 제거 

        	/*------------------------- TOBE 2017-07-01 암호화 ---------------------------*/
			bioEnc = bioEnc(paySendBio);
        	/*---------------------------------------------------------------------------*/
        	
			
    		//ASIS 2017-07-01 bio = new BioGW();
    		//TOBE 2107-07-01
    		
    		Logger.sys.println("CMT90040100 PAY_BD_APP  1");
    		
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
			
		   	bio.send_no = JSPUtil.CheckInjection(gdReq.getParam("PAY_SEND_NO"));
			
			Configuration conf = new Configuration();
			
			String send_ip = conf.get("sepoa.interface.tcpip.ip");
			int send_port  = Integer.parseInt(conf.get("sepoa.interface.tcpip.port"));
			ONCNF.LOGDIR   = conf.get("sepoa.logger.dir");
			
			/* ASIS 2107-07-01 rcvMsg     = bio.getEmpInfo(txtMnno, id, paySendBio, "", "4");
			   Logger.debug.println("rcvMsg : >" + rcvMsg + "<");
			*/   
			Logger.sys.println("CMT90040100 PAY_BD_APP  2");
			
			int iret = bio.sendMessage("CMT90040100", send_ip, send_port); //개발
			Logger.sys.println("CMT90040100 PAY_BD_APP  3");

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
    		
			Logger.debug.println("rcvMsg2 : >" + rcvMsg + "<");
			Logger.debug.println("resultFlag : >" + resultFlag + "<");
			Logger.debug.println("isStatus : >" + isStatus + "<");
			
			this.insertSinfhdBCB01000T(info, "CMT90040100", resultFlag, rcvMsg); //interface 입력
			
			
			if ((isStatus) && ("Y".equals(listSignYn))) { //TOBE 2017-07-01 추가 마지막 최종 책임자일경우 아래 상태코드(03:1차승인) 를 업데이트 하지 않는다
				gdResMessage = this.successJson();
			}
			else if(isStatus) {
    			obj      = this.updateSpy1gInfoBeforeSignObj(gdReq, info);
        		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1gInfoBeforeSign", obj);
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
    		Logger.debug.println("updateSpy1gInfoBeforeSign Exception : " + e.getMessage());
    		this.loggerExceptionStackTrace(e);
    		gdResMessage = e.getMessage();
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	finally{
    		Logger.debug.println("updateSpy1gInfoBeforeSign end...........!" );
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	@SuppressWarnings({ "rawtypes"})
    private GridData updateSpy1gInfoBeforeSignReject(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.updateSpy1gInfoBeforeSignObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "TX_009", "TRANSACTION", "updateSpy1gInfoBeforeSignReject", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = this.successJson();
    		}
    		else{
    			throw new Exception();
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		gdResMessage = this.failJson(gdResMessage);
	    	isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }


    @SuppressWarnings({ "rawtypes" })
	private GridData getCMT90020100(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    String        result       = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    Map<String, String> header = this.getHeader(gdReq, info);
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	    String        apvrncd        = gdReq.getParam("apvrncd");
	    String        user_trm_no    = gdReq.getParam("user_trm_no");
	    String        txtBrowserInfo = gdReq.getParam("txtBrowserInfo");
	    
	    try{	
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	isStatus = true;
	    	
            header.put("apvrncd"       , apvrncd);
            header.put("user_trm_no"   , user_trm_no);
            header.put("txtBrowserInfo", txtBrowserInfo);
            
	    	if(isStatus){
	    		result    = this.et_getCMT90020100(header, gdRes, info);

	    		Logger.sys.println(">>>>> bbb 01");
		    	gdResMessage = "[" + result + "]";
		    	Logger.sys.println(">>>>> bbb 02");
	    	}
	    	else{
	    		//gdResMessage = value.message;
	    		gdResMessage = "[]";
	    	}
	    	Logger.sys.println(">>>>> bbb 03");
	    	gdRes.addParam("mode", "query");
	    	Logger.sys.println(">>>>> bbb 04");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null)?"[" + message.get("MESSAGE.1002").toString() + "]":"[]";
	    	isStatus     = false;
	    }
	    Logger.sys.println(">>>>> bbb 05");
	    gdRes.setMessage(gdResMessage);
	    Logger.sys.println(">>>>> bbb 06");
	    gdRes.setStatus(Boolean.toString(isStatus));
	    Logger.sys.println(">>>>> bbb 07");
	    return gdRes;
	}

	/**
     * 책임자 승인 목록 
     * et_getCMT90020100
     * @param  gdReq
     * @param  info
     * @return GridData
     * @throws Exception
     * @since  2017-07-01
     * @modify 2017-07-01
     */
    private String et_getCMT90020100(Map<String, String> header, GridData gdRes, SepoaInfo info) throws Exception {
		String APV_RNCD          = null;
		String data_tot_size     = null;
		String result            = "";
		
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
		
	   	APV_RNCD                 = header.get("apvrncd");
	   	
	   	if(header.get("user_trm_no").length() >= 12){
			BKCD       = header.get("user_trm_no").substring(0,  6);      //점코드
			USERTERMNO = header.get("user_trm_no").substring(0, 12);      //사용자단말번호
			addUserId  = header.get("user_trm_no").substring(12);         //조작자번호
		}

	   	CMT90020100 n01 = new CMT90020100();
	   	
	   	data_tot_size    = String.format("%07d", n01.SEND.iTLen-10); // 데이터부 데이터길이 -10
//	    System.out.println("data_tot_size:"+data_tot_size+"|");
		
		n01.SEND.DAT_KDCD   = "DTI";           //데이타헤더부 : (문자3)  데이터종류코드	      
		n01.SEND.DAT_LEN    = data_tot_size;   //데이타헤더부 : (숫자7)  데이터길이
		
		n01.SEND.RLPE_APV_DSCD   = "B";           //1.   S1         책임자승인구분코드
		n01.SEND.APV_AVL_RLPE_CN = "00";          //2.   S2         승인가능책임자수
		n01.SEND.GRID_ROW_CNT    = "01";          //3.   S2         그리드열건수 
		n01.SEND.APV_RNCD        = APV_RNCD;      //4.   S10        승인사유코드 
		
		n01.SEND.trnHdr.TRM_BRNO      = BKCD;                //단말점번호    
		n01.SEND.trnHdr.TRN_TRM_NO    = USERTERMNO;          //단말번호
		n01.SEND.trnHdr.DL_BRCD       = BKCD;                //취급점번호    
        n01.SEND.trnHdr.OPR_NO        = addUserId;           //조작자번호
		
		try {
			int iret = n01.sendMessage("CMT90020100",send_ip,send_port);
			Logger.sys.println(">>>>> app 05");


			
			//TOBE 2017-07-01 추가 온라인 전문 로그
			if(iret == ONCNF.D_OK) {
				this.insertSinfhdBCB01000T(info, "CMT90020100", "Y", n01.RECV.msgHdr.MAIN_MSG_ADD_TXT); //interface 입력
			} else {
				this.insertSinfhdBCB01000T(info, "CMT90020100", "N", n01.RECV.msgHdr.MAIN_MSG_ADD_TXT); //interface 입력
			}
			
			
			if(iret == ONCNF.D_OK) {
				Logger.sys.println(">>>>> app 06");
				n01.ORECV.log(ONCNF.LOGNAME, "R");
				Logger.sys.println(">>>>> app 07");
				if(n01.ORECV.R_CODE.trim().equals("0000000")){
					for(int i = 0; i < n01.ORECV.list_cmt90020100_r.size();i++) {
						
						Logger.sys.println(">>>>> app 08");
						LIST_CMT90020100_R list = (LIST_CMT90020100_R) n01.ORECV.list_cmt90020100_r.get(i);
						Logger.sys.println(">>>>> app 09");
						gdRes.addValue("RLPE_EMNM"        ,  list.RLPE_EMNM        );  // S8   책임자행번	      
					    gdRes.addValue("RLPE_FNM"         ,  list.RLPE_FNM         );  // S30  책임자성명	      
					    gdRes.addValue("RLPE_LVJP_NM"     ,  list.RLPE_LVJP_NM     );  // S40  책임자직급명	    
						gdRes.addValue("RLPE_IPAD"        ,  list.RLPE_IPAD        );  // S39  책임자IP주소	    
						gdRes.addValue("RLPE_STS_INF"     ,  list.RLPE_STS_INF     );  // S1   책임자상태정보	  
						gdRes.addValue("RLPE_TRM_NO"      ,  list.RLPE_TRM_NO      );  // S12  책임자단말번호	  
						gdRes.addValue("RLPE_BRCD"        ,  list.RLPE_BRCD        );  // S6   책임자점코드	    
						gdRes.addValue("RLPE_MTBR_DIS"    ,  list.RLPE_MTBR_DIS    );  // S1   책임자모점구분	  
						gdRes.addValue("TGT_MD_DIS"       ,  list.TGT_MD_DIS       );  // S1   대상매체구분	    
						gdRes.addValue("RLPE_GDCD"        ,  list.RLPE_GDCD        );  // S2   책임자등급코드	  
						gdRes.addValue("RLPE_APV_SENU_2"  ,  list.RLPE_APV_SENU_2  );  // S1   책임자승인차수_2	
						gdRes.addValue("RLPE_GRP"         ,  list.RLPE_GRP         );  // S1   책임자그룹	      
						
						if(i+1 != n01.ORECV.list_cmt90020100_r.size()) {
						    result = result + "{managerNo:'" + list.RLPE_EMNM + "',managerName:'" + list.RLPE_FNM + "(" + list.RLPE_EMNM + ")'},";
						} else {
							result = result + "{managerNo:'" + list.RLPE_EMNM + "',managerName:'" + list.RLPE_FNM + "(" + list.RLPE_EMNM + ")'}";	
						}
						Logger.sys.println(">>>>> app 10");
						
					}
				}
				else{
					Logger.sys.println(">>>>> app 11");
					gdRes.setMessage(n01.ORECV.R_CODE.trim());
					Logger.sys.println(">>>>> app 12");
				}
			}
			else {
				Logger.sys.println(">>>>> app 13");
				throw new Exception();
			}
		}
		catch (Exception e) {
			Logger.sys.println(">>>>> app 14");
//			e.printStackTrace();
		}
		Logger.sys.println(">>>>> app 15");
    	return result;
	}


	/*------------------------- TOBE 2017-07-01 암호화 ---------------------------*/
    private String bioEnc(String strBio) throws Exception {
        String strPlain = null;   //지문
        String strEnc   = null;   //암호화
        String strDec   = null;   //복호화 
        
        strPlain = strBio;
        
	    try {
//	         Logger.sys.println("DAMO PAY_BD_APP  1");
	
        	 int ret;
             /* DAMO SCP : config file full path */
             String iniFilePath = "/app/damo3/scpdb_agent.ini"; //Unix/Linux Server
             //String iniFilePath = "C:\\app\\damo3\\scpdb_agent.ini"; // Windows Server
           
//             Logger.sys.println("DAMO PAY_BD_APP  2");
             /* DAMO SCP */      
             ScpDbAgent agt = new ScpDbAgent(); 
           
//             Logger.sys.println("DAMO PAY_BD_APP  3");
           
             /* DAMO SCP : initialization */ 
             /* return : 0,118(success) */
             ret = agt.AgentInit( iniFilePath );
             
//             Logger.sys.println("DAMO PAY_BD_APP  4");
           
           
             if ( ret != 0 && ret != 118 )
             {
//           	 Logger.sys.println("DAMO PAY_BD_APP  5");
             Thread.sleep(2000);
             throw new Exception("AgentInit ret( 0,118(success) ) : " + ret );
             }
//             Logger.sys.println("DAMO PAY_BD_APP  6");
        
             /* DAMO SCP : reinitialization */
             /* return : 0(success) */
             Thread.sleep(2000);      
           
//             Logger.sys.println("DAMO PAY_BD_APP  7");
           
             /* DAMO SCP : create context */
             byte[] ctx;
             ctx = agt.AgentCipherCreateContextServiceID( "EPS", "Account");
           
//             Logger.sys.println("DAMO PAY_BD_APP  8");
           
             /* 암호화 /복호화 */
             strEnc = agt.AgentCipherEncryptString( ctx, strPlain );  //지문 암호화
             //Logger.sys.println("EncryptString    : " + strEnc);
             strDec = agt.AgentCipherDecryptString( ctx, strEnc );    //복호화
             //Logger.sys.println("DecryptString    : " + strDec);
//             Logger.sys.println("DAMO PAY_BD_APP  9");
           
            }
            catch (ScpDbAgentException e1)
            {
//              System.out.println(e1.toString());
//            e1.printStackTrace();
              Logger.sys.println("bioEnc ScpDbAgentException : " + e1.getMessage() );	
            }
            catch (Exception e) {
              //e.printStackTrace();  
              Logger.sys.println("bioEnc Exception : " + e.getMessage() );	
            }
            finally {
            	Thread.sleep(2000); //try{Thread.sleep(2000);}catch(Exception e2){}            	
            }
		return strEnc;
	}
    
	/*---------------------------------------------------------------------------*/
    /* TOBE 2017-07-01 추가 EPS0033 재산관리 입지대사 */
    /*---------------------------------------------------------------------------*/
    
    //입지대사 화면에서 받은 data 처리
    private GridData webSendBs001(GridData gdReq, SepoaInfo info) throws Exception { 
    	Logger.sys.println("TEST_KIM webSendBs001 Start!!!!");
    	GridData                  gdRes        = new GridData();
    	String                    gdResMessage = null;
    	String                    paySendNo    = null;
    	String                    paySendBio   = null;
    	String                    statusCd     = null;
    	String                    accountKind  = null;
    	String                    txtMnno      = null;
    	Map<String, String>       glInfo       = null;
    	List<Map<String, String>> spy1List     = null;
    	boolean                   isStatus     = true;
    	int                       spy1ListSize = 0;
    	
    	String HoisuYN = "N";  // Y : 회수 , N : 회수아님
    	String payType = null; // Y : 실행 , N : 취소
		String returnMessage  = null;
	    String returnCode     = null;
	    String[] result       = null;
		List<Map<String, String>> ListbsData     = new ArrayList<Map<String, String>>();
		Map<String, String>       bsData         = new HashMap<String, String>();
		
        try {
			//gdRes        = OperateGridData.cloneResponseGridData(gdReq);  //화면 doqueryselect 문장용 세팅
        	
    		gdRes.setSelectable(false); // dosave insert update delete 용
			int row_cnt = gdReq.getRowCount();
			
			for( int i = 0; i < row_cnt; i++)
			{                             
				    bsData.put("EPS_STCD",       gdReq.getValue("EPS_STCD",   i));  //전자구매상태코드
				    bsData.put("ACCT_DT",        gdReq.getValue("ACCT_DT",    i));  //회계일
				    bsData.put("BIZ_DIS",        gdReq.getValue("BIZ_DIS",    i));  //업무구분
			    	bsData.put("MNG_BRCD",       gdReq.getValue("MNG_BRCD",   i));  //관리점   
					bsData.put("ACCD",           gdReq.getValue("ACCD",       i));  //계정코드
					bsData.put("RAP_DSCD",       gdReq.getValue("RAP_DSCD",   i));  //입지코드
					bsData.put("TRF_KRW_AM",     gdReq.getValue("TRF_KRW_AM", i));  //거래원화금액
					ListbsData.add(bsData);
					Logger.sys.println("TEST_KIM webSendBs001 EPS_STCD : " + bsData.get("EPS_STCD"));
					Logger.sys.println("TEST_KIM webSendBs001 ACCT_DT : " + bsData.get("ACCT_DT"));		
					Logger.sys.println("TEST_KIM webSendBs001 BIZ_DIS : " + bsData.get("BIZ_DIS"));
					Logger.sys.println("TEST_KIM webSendBs001 MNG_BRCD : " + bsData.get("MNG_BRCD"));
					Logger.sys.println("TEST_KIM webSendBs001 ACCD : " + bsData.get("ACCD"));
					Logger.sys.println("TEST_KIM webSendBs001 RAP_DSCD : " + bsData.get("RAP_DSCD"));
					Logger.sys.println("TEST_KIM webSendBs001 TRF_KRW_AM : " + bsData.get("TRF_KRW_AM"));
			}
			
			Logger.sys.println("TEST_KIM webSendBs001 EPS_STCD : " + bsData.get("EPS_STCD"));
			
			if(bsData.get("EPS_STCD") == null) {
				throw new Exception("Not Exist EPS_STCD");
			} else if("10".equals(bsData.get("EPS_STCD"))) { //실행
				payType = "Y";
			} else if("30".equals(bsData.get("EPS_STCD"))) { //취소
				payType = "N";
			}
			Logger.sys.println("TEST_KIM webSendBs001 payType : " + payType);
			//재산관리 입지대사				
			BCB01000T02 n02 = new BCB01000T02();
			Logger.sys.println("TEST_KIM webSendBs001 ---1");
			n02.SEND.DACC_CST_CNT = "00000";
			Logger.sys.println("TEST_KIM webSendBs001 ---2");			
			returnMessage = this.getEps0033(info, glInfo, ListbsData, n02, payType);
			//returnCode    = this.getTcpReturnCodeBoolean(returnMessage);
			
			if("200".equals(returnMessage)) { //성공
				if("Y".equals(payType)) {
					gdRes.addParam("STEP", "WebPrcSendOK"); //실행성공
				} else {
					gdRes.addParam("STEP", "WebCanSndOK");  //취소성공
				}
			} else {//실패
				if("Y".equals(payType)) { 
					gdRes.addParam("STEP", "WebPrcSendErr"); //실행실패
				} else {  
					gdRes.addParam("STEP", "WebCanSndErr");  //취소실패
				}
				//throw new Exception(returnMessage);
			}
			Logger.sys.println("TEST_KIM webSendBs001 ---3");			
			gdResMessage = this.successJson();
			Logger.sys.println("TEST_KIM webSendBs001 ---4");
        }
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.failJson(e.getMessage());
	    	isStatus     = false;
    	}
        gdRes.addParam("mode", "webSendBs001");
		Logger.sys.println("TEST_KIM webSendBs001 ---5");    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
		Logger.sys.println("TEST_KIM webSendBs001 END!!!");    	
    	return gdRes;
	}
    
    
    
    private EPS0033 getEps0033Eps0033(SepoaInfo info, String infNo, Map<String, String> glInfo, List<Map<String, String>> lnList, BCB01000T02 n02) throws Exception{
		Map<String, String>          gridInfo      = null;
		EPS0033                      eps0033       = new EPS0033();
		String                       trnTrnDt      = null;
		String                       trnTrnCd      = null;
		String                       id            = this.getWebserviceId(info);
		EPS0033_WSStub.ArrayOfString igjmArray     = new EPS0033_WSStub.ArrayOfString();
		EPS0033_WSStub.ArrayOfString bsisArray     = new EPS0033_WSStub.ArrayOfString();
		EPS0033_WSStub.ArrayOfString gwcdArray     = new EPS0033_WSStub.ArrayOfString();
		EPS0033_WSStub.ArrayOfString ijgbArray     = new EPS0033_WSStub.ArrayOfString();
		EPS0033_WSStub.ArrayOfString tsamArray     = new EPS0033_WSStub.ArrayOfString();
		int                          gridSize      = lnList.size();
		int                          i             = 0;
		String                       workKind      = null;
		String                       payType       = null;
		String                       trnMode       = null;
		
		Logger.sys.println("n02.SEND.DACC_CST_CNT : " + n02.SEND.DACC_CST_CNT);
		
		//자본예산 입지대사시 (BS)
		if(Integer.parseInt(n02.SEND.DACC_CST_CNT) > 0 ){
			trnTrnDt = n02.SEND.BGT_TRN_DT;
			workKind = glInfo.get("WORK_KIND");
			payType  = n02.SEND.NML_CAN_DSCD;
		} else { //재무회계 입지대사시 (CC)
			Logger.sys.println("lnList.get(i)  : " + lnList.get(i));
			gridInfo = lnList.get(i);
			Logger.sys.println("gridInfo  : " + gridInfo);
			
			trnTrnDt = gridInfo.get("ACCT_DT").replaceAll("/", "");
			Logger.sys.println("KIM_TEST trnTrnDt[" + trnTrnDt + "]");			
			workKind = gridInfo.get("BIZ_DIS");
			if ("10".equals(gridInfo.get("EPS_STCD"))) { //10:BS처리 , 30:BS취소
				payType  = "1"; //정상
			} else {
				payType  = "2"; //취소
			}
		}
		
		Logger.sys.println("eps0033 3");
		
		
		
		
		if("1".equals(payType)) {
			trnMode  = "C"; //등록
		} else {
			trnMode  = "R"; //취소
		}
		
		
		
	    //거래코드
		if("1".equals(workKind)) {           // 동산 신규
			if("1".equals(payType)) {
				trnTrnCd = "1030"; //정상
			} else {
				trnTrnCd = "1050"; //취소
			}
		} else if("2".equals(workKind)) {    // 동산 원가
			if("1".equals(payType)) {
				trnTrnCd = "1100"; //정상
			} else {
				trnTrnCd = "1110"; //취소
			}
		} else if(("3".equals(workKind)) ||  //건물자본적지출
				  ("4".equals(workKind)) ) { //임차점포자본적지출
			if("1".equals(payType)) {
				trnTrnCd = "2050"; //정상
			} else {
				trnTrnCd = "2060"; //취소
			}
		} else {
	    	throw new Exception("재산관리 입지대사중 미분류 거래코드 발생");		    				
	    }
		
			Logger.sys.println("eps0033 4");


		//자본예산 입지대사시 (BS)
		if(Integer.parseInt(n02.SEND.DACC_CST_CNT) > 0 ){
			Logger.sys.println("eps0033 5");
			
			for( i = 0; i < Integer.parseInt(n02.SEND.DACC_CST_CNT);i++) {
				
				gridInfo = lnList.get(i);
				igjmArray.addString(gridInfo.get("DACC_BRCD"));  //S6    일계점코드  
				bsisArray.addString(gridInfo.get("BSIS_DSCD"));  //S1    BS/IS구분코드 
				gwcdArray.addString(gridInfo.get("ACCD"     ));  //S11   계정과목코드   
				ijgbArray.addString(gridInfo.get("RAP_DSCD" )    //S1    입지급구분코드 (입지구분1)
						          + gridInfo.get("RAP_STCD" ));  //S1    입지급상태코드 (입지구분2)
				tsamArray.addString(gridInfo.get("EXU_AM"   ));  //D15   집행금액
				Logger.sys.println("eps0033 6");
			}
		} else { //재무회계 입지대사시 (CC)
			Logger.sys.println("eps0033 7");
			id = "99999999";
			
			for(i = 0; i < lnList.size(); i++){
				
				gridInfo = lnList.get(i);
				
				igjmArray.addString(gridInfo.get("MNG_BRCD"));
				bsisArray.addString("1");
				gwcdArray.addString(gridInfo.get("ACCD"));
				ijgbArray.addString(gridInfo.get("RAP_DSCD")+payType);
				tsamArray.addString(gridInfo.get("TRF_KRW_AM"));
				Logger.sys.println("eps0033 9");
			}
		}
		
		Logger.sys.println("eps0033 10");
		eps0033.setMODE(trnMode);
		eps0033.setBNKCD("20");
		eps0033.setTRNTRNDT(trnTrnDt);
		eps0033.setTRNTRNCD(trnTrnCd);
		eps0033.setIGJM(igjmArray);
		eps0033.setBSIS(bsisArray);
		eps0033.setGWCD(gwcdArray);
		eps0033.setIJGB(ijgbArray);
		eps0033.setTSAM(tsamArray);
		eps0033.setUSRUSRID(id);
		eps0033.setINF_REF_NO(infNo);
		
		return eps0033;
	}
    
    private Map<String, String> insertSinfep0033InfoSinfEp0033Info(EPS0033 eps0033, SepoaInfo info, String infNo) throws Exception{
		Map<String, String> sinfEp0033Info = new HashMap<String, String>();
		String              houseCode      = info.getSession("HOUSE_CODE");
		String              mode           = eps0033.getMODE();
		String              bnkCd          = eps0033.getBNKCD();
		String              trnTrnDt       = eps0033.getTRNTRNDT();
		String              trnTrnCd       = eps0033.getTRNTRNCD();
		String              usrUsrId       = eps0033.getUSRUSRID();
		
		sinfEp0033Info.put("HOUSE_CODE", houseCode);
		sinfEp0033Info.put("INF_NO",     infNo);
		sinfEp0033Info.put("INF_MODE",   mode);
		sinfEp0033Info.put("BNKCD",      bnkCd);
		sinfEp0033Info.put("TRNTRNDT",   trnTrnDt);
		sinfEp0033Info.put("TRNTRNCD",   trnTrnCd);
		sinfEp0033Info.put("USRUSRID",   usrUsrId);
		
		return sinfEp0033Info;
	}
    
    private List<Map<String, String>> insertSinfep0033InfoSinfEp0033PrList(EPS0033 eps0033, SepoaInfo info, String infNo) throws Exception{
		List<Map<String, String>>    sinfEp0033PrList     = new ArrayList<Map<String, String>>();
		EPS0033_WSStub.ArrayOfString jumJumCd             = eps0033.getIGJM();
		EPS0033_WSStub.ArrayOfString pmkPmkCd             = eps0033.getBSIS();
		EPS0033_WSStub.ArrayOfString pmkSrlNo             = eps0033.getGWCD();
		EPS0033_WSStub.ArrayOfString ijgb                 = eps0033.getIJGB();
		EPS0033_WSStub.ArrayOfString tsam                 = eps0033.getTSAM();
		String[]                     igjmArray            = jumJumCd.getString();
		String[]                     bsisArray            = pmkPmkCd.getString();
		String[]                     gwcdArray            = pmkSrlNo.getString();
		String[]                     ijgbArray            = ijgb.getString();
		String[]                     tsamArray            = tsam.getString();
		String                       igjmArrayInfo        = null;
		String                       bsisArrayInfo        = null;
		String                       gwcdArrayInfo        = null;
		String                       ijgbArrayInfo        = null;
		String                       tsamArrayInfo        = null;
		String                       houseCode            = info.getSession("HOUSE_CODE");
		Map<String, String>          sinfEp0033PrListInfo = null;
		int                          igjmArrayLength      = igjmArray.length;
		int                          i                    = 0;
		
		for(i = 0; i < igjmArrayLength; i++){
			sinfEp0033PrListInfo = new HashMap<String, String>();
			
			igjmArrayInfo = igjmArray[i];
			bsisArrayInfo = bsisArray[i];
			gwcdArrayInfo = gwcdArray[i];
			ijgbArrayInfo = ijgbArray[i];
			tsamArrayInfo = tsamArray[i];
			
			sinfEp0033PrListInfo.put("HOUSE_CODE", houseCode);
			sinfEp0033PrListInfo.put("INF_NO",     infNo);
			sinfEp0033PrListInfo.put("SEQ",        Integer.toString(i));
			sinfEp0033PrListInfo.put("IGJM",       igjmArrayInfo);
			sinfEp0033PrListInfo.put("BSIS",       bsisArrayInfo);
			sinfEp0033PrListInfo.put("GWCD",       gwcdArrayInfo);
			sinfEp0033PrListInfo.put("IJGB",       ijgbArrayInfo);
			sinfEp0033PrListInfo.put("TSAM",       tsamArrayInfo);
			
			sinfEp0033PrList.add(sinfEp0033PrListInfo);
		}
		
		return sinfEp0033PrList;
	}
    
    private void insertSinfep0033Info(EPS0033 eps0033, SepoaInfo info, String infNo) throws Exception{
		Object[]                  svcParamObj      = new Object[1];
		Map<String, Object>       svcParamObjInfo  = new HashMap<String, Object>();
		Map<String, String>       sinfEp0033Info   = this.insertSinfep0033InfoSinfEp0033Info(eps0033, info, infNo);
		List<Map<String, String>> sinfEp0033PrList = this.insertSinfep0033InfoSinfEp0033PrList(eps0033, info, infNo);
		SepoaOut                  value            = null;
		boolean                   flag             = false;
		
		svcParamObjInfo.put("sinfEp0033Info",   sinfEp0033Info);
		svcParamObjInfo.put("sinfEp0033PrList", sinfEp0033PrList);
		
		svcParamObj[0] = svcParamObjInfo;
		
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0033Info", svcParamObj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
	}
    
    private String[] getEPS0033Result(EPS0033 eps0033) throws Exception{
		EPS0033Response              eps0033Response = new EPS0033_WSStub().ePS0033(eps0033);
		EPS0033_WSStub.ArrayOfString arrayOfString   = eps0033Response.getEPS0033Result();
		String[]                     result          = arrayOfString.getString();
		
		return result;
	}
    
    
    private void updateSinfep0033Info(SepoaInfo info, String infNo, String[] response){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		String              return1   = response[1];
		String              return2   = response[2];
		
		try{
			param.put("RETURN1",    code);
			param.put("RETURN2",    return1);
			param.put("RETURN3",    return2);
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0033Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String getEps0033(SepoaInfo info, Map<String, String> glInfo, List<Map<String, String>> lnList, BCB01000T02 n02, String payType) throws Exception{
    	String   infNo        = null;
    	String   code         = null;
    	String   status       = null;
    	String   reason       = null;
    	String   infReceiveNo = null;
    	String[] result       = null;
    	EPS0033  eps0033      = null;
    	String   infCode      = null;
    	
    	try {
    		if("N".equals(payType)){
    			infCode = "EPS0033R";
        	}
        	else{
        		infCode = "EPS0033";
        	}
    		infNo   = this.insertSinfhdInfo(info, infCode, "S");
    		Logger.debug.println(info.getSession("ID"), this, "getEps00331 : 1" );
    		eps0033 = this.getEps0033Eps0033(info, infNo, glInfo, lnList, n02);
    		Logger.debug.println(info.getSession("ID"), this, "getEps00331 : 2" );
    		
    		this.insertSinfep0033Info(eps0033, info, infNo);
    		Logger.debug.println(info.getSession("ID"), this, "getEps00331 :3" );
    		
    		result       = this.getEPS0033Result(eps0033);
    		code         = result[0];
    		infReceiveNo = result[3];
    		
    		if("200".equals(code)){
    			status = "Y";
				reason = "";
    		}
    		else{
    			status = "N";
				reason = result[1];
    		}
    	}
    	catch(Exception e){
    		result = new String[3];
    		
	    	status       = "N";
			reason       = this.getExceptionStackTrace(e);
			reason       = this.getStringMaxByte(reason, 4000);
			infReceiveNo = "";
			
			result[0] = "901";
			result[1] = reason;
			result[2] = reason;
			
			this.loggerExceptionStackTrace(e);
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, infReceiveNo);
    	this.updateSinfep0033Info(info, infNo, result);
    	
    	return result[0];
    }
    /*---------------------------------------------------------------------------*/
    
    
    private String[] getEps0034WebService(SepoaInfo info, String bsmBsmYy, String bmsSrlNo, String appAppNo) throws Exception{
		EPS_WSStub      epsWSStub       = null;
		EPS0034         eps0034         = null;
		EPS0034Response eps0034Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          reason          = null;
		String          code            = null;
		String[]        response        = null;
		//StringBuffer    stringBuffer    = null;
		
		try{
			epsWSStub = new EPS_WSStub();
			
			eps0034 = this.getEpsWebServiceEps0034(info, bsmBsmYy, bmsSrlNo, appAppNo);
							
			eps0034Response = epsWSStub.ePS0034(eps0034);
			arrayOfString   = eps0034Response.getEPS0034Result();
			response        = arrayOfString.getString();
		}
		catch(Exception e){
			response = new String[3];
			
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
	    
		//stringBuffer = this.getEps0019CodeJson(response);
		
		return response;
	}
	
	 private EPS0034 getEpsWebServiceEps0034(SepoaInfo info, String bsmBsmYy ,String bmsSrlNo, String appAppNo) throws Exception{		
			EPS0034 eps0034  = new EPS0034();
			String  id       = this.getWebserviceId(info);
			
//			MODE      작업구분        string / (고정형)1 C 필수 - 자산등재(진행,완료) 여부조회 , R 자산등재취소(진행,완료) 여부조회
//			BMSBMSYY  예산연도        string / (고정형)4  
//			BMSSRLNO  예산일련번호    string / (고정형)5   필수 
//			APPAPPNO  승인번호        string / (고정형)3   필수 
//			USRUSRID  사용자행번      string / (고정형)8   필수 

			eps0034.setMODE("C");
			eps0034.setBMSBMSYY(bsmBsmYy);
			eps0034.setBMSSRLNO(bmsSrlNo);
			eps0034.setAPPAPPNO(appAppNo);
			eps0034.setUSRUSRID(id);
			
			return eps0034;
		}
	

    
    

}