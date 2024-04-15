package dt.ebd;

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

public class ebd_bd_ins6 extends HttpServlet{
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
    		
    		if("selectPrUserList".equals(mode)){
    			gdRes = this.selectPrUserList(gdReq, info);
    		}
    		else if("insertSprcart".equals(mode)){
    			gdRes = this.insertSprcart(gdReq, info);
    		}
    		else if("selectSmallCategoryList".equals(mode)){
    			gdRes = this.selectSmallCategoryList(gdReq, info);
    		}
    		else if("selectVerySmallCategoryList".equals(mode)){
    			gdRes = this.selectVerySmallCategoryList(gdReq, info);
    		}
    		else if("insertSprcartList".equals(mode)){
    			gdRes = this.insertSprcartList(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if(
    				"insertSprcart".equals(mode) || 
    				"selectSmallCategoryList".equals(mode) ||
    				"selectVerySmallCategoryList".equals(mode)
    			){
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
    
    private Object[] selectPrUserListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result    = new Object[1];
    	Map<String, String> header    = this.getHeader(gdReq, info);
    	String              houseCode = info.getSession("HOUSE_CODE");
    	
    	header.put("HOUSE_CODE", houseCode);
    	
    	result[0] = header;
    	
    	return result;
    }
    
    private GridData selectPrUserListGdRes(GridData gdReq, SepoaOut value) throws Exception{
    	GridData      gdRes            = OperateGridData.cloneResponseGridData(gdReq);
    	SepoaFormater sf               = new SepoaFormater(value.result[0]);
    	String[]      gridColAry       = this.getGridColArray(gdReq);
    	String        colKey           = null;
	    String        colValue         = null;
    	int           rowCount         = sf.getRowCount();
    	int           i                = 0;
    	int           k                = 0;
    	int           gridColAryLength = gridColAry.length;

    	for(i = 0; i < rowCount; i++){
    		for(k = 0; k < gridColAryLength; k++){
    			colKey   = gridColAry[k];
    			
    			if("CART".equals(colKey)){
    				colValue = "/images/icon/icon_disk_b.gif";
    			}
    			else if("IMAGE_FILE_PATH".equals(colKey)){//이미지 경로 그리드컬럼
    				colValue = sf.getValue(colKey, i);
    			}
    			else if("IMAGE_FILE".equals(colKey)){//이미지 그리드컬럼
    				colValue = sf.getValue(colKey, i);
    				if(colValue == null || "".equals(colValue)){
    					colValue = "/images/000/icon/icon_close3.gif";//이미지 경로 세팅
    				} else {
    					colValue = "/images/ico_x1.gif";//이미지 경로 세팅
    				}
    			}
    			else{
    				colValue = sf.getValue(colKey, i);
    			}
    			
    			gdRes.addValue(colKey, colValue);
    		}
    	}
    	
    	gdRes.addParam("mode", "query");
    	
    	return gdRes;
    }

	@SuppressWarnings({ "rawtypes"})
	private GridData selectPrUserList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData gdRes        = new GridData();
	    SepoaOut value        = null;
	    HashMap  message      = null;
	    String   gdResMessage = null;
	    Object[] obj          = null;
	    boolean  isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.selectPrUserListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "p1015", "CONNECTION", "selectPrUserList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		gdRes        = this.selectPrUserListGdRes(gdReq, value);
	    		gdResMessage = message.get("MESSAGE.0001").toString();
	    	}
	    	else{
	    		gdResMessage = value.message;
	    	}
	    }
	    catch(Exception e){
	    	gdResMessage = (message != null && message.get("MESSAGE.1002") != null)?message.get("MESSAGE.1002").toString():"";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
	
	private Object[] insertSprcartObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result       = new Object[1];
		Map<String, String> gridDataInfo = new HashMap<String, String>();
		String              houseCode    = info.getSession("HOUSE_CODE");
		String              id           = info.getSession("ID");
		String              itemNo       = gdReq.getParam("ITEM_NO");
		String              qty          = gdReq.getParam("PR_QTY");
		String              rdDate       = gdReq.getParam("RD_DATE");
		if(rdDate!=null){
			rdDate = rdDate.replace("/", "");
		}
		gridDataInfo.put("HOUSE_CODE",  houseCode);
		gridDataInfo.put("USER_ID",     id);
		gridDataInfo.put("ITEM_NO",     itemNo);
		gridDataInfo.put("QTY",         qty);
		gridDataInfo.put("ADD_USER_ID", id);
		gridDataInfo.put("RD_DATE",     rdDate);
		
		result[0] = gridDataInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData insertSprcart(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.insertSprcartObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "insertSprcart", obj);
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
	
	private Object[] selectSmallCategoryListObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result           = new Object[1];
		Map<String, String> hederInfo        = new HashMap<String, String>();
		String              materialType     = gdReq.getParam("MATERIAL_TYPE");
		String              materialCtrlType = gdReq.getParam("MATERIAL_CTRL_TYPE");
		String              houseCode        = info.getSession("HOUSE_CODE");
		
		hederInfo.put("MATERIAL_TYPE",      materialType);
		hederInfo.put("MATERIAL_CTRL_TYPE", materialCtrlType);
		hederInfo.put("HOUSE_CODE",         houseCode);
		
		result[0] = hederInfo;
		
		return result;
	}
	
	private String selectSmallCategoryListJson(SepoaFormater sf) throws Exception{
		String       result       = null;
		String       code         = null;
		String       text2        = null;
		StringBuffer stringBuffer = new StringBuffer();
		int          i            = 0;
		int          rowCount     = sf.getRowCount();
		int          lastIndex    = rowCount - 1;
		
		stringBuffer.append("[");
		
		for(i = 0; i < rowCount; i++){
			code  = sf.getValue("CODE",  i);
			text2 = sf.getValue("TEXT2", i);
			
			stringBuffer.append("{");
			stringBuffer.append(	"code:'").append(code).append("',");
			stringBuffer.append(	"text2:'").append(text2).append("'");
			stringBuffer.append("}");
			
			if(i != lastIndex){
				stringBuffer.append(",");
			}
		}
		
		stringBuffer.append("]");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private GridData selectSmallCategoryList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    boolean       isStatus     = false;
	
	    try{
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.selectSmallCategoryListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "p1015", "CONNECTION", "selectSmallCategoryList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	gdResMessage = this.selectSmallCategoryListJson(sf);
	    	}
	    	else{
	    		throw new Exception();
	    	}
	    }
	    catch (Exception e){
	    	gdResMessage = "[]";
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.addParam("mode", "query");
	    
	    return gdRes;
	}
	
	private Object[] insertSprcartListObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result       = new Object[1];
		List<Map<String, String>> grid         = this.getGrid(gdReq, info);
		List<Map<String, String>> listData     = new ArrayList<Map<String, String>>();
		Map<String, String>       gridInfo     = null;
		Map<String, String>       listDataInfo = null;
		Map<String, Object>       resultInfo   = new HashMap<String, Object>();
		String                    prQty        = null;
		String                    itemNo       = null;
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    id           = info.getSession("ID");
		int                       gridSize     = grid.size();
		int                       i            = 0;
		
		for(i = 0; i < gridSize; i++){
			listDataInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			prQty    = gridInfo.get("PR_QTY");
			itemNo   = gridInfo.get("ITEM_NO");
			
			listDataInfo.put("HOUSE_CODE",  houseCode);
			listDataInfo.put("USER_ID",     id);
			listDataInfo.put("ITEM_NO",     itemNo);
			listDataInfo.put("QTY",         prQty);
			listDataInfo.put("ADD_USER_ID", id);
			
			listData.add(listDataInfo);
		}
		
		resultInfo.put("listData", listData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData insertSprcartList(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	HashMap  message      = null;
    	SepoaOut value        = null;
    	Object[] obj          = null;
    	String   gdResMessage = null;
    	boolean  isStatus     = false;

    	try {
    		message  = this.getMessage(info);
    		obj      = this.insertSprcartListObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "insertSprcartList", obj);
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
	
	private Object[] selectVerySmallCategoryListObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]            result           = new Object[1];
		Map<String, String> hederInfo        = new HashMap<String, String>();
		String              materialType     = gdReq.getParam("MATERIAL_TYPE");
		String              materialCtrlType = gdReq.getParam("MATERIAL_CTRL_TYPE");
		String              materialClass1   = gdReq.getParam("MATERIAL_CLASS1");
		String              houseCode        = info.getSession("HOUSE_CODE");
		
		hederInfo.put("MATERIAL_TYPE",      materialType);
		hederInfo.put("MATERIAL_CTRL_TYPE", materialCtrlType);
		hederInfo.put("MATERIAL_CLASS1",    materialClass1);
		hederInfo.put("HOUSE_CODE",         houseCode);
		
		result[0] = hederInfo;
		
		return result;
	}
	
	private String selectVerySmallCategoryListJson(SepoaFormater sf) throws Exception{
		String       result       = null;
		String       code         = null;
		String       text2        = null;
		StringBuffer stringBuffer = new StringBuffer();
		int          i            = 0;
		int          rowCount     = sf.getRowCount();
		int          lastIndex    = rowCount - 1;
		
		stringBuffer.append("[");
		
		for(i = 0; i < rowCount; i++){
			code  = sf.getValue("CODE",  i);
			text2 = sf.getValue("TEXT2", i);
			
			stringBuffer.append("{");
			stringBuffer.append(	"code:'").append(code).append("',");
			stringBuffer.append(	"text2:'").append(text2).append("'");
			stringBuffer.append("}");
			
			if(i != lastIndex){
				stringBuffer.append(",");
			}
		}
		
		stringBuffer.append("]");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private GridData selectVerySmallCategoryList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaFormater sf           = null;
	    SepoaOut      value        = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    boolean       isStatus     = false;
	
	    try{
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.selectVerySmallCategoryListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "p1015", "CONNECTION", "selectVerySmallCategoryList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	gdResMessage = this.selectVerySmallCategoryListJson(sf);
	    	}
	    	else{
	    		throw new Exception();
	    	}
	    }
	    catch (Exception e){
	    	gdResMessage = "[]";
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.addParam("mode", "query");
	    
	    return gdRes;
	}
}