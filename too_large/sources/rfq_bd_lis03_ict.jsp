<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_RQ_447");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_RQ_447";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	String WISEHUB_PROCESS_ID="I_RQ_447";
    String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String CTRL_CODE 	= info.getSession("CTRL_CODE");
    String dNameLoc 	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"));
    String depart 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
    String FLAG			= JSPUtil.nullToRef(request.getParameter("FLAG"),"");
%>
<html>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
//<!--
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var mode;
var IDX_SELECTED        ;
var IDX_BIZ_NO          ;
var IDX_BIZ_NM          ;
var IDX_RFQ_NO          ;
var IDX_RFQ_COUNT       ;
var IDX_RFQ_SEQ         ;
var IDX_RFQ_NM          ;
var IDX_ITEM_NO         ;
var IDX_ITEM_NM         ;
var IDX_ITEM_CN         ;
var IDX_MFCO_CODE       ;
var IDX_MFCO_NM         ;
var IDX_RFQ_DATE        ;
var IDX_RFQ_CLOSE_DT    ;
var IDX_RFQ_CLOSE_DATE  ;
var IDX_RFQ_CLOSE_TIME  ;
var IDX_RFQ_ID          ;
var IDX_RFQ_NAME        ;
var IDX_VENDOR_CODE     ;
var IDX_VENDOR_NAME     ;
var IDX_SUBMIT_USER_ID  ;
var IDX_SUBMIT_USER_NAME;
var IDX_SUBMIT_DATE_TIME;
var IDX_SUBMIT_FLAG     ;
var IDX_SUBMIT_FLAG_NAME;
var IDX_QTA_NO          ;
var IDX_ATTACH_NO       ;
var IDX_ATTACH_CNT      ;
var IDX_ATTACH_NO_H     ;
var IDX_CONFIRM_FLAG    ;
var IDX_CONFIRM_REASON  ;

var IDX_H_BIZ_NO          ;
var IDX_H_RFQ_NO          ;
var IDX_H_RFQ_COUNT       ;
var IDX_H_RFQ_SEQ         ;
var IDX_H_ITEM_NO         ;


function Init() {	//화면 초기설정 
	setGridDraw();
	setHeader();
<%
	if(FLAG != null && !FLAG.equals("")){
		if(FLAG.equals("P")){
%>
	//document.forms.form1.rfq_status.value = 'G'
<%
		}
	}
%>
	doSelect();
}

function setHeader() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	
	GridObj.strHDClickAction="sortmulti";
	
	IDX_SELECTED             = GridObj.GetColHDIndex("SELECTED");
	IDX_BIZ_NO               = GridObj.GetColHDIndex("BIZ_NO");
	IDX_BIZ_NM               = GridObj.GetColHDIndex("BIZ_NM");
	IDX_RFQ_NO               = GridObj.GetColHDIndex("RFQ_NO");
	IDX_RFQ_COUNT            = GridObj.GetColHDIndex("RFQ_COUNT");
	IDX_RFQ_SEQ              = GridObj.GetColHDIndex("RFQ_SEQ");
	IDX_RFQ_NM               = GridObj.GetColHDIndex("RFQ_NM");
	IDX_ITEM_NO              = GridObj.GetColHDIndex("ITEM_NO");
	IDX_ITEM_NM              = GridObj.GetColHDIndex("ITEM_NM");
	IDX_ITEM_CN              = GridObj.GetColHDIndex("ITEM_CN");
	IDX_MFCO_CODE            = GridObj.GetColHDIndex("MFCO_CODE");
	IDX_MFCO_NM              = GridObj.GetColHDIndex("MFCO_NM");
	IDX_RFQ_DATE             = GridObj.GetColHDIndex("RFQ_DATE");
	IDX_RFQ_CLOSE_DT         = GridObj.GetColHDIndex("RFQ_CLOSE_DT");
	IDX_RFQ_CLOSE_DATE       = GridObj.GetColHDIndex("RFQ_CLOSE_DATE");
	IDX_RFQ_CLOSE_TIME       = GridObj.GetColHDIndex("RFQ_CLOSE_TIME");
	IDX_RFQ_ID               = GridObj.GetColHDIndex("RFQ_ID");
	IDX_RFQ_NAME             = GridObj.GetColHDIndex("RFQ_NAME");
	IDX_VENDOR_CODE          = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME          = GridObj.GetColHDIndex("VENDOR_NAME");
	IDX_SUBMIT_USER_ID       = GridObj.GetColHDIndex("SUBMIT_USER_ID");
	IDX_SUBMIT_USER_NAME     = GridObj.GetColHDIndex("SUBMIT_USER_NAME");
	IDX_SUBMIT_DATE_TIME     = GridObj.GetColHDIndex("SUBMIT_DATE_TIME");
	IDX_SUBMIT_FLAG          = GridObj.GetColHDIndex("SUBMIT_FLAG");
	IDX_SUBMIT_FLAG_NAME     = GridObj.GetColHDIndex("SUBMIT_FLAG_NAME");
	IDX_QTA_NO               = GridObj.GetColHDIndex("QTA_NO");
	IDX_ATTACH_NO            = GridObj.GetColHDIndex("ATTACH_NO");
	IDX_ATTACH_CNT           = GridObj.GetColHDIndex("ATTACH_CNT");
	IDX_ATTACH_NO_H          = GridObj.GetColHDIndex("ATTACH_NO_H");
	IDX_CONFIRM_FLAG         = GridObj.GetColHDIndex("CONFIRM_FLAG");
	IDX_CONFIRM_REASON       = GridObj.GetColHDIndex("CONFIRM_REASON");	
	
	IDX_H_BIZ_NO          = GridObj.GetColHDIndex("H_BIZ_NO");	
	IDX_H_RFQ_NO          = GridObj.GetColHDIndex("H_RFQ_NO");	
	IDX_H_RFQ_COUNT       = GridObj.GetColHDIndex("H_RFQ_COUNT");	
	IDX_H_RFQ_SEQ         = GridObj.GetColHDIndex("H_RFQ_SEQ");	
	IDX_H_ITEM_NO         = GridObj.GetColHDIndex("H_ITEM_NO");		
}

function doSelect(){
	if(LRTrim(form1.start_change_date.value) == "" || LRTrim(form1.end_change_date.value) == "" ) {
		alert("요청일자를 입력하셔야 합니다.");
		
		return;
	}
	
	if(!checkDate(del_Slash(form1.start_change_date.value))) {
		alert("요청일자를 확인하세요.");
		
		form1.start_change_date.select();
		
		return;
	}
	
	if(!checkDate(del_Slash(form1.end_change_date.value))) {
		alert("요청일자를 확인하세요.");
		
		form1.end_change_date.select();
		
		return;
	}
	
	change_user = LRTrim(form1.ctrl_person_id.value);
	change_user = change_user.toUpperCase();
		
 	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getRfqList3&grid_col_id="+grid_col_id;
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.dt.rfq.rfq_bd_lis3";

	GridObj.post(url, param);
	GridObj.clearAll(false);	 
}

function start_change_date(year,month,day,week) {
	document.form1.start_change_date.value=year+month+day;
}

function end_change_date(year,month,day,week) {
	document.form1.end_change_date.value=year+month+day;
}    
	
function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "t_imagetext") { //견적요청번호 click
		rfq_no    = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
		rfq_count = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

		if(msg3 == IDX_RFQ_NO) {
			window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
		}
		
	}
	else if (msg1 == "t_insert") {
		rfd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_EXTENDS_DATE);
			
		if(msg3 == IDX_RFQ_EXTENDS_DATE) {
			if(rfd_date < eval("<%=SepoaDate.getShortDateString()%>") ) {
				alert("연장마감일은 현재날짜 이후여야 합니다."  );
				
				GD_SetCellValueIndex(GridObj,msg2, IDX_RFQ_EXTENDS_DATE, msg4);
			}	
		}
	}
	else if(msg1 == "doData") {
		if(mode == "setRfqDelete") {
			if("1" == GridObj.GetStatus()){
				doSelect();
			}
		}
	}
	else if(msg1 == "t_insert"){
		if(msg3==IDX_RFQ_EXTENDS_TIME){
			var regExp       = new RegExp("[0-2][0-9][0-6][0-9]");
			var regExp1      = new RegExp("[0-9]");
			var regExp2      = new RegExp(".*[:].*");
			var extendedTime = GridObj.GetCellValue("RFQ_EXTENDS_TIME", msg2);

			if(!regExp1.test(extendedTime) || regExp2.test(extendedTime)){
				alert("숫자만 입력 가능합니다.(ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
				
				return;
			}

			if(extendedTime.length != 4){
				alert("시간 형식에 맞게 입력 해주세요. (ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
				
				return;
			}

			if(!regExp.test(extendedTime) || Number(extendedTime) > 2359){
				alert("0000~2359 사이의 시간값을 입력 해주세요. (ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
			}
		}
	}
}

function PopupManager(part){
	var wise = GridObj;
	var url  = '';
	var title  = '';
	var param  = '';
	
	if(part == "ctrl_person_id") {
		//window.open("/common/CO_008_ict.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		url    = '/common/CO_008_ict.jsp';
		title  = '담당자조회';
	    param  = 'popup=Y';
		param  += '&callback=getCtrlUser';
		popUpOpen01(url, title, '450', '550', param);	
	}else if(part == "biz_no") {
		//window.open("/common/CO_017_ict.jsp?callback=getCtrlBiz", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		url    = '/common/CO_017_ict.jsp';
		title  = '사업명조회';
	    param  = 'popup=Y';
		param  += '&callback=getCtrlBiz';
		popUpOpen01(url, title, '450', '550', param);
	}
}

function getCtrlUser(code, text) {
	document.form1.ctrl_person_id.value = code;
	document.form1.ctrl_person_id_name.value = text;
}

function getCtrlBiz(code, text) {
	document.forms[0].biz_no.value = code;
    document.forms[0].biz_nm.value = text;
}

//지우기
function doRemove( type ){
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_id_name.value = "";
    }else if( type == "biz_no" ) {
    	document.forms[0].biz_no.value = "";
        document.forms[0].biz_nm.value = "";
    }    
}

/* 
function getAddUser(user_id, user_name, dept_name, position){
	document.form1.ctrl_person_id.value = user_id;
	document.form1.ctrl_person_id_name.value = user_name;
}
*/

//-->
</script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var rfq_no      = "";
	var rfq_count   = "";
	var rfq_seq     = "";
	var item_no     = "";
	var url         = "";
	
    h_rfq_no      = GD_GetCellValueIndex(GridObj,rowId-1, IDX_H_RFQ_NO);
    h_rfq_count   = GD_GetCellValueIndex(GridObj,rowId-1, IDX_H_RFQ_COUNT);
    h_rfq_seq     = GD_GetCellValueIndex(GridObj,rowId-1, IDX_H_RFQ_SEQ);	
    h_item_no     = GD_GetCellValueIndex(GridObj,rowId-1, IDX_H_ITEM_NO);
	
	if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
	    url = 'rfq_bd_dis01_ict.jsp?rfq_no=' + encodeUrl(h_rfq_no) + '&rfq_count=' + encodeUrl(h_rfq_count) + "&item_no=" + encodeUrl(h_item_no);
		popUpOpen(url, 'GridCellClick', '1024', '650');
	}else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
		var qta_no = GD_GetCellValueIndex(GridObj,rowId-1, IDX_QTA_NO);
		
		if(qta_no != null && qta_no != "") {
			url = '/ict/s_kr/bidding/rfq/rfq_bd_dis02_ict.jsp?rfq_no=' + encodeUrl(h_rfq_no) + '&rfq_count=' + encodeUrl(h_rfq_count) + '&rfq_seq=' + encodeUrl(h_rfq_seq) + "&item_no=" + encodeUrl(h_item_no);
			popUpOpen(url, 'GridCellClick', '1024', '650');	
		}
	}else if(cellInd == GridObj.getColIndexById("VENDOR_NAME")) {
    	var vendor_code = GD_GetCellValueIndex(GridObj,rowId-1, IDX_VENDOR_CODE);
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/ict/s_kr/admin/info/ven_bd_con_ict.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
    }else if(cellInd == GridObj.getColIndexById("ATTACH_NO")){
	   	 var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
		 
		 if(attach_no != ""){
			 var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	    	 var b = "fileDown";
	    	 var c = "300";
	    	 var d = "100";
	    	 
	    	 var win2 = window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
	    	 win2.focus();
		 }
	 }
	
}

function doOnMouseOver(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {}
    else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
        
        doSelect();
    }
    else{
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
    if(status == "0"){
    	alert(msg);
    }
    
    ////grid_rowspan("0-0,1-2,3-4,6-17","SELECTED,BIZ_NO,BIZ_NM,RFQ_NO,RFQ_COUNT,RFQ_NM,ITEM_NO,ITEM_NM,ITEM_CN,MFCO_CODE,MFCO_NM,RFQ_DATE,RFQ_CLOSE_DT,RFQ_CLOSE_DATE,RFQ_CLOSE_TIME,RFQ_ID,RFQ_NAME");   	
   	grid_rowspan("0-0,1-2,3-4,6-9,12-17","SELECTED,BIZ_NO,BIZ_NM,RFQ_NO,RFQ_COUNT,RFQ_NM,ITEM_NO,ITEM_NM,ITEM_CN,RFQ_DATE,RFQ_CLOSE_DT,RFQ_CLOSE_DATE,RFQ_CLOSE_TIME,RFQ_ID,RFQ_NAME");
    
    
   	if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

function grid_rowspan(col_num,col_name){
    var cnt = 0;
    var temp1 = "";
    var temp2 = "";
    var col_num_cnt = col_num.split(",");
    var col_name_cnt = col_name.split(",");
    var col_ids = new Array();

    for( var k = 0 ; k < col_name_cnt.length ; k++){
	col_ids.push(GridObj.getColIndexById(col_name_cnt[k]));
    } 
    for(var i = 1; i < dhtmlx_last_row_id+1; i++){
		cnt = 0;
		temp1 = "";

		for( var k = 0 ; k < col_ids.length ; k++){
			temp1 += (GridObj.cells(i, col_ids[k]).getValue());
		}

		if(temp1 == "") {
			continue;
		}

		//해당 필드의 똑같은 데이타를 가지고 있는 로우의 갯수를 셈.
		for(var j = i; j < dhtmlx_last_row_id+1; j++){
			temp2 = "";
			
			for( var k = 0 ; k < col_ids.length ; k++){
				temp2 += (GridObj.cells(j, col_ids[k]).getValue());
			}

			if(temp1 == temp2){
				cnt = cnt + 1;
			} else {
				break;
			}
			//alert("["+temp1 + "=" + temp2 + "] : " + cnt);
		}

		//그 row수만 큼 span. 
		for(var m = 0; m<col_num_cnt.length; m++){
			spld = col_num_cnt[m].split("-");
			start_num = Number(spld[0]);
			end_num = Number(spld[1]);
			for(var n = start_num; n <= end_num; n++){
				GridObj.setRowspan(i,n,cnt);// 줄 / 칸 / 갯수
			} 
		}

		i = i + cnt - 1;
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
<body onload="javascript:Init();"  bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">
		<input type="hidden" name="h_rfq_no">
		<input type="hidden" name="h_rfq_count">
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
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td class="data_td" colspan="3">
											<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="end_change_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>
										<%--
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
										<td class="data_td">
											<select id="rfq_status" name="rfq_status" class="inputsubmit">
		                        				<option value="" selected>
		                        					<b>전체</b>
                                				</option>
                                				<option value="B">견적중</option>
                                				<option value="E">견적마감</option>                                				
											</select>
										</td>
										--%>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명 / 사업번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="txt_biz_nm" id="biz_nm" size="20" class="input_data2" readonly >
											<a href="javascript:PopupManager('biz_no');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('biz_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>	
											<input type="text" name="txt_biz_no" id="biz_no" size="20" class="input_data2" readonly >											
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적담당자</td>
										<td class="data_td">											
											<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="20" style="ime-mode:inactive"  value="<%=info.getSession("ID")%>" class="inputsubmit"  onkeydown='entKeyDown()' >
											<a href="javascript:PopupManager('ctrl_person_id')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>																	
											<input type="text" id="ctrl_person_id_name" name="ctrl_person_id_name" size="25" class="input_data2" readonly value='<%=info.getSession("NAME_LOC")%>'  onkeydown='entKeyDown()' >
										</td>										
									</tr>		
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
									    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
										<td width="35%" class="data_td">
											<input type="text" id="rfq_no" name="rfq_no" style="width:95%;ime-mode:inactive;" class="inputsubmit" maxlength="20"  onkeydown='entKeyDown()' >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
										<td class="data_td">
											<input type="text" id="rfq_nm" name="rfq_nm" style="width:95%" class="inputsubmit" maxlength="20"  onkeydown='entKeyDown()'>
										</td>										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
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
						<TR></TR>
					</TABLE>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
							</TD>							
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<form name="form2" action="/kr/dt/rfq/rfq_bd_ins1.jsp" method="post">
		<!--견적요청 hidden-->
		<input type="hidden" name="dom_loi_flag" id="dom_loi_flag" value="">
	</form>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_RQ_447" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>