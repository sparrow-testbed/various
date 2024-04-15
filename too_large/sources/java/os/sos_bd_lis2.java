package os;

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

public class sos_bd_lis2 extends HttpServlet{
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
    		
    		if("selectVendor".equals(mode)){
    			gdRes = this.selectVendor(gdReq, info);
    		}
    		else if("selectUnitPrice".equals(mode)){
    			gdRes = this.selectUnitPrice(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("selectUnitPrice".equals(mode)){
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
    
    @SuppressWarnings({ "unchecked", "unused" })
	private List<Map<String, String>> getGrid(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result  = null;
    	Map<String, Object>       allData = SepoaDataMapper.getData(info, gdReq);
    	
    	result = (List<Map<String, String>>)MapUtils.getObject(allData, "gridData");
    	
    	return result;
    }
    
	@SuppressWarnings("unused")
	private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    
    private List<Map<String, String>> selectVendorHeaderList(GridData gdReq, SepoaInfo info) throws Exception{
    	List<Map<String, String>> result            = new ArrayList<Map<String, String>>();
    	Map<String, String>       header            = this.getHeader(gdReq, info);
    	Map<String, String>       resultInfo        = null;
    	String                    itemNo            = header.get("itemNo");
    	String                    prLocation        = header.get("prLocation");
    	String                    houseCode         = info.getSession("HOUSE_CODE");
    	String                    companyCode       = info.getSession("COMPANY_CODE");
    	String                    prLocationInfo    = null;
    	String                    itemNoInfo        = null;
    	String[]                  itemNoArray       = itemNo.split(",");
    	String[]                  prLocationArray   = prLocation.split(",");
    	int                       itemNoArrayLength = itemNoArray.length;
    	int                       i                 = 0;
    	
    	for(i = 0; i < itemNoArrayLength; i++){
    		resultInfo = new HashMap<String, String>();
    		
    		prLocationInfo = prLocationArray[i];
    		itemNoInfo     = itemNoArray[i];
    		
    		resultInfo.put("HOUSE_CODE",   houseCode);
    		resultInfo.put("COMPANY_CODE", companyCode);
    		resultInfo.put("pr_location",  prLocationInfo);
    		resultInfo.put("item_no",      itemNoInfo);
    		
    		result.add(resultInfo);
    	}
    	
    	return result;
    }
    
    private List<Map<String, String>> selectVendorSvc(SepoaInfo info, Map<String, String> header) throws Exception{
    	Object[]                  obj             = {header};
    	SepoaOut                  value           = ServiceConnector.doService(info, "os_005", "CONNECTION", "selectVendorList", obj);
    	SepoaFormater             sf              = new SepoaFormater(value.result[0]);
    	List<Map<String, String>> valueList       = new ArrayList<Map<String, String>>();
    	String                    valueVendorCode = null;
    	String                    valueVendorName = null;
    	Map<String, String>       valueListInfo   = null;
    	int                       rowCount        = sf.getRowCount();
    	int                       i               = 0;
    	
    	if(value.flag == false){
    		throw new Exception(value.message);
    	}
    	
    	for(i = 0; i < rowCount; i++){
    		valueListInfo = new HashMap<String, String>();
    		
    		valueVendorCode = sf.getValue("VENDOR_CODE", i);
    		valueVendorName = sf.getValue("VENDOR_NAME", i);
    		
    		valueListInfo.put("vendorCode", valueVendorCode);
    		valueListInfo.put("vendorName", valueVendorName);
    		
    		valueList.add(valueListInfo);
    	}
    	
    	return valueList;
    }
    
    private List<Map<String, String>> selectVendorVendorList(List<Map<String, String>> vendorList, List<Map<String, String>> valueList) throws Exception{
    	Map<String, String> vendorListInfo = null;
    	Map<String, String> velueListInfo  = null;
    	String              vendorCode     = null;
    	String              valueCode      = null;
    	int                 vendorListSize = 0;
    	int                 valueListSize  = 0;
    	int                 i              = 0;
    	int                 j              = 0;
    	boolean             isExist        = false;
    	
    	if(vendorList == null){
    		vendorList = valueList;
    	}
    	else{
    		vendorListSize = vendorList.size();
    		
    		if(valueList != null){
    			valueListSize = valueList.size();
    		}
    		
    		for(i = (vendorListSize - 1); i >= 0; i--){
    			vendorListInfo = vendorList.get(i);
    			vendorCode     = vendorListInfo.get("vendorCode");
    			isExist        = false;
    			
    			for(j = 0; j < valueListSize; j++){
    				velueListInfo = valueList.get(j);
    				valueCode     = velueListInfo.get("vendorCode");
    				
    				if(vendorCode.equals(valueCode)){
    					isExist = true;
    					
    					break;
    				}
    			}
    			
    			if(isExist == false){
    				vendorList.remove(i);
    			}
    		}
    	}
    	
    	return vendorList;
    }
    
    private GridData selectVendorGdRes(GridData gdRes, List<Map<String, String>> vendorList) throws Exception{
    	Map<String, String> vendorListInfo = null;
    	String              vendorCode     = null;
    	String              vendorName     = null;
    	int                 vendorListSize = vendorList.size();
    	int                 i              = 0;
    	
    	for(i = 0; i < vendorListSize; i++){
    		vendorListInfo = vendorList.get(i);
    		vendorCode     = vendorListInfo.get("vendorCode");
    		vendorName     = vendorListInfo.get("vendorName");
    		
    		gdRes.addValue("SELECTED",    "0");
    		gdRes.addValue("VENDOR_CODE", vendorCode);
    		gdRes.addValue("VENDOR_NAME", vendorName);
    	}
    	
    	return gdRes;
    }
    
    @SuppressWarnings({ "rawtypes"})
	private GridData selectVendor(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData                  gdRes          = new GridData();
	    HashMap                   message        = null;
	    Map<String, String>       header         = null;
	    String                    gdResMessage   = null;
	    List<Map<String, String>> headerList     = this.selectVendorHeaderList(gdReq, info);
	    List<Map<String, String>> vendorList     = null;
	    List<Map<String, String>> valueList      = null;
	    boolean                   isStatus       = false;
	    int                       headerListSize = headerList.size();
	    int                       i              = 0;
	
	    try{
	    	message = this.getMessage(info);
	    	
	    	for(i = 0; i < headerListSize; i++){
	    		header     = headerList.get(i);
	    		valueList  = this.selectVendorSvc(info, header);
	    		vendorList = this.selectVendorVendorList(vendorList, valueList);
	    	}
	    	
	    	gdRes        = this.selectVendorGdRes(gdRes, vendorList);
	    	gdResMessage = (String)message.get("MESSAGE.0001");
	    	
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
    
    private Object[] selectUnitPriceObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result      = new Object[1];
    	Map<String, String> resultInfo  = new HashMap<String, String>();
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	String              companyCode = info.getSession("COMPANY_CODE");
    	String              prLocation  = gdReq.getParam("prLocation");
    	String              itemNo      = gdReq.getParam("itemNo");
    	String              vendorCode  = gdReq.getParam("vendorCode");
    	
    	resultInfo.put("HOUSE_CODE",        houseCode);
    	resultInfo.put("COMPANY_CODE",      companyCode);
    	resultInfo.put("PURCHASE_LOCATION", prLocation);
    	resultInfo.put("ITEM_NO",           itemNo);
    	resultInfo.put("VENDOR_CODE",       vendorCode);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private String selectUnitPriceGdResMessage(GridData gdReq, SepoaFormater sf) throws Exception{
    	String       result       = null;
    	String       vendorCode   = gdReq.getParam("vendorCode");
    	String       row          = gdReq.getParam("row");
    	String       unitPrice    = sf.getValue("UNIT_PRICE", 0);
    	String       vendorName   = sf.getValue("VENDOR_NAME", 0);
    	
    	StringBuffer stringBuffer = new StringBuffer();
    	
    	stringBuffer.append(vendorCode).append(",").append(row).append(",").append(unitPrice).append(",").append(vendorName);
    	
    	result = stringBuffer.toString();
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
	private GridData selectUnitPrice(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaOut      value        = null;
	    SepoaFormater sf           = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.selectUnitPriceObj(gdReq, info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	value    = ServiceConnector.doService(info, "os_005", "CONNECTION", "selectUnitPrice", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	gdResMessage = this.selectUnitPriceGdResMessage(gdReq, sf);
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