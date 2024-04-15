<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String getDateSlashFormat(String target) throws Exception{
	String       result       = null;
	StringBuffer stringBuffer = new StringBuffer();
	
	stringBuffer.append(target.subSequence(0, 4)).append("/").append(target.substring(4, 6)).append("/").append(target.substring(6, 8));
	
	result = stringBuffer.toString();
	
	return result;
}
%>
<%
	Vector  multilang_id       = new Vector();
	HashMap text               = null;
	String  screen_id          = "SO_006";
	String  grid_obj           = "GridObj";
	String  G_IMG_ICON         = "/images/ico_zoom.gif";
	String  WISEHUB_PROCESS_ID = "SO_006";
    String  HOUSE_CODE         = info.getSession("HOUSE_CODE");
    String  COMPANY_CODE       = info.getSession("COMPANY_CODE");
    String  CTRL_CODE          = info.getSession("CTRL_CODE");
    String  dNameLoc           = JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"));
    String  depart             = JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	boolean isSelectScreen     = false;
	isRowsMergeable            = true;

	multilang_id.addElement("SO_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	text = MessageUtil.getMessage(info, multilang_id);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var mode;
	
function Init() {	//화면 초기설정
	setGridDraw();
	doSelect();	
}

function doSelect(){
	var params = "mode=selectSoList";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis3", params);
	GridObj.clearAll(false);
}

function fnComplete(){
	var rowCount         = GridObj.GetRowCount();
	var chkCount         = 0;
	var i                = 0;
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	var osqFlagColIndex  = GridObj.getColIndexById("OSQ_FLAG");
	var selectedColValue = null;
	var osqFlagColValue  = null;
	var url              = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis3";
	var grid_array       = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	if(grid_array.length > 1) {
		alert("하나의 항목만 선택해주세요.");
		return;
	}
	
	for(var i = 0; i < grid_array.length; i++) {
		var osq_flag 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("OSQ_FLAG")).getValue();
		
		if(osq_flag != "E"){
			if(osq_flag == "P") {
				alert("업체에서 제출을 하지 않은 상태입니다.");
			} else {
				alert("실사진행 항목만 처리 가능합니다.");
			}
			return;
		}
	}
	
	if(confirm("실사완료 하시겠습니까?") == false){
		return;
	}
	
	url = url + "?mode=updateComplete";
	url = url + "&cols_ids=<%=grid_col_id%>";
	url = url + dataOutput();
	
	myDataProcessor = new dataProcessor(url);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function fnUnComplete(){
	var rowCount         = GridObj.GetRowCount();
	var chkCount         = 0;
	var i                = 0;
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	var prProceedingFlagColIndex  = GridObj.getColIndexById("PR_PROCEEDING_FLAG");
	var selectedColValue = null;
	var prProceedingFlagColValue  = null;
	var url              = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis3";
	var grid_array       = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	if(grid_array.length > 1) {
		alert("하나의 항목만 선택해주세요.");
		return;
	}	
	
	for(var i = 0; i < grid_array.length; i++) {
		var osq_flag 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("OSQ_FLAG")).getValue();
		
		if(osq_flag != "E"){
			if(osq_flag == "P") {
				alert("업체에서 제출을 하지 않은 상태입니다.");
			} else {
				alert("실사진행 항목만 처리 가능합니다.");
			}
			return;
		}
	}
	
// 	for(i = 0; i < rowCount; i++){
// 		selectedColValue = GD_GetCellValueIndex(GridObj, i, selectedColIndex);
// 		prProceedingFlagColValue  = GD_GetCellValueIndex(GridObj, i, prProceedingFlagColIndex);
		
// 		if(selectedColValue == true){
// 			chkCount++;
			
// 			if(prProceedingFlagColValue != "Y"){
// 				alert("실사완료 취소가 불가한 상태입니다.");
				
// 				return;
// 			}
// 		}
// 	}
	
// 	if(chkCount == 0){
// 		alert("선택하신 항목이 없습니다.");
		
// 		return;
// 	}
	
	if(confirm("완료취소 하시겠습니까?") == false){
		return;
	}
	
	url = url + "?mode=updateUnComplete";
	url = url + "&cols_ids=<%=grid_col_id%>";
	url = url + dataOutput();
	
	myDataProcessor = new dataProcessor(url);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

//실사반려
function fnReject(){
	var rowCount         = GridObj.GetRowCount();
	var chkCount         = 0;
	var i                = 0;
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	var prProceedingFlagColIndex  = GridObj.getColIndexById("PR_PROCEEDING_FLAG");
	var selectedColValue = null;
	var prProceedingFlagColValue  = null;
	var url              = "<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_lis3";
	var grid_array       = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	for(var i = 0; i < grid_array.length; i++) {
		var osq_flag 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("OSQ_FLAG")).getValue();
		
		if(osq_flag != "E"){
			if(osq_flag == "P") {
				alert("업체에서 제출을 하지 않은 상태입니다.");
			} else {
				alert("실사진행 항목만 처리 가능합니다.");
			}
			return;
		}
	}
	
	if(confirm("실사반려 하시겠습니까?") == false){
		return;
	}
	
	url = url + "?mode=updateReject";
	url = url + "&cols_ids=<%=grid_col_id%>";
	url = url + dataOutput();
	
	myDataProcessor = new dataProcessor(url);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function grid_rowspan(col_num,col_name){
    var cnt = 0;
    var temp1 = "";
    var temp2 = "";
    var col_num_cnt = col_num.split(",");
    var col_name_cnt = col_name.split(",");
    
    for(var i = 1; i < dhtmlx_last_row_id+1; i++){
		cnt = 0;
		temp1 = "";

		for( var k = 0 ; k < col_name_cnt.length ; k++){
			temp1 += LRTrim(GridObj.cells(i, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
		}

		//해당 필드의 똑같은 데이타를 가지고 있는 로우의 갯수를 셈.
		for(var j = i; j < dhtmlx_last_row_id+1; j++){
			temp2 = "";
			
			for( var k = 0 ; k < col_name_cnt.length ; k++){
				temp2 += LRTrim(GridObj.cells(j, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
			}

			if(temp1 == temp2){
				cnt = cnt + 1;
				
				if(temp1 == "" && temp2 == ""){
					cnt = 1;
				}
			}
		}

		//그 row수만 큼 span. 
		for(var m = 0; m<col_num_cnt.length; m++){
			for(var n = Number(col_num_cnt[m].split("-")[0]); n <= Number(col_num_cnt[m].split("-")[1]); n++){
				GridObj.setRowspan(i,n,cnt);// 줄 / 칸 / 갯수
			} 
		}

		i = i + cnt - 1;
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
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "OSQ_NO" ) {
		
	    var osq_no    = SepoaGridGetCellValueId( GridObj, rowId, "OSQ_NO" );
	    var osq_count = SepoaGridGetCellValueId( GridObj, rowId, "OSQ_COUNT" );
	    
	    var url    = 'sos_bd_dis1.jsp';
	    var title  = '실사요청상세조회';
	    var param  = 'OSQ_NO=' + osq_no;
	    param     += '&OSQ_COUNT=' + osq_count;
	    
	    popUpOpen01(url, title, '1024', '650', param);
    
	} else if( header_name == "VENDOR_NAME" ) {
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
		
	} else if( header_name == "ITEM_NO" ) {
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	} else if( header_name == "ATTACH_NO" ){
   	 	var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
   	    //var attach_cnt = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_CNT")).getValue();
   	 	//alert(attach_cnt)
   	 	if(attach_no != ""){
   			var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
       	 	var b = "fileDown";
       	 	var c = "300";
       	 	var d = "100";
       	 
       	 	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
   	 	}
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
    
    grid_rowspan("26-29", "SELECTED,OSQ_NO,OSQ_COUNT");
    
    grid_rowspan("9-13", "SELECTED,OSQ_NO,OSQ_COUNT,PR_SEQ");
    
    grid_rowspan("0-2,5-7", "SELECTED,OSQ_NO,OSQ_COUNT");
    
    return true;
}
</script>
</head>
<body onload="javascript:Init();"  bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">	
		<%@ include file="/include/sepoa_milestone.jsp" %>
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
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
				<td width="35%" class="data_td">
					<s:calendar id="startDate" default_value="<%=this.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(), -7)) %>" format="%Y/%m/%d"/>
					~
					<s:calendar id="endDate" default_value="<%=this.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d"/>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
				<td class="data_td">
					<select id="osqFlag" name="osqFlag" class="inputsubmit">
						<option value="" selected><b>전체</b></option>
						<option value="T">작성중</option>
						<option value="P">실사요청</option>
						<option value="D">실사포기</option>
						<option value="E">실사진행</option>
						<option value="C">실사완료</option>
						<option value="R">실사반려</option>
					</select>
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
				<td height="30" align="left">
					<TABLE cellpadding="0">
						<TR></TR>
					</TABLE>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">btn("javascript:doSelect()","조 회");</script>
							</TD>
							<TD>
								<script language="javascript">btn("javascript:fnComplete()","완 료");</script>
							</TD>
<!-- 							<TD> -->
<%-- 								<script language="javascript">btn("javascript:fnUnComplete()","완료취소");</script> --%>
<!-- 							</TD> -->
							<TD>
								<script language="javascript">btn("javascript:fnReject()","반 려");</script>
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
<%-- <s:grid screen_id="SO_006" grid_obj="GridObj" grid_box="gridbox" row_mergeable="true"/> --%>

<s:footer/>
</body>
</html>