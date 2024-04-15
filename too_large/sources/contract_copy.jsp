<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>


<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_001"); 
	multilang_id.addElement("MESSAGE");
    HashMap text 				= MessageUtil.getMessage(info,multilang_id);
   	 
   	String cont_form_no  		= JSPUtil.nullToEmpty(request.getParameter("cont_form_no"));
   	String contract_name 		= JSPUtil.nullToEmpty(request.getParameter("contract_name"));
   	String contract_type 		= JSPUtil.nullToEmpty(request.getParameter("contract_type"));
   	String remark				= JSPUtil.nullToEmpty(request.getParameter("remark"));
   	String cont_update_desc     = JSPUtil.nullToEmpty(request.getParameter("cont_update_desc"));
   	String content				= JSPUtil.nullToEmpty(request.getParameter("form_content"));
   	String use_flag				= JSPUtil.nullToEmpty(request.getParameter("use_flag"));
   	String input_flag			= JSPUtil.nullToEmpty(request.getParameter("input_flag"));
   	String cont_private_flag  	= JSPUtil.nullToEmpty(request.getParameter("cont_private_flag"));
   	String cont_status        	= JSPUtil.nullToEmpty(request.getParameter("cont_status"));
   	String confirm        	    = JSPUtil.nullToEmpty(request.getParameter("confirm"));
   	String user_name       	    = JSPUtil.nullToEmpty(request.getParameter("user_name"));
   
	Object[] obj1  = {cont_form_no, contract_name, contract_type, remark, content, use_flag, input_flag, cont_private_flag, cont_status, cont_update_desc, user_name};
	SepoaOut value = ServiceConnector.doService(info, "CT_001", "TRANSACTION","setContractCopy", obj1);   
	
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
	if("<%=value.status%>" == "1"){
		alert("성공적으로 처리 하였습니다.");
		parent.location.href = "contract_private_list.jsp";
	}
	else{
		alert("error");
	}
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>