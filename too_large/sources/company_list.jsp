<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text 				= MessageUtil.getMessage(info,multilang_id);
   	String change_user_id 		= JSPUtil.paramCheck(info.getSession("ID"));
	String house_code 			= JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_102";
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

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.company_list";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
	setTimeout(doSelect,500);
}

function doSelect()
{
	var grid_col_id = "<%=grid_col_id%>";
	/* var SERVLETURL  = G_SERVLETURL + "?mode=getMaintain&grid_col_id="+grid_col_id; */
	var SERVLETURL = G_SERVLETURL;
	/* var params = "mode=getMaintain&grid_col_id="+grid_col_id; */
	var params = "mode=query&grid_col_id="+grid_col_id;
	/* GridObj.loadXML(SERVLETURL); */
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doData")
	{
		doSelect();
	}
}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}

function doDelete()
{
	if(!checkedDataRow("SELECTED")) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var anw = confirm("<%=text.get("MESSAGE.1015")%>?");
	if(anw == false) return;

	var cols_ids = "<%=grid_col_id%>";
	var CHANGE_USER_ID = "<%=change_user_id%>";
	var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+cols_ids+"&CHANGE_USER_ID="+encodeUrl(CHANGE_USER_ID);

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

function doSave()
{
	var tCode ="";

	var grid_array = getGridChangedRows(GridObj, "SELECTED");

    // grid_array.length 만큼 loop 를 돌린다.
    // 기존에는 페이
    for(var i = 0; i < grid_array.length; i++)
    {
    	var cmCode = GridObj.cells(grid_array[i], GridObj.getColIndexById("COMPANY_CODE")).getValue();
		tCode += cmCode;
		tCode += ":";
    }

	location.href = "company_insert.jsp?tCode="+tCode;
}


function doUpdate(flag)
{

	var row_idx = checkedOneRow("SELECTED");

	if (row_idx == -1) return;

	var cmCode = SepoaGridGetCellValueId(GridObj, row_idx, "COMPANY_CODE");

	if(flag == 'chg') location.href = "company_update.jsp?cmCode="+cmCode; //com_bd_upd1.jsp
	else if(flag == 'dis') location.href = "company_detail_mgt.jsp?cmCode="+cmCode;
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
</script>
</head>
<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<s:header>
<!--내용시작-->

<form name="form">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
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
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
			      	      <TD><script language="javascript">btn("javascript:doSave()","<%=text.get("BUTTON.insert")%>")</script></TD>
		      			  <TD><script language="javascript">btn("javascript:doUpdate('chg')","<%=text.get("BUTTON.update")%>")</script></TD>
		      			  <TD><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></TD>
	    	  			  <td><script language="javascript">btn("javascript:doUpdate('dis')","<%=text.get("BUTTON.detail_info")%>")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			</td>
		  </tr>
		</table>
	</table>
	</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
