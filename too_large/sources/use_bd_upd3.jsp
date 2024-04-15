<%-- 사용처 없음 --%>
<%@ include file="/include/wisehub_common.jsp" %>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_scripts.jsp"%>

<%
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
	String nickName2 = "p0030";
	String conType2 = "CONNECTION";
	String MethodName2 = "setPASS_CHECK_CNT";

	WiseOut value = null;
	WiseRemote ws = null;

	if ((check_company_code == null) || (!check_company_code.equals("CC"))) {
		//20070115 shy, try~catchÂ¹Â® ÃÃÂ°Â¡(releaseÂ±Â¸Â¹Â® ÃÃÂ°Â¡)
		//try {
		//	ws = new WiseRemote(nickName2, conType2, info);
		//	value = ws.lookup(MethodName2, object2);
		//} catch(Exception e) {
		//} finally{
		//	try{
		//		ws.Release();
		//	}catch(Exception e){}
		//}
	}

	if( !i_user_id.equals("") )  {

		String[] args = {i_user_id};
		Object[] object = {(Object[])args};
		String nickName = "p0030";
		String conType = "CONNECTION";
		String MethodName = "getDisplay2";

		try {

			ws = new WiseRemote(nickName, conType, info);
			value = ws.lookup(MethodName, object);

			if(value.status == 1) {

				WiseFormater wf = new WiseFormater(value.result[0]);

				if ( wf.getRowCount() > 0 ) {

					password                			= wf.getValue("PASSWORD", 0) ;
					user_name_loc           		= wf.getValue("USER_NAME_LOC", 0) ;
					user_name_eng           	= wf.getValue("USER_NAME_ENG", 0) ;
					user_type               			= wf.getValue("USER_TYPE", 0) ;
					text_user_type          		= wf.getValue("USER_TYPE_LOC", 0) ;
					work_type               			= wf.getValue("WORK_TYPE", 0) ;
					text_work_type         		= wf.getValue("WORK_TYPE_LOC", 0) ;
					company_name_loc        = wf.getValue("COMPANY_CODE", 0) ;
					phone_no                			= wf.getValue("PHONE_NO1", 0) ;
					email                   			= wf.getValue("EMAIL", 0) ;
					mobile_no               			= wf.getValue("PHONE_NO2", 0) ;
					fax_no                  			= wf.getValue("FAX_NO", 0) ;

				}
			}

		} catch(Exception e) {
		} finally{
			try{
				ws.Release();
			}catch(Exception e){}
		}
	}
Logger.debug.println("AAAAAAAAAAAAAAAAAAAAAA"+phone_no);
Logger.debug.println("AAAAAAAAAAAAAAAAAAAAAA"+mobile_no);
	if(phone_no.length() > 3 && phone_no.substring(0,2).equals("02")) {
		if(phone_no.length() == 9){
			phone_no_2 = phone_no.substring(2,5);
			phone_no_3 = phone_no.substring(5,9);
			phone_no = phone_no.substring(0,2);
		} else if(phone_no.length() == 10){
			phone_no_2 = phone_no.substring(2,6);
			phone_no_3 = phone_no.substring(6,10);
			phone_no = phone_no.substring(0,2);
		}
	} else {
		if(phone_no.length() == 10){
			phone_no_2 = phone_no.substring(3,6);
			phone_no_3 = phone_no.substring(6,10);
			phone_no = phone_no.substring(0,3);
		} else if(phone_no.length() == 11){
			phone_no_2 = phone_no.substring(3,7);
			phone_no_3 = phone_no.substring(7,11);
			phone_no = phone_no.substring(0,3);
		}
	}
	if(fax_no.length() > 3 && fax_no.substring(0,2).equals("02")) {
		if(fax_no.length() == 9){
			fax_no_2 = fax_no.substring(2,5);
			fax_no_3 = fax_no.substring(5,9);
			fax_no = fax_no.substring(0,2);
		} else if(fax_no.length() == 10){
			fax_no_2 = fax_no.substring(2,6);
			fax_no_3 = fax_no.substring(6,10);
			fax_no = fax_no.substring(0,2);
		}
	} else {
		if(fax_no.length() == 10){
			fax_no_2 = fax_no.substring(3,6);
			fax_no_3 = fax_no.substring(6,10);
			fax_no = fax_no.substring(0,3);
		} else if(fax_no.length() == 11){
			fax_no_2 = fax_no.substring(3,7);
			fax_no_3 = fax_no.substring(7,11);
			fax_no = fax_no.substring(0,3);
		}
	}
	
	if(mobile_no.length() == 9){
		mobile_no_2 = mobile_no.substring(2,5);
		mobile_no_3 = mobile_no.substring(5,9);
		mobile_no = mobile_no.substring(0,2);
	} else if(mobile_no.length() == 10){
		mobile_no_2 = mobile_no.substring(3,6);
		mobile_no_3 = mobile_no.substring(6,10);
		mobile_no = mobile_no.substring(0,3);
	} else if(mobile_no.length() > 10){
		mobile_no_2 = mobile_no.substring(3,7);
		mobile_no_3 = mobile_no.substring(7,11);
		mobile_no = mobile_no.substring(0,3);
	}

%>
<html>
<head>
<title>ì°ë¦¬ìí ì ìêµ¬ë§¤ìì¤í</title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<Script language="javascript">

function operatingSave()
{
	if(!checkData()) return;
	document.form.method = "POST";
	document.form.target = "work";
	document.form.action = "use_wk_ins1.jsp";
	document.form.submit();
}

function checkData() {

	if(chkKorea(document.form.password.value) > 10) {
		alert("ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â´Ã 10ÃÃ ÃÃÂ³Â»ÃÃÂ´ÃÂ´Ã.");
		document.form.password.focus();
		document.form.password.select();
		return false;
		}

	if(chkKorea(document.form.user_name_eng.value) > 40) {
		alert("Â»Ã§Â¿Ã«ÃÃÂ¸Ã­(Â¿ÂµÂ¹Â®)ÃÂº 40ÃÃ ÃÃÂ³Â»ÃÃÂ´ÃÂ´Ã.");
		document.form.user_name_eng.focus();
		document.form.user_name_eng.select();
		return false;
	}

	if(isEmpty(document.form.phone_no_1.value)){
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ Â³ÃÂ¾Ã®ÃÃÂ¼Â¼Â¿Ã¤.");
		document.form.phone_no_1.focus();
		return false;
	}

	if(isEmpty(document.form.phone_no_2.value)){
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ Â³ÃÂ¾Ã®ÃÃÂ¼Â¼Â¿Ã¤.");
		document.form.phone_no_2.focus();
		return false;
	}

	if(isEmpty(document.form.phone_no_3.value)){
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ Â³ÃÂ¾Ã®ÃÃÂ¼Â¼Â¿Ã¤.");
		document.form.phone_no_3.focus();
		return false;
	}

	if(chkKorea(document.form.email.value) > 50) {
		alert("ÃÃÂ¸ÃÃÃÃÂº 50ÃÃ ÃÃÂ³Â»ÃÃÂ´ÃÂ´Ã.");
		document.form.email.focus();
		document.form.email.select();
		return false;
	}

	if(isEmpty(document.form.email.value)){
		alert("ÃÃÂ¸ÃÃÃÃÂ» Â³ÃÂ¾Ã®ÃÃÂ¼Â¼Â¿Ã¤.");
		document.form.email.focus();
		return false;
	}

	if(!IsTel(document.form.mobile_no_1.value)) {
		alert("ÃÃÂ´Ã«ÃÃ¹Â¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.mobile_no_1.focus();
		document.form.mobile_no_1.select();
		return false;
	}

	if(!IsTel(document.form.mobile_no_2.value)) {
		alert("ÃÃÂ´Ã«ÃÃ¹Â¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.mobile_no_2.focus();
		document.form.mobile_no_2.select();
		return false;
	}

	if(!IsTel(document.form.mobile_no_3.value)) {
		alert("ÃÃÂ´Ã«ÃÃ¹Â¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.mobile_no_3.focus();
		document.form.mobile_no_3.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_1.value)) {
		alert("ÃÃÂ½ÂºÂ¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.fax_no_1.focus();
		document.form.fax_no_1.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_2.value)) {
		alert("ÃÃÂ½ÂºÂ¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.fax_no_2.focus();
		document.form.fax_no_2.select();
		return false;
	}

	if(!IsTel(document.form.fax_no_3.value)) {
		alert("ÃÃÂ½ÂºÂ¹Ã¸ÃÂ£ ÃÃ¼ÃÃÂ·Ã ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		document.form.fax_no_3.focus();
		document.form.fax_no_3.select();
		return false;
	}

	return true;
}

function Check() {

	document.forms[0].i_flag.value = '<%=i_flag%>';
	document.forms[0].i_chk_user_id.value = document.forms[0].i_chk_user_id.value.toUpperCase();
	var i_user_id = document.forms[0].i_chk_user_id.value;
	var i_passwd = document.forms[0].i_chk_passwd.value;

	if(i_user_id == "") {
		alert("Â¾ÃÃÃÂµÃ°Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤..");
		return;
	}else {
		if(i_chk_passwd == "") {
			alert("ÃÃÂ½ÂºÂ¿Ã¶ÂµÃ¥Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤..");
			return;
		}
	}

	if(i_user_id != "" && i_chk_passwd != "")
		parent.work.location.href="/kr/master/user/use_wk_chk2.jsp?i_user_id="+ i_user_id+"&i_passwd="+i_passwd;
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
	if(fc == "city") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0019&function=getCity&values=<%=house_code%>&values="+document.forms[0].country.value+"&values=&values=";
	else if(fc == "dept") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=&values=";
	else if(fc == "pr") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0053&function=getPr&values=<%=house_code%>&values=M062";
	else if(fc == "posi") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0029&function=getPosition&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=C002";
	else if(fc == "manager_posi") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0029&function=getmanager_Position&values=<%=house_code%>&values="+document.forms[0].company_code.value+"&values=C001";

	Code_Search(url,'','','','','');
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
	var phone_no_1 = form.phone_no_1.value;
	var phone_no_2 = form.phone_no_2.value;
	var phone_no_3 = form.phone_no_3.value;
	var email    = form.email.value;
	var mobile_no_1 = form.mobile_no_1.value;
	var mobile_no_2 = form.mobile_no_2.value;
	var mobile_no_3 = form.mobile_no_3.value;

	if(password != "") {
		if(password2 == "") {
			alert("Â»Ãµ ÃÃÂ½ÂºÂ¿Ã¶ÂµÃ¥Â¸Â¦ ÃÃÂ¹Ã¸ Â´Ãµ Â³ÃÂ¾Ã®ÃÃÂ¼Â¼Â¿Ã¤");
			return;
		}else {
			if(password != password2) {
				alert("Â»Ãµ ÃÃÂ½ÂºÂ¿Ã¶ÂµÃ¥ ÂµÃÂ°Â³Â°Â¡ ÃÃÃÂ¡ÃÃÃÃ¶ Â¾ÃÂ½ÃÂ´ÃÂ´Ã.");
				return;
			}
		}
	}

	if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
		alert("ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â´Ã Â¿ÂµÂ¹Â®ÃÃÂ¿Ã Â¼Ã½ÃÃÂ¸Â¦ ÃÂ¥Â¿Ã«ÃÃÂ¿Â© 6~10ÃÃÂ¸Â¸ Â°Â¡Â´ÃÃÃÂ´ÃÂ´Ã.(1)");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkMixing(document.forms[0].password.value)) {
		alert("ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â´Ã Â¿ÂµÂ¹Â®ÃÃÂ¿Ã Â¼Ã½ÃÃÂ¸Â¦ ÃÂ¥Â¿Ã«ÃÃÂ¿Â© 6~10ÃÃÂ¸Â¸ Â°Â¡Â´ÃÃÃÂ´ÃÂ´Ã.(2)");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkIdIsEquals(document.forms[0].password.value)) {
		alert("ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â´Ã IDÂ°Â¡ ÃÃ·ÃÃÂµÃÂ¾Ã® ÃÃÃÂ¸Â¸Ã© Â¾ÃÂµÃÂ´ÃÂ´Ã.(3)");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!chkInputRepeat(document.forms[0].password.value)) {
		alert("ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â´Ã Â°Â°ÃÂº Â¹Â®ÃÃÂ¸Â¦ 3Â¹Ã¸ ÃÃÂ»Ã³ Â¹ÃÂºÂ¹ ÃÃÂ·ÃÃÃ Â¼Ã¶ Â¾Ã¸Â½ÃÂ´ÃÂ´Ã.(4)");
		document.forms[0].password.focus();
		document.forms[0].password.select();
		return false;
	}

	if(!checkData()) return;

	if(phone_no_1 == null || phone_no_1 == "") {
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if(phone_no_2 == null || phone_no_2 == "") {
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if(phone_no_3 == null || phone_no_3 == "") {
		alert("ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if( email == null || email== "") {
		alert("ÃÃÂ¸ÃÃÃÃÃÂ¼ÃÂ¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if( mobile_no_1 == null || mobile_no_1== "") {
		alert("ÃÃÂ´Ã«ÃÃ¹ Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if( mobile_no_2 == null || mobile_no_2== "") {
		alert("ÃÃÂ´Ã«ÃÃ¹ Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}
	if( mobile_no_3 == null || mobile_no_3== "") {
		alert("ÃÃÂ´Ã«ÃÃ¹ Â¹Ã¸ÃÂ£Â¸Â¦ ÃÃÂ·ÃÃÃÃÃÂ¼Â¼Â¿Ã¤");
		return;
	}

	form.method = "POST";
	form.target = "work";
	form.action = "use_wk_upd3.jsp";
	form.submit();
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
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=CJ00&values=&values=";
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

<body bgcolor="#FFFFFF" text="#000000" onUnload="closePopup()">
<form name="form" >
<div align="center">
  <input type="hidden" name="program" value="use_bd_upd3">
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td class="cell_title1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/a.gif" align="absmiddle">&nbsp;Â»Ã§Â¿Ã«ÃÃ Â¼Ã¶ÃÂ¤<!--Â»Ã§Â¿Ã«ÃÃÂ¼Ã¶ÃÂ¤ : ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â¸Â¦ Â¹ÃÂ²ÃÃÃ¶ Â¾ÃÂ°Ã­ PopupÃÂ¢ÃÂ» Â´ÃÃÂ¸Â½ÃÂ¸Ã© ÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£Â¸Â¦ ÃÃ§Â¹ÃÂ±Ã Â¹ÃÃÂ¸Â¼ÃÂ¾Ã ÃÃÂ´ÃÂ´Ã.--></td>
	</tr>
    <tr>
        <td height="10" bgcolor="FFFFFF"></td>
    </tr>	
  </table>
  <script language="javascript">rdtable_top1()</script>
   <table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
	  <td class="c_title_1_p" width="15%">Â»Ã§Â¿Ã«ÃÃ Â±Â¸ÂºÃ</td>
	  <td class="c_data_1_p" width="35%" >
		<input type="text" name="text_user_type" class="input_data2"  value="<%=text_user_type%>" readonly  >
		<input type="hidden" name="user_type"  value="<%=user_type%>"  >
	  </td>
	  <td class="c_title_1_p" width="15%">Â¾Ã·Â¹Â«Â±ÃÃÃ</td>
	  <td class="c_data_1_p" width="35%">
		<input type="text" name="text_work_type" class="input_data2"  value="<%=text_work_type%>" readonly  >
		<input type="hidden" name="work_type"  value="<%=work_type%>"  >
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1_p">ÃÂ¸Â»Ã§ÃÃÂµÃ¥</td>
	  <td class="c_data_1_p" colspan="3">
		<input type="text" name="text_company_code" class="input_data1"  value="<%=company_name_loc%>" readonly  >
		<input type="text" name="company_code"  class="input_data1" value="<%=company_code%>" readonly >
	  </td>
	</tr> 
  </table>
  <script language="javascript">rdtable_bot1()</script><br>
<%  if(i_flag.equals("P"))  { %>
	<script language="javascript">rdtable_top1()</script>
   <table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
	  <td class="cell_title" width="15%">Â»Ã§Â¿Ã«ÃÃ ID
	  </td>
	  <td class="cell_data" width="35%">
		<input type="text" name="i_chk_user_id" value="<%=password%>" size="20" class="inputsubmit"> </td>
	  <td class="cell_title" width="15%"> ÃÃÂ½ÂºÂ¿Ã¶ÂµÃ¥
	  <td class="c_title_1_p" width="15%">Â»Ã§Â¿Ã«ÃÃ ID</td>
	  <td class="c_data_1_p" width="35%">
		<input type="text" name="i_chk_user_id" value="" size="20" class="inputsubmit"> </td>
	  <td class="c_title_1_p" width="15%"> ÃÃÂ½ÂºÂ¿Ã¶ÂµÃ¥
	  </td>
	  <td class="cell_data" width="35%">
		<input type="password" name="i_chk_passwd" value="<%=password%>" size="20" class="inputsubmit"></td>
	  <td class="c_data_1_p" width="35%">
		<input type="password" name="i_chk_passwd" value="" size="20" class="inputsubmit"></td>
	</tr>
  </table>
	<script language="javascript">rdtable_bot1()</script>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td height="30">
		<div align="right"><a href="javascript:Check()"><img src="../../images//button/butt_search.gif" align="absmiddle" border="0"></a></div>
	  </td>
	</tr>
  </table>
<% }    %>
  <script language="javascript">rdtable_top1()</script>
  <table width="98%" border="0" cellspacing="1" cellpadding="1" bgcolor="#407bbc" style="border-collapse:collapse;">
	<tr>
	  <td class="c_title_1_p">Â»Ã§Â¿Ã«ÃÃ ID</td>
	  <td class="c_data_1_p" colspan="3" ><%=i_user_id%>
		<input type="hidden" name="i_user_id" value="<%=i_user_id%>">
		<input type="hidden" name="old_pwd" value="<%=password%>">
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1_p" width="15%">Â»ÃµÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£</td>
	  <td class="c_data_1_p" width="35%">
		<input type="password" name="password" value="<%=password%>" size="12" maxlength="10" class="input_re" style='ime-mode:inactive'>
	  </td>
	  <td class="c_title_1_p" width="15%">Â»ÃµÂºÃ±Â¹ÃÂ¹Ã¸ÃÂ£ÃÂ®ÃÃ</td>
	  <td class="c_data_1_p" width="35%">
		<input type="password" name="password2" value="<%=password%>" size="12" maxlength="10" class="input_re" style='ime-mode:inactive'>
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1_p">Â»Ã§Â¿Ã«ÃÃÂ¸Ã­(Â±Â¹Â¹Â®)</td>
	  <td class="c_data_1_p">
		<input type="text" name="user_name_loc" value="<%=user_name_loc%>" size="20" maxlength="40" class="input_data2" readonly >
	  </td>
	  <td class="c_title_1_p">Â»Ã§Â¿Ã«ÃÃÂ¸Ã­(Â¿ÂµÂ¹Â®)</td>
	  <td class="c_data_1_p">
		<input type="text" name="user_name_eng" value="<%=user_name_eng%>" size="20" maxlength="40" class="inputsubmit" >
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1_p">ÃÂ¸Â»Ã§ÃÃÂµÃ¥</td>
	  <td class="c_data_1_p" colspan="3">
		 <%=company_code%>
	  </td>
	</tr>
<%--
	<tr>
	  <td class="cell_title" width="15%">ÃÃÂ¹ÃÂµÃ®Â·ÃÂ¹Ã¸ÃÂ£</td>
	  <td class="cell_data" colspan="3">
		*************
		<input type="hidden" name="resident_no" value="<%=resident_no%>" size="20" maxlength="20" class="input_data2" readonly >
	  </td>
	</tr>
--%>
	<tr>
	  <td class="c_title_1_p"> ÃÃ¼ÃÂ­Â¹Ã¸ÃÂ£</td>
	  <td class="c_data_1_p">
		<input type="text" name="phone_no_1" value="<%=phone_no%>" size="3" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="phone_no_2" value="<%=phone_no_2%>" size="4" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="phone_no_3" value="<%=phone_no_3%>" size="4" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);">
	  </td>
	  <td class="c_title_1_p">ÃÃÂ¸ÃÃÃ</td>
	  <td class="c_data_1_p">
		<input type="text" name="email" value="<%=email%>" size="40" maxlength="50" class="input_re">
	  </td>
	</tr>
	<tr>
	  <td class="c_title_1_p">ÃÃÂ´Ã«ÃÃ¹</td>
	  <td class="c_data_1_p">
		<input type="text" name="mobile_no_1" value="<%=mobile_no%>" size="3" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="mobile_no_2" value="<%=mobile_no_2%>" size="4" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="mobile_no_3" value="<%=mobile_no_3%>" size="4" maxlength="4" class="input_re" onKeyPress="return onlyNumber(event.keyCode);">
	  </td>
	  <td class="c_title_1_p">ÃÃÂ½ÂºÂ¹Ã¸ÃÂ£</td>
	  <td class="c_data_1_p">
		<input type="text" name="fax_no_1" value="<%=fax_no%>" size="3" maxlength="4" class="inputsubmit" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="fax_no_2" value="<%=fax_no_2%>" size="4" maxlength="4" class="inputsubmit" onKeyPress="return onlyNumber(event.keyCode);"> -
		<input type="text" name="fax_no_3" value="<%=fax_no_3%>" size="4" maxlength="4" class="inputsubmit" onKeyPress="return onlyNumber(event.keyCode);">
	  </td>
	</tr>
	<!--tr>
	<% if ((position).equals("HS00")) { %>
	  <%--<td class="cell1_title" width="15%">ÃÃ¶Â¿Âª(only U.S.A)<br>
	  </td>
	  <td class="c_data_1_p" width="35%">
		<input type="text" name="state" value="<%=state%>" size="20" maxlength="20" class="input_data1" readOnly >
	  </td>--%>
	  <td class="c_title_1_p" width="15%">Â±Â¸Â¸ÃÂ±ÃÂ·Ã¬</td>
	  <td class="c_data_1_p" colspan="3">
		<input type="text" name="ctrl_code" size="5" maxlength="3" class="inputsubmit" value="<%=ctrl_code%>" readonly >
		<%--<a href="javascript:SP0216_Popup();" id=g4><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" id=g3></a>--%>
	  </td>
	 <% } else { %>
	  <%--<td class="cell1_title" width="15%">ÃÃ¶Â¿Âª(only U.S.A)<br>
	  </td>
	  <td class="c_data_1_p" colspan=3>
		<input type="text" name="state" value="<%=state%>" size="20" maxlength="20" class="input_data1" readOnly >
	  </td>--%>
	 <% } %>
	</tr-->
	<input type="hidden" name="menu_profile_code" value="<%=menu_profile_code%>"  class="inputsubmit" readonly >
	<input type="hidden" name="i_flag" value="<%=i_flag%>" >
  </table>
  <script language="javascript">rdtable_bot1()</script>
  
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td width="20%">
		<div align="left"></div>
	  </td>
	  <td width="80%" height="30">
		<div align="right">
<% if(i_user_id != "") {  %>
			<%-- <img src="../../images//button/butt_save.gif" align="absmiddle" border="0" onclick="doUpdate()" onMouseOver="style.cursor='hand'"> --%>
			<script language="javascript">btn("javascript:doUpdate()",6,"ÃÃº ÃÃ¥")</script>
<%  } %>
	   </div>
	  </td>
	</tr>
  </table>
 </div>   </form>
 <iframe id="work" name="work" width="0" height="0"></iframe>
</body>
</html>
