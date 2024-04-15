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
import sepoa.fw.util.DocumentUtil;
import sepoa.fw.util.JSPUtil;
import sepoa.fw.util.SepoaDataMapper;
import sepoa.fw.util.SepoaDate;
import sepoa.fw.util.SepoaFormater;
import sepoa.fw.util.SepoaString;
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ebd_bd_ins7 extends HttpServlet{
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
    		mode  = JSPUtil.CheckInjection(gdReq.getParam("mode"));
    		
    		if("selectSprcartList".equals(mode)){
    			gdRes = this.selectSprcartList(gdReq, info);
    		}
    		else if("deleteSprcartInfo".equals(mode)){
    			gdRes = this.deleteSprcartInfo(gdReq, info);
    		}
    		else if("setPrCreate".equals(mode)){
    			gdRes = this.setPrCreate(gdReq, info);
    		}
    		else if("setPrCreate_NonApp".equals(mode)){
    			gdRes = this.setPrCreate_NonApp(gdReq, info);
    		}
    		else if("setPrCreate2".equals(mode)){
    			gdRes = this.setPrCreate2(gdReq, info);
    		}
    		else if("setPrCreate_NonApp2".equals(mode)){
    			gdRes = this.setPrCreate_NonApp2(gdReq, info);
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
    
    @SuppressWarnings({ "unchecked"})
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
    	String              id        = info.getSession("ID");
    	
    	header.put("HOUSE_CODE", houseCode);
    	header.put("USER_ID",    id);
    	
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
    			
    			if("MODIFY_BUTTON".equals(colKey)){
    				colValue = "/images/icon/icon_disk_b.gif";
    			}
    			else if("APP_DIV".equals(colKey)){
    				colValue = "Z";
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
	private GridData selectSprcartList(GridData gdReq, SepoaInfo info) throws Exception{
	    GridData gdRes        = new GridData();
	    SepoaOut value        = null;
	    HashMap  message      = null;
	    String   gdResMessage = null;
	    Object[] obj          = null;
	    boolean  isStatus     = false;
	
	    try{
	    	message  = this.getMessage(info);
	    	obj      = this.selectPrUserListObj(gdReq, info);
	    	value    = ServiceConnector.doService(info, "p1015", "CONNECTION", "selectSprcartList", obj);
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
	
	private Object[] deleteSprcartInfoObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result       = new Object[1];
		Map<String, Object>       resultInfo   = new HashMap<String, Object>();
		Map<String, String>       gridInfo     = null;
		Map<String, String>       gridDataInfo = null;
		List<Map<String, String>> grid         = this.getGrid(gdReq, info);
		List<Map<String, String>> gridData     = new ArrayList<Map<String, String>>();
		String                    houseCode    = info.getSession("HOUSE_CODE");
		String                    id           = info.getSession("ID");
		String                    itemNo       = null;
		int                       gridSize     = grid.size();
		int                       i            = 0;
		
		for(i = 0; i < gridSize; i++){
			gridDataInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			itemNo   = gridInfo.get("ITEM_NO");
			
			gridDataInfo.put("HOUSE_CODE", houseCode);
			gridDataInfo.put("USER_ID",    id);
			gridDataInfo.put("ITEM_NO",    itemNo);

			gridData.add(gridDataInfo);
		}
		
		resultInfo.put("gridData", gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData deleteSprcartInfo(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.deleteSprcartInfoObj(gdReq, info);
    		value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "deleteSprcartInfo", obj);
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
	
	private String getPrNo(SepoaInfo info, String docType) throws Exception{
		SepoaOut wo   = DocumentUtil.getDocNumber(info, docType);
	    String   prNo = wo.result[0];
	    
	    return prNo;
	}
	
	private int parseInt(String s){
		int result = 0;
		
		try{
			result = Integer.parseInt(s);
		}
		catch(Exception e){
			result = 0;
		}
		
		return result;
	}
	
	private String setPrCreateObjHeaderAmt(GridData gdReq, SepoaInfo info) throws Exception{
		String                    result    = null;
		List<Map<String, String>> grid      = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo  = null;
		String                    prAmt     = null;
		int                       gridSize  = grid.size();
		int                       i         = 0;
		double                    resultInt = 0;
		double                    prAmtInt  = 0;
		
		for(i = 0; i < gridSize; i++){
			gridInfo  = grid.get(i);
			prAmt     = gridInfo.get("PR_AMT");
			prAmtInt  = this.parseInt(prAmt);
			resultInt = resultInt + prAmtInt;
		}
		
		result = Double.toString(resultInt);
		
		return result;
	}
	
	/**
	 * 구매요청 header Object 세팅
	 * @param gdReq
	 * @param info
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> setPrCreateObjHeader(GridData gdReq, SepoaInfo info) throws Exception{
		Map<String, String> result            = new HashMap<String, String>();
		Map<String, String> header            = this.getHeader(gdReq, info);
		String              nameLoc           = info.getSession("NAME_LOC");
		String              id                = info.getSession("ID");
		String              department        = info.getSession("DEPARTMENT");
		String              departmentNameLoc = info.getSession("DEPARTMENT_NAME_LOC");
		String              date              = SepoaDate.getShortDateString();
		String              hopeDay           = SepoaDate.addSepoaDateDay(date, 7);
		String              amt               = this.setPrCreateObjHeaderAmt(gdReq, info);
		
		result.put("sign_status",          "P");
		result.put("session_user_name",    nameLoc);
		result.put("wbs_txt",              "");
		result.put("hard_maintance_term",  "");
		result.put("cl_biz",               "");
		result.put("pc_flag",              "N");
		result.put("REMARK",               "");
		result.put("scms_cust_type",       "");
		result.put("expect_amt",           amt);
		result.put("order_no",             "");
		result.put("pr_type",              "I");
		result.put("cust_name",            "기타(계획용)");
		result.put("attach_count",         "");
		result.put("knttp",                "P");
		result.put("req_type",             "P");
		result.put("sales_user_id",        id);
		result.put("sign_person_name",     nameLoc);
		result.put("nowClickedIndex",      "2");
		result.put("pre_pjt_name",         "");
		result.put("add_user_id",          id);
		result.put("dept_code",            department);
		result.put("add_date",             date);
		result.put("prHeadStatus",         "C");
		result.put("sales_type",           "P");
		result.put("bsart",                "");
		result.put("plan_code",            "1000");
		result.put("dely_to_user",         "");
		result.put("soft_maintance_term",  "");
		result.put("wbs",                  "");
		result.put("sign_date",            date);
		result.put("view_type",            "");
		result.put("current_date",         date);
		result.put("approval_str",         header.get("approval_str"));
		result.put("session_user_id",      id);
		result.put("sign_attach_no_count", "0");
		result.put("dely_to_address",      "");
		result.put("sign_person_id",       id);
		result.put("req_user_id",          id);
		result.put("attach_no",            "");
		result.put("company_code",         info.getSession("COMPANY_CODE"));
		result.put("return_hope_day",      hopeDay);
		result.put("pjt_name",             "");
		result.put("create_type",          "PR");
		result.put("pre_pjt_code",         "");
		result.put("demand_dept",          department);
		result.put("cust_code",            "0000100000");
		result.put("subject",              header.get("subject"));
		result.put("dely_to_phone",        "");
		result.put("sales_amt",            "");
		result.put("scms_cust_name",       "");
		result.put("demand_dept_name",     departmentNameLoc);
		result.put("contract_to_date",     "");
		result.put("att_mode",             "");
		result.put("pr_tot_amt",           amt);
		result.put("prNo",                 this.getPrNo(info, "PR"));
		result.put("contract_hope_day",    hopeDay);
		result.put("dely_location",        "");
		result.put("sales_user_name",      nameLoc);
		result.put("house_code",           info.getSession("HOUSE_CODE"));
		result.put("fnc_name",             "getApproval");
		result.put("project_pm",           "");
		result.put("pjt_seq",              "");
		result.put("tmp_att_no",           "");
		result.put("dely_to_location",     "S100");
		result.put("wbs_no",               "");
		result.put("contract_from_date",   "");
		result.put("add_user_name",        nameLoc);
		result.put("blank",                "");
		result.put("sales_dept_name",      departmentNameLoc);
		result.put("current_time",         SepoaDate.getShortTimeString());
		result.put("pc_reason",            "");
		result.put("doc_type",             "PR");
		result.put("pjt_code",             "");
		result.put("ahead_flag",           "N");
		result.put("pr_gubun",             "P");
		result.put("wbs_sub_no",           "");
		result.put("file_type",            "");
		result.put("order_name",           "");
		result.put("project_pm_name",      "");
		result.put("cust_type",            "");
		result.put("attach_gubun",         "body");
		result.put("wbs_name",             "");
		result.put("zexkn",                "01");
		result.put("sales_dept",           department);
		result.put("order_count",          "");
		result.put("scms_cust_code",       "");
				
		return result;
	}

	private Map<String, String> setPrCreateObjHeader_NonApp(GridData gdReq, SepoaInfo info) throws Exception{
		Map<String, String> result            = new HashMap<String, String>();
		Map<String, String> header            = this.getHeader(gdReq, info);
		String              nameLoc           = info.getSession("NAME_LOC");
		String              id                = info.getSession("ID");
		String              department        = info.getSession("DEPARTMENT");
		String              departmentNameLoc = info.getSession("DEPARTMENT_NAME_LOC");
		String              date              = SepoaDate.getShortDateString();
		String              time              = SepoaDate.getShortTimeString();
		
		result.put("user_id"	,   id);
		result.put("insert_date",   date);
		result.put("insert_time",   time);
		result.put("status"		,  	"0127");	//0127: 신청, 0130: 출고
		result.put("dept_code"	,   department);
		result.put("dept_name"	,	departmentNameLoc);
		
		return result;
	}
	
	private List<Map<String, String>> setPrCreateObjGridData(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid       = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo   = null;
		Map<String, String>       resultInfo = null;
		String                    rdDate     = null;
		int                       gridSize   = grid.size();
		int                       i          = 0;
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
			rdDate   = gridInfo.get("RD_DATE");
			rdDate   = rdDate.replaceAll("/", "");
			rdDate   = rdDate.replaceAll("-", "");
			
			resultInfo.put("INPUT_TO_DATE",     "");
			resultInfo.put("MAKER_NAME",        gridInfo.get("MAKER_NAME"));
			resultInfo.put("ITEM_GROUP",        "");
			resultInfo.put("UNIT_MEASURE",      gridInfo.get("BASIC_UNIT"));
			resultInfo.put("REMARK",            gridInfo.get("REMARK"));
			resultInfo.put("PRE_TYPE",          "");
			resultInfo.put("PRE_PO_NO",         "");
			resultInfo.put("STATUS",            "C");
			resultInfo.put("ORDER_SEQ",         String.valueOf(i + 1));
			resultInfo.put("MAKER_CODE",        "");
			resultInfo.put("ACCOUNT_TYPE",      gridInfo.get("KTGRM"));
			resultInfo.put("PR_QTY",            gridInfo.get("PR_QTY"));
			resultInfo.put("INPUT_FROM_DATE",   "");
			resultInfo.put("PR_AMT",            gridInfo.get("PR_AMT"));
			resultInfo.put("REC_VENDOR_NAME",   "");
			resultInfo.put("CONTRACT_DIV",      "");
			resultInfo.put("PURCHASE_LOCATION", "01");
			resultInfo.put("KTGRM",             "");
			resultInfo.put("WBS_NAME",          "");
			resultInfo.put("ITEM_NO",           gridInfo.get("ITEM_NO"));
			resultInfo.put("CUR",               "KRW");
			resultInfo.put("PURCHASER_NAME",    "");
			resultInfo.put("PURCHASER_ID",      "");
			resultInfo.put("CTRL_CODE",         "P01");
			resultInfo.put("UNIT_PRICE",        gridInfo.get("UNIT_PRICE"));
			resultInfo.put("WBS_SUB_NO",        "");
			resultInfo.put("RD_DATE",           rdDate);
			resultInfo.put("TECHNIQUE_TYPE",    "");
			resultInfo.put("REC_VENDOR_CODE",    "");
			resultInfo.put("MATERIAL_TYPE",      "");
			resultInfo.put("WARRANTY",           "");
			resultInfo.put("WBS_TXT",            "");
			resultInfo.put("WBS_NO",             "");
			resultInfo.put("DELY_TO_ADDRESS",    "");
			resultInfo.put("ASSET_TYPE",         "");
			resultInfo.put("PR_PROCEEDING_FLAG", "P");
			resultInfo.put("PURCHASE_DEPT_NAME", "");
			resultInfo.put("ATTACH_NO",          "");
			resultInfo.put("PRE_PO_SEQ",         "");
			resultInfo.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
			resultInfo.put("PURCHASE_DEPT",      "");
			resultInfo.put("PR_SEQ",             String.valueOf((i + 1) * 10));
			resultInfo.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
			resultInfo.put("TECHNIQUE_GRADE",    "");
			resultInfo.put("EXCHANGE_RATE",      "1");
			resultInfo.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
			resultInfo.put("USER_ID",            info.getSession("ID"));
			resultInfo.put("ASSET_TYPE",         gridInfo.get("ASSET_TYPE"));
			if( "Z".equals( gridInfo.get("APP_DIV") ) ) {
				resultInfo.put("APP_DIV",        "");
			} else {
				resultInfo.put("APP_DIV",        gridInfo.get("APP_DIV"));
			}
			resultInfo.put("KTEXT",              gridInfo.get("KTEXT"));
			resultInfo.put("KAMT",               gridInfo.get("KAMT"));
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	private List<Map<String, String>> setPrCreateObjGridData2(GridData gdReq, SepoaInfo info) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		List<Map<String, String>> grid       = this.getGrid(gdReq, info);
		Map<String, String>       gridInfo   = null;
		Map<String, String>       resultInfo = null;
		String                    rdDate     = null;
		int                       gridSize   = grid.size();
		int                       i          = 0;
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo = grid.get(i);
//			rdDate   = gridInfo.get("RD_DATE");
//			rdDate   = rdDate.replaceAll("/", "");
//			rdDate   = rdDate.replaceAll("-", "");
			
			resultInfo.put("INPUT_TO_DATE",     "");
			resultInfo.put("MAKER_NAME",        "");
			resultInfo.put("ITEM_GROUP",        "");
			resultInfo.put("UNIT_MEASURE",      gridInfo.get("BASIC_UNIT"));
			resultInfo.put("REMARK",            "");
			resultInfo.put("PRE_TYPE",          "");
			resultInfo.put("PRE_PO_NO",         "");
			resultInfo.put("STATUS",            "C");
			resultInfo.put("ORDER_SEQ",         String.valueOf(i + 1));
			resultInfo.put("MAKER_CODE",        "");
			resultInfo.put("ACCOUNT_TYPE",      gridInfo.get("KTGRM"));
			resultInfo.put("PR_QTY",            gridInfo.get("PR_QTY"));
			resultInfo.put("INPUT_FROM_DATE",   "");
			resultInfo.put("PR_AMT",            "");
			resultInfo.put("REC_VENDOR_NAME",   "");
			resultInfo.put("CONTRACT_DIV",      "");
			resultInfo.put("PURCHASE_LOCATION", "01");
			resultInfo.put("KTGRM",             "");
			resultInfo.put("WBS_NAME",          "");
			resultInfo.put("ITEM_NO",           gridInfo.get("ITEM_NO"));
			resultInfo.put("CUR",               "KRW");
			resultInfo.put("PURCHASER_NAME",    "");
			resultInfo.put("PURCHASER_ID",      "");
			resultInfo.put("CTRL_CODE",         "P01");
			resultInfo.put("UNIT_PRICE",        "");
			resultInfo.put("WBS_SUB_NO",        "");
			resultInfo.put("RD_DATE",           "");
			resultInfo.put("TECHNIQUE_TYPE",    "");
			resultInfo.put("REC_VENDOR_CODE",    "");
			resultInfo.put("MATERIAL_TYPE",      "");
			resultInfo.put("WARRANTY",           "");
			resultInfo.put("WBS_TXT",            "");
			resultInfo.put("WBS_NO",             "");
			resultInfo.put("DELY_TO_ADDRESS",    "");
			resultInfo.put("ASSET_TYPE",         "");
			resultInfo.put("PR_PROCEEDING_FLAG", "P");
			resultInfo.put("PURCHASE_DEPT_NAME", "");
			resultInfo.put("ATTACH_NO",          "");
			resultInfo.put("PRE_PO_SEQ",         "");
			resultInfo.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
			resultInfo.put("PURCHASE_DEPT",      "");
			resultInfo.put("PR_SEQ",             String.valueOf((i + 1) * 10));
			resultInfo.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
			resultInfo.put("TECHNIQUE_GRADE",    "");
			resultInfo.put("EXCHANGE_RATE",      "1");
			resultInfo.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
			resultInfo.put("USER_ID",            info.getSession("ID"));
			resultInfo.put("ASSET_TYPE",         "");
//			if( "Z".equals( gridInfo.get("APP_DIV") ) ) {
//				resultInfo.put("APP_DIV",        "");
//			} else {
//				resultInfo.put("APP_DIV",        gridInfo.get("APP_DIV"));
//			}
			resultInfo.put("KTEXT",              "");
			resultInfo.put("KAMT",               "");
			
			result.add(resultInfo);
		}
		
		return result;
	}
	
	private Object[] setPrCreateObj(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result     = new Object[1];
		Map<String, Object>       resultInfo = new HashMap<String, Object>();
		Map<String, String>       header     = this.setPrCreateObjHeader(gdReq, info);//헤더 맵 데이터 생성
		List<Map<String, String>> gridData   = this.setPrCreateObjGridData(gdReq, info);//그리드 맵 데이터 생성
		
		resultInfo.put("headerData", header);
		resultInfo.put("gridData",   gridData);
		
		
		
		result[0] = resultInfo;
		
		return result;
	}
	
	private Object[] setPrCreateObj_NonApp(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result     = new Object[1];
		Map<String, Object>       resultInfo = new HashMap<String, Object>();
		Map<String, String>       header     = this.setPrCreateObjHeader_NonApp(gdReq, info);
		List<Map<String, String>> gridData   = this.setPrCreateObjGridData(gdReq, info);
		
		resultInfo.put("headerData", header);
		resultInfo.put("gridData",   gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	private Object[] setPrCreateObj_NonApp2(GridData gdReq, SepoaInfo info) throws Exception{
		Object[]                  result     = new Object[1];
		Map<String, Object>       resultInfo = new HashMap<String, Object>();
		Map<String, String>       header     = this.setPrCreateObjHeader_NonApp(gdReq, info);
		List<Map<String, String>> gridData   = this.setPrCreateObjGridData2(gdReq, info);
		
		resultInfo.put("headerData", header);
		resultInfo.put("gridData",   gridData);
		
		result[0] = resultInfo;
		
		return result;
	}
	
	@SuppressWarnings({ "rawtypes"})
    private GridData setPrCreate(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.setPrCreateObj(gdReq, info);//맵 데이터 생성
    		value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setUserCart", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = (String)message.get("MESSAGE.0001"); 
    			Logger.debug.println(info.getSession("ID"), this, "gdResMessage1===="+gdResMessage);
    		}
    		else {
    			gdResMessage = value.message;
    			Logger.debug.println(info.getSession("ID"), this, "gdResMessage2===="+gdResMessage);
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
	
	@SuppressWarnings({ "rawtypes"})
	private GridData setPrCreate_NonApp(GridData gdReq, SepoaInfo info) throws Exception{
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
			obj      = this.setPrCreateObj_NonApp(gdReq, info);
			value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setUserCart_NonApp", obj);
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
	
	@SuppressWarnings({ "rawtypes"})
	private GridData setPrCreate_NonApp2(GridData gdReq, SepoaInfo info) throws Exception{
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
			obj      = this.setPrCreateObj_NonApp2(gdReq, info);
			value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setUserCart_NonApp", obj);
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
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setPrCreate2(GridData gdReq, SepoaInfo info) throws Exception{
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
    		obj      = this.setPrCreateObj(gdReq, info);//맵 데이터 생성
    		value    = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setPrCreate2", obj);
    		isStatus = value.flag;
    		
    		if(isStatus) {
    			gdResMessage = (String)message.get("MESSAGE.0001"); 
    			Logger.debug.println(info.getSession("ID"), this, "gdResMessage1===="+gdResMessage);
    		}
    		else {
    			gdResMessage = value.message;
    			Logger.debug.println(info.getSession("ID"), this, "gdResMessage2===="+gdResMessage);
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