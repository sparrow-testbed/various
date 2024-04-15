<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector  multilang_id = new Vector();
	HashMap text         = null;

	multilang_id.addElement("AD_133");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
    text = MessageUtil.getMessage(info,multilang_id);

	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String sign_status = JSPUtil.CheckInjection(JSPUtil.paramCheck(request.getParameter("sign_status")));
	String gubun       = JSPUtil.CheckInjection(JSPUtil.paramCheck(request.getParameter("gubun")));
	boolean is_buyer = true;
	String display="style='display: none'";
	String disPlay2="";
	
	if(info.getSession("USER_TYPE").equals("S") || info.getSession("USER_TYPE").equals("P")){
		is_buyer = false;
	}

	String screen_id = "AD_133";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = true; //일반 조회용 화면 true, 데이터 처리용 화면은 false
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/pwdPolicy.js"></script>
<script language="javascript">
var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.user_status";
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
    <%=grid_obj%>_setGridDraw();
    GridObj.setSizes();
}

function doOnRowSelected(rowId,cellInd){
    if(GridObj.getColIndexById("MENU_PROFILE_CODE") == cellInd){
		var user_tto = "<%=info.getSession("USER_TYPE")%>";

		if(user_tto == "S" || user_tto == "P"){
			return;
		}

		document.forms[0].scol.value = cellInd;
		document.forms[0].srow.value = rowId;
		
		if("<%=sign_status%>"== "R"){
			url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP7099&function=Setprofile&values=1";
			
			Code_Search(url,'','','','','');
		}
	}
}

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

function doDeleteRow(){
    var rowcount = dhtmlx_end_row_id;

    for(var row = rowcount - 1; row >= dhtmlx_start_row_id; row--){
        if("1" == GridObj.cells(GridObj.getRowId(row), 0).getValue()){
            GridObj.deleteRow(GridObj.getRowId(row));
        }
    }
}

function init(){
	f                      = document.form;
	f.i_company_code.value = "<%=info.getSession("COMPANY_CODE")%>";

	if("<%=info.getSession("USER_TYPE")%>" == "S" || "<%=info.getSession("USER_TYPE")%>" == "P"){
		for(var i = 0; i < f.i_user_type.length; i++){
			if(f.i_user_type.options[i].value == "<%=info.getSession("USER_TYPE")%>"){
				f.i_user_type.selectedIndex = i;
				f.i_user_type.disabled = true;
			}
		}

		f.i_company_code.value = "<%=info.getSession("COMPANY_CODE")%>";
	}
}

function doSelect(){
	var f = document.forms[0];
	var wise = document.WiseGrid;

	f.i_company_code.value = f.i_company_code.value.toUpperCase();
	var i_company_code  = f.i_company_code.value;
	f.i_dept.value      = f.i_dept.value.toUpperCase();
	var i_dept          = f.i_dept.value;
	f.i_user_id.value   = f.i_user_id.value.toUpperCase();
	var i_user_id       = f.i_user_id.value;
	var i_user_name_loc = f.i_user_name_loc.value;
	var i_user_type     = f.i_user_type.value;
	var i_work_type     = f.i_work_type.value;

	if(i_user_id == ""){
		f.text_user_name.value = "";
	}
	
	if(document.form.i_user_type.value!="S"){
		if(document.form.i_dept.value=="" && document.form.i_user_name_loc.value==""){
			alert("부서 또는 사용자명을 입력하세요");
			return;
		}
	}
	f.dept_usedpopup.value = "off";
	f.id_usedpopup.value = "off";

    var grid_col_id = "<%=grid_col_id%>";
    var url = G_SERVLETURL;
    var params = "mode=query&grid_col_id="+grid_col_id+"&i_user_id=" + encodeUrl(i_user_id) + "&i_user_name_loc=" + encodeUrl(i_user_name_loc) +
                  "&i_company_code=" + encodeUrl(i_company_code) + "&i_dept=" + encodeUrl(i_dept) + "&i_sign_status=" + encodeUrl("<%=sign_status%>") +
                  "&i_user_type=" + encodeUrl(i_user_type) + "&i_work_type=" + encodeUrl(i_work_type) + "&grid_col_id=" + encodeUrl(grid_col_id);
    
    GridObj.post(url,params);
    GridObj.clearAll(false);
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows(){
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0){
		return true;
	}

	alert("<%=text.get("AD_133.MSG_0100")%>");
	
	return false;
}

function Change(){
	var gridArray = getGridChangedRows(GridObj, "SELECTED");
	var selRowCnt = gridArray.length;
	var i         = 0;
	var dim       = ToCenter('600','800');
	var top       = dim[0];
	var left      = dim[1];
	var selUserId = null;
	
	if(selRowCnt == 0) {
	    alert("<%=text.get("AD_133.MSG_0109")%>");
	    
	    return;
	}
	else if(selRowCnt > 1) {
	    alert("<%=text.get("AD_133.MSG_0110")%>");
	    
	    return;
	}
	
	for(i = 0; i < selRowCnt; i++){
		selUserId = SepoaGridGetCellValueId(GridObj, gridArray[i], "USER_ID");
	}
	
	window.open("user_status_pop_up.jsp?i_flag=N&i_user_id=" + selUserId, "BKW33in", "top=" + top+",left=" + left + ",width=800,height=430,resizable=yes,status=yes,scrollbars=yes");
}

<%-- 선택된 항목의 세부사항을 보여준다.--%>
function doDisplay(){
	if(!checkRows()){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	<%-- 변경할 항목을 선택했는지 체크하고 여러개가 선택되었으면 가장 위의 항목에 대한 변경화면으로 이동한다. --%>
	for(var i = 0; i < grid_array.length; i++){
		sel_row += i + "&";

		dim = ToCenter('600','800');
		var top = dim[0];
		var left = dim[1];

		winobj = window.open("use_bd_dis2.jsp?i_user_id="+SepoaGridGetCellValueId(GridObj, grid_array[i],"USER_ID"),"BKWin","top="+top+",left="+left+",width=810,height=520,resizable=yes,status=yes,scrollbars = yes");

		break;
	}
}


function checkcode(grid_array){
	var rtn = false;

	for(var i = 0; i < grid_array.length; i++){
		if(SepoaGridGetCellValueId(GridObj, grid_array[i], "MENU_PROFILE_CODE") == ""){
			rtn = true;
		}
	}

	return rtn;
}

<%-- 사용자 승인 --%>
function doApproval(){
	if(!checkRows()){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(checkcode(grid_array)){
		alert("<%=text.get("AD_133.MSG_0102")%>");
		
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	
    myDataProcessor = new dataProcessor(G_SERVLETURL + "?cols_ids=" + cols_ids + "&mode=doApproval");
    
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

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

	if(status == "true"){
		alert(messsage);
		doSelect();
	}
	else{
		alert(messsage);
		
		return;
	}

	return false;
}


<%-- 사용자 삭제--%>
function doDelete(mode){
	var grid_array    = getGridChangedRows(GridObj, "SELECTED");
	var iCheckedCount = grid_array.length;

	if(iCheckedCount < 1){
		alert("<%=text.get("AD_133.MSG_0103")%>");
		return;
	}

	if(!confirm("<%=text.get("AD_133.MSG_0104")%>")){
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	
    myDataProcessor = new dataProcessor(G_SERVLETURL + "?cols_ids=" + cols_ids + "&mode=delete" );
    
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doQueryEnd(GridObj, RowCnt){
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");
    var data_type  = GridObj.getUserData("", "data_type");

    if(status == "false"){
    	alert(msg);
    }
    
    return true;
}

function Setprofile(code,name){
	var col = document.forms[0].scol.value;
	var row = document.forms[0].srow.value;
	
	SepoaGridSetCellValueId(GridObj, row, "MENU_PROFILE_CODE", code);
}

<%--팝업화면.--%>
function getDept(code, text) {
	document.forms[0].i_dept.value = code;
	document.forms[0].text_depart.value = text;
	document.forms[0].dept_usedpopup.value = "on";
}

function SP9112_getCode(id,  name, dept ) {
	document.forms[0].i_user_id.value = id;
	document.forms[0].i_user_name_loc.value = name;
	document.forms[0].id_usedpopup.value = "on";
}

function SP9118_getCode(id,  name, dept ) {
	document.forms[0].i_user_id.value = id;
	document.forms[0].i_user_name_loc.value = name;
	document.forms[0].id_usedpopup.value = "on";
}

function getPartner_code(code,text, type) {
	document.forms[0].i_company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].i_company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function searchProfile(fc){
	var url = "";
	
	if( fc == "i_company_code" ){
		if (document.forms[0].edit.value == "N") {
			return;
		}

		if (document.forms[0].i_user_type.value  == ""){
			alert("<%=text.get("AD_133.MSG_0105")%>");
			
			return;
		}

		if (document.forms[0].i_user_type.value  == "P"){
			url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

		}
		else if (document.forms[0].i_user_type.value  == "S"){
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}
	
	if(fc == "i_dept") {
		if (document.forms[0].i_user_type.value  == "P" || document.forms[0].i_user_type.value  == "S"){
			url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getDept&values=<%=house_code%>&values=M105&values=&values=/&desc=code&desc=name";
		}
		else {
			if(document.forms[0].i_company_code.value == "") {
				alert("<%=text.get("AD_133.MSG_0106")%>");
				
				return;
			}
			else {
				window.open("/common/CO_009.jsp?callback=getDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
			}
		}
	}
	if (fc == "i_user_id")  {
		if(document.forms[0].i_company_code.value == "") {
			alert("회사코드를 입력해주세요");
			<%-- alert("<%=text.get("AD_133.MSG_0107")%>"); --%>
			
			return;
		}
		if(document.form.i_user_type.value!="S"){
			if(document.forms[0].i_dept.value == "") {
				alert("<%=text.get("AD_133.MSG_0108")%>");
				document.forms[0].i_dept.focus();
				return;
			}
			<%-- var arrValue = new Array();
			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = document.forms[0].i_company_code.value;
			arrValue[2] = document.forms[0].i_dept.value;
			arrValue[3] = "";
			arrValue[4] = "";
			var arrDesc  = new Array();
			arrDesc[0] = "아이디";
			arrDesc[1] = "이름";
			arrDesc[2] = "";
			arrDesc[3] = ""; --%>
			window.open("/common/CO_010.jsp?callback=SP9112_getCode&deptCd="+document.forms[0].i_dept.value+"&companyCd="+document.forms[0].i_company_code.value, "SP9112", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
			/* window.open("/common/CO_010.jsp?callback=getDept&deptCd="+document.forms[0].i_dept.value+"&companyCd="+document.forms[0].i_company_code.value, "SP9112", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0"); */
			//PopupCommonArr("SP9112","SP9112_getCode", arrValue,arrDesc);
		}else{
			<%-- var arrValue = new Array();
			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = document.forms[0].i_company_code.value;
			arrValue[2] = "";
			arrValue[3] = "";
			var arrDesc  = new Array();
			arrDesc[0] = "아이디";
			arrDesc[1] = "이름";
			arrDesc[2] = "";
			arrDesc[3] = "";
			
			PopupCommonArr("SP9118","SP9118_getCode",arrValue,arrDesc); --%>
			window.open("/common/CO_010.jsp?callback=SP9118_getCode&deptCd="+document.forms[0].i_dept.value+"&companyCd="+document.forms[0].i_company_code.value, "SP9118", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
	}

	if ( isNull(url) ) {
	    return ;
	}

	Code_Search(url,'','','','','');
}

function actionedit() {
	i_user_type    = document.forms[0].i_user_type.value;
	text_user_type = document.forms[0].i_user_type.options[document.forms[0].i_user_type.selectedIndex].text;

	if ( i_user_type == "P" || i_user_type == "S" ) {
		document.forms[0].edit.value = "Y";
		document.forms[0].i_company_code.value = "";
		document.forms[0].text_company_code.value = "";
	}
	else {
		document.forms[0].i_company_code.value = i_user_type;
		document.forms[0].text_company_code.value = text_user_type;
		document.forms[0].edit.value = "N";
	}
	userTypeChage();
}

function entKeyDown(){
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}

function isEqualsIdPasswd() {

	return "SUCCESS";
}


function pwdReset(){
	var sel_user_id = "";
	var password    = document.getElementById("password").value;
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");
	var sel_row_cnt = grid_array.length;
	var SERVLETURL  = "";

	if(password == "") {
	    alert("<%=text.get("AD_133.MSG_0113")%>");
	    
	    document.form.password.focus();
	    
	    return;
	}
	
	if(sel_row_cnt == 0) {
	    alert("<%=text.get("AD_133.MSG_0109")%>");
	    
	    return;
	}
	
	if(sel_row_cnt > 1) {
	    alert("<%=text.get("AD_133.MSG_0110")%>");
	    
	    return;
	}

	// 비밀번호 정책 적용체크
	// js/pwdPolicy.js : isNewValidPwd
	if ( !isNewValidPwd('', document.getElementById("password").value) )
	{
		return;
	}

	//사용자 ID, 비밀번호 동일체크
	/* message = isEqualsIdPasswd();
	if(message != "SUCCESS")
	{
			alert(message);
			document.getElementById("password").focus();
			document.getElementById("password").select();
			return;
	} */
	
	for(var i = 0; i < grid_array.length; i++){
		sel_user_id = SepoaGridGetCellValueId(GridObj, grid_array[i], "USER_ID");
	}

<%-- <%
	String pwd = CryptoUtil.getSHA256(KeyboardSecurity.getTouchEnKey(password));
%>	
	document.getElementById("password").value ="<%=pwd%>"; --%>
	if(confirm("<%=text.get("AD_133.MSG_0111")%>")) {
		SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.user_status_re";
		SERVLETURL = SERVLETURL + "?mode=pwdReset";
		SERVLETURL = SERVLETURL + "&cols_ids=<%=grid_col_id%>";
		SERVLETURL = SERVLETURL + "&sel_user_id=" + sel_user_id;
		SERVLETURL = SERVLETURL + "&password=" + password
						
	    myDataProcessor = new dataProcessor(SERVLETURL);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}
function userTypeChage(){
	if(document.form.i_user_type.value!="S"){
		//document.getElementById("hit1").style.display='none';
		//document.getElementById("hit2").style.display='none';
		/*
		document.getElementById("hit3").style.display='block';
		document.getElementById("hit4").style.display='block';
	
		document.form.hit5.width = "15%";
		document.form.hit6.width = "35%";
		document.form.hit6.colspan = "";
	    */
		document.form.i_user_name_loc.value="";
	}else{
		//document.getElementById("hit1").style.display='block';
		//document.getElementById("hit2").style.display='block';
		
		/*
		document.getElementById("hit3").style.display='none';
		document.getElementById("hit4").style.display='none';
		
		document.form.hit5.width = "15%";
		document.form.hit6.width = "85%";
		document.form.hit6.colspan = "3";
		*/
		document.form.i_dept.value="";
		document.form.text_depart.value="";
		document.form.i_user_name_loc.value="";
	}
	 //document.form.hid1.style.display="block";
}
</script>
</head>
<body leftmargin="15" topmargin="6" onload="init();setGridDraw();">
<s:header>
	<form name="form" method="post" action="">
		<input type="hidden" value="" name="scol">
		<input type="hidden" value="" name="srow">
		<input type="hidden" name="edit" value="Y">
		<input type="hidden"  value="off" name="dept_usedpopup">
		<input type="hidden"  value="off" name="id_usedpopup">
<%
    String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));

    if(this_window_popup_flag.trim().length() <= 0){
    	this_window_popup_flag = "false";
    }
%>
		<%@ include file="/include/sepoa_milestone.jsp"%>
		
    	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5"> </td>
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
										<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0100")%></td>
										<td width="35%" class="data_td">
											<select name="i_user_type" id="i_user_type" class="inputsubmit" onChange="actionedit();" >
												<option value=""><%=text.get("AD_133.TEXT_0101")%></option>
<%
	String i_user_type = ListBox(request, "SL0081",info.getSession("HOUSE_CODE")+"#"+info.getSession("HOUSE_CODE")+"#", company_code);

	out.println(i_user_type);
%>
											</select>
										</td>
										<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0102")%></td>
										<td width="35%" class="data_td">
											<select name="i_work_type" id="i_work_type" class="inputsubmit">
												<option value=""><%=text.get("AD_133.TEXT_0101")%></option>
<%
	String i_work_type = ListBox(request, "SL0007",info.getSession("HOUSE_CODE")+ "#M104#", "");

	out.println(i_work_type);
%>
											</select>
										</td>
        	        				</tr>
            	    				<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
              						<tr>              							
              							<td class="title_td" id="hit5"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0104")%></td>
              							<td class="data_td" id="hit6">
              								<input type="text" size="14" name="i_company_code" class="<%=is_buyer ? "inputsubmit" : "input_empty" %>" <%=is_buyer ? "" : "readOnly" %> maxlength="10" onkeydown='entKeyDown()'>
<%
	if(is_buyer){
%>
											<a href="javascript:searchProfile('i_company_code')">
												<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0">
											</a>
<%
	}	 
%>
											<input type="hidden" name="text_company_code" class="input_empty" readonly>
    	          						</td>
    	          						<td class="title_td" id="hit3"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0105")%></td>
              							<td class="data_td" id="hit4">
              								<input type="text" size="10" value="<%=info.getSession("DEPARTMENT")%>" name="i_dept" class="inputsubmit" maxlength="10" onkeydown='entKeyDown()'>
											<a href="javascript:searchProfile( 'i_dept' )">
												<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0">
											</a>
											<input type="text" value="<%=info.getSession("DEPARTMENT_NAME_LOC")%>" name="text_depart" size="10" class="input_empty" readOnly>
        	      						</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
              						<tr>
              							<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0106")%></td>
              							<td width="35%" class="data_td">
              								<input type="text" name="i_user_name_loc" size="20" class="inputsubmit" onkeydown='entKeyDown()'>
              							</td>
              							<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_133.TEXT_0103")%></td>
              							<td width="35%" class="data_td">
              								<input type="text" size="12" value="" name="i_user_id" class="inputsubmit" onkeydown='entKeyDown()'>
											<a href="javascript:searchProfile('i_user_id')">
												<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0">
											</a>
											<input type="hidden" value="" name="text_user_name" size="20" class=input_empty readOnly >
        	      						</td>            	  				              					        	      			
                					</tr>
                				</table>
                			</td>
                		</tr>
            		</table>
            	</td>
            </tr>
		</table>
		<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			<TR>
				<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
						<TR>
							<td height="30" align="right">
<script language="javascript">
btn("javascript:doSelect()", "<%=text.get("BUTTON.search")%>");
</script>
							</td>
<%
	if (sign_status.equals("R")) {
%>
							<td height="30" align="right">
<script language="javascript">
btn("javascript:doApproval()", "<%=text.get("BUTTON.consent")%>");
</script>
							</td>
							<td height="30" align="right">
<script language="javascript">
btn("javascript:doDelete('setDelete')", "<%=text.get("BUTTON.deleted")%>");
</script>
							</td>

<%
	}
	else{
		if (!gubun.equals("M")) {
%>
<%--
							<td height="30" align="right">
 								<%=text.get("AD_133.TEXT_0107")%> : 
								<input type="password" value="" name="password" id="password" size="12" >
							</td>
							<td height="30" align="right">
<script language="javascript">
btn("javascript:pwdReset()", "<%=text.get("BUTTON.Password_Reset")%>");
</script>
							</td>
 --%>							
							<td height="30" align="right">
<script language="javascript">
btn("javascript:Change()", "<%=text.get("BUTTON.update")%>");
</script>
							</td>
							<td height="30" align="right">
<script language="javascript">
btn("javascript:doDelete('setDelete')", "<%=text.get("BUTTON.deleted")%>");
</script>
							</td>
<%
		}
	}
%>
						</TR>
					</TABLE>
				</td>
			</TR>
	</TABLE>
</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>