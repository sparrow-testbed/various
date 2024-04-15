<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_243");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_243";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String mode 		= JSPUtil.nullToEmpty(request.getParameter("mode"));
	String szRow 		= JSPUtil.nullToEmpty(request.getParameter("szRow"));

	String rfq_no 		= JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count 	= JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String rfq_seq 		= JSPUtil.nullToEmpty(request.getParameter("rfq_seq"));
  	String shipper_type = JSPUtil.nullToEmpty(request.getParameter("shipper_type"));
  	String bid_flag 	= JSPUtil.nullToEmpty(request.getParameter("bid_flag"));
	String SG_REFITEM	= JSPUtil.nullToEmpty(request.getParameter("SG_REFITEM"));


	String data = "mode=" + mode + "&szRow=" + szRow;
	data += "&rfq_no=" + rfq_no + "&rfq_count=" + rfq_count;
	data += "&rfq_seq=" + rfq_seq + "&bid_flag=" + bid_flag;
	
	String WISEHUB_PROCESS_ID="RQ_243";
	String G_IMG_ICON = "/images/ico_zoom.gif";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<frameset rows="210,*" cols="*" frameborder="NO" border="2" framespacing="2">
	<frame name="topFrame" noresize src="rfq_pp_ins2_t.jsp?shipper_type=<%=shipper_type%>" marginwidth="0" marginheight="0" >
	<frameset cols="50%,*" frameborder="NO" border="2" framespacing="2" rows="*">
		<frame name="leftFrame" noresize src="rfq_pp_ins2_l.jsp?SG_REFITEM=<%=SG_REFITEM%>" marginwidth="0" marginheight="0" scrolling="no" >
		<frame name='mainFrame' src=rfq_pp_ins2_r.jsp?<%=data%> noresize marginwidth="0" marginheight="0" style="width: 500px;" scrolling="no">
	</frameset>
</frameset>
<!-- <frameset id=mainFrame rows="210,300,250" cols="*" frameborder="NO" border="0" framespacing="0"> -->
<%--   <frame name="topFrame" noresize src="rfq_req_sellersel_top.jsp?shipper_type=<%=shipper_type%><%=top_data%>" marginwidth="0" marginheight="0"> --%>
<!--   <frameset cols="45%,*" frameborder="NO" border="0" framespacing="0" rows="*"> -->
<%--     <frame name="leftFrame"  src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_left.jsp?SG_REFITEM=<%=SG_REFITEM%>" marginwidth="0" marginheight="0" style="overflow:auto"  scroll="no">  --%>
<%--     <frame name='mainFrame' src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_center.jsp?<%=data%>" noresize marginwidth=0 marginheight=0 > --%>
<!--   </frameset> -->
<%--   <frame name="bottomFrame" noresize src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_bottom.jsp?<%=data%>"	scrolling="no"  marginwidth="0" marginheight="0"/> --%>
<!-- </frameset> -->
<noframes>
</noframes>
</html>