<%@ page contentType = "text/html; charset=UTF-8" %>
<!-- 키보드보안  include Start -->
<%@ page import="com.raonsecure.touchenkey.*"%>

<%
String tnk_srnd = E2ECrypto.CreateSessionRandom(session, true);
%>
<script type="text/javascript">
var TNK_SR = '<%=tnk_srnd%>';
</script>
<!-- 키보드보안  include End-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%-- <%@ include file="/include/sepoa_session.jsp"%> --%>
<%@ page import="javax.servlet.*"%>

<%
	String user_id = request.getParameter("user_id");	// 사용자 ID
	String strFromSite = request.getParameter("FromSite");
	String login_type = ""; 
	if("ICT".equals(strFromSite)){
		login_type = "";
	}else{
		login_type = "BD";
	}
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" src="/js/pwdPolicy.js"></script>	
<!-- 키보드보안 스크립트 호출 </body>윗단에서 호출 필수!!!! -->
<script type="text/javascript" src="/TouchEnKey/js/TouchEnKey.js"></script>
<!--  키보드보안 스크립트 호출 끝 -->
<Script language="javascript" type="text/javascript">
function doSave() {

	$('#language').attr('value', "KO");

    var frm = document.getElementById("form1");
     
	var user_id      = LRTrim(document.form1.user_id.value);
	var password = LRTrim(document.form1.password.value);
	var new_password = LRTrim(document.form1.new_password.value);
	var new_password_confirm = LRTrim(document.form1.new_password_confirm.value);
		

	if ( isEmpty(password) )
	{
		alert("이전 암호를 입력하여 주십시오.");
		return;
	}


	if ( isEmpty(new_password) )
	{
		alert("새로운 암호를 입력하여 주십시오.");
		return;
	}

	if ( isEmpty(new_password_confirm) )
	{
		alert("새로운 암호를 입력하여 주십시오.");
		return;
	}

	if ( !isNoSpace(new_password) ) {
		alert("비밀번호에는 공백을 사용할 수 없습니다.");
		return false;
	}

	if ( new_password != new_password_confirm ) {
		alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
		return false;
	}

	
	// 비밀번호 정책 적용체크
	// js/pwdPolicy.js : isNewValidPwd
	if ( !isNewValidPwd(frm.user_id.value, frm.new_password.value) )
	{
		return;
	}

	
	//사용자 ID, 비밀번호 동일체크
	message = isEqualsIdPasswd();
	if(message != "SUCCESS")
	{
			alert(message);
			frm.new_password.focus();
			frm.new_password.select();
			return;
	}
	
	//비밀번호확인 체크
	message = isValidConfirmPasswd();
	if(message != "SUCCESS")
	{
			alert(message);
			frm.new_password_confirm.focus();
			frm.new_password_confirm.select();
			return;
	}

	goChangePassword('<%=user_id%>' , new_password);
	
}


function isValidPasswd()
{
	var strPassword = LRTrim(document.form1.new_password.value);
	if(strPassword.length == 0)
	{
			return "비밀번호를 입력하셔야 합니다.";
	}

	return "SUCCESS";
}


function isValidConfirmPasswd(){
	
		var strPassword      = LRTrim(document.form1.new_password.value);
		var confirm_password = LRTrim(document.form1.new_password_confirm.value);

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


function goChangePassword(user_id, strNewPass){		
	var frm = document.form1;
	if(makeEncData(frm)){ // 키보드보안 암호화 함수
		//var params = "&user_id=" + $('#id').val() + "&password=" + $('#password').val();
         
	     frm.mode.value   = "setPwdNew";
		 frm.browser_language.value = "KO";
		 frm.method = "POST";
         frm.target = "_self";	//"hiddenFrame";
         frm.action = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.co_login_process";
         frm.submit();
		
	} else{
		alert("암호화에 실패하였습니다. 정확한 값을 입력 후 재시도 해주세요.");
	} 

}

	

	function keyDown()
	{
		if(event.keyCode == 13) {
			goLogin();
		}
	}



	function ToCenter(height,width) {

		var outx = screen.height;
		var outy = screen.width;
		var x = (outx - height)/2;
		var y = (outy - width)/2;
		dim = new Array(2);
		dim[0] = x;
		dim[1] = y;

		return  dim;
	}
	function MM_openBrWindow(theURL,winName,width,height) { //v2.0
	  //화면 가운데로 배치
	  var dim = new Array(2);

	  dim = ToCenter(height,width);
	  var top = dim[0];
	  var left = dim[1];
	  features = "left="+left+",top="+top+",width="+width+",height="+height+", resizable=yes, status=yes, scrollbars=no";

	  window.open(theURL,winName,features);
	}

	
</script>
<title>우리은행 전자구매시스템</title> <%-- 우리은행 전자구매시스템 --%>
<link rel="SHORTCUT ICON" href="http://<%=request.getServerName() + ":" + request.getServerPort() + request.getContextPath()%>/images/icon/laps.ico">
<META HTTP-EQUIV="imagetooolbar" CONTENT="no">
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<form name="form1" id="form1" method="post">
	<input type="hidden" name="user_id"          id="user_id"             value="<%=user_id%>">
	<input type="hidden" name="browser_language" id="browser_language"    value=""  />
	<input type="hidden" name="language"         id="language"            value=""  />
	<input type="hidden" name="mode"             id="mode"                value="setPwdNew"  />
	<input type="hidden" name="acc_type"         id="acc_type"            value="ID"  />
	<input type="hidden" name="FromSite"         id="FromSite"            value="<%=strFromSite%>"  />
	<input type="hidden" name="login_type"       id="login_type"          value="<%=login_type%>"  />																											
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class='title_page'>
				비밀번호(Password) 변경
			</td>
		</tr>
	</table>
	
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
								<tr>
									<td class="title_td" width="50%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;이전 비밀번호
									</td>
									<td class="data_td">
										<input type="password" name="password" id="password" size="25" maxlength="20" data-enc="on">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td class="title_td" width="50%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;새로운 비밀번호
									</td>
									<td class="data_td">
										<input type="password" name="new_password" id="new_password" size="25" maxlength="20" data-enc="on">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr> 
									<td class="title_td" width="50%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;새로운 비밀번호 확인
									</td> 
									<td class="data_td">
										<input type="password" name="new_password_confirm" id="new_password_confirm" size="25" maxlength="20" data-enc="on">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
																												
	<table width="100%" border="0" cellspacing="1" cellpadding="0" >
		<tr>
			<td class="title_td" align="center">
				<b>
				비밀번호는 영문,숫자,특수문자중<br>
				2가지 이상을 조합할 경우 10자리,<br>
				3가지 이상을 조합할 경우 8자리로 입력하여 주십시오.
				</b>
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="left">
				<table cellpadding="0">
					<tr>
					</tr>
				</table>
			</td>
			<td height="30" align="right">
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:doSave()","저 장")</script></td>
						<td><script language="javascript">btn("javascript:self.close();","닫 기")</script></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>
</body>

</HTML>
