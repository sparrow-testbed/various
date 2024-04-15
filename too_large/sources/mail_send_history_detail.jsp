<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	String screen_message = "";
	String mail_text = "";
	String mail_send_no = JSPUtil.nullToEmpty(request.getParameter("mail_send_no"));

	//Header 조회
	Object[] obj = {mail_send_no};
    SepoaOut value = ServiceConnector.doService(info, "AD_051", "CONNECTION","getMailSendHistoryText", obj);

	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	for(int j = 0; j < wf.getRowCount(); j++)
	{
		mail_text += wf.getValue("mail_text", j);
	}
	
	out.println(mail_text);
%>