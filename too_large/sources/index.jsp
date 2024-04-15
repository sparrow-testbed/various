<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
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
        

        //url = "/index_login.jsp";
        url = "/index_main.jsp";
        SepoaSession.putValue(request, "HOUSE_CODE", house_code);
       
        //response.sendRedirect(url);
        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
%>