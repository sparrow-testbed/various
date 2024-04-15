<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<% String WISEHUB_PROCESS_ID="p0010"; %>

<%

	String user_id          		= info.getSession("id");
	String user_name_loc    		= info.getSession("name_loc");
	String user_name_eng    		= info.getSession("name_eng");
	String user_dept        		= info.getSession("department");
	String company_code     		= info.getSession("company_code");
	String house_code       		= info.getSession("house_code");
	
	String SIGN_FLAG    = JSPUtil.nullToEmpty(request.getParameter("sign_flag"      ));
	String APPROVAL     = JSPUtil.nullToEmpty(request.getParameter("approval"       ));	
	String CTRL_CODE    = JSPUtil.nullToEmpty(request.getParameter("ctrl_code"      ));
	String APPROVAL_TYPE= JSPUtil.nullToEmpty(request.getParameter("approval_type"  ));
	
	String TECH_RISE    = JSPUtil.nullToEmpty(request.getParameter("tech_rise"      ));
	String REG_REMARK   = JSPUtil.nullToEmpty(request.getParameter("reg_remark"     ));
	String VENDOR_CODE	= JSPUtil.nullToEmpty(request.getParameter("vendor_code"	));
	String CUSTOMER		= JSPUtil.nullToEmpty(request.getParameter("customer"	));
	
	String AKONT        = JSPUtil.nullToEmpty(request.getParameter("AKONT"));
	String ZTERM        = JSPUtil.nullToEmpty(request.getParameter("ZTERM"));
	String ZWELS        = JSPUtil.nullToEmpty(request.getParameter("ZWELS"));
	String HBKID        = JSPUtil.nullToEmpty(request.getParameter("HBKID"));
	
	String[][] temp_vngl = {{
						 REG_REMARK	 	
						,TECH_RISE
						,CUSTOMER	 	
						,user_id
						
						, AKONT
						, ZTERM
						, ZWELS
						, HBKID
						
						,house_code   	
						,VENDOR_CODE    
						}};
	
	
	SepoaOut value = null;
	if("PURCHASE_BLOCK".equals(APPROVAL_TYPE)){
		Object[] obj = {SIGN_FLAG, APPROVAL, VENDOR_CODE};
		value = ServiceConnector.doService(info, "p0070", "TRANSACTION","setBlockApproval", obj);	// 구매정지결재
	}else {
		Object[] obj = {temp_vngl, SIGN_FLAG, APPROVAL, VENDOR_CODE};
		value = ServiceConnector.doService(info, "p0010", "TRANSACTION","setVendorApproval", obj);	// 업체승인결재
	}
	
	
%>


<html>
<head>
<title>우리은행 전자구매시스템</title>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../../css/<%=info.getSession("HOUSE_CODE")%>/body_create.css" type="text/css">

<Script language="javascript">

function Init()
{
	parent.Saved("<%=value.message%>", "<%=value.status%>");
}

</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
