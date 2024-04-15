<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp" %>
<%@ include file="/include/sepoa_scripts.jsp" %>


<%
	String mode 		= JSPUtil.nullToEmpty(request.getParameter("mode"));
	String szRow 		= JSPUtil.nullToEmpty(request.getParameter("szRow"));
	String rfq_no 		= JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count 	= JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String rfq_seq 		= JSPUtil.nullToEmpty(request.getParameter("rfq_seq"));
  	String shipper_type = JSPUtil.nullToEmpty(request.getParameter("shipper_type"));
  	String bid_flag 	= JSPUtil.nullToEmpty(request.getParameter("bid_flag"));
	String SG_REFITEM	= JSPUtil.nullToEmpty(request.getParameter("SG_REFITEM"));
	String type       	= JSPUtil.nullToEmpty(request.getParameter("type"));
	String company_code = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String MATERIAL_NUMBER = JSPUtil.nullToEmpty(request.getParameter("MATERIAL_NUMBER").replaceAll ( "&#64;" , "@" ));
	//2011.07.06 R110620056건에서 재견적시 업체가 조회되지 않아서 DESCRIPTION_LOC부분 주석처리함.
	//String DESCRIPTION_LOC = JSPUtil.nullToEmpty(request.getParameter("DESCRIPTION_LOC"));
	//String SOURCING_GROUP	= JSPUtil.nullToEmpty(request.getParameter("SOURCING_GROUP"));
	String data = "mode=" + mode + "&szRow=" + szRow;
	data += "&rfq_seq=" + rfq_seq + "&bid_flag=" + bid_flag;
	data += "&type="+type + "&material_number="+ MATERIAL_NUMBER;
	data += "&rfq_no=" + rfq_no + "&rfq_count=" + rfq_count;
	String top_data = "&MATERIAL_NUMBER="+MATERIAL_NUMBER+"&company_code="+company_code;
	//2011.07.06 R110620056건에서 재견적시 업체가 조회되지 않아서 DESCRIPTION_LOC부분 주석처리함.
	//top_data += "&DESCRIPTION_LOC="+DESCRIPTION_LOC;

%>

<html>
<head>

<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<frameset id=mainFrame rows="210,300,250" cols="*" frameborder="NO" border="0" framespacing="0">
  <frame name="topFrame" noresize src="rfq_req_sellersel_top.jsp?shipper_type=<%=shipper_type%><%=top_data%>" marginwidth="0" marginheight="0">
  <frameset cols="45%,*" frameborder="NO" border="0" framespacing="0" rows="*">
    <frame name="leftFrame"  src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_left.jsp?SG_REFITEM=<%=SG_REFITEM%>" marginwidth="0" marginheight="0" style="overflow:auto"  scroll="no"> 
    <frame name='mainFrame' src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_center.jsp?<%=data%>" noresize marginwidth=0 marginheight=0 >
  </frameset>
  <frame name="bottomFrame" src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_bottom.jsp?<%=data%>"	scrolling="no"  marginwidth="0" marginheight="0"/>
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
</body>
</noframes>
</html>
