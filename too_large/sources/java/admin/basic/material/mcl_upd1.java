package admin.basic.material;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class mcl_upd1 extends HttpServlet{
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
    		
    		if("doData".equals(mode)){ // 저장 샘플
    			gdRes = this.doData(gdReq, info);
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
	private Map<String, Object> doDataSvcParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, Object>       result       = new HashMap<String, Object>();
    	Map<String, Object>       allData      = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String>       gridDataInfo = null;
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       header       = MapUtils.getMap(allData, "headerData");
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	String                    id           = info.getSession("ID");
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    mclass1      = header.get("mclass1");
    	String                    use          = null;
    	String                    type         = null;
    	String                    control      = null;
    	String                    loc          = null;
    	String                    eng          = null;
    	String                    text5        = null;
    	String                    text6        = null;
    	String                    text7        = null;
    	String                    class1       = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		use      = gridInfo.get("use");
    		type     = gridInfo.get("type");
    		control  = gridInfo.get("control");
    		loc      = gridInfo.get("loc");
    		eng      = gridInfo.get("eng");
    		text5    = gridInfo.get("text5");
    		text6    = gridInfo.get("text6");
    		text7    = gridInfo.get("text7");
    		class1   = gridInfo.get("class");
    		
    		gridDataInfo.put("CHANGE_USER_ID", id);
    		gridDataInfo.put("USE_FLAG",       use);
    		gridDataInfo.put("TEXT3",          type);
    		gridDataInfo.put("TEXT4",          control);
    		gridDataInfo.put("TEXT2",          loc);
    		gridDataInfo.put("TEXT1",          eng);
    		gridDataInfo.put("TEXT5",          text5);
    		gridDataInfo.put("TEXT6",          text6);
    		gridDataInfo.put("TEXT7",          text7);
    		gridDataInfo.put("TYPE",           mclass1);
    		gridDataInfo.put("HOUSE_CODE",     houseCode);
    		gridDataInfo.put("CODE",           class1);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	result.put("gridData", gridData);
    	
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Map<String, Object> svcParam    = this.doDataSvcParam(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p6024", "TRANSACTION", "mcl_setUpdate", obj);
    		
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