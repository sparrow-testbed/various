package admin.basic.material;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;

import sepoa.fw.log.Logger;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaFormater;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mcl_wk_ins2 extends HttpServlet{
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
    
	private Map<String, String> getQeurySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result    = new HashMap<String, String>();
    	String              houseCode = info.getSession("HOUSE_CODE");
    	String              mclass2   = gdReq.getParam("mclass2");
    	String              itemClass = gdReq.getParam("item_class");
    	
    	result.put("house_code", houseCode);
    	result.put("type",       mclass2);
    	result.put("code",       itemClass);
    	
    	return result;
    }

	private GridData getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes    = new GridData();
	    SepoaFormater       sf       = null;
	    SepoaOut            value    = null;
	    String              message  = null;
	    Map<String, String> svcParam = this.getQeurySvcParam(gdReq, info);
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	
	    	Object[] obj = {svcParam};
		
	    	value = ServiceConnector.doService(info, "p6024", "CONNECTION", "mcl_checkItem2", obj);
	    	
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