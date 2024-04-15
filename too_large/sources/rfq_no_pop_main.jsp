<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<% String WISEHUB_PROCESS_ID="RQ_237";%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<frameset rows="75,*" cols="*" frameborder="NO"> 
  <frame src="rfq_no_pop_t.jsp" frameborder="NO" name="code_t">
  <frameset rows="*,75" cols="*" frameborder="NO"> 
    <frame src="rfq_no_pop_c.jsp" name="code_c">
    <frame src="rfq_no_pop_b.jsp" name="code_b">
  </frameset>
</frameset>
<noframes>

</head>
<body onload="" bgcolor="#FFFFFF" text="#000000">

<s:header popup="true">
<!--내용시작-->
</body>
</noframes> 
</html>

</s:header>
<s:footer/>


