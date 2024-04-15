<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_132");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String LB_USER_TYPE = ListBox(request, "SL0081", info.getSession("HOUSE_CODE")+"#"+info.getSession("HOUSE_CODE")+"#", company_code);
	boolean is_buyer = true;
/*
	if(info.getSession("IS_ADMIN_USER").equals("false"))
	{	%>
		<script>
			alert("<%=text.get("AD_132.0002")%>");
			history.go(-1);
		</script>
<%	} 
*/
	if(info.getSession("USER_TYPE").equals("S") || info.getSession("USER_TYPE").equals("P"))
	{
		is_buyer = false;
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>

<script language="javascript">
var G_HOUSE_CODE = "<%=house_code%>";
var DEFAULT_USER_TYPE = "CJ00";

function init()
{
	actionedit();
}

function checkEmpty(obj, message)
{
	if(isEmpty(obj.value))
	{
		alert(message);
		obj.focus();
		return false;
	}
	return true;
}

function checkKorea(obj, message, chknum)
{
	if(chkKorea(obj.value) > chknum)
	{
		alert(message);
		obj.focus();
		obj.select();
		return false;
	}
	return true;
}

function checkTel(obj, message)
{
	if(!IsTel(obj.value))
	{
		alert(message);
		obj.focus();
		obj.select();
		return false;
	}
	return true;
}

function checkData()
{
	var f = document.forms[0];

	f.user_id.value = f.user_id.value.toUpperCase();

	var checkCode = f.user_id.value;

	if(!checkEmpty(f.user_type, "<%=text.get("AD_132.MSG_0100")%>"))//"사용자구분을 입력해주십시요."
		return false;

	if(!checkEmpty(f.work_type, "<%=text.get("AD_132.MSG_0101")%>"))//"업무권한을 입력해주십시요."
		return false;

	if(!checkEmpty(f.user_id, "<%=text.get("AD_132.MSG_0102")%>"))//"사용자 ID를 입력하셔야 합니다."
		return false;
<%--
	if(!checkEmpty(f.password, "<%=text.get("AD_132.MSG_0103")%>"))//"비밀번호를 입력해주십시요."
		return false;
--%>
    if(isEmpty(document.form.password.value)){
	 	//alert("비밀번호를 입력해주십시요.");
	 	alert("<%=text.get("AD_132.MSG_0104")%>");
	 	document.form.password.focus();
	 	return false;
	}

	if(isEmpty(document.form.password2.value)){
	 	//alert("비밀번호확인을 입력해주십시요.");
	 	alert("<%=text.get("AD_132.MSG_0105")%>");
	 	document.form.password2.focus();
	 	return false;
	}

	if(!(document.form.password.value == document.form.password2.value) ) {
        //alert("비밀번호가 일치하지 않습니다.");
        alert("<%=text.get("AD_132.MSG_0106")%>");
        document.form.password.focus();
        document.form.password.select();
        return false;
    	}


    if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
        //alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.");
        alert("<%=text.get("AD_132.MSG_0107")%>");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkMixing(document.forms[0].password.value)) {
        //alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.");
        alert("<%=text.get("AD_132.MSG_0108")%>");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkIdIsEquals(document.forms[0].password.value)) {
        //alert("비밀번호는 ID가 포함되어 있으면 안됩니다.");
        alert("<%=text.get("AD_132.MSG_0109")%>");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkInputRepeat(document.forms[0].password.value)) {
        //alert("비밀번호는 같은 문자를 3번 이상 반복 입력할 수 없습니다.");
        alert("<%=text.get("AD_132.MSG_0110")%>");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

<%--
	if(!checkKorea(f.password, "<%=text.get("AD_132.MSG_0111")%>", 10))//"비밀번호는 10자 이내입니다.."
		return false;

	if(!checkEmpty(f.password2, "<%=text.get("AD_132.MSG_0112")%>"))//"비밀번호 확인을 입력해주십시요."
		return false;

	if( !(f.password.value == f.password2.value) )
	{
		//alert("비밀번호가 일치하지 않습니다.");
		alert("<%=text.get("AD_132.MSG_0113")%>");
		f.password.focus();
		f.password.select();
		return false;
	}
--%>

	if(!checkEmpty(f.user_name_loc, "<%=text.get("AD_132.MSG_0114")%>"))//"사용자명(국문)을 입력해주십시요."
		return false;

	if(!checkKorea(f.user_name_loc, "<%=text.get("AD_132.MSG_0115")%>", 40))//"사용자명(국문)은 40자 이내입니다."
		return false;

<%--
	if(!checkKorea(f.user_first_name_eng, "<%=text.get("AD_132.MSG_0116")%>", 40))//"FIRST NAME은 40자 이내입니다."
		return false;

	if(!checkKorea(f.user_last_name_eng, "<%=text.get("AD_132.MSG_0117")%>", 40))//"LAST NAME은 40자 이내입니다."
		return false;
--%>

	if (f.user_name_eng.value == "")
	{
		if (f.user_first_name_eng.value == "" || f.user_last_name_eng.value == "" )
			f.user_name_eng.value = f.user_first_name_eng.value +  f.user_last_name_eng.value;
		else
			f.user_name_eng.value = f.user_first_name_eng.value + " " + f.user_last_name_eng.value;
	}
	else
	{
		f.user_name_eng.value = LTrim(f.user_name_eng.value);
	}

	if(!checkKorea(f.user_name_eng, "<%=text.get("AD_132.MSG_0118")%>", 40))//"사용자명(영문)은 40자 이내입니다."
		return false;
	if(!checkEmpty(f.user_name_loc, "<%=text.get("AD_132.MSG_0119")%>"))//"사용자명(영문)을 입력해주십시요."
		return false;

	if(!checkKorea(f.company_code, "<%=text.get("AD_132.MSG_0120")%>", 10))//"회사코드는 10자 이내입니다."
		return false;
	if(!checkEmpty(f.company_code, "<%=text.get("AD_132.0001")%>"))//회사코드를 선택하시기 바랍니다.
		return false;

	if(!checkKorea(f.employee_no, "<%=text.get("AD_132.MSG_0123")%>", 10))//"사원번호 10자 이내입니다."
		return false;

	if (f.user_type.value != "S" && f.user_type.value != "P")
	{
<%--
		if(!checkEmpty(f.employee_no, "<%=text.get("AD_132.MSG_0124")%>"))//"사원번호를 입력해주십시요."
			return false;

		if(!checkEmpty(f.pr_location, "<%=text.get("AD_132.MSG_0125")%>"))//"청구지역을 입력해주십시요."
			return false;

		if(!checkKorea(f.dept, "<%=text.get("AD_132.MSG_0121")%>", 10))//"부서코드는 10자 이내입니다."
			return false;
		if(!checkEmpty(f.dept, "<%=text.get("AD_132.MSG_0122")%>"))//"부서코드를 입력해주십시요."
			return false;
--%>
	}


	if(!checkEmpty(f.phone_no0, "<%=text.get("AD_132.MSG_0126")%>"))//"전화번호를 입력해주십시요."
		return false;

	if(!checkTel(f.phone_no0, "<%=text.get("AD_132.MSG_0127")%>"))//"전화번호 형태로 입력해주십시요."
		return false;

<%--
	if(!checkEmpty(f.phone_no1, "<%=text.get("AD_132.MSG_0126")%>"))//"전화번호를 입력해주십시요."
		return false;

	if(!checkEmpty(f.phone_no2, "<%=text.get("AD_132.MSG_0126")%>"))//"전화번호를 입력해주십시요."
		return false;

	if(!checkEmpty(f.phone_no3, "<%=text.get("AD_132.MSG_0126")%>"))//"전화번호를 입력해주십시요."
		return false;

	if(!checkTel(f.phone_no1, "<%=text.get("AD_132.MSG_0127")%>"))//"전화번호 형태로 입력해주십시요."
		return false;

	if(!checkTel(f.phone_no2, "<%=text.get("AD_132.MSG_0127")%>"))//"전화번호 형태로 입력해주십시요."
		return false;

	if(!checkTel(f.phone_no3, "<%=text.get("AD_132.MSG_0127")%>"))//"전화번호 형태로 입력해주십시요."
		return false;
--%>

	if(!checkKorea(f.email, "<%=text.get("AD_132.MSG_0128")%>", 50))//"이메일은 50자 이내입니다."
		return false;

	if(!checkEmpty(f.email, "<%=text.get("AD_132.MSG_0129")%>"))//"이메일을 입력해주십시요."
		return false;

	if(!checkKorea(f.language, "<%=text.get("AD_132.MSG_0130")%>", 5))//"사용언어는 5자 이내입니다."
		return false;

	if(!checkEmpty(f.language, "<%=text.get("AD_132.MSG_0131")%>"))//"사용언어를 선택해주십시요."
		return false;

<%--
	if(!checkEmpty(f.mobile_no1, "<%=text.get("AD_132.MSG_0132")%>"))//"휴대폰번호를 입력해주십시요."
		return false;

	if(!checkTel(f.mobile_no1, "<%=text.get("AD_132.MSG_0133")%>"))//"전화번호 형태로 입력해주십시요."
		return false;

	if(!checkEmpty(f.mobile_no2, "<%=text.get("AD_132.MSG_0134")%>"))//"휴대폰번호를 입력해주십시요."
		return false;

	if(!checkTel(f.mobile_no2, "<%=text.get("AD_132.MSG_0135")%>"))//"전화번호 형태로 입력해주십시요."
		return false;

	if(!checkEmpty(f.mobile_no3, "<%=text.get("AD_132.MSG_0136")%>"))//"휴대폰번호를 입력해주십시요."
		return false;

	if(!checkTel(f.mobile_no3, "<%=text.get("AD_132.MSG_0137")%>"))//"전화번호 형태로 입력해주십시요."
		return false;


	if(!checkTel(f.fax_no1, "<%=text.get("AD_132.MSG_0138")%>"))//"팩스번호 형태로 입력해주십시요."
		return false;

	if(!checkTel(f.fax_no2, "<%=text.get("AD_132.MSG_0138")%>"))//"팩스번호 형태로 입력해주십시요."
		return false;

	if(!checkTel(f.fax_no3, "<%=text.get("AD_132.MSG_0138")%>"))//"팩스번호 형태로 입력해주십시요."
		return false;
--%>
	if(!checkTel(f.mobile_no0, "<%=text.get("AD_132.MSG_0135")%>"))//"전화번호 형태로 입력해주십시요."
		return false;
	if(!checkTel(f.fax_no0, "<%=text.get("AD_132.MSG_0138")%>"))//"팩스번호 형태로 입력해주십시요."
		return false;

	if(!checkKorea(f.zip_code, "<%=text.get("AD_132.MSG_0139")%>", 10))//"우편번호는 10자 이내입니다."
		return false;

	if(!checkKorea(f.country, "<%=text.get("AD_132.MSG_0140")%>", 2))//"국가는 2자 이내입니다."
		return false;

	if(!checkEmpty(f.country, "<%=text.get("AD_132.MSG_0141")%>"))//"국가를 선택해주십시요."
		return false;

	if(!checkKorea(f.city_code, "<%=text.get("AD_132.MSG_0142")%>", 10))//"도시는 10자 이내입니다."
		return false;

	if(!checkKorea(f.city_name, "<%=text.get("AD_132.MSG_0143")%>", 200))//"도시이름은 200자 이내입니다."
		return false;

	if(!checkKorea(f.state, "<%=text.get("AD_132.MSG_0144")%>", 20))//"지역은 20자 이내입니다."
		return false;

	if(!checkKorea(f.address_loc, "<%=text.get("AD_132.MSG_0145")%>", 200))//"주소(한글)은 200자 이내입니다."
		return false;

	if(!checkKorea(f.address_eng, "<%=text.get("AD_132.MSG_0146")%>", 200))//"주소(영문)은 200자 이내입니다."
		return false;

	if (f.duplicate.value == "F")
	{
		//alert("중복확인을 해주십시요.");
		alert("<%=text.get("AD_132.MSG_0147")%>");
		return false;
	}

	return true;
}

function goDuplicate()
{
	var f = document.forms[0];
	f.duplicate.value = "T";
	f.user_id.value = f.user_id.value.toUpperCase();
	var user_id = f.user_id.value;

	if(!checkEmpty(f.user_id, "<%=text.get("AD_132.MSG_0148")%>"))//"사용자 ID를 입력해주십시요."
		return;
		
	if(!chkHangul(f.user_id.value)){
		alert("<%=text.get("AD_132.MSG_9990")%>");//아이디에 한글을 사용하실 수 없습니다.
		return;
	}	

	if(!checkKorea(f.user_id, "<%=text.get("AD_132.MSG_0149")%>", 10))//"사용자 ID는 10자 이내입니다."
		return ;

/* 	f.method = "POST";
	f.target = "childFrame";
	f.action = "user_register_chk.jsp";
	f.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "user_register_chk.jsp";
	jqa.submit();

}

function checkDulicate(o_flag)
{
	document.form.duplicate.value = o_flag;

	if(o_flag == "F") {
		document.form.user_id.select();
		return false;
	} else if(o_flag == "T") {
		return true;
	}
}

function operatingSave()
{
	var f = document.forms[0];

	if(!checkData())
	{
		return;
	}
	
	if(!chkHangul(f.user_id.value)){
		alert("<%=text.get("AD_132.MSG_9990")%>");//아이디에 한글을 사용하실 수 없습니다.
		return;
	}		

/* 	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "user_register_save.jsp";
	document.form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "user_register_save.jsp";
	jqa.submit();
}

function actionedit()
{
	var f = document.forms[0];
	var user_type      = f.user_type.value;
	var text_user_type = f.user_type.options[f.user_type.selectedIndex].text;

	if ( user_type == "P" || user_type == "S" )
	{
		f.edit.value               = "Y";
		f.company_code.value       = "";
		f.text_company_code2.value = "";
	}
	else
	{
		f.company_code.value = user_type;
		f.text_company_code2.value = user_type;
		f.edit.value = "N";
	}

	if ( user_type == DEFAULT_USER_TYPE ) {
    	for(n=1;n<=4;n++) {
    		document.all["g"+n].style.visibility = "visible";
    		if(n>1) document.all["g"+n].disabled = "false";
    	}
	} else {
		for(n=1;n<=4;n++) {
//			document.all["g"+n].style.visibility = "hidden";
//			if(n>1) document.all["g"+n].disabled = "true";
		}
	}

	if("<%=info.getSession("USER_TYPE")%>" == "S" || "<%=info.getSession("USER_TYPE")%>" == "P")
	{
		for(var i = 0; i < f.user_type.length; i++)
		{
			if(f.user_type.options[i].value == "<%=info.getSession("USER_TYPE")%>")
			{
				f.user_type.selectedIndex = i;
				f.user_type.disabled = true;
			}
		}

		f.company_code.value = "<%=info.getSession("COMPANY_CODE")%>";
		f.text_company_code2.value = "<%=info.getSession("COMPANY_CODE")%>";
	}
}

function searchProfile(part)
{
	var f = document.forms[0];

	if( part == "company_code" )
	{
		if (f.edit.value == "N"){
			return;}

		if (f.user_type.value  == "")
		{
			//alert("사용자 구분을 먼저 선택해야 합니다.");
			alert("<%=text.get("AD_132.MSG_0150")%>");
			f.user_type.focus();
			return;
		}
		
		if (f.user_type.value  == "P")
		{
			PopupCommon1("SP0055", "getPartner_code", "", "","");
		}
		else if (LRTrim(f.user_type.value)  == "S")
		{
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	if(part == "city")
	{
		if(!checkEmpty(f.country, "<%=text.get("AD_132.MSG_0153")%>"))//"국가를 먼저 선택해야 합니다."
			return;
		//PopupCommon2("SP0019", "getCity", f.country.value, "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0019&function=getCity&values="+f.country.value+"&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
	}

	else if(part == "dept")
	{
		if (f.user_type.value  == "P" || f.user_type.value  == "S")
		{
			//PopupCommon2("SP9053", "getDept", "M105", "","");
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getDept&values=M105&values=&values=&width=700";
       		Code_Search(url3, '', '', '', '720', '500');
		}
		else
		{
			if(!checkEmpty(f.company_code, "<%=text.get("AD_132.MSG_0154")%>"))//"회사단위를 먼저 선택해야 합니다."
				return;
			//PopupCommon2("SP0022", "getDept", f.company_code.value, "코드","부서명");
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+f.company_code.value+"&values=&values=/&width=700&desc=code&desc=name";
       		Code_Search(url3, '', '', '', '720', '500');
		}

	}
	else if(part == "pr")
	{
		//PopupCommon2("SP9053", "getPr", "M062", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getPr&values=<%=house_code%>&values=M062&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
	}
	else if(part == "posi")
	{
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getPosition&values=<%=house_code%>&values=M106&values=&values=&width=700";
       		Code_Search(url3, '', '', '', '720', '500');
	}
	else if(part == "manager_posi")
	{
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getmanager_Position&values=<%=house_code%>&values=M107&values=&values=&width=700";
       		Code_Search(url3, '', '', '', '720', '500');
	}
	else if(part == "language") {
		//PopupCommon2("SP9053", "getLanguage", "M013", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getLanguage&values=<%=house_code%>&values=M013&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }
	else if(part == "country") {
		//PopupCommon2("SP9053", "getCountry", "M001", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getCountry&values=<%=house_code%>&values=M001&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }
	else if(part == "time_zone") {
		//PopupCommon2("SP9001", "getTimeZone", "M075", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9001&function=getTimeZone&values=M075&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }

}
function getCity(code, text) {
	document.forms[0].city_code.value = code;
	document.forms[0].city_name.value = text;
}

function getDept(code, text) {
	document.forms[0].dept.value = code;
	document.forms[0].text_dept.value = text;
}

function getPr(code, text) {
	document.forms[0].pr_location.value = code;
	document.forms[0].text_pr_location.value = text;
}

function getPosition(code, text) {
	document.forms[0].position.value = code;
	document.forms[0].position_name.value = text;
}

function getmanager_Position(code, text) {
	document.forms[0].manager_position.value = code;
	document.forms[0].text_manager_position.value = text;
}

function getPartner_code(code,text, type) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code2.value = code;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function getLanguage(code,text) {
	document.forms[0].language.value = code;
	document.forms[0].text_language.value = text;
}

function getCountry(code,text) {
	document.forms[0].country.value = code;
	document.forms[0].text_country.value = text;
}

function getTimeZone(code,text) {
	document.forms[0].time_zone.value = code;
	document.forms[0].text_time_zone.value = text;
}

function SP0216_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0216&function=D&values=CJ00&values=&values=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	form.ctrl_code.value = ls_ctrl_code;
}

function chkMixing(chkstr)
{
    var j, a_cnt = 0, AA_cnt = 0, n_cnt = 0, ch = "";

    for (j=0; j<chkstr.length; j++)
    {
        ch = chkstr.charAt(j);
        if (!(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z') && !(ch >= '0' && ch <= '9'))
        {
            return false;
        }

        if(ch >= 'a' && ch <= 'z') a_cnt++;
        if(ch >= 'A' && ch <= 'Z') AA_cnt++;
        if(ch >= '0' && ch <= '9') n_cnt++;
    }

    if(a_cnt == 0 && AA_cnt == 0) return false;
    if(n_cnt == 0) return false;

    return true;
}
function chkIdIsEquals(chkstr)
{
    //var user_id = document.forms[0].user_id.value;
    var user_id = document.forms[0].user_id.value.toUpperCase();

    if(chkstr.indexOf(user_id) != -1) return false;
    else return true;
}
function chkInputRepeat(chkstr)
{
    var j, repeat_cnt = 0, ch = "";

    for (j=0; j<chkstr.length; j++)
    {
        var tmp_ch = chkstr.charAt(j);

        if(j == 0) {
            ch = tmp_ch;
            repeat_cnt = 1;
        } else {
            if(ch == tmp_ch) {
                ch = tmp_ch;
                repeat_cnt++;
            } else {
                ch = tmp_ch;
                repeat_cnt = 1;
            }
        }

        if(repeat_cnt > 2) return false;
    }

    return true;
}


</script>
</head>

<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="init()">
<s:header>
<form name="form" method="post" action="">

<!--  
<input type="hidden" name="language" id="language">
<input type="hidden" name="text_language" id="text_language">
<input type="hidden" name="country" id="country">
<input type="hidden" name="text_country" id="text_country">
-->

<input type="hidden" name="pr_location" id="pr_location">
<input type="hidden" name="text_pr_location" id="text_pr_location">
<input type="hidden" name="zip_code" id="zip_code">
<input type="hidden" name="time_zone" id="time_zone">
<input type="hidden" name="text_time_zone" id="text_time_zone">

<input type="hidden" name="city_code" id="city_code">
<input type="hidden" name="city_name" id="city_name">
<input type="hidden" name="state" id="state">
<input type="hidden" name="employee_no" id="employee_no">
<input type="hidden" name="plm_user_flag" id="plm_user_flag">		

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
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
	    <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
		      <tr>
        		<td height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0100")%></td>
        		<td height="24" class="data_td">
        			<select name="user_type" id="user_type" class="input_re" onChange="actionedit();">
						<option value=""><%=text.get("AD_132.TEXT_0101")%></option>
						<%=LB_USER_TYPE %>
					</select>
					<input type="hidden" name="origin_user_type" id="origin_user_type" value="<%=info.getSession("USER_TYPE") %>">
        		</td>
        		<td height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0102")%></td>
        		<td height="24" class="data_td">
        			<select name="work_type" id="work_type" class="input_re">
						<option value=""><%=text.get("AD_132.TEXT_0103")%></option>
						<%
							 String work_type = ListBox(request, "SL0007",info.getSession("HOUSE_CODE")+"#M104#", "");
							 out.println(work_type);
					   	%>
					</select>
				</td>
        		<td height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0104")%></td>
        		<td height="24" class="data_td">
        			<input type="text" name="company_code" id="company_code" value="" size="10" maxlength="10" class="<%=is_buyer ? "inputsubmit" : "input_empty" %>" readonly>
        		<%	if(is_buyer) { %>
					<a href="javascript:searchProfile('company_code')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
				<%	}	 %>
					<input type="hidden" name="text_company_code" id="text_company_code" value="" size="40" class="input_empty" readOnly>
				</td>
			  </tr>
			  </table>
			  </td>
                		</tr>
            		</table>
			<%--
								<select name="company_code" class="input_re">
								<option value=""></option>
								 <%
								 String lb = ListBox(request, "SL0006" ,house_code+"#", company_code);
								 out.println(lb);
								 %>
								</select>
			--%>

			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<input type="hidden" name="duplicate2" id="duplicate2" value="F">
					<input type="hidden" name="edit" id="edit" value="Y">
					<input type="hidden" name="i_flag" id="i_flag" value="">
				</td>
			  </tr>
			  </table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
			    	  	<TD><script language="javascript">btn("javascript:operatingSave()","<%=text.get("BUTTON.insert")%>")</script></TD>
			    	  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
			  <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0105")%></td>
				<td class="data_td" colspan="3">
					<table cellpadding="0">
						<tr>
							<td><input type="text" name="user_id" id="user_id" size="15" maxlength="10" class="input_re"></td>
							<td><script language="javascript">btn("javascript:goDuplicate()", "<%=text.get("BUTTON.dulicate")%>")</script></td>
						</tr>
					</table>
						<input type="hidden" name="duplicate" id="duplicate" value="F">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0106")%></td>
				<td class="data_td" width="35%">
					<input type="password" name="password" id="password" size="15" maxlength="10" class="input_re">
				</td>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0107")%></td>
				<td class="data_td" width="35%">
					<input type="password" name="password2" id="password2" size="15" maxlength="10" class="input_re">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0108")%>	</td>
				<td class="data_td">
					<input type="text" name="user_name_loc" id="user_name_loc" size="20" maxlength="40" class="input_re">
				</td>
				<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0109")%></td>
				<td class="data_td">
					<input type="text" name="user_name_eng" id="user_name_eng" size="20" maxlength="40" class="inputsubmit">
					<input type="hidden" name="user_first_name_eng" id="user_first_name_eng" size="20" maxlength="40" class="inputsubmit">
					<input type="hidden" name="user_last_name_eng" id="user_last_name_eng" size="20" maxlength="40" class="inputsubmit">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
<%--
			  <tr>
				<td class="cell1_title" width="15%">
					FIRST NAME
				</td>
				<td class="cell1_data">
					<input type="text" name="user_first_name_eng" size="20" maxlength="40" class="inputsubmit">
				</td>
				<td class="cell1_title">
					LAST NAME
				</td>
				<td class="cell1_data">
					<input type="text" name="user_last_name_eng" size="20" maxlength="40" class="inputsubmit">
				</td>
			  </tr>
--%>
			  <tr>
				<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0110")%></td>
				<td class="data_td">
					<input type="text" name="text_company_code2" id="text_company_code2" size="20" class="input_empty" readonly>
				</td>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0111")%></td>
				<td class="data_td" width="35%">
					<input type="text" name="dept" id="dept" value="" size="5" maxlength="10" class="input_re" readonly>
					<a href="javascript:searchProfile('dept')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_dept" id="text_dept" value="" size="20" class="input_empty" readOnly>
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
<!-- 제거 시작 -->
<%-- 
			  <tr>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0112")%></td>
				<td class="div_data" width="35%">
					<input type="text" name="employee_no" size="20" maxlength="10" class="input_re">
				</td>


				  <td class="div_input" width="15%" align="center">
				  		<%=text.get("AD_132.TEXT_PLM_USER_FLAG")%>
				  </td>
				  <td class="div_data" width="35%">
					        <select name="plm_user_flag" class="input_re">
							<%
								 String plm_user_flag = ListBox(request, "SL0007",  "#M223#", "");
								 out.println(plm_user_flag);
						   	%>
						</select>
				  </td>
			  </tr>
--%>					
<!-- 제거 끝 -->	

			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0113")%></td>
				<td class="data_td">
					<input type="text" name="phone_no0" id="phone_no0" size="15" maxlength="20" class="input_re">
					<input type="hidden" name="phone_no1" id="phone_no1" size="3" maxlength="3" class="input_re">
					<input type="hidden" name="phone_no2" id="phone_no2" size="4" maxlength="4" class="input_re">
					<input type="hidden" name="phone_no3" id="phone_no3" size="4" maxlength="4" class="input_re">
				</td>
				<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0114")%></td>
				<td class="data_td">
					<input type="text" name="email" id="email" size="30" maxlength="50" class="input_re">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0115")%></td>
				<td class="data_td">
					<input type="text" name="mobile_no0" id="mobile_no0" size="15" maxlength="20" class="input_re">
					<input type="hidden" name="mobile_no1" id="mobile_no1" size="3" maxlength="3" class="input_re">
					<input type="hidden" name="mobile_no2" id="mobile_no2" size="4" maxlength="4" class="input_re">
					<input type="hidden" name="mobile_no3" id="mobile_no3" size="4" maxlength="4" class="input_re">
				</td>
				<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0116")%></td>
				<td class="data_td">
					<input type="text" name="fax_no0" id="fax_no0" size="15" maxlength="20" class="inputsubmit">
					<input type="hidden" name="fax_no1" id="fax_no1" size="3" maxlength="3" class="inputsubmit">
					<input type="hidden" name="fax_no2" id="fax_no2" size="4" maxlength="4" class="inputsubmit">
					<input type="hidden" name="fax_no3" id="fax_no3" size="4" maxlength="4" class="inputsubmit">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0117")%></td>
				<td class="data_td" width="35%">
					<input type="text" name="position" id="position" value="" size="5" maxlength="10" class="inputsubmit" readOnly>
					<a href="javascript:searchProfile('posi')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="position_name" id="position_name" value="" size="20" maxlength="200" class="input_empty" readOnly>
				</td>
				<td class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0118")%></td>
				<td class="data_td">
					<input type="text" name="manager_position" id="manager_position" value="" size="5" maxlength="10" class="inputsubmit" readOnly>
					<a href="javascript:searchProfile('manager_posi')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_manager_position" id="text_manager_position" value="" size="20" class="input_empty" readOnly>
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>

<!-- 제거 시작 -->
<%-- 
			  <tr>
				<td class="div_input_re" width="15%" align="center"><%=text.get("AD_132.TEXT_0119")%>	</td>
				<td class="div_data" width="35%">
					<input type="text" name="language" value="KO" size="5" class="input_re" readOnly>
					<a href="javascript:searchProfile('language')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_language" value="<%=text.get("AD_132.TEXT_0130")%>" size="15" maxlength="15" class="input_empty" readOnly>
				</td>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0120")%></td>
				<td class="div_data" width="35%">
					<input type="text" name="pr_location" value="" size="5" maxlength="10" class="input_re" readOnly>
					<a href="javascript:searchProfile('pr')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_pr_location" value="" size="20" class="input_empty" readOnly>
				</td>
			  </tr>

			  <tr>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0121")%></td>
				<td class="div_data">
					<input type="text" name="zip_code" size="20" maxlength="10" class="inputsubmit">
				</td>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0122")%></td>
				<td class="div_data" width="35%">
					<input type="text" name="time_zone" value="G09" size="5" class="inputsubmit" readOnly>
					<a href="javascript:searchProfile('time_zone')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_time_zone" value="GMT+09:00" size="12" maxlength="12" class="input_empty" readOnly>
				</td>
			  </tr>

			  <tr>
				<td class="div_input_re" width="15%" align="center"><%=text.get("AD_132.TEXT_0123")%></td>
				<td class="div_data" width="35%">
					<input type="text" name="country" value="KR" size="5" class="input_re" readOnly>
					<a href="javascript:searchProfile('country')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_country" value="<%=text.get("AD_132.TEXT_0129")%>" size="15" maxlength="15" class="input_empty" readOnly>
				</td>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0124")%></td>
				<td class="div_data" width="35%">
					<input type="text" name="city_code" value="" size="15" maxlength="100" class="inputsubmit">
				<!--
					<a href="javascript:searchProfile('city')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
				-->
					<input type="text" name="city_name" value="" size="10" class="input_empty" readOnly>
				</td>
			  </tr>

			  <tr>
				<td class="div_input" width="15%" align="center"><%=text.get("AD_132.TEXT_0125")%>(only U.S.A)</td>
				<td class="div_data" width="35%">
					<input type="text" name="state" size="20" maxlength="20" class="inputsubmit">
				</td>
				<td class="div_input" width="15%" align="center"><span id="g1"><%=text.get("AD_132.TEXT_0126")%></span></td>
				<td class="div_data" width="35%">
					<input type="text" name="ctrl_code" size="15" maxlength="100" class="inputsubmit" id="g2">
				<!--
					<a href="javascript:SP0216_Popup();" id="g4">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" id="g3" alt="">
					</a>
				-->
				</td>
			  </tr>
--%>			  
<!-- 제거 끝 -->	

			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0119")%>	</td>
				<td class="data_td" width="35%">
					<input type="text" name="language" id="language" value="KO" size="5" class="input_re" readOnly>
					<a href="javascript:searchProfile('language')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_language" id="text_language" value="<%=text.get("AD_132.TEXT_0130")%>" size="15" maxlength="15" class="input_empty" readOnly>
				</td>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0123")%></td>
				<td class="data_td" width="35%">
					<input type="text" name="country" id="country" value="KR" size="5" class="input_re" readOnly>
					<a href="javascript:searchProfile('country')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="text_country" id="text_country" value="<%=text.get("AD_132.TEXT_0129")%>" size="15" maxlength="15" class="input_empty" readOnly>
				</td>
			  </tr>
			  			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<span id="g1"><%=text.get("AD_132.TEXT_0126")%></span></td>
				<td class="data_td" colspan="3">
					<input type="text" name="ctrl_code" id="ctrl_code" size="15" maxlength="100" class="inputsubmit" id="g2">
				<%--
					<a href="javascript:SP0216_Popup();" id="g4">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" id="g3" alt="">
					</a>
				--%>
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0127")%></td>
				<td class="data_td" colspan="3">
					<input type="text" name="address_loc" id="address_loc" size="90" maxlength="200" class="inputsubmit">
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td class="title_td" width="15%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_132.TEXT_0128")%><br></td>
				<td class="data_td" colspan="3">
					<input type="text" name="address_eng" id="address_eng" size="90" maxlength="200" class="inputsubmit">
				</td>
			  </tr>
		      </table>
			  
<%-- 			  <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>
		
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=200"/>
</jsp:include> --%>
<!-- <iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> -->
</s:header>
<s:footer/>
</body>
</html>
