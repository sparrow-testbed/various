<%@ page contentType = "text/html; charset=UTF-8" %>
<%-- <%@ include file="/include/sepoa_common.jsp"%> --%>
<%@ include file="/include/sepoa_session.jsp"%>
<%-- <%@ include file="/include/sepoa_scripts.jsp"%> --%>
<%@ page import="sepoa.fw.util.*"%>		<%-- SepoaDate,JSPUtil --%>
<%@ page import="java.util.*"%>			<%-- Vector,HashMap --%>
<%@ page import="sepoa.fw.srv.*"%>		<%-- SepoaOut --%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_102");
	multilang_id.addElement("MESSAGE");
    HashMap text 				= MessageUtil.getMessage(info,multilang_id);
	
	
	String add_user_id 			= JSPUtil.paramCheck(info.getSession("ID"));
	String house_code 			= JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	
%>
<%-- <html>
<head>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script> --%>
<%

	String[] args = {
		  JSPUtil.paramCheck(request.getParameter("COMPANY_CODE"))
		, JSPUtil.paramCheck(request.getParameter("LANGUAGE"))
		, JSPUtil.paramCheck(request.getParameter("COMPANY_NAME_LOC"))
		, JSPUtil.paramCheck(request.getParameter("COMPANY_NAME_ENG"))
		, JSPUtil.paramCheck(request.getParameter("CUR"))
		, JSPUtil.paramCheck(request.getParameter("COUNTRY"))
		, JSPUtil.paramCheck(request.getParameter("CITY_CODE"))
		, JSPUtil.paramCheck(request.getParameter("IRS_NO"))
		, JSPUtil.paramCheck(request.getParameter("DUNS_NO"))
		, JSPUtil.paramCheck(request.getParameter("FOUNDATION_DATE"))
		, JSPUtil.paramCheck(request.getParameter("GROUP_COMPANY_CODE"))
		, JSPUtil.paramCheck(request.getParameter("GROUP_COMPANY_NAME"))
		, JSPUtil.paramCheck(request.getParameter("CREDIT_RATING"))
		, JSPUtil.paramCheck(request.getParameter("INDUSTRY_TYPE"))
		, JSPUtil.paramCheck(request.getParameter("BUSINESS_TYPE"))
		, JSPUtil.paramCheck(request.getParameter("TRADING_REG_NO"))
		, JSPUtil.paramCheck(request.getParameter("TRADE_AGENCY_NO"))
		, JSPUtil.paramCheck(request.getParameter("TRADE_AGENCY_NAME"))
		, JSPUtil.paramCheck(request.getParameter("EDI_ID"))
		, JSPUtil.paramCheck(request.getParameter("EDI_QUALIFIER"))
		, add_user_id
		, "N"
		, current_date
		, current_time
		, JSPUtil.paramCheck(request.getParameter("ACCOUNT_CODE_SEPARATE"))
		, JSPUtil.paramCheck(request.getParameter("INS_COM_CODE"))
		, JSPUtil.paramCheck(request.getParameter("JIKIN_ATTACH_NO"))
	};
	
	String[] args2 = {
		  JSPUtil.paramCheck(request.getParameter("COMPANY_CODE"))
		, "1"
		, JSPUtil.paramCheck(request.getParameter("ADDRESS_LOC"))
		, JSPUtil.paramCheck(request.getParameter("ADDRESS_ENG"))
		, JSPUtil.paramCheck(request.getParameter("ZIP_CODE"))
		, JSPUtil.paramCheck(request.getParameter("PHONE_NO"))
		, JSPUtil.paramCheck(request.getParameter("HOMPAGE"))
		, JSPUtil.paramCheck(request.getParameter("CEO_NAME"))
	};
	Map<String, Object> data = new HashMap();
	data.put("COMPANY_CODE", JSPUtil.paramCheck(request.getParameter("COMPANY_CODE")));
	data.put("LANGUAGE", JSPUtil.paramCheck(request.getParameter("LANGUAGE")));
	data.put("COMPANY_NAME_LOC", JSPUtil.paramCheck(request.getParameter("COMPANY_NAME_LOC")));
	data.put("COMPANY_NAME_ENG", JSPUtil.paramCheck(request.getParameter("COMPANY_NAME_ENG")));
	data.put("CUR", JSPUtil.paramCheck(request.getParameter("CUR")));
	data.put("COUNTRY", JSPUtil.paramCheck(request.getParameter("COUNTRY")));
	data.put("CITY_CODE", JSPUtil.paramCheck(request.getParameter("CITY_CODE")));
	data.put("IRS_NO", JSPUtil.paramCheck(request.getParameter("IRS_NO")));
	data.put("DUNS_NO", JSPUtil.paramCheck(request.getParameter("DUNS_NO")));
	data.put("FOUNDATION_DATE", JSPUtil.paramCheck(request.getParameter("FOUNDATION_DATE")));
	data.put("GROUP_COMPANY_CODE", JSPUtil.paramCheck(request.getParameter("GROUP_COMPANY_CODE")));
	data.put("GROUP_COMPANY_NAME", JSPUtil.paramCheck(request.getParameter("GROUP_COMPANY_NAME")));
	data.put("CREDIT_RATING", JSPUtil.paramCheck(request.getParameter("CREDIT_RATING")));
	data.put("INDUSTRY_TYPE", JSPUtil.paramCheck(request.getParameter("INDUSTRY_TYPE")));
	data.put("INDUSTRY_TYPE", JSPUtil.paramCheck(request.getParameter("INDUSTRY_TYPE")));
	data.put("BUSINESS_TYPE", JSPUtil.paramCheck(request.getParameter("BUSINESS_TYPE")));
	data.put("TRADING_REG_NO", JSPUtil.paramCheck(request.getParameter("TRADING_REG_NO")));
	data.put("TRADE_AGENCY_NO", JSPUtil.paramCheck(request.getParameter("TRADE_AGENCY_NO")));
	data.put("TRADE_AGENCY_NAME", JSPUtil.paramCheck(request.getParameter("TRADE_AGENCY_NAME")));
	data.put("EDI_ID", JSPUtil.paramCheck(request.getParameter("EDI_ID")));
	data.put("EDI_QUALIFIER", JSPUtil.paramCheck(request.getParameter("EDI_QUALIFIER")));
	data.put("ACCOUNT_CODE_SEPARATE", JSPUtil.paramCheck(request.getParameter("ACCOUNT_CODE_SEPARATE")));
	data.put("INS_COM_CODE", JSPUtil.paramCheck(request.getParameter("INS_COM_CODE")));
	data.put("JIKIN_ATTACH_NO", JSPUtil.paramCheck(request.getParameter("JIKIN_ATTACH_NO")));
	data.put("ADDRESS_LOC", JSPUtil.paramCheck(request.getParameter("ADDRESS_LOC")));
	data.put("ADDRESS_ENG", JSPUtil.paramCheck(request.getParameter("ADDRESS_ENG")));
	data.put("ZIP_CODE", JSPUtil.paramCheck(request.getParameter("ZIP_CODE")));
	data.put("PHONE_NO", JSPUtil.paramCheck(request.getParameter("PHONE_NO")));
	data.put("HOMPAGE", JSPUtil.paramCheck(request.getParameter("HOMPAGE")));
	data.put("CEO_NAME", JSPUtil.paramCheck(request.getParameter("CEO_NAME")));


	String[][] str = new String[1][]; 
    str[0] = args; 
            
    String[][] str2 = new String[1][]; 
    str2[0] = args2; 
    Map<String, Object> data2 = new HashMap();
    data2.put("headerData", data);
    Object[] obj = {data2};
	//Object[] obj = {str, str2};
	SepoaOut value = ServiceConnector.doService(info, "AD_102", "TRANSACTION","setInsert", obj);
		
%>
<%-- [{
	"status":"<%=value.status%>"
}] --%>

<Script language="javascript">
(function Init()
{
	if("<%=value.status%>" == "1")
	{
		alert("<%=text.get("MESSAGE.0001")%>");
//		parent.location.href = "company_list.jsp";
		location.href = "company_list.jsp";
	}else alert("error");
})();
</Script>
<!-- </head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="Init();">
</body>
</html> -->