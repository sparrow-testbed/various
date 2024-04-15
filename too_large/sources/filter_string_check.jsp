<%@ page contentType = "text/html; charset=UTF-8" %>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/><!-- IE 최신 버전으로 자동 전환하도록 -->
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.math.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="sepoa.fw.cfg.*"%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.ses.*"%>
<%@ page import="sepoa.svc.common.*"%>

<%!
    public String fsFilter_String_Check(String strType, String strValue) {
		// strType 코드에 따라서 아래의 문자를 막아서 사용00 : 전체검색
		// 00 : 전체검색
		
		strValue = strValue.toLowerCase();
		if (strValue.indexOf("document") > 0)	return "문자[ document ]는 사용할 수 없습니다.";
		if (strValue.indexOf("cookie") > 0)		return "문자[ cookie ]는 사용할 수 없습니다.";
		if (strValue.indexOf("forms") > 0)		return "문자[ forms ]는 사용할 수 없습니다.";
		if (strValue.indexOf("body") > 0)		return "문자[ body ]는 사용할 수 없습니다.";
		if (strValue.indexOf("script") > 0)		return "문자[ script ]는 사용할 수 없습니다.";
		if (strValue.indexOf(">") > 0)			return "문자[ > ]는 사용할 수 없습니다.";
		if (strValue.indexOf("<") > 0)			return "문자[ < ]는 사용할 수 없습니다.";
		if (strValue.indexOf("'") > 0)			return "문자[ ' ]는 사용할 수 없습니다.";
		if (strValue.indexOf("\"") > 0)			return "문자[ “ ]는 사용할 수 없습니다.";
		if (strValue.indexOf("=") > 0)			return "문자[ = ]는 사용할 수 없습니다.";
		if (strValue.indexOf(":") > 0)			return "문자[ : ]는 사용할 수 없습니다.";
		if (strValue.indexOf("?") > 0)			return "문자[ ? ]는 사용할 수 없습니다.";
		if (strValue.indexOf("&") > 0)			return "문자[ & ]는 사용할 수 없습니다.";
		if (strValue.indexOf("/") > 0)			return "문자[ / ]는 사용할 수 없습니다.";
		
		return "";
		
 
    }

%>
