<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
 
<%	String PR_NO          = JSPUtil.nullToEmpty(request.getParameter("pr_no"));  %>
<html>
<head>
<title>우리은행 전자구매시스템</title>
</head>
<frameset rows="100%,*" frameborder="NO" border="0" framespacing="0" cols="*">
  <frame name="topFrame" noresize src="/kr/dt/ebd/ebd_bd_ins4_main.jsp?pr_no=<%=PR_NO%>" >
  <frame name="mainFrame" src="">
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes>
</html>
