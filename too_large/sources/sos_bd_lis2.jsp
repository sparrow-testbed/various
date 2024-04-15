<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector  multilang_id       = new Vector();
	HashMap text               = null;
	String  screen_id          = "SO_005";
	String  grid_obj           = "GridObj";
	String  G_IMG_ICON         = "/images/ico_zoom.gif";
	boolean isSelectScreen     = false;

	multilang_id.addElement("SO_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	text = MessageUtil.getMessage(info, multilang_id);
%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
function Init(){
	setGridDraw();
	doSelect();
}

function doSelect(){
	var params = "mode=selectVendor";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis2", params );
	GridObj.clearAll(false);
}

function fnSelect(){
	var iRowCount         = GridObj.GetRowCount();
	var iCheckedCount     = 0;
	var row               = 0;
	var vendorCode        = "";
	var prLocation        = "";
	var itemNo            = "";
	var prLocationObject  = document.getElementById("prLocation");
	var itemNoObject      = document.getElementById("itemNo");
	var prLocationArray   = prLocationObject.value.split(",");
	var itemNoArray       = itemNoObject.value.split(",");
	var itemNoArrayLength = itemNoArray.length;
	var url               = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis2?timeStamp=" + new Date().getTime();
	var queryString       = "";
		
	for(row = 0; row < iRowCount; row++){
		if(true == GridObj.GetCellValue("SELECTED", row)){
			iCheckedCount++;
			
			vendorCode = GridObj.GetCellValue("VENDOR_CODE", row);
		}
	}
	
	if(iCheckedCount<1){
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(iCheckedCount>1){
		alert(G_MSS2_SELECT);
		
		return;
	}
		 
	for(row = 0; row < itemNoArrayLength; row++){
		prLocation  = prLocationArray[row];
		itemNo      = itemNoArray[row];
		queryString = "&prLocation=" + prLocation;
		queryString = queryString + "&itemNo=" + itemNo;
		queryString = queryString + "&vendorCode=" + vendorCode;
		queryString = queryString + "&mode=selectUnitPrice";
		queryString = queryString + "&row=" + row;
		
		sendRequest(fnSelectCallback, queryString, 'POST', url , false, false);
	}
	
	window.close();
}

function fnSelectCallback(oj){
	var result            = oj.responseText;
	var resultArray       = result.split(",");
	var resultArrayLength = resultArray.length;
	var vendorCode        = "";
	var vendorName        = "";
	var unitPrice         = "";
	var rowIndex          = "";
	
	if(resultArrayLength == 1){
		alert(result);
	}
	else{
		vendorCode = resultArray[0];
		vendorName = resultArray[3];
		unitPrice  = resultArray[2];
		rowIndex   = resultArray[1];
		
		opener.setPo(vendorCode, vendorName, unitPrice, rowIndex);
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
function doOnRowSelected(rowId,cellInd){
	var rowIndex      = GridObj.getRowIndex(rowId);
	var osqNoColIndex = GridObj.getColIndexById("OSQ_NO");
	var gg            = getGridSelectedRows(GridObj, "SELECTED");
	
	if(gg !=0){
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++){
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		}
	}
	
	GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	if(cellInd == osqNoColIndex) {
		var osqCountColIndex = GridObj.getColIndexById("OSQ_COUNT");
		var osqNoColValue    = GD_GetCellValueIndex(GridObj, rowIndex, osqNoColIndex);
		var osqCountColValue = GD_GetCellValueIndex(GridObj, rowIndex, osqCountColIndex);
		var url              = "sos_bd_dis1.jsp";
		var title            = '실사요청상세조회';
		var param = "";
		param = param + "OSQ_NO=" + osqNoColValue;
		param = param + "&OSQ_COUNT=" + osqCountColValue;
		
	    popUpOpen01(url, title, '1024', '650', param);	
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
        doSelect();
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
<body onload="javascript:Init();"  bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" action="">
		<input type="hidden" name="prLocation" id="prLocation" value="<%=request.getParameter("pr_location") %>" />
		<input type="hidden" name="itemNo"     id="itemNo"     value="<%=request.getParameter("item_no") %>" />
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>실사요청 공급사 선택</span>
				</td>
			</tr>
		</table>
	
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>

		<s:grid screen_id="SO_005" grid_obj="GridObj" grid_box="gridbox"/>
		
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
btn("javascript:fnSelect()","선 택");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:window.close()","닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:footer/>
</body>
</html>