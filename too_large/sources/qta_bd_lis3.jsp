<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_236");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_236";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif"; 
	
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
%>
<% String WISEHUB_PROCESS_ID="RQ_236";%>

<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	Config conf1 = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";
	String session_profile_code = info.getSession("MENU_TYPE");
	try {
		all_admin_profile_code = conf1.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = conf1.get("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));
	} catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}
%>

<html>
	<head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>		
<Script language="javascript" type="text/javascript">
//<!--
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_lis3";

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var INDEX_RFQ_NO;
var INDEX_RFQ_COUNT;
var INDEX_QTA_NO;
var INDEX_VENDOR_CODE;
var INDEX_VENDOR_NAME;
var INDEX_CLOSE_DATA;

function init() {
	setGridDraw();
	setHeader();
	doSelect();
}


function setHeader() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	form1.CTRL_CODE.value = ctrl_code[0];


	//hidden

	GridObj.strHDClickAction="sortmulti";
	GridObj.SetDateFormat("CHANGE_DATE",  "yyyy/MM/dd");
	GridObj.SetDateFormat("CONFIRM_DATE",  "yyyy/MM/dd");
	GridObj.SetDateFormat("QTA_VAL_DATE",  "yyyy/MM/dd");


	INDEX_RFQ_NO 		= GridObj.GetColHDIndex("RFQ_NO");
	INDEX_RFQ_COUNT 	= GridObj.GetColHDIndex("RFQ_COUNT");
	INDEX_QTA_NO 		= GridObj.GetColHDIndex("QTA_NO");
	INDEX_VENDOR_NAME 	= GridObj.GetColHDIndex("VENDOR_NAME");
	INDEX_VENDOR_CODE 	= GridObj.GetColHDIndex("VENDOR_CODE");
	INDEX_CLOSE_DATA  	= GridObj.GetColHDIndex("CLOSE_DATA");
}

function doSelect() {
	var sepoa = GridObj;
	var F = document.forms[0];

	if(LRTrim(F.start_rfq_date.value) == "" || LRTrim(F.end_rfq_date.value) == "" ) {
		alert("견적마감일을 입력하셔야 합니다.");
		return;
	}
	if(!checkDate(del_Slash(F.start_rfq_date.value))) {
		alert("견적마감일을 확인하세요.");
		form1.start_rfq_date.select();
		return;
	}
	if(!checkDate(del_Slash(F.end_rfq_date.value))) {
		alert("견적마감일을 확인하세요.");
		form1.end_rfq_date.select();
		return;
	}

	/*if(LRTrim(F.CTRL_CODE.value) == "" ) {
		alert("구매직무를 입력하셔야 합니다.");
		return;
	}*/
	CTRL_CODE = LRTrim(F.CTRL_CODE.value);
	CTRL_CODE = CTRL_CODE.toUpperCase();

	var ctrl_person_id_name = LRTrim(F.ctrl_person_id_name.value);

	var grid_col_id = "<%=grid_col_id%>";
	var params = "mode=getRfqHistory";
	params += "&grid_col_id=" + grid_col_id;
	params += dataOutput();
	GridObj.post(G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {

	if(msg1 == "t_imagetext") {
		if(msg3 == INDEX_RFQ_NO) { //견적요청번호

			RFQ_NO 		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),msg2);
			rfq_count 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_COUNT);

			var url = "rfq_bd_dis1.jsp?rfq_no=" + RFQ_NO + "&rfq_count=" + rfq_count;
			CodeSearchCommon(url,'rfq_win1','0','0','1012','760');

		}else if(msg3 == INDEX_QTA_NO) { //견적서번호

			st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_QTA_NO),msg2);

			if(LRTrim(st_qta_no	) == "")
				return;

			st_vendor_code 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_CODE);
			st_rfq_no 		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),msg2);
			st_rfq_count 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_COUNT);
			st_close_data 	= GD_GetCellValueIndex(GridObj,msg2, INDEX_CLOSE_DATA);

			send_url = "qta_pp_dis1.jsp?st_vendor_code=" + st_vendor_code + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
			send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count + "&st_close_data=" + st_close_data;

			/*
			if (st_close_data.length == 12 && <%=SepoaDate.getFormatString("yyyyMMddHHmm")%> < st_close_data ){
				alert("견적마감일이 지나지 않았습니다.");
				return;
			}

			if (st_close_data.length == 10 && <%=SepoaDate.getFormatString("yyyyMMddHH")%> < st_close_data ){
				alert("견적마감일이 지나지 않았습니다.");
				return;
			}
			*/
/**/
			if (st_qta_no=="견적포기"){
				alert("업체에서 견적 포기한 건입니다.");
				return;
			}
			CodeSearchCommon(send_url,'qta_win1','0','0','1012','760');

		} else if(msg3 == INDEX_VENDOR_NAME) { //업체

			st_vendor_code = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_CODE),msg2);
			if(LRTrim(st_vendor_code) == "")
				return;

			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+st_vendor_code,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
		}
	}
}

function start_rfq_date(year,month,day,week) {
	document.form1.start_rfq_date.value=year+month+day;
}

function end_rfq_date(year,month,day,week) {
	document.form1.end_rfq_date.value=year+month+day;
}
//-->

function getVendorCode(){
	//var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0087&function=setVendorCode&values=<%=house_code%>&values=&values=/&desc=업체코드&desc=업체명";
	//CodeSearchCommon(url,'itemNoWin','50','100','570','530');
	var arrValue = new Array();
	var arrDesc  = new Array();
	
	arrValue[0] = "<%=house_code%>";
	arrValue[1] = "";
	arrValue[2] = "";
	arrValue[3] = "/";
	
	arrDesc[0] = "업체코드";
	arrDesc[1] = "업체명";
	
	PopupCommonNoCond("SP0087", "setVendorCode", arrValue, arrDesc);
}

function setVendorCode( code, desc1, desc2)
{
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = desc1;
}

//구매담당
function SP0216_Popup() {
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=house_code%>&values=<%=company_code%>&values=&values=/&desc=구매그룹&desc=구매그룹명";
	CodeSearchCommon(url,'doc','0','0','540','500');
}

function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	document.form1.CTRL_CODE.value = ls_ctrl_code;
	document.form1.CTRL_NAME_LOC.value = ls_ctrl_name;
}

//구매직무
function SP0023_Popup() {
	/*
	//var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=house_code%>&values=<%=company_code%>&values=&values=/&desc=담당자ID&desc=담당자명";
	//CodeSearchCommon(url,'doc','0','0','550','500');
	
	var arrValue = new Array();
	var arrDesc  = new Array();
	
	arrValue[0] = "<%=house_code%>";
	arrValue[1] = "<%=company_code%>";
	arrValue[2] = "";
	arrValue[3] = "/";
	
	
	arrDesc[0] = "담당자";
	arrDesc[1] = "담당자명";
	
	PopupCommonNoCond("SP0023", "SP0023_getCode", arrValue, arrDesc);
	*/
	window.open("/common/CO_008.jsp?callback=SP0023_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

//function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
function SP0023_getCode(USER_ID, USER_NAME_LOC) {
	document.form1.ctrl_person_id.value = USER_ID;
	document.form1.ctrl_person_id_name.value = USER_NAME_LOC;
}

</Script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }

	// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
	// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
	function doOnRowSelected(rowId,cellInd)
	{
		var vendorCode = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
			var rfqNo    = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
			var rfqCount = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
		    var url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
			popUpOpen(url, 'GridCellClick', '1024', '650');
		}else if(cellInd == GridObj.getColIndexById("VENDOR_NAME") ) {
			var rfqNo      = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
			var rfqCount   = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
			
		    var url = '/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code='+vendorCode;
			popUpOpen(url, 'GridCellClick', '900', '700');
		}else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
			
			var st_qta_no = SepoaGridGetCellValueId(GridObj, rowId, "QTA_NO");

			if(LRTrim(st_qta_no	) == "")
				return;

			var st_close_data 	= SepoaGridGetCellValueId(GridObj, rowId, "CLOSE_DATA");
			var rfqNo    		= SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
			var rfqCount 		= SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");


			/*
			if (st_close_data.length == 12 && <%=SepoaDate.getFormatString("yyyyMMddHHmm")%> < st_close_data ){
				alert("견적마감일이 지나지 않았습니다.");
				return;
			}

			if (st_close_data.length == 10 && <%=SepoaDate.getFormatString("yyyyMMddHH")%> < st_close_data ){
				alert("견적마감일이 지나지 않았습니다.");
				return;
			}
			*/

			if (st_qta_no=="견적포기"){
				alert("업체에서 견적 포기한 건입니다.");
				return;
			}
			//CodeSearchCommon(send_url,'qta_win1','0','0','1012','760');
			var url = "qta_pp_dis1.jsp?st_vendor_code=" + vendorCode + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
			    url += "&st_rfq_no=" + rfqNo + "&st_rfq_count=" + rfqCount + "&st_close_data=" + st_close_data;
		    //var url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
			popUpOpen(url, 'GridCellClick', '1012', '760');
		}
		
		
	}
	
// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name.value = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->

<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<form name="form1" action="">
	<input type="hidden" name="CTRL_CODE" id="CTRL_CODE">
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적마감일
	</td>
	<td width="35%" class="data_td">
		<%-- <input type="text" name="start_rfq_date" size="8" maxlength="8" class="input_re" value="<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>">
		<a href="javascript:Calendar_Open('start_rfq_date');">
			<img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt="">
		</a>
		~
		<input type="text" name="end_rfq_date" size="8" maxlength="8" class="input_re" value="<%=SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),10)%>">
		<a href="javascript:Calendar_Open('end_rfq_date');">
			<img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0" alt="">
		</a> --%>
		<s:calendar id="start_rfq_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
		~
		<s:calendar id="end_rfq_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 업체코드
	</td>
	<td width="35%" class="data_td">
		<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive;" onkeydown='entKeyDown()'  size="15" maxlength="10" class="inputsubmit" >
		<a href="javascript:getVendorCode('setVendorCode')">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" name="p_vendor_code" border="0" alt="">
		</a>
		<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" name="vendor_name" size="20" onkeydown='entKeyDown()'  class="input_data2">
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적요청명
	</td>
	<td class="data_td" >
		<input type="text" name="subject" id="subject" style="width:95%" onkeydown='entKeyDown()'  maxlength="14" class="inputsubmit">
	</td>
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적요청번호
	</td>
	<td class="data_td">
		<input type="text" name="rfq_no" id="rfq_no" onkeydown='entKeyDown()'  style="width:95%;ime-mode:inactive;" maxlength="14" class="inputsubmit">
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적담당자
	</td>
	<td class="data_td" >
<% if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {%>	
		<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="15" onkeydown='entKeyDown()'  maxlength="15" class="inputsubmit" value="<%=info.getSession("ID")%>" >
		<a href="javascript:SP0023_Popup()">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
		</a>
<% } else{%> 
		<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="15" maxlength="15" onkeydown='entKeyDown()'  class="inputsubmit" value="<%=info.getSession("ID")%>" readonly>
<%} %>			
		<input type="text" name="ctrl_person_id_name" id="ctrl_person_id_name" size="15" class="input_data1"  onkeydown='entKeyDown()'  value='<%=info.getSession("NAME_LOC")%>'>
	</td>
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 진행상태
	</td>
	<td class="data_td">
		<select name="RFQ_FLAG" id="RFQ_FLAG" class="inputsubmit">
			<option value="1">전체</option>
			<option value="2">견적중/마감</option>
			<option value="3">견적종료</option>
		</select>
	</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="left">
		<TABLE cellpadding="0">
		<TR>
		</TR>
		</TABLE>
	</td>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="RQ_236" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>


