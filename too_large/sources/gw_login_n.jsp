<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="sepoa.fw.util.TripleDes01" %>
<%@ page import="javax.servlet.RequestDispatcher"%>
<%

 		SepoaSession.invalidate(request);
 		/*house_code */
        String house_code = JSPUtil.nullToEmpty(request.getParameter("house_code"));
        //System.out.println("HouseCode : " + house_code);
        String url = "";
        Config conf = new Configuration("000");
        if(house_code == null || "".equals(house_code)){
                try {
                        house_code = conf.get(request.getServerName()+".house_code");
                } catch (Exception ex) {
                        house_code = "000";
                }
        }
        

        SepoaSession.putValue(request, "HOUSE_CODE", house_code);
        SepoaSession.putValue(request, "ID", "LOGIN");
        SepoaSession.putValue(request, "LANGUAGE", "KO");
        SepoaSession.putValue(request, "NAME_LOC", house_code);
        SepoaSession.putValue(request, "NAME_ENG", house_code);


	//param1앞 8자리 복호화
	//String param1 = "13283760d65ed9f928faf8ab81a2bf3f";//JSPUtil.paramCheck(request.getParameter("param1"));
	
	// 새로운 그룹웨어
	String param1 = "12345678"+JSPUtil.paramCheck(request.getHeader("USER_ID") ) + "20151214121212";	//==> To-BE 처리방법
	param1 = CryptoUtil.encryptText(param1);
	// 새로운 그룹웨어

	//String param1 = JSPUtil.paramCheck(request.getParameter("param1"));		// ID
	//String param2 = JSPUtil.paramCheck(request.getParameter("param2"));		// FromSite
	String FromSite = JSPUtil.paramCheck(request.getParameter("FromSite"));		// FromSite


    String requstUrl = request.getRequestURL().toString();
    StringTokenizer st = new StringTokenizer(requstUrl, "://");

    String protocol = "http";

    if(st.hasMoreTokens())
    {
        protocol = st.nextToken();
    }

	String aaserver_name = protocol+"://" + request.getServerName();
	String aaserver_port = String.valueOf(request.getServerPort());

	if(!aaserver_port.equals("80"))
	{
		aaserver_name += ":" + aaserver_port;
	}


	aaserver_name += POASRM_CONTEXT_NAME+"/servlets/sepoa.svl.co.co_login_process";
	String _id = Base64.base64Encode(param1);
	
	aaserver_name += "?mode=setDirectLogin";
	aaserver_name += "&param1="+_id;
	aaserver_name += "&FromSite="+FromSite;

	response.sendRedirect(aaserver_name);
%>
