<%--
	»ç¿ëÀÚ µî·Ï
	Áßº¹°Ë»ç : goDuplicate() -> use_wk_ins2.jsp
	ÀúÀå        : operatingSave() -> use_wk_ins1.jsp
--%>
<%@ include file="/include/wisehub_session.jsp"%>
<%@ include file="/include/wisehub_common.jsp"%>
<%@ include file="/include/admin_common.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String LB_USER_TYPE = ListBox(request, "SL0081",  house_code+"#"+house_code+"#", company_code);
%>

<%--Á¢¼ÓÇã¿ëID°¹¼ö  --%>
<%@ include file="/kr/master/user/count_user_id.jsp"%>

<html>
<Script language="javascript" type="text/javascript">
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
		obj.phone_no1.focus();
		obj.phone_no1.select();
		return false;
	}
	return true;
}

function checkData()
{
	var f = document.forms[0];
	
	var checkCode = f.user_id.value;

	if(!checkEmpty(f.user_type,"»ç¿ëÀÚ±¸ºÐÀ» ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.work_type,"¾÷¹«±ÇÇÑÀ» ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.user_id, "»ç¿ëÀÚ ID¸¦ ÀÔ·ÂÇÏ¼Å¾ß ÇÕ´Ï´Ù."))
		return false;
	
	if(!checkEmpty(f.login_ncy, "Á¢¼Ó°¡´É¿©ºÎ¸¦ ¼±ÅÃÇÏ¼Å¾ß ÇÕ´Ï´Ù."))
		return false;

    if(isEmpty(document.form.password.value)){
	 	alert("ºñ¹Ð¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä.");
	 	document.form.password.focus();
	 	return false;
	}

	if(isEmpty(document.form.password2.value)){
	 	alert("ºñ¹Ð¹øÈ£È®ÀÎÀ» ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä.");
	 	document.form.password2.focus();
	 	return false;
	}

	if(!(document.form.password.value == document.form.password2.value) ) {
        alert("ºñ¹Ð¹øÈ£°¡ ÀÏÄ¡ÇÏÁö ¾Ê½À´Ï´Ù.");
        document.form.password.focus();
        document.form.password.select();
        return false;
    }

    if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
        alert("ºñ¹Ð¹øÈ£´Â ¿µ¹®ÀÚ¿Í ¼ýÀÚ¸¦ È¥¿ëÇÏ¿© 6~10ÀÚ¸¸ °¡´ÉÇÕ´Ï´Ù.");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkMixing(document.forms[0].password.value)) {
        alert("ºñ¹Ð¹øÈ£´Â ¿µ¹®ÀÚ¿Í ¼ýÀÚ¸¦ È¥¿ëÇÏ¿© 6~10ÀÚ¸¸ °¡´ÉÇÕ´Ï´Ù.");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkIdIsEquals(document.forms[0].password.value)) {
        alert("ºñ¹Ð¹øÈ£´Â ID°¡ Æ÷ÇÔµÇ¾î ÀÖÀ¸¸é ¾ÈµË´Ï´Ù.");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

    if(!chkInputRepeat(document.forms[0].password.value)) {
        alert("ºñ¹Ð¹øÈ£´Â °°Àº ¹®ÀÚ¸¦ 3¹ø ÀÌ»ó ¹Ýº¹ ÀÔ·ÂÇÒ ¼ö ¾ø½À´Ï´Ù.");
        document.forms[0].password.focus();
        document.forms[0].password.select();
        return false;
    }

	if(!checkEmpty(f.user_name_loc, "»ç¿ëÀÚ¸í(±¹¹®)À» ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.user_name_loc, "»ç¿ëÀÚ¸í(±¹¹®)Àº 40ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",40))
		return false;

	if (f.user_name_eng.value == "")
	{
		if (f.user_first_name_eng.value == "" || f.user_last_name_eng.value == "" )
			f.user_name_eng.value = f.user_first_name_eng.value +  f.user_last_name_eng.value;
		else
			f.user_name_eng.value = f.user_first_name_eng.value + " " + f.user_last_name_eng.value;
	} else {
		f.user_name_eng.value = LTrim(f.user_name_eng.value);
	}

	if(!checkKorea(f.user_name_eng, "»ç¿ëÀÚ¸í(¿µ¹®)Àº 40ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",40))
		return false;
	
	if(!checkEmpty(f.company_code, "È¸»çÄÚµå¸¦ ¼±ÅÃÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.company_code, "È¸»çÄÚµå´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",10))
		return false;
	
	if(!checkEmpty(f.dept, "ºÎ¼­ÄÚµå¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.dept, "ºÎ¼­ÄÚµå´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",10))
		return false;
	
	if(!checkKorea(f.employee_no, "»ç¿ø¹øÈ£ 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",10))
		return false;

	if (f.user_type.value != "S")
	{
		if(!checkEmpty(f.employee_no, "»ç¿ø¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
			return false;
		if(!checkEmpty(f.pr_location, "Ã»±¸Áö¿ªÀ» ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
			return false;

		var dely_zip_code = f.dely_zip_code1.value + f.dely_zip_code2.value;
		f.dely_zip_code.value = dely_zip_code;
		
		if(!checkEmpty(f.dely_zip_code1,"¹è¼ÛÁö ¿ìÆí¹øÈ£¸¦ ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
			return false;
		
		if(!checkKorea(f.dely_zip_code, "¹è¼ÛÁö ¿ìÆí ¹øÈ£´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",10))
			return false;
		
		if(!checkEmpty(f.dely_address_loc,"¹è¼ÛÁö ÁÖ¼Ò¸¦ ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
			return false;
		
		if(!checkKorea(f.dely_address_loc, "¹è¼ÛÁö ÁÖ¼Ò´Â 200ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 200))
			return false;
	}

	if(!checkKorea(f.language, "»ç¿ë¾ð¾î´Â 5ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",5))
		return false;

	if(!checkEmpty(f.language, "»ç¿ë¾ð¾î¸¦ ¼±ÅÃÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.country, "±¹°¡´Â 2ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",2))
		return false;

	if(!checkEmpty(f.country, "±¹°¡¸¦ ¼±ÅÃÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.city_code, "µµ½Ã´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 10))
		return false;

	if(!checkKorea(f.city_name, "µµ½ÃÀÌ¸§Àº 200ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 200))
		return false;

	if(!checkKorea(f.state, "Áö¿ªÀº 20ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 20))
		return false;

	if(!checkEmpty(f.phone_no1, "ÀüÈ­¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.phone_no2, "ÀüÈ­¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.phone_no3, "ÀüÈ­¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.phone_no1, "ÀüÈ­¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.phone_no2, "ÀüÈ­¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.phone_no3, "ÀüÈ­¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.fax_no1, "ÆÑ½º¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.fax_no2, "ÆÑ½º¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.fax_no3, "ÆÑ½º¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.mobile_no1, "ÈÞ´ëÆù¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.mobile_no2, "ÈÞ´ëÆù¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkEmpty(f.mobile_no3, "ÈÞ´ëÆù¹øÈ£¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.mobile_no1, "ÈÞ´ëÆù¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.mobile_no2, "ÈÞ´ëÆù¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkTel(f.mobile_no3, "ÈÞ´ëÆù¹øÈ£ ÇüÅÂ·Î ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	if(!checkKorea(f.email, "ÀÌ¸ÞÀÏÀº 50ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",50))
		return false;

	if(!checkEmpty(f.email, "ÀÌ¸ÞÀÏÀ» ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return false;

	var zip_code = f.zip_code1.value + f.zip_code2.value;
	f.zip_code.value = zip_code;
	
	if(!checkEmpty(f.zip_code1,"±âº» ¿ìÆí¹øÈ£¸¦ ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
		return false;
	
	if(!checkKorea(f.zip_code, "±âº» ¿ìÆí ¹øÈ£´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.",10))
		return false;

	if(!checkEmpty(f.address_loc,"±âº»ÁÖ¼Ò¸¦ ÀÔ·ÂÇØ ÁÖ½Ê½Ã¿ä."))
		return false;
	
	if(!checkKorea(f.address_loc, "±âº»ÁÖ¼Ò´Â 200ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 200))
		return false;

	//if(!checkKorea(f.address_eng, "ÁÖ¼Ò(¿µ¹®)Àº 200ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 200))
	//	return false;

	if (f.duplicate.value == "F")
	{
		alert("Áßº¹È®ÀÎÀ» ÇØÁÖ½Ê½Ã¿ä.");
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

	if(!checkEmpty(f.user_id, "»ç¿ëÀÚ ID¸¦ ÀÔ·ÂÇØÁÖ½Ê½Ã¿ä."))
		return;

	if(!checkKorea(f.user_id, "»ç¿ëÀÚ ID´Â 10ÀÚ ÀÌ³»ÀÔ´Ï´Ù.", 10))
		return ;

	f.method = "POST";
	f.target = "childFrame";
	f.action = "use_wk_ins2.jsp";
	f.submit();

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
	
	//Á¢¼ÓÇã¿ëÀÎ¿ø¿¡ ´ëÇØ¼­¸¸ Ã¼Å©ÇÑ´Ù.
	if(f.login_ncy.value = "Y"){
		if(parseInt('<%=maxCnt%>') == parseInt('<%=totalCnt%>')){
			alert("·Î±×ÀÎ°¡´ÉID °¹¼ö´Â ÃÖ´ë "+ '<%=maxCnt%>'+"ÀÔ´Ï´Ù.\nÇöÀç µî·ÏÇÑ ·Î±×ÀÎID °¹¼ö´Â "+'<%=totalCnt%>'+"ÀÔ´Ï´Ù");
			return;
		}	
	}
	
	if(!checkData()) {
		return;
	}
	
	f.zip_code1.disabled 		= false;
	f.zip_code2.disabled 		= false;
	f.dely_zip_code1.disabled 	= false;
	f.dely_zip_code2.disabled 	= false;
	f.language.disabled 		= false;
	f.text_language.disabled 	= false;
	f.text_pr_location.disabled = false;
	f.pr_location.disabled 		= false;
	f.time_zone.disabled 		= false;
	f.text_time_zone.disabled 	= false;
	f.country.disabled 			= false;
	f.text_country.disabled 	= false;
	f.city_code.disabled 		= false;
	f.city_name.disabled 		= false;
	f.state.disabled 			= false;

	document.form.method = "POST";
	document.form.target = "childFrame";
	document.form.action = "use_wk_ins1.jsp";
	document.form.submit();
}

function actionedit()
{
	var f = document.forms[0];

	f.zip_code1.disabled = true;
	f.zip_code2.disabled = true;
	f.dely_zip_code1.disabled = true;
	f.dely_zip_code2.disabled = true;
	f.language.disabled = true;
	f.text_language.disabled = true;
	f.text_pr_location.disabled = true;
	f.pr_location.disabled = true;
	f.time_zone.disabled = true;
	f.text_time_zone.disabled = true;
	f.country.disabled = true;
	f.text_country.disabled = true;
	f.city_code.disabled = true;
	f.city_name.disabled = true;
	f.state.disabled = true;

	var user_type      = f.user_type.value;
	var text_user_type = f.user_type.options[f.user_type.selectedIndex].text;

	if ( user_type == "P" || user_type == "S" )
	{
		f.edit.value               = "Y";
		f.company_code.value       = "";
		f.text_company_code2.value = "";
	}
	else {
		f.company_code.value = user_type;
		f.text_company_code2.value = user_type;
		f.edit.value = "N";
	}
}

function searchProfile(part)
{
	var f = document.forms[0];

	if( part == "company_code" )
	{
		if (f.edit.value == "N")
			return;

		if (f.user_type.value  == "")
		{
			alert("»ç¿ëÀÚ ±¸ºÐÀ» ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù.");
			f.user_type.focus();
			return;
		}

		if (f.user_type.value  == "P")
		{
			PopupCommon1("SP0055", "getPartner_code", G_HOUSE_CODE, "","");

		}
		else if (f.user_type.value  == "S")
		{
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	if(part == "city")
	{
		if(!checkEmpty(f.country,"±¹°¡¸¦ ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù."))
			return;
		PopupCommon2("SP0019", "getCity", G_HOUSE_CODE, f.country.value, "","");
	}

	else if(part == "dept")
	{
		if (f.user_type.value  == "P" || f.user_type.value  == "S")
		{
			PopupCommon2("SP9053", "getDept", G_HOUSE_CODE,"M105", "","");
		}
		else
		{
			if(!checkEmpty(f.company_code,"È¸»ç´ÜÀ§¸¦ ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù."))
				return;
			PopupCommon2("SP0022", "getDept", G_HOUSE_CODE,f.company_code.value, "ÄÚµå","ºÎ¼­¸í");
		}

	}
	else if(part == "pr")
	{
		PopupCommon2("SP9053", "getPr", G_HOUSE_CODE,"M062", "","");
	}
	else if(part == "posi")
	{
		if (f.user_type.value  == "P" || f.user_type.value  == "S")
		{
			PopupCommon2("SP9053", "getPosition", G_HOUSE_CODE,"M106", "","");
		}
		else
		{
			if(!checkEmpty(f.company_code,"È¸»ç´ÜÀ§¸¦ ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù."))
				return;

			var arr = new Array(G_HOUSE_CODE, f.company_code.value, "C002");
			PopupCommonArr("SP9029", "getPosition", arr, "", "");
		}
	}
	else if(part == "manager_posi")
	{
		if (f.user_type.value  == "P" || f.user_type.value  == "S")
		{
			PopupCommon2("SP9053", "getmanager_Position", G_HOUSE_CODE,"M107", "","");
		}
		else
		{
			if(f.company_code.value == "")
			{
				alert("È¸»ç´ÜÀ§¸¦ ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù.");
				return;
			}
			var arr = new Array(G_HOUSE_CODE, f.company_code.value, "C001");
			PopupCommonArr("SP9029", "getmanager_Position", arr, "", "");
		}
	}
	else if(part == "language")
		PopupCommon2("SP9053", "getLanguage", G_HOUSE_CODE,"M013", "","");
	else if(part == "country")
		PopupCommon2("SP9053", "getCountry", G_HOUSE_CODE,"M001", "","");
	else if(part == "time_zone")
		PopupCommon2("SP9001", "getTimeZone", G_HOUSE_CODE,"M075", "","");

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
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=company_code%>&values=&values=";
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
    var user_id = document.forms[0].user_id.value;

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

function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

function SP0274_Popup(dely_flag) {
	var f = document.forms[0];
	f.dely_flag.value = "";
	f.dely_flag.value = dely_flag;
	if (dely_flag == "Y") {
		f.dely_flag.checked = false;
		addrChecked();
	}
	MM_openBrWindow('/s_kr/admin/info/hico_addr_search_pop.jsp','subpop','width=500,height=500,left=40,top=20,resizable=yes');
}

function selectAddr(zip_code, address_loc1, address_loc2, city ) {
	var f = document.forms[0];
	if (f.dely_flag.value == "Y") {
		f.dely_zip_code1.value = zip_code.substring(0,3);
		f.dely_zip_code2.value = zip_code.substring(3,6);
		f.dely_address_loc.value = address_loc2;
	} else {
		f.zip_code1.value = zip_code.substring(0,3);
		f.zip_code2.value = zip_code.substring(3,6);
		f.address_loc.value = address_loc2;
		f.city_code.value = city;
	}
}

function addrChecked() {
	var f = document.forms[0];
	if (f.dely_flag.checked) {
		f.dely_zip_code1.value = f.zip_code1.value;
		f.dely_zip_code2.value = f.zip_code2.value;
		f.dely_address_loc.value = f.address_loc.value;
	} else {
		f.dely_zip_code1.value = '';
		f.dely_zip_code2.value = '';
		f.dely_address_loc.value = '';
	}
}

</Script>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="init()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="cell_title1" width="78%" align="left">&nbsp;
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">
	  	<%@ include file="/include/wisehub_milestone.jsp" %>
	  	</td>
	</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td width="760" height="2" bgcolor="#0072bc"></td></tr>
</table>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
<form name="form" method="post" action="../partner/partners%20create.htm">
<input type="hidden" name="duplicate2" value="F">
<input type="hidden" name="edit" value="Y">
<input type="hidden" name="i_flag" value="">
	<tr>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ ±¸ºÐ</td>
		<td class="c_data_1"  width="32%">
			<select name="user_type" class="input_re" onChange="actionedit();">
				<option>:::¼±ÅÃ:::</option>
				<%=LB_USER_TYPE %>
			</select>
		</td>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> È¸»çÄÚµå</td>
		<td class="c_data_1"  width="32%">
			<input type="text" name="company_code" value="" size="15" maxlength="10" class="input_re" readonly>
			<a href="javascript:searchProfile('company_code')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="text_company_code" value="" size="25" class="input_data1" readOnly>
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ¾÷¹«±ÇÇÑ</td>
		<td class="c_data_1" colspan="3">
			<select name="work_type" class="input_re">
				<option>:::¼±ÅÃ:::</option>
				<%
		 		String work_type = ListBox(request, "SL0007",  house_code+"#M104#", "");
				out.println(work_type);
				%>
			</select>
		</td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ ID</td>
		<td class="c_data_1"  width="32%">
			<TABLE cellpadding="0">
				<tr>
					<td>
						<input type="text" name="user_id" size="15" maxlength="10" class="input_re" onKeyUp="return chkMaxByte(20, this, '»ç¿ëÀÚID');">
					</td>
					<TD><script language="javascript">btn("javascript:goDuplicate()",28,"Áßº¹È®ÀÎ")</script></TD>
				</tr>
			</table>
			<input type="hidden" name="duplicate" value="F">
			<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Á¢¼Ó°¡´É¿©ºÎ</td>
			<td class="c_data_1"  width="32%">
				<select id="login_ncy" name="login_ncy" class="input_re">
					<option value="">::¼±ÅÃ::</option>
					<option value="Y">°¡´É</option>
					<option value="N">ºÒ°¡</option>
				</select>
			</td>
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ¸í(±¹¹®)</td>
		<td class="c_data_1">
			<input type="text" name="user_name_loc" size="20" maxlength="40" class="input_re" onKeyUp="return chkMaxByte(40, this, '»ç¿ëÀÚ¸í(±¹¹®)');">
		</td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ¸í(¿µ¹®)</td>
		<td class="c_data_1">
			<input type="text" name="user_name_eng" size="20" maxlength="40" class="inputsubmit" onKeyUp="return chkMaxByte(40, this, '»ç¿ëÀÚ¸í(¿µ¹®)');">
			<input type="hidden" name="user_first_name_eng" size="20" maxlength="40" class="inputsubmit">
			<input type="hidden" name="user_last_name_eng" size="20" maxlength="40" class="inputsubmit">
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ºñ¹Ð¹øÈ£</td>
		<td class="c_data_1" ><input type="password" name="password" size="15" maxlength="10" class="input_re" onKeyUp="return chkMaxByte(150, this, 'ºñ¹Ð¹øÈ£');"></td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ºñ¹Ð¹øÈ£È®ÀÎ</td>
		<td class="c_data_1" ><input type="password" name="password2" size="15" maxlength="10" class="input_re"></td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ºÎ ¼­</td>
		<td class="c_data_1">
			<input type="text" name="dept" value="" size="5" maxlength="10" class="input_re" readonly>
			<a href="javascript:searchProfile('dept')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="text_dept" value="" size="20" class="input_data1" readOnly>
			<input type="hidden" name="text_company_code2" value="">
		</td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ø¹øÈ£</td>
		<td class="c_data_1" >
			<input type="text" name="employee_no" size="20" maxlength="10" class="input_re" onKeyUp="return chkMaxByte(20, this, '»ç¿ø¹øÈ£');">
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Á÷ À§</td>
		<td class="c_data_1" colspan="3">
			<input type="text" name="position" value="" size="5" maxlength="10" class="inputsubmit" readOnly>
			<a href="javascript:searchProfile('posi')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="position_name" value="" size="20" maxlength="200" class="input_data1" readOnly>
		</td>
		<!-- 2011.3.24 solarb Á÷Ã¥ Ç×¸ñ hidden  display:none Á÷À§td colspan="3" -->
		<td class="c_title_1" style="display:none"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Á÷Ã¥</td>
		<td class="c_data_1"  style="display:none">
			<input type="text" name="manager_position" value="" size="5" maxlength="10" class="inputsubmit" readOnly>
			<a href="javascript:searchProfile('manager_posi')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="text_manager_position" value="" size="20" class="input_data1" readOnly>
		</td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ±¹°¡</td>
		<td class="c_data_1"  width="32%">
			<input type="text" name="country" value="KR" size="15" class="inputsubmit" readOnly>
			<input type="text" name="text_country" value="ÇÑ±¹" size="15" maxlength="15" class="input_data2" readOnly>
		</td>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> µµ½Ã</td>
		<td class="c_data_1"  width="32%">
			<input type="text" name="city_code" value="" size="15" maxlength="10" class="inputsubmit" readOnly >
			<input type="text" name="city_name" value="" size="15" class="input_data1" readOnly>
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Ã»±¸Áö¿ª</td>
		<td class="c_data_1">
			<input type="text" name="pr_location" value="01" size="5" maxlength="10" class="inputsubmit" readOnly>
			<input type="text" name="text_pr_location" value="1000" size="20" class="input_data1" readOnly>
		</td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> Áö¿ª(only U.S.A)</td>
		<td class="c_data_1" colspan="3">
			<input type="text" name="state" size="20" maxlength="20" class="inputsubmit" onKeyUp="return chkMaxByte(200, this, 'Áö¿ª(only U.S.A)');">
		</td>
	</tr>
	<tr>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ½Ã°£´ë¿ª</td>
		<td class="c_data_1">
			<input type="text" name="time_zone" value="G09" size="15" class="inputsubmit" readOnly>
			<input type="text" name="text_time_zone" value="GMT+09:00" size="12" maxlength="12" class="input_data1" readOnly>
		</td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ë¾ð¾î</td>
		<td class="c_data_1">
			<input type="text" name="language" value="KO" size="5" class="inputsubmit" readOnly>
			<input type="text" name="text_language" value="ÇÑ±¹¾î" size="15" maxlength="15" class="input_data1" readOnly>
		</td>
		<!-- 2011.3.24 solarb ±¸¸Å±×·ì Ç×¸ñ hidden  display:none  Áö¿ªtd colspan="3" -->
		<td class="c_title_1" style="display:none"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ±¸¸Å±×·ì</td>
		<td class="c_data_1"  style="display:none">
			<input type="text" name="ctrl_code" size="15" maxlength="5" class="inputsubmit" id="g2">
			<a href="javascript:SP0216_Popup();" id="g4">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" id="g3" alt="">
			</a>
		</td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="c_title_1" width="18%" colspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÀüÈ­¹øÈ£</td>
		<td class="c_data_1"  width="32%">
			<input type="text" name="phone_no1" size="3" maxlength="3" class="input_re" onKeyUp="return chkMaxByte(5, this, 'ÀüÈ­¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="phone_no2" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(7, this, 'ÀüÈ­¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="phone_no3" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(8, this, 'ÀüÈ­¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
		<td class="c_title_1" width="18%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÆÑ½º¹øÈ£</td>
		<td class="c_data_1"  width="32%">
			<input type="text" name="fax_no1" size="3" maxlength="3" class="inputsubmit" onKeyUp="return chkMaxByte(5, this, 'ÆÑ½º¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="fax_no2" size="4" maxlength="4" class="inputsubmit" onKeyUp="return chkMaxByte(7, this, 'ÆÑ½º¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="fax_no3" size="4" maxlength="4" class="inputsubmit" onKeyUp="return chkMaxByte(8, this, 'ÆÑ½º¹øÈ£');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
	</tr>
	<tr>
		<td class="c_title_1" colspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÈÞ´ëÆù</td>
		<td class="c_data_1">
			<input type="text" name="mobile_no1" size="3" maxlength="3" class="input_re" onKeyUp="return chkMaxByte(5, this, 'ÈÞ´ëÆù');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="mobile_no2" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(7, this, 'ÈÞ´ëÆù');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="mobile_no3" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(8, this, 'ÈÞ´ëÆù');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
		<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÀÌ¸ÞÀÏ</td>
		<td class="c_data_1">
			<input type="text" name="email" size="30" maxlength="50" class="input_re" onKeyUp="return chkMaxByte(50, this, 'ÀÌ¸ÞÀÏ');">
		</td>
	</tr>
	<tr>
		<td class="c_title_1" rowspan="2"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ÁÖ ¼Ò</td>
		<td class="c_title_1">±âº»ÁÖ¼Ò</td>
		<td class="c_data_1" colspan="3">
			<input type="hidden" name="zip_code" value="">
			<input type="text" name="zip_code1" value="" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '¿ìÆí¹øÈ£1');">
			<input type="text" name="zip_code2" value="" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '¿ìÆí¹øÈ£2');">
			<a href="javascript:SP0274_Popup()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
			<br>
			<input type="text" name="address_loc" value="" size="96" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(100, this, '±âº»ÁÖ¼Ò');">
		</td>
	</tr>
	<tr>
		<td class="c_title_1">¹è¼ÛÁöÁÖ¼Ò</td>
		<td class="c_data_1" colspan="3">
			<input type="hidden" name="dely_zip_code" value="">
			<input type="checkbox" name="dely_flag" onclick="javascript:addrChecked()" class="input_re"> <b>±âº»ÁÖ¼Ò¿Í µ¿ÀÏ</b>
			<br>
			<input type="text" name="dely_zip_code1" value="" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '¹è¼ÛÁö ¿ìÆí¹øÈ£1');">
			<input type="text" name="dely_zip_code2" value="" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '¹è¼ÛÁö ¿ìÆí¹øÈ£2');">
			<a href="javascript:SP0274_Popup('Y')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
			<br>
			<input type="text" name="dely_address_loc" value="" size="96" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(100, this, '¹è¼ÛÁö ÁÖ¼Ò');">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
		<TABLE cellpadding="0">
     		<TR>
				<TD><script language="javascript">btn("javascript:operatingSave()",6,"»ç¿ëÀÚµî·Ï")</script></TD>
   	  		</TR>
		</TABLE>
  		</td>
	</tr>
</table>

</form>
</body>
</html>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>


