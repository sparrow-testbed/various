<%@ page contentType = "text/html; charset=UTF-8" %>
<% String WISEHUB_PROCESS_ID="p0030";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%-- <jsp:include page="/include/sepoa_common.jsp" flush="true" />
<jsp:include page="/include/sepoa_common.jsp" flush="true" /> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <jsp:include page="/include/sepoa_authority.jsp" flush="true" /> --%>

<%@ page import="sepoa.fw.srv.*"%>
<%@ page import="sepoa.fw.util.*"%>
<%@ page import="sepoa.fw.msg.*"%>
<%@ page import="sepoa.fw.log.*"%>

<%@ page import="sepoa.fw.util.*"%>  <%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>   <%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>  <%-- SepoaOut --%>
<%@ page import="sepoa.fw.log.*"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_133");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String i_user_id = JSPUtil.CheckInjection(request.getParameter("i_user_id"));
	String i_passwd  = JSPUtil.CheckInjection(request.getParameter("i_passwd"));
%>

<%-- <html>
<head>
<title></title>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>

<%
	String[] args = new String[2];
	args[0] = i_user_id;
	args[1] = i_passwd;
	Object[] obj = {args};

	String nickName= "AD_132";
	String conType = "CONNECTION";
	String MethodName = "getCheck";
	sepoa.fw.srv.SepoaOut value = null;
	SepoaRemote remote = null;
	
	String o_cnt = "" ;
	try {
		remote = new sepoa.fw.util.SepoaRemote(nickName, conType, info);
		value = remote.lookup(MethodName, obj);
		if(value.status == 1)
		{
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			o_cnt = wf.getValue("CNT",0);
		}
	} catch(SepoaServiceException wse) {
	} catch(Exception e) {
	} finally{
		try{
			remote.Release();
		}catch(Exception e){}
	}
%>
<%-- [{
	"status":"<%=value.status%>",
	"count":"<%=o_cnt%>",
	"i_user_id":"<%=i_user_id%>",
	"message":"<%=text.get("AD_134.MSG_0100")%>"
}] --%>

<Script language="javascript">
(function Init() {
   if("<%=value.status%>" == "1"){
	 var count = "<%=o_cnt%>";
	 if(count != 0)  {
		document.forms[0].user_id.value = '<%=i_user_id%>';
		document.forms[0].submit();
	  }else {
		//alert("아이디와 암호가 일치하지 않습니다.");
		alert("<%=text.get("AD_134.MSG_0100")%>");
		return;
	  }
   }else alert("error");
})();
</Script>
<%-- </head>

<body bgcolor="#FFFFFF" text="#000000" onload="Init()">
<form name="form">
<input type="hidden" name="count" value="<%=o_cnt%>">
</form>
</body>
</html>
 --%>