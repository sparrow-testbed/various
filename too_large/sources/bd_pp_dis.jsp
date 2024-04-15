<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_014_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_014_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="BD_014_1";
	String BID_NO 		= JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
	String BID_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("BID_COUNT"));
	String VOTE_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("VOTE_COUNT"));

	
	String currentDateTime		= SepoaDate.getShortDateString() + SepoaDate.getShortTimeString();
	String BID_OPEN_DATE_VALUE 	= JSPUtil.nullToRef(request.getParameter("BID_OPEN_DATE_VALUE"), currentDateTime);
	
	boolean isVendorView = false;
	
	if(Long.parseLong(BID_OPEN_DATE_VALUE) <= Long.parseLong(currentDateTime)){
		isVendorView = true;
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
//<!--
var mode;

function Init(){
	setGridDraw();
	setHeader();;
	
	<%
	if(!isVendorView){
	%>
		GridObj.setColumnHidden(GridObj.getColIndexById("BID_VEN_STATUS4"), true);
	<%
	}
	%>
	//GD_setProperty(document.WiseGrid);
}

function setHeader() {
	/* GridObj.SetColCellSortEnable("VENDOR_CODE",false);
	GridObj.SetColCellSortEnable("VENDOR_NAME",false);
	GridObj.SetColCellSortEnable("BID_FLAG",false); */
	
	doSelect();
}

function doSelect() {
	<%-- servletUrl = "<%=getWiseServletPath("dt.rfq.rfq_pp_dis7")%>"; --%>
	G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_open_list";
	<%-- GridObj.SetParam("mode", "getVendorDisplay");
	GridObj.SetParam("rfq_no", "<%=rfq_no%>");
	GridObj.SetParam("rfq_count", "<%=rfq_count%>");
	GridObj.SetParam("rfq_seq", "<%=rfq_seq%>");

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl); --%>
		
	var grid_col_id = "<%=grid_col_id%>";
	var params = "mode=getVendor";
	params += "&cols_ids=" + grid_col_id;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}
	
function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery") {}
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
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" >
		<input type = "hidden" name="BID_NO" 		id="BID_NO"       	value="<%=BID_NO%>">
		<input type = "hidden" name="BID_COUNT" 	id="BID_COUNT" 		value="<%=BID_COUNT%>">
		<input type = "hidden" name="VOTE_COUNT" 	id="VOTE_COUNT"     value="<%=VOTE_COUNT%>">

		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>참여업체</span>
				</td>
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰번호</td>
										<td class="data_td">
											<b><%=BID_NO%></b>
										</td>
									</tr>
								</table>
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
<s:grid screen_id="BD_014_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>