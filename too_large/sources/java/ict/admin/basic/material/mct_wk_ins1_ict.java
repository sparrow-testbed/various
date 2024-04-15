package ict.admin.basic.material;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mct_wk_ins1_ict extends HttpServlet{
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
    		
    		if("getQuery".equals(mode)){
    			gdRes = this.getQuery(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			out.print(gdRes.getMessage());
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }

    private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	String              control     = gdReq.getParam("control");
    	String              itemControl = gdReq.getParam("item_control");
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	
    	result.put("HOUSE_CODE", houseCode);
    	result.put("TYPE",       control);
    	result.put("CODE",       itemControl);
    	
    	return result;
    }
    
	private GridData getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes    = new GridData();
	    SepoaFormater       sf       = null;
	    SepoaOut            value    = null;
	    Map<String, String> svcParam = this.getQuerySvcParam(gdReq, info);
	    String              message  = null;
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParam};
	
	    	value = ServiceConnector.doService(info, "I_p6024", "CONNECTION", "mct_checkItem", obj);
	    	
	    	sf = new SepoaFormater(value.result[0]);
	
	    	message = sf.getValue("CNT", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("N");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}