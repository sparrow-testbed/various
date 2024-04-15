<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "c";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        	대분류 <p>
 Description:  	품목정보 > 품목관리 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	WELCHSY<p>
 @version      	1.0.0<p>
 @Comment       대분류 > 중분류 > 소분류 > 세분류를 관리한다.
!-->

<% 
	String WISEHUB_PROCESS_ID="MA_016";
	String WISEHUB_LANG_TYPE="KR";
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	
	/*Y일 경우 품목승인에서 넘어옴*/
	String app_flag          = JSPUtil.nullToEmpty(request.getParameter("app_flag"));
	app_flag          = "N";
	
	String type    = "0";
	String control = "M041";
	String class1  = "M042";
	String class2  = "M122";
		
    // "request 객체", "code name", "house_code#원하는code_type", "field 구분자", "line 구분자"
    SepoaListBox LB = new SepoaListBox();
    String lb_company_code = LB.Table_ListBox(request, "SL0088", house_code, "&" , "#");
    
    Logger.debug.println(info.getSession("ID"),this,"lb_company_code===>"+lb_company_code);
    
    
    
    
    
    
    
	SepoaFormater wf = null;
	SepoaOut value = null;
	SepoaRemote ws = null;
	
	String nickName= "p0070";
	String conType = "CONNECTION";
	
	String MethodName = "getSgContentsList";
	String sg_refitem = "";
	Object[] obj = { sg_refitem };
	
	try {
		ws 		= new SepoaRemote(nickName, conType, info);
		value 	= ws.lookup(MethodName, obj);
		wf 		= new SepoaFormater(value.result[0]);
	} catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	} catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	} finally {
		try{
			ws.Release();
		} catch(Exception e) { }
	}
	String str = "";
	for(int i=0; i < wf.getRowCount(); i++) {
		str = str + "<option value='" + wf.getValue("SG_REFITEM", i) + "'>" + wf.getValue("SG_NAME", i) + "</option>\n";
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_016_1"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_016_2"/>  
 			<jsp:param name="grid_obj" value="GridObj_2"/>
 			<jsp:param name="grid_box" value="gridbox_2"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_016_4"/>  
 			<jsp:param name="grid_obj" value="GridObj_4"/>
 			<jsp:param name="grid_box" value="gridbox_4"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_016_5"/>  
 			<jsp:param name="grid_obj" value="GridObj_5"/>
 			<jsp:param name="grid_box" value="gridbox_5"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
var area_code_col = "";
var image_text_col = "";
var area_name_col = "";
var company_code_col = "";
var ctrl_code_col = "";
var image_text1_col = "";
var ctrl_name_loc = "";
var ctrl_type_col = "";

function Init() {
	document.forms[0].flag_grid1.value = "";
	document.forms[0].flag_grid2.value = "";
	document.forms[0].flag_grid3.value = "";
	document.forms[0].flag_grid4.value = "";
	document.forms[0].flag_grid5.value = "";
	GridObj_1_setGridDraw();
	GridObj_1.setSizes();
	GridObj_2_setGridDraw();
	GridObj_2.setSizes();	
<%
	if(!"Y".equals(app_flag)){
%>
	GridObj_4_setGridDraw();
	GridObj_4.setSizes();
	GridObj_5_setGridDraw();
	GridObj_5.setSizes();
	
<%
	}
%>
	GridObj_1_doSelect();
}

function setHeader() {}

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

function GridObj_1_doSelectParams(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var params;
	
	
	inputParam = "type=0";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=query";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function GridObj_1_doSelect() {
	var servletURL = "/servlets/admin.basic.material.mty_g_lis1";
	var params     = GridObj_1_doSelectParams();
	
	GridObj_1.post(servletURL, params);
	GridObj_1.clearAll(false);
}

function GridObj_4_doSelectParams(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var params;
	
	var level = "0";
	var sg_refitem = "";

	if(form1.material_type.selectedIndex > 0)
	{
		level = "1";
		sg_refitem = form1.material_type.value;
	}
	if(form1.material_ctrl_type.selectedIndex > 0){
		level = "2";
		sg_refitem = form1.material_ctrl_type.value;
	}
	if(form1.material_class1.selectedIndex > 0) {
		level = "3";
		sg_refitem = form1.material_class1.value;
	}else{
		level = "4";
	}
	
	inputParam = "level="+level+"&sg_refitem="+sg_refitem;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=query";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function GridObj_4_doSelect() {
	var servletURL = "/servlets/admin.basic.material.mbb_g_lis1";
	var params     = GridObj_4_doSelectParams();
	
	GridObj_4.post(servletURL, params);
	GridObj_4.clearAll(false);
}

function lineInsertTl(){
	if(document.forms[0].flag_grid1.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	var newId = (new Date()).valueOf();
	
	GridObj_1.addRow(newId,"");
	
	document.forms[0].flag_grid1.value = "Y";
	
	document.forms[0].insert_flag.value = "on";	
	rowCount                        = GridObj_1.GetRowCount();
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_g_bd_lis1_hidden",
		{
			type        : "0",
			mode      : "getQuery"
		},
		function(arg){
			setClass(rowCount, arg, 'Tl');
		}
	);
}

function lineInsertTr(){
	if(document.forms[0].top_code.value == ''){
		alert("대분류를 선택하고 오른쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
		
		return;
	}
	
	if(document.forms[0].flag_grid2.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	var newId    = (new Date()).valueOf();
	var rowCount = 0;
	var top      = "";
	
	GridObj_2.addRow(newId,"");
	
	document.forms[0].flag_grid2.value  = "Y";
	document.forms[0].insert_flag.value = "on";	
	top                                 = document.forms[0].top_code.value;
	rowCount                            = GridObj_2.GetRowCount();
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_g_bd_lis1_hidden",
		{
			type      : document.forms[0].top_code.value,
			mode      : "getQuery"
		},
		function(arg){
			setClass(rowCount, arg, 'TR');
		}
	);
}

function lineInsertWg(){
	var rowCount         = GridObj_5.GetRowCount();
	var i                = 0;
	var areaCodeColValue = null;
	var top              = null;
	var middle           = null;
	var bottom           = null;
	var detail           = null;
	var newId            = (new Date()).valueOf();
	
	
	if(document.forms[0].detail_code.value == ''){
		alert("세분류를 선택하고 아래쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
		
		return;
	}
	
	if(document.forms[0].flag_grid5.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	
	document.forms[0].flag_grid5.value     = "Y";
	document.forms[0].event_location.value = "WG";
	
	top    = document.forms[0].top_code.value;
	detail = document.forms[0].detail_code.value;
	
	GridObj_5.addRow(newId,"");
}

function Line_insert(gridNm, str) {
	if(str == 'TL'){
		lineInsertTl();
	}
	else if(str == 'TR'){
		lineInsertTr();
	}
	else if(str == 'WG'){
		lineInsertWg();
	}
}

function CreateTL(){
	var rowCount     = GridObj_1.GetRowCount();
	var rowIndex     = rowCount - 1;
	var GROUP_CODEIndex = GridObj_1.getColIndexById("GROUP_CODE");
	var GROUP_NAMEIndex = GridObj_1.getColIndexById("GROUP_NAME");
	//var useFlagIndex = GridObj_1.getColIndexById("use_flag");
	var GROUP_CODE      = GD_GetCellValueIndex(GridObj_1, rowIndex, GROUP_CODEIndex);
	var GROUP_NAME      = GD_GetCellValueIndex(GridObj_1, rowIndex, GROUP_NAMEIndex);
	
	//GD_SetCellValueIndex(GridObj_1, rowIndex, useFlagIndex,	"Y");
	
	if(GROUP_CODE == "" ) {
		alert("대분류 코드는 필수입력사항입니다.");
		
		return;
	}
	
	if(GROUP_NAME == "" ) {
		alert("대분류명은 필수입력사항입니다.");
		
		return;
	}
	
	document.forms[0].flag_grid1.value = "";
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mty_g_wk_ins1",
		{
			type      : "0",
			item_type : GROUP_CODE, 
			mode      : "getCode"
		},
		function(arg){
			var flag = "";
			
	   		if(arg == "0"){
	   			flag = "Y";
	   	   	}
	   		else{
	   			flag = "N";
	   	   	} 
	   		
	   		Save(flag, "TL");
		}
	);
}

function createTr(){
	var rowCount     = GridObj_2.GetRowCount();
	var rowIndex     = rowCount - 1;
	var GROUP_CODEIndex = GridObj_2.getColIndexById("GROUP_CODE");
	var GROUP_NAMEIndex = GridObj_2.getColIndexById("GROUP_NAME");
	//var useFlagIndex = GridObj_1.getColIndexById("use_flag");
	var GROUP_CODE      = GD_GetCellValueIndex(GridObj_2, rowIndex, GROUP_CODEIndex);
	var GROUP_NAME      = GD_GetCellValueIndex(GridObj_2, rowIndex, GROUP_NAMEIndex);
	
	//GD_SetCellValueIndex(GridObj_1, rowIndex, useFlagIndex,	"Y");
	
	if(GROUP_CODE == "" ) {
		alert("중분류 코드는 필수입력사항입니다.");
		
		return;
	}
	
	if(GROUP_NAME == "" ) {
		alert("중분류명은 필수입력사항입니다.");
		
		return;
	}
	
	
	document.forms[0].flag_grid2.value = "";
	
	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mty_g_wk_ins1",
			{
				type      : document.forms[0].top_code.value,
				item_type : GROUP_CODE, 
				mode      : "getCode"
			},
			function(arg){
				var flag = "";
				
		   		if(arg == "0"){
		   			flag = "Y";
		   	   	}
		   		else{
		   			flag = "N";
		   	   	} 
		   		
		   		Save(flag, "TR");
			}
		);
}

function createWg(){
	var rowCount            = GridObj_5.GetRowCount();
	var rowIndex            = rowCount - 1;
	var areaCodeColValue    = GD_GetCellValueIndex(GridObj_5, rowIndex, area_code_col);
	var ctrlCodeColValue    = GD_GetCellValueIndex(GridObj_5, rowIndex, ctrl_code_col);
	var companyCodeColValue = GD_GetCellValueIndex(GridObj_5, rowIndex, company_code_col);
	
	if(areaCodeColValue.length < 1) {
		alert("팝업화면을 뛰워서 구매지역코드를 선택해야 합니다.");
		
		return;
	}
	
	if(ctrlCodeColValue.length < 1) {
		alert("팝업화면을 뛰워서 직무코드를 선택해야 합니다.");
		
		return;
	}
	
	check_count(companyCodeColValue, ctrlCodeColValue, 'WG');
}

function Create(gridNm, str) {
	var wise     = gridNm;
	var sel_row  = "";
	var i        = 0;
	var rowCount = wise.GetRowCount();
	var temp     = null;

	for(i = 0; i < rowCount; i++) {
		temp = GD_GetCellValueIndex(wise, i, 0);
		
		if(temp == true){
			sel_row += i+"&" ;
		}
	}

	if(sel_row == "") {
		alert("등록할 항목이 없습니다.");
		
		return;
	}
	else {
		if(str == 'TL'){
			CreateTL();
		}
		else if(str == 'TR'){
			createTr();
		}
		else if(str == 'WG'){
			createWg();
		}
	}
	
	document.forms[0].event_location.value = str;
}


function ChangeTl(){
	var rowCount         = GridObj_1.GetRowCount();
	var i                = 0;
	var GROUP_CODEColIndex  = GridObj_1.getColIndexById("GROUP_CODE");
	var GROUP_NAMEColIndex = GridObj_1.getColIndexById("GROUP_NAME");
	var SELECTEDColIndex    = GridObj_1.getColIndexById("SELECTED");
	var GROUP_NAME         = null;
	var SELECTEDColValue    = null;
	
	for(i = 0; i < rowCount; i++){
		SELECTEDColValue = GD_GetCellValueIndex(GridObj_1, i, SELECTEDColIndex);
		
		if(SELECTEDColValue == true){
			GROUP_CODE  = GD_GetCellValueIndex(GridObj_1, i, GROUP_CODEColIndex);
			GROUP_NAME = GD_GetCellValueIndex(GridObj_1, i, GROUP_NAMEColIndex);
			
			if(GROUP_CODE == ""){
				alert("대분류코드를 입력하세요.");
				
				return;
			}
			
			if(GROUP_NAME == ""){
				alert("대분류명을 입력하세요.");
				
				return;
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_g_upd1";
	var params;
	
	inputParam = "type=<%=type%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_1_sendTransactionGrid();
}

function changeTr(){
	var rowCount         = GridObj_2.GetRowCount();
	var i                = 0;
	var GROUP_CODEColIndex  = GridObj_2.getColIndexById("GROUP_CODE");
	var GROUP_NAMEColIndex = GridObj_2.getColIndexById("GROUP_NAME");
	var SELECTEDColIndex    = GridObj_2.getColIndexById("SELECTED");
	var GROUP_NAME         = null;
	var SELECTEDColValue    = null;
	
	for(i = 0; i < rowCount; i++){
		SELECTEDColValue = GD_GetCellValueIndex(GridObj_2, i, SELECTEDColIndex);
		
		if(SELECTEDColValue == true){
			GROUP_CODE  = GD_GetCellValueIndex(GridObj_2, i, GROUP_CODEColIndex);
			GROUP_NAME = GD_GetCellValueIndex(GridObj_2, i, GROUP_NAMEColIndex);
			
			if(GROUP_CODE == ""){
				alert("중분류코드를 입력하세요.");
				
				return;
			}
			
			if(GROUP_NAME == ""){
				alert("중분류명을 입력하세요.");
				
				return;
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_2, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_g_upd1";
	var params;
	
	inputParam = "type="+ document.forms[0].top_code.value;;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}


/* 어떤 항목을 수정하고 체크한뒤 수정버튼을 누르면 DB에 반영된다.*/
function Change(gridNm, str) {
	var wise = gridNm;
	var val = 0;
	
	for(var i=0; i < wise.GetRowCount();i++) {			
		if(GD_GetCellValueIndex(wise, i, 0) == true) {
			++val;
		}
	}
	
	if(val == 0){
		alert("수정할 데이터를 선택하세요");
		
		return;
	}
	
	if(confirm("수정하시겠습니까?") == false){
		return;
	}
	
	if(str == "TL"){
		ChangeTl();
	}
	else if(str == "TR"){
		changeTr();
	}
	
	document.forms[0].event_location.value = str;
}

function saveTl(){
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_g_ins1";
	var params;
	
	inputParam = "type=<%=type%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_1_sendTransactionGrid();		
}

function saveTr(){
	var grid_array = getGridChangedRows(GridObj_2, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_g_ins1";
	var params;
	
	inputParam = "type="+ document.forms[0].top_code.value;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}

function saveVl(flag){
	if(flag != 'Y') {
		alert("이미 있는 데이타입니다.");
		
		return;
	}
	
	if(confirm("업체추가 하시겠습니까?") == false){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj_4, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var servletURL = "/servlets/admin.basic.material.mbb_g_ins1";
	var params;
	
	inputParam = "type="+ document.forms[0].detail_code.value;
	
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_4_sendTransactionGrid();
}

function Save(flag, str) {
	var wise = "";
	var typeName = "";
	var typeValue = "";
	var servletURL = "";
	
	if(flag != 'Y') {
		alert("이미 있는 데이타입니다.");
		
		return;
	}
	
	if(confirm("저장하시겠습니까?") == false){
		return;
	}
	
	if(str == "TL"){
		saveTl();
	}
	else if(str == "TR"){
		saveTr();
	}
}

function DeleteTl(){
	var rowCount         = GridObj_1.GetRowCount();
	var i                = 0;
	var GROUP_CODEColIndex  = GridObj_1.getColIndexById("GROUP_CODE");
	
	for(i = 0; i < rowCount; i++){
		var GROUP_CODE  = GD_GetCellValueIndex(GridObj_1, i, GROUP_CODEColIndex);
		
		if(GROUP_CODE == ""){
			alert("대분류코드를 입력하세요.");
			
			return;
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_g_del1";
	var params;
	
	inputParam = "type=<%=type%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_1_sendTransactionGrid();
}

function deleteTr(){
	var rowCount         = GridObj_2.GetRowCount();
	var i                = 0;
	var GROUP_CODEColIndex  = GridObj_2.getColIndexById("GROUP_CODE");
	
	for(i = 0; i < rowCount; i++){
		var GROUP_CODE  = GD_GetCellValueIndex(GridObj_2, i, GROUP_CODEColIndex);
		
		if(GROUP_CODE == ""){
			alert("중분류코드를 입력하세요.");
			
			return;
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_2, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mct_g_del1";
	var params;
	
	inputParam = "type="+document.forms[0].top_code.value;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}

function deleteWg(){
	var grid_array = getGridChangedRows(GridObj_5, "SELECTED");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_5_getColIds();
	var servletURL = "/servlets/admin.basic.material.maa_g_del1";
	var params;
	var type   = document.forms[0].detail_code.value;
	
	inputParam = "type=" + type;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_5_sendTransactionGrid();
}

/* 선택한 항목을 지운다. */
function Delete(gridNm, str) {
	var wise = gridNm;
	var del_row = "";

	for(var i=0; i < wise.GetRowCount();i++) {
		var temp = GD_GetCellValueIndex(wise,i,0);
		
		if(temp == true) {
			del_row = i;
			
			break;
		}
	}

	if(del_row.length < 1){
		alert("항목을 선택해주세요.");
		
		return;
	}
	
	if(confirm("정말로 삭제하시겠습니까?") == false){
		return;
	}
	
	
	if(str == "TL"){
		DeleteTl();
	}
	else if(str == "TR"){
		deleteTr();
	}
	else if(str == "WG"){
		deleteWg();
	}
	
	document.forms[0].event_location.value = str;
}

function check_flag(result) {
	var wise = GridObj_5;
	var item_control = document.forms[0].middle_code.value;
	var item_class   = document.forms[0].bottom_code.value;
	var item_class2  = document.forms[0].detail_code.value;
	
	var ctrl_type = "P";
	var type = "M122";

	if(result == "Y") {
		var grid_array = getGridChangedRows(GridObj_5, "Check");
		var inputParam = "";
		var body       = document.getElementsByTagName("body")[0];
		var cols_ids   = GridObj_5_getColIds();
		var servletURL = "/servlets/admin.basic.material.maa_ins1";
		var params;
		
		inputParam = "item_class2=" + item_class2;
		inputParam = inputParam + "&ctrl_type=P";
		
		var form = fnGetDynamicForm("", inputParam, null);
		
		body.appendChild(form);
		
		params = "mode=doData";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		
		body.removeChild(form);
		
		myDataProcessor = new dataProcessor(servletURL + "?" + params);
		
		GridObj_5_sendTransactionGrid();
	}
	else{
		alert("존재하지 않는 코드입니다.");
		
		return;
	}
}

function check_count(code1, code2, str){
	document.forms[0].target = "workFrm";
	
	if(str == 'TL'){		
		document.forms[0].action = "/kr/admin/basic/material/cut_wk_lis1.jsp?de_type=<%=control %>&code1="+code1+"&code2="+code2;
		document.method = "post";
		document.forms[0].submit();
	}
	else if(str == 'TR'){}
	else if(str == 'BL'){}
	else if(str == 'BR'){}
	else if(str == 'WG'){
		document.forms[0].action = "/kr/admin/basic/material/maa_wk_lis2.jsp?company_code="+code1+"&ctrl_code="+code2;
		document.method = "get";
		
		document.forms[0].submit();
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.maa_wk_lis2",
			{
				company_code : code1,
				ctrl_code    : code2, 
				mode         : "getQuery"
			},
			function(arg){
				if(arg == ""){
					alert("에러입니다.");
				}
				else if(arg != "NOTBE") {
					SP9079_getCode(code2, arg);
					check_flag("Y");
					
				}
				else{
					check_flag("N");
				}
			}
		);
	}
}

/* 삭제하고 난 뒤에 첫 화면(쿼리된 화면)으로 돌아온다.*/
function JavaCall(msg1,msg2, msg3, msg4, msg5){
	
 	if(msg1=="doData"){ 	
 		if(document.forms[0].event_location.value != ""){
 			if(document.forms[0].event_location.value == "TL"){
 				alert(GridObj1.Getmessage());
 				Query(); 				
 			}else if(document.forms[0].event_location.value == "TR"){
 				alert(GridObj2.Getmessage());
 				goRight();
 			}else if(document.forms[0].event_location.value == "WG"){
 				alert(GridObj5.Getmessage());
 				goWorkItem(); 				
 			}
 		}
 	}
 	
 	if(document.forms[0].event_location.value="WG"){
 		
 		if(msg1 == "t_imagetext" && msg3 == image_text_col) {
 			var wise = GridObj5;
 	 		if(document.forms[0].flag_grid5.value == "Y") {
 	 			if( document.forms[0].region_flag.value == "" ) {
 	 				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=region_getCode&values=<%=house_code%>&values=M039&values=&values=";
 	 			}else {
 	 				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9135&function=region_getCode&values=<%=house_code%>&values=M039&values="+document.forms[0].region_flag_count.value+"&values=&values=";
 	 			}
 	 			//Code_Search(url,'','','','','');
 	 			CodeSearchCommon(url,'','','','','');
 	 		}else{
 	 			alert("생성시에만 누르실 수 있습니다.");
 	 		}
 	 	}else if(msg1 == "t_imagetext" && msg3 == image_text1_col) {
 	 		var wise = GridObj5;
 	 		if(wise.GetCellValue('area_code', msg2)==""){
 	 			alert("구매지역코드를 먼저 입력하세요");
 	 			return;
 	 		}
//  	 		document.forms[0].row.value = msg2;
 	 		if(document.forms[0].flag_grid5.value == "Y") {
 	 			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9079&function=D&values=<%=house_code%>&values="+wise.GetComboHiddenValue(wise.GetColHDKey(company_code_col),msg2)+"&values=P&values=&values=";
 	 			//Code_Search(url,'','','','','');
 	 			CodeSearchCommon(url,'','','','','');
 	 		}else{
 	 			alert("생성시에만 누르실 수 있습니다.");
 	 		}
 	 	}
 	}
}

function SP9079_getCode(a,b) {
	var row      = GridObj_5.GetRowCount();
	var rowIndex = row - 1;

	GD_SetCellValueIndex(GridObj_5, rowIndex, ctrl_code_col, a);
	GD_SetCellValueIndex(GridObj_5, rowIndex, ctrl_name_loc, b);

}

function GridObj_2_doSelectParams(type, code){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var params;
	
	inputParam = "type=" + type;
	inputParam = inputParam + "&code=" + code;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=query";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

//대분류를 선택하여 중분류를 조회한다.(왼쪽 --> 오른쪽)
function goRight(){
	var value                     = 0;
	var code                      = "";
	var gridObj_1_rowCount        = GridObj_1.GetRowCount();
	var i                         = 0;
	var gridObj_1_IndexColSELECTED   = GridObj_1.getColIndexById("SELECTED");
	var gridObj_1_IndexColAddNcy  = GridObj_1.getColIndexById("ADD_NCY");
	var gridObj_1_IndexColGROUP_CODE = GridObj_1.getColIndexById("GROUP_CODE");
	var gridObj_1_ValueColSELECTED   = null;
	var gridObj_1_ValueColAddNcy  = null;
	
	if(gridObj_1_rowCount > 0){
		for(i = 0; i < gridObj_1_rowCount; i++){
			gridObj_1_ValueColSELECTED   = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColSELECTED);
			gridObj_1_ValueColAddNcy  = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColAddNcy);
			
			
			if(gridObj_1_ValueColSELECTED == true){
				if(gridObj_1_ValueColAddNcy == 'Y'){
					value++;
					
					code = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColGROUP_CODE);
				}else{
					alert("등록 후 선택하여주세요.");
					
					return;					
				}
			}
		}
		
		if(value == 0){
			alert("대분류를 선택하세요.");
			
			return;
		}
		else if(value > 1){
			alert("대분류는 하나만 선택할 수 있습니다.");
			
			return;
		}	
		
		var type = "M041"
		
		document.forms[0].insert_flag.value = "off";
		document.forms[0].top_code.value    = code;
		document.forms[0].flag_grid2.value  = "";
		
		document.forms[0].detail_code.value = "";
		document.forms[0].flag_grid5.value  = "";
		
		var servletURL = "/servlets/admin.basic.material.mct_g_lis1";
		var params     = GridObj_2_doSelectParams(type, code);
		
		GridObj_2.post(servletURL, params);
		GridObj_2.clearAll(false);
<%
	if(!"Y".equals(app_flag)){
%>  
		GridObj_5.clearAll(false);
<%
	}
%>
	}
	else{
		alert("대분류가 없습니다.");
	}
}

//업체를 조회하여 그룹으로 묶어준다.(왼쪽 --> 오른쪽)
function goRight2(){	
	if(document.forms[0].detail_code.value == ""){
		alert("중분류를 선택후 아래화살표 누르시요.");
		return;
	}
	
	
	var value                     = 0;
	var code                      = "";
	var gridObj_4_rowCount        = GridObj_4.GetRowCount();
	var i                         = 0;
	var gridObj_4_IndexColSELECTED   = GridObj_4.getColIndexById("SELECTED");
	var gridObj_4_IndexColVENDOR_CODE = GridObj_4.getColIndexById("VENDOR_CODE");
	var gridObj_4_ValueColSELECTED   = null;
	
	if(gridObj_4_rowCount > 0){
		for(i = 0; i < gridObj_4_rowCount; i++){
			gridObj_4_ValueColSELECTED   = GD_GetCellValueIndex(GridObj_4, i, gridObj_4_IndexColSELECTED);
						
			if(gridObj_4_ValueColSELECTED == true){
				value++;
				
				code = GD_GetCellValueIndex(GridObj_4, i, gridObj_4_IndexColVENDOR_CODE);
			}
		}
		
		if(value == 0){
			alert("업체를 선택하세요.");
			
			return;
		}
		else if(value > 1){
			alert("업체는 하나만 선택할 수 있습니다.");
			
			return;
		}	
		
		$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mbb_g_wk_ins1",
				{
					code      : code,
					item_type : document.forms[0].detail_code.value, 
					mode      : "getCode"
				},
				function(arg){
					var flag = "";
					
			   		if(arg == "0"){
			   			flag = "Y";
			   	   	}
			   		else{
			   			flag = "N";
			   	   	} 
			   		
			   		saveVl(flag);			   		
				}
			);
	}
	else{
		alert("추가가능한 업체가 없습니다.");
	}

}

function GridObj_5_doSelectParams(code){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_5_getColIds();
	var params;
	
	inputParam = "detail_code=" + code;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=getQuery";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function goWorkItem(){
	var code           = "";
	var value          = "";
	var rowCount       = GridObj_2.GetRowCount();
	var i              = 0;
	var SELECTEDColIndex  = GridObj_2.getColIndexById("SELECTED");
	var addNcyColIndex = GridObj_2.getColIndexById("ADD_NCY");
	var GROUP_CODEColIndex = GridObj_2.getColIndexById("GROUP_CODE");
	var SELECTEDColValue  = null;
	var addNcyColValue = null;
	
	if(document.forms[0].top_code.value == ""){
		alert("대분류를 선택하세요");
		
		return;
	}
	
	if(rowCount <= 0){
		alert("중분류가 없습니다.");
		
		return;
	}
	
	for(i = 0; i < rowCount; i++){
		SELECTEDColValue = GD_GetCellValueIndex(GridObj_2, i, SELECTEDColIndex);
		
		if(SELECTEDColValue == true){
			addNcyColValue = GD_GetCellValueIndex(GridObj_2, i, addNcyColIndex);
			
			if(addNcyColValue == 'Y'){
				value++;
				
				code = GD_GetCellValueIndex(GridObj_2, i, GROUP_CODEColIndex);
			}
			else{
				alert("등록 후 선택하여주세요.");
				
				return;					
			}
		}
	}
	
	if(value == 0){
		alert("중분류를 선택하세요.");
		
		return;
	}
	else if(value > 1){
		alert("중분류는 하나만 선택할 수 있습니다.");
		
		return;
	}

	document.forms[0].detail_code.value = code;
	document.forms[0].flag_grid5.value  = "";
	
	var servletURL = "/servlets/admin.basic.material.maa_g_lis1";
	var params     = GridObj_5_doSelectParams(code);
	
	GridObj_5.post(servletURL, params);
	GridObj_5.clearAll(false);
}

function setClass(idx, item_control, str) {	
	if(str == "Tl"){
		var contCodeColIndex = GridObj_1.getColIndexById("GROUP_CODE");
		
		GD_SetCellValueIndex(GridObj_1, idx - 1, contCodeColIndex, item_control);	
	}
	else if(str == "TR"){
		var contCodeColIndex = GridObj_2.getColIndexById("GROUP_CODE");
		
		GD_SetCellValueIndex(GridObj_2, idx - 1, contCodeColIndex, item_control);	
	}
    
}

function region_getCode(a,b) {
	var wise             = GridObj_5;
	var count            = 0;
	var i                = 0;
	var rowCount         = GridObj_5.GetRowCount();
	var areaCodeColValue = null;
	var rowIndex         = rowCount - 1;
	
	for(i = 0; i < rowCount; i++) { //이미 있는 데이타를 가져오는지 확인한다.
		var areaCodeColValue = GD_GetCellValueIndex(GridObj_5, i, area_code_col);
	
		if(areaCodeColValue == a) {
			count = count + 1;
			break;
		}
	}
	
	if(count != 0){
		alert("이미 있는 데이타입니다.");
		
		return;
	}
	
	GD_SetCellValueIndex(GridObj_5, rowIndex, area_code_col, a);
	GD_SetCellValueIndex(GridObj_5, rowIndex, area_name_col, b);
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid5,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
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
        doQuery();
    } else {
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
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
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

	document.getElementById("GridObj_1_message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	alert(messsage);
	
	if(status == "true") {
		GridObj_1_doSelect();
	}

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_1.clearAll();
		GridObj_1.setCSVDelimiter("\t");
		GridObj_1.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj_1.getUserData("", "message");
	var status     = GridObj_1.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

function GridObj_1_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_1, "SELECTED");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var SELECTEDColIndex   = GridObj_1.getColIndexById("SELECTED");
	var gridObj_1Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_1);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_1_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		gridObj_1Cell = GridObj_1.cells(gridArrayInfo, SELECTEDColIndex);
		checked       = gridObj_1Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_1_doQueryDuring();
}

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_2_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_2_doOnCellChange(stage,rowId,cellInd){
	//var max_value = GridObj_2.cells(rowId, cellInd).getValue();
	
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
function GridObj_2_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_2_message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}
	
	alert(messsage);
	
	if(status == "true") {
        goRight();
    }
	
	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_2_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_2.clearAll();
		GridObj_2.setCSVDelimiter("\t");
		GridObj_2.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_2_doQueryEnd() {
	var msg        = GridObj_2.getUserData("", "message");
	var status     = GridObj_2.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	return true;
}

function GridObj_2_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_2, "SELECTED");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_2.getColIndexById("SELECTED");
	var GridObj_2Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_2);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_2_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		GridObj_2Cell = GridObj_2.cells(gridArrayInfo, checkColIndex);
		checked       = GridObj_2Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_2_doQueryDuring();
}


//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_4_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_4_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_4.cells(rowId, cellInd).getValue();
	
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
function GridObj_4_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	
	document.getElementById("GridObj_4_message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}
	
	alert(messsage);

	if(status == "true") {
		goWorkItem();
	}
	
	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_4_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_4.clearAll();
		GridObj_4.setCSVDelimiter("\t");
		GridObj_4.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_4_doQueryEnd() {
	var msg        = GridObj_4.getUserData("", "message");
	var status     = GridObj_4.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

function GridObj_4_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_4, "SELECTED");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_4.getColIndexById("SELECTED");
	var GridObj_4Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_4);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_4_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		GridObj_4Cell = GridObj_4.cells(gridArrayInfo, checkColIndex);
		checked       = GridObj_4Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	//GridObj_4_doQueryDuring();
}

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_5_doOnRowSelected(rowId,cellInd){
	var areaCodeColIndex    = GridObj_5.getColIndexById("area_code");
	var ctrlCodeColIndex    = GridObj_5.getColIndexById("ctrl_code");
	var companyCodeColIndex = GridObj_5.getColIndexById("company_code");
	var url                 = "";
	
	if(cellInd == areaCodeColIndex) { 
		if(document.forms[0].flag_grid5.value == "Y") {
			if(document.forms[0].region_flag.value == "" ) {
				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=region_getCode&values=<%=house_code%>&values=M039&values=&values=";
			}
			else {
				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9135&function=region_getCode&values=<%=house_code%>&values=M039&values="+document.forms[0].region_flag_count.value+"&values=&values=";
			}
			
			//Code_Search(url,'','','','','');
			CodeSearchCommon(url,'','','','','');
		}
		else{
			alert("생성시에만 누르실 수 있습니다.");
		}
	}
	else if(cellInd == ctrlCodeColIndex) {
		var rowIndex            = GridObj_5.getRowIndex(rowId);
		var areaCodeColValue    = GD_GetCellValueIndex(GridObj_5, rowIndex, areaCodeColIndex);
		var companyCodeColValue = GD_GetCellValueIndex(GridObj_5, rowIndex, companyCodeColIndex);
		
		if(areaCodeColValue == ""){
			alert("구매지역코드를 먼저 입력하세요");
	 			
			return;
		}
		
		if(document.forms[0].flag_grid5.value == "Y") {
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9079&function=D&values=<%=house_code%>&values=" + companyCodeColValue + "&values=P&values=&values=";
			
			//Code_Search(url,'','','','','');
			CodeSearchCommon(url,'','','','','');
		}
		else{
			alert("생성시에만 누르실 수 있습니다.");
		}
	}
}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_5_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_5.cells(rowId, cellInd).getValue();
	
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
function GridObj_5_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_5_message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}
	
	alert(messsage);

	if(status == "true") {
		goWorkItem();
	}
	
	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_5_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_5.clearAll();
		GridObj_5.setCSVDelimiter("\t");
		GridObj_5.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_5_doQueryEnd() {
	var msg        = GridObj_5.getUserData("", "message");
	var status     = GridObj_5.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

function GridObj_5_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_5, "SELECTED");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_5.getColIndexById("SELECTED");
	var GridObj_5Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_5);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_5_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		GridObj_5Cell = GridObj_5.cells(gridArrayInfo, checkColIndex);
		checked       = GridObj_5Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_5_doQueryDuring();
}

	function MATERIAL_TYPE_Changed()
	{
	  	clearMATERIAL_CTRL_TYPE();
	  	setMATERIAL_CTRL_TYPE("----------", "");
	    clearMATERIAL_CLASS1();
	  	setMATERIAL_CLASS1("----------", "");
	    var sg_refitem = form1.material_type.value;
	  	target = "MATERIAL_TYPE";
	  	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	  	this.hiddenframe.location.href = data;
	  	//location.href = data;
	}
	function MATERIAL_CTRL_TYPE_Changed()
  	{
  	  	clearMATERIAL_CLASS1();
  	  	var sg_refitem = form1.material_ctrl_type.value;
  	  	target = "MATERIAL_CTRL_TYPE";
  	  	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
  	  	this.hiddenframe.location.href = data;
  	}
	function MATERIAL_CLASS1_Changed()
  	{
  	  	var sg_refitem = form1.material_class1.value;
  	  	target = "MATERIAL_CLASS1";
  	  	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
  	  	this.hiddenframe.location.href = data;
  	}
	function clearMATERIAL_CLASS1()
  	{
  	  	if(form1.material_class1.length > 0)
  	  	{
  	    		for(i=form1.material_class1.length-1; i>=0;  i--) {
  	     			form1.material_class1.options[i] = null;
  	    		}
  	  	}
  	}
  	function setMATERIAL_CLASS1(name, value)
  	{
  		var option1 = new Option(name, value, true);
  	  	form1.material_class1.options[form1.material_class1.length] = option1;
  	}
  	function clearMATERIAL_CTRL_TYPE()
  	{
  	  	if(form1.material_ctrl_type.length > 0) {
  	    		for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
  	     			form1.material_ctrl_type.options[i] = null;
  	    		}
  	  	}
  	}
  	function setMATERIAL_CTRL_TYPE(name, value)
  	{
  	  	var option1 = new Option(name, value, true);
  	  	form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
  	}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="Init();">
<s:header popup="true">
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="760" height="2" bgcolor="#0072bc"></td>
		</tr>
	</table>
	<form name="form1" method="post" action="">
		<input type="hidden" size="5" value="off" name="insert_flag" class="inputsubmit">
		<input type="hidden" size="5" value="" name="count" class="inputsubmit">
		
		<%--분류코드 히든값 세팅 --%>
		<input type="hidden" name="top_code">
		<input type="hidden" name="middle_code">
		<input type="hidden" name="bottom_code">
		<input type="hidden" name="detail_code">
		<%--조회버튼클릭 플래그 --%>
		<input type="hidden" name="flag_grid1">
		<input type="hidden" name="flag_grid2">
		<input type="hidden" name="flag_grid3">
		<input type="hidden" name="flag_grid4">
		<input type="hidden" name="flag_grid5">
		<%--이벤트발생 플래그 --%>
		<input type="hidden" name="event_location">
		
		<input type="hidden" value="" name="region_flag">
		<input type="hidden" value="" name="region_flag_count">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="5px"></td>
			</tr>
			<tr>
				<td width="48%" align="right">
<%
	if(!"Y".equals(app_flag)){
%>  		
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:Line_insert(GridObj_1, 'TL')", "행삽입");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Create(GridObj_1, 'TL')", "등 록");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Change(GridObj_1, 'TL')", "수 정");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Delete(GridObj_1, 'TL')", "삭 제");
</script>
							</TD>
						</TR>
					</TABLE>
<%
	}
%>
				</td>
				<td width="4%"></td>
				<td width="48%" align="right">
					<TABLE cellpadding="0">
						<TR>
<%
	if("Y".equals(app_flag)){
%>
							<TD>
<script language="javascript">
btn("javascript:goRight()", "조 회");
</script>
							</TD>
<%
	}
	else{
%>
							<TD>
<script language="javascript">
btn("javascript:Line_insert(GridObj_2, 'TR')", "행삽입");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Create(GridObj_2, 'TR')", "등 록");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Change(GridObj_2, 'TR')", "수 정");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Delete(GridObj_2, 'TR')", "삭 제");
</script>
							</TD>
<%
	}
%>  		
						</TR>
					</TABLE>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
				</td>
				<td align="center">
					<a href="javascript:goRight()">
						<img src="/images/hwasalpyo_right.png" border="0" width="27px" height="31px" />
					</a>
				</td>
				<td align="center" valign="top">
					<div id="gridbox_2" name="gridbox_2" width="100%" style="background-color:white;"></div>
				</td>
			</tr>			
<%
	if(!"Y".equals(app_flag)){
%>    
			<tr>
				<td height="40px" colspan="2"></td>
				<td align="center" valign="middle">
					<a  href="javascript:goWorkItem();">
						<img src="/images/hwasalpyo_down.png" border="0" width="27px" height="31px" />
					</a>
				</td>
			</tr>
			<tr>
				<td width="48%" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								 업체명<input type="text"   name="vendor_name" id="vendor_name" size="15" class="inputsubmit" maxlength="20" >&nbsp;&nbsp;&nbsp;&nbsp;       							 
								<select name="material_type" id="material_type" class="inputsubmit" onChange="javascript:MATERIAL_TYPE_Changed();">
								<option value=''>----------</option>
									<%=str%>
								</select>
								<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javascript:MATERIAL_CTRL_TYPE_Changed();">
								<option value=''>----------</option>
								</select>
								<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javascript:MATERIAL_CLASS1_Changed();">
								<option value=''>----------</option>
								</select>
							</TD>
							<TD>
									<script language="javascript">
									btn("javascript:GridObj_4_doSelect()", "조회");
									</script>
							</TD>
						</TR>
					</TABLE>
				</td>
				<td width="4%"></td>
				<td width="48%" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD style="display:none;">
									<script language="javascript">
									btn("javascript:Line_insert(GridObj_5, 'WG')", "행삽입");
									</script>
							</TD>
							<TD style="display:none;">
									<script language="javascript">
									btn("javascript:Create(GridObj_5, 'WG')", "등 록");
									</script>
							</TD>
							<TD>
									<script language="javascript">
									btn("javascript:Delete(GridObj_5, 'WG')", "삭 제");
									</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div id="gridbox_4" name="gridbox_4" width="100%" style="background-color:white;"></div>
				</td>
				<td align="center">
					<a href="javascript:goRight2()">
						<img src="/images/hwasalpyo_right.png" border="0" width="27px" height="31px" />
					</a>
				</td>
				<td align="center" valign="top">
					<div id="gridbox_5" name="gridbox_5" width="100%" style="background-color:white;"></div>
				</td>
			</tr>        
<%
	}
%>
    
		</table>
		<iframe name = "hiddenframe" src=""  width="0" height="0" border="0" frameborder="0"></iframe>
	</form>
	<iframe name="workFrm" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</s:header>
<s:footer/>
</body>
</html>