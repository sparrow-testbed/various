<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_001_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_001_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
    String house_code = info.getSession("HOUSE_CODE");
    String inv_no	= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
    //String eval_refitem	= JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
    String po_no    = JSPUtil.nullToEmpty(request.getParameter("po_no"));
    String inv_seq  = JSPUtil.nullToEmpty(request.getParameter("inv_seq"));
    String item_no  = JSPUtil.nullToEmpty(request.getParameter("item_no"));
    String item_nm  = JSPUtil.nullToEmpty(request.getParameter("item_nm"));
    String inv_qty  = JSPUtil.nullToEmpty(request.getParameter("inv_qty"));
    String unit_measure  = JSPUtil.nullToEmpty(request.getParameter("unit_measure"));
    String materialClass2  = JSPUtil.nullToEmpty(request.getParameter("materialClass2"));
    String materialCtrlType = JSPUtil.nullToEmpty(request.getParameter("materialCtrlType"));
	String toDays          = SepoaDate.getShortDateString();    
    String po_no11 = "";
    String po_name12 = "";
    String project_name21 = "";
    String iv_no31 = "";   //매입계산서번호
    String inv_no32 = "";
    String inv_seq41 = "";
    String app_status42 = "";
    String confirm_date1 = "";
    String po_ttl_amt51 = "";
    String inv_amt52 = "";
    String dp_amt = "";
    String vendor_name61 = "";
    String vendor_cp_name62 = "";
    String bb71 = "";
    String attach_no81 = "";
    String inv_date98 = "";
    String inv_person_name99 = "";
    String invoice_status = "";
    String last_yn = "N";
    String exec_no = "";
    String dp_div = "";
    
    Object[] obj = {inv_no};
    SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getInvDisplay", obj);
	
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    
    wf.setFormat("INV_DATE","YYYY/MM/DD","DATE");
    
    if(wf.getRowCount() > 0) {
        po_no11           = wf.getValue("po_no11", 0);
        po_name12         = wf.getValue("po_name12", 0);
        project_name21    = wf.getValue("project_name21", 0);
        inv_no32          = wf.getValue("inv_no32", 0);
        inv_seq41         = wf.getValue("inv_seq41", 0);
        app_status42      = wf.getValue("app_status42", 0);
        confirm_date1     = wf.getValue("confirm_date1", 0);
        
        if(confirm_date1.equals("//")) {
        	confirm_date1 = "미완료";	
        }
        
        po_ttl_amt51      = wf.getValue("po_ttl_amt51", 0);
        inv_amt52         = wf.getValue("inv_amt52", 0);
        dp_amt            = wf.getValue("dp_amt", 0);
        vendor_name61     = wf.getValue("vendor_name61", 0);
        vendor_cp_name62  = wf.getValue("vendor_cp_name62", 0);
        bb71              = wf.getValue("bb71", 0);
        attach_no81       = wf.getValue("attach_no81", 0);
        inv_date98        = wf.getValue("inv_date98", 0);
        inv_person_name99 = wf.getValue("inv_person_name99", 0);
        invoice_status	  = wf.getValue("sign_status", 0);
        last_yn			  = wf.getValue("LAST_YN", 0);
        exec_no	  		  = wf.getValue("EXEC_NO", 0);
        dp_div			  = wf.getValue("DP_DIV", 0);
    }
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
<!--
var servletUrl 		= "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_dis1";
var mode;
var IDX_SEL;
var IDX_ITEM_NO;
var IDX_DESCRIPTION_LOC;
var IDX_UNIT_PRICE;
var IDX_INV_QTY;
var IDX_GR_QTY;
var IDX_GR_AMT;

function setHeader(){
	doSelect();
}

function doSelect(){
	var servletUrl2 = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_detail";
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=inv_item_info&grid_col_id="+grid_col_id;
	
	param += "&inv_no=<%=inv_no%>";
	param += "&inv_seq=<%=inv_seq%>";
	param += "&item_no=<%=item_no%>";
	param += dataOutput();
	
	GridObj.post(servletUrl2, param);
	GridObj.clearAll(false);
}

    
function addRow(){
<%
	if("010200600060".equals(materialClass2)){
%>
	var rowCount = GridObj.GetRowCount();
		
	if(rowCount == 1){
		alert("수입인지 관련 품목은 하나의 로우만 생성이 가능합니다.");
			
		return;
	}
<%
	}
%>
	var newId = (new Date()).valueOf();
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(newId, "", GridObj.getRowIndex(newId));
	GridObj.selectRowById(newId, false, true);
	GridObj.cells(newId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;    	
	GridObj.cells(newId, GridObj.getColIndexById("SELECTED")).setValue("1");    	
}
    
function delRow(){
	for(var i = GridObj.GetRowCount() - 1 ; i >= 0; i--){
		if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue() == "1"){
			GridObj.deleteRow(GridObj.getRowId(i));
		}
	}
}
    
function doSave(){
	var inv_qty         = '<%=inv_qty%>';
	var item_qty        = 0;
	var itemQtyValue    = 0;
	var itemLetter      = "";
	var itemStartNumber = "";
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		itemQtyValue = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_QTY")).getValue();
		
		if((itemQtyValue == "") || (itemQtyValue == "0")){
			alert("수량을 입력하여 주십시오.");
			
			return;
		}
<%
	if("01020".equals(materialCtrlType)){
%>
		itemLetter = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_LETTER")).getValue();

		if(itemLetter == ""){
			alert("중요증서기호를 입력하여 주십시오.");
			
			return;
		}
		
		itemStartNumber = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_START_NUMBER")).getValue();
		
		if(itemStartNumber == ""){
			alert("시작번호를 입력하여 주십시오.");
			
			return;
		}
<%
	}
%>		
		item_qty += Number(itemQtyValue);
	}
    	
	if(inv_qty != item_qty){
		alert("입력수량의 합과 검수수량은 동일해야 합니다.");
		
		return;
	}
    	
	if(!confirm("저장 하시겠습니까?")) return;
    	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;    	
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");   
	}    	
    	
	var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_detail";
    	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	
	params = "?mode=setInvItemInfo";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);    	
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
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
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

    if(status == "true"){
        alert(messsage);
        opener.doSelect();
        window.close();
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
function doExcelUpload(){
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
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">
	<form id="form1" name="form1" >
		<input type="hidden" id="inv_no"  name="inv_no" 	value="<%=inv_no%>"/>
		<input type="hidden" id="inv_seq" name="inv_seq" 	value="<%=inv_seq%>"/>
		<input type="hidden" id="item_no" name="item_no" 	value="<%=item_no%>"/>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class='title_page'>물류 입고 추가정보 입력</td>
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주번호</td>
										<td width="35%" class="data_td"><%=po_no11%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;발주명</td>
										<td width="35%" class="data_td"><%=po_name12%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수요청일자</td>
										<td class="data_td"><%=app_status42%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수요청번호</td>
										<td class="data_td"><%=inv_no32%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
										<td class="data_td"><%=item_no%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품명</td>
										<td class="data_td"><%=item_nm%></td>
									</tr>  
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수수량</td>
										<td class="data_td" colspan="3"><%=inv_qty%> <%=unit_measure %></td>
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
<script language="javascript">
btn("javascript:addRow()","행추가");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:delRow()","행삭제");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:doSave()","저 장");
</script>
							</TD>
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
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<iframe src="" name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>
</s:header>
<s:grid screen_id="IV_001_2" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>