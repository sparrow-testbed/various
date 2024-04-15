<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	try {
		String screen_id = request.getParameter("screen_id") == null ? "" : request.getParameter("screen_id");
		String user_id   = request.getParameter("user_id")   == null ? "" : request.getParameter("user_id");
		
		if(screen_id.length() > 0 && user_id.length() > 0) {
			MessageUtil.setGridUserOrderWidthClear(info, screen_id, user_id);
		}
	} 
	catch(Exception e) {}
	finally {}
%>