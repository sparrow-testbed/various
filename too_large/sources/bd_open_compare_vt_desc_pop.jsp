<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_016_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "BD_016_2";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	
	
	String ctrl_code = info.getSession("CTRL_CODE");

	String menu_type = "";
	if (ctrl_code.startsWith("P01") || ctrl_code.startsWith("P02")) {
		menu_type = "ADMIN";
	} else {
		menu_type = "NORMAL";
	}

	
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	
	String  BID_NO       = request.getParameter("bid_no");
	String  BID_COUNT       = request.getParameter("bid_count");
	String  VOTE_COUNT       = request.getParameter("vote_count");
	String  VENDOR_CODE       = request.getParameter("vendor_code");
	String  VENDOR_NAME       = request.getParameter("vendor_name");
	boolean isSelectScreen = false;
	
    if(!"ADMIN".equals(menu_type)){
    	if( !info.getSession("COMPANY_CODE").equals(VENDOR_CODE) ){
%>
			<script language="javascript" type="text/javascript">
				alert("접근권한이 없습니다.");
				self.close();
			</script>
<%
			return;
    	}
    }
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
	var params = "mode=getBdUnitDetail";
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_open_compare", params );                                                    
    GridObj.clearAll(false);    
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
	var rowIndex       = GridObj.getRowIndex(rowId);
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

    if(GridObj.GetRowCount() == 1){
    	doOnRowSelected(GridObj.getRowId(0), "");	
    }
    
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
			<td align="left" class="title_page">입찰단가 상세</td>
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
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고번호</td>
										<td class="data_td" width="30%">
											<%=BID_NO%>
										</td>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;투찰차수</td>
										<td class="data_td" width="30%">
											<%=VOTE_COUNT%>(차)
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명</td>
										<td class="data_td" width="80%" colspan=3>
											<Script language="javascript" type="text/javascript">
												document.write(decodeUrl("<%=VENDOR_NAME%>"));														
											</script>							
										</td>
									</tr>										
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>

	<form name="form1" action="">
	<input type="hidden" name="BID_NO" id="BID_NO" value="<%=BID_NO%>">
    <input type="hidden" name="BID_COUNT" id="BID_COUNT" value="<%=BID_COUNT%>">
    <input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" value="<%=VOTE_COUNT%>">
    <input type="hidden" id="VENDOR_CODE" 	name="VENDOR_CODE" 		value="<%=VENDOR_CODE%>">

    
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="BD_016_2" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>