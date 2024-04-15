<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ page buffer="16kb" %>
<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>
<%@ page import="javax.servlet.RequestDispatcher"%>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<html>
<head>
<form name='xecure'><input type=hidden name='p'></form>
<script language='javascript' src='/AnySign/anySign4PCInterface.js'></script>
<%
   
   //SignVerifierM	verifier = new SignVerifierM ( this.getXecureConfig(), request.getParameter("signed_msg") );
   XecureConfig aXecureConfig = new XecureConfig ();
// SignVerifierM	verifier = new SignVerifierM ( aXecureConfig, request.getParameter("signed_msg") );
   SignVerifier	verifier = new SignVerifier ( aXecureConfig, request.getParameter("signed_msg") );
//  	SignVerifier	verifier = new SignVerifier ( this.getXecureConfig(), request.getParameter("signed_msg") );
%>
</head>
			  
<!---BEGIN_ENC--->
<%
	int	nVerifierResult = verifier.getLastError();
	if ( nVerifierResult != 0 ) {
		//out.println(verifier.getSignerCertificate().getCertPem());
		out.println("서명문에 문제가 있습니다.<br>");
		out.println("오류 번호 : " + verifier.getLastError() + "<br>");

	}
	else {
		out.println("서명 확인 성공<br>");
	}

	if ( nVerifierResult == 0 ) {
%>	

<%//=verifier.getVerifiedMsg_Text()%>
<!-- 서명자 인증서 -->
<%
if(verifier!=null && verifier.getSignerCertificate()!=null){
%>
<%//=verifier.getSignerCertificate().getCertPem()%>
<!-- 서명자 인증서 DN -->
<%//=verifier.getSignerCertificate().getSubject()%>
<br/>
<br/>

<%=verifier.getSignerCertificate().getSubject("cn")%>
<%
        String url = "/servlets/sepoa.svl.co.co_login_process";
        
        SepoaSession.putValue(request, "mode", "setXecureLogin");	//로그인 실패 후 사용
        request.setAttribute("mode", "setXecureLogin");
        request.setAttribute("verifier_key", verifier.getSignerCertificate().getSubject("cn"));
        request.setAttribute("language", "KO");
        request.setAttribute("browser_language", "KO");
        //response.sendRedirect(url);
        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
	
	} else {

%>
<!-- 오류메세지 -->
<%=verifier.getLastErrorMsg()%>
<%
	}
}
%>
<!---END_ENC--->

</head>
</form>
</body>
</html>
