<%@ page contentType = "text/html; charset=UTF-8" %>

<%@page import="com.nprotect.pluginfree.modules.PluginFreeConfig"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.nprotect.pluginfree.PluginFree"%>
<%@page import="com.nprotect.pluginfree.PluginFreeDTO"%>
<%@page import="com.nprotect.pluginfree.PluginFreeException"%>
<%@page import="com.nprotect.pluginfree.PluginFreeWarning"%>
<%@page import="com.nprotect.pluginfree.PluginFreeDeviceDTO"%>
<%@page import="com.nprotect.pluginfree.modules.PluginFreeRequest"%>
<%@page import="com.nprotect.pluginfree.util.RequestUtil"%>
<%@page import="com.nprotect.pluginfree.util.StringUtil"%>
<%@page import="com.nprotect.pluginfree.transfer.InitechTransferImpl"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="sepoa.fw.util.pwdPolicy"%>

<%@ page buffer="16kb" %>
<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="SUP_003";%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- Sepoahub Common Scripts -->
<form name='xecure'><input type=hidden name='p'></form>
<script language='javascript' src='/AnySign/anySign4PCInterface.js'></script>

<%
	XecureConfig aXecureConfig = new XecureConfig ();
	//SignVerifierM	verifier = new SignVerifierM ( this.getXecureConfig(), request.getParameter("signed_msg") );
	//SignVerifierM	verifier = new SignVerifierM ( aXecureConfig, request.getParameter("signed_msg") );
	SignVerifier	verifier = new SignVerifier ( aXecureConfig, request.getParameter("signed_msg") );
%>

<%
	String verifier_key = "";
	String error_msg    = "";

	int	nVerifierResult = verifier.getLastError();
	if ( nVerifierResult != 0 ) {
		//out.println(verifier.getSignerCertificate().getCertPem());
		out.println("서명문에 문제가 있습니다.<br>");
		out.println("오류 번호 : " + verifier.getLastError() + "<br>");

	}
	else {
		//out.println("서명 확인 성공<br>");
	}

	if ( nVerifierResult == 0 ) {
		
		if(verifier!=null && verifier.getSignerCertificate()!=null){
			verifier_key = verifier.getSignerCertificate().getSubject("cn");	
		} else {
		 error_msg = verifier.getLastErrorMsg();
		}
	}
%>

<%
	javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(request);
	String old_password = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("old_password"));
	String password = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("password"));
	String password2 = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("password2"));
	
	if(!"".equals(password)) {
		if(password.equals(old_password)) {
			out.print("<script>");
			out.print("alert('기존 비밀번호와 새 비밀번호는 동일할 수 없습니다.');window.history.go(-1);");
			out.print("</script>");    	   
	    	return;	    		
		}
	
		if(!password.equals(password2)) {
			out.print("<script>");
			out.print("alert('새 패스워드 두개가 일치하지 않습니다.');window.history.go(-1);");
			out.print("</script>");    	 
			return;
		}
		
		String msgValidPwd = pwdPolicy.isNewValidPwd(info.getSession("ID"), password); 
	    if(!"".equals(msgValidPwd)){
	    	out.print("<script>");
			out.print("alert('"+msgValidPwd+"');window.history.go(-1);");
			out.print("</script>");    	   
	    	return;
	    }
	}

/* String str_user_id = KeyboardSecurity.getTouchEnKey(request, "user_id");
String str_password = KeyboardSecurity.getTouchEnKey(request, "password");
System.out.println("str_user_id:"+request.getParameter("E2E_user_id"));
System.out.println("str_password:"+request.getParameter("E2E_password"));
System.out.println("dec_user_id:"+str_user_id);
System.out.println("dec_password:"+str_password); */

	// Session이 없는 바깥쪽 에서도 불리기에 가상 info를 만든다. -- 삭제 (이수헌 : 2004/01/16)
	//SepoaInfo info = new SepoaInfo("100",null);

	String flag        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String user_flag   = JSPUtil.nullToEmpty(request.getParameter("user_flag"));	//마이페이지 수정인지 체크 Y
	
	String signed_msg  = JSPUtil.nullToEmpty(request.getParameter("signed_msg"));	//공인증서 등록정보

	String[] args = new String[20];
													           
	args[0]  = password;
//	args[0]  = JSPUtil.nullToEmpty(request.getParameter("password"));
//	args[0]  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "password"));
//System.out.println("args[0]:"+args[0]);
	if(!"".equals(args[0])){
		args[0]  = CryptoUtil.getSHA256(args[0]);
	}
	/*
  		암호화
  	*/
  	/* if(secret_code && !"".equals(args[0])){
  		CEncrypt encrypt = new CEncrypt("MD5", args[0]);
  		args[0] = encrypt.getEncryptData();
  	}      */                                                  
	args[1]  = JSPUtil.nullToEmpty(request.getParameter("user_name_loc"));   
	args[2]  = "";//JSPUtil.nullToEmpty(request.getParameter("user_name_eng"));   
	args[3]  = JSPUtil.nullToEmpty(request.getParameter("company_code"));                                                   
	args[4]  = JSPUtil.nullToEmpty(request.getParameter("dept"));                     
	args[5]  = JSPUtil.nullToEmpty(request.getParameter("resident_no"));                                                   
	args[6]  = "";//JSPUtil.nullToEmpty(request.getParameter("employee_no"));                                                    
	args[7]  = JSPUtil.nullToEmpty(request.getParameter("email"));                                                          
	args[8]  = "";//JSPUtil.nullToEmpty(request.getParameter("position"));                                                       
	args[9]  = "KO";//JSPUtil.nullToEmpty(request.getParameter("language"));                                                      
	args[10] = "G08";//JSPUtil.nullToEmpty(request.getParameter("time_zone"));                                                     
	args[11] = "KR";//JSPUtil.nullToEmpty(request.getParameter("country"));                                                       
	args[12] = "";//JSPUtil.nullToEmpty(request.getParameter("city_code"));                                                     
	args[13] = JSPUtil.nullToEmpty(request.getParameter("pr_location"));                                                   
	args[14] = "";//JSPUtil.nullToEmpty(request.getParameter("manager_position"));                                              
	args[15] = JSPUtil.nullToEmpty(request.getParameter("user_type"));                                                	  
	args[16] = verifier_key;
	args[17] = JSPUtil.nullToEmpty(request.getParameter("user_id"));
//	args[18] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "old_password"));
//	args[18] = JSPUtil.nullToEmpty(request.getParameter("old_password"));
	args[18] = old_password;
	if(!"".equals(args[18])){
		args[18]  = CryptoUtil.getSHA256(args[18]);
	}
//	args[16] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "user_id"));
    args[19] = JSPUtil.nullToEmpty(request.getParameter("uc_yn"));
	
	String[] args2 = new String[10];
	args2[0] = "3";//"2";                                                       				
	args2[1] = JSPUtil.nullToEmpty(request.getParameter("zip_code"));                                       
	args2[2] = JSPUtil.nullToEmpty(request.getParameter("phone_no"));                                       
	args2[3] = JSPUtil.nullToEmpty(request.getParameter("fax_no"));                                         
	//args2[4] = ""; // HOMEPAGE                                                                    
	args2[4] = JSPUtil.nullToEmpty2(request.getParameter("address_loc"));                                    
	args2[5] = "";//JSPUtil.nullToEmpty(request.getParameter("address_eng"));                                    
	//args2[7] = ""; // CEO_NAME_LOC
	//args2[8] = ""; // CEO_NAME_ENG
	args2[6] = JSPUtil.nullToEmpty(request.getParameter("email"));                                         
	args2[7] = ""; // ZIP_BOX_NO
    args2[8] = JSPUtil.nullToEmpty(request.getParameter("phone_no2"));
    args2[9] = JSPUtil.nullToEmpty(request.getParameter("user_id"));                                    
//     args2[9] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "user_id"));                                

	Object[] obj = {args, args2};
    	String nickName= "s6030";
    	String conType = "TRANSACTION";
    	String MethodName = "setUpdate";
        SepoaOut value = null;
        SepoaRemote ws = null;


	try {

		ws = new SepoaRemote(nickName,conType,info);
		value = ws.lookup(MethodName, obj);

		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
   		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(SepoaServiceException wse){
		Logger.err.println(info.getSession("ID"),request, " err = " + wse.getMessage());
	}catch(Exception e){
		Logger.err.println(info.getSession("ID"),request, " err = " + e.getMessage());
	}


	finally{
		try{

			ws.Release();
		} catch(Exception e) { }
	}


%>



<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="JavaScript">
<!--
function Init() {

	if(<%=value.status%> == 1) {
		alert("성공적으로 수정되었습니다.");
		
	} else {
		alert("수정에 실패하셨습니다.");
	}
	
	if('<%=user_flag%>' == "Y") {
		top.window.close();
	}
	else if('<%=flag%>' == "P"){
		window.close();
	}
	else {
		parent.parent.window.opener.doSelect();
		parent.close();
	}
}
//-->
</script>
</head>
<!---- START USER SOURCE CODE ---->

<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
<!---- END OF USER SOURCE CODE ---->
</body>
</html>
