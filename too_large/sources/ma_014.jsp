<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "MA_014";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	String  type           = request.getParameter("type");
	String  pItemNo        = request.getParameter("pItemNo");
	String  seq            = request.getParameter("seq");
	String  gate            = request.getParameter("gate");
	String  vendor_code = request.getParameter("vendor_code");
	
	boolean isSelectScreen = false;

	if(pItemNo == null){
		pItemNo = "";
	}
	
	if(seq == null){
		seq = "";
	}
	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_014_1"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var selectType = "";
var G_C_INDEX  = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";

function fnBodyOnLoad(){
	setGridDraw();	
}

function fnPIntemNoPop(){
	selectType = "parent";
	
	callCatalog();
}

function fnCIntemNoPop(){
	selectType = "child";
	
	callCatalog();
}

function callCatalog(){
	setCatalogIndex(G_C_INDEX);
	
	var url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y&INDEX=" + getAllCatalogIndex() ;
	
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	if(selectType == "parent"){
		var pItemNoObject         = document.getElementById("pItemNo");
		var pDescriptionLocObject = document.getElementById("pDescriptionLoc");
		
		pItemNoObject.value         = itemNo;
		pDescriptionLocObject.value = descriptionLoc;
	}
	else if(selectType == "child"){
		var cItemNoObject         = document.getElementById("cItemNo");
		var cDescriptionLocObject = document.getElementById("cDescriptionLoc");
		
		cItemNoObject.value         = itemNo;
		cDescriptionLocObject.value = descriptionLoc;
	}
}

function doSelect(){
	var params = "mode=ma012SelectGlList";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012", params);
	GridObj.clearAll(false);
}

function fnPItemNoOnChange(){
	document.getElementById("pDescriptionLoc").value = "";
}

function fnCItemNoOnChange(){
	document.getElementById("cDescriptionLoc").value = "";
}

function fnChoice(){
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var rowCount               = GridObj_1.GetRowCount();
	var i                      = 0;
	var pItemNoColIndex        = GridObj_1.getColIndexById("P_ITEM_NO");
	var pSeqColIndex            = GridObj_1.getColIndexById("SEQ");
	var cItemNoColIndex        = GridObj_1.getColIndexById("C_ITEM_NO");
	var descriptionLocColIndex = GridObj_1.getColIndexById("DESCRIPTION_LOC");
	var specificationColIndex  = GridObj_1.getColIndexById("SPECIFICATION");
	var makerCodeColIndex      = GridObj_1.getColIndexById("MAKER_CODE");
	var crtlCodeColIndex       = GridObj_1.getColIndexById("CTRL_CODE");
	var qtyColIndex            = GridObj_1.getColIndexById("QTY");
	var itemGroupColIndex      = GridObj_1.getColIndexById("ITEM_GROUP");
	var delyToAddressColIndex  = GridObj_1.getColIndexById("DELY_TO_ADDRESS");
	var unitPriceColIndex      = GridObj_1.getColIndexById("UNIT_PRICE");
	var ktgrmColIndex          = GridObj_1.getColIndexById("KTGRM");
	var makerNameColIndex      = GridObj_1.getColIndexById("MAKER_NAME");
	var basicUnitColIndex      = GridObj_1.getColIndexById("BASIC_UNIT");
	var materialTypeColIndex   = GridObj_1.getColIndexById("MATERIAL_TYPE");
	var selectedColIndex       = GridObj_1.getColIndexById("SELECTED");
	var c_unit_price_index       = GridObj_1.getColIndexById("C_UNIT_PRICE");
	var make_amt_code_index       = GridObj_1.getColIndexById("MAKE_AMT_CODE");
	var p_description_loc_index       = GridObj_1.getColIndexById("P_DESCRIPTION_LOC");
	var p_bom_name_index       = GridObj_1.getColIndexById("P_BOM_NAME");
	var make_amt_name_index       = GridObj_1.getColIndexById("MAKE_AMT_NAME");
	var make_amt_unit_index       = GridObj_1.getColIndexById("MAKE_AMT_UNIT");
	var image_file_path_index     = GridObj_1.getColIndexById("IMAGE_FILE_PATH");//이미지
	
	var wid_index       = GridObj_1.getColIndexById("WID");
	var hgt_index       = GridObj_1.getColIndexById("HGT");
	
	
	var pItemNoColValue        = null;
	var pSeqColValue            = null;
	var cItemNoColValue        = null;
	var descriptionLocColValue = null;
	var specificationColValue  = null;
	var makerCodeColValue      = null;
	var ctrlCodeColValue       = null;
	var qtyColValue            = null;
	var itemGroupColValue      = null;
	var delyToAddressColValue  = null;
	var unitPriceColValue      = null;
	var ktgrmColValue          = null;
	var makerNameColValue      = null;
	var basicUnitColValue      = null;
	var materialTypeColValue   = null;
	var selectedColValue       = null;
	var c_unit_price_value       = null;
	var make_amt_code_value      = null;
	var p_description_loc_value       = null;
	var p_bom_name_value       = null;
	var make_amt_name_value       = null;
	var make_amt_unit_value       = null;
	var image_file_path           = null;
	
	var wid = null;
	var hgt = null;
	
	var gate = "<%=gate %>";
	
	parent.opener._openFlag = true;
	
	for(i = 0; i < rowCount; i++){
		selectedColValue       = GD_GetCellValueIndex(GridObj_1, i, selectedColIndex);
		
		if(selectedColValue == true){
			pItemNoColValue        = GD_GetCellValueIndex(GridObj_1, i, pItemNoColIndex);
			pSeqColValue            = GD_GetCellValueIndex(GridObj_1, i, pSeqColIndex);
			cItemNoColValue        = GD_GetCellValueIndex(GridObj_1, i, cItemNoColIndex);
			descriptionLocColValue = GD_GetCellValueIndex(GridObj_1, i, descriptionLocColIndex);
			specificationColValue  = GD_GetCellValueIndex(GridObj_1, i, specificationColIndex);
			makerCodeColValue      = GD_GetCellValueIndex(GridObj_1, i, makerCodeColIndex);
			ctrlCodeColValue       = GD_GetCellValueIndex(GridObj_1, i, crtlCodeColIndex);
			qtyColValue            = GD_GetCellValueIndex(GridObj_1, i, qtyColIndex);
			itemGroupColValue      = GD_GetCellValueIndex(GridObj_1, i, itemGroupColIndex);
			delyToAddressColValue  = GD_GetCellValueIndex(GridObj_1, i, delyToAddressColIndex);
			unitPriceColValue      = GD_GetCellValueIndex(GridObj_1, i, unitPriceColIndex);
			ktgrmColValue          = GD_GetCellValueIndex(GridObj_1, i, ktgrmColIndex);
			makerNameColValue      = GD_GetCellValueIndex(GridObj_1, i, makerNameColIndex);
			basicUnitColValue      = GD_GetCellValueIndex(GridObj_1, i, basicUnitColIndex);
			materialTypeColValue   = GD_GetCellValueIndex(GridObj_1, i, materialTypeColIndex);
			c_unit_price_value   = GD_GetCellValueIndex(GridObj_1, i, c_unit_price_index);
			make_amt_code_value   = GD_GetCellValueIndex(GridObj_1, i, make_amt_code_index);
			p_description_loc_value   = GD_GetCellValueIndex(GridObj_1, i, p_description_loc_index);
			p_bom_name_value   = GD_GetCellValueIndex(GridObj_1, i, p_bom_name_index);
			make_amt_name_value   = GD_GetCellValueIndex(GridObj_1, i, make_amt_name_index);
			make_amt_unit_value   = GD_GetCellValueIndex(GridObj_1, i, make_amt_unit_index);
			image_file_path   = GD_GetCellValueIndex(GridObj_1, i, image_file_path_index);
			
			wid   = GD_GetCellValueIndex(GridObj_1, i, wid_index);
			hgt   = GD_GetCellValueIndex(GridObj_1, i, hgt_index);
			
			
			if(gate == "gate_a") {
				if(c_unit_price_value == "" || c_unit_price_value == "0") {
					alert("추가할 수 없는 품목입니다.");
					return;
				}
			}
			
			//alert('image_file_path : ' + image_file_path);
			
			opener.setCatalog(
				cItemNoColValue,   descriptionLocColValue, specificationColValue, makerCodeColValue, ctrlCodeColValue,
				qtyColValue,       itemGroupColValue,      delyToAddressColValue, unitPriceColValue, ktgrmColValue,
				makerNameColValue, basicUnitColValue,      materialTypeColValue, pItemNoColValue, c_unit_price_value
				, make_amt_code_value, p_description_loc_value, p_bom_name_value, make_amt_name_value, make_amt_unit_value
				,image_file_path,pSeqColValue,wid,hgt
			);
			
			parent.opener._openFlag = false;
		}
	}
	
	window.close();
}

function fnFormInputSet(inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	//frm.appendChild(input);
	
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

var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
	
	GridObj_1_setGridDraw();
	GridObj_1.setSizes();
}

function doOnRowSelectedParam(rowId){
	
	var inputParam      = "";
	var body            = document.getElementsByTagName("body")[0];
	var params;
	var rowIndex        = GridObj.getRowIndex(rowId);
	var pItemNoColIndex = GridObj.getColIndexById("P_ITEM_NO");
	var seqColIndex     = GridObj.getColIndexById("SEQ");
	var pItemNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, pItemNoColIndex);
	var seqColValue     = GD_GetCellValueIndex(GridObj, rowIndex, seqColIndex);
	
	inputParam = "P_ITEM_NO=" + pItemNoColValue;
	inputParam = inputParam + "&SEQ=" + seqColValue;
	inputParam = inputParam + "&VENDOR_CODE=<%=vendor_code%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	var params = "mode=ma012SelectLnList";
	params += "&cols_ids=" + GridObj_1_getColIds();
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var params = doOnRowSelectedParam(rowId);
	GridObj_1.clearAll(false);
	GridObj_1.post("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012", params);	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
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

    alert(messsage);
    
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
    var msg    = GridObj.getUserData("", "message");
    var status = GridObj.getUserData("", "status");

    if(status == "0"){
    	//alert(msg);
    }
    
    return true;
}

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	}
	else if(stage==1) {
		return false;
	}
	else if(stage==2) {
		return true;
	}
}

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj_1_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	alert(messsage);
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doData");
	} 

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj.clearAll();
		GridObj.setCSVDelimiter("\t");
		GridObj.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

//모품목 검색
function fnPIntemNoPop(){ 
	var valueArraay = new Array();
	var descArray   = new Array();
	
	valueArraay[valueArraay.length] = "000";
	valueArraay[valueArraay.length] = "";
	valueArraay[valueArraay.length] = "";
	descArray[descArray.length]     = "모품번";
	descArray[descArray.length]     = "모품명";
	
	PopupCommonPost("MA0120", "fnPIntemNoPopCallback", valueArraay, descArray);
}
//모품목 리턴
function fnPIntemNoPopCallback(code, text){ 
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012",
		{
			mode     : "ma012selectGl",
			cols_ids : "SEQ,BOM_NAME,DESCRIPTION_LOC,SPECIFICATION,BASIC_UNIT,ITEM_NO",
			pItemNo  : code,
			seq      : text
		},
		function(arg){
			var argArray       = arg.split(",");
			var argArrayLength = argArray.length;
			
			if(argArrayLength == 1){
				alert(arg);
				
				return;
			}
			else{
				document.getElementById("pItemNo").value        = code;
// 				document.getElementById("seq").value            = text;
// 				document.getElementById("bomName").value        = argArray[1];
				document.getElementById("pDescriptionLoc").value = argArray[2];
// 				document.getElementById("specification").value  = argArray[3];
// 				document.getElementById("basicUnit").value      = argArray[4];
			}
		}
	);
}
//지우기
function doRemove( type ){
    if( type == "pItemNo" ) {
    	document.getElementById("pItemNo").value ="";
		document.getElementById("pDescriptionLoc").value = "";
    }  
    if( type == "cItemNo" ) {
    	document.getElementById("cItemNo").value = "";
		document.getElementById("cDescriptionLoc").value = "";
    }  
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="Javascript:fnBodyOnLoad();">
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>BOM 관리</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품목</td>
										<td width="35%" class="data_td">
											<input type="text" id="pItemNo" name="pItemNo" size="15" value='' onchange="javascript:fnPItemNoOnChange();">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:fnPIntemNoPop();">
											<a href="javascript:doRemove('pItemNo')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
<%-- 											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:fnPIntemNoPop();"> --%>
											<input type="text" id="pDescriptionLoc" name="pDescriptionLoc" size="15" value='' readonly="readonly">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;자품목</td>
										<td width="35%" class="data_td">
											<input type="text" id="cItemNo" name="cItemNo" size="15" value='' onchange="javascript:fnCItemNoOnChange();">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:fnCIntemNoPop();">
											<a href="javascript:doRemove('cItemNo')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" id="cDescriptionLoc" name="cDescriptionLoc" size="15" value='' readonly="readonly">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품요청수</td>
										<td class="data_td" colspan="3">
											<input type="text" name="desctiptionLoc" id="desctiptionLoc" size="20" class="inputsubmit" value=''>
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
				<td height="30" align="right">
					<table cellpadding="0">
						<tr>
							<td>
<script language="javascript">
btn("javascript:doSelect()", "조 회");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:fnChoice()", "확 인");
</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="MA_014" grid_obj="GridObj" grid_box="gridbox"/> --%>

<br/>
<br/>
<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>
</html>