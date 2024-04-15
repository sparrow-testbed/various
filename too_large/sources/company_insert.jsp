<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	String user_id       =  JSPUtil.paramCheck(info.getSession("ID"));
	String house_code    =  JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	String tCode 		 =  JSPUtil.paramCheck(request.getParameter("tCode"));
	String language    = info.getSession("LANGUAGE");

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


<Script language="javascript">

var G_HOUSE_CODE = "<%=house_code%>";

function doSave()
{
	var FormName = document.forms[0];

	if(!checkData()) return;

/* 	FormName.method = "POST";
	FormName.target = "childFrame";
	//FormName.action = "com_wk_ins1.jsp";
	FormName.action = "company_insertok.jsp";
	FormName.submit(); */
	
<%-- 	var jqa = new jQueryAjax();
	jqa.action = "company_insertok.jsp";
	jqa.dataType = "json";
	//jqa.data = "";
	jqa.successF = function(data){//
		$.each(data, function(index, obj){	//data는 배열이다. data index++번째 객체를 obj로 나타내준다.
			var status = obj.status;		
			if(status == "1")
			{
				alert("<%=text.get("MESSAGE.0001")%>");
				location.href = "company_list.jsp";
			}else alert("error");
			
		});
	}; 
	jqa.submit(); --%>

 	var jqa = new jQueryAjax();
	jqa.action = "company_insertok.jsp";
	jqa.submit();
	
}

function moveBody(url)
{
	/* parent.body.location.href="company_list.jsp"; */
	location.href="company_list.jsp";
}

function checkData()
{
	var FormName = document.forms[0];
	tCode = FormName.tCode.value;
	checkCode = FormName.COMPANY_CODE.value;
	var language		= "<%=language%>";
	var irs_no          = FormName.IRS_NO.value;


	if(chkKorea(checkCode) > 10)
	{
		alert("Company Code Length In 10.");
		FormName.COMPANY_CODE.focus();
		FormName.COMPANY_CODE.select();
		return false;
	}

	if(isEmpty(checkCode)){
		alert("<%=text.get("AD_102.MSG_0100")%>");
		FormName.COMPANY_CODE.focus();
		return false;
	 }

	if(!check_Dulicate_flag()) return;


	if(isEmpty(FormName.LANGUAGE.value)){
		alert("<%=text.get("AD_102.MSG_0101")%>");
		//alert("언어를 입력하세요.");
		FormName.LANGUAGE.focus();
		return false;
	 }
	if(isEmpty(FormName.COMPANY_NAME_LOC.value)){
		alert("<%=text.get("AD_102.MSG_0102")%>");
		//alert("회사명(한글)을 입력하세요.");
		FormName.COMPANY_NAME_LOC.focus();
		return false;
	 }


	if(isEmpty(FormName.CUR.value)){
		alert("<%=text.get("AD_102.MSG_0103")%>");
		//alert("통화를 입력하세요.");
		FormName.CUR.focus();
		return false;
	 }
	if(isEmpty(FormName.COUNTRY.value)){
		alert("<%=text.get("AD_102.MSG_0104")%>");
		//alert("국가를 입력하세요.");
		FormName.COUNTRY.focus();
		return false;
	 }
	if(isEmpty(FormName.CITY_CODE.value)){
		alert("<%=text.get("AD_102.MSG_0105")%>");
		//alert("도시를 입력하세요.");
		FormName.CITY_CODE.focus();
		return false;
	 }
	if(isEmpty(FormName.ADDRESS_LOC.value)){
		alert("<%=text.get("AD_102.MSG_0106")%>");
		//alert("주소(한글)를 입력하세요.");
		FormName.ADDRESS_LOC.focus();
		return false;
	 }
	if(isEmpty(FormName.PHONE_NO.value)){
		alert("<%=text.get("AD_102.MSG_0107")%>");
		//alert("전화번호를 입력하세요.");
		FormName.PHONE_NO.focus();
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


	var arr = tCode.split(":");
	var aLen = arr.length;
	for(idx in arr) {
		col = arr[idx].split(":");
		if(col[0] == checkCode)
		{
			alert("Code Exist, Please, Check Again.");
			FormName.COMPANY_CODE.select();
			FormName.COMPANY_CODE.focus();
			return false;
		}
	 }
	return true;
}

function check_Dulicate_flag()
{
	var FormName = document.forms[0];
	flag = FormName.duplicate_flag.value;
	if(flag == "ng")
	{
		//alert("입력하신 코드의 중복여부를 확인하세요.");
		alert("<%=text.get("AD_102.MSG_0108")%>");
		return false;
	}
	return true;
}


function checkDulicate(flag)
{
	
	var FormName = document.forms[0];
	FormName.duplicate_flag.value = flag;

	if(FormName.duplicate_flag.value == "ng")
	{
		FormName.COMPANY_CODE.select();
		return false;
	}
	if(FormName.duplicate_flag.value == "ok")
	{
		return true;
	}
}





function getLang(a,b,c)
{
	var FormName = document.forms[0];
	document.form.LANGUAGE.value = a;
}

function getCity(a,b)
{
	var FormName = document.forms[0];
	FormName.CITY_CODE.value = a;
	FormName.TEXT_CITY_CODE.value = b;
}

function getgroup_company_code(code, text) {
	var FormName = document.forms[0];
	FormName.GROUP_COMPANY_CODE.value = code;
	FormName.GROUP_COMPANY_NAME.value = text;
}

//Company 중복 확인
function check_Dulicate()
{
	var FormName = document.forms[0];
	FormName.COMPANY_CODE.value = FormName.COMPANY_CODE.value.toUpperCase();
	var COMPANY_CODE = FormName.COMPANY_CODE.value;
	if(isEmpty(COMPANY_CODE)){
		//alert("회사 코드를 넣어주세요.");
		alert("<%=text.get("AD_102.MSG_0109")%>");
		FormName.COMPANY_CODE.focus();
		return;
	} else{
/* 		parent.work.location.href = "company_chkcode.jsp?company_code="+COMPANY_CODE; */
		
<%-- 		var jqa = new jQueryAjax();
		jqa.action = "company_chkcode.jsp";
		jqa.dataType = "json";
		jqa.data = "company_code="+COMPANY_CODE;
		jqa.successF = function(data){//
			$.each(data, function(index, obj){	//data는 배열이다. data index++번째 객체를 obj로 나타내준다.
				var status = obj.status;
				var count = obj.count;
				if(status == "1")
				{
					if(status == "1")
					{
						if(count != 0)
						{
							alert("<%=text.get("AD_102.MSG_0111")%>");
							checkDulicate('ng');
						}
						else
						{
							alert("<%=text.get("AD_102.MSG_0112")%>");
							checkDulicate('ok');
						}
					}else alert("error");
				}else alert("error");
			});
		}; 
		jqa.submit(false);//form데이터는 사용하지 않는다.
	 --%>
	
		var jqa = new jQueryAjax();
		jqa.action = "company_chkcode.jsp";
		jqa.data = "company_code="+COMPANY_CODE;
		jqa.submit(false);//form데이터는 사용하지 않는다.
	}		

}


//업종코드
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

		PopupCommon1("SP0019","getCity",value,"","");
	}
	else if(code == "GROUP_COMPANY_CODE")
	{
		PopupCommon0("SP0114","getgroup_company_code","","");
	}
	else if(code == "industry_type")
	{
		arrValue[arrValue.length] = G_HOUSE_CODE;
		/*arrDesc[arrDesc.length] = "대분류";
		arrDesc[arrDesc.length] = "중분류";*/
		PopupCommonArr("SP0114","getgroup_company_code",arrValue, arrDesc);
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
		if ((retChar <  "0" || retChar  > "9") && (retChar <  "A" || retChar  > "Z") &&
		((retCode  > 255) || (retCode <  0) || (retCode == 32 )))
		{
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

function setAttach(attach_key, arrAttrach, attach_count) {
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
<input type="hidden" name="tCode" id="tCode" value="<%=tCode%>" size="20" class="inputsubmit">

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
						<TD><script language="javascript">btn("javascript:doSave()" , "<%=text.get("BUTTON.save")%>")</script></TD>
    	  				<TD><script language="javascript">btn("javascript:moveBody()" , "<%=text.get("BUTTON.confirm")%>")</script></TD>
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
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_CODE")%></td>
			<td class="data_td" width="30%">
				<table cellpadding="0">
					<tr>
					<td>
					<input type="text" name="COMPANY_CODE" id="COMPANY_CODE" value="" size="10" maxlength="10" >
					</td>
					<td>
					<script language="javascript">btn("javascript:check_Dulicate()","<%=text.get("BUTTON.dulicate")%>")    </script>
					</td>
					</tr>
				</table>
				<input type="hidden" name="duplicate_flag" id="duplicate_flag" value="ng">
			</td>
		    <td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.LANGUAGE")%></td>
		    <td class="data_td" width="30%">
                <select name="LANGUAGE" id="LANGUAGE">
		            <option value=""></option>
<%
		 String lang = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M013#", "");
		 out.println(lang);
%>
			    </select>
		    </td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_LOC")%></td>
			<td class="data_td" colspan="3">
				<input type="text" name="COMPANY_NAME_LOC" id="COMPANY_NAME_LOC" value="" size="70" maxlength="50" class="">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.COMPANY_NAME_ENG")%></td>
			<td class="data_td" colspan="3">
				<input type="text" name="COMPANY_NAME_ENG" id="COMPANY_NAME_ENG" value="" size="70" maxlength="50" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.CUR")%>
			</td>
			<td class="data_td" colspan="3">
				<select name="CUR" id="CUR" class="">
					<%
						 String cur = ListBox(request, "SL0014" ,info.getSession("HOUSE_CODE")+"#M002#", "");
						 out.println(cur);
					%>
				</select>
			</td>
			<input type="hidden" name="ACCOUNT_CIDE_SEPARATE" id="ACCOUNT_CIDE_SEPARATE" value="">
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.COUNTRY")%>
			</td>
			<td class="data_td" width="30%">
				<select name="COUNTRY" id="COUNTRY" class="">
					<option value=""></option>
<%
		 String country = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M001#", "");
		 out.println(country);
%>
				</select>
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.CITY_CODE")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="CITY_CODE" id="CITY_CODE" value="" size="15" maxlength="20" class="">  <%-- readOnly>--%>
				<input type="hidden" name="TEXT_CITY_CODE" id="TEXT_CITY_CODE" size="20" class="input_data2" readonly>  <%-- readOnly>--%>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.ADDRESS_LOC")%>
			</td>
			<td class="data_td" colspan="3">
				<input type="text" name="ADDRESS_LOC" id="ADDRESS_LOC" value="" size="84" maxlength="200" class="">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.ADDRESS_ENG")%>
			</td>
			<td class="data_td" colspan="3">
				<input type="text" name="ADDRESS_ENG" id="ADDRESS_ENG" value="" size="84" maxlength="200" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				 <%=text.get("AD_102.ZIP_CODE")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="ZIP_CODE" id="ZIP_CODE" value="" size="20" maxlength="10" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.PHONE_NO")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="PHONE_NO" id="PHONE_NO" value="" size="20" maxlength="20" class="">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.IRS_NO")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="IRS_NO" id="IRS_NO" value="" size="20" maxlength="10" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.DUNS_NO")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="DUNS_NO" id="DUNS_NO" value="" size="20" maxlength="20" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.HOMPAGE")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="HOMPAGE" id="HOMPAGE" value="" size="30" maxlength="50" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.FOUNDATION_DATE")%>
			</td>
			<td class="data_td" width="30%">
			                      <s:calendar id="FOUNDATION_DATE" default_value=""  
	        						format="%Y/%m/%d"/>

			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.CREDIT_RATING")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="CREDIT_RATING" id="CREDIT_RATING" value="" size="20" maxlength="10" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.INDUSTRY_TYPE")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="INDUSTRY_TYPE" id="INDUSTRY_TYPE" value="" size="10" maxlength="25" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.CEO_NAME")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="CEO_NAME" id="CEO_NAME" value="" size="20" maxlength="40" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.BUSINESS_TYPE")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="BUSINESS_TYPE" id="BUSINESS_TYPE" value="" size="20" maxlength="25" class="inputsubmit">

			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.TRADING_REG_NO")%>
			</td>
			<td class="data_td" colspan="3">
				<input type="text" name="TRADING_REG_NO" id="TRADING_REG_NO" value="" size="20" maxlength="20" class="">
			</td>
			<input type="hidden" name="ins_com_code" id="ins_com_code" value="">

		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.TRADE_AGENCY_NO")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="TRADE_AGENCY_NO" id="TRADE_AGENCY_NO" value="" size="20" maxlength="7" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.TRADE_AGENCY_NAME")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="TRADE_AGENCY_NAME" id="TRADE_AGENCY_NAME" value="" size="20" maxlength="50" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		<tr>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.EDI_ID")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="EDI_ID" id="EDI_ID" value="" size="20" maxlength="15" class="inputsubmit">
			</td>
			<td class="title_td" width="20%">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				<%=text.get("AD_102.EDI_QUALIFIER")%>
			</td>
			<td class="data_td" width="30%">
				<input type="text" name="EDI_QUALIFIER" id="EDI_QUALIFIER" value="" size="20" maxlength="15" class="inputsubmit">
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
		
		<%-- 
		<tr>
      		<td class="title_td">&nbsp;&nbsp;&nbsp;&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_102.JIKIN_ATTACH_NO")%><!-- 명판 첨부파일 --></td>
      		<td class="data_td" colspan="3">
	      		<table cellpadding="0">
				<tr>
					<td><script language="javascript">btn("javascript:goAttach(document.forms[0].JIKIN_ATTACH_NO.value)", "<%=text.get("AD_102.button_file")%>")</script></td>
					<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" value="0" name="JIKIN_ATTACH_NO_COUNT" id="JIKIN_ATTACH_NO_COUNT"><%=text.get("AD_102.file_count")%>
						<br>* Image Size 는 가로 300 픽셀, 세로 111 픽셀 크기의 파일을 첨부해야 합니다.
						<font style="font-size:10px" color="blue"><%=text.get("AD_102.MSG_0113")%></font>
						<input type="hidden" value="" name="JIKIN_ATTACH_NO" id="JIKIN_ATTACH_NO">
					</td>
				</tr>
		  		</table>
      		</td>
    	</tr>
    	--%>
    	
   <%--  	<%@ include file="/include/include_bottom.jsp"%> --%>
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
