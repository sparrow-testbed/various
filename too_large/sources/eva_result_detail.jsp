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
	String user = info.getSession("ID");

	String dept = "";
	String note = "";
	
	double jungSun = 0;
	double jungYang = 0;
	
	String eval_valuer_refitem = "";
	String eval_item_refitem  = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));
	String eval_refitem       = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type      = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	
	String vendor_name = JSPUtil.nullToEmpty(request.getParameter("vendor_name"));
	String sg_name     = JSPUtil.nullToEmpty(request.getParameter("sg_name"));
	String user_id     = "";
	String eval_name     = JSPUtil.nullToEmpty(request.getParameter("eval_name"));
	//String total_score = JSPUtil.nullToRef(request.getParameter("total_score"),"0");
	//double total = Double.parseDouble(total_score);
	if(user_id.equals(""))
		user_id = user;
	
	String valuer_name = "";
	
	String ret = null;
	SepoaFormater wf = null;	
	SepoaFormater wf2 = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String nickName= "p0080";
	String conType = "CONNECTION";
	String MethodName = "getValuerList1";
	Map<String, String> data = new HashMap<String, String>();
	data.put("eval_item_refitem",eval_item_refitem);
	data.put("user_id",user_id);
	

	Object[] obj = {data};
	
	try {
		value = ServiceConnector.doService(info, "SR_031", "CONNECTION", "getEvaList", obj);
		wf =  new SepoaFormater(value.result[0]);
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	}
%>
<html> 
<head>
	<title>우리은행 전자구매시스템</title>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	 <script language="javascript" src="../../jscomm/crypto.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>
		
	<script language="javascript">
	//<!--
 	function doSubmit() {
 		temp = document.form1.valuer_sel.value;
 		
 		valuer = temp.substring(0, temp.indexOf("|"));
 		dept = temp.substring(temp.indexOf("|")+1, temp.indexOf("_"));
 		note = temp.substring(temp.indexOf("_")+1);
 		
 		document.form1.note.value = note;
 		
 		url = "eva_result_detail_frame.jsp?template_type=<%=template_type%>" + 
 					    "&e_template_refitem=<%=e_template_refitem%>" + 
 					    "&eval_item_refitem=<%=eval_item_refitem%>" +
 					    "&eval_refitem=<%=eval_refitem%>" + 
 					    "&dept=" + dept +
 					    "&eval_valuer_refitem=" + valuer;
 					    
 		listframe.location.href=url;
 	
 	}
 	function init() {
 	 	
 		temp = document.form1.valuer_sel.value;
 		valuer = temp.substring(0, temp.indexOf("|"));
 		dept = temp.substring(temp.indexOf("|")+1, temp.indexOf("_"));
 		note = temp.substring(temp.indexOf("_")+1);
 		
 		document.form1.note.value = note;
 		
 		url = "eva_result_detail_frame.jsp?template_type=<%=template_type%>" + 
 					    "&e_template_refitem=<%=e_template_refitem%>" + 
 					    "&eval_item_refitem=<%=eval_item_refitem%>" +
 					    "&eval_refitem=<%=eval_refitem%>" + 
 					    "&dept=" + dept +
 					    "&eval_valuer_refitem=" + valuer;
 					    
 		listframe.location.href=url;
 	
 	}
 //-->
</script>
	
       

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" onload="javascript:init();">

<s:header>
<!--내용시작-->
<form name="form1">	

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;평가결과
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 업체명</div>
	</td>
	<td width="35%" class="c_data_1" align="left">		
		<div align="left"><%=vendor_name%></div>
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 소싱그룹명</div>
	</td>
	<td width="35%" class="c_data_1" align="left">		
		<div align="left"><%=sg_name%></div>
	</td>
</tr>
<%
	if (wf != null && wf.getRowCount() > 0) {
%>
<br>	
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가자</div>
	</td>
	<td width="35%" class="c_data_1" align="left" colspan="3">		
		<SELECT class=input_re  name="valuer_sel" onChange="javascript:doSubmit();">
<%
		for(int i=0; i < wf.getRowCount(); i++) {
			eval_valuer_refitem = wf.getValue(i, 0);
			dept = wf.getValue(i, 2);
			note = wf.getValue(i, 3);
			valuer_name = wf.getValue(i, 1);
%>
			<option value="<%=eval_valuer_refitem%>|<%=dept%>_<%=note%>" <% if(eval_name.equals(valuer_name)){  %> selected <%}%> ><%=valuer_name%></option>
<%
		}
%>
		</SELECT>
	</td>
</tr>
<%
	}
%>
</table>

<div id="frame1" border="1">
	<iframe name="listframe" src="" width="99%" height="300" frameborder="0"></iframe>       
</div> 	


<br>
<br>
<%
	if(wf != null && wf.getRowCount() > 0) {
%>		
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 비고</div>
	</td>
	<td width="85%" class="c_data_1">
		<textarea rows="3" name="note" cols="110" readonly="readonly"></textarea>
	</td>
</tr>
</table>
<%
	}
%>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<tr>
			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>

</form>

</s:header>
<s:footer/>
</BODY> 
</HTML>


