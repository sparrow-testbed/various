<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("AD_049");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String content = JSPUtil.paramCheck(request.getParameter("contents"));
	String opener_function_name = JSPUtil.paramCheck(request.getParameter("opener_function_name"));
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<Script language="javascript">
	function callBack()
	{
		if(LRTrim(document.form.subject.value) == "")
		{
			//제목은 필수 입력 사항입니다.
			alert("<%=text.get("AD_049.msg_subject")%>");
			document.form.subject.focus();
			return;
		}

		if(LRTrim(document.form.content_back.value) == "")
		{
			//내용은 필수 입력 사항입니다.
			alert("<%=text.get("AD_049.msg_contents")%>");
			document.form.content_back.focus();
			return;
		}

		if (confirm("<%=text.get("AD_049.msg_0002")%>")){
			opener.<%=opener_function_name%>(document.form.subject.value, document.form.content_back.value);
			parent.window.close();
		}
	}

	function doCancel() {
		parent.window.close();
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
							<td  align="center" class="div_input_re" width="10%">
								<%=text.get("AD_049.txt_subject")%><%--제목 --%>
							</td>
							<td  align="center" class="div_data">
								<input type="text" name="subject" style="width:100%">
							</td>
						</tr>
						<tr>
							<td  align="center" class="div_input_re" width="10%">
								<%=text.get("AD_049.txt_contents")%><%--내용 --%>
							</td>
							<td  align="center" class="div_data">
								<textarea name="content_back" rows="20" class="inputsubmit" style="width:100%" ><%=content%></textarea>
							</td>
						</tr>
				  </table>
		  		</td>
		  	</tr>
		  <!-- button start-->
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="6" colspan="2"></td>
							</tr>
							<tr>
								<td width="100%" height="40" align="center">
								<table border="0" cellspacing="3" cellpadding="0">
									<tr>
										<TD><script language="javascript">btn("javascript:callBack()" , "<%=text.get("BUTTON.confirm")%>")</script></TD>
	    	  							<TD><script language="javascript">btn("javascript:doCancel()" , "<%=text.get("BUTTON.close")%>")</script></TD>
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
