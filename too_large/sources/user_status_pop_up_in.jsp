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
	multilang_id.addElement("AD_135");
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
	out.println("i_flag="+i_flag);

	String makepw = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("password")));

	String[] temp_user = {
		//  house_code
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
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_type")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("work_type")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("ctrl_code")))
	};

	String[][] args_user = new String[1][];
	args_user[0] = temp_user;

	String[] temp_addr = {
		//house_code
		  JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_id")))
		, "3"
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("zip_code")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("phone_no3")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("fax_no3")))
		, "" //homepage
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_loc")))
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("address_eng")))
		, ""
		, ""
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("email")))
		, ""
		, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no1"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no2"))) + JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("mobile_no3")))

	};

	String[][] args_addr = new String[1][];
	args_addr[0] = temp_addr;

	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_first_name_eng")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_last_name_eng")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("city_name")))
	//, JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("position_name")))

	Object[] obj = {args_user, args_addr, makepw};
	SepoaOut value = ServiceConnector.doService(info, "AD_132", "TRANSACTION","setInsert", obj);

%>

<Script language="javascript">

(function Init()
{
	if("<%=value.status%>" == "1")
	{
		//alert("사용자가 등록되었습니다.");
		alert("<%=text.get("AD_035.MSG_0200")%>");
		if('<%=i_flag%>'=="P")
			//parent.window.close();
			close();
		else location.href = "uesr_register.jsp?";
	} else
		//alert("사용자 등록이 실패하였습니다. ");
		alert("<%=text.get("AD_035.MSG_0201")%>");
})();

</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->