<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_243_r");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_243_r";
	String grid_obj  = "GridObj";
	String G_IMG_ICON = "/images/ico_zoom.gif";
	boolean isSelectScreen = false;

 	String WISEHUB_PROCESS_ID="RQ_243_r";
	String mode = JSPUtil.nullToEmpty(request.getParameter("mode"));
	String szRow = JSPUtil.nullToEmpty(request.getParameter("szRow"));

	String[] VENDOR_CODE = null;
	String[] VENDOR_NAME = null;
	String[] DIS = null;
	String[] NO = null;
	String[] NAME = null;			

	//생성화면에서....조회
	if(mode.equals("S")) { 
		String rfq_no    = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
		String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
		String rfq_seq   = JSPUtil.nullToEmpty(request.getParameter("rfq_seq"));
        String bid_flag  = JSPUtil.nullToEmpty(request.getParameter("bid_flag"));

		Object[] obj = {rfq_no, rfq_count, rfq_seq, bid_flag};
		SepoaOut value = ServiceConnector.doService(info, "p1005", "CONNECTION", "getVendorList", obj);

		SepoaFormater wf = new SepoaFormater(value.result[0]);
		
		if(wf != null) {
			if(wf.getRowCount() > 0) { //데이타가 있는 경우
				VENDOR_CODE = new String[wf.getRowCount()];
				VENDOR_NAME = new String[wf.getRowCount()];
				DIS = new String[wf.getRowCount()];
				NO = new String[wf.getRowCount()];
				NAME = new String[wf.getRowCount()];

				int n;
				for(int i=0; i<wf.getRowCount(); i++) {
					n = 0;

					VENDOR_CODE[i] = wf.getValue("VENDOR_CODE",i);
					VENDOR_NAME[i] = wf.getValue("VENDOR_NAME",i);
					DIS[i]         = wf.getValue("DIS",i);
					NO[i]          = wf.getValue("NO",i);
					NAME[i]        = wf.getValue("NAME",i);
				}
			}
		}

	}
	else if(mode.equals("R") || mode.equals("M")) {
		String rfq_no    = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
		String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
		String bid_flag  = JSPUtil.nullToEmpty(request.getParameter("bid_flag"));

		Object[] obj = {rfq_no, rfq_count, bid_flag};

		SepoaOut value = ServiceConnector.doService(info, "p1005", "CONNECTION", "re_getVendorList_all", obj);
		
		SepoaFormater wf = new SepoaFormater(value.result[0]);
		
		if(wf != null) {
			if(wf.getRowCount() > 0) { //데이타가 있는 경우
				VENDOR_CODE = new String[wf.getRowCount()];
				VENDOR_NAME = new String[wf.getRowCount()];
				DIS         = new String[wf.getRowCount()];
				NO          = new String[wf.getRowCount()];
				NAME        = new String[wf.getRowCount()];

				for(int i=0; i<wf.getRowCount(); i++) {
					VENDOR_CODE[i] = wf.getValue("VENDOR_CODE",i);
					VENDOR_NAME[i] = wf.getValue("VENDOR_NAME",i);
					DIS[i]         = wf.getValue("DIS",i);
					NO[i]          = wf.getValue("NO",i);
					NAME[i]        = wf.getValue("NAME",i);
				}
			}
		}

	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">
var mode;

var IDX_SEL;
var IDX_VENDOR_CODE;
var IDX_VENDOR_NAME;
var IDX_DIS;
var IDX_NO;
var IDX_NAME;
var IDX_MOBILE_NO;
var IDX_EMAIL;

function setHeader() {
	IDX_SEL 		= GridObj.GetColHDIndex("SEL");
	IDX_VENDOR_CODE = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME = GridObj.GetColHDIndex("VENDOR_NAME");
	IDX_DIS 		= GridObj.GetColHDIndex("DIS");
	IDX_NO 			= GridObj.GetColHDIndex("NO");
	IDX_NAME 		= GridObj.GetColHDIndex("NAME");

	init();
}

function init() {
<%
	if(VENDOR_CODE != null)	{
		for(int i=0; i<VENDOR_CODE.length; i++) {
%> //조회


	/* GridObj.selectRowById(i, false, true);
	GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(i, GridObj.getColIndexById("USER_POP")).setValue("/images/icon/detail.gif");
	GridObj.cells(i, GridObj.getColIndexById("SIGN_PATH_SEQ")).setValue(nMaxRow2); 
	GridObj.cells(i, GridObj.getColIndexById("PROCEEDING_FLAG")).setValue("P");  */
	

	GridObj.addRow("<%=i%>","");
	rightrowcount = GridObj.GetRowCount() - 1;
	GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_CODE, "<%=VENDOR_CODE[i]%>");
	GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_NAME, "<%=VENDOR_NAME[i]%>");
	GD_SetCellValueIndex(GridObj,rightrowcount, IDX_DIS, "<%=DIS[i]%>");
	GD_SetCellValueIndex(GridObj,rightrowcount, IDX_NO, "<%=NO[i]%>");
	GD_SetCellValueIndex(GridObj,rightrowcount, IDX_NAME, "<%=NAME[i]%>"); 
<%
		}
	}
	else{
%>
	if("E" == "<%=mode%>") { //입력
	}
	else if("I" == "<%=mode%>") {
		//입력후 수정 (품목번호별로 가져오기)
		value = parent.opener.getCompany("<%=szRow%>");
		
		if(value != null) {
			if(LRTrim(value) != "") {
				var m_values = value.split("#");

				for(i=0; i<m_values.length; i++) {
					if(m_values[i] != "") {
						var m_data = m_values[i].split("@");

						VENDOR_CODE = $.trim(m_data[0]);
						VENDOR_NAME = $.trim(m_data[1]);
						NAME 		= $.trim(m_data[2]);
						
						var newRowId = (new Date()).valueOf() + i;
						GridObj.addRow(newRowId, "");

						rightrowcount = GridObj.GetRowCount() - 1;

						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_SEL,  "true");
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_CODE, VENDOR_CODE);
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_NAME, VENDOR_NAME);
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_NAME, NAME);
					}
				}
			}
		}
	}
	else if("A" == "<%=mode%>") {
		value = parent.opener.getAllCompany();

		if(value != null) {
			if(LRTrim(value) != "") {
				var m_values = value.split("#");

				for(i=0; i<m_values.length; i++) {
					if(m_values[i] != "") {
						var m_data = m_values[i].split("@");
						
						VENDOR_CODE = $.trim(m_data[0]);
						VENDOR_NAME = $.trim(m_data[1]);
						NAME 		= $.trim(m_data[2]);
						
						var newRowId = (new Date()).valueOf() + i;
						GridObj.addRow(newRowId, "");

						rightrowcount = GridObj.GetRowCount() - 1;

						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_CODE, VENDOR_CODE);
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_VENDOR_NAME, VENDOR_NAME);
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_NAME, NAME);
						GD_SetCellValueIndex(GridObj,rightrowcount, IDX_SEL,  "true");
					}
				}
			}
		}
	}

<%
	}
%>
}

function leftArrow() {
	var leftGirdObj  = parent.leftFrame.GridObj;
	
	transVendorInfo(leftGirdObj, GridObj);
}

function rightArrow() {
	var leftGirdObj  = parent.leftFrame.GridObj;
	
	transVendorInfo(GridObj, leftGirdObj);
}

function transVendorInfo(sourceGrid, targetGrid){
	var sourceRowCount       = sourceGrid.GetRowCount();
	var targetRowCount       = targetGrid.GetRowCount();
	var rowIndex             = 0;
	var isSourceGridSelected = false;
	var vendorCode           = null;
	var vendorName           = null;
	var dis                  = null;
	var no                   = null;
	var flag                 = true;
	var i                    = 0;
	var trimVendorCode       = null;
	var trimTargetVendorCode = null;
	var newTargetId          = null;
	var newTargetRowIndex    = 0;
	var sourceGridRowId      = null;
	
	for(rowIndex = (sourceRowCount - 1); rowIndex >= 0; rowIndex--) {
		isSourceGridSelected = GD_GetCellValueIndex(sourceGrid, rowIndex, "0");
		
		if(isSourceGridSelected == true) {
			vendorCode     = sourceGrid.GetCellValue(sourceGrid.GetColHDKey(IDX_VENDOR_CODE), rowIndex); //업체코드
			vendorName     = sourceGrid.GetCellValue(sourceGrid.GetColHDKey(IDX_VENDOR_NAME), rowIndex); //업체명
			dis            = sourceGrid.GetCellValue(sourceGrid.GetColHDKey(IDX_DIS),         rowIndex); //업종
			no             = sourceGrid.GetCellValue(sourceGrid.GetColHDKey(IDX_NO),          rowIndex); //사업자번호
			flag           = true;
			trimVendorCode = LRTrim(vendorCode);
			
			for(i = 0; i < targetRowCount; i++) {
				trimTargetVendorCode = GD_GetCellValueIndex(targetGrid, i, IDX_VENDOR_CODE);
				trimTargetVendorCode = LRTrim(trimTargetVendorCode);
				
				if(trimVendorCode == trimTargetVendorCode) {
					flag = false;
					
					break;
				}
			}

			if(flag) {
				newTargetId = (new Date()).valueOf();
				
				targetGrid.addRow(newTargetId, "");
				
				targetRowCount    = targetGrid.GetRowCount();
				newTargetRowIndex = targetRowCount - 1;
				
				GD_SetCellValueIndex(targetGrid, newTargetRowIndex, IDX_VENDOR_CODE, vendorCode);
				GD_SetCellValueIndex(targetGrid, newTargetRowIndex, IDX_VENDOR_NAME, vendorName);
				GD_SetCellValueIndex(targetGrid, newTargetRowIndex, IDX_DIS,         dis);
				GD_SetCellValueIndex(targetGrid, newTargetRowIndex, IDX_NO,          no);
				GD_SetCellValueIndex(targetGrid, newTargetRowIndex, IDX_SEL,         "true");
			}
			
			sourceGridRowId = sourceGrid.getRowId(rowIndex);
			
			sourceGrid.deleteRow(sourceGridRowId);
		}
	}
}

function doSave() {
	linecount = 0;
	VENDOR_SELECTED = "";
	rightrowcount = GridObj.GetRowCount();

	for(row = rightrowcount-1; row >= 0; row--) {
		linecount++;

		VENDOR_CODE = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_VENDOR_CODE),row); //업체코드
		VENDOR_NAME = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_VENDOR_NAME),row); //업체명
		DIS = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_DIS),row); //업종
		NO = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_NO),row); //사업자번호
		NAME = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_NAME),row); //NAME

		VENDOR_SELECTED += VENDOR_CODE + " @";
		VENDOR_SELECTED += VENDOR_NAME + " @";
		VENDOR_SELECTED += NAME + " @";
		VENDOR_SELECTED += "#";
	}

	parent.opener.vendorInsert("<%=szRow%>", VENDOR_SELECTED, linecount);
	parent.window.close();
}
function JavaCall(msg1,msg2,msg3,msg4,msg5){}

var GridObj = null;
var MenuObj = null;
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

    if(status == "true") {
        alert(messsage);
        doQuery();
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
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true" >
	<form name="form1" method="post" action="">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" width="40%">
					&nbsp;&nbsp;
					<img src="/images/button/butt_arrow1_.gif" border="0" alt="" style="cursor: pointer;" onclick="javascript:leftArrow();">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<br>
					<br>
					&nbsp;&nbsp;
					<img src="/images/button/butt_arrow2_.gif" border="0" alt="" style="cursor: pointer;" onclick="javascript:rightArrow();">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</td>
				<td width="60%" align="right">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table width="50%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td align="left" class="title_page">견적업체대상</td>
									</tr>
								</table>
							</td>
							<td rowspan="2" width="50%">&nbsp;
							</td>
						</tr>
						<tr>
							<td align="left" width="50%">
<!-- 								<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div> -->
								
								<s:grid screen_id="RQ_243_r" grid_obj="GridObj" grid_box="gridbox" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:doSave()", "선 택");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:parent.window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<p>
		&nbsp;
	</p>
</s:header>
<s:footer/>
</body>
</html>


