<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/admin/basic/approval2/ap2_pp_lis2.jsp -->
<!--
 Title:        	결재상신 팝업화면 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team Youn Hea Yean<p>
 @version      	1.0.0<p>
 @Comment       결재전략이 "A"이면 차기결재자를 자동으로 쿼리해오고 <p>
 				"P"이면 팝업을 띄워서 차기결재자와 상신의견, 긴급여부 정보를 받는다. <p>
!-->
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
</head>



<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EM_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

		String house_code = info.getSession("HOUSE_CODE");
  		String company_code = info.getSession("COMPANY_CODE");
      	//String text1	= request.getParameter("text1");
      	//String subject	= request.getParameter("subject");
  		String doc_no = request.getParameter("doc_no");
  		String confirm_date = request.getParameter("confirm_date");
  		String text1	= "";
      	String subject	= "";

  		if (doc_no == null) doc_no = "";
  		if (confirm_date == null) confirm_date = "";

  		if (doc_no.length() != 0 )
  		{

  			// ICOMMAIL 에 INSERT 하는 데이타.
    			String[] args = new String[2];

				args[0] = company_code;
				args[1] = doc_no;
				String doc_noc = args[1];


	    		Object[] obj = {doc_noc};
	    		String nickName= "EM_001";
	    		String conType = "CONNECTION";
	    		String MethodName = "";

	    		MethodName = "getReceviedMailSel";
	        	sepoa.fw.srv.SepoaOut value = null;
				SepoaRemote remote = null;

	        	try {
						Logger.debug.println(info.getSession("ID"),request,"insert:wk:jsp:info===>"+info.getSession("ID"));
			   			remote = new SepoaRemote(nickName, conType,info);
			   			value = remote.lookup(MethodName, obj);
			   			if(value.status == 1)

			   			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
   						Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	        	}catch(SepoaServiceException wse) {
			       	Logger.err.println(info.getSession("ID"),request, " err = " + wse.getMessage());
	        	}catch(Exception e) {
	        	    Logger.err.println(info.getSession("ID"),request, " err = " + e.getMessage());
	    		}finally{
	    			try{
						remote.Release();
				}catch(Exception e){}
			}

			SepoaFormater wf = new SepoaFormater(value.result[0]);
			int iRowCount = wf.getRowCount();

			if(iRowCount>0)
		    {
				text1	     	 = wf.getValue("text1", 0);
				subject	 = wf.getValue("subject", 0);
			}

		}

  		//매일 받음 확인 하는 내용이다.
  		//doc_no없을 때는 전체 공지때 인데 이때는 이걸 할 필요없다.
  		//이미 확인된건 할 필요없다.
  		if (confirm_date.length() == 0  )
  		{
  			// ICOMMAIL 에 INSERT 하는 데이타.
    			String[] args = new String[2];

			args[0] = company_code;
			args[1] = doc_no;


	    		Object[] obj = {args};
	    		String nickName= "EM_001";
	    		String conType = "TRANSACTION";
	    		String MethodName = "";

	    		MethodName = "ConfirmReceivedMail";
	        	sepoa.fw.srv.SepoaOut value = null;
				SepoaRemote remote = null;

	        	try {
						Logger.debug.println(info.getSession("ID"),request,"insert:wk:jsp:info===>"+info.getSession("ID"));
			   			remote = new SepoaRemote(nickName, conType,info);
			   			value = remote.lookup(MethodName, obj);
			   			if(value.status == 1)

			   			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
   						Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	        	}catch(SepoaServiceException wse) {
			       	Logger.err.println(info.getSession("ID"),request, " err = " + wse.getMessage());
	        	}catch(Exception e) {
	        	    Logger.err.println(info.getSession("ID"),request, " err = " + e.getMessage());
	    		}finally{
	    			try{
						remote.Release();
				}catch(Exception e){}
			}

		}
%>

<%--
	String this_image_folder_name = "";
	String this_session_user_type = "";
	String this_request_language = JSPUtil.nullChk(request.getParameter("language")).toUpperCase();
	String this_menu_order = "0";

	this_menu_order = JSPUtil.nullChk(request.getParameter("this_menu_order"));
	String session_menu_order = (String)session.getAttribute("MENU_ORDER");

	if(session_menu_order == null) session_menu_order = "";

	if(this_menu_order.length() > 0)
	{
		session.setAttribute("MENU_ORDER" ,this_menu_order);

		//info = wise.ses.WiseSession.getAllValue(request);
		//WiseSession.putValue(request, "MENU_ORDER", this_menu_order);
		//info = wise.ses.WiseSession.getAllValue(request);
	}
	else if(session_menu_order.length() > 0)
	{
		this_menu_order = session_menu_order;
	}


	String css_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(css_popup_flag.trim().length() <= 0) css_popup_flag = "false";

	if(this_request_language.trim().length() <= 0)
	{
		if(session.getAttribute("LANGUAGE") != null)
		{
			this_request_language = JSPUtil.nullChk(String.valueOf(session.getAttribute("LANGUAGE")));
		}
	}

	if(session.getAttribute("USER_TYPE") == null)
	{
		this_session_user_type = "S";
	}
	else
	{
		this_session_user_type = String.valueOf(session.getAttribute("USER_TYPE"));
	}

	if(this_session_user_type.equals("B") && css_popup_flag.equals("false"))
	{
		//this_image_folder_name = "/";
		this_image_folder_name = "/supplier/";
	}
	else
	{
		this_image_folder_name = "/supplier/";
	}

	String css_url_name = "";
	css_url_name = "../css/sec.css";
--%>


<html>
<head>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
<!--


function Save() {


	var remark = document.forms[0].remark.value;
	var row = opener.parent.body.document.forms[0].row.value;
	var SIGN_REMARK  = opener.parent.body.document.WiseTable.getColumnIndex("SIGN_REMARK");
	opener.parent.body.document.WiseTable.setValue(row, SIGN_REMARK, "/kr/images/button/query.gif&&"+remark, "&");
	opener.parent.body.document.WiseTable.Update();

	window.close();
}



//-->
</script>
	<%@ include file="/include/code_common.jsp"%>
<%--	<link rel="stylesheet" href="../css/sec_pop.css" type="text/css"> --%>
<%@ include file="/include/include_css.jsp"%>
    <script language=javascript src="../js/lib/sec.js"></script>
    

</head>

<body bgcolor="#FFFFFF" text="#000000" >
<s:header popup="true">
<form name="form1">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("EM_005.TEXT2");	//메세지 확인
%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="3"> </td>
	  </tr>
	  <tr>
	  <td width="100%" valign="top">
  		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="left">
					<TABLE cellpadding="0">
						<TR>
	    	  				<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></TD>
	    	  			</TR>
			      	</TABLE>
			    </td>
			</tr>
		</table>
  	
		<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB">
        	<tr>
                <td class="div_input"  width="15%" align="center"><%--제목--%><%=text.get("EM_005.SUBJECT") %></td>
                <td class="div_data">
                	<b><%=subject%></b>
<%--                	<input type="text" name="textfield" size="98%" style="font-weight: bold" value="<%=subject%>" readonly> --%>
                </td>
            </tr>
            <tr>
                <td class=div_input  align="center"><%--매일 내용--%><%=text.get("EM_005.CONTENTS") %></td>
                <td class=div_data>
                	<textarea name="text1" cols="100%" rows="28" readonly><%=text1%></textarea>
                </td>
            </tr>
		</table>
	  </td>
	  </tr>
	</table>
</form>
</s:header>
<s:footer/>
</body>
</html>
