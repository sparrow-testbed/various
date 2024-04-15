<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_014";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>



<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.code_master_mgt";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
}

function doTypeChk(){
	//기본타입코드 등록불가
	if((document.form.code.value == ("M000")) || (document.form.code.value == ("m000"))){

		alert("기본타입코드입니다.");
		return false;
	}else{

		return true;
	}
}

//쿼리
function doQuery()
{
	if(!doTypeChk()) return;

	document.form.code.value = document.form.code.value.toUpperCase();
	var code = encodeUrl(LRTrim(document.form.code.value));
	var searchword = encodeUrl(LRTrim(document.form.searchword.value));

	var grid_col_id = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL;
	var params = "mode=query&grid_col_id="+grid_col_id+
	                                 "&code="+code+
	                                 "&searchword="+searchword;
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);
}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}

function doOnRowSelected(rowId,cellInd)
{
	if(cellInd == GridObj.getColIndexById("CODE")) {
		var type = SepoaGridGetCellValueId(GridObj, rowId, "TYPE");
		var code = SepoaGridGetCellValueId(GridObj, rowId, "CODE");
	    var url = 'code_master_popup_mgt.jsp?type=' + encodeUrl(type) + '&code=' + encodeUrl(code) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '800', '600');
	}
}

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

//등록
function createData()
{
  if (confirm("<%=text.get("MESSAGE.1014")%>")){
		var url = 'code_master_popup_mgt.jsp?popup_flag=true';
		popUpOpen(url, 'crateData', '800', '600');

   }

	<%-- popupcode("M000", "popup_flag"); --%>
}

//수정
function doUpdate()
{
	if(!checkRows()) return;

	if(!selectOneChk()) return;

	var type = "";
	var code = "";

	type = GridObj.cells(checkedOneRow("SELECTED"), GridObj.getColIndexById("TYPE")).getValue();
	code = GridObj.cells(checkedOneRow("SELECTED"), GridObj.getColIndexById("CODE")).getValue();

   if (confirm("<%=text.get("MESSAGE.1016")%>")) {
   		var url = 'code_master_popup_mgt.jsp?type=' + encodeUrl(type) + '&code=' + encodeUrl(code) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '800', '600');
   }
}


//삭제
function doDelete()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	var cols_ids = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+cols_ids;
    myDataProcessor = new dataProcessor(SERVLETURL);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function selectOneChk() {
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length < 2) {
		return true;
	} else {
		alert("<%=text.get("AD_014.0001")%>");
		return false;
	}
}

function checkRows() {
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0) {
		return true;
	} else {
		alert("<%=text.get("AD_014.0002")%>");
		return false;
	}
}

function doSaveEnd(obj) {
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	var data_type= obj.getAttribute("data_type");

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

	return false;
}

function reload_page()
{
	doQuery();
}

function debug()
{
	document.form.debug_text.value = GridObj.GetDebugString();
}

function excelDown(){
	document.WiseGrid.ExcelExport('', '', true, true);
}


</Script>
</head>


<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();">
<s:header>
<form name="form" method="post" action="">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.codetype")%></td>
				<td width="30%" height="24" class="data_td">
					<input type="text" size="4" name="code" maxlength="4">
				</td>
				<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.searchword")%></td>
				<td width="30%" height="24" class="data_td">
					<input type="text" size="45" name="searchword">
				</td>
			</tr>
			</table>
			
			</td>
                		</tr>
            		</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
									<td><script language="javascript">btn("doQuery()", "<%=text.get("BUTTON.search")%>")</script></td>
									<td><script language="javascript">btn("createData()","<%=text.get("BUTTON.insert")%>")</script></td>
									<td><script language="javascript">btn("doUpdate()", "<%=text.get("BUTTON.update")%>")</script></td>
									<td><script language="javascript">btn("doDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
								</TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
<%--               
             <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=230"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>

