<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<%

	String eval_refitem        = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem  = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type       = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	String eval_valuer_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_valuer_refitem"));
	String eval_item_refitem   = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));
	String eval_name   			= JSPUtil.nullToEmpty(request.getParameter("eval_name"));
	String eval_dept_name		= JSPUtil.nullToEmpty(request.getParameter("eval_dept_name"));
	String vendor_name			= JSPUtil.nullToEmpty(request.getParameter("vendor_name"));
	
%>
<html> 
<head>
	<title>우리은행 전자구매시스템</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="/include/include_css.jsp"%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>	
	<script language="javascript">
	//<!--
 	function setData()
 	{
 		this.listframe.setData();
   	}
    	
	function getNote() {
		return document.form1.note.value;
	}
	
	function onClose() {
		opener.getQuery();
		window.close();
	}
 //-->
</script>  

</head>       
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" onLoad="">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;제안 평가
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="12%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가업체 </div>
	</td>
	<td class="c_data_1" align="left">		
		<%=vendor_name%>
	</td>
	<td width="12%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가자 </div>
	</td>
	<td width="21%" class="c_data_1" align="left">		
		<%=eval_name%>
	</td>
	<td width="12%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가자 소속 </div>
	</td>
	<td width="21%" class="c_data_1" align="left">		
		<%=eval_dept_name%>
	</td>
</tr>
</table>

<div id="frame1">
<%-- 	<iframe name="listframe" src="eva_list_pop1_frame.jsp?template_type=<%=template_type%>&e_template_refitem=<%=e_template_refitem%>&eval_valuer_refitem=<%=eval_valuer_refitem%>&eval_item_refitem=<%=eval_item_refitem%>&eval_refitem=<%=eval_refitem%>" width="100%" height="450" frameborder="0" boder="0"></iframe>        --%>
	<iframe name="listframe" src="/kr/master/evaluation/eva_list_pop1_frame.jsp?template_type=<%=template_type%>&e_template_refitem=<%=e_template_refitem%>&eval_valuer_refitem=<%=eval_valuer_refitem%>&eval_item_refitem=<%=eval_item_refitem%>&eval_refitem=<%=eval_refitem%>" width="100%" height="450" frameborder="0" boder="0"></iframe>       
</div>  

<form name="form1">
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 비고</div>
	</td>
	<td width="85%" class="c_data_1">
		<textarea rows="3" name="note" cols="110"></textarea>
	</td>
</tr>
</table>
</form>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<tr>
			<td><script language="javascript">btn("javascript:setData()","실 행")</script></td>
			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
	
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
</BODY> 
</HTML>
