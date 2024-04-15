<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<!-- logout_process.jsp의 상단부분만 발췌 -->
<%
	String id = info.getSession("ID");
	/* logout 처리 */
	Object[] obj = {info};
	SepoaOut wo = ServiceConnector.doService(info, "CO_004", "TRANSACTION","setLogoutProcess", obj);
	Logger.debug.println(id, request, "sepoaout.flag : " + wo.flag);
	Logger.debug.println(id, request, "sepoaout.message : " + wo.message);

    if(! wo.flag)
    {
       String error_message = SepoaString.replace(SepoaString.replace(wo.message, "\r", ""), "\n", "");
       out.println("<script>");
       out.println("alert(\"" + error_message + "\");");
       out.println("</script>");
    }else{
    	//세션 초기화
    	SepoaSession.invalidate(request);
%>

<script>
	var nickName = "CO_004";
	var conType = "CONNECTION";
	var methodName = "setLoginMap";
	// TODO:암호화/복호화 필요
	var SepoaOut = doServiceAjax( nickName, conType, methodName );
	if(SepoaOut.status == '2') {
		location.href = _POASRM_CONTEXT_NAME+"/common/main.jsp";
	} else {
		alert("사용자의 ID 혹은 비밀번호 입력이 잘못되었습니다.");
	}
</script>

<%} %>	