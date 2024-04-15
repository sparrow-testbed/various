<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%

    /* TOBE 2017-07-01 사용자 ID , 점코드 추가 */
    String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
    String user_jumcd	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));

	Vector multilang_id = new Vector();

	multilang_id.addElement("TX_012_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap			text            = MessageUtil.getMessage(info, multilang_id);
	String      	screen_id       = "TX_012_1";
	String       	grid_obj        = "GridObj";
	boolean      	isSelectScreen  = false;
	String       	company_code    = info.getSession("COMPANY_CODE");
	String 		 	vendor_code	  	= JSPUtil.nullToRef(request.getParameter("vendor_code")	, "");
	String 		 	tax_date	  	= JSPUtil.nullToRef(request.getParameter("tax_date")	, "");
	String       	house_code      = info.getSession("HOUSE_CODE");
	String       	LB_DEAL_KIND    = ListBox(request, "SL0014", house_code + "#M803", ""); //거래구분
	String       	LB_USE_KIND     = ListBox(request, "SL0014", house_code + "#M804", ""); //용도구분(존속기간)복구충당부채사용기간
	String       	LB_BUDGET_DEPT  = ListBox(request, "SL0014", house_code + "#M805", ""); //소관부서
	String       	LB_PAY_KIND_BUD = ListBox(request, "SL0018", house_code + "#M800", "");
	String     	 	taxNo           = JSPUtil.nullToRef(request.getParameter("tax_no")	, "");
	String       	taxSeq          = JSPUtil.nullToRef(request.getParameter("tax_seq")	, "");
	String       	procDept        = JSPUtil.nullToRef(request.getParameter("proc_dept"),""); //TOBE 2017-07-01 지급결의담당부서 추가
	StringBuffer 	stringBuffer    = new StringBuffer();
	
	String			VENDOR_NAME_LOC = "";
	String			IRS_NO 			= "";
	String			TOT_AMT			= "";
	String			SUP_AMT			= "";
	String			VAT_AMT 		= "";
	String			BANK_ACCT		= "";
	String          BANK_CODE       = "";
	String          DEPOSITOR_NAME  = "";
	
	Object[] args = {taxNo};
	
	SepoaOut value = null;
	SepoaRemote wr = null;
	String nickName   = "TX_012";
	String conType    = "CONNECTION";
	String MethodName = "getOperateExpenseHeader";
	SepoaFormater wf = null;	
	
	try {
		wr = new SepoaRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);

		wf = new SepoaFormater(value.result[0]);

		int rw_cnt = wf.getRowCount();
		
		if(rw_cnt > 0){
			VENDOR_NAME_LOC = wf.getValue("VENDOR_NAME_LOC", 0);
			IRS_NO 			= wf.getValue("IRS_NO", 0);
			TOT_AMT 		= wf.getValue("TOT_AMT", 0);
			SUP_AMT 		= wf.getValue("SUP_AMT", 0);
			VAT_AMT 		= wf.getValue("VAT_AMT", 0);
			BANK_ACCT		= wf.getValue("BANK_ACCT", 0);
			BANK_CODE       = wf.getValue("BANK_CODE", 0);
			DEPOSITOR_NAME  = wf.getValue("DEPOSITOR_NAME", 0);
		}
	
	} catch (Exception e) {
		//e.printStackTrace();
		isSelectScreen  = false;
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
	<jsp:param name="screen_id" value="TX_003"/>  
	<jsp:param name="grid_obj" value="GridObj_1"/>
	<jsp:param name="grid_box" value="gridbox_1"/>
	<jsp:param name="grid_cnt" value="2"/>
</jsp:include>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_ins2";

/* TOBE 2017-07-01 통합단말 관련 변수 */
var strSourceSystem = "EPS";	// 송신 시스템 코드
var strTargetSystem = "UTM";    // 수신 시스템 코드 //- (통합단말) UTM(리얼), UTM_D(개발), UTM_T(테스트), UTM_Y(연수) 


function Init() {	//화면 초기설정

	//TOBE 2017-07-01 (기능추가) 지급결의담당부서와 로그인지점이 다를경우 결재요청 버튼 숨김
	//alert("A : "+"<%=user_jumcd%>" + " B : "+ "<%=procDept%>");
	if("<%=user_jumcd%>" != "<%=procDept%>") {
		$('#tdBEB00730T02').hide();//결재요청 버튼
	}
	
    /* TOBE 2017-07-01 추가 */
    var nResult = XFramePLUS.StartCopyData(true, strSourceSystem);// WM_COPYDATA 메시지를 수신하기 위한 윈도우 생성{필수}
    if(nResult != 1) {alert("수신 윈도우 생성 시 오류 발생");}

	setGridDraw();
	GetBrowserInfo(document.form1);
	doSelect2();
	<%--
	$("#ziphangcd").html("<option value=''>선택</option>");
	doRequestUsingPOST( 'SL0009', '<%=info.getSession("HOUSE_CODE")%>#M813#'+'<%=info.getSession("DEPARTMENT")%>' ,'ziphangcd', '', false);
	--%>
	getZiphangcdSelect();
}

function getZiphangcdSelect(){
	//TOBE 2017-07-01 책임자 승인 목록
   	$.post(
 		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_ins2",
		{
			mode           : "getEps0037",
			mode2          : "I"			
		},
		function(arg){
			var result = eval("(" + arg + ")");
			getZiphangcdSelectCallback(result);
		}
	);
}

function getZiphangcdSelectCallback(result){
	var signerSelect = document.getElementById("ziphangcd");
	var i            = 0;
	var resultLength = result.length;
	var resultInfo   = null;
	
	try{
		if(resultLength == 0){
			alert("집행장소대상 정보가 없습니다.");
			
			//fnList();
		}
		else{
			for(i = 0; i < resultLength; i++){
				resultInfo   = result[i];
				option       = document.createElement("option");
				option.text  = resultInfo.TEXT2;
				option.value = resultInfo.CODE;
				
				signerSelect.add(option, i);
			}
			
			option       = document.createElement("option");
			option.text  = "선택";
			option.value = "";
			
			signerSelect.add(option, 0);
			
			signerSelect.value = "";
			
			//document.getElementById("signerBeforeLineTr").style.display = "";
			//document.getElementById("signerBeforeDataTr").style.display = "";
		}
	}
	catch(e){
		alert("집행장소대상 정보가 없습니다.");
		
		//fnList();
	}
}



function fnApproval(){
	var isChecked 	= false;
	var chkCnt		= 0;
	var rowId;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if($.trim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue()) == "1"){
			rowId		= GridObj.getRowId(i);
			isChecked 	= true;
			chkCnt++;
		}
	}

	if(!isChecked){
		alert("세금계산서 데이터를 선택해 주세요.");
		
		return;
	}
	else{
		if(chkCnt > 1){
			alert("하나의 항목만 선택해주세요.");
			
			return;
		}
	}
	
	//TOBE 2017-07-01 세금계선서 조회건의 공급가액과 원데이타의 공급가액이 같은건만 처리
	//alert("a : " + GridObj.cells(rowId, GridObj.getColIndexById("SPL_AM")).getValue() );
	//alert("b : " + GridObj_1.cells(1, GridObj_1.getColIndexById("SUPPLIER_PRICE")).getValue() );
	
	if( GridObj.cells(rowId, GridObj.getColIndexById("EXE_AM"        )).getValue() != 
		//그리드 금액이 아닌 화면상 총합계의 공급가액으로 해야된다 GridObj_1.cells(1, GridObj_1.getColIndexById("SUPPLIER_PRICE")).getValue() ){
		<%=TOT_AMT%> ){
		alert("선택한 세금계산서의 집행금액과 품목의 합계가 서로 다릅니다.");
		return;
	}
	 
	var bank_code		= $.trim($("#bank_code").val());
	var bank_acct    	= $.trim($("#bank_acct").val());
	var depositor_name  = $.trim($("#depositor_name").val());
	var bmsbmsyy     	= $.trim($("#bmsbmsyy").val());
	var bugumcd			= $.trim($("#bugumcd").val());
	var act_date    	= $.trim($("#act_date").val());
	var expensecd   	= $.trim($("#expensecd").val());
	var semokcd     	= $.trim($("#semokcd").val());
	var sebucd      	= $.trim($("#sebucd").val());
	var ziphangcd     	= $.trim($("#ziphangcd").val());
	var pay_reason     	= $.trim($("#pay_reason").val());
	var saupcd         	= $.trim($("#saupcd").val());
	
	if(bank_code == ''){
		alert('대체은행을 선택해 주세요.\n해당입력값을 변경하려면 해당 업체의 업체정보를 수정하여야 합니다.');
		return;
	}
	if(bank_acct == ''){
		alert('대체은행 계좌번호를 입력해 주세요.\n해당입력값을 변경하려면 해당 업체의 업체정보를 수정하여야 합니다.');
		return;
	}
	if(depositor_name == ''){
		alert('예금주명을 입력해 주세요.\n해당입력값을 변경하려면 해당 업체의 업체정보를 수정하여야 합니다.');
		return;
	}
	if(bmsbmsyy == ''){
		alert('예산년도를 선택해 주세요.');
		return;
	}
	if(bugumcd == ''){
		alert('부점코드를 선택해 주세요.');
		return;
	}
	if(act_date == ''){
		alert('결의일자를 입력해 주세요.');
		return;
	}
	if(expensecd == ''){
		alert('경비코드를 선택해 주세요.');
		return;
	}
	if(document.getElementById("semokcd").style.display != "none" && semokcd == ''){
		alert('세목코드를 선택해 주세요.');
		return;
	}
	if(document.getElementById("sebucd").style.display != "none" && sebucd == ''){
		alert('세부코드를 선택해 주세요.');
		return;
	}
	if(document.getElementById("sebucd").style.display != "none" && ziphangcd == ''){
		alert('집행대상장소코드를 선택해 주세요.');
		return;
	}
	
	if(pay_reason == ''){
		alert('지급사유를 입력해 주세요.');
		return;
	}
	
	if(saupcd == ""){
		alert("사업코드를 입력해 주세요.");
		
		return;
	}
	
	/*
	document.forms[0].target = "childframe";
	document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
	document.forms[0].method = "POST";
	document.forms[0].submit();
	*/
	
    
	//$("#tdDelete").hide();
	//fnBtnHide();
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
				document.forms[0].target = "childframe";
				document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
				document.forms[0].method = "POST";
				document.forms[0].submit();				
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
	
}

function getApproval(approval_str){
	$("#approval_str").val(approval_str);
	
	if(!confirm("결재요청 하시겠습니까?")){
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setApproval";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(servletUrl+params);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	
	//self.close();
}

function fnExpenseCdChange(obj) {
    $("#semokcd").html("<option value=''>선택</option>");
	doRequestUsingPOST( 'SL0009', '<%=info.getSession("HOUSE_CODE")%>#M811#'+obj.value ,'semokcd', '', false);
	
	fnComboVisible("expensecd");
}

function fnSemokCdChange(obj) {
	$("#sebucd").html("<option value=''>선택</option>");
	doRequestUsingPOST( 'SL0019', '<%=info.getSession("HOUSE_CODE")%>#M812#'+obj.value ,'sebucd', '', false);
	fnComboVisible("semokcd");
}

function fnZiphangcdChange(obj) {
	$("#ziphangnm").val($("#ziphangcd option:checked").text());
}

//combo visible
function fnComboVisible(opt){
	if(opt == "expensecd"){
		if($("#semokcd option").size() > 1){
			document.getElementById("semokstar").style.display = "";
			document.getElementById("semokcd").style.display   = "";
		
		}
		else{
			document.getElementById("semokstar").style.display = "none";
			document.getElementById("semokcd").style.display   = "none";
		}
		
		document.getElementById("sebucd").style.display    = "none";
		document.getElementById("sebustar").style.display  = "none";
		document.getElementById("ziphangcd").style.display = "none";
	}
	else if(opt == "semokcd"){
		if($("#sebucd option").size() > 1){
			document.getElementById("sebustar").style.display  = "";
			document.getElementById("sebucd").style.display    = "";
			document.getElementById("ziphangcd").style.display = "";
		}
		else{
			document.getElementById("sebustar").style.display  = "none";
			document.getElementById("sebucd").style.display    = "none";
			document.getElementById("ziphangcd").style.display = "none";
		}
	}
	else{
		document.getElementById("semokcd").style.display   = "none";
		document.getElementById("semokstar").style.display = "none";
		document.getElementById("sebustar").style.display  = "none";
		document.getElementById("sebucd").style.display    = "none";
		document.getElementById("ziphangcd").style.display = "none";
	}
}

function PopupManager(kind){
	if(kind == "DELY_TO_ADDRESS"){
		window.open("/common/CO_009.jsp?callback=getDelyCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(kind == "SAUP"){
		window.open("/common/CO_016.jsp?callback=getSaupCode", "SAUP", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getDelyCode(code, text){
	$("#bugumnm").val(text);
	$("#bugumcd").val(code);
}

function getSaupCode(code, text){
	document.getElementById("saupcd").value = code;
	document.getElementById("saupnm").value = text;
}
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
    	
	GridObj_1_setGridDraw();
	GridObj_1.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var nts_app_no = GridObj.cells(rowId, GridObj.getColIndexById("TAA_APV_NO")).getValue();	//국세청승인번호
   	var isu_dt     = GridObj.cells(rowId, GridObj.getColIndexById("ISU_DT")).getValue();		//증빙서발행일자
   	var rgs_brcd   = GridObj.cells(rowId, GridObj.getColIndexById("RGS_BRCD")).getValue();		//등록부점코드
   	var rgs_dt 	   = GridObj.cells(rowId, GridObj.getColIndexById("RGS_DT")).getValue();		//계산서등록일자
   	var rgs_srno   = GridObj.cells(rowId, GridObj.getColIndexById("RGS_SRNO")).getValue();		//계산서등록일련번호
   	var exe_am     = GridObj.cells(rowId, GridObj.getColIndexById("EXE_AM")).getValue();		//집행금액
   	var spl_am     = GridObj.cells(rowId, GridObj.getColIndexById("SPL_AM")).getValue();		//공급가액
   	var tax_am     = GridObj.cells(rowId, GridObj.getColIndexById("TAX_AM")).getValue();		//세액
   	var rgs_dscd   = GridObj.cells(rowId, GridObj.getColIndexById("RGS_DSCD")).getValue();		//등록거래구분
   	var pay_rsn    = GridObj.cells(rowId, GridObj.getColIndexById("PAY_RSN")).getValue();		//지급사유
   	var tot_amt    = $("#tot_amt").val();
   	
// 	if(exe_am != tot_amt){
// 		alert("선택된 세금계산서의 집행금액과 지급결의금액이 다릅니다.");
		
// 		return false;
// 	}
   	
   	$("#nts_app_no").val(nts_app_no);
   	$("#isu_dt").val(isu_dt);
   	$("#acc_tax_date").val(rgs_dt);
   	$("#acc_tax_seq").val(rgs_srno);
   	$("#exe_am").val(exe_am);  
   	$("#spl_am").val(spl_am);
   	$("#tax_am").val(tax_am);
   	
   	if(stage==0){
        return true;
    }
   	else if(stage==1){}
   	else if(stage==2){
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

    if(status == "true") {
		opener.doSelect();
		self.close();
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
    
    if(status == "0"){
    	alert(msg)
    }
    else{
    	alert(GridObj.GetRowCount()+"건의 자료가 조회되었습니다.");
    }
    
    document.forms[0].std_date.value = add_Slash( document.forms[0].std_date.value );
    document.forms[0].act_date.value = add_Slash( document.forms[0].act_date.value );
    
    return;
}

function fnTaxSearch(){
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
				var SPLPE_BZNO 	= "<%=IRS_NO%>";									//공급업체코드
				var INQ_BAS_DT  = document.getElementById("std_date").value;		//기준일자
				
				if(confirm("["+INQ_BAS_DT+"] 일자 세금계산서 발급정보를 요청하시겠습니까?")){
					var cols_ids = "<%=grid_col_id%>";
					var params = "mode=getBEB00730T01";
					params += "&cols_ids=" + cols_ids;
					params += dataOutput();
					GridObj.post( servletUrl, params );
					GridObj.clearAll(false);
				}			
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

//===================================== Grid2 Function =============================================
//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	
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

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj_1_doSaveEnd(obj){
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");

	document.getElementById("GridObj_1_message").innerHTML = messsage; // 아이디 주의

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		
		//doQuery();
	}
	else {
		alert(messsage);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doData");
	} 

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj_1.clearAll();
		GridObj_1.setCSVDelimiter("\t");
		GridObj_1.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj_1.getUserData("", "message");
	var status     = GridObj_1.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
    for(var i = 0 ; i < GridObj_1.GetRowCount() ; i++){
		GridObj_1.cells(GridObj_1.getRowId(i), GridObj_1.getColIndexById("SEL")).cell.wasChanged = true;
		GridObj_1.cells(GridObj_1.getRowId(i), GridObj_1.getColIndexById("SEL")).setValue("1");
    }
	
    $("#itemSize").val(GridObj_1.GetRowCount());
	return true;
}

// 트랜잭션용 함수
function GridObj_1_sendTransactionGrid(){
	var grid_array      = getGridChangedRows(GridObj_1, "Check"); // 선택 칼럼명에 맞춰서
	var row             = 0;
	var gridArrayLength = grid_array.length;
	var gridArrayInfo   = null;
	var checkColIndex   = GridObj_1.getColIndexById("Check");// 선택 칼럼명에 맞춰서
	var gridObj_1Cell   = null;
	var isSetUpdated    = false;
	
	if(grid_array == null){
		alert("grid_array is null.");
		
		return;
	}

	myDataProcessor.init(GridObj_1);
	myDataProcessor.enableDataNames(true);
	myDataProcessor.setTransactionMode("POST", true);
	myDataProcessor.defineAction("doSaveEnd", GridObj_1_doSaveEnd);
	myDataProcessor.setUpdateMode("off");
	
	for(row = 0; row < gridArrayLength; row++){
		gridArrayInfo = grid_array[row];
		gridObj_1Cell = GridObj_1.cells(gridArrayInfo, checkColIndex);
		checked       = gridObj_1Cell.getValue();

		if(checked == "1") {
			isSetUpdated = true;
		}
		else {
			isSetUpdated = false;
		}
		
		myDataProcessor.setUpdated(gridArrayInfo, isSetUpdated);
    }

	myDataProcessor.setUpdateMode("row");
	myDataProcessor.sendData();
	myDataProcessor.setUpdateMode("off");

	GridObj_1_doQueryDuring();
}

function doSelect2(){
	var grid_col_id = GridObj_1_getColIds();
	
	var params = "mode=getItemList";
	params += "&cols_ids=" + grid_col_id;
	params += dataOutput();	
	
	GridObj_1.post(servletUrl, params);
	GridObj_1.clearAll(false);
}

function checkSpecialText(str){
	var deny_pattern = /[^가-힣a-z0-9]/;
	var sKey = String.fromCharCode(str);

	if(deny_pattern.test(sKey) == true){
		alert("지급사유에는 특수문자를 사용할 수 없습니다. 내용을 확인해 주세요.");
		document.form1.pay_reason.focus();
		return false;
	}
}

<%-- ASIS 2017-07-01
function GetBrowserInfo(form){
	try{
		var ret = WooriDeviceForOcx.OpenDevice();
		var msg;
		
		if( ret == 0 ){
			ret = WooriDeviceForOcx.GetTerminalInfo(30);
			
			if( ret == 0 ){
				msg = WooriDeviceForOcx.GetResult();
				
				var arr = msg.split('');
				
				if(arr.length > 0 && arr[0].length==10){
					if(arr[1] == ""){
						alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
						window.close();
					}
					$('#bk_cd').val(arr[0].substr(0,5));
					$('#br_cd').val(arr[0].substr(5,1));
					$('#trm_bno').val(arr[0].substr(6,3));
					$('#user_trm_no').val(arr[0].substr(0,10) + arr[1]);
					$('#txtBrowserInfo').val(arr[0]);
					$('#execute_no').val(arr[1]);
					$("#txtMnno").val(arr[1]);
				}
				else{
					alert("통합 단말 정보가 올바르지 않습니다.");
					window.close();
					
				}
			}
			else{
				msg = WooriDeviceForOcx.GetErrorMsg(ret);
				
				alert(msg);
				window.close();
			}
			
			WooriDeviceForOcx.CloseDevice();
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
			
			window.close();
		}
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}
--%>



/* TOBE 2017-07-01 통합단말 사용자정보 */
function GetBrowserInfo(form){
	try{	
		// 우선적으로 데이터를 클리어한다
		XFramePLUS.clear(key);
		var key = XFramePLUS.GetQueueKeyIndex(strSourceSystem, "ZZZZZ");
		
		// 공통부(헤더)의 데이터를 채운다
		XFramePLUS.AddStr(key, "SOURCE_SYS"    , strSourceSystem ); // 송신하는 시스템코드 {필수}
		XFramePLUS.AddStr(key, "USER_ID"       , '<%=user_id%>'  ); // 행번 {필수}
 		XFramePLUS.AddStr(key, "BROWSER_INFO"  , "TRUE"          ); // 단말정보
		
		//메모리에 누적된 데이터를 확인
 		//alert(XFramePLUS.Command(key)); // 테스트 확인용 오픈시 제거
		//alert(XFramePLUS.Data(key));    // 테스트 확인용 오픈시 제거
		
 		// 송신
		var nResult = XFramePLUS.QMergeSend(strTargetSystem, key); //연결 시스템 코드 (수신대상)
		if(nResult != 1) {
			alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
			window.close();
		}
		
		// 송신 후  데이터를 클리어한다
		XFramePLUS.clear(key);
		
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}




//TOBE 2017-07-01 통합단말 수신 이벤트 발생시 호출
function recvLinkData(strQueueKeyIndex)
{
		
		/*통합단말에서 받은 DATA 담을 변수*/
		var strTargetSystem, userId, strScreenNo;
		var arrSendSeq    = new Array();
		var arrSendData   = new Array();
		
		/*통합단말에서 받은 DATA 변수에 set*/
		var nCnt = XFramePLUS.RCount(strQueueKeyIndex);
		var strCmd  = "", strData = "", strCmdAll  = "", strDataAll = "", strBrowserInfo = "", strFingerPrint = "";
		var strTRM_NO = "", strOPR_NO = "";
		
		for(var i = 0; i < nCnt ; i++){
			
			strCmd  = XFramePLUS.RCommand(strQueueKeyIndex, i); //수신 받은 데이터의 항목명
			strData = XFramePLUS.RData(strQueueKeyIndex, i);    //수신 받은 데이터의 값
			
			strCmdAll  += strCmd +"|";                          //수신항목명   확인용 ROW조립
			strDataAll += strData +"|";                         //수신데이터값 확인용 ROW조립
			
			if(strCmd == "SOURCE_SYS"){                         //시스템코드
				strTargetSystem = strData;
			}
			else if(strCmd == "USER_ID"){                       //사용자행번
				userId = strData;
			}
			else if(strCmd == "SCREEN_NO"){                     //거래화면일련번호
				strScreenNo = strData;
			}
			else if(strCmd == "BROWSER_INFO"){                  // 단말정보 (단말번호,사용자ID,텔러번호,지점번호(혹은대행점))
				
				strBrowserInfo = strData;
				//alert("단말정보 : " + strBrowserInfo ); // 테스트 확인용 오픈시 제거
				
				strTRM_NO = strBrowserInfo.substr(7,12); //단말번호
				strOPR_NO = strBrowserInfo.substr(27,8); //사용자ID
					
				$('#user_trm_no').val(strTRM_NO+strOPR_NO);  //020644DD008919010045
				$('#txtBrowserInfo').val(strTRM_NO);         //020644DD0089

			}
			else if(strCmd == "FINGER_PRINT"){  // 지문정보
				strFingerPrint = strData;
				//alert("지문인식 : " + strFingerPrint ); // 테스트 확인용 오픈시 제거
			}
			else if(strCmd.substr(0,1) == "S"){
				arrSendSeq.push( strCmd.substr(1,4) );
				arrSendData.push( strData );
			}
		}
		 
	 if(strOPR_NO != "<%=info.getSession("ID") %>"){
			alert("통합 단말과 로그인 사용자 정보가 일치하지 않습니다.");
			window.close();
	 }

     //alert(strQueueKeyIndex); // 테스트 확인용 오픈시 제거
     //alert(strCmdAll);        // 테스트 확인용 오픈시 제거
     //alert(strDataAll);       // 테스트 확인용 오픈시 제거

     XFramePLUS.RClear(strQueueKeyIndex); // 수신 받은 데이터 삭제
	
}


</script>

<!-- TOBE 2017-07-01 통합단말 수신 이벤트 -->
<script language="JavaScript" for=XFramePLUS event="onqrecvcopydata(strQueueKeyIndex)">
	recvLinkData(strQueueKeyIndex);
</script>

</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">경상비 지급 요청</td>
		</tr>
	</table>
	<form id="form1" name="form1" >
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
		<input type="hidden" name="house_code" 		id="house_code" 	value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" 	id="company_code" 	value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" 		id="dept_code" 		value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" 	id="req_user_id" 	value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" 		id="doc_type" 		value="PAY">
		<input type="hidden" name="fnc_name" 		id="fnc_name" 		value="getApproval">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>	

		<input type="hidden" name="company_code"    id="company_code"   value="<%=company_code%>">
		<input type="hidden" name="approval_str"    id="approval_str"   value="">
		<input type="hidden" name="tax_no"    		id="tax_no"   		value="<%=taxNo%>">

		<input type="hidden" name="nts_app_no"    	id="nts_app_no"   	value="">
		<input type="hidden" name="acc_tax_no"    	id="acc_tax_no"   	value="">
		<input type="hidden" name="acc_tax_date"    id="acc_tax_date"   value="">
		<input type="hidden" name="acc_tax_seq"    	id="acc_tax_seq"   	value="">
		<input type="hidden" name="isu_dt"    	    id="isu_dt"   	value="">
		<input type="hidden" name="exe_am"    	    id="exe_am"   	value="">
		<input type="hidden" name="spl_am"    	    id="spl_am"   	value="">
		<input type="hidden" name="tax_am"    	    id="tax_am"   	value="">
	
	
		<input type="hidden" name="itemSize"    	id="itemSize"   	value="">
	
	    <input type="hidden"    id="user_trm_no"      name="user_trm_no"      value="">
	    <input type="hidden"    id="txtBrowserInfo"   name="txtBrowserInfo"   value="">
	    <INPUT type="hidden"  id="txtLevel"            name="txtLevel"         value="10">
	    <INPUT type="hidden"  id="txtManagerList"   name="txtManagerList"   value="">
	    
	    <INPUT type="hidden"  id="ziphangnm"   name="ziphangnm"   value="">
	    
	    
	
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
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
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
										<td class="data_td" width="20%">&nbsp; <%=vendor_code %>
											<input type="hidden" id="vendor_code" name="vendor_code" value="<%=vendor_code %>">
										</td>
 										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;기준일자&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%">
											<s:calendar id="std_date" default_value="<%=SepoaString.getDateSlashFormat(tax_date)%>" 	format="%Y/%m/%d"/>
										</td>
										<td width="13%" class="title_td"></td>
										<td class="data_td" width="21%" align="right">
<script language="javascript">
btn("javascript:fnTaxSearch();","세금계산서 조회");
</script>											
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br />
		
		<s:grid screen_id="TX_012_1" grid_obj="GridObj" grid_box="gridbox" height="200" />

		<br />
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체명</td>
										<td class="data_td" width="20%">&nbsp; <%=VENDOR_NAME_LOC %><input type="hidden" id="vendor_name_loc" name="vendor_name_loc" value="<%=VENDOR_NAME_LOC %>">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;주민사업자번호</td>
										<td class="data_td" width="20%">&nbsp; <%=IRS_NO%>
											<input type="hidden" id="irs_no" name="irs_no" value="<%=IRS_NO %>">
										</td>
										<td width="13%" class="title_td">&nbsp;</td>
										<td class="data_td" width="21%">&nbsp</td>
									</tr>
						    		<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;집행금액</td>
										<td class="data_td" width="20%">&nbsp; <%=SepoaMath.SepoaNumberType(TOT_AMT, "###,###,###,###,###,###") %>
											<input type="hidden" id="tot_amt" name="tot_amt" value="<%=TOT_AMT %>">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급가액</td>
										<td class="data_td" width="20%">&nbsp; <%=SepoaMath.SepoaNumberType(SUP_AMT, "###,###,###,###,###,###") %>
											<input type="hidden" id="supply_amt" name="supply_amt" value="<%=SUP_AMT %>">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세액</td>
										<td class="data_td" width="21%">&nbsp; <%=SepoaMath.SepoaNumberType(VAT_AMT, "###,###,###,###,###,###") %>
											<input type="hidden" id="tax_amt" name="tax_amt" value="<%=VAT_AMT %>">
										</td>
									</tr>
							    	<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금은행&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%">&nbsp;
											<select id="bank_code" name="bank_code" disabled="disabled">
												<option value="">선택</option>
<%
	String comstr = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M349", BANK_CODE);
	out.print(comstr);
%>
											</select> 
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금은행계좌번호&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%" >&nbsp; 
											<input type="text" id="bank_acct" name="bank_acct" style="width: 90%;" value="<%=BANK_ACCT%>" readonly="readonly">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예금주명&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="21%" >&nbsp; 
											<input type="text" id="depositor_name" name="depositor_name" style="width: 40%;" value="<%=DEPOSITOR_NAME%>" readonly="readonly">
										</td>
									</tr>								
									<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예산년도&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%">&nbsp; 
											<select id="bmsbmsyy" name="bmsbmsyy">
												<option value="<%= SepoaDate.getYear() - 2%>"><%= SepoaDate.getYear() - 2%></option>
												<option value="<%= SepoaDate.getYear() - 1%>"><%= SepoaDate.getYear() - 1%></option>
												<option value="<%= SepoaDate.getYear()    %>" selected="selected"><%= SepoaDate.getYear()    %></option>
												<option value="<%= SepoaDate.getYear() + 1%>"><%= SepoaDate.getYear() + 1%></option>
											</select>
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부점코드&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%">&nbsp; 
											<input type="text" id="bugumcd" name="bugumcd" readonly="readonly" value="<%=info.getSession("DEPARTMENT")%>" style="width: 50px;"> 
											<img align="absMiddle" alt="" src="/images/button/butt_query.gif" border="0" complete="complete" style="cursor: pointer;" onclick="javascript:PopupManager('DELY_TO_ADDRESS');" />
											<input type="text" id="bugumnm" name="bugumnm" readonly="readonly" value="<%=info.getSession("DEPARTMENT_NAME_LOC")%>" style="width: 50px;">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결의일자&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="21%">&nbsp; <s:calendar id="act_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" 	format="%Y/%m/%d"/></td>
									</tr>
									<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;경비코드&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="20%">&nbsp; 
											<select id="expensecd" name="expensecd" onchange="javascript:fnExpenseCdChange(this);">
												<option value="">선택</option>
<%
	String comstr1 = ListBox(request, "SL0018", house_code + "#M810", "");		
	out.print(comstr1);
%>
											</select>									
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세목코드&nbsp;<font color="red" id="semokstar" style="display:none;"><b>*</b></font></td>
										<td class="data_td" width="20%">&nbsp; 
											<select id="semokcd" name="semokcd"  onchange="javascript:fnSemokCdChange(this);"   style="display:none;">>
												<option value="">선택</option>
											</select>									
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세부코드&nbsp;<font color="red" id="sebustar" style="display:none;"><b>*</b></font><br />&nbsp;&nbsp;&nbsp;&nbsp;/집행대상장소코드</td>
										<td class="data_td" width="21%">&nbsp; 
											<select id="sebucd" name="sebucd"  style="display:none;">
												<option value="">선택</option>
											</select>
											<br />		
											&nbsp;
											<select id="ziphangcd" name="ziphangcd" onchange="javascript:fnZiphangcdChange(this);" style="display:none;">
												<option value="">선택</option>
											</select>
										</td>
									</tr>
							    	<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;증빙구분</td>
										<td class="data_td" width="20%">&nbsp; 
											<input type="text" id="doc_type_txt" 	name="doc_type_txt" value="09-전자세금계산서" readonly="readonly">
											<input type="hidden" id="doc_type_loc" 	name="doc_type_loc" value="09">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;금액구분</td>
										<td class="data_td" width="20%">&nbsp; 
											<input type="text" id="pay_type_txt" 	name="pay_type_txt" value="2-대체" readonly="readonly">
											<input type="hidden" id="pay_type" 		name="pay_type" 	value="2">
										</td>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업코드&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" width="21%">&nbsp; 
											<input type="text" id="saupcd" name="saupcd" value="" readonly="readonly" style="width: 50px;">
											<img align="absMiddle" alt="" src="/images/button/butt_query.gif" border="0" complete="complete" style="cursor: pointer;" onclick="javascript:PopupManager('SAUP');" />
											<input type="text" id="saupnm" name="saupnm" value="" readonly="readonly" style="width: 50px;">
										</td>
									</tr>									
							    	<tr>
										<td colspan="6" height="1" bgcolor="#dedede"></td>
									</tr>  								
									<tr>
										<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급사유&nbsp;<font color="red"><b>*</b></font></td>
										<td class="data_td" colspan="5">&nbsp; 
											<input type="text" id="pay_reason" name="pay_reason" style="width: 98%;" onKeyUp="return chkMaxByte(150, this, '지급사유');">
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
				<td align="right">
					<table>
						<tr>
							<%-- ASIS 2017-07-01 <td> --%>
							<%-- TOBE 2017-07-01 버튼 ID 추가 --%>
							<td id="tdBEB00730T02">
<script language="javascript">
btn("javascript:fnApproval();","결재요청");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:window.close();","닫 기");
</script>
							</td>
						</tr>	
					</table>
				</td>
			</tr>
		</table> 
	</form>
	<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
</s:header>
<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<!-- ASIS 2017-07-01
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
 -->
<!-- TOBE 2017-07-01 -->
<object ID="XFramePLUS" CLASSID="CLSID:D6091B5A-D59C-454b-83A4-FA489E94BE0B" width=0 height=0 VIEWASTEXT></object>
 
</body>
</html>