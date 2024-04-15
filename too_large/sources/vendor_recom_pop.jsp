<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_105");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_105";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SU_105";%>
						
<HTML>
<HEAD>
	<script language="javascript">
	<!--
    	function recom_search(user_name)
    	{
    		f = document.charge_f;
    		f.user_name.value = user_name;
    		
		f.target = "recom_list";
		f.action = "vendor_recom_list.jsp";
		f.submit();
        }
        
        function s_select(user_id, user_name) {
        	opener.s_select(user_id, user_name);
        	self.close();
        }
        
        function closeWin() {
        	self.close();
        }
        
//-->
	
	</script>
  
<html> 
<head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="/include/include_css.jsp"%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
	<%-- Ajax SelectBox용 JSP--%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>


</head>
<body onload="" TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000">

<s:header popup="true">
<!--내용시작-->
	<table border=0 cellpadding=0 cellspacing=0 width="100%">

	<form name="charge_f" method="post">
		<input type="hidden" name="user_name">
	</form>
	
   	<tr>
   		<td>
		<div id="frame1" align="center">
    		<iframe name="recom_top" src="vendor_recom_top.jsp" width="98%" height="163" frameborder="0" align="center"></iframe>       
   		</div>	
		<div id="frame2" align="center">
    		<iframe name="recom_list" src="vendor_recom_list.jsp" width="98%" height="220" frameborder="0" align="center"></iframe>       
		</div>
   		</td>	
   	</tr>	
   	</table>	
<TABLE width="94%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:closeWin()","닫 기")</script></TD>
		</TR>
		</TABLE>
</TR>
</TABLE>
   	
	<!-- 본문 끝 -->

</s:header>
<%-- <s:grid screen_id="SU_105" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</BODY> 
</HTML>


