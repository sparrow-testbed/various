<%@ page contentType = "text/html; charset=UTF-8" %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page import="sepoa.fw.util.*" %>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>

<%	
	String user_id 	= JSPUtil.paramCheck (info.getSession("ID"));

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
%>

<%
	String SUBJECT 		  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("SUBJECT")));
	String CONTENT 		  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("CONTENT")));
	String COMPANY_CODE	  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("COMPANY_CODE")));
	String DEPT_TYPE	  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("DEPT_TYPE")));
	String GONGJI_GUBUN   = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("GONGJI_GUBUN")));
	String VIEW_USER_TYPE = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("VIEW_USER_TYPE")));
	String FROM_DATE = SepoaString.getDateUnSlashFormat(JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("from_date"))));
	String TO_DATE = SepoaString.getDateUnSlashFormat(JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("to_date"))));
	
	String pop_chk = request.getParameter("pop_chk");
	String publish_flag="";
	if("true".equals(pop_chk)){
		publish_flag="Y";
	}else{
		publish_flag="N";
	}
	
	if (COMPANY_CODE.length() < 0)
	{
		COMPANY_CODE = "";
	}
	if (DEPT_TYPE.length() < 0)
	{
		DEPT_TYPE = "";
	}
	String ATTACH_NO 	= JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ATTACH_NO")));
	String con_type = request.getParameter("con_type"); // 'N'은 공지사항, 'Q'는 Q&A
      if(con_type == null) con_type = "";	 	  	  

	String[][] args = {{SUBJECT,COMPANY_CODE,DEPT_TYPE,CONTENT,ATTACH_NO,user_id,current_date,current_time,"N", con_type,GONGJI_GUBUN,publish_flag,FROM_DATE,TO_DATE,VIEW_USER_TYPE}};
    
	Object[] obj = {args};
	SepoaOut value = ServiceConnector.doService(info, "I_MT_014", "CONNECTION","setInsertDataStore_New", obj);
%>

<head>
<title></title>

<link rel="stylesheet" href="../../../css/body_create.css" type="text/css">--%>
<Script language="javascript">
	
(function Init()
{
	var con_type = "<%=con_type%>";
	alert("<%=value.message%>");
	parent.go_list('/admin/data_store_list_ict.jsp', 'MUO15070800003', 12, '');

})();

</Script>
<!-- 
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 --> 