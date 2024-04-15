<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_135");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code         = info.getSession("HOUSE_CODE");
	String check_company_code = info.getSession("COMPANY_CODE");
	String i_flag = "B";
	String i_user_id = info.getSession("ID");

	if(i_user_id == null || i_user_id.equals("")) {
		i_user_id = "";
	}
%>
<%
	String password                = "" ;
	String user_name_loc           = "" ;
	String user_name_eng           = "" ;
	String company_name_loc        = "" ;
	String dept_name_loc           = "" ;
	String resident_no             = "" ;
	String employee_no             = "" ;
	String phone_no                = "" ;
	String phone_no_2              = "" ;
	String phone_no_3              = "" ;
	String email                   = "" ;
	String mobile_no               = "" ;
	String mobile_no_2             = "" ;
	String mobile_no_3             = "" ;
	String fax_no                  = "" ;
	String fax_no_2                = "" ;
	String fax_no_3                = "" ;
	String position_name           = "" ;
	String language_name           = "" ;
	String time_zone               = "" ;
	String zip_code                = "" ;
	String country_name            = "" ;
	String city_name               = "" ;
	String state                   = "" ;
	String address_loc             = "" ;
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
	String user_first_name_eng     = "" ;
	String user_last_name_eng      = "" ;
	String ctrl_code               = "" ;
	String time_zone_name          = "" ;
	String d_dept_name_loc         = "" ;
	String d_dept                  = "" ;

	Object[] object2 = {i_user_id};
	String nickName2 = "AD_132";
	String conType2 = "CONNECTION";
	String MethodName2 = "setPASS_CHECK_CNT";

	SepoaOut value = null;
	SepoaRemote ws = null;

	if ((check_company_code == null) || (!check_company_code.equals("CC"))) {
		//20070115 shy, try~catch문 추가(release구문 추가)
		try {
			ws = new SepoaRemote(nickName2, conType2, info);
			value = ws.lookup(MethodName2, object2);
		} catch(Exception e) {
		} finally{
			try{
				ws.Release();
			}catch(Exception e){}
		}
	}

	if( !i_user_id.equals("") )  {

		String[] args = {i_user_id};
		Object[] object = {(Object[])args};
		String nickName = "AD_132";
		String conType = "CONNECTION";
		String MethodName = "getDisplay2";

		try {

			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName, object);

			if(value.status == 1) {

				SepoaFormater wf = new SepoaFormater(value.result[0]);

				if ( wf.getRowCount() > 0 ) {

					password                = wf.getValue("PASSWORD", 0) ;
					user_name_loc           = wf.getValue("USER_NAME_LOC", 0) ;
					user_name_eng           = wf.getValue("USER_NAME_ENG", 0) ;
					user_type               = wf.getValue("USER_TYPE", 0) ;
					text_user_type          = wf.getValue("USER_TYPE_LOC", 0) ;
					work_type               = wf.getValue("WORK_TYPE", 0) ;
					text_work_type         	= wf.getValue("WORK_TYPE_LOC", 0) ;
					company_name_loc        = wf.getValue("COMPANY_CODE", 0) ;
					phone_no                = wf.getValue("PHONE_NO1", 0) ;
					email                   = wf.getValue("EMAIL", 0) ;
					mobile_no               = wf.getValue("PHONE_NO2", 0) ;
					fax_no                  = wf.getValue("FAX_NO", 0) ;

				}
			}

		} catch(Exception e) {
		} finally{
			try{
				ws.Release();
			}catch(Exception e){}
		}
	}

	if(phone_no.length() == 9){
		phone_no_2 = phone_no.substring(2,5);
		phone_no_3 = phone_no.substring(5,9);
		phone_no = phone_no.substring(0,2);
	} else if(phone_no.length() == 10){
		phone_no_2 = phone_no.substring(3,6);
		phone_no_3 = phone_no.substring(6,10);
		phone_no = phone_no.substring(0,3);
	} else if(phone_no.length() == 11){
		phone_no_2 = phone_no.substring(3,7);
		phone_no_3 = phone_no.substring(7,11);
		phone_no = phone_no.substring(0,3);
	}

	if(fax_no.length() == 9){
		fax_no_2 = fax_no.substring(2,5);
		fax_no_3 = fax_no.substring(5,9);
		fax_no = fax_no.substring(0,2);
	} else if(fax_no.length() == 10){
		fax_no_2 = fax_no.substring(3,6);
		fax_no_3 = fax_no.substring(6,10);
		fax_no = fax_no.substring(0,3);
	} else if(fax_no.length() == 11){
		fax_no_2 = fax_no.substring(3,7);
		fax_no_3 = fax_no.substring(7,11);
		fax_no = fax_no.substring(0,3);
	}

	if(mobile_no.length() == 10){
		mobile_no_2 = mobile_no.substring(3,6);
		mobile_no_3 = mobile_no.substring(6,10);
		mobile_no = mobile_no.substring(0,3);
	} else if(mobile_no.length() == 11){
		mobile_no_2 = mobile_no.substring(3,7);
		mobile_no_3 = mobile_no.substring(7,11);
		mobile_no = mobile_no.substring(0,3);
	}

%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<Script language="javascript">

function operatingSave()
{
	if(!checkData()) return;
/* 	document.form.method = "POST";
	document.form.target = "work";
	document.form.action = "user_status_pop_up_in.jsp";
	document.form.submit(); */
	
	//페이지가 존재하지 않음.
	var jqa = new jQueryAjax();
	jqa.action = "user_status_pop_up_in.jsp";
	jqa.submit();
	
}

function checkData() {

	if(chkKorea(document.form.password.value) > 10) {
		//alert("비밀번호는 10자 이내입니다.");
		alert("<%=text.get("AD_135.MSG_0100")%>");
		document.form.password.focus();
		document.form.password.select();
		return false;
		}

	if(chkKorea(document.form.user_name_eng.value) > 40) {
		//alert("사용자명(영문)은 40자 이내입니다.");
		alert("<%=text.get("AD_135.MSG_0101")%>");
		document.form.user_name_eng.focus();
		document.form.user_name_eng.select();
		return false;
	}

	if(isEmpty(document.form.phone_no_0.value)){
		//alert("전화번호를 넣어주세요.");
		alert("<%=text.get("AD_135.MSG_0102")%>");
		document.form.phone_no_0.focus();
		return false;
	}

<%--
	if(isEmpty(document.form.phone_no_1.value)){
		//alert("전화번호를 넣어주세요.");
		alert("<%=text.get("AD_135.MSG_0102")%>");
		document.form.phone_no_1.focus();
		return false;
	}

	if(isEmpty(document.form.phone_no_2.value)){
		//alert("전화번호를 넣어주세요.");
		alert("<%=text.get("AD_135.MSG_0102")%>");
		document.form.phone_no_2.focus();
		return false;
	}

	if(isEmpty(document.form.phone_no_3.value)){
		//alert("전화번호를 넣어주세요.");
		alert("<%=text.get("AD_135.MSG_0102")%>");
		document.form.phone_no_3.focus();
		return false;
	}
--%>
	if(chkKorea(document.form.email.value) > 50) {
		//alert("이메일은 50자 이내입니다.");
		alert("<%=text.get("AD_135.MSG_0103")%>");
		document.form.email.focus();
		document.form.email.select();
		return false;
	}

	if(isEmpty(document.form.email.value)){
		//alert("이메일을 넣어주세요.");
		alert("<%=text.get("AD_135.MSG_0104")%>");
		document.form.email.focus();
		return false;
	}

<%--
	if(!IsTel(document.form.mobile_no_1.value)) {
		//alert("휴대폰번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0105")%>");
		document.form.mobile_no_1.focus();
		document.form.mobile_no_1.select();
		return false;
	}

	if(!IsTel(document.form.mobile_no_2.value)) {
		//alert("휴대폰번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0105")%>");
		document.form.mobile_no_2.focus();
		document.form.mobile_no_2.select();
		return false;
	}

	if(!IsTel(document.form.mobile_no_3.value)) {
		//alert("휴대폰번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0105")%>");
		document.form.mobile_no_3.focus();
		document.form.mobile_no_3.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_1.value)) {
		//alert("팩스번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0106")%>");
		document.form.fax_no_1.focus();
		document.form.fax_no_1.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_2.value)) {
		//alert("팩스번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0106")%>");
		document.form.fax_no_2.focus();
		document.form.fax_no_2.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_3.value)) {
		//alert("팩스번호 형태로 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0106")%>");
		document.form.fax_no_3.focus();
		document.form.fax_no_3.select();
		return false;
	}
--%>
	return true;
}

function Check() {

	document.forms[0].i_flag.value = '<%=i_flag%>';
	document.forms[0].i_chk_user_id.value = document.forms[0].i_chk_user_id.value.toUpperCase();
	var i_user_id = document.forms[0].i_chk_user_id.value;
	var i_passwd = document.forms[0].i_chk_passwd.value;

	if(i_user_id == "") {
		//alert("아이디를 입력해주세요..");
		alert("<%=text.get("AD_135.MSG_0107")%>");
		return;
	}else {
		if(i_chk_passwd == "") {
			//alert("패스워드를 입력해주세요..");
			alert("<%=text.get("AD_135.MSG_0108")%>");
			return;
		}
	}

	if(i_user_id != "" && i_chk_passwd != ""){
/* 		parent.work.location.href="user_status_pop_up_chk.jsp?i_user_id="+ i_user_id+"&i_passwd="+i_passwd; */
		
		var jqa = new jQueryAjax();
		jqa.action = "user_status_pop_up_chk.jsp";
		jqa.data = "i_user_id="+ i_user_id+"&i_passwd="+i_passwd;
		jqa.submit(false);
	}
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


function IsTel(num) {
    for(i=0;i<num.length;i++)
	{
        if((num.charAt(i) < '0' || num.charAt(i) > '9') && num.charAt(i) !='-' && num.charAt(i) !=')' && num.charAt(i) !=' ' )
        {
            return false;
        }
	}

    return true;
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

function getmanager_Position(code, text) {
	document.forms[0].manager_position.value = code;
	document.forms[0].text_manager_position.value = text;
}

function searchProfile(fc) {
	var url = "";
	if(fc == "city") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0019&function=getCity&values="+document.forms[0].country.value+"&values=&values=";
	else if(fc == "dept") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0022&function=getDept&values="+document.forms[0].company_code.value+"&values=&values=";
	else if(fc == "pr") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0053&function=getPr&values=M062";
	else if(fc == "posi") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0029&function=getPosition&values="+document.forms[0].company_code.value+"&values=C002";
	else if(fc == "manager_posi") url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0029&function=getmanager_Position&values="+document.forms[0].company_code.value+"&values=C001";

	Code_Search(url,'','','','','');
}
function getprofile() {
    var dim = new Array(2);
    dim = ToCenter('600','800');
    var top = dim[0];
    var left = dim[1];
    var url = "profile_common.jsp?flag=Y";

    Code_Search(url,'','','','800','600');
}

function Setprofile(code,name) {
	document.forms[0].menu_profile_code.value = code;
	document.forms[0].menu_name.value = name;
}


function chkMixing(chkstr) {
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

function chkIdIsEquals(chkstr) {
    var user_id = '<%=i_user_id%>';

    if(chkstr.indexOf(user_id) != -1) return false;
    else return true;
}

function chkInputRepeat(chkstr){
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

function doUpdate() {

	var form = document.forms[0];
	var password = form.password.value;
	var password2 = form.password2.value;

	var phone_no_0 = form.phone_no_0.value;
	var phone_no_1 = form.phone_no_1.value;
	var phone_no_2 = form.phone_no_2.value;
	var phone_no_3 = form.phone_no_3.value;
	var email    = form.email.value;

	var mobile_no_0 = form.mobile_no_0.value;
	var mobile_no_1 = form.mobile_no_1.value;
	var mobile_no_2 = form.mobile_no_2.value;
	var mobile_no_3 = form.mobile_no_3.value;

	if(password != "") {
		if(password2 == "") {
			//alert("새 패스워드를 한번 더 넣어주세요");
			alert("<%=text.get("AD_135.MSG_0109")%>");
			return;
		}else {
			if(password != password2) {
				//alert("새 패스워드 두개가 일치하지 않습니다.");
				alert("<%=text.get("AD_135.MSG_0110")%>");
				return;
			}
		}
	}

	if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
		//alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(1)");
		alert("<%=text.get("AD_135.MSG_0111")%>");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkMixing(document.forms[0].password.value)) {
		//alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(2)");
		alert("<%=text.get("AD_135.MSG_0112")%>");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkIdIsEquals(document.forms[0].password.value)) {
		//alert("비밀번호는 ID가 포함되어 있으면 안됩니다.(3)");
		alert("<%=text.get("AD_135.MSG_0113")%>");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkInputRepeat(document.forms[0].password.value)) {
		//alert("비밀번호는 같은 문자를 3번 이상 반복 입력할 수 없습니다.(4)");
		alert("<%=text.get("AD_135.MSG_0114")%>");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!checkData()) return;

	if(phone_no_0 == null || phone_no_0 == "") {
		//alert("전화번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0115")%>");
		return;
	}
<%--
	if(phone_no_1 == null || phone_no_1 == "") {
		//alert("전화번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0115")%>");
		return;
	}
	if(phone_no_2 == null || phone_no_2 == "") {
		//alert("전화번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0115")%>");
		return;
	}
	if(phone_no_3 == null || phone_no_3 == "") {
		//alert("전화번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0115")%>");
		return;
	}
--%>
	if( email == null || email== "") {
		//alert("이메일주소를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0116")%>");
		return;
	}

<%--
	if( mobile_no_1 == null || mobile_no_1== "") {
		//alert("휴대폰 번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0117")%>");
		return;
	}
	if( mobile_no_2 == null || mobile_no_2== "") {
		//alert("휴대폰 번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0117")%>");
		return;
	}
	if( mobile_no_3 == null || mobile_no_3== "") {
		//alert("휴대폰 번호를 입력해주세요");
		alert("<%=text.get("AD_135.MSG_0117")%>");
		return;
	}
--%>
/* 	form.method = "POST";
	form.target = "work";
	form.action = "user_status_pop_up_b_save.jsp";
	form.submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "user_status_pop_up_b_save.jsp";
	jqa.submit();
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();
		Check();
	}
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

function Close() {
	window.returnValue  = 0;
	self.close();
}

function closePopup(){
	var value1 = "Close";
	window.returnValue  = new RtnObjName(value1);
	window.close();
}

function RtnObjName(value1){
	this.value1 = value1;
}

</Script>

</head>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
<form name="form" method="post" action="">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<%@ include file="/include/include_menu.jsp"%>

				<td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="98%" border="0" cellspacing="0" cellpadding="0">

				<span class='location'><b><font color="blue"><%=text.get("AD_135.TEXT_0100")%></font></b></span>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="5" colspan="2"></td>
							</tr>
							<tr>
								<td height="4" colspan="2" bgcolor="51C3E8"></td>
							</tr>

							<tr>
								<td height="5" colspan="2" style="background-image:url(../images/bg_srch.gif); background-repeat:repeat-x"></td>
							</tr>
						</TABLE>
 <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td></td>
	</tr>
  </table>
   <table width="98%" border="0" cellspacing="1" cellpadding="0" bgcolor="F6F6F6">
	<tr><td>
	&nbsp;&nbsp;<img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle">
	<%=text.get("AD_135.TEXT_0101")%> :  &nbsp;<%=text_user_type%>
		<input type="hidden" name="text_user_type" id="text_user_type" class="input_empty"  value="<%=text_user_type%>" readonly>
		<input type="hidden" name="user_type" id="user_type" value="<%=user_type%>"  >
	&nbsp;&nbsp;<img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle">
	<%=text.get("AD_135.TEXT_0102")%> : &nbsp;<%=text_work_type%>
		<input type="hidden" name="text_work_type" id="text_work_type" class="input_empty"  value="<%=text_work_type%>" readonly>
		<input type="hidden" name="work_type" id="work_type" value="<%=work_type%>">
		<img src="../images/blt_srch.gif" width="7" height="7" hspace="5" align="absmiddle">
		<%=text.get("AD_135.TEXT_0103")%> : &nbsp;<%=company_name_loc%>
		<input type="hidden" name="text_company_code" id="text_company_code" class="input_empty"  value="<%=company_name_loc%>" readonly>
		<input type="hidden" name="company_code" id="company_code" class="input_empty" value="<%=company_code%>" readonly>
	</td></tr>
  </table>
  <table>
  <tr><td></td></tr>
  </table>

<%  if(i_flag.equals("P"))  { %>
   <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0104")%></td>
	  <td class="div_data" width="35%">
		<input type="text" name="i_chk_user_id" id="i_chk_user_id" value="" size="20" class="inputsubmit"> </td>
	  <td class="cell_title" width="15%" align="center"><%=text.get("AD_135.TEXT_0105")%></td>
	  <td class="cell_data" width="35%">
		<input type="password" name="i_chk_passwd" id="i_chk_passwd" value="" size="20" class="inputsubmit"></td>
	</tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td></td>
	</tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td height="30">
		<div align="right"><a href="javascript:Check()"><img src="../../images/button/butt_search.gif" align="absmiddle" border="0"></a></div>
	  </td>
	</tr>
  </table>
<% }    %>



  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td></td>
	</tr>
  </table>
  <table width="98%" border="0" cellspacing="1" cellpadding="0" bgcolor="F6F6F6">
	<tr>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0106")%></td>
	  <td class="div_data" colspan="3" ><%=i_user_id%>
		<input type="hidden" name="i_user_id" id="i_user_id" value="<%=i_user_id%>">
		<input type="hidden" name="old_pwd" id="old_pwd" value="<%=password%>">
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>

	<tr>
	  <td class="div_input_re" width="15%" align="center"><%=text.get("AD_135.TEXT_0107")%></td>
	  <td class="div_data">
		<input type="password" name="password" id="password" value="" size="12" maxlength="10" class="input_re" style='ime-mode:inactive'>
	  </td>
	  <td class="div_input_re" align="center"><%=text.get("AD_135.TEXT_0108")%></td>
	  <td class="div_data">
		<input type="password" name="password2" id="password2" value="" size="12" maxlength="10" class="input_re" style='ime-mode:inactive'>
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>


	<tr>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0109")%></td>
	  <td class="div_data">
		<input type="text" name="user_name_loc" id="user_name_loc" value="<%=user_name_loc%>" size="20" maxlength="40" class="input_empty" readonly >
	  </td>
	  <td class="div_input" align="center"><%=text.get("AD_135.TEXT_0110")%></td>
	  <td class="div_data">
		<input type="text" name="user_name_eng" id="user_name_eng" value="<%=user_name_eng%>" size="20" maxlength="40" class="input_empty" readonly >
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>

<%--
	<tr>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0111")%></td>
	  <td class="div_data" colspan="3">
		 <%=company_code%>
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>
--%>

<%--
	<tr>
	  <td class="cell_title" width="15%"><%=text.get("AD_135.TEXT_0112")%></td>
	  <td class="cell_data" colspan="3">
		*************
		<input type="hidden" name="resident_no" value="<%=resident_no%>" size="20" maxlength="20" class="input_data0" readonly >
	  </td>
	</tr>
--%>
	<tr>
	  <td class="div_input_re" width="15%" align="center"><%=text.get("AD_135.TEXT_0113")%></td>
	  <td class="div_data">
		<input type="text" name="phone_no_0" id="phone_no_0" value="<%=phone_no%>" size="20" maxlength="20" class="input_re">
		<input type="hidden" name="phone_no_1" id="phone_no_1" value="<%=phone_no%>" size="3" maxlength="4" class="input_re">
		<input type="hidden" name="phone_no_2" id="phone_no_2" value="<%=phone_no_2%>" size="4" maxlength="4" class="input_re">
		<input type="hidden" name="phone_no_3" id="phone_no_3" value="<%=phone_no_3%>" size="4" maxlength="4" class="input_re">
	  </td>
	  <td class="div_input_re" align="center"><%=text.get("AD_135.TEXT_0114")%></td>
	  <td class="div_data">
		<input type="text" name="email" id="email" value="<%=email%>" size="30" maxlength="50" class="input_re">
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>


	<tr>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0115")%></td>
	  <td class="div_data">
		<input type="text" name="mobile_no_0" id="mobile_no_0" value="<%=mobile_no%>" size="20" maxlength="20" class="input_re">
		<input type="hidden" name="mobile_no_1" id="mobile_no_1" value="<%=mobile_no%>" size="3" maxlength="4" class="input_re">
		<input type="hidden" name="mobile_no_2" id="mobile_no_2" value="<%=mobile_no_2%>" size="4" maxlength="4" class="input_re">
		<input type="hidden" name="mobile_no_3" id="mobile_no_3" value="<%=mobile_no_3%>" size="4" maxlength="4" class="input_re">
	  </td>
	  <td class="div_input" align="center"><%=text.get("AD_135.TEXT_0116")%></td>
	  <td class="div_data">
		<input type="text" name="fax_no_0" id="fax_no_0" value="<%=fax_no%>" size="20" maxlength="20" class="inputsubmit">
		<input type="hidden" name="fax_no_1" id="fax_no_1" value="<%=fax_no%>" size="3" maxlength="4" class="inputsubmit">
		<input type="hidden" name="fax_no_2" id="fax_no_2" value="<%=fax_no_2%>" size="4" maxlength="4" class="inputsubmit">
		<input type="hidden" name="fax_no_3" id="fax_no_3" value="<%=fax_no_3%>" size="4" maxlength="4" class="inputsubmit">
	  </td>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>


	<tr>
	<% if ((position).equals("HS00")) { %>
	  <%--<td class="cell1_title" width="15%"><%=text.get("AD_135.TEXT_0117")%><br>
	  </td>
	  <td class="cell1_data" width="35%">
		<input type="text" name="state" value="<%=state%>" size="20" maxlength="20" class="input_data1" readOnly >
	  </td>--%>
	  <td class="div_input" width="15%" align="center"><%=text.get("AD_135.TEXT_0118")%></td>
	  <td class="div_data" colspan="3">
		<input type="text" name="ctrl_code" id="ctrl_code" size="5" maxlength="3" class="inputsubmit" value="<%=ctrl_code%>" readonly >
		<%--<a href="javascript:SP0216_Popup();" id=g4><img src="../../images/button/query.gif" align="absmiddle" border="0" id=g3></a>--%>
	  </td>
	 <% } else { %>
	  <%--<td class="cell1_title" width="15%"><%=text.get("AD_135.TEXT_0119")%><br>
	  </td>
	  <td class="cell1_data" colspan=3>
		<input type="text" name="state" value="<%=state%>" size="20" maxlength="20" class="input_data1" readOnly >
	  </td>--%>
	 <% } %>
	</tr>
	<tr>
		<td height="1" colspan="4" style="background-image:url(../images/dot_hor.gif); background-repeat:repeat-x"></td>
	</tr>
	<input type="hidden" name="menu_profile_code" id="menu_profile_code" value="<%=menu_profile_code%>"  class="inputsubmit" readonly >
	<input type="hidden" name="i_flag" id="i_flag" value="<%=i_flag%>" >
  </table>

  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td width="20%">
		<div align="left"></div>
	  </td>
	  <td width="80%" height="30">
		<div align="right">
<% if(i_user_id != "") {  %>
			<%-- <img src="../../images/button/butt_save.gif" align="absmiddle" border="0" onclick="doUpdate()" onMouseOver="style.cursor='hand'"> --%>
			<script language="javascript">btn("javascript:doUpdate()", "<%=text.get("BUTTON.save")%>")</script>
<%  } %>
	   </div>
	  </td>
	</tr>
  </table>
 </div>   </form>
<!-- <iframe id="work" name="work" width="0" height="0"></iframe> -->
</s:header>
<s:footer/>
</body>
</html>
