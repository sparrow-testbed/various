<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<% String WISEHUB_PROCESS_ID="I_RQ_237_03";%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<body  width="450" onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header popup="true">
<!--내용시작-->
<form name="form1" >
  	<table width="450" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:parent.window.close()","닫 기")    </script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>

</s:header>
<s:footer/>
</body>
</html>


