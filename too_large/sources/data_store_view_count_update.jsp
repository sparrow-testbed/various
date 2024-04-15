<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	String SEQ	= JSPUtil.nullToEmpty(request.getParameter("seq"));
	
	String[] obj = {SEQ};

	SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION","view_DataStore_Count", obj);
%>
<%-- [{
	"seq":"<%=SEQ%>"
}] --%>
<!-- <html>
<head>
<title></title> -->

<Script language="javascript">

(function Init()
{
	<%-- parent.popup("<%=SEQ%>"); --%>
	popup("<%=SEQ%>");
})();

//-->
</Script>

<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->