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
	
	String dept = JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	
	String eval_refitem        = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String e_template_refitem  = JSPUtil.nullToEmpty(request.getParameter("e_template_refitem"));
	String template_type       = JSPUtil.nullToEmpty(request.getParameter("template_type"));
	String eval_valuer_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_valuer_refitem"));
	String eval_item_refitem   = JSPUtil.nullToEmpty(request.getParameter("eval_item_refitem"));

/*
	if(template_type.equals("2")) 
	{
		if(dept.equals("510007")) {	//구매
			factor_type = "1";
		}else if(dept.equals("510008")) {	//제작
			factor_type = "2";
		}
	}
*/
// 	String nickName= "p0080";
// 	String conType = "CONNECTION";
// 	String MethodName = "getEvalTempFactorList";
	
	Map<String, String> data = new HashMap<String, String>();
	data.put("e_template_refitem",e_template_refitem);
	data.put("template_type",template_type);
	
	Object[] obj = { data };
	
	try {
		value = ServiceConnector.doService(info, "SR_030", "CONNECTION", "getEvaList", obj);
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
	<%@ include file="/include/include_css.jsp"%>
	<%-- Dhtmlx SepoaGrid용 JSP--%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

	<script language="javascript">
	//<!--
 	function setData()
 	{
 		f = document.form1;
 		var e_factor_refitem = "";
 		var answered_seq = "";
 		var answered_score = "";
 		var answered_num = "";
 		var weight = "";
 		var max_score = "";
 		var count = document.form1.count.value;
 		
 		var i = 0;
	 		for(i=0; i < count; i++) 
	 		{
	 			if(document.getElementById("answered_seq_"+i).value == '') 
	 			{
	 				alert('모든항목을 빠짐없이 체크해주세요.');
	 				return;
	 			}
	 		}

 		var value = confirm('평가점수를 등록하시겠습니까?');
 		if(value) 
 		{
 			var note = escape(parent.getNote());
 	      	document.form1.note.defaultValue = note;
 	      	document.form1.count.value = count;

 			//세포아 ajax 처리부분
 	        var nickName        = "SR_030";
 	        var conType         = "TRANSACTION";
 	        var methodName      = "setEvaDetailInsert";
 	        var value1        = doServiceAjax( "SR_030","TRANSACTION", "setEvaDetailInsert" );
 	        var value2       = doServiceAjax( "SR_030", "TRANSACTION", "checkComplete" );

 	   	if(value1.status == 1){
			if(value2.message != null && value2.message=="complete") {
				alert('평가 업체에대한 모든 평가자의 평가가 완료 되었습니다.');
			}else if(value2.message != null && value2.message=="all_complete") {
				alert('해당평가가 모두 완료 되었습니다.\n평가결과를 확인하세요.');
			}else if(value2.message == "null") {
				alert('평가가 완료되었습니다.');
			}else{
				alert('해당평가가 모두 완료 되었습니다.\n평가결과를 확인하세요.');
			}
			parent.onClose();
			parent.opener.getQuery();
		}else{
			alert('등록실패');
			parent.onClose();
			
	}
 		}
 	}
	function checkData(cnt, value, itemScore, item_num) 
	{
			document.getElementById("answered_seq_"+cnt).value = value
			document.getElementById("answered_score_"+cnt).value = itemScore;
			document.getElementById("answered_num_"+cnt).value = item_num;
	}
	
	function onClose() 
	{
		parent.onClose();
	}
    	
 //-->
 
</script>  

</head>
<body onload="" bgcolor="" text="#000000" leftmargin="0" topmargin="0">

<!--내용시작-->
<form name="form1">

<table width="100%" border="0" cellpadding="1" cellspacing="1">

	<input type="hidden" name="eval_valuer_refitem" id="eval_valuer_refitem" value="<%=eval_valuer_refitem%>">
	<input type="hidden" name="eval_item_refitem" id="eval_item_refitem" value="<%=eval_item_refitem%>">
	<input type="hidden" name="eval_refitem" id="eval_refitem" value="<%=eval_refitem%>">
	<div style="display: none">
	<textarea name="note" id="note"></textarea>
	</div>
<%
	int count = 0;
	for(int i=0; i < wf.getRowCount(); i++) {
		int scale = Integer.parseInt(wf.getValue(i, 2));
		String factor_num = wf.getValue(i, 3);
%>
<tr height=25>
	<td colspan="7" class="c_title_1">
		<div align="left"><strong><%=wf.getValue(i, 1)%></strong></div>
		<input type="hidden" name="answered_seq_<%=count %>" id="answered_seq_<%=count %>"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="answered_score_<%=count %>" id="answered_score_<%=count %>"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="answered_num_<%=count %>" id="answered_num_<%=count %>"><!--선택된 값이 담긴다.-->
		<input type="hidden" name="weight_<%=count %>" id="weight_<%=count %>" value="<%=wf.getValue(i, 6)%>" >
		<input type="hidden" name="e_factor_refitem_<%=count %>" id="e_factor_refitem_<%=count %>" value="<%=factor_num%>" >
		
	</td>
</tr>
<tr height=25 >
<%
		int maxScore = 0;
		int itemScore = 0;
		for(int j=0; j < scale; j++){
			itemScore = Integer.parseInt(wf.getValue(i, 7));
			if(itemScore > maxScore) maxScore = itemScore;
%>
		<td class="c_data_1">
			<input type="radio" name="factor_<%=factor_num%>" id="factor_<%=factor_num%>" style="border:'0';" onClick="javascript:checkData(<%=count%>, <%=wf.getValue(i+j, 5)%>, <%=wf.getValue(i+j, 7)%>, <%=wf.getValue(i+j, 8)%>);">
			<%=wf.getValue(i+j, 4)%>&nbsp;
		</td>
<%	
		}
	
		i = i + (scale-1);
%>
<input type="hidden" name="item_maxscore_<%=count %>" id="item_maxscore_<%=count %>" value="<%=maxScore%>">
</tr>
<%
		count++;
	}
%>
<input type="hidden" name="count" id="count" value="<%=count%>">

</table>
				
</form>	
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
</body>
</html>


