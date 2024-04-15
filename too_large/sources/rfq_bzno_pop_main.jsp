<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>

<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<% String WISEHUB_PROCESS_ID="I_RQ_237";%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<frameset rows="60,*" cols="500" frameborder="NO"> 
  <frame src="rfq_bzNo_pop_t.jsp" frameborder="NO" name="code_t"  scrolling="no">
  <frameset rows="*,60" cols="500" frameborder="NO"> 
    <frame src="rfq_bzNo_pop_c.jsp?flag=<%=JSPUtil.nullToRef(request.getParameter("flag"),"")%>" name="code_c" scrolling="auto">
    <frame src="rfq_bzNo_pop_b.jsp" name="code_b" scrolling="no">
  </frameset>
</frameset>
<noframes>

</head>
<body  width="450" onload="" bgcolor="#FFFFFF" text="#000000">

<s:header popup="true">
<!--내용시작-->
</body>
</noframes> 
</html>

</s:header>
<s:footer/>


