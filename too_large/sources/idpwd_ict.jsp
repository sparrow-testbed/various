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

<% session.setAttribute("popup_name", "신규업체등록"); %>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
	if(session.getAttribute("MENU_TOP") != null){
		SepoaSession.putValue(request, "MENU_TOP", null);
	}

	
	String request_server_name = SepoaString.replace(request.getServerName(), ".", "");
	String prev_url = request.getParameter("prev_url");
	String fail_msg = request.getParameter("fail_msg"); 		

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

    
    /*
     예외처리될 IP를 SCODE에서 가지고온다. 
	Object[] obj1 = {};
    SepoaOut value1 = ServiceConnector.doService(info, "CO_004", "CONNECTION", "getIPaddr", obj1);
    SepoaFormater sf1 = new SepoaFormater(value1.result[0]);*/
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
<html>
<head>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/lib/jquery-1.10.2.min.js"></script>
<%-- 키보드보안 스크립트 호출 </body>윗단에서 호출 필수!!!! --%>
<script type="text/javascript" src="/TouchEnKey/js/TouchEnKey.js"></script>
<%-- 키보드보안 스크립트 호출 끝 --%>
<script  type="text/javascript">
$(document).ready(function(){
	
	var fail_msg = "<%=fail_msg%>";
	fail_msg = fail_msg.replace(/rn/g,"\r\n");
	<%if("login_fail".equals(prev_url)){%>
		//로그인 에러
		<%if(!"".equals(fail_msg)){%>
		alert(fail_msg);
		<%}else{%>
		alert("사용자의 ID 혹은 비밀번호 입력이 잘못되었습니다.");
		<%}%>
			
		window.location.href = "/common/idpwd_ict.jsp";
			
	<%	} %>

});



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

	function goLogin() {
		    
// 	    $('#language').attr('value', getLanguage());
	    $('#language').attr('value', "KO");

	    var frm = document.getElementById("form1");
	     
		var user_id = LRTrim(document.form1.user_id.value);
		var password = LRTrim(document.form1.password.value);
		
		if(user_id == "")
		{
			alert("사용자 ID 를 입력하세요.");//사용자 ID 를 입력하세요.
			document.form1.user_id.focus();
			return;
		}
		
		if(password == "")
		{
			alert("패스워드를 입력 하세요.");//패스워드를 입력 하시오.
			document.form1.password.focus();
			return;
		}
		
		// Query에 사용되는 특수문자(') 에러 방지를 위하여
		var sTmpPass = document.form1.password.value;
		sTmpPass     = sTmpPass.replace("'","");
		document.form1.password.value = sTmpPass;

		CheckCookie("user_id", document.form1.user_id.value);
	     
		if(makeEncData(frm)){ // 키보드보안 암호화 함수
			var params = "&user_id=" + $('#id').val() + "&password=" + $('#password').val();
		
		     frm.mode.value   = "setLogin";
		     frm.FromSite.value = "ICT"
			 frm.browser_language.value = "KO";
			 frm.method = "POST";
             frm.target = "_self";	//"hiddenFrame";
             frm.action = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.co_login_process";
             frm.submit();
			
		} else{
			alert("암호화에 실패하였습니다. 정확한 값을 입력 후 재시도 해주세요.");
		} 
	
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

	function init()
	{
	
		var user_id = GetCookie("user_id");
		var cookie_set = GetCookie("cookie_set");
		alert("cookie_set:"+cookie_set);
		document.form1.user_id.focus();
		if(!isNull(user_id))
		{
			document.form1.user_id.value = user_id;
		}
		document.form1.user_id.value = user_id;
		document.form1.user_id.focus();
		document.form1.user_id.select();
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
		MM_openBrWindow("admin/find_id.jsp?lang=<%=browser_language%>", "system_pic", "450", "250");
	}
	
	function show_news(div_val, idx, type_val){
		var div_news_obj = document.getElementById("div_" + div_val);
		var img_news_obj = document.getElementById("img_" + div_val);
		document.form1.type_val.value = type_val;
		
		for(var i=1; i<3; i++)
		{
			if(i != idx){
				document.getElementById("div_news_" + i).style.display = "none";
				document.getElementById("img_news_" + i).src = "/images/pr/news_tit" + i + "_s.gif";
			}
		}
		
		div_news_obj.style.display = "inline";
		img_news_obj.src = "/images/pr/news_tit" + idx + "_u.gif";
	}
	
	function goList(theURL, param) { //v2.0
		var type_val = document.form1.type_val.value;
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

	      window.open('/s_kr/admin/info/confirm.jsp',"noname",features);
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
		else if(no == "5" )
			popUpOpen('http://www.tradesign.net/certification/new/poongsanRegPay.jsp', 'menu4_with', '800', '700');
		
	}
	function check_cookie(){
		try{
		if(document.forms[0].cookie_set.checked == true){
			CheckCookie("user_id", document.forms[0].user_id.value);
			CheckCookie("cookie_set", document.getElementById("cookie_set").checked);
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
			document.getElementById("cookie_set").checked = true;
			document.getElementById("user_id").value = GetCookie("user_id");
		}
	}
	function imgChange(obj){
		if(document.getElementById("cookie_set").checked){
			CheckCookie("cookie_set",true);
		}else{
			CheckCookie("cookie_set",false);
		}
	}
	function cert_center(){
		MM_openBrWindow("admin/cert_center.jsp?lang=<%=browser_language%>", "cert_center", "250", "200");
	}

	
</script>
<TITLE>우리은행 전자구매시스템</TITLE>
<link rel="SHORTCUT ICON" href="http://<%=request.getServerName() + ":" + request.getServerPort() + request.getContextPath()%>/images/icon/laps.ico">
<META HTTP-EQUIV="imagetooolbar" CONTENT="no">
</head>
<BODY topmargin="10" leftmargin="10" style="text-align:center;"" onload="cookie_Cehck();">
<form name="form1" id="form1">
	<input type="hidden" name="browser_language" id="browser_language"    value=""  />
	<input type="hidden" name="language"         id="language"            value=""  />
	<input type="hidden" name="mode"             id="mode"                value=""  />
	<input type="hidden" name="acc_type"         id="acc_type"            value="ID"  />
	<input type="hidden" name="login_type"       id="login_type"          value=""  />
	<input type="hidden" name="FromSite"         id="FromSite"            value="ICT"  />
	<input type="hidden" name="os_gb"            id="os_gb"               value="win7"  />
	
	<table width="520" border="0" cellspacing="10" cellpadding="0" bgcolor="#0083ca" style="width:420px; height:337px">
		<tr>
			<td bgcolor="#FFFFFF">
				<table width="500" style="height:182px" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="258" align="center" style="height:54px">
							<br />
							<img src="../images/intro/login_title_ict.gif" width="174" height="49" />
						</td>
					</tr>
					<tr>
						<td style="height:15px"></td>
					</tr>
					<tr>
						<td align="center" valign="top" style="height:107px">
							<table width="450" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" style="background:#ececec; height:2px"></td>
								</tr>
								<tr>
									<td height="15" colspan="2">
										<font color="red" style="font-size:9px">
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											* 비밀번호는 대소문자를 구분하여 입력해주십시오.
										</font>
									</td>
								</tr>
								<tr>
									<td width="56" height="40" align="right">
										<img src="../images/intro/txt_id.gif" width="43" height="12" />
									</td>
									<td height="29" align="right">
										<input type="text" name="user_id" id="user_id"  style="width:290px; height:25px" onkeyup="check_cookie();" onkeydown="enter_event('id');" data-enc="on" />
									</td>
								</tr>
								<tr>
									<td height="40" align="right">
										<img src="../images/intro/txt_pw.gif" width="54" height="12" />
									</td>
									<td height="29" align="right">
										<input type="password" name="password" id="password" style="width:290px; height:25px"  onkeydown="enter_event('pass');" data-enc="on" />
									</td>
								</tr>
								<tr>
									<td height="29" align="right">&nbsp;</td>
									<td height="29" align="left">
										<input name="cookie_set" id="cookie_set"  type="checkbox" class="radio" onClick="imgChange();" />
										<img src="../images/intro/txt_saveid.gif" width="69" height="13" valign="absmiddle" />
									</td>
								</tr>
								<%
									//서버에만 적용
									String ip = request.getHeader("HTTP_X_FORWARDED_FOR");
									if(ip == null || ip.length() == 0 || ip.toLowerCase().equals("unknown")) {
										ip = request.getHeader("REMOTE_ADDR");
									}
									
									if(ip == null || ip.length() == 0 || ip.toLowerCase().equals("unknown")) {
										ip = request.getRemoteAddr().replace(".","");
									}
									
									boolean ip_flag = true;

									if(ip_flag && (!ip.equals("0:0:0:0:0:0:0:1")&&!ip.equals("127001"))){
										%>
										
										<tr>
											<td width="187" height="25">
												<input type="hidden" name="cert_number" id="cert_number" style="width:120px; background-color:#f1f1f1" onkeyup="check_cookie();" onkeydown="enter_event('id');">
												<input type="hidden" name="cert_flag" id="cert_flag" value="true"/>
											</td>
											<!-- <td width="60"><img src="../images/intro/btn_cert.gif" width="60" border=0 onclick="cert_center()"></td>  -->
										</tr>
										<%
									}else{
										%>
										<!--  <tr>
										<td height="20" colspan="2" align="center"></td>
										</tr> -->
										<%
									}
								%>
								
								<tr>
									<td height="10" colspan="2"></td>
								</tr>
								<tr>
									<td colspan="2" style="background:#ececec; height:2px"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center" valign="top" style="height:10px">&nbsp;</td>
					</tr>
					<tr>
						<td align="center" valign="top" style="height:30px">
							<img src="../images/intro/btn_login.gif" width="350" height="49" style="cursor:hand;" onclick="goLogin()" />
						</td>
					</tr>
					<tr>
						<td align="center" valign="top" style="height:30px">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<!-- <iframe name="hiddenFrame" src="/common/login_frame.jsp" width="520" height="150" marginwidth="0" marginheight="0" frameborder="1" scrolling="no"></iframe> -->
</BODY>

</HTML>
<%
}catch(Exception e){
	
	out.println(e.getMessage());
}
 %>
	
