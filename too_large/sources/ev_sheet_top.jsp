<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ page import="sepoa.fw.cfg.*" %>
<%
	Configuration conf = new Configuration();
	String domain = conf.getString("sepoa.system.domain.name");

	String screen_id="WO_005_1";
	
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.nullToEmpty(request.getParameter("ev_year"));

 %>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="../js/sec.js"></script>
<script src="../js/cal.js" language="javascript"></script>
<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="JavaScript" type="text/javascript">

var G_HOUSE_CODE  = "";
var G_FLAG        = ">";
var G_VENDOR_CODE = ">";
var G_ACCESS_URL  = ""; //이동하는 페이지
var G_MOVE_FLAG   = true; 

	function help(){
		var url = "<%=domain%>/help/<%=screen_id%>.htm";
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'yes';
        var title = "Help";
        var left = "100";
        var top = "100";
        var width = "800";
        var height = "600";
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();

	}
	
	
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
	if(G_MOVE_FLAG){
  		var i,p,v,obj,args=MM_showHideLayers.arguments;
  		
  		for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
  		  if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
  		  obj.visibility=v; }
	}
}


function goSubmit()
{
	MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m4','','show','m11','','show','m22','','hide','m33','','hide','m44','','hide');
	var objForm = document.forms[0];
	objForm.st_vsendor_code.value = objForm.st_vendor_code.value.toUpperCase();

	var save_flag= objForm.save_flag.value;
	var st_vendor_code  = objForm.st_vendor_code.value;
	var st_company_code = objForm.st_company_code.value;
/*
	if(save_flag == "false")
	{
		alert("심사표의 일반사항 저장을 입력하셔야 이동이 가능합니다");
		objForm.st_vendor_code.focus();
		return;
	}
*/
	objForm.method="post";
	objForm.target="down"
	objForm.action = downframe;
	objForm.submit();
}


function goPage(access_flag)
{
	var f 		= document.forms[0];
	var save_flag= f.save_flag.value;
	vendor_code = f.vendor_code.value;
	var flag 	= f.flag.value;
	var bp_yn 	= f.bp_yn.value;
	var ev_no	= f.ev_no.value;
	var ev_year	= f.ev_year.value;
	
	if(ev_no == "" )
	{
		alert("일반사항 저장을 입력하셔야 이동이 가능합니다");
		G_MOVE_FLAG = false;
		return;
	}
	G_MOVE_FLAG = true;
	
	if (access_flag	== 'a')
	{
		url_detail   = "ev_sheet_basic.jsp?ev_no="+ev_no+"&ev_year="+ev_year;
	}
	if(access_flag == "b"){
		url_detail   = "ev_sheet_insert.jsp?ev_no="+ev_no+"&ev_year="+ev_year;
	}
	if(access_flag == "c"){
		url_detail   = "ev_sheet_insert2.jsp?ev_no="+ev_no+"&ev_year="+ev_year;
	}
	
	G_ACCESS_URL = url_detail;
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

</script>

</head>

	<body bgcolor="#FFFFFF" leftmargin="15" topmargin="6" onload="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m11','','show','m22','','hide','m33','','hide')">
		<form name="form1" method="post" action="">
		<input type="hidden" name="vendor_code" value="" readonly="readonly">
		<input type="hidden" name="flag" value="insert" readonly="readonly">
		<input type="hidden"  name="bp_yn"  value="" readonly="readonly"> 
		<input type="hidden"  name="save_flag"  value="false" readonly="readonly"> 
		<input type="hidden"  name="ev_no"  value="<%=ev_no %>" readonly="readonly">
		<input type="hidden"  name="ev_year"  value="<%=ev_year %>" readonly="readonly"> 
		
<%
 	String title = "";
 	
 	if( "".equals(ev_no) ){
 		title = "심사표생성";
 	}else{
 		title = "심사표수정";
 	}
 	
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = title;
%>		
		<%@ include file="/include/sepoa_milestone.jsp"%>
			
			
			<div id="m1" style="position:absolute; left: 20px; top:33px; width:120px; height:29px; z-index:1; visibility: visible"
				onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m11','','show','m22','','hide','m33','','hide')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('a')" style=cursor:hand>
					<tr>
						<td><img src=/images/button1_w.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
			<div id="m2" style="position:absolute; left:140px; top:33px; width:120px; height:28px; z-index:2; visibility: visible"
				onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m11','','hide','m22','','show','m33','','hide')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('b')" style=cursor:hand>
					<tr>
						<td><img src=/images/button2_w.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
			<div id="m3" style="position:absolute; left:260px; top:33px; width:120px; height:28px; z-index:3; visibility: visible"
				onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m11','','hide','m22','','hide','m33','','show')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('c')" style=cursor:hand>
					<tr>
						<td><img src=/images/button3_w.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
		
			

			<div id="m11" style="position:absolute; left: 20px; top:33px; width:120px; height:29px; z-index:1; visibility: hidden"
				onClick="MM_showHideLayers('m1','','hide','m2','','show','m3','','show','m11','','show','m22','','hide','m33','','hide')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('a')" style=cursor:hand>
					<tr>
						<td><img src=/images/button1_b.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
			<div id="m22" style="position:absolute; left:140px; top:33px; width:120px; height:29px; z-index:2; visibility: hidden"
				onClick="MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m11','','hide','m22','','show','m33','','hide')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('b')" style=cursor:hand>
					<tr>
						<td><img src=/images/button2_b.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
			<div id="m33" style="position:absolute; left:260px; top:33px; width:120px; height:29px; z-index:3; visibility: hidden"
				onClick="MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m11','','hide','m22','','hide','m33','','show')">
				<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="javascript:goPage('c')" style=cursor:hand>
					<tr>
						<td><img src=/images/button3_b.gif width="120" height="29"></td>
					</tr>
				</table>
			</div>
			
			
			<br>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:  0.9cm">
					<tr>
						<td class="title_table_top_folder" height="5">
							
						</td>
					</tr>
				</table>
		</form>
	</body>
</html>
