package sepoa.svc.common;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

/**
 * Servlet implementation class HldyServlet
 */
public class HldyInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public void init(ServletConfig config) throws ServletException {}
       
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	doPost(req, res);
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
    		
    		if("isHldy".equals(mode)){ // 문서 파기
    			gdRes  = this.isHldy(gdReq, info);
    			isJson = true;
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
    
    private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	
    	
    	result.put("HOUSE_CODE",   houseCode);
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData isHldy(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes   = new GridData();
	    SepoaOut            value   = null;
	    SepoaFormater       sf      = null;
	    Map<String, String> svcParm = this.getQuerySvcParam(gdReq, info);
	    String              message = null;
	    int rowCount = 0;
        
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParm};
	
	    	value   = ServiceConnector.doService(info, "HldyInfoService", "CONNECTION","isHldy", obj);
	    	sf = new SepoaFormater(value.result[0]);
	    	
	    	rowCount = sf.getRowCount();
			
			if (rowCount == 0) {
				gdRes.setMessage("-1");
				gdRes.setStatus("false");
				return gdRes;
			}
	    	
	    	message = sf.getValue("HLDY_DSCD", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("-999");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
    
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	private Object[] isHldyObj(GridData gdReq, SepoaInfo info) throws Exception{
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
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


}
