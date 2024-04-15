<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	String headText  = JSPUtil.nullToEmpty(request.getParameter("headText"));
	String headWidth = JSPUtil.nullToEmpty(request.getParameter("headWidth"));
	String screen_id = JSPUtil.nullToEmpty(request.getParameter("screen_id"));
	String user_id   = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	
	if(headText.length() > 0 && headWidth.length() > 0 && screen_id.length() > 0 && user_id.length() > 0) {
		MessageUtil.setGridUserOrderWidthSave(info, headText, headWidth, screen_id, user_id);
	}
%>