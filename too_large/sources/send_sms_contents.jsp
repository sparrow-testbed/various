<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_050");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

    Object[] obj = {info};
    SepoaOut value = ServiceConnector.doService(info, "AD_049", "CONNECTION", "getSenderPhoneNO", obj);
    SepoaFormater wf = new SepoaFormater(value.result[0]);

	String sender_phoneno = "";
	if(wf.getRowCount() > 0) {
		sender_phoneno				= wf.getValue("phone_no2", 				0);
	}

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<Script language="javascript">
	function callBack() {
		if(document.form.content.value == "")
		{
			alert("<%=text.get("AD_050.msg_0001")%>");
			return;
		}
		if(document.form.sender_name.value == "" || document.form.sender_phoneno.value == "")
		{
			alert("<%=text.get("AD_050.msg_0002")%>");
			return;
		}

		if (confirm("<%=text.get("AD_050.confirm_msg")%>"))
		{
			opener.sendSmsContents(document.form.content.value,document.form.sender_phoneno.value);
			parent.window.close();
		}
	}

	function doCancel() {
		parent.window.close();
	}

	function length_check(obj, max_length)
	{
		var len = getLength2Bytes(obj.value);
		document.form.content_length.value = len;

		if(len > max_length)
		{
			alert("<%=text.get("AD_050.msg_0003")%>");
			SubStrLen2Bytes(obj, max_length);
		}
	}

	function initContent()
	{
		length_check(document.form.content, 80);
	}

	function SubStrLen2Bytes(obj, max_length)
	{
		obj.value = getSubStrLength2Bytes(obj.value, max_length);
		initContent();
		obj.focus();
		return;
	}

</script>
</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0">
<s:header popup="true">
<form name="form" method="post" action="">
<input type="hidden" name="duplicate_flag" value="ng">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
    <%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">


					<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">

						<tr>
						  	 <td width="30%" class="div_input" align="center"><%=text.get("AD_050.sender")%></td>
						     <td width="70%" class="div_data">
						     <input type="text" readonly value="<%=info.getSession("NAME_LOC") %>" name="sender_name" size="15" class="input_empty" maxlength="20">
						     </td>
						</tr>
						<tr>
				     		 <td width="30%" class="div_input" align="center"><%=text.get("AD_050.phone")%></td>
				     		 <td width="70%" class="div_data">
				     		 <input type="text" readonly value="<%=sender_phoneno %>" name="sender_phoneno" size="15" class="input_empty" maxlength="20">
				     		 </td>
					   	</tr>


						<tr>
							<td width="30%" class="div_input_re" align="center" height="80"><%=text.get("AD_050.sms_content")%>
							<br>
							(
							<input type="text" name="content_length" size="3" maxlength="3" class="inputsubmit">
							<%=text.get("AD_050.str")%>
							)
							</td>
							<td  align="center" colspan="3" class="div_data" height="80">
								<textarea name="content" class="inputsubmit" cols="5" style="width:100%" rows="5" onkeyup="length_check(this, 80)"></textarea>
							</td>
						</tr>

				  </table>


		  	</tr>
		  <!-- button start-->

						<table width="100%" border="0" cellspacing="0" cellpadding="0" >
							<tr>
								<td height="6" colspan="2"></td>
							</tr>

							<tr>
								<td width="100%" height="40" >
								<table border="0" cellspacing="3" cellpadding="0" align="center">
									<tr>
										<TD><script language="javascript">btn("javascript:callBack()" , "<%=text.get("AD_050.btn_sms_carry")%>")</script></TD>
	    	  							<TD><script language="javascript">btn("javascript:doCancel()" , "<%=text.get("AD_050.btn_cancel")%>")</script></TD>
									</tr>
								</table>
								</td>
							</tr>
						</table>

		<!-- button end-->


		  <table width="100%" border="0" cellpadding="0" cellspacing="0">
		  <TR><TD>&nbsp;</TD></TR>
		  </TABLE>

<%-- 				<%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>

</form>
</s:header>
<s:footer/>
</body>
</html>
