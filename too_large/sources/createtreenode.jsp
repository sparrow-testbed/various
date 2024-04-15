<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Enumeration<String> paramNames = request.getParameterNames();
	List<String> params = new ArrayList<String>();
	List<String> values = new ArrayList<String>();
	while(paramNames.hasMoreElements()) {
		String paramName = paramNames.nextElement();
		if(paramName.startsWith("id_")) {
			String value = request.getParameter(paramName);
			params.add(paramName.substring(3));
			values.add(value);
		}
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	HashMap text = MessageUtil.getMessage(info, multilang_id);

%>
<html>
<header>
<%@ include file="/include/include_css.jsp"%>
<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME %>/css/sec.css" type="text/css"/>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script>
function doConfirm() {
	var map = new JavascriptMap();
<%
for(int i = 0; i < params.size(); i++) {
%>
	map.put("<%=params.get(i)%>", document.form1.<%=params.get(i)%>.value);
<%
}
%>
	parent.popupConfirm(map);
	parent.popupClose();
}
function doCancel() {
	parent.popupClose();
}
</script>
</header>
<body>
<form name="form1">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<%
for(int i = 0; i < params.size(); i++) {
%>
<tr>
<td class="se_cell_title" width="50%" height="24" >
<%=values.get(i)%>
</td>
<td class="se_cell_data" width="50%" height="24" >
<input type="text" id="<%=params.get(i) %>" name="<%=params.get(i) %>">
</td>
</tr>
<%
}
%>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr >
<td><script language="javascript">btn("javascript:doConfirm()","<%=text.get("BUTTON.confirm")%>")</script>
<script language="javascript">btn("javascript:doCancel()","<%=text.get("BUTTON.cancel")%>")</script></td>
</tr>
</table>
</form>
</body>
</html>