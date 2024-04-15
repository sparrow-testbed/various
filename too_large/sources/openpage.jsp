<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Enumeration"%>
<%@page import="sepoa.fw.ses.SepoaSession"%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	//선택한 트리의 id를 넘겨받아서 세션에 저장한다.
	//request.setCharacterEncoding("UTF-8");

	//System.out.println("screen_id="+request.getParameter("screen_id"));
	//System.out.println("contents="+request.getParameter("contents"));
	//System.out.println("language="+request.getParameter("language"));
	//System.out.println("type="+request.getParameter("type"));
	
	/* request parameter key 전체를 보고싶을때 사용 	
	Enumeration enu = request.getParameterNames();
	while(enu.hasMoreElements()){
		System.out.println(enu.nextElement());
	} */
	
	// 사용자의 강제호출을 방지하기 위하여 GET 방식은 에러처리(2016-01-05 보안취약점 강화)
	if ("GET".equals(request.getMethod())) {
		%>
		<script>
			alert("잘못된 접근방법을 사용하였습니다.");
			sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
		</script>
		<%
	}
	
	String id = request.getParameter("id");
	String menuObjectCode = request.getParameter("menuObjectCode");
	String sepoa_screen_name = request.getParameter("sepoa_screen_name");
	String sepoa_screen_path = request.getParameter("sepoa_screen_path");
	String jsp_addr = request.getParameter("jsp_addr");
	
	if(id != null){
		session.setAttribute("treeMenuId", id);
	}	

	if(sepoa_screen_name != null){
        SepoaSession.putValue(request, "SEPOA_SCREEN_NAME", sepoa_screen_name);
		//session.setAttribute("SEPOA_SCREEN_NAME", sepoa_screen_name);	
	}
	if(sepoa_screen_path != null){
        SepoaSession.putValue(request, "SEPOA_SCREEN_PATH", sepoa_screen_path);
		//session.setAttribute("SEPOA_SCREEN_PATH", sepoa_screen_path);	
	}

 	if(menuObjectCode != null){
		session.setAttribute("RECENT_MENU_OBJECT_CODE", menuObjectCode);
		//RequestDispatcher rd = request.getRequestDispatcher(jsp_addr);
		//rd.forward(request, response);
		response.sendRedirect(jsp_addr);
	}
%>
