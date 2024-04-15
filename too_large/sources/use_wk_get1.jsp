<%--
È­¸é¸í	: Desc Á¶È¸	(/kr/master/user/use_wk_get1.jsp)
³»	¿ë	: ½Å±Ô»ç¿ëÀÚ, »ç¿ëÀÚÇöÈ² Á¶È¸½Ã	Desc Á¶È¸
ÀÛ¼ºÀÚ	: ½Åº´°ï
ÀÛ¼ºÀÏ	: 2006.01.21.
ºñ	°í	:
--%>

<%@ include file="/include/wisehub_common.jsp" %>
<jsp:include page="/include/admin_common.jsp" flush="true" />
<%@ include file="/include/wisehub_session.jsp" %>
<%
	String house_code = info.getSession("HOUSE_CODE");
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<jsp:include page="/include/wisehub_scripts.jsp" flush="true" />

<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<%
	String[] args = new String[2];

	args[0] = house_code;
	args[1] = JSPUtil.CheckInjection(request.getParameter("i_menu_profile_code"));

    String o_menu_object_code = "" ;

	Object[] obj = {args};
	String nickName= "p0030";
	String conType = "CONNECTION";
	String MethodName = "getMenuobject";
    wise.srv.WiseOut value = null;
    WiseRemote remote = null;

    try {
	 	remote = new WiseRemote(nickName, conType, info);
	 	value = remote.lookup(MethodName, obj);

		if(value.status == 1)
		{
			o_menu_object_code = value.result[0];
			//WiseFormater wf = new WiseFormater(value.result[0]);
			//if ( wf.getRowCount() > 0 )
			//{
			 //   o_menu_object_code = wf.getValue("MENU_OBJECT_CODE",0);
			//}
		}
    }catch(WiseServiceException wse) {
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

<Script language="javascript">
function Init()
{
   if("<%=value.status%>" == "1")
    {
    	var code = document.form.code.value;

	    parent.setobjectcode("<%=args[1]%>",code);

    }else alert("error");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<form name="form">
<input type="hidden" name="code" value="<%=o_menu_object_code%>">
</form>
</body>
</html>
