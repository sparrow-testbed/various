package os;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class sos_bd_ins1 extends HttpServlet{
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
//    		System.out.println("mode==="+mode);
    		if("requestList".equals(mode)){
    			gdRes = this.requestList(gdReq, info);
    		}
    		else if("createOs".equals(mode)){
    			gdRes = this.createOs(gdReq, info);
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private String prDTQuerySourcingPrNoSeq(String prData) throws Exception{
    	List<Map<String, String>> resultArray = new ArrayList<Map<String, String>>();
    	StringTokenizer           st1         = new StringTokenizer(prData, ",");
    	StringTokenizer           st2         = null;
    	String                    prDataToken = null;
    	String                    result      = null;
    	Map<String, String>       resultInfo  = null;
        int                       count1      = st1.countTokens();
        int                       j           = 0;
        
        for(j = 0; j< count1; j++){
        	resultInfo = new HashMap<String, String>();
        	
        	prDataToken = st1.nextToken();
        	
        	st2 = new StringTokenizer(prDataToken, "-");
        	
        	resultInfo.put("PR_NO", st2.nextToken());
        	resultInfo.put("PR_SEQ", st2.nextToken());
        	
        	resultArray.add(resultInfo);
        }
        
        result = this.getPrNoPrSeqInConditionStr(resultArray);
    	
    	return result;
    }
    
    private String getPrNoPrSeqInConditionStr(List<Map<String, String>> recvdata) throws Exception{
		String              result                = null;
		String              prNo                  = null;
		String              prSeq                 = null;
		StringBuffer        stringBuffer          = new StringBuffer();
		Map<String, String> recvdataInfo          = null;
		int                 recvdataSize          = recvdata.size();
		int                 i                     = 0;
		int                 recvdataSizeLastIndex = recvdataSize - 1;
		
		for(i = 0; i < recvdataSize; i++){
			recvdataInfo = recvdata.get(i);
			prNo         = recvdataInfo.get("PR_NO");
			prSeq        = recvdataInfo.get("PR_SEQ");
			
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
    
    private Object[] requestListHeader(GridData gdReq, SepoaInfo info) throws Exception{
    	Object[]            result     = new Object[1];
    	Map<String, String> resultInfo = new HashMap<String, String>();
    	Map<String, String> header     = this.getHeader(gdReq, info);
    	String              prData     = header.get("prData");
    	String              prNoSeq    = this.prDTQuerySourcingPrNoSeq(prData);
    	
    	resultInfo.put("prNoSeq", prNoSeq);
    	
    	result[0] = resultInfo;
    	
    	return result;
    }

	@SuppressWarnings({ "rawtypes"})
	private GridData requestList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData            gdRes            = new GridData();
	    SepoaFormater       sf               = null;
	    SepoaOut            value            = null;
	    HashMap             message          = null;
	    String[]            gridColAry       = null;
	    String              colKey           = null;
	    String              colValue         = null;
	    String              gdResMessage     = null;
	    Object[]            obj              = null;
	    int                 rowCount         = 0;
	    int                 gridColAryLength = 0;
	    int                 i                = 0;
	    int                 k                = 0;
	    boolean             isStatus         = false;
	
	    try{
	    	message          = this.getMessage(info);
	    	obj              = this.requestListHeader(gdReq, info);
	    	gridColAry       = this.getGridColArray(gdReq);
	    	gridColAryLength = gridColAry.length;
	    	gdRes            = OperateGridData.cloneResponseGridData(gdReq);
	    	value            = ServiceConnector.doService(info, "os_001", "CONNECTION", "requestList", obj);
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
	
	private String getOsNo(SepoaInfo info) throws Exception{
    	String   result = null;
    	SepoaOut wo2    = null;
    	
    	wo2    = DocumentUtil.getDocNumber(info, "OS");
    	result = wo2.result[0];
    	
    	return result;
    }
	
	private Map<String, String> createOsObjHeader(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
		Map<String, String> result          = new HashMap<String, String>();
		Map<String, String> header          = this.getHeader(gdReq, info);
		String              id              = info.getSession("ID");
		String              status          = header.get("status");
		String              shortDateString = SepoaDate.getShortDateString();
    	String              shortTimeString = SepoaDate.getShortTimeString();
    	String              iRfgFlag        = null;
    	String              signStatus      = null;
    	String              osqDate         = header.get("osqDate");
    	
    	if("T".equals(status)){
    		iRfgFlag   = "T";
    		signStatus = "T";
    	}
    	else if("P".equals(status)){
    		iRfgFlag   = "P";
    		signStatus = "E";
    	}
    	
    	osqDate = osqDate.replaceAll("/", "");
    	
		result.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
		result.put("OSQ_NO",             osqNo);
		result.put("OSQ_COUNT",          "1");
		result.put("STATUS",             "C");
		result.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
		result.put("OSQ_DATE",           shortDateString);
		result.put("OSQ_CLOSE_DATE",     osqDate);
		result.put("OSQ_CLOSE_TIME",     "235959");
		result.put("OSQ_TYPE",           "");
		result.put("PC_REASON",          "");
		result.put("SETTLE_TYPE",        "");
		result.put("BID_TYPE",           "");
		result.put("OSQ_FLAG",           iRfgFlag);
		result.put("TERM_CHANGE_FLAG",   "");
		result.put("CREATE_TYPE",        "");
		result.put("BID_COUNT",          "0");
		result.put("CTRL_CODE",          "");
		result.put("ADD_USER_ID",        id);
		result.put("ADD_DATE",           shortDateString);
		result.put("ADD_TIME",           shortTimeString);
		result.put("CHANGE_DATE",        shortDateString);
		result.put("CHANGE_TIME",        shortTimeString);
		result.put("CHANGE_USER_ID",     id);
		result.put("SUBJECT",            header.get("subject"));
		result.put("REMARK",             header.get("remark"));
		result.put("DOM_EXP_FLAG",       "");
		result.put("ARRIVAL_PORT",       "");
		result.put("USANCE_DAYS",        "");
		result.put("SHIPPING_METHOD",    "");
		result.put("PAY_TERMS",          "");
		result.put("ARRIVAL_PORT_NAME",  "");
		result.put("DELY_TERMS",         "");
		result.put("PRICE_TYPE",         "");
		result.put("SETTLE_COUNT",       "0");
		result.put("RESERVE_PRICE",      "0");
		result.put("CURRENT_PRICE",      "0");
		result.put("BID_DEC_AMT",        "0");
		result.put("TEL_NO",             "");
		result.put("EMAIL",              "");
		result.put("BD_TYPE",            "");
		result.put("CUR",                "");
		result.put("START_DATE",         "");
		result.put("START_TIME",         "");
		result.put("sms_yn",             "");
		result.put("z_result_open_flag", "");
		result.put("BID_REQ_TYPE",       "");
		result.put("H_ATTACH_NO",        header.get("attach_no"));
		result.put("SIGN_STATUS",        signStatus);
		
		return result;
	}
	
//	private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
//		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
//		List<Map<String, String>> grid            = this.getGrid(gdReq, info);
//		Map<String, String>       gridDataInfo    = null;
//		Map<String, String>       gridInfo        = null;
//		String                    id              = info.getSession("ID");
//		String                    rdDate          = null;
//		String                    osqSeq          = null;
//		String                    shortDateString = SepoaDate.getShortDateString();
//    	String                    shortTimeString = SepoaDate.getShortTimeString();
//		int                       gridSize        = grid.size();
//		int                       i               = 0;
//		
//		for(i = 0; i < gridSize; i++){
//			gridDataInfo = new HashMap<String, String>();
//			
//			gridInfo = grid.get(i);
//			rdDate   = gridInfo.get("RD_DATE");
//			rdDate   = rdDate.replaceAll("/", "");
//			osqSeq   = Integer.toString(i + 1);
//			
//			gridDataInfo.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
//			gridDataInfo.put("OSQ_NO",              osqNo);
//			gridDataInfo.put("OSQ_COUNT",           "1");
//			gridDataInfo.put("OSQ_SEQ",             osqSeq);
//			gridDataInfo.put("STATUS",              "C");
//			gridDataInfo.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
//			gridDataInfo.put("PLANT_CODE",          "");
//			gridDataInfo.put("OSQ_PROCEEDING_FLAG", "N");
//			gridDataInfo.put("ADD_DATE",            shortDateString);
//			gridDataInfo.put("ADD_TIME",            shortTimeString);
//			gridDataInfo.put("ADD_USER_ID",         id);
//			gridDataInfo.put("CHANGE_DATE",         shortDateString);
//			gridDataInfo.put("CHANGE_TIME",         shortTimeString);
//			gridDataInfo.put("CHANGE_USER_ID",      id);
//			gridDataInfo.put("ITEM_NO",             gridInfo.get("ITEM_NO"));
//			gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("BASIC_UNIT"));
//			gridDataInfo.put("RD_DATE",             rdDate);
//			gridDataInfo.put("VALID_FROM_DATE",     "");
//			gridDataInfo.put("VALID_TO_DATE",       "");
//			gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
//			gridDataInfo.put("OSQ_QTY",             gridInfo.get("PR_QTY"));
//			gridDataInfo.put("OSQ_AMT",             gridInfo.get("INFO_UNIT_PRICE"));
//			gridDataInfo.put("BID_COUNT",           "0");
//			gridDataInfo.put("CUR",                 "");
//			gridDataInfo.put("PR_NO",               gridInfo.get("PR_NO"));
//			gridDataInfo.put("PR_SEQ",              gridInfo.get("PR_SEQ"));
//			gridDataInfo.put("SETTLE_FLAG",         "N");
//			gridDataInfo.put("SETTLE_QTY",          "0");
//			gridDataInfo.put("TBE_FLAG",            "");
//			gridDataInfo.put("TBE_DEPT",            "");
//			gridDataInfo.put("PRICE_TYPE",          "");
//			gridDataInfo.put("TBE_PROCEEDING_FLAG", "");
//			gridDataInfo.put("SAMPLE_FLAG",         "");
//			gridDataInfo.put("DELY_TO_LOCATION",    "");
//			gridDataInfo.put("ATTACH_NO",           gridInfo.get("ATTACH_NO"));
//			gridDataInfo.put("SHIPPER_TYPE",        "");
//			gridDataInfo.put("CONTRACT_FLAG",       "");
//			gridDataInfo.put("COST_COUNT",          "");
//			gridDataInfo.put("YEAR_QTY",            "");
//			gridDataInfo.put("DELY_TO_ADDRESS",     gridInfo.get("DELY_TO_ADDRESS"));
//			gridDataInfo.put("MIN_PRICE",           "0");
//			gridDataInfo.put("MAX_PRICE",           "0");
//			gridDataInfo.put("STR_FLAG",            "");
//			gridDataInfo.put("TBE_NO",              "");
//			gridDataInfo.put("Z_REMARK",            gridInfo.get("REMARK"));
//			gridDataInfo.put("TECHNIQUE_GRADE",     "");
//			gridDataInfo.put("TECHNIQUE_TYPE",      "");
//			gridDataInfo.put("INPUT_FROM_DATE",     "");
//			gridDataInfo.put("INPUT_TO_DATE",       "");
//			gridDataInfo.put("TECHNIQUE_FLAG",      "");
//			gridDataInfo.put("SPECIFICATION",       gridInfo.get("SPECIFICATION"));
//			gridDataInfo.put("MAKER_NAME",          "");
//			gridDataInfo.put("MAKE_AMT_CODE",       gridInfo.get("MAKE_AMT_CODE"));
//			gridDataInfo.put("P_ITEM_NO",       gridInfo.get("P_ITEM_NO"));
//			gridDataInfo.put("DELY_TO_DEPT",       gridInfo.get("DELY_TO_ADDRESS_CD"));
//			gridDataInfo.put("WID",       gridInfo.get("WID"));
//			gridDataInfo.put("HGT",       gridInfo.get("HGT"));
//			
//			result.add(gridDataInfo);
//		}
//		
//		return result;
//	}
	
	private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid            = this.getGrid(gdReq, info);
		Map<String, String>       gridDataInfo    = null;
		Map<String, String>       gridInfo        = null;
		String                    id              = info.getSession("ID");
		String                    rdDate          = null;
		String                    osqSeq          = null;
		String                    makeAmtCode = null;
		String                    shortDateString = SepoaDate.getShortDateString();
    	String                    shortTimeString = SepoaDate.getShortTimeString();
		int                       gridSize        = grid.size();
		int                       i               = 0;
		int                       iPrQty       = 0;
		int                       j               = 0;
		int                       k              = 0;
		
		for(i = 0; i < gridSize; i++){
			
			gridInfo = grid.get(i);
			rdDate   = gridInfo.get("RD_DATE");
			rdDate   = rdDate.replaceAll("/", "");			
			makeAmtCode = gridInfo.get("MAKE_AMT_CODE");
			iPrQty    = Integer.parseInt(gridInfo.get("PR_QTY"));
						
			//결정코드가 실사대상 품목인 경우
			if(makeAmtCode.equals("01") || makeAmtCode.equals("02") || makeAmtCode.equals("03")){				
				    
					for(j = 0; j < iPrQty; j++){				
						osqSeq   = Integer.toString(++k);
						
						gridDataInfo = new HashMap<String, String>();
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
						gridDataInfo.put("OSQ_QTY",             "1");
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
						gridDataInfo.put("WID",       gridInfo.get("WID"));
						gridDataInfo.put("HGT",       gridInfo.get("HGT"));
						
						result.add(gridDataInfo);			
					}
			}else{
				osqSeq   = Integer.toString(++k);
				
				gridDataInfo = new HashMap<String, String>();
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
				gridDataInfo.put("WID",       gridInfo.get("WID"));
				gridDataInfo.put("HGT",       gridInfo.get("HGT"));
				
				result.add(gridDataInfo);							
			}
			
			
			
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
	
//	private List<Map<String, String>> createOsObjSosseData(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
//		List<Map<String, String>> result      = new ArrayList<Map<String, String>>();
//		List<Map<String, String>> grid        = this.getGrid(gdReq, info);
//		Map<String, String>       gridInfo    = null;
//		Map<String, String>       resultInfo  = null;
//		String                    houseCode   = info.getSession("HOUSE_CODE");
//		String                    id          = info.getSession("ID");
//		String                    companyCode = info.getSession("COMPANY_CODE");
//		String                    osqSeq      = null;
//		String                    vendorCode  = null;
//		int                       gridSize    = grid.size();
//		int                       i           = 0;
//		
//		for(i = 0; i < gridSize; i++){
//			resultInfo = new HashMap<String, String>();
//			
//			gridInfo   = grid.get(i);
//			vendorCode = gridInfo.get("VENDOR_CODE");
//			osqSeq     = Integer.toString(i + 1);
//			
//			resultInfo.put("HOUSE_CODE",   houseCode);
//			resultInfo.put("OSQ_NO",       osqNo);
//			resultInfo.put("OSQ_COUNT",    "1");
//			resultInfo.put("OSQ_SEQ",      osqSeq);
//			resultInfo.put("VENDOR_CODE",  vendorCode);
//			resultInfo.put("STATUS",       "C");
//			resultInfo.put("COMPANY_CODE", companyCode);
//			resultInfo.put("CONFIRM_FLAG", "S");
//			resultInfo.put("ADD_USER_ID",  id);
//			
//			result.add(resultInfo);
//		}
//		
//		return result;
//	}
	
	
	private List<Map<String, String>> createOsObjSosseData(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
		List<Map<String, String>> result      = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid        = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo    = null;
		Map<String, String>       resultInfo  = null;
		String                    houseCode   = info.getSession("HOUSE_CODE");
		String                    id          = info.getSession("ID");
		String                    companyCode = info.getSession("COMPANY_CODE");
		String                    osqSeq      = null;
		String                    vendorCode  = null;
		String                    makeAmtCode = null;
		int                       gridSize    = grid.size();
		int                       i           = 0;
		int                       iPrQty       = 0;
		int                       j               = 0;
		int                       k              = 0;
				
		for(i = 0; i < gridSize; i++){
			
			gridInfo   = grid.get(i);
			vendorCode = gridInfo.get("VENDOR_CODE");
			makeAmtCode = gridInfo.get("MAKE_AMT_CODE");
			iPrQty    = Integer.parseInt(gridInfo.get("PR_QTY"));
			
			//결정코드가 실사대상 품목인 경우
			if(makeAmtCode.equals("01") || makeAmtCode.equals("02") || makeAmtCode.equals("03")){				
					for(j = 0; j < iPrQty; j++){				
						osqSeq   = Integer.toString(++k);
						
						resultInfo = new HashMap<String, String>();						
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
			}else{
					osqSeq   = Integer.toString(++k);
					
					resultInfo = new HashMap<String, String>();					
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
		}
		
		
		return result;
	}
	
	
	private Object[] createOsObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result        = new Object[1];
		Map<String, Object>       resultInfo    = new HashMap<String, Object>();
		Map<String, String>       heaerParam    = null;
		String                    osqNo         = this.getOsNo(info);
		List<Map<String, String>> gridData      = null;
		List<Map<String, String>> prConfirmData = null;
		List<Map<String, String>> sosseData     = null;
		
		heaerParam    = this.createOsObjHeader(gdReq, info, osqNo);
		gridData      = this.createOsObjGrid(gdReq, info, osqNo);
		prConfirmData = this.createOsObjPrConfirmData(gdReq, info);
		sosseData     = this.createOsObjSosseData(gdReq, info, osqNo);
		
		resultInfo.put("header",        heaerParam);
		resultInfo.put("gridData",      gridData);
		resultInfo.put("prConfirmData", prConfirmData);
		resultInfo.put("sosseData",     sosseData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData createOs(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.createOsObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "os_001", "TRANSACTION", "createOs", obj);
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