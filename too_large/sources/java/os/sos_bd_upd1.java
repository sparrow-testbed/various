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
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class sos_bd_upd1 extends HttpServlet{
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
    		
    		if("updateOs".equals(mode)){
    			gdRes = this.updateOs(gdReq, info);
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
    
    @SuppressWarnings({ "unchecked" })
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
    
	@SuppressWarnings("unused")
	private String[] getGridColArray(GridData gdReq) throws Exception{
    	String[] result    = null;
    	String   gridColId = gdReq.getParam("cols_ids");
    	
    	gridColId = JSPUtil.paramCheck(gridColId);
    	gridColId = gridColId.trim();
    	result    = SepoaString.parser(gridColId, ",");
    	
    	return result;
    }
    
    
    private Map<String, String> updateOsObjUpdateSosglInfo(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result     = new HashMap<String, String>();
    	Map<String, String> header     = this.getHeader(gdReq, info);
    	String              houseCode  = info.getSession("HOUSE_CODE");
    	String              status     = header.get("status");
    	String              subject    = header.get("subject");
    	String              osqDate    = header.get("osqDate");
    	String              remark     = header.get("remark");
    	String              attachNo   = header.get("attach_no");
    	String              osqNo      = header.get("osqNo");
    	String              osqCount   = header.get("osqCount");
    	String              iOsqFlag   = null;
    	String              signStatus = null;
    	
    	osqDate = osqDate.replaceAll("/", "");
    	
    	if("T".equals(status)){
    		iOsqFlag   = "T";
    		signStatus = "T";
    	}
    	else if("P".equals(status)){
    		iOsqFlag   = "P";
    		signStatus = "E";
    	}
    	
    	result.put("OSQ_FLAG",       iOsqFlag);
    	result.put("SUBJECT",        subject);
    	result.put("OSQ_CLOSE_DATE", osqDate);
    	result.put("REMARK",         remark);
    	result.put("ATTACH_NO",      attachNo);
    	result.put("HOUSE_CODE",     houseCode);
    	result.put("OSQ_NO",         osqNo);
    	result.put("OSQ_COUNT",      osqCount);
    	result.put("SIGN_STATUS",    signStatus);
    	
    	return result;
    }
    
    private Map<String, String> updateOsObjDeleteSoInfo(GridData gdReq, SepoaInfo info) throws Exception{
    	Map<String, String> result    = new HashMap<String, String>();
    	Map<String, String> header    = this.getHeader(gdReq, info);
    	String              houseCode = info.getSession("HOUSE_CODE");
    	String              osqNo     = header.get("osqNo");
    	String              osqCount  = header.get("osqCount");
    	
    	result.put("HOUSE_CODE",     houseCode);
    	result.put("OSQ_NO",         osqNo);
    	result.put("OSQ_COUNT",      osqCount);
    	
    	return result;
    }
    
    private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid            = this.getGrid(gdReq, info);
		Map<String, String>       gridDataInfo    = null;
		Map<String, String>       gridInfo        = null;
		Map<String, String>       header          = this.getHeader(gdReq, info);
		String                    id              = info.getSession("ID");
		String                    rdDate          = null;
		String                    osqSeq          = null;
		String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
    	String                    osqNo           = header.get("osqNo");
		int                       gridSize        = grid.size();
		int                       i               = 0;
		
		for(i = 0; i < gridSize; i++){
			gridDataInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			rdDate   = gridInfo.get("RD_DATE");
			rdDate   = rdDate.replaceAll("/", "");
			osqSeq   = Integer.toString(i + 1);
			
			gridDataInfo.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
			gridDataInfo.put("OSQ_NO",              osqNo);
			gridDataInfo.put("OSQ_COUNT",           "1");
			gridDataInfo.put("OSQ_SEQ",             osqSeq);
			gridDataInfo.put("STATUS",              "C");
			gridDataInfo.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
			gridDataInfo.put("PLANT_CODE",          "");
			gridDataInfo.put("OSQ_PROCEEDING_FLAG", "N");
			gridDataInfo.put("ADD_DATE",            shortDateString);
			gridDataInfo.put("ADD_TIME",            shortTimeString);
			gridDataInfo.put("ADD_USER_ID",         id);
			gridDataInfo.put("CHANGE_DATE",         shortDateString);
			gridDataInfo.put("CHANGE_TIME",         shortTimeString);
			gridDataInfo.put("CHANGE_USER_ID",      id);
			gridDataInfo.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
			gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("BASIC_UNIT"));
			gridDataInfo.put("RD_DATE",             rdDate);
			gridDataInfo.put("VALID_FROM_DATE",     "");
			gridDataInfo.put("VALID_TO_DATE",       "");
			gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
			gridDataInfo.put("OSQ_QTY",             gridInfo.get("PR_QTY"));
			gridDataInfo.put("OSQ_AMT",             gridInfo.get("INFO_UNIT_PRICE"));
			gridDataInfo.put("BID_COUNT",           "0");
			gridDataInfo.put("CUR",                 "");
			gridDataInfo.put("PR_NO",               gridInfo.get("PR_NO"));
			gridDataInfo.put("PR_SEQ",              gridInfo.get("PR_SEQ"));
			gridDataInfo.put("SETTLE_FLAG",         "N");
			gridDataInfo.put("SETTLE_QTY",          "0");
			gridDataInfo.put("TBE_FLAG",            "");
			gridDataInfo.put("TBE_DEPT",            "");
			gridDataInfo.put("PRICE_TYPE",          "");
			gridDataInfo.put("TBE_PROCEEDING_FLAG", "");
			gridDataInfo.put("SAMPLE_FLAG",         "");
			gridDataInfo.put("DELY_TO_LOCATION",    "");
			gridDataInfo.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
			gridDataInfo.put("SHIPPER_TYPE",        "");
			gridDataInfo.put("CONTRACT_FLAG",       "");
			gridDataInfo.put("COST_COUNT",          "");
			gridDataInfo.put("YEAR_QTY",            "");
			gridDataInfo.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
			gridDataInfo.put("MIN_PRICE",           "0");
			gridDataInfo.put("MAX_PRICE",           "0");
			gridDataInfo.put("STR_FLAG",            "");
			gridDataInfo.put("TBE_NO",              "");
			gridDataInfo.put("Z_REMARK",            gridInfo.get("REMARK"));
			gridDataInfo.put("TECHNIQUE_GRADE",     "");
			gridDataInfo.put("TECHNIQUE_TYPE",      "");
			gridDataInfo.put("INPUT_FROM_DATE",     "");
			gridDataInfo.put("INPUT_TO_DATE",       "");
			gridDataInfo.put("TECHNIQUE_FLAG",      "");
			gridDataInfo.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
			gridDataInfo.put("MAKER_NAME",          "");
			gridDataInfo.put("MAKE_AMT_CODE",       gridInfo.get("MAKE_AMT_CODE"));
			gridDataInfo.put("P_ITEM_NO",       gridInfo.get("P_ITEM_NO"));
			gridDataInfo.put("DELY_TO_DEPT",       gridInfo.get("DELY_TO_ADDRESS_CD"));
			
			result.add(gridDataInfo);
		}
		
		return result;
	}
    
    private List<Map<String, String>> createOsObjSosseData(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result      = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid        = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo    = null;
		Map<String, String>       resultInfo  = null;
		Map<String, String>       header      = this.getHeader(gdReq, info);
		String                    houseCode   = info.getSession("HOUSE_CODE");
		String                    id          = info.getSession("ID");
		String                    companyCode = info.getSession("COMPANY_CODE");
		String                    osqSeq      = null;
		String                    vendorCode  = null;
		String                    osqNo       = header.get("osqNo");
		int                       gridSize    = grid.size();
		int                       i           = 0;
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo   = grid.get(i);
			vendorCode = gridInfo.get("VENDOR_CODE");
			osqSeq     = Integer.toString(i + 1);
			
			resultInfo.put("HOUSE_CODE",   houseCode);
			resultInfo.put("OSQ_NO",       osqNo);
			resultInfo.put("OSQ_COUNT",    "1");
			resultInfo.put("OSQ_SEQ",      osqSeq);
			resultInfo.put("VENDOR_CODE",  vendorCode);
			resultInfo.put("STATUS",       "C");
			resultInfo.put("COMPANY_CODE", companyCode);
			resultInfo.put("CONFIRM_FLAG", "S");
			resultInfo.put("ADD_USER_ID",  id);
			
			result.add(resultInfo);
		}
		
		return result;
	}
    
    private List<Map<String, String>> createOsObjPrConfirmData(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid       = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo   = null;
		Map<String, String>       resultInfo = null;
		Map<String, String>       header     = this.getHeader(gdReq, info);
		String                    houseCode  = info.getSession("HOUSE_CODE");
		String                    prNo       = null;
		String                    prSeq      = null;
		String                    status     = header.get("status");
		String                    bidStatus  = null;
		String                    prQty      = null;
		int                       gridSize   = grid.size();
		int                       i          = 0;
		
		if("T".equals(status)){
			bidStatus = "GA";
		}
		else if("P".equals(status)){
			bidStatus = "GB";
		}
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			prNo     = gridInfo.get("PR_NO");
			prSeq    = gridInfo.get("PR_SEQ");
			prQty    = gridInfo.get("PR_QTY");
			
			resultInfo.put("OSQ_QTY",    prQty);
			resultInfo.put("BID_STATUS", bidStatus);
			resultInfo.put("HOUSE_CODE", houseCode);
			resultInfo.put("PR_NO",      prNo);
			resultInfo.put("PR_SEQ",     prSeq);
			
			result.add(resultInfo);
		}
		
		return result;
	}
    
    private Object[] updateOsObj(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]                  result          = new Object[1];
    	Map<String, Object>       resultInfo      = new HashMap<String, Object>();
    	Map<String, String>       updateSosglInfo = this.updateOsObjUpdateSosglInfo(gdReq, info);
    	Map<String, String>       deleteSoInfo    = this.updateOsObjDeleteSoInfo(gdReq, info);
    	List<Map<String, String>> insertSosln     = this.createOsObjGrid(gdReq, info);
    	List<Map<String, String>> insertSosse     = this.createOsObjSosseData(gdReq, info);
    	List<Map<String, String>> updateIcoyprdt  = this.createOsObjPrConfirmData(gdReq, info);
    	
    	resultInfo.put("updateSosglInfo", updateSosglInfo);
    	resultInfo.put("deleteSoInfo",    deleteSoInfo);
    	resultInfo.put("insertSosln",     insertSosln);
    	resultInfo.put("insertSosse",     insertSosse);
    	resultInfo.put("updateIcoyprdt",  updateIcoyprdt);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }
    
    @SuppressWarnings({ "rawtypes"})
    private GridData updateOs(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.updateOsObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_004", "TRANSACTION", "updateOs", obj);
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