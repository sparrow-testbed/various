<%@ include file="/include/wisehub_common.jsp"%>
<%
	String INDEX = JspUtil.nullToEmpty(request.getParameter("INDEX"));
	String gate  = JspUtil.nullToEmpty(request.getParameter("gate"));
	
	String url = "mycat_pr_lis1.jsp?INDEX="+INDEX+"&gate="+gate;
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
