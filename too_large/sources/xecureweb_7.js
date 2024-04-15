
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
var MultiSignWithSerial(var total, var sign_msg, var delimeter, var serial, var locaton) { }

/**
 * 주어진 문자열을 Escape 처리 해준다.<BR>
 *
 * @param Msg 원문
 * @return Escape된 문자열
 */
var XecureEscape(var Msg) { }

/**
 * 전자 서명시 식별번호 확인의 기능을 사용할 경우, IDN 값을 Web Application 이 넘겨줄 경우, 서명하기 이전에 이 함수를 통하여 idn 을 넘겨준다.<BR>
 * Sign_with_vid_web() 내부에 적용되어 있음.
 *
 * @ingroup digitalSignAPI
 * @param idn 식별번호(주민등록/사업자등록번호)
 * @return Success : 0<BR>
 * Fail : -1
 */
var Set_ID_Num(var idn) { }

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
var Sign_with_desc(var plain, var desc) { }
var xecure_ca_type_1;

/**
 * 전자봉투를 지원하는 XecureNagivate<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureNavigate
 */
var XecureNavigate_Env(var url, var target, var feature) { }

/**
 * ISO 형식의 url을ASCII 문자열로 전환한다.
 *
 * @ingroup etcAPI
 * @param url escape 처리할 문자열
 * @return escape 처리된 문자열
 */
var escape_url(var url) { }
var getPath(var url) { }
var XecureAddQuery(var qs) { }
var s_sign_desc;

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
var Sign_with_vid_web(var option, var plain, var svrCert, var idn) { }
var Multi_Sign(var multiSignId, var Option) { }

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
var VerifyVirtualID(var Idn, var TimeStamp, var ServerCertPem) { }
var isOldPlugin(var desc, var version) { }
var ran_gen() { }
var Multi_Sign_Init() { }
var XecureMakePlain_Org(var form) { }

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
var SetUpdateInfo(var section, var key, var value1) { }
var XecureWebError() { }

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
var Sign_with_vid_user(var option, var plain, var svrCert) { }

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
var XecureNavigate_NoEnc(var url, var target) { }
var xecure_ca_ip_1;
var cert_serial;

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
var Sign_with_vid_user_serial(var certSerial, var certLocation, var option, var plain, var svrCert) { }

/**
 * Xgate_addr에 해당하는 보안세션을 강제로 종료한다.
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : 오류코드
 */
var EndSession() { }
var versionRel;

/**
 * 인증기관 인증서 다운로드시 인증기관 인증서<BR>
 */
var pCaCertUrl;

/**
 * MultiSign 내부에서 사용되는 기능으로 사용한 메모리를 해제한다.<BR>
 */
var Multi_Sign_Final(var multiSignId) { }
var Set_Multi_Sign_Data(var multiSignId, var plain) { }
var gIsContinue;
var escape_url_applet(var in_str) { }
var dec(var str) { }
var enc(var str) { }

/**
 * 주어진 구분자로 구분된 평문을 받아. 각각의 token에 대해서 전자서명을 한다.<BR>
 * 이때, 전자서명된 값 또한 구분자로 구분된다.<BR>
 * 
 * @param total 서명할 데이터의 갯수
 * @param sign_msg 서명할 데이터
 * @param delimeter 입력 메시지의 구분자
 * @return 구분자로 이루어진 전자서명 데이터
 */
var MultiSign(var total, var sign_msg, var delimeter) { }

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
var PrintObjectTag() { }
var versionMin;
var XecurePath(var xpath) { }
var s_bannerPath;

/**
 * 인증기관 인증서 다운로드시 인증기관 인증서 CN<BR>
 */
var pCaCertName;

/**
 * 금결원 CA의 서비스 Port
 */
var yessign_ca_port;

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
var GenCertReq() { }

/**
 * 암복호시 페이지에 명시된 문자셋의 사용 여부<BR>
 * XecureWeb Java 버전 암복호시 시스템 디폴트 인코딩과 다른 문자셋의<BR>
 * 메세지를 처리하는 경우 true 설정
 *
 * @since 6.0 v210
 */
var usePageCharset;

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
var XecureLink(var link) { }
var get_sid() { }
var xecure_ca_ip;

/**
 * ClientSM의 인증서 관리자 메뉴를 웹 상에서 직접 호출하여 사용할 수 있다.
 * @ingroup etcAPI
 */
var ShowCertManager() { }

/**
 * 전자서명, 인증서 갱신, 인증서 폐기시에 인증서 암호오류를 허용회수<BR>
 */
var pwd_fail;

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
var XecureNavigate(var url, var target, var feature) { }
var XecureWebPlugin(var version) { }

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
var XecureSubmit(var form) { }
var Set_PinNumber(var pin) { }
var EnvelopData(var inMsg, var pwd, var certPem, var envOption) { }

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
var GetVersion(var nOption) { }

/**
 * 연결된 세션정보를 찾아서 해당 키로 암호화된 XML 데이터를 복호화한다.
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher : 복호화할 XML data의 암호문
 * @return Success : 복호화된 평문<BR>
 * Fail : empty string (“”) 
 */
var BlockXMLDec(var cipher) { }

/**
 * 전자서명 확인창에 보일 메세지와 전자서명 확인창 보기 옵션<BR>
 * 0 : 서명 원문 출력 안함, 1: 서명 원문 출력 
 */
var show_plain;
var versionMaj;
var DownloadPackage(var packageURL) { }

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
var PutBannerUrl() { }

/**
 * 서명원문 확인창의 기본 설명문<BR>
 */
var sign_desc;
var busy_info;

/**
 * infoURL로부터 가져온 서명된 업데이트 정보파일을 이용하여 필요한 파일을 다운로드하여 설치한다.<BR>
 *
 * @ingroup etcAPI
 * @param infoURL : 업데이트 정보파일이 있는 URL<BR>
 * Ex) infoURL = “http://download.softforum.co.kr/ XecureWeb/Update/info.ini.sig”
 *
 * @return 0 : 성공, 1 : 사용자 취소, 2 : 업데이트할 파일을 다른 애플리케이션에서 사용중, 3 : 이미 업데이트되었음, 4 : 업데이트 권한이 없는 사용자, 5 : 최신 버전임, -1 : 실패
 */
var UpdateModules(var infoURL) { }
var DeleteCertificate(var dn) { }

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
var Verify_SignedData(var signedData, var option, var directoryServer) { }

/**
 * Send_vid_info_user() 또는 Send_vid_info_web() 호출을 통하여 식별번호가 주입된 인증서의 경우,<BR>
 * 식별번호(VID)를 확인하기 위한 정보를 암호화 하여 return 한다.<BR>
 * 만약, 식별번호가 주입되지 않은 인증서의 경우 null 을 return 한다.
 * 
 * @ingroup digitalSignAPI
 * @return Success : 식별 번호 검증을 위해 암호화된 정보<BR>
 * Fail : empty string (“”)
 */
var send_vid_info() { }

/**
 * 금결원 CA의 종류<BR>
 * 1 : Yessign Real<BR>
 * 11 : Yessign Test
 */
var yessign_ca_type;
var IsNetscape60() { }

/*************For Applet**********************/
var BlockEnc(var auth_type, var plain_text) { }
var isNewPlugin(var desc) { }

/**
 * 전자봉투를 지원하는 XecureSubmit<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureSubmit
 */
var XecureSubmit_Env(var form) { }

/**
 * 연결된 세션정보를 찾아서 해당 키로 암호문을 복호화한다.<BR>
 *
 * @ingroup serverResponseCryptoAPI
 * @param cipher 복호화할 암호문
 * @return Success : 복호화된 평문<BR>
 * Fail : empty string (“”) 
 */
var BlockDec(var cipher) { }

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
var RevokeCertificate(var type, var jobcode, var reason) { }

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
var Sign_with_option(var option, var plain) { }

/**
 * 서명에 사용될 유효한 인증기관 목록 (CN)<BR>
 * Sign, RequestCertificate, RevokeCertificate 시 나타나는 인증서 목록 <BR>
 * XecureWeb ver 5.1 에서는 accept_cert 에 유효한 인증기관 인증서의 <BR>
 * CN 을 정확히 적어준다.<BR>
 * ver 4.0 에서 yessign 이라 적었던 것은 yessignCA-TEST, yessignCA 로 세분화 된다.<BR>
 * YESSIGN TEST : yessignCA-TEST<BR>
 * YESSIGN REAL : yessignCA<BR>
 */
var accept_cert;
var quick_escape(var str) { }

/**
 * 금결원 CA의 서비스 IP
 */
var yessign_ca_ip;

/**
 * MultiSign 내부에서 사용하는 기능.<BR>
 */
var Get_Multi_Signed_Data(var multiSignId, var index) { }

/**
 * 사설 인증기관을 사용시 사설인증기관 인증서를 사용자에게 배포한다.<BR>
 *
 * @ingroup etcAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
var PutCACert() { }

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
var Sign_Add(var option, var plain) { }

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
var InstallCertificate(var cert_type, var cert) { }

/**
 * 로그인 창에 보일 이미지를 다운로드 받을 URL<BR>
 */
var bannerUrl;

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
var RequestCertificate(var type, var ref_code, var auth_code) { }
var packageURL;
var SetProviderList() { }
var XecureNavigate2iframe(var url, var target, var feature, var sid) { }

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
var XecureLogIn(var link) { }
var downloadNow() { }
var XecureUnescape(var Msg) { }

/**
 * 전자봉투를 지원하는 XecureLink<BR>
 *
 * @ingroup clientRequestCryptoAPI
 * @since XecureWeb 6.0 v220
 * @see XecureLink
 */
var XecureLink_Env(var link) { }

/**
 * xgate 서버 명:포트 지정 , 포트 생략시 디폴트로 443 포트 사용<BR>
 */
var xgate_addr;

/**
 * 주어진 form 문의 입력필드중 type이button/reset/submit인 것을 제외하고<BR>
 * aa=bb&cc=dd&ee=…  형식으로 재작성하여 리턴한다.
 *
 * @param form form 객체
 * @return Form 문의 입력필드로 새로이 작성한 데이터
 */
var XecureMakePlain(var form) { }
var IsNetscape() { }

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
var Sign_with_serial(var certSerial, var certLocation, var plain, var option) { }

/**
 * 관리창, 서명창, Login창에서 인증서 List를 구분하여 발급자를 Rename할 때<BR>
 * 사용하며, 구분은 인증서의 정책값을 기준으로 Rename되고, Default는 사설인증서 이다.<BR>
 * 발급자는 인증서 발급자의 CN값을 기준으로 Rename된다.<BR>
 * 자세한 것은 SE에게 문의.<BR>
 * @ingroup etcAPI
 */
var SetConvertTable() { }
var xecure_ca_port;
var UserAgent() { }

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
var Sign_with_vid_web_serial(var certSerial, var certLocation, var option, var plain, var svrCert, var idn) { }
var xecure_ca_port_1;

/**
 * 이 함수를 실행시키면 갱신할 인증서를 선택한후 그 인증서를 갱신하여 선택된 위치에 다시 저장시킨다. ( 하드디스크/플로피 디스크/IC카드)
 *
 * @ingroup CMPAPI
 * @return Success : 0<BR>
 * Fail : -1
 */
var RenewCertificate(var type) { }

/**
 * 주어진 데이터에 전자서명을 한다.<BR>
 * 서명원문 확인창이 뜰 경우 창의 설명문은 sign_desc 이다.<BR>
 * 이 함수를 호출하면 전자서명만 이루어질 뿐 보안세션이 연결되지는 않는다.<BR>
 * @ingroup digitalSignAPI
 * @param plain :  서명하고자 하는 서명 원문
 * @return Success : 서명된 문서[전자서명문=원문+서명값+인증서]<BR>
 * Fail : empty string (“”) 
 */
var Sign(var plain) { }
var xecure_ca_type;

