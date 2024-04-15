<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="sepoa.fw.util.JSPUtil"%>
<%
	String INDEX = JSPUtil.nullToEmpty(request.getParameter("INDEX"));
	String gate  = JSPUtil.nullToEmpty(request.getParameter("gate"));
	
	String url = "cat_pp_lis_main.jsp" ;
		   url = url + "?INDEX=" + INDEX + "&gate=" + gate;
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<frameset rows="100%,*" frameborder="NO" border="0" framespacing="0" cols="*">
  <frame name="topFrame" noresize src="/kr/catalog/<%=url %>" >
  <frame name="mainFrame" src="">
</frameset>
<noframes>

<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes>
</html>
