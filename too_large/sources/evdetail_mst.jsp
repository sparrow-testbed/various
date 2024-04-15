<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_202");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_202";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">
var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.evdetail_mst";
var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function initAjax(){
	doRequestUsingPOST( 'W202', '<%=to_day.substring(0,4)%>' ,'p_ev_gubun', '' );
}
	
function setGridDraw(){
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
}
	
function doOnRowSelected(rowId,cellInd){
	//alert("doOnRowSelected");
}
	
function doOnCellChange(stage,rowId,cellInd){
	//alert("doOnCellChange");
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

//그리드의 선택된 행의 존재 여부를 리턴
function checkRows(){
	var i                = 0;
	var rowCount         = GridObj.GetRowCount();
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	var isSelected       = false;
	
	for(i = 0; i < rowCount; i++){
		if(GD_GetCellValueIndex(GridObj, i, selectedColIndex) == true){
			isSelected = true;
			
			break;
		}
	}
	
	if(isSelected == false){
		alert("<%=text.get("MESSAGE.1004")%>");
	}
	
	return isSelected;
}
	
//조회
function doQuery(){
	var grid_col_id    = "<%=grid_col_id%>";
	var form        = document.forms[0];
	var p_ev_gubun	= LRTrim(form.p_ev_gubun.value); // 평가항목대분류명
	var p_use_yn	= LRTrim(form.p_use_yn.value);   // 사용여부
		
	if( form.p_ev_gubun.length == "1" ){
		alert("평가항목관리대분류를 먼저 등록 해주십시요.");
		
		return;
	}
		
	var param    = "?mode=query&cols_ids="+grid_col_id;
	
	param += dataOutput();

	GridObj.post(G_SERVLETURL+param);
	GridObj.clearAll(false);
}
	
//조회후 뒷처리
function doQueryEnd(GridObj, RowCnt){
	var msg    = GridObj.getUserData("", "message");
	var status = GridObj.getUserData("", "status");
		
	if(status == "false"){
		alert(msg);
	}
	
	return true;
}
    			
//저장
function doInsert(){
	if( !checkRows() ){
		return;
	}
	
	var form       = document.forms[0];
	var p_ev_gubun = LRTrim(form.p_ev_gubun.value); // 평가항목대분류명		
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for( var i = 0; i < grid_array.length; i++ ){
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NAME")).getValue()) == ""){
			alert('평가항목대분류명은 필수입력입니다.');
			
			return;
		}
	}
		
	if (confirm("<%=text.get("MESSAGE.1018")%>")){
		var cols_ids    = "<%=grid_col_id%>";
		var param       = "?mode=insert&cols_ids="+cols_ids;
		
		param += dataOutput();
		
		myDataProcessor = new dataProcessor(G_SERVLETURL + param);
		    
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}		
}
	
//저장후 뒷처리
function doSaveEnd(obj) {
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	
	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;
	
	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}
		
	if(status == "true"){
		doQuery();
	}
	else{
		alert(messsage);
	}

	return false;
}
	
//삭제
function doDelete(){
	if( !checkRows() ){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	for( var i = 0; i < grid_array.length; i++ ){
		if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("NAME")).getValue()) == ""){
			alert('평가항목대분류명은 필수입력입니다.');
			
			return;
		}
	}
	
	if( confirm("<%=text.get("MESSAGE.1015")%>") ){
		var cols_ids    = "<%=grid_col_id%>";
		
		param           = "?mode=delete&cols_ids="+cols_ids;
		myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			
		sendTransactionGrid( GridObj, myDataProcessor, "SELECTED", grid_array );
	}	
}
	
//행삽입
function doAddRow(){
	var form = document.forms[0];
	
	if( form.p_ev_gubun.length == "1" ){
		alert("평가항목관리대분류를 먼저 등록 해주십시요.");
		
		return;
	}		
	
	if( form.p_ev_gubun.value == "" ){
		alert("등록할 평가항목대분류명을 선택하여 주십시요.");
		form.p_ev_gubun.focus();
		
		return;
	}
		
	var newId = (new Date()).valueOf();
	
	GridObj.addRow(newId,"");
	GridObj.selectRowById(newId, false, true);
	
	GridObj.cells(newId, GridObj.getColIndexById("SELECTED") ).cell.wasChanged = true;
	GridObj.cells(newId, GridObj.getColIndexById("SELECTED") ).setValue("1");
	GridObj.cells(newId, GridObj.getColIndexById("NAME")     ).setValue("");
	GridObj.cells(newId, GridObj.getColIndexById("USEFLAG")  ).setValue("Y");
	GridObj.cells(newId, GridObj.getColIndexById("CODE")     ).setValue("");
	GridObj.cells(newId, GridObj.getColIndexById("TYPE")     ).setValue("");
	GridObj.cells(newId, GridObj.getColIndexById("ADD_DATE") ).setValue("");				
}
    
//행삭제
function doDeleteRow(){
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount   = grid_array.length;
	
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--){
		if( "1" == GridObj.cells(grid_array[row], 0).getValue() ) 	GridObj.deleteRow(grid_array[row]);
	}
}		
</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="initAjax();setGridDraw();">
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<form name="form" method="post" action="">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5"></td>
			</tr>
			<tr>
				<td width="100%" valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
						<tr>
							<td width="20%" height="24" class="se_cell_title">
								<%=text.get("WO_202.ev_name")%>
							</td>
							<td width="30%" height="24" class="se_cell_data">
								<select name="p_ev_gubun" id="p_ev_gubun" class="input_submit">
									<option value="">전체</option>
								</select>
							</td>
							<td width="20%" height="24" class="se_cell_title">
								<%=text.get("WO_202.USEFLAG")%>
							</td>
							<td width="30%" height="24" class="se_cell_data">
								<select name="p_use_yn" id="p_use_yn" class="input_submit">
									<option value="">전체</option>
									<option value="Y">Y</option>
									<option value="N">N</option>
								</select>
							</td>
						</tr>
					</table>
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td style="padding:5 5 5 0" align="right">
								<table cellpadding="2" cellspacing="0">
									<tr>
										<td>
<script language="javascript">
	btn("doQuery()"    , "<%=text.get("BUTTON.search")%>");
</script>
										</td>
										<td>
<script language="javascript">
	btn("doInsert()"   , "<%=text.get("BUTTON.insert")%>");
</script>
										</td>
										<td>
<script language="javascript">
	btn("doDelete()"   , "<%=text.get("BUTTON.deleted")%>");
</script>
										</td>
										<td>
<script language="javascript">
	btn("doAddRow()"   , "<%=text.get("BUTTON.rowinsert")%>");
</script>
										</td>
										<td>
<script language="javascript">
	btn("doDeleteRow()", "행삭제");
</script>
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
</s:header>
<s:grid screen_id="WO_202" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>