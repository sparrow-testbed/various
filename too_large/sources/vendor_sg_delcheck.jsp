<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String sg_type3     = JSPUtil.nullToEmpty(request.getParameter("sg_type3"));
	String vendor_code  = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
		
	Object[] obj   = { sg_type3, vendor_code };
   	SepoaOut value = ServiceConnector.doService(info, "SR_001", "CONNECTION","vendor_del_Check", obj);	
%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/sec.js"></script>

<Script language="javascript">
function Init()
{
	if( "<%=value.status%>" == "1" ){
		parent.setvendor_sgDelete("<%=value.result[0]%>");
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