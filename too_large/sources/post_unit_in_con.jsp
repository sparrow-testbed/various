<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>
<%
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
%>

<%-- <html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<%
	String[] args = new String[2];
	//args[0] = house_code;
	args[0] = request.getParameter("i_company_code");
	args[1] = request.getParameter("i_dept");
	//args[2] = request.getParameter("i_pr_location");
	
	Object[] obj = {args};
	SepoaOut value = ServiceConnector.doService(info, "AD_126", "CONNECTION", "getDuplicate", obj);	

%>

<%-- [{
	"status":"<%=value.status%>",
	"sflag":"<%=value.result[0]%>"
}] --%>
<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		var sflag = "<%=value.result[0]%>";
		if( sflag == 'X') checkDulicate('ok', sflag);
		else checkDulicate('ng', sflag);
	}else alert("error");
})();
</Script>
<%-- </head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="sflag" value="<%=value.result[0]%>">
</form>
</body>
</html>
 --%>