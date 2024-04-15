<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>
<%


	String user_id 			= JSPUtil.paramCheck(info.getSession("ID"));
	String house_code 		= JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	String company_code 	= JSPUtil.paramCheck(request.getParameter("cmCode"));
	String language    		= info.getSession("LANGUAGE");

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
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
// 	String JIKIN_ATTACH_NO     	 = "" ;
// 	String JIKIN_ATTACH_NO_COUNT = "0";

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
// 			JIKIN_ATTACH_NO       = wf.getValue("JIKIN_ATTACH_NO"      , 0) ;
// 			JIKIN_ATTACH_NO_COUNT = wf.getValue("JIKIN_ATTACH_NO_COUNT", 0) ;
        }
    }

%>

<Script language="javascript">

var G_HOUSE_CODE = "<%=house_code%>";
function doUpdate()
{
	if(!checkData()) return;

/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "company_updateok.jsp";
	document.form.submit(); 
	//location.href="company_updateok.jsp";*/
	
	var jqa = new jQueryAjax();
	jqa.action = "company_updateok.jsp";
	jqa.submit();
}

function checkData()
{
	var FormName = document.forms[0];
	var language		= "<%=language%>";
	var irs_no          = FormName.IRS_NO.value;

	if(isEmpty(FormName.COMPANY_NAME_LOC.value)){
		//alert("회사명(한글)을 입력하세요.");
		alert("<%=text.get("AD_102.MSG_0102")%>");
		document.form.COMPANY_NAME_LOC.focus();
		return false;
	}


	if(isEmpty(FormName.CUR.value)){
		alert("<%=text.get("AD_102.MSG_0103")%>");
		//alert("통화를 입력하세요.");
		document.form.CUR.focus();
		return false;
	}
	if(isEmpty(FormName.COUNTRY.value)){
		//alert("국가를 입력하세요.");
		alert("<%=text.get("AD_102.MSG_0104")%>");
		document.form.COUNRTRY.focus();
		return false;
	}
	if(isEmpty(FormName.CITY_CODE.value)){
		//alert("도시를 입력하세요.");
		alert("<%=text.get("AD_102.MSG_0105")%>");
		document.form.CITY_CODE.focus();
		return false;
	}
	if(isEmpty(FormName.ADDRESS_LOC.value)){
		//alert("주소(한글)를 입력하세요.");
		alert("<%=text.get("AD_102.MSG_0106")%>");
		document.form.ADDRESS_LOC.focus();
		return false;
	}
	if(isEmpty(FormName.PHONE_NO.value)){
		//alert("전화번호를 입력하세요.");
		alert("<%=text.get("AD_102.MSG_0107")%>");
		document.form.PHONE_NO.focus();
		return false;
	}

	if(FormName.COUNTRY.value == "KR") {
		if(FormName.IRS_NO.value.length == 10) {
		} else {
			//alert("사업자등록번호를 10자리로 입력하세요.");
			alert("<%=text.get("AD_102.MSG_0300")%>");
			FormName.IRS_NO.focus();
			return false;
		 }
	} else {
	}

 	if(!IsNumber1(irs_no)) {
	 	//alert("사업자등록번호에는 숫자만 입력하셔야 합니다.");
	 	alert("<%=text.get("AD_102.MSG_0301")%>");
	 	FormName.IRS_NO.focus();
		return;
	}

	return true;
}

function doList()
{
	parent.body.location.href="company_list.jsp";
}



function getCity(a,b)
{
	var FormName = document.forms[0];
	FormName.CITY_CODE.value = a;
	FormName.TEXT_CITY_CODE.value = b;
}

function GETGROUP_COMPANY_CODE(code, text) {
	var FormName = document.forms[0];
	FormName.GROUP_COMPANY_CODE.value = code;
	FormName.GROUP_COMPANY_NAME.value = text;

}

function getindustry_type(code,text1,text2,text3) {
	var FormName = document.forms[0];
	FormName.INDUSTRY_TYPE.value = code;
	FormName.TEXT_INDUSTRY_TYPE.value = text3;
}

function popup(code)
{
	var arrValue = new Array();
	var arrDesc  = new Array();
	var FormName = document.forms[0];
	if (code == "city_code") {
		var value = FormName.COUNTRY.value;
		if (isEmpty(value)) {
			//alert("먼저 국가코드를 입력하세요."+value);
			alert("<%=text.get("AD_102.MSG_0110")%>"+value);
			return;
		}

		PopupCommon2("SP0019","getCity",value,"","");
	}
	else if(code == "group_company_code")
	{
		PopupCommon0("SP0114","getgroup_company_code","","");
	}
	else if(code == "industry_type")
	{
		arrValue[arrValue.length] = G_HOUSE_CODE;
		arrDesc[arrDesc.length] = "대분류";
		arrDesc[arrDesc.length] = "중분류";
		PopupCommonArr("SP0114","getgroup_company_code",arrValue, arrDesc);
		//url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0113&function=getindustry_type&values=<=house_code%>&values=&values=/&desc=대분류&desc=중분류";
	}
}

function Trim(a)
{
	return(LTrim(RTrim(a)));
}

function h_check(a)
{
	var intErr
	var strValue = a;
	var retCode = 0
	var intErr = 0

	for (i = 0; i <  strValue.length; i++)
	{
		var retCode = strValue.charCodeAt(i)
		var retChar = strValue.substr(i,1).toUpperCase()
		retCode = parseInt(retCode)
		if ((retChar <  "0" || retChar  > "9") && (retChar <  "A" || retChar  > "Z") && ((retCode  > 255) || (retCode <  0) || (retCode == 32 ))) {
			intErr = -1;
			break;
		}
	}
	return (intErr);
}

/*
function goAttach(attach_no){
	attach_file(attach_no,"IMAGE");
}
 
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.form.JIKIN_ATTACH_NO.value = attach_key;
	document.form.JIKIN_ATTACH_NO_COUNT.value = attach_count;
}
*/


</Script>

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
						<TD><script language="javascript">btn("javascript:doUpdate()", "<%=text.get("BUTTON.update")%>")</script></TD>
						<%-- <TD><script language="javascript">btn("javascript:doList()", "<%=text.get("BUTTON.confirm")%>")</script></TD>--%>
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
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_CODE")%>
			</td>
	  		<td class="data_td" width="30%">
				<input type="text" name="COMPANY_CODE" id="COMPANY_CODE" value="<%=company_code%>" size="20" class="input_re" readOnly>
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.LANGUAGE")%></td>
	  		<td class="data_td" width="30%">
				<select name="LANGUAGE" id="LANGUAGE" class="inputsubmit">
		 			<option value=""></option>
		 			<%
		 				String lang = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M013#", LANGUAGE);
		 				out.println(lang);
		 			%>
		 		</select>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_LOC")%></td>
	  		<td class="data_td" colspan="3">
				<input type="text" name="COMPANY_NAME_LOC" id="COMPANY_NAME_LOC" value="<%=COMPANY_NAME_LOC%>" size="70" maxlength="50" class="input_re">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_ENG")%></td>
	  		<td class="data_td" colspan="3">
				<input type="text" name="COMPANY_NAME_ENG" id="COMPANY_NAME_ENG" value="<%=COMPANY_NAME_ENG%>" size="70" maxlength="50" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CUR")%></td>
	  		<td class="data_td" colspan="3" >
		 		<select name="CUR" id="CUR" class="input_re">
		 			<%
		 				String s_cur = ListBox(request, "SL0014" ,info.getSession("HOUSE_CODE")+"#M002#", CUR);
		 				out.println(s_cur);
		 			%>
		 		</select>
			</td>
				<input type="hidden" name="ACCOUNT_NO_SEPARATE" id="ACCOUNT_NO_SEPARATE" value="<%=ACCOUNT_CODE_SEPARATE%>">
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COUNTRY")%></td>
	  		<td class="data_td" width="30%">
		 		<select name="COUNTRY" id="COUNTRY" class="input_re">
		 			<option value=""></option>
		 			<%
		 				String s_country = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M001#", COUNTRY);
		 				out.println(s_country);
		 			%>
		 		</select>
			</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CITY_CODE")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="CITY_CODE" id="CITY_CODE" value="<%=CITY_CODE%>" size="15" maxlength="20" class="input_re" >
			<%--
					<a href="javascript:popup('city_code')"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
			--%>
				<input type="hidden" name="TEXT_CITY_CODE" id="TEXT_CITY_CODE" value="<%=CITY_CODE_NAME%>" size="15"  class="input_data2" readonly>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.ADDRESS_LOC")%></td>
	  		<td class="data_td" colspan="3">
				<input type="text" name="ADDRESS_LOC" id="ADDRESS_LOC" value="<%=ADDRESS_LOC%>" size="84" maxlength="200" class="input_re">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.ADDRESS_ENG")%></td>
	  		<td class="data_td" colspan="3">
				<input type="text" name="ADDRESS_ENG" id="ADDRESS_ENG" value="<%=ADDRESS_ENG%>" size="84" maxlength="200" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.ZIP_CODE")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="ZIP_CODE" id="ZIP_CODE" value="<%=ZIP_CODE%>" size="20" maxlength="10" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <%=text.get("AD_102.PHONE_NO")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="PHONE_NO" id="PHONE_NO" value="<%=PHONE_NO%>" size="20" maxlength="20" class="input_re">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.IRS_NO")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="IRS_NO" id="IRS_NO" value="<%=IRS_NO%>" size="20" maxlength="14" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.DUNS_NO")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="DUNS_NO" id="DUNS_NO" value="<%=DUNS_NO%>" size="20" maxlength="20" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.HOMPAGE")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="HOMPAGE" id="HOMPAGE" value="<%=HOMEPAGE%>" size="30" maxlength="50" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.FOUNDATION_DATE")%></td>
	  		<td class="data_td" width="30%">
      					                      <s:calendar id="FOUNDATION_DATE" default_value="<%=SepoaString.getDateSlashFormat(FOUNDATION_DATE)%>"  
	        						format="%Y/%m/%d"/>
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CREDIT_RATING")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="CREDIT_RATING" id="CREDIT_RATING" value="<%=CREDIT_RATING%>" size="20" maxlength="10" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.INDUSTRY_TYPE")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="INDUSTRY_TYPE" id="INDUSTRY_TYPE" value="<%=INDUSTRY_TYPE%>" size="20" maxlength="25" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.CEO_NAME")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="CEO_NAME" id="CEO_NAME" value="<%=CEO_NAME%>" size="40" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.BUSINESS_TYPE")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="BUSINESS_TYPE" id="BUSINESS_TYPE" value="<%=BUSINESS_TYPE%>" size="20" maxlength="25" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADING_REG_NO")%></td>
	  		<td class="data_td" colspan="3">
				<input type="text" name="TRADING_REG_NO" id="TRADING_REG_NO" value="<%=TRADE_REG_NO%>" size="20" maxlength="20" class="inputsubmit">
	  		</td>
	  			<input type="hidden" name="INS_COM_CODE" id="INS_COM_CODE" value="<%=INS_COM_CODE%>" >
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADE_AGENCY_NO")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="TRADE_AGENCY_NO" id="TRADE_AGENCY_NO" value="<%=TRADE_AGENCY_NO%>" size="20" maxlength="7" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.TRADE_AGENCY_NAME")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="TRADE_AGENCY_NAME" id="TRADE_AGENCY_NAME" value="<%=TRADE_AGENCY_NAME%>" size="20" maxlength="50" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.EDI_ID")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="EDI_ID" id="EDI_ID" value="<%=EDI_ID%>" size="20" maxlength="15" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="20%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.EDI_QUALIFIER")%></td>
	  		<td class="data_td" width="30%">
				<input type="text" name="EDI_QUALIFIER" id="EDI_QUALIFIER" value="<%=EDI_QUALIFIER%>" size="20" maxlength="15" class="inputsubmit">
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		
		<%-- 
		<tr>
      		<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.JIKIN_ATTACH_NO")%><!-- 명판 첨부파일 --></td>
      		<td class="data_td" colspan="3">
	      		<table cellpad 	ding="0">
				<tr>
					<td><script language="javascript">btn("javascript:goAttach(document.forms[0].JIKIN_ATTACH_NO.value)", "<%=text.get("AD_102.button_file")%>")</script></td>
					<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="<%=JIKIN_ATTACH_NO_COUNT%>" name="JIKIN_ATTACH_NO_COUNT" id="JIKIN_ATTACH_NO_COUNT"><%=text.get("AD_102.file_count")%>
						<br>* Image Size 는 가로 300 픽셀, 세로 111 픽셀 크기의 파일을 첨부해야 합니다.
						<font style="font-size:10px" color="blue"><%=text.get("AD_102.MSG_0113")%></font>
						<input type="hidden" value="<%=JIKIN_ATTACH_NO%>" name="JIKIN_ATTACH_NO" id="JIKIN_ATTACH_NO">
					</td>
				</tr>
		  		</table>
      		</td>
    	</tr>
    	--%>
    	
    <%-- 	<%@ include file="/include/include_bottom.jsp"%> --%>
		</table>
		</td>
                		</tr>
            		</table>
		</td>
	</tr>
</table>
</form>
<!-- <iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> -->
</s:header>
<s:footer/>
</body>
</html>
