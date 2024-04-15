<%--
 Title:        		업체생성, 수정 top  <p>
 Description:
 Copyright:    		Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author
 @version      	1.0.0
 @Comment
--%>

<% String WISEHUB_PROCESS_ID="p0010";%>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	String company_code = info.getSession("COMPANY_CODE");
	String house_code = info.getSession("HOUSE_CODE");

	String mode = "select";

	String IRS_NO                   = "";
	/*3일경우 프리랜서*/
	String SOLE_PROPRIETOR_FLAG = "";
	String resident_no = "";
	int iRowCount = 0;
	SepoaOut value =null;

	String[] data = {
		  house_code
		, company_code
	};
	Object[] obj = {(Object[])data, mode};
	value = ServiceConnector.doService(info, "p0010", "CONNECTION","getDis_icomvngl", obj);

	if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		iRowCount = wf.getRowCount();
		if(iRowCount > 0)
		{
			IRS_NO                  = wf.getValue("IRS_NO"                 	, 0);
			SOLE_PROPRIETOR_FLAG    = wf.getValue("SOLE_PROPRIETOR_FLAG"	, 0);
			resident_no  			= wf.getValue("RESIDENT_NO"             , 0);
		}
	}

	/*복호화*/
// 	EncDec enc = new EncDec();
// 	resident_no = enc.decrypt(resident_no);
	resident_no = resident_no;

%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script>
	function init(){
<%-- 		location.href = "ven_bd_con2.jsp?flag=update&vendor_code=<%=company_code%>&mode=<%="3".equals(SOLE_PROPRIETOR_FLAG) ? "resident_no" : "irs_no"%>&irs_no=<%=IRS_NO%>&popup=T&resident_no="+form1.resident_no.value --%>
		var tmp = "ven_bd_con2.jsp?flag=update&vendor_code=<%=company_code%>&mode=<%="3".equals(SOLE_PROPRIETOR_FLAG) ? "resident_no" : "irs_no"%>&irs_no=<%=IRS_NO%>&popup=T&resident_no="+form1.resident_no.value;
// 		alert("tmp : " + tmp);

		//alert($(window).height());
		var height = ($(window).height() - $('#head_area').height() - $('#header').height() - 40);
		$("#redirectFrame").attr("height", height);
		$("#redirectFrame").attr("src", tmp);
	}
</script>
</head>
<s:header>
<body bgcolor="#FFFFFF" text="#000000" onload="init()">
<form name="form1" >
<input type="hidden" name="resident_no" value="<%=resident_no %>">
</form>
</body>
</s:header>
<iframe id="redirectFrame" name="redirectFrame" src="" style="width: 100%; " scrolling="no"></iframe>
<s:footer/>
</html>
