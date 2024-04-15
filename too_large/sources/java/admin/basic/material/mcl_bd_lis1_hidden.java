package admin.basic.material;

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

public class mcl_bd_lis1_hidden extends HttpServlet{
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
    		
    		if("getQuery".equals(mode)){ // 조회 샘플
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
    	Map<String, String> result    = new HashMap<String, String>();
    	String              type      = null;
    	String              itemCode  = null;
    	String              houseCode = info.getSession("HOUSE_CODE");
    	
    	type     = gdReq.getParam("type");
    	itemCode = gdReq.getParam("item_type");
    	
    	result.put("ITEM_CODE",  itemCode);
    	result.put("HOUSE_CODE", houseCode);
    	result.put("TYPE",       type);
    	
    	return result;
    }

	private GridData getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes       = new GridData();
	    SepoaFormater       sf          = null;
	    SepoaOut            value       = null;
	    Map<String, String> svcParam    = this.getQuerySvcParam(gdReq, info);
	    String              classString = null;
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParam};
	
	    	value = ServiceConnector.doService(info, "p6024", "CONNECTION", "getMaxClass", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setStatus("true");
	    		
	    		sf = new SepoaFormater(value.result[0]);
	    		
	    		classString = sf.getValue("CLASS", 0);
	    		
	    		gdRes.setMessage(classString);
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}