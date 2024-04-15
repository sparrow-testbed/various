<%--
	»ç¿ëÀÚ ½ÂÀÎ, »ç¿ëÀÚ ÇöÈ²
--%>

<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_common.jsp"%>
<script language='javascript' for='WiseGrid' event='Initialize()'>
	javascript:init();
	GD_setProperty(document.WiseGrid);
</script>
<script language='javascript' for='WiseGrid' event='ChangeCell(strColumnKey,nRow,vtOldValue,vtNewValue)'>
	GD_ChangeCell(document.WiseGrid,strColumnKey,nRow,vtOldValue,vtNewValue);
</script>
<script language='javascript' for='WiseGrid' event='ChangeCombo(strColumnKey, nRow, vtOldIndex, vtNewIndex)'>
	GD_ChangeCombo(document.WiseGrid,strColumnKey, nRow, vtOldIndex, vtNewIndex);
</script>
<script language='javascript' for='WiseGrid' event='CellClick(strColumnKey, nRow)'>
	GD_CellClick(document.WiseGrid,strColumnKey, nRow);
</script>
<script language='javascript' for='WiseGrid' event='EndQuery()'>
	GD_EndQuery(document.WiseGrid);
</script>
<script language='javascript' for='WiseGrid' event='HDClick(strColumnKey)'>
	GD_HDClick(document.WiseGrid,strColumnKey);
</script>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%>
<%@ include file="/include/wisetable_scripts.jsp"%>

<%
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String sign_status = JSPUtil.CheckInjection(JspUtil.nullToEmpty(request.getParameter("sign_status")));
	String gubun       = JSPUtil.CheckInjection(JspUtil.nullToEmpty(request.getParameter("gubun")));
%>
<%--Á¢¼ÓÇã¿ëID°¹¼ö  --%>
<%@ include file="/kr/master/user/count_user_id.jsp"%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">

<script language="javascript">
var G_SERVLETURL = "<%=getWiseServletPath("master.user.use_bd_lis2")%>";

var IDX_SEL                 = "" ;
var IDX_USER_ID             = "" ;
var IDX_USER_NAME_LOC       = "" ;
var IDX_COMPANY_NAME        = "" ;
var IDX_TEXT_WORK_TYPE      = "" ;
var IDX_DEPT_NAME           = "" ;
var IDX_POSITION            = "" ;
var IDX_MANAGER_POSITION    = "" ;
var IDX_PHONE_NO            = "" ;
var IDX_MENU_NAME           = "" ;
var IDX_HOUSE_CODE          = "" ;
var IDX_USER_TYPE           = "" ;

function init()
{
	setHeader();

}

function setHeader()
{



	document.WiseGrid.ClearGrid();

	document.WiseGrid.AddHeader("SEL"             ,       "¼±ÅÃ","t_checkbox",10,30,true);
	document.WiseGrid.AddHeader("USER_ID"         ,       "»ç¿ëÀÚID","t_text",20,90,false);
	document.WiseGrid.AddHeader("USER_NAME_LOC"   ,       "»ç¿ëÀÚ¸í","t_text",100,120,false);
	document.WiseGrid.AddHeader("COMPANY_NAME"    ,       "È¸»ç","t_text",100,120,false);
	document.WiseGrid.AddHeader("TEXT_WORK_TYPE"  ,       "¾÷¹«±ÇÇÑ","t_text",100,80,false);
	document.WiseGrid.AddHeader("DEPT_NAME"       ,       "ºÎ¼­¸í","t_text",100,120,false);
	document.WiseGrid.AddHeader("POSITION"        ,       "Á÷À§","t_text",100,80,false);
	// 2011.3.24 solarb Á÷Ã¥Ç×¸ñ hidden  »çÀÌÁî 0À¸·Î ¼öÁ¤
	document.WiseGrid.AddHeader("MANAGER_POSITION",       "Á÷Ã¥","t_text",100,0,false);
	document.WiseGrid.AddHeader("PHONE_NO"        ,       "ÀüÈ­¹øÈ£","t_text",100,100,false);
	document.WiseGrid.AddHeader("MENU_NAME"       ,       "ÇÁ·ÎÆÄÀÏ¸í","t_imagetext",100,160,false);
	document.WiseGrid.AddHeader("LOGIN_NCY_NAME"  ,       "Á¢¼Ó°¡´É¿©ºÎ","t_text",100,100,false);
	document.WiseGrid.AddHeader("HOUSE_CODE"      ,       "","t_text",1000,0,false);
	document.WiseGrid.AddHeader("USER_TYPE"       ,       "USER_TYPE","t_text",10,0,false);

	document.WiseGrid.BoundHeader();
	//document.WiseGrid.SetColCellBgColor(    "USER_ID"         ,G_COL1_ESS);

	document.WiseGrid.SetColCellAlign("USER_ID","center");
	document.WiseGrid.SetColCellAlign("TEXT_WORK_TYPE","center");
	document.WiseGrid.SetColCellAlign("POSITION","center");
	document.WiseGrid.SetColCellAlign("MANAGER_POSITION","center");
	document.WiseGrid.SetColCellAlign("LOGIN_NCY_NAME","center");

	IDX_SEL                 = document.WiseGrid.GetColHDIndex("SEL");
	IDX_USER_ID             = document.WiseGrid.GetColHDIndex("USER_ID");
	IDX_USER_NAME_LOC       = document.WiseGrid.GetColHDIndex("USER_NAME_LOC");
	IDX_COMPANY_NAME        = document.WiseGrid.GetColHDIndex("COMPANY_NAME");
	IDX_TEXT_WORK_TYPE      = document.WiseGrid.GetColHDIndex("TEXT_WORK_TYPE");
	IDX_DEPT_NAME           = document.WiseGrid.GetColHDIndex("DEPT_NAME");
	IDX_POSITION            = document.WiseGrid.GetColHDIndex("POSITION");
	IDX_MANAGER_POSITION    = document.WiseGrid.GetColHDIndex("MANAGER_POSITION");
	IDX_PHONE_NO            = document.WiseGrid.GetColHDIndex("PHONE_NO");
	IDX_MENU_NAME           = document.WiseGrid.GetColHDIndex("MENU_NAME");
	IDX_USER_TYPE           = document.WiseGrid.GetColHDIndex("LOGIN_NCY_NAME");
	IDX_HOUSE_CODE          = document.WiseGrid.GetColHDIndex("HOUSE_CODE");
	IDX_USER_TYPE           = document.WiseGrid.GetColHDIndex("USER_TYPE");
	
}

function doSelect()
{
	var f = document.forms[0];
	var wise = document.WiseGrid;

	f.i_company_code.value = f.i_company_code.value.toUpperCase();
	var i_company_code  = f.i_company_code.value;
	f.i_dept.value      = f.i_dept.value.toUpperCase();
	var i_dept          = f.i_dept.value;
	f.i_user_id.value   = f.i_user_id.value.toUpperCase();
	var i_user_id       = f.i_user_id.value;
	var i_user_name_loc = f.i_user_name_loc.value;
	var i_user_type     = f.i_user_type.value;
	var i_work_type     = f.i_work_type.value;

	if(i_user_id == "")
		f.text_user_name.value = "";


	f.dept_usedpopup.value = "off";
	f.id_usedpopup.value = "off";

	document.WiseGrid.SetParam("i_user_id",i_user_id);
	document.WiseGrid.SetParam("i_user_name_loc",i_user_name_loc);
	document.WiseGrid.SetParam("i_company_code",i_company_code);
	document.WiseGrid.SetParam("i_dept",i_dept);
	document.WiseGrid.SetParam("i_sign_status","<%=sign_status%>");
	document.WiseGrid.SetParam("i_user_type",i_user_type);
	document.WiseGrid.SetParam("i_work_type",i_work_type);
	document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","0");
	document.WiseGrid.SendData(G_SERVLETURL);
	document.WiseGrid.strHDClickAction="sortmulti";
}


function Change()
{
	var wise =  document.WiseGrid;
	var iCheckedCount = 0;
	var totalCnt = '<%=totalCnt%>';
		
	var iCheckedCount = getCheckedCount(wise,IDX_SEL);
	if(iCheckedCount < 1)
	{
		alert("¼±ÅÃµÈ Ç×¸ñÀÌ ¾ø½À´Ï´Ù.");
		return;
	}else if (iCheckedCount > 1 ){
		alert("ÇÏ³ªÀÇ Ç×¸ñ¸¸ ¼±ÅÃÇØÁÖ¼¼¿ä");
		return;
	}
	
	
	<%-- º¯°æÇÒ Ç×¸ñÀ» ¼±ÅÃÇß´ÂÁö Ã¼Å©ÇÏ°í ¿©·¯°³°¡ ¼±ÅÃµÇ¾úÀ¸¸é °¡Àå À§ÀÇ Ç×¸ñ¿¡ ´ëÇÑ º¯°æÈ­¸éÀ¸·Î ÀÌµ¿ÇÑ´Ù. --%>
	for(var i=0;i<document.WiseGrid.GetRowCount();i++)
	{
		var temp = GD_GetCellValueIndex(document.WiseGrid,i,IDX_SEL);
		if(temp == "true")
		{
			iCheckedCount++;

			dim = ToCenter('600','800');
			var top = dim[0];
			var left = dim[1];

			<%--   // i_flag´Â B: top¿¡¼­ÀÇ ÀÚ±âÀÚ½ÅÀÇ »ç¿ëÀÚ Á¤º¸¸¦ °íÄ¥¶§ ,N: ¸¶½ºÅÍ »ç¿ëÀÚ¸Þ´º¿¡¼­  »ç¿ëÀÚ ¼öÁ¤ P: ? --%>
			winobj = window.open("/kr/master/user/use_bd_updf.jsp?i_flag=N&i_user_id="+GD_GetCellValueIndex(document.WiseGrid,i,IDX_USER_ID)+"&totalCnt="+totalCnt,"BKWin","top="+top+",left="+left+",width=840,height=600,resizable=yes,status=yes,scrollbars = yes");

			break;
		}
	}

	if(iCheckedCount<1)
		alert("Ç×¸ñÀ» ¼±ÅÃÇØÁÖ¼¼¿ä.");
}

<%-- ¼±ÅÃµÈ Ç×¸ñÀÇ ¼¼ºÎ»çÇ×À» º¸¿©ÁØ´Ù.--%>
function doDisplay() {

	var wise =  document.WiseGrid;
	var sel_row = "";

	<%-- º¯°æÇÒ Ç×¸ñÀ» ¼±ÅÃÇß´ÂÁö Ã¼Å©ÇÏ°í ¿©·¯°³°¡ ¼±ÅÃµÇ¾úÀ¸¸é °¡Àå À§ÀÇ Ç×¸ñ¿¡ ´ëÇÑ º¯°æÈ­¸éÀ¸·Î ÀÌµ¿ÇÑ´Ù. --%>
	for(var i=0;i<document.WiseGrid.GetRowCount();i++){
		var temp = GD_GetCellValueIndex(document.WiseGrid,i,IDX_SEL);
		if(temp == "true") {
			sel_row += i + "&";

			<%-- alert(i+1+"¹øÂ° Ç×¸ñÀÌ ¼±ÅÃµÇ¾ú½À´Ï´Ù.");--%>

			dim = ToCenter('600','800');
			var top = dim[0];
			var left = dim[1];

			winobj = window.open("/kr/master/user/use_bd_dis2.jsp?i_user_id="+GD_GetCellValueIndex(document.WiseGrid,i,IDX_USER_ID),"BKWin","top="+top+",left="+left+",width=840,height=520,resizable=yes,status=yes,scrollbars = yes");

			break;
		}
	}
	if(sel_row=="") alert("Ç×¸ñÀ» ¼±ÅÃÇØÁÖ¼¼¿ä.");

}

<%-- ½ÂÀÎ½Ã ÀÌ ÇÔ¼ö¸¦ ºÎ¸¥´Ù. ¼±ÅÃµÈ ROW¸¦ È®ÀÎ.--%>

function checkrow() {
	var rtn = "false"
	var addrow = document.WiseGrid.GetRowCount();
	for(i = 0 ; i < parseInt(addrow) ; i++)
	{
		if(GD_GetCellValueIndex(document.WiseGrid,i,IDX_SEL) != "false") rtn = "true";
	}
	return rtn;
}

<%-- ½ÂÀÎ½Ã ÀÌ ÇÔ¼ö¸¦ ºÎ¸¥´Ù. ¼±ÅÃµÈ °÷ÀÇ ¸Þ´º ÄÚµå°¡ ÀÖ´ÂÁö È®ÀÎ.--%>

function checkcode()
{
	var wise = document.WiseGrid;
	var rtn = false
	var iRowCount = document.WiseGrid.GetRowCount();
	for(i = 0 ; i < parseInt(iRowCount) ; i++)
	{
		if(GD_GetCellValueIndex(document.WiseGrid,i,IDX_SEL) == "true" && (GD_GetCellValueIndex(document.WiseGrid,i,IDX_MENU_NAME) == "" ||GD_GetCellValueIndex(document.WiseGrid,i,IDX_MENU_NAME) == 'null'))
			rtn = true;
	}
	return rtn;
}

<%-- »ç¿ëÀÚ ½ÂÀÎ --%>
function doApproval()
{
	var wise = document.WiseGrid;

	var iCheckedCount = getCheckedCount(wise,IDX_SEL);
	if(iCheckedCount < 1)
	{
		alert("¼±ÅÃµÈ Ç×¸ñÀÌ ¾ø½À´Ï´Ù.");
		return;
	}

	if(checkcode())
	{
		alert("ÇÁ·ÎÆÄÀÏ ÄÚµå¸¦ ³Ö¾îÁÖ¼¼¿ä.");
		return;
	}

	document.WiseGrid.SetParam("mode","setApproval");
	document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
	document.WiseGrid.SendData(G_SERVLETURL, "ALL", "ALL");
}

<%-- »ç¿ëÀÚ »èÁ¦--%>
function doDelete(mode)
{
	var wise = document.WiseGrid;
	var iCheckedCount = getCheckedCount(wise,IDX_SEL);
	if(iCheckedCount < 1)
	{
		alert("¼±ÅÃµÈ Ç×¸ñÀÌ ¾ø½À´Ï´Ù.");
		return;
	}

	if(!confirm("»ç¿ëÀÚ »èÁ¦½Ã µ¿ÀÏÇÑ ¾ÆÀÌµð·Î(ID)·Î ´Ù½Ã µî·ÏÇÒ ¼ö ¾ø½À´Ï´Ù.\n\nÁ¤¸» »èÁ¦ ÇÏ½Ã°Ú½À´Ï±î?"))
		return;

	document.WiseGrid.SetParam("mode",mode);
	document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
	document.WiseGrid.SendData(G_SERVLETURL, "ALL", "ALL");
}

<%-- ¸Þ´º ¿ÀºêÁ§Æ® ÄÚµå¸¦ ¹Þ°í ÇÁ·Î ÆÄÀÏ Á¤º¸¸¦ º¼ ¼öÀÖ´Â ÆË¾÷À» ¶ç¿î´Ù.--%>
function setobjectcode(obj_code, code) {
	var f = document.forms[0];
	var col = f.scol.value;
	var row = f.srow.value;
	var obj_name = document.WiseGrid.GetCellValue(document.WiseGrid.GetColHDKey(row),col);

	var url = "/kr/admin/system/mu1_pp_ins2.jsp?MENU_PROFILE_CODE=" +obj_code+ "&MENU_NAME=" + obj_name+"&MENU_CODE="+code;
	var dim = new Array(2);

	dim = ToCenter('600','800');
	var top = dim[0];
	var left = dim[1];
	window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=600,resizable=yes,status=yes,scrollbars = yes");
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)  {

	if(msg1 == "doData") {
		rtn = GD_GetParam(document.WiseGrid, 0 );
		alert(rtn); <%--// ¼­¹ö¿¡¼­ °¡Á®¿À´Â ¸Þ¼¼ÁöÀÌ´Ù.--%>

		doSelect();
	}
	
	if(msg1 == "t_imagetext" )
	{
		document.forms[0].scol.value = msg2;
		document.forms[0].srow.value = msg3;
		
		<%-- ½Å±Ô »ç¿ëÀÚ ½ÂÀÎ½Ã¿¡´Â ÇÁ·ÎÆÄÀÏ ÄÚµå¸¦ ³Ö´Â ÆË¾÷À» ºÎ¸£°í--%>
		<%-- »ç¿ëÀÚ ÇöÈ²Á¶È¸¶§´Â ÇÁ·ÎÆÄÀÏ ÄÚµåÀÇ »ó¼¼³»¿ë(¸Þ´ºµé)À» ÆË¾÷À¸·Î º¸¿©ÁØ´Ù.--%>
		if ("<%=sign_status%>"== "R") {
			var url = "/kr/admin/system/mu1_bd_ins3.jsp?flag=Y";
			var dim = new Array(2);

			dim = ToCenter('600','800');
			var top = dim[0];
			var left = dim[1];
			window.open(url,"BKWin","top="+top+",left="+left+",width=800,height=500,resizable=yes,status=yes,scrollbars = yes");
		} else {
			var obj_code = GD_GetCellValueIndex(document.WiseGrid,msg2,msg3);
			if (obj_code == "") {
				alert("ÇÁ·ÎÆÄÀÏ ÄÚµå°¡ ÁöÁ¤µÇÁö ¾Ê¾Ò½À´Ï´Ù.");
				return;
			}

			document.workFrm.location.href = "use_wk_get1.jsp?i_menu_profile_code="+obj_code;  //worm.  ¼öÁ¤ ÇÏ´Ü¿¡ iFrame Ãß°¡
		}
	}else if(msg1 == 't_insert'){
		if(msg3 == IDX_SEL)
		{

		}
	}
}

function Setprofile(code,name) {
	var col = document.forms[0].scol.value;
	var row = document.forms[0].srow.value;
	GD_SetCellValueIndex(document.WiseGrid,col, row,"/kr/images/button/query.gif&"+replace(name, "&", "£¦")+"&"+code,"&");
}

<%-- ÆË¾÷È­¸é.--%>
function getDept(code, text) {
	document.forms[0].i_dept.value = code;
	document.forms[0].text_depart.value = text;
	document.forms[0].dept_usedpopup.value = "on";
}

function SP9112_getCode(id, no, name, dept ) {
	document.forms[0].i_user_id.value = id;
	document.forms[0].text_user_name.value = name;
	document.forms[0].id_usedpopup.value = "on";
}

function getPartner_code(code,text, type) {
	document.forms[0].i_company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function getVendor_code(code,text, texteng) {
	document.forms[0].i_company_code.value = code;
	document.forms[0].text_company_code.value = text;
}

function searchProfile(fc) {
	var url = "";
	if( fc == "i_company_code" ) {
		if (document.forms[0].edit.value == "N") {
			return;
		}

		if (document.forms[0].i_user_type.value  == "")
		{
			alert("È¸»ç ±¸ºÐÀ» ¸ÕÀú ¼±ÅÃÇØ¾ß ÇÕ´Ï´Ù.");
			return;
		}

		if (document.forms[0].i_user_type.value  == "1000")
		{
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0055&function=getPartner_code&values=<%=house_code%>&values=&values=";

		} else if (document.forms[0].i_user_type.value  == "S")
		{
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}
	if(fc == "i_dept") {
		if (document.forms[0].i_user_type.value  == "P" || document.forms[0].i_user_type.value  == "S")
		{
			url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9053&function=getDept&values=<%=house_code%>&values=M105&values=&values=/&desc=ÄÚµå&desc=ºÎ¼­¸í";
		} else {
			if(document.forms[0].i_company_code.value == "") {
				alert("È¸»ç¸¦ ¸ÕÀú ¼±ÅÃÇØÁÖ¼¼¿ä");
				return;
			}else {
				url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0022&function=getDept&values=<%=house_code%>&values="+document.forms[0].i_company_code.value+"&values=&values=/&desc=ÄÚµå&desc=ºÎ¼­¸í";
			}
		}
	}else if (fc == "i_user_id")  {
		if(document.forms[0].i_company_code.value == "") {
			alert("È¸»ç¸¦ ¸ÕÀú ¼±ÅÃÇØÁÖ¼¼¿ä");
			return;
		}

		if(document.forms[0].i_dept.value == "") {
			alert("ºÎ¼­´ÜÀ§¸¦ ¸ÕÀú ¼±ÅÃÇØÁÖ¼¼¿ä");
			return;
		}

		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9112&function=D&values=<%=house_code%>&values="+document.forms[0].i_company_code.value+"&values="+document.forms[0].i_dept.value+"&values=&values=";
	}

	if ( isNull(url) ) {
	    return ;
	}

	Code_Search(url,'','','','','');
}

function actionedit() {

	i_user_type = document.forms[0].i_user_type.value;
	text_user_type = document.forms[0].i_user_type.options[document.forms[0].i_user_type.selectedIndex].text;

	if ( i_user_type == "P" || i_user_type == "S" ) {
		document.forms[0].edit.value = "Y";
		document.forms[0].i_company_code.value = "";
		document.forms[0].text_company_code.value = "";
	} else {
		document.forms[0].i_company_code.value = i_user_type;
		document.forms[0].text_company_code.value = text_user_type;
		document.forms[0].edit.value = "N";
	}
}

<%--  ºÎ¼­ÄÚµå µ¿Àû Select
	function getDepartment() {
		parent.work.location.href ="use_dept_lis2.jsp?i_company_code="+document.form.i_company_code.options[document.form.i_company_code.selectedIndex].value+"&sv=i_dept";
	}
--%>

function entKeyDown()
{
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}

function pwdReset()
{


	var wise =  document.WiseGrid;
	var sel_row_cnt = 0;
	var sel_user_id = "";
	var user_type = "";
	var password = document.form.password.value;



	for(var i=0;i<document.WiseGrid.GetRowCount();i++)
	{
		var temp = wise.getCellValue("SEL",i);
		if(temp == 1) {
			sel_row_cnt++;
			sel_user_id = wise.getCellValueIndex(IDX_USER_ID,i);
			user_type = wise.getCellValueIndex(IDX_USER_TYPE,i);
		}
	}
	if(sel_row_cnt==0) {
	    alert("Ç×¸ñÀ» ¼±ÅÃÇØÁÖ¼¼¿ä.");
	    return;
	}

// 	if(sel_row_cnt>1) {
// 	    alert("ÇÏ³ªÀÇ Ç×¸ñ¸¸ ¼±ÅÃÇØÁÖ¼¼¿ä");
// 	    return;
// 	}

	if(password == "") {
	    alert("ÀÓ½Ã ºñ¹Ð¹øÈ£¸¦ ÀÔ·ÂÇÏ¼¼¿ä");
	    document.form.password.focus();
	    return;
	}

	/*if(user_type == "1000"){
		alert("³»ºÎ»ç¿ëÀÚ´Â ¾ÏÈ£¸¦ ÃÊ±âÈ­ ÇÒ ¼ö ¾ø½À´Ï´Ù.");
		return;
	}*/


// 	if(!confirm("¼±ÅÃÇÏ½Å »ç¿ëÀÚ("+sel_user_id+") ºñ¹Ð¹øÈ£¸¦ ÃÊ±âÈ­ ÇÕ´Ï´Ù.\nÃÊ±âÈ­ ºñ¹Ð¹øÈ£´Â '"+password+"' ÀÔ´Ï´Ù.")) {
// 	    return;
// 	}
	if(!confirm("¼±ÅÃÇÏ½Å »ç¿ëÀÚ ºñ¹Ð¹øÈ£¸¦ ÃÊ±âÈ­ ÇÕ´Ï´Ù.\nÃÊ±âÈ­ ºñ¹Ð¹øÈ£´Â '"+password+"' ÀÔ´Ï´Ù.")) {
	    return;
	}	

	document.WiseGrid.SetParam("sel_user_id", sel_user_id);
	document.WiseGrid.SetParam("password", password);
	var servletUrl = "<%=getWiseServletPath("master.user.use_pwd_reset")%>";
	document.WiseGrid.SetParam("WISETABLE_DOQUERY_DODATA","1");
	document.WiseGrid.SendData(servletUrl, "ALL", "ALL");
}

</script>

</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onLoad='actionedit();'>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="cell_title1" width="78%" align="left">&nbsp;
	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12">
	  	<%@ include file="/include/wisehub_milestone.jsp" %>
	  	</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="ccd5de">
<form name="form" method="post" action="">
<input type="hidden" value="" name="scol">
<input type="hidden" value="" name="srow">
<input type="hidden" name="edit" value="Y">
	 <tr>
	  <td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ±¸ºÐ</td>
	  <td class="c_data_1">
		<select name="i_user_type" class="inputsubmit" onChange="actionedit();" >
		<option>ÀüÃ¼</option>
	   <%
		 String i_user_type = ListBox(request, "SL0081",  house_code+"#"+house_code+"#", company_code);
		 out.println(i_user_type);
	   %>
		</select>
	  </td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ¾÷¹«±ÇÇÑ</td>
	  <td class="c_data_1">
		<select name="i_work_type" class="inputsubmit">
		<option>ÀüÃ¼</option>
	   <%
		 String i_work_type = ListBox(request, "SL0007",  house_code+"#M104#", "");
		 out.println(i_work_type);
	   %>
		</select>
		</td>
	</tr>
	<tr>
	  <td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> È¸»çÄÚµå</td>
	  <td class="c_data_1">
		<input type="text" size="15" name="i_company_code" class="inputsubmit" maxlength="10" onkeydown='entKeyDown()' >
		<a href="javascript:searchProfile('i_company_code')"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		<input type="text" name="text_company_code" class="input_data2" readonly  >
	  </td>
	  <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> ºÎ¼­</td>
	  <td class="c_data_1">
		<input type="text" size="15" value="" name="i_dept" class="inputsubmit" maxlength="10" onkeydown='entKeyDown()' >
		<a href="javascript:searchProfile( 'i_dept' )"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		<input type="text" value="" name="text_depart" size="10" class="input_data2" readOnly ></td>
	</tr>

	<tr>
	  <td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ ID</td>
	  <td class="c_data_1" width="35%">
		<input type="text" size="15" value="" name="i_user_id" class="inputsubmit" onkeydown='entKeyDown()' >
		<a href="javascript:searchProfile( 'i_user_id' )"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0"></a>
		<input type="text" value="" name="text_user_name" size="20" class="input_data2" readOnly ></td>
	</td>
	  <td class="c_title_1" width="15%"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> »ç¿ëÀÚ¸í</td>
	  <td class="c_data_1" width="35%">
		<input type="text" name="i_user_name_loc" size="20" class="inputsubmit" onkeydown='entKeyDown()' ></td>
	</tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td><input type="hidden"  value="off" name="dept_usedpopup">
		<input type="hidden"  value="off" name="id_usedpopup"> </td>
	</tr>
  </table>
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
      		<%
      			String widSize = "51";
      			if(sign_status.equals("R")){
      				widSize = "74";
      			}
      		%>
				<TABLE width="100%" cellpadding="0">
		      		<TR>
		      			 <td width="<%=widSize%>%" align="left">		      			 	
							ÃÖ´ë»ç¿ëÀÚ/·Î±×ÀÎ°¡´É»ç¿ëÀÚ(³»ºÎ/¿ÜºÎ)&nbsp;:&nbsp;<%=maxCnt %>&nbsp;/&nbsp;<%=totalCnt %>(&nbsp;<%=companyCnt %>&nbsp;/&nbsp;<%=supplyCnt %>&nbsp;)							
		      			 </td>
						<TD align="right"><script language="javascript">btn("javascript:doSelect()",2,"Á¶ È¸")</script></TD>
	<%
		if (sign_status.equals("R")) {
	%>
						<TD align="right"><script language="javascript">btn("javascript:doDisplay()",29,"»ó¼¼Á¤º¸")</script></TD>
						<TD align="right"><script language="javascript">btn("javascript:doApproval()",13,"½Â ÀÎ")</script></TD>
						<TD align="right"><script language="javascript">btn("javascript:doDelete('setDelete')",3,"»è Á¦")</script></TD>
	<%} else {%>
		<%
		if (!gubun.equals("M")) {
		%>				<TD height="25">ÀÓ½Ã ºñ¹Ð¹øÈ£ : </TD>
						<TD height="25"><input type="text" value="" name="password" size="12"></td>
						<TD align="right"><script language="javascript">btn("javascript:pwdReset()",28,"ºñ¹Ð¹øÈ£ ÃÊ±âÈ­")</script></TD>
						<TD align="right"><script language="javascript">btn("javascript:Change()",43,"¼ö Á¤")</script></TD>
		<%} %>
		<%
		if (!gubun.equals("M")) {
		%>
						<TD align="right"><script language="javascript">btn("javascript:doDelete('setDelete')",3,"»è Á¦")</script></TD>
		<%} %>
	<%} %>
					</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="1" class="cell"></td>
	<!-- wisegrid »ó´Ü bar -->
	</tr>
	<tr>
		 <td align="center"><%=WiseTable_Scripts("100%","340")%></td>
	</tr>
  </table>
</form>
	<jsp:include page="/include/window_height_resize_event.jsp" >
	<jsp:param name="grid_object_name_height" value="WiseGrid=260"/>
	</jsp:include>
</body>
<iframe name="workFrm" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</html>
