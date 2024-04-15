<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("STA042");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	

	String screen_id = "STA042";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";
	//String WISEHUB_PROCESS_ID="PR_030";
	
	String house_code = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String PURCHASE_LOCATION = info.getSession("PURCHASE_LOCATION");
	String CTRL_CODE = info.getSession("CTRL_CODE");
	String SH_CONFIRM_YN = request.getParameter("sh_confirm_yn");	
	
	String ctrl_code = info.getSession("CTRL_CODE");

	String purchaser_id = "";
	String purchaser_nm = "";
	
	if(!"".equals(ctrl_code)){
		purchaser_id = "";
		purchaser_nm = "";
	}
	else{
		purchaser_id = info.getSession("ID");
		purchaser_nm = info.getSession("NAME_LOC");
	}
	
	String ANN_VERSION = "";
	
	Object[] obj = new Object[1]; 
	
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getBdAnnVersion", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	if(wf.getRowCount() > 0) {
		ANN_VERSION = wf.getValue("CODE", 0);
	}
	
%>
<script language='javascript' for='WiseGrid' event='ChangeCombo(strColumnKey, nRow, vtOldIndex, vtNewIndex)'>
	GD_ChangeCombo(GridObj,strColumnKey, nRow, vtOldIndex, vtNewIndex);
</script>
<script language='javascript' for='WiseGrid' event='CellClick(strColumnKey, nRow)'>
	GD_CellClick(GridObj,strColumnKey, nRow);
</script>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<style type="text/css">
<!--
.input_white {
	font-size: 12px;
	color: #333333;
	padding-left: 3;
	font-weight: normal;
	padding-right: 3px;
	background-color: ffffff;
	border-style: none
}
-->
</style>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- Ajax lib include한다. utf-8로 씌여졌으므로 charset은 반드시 utf-8로 기술할 것!! -->
<script language="javascript" src="/include/script/js/lib/jslb_ajax.js" charset="utf-8"></script>
<script language="javascript">

<%-- var house_code = "<%=HOUSE_CODE%>"; --%>
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_ins42";
<%-- var G_HOUSE_CODE   = "<%=HOUSE_CODE%>"; --%>
<%-- var G_COMPANY_CODE = "<%=COMPANY_CODE%>"; --%>



var company_code = "<%=COMPANY_CODE%>";
var param="";

var button_flag = false;
var cancel_flag = false;
//견적요청 popup 상태
var rfq_pop_id = false;
var mode;

///--- for 발주정보 ---//
var INDEX_PR_CODE;
var INDEX_PR_NAME; 
var INDEX_PR_PRESIDENT_NAME;
var INDEX_PR_ADDRESS;
var INDEX_PR_BIZ_NO;
var INDEX_PR_COP_NO;
var INDEX_PR_BIZ_GBN;
var INDEX_PR_PUB_DATE;
var INDEX_PR_MGR_NM;
var INDEX_PR_PO_CLS;
	
///--- for 발주정보 ---//
var INDEX_SELECTED;
var INDEX_SUBJECT; 
var INDEX_ITEM_NO;
var INDEX_ITEM_NAME;
var INDEX_CONTRACT_TO_DATE;
var INDEX_UNIT_MEASURE;
var INDEX_PO_NUMBER;
var INDEX_PO_AMT;
var INDEX_ADD_DATE;
var INDEX_ADD_TIME;
var INDEX_ADD_USER_ID;
var INDEX_CHANGE_DATE;
var INDEX_CHANGE_TIME;
var INDEX_CHANGE_USER_ID;  
var INDEX_TAX_NO;  
var INDEX_PO_NO;  




var Send_Data = "";

function init(){
	setGridDraw();
	setHeader();
	GridObj.setColumnHidden(GridObj.getColIndexById("SELECTED"), true);
// 	setContextMenu();
<%-- <% --%>
// 	if(SH_CONFIRM_YN != null && !SH_CONFIRM_YN.equals("")){
// 		if(SH_CONFIRM_YN.equals("Y")){
<%-- %> --%>
// 	document.forms.form1.sh_confirm_yn.value = 'Y';
<%-- <% --%>
// 		}
// 		else if(SH_CONFIRM_YN.equals("N")){
<%-- %> --%>
// 	document.forms.form1.sh_confirm_yn.value = 'N';
<%-- <% --%>
// 		}
// 	}
<%-- %> --%>
// 	doSelect();
}
function doOnRowSelected(rowId,cellInd){

}
// function doOnCellChange(stage,rowId,cellInd){
// 	//setCatalogSum();)
	
// }


function checkSelectedRows() {
	var gridObj = GridObj;
	var f = gridObj.GetSelectedCells();
	var rtnArr = new Array();

	if (f.length > 0) {
		var aArr = f.split(',');
		var index = 0;
		
		for (var i = 0; i < aArr.length; i += 2) {
			gridObj.SetCellValue("SELECTED", aArr[i + 1], "1");
		}
	}
}

function setContextMenu() {
	var gridObj = GridObj;
	
	gridObj.bUseDefaultContextMenu = false;
	gridObj.bUserContextMenu = true;
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
	
// 	if(isSelected == false){
// 		alert(G_MSS1_SELECT);
		
// 		return;
// 	}
	
// 	if(!checkData(wise, f)){
// 		return;
// 	}
	
	// 결재상태 변경
	//f.sign_status.value = sign_status;
	    
// 	if(sign_status == "P") {
// 		f.method = "POST";
// 		f.target = "childFrame";
// 		f.action = "/kr/admin/basic/approval/approval.jsp";
// 		f.submit();
// 	}
// 	else {
		getApproval(sign_status);
		
// 		return;
// 	}
}//Approval End

function getApproval(approval_str) {
	var f = document.forms[0];

// 	if(approval_str == "") {
// 		alert("결재자를 지정해 주세요");
		
// 		return;
// 	}

// 	var Message = "";
	
// 	if(f.sign_status.value == "P"){
// 		Message = "결재상신 하시겠습니까?";
// 	}
// 	else if(f.sign_status.value == "T"){
// 		Message = "임시저장 하시겠습니까?";
// 	}
// 	else if(f.sign_status.value == "E"){
// 		Message = "요청완료 하시겠습니까?";
// 	}
		
// 	if(!confirm(Message)) {
// 		return;
// 	}
		
// 	f.approval_str.value = approval_str;

	getApprovalSend(approval_str);
}

function getApprovalSend(approval_str) {
	var wise = GridObj;
	var f = document.forms[0];
	
	var rdoWorkKind = document.getElementsByName("rdo_work_kind");
	var i = 0;
	var isCheck = false;
	
	if($.trim($("#vendor_code").val()) == ''){
		alert("공급업체를 선택해 주세요.");
		return;
	}
	
	for(i = 0; i < rdoWorkKind.length; i++){
		if(rdoWorkKind[i].checked){
			isCheck = true;
			
			//form1.itype.vue = "01";
			if(i==0){			
				document.getElementById("itype").value = "01";
			}
			else if(i==1){
				document.getElementById("itype").value = "03";
			}
			else if(i=2) {
				document.getElementById("itype").value = "05";
			}
			//alert(rdoWorkKind[i].value);
			
			break;
		}
	}
	
	if(isCheck == false){
		alert("업태구분을 선택해 주세요.");
		return;
	}

	if(GridObj.GetRowCount() == 0) return;

	if(!confirm("실적증명서를 저장하시겠습니까?"))return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params = "?mode=setPrCreate";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();

	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function setHeader() {
	INDEX_SELECTED             = GridObj.GetColHDIndex("SELECTED"			);
	INDEX_SUBJECT              = GridObj.GetColHDIndex("SUBJECT"			);
	INDEX_ITEM_NO              = GridObj.GetColHDIndex("ITEM_NO"			);
	INDEX_ITEM_NAME            = GridObj.GetColHDIndex("ITEM_NAME"			);
	INDEX_CONTRACT_TO_DATE     = GridObj.GetColHDIndex("CONTRACT_TO_DATE"			);
	INDEX_UNIT_MEASURE         = GridObj.GetColHDIndex("UNIT_MEASURE"			);
	INDEX_PO_NUMBER            = GridObj.GetColHDIndex("PO_NUMBER"			);
	INDEX_PO_AMT               = GridObj.GetColHDIndex("PO_AMT"			);
    INDEX_YN                   = GridObj.GetColHDIndex("YN");
    INDEX_ADD_DATE             = GridObj.GetColHDIndex("ADD_DATE");
    INDEX_ADD_TIME             = GridObj.GetColHDIndex("ADD_TIME");
    INDEX_ADD_USER_ID          = GridObj.GetColHDIndex("ADD_USER_ID");
    INDEX_CHANGE_DATE          = GridObj.GetColHDIndex("CHANGE_DATE");
    INDEX_CHANGE_TIME          = GridObj.GetColHDIndex("CHANGE_TIME");
    INDEX_CHANGE_USER_ID       = GridObj.GetColHDIndex("CHANGE_USER_ID");  	
    INDEX_TAX_NO       		   = GridObj.GetColHDIndex("TAX_NO");  	
    INDEX_PO_NO       		   = GridObj.GetColHDIndex("PO_NO");  	

}//setHeader End

//조회
function doSelect() {
// 	alert("doselect call");

// 	var ctrlCode = document.getElementById("CTRL_CODE");
	
// 	ctrlCode.value = ctrlCode.value.toUpperCase();
	
<%-- 	var cols_ids = "<%=grid_col_id%>"; --%>
// 	var params = "mode=prItemsList";
	
// 	params += "&cols_ids=" + cols_ids;
// 	params += dataOutput();
	
<%-- 	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2", params ); --%>
// 	GridObj.clearAll(false);

}

function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;
	var rowcount = GridObj.GetRowCount();

	for (var row = 0; row < rowcount; row++) {
		if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			for(i=0; i < ctrl_code.length; i++ ) {
				if (ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
					flag = true;
					
					break;
				}
				else {
					flag = false;
				}
			}
		}
	}
	
	return flag;
}



	
function setVendorName(tmpVendorName) {
	GD_SetCellValueIndex(GridObj,tmpVendorRow,INDEX_VENDOR_NAME,tmpVendorName);
}

var row = 0;
var TEMP_TAX_CODE_ID;
var tmpRdDate;
var tmpVendorRow;

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	row = msg2;
        
	if(msg1 == "doQuery") {
			
	}
	else if(msg1 == "doData") {
		doSelect();
		/*
		var mode = GD_GetParam(GridObj,2);
		var status = GD_GetParam(GridObj,0);

		if(mode == "charge_transfer") {
			alert(GridObj.GetMessage());
			
			button_flag = false; // 버튼 action ...  action을 취할수있도록...
			
			if(status == "1") {
				doSelect();
				document.form1.Transfer_id.value = "";
				document.form1.Transfer_name.value = "";
				document.form1.Transfer_person_id.value = "";
				document.form1.Transfer_person_name.value = "";
			}
		}
		else if(mode == "reject") {
			button_flag = false; // 버튼 action ...  action을 취할수있도록...
			
			alert(GridObj.GetMessage());
			
			if(status == "1") {
				doSelect();
			}
		}
		else if(mode == "po_domestic") {
			alert(GridObj.GetMessage());
			
			button_flag = false; // 버튼 action ...  action을 취할수있도록...
			
			if("1" == status) {
				doSelect();
			}
		}
		else if(mode == "po_export") {
			if("0" == status) {
				button_flag = false; // 버튼 action ...  action을 취할수있도록...
				
				alert(GridObj.GetMessage());
			}
			else {
				button_flag = false; // 버튼 action ...  action을 취할수있도록...
				window.open("/kr/order/bpo/po2_bd_ins1.jsp?bType=PR"+"&prStr="+Send_Data,"_self","");
			}
		}
		else if(mode == "setSendPo"){
			if(status == "1") {
				alert("정상적으로 처리되었습니다.\n\n기안대기현황에서 기안서를 작성하세요.");
				
				doSelect();
			}
		}
		else if(mode == "setDirectPo"){
			if(status == "1") {
				alert("정상적으로 처리되었습니다.\n\직발주대상조회에서 발주생성하세요.");
				
				doSelect();
			}
		}
		else if(mode == "doConfirm"){
			alert(GridObj.GetMessage());
			
			doSelect();
		}
		*/
	}
// 	else if(msg1 == "t_imagetext") {//구매요청번호
// 		var img_pr_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_PR_NO);
	
// 		if (msg3 == INDEX_PR_NO) {
// 			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=1024,height=650,resizable=yes,scrollbars=yes");
// 		}
		
// 		if (msg3 == INDEX_UNIT_PRICE_CONTRACT_VENDOR_CNT) {
// 			tmpVendorRow = msg2;
			
// 			var info_cnt 			= GD_GetCellValueIndex(GridObj,msg2,INDEX_UNIT_PRICE_CONTRACT_VENDOR_CNT);
// 			var purchase_location 	= GD_GetCellValueIndex(GridObj,msg2,INDEX_PURCHASE_LOCATION);
// 			var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);

// 			if(info_cnt > 0 ) {
// 				window.open("/kr/dt/pr/pr5_pp_lis1.jsp?pr_location=" + purchase_location + "&item_no="+item_no,"pr5_pp_lis1","left=0,top=0,width=500,height=300,resizable=yes,scrollbars=yes");
// 			}
// 		}
// 	}
	else if(msg1 == "t_insert") {
		if(msg3 == INDEX_SELECTED){}
	}
}//JavaCall End

function selectCond(wise, selectedRow){
	var wise = GridObj;
	var cur_pr_no  	 = GD_GetCellValueIndex(wise,selectedRow, INDEX_PR_NO);
	var iRowCount   	 = wise.GetRowCount();
	
	for(var i=0;i<iRowCount;i++){
		if(i==selectedRow){
			continue;
		}
				
		if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO)){
			var flag = "true";
			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
		else{
			var flag = "false";
			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
	}
}

function POPUP_Open(url, title, left, top, width, height) {
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = 'yes';
	var resizable = 'no';
	var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	
	code_search.focus();
}//POPUP_Open End

function reason() {
	window.open("../../approval/app_pp_dis1.htm","windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=548,height=170,left=0,top=0")
}

function START_SIGN_DATE(year,month,day,week) {
	document.form1.START_SIGN_DATE.value=year+month+day;
}

function END_SIGN_DATE(year,month,day,week) {
	document.form1.END_SIGN_DATE.value=year+month+day;
}


function doSelectCompInfo()
{
//     var f = document.forms[0];
    var wise = GridObj;
    
//     var from_date       = LRTrim(f.start_add_date.value);
//     var to_date         = LRTrim(f.end_add_date.value); 
//     var pr_type         = LRTrim(f.pr_type.value); 
//     var demand_dept     = LRTrim(f.demand_dept.value); 
//     var add_user_id     = LRTrim(f.add_user_id.value);  
//     var pr_status       = LRTrim(f.pr_status.value);
//     var sign_status     = LRTrim(f.sign_status.value); 
//     var order_no        = LRTrim(f.order_no.value);
 
    
   
//     if(from_date == "")
//     {
//         alert("생성일자를 입력하셔야 합니다.");
//         return;
//     }
//     if(!checkDate(from_date)) {
//         alert("생성일자를 확인하세요.");
//         f.start_add_date.select();
//         return;
//     }
//     if(!checkDate(from_date)) {
//         alert("생성일자를 확인하세요.");
//         f.end_add_date.select();
//         return;
//     }

	
<%-- 	var cols_ids = "<%=grid_col_id%>"; --%>
    var cols_ids = "";
    mode = "getStaCompInfo";//dt.rfq.ebd_bd_lis3

    var params = "mode=" + mode;
//     params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );

    GridObj.clearAll(false);

}
function getVendorCode(){
<%-- 	//var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0087&function=setVendorCode&values=<%=house_code%>&values=&values=/&desc=업체코드&desc=업체명"; --%>
// 	//CodeSearchCommon(url,'itemNoWin','50','100','570','530');
	var arrValue = new Array();
	var arrDesc  = new Array();

	arrValue[0] = "<%=house_code%>";
	arrValue[1] = "";
	arrValue[2] = "";
	arrValue[3] = "/";
	
	arrDesc[0] = "업체코드";
	arrDesc[1] = "업체명";

	PopupCommonNoCond("SP0087", "setVendorCode", arrValue, arrDesc);

}
function setVendorCode( code, desc1, desc2)
{

	form1.vendor_code.value = code;
	form1.vendor_name.value = desc1;

	doSelectCompInfo();

}


function popupvendor( fun ) {
    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}



// 접수
function doConfirm(){
	// 구매담당자지정 - 접수 - 소싱
	// 구매담당자 체크
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_bd_lis2";

	var chk_cnt = 0;
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == true){
			chk_cnt++;
		}
	}
	
	if(chk_cnt == 0) {
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
	
	if(!hasRequreCondition("CONFIRM_USER_ID", "이미 접수되었습니다.", "FULL")){
		return;
	}
	
	if(hasRequreCondition("PURCHASER_ID", "담당자를 먼저 지정해주십시요.")){
		if (confirm('접수하시겠습니까?')) {
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
			var params     = getParam();
			
			myDataProcessor = new dataProcessor(servletUrl + "?" + params);
			
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		}
	}
}


function doModify(){
	checkCnt = 0;
	pr_data  = "";
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			cur = GridObj.GetCellValue("CUR", i);
			
			if(cur != "KRW"){}
			
			pr_data = GridObj.GetCellValue("PR_NO", i);
		}
	}
	
	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		return;
	}
	
	if(checkCnt > 1){
		alert("수정은 한건씩만 가능합니다");
		return;
	}
	
	document.form2.PR_NO.value = pr_data;
	
	var url  = "/kr/dt/pr/pr1_bd_ins2.jsp";
	window.open("","doModifyPR","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=760,left=0,top=0");
	document.form2.method = "POST";
	document.form2.action = url;
	document.form2.target = "doModifyPR";
	document.form2.submit();
}



var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	setCatalogSum();
        return true;
    }
    else if(stage==1) {
    	setCatalogSum();
    	return false;
    }
    else if(stage==2) {
    	setCatalogSum();
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
    	topMenuClick("/kr/statistics/sta_bd_lis41.jsp", "MUO141000007", "6", '');
    }
    else {
        alert("doSaveEnd()..."+messsage);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
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
function setStaCompInfo(HOUSE_CODE, VENDOR_CODE, STATUS, VENDOR_NAME_ENG, CEO_NAME, ADDRESS
		              , TEL_NO, IRS_NO, COMPANY_REG_NO, INDUSTRY_TYPE, BUSINESS_TYPE, USER_NAME, POSITION){
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();

	form1.vendor_code.value = VENDOR_CODE;
	form1.vendor_name.value = VENDOR_NAME_ENG;
	form1.ceo_name.value = CEO_NAME;
	form1.address.value = ADDRESS;
	form1.tel_no.value = TEL_NO;
	form1.irs_no.value = IRS_NO;
	form1.company_reg_no.value = COMPANY_REG_NO;
// 	form1.purcheser_name.value = USER_NAME;
// 	form1.position.value = POSITION;

	return true;
}

function setCatalogSum() {

		var wise          = GridObj;
		var iRowCount     = GridObj.GetRowCount();
	    var iCount = 0;	
	    var iPoAmtSum = 0;
		var iCheckedCount = getCheckedCount(wise, "SELECTED");
		//var arr           = new Array(G_INDEXES.length);		
// 		if(iCheckedCount == 0){
// 			alert(G_MSS1_SELECT);
			
// 			return;
// 	    }
	    for(var i=0; i<iRowCount; i++){
	        if( GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED) == true){
	        	iCount++;	       				
	       		iPoAmtSum = parseInt(iPoAmtSum) + parseInt(GD_GetCellValueIndex(GridObj, i, INDEX_PO_AMT));       				
	        }
	    }
	    
	    form1.PoAmtSum.value = add_comma(iPoAmtSum, 0);


}
function setCatalog(subject, po_no, po_seq, item_no, description_loc, contract_to_date, unit_measure, item_qty, po_amt, yn,add_date,add_time,add_user_id,change_date,change_time,change_user_id,tax_no){
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	//var pjt_code   = document.getElementById("pjt_code").value;
	//alert("... setCatalog .................iMaxRow = "+iMaxRow + ", unit_measure="+unit_measure);
	GridObj.addRow(newId,"");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED        ,     	    "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SUBJECT         ,        subject);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO         ,          item_no);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NAME       ,         description_loc);
 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CONTRACT_TO_DATE,        contract_to_date);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE    ,  unit_measure);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PO_NUMBER       , item_qty);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PO_AMT          ,   po_amt);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_YN              ,   yn);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ADD_DATE        ,   add_date);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ADD_TIME        ,   add_time);	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ADD_USER_ID     ,   add_user_id);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CHANGE_DATE     ,   change_date);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CHANGE_TIME     ,   change_time);	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CHANGE_USER_ID  ,   change_user_id);		
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_TAX_NO  		 ,   tax_no);		
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PO_NO  		 ,   po_no);		

	//form1.pr_add_user_name.value = description_loc;
	
   setCatalogSum();
	


// 	if(pjt_code != ''){
// 		if(pjt_code.substr(0,2) == 'SI' && ktgrm == '01'){
// 			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, "상품(" + pjt_code.substr(0,5) + ")");
// 		}
// 		else{
// 			GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ACCOUNT_TYPE, pjt_code.substr(0,9));
// 		}
// 	}
     
// 	if(ADD_UNIT_MEASURE_OPTION_CNT == 0){
// 		//GridObj.AddComboListValue("UNIT_MEASURE", "", "");
		
// 		ADD_UNIT_MEASURE_OPTION_CNT++;
// 	}
	
// 	if((GD_GetCellValueIndex(GridObj,iMaxRow, INDEX_CUR ) == "KRW") == false){
// 		//GridObj.SetCellActivation('EXCHANGE_RATE', iMaxRow, 'edit');
// 	}
	//calculate_pr_amt(GridObj, iMaxRow);
	//calculate_pr_tot_amt();

	return true;
}
/////////////////////
/// 공급업체 정보 ///
/////////////////////
function pStaCompList() {

	url = "/kr/statistics/sta_bd_lis44.jsp";
	windowopen1 = window.open(url,"mycatalog_win","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=500,left=0,top=0");
}
//나의카탈로그
function pStaOrdList() {
	var f = document.forms[0];
    //alert("pStaOrdList().............................")
// 	if(f.sales_type.value == ""){
// 		alert("구매요청구분을 선택 후 나의카탈로그를 선택 하십시요");
		
// 		return;
// 	}
	
	if($.trim($("#vendor_code").val()) == ''){
		alert("업체코드를 선택해 주세요.");
		return;
    }
	
	var po_no = "";
	
	if(GridObj.GetRowCount() > 0){
		for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
			po_no += ",'" + GridObj.cells(GridObj.getRowId(i),  GridObj.getColIndexById("PO_NO")).getValue() + "'";
		}
	}
	
	//setCatalogIndex(G_C_INDEX_MY);

// 	url = "/kr/catalog/pr/pr1_pp_lis4.jsp?INDEX=" + getAllCatalogIndex() ;
	url = "/kr/statistics/sta_bd_lis43.jsp";
	windowopen1 = window.open("","mycatalog_win","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=950,height=500,left=0,top=0");
	
	document.popForm.action = url;
	document.popForm.method = "post";
	document.popForm.vendor_code.value = $.trim($("#vendor_code").val());
	document.popForm.po_no.value = po_no;
	document.popForm.target="mycatalog_win";
	document.popForm.submit();	
	
}

function rdoCheck(){
	var rdoWorkKind = document.getElementsByName("rdo_work_kind");
	var i = 0;
	var isCheck = false;
	
	for(i = 0; i < rdoWorkKind.length; i++){
		if(rdoWorkKind[i].checked){
			isCheck = true;
			
			document.itype.vlaue = "0"+i;
			alert(rdoWorkKind[i].value);
			
			break;
		}
	}
	
	if(isCheck == false){
		alert("선택안됨");
	}
}

function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.form1.vendor_code.value = "";
    	document.form1.vendor_name.value = "";
    	document.form1.ceo_name.value = "";
    	document.form1.address.value = "";
    	document.form1.tel_no.value = "";
    	document.form1.irs_no.value = "";
    	document.form1.company_reg_no.value = "";
    }  
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header>
<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

	<form id="form1" name="form1">
		<!-- hidden -->
		<input type="hidden" name="ANN_VERSION" id="ANN_VERSION" value="<%=ANN_VERSION%>">
		<input type="hidden" name="buyer_item_no" id="buyer_item_no" value="">
		<input type="hidden" name="CTRL_CODE" id="CTRL_CODE" value="<%=CTRL_CODE%>">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="sign_status" id="sign_status" value="">
		<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="purcheser_id" id="purcheser_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="add_user_id" id="add_user_id" value="<%=info.getSession("ID")%>">	
		<input type="hidden" name="change_user_id" id="change_user_id" value="<%=info.getSession("ID")%>">		
		<input type="hidden" name="itype" id="itype" value="">
		<input type="hidden" name="dept" id="dept" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="dept_name" id="dept_name" value="<%=info.getSession("DEPARTMENT_NAME_LOC")%>">
		<input type="hidden" name="position" id="position" value="<%=info.getSession("POSITION")%>">
		
		
		
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체<font color="red"><b>*</b></font> </td>
				<td width="35%" class="data_td">
					<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="10" maxlength="10" class="inputsubmit" style="width: 90px;" readonly="readonly">
<!-- 					<a href="javascript:getVendorCode('setVendorCode')"> -->
					<a href="javascript:pStaCompList()">
						<img src="<%=G_IMG_ICON%>" align="absmiddle" name="p_vendor_code" border="0" alt="">
					</a>
					<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
					<input type="text" name="vendor_name" id="vendor_name" size="20" readonly="readonly" >
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대표자<font color="red"><b>*</b></font> </td></td>
				<td width="35%" class="data_td">
					<input type="text" name="ceo_name" id="ceo_name" size="20" readonly value=''>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;주소<font color="red"><b>*</b></font> </td></td>
				<td width="35%" class="data_td" colspan="1">
					<input type="text" name="address" id="address" style="width:95%" maxlength="20" class="inputsubmit" value="">
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전화번호<font color="red"><b>*</b></font> </td></td>
				<td width="35%" class="data_td">
					<input type="text" name="tel_no" id="tel_no" style="width:95%" maxlength="20" class="inputsubmit">
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>		
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업자번호<font color="red"><b>*</b></font> </td></td>
				<td class="data_td" colspan="1">
					<input type="text" name="irs_no" id="irs_no" style="width:95%" maxlength="20" class="inputsubmit">
				</td>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;법인번호<font color="red"><b>*</b></font> </td></td>
				<td class="data_td" colspan="1">
					<input type="text" name="company_reg_no" id="company_reg_no" style="width:95%" maxlength="20" class="inputsubmit">
				</td>		
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>		
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;용  도</td>
				<td class="data_td" colspan="1">
					<input type="text" name="purpose" id="purpose" style="width:95%" maxlength="20" class="inputsubmit">
				</td>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제출처</td>
				<td class="data_td" colspan="1">
					<input type="text" name="present" id="present" style="width:95%" maxlength="20" class="inputsubmit">
				</td>	
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>		
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업태구분<font color="red"><b>*</b></font> </td></td>
				<td width="25%" class="data_td">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" >
						<tr>
		 				<td width="24%" >
				 			<input type="radio" name="rdo_work_kind" id="rdo_work_kind1"  class="input_data2" value="01">제조
				      	</td>
				      	<td width="24%" >
				 			<input type="radio" name="rdo_work_kind" id="rdo_work_kind2"  class="input_data2" value="03">공급
				      	</td>
				      	<td width="24%">
				 			<input type="radio" name="rdo_work_kind" id="rdo_work_kind3"  class="input_data2" value="05">기타
				      	</td>
		 			    </tr>
		 		   </table>
     			</td>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발행일자<font color="red"><b>*</b></font> </td></td>
	            <td class="data_td">
	            	<s:calendar id="issued_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),0) )%>" format="%Y/%m/%d"/>
				</td>		
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>						
			<tr>		
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자</td></td>
				<td class="data_td" colspan="1">
					<input type="text" name="purcheser_name" id="purcheser_name" style="width:95%" maxlength="20" class="inputsubmit" value="<%=info.getSession("NAME_LOC")%>">
				</td>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;직  급</td></td>
				<td class="data_td" colspan="1">
					<input type="text" name="position_name" id="position_name" style="width:95%" maxlength="20" class="inputsubmit" value="<%=info.getSession("POSITION_NAME_LOC")%>">
				</td>		
			</tr>			
		</table>
  	</td>
</tr>
</table>
</td>
</tr>
</table>
</br>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="10%" class="title_td" style="font-weight:bold;font-size:12px;color:#555555;">합계금액</td>
				<td class="data_td">
					<input type="text" name="PoAmtSum" id="PoAmtSum" size="10" maxlength="5" class="inputsubmit" style="text-align: right;">
				</td>
				<td width="10%" class="title_td" style="font-weight:bold;font-size:12px;color:#555555;">발행부수</td>
				<td class="data_td">
					<input type="text" name="print_cnt" id="print_cnt" size="10" maxlength="5" class="inputsubmit" style="text-align: right;">
				</td>	
                <td height="30" align="right" class="data_td">
            	<TABLE cellpadding="0">
                	<TR>
                        <TD><script language="javascript">btn("javascript:pStaOrdList()","세금계산서정보")    			</script></TD>
<%--                         <TD><script language="javascript">btn("javascript:Approval('T')","결  재")   			</script></TD>  			</script></TD>   --%>
                        <TD><script language="javascript">btn("javascript:Approval()","저 장")   			</script></TD>  			</script></TD>  
                    </TR>
                </TABLE>
                </td>
			</tr>
			</table>
   		</td>
   	</tr>
 	</table>
 	</td>
   	</tr>
 	</table>
		
		
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<input type="hidden" name="mtou_flag" id="mtou_flag" value="N" readOnly>
		</table>
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			</tr>
		</table>
		<iframe name="xWork" width="0" height="0" border="0"></iframe>
		<iframe name="childFrame" src="" width="0%" height="0" border=0 frameborder=0> </iframe>
		<iframe name="getDescframe" src="" width="0%" height="0" border=0 frameborder=0></iframe>
	</form>
	<form id="popForm" name="popForm">
	<input type="hidden" id="po_no" name="po_no">
	<input type="hidden" id="vendor_code" name="vendor_code">
	</form>
</s:header>
<s:grid screen_id="STA042" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>