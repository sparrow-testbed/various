<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String house_code = info.getSession("HOUSE_CODE");
	String i_flag            = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("i_flag")));
	String i_user_id         = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("i_user_id")));
	String user_flag         = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("user_flag")));
	String totalCnt 		 = JSPUtil.nullToEmpty(request.getParameter("totalCnt"));
	
	String G_IMG_ICON = "/images/ico_zoom.gif"; 
	
	// 접속가능 최대 사용자수
	Configuration sepoa_conf = new Configuration();
	String maxCnt = "0";
    try {
    	maxCnt = sepoa_conf.getString("sepoa.max.user." + info.getSession("HOUSE_CODE"));
    } catch (Exception e) {
    	maxCnt = "0";
    }

	String password                = "" ;
	String user_name_loc           = "" ;
	String user_name_eng           = "" ;
	String company_name_loc        = "" ;
	String resident_no             = "" ;
	String employee_no             = "" ;
	String phone_no                = "" ;
	String email                   = "" ;
	String mobile_no               = "" ;
	String fax_no                  = "" ;
	String position_name           = "" ;
	String language_name           = "" ;
	String time_zone               = "" ;
	String zip_code                = "" ;
	String zip_code1               = "" ;
	String zip_code2               = "" ;
	String dely_zip_code           = "" ;
	String dely_zip_code1          = "" ;
	String dely_zip_code2          = "" ;
	String country_name            = "" ;
	String city_name               = "" ;
	String state                   = "" ;
	String address_loc             = "" ;
	String dely_address_loc        = "" ;
	String address_eng             = "" ;
	String pr_location_name        = "" ;
	String dept                    = "" ;
	String position                = "" ;
	String city_code               = "" ;
	String pr_location             = "" ;
	String company_code            = "" ;
	String language                = "" ;
	String country                 = "" ;
	String menu_profile_code       = "" ;
	String menu_profile_name       = "" ;
	String manager_position        = "" ;
	String manager_position_name   = "" ;
	String user_type               = "" ;
	String text_user_type          = "" ;
	String work_type               = "" ;
	String text_work_type          = "" ;
	String ctrl_code               = "" ;
	String time_zone_name          = "" ;
	String dept_name_loc           = "" ;
	String loginNcy				   = "" ; // 로그인 가능여부

	//System.out.println("i_user_id:"+i_user_id);

	if( i_user_id != "" )
	{
		String[] args = {i_user_id};
		Object[] obj = {(Object[])args};
		SepoaOut value = ServiceConnector.doService(info, "p0030", "CONNECTION","getDisplay", obj);
		//System.out.println("value:"+value.status);

		if(value.status == 1)
		{
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			if ( wf.getRowCount() > 0 )
			{
				password                = wf.getValue("PASSWORD"             , 0) ;
				user_name_loc           = wf.getValue("USER_NAME_LOC"        , 0) ;
				user_name_eng           = wf.getValue("USER_NAME_ENG"        , 0) ;
				company_name_loc        = wf.getValue("COMPANY_NAME_LOC"     , 0) ;
				resident_no             = wf.getValue("RESIDENT_NO"          , 0) ;
				employee_no             = wf.getValue("EMPLOYEE_NO"          , 0) ;
				phone_no                = wf.getValue("PHONE_NO"             , 0) ;
				email                   = wf.getValue("EMAIL"                , 0) ;
				mobile_no               = wf.getValue("MOBILE_NO"            , 0) ;
				fax_no                  = wf.getValue("FAX_NO"               , 0) ;
				position_name           = wf.getValue("POSITION_NAME"        , 0) ;
				language_name           = wf.getValue("LANGUAGE_NAME"        , 0) ;
				time_zone               = wf.getValue("TIME_ZONE"            , 0) ;
				zip_code           		= wf.getValue("ZIP_CODE"             , 0) ;
				if (zip_code != null && zip_code != "" && zip_code.length() == 6) {
					zip_code1           = zip_code.substring(0,3);
					zip_code2           = zip_code.substring(3,6);
				} else {
					zip_code1           = "";
					zip_code2           = "";
				}
				dely_zip_code      		= wf.getValue("DELY_ZIP_CODE"         , 0);
				if (dely_zip_code != null && dely_zip_code != "" && dely_zip_code.length() == 6) {
					dely_zip_code1      = dely_zip_code.substring(0,3);
					dely_zip_code2      = dely_zip_code.substring(3,6);
				} else {
					dely_zip_code1      = "";
					dely_zip_code1      = "";
				}
				address_loc             = wf.getValue("ADDRESS_LOC"          , 0) ;
				dely_address_loc        = wf.getValue("DELY_ADDRESS_LOC"     , 0) ;
				address_eng             = wf.getValue("ADDRESS_ENG"          , 0) ;
				country_name            = wf.getValue("COUNTRY_NAME"         , 0) ;
				city_name               = wf.getValue("CITY_NAME"            , 0) ;
				state                   = wf.getValue("STATE"                , 0) ;
				pr_location_name        = wf.getValue("PR_LOCATION_NAME"     , 0) ;
				position                = wf.getValue("POSITION"             , 0) ;
				city_code               = wf.getValue("CITY_CODE"            , 0) ;
				pr_location             = wf.getValue("PR_LOCATION"          , 0) ;
				company_code            = wf.getValue("COMPANY_CODE"         , 0) ;
				language                = wf.getValue("LANGUAGE"             , 0) ;
				country                 = wf.getValue("COUNTRY"              , 0) ;
				menu_profile_code       = wf.getValue("MENU_PROFILE_CODE"    , 0) ;
				menu_profile_name       = wf.getValue("MENU_PROFILE_NAME"    , 0) ;
				manager_position        = wf.getValue("MANAGER_POSITION"     , 0) ;
				manager_position_name   = wf.getValue("MANAGER_POSITION_NAME", 0) ;
				user_type               = wf.getValue("USER_TYPE"            , 0) ;
				text_user_type          = wf.getValue("TEXT_USER_TYPE"       , 0) ;
				work_type               = wf.getValue("WORK_TYPE"            , 0) ;
				text_work_type          = wf.getValue("TEXT_WORK_TYPE"       , 0) ;
				ctrl_code               = wf.getValue("CTRL_CODE"            , 0) ;
				time_zone_name          = wf.getValue("TIME_ZONE_NAME"       , 0) ;
				dept_name_loc           = wf.getValue("DEPT_NAME_LOC"      	 , 0) ;
				dept                    = wf.getValue("DEPT"               	 , 0) ;
				loginNcy                = wf.getValue("LOGIN_NCY"          	 , 0) ;
			}
		}
	}

	String LB_USER_TYPE = ListBox(request, "SL0081",  house_code+"#"+house_code+"#", user_type);
	String LB_WORK_TYPE = ListBox(request, "SL0007",  house_code+"#M104#", work_type);
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="/include/include_css.jsp"%>
	<%-- Dhtmlx SepoaGrid용 JSP--%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
	<%-- Ajax SelectBox용 JSP--%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript" type="text/javascript">
<!--
var G_HOUSE_CODE = "<%=house_code%>";
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
	var checkCode = f.user_id.value;
	
	if(!checkEmpty(f.login_ncy,"접속 가능여부를 선택해 주십시요."))
		return false;

	if(!checkEmpty(f.login_ncy,"접속 가능여부를 선택해 주십시요."))
		return false;

	if(!checkEmpty(f.user_type,"사용자 구분을 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.work_type,"업무 권한을 입력해 주십시요."))
		return false;

	if(!checkEmpty(f.user_id, "사용자 아이디를 입력하셔야 합니다."))
		return false;

	if(!checkEmpty(f.login_ncy, "사용자 아이디를 입력하셔야 합니다."))
		return false;
	
	if(!checkEmpty(f.user_name_loc, "사용자명(국문)을 입력해 주십시요."))
		return false;

	if(!checkKorea(f.user_name_loc, "사용자명(국문)은 40자 이내입니다.",40))
		return false;

	if(!checkKorea(f.user_name_eng, "사용자명(영문)은 40자 이내입니다.",40))
		return false;

<%if(!user_type.equals("S")){%>
	if(!checkKorea(f.company_code, "회사코드는 10자 이내입니다.",10))
		return false;

	if(!checkEmpty(f.company_code, "회사코드를 선택해 주십시요."))
		return false;

	if(!checkEmpty(f.dept, "부서코드를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.dept, "부서코드는 10자 이내입니다.",10))
		return false;

	if(!checkEmpty(f.employee_no, "사원번호를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.employee_no, "사원번호 10자 이내입니다.",10))
		return false;

	if(!checkEmpty(f.pr_location, "청구지역을 입력해 주십시요."))
		return false;
	/*
	var dely_zip_code = f.dely_zip_code1.value + f.dely_zip_code2.value;
	f.dely_zip_code.value = dely_zip_code;
	
	if(!checkEmpty(f.dely_zip_code1,"배송지 우편번호를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.dely_zip_code, "배송지 우편 번호는 10자 이내입니다.",10))
		return false;
	
	if(!checkEmpty(f.dely_address_loc,"배송지 주소를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.dely_address_loc, "배송지 주소는 200자 이내입니다.", 200))
		return false;
	*/
<%}%>
	
	if(!checkKorea(f.language, "사용언어는 5자 이내입니다.",5))
		return false;

	if(!checkEmpty(f.language, "사용언어를 선택해 주십시요."))
		return false;
	
	if(!checkKorea(f.country, "국가는 2자 이내입니다.",2))
		return false;
	
	if(!checkEmpty(f.country, "국가를 선택해 주십시요."))
		return false;
	
	if(!checkKorea(f.city_code, "도시는 10자 이내입니다.", 10))
		return false;
	
	if(!checkKorea(f.state, "지역은 20자 이내입니다.", 20))
		return false;
	
	if(!checkEmpty(f.phone_no_1, "전화번호를 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.phone_no_2, "전화번호를 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.phone_no_3, "전화번호를 입력해 주십시요."))
		return false;
	
	if(!checkTel(f.phone_no_1, "전화번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.phone_no_2, "전화번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.phone_no_3, "전화번호 형태로 입력해 주십시요."))
		return false;
	
	if(!checkTel(f.fax_no_1, "팩스번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.fax_no_2, "팩스번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.fax_no_3, "팩스번호 형태로 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.mobile_no_1, "휴대폰번호를 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.mobile_no_2, "휴대폰번호를 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.mobile_no_3, "휴대폰번호를 입력해 주십시요."))
		return false;
	
	if(!checkTel(f.mobile_no_1, "휴대폰번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.mobile_no_2, "휴대폰번호 형태로 입력해 주십시요."))
		return false;

	if(!checkTel(f.mobile_no_3, "휴대폰번호 형태로 입력해 주십시요."))
		return false;
	
	if(!checkEmpty(f.email, "이메일 주소를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.email, "이메일은 50자 이내입니다.",50))
		return false;

	
	var zip_code = f.zip_code1.value + f.zip_code2.value;
	f.zip_code.value = zip_code;
	/*
	if(!checkEmpty(f.zip_code1,"기본 우편번호를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.zip_code, "기본 우편 번호는 10자 이내입니다.",10))
		return false;

	if(!checkEmpty(f.address_loc,"기본주소를 입력해 주십시요."))
		return false;
	
	if(!checkKorea(f.address_loc, "기본주소는 200자 이내입니다.", 200))
		return false;
	*/
	//if(!checkKorea(f.address_eng, "주소(영문)은 200자 이내입니다.", 200))
	//	return false;
	
	return true;
}

function Save()
{
	var f = document.forms[0];

	var password = f.password.value;
	var password2 = f.password2.value;

	//접속허용인원에 대해서만 체크한다.
	if(f.login_ncy.value = "Y"){
		if(parseInt('<%=maxCnt%>') == parseInt('<%=totalCnt%>')){
			alert("로그인가능ID 갯수는 최대 "+ '<%=maxCnt%>'+"입니다.\n현재 등록한 로그인ID 갯수는 "+'<%=totalCnt%>'+"입니다");
			return;
		}	
	}
	
	if(password != "") {
		if(password2 == "") {
			alert("새 패스워드를 한번 더 넣어주세요");
			return;
		}else {
			if(password != password2) {
				alert("새 패스워드 두개가 일치하지 않습니다.");
				return;
			}
		}

    	if(!(document.form.password.value == document.form.password2.value) ) {
            alert("비밀번호가 일치하지 않습니다.");
            document.form.password.focus();
            document.form.password.select();
            return ;
        }

        if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
            alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(1)");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            return ;
        }

        if(!chkMixing(document.forms[0].password.value)) {
            alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(2)");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            return ;
        }

        if(!chkIdIsEquals(document.forms[0].password.value)) {
            alert("비밀번호는 ID가 포함되어 있으면 안됩니다.(3)");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            return ;
        }

        if(!chkInputRepeat(document.forms[0].password.value)) {
            alert("비밀번호는 같은 문자를 3번 이상 반복 입력할 수 없습니다.(4)");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            return ;
        }
	}

	if(!checkData()) return;

	if(!confirm("수정하시겠습니까?"))
		return;

	f.language.disabled 			= false;
	f.language_name.disabled 		= false;
	f.pr_location.disabled 			= false;
	f.text_pr_location.disabled 	= false;
	f.zip_code1.disabled 			= false;
	f.zip_code2.disabled 			= false;
	f.dely_zip_code1.disabled 		= false;
	f.dely_zip_code2.disabled 		= false;
	f.time_zone.disabled 			= false;
	f.text_time_zone.disabled 		= false;
	f.country.disabled 				= false;
	f.country_name.disabled 		= false;
	f.city_code.disabled 			= false;
	f.text_city_code.disabled 		= false;
	f.state.disabled 				= false;

	f.method = "POST";
	f.target = "childFrame";
	f.action = "use_wk_upd2.jsp";
	f.submit();
}

function Check() {
	var f = document.forms[0];
	f.i_flag.value = '<%=i_flag%>';
	f.i_chk_user_id.value = f.i_chk_user_id.value.toUpperCase();
	var i_user_id = f.i_chk_user_id.value;
	var i_passwd = f.i_chk_passwd.value;

	if(i_user_id == "") {
		alert("아이디를 입력해주세요..");
		return;
	}else {
		if(i_passwd == "") {
			alert("패스워드를 입력해주세요..");
			return;
		}
	}

	if(i_user_id != "" && i_passwd != "")
		parent.work.location.href="/kr/master/user/use_wk_chk2.jsp?i_user_id="+ i_user_id+"&i_passwd="+i_passwd;
}


function getCity(code, text) {
	document.forms[0].city_code.value = code;
	document.forms[0].text_city_code.value = text;
}

function getDept(code, text) {
	document.forms[0].dept.value = code;
	document.forms[0].text_dept.value = text;
}

function getPosition(code, text) {
	document.forms[0].position.value = code;
	document.forms[0].text_position.value = text;
}

function getPr(code, text) {
	document.forms[0].pr_location.value = code;
	document.forms[0].text_pr_location.value = text;
}

function getmanagerPosition(code,text){
	document.forms[0].manager_position.value = code;
	document.forms[0].text_manager_position.value = text;
}

function getPartner_code(code,text, type) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code2.value = code;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code2.value = code;
}

function getLanguage(code,text) {
	document.forms[0].language.value = code;
	document.forms[0].language_name.value = text;
}

function getCountry(code,text) {
	document.forms[0].country.value = code;
	document.forms[0].country_name.value = text;
}

function getTimeZone(code,text) {
	document.forms[0].time_zone.value = code;
	document.forms[0].text_time_zone.value = text;
}

function actionedit()
{
	var f = document.forms[0];
	user_type = f.user_type.value;
	text_user_type = f.user_type.options[f.user_type.selectedIndex].text;
	
	alert('user_type : ' + user_type);
	alert('text_user_type : ' + text_user_type);

	if ( user_type == "P" || user_type == "S" ) {
		f.edit.value = "Y";
		f.company_code.value = user_type;
		f.text_company_code2.value = "";
	} else {
		f.company_code.value = user_type;
		f.text_company_code2.value = user_type;
		f.edit.value = "N";
	}

	if ( user_type == "CJ00" ) {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "visible";
			if(n>1) document.all["g"+n].disabled = "false";
		}
	}
	else {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "hidden";
			if(n>1) document.all["g"+n].disabled = "true";
		}
	}

	<%if(!user_type.equals("S")){%>
		f.dept.value = "";
		f.text_dept.value = "";
	<% } %>
	f.position.value = "";
	f.text_position.value = "";
	f.manager_position.value = "";
	f.text_manager_position.value = "";
	f.ctrl_code.value = "";
	f.ctrl_code_data.value = "";
}

function getprofile() {
	var dim = new Array(2);

	dim = ToCenter('600','800');
	var top = dim[0];
	var left = dim[1];
	var url = "/kr/admin/system/mu1_bd_ins3.jsp?flag=Y";

	Code_Search(url,'','','','800','600');
}

function Setprofile(code,name) {
	var f = document.forms[0];
	f.menu_profile_code.value = code;
	f.menu_name.value = name;
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
			alert("사용자 구분을 먼저 선택해야 합니다.");
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
		if(!checkEmpty(f.country,"국가를 먼저 선택해야 합니다."))
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
			if(!checkEmpty(f.company_code,"회사단위를 먼저 선택해야 합니다."))
				return;
			PopupCommon2("SP0022", "getDept", G_HOUSE_CODE,f.company_code.value, "코드","부서명");
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
			if(!checkEmpty(f.company_code,"회사단위를 먼저 선택해야 합니다."))
				return;

			var arr = new Array(G_HOUSE_CODE, f.company_code.value, "C002");
			PopupCommonArr("SP9029", "getPosition", arr, "", "");
		}
	}
	else if(part == "manager_posi")
			PopupCommon2("SP9053", "getmanagerPosition", G_HOUSE_CODE,"M107", "","");
	else if(part == "language")
		PopupCommon2("SP9053", "getLanguage", G_HOUSE_CODE,"M013", "","");
	else if(part == "country")
		PopupCommon2("SP9053", "getCountry", G_HOUSE_CODE,"M001", "","");
	else if(part == "time_zone")
		PopupCommon2("SP9001", "getTimeZone", G_HOUSE_CODE,"M075", "","");

}

function  SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_code_data.value = ls_ctrl_code;
}

function checkCtrl_code()
{
	var f = document.forms[0];

	if("<%=phone_no%>".length == 9){
		f.phone_no_1.value = "<%=phone_no%>".substring(0,2);
		f.phone_no_2.value = "<%=phone_no%>".substring(2,5);
		f.phone_no_3.value = "<%=phone_no%>".substring(5,9);
	} else if("<%=phone_no%>".length == 10){
		if("<%=phone_no%>".substring(0,2) == "02"){
			f.phone_no_1.value = "<%=phone_no%>".substring(0,2);
			f.phone_no_2.value = "<%=phone_no%>".substring(2,6);
			f.phone_no_3.value = "<%=phone_no%>".substring(6,10);
		}else{
			f.phone_no_1.value = "<%=phone_no%>".substring(0,3);
			f.phone_no_2.value = "<%=phone_no%>".substring(3,6);
			f.phone_no_3.value = "<%=phone_no%>".substring(6,10);
		}

	} else if("<%=phone_no%>".length > 10){
		f.phone_no_1.value = "<%=phone_no%>".substring(0,3);
		f.phone_no_2.value = "<%=phone_no%>".substring(3,7);
		f.phone_no_3.value = "<%=phone_no%>".substring(7);
	}

	if("<%=mobile_no%>".length == 10){
		f.mobile_no_1.value = "<%=mobile_no%>".substring(0,3);
		f.mobile_no_2.value = "<%=mobile_no%>".substring(3,6);
		f.mobile_no_3.value = "<%=mobile_no%>".substring(6,10);
	} else if("<%=mobile_no%>".length == 11){
		f.mobile_no_1.value = "<%=mobile_no%>".substring(0,3);
		f.mobile_no_2.value = "<%=mobile_no%>".substring(3,7);
		f.mobile_no_3.value = "<%=mobile_no%>".substring(7,11);
	}

	if("<%=fax_no%>".length == 9){
		f.fax_no_1.value = "<%=fax_no%>".substring(0,2);
		f.fax_no_2.value = "<%=fax_no%>".substring(2,5);
		f.fax_no_3.value = "<%=fax_no%>".substring(5,9);
	} else if("<%=fax_no%>".length == 10){
		f.fax_no_1.value = "<%=fax_no%>".substring(0,3);
		f.fax_no_2.value = "<%=fax_no%>".substring(3,6);
		f.fax_no_3.value = "<%=fax_no%>".substring(6,10);
	} else if("<%=fax_no%>".length > 10){
		f.fax_no_1.value = "<%=fax_no%>".substring(0,3);
		f.fax_no_2.value = "<%=fax_no%>".substring(3,7);
		f.fax_no_3.value = "<%=fax_no%>".substring(7);
	}

	var f = document.forms[0];
	if ( "<%=company_code %>" == "CJ00" ) {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "visible";
			if(n>1) document.all["g"+n].disabled = "false";
		}
	} else {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "hidden";
			if(n>1) document.all["g"+n].disabled = "true";
			f.ctrl_code.value = "";
			f.ctrl_code_data.value = "";
		}
	}

	var f = document.forms[0];
	if ( "<%=company_code %>" == "1000" ) {
		<%if(!"Y".equals(user_flag)){%>
			f.password.disabled = true;
			f.password2.disabled = true;
		<%}%>
	}

	f.language.disabled 			= true;
	f.language_name.disabled 		= true;
	f.pr_location.disabled 			= true;
	f.text_pr_location.disabled 	= true;
	f.zip_code1.disabled 			= true;
	f.zip_code2.disabled 			= true;
	f.dely_zip_code1.disabled 		= true;
	f.dely_zip_code2.disabled 		= true;
	f.time_zone.disabled 			= true;
	f.text_time_zone.disabled 		= true;
	f.country.disabled 				= true;
	f.country_name.disabled 		= true;
	f.city_code.disabled 			= true;
	f.text_city_code.disabled 		= true;
	f.state.disabled 				= true;
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
		f.dely_zip_code1.value = f.tmp_zip_code1.value;
		f.dely_zip_code2.value = f.tmp_zip_code2.value;
		f.dely_address_loc.value = f.tmp_address_loc.value;
	}
}

function setCookie( name, value, expiredays ) {
    var todayDate = new Date();
    todayDate.setDate( todayDate.getDate() + expiredays );
    document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function closeWin() {
    if (document.forms[0].Notice.checked) {
      setCookie( "userInfo_notice", "done" , 1);
    } else {
      setCookie( "userInfo_notice", "1" , 1);
    }
    parent.window.close();
}

//-->
</Script>
</head>

<body bgcolor="#FFFFFF" text="#000000" onload="checkCtrl_code();">
<form name="form" action="">
	<input type="hidden" name="program" value="use_bd_upd2">
	<input type="hidden" name="edit" value="Y">
<table width="99%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td class='title_page' height="20" align="left" valign="bottom">
			사용자 정보수정
		</td>
	</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<%
if("Y".equals(user_flag)){
%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr style="display: none;">
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 구분</td>
		<td class="data_td"  width="30%">
			<select name="user_type" class="input_re" onChange="actionedit();" >
				<option>:::선택:::</option>
				<%=LB_USER_TYPE%>
			</select>
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업무권한</td>
		<td class="data_td" width="30%" >
			<select name="work_type" class="input_re">
				<option>:::선택:::</option>
				<%=LB_WORK_TYPE%>
			</select>
		</td>
	</tr>
	<%
	if(!user_type.equals("S")) {
	%>
	<tr style="display: none;">
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사코드</td>
		<td class="data_td" colspan="3">
			<select name="company_code" class="input_re">
				<option value="">:::선택:::</option>
				<%
				String lb = ListBox(request, "SL0006" ,house_code+"#", company_code);
				out.println(lb);
				%>
			</select>
		</td>
	</tr>
	<%
	} else {
	%>
	<input type="hidden" name="company_code" value="<%=company_code%>" >
	<%
	}
	%>
</table>
<br>
<%
} else {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 구분</td>
		<td class="data_td"  width="30%">
			<select name="user_type" class="input_re" onChange="actionedit();">
				<option>:::선택:::</option>
				<%=LB_USER_TYPE%>
			</select>
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업무권한</td>
		<td class="data_td"  width="30%">
			<select name="work_type" class="input_re">
				<option>:::선택:::</option>
				<%=LB_WORK_TYPE%>
			</select>
		</td>
	</tr>
	<%
	if(!user_type.equals("S")){
	%>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사코드</td>
		<td class="data_td" colspan="3">
			<select name="company_code" class="input_re">
				<option value="">:::선택:::</option>
				<%
				String lb = ListBox(request, "SL0006" ,house_code+"#", company_code);
				out.println(lb);
				%>
			</select>
		</td>
	</tr>
	<%
	} else {
	%>
	<input type="hidden" name="company_code" value="<%=company_code%>" >
	<%
	}
	%>
</table>
<br>
<%
}
%>

<%
if(i_flag.equals("P"))  {
%>
<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 ID<br></td>
		<td class="data_td"  width="30%">
			<input type="text" name="i_chk_user_id" value="" size="20" class="inputsubmit">
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비밀번호<br></td>
		<td class="data_td"  width="30%">
			<input type="password" name="i_chk_passwd" value="" size="20" class="inputsubmit">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
			<TABLE cellpadding="0">
			<TR>
				<TD><script language="javascript">btn("javascript:Check()","조 회")</script></TD>
			</TR>
			</TABLE>
		</td>
	</tr>
</table>
<br>
<%
}
%>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
<%
	//********접속가능여부 수정은 전체admin 및 업체admin만 수정가능***********************************
	boolean admin_flag = false;
	String admin_menu_profile_code = "";
	String user_menu_profile_code = info.getSession("MENU_TYPE");
	
	try {
		admin_menu_profile_code = sepoa_conf.getString("sepoa.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		if (user_menu_profile_code.equals(admin_menu_profile_code))
			admin_flag = true;
		if (!admin_flag) {
			admin_menu_profile_code = sepoa_conf.getString("sepoa.admin.profile_code."+info.getSession("HOUSE_CODE"));
			if (user_menu_profile_code.equals(admin_menu_profile_code))
				admin_flag = true;
		}
	} catch (Exception e) {
		admin_flag = false;
	}
	
	//********접속가능여부 수정은 전체admin 및 업체admin만 수정가능***********************************
	if (admin_flag) {
%>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 ID</td>
		<td class="data_td"><%=i_user_id%>
			<input type="hidden" name="user_id" value="<%=i_user_id%>">
			<input type="hidden" name="old_pwd" value="">
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;접속가능여부</td>
		<td class="data_td">
			<select id="login_ncy" name="login_ncy" class="input_re">
				<option value="" <%=loginNcy == null || loginNcy.equals("") ? "selected" : "" %>>:::선택:::</option>
				<option value="Y" <%=loginNcy.equals("Y") ? "selected" : "" %>>가능</option>
				<option value="N" <%=loginNcy.equals("N") ? "selected" : "" %>>불가</option>
			</select>
		</td>
	</tr>
<%
} else {
%>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자 ID</td>
		<td class="data_td" colspan="3"><%=i_user_id%>
			<input type="hidden" name="user_id" value="<%=i_user_id%>">
			<input type="hidden" name="old_pwd" value="">
			<input type="hidden" name="login_ncy" value="<%=loginNcy%>">
		</td>
	</tr>
<%
}
%>
	<tr>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자명(국문)</td>
		<td class="data_td"  width="30%">
			<input type="text" name="user_name_loc" value="<%=user_name_loc%>" size="20" maxlength="40" class="inputsubmit" readOnly onKeyUp="return chkMaxByte(20, this, '사용자명(국문)');">
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자명(영문)</td>
		<td class="data_td"  width="30%">
			<input type="text" name="user_name_eng" value="<%=user_name_eng%>" size="20" maxlength="40" class="input_re" onKeyUp="return chkMaxByte(40, this, '사용자명(영문)');">
		</td>
	</tr>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;새비밀번호</td>
		<td class="data_td" >
			<input type="password" name="password"  value="" size="15" maxlength="100" class="input_re" onKeyUp="return chkMaxByte(10, this, '새비밀번호');">
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;새비밀번호확인</td>
		<td class="data_td">
			<input type="password" name="password2" value="" size="15" maxlength="100" class="input_re" onKeyUp="return chkMaxByte(10, this, '새비밀번호확인');">
		</td>
	</tr>
	<%
	if(!user_type.equals("S")){
	%>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부 서</td>
		<td class="data_td" >
			<input type="text" name="dept" value="<%=dept%>" size="5" maxlength="10" class="input_re" readOnly>
<!-- 			<a href="javascript:searchProfile('dept')"> 
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
 			</a> -->
			<input type="text" name="text_dept" value="<%=dept_name_loc%>" size="20" class="input_data1" readOnly>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사원번호</td>
		<td class="data_td" <%if(user_type.equals("S")){ out.println("colspan='3'");}%>>
			<input type="text" name="employee_no" value="<%=employee_no%>" <%="Y".equals(user_flag) ? "readOnly" : "" %> size="20" maxlength="10" class="inputsubmit" onKeyUp="return chkMaxByte(20, this, '사원번호');">
		</td>
		<input type="hidden" name="text_company_code2" value="<%=company_code%>">
	</tr>
	<%
	}
	%>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;직 위</td>
		<td class="data_td" colspan="3">
			<input type="text" name="position" value="<%=position%>" size="5" maxlength="10" class="inputsubmit" readOnly>
			<a href="javascript:searchProfile('posi')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="text_position" value="<%=position_name%>" size="20" maxlength="200" class="input_data1" readOnly>
		</td>
		<td class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;직 책</td>
		<td class="data_td"  style="display:none;">
			<input type="text" name="manager_position" value="<%=manager_position%>" size="5" maxlength="10" class="inputsubmit" readOnly>
			<a href="javascript:searchProfile('manager_posi')">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="text_manager_position" value="<%=manager_position_name%>" size="20" class="input_data1" readOnly>
		</td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;국 가</td>
		<td class="data_td">
			<input type="text" name="country" value="<%=country%>" size="5" class="inputsubmit" readOnly>
			<input type="text" name="country_name" value="<%=country_name%>" size="15" maxlength="15" class="input_data1" readOnly>
		</td>
		<td class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;도 시<br></td>
		<td class="data_td" style="display:none;">
			<input type="text" name="city_code" value="<%=city_code%>" size="5" maxlength="10" class="inputsubmit" readOnly>
			<input type="text" name="text_city_code" value="<%=city_name%>" size="20" maxlength="200" class="input_data1" readOnly>
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용언어</td>
		<td class="data_td" >
			<input type="text" name="language" value="<%=language%>" size="5" class="inputsubmit" readOnly>
			<input type="text" name="language_name" value="<%=language_name%>" size="15" maxlength="15" class="input_data1" readOnly>
		</td>
	</tr>
	<tr>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;시간대역</td>
		<td class="data_td"  width="30%">
			<input type="text" name="time_zone" value="<%=time_zone%>" size="5" maxlength="10" class="inputsubmit" readOnly>
			<input type="text" name="text_time_zone" value="<%=time_zone_name%>" size="20" class="input_data1" readOnly>
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지역(only U.S.A)</td>
		<td class="data_td"  width="30%">
			<input type="text" name="state" value="<%=state%>" size="20" maxlength="20" class="inputsubmit" onKeyUp="return chkMaxByte(200, this, '지역(only U.S.A)');">
		</td>
	</tr>
	<tr style="display:none;">
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;청구지역</td>
		<td class="data_td"  width="30%">
			<input type="text" name="pr_location" value="01" size="5" maxlength="10" class="inputsubmit" readOnly>
			<input type="text" name="text_pr_location" value="<%=pr_location_name%>" size="20" class="input_data1" readOnly>
		</td>		
	</tr>
	<tr style="display:none">
		<td class="title_td">
			<span id="g1">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매그룹</span>
		</td>
		<td class="data_td" >
			<input type="text" name="ctrl_code_data" size="5" maxlength="3" class="inputsubmit" id="g2" value="<%=ctrl_code%>">
			<input type="hidden" name="ctrl_code" size="5" maxlength="3" class="inputsubmit" value="<%=ctrl_code%>">
			<a href="javascript:SP0216_Popup();" id="g4">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" id="g3" alt="">
			</a>
		</td>
	</tr>
</table>

<br>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
	<tr>
		<td class="title_td" width="20%" colspan="2">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사 전화번호</td>
		<td class="data_td"  width="30%">
			<input type="text" name="phone_no_1" value="" size="3" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(5, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="phone_no_2" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(7, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="phone_no_3" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(8, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
		<td class="title_td" width="20%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;팩스번호</td>
		<td class="data_td"  width="30%">
			<input type="text" name="fax_no_1" value="" size="3" maxlength="3" class="input_re" onKeyUp="return chkMaxByte(5, this, '팩스번호');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="fax_no_2" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(7, this, '팩스번호');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="fax_no_3" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(8, this, '팩스번호');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
	</tr>
	<tr>
		<td class="title_td" colspan="2">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;휴대폰번호</td>
		<td class="data_td">
			<input type="text" name="mobile_no_1" value="" size="3" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(5, this, '휴대폰');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="mobile_no_2" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(7, this, '휴대폰');" onKeyPress="return onlyNumber(event.keyCode);"> -
			<input type="text" name="mobile_no_3" value="" size="4" maxlength="4" class="input_re" onKeyUp="return chkMaxByte(8, this, '휴대폰');" onKeyPress="return onlyNumber(event.keyCode);">
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;이메일</td>
		<td class="data_td">
			<input type="text" name="email" value="<%=email%>" size="30" maxlength="50" class="input_re" onKeyUp="return chkMaxByte(50, this, '이메일');">
		</td>
	</tr>
	<%
	if(!user_type.equals("S")){
	%>
	<tr>
		<td class="title_td"  colspan="2">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;현 근무지</td>
<!-- 		<td class="title_td">기본주소</td> -->
		<td class="data_td" colspan="3">
			<input type="hidden" name="zip_code" value="">
			<input type="text" name="zip_code1" value="<%=zip_code1%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '우편번호1');">
			<input type="text" name="zip_code2" value="<%=zip_code2%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '우편번호2');">
			<a href="javascript:SP0274_Popup()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
			<br>
			<input type="text" name="address_loc" value="<%=address_loc%>" size="96" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(100, this, '기본주소');">
		</td>
	</tr>
	<tr style="display:none;">
		<td class="title_td" colspan="2">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;배송지주소</td>
		<td class="data_td" colspan="3">
			<input type="hidden" name="dely_zip_code" value="">
			<input type="checkbox" name="dely_flag" onclick="javascript:addrChecked()" class="input_re"> <b>기본주소와 동일</b>
			<br>
			<input type="text" name="dely_zip_code1" value="<%=dely_zip_code1%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '배송지 우편번호1');">
			<input type="text" name="dely_zip_code2" value="<%=dely_zip_code2%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '배송지 우편번호2');">
			<a href="javascript:SP0274_Popup('Y')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
			<br>
			<input type="text" name="dely_address_loc" value="<%=dely_address_loc%>" size="96" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(100, this, '배송지 주소');">
			<input type="hidden" name="tmp_zip_code1" value="<%=dely_zip_code1%>">
			<input type="hidden" name="tmp_zip_code2" value="<%=dely_zip_code2%>">
			<input type="hidden" name="tmp_address_loc" value="<%=dely_address_loc%>">
		</td>
	</tr>
	<%
	} else {
	%>
	<tr>
		<td class="title_td" colspan="2">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기본주소</td>
		<td class="data_td"  colspan="3">
			<input type="hidden" name="zip_code" value="">
			<input type="text" name="zip_code1" value="<%=zip_code1%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '우편번호1');">
			<input type="text" name="zip_code2" value="<%=zip_code2%>" size="5" maxlength="5" class="input_re" onKeyUp="return chkMaxByte(5, this, '우편번호2');">
			<a href="javascript:SP0274_Popup()"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
			<br>
			<input type="text" name="address_loc" value="<%=address_loc%>" size="96" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(100, this, '기본주소');">
		</td>
		<input type="hidden" name="dely_zip_code1" value="">
		<input type="hidden" name="dely_zip_code2" value="">
	</tr>
	<%
	}
	%>	
	<% if (i_flag.equals("N")&& !"Y".equals(user_flag)) {  %>
	<tr>
		<td class="title_td" width="15%" colspan="2"><img src="/images/ibk_s_arr.gif" width="9" height="9"> 프로파일코드
		</td>
		<td class="data_td" colspan="5">
			<input type="text" name="menu_profile_code" value="<%=menu_profile_code%>" size="20" maxlength="20" class="inputsubmit" readonly>
<!-- 			<A HREF="JAVASCRIPT:GETPROFILE()"> -->
<%-- 				<IMG SRC="<%=G_IMG_ICON%>" ALIGN="ABSMIDDLE" BORDER="0" ALT=""> --%>
<!-- 			</A> -->
			<input type="text" name="menu_name" value="<%=menu_profile_name%>" size="20" class="input_data1" readonly>
		</td>
	</tr>
	<% } else { %>
	<input type="hidden" name="menu_profile_code" value="<%=menu_profile_code%>" class="inputsubmit" readonly>
	<% } %>	
	<input type="hidden" name="i_flag" value="<%=i_flag%>">
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
if (user_flag.equals("Y")) {
%>
	<tr>
		<td align="right">
			<input type="checkbox" name="Notice" OnClick="javascript:closeWin();"> <b>오늘 하루 그만보기</b>
		</td>
	</tr>
<%
}
%>
	<tr>
		<td height="30" align="right">
		<TABLE cellpadding="0">
			<TR>
				<% if(!i_user_id.equals("")) {  %>
				<TD><script language="javascript">btn("javascript:Save()","저 장")</script></TD>
				<TD><script language="javascript">btn("javascript:parent.window.close()","닫 기")</script></TD>
				<% } %>
			</TR>
		</TABLE>
		</td>
	</tr>
</form>
</table>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>



