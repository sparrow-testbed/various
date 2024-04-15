<%@ page import="sepoa.fw.util.*"%>
<%
String type 	= JSPUtil.nullToEmpty(request.getParameter("type"));
String flag 	= JSPUtil.nullToEmpty(request.getParameter("flag"));
String item_no  = JSPUtil.nullToEmpty(request.getParameter("item_no"));

response.sendRedirect("../new_material/real_pp_lis1.jsp?ITEM_NO="+item_no);
%>

