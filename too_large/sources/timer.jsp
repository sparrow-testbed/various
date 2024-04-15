<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<html>
<head>
<script>
function timer_s(){
	setTimeout(function(){location.href = '/common/timer.jsp'}, 1000 * 60 * 2);
}
</script>
</head>
<body onload="timer_s()"></body>
</html>