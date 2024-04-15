<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
%>
<%-- <html>
<head>
<title></title> --%>
<%
	String[] args = new String[2];
	//args[0] = house_code;
	args[0] = request.getParameter("company_code");
	args[1] = request.getParameter("plant_code");
//	args[2] = request.getParameter("pr_location");

	Object[] obj = {args};
	String nickName= "AD_118";
	String conType = "CONNECTION";
	String MethodName = "getDuplicate";
	sepoa.fw.srv.SepoaOut value = null;
	SepoaRemote remote = null;

	try {
		remote = new SepoaRemote(nickName, conType, info);
		value = remote.lookup(MethodName, obj);
	}catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"wse = " + wse.getMessage());
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	}catch(Exception e) {
		Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	}finally{
		try{
			remote.Release();
		}catch(Exception e){}
	}
%>
<%-- [{
	"status":"<%=value.status%>",
	"sflag":"<%=value.result[0]%>"
}] --%>
<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		var sflag = "<%=value.result[0]%>";
		if( sflag == 'X'){
			//parent.body.checkDulicate('ok', sflag);
			checkDulicate('ok', sflag);
		}else{
			//parent.body.checkDulicate('ng', sflag);
			checkDulicate('ng', sflag);
		}

	}else alert("error");
})();
</script>
<%-- </head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="sflag" value="<%=value.result[0]%>">
</form>
</body>
</html> --%>