<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_048");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");
    String user_id = info.getSession("ID");
	String change_user_id = JSPUtil.CheckInjection(JSPUtil.nullChk(request.getParameter("change_user_id"))).trim().toLowerCase();

	/*if(info.getSession("IS_ADMIN_USER").equals("false"))
	{	%>
		<script>
			alert("<%=text.get("AD_048.autho_not_had")%>");
			history.go(-1);
		</script>
<%
	}*/
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>
<script>
	function PopupManager()
	{
		//PopupCommon1( "SP0268", "D",  "", "ID", "Name" );
		var arrValue = new Array();
		arrValue[0]="<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1]="";
		arrValue[2]="";
		
		var arrValue1 = new Array();
		arrValue1[0] = "USER_ID";
		arrValue1[1] = "COMPANY_NAME";
		PopupCommonArr("SP0268","SP0268_getCode",arrValue,arrValue1);
	}

	function SP0268_getCode(company_code, company_name, user_id) {
		document.forms[0].change_user_id.value = user_id;
	}

	function user_change()
	{
		document.form.method = "POST";
		document.form.action = "user_change.jsp";
		document.form.type.value = "C";
		document.form.submit();
	}

	function init()
	{
	<%	if(change_user_id.length() > 0) {	%>
<%-- 			document.form.method = "POST";
			document.form.action = "../common/login_process.jsp";
			document.form.target = "WholeHidden";
			document.form.force_login_flag.value = "true";
			document.form.user_id.value = "<%=change_user_id%>";
			document.form.browser_language.value = "<%=info.getSession("LANGUAGE")%>";
			document.form.language.value = "<%=info.getSession("LANGUAGE")%>";
			document.form.submit(); --%>
			
			document.form.force_login_flag.value = "true";
			document.form.user_id.value = "<%=change_user_id%>";
			document.form.browser_language.value = "<%=info.getSession("LANGUAGE")%>";
			document.form.language.value = "<%=info.getSession("LANGUAGE")%>";
			document.form.house_code.value = "<%=info.getSession("HOUSE_CODE")%>";
			
			//로그아웃 & 로그인
			var jqa = new jQueryAjax();
			jqa.action = "user_change_logout_process.jsp";
			jqa.sync = false;	//비동기방식
			jqa.submit(false);
			
	<%	}	%>
	}

</script>
</head>
<body leftmargin="15" topmargin="6" onload="init();">
<s:header>
<form name="form" id="form" method="POST">
<input type="hidden" name="browser_language" id="browser_language">
<input type="hidden" name="language" id="language">
<input type="hidden" name="force_login_flag" id="force_login_flag">
<input type="hidden" name="house_code" id="house_code">
<input type="hidden" name="user_id" id="user_id">
<input type="hidden" name="type" id="type">

<%
	//íë©´ì´ popup ì¼ë¡ ì´ë¦´ ê²½ì°ì ì²ë¦¬ í©ëë¤.
	//ìë this_window_popup_flag ë³ìë ê¼­ ì ì¸í´ ì£¼ì´ì¼ í©ëë¤.
	//String this_window_popup_flag = "false";
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
       		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("AD_048.change_user_id")%></td>
       		<td width="30%" height="24" class="se_cell_data">
       			<input type="text" size="20" name="change_user_id" id="change_user_id" value=""><img src="/images/icon/icon_search.gif" align="absmiddle" style="cursor:hand" onClick="javascript:PopupManager()">
                <input type="hidden" size="20" name="p" id="p" value="" style="display:none" >
       		</td>
       		<td width="20%" height="24" align="right" class="se_cell_title">&nbsp;</td>
       		<td width="30%" height="24" class="se_cell_data">
       		&nbsp;
			</td>
		  </tr>
		</table>
		  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			  <TR>
				<td style="padding:5 5 5 0">
				<TABLE cellpadding="2" cellspacing="0">
				  <TR>
				  	  <td><script language="javascript">btn("user_change()", "<%=text.get("AD_048.change_user")%>")</script></td>
				  </TR>
			    </TABLE>
			  </td>
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

