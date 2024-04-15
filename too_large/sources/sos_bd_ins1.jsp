<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SO_001");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SO_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var attachType             = "";
var attachSelectedRowIndex = -1;

function fnBodyOnLoad(){
	setGridDraw();
	doSelect();
}

function doSelect(){
	var params = "mode=requestList";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_ins1", params );
	GridObj.clearAll(false);
}

function fnVendorSelect(){
	var i                        = 0;
	var rowCount                 = GridObj.GetRowCount();
	var chkCount                 = 0;
	var purchaseLocationColIndex = GridObj.getColIndexById("PURCHASE_LOCATION");
	var itemNoColIndex           = GridObj.getColIndexById("ITEM_NO");
	var selectedColValue         = null;
	var purchaseLocationColValue = "";
	var itemNoColValue           = "";
	var url                      = null;
	
	for(i = 0; i < rowCount; i++){
		purchaseLocationColValue = purchaseLocationColValue + GD_GetCellValueIndex(GridObj, i, purchaseLocationColIndex);
		itemNoColValue           = itemNoColValue + GD_GetCellValueIndex(GridObj, i, itemNoColIndex);
		
		if(i != (rowCount - 1)){
			purchaseLocationColValue = purchaseLocationColValue + ",";
			itemNoColValue           = itemNoColValue + ",";
		}
	}
	
	url = "sos_bd_lis2.jsp";
	url = url + "?pr_location=" + purchaseLocationColValue;
	url = url + "&item_no="     + itemNoColValue;
	
	window.open(url, "sos_bd_lis2", "left=0,top=0,width=500,height=300,resizable=yes,scrollbars=yes");
}

function setPo(vendorCode, vendorName, unitPrice, rowIndex){
	var vendorCodeColIndex    = GridObj.getColIndexById("VENDOR_CODE");
	var vendorNameColIndex    = GridObj.getColIndexById("VENDOR_NAME");
	var infoUnitPriceColIndex = GridObj.getColIndexById("INFO_UNIT_PRICE");
	
	GD_SetCellValueIndex(GridObj, rowIndex, vendorCodeColIndex,    vendorCode);
	GD_SetCellValueIndex(GridObj, rowIndex, vendorNameColIndex,    vendorName);
	GD_SetCellValueIndex(GridObj, rowIndex, infoUnitPriceColIndex, unitPrice);
	
	
	return true;
}

function attachFileHeader(){
	attachType = "H";
	attach_file(document.getElementById('attach_no').value, 'TEMP');
}

function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	if(attachType == "H"){
		
	 	document.getElementById("attach_no").value = attach_key;
	 	document.getElementById("sign_attach_no_count").value = attach_count;
		
		document.getElementById("attach_no").value = attach_key;
		document.getElementById("sign_attach_no_count").value = attach_count;
	}
	else if(attachType == "G"){
		var attachNoColIndex    = GridObj.getColIndexById("ATTACH_NO");
		var attachCountColIndex = GridObj.getColIndexById("ATTACH_COUNT");
		
		GD_SetCellValueIndex(GridObj, attachSelectedRowIndex, attachNoColIndex,    attach_key + "");
		GD_SetCellValueIndex(GridObj, attachSelectedRowIndex, attachCountColIndex, attach_count + "");
	}
}

function selectAll_new() {
	for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
	{
		<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).setValue("1");
		<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    }
}

function fnCreate(status){
	var statusObject       = document.getElementById("status");
	var subject            = document.getElementById("subject");
	var grid_array         = getGridChangedRows(GridObj, "SELECTED");
	var url                = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_ins1";
	
	var i                  = 0;
	var rowCount           = GridObj.GetRowCount();
	var chkCount           = 0;
	var selectedColIndex   = GridObj.getColIndexById("SELECTED");
	var vendorCodeColIndex = GridObj.getColIndexById("VENDOR_CODE");
	var selectedColValue   = null;
	var vendorCodeColValue = null;
	var confirmMessage     = null;
	selectAll_new();
	for(i = 0; i < rowCount; i++){
		selectedColValue   = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		vendorCodeColValue = GD_GetCellValueIndex(GridObj, i, vendorCodeColIndex);
		
		if(selectedColValue == true){
			chkCount++;
			
			if(vendorCodeColValue == ""){
				alert("실사 업체를 선택하여 주십시오.");
				
				return;
			}
		}
	}
	
	if(subject.value == ""){
		alert("실사요청명을 입력하여 주십시오.");
		
		return;
	}
	
	if(chkCount == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}
	
	if(status == "T"){
		confirmMessage = "임시저장하시겠습니까?";
	}
	else if(status == "P"){
		confirmMessage = "업체전송하시겠습니까?";
	}
	
	if(confirm(confirmMessage)){
		statusObject.value = status;
		
		url = url + "?mode=createOs";
		url = url + "&cols_ids=<%=grid_col_id%>";
		url = url + dataOutput();
		myDataProcessor = new dataProcessor(url);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

function fnDeleteRows(){
	var rowCount         = GridObj.GetRowCount();
	var selected         = false;
	var rowid            = "";
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	
	for(var i = (rowCount - 1); i >= 0; i--){
		selected = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
		
		if(selected == true){
			rowid = GridObj.getRowId(i);
			
			GridObj.deleteRow(rowid);
		}
	}
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId, cellInd){
	var rowIndex   = GridObj.getRowIndex(rowId);
	
	if(cellInd == GridObj.getColIndexById("ATTACH_COUNT")) {
		var attachNoColIndex = GridObj.getColIndexById("ATTACH_NO");
		var attachNoColValue = null;
		
		attachType             = "G";
		attachSelectedRowIndex = rowIndex;
		attachNoColValue       = GD_GetCellValueIndex(GridObj, rowIndex, attachNoColIndex);
		
		attach_file(attachNoColValue, 'TEMP');
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

    alert(messsage);
    
    if(status == "true") {
    	opener.doSelect();
    	window.close();
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
    var tmpSubject = "";
    var tmpRemark = "";
    if(GridObj.GetRowCount() > 0){
    	
   		if(GridObj.GetRowCount() > 1){
   			tmpSubject = GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("USER_DEPT_NAME_LOC")).getValue() ;
   			tmpSubject += "(" + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("USER_DEPT_CD")).getValue() + ")" ;
   			tmpSubject += " " + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue() ;
   			tmpSubject += " " + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DESCRIPTION_LOC")).getValue() + " 외" + (GridObj.GetRowCount()-1);
   			tmpSubject += "건 실사요청";
   		}else{
   			tmpSubject = GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("USER_DEPT_NAME_LOC")).getValue() ;
   			tmpSubject += "(" + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("USER_DEPT_CD")).getValue() + ")" ;
   			tmpSubject += " " + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue() ;
   			tmpSubject += " " + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
   			tmpSubject += " 실사요청";
   		}   		
   		tmpRemark = GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("USER_NAME_LOC")).getValue() ;
   		tmpRemark += " " + GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("REMARK")).getValue() ;
    }
    
    $("#subject").val(tmpSubject);
    $("#remark").val(tmpRemark);
    
    selectAll_new();
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();">
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>실사요청생성</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" id="form1" action="">
		<input type="hidden" name="prData" id="prData" value="<%=request.getParameter("PR_DATA") %>" />
		<input type="hidden" name="status" id="status" value="" />
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청명</td>
										<td width="35%" class="data_td">
											<input type="text" name="subject" id="subject" style="width:95%" class="inputsubmit" onKeyUp="return chkMaxByte(500, this, '실사요청명');">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청일자</td>
										<td width="35%" class="data_td">
											<s:calendar id="osqDate" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특이사항</td>
										<td class="data_td" colspan="3">
											<input type="text" name="remark" id="remark" style="width:95%" class="inputsubmit" value="" onKeyUp="return chkMaxByte(4000, this, '특이사항');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="10%">
<script language="javascript">
// function setAttach(attach_key, arrAttrach, rowId, attach_count) {
// 	document.getElementById("attach_no").value = attach_key;
// 	document.getElementById("sign_attach_no_count").value = attach_count;
// }
	
btn("javascript:attachFileHeader();", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="0" name="sign_attach_no_count" id="sign_attach_no_count"/>
														<input type="hidden" value="" name="attach_no" id="attach_no">
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
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<TD>
<script language="javascript">
btn("javascript:fnVendorSelect()", "실사업체");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:fnCreate('T')", "임시저장");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:fnCreate('P')", "업체전송");
</script>
						</TD>
<!-- 						<TD> -->
<%-- <script language="javascript">btn("javascript:fnDeleteRows()", "행삭제");</script> --%>
<!-- 						</TD> -->
						<TD>
<script language="javascript">
btn("javascript:window.close()", "닫  기");
</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SO_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>