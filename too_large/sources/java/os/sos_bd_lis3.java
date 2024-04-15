package os;

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

public class sos_bd_lis3 extends HttpServlet{
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
    		
    		if("selectSoList".equals(mode)){
    			gdRes = this.selectSoList(gdReq, info);
    		}
    		else if("updateComplete".equals(mode)){
    			gdRes = this.updateComplete(gdReq, info);
    		}
    		else if("updateUnComplete".equals(mode)){
    			gdRes = this.updateUnComplete(gdReq, info);
    		}
    		else if("updateReject".equals(mode)){
    			gdRes = this.updateReject(gdReq, info);
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
    
    @SuppressWarnings({ "rawtypes", "unchecked"})
	private HashMap getMessage(SepoaInfo info) throws Exception{
    	HashMap result = null;
    	Vector  v      = new Vector();
    	
    	v.addElement("MESSAGE");
    	
    	result = MessageUtil.getMessage(info, v);
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked" })
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked"})
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
    
    private Object[] selectSoListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result     = new Object[1];
    	Map<String, String> header     = this.getHeader(gdReq, info);
    	String              houseCode  = info.getSession("HOUSE_CODE");
    	String              startDate  = header.get("startDate");
    	String              endDate    = header.get("endDate");
    	
    	startDate = SepoaString.getDateUnSlashFormat(startDate);
    	endDate   = SepoaString.getDateUnSlashFormat(endDate);
    	
    	header.put("HOUSE_CODE", houseCode);
    	header.put("startDate",  startDate);
    	header.put("endDate",    endDate);
    	
    	result[0] = header;
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
	private GridData selectSoList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaFormater       sf               = null;
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String[]            gridColAry       = null;
	    String              colKey           = null;
	    String              colValue         = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    int                 rowCount         = 0;
	    int                 gridColAryLength = 0;
	    int                 i                = 0;
	    int                 k                = 0;
	    boolean             isStatus         = false;
	
	    try{
	    	message          = this.getMessage(info);
	    	obj              = this.selectSoListObj(gdReq, info);
	    	gridColAry       = this.getGridColArray(gdReq);
	    	gridColAryLength = gridColAry.length;
	    	gdRes            = OperateGridData.cloneResponseGridData(gdReq);
	    	value            = ServiceConnector.doService(info, "os_006", "CONNECTION", "selectSoList", obj);
	    	isStatus         = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		for(i = 0; i < rowCount; i++){
			    		for(k = 0; k < gridColAryLength; k++){
			    			colKey   = gridColAry[k];
			    			colValue = sf.getValue(colKey, i);
			    			
			    			//gdRes.addValue(colKey, colValue);
			    						    			
			    			if(gridColAry[k] != null && gridColAry[k].equals( "ATTACH_NO" ) ) {
		                    	gdRes.addValue(colKey,"<img src='/images/icon/icon_search.gif'/> " + sf.getValue("ATTACH_CNT", i));								
		                    }else {
		    					gdRes.addValue(colKey, colValue );
		    				}
			    			
			    			
			    		}
			    	}
		    	}
		    	
		    	gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch(Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
    
    private Object[] updateCompleteObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
//    	Map<String, String>       hdInfo = null;
    	List<Map<String, String>> grid         = this.getGrid(gdReq, info);
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    id           = info.getSession("ID");
    	String                    osqNo        = null;
    	String                    osqCount     = null;
//    	long                    longTtlAmt    = 0;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		osqNo    = gridInfo.get("OSQ_NO");
    		osqCount = gridInfo.get("OSQ_COUNT");
    		
//    		longTtlAmt += Long.parseLong( gridInfo.get("ITEM_AMT") );
    		
    		
    		gridDataInfo.put("OSQ_FLAG",       "C");
    		gridDataInfo.put("HOUSE_CODE",     houseCode);
    		gridDataInfo.put("OSQ_NO",         osqNo);
    		gridDataInfo.put("OSQ_COUNT",      osqCount);
    		gridDataInfo.put("CHANGE_USER_ID", id);
    		gridDataInfo.put("SETTLE_FLAG",    "Y");
    		
    		gridData.add(gridDataInfo);
    	}
    	
//    	hdInfo.put("TTL_AMT", String.valueOf(longTtlAmt));
    	
    	
    	resultInfo.put("gridData", gridData);
//    	resultInfo.put("hdInfo", hdInfo);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData updateComplete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	
    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		message  = this.getMessage(info);
    		obj      = this.updateCompleteObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_006", "TRANSACTION", "updateComplete", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = (String)message.get("MESSAGE.0001"); 
    		}
    		else {
    			gdResMessage = value.message;
    		}
    	}
    	catch(Exception e){
    		isStatus     = false;
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    private Object[] updateUnCompleteObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
    	List<Map<String, String>> grid         = this.getGrid(gdReq, info);
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    id           = info.getSession("ID");
    	String                    osqNo        = null;
    	String                    osqCount     = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		osqNo    = gridInfo.get("OSQ_NO");
    		osqCount = gridInfo.get("OSQ_COUNT");
    		
    		gridDataInfo.put("OSQ_FLAG",       "E");
    		gridDataInfo.put("HOUSE_CODE",     houseCode);
    		gridDataInfo.put("OSQ_NO",         osqNo);
    		gridDataInfo.put("OSQ_COUNT",      osqCount);
    		gridDataInfo.put("CHANGE_USER_ID", id);
    		gridDataInfo.put("SETTLE_FLAG",    "N");
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData updateUnComplete(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	
    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		message  = this.getMessage(info);
    		obj      = this.updateUnCompleteObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_006", "TRANSACTION", "updateUnComplete", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = (String)message.get("MESSAGE.0001"); 
    		}
    		else {
    			gdResMessage = value.message;
    		}
    	}
    	catch(Exception e){
    		isStatus     = false;
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData updateReject(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;
    	
    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		message  = this.getMessage(info);
    		obj      = this.updateRejectObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_006", "TRANSACTION", "updateReject", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = (String)message.get("MESSAGE.0001"); 
    		}
    		else {
    			gdResMessage = value.message;
    		}
    	}
    	catch(Exception e){
    		isStatus     = false;
    		gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
    

    private Object[] updateRejectObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
    	List<Map<String, String>> grid         = this.getGrid(gdReq, info);
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    id           = info.getSession("ID");
    	String                    osqNo        = null;
    	String                    osqCount     = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo = grid.get(i);
    		osqNo    = gridInfo.get("OSQ_NO");
    		osqCount = gridInfo.get("OSQ_COUNT");
    		
    		gridDataInfo.put("OSQ_FLAG",       "R");
    		gridDataInfo.put("HOUSE_CODE",     houseCode);
    		gridDataInfo.put("OSQ_NO",         osqNo);
    		gridDataInfo.put("OSQ_COUNT",      osqCount);
    		gridDataInfo.put("CHANGE_USER_ID", id);
    		gridDataInfo.put("SETTLE_FLAG",    "N");
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
}