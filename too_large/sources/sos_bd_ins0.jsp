<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%!
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
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isSignUseYn(SepoaInfo info, Config signConf){
	String          sign_use_module = "";
	StringTokenizer st              = null;
	boolean         sign_use_yn     = false;
	
	try {
		sign_use_module = signConf.get("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	}
	catch(Exception e) {
		sign_use_module	= "";
	}
	
	st = new StringTokenizer(sign_use_module, ";");
	
	while (st.hasMoreTokens()) {
		if ("PR".equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
	
	return sign_use_yn;
}

private String getDateSlashFormat(String target) throws Exception{
	String       result       = null;
	StringBuffer stringBuffer = new StringBuffer();
	
	stringBuffer.append(target.subSequence(0, 4)).append("/").append(target.substring(4, 6)).append("/").append(target.substring(6, 8));
	
	result = stringBuffer.toString();
	
	return result;
}
%>
<%
	Vector       multilang_id            = null;
	HashMap      text                    = null;
	SepoaListBox LB                      = new SepoaListBox();
	String       grid_obj                = "GridObj";
	String       SepoaHUB_PROCESS_ID     = "SO_000";
	String       screen_id               = null;
	String       USER_ID                 = info.getSession("ID");
    String       HOUSE_CODE              = info.getSession("HOUSE_CODE") ;
    String       COMPANY_CODE            = info.getSession("COMPANY_CODE") ;
    String       CURRENT_DATE            = SepoaDate.getShortDateString();
    String       RETURN_HOPE_DAY         = SepoaDate.addSepoaDateDay(CURRENT_DATE,7);
    String       LB_CODE_SHIPPER_TYPE    = "D";
    String       COMBO_M002              = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M002#", "&" , "#");
    String       COMBO_IDX_M002          = ""+CommonUtil.getComboIndex(COMBO_M002,"KRW","#");
    String       COMBO_M007              = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M007#", "&" , "#");
    String       COMBO_IDX_M007          = ""+CommonUtil.getComboIndex(COMBO_M007,"EA","#");
    String       req_type                = null;
    String       G_IMG_ICON              = "/images/ico_zoom.gif";
    String[]     CATAL_ITEM_NO 			 = null;
	String[]     CATAL_DESCRIPTION_LOC	 = null;
	String[]     CATAL_SPECIFICATION 	 = null;
	String[]     CATAL_MAKER_NAME 		 = null;
	String[]     CATAL_MAKER_CODE 		 = null;
	String[]     CATAL_QTY 				 = null;
	String[]     CATAL_ITEM_GROUP 		 = null;
	String[]     CATAL_PREV_UNIT_PRICE	 = null;
	String[]     CATAL_UNIT_MEASURE 	 = null;
	String[]     CATAL_BASIC_UNIT 		 = null;
	String[]     CATAL_MATERIAL_TYPE 	 = null;
	String[]     CATAL_VENDOR_CODE 		 = null;
	String[]     CATAL_VENDOR_NAME 		 = null;
	String[]     CATAL_PURCHASE_LOCATION = null;
	String[]     CATAL_DELY_TO_ADDRESS 	 = null;
	String[]     CATAL_CTRL_CODE		 = null;
	boolean      isSelectScreen          = false;
	boolean      sign_use_yn             = this.isSignUseYn(info, new Configuration());
	
	multilang_id = new Vector();
	
	multilang_id.addElement("SO_000");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	text      = MessageUtil.getMessage(info, multilang_id);
	screen_id = request.getParameter("screen_id");
	screen_id = JSPUtil.nullToEmpty(screen_id);
	screen_id = this.nvl(screen_id, "SO_000");
	
	req_type = request.getParameter("req_type");
	req_type = JSPUtil.CheckInjection(req_type);
	req_type = JSPUtil.nullToEmpty(req_type);
	req_type = this.nvl(req_type);
	
	if ("CA".equals(req_type)) {
		CATAL_ITEM_NO 			= request.getParameterValues("ITEM_NO");
		CATAL_DESCRIPTION_LOC	= request.getParameterValues("DESCRIPTION_LOC");
		CATAL_SPECIFICATION 	= request.getParameterValues("SPECIFICATION");
		CATAL_MAKER_NAME 		= request.getParameterValues("MAKER_NAME");
		CATAL_MAKER_CODE 		= request.getParameterValues("MAKER_CODE");
		CATAL_QTY 				= request.getParameterValues("QTY");
		CATAL_ITEM_GROUP 		= request.getParameterValues("ITEM_GROUP");
		CATAL_PREV_UNIT_PRICE	= request.getParameterValues("PREV_UNIT_PRICE");
		CATAL_UNIT_MEASURE 		= request.getParameterValues("UNIT_MEASURE");
		CATAL_BASIC_UNIT 		= request.getParameterValues("BASIC_UNIT");
		CATAL_MATERIAL_TYPE 	= request.getParameterValues("MATERIAL_TYPE");
		CATAL_VENDOR_CODE 		= request.getParameterValues("VENDOR_CODE");
		CATAL_VENDOR_NAME 		= request.getParameterValues("VENDOR_NAME");
		CATAL_PURCHASE_LOCATION	= request.getParameterValues("PURCHASE_LOCATION");
		CATAL_DELY_TO_ADDRESS 	= request.getParameterValues("DELY_TO_ADDRESS");
		CATAL_CTRL_CODE		 	= request.getParameterValues("CTRL_CODE");
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
//var G_SERVLETURL                 = "POASRM_CONTEXT_NAME/servlets/dt.ebd.ebd_bd_ins3";
var G_SERVLETURL                 = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_ins0";
var G_HOUSE_CODE                 = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE               = "<%=COMPANY_CODE%>";
var G_SAVE_STATUS                = "T";
var summaryCnt                   = 0;
var G_PRE_CODE                   = "B";
var ctrl_code                    = "<%=info.getSession("CTRL_CODE")%>".split("&");
var G_C_INDEX                    = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";
var G_C_INDEX_PJ                 = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP:PR_QTY:CUR:UNIT_PRICE:EXCHANGE_RATE:PR_AMT:REC_VENDOR_NAME:CONTRACT_DIV:RD_DATE:DELY_TO_ADDRESS:WARRANTY:KTGRM";
var G_C_INDEX_MY                 = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS";
var ADD_UNIT_MEASURE_OPTION_CNT  = 0;
var ADD_UNIT_MEASURE_OPTION_CNT2 = 0;
var INDEX_SELECTED;
var INDEX_ITEM_NO;
var INDEX_PR_SEQ;
var INDEX_DESCRIPTION_LOC;
var INDEX_UNIT_MEASURE;
var INDEX_PR_QTY;
var INDEX_CUR;
var INDEX_UNIT_PRICE;
var INDEX_EXCHANGE_RATE;
var INDEX_RD_DATE;
var INDEX_PR_AMT;
var INDEX_ATTACH_NO;
var INDEX_REC_VENDOR_CODE;
var INDEX_REC_VENDOR_NAME;
var INDEX_REMARK;
var INDEX_DELY_TO_LOCATION;
var INDEX_PURCHASE_LOCATION;
var INDEX_PURCHASER_ID;
var INDEX_PURCHASER_NAME;
var INDEX_PURCHASE_DEPT_NAME;
var INDEX_TECHNIQUE_GRADE;
var INDEX_TECHNIQUE_TYPE;
var INDEX_INPUT_FROM_DATE;
var INDEX_INPUT_TO_DATE;
var INDEX_WBS_NO;
var INDEX_WBS_SUB_NO;
var INDEX_WBS_TXT;
var INDEX_ORDER_SEQ;
var INDEX_ITEM_GROUP;
var INDEX_CTRL_CODE;
var INDEX_CONTRACT_DIV;
var INDEX_ACCOUNT_TYPE;
var INDEX_ASSEST_TYPE;
var INDEX_KTGRM;
var INDEX_MATERIAL_TYPE;
var INDEX_DELY_TO_ADDRESS_CD;
var INDEX_P_ITEM_NO;	//모품코드
var INDEX_P_SEQ;	//모품순번
var INDEX_MAKE_AMT_NAME;
var INDEX_MAKE_AMT_CODE;
var G_CUR_ROW;//팝업 관련해서 씀..

var INDEX_IMAGE_FILE;//팝업 관련해서 씀..
var INDEX_IMAGE_FILE_PATH;//팝업 관련해서 씀..

var INDEX_WID;
var INDEX_HGT;

function init() {
	setGridDraw();
	setHeader_1();
	GridView();
}

function setHeader_1(){
	var wise = GridObj;
	    
	INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
	
	INDEX_P_ITEM_NO      	= GridObj.GetColHDIndex("P_ITEM_NO");
	INDEX_P_SEQ                   = GridObj.GetColHDIndex("P_SEQ");
	INDEX_P_DESCRIPTION_LOC      	= GridObj.GetColHDIndex("P_DESCRIPTION_LOC");
	INDEX_P_BOM_NAME      	= GridObj.GetColHDIndex("P_BOM_NAME");
	
	INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_PR_SEQ                   = GridObj.GetColHDIndex("PR_SEQ");
	INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_MAKER_NAME            = GridObj.GetColHDIndex("MAKER_NAME");
	INDEX_MAKER_CODE            = GridObj.GetColHDIndex("MAKER_CODE");
	INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_PR_QTY                = GridObj.GetColHDIndex("PR_QTY");
	INDEX_CUR                   = GridObj.GetColHDIndex("CUR");
	INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_EXCHANGE_RATE         = GridObj.GetColHDIndex("EXCHANGE_RATE");
	INDEX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
	INDEX_PR_AMT                = GridObj.GetColHDIndex("PR_AMT");
	INDEX_REC_VENDOR_CODE       = GridObj.GetColHDIndex("REC_VENDOR_CODE");
	INDEX_REC_VENDOR_NAME       = GridObj.GetColHDIndex("REC_VENDOR_NAME");
	INDEX_ATTACH_NO             = GridObj.GetColHDIndex("ATTACH_NO");
	INDEX_REMARK                = GridObj.GetColHDIndex("REMARK");
	INDEX_PURCHASE_LOCATION     = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	INDEX_PURCHASER_ID          = GridObj.GetColHDIndex("PURCHASER_ID");
	INDEX_PURCHASER_NAME        = GridObj.GetColHDIndex("PURCHASER_NAME");
	INDEX_PURCHASE_DEPT_NAME    = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME");
	INDEX_PURCHASE_DEPT         = GridObj.GetColHDIndex("PURCHASE_DEPT");
	INDEX_WBS_NO                = GridObj.GetColHDIndex("WBS_NO");
	INDEX_WBS_SUB_NO            = GridObj.GetColHDIndex("WBS_SUB_NO");
	INDEX_WBS_TXT               = GridObj.GetColHDIndex("WBS_TXT");
	INDEX_ORDER_SEQ             = GridObj.GetColHDIndex("ORDER_SEQ");
	INDEX_ITEM_GROUP            = GridObj.GetColHDIndex("ITEM_GROUP");
	INDEX_CONTRACT_DIV          = GridObj.GetColHDIndex("CONTRACT_DIV");
	INDEX_DELY_TO_ADDRESS	    = GridObj.GetColHDIndex("DELY_TO_ADDRESS");
	INDEX_DELY_TO_ADDRESS_CD    = GridObj.GetColHDIndex("DELY_TO_ADDRESS_CD");
	INDEX_WARRANTY        	    = GridObj.GetColHDIndex("WARRANTY");
	INDEX_CTRL_CODE      	    = GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_ACCOUNT_TYPE          = GridObj.GetColHDIndex("ACCOUNT_TYPE");
	INDEX_ASSET_TYPE      	    = GridObj.GetColHDIndex("ASSET_TYPE");
	INDEX_KTGRM      		    = GridObj.GetColHDIndex("KTGRM");
	INDEX_MATERIAL_TYPE      	= GridObj.GetColHDIndex("MATERIAL_TYPE");
	
	INDEX_IMAGE_FILE      	= GridObj.GetColHDIndex("IMAGE_FILE");
	INDEX_IMAGE_FILE_PATH  	= GridObj.GetColHDIndex("IMAGE_FILE_PATH");
	
	INDEX_MAKE_AMT_NAME = GridObj.GetColHDIndex("MAKE_AMT_NAME");
	INDEX_MAKE_AMT_CODE = GridObj.GetColHDIndex("MAKE_AMT_CODE");
	
	INDEX_WID  = GridObj.GetColHDIndex("WID");
	INDEX_HGT = GridObj.GetColHDIndex("HGT");
	
	
	
	GridObj.strHDClickAction="select";
<%
	if ("CA".equals(req_type)) {
%>
	setCatalog_catalog();
<%
	}
%>
}
	
  	
/**
 * 카탈로그 : cat_pp_lis_main.jsp에서 호출되는 부분, 선택한 항목에 대해 와이즈 테이블에 인서트한다.
*/
function setCatalog1(arr) {
	var wise     = GridObj;
	var ITEM_NO  = arr[getCatalogIndex("BUYER_ITEM_NO")];
	var dup_flag = true;
	
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO)) {
			dup_flag = true;
			
			break;
		}
	}
		
	if(!dup_flag) {
		var iMaxRow = GridObj.GetRowCount();
		GridObj.AddRow();
			
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,     		"true", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,      		"null&"+ITEM_NO+"&"+ITEM_NO, "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  	arr[getCatalogIndex("DESCRIPTION_LOC")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  	"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    		"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,        		"<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,     		arr[getCatalogIndex("QTY")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_LOCATION, 	arr[getCatalogIndex("PURCHASE_LOCATION")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_ID,      	arr[getCatalogIndex("CTRL_PERSON_ID")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASER_NAME,    	arr[getCatalogIndex("PURCHASER_NAME")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT_NAME,	arr[getCatalogIndex("PURCHASE_DEPT_NAME")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PURCHASE_DEPT,  	arr[getCatalogIndex("PURCHASE_DEPT")]);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,         	document.form1.wbs_no.value);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,     	document.form1.wbs_sub_no.value);
		GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,        	document.form1.wbs_txt.value);
	}
}
	
function setExcelCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode
		, qty, itemGroup, delyToAddress, unitPrice, ktgrm
		, makerName, basicUnit, materialType, pItemNoColValue, cUnitPrice
		, tmp1, tmp2, tmp3, excelDelyToAddress, excelDelyToAddressCd
		, imgPath, rdDate){

var dup_flag   = false;
var i          = 0;
var iMaxRow    = GridObj.GetRowCount();
var newId      = (new Date()).valueOf();

GridObj.addRow(newId,"");
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	     "true");
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	     itemNo);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,      specification);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,         makerCode);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,          ctrlCode);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,             qty);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,         itemGroup);
//GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         unitPrice);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         cUnitPrice);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_EXCHANGE_RATE,      "1");
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,              ktgrm);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,         makerName);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,       basicUnit);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,      materialType);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,                "KRW");
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS,    excelDelyToAddress);
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS_CD, excelDelyToAddressCd);
<%-- GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS,    "<%=info.getSession("DEPARTMENT_NAME_LOC")%>"); --%>
<%-- GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS_CD, "<%=info.getSession("DEPARTMENT")%>"); --%>
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_ITEM_NO,      	     pItemNoColValue);

if($.trim(imgPath) == ""){
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/000/icon/icon_close3.gif");
}else{
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/ico_x1.gif");
}
GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE_PATH,      	     imgPath);

if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
ADD_UNIT_MEASURE_OPTION_CNT++;
}

GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_RD_DATE, rdDate);

calculate_pr_amt(GridObj, iMaxRow);
calculate_pr_tot_amt();

return true;
}

var _openFlag = false;
var _ItemNoColValue = "";

function getMaxPR_SEQ(){
	var s_PR_SEQ = "";
	var i_PR_SEQ = 0;
	var PR_SEQ = 0
	
	for(var i=0;i<GridObj.GetRowCount();i++) {	
		s_PR_SEQ = GD_GetCellValueIndex(GridObj,i,INDEX_PR_SEQ).substring(0,4);
		i_PR_SEQ = parseFloat(s_PR_SEQ);
		
		if( i_PR_SEQ > PR_SEQ ){
			PR_SEQ = i_PR_SEQ;
		}
	}
	return PR_SEQ;
}

function prSeqFormat(i_PR_SEQ){
	var s_PR_SEQ
	if(i_PR_SEQ < 10){
		s_PR_SEQ = "000" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 100){
		s_PR_SEQ = "00" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 1000){
		s_PR_SEQ = "0" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 10000){
		s_PR_SEQ =  i_PR_SEQ + "0";
	}
	
	return 	s_PR_SEQ;
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode
				, qty, itemGroup, delyToAddress, unitPrice, ktgrm
				, makerName, basicUnit, materialType, pItemNoColValue, cUnitPrice
				, tmp1, tmp2, tmp3, tmp4, tmp5
				, imgPath, tmp6, wid, hgt){
	
	var f = document.forms[0];
	
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	
	GridObj.addRow(newId,"");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	     "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	     itemNo);
	
	var PR_SEQ = 0;

	if(pItemNoColValue != ""){
		if(_ItemNoColValue != pItemNoColValue){
			PR_SEQ = getMaxPR_SEQ() + 1;
			_ItemNoColValue = pItemNoColValue;
		}else{
			if(_openFlag){
				PR_SEQ = getMaxPR_SEQ() + 1;				
			}else{
				PR_SEQ = getMaxPR_SEQ();	
			}
		}
	}else{
		PR_SEQ = getMaxPR_SEQ() + 1;
	}
	//GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_SEQ,   "" + PR_SEQ);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_SEQ,   prSeqFormat(PR_SEQ));
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,      specification);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,         makerCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,          ctrlCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,             qty);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,         itemGroup);
	//GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         unitPrice);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         cUnitPrice);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_EXCHANGE_RATE,      "1");
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,              ktgrm);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,         makerName);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,       basicUnit);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,      materialType);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,                "KRW");
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS,    f.demand_dept_name.value);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS_CD, f.demand_dept.value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_ITEM_NO,      	     pItemNoColValue);
	if(pItemNoColValue != ""){
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_SEQ,      	     tmp6);	
	}
	
	
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_DESCRIPTION_LOC,      	     tmp2);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_BOM_NAME,      	     tmp3);
	
	if($.trim(imgPath) == ""){
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/000/icon/icon_close3.gif");
	}else{
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/ico_x1.gif");
	}
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE_PATH,      	     imgPath);
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_NAME,      	     tmp4);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_CODE,      	     tmp1);
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_WID,      	     wid);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_HGT,      	 hgt);
	
     
	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
		ADD_UNIT_MEASURE_OPTION_CNT++;
	}
	
	calculate_pr_amt(GridObj, iMaxRow);
	calculate_pr_tot_amt();

	return true;
}
  
function setCatalogPrBr(arr){
	var ITEM_NO  = arr[getCatalogIndex("ITEM_NO")];
	var dup_flag = false;
	var iMaxRow  = GridObj.GetRowCount();
	var newId    = (new Date()).valueOf();
	
	GridObj.addRow(newId, "");
      	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	  "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,         ITEM_NO);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC, arr[getCatalogIndex("DESCRIPTION_LOC")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,   arr[getCatalogIndex("SPECIFICATION")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,      arr[getCatalogIndex("MAKER_NAME")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,      arr[getCatalogIndex("MAKER_CODE")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,       "P01");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,          arr[getCatalogIndex("PR_QTY")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,      arr[getCatalogIndex("ITEM_GROUP")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS, arr[getCatalogIndex("DELY_TO_ADDRESS")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,      arr[getCatalogIndex("UNIT_PRICE")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_AMT,          arr[getCatalogIndex("PR_AMT")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_WARRANTY,        arr[getCatalogIndex("WARRANTY")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,           arr[getCatalogIndex("KTGRM")]);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CONTRACT_DIV,    arr[getCatalogIndex("CONTRACT_DIV")]);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,    arr[getCatalogIndex("BASIC_UNIT")]);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,   arr[getCatalogIndex("MATERIAL_TYPE")]);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,             "KRW");
      	  	
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_EXCHANGE_RATE, "1");
     
	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
		ADD_UNIT_MEASURE_OPTION_CNT++;
	}
	
	calculate_pr_amt(GridObj, iMaxRow);
	calculate_pr_tot_amt();
      	
	return true;
}

function setCatalog2(arr){
	var wise     = GridObj;
	var ITEM_NO  = arr[getCatalogIndex("MATNR")];
	var dup_flag = false;
	
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ORDER_SEQ)) {
			dup_flag = true;
			
			break;
		}
	}
    	
	var iMaxRow = GridObj.GetRowCount();
        
	GridObj.AddRow();
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_SELECTED,         "true" );
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_NO,          "null&"+ITEM_NO+"&"+ITEM_NO, "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_DESCRIPTION_LOC,  arr[getCatalogIndex("ARKTX")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_PR_QTY,       	arr[getCatalogIndex("KWMENG")]);
    GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_UNIT_MEASURE,     "<%=COMBO_M007%>", "&","#");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CTRL_CODE,      	arr[getCatalogIndex("CTRL_CODE")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_REC_VENDOR_NAME,  "<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ATTACH_NO,    	"<%=G_IMG_ICON%>" + "&"+"null"+"&"+"null", "&");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_CUR,              "<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_NO,           arr[getCatalogIndex("PS_PSP_PNR")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_SUB_NO,       arr[getCatalogIndex("CONV_PSPNR")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_WBS_TXT,          arr[getCatalogIndex("POST1")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ORDER_SEQ,        arr[getCatalogIndex("VBELP")]);
	GD_SetCellValueIndex(GridObj,iMaxRow, INDEX_ITEM_GROUP,       arr[getCatalogIndex("PSTYV")]);
	GridObj.SetComboSelectedHiddenValue('UNIT_MEASURE',iMaxRow,	arr[getCatalogIndex("VRKME")]);

	document.forms[0].order_no.value = arr[getCatalogIndex("VBELN")];
	document.forms[0].cust_code.value = arr[getCatalogIndex("KUNNR")];
	document.forms[0].cust_name.value = arr[getCatalogIndex("WAERK")];
	document.forms[0].subject.value = arr[getCatalogIndex("POST1")];
}
	
function setCatalog_catalog(){
	var wise = GridObj;
<%
	if (CATAL_ITEM_NO != null){
		for(int i = 0 ; i < CATAL_ITEM_NO.length; i++ ) {
%>
	var ITEM_NO  = "<%=CATAL_ITEM_NO[i]%>";
	var dup_flag = false;
	
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(ITEM_NO == GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO)) {
			dup_flag = true;
			
			break;
		}
	}
	      	
	GridObj.AddRow();
	GD_SetCellValueIndex(GridObj, i, INDEX_SELECTED,        "1" );
	GD_SetCellValueIndex(GridObj, i, INDEX_ITEM_NO,         "null&"+ITEM_NO+"&"+ITEM_NO, "&");
	GD_SetCellValueIndex(GridObj, i, INDEX_DESCRIPTION_LOC, "<%=CATAL_DESCRIPTION_LOC[i]%>");
	GD_SetCellValueIndex(GridObj, i, INDEX_SPECIFICATION,   "<%=CATAL_SPECIFICATION[i]%>");
	GD_SetCellValueIndex(GridObj, i, INDEX_MAKER_CODE,      "<%=CATAL_MAKER_CODE[i]%>");
	GridObj.SetCellValue("MAKER_NAME", i, "<%=CATAL_MAKER_NAME[i]%>");
	GridObj.SetCellHiddenValue("MAKER_NAME", i, "<%=CATAL_MAKER_NAME[i]%>");
	GD_SetCellValueIndex(GridObj, i, INDEX_UNIT_MEASURE, "<%=COMBO_M007%>", "&","#");
	GD_SetCellValueIndex(GridObj, i, INDEX_CTRL_CODE,    "<%=CATAL_CTRL_CODE[i]%>");	        
	GD_SetCellValueIndex(GridObj, i, INDEX_CUR,          "<%=COMBO_M002%>", "&","#", "<%=COMBO_IDX_M002%>");
	GD_SetCellValueIndex(GridObj, i, INDEX_ITEM_GROUP,   "");
	GD_SetCellValueIndex(GridObj, i, INDEX_UNIT_PRICE,   "");
	        
	if(ADD_UNIT_MEASURE_OPTION_CNT2 == 0){
		GridObj.AddComboListValue("UNIT_MEASURE", "", "");
		ADD_UNIT_MEASURE_OPTION_CNT2++;
	}
	
	GridObj.SetComboSelectedHiddenValue('UNIT_MEASURE',i,"<%=CATAL_BASIC_UNIT[i]%>");
	GridObj.SetCellValue("MATERIAL_TYPE", i, "");
	GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS,"<%=CATAL_DELY_TO_ADDRESS[i]%>");
<%
		}
	}
%>
}
    
function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;
	var f = document.forms[0];
		
	if(msg1 == "t_insert") {
		if(msg3 == INDEX_PR_QTY || msg3 == INDEX_UNIT_PRICE) {
			calculate_pr_amt(wise, msg2);
    	      	
			if(summaryCnt == 0) {
				GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
				GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
				summaryCnt++;
			}
		}
		else if(msg3 == INDEX_CUR){//통화 변경시
			var cur = GD_GetCellValueIndex(GridObj,msg2, INDEX_CUR);
      			
			if(cur == 'KRW'){
				GridObj.SetCellActivation('EXCHANGE_RATE',msg2,'activatenoedit');
			}
			else{
				GridObj.SetCellActivation('EXCHANGE_RATE',msg2,'edit');
			}
		}
	}
	
	if(msg1 == "t_imagetext"){
		G_CUR_ROW = msg2;
		
		if(msg3 == INDEX_ITEM_NO) {}
		
		if(msg3==INDEX_DELY_TO_LOCATION) {
			PopupManager("DELY_TO_LOCATION");
		}
		
		if(msg3==INDEX_REC_VENDOR_NAME) {
			PopupManager("REC_VENDOR_NAME");
		}
		
		if(msg3 == INDEX_ATTACH_NO) {
			var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
			
			Arow = msg2;
			
			document.form1.attach_gubun.value = "wise";
			
			if("" == ATTACH_NO_VALUE) {
				FileAttach('PR','','');
			}
			else {
				FileAttachChange('PR', ATTACH_NO_VALUE);
			}
		}
		
		if(msg3==INDEX_MAKER_NAME){
			if(GridObj.GetCellInfo("activation", "DESCRIPTION_LOC", msg2) == "edit"){
				SP9053_Popup();
			}
		}
	}
	
	if(msg1 == "t_header"){
		if(msg3==INDEX_RD_DATE){
			copyCell(wise, INDEX_RD_DATE, "t_date");
		}
	}
	
	if(msg1 == "doData"){
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);
		
		if(mode == "setPrCreate"){
			alert(GridObj.GetMessage());
			
			if(status != "0"){
				GridObj.RemoveAllData();
				f.pr_tot_amt.value = "";
				f.attach_no.value = "";
				rMateFileAttach('S','C',f.doc_type.value,f.attach_no.value);
			}
			
			location.href = "/kr/dt/pr/pr1_bd_lis1.jsp";
		}
	}
}

function setAttach(attach_key, arrAttrach, attach_count){
	if(document.form1.attach_gubun.value == "wise"){
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, "<%=G_IMG_ICON%>" + "&" + attach_count + "&" + attach_key, "&");
	}
	else{
		var f = document.forms[0];
		f.attach_no.value = attach_key;
		f.attach_count.value = attach_count;
	}
	
	document.form1.attach_gubun.value="body";
}

/**
 * 구매요청금액을 계산한다.
 */
function calculate_pr_amt(wise, row){
	var prQty      = GD_GetCellValueIndex(GridObj, row, INDEX_PR_QTY);
	var unitPrice  = GD_GetCellValueIndex(GridObj, row, INDEX_UNIT_PRICE);
	var calculEval = getCalculEval(unitPrice);
	var prAmt      = 0;
	
	calculEval = prQty * calculEval;
	calculEval = getCalculEval(calculEval);
	prAmt      = RoundEx(calculEval, 3); // 소숫점 두자리까지 계산
	prAmt      = prAmt + "";
	
	if(prAmt.length > 17){
		alert("금액이 너무 큽니다.");
		
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_AMT,     "0");
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_QTY,     "0");
		GD_SetCellValueIndex(GridObj, row, INDEX_UNIT_PRICE, "0");
	}
	else{
		GD_SetCellValueIndex(GridObj, row, INDEX_PR_AMT, prAmt);
	}
	
	calculate_pr_tot_amt();
}

function RoundEx(val, pos){
    var rtn;
    
    rtn = Math.round(val * Math.pow(10, Math.abs(pos)-1))
    rtn = rtn / Math.pow(10, Math.abs(pos)-1)

    return rtn;
}

/*
 총금액을 계산한다.
 calculate_pr_amt에서 호출한다.
 */
function calculate_pr_tot_amt(){
	var f          = document.forms[0];
    var pr_tot_amt = 0;
    var pr_amt     = 0;

    for(var i=0;i<GridObj.GetRowCount();i++){
		pr_amt     = GD_GetCellValueIndex(GridObj, i, INDEX_PR_AMT);
		pr_amt     = getCalculEval(pr_amt);
		pr_tot_amt = pr_tot_amt + pr_amt;
	}
    
	f.expect_amt.value = add_comma(pr_tot_amt, 0);
}
  
/**
 * 결재, 저장 전 데이터 체크
 */
function checkData(wise, f){
	var iRowCount = GridObj.GetRowCount();
	
    if(f.demand_dept.value == ""){
        alert("요청자의 부서가 없습니다.");
        
        f.demand_dept.focus();
        
        return false;
    }
    
    if(f.add_user_id.value == ""){
        alert("요청자가 없습니다.");
        
        f.add_user_id.focus();
        
        return false;
    }
    
    if(f.vendor_code.value == ""){
		alert("실사 업체를 선택하여 주십시오.");		
		return;
	}
	
	if(f.subject.value == ""){
      alert("실사요청명을 입력하셔야합니다.");
      
      f.subject.focus();
      
      return false;
    }
	
    for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) != true){
			continue;
		}
        
		if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC))){
			alert("품목명을 입력하셔야합니다.");
			
			return false;
		}
		
		if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))){
			alert("수량을 입력하셔야합니다.");
			
			return false;
		}
		
		if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0){
			alert("수량은 0보다 커야합니다.");
			
			return false;
		}
		
		if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE))){
			alert("납기요청일을 입력하셔야합니다.");
			
			return false;
		}
		
		
		var rdDateColValue = GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE);
		
		rdDateColValue = rdDateColValue.replace("/", "");
		rdDateColValue = rdDateColValue.replace("/", "");
		
		if(rdDateColValue <= Number(<%=SepoaDate.getShortDateString()%>)){
			alert("납기요청일은 오늘 이후 날짜로 설정해야 합니다.");
			
			return false;
		}
		
	}

    return true;
}

/*
 결재, 저장
 */
function Approval(sign_status){
	var wise = GridObj;
	var f = document.forms[0];
	var iRowCount = GridObj.GetRowCount();
	var isSelected = false;
	
	for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true){
			isSelected = true;
			
			break;
		}
	}
	
	if(isSelected == false){
		alert("구매요청 대상 품목을 선택하여 주십시오.");
		
		return;
	}
	
	if(!checkData(wise, f)){
		return;
	}
	
	// 결재상태 변경
	f.sign_status.value = sign_status;
	    
	if(sign_status == "P") {
		f.method = "POST";
		f.target = "childFrame";
		f.action = "/kr/admin/basic/approval/approval.jsp";
		f.submit();
	}
	else {
		getApproval(sign_status);
	}
}//Approval End

function getApproval(approval_str) {
	$("#tdApprovalE").hide();
	//$("#tdApprovalT").hide();
	
	var f = document.forms[0];

	if(approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}

	var Message = "";
	
	if(f.sign_status.value == "T"){
		Message = "임시저장 하시겠습니까?";
	}
	else if(f.sign_status.value == "E"){
		Message = "업체전송 하시겠습니까?";
	}
		
	if(!confirm(Message)) {
		$("#tdApprovalE").show();
		//$("#tdApprovalT").show();
		
		return;
	}
		
	f.approval_str.value = approval_str;
	
	getApprovalSend(approval_str);
}

function getApprovalSend(approval_str) {
	var wise = GridObj;
	var f = document.forms[0];
	
	var expectAmt = document.getElementById("expect_amt").value;
	
	expectAmt = del_comma(expectAmt);
	
	document.getElementById("expect_amt").value = expectAmt;
	document.getElementById("pr_tot_amt").value = expectAmt;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=createOs";
	//var params = "mode=setPrCreate";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(G_SERVLETURL, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED",grid_array);
}


function fnCreate(status){
	//var statusObject       = document.getElementById("status");
	var grid_array         = getGridChangedRows(GridObj, "SELECTED");
	var url                = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_ins1";
	
	var i                  = 0;
	var rowCount           = GridObj.GetRowCount();
	var chkCount           = 0;
	var confirmMessage    = null;
	var selectedColValue   = null;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue   = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
		
		if(selectedColValue == true){
			chkCount++;		
		}
	}
	
	
	
	var f = document.forms[0];
	
	if(f.vendor_code.value == ""){
		alert("실사 업체를 선택하여 주십시오.");		
		return;
	}
	
	if(f.subject.value == ""){
		alert("실사요청명을 입력하여 주십시오.");
		return;
	}
	
	if(chkCount == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
	
	if(status == "T"){
		confirmMessage = "임시저장하시겠습니까?";
	}
	else if(status == "P"){
		confirmMessage = "업체전송하시겠습니까?";
	}
	
	if(confirm(confirmMessage)){
		//statusObject.value = status;
		
		url = url + "?mode=createOs";
		url = url + "&cols_ids=<%=grid_col_id%>";
		url = url + dataOutput();
		myDataProcessor = new dataProcessor(url);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}



function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "P") {
		var protocol = location.protocol;
		var host     = location.host;
		var addr     = protocol +"//" +host;

		var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

		f.method = "POST";
		f.target = "fileattach";
		f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
		f.submit();
	}
	else if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	if (document.form1.attach_gubun.value == "wise"){
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

		document.form1.attach_gubun.value="body";
	}
	else {
		var f = document.forms[0];
		f.attach_no.value    = attach_key;
		f.attach_count.value = attach_count;

		var approval_str = f.approval_str.value;
		getApprovalSend(approval_str);
	}
}


/*
 팝업 관련 코드
 */
function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	var wise = GridObj;

	if(part == "CATALOG"){ //카탈로그
		if(f.vendor_code.value == ""){
			alert("실사업체를 선택 하십시요");        
			return;
		}
	
		setCatalogIndex(G_C_INDEX);
		
		url = "/kr/catalog/cat_pp_lis_main_so.jsp?INDEX=" + getAllCatalogIndex() + "&VENDOR_CODE=" + f.vendor_code.value ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}	
    else if(part == "DELY_TO_LOCATION"){
		var plant_code = f.demand_dept.value;
		var item_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW,INDEX_ITEM_NO);
		var arr = new Array(G_HOUSE_CODE, G_COMPANY_CODE, plant_code,item_no );//
		
		PopupCommonArr("SP0237","getDely", arr, "","");
	}
    else if(part == "DELY_TO_ADDRESS_GRID"){
    	window.open("/common/CO_009.jsp?callback=getDemandGrid", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ITEM_NO"){
		var arr = new Array(G_HOUSE_CODE, "" );
		PopupCommonArr("SP0268","getItem",arr,"","");
    }
    else if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "SALES_DEPT"){
		window.open("/common/CO_009.jsp?callback=getSales", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "CUST_CODE"){
		PopupCommon0("SP0277","getCust","매출처코드","매출처명");
    }
    else if(part == "REC_VENDOR_NAME"){
		window.open("/common/CO_014.jsp?callback=getRecv", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
    }
    else if(part == "ATTACH_FILE"){
		var attach_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ATTACH_NO);
		
		attach_file(attach_no,"PR");
    }
    else if(part == "ADD_USER_ID"){
    	window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
}

function searchCust() {
	PopupCommon0("SP0120F","scms_getCust","고객사코드","고객사명");
}
  
/* 고객사 조회*/
function scms_getCust(code, text, div) {
	document.form1.scms_cust_type.value = div;
	document.form1.scms_cust_code.value = code;
	document.form1.scms_cust_name.value = text;
}

function getDemand(code, text){
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

function getDemandGrid(code, text){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_ADDRESS_CD, code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_ADDRESS, text);
}

function getSales(code, text){
	document.form1.sales_dept_name.value = text;
	document.form1.sales_dept.value = code;
}

function getRecv(code, text){
	var wise = GridObj;
	
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_REC_VENDOR_CODE, code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_REC_VENDOR_NAME, text);
}

function getItem(code, text, basic_unit){
	var wise = GridObj;
	
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ITEM_NO,  "<%=G_IMG_ICON%>" + "&"+code+"&"+code, "&");
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DESCRIPTION_LOC, text);
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_UNIT_MEASURE, basic_unit);
}

function getCust(code, text){
	document.form1.cust_name.value = text;
	document.form1.cust_code.value = code;
}

function getDely(code, text){
	var wise = GridObj;
	
	GD_SetCellValueIndex(GridObj,G_CUR_ROW, INDEX_DELY_TO_LOCATION, "<%=G_IMG_ICON%>" + "&"+text+"&"+code, "&");
}

function getAddUser(code, text){
	document.form1.add_user_name.value = text;
	document.form1.add_user_id.value = code;
}

/*
 업체지정 팝업(VENDOR_SELECT)에서 호출한다.
 @parameter
 szRow           : 넘긴 와이즈테이블 로우
 values          : vendor_code@vendor_name@name@#
 count           : 선택된 업체수가 넘어온다.
*/
function vendorInsert(szRow, values, count){
	if(szRow == "-1") {
		for(row=0; row<GridObj.GetRowCount(); row++) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_CODE,  "<%=G_IMG_ICON%>" + "&" + count + "&Y", "&");
				GD_SetCellValueIndex(GridObj,row, INDEX_REC_VENDOR_SELECTED, values);
				GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_CNT, count);
			}
		}
	}
	else {
		GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_CODE,  "<%=G_IMG_ICON%>" + "&" + count + "&Y", "&");
		GD_SetCellValueIndex(GridObj,szRow, INDEX_REC_VENDOR_SELECTED, values);
		GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_CNT, count);
	}
}
  
function SP1001_Popup() {
	var left = 0;
    var top = 0;
    var width = 540;
    var height = 500;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'no';
    var resizable = 'no';
    var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP1001&function=SP1001_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=프로젝트&desc=프로젝트명";
    CodeSearchCommon(url, 'doc', left, top, width, height);
}

function SP1001_Popup_getCode(z_code1, project_name) {
	document.form1.z_code1.value = z_code1;
	document.form1.project_name.value = project_name;
}

function POPUP_Open(url, title, left, top, width, height) {
	var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    code_search.focus();
}

function ExView(view_flag){
	if(view_flag==0){
		GridObj.SetColHide("EXCHANGE_RATE", true);
		GridObj.SetColHide("KRW_AMT", true);
	}
	else if(view_flag==1){
		GridObj.SetColHide("EXCHANGE_RATE", false);
        GridObj.SetColHide("KRW_AMT", false);
	}
	else{}
}

function GridView(){
    setHeader_1();
	
    summaryCnt = 0;
}

function addDate(year,month,day,week){
	window.self.document.forms[0].add_date.value=year+month+day;
}

function returnhopeDay(year,month,day,week){
	window.self.document.forms[0].return_hope_day.value=year+month+day;
}

function contractDay(year,month,day,week){
	window.self.document.forms[0].contract_hope_day.value=year+month+day;
}

function contractFromDate(year,month,day,week){
	window.self.document.forms[0].contract_from_date.value=year+month+day;
}

function contractToDate(year,month,day,week){
	window.self.document.forms[0].contract_to_date.value=year+month+day;
}

function PrdeleteWiseTable() {
	var rowCount = GridObj.GetRowCount();
	var selected = false;
	var rowid    = "";
	
	for(var i = (rowCount - 1); i >= 0; i--){
		selected   = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
		
		if(selected == true){
			rowid = GridObj.getRowId(i);
			
			GridObj.deleteRow(rowid);
		}
	}
}
 


function selectCode( maker_code, maker_name) {
	GridObj.SetCellValue("MAKER_CODE",G_CUR_ROW, maker_code);
	GridObj.SetCellValue("MAKER_NAME",G_CUR_ROW, maker_name);
	GridObj.SetCellHiddenValue("MAKER_NAME",G_CUR_ROW, maker_name);
}

function SP9053_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}
	   
function  onlyNumber(obj){  
	var keycode = event.keyCode;
	
	if( !((48 <= keycode && keycode <=57) || keycode == 13 || keycode == 46) ){
		event.keyCode = 0;
		alert("숫자만 입력 가능합니다.")
	}
}

function fnFormInputSet(inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	
	return input;
}

function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function fnMa014Pop(){
	var f = document.forms[0];
	 
	if(f.vendor_code.value == ""){
		alert("실사업체를 선택 하십시요");        
		return;
	}
	
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	
	window.open("","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	var form = fnGetDynamicForm("/kr/bom/ma_014.jsp?vendor_code=" + f.vendor_code.value, inputParam, "windowopen1");
	
	body.appendChild(form);
	
	form.submit();
	
	body.removeChild(form);
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId, cellInd){
	if(cellInd == GridObj.getColIndexById("REC_VENDOR_NAME")) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		
		PopupManager("REC_VENDOR_NAME");
	}
	else if(cellInd == GridObj.getColIndexById("ITEM_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var itemNo     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	}
	else if(cellInd == GridObj.getColIndexById("DELY_TO_ADDRESS")) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		PopupManager('DELY_TO_ADDRESS_GRID');
	}
	
	else if(cellInd == GridObj.getColIndexById("IMAGE_FILE")) {
		
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var image_file_path = SepoaGridGetCellValueId(GridObj, rowId, "IMAGE_FILE_PATH");
		
		if(image_file_path != null && image_file_path != "") {
			
			var url    = "/common/image_view_popup.jsp";
			
			window.open(url + '?item_no=' + item_no ,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=650,left=0,top=0");
			
		}
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage, rowId, cellInd){
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
    	var prQtyIndex     = GridObj.getColIndexById("PR_QTY");
    	var unitPriceIndex = GridObj.getColIndexById("UNIT_PRICE");
    	var rowIndex       = GridObj.getRowIndex(GridObj.getSelectedId());
        
        if((cellInd == prQtyIndex) || (cellInd == unitPriceIndex)){
    		calculate_pr_amt(GridObj, rowIndex);
    	    
    		/*
    		if(summaryCnt == 0) {
    			GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
    			GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
    			summaryCnt++;
    		}
    		*/
    	}
        
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        
		//location.href = "/kr/dt/pr/pr1_bd_lis1.jsp";
    	var url = "/kr/so/sos_bd_lis1.jsp"; 
		topMenuClick(url, "MUO141000002", "5", '2');
// 		topMenuClick(url, "MUO140800002", "1", '');
    }
    else {
        alert(messsage);
    }
    
    if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
    } 

    return false;
}



// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

/*
첫번째 행의 납품요청일자/납품일자 모든 행에 일괄적용
*/
function setDeliveryData() {
	
	var RD_DATE = '';
	var DELY_TO_ADDRESS = '';
	var DELY_TO_ADDRESS_CD = '';
	
	var iRowCount = GridObj.GetRowCount();
	
	for(var i = 0; i < iRowCount; i++) {
		if(i == 0) {
			RD_DATE = GD_GetCellValueIndex(GridObj, i, INDEX_RD_DATE);
			DELY_TO_ADDRESS = GD_GetCellValueIndex(GridObj, i, INDEX_DELY_TO_ADDRESS);
			DELY_TO_ADDRESS_CD = GD_GetCellValueIndex(GridObj, i, INDEX_DELY_TO_ADDRESS_CD);
		} else {
			if(isEmpty(RD_DATE) || isEmpty(DELY_TO_ADDRESS)){
				alert('첫번째 행의 납기요청일자/납품장소를 입력하십시오.');
				return;
			} else {
				GD_SetCellValueIndex(GridObj,i, INDEX_RD_DATE, RD_DATE);
				GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS, DELY_TO_ADDRESS);
				GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS_CD, DELY_TO_ADDRESS_CD);
			}
		}
	}
	
}

function getVendorCode(setMethod) {
	window.open("/common/CO_014.jsp?callback=" + setMethod, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

function setVendorCode( code, desc1, desc2 , desc3) {
	$("#vendor_code").val(code);
	$("#vendor_code_name").val(desc1);
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
        
        GridObj.clearAll();        
    }
    else if( type == "purchase_id" ) {
    	document.forms[0].purchase_id.value = "";
        document.forms[0].purchase_name.value = "";
    }
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<input type="hidden" name="sign_status" id="sign_status" value="N"> <!-- 저장,결재를 구분하는 플래그 -->
	
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" id="doc_type" value="PR">
		<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
		<input type="hidden" name="pr_tot_amt" id="pr_tot_amt">
		<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
		<input type="hidden" name="dely_to_location" id="dely_to_location" value="S100">
		<input type="hidden" name="plan_code" id="plan_code" value="1000">
	
		<input type="hidden" name="att_mode" id="att_mode"   value="">
		<input type="hidden" name="view_type" id="view_type"  value="">
		<input type="hidden" name="file_type" id="file_type"  value="">
		<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
		<input type="hidden" name="attach_count" id="attach_count" value="">
		<input type="hidden" name="approval_str" id="approval_str" value="">
		<%--수주번호 조회 정보 HIDDEN FIELD--%>
		<input type="hidden" name="cl_biz" id="cl_biz" value="">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class="cell_title1">&nbsp;◆ 관리정보</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
      									<td  width="35%" class="data_td">
											<input type="text" name="demand_dept" id="demand_dept" size="10" class="input_re" value='<%=info.getSession("DEPARTMENT")%>' readOnly>
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
												<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" maxlength="15" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>' style="border:0">
											</a>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자</td>
										<td class="data_td" >
											<input type="text" name="add_user_id" id="add_user_id" size="13" class="input_re"  value='<%=info.getSession("ID")%>' readOnly>
											<a href="javascript:PopupManager('ADD_USER_ID')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="add_user_name" id="add_user_name" size="20" class="input_data2"  value='<%=info.getSession("NAME_LOC")%>'>
										</td>
									</tr>									
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="3"></td>
			</tr>
			<tr>
				<td align="left" class="cell_title1">&nbsp;◆ 등록정보</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청명</td>
										<td width="85%" class="data_td"  colspan="3" >
											<input type="text" name="subject" id="subject" style="width:93%" class="input_re" onKeyUp="return chkMaxByte(500, this, '요청명');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>	  	
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사업체</td>
										<td class="data_td" colspan="3" >
											<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="12" class="inputsubmit" maxlength="10" style="ime-mode:inactive"  readonly>
											<a href="javascript:getVendorCode('setVendorCode')">
												<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')">
												<img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0">
											</a>
											<input type="text" name="vendor_code_name" id="vendor_code_name" size="20"  readonly>			
										</td>
									</tr>									
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특이사항</td>
										<td class="data_td" colspan="3">
											<input type="text" name="remark" id="remark" style="width:95%" class="inputsubmit" value="" onKeyUp="return chkMaxByte(4000, this, '특이사항');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr>				
										<td class="title_td" WIDTH="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청일자</td>
										<td class="data_td" width="35%">
											<s:calendar id="osqDate" default_value="<%=SepoaString.getDateSlashFormat(CURRENT_DATE)%>" format="%Y/%m/%d"/>
										</td>
										<td class="title_td"  WIDTH="15%" style='display:none;'>&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예상금액(자동계산)</td>
										<td class="data_td" width="35%" style='display:none;'>
											<input type="text" name="expect_amt" id="expect_amt" style="width:70%" class="inputsubmit" readonly>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr style='display:none;'>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.getElementById("attach_no").value = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}
	
btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="0" name="sign_attach_no_count" id="sign_attach_no_count"/>
														<input type="hidden" value="" name="attach_no" id="attach_no">
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:setDeliveryData()", "납기요청일/납품장소 일괄적용");
</script>
							</TD>
							<TD>
								<font color="red" style="font-size:10px">&nbsp;* 납기요청일과 납품장소를<br>&nbsp;&nbsp;&nbsp;&nbsp;첫번째 행 기준으로 일괄적용합니다.</font>
							</TD>
						</TR>
					</TABLE>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0" border="0">
						<TR>							
							<TD>
<script language="javascript">
btn("javascript:fnMa014Pop()", "BOM품목");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:PopupManager('CATALOG')", "품목카탈로그");
</script>
							</TD>							
							<!-- TD id="tdApprovalT">
<script language="javascript">
btn("javascript:Approval('T')", "임시저장");
</script>
							</TD -->
							<TD id="tdApprovalE">
<script language="javascript">
btn("javascript:Approval('E')", "업체전송");
//btn("javascript:fnCreate('P')", "업체전송");
</script>
							</TD>
						<%-- 
							<TD>
<script language="javascript">
btn("javascript:PrdeleteWiseTable()", "행삭제");
</script>
							</TD>
							--%>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SO_000" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>