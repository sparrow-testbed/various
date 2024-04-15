<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String ev_no 		= JSPUtil.paramCheck(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.paramCheck(request.getParameter("ev_year"));
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/sec.js"></script>
<script src="../js/cal.js" language="javascript"></script>
<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

</head>
<frameset rows="85,*" cols="*" border="0" framespacing="0" frameborder="NO">
<frame src="ev_sheet_top.jsp?ev_no=<%=ev_no %>&ev_year=<%=ev_year %>" name="up" frameborder="NO">
<frame src="ev_sheet_basic.jsp?ev_no=<%=ev_no %>&ev_year=<%=ev_year %>" name="down" frameborder="NO">
</frameset>
</html>
