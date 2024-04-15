package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.woorifg.wpms.wpms_webservice.EPS_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.ArrayOfString;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0024Response;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class pay_pp_lis2 extends HttpServlet{

	private static final long serialVersionUID = 1L;


	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        SepoaInfo   info  = sepoa.fw.ses.SepoaSession.getAllValue(req); // 세션 Object
        GridData    gdReq = null;
        GridData    gdRes = new GridData();
        String      mode  = null;
        PrintWriter out   = null;
        
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");
        
        try {
        	out   = res.getWriter();
       		gdReq = OperateGridData.parse(req, res);
       		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
       		
       		if("getEps0024".equals(mode)){			//동산 자본적지출(EPS0024) 
       			gdRes = this.getEps0024(gdReq, info);
       		}
        }
        catch (Exception e) {
        	gdRes.setMessage("Error: " + e.getMessage());
        	gdRes.setStatus("false");
        }
        finally {
        	try {
        		OperateGridData.write(req, res, gdRes, out);
        	}
        	catch (Exception e) {Logger.debug.println();}
        }
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
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
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
    
    private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
     
    private EPS0024 getEps0024WebserviceEps0024(GridData gdReq, SepoaInfo info) throws Exception{
    	EPS0024             eps0024  = new EPS0024();
    	Map<String, String> header   = this.getHeader(gdReq, info);
    	String              jumJumCd = header.get("jumjumcd");
    	String              pmkPmkCd = header.get("pmkpmkcd");
    	String              pmkPmkNy = header.get("pmkpmknm");
    	String              usrUsrId = this.getWebserviceId(info);
    	
    	eps0024.setMODE("S");
    	eps0024.setJUMJUMCD(jumJumCd);
    	eps0024.setPMKPMKCD(pmkPmkCd);
    	eps0024.setPMKPMKNY(pmkPmkNy);
    	eps0024.setUSRUSRID(usrUsrId);
    	
    	return eps0024;
    }
    
    private void insertSinfep0024Info(SepoaInfo info, String infNo, EPS0024 eps0024) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              mode      = eps0024.getMODE();
		String              jumJumCd  = eps0024.getJUMJUMCD();
		String              pmkPmkCd  = eps0024.getPMKPMKCD();
		String              pmkPmkNy  = eps0024.getPMKPMKNY();
		String              usrUsrId  = eps0024.getUSRUSRID();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE", houseCode);
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("JUMJUMCD",   jumJumCd);
		svcParam.put("PMKPMKCD",   pmkPmkCd);
		svcParam.put("PMKPMKNY",   pmkPmkNy);
		svcParam.put("USRUSRID",   usrUsrId);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0024Info", obj);
		isStatus = value.flag;
		
		if(isStatus == false) {
			throw new Exception(); 
		}
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
    
    private void updateSinfep0024Info(SepoaInfo info, String infNo, String[] response){
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
			content   = this.getStringMaxByte(content, 4000);
			
			if("200".equals(code)){
				param.put("RETURN1", code);
				param.put("RETURN2", content);
				param.put("RETURN3", "");
			}
			else{
				param.put("RETURN1", code);
				param.put("RETURN2", content);
				param.put("RETURN3", "");
			}
			
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0024Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private String[] getEps0024GdResSplit(String result, String deli) throws Exception{
    	String[] resultArray   = null;
    	String   delimeter     = null;
    	char[]   tempCharArray = new char[1];
    	
		tempCharArray[0] = (char)9;
		delimeter        = new String(tempCharArray);
		result           = result.replace(deli, delimeter);
		resultArray      = result.split(delimeter);
		
		return resultArray;
    }
    
    private GridData getEps0024GdRes(GridData gdReq, SepoaInfo info, GridData gdRes, String result) throws Exception{
	    String              rowInfo        = null;
	    String[]            rowArray       = this.getEps0024GdResSplit(result, "!|");
	    String[]            columnArray    = null;
	    Map<String, String> columnInfo     = null;
	    Map<String, String> header         = this.getHeader(gdReq, info);
    	int                 i              = 0;
	    int                 rowArrayLength = rowArray.length;
	    
    	for(i = 0; i < rowArrayLength; i++){
    		columnInfo = new HashMap<String, String>();
    		
    		rowInfo     = rowArray[i];
    		columnArray = this.getEps0024GdResSplit(rowInfo, "@|");
    		
    		columnInfo.put("DOSUNQNO", columnArray[0]);
    		columnInfo.put("PMKPMKCD", columnArray[1]);
    		columnInfo.put("PMKPMKNM", columnArray[2]);
    		columnInfo.put("JUMJUMCD", columnArray[3]);
    		columnInfo.put("GEGETDT",  columnArray[4]);
    		columnInfo.put("JANJONAM", columnArray[6]);
    		
    		gdRes.addValue("SELECTED", "0");
    		gdRes.addValue("DOSUNQNO", columnInfo.get("DOSUNQNO"));
    		gdRes.addValue("JUMJUMNM", header.get("jumjumnm"));
    		gdRes.addValue("PMKPMKCD", columnInfo.get("PMKPMKCD"));
    		gdRes.addValue("PMKPMKNM", columnInfo.get("PMKPMKNM"));
    		gdRes.addValue("JUMJUMCD", columnInfo.get("JUMJUMCD"));
    		gdRes.addValue("GEGETDT",  columnInfo.get("GEGETDT"));
    		gdRes.addValue("JABJABAM", columnInfo.get("JANJONAM"));
    	}
    	
    	return gdRes;
    }
    
    private String getEps0024Webservice(GridData gdReq, SepoaInfo info) throws Exception{
    	String[]        arrayOfStringArray = null;
    	String          code               = null;
    	String          result             = null;
    	String          infNo              = null;
    	String          status             = null;
		String          reason             = null;
    	EPS_WSStub      epsWSStub          = null;
    	EPS0024         eps0024            = null;
    	EPS0024Response eps0024Response    = null;
    	ArrayOfString   arrayOfString      = null;
    	
    	try{
    		epsWSStub = new EPS_WSStub();
    		eps0024   = this.getEps0024WebserviceEps0024(gdReq, info);
    		infNo     = this.insertSinfhdInfo(info, "EPS0024", "S");
        	
        	this.insertSinfep0024Info(info, infNo, eps0024);
        	
        	eps0024Response = epsWSStub.ePS0024(eps0024);
        	
        	arrayOfString      = eps0024Response.getEPS0024Result();
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
    		reason = this.getStringMaxByte(reason, 4000);
    		result = reason;
    		code   = "900";
    		
    		arrayOfStringArray[0] = code;
    		arrayOfStringArray[1] = reason;
    		arrayOfStringArray[2] = "";
    	}
    	
    	this.updateSinfhdInfo(info, infNo, status, reason, " ");
    	this.updateSinfep0024Info(info, infNo, arrayOfStringArray);
    	
    	if("200".equals(code) == false){
    		throw new Exception(result);
    	}
    	
    	return result;
    }

	private GridData getEps0024(GridData gdReq, SepoaInfo info) throws Exception{
		GridData gdRes        = new GridData();
	    String   gdResMessage = "";
	    String   result       = null;
	    boolean  isStatus     = true;
	
	    try{
	    	gdRes  = OperateGridData.cloneResponseGridData(gdReq);
	    	result = this.getEps0024Webservice(gdReq, info);
	    	gdRes  = this.getEps0024GdRes(gdReq, info, gdRes, result);
	    }
	    catch(Exception e){
	    	this.loggerExceptionStackTrace(e);
	    	
	    	gdResMessage = e.getMessage();
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
}
