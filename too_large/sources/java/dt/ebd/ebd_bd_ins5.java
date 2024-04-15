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
import xlib.cmc.GridData;
import xlib.cmc.OperateGridData;

public class ebd_bd_ins5 extends HttpServlet{
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
    		
    		if("setPrCreate".equals(mode)){
    			gdRes = this.setPrCreate(gdReq, info);
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

	private String setPrCreatePrNo(SepoaInfo info, String docType) throws Exception{
		SepoaOut wo     = DocumentUtil.getDocNumber(info, docType);
		String   result = wo.result[0];
		
		
		
		return result;
	}
   
	private List<Map<String, String>> setPrCreateArgsHd(SepoaInfo info, Map<String, String> header, String prNo) throws Exception{
		List<Map<String, String>> result     = new ArrayList<Map<String, String>>();
		Map<String, String>       resultInfo = new HashMap<String, String>();
		
		resultInfo.put("HOUSE_CODE",          info.getSession("HOUSE_CODE"));
		resultInfo.put("PR_NO",               prNo);
		resultInfo.put("STATUS",              "C");
		resultInfo.put("COMPANY_CODE",        info.getSession("COMPANY_CODE"));
		resultInfo.put("PLANT_CODE",          info.getSession("DEPARTMENT"));
		resultInfo.put("PR_TOT_AMT",          header.get("pr_tot_amt"));
		resultInfo.put("PR_TYPE",             header.get("pr_type"));
		resultInfo.put("DEMAND_DEPT",         header.get("demand_dept"));
		resultInfo.put("SIGN_STATUS",         header.get("sign_status"));
		resultInfo.put("SIGN_DATE",           header.get("signDate"));
		resultInfo.put("SIGN_PERSON_ID",      header.get("signPersonId"));
		resultInfo.put("SIGN_PERSON_NAME",    header.get("signPersonName"));
		resultInfo.put("DEMAND_DEPT_NAME",    header.get("demand_dept_name"));
		resultInfo.put("REMARK",              header.get("REMARK"));
		resultInfo.put("SUBJECT",             header.get("subject"));
		resultInfo.put("PR_LOCATION",         info.getSession("LOCATION_CODE"));
		resultInfo.put("ORDER_NO",            header.get("order_no"));
		resultInfo.put("SALES_DEPT",          header.get("sales_dept"));
		resultInfo.put("SALES_USER_ID",       header.get("sales_user_id"));
		resultInfo.put("CONTRACT_HOPE_DAY",   header.get("contract_hope_day"));
		resultInfo.put("CUST_CODE",           header.get("cust_code"));
		resultInfo.put("CUST_NAME",           header.get("cust_name"));
		resultInfo.put("EXPECT_AMT",          header.get("expect_amt"));
		resultInfo.put("SALES_TYPE",          header.get("sales_type"));
		resultInfo.put("ORDER_NAME",          header.get("order_name"));
		resultInfo.put("REQ_TYPE",            header.get("pr_gubun"));
		resultInfo.put("RETURN_HOPE_DAY",     header.get("return_hope_day"));
		resultInfo.put("ATTACH_NO",           header.get("attach_no"));
		resultInfo.put("HARD_MAINTANCE_TERM", header.get("hard_maintance_term"));
		resultInfo.put("SOFT_MAINTANCE_TERM", header.get("soft_maintance_term"));
		resultInfo.put("CREATE_TYPE",         header.get("create_type"));
		resultInfo.put("ADD_USER_ID",         header.get("add_user_id"));
		resultInfo.put("ADD_USER_ID_1",       header.get("add_user_id"));
		resultInfo.put("BSART",               header.get("bsart"));
		resultInfo.put("CUST_TYPE",           header.get("cust_type"));
		resultInfo.put("ADD_DATE",            header.get("add_date"));
		resultInfo.put("AHEAD_FLAG",          header.get("ahead_flag"));
		resultInfo.put("CONTRACT_FROM_DATE",  header.get("contract_from_date"));
		resultInfo.put("CONTRACT_TO_DATE",    header.get("contract_to_date"));
		resultInfo.put("SALES_AMT",           header.get("sales_amt"));
		resultInfo.put("PROJECT_PM",          header.get("project_pm"));
		resultInfo.put("ORDER_COUNT",         header.get("order_count"));
		resultInfo.put("PJT_SEQ",             header.get("pjt_seq"));
		resultInfo.put("DELY_LOCATION",       header.get("dely_location"));
		resultInfo.put("DELY_TO_ADDRESS",     header.get("dely_to_address"));
		resultInfo.put("DELY_TO_USER",        header.get("dely_to_user"));
		resultInfo.put("DELY_TO_PHONE",       header.get("dely_to_phone"));
		
		result.add(resultInfo);
		
		return result;
	}
	
	private String nvl(String str, String defaultValue) throws Exception{
		String result = null;
		
		if(str == null){
			str = "";
		}
		
		if(str.equals("")){
			result = defaultValue;
		}
		else{
			result = str;
		}
		
		return result;
	}
	
	private List<Map<String, String>> setPrCreateArgsDt(SepoaInfo info, Map<String, String> header, List<Map<String, String>> grid, String prNo) throws Exception{
		List<Map<String, String>> result           = new ArrayList<Map<String, String>>();
		Map<String, String>       resultInfo       = null;
		Map<String, String>       gridInfo         = null;
		String                    prType           = header.get("pr_type");
		String                    salesType        = header.get("sales_type");
		String                    wbsSubNo         = header.get("wbs_sub_no");
		String                    wbsTxt           = header.get("wbs_txt");
		String                    prGubun          = header.get("pr_gubun");
		String                    techniqueGrade   = null;
		String                    techniqueType    = null;
		String                    gridInfoWbsSubNo = null;
		String                    gridInfoWbsTxt   = null;
		String                    purchaseLocation = null;
		String                    orderSeq         = null;
		String                    rdDate           = null;
		int                       i                = 0;
		int                       gridSize         = grid.size();
		
		for(i = 0; i < gridSize; i++){
			resultInfo = new HashMap<String, String>();
			
			gridInfo         = grid.get(i);
			techniqueGrade   = gridInfo.get("TECHNIQUE_GRADE");
			techniqueType    = gridInfo.get("TECHNIQUE_TYPE");
			gridInfoWbsSubNo = gridInfo.get("WBS_SUB_NO");
			gridInfoWbsTxt   = gridInfo.get("WBS_TXT");
			purchaseLocation = gridInfo.get("PURCHASE_LOCATION");
			orderSeq         = gridInfo.get("ORDER_SEQ");
			rdDate           = gridInfo.get("RD_DATE");
			rdDate           = rdDate.replaceAll("-", "");
			
			if("I".equals(prType)){
				techniqueGrade = "";
				techniqueType  = "";
				
				if("P".equals(salesType)){
					gridInfoWbsSubNo = wbsSubNo;
					gridInfoWbsTxt   = wbsTxt;
				}
			}
			
			if("".equals(purchaseLocation)){
				purchaseLocation = "01";
			}
			
			if("B".equals(prGubun) == false){
				orderSeq = String.valueOf(i + 1);
			}

			resultInfo.put("HOUSE_CODE",         info.getSession("HOUSE_CODE"));
			resultInfo.put("PR_NO",              prNo);
			resultInfo.put("PR_SEQ",             String.valueOf((i + 1) * 10));
			resultInfo.put("STATUS",             "C");
			resultInfo.put("COMPANY_CODE",       info.getSession("COMPANY_CODE"));
			resultInfo.put("PLANT_CODE",         info.getSession("DEPARTMENT"));
			resultInfo.put("ITEM_NO",            gridInfo.get("ITEM_NO"));
			resultInfo.put("PR_PROCEEDING_FLAG", "P");
			resultInfo.put("CTRL_CODE",          this.nvl(gridInfo.get("CTRL_CODE"), "P01"));
			resultInfo.put("UNIT_MEASURE",       gridInfo.get("UNIT_MEASURE"));
			resultInfo.put("PR_QTY",             gridInfo.get("PR_QTY"));
			resultInfo.put("CUR",                gridInfo.get("CUR"));
			resultInfo.put("UNIT_PRICE",         gridInfo.get("UNIT_PRICE"));
			resultInfo.put("PR_AMT",             gridInfo.get("PR_AMT"));
			resultInfo.put("RD_DATE",            rdDate);
			resultInfo.put("ATTACH_NO",          gridInfo.get("ATTACH_NO"));
			resultInfo.put("REC_VENDOR_CODE",    gridInfo.get("REC_VENDOR_CODE"));
			resultInfo.put("DELY_TO_LOCATION",   header.get("dely_to_location"));
			resultInfo.put("REC_VENDOR_NAME",    gridInfo.get("REC_VENDOR_NAME"));
			resultInfo.put("DESCRIPTION_LOC",    gridInfo.get("DESCRIPTION_LOC"));
			resultInfo.put("SPECIFICATION",      gridInfo.get("SPECIFICATION"));
			resultInfo.put("MAKER_NAME",         gridInfo.get("MAKER_NAME"));
			resultInfo.put("MAKER_CODE",         gridInfo.get("MAKER_CODE"));
			resultInfo.put("REMARK",             gridInfo.get("REMARK"));
			resultInfo.put("PURCHASE_LOCATION",  purchaseLocation);
			resultInfo.put("PURCHASER_ID",       gridInfo.get("PURCHASER_ID"));
			resultInfo.put("PURCHASER_NAME",     gridInfo.get("PURCHASER_NAME"));
			resultInfo.put("PURCHASE_DEPT",      gridInfo.get("PURCHASE_DEPT"));
			resultInfo.put("PURCHASE_DEPT_NAME", gridInfo.get("PURCHASE_DEPT_NAME"));
			resultInfo.put("TECHNIQUE_GRADE",    techniqueGrade);
			resultInfo.put("TECHNIQUE_TYPE",     techniqueType);
			resultInfo.put("INPUT_FROM_DATE",    gridInfo.get("INPUT_FROM_DATE"));
			resultInfo.put("INPUT_TO_DATE",      gridInfo.get("INPUT_TO_DATE"));
			resultInfo.put("ADD_USER_ID",        header.get("add_user_id"));
			resultInfo.put("ADD_USER_ID_1",      header.get("add_user_id"));
			resultInfo.put("KNTTP",              salesType);
			resultInfo.put("ZEXKN",              "01");
			resultInfo.put("ORDER_NO",           header.get("order_no"));
			resultInfo.put("ORDER_SEQ",          orderSeq);
			resultInfo.put("WBS_NO",             gridInfo.get("WBS_NO"));
			resultInfo.put("WBS_SUB_NO",         gridInfoWbsSubNo);
			resultInfo.put("WBS_TXT",            gridInfoWbsTxt);
			resultInfo.put("CONTRACT_DIV",       gridInfo.get("CONTRACT_DIV"));
			resultInfo.put("DELY_TO_ADDRESS",    gridInfo.get("DELY_TO_ADDRESS"));
			resultInfo.put("DELY_TO_ADDRESS_CD", gridInfo.get("DELY_TO_ADDRESS_CD"));
			resultInfo.put("WARRANTY",           gridInfo.get("WARRANTY"));
			resultInfo.put("WBS_NAME",           gridInfo.get("WBS_NAME"));
			resultInfo.put("ORDER_COUNT",        header.get("order_count"));

			result.add(resultInfo);
		}
		
		return result;
	}
	
	private String setPrCreateCur(List<Map<String, String>> grid) throws Exception{
		Map<String, String> gridInfo = grid.get(0);
		String              result   = gridInfo.get("CUR");
		
		return result;
	}
	
	private Map<String, String> setPrCreateHeader(SepoaInfo info, Map<String, String> header) throws Exception{
		String signStatus     = header.get("sign_status");
		String signDate       = null;
    	String signPersonId   = null;
    	String signPersonName = null;
    	
		if("E".equals(signStatus)){
			signDate       = SepoaDate.getShortDateString();
			signPersonId   = info.getSession("ID");
			signPersonName = info.getSession("NAME_LOC");
		}
		else{
			signDate       = "";
			signPersonId   = "";
			signPersonName = "";
		}
		
		header.put("signDate",       signDate);
		header.put("signPersonId",   signPersonId);
		header.put("signPersonName", signPersonName);
		
		return header;
	}
	
	/**
     * transaction sample
     * 
     * @param gdReq
     * @param info
     * @return GridData
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private GridData setPrCreate(GridData gdReq, SepoaInfo info) throws Exception{
    	GridData                  gdRes             = new GridData();
    	Vector                    multilangId       = new Vector();
    	HashMap                   message           = null;
    	Map<String, Object>       data              = SepoaDataMapper.getData(info, gdReq);
    	Map<String, Object>       svcParam          = new HashMap<String, Object>();
    	Map<String, String>       header            = MapUtils.getMap(data, "headerData");
    	List<Map<String, String>> grid              = (List<Map<String, String>>)MapUtils.getObject(data, "gridData");
    	List<Map<String, String>> argsHd            = null;
    	List<Map<String, String>> argsDt            = null;
    	String                    approvalStr       = header.get("approval_str");
    	String                    docType           = header.get("doc_type");
    	String                    signStatus        = header.get("sign_status");
    	String                    prTotAmt          = header.get("pr_tot_amt");
    	String                    prNo              = this.setPrCreatePrNo(info, docType);
    	String                    cur               = this.setPrCreateCur(grid);
    	SepoaOut                  value             = null;
    	
    	multilangId.addElement("MESSAGE");
   
    	message = MessageUtil.getMessage(info, multilangId);

    	try {
    		gdRes.addParam("mode", "doSave");
    		gdRes.setSelectable(false);
    		
    		header = this.setPrCreateHeader(info, header);
    		argsHd = this.setPrCreateArgsHd(info, header, prNo);
    		argsDt = this.setPrCreateArgsDt(info, header, grid, prNo);
    		
    		svcParam.put("args_hd",      argsHd);
    		svcParam.put("args_dt",      argsDt);
    		svcParam.put("pr_no",        prNo);
    		svcParam.put("sign_status",  signStatus);
    		svcParam.put("CUR",          cur);
    		svcParam.put("pr_tot_amt",   prTotAmt);
    		svcParam.put("approval_str", approvalStr);
    		
    		Object[] obj = {svcParam};
    		
    		value = ServiceConnector.doService(info, "p1015", "TRANSACTION", "setReqBidCreate1", obj);
    		
    		gdRes.setMessage(value.message);
    		
    		if(value.flag) {
    			gdRes.setStatus("true");
    		}
    		else {
    			gdRes.setStatus("false");
    		}
    	}
    	catch(Exception e){
    		
    		gdRes.setMessage(message.get("MESSAGE.1002").toString()); 
    		gdRes.setStatus("false");
    	}
    	
    	return gdRes;
    }
}