package statistics;

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

public class sta_bd_lis42 extends HttpServlet{
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
    		
    		if("prItemsList".equals(mode)){
    			gdRes = this.prItemsList(gdReq, info);
    		}
    		else if("charge_transfer".equals(mode)){
    			gdRes = this.charge_transfer(gdReq, info);
    		}
    		else if("doConfirm".equals(mode)){
    			gdRes = this.doConfirm(gdReq, info);
    		}
    		else if("reject".equals(mode)){
    			gdRes = this.reject(gdReq, info);
    		}
    		else if("setSendPo".equals(mode)){
    			gdRes = this.setSendPo(gdReq, info);
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
	private GridData prItemsList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes      = new GridData();
	    SepoaOut            value      = null;
	    Vector              v          = new Vector();
	    HashMap             message    = null;
	    Map<String, Object> allData    = null;
	    Map<String, String> header     = null;
	    String              gridColId  = null;
	    String[]            gridColAry = null;
	
	    v.addElement("MESSAGE");
	
	    message = MessageUtil.getMessage(info, v);
	
	    try{
	    	allData    = SepoaDataMapper.getData(info, gdReq);
	    	header     = MapUtils.getMap(allData, "headerData");
	    	gridColId  = JSPUtil.paramCheck(gdReq.getParam("cols_ids")).trim();
	    	gridColAry = SepoaString.parser(gridColId, ",");
	    	gdRes      = OperateGridData.cloneResponseGridData(gdReq); // 응답 객체 생성
	    	header     = this.getCatalogHeader(header, info);
	
	    	gdRes.addParam("mode", "query");
	
	    	Object[] obj = {header};
	
	    	value = ServiceConnector.doService(info, "p1001", "CONNECTION", "prItemsList", obj);
	    	gdRes = this.prItemsListGdRes(value, gdRes, message, gridColAry);
	    }
	    catch (Exception e){
	    	
	    	
	    	gdRes.setMessage(message.get("MESSAGE.1002").toString());
	    	gdRes.setStatus("false");
	    }
	    
	    return gdRes;
	}
	
	@SuppressWarnings("rawtypes")
	private GridData prItemsListGdRes(SepoaOut value, GridData gdRes, HashMap message, String[] gridColAry) throws Exception{
		SepoaFormater sf       = null;
		String        prStatus = null;
		int           rowCount = 0;
		int           index    = 0;
		
		if(value.flag){// 조회 성공
    		gdRes.setMessage(message.get("MESSAGE.0001").toString());
    		gdRes.setStatus("true");
    		
    		sf= new SepoaFormater(value.result[0]);
    		
	    	rowCount = sf.getRowCount(); // 조회 row 수
	
	    	if(rowCount == 0){
	    		gdRes.setMessage(message.get("MESSAGE.1001").toString());
	    	}
	    	else{
	    		for (int i = 0; i < rowCount; i++){
		    		for(int k=0; k < gridColAry.length; k++){
		    			if("SELECTED".equals(gridColAry[k])){
		    				gdRes.addValue("SELECTED", "0");
		    			}
		    			else if("PR_STATUS".equals(gridColAry[k])){
		    				prStatus = sf.getValue("PR_STATUS", i);
		    				prStatus = this.nvl(prStatus);
		    				index    = prStatus.indexOf("^");
		    				
		    				if(index != -1){
		    					prStatus = prStatus.substring(0, prStatus.indexOf("^"));
		    				}
		    				
		    				gdRes.addValue("PR_STATUS", prStatus);
		    			}
		    			else{
		    				gdRes.addValue(gridColAry[k], sf.getValue(gridColAry[k], i));
		    			}
		    		}
		    	}
	    	}
    	}
    	else{
    		gdRes.setMessage(value.message);
    		gdRes.setStatus("false");
    	}
		
		return gdRes;
	}
	
	private Map<String, String> getCatalogHeader(Map<String, String> header, SepoaInfo info) throws Exception{
		header.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		header.put("ADD_DATE_START",     header.get("start_add_date"));
		header.put("ADD_DATE_END",       header.get("end_add_date"));
		header.put("DEMAND_DEPT",        header.get("demand_dept"));
		header.put("PURCHASER_ID",       header.get("purchaser_id"));
		header.put("PR_NO",              header.get("pr_no"));
		header.put("USER_NAME_LOC",      header.get("pr_add_user_name"));
		header.put("PR_REQ_STATUS",      header.get("pr_status"));
		header.put("ORDER_NO",           header.get("order_no"));
		header.put("WBS_NAME",           header.get("pr_wbs_name"));
		header.put("DESCRIPTION_LOC",    header.get("item_nm"));
		header.put("MATERIAL_TYPE",      header.get("MATERIAL_TYPE"));
		header.put("MATERIAL_CTRL_TYPE", header.get("MATERIAL_CTRL_TYPE"));
		header.put("MATERIAL_CLASS1",    header.get("MATERIAL_CLASS1"));
		header.put("MATERIAL_CLASS2",    header.get("MATERIAL_CLASS2"));
		header.put("CONFIRM_YN_CODE",    header.get("sh_confirm_yn"));
		
		return header;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData charge_transfer(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes       = new GridData();
    	Vector                    multilangId = new Vector();
    	HashMap                   message     = null;
    	SepoaOut                  value       = null;
    	Map<String, Object>       data        = null;
    	Map<String, Object>       svcParam    = new HashMap<String, Object>();
    	Map<String, String>       header      = null;
    	List<Map<String, String>> grid        = null;
    	List<Map<String, String>> prDataList  = null;
    	
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data       = SepoaDataMapper.getData(info, gdReq);
    		header     = MapUtils.getMap(data, "headerData");
			grid       = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			prDataList = this.getGridPrNoPrSeqList(grid);
			
			svcParam.put("prdata",               prDataList);
			svcParam.put("Transfer_id",          header.get("Transfer_id"));
			svcParam.put("Transfer_name",        header.get("Transfer_name"));
			svcParam.put("Transfer_person_id",   header.get("Transfer_person_id"));
			svcParam.put("Transfer_person_name", header.get("Transfer_person_name"));
			
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1010", "TRANSACTION", "charge_transfer_doc", obj);
    		
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData doConfirm(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes        = new GridData();
    	Vector                    multilangId  = new Vector();
    	HashMap                   message      = null;
    	SepoaOut                  value        = null;
    	Map<String, Object>       data         = null;
    	Map<String, Object>       svcParam     = new HashMap<String, Object>();
    	Map<String, String>       header       = null;
    	List<Map<String, String>> grid         = null;
    	List<Map<String, String>> recvdata     = null;
    	String                    reqType      = null;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		header   = MapUtils.getMap(data, "headerData");
			grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			recvdata = this.getGridPrNoPrSeqList(grid);
			reqType  = header.get("req_type");
			
			svcParam.put("recvdata", recvdata);
			svcParam.put("req_type", reqType);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1010", "TRANSACTION", "doConfirm", obj);
    		
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData reject(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes        = new GridData();
    	Vector                    multilangId  = new Vector();
    	HashMap                   message      = null;
    	SepoaOut                  value        = null;
    	Map<String, Object>       data         = null;
    	Map<String, Object>       svcParam     = new HashMap<String, Object>();
    	Map<String, String>       header       = null;
    	List<Map<String, String>> grid         = null;
    	List<Map<String, String>> recvdata     = null;
    	
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		header   = MapUtils.getMap(data, "headerData");
			grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
			recvdata = this.getGridPrNoPrSeqList(grid);
			
			svcParam.put("recvdata",    recvdata);
			svcParam.put("pTitle_Memo", header.get("pTitle_Memo"));
			svcParam.put("flag",        header.get("flag"));
			svcParam.put("reason_code", header.get("reason_code"));
			svcParam.put("email",       header.get("email"));
			svcParam.put("pr_name",     header.get("pr_name"));
			svcParam.put("req_type",    header.get("req_type"));
			
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1010", "TRANSACTION", "reject_doc", obj);
    		
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
	
	private List<Map<String, String>> getGridPrNoPrSeqList(List<Map<String, String>> grid) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		Map<String, String>       resultInfo = null;
		Map<String, String>       gridInfo   = null;
		int                       gridSize   = grid.size();
		int                       i          = 0;
		
		for(i = 0; i < gridSize; i++) {
			resultInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			
			resultInfo.put("PR_NO",  gridInfo.get("PR_NO"));
			resultInfo.put("PR_SEQ", gridInfo.get("PR_SEQ"));
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setSendPo(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes        = new GridData();
    	Vector                    multilangId  = new Vector();
    	HashMap                   message      = null;
    	SepoaOut                  value        = null;
    	Map<String, Object>       data         = null;
    	Map<String, Object>       svcParam     = new HashMap<String, Object>();
    	Map<String, String>       recvdataInfo = null;
    	Map<String, String>       gridInfo     = null;
    	List<Map<String, String>> grid         = null;
    	List<Map<String, String>> recvdata     = new ArrayList<Map<String, String>>();
    	String                    poVendorCode = null;
    	String                    poUnitPrice  = null;
    	String                    prNo         = null;
    	String                    prSeq        = null;
    	int                       gridSize     = 0;
    	int                       i            = 0;
   
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		data     = SepoaDataMapper.getData(info, gdReq);
    		grid     = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    		gridSize = grid.size();
    		
    		for(i = 0; i < gridSize; i++){
    			recvdataInfo = new HashMap<String, String>();
    			
    			gridInfo     = grid.get(i);
    			poVendorCode = gridInfo.get("PO_VENDOR_CODE");
    			poUnitPrice  = gridInfo.get("PO_UNIT_PRICE");
    			prNo         = gridInfo.get("PR_NO");
    			prSeq        = gridInfo.get("PR_SEQ");
    			
    			recvdataInfo.put("PO_VENDOR_CODE", poVendorCode);
    			recvdataInfo.put("PO_UNIT_PRICE",  poUnitPrice);
    			recvdataInfo.put("PR_NO",          prNo);
    			recvdataInfo.put("PR_SEQ",         prSeq);
    			
    			recvdata.add(recvdataInfo);
    		}
    		
    		svcParam.put("recvdata", recvdata);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1001", "TRANSACTION", "setSendPo", obj);
    		
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
	
	/**
	 * 빈 문자열 처리
	 * 
	 * @param str
	 * @return String
	 * @throws Exception
	 */
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
	/**
	 * 빈문자열 처리
	 * 
	 * @param str
	 * @param defaultValue
	 * @return String
	 * @throws Exception
	 */
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if("".equals(str)){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
}