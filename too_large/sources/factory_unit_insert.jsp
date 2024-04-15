<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_119");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String user_id       = info.getSession("ID");
	String user_name_loc = info.getSession("NAME_LOC");
	String user_name_eng = info.getSession("NAME_ENG");
	String user_dept     = info.getSession("DEPARTMENT");
	String house_code    = info.getSession("HOUSE_CODE");
	String language    = info.getSession("LANGUAGE");
	String i_company_code = request.getParameter("i_company_code");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<Script language="javascript">

function doInsert()
{
	if(!checkData()) return;

/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "factory_unit_save_in.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "factory_unit_save_in.jsp";
	jqa.submit();
	
}

function checkData()
{
	var FormName 		= document.forms[0];
	var checkCode       = FormName.plant_code.value;
	var country         = FormName.country.value;
	var plant_name_loc  = FormName.plant_name_loc.value;
	var address_loc     = FormName.address_loc.value;
	var irs_no          = FormName.irs_no.value;
	var pr_location     = FormName.pr_location.value;
	var ceo_name_loc    = FormName.ceo_name_loc.value ;
	var industry_type   = FormName.industry_type.value ;
	var business_type   = FormName.business_type.value ;
	var biz_name_loc    = FormName.biz_name_loc.value ;
	var language		= "<%=language%>";

	if(chkKorea(checkCode) > 10)
	{
		//alert("공장단위 코드는 10자 이내입니다.");
		alert("<%=text.get("AD_119.MSG_0100")%>");
		FormName.plant_code.focus();
		FormName.plant_code.select();
		return false;
	}

	if(isEmpty(checkCode))
	{
		//alert("공장단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0101")%>");
		FormName.plant_code.focus();
		return false;
	}

	if(chkKorea(country) > 5)
	{
		//alert("국가 코드는 5자 이내입니다.");
		alert("<%=text.get("AD_119.MSG_0102")%>");
		FormName.country.focus();
		FormName.country.select();
		return false;
	}

	if(isEmpty(country))
	{
		//alert("국가 코드를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0103")%>");
		FormName.country.focus();
		return false;
	}

	if(isEmpty(plant_name_loc))
	{
		//alert("공장단위 명(한글)를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0104")%>");
		FormName.plant_name_loc.focus();
		return false;
	}
	if(isEmpty(address_loc))
	{
		//alert("주소(한글)를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0105")%>");
		FormName.address_loc.focus();
		return false;
	}

	if(isEmpty(ceo_name_loc))
	{
		//alert("대표자명을 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0106")%>");
		FormName.ceo_name_loc.focus();
		return false;
	}
<%--
	if(isEmpty(industry_type))
	{
		//alert("업태를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0107")%>");
		FormName.industry_type.focus();
		return false;
	}
	if(isEmpty(business_type))
	{
		//alert("업종을 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0108")%>");
		FormName.business_type.focus();
		return false;
	}
--%>

	<%--//  부서코드--%>
	if(chkKorea(document.form.dept.value) > 10)
	{
		//alert("부서코드는 10자 이내입니다.");
		alert("<%=text.get("AD_119.MSG_0109")%>");
		FormName.dept.focus();
		FormName.dept.select();
		return false;
	}
/*
	if(isEmpty(document.form.dept.value))
	{
		//alert("부서코드를 넣어주세요.");
		alert("<%//=text.get("AD_119.MSG_0110")%>");
		FormName.dept.focus();
		return false;
	}
*/
	if(isEmpty(irs_no))
	{
		//alert("사업자등록번호를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0111")%>");
		FormName.irs_no.focus();
		return false;
	}

	if(FormName.country.value == "KR") {
		if(FormName.irs_no.value.length == 10) {
		} else {
			//alert("사업자등록번호를 10자리로 입력하세요.");
			alert("<%=text.get("AD_119.MSG_0300")%>");
			FormName.irs_no.focus();
			return false;
		 }
	} else {
	}

 	if(!IsNumber1(irs_no)) {
	 	//alert("사업자등록번호에는 숫자만 입력하셔야 합니다.");
	 	alert("<%=text.get("AD_119.MSG_0301")%>");
	 	FormName.irs_no.focus();
		return;
	}

	if(isEmpty(pr_location))
	{
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0112")%>");
		FormName.pr_location.focus();
		return false;
	}

	if(isEmpty(biz_name_loc))
	{
		//alert("사업장명(한글)을 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0113")%>");
		FormName.biz_name_loc.focus();
		return false;
	}

	if(!check_Dulicate_flag())
		return;

	return true;
}

function doList()
{
/* 	parent.body.location.href="factory_unit.jsp"; */
	location.href="factory_unit.jsp";
}

function checkDulicate(flag, status)
{
	document.form.duplicate_flag.value = flag;
	document.form.dup_ins_flag.value = status;

	if(status == 'X')
	{
		//alert("사용가능한 코드입니다.");
		alert("<%=text.get("AD_119.MSG_0114")%>");
		return true;
	}
	else
	{
		//alert("중복된 데이타입니다");
		alert("<%=text.get("AD_119.MSG_0115")%>");
		document.form.plant_code.focus();
		return false;
	}
}

/*
*/
function check_Dulicate()
{
	var FormName = document.forms[0];
	FormName.plant_code.value = FormName.plant_code.value.toUpperCase();

	plant_code   = FormName.plant_code.value;
	company_code = FormName.company_code.value;
	pr_location  = FormName.pr_location.value;

	if(isEmpty(plant_code))
	{
		//alert("공장단위 코드를 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0116")%>");
		FormName.plant_code.focus();
		return;
	 }

	if(isEmpty(pr_location))
	{
		//alert("청구지역을 넣어주세요.");
		alert("<%=text.get("AD_119.MSG_0117")%>");
		FormName.pr_location.focus();
		return;
	}

/* 	parent.work.location.href = "factory_unit_chk.jsp?company_code="+company_code+"&plant_code="+plant_code+"&pr_location="+pr_location; */

	var jqa = new jQueryAjax();
	jqa.action = "factory_unit_chk.jsp";
	jqa.data = "company_code="+company_code+"&plant_code="+plant_code+"&pr_location="+pr_location;
	jqa.submit(false);	//form데이터 사용하지 않음

}

function check_Dulicate_flag()
{
	flag = document.form.duplicate_flag.value;
	if(flag == "ng")
	{
		//alert("입력하신 코드의 중복여부를 확인하세요.");
		alert("<%=text.get("AD_119.MSG_0118")%>");
		return false;
	}
	return true;
}

function isEmpty(a)
{
	if (Trim(a) == '') return true;
	return false;
}

function Trim(a)
{
	return(LTrim(RTrim(a)));
}

function LTrim(a)
{
	var i;
	i = 0;
	while (a.substring(i,i+1) == ' ')  i = i + 1;
	return a.substring(i);
}

function RTrim(a)
{
	var b;
	var i = a.length - 1;
	while (i >= 0 && a.substring(i,i+1) == ' ') i = i - 1;
	return a.substring(0,i+1);
}
	
function chkKorea(chkstr)
{
	var j, lng = 0;
	for (j=0; j<chkstr.length; j++)
	{
		if (chkstr.charCodeAt(j) > 255)
		{
			++lng;
		}
		++lng;
	}
	return lng;
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

function open_date(year,month,day,week) {
	document.forms[0].open_date.value=year+month+day;
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
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
<%@ include file="/include/include_top.jsp"%>
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
						<TD><script language="javascript">btn("javascript:doInsert()" , "<%=text.get("BUTTON.save")%>")</script></TD>
   						<TD><script language="javascript">btn("javascript:doList()" , "<%=text.get("BUTTON.confirm")%>")</script></TD>
					</TR>
			    </TABLE>
			</td>
		</tr>
	  </table>    	  				
	  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="DBDBDB">
        <tr>
			<td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0100")%> </td>
			<td class="div_data" width="80%">
				<input type="text" name="company_code" id="company_code" value="<%=i_company_code%>" size="20" class="input_data0" readOnly>
			</td>
		</tr>
		<tr>
			<td class="div_input_re" width="20%" align="center"> <%=text.get("AD_119.TEXT_0101")%> </td>
			<td class="div_data" width="80%">
			<table cellpadding="0">
				<tr>
					<td>
						<input type="text" name="plant_code" id="plant_code" size="20" maxlength="5" class="input_re">
					</td>
					<td>
						<script language="javascript" align="center">btn("javascript:check_Dulicate()","<%=text.get("BUTTON.dulicate")%>")</script>
					</td>
				</tr>
			</table>
			</td>
					<input type="hidden" name="duplicate_flag" id="duplicate_flag" value="ng">
					<input type="hidden" name="dup_ins_flag" id="dup_ins_flag" value="">
		</tr>
		<tr>
			<td class="div_input_re" width="20%" align="center"> <%=text.get("AD_119.TEXT_0102")%> </td>
			<td class="div_data" colspan="3">
				<input type="text" name="plant_name_loc" id="plant_name_loc" size="50" maxlength="50" class="input_re">
			</td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0103")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="plant_name_eng" id="plant_name_eng" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_119.TEXT_0104")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="address_loc" id="address_loc" size="90" maxlength="200" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0105")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="address_eng" id="address_eng" size="90" maxlength="200" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_119.TEXT_0106")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="phone_no" id="phone_no" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0107")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="fax_no" id="fax_no" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_119.TEXT_0108")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="ceo_name_loc" id="ceo_name_loc" size="20" maxlength="20" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0109")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="business_type" id="business_type" size="30" maxlength="30" class="input_re">
			&nbsp;/&nbsp;
			<input type="text" name="industry_type" id="industry_type" size="30" maxlength="30" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" align="center"> <%=text.get("AD_119.TEXT_0110")%> </td>
		  <td class="div_data" colspan="3">

			 <select name="country" id="country" class="input_re">
			 <option value=""></option>
			 <%
				 String country = ListBox(request, "SL0018" , "#M001#", "");
				 out.println(country);
			 %>
			 </select>
		  </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_119.TEXT_0111")%> </td>
		  <td class="div_data">
			<input type="text" name="dept" id="dept" value="" size="10" maxlength="10" class="input_re" readonly >
			<a href="javascript:popup('dept')"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
			<input type="text" name="text_dept" id="text_dept" value="" size="20" class="input_empty" readOnly>
		  </td>
		</tr>
		  <%--지역은 물류지역을 의미함 --%>
	    <input type="hidden" name="logistics_area" id="logistics_area" value="" size="15" maxlength="10" class="inputsubmit" readOnly>
		<tr>
		  <td width="20%" class="div_input_re">
			<div align="center"> <%=text.get("AD_119.TEXT_0112")%> </div>
		  </td>
		  <td colspan="3" class="div_data">
			<select name="pr_location" id="pr_location" class="input_re">
			 <%
			 String pr_location = ListBox(request, "SL0018" , "#M062#", "");
			 out.println(pr_location);
			 %>
			</select>
		   </td>
		</tr>
		<tr>
		  <td class="div_input" align="center"> <%=text.get("AD_119.TEXT_0113")%> </td>
		  <td class="div_data" width="35%">
			<input type="text" name="zip_code" id="zip_code" size="10" maxlength="10" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_119.TEXT_0114")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="irs_no" id="irs_no" size="20" maxlength="10" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input_re" width="20%" align="center"> <%=text.get("AD_119.TEXT_0115")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="biz_name_loc" id="biz_name_loc" size="50" maxlength="50" class="input_re">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0116")%> </td>
		  <td class="div_data" colspan="3">
			<input type="text" name="biz_name_eng" id="biz_name_eng" size="50" maxlength="50" class="inputsubmit">
		  </td>
		</tr>
		<tr>
		  <td class="div_input" width="20%" align="center"> <%=text.get("AD_119.TEXT_0118")%> </td>
		  <td class="div_data" colspan="3">
			<table cellpadding="0">
			<tr>
				<td><script language="javascript">btn("javascript:file_attach(document.forms[0].attach_no.value)", "<%=text.get("AD_119.button_file")%>")</script></td>
				<td>&nbsp;<input type="text" size="3" readOnly class="input_empty" name="attach_count" id="attach_count"><%=text.get("AD_119.file_count")%>
					<br><%-- * 직인 도장의 Image Size 는 가로 60 픽셀, 세로 60 픽셀 크기의 파일을 첨부해야 합니다. --%>
					<font style="font-size:10px" color="blue"><%=text.get("AD_119.TEXT_0117")%></font>
					<input type="hidden" name="attach_no" id="attach_no">
				</td>
			</tr>
			</table>
		  </td>
		</tr>
		<%-- <%@ include file="/include/include_bottom.jsp"%> --%>
	</table>
	</td>
	</tr>
	</table>
	</form>
	

<!-- 		<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> -->

</s:header>		
<s:footer/>
</body>
</html>
