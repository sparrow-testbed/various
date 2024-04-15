<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp" %>
<%
	String i_flag    = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("i_flag")));
	String i_user_id = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("i_user_id")));
	String target = "user_status_pop_up.jsp";
	
	if (i_flag.equals("B")) {
		target = "user_status_pop_up_b.jsp";
	}
    request.getRequestDispatcher(target).forward(request, response);
%>