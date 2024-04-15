package master.new_material;

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

public class confirm_bd_upd2 extends HttpServlet{
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
	private Object[] doDataT0033Param(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       data         = SepoaDataMapper.getData(info, gdReq);
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    rejectRemark = null;
    	String                    id           = info.getSession("ID");
    	String                    nameLoc      = info.getSession("NAME_LOC");
    	String                    houseCode    = info.getSession("HOUSE_CODE");
    	String                    reqItemNo    = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo     = grid.get(i);
    		rejectRemark = gridInfo.get("REJECT_REMARK");
    		reqItemNo    = gridInfo.get("REQ_ITEM_NO");
    		
    		gridDataInfo.put("REJECT_REMARK",        rejectRemark);
    		gridDataInfo.put("CONFIRM_USER_ID",      id);
    		gridDataInfo.put("CHANGE_USER_NAME_LOC", nameLoc);
    		gridDataInfo.put("HOUSE_CODE",           houseCode);
    		gridDataInfo.put("REQ_ITEM_NO",          reqItemNo);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings("unchecked")
	private Object[] doDataSmsParam(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result       = new Object[1];
    	Map<String, Object>       data         = SepoaDataMapper.getData(info, gdReq);
    	Map<String, Object>       resultInfo   = new HashMap<String, Object>();
    	Map<String, String>       gridInfo     = null;
    	Map<String, String>       gridDataInfo = null;
    	List<Map<String, String>> grid         = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
    	String                    reqItemNo    = null;
    	int                       gridSize     = grid.size();
    	int                       i            = 0;
    	
    	for(i = 0; i < gridSize; i++){
    		gridDataInfo = new HashMap<String, String>();
    		
    		gridInfo  = grid.get(i);
    		reqItemNo = gridInfo.get("REQ_ITEM_NO");
    		
    		gridDataInfo.put("reqItemNo", reqItemNo);
    		
    		gridData.add(gridDataInfo);
    	}
    	
    	resultInfo.put("gridData", gridData);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doData(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData            gdRes       = new GridData();
    	Vector              multilangId = new Vector();
    	HashMap             message     = null;
    	SepoaOut            value       = null;
    	Object[]            t0033Param  = this.doDataT0033Param(gdReq, info);
    	Object[]            smsParam    = this.doDataSmsParam(gdReq, info);
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		value = ServiceConnector.doService(info, "t0033", "TRANSACTION", "confirm_bd_upd2_getUpdate", t0033Param);
    		
    		if(value.flag) {
    			gdRes.setMessage(message.get("MESSAGE.0001").toString()); 
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setMessage(value.message);
    			gdRes.setStatus("false");
    		}
    		
//    		ServiceConnector.doService(info, "SMS", "TRANSACTION", "S00001", smsParam);
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
}