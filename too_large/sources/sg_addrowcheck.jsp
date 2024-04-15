<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String sg_type1     = JSPUtil.nullToEmpty(request.getParameter("sg_type1"));
	String sg_type2     = JSPUtil.nullToEmpty(request.getParameter("sg_type2"));
	String sg_type3		= JSPUtil.nullToEmpty(request.getParameter("sg_type3"));
	String company_code	= JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String company_name = JSPUtil.nullToEmpty(request.getParameter("company_name"));
		
	Object[] obj   = { sg_type1, sg_type2, sg_type3, company_code, company_name };
   	SepoaOut value = ServiceConnector.doService(info, "SR_001", "CONNECTION","sg_addRowCheck", obj);	
%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/sec.js"></script>

<Script language="javascript">
function Init()
{
	if( "<%=value.status%>" == "1" ){
		parent.setdoAddRow("<%=value.result[0]%>", "<%=sg_type1%>", "<%=sg_type2%>", "<%=sg_type3%>", "<%=company_code%>", "<%=company_name%>");
	}
	else{
		alert("정상적으로 처리하지 못하였습니다.");
	}
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>