<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="xecure.servlet.*" %>
<%@ page import="xecure.crypto.*" %>
<%@ page import="java.security.*" %>
<%@ page import="java.util.Random" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache">
<style type="text/css">
* {font-family:'맑은 고딕','Malgun Gothic','돋움',Dotum,Helvetica,AppleGothic,Sans-serif}
caption { display: none; }
.board-list-1,.board-list-1 th,.board-list-1 td{border:none;text-align:center;font-size:14px}
.board-list-1 a {font-size:14px}
.board-list-1 {border-top:1px solid #444;border-bottom:1px solid #c7c7c7;border-collapse:separate;table-layout:fixed}
.lt-ie9 .board-list-1 {border-collapse:collapse} 
.board-list-1 th {padding:8px 10px 10px;border-bottom:1px solid #c7c7c7;background:#fff;font-weight:bold;vertical-align:middle}
.board-list-1 td {padding:8px 10px 10px;border-top:1px solid #e5e5e5;background:#fff;color:#555;vertical-align:top;line-height:30px}

.infoReferBox {background-color: #fbfbfb; border: 1px solid #d6d6d6; overflow: hidden; font-size:14px; width:780px}

.btn{vertical-align:top;display:inline-block}
.btn.home{margin-left:295px;width:104px;height:42px;background:url(/AnySign/AnySign4PC/img/sp_com.png) no-repeat -356px -700px}
.btn.down{margin-left:5px;width:70px;height:30px;background:url(/AnySign/AnySign4PC/img/sp_com.png) no-repeat -268px -705px}
</style>
</head>

<!--  script type="text/javascript" src="../anySign4PCInterface.js"></script-->
<script type="text/javascript">
document.write("<script type=\"text/javascript\" src=\"" + "/AnySign/anySign4PCInterface.js" + "?version=" + new Date().getTime() + "\"></scr"+"ipt>");
</script>
<script type="text/javascript">
<%
    //VidVerifier vid = new VidVerifier(new XecureConfig());
    //out.println(vid.ServerCertWriteScript());

	// AnySign 세션ID 설정
	String HashedSessionID = "";

	// 1. 고정 세션 ID
	HashedSessionID = "reaverTestSID19810531";
	
	// 2. 웹세션ID 해쉬
	//String id = session.getId();
	//HashedSessionID = cipher.getHash("SHA256",id);

	out.println("AnySign.mAnySignSID = '" + HashedSessionID + "';");
	//


	// 데몬 무결성 검증 기능 선택사항
	String HashedRandomValue = "";
	
	// 1. 무결성 검증 비활성화
	//    AnySign.mAnySignITGT 변수 "" 설정 - 2번 부분 주석처리.
	//

	// 2. 랜덤값 기반 무결성 검증 설정
	//    AnySign.mAnySignITGT = HashedRandomValue
	//
	//Cipher cipher = new Cipher( new XecureConfig());
	//HashedRandomValue = cipher.getRamdomMsg(30);

	//out.println("AnySign.mAnySignITGT = '" + HashedRandomValue + "';");
%>

function fn_Download (type)
{
	var downURL;
	if (type == "ANYSIGN")
	{
		if (AnySign.mPlatform.aName == "linux")
		{
			if (confirm("AnySign for PC 설치를 위해서는 브라우저가 재실행 될 수 있습니다. 설치하시겠습니까?"))
			{
				var i386deb = document.createElement("a");
				i386deb.text = "i386_deb";
				var i386rpm = document.createElement("a");
				i386rpm.text = "i386_rpm"
				var x86_64_deb = document.createElement("a");
				x86_64_deb.text = "x86_64_deb";
				var x86_64_rpm = document.createElement("a");
				x86_64_rpm.text = "x86_64_rpm";

				i386deb.href = AnySign.mPlatform.aAnySignInstallPath[0];
				i386rpm.href = AnySign.mPlatform.aAnySignInstallPath[1];
				x86_64_deb.href = AnySign.mPlatform.aAnySignInstallPath[2];
				x86_64_rpm.href = AnySign.mPlatform.aAnySignInstallPath[3];

				document.getElementById("AnySign4PC_download").appendChild (document.createElement("br"));
				document.getElementById("AnySign4PC_download").appendChild (i386deb);
				document.getElementById("AnySign4PC_download").appendChild (document.createElement("br"));
				document.getElementById("AnySign4PC_download").appendChild (i386rpm);
				document.getElementById("AnySign4PC_download").appendChild (document.createElement("br"));
				document.getElementById("AnySign4PC_download").appendChild (x86_64_deb);
				document.getElementById("AnySign4PC_download").appendChild (document.createElement("br"));
				document.getElementById("AnySign4PC_download").appendChild (x86_64_rpm);
				document.getElementById("AnySign4PC_download").appendChild (document.createElement("br"));
			}
		}
		else
		{
			downURL = AnySign.mPlatform.aAnySignInstallPath;
			document.location = downURL;
		}

		var checkInterval = setInterval (function () {
			if (!AnySign.mAnySignLoad && AnySign.mExtensionSetting.mInstallCheck_CB == null) {
				AnySign4PC_installCheck (installCheck_callback);
			} else if (AnySign.mAnySignLoad == true) {
				clearInterval(checkInterval);
			}
		}, 2000);
	}
}

function installCheck_callback (result) {
	var aElement1 = document.getElementById("AnySign4PC_checkMessage1");

	switch (result)
	{
		case "ANYSIGN4PC_NORMAL":
			aElement1.style.color = "blue";
			aElement1.innerHTML = "설치됨";
			break;
		case "ANYSIGN4PC_INTEGRITY_FAIL":
		case "ANYSIGN4PC_NEED_INSTALL":
		case "ANYSIGN4PC_NEED_UPDATE":
			if (result == "ANYSIGN4PC_INTEGRITY_FAIL") {
				aElement1.style.color = "red";
				aElement1.innerHTML = "미설치";
			}
			else if (result == "ANYSIGN4PC_NEED_INSTALL") {
				aElement1.style.color = "red";
				aElement1.innerHTML = "미설치";
			}
			else
			{
				aElement1.style.color = "green";
				aElement1.innerHTML = "업데이트필요";
			}

			break;
	}
}

function link () {	
	//document.location = AnySign.mBasePath + "/../test";
	document.location = "https://epro.wooribank.com";
}

AnySign.mAnySignShowImg.showImg = false;
PrintObjectTag (true);
setTimeout(function () {
	AnySign4PC_installCheck (installCheck_callback);
}, 500);

</script>

<body>
<h3>AnySign4PC 설치 정보</h3>
<table class="board-list-1 board-security" border="1" cellspacing="0" summary="프로그램,내용,설치현황,설치관리제공">
<caption>보안 프로그램 설치 다운로드</caption>
<colgroup>
	<col width="130"></col>
	<col></col>
	<col width="120"></col>
	<col width="100"></col>
</colgroup>
<thead>
<tr>
	<th scope="col">프로그램명</th>
	<th scope="col">내용</th>
	<th scope="col">설치현황</th>
	<th scope="col">설치관리</th>
</tr>
</thead>
<tbody>
<tr>
<td>AnySignForPC</td>
<td>Non-ActiveX 공인인증서 전자서명을 지원해주는 프로그램입니다.</td>
<td><div id="AnySign4PC_checkMessage1"><strong>확인중..</strong></div></div></td>
<td><span id="AnySign4PC_download"><a class="btn down" href="javascript:fn_Download('ANYSIGN');"></a></span></td>
</tr>
<!--
<tr>
<td>잉카 키보드 보안</td>
<td>nProtect Online Security V1.0(PFS)</td>
<td><div id="AnySign4PC_checkMessage2">-</div></td>
<td><a class="btn down" href="../inca_nos10/nos_setup.exe"></a></td>
</tr>
-->
</tbody>
</table>
<p>
<p>
<div class="infoReferBox">
<ul>
<li>운영 시스템(OS) : <strong><script type="text/javascript">document.write(AnySign.mPlatform.aName);</script></strong></li>
<li>웹브라우저 : <strong><script type="text/javascript">document.write(AnySign.mBrowser.aName);</script></strong></li>
<li>필요 모듈버전 : <strong><script type="text/javascript">document.write(AnySign.mAnySignVersion);</script></strong></li>

</ul>
</div>
<p>
<a class="btn home" href="javascript:link();"></a>

</body>
</html>
