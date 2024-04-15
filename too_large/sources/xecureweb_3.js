//////////////////////////////Update Zhang////////////////////////////////
// XecureWeb SSL Client Java Script ver4.1  2001.5.30
//
// 아직 : Netscape 6.0은 지원되지 않습니다....
// Edit List 2000,05,30
// process_error() --> XecureWebError() // by Zhang 변경
// function IsNetscape60()		// by Zhang 추가
// function XecureUnescape(Msg)		// by Zhang 추가
// function XecureEscape(Msg)		// by Zhang 추가
// function XecurePath(xpath)		// by zhang 추가

/**
 * @mainpage XecureWeb SSL Client JavaScript API메뉴얼
 * 
 * @section Program XecureWeb SSL Client JavaScript
 * - 프로그램 이름 : XecureWeb SSL Client JavaScript
 * - 프로그램 내용 : XecureWeb SSL Client의 API의 강화된 기능을 사용자 편의에 맞도록 제공한다.
 *
 * @section CREATEINFO 작성정보
 * - 작성일 : 2008/04/28
 */
/**
 * @file xecureweb.js
 * xecureweb javascript의 구현체
 *
 * @author  PKI Part, Softforum R&D Team
 * @date    2008/04/28
 * @attention Copyright (c) 2008 Softforum - All rights reserved.
 */


/**
 * @defgroup clientRequestCryptoAPI 클라이언트 Request 암호 API
 * 클라이언트 Request 암호 API<BR>
 */
/**
 * @defgroup serverResponseCryptoAPI 서버 Response 복호 API
 * 서버 Response 복호 API<BR>
 */
/**
 * @defgroup digitalSignAPI 전자서명 API
 * 전자서명 API<BR>
 * @code
 * var sign_desc=””; ( 서명원문 확인창의 기본 설명문 )
 * var show_plain=1; ( 0 : 서명원문 확인창 보이지 않기 , 1 : 서명원문 확인창 보이기 )
 * var accept_cert = “yessign,SoftForum CA”; (서명에 사용될 유효한 인증기관 목록 (CN) )
 * // Yessign Test : yessignCA-TEST
 * // Yessign Real : yessignCA
 * // SignGate Test : SignGateFTCA
 * // SignGate Real : signGate CA
 * // SignKorea Test : SignKorea Test CA
 * // SignKorea Real : SignKorea CA
 * // 기타 인증기관은…발급자(인증기관)의CN
 * var pwd_fail = 3; (인증서 암호 오류를 허용회수)
 * var xgate_addr	= window.location.hostname + “:443:8080”; 
 * (서버측 세션관리자의 IP와 포트번호 , 443 : Direct port , 8080 : Proxy port )
 * @endcode
 */
/**
 * @defgroup CMPAPI 인증서 발급/갱신/폐기 관련 CMP API
 * 인증서 발급/갱신/폐기 관련 CMP API<BR>
 * @code
 * var ca_ip =  “203.233.91.232”;  (YesSign 공인 인증기관 IP - Test)
 * var ca_ip =  “203.233.91.71”;  (YesSign 공인 인증기관 IP - Real)
 * var ca_ip =  "192.168.10.25;SoftforumCA"; (Xecure 인증기관 IP;CA Name)
 * var ca_port = 4512; (YesSign 공인 인증기관 Port )
 * var ca_type = 11; (YesSign 인증기관 Type ? Test)
 * var ca_type = 1; (YesSign 인증기관 Type ? Real)
 * var ca_type = 101; (Xecure 인증기관 Type ? RSA)
 * var ca_type = 101+256; (Xecure 인증기관 Type ? RSA & CSP 사용시 키1쌍만 생성)
 * var ca_type = 102; (Xecure 인증기관 Type ? GPKI)
 * var pwd_fail = 3; (인증서 암호 오류를 허용회수)
 * @endcode
 */
/**
 * @defgroup SFCA_CMPAPI SFCA 인증서 관련 API
 * SFCA 인증서 관련 API<BR>
 * <B>Linux System에서는 지원하지 않는다.</B>
 */
/**
 * @defgroup etcAPI 기타 API
 * 기타 API<BR>
 */

var gIsContinue=0;
var busy_info = "암호화 작업이 진행중입니다. 확인을 누르시고 잠시 기다려 주십시오."

/**
 * 암복호시 페이지에 명시된 문자셋의 사용 여부<BR>
 * XecureWeb Java 버전 암복호시 시스템 디폴트 인코딩과 다른 문자셋의<BR>
 * 메세지를 처리하는 경우 true 설정
 *
 * @since 6.0 v210
 */
var usePageCharset=false;

// YESSIGN CA ADDRESS//////////////////////////////////////////////////////
// TEST : 203.233.91.234
// REAL : 203.233.91.71  
//var yessign_ca_type = 1;	// Yessign Real
/**
 * 금결원 CA의 종류<BR>
 * 1 : Yessign Real<BR>
 * 11 : Yessign Test
 */
var yessign_ca_type = 11+256;	// Yessign Test

/**
 * 금결원 CA의 서비스 IP
 */
var yessign_ca_ip =  "203.233.91.231;yessignCA-Test Class 2";

/**
 * 금결원 CA의 서비스 Port
 */
var yessign_ca_port = 4512;

// XECURE CA ADDRESS///////////////////////////////////////////////////////
// TEST : 192.168.10.30
var xecure_ca_type = 101;	// XecureCA (RSA)
//var xecure_ca_type = 102;	// XecureCA (GPKI)
var xecure_ca_ip =  "192.168.10.25;SoftforumCA";
//var xecure_ca_ip =  "192.168.10.25";
var xecure_ca_port = 8200;

var xecure_ca_type_1 = 101;	// XecureCA (RSA)
//var xecure_ca_type = 102;	// XecureCA (GPKI)
var xecure_ca_ip_1 =  "192.168.10.30;mma ca";
var xecure_ca_port_1 = 2223;

/**
 * 전자서명, 인증서 갱신, 인증서 폐기시에 인증서 암호오류를 허용회수<BR>
 */
var pwd_fail = 3;

/**
 * 서명에 사용될 유효한 인증기관 목록 (CN)<BR>
 * Sign, RequestCertificate, RevokeCertificate 시 나타나는 인증서 목록 <BR>
 * XecureWeb ver 5.1 에서는 accept_cert 에 유효한 인증기관 인증서의 <BR>
 * CN 을 정확히 적어준다.<BR>
 * ver 4.0 에서 yessign 이라 적었던 것은 yessignCA-TEST, yessignCA 로 세분화 된다.<BR>
 * YESSIGN TEST : yessignCA-TEST<BR>
 * YESSIGN REAL : yessignCA<BR>
 */
var accept_cert = "yessignCA-Test Class 2,CA131000002Test,CA131000002,Softforum CA 3.0,SoftforumCA,yessignCA,yessignCA-OCSP,signGATE CA,SignKorea CA,CrossCertCA,CrossCertCA-Test2,NCASign CA,TradeSignCA,yessignCA-TEST,lotto test CA,NCATESTSign,SignGateFTCA,SignKorea Test CA,TestTradeSignCA,Softforum Demo CA,mma ca,병무청 인증기관";


//////////////////////////////////////////////////////////////////////////////////
// 로그인 창에 보일 이미지를 다운로드 받을 URL
//var bannerUrl =  "http://" + window.location.host + "/XecureObject/xecure.bmp";
/**
 * 로그인 창에 보일 이미지를 다운로드 받을 URL<BR>
 */
var bannerUrl =  "http://" + window.location.host + "/XecureObject/xecureweb_big.bmp";

/**
 * 인증기관 인증서 다운로드시 인증기관 인증서<BR>
 */
var pCaCertUrl= "http://" + window.location.host + "/XecureObject/signed_cacert.bin";
/**
 * 인증기관 인증서 다운로드시 인증기관 인증서 CN<BR>
 */
var pCaCertName = "shinbo real ca";

/**
 * 서명원문 확인창의 기본 설명문<BR>
 */
var sign_desc = "";
/**
 * 전자서명 확인창에 보일 메세지와 전자서명 확인창 보기 옵션<BR>
 * 0 : 서명 원문 출력 안함, 1: 서명 원문 출력 
 */
var show_plain = 0; 

/**
 * xgate 서버 명:포트 지정 , 포트 생략시 디폴트로 443 포트 사용<BR>
 */
var xgate_addr	= window.location.hostname + ":443:8080";

///////////////////////////////////////////////////////////////////////////////////
// Netscape plugin version information
var packageURL = 'http://' + window.location.host + '/XecureObject/NPXecSSL_Install.jar';
var versionMaj = 5;
var versionMin = 1;
var versionRel = 0;

/**
 * 관리창, 서명창, Login창에서 인증서 List를 구분하여 발급자를 Rename할 때<BR>
 * 사용하며, 구분은 인증서의 정책값을 기준으로 Rename되고, Default는 사설인증서 이다.<BR>
 * 발급자는 인증서 발급자의 CN값을 기준으로 Rename된다.<BR>
 * 자세한 것은 SE에게 문의.<BR>
 * @ingroup etcAPI
 */
function SetConvertTable() {
}

function UserAgent()
{
	return navigator.userAgent.substring(0,9);
}

function IsNetscape()			// by Zhang
{
	if(navigator.appName == 'Netscape')
		return true ;
	else
		return false ;
}

function IsNetscape60()			// by Zhang
{
	if(IsNetscape() && UserAgent() == 'Mozilla/5')
		return true ;
	else
		return false ;
}

function IsNetscape60()			// by Zhang
{
	if(IsNetscape() && UserAgent() == 'Mozilla/5')
		return true ;
	else
		return false ;
}

function XecureUnescape(Msg)		// by Zhang
{
	if(IsNetscape())
		return unescape(Msg) ;
	else
		return Msg ;
}

/**
 * 주어진 문자열을 Escape 처리 해준다.<BR>
 *
 * @param Msg 원문
 * @return Escape된 문자열
 */
function XecureEscape(Msg)		// by Zhang
{
	if(IsNetscape())
		return escape(Msg) ;
	else
		return Msg ;
}

function XecurePath(xpath)		// by zhang
{
	if(IsNetscape())
		return (xpath) ;
	else
		return ("/" + xpath) ;		
}

function XecureAddQuery(qs)
{
	if(qs == "")	
		return "" ;
	else
		return "&" + qs ;
}

function XecureWebError()		// by zhang
{
	var errCode = 0 ;
	var errMsg = "" ;
	
	if( IsNetscape60() )		// Netscape 6.0
	{
		errCode = document.XecureWeb.nsIXecurePluginInstance.LastErrCode();
		errMsg  = document.XecureWeb.nsIXecurePluginInstance.LastErrMsg();
	}
	else
	{
		errCode = document.XecureWeb.LastErrCode();
		errMsg  = document.XecureWeb.LastErrMsg();
	}
	
	if(errCode == -144)
	{
		if(confirm("에러코드 : " + errCode + "\n\n" + XecureUnescape(errMsg) + "\n\n 인증서관리창을 열겠습니까?"))
			ShowCertManager() ;
	}
//	else if(errCode != 0)	
		alert( "에러코드 : " + errCode + "\n\n" + XecureUnescape(errMsg) );
	
	return false;
}

/**
 * ISO 형식의 url을ASCII 문자열로 전환한다.
 *
 * @ingroup etcAPI
 * @param url escape 처리할 문자열
 * @return escape 처리된 문자열
 */
function escape_url(url) {
	var i;
	var ch;
	var out = '';
	var url_string = '';

	url_string = String(url);

	for (i = 0; i < url_string.length; i++) {
		ch = url_string.charAt(i);
		if (ch == ' ')		out += '%20';
		else if (ch == '%')	out += '%25';
		else if (ch == '&')	out += '%26';
		else if (ch == '+')	out += '%2B';
		else if (ch == '=')	out += '%3D';
		else if (ch == '?') out += '%3F';
		else				out += ch;
	}
	return out;
}

function ran_gen()
{
	var maxnumbers = "999999";
	var r = Math.round(Math.random() * (maxnumbers-1))+1+"";

	for(var i=0; i < 6-r.length; i++)
		r = "0" + r;
	
	return r;
}

/**
 * <B>보안 세션을 연결하고 주어진 url의query string 부분을 암호화 하지 않고 이동한다. script ( javascript 혹은 VBscript ) 내부에서 이동할 경우 사용</B><BR>
 * <BR>
 * script문 안에서 window.open 이나, document.location.href 등을 이용한 페이지 <BR>
 * 이동시에 query string을 암호화 하지 않고 이동할 경우<BR>
 * window.open, document.location.href 대신XecureNavigate_NoEnc 함수를 호출한다.</B> <BR>
 * <BR>
 * Query string이 없는 경우  :   <B>url?q=암호화된 SID</B><BR>
 * Query string이 있는 경우  :   <B>url?q=암호화된 SID;암호화 되지 않은 데이터</B><BR>
 * <BR>
 * @ingroup clientRequestCryptoAPI
 * @param url : 이동할 URL
 * @param target 이동할 타겟
 * @return Success : true<BR>
 * Fail : false
 */
function XecureNavigate_NoEnc( url, target )
{
	var qs ;
	var path = "/";
	var sid;
	var xecure_url;

	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	path = getPath(url)

	// get query string action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = url.substring(qs_begin_index + 1, url.length );
	}

	if( gIsContinue == 0 ) {
		gIsContinue = 1;
		if( IsNetscape60() )		// Netscape 6.0
			sid = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, "", "GET");
		else
			sid = document.XecureWeb.BlockEnc ( xgate_addr, path, "", "GET" );
		gIsContinue = 0;
	}
	else {
		alert(busy_info);
		return false ;
	}

	if( sid == "")	return XecureWebError();

	xecure_url = path + "?q=" + sid + XecureAddQuery(qs);
	// adding character set information
	if(usePageCharset)
		xecure_url += "&charset=" + document.charset;

	open ( xecure_url, target );
}

/**
 * <B>보안 세션을 연결하고 주어진 url의query string을 암호화 한후 입력된 frame 으로 이동한다. script ( javascript 혹은 VBscript ) 내부에서 이동할 경우 사용</B><BR>
 * <BR>
 * script문 안에서 window.open 이나, document.location.href 등을 이용한 페이지 이동시에는 window.open, document.location.href 대신<BR>
 * XecureNavigate 함수를 호출한다. <BR>
 * <BR>
 * Query string이 없는 경우  :   <B>url?q=암호화된 SID</B><BR>
 * Query string이 있는 경우  :   <B>url?q=암호화된 SID;암호화된 데이터</B><BR>
 * <BR>
 * example><BR>
 * &lt;script language=javascript> <BR>
 * window.open ( “/hello.php”, “body” ) ; <BR>
 * &lt;/script> <BR>
 * ==> <BR>
 * &lt;script language=javascript> <BR>
 * XecureNavigate ( “/hello.php”, “body” ) ; <BR>
 * &lt;/script><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param url 이동할 URL<BR>
 * @param target 결과 화면이 출력될 frame명<BR>
 * @param feature 새로운 창에 대한 성질 ( 창 크기 등등 ) ? 옵션
 *
 * @return Success : true<BR>
 * Fail : false
 *
 */
function XecureNavigate( url, target, feature )
{
var qs ;
var path = "/";
var cipher;
var xecure_url;

// get path info & query string & hash from url
qs_begin_index = url.indexOf('?');
path = getPath(url)
// get query string action url
if ( qs_begin_index < 0 ) {
	qs = "";
}
else {
	qs = url.substring(qs_begin_index + 1, url.length );
}

if( gIsContinue == 0 ) {
	gIsContinue = 1;
	if( IsNetscape60() )		// Netscape 6.0
		cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
	else 
		cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
	gIsContinue = 0;
}
else {
	alert(busy_info);
	return false;
}
		
if( cipher == "" )	return XecureWebError();

xecure_url = path + "?q=" + escape_url(cipher);
// adding character set information
if(usePageCharset)
	xecure_url += "&charset=" + document.charset;

if (feature=="" || feature==null) open ( xecure_url, target );
else open(xecure_url, target, feature );

}

/**
 * 전자봉투를 지원하는 XecureNagivate<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureNavigate
 */
function XecureNavigate_Env( url, target, feature )
{
var qs ;
var path = "/";
var cipher;
var xecure_url;

// get path info & query string & hash from url
qs_begin_index = url.indexOf('?');
path = getPath(url)
// get query string action url
if ( qs_begin_index < 0 ) {
	qs = "";
}
else {
	qs = url.substring(qs_begin_index + 1, url.length );
}

if( gIsContinue == 0 ) {
	gIsContinue = 1;
	//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
	cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
	gIsContinue = 0;
}
else {
	alert(busy_info);
	return false;
}
		
if( cipher == "" )	return XecureWebError();

//xecure_url = path + "?q=" + escape_url(cipher);
xecure_url = path + "?eq=" + escape_url(cipher);

// adding character set information
if(usePageCharset)
	xecure_url += "&charset=" + document.charset;

if (feature=="" || feature==null) {
	open ( xecure_url, target );
}
else {
	open(xecure_url, target, feature );
}

}

/**
 * 보안세션을 연결하고 <a href> 문을 이용하여 주어진 link의query string을 암호화 하여 전송한다.<BR>
 * 이 함수가 호출되면 컨트롤은 ClientSM 에게 xgate와SSL handshaking을 요청하여 새로운 보안 세션을<BR>
 * 연결하거나 연결된 보안세션이 있으면 Resume에 들어간다.  javascript onClick 이벤트를 사용하여<BR>
 * XecureLink 함수를 호출한다. 이 함수가 실행되어 주어진 url로 이동할 때append 되는 query string은<BR>
 * 다음의 형식이다.<BR>
 * <BR>
 * 암호화된 데이터가 없는 경우  :   <B>url?q=암호화된 SID</B><BR>
 * 암호화된 데이터가 있는 경우  :   <B>url?q=암호화된 SID;암호화된 데이터</B><BR>
 * <BR>
 * ex><BR>
 * <a href=”enc_demo_result.php?aa=test&bb=test” onClick=”return XecureLink(this);”>암호</a><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param link link 객체
 * @return Success : true
 * Fail : false
 k*/
function XecureLink( link )
{
var qs ;
//	var path = "/";
var cipher;


// get path info & query string from action url 

if ( link.protocol != "http:" ) {
	// alert ( "http 프로토콜만 사용 가능합니다." );
	return true;
}

qs = link.search;
if ( qs.length > 1 ) {
	qs = link.search.substring(1);
}

hash = link.hash;

if( gIsContinue == 0 ) {
	path = XecurePath(link.pathname) ;
	gIsContinue = 1;
	
	if( IsNetscape60() )		// Netscape 6.0
		cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs), "GET");
	else {
		//cipher = document.XecureWeb.BlockEnc(xgate_addr, "/XecureDemo/jsp/ibs/transfer_input.jsp", XecureEscape(qs),"GET");
		cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
	}
	gIsContinue = 0;
}
else {
	alert(busy_info);
	return false;
}
if( cipher.length == 0)	return XecureWebError() ;

// link.search = "?q=" + escape_url(cipher);
xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher);
// adding character set information
if(usePageCharset)
	xecure_url += "&charset=" + document.charset;

if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
else open( xecure_url, link.target );
return false;
}

/**
 * 전자봉투를 지원하는 XecureLink<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureLink
 */
function XecureLink_Env( link )
{
var qs ;
//	var path = "/";
var cipher;


// get path info & query string from action url 

if ( link.protocol != "http:" ) {
	// alert ( "http 프로토콜만 사용 가능합니다." );
	return true;
}

qs = link.search;
if ( qs.length > 1 ) {
	qs = link.search.substring(1);
}

hash = link.hash;

if( gIsContinue == 0 ) {
	path = XecurePath(link.pathname) ;
	gIsContinue = 1;
	//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
	cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
	gIsContinue = 0;
}
else {
	alert(busy_info);
	return false;
}
if( cipher.length == 0)	return XecureWebError() ;

// link.search = "?q=" + escape_url(cipher);
//xecure_url = "http://" + link.host + path + hash + "?q=" + escape_url(cipher);
xecure_url = "http://" + link.host + path + hash + "?eq=" + escape_url(cipher);

// adding character set information
if(usePageCharset)
	xecure_url += "&charset=" + document.charset;

if ( link.target == "" || link.target == null ) open ( xecure_url, "_self" );
else open( xecure_url, link.target );
return false;
}

/**
 * <B>보안 세션을 연결하고 &lt;form> 문에 입력된 데이터를 암호화 하여 전송한다.</B> <BR>
 * <B>이 함수를 사용하기 위해서는 반드시</B><BR>
 * <B>&lt;form name=’xecure’>&lt;input type=hidden name=’p’>&lt;/form> 이 페이지 내에 위치하도록 한다.</B><BR>
 * <BR>
 * 이 함수가 호출되면 컨트롤은 ClientSM 에게 xgate와SSL handshaking을 요청하여 새로운 보안 세션을 연결하거나<BR>
 * 연결된 보안세션이 있으면 Resume에 들어간다. javascript onSubmit 이벤트를 사용하여 XecureSubmit 함수를 호출한다. 
 * <BR>
 * <B><주어진 form 문의 method가 ‘GET’ 인 경우></B><BR>
 * form 문의 입력필드들을 input1=x&input2=&… 형식으로 만들어서 컨트롤에 보내면 컨트롤은 보안세션을 연결/Resume 한후<BR>
 * 입력된 데이터를 암호화하여 리턴한다. 암호문을 받아서 attach 한후 target url로 전송한다.
 * 이때 주어진 form의action에query string이 있는 경우 이query string은 무시되고 전송되지 않는다.
 * <BR>
 * <B><주어진 form 문의 method가 ‘POST’ 인 경우></B><BR>
 * form의action에 주어진 query string을 컨트롤에 보내면 컨트롤은 보안세션을 연결/Resume한 후 입력된 데이터를<BR>
 * 암호화 하여 리턴한다. 암호문을 받아서 url?q=xxx 형태로 이미 선언된 xecure frame의action 으로 지정한다. 
 * form 문의 입력필드들을 input1=x&input2=&… 형식으로 만들어서 컨트롤에 보내면 컨트롤은 (1) 과정에서 연결/Resume된<BR>
 * 세션정보를 이용하여 form 문의 입력필드들을 암호화 하여 리턴한다.
 * Xecure frame의p필드에 리턴된 암호문을 저장한후 <BR>
 * xecure.summit() 으로 (1)에서 지정된 url로 이동한다.<BR>
 * <BR>
 * 암호화된 데이터가 없는 경우  :     <B>url?q=암호화된 SID</B><BR>
 * 암호화된 데이터가 있는 경우  :     <B>url?q=암호화된 SID;암호화된 데이터</B><BR>
 * <BR>
 * example><BR>
 * &lt;form name=’xecure’>&lt;input type=hidden name=’p’>&lt;/form><BR>
 * <BR>
 * &lt;form name=transfer action=”enc_demo_result.php” method=”post”<BR>
 *  onSubmit=”return XecureSubmit(this);”> <BR>
 *  ... <BR>
 * &lt;/form><BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @param form : form 객체
 * @return Success : true<BR>
 * Fail : false
 */
function XecureSubmit( form )
{
	var qs ;
	var path ;
	var cipher;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	path = getPath(form.action)
	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
	}
	document.xecure.target = form.target;

	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		//qs = XecureMakePlain( form );
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );

		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");			
			else{
				cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			}
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}
		
		if( cipher == "" )	return XecureWebError() ;
		
		xecure_url = path + "?q=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset)
			xecure_url += "&charset=" + document.charset;
		
		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");			
			else {
				cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			}
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}		


		if( cipher == "" )	return XecureWebError() ;

		document.xecure.action = path + "?q=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset)
			document.xecure.action += "&charset=" + document.charset;
		
		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			if( IsNetscape60() )		// Netscape 6.0
				cipher = document.XecureWeb.nsIXecurePluginInstance.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			else{
				cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			}
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}		
		
		if( cipher == "" )	return XecureWebError() ;
		
		document.xecure.p.value = cipher;
		document.xecure.submit();
	}
	return false;
}

/**
 * 전자봉투를 지원하는 XecureSubmit<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureSubmit
 */
function XecureSubmit_Env( form )
{
	var qs ;
	var path ;
	var cipher;

	qs_begin_index = form.action.indexOf('?');
	
	// if action is relative url, get base url from window location
	path = getPath(form.action)
	// get path info & query string & hash from action url
	if ( qs_begin_index < 0 ) {
		qs = "";
	}
	else {
		qs = form.action.substring(qs_begin_index + 1, form.action.length );
	}
	document.xecure.target = form.target;
	
	if ( form.method == "get" || form.method=="GET" ) {
		// collect input field values 
		if(qs.length!=0)
			qs += "&"+XecureMakePlain( form );
		else
			qs = XecureMakePlain( form );
		
		// encrypt QueryString
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}
		
		if( cipher == "" )	return XecureWebError() ;
		
		//xecure_url = path + "?q=" + escape_url(cipher);
		xecure_url = path + "?eq=" + escape_url(cipher);
		
		// adding character set information
		if(usePageCharset)
			xecure_url += "&charset=" + document.charset;

		if ( form.target == "" || form.target == null ) open( xecure_url, "_self");
		else open ( xecure_url, form.target );
	}
	else {
		document.xecure.method = "post";

		// encrypt QueryString of action field
		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"GET");
			cipher = EnvelopData(XecureEscape(qs), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}		


		if( cipher == "" )	return XecureWebError() ;

		//document.xecure.action = path + "?q=" + escape_url(cipher);
		document.xecure.action = path + "?eq=" + escape_url(cipher);
		// adding character set information
		if(usePageCharset)
			document.xecure.action += "&charset=" + document.charset;

		posting_data = XecureMakePlain( form );

		if( gIsContinue == 0 ) {
			gIsContinue = 1;
			//cipher = document.XecureWeb.BlockEnc ( xgate_addr, path, XecureEscape(posting_data), "POST" );
			cipher = EnvelopData(XecureEscape(posting_data), "", serverCert, 1);
			gIsContinue = 0;
		}
		else {
			alert(busy_info);
			return false;
		}				
				
		if( cipher == "" )	return XecureWebError() ;
		
		//document.xecure.p.value = cipher;
		document.xecure.ep.value = cipher;
		document.xecure.submit();
	}
	return false;
}

function XecureMakePlain_Org(form)
{
	var name = new Array(form.elements.length); 
	var value = new Array(form.elements.length); 
	var flag = false;
	var j = 0;
	var plain_text="";
	var enable=false;//for softcamp

	//for softcamp
	if(document.secukey==null || typeof(document.secukey) == "undefined" || document.secukey.object==null) {
		enable=false;
	}
	else {
		enable=secukey.GetSecuKeyEnable();
	}


	len = form.elements.length; 
	for (i = 0; i < len; i++) {
		if ((form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit")) {
			if (form.elements[i].type == "radio" || form.elements[i].type == "checkbox") { // Leejh 99.11.10 checkbox추가
				if (form.elements[i].checked == true) {
					name[j] = form.elements[i].name; 
					value[j] = form.elements[i].value;
					j++;
				}
			}
			//for softcamp
			else if(enable && form.elements[i].type == "password"){
				if(form.elements[i].type == "password"){
					name[j] = form.elements[i].name;
					value[j] = secukey.GetRealPass(form.elements[i].name,form.elements[i].value);
					j++;
				}
			}
			else {
				name[j] = form.elements[i].name; 
				if (form.elements[i].type == "select-one") {
					var ind = form.elements[i].selectedIndex;
					if (form.elements[i].options[ind].value != '')
						value[j] = form.elements[i].options[ind].value;
					else
						value[j] = form.elements[i].options[ind].text;
					// form.elements[i].selectedIndex = 0;
				}
				else {
					value[j] = form.elements[i].value;
				}
				j++;
			}
		}
	}
	for (i = 0; i < j; i++) {
		str = value[i]; 
		value[i] = escape_url(str); 
	}

	for (i = 0; i < j; i++) {
		if (flag)
			plain_text += "&";
		else
			flag = true;
		plain_text += name[i] ;
		plain_text += "=";
		plain_text += value[i];
	}

	return plain_text;
}

/**
 * 주어진 form 문의 입력필드중 type이button/reset/submit인 것을 제외하고<BR>
 * aa=bb&cc=dd&ee=…  형식으로 재작성하여 리턴한다.
 *
 * @param form form 객체
 * @return Form 문의 입력필드로 새로이 작성한 데이터
 */
function XecureMakePlain(form)	// modified by tiger on 2004/12/22
{
       var name = new Array(form.elements.length);
       var value = new Array(form.elements.length);
       var flag = false;
       var j = 0;
       var plain_text="";


       //for softcamp
       if(document.secukey==null || typeof(document.secukey) == "undefined" || document.secukey.object==null) {
                    enable=false;
       }
       else {
                    enable=secukey.GetSecuKeyEnable();
       }

       len = form.elements.length;
       for (i = 0; i < len; i++) {
                    if ((form.elements[i].type != "button") && (form.elements[i].type != "reset") && (form.elements[i].type != "submit")) {
                                 if (form.elements[i].type == "radio" || form.elements[i].type == "checkbox") {
                                              if (form.elements[i].checked == true) {
                                                if (form.elements[i].disabled == false) {
                                                          name[j] = form.elements[i].name;
                                                          value[j] = form.elements[i].value;
                                                          j++;
                                                }
                                              }
                                 }
                                 //for softcamp
                                 else if(enable && form.elements[i].type == "password"){
                                              if(form.elements[i].type == "password"){
                                                            name[j] = form.elements[i].name;
                                                            value[j] = secukey.GetRealPass(form.elements[i].name,form.elements[i].value);
                                                            j++;
                                              }
                                 }
                                 else {
                                              name[j] = form.elements[i].name;
                                              if (form.elements[i].type == "select-one") {
                                                            var ind = form.elements[i].selectedIndex;
                                                            var op_len = form.elements[i].length;
                                                if (op_len > 0) {
                                                          if(ind > 0) {
                                                                     if (form.elements[i].options[ind].value != '')
                                                                               value[j] = form.elements[i].options[ind].value;
                                                                     else
                                                                               //value[j] = form.elements[i].options[ind].text;
                                                                               value[j] = "";
                                                          } else {
                                                                     if(ind == 0)
                                                                     {
                                                                               if (form.elements[i].options[ind].value != '')
                                                                                          value[j] = form.elements[i].options[ind].value;
                                                                               else
                                                                                          //value[j] = form.elements[i].options[ind].text;
                                                                                          value[j] = "";
                                                                     }
                                                          }
                                                          // form.elements[i].selectedIndex = 0;
                                                }
                                     }
                                     else if (form.elements[i].type == "select-multiple") {
                                                var llen = form.elements[i].length;
                                                var increased = 0;
                                                for( k = 0; k < llen; k++) {
                                                          if (form.elements[i].options[k].selected) {
                                                                     name[j] = form.elements[i].name;
                                                                     if (form.elements[i].options[k].value != '')
                                                                               value[j] = form.elements[i].options[k].value;
                                                                     else
                                                                               //value[j] = form.elements[i].options[k].text;
                                                                               value[j] = "";
                                                                     j++;
                                                                     increased++;
                                                          }
                                                }
                                                if(increased > 0) {
                                                          j--;
                                                }
                                                else {
                                                          value[j] = "";
                                                }
                                     }
                                     else {
                                                value[j] = form.elements[i].value;
                                     }
                                     j++;
                          }
                }
     }

       for (i = 0; i < j; i++) {
                    str = value[i];
                    value[i] = escape_url(str);
       }
 
       for (i = 0; i < j; i++) {
                    if (flag)
                                 plain_text += "&";
                    else
                                 flag = true;
                    plain_text += name[i] ;
                    plain_text += "=";
                    if (value[i] !="undefined"){
                                 plain_text += value[i];
                    }else {
                                 plain_text += "";
                    }
       }
 
       return plain_text;
}

/*************For Applet**********************/
function BlockEnc(auth_type,plain_text)
{	
	var cipher = "";

	if( IsNetscape60() )		// Netscape 6.0
		cipher =  XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockEnc(xgate_addr,auth_type,plain_text,"GET"));
	else
		cipher =  XecureUnescape(document.XecureWeb.BlockEnc(xgate_addr,auth_type,plain_text,"GET"));
		
	if( cipher == "" ) XecureWebError() ;
	
	return cipher;
}

/**
 * 연결된 세션정보를 찾아서 해당 키로 암호문을 복호화한다.<BR>
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher 복호화할 암호문
 * @return Success : 복호화된 평문<BR>
 * Fail : empty string (“”) 
 */
function BlockDec(cipher)
{
	var plain = "";

	if( IsNetscape60() )		// Netscape 6.0
		plain = XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockDec( xgate_addr, cipher));
	else {
		plain = XecureUnescape(document.XecureWeb.BlockDec( xgate_addr, cipher));
	}

	if( plain == "" ) XecureWebError() ;
		
	return plain;
}

/**
 * 연결된 세션정보를 찾아서 해당 키로 암호화된 XML 데이터를 복호화한다.
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher : 복호화할 XML data의 암호문
 * @return Success : 복호화된 평문<BR>
 * Fail : empty string (“”) 
 */
function BlockXMLDec(cipher)
{
	var path = "";

	if( IsNetscape60() )		// Netscape 6.0
		path = XecureUnescape(document.XecureWeb.nsIXecurePluginInstance.BlockXMLDec( xgate_addr, cipher));	
	else
		path = XecureUnescape(document.XecureWeb.BlockXMLDec( xgate_addr, cipher));
	
	if( path == "" ) 	XecureWebError() ;
	
	return path;
}

/**
 * 보안세션을 연결하고 <a href> 문을 이용하여 주어진 link의query string을 암호화 하여 전송한다.<BR>
 * ex>
 * <a href=”transfer_input.php “ target=main 
 * onClick=”return XecureLogIn(this);”>로그인</a>
 *
 * @param link link 객체
 * @return Success : true <BR>
 * Fail : false
 */
function XecureLogIn( link )
{
	EndSession();
	return XecureLink(link);
}

/**
 * Xgate_addr에 해당하는 보안세션을 강제로 종료한다.
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : 오류코드
 */
function EndSession()
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.EndSession( xgate_addr );
	else
		document.XecureWeb.EndSession(xgate_addr);
}

// XecureWeb ver 4.1 add
// option : 0 : no confirm window, all certificates
// option : 1 : confirm window, all certificates
// option : 2 : no confirm window, log-on certificate only
// option : 3 : confirm window, log-on certificate only

/**
 * 주어진 데이터에 전자 서명을 한다. <BR>
 * 서명원문 확인창 Diplay 유무 및 인증서 선택 제어를 할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * <BR>
 * @param option : 0 : 서명원문 확인창 No Display, 모든 인증서 서명 가능하게<BR>
 * 1 : 서명원문 확인창 Display, 모든 인증서 서명 가능하게<BR>
 * 2 : 서명원문 확인창 No Display, Login시 인증서로만 서명 가능하게<BR>
 * 3 : 서명원문 확인창 Display, Login시 인증서로만 서명 가능하게<BR>
 * @param plain : 서명하고자 하는 서명 원문
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_option( option, plain )
{
	var signed_msg;

	if( IsNetscape60() )	// Netscape 6.0
		signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr,
							escape(accept_cert), 
							escape(plain), 
							option, 
							escape(sign_desc),
							pwd_fail);
	else
		signed_msg = document.XecureWeb.SignDataCMS(
							xgate_addr,
							XecureEscape(accept_cert), 
							XecureEscape(plain), 
							option, 
							XecureEscape(sign_desc),
							pwd_fail);

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}
 
/**
 * 주어진 서명 데이터에 전자 서명을 한다. <BR>
 * 서명원문 확인창 Diplay 유무 및 인증서 선택 제어를 할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option 0 : 서명원문 확인창 No Display, 모든 인증서 서명 가능하게<BR>
 * 1 : 서명원문 확인창 Display, 모든 인증서 서명 가능하게<BR>
 * 2 : 서명원문 확인창 No Display, Login시 인증서로만 서명 가능하게<BR>
 * 3 : 서명원문 확인창 Display, Login시 인증서로만 서명 가능하게
 * @param plain 서명하고자 하는 서명 원문
 *
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서(n)]<BR>
 * Fail : empty string (“”)
 */
function Sign_Add( option, plain )
{
	var signed_msg;

	signed_msg = document.XecureWeb.SignDataAdd ( xgate_addr, accept_cert, plain, option, sign_desc, pwd_fail );

    if( signed_msg == "" )	XecureWebError() ;

    return signed_msg;
}

/**
 * 주어진 데이터에 전자서명을 한다.<BR>
 * 서명원문 확인창이 뜰 경우 창의 설명문은 sign_desc 이다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * @ingroup digitalSignAPI
 * @param plain :  서명하고자 하는 서명 원문
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”) 
 */
function Sign( plain )
{
	var signed_msg;
	
	if( IsNetscape60() )		// Netscape 6.0
	{
		signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(sign_desc) );
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(sign_desc) );
	}
	
	if( signed_msg == "" )	XecureWebError() ;
	
	return signed_msg;
}

/**
 * 주어진 데이터에 전자 서명을 한다. <BR>
 * 서명원문 확인창의 설명문을 전달할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * @ingroup digitalSignAPI
 * @param plain 서명하고자 하는 서명 원문
 * @param desc 서명원문 확인창의 설명문
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_desc( plain, desc )
{
	var signed_msg;

	if( IsNetscape60() )		// Netscape 6.0
		signed_msg = document.XecureWeb.nsIXecurePluginInstance.SignDataCMS( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(desc) );
	else
		signed_msg = document.XecureWeb.SignDataCSM( xgate_addr, XecureEscape(accept_cert), XecureEscape(plain), show_plain, XecureEscape(desc) );
		
	if( signed_msg == "" )	XecureWebError() ;
	
	return signed_msg;
}

// XecureWeb ver 4.1 add
// option : 0 : no confirm window, all certificates
// option : 1 : confirm window, all certificates
// option : 2 : no confirm window, log-on certificate only
// option : 3 : confirm window, log-on certificate only

// XecureWeb ver 5.0 add

/**
 * 주어진 서명 데이터에 전자 서명을 한다. <BR>
 * 서명원문 확인창 Diplay 유무 및 인증서 선택 제어를 할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * 식별번호가 주입된 인증서는 서명창에서 사용자의 IDN을 입력 하며, send_vid_info() 를 통해 식별 번호 검증을 위해 암호화 된 값을 가져올 수 있다.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option 0 : 서명원문 확인창 No Display, 모든 인증서 서명 가능하게<BR>
 * 1 : 서명원문 확인창 Display, 모든 인증서 서명 가능하게<BR>
 * 2 : 서명원문 확인창 No Display, Login시 인증서로만 서명 가능하게<BR>
 * 3 : 서명원문 확인창 Display, Login시 인증서로만 서명 가능하게
 * @param plain 서명하고자 하는 서명 원문
 * @param svrCert IDN, R 값을 암호화하기 위한 인증서 ( pem type )
 *
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_vid_user( option, plain, svrCert )
{
	var signed_msg;

	option = option + 4;
	
	if(IsNetscape())
	{
		alert("Not supported function");
	}
	else {
		signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

/**
 * 주어진 서명 데이터에 전자 서명을 한다. <BR>
 * 서명원문 확인창 Diplay 유무 및 인증서 선택 제어를 할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * 전자서명시 식별번호 확인을 위하여 Web Application에서 사용자의 IDN을 입력 하며, send_vid_info() 를 통해 식별 번호 검증을 위해 암호화 된 값을 가져올 수 있다.<BR>
 * <BR>
 * @ingroup digitalSignAPI
 * @param option : 0 : 서명원문 확인창 No Display, 모든 인증서 서명 가능하게<BR>
 * 1 : 서명원문 확인창 Display, 모든 인증서 서명 가능하게<BR>
 * 2 : 서명원문 확인창 No Display, Login시 인증서로만 서명 가능하게<BR>
 * 3 : 서명원문 확인창 Display, Login시 인증서로만 서명 가능하게
 * @param plain 서명하고자 하는 서명 원문
 * @param svrCert IDN, R 값을 암호화하기 위한 인증서 ( pem type )
 * @param idn 서명자의 주민등록(사업자등록)번호
 *
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_vid_web( option, plain, svrCert, idn )
{
	var ret;
	var signed_msg;

	option = option + 12;
	
	if(IsNetscape())
	{
		alert("Not supported function");
	}
	else {
		ret = Set_ID_Num(idn);
		if(ret != 0) {
			XecureWebError();
			return signed_msg;
		}
			
		signed_msg = document.XecureWeb.SignDataWithVID ( xgate_addr, accept_cert, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : 서명원문 확인창 없음
//	1 : 서명원문 확인창 띄움
/**
 * 주어진 시리얼 번호와 일치하는 인증서로 주어진 데이터를 전자 서명을 한다.<BR>
 * 서명원문 확인창 Diplay 를 제어할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * 식별번호가 주입된 인증서는 서명창에서 사용자의 IDN을 입력하며, send_vid_info() 를 통해 식별 번호 검증을 위해 암호화된 값을 가져올 수 있다.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial : 서명에 사용할 인증서의 시리얼 번호<BR>
 * 여러 개의 시리얼을 사용할 경우 “,”로 구별한다.<BR>
 * Ex) “008ade93, 008ade94”
 * @param certLocation 서명에 사용할 인증서 위치<BR>
 * 0 : 하드디스크, 1 : 이동식디스크, 2 : IC카드,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : 서명원문 확인창 No Display<BR>
 * 1 : 서명원문 확인창 Display
 * @param plain 서명하고자 하는 서명 원문
 * @param svrCert IDN, R 값을 암호화하기 위한 인증서 ( pem type )
 *
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_vid_user_serial( certSerial, certLocation, option, plain, svrCert )
{
	var signed_msg;

	option = option + 4;
	
	if(IsNetscape())
	{
		alert("Not supported function");
	}
	else {
		signed_msg = document.XecureWeb.SignDataWithVID_Serial ( xgate_addr, accept_cert, certSerial, certLocation, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : 서명원문 확인창 없음
//	1 : 서명원문 확인창 띄움

/**
 * 주어진 시리얼 번호와 일치하는 인증서로 주어진 데이터를 전자 서명을 한다.<BR>
 * 서명원문 확인창 Diplay 를 제어할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * 전자서명시 식별번호 확인을 위하여 Web Application에서 사용자의 IDN을 입력하며, send_vid_info() 를 통해 식별 번호 검증을 위해 암호화 된 값을 가져올 수 있다.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial 서명에 사용할 인증서의 시리얼 번호<BR>
 * 여러 개의 시리얼을 사용할 경우 “,”로 구별한다.<BR>
 * Ex) “008ade93, 008ade94”
 * @param certLocation 서명에 사용할 인증서 위치<BR>
 * 0 : 하드디스크, 1 : 이동식디스크, 2 : IC카드,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : 서명원문 확인창 No Display<BR>
 * 1 : 서명원문 확인창 Display
 * @param plain 서명하고자 하는 서명 원문
 * @param svrCert IDN, R 값을 암호화하기 위한 인증서 ( pem type )
 * @param idn 서명자의 주민등록(사업자등록)번호
 *
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 */
function Sign_with_vid_web_serial( certSerial, certLocation, option, plain, svrCert, idn )
{
	var ret;
	var signed_msg;

	option = option + 12;
	
	if(IsNetscape())
	{
		alert("Not supported function");
	}
	else {
		ret = Set_ID_Num(idn);
		if(ret != 0) {
			XecureWebError();
			return signed_msg;
		}
			
		signed_msg = document.XecureWeb.SignDataWithVID_Serial ( xgate_addr, accept_cert, certSerial, certLocation, plain, svrCert, option, sign_desc, pwd_fail );
	}

    if( signed_msg == "" )	XecureWebError();

    return signed_msg;
}

/**
 * 전자 서명시 식별번호 확인의 기능을 사용할 경우, IDN 값을 Web Application 이 넘겨줄 경우, 서명하기 이전에 이 함수를 통하여 idn 을 넘겨준다.<BR>
 * Sign_with_vid_web() 내부에 적용되어 있음.
 *
 * @ingroup digitalSignAPI
 * @param idn 식별번호(주민등록/사업자등록번호)
 * @return Success : 0<BR>
 * Fail : -1
 */
function Set_ID_Num(idn)
{
	var ret;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
	}
	else
	{
		ret = document.XecureWeb.SetIDNum(idn);
	}
	
	return ret;
}

/**
 * Send_vid_info_user() 또는 Send_vid_info_web() 호출을 통하여 식별번호가 주입된 인증서의 경우,<BR>
 * 식별번호(VID)를 확인하기 위한 정보를 암호화 하여 return 한다.<BR>
 * 만약, 식별번호가 주입되지 않은 인증서의 경우 null 을 return 한다.
 * 
 * @ingroup digitalSignAPI
 * @return Success : 식별 번호 검증을 위해 암호화된 정보<BR>
 * Fail : empty string (“”)
 */
function send_vid_info()
{
	var	vid_info;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
	}
	else
	{
		vid_info = document.XecureWeb.GetVidInfo();
	}
	
	if(vid_info.length == 0)
		return null;
	else
		return vid_info;
}

// only over XecureWeb Client v5.3.0.1
// [certLocation]
// 	0 : HARD
//	1 : REMOVABLE
//	2 : ICCARD
//	3 : CSP
//	4 : VSC
// [option]
//	0 : 서명원문 확인창 없음
//	1 : 서명원문 확인창 띄움
/**
 * 주어진 시리얼 번호와 일치하는 인증서로 주어진 데이터를 전자 서명을 한다. <BR>
 * 서명원문 확인창 Diplay 유무를 제어할 수 있다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 *
 * @ingroup digitalSignAPI
 * @param certSerial : 서명에 사용할 인증서의 시리얼 번호<BR>
 * 여러 개의 시리얼을 사용할 경우 “,”로 구별한다.<BR>
 * Ex) “008ade93, 008ade94”<BR>
 * @param certLocation 서명에 사용할 인증서 위치<BR>
 * 0 : 하드디스크, 1 : 이동식디스크, 2 : IC카드,3 :CSP 4: pkcs11,5:USBTOKEN_KIUP, 6 :iccard,  7 :NO_SMARTON, 8 : USBTOKEN_KIUP, 9 :YESSIGNM
 * @param option 0 : 서명원문 확인창 No Display<BR>
 * 1 : 서명원문 확인창 Display
 * @param plain 서명하고자 하는 서명 원문
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”)
 *
 */
function Sign_with_serial( certSerial, certLocation, plain, option )
{
	var	signed_msg;

	if( IsNetscape() )
	{
		alert("Not supported function");
	}
	else
	{
		signed_msg = document.XecureWeb.SignDataCMSWithSerial(  xgate_addr, 
									XecureEscape(accept_cert), 
									certSerial, 
									certLocation, 
									plain, 
									option, 
									XecureEscape(sign_desc),
									pwd_fail );
	}

	if( signed_msg == "" )	XecureWebError();

	return signed_msg;	
}

//
// only over XecureWeb Client v5.4.x
//
// !!! This function need site/executable license !!!
// 
// [option]
//      0 : only signature verification( NOT perform cert verification )
// 	1 : signature verification + default cert verification
//	2 : + cert chain check
//	3 : + CRL check
//	4 : + LDAP 
// [directoryServer]
//	ex) dirsys.rootca.or.kr:389 or ""
//

/**
 * 서명문을 검증하고 서명 원문을 리턴한다. 검증 옵션에 따라 다양한 검증 기능을<BR>
 * 수행할 수 있다. 또한 Verify_SignedData는 함수 사용을 위한 <B>라이센스</B>가 필요하다.
 *
 * @ingroup digitalSignAPI
 * @param signedData : 검증할 서명운
 * @param option : 서명 검증 옵션<BR>
 * 0 : 서명문만 검증(인증서에 대한 검증은 생략)<BR>
 * 1 : 0에 더하여 인증서 검증<BR>
 * 2 : 1에 더하여 인증서 체인까지 검증<BR>
 * 3 : 2에 더하여 인증서 CRL 체크<BR>
 * 4 : 3에 더하여 LDAP으로 인증서 검증<BR>
 * @param directoryServer : CRL을 가져올 디렉토리 서버 주소<BR>
 * Ex) dirsys.rootca.or.kr:389<BR>
 * “”을 입력하면 인증서에 포함된 CRL 분배점 이용하여 CRL 체크<BR>
 *
 * @return Success : 서명 원문
 * Fail : “”<BR>
 * <B>하지만 서명문 검증이 일단 성공하면 인증서 검증시 에러가 발생하더라도 서명 원문을 리턴한다. 따라서 전체적인 겸증 옵션에 따른 서명 검증이 올바르게 되었는지를 확인하기 위해서는, 리턴값 확인과 함께 LastErrCode 등으로 오류 여부를 확인해야 한다.</B>
 */
function Verify_SignedData( signedData, option, directoryServer )
{
	var	verified_msg;
	var	errCode;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
		return "";
	}
	else
	{
		verified_msg = document.XecureWeb.VerifySignedData( signedData, option, directoryServer );
	}

	// VerifySignedData는 인증서 검증시 오류가 발생하더라도 원문 추출이 성공하면 원문을 리턴하기 때문에
	// 반드시 LastErrCode를 확인해야 한다.
	errCode = document.XecureWeb.LastErrCode();
	if( errCode != 0 )
		XecureWebError();
	
	return verified_msg;	
}

//
// only over XecureWeb Client v5.4.x
//
// applicable cert location : usbtoken_kb, usbtoken_kiup
//
function Set_PinNumber( pin )
{
	var	ret = -1;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
	}
	else
	{
		 ret = document.XecureWeb.SetPinNum( pin );
	}

	return ret;
}

// type 10 : YessignCA
// type 11 : XecureCA
/**
 * 참조코드와 인가코드를 가지고 공인인증기관에 접속하여 인증서를 발급받는다. 인증서 발급 위치는 하드디스크/IC카드 이다.
 * 
 * @ingroup CMPAPI
 * @param type CA TYPE 10: YessignCA, 11: XecureCA
 * @param ref_code 참조코드
 * @param auth_code 인가코드
 *
 * @return Success : 0<BR>
 * Fail : -1
 */
function RequestCertificate ( type, ref_code, auth_code )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;
	
	if(type == 10) {
		ca_type = yessign_ca_type;
		ca_ip = yessign_ca_ip;
		ca_port = yessign_ca_port;
	}
	else if(type == 11) {
		ca_type = xecure_ca_type;
		ca_ip = xecure_ca_ip;
		ca_port = xecure_ca_port;
	}
	else if(type == 12) {
		ca_type = xecure_ca_type_1;
		ca_ip = xecure_ca_ip_1;
		ca_port = xecure_ca_port_1;
	}
	else {
		alert("Input type error!");
		return 0;
	}
	
	if(IsNetscape())
	{
		if( IsNetscape60() )	// Netscape 6.0
			r = document.XecureWeb.nsIXecurePluginInstance.RequestCertificate2 ( ca_port, ca_ip, ref_code, auth_code, ca_type );
		else
			r = document.XecureWeb.RequestCertificate2 ( ca_port, ca_ip, ref_code, auth_code, ca_type );
	}
	else 
	{
		r = document.XecureWeb.RequestCertificate ( ca_port, ca_ip, ref_code, auth_code, ca_type);
	}

	if ( r != 0 )	XecureWebError();
	
	return r;
}

// type 00 : YessignCA
// type 11 : XecureCA
/**
 * 이 함수를 실행시키면 갱신할 인증서를 선택한후 그 인증서를 갱신하여 선택된 위치에 다시 저장시킨다. ( 하드디스크/플로피 디스크/IC카드)
 *
 * @ingroup CMPAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
function RenewCertificate ( type )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;
	
	if(type == 10) {
		ca_type = yessign_ca_type;
		ca_ip = yessign_ca_ip;
		ca_port = yessign_ca_port;
	}
	else if(type == 11) {
		ca_type = xecure_ca_type;
		ca_ip = xecure_ca_ip;
		ca_port = xecure_ca_port;
	}
	else if(type == 12) {
		ca_type = xecure_ca_type_1;
		ca_ip = xecure_ca_ip_1;
		ca_port = xecure_ca_port_1;
	}
	else {
		alert("Input type error!");
		return 0;
	}

	if(IsNetscape())
	{
		if( IsNetscape60() )	// Netscape 6.0
			r = document.XecureWeb.nsIXecurePluginInstance.RenewCertificate2( ca_port, ca_ip, ca_type, pwd_fail );
		else
			r = document.XecureWeb.RenewCertificate2( ca_port, ca_ip, ca_type, pwd_fail );
	}
	else{
		r = document.XecureWeb.RenewCertificate ( ca_port, ca_ip, ca_type, pwd_fail );
	}

	if ( r != 0 ) 	XecureWebError();
	
	return r;
}

// type 00 : YessignCA
// type 11 : XecureCA
/**
 * 이 함수를 실행시키면 폐기할 인증서를 선택한후 그 인증서를 폐기하고 저장된<BR>
 * 위치에서 삭제시킨다. ( 하드디스크/플로피 디스크/IC카드)
 *
 * @ingroup CMPAPI
 * @param type  00 : YessignCA, 11 : XecureCA
 * @param jobcode <BR>
 * 인증서 폐기 : 17<BR>
 * 인증서 효력정지 : 256
 * @param reason (폐기/효력정지 사유 )<BR>
 * 1 : keyCompromise ( default )<BR>
 * 2 : cACompromise<BR>
 * 3 : affiliationChanged<BR>
 * 4 : superseded<BR>
 * 5 : cessationOfOperation<BR>
 * 6 : certificateHold
 *
 * @return Success : 0<BR>
 * Fail : -1
 */
function RevokeCertificate ( type, jobcode, reason )
{
	var r;
	var ca_type;
	var ca_ip;
	var ca_port;
	
	if(type == 10) {
		ca_type = yessign_ca_type;
		ca_ip = yessign_ca_ip;
		ca_port = yessign_ca_port;
	}
	else if(type == 11) {
		ca_type = xecure_ca_type;
		ca_ip = xecure_ca_ip;
		ca_port = xecure_ca_port;
	}
	else if(type == 12) {
		ca_type = xecure_ca_type_1;
		ca_ip = xecure_ca_ip_1;
		ca_port = xecure_ca_port_1;
	}
	else {
		alert("Input type error!");
		return 0;
	}
	
	if(IsNetscape())
	{
		if( IsNetscape60() )	// Netscape 6.0
			r = document.XecureWeb.nsIXecurePluginInstance.RevokeCertificate2( ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail );
		else
			r = document.XecureWeb.RevokeCertificate2( ca_port, ca_ip, jobcode, reason, ca_type,  pwd_fail);
	}
	else {
		r = document.XecureWeb.RevokeCertificate ( ca_port, ca_ip, jobcode, reason, ca_type, pwd_fail );
	}

        if ( r != 0 ) 	XecureWebError();

	return r;
}

/**
 * RSA 1024 bit 공개키/개인키쌍을 생성한후, 개인키 정보는 Client 에서 저장하고<BR>
 * 공개키 정보를 리턴한다. (사설 인증서 발급/갱신시 이용되며, 인증서 발급시에<BR>
 * 입력된 필요한 정보들과 이 함수에서 리턴된 공개키를 가지고 사설인증기관에<BR>
 * 접속하여 인증서를 발급/갱신 한다. )
 *
 * @ingroup SFCA_CMPAPI
 * @return Success : 생성된 공개키 문자열<BR>
 * Fail : “”
 *
 */
function GenCertReq ( )
{
	if( IsNetscape60() )		// Netscape 6.0
		cert_req = document.XecureWeb.nsIXecurePluginInstance.GenerateCertReq( 1024 );
	else
		cert_req = document.XecureWeb.GenerateCertReq( 1024 );

	if ( cert_req == "" )	XecureWebError() ;
	
	return cert_req;
}

/**
 * 발급/갱신된 사설 인증서를 저장시킨다. (저장 가능매체 : 하드디스크/IC카드)
 *
 * @ingroup SFCA_CMPAPI
 * @param cert_type 발급된 인증서 종류<BR>
 * 1 : 인증기관 인증서<BR>
 * 2 : 사용자 인증서<BR>
 * 5 : 암호화하여 저장할 사용자 인증서<BR/.
 * @param cert : 발급된 인증서 
 */
function InstallCertificate (cert_type, cert)
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.InstallCertificate(cert_type, cert );
	else
		document.XecureWeb.InstallCertificate(cert_type, cert );
}

/**
 * ClientSM의 인증서 관리자 메뉴를 웹 상에서 직접 호출하여 사용할 수 있다.
 * @ingroup etcAPI
 */
function ShowCertManager()
{
	if( IsNetscape60() )		// Netscape 6.0
		document.XecureWeb.nsIXecurePluginInstance.ShowCertManager();
	else
		document.XecureWeb.ShowCertManager();
}

function DeleteCertificate( dn )
{       
	var r; 
	
	if( IsNetscape60() )		// Netscape 6.0
		r = document.XecureWeb.nsIXecurePluginInstance.DeleteCertificate( XecureEscape(dn) );
	else
		r = document.XecureWeb.DeleteCertificate ( XecureEscape(dn) );

	if( r != 0 )	XecureWebError() ;
	else 		alert('인증서를 삭제하였습니다.');
}

/**
 * [ ClinetSM : 2.3.3 / AcitveX 4.1.2.3 이전 Version용 ]<BR>
 * 서명창이나 인증서Login창의 이미지를 설정한다. 이미지 BMP 파일을 제작한다. (여기서는 login.bmp(해상도:290x64) 로 가정)<BR>
 * XecureWeb ver4 server module이 설치되어 있는 디렉토리를 <BR>
 * /user/xecureweb_ver4라 가정하면<BR>
 * /user/xecureweb_ver4/object/ 아래에 login.bmp를 복사한다.<BR>
 * /user/xecureweb_ver4/object/xecureweb.js 파일을 열고 bannerUrl을 수정한다.<BR>
 * 예) var bannerUrl=<BR>
 * “http://” + window.location.hostname + “/XecureObject/login.bmp”;<BR>
 * BMP변경시..다른이름으로 저장하여야 다시 DownLoad받을 수 있다.
 * @ingroup etcAPI
 */
function PutBannerUrl()
{
	if( IsNetscape60() )		// Netscape 6.0
	{
		document.XecureWeb.nsIXecurePluginInstance.PutBigBannerUrl( xgate_addr, bannerUrl);
	}
	else
	{
		document.XecureWeb.PutBigBannerUrl( xgate_addr, bannerUrl);
	}
}

/**
 * 사설 인증기관을 사용시 사설인증기관 인증서를 사용자에게 배포한다.<BR>
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
function PutCACert()
{
	var r ;
	
	if( IsNetscape60() )		// Netscape 6.0
		r = document.XecureWeb.nsIXecurePluginInstance.PutCACert( XecureEscape(pCaCertName), pCaCertUrl);
	else
		r = document.XecureWeb.PutCACert( XecureEscape(pCaCertName), pCaCertUrl);

	if( r != 0 )	XecureWebError() ;
}

function isNewPlugin(desc)
{
	index = desc.indexOf('v.', 0);
	if (index < 0)
		return false;
	desc += ' ';

	versionString = desc.substring(index +2, desc.length);
	arrayOfStrings = versionString.split('.');
	thisMajor = parseInt(arrayOfStrings[0], 10);
	thisMinor = parseInt(arrayOfStrings[1], 10);
	thisBuild = parseInt(arrayOfStrings[2], 10);
	
	if (thisMajor > versionMaj)	return true;
	if (thisMajor < versionMaj)	return false;
	
	if (thisMinor > versionMin)	return true;
	if (thisMinor < versionMin)	return false;
	
	if (thisBuild > versionRel)	return true;
	if (thisBuild < versionRel)	return false;

	return true;
}

function downloadNow () {
	if ( navigator.javaEnabled() ) {
		trigger = netscape.softupdate.Trigger;
		if ( trigger.UpdateEnabled() ) {
			if (navigator.platform == "Win32") {
				trigger.StartSoftwareUpdate( packageURL, trigger.DEFAULT_MODE);
			}
			else alert('이 플러그 인은 윈도우즈 95/98/NT 환경에서만 작동합니다.')
		}
		else
			alert('넷스케입의 SmartUpdate 설치를 가능하도록 해야합니다.');
	}
	else
		alert('Java 실행을 가능하도록 해야합니다.');
}

function isOldPlugin(desc,version)	// by Zhang
{
	index = desc.indexOf('v.', 0);
	if (index < 0)	return true;
	
	desc += ' ';
	versionString = desc.substring(index +2, desc.length);
	arrayOfStrings = versionString.split('.');
	thisMaj = parseInt(arrayOfStrings[0], 10);
	thisMin = parseInt(arrayOfStrings[1], 10);
	thisRel = parseInt(arrayOfStrings[2], 10);
	
	arrayOfStrings = version.split('.');
//	verMaj = parseInt(arrayOfStrings[0], 10);
//	verMin = parseInt(arrayOfStrings[1], 10);
//	verRel = parseInt(arrayOfStrings[2], 10);
	s_verMaj = parseInt(arrayOfStrings[0], 10);
	s_verMin = parseInt(arrayOfStrings[1], 10);
	s_verRel = parseInt(arrayOfStrings[2], 10);
	
	if (thisMaj > s_verMaj)	return false;
	if (thisMaj < s_verMaj)	return true;
	
	if (thisMin > s_verMin)	return false;
	if (thisMin < s_verMin)	return true;
	
	if (thisRel > s_verRel)	return false;
	if (thisRel < s_verRel)	return true;

	return false;
}

function DownloadPackage(packageURL) // by Zhang
{
	if ( navigator.javaEnabled() ) {
		trigger = netscape.softupdate.Trigger;
		if ( trigger.UpdateEnabled() ) {
			if (navigator.platform == "Win32") {
				trigger.StartSoftwareUpdate( packageURL, trigger.DEFAULT_MODE);
			}
			else
				alert('이 플러그 인은 윈도우즈 95/98/NT 환경에서만 작동합니다.');
		}
		else
			alert('넷스케입의 SmartUpdate 설치를 가능하도록 해야합니다.');
	}
	else
		alert('Java 실행을 가능하도록 해야합니다.');
}

function XecureWebPlugin(version)	// by Zhang
{	
	if (navigator.appName == 'Netscape' && UserAgent() == "Mozilla/4") 
	{
  		var XecureMime = navigator.mimeTypes["application/x-SoftForum-XecSSL40"];
		if (XecureMime) {   // Xecure PlugIn 이 이미 설치되어 있는 경우
			if ( isOldPlugin(XecureMime.enabledPlugin.description,version))
				DownloadPackage(packageURL);
		}
		else {     // Xecure PlugIn 이 설치되어 있지 않은 경우
			DownloadPackage(packageURL);
		}
	}
}

/**
 * Netscape를 위해&lt;EMBED&gt; Tag를, Internet Explorer를 위해 &lt;OBJECT&gt; Tag를 document.write한다.<BR>
 * <BR>
 * example><BR>
 * &lt;html><BR>
 * &lt;head><BR>
 * &lt;form name='xecure' >&lt;input type=hidden name='p'>&lt;/form><BR>
 * &lt;script language='javascript' src='/XecureObject/xecureweb.js'>&lt;/script><BR>
 * &lt;script language='javascript' src='/XecureObject/xecureweb_file.js'>&lt;/script><BR>
 * &lt;script><BR>
 * PrintObjectTag();<BR>
 * PrintFileObjectTag();<BR>
 * &lt;/script><BR>
 * &lt;/head><BR>
 * &lt;body> &lt;/body>&lt;/html>
 * @ingroup etcAPI
 */
function PrintObjectTag()
{	
	if( IsNetscape60() )	
		alert("Netscape 6.0은 지원하지 않습니다") ;
	else
	{		
		if(navigator.appName == 'Netscape')
		{
			document.write("<EMBED type='application/x-SoftForum-XecSSL40' hidden=true name='XecureWeb'></EMBED><NOEMBED>No XecureWeb PlugIn</NOEMBED>");
		}
		else
		{
			// param 설정( name : value )
			//
			// [언어 설정]
			//    lang : KOREAN / ENGLISH
			//    ex) <PARAM NAME="LANG" VALUE="KOREAN">
			//
			// [보안 옵션] only over XecureWeb Client v5.3.0.1
			//    "보안 옵션"의 적용은 반드시 개발팀을 통해 자세한 내용을 확인한 후 사용하시기 바랍니다.
			//    sec_option :
			//	- xgate 주소로 서명 검증(디폴트는 host name으로 서명 검증)		: 0x00000080 = 128
			//	- 인증서 암호 재사용(IC카드의 경우 핀번호도 재사용)
			//        USBTOKE_KB의 경우, SetPinNum으로 핀번호를 preset해야 함	        : 0x00000040 =  64
			//	- 서명시 인증서 선택창없이 캐시된 인증서 사용(only for IC card, USBTOKEN_KB)
			//        USBTOKE_KB의 경우는 캐시하지 않고 자동으로 다시 읽어들임              : 0x00000020 =  32
			//	- 로그인시 인증서 선택창없이 캐시된 인증서 사용(only for IC card)	: 0x00000010 =  16
			//    sec_context : 서명값
			//    sec_desc : 임의의 문자열(storage가 iccard로 설정된 경우 ic카드 핀번호 입력창에 나타나는 안내문구. 설정되지 않으면 default 문구가 나타남)
			//
			// [인증서 저장매체 설정] only over XecureWeb Client v5.3.0.1
			//    storage : "HARD" / "REMOVABLE" / "ICCARD" / "CSP" / "VSC" / "USBTOKEN","USBTOKEN_KB","USBTOKEN_KIUP"
			//    ex1) <PARAM NAME="STORAGE" VALUE="HARD">
			//    ex2) <PARAM NAME="STORAGE" VALUE="HARD,REMOVABLE,ICCARD"> ==> 여러 개의 저장매체를 설정할 때에는 첫번째 저장매체가 우선 선택되어짐
			//
			// [키스트로크 해킹방지 옵션] only over XecureWeb Client v5.3.0.1
			//    seckey : KeyStroke 해킹방지툴 적용 여부, 해당하는 vendor에 대한 string value 입력
			//             현재[2003/10/30] 가능한 string value
			//             - "XW_SKS_SOFTCAMP_KEYPAD" : 소프트캠프의 키패드 버전
			//             - "XW_SKS_SOFTCAMP_DRIVER" : 소프트캠프의 드라이버 버전
			//             - "XW_SKS_KINGS_DRIVER"    : 킹스정보통신의 드라이버 버전
			//             - "_WITH_SKS_ENCRYPT"      : 폼 데이터의 패스워드 타입에 대해서 암호화 => BlockEnc 호출시 내부에서 다시 복호화함(xwcs_client.dll 사용)
			//    ex) <PARAM NAME="SECKEY" VALUE="XW_SKS_SOFTCAMP_KEYPAD"> ==> 소프트캠프의 키패드 버전 적용
			//    ex) <PARAM NAME="SECKEY" VALUE="XW_SKS_KINGS_DRIVER_WITH_SKS_ENCRYPT"> ==> 킹스정보통신의 드라이버 버전 적용 + 패스워드 타입 암호화
			//    ex) <PARAM NAME="SECKEY" VALUE="_WITH_SKS_ENCRYPT"> ==> 패스워드 타입 암호화만 지원
			//
			// [라이센스] only over XecureWeb Client v5.4.x
			//    XecureWeb Client의 특정 기능에 대해서 사이트 라이센스가 검증될 때에만 사용 가능
			//    현재 라이센스가 적용된 기능
			//      - 서명 검증(VerifySignedData)
			//    ex) <PARAM NAME="LICENSE" VALUE="개발팀에서 제공하는 서명값">
			
			//document.write('<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404" CODEBASE="http://phobos.softforum.co.kr:8188/XecureObject/xw_install.cab#Version=5,4,1,0" width=0 height=0>No XecureWeb PlugIn</OBJECT>');
			
			// test
			//document.write('<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404" CODEBASE="http://phobos.softforum.co.kr:8188/XecureObject/xw_install.cab#Version=5,4,1,0" width=0 height=0>');
			//document.write('<param name="storage" value="usbtoken_kb,hard,removable,csp,vsc"><param name="sec_option" value=96><param name="sec_context" value="30820649020101310b300906052b0e03021a0500302506092a864886f70d010701a018041670686f626f732e736f6674666f72756d2e636f2e6b72a0820467308204633082034ba003020102020103300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3033303132313030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920522644204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010041a27ed4a985ee6b9a1e8823537a34a4da4cdad762478acfe7d8727ba227f7606a108eacbb991675865e374d7a700e537a1662bb9dcd27b89f99e0c91ac963390a11a0f6d945b97bde543a9f05ffe8bfeeb2cdfbbd939f1242d4ed645daa0e8be02813d5360eb3784b4859928df7d397d55febbaf00a83de11e047121cffc72c2bccd28b3cf8dd74f5dbb22b1b16b9c710f74a9b0243fc7c67000f8c1e343ac094e7b3a459ed7b9fb679019f4ef6ab425644ca895e63c0e67b9ada35034004f9eabf41d30bdcd62a6b3dc115e4c226b810b12e51c2b82414830b1995adc7aa94c3f37434aaa260ce4117f4e9d23f9ed9caa9e6b856815984009958e6271731490203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e0416041418053cf13370b5ae2123a28f9e68f75731330788300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c535256432c4f553d536563757269747920522644204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d01010505000382010100329b1c2e5bf79586af02652e689f5451332746a7d4d290ff39c061612c93e8225837ee83eff242b50c27466961f4440f9900b202edbbcc1ebde1b63f31e76f6fe671c3afdf9ce8e513ec1e74ffd1b64658cdc3aa5db763b58dd1a9ca9671d50ea84c04fd491696a7dbf545d9058fef506da13ed4cbc292198a493d1a6225ec88cda9a94e79edc655655b223c5ec32ffacee0a8eaa3c87f2848e5085a32249426e66ee83611d1d3357113fc0a68e73f1d797430398d70a9a89b5ee124e3a7e1568582a74bc0b675988ffda2e34437cc0e303b98858c08fec39ad512c3a70f549716e82d6f4a79327cc71a1c20c03365af8b2898afb34b3b287e44b59731708d29318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020103300906052b0e03021a0500300d06092a864886f70d0101010500048201002913691bf3328c68353c827147ed29ebb80e17843131f0ebfdab00e355c52636fb8f13cf98cda2f5623f7449e1206d7f61be5d9f2fbd1cda7bf3d86b2c7ac29091a208177bc722a023d21ba3831264a715bae402aee27b0f401bc25ca72430fcc793a904709b449274cc071f1635a951aa99637c0564ca71ea5a8f10b5c07cfa5032e848e62411dda1bae95ba2ce759b2535b95a35109db6308098e85a8394b7ff180fe237e90cfaf6c6ba7d991edf878ebc7adbe68ea9322371141ddc1ba7560fdcf3ec59ffce70bcbf1029faa5dad1581c9a47d3f347c250c9d01d256243635dae1254d03a27e5bec661672f5a87ba2973c8ddf4ca20d653f7d25dec17e9b8">No XecureWeb PlugIn</OBJECT>');
			
			document.write('<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404" CODEBASE="http://phobos.softforum.co.kr:8188/XecureObject/xw_install.cab#Version=5,4,1,0" width=0 height=0><param name="lang" value="korean"><param name="lang" value="korean"><param name="LICENSE" value="3082065c020101310b300906052b0e03021a0500303806092a864886f70d010701a02b0429313a70686f626f732e736f6674666f72756d2e636f2e6b723a5665726966795369676e656444617461a0820467308204633082034ba003020102020103300d06092a864886f70d01010505003077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d301e170d3033303132313030303030305a170d3333303131333030303030305a308192310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e311e301c060355040b1315536563757269747920522644204469766973696f6e311c301a06035504031313536f6674666f72756d205075626c69632043413125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d30820121300d06092a864886f70d01010105000382010e00308201090282010041a27ed4a985ee6b9a1e8823537a34a4da4cdad762478acfe7d8727ba227f7606a108eacbb991675865e374d7a700e537a1662bb9dcd27b89f99e0c91ac963390a11a0f6d945b97bde543a9f05ffe8bfeeb2cdfbbd939f1242d4ed645daa0e8be02813d5360eb3784b4859928df7d397d55febbaf00a83de11e047121cffc72c2bccd28b3cf8dd74f5dbb22b1b16b9c710f74a9b0243fc7c67000f8c1e343ac094e7b3a459ed7b9fb679019f4ef6ab425644ca895e63c0e67b9ada35034004f9eabf41d30bdcd62a6b3dc115e4c226b810b12e51c2b82414830b1995adc7aa94c3f37434aaa260ce4117f4e9d23f9ed9caa9e6b856815984009958e6271731490203010001a381de3081db301f0603551d2304183016801409b5e27e7d2ac24a8f56bb67accebb93f5318fd3301d0603551d0e0416041418053cf13370b5ae2123a28f9e68f75731330788300e0603551d0f0101ff04040302010630120603551d130101ff040830060101ff02010030750603551d1f046e306c306aa068a06686646c6461703a2f2f6c6461702e736f6674666f72756d2e636f6d3a3338392f434e3d58656375726543524c535256432c4f553d536563757269747920522644204469766973696f6e2c4f3d536f6674666f72756d20436f72706f726174696f6e2c433d4b52300d06092a864886f70d01010505000382010100329b1c2e5bf79586af02652e689f5451332746a7d4d290ff39c061612c93e8225837ee83eff242b50c27466961f4440f9900b202edbbcc1ebde1b63f31e76f6fe671c3afdf9ce8e513ec1e74ffd1b64658cdc3aa5db763b58dd1a9ca9671d50ea84c04fd491696a7dbf545d9058fef506da13ed4cbc292198a493d1a6225ec88cda9a94e79edc655655b223c5ec32ffacee0a8eaa3c87f2848e5085a32249426e66ee83611d1d3357113fc0a68e73f1d797430398d70a9a89b5ee124e3a7e1568582a74bc0b675988ffda2e34437cc0e303b98858c08fec39ad512c3a70f549716e82d6f4a79327cc71a1c20c03365af8b2898afb34b3b287e44b59731708d29318201a33082019f020101307c3077310b3009060355040613024b52311e301c060355040a1315536f6674666f72756d20436f72706f726174696f6e3121301f06035504031318536f6674666f72756d20526f6f7420417574686f726974793125302306092a864886f70d010901161663616d617374657240736f6674666f72756d2e636f6d020103300906052b0e03021a0500300d06092a864886f70d01010105000482010009fb7f805e9c8b7d6a35f6519d3a4a5f5cf2b394e622003b43cdf4f5a80d9b032586f8b18b267a2188e1146a8bdca1d0461cd548c1378dacfbce16a228fe14d35537c86abe3a42fa4e70ebd74774d17ba792aca313f49456d09dd72dadb67767c4a452100b32d5f1595d055aa3f38d992473a3896129f79b99208294170a7aedc553720fc55b80668f3b76f43dfa0ba914697fc9691e271c9be102822cd9968919de6a62b921112e7ee2fba9b7e7a48a1378a7fa61b14d5738ab066f6b816642b37117aec32e18010ad8feae452c5f5a70a10d67973647d24f68169e80a8dc971823235ae51d77186ae98fee1e28455dc930cf2aa51f6d12eb02e452e00957c3">No XecureWeb PlugIn</OBJECT>');
		}
	}
}

function get_sid() 
{
	var sid = document.XecureWeb.BlockEnc ( xgate_addr, "", "", "GET" );
        
	if( sid == "") 	return XecureWebError() ;
        
	return sid;
}

// applet에서 servlet으로 보낼 값을 암호화 하는 function
function enc(str) {
	var state='';
	var plain='';
	var escaped_state='';
	plain=String(str);

	if (navigator.appName == 'Netscape')
		state=XecureWeb.BlockEnc(xgate_addr, path, escape(plain), "POST");
	else
   		state=XecureWeb.BlockEnc(xgate_addr, path, plain, "POST");
   	//escaped_state=escape_url(state);
   	escaped_state=escape_url_applet(state);
//   	alert("POST:" + escaped_state);
	return escaped_state;
}

// servlet에서 applet으로 보내준 값을 복호화 하는 function
function dec(str) {
	var result=BlockDec(str);
	return result;
}

function XecureNavigate2iframe( url, target, feature, sid) 
{
	var qs ;
	var path = "/";
	var cipher;
	var xecure_url;

	path = getPath(url);
	
	cipher = document.XecureWeb.BlockEnc(xgate_addr, path, XecureEscape(qs),"POST");
		
	if( cipher.length == 0 ) 	return XecureWebError() ;
	
	xecure_url = path + "?q=" + sid + ";" + escape_url(cipher);
	if (feature=="" || feature==null) open ( xecure_url, target );
	else open(xecure_url, target, feature );
}

function getPath(url)
{
	var path = "/";
	// get path info & query string & hash from url
	qs_begin_index = url.indexOf('?');
	// if action is relative url, get base url from window location
	if ( url.charAt(0) != '/' && url.substring(0,7) != "http://" ) {
		path_end = window.location.href.indexOf('?');
		if(path_end < 0)	path_end_str = window.location.href;
		else				path_end_str = window.location.href.substring(0,path_end); 
		path_relative_base_end = path_end_str.lastIndexOf('/');
		path_relative_base_str = path_end_str.substring(0,path_relative_base_end+1);
		path_begin_index = path_relative_base_str.substring (7,path_relative_base_str.length).indexOf('/');
		if (qs_begin_index < 0){
			path = path_relative_base_str.substring( 7+path_begin_index,path_relative_base_str.length ) + url;
		}
		else {
			path = path_relative_base_str.substring( 7+path_begin_index,path_relative_base_str.length )
				 + url.substring(0, qs_begin_index );
		}
	}
	else if ( url.substring(0,7) == "http://" ) {
		path_begin_index = url.substring (7, url.length).indexOf('/');
		if (qs_begin_index < 0){
			path = url.substring( path_begin_index + 7, url.length);
		}
		else {
			path = url.substring(path_begin_index + 7, qs_begin_index );
		}
	}
	else if (qs_begin_index < 0){
		path = url;
	}
	else {
		path = url.substring(0, qs_begin_index );
	}
	return path;
}

// option bit : _4_ _3_ _2_ _1_
//                       |   |
//                       |   --- 0 : 모든 인증서 리스트업, 1 : 로그인한 인증서 사용
//                       ------- 0 : 사용자에게 idn 입력 요구, 1 : idn에 "NULL" setting, 서버에서 idn 설정

/**
 * 인증서의 식별번호를 검증한다.<BR/>
 *
 * @ingroup etcAPI
 * @param Idn <PRE>검증할 인증서의 식별번호<BR>
 * Idn에 “”이면 사용자로부터 IDN을 입력받는다.<BR>
 * option bit : _4_ _3_ _2_ _1_<BR>
 *                       |   |<BR>
 *                       |   --- 0 : 모든 인증서 리스트업, 1 : 로그인한 인증서 사용<BR>
 *                          ------- 0 : 사용자에게 idn 입력 요구, 1 : idn에 "NULL" setting, 서버에서 idn 설정</PRE>
 * @param TimeStamp 서버의 타임스탬
 * @param ServerCertPem pem타입의 서버인증서
 *
 * @return 성공하면 VID정보를 envelop한 결과 리턴
 * 실패시 “” 리턴
 */
function VerifyVirtualID(Idn, TimeStamp, ServerCertPem)
{
	var msg;
	
	var option = 0;
	
	option = 0;   // 모든 인증서 리스트업, 사용자에게 idn 입력 요구
//	option = 1;   // 로그인한 인증서 사용, 사용자에게 idn 입력 요구
// only over XecureWeb Client v5.3.0.1
//	option = 2;   // 모든 인증서 리스트업, idn에 "NULL" 설정
//	option = 3;   // 로그인한 인증서 사용, idn에 "NULL" 설정
	
	if( IsNetscape() )
	{
		msg = document.XecureWeb.VerifyAndGetVID(xgate_addr, ServerCertPem, TimeStamp, escape(accept_cert), option, escape(Idn));
	}
	else 
	{
		msg = document.XecureWeb.VerifyAndGetVID(xgate_addr, ServerCertPem, TimeStamp, accept_cert, option, Idn);
	}
	
	return msg;

}

// nOption is 0 : (default value) File version, which is checked by 'Internet Explorer'
//            1 : Product version
//            2 : File Description
/**
 * XecureWeb Control 에 관련된 버전 정보를 리턴한다.
 *
 * @ingroup etcAPI
 * @param nOption <BR>
 * 0 : (default value) File version, which is checked by 'Internet Explorer'<BR>
 * 1 : Product version<BR>
 * 2 : File Description
 *
 * @return nOption 에 따른 버전 정보<BR>
 * 그냥 GetVersion()을 호출하면 Object tag에서 참조하는 버전을 얻을 수 있다.<BR>
 * 리턴값은 “7, 0, 5, 0” 과 같은 형식이다.
 *
 */
function GetVersion(nOption)
{
	var ver;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
		ver = "";
	}
	else
	{
		ver = document.XecureWeb.GetVerInfo(nOption);
		if( ver == "" )
			alert("No version information");
	}
	
	return ver;
}

// only over XecureWeb Client v5.3.0.1
/**
 * infoURL로부터 가져온 서명된 업데이트 정보파일을 이용하여 필요한 파일을 다운로드하여 설치한다.<BR>
 *
 * @ingroup etcAPI
 * @param infoURL : 업데이트 정보파일이 있는 URL<BR>
 * Ex) infoURL = “http://download.softforum.co.kr/ XecureWeb/Update/info.ini.sig”
 *
 * @return 0 : 성공, 1 : 사용자 취소, 2 : 업데이트할 파일을 다른 애플리케이션에서 사용중, 3 : 이미 업데이트되었음, 4 : 업데이트 권한이 없는 사용자, 5 : 최신 버전임, -1 : 실패
 */
function UpdateModules( infoURL )
{
	var	ret;
	
	if( IsNetscape() )
	{
		alert("Not supported function");
		ret = 0;
	}
	else
	{
		// success : 0, cancel : 1, file(s) holded : 2, already updated : 3, invalid user : 4, need not : 5
		// error : -1
		ret = document.XecureWeb.UpdateModules( infoURL );
	}
		
	return	ret;
}

// only over XecureWeb Client v5.3.0.1
/**
 * 사용자 PC에 저장된 업데이트 정보파일의 내용을 변경한다.<BR>
 * <BR>
 * example><BR>
 * SetUpdateInfo( “PERIOD”, “Apply”, “0” );<BR>
 * => 하루로 설정되어 있는 업데이트 주기를 일시적으로 무효화시킴<BR>
 *
 * @ingroup etcAPI
 * @param section 다운로드된 업데이트 정보파일의 section name
 * @param key section내부의 key name
 * @param value1 변경할 실제 value
 *
 * @return 0 : 성공, -1 : 실패
 */
function SetUpdateInfo( section, key, value1 )
{
	var	ret;
	
	if( IsNetscape() )
	{
		alert( "Not supported function" );
		ret = 0;
	}
	else
	{
		ret = document.XecureWeb.SetUpdateInfoString( section, key, value1 );
	}
	
	return ret;			
}

// inserted by knlee 2003/06/10
function SetProviderList()
{
	var	ret;
	
	//var	provName = "TrustedNet Connect 2 Smart Card CSP;Microsoft Base Cryptographic Provider v1.0;Microsoft Enhanced Cryptographic Provider v1.0";
	var	provName = "TrustedNet Connect 2 Smart Card CSP;Keycorp CSP";
	
	if( IsNetscape() )
	{
		alert("Not supported function");
		return -1;
	}
	else
	{
		ret = document.XecureWeb.SetProvider(provName);
		if( ret != 0 )
			alert("Set Provider name is Fail!");
	}
	
	return ret;
}

// applet에서 servlet으로 보낼 값을 암호화 하는 function
function enc(str) {
	var state='';
	var plain='';
	var escaped_state='';
//	plain=String(str);

	alert("enc : " + str.length);
	if (navigator.appName == 'Netscape')
		state=XecureWeb.BlockEnc(xgate_addr, "/off", escape(str), "POST");
	else
   		state=XecureWeb.BlockEnc(xgate_addr, "/off", str, "POST");
   	//escaped_state=escape_url(state);
//   	escaped_state=escape_url_applet(state);
   	alert("POST:" + state.length);
	alert("enc end");
	return state;
}

// servlet에서 applet으로 보내준 값을 복호화 하는 function
function dec(str) {
	var result=BlockDec(str);
	return result;
}

function quick_escape(str)
{
	var len, leftlen, cut, i, j, pos, k;
	var out = "", out1 = "", out2 = "";

	len = str.length;
	if(len > 160) {
		leftlen = len/2;
		cut = Math.round(leftlen);
		out1 = quick_escape(str.substring(0, cut));
		out2 = quick_escape(str.substring(cut));
		out = out1 + out2;
	}else {
		pos = 0;
		j = -2;
		k = -2;
		while (pos > -1 && pos < len) 
		{
			if(j == -2)
				j = str.indexOf('+', pos);
			if(k == -2)		
				k = str.indexOf('=', pos);
			if(j < 0 && k < 0) {
				out += str.substring(pos);
				break;
			}
			if ((j < k && j > -1) || (j > -1 && k < 0))
			{
				out += str.substring(pos, j);
				out += '%2B';
				pos = j + 1;
				j = -2;
			}
			else if ((j > k && k > -1) || (k > -1 && j < 0))
			{
				out += str.substring(pos, k);
				out += '%3D';
				pos = k + 1;
				k = -2;
			}
			else{
				out += str.substring(pos);
				pos = -1;
			}
		}
	}
	return out;
}
function escape_url_applet(in_str)
{
	var len, leftlen, cut;
	var out = "", out1 = "", out2 = "";
	
	len = in_str.length;
	
	if(len > 160) {
		leftlen = len/2;
		cut = Math.round(leftlen);
		out1 = quick_escape(in_str.substring(0, cut));
		out2 = quick_escape(in_str.substring(cut));
		out = out1 + out2;
	}else {
		out = quick_escape(in_str);
	}
	alert("escape_url_applet end : " + out.length);
	return out;
} 

/*
	*** valid for only XWebFilCom v5.5.x ***
	
	It is possible to combine following option flags
	[EXCEPTION]
	   - 1,2 cannot be used simultaneously
	   - 4 is valid for only 1
	
	envOption  =   1 : 인증서기반 전자봉투
	           =   2 : 패스워드기반 전자봉투
	           =   4 : 여러 개의 인증서로 전자봉투
	           =   8 : CMS 타입으로 Envelop
	           = 256 : 로그인한 인증서로 전자봉투
	           
	return value
	   - success : enveloped message
	   - fail    : ""
*/
function EnvelopData( inMsg, pwd, certPem, envOption )
{
	var envMsg;

		
	envMsg = document.XecureWeb.EnvelopData(
			xgate_addr, 
			XecureEscape(accept_cert), 
			XecureEscape(inMsg), 
			envOption, 
			pwd, 
			certPem, 
			"", 
			0, 
			"", 
			3 );

   	if( envMsg == "" )
   	{
		XecureWebError();
   	}

	return envMsg;
}

// added Park, sohyun
// MultiSignData 추가
//Multi_Sign을 하기위해 처음에 실행.
//변수 초기화, Sign Id 받음.
var s_sign_desc = "MultiSign";
var s_bannerPath = "CHB_EFMS";
var cert_serial = "0376b015";

/*
 * Multi_Sign을 하기위해 처음에 실행<BR/>
 */
function Multi_Sign_Init()
{
    var multiSignId;

    multiSignId = document.XecureWeb.MultiSignInit();  //MultiSignInit()호출

    if( multiSignId < 0 )
    {
        XecureSignError();
    }
    else
    {
    }
    return multiSignId;
}

/*
 * Multi_Sign 데이터를 설정한다.
 */
function Set_Multi_Sign_Data(multiSignId, plain)
{
    var     originalDataTotalSize = 0;

    if(multiSignId != "")
    {
        originalDataTotalSize = document.XecureWeb.SetMultiSignData(multiSignId, plain);

        if( originalDataTotalSize < 0 )
        {
            XecureSignError();
        }
        else
        {
        }
    }
    else
    {
    alert("MultiSignInit를 먼저 해주십시오");
    }

    return originalDataTotalSize;
}

// option :
//              0 : 서명 원문 출력 안함
//              1 : 서명 원문 출력
//x2            0 : hex encoding
//x2            1 : BASE64 encoding
// mask : 0 : all certificates
//        1 : only user certificates
//        2 : only coperation certificates

// 최신은 MultiSign 함수 주석 참고

function Multi_Sign(multiSignId, Option)
{
    var result = 0;

    if(multiSignId != "")
    {
        result = document.XecureWeb.MultiSignEx(multiSignId, xgate_addr, accept_cert, sign_desc, Option, 2);

        if( result < 0 )
        {
            alert("서명에 실패했습니다.");//XecureSignError();
        }
        else
        {
            alert("서명 성공");
        }
    }
    else
    {
        alert("MultiSignInit를 먼저 해주십시오");
    }
    return result;
}

/**
 * MultiSign 내부에서 사용하는 기능.<BR>
 */
function Get_Multi_Signed_Data(multiSignId, index)
{
    var signedData = "";

    if(multiSignId != "")
    {
        signedData = document.XecureWeb.GetMultiSignedData(multiSignId,
index);
        if( signedData == "" )
        {
        XecureSignError();
        }
        else
        {
                //alert("가져오기 성공");
        }
    }
    else
    {
        alert("MultiSignInit를 먼저 해주십시오");
    }
    return signedData;
}

//Multi_Sign을 위해 마지막에 Call
//사용한 메모리 공간 free
/**
 * MultiSign 내부에서 사용되는 기능으로 사용한 메모리를 해제한다.<BR>
 */
function Multi_Sign_Final(multiSignId)
{
    var result;

    result = document.XecureWeb.MultiSignFinal(multiSignId);

    if( result < 0)
    {
        XecureSignError();
    }
    else
    {
        multiSignId = 0;
    }

    return result;
}

/**
 * 주어진 구분자로 구분된 평문을 받아. 각각의 token에 대해서 전자서명을 한다.<BR>
 * 이때, 전자서명된 값 또한 구분자로 구분된다.<BR>
 * 
 * @param total 서명할 데이터의 갯수
 * @param sign_msg 서명할 데이터
 * @param delimeter 입력 메시지의 구분자
 * @return 구분자로 이루어진 전자서명 데이터
 */
function MultiSign(total,sign_msg,delimeter)
{
    var signed_msg = "";
    var multiSign_id = "";
    var tmp = sign_msg;
    var index= "";
    var length = "";
    var signed_tmp;// = "";
    var ret = "";

    if (total <= 0 || sign_msg == "")
    {
        alert("서명할 데이타가 없습니다");
        return;
    }

    //Multi전자서명 초기화
    multiSign_id = Multi_Sign_Init();

    //서명값 세팅
    for(i =0;i < total ;i++)
    {
        length = tmp.length;
        index = tmp.indexOf(delimeter);

        Set_Multi_Sign_Data(multiSign_id,tmp.substring(0,index));
        tmp = tmp.substring(index+1,length);
    }
    //서명값 생성
    ret = Multi_Sign(multiSign_id,131072);//HEX  encoding

    if(ret != 0)
    {
        return ;
    }

    //서명값 추출
    for(i = 0; i < total ; i++)
    {
        signed_tmp = Get_Multi_Signed_Data(multiSign_id,i);

        if( signed_tmp == "")
        {
                alert('aaa');
                break;
        }
        signed_msg += signed_tmp + delimeter;
    }

        Multi_Sign_Final(multiSign_id);

    return signed_msg;
}


/**
 * 주어진 구분자로 구분된 평문을 받아. 각각의 token에 대해서 주어진 serial을 가진 인증서로 전자서명을 한다.<BR>
 * 이때, 전자서명된 값 또한 구분자로 구분된다.<BR>
 * 
 * @param total 서명할 데이터의 갯수
 * @param sign_msg 서명할 데이터
 * @param delimeter 입력 메시지의 구분자
 * @param serial 서명에 사용할 인증서의 시리얼 번호
 * @param locaton 서명에 사용할 인증서의 위치 정보
 * @return 구분자로 이루어진 전자서명 데이터
 * @see MultiSign
 */
function MultiSignWithSerial(total, sign_msg, delimeter,serial,locaton)
{
    var signed_msg = "";
    var multiSign_id = "";
    var tmp = sign_msg;
    var index= "";
    var length = "";
    var signed_tmp = "";
    var ret = "";

    if (total <= 0 || sign_msg == "")
    {
        alert("서명할 데이타가 없습니다");
        return;
    }

    //Multi전자서명 초기화
    multiSign_id = Multi_Sign_Init();

    //서명값 세팅
    for(i =0;i < total ;i++)
    {
        length = tmp.length;
        index = tmp.indexOf(delimeter);

        Set_Multi_Sign_Data(multiSign_id,tmp.substring(0,index));
        tmp = tmp.substring(index+1,length);
    }
    ret = Multi_Sign_with_serial(multiSign_id, 256+65536+131072, serial,locaton); //base64  encoding
    if(ret != 0)
    {
        return ;
    }

    //서명값 추출
    for(i = 0; i < total ; i++)
    {
        signed_tmp = Get_Multi_Signed_Data(multiSign_id,i);
        signed_msg += signed_tmp + delimeter;
    }
    return signed_msg;
}

function GetUserHWInfo(opOpt, ServerCertPem)
{
	var CertInfo;
	alert(opOpt);
			
	CertInfo = document.XecureWeb.GetUserHWInfo( opOpt, ServerCertPem );
					
	alert(CertInfo);
	return CertInfo;
}

