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

public class mcl_lis1 extends HttpServlet{
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
    	Map<String, String> header      = null;
    	Map<String, Object> allData     = SepoaDataMapper.getData(info, gdReq);
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	String              itemControl = null;
    	String              itemType    = null;
    	String              class1      = null;
    	
    	header      = MapUtils.getMap(allData, "headerData");
    	itemControl = header.get("item_control");
    	itemType    = header.get("item_type");
    	class1      = header.get("class1");
    	
    	result.put("TEXT3",      itemType);
    	result.put("TEXT4",      itemControl);
    	result.put("HOUSE_CODE", houseCode);
    	result.put("TYPE",       class1);
    	
    	return result;
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
	    	
	    	value = ServiceConnector.doService(info, "p6024", "CONNECTION","mcl_getMainternace", obj);
	
	    	if(value.flag){// 조회 성공
	    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
	    		gdRes.setStatus("true");
	    		
	    		sf= new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount(); // 조회 row 수
		
		    	if(rowCount == 0){
		    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
		    	}
		    	else{
		    		for(int i = 0; i < rowCount; i++){
		    			gdRes.addValue("check",    "0");
		    			gdRes.addValue("use",      sf.getValue("USE_FLAG", i));
		    			gdRes.addValue("type",     sf.getValue("TEXT3", i));
		    			gdRes.addValue("pop1",     "");
		    			gdRes.addValue("control",  sf.getValue("TEXT4", i));
		    			gdRes.addValue("pop2",     "");
		    			gdRes.addValue("class",    sf.getValue("CODE", i));
		    			gdRes.addValue("loc",      sf.getValue("TEXT2", i));
		    			gdRes.addValue("eng",      sf.getValue("TEXT1", i));
		    			gdRes.addValue("text5",    sf.getValue("TEXT5", i));
		    			gdRes.addValue("text6",    sf.getValue("TEXT6", i));
		    			gdRes.addValue("text7",    sf.getValue("TEXT7", i));
		    			gdRes.addValue("add_ncy",  "Y");
			    	}
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