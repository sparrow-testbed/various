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
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mty_lis1_ict extends HttpServlet{
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
    		
    		if("query".equals(mode)){
    			gdRes = this.query(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings("rawtypes")
	private GridData queryGdRes(GridData gdRes, SepoaOut value, HashMap message) throws Exception{
    	SepoaFormater sf       = null;
    	int           rowCount = 0;
    	
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
	    			gdRes.addValue("Check",     "0");
	    			gdRes.addValue("use_flag",  "Y");
	    			gdRes.addValue("mat_code",  sf.getValue("CODE", i));
	    			gdRes.addValue("mat_name1", sf.getValue("TEXT2", i));
	    			gdRes.addValue("mat_name2", sf.getValue("TEXT1", i));
	    			gdRes.addValue("mat_name3", sf.getValue("TEXT3", i));
	    			gdRes.addValue("mat_name4", sf.getValue("TEXT4", i));
	    			gdRes.addValue("mat_name5", sf.getValue("TEXT5", i));
	    			gdRes.addValue("mat_name6", sf.getValue("TEXT6", i));
	    			gdRes.addValue("mat_name7", sf.getValue("TEXT7", i));
	    			gdRes.addValue("add_ncy",   "Y");
		    	}
	    	}
    	}
    	else{
    		gdRes.setMessage(value.message);
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData query(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes     = new GridData();
	    SepoaOut            value     = null;
	    Vector              v         = new Vector();
	    HashMap             message   = null;
	    Map<String, Object> allData   = null;
	    Map<String, String> header    = null;
	    String              houseCode = info.getSession("HOUSE_CODE");              
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData = SepoaDataMapper.getData(info, gdReq);
	    	header  = MapUtils.getMap(allData, "headerData");
	    	gdRes   = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	    	
	    	header.put("house_code", houseCode);
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "I_p6024", "CONNECTION", "mty_getMaintain", obj);
	    	gdRes = this.queryGdRes(gdRes, value, message);
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}