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

public class sos_bd_lis1 extends HttpServlet{
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
    		
    		if("getOsList".equals(mode)){
    			gdRes = this.getOsList(gdReq, info);
    		}
    		else if("deleteSos".equals(mode)){
    			gdRes = this.deleteSos(gdReq, info);
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
    
    private Object[] requestListHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result          = new Object[1];
    	Map<String, String> resultInfo      = new HashMap<String, String>();
    	Map<String, String> header          = this.getHeader(gdReq, info);
    	String              houseCode       = info.getSession("HOUSE_CODE");
    	String              startChangeDate = header.get("start_change_date");
    	String              endChangeDate   = header.get("end_change_date");
    	String              osqNo           = header.get("osq_no");
    	String              subject         = header.get("subject");
    	String              changeUser      = header.get("ctrl_person_id");
    	String              osqFlag         = header.get("osq_flag");
    	
    	startChangeDate = SepoaString.getDateUnSlashFormat(startChangeDate);
    	endChangeDate   = SepoaString.getDateUnSlashFormat(endChangeDate);
    	
    	resultInfo.put("HOUSE_CODE",        houseCode);
    	resultInfo.put("start_change_date", startChangeDate);
    	resultInfo.put("end_change_date",   endChangeDate);
    	resultInfo.put("osq_no",            osqNo);
    	resultInfo.put("subject",           subject);
    	resultInfo.put("ctrl_person_id",    changeUser);
    	resultInfo.put("osq_flag",          osqFlag);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private GridData getOsListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
    	SepoaFormater sf               = new SepoaFormater(value.result[0]);
    	String[]      gridColAry       = this.getGridColArray(gdReq);
    	String        colKey           = null;
	    String        colValue         = null;
		int           rowCount         = sf.getRowCount();
		int           i                = 0;
		int           k                = 0;
		int           gridColAryLength = gridColAry.length;

    	if(rowCount != 0){
    		for(i = 0; i < rowCount; i++){
	    		for(k = 0; k < gridColAryLength; k++){
	    			colKey   = gridColAry[k];
	    			colValue = sf.getValue(colKey, i);
	    			
	    			if("SEL".equals(colKey)){
	    				gdRes.addValue("SEL", "0");
	    			}
	    			else{
	    				gdRes.addValue(colKey, colValue);
	    			}
	    		}
	    	}
    	}
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes"})
	private GridData getOsList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    boolean             isStatus         = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.requestListHeader(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "os_002", "CONNECTION", "getOsList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.getOsListGdRes(gdReq, gdRes, value);
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
	
	private Object[] deleteSosObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result      = new Object[1];
		Map<String, Object>       resultInfo  = new HashMap<String, Object>();
		Map<String, String>       gridInfo    = null;
		Map<String, String>       gridDatInfo = null;
		List<Map<String, String>> grid        = this.getGrid(gdReq, info);
		List<Map<String, String>> gridData    = new ArrayList<Map<String, String>>();
		String                    houseCode   = info.getSession("HOUSE_CODE");
		String                    osqNo       = null;
		String                    osqCount    = null;
		int                       gridSize    = grid.size();
		int                       i           = 0;
		
		for(i = 0; i < gridSize; i++){
			gridDatInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			osqNo    = gridInfo.get("OSQ_NO");
			osqCount = gridInfo.get("OSQ_COUNT");
			
			gridDatInfo.put("HOUSE_CODE", houseCode);
			gridDatInfo.put("OSQ_NO",     osqNo);
			gridDatInfo.put("OSQ_COUNT",  osqCount);
			
			gridData.add(gridDatInfo);
		}
		
		resultInfo.put("gridData", gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData deleteSos(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.deleteSosObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_002", "TRANSACTION", "deleteSos", obj);
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
}