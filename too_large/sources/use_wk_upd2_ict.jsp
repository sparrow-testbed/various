<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ page import="com.raonsecure.touchen.KeyboardSecurity" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="I_SUP_003";%>


<%

	String flag        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String user_flag   = JSPUtil.nullToEmpty(request.getParameter("user_flag"));	//마이페이지 수정인지 체크 Y

	String[] args = new String[19];
													           
	args[0]  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "password"));
	
	if(!"".equals(args[0])){
			args[0]  = CryptoUtil.getSHA256(args[0]);
	}

                                                  
	args[1]  = JSPUtil.nullToEmpty(request.getParameter("user_name_loc"));   
	args[2]  = JSPUtil.nullToEmpty(request.getParameter("user_name_eng"));   
	//args[3]  = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	args[3]  = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	args[4]  = JSPUtil.nullToEmpty(request.getParameter("dept"));                     
	args[5]  = JSPUtil.nullToEmpty(request.getParameter("resident_no"));                                                   
	args[6]  = JSPUtil.nullToEmpty(request.getParameter("employee_no"));                                                    
	args[7]  = JSPUtil.nullToEmpty(request.getParameter("email"));                                                          
	args[8]  = JSPUtil.nullToEmpty(request.getParameter("position"));                                                       
	args[9]  = JSPUtil.nullToEmpty(request.getParameter("language"));                                                      
	args[10] = JSPUtil.nullToEmpty(request.getParameter("time_zone"));                                                     
	args[11] = JSPUtil.nullToEmpty(request.getParameter("country"));                                                       
	args[12] = JSPUtil.nullToEmpty(request.getParameter("city_code"));                                                     
	args[13] = JSPUtil.nullToEmpty(request.getParameter("pr_location"));                                                   
	args[14] = JSPUtil.nullToEmpty(request.getParameter("manager_position"));                                              
	args[15] = JSPUtil.nullToEmpty(request.getParameter("user_type"));                                                	  
	args[16] = JSPUtil.nullToEmpty(request.getParameter("verifier_key")) != "" ? JSPUtil.nullToEmpty(request.getParameter("verifier_key")) : info.getSession("HOUSE_CODE");
	//args[17] = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	args[17] = JSPUtil.nullToEmpty(info.getSession("ID"));
	args[18] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "old_password"));
	if(!"".equals(args[18])){
		args[18]  = CryptoUtil.getSHA256(args[18]);
	}


	String[] args2 = new String[10];
	args2[0] = "3";//"2";                                                       				
	args2[1] = JSPUtil.nullToEmpty(request.getParameter("zip_code"));                                       
	args2[2] = JSPUtil.nullToEmpty(request.getParameter("phone_no"));                                       
	args2[3] = JSPUtil.nullToEmpty(request.getParameter("fax_no"));                                         
	args2[4] = JSPUtil.nullToEmpty(request.getParameter("address_loc"));                                    
	args2[5] = JSPUtil.nullToEmpty(request.getParameter("address_eng"));                                    
	args2[6] = JSPUtil.nullToEmpty(request.getParameter("email"));                                         
	args2[7] = ""; // ZIP_BOX_NO
    args2[8] = JSPUtil.nullToEmpty(request.getParameter("phone_no2"));
    args2[9] = JSPUtil.nullToEmpty(info.getSession("ID"));                                    

	Object[] obj = {args, args2};
    	String nickName= "s6030";
    	String conType = "TRANSACTION";
    	String MethodName = "setUpdate_ict";
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

<form name='xecure'>
	<input type=hidden name='p'>
</form>

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
