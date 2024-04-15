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
	multilang_id.addElement("AD_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_015";
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



<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.code_detail_mgt";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
}

function checkRows(mode)
{	//선택된 로우 체크만 반환

	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	if(mode == "I") {
		alert("<%=text.get("AD_015.0003")%>");
		return false;
	} else {
		alert("<%=text.get("AD_015.0005")%>");
		return false;
	}
}

function debug()
{	//디버그
	document.form.debug_text.value = GridObj.GetDebugString();
}

function excelDown(){
	//액셀
	document.WiseGrid.ExcelExport('', '', true, true);
}

function typeChk(){
	//type체크여부
	if(document.form.detailType.value == ""){
		alert("<%=text.get("AD_015.0002")%>");
		return false;
	}
	return true;
}

function haveCodeChk() //중복 코드 입력 불가
{
	for(i = dhtmlx_start_row_id; i < dhtmlx_end_row_id; i++)
	{
		if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue() == "1")
		{
			//check된 등록할 새로운 코드값, LANGUAGE
			var new_Code = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("CODE")).getValue()).toUpperCase();
			var new_language = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("LANGUAGE")).getValue()).toUpperCase();

			for (j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				//uncheck된 기존 코드값, language
				if(GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("SELECTED")).getValue() == "0")
				{
					//기존코드값과 등록할 코드값, language를 비교
					var old_Code = LRTrim(GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("CODE")).getValue()).toUpperCase();
					var old_language = LRTrim(GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("LANGUAGE")).getValue()).toUpperCase();

					if( (old_Code == new_Code) && (old_language == new_language) )
					{
						alert("<%=text.get("AD_015.0008")%>");//동일한 데이터가 존재합니다.
						return false;
					}
				}
			}
		}
	}

	return true;
}

//코드입력체크
function codeChk()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
    {
		if(GridObj.cells(grid_array[i], GridObj.getColIndexById("SELECTED")).getValue() == "1")
		{
			<%-- 언어는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("LANGUAGE")).getValue()) == "")
			{
				alert("<%=text.get("AD_015.0009")%>");
				return false;
			}

			<%-- 코드는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CODE")).getValue()) == "")
			{
				alert("<%=text.get("AD_015.0007")%>");
				return false;
			}

			<%-- 텍스트1은 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("TEXT1")).getValue()) == "")
			{
				alert("<%=text.get("AD_015.0004")%>");
				return false;
			}

		}
	}
	return true;
}

function doQuery()
{	//쿼리조회(3가지조건으로)
	document.form.detailType.value = document.form.detailType.value.toUpperCase();
	var type = LRTrim(document.form.detailType.value);
	var code = LRTrim(document.form.detailCode.value);
	var search = LRTrim(document.form.search.value);
	var language = LRTrim(document.form.language.value);

	if(type == "" && code == "")
	{
		alert("<%=text.get("AD_015.0002")%>");
		return;
	}

	var grid_col_id = "<%=grid_col_id%>";
/* 	var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id+
	                                 "&type="+encodeUrl(type)+
	                                 "&language="+encodeUrl(language)+
	                                 "&code="+encodeUrl(code)+
	                                 "&search="+encodeUrl(search); */
	var SERVLETURL  = G_SERVLETURL;
    var params = "mode=query&grid_col_id="+grid_col_id+
     "&type="+encodeUrl(type)+
     "&language="+encodeUrl(language)+
     "&code="+encodeUrl(code)+
     "&search="+encodeUrl(search);
    
//	GridObj.loadXML(SERVLETURL);
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

function doInsert()
{//등록

	var type = LRTrim(document.form.detailType.value);
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	//선택된 로우체크
	if (!checkRows("I")) return false;
	//TYPE 존재여부 체크
	if (!typeChk()) return;
	//코드,텍스트1,텍스트2 입력체크
	if (!codeChk()) return;
	//기존 코드존재 여부체크(동일코드 등록불가)
	//if (!haveCodeChk()) return;

	if (confirm("<%=text.get("MESSAGE.1014")%>")){
		var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=insert&cols_ids="+cols_ids+"&type="+encodeUrl(type);
    	myDataProcessor = new dataProcessor(SERVLETURL);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

//수정
function doModify()
{
	var type = LRTrim(document.form.detailType.value);

	//선택된 로우체크
	if (!checkRows("M")) return;

	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
    {
		if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SELECTED") == "true")
        {
          	var code_hidden = LRTrim(SepoaGridGetCellValueId(GridObj, grid_array[i], "CODE_HIDDEN"));

          	if(code_hidden == "") {
          		alert("<%=text.get("AD_015.MSG_0110")%> ");//행삽입 후 수정을 하실수 없습니다\
          		return false;
          	}
        }
	}

	//TYPE 존재여부 체크
	if (!typeChk()) return;
	//코드,텍스트1,텍스트2 입력체크
	if (!codeChk()) return;

	if (confirm("<%=text.get("MESSAGE.1016")%>")){
		var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=modify&cols_ids="+cols_ids+"&type="+encodeUrl(type);
    	myDataProcessor = new dataProcessor(SERVLETURL);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

function doDelete()
{//삭제
	var type = LRTrim(document.form.detailType.value);

	//선택된 로우체크
	if (!checkRows("D")) return;
	//TYPE 존재여부 체크
	if (!typeChk()) return;

	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if (confirm("<%=text.get("MESSAGE.1015")%>")){
		var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+cols_ids+"&type="+encodeUrl(type);
    	myDataProcessor = new dataProcessor(SERVLETURL);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

//행삽입
function rowinsert()
{
	dhtmlx_last_row_id++;
   	var nMaxRow2 = dhtmlx_last_row_id;
	GridObj.enableSmartRendering(true);
   	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
   	GridObj.selectRowById(nMaxRow2, false, true);
   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("USE_FLAG")).setValue("1");
}

function searchCode() {
	//공통코드 찾기

	//var url = "/dpos/wise/wisepopup/cod_cm_lis1.jsp?code=SP0001&function=getAllCode&values=M000&values=<%=language%>&values=&values=";
	//Code_Search(url,'','','','600','');
	popupcode("M000","getAllCode")
}

function getAllCode(code, text) {
	//화면출력
	document.form.detailType.value = code;
	document.form.detailCodeName.value = text;
}

function CheckBoxSelect(strColumnKey, nRow)
{
	if(strColumnKey  == 'SELECTED') return;
	GridObj.SetCellValue("SELECTED", nRow, "1");
}

function initAjax(){
	doRequestUsingPOST( 'SL5003', 'M013' ,'language', '' );
	
}

</script>
</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();initAjax();">
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
        		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_015.codetype")%></td>
				<td width="30%" height="24" class="data_td">
					<input type="text" size="4" maxlength="4" name="detailType">
					<img src="../images/ico_zoom.gif" hspace="2" align="absmiddle" style="cursor:hand" onClick="javascript:searchCode();">
                    <input type="text" size="20" maxlength="20" name="detailCodeName" class="CSS INPUT_EMPTY" readOnly>
				</td>
				<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_015.CODE")%></td>
				<td width="30%" height="24" class="data_td">
 	               <input type="text" size="10" name="detailCode">
 	            </td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_015.language")%></td>
				<td width="30%" height="24" class="data_td">
					<select name="language" id="language" class="inputsubmit">
						<option value="">전체</option>
					</select>
				</td>
				<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_015.searchword")%></td>
				<td width="30%" height="24" class="data_td">
 	               <input type="text" size="13" name="search">
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
                           	<td>
		                      <script language="javascript">btn("doQuery()", "<%=text.get("BUTTON.search")%>")</script></td>
		                      <td><script language="javascript">btn("doInsert()","<%=text.get("BUTTON.insert")%>")</script></td>
		                      <td><script language="javascript">btn("doModify()", "<%=text.get("BUTTON.update")%>")</script></td>
		                      <td><script language="javascript">btn("doDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
		                      <td><script language="javascript">btn("rowinsert()","<%=text.get("BUTTON.rowinsert")%>")</script></td>
		                    </td>
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
<jsp:param name="grid_object_name_height" value="gridbox=220"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>

