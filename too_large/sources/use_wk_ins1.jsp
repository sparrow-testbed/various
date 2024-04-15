<%@ include file="/include/wisehub_common.jsp" %>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisehub_CEncrypt.jsp"%> <!-- ¾ÏÈ£È­-->

<html>
<head>
<title>우리은행 전자구매시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<%
	if(info == null || info.getSession("ID") == null || info.getSession("ID").equals("")){
		info = new WiseInfo("100","ID=IF ^@^LANGUAGE=KO^@^COMPANY_CODE=CC^@^EMPLOYEE_NO=9999999^@^NAME_LOC=INTERFACE^@^NAME_ENG=INTERFACE^@^DEPARTMENT_NAME_LOC=ALL^@^DEPARTMENT=ALL^@^PLANT_CODE=ALL^@^CTRL_CODE=ALL^@^");		
	}
	
	String house_code = info.getSession("house_code");
	String i_flag = JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_type")));
	String makepw = JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("password")));
	
	/**
  	 * ºñ¹Ð¹øÈ£ ¾ÏÈ£È­
  	 */
  	if(secret_code){
  		CEncrypt encrypt = new CEncrypt("MD5", makepw);
  		makepw = encrypt.getEncryptData();
  	}
	
	String[] temp_user = {
		  house_code
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_name_loc")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_name_eng")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("company_code")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dept")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("resident_no")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("employee_no")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("email")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("position")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("language")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("time_zone")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("country")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("city_code")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("pr_location")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("manager_position")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_type")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("work_type")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("ctrl_code")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("login_ncy")))
	};
	
	String[][] args_user = new String[1][];
	args_user[0] = temp_user;
	
	String[] temp_addr = {
		house_code
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")))
		, "3"
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("zip_code")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no1"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no2"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("phone_no3")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no1"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no2"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("fax_no3")))
		, "" //homepage
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("address_loc")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("address_eng")))
		, ""
		, ""
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("email")))
		, ""
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no1"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no2"))) + JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("mobile_no3")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dely_zip_code")))
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("dely_address_loc")))
	};
	
	String[][] args_addr = new String[1][];
	args_addr[0] = temp_addr;
	
	Object[] obj = {args_user, args_addr, makepw};
	WiseOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION","setInsert", obj);
    
%>

<Script language="javascript">
function Init()
{
	if("<%=value.status%>" == "1") {
		alert("»ç¿ëÀÚ°¡ µî·ÏµÇ¾ú½À´Ï´Ù.");
		if('<%=i_flag%>'=="P")
			parent.close();
		else
			parent.location.href = "/kr/master/user/use_bd_ins1.jsp?";
	} else {
		alert("»ç¿ëÀÚ µî·ÏÀÌ ½ÇÆÐÇÏ¿´½À´Ï´Ù. ");
	}
}
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
