package ev;

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
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class evmaster_mst extends HttpServlet{
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
    		else if("insert".equals(mode)){
    			gdRes = this.insert(gdReq, info);
    		}
    		else if("delete".equals(mode)){
    			gdRes = this.delete(gdReq, info);
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
    		catch (Exception e) {Logger.debug.println();}
    		
    	}
    }
    
    
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
    private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    private Object[] getCatalogObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result = new Object[1];
    	Map<String, String> header = this.getHeader(gdReq, info);
    	
    	result[0] = header;
    	
    	return result;
    }
    
    private GridData queryGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
    	String[]            gridColAry       = this.getGridColArray(gdReq);
    	String              colKey           = null;
	    String              colValue         = null;
    	int                 i                = 0;
	    int                 k                = 0;
	    int                 rowCount         = sf.getRowCount();
	    int                 gridColAryLength = gridColAry.length;
	    
    	for (i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			colValue = sf.getValue(colKey, i);
    			
    			if("SELECTED".equals(gridColAry[k])){
    				gdRes.addValue("SELECTED", "0");
    			}
    			else{
    				gdRes.addValue(colKey, colValue);
    			}
    		}
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes" })
	private GridData query(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    int           rowCount     = 0;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.getCatalogObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "WO_201", "TRANSACTION", "ev_query", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.queryGdRes(gdReq, gdRes, sf);
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
	
	private Object[] insertObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result       = new Object[1];
		Map<String, Object>       resultInfo   = new HashMap<String, Object>();
		Map<String, String>       gridInfo     = null;
		Map<String, String>       gridDataInfo = null;
		List<Map<String, String>> grid         = this.getGrid(gdReq, info);
		List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
		String                    id           = info.getSession("ID");
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    useFlag      = null;
		String                    name         = null;
		String                    code         = null;
		String                    addDate      = null;
		int                       gridSize     = grid.size();
		int                       i            = 0;
		
		for(i = 0; i < gridSize; i++){
			gridDataInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			useFlag  = gridInfo.get("USEFLAG");
			name     = gridInfo.get("NAME");
			code     = gridInfo.get("CODE");
			addDate  = gridInfo.get("ADD_DATE");
			
			gridDataInfo.put("USE_FLAG",    useFlag);
			gridDataInfo.put("TEXT1",       name);
			gridDataInfo.put("CODE",        code);
			gridDataInfo.put("ADD_DATE",    addDate);
			gridDataInfo.put("ADD_USER_ID", id);
			gridDataInfo.put("HOUSE_CODE",  houseCode);
			
			gridData.add(gridDataInfo);
		}
		
		resultInfo.put("gridData", gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData insert(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.insertObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "WO_201", "TRANSACTION", "ev_insert", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	private Object[] deleteObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result       = new Object[1];
		Map<String, Object>       resultInfo   = new HashMap<String, Object>();
		Map<String, String>       gridInfo     = null;
		Map<String, String>       gridDataInfo = null;
		List<Map<String, String>> grid         = this.getGrid(gdReq, info);
		List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
		String                    code         = null;
		String                    addDate      = null;
		String                    addDateYear  = null;
		int                       gridSize     = grid.size();
		int                       i            = 0;
		
		for(i = 0; i < gridSize; i++){
			gridDataInfo = new HashMap<String, String>();
			
			gridInfo    = grid.get(i);
			code        = gridInfo.get("CODE");
			addDate     = gridInfo.get("ADD_DATE");
			addDateYear = addDate.substring(0, 4);
			
			gridDataInfo.put("CODE",          code);
			gridDataInfo.put("ADD_DATE",      addDate);
			gridDataInfo.put("ADD_DATE_YEAR", addDateYear);
			
			gridData.add(gridDataInfo);
		}
		
		resultInfo.put("gridData", gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData delete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.deleteObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "WO_201", "TRANSACTION", "ev_delete", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdResMessage = value.message;
    		}
    		
    		gdRes.setSelectable(false);
    		gdRes.addParam("mode", "doSave");
    	}
    	catch(Exception e){
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    		isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
}