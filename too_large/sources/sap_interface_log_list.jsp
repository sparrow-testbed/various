<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_137");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");
	String screen_id = "AD_137";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = true; //ì¼ë° ì¡°íì© íë©´ true, ë°ì´í° ì²ë¦¬ì© íë©´ì false
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script>



<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBoxì© JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%-- Dhtmlx SepoaGridì© JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
    GridObj.setSizes();
}

function doOnRowSelected(rowId,cellInd)
{
	if(GridObj.getColIndexById("IF_NUMBER") == cellInd)
	{
		var if_number = SepoaGridGetCellValueId(GridObj, rowId, "IF_NUMBER");
		popUpOpen('sap_rfc_log_detail_horizontal.jsp?if_number=' + encodeURIComponent(if_number), 'RFCLOG', '1000', '700');
	}
}

function doOnCellChange(stage,rowId,cellInd)
{
	var max_value = GridObj.cells(rowId, cellInd).getValue();
	//stage = 0 íì¬ìí, 1 = ìì ì´ì ìí, 2 = ìì íìí, true ìì íê°ì´ ì ì©ëë©° false ë ìì ì´ì ê°ì¼ë¡ ì ì©ë©ëë¤.
	if(stage==0)
	{
		return true;
	}
	else if(stage==1)
	{
	}
	else if(stage==2)
	{
	    return true;
	}
	return false;
}

function doQueryEnd(GridObj, RowCnt)
{
	//24ë² Grid ìê³, ì¤ê³, í©ê³ ê¸°ë¥
	//var sum_add_amt = document.getElementById("add_amt");
	//sum_add_amt.innerHTML = sumColumn(GridObj.getColIndexById("add_amt"));
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");
	//var data_type  = GridObj.getUserData("", "data_type");
	//var zero_value = GridObj.getUserData("", "0");
	//var one_value  = GridObj.getUserData("", "1");
	//var two_value  = GridObj.getUserData("", "2");
	//alert("msg]"+msg);

	if(status == "false") alert(msg);
	return true;
}

function doExcelDown()
{
	GridObj.setCSVDelimiter("\t");
	var csvNew = GridObj.serializeToCSV();
	GridObj.loadCSVString(csvNew);
}

function myErrorHandler(obj) {
	alert("Error occured.\n"+obj.firstChild.nodeValue);
	myDataProcessor.stopOnError = true;
	return false;
}

function doQuery()
{
	var from_date	= LRTrim(document.form.from_date.value);
	var to_date		= LRTrim(document.form.to_date.value);
	var rfc_name	= LRTrim(document.form.rfc_name.value);
	var user_name	= LRTrim(document.form.user_name.value);
	var mode = "query";
	var grid_col_id = "<%=grid_col_id%>";
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.sap_interface_log_list";
	var params = "from_date=" + encodeUrl(from_date) + "&to_date=" + encodeUrl(to_date) +
			  "&rfc_name=" + encodeUrl(rfc_name) + "&user_name=" + encodeUrl(user_name) + "&mode=" + encodeUrl(mode) + "&grid_col_id=" + encodeUrl(grid_col_id);
	GridObj.post(url,params);
	GridObj.clearAll(false);
}

function initAjax(){
	//doRequestUsingPOST( 'SL5001', 'M722' ,'module', '' );
}

</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>
<form name="form">

<%
	//íë©´ì´ popup ì¼ë¡ ì´ë¦´ ê²½ì°ì ì²ë¦¬ í©ëë¤.
	//ìë this_window_popup_flag ë³ìë ê¼­ ì ì¸í´ ì£¼ì´ì¼ í©ëë¤.
	//String this_window_popup_flag = "false";
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
	        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("AD_137.0001")%></td>
	        		<td width="30%" height="24" class="se_cell_data">
						<s:calendar id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"  
	        						default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" id_to="to_date" 
	        						format="%Y/%m/%d"/>
	        		</td>
	        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("AD_137.0002")%></td>
	        		<td width="30%" height="24" class="se_cell_data">
						<input type="text" name="rfc_name" size=15>
					</td>
				  </tr>
				  <tr>
	        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("AD_137.0003")%></td>
	        		<td width="30%" height="24" class="se_cell_data">
	        			<input type="text" name="user_name" size=15>
	        		</td>
	        		<td width="20%" height="24" align="right" class="se_cell_title">&nbsp;</td>
	        		<td width="30%" height="24" class="se_cell_data">
	        			&nbsp;
					</td>
				  </tr>
				</table>
			    <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
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
<jsp:param name="grid_object_name_height" value="gridbox=250"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
