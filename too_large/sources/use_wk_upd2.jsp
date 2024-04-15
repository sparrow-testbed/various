<!--
 Title:        	SUP_003  <p>
 Description:  	House Create <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team : Youn Hea Yean<p>
 @version      	1.0.0<p>
 @Comment       사용자 상세 내용 업데이트
!-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ page import="com.raonsecure.touchen.KeyboardSecurity" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="SUP_003";%>


<%

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

	String[] args = new String[20];
													           
//	args[0]  = JSPUtil.nullToEmpty(request.getParameter("password"));
	args[0]  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "password"));
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
	//args[3]  = JSPUtil.nullToEmpty(request.getParameter("company_code"));                                                   
	args[3]  = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	args[4]  = JSPUtil.nullToEmpty(request.getParameter("dept"));                     
	args[5]  = JSPUtil.nullToEmpty(request.getParameter("resident_no"));                                                   
	args[6]  = JSPUtil.nullToEmpty(request.getParameter("employee_no"));                                                    
	args[7]  = JSPUtil.nullToEmpty(request.getParameter("email"));                                                          
	args[8]  = "";//JSPUtil.nullToEmpty(request.getParameter("position"));                                                       
	args[9]  = "KO";//JSPUtil.nullToEmpty(request.getParameter("language"));                                                      
	args[10] = "G08";//JSPUtil.nullToEmpty(request.getParameter("time_zone"));                                                     
	args[11] = "KR";//JSPUtil.nullToEmpty(request.getParameter("country"));                                                       
	args[12] = "";//JSPUtil.nullToEmpty(request.getParameter("city_code"));                                                     
	args[13] = JSPUtil.nullToEmpty(request.getParameter("pr_location"));                                                   
	args[14] = "";//JSPUtil.nullToEmpty(request.getParameter("manager_position"));                                              
	args[15] = JSPUtil.nullToEmpty(request.getParameter("user_type"));                                                	  
	args[16] = JSPUtil.nullToEmpty(request.getParameter("verifier_key")) != "" ? JSPUtil.nullToEmpty(request.getParameter("verifier_key")) : info.getSession("HOUSE_CODE");
	//args[17] = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	args[17] = JSPUtil.nullToEmpty(info.getSession("ID"));
//	args[16] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "user_id"));
	args[18] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "old_password"));
	if(!"".equals(args[18])){
		args[18]  = CryptoUtil.getSHA256(args[18]);
	}
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
    args2[9] = JSPUtil.nullToEmpty(info.getSession("ID"));
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


<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- Sepoahub Common Scripts -->

<form name='xecure'><input type=hidden name='p'></form>
<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404" CODEBASE="http://phobos.softforum.co.kr:8188/XecureObject/xw50_install.cab#Version=5,0,3,6" width=0 height=0>No XecureWeb 5.0 PlugIn</OBJECT>
<script language='javascript' src='/XecureObject/xecureweb.js'></script>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="JavaScript">
<!--
function Init() {

	if(<%=value.status%> == 1) {
		alert("성공적으로 수정되었습니다.");
		if('<%=flag%>' == "P" || '<%=user_flag%>' == "Y"  ) {
			top.window.close();
		}
		else {
			parent.parent.window.opener.doSelect();
			parent.close();
		}
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
<!--jsp:include page="/include/us_template_end.jsp" flush="true" / -->
</body>
</html>
