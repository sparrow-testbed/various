<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
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
    }
    
    String requstUrl = request.getRequestURL().toString();
    StringTokenizer st = new StringTokenizer(requstUrl, "://");

    String protocol = "http";

    if(st.hasMoreTokens())
    {
        protocol = st.nextToken();
    }

	String aaserver_name = protocol+"://" + request.getServerName();
	String aaserver_port = String.valueOf(request.getServerPort());

	if(! aaserver_port.equals("80"))
	{
		aaserver_name += ":" + aaserver_port;
	}
	
	if ("ICT".equals(info.getSession("FROM_SITE")) ){
		aaserver_name += "/index_ict.jsp";
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement("CO_004");
	HashMap text = MessageUtil.getMessage(info,multilang_id);

	aaserver_name += POASRM_CONTEXT_NAME;
	SepoaSession.invalidate(request);
	out.println("<script>");
    out.println("top.location.href=\"" + aaserver_name + "\";");
    out.println("</script>");
%>
