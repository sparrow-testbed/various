<%@page import="sepoa.fw.util.CommonUtil"%>
<%@ page contentType="text/html; charset=utf-8" %>
<html>
<%
//    String ip = request.getRemoteAddr();
//    ip = ip.substring(0, ip.indexOf("."));
//    String home = (ip.equals("52") ? "http://cgv.cj.net:800/index.aspx" : "http://cgvsrm.cj.net/intro/body.jsp");

	String sHostName = ( "http://"+request.getServerName()+ ":"+String.valueOf(request.getServerPort()) ) ;
	//String home = sHostName ;
	String home = CommonUtil.getConfig("sepoa.ip.info");

	String house_code = "";

	String user_type = request.getParameter("user_type");
	user_type = user_type == null || user_type.equals("") || user_type.equals("S") ? "" : "/index.htm";
	String url = home+ user_type;

	url = "/";
%>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script>

function Redirect()
{
    alert('세션이 종료되었습니다.');
    top.location.href="<%=url%>";
}

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad='Redirect();'>
</body>
</html>
