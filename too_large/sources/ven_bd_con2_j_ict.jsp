<%--
 Title:        		업체생성, 수정 top  <p>
 Description:
 Copyright:    		Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author
 @version      	1.0.0
 @Comment
--%>

<% String WISEHUB_PROCESS_ID="p0010";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String company_code = info.getSession("COMPANY_CODE");
	String house_code = info.getSession("HOUSE_CODE");
	String os_gb = info.getSession("OS_GB");
%>


<html>
<head>
<title>우리은행 전자구매시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
	String popup                  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("popup")));
	String mode                   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mode")));
	String resident_no            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("resident_no")));
	String irs_no                 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("irs_no")));
	String vendor_code			  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("vendor_code")));
	String CompanyCode			  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("CompanyCode")));
	String flag			  		  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("flag")));
	String status				  =  JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("status")));
	String downframe = "";    //아래쪽 frame 이름 결정 flag가 D 이면 ven_bd_dis2.jsp
	String upframe = "";

	upframe = "ven_bd_top_j_ict.jsp";
	
	if("win10".equals(os_gb)){
		downframe = "ven_bd_ins2_j_ict_window10.jsp";
	}else{
		downframe = "ven_bd_ins2_j_ict.jsp";
	}

%>
</head>
<frameset rows="0,80,*" cols="*" border="0" framespacing="0" frameborder="NO">
	<frame src="ven_bd_prt.jsp" name="prt" frameborder="NO"><!-- 소스가 없음 -->
	<frame src="<%=upframe%>?mode=<%=mode%>&irs_no=<%=irs_no%>&resident_no=<%=resident_no%>&popup=<%=popup%>&vendor_code=<%=vendor_code%>&CompanyCode=<%=CompanyCode%>" name="up" frameborder="NO">
	<frame src="<%=downframe%>?mode=<%=mode%>&irs_no=<%=irs_no%>&resident_no=<%=resident_no%>&popup=<%=popup%>&vendor_code=<%=vendor_code%>&flag=<%=flag%>&status=<%=status%>&CompanyCode=<%=CompanyCode%>" name="down" frameborder="NO">
</frameset>

<noframes>
</noframes>
<s:header>
<body bgcolor="#FFFFFF" text="#000000" onload="">
</body>
</s:header>
</html>
