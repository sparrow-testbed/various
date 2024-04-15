<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");
	String screen_message = "";
	String popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	String screen_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("screen_flag")));
	String file_name = request.getServletPath();
	String searchword = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("searchword")));
	String code = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("code")));
	String type = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("type")));
	String note = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("note")));
	String text2 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("text2")));
	String text3 = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("text3")));
	String flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("flag")));
	String status = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("status")));
	String add_date = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("add_date")));
	String change_date = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("change_date")));
	String change_user_id = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("change_user_id")));
	String add_user_id = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("add_user_id")));
	String use_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("use_flag")));

	//등록이라면
	if(screen_flag.equals("insert"))
	{
		/*
        AdminCodeh admin;
        Object objref = ServiceLocator.getInstance().WiseContext("AdminCodeh", info);
        AdminCodehHome home = (AdminCodehHome) PortableRemoteObject.narrow(objref, AdminCodehHome.class);
        admin = home.create();
        SepoaOut wo = admin.getCodehInsert(info, code, type, text2, text3, note);
        */

        Object[] obj = {info, code, type, text2, text3, note};
        SepoaOut wo = ServiceConnector.doService(info, "AD_014", "TRANSACTION", "getCodehInsert", obj);

        //실패했다면
        if(!wo.flag)
        {
        	 String error_message = SepoaString.replace(SepoaString.replace(wo.message, "\r", ""), "\n", "");
             screen_message = text.get("MESSAGE.1003") + "\\r\\r" + error_message;
        }
        else
        {
			screen_message = (String) text.get("AD_014.0008");
			screen_flag = "search";
	        code = wo.result[0];
        }
	}

	//수정이라면
	if(screen_flag.equals("modify"))
	{
		/*
        AdminCodeh admin;
        Object objref = ServiceLocator.getInstance().WiseContext("AdminCodeh", info);
        AdminCodehHome home = (AdminCodehHome) PortableRemoteObject.narrow(objref, AdminCodehHome.class);
        admin = home.create();
    	*/

        //SepoaOut wo = admin.getCodehUpdate(info, code, type, text2, text3, note);

        Object[] obj = {info, code, type, text2, text3, note, use_flag};
        SepoaOut wo = ServiceConnector.doService(info, "AD_014", "TRANSACTION", "getCodehUpdate", obj);

        //실패했다면
        if(!wo.flag)
        {
        	 String error_message = SepoaString.replace(SepoaString.replace(wo.message, "\r", ""), "\n", "");
             screen_message = text.get("MESSAGE.1003") + "\\r\\r" + error_message;
        }
        else
        {
        	screen_message = (String) text.get("AD_014.0007");
        	screen_flag = "search";
        }
	}


	//조회라면
	if(screen_flag.equals("search"))
	{
		/*
        AdminCodeh admin;
        Object objref = ServiceLocator.getInstance().WiseContext("AdminCodeh", info);
        AdminCodehHome home = (AdminCodehHome) PortableRemoteObject.narrow(objref, AdminCodehHome.class);
        admin = home.create();
        */

        //WiseOut wo = admin.getCodehList(info, code);
        Object[] obj = {info, code};
        SepoaOut wo = ServiceConnector.doService(info, "AD_014", "CONNECTION", "getCodehList", obj);

        //실패했다면
        if(!wo.flag)
        {
        	 String error_message = SepoaString.replace(SepoaString.replace(wo.message, "\r", ""), "\n", "");
             screen_message = text.get("MESSAGE.1002") + "\\r\\r" + error_message;
        }
        else
        {
			SepoaFormater wf = new SepoaFormater(wo.result[0]);
			code = wf.getValue("CODE", 0);
			type = wf.getValue("TYPE", 0);
			//text1 = wf.getValue("TEXT1", 0);
			text2 = wf.getValue("TEXT2", 0);
			text3 = wf.getValue("TEXT3", 0);
			note = wf.getValue("TEXT4", 0);
			flag = wf.getValue("FLAG", 0);
			status = wf.getValue("STATUS", 0);
			add_date = wf.getValue("ADD_DATE", 0);
			change_date = wf.getValue("CHANGE_DATE", 0);
			change_user_id = wf.getValue("CHANGE_USER_ID", 0);
			add_user_id = wf.getValue("ADD_USER_ID", 0);
			use_flag = wf.getValue("use_flag", 0);
		}
	}

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<script language="javascript">

	function check_form()
	{
		var f = document.form;

		if(getLength(LRTrim(f.text2.value)) < 1)
		{
			alert("<%=text.get("AD_014.0009")%>");
			f.text2.focus();
			return false;
		}

		if(getLength(LRTrim(f.text3.value)) < 1)
		{
			alert("<%=text.get("AD_014.0010")%>");
			f.text3.focus();
			return false;
		}

		if(getLength(LRTrim(f.code.value)) < 1)
		{
			alert("<%=text.get("AD_014.0011")%>");
			f.code.focus();
			return false;
		}

		return true;
	}

	function AdminCodeh_insert()
	{

		if(!check_form()) return;

		if (confirm("<%=text.get("MESSAGE.1014")%>")){
			document.form.method = "POST";
			document.form.action = "<%=POASRM_CONTEXT_NAME%><%=file_name%>";
			document.form.screen_flag.value = "insert";
			document.form.submit();
		}
	}

	function AdminCodeh_update()
	{
		if(!check_form()) return;

		if (confirm("<%=text.get("MESSAGE.1014")%>")){
			document.form.method = "POST";
			document.form.action = "<%=POASRM_CONTEXT_NAME%><%=file_name%>";
			document.form.screen_flag.value = "modify";
			document.form.submit();
		}
	}

	//취소후 리스트 페이지 갱신
	function AdminCodeh_cancel()
	{
		opener.reload_page();
		window.close();
	}

	function message_display()
	{
<%		if(screen_message.length() > 0)
		{	%>
			alert("<%=screen_message%>");
<%		}	%>
	}

</script>
</head>

<body onLoad="message_display();">
<s:header popup="true">
<form name="form">

<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
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
 		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    	<tr>
	      		<td height="30" align="right">
					<TABLE cellpadding="0">
			      		<TR>
							<%
                        		if (screen_flag.equals("") && code.equals("")){
                        	%>
                            		<td><script language="javascript">btn("AdminCodeh_insert()","<%=text.get("BUTTON.insert")%>")</script></td>
                              		<td><script language="javascript">btn("AdminCodeh_cancel()","<%=text.get("BUTTON.close")%>")</script></td>
                        	<%
                        		}else{
                        	%>
                        			<td><script language="javascript">btn("AdminCodeh_update()","<%=text.get("BUTTON.update")%>")</script></td>
                              		<td><script language="javascript">btn("AdminCodeh_cancel()","<%=text.get("BUTTON.close")%>")</script></td>
                        	<%
                        		}
                        	%>
		    	  		</TR>
	   			</TABLE>
	   		</td>
	   	</tr>
	  </table>
	  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="DBDBDB">
	  	  <tr>
          	<td height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.codetype")%></td>
            <td height="25" class="data_td" colspan="3">
            <% if(code.length() <= 0) { %>
				<input type="text" name="code" maxlength="4" size="5">
            <% } else { %>
	  			<input type="hidden" name="code" value="<%=code%>">&nbsp;<b><%=code%></b>
               	<input type="hidden" name="type" value="<%=type%>">
            <% } %>
              </td>
            </tr>
            <tr>
              <td height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.codename")%></td>
              <td height="25" class="data_td" colspan="3"><input type="text" size="23" name="text2" value="<%=text2%>"></td>
            </tr>
            <tr>
              <td height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.use_flag")%></td>
              <td height="25" class="data_td" colspan="3"><input type="text" size="1" maxlength="1" name="use_flag" value="<%=use_flag%>"></td>
            </tr>
            <tr>
              <td height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.content")%></td>
              <td height="90" class="data_td" colspan="3"><textarea name="text3" rows="5" style="width:95%"><%=text3%></textarea></td>
            </tr>
            <tr>
              <td width="100" height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.TEXT4")%></td>
              <td height="90" class="data_td" colspan="3">
                <textarea name="note" rows="5" style="width:95%"><%=note%></textarea>
              </td>
            </tr>
            <tr>
              <td width="100" height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.adduserid")%> </td>
              <td width="260" height="25" class="data_td">&nbsp;<%=add_user_id%> </td>
              <td width="100" height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.adddate")%></td>
              <td width="260" class="data_td">&nbsp;<%=add_date%></td>
            </tr>
            <tr>
              <td width="100" height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.changeuserid")%></td>
              <td width="260" height="25" class="data_td">&nbsp;<%=change_user_id%></td>
              <td width="100" height="25" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_014.changedate")%></td>
              <td width="260" class="data_td">&nbsp;<%=change_date%></td>
            </tr>
            </table>
			<script language="JavaScript" src="../../jscomm/body_bot_bar.js" type="text/javascript"></script>
		</td>
		</tr>
	</table>
<input type="hidden" name="screen_flag" value="<%=screen_flag %>">
</form>
<%-- <%@ include file="/include/include_bottom.jsp"%> --%>
</table>
</s:header>
<s:footer/>
</body>
</html>
