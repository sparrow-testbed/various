<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp" %> --%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%-- <%@ include file="/include/code_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.ses.*"%>


<%
	/* sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);
 */
	if(info.getSession("ID") == null || info.getSession("ID").length() == 0)
	{
		//info = new SepoaInfo("100","ID=SEPOASOFT^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
		String user_os_lang = (String)(session.getAttribute("USER_OS_LANGUAGE")) == null ? "KO" : (String)(session.getAttribute("USER_OS_LANGUAGE"));
		info = new SepoaInfo("100","ID=SUPPLIER^@^LANGUAGE=" + user_os_lang + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_132");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code = info.getSession("HOUSE_CODE");
%>

<%-- <html>
<head>
<title></title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
 --%>
<%
	int o_cnt = 0;

	String[] args = {
		 JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("user_id")))
	};

	
	Map<String, Object> data = new HashMap();
	data.put("user_id", JSPUtil.paramCheck(request.getParameter("user_id")));
	Object[] obj = {data};
	
	SepoaOut value = ServiceConnector.doService(info, "AD_132", "CONNECTION","getDuplicate", obj);

	/* if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if(wf.getRowCount()>0)
		{
			o_cnt = Integer.parseInt(wf.getValue("CNT",0));
		}
	} */

%>
<%-- [{
	"status":"<%=value.status%>",
	"o_cnt":"<%=o_cnt%>"
}] --%>
<Script language="javascript">
(function Init()
{
   if("<%=value.status%>" == "1")
	{
		var o_cnt = "<%=o_cnt%>";
		if(o_cnt != 0)
		{
			//alert("입력하신 ID는 이미 존재합니다.");
			alert("<%=text.get("AD_132.MSG_0155")%>");
			checkDulicate('F');
		}
		else
		{
			//alert("등록 가능한 ID 입니다.");
			alert("<%=text.get("AD_132.MSG_0156")%>");
			checkDulicate('T');
		}
	}else
		//alert("조회가 실패하였습니다.");
		alert("<%=text.get("AD_132.MSG_0155")%>");
})();
</Script>
<%-- </head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="o_cnt" value="<%=o_cnt%>">
</form>
</body>
</html>
 --%> 