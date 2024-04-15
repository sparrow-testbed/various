<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_120");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String user_id = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept = info.getSession("DEPARTMENT");
	String house_code = info.getSession("HOUSE_CODE");
	String language    = info.getSession("LANGUAGE");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<Script language="javascript">

<%
	String i_company_code = request.getParameter("i_company_code");
	String i_plant_code = request.getParameter("i_plant_code");
	String i_pr_location = request.getParameter("i_pr_location");

	String[] data = {i_company_code,i_plant_code,i_pr_location};
	Object[] obj = {(Object[])data};
	String nickName = "AD_118";
	String conType = "CONNECTION";
	String MethodName = "getDisplay";

	SepoaOut value = null;
	SepoaRemote ws = null;

	SepoaFormater wf = null ;

	try {
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName, obj);

		if(value.status == 1) {
			wf = new SepoaFormater(value.result[0]);
		}
	}catch(Exception e) {
		Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	}finally{
		try{
			ws.Release();
		}catch(Exception e){}
	}
%>

function checkDulicate(flag, status)
{
	if( status == 'X')  {
		plantSave();

	}else {
		//alert("중복된 데이타입니다");
		alert("<%=text.get("AD_120.MSG_0100")%>");
		document.form.pr_location.focus();
		return false;
	}
}

<%--//처구지역이 PK가 되었다.--%>
<%--//따라서 수정시 중복체크 로직이 붙었다.--%>
<%--//pr_location이 안바뀌면 중복체크 로직 안태운다.--%>
<%--//수정시 공장단위,청구지역은 이미 있어야 되는 것이 정상이다.--%>
function doUpdate()
{
	var FormName = document.forms[0];
	pr_location     = FormName.pr_location.value;
	old_pr_location = FormName.old_pr_location.value;


//	alert("pr_location: " + pr_location);
//	alert("old_pr_location: " + old_pr_location);
	<%--//pr_location이 안바뀌면 중복체크 로직 안태운다.--%>
//	if (pr_location == old_pr_location)
//	{
//		plantSave();
//		return;
//	}

	FormName.plant_code.value = FormName.plant_code.value.toUpperCase();

	var checkCode       = FormName.plant_code.value;
	var country         = FormName.country.value;
	var plant_name_loc  = FormName.plant_name_loc.value;
	var address_loc     = FormName.address_loc.value;
	var irs_no          = FormName.irs_no.value;
	var pr_location     = FormName.pr_location.value;
	var plant_code      = FormName.plant_code.value;
	var company_code    = FormName.company_code.value;
	var ceo_name_loc    = FormName.ceo_name_loc.value ;
	var industry_type   = FormName.industry_type.value ;
	var business_type   = FormName.business_type.value ;
	var biz_name_loc    = FormName.biz_name_loc.value ;
	var language		= "<%=language%>";

	if(chkKorea(checkCode) > 10)
	{
		//alert("공장단위 코드는 10자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0101")%>");
		FormName.plant_code.focus();
		FormName.plant_code.select();
		return false;
	}

	if(isEmpty(checkCode)){
		//alert("공장단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0102")%>");
		FormName.plant_code.focus();
		return false;
	}

	if(chkKorea(country) > 5)
	{
		//alert("국가 코드는 5자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0103")%>");
		FormName.country.focus();
		FormName.country.select();
		return false;
	}

	if(isEmpty(country)){
		//alert("국가 코드를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0104")%>");
		FormName.country.focus();
		return false;
	}
	if(isEmpty(plant_name_loc)){
		//alert("공장단위 명(한글)를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0105")%>");
		FormName.plant_name_loc.focus();
		return false;
	}
	if(isEmpty(address_loc)){
		//alert("주소(한글)를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0106")%>");
		FormName.address_loc.focus();
		return false;
	}

	if(isEmpty(ceo_name_loc)){
		//alert("대표자명을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0107")%>");
		FormName.ceo_name_loc.focus();
		return false;
	}
<%--
	if(isEmpty(industry_type)){
		//alert("업태를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0108")%>");
		FormName.industry_type.focus();
		return false;
	}
	if(isEmpty(business_type)){
		//alert("업종을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0109")%>");
		FormName.business_type.focus();
		return false;
	}
--%>
	if(chkKorea(document.form.dept.value) > 10) {
		//alert("부서코드는 10자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0110")%>");
		FormName.dept.focus();
		FormName.dept.select();
		return false;
		}
/*
	if(isEmpty(document.form.dept.value)){
		//alert("부서코드를 넣어주세요.");
		alert("<%//=text.get("AD_120.MSG_0111")%>");
		FormName.dept.focus();
		return false;
	}
*/
	if(isEmpty(irs_no)){
		//alert("사업자등록번호를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0112")%>");
		FormName.irs_no.focus();
		return false;
	}

	if(FormName.country.value == "KR") {
		if(FormName.irs_no.value.length == 10) {
		} else {
			//alert("사업자등록번호를 10자리로 입력하세요.");
			alert("<%=text.get("AD_120.MSG_0300")%>");
			FormName.irs_no.focus();
			return false;
		 }
	} else {
	}

 	if(!IsNumber1(irs_no)) {
	 	//alert("사업자등록번호에는 숫자만 입력하셔야 합니다.");
	 	alert("<%=text.get("AD_120.MSG_0301")%>");
	 	FormName.irs_no.focus();
		return;
	}


	if(isEmpty(pr_location)){
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0113")%>");
		FormName.pr_location.focus();
		return;
	}

	if(isEmpty(biz_name_loc)){
		//alert("사업장명(한글)을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0114")%>");
		FormName.biz_name_loc.focus();
		return false;
	}

	<%-- parent.work.location.href = "factory_unit_chk.jsp?company_code="+company_code+"&plant_code="+plant_code+"&pr_location="+pr_location; --%>
/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "factory_unit_save_up.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "factory_unit_save_up.jsp";
	jqa.submit();
}


function plantSave()
{
	if(!checkData()) return;

/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "factory_unit_save_up.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "factory_unit_save_up.jsp";
	jqa.submit();
}

function checkData()
{
	var checkCode       = document.form.plant_code.value;
	var country         = document.form.country.value;
	var plant_name_loc  = document.form.plant_name_loc.value;
	var irs_no          = document.form.irs_no.value;
	var pr_location     = document.form.pr_location.value;
	var address_loc     = document.form.address_loc.value;
	var ceo_name_loc    = document.form.ceo_name_loc.value ;
	var industry_type   = document.form.industry_type.value ;
	var business_type   = document.form.business_type.value ;
	var biz_name_loc   = document.form.biz_name_loc.value ;
	var language		= "<%=language%>";


	if(chkKorea(checkCode) > 10)
	{
		//alert("공장단위 코드는 10자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0115")%>");
		document.form.plant_code.focus();
		document.form.plant_code.select();
		return false;
	}

	if(isEmpty(checkCode)){
		//alert("공장단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0116")%>");
		document.form.plant_code.focus();
		return false;
	}

	if(chkKorea(country) > 5)
	{
		//alert("국가 코드는 5자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0117")%>");
		document.form.country.focus();
		document.form.country.select();
		return false;
	}

	if(isEmpty(country)){
		//alert("국가 코드를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0118")%>");
		document.form.country.focus();
		return false;
	}
	if(isEmpty(plant_name_loc)){
		//alert("공장단위 명(한글)를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0119")%>");
		document.form.plant_name_loc.focus();
		return false;
	}
	if(isEmpty(address_loc)){
		//alert("주소(한글)를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0120")%>");
		document.form.address_loc.focus();
		return false;
	}

	if(isEmpty(ceo_name_loc)){
		//alert("대표자명을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0121")%>");
		document.form.ceo_name_loc.focus();
		return false;
	}
<%--
	if(isEmpty(industry_type)){
		//alert("업태를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0122")%>");
		document.form.industry_type.focus();
		return false;
	}

	if(isEmpty(business_type)){
		//alert("업종을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0123")%>");
		document.form.business_type.focus();
		return false;
	}
--%>
	if(chkKorea(document.form.dept.value) > 10) {
		//alert("부서코드는 10자 이내입니다.");
		alert("<%=text.get("AD_120.MSG_0124")%>");
		document.form.dept.focus();
		document.form.dept.select();
		return false;
		}
/*
	if(isEmpty(document.form.dept.value)){
		//alert("부서코드를 넣어주세요.");
		alert("<%//=text.get("AD_120.MSG_0125")%>");
		document.form.dept.focus();
		return false;
	}
*/
	if(isEmpty(irs_no)){
		//alert("사업자등록번호를 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0126")%>");
		document.form.irs_no.focus();
		return false;
	}

	if((irs_no.length != 10) && (language == "KO")) {
		//alert("사업자등록번호를 14자리로 입력하세요.");
		alert("<%=text.get("AD_120.MSG_0300")%>");
		document.form.irs_no.focus();
		return false;
	}

 	if(!IsNumber1(irs_no)) {
	 	//alert("사업자등록번호에는 숫자만 입력하셔야 합니다.");
	 	alert("<%=text.get("AD_120.MSG_0301")%>");
	 	document.form.irs_no.focus();
		return;
	}


	if(isEmpty(pr_location)){
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0127")%>");
		document.form.pr_location.focus();
		return;
	}

	if(isEmpty(biz_name_loc)){
		//alert("사업장명(한글)을 넣어주세요.");
		alert("<%=text.get("AD_120.MSG_0128")%>");
		document.form.biz_name_loc.focus();
		return false;
	}

	return true;
}

function doList()
{
	parent.body.location.href="factory_unit.jsp";
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


function getlogistics(a,b)
{
	document.form.logistics_area.value = a;
	document.form.text_logistics_area.value = b;
}

function getDept(code, text) {
	document.forms[0].dept.value = code;
	document.forms[0].text_dept.value = text;
}


function popup(code)
{
	<%--//물류--%>
	if (code == "logistics_area")  var url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getlogistics&values=M088&values=&values=";
	<%--//부서--%>
	if(code == "dept") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0022&function=getDept&values="+document.forms[0].company_code.value+"&values=&values=";

	Code_Search(url,'','','','','');
}

function file_attach(attach_no)
{
	attach_type = "";
    attach_file(attach_no,"IMAGE");
}

function setAttach(attach_key, arrAttrach, attach_count)
{
	document.forms[0].attach_no.value = attach_key;
	document.forms[0].attach_count.value = attach_count;
}

</script>
</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0">
<s:header>
<form name="form">
<input type="hidden" name="old_pr_location" id="old_pr_location" value="<%=wf.getValue("PR_LOCATION", 0) %>" >
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
						<TD><script language="javascript">btn("javascript:doUpdate()" , "<%=text.get("BUTTON.update")%>")</script></TD>
					</TR>
			    </TABLE>
			</td>
		</tr>
	  </table>    	  				
	  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="DBDBDB">
        <tr>
			<td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0100")%> </td>
			<td class="div_data" width="80%" colspan="3">
				<input type="text" name="company_code" id="company_code" value="<%=i_company_code%>" size="20" class="input_data0" readOnly>
				 </td>
		</tr>
		<tr>
		<td class="div_input_re" width="20%" align="center"> <%=text.get("AD_120.TEXT_0101")%> </td>
		  <td class="div_data" width="80%" colspan="3">
			<input type="text" name="plant_code" id="plant_code" value="<%=wf.getValue("PLANT_CODE", 0) %>" size="20" class="input_re" readOnly>
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_120.TEXT_0102")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="plant_name_loc" id="plant_name_loc" value="<%=wf.getValue("PLANT_NAME_LOC", 0) %>" size="50" maxlength="50" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0103")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="plant_name_eng" id="plant_name_eng" value="<%=wf.getValue("PLANT_NAME_ENG", 0) %>" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_120.TEXT_0104")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="address_loc" id="address_loc" value="<%=wf.getValue("ADDRESS_LOC", 0) %>" size="90" maxlength="200" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0105")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="address_eng" id="address_eng" value="<%=wf.getValue("ADDRESS_ENG", 0) %>" size="90" maxlength="200" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_120.TEXT_0106")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="phone_no" id="phone_no" value="<%=wf.getValue("PHONE_NO", 0) %>" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0107")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="fax_no" id="fax_no" value="<%=wf.getValue("FAX_NO", 0) %>" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_120.TEXT_0108")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="ceo_name_loc" id="ceo_name_loc" value="<%=wf.getValue("CEO_NAME_LOC", 0) %>" size="20" maxlength="20" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_120.TEXT_0109")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="business_type" id="business_type" value="<%=wf.getValue("BUSINESS_TYPE", 0) %>" size="30" maxlength="30" class="input_re">
			&nbsp;/&nbsp;
			<input type="text" name="industry_type" id="industry_type" value="<%=wf.getValue("INDUSTRY_TYPE", 0) %>" size="30" maxlength="30" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_120.TEXT_0110")%> </td>
		  <td class="div_data" colspan="3">
			 <select name="country" id="country" class="input_re">
			 <option value=""></option>
			 <%
			 String country = ListBox(request, "SL0018" ,"#M001#", wf.getValue("COUNTRY", 0));
			 out.println(country);
			 %>
			 </select>
		  </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_120.TEXT_0111")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="dept" id="dept" value="<%=wf.getValue("DEPT", 0) %>" size="10" maxlength="10" class="input_re" readonly >
			<a href="javascript:popup('dept')"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
			<input type="text" name="text_dept" id="text_dept" value="<%=wf.getValue("DEPT_NAME", 0) %>" size="20" class="input_empty" readOnly>
		  </td>
		</tr>
			<input type="hidden" name="logistics_area" id="logistics_area" value="<%=wf.getValue("LOGISTICS_AREA", 0) %>" size="15" maxlength="10" class="inputsubmit" readOnly>

		 <tr>
		 	<td width="20%" class="div_input_re">
				<div align="center"> <%=text.get("AD_120.TEXT_0112")%> </div>
			  </td>
		  <td colspan="3" class="div_data">
			<select name="pr_location" id="pr_location" class="input_re">
			 <%
			 String pr_location_data = ListBox(request, "SL0018" , "#M062#", wf.getValue("PR_LOCATION", 0));
			 out.println(pr_location_data);
			 %>
			</select>
		   </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_120.TEXT_0113")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="zip_code" id="zip_code" value="<%=wf.getValue("ZIP_CODE", 0) %>" size="10" maxlength="10" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_120.TEXT_0114")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="irs_no" id="irs_no" value="<%=wf.getValue("IRS_NO", 0) %>" size="20" maxlength="10" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_120.TEXT_0115")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="biz_name_loc" id="biz_name_loc" value="<%=wf.getValue("BIZ_NAME_LOC", 0) %>" size="50" maxlength="50" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0116")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="biz_name_eng" id="biz_name_eng" value="<%=wf.getValue("BIZ_NAME_ENG", 0) %>" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_120.TEXT_0118")%> </td>
		  <td class="div_data" colspan="3">
			<table cellpadding="0">
			<tr>
				<td><script language="javascript">btn("javascript:file_attach('<%=wf.getValue("attach_no", 0) %>')", "<%=text.get("AD_120.button_file")%>")</script></td>
				<td>&nbsp;<input type="text" size="3" readOnly value="<%=wf.getValue("attach_count", 0) %>" class="input_empty" name="attach_count" id="attach_count"><%=text.get("AD_120.file_count")%>
					<br><%-- * 직인 도장의 Image Size 는 가로 60 픽셀, 세로 60 픽셀 크기의 파일을 첨부해야 합니다. --%>
					<font style="font-size:10px" color="blue"><%=text.get("AD_120.TEXT_0117")%></font>
					<input type="hidden" name="attach_no" id="attach_no" value="<%=wf.getValue("attach_no", 0) %>">
				</td>
			</tr>
			</table>
		  </td>
		</tr>
		<%-- <%@ include file="/include/include_bottom.jsp"%> --%>
	</table>
	</form>
	<!-- <iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> -->
	
</s:header>	
<s:footer/>
</body>
</html>


