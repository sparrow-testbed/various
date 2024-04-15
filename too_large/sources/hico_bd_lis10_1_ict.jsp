<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%
    String irs_no             = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
    String status             = JSPUtil.nullToEmpty(request.getParameter("status"));
    String sg_refitem         = JSPUtil.nullToEmpty(request.getParameter("sg_refitem"));
    String buyer_house_code   = JSPUtil.nullToEmpty(request.getParameter("buyer_house_code"));
    String popup   			  = JSPUtil.nullToEmpty(request.getParameter("popup"));

    String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
    if (vendor_code.equals("")) vendor_code = irs_no;

	//Logger.debug.println("YP",this, "YPP FLAG vendor_code=1=================>"+vendor_code);

	StringTokenizer parsingCode = new StringTokenizer(vendor_code,"::");
	vendor_code = parsingCode.nextToken();
	//Logger.debug.println("YP",this, "YPP FLAG vendor_code==2================>"+vendor_code);
%>
<html>
<head>

<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<frameset rows="130,*,1" frameborder="NO" border="0" framespacing="0" cols="*">
	<frame name="lis10_top" scrolling="NO" noresize src="hico_bd_lis10_1_top.jsp?flag=popup&irs_no=<%=irs_no%>&status=<%=status%>&sg_refitem=<%=sg_refitem%>&vendor_code=<%=vendor_code%>&buyer_house_code=<%=buyer_house_code%>&popup=<%=popup%>">
	<frame name="lis10_body"                        src="about:blank">
	<frame name="lis10_wk"                          src="about:blank">
</frameset>

<noframes>
<body bgcolor="#FFFFFF" text="#000000">
<s:header popup="true"></s:header>
</body>
</noframes>
</html>


