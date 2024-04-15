<%-- UTF-8적용 지우지마세요 --%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.fw.ses.*" %>
<%@ page import="sepoa.fw.srv.*" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
	String err_msg = request.getParameter("err_msg");
%>

<script>
	alert("<%=err_msg%>");
	history.back();
</script>
