<%@page import="java.util.Enumeration"%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="encrypt.jsp" %>
<%
/*******************************************************
**  업무서버에서 선언해야 할 변수- Start
**  필수 전달 Parameter 에 넘겨줘야 할 변수 선언 부
*******************************************************/
	String AP_URL = "http://업무서버 경로 및 포트/main.jsp";  // 암호화된 SSO ID 를 받아 복호화 실행하는 URL
/*******************************************************
**  업무서버에서 선언해야 할 변수- End
*******************************************************/
	String sso_userid 	= request.getParameter("userid") ;
	String ENT_CODE 	= request.getParameter("ENT_CODE") ;
	String UNIT_CODE 	= request.getParameter("UNIT_CODE") ;
	String UNIT_NAME 	= decode_name(request.getParameter("UNIT_NAME")) ;
	String rand = request.getParameter("rand") ;
	System.out.println("[SSO_PROXY_INFO]["+request.getRequestURL()+"] request UserId==>"+sso_userid) ;
	String xKeyValue = "";
	xKeyValue = request.getRemoteAddr();
	if(xKeyValue == null || xKeyValue.equals("")){
		System.out.println("[SSO_PROXY_ERROR]["+request.getRequestURL()+"] Header에서 client IP Address 를 얻어올 수 없습니다.");
	}
	sso_userid = decrypt(sso_userid,xKeyValue,rand) ;
	System.out.println("[SSO_PROXY_INFO]["+request.getRequestURL()+"] DEC_USERID==>" + sso_userid) ;
	if ( sso_userid == null || sso_userid.equals("") ) {
		System.out.println("[SSO_PROXY_ERROR]["+request.getRequestURL()+"] 복호화된 SSO ID 를 얻어올 수 없습니다.");
	} else {
		// 복호화한 SSOID 를 업무 Session에 기록한다. 		
    	session.setAttribute("SSOID", sso_userid);	
	}
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<table border="1">
	<tr>
		<td>프록시 헤더명</td><td>프록시 헤더값</td>
	</tr>
<%	
	Enumeration enumer = request.getParameterNames();
	
	while(enumer.hasMoreElements()){
		String name = enumer.nextElement().toString();
		String value = request.getParameter(name);
		
		if(value.startsWith("=?UTF-8?B?")){
			String base64Value = value.substring(10,value.indexOf("?=") );
			BASE64Decoder decoder=new BASE64Decoder();
			String decodeString = new String( decoder.decodeBuffer(base64Value), "UTF-8" );
			//System.out.println("[Parsing_Before => " + value);		
			//System.out.println("[Parsing_After =>" + decodeString);
			value = decodeString;
		}
%>
	<tr>
		<input type="hidden" name="<%=name %>" value="<%=value%>" />
		<td><%=name %></td><td><%=value %></tr>
	</tr>
<%		
	}
%> 
 </table>
 
 <!-- 
 업무 session 활성화 시작 부분. 
 아래 내용은 헤더값을 비교할 수 있는 Sample 페이지 이므로 삭제 후 적용한다.
  -->
SSO 로그인ID:<%=sso_userid%><br>
IP<%=request.getRemoteAddr() %>
<%
// session에 SSOID를 기록 후 업무 세션을 시작하기 위한 준비를 한다.
//response.sendRedirect(AP_URL);
%>
<table bordercolor="red"border="1">
	<tr>
		<td>업무 헤더명</td><td>업무 헤더값</td>
	</tr>
<%
	Enumeration enum2 = request.getHeaderNames();
	while(enum2.hasMoreElements()){
		String hKey = enum2.nextElement().toString();
		String hValue = request.getHeader(hKey);
%>
	<tr>
		<td><%=hKey %></td><td><%=hValue %></td>
	</tr>
<%
	}
%>
</table>
</body>
</html>