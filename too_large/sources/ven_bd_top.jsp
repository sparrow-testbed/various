<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	SepoaInfo info = SepoaSession.getAllValue(request);
	String company_code  = info.getSession("COMPANY_CODE");
	String house_code    = info.getSession("HOUSE_CODE");
	String buyer_house_code = info.getSession("HOUSE_CODE")==null?"100":info.getSession("HOUSE_CODE");
	String os_gb = info.getSession("OS_GB");
%>
<%
	String flag = JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("flag")));
	String flag_value = "";

	if(flag.equals("C")) flag_value = "업체생성";
	if(flag.equals("U")) flag_value = "업체수정";
	if(flag.equals("D")) flag_value = "업체상세조회";
	String mode               	  	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("mode")));
	String irs_no              	  	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("irs_no")));
	String resident_no            	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("resident_no")));
    String vendor_code         		= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("vendor_code")));
    String CompanyCode        		= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("CompanyCode")));
	String st_vendor_code         	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("st_vendor_code")));
	String st_operating_code      	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("st_operating_code")));
	String text_st_operating_code 	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("text_st_operating_code")));
	String ref_flag               	= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("ref_flag")));
	String popup             		= JSPUtil.nullToEmpty(request.getParameter("popup"));

	String st_company_code     		= info.getSession("COMPANY_CODE");
	String ref_st_vendor_code  		= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("ref_st_vendor_code")));
	String ref_st_company_code 		= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("ref_st_company_code")));
	Configuration con = new Configuration();
// 	company_code 	  = CommonUtil.getConfig("sepoa.company.code");
	company_code 	  = CommonUtil.getConfig("sepoa.buyer.company.code");

	String status             		= JSPUtil.nullToEmpty(JSPUtil.CheckInjection3(request.getParameter("status")));
	String tab_flag = "false";

	/*신청중일 경우 영업담당정보가 있으면 탭 이동가능하다.*/
	if (status.equals("T")) {
		SepoaOut value = null;
		/*주민번호 일 경우엔 암호화 한다.*/
// 		EncDec enc = new EncDec();
// 	    String resident_no_p = enc.encrypt(resident_no);
	    String resident_no_p = resident_no;

		String[] data = { house_code, 		"".equals(irs_no) ?  resident_no_p  :  irs_no  };
		Object[] obj = { (Object[]) data, 	"".equals(irs_no) ? "resident_no" : "irs_no" };

		value = ServiceConnector.doService(info, "p0010", "CONNECTION", "getDis_icomvngl_2", obj);

		if (value.status == 1) {
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			int iRowCount = wf.getRowCount();
			if(iRowCount == 0){
				tab_flag = "false";
			}
			else{
				vendor_code = wf.getValue("VENDOR_CODE", 0);
				tab_flag = "true";
			}
		}
	}

	String menu_type = "";
	
	//여기선 관리자인지 일반 사용자인지 구분하기 위해 사용
	String ctrl_code = "";
			
// 	Config conf = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";
	String session_profile_code = info.getSession("MENU_TYPE");
	String readOnly = "";
	try {
		all_admin_profile_code = CommonUtil.getConfig("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = CommonUtil.getConfig("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));
		
		
	} catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}
	if(null == session_profile_code){
		session_profile_code = "P01";
	}else if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {
		ctrl_code = "P01";
	}else if("MUP100300001".equals(session_profile_code)){
		ctrl_code = "P01";
	}else{
		ctrl_code = "P99";	
	}
	
	

%>
<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
</script>
<script language="JavaScript" type="text/javascript">

var G_HOUSE_CODE  = "<%=house_code%>";
var G_FLAG        = "<%=flag%>";
var G_VENDOR_CODE = "<%=st_vendor_code%>";
var G_ACCESS_URL  = ""; //이동하는 페이지
var G_MOVE_FLAG   = true;

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

// 탭 이미지 변경
function MM_showHideLayers() {
	if(G_MOVE_FLAG){
  		var i,p,v,obj,args=MM_showHideLayers.arguments;
  		for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
  		  if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
  		  obj.visibility=v; }
	}
}


function goSubmit()
{
	MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide');
	var objForm = document.forms[0];
	objForm.st_vendor_code.value = objForm.st_vendor_code.value.toUpperCase();

	var st_vendor_code  = objForm.st_vendor_code.value;
	var st_company_code = objForm.st_company_code.value;

	if(st_vendor_code.length < 1)
	{
		alert("업체코드를 입력해주십시요.");
		objForm.st_vendor_code.focus();
		return;
	}

	if ( G_FLAG == "C" )
	{
		downframe = "ven_bd_ins2.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>";
	}
	else if ( G_FLAG == "U" )
	{
		downframe = "ven_bd_ins2.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>"+"&sign_status=C";
	}
	else
	{
		downframe = "ven_bd_dis2.jsp?st_vendor_code="+st_vendor_code+"&st_company_code=<%=st_company_code%>&ref_flag=<%=ref_flag%>&ref_st_vendor_code=<%=ref_st_vendor_code%>&ref_st_company_code=<%=ref_st_company_code%>&flag=<%=flag%>";
	}
	objForm.method="post";
	objForm.target="down"
	objForm.action = downframe;
	objForm.title.value = "일반정보";
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

<%-- 필수정보인 영업담당자 정보를 입력하고 저장하지 않으면 다른 탭으로 이동할 수 없어야한다(기본정보 탭은 예외) --%>
function chkVncp() {
	
	var vendor_code = document.forms[0].vendor_code.value;
	
	if(vendor_code == null || vendor_code == "") {
		vendor_code = "<%=irs_no%>";//처음 등록시 업체코드는 없고 사업자등록번호를 대신 사용하므로 없을 경우 사업자등록번호로 세팅
		document.forms[0].vendor_code.value = vendor_code;
	}
	
	// 필수정보인 영업담당자 정보를 조회
	var nickName    = "s6006";
	var conType     = "CONNECTION";
	var methodName  = "getVncp";
	var SepoaOut    = doServiceAjax( nickName, conType, methodName );
	
  	if( SepoaOut.status == "0" ) { // 실패
  		alert('조회 중 오류가 발생하였습니다.');
  		G_MOVE_FLAG = false;
  		return false;
  	} else {
  		if(SepoaOut.result < 1) {
  			alert('영업담당 정보를 등록하지 않으면\n수주실적/품질인증/소싱정보등록 탭으로 이동할 수 없습니다.');
  			G_MOVE_FLAG = false;
  			return false;
  		} else {
  			G_MOVE_FLAG = true;
		  	return true;
  		}
  	}

}


function goPage(access_flag)
{
	var f 		 = document.forms[0];
	vendor_code  = f.vendor_code.value;
	var flag 	 = f.flag.value;
	var title = "기본정보";
	<% if(popup.equals("Y")){%>
		vendor_code="<%=vendor_code%>";
		company_code="<%=CompanyCode%>";
	<%}%>

	if("<%=vendor_code%>" != ""){
		form1.vendor_code.value = "<%=vendor_code%>";
	}
	
	<% //if("win10".equals(os_gb)){%>
		var url_detail   = "ven_bd_ins2_window10.jsp?vendor_code="+form1.vendor_code.value+"&flag="+flag+"&mode=<%=mode%>&resident_no=<%=resident_no%>&popup=<%=popup%>&irs_no=<%=irs_no%>&company_code=<%=company_code%>";
	<%//}else{%>
//		var url_detail   = "ven_bd_ins2.jsp?vendor_code="+form1.vendor_code.value+"&flag="+flag+"&mode=<%=mode%>&resident_no=<%=resident_no%>&popup=<%=popup%>&irs_no=<%=irs_no%>&company_code=<%=company_code%>";
	<%//}%>
	
	
	if(access_flag != 'gl' && vendor_code == ""){
		if(!<%=tab_flag%>){
			alert("업체정보를 먼저 입력하셔야 이동이 가능합니다.");
			G_MOVE_FLAG = false;
			return;
		}
	}
	
	G_access_flag = "";
	G_MOVE_FLAG = true;
	if (access_flag	== 'cp')
	{
		title = "영업담당";
		url_detail   = "ven_bd_ins6.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	if(access_flag == "pj"){
		if( !chkVncp() ) return;
		title = "수주실적";
		url_detail   = "ven_bd_ins9.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	if(access_flag == "qr"){
		if( !chkVncp() ) return;
		title = "품질인증";
		url_detail   = "ven_bd_ins10.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	if(access_flag == "pl"){
		title = "개발자현황";
		url_detail   = "ven_bd_ins12.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	if(access_flag == "pi"){
		title = "상품정보";
		url_detail   = "ven_bd_ins11.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=pi"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	if(access_flag == "sc"){
		if( !chkVncp() ) return;
// 		title = "업체등록평가";
		title = "소싱정보등록";
		
		url_detail   = "hico_bd_lis10_1.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=sc"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
<%-- 		url_detail   = "hico_bd_lis10.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=sc"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag; --%>
	}
	if(access_flag == "sl"){
		title = "솔루션정보";
		url_detail   = "ven_bd_ins11.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=sl"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}	
// 	if(access_flag == "sg"){
// 		title = "소싱그룹현황";
<%-- 		url_detail   = "ven_bd_ins13.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=sl"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag; --%>
// 	}
	if(access_flag == "fu"){
		title = "재무제표";
		url_detail   = "ven_bd_ins14.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&mode=sl"+"&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&flag="+flag;
	}
	/*
	if(access_flag == "pl"){
		title = "개발자현황";
		url_detail   = "/s_kr/master/human/hum1_bd_lis1.jsp?vendor_code="+form1.vendor_code.value+"&company_code=<%=company_code%>&popup=<%=popup%>&buyer_house_code=<%=buyer_house_code%>&mode="+flag;
	}
	*/
	G_ACCESS_URL = url_detail;
	movePage();
}


function movePage()
{
	var objForm = document.forms[0];
	objForm.method="post";
	objForm.target="down";
	objForm.action = G_ACCESS_URL;
	objForm.submit();
}

//가입신청
function btnReg() {
	
	if(!confirm("신규가입 하시겠습니까?")){
		return;
	}
	
	var vendor_code = document.forms[0].vendor_code.value;
	
	if(vendor_code == null || vendor_code == "") {
		vendor_code = "<%=irs_no%>";//처음 등록시 업체코드는 없고 사업자등록번호를 대신 사용하므로 없을 경우 사업자등록번호로 세팅
		document.forms[0].vendor_code.value = vendor_code;
	}
	
	// 필수정보인 영업담당자 정보를 조회
	var nickName    = "s6006";
	var conType     = "TRANSACTION";
	var methodName  = "updateNewReg";
	var SepoaOut    = doServiceAjax( nickName, conType, methodName );
	
  	if( SepoaOut.status == "0" ) { // 실패
  		alert(SepoaOut.message);
  		G_MOVE_FLAG = false;
  		return false;
  	} else {
  		if(SepoaOut.result < 1) {
  			alert(SepoaOut.message);
  			G_MOVE_FLAG = false;
  			return false;
  		} else {  			
  			alert(SepoaOut.message);
  			G_MOVE_FLAG = true;
  			window.close();
		  	return true;
  		}
  	}
}


</script>

</head>

<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide')">
<%
	if(!mode.equals("new")) {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="20" align="left" class="title_page" vAlign="bottom">
		<%if(!popup.equals("Y")&&!popup.equals("T")&&!popup.equals("U")){%>
			신규업체 등록 신청
		<%}else if(popup.equals("T")){%>
			기본정보 > 회사정보관리 > 회사정보
		<%}else{%>
			업체상세조회
		<%}%>
	</td>
</tr>
</table>
<%
	} else {
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		&nbsp;신규업체 등록
	</td>
</tr>
</table>
<%
	}
%>
<form name="form1" method="post" action="">
<input type="hidden" id="house_code" name="house_code" value="<%=house_code%>">
<input type="hidden" id="vendor_code" name="vendor_code" value="<%=vendor_code%>">
<input type="hidden" name="flag" value="insert">
	<%if(!popup.equals("Y")&&!popup.equals("T")){ //신규업체등록 %>
	<div id="m1" style="position:absolute; left: 24px; top:28px; width:86px; height:28px; z-index:1; visibility: visible"
		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m8','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=10 onClick="javascript:goPage('gl')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m2" style="position:absolute; left:84px; top:28px; width:86px; height:28px; z-index:4; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('cp')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m3" style="position:absolute; left:144px; top:28px; width:86px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('pj')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m4" style="position:absolute; left:204px; top:28px; width:86px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('qr')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m5" style="position:absolute; left:264px; top:28px; width:100px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('sc')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
<!-- 		<td class=tab_txt_off valign=bottom>업체등록평가</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
		<td class=tab_txt_off valign=bottom>소싱정보등록</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
<!-- 	<div id="m8" style="position:absolute; left:370px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m8','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('fu')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>재무제표</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div>	 -->
	<div id="m11" style="position:absolute; left: 20px; top:28px; width:86px; height:28px; z-index:1; visibility: hidden"
		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m8','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m22" style="position:absolute; left:82px; top:28px; width:86px; height:28px; z-index:4; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m33" style="position:absolute; left:142px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m44" style="position:absolute; left:202px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m55" style="position:absolute; left:262px; top:28px; width:100px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
 <!-- 		<td class=tab_txt_on valign=bottom>업체등록평가</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>  -->
		<td class=tab_txt_on valign=bottom>소싱정보등록</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
<!-- 	<div id="m88" style="position:absolute; left:370px; top:28px; width:95px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m8','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m88','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>재무제표</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<%
			if(!mode.equals("new")) {
				if(!popup.equals("Y")&&!popup.equals("T")&&!popup.equals("U")){
			%>				
				<div id="btnReg" style="position:absolute; left:372px; top:28px; width:600px; height:28px; z-index:5; visibility: visible">
				<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand>
				<tr>
					<td>※ 신규가입방법 : 1.기본정보(저장) -> 2.영업담당(저장) -> 3.소싱정보등록(저장) -> 4.가입신청</td><td width="30px">&nbsp;</td><td><script language="javascript">btn("javascript:btnReg()","가입신청")</script></td>
				</tr>
				</table>
				</div>									
			<%
				}
			}
			%>
<%}else{ // 공급업체 : 기본정보 > 회사정보관리 > 회사정보

//	if(!ctrl_code.equals("P99")){
// 	if(ctrl_code.equals("P99")){
		
// 		System.out.println("ctrl_code : "+ctrl_code);
%>
	<div id="m1" style="position:absolute; left: 24px; top:28px; width:86px; height:28px; z-index:1; visibility: visible"
		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('gl')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m2" style="position:absolute; left:84px; top:28px; width:86px; height:28px; z-index:4; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('cp')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m3" style="position:absolute; left:144px; top:28px; width:86px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('pj')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m4" style="position:absolute; left:204px; top:28px; width:86px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('qr')" style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_off.gif></td>
		<td class=tab_txt_off valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>
	<div id="m5" style="position:absolute; left:264px; top:28px; width:	100px; height:28px; z-index:5; visibility: visible"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('sc')" style=cursor:hand><tr><td width=3>       
		<img src=/images/tab_left_off.gif></td>                                                                    
 <!-- 		<td class=tab_txt_off valign=bottom>업체등록평가</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>  -->
		<td class=tab_txt_off valign=bottom>소싱정보등록</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table>
	</div>	
<!-- 	<div id="m6" style="position:absolute; left:370px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide','m88','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('pl')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>개발자현황</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m7" style="position:absolute; left:346px; top:28px; width:95px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','hide','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','show','m88','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('sg')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>소싱그룹현황</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m8" style="position:absolute; left:535px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('fu')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>재무제표</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div>	 -->
	<div id="m11" style="position:absolute; left: 20px; top:28px; width:86px; height:28px; z-index:1; visibility: hidden"
		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m22" style="position:absolute; left:82px; top:28px; width:86px; height:28px; z-index:4; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m33" style="position:absolute; left:142px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23 style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m44" style="position:absolute; left:202px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>
		<img src=/images/tab_left_on.gif></td>
		<td class=tab_txt_on valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>
	</div>
	<div id="m55" style="position:absolute; left:262px; top:28px; width:100px; height:28px; z-index:5; visibility: hidden"
		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','show','m66','','hide','m77','','hide','m88','','hide')">
		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3>       
		<img src=/images/tab_left_on.gif></td>          
 <!-- 		<td class=tab_txt_on valign=bottom>업체등록평가</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>                                                            -->
		<td class=tab_txt_on valign=bottom>소싱정보등록</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table>                                                          
	</div>	
<!-- 	<div id="m66" style="position:absolute; left:370px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide','m88','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>개발자현황</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m77" style="position:absolute; left:346px; top:28px; width:95px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','hide','m8','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','show','m88','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>소싱그룹현황</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m88" style="position:absolute; left:535px; top:28px; width:95px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m8','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide','m88','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>재무제표</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->




<!-- To-be에서는 컨트롤코드 체크와 상관없이 우선은 모든 탭 보이게 설정함으로 하기 소스 주석처리함  -- 2014-10-29 by Kavez -->


<%-- 	<%}else{%> --%>
<!-- 	<div id="m1" style="position:absolute; left: 20px; top:28px; width:104px; height:29px; z-index:1; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('gl')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m2" style="position:absolute; left:85px; top:28px; width:86px; height:28px; z-index:4; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('cp')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m3" style="position:absolute; left:150px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('pj')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m4" style="position:absolute; left:215px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('qr')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div>	 -->
<!-- <!-- 	<div id="m6" style="position:absolute; left:282px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- <!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide')"> -->
<!-- <!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('pl')" style=cursor:hand><tr><td width=3> -->
<!-- <!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- <!-- 		<td class=tab_txt_off valign=bottom>개발자현황</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- <!-- 	</div> -->
<!-- 	<div id="m7" style="position:absolute; left:282px; top:28px; width:86px; height:28px; z-index:5; visibility: visible" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m11','m7','','hide','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('sg')" style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_off.gif></td> -->
<!-- 		<td class=tab_txt_off valign=bottom>소싱그룹현황</td><td width=4><img src=/images/tab_right_off.gif></td></tr></table> -->
<!-- 	</div>	 -->
<!-- 	<div id="m11" style="position:absolute; left: 20px; top:28px; width:104px; height:29px; z-index:1; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>기본정보</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m22" style="position:absolute; left:83px; top:28px; width:86px; height:28px; z-index:4; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>영업담당</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m33" style="position:absolute; left:148px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23 style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>수주실적</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<!-- 	<div id="m44" style="position:absolute; left:213px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>품질인증</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div>	 -->
<!-- <!-- 	<div id="m66" style="position:absolute; left:282px; top:28px; width:86px; height:28px; z-index:5; visibility: hidden" -->
<!-- <!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide')"> -->
<!-- <!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- <!-- 		<img src=/images/tab_left_on.gif></td> --> 
<!-- <!-- 		<td class=tab_txt_on valign=bottom>개발자현황</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- <!-- 	</div> -->
<!-- 	<div id="m77" style="position:absolute; left:282px; top:28px; width:95px; height:28px; z-index:5; visibility: hidden" -->
<!-- 		onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','show','m7','','hide','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide','m77','','show')"> -->
<!-- 		<table cellpadding=0 cellspacing=0 border=0 height=23  style=cursor:hand><tr><td width=3> -->
<!-- 		<img src=/images/tab_left_on.gif></td> -->
<!-- 		<td class=tab_txt_on valign=bottom>소싱그룹현황</td><td width=4><img src=/images/tab_right_on.gif></td></tr></table> -->
<!-- 	</div> -->
<%-- 	<% --%>
<!-- // 	  } -->
<%-- 	%> --%>
	
	
	<%
	}
	%>
<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="33">&nbsp;</td>
</tr>
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>
</form>
</body>
</html>
