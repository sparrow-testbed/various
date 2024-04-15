<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp" %>

<%
	String user_id       = JSPUtil.paramCheck(info.getSession("ID"));
	String user_name_loc = JSPUtil.paramCheck(info.getSession("NAME_LOC"));
	String user_name_eng = JSPUtil.paramCheck(info.getSession("NAME_ENG"));
	String user_dept     = JSPUtil.paramCheck(info.getSession("DEPARTMENT"));
	String company_code  = JSPUtil.paramCheck(info.getSession("COMPANY_CODE"));
	String house_code    = JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));

	Vector multilang_id = new Vector();
	multilang_id.addElement("MT_004");
	multilang_id.addElement("SIF_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
%>
<%
	String flag = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("flag")));
	String flag_value = "";

	//if(flag.equals("C")) flag_value = "업체생성";
	if(flag.equals("U")) flag_value = String.valueOf(text.get("MT_004.TXT_01"));
	if(flag.equals("D")) flag_value = String.valueOf(text.get("MT_004.TXT_02"));//"업체상세조회";

	String st_vendor_code         = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("st_vendor_code")));
	String st_operating_code      = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("st_operating_code")));
	String text_st_operating_code = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("text_st_operating_code")));
	String ref_flag               = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("ref_flag")));

	String st_company_code     = info.getSession("COMPANY_CODE");
	String ref_st_vendor_code  = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("ref_st_vendor_code")));
	String ref_st_company_code = JSPUtil.nullToEmpty(JSPUtil.CheckInjection(request.getParameter("ref_st_company_code")));
	String choice = JSPUtil.CheckInjection(JSPUtil.nullChk(request.getParameter("choice")));
	
	System.out.println("** flag = " + flag);
	System.out.println("** flag_value = " + flag_value);
	System.out.println("** st_vendor_code = " + st_vendor_code);
	System.out.println("** st_operating_code = " + st_operating_code);
	System.out.println("** text_st_operating_code = " + text_st_operating_code);
	System.out.println("** ref_flag = " + ref_flag);
	System.out.println("** st_company_code = " + st_company_code);
	System.out.println("** ref_st_vendor_code = " + ref_st_vendor_code);
	System.out.println("** ref_st_company_code = " + ref_st_company_code);
	System.out.println("** choice = " + choice);
%>

<html>
<head><title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<style type="text/css">
.tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold;}
.tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
.tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
.tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
.tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
.tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
.tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}
</style>
<%@ include file="/include/include_css.jsp"%>
<style>
.navy { font-size: 12px; color:#ffffff; padding-left : 3; font-weight: bold; padding-right: 3px; background-color: #9AC4D4; border-style: none }
</style>

<script language=javascript src="../js/sec.js"></script>
<script language="javascript" src="../js/ajaxlib/jslb_ajax.js" charset="utf-8"></script>

<script language="JavaScript" type="text/javascript">

var G_HOUSE_CODE  = "<%=house_code%>";
var G_FLAG        = "<%=flag%>";
var G_VENDOR_CODE = "<%=st_vendor_code%>";
var G_ACCESS_URL  = ""; //이동하는 페이지

function MM_preloadImages()
{
 	var d=document;
	if(d.images)
  	{
		if(!d.MM_p)
			d.MM_p=new Array();

		var i,j=d.MM_p.length,
		a=MM_preloadImages.arguments;

		for(i=0; i<a.length; i++)
		{
			if (a[i].indexOf("#")!=0)
			{
				d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];
	    	}
    	}
	}
}

function MM_reloadPage(init) {
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);


function MM_findObj(n, d) {
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_showHideLayers() {
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}


function goSubmit()
{
	MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
	var objForm = document.forms[0];
	objForm.st_vendor_code.value = objForm.st_vendor_code.value.toUpperCase();

	var st_vendor_code  = objForm.st_vendor_code.value;
	var st_company_code = objForm.st_company_code.value;


	if(st_vendor_code.length < 1)
	{
		alert("<%=text.get("MT_004.MSG_0100")%>");//alert("업체코드를 입력해주십시요.");
		objForm.st_vendor_code.focus();
		return;
	}

	if ( G_FLAG == "C" )
	{//ven_bd_ins2.jsp
		downframe = "seller_mgt.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>";
	}
	else if ( G_FLAG == "U" )
	{
		downframe = "seller_mgt.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>"+"&sign_status=C";
	}
	else
	{
		downframe = "seller_mgt_detail.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>";
	}
	objForm.method="post";
	objForm.target="down"
	objForm.action = downframe;
	objForm.title.value = "<%=text.get("MT_004.TXT_BUTTON1")%>";//일반정보
	objForm.submit();
}


function PopupManager(objForm, name)
{
	if(name =="vendor_code")
	{
		window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}

function SP0054_getCode(code, text1, text2) {
	document.forms[0].st_vendor_code.value = code;
	document.forms[0].text_st_vendor_code.value = text1;

}

function goPage(access_flag)
{

	var f = document.forms[0];

	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

	if(access_flag == 'pu' || access_flag == 'fr' || access_flag == 'cp')
	{
		if(st_company_code.length <1)
		{
			//alert("회사코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0102")%>");
			return;
		}
	}

	var title = "<%=text.get("MT_004.TXT_BUTTON1")%>";//일반정보
	var url_detail   = "seller_mgt_detail.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
	var url_iu       = "seller_mgt.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U&registered_gl="+registered_gl;


	if (access_flag	== 'cp')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON2")%>";//담당자정보
		url_detail   = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}
	else if (access_flag	== 'bk')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON3")%>";//은행정보
		url_detail   = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}

	G_ACCESS_URL = url_detail;

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}

		G_ACCESS_URL = url_iu;
	}

	if(access_flag == 'gl'){
		document.forms[0].title.value = title;
		movePage();
		return;
	}

	if (G_FLAG != "D"){
		checkingData(access_flag, f);
	}
	else{
		movePage();
	}

	document.forms[0].title.value = title;
}

function checkingData(access_flag, f)
{

	var url = "&nickName=MT_004&conType=CONNECTION&methodName=existVendorInfo";
	url = url + "&AjaxArgs="+f.st_vendor_code.value;
	url = url + "&AjaxArgs="+f.st_company_code.value;
	url = url + "&AjaxArgs="+access_flag;
	url = url + "&AjaxArgsArr=null";
	sendRequest(checkedData,url,'POST','<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.util.SepoaAjax',true,true);
}

function checkedData(oj)
{
	var xmlDoc = oj.responseXML;
	var status_nodes  = xmlDoc.getElementsByTagName("status");
	var message_nodes = xmlDoc.getElementsByTagName("message");
	var result_nodes  = xmlDoc.getElementsByTagName("result");

	var status  = status_nodes[0].firstChild.nodeValue;
	var message = message_nodes[0].firstChild.nodeValue;
	var result  = result_nodes[0].firstChild.nodeValue;

	if(status!="1")
	{
		alert(G_ERROR_MESSAGE);
		return;
	}

	if(result != "Y")
	{
		alert(message);
		return;
	}

	movePage();
}

function movePage()
{
	var objForm = document.forms[0];
	objForm.method="post";
	objForm.target="down"
	objForm.action = G_ACCESS_URL;
	objForm.submit();
}

function change_seller_code()
{
	popUpOpen("change_seller_code.jsp?before_seller_code=" + LRTrim(document.form1.st_vendor_code.value.toUpperCase()), "change_seller_code", "300", "150");
}

function check_seller_code(access_flag)
{
	var f = document.forms[0];

	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return false;
	}

	if(access_flag == 'pu' || access_flag == 'fr' || access_flag == 'cp')
	{
		if(st_company_code.length <1)
		{
			//alert("회사코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0102")%>");
			return false;
		}
	}

	return true;
}

function init(){
	document.tab_start1.src="../images/button/tab_start_1.gif";
	document.tab1_right.src="../images/button/tab_div_right_1.gif";
	document.tab2_right.src="../images/button/tab_div.gif";
	document.tab3_right.src="../images/button/tab_div.gif";
	document.tab4_right.src="../images/button/tab_div.gif";
	document.tab5_right.src="../images/button/tab_div.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";
	//document.form.btn_flg.value = 1;
}

function tab1(){
	document.tab_start1.src="../images/button/tab_start_1.gif";
	document.tab1_right.src="../images/button/tab_div_right_1.gif";
	document.tab2_right.src="../images/button/tab_div.gif";
	document.tab3_right.src="../images/button/tab_div.gif";
	document.tab4_right.src="../images/button/tab_div.gif";
	document.tab5_right.src="../images/button/tab_div.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";

	var f = document.forms[0];
	
	<%-- 일반정보 --%>
	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	var url_detail   = "seller_mgt_detail.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
	var url_iu       = "seller_mgt.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U&registered_gl="+registered_gl;

	G_ACCESS_URL = url_detail;

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}

		G_ACCESS_URL = url_iu;
	}

	if(! check_seller_code('gl')) return;
	movePage();
}

function tab2(){
	document.tab_start1.src="../images/button/tab_start.gif";
	document.tab1_right.src="../images/button/tab_div_left_1.gif";
	document.tab2_right.src="../images/button/tab_div_right_1.gif";
	document.tab3_right.src="../images/button/tab_div.gif";
	document.tab4_right.src="../images/button/tab_div.gif";
	document.tab5_right.src="../images/button/tab_div.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";

	var f = document.forms[0];
	
	<%-- 담당자정보 --%>
	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

	if(st_company_code.length <1)
	{
		//alert("회사코드를 입력해주십시요.");
		alert("<%=text.get("MT_004.MSG_0102")%>");
		return;
	}

	//G_ACCESS_URL = "../master/seller_pic_mgt_seller.jsp?vendor_code=" + st_vendor_code;
	G_ACCESS_URL  = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}
	}

	movePage();
}

function tab3(){
	document.tab_start1.src="../images/button/tab_start.gif";
	document.tab1_right.src="../images/button/tab_div.gif";
	document.tab2_right.src="../images/button/tab_div_left_1.gif";
	document.tab3_right.src="../images/button/tab_div_right_1.gif";
	document.tab4_right.src="../images/button/tab_div.gif";
	document.tab5_right.src="../images/button/tab_div.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";

	var f = document.forms[0];

	<%-- 재무현황 --%>
	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

<%--
	if(access_flag == 'pu' || access_flag == 'fr' || access_flag == 'cp')
	{
		if(st_company_code.length <1)
		{
			//alert("회사코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0102")%>");
			return;
		}
	}

	if (access_flag	== 'cp')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON2")%>";//담당자정보
		url_detail   = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}
	else if (access_flag	== 'bk')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON3")%>";//은행정보
		url_detail   = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}
--%>
	G_ACCESS_URL = "../master/seller_financial_mgt.jsp?vendor_code=" + st_vendor_code;

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}
	}

	movePage();
}

function tab4(){
	<%-- 신용평가 --%>
	document.tab_start1.src="../images/button/tab_start.gif";
	document.tab1_right.src="../images/button/tab_div.gif";
	document.tab2_right.src="../images/button/tab_div.gif";
	document.tab3_right.src="../images/button/tab_div_left_1.gif";
	document.tab4_right.src="../images/button/tab_div_right_1.gif";
	document.tab5_right.src="../images/button/tab_div.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";
}

function tab5(){
	document.tab_start1.src="../images/button/tab_start.gif";
	document.tab1_right.src="../images/button/tab_div.gif";
	document.tab2_right.src="../images/button/tab_div.gif";
	document.tab3_right.src="../images/button/tab_div.gif";
	document.tab4_right.src="../images/button/tab_div_left_1.gif";
	document.tab5_right.src="../images/button/tab_div_right_1.gif";
	document.tab_end_right.src="../images/button/tab_end_right.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}";
	
	var f = document.forms[0];
	
	<%-- 회사규모/인원현황 --%>
	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

	if(st_company_code.length <1)
	{
		//alert("회사코드를 입력해주십시요.");
		alert("<%=text.get("MT_004.MSG_0102")%>");
		return;
	}

	//G_ACCESS_URL = "../master/seller_pic_mgt_seller.jsp?vendor_code=" + st_vendor_code;
	G_ACCESS_URL  = "seller_person_mgt.jsp?vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}
	}

	movePage();
}

function tab_end(){
	document.tab_start1.src="../images/button/tab_start.gif";
	document.tab1_right.src="../images/button/tab_div.gif";
	document.tab2_right.src="../images/button/tab_div.gif";
	document.tab3_right.src="../images/button/tab_div.gif";
	document.tab4_right.src="../images/button/tab_div.gif";
	document.tab5_right.src="../images/button/tab_div_left_1.gif";
	document.tab_end_right.src="../images/button/tab_end_right_1.gif";
	document.styleSheets[1].cssText=".tab{color: #ffffff; font-size: 12px; text-decoration: none; font-family: arial, 굴림; font-weight:bold}"
								  + ".tab1{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab2{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab3{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab4{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab5{background-image: url(../images/button/bg_tab_mid.gif); color: #ffffff}"
								  + ".tab_end{background-image: url(../images/button/bg_tab_mid_1.gif); color: #333366}";

	var f = document.forms[0];
	
	<%-- 설비정보 --%>
	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

<%--
	if(access_flag == 'pu' || access_flag == 'fr' || access_flag == 'cp')
	{
		if(st_company_code.length <1)
		{
			//alert("회사코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0102")%>");
			return;
		}
	}

	if (access_flag	== 'cp')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON2")%>";//담당자정보
		url_detail   = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_chargeinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}
	else if (access_flag	== 'bk')
	{
		title = "<%=text.get("MT_004.TXT_BUTTON3")%>";//은행정보
		url_detail   = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&flag=D";
		url_iu       = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";
	}
--%>

	G_ACCESS_URL = "../master/seller_equipment_mgt.jsp?vendor_code=" + st_vendor_code;

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}
	}

	movePage();
}

function tab7(){
	<%-- 은행정보 --%>
	

	var f = document.forms[0];

	f.st_vendor_code.value = f.st_vendor_code.value.toUpperCase();
	var st_vendor_code     = f.st_vendor_code.value
	var st_company_code    = f.st_company_code.value;
	var ref_flag           = "<%=ref_flag%>";
	var ref_st_vendor_code = "<%=ref_st_vendor_code%>";
	var ref_st_company_code = "<%=ref_st_company_code%>";
	var flag               = "U";
	var registered_gl      = parent.prt.reg.registered_gl.value;
	var registered_pu      = parent.prt.reg.registered_pu.value;

	if(st_vendor_code.length == 0 )
	{
		//alert("일반정보를 입력하셔야 다음 단계로 이동 가능합니다.");
		alert("<%=text.get("MT_004.MSG_0101")%>");

		f.st_vendor_code.focus();
		return;
	}

	G_ACCESS_URL  = "seller_bankinfo.jsp?st_vendor_code="+st_vendor_code+"&st_company_code="+st_company_code+"&ref_flag="+ref_flag+"&ref_st_vendor_code="+ref_st_vendor_code+"&ref_st_company_code="+ref_st_company_code+"&flag=U";

	if(G_FLAG != "D")
	{
		if(st_vendor_code.length < 1){
			//alert("업체코드를 입력해주십시요.");
			alert("<%=text.get("MT_004.MSG_0103")%>");
			f.st_vendor_code.focus();
			return;
		}
	}

	movePage();
}

function downUrl(url){
	goCreate(url, '1');
}
</script>

</head>

<body leftmargin="15" topmargin="6" onload="javascript:init();">
<form name="form1" method="post" action="">
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
		        <td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("MT_004.TXT_01")%></td>
        		<td width="30%" height="24" class="se_cell_data">
        			<input type="text" name="st_vendor_code" value="<%=st_vendor_code%>" size="10" onKeyUp="javascript:this.value=this.value.toUpperCase();" class="input_re" maxlength="10">
        			<a href="javascript:PopupManager(document.forms[0],'vendor_code')"><img src="../images/button/query.gif" align="absmiddle" border="0" alt=""></a>
					<input type="text" name="text_st_vendor_code" size="20" class="input_empty" readonly>
				</td>
        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("MT_004.TXT_02")%></td>
        		<td width="35%" height="24" class="se_cell_data">
					<select name="st_company_code" class="inputsubmit">
					<%
						 String st_company_code_list = ListBox(request, "SL0006" ,"#", st_company_code);
						 out.println(st_company_code_list);
		 			%>
					</select>
				</td>
			  </tr>
			</table>
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			  <TR>
				<td style="padding:5 5 5 0" align="right">
				  <TABLE cellpadding="2" cellspacing="0">
				    <TR>
					  <TD><script language="javascript">btn("javascript:goSubmit()" , "<%=text.get("BUTTON.search")%>")</script></TD>
							<!--  <TD><script language="javascript">btn("javascript:change_seller_code()" , "<%=text.get("MT_004.button_change_code")%>")</script></TD> -->
					</TR>
				  </TABLE>
				</td>
			  </TR>
			</TABLE>
		</td>
	  </tr>
	  <tr><td>
		<table border="0" cellspacing="0" cellpadding="0">
        	<tr>
        	<td>&nbsp;&nbsp;</td>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab1();" style="cursor:hand">
			<%-- 일반정보 --%>
			<tr class="tab">
				<td width="7"><img src="../images/button/tab_start.gif" width="7" height="21" border=0 name="tab_start1"></td>
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2" id="tab1_mn" class="tab1"><%=text.get("SIF_012.0001")%></td>
				<td><IMG SRC="../images/button/tab_div.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab1_right"></td>
			</tr>
			</table>
			</td>
			<%-- 담당자정보 --%>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab2();" style="cursor:hand">
			<tr class="tab">
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2"  id="tab2_mn" class="tab2"><%=text.get("SIF_012.0002")%></td>
				<td><IMG SRC="../images/button/tab_div.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab2_right"></td>
			</tr>
			</table>
			</td>
			<%-- 재무현황 --%>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab3();" style="cursor:hand">
			<tr class="tab">
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2"  id="tab3_mn" class="tab3"><%=text.get("SIF_012.0005")%></td>
				<td><IMG SRC="../images/button/tab_div.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab3_right"></td>
			</tr>
			</table>
			</td>
			<%-- 신용평가 --%>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab4();" style="cursor:hand">
			<tr class="tab">
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2"  id="tab4_mn" class="tab4"><%=text.get("SIF_012.0011")%></td>
				<td><IMG SRC="../images/button/tab_div.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab4_right"></td>
			</tr>
			</table>
			</td>
			<%-- 회사규모/인원현황 --%>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab5();" style="cursor:hand">
			<tr class="tab">
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2"  id="tab5_mn" class="tab5"><%=text.get("SIF_012.0012")%></td>
				<td><IMG SRC="../images/button/tab_div.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab5_right"></td>
			</tr>
			</table>
			</td>
			<%-- 품질인증/설비현황 --%>
			<td>
			<table cellpadding="0" cellspacing="0" border="0" height="21" onClick="tab_end();" style="cursor:hand">
			<tr class="tab">
				<td background="../images/button/bg_tab_mid.gif" align="center" valign="bottom" style="padding-left:10;padding-right:10;padding-bottom:2"  id="tab_end_mn" class="tab_end"><%=text.get("SIF_012.0013")%></td>
				<td><IMG SRC="../images/button/tab_end_right.gif" WIDTH="20" HEIGHT="21" BORDER=0 name="tab_end_right"></td>
			</tr>
			</table>
			</td>
	   		</tr>
		</table>
	  </td></tr>
	  <tr>
		<td bgcolor="#CCCCCC" height="3"></td>
	  </tr>

	</table>
</form>
</body>
</html>
