<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_013");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "MA_013";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	String  type           = request.getParameter("type");
	String  pItemNo        = request.getParameter("pItemNo");
	String  seq            = request.getParameter("seq");
	boolean isSelectScreen = false;
	
	if(pItemNo == null){
		pItemNo = "";
	}
	
	if(seq == null){
		seq = "";
	}
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
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var selectType = "";
var G_C_INDEX  = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";

function fnBodyOnLoad(){
	setGridDraw();
	
	if(document.getElementById("type").value == "U"){
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012",
			{
				mode     : "ma012selectGl",
				cols_ids : "SEQ,BOM_NAME,DESCRIPTION_LOC,SPECIFICATION,BASIC_UNIT,ITEM_NO",
				pItemNo  : document.getElementById("pItemNo").value,
				seq      : document.getElementById("seq").value
			},
			function(arg){
				var argArray       = arg.split(",");
				var argArrayLength = argArray.length;
				
				if(argArrayLength == 1){
					alert(arg);
					
					return;
				}
				else{
					
					document.getElementById("seq").value            = argArray[0];
					document.getElementById("bomName").value        = argArray[1];
					document.getElementById("desctiptionLoc").value = argArray[2];
					document.getElementById("specification").value  = argArray[3];
					document.getElementById("basicUnit").value      = argArray[4];
					document.getElementById("pItemNo").value        = argArray[5];
					
					var params = "mode=doSelect";
					params += "&cols_ids=<%=grid_col_id%>";
					params += dataOutput();
					
					GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012", params);
					
					GridObj.clearAll(false);
				}
			}
		);
	}
}

function fnPIntemNoPop(){
	selectType = "parent";
	
	callCatalog();
}

function fnAddRow(){
	selectType = "child";
	
	callCatalog();
}

function callCatalog(){
	setCatalogIndex(G_C_INDEX);
	
	var url = "/kr/catalog/cat_pp_lis_main.jsp?INDEX=" + getAllCatalogIndex() ;
	
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	if(selectType == "parent"){
		var pItemNoObject        = document.getElementById("pItemNo");
		var desctiptionLocObject = document.getElementById("desctiptionLoc");
		var specificationObject  = document.getElementById("specification");
		var basicUnitObject      = document.getElementById("basicUnit");
		
		pItemNoObject.value        = itemNo;
		desctiptionLocObject.value = descriptionLoc;
		specificationObject.value  = specification;
		basicUnitObject.value      = basicUnit;
	}
	else if(selectType == "child"){
		var rowIndex               = GridObj.GetRowCount();
		var newId                  = (new Date()).valueOf();
		var cItemNoColIndex        = GridObj.getColIndexById("C_ITEM_NO");
		var descriptionLocColIndex = GridObj.getColIndexById("DESCRIPTION_LOC");
		var specificationColIndex  = GridObj.getColIndexById("SPECIFICATION");
		var basicUnitColIndex      = GridObj.getColIndexById("BASIC_UNIT");
		var bomStandardQtyColIndex = GridObj.getColIndexById("BOM_STANDARD_QTY");
		var i                      = 0;
		var cItemNoColValue        = null;
		var isDupFlag              = false;
		
		for(i = 0; i < rowIndex; i++) {
			cItemNoColValue = GD_GetCellValueIndex(GridObj,i,cItemNoColIndex);
			
			if(itemNo == cItemNoColValue) {
				isDupFlag = true;
			}
		}
		
		if(isDupFlag == false){
			GridObj.addRow(newId,"");
			
			GD_SetCellValueIndex(GridObj, rowIndex, cItemNoColIndex,        itemNo);
			GD_SetCellValueIndex(GridObj, rowIndex, descriptionLocColIndex, descriptionLoc);
			GD_SetCellValueIndex(GridObj, rowIndex, specificationColIndex,  specification);
			GD_SetCellValueIndex(GridObj, rowIndex, basicUnitColIndex,      basicUnit);
			GD_SetCellValueIndex(GridObj, rowIndex, bomStandardQtyColIndex, "0");
			GridObj.cells(GridObj.getRowId(rowIndex), GridObj.getColIndexById("SELECTED")).setValue("1");
			GridObj.cells(GridObj.getRowId(rowIndex), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		}
	}
}

function fnDelRow(){
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

function fnSave(){
	var pItemNoObject    = document.getElementById("pItemNo");
	var bomNameObject    = document.getElementById("bomName");
	var rowCount         = GridObj.GetRowCount();
	var isSelected       = false;
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	var i                = 0;
	var params;
	
	if(pItemNoObject.value == ""){
		alert("모품목을 선택하여 주십시오.");
		
		return;
	}
	
	if(bomNameObject.value == ""){
		alert("BOM명을 입력하여 주십시오.");
		
		return;
	}
	
	if(rowCount == 0){
		alert("자품목을 선택하여 주십시오.");
		
		return;
	}
	
	for(i = 0;i < rowCount; i++){
		if(GD_GetCellValueIndex(GridObj, i, selectedColIndex) == true){
			isSelected = true;
			
			break;
		}
	}
	
	if(isSelected == false){
		alert("저장할 자품목을 선택하여 주십시오.");
		
		return;
	}
	
	if(confirm("저장하시겠습니까?")){
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		params = "?mode=doSave";
		params = params + "&cols_ids=<%=grid_col_id%>";
		params = params + dataOutput();
		
		myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012" + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
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

    alert(messsage);
    
    if(document.getElementById("type").value == "U"){
    	var pItemNoObject = document.getElementById("pItemNo");
    	var seqObject     = document.getElementById("seq");
    	
    	opener.doSelect();
    	opener.fnPIntemNoPopCallback(pItemNoObject.value, seqObject.value);
    }
    
    window.close();
    
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
    var msg    = GridObj.getUserData("", "message");
    var status = GridObj.getUserData("", "status");

    if(status == "0"){
    	alert(msg);
    }
    
    for(var i = 0; i < GridObj.getRowsNum(); i++){
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	}
    
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();" >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">BOM 관리</td>
		</tr>
	</table>

	<form name="form1" action="">
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
	
		<input type="hidden" id="type" name="type" value="<%=type %>"/>
		<input type="hidden" id="seq"  name="seq"  value="<%=seq %>"/>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품목</td>
				<td class="data_td" width="35%">
					<input type="text" id="pItemNo" name="pItemNo" size="15" class="inputsubmit" value='<%=pItemNo %>' readonly="readonly">
<%
	if("I".equals(type)){
%>
					<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:fnPIntemNoPop();">
<%
	}
%>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;BOM 명</td>
				<td class="data_td" width="35%">
					<input type="text" name="bomName" id="bomName" size="20" maxlength="500" class="inputsubmit" value=''>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품명</td>
				<td class="data_td" width="35%">
					<input type="text" name="desctiptionLoc" id="desctiptionLoc" size="20" class="input_data2" readonly value=''>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
				<td class="data_td" width="35%">
					<input type="text" name="specification" id="specification" size="20" class="input_data2" readonly value=''>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위</td>
				<td class="data_td" colspan="3">
					<input type="text" name="basicUnit" id="basicUnit" size="20" class="input_data2" readonly value=''>
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
				<td height="30" align="right">
					<table cellpadding="0">
						<tr>
							<td>
<script language="javascript">
btn("javascript:fnAddRow()", "행추가");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:fnDelRow()", "행삭제");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:fnSave()", "저 장");
</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="MA_013" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>