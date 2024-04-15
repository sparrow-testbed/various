package sepoa.svl.co;

import java.io.IOException;
import java.io.PrintWriter;
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

public class CO_008_Servlet extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void init(ServletConfig config) throws ServletException {}
	    
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
    		
    		if("selectUserList".equals(mode)){
    			gdRes = this.selectUserList(gdReq, info);
    		}
    		else if("selectDeviceUserJsonList".equals(mode)){
    			gdRes = this.selectDeviceUserJsonList(gdReq, info);
    		}
    		else if("selectApprovalUserList".equals(mode)){
    			gdRes = this.selectApprovalUserList(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		//e.printStackTrace();
    	}
    	finally {
    		try{
    			if("selectDeviceUserJsonList".equals(mode)){
    				out.print(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {
    			//e.printStackTrace();
    			mode  = "";
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
    
    private Object[] selectUserListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result      = new Object[1];
    	Map<String, String> header      = this.getHeader(gdReq, info);
    	Map<String, String> resultInfo  = new HashMap<String, String>();
    	String              houseCode   = info.getSession("HOUSE_CODE");
    	String              companyCode = info.getSession("COMPANY_CODE");
    	String              userId      = header.get("userId");
    	String              userNameLoc = header.get("userNameLoc");
    	String              deptCd      = header.get("deptCd");
    	String              deptNm      = header.get("deptNm");
    	
    	resultInfo.put("HOUSE_CODE",    houseCode);
    	resultInfo.put("COMPANY_CODE",  companyCode);
    	resultInfo.put("USER_ID",       userId);
    	resultInfo.put("USER_NAME_LOC", userNameLoc);
    	resultInfo.put("deptCd",        deptCd);
    	resultInfo.put("deptNm",        deptNm);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    private GridData selectUserListGdRes(GridData gdReq, GridData gdRes, SepoaFormater sf) throws Exception{
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
	private GridData selectUserList(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	obj      = this.selectUserListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "CO_008", "CONNECTION", "selectUserList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.selectUserListGdRes(gdReq, gdRes, sf);
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
	
	@SuppressWarnings({ "rawtypes" })
	private GridData selectApprovalUserList(GridData gdReq, SepoaInfo info) throws Exception{
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
	    	obj      = this.selectUserListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "CO_008", "CONNECTION", "selectApprovalUserList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	    		sf = new SepoaFormater(value.result[0]);
	    		
		    	rowCount = sf.getRowCount();
		
		    	if(rowCount != 0){
		    		gdRes = this.selectUserListGdRes(gdReq, gdRes, sf);
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
	
	private Object[] selectDeviceUserJsonListObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result         = new Object[1];
    	Map<String, String> resultInfo     = new HashMap<String, String>();
    	String              deviceUserInfo = gdReq.getParam("deviceUserInfo");
    	
    	resultInfo.put("deviceUserInfo", deviceUserInfo);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
	
	@SuppressWarnings({ "rawtypes" })
	private GridData selectDeviceUserJsonList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData      gdRes        = new GridData();
	    SepoaOut      value        = null;
	    HashMap       message      = null;
	    String        gdResMessage = null;
	    Object[]      obj          = null;
	    boolean       isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	gdRes    = OperateGridData.cloneResponseGridData(gdReq);
	    	obj      = this.selectDeviceUserJsonListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "CO_008", "CONNECTION","selectDeviceUserJsonList", obj);
	    	isStatus = value.flag;
	
	    	if(isStatus){
	        	gdResMessage = value.result[0];
	    	}
	    	else{
	    		gdResMessage = "[]";
	    	}
	    	
	    	gdRes.addParam("mode", "query");
	    }
	    catch (Exception e){
	    	gdResMessage = "[]";
	    	isStatus     = false;
	    }
	    
	    gdRes.setMessage(gdResMessage);
	    gdRes.setStatus(Boolean.toString(isStatus));
	    
	    return gdRes;
	}
}