package ict.admin.basic.material;

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

public class mcl_ins2_ict extends HttpServlet{
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
    			OperateGridData.write(req, res, gdRes, out);
    		}
    		catch (Exception e) {
    			Logger.debug.println();
    		}
    	}
    }
    
    @SuppressWarnings("unchecked")
	private Object[] doDataMclSetInsert2Param(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, Object>       data         = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String>       header       = MapUtils.getMap(data, "headerData");
    	Map<String, String>       gridDataInfo = null;
    	Map<String, String>       gridInfo     = null;
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    id           = info.getSession("ID");
    	String                    mclass2      = header.get("mclass2");
    	String                    class2       = null;
    	String                    use          = null;
    	String                    eng          = null;
    	String                    loc          = null;
    	String                    type         = null;
    	String                    control      = null;
    	String                    class1       = null;
    	String                    text6        = null;
    	String                    text7        = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		class2   = gridInfo.get("class2");
    		use      = gridInfo.get("use");
    		eng      = gridInfo.get("eng");
    		loc      = gridInfo.get("loc");
    		type     = gridInfo.get("type");
    		control  = gridInfo.get("control");
    		class1   = gridInfo.get("class1");
    		text6    = gridInfo.get("text6");
    		text7    = gridInfo.get("text7");
    		
    		gridDataInfo.put("HOUSE_CODE", houseCode);
    		gridDataInfo.put("TYPE",       mclass2);
    		gridDataInfo.put("CODE",       class2);
    		gridDataInfo.put("USER_ID",    id);
    		gridDataInfo.put("USE_FLAG",   use);
    		gridDataInfo.put("TEXT1",      eng);
    		gridDataInfo.put("TEXT2",      loc);
    		gridDataInfo.put("TEXT3",      type);
    		gridDataInfo.put("TEXT4",      control);
    		gridDataInfo.put("TEXT5",      class1);
    		gridDataInfo.put("TEXT6",      text6);
    		gridDataInfo.put("TEXT7",      text7);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private Object[] doDataAreaSetInsertParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, Object>       data         = SepoaDataMapper.getData(info, gdReq);
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    companyCode  = info.getSession("COMPANY_CODE");
    	String                    id           = info.getSession("ID");
    	String                    class2       = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		class2   = gridInfo.get("class2");
    		
    		gridDataInfo.put("MATERIAL_CLASS1",   class2);
    		gridDataInfo.put("PURCHASE_LOCATION", "01");
    		gridDataInfo.put("CTRL_TYPE",         "P");
    		gridDataInfo.put("CTRL_CODE",         "P01");
    		gridDataInfo.put("COMPANY_CODE",      companyCode);
    		gridDataInfo.put("ADD_USER_ID",       id);
    		gridDataInfo.put("HOUSE_CODE",        houseCode);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes              = new GridData();
    	Vector   multilangId        = new Vector();
    	HashMap  message            = null;
    	SepoaOut value              = null;
    	Object[] setInsert2Param    = this.doDataMclSetInsert2Param(gdReq, info);
    	Object[] areaSetInsertParam = this.doDataAreaSetInsertParam(gdReq, info);
    	
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		value = ServiceConnector.doService(info, "I_p6024", "TRANSACTION", "mcl_setInsert2", setInsert2Param);
    		value = ServiceConnector.doService(info, "I_p6024", "TRANSACTION", "Area_setInsert", areaSetInsertParam);
    		
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