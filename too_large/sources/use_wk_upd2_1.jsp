<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%-- <%@ include file="/include/sepoahub_CEncrypt.jsp"%> --%> <!-- 암호화-->

<%
	//Message msg = new Message("STDCOMM");
	
	String house_code           = info.getSession("HOUSE_CODE");
	String i_flag               = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("i_flag")      ));
	String program              = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("program")     ));
	String user_type            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_type")   ));
	String work_type            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("work_type")   ));
	String company_code         = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("company_code")));
	String user_id              = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")     ));
	String password             = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("password")    ));
	/**
  	 * 암호화
  	 */
//   	if(secret_code && !"".equals(password)){
//   		CEncrypt encrypt = new CEncrypt("MD5", password);
//   		password = encrypt.getEncryptData();
//   	}
  	
	String user_name_loc        = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_name_loc")         ));
	String user_name_eng        = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_name_eng")         ));
	String dept                 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dept")                  ));
	String resident_no          = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("resident_no")           ));
	String employee_no          = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("employee_no")           ));
	String phone_no             = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no_1"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no_2"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no_3")));
	String email                = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("email")                 ));
	String mobile_no            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no_1"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no_2"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no_3")));
	String fax_no               = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no_1"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no_2"))) + JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no_3")));
	String position             = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("position")              ));
	String manager_position     = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("manager_position")      ));
	String language             = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("language")              ));
	String pr_location          = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("pr_location")           ));
	String time_zone            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("time_zone")             ));
	String country              = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("country")               ));
	String city_code            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("city_code")             ));
	String state                = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("state")                 ));
	String ctrl_code            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("ctrl_code")             ));
	String zip_code             = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("zip_code")              ));
	String address_loc          = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("address_loc")           ));
	String dely_zip_code        = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dely_zip_code")              ));
	String dely_address_loc     = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dely_address_loc")      ));
	String address_eng          = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("address_eng")           ));
	String menu_profile_code    = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("menu_profile_code")     ));
	String login_ncy   			= JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("login_ncy")     ));
	String code_type = "";
	System.out.println("+++++++++++"+user_type+"+++++++++++++");
	if(user_type.equals("S")){
		code_type = "2";
	} else {
		code_type = "3";
	}
	
	String[][] args_user = {
		{
			    user_type    
			  , work_type          
			  , company_code      
			  , user_name_loc
			  , user_name_eng
			  , dept       
			  , resident_no  
			  ,	employee_no  
			  , email             
			  , position     
			  , manager_position   
			  , language          
			  , pr_location
			  , time_zone    
			  , country            
			  , city_code         
			  , state      
			  , ctrl_code			  
			  , menu_profile_code
			  , login_ncy
			  , user_id			  
		}
	};
	if(user_type.equals("S")){
		user_id = company_code;
	}
	String[][] args_addr = {
		{
			  zip_code
			, phone_no
			, mobile_no
			, fax_no
			, address_loc
			, address_eng
			, email
			, dely_zip_code
			, dely_address_loc
			, house_code
			, user_id
			, code_type
		}
	};

	Object[] obj = {program, password, args_user, args_addr};
	SepoaOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION","setUserInfoUpdate", obj);
	
Logger.debug.println(info.getSession("ID"),this,"i_flag==//"+i_flag+"//");
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<script language="JavaScript">
	
function Init() 
{
	var message = "<%=value.message%>";
	if(<%=value.status%> == 1) 
	{
		alert(message);
		if('<%=i_flag%>' == "P") {
			top.window.close();
		} else {
			parent.parent.window.close();
		}
	} else {
		alert(message);
	}
}

</script>
</head>
<body bgcolor="#FBFAF2" onLoad="Init()">
</body>
</html>
