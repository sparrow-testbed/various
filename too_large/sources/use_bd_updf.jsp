<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="sepoa.fw.util.*"%> 
<html>
<head>
<title>우리은행 전자구매시스템</title>
</head>
<%
	String flag         = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String user_flag    = JSPUtil.nullToEmpty(request.getParameter("user_flag"));
	String user_id      = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	String os_gb       = JSPUtil.nullToRef(request.getParameter("os_gb"),"win10");
	
	String target       = "use_bd_upd2.jsp"; // 사용자 리스트의 수정화면에서의 수정
	if (os_gb.equals("win10")) {
		target       = "use_bd_upd2_window10.jsp"; // 사용자 리스트의 수정화면에서의 수정
	}
	
	//사용안하는걸로 추정
	if (flag.equals("B")){
		if (os_gb.equals("win10")) {
			target       = "use_bd_upd3_window10.jsp"; // 최상단 메뉴에서의 user_info라는 수정화면
		}else{
			target = "use_bd_upd3.jsp"; //최상단 메뉴에서의 user_info라는 수정화면
		}
	}
%>
<frameset rows="100%,*" frameborder="NO" border="0" framespacing="0" cols="*"> 
  <frame name="body" noresize src="/s_kr/admin/user/<%=target%>?flag=<%=flag%>&user_flag=<%=user_flag%>&user_id=<%=user_id%>">
  <frame name="work" src="about:blank">
</frameset>
<noframes><body bgcolor="#FFFFFF">
</body></noframes>
</html>
