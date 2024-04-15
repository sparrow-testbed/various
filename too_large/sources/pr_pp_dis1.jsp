<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String pRow 	= JSPUtil.nullToEmpty(request.getParameter("pRow"));
	String pCol 	= JSPUtil.nullToEmpty(request.getParameter("pCol"));
	String pFlag	= JSPUtil.nullToEmpty(request.getParameter("pFlag"));
	
	String title	= "반려사유";
	if("Z".equals(pFlag))	title = "보류사유";
%>

<html>

<head>

<title>우리은행 전자구매시스템</title>


<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<script language="javascript">

	 

	function init()	{
		var data = opener.GridObj.cells(opener.GridObj.getRowId("<%=pRow%>"), opener.GridObj.getColIndexById("<%=pCol%>")).getValue();
		form1.textfield_data.value = data;
	}
</script>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onload="init()">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;
<%-- 	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle"> --%>
		&nbsp;<%=title %>
	</td>
</tr>
</table>

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
		</TR>
		</TABLE>
	</TD>
</TR>
</TABLE>

<form name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="text-align: center">
				<textarea name="textfield_data" value=""  rows = "10" cols = "88" class="inputsubmit" style="overflow=hidden; height: 200px; width: 95%;" onKeyUp="return chkMaxByte(500, this, '반려사유');"></textarea>
			</td>
		</tr>
	</table>
</form>

</body>
</html>
