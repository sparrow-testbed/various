<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_135");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String i_flag               = JSPUtil.CheckInjection(request.getParameter("i_flag"));
	String program              = JSPUtil.CheckInjection(request.getParameter("program"));

	String user_type            = JSPUtil.CheckInjection(request.getParameter("user_type"));
	String work_type            = JSPUtil.CheckInjection(request.getParameter("work_type"));
	String company_code         = JSPUtil.CheckInjection(request.getParameter("company_code"));
	String i_user_id            = JSPUtil.CheckInjection(request.getParameter("i_user_id"));
	String password             = JSPUtil.CheckInjection(request.getParameter("password"));
	if(password==null || password.equals("")) password = JSPUtil.CheckInjection(request.getParameter("old_pwd"));
	String user_name_loc        = JSPUtil.CheckInjection(request.getParameter("user_name_loc"));
	String user_name_eng        = JSPUtil.CheckInjection(request.getParameter("user_name_eng"));
	String dept                 = JSPUtil.CheckInjection(request.getParameter("dept"));
	String resident_no          = JSPUtil.CheckInjection(request.getParameter("resident_no"));
	String employee_no          = JSPUtil.CheckInjection(request.getParameter("employee_no"));
//	String phone_no             = JSPUtil.CheckInjection(request.getParameter("phone_no_1")) + JSPUtil.CheckInjection(request.getParameter("phone_no_2")) + JSPUtil.CheckInjection(request.getParameter("phone_no_3"));
	String phone_no             = JSPUtil.CheckInjection(request.getParameter("phone_no_0"));
	String email                = JSPUtil.CheckInjection(request.getParameter("email"));
//	String mobile_no 			= JSPUtil.CheckInjection(request.getParameter("mobile_no_1")) + JSPUtil.CheckInjection(request.getParameter("mobile_no_2")) + JSPUtil.CheckInjection(request.getParameter("mobile_no_3"));
//	String fax_no               = JSPUtil.CheckInjection(request.getParameter("fax_no_1")) + JSPUtil.CheckInjection(request.getParameter("fax_no_2")) + JSPUtil.CheckInjection(request.getParameter("fax_no_3"));
	String mobile_no 			= JSPUtil.CheckInjection(request.getParameter("mobile_no_0"));
	String fax_no               = JSPUtil.CheckInjection(request.getParameter("fax_no_0"));
	String ctrl_code            = JSPUtil.CheckInjection(request.getParameter("ctrl_code"));

	//String smile_user_id              = JSPUtil.CheckInjection(request.getParameter("smile_user_id"));
	//String smile_password             = JSPUtil.CheckInjection(request.getParameter("smile_password"));
	//if(smile_password.equals("") || smile_password==null) smile_password = JSPUtil.CheckInjection(request.getParameter("smile_old_pwd"));

	String[][] data1 = {{ user_name_eng, email, i_user_id }};
	String[][] data2 = {{ phone_no, mobile_no, fax_no, email, i_user_id }};

	Object[] obj = {i_user_id, password};
	SepoaOut value = ServiceConnector.doService(info, "AD_132", "TRANSACTION","setPwdReset", obj);

	SepoaOut value2 = null;

	if(value.status == 1){

		Object[] obj2 = {(Object[])data1, (Object[])data2};
		String nickName= "AD_132";
		String conType = "TRANSACTION";
		String MethodName = "setUserInfoUpdate2";
		SepoaRemote ws = null;
		int result = -1;

		try {
		   	ws = new sepoa.fw.util.SepoaRemote(nickName, conType,info);
		   	value2 = ws.lookup(MethodName, obj2);

			result = 1;

		} catch(Exception e) {
			result = 0;
		} finally {
			try {
				ws.Release();
			} catch(Exception e){}
		}

	}

%>
<%-- [{
	"status":"<%=value2.status%>",
	"message0300":"<%=text.get("AD_135.MSG_0300")%>",
	"message0301":"<%=text.get("AD_135.MSG_0301")%>"
}] --%>

<%-- <html>
<head>
<title></title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<script language="JavaScript">

(function Init() {
	if(<%=value2.status%> == 1) {
		//alert("성공적으로 수정되었습니다.");
		alert("<%=text.get("AD_135.MSG_0300")%>");
	} else {
		//alert("수정에 실패하셨습니다.");
		alert("<%=text.get("AD_135.MSG_0301")%>");
	}
	window.returnValue  = true;
	self.close();
})();
</script>
<!--</head>
<body bgcolor="#FBFAF2" onLoad="Init()">
</body>
</html> -->