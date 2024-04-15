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

public class mcl_lis2 extends HttpServlet{
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
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getQuerySvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result      = new HashMap<String, String>();
    	Map<String, Object> allData     = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String> header      = MapUtils.getMap(allData, "headerData");
    	String              itemType    = header.get("item_type");
    	String              itemControl = header.get("item_control");
    	String              itemClass1  = header.get("item_class1");
    	String              mClass2     = header.get("mclass2");
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	
    	result.put("text3",      itemType);
    	result.put("text4",      itemControl);
    	result.put("text5",      itemClass1);
    	result.put("house_code", houseCode);
    	result.put("type",       mClass2);
    	
    	return result;
    }
    
    private GridData getQueryAddValue(GridData gdRes, SepoaFormater sf) throws Exception{
    	int i        = 0;
    	int rowCount = sf.getRowCount();
    	
    	for (i = 0; i < rowCount; i++){
			gdRes.addValue("check",        "0");
			gdRes.addValue("use",          "Y");
			gdRes.addValue("type",         sf.getValue("text3", i));
			gdRes.addValue("type_name",    sf.getValue("text3_name", i));
			gdRes.addValue("pop1",         "");
			gdRes.addValue("control",      sf.getValue("text4", i));
			gdRes.addValue("control_name", sf.getValue("text4_name", i));
			gdRes.addValue("pop2",         "");
			gdRes.addValue("class1",       sf.getValue("text5", i));
			gdRes.addValue("class1_name",  sf.getValue("text5_name", i));
			gdRes.addValue("pop3",         "");
			gdRes.addValue("class2",       sf.getValue("code", i));
			gdRes.addValue("loc",          sf.getValue("text2", i));
			gdRes.addValue("eng",          sf.getValue("text1", i));
			gdRes.addValue("text6",        sf.getValue("text6", i));
			gdRes.addValue("text7",        sf.getValue("text7", i));
			gdRes.addValue("add_ncy",      "Y");
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private GridData getQuery(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes    = new GridData();
	    SepoaFormater       sf       = null;
	    SepoaOut            value    = null;
	    Vector              v        = new Vector();
	    HashMap             message  = null;
	    Map<String, String> svcParam = this.getQuerySvcParam(gdReq, info);
	    int                 rowCount = 0;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	gdRes = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {svcParam};
	
	    	value = ServiceConnector.doService(info, "p6024", "CONNECTION","mcl_getMainternace2", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		gdRes = this.getQueryAddValue(gdRes, sf);
		    	}
	    	}
	    	else{
	    		gdRes.setMessage(value.message);
	    		gdRes.setStatus("false");
	    	}
	    }
	    catch (Exception e){
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
}