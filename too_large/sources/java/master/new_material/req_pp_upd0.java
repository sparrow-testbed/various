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

public class req_pp_upd0 extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {
		Logger.debug.println();
	}
	    
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
    
    private Map<String, String> doDataHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result            = new HashMap<String, String>();
    	String              descriptionLoc    = JSPUtil.nullToEmpty(gdReq.getParam("DESCRIPTION_LOC"));	
    	String              specification     = JSPUtil.nullToEmpty(gdReq.getParam("SPECIFICATION"));	
    	String              makerFlag         = JSPUtil.nullToEmpty(gdReq.getParam("MAKER_FLAG"));
    	String              makerCode         = JSPUtil.nullToEmpty(gdReq.getParam("MAKER_CODE"));
    	String              makerName         = JSPUtil.nullToEmpty(gdReq.getParam("MAKER_NAME")); 
    	String              zItemDesc         = JSPUtil.nullToEmpty(gdReq.getParam("Z_ITEM_DESC"));
    	String              remark            = JSPUtil.nullToEmpty(gdReq.getParam("REMARK"));
    	String              itemAbbreviation  = JSPUtil.nullToEmpty(gdReq.getParam("ITEM_ABBREVIATION"));
    	String              basicUnit         = JSPUtil.nullToEmpty(gdReq.getParam("BASIC_UNIT"));
    	String              appTaxCode        = JSPUtil.nullToEmpty(gdReq.getParam("APP_TAX_CODE"));
    	String              itemBlockFlag     = JSPUtil.nullToEmpty(gdReq.getParam("ITEM_BLOCK_FLAG"));
    	String              modelFlag         = JSPUtil.nullToEmpty(gdReq.getParam("MODEL_FLAG"));
    	String              modelNo           = JSPUtil.nullToEmpty(gdReq.getParam("MODEL_NO"));
    	String              attachNo          = JSPUtil.nullToEmpty(gdReq.getParam("ATTACH_NO"));
    	String              reqItemNo         = JSPUtil.nullToEmpty(gdReq.getParam("REQ_ITEM_NO"));
    	String              makeAmtCode       = JSPUtil.nullToEmpty(gdReq.getParam("MAKE_AMT_CODE"));
    	String              houseCode         = info.getSession("HOUSE_CODE");
    	String              id                = info.getSession("ID");
    	
    	result.put("DESCRIPTION_LOC",   descriptionLoc);
    	result.put("BASIC_UNIT",        basicUnit);
    	result.put("Z_ITEM_DESC",       zItemDesc);
    	result.put("ITEM_ABBREVIATION", itemAbbreviation);
    	result.put("IMAGE_FILE_PATH",   "");
    	result.put("ITEM_GROUP",        "");
    	result.put("Z_PURCHASE_TYPE",   "");
    	result.put("SPECIFICATION",     specification);
    	result.put("MAKER_CODE",        makerCode);
    	result.put("MAKER_NAME",        makerName);
    	result.put("REMARK",            remark);
    	result.put("APP_TAX_CODE",      appTaxCode);
    	result.put("DELIVERY_LT",       "");
    	result.put("MARKET_TYPE",       "");
    	result.put("ITEM_BLOCK_FLAG",   itemBlockFlag);
    	result.put("MAKER_FLAG",        makerFlag);
    	result.put("MODEL_FLAG",        modelFlag);
    	result.put("MODEL_NO",          modelNo);
    	result.put("ATTACH_NO",         attachNo);
    	result.put("USER_ID",           id);
    	result.put("HOUSE_CODE",        houseCode);
    	result.put("REQ_ITEM_NO",       reqItemNo);
    	result.put("MAKE_AMT_CODE",     makeAmtCode);
    		
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, String> data        = this.doDataHeader(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		Object[] obj = {data};
    		
    		value = ServiceConnector.doService(info, "t0002", "TRANSACTION", "real_upd1_setInsert3", obj);
    		
    		if(value.flag) {
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
}