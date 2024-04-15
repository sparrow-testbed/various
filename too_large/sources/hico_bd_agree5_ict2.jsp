<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<title>입찰유의서및 계약조건 (필수-사용자대리인용)</title>
</head>
<body>
					<table width="840" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="1" colspan="2" bgcolor="#1e97d1"></td>
						</tr>
						<tr>
							<td height="29" bgcolor="#ebf5fa" class="bluebold">
								&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								&nbsp;&nbsp;개인정보 수집 및 이용(필수)【영업담당자용】
							</td>
							<td align="right" bgcolor="#ebf5fa">&nbsp;</td>
						</tr>
						<tr>
							<td height="1" colspan="2" bgcolor="#c4d6e4"></td>
						</tr>
					</table>
					<DIV id="divGrdBody" style='WIDTH: 845px; DISPLAY: block; HEIGHT: 600px; <% if(request.getParameter("flag").equals("1")){ %>OVERFLOW: auto <% } %>'>					
					<table width="840" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="100">
								<pre>
1. 수집 및 이용 목적
● 입찰 및 계약사무 처리 : “시스템“ 가입의사 확인, 서비스 제공에 따른 본인 식별·인증, “사용자” 자격 유지 및 관리, 서비스 부정이용 방지, 신규업체 심사, 입찰참가 통지 등 입찰/계약/대가 지급 등의 사무를 
   전자적으로 처리하기 위한 자격 확인, 고지, 통지사항 전달 등
● 사고/민원사무 처리 : 사고/민원인의 신원 확인, 사고/민원사항 확인, 사고해결 및 민원처리 사실조사를 위한 연락/통지, 처리결과 통보 등

2. 수집 항목
● 부서명, 성명, 이메일주소, 전화번호, 핸드폰번호
● 서비스 이용 또는 사업처리 과정에서 생성되는 정보 : 접속로그, 쿠키, 접속IP정보, 기타 상담 등을 통해 생성되는 정보 등
● 부정 이용 및 비인가 사용 정보 : 부정한 방법으로 "시스템" 이용 사실과 관련된 정보

3. 보유이용기간
위 개인정보는 수집 및 이용에 관한 동의일로부터 “시스템” 탈퇴 시까지 수집 및 이용 목적을 위하여 보유·이용됩니다. “시스템” 탈퇴 후에는 위에 기재된 이용 목적과 관련된 사고조사, 분쟁해결, 민원처리, 법령상 의무 이행을 위하여 
필요한 범위 내에서만 보유·이용됩니다. 이 경우 당사는 보관하는 정보를 그 보관 목적으로만 이용합니다.

※ 동의를 거부할 권리 및 동의를 거부할 경우의 불이익
위 개인정보 및 기타 정보의 수집·이용에 관한 동의는 계약의 체결 및 이행을 위하여 필수적이므로, 위 사항에 동의하셔야만 “시스템” 가입 및 서비스 제공이 가능합니다.
</pre>
							</td>
						</tr>
					</table>

</DIV>
</body>
</html>