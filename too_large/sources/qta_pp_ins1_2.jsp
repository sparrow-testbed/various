
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_246_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_246_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
 
	String WISEHUB_PROCESS_ID 	= "RQ_246_2";
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
<%
String house_code = info.getSession("HOUSE_CODE");
String company_code = info.getSession("COMPANY_CODE");

String vendor_code  		= JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
String rfq_no       		= JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
String rfq_count    		= JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
String settle_type       	= JSPUtil.nullToEmpty(request.getParameter("settle_type"));
String req_type       		= JSPUtil.nullToEmpty(request.getParameter("req_type"));
%>

<script language="javascript" type="text/javascript">
<!--
var s_m_item_no;
var s_m_RFQ_SEQ;
var G_Pos= -1;

var s_rfq_no;
var s_rfq_count;
var s_VendorCode;
var s_flag;

var s_seq;

var mode;
var shipping_method;

var INDEX_SELECTED                ;
var INDEX_ITEM_NO                 ;
var INDEX_DESCRIPTION_LOC         ;
var INDEX_SPECIFICATION           ;
var INDEX_ITEM_QTY                ;
var INDEX_UNIT_MEASURE            ;
var INDEX_F_UNIT_PRICE            ;
var INDEX_UNIT_PRICE              ;
var INDEX_ITEM_AMT                ;
var INDEX_F_MOLDING_CHARGE        ;
var INDEX_MOLDING_CHARGE          ;
var INDEX_COST_COUNT              ;
var INDEX_DELIVERY_LT             ;
var INDEX_PURCHASE_LOCATION       ;
var INDEX_AUTO_PO_FLAG            ;
var INDEX_CONTRACT_FLAG           ;
var INDEX_PR_NO                   ;
var INDEX_PR_SEQ                  ;
var INDEX_RFQ_SEQ                 ;
var INDEX_SHIPPER_TYPE            ;
var INDEX_QTA_NO                  ;
var INDEX_QTA_SEQ                 ;
var INDEX_VENDOR_CODE             ;
var INDEX_MOLDING_TYPE 			;
var INDEX_CUSTOMER_PRICE		;
var INDEX_CUSTOMER_AMT			;
var INDEX_SUPPLY_PRICE			;
var INDEX_SUPPLY_AMT			;
var INDEX_DISCOUNT				;


function Init()
{
	setGridDraw();
	setHeader();
	doSelect();
}


function setHeader() {
	/* GridObj.bHDMoving 			= false;
	GridObj.bHDSwapping 			= false;
	GridObj.bRowSelectorVisible 	= false;
	GridObj.strRowBorderStyle 	= "none";
	GridObj.nRowSpacing 			= 0 ;
	GridObj.strHDClickAction 		= "select";
	GridObj.nHDLineSize  = 32; */
		
	

	INDEX_SELECTED                = GridObj.GetColHDIndex("SELECTED");
	INDEX_ITEM_NO                 = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_DESCRIPTION_LOC         = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_SPECIFICATION           = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_ITEM_QTY                = GridObj.GetColHDIndex("ITEM_QTY");
	INDEX_UNIT_MEASURE            = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_F_UNIT_PRICE            = GridObj.GetColHDIndex("F_UNIT_PRICE");
	INDEX_ITEM_AMT                = GridObj.GetColHDIndex("ITEM_AMT");
	INDEX_F_MOLDING_CHARGE        = GridObj.GetColHDIndex("F_MOLDING_CHARGE");
	INDEX_MOLDING_CHARGE          = GridObj.GetColHDIndex("MOLDING_CHARGE");
	INDEX_COST_COUNT              = GridObj.GetColHDIndex("COST_COUNT");
	INDEX_DELIVERY_LT             = GridObj.GetColHDIndex("DELIVERY_LT");
	INDEX_PURCHASE_LOCATION       = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	INDEX_AUTO_PO_FLAG            = GridObj.GetColHDIndex("AUTO_PO_FLAG");
	INDEX_CONTRACT_FLAG           = GridObj.GetColHDIndex("CONTRACT_FLAG");
	INDEX_PR_NO                   = GridObj.GetColHDIndex("PR_NO");
	INDEX_PR_SEQ                  = GridObj.GetColHDIndex("PR_SEQ");
	INDEX_RFQ_SEQ                 = GridObj.GetColHDIndex("RFQ_SEQ");
	INDEX_SHIPPER_TYPE            = GridObj.GetColHDIndex("SHIPPER_TYPE");
	INDEX_QTA_NO                  = GridObj.GetColHDIndex("QTA_NO");
	INDEX_QTA_SEQ                 = GridObj.GetColHDIndex("QTA_SEQ");
	INDEX_VENDOR_CODE             = GridObj.GetColHDIndex("VENDOR_CODE");
	INDEX_MOLDING_TYPE            = GridObj.GetColHDIndex("MOLDING_TYPE");
	INDEX_CUSTOMER_PRICE        = GridObj.GetColHDIndex("CUSTOMER_PRICE" );
	INDEX_CUSTOMER_AMT        	= GridObj.GetColHDIndex("CUSTOMER_AMT" );
	INDEX_SUPPLY_PRICE          = GridObj.GetColHDIndex("SUPPLY_PRICE" );
	INDEX_SUPPLY_AMT          	= GridObj.GetColHDIndex("SUPPLY_AMT" );
	INDEX_DISCOUNT				= GridObj.GetColHDIndex("DISCOUNT" );
	INDEX_ATTACH_NO				= GridObj.GetColHDIndex("ATTACH_NO" );


}

function doSelect() {
	form1.rfq_no.value = "<%=rfq_no%>";
	form1.rfq_count.value = "<%=rfq_count%>";
	form1.vendor_code.value = "<%=vendor_code%>";

    G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_pp_ins1_2";

	<%-- GridObj.SetParam("mode", "getDocBaseQtaCompareDT");

	GridObj.SetParam("rfq_no", "<%=rfq_no%>");
	GridObj.SetParam("rfq_count", "<%=rfq_count%>");
	GridObj.SetParam("vendor_code", "<%=vendor_code%>");

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl); --%>
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getDocBaseQtaCompareDT";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
	
}

function doSave() {
	if(0 == GridObj.GetRowCount()) {
		return;
	}

	var chk = parent.topFrame.nego_amt_data();
	
	
	if( chk == false ) {
		if( !confirm("선정하신 업체가 최저단가제시업체가 아닙니다. 진행하시겠습니까?") ){
			return;
		}
		else{
			if(parent.topFrame.remarkData() == "") {
				alert("선정사유를 입력하세요.");
				return;
			}else{
				document.getElementById("remark").value = parent.topFrame.remarkData();
			}
		}
	}
	else {
		if( !confirm("업체선정 하시겠습니까?") ){
			return;
		}
	}


	G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_pp_ins1_2";

	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setDocTotalSave";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	
	
}

function reset_bill() {
	var req_type = "<%=req_type%>";
	
	if(req_type=="M"){
		alert("메뉴얼 견적은 구매복구 되지 않습니다.");
	
		return;
	}

	Message = "구매복구 하시겠습니까?";

	if(!confirm(Message)) {
		return;
	}

	// 구매복구 사유입력창
	var url = "/kr/confirm_pp_dis.jsp?mode=update&function=go_reset_bill&title=구매복구사유&column=sr_reason&maxByte=4000&useAttach=Y&attach_no="+document.forms[0].sr_attach_no.value;
	var left = 150;
	var top = 150;
	var width = 680;
	var height = 480;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'yes';
	var resizable = 'no';
	var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	
	ReasonWin.focus();
}

function go_reset_bill(value, row, att_no){
	document.forms[0].sr_reason.value    = value;
	document.forms[0].sr_attach_no.value = att_no;

	//mode = "setReturnToPR_DOC_ALL";
<%-- 	servletUrl =  "<%=getWiseServletPath("dt.rfq.qta_pp_ins1_2")%>"; --%>
    G_SERVLETURL =  "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_pp_ins1_2";

	rfq_no = form1.rfq_no.value;
	rfq_count = form1.rfq_count.value;

	if(GridObj.GetRowCount() == 0) {
		alert("업체를 선택하세요");
		
		return;
	}
	
/* 	GridObj.SetParam("mode"			, "setReturnToPR_DOC_ALL");
	GridObj.SetParam("rfq_no"			, rfq_no);
	GridObj.SetParam("rfq_count"		, rfq_count);
	GridObj.SetParam("sr_reason"		, document.forms[0].sr_reason.value);
	GridObj.SetParam("sr_attach_no"	, document.forms[0].sr_attach_no.value);
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(servletUrl, "ALL", "ALL"); // PR_NO, PR_SEQ */

	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setReturnToPR_DOC_ALL";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	
}

function setData(selected_flag) {
	if(selected_flag == "detail") {
		document.forms[0].seq.value             = s_seq;
		document.forms[0].item_no.value   = s_m_item_no;
		document.forms[0].rfq_no.value          = s_rfq_no;
		document.forms[0].rfq_count.value       = s_rfq_count;
		document.forms[0].VendorCode.value      = s_VendorCode;
		document.forms[0].flag.value            = "DOC";

		win = window.open('', 'detailSetup','toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=no,resizable=0,copyhistory=0,width=640,height=400')
		
		document.forms[0].target = 'detailSetup'
		document.forms[0].action = 'qta_pp_ins4_frame.jsp';
		document.forms[0].submit();
	}
	else if(selected_flag == "") {}
}

function doClose(reload_flag) {
	if(reload_flag == "Y") {
		top.opener.doSelect();
	}

	top.window.close();
}

function getBuyer_Item_Index(Buyer_ItemNO) {
	index = -1;
	
	for(i=0; i<GridObj.GetRowCount(); i++) {
		item_no = GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_NO);

		if(item_no == Buyer_ItemNO) {
			index = i;
			
			break;
		}
	}

	return index;
}

function getRFQ_SEQ_Index(rfq_seq){
	index = -1;
	
	for(i=0; i<GridObj.GetRowCount(); i++){
		RFQ_SEQ = GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_SEQ);

		if(RFQ_SEQ == rfq_seq){
			index = i;
			
			break;
		}
	}

	return index;
}

function removeAll() {
	if(GridObj.GetRowCount() > 0){
		GridObj.RemoveAllData();
	}
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

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery") {
		var maxRow = GridObj.GetRowCount();
		var customer_unitPrice = 0;
		var itemQty = 0;
		
		selectAll();	
		
		for(i=0; i<maxRow; i++) {
			//GD_SetCellValueIndex(GridObj, i, INDEX_SELECTED, true);
        	
			customer_unitPrice = GD_GetCellValueIndex(GridObj, i, INDEX_CUSTOMER_PRICE);

			itemQty = GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_QTY);
			var tmp_amt = eval(customer_unitPrice) * eval(itemQty);
			GD_SetCellValueIndex(GridObj, i, INDEX_CUSTOMER_AMT, setAmt(tmp_amt)+""); 
		}
		
		// 컬럼 그룹
		//GridObj.SetGroupMerge("CUSTOMER_PRICE,CUSTOMER_AMT,SUPPLY_PRICE,SUPPLY_AMT");
	}

	if(msg1 == "doData") {
		if(mode == "setReturnToPR_DOC_ALL") {
			alert(GD_GetParam(GridObj,0));

			if("1" == GridObj.GetStatus()) {
				doClose('Y');
			}
		}
		else if(mode == "setDocTotalSave") {
			alert(GD_GetParam(GridObj,0));

			if("1" == GridObj.GetStatus()) {
				doClose('Y');
			}
		}
	}

	if(msg1 == "t_imagetext") {
		if(msg3 == INDEX_ITEM_NO) { //품목번호
			var item_no = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
		
			POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+item_no, "품목_일반정보", '0', '0', '800', '400');
		}

		if(msg3 == INDEX_COST_COUNT){
			var PRICE_DOC_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_COST_COUNT));
			var wt = GridObj;

			var RFQ_NO      = document.forms[0].rfq_no.value;
			var RFQ_COUNT   = document.forms[0].rfq_count.value;
			var RFQ_SEQ     = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_SEQ);
			var VENDOR_CODE = document.forms[0].vendor_code.value;

			G_Pos = msg2;

			if("0" != PRICE_DOC_VALUE) {
				window.open('qta_pp_dis7.jsp?XPosition='+ msg2 + '&RFQ_NO=' + RFQ_NO + '&RFQ_COUNT=' + RFQ_COUNT +'&RFQ_SEQ=' + RFQ_SEQ +'&PRICE_DOC=' +PRICE_DOC_VALUE + '&VENDOR_CODE=' + VENDOR_CODE,"win_cost","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=465,height=300,left=0,top=0");
			}
		}
		else if(msg3 == INDEX_ATTACH_NO) {
			var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
			Arow = msg2;

			rMateFileAttach('P','R','QTA',ATTACH_NO_VALUE,'S');
		}
		else if (msg3 == INDEX_PURCHASE_LOCATION) openSelectLocation(msg2);
	} // t_imagetext

	if(msg1 == "t_header") {
		if(msg3 == INDEX_PURCHASE_LOCATION) {
			copyCell(WiseTable, INDEX_PURCHASE_LOCATION, "t_imagetext");
		}
		else if(msg3 == INDEX_AUTO_PO_FLAG) {
			copyCell(WiseTable, INDEX_AUTO_PO_FLAG, "t_boolean");
		}
		else if(msg3 == INDEX_CONTRACT_FLAG) {
			copyCell(WiseTable, INDEX_CONTRACT_FLAG, "t_boolean");
		}
	}
}

function openSelectLocation(selectedIndex) {
	G_Pos = selectedIndex;

	url = "/kr/dt/rfq/ebd_pp_ins7.jsp?PURCHASE_CODE="+GD_GetCellValueIndex(GridObj,selectedIndex, INDEX_PURCHASE_LOCATION);
	PopupGeneral(url, "ebd_pp_ins7", "","","600","500");
}

function called_ebd_pp_ins7(data) {
	GD_SetCellValueIndex(GridObj,G_Pos, INDEX_PURCHASE_LOCATION, G_IMG_ICON + "&Y&" + data, "&");
}

function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "P") {
		var protocol = location.protocol;
		var host     = location.host;
		var addr     = protocol +"//" +host;

		var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

		f.method = "POST";
		f.target = "fileattach";
		f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
		f.submit();
	}
	else if (att_mode == "S") {
		f.method = "POST";
		
		if (company == "B") {			// Buyer
			f.target = "attachBFrame";
		}
		else if (company == "S") {	// Supplier
			f.target = "attachSFrame";
		}
		
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

var selectAllFlag = 0;

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

/* 
function doPrint() {
	
	var url = '/kr/dt/rfq/price_investigation.jsp';
	var title = '가격조사서';
	param  = 'popup_flag=true';
	param += dataOutput();
	alert('param : ' + param);
	popUpOpen01(url, title, '600', '800', param);
	
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
	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
		return true;
    }
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
        parent.opener.doSelect();
        parent.window.close();
    }
    else {
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
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" action="">
		<input type="hidden" name="rfq_no"        id="rfq_no"         value="">
		<input type="hidden" name="rfq_count"     id="rfq_count"      value="">
		<input type="hidden" name="vendor_code"   id="vendor_code"    value="">
		<input type="hidden" name="bid_req_type"  id="bid_req_type"   value="">
		<input type="hidden" name="seq"           id="seq"            value="">
		<input type="hidden" name="item_no"       id="item_no"        value="">
		<input type="hidden" name="VendorCode"    id="VendorCode"     value="">
		<input type="hidden" name="flag"          id="flag"           value="">
		<input type="hidden" name="remark"        id="remark"         value="">
		<input type="hidden" name="settle_attach_no" id="settle_attach_no" value=""> 
		                                                               
		<input type="hidden" name="sr_attach_no" id="sr_attach_no"> 
		                                                               
		<input type="hidden" name="att_mode"      id="att_mode"       value="">
		<input type="hidden" name="view_type"     id="view_type"      value="">
		<input type="hidden" name="file_type"     id="file_type"      value="">
		<input type="hidden" name="tmp_att_no"    id="tmp_att_no"     value="">
		<input type="hidden" name="attach_count"  id="attach_count"   value="">
		
		<textarea name="sr_reason" style="display:none;"></textarea>

		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="20" align="right">
					<TABLE cellpadding="0">
						<TR>
<%--
							<TD>
								<script language="javascript">
									btn("javascript:reset_bill()", "구매복구");
								</script>
							</TD>
 --%>
 							<%-- 
							<TD>
								<script language="javascript">
									btn("javascript:doPrint()", "가격조사서");
								</script>
							</TD>
							--%>
							<TD>
								<script language="javascript">
									btn("javascript:doSave()", "업체선정");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:doClose('N')", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
		
		<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
		<div id="pagingArea"></div>
<%-- 		<s:grid screen_id="RQ_246_2" grid_obj="GridObj" grid_box="gridbox" height="180px" /> --%>

	</form>
</s:header>
<s:footer/>
</body>
</html>