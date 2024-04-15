<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_126");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_126";
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

<script language="javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.post_unit";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
	setTimeout(doSelect,500);
	
}

//Query 조건의 데이타 Check.
function queryDataCheck(check) {
	if (check != null && check.length != 0) return true;
	else return false;
}

function getTopSelectedRow(SelectedRow) {
	var selected = SelectedRow.substring(0, SelectedRow.indexOf("&"));
	return selected;
}

function doSelect()
{
	var FormName = document.forms[0];
	var check = FormName.I_COMPANY_CODE.value;

	if (queryDataCheck(check))
	{
		var I_COMPANY_CODE  = FormName.I_COMPANY_CODE.value;
		FormName.DEPT.value = FormName.DEPT.value.toUpperCase();
		var DEPT        	= FormName.DEPT.value;
		var DEPT_NAME_ENG   	= FormName.I_DEPT_NAME.value;
		var PR_LOCATION 	= FormName.PR_LOCATION.value;
		var DEPT_NAME_LOC ;
		var PR_LOCATION_NAME ;

		var grid_col_id = "<%=grid_col_id%>";
/* 		var SERVLETURL  = G_SERVLETURL + "?mode=getMaintain&grid_col_id="+grid_col_id+
		                                 "&DEPT="+encodeUrl(DEPT)+
		                                 "&I_COMPANY_CODE="+encodeUrl(I_COMPANY_CODE)+
		                                 "&DEPT_NAME_LOC="+encodeUrl(DEPT_NAME_LOC)+
		                                 "&DEPT_NAME_ENG="+encodeUrl(DEPT_NAME_ENG)+
		                                 "&PR_LOCATION_NAME="+encodeUrl(PR_LOCATION_NAME)+
		                                 "&PR_LOCATION="+encodeUrl(PR_LOCATION); */
		var SERVLETURL = G_SERVLETURL;
		var params = "mode=getMaintain&grid_col_id="+grid_col_id+
			       "&DEPT="+encodeUrl(DEPT)+
			       "&I_COMPANY_CODE="+encodeUrl(I_COMPANY_CODE)+
			       "&DEPT_NAME_LOC="+encodeUrl(DEPT_NAME_LOC)+
			       "&DEPT_NAME_ENG="+encodeUrl(DEPT_NAME_ENG)+
			       "&PR_LOCATION_NAME="+encodeUrl(PR_LOCATION_NAME)+
			       "&PR_LOCATION="+encodeUrl(PR_LOCATION);
		
		/* GridObj.loadXML(SERVLETURL); */
		GridObj.post(SERVLETURL,params);
		GridObj.clearAll(false);

		FormName.query_flag.value = "2";
	} else {
		//alert("Company code를 입력해 주십시요.");
		alert("<%=text.get("AD_126.MSG_0104")%>");
	}
}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}

function doInsert()
{
	var I_COMPANY_CODE = document.form.I_COMPANY_CODE.value;
	if(I_COMPANY_CODE.length < 1 || document.form.query_flag.value != "2" )
	{
		//alert("데이터 조회 후 생성하세요.");
		alert("<%=text.get("AD_126.MSG_0105")%>");
		return;
	}
	location.href = "post_unit_in.jsp?I_COMPANY_CODE="+I_COMPANY_CODE;
}

function doUpdate()
{

	var FormName = document.forms[0];
	var iCheckedCount = getCheckedCount(GridObj, "SELECTED");

	if(iCheckedCount<1)
	{
		//alert("선택한 내역이 없습니다.");
		alert("<%=text.get("AD_126.MSG_0100")%>");
		return;
	}
	if(iCheckedCount>1)
	{
		//alert("하나의 항목만 선택하여 주십시오.");
		alert("<%=text.get("AD_126.MSG_0101")%>");
		return;
	}

	var selected       = checkedOneRow("SELECTED");
	var DEPT           = SepoaGridGetCellValueId(GridObj, selected, "DEPT");
	var I_PR_LOCATION  = SepoaGridGetCellValueId(GridObj, selected, "PR_LOCATION");
	var I_COMPANY_CODE = FormName.I_COMPANY_CODE.value;

	location.href = "post_unit_up.jsp?I_DEPT="+DEPT+"&I_COMPANY_CODE="+I_COMPANY_CODE+"&I_PR_LOCATION="+I_PR_LOCATION;
}

function doDelete()
{
	var FormName = document.forms[0];
	var iCheckedCount = getCheckedCount(GridObj, "SELECTED");
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(iCheckedCount < 1)
	{
		//alert("행을 선택하세요");
		alert("<%=text.get("AD_126.MSG_0102")%>");
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	var I_COMPANY_CODE = document.form.I_COMPANY_CODE.value;
	var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+cols_ids+"&I_COMPANY_CODE="+encodeUrl(I_COMPANY_CODE);

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
		doSelect();
	} else {
		alert(messsage);
	}

	return false;
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

function entKeyDown()
{
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doData")
	{
		doSelect();
	}
}
</script>
</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();" onkeydown='entKeyDown()'>
<s:header>
<!--내용시작-->
<form name="form" method="post" action="">
<input type="hidden" name="query_flag" value="1" class="inputsubmit">
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
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_126.TEXT_0100")%></td>
				<td width="30%" height="24" class="se_cell_data">
						<select name="I_COMPANY_CODE" class="input_re">
							<option value="">&nbsp;</option>
						<%
							 String lb = ListBox(request, "SL0006" , "#", company_code);
							 out.println(lb);
						%>
						</select>
				</td>
				<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_126.TEXT_0101")%></td>
				<td width="30%" height="24" class="se_cell_data">
						<select name="PR_LOCATION" class="inputsubmit">
							<option value=""></option>
						<%
							String pr_location = ListBox(request, "SL0018" , "#M062#", "");
							out.println(pr_location);
						%>
						</select>
				</td>
			</tr>
			<tr>
				<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_126.TEXT_0102")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" name="DEPT" maxlength="5" class="inputsubmit" size="8">
				</td>
				<td width="20%" height="24" class="se_cell_title"><%=text.get("AD_126.TEXT_0103")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" name="I_DEPT_NAME" maxlength="10" class="inputsubmit" size="10">
				</td>
			</tr>
			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
								<td><script language="javascript">btn("javascript:doSelect();","<%=text.get("BUTTON.search")%>")</script></td>
			    	  			<TD><script language="javascript">btn("javascript:doInsert();","<%=text.get("BUTTON.insert")%>")</script></TD>
			    	  			<td><script language="javascript">btn("javascript:doUpdate();","<%=text.get("BUTTON.update")%>")</script></td>
								<TD><script language="javascript">btn("javascript:doDelete();","<%=text.get("BUTTON.deleted")%>")</script></TD>
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
<jsp:param name="grid_object_name_height" value="gridbox=260"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
