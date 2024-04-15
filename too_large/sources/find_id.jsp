<%@page import="sepoa.fw.util.CommonUtil"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%

SepoaSession.putValue(request, "HOUSE_CODE", "000");
SepoaSession.putValue(request, "ID", "LOGIN");
SepoaSession.putValue(request, "LANGUAGE", "KO");
SepoaSession.putValue(request, "NAME_LOC", "000");
SepoaSession.putValue(request, "NAME_ENG", "000");
SepoaSession.putValue(request, "DEPT", "ALL");

String user_gb        = JSPUtil.nullToEmpty(request.getParameter("user_gb"));

%>
<%@ page import="javax.servlet.*"%>
<%
 
	String opener_flag = "S";  

	String introduction = "";
	String sub_intro = "";
	String user_name = "";

	if(opener_flag.equals("B"))
	{
		introduction = "사용자명과 사번(주민번호)을 입력하세요.";
		sub_intro    = "사번(주민번호)을";
		user_name    = "사 용 자 명";
	}
	else
	{
		introduction = "대표자명과 사업자등록번호를 입력하세요.";
		sub_intro    = "사업자등록번호를";
		user_name    = "업체명";
	}

	//// 사용자의 편의를 위하여 혼돈을 주는 문자는 제거(i, o, 숫자 1, 0)
	//String[] num = {"A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","S","T","U","V","W","X","Y","Z","2","3","4","5","6","7","8","9"};
	//String[] history = {"", "", "", "", "", "", "", ""};
	//int count1 = history.length;
	//boolean cont = true;
	//String makepw = "";
	//
	//for(int i=0; i<count1 ; i++)
	//{
	//	while(true)
	//	{
	//		cont = true;
	//		int randomNum=(int)(Math.random()*32);
	//		  
	//		history[i] = num[randomNum];
    //
	//		for(int j=0; j<i ; j++)
	//		{
	//			if(history[j].equals(history[i]))
	//			{
	//					cont = false;
	//					break;
	//			}
	//		}
	//		if (cont) break;
	//	}
	//	makepw = makepw + history[i];
	//}


	//// 사용자들이 눈으로 구분이 쉽게 가능한 14자리 사용
	//String[] num1 = {"-","=","~","!","@","#","$","%","^","&","*","(",")","+"};
	//
	//makepw = num1[(int)(Math.random()*14)] + makepw + num1[(int)(Math.random()*14)];   
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/pluginfree/js/nppfs-1.13.0.js"></script>
<Script language="javascript" type="text/javascript">
$(document).ready(function(){
	npPfsStartup(document.form, false, true, false, false, "npkencrypt", "on");
});
function init()
{
	self.resizeTo(550,580);
	<% if(user_gb.equals("ICT")){ %>
		document.forms[0].chkUser_GB2.checked = true;
	<% }else{ %>
		document.forms[0].chkUser_GB1.checked = true;
	<% } %>
	
// 	self.resizeTo(310,400);
	//self.resizeTo(800,600);
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

function checkUser_GB()
{
	var f       = document.forms[0];
	var user_gb = "";

	for(var i=0; i<f.optUser_GB.length; i++)  //라디오박스 길이만큼 루프
	{
		if(f.optUser_GB[i].checked == true){  //항목이 체크되있는지검사
			user_gb = f.optUser_GB[i].value; 	
			document.form.selectedUser.value = user_gb;
			break;
		}
	}

	if(user_gb == ""){
		alert("사용자 구분을 선택하여 주십시오.");
		return false;
	}
	return true;
}

function findID()
{
	if(checkUser_GB() == false) return;

	if(isEmpty(document.form.sms_check_no1.value)){
	 	alert("SMS 인증번호를 입력하여 주십시오.");
	 	document.form.sms_check_no1.focus();
	 	return;
	}

	if(isEmpty(document.form.irs_no.value)){
	 	alert("사업자등록번호를 입력하여 주십시오.");
	 	document.form.irs_no.focus();
	 	return;
	}
    
    if(isEmpty(document.form.vendor_sms_no.value)){
	 	alert("업체SMS번호를 입력하여 주십시오.");
	 	document.form.vendor_sms_no.focus();
	 	return;
	}

	goFindID();

}

/* 인증번호요청*/
function reqCheckNo(sTmpFlag)
{
	var JobFlag="";
	
	if(checkUser_GB() == false) return;

	if (sTmpFlag == "ID"){
		if(isEmpty(document.form.irs_no.value)){
		 	alert("사업자등록번호를 입력하여 주십시오.");
		 	document.form.irs_no.focus();
		 	return;
		}
	    
	    if(isEmpty(document.form.vendor_sms_no.value)){
		 	alert("등록된 SMS번호를 입력하여 주십시오.");
		 	document.form.vendor_sms_no.focus();
		 	return;
		}
	    JobFlag = "ReqCheckNo_ID";
	}
	
	if (sTmpFlag == "PW"){
		if(isEmpty(document.form.user_id.value))
		{
			alert("사용자ID를 입력하여 주십시오.");
			document.form.user_id.focus();
			return;
		}

		if(isEmpty(document.form.user_sms_no.value))
		{
			alert("등록된 SMS번호를 입력하여 주십시오.");
			document.form.user_sms_no.focus();
			return;
		}
		JobFlag = "ReqCheckNo_PW";
	}


	var f = document.forms[0];
	f.JobFlag.value = JobFlag;
	f.method = "POST";
	f.target = "childFrame";
	f.action = "use_wk_ins5.jsp";
	f.submit();
}


function goFindID()
{
	var f             = document.forms[0];
	var irs_no        = f.irs_no.value;
	var vendor_sms_no = f.vendor_sms_no.value;
	
	document.form.JobFlag.value = "FindID";
	f.method = "POST";
	f.target = "childFrame";
	f.action = "use_wk_ins5.jsp";
	f.submit();

}

function getResult(user_id, mobile, email, user_name)
{
	document.form.result1.value = "";
	document.form.result2.value = "";
	document.form.result3.value = "";

	var user_name = document.form.ceo_name_loc.value;
	document.form.user_id.value = user_id;		
	if(user_id == "" ){
		alert("해당정보와 일치하는 ID가 없습니다.");
	} else if(sign_status == "R" ) {
		document.form.result1.value = "업체 승인전입니다.";
		document.form.result2.value = "은행에 문의하여 주십시요."; 
	} else
		document.form.result1.value = user_name + "님의 ID는 " + user_id + "입니다.";
		 
}

function GoFindPw()
{
	var user_id     = document.forms[0].user_id.value.toUpperCase();
	var user_sms_no = document.forms[0].user_sms_no.value;
	var f           = document.forms[0];

	if(checkUser_GB() == false) return;

	if(isEmpty(document.form.sms_check_no2.value)){
	 	alert("SMS 인증번호를 입력하여 주십시오.");
	 	document.form.sms_check_no2.focus();
	 	return;
	}

	if(isEmpty(document.form.user_id.value))
	{
		alert("사용자ID를 입력하여 주십시오.");
		document.form.user_id.focus();
		return;
	}

	if(isEmpty(document.form.user_sms_no.value))
	{
		alert("본인SMS번호를 입력하여 주십시오.");
		document.form.user_sms_no.focus();
		return;
	}
  
	goDuplicate();

}

function goDuplicate()
{
	var f            = document.forms[0];
	//f.user_id.value   = f.user_id.value.toUpperCase();

    f.method = "POST";
	f.target = "childFrame";
	f.action = "use_wk_ins6.jsp";
	f.submit();
}

function getChangePw(status)
{
	if (status == "OK")
	{
		alert("OK");
		//document.form.result1.value = "새로운 비밀번호로 로그인하세요";
		//document.form.result2.value = "";
	}	
	else 
	{	 
		alert("Fail");
		//document.form.result1.value = "일치하는 정보가 없거나,";
		//document.form.result2.value = "입력하신 정보가 일치하지 않습니다.";
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

</Script>
<title>
	우리은행 전자구매시스템
</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body bgcolor="#FFFFFF" style="margin-left:10px;margin-right:10px;" onload="init()">
	<form name="form" id="form" method="post" action="../partner/partners%20create.htm">
		
		<input type="hidden" id="JobFlag"      name="JobFlag">
		<input type="hidden" id="selectedUser" name="selectedUser">

		<div id="dv001" name="dv001" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="left" class='title_page'>사용자 구분</td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
								<tr>
									<td width="40%" class="title_td">
										&nbsp;<input type="radio" id="chkUser_GB1" name="optUser_GB" value="GAD">
										&nbsp;<font color="black" style="font-size:11px;font-weight:bold;">총무부</font>
									</td>
									<td width="40%" class="title_td">
										&nbsp;<input type="radio" id="chkUser_GB2" name="optUser_GB" value="ICT">
										&nbsp;<font color="black" style="font-size:11px;font-weight:bold;">ICT지원센터</font>
									</td>
								</tr>
							</table>
						<td>
					</tr>
				</table>
		
		</div>

		<br><br>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class='title_page'>ID 찾기</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;사업자등록번호
							</td>
							<td class="data_td">
								&nbsp;<input type="password" name="irs_no" npkencrypt="on"  size="26" maxlength="13" class="input_re" style="ime-mode:disabled;">
							</td>
						</tr>
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;등록 휴대폰번호
							</td>
							<td class="data_td">
								&nbsp;<input type="password" name="vendor_sms_no" npkencrypt="on"  size="26" maxlength="13" class="input_re" style="ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);">
							</td>
						</tr>
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;SMS인증번호
							</td>
							<td class="data_td">
								<table>
									<tr>
										<td>
											<input type="password" name="sms_check_no1" id ="sms_check_no1" npkencrypt="on"  size="15" maxlength="13" class="input_re" style="ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);">
										</td>
										<td>
											<script language="javascript">btn("javascript:reqCheckNo('ID')","번호요청")</script>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<font color="red" style="font-size:11px;">
												&nbsp;(인증유효시간 : 3분)
											</font>										
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				<td>
			</tr>
			<tr>
				<td>
					<font color="red" style="font-size:11px;">
						&nbsp;* 사업자등록번호 / SMS번호는 숫자만 입력 가능합니다.<br>
						&nbsp;&nbsp;&nbsp;ex) 1234567890 / 01012345678
					</font>
				</td>
			</tr>
		</table>
		
		<br>

		<table width="99%" border="0" cellspacing="0" cellpadding="0" valign="top">
			<tr>
				<td align="left"><script language="javascript">btn("javascript:findID()","ID 찾기")</script></td>
				<td align="right"><script language="javascript">btn("javascript:self.close();","닫 기")</script></td>
			</tr>
		</table>
		
		<br><br><br>

		<script language="JavaScript" src="/jscomm/body_bot_bar.js" type="text/javascript"></script>
		
		<!---------------------------------------------------------------------------------------->
		<!---------------------------------------------------------------------------------------->
		<!---------------------------------------------------------------------------------------->
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class='title_page'>새비밀번호 받기</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;사용자ID
							</td>
							<td class="data_td">
								&nbsp;<input type="password" name="user_id" npkencrypt="on"  size="26" style="ime-mode:inactive" maxlength="13" class="input_re">
							</td>
						</tr>
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;등록 휴대폰번호
							</td>
							<td class="data_td">
								&nbsp;<input type="password" name="user_sms_no" npkencrypt="on"  size="26" maxlength="13" class="input_re"  style="ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);">
							</td>
						</tr>
						<tr>
							<td width="40%" class="title_td">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;SMS인증번호
							</td>
							<td class="data_td">
								<table>
									<tr>
										<td>
											<input type="password" name="sms_check_no2" id ="sms_check_no2" npkencrypt="on"  size="15" maxlength="13" class="input_re" style="ime-mode:disabled;" onKeyPress="return onlyNumber(event.keyCode);">
										</td>
										<td>
											<script language="javascript">btn("javascript:reqCheckNo('PW')","번호요청")</script>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											<font color="red" style="font-size:11px;">
												&nbsp;(인증유효시간 : 3분)
											</font>										
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font color="red" style="font-size:11px;">
						&nbsp;* SMS번호는 숫자만 입력 가능합니다.<br>
						&nbsp;&nbsp;&nbsp;ex) 01012345678
					</font>
				</td>
			</tr>
		</table>

		<br>
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0" valign="top">
			<tr>
				<td align="left"><script language="javascript">btn("javascript:GoFindPw()","새비밀번호 받기")</script></td>
				<td align="right"><script language="javascript">btn("javascript:self.close();","닫 기")</script></td>
			</tr>
		</table>

	</form>
</body>
<iframe name="childFrame"  frameborder="0" width="100%" height="700" marginwidth="0" marginheight="0" scrolling="no"></iframe>

<html></html>
