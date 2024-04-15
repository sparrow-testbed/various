<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_118");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_118";
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

<Script language="javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.factory_unit";
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
	setTimeout(getQuery,500);
}

<%--//Query 조건의 데이타 Check.--%>
function queryDataCheck(check) {
	if (check != null && check.length != 0) return true;
	else return false;
}


<%--//Checked Row--%>
function checkedRow()
{
	var sendRow = "";

	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
    {
    	var check = GridObj.cells(grid_array[i], GridObj.getColIndexById("SELECTED")).getValue();
		if (check == "1") sendRow += (grid_array[i]+"&");
	}

	return sendRow;
}

function getCheckCount()
{
	var iCheckCount = 0;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	iCheckCount = grid_array.length;
	return iCheckCount;
}


<%--//CheckedRow중 최상위 Row를 가져온다.--%>
function getTopSelectedRow(SelectedRow) {
	var selected = SelectedRow.substring(0, SelectedRow.indexOf("&"));
	return selected;
}



<%--//Data Query해서 가져오기--%>
function getQuery()
{
	var check = document.form.i_company_code.value;

	if (!queryDataCheck(check))
	{
		//alert("회사를 입력해 주십시요.");
		alert("<%=text.get("AD_118.MSG_0100")%>");
		return;
	}

	var grid_col_id = "<%=grid_col_id%>";
	var i_company_code = document.form.i_company_code.value;
	var SERVLETURL  = G_SERVLETURL;
	var params = "i_company_code="+encodeUrl(i_company_code)+"&grid_col_id="+grid_col_id;
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);
	document.form.query_flag.value = "2";
}

<%--//Create--%>
function doInsert()
{
	var i_company_code = document.form.i_company_code.value;
	if(i_company_code.length < 1 || document.form.query_flag.value != "2" )
	{
		//alert("데이터 조회 후 생성하세요.");
		alert("<%=text.get("AD_118.MSG_0101")%>");
		return;
	}
	location.href = "factory_unit_insert.jsp?i_company_code="+i_company_code;
}

<%--//Change--%>
function doUpdate()
{
	<%--//Table에서 선택된 Row를 알아본다.--%>
	var checked = checkedRow();

	if (checked.length != 0) {
		<%--//선택된 Row중 Table위치상 상위에 있는 Row를 가져온다.--%>
		var selected = getTopSelectedRow(checked);
		<%--//alert(eval(selected)+1+"째 Row를 변경합니다. ");--%>

		var plant_code      = SepoaGridGetCellValueId(GridObj, selected, "PLANT_CODE");
		var company_code    = SepoaGridGetCellValueId(GridObj, selected, "COMPANY_CODE");
		var i_pr_location   = SepoaGridGetCellValueId(GridObj, selected, "PR_LOCATION");

		location.href = "factory_unit_update.jsp?i_plant_code="+plant_code+"&i_company_code="+company_code+"&i_pr_location="+i_pr_location;
	}
	else
		//alert("처리할 Row를 선택해 주세요.");
		alert("<%=text.get("AD_118.MSG_0102")%>");
}

function doDelete()
{
	var iCheckedRow = getCheckCount();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	if (iCheckedRow<1)
	{
		//alert("선택한 항목이 없습니다.");
		alert("<%=text.get("AD_118.MSG_0103")%>");
		return;
	}

	//if(!confirm("정말로 삭제하시겠습니까?"))
	if(!confirm("<%=text.get("AD_118.MSG_0104")%>"))
	{
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL + "?cols_ids="+cols_ids;

    myDataProcessor = new dataProcessor(SERVLETURL);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
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
		getQuery();
	} else {
		alert(messsage);
	}

	return false;
}

function doDisplay() {
	var checked = checkedRow();

	if (checked.length != 0)
	{
		var selected       = getTopSelectedRow(checked);
		var plant_code     = SepoaGridGetCellValueIndex(document.WiseGrid,selected,IDX_PLANT_CODE);
		var company_code   = SepoaGridGetCellValueIndex(document.WiseGrid,selected,IDX_COMPANY_CODE);
		var i_pr_location  = SepoaGridGetCellValueIndex(document.WiseGrid,selected,IDX_PR_LOCATION);

		location.href = "factorypop_unit.jsp?i_plant_code="+plant_code+"&i_company_code="+company_code+"&i_pr_location="+i_pr_location;
	}
	else
		//alert("처리할 Row를 선택해 주세요.");
		alert("<%=text.get("AD_118.MSG_0102")%>");
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

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}
</script>
</head>


<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();">
<s:header>
<form name="form" method="post" action="">
<input type="hidden" name="query_flag" value="1" class="inputsubmit">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_118.TEXT1")%>
        		<td width="80%" height="24" class="se_cell_data" colspan="3">
			       <select name="i_company_code" class="input_re">
						<option value=""></option>
							<%
								String lb = ListBox(request, "SL0006" , "#", company_code);
								out.println(lb);
							%>
					</select>
				</td>
			  </tr>
			  </table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
							<td><script language="javascript">btn("javascript:getQuery()","<%=text.get("BUTTON.search")%>")</script></td>
				    	  	<TD><script language="javascript">btn("javascript:doInsert()","<%=text.get("BUTTON.insert")%>")</script></TD>
				    	  	<td><script language="javascript">btn("javascript:doUpdate()","<%=text.get("BUTTON.update")%>")</script></td>
							<TD><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></TD>
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
<jsp:param name="grid_object_name_height" value="gridbox=220"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
