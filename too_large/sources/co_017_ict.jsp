<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_CO_017");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "I_CO_017";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	
	String  callback       = request.getParameter("callback");
	boolean isSelectScreen = false;
	
	String	bizNo   = request.getParameter("biz_no");			
	String	bizNm	= request.getParameter("biz_nm");
	
	if(bizNo == null){
		bizNo = "";
	}
	
	if(bizNm == null){
		bizNm = "";
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
	var startChangeDate  = document.getElementById("start_change_date");
	var endChangeDate    = document.getElementById("end_change_date");
	var bizNo      = document.getElementById("biz_no");
	var bizNm      = document.getElementById("biz_nm");
	
	
	if(LRTrim(startChangeDate.value) == "" || LRTrim(endChangeDate.value) == "" ) {
		alert("요청일자를 입력하셔야 합니다.");		
		return;
	}
	
	if(!checkDate(del_Slash(startChangeDate.value))) {
		alert("요청일자를 확인하세요.");		
		startChangeDate.select();		
		return;
	}
	
	if(!checkDate(del_Slash(endChangeDate.value))) {
		alert("요청일자를 확인하세요.");		
		endChangeDate.select();		
		return;
	}
	
    var params = "mode=selectBizList";
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.co.I_CO_017_Servlet", params );
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
	var rowIndex       = GridObj.getRowIndex(rowId);
	var bizNoColIndex  = GridObj.getColIndexById("BIZ_NO");
	var bizNmColIndex  = GridObj.getColIndexById("BIZ_NM");
	var bizNo          = GD_GetCellValueIndex(GridObj, rowIndex, bizNoColIndex);
	var bizNm          = GD_GetCellValueIndex(GridObj, rowIndex, bizNmColIndex);
	
	opener.<%=callback%>(bizNo,bizNm);
	
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
    /*
    if(GridObj.GetRowCount() == 1){
    	doOnRowSelected(GridObj.getRowId(0), "");	
    }
    */
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
			<td align="left" class="title_page">사업명 조회</td>
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
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td width="35%" class="data_td" colspan="3">
											<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="end_change_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>																
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업코드</td>
										<td class="data_td" width="30%">
											<input type="text" id="biz_no" name="biz_no" size="15" class="inputsubmit" style="ime-mode:inactive" onkeydown="javascript:entKeyDown();">
										</td>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명</td>
										<td class="data_td" width="30%">
											<input type="text" name="biz_nm" id="biz_nm" size="20" maxlength="500" class="inputsubmit" onkeydown="javascript:entKeyDown();">
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
									btn("javascript:fnSelect()", "조 회");
								</script>
							</td>
							<td>
								<script language="javascript">
									btn("javascript:window.close()", "닫 기");
								</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="I_CO_017" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>