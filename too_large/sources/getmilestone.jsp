<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String screen_name = sepoa.fw.ses.SepoaSession.getAllValue(request).getSession("SEPOA_SCREEN_NAME");
%>

{"screen_name":"<%=screen_name%>"}