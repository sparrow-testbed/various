package bom;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

public class ma_012 extends HttpServlet{
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
    		
    		if("doSelect".equals(mode)){
    			gdRes = this.doSelect(gdReq, info);
    		}
    		else if("doSave".equals(mode)){
    			gdRes = this.doSave(gdReq, info);
    		}
    		else if("ma012selectGl".equals(mode)){
    			gdRes = this.ma012selectGl(gdReq, info);
    		}
    		else if("ma012SelectGlList".equals(mode)){
    			gdRes = this.ma012SelectGlList(gdReq, info);
    		}
    		else if("ma012SelectLnList".equals(mode)){
    			gdRes = this.ma012SelectLnList(gdReq, info);
    		}
    		else if("ma012SelectSoslnList".equals(mode)){
    			gdRes = this.ma012SelectSoslnList(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("ma012selectGl".equals(mode)){
    				out.print(gdRes.getMessage());
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
    
    @SuppressWarnings("unchecked")
	private Map<String, String> getHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result  = null;
    	Map<String, Object> allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = MapUtils.getMap(allData, "headerData");
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
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
    
    private Map<String, String> doSelectHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result    = new HashMap<String, String>();
    	Map<String, String> header    = this.getHeader(gdReq, info);
    	String              pItemNo   = header.get("pItemNo");
    	String              seq       = header.get("seq");
    	String              houseCode = info.getSession("HOUSE_CODE");
    	
    	result.put("HOUSE_CODE", houseCode);
    	result.put("P_ITEM_NO",  pItemNo);
    	result.put("SEQ",        seq);
    	
    	return result;
    }

	@SuppressWarnings({ "rawtypes"})
	private GridData doSelect(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaFormater       sf               = null;
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    Map<String, String> header           = null;
	    String              gdResMessage     = null;
	    String              colKey           = null;
	    String              colValue         = null;
	    String[]            gridColAry       = null;
	    Object[]            obj              = new Object[1];
	    int                 rowCount         = 0;
	    int                 i                = 0;
	    int                 k                = 0;
	    int                 gridColAryLength = 0;
	    boolean             isStatus         = false;
	
	    try{
	    	message          = this.getMessage(info);
	    	header           = this.doSelectHeader(gdReq, info);
	    	obj[0]           = header;
	    	gridColAry       = this.getGridColArray(gdReq);
	    	gridColAryLength = gridColAry.length;
	    	gdRes            = OperateGridData.cloneResponseGridData(gdReq);
	    	value            = ServiceConnector.doService(info, "MA012", "CONNECTION", "ma012DoSelect", obj);
	    	isStatus         = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		for(i = 0; i < rowCount; i++){
			    		for(k = 0; k < gridColAryLength; k++){
			    			colKey   = gridColAry[k];
			    			colValue = sf.getValue(colKey, i);
			    			
			    			gdRes.addValue(colKey, colValue);
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
	
	private Object[] doSaveInsertParam(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       header           = this.getHeader(gdReq, info);
		Map<String, String>       resultInfoHeader = new HashMap<String, String>();
		Map<String, String>       gridInfo         = null;
		Map<String, String>       resultGridInfo   = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    id               = info.getSession("ID");
		String                    pItemNo          = header.get("pItemNo");
		String                    bomName          = header.get("bomName");
		String                    cItemNo          = null;
		String                    bomStandardQty   = null;
		List<Map<String, String>> grid             = this.getGrid(gdReq, info);
		List<Map<String, String>> resultInfoGrid   = new ArrayList<Map<String, String>>();
		int                       gridSize         = grid.size();
		int                       i                = 0;
		
		resultInfoHeader.put("HOUSE_CODE",  houseCode);
		resultInfoHeader.put("P_ITEM_NO",   pItemNo);
		resultInfoHeader.put("BOM_NAME",    bomName);
		resultInfoHeader.put("ADD_USER_ID", id);
		
		for(i = 0; i < gridSize; i++){
			resultGridInfo = new HashMap<String, String>();
			
			gridInfo       = grid.get(i);
			cItemNo        = gridInfo.get("C_ITEM_NO");
			bomStandardQty = gridInfo.get("BOM_STANDARD_QTY");
			
			resultGridInfo.put("HOUSE_CODE",       houseCode);
			resultGridInfo.put("P_ITEM_NO",        pItemNo);
			resultGridInfo.put("C_ITEM_NO",        cItemNo);
			resultGridInfo.put("BOM_STANDARD_QTY", bomStandardQty);
			resultGridInfo.put("ADD_USER_ID",      id);
			
			resultInfoGrid.add(resultGridInfo);
		}
		
		resultInfo.put("header",   resultInfoHeader);
		resultInfo.put("gridData", resultInfoGrid);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	private Object[] doSaveUpdateParam(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result           = new Object[1];
		Map<String, Object>       resultInfo       = new HashMap<String, Object>();
		Map<String, String>       header           = this.getHeader(gdReq, info);
		Map<String, String>       resultInfoHeader = new HashMap<String, String>();
		Map<String, String>       gridInfo         = null;
		Map<String, String>       resultGridInfo   = null;
		String                    houseCode        = info.getSession("HOUSE_CODE");
		String                    id               = info.getSession("ID");
		String                    pItemNo          = header.get("pItemNo");
		String                    bomName          = header.get("bomName");
		String                    cItemNo          = null;
		String                    bomStandardQty   = null;
		String                    seq              = header.get("seq");
		List<Map<String, String>> grid             = this.getGrid(gdReq, info);
		List<Map<String, String>> resultInfoGrid   = new ArrayList<Map<String, String>>();
		int                       gridSize         = grid.size();
		int                       i                = 0;
		
		resultInfoHeader.put("HOUSE_CODE",     houseCode);
		resultInfoHeader.put("P_ITEM_NO",      pItemNo);
		resultInfoHeader.put("BOM_NAME",       bomName);
		resultInfoHeader.put("CHANGE_USER_ID", id);
		resultInfoHeader.put("SEQ",            seq);
		
		for(i = 0; i < gridSize; i++){
			resultGridInfo = new HashMap<String, String>();
			
			gridInfo       = grid.get(i);
			cItemNo        = gridInfo.get("C_ITEM_NO");
			bomStandardQty = gridInfo.get("BOM_STANDARD_QTY");
			
			resultGridInfo.put("HOUSE_CODE",       houseCode);
			resultGridInfo.put("P_ITEM_NO",        pItemNo);
			resultGridInfo.put("SEQ",              seq);
			resultGridInfo.put("C_ITEM_NO",        cItemNo);
			resultGridInfo.put("BOM_STANDARD_QTY", bomStandardQty);
			resultGridInfo.put("ADD_USER_ID",      id);
			
			resultInfoGrid.add(resultGridInfo);
		}
		
		resultInfo.put("header",   resultInfoHeader);
		resultInfo.put("gridData", resultInfoGrid);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doSave(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes        = new GridData();
    	Vector              multilangId  = new Vector();
    	HashMap             message      = null;
    	Map<String, String> header       = this.getHeader(gdReq, info);
    	SepoaOut            value        = null;
    	String              type         = header.get("type");
    	String              gdRedMessage = null;
    	String              serviceName  = null;
    	Object[]            obj          = null;
    	boolean             isStatus     = false;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		if("I".equals(type)){
    			obj         = this.doSaveInsertParam(gdReq, info);
    			serviceName = "ma012DoInsert";
    		}
    		else if("U".equals(type)){
    			obj         = this.doSaveUpdateParam(gdReq, info);
    			serviceName = "ma012DoUpdate";
    		}
    		
    		value    = ServiceConnector.doService(info, "MA012", "TRANSACTION", serviceName, obj);
    		isStatus = value.flag;
    		
    		if(value.flag) {
    			gdRedMessage = message.get("MESSAGE.0001").toString();
    		}
    		else {
    			gdRedMessage = value.message;
    		}
    	}
    	catch(Exception e){
    		gdRedMessage = message.get("MESSAGE.1002").toString();
    		isStatus     = false;
    	}
    	
    	gdRes.setMessage(gdRedMessage);
    	gdRes.setStatus(Boolean.toString(isStatus));
    	
    	return gdRes;
    }
	
	private Map<String, String> ma012selectGlHeader(GridData gdReq, SepoaInfo info) throws Exception{
		Map<String, String> result    = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              pItemNo   = gdReq.getParam("pItemNo");
		String              seq       = gdReq.getParam("seq");
		
		result.put("HOUSE_CODE", houseCode);
		result.put("P_ITEM_NO",  pItemNo);
		result.put("SEQ",        seq);
		
		return result;
	}
	
	private String ma012selectGlGdResMessage(SepoaOut value, String[] gridColAry) throws Exception{
		String        result           = null;
		String        queryKey         = null;
		String        queryValue       = null;
		StringBuffer  stringBuffer     = new StringBuffer();
		SepoaFormater sf               = null;
		int           rowCount         = 0;
		int           i                = 0;
		int           k                = 0;
		int           gridColAryLength = gridColAry.length;
		
		sf = new SepoaFormater(value.result[0]);
		
    	rowCount = sf.getRowCount();

    	if(rowCount != 0){
    		for(i = 0; i < rowCount; i++){
	    		for(k = 0; k < gridColAryLength; k++){
	    			queryKey   = gridColAry[k];
	    			queryValue = sf.getValue(queryKey, i);
	    			
	    			stringBuffer.append(queryValue);
	    			
	    			if(k != (gridColAryLength - 1)){
	    				stringBuffer.append(',');
	    			}
	    		}
	    	}
    	}
    	
    	result = stringBuffer.toString();
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
	private GridData ma012selectGl(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes        = new GridData();
	    SepoaOut            value        = null;
	    HashMap             message      = null;
	    Map<String, String> header       = null;
	    String              gdResMessage = null;
	    String[]            gridColAry   = null;
	    Object[]            obj          = new Object[1];
	    boolean             isStatus     = false;
	
	    try{
	    	message    = this.getMessage(info);
	    	header     = this.ma012selectGlHeader(gdReq, info);
	    	obj[0]     = header;
	    	gridColAry = this.getGridColArray(gdReq);
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq);
	    	value      = ServiceConnector.doService(info, "MA012", "CONNECTION", "ma012selectGl", obj);
	    	isStatus   = value.flag;
	
	    	if(isStatus){
		    	gdResMessage = this.ma012selectGlGdResMessage(value, gridColAry);
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
	
	private Map<String, String> ma012SelectGlListHeader(GridData gdReq, SepoaInfo info) throws Exception{
		Map<String, String> result    = new HashMap<String, String>();
		Map<String, String> header    = this.getHeader(gdReq, info);
		String              houseCode = info.getSession("HOUSE_CODE");
		String              pItemNo   = header.get("pItemNo");
		String              cItemNo   = header.get("cItemNo");
		
		result.put("HOUSE_CODE", houseCode);
		result.put("P_ITEM_NO",  pItemNo);
		result.put("C_ITEM_NO",  cItemNo);
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
	private GridData ma012SelectGlList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaFormater       sf               = null;
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    Map<String, String> header           = null;
	    String              gdResMessage     = null;
	    String              colKey           = null;
	    String              colValue         = null;
	    String[]            gridColAry       = null;
	    Object[]            obj              = new Object[1];
	    int                 rowCount         = 0;
	    int                 i                = 0;
	    int                 k                = 0;
	    int                 gridColAryLength = 0;
	    boolean             isStatus         = false;
	
	    try{
	    	message          = this.getMessage(info);
	    	header           = this.ma012SelectGlListHeader(gdReq, info);
	    	obj[0]           = header;
	    	gridColAry       = this.getGridColArray(gdReq);
	    	gridColAryLength = gridColAry.length;
	    	gdRes            = OperateGridData.cloneResponseGridData(gdReq);
	    	value            = ServiceConnector.doService(info, "MA012", "CONNECTION", "ma012SelectGlList", obj);
	    	isStatus         = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		for(i = 0; i < rowCount; i++){
			    		for(k = 0; k < gridColAryLength; k++){
			    			colKey   = gridColAry[k];
			    			colValue = sf.getValue(colKey, i);
			    			
			    			gdRes.addValue(colKey, colValue);
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
	
	private Map<String, String> ma012SelectLnListHeader(GridData gdReq, SepoaInfo info) throws Exception{
		Map<String, String> result     = new HashMap<String, String>();
		Map<String, String> header     = this.getHeader(gdReq, info);
		String              pItemNo    = header.get("P_ITEM_NO");
		String              seq        = header.get("SEQ");
		String              vendor_code        = header.get("VENDOR_CODE");
		String              id         = info.getSession("ID");
		String              houseCode  = info.getSession("HOUSE_CODE");
		String              prLocation = info.getSession("LOCATION_CODE");
		
		if("".equals(prLocation)){
			prLocation = "01";
		}
		
		result.put("ID",          id);
		result.put("HOUSE_CODE",  houseCode);
		result.put("PR_LOCATION", prLocation);
		result.put("P_ITEM_NO",   pItemNo);
		result.put("SEQ",         seq);
		result.put("VENDOR_CODE",         vendor_code);
		
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	private GridData ma012SelectLnList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaFormater       sf               = null;
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    Map<String, String> header           = null;
	    String              gdResMessage     = null;
	    String              colKey           = null;
	    String              colValue         = null;
	    String[]            gridColAry       = null;
	    Object[]            obj              = new Object[1];
	    int                 rowCount         = 0;
	    int                 i                = 0;
	    int                 k                = 0;
	    int                 gridColAryLength = 0;
	    boolean             isStatus         = false;
	
	    try{
	    	message          = this.getMessage(info);
	    	header           = this.ma012SelectLnListHeader(gdReq, info);
	    	obj[0]           = header;
	    	gridColAry       = this.getGridColArray(gdReq);
	    	gridColAryLength = gridColAry.length;
	    	gdRes            = OperateGridData.cloneResponseGridData(gdReq);
	    	value            = ServiceConnector.doService(info, "MA012", "CONNECTION", "ma012SelectLnList", obj);
	    	isStatus         = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		for(i = 0; i < rowCount; i++){
			    		for(k = 0; k < gridColAryLength; k++){
			    			colKey   = gridColAry[k];
			    			colValue = sf.getValue(colKey, i);
			    			
			    			gdRes.addValue(colKey, colValue);
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
	
	
	
	
	
	@SuppressWarnings({ "rawtypes"})
	private GridData ma012SelectSoslnList(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	value    = ServiceConnector.doService(info, "MA012", "CONNECTION", "ma012SelectSoslnList", obj);
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

}