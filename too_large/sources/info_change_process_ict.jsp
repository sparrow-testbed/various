<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
	if(!sepoa.svc.common.constants.DEFAULT_ICT_JUMCD.equals(info.getSession("DEPARTMENT_ORG"))){
		out.println("<script>");
        out.println("alert('권한이 없습니다.');");
        out.println("self.close();");
        out.println("</script>");
        return;
	}


    String dept	      = JSPUtil.nullToRef(request.getParameter("dept"),"");
    String deptnm     = JSPUtil.nullToRef(request.getParameter("deptnm"),"");
    

//	SepoaSession.invalidate(request);
	
	
	SepoaSession.putValue(request, "DEPARTMENT", dept);
	SepoaSession.putValue(request, "DEPARTMENT_NAME_LOC", deptnm);
	SepoaSession.putValue(request, "DEPARTMENT_NAME_ENG", deptnm);

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
		aaserver_name += "/common/index_buyer_ict.jsp";
	}

//	Vector multilang_id = new Vector();
//	multilang_id.addElement("CO_004");
//	HashMap text = MessageUtil.getMessage(info,multilang_id);

//	aaserver_name += POASRM_CONTEXT_NAME;
//	SepoaSession.invalidate(request);
	out.println("<script>");
    out.println("top.location.href=\"" + aaserver_name + "\";");
    out.println("</script>");
%>
