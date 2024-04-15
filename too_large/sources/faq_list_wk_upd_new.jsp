<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	String user_id 	= JSPUtil.nullToEmpty(info.getSession("ID"));
%>

<%
	String SEQ			  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("SEQ")));
	String COMPANY_CODE   = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("COMPANY_CODE")));
	String SUBJECT 		  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("SUBJECT")));
	String CONTENT 		  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("CONTENT")));
	
	String DEPT_TYPE	  = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("DEPT_TYPE")));
	String GONGJI_GUBUN   = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("GONGJI_GUBUN")));	
	String VIEW_USER_TYPE = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("VIEW_USER_TYPE")));	
	
	String ATTACH_NO 	= JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ATTACH_NO")));
	
	String FROM_DATE 	= JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("from_date")));
	String TO_DATE 		= JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("to_date")));
	
	if (COMPANY_CODE.length() < 0)
	{
		COMPANY_CODE = "";
	}
	if (FROM_DATE==null && TO_DATE ==null )
	{
		FROM_DATE = "";
		TO_DATE = "";
	}
	
	
	String[][] obj = {{SUBJECT,COMPANY_CODE,CONTENT,ATTACH_NO,user_id,"R",SEQ,DEPT_TYPE,GONGJI_GUBUN,FROM_DATE,TO_DATE,VIEW_USER_TYPE}};

	SepoaOut value = ServiceConnector.doService(info, "MT_014", "TRANSACTION","modify_New_faq", obj);
%>
<%-- [{
	"message":"<%=value.message%>"
}] --%>
<!-- <html>
<head>
<title></title>

<link rel="stylesheet" href="../../../css/body_create.css" type="text/css"> -->
<Script language="javascript">
(function Init()
{
	alert("<%=value.message%>");
	parent.go_list('/admin/faq_list_new.jsp', 'MUO140100005', 7, '');
// 	location.href="faq_list_new.jsp";
})();
</Script>
<!-- 
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->