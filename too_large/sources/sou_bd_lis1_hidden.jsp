<%--
Title:        FrameWork 적용 Sample화면(PROCESS_ID)  <p>
 Description:  개발자들에게 적용될 기본 Sample(조회) 작업 입니다.(현재 모듈명에 대한 간략한 내용 기술) <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       DEV.Team 2 Senior Manager Song Ji Yong<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>

<% String WISEHUB_PROCESS_ID="PROCESSID001";%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	
	String house_code = info.getSession("HOUSE_CODE");
	String id = JSPUtil.CheckInjection(request.getParameter("id"));
	String code = JSPUtil.CheckInjection(request.getParameter("code"));
	String value = JSPUtil.CheckInjection(request.getParameter("value"));
	String target = JSPUtil.CheckInjection(request.getParameter("target"));
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
	
	function init() {
		
		<% if (target.equals("MATERIAL_TYPE")) { %>
			
			for(i=0; i<form2.List.length; i++) {
				var name = form2.List.options[i].text;
				var value = form2.List.options[i].value;
				parent.setMATERIAL_CTRL_TYPE(name, value);
			}

		<% } else if (target.equals("MATERIAL_CTRL_TYPE")) { %>

			for(i=0; i<form2.List.length; i++) {
				var name = form2.List.options[i].text;
				var value = form2.List.options[i].value;
				parent.setMATERIAL_CLASS1(name, value);
			}
		<% } %>
		
	}
	
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="javascript:init();">
<form id="form2" name="form2" >
<select name="List" class="inputsubmit">
            <option>----------</option>
<%
            String listbox1 = ListBox(info, id,house_code+"#"+code+"#"+value+"#" , "");
            out.println(listbox1);
%>
</select>
</form>
</body>
</noframes>
</html>
                                                    
