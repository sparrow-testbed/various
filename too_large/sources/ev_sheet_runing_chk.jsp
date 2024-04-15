<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%

    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

/*  넘어온 파라미터 값 셋팅  START */
	String ev_no	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ev_no")));
	String ev_year	 	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("ev_year")));	
	String est_no	     = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("est_no")));
	String seller_code	 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("seller_code")));
/*  넘어온 파라미터 값 셋팅  END */

	Object[] obj = { ev_no, ev_year, est_no, seller_code };
	SepoaOut value = ServiceConnector.doService(info, "WO_031", "CONNECTION","srgvn_tbl_chk", obj);

%>
<html>
<head>
<script language="javascript">
function init(){
	<%if( value.flag ){%>
		parent.doDetailInsert_2("<%=value.result[0]%>");
	<%}else{%>
		parent.location.href = "/errorPage/errorPage.jsp";
	<%}%>
}
</script>
</head>
<body onload = "init();">
<form name="frm" method="post">
</form>
</body>
</html>