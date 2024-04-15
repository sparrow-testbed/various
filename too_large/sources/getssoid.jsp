<%@page import="java.util.Random"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@include file="encrypt.jsp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- ============================================== 
*. 본 페이지는 SSO 연동을 하기위한 ProxyServer의 게이트웨이 역할을 하며
   Header 에서 SSO ID를 취득 후 업무 서버로 인증 정보를 전달한다.
=================================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Reverse Proxy OHS</title>
</head>
<%
/*******************************************************
**  업무서버에서 선언해야 할 변수- Start
**  필수 전달 Parameter 에 넘겨줘야 할 변수 선언 부
*******************************************************/
	String actionUrl = "https://eprodev.wooribank.com/sso/app_login_exec.jsp";  // 암호화된 SSO ID 를 받아 복호화 실행하는 URL
/*******************************************************
**  업무서버에서 선언해야 할 변수- End
*******************************************************/
	String userid = "" ;
    String rand = "";
	String sso_userid = request.getHeader("USER_ID") ;
	String ENT_CODE = request.getHeader("ENT_CODE") ; //계열사 코드
	String UNIT_CODE = request.getHeader("UNIT_CODE") ; //부서 코드
	if ( sso_userid == null || sso_userid.equals("") ) {
		System.out.println("[SSO_PROXY_ERROR]["+request.getRequestURL()+"]Header에서 사용자 ID를 얻어올 수 없습니다.");
		response.sendRedirect("");	
	} else {
		String xKeyValue = request.getHeader("x-forwarded-for").toString();
		if(xKeyValue != null && !xKeyValue.equals("") ){
			if(xKeyValue.contains(":")){
				xKeyValue = xKeyValue.substring(0,xKeyValue.indexOf(":"));
			}
		}else{
			System.out.println("[SSO_PROXY_ERROR]["+request.getRequestURL()+"] Header에서 client IP Address 를 얻어올 수 없습니다.");
			response.sendRedirect("");	
		}
		Random ran = new Random();
		int tmpMax = 999999999;
		rand = String.valueOf(ran.nextInt(tmpMax));
		
		//userid = encrypt(sso_userid,xKeyValue, rand) ;
		System.out.println("[SSO_PROXY_INFO]["+request.getRequestURL()+"] ENC_USERID==>"+userid) ;
	}
%> 
<body>
<form name="ssoSample" method="post" target="_self" action="<%=actionUrl%>">  
<%
/********************************************************************
** Proxy 에서 얻어온 헤더 정보를 Parameter로 넘겨주기 위한 설정
** w_userid 는 평문값이므로 제외토록한다.
** 본 페이지는 Sample 이므로 모든 헤더 값을 Parameter 로 넘긴다.
** 실제 업무에서는 필요 정보만 Parameter로 넘기도록 한다.
********************************************************************/
	Enumeration enumer = request.getHeaderNames();
	int i=1;
	while(enumer.hasMoreElements()){
		String key = enumer.nextElement().toString();
		String value = request.getHeader(key);
	
		if(key.equals("w_userid")) continue;
%>
<input type="hidden" name="<%=key %>" value="<%=value%>"/>
<%	
		//System.out.println("[Header] " + i + " =>" + key + "\t" + value);
		//i++;
	}
%>
<%-- 필수 전달 Parameter Start --%>
<input type="hidden" name="userid" value="<%=userid%>"/>
<input type="hidden" name="ENT_CODE" value="<%=ENT_CODE%>"/>
<input type="hidden" name="UNIT_CODE" value="<%=UNIT_CODE%>"/>
<input type="hidden" name="rand" value="<%=rand%>"/>
<%-- 필수 전달 Parameter End --%>
</form>
</body>
<script>
//document.ssoSample.submit();
</script>
</html>