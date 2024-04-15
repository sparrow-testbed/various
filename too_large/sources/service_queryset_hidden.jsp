﻿<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
%>
<%--
<html>
<head>
<title>Popup/list Create(General)</title>

<!-- META TAG 정의  -->
<!-- Wisehub Common Scripts -->

<link rel="stylesheet" href="/css/mobis.css" type="text/css"> --%>

<%
    String[] straData = new String[9];
	straData[0] = request.getParameter("type")+request.getParameter("id");
	straData[1] = request.getParameter("Title");
	straData[2] = request.getParameter("type");
	straData[3] = request.getParameter("Description");
	straData[4] = request.getParameter("List_Item");
	straData[5] = request.getParameter("SQL");
	straData[6] = request.getParameter("use_flag");
	straData[7] = request.getParameter("auto_select_flag");
	straData[8] = request.getParameter("language");
	SepoaOut value = null;
	try {
		/* Create Ejb Home */
		//CommonSql master;
		//Object objref = ServiceLocator.getInstance().WiseContext("CommonSql", info);
		//CommonSqlHome home = (CommonSqlHome) PortableRemoteObject.narrow(objref, CommonSqlHome.class);
		//master = home.create();

		/* change that 'how to ejb call' */
		//value = master.insertCode(info, straData);
		Object[] obj = {info,straData};
		value = ServiceConnector.doService(info, "AD_037", "CONNECTION","insertCode", obj);

	} catch (Exception e) {
		Logger.debug.println(e.toString());

	}



%>
<%-- [{
	"status":"<%=value.status%>",
	"message":"<%=value.message%>"
}] --%>

<Script language="javascript">
	var status = "<%=value.status%>";
	var message = '<%=value.message%>';
	(function Init() {
	   if(status == '0') {
	    	alert("Code Created ");
			top.opener.doQuery();
			close();
	    } else {
	        alert(message);
	    }
	})();


</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html> -->