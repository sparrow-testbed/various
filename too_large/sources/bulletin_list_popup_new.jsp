<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}
%>
<%
	String user_type = info.getSession("USER_TYPE");
    String is_admin_user = info.getSession("IS_ADMIN_USER");

	Vector multilang_id = new Vector();
	multilang_id.addElement("MT_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String seq= JSPUtil.nullToEmpty(request.getParameter("seq"));

    Object[] obj = {seq};

	SepoaOut value = ServiceConnector.doService(info, "MT_014", "CONNECTION","getQuery_NOTICE_POP_New", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);

    //DB에서 받아올값들 초기화
    String SUBJECT = null;
    String SEQ = null;
    String COMPANY_NAME = null;
    String DEPT_TYPE = null;
    String CONTENT = null;
    String ATTACH_NO = null;
    String GONGJI_GUBUN = null;
    String GONGJI_GUBUN_DESC = null;
    String VIEW_COUNT = null;

    int checkVal = 0;
	String title = String.valueOf(text.get("MT_014.MSG_0100"));// "공지사항";
	String readOnly = "";
	String ScreeningItemName = "";

    if(wf.getRowCount() > 0) {
        //for(int i=0;i<wf.getRowCount();i++){
            SUBJECT 	= wf.getValue("SUBJECT",0);
            SEQ 		= wf.getValue("SEQ",0);
            COMPANY_NAME= wf.getValue("COMPANY_NAME",0);
            DEPT_TYPE	= wf.getValue("DEPT_TYPE",0);
            CONTENT 	= wf.getValue("CONTENT",0);
            ATTACH_NO 	= wf.getValue("ATTACH_NO", 0);

            GONGJI_GUBUN 	= wf.getValue("GONGJI_GUBUN", 0);
            GONGJI_GUBUN_DESC 	= wf.getValue("GONGJI_GUBUN_DESC", 0);
            
            VIEW_COUNT 	= wf.getValue("VIEW_COUNT", 0);
            VIEW_COUNT = nvl(VIEW_COUNT, "0");
        //}
    }

    wf = new SepoaFormater(value.result[2]);  //공지사항 내용
    CONTENT = "";

    for(int i = 0; i < wf.getRowCount(); i++)
    {
    	CONTENT += wf.getValue("CONTENT", i);
    }

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
%>
<html>
<head>


<%@ include file="/include/code_common.jsp"%>
<link rel="stylesheet" href="../css/common.css" type="text/css">
<link rel="stylesheet" href="../css/sec.css" type="text/css">
<script language=javascript src="../js/lib/sec.js"></script>


<script type="text/javascript">
function view_count_list_popup(){
	var seq = "<%=seq%>";
	
	var url = "../admin/bulletin_view_count_list.jsp?seq="+seq;

	CodeSearchCommon(url,'bulletin_view_count_list','0','0','700','600');
}
</script>
</head>

<body leftmargin="15" topmargin="6">
<s:header popup="true">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
//	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
//	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("MT_014.MSG_0100");
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
						<td height="30">
							<TABLE cellpadding="0" style="width: 100%">
								<TR>
									<TD align="right">
<script language="javascript">
btn("javascript:window.close()", "<%=text.get("BUTTON.close")%>");
</script>
									</TD>
								</TR>
							</TABLE>
						</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
								<tr>
									<td width="100%">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제목</td>
												<td class="data_td" colspan="5">
													<%=SUBJECT%>
												</td>
											</tr>
											<tr>
												<td colspan="6" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
<%--
												<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_014.COMPANY_NAME")%></td>
												<td width="20%" class="data_td">
													<%=COMPANY_NAME%>
												</td>
												<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_014.DEPT_TYPE")%></td>
												<td width="20%" class="data_td">
													<%=DEPT_TYPE%>
												</td>
 --%>
												<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("MT_014.VIEW_COUNT")%></td>
												<td class="data_td">
													<%=VIEW_COUNT%>
												</td>
											</tr>
											<tr>
												<td colspan="6" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td style="background:#FFFFFF;padding:20px 5px 5px 5px;" height="450" colspan="6" class="content" valign="top">
													<%=CONTENT%>
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
</s:header>	
<s:footer/>
</body>
</html>