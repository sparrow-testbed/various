<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EV_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "EV_005";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	String  callback       = request.getParameter("callback");
	boolean isSelectScreen = false;
	
	String	userId		= request.getParameter("userId");			
	String	userName	= request.getParameter("userName");
	
	if(userId == null){
		userId = "";
	}
	
	if(userName == null){
		userName = "";
	}
	
	String to_date          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	String from_date        = "2021/07/01";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
function fnBodyOnLoad(){
	setGridDraw();
	fnSelect();
}

function fnSelect(){
    var f0 = document.forms[0];

	if(!checkDateCommon(del_Slash(f0.from_date.value))) {
		alert("생성일자(From)를 확인 하세요 ");
		f0.from_date.focus();
		return;
	}

	if(!checkDateCommon(del_Slash(f0.to_date.value))) {
		alert("생성일자(To)를 확인 하세요 ");
		f0.to_date.focus();
		return;
	}
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=getEvalSheetList&grid_col_id="+grid_col_id;
	param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";
	GridObj.post(url, param);
	GridObj.clearAll(false);
}

function entKeyDown(){
	if(event.keyCode==13) {
		fnSelect();
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
function doOnRowSelected(rowId, cellInd){
	var header_name = GridObj.getColumnId(cellInd);
	var url = '';
	var param = '';
	
	if( header_name == "ES_CD" ) {
		var url = "/kr/ev/ts_sheet_view.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&es_cd="+SepoaGridGetCellValueId(GridObj, rowId, "ES_CD");
		param += "&es_ver="+SepoaGridGetCellValueId(GridObj, rowId, "ES_VER");
		PopupGeneral(url+param, "평가상세", "", "", "925", "800");
	}  
	
	var grid_array = getGridChangedRows(GridObj, "selected");
	var rowcount = grid_array.length;
	//GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		GridObj.cells(grid_array[row], GridObj.getColIndexById("selected")).setValue(0);
		GridObj.cells(grid_array[row], GridObj.getColIndexById("selected")).cell.wasChanged = false;
    }	
	
	
	GridObj.cells( rowId, GridObj.getColIndexById("selected")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("selected")).cell.wasChanged = true;
}

/////////////////////////////////////////////
//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "selected");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}

function doSelected()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "selected");

	var ES_CD = "";
	var ES_VER = "";
	var ES_NM = "";
	var CSKD_GB = "";
	var CSKD_GB_NM = "";
	
	for(var i = 0; i < grid_array.length; i++)
	{
		ES_CD = GridObj.cells(grid_array[i], GridObj.getColIndexById("ES_CD")).getValue();
		ES_VER = GridObj.cells(grid_array[i], GridObj.getColIndexById("ES_VER")).getValue();
		ES_NM = GridObj.cells(grid_array[i], GridObj.getColIndexById("ES_NM")).getValue();
		CSKD_GB = GridObj.cells(grid_array[i], GridObj.getColIndexById("CSKD_GB")).getValue();
		CSKD_GB_NM = GridObj.cells(grid_array[i], GridObj.getColIndexById("CSKD_GB_NM")).getValue();		
	}
	
	opener.<%=callback%>(
			ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM
	);
	
	window.close();
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
    	if(GridObj.getColIndexById("selected") == cellInd){
			for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
				GridObj.cells(GridObj.getRowId(i), cellInd).setValue("0");			
			}
		}
    	GridObj.cells(rowId, cellInd).setValue("1");
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
    
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();" >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">평가표 선택</td>
		</tr>
	</table>

	<form name="form1" action="">
	    <input type="hidden" id="ev_gb" name="ev_gb" value="T"/>
		<input type="hidden" id="from_date" name="from_date" value="<%=from_date %>"/>
		<input type="hidden" id="to_date" name="to_date" value="<%=to_date %>"/>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>				
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<table cellpadding="0">
						<tr>
							<td>
<script language="javascript">
btn("javascript:fnSelect()", "조 회");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:doSelected()", "선 택");
</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="EV_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>