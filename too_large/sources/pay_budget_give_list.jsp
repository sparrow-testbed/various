<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_009";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String sessionId    = info.getSession("ID");    
	String  LB_MATERIAL_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
    
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_budget_give_list";

var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;

var mode = "";

var IDX_SELECTED;
var IDX_STATUS_CD;
var IDX_STATUS_NM;
var IDX_PAY_SEND_NO;
var IDX_PAY_SEND_SEQ;
var IDX_PAY_AMT;
var IDX_VENDOR_CODE;
var IDX_VENDOR_NAME;
var IDX_SIGNER_NM;
var IDX_SIGNER_NO;
var IDX_SIGNER_FLAG;


function init()
{
	setGridDraw();
	setHeader();
    doSelect();
}

function setHeader() {

	
	IDX_SELECTED   	     = GridObj.GetColHDIndex("SELECTED");   
	IDX_STATUS_CD  	     = GridObj.GetColHDIndex("STATUS_CD");  
	IDX_STATUS_NM  	     = GridObj.GetColHDIndex("STATUS_NM");  
	IDX_PAY_SEND_NO	     = GridObj.GetColHDIndex("PAY_SEND_NO");
	IDX_PAY_SEND_SEQ     = GridObj.GetColHDIndex("PAY_SEND_SEQ");
	IDX_PAY_AMT    	     = GridObj.GetColHDIndex("PAY_AMT");    
	IDX_VENDOR_CODE	     = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME	     = GridObj.GetColHDIndex("VENDOR_NAME");
    IDX_SIGNER_NM  	     = GridObj.GetColHDIndex("SIGNER_NM");  
    IDX_SIGNER_NO  	     = GridObj.GetColHDIndex("SIGNER_NO");  
    IDX_SIGNER_FLAG	     = GridObj.GetColHDIndex("SIGNER_FLAG");
}

function doSelect()
{
	
	document.forms[0].inv_start_date.value = del_Slash( document.forms[0].inv_start_date.value );
	document.forms[0].inv_end_date.value   = del_Slash( document.forms[0].inv_end_date.value   );
	
    mode = "getPayBugetGiveList";
    
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=" + mode;
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);    
}


function getVendorCode(setMethod) {
	window.open("/common/CO_014.jsp?callback=" + setMethod, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

function setVendorCode( code, desc1, desc2 , desc3) {
	$("#vendor_code").val(code);
	$("#vendor_code_name").val(desc1);
}

<%--
function doApproval(){
	var row_idx    = checkedDataRow("SELECTED");
	var checkCnt   = 0;
	var statusCd   = ""; 
	var payAmt     = "";
	var signerFlag = "";
	var signerNo   = "";
	var paySendNo  = "";
	var addUserId  = "";
	
	if(row_idx < 1) {
		return;		
	} 
	
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			
			if(checkCnt == 1){
				statusCd 	= GridObj.GetCellValue("STATUS_CD"       , i);
				payAmt 		= GridObj.GetCellValue("PAY_AMT"         , i);
				signerFlag	= GridObj.GetCellValue("SIGNER_FLAG"     , i);
				signerNo	= GridObj.GetCellValue("SIGNER_NO"       , i);
				paySendNo	= GridObj.GetCellValue("PAY_SEND_NO"     , i);
				addUserId	= GridObj.GetCellValue("ADD_USER_ID"     , i);
			}
		}
	}
	
	if(checkCnt > 1){
		alert("한 Row 이상 선택하실 수 없습니다.");
		return;
	}
	
	if((statusCd != "00") && (statusCd != "85")){
		alert("처리 가능한 상태가 아닙니다.");
		
		return;
	} 
	
	if(signerFlag == "Y" && signerNo != "<%=sessionId%>"){
		alert("책임자를 확인하여 주십시오.");
		
		return;
	}else if(signerFlag != "Y" && addUserId != "<%=sessionId%>"){
		alert("지급권한이 없습니다.");
		return;
	}
	 
	var frm = document.frmEps0000;
	var url = "pay_bd_app.jsp";
	
	frm.signer_no.value   = signerNo;	
	frm.pay_send_no.value = paySendNo;
	
	frm.method = "POST";
	frm.target = "_self";
	frm.action = url;
	
	frm.submit();
}
--%>
function fnDetail(){
	var row_idx      = checkedDataRow("SELECTED");
	var checkCnt     = 0;
	var statusCd     = ""; 
	var payAmt       = "";
	var signerFlag   = "";
	var signerNo     = "";
	var paySendNo    = "";
	var addUserId    = "";
	var rtnSignerNo  = "";
	var beforeSingNo = "";
	
	if(row_idx < 1) {
		return;		
	} 
	
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			
			if(checkCnt == 1){
				statusCd 	 = GridObj.GetCellValue("STATUS_CD",      i);
				payAmt 		 = GridObj.GetCellValue("PAY_AMT",        i);
				signerFlag	 = GridObj.GetCellValue("SIGNER_FLAG",    i);
				signerNo	 = GridObj.GetCellValue("SIGNER_NO",      i);
				paySendNo	 = GridObj.GetCellValue("PAY_SEND_NO",    i);
				addUserId	 = GridObj.GetCellValue("ADD_USER_ID",    i);
				rtnSignerNo	 = GridObj.GetCellValue("RTN_SIGNER_NO",  i);
				beforeSingNo = GridObj.GetCellValue("BEFORE_SIGN_NO", i);
			}
		}
	}
	
	if(checkCnt > 1){
		alert("한 Row 이상 선택하실 수 없습니다.");
		return;
	}
	/*
	if(signerFlag == "Y" && signerNo != "<%=sessionId%>"){
		alert("책임자를 확인하여 주십시오.");
		
		return;
	}
	else if(signerFlag != "Y" && addUserId != "<%=sessionId%>"){
		alert("지급권한이 없습니다.");
		return;
	}
	*/
	if(
		(signerNo     != "<%=sessionId%>") &&
		(addUserId    != "<%=sessionId%>") &&
		(beforeSingNo != "<%=sessionId%>") &&
		(rtnSignerNo  != "<%=sessionId%>")
	){
		alert("접근 권한이 없습니다.");
		
		return;
	}
	 
	var frm = document.frmEps0000;
	var url = "pay_bd_app.jsp";
	
	frm.signer_no.value   = signerNo;	
	frm.pay_send_no.value = paySendNo;
	
	frm.method = "POST";
	frm.target = "_self";
	frm.action = url;
	
	frm.submit();
}

function doReject(){
	var row_idx    = checkedDataRow("SELECTED");
	var checkCnt   = 0;
	var signStatus = "";
	var statusCd   = ""; 
	var payAmt     = "";
	var signerFlag = "";
	var signerNo   = "";
	var paySendNo  = "";
	
	if(row_idx < 1) {
		return;		
	} 
	
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			
			if(checkCnt == 1){
				signStatus  = GridObj.GetCellValue("SIGN_STATUS"     , i);
				statusCd 	= GridObj.GetCellValue("STATUS_CD"       , i);
				payAmt 		= GridObj.GetCellValue("PAY_AMT"         , i);
				signerFlag	= GridObj.GetCellValue("SIGNER_FLAG"     , i);
				signerNo	= GridObj.GetCellValue("SIGNER_NO"       , i);
				paySendNo	= GridObj.GetCellValue("PAY_SEND_NO"     , i);
			}
		}
	}
	
	if(signStatus != "E"){
		alert("처리 가능한 상태가 아닙니다.");
		
		return;
	}
	
	if(statusCd != "00"){
		alert("처리 가능한 상태가 아닙니다.");
		
		return;
	}
	
	if((signerFlag == "N") || (signerNo != "<%=sessionId%>")){
		alert("책임자를 확인하여 주십시오.");
		
		return;
	}
	
	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
		{
			mode        : "isHldy"
		},
		function(arg){
			
			var result  = eval("(" + arg + ")"); 
			var code    = result.code;
			var message = result.message;
			
			if(result != "0" ){
				alert("휴일거래 불가합니다.");
			}else if(result == "0" ){ 
				var grid_array    = getGridChangedRows(GridObj, "SELECTED");
				var params        = "?mode=updateSpy1glStatusCd03";
				
				params += "&cols_ids=<%=grid_col_id%>";
				params += dataOutput();
				
				myDataProcessor = new dataProcessor(G_SERVLETURL + params);
				
				sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function doManualConfirm(){
	var grid_array    = getGridChangedRows(GridObj, "SELECTED");
	var params        = "?mode=updateSpy1glManualAccountKind";
	var rowCount      = GridObj.GetRowCount();
	var checkCount    = 0;
	var i             = 0;
	var selectedIndex = GridObj.getColIndexById("SELECTED");
	var statusCdIndex = GridObj.getColIndexById("STATUS_CD");
	var statusCdValue = "";
	
	for(i = 0; i < rowCount; i++){
		if(GD_GetCellValueIndex(GridObj, i, selectedIndex) == true){
			statusCdValue = GD_GetCellValueIndex(GridObj, i, statusCdIndex);
			
			if(
				(statusCdValue != "00") &&
				(statusCdValue != "70") &&
				(statusCdValue != "85")
			){
				alert("수동완료 변경이 안되는 건이 있습니다.");
				
				return;
			}
			
			checkCount++;
		}
	}
	
	if(checkCount == 0){
		alert("처리할 데이터를 선택하여 주십시오.");
		
		return;
	}
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	if(confirm("수동완료 처리 하시겠습니까?")){
		myDataProcessor = new dataProcessor(G_SERVLETURL + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	
	if(part == "PURCHASER_ID"){
		window.open("/common/CO_008.jsp?callback=getPurUser&userId="+$("#purchaser_id").val()+"&userName="+$("#purchaser_name").val(), "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
	if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}	
}

function getPurUser(code, text){
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}


//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( GridObj.getColIndexById("TAX_NO") == cellInd ){
		if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
	  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
	  		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&gubun=" + status + "&gubun=P";
		}else{
			var pubCode = GridObj.cells(rowId, GridObj.GetColHDIndex("PUBCODE")).getValue();
			
			var iMyHeight;
			width = (window.screen.width-635)/2
			if(width<0)width=0;
			iMyWidth = width;
			height = 0;
			if(height<0)height=0;
			iMyHeight = height;
			var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
			document.taxListForm.action="<%=CommonUtil.getConfig("sepoa.trus.server")%>/jsp/directTax/TaxViewIndex.jsp";
			document.taxListForm.method="post";
			document.taxListForm.pubCode.value=pubCode;
			document.taxListForm.docType.value= "T"; //세금계산서
			document.taxListForm.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
			document.taxListForm.target="taxInvoice";
			document.taxListForm.submit();		
		}
	} else if( header_name == "VENDOR_NAME" ) {
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		var url    = '/s_kr/admin/info/ven_bd_con.jsp';
		var title  = '업체상세조회';
		var param  = 'popup=Y';
		param     += '&mode=irs_no';
		param     += '&vendor_code=' + vendor_code;
		popUpOpen01(url, title, '900', '700', param);
		
	}
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
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
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    }
    
    doSelect();

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
    
    document.forms[0].inv_start_date.value = add_Slash( document.forms[0].inv_start_date.value );
	document.forms[0].inv_end_date.value   = add_Slash( document.forms[0].inv_end_date.value   );
    
    return true;
}
//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }  
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].purchaser_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}


function clearMATERIAL_CTRL_TYPE() {
    if(form1.MATERIAL_CTRL_TYPE.length > 0) {
        for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
            form1.MATERIAL_CTRL_TYPE.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS1() {
    if(form1.MATERIAL_CLASS1.length > 0) {
        for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS1.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS2() {
    if(form1.MATERIAL_CLASS2.length > 0) {
        for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS2.options[i] = null;
        }
    }
}

function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function setMATERIAL_CLASS1(name, value){
    var option1 = new Option(name, value, true);
    
    form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function setMATERIAL_CLASS2(name, value){
    var option1 = new Option(name, value, true);
    
    form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
}

function MATERIAL_TYPE_Changed() {
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1(":::전체:::", "");
    setMATERIAL_CLASS2(":::전체:::", "");
 
  	var materialType     = document.getElementById("MATERIAL_TYPE");
  	var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M041";
  	param = param + "#" + materialType.value;
  
	doRequestUsingPOST( 'SL0009', param ,'MATERIAL_CTRL_TYPE', '', false);	//false:동기, true:비동기모드
	
	option.text  = ":::전체:::";
	option.value = "";
	
	materialCtrlType.add(option, 0);
	materialCtrlType.value = "";
}

function MATERIAL_CTRL_TYPE_Changed(){
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2(":::전체:::", "");
        
    var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
    var materialClass1   = document.getElementById("MATERIAL_CLASS1");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M042";
  	param = param + "#" + materialCtrlType.value;
    
    doRequestUsingPOST( 'SL0019', param ,'MATERIAL_CLASS1', '', false);
    
    option.text = ":::전체:::";
    option.value = "";
    
    materialClass1.add(option, 0);
    materialClass1.value = "";
}

function MATERIAL_CLASS1_Changed(){
    clearMATERIAL_CLASS2();
    
    var materialClass1 = document.getElementById("MATERIAL_CLASS1");
    var materialClass2 = document.getElementById("MATERIAL_CLASS2");
  	var param          = "<%=info.getSession("HOUSE_CODE")%>";
  	var option         = document.createElement("option");
  	
  	param = param + "#" + "M122";
  	param = param + "#" + materialClass1.value;
    
    doRequestUsingPOST( 'SL0089', param ,'MATERIAL_CLASS2', '', false);
    
	option.text = ":::전체:::";
	option.value = "";
    
    materialClass2.add(option, 0);
    materialClass2.value = "";
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form id="form1" name="form1" action="">
	  	<%@ include file="/include/sepoa_milestone.jsp"%>
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
        								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서 발행일자</td>
            							<td class="data_td">
            								<s:calendar id="inv_start_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" format="%Y/%m/%d" cssClass=" "/>
                							~
                							<s:calendar id="inv_end_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" format="%Y/%m/%d" cssClass=" "/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
										<td class="data_td">
											<input type="text" name="vendor_code" id="vendor_code" size="12" class="inputsubmit" maxlength="10" style="ime-mode:inactive" onkeydown='entKeyDown()'>
											<a href="javascript:getVendorCode('setVendorCode')">
												<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="vendor_code_name" id="vendor_code_name" size="20" onkeydown='entKeyDown()'>			
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서번호</td>
										<td class="data_td"> 
            								<input type="text" id="tax_no" name="tax_no" size="10" style="ime-mode:inactive" value='' onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상태</td>
										<td class="data_td">
								      		<select name="status_cd" id="status_cd" class="inputsubmit">
												<option value="">전체</option>
												<%
													String complete_mark = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+"#M1015", "");
													out.println(complete_mark);
												%>
											</select>
								      		
										</td>
									</tr> 
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;조작자</td>
										<td class="data_td" colspan="3">
											<input type="text" name="purchaser_id" id="purchaser_id" size="20" value="" onkeydown="JavaScript: entKeyDown();" style="ime-mode:disabled;" maxlength="10">
											<a href="javascript:PopupManager('PURCHASER_ID')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="purchaser_name" id="purchaser_name" size="20" value=""  onkeydown="JavaScript: entKeyDown();" >
										</td>	
									</tr>
									
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
										<td width="35%" class="data_td">
											<select name="MATERIAL_TYPE" onChange="javacsript:MATERIAL_TYPE_Changed();", id="MATERIAL_TYPE">
												<option value=''>:::전체:::</option>
												<%=LB_MATERIAL_TYPE%>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
										<td width="35%" class="data_td">
											<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
												<option value=''>:::전체:::</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
										<td width="35%" class="data_td">
											<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" onChange="javacsript:MATERIAL_CLASS1_Changed();">
												<option value=''>:::전체:::</option>
											</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
										<td width="35%" class="data_td">
											<select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2">
												<option value=''>:::전체:::</option>
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
				<td height="30" align="right">
            		<TABLE cellpadding="0">
                		<TR>
                        	<TD>
<script language="javascript">
btn("javascript:doSelect()", "조 회");
</script>
							</TD>
                        	<TD>
<script language="javascript">
btn("javascript:fnDetail()", "상 세");
</script>
							</TD>
<%-- 
                        	<TD>
<script language="javascript">
btn("javascript:doApproval()", "지 급");
</script>
							</TD>
                        	<TD>
<script language="javascript">
btn("javascript:doApproval()", "책임자승인");
</script>
							</TD>
--%>
                        	<TD>
<script language="javascript">
btn("javascript:doReject()", "책임자반려");
</script>
							</TD> 
<%--
                        	<TD>
<script language="javascript">
btn("javascript:doManualConfirm()", "수동완료");
</script>
							</TD>
--%>
                    	</TR>
                	</TABLE>
            	</td>
        	</tr>
    	</table>
	</form>
	<form name="frmEps0000">
		<input type="hidden" name="signer_no"            id="signer_no"             />
		<input type="hidden" name="pay_send_no"          id="pay_send_no"           />
		<input type="hidden" name="pay_send_seq"         id="pay_send_seq"          />
	</form>  
	<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
    </form>
              
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_009" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
<%-- TOBE 2017-07-01 구 activeX 미사용 주석처리   
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
--%>
</OBJECT>
</body>
</html>