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
   String cont_update_desc      = JSPUtil.nullToEmpty(request.getParameter("cont_update_desc"));
   String content				= JSPUtil.nullToEmpty(request.getParameter("form_content"));
   String use_flag				= JSPUtil.nullToEmpty(request.getParameter("use_flag"));
   String input_flag			= JSPUtil.nullToEmpty(request.getParameter("input_flag"));
   String cont_private_flag  	= JSPUtil.nullToEmpty(request.getParameter("cont_private_flag"));
   String cont_status        	= JSPUtil.nullToEmpty(request.getParameter("cont_status"));
   String confirm        	    = JSPUtil.nullToEmpty(request.getParameter("confirm"));
   
   Logger.sys.println("cont_form_no       = " + cont_form_no);
   Logger.sys.println("contract_name      = " + contract_name);
   Logger.sys.println("contract_type      = " + contract_type);
   Logger.sys.println("remark             = " + remark);
   Logger.sys.println("cont_update_desc   = " + cont_update_desc);
   Logger.sys.println("content            = " + content);
   Logger.sys.println("use_flag           = " + use_flag);
   Logger.sys.println("input_flag         = " + input_flag);
   Logger.sys.println("cont_private_flag  = " + cont_private_flag);
//    System.out.println("cont_private_flag  = " + cont_private_flag);
   Logger.sys.println("cont_status        = " + cont_status);
   Logger.sys.println("confirm            = " + confirm);
   
   SepoaOut value = null;

   if( "Confirm".equals(confirm) ){
   		Logger.sys.println("확정");
   		Object[] obj  = {cont_form_no, contract_name, contract_type, remark, content, use_flag, input_flag, cont_private_flag, cont_status, cont_update_desc, confirm};
   		value = ServiceConnector.doService(info, "CT_001", "TRANSACTION","setConfirmSave", obj);   		
   }else{
   		Logger.sys.println("등록");
   		Object[] obj1 = {cont_form_no, contract_name, contract_type, remark, content, use_flag, input_flag, cont_private_flag, cont_status, cont_update_desc};
   		value = ServiceConnector.doService(info, "CT_001", "TRANSACTION","setContractSave", obj1);
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
		alert("<%=text.get("MESSAGE.0001")%>");
		if("<%=cont_private_flag%>" == "PU" ){ // 공통
			parent.location.href = "contract_form_list.jsp";
		}else{
			parent.location.href = "contract_private_list.jsp";
		}
	}else alert("error");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>