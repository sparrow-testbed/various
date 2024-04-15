<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_036");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id             = "PR_036";
	String  grid_obj              = "GridObj";
	String  WISEHUB_PROCESS_ID    = "PR_036";
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
var bigMenuCodeArray    = new Array();
var bigMenuNameArray    = new Array();
var middleMenuCodeArray = new Array();
var middleMenuNameArray = new Array();

function fnBodyOnLoad(){
	fnCategory();
	setGridDraw();
}

function fnCategory(){
	var param       = "<%=info.getSession("HOUSE_CODE")%>#M040"
	var queryString = createQueryString("SL0018", param, "", "");
	var url         = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();
	
	sendRequest(fnCategoryCallback, queryString, 'POST', url , true, false);
}

function fnCategoryCallback(oj) {
    var result                = oj.responseText;
    var bigMenuArray          = result.split("<%=ajax_line%>");
    var bigMenuArrayLength    = bigMenuArray.length;
    var i                     = 0;
    var bigMenuInfoArray      = null;
    var bigMenuCodeArrayIndex = -1;
    var bigMenuNameArrayIndex = -1;
    var bigMenuCode           = "";
    var bigMenuName           = "";
    var param                 = "<%=info.getSession("HOUSE_CODE")%>#M041#"
	var queryString           = "";
	var url                   = "<%=ajax_poasrm_context_name%>/servlets/sepoa.svl.util.SepoaAjaxCombo?timeStamp=" + new Date().getTime();
	
    for(i = 1; i < bigMenuArrayLength; i++){
    	bigMenuInfoArray                        = bigMenuArray[i].split("<%=ajax_field%>");
    	bigMenuCode                             = bigMenuInfoArray[0];
    	bigMenuName                             = bigMenuInfoArray[1];
    	
    	if(
    		(bigMenuCode != "01") &&
    		(bigMenuCode != "04") &&
    		(bigMenuCode != "50")
    	){
    		bigMenuCodeArrayIndex                   = bigMenuCodeArray.length;
        	bigMenuNameArrayIndex                   = bigMenuNameArray.length;
        	bigMenuCodeArray[bigMenuCodeArrayIndex] = bigMenuCode;
        	bigMenuNameArray[bigMenuNameArrayIndex] = bigMenuName;
        	
        	queryString = createQueryString("SL0009", param + bigMenuCode, "", "");
        	
        	sendRequest(fnCategoryCallbackCallback, queryString, 'POST', url , false, false);
    	}
    }
    
    fnCategoryTableContent();
}

function fnCategoryCallbackCallback(oj){
	var result                       = oj.responseText;
	var middleMenuArray              = result.split("<%=ajax_line%>");
	var middleMenuArrayLength        = middleMenuArray.length;
	var i                            = 0;
	var middleMenuInfoArray          = null;
	var middleMenuCodeInfoArray      = new Array();
	var middleMenuNameInfoArray      = new Array();
	var middleMenuCode               = "";
	var middleMenuName               = "";
	var middleMenuCodeInfoArrayIndex = 0;
	var middleMenuNameInfoArrayIndex = 0;
	var middleMenuCodeArrayIndex     = middleMenuCodeArray.length;
	var middleMenuNameArrayIndex     = middleMenuNameArray.length;
	
	for(i = 1; i < middleMenuArrayLength; i++){
		middleMenuInfoArray                                   = middleMenuArray[i].split("<%=ajax_field%>");
		middleMenuCode                                        = middleMenuInfoArray[0];
		middleMenuName                                        = middleMenuInfoArray[1];
		
		if(
			(middleMenuCode != "02007") &&
			(middleMenuCode != "02008") &&
			(middleMenuCode != "02003") &&
			(middleMenuCode != "02006")
		){
			middleMenuCodeInfoArrayIndex                          = middleMenuCodeInfoArray.length;
			middleMenuNameInfoArrayIndex                          = middleMenuNameInfoArray.length;
			middleMenuCodeInfoArray[middleMenuCodeInfoArrayIndex] = middleMenuCode;
			middleMenuNameInfoArray[middleMenuNameInfoArrayIndex] = middleMenuName;
		}
	}
	
	middleMenuCodeArray[middleMenuCodeArrayIndex] = middleMenuCodeInfoArray;
	middleMenuNameArray[middleMenuNameArrayIndex] = middleMenuNameInfoArray;
}

function fnCategoryTableContentMaxMiddleMenuLength(){
	var i                       = 0;
	var bigMenuCodeArrayLength  = bigMenuCodeArray.length;
	var middelMenuLength        = 0;
	var maxMiddleMenuLength     = 0;
	
	for(i = 0; i < bigMenuCodeArrayLength; i++){
		middelMenuLength = middleMenuCodeArray[i].length;
		
		if(middelMenuLength > maxMiddleMenuLength){
			maxMiddleMenuLength = middelMenuLength;
		}
	}
	
	return maxMiddleMenuLength;
}

function fnCategoryTableContentBigMenuTd(tr, i){
	var td = document.createElement("td");
	
	td.className = "title_td";
	td.innerHTML = "&nbsp;<img src=\"/images/blt_srch.gif\" width=\"7\" height=\"7\" align=\"absmiddle\">&nbsp;&nbsp;<a href='javascript:fnBigMenuProductList(" + i + ")'><b>" + bigMenuNameArray[i] + "</b></a>";
	
	tr.appendChild(td);
	
	return tr;
}

function fnCategoryTableContentMiddleMenuTd(tr, i, j){
	var td = document.createElement("td");
	
	td.className = "data_td";
	td.innerHTML = "<a href='javascript:fnMiddleMenuProductList(" + i + ", " + j + ")'>" + middleMenuNameArray[i][j] + "</a>";
	
	tr.appendChild(td);
	
	return tr;
}

function fnCategoryTableContentEmptyTd(tr){
	var td = document.createElement("td");
	
	td.className = "data_td";
	td.innerHTML = "&nbsp;";
	
	tr.appendChild(td);
	
	return tr;
}

function fnfnCategoryTableContentLineTr(categoryTableObject, maxMiddleMenuLength){
	var tr = document.createElement("tr");
	var td = document.createElement("td");
	
	td.colspan = maxMiddleMenuLength;
	td.height  = "1";
	td.bgcolor = "#dedede";
	
	tr.appendChild(td);
	categoryTableObject.appendChild(tr);
}

function fnCategoryTableContent(){
	var categoryTableObject     = document.getElementById("categoryTable");
	var bigMenuCodeArrayLength  = bigMenuCodeArray.length;
	var i                       = 0;
	var middelMenuLength        = 0;
	var maxMiddleMenuLength     = fnCategoryTableContentMaxMiddleMenuLength();
	var tr                      = null;
	var emptyTdLength           = 0;
	var j                       = 0;
	var middleMenuNameInfoArray = null;
	
	for(i = 0; i < bigMenuCodeArrayLength; i++){
		middleMenuNameInfoArray = middleMenuNameArray[i];
		middelMenuLength        = middleMenuNameInfoArray.length;
		emptyTdLength           = maxMiddleMenuLength - middelMenuLength;
		tr                      = document.createElement("tr");
		tr                      = fnCategoryTableContentBigMenuTd(tr, i);
		
		for(j = 0; j < middelMenuLength; j++){
			tr = fnCategoryTableContentMiddleMenuTd(tr, i, j);
		}
		
		for(j = 0; j < emptyTdLength; j++){
			tr = fnCategoryTableContentEmptyTd(tr);
		}
		
		if(i != 0){
			fnfnCategoryTableContentLineTr(categoryTableObject, maxMiddleMenuLength);
		}
		
		categoryTableObject.appendChild(tr);
	}
	
	recal();
}

function recal() {
    var gridObjs = $('div[id^=\"gridbox\"]');
    if(gridObjs.length == 1) {
        var height = ($(window).height() - $('#head_area').height() - $('#header').height() - 33);
        if(height > 200){
            gridObjs[0].style.height = height + 'px';
        }else{
        	gridObjs[0].style.height = '200px';	//기본값
        }
    } else if(gridObjs.length > 1) {
        var height = ($(window).height() - $('#head_area').height() - $('#header').height() - 67);
        for(var i = 0; i < gridObjs.length; i++ ) {
            var percent = gridObjs[i].getAttribute('height');
            pheight = (height * percent) / 100;
            if(pheight > 200){
                gridObjs[i].style.height = pheight + 'px';
            }else{
            	gridObjs[i].style.height = '200px';	//기본값
            }
        }
    }
    $('#treeboxbox_tree').css('height', ($(window).height() - $('#header').height() - 70) + 'px');
    $('#snb').css('height', ($(window).height() - $('#header').height() - 20) + 'px');
}

function fnBigMenuProductList(bigMenuCodeIndex){
	var bigMenuCode                   = bigMenuCodeArray[bigMenuCodeIndex];
	var smallCategoryDisplayTable     = document.getElementById("smallCategoryDisplayTable");
	var verySmallCategoryDisplayTable = document.getElementById("verySmallCategoryDisplayTable");
	
	smallCategoryDisplayTable.style.display     = "none";
	verySmallCategoryDisplayTable.style.display = "none";
	
	doSelect(bigMenuCode, "", "", "");
}

function fnMiddleMenuProductListSmallCategoryList(bigMenuCode, middleMenuCode){
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6",
		{
			MATERIAL_TYPE      : bigMenuCode,
			MATERIAL_CTRL_TYPE : middleMenuCode,
			mode               : "selectSmallCategoryList"
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			fnMiddleMenuProductListSmallCategoryListCallback(result, bigMenuCode, middleMenuCode);
		}
	);
}

function fnMiddleMenuProductListSmallCategoryListCallback(result, bigMenuCode, middleMenuCode){
	var smallCategoryTable        = document.getElementById("smallCategoryTable");
	var smallCategoryDisplayTable = document.getElementById("smallCategoryDisplayTable");
	var resultLength              = result.length;
	var tr                        = null;
	var td                        = null;
	var i                         = 0;
	var display                   = null;
	var code                      = null;
	var text2                     = null;
	
	tr = document.getElementById("smallCategoryTr");
	
	if(tr != null){
		smallCategoryTable.removeChild(tr);
	}
	
	if(resultLength == 0){
		display = "none";
	}
	else{
		display = "";
		
		tr    = document.createElement("tr");
		tr.id = "smallCategoryTr";
		
		for(i = 0; i < resultLength; i++){
			td    = document.createElement("td");
			code  = result[i].code;
			text2 = result[i].text2;
			
			td.className = "data_td";
						
			if(code == "03091010"){
				td.innerHTML = "<a href=\"javascript:alert('포탈내 카드플라자에서 안내장(카드 만 해당)을 신청해주세요.');\">" + text2 + "</a>";
			}else{
				td.innerHTML = "<a href=\"javascript:fnSmallCategoryList('" + bigMenuCode + "', '" + middleMenuCode + "', '" + code + "');\">" + text2 + "</a>";
			}
			tr.appendChild(td);
			
		}
		
		smallCategoryTable.appendChild(tr);
	}
	
	smallCategoryDisplayTable.style.display = display;
	
	recal();
}

function fnMiddleMenuProductList(bigMenuCodeIndex, middleMenuCodeIndex){
	var bigMenuCode                   = bigMenuCodeArray[bigMenuCodeIndex];
	var middleMenuCode                = middleMenuCodeArray[bigMenuCodeIndex][middleMenuCodeIndex];
	var verySmallCategoryDisplayTable = document.getElementById("verySmallCategoryDisplayTable");
	
	verySmallCategoryDisplayTable.style.display = "none";
	
	fnMiddleMenuProductListSmallCategoryList(bigMenuCode, middleMenuCode);
	doSelect(bigMenuCode, middleMenuCode, "", "");
}

function fnSmallCategoryList(bigMenuCode, middleMenuCode, smallCategoryCode){
	var verySmallCategoryDisplayTable = document.getElementById("verySmallCategoryDisplayTable");
	
	if((bigMenuCode == "03") && (middleMenuCode == "03091")){
		fnVerySmallCategoryList(bigMenuCode, middleMenuCode, smallCategoryCode);
	}
	else{
		fnVerySmallCategoryList(bigMenuCode, middleMenuCode, smallCategoryCode);
		verySmallCategoryDisplayTable.style.display = "none";
	}
	
	doSelect(bigMenuCode, middleMenuCode, smallCategoryCode, "");
}

function fnVerySmallCategoryList(bigMenuCode, middleMenuCode, smallCategoryCode){
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6",
		{
			MATERIAL_TYPE      : bigMenuCode,
			MATERIAL_CTRL_TYPE : middleMenuCode,
			MATERIAL_CLASS1    : smallCategoryCode,
			mode               : "selectVerySmallCategoryList"
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			fnVerySmallCategoryListCallback(result, bigMenuCode, middleMenuCode, smallCategoryCode);
		}
	);
}

function fnVerySmallCategoryListCallback(result, bigMenuCode, middleMenuCode, smallCategoryCode){
	var verySmallCategoryTable        = document.getElementById("verySmallCategoryTable");
	var verySmallCategoryDisplayTable = document.getElementById("verySmallCategoryDisplayTable");
	var resultLength                  = result.length;
	var tr                            = null;
	var td                            = null;
	var i                             = 0;
	var display                       = null;
	var code                          = null;
	var text2                         = null;
	
	tr = document.getElementById("verySmallCategoryTr");
	
	if(tr != null){
		verySmallCategoryTable.removeChild(tr);
	}
	
	if(resultLength == 0){
		display = "none";
	}
	else{
		display = "";
		
		tr    = document.createElement("tr");
		tr.id = "verySmallCategoryTr";
		
		for(i = 0; i < resultLength; i++){
			td    = document.createElement("td");
			code  = result[i].code;			
			text2 = result[i].text2;
			
			td.className = "data_td";
			td.innerHTML = "<a href=\"javascript:fnVerySmallProductList('" + bigMenuCode + "', '" + middleMenuCode + "', '" + smallCategoryCode + "', '" + code + "');\">" + text2 + "</a>";
			
			tr.appendChild(td);
		}
		
		verySmallCategoryTable.appendChild(tr);
	}
	
	
	verySmallCategoryDisplayTable.style.display = display;
	
	recal();
}

function fnVerySmallProductList(bigMenuCode, middleMenuCode, smallCategoryCode, verySmallCategoryCode){
	doSelect(bigMenuCode, middleMenuCode, smallCategoryCode, verySmallCategoryCode);
}

function doSelect(materialType, materialCtrlType, materialClass1, materialClass2){
	document.getElementById("MATERIAL_TYPE").value      = materialType;
	document.getElementById("MATERIAL_CTRL_TYPE").value = materialCtrlType;
	document.getElementById("MATERIAL_CLASS1").value    = materialClass1;
	document.getElementById("MATERIAL_CLASS2").value    = materialClass2;
	
    fnList();
}

function fnList(){
	var materialType     = document.getElementById("MATERIAL_TYPE").value;
	var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE").value;
	var materialClass1   = document.getElementById("MATERIAL_CLASS1").value;
	var materialClass2   = document.getElementById("MATERIAL_CLASS2").value;
	var itemNo           = document.getElementById("ITEM_NO").value;
	var descriptionLoc   = document.getElementById("DESCRIPTION_LOC").value;
	var params           = "mode=selectPrUserList";
    
	if(
		(materialType == "") &&
		(materialCtrlType == "") &&
		(materialClass1 == "") &&
		(materialClass2 == "") &&
		(itemNo == "") &&
		(descriptionLoc == "")
	){
		alert("품목 카테고리를 선택하시거나 품목코드, 품목명을 입력하고 조회하여 주시기 바랍니다.");
		
		return;
	}
	
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    
    GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6", params );
    GridObj.clearAll(false);
}

function fnRequest(){
	var rowCount   = GridObj.GetRowCount();
	var checkCount = 0;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length  == 0) {
		alert("선택된 데이터가 없습니다.");
		return;
	}
	
	for(var i = 0; i < grid_array.length; i++) {
		var prQtyColValue     = GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_QTY")).getValue();
		var maxReqCntColValue = GridObj.cells(grid_array[i], GridObj.getColIndexById("MAX_REQ_CNT")).getValue();
		var minReqCntColValue = GridObj.cells(grid_array[i], GridObj.getColIndexById("MIN_REQ_CNT")).getValue();
		
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
		
		checkCount++;
	}
	
	if(checkCount > 0){
		if(confirm("카트에 담으시겠습니까?") == false){
			return;
		}
		
		var params;
		
		params = "?mode=insertSprcartList";
		params += "&cols_ids=<%=grid_col_id%>";
		params += dataOutput();
		
		myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6" + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
	else{
		alert("신청 대상을 선택하여 주십시오.");
	}
}

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	
	var cartColIndex = GridObj.getColIndexById("CART");
	var rowIndex     = GridObj.getRowIndex(rowId);
	
	if(cartColIndex == cellInd){
		var prQtyColIndex     = GridObj.getColIndexById("PR_QTY");
		var selectedColIndex  = GridObj.getColIndexById("SELECTED");
		var itemNoColIndex    = GridObj.getColIndexById("ITEM_NO");
		var maxReqCntColIndex = GridObj.getColIndexById("MAX_REQ_CNT");
		var minReqCntColIndex = GridObj.getColIndexById("MIN_REQ_CNT");
		var rowCount          = GridObj.GetRowCount();
		var prQtyColValue     = GD_GetCellValueIndex(GridObj, rowIndex, prQtyColIndex);
		var itemNoColValue    = GD_GetCellValueIndex(GridObj, rowIndex, itemNoColIndex);
		var maxReqCntColValue = GD_GetCellValueIndex(GridObj, rowIndex, maxReqCntColIndex);
		var minReqCntColValue = GD_GetCellValueIndex(GridObj, rowIndex, minReqCntColIndex);
		
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
		
		if(confirm("카트에 담으시겠습니까?") == false){
			return;
		}
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins6",
			{
				ITEM_NO : itemNoColValue,
				PR_QTY  : prQtyColValue,
				mode    : "insertSprcart"
			},
			function(arg){
				alert(arg);
				fnList();
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
    
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
    	
    	var header_name = GridObj.getColumnId(cellInd);
		    	
		if(header_name == "PR_QTY")   { 
    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
	    		GridObj.cells(rowId, cellInd).setValue("");
				return true;
			}
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
        fnList();
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

function KeyFunction(temp) {
	if(temp == "Enter") {
		if(event.keyCode == 13) {
			fnList();
		}
	}
}
</script>
</head>
<body onload="javascript:fnBodyOnLoad();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<input type="hidden" id="MATERIAL_TYPE"      name="MATERIAL_TYPE"      value="" />
		<input type="hidden" id="MATERIAL_CTRL_TYPE" name="MATERIAL_CTRL_TYPE" value="" />
		<input type="hidden" id="MATERIAL_CLASS1"    name="MATERIAL_CLASS1"    value="" />
		<input type="hidden" id="MATERIAL_CLASS2"    name="MATERIAL_CLASS2"    value="" />
		<font color="red" size="10">* <b>안내장(카드 만 해당)</b>은 포탈내 카드플라자에서 신청해주세요.</font>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" id="categoryTable"></table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display: none;" id="smallCategoryDisplayTable">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" id="smallCategoryTable"></table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display: none;" id="verySmallCategoryDisplayTable">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" id="verySmallCategoryTable"></table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
										<td width="35%" class="data_td">
											<input type="text" id="ITEM_NO" name="ITEM_NO" style="ime-mode:inactive" value="" onkeydown="JavaScript: KeyFunction('Enter');">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td width="35%" class="data_td">
											<input type="text" id="DESCRIPTION_LOC" name="DESCRIPTION_LOC" value="" onkeydown="JavaScript: KeyFunction('Enter');">
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
				<td height="30" align="right" >
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:fnList();","조회");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:fnRequest();","신청");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_036" grid_obj="GridObj" grid_box="gridbox" /> --%>

<s:footer/>
</body>
</html>