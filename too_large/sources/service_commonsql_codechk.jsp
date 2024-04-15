<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	String user_id = JSPUtil.paramCheck(info.getSession("ID"));
	String user_name_loc = JSPUtil.paramCheck(info.getSession("NAME_LOC"));
	String user_name_eng = JSPUtil.paramCheck(info.getSession("NAME_ENG"));
	String user_dept = JSPUtil.paramCheck(info.getSession("DEPARTMENT"));
	String house_code = JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_038");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

%>

<%-- <html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<%
	String[] args = new String[2];
	//args[0] = house_code;
	args[0] = JSPUtil.paramCheck(request.getParameter("type")) +JSPUtil.paramCheck(request.getParameter("id"));
	args[1] = JSPUtil.paramCheck(request.getParameter("language"));

	Object[] obj = {args};
	String nickName= "AD_037";
	String conType = "CONNECTION";
	String MethodName = "getDuplicate";

	SepoaOut value =  null;
	SepoaRemote remote = null;


	try {
		remote = new SepoaRemote(nickName, conType, info);
		value = remote.lookup(MethodName, obj);

	}
	catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}
	catch(Exception e) {
		Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	}
	finally{
		try{
			remote.Release();
		}catch(Exception e){}
	}
%>
<%-- [{
	"status":"<%=value.status%>",
	"count":"<%=value.result[0]%>"
}] --%>

<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		var count = "<%=value.result[0]%>";
		if(count != 0)
		{
			alert("<%=text.get("AD_038.MSG_0109")%>");
			parent.checkCodeDulicate('ng');
		}
		else
		{
			alert("<%=text.get("AD_038.MSG_0110")%>");
			parent.checkCodeDulicate('ok');
		}
	}else alert("error");
})();
</Script>
<%-- </head>

<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="count" value="<%=value.result[0]%>">
</form>
</body>
</html> --%>
