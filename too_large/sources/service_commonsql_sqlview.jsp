<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String sqlpass =request.getParameter("sqlpass");

	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language=javascript src="../js/cnkcl.js"></script>
</head>

<body topmargin="25">
<s:header popup="true">
<form name="form1" method="post" action="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="10"></td>
	<td width="100%" align="center" valign="top">
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td><textarea name="textfield2" class="inputsubmit" cols="67" rows="20" wrap="VIRTUAL"><%=sqlpass%></textarea></td>
		</tr>
		<tr>
			<td height="5"></td>
		</tr>
		<tr>
			<td align="right">
				<script language="javascript">btn("window.close()","<%=text.get("BUTTON.close")%>")</script>
		  	</td>
		</tr>
	  	</table>
	</td>
  	<td width="10"></td>
</tr>
</table>
</form>

</s:header>
<s:footer/>
</body>
</html>

