<%@ page contentType = "text/html; charset=UTF-8" %>
<% session.setAttribute("popup_name", "신규업체등록"); %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
	if(session.getAttribute("MENU_TOP") != null){
%>
	<script>
		location.href = "<%=POASRM_CONTEXT_NAME%>/common/logout_process.jsp";
	</script>
<%		
	}

	
	String request_server_name = SepoaString.replace(request.getServerName(), ".", "");
	String prev_url = request.getParameter("prev_url");
	

	if(StringUtils.isNumeric(request_server_name) && ! devCheckFlag)
	{
%>
		<script>
			alert("운영 장비에서는 IP 로 접속할 수 없습니다. Domain 으로 접속하시기 바랍니다.");
		</script>
<%
		return;
	}
	// 임시적으로..
	//SepoaSession.putValue(request, "COMPANY_CODE", "1000");
	
%>


<%
try{
	if( sepoa.fw.util.CommonUtil.Flag.Yes.getValue().equals((String)session.getAttribute("sso_flag")) ) {
		response.sendRedirect("login_process.jsp");
	}
	/* Browser Language */
	/* 용도에 따라서 사용하기 위함. */
	/* 예) 다국어 처리등 */
	String browser_language = request.getParameter("browser_language")==null?"":request.getParameter("browser_language").toUpperCase();
	sepoa.fw.ses.SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);

	//if(browser_language.trim().length() <= 0)  
	//{
		browser_language = "KO";
	//}


	if(info.getSession("ID").trim().length() <= 0)
	{
		
		info = new SepoaInfo("000","ID=SUPPLIER^@^LANGUAGE=" + browser_language + "^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement("LOGIN");
	HashMap text = MessageUtil.getMessage(info, multilang_id);

	/* parameter 는 공지사항 가지고 올려는 갯수 */
// 	Object[] obj = {5, browser_language};
//     SepoaOut value = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getBulletinList", obj);
//     SepoaFormater sf = new SepoaFormater(value.result[0]);
//     int sfCount = sf.getRowCount();
    
   /* parameter 는 FAQ 가지고 올려는 갯수 */
	
//     Object[] obj2 = {5, browser_language};
//     SepoaOut value2 = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getFaqList", obj);
// 	SepoaFormater sf2 = new SepoaFormater(value2.result[0]);
//     int sfCount2 = sf2.getRowCount();
 	 
 	
    /*
     예외처리될 IP를 SCODE에서 가지고온다. 
	Object[] obj1 = {};
    SepoaOut value1 = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getIPaddr", obj1);
    SepoaFormater sf1 = new SepoaFormater(value1.result[0]);*/
    
    String[] args = {"000"};
    Object[] objs  = {(Object[])args};
	SepoaOut value = null;
	SepoaRemote wr = null;

	String nickName = "s6030";
	String MethodName = "getEdagGuidYn";
	String conType = "CONNECTION";
	
	//String[] args2 = {"000"};
	//Object[] obj2 = {(Object[])args2};
	//value2 = ServiceConnector.doService(info, "s6030", "CONNECTION", "getUcTobeAsisYn", obj2);

	SepoaFormater wf_App    = null;
	String edagGuidYn       = "Y";
    
    try {
		int idx = 0;

		wr = new SepoaRemote(nickName, conType, info);
		value = wr.lookup(MethodName, objs);
        
		wf_App = new SepoaFormater(value.result[idx++]);//결재요청
		if (wf_App.getRowCount() > 0) {
			edagGuidYn = wf_App.getValue("YN", 0);
		}
	} catch (Exception e) {
		Logger.err.println(info.getSession("ID"), this,
				"e ================> " + e.getMessage());
		Logger.dev.println(e.getMessage());
	} finally {
		wr.Release();
	} // finally 끝
%>
<%!
	public String getShortString( String str, int byteSize )
	{
		int rSize = 0;
		int len = 0;

		if ( str.getBytes().length > byteSize ) {
			for ( ; rSize < str.length(); rSize++ ) {
				if ( str.charAt( rSize ) > 0x007F )
					len += 2;
				else
					len++;

				if ( len > byteSize )
					break;
			}
			str = str.substring( 0, rSize ) + "...";
		}

		return str;
	}
%>
<%!
	public String deconvertDate(String dataData){
		if(dataData != null && dataData.length() ==10){
			dataData = dataData.replaceAll("/","");
			return dataData;
		}
		return dataData;
	}

	public String convertDate(String dataData){
		String convert_year="";
		String convert_month ="";
		String convert_day="";
		if(dataData != null && dataData.length() ==8){
			convert_year = dataData.substring(0,4);
			convert_month = dataData.substring(4,6);
			convert_day = dataData.substring(6,8);
			dataData = convert_year+"/"+convert_month+"/"+convert_day;
		}
		return dataData;
	}

	public String convertTime(String dataData){
		String convert_hh="";
		String convert_mm ="";
		String convert_ss="";
		if(dataData != null && dataData.length() ==6){
			convert_hh = dataData.substring(0,2);
			convert_mm = dataData.substring(2,4);
			convert_ss = dataData.substring(4,6);
			dataData = convert_hh+":"+convert_mm+":"+convert_ss;
		}
		return dataData;
	}

	public String convertNullStr(String dataData){

		if(dataData == null){
			dataData = "";
		}
		return dataData;
	}

	public static String translate(String s) {
		if ( s == null ) return null;

		StringBuffer buf = new StringBuffer();
		char[] c = s.toCharArray();
		int len = c.length;
		for ( int i=0; i < len; i++) {
			if      ( c[i] == '&' ) buf.append("&amp;");
			else if ( c[i] == '<' ) buf.append("&lt;");
			else if ( c[i] == '>' ) buf.append("&gt;");
			else if ( c[i] == '"' ) buf.append("&quot;");
			else if ( c[i] == '\'') buf.append("&#039;");
			else buf.append(c[i]);
		}
		return buf.toString();
	}
%>
<HTML>
<HEAD>
<TITLE>우리은행 IT전자입찰시스템</TITLE>
<META HTTP-EQUIV="imagetooolbar" CONTENT="no">
<script language="JavaScript" src="/js/flash.js"></script>
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery-1.10.2.min.js"></script>
<link rel="stylesheet" href="/css/woori.css" type="text/css">
<script type="text/javascript">

function QuickLink(selObj,restore){ //v3.0
  window.open(selObj.options[selObj.selectedIndex].value)
  if (restore) selObj.selectedIndex=0;
}

function goTo(popup){
	if (popup.options[popup.selectedIndex].value != "")
	{
	window.open(popup.options[popup.selectedIndex].value, '_blank');
	popup.selectedIndex=0;
	}
}


function open_pop(a,b,c,d)
{
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}



function getLanguage() {
    var language = navigator.systemLanguage;
    // NON IE
    if(!language) {
        language = navigator.language;
    }
    language = language.toUpperCase().substring(0, 2);

    // 테스트용
    if(language == 'EN') {
        language = "KO";
    }
    return language;
}

function loginFailed() {
	$('#form0').attr('action', 'javascript:goLogin()');
	alert("Login failed.");
}

function CheckCookie(name, value) {
	var value1 = GetCookie(name);
	if(value1 != value) {
		var exp = new Date();
		exp.setMonth(exp.getMonth() + 1);
		SetCookie(name, value, exp, "/", "", false);
	}
}

// Cookie Setting
function SetCookie(name, value, expires, path, domain, secure)
{
	document.cookie = name + "="
					+ escape(value)
					+ ((expires) ? "; expires=" + expires.toGMTString() : "")
					+ ((path) ? "; path=" + path : "")
					+ ((domain) ? "; domain=" + domain : "")
					+ ((secure) ? "; secure" : "");
}

// Cookie값 얻기.
function GetCookie(name)
{
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while(i < clen)
	{
		var j = i + alen;
		if(document.cookie.substring(i, j) == arg)
		{
			var end = document.cookie.indexOf(";", j);
			if(end == -1) end = document.cookie.length;
			return unescape(document.cookie.substring(j, end));
		}
		i = document.cookie.indexOf(" ", i) + 1;
		if(i == 0) break;
	}
	return "";
}

function view_bulletin(seq)
{
	var url = "admin/bulletin_list_popup_new.jsp?lang=<%=browser_language%>&seq=" + seq + "&initflag=true";
    var width = 700;
    var height = 500;
//    var left = 0;
//       var top = 0;
	dim = ToCenter(height, width);
	var top = dim[0];
	var left = dim[1];
    var windowW = width;
    var windowH = height;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var library = window.open( url, 'Bulletin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}


function view_faq(seq)
{
	var url = "admin/faq_list_popup_new.jsp?lang=<%=browser_language%>&seq=" + seq + "&initflag=true";
    var width = 700;
    var height = 500;
//    var left = 0;
//       var top = 0;
	dim = ToCenter(height, width);
	var top = dim[0];
	var left = dim[1];
    var windowW = width;
    var windowH = height;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'yes';
    var library = window.open( url, 'Bulletin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
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

//전자입찰
function os_select(event)
{
	 var width = 320;
     var height = 200;
//   var dim = new Array(2);

//   dim = ToCenter(height,width);
//   var top = dim[0];
//   var left = dim[1];
//   style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px"
 	
 	 var top = event.clientY;
     var left = event.clientX;
     
     document.getElementById("divOS").style.width = width+"px";
     document.getElementById("divOS").style.height = height+"px";
     document.getElementById("divOS").style.top = top+"px";
     document.getElementById("divOS").style.left = left+"px";
     document.getElementById("divOS").style.visibility = "visible";
     
//	MM_openBrWindow("common/idpwd.jsp", "login_idpwd", "440", "380");
	
}

function os_un_select()
{
	signform.rdoWin7.checked = false;
	signform.rdoWin10.checked = false;
	
	document.getElementById('divOS').style.visibility = 'hidden';
}

function open_idpwd()
{
	if (!signform.rdoWin7.checked && !signform.rdoWin10.checked)
	{
		alert("OS(운영체재)를 선택하세요.");
		return;
	}
	
	if(signform.rdoWin7.checked){
	    MM_openBrWindow("common/idpwd_ict.jsp", "login_idpwd", "440", "380");
	}else{
		MM_openBrWindow("common/idpwd_ict2.jsp", "login_idpwd", "440", "380");	
	}
	
	document.getElementById('divOS').style.visibility = 'hidden';
}

function open_idpwd2()
{
	MM_openBrWindow("common/idpwd_ict2.jsp", "login_idpwd", "440", "380");
	//MM_openBrWindow("common/idpwd_local.jsp", "login_idpwd", "700", "400");
	//popUpOpen('common/idpwd.jsp', 'login_idpwd','width=550,height=250,resizable=no, status=yes, scrollbars=no');
}

//전자구매
function open_certificate()
{
	//공인인증서 오픈
	alert("공인인증서 오픈");
}

<%-- 
function open_bulletin()
{
	MM_openBrWindow("admin/bulletin_list_new_1.jsp?type=A,I&lang=<%=browser_language%>", "Bulletin_List", "700", "500");
}

function open_faq()
{
	MM_openBrWindow("admin/faq_list_new_1.jsp?type=A,I&lang=<%=browser_language%>", "Bulletin_List", "700", "500");
}
 --%>

function open_business_pic()
{
	MM_openBrWindow("business_pic.jsp?lang=<%=browser_language%>", "business_pic", "450", "300");
}

function open_system_pic()
{
	MM_openBrWindow("system_pic.jsp?lang=<%=browser_language%>", "system_pic", "450", "300");
}

function find_id()
{
	//MM_openBrWindow("admin/find_and_confirm.jsp?lang=<%=browser_language%>", "system_pic", "600", "350");
	MM_openBrWindow("/kr/master/user/find_id.jsp?lang=<%=browser_language%>&user_gb=ICT", "system_pic", "550", "580");
}


function show_news(div_val, idx, type_val){
	var div_news_obj = document.getElementById("div_" + div_val);
	var img_news_obj = document.getElementById("img_" + div_val);
	document.signform.type_val.value = type_val;
	
	for(var i=1; i<3; i++)
	{
		if(i != idx){
			document.getElementById("div_news_" + i).style.display = "none";
			document.getElementById("img_news_" + i).src = "images/pr/news_tit" + i + "_s.gif";
		}
	}
	
	div_news_obj.style.display = "inline";
	img_news_obj.src = "images/pr/news_tit" + idx + "_u.gif";
}

function goList(theURL, param) { //v2.0
	var type_val = document.signform.type_val.value;
	if(type_val == '') type_val = 2;
	
	if(param){
		parent.location.href = theURL;
	}else{
		parent.location.href = theURL + '?news_type=' + type_val;
	}
}

function goRegister()
{
	//화면 가운데로 배치
      var width = 990;
      var height = 700;
      var dim = new Array(2);

      dim = ToCenter(height,width);
      var top = dim[0];
      var left = dim[1];
      var features = "left="+left+",top="+top+",width="+width+",height="+height+", resizable=no, status=yes, scrollbars=yes";

      
      
      
//	      window.open('srm/seller_deal_irsno_check.jsp',"noname",features);
      window.open('/s_kr/admin/info/confirm_ict.jsp',"noname",features);
	//popUpOpen('../srm/seller_deal_irsno_check_before.jsp', 'deal_with', '800', '400');
//		popUpOpen('../srm/seller_deal_irsno_check.jsp', 'deal_with','width=990,height=800,resizable=no, status=yes, scrollbars=no');
}

function goFAQ()
{
	document.location.href = "portal/jsp/common/FAQ/list.jsp";
}

function goOrg()
{
	document.location.href = "procurement/jsp/common/purchase_organization/org2.jsp";
}

function goMenu(no)
{
	if( no == "1" ) 
		popUpOpen('menu/REGISTER.pdf', 'menu1_with', '800', '700');
	else if(no == "2" )
		popUpOpen('menu/USE.pdf', 'menu4_with', '800', '700');
	else if(no == "3" )
		popUpOpen('menu/PURCHASE.pdf', 'menu4_with', '800', '700');
	else if(no == "4" )
		popUpOpen('menu/FAQ.pdf', 'menu4_with', '800', '700');
	//else if(no == "5" )
		//popUpOpen('http://www.tradesign.net/certification/new/poongsanRegPay.jsp', 'menu4_with', '800', '700');
	
}
function check_cookie(){
	try{
	if(document.forms[0].cookie_set.checked == true){
		CheckCookie("user_id", document.forms[0].user_id.value);
	}
	}catch(e){
		alert(e.message);
	}
}

function enter_event(str){
	if(event.keyCode == 13){
		if(str == "id"){
			document.forms[0].password.focus();
		}else if(str =="pass"){
			goLogin();
		}
	}
}
function cookie_Cehck(){
	document.forms[0].user_id.focus();
	if(GetCookie("cookie_set") == "true"){
		document.getElementById("is_save_img").src = "images/intro/ico5_2.gif";
		document.getElementById("cookie_set").checked = true;
		document.getElementById("user_id").value = GetCookie("user_id");
	}
}
function imgChange(obj){
	if(obj.src.split("/")[obj.src.split("/").length-1].indexOf("1") != -1){
		obj.src = "images/intro/ico5_2.gif";
		document.getElementById("cookie_set").checked = true;
		CheckCookie("cookie_set",true);
	}else{
		obj.src = "images/intro/ico5_1.gif";
		document.getElementById("cookie_set").checked = false;
		CheckCookie("cookie_set",false);
	}
}

function fncLoginFail(){
	<%if("login_fail".equals(prev_url)){%>
	alert("사용자의 ID 혹은 비밀번호 입력이 잘못되었습니다.");
		window.location.href = "/";
	<%}%>
	
}	


function fnNoticePop(){
	dim = ToCenter('600','250');
	var top = dim[0];
	var left = dim[1];
	winobj = window.open("/common/index_buyer_notice_pop.jsp","Notice","top="+top+",left="+left+",width=600,height=250,resizable=yes,status=yes,scrollbars = yes");
}
 
function fnFaqList(){
	dim = ToCenter('600','250');
	var top = dim[0];
	var left = dim[1];
	winobj = window.open("/common/index_buyer_faq_pop.jsp","FAQ","top="+top+",left="+left+",width=600,height=250,resizable=yes,status=yes,scrollbars = yes");
}


function gongi_popup() {
	
	//var notice04 = getCookie("notice01");
	var notice04 = "yes";
 	
	var url04 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_04.htm";
	
	if(notice04 != "no") {
 		window.open(url04, "", "top=2, left=2, width=520, height=500, resizable=no, scrollbars=no, status=no;");
 	}
}

function open_popup(edagGuidYn)
{
	if(edagGuidYn == 'N'){
		retrun;
	}
	var noticeit99 = getCookie("noticeit99");
	
	if(noticeit99 != "no") {
		var width = 910;
	    var height = 750;
	    var dim = new Array(2);

	    dim = ToCenter(height,width);
	    var top = dim[0];
	    var left = dim[1];
	 
	 	document.getElementById("divPopup").style.width = width+"px";
	    document.getElementById("divPopup").style.height = height+"px";
	    document.getElementById("divPopup").style.top = top+"px";
	    document.getElementById("divPopup").style.left = left+"px";
	    //document.getElementById("divPopup").style.top = "0px";
	    //document.getElementById("divPopup").style.left = "0px";
	    document.getElementById("divPopup").style.visibility = "visible";	
 	}	
}

function close_popup(flag)
{	
	if( typeof(flag) != "undefined" && document.signform.chkClose.checked ) {
		setCookie2("noticeit99", "no", 1);
	}
	document.getElementById('divPopup').style.visibility = 'hidden';
}

function setCookie2(name, value, expiredays) {
	var today = new Date();
	today.setDate( today.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + today.toGMTString() + ";";
}

</script>


<META HTTP-EQUIV="imagetooolbar" CONTENT="no">

</HEAD>

<BODY topmargin="40" leftmargin="0"  onload="javascript:open_popup('<%=edagGuidYn%>');">
<!--//전자서명 start -->
<form name='xecure'><input type=hidden name='p'></form>
<!-- script language='javascript' src='/XecureObject/xecureweb.js'></script -->
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
	var frm = document.signform;
	var signedMsg = frm.signed_msg;
	frm.rdoWin10.checked = true;
	signedMsg.value = Sign_with_option(0, frm.plain.value);
	
	if(signedMsg.value != ""){
		XecureSubmit(frm);
	}
	else{
		//fail
		alert("사용자 인증에 실패하였습니다.");
	}
}

</script>
<!--//전자서명 end -->



<form name="signform" method=post action='/common/sign_result.jsp' onSubmit='return XecureSubmit(this);'>
<center>
<textarea style="display:none" cols=120 rows=1 name='plain' id="plain">epro.wooriepro.com</textarea>
<textarea style="display:none" cols=120 rows=1 name='signed_msg' id="signed_msg"></textarea>
<input type="hidden" name='mode' id="modde" />
<input type="hidden" name='browser_language' id="browser_language" />

  <table width="1025" style="height:750px;" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="90" colspan="3" align="left" valign="bottom"><img src="/images/intro/logo_ict.gif" width="183" height="45"></td>
    </tr>
    <tr>
      <td width="258" rowspan="2" valign="top"><table width="258" height="500" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td height="193" valign="top"><table width="258" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td colspan="2" style="height:81px"></td>
            </tr>
            <tr>
              <td colspan="2" style="height:27px"><img src="/images/intro/title_login.gif" width="258" height="27"></td>
            </tr>
            <tr>
              <td colspan="2" style="height:15px"></td>
            </tr>
            <tr>
              <td align="left" valign="top" style="height:95px" colspan="2">
              		<%-- img src="/images/intro/btn_login_bidding_ict.jpg" height="79" border="0" onclick="javascript:os_select(event);" --%>
              		<img src="/images/intro/btn_login_bidding_ict.jpg" height="79" border="0" onclick="javascript:MM_openBrWindow('common/idpwd_ict2.jsp', 'login_idpwd', '540', '400');">              	
              </td>
            </tr>
            <tr>
              <td colspan="2" align="left" valign="top" style="height:5px"><img src="/images/intro/div_login.gif" width="259" height="5"></td>
              </tr>
            <tr>
              <td colspan="2" style="background:#ececec; height:1px"></td>
            </tr>
            <tr>
              <td width="129" valign="bottom" style="height:40px;"><a href="javascript:goRegister();"><img src="/images/intro/btn_regist.gif" width="122" height="30" border="0"></a></td>
              <td width="129" align="right" valign="bottom" style="height:40px;"><a href="javascript:find_id();"><img src="/images/intro/btn_find.gif" width="122" height="30"  border="0"></a></td>
            </tr>
          </table></td>
        </tr>
        <tr>
          <td height="74" valign="bottom" style="padding:0 0 7px 2px"><img src="/images/intro/title_quick.gif" width="82" height="14"></td>
        </tr>
        <tr>
          <td valign="top"><table width="258" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td height="84" align="left" valign="top" colspan="2"> 
              	<a href="javascript:goRegister();">
              		<img src="/images/intro/banner1.gif" width="126" height="77"  border="0">
              	</a>
              </td>
            </tr>
            <tr>
              <td height="84" align="left" valign="top"><img src="/images/intro/banner3.gif" width="126" height="77"  border="0"></td>
              <td align="right" valign="top"><img src="/images/intro/banner4.gif" width="126" height="77"></td>
            </tr>
          </table></td>
        </tr>
      </table></td>
      <td colspan="2" valign="top" style="width:767px;height:35px"></td>
    </tr>
    <tr>
      <td height="521" valign="top" style="width:443px;"><img src="/images/intro/visual.jpg" width="442" height="539"></td>
      <%-- <td align="right" style="width:324px; text-align:right; padding:0 0 0 0;" valign="top"><table width="324" border="0" cellspacing="0" cellpadding="0" align="right" >
        <tr>
          <td style="height:46px"></td>
        </tr>
        <tr>
          <td align="right" style="background:url(../images/intro/title_notice.gif) no-repeat; height:27px"><img src="/images/intro/btn_more.gif" width="40" height="9" vspace="2"  border="0" onclick="javascript:fnNoticePop();" style="cursor: pointer;"></td>
        </tr>
        <tr>
          <td style="height:8px"></td>
        </tr>
        <tr>
          <td><table width="324" border="0" cellspacing="0" cellpadding="0">
          		<%for(int i = 0; i < sfCount; i++) { %>              
				<tr>
				     		<td style="height:22px;"><a href="javascript:view_bulletin('<%=sf.getValue("SEQ", i)%>')" class="article"><%=getShortString(sf.getValue("SUBJECT", i), 50) %></a></td>
				</tr>
				<%}%>
          		<%for(int j = sfCount; j < 7; j++) { %>              
				<tr><td style="height:22px;">&nbsp;</td></tr>
				<%}%> 
          </table></td>
        </tr>
        <tr>
          <td style="height:47px"></td>
        </tr>
        <tr>
          <td align="right" style="background:url(../images/intro/title_faq.gif) no-repeat; height:27px"><img src="/images/intro/btn_more.gif" width="40" height="9" vspace="2"  border="0" onclick="javascript:fnFaqList();" style="cursor: pointer;"></td>
        </tr>
        <tr>
          <td style="height:8px"></td>
        </tr>
        <tr>
          <td><table width="324" border="0" cellspacing="0" cellpadding="0">
				<%for(int i = 0; i < sf2.getRowCount(); i++) { %>              
				<tr>
				     		<td style="height:22px;"><a href="javascript:view_faq('<%=sf2.getValue("SEQ", i)%>')" class="article"><%=getShortString(sf2.getValue("SUBJECT", i), 50) %></a></td>
				</tr>
				<%}%> 
				<%for(int j = sfCount2; j < 7; j++) { %>              
				<tr><td style="height:22px;">&nbsp;</td></tr>
				<%}%> 
          </table></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </table>
      </td> --%>
    </tr>
    <tr>
      <td height="34" colspan="3" valign="middle"><img src="/images/intro/footer.gif" width="1025" height="98"></td>
    </tr>
  </table>
</center>

<div id="divOS" style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px">
	<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
		<tr>
			<td colspan="4" width="320px">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="middle">
		    	&nbsp;
			</td>	
			<td colspan="2" align="middle">
				<span style="font-size:18px; font-weight:bold; color:black">OS(운영체재) 구분</span>
			</td>
			<td align="middle">
		    	&nbsp;
			</td>	
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>		
		<tr>
		    <td align="middle">
		    	&nbsp;
			</td>		    			
			<td colspan="2" align="middle">
				<input value="Win7" name="rdoWin" id="rdoWin7" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 7</span>&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="Win10" name="rdoWin" id="rdoWin10" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 10</span>
			</td>
			<td align="middle">
		    	&nbsp;
			</td>	
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>		
		<tr>
			<td align="middle">
		    	&nbsp;
			</td>	
			<td align="right">
				<script language="javascript">btn("javascript:open_idpwd()"		, "선 택")	</script>				
			</td>
			<td align="left">
				<script language="javascript">btn("javascript:os_un_select()"		, "닫 기")	</script>				
			</td>	
			<td align="middle">
		    	&nbsp;
			</td>			
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;<span style="font-size:12px; font-weight:bold; color:red">* OS(운영체재) - Window7 , 브라우저 - IE11</span><br>&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">에 최적화 되었습니다.</span>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>	
	</table>
</div>

<div id="divPopup" style="POSITION:absolute; WIDTH:910px; HEIGHT:750px; VISIBILITY:hidden; Z-INDEX:999999; BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid; ">
	<table style="BACKGROUND-COLOR: #004C99; BORDER-BOTTOM: black thin solid;" width="910px" height="40px">
		<tr>
			<td align="middle" width="875px">
				<span style="font-size:16px; font-weight:bold; color:white">[필독] 팝업차단 해제</span>				
			</td>				
            <td align="right" width="35px">
				<img src="/images/dhtml/sample_close.gif" onclick="javascript:close_popup()">			
			</td>				            	
		</tr>		
	</table>	
	<div style="POSITION:absolute; WIDTH:910px; HEIGHT:710px; OVERFLOW:auto;">
		<table style="BACKGROUND-COLOR: #ffffff;" width="890px">
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;<span style="font-size:18px; color:red">반드시 </span> <span style="font-size:18px; font-weight:bold; color:red">[팝업차단 해제]</span><span style="font-size:18px; color:red"> 후 우리은행 IT전자입찰시스템 이용 바랍니다.</span>								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="right">
					&nbsp;<span style="font-size:12px;">* 브라우저-</span><span style="font-size:12px; font-weight:bold; color:blue">Microsoft Edge(엣지)</span> <span style="font-size:12px;"> , OS(운영체재)-</span><blue><span style="font-size:12px; font-weight:bold; color:blue">Window10</span> <span style="font-size:12px;">최적화</span>								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					<img src="/images/etc/popup_img1.jpg">
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">1. 오른쪽 상단에 점3개 아이콘 클릭</span><br>
					&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">2. 위와 같이 창이 나오면 [설정]을 클릭</span>				
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					<img src="/images/etc/popup_img2.jpg">
				</td>			
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">3. 설정페이지에서 왼쪽매뉴의 [쿠키 및 사이트 권한] 클릭</span><br>							
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					<img src="/images/etc/popup_img3.jpg">
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">4. 오른쪽에 설정할수 있는 화면이 나오면, 하단으로 이동해서 [팝업 및 리디렉션] 클릭</span><br>							
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;								
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					<img src="/images/etc/popup_img4.jpg">
				</td>				
			</tr>
			<tr>
			    <td align="middle">
					&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">5. 차단(권장) 클릭하여 캡쳐와 같이 비활성화 시켜줍니다.</span>							
				</td>				
			</tr>
			<tr>
				<td height="30px"></td>
			</tr>			
			<tr>
				<td align="center">
					 <img src="/images/top/logo.gif"  border="0"  width="100"  height="20">
				</td>
			</tr>	
			<tr>
				<td height="30px"></td>
			</tr>		
			<tr>
				<td align="right">
					<input type="checkbox" name="chkClose" id="chkClose" onclick="javascript:close_popup(1);" value="T" >&nbsp;&nbsp;<span style="font-size:12px; color:red">1일동안 열지 않음</span>&nbsp;			
				</td>				            	
			</tr>
			<tr>
				<td height="30px"></td>
			</tr>							
		</table>
	</div>
</div>

</form>
</BODY>
<!--AOS START  -->
<script type="text/javascript" src="http://ahnlabdownload.nefficient.co.kr/aos/plugin/aosmgr_common.js"></script>
<script type="text/javascript">
//설치완료(업데이트 완료 후)
function on_aosmgr_event( event_name, event_param1, event_param2 ) {
             if( event_name == "update_complete" ) {
                           //window.location.reload();
             }
}
function installAOS() {
    aos_set_authinfo( 'aosmgr_wooribank_com_srm.html' );
    aos_set_option( "aos_event_handler", on_aosmgr_event );
    aos_write_object(); 
    aos_start( 'e5' );          
}
</script> 
<!--AOS END  -->
</HTML>
<%
}catch(Exception e){
	RequestDispatcher dispatcher = request.getRequestDispatcher("/include/error_msg.jsp?err_msg="+e.getMessage());
	dispatcher.forward(request, response);	
	//out.println(e.getMessage());
}
 %>
	