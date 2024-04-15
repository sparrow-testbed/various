package dt.pr;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
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

import com.woorifg.eoffice.ConnServiceStub;
import com.woorifg.eoffice.ConnServiceStub.ArrayOfString;
import com.woorifg.eoffice.ConnServiceStub.DocLinkUrl;
import com.woorifg.eoffice.ConnServiceStub.DocLinkUrlResponse;
      
public class pr5_bd_lis2 extends HttpServlet{
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
    		else if("setSendPo2".equals(mode)){
    			gdRes = this.setSendPo2(gdReq, info);
    		}
    		else if("gwDraft".equals(mode)){
    			gdRes = this.gwDraft(gdReq, info);
    		}
    		else if("gwBind".equals(mode)){
    			gdRes = this.gwBind(gdReq, info);
    		}
    	}
    	catch (Exception e) {
    		gdRes.setMessage("Error: " + e.getMessage());
    		gdRes.setStatus("false");
    		
    	}
    	finally {
    		try{
    			if("gwDraft".equals(mode) || "gwBind".equals(mode)){
    				out.println(gdRes.getMessage());
    			}
    			else{
    				OperateGridData.write(req, res, gdRes, out);
    			}
    		}
    		catch (Exception e) {Logger.debug.println();}
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
	    	
	    	header.put("start_add_date ".trim(), SepoaString.getDateUnSlashFormat( header.get("start_add_date ".trim() ) ) );
	    	header.put("end_add_date   ".trim(), SepoaString.getDateUnSlashFormat( header.get("end_add_date   ".trim() ) ) );
	
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
		    			else if("GW_STATUS_NM".equals(gridColAry[k])){
		    				String gwStatus   = sf.getValue("GW_STATUS",    i);
		    				String gwStatusNm = sf.getValue("GW_STATUS_NM", i);
		    				
		    				if("E".equals(gwStatus)){
		    					gwStatusNm = "<font color='blue'>" + gwStatusNm + "</font>";
		    				}
		    				
		    				gdRes.addValue(gridColAry[k], gwStatusNm);
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
		header.put("ADD_DATE_START",     SepoaString.getDateUnSlashFormat(header.get("start_add_date")));
		header.put("ADD_DATE_END",       SepoaString.getDateUnSlashFormat(header.get("end_add_date")));
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
			
			svcParam.put( "start_add_date ".trim(), SepoaString.getDateUnSlashFormat( header.get("start_add_date ".trim() ) ) );
			svcParam.put( "end_add_date   ".trim(), SepoaString.getDateUnSlashFormat( header.get("end_add_date   ".trim() ) ) );
			
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
    	String                    rdDate       = null;
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
    			rdDate       = gridInfo.get("RD_DATE");
    			
    			recvdataInfo.put("PO_VENDOR_CODE", poVendorCode);
    			recvdataInfo.put("PO_UNIT_PRICE",  poUnitPrice);
    			recvdataInfo.put("PR_NO",          prNo);
    			recvdataInfo.put("PR_SEQ",        prSeq);
    			recvdataInfo.put("RD_DATE",      rdDate);
    			
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setSendPo2(GridData gdReq, SepoaInfo info) throws Exception{
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
    	String                    rdDate       = null;
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
    			rdDate       = gridInfo.get("RD_DATE");
    			
    			recvdataInfo.put("PO_VENDOR_CODE", poVendorCode);
    			recvdataInfo.put("PO_UNIT_PRICE",  poUnitPrice);
    			recvdataInfo.put("PR_NO",          prNo);
    			recvdataInfo.put("PR_SEQ",        prSeq);
    			recvdataInfo.put("RD_DATE",      rdDate);
    			
    			recvdata.add(recvdataInfo);
    		}
    		
    		svcParam.put("recvdata", recvdata);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1001", "TRANSACTION", "setSendPo2", obj);
    		
    		gdRes.setMessage(value.message);
    		gdRes.setStatus(Boolean.toString(value.flag));
    	}
    	catch(Exception e){
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
	
	private String nvl(String str) throws Exception{
		String result = null;
		
		result = this.nvl(str, "");
		
		return result;
	}
	
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
	
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend, String USRUSRID) throws Exception{
		Map<String, String> param = new HashMap<String, String>();
		Object[]            obj   = new Object[1];
		SepoaOut            value = null;
		String              infNo = null;
		boolean             flag  = false;
		
		param.put("HOUSE_CODE", "000");
		param.put("INF_TYPE",   "G");
		param.put("INF_CODE",   infCode);
		param.put("INF_SEND",   infSend);
		param.put("INF_ID",     USRUSRID);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception("900");
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	private String enCode(String param){
		StringBuffer sb = new StringBuffer();
		
		if(param == null){
			sb.append("");
		}
		else{
			if(param.length() > 0){
				for(int i = 0; i < param.length(); i++){
					String len = "" + (int)param.charAt(i);
					sb.append(len.length());
					sb.append((int)param.charAt(i));
				}
			}
		}
		
		return sb.toString();
	}
	
	private String getPrNoPrSeqInConditionStr(String[] prNoArray, String[] prSeqArray) throws Exception{
		String              result                = null;
		String              prNo                  = null;
		String              prSeq                 = null;
		StringBuffer        stringBuffer          = new StringBuffer();
		int                 recvdataSize          = prNoArray.length;
		int                 i                     = 0;
		int                 recvdataSizeLastIndex = recvdataSize - 1;
		
		for(i = 0; i < recvdataSize; i++){
			prNo         = prNoArray[i];
			prSeq        = prSeqArray[i];
			
			if(i == recvdataSizeLastIndex){
				stringBuffer.append("('").append(prNo).append("', '").append(prSeq).append("') ");
			}
			else{
				stringBuffer.append("('").append(prNo).append("', '").append(prSeq).append("'), ");
			}
		}
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private List<Map<String, String>> selectIcoyprdtGwList(SepoaInfo info, String[] prNoArray, String[] prSeqArray) throws Exception{
		List<Map<String, String>> result         = new ArrayList<Map<String, String>>();
		Object[]                  obj            = new Object[1];
		Map<String, String>       objInfo        = new HashMap<String, String>();
		Map<String, String>       resultInfo     = null;
		String                    houseCode      = info.getSession("HOUSE_CODE");
		String                    prNoSeq        = this.getPrNoPrSeqInConditionStr(prNoArray, prSeqArray);
		String                    descriptionLoc = null;
		String                    prQty          = null;
		String                    unitPrice      = null;
		String                    prAmt          = null;
		SepoaOut                  value          = null;
		SepoaFormater             sf             = null;
		boolean                   isStatus       = false;
		int                       rowCount       = 0;
		int                       i              = 0;
		
		objInfo.put("HOUSE_CODE", houseCode);
		objInfo.put("prNoSeq",    prNoSeq);
		
		obj[0]   = objInfo;
		value    = ServiceConnector.doService(info, "p1001", "CONNECTION", "selectIcoyprdtGwList", obj);
		isStatus = value.flag;
		
		if(isStatus){
    		sf = new SepoaFormater(value.result[0]);
    		
	    	rowCount = sf.getRowCount();
	
	    	for(i = 0; i < rowCount; i++){
	    		resultInfo = new HashMap<String, String>();
	    		
	    		descriptionLoc = sf.getValue("DESCRIPTION_LOC", i);
	    		prQty          = sf.getValue("PR_QTY",          i);
	    		unitPrice      = sf.getValue("UNIT_PRICE",      i);
	    		prAmt          = sf.getValue("PR_AMT",          i);
	    		
	    		resultInfo.put("DESCRIPTION_LOC", descriptionLoc);
	    		resultInfo.put("PR_QTY",          prQty);
	    		resultInfo.put("UNIT_PRICE",      unitPrice);
	    		resultInfo.put("PR_AMT",          prAmt);
	    		
	    		result.add(resultInfo);
	    	}
    	}
    	else{
    		throw new Exception();
    	}
		
		return result;
	}
	
	private StringBuffer gwDraftObjBodyContentBody(StringBuffer stringBuffer, List<Map<String, String>> prdtList) throws Exception{
		Map<String, String> prdtListInfo = null;
		int                 prdtListSize = prdtList.size();
		int                 i            = 0;
		
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("1. 구입근거");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("2. 구입품목 및 예정금액");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<table width='100%' border='0' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD style='text-align: right;'>(단위 : 원, 부가세포함)</TD>");
		stringBuffer.append(	"</TR>");
		stringBuffer.append("</TABLE>");
		stringBuffer.append("<table width='100%' border='1' cellspacing='0' cellpadding='0'>");
		stringBuffer.append(	"<TR>");
		stringBuffer.append(		"<TD width='35%'><p align='center'>품명</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>수량</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>예정단가</p></TD>");
		stringBuffer.append(		"<TD width='15%'><p align='center'>예정금액</p></TD>");
		stringBuffer.append(		"<TD width='20%'><p align='center'>비고</p></TD>");
		stringBuffer.append(	"</TR>");
		
		for(i = 0; i < prdtListSize; i++){
			prdtListInfo = prdtList.get(i);
			
			stringBuffer.append("<TR>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		prdtListInfo.get("DESCRIPTION_LOC"));
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PR_QTY")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("UNIT_PRICE")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>");
			stringBuffer.append(		"<p align='right'>");
			stringBuffer.append(			SepoaString.dFormat(prdtListInfo.get("PR_AMT")));
			stringBuffer.append(		"</p>");
			stringBuffer.append(	"</TD>");
			stringBuffer.append(	"<TD height='30'>&nbsp;</TD>");
			stringBuffer.append("</TR>");
		}
		
		stringBuffer.append("</TABLE>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("3. 구입방법");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("4. 낙찰방법");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("5. 처리계정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("6. 추진일정");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("7. 기타");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("<p>&nbsp;</p>");
		stringBuffer.append("붙임");
		
		return stringBuffer;
	}
	
	private String gwDraftObjBodyContent(SepoaInfo info, String infNo, String[] prNoArray, String[] prSeqArray) throws Exception{
		String                    result       = null;
		StringBuffer              stringBuffer = new StringBuffer();
		List<Map<String, String>> prdtList     = this.selectIcoyprdtGwList(info, prNoArray, prSeqArray);
		
		stringBuffer.append("<DOCLINKS></DOCLINKS>");
		stringBuffer.append("<SYSKEY>").append(infNo).append("</SYSKEY>");
		stringBuffer.append("<EDATE></EDATE>");
		stringBuffer.append("<SEL_Secrecy></SEL_Secrecy>");
		stringBuffer.append("<DOC_KIND></DOC_KIND>");
		stringBuffer.append("<RULENAUTH></RULENAUTH>");
		stringBuffer.append("<sY></sY>");
		stringBuffer.append("<sN></sN>");
		stringBuffer.append("<PRERULE_DATA></PRERULE_DATA>");
		stringBuffer.append("<LIMIT_DATA></LIMIT_DATA>");
		stringBuffer.append("<YPUBLIC></YPUBLIC>");
		stringBuffer.append("<NPUBLIC></NPUBLIC>");
		stringBuffer.append("<SUBJECT>구매요청품의</SUBJECT>");
		stringBuffer.append("<HtmlBody><![CDATA[");
		stringBuffer.append(	"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">");
		stringBuffer.append(	"<HTML>");
		stringBuffer.append(	"<HEAD>");
		stringBuffer.append(		"<META http-equiv=Content-Type content=\"text/html; charset=utf-8\">");
		stringBuffer.append(		"<META content=http://schemas.microsoft.com/intellisense/ie5   name=vs_targetSchema>");
		stringBuffer.append(		"<STYLE type=text/css>");
		stringBuffer.append(			"p {font-size:12px; font-family:굴림; margin:0pt;}");
		stringBuffer.append(		"</STYLE>");
		stringBuffer.append(		"<META content=\"MSHTML 6.00.2900.5969\" name=GENERATOR>");
		stringBuffer.append(	"</HEAD>");
		stringBuffer.append(	"<BODY>");
		
		stringBuffer = this.gwDraftObjBodyContentBody(stringBuffer, prdtList);
		
		stringBuffer.append(	"</BODY>");
		stringBuffer.append("]]></HtmlBody>");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private Object[] gwDraftObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result          = new Object[1];
		Map<String, Object>       resultInfo      = new HashMap<String, Object>();
		Map<String, String>       data            = new HashMap<String, String>();
		Map<String, String>       listInfo        = null;
		String                    prNo            = gdReq.getParam("prNo");
		String                    prSeq           = gdReq.getParam("prSeq");
		String                    kind            = gdReq.getParam("kind");
		String                    houseCode       = info.getSession("HOUSE_CODE");
		String                    infNo           = this.insertSinfhdInfo(info, "GWAPP", "S", " ");
		String                    bodyContent     = null;
		String                    seq             = null;
		String                    prNoArrayInfo   = null;
		String                    prSeqArrayInfo  = null;
		String[]                  prNoArray       = prNo.split(",");
		String[]                  prSeqArray      = prSeq.split(",");
		List<Map<String, String>> list            = new ArrayList<Map<String, String>>();
		int                       prNoArrayLength = prNoArray.length;
		int                       i               = 0;
		
		bodyContent     = this.gwDraftObjBodyContent(info, infNo, prNoArray, prSeqArray);
		
		data.put("HOUSE_CODE",   houseCode);
		data.put("INF_NO",       infNo);
		data.put("BODY_CONTENT", bodyContent);
		data.put("TYPE",         "P");
		
		for(i = 0; i < prNoArrayLength; i++){
			listInfo = new HashMap<String, String>();
			
			seq            = Integer.toString(i + 1);
			prNoArrayInfo  = prNoArray[i];
			prSeqArrayInfo = prSeqArray[i];
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("INF_NO",     infNo);
			listInfo.put("SEQ",        seq);
			listInfo.put("PR_NO",      prNoArrayInfo);
			listInfo.put("PR_SEQ",     prSeqArrayInfo);
			listInfo.put("kind",     kind);
			
			list.add(listInfo);
		}
		
		resultInfo.put("data", data);
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	private String gwDraftSuccessJson(Object[] obj) throws Exception{
		String              result       = null;
		String              bodyContent  = null;
		String              infNo        = null;
		StringBuffer        stringBuffer = new StringBuffer();
    	Map<String, Object> objInfo      = null;
    	Map<String, String> objInfoData  = null;
		
		objInfo     = (Map<String, Object>)obj[0];
		objInfoData = (Map<String, String>)objInfo.get("data");
		bodyContent = objInfoData.get("BODY_CONTENT");
		infNo       = objInfoData.get("INF_NO");
		bodyContent = this.enCode(bodyContent);
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'200',");
		stringBuffer.append(	"bodyContextValue:'").append(bodyContent).append("',");
		stringBuffer.append(	"infNo:'").append(infNo).append("'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String gwDraftFailJson() throws Exception{
		String       result       = null;
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"message:'상신 내용 작성 중 문제가 발생하였습니다.'");
		stringBuffer.append("}");
		
		result = stringBuffer.toString();
		
		return result;
	}
	
	private String getExceptionStackTrace(Exception e){
		Writer      writer      = null;
		PrintWriter printWriter = null;
		String      s           = null;
		
		writer      = new StringWriter();
		printWriter = new PrintWriter(writer);
		
		e.printStackTrace(printWriter);
		
		s = writer.toString();
		
		return s;
	}
	
	private void loggerExceptionStackTrace(Exception e){
		String trace = this.getExceptionStackTrace(e);
		
		Logger.err.println(trace);
	}
	
	private GridData gwDraft(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData gdRes        = new GridData();
    	SepoaOut value        = null;
    	Object[] obj          = null; 
    	String   gdResMessage = null;
    	boolean  flag         = false;
   
    	try {
    		obj   = this.gwDraftObj(gdReq, info);
    		value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertGwappprInfo", obj);
    		flag  = value.flag;
    		
    		if(flag == false){
    			throw new Exception();
    		}
    		
    		gdResMessage = this.gwDraftSuccessJson(obj);
    	}
    	catch(Exception e){
    		this.loggerExceptionStackTrace(e);
    		
    		gdResMessage = this.gwDraftFailJson();
    	}
    	
    	gdRes.setMessage(gdResMessage);
    	
    	return gdRes;
    }
	
	private Object[] gwBindObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result          = new Object[1];
		Map<String, Object>       resultInfo      = new HashMap<String, Object>();
		Map<String, String>       data            = new HashMap<String, String>();
		Map<String, String>       listInfo        = null;
		String                    prNo            = gdReq.getParam("prNo");
		String                    prSeq           = gdReq.getParam("prSeq");
		String                    kind            = gdReq.getParam("kind");
		String                    gwDocNo         = gdReq.getParam("gwDocNo");
		String                    gwEndDate       = gdReq.getParam("gwEndDate");
		String                    houseCode       = info.getSession("HOUSE_CODE");		
		String                    id              = this.getWebserviceId(info);	
		String                    infNo           = this.insertSinfhdInfo(info, "GWAPP", "S", id);
		String                    bodyContent     = null;
		String                    seq             = null;
		String                    prNoArrayInfo   = null;
		String                    prSeqArrayInfo  = null;
		String[]                  prNoArray       = prNo.split(",");
		String[]                  prSeqArray      = prSeq.split(",");
		List<Map<String, String>> list            = new ArrayList<Map<String, String>>();
		int                       prNoArrayLength = prNoArray.length;
		int                       i               = 0;
		
		bodyContent     = this.gwDraftObjBodyContent(info, infNo, prNoArray, prSeqArray);
		
		data.put("HOUSE_CODE",   houseCode);
		data.put("INF_NO",       infNo);
		data.put("BODY_CONTENT", bodyContent);
		data.put("TYPE",         "E");
		data.put("gwDocNo",      gwDocNo);
		data.put("gwEndDate",    gwEndDate);
		
		for(i = 0; i < prNoArrayLength; i++){
			listInfo = new HashMap<String, String>();
			
			seq            = Integer.toString(i + 1);
			prNoArrayInfo  = prNoArray[i];
			prSeqArrayInfo = prSeqArray[i];
			
			listInfo.put("HOUSE_CODE", houseCode);
			listInfo.put("INF_NO",     infNo);
			listInfo.put("SEQ",        seq);
			listInfo.put("PR_NO",      prNoArrayInfo);
			listInfo.put("PR_SEQ",     prSeqArrayInfo);
			listInfo.put("kind",       kind);
			
			list.add(listInfo);
		}
		
		resultInfo.put("data", data);
		resultInfo.put("list", list);
		
		result[0] = resultInfo;
		
		return result;
	}
	
//	private GridData gwBind(GridData gdReq, SepoaInfo info) throws Exception{
//    	GridData gdRes        = new GridData();
//    	SepoaOut value        = null;
//    	Object[] obj          = null; 
//    	String   gdResMessage = null;
//    	boolean  flag         = false;
//   
//    	try {
//    		obj   = this.gwBindObj(gdReq, info);
//    		value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertGwappprInfo", obj);
//    		flag  = value.flag;
//    		
//    		if(flag == false){
//    			throw new Exception();
//    		}
//    		
//    		gdResMessage = this.gwDraftSuccessJson(obj);
//    	}
//    	catch(Exception e){
//    		this.loggerExceptionStackTrace(e);
//    		
//    		gdResMessage = this.gwDraftFailJson();
//    	}
//    	
//    	gdRes.setMessage(gdResMessage);
//    	
//    	return gdRes;
//    }
	
	private GridData gwBind(GridData gdReq, SepoaInfo info) throws Exception{
		StringBuffer stringBuffer = null;
		String       result       = null;
		GridData     gdRes        = new GridData();
		
		try{
			stringBuffer = this.getEps0036WebService(gdReq, info);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
			
			stringBuffer = this.getExceptionJson(e);
	    }
		
		result = stringBuffer.toString();
		
		gdRes.setMessage(result);
		
		return gdRes;
	}
	
	private StringBuffer getEps0036WebService(GridData gdReq, SepoaInfo info) throws Exception{
		ConnServiceStub    epsWSStub       = null;
		DocLinkUrl         eps0036         = null;
		DocLinkUrlResponse eps0036Response = null;
		ArrayOfString   arrayOfString   = null;
		String          infNo           = null;
		String          status          = null;
		String          reason          = null;
		String          code            = null;
		String[]        response        = null;
		StringBuffer    stringBuffer    = null;
		
		SepoaOut value        = null;
		Object[] obj          = null; 
		boolean  flag         = false;
		
		try{
			epsWSStub = new ConnServiceStub();
			
			eps0036 = this.getEps0036WebServiceEps0036(gdReq, info);
			infNo   = this.insertSinfhdInfo(info, "EPS0036", "S");
			
			this.insertSinfEps0036Info(info, infNo, eps0036);
			
			eps0036Response = epsWSStub.docLinkUrl(eps0036);
			arrayOfString   = eps0036Response.getDocLinkUrlResult();
			
			response        = arrayOfString.getString();
			code            = response[0];
			
			if("200".equals(code)){
				obj   = this.gwBindObj(gdReq, info);
				value = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertGwappprInfo3", obj);
				flag  = value.flag;
				
				status = "Y";
				reason = "";
			}else{
				status = "N";
				reason = response[2];
			}
		}
		catch(Exception e){
			response = new String[3];
			
			status = "N";
			reason = this.getExceptionStackTrace(e);
			reason = this.getStringMaxByte(reason, 4000);
			
			response[0] = "901";
			response[1] = reason;
			response[2] = reason;
			
			this.loggerExceptionStackTrace(e);
		}
		
		this.updateSinfhdInfo(info, infNo, status, reason, " ");
		this.updateSinfEps0036Info(info, infNo, response, obj);
		
		stringBuffer = this.getEps0036CodeJson(response);
		
		return stringBuffer;
	}
	
	private StringBuffer getEps0036CodeJson(String[] response) throws Exception{
		String       code         = response[0];
		String       message      = response[2];
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'").append(code).append("',");
		
		if("200".equals(code)){
			stringBuffer.append("message:'").append("그룹웨어품의가 연결되었습니다.").append("'");
		}
		else{
			//message = this.getRemoveLineSeparator(message);
			
			stringBuffer.append("message:'").append(message).append("'");			
		}
		
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
    
	
	private String insertSinfhdInfo(SepoaInfo info, String infCode, String infSend) throws Exception{
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		String              infNo     = null;
		String              houseCode = info.getSession("HOUSE_CODE");
		String              id        = this.getWebserviceId(info);
		boolean             flag      = false;
		
		param.put("HOUSE_CODE",     houseCode);
		param.put("INF_TYPE",       "W");
		param.put("INF_CODE",       infCode);
		param.put("INF_SEND",       infSend);
		param.put("INF_ID",         id);
		
		obj[0] = param;
		value  = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfhdInfo", obj);
		flag   = value.flag;
		
		if(flag == false){
			throw new Exception();
		}
		else{
			infNo = value.result[0];
		}
		
		return infNo;
	}
	
	private void insertSinfEps0036Info(SepoaInfo info, String infNo, DocLinkUrl eps0036) throws Exception{
		Map<String, String> svcParam  = new HashMap<String, String>();
		String              houseCode = info.getSession("HOUSE_CODE");
		String              sDocNo    = eps0036.getSDocNo();
		String              sEndDate  = eps0036.getSEndDate().replace("-", "");
		Object[]            obj       = new Object[1];
		SepoaOut            value     = null;
		boolean             isStatus  = false;
		
		svcParam.put("HOUSE_CODE",      houseCode);
		svcParam.put("INF_NO",          infNo);
		svcParam.put("DOC_NO",          "");
		svcParam.put("STATUS",          "P");
		svcParam.put("GW_COD_NO",       sDocNo);
		svcParam.put("APP_DATE",        sEndDate);
		svcParam.put("APP_TIME",        "");
		svcParam.put("GW_TITLE",        "");
		svcParam.put("DOC_LINK",        "");
		svcParam.put("REGISTER_DATE",   "");
		svcParam.put("APPROVAL_PRO_ID", "");
		svcParam.put("APPROVAL_INS_ID", "");
		
		obj[0]   = svcParam;
		value    = ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "insertSinfep0022_2Info", obj);
		isStatus = value.flag;
		
//		if(isStatus == false) {
//			throw new Exception(); 
//		}
	}
	
	private void updateSinfhdInfo(SepoaInfo info, String infNo, String status, String reason, String infReceiveNo){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		
		try{
			param.put("STATUS",         status);
			param.put("REASON",         reason);
			param.put("HOUSE_CODE",     houseCode);
			param.put("INF_NO",         infNo);
			param.put("INF_RECEIVE_NO", infReceiveNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfhdInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private void updateSinfEps0036Info(SepoaInfo info, String infNo, String[] response, Object[] pObj ){
		Map<String, String> param     = new HashMap<String, String>();
		Object[]            obj       = new Object[1];
		String              houseCode = info.getSession("HOUSE_CODE");
		String              code      = response[0];
		
		Map<String, String>    data   = null;
		
		
		try{
			if(pObj != null){
				data   = (Map<String, String>)((Map<String, Object>)pObj[0]).get("data");
				param.put("STATUS",    "E");
				param.put("DOC_NO",    data.get("INF_NO"));
				param.put("GW_TITLE",  response[3]);
				param.put("DOC_LINK",  response[1]);				
			}
			
			param.put("RETURN1",    code);
			param.put("RETURN2",    response[2]);
			param.put("RETURN3",    "");
			param.put("HOUSE_CODE", houseCode);
			param.put("INF_NO",     infNo);
			
			obj[0] = param;
			
			ServiceConnector.doService(info, "ws_eps", "TRANSACTION", "updateSinfep0022_2GwInfo", obj);
		}
		catch(Exception e){
			this.loggerExceptionStackTrace(e);
		}
	}
	
	private String getStringMaxByte(String target, int maxLength){
    	byte[] targetByteArray       = target.getBytes();
    	int    targetByteArrayLength = targetByteArray.length;
    	int    targetLength          = 0;
    	
    	while(targetByteArrayLength > maxLength){
    		targetLength          = target.length();
    		targetLength          = targetLength - 1;
    		target                = target.substring(0, targetLength);
    		targetByteArray       = target.getBytes();
    		targetByteArrayLength = targetByteArray.length;
    	}
    	
    	return target;
    }
	
	private String getRemoveLineSeparator(String target) throws Exception{
    	target = target.replace(System.getProperty("line.separator"), "");	    	
    	return target;
	}
	
	private DocLinkUrl getEps0036WebServiceEps0036(GridData gdReq, SepoaInfo info) throws Exception{
		DocLinkUrl eps0036     = new DocLinkUrl();
		String  sDocNo         = gdReq.getParam("gwDocNo");
		String  sEndDate       = gdReq.getParam("gwEndDate");
		
		eps0036.setSDocNo(sDocNo);
		eps0036.setSEndDate(sEndDate);
		
		return eps0036;
	}
	
	private StringBuffer getExceptionJson(Exception e){
		StringBuffer stringBuffer = new StringBuffer();
		String       stackTrace   = this.getExceptionStackTrace(e);
		
		try{
			stackTrace = this.getRemoveLineSeparator(stackTrace);
		}
		catch(Exception e1){
			stackTrace = "";
		}
		
		stringBuffer.append("{");
		stringBuffer.append(	"code:'900',");
		stringBuffer.append(	"useMessage:'서블릿에러발생',");
		stringBuffer.append(	"sysMessage:'").append(stackTrace).append("'");
		stringBuffer.append("}");
		
		return stringBuffer;
	}
	
	private String getWebserviceId(SepoaInfo info) throws Exception{
		String id = info.getSession("ID");
		
		if("ADMIN".equals(id)){
			id = "EPROADM";
		}
		
		return id;
	}
}