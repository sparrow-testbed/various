<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_102");
	multilang_id.addElement("BUTTON");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String user_id 			= JSPUtil.paramCheck(info.getSession("ID"));
	String house_code 		= JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	String company_code 	= JSPUtil.paramCheck(request.getParameter("cmCode"));
%>
<html>
<head>


<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%

	String[] data = {company_code};
	Object[] obj = {data};
	SepoaOut value = ServiceConnector.doService(info, "AD_102", "CONNECTION","getDis", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	String LANGUAGE              = "" ;
	String LANGUAGE_NAME         = "" ;
	String COMPANY_NAME_LOC		 = "" ;
	String COMPANY_NAME_ENG      = "" ;
	String CUR                   = "" ;
	String COUNTRY               = "" ;
	String COUNTRY_NAME          = "" ;
	String CITY_CODE             = "" ;
	String CITY_CODE_NAME        = "" ;
	String ADDRESS_LOC           = "" ;
	String ADDRESS_ENG           = "" ;
	String ZIP_CODE              = "" ;
	String PHONE_NO              = "" ;
	String IRS_NO                = "" ;
	String DUNS_NO               = "" ;
	String HOMEPAGE              = "" ;
	String FOUNDATION_DATE       = "" ;
	String GROUP_COMPANY_CODE    = "" ;
	String GROUP_COMPANY_NAME    = "" ;
	String CREDIT_RATING         = "" ;
	String INDUSTRY_TYPE         = "" ;
	String INDUSTRY_TYPE_NAME    = "" ;
	String CEO_NAME              = "" ;
	String BUSINESS_TYPE         = "" ;
	String TRADE_REG_NO          = "" ;
	String ACCOUNT_CODE_SEPARATE = "" ;
	String TRADE_AGENCY_NO       = "" ;
	String TRADE_AGENCY_NAME     = "" ;
	String EDI_ID                = "" ;
	String EDI_QUALIFIER         = "" ;
	String INS_COM_CODE          = "" ;
	String INS_COM_CODE_NAME     = "" ;
	String JIKIN_ATTACH_NO     	 = "" ;
	String JIKIN_ATTACH_NO_COUNT = "0";
	
	if(wf.getRowCount() > 0) {
        for(int i=0;i<wf.getRowCount();i++){
            LANGUAGE              = wf.getValue("LANGUAGE"             , 0) ;
			LANGUAGE_NAME         = wf.getValue("LANGUAGE_NAME"        , 0) ;
			COMPANY_NAME_LOC      = wf.getValue("COMPANY_NAME_LOC"     , 0) ;
			COMPANY_NAME_ENG      = wf.getValue("COMPANY_NAME_ENG"     , 0) ;
			CUR                   = wf.getValue("CUR"                  , 0) ;
			COUNTRY               = wf.getValue("COUNTRY"              , 0) ;
			COUNTRY_NAME          = wf.getValue("COUNTRY_NAME"         , 0) ;
			CITY_CODE             = wf.getValue("CITY_CODE"            , 0) ;
			CITY_CODE_NAME        = wf.getValue("CITY_CODE_NAME"       , 0) ;
			ADDRESS_LOC           = wf.getValue("ADDRESS_LOC"          , 0) ;
			ADDRESS_ENG           = wf.getValue("ADDRESS_ENG"          , 0) ;
			ZIP_CODE              = wf.getValue("ZIP_CODE"             , 0) ;
			PHONE_NO              = wf.getValue("PHONE_NO"             , 0) ;
			IRS_NO                = wf.getValue("IRS_NO"               , 0) ;
			DUNS_NO               = wf.getValue("DUNS_NO"              , 0) ;
			HOMEPAGE              = wf.getValue("HOMEPAGE"             , 0) ;
			FOUNDATION_DATE       = wf.getValue("FOUNDATION_DATE"      , 0) ;
			GROUP_COMPANY_CODE    = wf.getValue("GROUP_COMPANY_CODE"   , 0) ;
			GROUP_COMPANY_NAME    = wf.getValue("GROUP_COMPANY_NAME"   , 0) ;
			CREDIT_RATING         = wf.getValue("CREDIT_RATING"        , 0) ;
			INDUSTRY_TYPE         = wf.getValue("INDUSTRY_TYPE"        , 0) ;
			INDUSTRY_TYPE_NAME    = wf.getValue("INDUSTRY_TYPE_NAME"   , 0) ;
			CEO_NAME              = wf.getValue("CEO_NAME"             , 0) ;
			BUSINESS_TYPE         = wf.getValue("BUSINESS_TYPE"        , 0) ;
			TRADE_REG_NO          = wf.getValue("TRADE_REG_NO"         , 0) ;
			ACCOUNT_CODE_SEPARATE = wf.getValue("ACCOUNT_CODE_SEPARATE", 0) ;
			TRADE_AGENCY_NO       = wf.getValue("TRADE_AGENCY_NO"      , 0) ;
			TRADE_AGENCY_NAME     = wf.getValue("TRADE_AGENCY_NAME"    , 0) ;
			EDI_ID                = wf.getValue("EDI_ID"               , 0) ;
			EDI_QUALIFIER         = wf.getValue("EDI_QUALIFIER"        , 0) ;
			INS_COM_CODE          = wf.getValue("INS_COM_CODE"         , 0) ;
			INS_COM_CODE_NAME     = wf.getValue("INS_COM_CODE_NAME"    , 0) ;
			JIKIN_ATTACH_NO       = wf.getValue("JIKIN_ATTACH_NO"      , 0) ;
			JIKIN_ATTACH_NO_COUNT = wf.getValue("JIKIN_ATTACH_NO_COUNT", 0) ;
        }
    }

%>

<Script language="javascript">
function doList()
{
	location.href="company_list.jsp";
}
</script>

</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0">
<s:header>
<form name="form">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	  <td width="100%" valign="top">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="left">
				<TABLE cellpadding="0">
		      		<TR>
    	  				<TD><script language="javascript">btn("javascript:doList()" , "<%=text.get("BUTTON.confirm")%>")</script></TD>
    	  			</TR>
			    </TABLE>
			</td>
		</tr>
	  </table>    	  				
	  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="DBDBDB">
        <tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_CODE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=company_code%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.LANGUAGE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=LANGUAGE_NAME%></td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_LOC")%></td>
      		<td class="data_td" colspan="3">&nbsp;&nbsp;<%=COMPANY_NAME_LOC%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_ENG")%></td>
      		<td class="data_td" colspan="3">&nbsp;&nbsp;<%=COMPANY_NAME_ENG%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CUR")%></td>
      		<td class="data_td" colspan="3" >&nbsp;&nbsp;<%=CUR%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COUNTRY")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=COUNTRY_NAME%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CITY_CODE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=CITY_CODE%>/<%=CITY_CODE_NAME%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.ADDRESS_LOC")%></td>
      		<td class="data_td" colspan="3">&nbsp;&nbsp;<%=ADDRESS_LOC%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.ADDRESS_ENG")%></td>
      		<td class="data_td" colspan="3">&nbsp;&nbsp; <%=ADDRESS_ENG%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><%=text.get("AD_102.ZIP_CODE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=ZIP_CODE%></td>
      		<td class="title_td" width="20%"><%=text.get("AD_102.PHONE_NO")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=PHONE_NO%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.IRS_NO")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=IRS_NO%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.DUNS_NO")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=DUNS_NO%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.HOMPAGE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=HOMEPAGE%></td>
      		<td class="title_td" width="0"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.FOUNDATION_DATE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=FOUNDATION_DATE%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CREDIT_RATING")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=CREDIT_RATING%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.INDUSTRY_TYPE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=INDUSTRY_TYPE%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CEO_NAME")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=CEO_NAME%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.BUSINESS_TYPE")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=BUSINESS_TYPE%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADING_REG_NO")%></td>
      		<td class="data_td" colspan="3" >&nbsp;&nbsp;<%=TRADE_REG_NO%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADE_AGENCY_NO")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=TRADE_AGENCY_NO%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADE_AGENCY_NAME")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=TRADE_AGENCY_NAME%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
     	<tr>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.EDI_ID")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=EDI_ID%></td>
      		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.EDI_QUALIFIER")%></td>
      		<td class="data_td" width="30%">&nbsp;&nbsp;<%=EDI_QUALIFIER%></td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
    	<tr>
      		<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.JIKIN_ATTACH_NO")%><!-- 명판 첨부파일 --></td>
      		<td class="data_td" colspan="3">
	      		<table cellpadding="0">
				<tr>
					<td><script language="javascript">btn("javascript:FileAttach('IMAGE',document.forms[0].JIKIN_ATTACH_NO.value,'VI')", "<%=text.get("AD_102.button_file_view")%>")</script></td>
					<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="<%=JIKIN_ATTACH_NO_COUNT%>" name="JIKIN_ATTACH_NO_COUNT"><%=text.get("AD_102.file_count")%>
						<input type="hidden" value="<%=JIKIN_ATTACH_NO%>" name="JIKIN_ATTACH_NO">
					</td>
				</tr>
		  		</table>
      		</td>
    	</tr>
	<%-- 	<%@ include file="/include/include_bottom.jsp"%> --%>
		</table>
		</td>
                		</tr>
            		</table>
	</td>
	</tr>
	</table>
</form>
</s:header>
<s:footer/>
</body>
</html>
