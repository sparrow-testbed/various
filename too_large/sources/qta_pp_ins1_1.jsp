<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_246_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_246_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
		

    String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
    String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
    String settle_type  = JSPUtil.nullToEmpty(request.getParameter("settle_type"));
    String bid_req_type     = JSPUtil.nullToEmpty(request.getParameter("bid_req_type"));
    String req_type     = JSPUtil.nullToEmpty(request.getParameter("req_type"));
	String WISEHUB_PROCESS_ID="RQ_246_1";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var req_type = "<%=bid_req_type%>";
var mode;

var IDX_SEL           ;
var IDX_ABANDON       ;
var IDX_VENDOR_CODE   ;
var IDX_VENDOR_NAME   ;
var IDX_CUR           ;
var IDX_TTL_AMT       ;
var IDX_QTA_NO        ;
var IDX_DELY_TERMS_TEXT    ;
var IDX_PAY_TERMS_TEXT     ;
var IDX_RFQ_COUNT     ;
var IDX_SETTLE_REMARK ;
var IDX_SETTLE_ATTACH_NO		;


function Init()
{
	setGridDraw();
	setHeader();
	
}

function setHeader() {
	/* GridObj.SetColCellSortEnable("SEL",false);
	GridObj.SetColCellSortEnable("ABANDON",false);
	GridObj.SetColCellSortEnable("VENDOR_CODE",false);
	GridObj.SetColCellSortEnable("VENDOR_NAME",false);
	GridObj.SetColCellSortEnable("CUR",false);
	GridObj.SetNumberFormat("TTL_AMT",G_format_amt);
	GridObj.SetColCellSortEnable("TTL_AMT",false);
	GridObj.SetColCellSortEnable("DELY_TERMS_TEXT",false);
	GridObj.SetColCellSortEnable("PAY_TERMS_TEXT",false);
	GridObj.SetColCellSortEnable("RFQ_COUNT",false); */

	IDX_SEL               = GridObj.GetColHDIndex("SEL");
	IDX_ABANDON           = GridObj.GetColHDIndex("ABANDON");
	IDX_VENDOR_CODE       = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME       = GridObj.GetColHDIndex("VENDOR_NAME");
	IDX_CUR               = GridObj.GetColHDIndex("CUR");
	IDX_TTL_AMT           = GridObj.GetColHDIndex("TTL_AMT");
	IDX_QTA_NO            = GridObj.GetColHDIndex("QTA_NO");
	IDX_DELY_TERMS_TEXT   = GridObj.GetColHDIndex("DELY_TERMS_TEXT");
	IDX_PAY_TERMS_TEXT    = GridObj.GetColHDIndex("PAY_TERMS_TEXT");
	IDX_RFQ_COUNT         = GridObj.GetColHDIndex("RFQ_COUNT");
	IDX_BID_REQ_TYPE      = GridObj.GetColHDIndex("BID_REQ_TYPE");
	IDX_SETTLE_REMARK     = GridObj.GetColHDIndex("SETTLE_REMARK");
	IDX_SETTLE_ATTACH_NO  = GridObj.GetColHDIndex("SETTLE_ATTACH_NO");

	doSelect();
}

/* function setSelectRow(){
	var rowId = 1;
	var cellInd = 1;
	doOnRowSelected(rowId, cellInd);
	//GridObj.selectRowById(rowId, false, true);
	//alert("OK"); 
	
} */

function doSelect() {
<%-- 	servletUrl = "<%=getWiseServletPath("dt.rfq.qta_pp_ins1_1")%>"; --%>
G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_pp_ins1_1";

	<%-- GridObj.SetParam("mode", "getDocBaseQtaCompareHD");

	GridObj.SetParam("rfq_no", "<%=rfq_no%>");
	GridObj.SetParam("rfq_count", "<%=rfq_count%>");

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl); --%>
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getDocBaseQtaCompareHD";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
	
}

function getSelectedVendorCode() {
	VendorCode = "";

	for(row=0; row<top.topFrame.GridObj.GetRowCount(); row++) {
		if("true" == top.topFrame.GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			VendorCode = top.topFrame.GD_GetCellValueIndex(GridObj,row, IDX_VENDOR_CODE);
			
			return VendorCode;
		}
	}

	return VendorCode;
}

function removeSelectRow() {
	if(GridObj.GetRowCount() > 0) {
		for(var row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
				GridObj.DeleteRow(row);
				
				if(GridObj.GetRowCount() == 0) {
					top.opener.doSelect();
					top.window.close();
				}

				return;
			}
		}
	}
}

function nego_amt_data(){
	var row = GridObj.GetRowCount();
	var cnt = 0;
	var nego_amt = 0;
	var compare_nego_amt = 0;
	var tmp_nego_amt = 0;

	for(i = 0;i < row;i++){
		var yn = GD_GetCellValueIndex(GridObj,i,IDX_SEL);
		
		compare_nego_amt = GD_GetCellValueIndex(GridObj,i,IDX_TTL_AMT);

		if(yn == true){
			tmp_nego_amt = GD_GetCellValueIndex(GridObj,i,IDX_TTL_AMT);
			
			if( nego_amt == 0 ){
				nego_amt = tmp_nego_amt;
			}
            
			if( nego_amt < tmp_nego_amt ){
				nego_amt = tmp_nego_amt;
			}
		}
	}

	for(i = 0;i < row;i++){
		var yn = GD_GetCellValueIndex(GridObj,i,IDX_SEL);

		if(yn != true){
			tmp_nego_amt = GD_GetCellValueIndex(GridObj,i,IDX_TTL_AMT);

			if( eval(nego_amt) > 0 && eval(nego_amt) > eval(tmp_nego_amt) ){
				return false;
			}
		}
	}
	
	return true;
}

function remarkData(){
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var remark = "";

	for(var i=0;i<iRowCount;i++){
		if(true == GD_GetCellValueIndex(GridObj,i, IDX_SEL)) {
			//GridObj.SetCellBgColor("SETTLE_REMARK", i, G_COL1_ESS);
			//GridObj.SetCellBgColor("SETTLE_ATTACH_NO", i, G_COL1_ESS);
			
			remark = GD_GetCellValueIndex(GridObj, i, IDX_SETTLE_REMARK);
			iCheckedCount++;
		}
	}

	return remark;
}

function attachData(){
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var attach_no = "";

	for(var i=0;i<iRowCount;i++){
		if("true" == GD_GetCellValueIndex(GridObj,i, IDX_SEL)) {
			attach_no = GD_GetCellValueIndex(GridObj,i, IDX_SETTLE_ATTACH_NO);
			iCheckedCount++;
		}
	}

	return attach_no;
}

function chk_Abandon(){
	if(0 == GridObj.GetRowCount()) {
		return;
	}

	for(var row=0; row<GridObj.GetRowCount(); row++){
		var yn = GD_GetCellValueIndex(GridObj,row,IDX_SEL);

		if(yn == "true"){
			if(GD_GetCellValueIndex(GridObj,row,IDX_ABANDON) == "Y"){
				return false;
			}
		}
	}
	
	return true;
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	var rfq_no      = "<%=rfq_no%>";
//	var rfq_count   = GD_GetCellValueIndex(GridObj, msg2, IDX_RFQ_COUNT);
	var rfq_count   = <%=rfq_count%>;
	var settle_type = "<%=settle_type%>";
	
	if(msg1 == "doQuery") {
		vendor_code = GD_GetCellValueIndex(GridObj,0, IDX_VENDOR_CODE);
		
		/* GridObj.SetCellValue("SEL", 0, "1");
		GridObj.SetCellBgColor("SETTLE_REMARK", 0, G_COL1_OPT);
		GridObj.SetCellBgColor("SETTLE_ATTACH_NO", 0, G_COL1_OPT); */
		if(req_type == "I"){
			parent.mainFrame.location.href="qta_pp_ins1_2.jsp?rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>&vendor_code="+vendor_code+"&settle_type=<%=settle_type%>&req_type=<%=req_type%>";
		}
		else{
			//as is 파일 없음.
			//parent.mainFrame.location.href="qta_pp_ins1_3.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count+"&vendor_code="+vendor_code+"&settle_type="+settle_type;
			alert("as is 파일 없음.");
		}
	}
	
	if(msg1 == "t_insert") {
		if(msg3 == IDX_SEL) {
			if("false" == msg5) {
				parent.mainFrame.removeAll();
				
				return;
			}

			for(i=0; i<GridObj.GetRowCount(); i++) {
				if("true" == GD_GetCellValueIndex(GridObj,i, IDX_SEL)) {
					//선정사유, 첨부파일 색상 변경
					//GridObj.SetCellBgColor("SETTLE_REMARK", i, G_COL1_OPT);
					//GridObj.SetCellBgColor("SETTLE_ATTACH_NO", i, G_COL1_OPT);

					if(i != msg2) {
						GD_SetCellValueIndex(GridObj,i, IDX_SEL, "false&", "&");
						
						//GridObj.SetCellBgColor("SETTLE_REMARK", i, "255|255|255");
						//GridObj.SetCellBgColor("SETTLE_ATTACH_NO", i, "255|255|255");
					}
				}
			}

			bid_req_type = GD_GetCellValueIndex(GridObj,msg2, IDX_BID_REQ_TYPE );
			vendor_code = GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);


			//parent.mainFrame.doSelect("<%=settle_type%>", "<%=rfq_no%>", rfq_count, vendor_code, bid_req_type);
			
			if(bid_req_type == "I"){
				parent.mainFrame.location.href="qta_pp_ins1_2.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count+"&vendor_code="+vendor_code+"&settle_type="+settle_type;
			}
			else{
				parent.mainFrame.location.href="qta_pp_ins1_3.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count+"&vendor_code="+vendor_code+"&settle_type="+settle_type;
			}
		}
	}
	else if(msg1 == "t_imagetext"){
		if(msg3 == IDX_QTA_NO){
			st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_QTA_NO),msg2);
			
			if(LRTrim(st_qta_no) == ""){
				return;
			}
			
			st_vendor_code = GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);
			st_rfq_no ="<%=rfq_no%>";
			st_rfq_count = "<%=rfq_count%>";

			send_url = "qta_pp_dis1.jsp?st_vendor_code=" + st_vendor_code + "&st_qta_no=" + st_qta_no;
			send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count ;
			
			window.open(send_url,"qta_win","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=840,height=760,left=0,top=0");
		}
		else if(msg3 == IDX_SETTLE_REMARK){
			if(GridObj.GetCellValue("SEL", msg2) != "1"){
				//return;
			}

			var SETTLE_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_SETTLE_ATTACH_NO));

			var mode = "";
			var url = "/kr/confirm_pp_dis.jsp?mode=update&function=setSettleRemark&title=선정사유&columnType=t_imagetext&column=SETTLE_REMARK&useAttach=Y&row="+ msg2+"&attach_no="+SETTLE_ATTACH_NO_VALUE;
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
	}
}

function setSettleRemark(value, row, att_no){
	var img = value == "" ? "" : "<%=G_IMG_ICON%>";
	
	GD_SetCellValueIndex(GridObj,row,IDX_SETTLE_REMARK,     img + "&"+value+"&" + value,"&");
	GD_SetCellValueIndex(GridObj,row, IDX_SETTLE_ATTACH_NO, img + "&null&" + att_no,"&");
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
	var rfq_no      = "<%=rfq_no%>";
	var rfq_count   = <%=rfq_count%>;
	var settle_type = "<%=settle_type%>";	
	
	
// 		if("false" == msg5) {
// 			parent.mainFrame.removeAll();
// 			return;
// 		}


	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
	    GridObj.cells(GridObj.getRowId(i), 0).setValue("0");
	}
	GridObj.cells(rowId, 0).setValue("1");

	bid_req_type = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId), IDX_BID_REQ_TYPE );
	vendor_code  = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId), IDX_VENDOR_CODE);

	
	if(bid_req_type == "I"){
		parent.mainFrame.location.href="qta_pp_ins1_2.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count+"&vendor_code="+vendor_code+"&settle_type="+settle_type;
	}
	else{
		parent.mainFrame.location.href="qta_pp_ins1_3.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count+"&vendor_code="+vendor_code+"&settle_type="+settle_type;
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    }
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
    
    if(GridObj.GetRowCount() > 0){
	    GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(0), false, true);

	    GridObj.cells(GridObj.getRowId(0), 0).cell.wasChanged = true;
	    GridObj.cells(GridObj.getRowId(0), 0).setValue("1");
   
//     	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
// 	    doOnRowSelected(GridObj.getRowId(0), 0);	    
    	
    }
    
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
		<input type="hidden" name="rfq_no" value="<%=rfq_no%>">
		<input type="hidden" name="rfq_count" value="<%=rfq_count%>">

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class="title_page">견적비교(총액별)</td>
			</tr>
		</table>

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
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
				<td width="35%" class="data_td">
					&nbsp;<input type="text" name="rfq_no" id="rfq_no" value="<%=rfq_no%>" style="border:0;padding:4px 2px 0px 2px;" readOnly>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
				<td width="35%" class="data_td">
					&nbsp;<input type="text" name="rfq_count" id="rfq_count" value="<%=rfq_count%>" style="border:0;padding:4px 2px 0px 2px;" readOnly>
				</td>
			</tr>
		</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		

	<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
	<div id="pagingArea"></div>
<%--	<s:grid screen_id="RQ_246_1" grid_obj="GridObj" grid_box="gridbox" height="180px" /> --%>

	</form>
</s:header>
<s:footer/>
</body>
</html>