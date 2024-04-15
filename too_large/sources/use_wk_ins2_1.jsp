<%--
	³»  ¿ë  : »ç¿ëÀÚID Áßº¹È®ÀÎ
--%>

<%@ include file="/include/wisehub_common.jsp" %>
<%@ include file="/include/wisehub_session.jsp" %>
<jsp:include page="/include/admin_common.jsp" flush="true" />
<%
	info = new WiseInfo("100",null);
	String house_code = info.getSession("HOUSE_CODE");
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/wisehub_scripts.jsp"%>
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<%
	int o_cnt = 0;

	String[] args = {
		  house_code
		, JspUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")))
	};

	Object[] obj = {args};
	
	WiseOut value = ServiceConnector.doService(info, "p0030", "CONNECTION","getDuplicate", obj);
    
	if(value.status == 1)
	{
		WiseFormater wf = new WiseFormater(value.result[0]);
		if(wf.getRowCount()>0)
		{
			o_cnt = Integer.parseInt(wf.getValue("CNT",0));
		}
	}
	
%>

<Script language="javascript">
function Init()
{
   if("<%=value.status%>" == "1")
	{
		var o_cnt = document.form.o_cnt.value;
		if(o_cnt != 0)
		{
			alert("ÀÔ·ÂÇÏ½Å ID´Â ÀÌ¹Ì Á¸ÀçÇÕ´Ï´Ù.");
			parent.checkDulicate('F');
		}
		else
		{
			alert("µî·Ï °¡´ÉÇÑ ID ÀÔ´Ï´Ù.");
			parent.checkDulicate('T');
		}
	}else alert("Á¶È¸°¡ ½ÇÆÐÇÏ¿´½À´Ï´Ù.");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="o_cnt" value="<%=o_cnt%>">
</form>
</body>
</html>
