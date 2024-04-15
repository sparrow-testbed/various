<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
    String flag	          = JSPUtil.nullToRef(request.getParameter("flag"),"");
    String rfq_no	      = JSPUtil.nullToRef(request.getParameter("rfq_no"),"");
	String rfq_count	  = JSPUtil.nullToRef(request.getParameter("rfq_count"),"");
	String rfq_seq   	  = JSPUtil.nullToRef(request.getParameter("rfq_seq"),"");
	
	String biz_no         = JSPUtil.nullToRef(request.getParameter("txt_biz_no"),"");
	String biz_nm         = JSPUtil.nullToRef(request.getParameter("txt_biz_nm"),"");
	String rfq_nm         = JSPUtil.nullToRef(request.getParameter("txt_rfq_nm"),"");
	String item_no        = JSPUtil.nullToRef(request.getParameter("sel_item_no"),request.getParameter("item_no"));
	String mfco_code      = "";	
	String item_cn        = JSPUtil.nullToRef(request.getParameter("txt_item_cn"),"");	
	String rfq_close_date = JSPUtil.nullToRef(request.getParameter("rfq_close_date"),SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), 1)));
	String szTime         = JSPUtil.nullToRef(request.getParameter("szTime"),"23");
	String szMin          = JSPUtil.nullToRef(request.getParameter("szMin"),"00");	
	String rfq_id         = JSPUtil.nullToRef(request.getParameter("txt_rfq_id"),info.getSession("ID"));
	String rfq_name       = JSPUtil.nullToRef(request.getParameter("txt_rfq_name"),info.getSession("NAME_LOC"));	
	String rmk_txt        = JSPUtil.nullToRef(request.getParameter("txt_rmk_txt"),"");


	Vector multilang_id = new Vector();
	multilang_id.addElement("I_RQ_50"+item_no);	
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_RQ_50"+item_no;
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	

 	String WISEHUB_PROCESS_ID="I_RQ_50"+item_no;
	
	boolean sign_use_yn = false;
	
	
	Object[] obj = {rfq_no, rfq_count, rfq_seq};
	SepoaOut value = ServiceConnector.doService(info, "I_s2011", "CONNECTION", "getRfqHDDisplay", obj);
	
	String RFQ_NM            = "";
	String BIZ_NO            = "";
	String BIZ_NM            = "";
	String STATUS            = "";
	String RFQ_STATUS        = "";
	String ITEM_NO           = "";
	String ITEM_NM           = "";
	String ITEM_CN           = "";
	String MFCO_CODE         = "";
	String MFCO_NM           = "";
	String RFQ_DATE          = "";
	String RFQ_CLOSE_DATE    = "";
	String SZTIME            = "";
	String SZMIN             = "";
	String RMK_TXT           = "";
	String RFQ_ID            = "";
	String RFQ_NAME          = "";
	String VENDOR_CNT        = "0";
	String VENDOR_INFO       = "";
	String VENDOR_VALUES     = "";
	String MDL_ID            = "";
	String MDL_NM            = "";
	String ATTACH_NO         = "";
	String ATTACH_CNT        = "0";
    String QTA_NO            = "";
    String CONFIRM_FLAG      = "";
    String CONFIRM_REASON    = "";
    String VENDOR_CODE       = "";
    String VENDOR_NAME       = "";
    
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이?린? 있는 경우

			RFQ_NM            =  wf.getValue("RFQ_NM", 0);
			BIZ_NO            =  wf.getValue("BIZ_NO", 0);
			BIZ_NM            =  wf.getValue("BIZ_NM", 0);
			STATUS            =  wf.getValue("STATUS", 0);
			RFQ_STATUS        =  wf.getValue("RFQ_STATUS", 0);
			ITEM_NO           =  wf.getValue("ITEM_NO", 0);
			ITEM_NM           =  wf.getValue("ITEM_NM", 0);
			ITEM_CN           =  wf.getValue("ITEM_CN", 0);
			MFCO_CODE         =  wf.getValue("MFCO_CODE", 0);
			MFCO_NM           =  wf.getValue("MFCO_NM", 0);
			RFQ_DATE          =  wf.getValue("RFQ_DATE", 0);
			RFQ_CLOSE_DATE    =  wf.getValue("RFQ_CLOSE_DATE", 0);
			SZTIME            =  wf.getValue("SZTIME", 0);
			SZMIN             =  wf.getValue("SZMIN", 0);
			RMK_TXT           =  wf.getValue("RMK_TXT", 0);
			RFQ_ID            =  wf.getValue("RFQ_ID", 0);
			RFQ_NAME          =  wf.getValue("RFQ_NAME", 0);
			VENDOR_CNT        =  wf.getValue("VENDOR_CNT", 0);
			VENDOR_INFO       =  wf.getValue("VENDOR_INFO", 0);	
			
			VENDOR_VALUES     = "";
			String strTemp = JSPUtil.nullToEmpty(VENDOR_INFO.replaceAll ( "&#64;" , "@" ));
			String[] arrayVENDOR_CODE = SepoaString.parser( strTemp, "#" );
            for( int j = 0; j < arrayVENDOR_CODE.length; j++ ) {
            	VENDOR_VALUES += arrayVENDOR_CODE[j].substring(0,5) + "@";
            }
            
            MDL_ID            = wf.getValue("MDL_ID", 0);	
            MDL_NM            = wf.getValue("MDL_NM", 0);	
            ATTACH_NO         = wf.getValue("ATTACH_NO", 0);
            ATTACH_CNT        = wf.getValue("ATTACH_CNT", 0);
            QTA_NO            = wf.getValue("QTA_NO", 0);	
            
            CONFIRM_FLAG      = wf.getValue("CONFIRM_FLAG", 0);
            CONFIRM_REASON    = wf.getValue("CONFIRM_REASON", 0);
            
            VENDOR_CODE       = wf.getValue("VENDOR_CODE", 0);
            VENDOR_NAME       = wf.getValue("VENDOR_NAME", 0);            
		}
	}



%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
function Init() {	//화면 초기설정 
	setGridDraw();
	setHeader();
	doSelect();
	<% if("R".equals(CONFIRM_FLAG)){ %>
		alert("<%=CONFIRM_REASON%>");
	<% } %>	
}	

function  setBIZNO(biz_no, biz_nm) {
    document.forms[0].txt_biz_no.value = biz_no;
    document.forms[0].txt_biz_nm.value = biz_nm;
}

function getBIZ_pop() {
    var url = "/ict/kr/dt/rfq/rfq_bzNo_pop_main.jsp";
    Code_Search(url,'사업명','0','0','500','500');
    
    //url, title, left, top, width, height
}

var Arow = 0;

var mode									;
var Current_Row								;
var poprow									;

function setHeader() {
	GridObj.bHDMoving 			= false;
	GridObj.bHDSwapping 		= false;
	GridObj.bRowSelectorVisible = false;
	GridObj.strRowBorderStyle 	= "none";
	GridObj.nRowSpacing 		= 0 ;
	GridObj.strHDClickAction 	= "select";
	GridObj.nHDLineSize  		= 40; 
			
	pre_Insert();
	
	GridObj.strHDClickAction="sortmulti";
}

function doSelect() {
	
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.dt.rfq.rfq_bd_upd1";

	<%-- GridObj.SetParam("mode", "getRfqDTDisplay");
	GridObj.SetParam("rfq_no", "<%=rfq_no%>");
	GridObj.SetParam("rfq_count", "<%=rfq_count%>");

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl);  --%>
	
	var grid_col_id = "<%=grid_col_id%>";
	var params   = "mode=getRfqDTDisplay";
	params += "&grid_col_id=" + grid_col_id;
	params += dataOutput();
	GridObj.post(servletUrl, params);
	GridObj.clearAll(false);
}

function checkData() {
	rowcount = GridObj.GetRowCount();
	checked_count = 0;
	
	return true;
}

function fnFormInputSet(inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	return input;
}

/**
 * 동적 form을 생성하여 반환하는 메소드
 *
 * @param url
 * @param param
 * @param target
 * @return form
 */
function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");	
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}
	
	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		var input = fnFormInputSet(paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}
	
	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function pre_Insert() {
	document.form1.attach_count.value = '';
}

function POPUP_Open(url, title, left, top, width, height) {
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = 'yes';
	var resizable = 'no';
	var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	code_search.focus();
}

function sel_item_no_Changed()
{
    form1.sel_mfco_code.length = 1;
    var id = "SL0019";
    var code = "M680_ICT";
    var value = form1.sel_item_no.value;
    target = "MFCO_TYPE";
    data = "/ict/kr/dt/rfq/mfco_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    childframe.location.href = data;
}

function setMFCO_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.sel_mfco_code.options[form1.sel_mfco_code.length] = option1;
}

function PopupManager(part)
{
	if(part == "rfq_id"){
		window.open("/common/CO_008_ict.jsp?callback=getConUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
}

//지우기
function doRemove( type ){
	if( type == "rfq_id" ) {
		document.form1.txt_rfq_id.value = "";
		document.form1.txt_rfq_name.value = "";
	}  
}

function getConUser(code, text){
	document.form1.txt_rfq_id.value = code;
	document.form1.txt_rfq_name.value = text;
}

function openPopup(szRow, mode,SG_REFITEM) {
	var url = "rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SG_REFITEM="+SG_REFITEM;
	window.open(url, "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
}

function rfq_close_date(year,month,day,week) {
	document.form1.rfq_close_date.value=year+month+day;
}

function checkMin(sFilter) {
	var sKey = String.fromCharCode(event.keyCode);
	var re = new RegExp(sFilter);

	// Enter는 키검사를 하지 않는다.
	if(sKey != "\r" && !re.test(sKey)) {
		event.returnValue = false;
	}

	if (form1.szMin.value.length == 0) {
		if (parseInt(sKey) > 5){
			event.returnValue = false;
		}
	}
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery"){
		
		//전체 선택
		selectAll();
		
	}
	
	if(msg1 == "t_imagetext") {
	}
	else if(msg1 == "doData") { // 전송/저장시 Row삭제
		opener.doSelect();
		window.close();
	}
	else if(msg1 == "t_insert") { //
		if(msg3 == INDEX_RD_DATE) {
			se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
			var  rfq_close_date_val = form1.rfq_close_date.value;			
			if(rfq_close_date_val == "") {
				alert("견적마감일을 먼저 입력하세요");				
				return;
			}
			
			if(!checkDateCommon(form1.rfq_close_date.value)){
				document.forms[0].rfq_close_date.select();				
				alert("견적마감일을 확인하세요.");				
				return;
			}
		}
	}
	else if(msg1 == "t_header") {
		if(msg3 == INDEX_RD_DATE) {
			copyCell(GridObj, INDEX_RD_DATE, "t_date");
		}
	}
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	<% if("1".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,Disk 타입,용량,수량,Type,포트수,카드수량,Type,포트수,카드수량,#rspan,#rspan");
	<% }else if("2".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,구성여부,파티션갯수,#rspan,#rspan,Disk타입,용량,수량,Type,포트수,카드수량,Type,포트수,카드수량,#rspan,#rspan");
	<% }else if("3".equals(item_no)){ %>
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,타입,용량,#rspan,#rspan,포트Type,포트수,#rspan");	
	<% } %>
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
   
}

function changeMoney(mon)
{
	var money = del_comma(mon);

	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		alert("숫자로 입력하세요");
		
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");		
		return false;
	}
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function doOnCellChange(stage,rowId,cellInd){
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

    alert(messsage);
    
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

/* 파일 업로드 */
/* function goAttach(attach_no){
	attach_file(attach_no,"RFQ");
} */
/* function setAttach(attach_key, arrAttrach, attach_count) {
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
}
 */
/* 
function setAttach(attach_key, arrAttrach, attach_count) {

	if(document.form1.attach_gubun.value == "wise"){
		//alert(Arow+"|"+attach_key+"|"+attach_count);
		GridObj.cells(Arow, INDEX_ATTACH_NO).setValue(attach_key);
		GridObj.cells(Arow, INDEX_ATTACH_NO_CNT).setValue(attach_count);
		
//		GD_SetCellValueIndex(document.WiseGrid,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO, attach_key);
		//GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO_CNT, attach_count);
		
	} else {
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;
	}
	document.form1.attach_gubun.value="body";

} */
 
 var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
 function selectAll(){
		if(selectAllFlag == 0)
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
			}
			selectAllFlag = 1;
		}
		else
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			}
		}
	}
 	function setApprovalButton(attach_count){
 		try{
			if(attach_count>0){
				document.getElementById("approvalButton1").style.display = "";
				document.getElementById("approvalButton2").style.display = "none";
			}else{
				document.getElementById("approvalButton1").style.display = "none";     
				document.getElementById("approvalButton2").style.display = "";
			}
 		}catch(e){
 			
 		}
 	}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header popup="true">
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">견적서</td>
			<TD align="right" >
							<script language="javascript">
								btn("javascript:window.close()", "닫 기");
							</script>
						</TD>
		</tr>
	</table>
	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>	

	<form name="form1" id="form1" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
		<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" id="doc_type" value="RQ">
		<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>
		
		<input type="hidden" id="vendor_count" name="vendor_count" value="<%=VENDOR_CNT%>">
		<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>"> 
	    <input type="hidden" name="vendor_info"     id="vendor_info"    value="<%=VENDOR_INFO%>">
		<input type="hidden" id="vendor_each_flag" 	name="vendor_each_flag">
		<input type="hidden" name="seller_change_flag" 	id="seller_change_flag" value= "Y"><!-- 업체선택여부 -->
		<input type="hidden" id="seller_cnt" 		name="seller_cnt" value="<%=VENDOR_CNT%>">
		<input type="hidden" id="seller_choice" 	name="seller_choice">
		
		
		<input type="hidden" name="rfq_no" id="rfq_no" value="<%=rfq_no%>">
		<input type="hidden" name="rfq_count" id="rfq_count" value="<%=rfq_count%>">
		<input type="hidden" name="szdate" id="szdate">
		<input type="hidden" name="dely_text" id="dely_text">
		<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
		<input type="hidden" name="rfq_status" id="rfq_status" value="">		
		<input type="hidden" name="sign_status" id="sign_status" value="">
		
		<input type="hidden" name="att_mode" id="att_mode"  value="">
		<input type="hidden" name="view_type" id="view_type"  value="">
		<input type="hidden" name="file_type" id="file_type"  value="">
		<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
		<input type="hidden" name="attach_count" id="attach_count" value="">
		<input type="hidden" name="approval_str" id="approval_str" value="">
		

<table width="100%" border="0" cellspacing="0" cellpadding="1" >
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
		<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		   <tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적서번호</td>
				<td width="35%" class="data_td">
				    <%=QTA_NO%>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적업체</font>
				</td>
				<td width="35%" class="data_td">
					<%=VENDOR_NAME%> (<%=VENDOR_CODE%>)
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
					 모델번호
				</td>
				<td width="35%" class="data_td">
					<%=MDL_ID%>					
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
					 모델명
				</td>
				<td width="35%" class="data_td">
					<%=MDL_NM%>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
					첨부파일
				</td>
				<td width="35%" class="data_td">
					<table><tr></tr><td>
					<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
					<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width:350px; height: 50px; border: 0px;" frameborder="0" ></iframe>
					</td></table>
				</td>
				<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
				<td width="35%"  class="data_td">
					<%=MFCO_NM%>
				</td>	
			</tr>
		</table>
	</td>
</tr>
</table>
</td>
</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
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
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명</td>
				<td width="35%" class="data_td">
					<%=BIZ_NM%> (<%=BIZ_NO%>)					
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
				<td width="35%" class="data_td">
					<%=RFQ_NM%>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
				<td width="35%"  class="data_td">
					<%=rfq_no%>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
				<td width="35%"  class="data_td"><%=rfq_count%>
				</td>
			</tr>			
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적품목</td>
				<td class="data_td">
				    <%=ITEM_NM%>
					<select name="sel_item_no" id="sel_item_no" style="ime-mode:disabled;display:none;" disabled readonly class="inputsubmit">
									<option value="">선택</option>
<%
	String  lb_item_no = ListBox(request, "SL0019",info.getSession("HOUSE_CODE") + "#" + "M680_ICT" + "#" + "0", ITEM_NO);
	out.println(lb_item_no);
%>
					</select>
				</td>
				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수량</td>
				<td class="data_td">
				   <%=ITEM_CN%>
				</td>
			</tr>											
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일</td>
				<td width="35%" class="data_td">
				    <%=RFQ_CLOSE_DATE%> <%=SZTIME%>시 <%=SZMIN%>분
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적담당자</td>
				<td width="85%" class="data_td" colspan=3>
				    <%=RFQ_NAME%> (<%=RFQ_ID%>)
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비고</td>
				<td class="data_td" colspan="3" height="150px">
					<table width="98%" >
						<tr>
							<td>
							    <pre><%=RMK_TXT%></pre>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</td>
</tr>
</table>		
	</form>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>

<s:footer/>
</body>
</html>