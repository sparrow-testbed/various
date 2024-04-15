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
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
		javax.servlet.ServletRequest pluginfreeRequest = new PluginFreeRequest(request);
		SepoaInfo info       = SepoaSession.getAllValue(request);
		String house_code    = info.getSession("house_code");
		//String user_id       = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_id")));
		String user_id       = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("user_id")));
		//String user_sms_no   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_sms_no")));
		String user_sms_no   = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("user_sms_no")));
		String user_gubun    = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("selectedUser")));	// 총무부,ICT지원센터 구분
		//String sms_check_no  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("sms_check_no2")));	// 전송받은 SMS 번호
		String sms_check_no  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(pluginfreeRequest.getParameter("sms_check_no2")));	// 전송받은 SMS 번호
	    
		// '-' 문자 제거
		user_id     = SepoaString.replace( user_id, "-", "" );
		user_sms_no = SepoaString.replace( user_sms_no, "-", "" );
        
		// 사용자 암호 만들기
		// 사용자의 편의를 위하여 혼돈을 주는 문자는 제거(i, o, 숫자 1, 0)
		String[] num = {"A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z","2","3","4","5","6","7","8","9"};
		String[] history = {"", "", "", "", "", "", "", ""};
		int count1 = history.length;
		boolean cont = true;
		String makepw = "";
		
		for(int i=0; i<count1 ; i++)
		{
			while(true)
			{
				cont = true;
				int randomNum=(int)(Math.random()*32);
				  
				history[i] = num[randomNum];
	    
				for(int j=0; j<i ; j++)
				{
					if(history[j].equals(history[i]))
					{
							cont = false;
							break;
					}
				}
				if (cont) break;
			}
			makepw = makepw + history[i];
		}
	    
	    
		// 사용자들이 눈으로 구분이 쉽게 가능한 14자리 사용
		String[] num1 = {"-","=","~","!","@","#","$","%","^","&","*","(",")","+"};
		
		makepw = makepw.substring(0,2) + num1[(int)(Math.random()*14)] + makepw.substring(2,5) + num1[(int)(Math.random()*14)] + makepw.substring(5,8);

	
	
		String CallBackNo = "";
		String msg = "";  
		
		Object[] obj = {user_id, user_sms_no, makepw, user_gubun, sms_check_no};
		SepoaOut value = ServiceConnector.doService(info, "p0030", "TRANSACTION", "setPwdReset", obj);
		try
		{
				if(value.status == 1){
					msg = "새로운 암호가 입력하신 SMS로 발송되었습니다.";
				}
				else{
					msg = value.message;
				}
		}
		catch(Exception e)
		{
// 				result = 0;
				msg = "새로운 암호 설정에 실패하였습니다.";
		}
		
%>

<Script language="javascript">
function Init()
{
	alert("<%=msg%>");
}
</Script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
</form>
</body>
</html>
