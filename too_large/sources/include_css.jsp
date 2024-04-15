<%-- UTF-8적용 지우지마세요 --%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<%
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
	
	
	int index = 0;
	// /poasrm/master/subcontractor_progress_list.jsp
	if(request.getRequestURI().indexOf(POASRM_CONTEXT_NAME+"/admin") >= 0 ){	
		//css_url_name = "../css/sec_admin.css";
		//index = 1;
		css_url_name = POASRM_CONTEXT_NAME + "/css/sec.css";
		index = 2;
	}else{
		css_url_name = POASRM_CONTEXT_NAME + "/css/sec.css";
		//index = 2;
		index = 2;
	}
%>

	<!-- IE10에서 추가함 -->
	<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME %>/css/common.css" type="text/css"/>
	<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME %>/css/layout.css" type="text/css"/>
	<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME %>/css/body.css"   type="text/css"/>
	<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME %>/css/woori.css"   type="text/css"/>

	<link rel="stylesheet" href="<%=css_url_name%>" type="text/css"/>
<%--
<%	if(index == 2){ %>
	<style>
	/* 창성 sec.css를 오버라이딩 - 변경 또는 추가된 것. */
	table tr.div_data td{
		padding-top:2px;
		height:18px;
		vertical-align:middle;
	}
	table tr td.title_td
	, table tr td.data_td_input
	, table tr td.div_input
	, table tr td.div_data
	{
		border:1px solid #A9C3D8;
		height:18px;
		vertical-align:middle;
	}
	select.inputsubmit
	,select.div_data
	,select.div_data_no{
		height:22px;
		vertical-align:middle;
	}
	</style>
	<!-- 
		#C8EAF6 옅은 파랑(그리드)
		#629DD9 테이블 높이3 라인(파랑)
		#A9C3D8 창성에서 사용하던 색상(border)
		#368EE4 좌측상단 메뉴 텍스트 배경색
		#3B75A8 snb좌측메뉴 테두리		
	 -->
<% } %>
 --%>
<%@ include file="/include/dhtmlx_common.jsp"%>
