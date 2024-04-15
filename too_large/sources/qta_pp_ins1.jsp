<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_246");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_246";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
    String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
    String settle_type  = JSPUtil.nullToEmpty(request.getParameter("settle_type"));
    String bid_req_type     = JSPUtil.nullToEmpty(request.getParameter("bid_req_type"));
    String req_type     = JSPUtil.nullToEmpty(request.getParameter("req_type"));
%>
<% String WISEHUB_PROCESS_ID="RQ_246";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<frameset rows="280,*" frameborder="YES" border="0" framespacing="0" cols="*"> 
  <frame name="topFrame" noresize src="qta_pp_ins1_1.jsp?rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>&settle_type=<%=settle_type%>&bid_req_type=<%=bid_req_type%>&req_type=<%=req_type%>"  scrolling="NO" >
  <frame name="mainFrame" src="" scrolling="NO" noresize>
</frameset>
<noframes> 

</html>