<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SUP_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SUP_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지
%>


<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID= "SUP_003"; %>

<!-- Session 정보 //Parameter 정보 -->
<%
	String house_code  = info.getSession("HOUSE_CODE");
	String vendor_code = info.getSession("COMPANY_CODE");
	String flag        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	//String user_id     = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	//String user_id     = info.getSession("ID");
	// 무조건 Session 에서 ID를 가져온다. 취약점 점검 : 2015.09.23 
	String user_id     = info.getSession("ID");

	//if(JSPUtil.nullToEmpty(request.getParameter("user_id"))!=null || JSPUtil.nullToEmpty(request.getParameter("user_id"))!=""){
	//	user_id     = JSPUtil.nullToEmpty(request.getParameter("user_id"));
	//}else{
	//	user_id     = info.getSession("ID");
	//}
	
	String user_flag   = JSPUtil.nullToEmpty(request.getParameter("user_flag"));	//마이페이지 수정인지 체크 Y

	String PASSWORD = "";
	String USER_TYPE = "";
	String WORK_TYPE = "";
	String USER_NAME_LOC = "";
	String USER_NAME_ENG = "";
	String DEPT = "";
	String DEPT_NAME = "";
	String EMPLOYEE_NO = "";
	String EMAIL = "";
	String PHONE_NO1 = "";
	String PHONE_NO2 = "";
	String POSITION = "";
	String MANAGER_POSITION = "";
	String FAX_NO = "";
	String ZIP_CODE = "";
	String ADDRESS_LOC = "";
	String ADDRESS_ENG = "";
	String LANGUAGE = "";
	String TIME_ZONE = "";
	String COUNTRY = "";
	String CITY_CODE = "";
	
	String temp_user_type = "";
	String temp_work_type = "";
	
%>

<%
	String[][] str = new String[1][36];
	//for(int i=0; i<35; i++) str[0][i]="";

if( user_id != "" )  {
	
	String[] args = {house_code, user_id};
	Object[] obj = {(Object[])args};

	SepoaOut value = ServiceConnector.doService(info, "s6030", "CONNECTION","getDisplay_ict", obj);
	if(value.status == 1)
	{
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		if ( wf.getRowCount() > 0 ){
			str = wf.getValue();
			
			PASSWORD         = wf.getValue("PASSWORD", 0);
			USER_TYPE        = wf.getValue("USER_TYPE", 0);
			WORK_TYPE        = wf.getValue("WORK_TYPE", 0);
			                 
			USER_NAME_LOC    = wf.getValue("USER_NAME_LOC", 0);
			USER_NAME_ENG    = wf.getValue("USER_NAME_ENG", 0);
			DEPT             = wf.getValue("DEPT", 0);
			DEPT_NAME        = wf.getValue("DEPT_NAME", 0);
			EMPLOYEE_NO      = wf.getValue("EMPLOYEE_NO", 0);
			EMAIL            = wf.getValue("EMAIL", 0);
			PHONE_NO1        = wf.getValue("PHONE_NO1", 0);
			PHONE_NO2        = wf.getValue("PHONE_NO2", 0);
			POSITION         = wf.getValue("POSITION", 0);
			MANAGER_POSITION = wf.getValue("MANAGER_POSITION", 0);
			FAX_NO           = wf.getValue("FAX_NO", 0);
			ZIP_CODE         = wf.getValue("ZIP_CODE", 0);
			ADDRESS_LOC      = wf.getValue("ADDRESS_LOC", 0);
			ADDRESS_ENG      = wf.getValue("ADDRESS_ENG", 0);
			LANGUAGE         = wf.getValue("LANGUAGE", 0);
			TIME_ZONE        = wf.getValue("TIME_ZONE", 0);
			COUNTRY          = wf.getValue("COUNTRY", 0);
			CITY_CODE        = wf.getValue("CITY_CODE", 0);
		}
	}
	
	
	if( "WOORI".equals(USER_TYPE) ) {
		temp_user_type = "WOORI";
	} else {
		temp_user_type = "Supplier";
	}
	
	if( "Z".equals(WORK_TYPE) ) {
		temp_work_type = "어드민";
	} else {
		temp_work_type = "일반";
	}
	
}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/pluginfree/js/nppfs-1.13.0.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">
<!--
$(document).ready(function(){
	npPfsStartup(document.form1, false, true, false, false, "npkencrypt", "on");
});

function checkData() {

	var frm = document.form1;


//	사용자명 (국문)
	if(chkKorea(frm.user_name_loc.value) > 40) {
        alert("사용자명(국문)은 40자 이내입니다.");
        frm.user_name_loc.focus();
        frm.user_name_loc.select();
        return false;
    	}

	if(isEmpty(frm.user_name_loc.value)){
	 	alert("사용자명(국문)을 넣어주세요.");
	 	frm.user_name_loc.focus();
	 	return false;
	}

//	사용자명 (영문)
	if(chkKorea(frm.user_name_eng.value) > 40) {
        alert("사용자명(영문)은 40자 이내입니다.");
        frm.user_name_eng.focus();
        frm.user_name_eng.select();
        return false;
    	}
   


//	부서코드
//	if(chkKorea(frm.dept.value) > 10) {
//        alert("부서코드는 10자 이내입니다.");
//        frm.dept.focus();
//        frm.dept.select();
//        return false;
//    	}

 
//	사원번호
/* 	if(chkKorea(frm.employee_no.value) > 10) {
        alert("사원번호 10자 이내입니다.");
        frm.employee_no.focus();
        frm.employee_no.select();
        return false;
    	}
 */
  

//	전화번호
	/* if(chkKorea(frm.phone_no.value) > 20) {
        alert("전화번호는 20자 이내입니다.");
        frm.phone_no.focus();
        frm.phone_no.select();
        return false;
    	}

	if(isEmpty(frm.phone_no.value)){
	 	alert("전화번호를 넣어주세요.");
	 	frm.phone_no.focus();
	 	return false;
	}

	if(!IsTel(frm.phone_no.value)) {
    	alert("전화번호 형태로 입력해주세요");
    	frm.phone_no.focus();
        frm.phone_no.select();
        return false;
    }
 */
//	이메일
	/* if(chkKorea(frm.email.value) > 50) {
        alert("이메일은 50자 이내입니다.");
        frm.email.focus();
        frm.email.select();
        return false;
    	}

	if(isEmpty(frm.email.value)){
	 	alert("이메일을 넣어주세요.");
	 	frm.email.focus();
	 	return false;
	}

	var re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	if(!re.test(frm.email.value)) {
		alert("이메일이 잘못되었습니다.");
		frm.email.focus();
        return false;
    } */

//	사용언어
	/* if(chkKorea(frm.language.value) > 5) {
        alert("사용언어는 5자 이내입니다.");
        frm.language.focus();
        frm.language.select();
        return false;
    	}

	if(isEmpty(frm.language.value)){
	 	alert("사용언어를 넣어주세요.");
	 	frm.language.focus();
	 	return false;
	} */



//	팩스번호
	/* if(chkKorea(frm.fax_no.value) > 20) {
        alert("팩스번호  20자 이내입니다.");
        frm.fax_no.focus();
        frm.fax_no.select();
        return false;
    }
    if(!IsTel(frm.fax_no.value)) {
    	alert("팩스번호 형태로 입력해주세요");
    	frm.fax_no.focus();
        frm.fax_no.select();
        return false;
    } */
	/*
    if(isEmpty(frm.fax_no.value)){
	 	alert("팩스번호를 넣어주세요.");
	 	frm.fax_no.focus();
	 	return false;
	}
	*/
	//	휴대폰
	/* if(chkKorea(frm.phone_no2.value) > 20) {
        alert("휴대폰번호  20자 이내입니다.");
        frm.phone_no2.focus();
        frm.phone_no2.select();
        return false;
    }
    if(!IsTel(frm.phone_no2.value)) {
    	alert("휴대폰번호 형태로 입력해주세요");
    	frm.phone_no2.focus();
        frm.phone_no2.select();
        return false;
    }

    if(isEmpty(frm.phone_no2.value)){
	 	alert("휴대폰번호를 넣어주세요.");
	 	frm.phone_no2.focus();
	 	return false;
	} */



//	직위
	/* if(chkKorea(frm.position.value) > 10) {
        alert("직위는 20자 이내입니다.");
        frm.position.focus();
        frm.position.select();
        return false;
    	} */

//	직책
	/* if(chkKorea(frm.manager_position.value) > 10) {
        alert("직책은 20자 이내입니다.");
        frm.manager_position.focus();
        frm.manager_position.select();
        return false;
    	} */

//	우편번호
	/* if(chkKorea(frm.zip_code.value) > 10) {
        alert("우편번호는 10자 이내입니다.");
        frm.zip_code.focus();
        frm.zip_code.select();
        return false;
    	} */

//	국가
	/* if(chkKorea(frm.country.value) > 2) {
        alert("국가는 2자 이내입니다.");
        frm.country.focus();
        frm.country.select();
        return false;
    	} */

//	도시
	/* if(chkKorea(frm.city_code.value) > 10) {
        alert("도시는 10자 이내입니다.");
        frm.city_code.focus();
        frm.city_code.select();
        return false;
    } */

    /* if(isEmpty(frm.city_code.value)){
	 	alert("도시를 넣어주세요.");
	 	frm.city_code.focus();
	 	return false;
	}
 */



//	지역
	

//	주소(한글)
	/* if(chkKorea(frm.address_loc.value) > 200) {
        alert("주소(한글)은 200자 이내입니다.");
        frm.address_loc.focus();
        frm.address_loc.select();
        return false;
    	}


    if(isEmpty(frm.address_loc.value)){
	 	alert("주소(한글)을 넣어주세요.");
	 	frm.address_loc.focus();
	 	return false;
	} */

//	주소(영문)
	/* if(chkKorea(frm.address_eng.value) > 200) {
        alert("주소(영문)은 200자 이내입니다.");
        frm.address_eng.focus();
        frm.address_eng.select();
        return false;
   	} */

    return true;
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
	var strPassword      = LRTrim(document.form1.password.value);
	var confirm_password = LRTrim(document.form1.password2.value);

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
	document.forms[1].flag.value = '<%=flag%>';
	document.forms[1].id.value = document.forms[1].id.value.toUpperCase();
	var user_id = document.forms[1].user_id.value;
	var passwd = document.forms[1].passwd.value;

	if(user_id == "") {
		alert("아이디를 입력해주세요..");
		return;
	}else {
		if(passwd == "") {
			alert("패스워드를 입력해주세요..");
			return;
		}
	}

	if(user_id != "" && passwd != "")
		parent.work.location.href="/kr/master/user/use_wk_chk2.jsp?user_id="+ user_id+"&passwd="+passwd;
}


// 공통스크립트 부분 --------------------------
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
   if ((retChar <  "0" || retChar  > "9") && (retChar <  "A" || retChar  > "Z") &&
    ((retCode  > 255) || (retCode <  0) || (retCode == 32 )))
     {
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
	document.forms[1].city_code.value = code;
	document.forms[1].text_city_code.value = text;
}

function getDept(code, text) {
	document.forms[1].dept.value = code;
	document.forms[1].text_dept.value = text;
}

function getPosition(code, text) {
	document.forms[1].position.value = code;
	document.forms[1].text_position.value = text;
}

function getPr(code, text) {
	document.forms[1].pr_location.value = code;
	document.forms[1].text_pr_location.value = text;
}

function getmanager_Position(code, text) {
	document.forms[1].manager_position.value = code;
	document.forms[1].text_manager_position.value = text;
}

function getPartner_code(code,text, type) {
	document.forms[1].company_code.value = code;
	document.forms[1].text_company_code.value = text;
	document.forms[1].text_company_code2.value = code;
}

function getVendor_code(code,text, texteng) {
	document.forms[1].company_code.value = code;
	document.forms[1].text_company_code.value = text;
	document.forms[1].text_company_code2.value = code;
}

function getLanguage(code,text) {
	document.forms[1].language.value = code;
	document.forms[1].text_language.value = text;
}

function getCountry(code,text) {
	document.forms[1].country.value = code;
	document.forms[1].text_country.value = text;
}

function getTimeZone(code,text) {
	document.forms[1].time_zone.value = code;
	document.forms[1].text_time_zone.value = text;
}


function actionedit() {

	user_type = document.forms[1].user_type.value;
	text_user_type = document.forms[1].user_type.options[document.forms[1].user_type.selectedIndex].text;

    if ( user_type == "P" || user_type == "S" ) {
		document.forms[1].edit.value = "Y";
   		document.forms[1].company_code.value = "";
		document.forms[1].text_company_code.value = "";
		document.forms[1].text_company_code2.value = "";
    } else {
    	document.forms[1].company_code.value = user_type;
		document.forms[1].text_company_code.value = text_user_type;
		document.forms[1].text_company_code2.value = user_type;
		document.forms[1].edit.value = "N";

    }

    document.forms[1].dept.value = "";
	document.forms[1].text_dept.value = "";
    document.forms[1].position.value = "";
	document.forms[1].text_position.value = "";
	document.forms[1].manager_position.value = "";
	document.forms[1].text_manager_position.value = "";

}

function searchProfile(fc) {
	var url = "";

	if( fc == "company_code" ) {

	   if (document.forms[1].edit.value == "N")
	   		return;

	   if (document.forms[1].user_type.value  == "")
	   {
			alert("사용자 구분을 먼저 선택해야 합니다.");
			return;
	   }

	   if (document.forms[1].user_type.value  == "P")
	   {
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

	   } else if (document.forms[1].user_type.value  == "S")
	   {
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
			return;
	   }

	}

	if(fc == "city") {
		if(document.forms[1].country.value == "") {
			alert("국가를 먼저 선택해야 합니다.");
			return;
		}else
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0019&function=getCity&values=<%=house_code%>&values="+document.forms[1].country.value+"&values=&values=";
	}

	else if(fc == "dept") {
		if (document.forms[1].user_type.value  == "P" || document.forms[1].user_type.value  == "S")
		{
			//url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0053&function=getDept&values=<%=house_code%>&values=M105";
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9029&function=getDept&values=<%=house_code%>&values=<%=vendor_code%>&values=C009&values=&values=";
		} else {

			if(document.forms[1].company_code.value == "") {
				alert("회사단위를 먼저 선택해야 합니다.");
				return;
			}
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+document.forms[1].company_code.value+"&values=&values=";
		}

	}
	else if(fc == "pr") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getPr&values=<%=house_code%>&values=M062&values=&values=";
	else if(fc == "posi") {
		//if (document.forms[1].user_type.value  == "P" || document.forms[1].user_type.value  == "S")
		//{

			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getPosition&values=<%=house_code%>&values=M106&values=&values=";
		//}


	}else if(fc == "manager_posi") {
		//if (document.forms[1].user_type.value  == "P" || document.forms[1].user_type.value  == "S")
		//{

			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getmanager_Position&values=<%=house_code%>&values=M107&values=&values=";
		//}
	}else if(fc == "language") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getLanguage&values=<%=house_code%>&values=M013&values=&values=";
	else if(fc == "country") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getCountry&values=<%=house_code%>&values=M001&values=&values=";
	else if(fc == "time_zone") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9001&function=getTimeZone&values=<%=house_code%>&values=M075&values=&values=";

	Code_Search(url,'','','','','');
}

function getprofile() {


 //화면 가운데로 배치
		var dim = new Array(2);

		dim = ToCenter('600','800');
		var top = dim[0];
		var left = dim[1];
	    var url = "/kr/admin/system/mu1_bd_ins3.jsp?flag=Y";


        Code_Search(url,'','','','800','600');



		//var win = window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes");
	    //win.focus();
}

function Setprofile(code,name) {

	document.forms[1].menu_profile_code.value = code;
	document.forms[1].menu_name.value = name;

}


function doSave() {
	var frm = document.form1;
	var old_password = frm.old_password.value;
	var password     = frm.password.value;
	var password2    = frm.password2.value;
	
	//사용자 구분(USER_TYPE) 코드로 세팅
	frm.user_type.value = '<%=USER_TYPE%>';
	
	//업무권한(WORK_TYPE) 코드로 세팅
	frm.work_type.value = '<%=WORK_TYPE%>';
	
	if(old_password == "") {
		alert("기존 비밀번호를 입력하여 주십시오.\r\n\r\n기존 비밀번호는 필수 입력사항입니다.");
		frm.old_password.focus();
		return;	
	}

	if(password != "") {
		
	}
	
	if(!checkData()) return;
	
	//alert("새비밀번호를 입력하지 않을 시에는 기존 비밀번호 그대로입니다.");
	
	/* form.method = "POST";
	form.target = "work";
  	form.action = "use_wk_upd2.jsp";
  	form.submit(); */
	//var frm = document.getElementById("form1");
	//alert(makeEncData(frm));

	frm.method = "POST";
	frm.target = "_self";
	if(LRTrim(frm.signed_msg.value) != ""){
		frm.action = "use_wk_upd3_ict.jsp";	// 사용처 없음
		usePageCharset = true;
		XecureSubmit(frm);
	}else{
		frm.action = "use_wk_upd2_ict_window10.jsp";
		frm.submit();
	}
		
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Check();
	}
}

-->
</Script>


<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

</script>
</head>

<body onload="" bgcolor="#FFFFFF" text="#000000" topmargin="0">
<!--//전자서명 start -->
<form name='xecure'><input type=hidden name='p'></form>
<!-- script language='javascript' src='/XecureObject/xecureweb.js'></script -->
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/pwdPolicy.js"></script>
<script language='javascript'>
PrintObjectTag();
</script>

<script language='javascript'>
//alert(document.XecureWeb.GetVerInfo());
//document.writeln( accept_cert );
</script>

<script>
function makemsg(size)
{
	var msg = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
	var data = "";
	var msg2 = "";
	var msg3 = "";
	var msg4 = "";
	
	for(i = 0 ; i < 10; i++) {
		data += msg;	
	}
	
	for(i = 0 ; i < 10; i++) {
		msg2 += data;
	}
	
	for(i = 0 ; i < 10 ; i++) 
		msg3 += msg2;

	for(i = 0 ; i < size ; i++)
		msg4 += msg3;
		
	return msg4;
}

function fnXecureLogin(){
	var frm = document.form1;
	var signedMsg = frm.signed_msg;
	signedMsg.value = Sign_with_option(0, frm.plain.value);
	
	if(signedMsg.value != ""){
		//suc
	    // frm.mode.value   = "setXecureLogin";
		 //frm.browser_language.value = "KO";
		 //frm.method = "POST";
         //frm.target = "_self";	//"hiddenFrame";
         //frm.action = "/servlets/sepoa.svl.co.co_login_process";
         //frm.action = "/common/sign_result.jsp"
         //frm.action = "/XecureDemo/sign_result.jsp"
         //frm.submit();
		//XecureSubmit(frm);
		
	}
	else{
		//fail
		alert("사용자 인증에 실패하였습니다.");
	}
}

function onlyNumber(keycode){
	/* alert(keycode); */
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}

</script>
<!--//전자서명 end -->
<s:header popup="true">
<!--내용시작-->
<form name="form1" id="form1" method=post >

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				사용자 수정
			</td>
		</tr>
	</table>
	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	
	<textarea style="display:none" cols="120" rows="1" name="plain" id="plain">epro.wooriepro.com</textarea>
	<textarea style="display:none" cols="120" rows="1" name="signed_msg" id="signed_msg"></textarea>
	
	<input type="hidden" name="user_flag" id="user_flag" value="<%=user_flag%>" />
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_td" width="18%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사용자 구분
									</td>
									<td class="data_td" width="32%" >
										<input type="text" name="user_type" id="user_type" value="<%=temp_user_type%>" class="input_data2" readonly  >
									</td>
									<td class="title_td" width="15%" style="display:none">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;업무권한
									</td>
									<td class="data_td" style="display:none">
										<input type="text" name="work_type" id="work_type" value="<%=temp_work_type%>" class="input_data2" readonly >
									</td>     
									<td class="title_td" width="15%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;회사코드
									</td>
									<td class="data_td">
										<input type="text" name="company_code" id="company_code" value="<%=vendor_code%>" class="input_data2" readonly  >
									</td>

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
				<table cellpadding="2" cellspacing="0">
					<tr>
						<td><script language="javascript">btn("javascript:doSave()","저 장")</script></td>
						<td><script language="javascript">btn("javascript:parent.window.close()","닫 기")</script></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
																															
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_td" width="18%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사용자 ID<br>
									</td>
									<td class="data_td" >
										<table cellpadding="0">
											<tr>
												<td>
													<input type="text" name="user_id" id="user_id" size="15" maxlength="10" class="input_data2" value="<%=user_id%>" readonly  >
												</td>        
											</tr>
										</table>
										
										<input type="hidden" name="duplicate" value="F">
									</td> 
									<td class="title_td" width="15%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;기존비밀번호
									</td>
									<td class="data_td" width="35%">
										<input type="password" name="old_password" id="old_password" style="width:95%" maxlength="100" class="input_re" value=""  npkencrypt="on">
									</td>     
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr>
									<td class="title_td" width="18%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;새 비밀번호
									</td>
									<td class="data_td" width="32%">
										<input type="password" name="password" id="password" style="width:95%" maxlength="100" class="inputsubmit" value="" onKeyUp="return chkMaxByte(150, this, '비밀번호');"  npkencrypt="on">
									</td>
									<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;새 비밀번호확인</td>
									<td class="data_td" width="35%">
										<input type="password" name="password2" id="password2" style="width:95%" maxlength="100" class="inputsubmit" value=""   npkencrypt="on">
									</td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;</td>
									<td colspan="3" class="data_td">
										<img src="/images/blt_2depth.gif"> 비밀번호는 영문,숫자,특수문자중 2가지 이상을 조합할 경우 10자리,<br/>
										&nbsp;&nbsp;3가지 이상을 조합할 경우 8자리로 구성하여 주십시오. <br/>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자명(국문)</td>
									<td class="data_td" colspan="3">
										<input type="text" name="user_name_loc" id="user_name_loc" style="width:95%" maxlength="40" class="input_re" value="<%=USER_NAME_LOC%>" onKeyUp="return chkMaxByte(40, this, '사용자명(국문)');">
									</td>
									<td class="title_td" style="display:none">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;사용자명(영문)</td>
									<td class="data_td" style="display:none">
										<input type="text" name="user_name_eng" id="user_name_eng" style="width:95%;ime-mode: disabled;" maxlength="40" class="inputsubmit" value="<%=USER_NAME_ENG%>" onKeyUp="return chkMaxByte(40, this, '사용자명(영문)');">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;회사코드 </td>
									<td class="data_td" colspan="3">
										<input type="text" name="text_company_code2" id="text_company_code2" style="width:95%"  value="<%=vendor_code%>" class="input_data2" readonly  >
									</td>
									<td class="title_td" style="display:none">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부서명</td>
									<td class="data_td" style="display:none">
										<input type="text" name="dept_name_loc" id="dept_name_loc"  style="width:95%" maxlength="100" class="inputsubmit" value="<%=DEPT_NAME%>" onKeyUp="return chkMaxByte(100, this, '부서명');" >
										<input type="hidden" name="dept" id="dept"  style="width:95%" maxlength="100" class="inputsubmit" value="<%=DEPT%>" onKeyUp="return chkMaxByte(100, this, '부서코드');" >
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr style="display:none">
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사원번호</td>
									<td class="data_td" colspan="3" width="85%">
										<input type="text" name="employee_no" id="employee_no" style="width:95%" maxlength="20" class="inputsubmit" value="<%=EMPLOYEE_NO%>" onKeyUp="return chkMaxByte(20, this, '사원번호');">       
									</td>
								</tr>
								<tr style="display:none">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr style="display:none">
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전화번호</td>
									<td class="data_td">
										<input type="text" name="phone_no" id="phone_no" style="width:95%;ime-mode: disabled;" maxlength="20" class="input_re" value="<%=PHONE_NO1%>" onKeyUp="return chkMaxByte(20, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n">
									</td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;이메일</td>
									<td class="data_td">
										<input type="text" name="email" id="email" style="width:95%;ime-mode: disabled;" maxlength="50" class="input_re" value="<%=EMAIL%>" onKeyUp="return chkMaxByte(50, this, '이메일');">
									</td>
								</tr>
								<tr style="display:none">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr style="display:none">
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;휴대폰</td>
									<td class="data_td" colspan="3">
										<input type="text" name="phone_no2" id="phone_no2" style="width:95%;ime-mode: disabled;" maxlength="20" class="input_re" value="<%=PHONE_NO2%>" data-dataType="n" onKeyUp="return chkMaxByte(20, this, '휴대폰');" onKeyPress="return onlyNumber(event.keyCode);">
									</td>
									<td class="title_td" style="display:none">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;팩스번호</td>
									<td class="data_td" style="display:none">
										<input type="text" name="fax_no" id="fax_no" style="width:95%;ime-mode: disabled;" maxlength="20" class="inputsubmit" value="<%=FAX_NO%>" data-dataType="n" onKeyUp="return chkMaxByte(20, this, '팩스번호');" onKeyPress="return onlyNumber(event.keyCode);">
									</td>
								</tr>
								<tr style="display:none">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr style="display:none">
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;직위</td>
									<td class="data_td" width="32%">
										<input type="text" name="position" id="position" value="<%=POSITION%>" size="5" maxlength="10" class="inputsubmit" readOnly >
										<a href="javascript:searchProfile('posi')">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
										</a>
										<input type="text" name="text_position" id="text_position" value="" size="20" class="input_data2" readOnly >
									</td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;직책</td>
									<td class="data_td">
										<input type="text" name="manager_position" id="manager_position" value="<%=MANAGER_POSITION%>" size="5" maxlength="10" class="inputsubmit" readOnly >
										<a href="javascript:searchProfile('manager_posi')">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
										</a>
										<input type="text" name="text_manager_position" id="text_manager_position" value="" size="20" class="input_data2" readOnly >
									</td>
								</tr>
								<tr style="display:none">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr style="display:none">
									<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용언어</td>
									<td class="data_td" colspan="3">
										<input type="text" name="language" id="language" value="<%=LANGUAGE%>" size="5" class="input_re" readOnly >
										<a href="javascript:searchProfile('language')">
											<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
										</a>
										<input type="text" name="text_language" id="text_language" value="한국어" size="15" maxlength="15" class="input_data2" readOnly >
									</tr>
									<tr style="display:none">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>    
									<tr style="display:none">
										<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;우편번호</td>
										<td class="data_td">
											<input type="text" name="zip_code" id="zip_code" style="width:95%;ime-mode: disabled;" maxlength="10" class="inputsubmit" value="<%=ZIP_CODE%>" onKeyUp="return chkMaxByte(10, this, '우편번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n">
										</td>
										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;시간대역</td>
										<td class="data_td" width="35%">
											<input type="text" name="time_zone" id="time_zone" value="<%=TIME_ZONE%>" size="5" class="inputsubmit" readOnly >
											<a href="javascript:searchProfile('time_zone')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<input type="text" name="text_time_zone" id="text_time_zone" value="GMT+09:00" size="12" maxlength="12" class="input_data2" readOnly >
										</td>
									</tr>	
									<tr style="display:none">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display:none">
										<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;국가</td>
										<td class="data_td" width="32%">
											<input type="text" name="country" id="country" value="<%=COUNTRY%>" size="5" class="input_re" readOnly >
											<a href="javascript:searchProfile('country')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<input type="text" name="text_country" id="text_country" value="한국" size="15" maxlength="15" class="input_data2" readOnly >
										</td>
										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;도시</td>
										<td class="data_td" width="35%">
											<input type="text" name="city_code" id="city_code" value="<%=CITY_CODE%>" size="5" maxlength="10" class="input_re" readOnly>
											<a href="javascript:searchProfile('city')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<input type="text" name="text_city_code" id="text_city_code" value="" size="10"  class="input_data2" readOnly>
										</td>
									</tr>
									<tr style="display:none">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>    
									<tr style="display:none">
										<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;주소(한글)</td>
										<td class="data_td" colspan="3">
											<input type="text" name="address_loc" id="address_loc" style="width:95%" maxlength="200" class="input_re" value="<%=ADDRESS_LOC%>" onKeyUp="return chkMaxByte(200, this, '주소(한글)');">
										</td>
									</tr>
									<tr style="display:none">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>    
									<tr style="display:none">
										<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;주소(영문)</td>
										<td class="data_td" colspan="3">
											<input type="text" name="address_eng" id="address_eng" style="width:95%;ime-mode: disabled;" maxlength="200" class="inputsubmit" value="<%=ADDRESS_ENG%>" onKeyUp="return chkMaxByte(200, this, '주소(영문)');">
										</td>
									</tr>
									<tr style="display:none">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>    
									<tr style="display:none">
										<td class="title_td" width="18%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공인인증서 등록</td>
										<td class="data_td" colspan="3" >
											<input type=button value=' 전자서명 가져오기 ' onClick='javascript:fnXecureLogin();' style="height: 25px;">
										</td>
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
				<td>
					<input type="hidden" name="flag" id="flag" value="<%=flag%>" >
				</td>
			</tr>
		</table>
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<input type="hidden" name="duplicate2" id="duplicate2" value="F">
					<input type="hidden" name="edit" id="edit" value="Y">
				</td>
			</tr>
		</table>
</form>

</s:header>


<%-- <s:grid screen_id="SUP_003" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>


