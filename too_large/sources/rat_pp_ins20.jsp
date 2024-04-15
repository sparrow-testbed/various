<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_003_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_003_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%
    String TYPE = JSPUtil.nullToEmpty(request.getParameter("TYPE"));
%>

<% String WISEHUB_PROCESS_ID="AU_003_2";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>


<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
<!--
	function Save(){
		document.attachFrame.setData();	//startUpload
	}

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];
	
		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}
	
	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;
		
		var f = document.forms[0];
		f.attach_no.value    = attach_key;
		f.attach_count.value = attach_count;
		
		getApprovalSend();
	}

	function getApprovalSend() { 
		var cancle_text  = document.form1.comment.value;
		var sr_attach_no = document.form1.attach_no.value;

		opener.document.form1.cancle_text.value  = cancle_text;
		opener.document.form1.sr_attach_no.value = sr_attach_no;
		opener.doSave("NB");
		window.close();
	}
//-->

	function Save(){
		var cancle_text  = document.form1.comment.value;
		var sr_attach_no = document.form1.attach_no.value;

		opener.document.form1.cancle_text.value  = cancle_text;
		opener.document.form1.sr_attach_no.value = sr_attach_no;
		opener.doSave("NB");
		window.close();
	}
	

	function goAttach(attach_no){
		attach_file(attach_no,"TEMP");
	}

	function setAttach(attach_key, arrAttrach,rowId, attach_count) {
		document.form1.attach_no.value = attach_key;
		document.form1.attach_no_count.value = attach_count;
	}	
	
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">

<s:header popup="true">
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">	
<tr>
	<td height="30" align="right">
		<table>
		<tr>
<%
		if(!TYPE.equals("DIS")){
%>
			<td><script language="javascript">btn("javascript:Save()","유 찰")</script></td>
<%
		}
%>
			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
		</tr>
		</table>
	</td>
</tr>
</table>


<form id="form1" name="form1" method="post" action="">
<!-- 	<input type="hidden" id="attach_no"     name="attach_no"    	value=""> -->
	<input type="hidden" id="attach_count"  name="attach_count" 	value="">
	<input type="hidden" id="att_mode"  	name="att_mode"  		value="">
	<input type="hidden" id="view_type"  	name="view_type"  		value="">
	<input type="hidden" id="file_type"  	name="file_type"  		value="">
	<input type="hidden" id="tmp_att_no" 	name="tmp_att_no" 		value="">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
<tr>
	<td class="data_td" colspan="4" style="height: 200px;">
		<textarea name="comment" style="width:98%;height: 98%;" class="inputsubmit" maxlength=400 rows="5"></textarea>
	</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
  		<td width="15%" class="title_td"> 첨부파일</td>
		<td class="data_td" colspan="4">
			<table>
				<tr>
					<td>
						<script language="javascript">btn("javascript:goAttach($('#attach_no').val())", "<%=text.get("AU_003_2.TEXT_01")%>")</script>
					</td>
					<td>
						<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
						<input type="hidden" value="" name="attach_no" id="attach_no">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

</form>

</s:header>
<%-- <s:grid screen_id="AU_003_2" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','C','RA',form1.attach_no.value);</script> --%>


