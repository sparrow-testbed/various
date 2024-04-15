<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>


<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<% 
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
%>
<%-- <html>
<head>
<title> reate(General)</title>

META TAG 정의 
Wisehub Common Scripts


<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<link rel="stylesheet" href="/css/mobis.css" type="text/css"> --%>

<%
	String strParamSql = request.getParameter("SQL");
	SepoaOut value = null;
	try {
		
		
		
		Object[] obj = {info,strParamSql};
		value = ServiceConnector.doService(info, "AD_037", "CONNECTION","testSql", obj);
		
	} catch (Exception e) {
		
		Logger.debug.println(e.toString());
	}
	
	
%>
<%-- [{
	"status":"<%=value.status%>",
	"message":"<%=value.message%>",
	"resultv":"<%=value.result[0]%>"
}] --%>
<Script language="javascript">
	var status = "<%=value.status%>";
	var message = '<%= value.message %>';
	(function Init() {
	   if ( status == '0') {
	    	var resultv = "<%=value.result[0]%>";
	        alert(resultv);
	        checkverify('ok');
	    } else {
	        alert(message);
	        //alert("error query!!!");
	        checkverify('ng');
		}
	})();

</Script>
<%-- </head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="resultv" value="<%=value.result[0]%>"> 
</form>
</body>
</html> --%>