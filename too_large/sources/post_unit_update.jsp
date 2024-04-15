<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>		<%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>			<%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>		<%-- SepoaOut --%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_128");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");

	String cur_date = SepoaDate.getShortDateString();	//현재날짜 
	String cur_time = SepoaDate.getShortTimeString();  //현재시간 
	String status = "N";	//status	 : C:Create, R:Replace, D:Delete 

%>

<%-- <html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<%

	String[] args = {
		  JSPUtil.paramCheck(request.getParameter("dept_name_loc")     )
		, JSPUtil.paramCheck(request.getParameter("dept_name_eng")     )
		, JSPUtil.paramCheck(request.getParameter("manager_name")      )
		, JSPUtil.paramCheck(request.getParameter("manager_position")  )
		, JSPUtil.paramCheck(request.getParameter("pr_location")       )
		, JSPUtil.paramCheck(request.getParameter("menu_profile_code") )
		, JSPUtil.paramCheck(request.getParameter("ctrl_dept_flag2")   )
		, JSPUtil.paramCheck(request.getParameter("phone_no")          )
		, JSPUtil.paramCheck(request.getParameter("fax_no")            )
		, JSPUtil.paramCheck(request.getParameter("menu_type")         )
		, JSPUtil.paramCheck(request.getParameter("sign_attach_no")    )
		, JSPUtil.paramCheck(status                                    )
		, JSPUtil.paramCheck(cur_date                                  )
		, JSPUtil.paramCheck(cur_time                                  )
		, JSPUtil.paramCheck(user_id                                   )
		//, JSPUtil.paramCheck(house_code                                )
		, JSPUtil.paramCheck(request.getParameter("company_code")      )
		, JSPUtil.paramCheck(request.getParameter("dept")              )
		, JSPUtil.paramCheck(request.getParameter("old_pr_location")   )
	};

	Object[] obj = {args};
	SepoaOut value = ServiceConnector.doService(info, "AD_126", "TRANSACTION","setChange", obj);
	
 %>
<%-- [{
	"status":"<%=value.status%>"
}] --%>
<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		//alert("부서단위가 변경되었습니다.");
		alert("<%=text.get("AD_128.MSG_0106")%>");
		location.href = "post_unit.jsp";
	}else alert("error");
})();
</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
 -->