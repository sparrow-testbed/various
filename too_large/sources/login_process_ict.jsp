<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
//System.out.println("status:"+"|"+SepoaSession.getValue(request, "logStatus"));

String goFnc     = "failPage();";
String goUrl     = "/common/idpwd_ict.jsp?prev_url=login_fail";
String logStatus = SepoaSession.getValue(request, "logStatus");
String mode      = SepoaSession.getValue(request, "mode");
String user_id   = SepoaSession.getValue(request, "user_id");
String msg       = SepoaSession.getValue(request, "msg");
String msg2      = "";
String user_type = SepoaSession.getValue(request, "USER_TYPE");
String gb_gj = JSPUtil.nullToEmpty(SepoaSession.getValue(request, "GB_GJ"));

String step_str = "";


String from_site = SepoaSession.getValue(request, "FROM_SITE");
String MENU_PROFILE_CODE = SepoaSession.getValue(request, "MENU_PROFILE_CODE");


//System.out.println(msg);
if("setDirectLogin".equals(mode) ){	//그룹웨어 직접 로그인
	if("true".equals(logStatus)){
		
		goUrl = "/common/index_buyer_ict.jsp";		
		goFnc = "startDirectPage();";
		
	}else{
		goUrl = "/common/idpwd_ict.jsp?prev_url=login_fail";
		goFnc = "failDirectPage();";
	}
	
}else if("setDateOver".equals(msg)){	//날짜 3개월 초과
	msg2 = "사용자 암호변경주기가 도래하였습니다. (분기당1회) 암호를 변경하여 주십시오.";
	goUrl = "/common/idpwd_pass.jsp?FromSite=ICT";
	goFnc = "failPage();";

}else if("setLoginLocal".equals(mode)){
	if("true".equals(logStatus)){
		if("WOORI".equals(user_type)){
			goUrl = "/common/index_buyer_ict.jsp";
			step_str="1";
		}else{
			if("J".equals(gb_gj)){
				goUrl = "/ict/s_kr/admin/info/ven_bd_ref2_j_ict.jsp";
			}else{
				goUrl = "/common/index_seller_ict.jsp";	
			}
			step_str="2";
		}

		//goFnc = "startPage();";
		goFnc = "startDirectPage();";		
	}
}else{
	if("true".equals(logStatus)){
		if("WOORI".equals(user_type)){
			goUrl = "/common/index_buyer_ict.jsp";
			step_str="3";
		}else{
			if("J".equals(gb_gj)){
				goUrl = "/ict/s_kr/admin/info/ven_bd_ref2_j_ict.jsp";
			}else{
				goUrl = "/common/index_seller_ict.jsp?f=1";
			}
			step_str="4";
		}

		goFnc = "startPage();";
		
	}else{
		goUrl = "/common/idpwd_ict.jsp?prev_url=login_fail";
		goFnc = "failPage();";
	}
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리은행 전자구매시스템</title>
<link rel="stylesheet" href="<%=POASRM_CONTEXT_NAME%>/css/jquery.contextMenu.css" type="text/css"/>
<script src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery.contextMenu.js"></script>
<script type="text/javascript"> 

	var home_jsp = "<%=goUrl%>";
	
	function init(){
		<%=goFnc%>   
	}
	
	function startPage(){
		opener.location.href = home_jsp;
		window.close();
	}
	
	function failPage(){
		//window.location.href = home_jsp;
		<%if("setDateOver".equals(msg)){%>
			alert("1:<%=msg2%>");
		<%}%>
		var frm = document.frm;
		frm.method = "POST";
		frm.action = home_jsp;
		frm.submit();
		
	}
	function startDirectPage(){
		location.href = home_jsp;
		
	}
	
	function failDirectPage(){
		alert("접속 정보를 확인하신 후 다시 로그인하여 주십시오.");
		//window.close();
		window.open('about;blank','_self').close();
		
	}
	function failXecurePage(){
		alert("접속 정보를 확인하신 후 다시 로그인하여 주십시오.");
		//window.close();
		location.href = home_jsp;
		
	}
</script>
</head>
<body onload="init();">
<form name="frm">
<input type="hidden" name="prev_url" id="prev_url" value="login_fail" >
<input type="hidden" name="fail_msg" id="fail_msg" value="<%=msg%>" >
<input type="hidden" name="user_id"  id="user_id"  value="<%=user_id%>" >
</form>
<body>
</body>
</html>