<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%
	Vector  multilang_id          = new Vector();
	HashMap text                  = null;
	String  house_code            = info.getSession("HOUSE_CODE");
	String  i_flag                = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("i_flag")));
	String  i_user_id             = JSPUtil.paramCheck(JSPUtil.CheckInjection(request.getParameter("i_user_id")));
	String  password              = "" ;
	String  user_name_loc         = "" ;
	String  user_name_eng         = "" ;
	String  company_name_loc      = "" ;
	String  resident_no           = "" ;
	String  employee_no           = "" ;
	String  phone_no              = "" ;
	String  email                 = "" ;
	String  mobile_no             = "" ;
	String  fax_no                = "" ;
	String  position_name         = "" ;
	String  language_name         = "" ;
	String  time_zone             = "" ;
	String  zip_code              = "" ;
	String  country_name          = "" ;
	String  city_name             = "" ;
	String  state                 = "" ;
	String  address_loc           = "" ;
	String  address_eng           = "" ;
	String  pr_location_name      = "" ;
	String  dept                  = "" ;
	String  position              = "" ;
	String  city_code             = "" ;
	String  pr_location           = "" ;
	String  company_code          = "" ;
	String  language              = "" ;
	String  country               = "" ;
	String  menu_profile_code     = "" ;
	String  menu_profile_name     = "" ;
	String  manager_position      = "" ;
	String  manager_position_name = "" ;
	String  user_type             = "" ;
	String  text_user_type        = "" ;
	String  work_type             = "" ;
	String  text_work_type        = "" ;
	String  ctrl_code             = "" ;
	String  time_zone_name        = "" ;
	String  dept_name_loc         = "" ;
	String  plm_user_flag         = "";
	boolean is_buyer              = true;
	String  UC_YN                 = "";

	multilang_id.addElement("AD_134");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
    text = MessageUtil.getMessage(info,multilang_id);
	
	if(info.getSession("USER_TYPE").equals("S") || info.getSession("USER_TYPE").equals("P")){
		is_buyer = false;
	}
	
	if("".equals(i_user_id) == false){
		String[] args = {i_user_id};
		Object[] obj  = {(Object[])args};

		SepoaOut value = ServiceConnector.doService(info, "AD_132", "CONNECTION","getDisplay", obj);

		if(value.status == 1){
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			
			if(wf.getRowCount() > 0){
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
				zip_code                = wf.getValue("ZIP_CODE"             , 0) ;
				country_name            = wf.getValue("COUNTRY_NAME"         , 0) ;
				city_name               = wf.getValue("CITY_NAME"            , 0) ;
				state                   = wf.getValue("STATE"                , 0) ;
				address_loc             = wf.getValue("ADDRESS_LOC"          , 0) ;
				address_eng             = wf.getValue("ADDRESS_ENG"          , 0) ;
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
				time_zone_name          = wf.getValue("TIME_ZONE_NAME"       , 0) ;
				dept_name_loc           = wf.getValue("DEPT_NAME_LOC"        , 0) ;
				dept                    = wf.getValue("DEPT"                 , 0) ;
				plm_user_flag           = wf.getValue("PLM_USER_FLAG"        , 0) ;
				UC_YN                   = wf.getValue("UC_YN"                , 0) ;
			}
		}
	}

	String LB_USER_TYPE = ListBox(request, "SL0081",info.getSession("HOUSE_CODE")+"#", user_type);
	String LB_WORK_TYPE = ListBox(request, "SL0007",info.getSession("HOUSE_CODE")+"#M104#", work_type);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/pwdPolicy.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/pluginfree/js/nppfs-1.13.0.js"></script>
<script language="javascript">
$(document).ready(function(){
	npPfsStartup(document.form, false, true, false, false, "npkencrypt", "on");
});
var G_HOUSE_CODE = "<%=house_code%>";

function checkEmpty(obj, message){
	if(isEmpty(obj.value)){
		alert(message);
		
		obj.focus();
		
		return false;
	}
	
	return true;
}

function checkKorea(obj, message, chknum){
	if(chkKorea(obj.value) > chknum){
		alert(message);
		
		obj.focus();
		obj.select();
		
		return false;
	}
	
	return true;
}

function checkTel(obj, message){
	if(!IsTel(obj.value)){
		alert(message);
		
		obj.focus();
		obj.select();
		
		return false;
	}
	
	return true;
}

function checkData(){
	var f         = document.forms[0];
	var checkCode = f.user_id.value;

	<%-- if(!checkEmpty(f.user_type, "<%=text.get("AD_134.MSG_0100")%>"))//사용자구분을 입력해주십시요.
		return false; --%>

	if(!checkEmpty(f.work_type,"<%=text.get("AD_134.MSG_0101")%>"))//업무권한을 입력해주십시요.
		return false;

	if(!checkEmpty(f.user_id, "<%=text.get("AD_134.MSG_0102")%>"))//사용자 ID를 입력하셔야 합니다.
		return false;

	if(!checkEmpty(f.user_name_loc, "<%=text.get("AD_134.MSG_0103")%>"))//사용자명(국문)을 입력해주십시요.
		return false;

	if(!checkKorea(f.user_name_loc, "<%=text.get("AD_134.MSG_0104")%>",40))//사용자명(국문)은 40자 이내입니다.
		return false;
<%
	if(!user_type.equals("S")){
%>
	if(!checkKorea(f.company_code, "<%=text.get("AD_134.MSG_0107")%>",10))//회사코드는 10자 이내입니다.
		return false;

	if(!checkEmpty(f.company_code, "<%=text.get("AD_134.MSG_0108")%>"))//회사코드를 선택해주십시요.
		return false;
<%
	}
%>
	if(!checkEmpty(f.phone_no_0, "<%=text.get("AD_134.MSG_0114")%>"))//전화번호를 입력해주십시요.
		return false;

	if(!checkTel(f.phone_no_0, "<%=text.get("AD_134.MSG_0115")%>"))//전화번호 형태로 입력해주십시요.
		return false;

	if(!checkKorea(f.email, "<%=text.get("AD_134.MSG_0116")%>",50))//이메일은 50자 이내입니다.
		return false;

	if(!checkEmpty(f.email, "<%=text.get("AD_134.MSG_0117")%>"))//이메일을 입력해주십시요.
		return false;

	if(!checkTel(f.mobile_no_0, "<%=text.get("AD_134.MSG_0120")%>"))//전화번호 형태로 입력해주십시요.
		return false;

	if(!checkTel(f.fax_no_0, "<%=text.get("AD_134.MSG_0121")%>"))//팩스번호 형태로 입력해주십시요.
		return false;

	if(!checkKorea(f.zip_code, "<%=text.get("AD_134.MSG_0122")%>",10))//우편번호는 10자 이내입니다.
		return false;
	
	if(!checkKorea(f.city_code, "<%=text.get("AD_134.MSG_0125")%>", 10))//도시는 10자 이내입니다.
		return false;

	if(!checkKorea(f.state, "<%=text.get("AD_134.MSG_0126")%>", 20))//지역은 20자 이내입니다.
		return false;

	if(!checkKorea(f.address_loc, "<%=text.get("AD_134.MSG_0127")%>", 200))//주소(한글)은 200자 이내입니다.
		return false;

	return true;
}

function PopupManager(part) {
	var url = "";
	var f   = document.forms[0];
	
	if(part == "CTRL_CODE"){ //구매담당직무
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
}

//구매담당직무
function getCtrlManager(code, text){
	document.form.ctrl_code_data.value = code;
	document.form.ctrl_code.value = text;
}

function Save(){
	pw = document.form.login_user_password.value;
	if(pw == ""){
		alert("수정자 패스워드를 입력하세요");
		document.getElementById("login_user_password").focus();
		return;
	}
	 
	var f = document.forms[0];

	var password = f.password.value;
	var password2 = f.password2.value;

	if(password != "") {
		/*
		if(password2 == "") {
			alert("새 패스워드를 한번 더 넣어주세요");
			
			return;
		}
		else {
			if(password != password2) {
				alert("새 패스워드 두개가 일치하지 않습니다.");
				
				return;
			}
		}

    	if(!(document.form.password.value == document.form.password2.value) ) {
            alert("비밀번호가 일치하지 않습니다.");
            document.form.password.focus();
            document.form.password.select();
            
            return false;
        }
		*/
    	
    	// 비밀번호 정책 적용체크
    	// js/pwdPolicy.js : isNewValidPwd
    	/*
    	if ( !isNewValidPwd(f.user_id.value, f.password.value) )
    	{
    		return;
    	}
		*/
    	/* //비밀번호 체크
    	message = isValidPasswd();
    	if(message != "SUCCESS")
    	{
    			alert(message);
    			f.password.focus();
    			f.password.select();
    			return;
    	} */
    	
    	//사용자 ID, 비밀번호 동일체크
    	/*
    	message = isEqualsIdPasswd();
    	if(message != "SUCCESS")
    	{
    			alert(message);
    			f.password.focus();
    			f.password.select();
    			return;
    	}
    	*/
    	//비밀번호확인 체크
    	/*
    	message = isValidConfirmPasswd();
    	if(message != "SUCCESS")
    	{
    			alert(message);
    			f.password2.focus();
    			f.password2.select();
    			return;
    	}
    	*/    	
    	
<%-- 
        if(chkKorea(document.forms[0].password.value) < 6 || chkKorea(document.forms[0].password.value) > 10) {
            //alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(1)");
            alert("<%=text.get("AD_134.MSG_0132")%>");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            
            return false;
        }

        if(!chkMixing(document.forms[0].password.value)) {
            //alert("비밀번호는 영문자와 숫자를 혼용하여 6~10자만 가능합니다.(2)");
            alert("<%=text.get("AD_134.MSG_0133")%>");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            
            return false;
        }

        if(!chkIdIsEquals(document.forms[0].password.value)) {
            //alert("비밀번호는 ID가 포함되어 있으면 안됩니다.(3)");
            alert("<%=text.get("AD_134.MSG_0134")%>");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            
            return false;
        }

        if(!chkInputRepeat(document.forms[0].password.value)) {
            //alert("비밀번호는 같은 문자를 3번 이상 반복 입력할 수 없습니다.(4)");
            alert("<%=text.get("AD_134.MSG_0135")%>");
            document.forms[0].password.focus();
            document.forms[0].password.select();
            
            return false;
        } --%>

	}

	if(!checkData()) return;

	//if(!confirm("수정하시겠습니까?"))
	if(!confirm("<%=text.get("AD_134.MSG_0136")%>"))
		return;
	
// 	var jqa = new jQueryAjax();
// 	jqa.action = "user_status_pop_up_save.jsp";
//   	jqa.submit();
	
		f.method = "POST";
		f.action = "user_status_pop_up_save.jsp";
		f.submit();	
}

function isValidPasswd()
{
	var strPassword = LRTrim(document.form1.PASSWORD.value);
	if(strPassword.length == 0)
	{
		return "비밀번호를 입력하셔야 합니다.";
	}

	// /include/wisehub_scripts.jsp
// 	if(!hangulCheckCommon(strPassword))
// 	{
// 		return "비밀번호에는 한글을 사용할 수 없습니다.";
// 	}

	return "SUCCESS";
}

function isValidConfirmPasswd()
{
	var strPassword      = LRTrim(document.form.password.value);
	var confirm_password = LRTrim(document.form.password2.value);

	if(confirm_password.length == 0) {
		return "비밀번호확인을 입력하셔야 합니다.";
	}

	if(strPassword != confirm_password) {
		return "비밀번호가 다릅니다.";
	}

	return "SUCCESS";
}

function isEqualsIdPasswd() {

	return "SUCCESS";
}



function Check() {
	var f = document.forms[0];
	f.i_flag.value = '<%=i_flag%>';
	f.i_chk_user_id.value = f.i_chk_user_id.value.toUpperCase();
	var i_user_id = f.i_chk_user_id.value;
	var i_passwd = f.i_chk_passwd.value;

	if(i_user_id == "") {
		//alert("아이디를 입력해주세요..");
		alert("<%=text.get("AD_134.MSG_0137")%>");
		return;
	}
	else {
		if(i_passwd == "") {
			//alert("패스워드를 입력해주세요..");
			alert("<%=text.get("AD_134.MSG_0138")%>");
			return;
		}
	}

	if(i_user_id != "" && i_passwd != "")
		parent.work.location.href="user_status_pop_up_chk.jsp?i_user_id="+ i_user_id+"&i_passwd="+i_passwd;
}

function getCity(code, text) {
	document.forms[0].city_code.value = code;
	document.forms[0].text_city_code.value = text;
}

/*
function getDept(code, text) {
	document.forms[0].dept.value = code;
	document.forms[0].text_dept.value = text;
}
*/

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
//	document.forms[0].text_company_code2.value = code;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].company_code.value = code;
//	document.forms[0].text_company_code2.value = code;
}


function getTimeZone(code,text) {
	document.forms[0].time_zone.value = code;
	document.forms[0].text_time_zone.value = text;
}


function actionedit(){
	var f = document.forms[0];
	user_type = f.user_type.value;
	text_user_type = f.user_type.options[f.user_type.selectedIndex].text;

	if ( user_type == "P" || user_type == "S" ) {
		f.edit.value = "Y";
		f.company_code.value = "";
//		f.text_company_code2.value = "";
	}
	else {
			f.company_code.value = user_type;
//		f.text_company_code2.value = user_type;
		f.edit.value = "N";

	}

	if ( user_type == "CJ00" ){
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "visible";
			if(n>1) document.all["g"+n].disabled = "false";
		}
	}
	else{
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "hidden";
			if(n>1) document.all["g"+n].disabled = "true";
		}
	}

	f.dept.value = "";
//  f.text_dept.value = "";
	f.position.value = "";
	f.text_position.value = "";
	f.manager_position.value = "";
	f.text_manager_position.value = "";
	f.ctrl_code.value = "";
	f.ctrl_code_data.value = "";
}


function getprofile(){
	var url = "";
	<%if("MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))){%>
		url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP7099&function=Setprofile&values=1";
	<%}else if("MUP141000001".equals(info.getSession("MENU_PROFILE_CODE")) || "MUP210200001".equals(info.getSession("MENU_PROFILE_CODE"))){%>
		url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP7097&function=Setprofile&values=1";
	<%}else if("MUP150700003".equals(info.getSession("MENU_PROFILE_CODE"))){%>
		url = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP7098&function=Setprofile&values=1";
	<%}%>
	Code_Search(url,'','','','','');
}

function Setprofile(code,name) {
	var f = document.forms[0];
	
	f.menu_profile_code.value = code;
	f.menu_name.value = name;
}


function searchProfile(part){
	var f = document.forms[0];

	if( part == "company_code" ){
		if (f.edit.value == "N")
			return;

		if (f.user_type.value  == ""){
			//alert("사용자 구분을 먼저 선택해야 합니다.");
			alert("<%=text.get("AD_134.MSG_0139")%>");

			return;
		}

		if (f.user_type.value  == "P"){
			PopupCommon1("SP0055", "getPartner_code", "", "", "");

		}
		else if (f.user_type.value  == "S"){
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	if(part == "dept"){
		if (f.user_type.value  == "P" || f.user_type.value  == "S"){
			//PopupCommon2("SP9053", "getDept", "M105", "","");
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getDept&values=<%=house_code%>&values=M105&values=&values=&width=700";
       		Code_Search(url3, '', '', '', '720', '500');
		}
		else{
			//if(!checkEmpty(f.company_code,"회사단위를 먼저 선택해야 합니다."))
			if(!checkEmpty(f.company_code,"<%=text.get("AD_134.MSG_0141")%>"))
				return;
			//PopupCommon2("SP0022", "getDept", f.company_code.value, "코드","부서명");
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+f.company_code.value+"&values=&values=/&width=700&desc=code&desc=name";
       		Code_Search(url3, '', '', '', '720', '500');
		}

	}
	else if(part == "pr"){
		//PopupCommon2("SP9053", "getPr", "M062", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getPr&values=<%=house_code%>&values=M062&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
	}
	else if(part == "posi"){
			//PopupCommon2("SP9053", "getPosition", "M106", "","");
			var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getPosition&values=<%=house_code%>&values=M106&values=&values=&width=700";
       		Code_Search(url3, '', '', '', '720', '500');
	}
	else if(part == "manager_posi") {
		//PopupCommon2("SP9053", "getmanagerPosition", "M107", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=getmanagerPosition&values=<%=house_code%>&values=M107&values=&values=&width=700";
      	Code_Search(url3, '', '', '', '720', '500');
    }
	else if(part == "time_zone") {
		//PopupCommon2("SP9001", "getTimeZone", "M075", "","");
		var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9001&function=getTimeZone&values=M075&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }
}

function  SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].ctrl_code_data.value = ls_ctrl_code;
}

function checkCtrl_code(){
	/*
	var f = document.forms[0];

	if ( "<%=company_code %>" == "CJ00" ) {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "visible";
			if(n>1) document.all["g"+n].disabled = "false";
		}
	}
	else {
		for(n=1;n<=4;n++) {
			document.all["g"+n].style.visibility = "hidden";
			if(n>1) document.all["g"+n].disabled = "true";
			f.ctrl_code.value = "";
			f.ctrl_code_data.value = "";
		}
	}
	*/
}


function chkMixing(chkstr){
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

function chkIdIsEquals(chkstr){
    var user_id = document.forms[0].user_id.value;

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

function set_init(){
	f = document.form;

	if("<%=info.getSession("USER_TYPE")%>" == "S" || "<%=info.getSession("USER_TYPE")%>" == "P"){
		for(var i = 0; i < f.user_type.length; i++){
			if(f.user_type.options[i].value == "<%=info.getSession("USER_TYPE")%>"){
				f.user_type.selectedIndex = i;
				f.user_type.disabled = true;
			}
		}

	}
}
</Script>
</head>
<body onload="checkCtrl_code(); set_init();" >
<s:header popup="true">
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("AD_134.TEXT_0100");
%>
<form name="form" id="form" action="">
	<input type="hidden" name="program" id="program" value="use_bd_upd2">
	<input type="hidden" name="edit" id="edit" value="Y">
	<input type="hidden" name="user_info_flag" id="user_info_flag" value="N">
	<input type="hidden" name="pr_location" id="pr_location" value="<%=pr_location%>">
	<input type="hidden" name="text_pr_location" id="text_pr_location" value="<%=pr_location_name%>">
	<input type="hidden" name="zip_code" id="zip_code" value="<%=zip_code%>">
	<input type="hidden" name="time_zone" id="time_zone" value="<%=time_zone%>">
	<input type="hidden" name="text_time_zone" id="text_time_zone" value="<%=time_zone_name%>">
	<input type="hidden" name="city_code" id="city_code" value="<%=city_code%>">
	<input type="hidden" name="state" id="state" value="<%=state%>">
	<input type="hidden" name="employee_no" id="employee_no" value="<%=employee_no%>">
	<input type="hidden" name="plm_user_flag" id="plm_user_flag" value="<%=plm_user_flag%>">
	<input type="hidden" name="i_flag" id="i_flag" value="<%=i_flag%>">
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5"> </td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display: none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0101")%></td>
									<td width="20%" class="data_td">
										<select name="user_type" id="user_type" class="input_re" onChange="actionedit()">
											<option value=""></option>
											<%=LB_USER_TYPE%>
										</select>
										<input type="hidden" name="origin_user_type" id="origin_user_type" value="<%=info.getSession("USER_TYPE") %>">
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0102")%></td>
									<td width="20%" class="data_td">
										<select name="work_type" id="work_type" class="input_re">
											<option value=""></option>
											<%=LB_WORK_TYPE%>
										</select>
									</td>
<%
	if(!user_type.equals("S") && !user_type.equals("P")){
%>									
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0103")%></td>
									<td width="20%" class="data_td">
										<select name="company_code" id="company_code" class="input_re">
											<option value=""></option>
<%
		String lb = ListBox(request, "SL0006" ,info.getSession("HOUSE_CODE")+"#", company_code);

		out.println(lb);
%>
										</select>
									</td>
<%
	}
	else{
%>
									<td style="display: none;">
										<input type="hidden" name="company_code" id="company_code" value="<%=(!user_type.equals("S") && !user_type.equals("P")) ? info.getSession("COMPANY_CODE") : company_code%>">
									</td>
<%
	}
%>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
<%
	if(!i_user_id.equals("")) {
%>
						<TD>
<script language="javascript">
btn("javascript:Save()","<%=text.get("BUTTON.save")%>");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:parent.window.close()","<%=text.get("BUTTON.close")%>");
</script>
						</TD>
<%
	}
%>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
<%
	if(i_flag.equals("P")){
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0104")%></td>
									<td width="35%" class="data_td">
										<input type="text" name="i_chk_user_id" id="i_chk_user_id" value="" size="20" class="inputsubmit">
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0105")%></td>
									<td width="35%" class="data_td">
										<input type="password" name="i_chk_passwd" id="i_chk_passwd" value="" size="20" class="inputsubmit">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<%--
<script language="JavaScript" src="/kr/jscomm/body_bot_bar.js" type="text/javascript"></script>
 --%>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<TD>
<script language="javascript">
btn("javascript:Check()","<%=text.get("BUTTON.search")%>");
</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>	
<%--
<script language="JavaScript" src="/kr/jscomm/body_bot_bar.js" type="text/javascript"></script>
 --%>
<%
	}
%>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<colgroup>
				                	<col width="180px" />
				                	<col width="280px" />
				                	<col width="180px" />
				                	<col />
				              	</colgroup>
								<tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0106")%></td>
									<td class="data_td">
										<%=i_user_id%>
										<input type="hidden" name="user_id" id="user_id" value="<%=i_user_id%>">
										<input type="hidden" name="old_pwd" id="old_pwd" value="">
									</td>
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사코드</td>
								    <td class="data_td" colspan="3">
								        <input type="text" name="company_code2" id="company_code2" value="<%=company_code%>" class="input_data2" readonly  >
								    </td>		
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<Tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0107")%></td>
									<td class="data_td">
										<input type="password" name="password" id="password" value="" size="20" maxlength="10" class="input_re"  style="ime-mode:disabled;" npkencrypt="on">
									</td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0108")%></td>
									<td class="data_td">
										<input type="password" name="password2" id="password2" value="" size="20" maxlength="10" class="input_re"  style="ime-mode:disabled;" npkencrypt="on">
									</td>
								</Tr>
								<Tr>
									<td class="title_td">&nbsp;</td>
									<td colspan="3" class="data_td">
												<img src="/images/blt_2depth.gif"> 비밀번호는 영문,숫자,특수문자중 2가지 이상을 조합할 경우 10자리,<br/>
												&nbsp;&nbsp;3가지 이상을 조합할 경우 8자리로 구성하여 주십시오. <br/>
									</td>
									
								</Tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0109")%></td>
									<td class="data_td" <%= ("WOORI".equals(user_type))?"":"colspan='3'" %>>
										<input type="text" name="user_name_loc" id="user_name_loc" value="<%=user_name_loc%>" style="width:<%=("WOORI".equals(user_type))?"95%":"37%"%>" maxlength="40" class="input_re">
										<input type="hidden" name="dept" id="dept" value="<%=dept%>" size="7" maxlength="10" class="input_re" readOnly>										
									</td>
									<% if( "WOORI".equals(user_type) ) { %> 
								    <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;UC쪽지</td>
								    <td class="data_td">
								      <select id="uc_yn" name="uc_yn" class="inputsubmit">
										<option value="Y" <%=("Y".equals(UC_YN))?"selected":""%>>수신</option>
										<option value="N" <%=("N".equals(UC_YN))?"selected":""%>>미수신</option>		
									</select>
								    </td>
								    <% }else{ %>
								    <input type="hidden" name="uc_yn" id="uc_yn" value="N">
								    <% } %>     									
								</tr>															
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0114")%></td>
									<td class="data_td">
										<input type="text" name="phone_no_0" id="phone_no_0" value="<%=phone_no%>" size="12" maxlength="20" class="input_re">
										<input type="hidden" name="phone_no_1" id="phone_no_1" value="" size="3" maxlength="4" class="input_re">
										<input type="hidden" name="phone_no_2" id="phone_no_2" value="" size="4" maxlength="4" class="input_re">
										<input type="hidden" name="phone_no_3" id="phone_no_3" value="" size="4" maxlength="4" class="input_re">
									</td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0116")%></td>
									<td class="data_td">
										<input type="text" name="email" id="email" value="<%=email%>" size="30" maxlength="50" class="input_re">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0115")%></td>
									<td  class="data_td">
										<input type="text" name="mobile_no_0" id="mobile_no_0" value="<%=mobile_no%>" size="12" maxlength="20" class="inputsubmit">
										<input type="hidden" name="mobile_no_1" id="mobile_no_1" value="" size="3" maxlength="4" class="inputsubmit">
										<input type="hidden" name="mobile_no_2" id="mobile_no_2" value="" size="4" maxlength="4" class="inputsubmit">
										<input type="hidden" name="mobile_no_3" id="mobile_no_3" value="" size="4" maxlength="4" class="inputsubmit">
									</td>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0117")%></td>
									<td  class="data_td">
										<input type="text" name="fax_no_0" id="fax_no_0" value="<%=fax_no%>" size="12" maxlength="20" class="inputsubmit">
										<input type="hidden" name="fax_no_1" id="fax_no_1" value="" size="3" maxlength="3" class="inputsubmit">
										<input type="hidden" name="fax_no_2" id="fax_no_2" value="" size="4" maxlength="4" class="inputsubmit">
										<input type="hidden" name="fax_no_3" id="fax_no_3" value="" size="4" maxlength="4" class="inputsubmit">
									</td>
								</tr>
								<tr style="display: none;">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr style="display: none;">
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0118")%></td>
									<td  class="data_td">
										<input type="text" name="position" id="position" value="<%=position%>" size="5" maxlength="10" class="inputsubmit" readOnly>
										<a href="javascript:searchProfile('posi')">
											<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
										</a>
										<input type="text" name="text_position" id="text_position" value="<%=position_name%>" size="10" maxlength="200" class="input_empty" readOnly>
									</td>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0119")%></td>
									<td  class="data_td">
										<input type="text" name="manager_position" id="manager_position" value="<%=manager_position%>" size="5" maxlength="10" class="inputsubmit" readOnly>
										<a href="javascript:searchProfile('manager_posi')">
											<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
										</a>
										<input type="text" name="text_manager_position" id="text_manager_position" value="<%=manager_position_name%>" size="10" class="input_empty" readOnly>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0128")%></td>
									<td class="data_td" colspan="3">
										<input type="text" name="address_loc" id="address_loc" value="<%=address_loc%>" size="98%" maxlength="200" class="inputsubmit">
									</td>
								</tr>								
<%
	if (i_flag.equals("N") && is_buyer) {
%>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_134.TEXT_0130")%></td>
									<td class="data_td" colspan="3">
										<input type="text" name="menu_profile_code" id="menu_profile_code" value="<%=menu_profile_code%>" size="20" maxlength="20" class="inputsubmit" readonly>
										<a href="javascript:getprofile()">
											<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
										</a>
										<input type="text" name="menu_name" id="menu_name" value="<%=menu_profile_name%>" size="20" class="input_empty" readonly>
									</td>
								</tr>
<%
	}
	else{
%>
								<tr style="display: none;">
									<td>
										<input type="hidden" name="menu_profile_code" id="menu_profile_code" value="<%=menu_profile_code%>" class="inputsubmit" readonly>
									</td>
								</tr>
<%
	}
%>
								<tr id="tr_password">
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수정자패스워드</td>
									<td class="data_td" colspan="3">
										<input  type="password"  name="login_user_password" id="login_user_password" size="20" maxlength="20" class="input_re"  npkencrypt="on">
									</td>
								</tr>
							</table>
							
<%--
<script language="JavaScript" src="../../jscomm/body_bot_bar.js" type="text/javascript"></script>
 --%>
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