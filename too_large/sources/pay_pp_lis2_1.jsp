<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
    String to_day       = SepoaDate.getShortDateString(); 
	String from_date    = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_year      = SepoaDate.getYear()+"";
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String jumjumCd     = JSPUtil.nullToEmpty(request.getParameter("jumjumcd"));
	String jumjumNm     = JSPUtil.nullToEmpty(request.getParameter("jumjumnm"));
	String pmkpmkCd     = JSPUtil.nullToEmpty(request.getParameter("pmkpmkcd"));
	String pmkpmkNm     = JSPUtil.nullToEmpty(request.getParameter("pmkpmknm"));	
	String p_row_id     = JSPUtil.nullToEmpty(request.getParameter("p_row_id"));	
// 	String p_cell_ind   = JSPUtil.nullToEmpty(request.getParameter("p_cell_ind"));	
	
	Vector multilang_id = new Vector();
	
	multilang_id.addElement("TX_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text     = MessageUtil.getMessage(info,multilang_id);
	String  language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String  screen_id      = "TX_007";
	String  grid_obj       = "GridObj";
	boolean isSelectScreen = false; // 조회용 화면인지 데이터 저장화면인지의 구분
	
	isRowsMergeable = true; // 화면에 행머지기능을 사용할지 여부의 구분
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
<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
function Init(){
	setGridObj(GridObj);
	setGridDraw();
	doSelect();
}
	
function setGridObj(arg) {
	GridObj = arg;
}
	
function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

function doMoveRowUp(){ // 위로 행이동 시점에 이벤트 처리해 줍니다.
	GridObj.moveRow(GridObj.getSelectedId(),"up");
}

// 아래로 행이동 시점에 이벤트 처리해 줍니다.
function doMoveRowDown(){
	GridObj.moveRow(GridObj.getSelectedId(),"down");
}

// doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
// GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
// setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
function doQueryEnd(GridObj, RowCnt){
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false"){
		alert(msg);
	}
	
	return true;
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
		
	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		
		pass_pass(ev_no);
	}
	else{
		alert(messsage);
	}

	return false;
}
    
function doQuery(){
	var grid_col_id = "<%=grid_col_id%>";
	var f = document.forms[0];
}
	
function doSelect(){
	var	servletUrl  = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_pp_lis2";
	var param       = "mode=getEps0024&grid_col_id=<%=grid_col_id%>";
	
	param += dataOutput();
	
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
}
     
function doInsert(){
	var pass_flag     = false;
	var checkCnt      = 0;
	var iCheckedRow   = 0;
	var dosUnqNoIndex = GridObj.getColIndexById("DOSUNQNO");//고유번호
	var jumJumCdIndex = GridObj.getColIndexById("JUMJUMCD");//점코드
	var pmkPmkCdIndex = GridObj.getColIndexById("PMKPMKCD");//품목코드
	var geGetDtIndex  = GridObj.getColIndexById("GEGETDT");//취득일자
	var jabJabAmIndex = GridObj.getColIndexById("JABJABAM");//취득금액

	for(iCheckedRow = 0; iCheckedRow < GridObj.GetRowCount(); iCheckedRow++){
		if(GridObj.GetCellValue("SELECTED", iCheckedRow) == true){
			checkCnt ++;
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	if(checkCnt > 1){
		alert("선택은 한건씩만 가능합니다");
		
		return;
	}
		
	for(iCheckedRow = 0; iCheckedRow < GridObj.GetRowCount(); iCheckedRow++){
		if(GridObj.GetCellValue("SELECTED", iCheckedRow) == true){
			break;
		}
	}
	    
	var DOSUNQNO = GD_GetCellValueIndex(GridObj, iCheckedRow, dosUnqNoIndex);//고유번호
	var JUMJUMCD = GD_GetCellValueIndex(GridObj, iCheckedRow, jumJumCdIndex);//점코드
	var PMKPMKCD = GD_GetCellValueIndex(GridObj, iCheckedRow, pmkPmkCdIndex);//품목코드
	var GEGETDT  = GD_GetCellValueIndex(GridObj, iCheckedRow, geGetDtIndex);//취득일자
	var JABJABAM = GD_GetCellValueIndex(GridObj, iCheckedRow, jabJabAmIndex);//취득금액
	
	var KTEXT = add_Slash(GEGETDT);
	var KAMT  = JABJABAM;
		
	DOSUNQNO_VAL = DOSUNQNO;
			
	parent.opener.setAssetType('<%=p_row_id%>', DOSUNQNO_VAL, KTEXT, KAMT);
<%-- 	parent.opener.setAssetType('<%=p_row_id%>', '<%=p_cell_ind%>', DOSUNQNO_VAL, KTEXT, KAMT); --%>
	parent.window.close();
}
</script>
</head>
<body leftmargin="15" topmargin="6" onload="Init();">
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>업무용동산 자산번호 조회(EPS0024)</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소속점</td>
										<td width="35%" class="data_td" >
											<input type="text"    name="jumjumnm" id="jumjumnm" value="<%=jumjumNm%>" readOnly>
											<input type="hidden"  name="jumjumcd" id="jumjumcd" value="<%=jumjumCd%>">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목</td>
										<td width="35%" class="data_td" >
											<input type="text"    name="pmkpmknm" id="pmkpmknm" value="<%=pmkpmkNm%>" readOnly>
											<input type="hidden"  name="pmkpmkcd" id="pmkpmkcd" value="<%=pmkpmkCd%>">
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
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
<script language="javascript">
btn("javascript:doSelect()", "조 회");
</script>
										</td>
										<td width="2px;">
											&nbsp;
										</td>
										<td>
<script language="javascript">
btn("javascript:doInsert()", "선택완료");
</script>
										</td>
										<td width="2px;">
											&nbsp;
										</td>
										<td>
<script language="javascript">
btn("javascript:parent.window.close()", "닫 기");
</script>
										</td>
									</tr>
								</table>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="TX_007" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>