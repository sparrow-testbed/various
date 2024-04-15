package ict.admin.basic.material;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mty_wk_ins1_ict extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {Logger.debug.println();}
	    
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	this.doPost(req, res);
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
    	SepoaInfo   info  = sepoa.fw.ses.SepoaSession.getAllValue(req);
    	GridData    gdReq = null;
    	GridData    gdRes = new GridData();
    	String      mode  = null;
    	PrintWriter out   = null;
    	
    	req.setCharacterEncoding("UTF-8");
    	res.setContentType("text/html;charset=UTF-8");
    	
    	out = res.getWriter();

    	try {
    		gdReq = OperateGridData.parse(req, res);
    		mode = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("getCode".equals(mode)){ 
    			gdRes = this.getCode(gdReq, info);
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

	private GridData getCode(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes     = new GridData();
	    SepoaOut            value     = null;
	    SepoaFormater       sf        = null;
	    Map<String, String> header    = new HashMap<String, String>();
	    String              type      = gdReq.getParam("type");
	    String              itemType  = gdReq.getParam("item_type");
	    String              message   = null;
	    String              houseCode = info.getSession("HOUSE_CODE");
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	    	
	    	header.put("type",       type);
	    	header.put("item_type",  itemType);
	    	header.put("house_code", houseCode);
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "I_p6024", "CONNECTION", "mty_checkItem", obj);
	    	
	    	sf = new SepoaFormater(value.result[0]);
	    	
	    	message = sf.getValue("CNT", 0);
	    	
	    	gdRes.setMessage(message);
	    	gdRes.setStatus(Boolean.toString(value.flag));
	    }
	    catch (Exception e){
	    	gdRes.setMessage("-1");
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}