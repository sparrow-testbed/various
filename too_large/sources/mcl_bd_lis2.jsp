<%@page import="java.util.regex.Pattern"%>
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
	String WISEHUB_PROCESS_ID="MA_011";
	String WISEHUB_LANG_TYPE="KR";
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	
	/*Y일 경우 품목승인에서 넘어옴*/
	String app_flag  = JSPUtil.nullToEmpty(request.getParameter("app_flag"));
	String item_no   = JSPUtil.nullToEmpty(request.getParameter("item_no"));
	String top_code  = "";
	String middle_code  = "";
	boolean isNumber = false;
	int length = 0;
	
	if("Y".equals(app_flag)){
		//<input type="hidden" name="top_code">
		//<input type="hidden" name="middle_code">
		if("".equals(item_no)){
			top_code = "";
		}else{
			//isNumber = java.util.regex.Pattern.matches("^[0-9a-zA-Z가-힣]*$","asdfsadf");
			isNumber = StringUtils.isNumeric(item_no);
			length = item_no.length();
			
			if(isNumber){
				if(length == 6){
					if("1".equals(item_no.substring(0,1))){ //일반집기
						top_code = "02";
						middle_code = "02001";
					}else if("2".equals(item_no.substring(0,1))){ //일반기구
						top_code = "02";
						middle_code = "02002";
					}else if("3".equals(item_no.substring(0,1))){ //전산기기
						top_code = "02";
						middle_code = "02003";
					}else if("4".equals(item_no.substring(0,1))){ //사무기기
						top_code = "02";
						middle_code = "02004";
					}else if("5".equals(item_no.substring(0,1))){ //간판류
						top_code = "02";
						middle_code = "02005";
					}else if("6".equals(item_no.substring(0,1))){ //차량류
						top_code = "02";
						middle_code = "02006";
					}else if("7".equals(item_no.substring(0,1))){ //서화류
						top_code = "02";
						middle_code = "02007";
					}else if("8".equals(item_no.substring(0,1))){ //안전관리장비
						top_code = "02";
						middle_code = "02008";
					}else if("9".equals(item_no.substring(0,1))){ //기타
						top_code = "02";
						middle_code = "02009";
					}
				}else if(length == 10){
					if("20".equals(item_no.substring(0,2))){ //중용증서
						top_code = "01";
						middle_code = "01020";
					}else if("30".equals(item_no.substring(0,2))){ //용도품
						top_code = "01";
						middle_code = "01030";
					}else if("91".equals(item_no.substring(0,2))){ //안내장
						top_code = "03";
						middle_code = "03091";
					}
				}else if(length == 14){
					if("92".equals(item_no.substring(0,2))){ //홍보물
						top_code = "03";
						middle_code = "03092";
					}
				}
			}
		}
	}
	
	String type    = "M040";
	String control = "M041";
	String class1  = "M042";
	String class2  = "M122";
	
    // "request 객체", "code name", "house_code#원하는code_type", "field 구분자", "line 구분자"
    SepoaListBox LB = new SepoaListBox();
    String lb_company_code = LB.Table_ListBox(request, "SL0088", house_code, "&" , "#");
    
    Logger.debug.println(info.getSession("ID"),this,"lb_company_code===>"+lb_company_code);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_011_1"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_011_2"/>  
 			<jsp:param name="grid_obj" value="GridObj_2"/>
 			<jsp:param name="grid_box" value="gridbox_2"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_011_3"/>  
 			<jsp:param name="grid_obj" value="GridObj_3"/>
 			<jsp:param name="grid_box" value="gridbox_3"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_011_4"/>  
 			<jsp:param name="grid_obj" value="GridObj_4"/>
 			<jsp:param name="grid_box" value="gridbox_4"/>
 			<jsp:param name="grid_cnt" value="5"/>
</jsp:include>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="MA_011_5"/>  
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
	GridObj_3_setGridDraw();
	GridObj_3.setSizes();
	GridObj_4_setGridDraw();
	GridObj_4.setSizes();
<%
	if(!"Y".equals(app_flag)){
%>
	GridObj_5_setGridDraw();
	GridObj_5.setSizes();
	
	area_code_col    = GridObj_5.getColIndexById("area_code");
	area_name_col    = GridObj_5.getColIndexById("area_name");
	company_code_col = GridObj_5.getColIndexById("company_code");
	ctrl_code_col    = GridObj_5.getColIndexById("ctrl_code");
	ctrl_name_loc    = GridObj_5.getColIndexById("ctrl_name_loc");
<%
	}
%>
	GridObj_1_doSelect('<%=top_code%>');
<%  if(!"".equals(middle_code)){ %>
	GridObj_2_doSelect('<%=middle_code%>');
	GridObj_3_doSelect('<%=top_code%>','<%=middle_code%>');
<%  } %>
}

function setHeader() {}

function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	//frm.appendChild(input);
	
	//return frm;
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

function GridObj_1_doSelectParams(code){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var params;
	
	inputParam = "type=M040";
	inputParam = inputParam + "&code=" + code;
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
    params = "mode=query";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function GridObj_1_doSelect(code) {
	var servletURL = "/servlets/admin.basic.material.mty_lis1";
	var params     = GridObj_1_doSelectParams(code);
	
	GridObj_1.post(servletURL, params);
	GridObj_1.clearAll(false);
}



function GridObj_2_doSelect(code){
	var value                     = 0;
	
    var type = "M041"
		
	document.forms[0].insert_flag.value = "off";
	document.forms[0].top_code.value    = code;
	document.forms[0].flag_grid2.value  = "";
	
	var servletURL = "/servlets/admin.basic.material.mct_lis1";
	var params     = GridObj_2_doSelectParams(type, code);
	
	GridObj_2.post(servletURL, params);
	GridObj_2.clearAll(false);
	GridObj_3.clearAll(false);
	GridObj_4.clearAll(false);
	
	<%
	if(!"Y".equals(app_flag)){
	%>  
		GridObj_5.clearAll(false);
	<%
	}
	%>
}

function GridObj_3_doSelect(item_type,code){
	
	document.forms[0].middle_code.value = code;
	document.forms[0].flag_grid3.value = "";
	
	var servletURL = "/servlets/admin.basic.material.mcl_lis1";
	var params     = GridObj_3_doSelectParams(item_type, code);
	
	GridObj_3.post(servletURL, params);
	GridObj_3.clearAll(false);
	GridObj_4.clearAll(false);
	<%
	if(!"Y".equals(app_flag)){
	%>  
	GridObj_5.clearAll(false);
	<%
	}
	%>
}


function lineInsertTl(){
	if(document.forms[0].flag_grid1.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	var newId = (new Date()).valueOf();
	
	GridObj_1.addRow(newId,"");
	
	document.forms[0].flag_grid1.value = "Y";
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
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_bd_lis1_hidden",
		{
			type      : "M041",
			item_type : top, 
			mode      : "getQuery"
		},
		function(arg){
			setClass(rowCount, arg, 'TR');
		}
	);
}

function lineInsertBr(){
	if(document.forms[0].middle_code.value == ''){
		alert("중분류를 선택하고 아래쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
		
		return;
	}
	
	if(document.forms[0].flag_grid3.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	var newId           = (new Date()).valueOf();
	var rowCount        = 0;
	var rowIndex        = 0;
	var useColIndex     = GridObj_3.getColIndexById("use");
	var typeColIndex    = GridObj_3.getColIndexById("type");
	var controlColIndex = GridObj_3.getColIndexById("control");
	var addNcyColIndex  = GridObj_3.getColIndexById("add_ncy");
	var top             = "";
	var middle          = "";
	
	document.forms[0].flag_grid3.value = "Y";
	top                                = document.forms[0].top_code.value;
	middle                             = document.forms[0].middle_code.value;
	
	GridObj_3.addRow(newId,"");
	
	rowCount = GridObj_3.GetRowCount();
	rowIndex = rowCount - 1;
	
	GD_SetCellValueIndex(GridObj_3, rowIndex, useColIndex,     "Y");
	GD_SetCellValueIndex(GridObj_3, rowIndex, typeColIndex,    top);
	GD_SetCellValueIndex(GridObj_3, rowIndex, controlColIndex, middle);
	GD_SetCellValueIndex(GridObj_3, rowIndex, addNcyColIndex,  "D");
		
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_bd_lis1_hidden",
		{
			type      : "M042",
			item_type : middle, 
			mode      : "getQuery"
		},
		function(arg){
			setClass(rowCount, arg, 'BR');
		}
	);
}

function lineInsertBl(){
	var top             = document.forms[0].top_code.value;
	var middle          = document.forms[0].middle_code.value;
	var bottom          = document.forms[0].bottom_code.value;
	var rowCount        = 0;
	var rowIndex        = 0;
	var typeColIndex    = GridObj_4.getColIndexById("type");
	var controlColIndex = GridObj_4.getColIndexById("control");
	var class1ColIndex  = GridObj_4.getColIndexById("class1");
	var addNcyColIndex  = GridObj_4.getColIndexById("add_ncy");
	var newId           = (new Date()).valueOf();
	
	if(document.forms[0].bottom_code.value == ''){
		alert("소분류를 선택하고 왼쪽방향 화살표를 클릭하신 후 행삽입이 가능합니다.");
		
		return;
	}
	
	if(document.forms[0].flag_grid4.value == "Y"){
		alert("한 로우만 생성할 수 있습니다.");
		
		return;
	}
	
	GridObj_4.addRow(newId,"");
	
	document.forms[0].flag_grid4.value = "Y";
	
	rowCount = GridObj_4.GetRowCount();
	rowIndex = rowCount - 1;
	
	GD_SetCellValueIndex(GridObj_4, rowIndex, typeColIndex,    top);
	GD_SetCellValueIndex(GridObj_4, rowIndex, controlColIndex, middle);
	GD_SetCellValueIndex(GridObj_4, rowIndex, class1ColIndex,  bottom);
	GD_SetCellValueIndex(GridObj_4, rowIndex, addNcyColIndex,  "D");
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_bd_lis1_hidden",
		{
			type      : "M122",
			item_type : bottom, 
			mode      : "getQuery"
		},
		function(arg){
			setClass(rowCount, arg, 'BL');
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
	
	for(i = 0; i < rowCount; i++) {
		areaCodeColValue = GD_GetCellValueIndex(GridObj_5, i, area_code_col);
		
		if(areaCodeColValue == "ALL") {
			document.forms[0].region_flag.value = "A";
			
			alert("구매지역이 ALL 입니다.");
			
			return;
		}
		else {	
			document.forms[0].region_flag.value       = areaCodeColValue;
			document.forms[0].region_flag_count.value = areaCodeColValue.length;
		}
	}
	
	document.forms[0].flag_grid5.value     = "Y";
	document.forms[0].event_location.value = "WG";
	
	top    = document.forms[0].top_code.value;
	middle = document.forms[0].middle_code.value;
	bottom = document.forms[0].bottom_code.value;	
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
	else if(str == 'BR'){
		lineInsertBr();
	}
	else if(str == 'BL'){
		lineInsertBl();
	}
	else if(str == 'WG'){
		lineInsertWg();
	}
}

function CreateTL(){
	var rowCount     = GridObj_1.GetRowCount();
	var rowIndex     = rowCount - 1;
	var matCodeIndex = GridObj_1.getColIndexById("mat_code");
	var useFlagIndex = GridObj_1.getColIndexById("use_flag");
	var matCode      = GD_GetCellValueIndex(GridObj_1, rowIndex, matCodeIndex);
	
	GD_SetCellValueIndex(GridObj_1, rowIndex, useFlagIndex,	"Y");
	
	if(matCode == "" ) {
		alert("대분류 코드는 필수입력사항입니다.");
		
		return;
	}
	
	document.forms[0].flag_grid1.value = "";
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mty_wk_ins1",
		{
			type      : "M040",
			item_type : matCode, 
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
	var rowCount      = GridObj_2.GetRowCount();
	var rowIndex      = rowCount - 1;
	var contCodeIndex = GridObj_2.getColIndexById("cont_code");
	var matName1Index = GridObj_2.getColIndexById("mat_name1");
	var useFlagIndex  = GridObj_2.getColIndexById("use_flag");
	var matCodeIndex  = GridObj_2.getColIndexById("mat_code");
	var contCode      = GD_GetCellValueIndex(GridObj_2, rowIndex, contCodeIndex);
	var matName1      = GD_GetCellValueIndex(GridObj_2, rowIndex, matName1Index);
	var topCode       = document.forms[0].top_code.value;
	
	GD_SetCellValueIndex(GridObj_2, rowIndex, useFlagIndex,	"Y");
	GD_SetCellValueIndex(GridObj_2, rowIndex, matCodeIndex,	topCode);
	
	if(contCode == "" ) {
		alert("중분류코드는 필수입력사항입니다.");
		
		return;
	}
	
	if(matName1 == "" ) {
		alert("중분류명은 필수입력사항입니다.");
		
		return;
	}
	
	document.forms[0].flag_grid2.value = "";
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mct_wk_ins1",
		{
			control      : "<%=control %>",
			item_control : contCode, 
			mode         : "getQuery"
		},
		function(arg){
			Save(arg, "TR");
		}
	);
}

function createBr(){
	var rowCount      = GridObj_3.GetRowCount();
	var rowIndex      = rowCount - 1;
	var locColIndex   = GridObj_3.getColIndexById("loc");
	var classColIndex = GridObj_3.getColIndexById("class");
	var useColIndex   = GridObj_3.getColIndexById("use");
	var locColValue   = GD_GetCellValueIndex(GridObj_3, rowIndex, locColIndex);
	var calssColValue = GD_GetCellValueIndex(GridObj_3, rowIndex, classColIndex);
	
	GD_SetCellValueIndex(GridObj_3, rowIndex, useColIndex,	"Y");
	
	if(locColValue == ""){
		alert("소분류명은 필수입력사항입니다.");
		
		return;
	}
	
	document.forms[0].flag_grid3.value = "";
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_wk_ins1",
		{
			class1     : "<%=class1 %>",
			item_class : calssColValue, 
			mode       : "getQuery"
		},
		function(arg){
			Save(arg, "BR");
		}
	);
}

function createBl(){
	var rowCount       = GridObj_4.GetRowCount();
	var rowIndex       = rowCount - 1;
	var locColIndex    = GridObj_4.getColIndexById("loc");
	var class2ColIndex = GridObj_4.getColIndexById("class2");
	var locColValue    = GD_GetCellValueIndex(GridObj_4, rowIndex, locColIndex);
	var item_class     = GD_GetCellValueIndex(GridObj_4, rowIndex, class2ColIndex);
		
	if(locColValue == ""){
		alert("세분류명은 필수입력사항입니다.");
		
		return;
	}
	
	document.forms[0].flag_grid4.value = "";
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.material.mcl_wk_ins2",
		{
			mclass2     : "<%=class2 %>",
			item_class : item_class, 
			mode       : "getQuery"
		},
		function(arg){
			Save(arg, "BL");
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
		else if(str == 'BR'){
			createBr();
		}
		else if(str == 'BL'){
			createBl();
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
	var matCodeColIndex  = GridObj_1.getColIndexById("mat_code");
	var matName1ColIndex = GridObj_1.getColIndexById("mat_name1");
	var checkColIndex    = GridObj_1.getColIndexById("Check");
	var matCode          = null;
	var matName1         = null;
	var checkColValue    = null;
	
	for(i = 0; i < rowCount; i++){
		checkColValue = GD_GetCellValueIndex(GridObj_1, i, checkColIndex);
		
		if(checkColValue == true){
			matCode  = GD_GetCellValueIndex(GridObj_1, i, matCodeColIndex);
			matName1 = GD_GetCellValueIndex(GridObj_1, i, matName1ColIndex);
			
			if(matCode == ""){
				alert("대분류코드를 입력하세요.");
				
				return;
			}
			
			if(matName1 == ""){
				alert("대분류명을 입력하세요.");
				
				return;
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_1, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_upd1";
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
	var checkColIndex    = GridObj_2.getColIndexById("Check");
	var matName1ColIndex = GridObj_2.getColIndexById("mat_name1");
	var checkColValue    = null;
	var matName1ColValue = null;
	
	for(i = 0; i < rowCount; i++) {
		checkColValue = GD_GetCellValueIndex(GridObj_2, i, checkColIndex);
		
		if(checkColValue == true) {
			matName1ColValue = GD_GetCellValueIndex(GridObj_2, i, matName1ColIndex);
			
			if(matName1ColValue == ""){
				alert("중분류명을 입력하세요.");
				
				return;					
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_2, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mct_upd1";
	var params;
	
	inputParam = "type=<%=control%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}

function changeBr(){
	var rowCount         = GridObj_3.GetRowCount();
	var i                = 0;
	var checkColIndex    = GridObj_3.getColIndexById("check");
	var locColIndex      = GridObj_3.getColIndexById("loc");
	var checkColValue    = null;
	var locColValue      = null;
	
	for(i = 0; i < rowCount; i++) {
		checkColValue = GD_GetCellValueIndex(GridObj_3, i, checkColIndex);
		
		if(checkColValue == true) {
			locColValue = GD_GetCellValueIndex(GridObj_3, i, locColIndex);
			
			if(locColValue == ""){
				alert("소분류명을 입력하세요.");
				
				return;
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_3, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_3_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_upd1";
	var params;
	
	inputParam = "mclass1=<%=class1%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_3_sendTransactionGrid();
}

function changeBl(){
	var i             = 0;
	var rowCount      = GridObj_4.GetRowCount();
	var checkColIndex = GridObj_4.getColIndexById("check");
	var locColIndex   = GridObj_4.getColIndexById("loc");
	var checkColValue = null;
	var locColValue   = null;
	
	for(i = 0; i < rowCount; i++) {
		checkColValue = GD_GetCellValueIndex(GridObj_4, i, checkColIndex);
		
		if(checkColValue == true){
			locColValue = GD_GetCellValueIndex(GridObj_4, i, locColIndex);
			
			if(locColValue == ""){
				alert("세분류명을 입력하세요.");
				
				return;
			}
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_4, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_upd2";
	var params;
	
	inputParam = "mclass2=<%=class2%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_4_sendTransactionGrid();
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
	else if(str == "BR"){
		changeBr();
	}
	else if(str == "BL"){
		changeBl();
	}
	
	document.forms[0].event_location.value = str;
}

function SaveTl(){
	var grid_array = getGridChangedRows(GridObj_1, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_ins1";
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
	var grid_array = getGridChangedRows(GridObj_2, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mct_ins1";
	var params;
	
	inputParam = "type=<%=control%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}

function saveBr(){
	var grid_array = getGridChangedRows(GridObj_3, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_3_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_ins1";
	var params;
	
	inputParam = "mclass1=<%=class1%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_3_sendTransactionGrid();
}

function saveBl(){
	var grid_array = getGridChangedRows(GridObj_4, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_ins2";
	var params;
	
	inputParam = "mclass2=<%=class2%>";
	
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
		SaveTl();
	}
	else if(str == "TR"){
		saveTr();
	}
	else if(str == "BR"){
		saveBr();
	}
	else if(str == "BL"){
		saveBl();
	}
}

function DeleteTl(){
	var rowCount         = GridObj_1.GetRowCount();
	var i                = 0;
	var matCodeColIndex  = GridObj_1.getColIndexById("mat_code");
	
	for(i = 0; i < rowCount; i++){
		var matCode  = GD_GetCellValueIndex(GridObj_1, i, matCodeColIndex);
		
		if(matCode == ""){
			alert("대분류코드를 입력하세요.");
			
			return;
		}
	}
	
	var grid_array = getGridChangedRows(GridObj_1, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_1_getColIds();
	var servletURL = "/servlets/admin.basic.material.mty_del1";
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
	var grid_array = getGridChangedRows(GridObj_2, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_2_getColIds();
	var servletURL = "/servlets/admin.basic.material.mct_del1";
	var params;
	
	inputParam = "type=<%=control%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_2_sendTransactionGrid();
}

function deleteBr(){
	var grid_array = getGridChangedRows(GridObj_3, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_3_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_del1";
	var params;
	
	inputParam = "mclass1=<%=class1%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_3_sendTransactionGrid();
}

function deleteBl(){
	var grid_array = getGridChangedRows(GridObj_4, "check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var servletURL = "/servlets/admin.basic.material.mcl_del2";
	var params;
	
	inputParam = "mclass2=<%=class2%>";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=doData";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	myDataProcessor = new dataProcessor(servletURL + "?" + params);
	
	GridObj_4_sendTransactionGrid();
}

function deleteWg(){
	var grid_array = getGridChangedRows(GridObj_5, "Check");
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_5_getColIds();
	var servletURL = "/servlets/admin.basic.material.maa_del1";
	var params;
	var item_class2   = document.forms[0].detail_code.value;
	
	inputParam = "item_class2=" + item_class2;
	
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
	else if(str == "BR"){
		deleteBr();
	}
	else if(str == "BL"){
		deleteBl();
	}
	else if(str == "WG"){
		deleteWg();
	}
	
	document.forms[0].event_location.value = str;
}

function check_flag222222(gridNm, result) {
	var wise = gridNm;
	var type = "<%=type %>";

	if(result == "Y") {
		var anw = confirm("정말로 삭제하시겠습니까?");
		if(anw == true) {
			servletURL = "/servlets/admin.basic.material.mty_del1";
			GridObj1.SetParam("type", type);
			GridObj1.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj1.SendData(servletURL, "ALL", "ALL");
		}else return;
	}else alert("하위코드가 있으므로 삭제할 수 없습니다. ");
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

function oneSelect2(max_row, msg1, msg2) {
	var noSelect = "";
	if (GridObj2.GetRowCount() == 0) {
		alert('선택된 데이터가 없습니다.');
		return;
	}
	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj2,msg2,"0") == "false") 
		noSelect = "Y";
	
	for(var i=0;i<max_row;i++)  {
     	GD_SetCellValueIndex(GridObj2,i,"0","false", "&");
    }
	
   	if(msg1 != "t_header" && noSelect != "Y")
   		GD_SetCellValueIndex(GridObj2,msg2,"0","true", "&");
   	
   	Select2();
}

function oneSelect3(max_row, msg1, msg2) {
	var noSelect = "";
	if (GridObj3.GetRowCount() == 0) {
		alert('선택된 데이터가 없습니다.');
		return;
	}
	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj3,msg2,"0") == "false") 
		noSelect = "Y";
	
	for(var i=0;i<max_row;i++)  {
     	GD_SetCellValueIndex(GridObj3,i,"0","false", "&");
    }
	
   	if(msg1 != "t_header" && noSelect != "Y")
   		GD_SetCellValueIndex(GridObj3,msg2,"0","true", "&");
   	
   	Select3();
}

function oneSelect4(max_row, msg1, msg2) {
	if (GridObj_4.GetRowCount() == 0) {
		alert('데이터가 없습니다.');
		
		return;
	}
	
   	Select4();
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
 			}else if(document.forms[0].event_location.value == "BR"){
 				alert(GridObj3.Getmessage()); 				
 				goDown();
 			}else if(document.forms[0].event_location.value == "BL"){
 				alert(GridObj4.Getmessage());
 				goLeft(); 				
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
	var gridObj_1_IndexColCheck   = GridObj_1.getColIndexById("Check");
	var gridObj_1_IndexColAddNcy  = GridObj_1.getColIndexById("add_ncy");
	var gridObj_1_IndexColMatCode = GridObj_1.getColIndexById("mat_code");
	var gridObj_1_ValueColCheck   = null;
	var gridObj_1_ValueColAddNcy  = null;
	
	if(gridObj_1_rowCount > 0){
		for(i = 0; i < gridObj_1_rowCount; i++){
			gridObj_1_ValueColCheck   = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColCheck);
			gridObj_1_ValueColAddNcy  = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColAddNcy);
			
			
			if(gridObj_1_ValueColCheck == true){
				if(gridObj_1_ValueColAddNcy == 'Y'){
					value++;
					
					code = GD_GetCellValueIndex(GridObj_1, i, gridObj_1_IndexColMatCode);
				}
				else{
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
		
		var servletURL = "/servlets/admin.basic.material.mct_lis1";
		var params     = GridObj_2_doSelectParams(type, code);
		
		GridObj_2.post(servletURL, params);
		GridObj_2.clearAll(false);
		GridObj_3.clearAll(false);
		GridObj_4.clearAll(false);
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

function GridObj_3_doSelectParams(item_type, code){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_3_getColIds();
	var params;
	
	inputParam = "item_type=" + item_type;
	inputParam = inputParam + "&item_control=" + code;
	inputParam = inputParam + "&class1=M042";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=getQuery";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

//중분류를 선택하여 소분류를 조회한다.(상위 --> 하위)
function goDown(){
	var wise2                      = GridObj_2;
	var wise3                      = GridObj_3;
	var item_type                  = "";
	var value                      = 0;
	var code                       = "";
	var gridObj_2_rowCount         = GridObj_2.GetRowCount();
	var i                          = 0;
	var gridObj_2_IndexColCheck    = GridObj_2.getColIndexById("Check");
	var gridObj_2_IndexColAddNcy   = GridObj_2.getColIndexById("add_ncy");
	var gridObj_2_IndexColMatCode  = GridObj_2.getColIndexById("mat_code");
	var gridObj_2_IndexColContCode = GridObj_2.getColIndexById("cont_code");
	var gridObj_2_ValueColCheck    = false;
	var gridObj_2_ValueColAddNcy   = null;
	
	if(gridObj_2_rowCount <= 0){
		alert("중분류가 없습니다.");
		
		return;
 	}
	
	for(i = 0; i < gridObj_2_rowCount; i++){
		gridObj_2_ValueColCheck = GD_GetCellValueIndex(GridObj_2, i, gridObj_2_IndexColCheck);
		
		if(gridObj_2_ValueColCheck == true){
			gridObj_2_ValueColAddNcy = GD_GetCellValueIndex(GridObj_2, i, gridObj_2_IndexColAddNcy);
			
			if(gridObj_2_ValueColAddNcy == 'Y'){
				value++;
					
				item_type = GD_GetCellValueIndex(GridObj_2, i, gridObj_2_IndexColMatCode); //대분류의 값을 가지고 온다.
				code      = GD_GetCellValueIndex(GridObj_2, i, gridObj_2_IndexColContCode); //중분류의 값을 가지고 온다.	
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
	
	document.forms[0].middle_code.value = code;
	document.forms[0].flag_grid3.value = "";
	
	var servletURL = "/servlets/admin.basic.material.mcl_lis1";
	var params     = GridObj_3_doSelectParams(item_type, code);
	
	GridObj_3.post(servletURL, params);
	GridObj_3.clearAll(false);
	GridObj_4.clearAll(false);
<%
	if(!"Y".equals(app_flag)){
%>  
	GridObj_5.clearAll(false);
<%
	}
%>
}

function GridObj_4_doSelectParams(item_type, item_control, item_class1){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_4_getColIds();
	var params;
	
	inputParam = "item_type=" + item_type;
	inputParam = inputParam + "&item_control=" + item_control;
	inputParam = inputParam + "&item_class1=" + item_class1;
	inputParam = inputParam + "&mclass2=M122";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=getQuery";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

//소분류를 선택하여 세분류를 조회한다.(오른쪽 --> 왼쪽)
function goLeft(){
	var item_type       = "";
	var item_control    = "";
	var item_class1     = "";
	var value           = 0;
	var rowCount        = GridObj_3.GetRowCount();
	var checkColIndex   = GridObj_3.getColIndexById("check");
	var checkColValue   = null;
	var addNcyColIndex  = GridObj_3.getColIndexById("add_ncy");
	var addNcyColValue  = null;
	var typeColIndex    = GridObj_3.getColIndexById("type");
	var controlColIndex = GridObj_3.getColIndexById("control");
	var classColIndex   = GridObj_3.getColIndexById("class");
	
	if(rowCount <= 0){
		alert("소분류가 없습니다.");
		
		return;
	}
	
	for(var i = 0; i < rowCount; i++){
		checkColValue = GD_GetCellValueIndex(GridObj_3, i, checkColIndex);
		
		if(checkColValue == true){
			addNcyColValue = GD_GetCellValueIndex(GridObj_3, i, addNcyColIndex);
			
			if(addNcyColValue == 'Y'){
				value++;
				
				item_type    = GD_GetCellValueIndex(GridObj_3, i, typeColIndex); //대분류의 값을 가지고 온다.	
				item_control = GD_GetCellValueIndex(GridObj_3, i, controlColIndex); //중분류의 값을 가지고 온다.
				item_class1  = GD_GetCellValueIndex(GridObj_3, i, classColIndex); //소분류의 값을 가지고 온다.
			}
			else{
				alert("등록 후 선택하여주세요.");
				
				return;					
			}
		}
	}
	
	if(value == 0){
		alert("소분류를 선택하세요.");
		
		return;
	}
	else if(value > 1){
		alert("소분류는 하나만 선택할 수 있습니다.");
		
		return;
	}
	
	document.forms[0].bottom_code.value = item_class1;
	document.forms[0].flag_grid4.value = "";
	
	var servletURL = "/servlets/admin.basic.material.mcl_lis2";
	var params     = GridObj_4_doSelectParams(item_type, item_control, item_class1);
	
	GridObj_4.post(servletURL, params);
	GridObj_4.clearAll(false);
<%
	if(!"Y".equals(app_flag)){
%>  
	GridObj_5.clearAll(false);
<%
	}
%>
}

function GridObj_5_doSelectParams(code){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var cols_ids   = GridObj_5_getColIds();
	var params;
	
	inputParam = "item_class2=" + code;
	inputParam = inputParam + "&ctrl_type=P";
	
	
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
	var rowCount       = GridObj_4.GetRowCount();
	var i              = 0;
	var checkColIndex  = GridObj_4.getColIndexById("check");
	var addNcyColIndex = GridObj_4.getColIndexById("add_ncy");
	var class2ColIndex = GridObj_4.getColIndexById("class2");
	var checkColValue  = null;
	var addNcyColValue = null;
	
	if(document.forms[0].top_code.value == ""){
		alert("대분류를 선택하세요");
		
		return;
	}
	
	if(document.forms[0].middle_code.value == ""){
		alert("중분류를 선택하세요");
		
		return;
	}
	
	if(document.forms[0].bottom_code.value == ""){
		alert("소분류를 선택하세요");
		
		return;
	}
	
	if(rowCount <= 0){
		alert("세분류가 없습니다.");
		
		return;
	}
	
	for(i = 0; i < rowCount; i++){
		checkColValue = GD_GetCellValueIndex(GridObj_4, i, checkColIndex);
		
		if(checkColValue == true){
			addNcyColValue = GD_GetCellValueIndex(GridObj_4, i, addNcyColIndex);
			
			if(addNcyColValue == 'Y'){
				value++;
				
				code = GD_GetCellValueIndex(GridObj_4, i, class2ColIndex);
			}
			else{
				alert("등록 후 선택하여주세요.");
				
				return;					
			}
		}
	}
	
	if(value == 0){
		alert("세분류를 선택하세요.");
		
		return;
	}
	else if(value > 1){
		alert("세분류는 하나만 선택할 수 있습니다.");
		
		return;
	}

	document.forms[0].detail_code.value = code;
	document.forms[0].flag_grid5.value  = "";
	
	var servletURL = "/servlets/admin.basic.material.maa_lis1";
	var params     = GridObj_5_doSelectParams(code);
	
	GridObj_5.post(servletURL, params);
	GridObj_5.clearAll(false);
}

function Select2(){
	var selected = 0;
	for(i = 0; i < GridObj2.GetRowCount(); i++)
	{
	    if(GD_GetCellValueIndex(GridObj2, i, INDEX_SEL)=="true")
	    {
	        var value1 = GridObj2.GetCellValue("mat_code", i);
	        var value2 = GridObj2.GetCellValue("cont_code", i);
	        var value3 = '';
	        var value4 = '';
	        var value5 = GridObj2.GetCellValue("mat_name1", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    return;
	}else{
	    alert("선택되었습니다.");
	    parent.parent.opener.Category(value1,value2,value3,value4,value5,value6);
	    parent.parent.close();
	}
}

function Select3(){
	var selected = 0;
	for(i = 0; i < GridObj3.GetRowCount(); i++)
	{
	    if(GD_GetCellValueIndex(GridObj3, i, INDEX_SEL)=="true")
	    {
	        var value1 = GridObj3.GetCellValue("type", i);
	        var value2 = GridObj3.GetCellValue("control", i);
	        var value3 = GridObj3.GetCellValue("class", i);
	        var value4 = '';
	        var value5 = GridObj3.GetCellValue("loc", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    return;
	}else{
	    alert("선택되었습니다.");
	    parent.parent.opener.Category(value1,value2,value3,value4,value5,value6);
	    parent.parent.close();
	}
}

function Select4(){
	var selected      = 0;
	var checkColIndex = GridObj_4.getColIndexById("check");
	
	for(i = 0; i < GridObj_4.GetRowCount(); i++){
	    if(GD_GetCellValueIndex(GridObj_4, i, checkColIndex) == true){
	        var value1 = GridObj_4.GetCellValue("type", i);
	        var value2 = GridObj_4.GetCellValue("control", i);
	        var value3 = GridObj_4.GetCellValue("class1", i);
	        var value4 = GridObj_4.GetCellValue("class2", i);
	        var value5 = GridObj_4.GetCellValue("loc", i);
	        var value6 = '';
	        selected ++;
	    }
	}
	
	if(selected == 0){
		alert("데이터를 선택하셔야 합니다.");
	    
	    return;
	}
	else if(selected >1){
	    alert("한개만 선택하셔야 합니다.");
	    
	    return;
	}
	else{
	    opener.Category(value1,value2,value3,value4,value5,value6);
	    
	    alert("선택되었습니다.");
	    
	    window.close();
	}
}

function setClass(idx, item_control, str) {	
	if(str == "TR"){
		var contCodeColIndex = GridObj_2.getColIndexById("cont_code");
		
		GD_SetCellValueIndex(GridObj_2, idx - 1, contCodeColIndex, item_control);	
	}
	else if(str == "BR"){
		var classColIndex = GridObj_3.getColIndexById("class");
		
		GD_SetCellValueIndex(GridObj_3, idx - 1, classColIndex, item_control);
	}
	else if(str == "BL"){
		var class2ColIndex = GridObj_4.getColIndexById("class2");
		
		GD_SetCellValueIndex(GridObj_4, idx - 1, class2ColIndex, item_control);
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
	var grid_array      = getGridChangedRows(GridObj_1, "Check");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_1.getColIndexById("Check");
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
		gridObj_1Cell = GridObj_1.cells(gridArrayInfo, checkColIndex);
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
	var grid_array      = getGridChangedRows(GridObj_2, "Check");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_2.getColIndexById("Check");
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
function GridObj_3_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_3_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_3.cells(rowId, cellInd).getValue();
	
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
function GridObj_3_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_3_message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		
		goDown();
	}
	
	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_3_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_3.clearAll();
		GridObj_3.setCSVDelimiter("\t");
		GridObj_3.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_3_doQueryEnd() {
	var msg        = GridObj_3.getUserData("", "message");
	var status     = GridObj_3.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

function GridObj_3_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_3, "check");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_3.getColIndexById("check");
	var GridObj_3Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_3);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_3_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		GridObj_3Cell = GridObj_3.cells(gridArrayInfo, checkColIndex);
		checked       = GridObj_3Cell.getValue();

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

	GridObj_3_doQueryDuring();
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
		goLeft();
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
	var grid_array      = getGridChangedRows(GridObj_4, "check");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_4.getColIndexById("check");
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

	GridObj_4_doQueryDuring();
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
	var grid_array      = getGridChangedRows(GridObj_5, "Check");
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_5.getColIndexById("Check");
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
<% if("".equals(top_code)){ %>
<script language="javascript">
btn("javascript:goRight()", "조 회");
</script>
<% } %>
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
				    <% if("".equals(top_code)){ %>
					<a href="javascript:goRight()">
						<img src="/images/hwasalpyo_right.png" border="0" width="27px" height="31px" />
					</a>
					<% } %>
				</td>
				<td align="center" valign="top">
					<div id="gridbox_2" name="gridbox_2" width="100%" style="background-color:white;"></div>
				</td>
			</tr>
			<tr>
				<td height="40px" colspan="2"></td>
				<td align="center" valign="middle">
					<% if("".equals(middle_code)){ %>
					<a href="javascript:goDown()">
						<img src="/images/hwasalpyo_down.png" border="0" width="27px" height="31px" />
					</a>
					<% } %>
				</td>
			</tr>
			<tr>
				<td align="right">
					<TABLE cellpadding="0">
						<TR>
<%
	if("Y".equals(app_flag)){
%>
							<TD>
<script language="javascript">
btn("javascript:goLeft()", "조 회");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:oneSelect4()", "선 택");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:window.close()", "닫 기");
</script>
							</TD>
<%
	}
	else{
%>
							<TD>
<script language="javascript">
btn("javascript:Line_insert(GridObj_4, 'BL')", "행삽입");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Create(GridObj_4, 'BL')", "등 록");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Change(GridObj_4, 'BL')", "수 정");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Delete(GridObj_4, 'BL')", "삭 제");
</script>
							</TD>
<%
	}
%>
						</TR>
					</TABLE>	    
				</td>
				<td></td>
				<td align="right">
					<TABLE cellpadding="0">
						<TR>
<%
	if("Y".equals(app_flag)){
%>
							<TD>
<% if("".equals(middle_code)){ %>
<script language="javascript">
btn("javascript:goDown()", "조 회");
</script>
<% } %>
							</TD>
<%
	}
	else{
%>
							<TD>
<script language="javascript">
btn("javascript:Line_insert(GridObj_3, 'BR')", "행삽입");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Create(GridObj_3, 'BR')", "등 록");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Change(GridObj_3, 'BR')", "수 정");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:Delete(GridObj_3, 'BR')", "삭 제");
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
					<div id="gridbox_4" name="gridbox_4" width="100%" style="background-color:white;"></div>
				</td>
				<td align="center">
					<a href="javascript:goLeft()">
						<img src="/images/hwasalpyo_left.png" border="0" width="27px" height="31px" />
					</a>
				</td>
				<td align="center">
					<div id="gridbox_3" name="gridbox_3" width="100%" style="background-color:white;"></div>
				</td>
			</tr>
<%
	if(!"Y".equals(app_flag)){
%>    
			<tr style="display: none;">
				<td colspan="3" align="center" valign="bottom" height="50px">
					<a href="javascript:goWorkItem();">
						<img src="/images/hwasalpyo_down.png" border="0" width="27px" height="31px" />
					</a>
				</td>
			</tr>
			<tr style="display: none;">
				<td colspan="3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>  	
							<td height="30" align="right">
								<TABLE cellpadding="0">
									<TR>
										<TD>
<script language="javascript">
btn("javascript:Line_insert(GridObj_5, 'WG')", "행삽입");
</script>
										</TD>
										<TD>
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
					</table>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="1" class="cell"></td>
						</tr>
						<tr>
							<td align="center">
								<div id="gridbox_5" name="gridbox_5" width="100%" style="background-color:white;"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>    
<%
	}
%>
    
		</table>
	</form>
	<iframe name="workFrm" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</s:header>
<s:footer/>
</body>
</html>