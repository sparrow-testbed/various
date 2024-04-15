<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	int checkVal = 0;
	String ret = null;
	String title = "";
	String factor_type = "";
	
	SepoaFormater wf = null;	
	SepoaOut value = null; 
	SepoaRemote ws = null;	
	
	String dept                = JSPUtil.nullToEmpty(request.getParameter("dept"));
	String eval_refitem        = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem  = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type       = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	String eval_valuer_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_valuer_refitem"));
	String eval_item_refitem   = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));
	String qnt_flag   		   = JSPUtil.nullToEmpty(request.getParameter("qnt_flag"));
	
	
	if(template_type.equals("2")) {
		if(dept.equals("510007")) {	//구매
			factor_type = "1";
		}else if(dept.equals("510008")) {	//제작
			factor_type = "2";
		}
	}
	
	String nickName= "p0080";
	String conType = "CONNECTION";
	String MethodName = "getEvalTempSelectedFactor";
	Map<String, String> data = new HashMap<String, String>();
	data.put("e_template_refitem",e_template_refitem);
	data.put("template_type",template_type);
	data.put("factor_type",factor_type);
	data.put("eval_valuer_refitem",eval_valuer_refitem);
	data.put("qnt_flag",qnt_flag);
	Object[] obj = {data};
	
	try {
		value = ServiceConnector.doService(info, "SR_032", "CONNECTION", "getEvaDetailList", obj);
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
	 <script language="javascript" src="../../jscomm/crypto.js"></script>
	<script language="javascript" src="../../jscomm/common.js"></script>
	<script language="javascript" src="../../jscomm/menu.js"></script>	
<script language="javascript">
//<!--
 //-->
</script>  
	
<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
</head>
<body onload="" bgcolor="" text="#000000" leftmargin="0" topmargin="0">

<!--내용시작-->
<form name="form1">

<table width="100%" border="0" cellpadding="1" cellspacing="1">
<%
	if(wf != null) {
		int count = 0;
		for(int i=0; i < wf.getRowCount(); i++) {
			int scale = Integer.parseInt(wf.getValue(i, 2));
			String factor_num = wf.getValue(i, 3);
%>
<tr height=25>
	<td colspan="7" class="c_title_1">
		<div align="left"><strong><%=wf.getValue(i, 1)%></strong></div>
	</td>
</tr>
<tr height=25 >
<%
			int selected_seq = Integer.parseInt(wf.getValue(i, 6));
			for(int j=0; j < scale; j++){
				int factor_item_seq = Integer.parseInt(wf.getValue(i+j, 7));
				if (selected_seq == factor_item_seq) {
%>
				<td class="c_data_1">
					<input type="radio" name="factor_<%=factor_num%>" style="border:'0';" checked disabled>
					<b><font color="blue"><%=wf.getValue(i+j, 4)%></font></b>&nbsp;
				</td>
<%
				} else {
%>
				<td class="c_data_1">
					<input type="radio" name="factor_<%=factor_num%>" style="border:'0';" <%if(selected_seq == factor_item_seq){%>checked<%}%> disabled >
					<%=wf.getValue(i+j, 4)%>&nbsp;
				</td>
<%
				}
%>
<%	
			}
			
			i = i + (scale-1);
			count++;
%>
</tr>
<%
		}

		if(wf.getRowCount() == 0) {
%>
			<tr height=25 class="bg3">
				<td colspan="5" bgcolor="white" align="center"><strong><font color="blue" size="3">평가 항목이 없습니다.</font></strong></td>
			</tr>
<%	
		}
	}
%>
</table>				

</form>	

<iframe name="hiddenframe" src="" width="0" height="0"></iframe>

</body>
</html>


