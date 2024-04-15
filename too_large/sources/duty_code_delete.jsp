<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%-- <html>
<head>
<title></title> 
<%@ include file="/include/sepoa_scripts.jsp"%>--%>
<%
	String i_company_code = JSPUtil.paramCheck(request.getParameter("i_company_code"));
	String i_ctrl_code = JSPUtil.paramCheck(request.getParameter("i_ctrl_code"));
	String i_ctrl_type = JSPUtil.paramCheck(request.getParameter("i_ctrl_type"));

	String[] args = {i_company_code, i_ctrl_type, i_ctrl_code};
	
	SepoaOut value = ServiceConnector.doService(info, "AD_115", "CONNECTION", "getCount", args);
	
	String o_cnt = "" ;
	if(value.status == 1) {
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		o_cnt = wf.getValue("CNT", 0) ;
	}
%>
<%-- [{
	"status":"<%=value.status%>",
	"o_cnt":"<%=o_cnt%>",
	"message":"<%=value.message%>"
}] --%>

<Script language="javascript">
(function Init() {
	if("<%=value.status%>" == "1"){
		if("<%=o_cnt%>" == "0") check_flag("Y");
		else  check_flag("N");
	}else alert("<%=value.message%>");
})();
</Script>
<!-- </head>

<body bgcolor="#FFFFFF" text="#000000" onload="Init()">
<form name="form">
</form>
</body>
</html> -->
