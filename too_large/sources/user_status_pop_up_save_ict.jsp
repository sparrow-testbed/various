<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>
<%@ page import="sepoa.fw.msg.*"%>

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

<%
	javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(request);
	String login_user_password = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("login_user_password"));
	String password = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("password"));
	String password2 = JSPUtil.nullToEmpty(pluginfreeRequest.getParameter("password2"));
	String user_id              = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_id")     ));
	
	if(!"".equals(password)) {
		if(password.equals(login_user_password)) {
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
		
		String msgValidPwd = pwdPolicy.isNewValidPwd(user_id, password); 
	    if(!"".equals(msgValidPwd)){
	    	out.print("<script>");
			out.print("alert('"+msgValidPwd+"');window.history.go(-1);");
			out.print("</script>");    	   
	    	return;
	    }
	}

	Message msg = new Message(info, "STDCOMM");

	String house_code           = info.getSession("HOUSE_CODE");
	String i_flag               = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("i_flag")      ));
	String user_info_flag       = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_info_flag")      ));
	String program              = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("program")     ));
	String user_type            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_type")   ));
	String work_type            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("work_type")   ));
	String company_code         = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("company_code")));
	//String password = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "password"));
 	if(!"".equals(password)){
		password  = CryptoUtil.getSHA256(password);
	}

	String user_name_loc        = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_name_loc")         ));
	String user_name_eng        = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_name_eng")         ));
	String dept                 = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("dept")                  ));
	String resident_no          = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("resident_no")           ));
	String employee_no          = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("employee_no")           ));

	String phone_no             = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no_0")));
	String email                = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("email")                 ));

	String mobile_no            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no_0")));

	String fax_no               = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no_0")));
	String position             = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("position")              ));
	String manager_position     = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("manager_position")      ));
	String language             = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("language")              ));
	String pr_location          = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("pr_location")           ));
	String zip_code             = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("zip_code")              ));
	String time_zone            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("time_zone")             ));
	String country              = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("country")               ));
	String city_code            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("city_code")             ));
	String state                = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("state")                 ));
	//String ctrl_code            = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("ctrl_code")             ));
	String address_loc          = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_loc")           ));
	String address_eng          = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_eng")           ));
	String menu_profile_code    = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("menu_profile_code")     ));
	String origin_user_type     = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("origin_user_type")     ));
	String plm_user_flag        = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("plm_user_flag")     ));
	
	/*
	String login_user_password  = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("login_user_password")     ));
	login_user_password  = CryptoUtil.getSHA256(login_user_password);
	*/
	
	//String login_user_password = JSPUtil.nullToEmpty(KeyboardSecurity.getTouchEnKey(request, "login_user_password"));
	if(!"".equals(login_user_password)){
		login_user_password  = CryptoUtil.getSHA256(login_user_password);
	}
	
	String code_type = "";
	String param_user_type = "";

	if(info.getSession("USER_TYPE").equals("S") || info.getSession("USER_TYPE").equals("P"))
	{
		param_user_type = origin_user_type;
	}
	else
	{
		param_user_type = user_type;
	}

/*
	if(user_type.equals("S")){
		code_type = "2";
	} else {
		code_type = "3";
	}
*/
	code_type = "3";

	String[][] args_user = {
		{
			 //   user_type
			 	param_user_type
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
			//  , ctrl_code
			  , menu_profile_code
			  , plm_user_flag
			  , user_id
			  , login_user_password
		}
	};

	String[][] args_addr = {
		{
			  zip_code
			, phone_no
			, mobile_no
			, fax_no
			, address_loc
			, address_eng
			, email
		//	, house_code
			, user_id
			, code_type
		}
	};

	Object[] obj = {program, password, args_user, args_addr, user_info_flag};
	
	
	SepoaOut value = ServiceConnector.doService(info, "I_AD_132", "TRANSACTION","setUserInfoUpdate", obj);

	Logger.debug.println(info.getSession("ID"),this,"i_flag==//"+i_flag+"//");
%>
<%-- [{
	"status":<%=value.status%>,
	"message":"<%=value.message%>",
	"i_flag":"<%=i_flag%>"
}] --%>

<%-- <html>
<head>
<title></title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>--%>
<script language="JavaScript"> 

function Init()
{
	var message = "<%=value.message%>";
	if(<%=value.status%> == 1)
	{
		alert(message);
<%-- 		alert('<%=i_flag%>'); --%>
		if('<%=i_flag%>' == "P") {
			top.window.close();
		} else {
			//parent.parent.window.close();
			window.close();
		}
	} else {
		alert(message);
		
		if('<%=i_flag%>' == "P") {
			top.window.close();
		} else {
			//parent.parent.window.close();
			//window.close();
			history.back(-1);
		}
	}
}

</script>
</head>
<body bgcolor="#FBFAF2" onLoad="Init();">
</body>
</html>