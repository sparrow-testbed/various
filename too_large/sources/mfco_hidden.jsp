<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/pr/pr1_pp_lis2_hidden.jsp -->
<!--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="I_PROCESSID001";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	String id      = JSPUtil.CheckInjection(request.getParameter("id"));
	String code    = JSPUtil.CheckInjection(request.getParameter("code"));
	String value   = JSPUtil.CheckInjection(request.getParameter("value"));
	String target  = JSPUtil.CheckInjection(request.getParameter("target"));
	SepoaListBox lb = new SepoaListBox();
	
	String result = "";
	if ((value != null) && (!value.equals(""))) {
    	//result = lb.Table_ListBox( request, id, info.getSession("HOUSE_CODE") + "#" + code + "#" + value + "#", "#", "@");
		result = lb.Table_ListBox( request, id, info.getSession("HOUSE_CODE") + "#" + code + "#" + value, "#", "@");
    }
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<script language="javascript">
<!--
	function init() {
		if("<%=target%>" == "MFCO_TYPE") {
		    var company = "<%=result%>".split("@");
	        var company_code = "";
	        row_index = 0;
	        var count = 0;
	        for(i=0; i<company.length-1; i++)
	        {
	            company_code = company[i].split("#");
				name = company_code[1];
				value = company_code[0];
				parent.setMFCO_TYPE(name, value);
			}
		}
	}
//-->
</script>


</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init();">

<!--내용시작-->
<form name="form1" >

</form>

</body>
</html>


