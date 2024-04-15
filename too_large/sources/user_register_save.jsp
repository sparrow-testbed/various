<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%-- <html>
<head>
<title></title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_132");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	if(info == null || info.getSession("ID") == null || info.getSession("ID").equals("")){
		//info = new SepoaInfo("100","ID=IF ^@^LANGUAGE=KO^@^COMPANY_CODE=CC^@^EMPLOYEE_NO=9999999^@^NAME_LOC=INTERFACE^@^NAME_ENG=INTERFACE^@^DEPARTMENT_NAME_LOC=ALL^@^DEPARTMENT=ALL^@^PLANT_CODE=ALL^@^CTRL_CODE=ALL^@^");
		String user_os_lang = (String)(session.getAttribute("USER_OS_LANGUAGE")) == null ? "KO" : (String)(session.getAttribute("USER_OS_LANGUAGE"));
		info = new SepoaInfo("100","ID=SUPPLIER^@^LANGUAGE=" + user_os_lang + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	}

	String house_code = info.getSession("house_code");
	String i_flag = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_type")));
	//out.println("i_flag="+i_flag);
	String makepw = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("password")));
	String user_type = "";

	if(info.getSession("USER_TYPE").equals("S") || info.getSession("USER_TYPE").equals("P"))
	{
		user_type = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("origin_user_type")));
	}
	else
	{
		user_type = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_type")));
	}

	String[] temp_user = {
		  JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_id")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_name_loc")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_name_eng")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("company_code")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("dept")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("resident_no")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("employee_no")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("email")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("position")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("language")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("time_zone")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("country")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("city_code")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("pr_location")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("manager_position")))
		//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_type")))
		, user_type
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("work_type")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("plm_user_flag")))
		//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("ctrl_code")))
	};

	String[][] args_user = new String[1][];
	args_user[0] = temp_user;

	String[] temp_addr = {
		JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_id")))
		, "3"
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("zip_code")))
//		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no3")))
//		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no3")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no0")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no0")))
		, "" //homepage
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_loc")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_eng")))
		, ""
		, ""
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("email")))
		, ""
//		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no3")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no0")))

	};

	String[][] args_addr = new String[1][];
	args_addr[0] = temp_addr;

	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_first_name_eng")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_last_name_eng")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("city_name")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("position_name")))
	
	Map<String, Object> data = new HashMap();
	data.put("user_id", JSPUtil.paramCheck(request.getParameter("user_id")));
	data.put("password", JSPUtil.paramCheck(request.getParameter("password")));
	data.put("user_name_loc", JSPUtil.paramCheck(request.getParameter("user_name_loc")));
	data.put("user_name_eng", JSPUtil.paramCheck(request.getParameter("user_name_eng")));
	data.put("dept", JSPUtil.paramCheck(request.getParameter("dept")));
	data.put("resident_no", JSPUtil.paramCheck(request.getParameter("resident_no")));
	data.put("employee_no", JSPUtil.paramCheck(request.getParameter("employee_no")));
	data.put("email", JSPUtil.paramCheck(request.getParameter("email")));
	data.put("position", JSPUtil.paramCheck(request.getParameter("position")));
	data.put("language", JSPUtil.paramCheck(request.getParameter("language")));
	data.put("time_zone", JSPUtil.paramCheck(request.getParameter("time_zone")));
	data.put("country", JSPUtil.paramCheck(request.getParameter("country")));
	data.put("city_code", JSPUtil.paramCheck(request.getParameter("city_code")));
	data.put("pr_location", JSPUtil.paramCheck(request.getParameter("pr_location")));
	data.put("manager_position", JSPUtil.paramCheck(request.getParameter("manager_position")));
	data.put("user_type", JSPUtil.paramCheck(request.getParameter("user_type")));
	data.put("work_type", JSPUtil.paramCheck(request.getParameter("work_type")));
	data.put("plm_user_flag", JSPUtil.paramCheck(request.getParameter("plm_user_flag")));
	
	data.put("zip_code", JSPUtil.paramCheck(request.getParameter("zip_code")));
	data.put("phone_no0", JSPUtil.paramCheck(request.getParameter("phone_no0")));
	data.put("fax_no0", JSPUtil.paramCheck(request.getParameter("fax_no0")));
	data.put("address_loc", JSPUtil.paramCheck(request.getParameter("address_loc")));
	data.put("address_eng", JSPUtil.paramCheck(request.getParameter("address_eng")));
	data.put("mobile_no0", JSPUtil.paramCheck(request.getParameter("mobile_no0")));
	
	
	 
	
	Object[] obj = {data};
	SepoaOut value = ServiceConnector.doService(info, "AD_132", "TRANSACTION","setInsert", obj);

%>
<%-- [{
	"status":"<%=value.status%>",
	"i_flag":"<%=i_flag%>"
}] --%>
<Script language="javascript">

(function Init()
{
	if("<%=value.status%>" == "1")
	{
		//alert("사용자가 등록되었습니다.");
		alert("<%=text.get("AD_132.MSG_0158")%>");
		if('<%=i_flag%>'=="P")
			//parent.window.close();
			window.close();
		else location.href = "user_register.jsp?";
	} else
		//alert("사용자 등록이 실패하였습니다. ");
		alert("<%=text.get("AD_132.MSG_0159")%>");
})();

</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->