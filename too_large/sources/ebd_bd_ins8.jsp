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
	String       SepoaHUB_PROCESS_ID     = "PR_038";
	String       screen_id               = null;
	String       USER_ID                 = info.getSession("ID");
    String       HOUSE_CODE              = info.getSession("HOUSE_CODE") ;
    String       COMPANY_CODE            = info.getSession("COMPANY_CODE") ;
    String       CURRENT_DATE            = SepoaDate.getShortDateString();
    String       RETURN_HOPE_DAY         = SepoaDate.addSepoaDateDay(CURRENT_DATE,7);
    String       LB_CODE_SHIPPER_TYPE    = "D";
    String       LB_PR_TYPE              = ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", "I");
    String       LB_MAINTANCE_TERM       = ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", "");
    String       LB_CREATE_TYPE          = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", "BD");
    String       LB_BSART                = ListBox(request, "SL0018",  HOUSE_CODE+"#M371#", "");
    String       LB_S_SALES_TYPE         = ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", "P");
    String       COMBO_M000              = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M169#", "&" , "#");
    String       COMBO_M001              = LB.Table_ListBox(request, "SL0018", HOUSE_CODE+"#M170#", "&" , "#");
    String       COMBO_M002              = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M002#", "&" , "#");
    String       COMBO_IDX_M002          = ""+CommonUtil.getComboIndex(COMBO_M002,"KRW","#");
    String       COMBO_M007              = LB.Table_ListBox(request, "SL0014", HOUSE_CODE+"#M007#", "&" , "#");
    String       COMBO_IDX_M007          = ""+CommonUtil.getComboIndex(COMBO_M007,"EA","#");
    String       COMBO_M933              = LB.Table_ListBox(request, "SL0022", HOUSE_CODE+"#M933#", "&" , "#");
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
	
	multilang_id.addElement("PR_038");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	text      = MessageUtil.getMessage(info, multilang_id);
	screen_id = request.getParameter("screen_id");
	screen_id = JSPUtil.nullToEmpty(screen_id);
	screen_id = this.nvl(screen_id, "PR_038");
	
	Object[] obj1 = {info.getSession("DEPARTMENT")};
    SepoaOut value1 = ServiceConnector.doService(info, "p1015", "CONNECTION", "getApprvalId", obj1);
    //SepoaOut value1 = ServiceConnector.doService(info, "p1015", "CONNECTION", "getApprvalId", null);
    SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
    String approval_id = "";
    String approval_name = "";
    if(wf1.getRowCount() > 0) {
    	approval_id = wf1.getValue("USER_ID", 0);
    	approval_name = wf1.getValue("USER_NAME_LOC", 0);
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
var G_SERVLETURL                 = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins3";
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



var INDEX_SELECTED          ;
var INDEX_APP_DIV           ;
var INDEX_REMARK            ;
var INDEX_ASSET_TYPE        ;
var INDEX_KTEXT             ;
var INDEX_KAMT              ;
var INDEX_ITEM_NO           ;
var INDEX_IMAGE_FILE_PATH   ;
var INDEX_IMAGE_FILE        ;
var INDEX_DESCRIPTION_LOC   ;
var INDEX_MODEL_NO          ;
var INDEX_SPECIFICATION     ;
var INDEX_BASIC_UNIT        ;
var INDEX_UNIT_PRICE        ;
var INDEX_PR_QTY            ;
var INDEX_PR_AMT            ;
var INDEX_RD_DATE           ;
var INDEX_KTGRM             ;
var INDEX_MATERIAL_CTRL_TYPE;
var INDEX_MATERIAL_TYPE     ;

var G_CUR_ROW;//팝업 관련해서 씀..

function init() {
	setGridDraw();
	setHeader_1();
	GridView(0);
}

function setHeader_1(){
	var wise = GridObj;

	INDEX_SELECTED                        = GridObj.GetColHDIndex("SELECTED");
	INDEX_APP_DIV                         = GridObj.GetColHDIndex("APP_DIV");
	INDEX_REMARK                          = GridObj.GetColHDIndex("REMARK");
	INDEX_ASSET_TYPE                      = GridObj.GetColHDIndex("ASSET_TYPE");
	INDEX_KTEXT                           = GridObj.GetColHDIndex("KTEXT");
	INDEX_KAMT                            = GridObj.GetColHDIndex("KAMT");
	INDEX_ITEM_NO                         = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_IMAGE_FILE_PATH                 = GridObj.GetColHDIndex("IMAGE_FILE_PATH");
	INDEX_IMAGE_FILE                      = GridObj.GetColHDIndex("IMAGE_FILE");
	INDEX_DESCRIPTION_LOC                 = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_MODEL_NO                        = GridObj.GetColHDIndex("MODEL_NO");
	INDEX_SPECIFICATION                   = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_BASIC_UNIT                      = GridObj.GetColHDIndex("BASIC_UNIT");
	INDEX_UNIT_PRICE                      = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_PR_QTY                          = GridObj.GetColHDIndex("PR_QTY");
	INDEX_PR_AMT                          = GridObj.GetColHDIndex("PR_AMT");
	INDEX_RD_DATE                         = GridObj.GetColHDIndex("RD_DATE");
	INDEX_KTGRM                           = GridObj.GetColHDIndex("KTGRM");
	INDEX_MATERIAL_CTRL_TYPE              = GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE");
	INDEX_MATERIAL_TYPE                   = GridObj.GetColHDIndex("MATERIAL_TYPE");
	
	GridObj.strHDClickAction="select";
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

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode
				, qty, itemGroup, delyToAddress, unitPrice, ktgrm
				, makerName, basicUnit, materialType, pItemNoColValue, cUnitPrice
				, tmp1, tmp2, tmp3, tmp4, tmp5
				, imgPath){
	
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	
	GridObj.addRow(newId,"");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	     "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_APP_DIV,     	     "Z");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	     itemNo);
	if($.trim(imgPath) == ""){
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/000/icon/icon_close3.gif");
	}else{
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE,      	     "/images/ico_x1.gif");
	}
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_IMAGE_FILE_PATH,      	     imgPath); 
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MODEL_NO,           "");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_BASIC_UNIT,           basicUnit);	
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,      specification);
	
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         cUnitPrice);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_QTY,             qty);
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,              ktgrm);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,      materialType);
    
	
	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
		ADD_UNIT_MEASURE_OPTION_CNT++;
	}
	
/*
	var INDEX_SELECTED          ;
	
	var INDEX_APP_DIV           ;
	var INDEX_REMARK            ;
	var INDEX_ASSET_TYPE        ;
	var INDEX_KTEXT             ;
	var INDEX_KAMT              ;
	
	var INDEX_ITEM_NO           ;
	var INDEX_IMAGE_FILE_PATH   ;
	var INDEX_IMAGE_FILE        ;
	var INDEX_DESCRIPTION_LOC   ;
	
	var INDEX_MODEL_NO          ;
	
	var INDEX_SPECIFICATION     ;
	
	//var INDEX_BASIC_UNIT        ;
	var INDEX_UNIT_PRICE        ;
	var INDEX_PR_QTY            ;
	//var INDEX_PR_AMT            ;
	//var INDEX_RD_DATE           ;
	var INDEX_KTGRM             ;
	var INDEX_MATERIAL_CTRL_TYPE;
	var INDEX_MATERIAL_TYPE     ;
*/	
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
	    
function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;
	var f = document.forms[0];
		
	if(msg1 == "t_imagetext"){
		G_CUR_ROW = msg2;
		
		if(msg3 == INDEX_ITEM_NO) {}
		
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
	}
	
	if(msg1 == "t_header"){
		if(msg3==INDEX_RD_DATE){
			copyCell(wise, INDEX_RD_DATE, "t_date");
		}
	}
	
	if(msg1 == "doData"){
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);
		
		if(mode == "setPrCreate2"){
			alert(GridObj.GetMessage());
			
			if(status != "0"){
				GridObj.RemoveAllData();
				f.pr_tot_amt.value = "";
				f.attach_no.value = "";
				rMateFileAttach('S','C',f.doc_type.value,f.attach_no.value);
			}
			//location.href = "/kr/dt/pr/pr1_bd_lis1_2.jsp";
			topMenuClick('/kr/dt/pr/pr1_bd_lis1_2.jsp','MUO141000013', '1','');
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
 * 구매신청금액을 계산한다.
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
        alert("신청자의 부서가 없습니다.");
        
        f.demand_dept.focus();
        
        return false;
    }
    
    if(f.add_user_id.value == ""){
        alert("신청자가 없습니다.");
        
        f.add_user_id.focus();
        
        return false;
    }
    
    if(f.subject.value == ""){
      alert("구매신청명을 입력하셔야합니다.");
      
      f.subject.focus();
      
      return false;
    }
    
	if(f.create_type.value == ""){
		alert("요청구분을 입력하셔야합니다.");
		
		f.create_type.focus();
		
		return false;
	}
	
	if(f.sales_user_id.value == ""){
		alert("검수자를 입력하셔야합니다.");
		
		f.sales_user_id.focus();
		
    	return false;
    }

    for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) != true){
			continue;
		}
        
		if(f.pr_type.value == 'I'){
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
				alert("배송희망일을 입력하셔야합니다.");
				
				return false;
			}
		}
		else{
			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC))){
				alert("기술구분을 입력하셔야합니다.");
				
				return false;
			}
			
			if(isEmpty(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))){
				alert("공수(MM)을 입력하셔야합니다.");
				
				return false;
			}
			
			if(parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_PR_QTY))==0){
				alert("공수(MM)은 0보다 커야합니다.");
				
				return false;
			}
		}
		
		var rdDateColValue = GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE);
		
		rdDateColValue = rdDateColValue.replace("/", "");
		rdDateColValue = rdDateColValue.replace("/", "");
		
		if(rdDateColValue <= Number(<%=SepoaDate.getShortDateString()%>)){
			alert("배송희망일은 오늘 이후 날짜로 설정해야 합니다.");
			
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
	var approval_str = "";
	var approval_id = "";
	for(var i=0;i<iRowCount;i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true){
			isSelected = true;
			
			break;
		}
	}
	
	if(isSelected == false){
		alert("구매신청 대상 품목을 선택하여 주십시오.");
		
		return;
	}
	
	if(!checkData(wise, f)){
		return;
	}
	// 결재상태 변경
	f.sign_status.value = sign_status;
	    
	if(sign_status == "P") {
		alert(1);
		f.method = "POST";
		f.target = "childFrame";
		f.action = "/kr/admin/basic/approval/approval.jsp";
		f.submit();
	}
	else {
		approval_id = document.getElementById("approval_id").value;
		approval_str = "UrgentFlag===F|||SignUserId==="+ approval_id +"|||SignRemark===|||auto_flag===A|||strategy===|||attach_no===|||Sign_Path===1 #"+ approval_id +" #130000 # #P #Y #$";
		getApproval(approval_str);
	}
}//Approval End

/*
결재요청
*/
function getApproval(approval_str){
	
	if(approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	
	
	document.getElementById("approval_str").value = approval_str;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var params = "?mode=setPrCreate2";
	
	var tmp = "";
	if(grid_array.length > 0){
		for(var i = 0; i < grid_array.length; i++) {
			if(i < 5){
				tmp += GridObj.cells(grid_array[i], GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();	
			    if(i != (grid_array.length-1)){
			    	tmp += ",";	
			    }
			}
		}
		
		if(grid_array.length > 5){
			tmp += " 외 " + (grid_array.length-5) + "건 구매신청" ;
		}else{
			tmp += " 구매신청";
		}
	}
	$("#subject").val(tmp);
	
	
//	String add_user_dept   =  info.getSession("DEPARTMENT");
//  String dept_name       =  info.getSession("DEPARTMENT_NAME_LOC");
	
    params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins7"+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function fnCreate(){
	var rowCount          = GridObj.GetRowCount();
	var i                 = 0;
	var selectedColIndex  = GridObj.getColIndexById("SELECTED");
	var prQtyColIndex     = GridObj.getColIndexById("PR_QTY");
	var maxReqCntColIndex = GridObj.getColIndexById("MAX_REQ_CNT");
	var minReqCntColIndex = GridObj.getColIndexById("MIN_REQ_CNT");
	var material_ctrl_type = GridObj.getColIndexById("MATERIAL_CTRL_TYPE");	//중분류 컬럼 추가
	var selectedColValue  = null;
	var checkCount        = 0;
	var checkCount3        = 0;
	var prQtyColValue     = null;
	var maxReqCntColValue = null;
	var minReqCntColValue = null;
	var material_ctrl_type_value = null;	//중분류 값 추가
	var f = document.forms[0];
    /*
    if(f.subject.value == ""){
      alert("구매신청명을 입력하셔야합니다.");
      
      f.subject.focus();
      
      return false;
    }
    */
	//대분류가 재산관리인 경우 신청구분 선택여부와 고유번호/취득일자/취득금액/신청사유 입력여부 체크
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	for(var i = 0; i < grid_array.length; i++) {
		var item_no = GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_NO")).getValue();
		var material_type = GridObj.cells(grid_array[i], GridObj.getColIndexById("MATERIAL_TYPE")).getValue();
		var app_div = GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_DIV")).getValue();
		var asset_type = GridObj.cells(grid_array[i], GridObj.getColIndexById("ASSET_TYPE")).getValue();
		var ktext = GridObj.cells(grid_array[i], GridObj.getColIndexById("KTEXT")).getValue();
		var kamt = GridObj.cells(grid_array[i], GridObj.getColIndexById("KAMT")).getValue();
		var remark = GridObj.cells(grid_array[i], GridObj.getColIndexById("REMARK")).getValue();
	    var pr_qty = GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_QTY")).getValue();
	    
		checkCount3 = 0;
		for(var j = 0; j < grid_array.length; j++) {
			var item_no2 = GridObj.cells(grid_array[j], GridObj.getColIndexById("ITEM_NO")).getValue();
			var description_loc = GridObj.cells(grid_array[j], GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
			if(item_no == item_no2){
				checkCount3++;
			}
			
			if(checkCount3 > 1) {
				alert("동일 품목이 존재합니다. \r\n동일품목 : "+ description_loc + " ("+ item_no2 +")");
				return;
			}
		}
		
		
		if( material_type == "02" && (app_div == "Z" || app_div == "")) {
			//alert("대분류가 재산관리인 품목은 신청구분을 선택하지 않으면 처리할 수 없습니다.");
			alert("업무용동산 품목은 신청구분에 신규/교체 여부를 선택하셔야 합니다.");
			return;
		}
		if( material_type == "02" && (remark == null || remark == "")) {
			alert("신청사유가 없으면 처리할 수 없습니다.");
			return;
		}
		
		if( material_type == "02" && app_div == "B" ) {
			if(pr_qty == ""){
				alert("교체수량을 입력하여 주십시오.");
				return;
			}
			
			if(Number(pr_qty) != 1){
				alert("교체수량은 1개만 입력가능합니다.");
				return;
			}
			
			if( asset_type == null || asset_type == "" ) {
				
				alert("교체건은 동산 고유번호를 지정해주세요.");
				return;
				
			}
			
			if( ktext == null || ktext == "" ) {
				
				alert("교체건은 동산 취득일자가 없으면 처리할 수 없습니다.");
				return;
				
			}
			
			if( kamt == null || kamt == "" ) {
				
				alert("교체건은 동산 취득금액이 없으면 처리할 수 없습니다.");
				return;
				
			}
			
			if( remark == null || remark == "" ) {
				
				alert("신청사유가 없으면 처리할 수 없습니다.");
				return;
				
			}
			
		}
		
		if((pr_qty == "") || (Number(pr_qty) <= 0)){
			alert("신청수량을 입력하여 주십시오.");
			
			return;
		}
		
		//var rdDateColValue = GD_GetCellValueIndex(GridObj,i, INDEX_RD_DATE);
		var rd_date = GridObj.cells(grid_array[i], GridObj.getColIndexById("RD_DATE")).getValue();
		
		rd_date = rd_date.replace("/", "");
		rd_date = rd_date.replace("/", "");
		
		if(isEmpty(rd_date)){
			alert("배송희망일을 입력하셔야합니다.");
			
			return false;
		}	
		if(rd_date <= Number(<%=SepoaDate.getShortDateString()%>)){
			alert("배송희망일은 오늘 이후 날짜로 설정해야 합니다.");
			
			return false;
		}
		
		checkCount++;
	}
	
// 	alert("material_ctrl_type_before==="+material_ctrl_type_before);
	var confirm_msg = "결재상신 하시겠습니까?";
	if(checkCount > 0){
		
		if(f.approval_id.value == ""){
	        alert("결재자를 지정해주세요.");
	        
	        f.approval_id.focus();
	        
	        return false;
	    }
	    
	    if(!f.ckb_approval.checked){
	        alert("결재자 확인후\r\n\r\n결재자확인 버튼을 클릭 해주세요.");
	        
	        return false;
	    }
	    
		if(confirm(confirm_msg)){
			/*
			var frm = document.getElementById("frm");
			
			frm.method = "POST";
			frm.target = "childFrame";
			frm.action = "/kr/admin/basic/approval/approval.jsp";
			
			frm.submit();
			*/
			approval_id = document.getElementById("approval_id").value;
			approval_str = "UrgentFlag===F|||SignUserId==="+ approval_id +"|||SignRemark===|||auto_flag===A|||strategy===|||attach_no===|||Sign_Path===1 #"+ approval_id +" #130000 # #P #Y #$";
			getApproval(approval_str);	
		}
	}
	else{
		alert("결재상신 구매품목을 선택하여 주십시오.");
	}
}

/*
function getApproval(approval_str) {
	$("#tdApprovalE").hide();
	$("#tdApprovalT").hide();
	
	var f = document.forms[0];

	if(approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	alert(approval_str);
	return;

	var Message = "";
	
	if(f.sign_status.value == "P"){
		Message = "결재상신 하시겠습니까?";
	}
	else if(f.sign_status.value == "T"){
		Message = "임시저장 하시겠습니까?";
	}
	else if(f.sign_status.value == "E"){
		Message = "요청완료 하시겠습니까?";
	}
		
	if(!confirm(Message)) {
		$("#tdApprovalE").show();
		$("#tdApprovalT").show();
		
		return;
	}
		
	f.approval_str.value = approval_str;
	
	getApprovalSend(approval_str);
}
*/

function getApprovalSend(approval_str) {
	var wise = GridObj;
	var f = document.forms[0];
	
	var expectAmt = document.getElementById("expect_amt").value;
	
	expectAmt = del_comma(expectAmt);
	
	document.getElementById("expect_amt").value = expectAmt;
	document.getElementById("pr_tot_amt").value = expectAmt;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=setPrCreate";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(G_SERVLETURL, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED",grid_array);
// 	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
// 	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
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

	if(part == "CATALOG"){ //품목선택
		/*
		if(f.sales_type.value == ""){
			alert("구매신청구분을 선택 후 카탈로그를 선택 하십시요");
            
			return;
		}

		if(f.sales_type.value == "M"){
			alert("구매신청구분이 판매오더인 경우 카탈로그 사용을 하실 수 없습니다.");
			
			return;
		}
        */
		setCatalogIndex(G_C_INDEX);
		
		url = "/kr/catalog/cat_pp_lis_main2.jsp?INDEX=" + getAllCatalogIndex() ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"1243","720");
	}
	else if(part == "APPROVAL_ID"){
    	window.open("/common/CO_018.jsp?callback=getApprovalUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
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
    else if(part == "SALES_USER_ID"){
		window.open("/common/CO_008.jsp?callback=getSalesUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
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
    else if(part == "project_pm"){
		window.open("/common/CO_008.jsp?callback=getProject_pm", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
}

function searchCust() {
	PopupCommon0("SP0120F","scms_getCust","고객사코드","고객사명");
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

function getSalesUser(code, text){
	document.form1.sales_user_name.value = text;
	document.form1.sales_user_id.value = code;
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

function getApprovalUser(code, text){
	document.form1.ckb_approval.checked = false;
	document.form1.ckb_approval.disabled = false;
	
	document.form1.approval_name.value = text;
	document.form1.approval_id.value = code;
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

function GridView(view_flag){
    var id = "SL0018";

	if(view_flag==0){
		setHeader_1();
		var code = "M372";
		document.all.butt_i.style.display="";
		document.form1.create_type.options[0].selected = true;
		document.form1.create_type.disabled = false;
		document.form1.hard_maintance_term.disabled = false;
		document.form1.sales_type.disabled=false;
	}
	
    summaryCnt = 0;
}

function setSALES_TYPE(name, value) {
	var option1 = new Option(name, value, true);
	
	form1.sales_type.options[form1.sales_type.length] = option1;
}

function clearSALES_TYPE() {
	if(form1.sales_type.length > 0) {
		for(i=form1.sales_type.length-1; i>=0;  i--) {
			form1.sales_type.options[i] = null;
		}
	}
}

function addDate(year,month,day,week){
	window.self.document.forms[0].add_date.value=year+month+day;
}

function returnhopeDay(year,month,day,week){
	window.self.document.forms[0].return_hope_day.value=year+month+day;
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
 
function sales_com(){
	var f = document.forms[0];
	
	commaPrice(f.expect_amt,'add',0);
}
    
function getOrder_pop() {
	var left = 0;
	var top = 0;
	var width = 1024;
	var height = 600;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/dt/pr/es_bd_lis1.jsp";
	var getOrderNoWin = window.open( url, 'getOrderNoWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function setOrderNO(cd_control, nm_control, cl_biz, cd_salecust, nm_salecust, dt_contstart, dt_contend, amt_cont, cd_saledept, no_saleemp, nm_saledept, nm_saleemp){
     document.forms[0].order_no.value       = cd_control;
     document.forms[0].order_name.value     = nm_control;
     document.forms[0].cl_biz.value       = cl_biz;
     document.forms[0].cust_code.value      = cd_salecust;
     document.forms[0].cust_name.value      = nm_salecust;
     document.forms[0].sales_dept.value     = cd_saledept;
     document.forms[0].sales_user_id.value    = no_saleemp ;
     document.forms[0].sales_dept_name.value  = nm_saledept;
     document.forms[0].sales_user_name.value  = nm_saleemp ;
}

function orderChange(cd){
	GridObj.RemoveAllData();

	document.form1.bsart.value = "";

	if(cd == "M"){
		document.form1.cust_code.value = "";
		document.form1.cust_name.value = "";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";
		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		document.getElementById("t_cls01").className = "title_tdtitle_td";
		document.all["t_cls01"].innerHTML = "Sales Order";
		document.all["_div01"].style.display="block";
		document.all["_div02"].style.display="none";
		document.form1.bsart.disabled = true;
	}
	else if(cd == "P"){
		document.form1.cust_code.value = "0000100000";
		document.form1.cust_name.value = "기타(계획용)";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";

		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		document.getElementById("t_cls01").className = "title_td";
		document.all["t_cls01"].innerHTML = "WBS요소";
		document.all["_div01"].style.display="none";
		document.all["_div02"].style.display="block";
		document.form1.bsart.disabled = false;
	}
	else{
		document.form1.cust_code.value = "0000100000";
		document.form1.cust_name.value = "기타(계획용)";
		document.form1.order_no.value = "";
		document.form1.sales_amt.value = "";

		document.form1.wbs_no.value = "";
		document.form1.wbs_sub_no.value = "";
		document.form1.wbs_txt.value = "";

		document.form1.subject.value = "";
		
		if(cd == "A"){
			document.form1.bsart.value = "Z02";
		}
		
		document.getElementById("t_cls01").className = "data_td";
		document.all["t_cls01"].innerHTML = "&nbsp;";
		document.all["_div01"].style.display="none";
		document.all["_div02"].style.display="none";
		document.form1.bsart.disabled = true;
	}
}

function orderChange2(cd){
	document.form1.sales_type.value = cd;

    if(cd == "M"){
        document.getElementById("t_cls01").className = "title_td";
        document.all["t_cls01"].innerHTML = "Sales Order";
        document.all["_div01"].style.display="block";
        document.all["_div02"].style.display="none";
    }
    else if(cd == "P"){
        document.getElementById("t_cls01").className = "title_td";
        document.all["t_cls01"].innerHTML = "WBS요소";
        document.all["_div01"].style.display="none";
        document.all["_div02"].style.display="block";
    }
    else{
        document.getElementById("t_cls01").className = "data_td";
        document.all["t_cls01"].innerHTML = "&nbsp;";
        document.all["_div01"].style.display="none";
        document.all["_div02"].style.display="none";
    }
}

function getOrder_pop() {
	var left = 0;
	var top = 0;
	var width = 1024;
	var height = 600;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';

	setCatalogIndex("VBELN:KUNNR:NAME1:WAERK:VBELP:MATNR:ARKTX:KWMENG:VRKME:LGORT:PSTYV:PS_PSP_PNR:CONV_PSPNR:POST1");
	url = "/kr/dt/pr/es_bd_lis2.jsp?INDEX=" + getAllCatalogIndex() ;
	var getOrderNoWin = window.open( url, 'getOrderNoWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function getWbs_pop() {
	var url = "/kr/dt/pr/pr1_wbs_pop_main.jsp";
	
	Code_Search(url,'','','','','');
}

function setWbs(){
	var f = document.forms[0];

	for(var i=0;i<GridObj.GetRowCount();i++){
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_NO,     f.wbs_no.value);
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_SUB_NO,     f.wbs_sub_no.value);
		GD_SetCellValueIndex(GridObj,i, INDEX_WBS_TXT,    f.wbs_txt.value);
	}
}

function getItemValue(){
	var iRowCount = GridObj.GetRowCount();
	var indexItem = "";
	var itemArr = "";

	for(var i=0; i<iRowCount; i++){
		if( GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED) == "true"){
			indexItem += GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_GROUP) + ":"      //범주
		}
	}

	indexItem = indexItem.substr(0,indexItem.length-1).split(":");

	if(indexItem.length > 1){
		for(var k=0; k<indexItem.length; k++){
			if(itemArr != ""){
				itemArr = indexItem[k];
			}

			if(indexItem[k] != itemArr){
				itemArr = "Z06";
			}
		}
	}
	else{
		itemArr = indexItem;
	}

	setBsart(itemArr);
}

function setBsart(cd){
	if(document.form1.sales_type.value == "A"){
		document.form1.bsart.value = "Z02";
            
		return;
	}

	if(cd == "Z101" || cd == "Z201" || cd == "Z301"){
		document.form1.bsart.value = "Z01"; //상품구매요청
	}
	else if(cd == "Z105" || cd == "Z106" || cd == "Z206" || cd == "Z305" || cd == "Z306" || cd == "Z309"){
		document.form1.bsart.value = "Z05"; //유지보수 구매요청
	}
	else if(cd == "Z103" || cd == "Z203" || cd == "Z303" || cd == "Z403"){
		document.form1.bsart.value = "Z04"; //외주용역 구매요청
	}
	else{
		document.form1.bsart.value = "Z06"; //도급계약 요청
	}
}

function getCustomerList_pop() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var itemArr = "";
	var prArr = "";

	setCatalogIndex("VBELN:KUNNR:WAERK:NAME1:VBELP:MATNR:ARKTX:KWMENG:VRKME:LGORT:PSTYV:PS_PSP_PNR:CONV_PSPNR:POST1");
	url = "/kr/dt/pr/custom_pp_lis1.jsp?INDEX=" + getAllCatalogIndex() ;
	var getCustomerListWin = window.open( url, 'getCustomerListWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function setCustomerList(vendor_code, vendor_name){
	document.forms[0].cust_code.value = vendor_code;
	document.forms[0].cust_name.value = vendor_name;
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

//2010.12.08 swlee add
function getProject_pm(code, text){
	document.forms[0].project_pm_name.value = text;
	document.forms[0].project_pm.value = code;
}

function setDocType(strType){
	if(strType == "B"){
		document.forms[0].doc_type.value = "BR";
	}
	else if(strType == "P"){
		document.forms[0].doc_type.value = "PR";
	}

	document.forms[0].doc_type.value = "PR";
}
	   
function  onlyNumber(obj){  
	var keycode = event.keyCode;
	
	if( !((48 <= keycode && keycode <=57) || keycode == 13 || keycode == 46) ){
		event.keyCode = 0;
		alert("숫자만 입력 가능합니다.")
	}
}

function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
//	frm.appendChild(input);
	
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
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
    var header_name = GridObj.getColumnId(cellInd);
	
	var rowIndex             = GridObj.getRowIndex(rowId);
		
	if(header_name == "IMAGE_FILE") {
		
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var image_file_path = SepoaGridGetCellValueId(GridObj, rowId, "IMAGE_FILE_PATH");
		
		if(image_file_path != null && image_file_path != "") {
			
			var url    = "/common/image_view_popup.jsp";
// 			var title  = "이미지보기";
// 			var param  = "item_no=" + item_no;
			
// 			popUpOpen01(url, title, "850", "650", param);
			window.open(url + '?item_no=' + item_no ,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=650,left=0,top=0");
			
		}
		
	}
	
	if(header_name == "ASSET_TYPE") {
		
		var app_div         = SepoaGridGetCellValueId(GridObj, rowId, "APP_DIV");
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var description_loc = SepoaGridGetCellValueId(GridObj, rowId, "DESCRIPTION_LOC");
		
		if(app_div != "B") {
			alert('신청구분이 교체인 건만 고유번호를 변경할 수 있습니다.');
			return;
		} else {
			var url = '/kr/tax/pay_pp_lis2_1.jsp';
			var title = 'GridCellClick';
			url = url + "?jumjumcd=" + "<%=info.getSession("DEPARTMENT")%>";
			url = url + "&jumjumnm=" + encodeUrl("<%=info.getSession("DEPARTMENT_NAME_LOC")%>");
			url = url + "&pmkpmkcd="   + item_no;
			url = url + "&pmkpmknm="   + encodeUrl(description_loc);
// 			url = url + "?jumjumcd="   + "20644";
// 			url = url + "&jumjumnm="   + encodeUrl("총무부");
// 			url = url + "&pmkpmkcd="   + "401000";
// 			url = url + "&pmkpmknm="   + encodeUrl("전자복사기");
			url = url + "&p_row_id="   + rowId;
			url = url + "&p_cell_ind=" + cellInd;
			popUpOpen(url, title, '720', '650');
		}
	}	
}

/*
고유번호, 취득일자, 취득금액 세팅
*/
// function setAssetType(rowId, cellInd, asset_type, ktext, kamt) {
function setAssetType(rowId, asset_type, ktext, kamt) {
	//GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('ASSET_TYPE'), asset_type);
	//GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('KTEXT'), ktext);
	//GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('KAMT'), kamt);
	
	GridObj.cells(rowId, GridObj.getColIndexById("ASSET_TYPE")).setValue(asset_type);
	GridObj.cells(rowId, GridObj.getColIndexById("KTEXT")).setValue(ktext);
	GridObj.cells(rowId, GridObj.getColIndexById("KAMT")).setValue(kamt);
	
}

function changeMoney(mon)
{
	var money = del_comma(mon);

	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		alert("숫자로 입력하세요");
		
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");		
		return false;
	}
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
	  var max_value = GridObj.cells(rowId, cellInd).getValue();
	    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	    
	    var header_name = GridObj.getColumnId(cellInd);

	    if(stage==0) {
	        return true;
	    }
	    else if(stage==1) {
	    	return false;
	    }
	    else if(stage==2) {
	    	var prQtyIndex     = GridObj.getColIndexById("PR_QTY");
	    	var rowIndex       = GridObj.getRowIndex(GridObj.getSelectedId());	    	
	    	if(header_name == "PR_QTY")   { 
	    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
		    		GridObj.cells(rowId, cellInd).setValue("");
					return true;
				}
	    	}
	    	
	    	if(header_name == "APP_DIV") {
	    		if( GridObj.cells(rowId, GridObj.getColIndexById("APP_DIV")).getValue() == "Z" ) {
			    	GridObj.cells(rowId, GridObj.getColIndexById("ASSET_TYPE")).setValue("");
			    	GridObj.cells(rowId, GridObj.getColIndexById("KTEXT")).setValue("");
			    	GridObj.cells(rowId, GridObj.getColIndexById("KAMT")).setValue("");
			    	//GridObj.cells(rowId, GridObj.getColIndexById("REMARK")).setValue("");
	    		}
	    	}
	    	
	    	if(header_name == "REMARK") {
	   			if( GridObj.cells(rowId, GridObj.getColIndexById("APP_DIV")).getValue() == "Z" ) {
	   				//return false;
	   			}
	    	}
	    	
	    	if( header_name == "PR_QTY") {
				var	pr_qty    = GridObj.cells(rowId, GridObj.getColIndexById("PR_QTY")).getValue();
				var	unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
				
				var pr_amt     = floor_number(eval(pr_qty) * eval(unit_price), 0);
				GridObj.cells(rowId, GridObj.getColIndexById("PR_AMT")).setValue(pr_amt);			
			}
	    	
	    	if(cellInd == prQtyIndex){
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
        //alert(messsage);
        //doSelect();
		alert(messsage);
        
		//location.href = "/kr/dt/pr/pr1_bd_lis1.jsp";
    	var url = "/kr/dt/pr/pr1_bd_lis1_2.jsp";
		topMenuClick(url, "MUO141000013", "1", '');
// 		topMenuClick(url, "MUO140800002", "1", '');

    }
    else{
        alert(messsage);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
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
function setRemarkRdData() {
	
    var REMARK = '';
	var RD_DATE = '';
	//var DELY_TO_ADDRESS = '';
	//var DELY_TO_ADDRESS_CD = '';
	
	var iRowCount = GridObj.GetRowCount();
	
	for(var i = 0; i < iRowCount; i++) {
		if(i == 0) {
			REMARK  = GD_GetCellValueIndex(GridObj, i, INDEX_REMARK);			
			RD_DATE = GD_GetCellValueIndex(GridObj, i, INDEX_RD_DATE);
			//DELY_TO_ADDRESS = GD_GetCellValueIndex(GridObj, i, INDEX_DELY_TO_ADDRESS);
			//DELY_TO_ADDRESS_CD = GD_GetCellValueIndex(GridObj, i, INDEX_DELY_TO_ADDRESS_CD);
		} else {
			if(isEmpty(REMARK) && isEmpty(RD_DATE)){
				alert('첫번째 행의 신청사유 , 배송희망일을 입력하십시오.');
				return;
			} else {
				GD_SetCellValueIndex(GridObj,i, INDEX_REMARK, REMARK);
				GD_SetCellValueIndex(GridObj,i, INDEX_RD_DATE, RD_DATE);
				//GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS, DELY_TO_ADDRESS);
				//GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_ADDRESS_CD, DELY_TO_ADDRESS_CD);
			}
		}
	}
}

function ckb_approval_onclick() {
	var f = document.forms[0];
	//if(!f.ckb_approval.checked){       
		f.ckb_approval.checked = true;
		f.ckb_approval.disabled = true;
	//}
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
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display:none;">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;문서유형</td>
										<td class="data_td" colspan="3">
											<select name="bsart" id="bsart" class="inputsubmit" style="width:120px" disabled>
												<option value="">-----</option>
												<%=LB_BSART%>
											</select>
											<input type="hidden" name="cust_code" id="cust_code" size="10" class="input_data2" value="0000100000">
											<input type="hidden" name="cust_name" id="cust_name" size="20" class="input_data2" value="기타(계획용)" readonly style="border:0">
										</td>
									</tr>
									<tr style="display:none;">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매요청구분</td>
										<td class="data_td" >
											<select name="sales_type" id="sales_type" class="inputsubmit"  style="width:90px" onchange="orderChange(this.value)">
												<option value="">-----</option>
												<%=LB_S_SALES_TYPE %>
											</select>
										</td>
										<td id="t_cls01" class="data_td"></td>
										<td id="t_cls02" class="data_td">
											<div id="_div01" style="display:none;">
												<a href="javascript:getOrder_pop();">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
												</a>
											</div>
											<div id="_div02" style="display:none;">
												<input type="hidden" name="wbs_txt" id="wbs_txt">
												<input type="text" name="wbs_no" id="wbs_no" size="15" maxlength="10" class="inputsubmit" value="" readonly>
												<a href="javascript:getWbs_pop();">
													<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
												</a>
												<input type="text" name="wbs_sub_no" id="wbs_sub_no" size="20" class="input_data2" maxlength="15" style="border:0">
											</div>
										</td>
									</tr>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="sales_dept" id="sales_dept" size="10"  class="input_data" value='<%=info.getSession("DEPARTMENT")%>' readonly>
											<a href="javascript:PopupManager('SALES_DEPT');">
												<img src="<%=G_IMG_ICON%>" border="0" >
											</a>
											<input type="text" name="sales_dept_name" id="sales_dept_name" size="20" class="input_data2" maxlength="15" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>' style="border:0" readonly>
										</td>
									</tr>
									<tr style="display: none">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수자</td>
										<td class="data_td" colspan="3">
											<input type="text" name="sales_user_id" id="sales_user_id" size="13"  class="input_re" value='<%=info.getSession("ID")%>' readonly>
											<a href="javascript:PopupManager('SALES_USER_ID');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="sales_user_name" id="sales_user_name" size="10" class="input_data2" maxlength="15" value='<%=info.getSession("NAME_LOC")%>' readonly style="border:0">
										</td>
									</tr>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등록구분</td>
										<td  class="data_td" colspan="3">
											<select name="pr_gubun" id="pr_gubun" class="input_re" style="width:20%" onChange='setDocType(this.value)'  >
												<option value="P" selected>구매요청</option>
											</select>
										</td>
									</tr>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트코드</td>
										<td class="data_td"  >
											<input type="text" name="wbs" id="wbs" style="width:93%" class="input_re" onKeyUp="return chkMaxByte(500, this, '프로젝트코드');">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트명</td>
										<td class="data_td"  >
											<input type="text" name="wbs_name" id="wbs_name" style="width:93%" class="input_re" onKeyUp="return chkMaxByte(500, this, '프로젝트명');">
										</td>
									</tr>
									<tr style="display: none">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청구분</td>
										<td class="data_td" >
											<select name="create_type" id="create_type" class="input_re" >
												<%=LB_CREATE_TYPE%>
											</select>
										</td>
									</tr>
									<tr style="display:none;">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;하자보증기간</td>
										<td class="data_td" >
											H/W
											<select name="hard_maintance_term" id="hard_maintance_term" class="inputsubmit" >
												<option value="" selected>
													<b>-----</b>
												</option>
												<%=LB_MAINTANCE_TERM%>
											</select>
											&nbsp;&nbsp;&nbsp;S/W
											<select name="soft_maintance_term" id="soft_maintance_term" class="inputsubmit" >
												<option value="" selected>
													<b>-----</b>
												</option>
												<%=LB_MAINTANCE_TERM%>
											</select>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회신희망일</td>
										<td class="data_td" >
											<input type="text" name="return_hope_day" id="return_hope_day" size="8" class="inputsubmit" value="<%=RETURN_HOPE_DAY%>" readonly>
											<a href="javascript:Calendar_Open('returnhopeDay');"></a>
										</td>
									</tr>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;선투입여부</td>
										<td  class="data_td" >
											<select name="ahead_flag" id="ahead_flag" class="inputsubmit"  >
												<option value="Y">Y</option>
												<option value="N" selected>N</option>
											</select>
										</td>
									</tr>
									<tr style="display:none">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;매출액</td>
										<td class="data_td" >
											<input type="text" name="sales_amt" id="sales_amt" size="20" class="inputsubmit" maxlength="15" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트 책임자</td>
										<td class="data_td" >
											<input type="text" name="project_pm" id="project_pm" size="13"  class="input_data" value='' readonly>
											<a href="javascript:PopupManager('project_pm');">
												<img src="<%=G_IMG_ICON%>" border="0" >
											</a>
											<input type="text" name="project_pm_name" id="project_pm_name" size="20" class="input_data2" maxlength="15" value='' readonly>
										</td>
									</tr>
									<tr style="display:none">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수주번호</td>
										<td class="data_td" >
											<input type="text" name="order_no" id="order_no" size="20" class="inputsubmit" maxlength="12" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수주차수</td>
										<td class="data_td" >
											<input type="text" name="order_count" id="order_count" size="8" class="inputsubmit" maxlength="2" readonly  value="" onKeyPress="return onlyNumber(event.keyCode);">
										</td>
									</tr>
									<tr style="display:none">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;프로젝트 수행기간</td>
										<td class="data_td" colspan="3">
											<input type="text" name="contract_from_date" id="contract_from_date" size="8" class="inputsubmit" value="" readonly>
											<a href="javascript:Calendar_Open('contractFromDate');"></a>
											~
											<input type="text" name="contract_to_date" id="contract_to_date" size="8" class="inputsubmit" maxlength="15" readonly  value="">
											<a href="javascript:Calendar_Open('contractToDate');"></a>
										</td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;납품장소</td>
										<td  class="data_td" colspan="">
											<input type="text" name="dely_location" id="dely_location" style="width:93%"   onKeyUp="return chkMaxByte(80, this, '납품장소');" class='input_re'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;납품주소</td>
										<td class="data_td"  >
											<input type="text" name="dely_to_address" id="dely_to_address" style="width:93%"   onKeyUp="return chkMaxByte(100, this, '납품주소');" class='input_re'>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table  style="display:none;" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class="cell_title1">&nbsp;◆ 관리정보</td>
			</tr>
		</table>
		<table  style="display:none;" width="100%" border="0" cellspacing="0" cellpadding="1">
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;신청자</td>
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
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="10%" class="title_td" style="display: none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매신청명</td>
										<td width="35%" class="data_td" style="display: none;">
											<input type="text" name="subject" id="subject" style="width:93%" class="input_re" onKeyUp="return chkMaxByte(500, this, '구매신청명');">
										</td>
										<td width="10%" class="title_td" align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재자</td>
										<td width="90%" class="data_td"  colspan="3">											
											<TABLE cellpadding="0" border="0">
												<TR>
													<TD>
														<input type="text" name="approval_id" id="approval_id" size="8" class="input_data2"  value='<%=approval_id%>' readOnly>
														<a href="javascript:PopupManager('APPROVAL_ID')">
															<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
														</a>
														<input type="text" name="approval_name" id="approval_name" size="8" class="input_data2"  value='<%=approval_name%>'>
													</TD>
													<TD align="left">
														<script language="javascript">
															btn("javascript:ckb_approval_onclick();", "결재자확인");
														</script>
													</TD>
													<TD align="left">
														<input type="checkbox" id="ckb_approval">&nbsp;&nbsp;<font color="red">* 결재권자는 전결권자만 지정하세요.</font>
													</TD>													
												</TR>
											</TABLE>											
										</td>														
									</tr>
									<tr style="display: none;">
										<td class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고객사</td>
										<td class="data_td" colspan="3" >
											<select name="pr_type" id="pr_type" class="input_re" onChange='GridView(form1.pr_type.options.selectedIndex)'  disabled style="display:none;">
												<%=LB_PR_TYPE%>
											</select>
											<input type="text" name="scms_cust_code" id="scms_cust_code" size="10"  class="inputsubmit" value='' readonly>
											<a href="javascript:searchCust();">
												<img src="<%=G_IMG_ICON%>" border="0" >
											</a>
											<input type="text"   name="scms_cust_name" id="scms_cust_name" size="30" class="input_data2" value='' style="border:0" readonly>
											<input type="hidden" name="scms_cust_type" id="scms_cust_type" size="30" class="input_data2" value='' style="border:0" readonly>
										</td>
									</tr>
									<tr style="display:none;" >
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr style="display:none;" >
										<td style="display:none;" class="title_td"  WIDTH="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예상금액(자동계산)</td>
										<td style="display:none;"  class="data_td" width="35%" align="left">
											<input type="text" name="expect_amt" id="expect_amt" size="20" class="input_data2"  readonly>
										</td>								    	
										<td style="display:none;" class="title_td" WIDTH="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td style="display:none;" class="data_td" width="35%">
											<s:calendar id="add_date" default_value="<%=SepoaString.getDateSlashFormat(CURRENT_DATE)%>" format="%Y/%m/%d"/>
										</td>										
									</tr>
									<tr  style="display:none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr  style="display:none;">
										<td  class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
										<td  class="data_td" colspan="3" height="200">
											<textarea name="REMARK" id="REMARK" class="inputsubmit" cols="85" rows="10" onKeyUp="return chkMaxByte(4000, this, '특기사항');" style="height: 180px; width: 98%"></textarea>
										</td>
									</tr>
									<tr  style="display:none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr  style="display:none;">
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
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:setRemarkRdData()", "신청사유 / 배송희망일  일괄적용");
</script>
							</TD>
							<TD>
								&nbsp;* <font color="blue">신청사유와 배송희망일을 첫번째 행 기준으로 일괄적용합니다.</font><br>
								&nbsp;* <font color="red">업무용동산 품목은 신청구분에 신규/교체 여부 선택, 신청사유를 입력 하셔야 합니다.</font><br>
								&nbsp;* <a href="javascript:topMenuClick('/kr/dt/pr/pr1_bd_lis1_2.jsp','MUO141000013', '1','')" class="summary_no"><font color="red">구매신청결과</font>는 <font color="blue">"구매관리 / 구매요청 / 구매신청현황"</font> 에서 확인 하세요. <font color="red">(클릭)</font></a>
		    				</TD>
						</TR>
					</TABLE>
				</td>
				<td height="30" align="right" id="butt_i">
					<TABLE cellpadding="0" border="0">
						<TR>							
							<TD>
<script language="javascript">
btn("javascript:PopupManager('CATALOG')", "구매품목선택");
</script>
							</TD>
							<%--
							<TD id="tdApprovalT">
<script language="javascript">
btn("javascript:Approval('T')", "임시저장");
</script>
							</TD>
							<TD id="tdApprovalE">
<script language="javascript">
btn("javascript:fnCreate()", "결재요청");
</script>
							</TD>	
							 --%>
						   <TD>
<script language="javascript">
btn("javascript:fnCreate()", "결재요청");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:PrdeleteWiseTable()", "행삭제");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
	</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_038" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>