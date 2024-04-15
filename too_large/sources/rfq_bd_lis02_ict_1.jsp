<%--
    Title                            :          rfq_bd_lis2_ict.jsp  <p>
    Description                      :          견적진행현황 <p>
    @author                          :          변원상(2018.07.25)<p>
    @version                         :          1.0
    @Comment                         :          견적진행현황을 조회하는 화면이다.
    @SCREEN_ID                       :          I_SRQ_102
--%>
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
	multilang_id.addElement("I_SRQ_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SRQ_102";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	String WISEHUB_PROCESS_ID="I_SRQ_102";
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
var IDX_SEL            ;
var IDX_RFQ_STATUS     ;
var IDX_RFQ_STATUS_TEXT;
var IDX_RFQ_NO         ;
var IDX_RFQ_COUNT      ;
var IDX_RFQ_SEQ        ;
var IDX_QTA_NO         ;
var IDX_RFQ_NM         ;
var IDX_BIZ_NO         ;
var IDX_BIZ_NM         ;
var IDX_ITEM_NO        ;
var IDX_ITEM_NM        ;
var IDX_ITEM_CN        ;
var IDX_MFCO_CODE      ;
var IDX_MFCO_NM        ;
var IDX_RMK_TXT        ;
var IDX_RFQ_DATE       ;
var IDX_RFQ_CLOSE_DT   ;
var IDX_RFQ_CLOSE_DATE ;
var IDX_RFQ_CLOSE_TIME ;
var IDX_RFQ_ID         ;
var IDX_RFQ_NAME       ;
var IDX_VENDOR_CNT     ;
var IDX_BID_COUNT      ;

	
function Init() {	//화면 초기설정 
	setGridDraw();
	setHeader();
<%
	if(FLAG != null && !FLAG.equals("")){
		if(FLAG.equals("P")){
		}
	}
%>
	doSelect();
}

function setHeader() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	
	GridObj.strHDClickAction="sortmulti";
	
	IDX_SEL                              = GridObj.GetColHDIndex("SEL");
	IDX_RFQ_STATUS                       = GridObj.GetColHDIndex("RFQ_STATUS");
	IDX_RFQ_STATUS_TEXT                  = GridObj.GetColHDIndex("RFQ_STATUS_TEXT");
	IDX_RFQ_NO                           = GridObj.GetColHDIndex("RFQ_NO");
	IDX_RFQ_COUNT                        = GridObj.GetColHDIndex("RFQ_COUNT");
	IDX_RFQ_SEQ                          = GridObj.GetColHDIndex("RFQ_SEQ");
	IDX_QTA_NO                           = GridObj.GetColHDIndex("QTA_NO");
	IDX_RFQ_NM                           = GridObj.GetColHDIndex("RFQ_NM");
	IDX_BIZ_NO                           = GridObj.GetColHDIndex("BIZ_NO");
	IDX_BIZ_NM                           = GridObj.GetColHDIndex("BIZ_NM");
	IDX_ITEM_NO                          = GridObj.GetColHDIndex("ITEM_NO");
	IDX_ITEM_NM                          = GridObj.GetColHDIndex("ITEM_NM");
	IDX_ITEM_CN                          = GridObj.GetColHDIndex("ITEM_CN");
	IDX_MFCO_CODE                        = GridObj.GetColHDIndex("MFCO_CODE");
	IDX_MFCO_NM                          = GridObj.GetColHDIndex("MFCO_NM");
	IDX_RMK_TXT                          = GridObj.GetColHDIndex("RMK_TXT");
	IDX_RFQ_DATE                         = GridObj.GetColHDIndex("RFQ_DATE");
	IDX_RFQ_CLOSE_DT                     = GridObj.GetColHDIndex("RFQ_CLOSE_DT");
	IDX_RFQ_CLOSE_DATE                   = GridObj.GetColHDIndex("RFQ_CLOSE_DATE");
	IDX_RFQ_CLOSE_TIME                   = GridObj.GetColHDIndex("RFQ_CLOSE_TIME");
	IDX_RFQ_ID                           = GridObj.GetColHDIndex("RFQ_ID");
	IDX_RFQ_NAME                         = GridObj.GetColHDIndex("RFQ_NAME");
	IDX_VENDOR_CNT                       = GridObj.GetColHDIndex("VENDOR_CNT");
	IDX_BID_COUNT                        = GridObj.GetColHDIndex("BID_COUNT");
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
	
 	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getQtaProList&grid_col_id="+grid_col_id;
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.supply.bidding.rfq.rfq_bd_lis1";
	
	GridObj.post(url, param);
	GridObj.clearAll(false);	 
}

function setRfqSubmit(){
	checked_count = 0;
	rowcount      = GridObj.GetRowCount();
	rfq_no        = "";
	rfq_count     = "";
	rfq_seq       = "";
	item_no       = "";
       	
	var rfq_state = "write";
	var rfq_status = "";

	for(row=rowcount-1; row>=0; row--){
		if( true != GD_GetCellValueIndex(GridObj,row, IDX_SEL)){
			continue;
		}
			
		checked_count++;
		
		if( GD_GetCellValueIndex(GridObj,row, IDX_RFQ_STATUS) != "B" ) { // 진행상태에 따라 견적 수정불가(작성중)
			alert("진행상태가 [견적중] 인 경우에만 제출이 가능합니다.");
		
			return;
		}
		
		/*
		if( GD_GetCellValueIndex(GridObj,row, IDX_RFQ_FLAG) != "T" ) { // 진행상태에 따라 견적 수정불가(작성중)
			alert("진행상태가 [작성중] 인 경우에만 수정이 가능합니다.");
		
			return;
		}
			
		if("0" != GD_GetCellValueIndex(GridObj,row, IDX_BID_COUNT)) { // 견적서를 제출한 업체가 있는 경우 수정불가
			alert("견적서를 제출한 업체가 있는 경우 수정할 수 없습니다.");
		
			return;
		}
		*/
		
		rfq_no      = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_NO);
		rfq_count   = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_COUNT);
		rfq_seq     = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_SEQ);
		item_no     = GD_GetCellValueIndex(GridObj,row, IDX_ITEM_NO);		
	}
	
	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(checked_count > 1)  {
		alert(G_MSS2_SELECT);
		
		return;
	}
	
	var REDIRECT = "new";
    var url="/ict/s_kr/bidding/rfq/rfq_bd_upd01_ict.jsp?flag=Y&rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&rfq_seq=" + rfq_seq + "&item_no=" + item_no;	
	
    document.location = url;
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
		}else if(msg3 == IDX_ANNOUNCE_DATE) {
			ivalue     = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_ANNOUNCE_DATE));
			ITEM_COUNT = GD_GetCellValueIndex(GridObj,msg2, IDX_ITEM_CNT);

			if(ivalue  == "Y") {
				window.open("rfq_pp_dis5.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&count=" + ITEM_COUNT,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=350,left=0,top=0")
			}
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
	var url  = "";
	
	if(part == "biz_no") {
		//window.open("/common/CO_017_ict.jsp?callback=getCtrlBiz", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		
		url    = '/common/CO_017_ict.jsp';
		var title  = '사업명조회';
		var param  = 'popup=Y';
		param     += '&callback=getCtrlBiz';
		popUpOpen01(url, title, '450', '550', param);	
		
	}
}

function getCtrlBiz(code, text) {
	document.forms[0].biz_no.value = code;
    document.forms[0].biz_nm.value = text;
}

//지우기
function doRemove( type ){
    if( type == "biz_no" ) {
    	document.forms[0].biz_no.value = "";
        document.forms[0].biz_nm.value = "";
    }    
}
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
	var rfqType    = "";
	var rfqNo      = "";
	var rfqCount   = "";
	var url        = "";
	var vendorType = "";

    rfq_no      = GD_GetCellValueIndex(GridObj,rowId-1, IDX_RFQ_NO);
	rfq_count   = GD_GetCellValueIndex(GridObj,rowId-1, IDX_RFQ_COUNT);
	rfq_seq     = GD_GetCellValueIndex(GridObj,rowId-1, IDX_RFQ_SEQ);
	
	item_no     = GD_GetCellValueIndex(GridObj,rowId-1, IDX_ITEM_NO);	
    
	if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
	    url = 'rfq_bd_dis01_ict.jsp?rfq_no=' + encodeUrl(rfq_no) + '&rfq_count=' + encodeUrl(rfq_count) + "&item_no=" + encodeUrl(item_no);
		popUpOpen(url, 'GridCellClick', '1024', '650');
	}
	else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
	    url = 'rfq_bd_dis02_ict.jsp?rfq_no=' + encodeUrl(rfq_no) + '&rfq_count=' + encodeUrl(rfq_count) + '&rfq_seq=' + encodeUrl(rfq_seq) + "&item_no=" + encodeUrl(item_no);
		popUpOpen(url, 'GridCellClick', '1024', '650');
	}
	else if(cellInd == GridObj.getColIndexById("VENDOR_CNT")) {	//지정업체수
	    url = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true'; 	    
    	popUpOpen(url, 'GridCellClick', '650', '350');
    }
	else if(cellInd == GridObj.getColIndexById("BID_COUNT")) {	//제안업체수
		url      = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '650', '350');
	}
	else if(cellInd == GridObj.getColIndexById("RFQ_GIVEUP_CNT")) {		//견적포기수
		url      = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true';		
		popUpOpen(url, 'GridCellClick', '650', '350');
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
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
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
										<td class="data_td">
											<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="end_change_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>
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
										
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
									    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명 / 사업번호</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="txt_biz_nm" id="biz_nm" size="20">
											<a href="javascript:PopupManager('biz_no');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('biz_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>	
											<input type="text" name="txt_biz_no" id="biz_no" size="20">											
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
										<td width="35%" class="data_td">
											<input type="text" id="subject" name="subject" style="width:95%" class="inputsubmit" maxlength="20"  onkeydown='entKeyDown()'>
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
							<TD>
<script language="javascript">
btn("javascript:setRfqSubmit()","견적서 (수정)");
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
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SRQ_102" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>