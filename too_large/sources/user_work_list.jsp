<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ page import="sepoa.fw.ses.SepoaInfo" %>
<%@ page import="sepoa.fw.ses.SepoaSession" %>
<%@ page import="sepoa.fw.msg.MessageUtil" %>
<%@ page import="java.util.Vector" %>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(to_day, 0));
	String to_date = SepoaString.getDateSlashFormat(to_day);

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_028");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	String screen_id = "AD_028";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = true; //일반 조회용 화면 true, 데이터 처리용 화면은 false
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
var GridObj = null;
var current_row_number = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
    GridObj.setSizes();
}

function doQuery()
{
	var from_date = del_Slash(LRTrim(document.form.from_date.value));
	var to_date = del_Slash(LRTrim(document.form.to_date.value));
	var module_name = LRTrim(document.form.module_name.value);
	var job_type = LRTrim(document.form.job_type.value);
	var method_name = LRTrim(document.form.method_name.value);
	var user_name = LRTrim(document.form.user_name.value);
	var user_id = LRTrim(document.form.user_id.value);
	var grid_col_id = "<%=grid_col_id%>";

	if(from_date == "")
	{
		alert("<%=text.get("AD_028.0001")%>");
		document.form.from_date.focus();
		return false;
	}

	if(to_date == "")
	{
		alert("<%=text.get("AD_028.0001")%>");
		document.form.to_date.focus();
		return false;
	}

	if(from_date != null && 0 < from_date.length){
		if(!checkDate(from_date.replaceAll("-",""))){
			alert("<%=text.get("AD_028.0003")%>");
			document.form.from_date.focus();
			return false;
		}

		if(from_date > to_date){
			alert("<%=text.get("AD_028.0002")%>");
			document.form.from_date.focus();
			return false;
		}
	}

	if(to_date != null && 0 < to_date.length){
		if(!checkDate(to_date.replaceAll("-",""))){
			alert("<%=text.get("AD_028.0003")%>");
			document.form.to_date.focus();
			return false;
		}
	}

	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.user_work_list";
	var params = "from_date=" + encodeUrl(from_date) + "&to_date=" + encodeUrl(to_date) +
			  "&module_name=" + encodeUrl(module_name) + "&job_type=" + encodeUrl(job_type) + "&method_name=" + encodeUrl(method_name) +
			  "&user_name=" + encodeUrl(user_name) + "&user_id=" + encodeUrl(user_id) + "&grid_col_id=" + encodeUrl(grid_col_id)+"&mode=query";
	GridObj.post(url,params);
	GridObj.clearAll(false);
}

function doOnRowSelected(rowId,cellInd)
{
   	//alert(GridObj.cells(rowId, cellInd).getValue());
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
   	//24번 Grid 소계, 중계, 합계 기능
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

function initAjax(){

}



</Script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>
<form name="form">
<input type="hidden" name="module_type" value="V">
<input type="hidden" name="apply_flag">

<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
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
  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
	<tr>
    <td width="100%" valign="top">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
		  <tr>
       		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;Module Name</td>
       		<td width="30%" height="24" class="data_td">
       			<input type="text" size="15" name="module_name" value="">
       		</td>
       		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;Method Name</td>
       		<td width="30%" height="24" class="data_td">
				<input type="text" size="15" name="method_name">
			</td>
		  </tr>
		  <tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
		  <tr>
       		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;User Name</td>
       		<td width="30%" height="24" class="data_td">
       			<input type="text" size="15" name="user_name">
       		</td>
       		<td width="20%" height="24"  class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;User ID</td>
       		<td width="30%" height="24" class="data_td">
				<input type="text" size="15" name="user_id">
			</td>
		  </tr>
		  <tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
		  </tr>
		  <tr>
       		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;Job Date</td>
       		<td width="30%" height="24" class="data_td">
       				  <%-- <input type="text" size="8" maxlength="8" name="from_date" value="<%=from_date%>">
                      <img src="../images/ico_cal.gif" width="21" height="20"  align="absmiddle" style="cursor:hand" onClick="popUpCalendar(this, from_date, 'yyyy/mm/dd')">~
                      <input type="text" size="8" maxlength="8" name="to_date" value="<%=to_date%>">
                      <img src="../images/ico_cal.gif" width="21" height="20"  align="absmiddle" style="cursor:hand" onClick="popUpCalendar(this, to_date, 'yyyy/mm/dd')"> --%>
                      <s:calendar id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"  
	        						default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" id_to="to_date" 
	        						format="%Y/%m/%d"/>
       		</td>
       		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;Job Type</td>
       		<td width="30%" height="24" class="data_td">
						<select name="job_type" class="inputsubmit">
						  <option value=""><%=text.get("AD_028.ALL")%></option>
				          <option value="LI"><%=text.get("AD_028.LI")%></option>
				          <option value="LO"><%=text.get("AD_028.LO")%></option>
				          <option value="WK"><%=text.get("AD_028.WK")%></option>
				        </select>
			</td>
		  </tr>
		</table>
		</TR>
		  </TABLE>
		  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			  <TR>
				<td style="padding:5 5 5 0">
				<TABLE cellpadding="2" cellspacing="0">
				  <TR>
				  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
				  </TR>
			    </TABLE>
			  </td>
			  </tr>
            		</table>
		    
<%--        
      <%@ include file="/include/include_bottom.jsp"%> --%>
		</td>
	</tr>
</table>
</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=280"/>
</jsp:include> --%>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
