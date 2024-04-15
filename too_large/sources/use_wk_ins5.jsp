<%@page import="sepoa.fw.util.CommonUtil"%>

<%@page import="com.nprotect.pluginfree.modules.PluginFreeConfig"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.nprotect.pluginfree.PluginFree"%>
<%@page import="com.nprotect.pluginfree.PluginFreeDTO"%>
<%@page import="com.nprotect.pluginfree.PluginFreeException"%>
<%@page import="com.nprotect.pluginfree.PluginFreeWarning"%>
<%@page import="com.nprotect.pluginfree.PluginFreeDeviceDTO"%>
<%@page import="com.nprotect.pluginfree.modules.PluginFreeRequest"%>
<%@page import="com.nprotect.pluginfree.util.RequestUtil"%>
<%@page import="com.nprotect.pluginfree.util.StringUtil"%>
<%@page import="com.nprotect.pluginfree.transfer.InitechTransferImpl"%>
<%@page import="java.util.StringTokenizer"%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	request.setCharacterEncoding("utf-8");
    javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(request);
        
    SepoaInfo info       = SepoaSession.getAllValue(request);
	String house_code    = info.getSession("HOUSE_CODE");
	String user_sabun    = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_sabun"))).replaceAll("-", "");
	String user_name_loc = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_name_loc")));
	//String irs_no        = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("irs_no")));
	String irs_no        = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("irs_no")));
	//String vendor_sms_no = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("vendor_sms_no")));
	String vendor_sms_no = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("vendor_sms_no")));
	String opener_flag   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("opener_flag")));
	String user_gubun    = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("selectedUser")));	// 총무부,ICT지원센터 구분
	String JobFlag       = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("JobFlag")));		// 작업구분 : FindID(ID찾기), ReqCheckNo(인증번호전송)
	//String sms_check_no1 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("sms_check_no1")));	// ID찾기 SMS인증번호
	String sms_check_no1 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("sms_check_no1")));	// ID찾기 SMS인증번호
	//String sms_check_no2 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("sms_check_no2")));	// PW찾기 SMS인증번호
	String sms_check_no2 = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("sms_check_no2")));	// PW찾기 SMS인증번호
	//String user_id       = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")));		// PW찾기 user_id
	String user_id       = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("user_id")));		// PW찾기 user_id
	//String user_sms_no   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_sms_no")));	// PW찾기 user_sms_no
	String user_sms_no   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("user_sms_no")));	// PW찾기 user_sms_no
	
	
	String method_name   = "";
	String job_kind      = "";

	// SMS 인증번호 요청
	if ("ReqCheckNo_ID".equals(JobFlag) || "ReqCheckNo_PW".equals(JobFlag) )
	{
		method_name = "ReqCheckNo";
	}
	
	// ID 찾기
	if ("FindID".equals(JobFlag) )
	{
		method_name = "FindID1";
	}
	
	String strMsg = "";

	String[] args = {
					  house_code
					, user_sabun
					, user_name_loc
					, irs_no
					, vendor_sms_no
					, user_gubun
					, JobFlag
					, sms_check_no1
					, sms_check_no2
					, user_id
					, user_sms_no
					};

	Object[] obj = {args};
	SepoaOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION", method_name, obj);
	if(value.status == 1){
	
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			/* String user_id = "";
			String mobile = "";
			String email = "";
			String user_name = "";
			if(wf.getRowCount() > 0){
				user_id   = wf.getValue("USER_ID", 0);
				mobile    = wf.getValue("PHONE_NO2", 0);
				email     = wf.getValue("EMAIL", 0);
				user_name = wf.getValue("USER_NAME", 0);
			} */
			
			if(wf.getRowCount()>0){	
					strMsg = "등록된 SMS번호로 문자가 발송되었습니다.";
			}else{
					strMsg = value.message;
			}
	}else{
		strMsg = "사업자등록번호 혹은 SMS번호가 일치하지 않습니다.";
	}
	
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<Script language="javascript">
function Init(){
	alert("<%=strMsg%>");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html>
