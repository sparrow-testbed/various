<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_035");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_035";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="PR_035";
	String pr_location	= request.getParameter("pr_location");
	String item_no	= request.getParameter("item_no"); 
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript">
function setHeader() {
	INDEX_SELECTED				= GridObj.GetColHDIndex("SELECTED"			);	
	INDEX_VENDOR_CODE			= GridObj.GetColHDIndex("VENDOR_CODE"			);	
	INDEX_VENDOR_NAME			= GridObj.GetColHDIndex("VENDOR_NAME"			);	 
		
	doSelect();
}

function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	//frm.appendChild(input);
	
	return input;
}

function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function getParams(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params;
	
	inputParam = "pr_location=<%=pr_location%>";
	inputParam = inputParam + "&item_no=<%=item_no%>";
	inputParam = inputParam + "&pr_no=";
	inputParam = inputParam + "&bid_pr_no=";
	inputParam = inputParam + "&pr_type=";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=prInfoVendorList";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function doSelect(){
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr5_pp_lis1";
	var params     = getParams();
	
	GridObj.post(servletUrl, params);
	
	GridObj.clearAll(false);
}

function doSave(){  
	var wise = GridObj;
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = 0;
	var tmp_vendor_code = "";
	var tmp_vendor_name = "";
	var tmp_unit_price = "";
		
	for(var row = 0; row < iRowCount; row++){
		if(true == GridObj.GetCellValue("SELECTED", row)){
			tmp_vendor_code = GridObj.GetCellValue("VENDOR_CODE", row);
			tmp_vendor_name = GridObj.GetCellValue("VENDOR_NAME", row);
			tmp_unit_price = GridObj.GetCellValue("UNIT_PRICE", row);
			iCheckedCount++;
		}
	}
	
	if(iCheckedCount<1){
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(iCheckedCount>1){
		alert(G_MSS2_SELECT);
		
		return;
	}
		 
	var rtn_parent = opener.setPo(tmp_vendor_code, tmp_vendor_name, tmp_unit_price);
	
	if(rtn_parent == true){
		opener.window.focus();  
		window.close();
	}
}
	 

function JavaCall(msg1,msg2,msg3,msg4,msg5){
	if(msg1 == "doQuery") {}
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
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" text="#000000" >
<s:header popup="true">
	<form name="form1" > 
	
		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>발주대상업체</span>
				</td>
			</tr>
		</table>
		<br>
		
		<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
		<div id="pagingArea"></div>
<%-- 		<s:grid screen_id="PR_035" grid_obj="GridObj" grid_box="gridbox"/> --%>

		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR> 
							<td>
								<script language="javascript">
									btn("javascript:doSave();", "선 택");
								</script>
							</td>  
							<TD>
								<script language="javascript">
									btn("javascript:window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:footer/>
</body>
</html>


