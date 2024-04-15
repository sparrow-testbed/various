<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
function fnBodyOnLoad(){
	var height = ($(window).height() - $('#head_area').height());
	
	document.getElementById("workFrm").style.height = height + 'px';
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascrip:fnBodyOnLoad();">
<s:header>
	<iframe id="workFrm" width="100%" height="100" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" src="/ict/kr/admin/basic/material/mcl_bd_lis2_ict.jsp"></iframe>
</s:header>
<s:footer/>
</body>
</html>