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

public class sos_bd_ins0 extends HttpServlet{
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
    		if("createOs".equals(mode)){
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
	
	private String getOsNo(SepoaInfo info) throws Exception{
    	String   result = null;
    	SepoaOut wo2    = null;
    	
    	wo2    = DocumentUtil.getDocNumber(info, "OS");
    	result = wo2.result[0];
    	
    	return result;
    }
	
	/**
	 * 문서번호를 따오는 메소드인가?
	 * 
	 * @param info
	 * @param docType
	 * @return String
	 * @throws Exception
	 */
	private String getPrNo(SepoaInfo info) throws Exception{
		SepoaOut wo   = DocumentUtil.getDocNumber(info, "PR");
	    String   prNo = wo.result[0];
	    
	    return prNo;
	}
	
	/**
	 * et_setPrHDCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param header
	 * @return Map
	 * @throws Exception
	 */
//	private Map<String, String> prHdCreateParam(GridData gdReq, SepoaInfo info, String prNo) throws Exception{		
//		Map<String, String> result          = new HashMap<String, String>();
//		Map<String, String> header          = this.getHeader(gdReq, info);
//		
//		
//		String                    sign_status      = null;
//	    String                    sign_date        = null;
//		String                    sign_person_id   = null;
//		String                    sign_person_name = null;
//		
//		sign_status = header.get("sign_status");
//		
//		
//		if("E".equals(sign_status)){
//			sign_date        = SepoaDate.getShortDateString();				
//			sign_person_id   = info.getSession("ID");
//			sign_person_name = info.getSession("NAME_LOC");
//		}
//		else{
//			sign_date        = "";
//			sign_person_id   = "";
//			sign_person_name = "";
//		}
//		
//		
//		result.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
//		result.put("PR_NO",               prNo);
//		result.put("STATUS",               "C");
//		result.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
//		result.put("PLANT_CODE",          info.getSession("DEPARTMENT"));
//		result.put("PR_TOT_AMT",          header.get("pr_tot_amt"));
//		result.put("PR_TYPE",             "I");
//		result.put("DEMAND_DEPT",         header.get("demand_dept"));
//		result.put("SIGN_STATUS",         header.get("sign_status"));
//		result.put("SIGN_DATE",           sign_date);
//		result.put("SIGN_PERSON_ID",      sign_person_id);
//		result.put("SIGN_PERSON_NAME",    sign_person_name);
//		result.put("DEMAND_DEPT_NAME",    header.get("demand_dept_name"));
//		result.put("REMARK",              header.get("remark"));
//		result.put("SUBJECT",             header.get("subject"));
//		result.put("PR_LOCATION",         info.getSession("LOCATION_CODE"));				
//// NULL 처리           result.put("ORDER_NO",            header.get("order_no"));		
//		result.put("SALES_USER_DEPT",     info.getSession("DEPARTMENT"));				
//		result.put("SALES_USER_ID",       info.getSession("ID"));		
//		result.put("CONTRACT_HOPE_DAY",   SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),7));		
//		result.put("CUST_CODE",           "0000100000");		
//		result.put("CUST_NAME",           "기타(계획용)");		
//		result.put("EXPECT_AMT",          header.get("expect_amt"));		
//		result.put("SALES_TYPE",          "P");		
//// NULL 처리           result.put("ORDER_NAME",          header.get("order_name"));		
//		result.put("REQ_TYPE",            "P");		
//		result.put("RETURN_HOPE_DAY",     SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),7));		
//		result.put("ATTACH_NO",           header.get("attach_no"));	
//// NULL 처리           result.put("HARD_MAINTANCE_TERM", header.get("hard_maintance_term"));
//// NULL 처리           result.put("SOFT_MAINTANCE_TERM", header.get("soft_maintance_term"));
//		result.put("CREATE_TYPE",         "PR");		
//		result.put("ADD_USER_ID",         info.getSession("ID"));
//		result.put("CHANGE_USER_ID",      info.getSession("ID"));		
//// NULL 처리           result.put("BSART",               header.get("bsart"));
//// NULL 처리           result.put("CUST_TYPE",           header.get("cust_type"));		
//		result.put("ADD_DATE",            header.get("osqDate"));		
//		result.put("AHEAD_FLAG",          "N");		
//// NULL 처리           result.put("CONTRACT_FROM_DATE",  header.get("contract_from_date"));
//// NULL 처리           result.put("CONTRACT_TO_DATE",    header.get("contract_to_date"));	
//// NULL 처리           result.put("SALES_AMT",           header.get("sales_amt"));
//// NULL 처리           result.put("PROJECT_PM",          header.get("project_pm"));
//// NULL 처리           result.put("ORDER_COUNT",         header.get("order_count"));
//// NULL 처리           result.put("WBS",                 header.get("pjt_seq"));
//// NULL 처리           result.put("WBS_NAME",            header.get("pjt_name"));
//// NULL 처리           result.put("DELY_TO_LOCATION",    header.get("dely_location"));
//// NULL 처리           result.put("DELY_TO_ADDRESS",     header.get("dely_to_address"));
//// NULL 처리           result.put("DELY_TO_USER",        header.get("dely_to_user"));
//// NULL 처리           result.put("DELY_TO_PHONE",       header.get("dely_to_phone"));
//		result.put("PC_FLAG",             "N");
//// NULL 처리           result.put("PC_REASON",         header.get("pc_reason")); 	
//		
//		return result;
//	}
	
	/**
	 * et_setPrDTCreate 메소드를 수행하기 위한 파라미터 맵을 구성하여 반환하는 메소드
	 * 
	 * @param head
	 * @return
	 * @throws Exception
	 */
//	private List<Map<String, String>> prDtCreateParam(GridData gdReq, SepoaInfo info, String prNo) throws Exception{
//		List<Map<String, String>> result          = new ArrayList<Map<String, String>>();
//		List<Map<String, String>> grid            = this.getGrid(gdReq, info);		
//		Map<String, String> header        = this.getHeader(gdReq, info);
//		Map<String, String>       gridDataInfo    = null;
//		Map<String, String>       gridInfo        = null;
//		String                    id              = info.getSession("ID");
//		String                    rdDate          = null;
//		String                    shortDateString = SepoaDate.getShortDateString();
//    	String                    shortTimeString = SepoaDate.getShortTimeString();
//		int                       gridSize        = grid.size();
//		int                       i               = 0;
//		
//	
//		for(i = 0; i < gridSize; i++){
//			gridDataInfo = new HashMap<String, String>();
//			
//			gridInfo = grid.get(i);
//			rdDate   = gridInfo.get("RD_DATE");
//			rdDate   = rdDate.replaceAll("/", "");
//			
//			gridDataInfo.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
//			gridDataInfo.put("PR_NO",              prNo);
//			gridDataInfo.put("PR_SEQ",             gridInfo.get("PR_SEQ"));
//			gridDataInfo.put("STATUS",             "C");
//			gridDataInfo.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
//			gridDataInfo.put("PLANT_CODE",         header.get("plan_code"));
//			gridDataInfo.put("ITEM_NO",            gridInfo.get("ITEM_NO"));			
//			gridDataInfo.put("PR_PROCEEDING_FLAG", gridInfo.get("PR_PROCEEDING_FLAG"));
//			gridDataInfo.put("CTRL_CODE",          gridInfo.get("CTRL_CODE"));
//			gridDataInfo.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
//			gridDataInfo.put("PR_QTY",             gridInfo.get("PR_QTY"));
//			gridDataInfo.put("CUR",                gridInfo.get("CUR"));
//			gridDataInfo.put("UNIT_PRICE",         gridInfo.get("UNIT_PRICE"));
//			gridDataInfo.put("PR_AMT",             gridInfo.get("PR_AMT"));
//			gridDataInfo.put("RD_DATE",            rdDate);
//			gridDataInfo.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
//			gridDataInfo.put("REC_VENDOR_CODE",    gridInfo.get("REC_VENDOR_CODE"));
//			gridDataInfo.put("DELY_TO_LOCATION",   header.get("dely_to_location"));
//			gridDataInfo.put("REC_VENDOR_NAME",    gridInfo.get("REC_VENDOR_NAME"));
//			gridDataInfo.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
//			gridDataInfo.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
//			gridDataInfo.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
//			gridDataInfo.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
//			gridDataInfo.put("REMARK",             gridInfo.get("REMARK"));
//			gridDataInfo.put("PURCHASE_LOCATION",  gridInfo.get("PURCHASE_LOCATION"));
//			gridDataInfo.put("PURCHASER_ID",       gridInfo.get("PURCHASER_ID"));
//			gridDataInfo.put("PURCHASER_NAME",     gridInfo.get("PURCHASER_NAME"));
//			gridDataInfo.put("PURCHASE_DEPT",      gridInfo.get("PURCHASE_DEPT"));
//			gridDataInfo.put("PURCHASE_DEPT_NAME", gridInfo.get("PURCHASE_DEPT_NAME"));
//			gridDataInfo.put("TECHNIQUE_GRADE",    gridInfo.get("TECHNIQUE_GRADE"));
//			gridDataInfo.put("TECHNIQUE_TYPE",     gridInfo.get("TECHNIQUE_TYPE"));
//			gridDataInfo.put("INPUT_FROM_DATE",    gridInfo.get("INPUT_FROM_DATE"));
//			gridDataInfo.put("INPUT_TO_DATE",      gridInfo.get("INPUT_TO_DATE"));
//			gridDataInfo.put("ADD_USER_ID",        header.get("add_user_id"));
//			gridDataInfo.put("CHANGE_USER_ID",     header.get("add_user_id"));
//			gridDataInfo.put("KNTTP",              header.get("knttp"));
//			gridDataInfo.put("ZEXKN",              header.get("zexkn"));
//			gridDataInfo.put("ORDER_NO",           header.get("order_no"));
//			gridDataInfo.put("ORDER_SEQ",          gridInfo.get("ORDER_SEQ"));
//			gridDataInfo.put("BS_NO",              gridInfo.get("WBS_NO"));
//			gridDataInfo.put("WBS_SUB_NO",         gridInfo.get("WBS_SUB_NO"));
//			gridDataInfo.put("WBS_TXT",            gridInfo.get("WBS_TXT"));
//			gridDataInfo.put("CONTRACT_DIV",       gridInfo.get("CONTRACT_DIV"));
//			gridDataInfo.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
//			gridDataInfo.put("WARRANTY",           gridInfo.get("WARRANTY"));
//			gridDataInfo.put("EXCHANGE_RATE",      gridInfo.get("EXCHANGE_RATE"));
//		    gridDataInfo.put("WBS_NAME",           gridInfo.get("WBS_NAME"));
//		    gridDataInfo.put("ORDER_COUNT",        header.get("order_count"));
//		    gridDataInfo.put("PRE_TYPE",           gridInfo.get("PRE_TYPE"));
//		    gridDataInfo.put("PRE_PO_NO",          gridInfo.get("PRE_PO_NO")); 
//		    gridDataInfo.put("PRE_PO_SEQ",         gridInfo.get("PRE_PO_SEQ"));
//		    gridDataInfo.put("ACCOUNT_TYPE",       gridInfo.get("ACCOUNT_TYPE"));
//		    gridDataInfo.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
//		    gridDataInfo.put("DELY_TO_ADDRESS_CD", gridInfo.get("DELY_TO_ADDRESS_CD"));
//		    gridDataInfo.put("P_ITEM_NO",          gridInfo.get("P_ITEM_NO"));
//		    gridDataInfo.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
//		    gridDataInfo.put("APP_DIV",            gridInfo.get("APP_DIV"));
//		    gridDataInfo.put("KTEXT",              gridInfo.get("KTEXT"));
//		    gridDataInfo.put("KAMT",               gridInfo.get("KAMT"));
//		    gridDataInfo.put("DEMAND_DEPT",         header.get("demand_dept"));
//		    
//		    result.add(gridDataInfo);
//		}
//	    
//		return result;
//	}
	
	private Map<String, String> createOsObjHeader(GridData gdReq, SepoaInfo info, String osqNo) throws Exception{
		Map<String, String> result          = new HashMap<String, String>();
		Map<String, String> header          = this.getHeader(gdReq, info);
		String              id              = info.getSession("ID");
		String              status          = header.get("sign_status");
		String              shortDateString = SepoaDate.getShortDateString();
    	String              shortTimeString = SepoaDate.getShortTimeString();
    	String              iRfgFlag        = null;
    	String              signStatus      = null;
    	String              osqDate         = header.get("osqDate");
    	
    	if("T".equals(status)){
    		iRfgFlag   = "T";
    		signStatus = "T";
    	}
    	else if("E".equals(status)){
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
		result.put("BID_TYPE",           "1");
		result.put("OSQ_FLAG",           iRfgFlag);
		result.put("TERM_CHANGE_FLAG",   "Y"); //구매없이 실사요청
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
	
//	private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info, String osqNo, String prNo) throws Exception{
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
//			gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
//			gridDataInfo.put("RD_DATE",             rdDate);
//			gridDataInfo.put("VALID_FROM_DATE",     "");
//			gridDataInfo.put("VALID_TO_DATE",       "");
//			gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
//			gridDataInfo.put("OSQ_QTY",             gridInfo.get("PR_QTY"));
//			gridDataInfo.put("OSQ_AMT",             gridInfo.get("UNIT_PRICE"));
//			gridDataInfo.put("BID_COUNT",           "0");
//			gridDataInfo.put("CUR",                 "");
//			gridDataInfo.put("PR_NO",               prNo);
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
//			gridDataInfo.put("P_SEQ",              gridInfo.get("P_SEQ"));
//			gridDataInfo.put("DELY_TO_DEPT",       gridInfo.get("DELY_TO_ADDRESS_CD"));
//			gridDataInfo.put("WID",       gridInfo.get("WID"));
//			gridDataInfo.put("HGT",       gridInfo.get("HGT"));
//			
//			result.add(gridDataInfo);
//		}
//		
//		return result;
//	}
	
	private List<Map<String, String>> createOsObjGrid(GridData gdReq, SepoaInfo info, String osqNo, String prNo) throws Exception{
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
						gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
						gridDataInfo.put("RD_DATE",             rdDate);
						gridDataInfo.put("VALID_FROM_DATE",     "");
						gridDataInfo.put("VALID_TO_DATE",       "");
						gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
						gridDataInfo.put("OSQ_QTY",             "1");
						gridDataInfo.put("OSQ_AMT",             gridInfo.get("UNIT_PRICE"));
						gridDataInfo.put("BID_COUNT",           "0");
						gridDataInfo.put("CUR",                 "");
						gridDataInfo.put("PR_NO",               prNo);
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
						gridDataInfo.put("P_SEQ",              gridInfo.get("P_SEQ"));
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
				gridDataInfo.put("UNIT_MEASURE",        gridInfo.get("UNIT_MEASURE"));
				gridDataInfo.put("RD_DATE",             rdDate);
				gridDataInfo.put("VALID_FROM_DATE",     "");
				gridDataInfo.put("VALID_TO_DATE",       "");
				gridDataInfo.put("PURCHASE_PRE_PRICE",  "");
				gridDataInfo.put("OSQ_QTY",             gridInfo.get("PR_QTY"));
				gridDataInfo.put("OSQ_AMT",             gridInfo.get("UNIT_PRICE"));
				gridDataInfo.put("BID_COUNT",           "0");
				gridDataInfo.put("CUR",                 "");
				gridDataInfo.put("PR_NO",               prNo);
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
				gridDataInfo.put("P_SEQ",              gridInfo.get("P_SEQ"));
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
		String                    status     = header.get("sign_status");
		String                    bidStatus  = null;
		String                    prQty      = null;
		int                       gridSize   = grid.size();
		int                       i          = 0;
		
		if("T".equals(status)){
			bidStatus = "GA";
		}
		else if("E".equals(status)){
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
//		Map<String, String> header          = this.getHeader(gdReq, info);
//		
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
////			vendorCode = gridInfo.get("VENDOR_CODE");
//			vendorCode = header.get("vendor_code");
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
		Map<String, String> header          = this.getHeader(gdReq, info);
		
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
//			vendorCode = gridInfo.get("VENDOR_CODE");
			vendorCode = header.get("vendor_code");
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
		Map<String, String>       prHdParam    = null;
		String                    osqNo         = this.getOsNo(info);
//		String                    prNo           = this.getPrNo(info);
		String                    prNo           = null;
		List<Map<String, String>> gridData      = null;
		List<Map<String, String>> prConfirmData = null;
		List<Map<String, String>> sosseData     = null;
		
		heaerParam    = this.createOsObjHeader(gdReq, info, osqNo);
		gridData      = this.createOsObjGrid(gdReq, info, osqNo, prNo);
		prConfirmData = this.createOsObjPrConfirmData(gdReq, info);
		sosseData     = this.createOsObjSosseData(gdReq, info, osqNo);		
//		prHdParam = this.prHdCreateParam(gdReq, info, prNo);
		
		resultInfo.put("header",        heaerParam);
		resultInfo.put("gridData",      gridData);
		resultInfo.put("prConfirmData", prConfirmData);
		resultInfo.put("sosseData",     sosseData);
		resultInfo.put("prHdParam",     prHdParam);
		
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
    		value    = ServiceConnector.doService(info, "os_000", "TRANSACTION", "createOs", obj);
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