<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--본 페이지는 포털의 링크 역할을 하는 임시 테스트 페이지임 --%>
<%
// getssoid.jsp 대신 gw_login.jsp 를 호출... getssoid.jsp 페이지는 샘플

	String FromSite = request.getParameter("FromSite");


// 개발
	//response.sendRedirect("http://wsypxyt.woorifg.com:7780/epro/gw_login_n.jsp?FromSite="+FromSite);	// Proxy 서버에 업무 URL Context 등록 후 사용할 것

// REAL
	response.sendRedirect("http://wsypxy1.woorifg.com:7780/epro/gw_login_n.jsp?FromSite="+FromSite);	// Proxy 서버에 업무 URL Context 등록 후 사용할 것
%> 

