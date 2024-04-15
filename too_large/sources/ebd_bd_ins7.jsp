<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_037");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id             = "PR_037";
	String  grid_obj              = "GridObj";
	String  WISEHUB_PROCESS_ID    = "PR_037";
	String  G_IMG_ICON            = "/images/ico_zoom.gif";
	boolean isSelectScreen = false;
	String LB_MATERIAL_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var GridObj             = null;
var MenuObj             = null;
var myDataProcessor     = null;

function fnBodyOnLoad(){
	setGridDraw();
	doSelect();
}

function doSelect(){
	var params = "mode=selectSprcartList";
    
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    
    GridObj.post( "<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins7", params );
    GridObj.clearAll(false);
}

function fnDelete(){
	if(confirm("삭제 하시겠습니까?")){
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var params = "?mode=deleteSprcartInfo";
		
		params += "&cols_ids=<%=grid_col_id%>";
		params += dataOutput();
		
		myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins7"+params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}

function fnCreate(){
	var rowCount          = GridObj.GetRowCount();
	var i                 = 0;
	var selectedColIndex  = GridObj.getColIndexById("SELECTED");
	var prQtyColIndex     = GridObj.getColIndexById("PR_QTY");
	var maxReqCntColIndex = GridObj.getColIndexById("MAX_REQ_CNT");
	var minReqCntColIndex = GridObj.getColIndexById("MIN_REQ_CNT");
	var material_ctrl_type = GridObj.getColIndexById("MATERIAL_CTRL_TYPE");	//중분류 컬럼 추가
	var selectedColValue  = null;
	var checkCount        = 0;
	var checkCount2        = 0;
	var prQtyColValue     = null;
	var maxReqCntColValue = null;
	var minReqCntColValue = null;
	var material_ctrl_type_value = null;	//중분류 값 추가
	
	
	
	//대분류가 재산관리인 경우 신청구분 선택여부와 고유번호/취득일자/취득금액/신청사유 입력여부 체크
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	for(var i = 0; i < grid_array.length; i++) {
		
		var material_type = GridObj.cells(grid_array[i], GridObj.getColIndexById("MATERIAL_TYPE")).getValue();
		var app_div = GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_DIV")).getValue();
		var asset_type = GridObj.cells(grid_array[i], GridObj.getColIndexById("ASSET_TYPE")).getValue();
		var ktext = GridObj.cells(grid_array[i], GridObj.getColIndexById("KTEXT")).getValue();
		var kamt = GridObj.cells(grid_array[i], GridObj.getColIndexById("KAMT")).getValue();
		var remark = GridObj.cells(grid_array[i], GridObj.getColIndexById("REMARK")).getValue();
		
		if( material_type == "02" && (app_div == "Z" || app_div == "")) {
			//alert("대분류가 재산관리인 품목은 신청구분을 선택하지 않으면 처리할 수 없습니다.");
			alert("업무용동산 품목은 신청구분에 신규/교체 여부를 선택하셔야 합니다.");
			return;
		}
		if( material_type == "02" && (remark == null || remark == "")) {
			alert("신청사유가 없으면 처리할 수 없습니다.");
			return;
		}
		
		if( material_type == "02" && app_div == "B" ) {
			
			if( asset_type == null || asset_type == "" ) {
				
				alert("고유번호가 없으면 처리할 수 없습니다.");
				return;
				
			}
			
			if( ktext == null || ktext == "" ) {
				
				alert("취득일자가 없으면 처리할 수 없습니다.");
				return;
				
			}
			
			if( kamt == null || kamt == "" ) {
				
				alert("취득금액이 없으면 처리할 수 없습니다.");
				return;
				
			}
			
			if( remark == null || remark == "" ) {
				
				alert("신청사유가 없으면 처리할 수 없습니다.");
				return;
				
			}
			
		}
		
	}
	
	
	
	var material_ctrl_type_before = "";	//중분류 값 모음 추가
	for(i = 0; i < rowCount; i++){
		selectedColValue  = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		prQtyColValue     = GD_GetCellValueIndex(GridObj, i, prQtyColIndex);
		maxReqCntColValue = GD_GetCellValueIndex(GridObj, i, maxReqCntColIndex);
		minReqCntColValue = GD_GetCellValueIndex(GridObj, i, minReqCntColIndex);
		material_ctrl_type_value = GD_GetCellValueIndex(GridObj, i, material_ctrl_type);
		
		if(selectedColValue == true){
			checkCount++;
			
			if((prQtyColValue == "") || (Number(prQtyColValue) < 0)){
				alert("카트에 담을 수량을 확인하여 주십시오.");
				
				return;
			}
			
			if((maxReqCntColValue != "") && (Number(prQtyColValue) > Number(maxReqCntColValue))){
				alert("최대수량을 확인하여 주십시오.");
				
				return;
			}
			
			if((minReqCntColValue != "") && (Number(prQtyColValue) < Number(minReqCntColValue))){
				alert("최소수량을 확인하여 주십시오.");
				
				return;
			}
			//두번째 부터 이전 중분류 값과 비교하여 이전 값과 현재 값이 서로 다르고, 두개의 값 중, 하나라도 안내장(03091)이 있으면 Validation
			if(checkCount > 1) {
				if(material_ctrl_type_before != material_ctrl_type_value && (material_ctrl_type_value == "03091" || material_ctrl_type_before == "03091")) {
					alert("안내장은 다른 품목과 같이 결재상신 할 수 없습니다.");
					return;
				}
			}
			material_ctrl_type_before = material_ctrl_type_value;
			
			if(material_ctrl_type_value == "03091"){
				checkCount2++;
			}
		}
	}
	
	if(checkCount2 > 1){
		alert("안내장은 1건씩만 출고요청 가능합니다.\r\n\r\n안내장은 결재 클릭시 결재상신되는게 아니고 즉시 출고요청 됩니다.");
		return;
	}
	
// 	alert("material_ctrl_type_before==="+material_ctrl_type_before);
	var confirm_msg = "결재상신 하시겠습니까?";
	if(material_ctrl_type_before == "03091") {
		confirm_msg = "출고요청 하시겠습니까?\r\n\r\n안내장은 결재 클릭시 결재상신되는게 아니고 즉시 출고요청 됩니다.";
	}
	if(checkCount > 0){
		if(confirm(confirm_msg)){
			if(material_ctrl_type_before == "03091") {
				document.getElementById("material_ctrl_type").value = material_ctrl_type_before;
// 				frm.material_ctrl_type.value = material_ctrl_type_before;
				var grid_array = getGridChangedRows(GridObj, "SELECTED");
				var params = "?mode=setPrCreate_NonApp";
				
				params += "&cols_ids=<%=grid_col_id%>";
				params += dataOutput();
				
				myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins7"+params);
				
				sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
			} else {
				
				/* 
				var grid_array = getGridChangedRows(GridObj, "SELECTED");
				
				for(var i = 0; i < grid_array.length; i++) {
					var app_div = GD_GetCellValueIndex( GridObj, i, GridObj.getColIndexById("APP_DIV") );
					var asset_type = GD_GetCellValueIndex( GridObj, i, GridObj.getColIndexById("ASSET_TYPE") );
					var ktext = GD_GetCellValueIndex( GridObj, i, GridObj.getColIndexById("KTEXT") );
					var kamt = GD_GetCellValueIndex( GridObj, i, GridObj.getColIndexById("KAMT") );
				}
				*/
				
// 				document.getElementById('app_div').value = app_div;
// 				document.getElementById('asset_type').value = asset_type;
				
				var frm = document.getElementById("frm");
				
				frm.method = "POST";
				frm.target = "childFrame";
				frm.action = "/kr/admin/basic/approval/approval.jsp";
				
				frm.submit();
			}
			
		}
	}
	else{
		alert("결재상신 대상을 선택하여 주십시오.");
	}
}

/*
하나만 선택했는지 체크
*/
function checkOneRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length > 0 && grid_array.length == 1)
	{
		return true;
	}

	alert("하나만 선택할 수 있습니다.");
	return false;
}

/*
결재요청
*/
function getApproval(approval_str){
	
	if(approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	
	
	document.getElementById("approval_str").value = approval_str;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var params = "?mode=setPrCreate";
	
	var tmp = "";
	if(grid_array.length > 0){
		tmp = GridObj.cells(grid_array[0], GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
		if(grid_array.length > 1){
			tmp += " 외 " + (grid_array.length-1) + "건 구매요청" ;
		}else{
			tmp += " 구매요청";
		}
	}
	$("#subject").val(tmp);
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins7"+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	
	var modifyButtonColIndex = GridObj.getColIndexById("MODIFY_BUTTON");
	var rowIndex             = GridObj.getRowIndex(rowId);
		
	if(modifyButtonColIndex == cellInd){
		var prQtyColIndex     = GridObj.getColIndexById("PR_QTY");
		var selectedColIndex  = GridObj.getColIndexById("SELECTED");
		var itemNoColIndex    = GridObj.getColIndexById("ITEM_NO");
		var maxReqCntColIndex = GridObj.getColIndexById("MAX_REQ_CNT");
		var minReqCntColIndex = GridObj.getColIndexById("MIN_REQ_CNT");
		var rdDateColIndex    = GridObj.getColIndexById("RD_DATE");
		var rowCount          = GridObj.GetRowCount();
		var prQtyColValue     = GD_GetCellValueIndex(GridObj, rowIndex, prQtyColIndex);
		var itemNoColValue    = GD_GetCellValueIndex(GridObj, rowIndex, itemNoColIndex);
		var maxReqCntColValue = GD_GetCellValueIndex(GridObj, rowIndex, maxReqCntColIndex);
		var minReqCntColValue = GD_GetCellValueIndex(GridObj, rowIndex, minReqCntColIndex);
		var rdDateColValue    = GD_GetCellValueIndex(GridObj, rowIndex, rdDateColIndex);
		
		if((prQtyColValue == "") || (Number(prQtyColValue) < 0)){
			alert("카트에 담을 수량을 확인하여 주십시오.");
			
			return;
		}
		
		if((maxReqCntColValue != "") && (Number(prQtyColValue) > Number(maxReqCntColValue))){
			alert("최대수량을 확인하여 주십시오.");
			
			return;
		}
		
		if((minReqCntColValue != "") && (Number(prQtyColValue) < Number(minReqCntColValue))){
			alert("최소수량을 확인하여 주십시오.");
			
			return;
		}
		
		if(confirm("수정하시겠습니까?") == false){
			return;
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6",
			{
				ITEM_NO : itemNoColValue,
				PR_QTY  : prQtyColValue,
				RD_DATE : rdDateColValue,
				mode    : "insertSprcart"
			},
			function(arg){
				alert(arg);
				doSelect();
			}
		);
	}
	
	if(header_name == "IMAGE_FILE") {
		
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var image_file_path = SepoaGridGetCellValueId(GridObj, rowId, "IMAGE_FILE_PATH");
		
		if(image_file_path != null && image_file_path != "") {
			
			var url    = "/common/image_view_popup.jsp";
// 			var title  = "이미지보기";
// 			var param  = "item_no=" + item_no;
			
// 			popUpOpen01(url, title, "850", "650", param);
			window.open(url + '?item_no=' + item_no ,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=650,left=0,top=0");
			
		}
		
	}
	
	if(header_name == "ASSET_TYPE") {
		
		var app_div         = SepoaGridGetCellValueId(GridObj, rowId, "APP_DIV");
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var description_loc = SepoaGridGetCellValueId(GridObj, rowId, "DESCRIPTION_LOC");
		
		if(app_div != "B") {
			alert('신청구분이 교체인 건만 고유번호를 변경할 수 있습니다.');
			return;
		} else {
			var url = '/kr/tax/pay_pp_lis2_1.jsp';
			var title = 'GridCellClick';
			url = url + "?jumjumcd=" + "<%=info.getSession("DEPARTMENT")%>";
			url = url + "&jumjumnm=" + encodeUrl("<%=info.getSession("DEPARTMENT_NAME_LOC")%>");
			url = url + "&pmkpmkcd="   + item_no;
			url = url + "&pmkpmknm="   + encodeUrl(description_loc);
// 			url = url + "?jumjumcd="   + "20644";
// 			url = url + "&jumjumnm="   + encodeUrl("총무부");
// 			url = url + "&pmkpmkcd="   + "401000";
// 			url = url + "&pmkpmknm="   + encodeUrl("전자복사기");
			url = url + "&p_row_id="   + rowId;
			url = url + "&p_cell_ind=" + cellInd;
			popUpOpen(url, title, '720', '650');
		}
	}
	
}

/*
고유번호, 취득일자, 취득금액 세팅
*/
// function setAssetType(rowId, cellInd, asset_type, ktext, kamt) {
function setAssetType(rowId, asset_type, ktext, kamt) {
	
	GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('ASSET_TYPE'), asset_type);
	GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('KTEXT'), ktext);
	GD_SetCellValueIndex(GridObj, rowId-1, GridObj.getColIndexById('KAMT'), kamt);
	
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
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    
    var header_name = GridObj.getColumnId(cellInd);

    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
    	    
    	if(header_name == "PR_QTY")   { 
    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
	    		GridObj.cells(rowId, cellInd).setValue("");
				return true;
			}
    	}
    	
    	if(header_name == "APP_DIV") {
    		if( GridObj.cells(rowId, GridObj.getColIndexById("APP_DIV")).getValue() == "Z" ) {
		    	GridObj.cells(rowId, GridObj.getColIndexById("ASSET_TYPE")).setValue("");
		    	GridObj.cells(rowId, GridObj.getColIndexById("KTEXT")).setValue("");
		    	GridObj.cells(rowId, GridObj.getColIndexById("KAMT")).setValue("");
		    	//GridObj.cells(rowId, GridObj.getColIndexById("REMARK")).setValue("");
    		}
    	}
    	
    	if(header_name == "REMARK") {
   			if( GridObj.cells(rowId, GridObj.getColIndexById("APP_DIV")).getValue() == "Z" ) {
   				//return false;
   			}
    	}
    	
    	if( header_name == "PR_QTY") {
			var	pr_qty    = GridObj.cells(rowId, GridObj.getColIndexById("PR_QTY")).getValue();
			var	unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
			
			var pr_amt     = floor_number(eval(pr_qty) * eval(unit_price), 0);
			GridObj.cells(rowId, GridObj.getColIndexById("PR_AMT")).setValue(pr_amt);			
		}
    	
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
<body onload="javascript:fnBodyOnLoad();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="760" height="2" bgcolor="#0072bc"></td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right" id="butt_i">
				<TABLE cellpadding="0">
					<TR>
						<TD>
<script language="javascript">
btn("javascript:doSelect()", "조 회");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:fnCreate()", "결재요청");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:fnDelete()", "삭 제");
</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_037" grid_obj="GridObj" grid_box="gridbox" /> --%>

<s:footer/>
<form id="frm" method="post">
	<input type="hidden" name="house_code"         id="house_code"         value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code"       id="company_code"       value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code"          id="dept_code"          value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id"        id="req_user_id"        value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type"           id="doc_type"           value="PR">
	<input type="hidden" name="fnc_name"           id="fnc_name"           value="getApproval">
	<input type="hidden" name="approval_str"       id="approval_str"       value="">
	<input type="hidden" name="material_ctrl_type" id="material_ctrl_type" value="">
	<input type="hidden" name="app_div"            id="app_div"            value="">
	<input type="hidden" name="asset_type"         id="asset_type"         value="">
	<input type="hidden" name="ktext"              id="ktext"              value="">
	<input type="hidden" name="kamt"               id="kamt"               value="">
	<input type="hidden" name="remark"             id="remark"             value="">
	<input type="text" name="subject" 	           id="subject"            value="">
	
</form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>