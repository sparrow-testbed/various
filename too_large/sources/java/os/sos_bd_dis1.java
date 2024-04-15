package os;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
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

public class sos_bd_dis1 extends HttpServlet{
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
    		
    		if("getSosglInfo".equals(mode)){
    			gdRes = this.getSosglInfo(gdReq, info);
    		}
    		else if("getSoslnList".equals(mode)){
    			gdRes = this.getSoslnList(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("getSosglInfo".equals(mode)){
    				out.println(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
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
    
    @SuppressWarnings({ "unchecked" })
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings({ "unchecked", "unused" })
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
    	Object[]            result     = new Object[1];
    	Map<String, String> resultInfo = new HashMap<String, String>();
    	String              houseCode  = info.getSession("HOUSE_CODE");
    	String              osqNo      = gdReq.getParam("OSQ_NO");
    	String              osqCount   = gdReq.getParam("OSQ_COUNT");
    	
    	resultInfo.put("HOUSE_CODE", houseCode);
    	resultInfo.put("OSQ_NO",     osqNo);
    	resultInfo.put("OSQ_COUNT",  osqCount);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private String getOsListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
    	SepoaFormater sf               = new SepoaFormater(value.result[0]);
    	String[]      gridColAry       = {"SUBJECT", "OSQ_DATE", "ATTACH_NO", "ATT_COUNT", "REMARK"};
    	String        colKey           = null;
	    String        colValue         = null;
	    String        result           = null;
	    StringBuffer  stringBuffer     = new StringBuffer();
		int           rowCount         = sf.getRowCount();
		int           i                = 0;
		int           k                = 0;
		int           gridColAryLength = gridColAry.length;

    	if(rowCount != 0){
    		for(i = 0; i < rowCount; i++){
	    		for(k = 0; k < gridColAryLength; k++){
	    			colKey   = gridColAry[k];
	    			colValue = sf.getValue(colKey, i);
	    			
	    			stringBuffer.append(colValue);
	    			
	    			if(k != (gridColAryLength - 1)){
	    				stringBuffer.append("@@");
	    			}
	    		}
	    	}
    	}
    	
    	result = stringBuffer.toString();
    	
    	return result;
    }

	@SuppressWarnings({ "rawtypes"})
	private GridData getSosglInfo(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	value    = ServiceConnector.doService(info, "os_003", "CONNECTION", "getSosglInfo", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
		    	gdResMessage = this.getOsListGdRes(gdReq, gdRes, value);
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
	
	private Object[] getSoslnListObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result     = new Object[1];
		Map<String, String> resultInfo = new HashMap<String, String>();
		Map<String, String> header     = this.getHeader(gdReq, info);
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              osqNo      = header.get("osqNo");
		String              osqCount   = header.get("osqCount");
		
		resultInfo.put("HOUSE_CODE", houseCode);
		resultInfo.put("OSQ_NO",     osqNo);
		resultInfo.put("OSQ_COUNT",  osqCount);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	private GridData getSoslnListGdRes(GridData gdReq, GridData gdRes, SepoaOut value) throws Exception{
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
	private GridData getSoslnList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    boolean             isStatus         = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.getSoslnListObj(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "os_003", "CONNECTION", "getSoslnList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.getSoslnListGdRes(gdReq, gdRes, value);
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
}