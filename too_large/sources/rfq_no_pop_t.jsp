<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<% String WISEHUB_PROCESS_ID="RQ_237_01";%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<form name="form" >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="se_cell_title">
		견적요청번호 / 차수 조회
	</td>
</tr>
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>
</form>

</s:header>
<s:footer/>
</body>
</html>


