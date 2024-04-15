<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<% String WISEHUB_PROCESS_ID="SU_102_02";%>

<%
	String REJECT_REASON = JSPUtil.nullToEmpty(request.getParameter("REJECT_REASON"));
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="/include/include_css.jsp"%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
	<%-- Ajax SelectBox용 JSP--%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">

function save() {
	if(confirm("반려처리 하시겠습니까?")){
	var reject_reason = document.form1.reject_reason.value;
	opener.setREJECT_REASON(reject_reason);	
	self.close();
	}
}

function initial() {


}
</script>

<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;
		&nbsp;반려사유
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:save()","저 장")</script></TD>
			<TD><script language="javascript">btn("javascript:self.close()","닫 기")</script></TD>
		</TR>
		</TABLE>
</TR>
</TABLE>

<form name="form1">
	<textarea name="reject_reason"  id="reject_reason" value=""  rows = "10" cols = "88" style="overflow=hidden"><%=REJECT_REASON%></textarea>
</form>

</body>
</html>
