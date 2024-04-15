<%@ include file="/include/sepoa_common.jsp" %>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<%
	String i_flag    = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("i_flag")));
	String i_user_id = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("i_user_id")));
	String user_flag = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_flag")));
	String totalCnt 		 = JSPUtil.nullToEmpty(request.getParameter("totalCnt"));
	String target = "use_bd_upd2.jsp";

	if (i_flag.equals("B"))
		target = "use_bd_upd3.jsp";
%>
<frameset rows="100%,*" frameborder="NO" border="0" framespacing="0" cols="*">
  <frame name="body" noresize src="/kr/master/user/<%=target%>?i_flag=<%=i_flag%>&i_user_id=<%=i_user_id%>&user_flag=<%=user_flag %>&totalCnt=<%=totalCnt%>">
  <frame name="work" src="about:blank">
</frameset>
<noframes><body bgcolor="#FFFFFF">
</body></noframes>
</html>
