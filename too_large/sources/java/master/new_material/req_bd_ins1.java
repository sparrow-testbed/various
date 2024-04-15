package master.new_material;

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

import sepoa.fw.log.Logger;
import sepoa.fw.msg.MessageUtil;
import sepoa.fw.ses.SepoaInfo;
import sepoa.fw.srv.SepoaOut;
import sepoa.fw.srv.ServiceConnector;
import sepoa.fw.util.JSPUtil;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class req_bd_ins1 extends HttpServlet{
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
    		
    		if("doData".equals(mode)){
    			gdRes = this.doData(gdReq, info);
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
    
    private Map<String, String> getSvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result               = new HashMap<String, String>();
    	String              house_code           = info.getSession("HOUSE_CODE");
    	String              DESCRIPTION_LOC      = this.nvl(gdReq.getParam("DESCRIPTION_LOC"));	
    	String              SPECIFICATION        = this.nvl(gdReq.getParam("SPECIFICATION"));
    	String              MAKER_FLAG           = this.nvl(gdReq.getParam("MAKER_FLAG"));
    	String              MAKER_CODE           = this.nvl(gdReq.getParam("MAKER_CODE"));
    	String              MAKER_NAME           = this.nvl(gdReq.getParam("MAKER_NAME")); 
    	String              Z_ITEM_DESC          = this.nvl(gdReq.getParam("Z_ITEM_DESC"));
    	String              REMARK               = this.nvl(gdReq.getParam("REMARK"));
    	String              MATERIAL_TYPE        = this.nvl(gdReq.getParam("MATERIAL_TYPE"));
    	String              MATERIAL_CTRL_TYPE   = this.nvl(gdReq.getParam("MATERIAL_CTRL_TYPE"));
    	String              MATERIAL_CLASS1      = this.nvl(gdReq.getParam("MATERIAL_CLASS1"));
    	String              MATERIAL_CLASS2      = this.nvl(gdReq.getParam("MATERIAL_CLASS2")); 
    	String              ITEM_ABBREVIATION    = this.nvl(gdReq.getParam("ITEM_ABBREVIATION"));
    	String              BASIC_UNIT           = this.nvl(gdReq.getParam("BASIC_UNIT"));
    	String              APP_TAX_CODE         = this.nvl(gdReq.getParam("APP_TAX_CODE"));
    	String              ITEM_BLOCK_FLAG      = this.nvl(gdReq.getParam("ITEM_BLOCK_FLAG"));
    	String              MODEL_FLAG           = this.nvl(gdReq.getParam("MODEL_FLAG"));
    	String              MODEL_NO             = this.nvl(gdReq.getParam("MODEL_NO"));
    	String              REQ_USER_ID          = this.nvl(gdReq.getParam("REQ_USER_ID"));
    	String              ADD_USER_ID          = this.nvl(gdReq.getParam("ADD_USER_ID"));
    	String              ADD_USER_NAME_LOC    = this.nvl(gdReq.getParam("ADD_USER_NAME_LOC"));
    	String              CHANGE_USER_ID       = this.nvl(gdReq.getParam("CHANGE_USER_ID"));
    	String              CHANGE_USER_NAME_LOC = this.nvl(gdReq.getParam("CHANGE_USER_NAME_LOC"));
    	String              ATTACH_NO            = this.nvl(gdReq.getParam("ATTACH_NO"));
    	String              MAKE_AMT_CODE        = this.nvl(gdReq.getParam("MAKE_AMT_CODE"));
    	
    	result.put("house_code",           house_code);
    	result.put("MATERIAL_TYPE",        MATERIAL_TYPE);
    	result.put("MATERIAL_CTRL_TYPE",   MATERIAL_CTRL_TYPE);
    	result.put("MATERIAL_CLASS1",      MATERIAL_CLASS1);
    	result.put("MATERIAL_CLASS2",      MATERIAL_CLASS2);
    	result.put("DESCRIPTION_LOC",      DESCRIPTION_LOC);
    	result.put("SPECIFICATION",        SPECIFICATION);
    	result.put("ITEM_ABBREVIATION",    ITEM_ABBREVIATION);
    	result.put("BASIC_UNIT",           BASIC_UNIT);
    	result.put("APP_TAX_CODE",         APP_TAX_CODE);
    	result.put("ITEM_BLOCK_FLAG",      ITEM_BLOCK_FLAG);
    	result.put("MAKER_NAME",           MAKER_NAME);
    	result.put("MAKER_CODE",           MAKER_CODE);
    	result.put("Z_ITEM_DESC",          Z_ITEM_DESC);
    	result.put("REMARK",               REMARK);
    	result.put("MAKER_FLAG",           MAKER_FLAG);
    	result.put("MODEL_FLAG",           MODEL_FLAG);
    	result.put("MODEL_NO",             MODEL_NO);
    	result.put("ATTACH_NO",            ATTACH_NO);
    	result.put("REQ_USER_ID",          REQ_USER_ID);
    	result.put("ADD_USER_ID",          ADD_USER_ID);
    	result.put("ADD_USER_NAME_LOC",    ADD_USER_NAME_LOC);
    	result.put("CHANGE_USER_ID",       CHANGE_USER_ID);
    	result.put("CHANGE_USER_NAME_LOC", CHANGE_USER_NAME_LOC);
    	result.put("MAKE_AMT_CODE",        MAKE_AMT_CODE);
    	
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, String> svcParam    = this.getSvcParam(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "t0002", "TRANSACTION","req_setInsert", obj);
    		
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    	}
    	catch(Exception e){
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
    
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
}