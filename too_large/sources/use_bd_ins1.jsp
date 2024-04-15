<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>


<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SUP_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SUP_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지
%>
<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID= "SUP_001"; %>

<!-- Session 정보 -->
<%
	String house_code = info.getSession("HOUSE_CODE");
	String vendor_code = info.getSession("COMPANY_CODE");
	String os_gb = info.getSession("OS_GB");
%>


<Script language="javascript">
//<!--
function isEqualsIdPasswd() {

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
function doSave()
{
	toUpper(); //입력한 ID를 대문자로 변환한다.
 	if(!checkData()) return;
	
 	var frm = document.getElementById("form");
 	
 // 비밀번호 정책 적용체크
	// js/pwdPolicy.js : isNewValidPwd
	/*
	if ( !isNewValidPwd(frm.user_id.value, frm.password.value) )
	{
		return;
	}
 	*/
	//사용자 ID, 비밀번호 동일체크
	/*
	message = isEqualsIdPasswd();
	if(message != "SUCCESS")
	{
			alert(message);
			frm.password.focus();
			frm.password.select();
			return;
	}
	*/
	//비밀번호확인 체크
	/*
	message = isValidConfirmPasswd();
	if(message != "SUCCESS")
	{
			alert(message);
			frm.password2.focus();
			frm.password2.select();
			return;
	}
	*/
	frm.method = "POST";
	//frm.target = "work";
	frm.action = "use_wk_ins1_window10.jsp?flag=B";
	frm.submit();
}

function checkData()
{

//	사용자 ID
 	checkCode = document.form.user_id.value;

 	if(isEmpty(document.form.user_type.value)){
	 	alert("사용자 구분을 입력해주십시요.");
	 	document.form.user_type.focus();
	 	return false;
	 }
 	if(isEmpty(document.form.work_type.value)){
	 	alert("업무권한을 입력해주십시요.");
	 	document.form.work_type.focus();
	 	return false;
	 }

 	if(chkKorea(checkCode) > 10) {
        alert("사용자 ID는 10자 이내입니다.");
        document.form.user_id.focus();
        document.form.user_id.select();
        return false;
    	}
	if(isEmpty(checkCode)){
	 	alert("사용자 ID를 입력해주십시요.");
	 	document.form.user_id.focus();
	 	return false;
	 }

//	비밀번호
	/*
	if(chkKorea(document.form.password.value) > 10) {
        alert("비밀번호는 10자 이내입니다.");
        document.form.password.focus();
        document.form.password.select();
        return false;
    	}
    */
	if(isEmpty(document.form.password.value)){
	 	alert("비밀번호를 입력해주십시요.");
	 	document.form.password.focus();
	 	return false;
	}
	
//	비밀번호 확인
	if(isEmpty(document.form.password2.value)){
	 	alert("비밀번호확인을 입력해주십시요.");
	 	document.form.password2.focus();
	 	return false;
	}
	/*
	if( !(document.form.password.value == document.form.password2.value) ) {
        alert("비밀번호가 일치하지 않습니다.");
        document.form.password.focus();
        document.form.password.select();
        return false;
    	}
     */
//	사용자명 (국문)
	if(chkKorea(document.form.user_name_loc.value) > 40) {
        alert("사용자명(국문)은 40자 이내입니다.");
        document.form.user_name_loc.focus();
        document.form.user_name_loc.select();
        return false;
    	}
	if(isEmpty(document.form.user_name_loc.value)){
	 	alert("사용자명(국문)을 입력해주십시요.");
	 	document.form.user_name_loc.focus();
	 	return false;
	}

//	회사코드
	if(chkKorea(document.form.company_code.value) > 10) {
        alert("회사코드는 10자 이내입니다.");
        document.form.company_code.focus();
        document.form.company_code.select();
        return false;
    	}
	if(isEmpty(document.form.company_code.value)){
	 	alert("회사코드를 선택해주십시요.");
	 	document.form.company_code.focus();
	 	return false;
	}   

//	전화번호
	if(chkKorea(document.form.phone_no.value) > 20) {
        alert("전화번호는 20자 이내입니다.");
        document.form.phone_no.focus();
        document.form.phone_no.select();
        return false;
    	}
	if(isEmpty(document.form.phone_no.value)){
	 	alert("전화번호를 입력해주십시요.");
	 	document.form.phone_no.focus();
	 	return false;
	}
	if(!IsTel(document.form.phone_no.value)) {
    	alert("전화번호 형태로 입력해주십시요.");
    	document.form.phone_no.focus();
        document.form.phone_no.select();
        return false;
    }
    
    

//	이메일
	if(chkKorea(document.form.email.value) > 50) {
        alert("이메일은 50자 이내입니다.");
        document.form.email.focus();
        document.form.email.select();
        return false;
    	}
	if(isEmpty(document.form.email.value)){
	 	alert("이메일을 입력해주십시요.");
	 	document.form.email.focus();
	 	return false;
	}
	var re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	if(!re.test(document.form.email.value)) {
		alert("이메일이 잘못되었습니다.");
		document.form.email.focus();
        return false;
    }

//	휴대폰
	if(chkKorea(document.form.mobile_no.value) > 20) {
        alert("휴대폰은 20자 이내입니다.");
        document.form.mobile_no.focus();
        document.form.mobile_no.select();
        return false;
    	}
    if(!IsTel(document.form.mobile_no.value)) {
    	alert("휴대폰번호 형태로 입력해주십시요.");
    	document.form.mobile_no.focus();
        document.form.mobile_no.select();
        return false;
    }
    if(isEmpty(document.form.mobile_no.value)){
	 	alert("휴대폰번호를 입력해주십시요.");
	 	document.form.mobile_no.focus();
	 	return false;
	}

//	팩스번호
	if(chkKorea(document.form.fax_no.value) > 20) {
        alert("팩스번호  20자 이내입니다.");
        document.form.fax_no.focus();
        document.form.fax_no.select();
        return false;
    }
    if(!IsTel(document.form.fax_no.value)) {
    	alert("팩스번호 형태로 입력해주십시요.");
    	document.form.fax_no.focus();
        document.form.fax_no.select();
        return false;
    }
    if(isEmpty(document.form.fax_no.value)){
	 	alert("팩스번호를 넣어주세요.");
	 	document.form.fax_no.focus();
	 	return false;
	}


//	우편번호
	if(chkKorea(document.form.zip_code.value) > 10) {
        alert("우편번호는 10자 이내입니다.");
        document.form.zip_code.focus();
        document.form.zip_code.select();
        return false;
    	}

//	지역
	if(chkKorea(document.form.pr_location.value) > 20) {
        alert("지역은 20자 이내입니다.");
        document.form.pr_location.focus();
        document.form.pr_location.select();
        return false;
    	}

//	주소(한글)
	if(chkKorea(document.form.address_loc.value) > 200) {
        alert("주소(한글)은 200자 이내입니다.");
        document.form.address_loc.focus();
        document.form.address_loc.select();
        return false;
    }
    if(isEmpty(document.form.address_loc.value)){
	 	alert("주소(한글)을 넣어주세요.");
	 	document.form.address_loc.focus();
	 	return false;
	}


	//중복확인값이 True인지 확인한다.
 	if (document.form.duplicate.value == "F")	{
 		alert("중복확인을 해주십시요.");
 		return;
 	}

    return true;
}



///////////////Modify Date : 09.25. 홍선희///////////////////////
	//입력한 ID 대문자로 변환.
	function toUpper() {
		document.form.user_id.value = document.form.user_id.value.toUpperCase();
	}


	//중복확인
	function goDuplicate() {
		
		var f = document.forms[0];
		
		f.duplicate.value = "T";
		toUpper(); //입력한 ID를 대문자로 변환한다.
		user_id = f.user_id.value;

		if(isEmpty(user_id)){
		 	alert("사용자 ID를 입력해주십시요.");
		 	f.user_id.focus();
		 	return;
		}
		if(user_id.length < 7){
			alert("사용자 ID는 7자 이상입니다.");
			return;
		}
		
		if(chkKorea(user_id) > 10) {
        	alert("사용자 ID는 10자 이내입니다.");
        	f.user_id.focus();
        	return;
    	}

		//alert(user_id);
		//parent.work.location.href = "use_wk_ins2.jsp?user_id="+user_id;
		
		f.method = "POST";
		f.target = "childFrame";
		f.action = "/s_kr/admin/user/use_wk_ins2.jsp";
		f.submit();
		
	}


	function checkDulicate(flag)
	{
	
		document.form.duplicate.value = flag;

		if(flag == "F") {
		  document.form.user_id.select();
		  return false;
		} else if(flag == "T") {
		  return true;
		}
	}
/////////////////////////////////////////////////////////////////



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

function getPr(code, text) {
	document.forms[0].pr_location.value = code;
	document.forms[0].text_pr_location.value = text;
}

function getPartner_code(code,text, type) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code.value = text;
	//document.forms[0].text_company_code2.value = code;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].company_code.value = code;
	document.forms[0].text_company_code.value = text;
	//document.forms[0].text_company_code2.value = code;
}

function actionedit() {

	user_type = document.forms[0].user_type.value;
	text_user_type = document.forms[0].user_type.options[document.forms[0].user_type.selectedIndex].text;

    if ( user_type == "P" || user_type == "S" ) {

		document.forms[0].edit.value = "Y";
   		document.forms[0].company_code.value = "";
		document.forms[0].text_company_code.value = "";
		//document.forms[0].text_company_code2.value = "";

    } else {
    	document.forms[0].company_code.value = user_type;
		document.forms[0].text_company_code.value = text_user_type;
		//document.forms[0].text_company_code2.value = user_type;
		document.forms[0].edit.value = "N";

    }
}



function searchProfile(fc) {
	var url = "";

	if( fc == "company_code" ) {

	   if (document.forms[0].edit.value == "N")
	   		return;

	   if (document.forms[0].user_type.value  == "")
	   {
			alert("사용자 구분을 먼저 선택해야 합니다.");
			return;
	   }

	   if (document.forms[0].user_type.value  == "P")
	   {
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

	   } else if (document.forms[0].user_type.value  == "S")
	   {
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
			return;
	   }

	}

	else if(fc == "pr") url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getPr&values=<%=house_code%>&values=M062&values=&values=";
	
	Code_Search(url,'','','','','');
}

// 공통스크립트 부분 --------------------------




-->
</Script>
  <title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/pwdPolicy.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/pluginfree/js/nppfs-1.13.0.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
$(document).ready(function(){
	npPfsStartup(document.form, false, true, false, false, "npkencrypt", "on");
});
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
        doSelect();
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

function onlyNumber(keycode){
	/* alert(keycode); */
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}
function go_list(url, topMenuCode, topMenuSeq, param) {
	topMenuClick(url, topMenuCode, topMenuSeq, param);// '/admin/faq_list_new.jsp', 'MUO140100005', 7, ''
}


</script>
</head>
<body onload="" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>



<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form" id="form" method="post">
<input type="hidden" name="pr_location" id="pr_location" value="01">
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자 구분</td>
      <td class="data_td" width="35%" >Supplier
        <input type="hidden" name="user_type" value="S" class="input_data2" readonly  >
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업무권한</td>
      <td class="data_td">
        <select name="work_type" class="input_re">
        <option value=''>선택</option>
	   <%
	     String work_type = ListBox(request, "SL0007",  house_code+"#M104#", "");
     	     out.println(work_type);
	   %>
        </select>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사코드</td>
      <td class="data_td" colspan="3">
        <input type="text" name="company_code" value="<%=vendor_code%>" class="input_data2" readonly  >
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
			<TABLE cellpadding="0" cellspacing="0">
				<TR>
						<TD >
							<!-- <a href="javascript:doSave()" class="btn">등 록</a> -->
							<script language="javascript">btn("javascript:doSave()","등 록")</script>
						</TD>
				</TR>
			</TABLE>
  		</td>
	</tr>
</table>

<%--     <script language="javascript">rdtable_top1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자 ID<br>
      </td>
	<td class="data_td" colspan="3">
		<TABLE cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<input type="text" name="user_id" id="user_id" size="15" maxlength="10" class="input_re" onKeyUp="return chkMaxByte(20, this, '사용자ID');">
				</td>        
				<TD width="10" align="left"></TD>
				<TD background="/images/<%=info.getSession("HOUSE_CODE")%>/btn_bg.gif" class="btn" height="25">
					<!-- <a href="javascript:goDuplicate()" class="btn">중복확인</a> -->
					<script language="javascript">btn("javascript:goDuplicate()","중복확인")</script>
				</TD>
			</tr>
		</table>
		<input type="hidden" name="duplicate" value="F">
	</td>      
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비밀번호</td>
      <td class="data_td" width="35%">
        <input type="password" name="password" id="password" style="width:95%" maxlength="10" class="input_re" onKeyUp="return chkMaxByte(150, this, '비밀번호');" npkencrypt="on">
      </td>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비밀번호확인</td>
      <td class="data_td" width="35%">
        <input type="password" name="password2" id="password2" style="width:95%" maxlength="10" class="input_re"  npkencrypt="on">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사용자명(국문)</td>
      <td class="data_td" colspan="3">
        <input type="text" name="user_name_loc" style="width:39%" maxlength="40" class="input_re" onKeyUp="return chkMaxByte(40, this, '사용자명(국문)');">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 전화번호</td>
      <td class="data_td">
        <input type="text" name="phone_no" style="width:95%;ime-mode: disabled;" maxlength="20" class="input_re" onKeyUp="return chkMaxByte(20, this, '전화번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n">
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 이메일</td>
      <td class="data_td">
        <input type="text" name="email" style="width:95%;ime-mode: disabled;" maxlength="50" class="input_re" onKeyUp="return chkMaxByte(50, this, '이메일');">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 휴대폰</td>
      <td class="data_td">
        <input type="text" name="mobile_no" style="width:95%;ime-mode: disabled;" maxlength="20" class="input_re" onKeyUp="return chkMaxByte(20, this, '휴대폰');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n">
      </td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 팩스번호</td>
      <td class="data_td">
        <input type="text" name="fax_no" style="width:95%;ime-mode: disabled;" maxlength="20" class="input_re" onKeyUp="return chkMaxByte(20, this, '팩스번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 우편번호</td>
      <td class="data_td" colspan="3">
        <input type="text" name="zip_code" size="20" maxlength="10" class="inputsubmit" onKeyUp="return chkMaxByte(10, this, '우편번호');" onKeyPress="return onlyNumber(event.keyCode);" data-dataType="n" style="ime-mode: disabled;">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <!-- <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지역</td>
      <td class="data_td" colspan="3">
        <input type="text" name="pr_location" size="20" maxlength="20" class="inputsubmit" onKeyUp="return chkMaxByte(200, this, '지역(only U.S.A)');">
      </td>
    </tr> -->
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      <td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소(한글)</td>
      <td class="data_td" colspan="3">
        <input type="text" name="address_loc" style="width:98%" maxlength="200" class="input_re" onKeyUp="return chkMaxByte(200, this, '주소(한글)');">
      </td>
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		
  
  
  
  <%-- <script language="javascript">rdtable_bot1()</script> --%>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td></td>
    </tr>
  </table>
  <table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
      <input type="hidden" name="duplicate2" value="F">
      <input type="hidden" name="edit" value="Y">
      </td>
    </tr>
  </table>
  </form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:footer/>
</body>
</html>

