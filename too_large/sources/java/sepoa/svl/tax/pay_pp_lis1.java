package sepoa.svl.tax;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import com.woorifg.wpms.wpms_webservice.EPS_WSStub;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.ArrayOfString;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020;
import com.woorifg.wpms.wpms_webservice.EPS_WSStub.EPS0020Response;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class pay_pp_lis1 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData  gdReq = null;
    	GridData  gdRes = new GridData();
    	String    mode  = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	PrintWriter out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getEps0020".equals(mode)){
    			gdRes = this.getEps0020(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
//    		e.printStackTrace();
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {Logger.debug.println();}
    	}
    }
    
    
    
    @SuppressWarnings({ "rawtypes", "unchecked", "unused" })
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
    
    @SuppressWarnings("unused")
	private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
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
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
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
			id = "19116877";
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
    
    private void insertSinfep0020Info(SepoaInfo info, String infNo, EPS0020 eps0020) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              mode      = eps0020.getMODE();
		String              jumJumCd  = eps0020.getJUMJUMCD();
		String              astAstCd  = eps0020.getASTASTGB();
		String              usrUsrId  = eps0020.getUSRUSRID();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE", houseCode);
		svcParam.put("INF_NO",     infNo);
		svcParam.put("INF_MODE",   mode);
		svcParam.put("JUMJUMCD",   jumJumCd);
		svcParam.put("ASTASTCD",   astAstCd);
		svcParam.put("USRUSRID",   usrUsrId);
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0020Info", obj);
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
    
    private void updateSinfep0020Info(SepoaInfo info, String infNo, String[] response){
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
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0020Info", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
    
    private EPS0020 getEps0020WebserviceEps0020(GridData gdReq, SepoaInfo info) throws Exception{
    	EPS0020             eps0020            = new EPS0020();
    	Map<String, String> header             = this.getHeader(gdReq, info);
    	String              jumjumcd           = null;
    	String              astastcd           = null;
    	String              id                 = this.getWebserviceId(info);
    	
    	jumjumcd = header.get("jumjumcd");
		astastcd = header.get("astastcd");
		
    	eps0020.setMODE("S");
    	eps0020.setASTASTGB(astastcd);
    	eps0020.setJUMJUMCD(jumjumcd);
    	eps0020.setUSRUSRID(id);
    	
    	return eps0020;
    }
        
    private String getEps0020Webservice(GridData gdReq, SepoaInfo info) throws Exception{
    	String[]        arrayOfStringArray = null;
    	String          code               = null;
    	String          result             = null;
    	String          infNo              = null;
    	String          status             = null;
		String          reason             = null;
    	EPS_WSStub      epsWSStub          = null;
    	EPS0020         eps0020            = null;
    	EPS0020Response eps0020Response    = null;
    	ArrayOfString   arrayOfString      = null;
    	
    	try{
    		epsWSStub = new EPS_WSStub();
    		eps0020   = this.getEps0020WebserviceEps0020(gdReq, info);
    		infNo     = this.insertSinfhdInfo(info, "EPS0020", "S");
        	
        	this.insertSinfep0020Info(info, infNo, eps0020);
        	
        	eps0020Response    = epsWSStub.ePS0020(eps0020);
        	arrayOfString      = eps0020Response.getEPS0020Result();
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
    	this.updateSinfep0020Info(info, infNo, arrayOfStringArray);
    	
    	if("200".equals(code) == false){
    		throw new Exception(result);
    	}
    	
    	return result;
    }
    
    private String[] getEps0020GdResSplit(String result, String deli) throws Exception{
    	String[] resultArray   = null;
    	String   delimeter     = null;
    	char[]   tempCharArray = new char[1];
    	
		tempCharArray[0] = (char)9;
		delimeter        = new String(tempCharArray);
		result           = result.replace(deli, delimeter);
		resultArray      = result.split(delimeter);
		
		return resultArray;
    }
    
    private GridData getEps0020GdRes(GridData gdRes, String result) throws Exception{
	    String              rowInfo        = null;
	    String[]            rowArray       = this.getEps0020GdResSplit(result, "!|");
	    String[]            columnArray    = null;
	    Map<String, String> columnInfo     = null;
    	int                 i              = 0;
	    int                 rowArrayLength = rowArray.length;
	    
    	for(i = 0; i < rowArrayLength; i++){
    		columnInfo = new HashMap<String, String>();
    		
    		rowInfo     = rowArray[i];
    		columnArray = this.getEps0020GdResSplit(rowInfo, "@|");
    		
    		columnInfo.put("ASTASTGB", columnArray[0]);
    		columnInfo.put("ASTASTNM", columnArray[1]);
    		columnInfo.put("UNQUNQNO", columnArray[2]);
    		columnInfo.put("BDSBDSNO", columnArray[3]);
    		columnInfo.put("BDSBDSNM", columnArray[4]);
    		columnInfo.put("JUMJUMCD", columnArray[5]);
    		columnInfo.put("JUMJUMNM", columnArray[6]);
    		columnInfo.put("GETGETDT", columnArray[7]);
    		columnInfo.put("PRSBOKAM", columnArray[8]);
    		columnInfo.put("RPYCHDAM", columnArray[9]);
    		columnInfo.put("NEYNEYVL", columnArray[10]);
    		columnInfo.put("CSCASTAM", columnArray[11]);
    		columnInfo.put("GJGGJGAM", columnArray[12]);

    		gdRes.addValue("SELECTED", "0");
    		gdRes.addValue("JUMJUMNM", columnInfo.get("JUMJUMNM"));
    		gdRes.addValue("BDSBDSCD", columnInfo.get("BDSBDSNO"));
    		gdRes.addValue("BDSBDSNM", columnInfo.get("BDSBDSNM"));
    		gdRes.addValue("GETGETDT", columnInfo.get("GETGETDT"));
    		gdRes.addValue("PRSBOKAM", columnInfo.get("PRSBOKAM"));
    		gdRes.addValue("RPYCHDAM", columnInfo.get("RPYCHDAM"));
    		gdRes.addValue("NEYNEYVL", columnInfo.get("NEYNEYVL"));
    		gdRes.addValue("ASTASTGB", columnInfo.get("ASTASTGB"));
    		gdRes.addValue("ASTASTNM", columnInfo.get("ASTASTNM"));
    		gdRes.addValue("UNQUNQNO", columnInfo.get("UNQUNQNO"));
    	}
    	
    	return gdRes;
    }

	private GridData getEps0020(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData gdRes        = new GridData();
	    String   gdResMessage = "";
	    String   result       = null;
	    boolean  isStatus     = true;
	
	    try{
	    	gdRes  = OperateGridData.cloneResponseGridData(gdReq);
	    	result = this.getEps0020Webservice(gdReq, info);
	    	gdRes  = this.getEps0020GdRes(gdRes, result);
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