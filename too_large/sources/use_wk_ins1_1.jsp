<!--  /home/user/sepoahub/sepoahub_package/myserver/V1.0.0/sepoadoc/s_kr/admin/user/use_wk_ins1.jsp -->
<!--
 Title:        Operating Create
 Description:
 Copyright:    Copyright (c)
 Company:      ICOMPIA <p>
 @author       chan-gon ,Moon<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ page import="com.raonsecure.touchen.KeyboardSecurity" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID= "SUP_001"; %>


<html>
<head>
<title>우리은행 전자구매시스템</title>
<!-- META TAG 정의  -->
<!-- Sepoahub Common Scripts -->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<%
	// Session이 없는 바깥쪽 에서도 불리기에 가상 info를 만든다. -- 삭제 (이수헌 : 2004/01/16)
	//SepoaInfo info = new SepoaInfo("100",null);

	String flag = JSPUtil.nullToEmpty(request.getParameter("flag"));

	String[] args = new String[18];
//	args[0]  = JSPUtil.nullToEmpty(request.getParameter("user_id"));														           
//	args[1]  = JSPUtil.nullToEmpty(request.getParameter("password"));
	args[0]  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "user_id"));												           
	args[1]  = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "password"));		
	if(!"".equals(args[1])){
		args[1]  = CryptoUtil.getSHA256(args[1]);
	}
	/*
  		암호화
  	*/
  	/* if(secret_code){
  		CEncrypt encrypt = new CEncrypt("MD5", args[1]);
  		args[1] = encrypt.getEncryptData();
  	} */
  	                                                       
	args[2]  = JSPUtil.nullToEmpty(request.getParameter("user_name_loc"));   
	args[3]  = "";//JSPUtil.nullToEmpty(request.getParameter("user_name_eng"));   
	args[4]  = JSPUtil.nullToEmpty(request.getParameter("company_code"));                                                   
	args[5]  = "";//JSPUtil.nullToEmpty(request.getParameter("dept"));                     
	args[6]  = JSPUtil.nullToEmpty(request.getParameter("resident_no"));                                                    
	args[7]  = "";//JSPUtil.nullToEmpty(request.getParameter("employee_no"));                                                    
	args[8]  = JSPUtil.nullToEmpty(request.getParameter("email"));                                                          
	args[9]  = "";//JSPUtil.nullToEmpty(request.getParameter("position"));                                                       
	args[10] = "KO";//JSPUtil.nullToEmpty(request.getParameter("language"));                                                      
	args[11] = "G09";//JSPUtil.nullToEmpty(request.getParameter("time_zone"));                                                     
	args[12] = "KR";//JSPUtil.nullToEmpty(request.getParameter("country"));                                                       
	args[13] = "";//JSPUtil.nullToEmpty(request.getParameter("city_code"));                                                     
	args[14] = JSPUtil.nullToEmpty(request.getParameter("pr_location"));                                                   
	args[15] = "";//JSPUtil.nullToEmpty(request.getParameter("manager_position"));                                              
	args[16] = JSPUtil.nullToEmpty(request.getParameter("user_type"));                                                     
	args[17] = JSPUtil.nullToEmpty(request.getParameter("work_type"));                                                 	  
	
	String[] args2 = new String[13];
	//args2[0] = JSPUtil.nullToEmpty(request.getParameter("user_id"));                                        
	args2[0] = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "user_id"));	                                     
	args2[1] = "3";                                                       				
	args2[2] = JSPUtil.nullToEmpty(request.getParameter("zip_code"));                                       
	args2[3] = JSPUtil.nullToEmpty(request.getParameter("phone_no"));                                       
	args2[4] = JSPUtil.nullToEmpty(request.getParameter("fax_no"));                                         
	args2[5] = "";                                                                     
	args2[6] = JSPUtil.nullToEmpty(request.getParameter("address_loc"));                                    
	args2[7] = "";//JSPUtil.nullToEmpty(request.getParameter("address_eng"));                                    
	args2[8] = "";                                                        				
	args2[9] = "";                                                     					
	args2[10] = JSPUtil.nullToEmpty(request.getParameter("email"));                                         
	args2[11] = "";                                                   					
    args2[12] = JSPUtil.nullToEmpty(request.getParameter("mobile_no"));                                    

     
    
	Object[] obj = {args, args2};
    	String nickName= "s6030";
    	String conType = "TRANSACTION";
    	String MethodName = "setInsert";
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

<Script language="javascript">

function Init()
{
   if("<%=value.status%>" == "1")
    {
    	alert("사용자가 등록되었습니다.");
    	if('<%=flag%>'=="P"){
    		parent.window.close();
    	}else{
    		parent.go_list('/s_kr/admin/user/use_bd_ins1.jsp', 'MUO141000008', 4, '');
    		
    		//window.close();
    	}
    }else alert("사용자 등록이 실패하였습니다. ");
}


</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
