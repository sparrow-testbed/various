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
	String dept = "";
	String note = "";
	
	float jungSun = 0;
	float jungYang = 0;
	
	
	String eval_valuer_refitem = "";
	String eval_item_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));
	String eval_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	
	String vendor_name = JSPUtil.nullToEmpty(request.getParameter("vendor_name"));
	String sg_name = JSPUtil.nullToEmpty(request.getParameter("sg_name"));
	String total_score = JSPUtil.nullToRef(request.getParameter("total_score"),"0");
	String qnt_score = JSPUtil.nullToRef(request.getParameter("qnt_score"),"0");
	String qnt_n_score = JSPUtil.nullToRef(request.getParameter("qnt_n_score"),"0");
	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	
	float total = Float.parseFloat(total_score);
	jungYang = Float.parseFloat(qnt_score);
	jungSun = Float.parseFloat(qnt_n_score);
	
	String ret = null;
	SepoaFormater wf = null;	
	//WiseFormater wf2 = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String nickName= "SR_025";
	String conType = "CONNECTION";
	String MethodName = "getValuerList";
	Object[] obj = { eval_item_refitem };
	
	try 
	{
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);	
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	}finally{
		try{
			ws.Release();
		}catch(Exception e){}
	}
	
	 
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

 	function init() 
 	{
 		temp = document.form1.valuer_sel.value;

		if(temp != "")
		{ 		
	 		valuer = temp.substring(0, temp.indexOf("|"));
	 		dept = temp.substring(temp.indexOf("|")+1, temp.indexOf("_"));
	 		note = temp.substring(temp.indexOf("_")+1);
	 		
	 		document.form1.note.value = note;
	 		
	 		url = "eva_list_pop2_frame.jsp?template_type=<%=template_type%>" + 
	 					    "&e_template_refitem=<%=e_template_refitem%>" + 
	 					    "&eval_item_refitem=<%=eval_item_refitem%>" +
	 					    "&eval_refitem=<%=eval_refitem%>" + 
	 					    "&qnt_flag=N" +
	 					    "&dept=" + dept +
	 					    "&eval_valuer_refitem=" + valuer;
	 					    
	 		listframe.location.href=url;
		}
	
 		url = "eva_list_pop2_frame.jsp?template_type=<%=template_type%>" + 
		    "&e_template_refitem=<%=e_template_refitem%>" + 
		    "&eval_item_refitem=<%=eval_item_refitem%>" +
		    "&eval_refitem=<%=eval_refitem%>" + 
		    "&qnt_flag=Y" +
		    "&dept=" + dept +
		    "&eval_valuer_refitem=" + valuer;
<%-- 		url = "eva_list_pop3_frame.jsp? template_type=<%=template_type%>" + e_template_refitem=<%=e_template_refitem%>" +  --%>
<%-- 	 					    "&vendor_code=<%=vendor_code%>" + --%>
<%-- 	 					    "&eval_refitem=<%=eval_refitem%>"  --%>
// 	 					   ;
	 					    
	 	listframeQnt.location.href=url;
 	}
 //-->
</script>  
</head>       
<BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000" onLoad="javascript:init();">
<s:header popup="true">
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;평가 결과 상세
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
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 업체명</div>
	</td>
	<td width="35%" class="c_data_1" align="left">		
		<div align="left"><%=vendor_name%></div>
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 소싱그룹</div>
	</td>
	<td width="35%" class="c_data_1" align="left">		
		<div align="left"><%=sg_name%></div>
	</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:window.close()","닫 기")  </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<strong>◆&nbsp;평가결과</strong>
<form name="form1">
<%
	if(wf != null && wf.getRowCount() > 0) {
%>		
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가자</div>
	</td>
	<td width="85%" class="c_data_1" align="left">		
		<SELECT class=input_re  name="valuer_sel" onChange="javascript:init();">
<%
		for(int i=0; i < wf.getRowCount(); i++) {
			eval_valuer_refitem = wf.getValue("EVAL_VALUER_REFITEM", i);
			dept 				= wf.getValue("DEPT", i);
			note 				= wf.getValue("NOTE", i);
%>
			<option value="<%=eval_valuer_refitem%>|<%=dept%>_<%=note%>"><%=wf.getValue("USER_NAME_LOC", i)%></option>
<%
		}
%>
		</SELECT>
	</td>
</tr>
</table>
<br>
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="25%" class="c_title_1">
		<div align="center">구분</div>
	</td>
	<td width="25%" class="c_title_1">
		<div align="center">정성평가</div>
	</td>
	<td width="25%" class="c_title_1">
		<div align="center">정량평가</div>
	</td>
	<td width="25%" class="c_title_1">
		<div align="center">합계</div>
	</td>
</tr>
<tr>
	<td width="25%" class="c_title_1">
		<div align="center">평가점수</div>
	</td>
<%
	if(wf != null && wf.getRowCount() > 0 ) {
		Logger.debug.println(info.getSession("ID"),request,"total = " + total);	
		Logger.debug.println(info.getSession("ID"),request,"jungYang = " + jungYang);	
		Logger.debug.println(info.getSession("ID"),request,"jungSun = " + jungSun);	
	} else if(wf != null && wf.getRowCount() > 0) {
		jungSun = total;
	} 
%>
	<%--정성평가점수--%>
	<td width="25%" class="c_data_1">
		<div align="center"><%=jungSun%></div>
	</td>
	<%--정량평가점수--%>
	<td width="25%" class="c_data_1">
		<div align="center"><%=jungYang%></div>
	</td>
	<%--합계점수--%>
	<td width="25%" class="c_data_1">
		<div align="center"><%=total_score%></div>
	</td>
</tr>
</table>
<br>
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 비고</div>
	</td>
	<td width="85%" class="c_data_1">
		<textarea rows="3" name="note" cols="80" readonly="readonly"></textarea>
	</td>
</tr>
</table>

<%
	} else {
%>
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="center">평가 항목이 없습니다.</div>
	</td>
</tr>
</table>
<%
	}
%>
<br> 
<strong>◆&nbsp;정성평가</strong> 
 <div id="frame1" border="1">
	<iframe name="listframe" src="" width="99%" height="200" frameborder="0"></iframe>       
</div> 	
<br>
<strong>◆&nbsp;정량평가</strong>
<div id="frame2" border="1">
	<iframe name="listframeQnt" src="" width="99%" height="200" frameborder="0"></iframe>       
</div> 	
 

</form>
</s:header>
<s:footer/>
</BODY> 
</HTML>
