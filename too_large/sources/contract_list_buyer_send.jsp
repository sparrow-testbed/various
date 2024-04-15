<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

 
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_012");
	multilang_id.addElement("MESSAGE");
    HashMap text		= MessageUtil.getMessage(info,multilang_id);

	String cont_no	    = JSPUtil.nullToEmpty(request.getParameter("cont_no"));
	String cont_gl_seq	= JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq"));
	String send		    = JSPUtil.nullToEmpty(request.getParameter("send"));
	String in_attach_no	= JSPUtil.nullToEmpty(request.getParameter("in_attach_no"));
	String seller_code_text	= JSPUtil.nullToEmpty(request.getParameter("seller_code_text"));//업체명
	
	
	SepoaOut value = null;
   	if(send.equals("Y")) {
   	   	Object[] obj = {cont_no, "CB", in_attach_no, cont_gl_seq};
		value = ServiceConnector.doService(info, "CT_021", "TRANSACTION","setContractBuyerSend", obj);
   	} else if(send.equals("N")) {
   	   	Object[] obj = {cont_no, "CE", in_attach_no, cont_gl_seq};
   		value = ServiceConnector.doService(info, "CT_021", "TRANSACTION","setContractBuyerSend", obj);
   	}
   	
   	
%> 
<html>
<head>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<Script language="javascript">

function Init()
{
	if("<%=value.status%>" == "1")
	{
		
		alert("<%=seller_code_text%>에게 성공적으로 전송되었습니다.");
		parent.location.href = "contract_list.jsp";
	}else alert("error");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>