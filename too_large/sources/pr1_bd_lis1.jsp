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
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id             = "PR_008";
	String  grid_obj              = "GridObj";
	String  WISEHUB_PROCESS_ID    = "PR_008";
	String  house_code            = info.getSession("HOUSE_CODE");
	String  company_code          = info.getSession("COMPANY_CODE");
	String  LB_CODE_SIGN_STATUS   = "";
	String  LB_PR_PROCEEDING_FLAG = ListBox(request, "SL0007",  house_code+"#M157#", "");
	boolean isSelectScreen        = false;
	String  G_IMG_ICON            = "/images/ico_zoom.gif";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript"><!--
var mode;
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr1_bd_lis1";
var G_ADD_USER_ID  = "<%=info.getSession("ID")%>"
var G_DEPT         = "<%=info.getSession("DEPARTMENT")%>";
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";
var INDEX_SELECTED        ;
var INDEX_PR_NO		  	  ;
var INDEX_SUBJECT		  ;
var INDEX_ORDER_NO        ;
var INDEX_ADD_DATE		  ;
var INDEX_DEMAND_DEPT     ;
var INDEX_DEMAND_DEPT_NAME;
var INDEX_ADD_USER_NAME   ;
var INDEX_ADD_USER_ID     ;
var INDEX_SALES_TYPE      ;
var INDEX_PR_TYPE         ;
var INDEX_SALES_AMT       ;
var INDEX_PR_AMT    	  ;
var INDEX_PR_KRW_AMT      ;
var INDEX_CUST_NAME	      ;
var INDEX_SIGN_STATUS	  ;
var INDEX_CTRL_DATE	      ;
var INDEX_PURCHASER_NAME  ;
var INDEX_PR_PROCEEDING_FLAG;
var INDEX_ITEM_NO;

var G_CUR_ROW;

function setHeader(){
	GridObj.bHDMoving           = false;
	GridObj.bHDSwapping         = false;
	GridObj.bRowSelectorVisible = false;
	GridObj.strRowBorderStyle   = "none";
	GridObj.nRowSpacing         = 0 ;
	GridObj.strHDClickAction    = "select";
	
	var wise = GridObj;
		
	GridObj.SetDateFormat("ADD_DATE", "yyyy/MM/dd");
	GridObj.SetDateFormat("CTRL_DATE","yyyy/MM/dd");
	GridObj.SetDateFormat("RD_DATE","yyyy/MM/dd");

	INDEX_SELECTED           = GridObj.GetColHDIndex("SELECTED");
	INDEX_PR_NO		     	 = GridObj.GetColHDIndex("PR_NO");
	INDEX_SUBJECT		     = GridObj.GetColHDIndex("SUBJECT");
	INDEX_ORDER_NO           = GridObj.GetColHDIndex("ORDER_NO");
	INDEX_ADD_DATE		     = GridObj.GetColHDIndex("ADD_DATE");
	INDEX_DEMAND_DEPT        = GridObj.GetColHDIndex("DEMAND_DEPT");
	INDEX_DEMAND_DEPT_NAME   = GridObj.GetColHDIndex("DEMAND_DEPT_NAME");
	INDEX_ADD_USER_NAME      = GridObj.GetColHDIndex("ADD_USER_NAME");
	INDEX_ADD_USER_ID        = GridObj.GetColHDIndex("ADD_USER_ID");
	INDEX_SALES_TYPE         = GridObj.GetColHDIndex("SALES_TYPE");
	INDEX_PR_TYPE            = GridObj.GetColHDIndex("PR_TYPE");
	INDEX_SALES_AMT          = GridObj.GetColHDIndex("SALES_AMT");
	INDEX_PR_AMT    	     = GridObj.GetColHDIndex("PR_AMT");
	INDEX_PR_KRW_AMT         = GridObj.GetColHDIndex("PR_KRW_AMT");
	INDEX_CUST_NAME	         = GridObj.GetColHDIndex("CUST_NAME");
	INDEX_SIGN_STATUS	     = GridObj.GetColHDIndex("SIGN_STATUS");
	INDEX_CTRL_DATE	         = GridObj.GetColHDIndex("CTRL_DATE");
	INDEX_PURCHASER_NAME     = GridObj.GetColHDIndex("PURCHASER_NAME");
	INDEX_CTRL_CODE     	 = GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_PR_PROCEEDING_FLAG = GridObj.GetColHDIndex("PR_PROCEEDING_FLAG");
	INDEX_PR_STATUS    		 = GridObj.GetColHDIndex("PR_STATUS");
	INDEX_ITEM_NO	     	 = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_RETURN_REASON			= GridObj.GetColHDIndex("RETURN_REASON");
	INDEX_RETURN_REASON_TEXT	= GridObj.GetColHDIndex("RETURN_REASON_TEXT");

	GridObj.strHDClickAction="sortmulti";
	
	//doSelect();
}

function doSelect(){
	var f    = document.forms[0];
	var wise = GridObj;

	if(LRTrim(f.add_date_start.value) == "" || LRTrim(f.add_date_end.value) == ""){
		alert("생성일자를 입력하셔야 합니다.");
			
		return;
	}
		
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=prQueryList";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post(G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function checkUpdate(wise, row){
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;
	var rowcount = GridObj.GetRowCount();

	for (var row = 0; row < rowcount; row++){
		if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
			for(i=0; i < ctrl_code.length; i++ ){
				if (ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)){
					flag  = true;
					
					break;
				}
				else {
					flag  = false;
				}
			}
			
			return flag;
		}
	}

	var SIGN_STATUS = GD_GetCellValueIndex(GridObj,row, INDEX_SIGN_STATUS);

	if( (SIGN_STATUS=='T') || (SIGN_STATUS=='R') || (SIGN_STATUS=='D')){
		return true;
	}

	alert("수정/삭제는 작성중이거나 결재취소/반려된 항목일때 가능합니다.");
	
	return false;
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;
	
	if(msg1 == "doQuery" ){}
	
	if(msg1 == "doData"){
		doSelect();
	}
	else if(msg1 == "t_imagetext") {
		var left = 30;
		var top = 30;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var width = "";
		var height = "";
		
		G_CUR_ROW   = msg2;
		
		if(msg3 == INDEX_PR_NO){
			pr_no = GridObj.GetCellValue(GridObj.GetColHDKey( msg3),msg2);
			
			window.open('pr1_bd_dis1.jsp?pr_no='+pr_no ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
		}
		
		if(msg3 == INDEX_ITEM_NO){
			var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
			width = 750;
			height = 550;
			var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
			var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width=750, height=550, toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			
			PoDisWin.focus();
		}
		else if(msg3 == INDEX_RETURN_REASON) {
			if(GridObj.GetCellValue("RETURN_REASON", msg2) == ""){
				return;
			}

			var left = 150;
			var top = 150;

			var ReasonWin = window.open('/kr/dt/pr/pr_pp_dis1.jsp?pRow='+G_CUR_ROW+'&pCol=RETURN_REASON',"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=600,height=300,left="+left+",top="+top);
			
			ReasonWin.focus();
		}
	}
	else  if(msg1 == "t_insert") {
		if(msg3 == INDEX_SELECTED){}
	}
}

function selectCond(wise, selectedRow){
	var wise = GridObj;
	var cur_pr_no  	 = GD_GetCellValueIndex(wise,selectedRow, INDEX_PR_NO);
	var iRowCount   	 = wise.GetRowCount();
	
	for(var i=0;i<iRowCount;i++){
		if(i==selectedRow){
			continue;
		}
			
		if(cur_pr_no == GD_GetCellValueIndex(wise,i,INDEX_PR_NO)){
			var flag = "true";
			
			if(GD_GetCellValueIndex(wise,i,INDEX_SELECTED) == "true"){
				flag = "false";
			}

			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
		else{
			var flag = "false";
			
			GD_SetCellValueIndex(wise,i,INDEX_SELECTED,flag + "&","&");
		}
	}
}

function add_date_start(year,month,day,week) {
	document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
	document.form1.add_date_end.value=year+month+day;
}

function sign_date_start(year,month,day,week) {
	document.form1.sign_date_start.value=year+month+day;
}

function sign_date_end(year,month,day,week) {
	document.form1.sign_date_end.value=year+month+day;
}

function MM_goToURL() { //v3.0
	var i, args=MM_goToURL.arguments; document.MM_returnValue = false;
	
	for (i=0; i<(args.length-1); i+=2){
		eval(args[i]+".location='"+args[i+1]+"'");
	}
}

//enter를 눌렀을때 event발생
function entKeyDown(){
	if(event.keyCode==13){
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		doSelect();
	}
}

function PopupManager(part){
	var url = "";
	var f = document.forms[0];

	if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "ADD_USER_ID"){
		window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getDemand(code, text){
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

function getAddUser(code, text){
	document.form1.add_user_name.value = text;
	document.form1.add_user_id.value = code;
}


//추가(20110217)
function checkUser(){
    var add_user_id = "<%=info.getSession("ID")%>";
    var flag = true;
    var rowcount = GridObj.GetRowCount();

    for (var row = 0; row < rowcount; row++){
		if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
			if (add_user_id == GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_ID)) {
				flag = true;
			}
			else {
				flag = false;
			}
        }
    }
    
    return flag;
}

/**
* 담당자이거나 작성중이거나 예정 경우가 수정 가능합니다.
*/
function doModify(){
	if(checkUser() == false) {
        alert("구매요청자만 수정 가능합니다.");
        
        return;
    }

    var wise = GridObj;
    var iRowCount = GridObj.GetRowCount();
    var iCheckedCount = 0;
	
    var pr_no = "";
    
    for(var i=0;i<iRowCount;i++){
        if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "0"){
        	continue;
        }
            
        var SIGN_STATUS 		= GD_GetCellValueIndex(GridObj,i, INDEX_SIGN_STATUS);			//3
        var PR_PROCEEDING_FLAG 	= GD_GetCellValueIndex(GridObj,i, INDEX_PR_PROCEEDING_FLAG);	//2
        
		pr_no 				= GD_GetCellValueIndex(GridObj,i, INDEX_PR_NO);
		
	    var modify_flag = "N"; // 수정가능 : T(작성중), R(담당자 반려)
        
	    if (PR_PROCEEDING_FLAG == "P") {
	    	if(SIGN_STATUS == "T" || SIGN_STATUS == "D" || SIGN_STATUS == "R") {
	    		modify_flag = "Y";
	    	}
	    }
	    else if(PR_PROCEEDING_FLAG == "R"){
	    	modify_flag = "Y";
	    }
	    
	    if(modify_flag == "N"){
	        alert("수정은 진행상태가 [작성/반려] 인 경우에만 가능합니다.");
	        return;
	    }
	    
        iCheckedCount++;
    }
	
    if(iCheckedCount < 1){
        alert(G_MSS1_SELECT);
        
        return;
    }
    
    var url  = "/sourcing/pr_req_update.jsp?pr_no=" + pr_no + "&popup_flag=true";	//프레임셋 거치지 않고
    var ebd_pop_id = window.open(url,"ebd_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1012,height=650,left=0,top=0");
    ebd_pop_id.focus();
}

function doDelete(){
    if(!checkUser() == true) {
        alert("구매요청자만 삭제 가능합니다.");
        
        return;
    }
    
    var f = document.forms[0];
    var wise = GridObj;
    var iRowCount = GridObj.GetRowCount();
    var iCheckedCount = 0;
    var delete_flag = "";
    
    for(var i=0;i<iRowCount;i++){
        if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "0"){
        	continue;
        }
        
        var SIGN_STATUS 		= GD_GetCellValueIndex(GridObj,i, INDEX_SIGN_STATUS);
        var PR_PROCEEDING_FLAG 	= GD_GetCellValueIndex(GridObj,i, INDEX_PR_PROCEEDING_FLAG);
		
	    
	    var delete_flag = "N"; // 수정가능 : T(작성중), R(담당자 반려)
	    
	    if (PR_PROCEEDING_FLAG == "P") {
	    	if(SIGN_STATUS == "T" || SIGN_STATUS == "D"|| SIGN_STATUS == "R") {
	    		delete_flag = "Y";
	    	}
	    }
	    else if(PR_PROCEEDING_FLAG == "R"){
    		delete_flag = "Y";
    	}
		
	    if(delete_flag == "N"){
	        alert("삭제는 진행상태가 작성중 인 경우에만 가능합니다.");
	        return;
	    }
		
        iCheckedCount++;
    }

    if(iCheckedCount<1){
        alert(G_MSS1_SELECT);
        
        return;
    }

    if(confirm("일부 삭제시 요청건 모두 삭제됩니다. \n삭제하시겠습니까?") == false){
    	return;
    }
    
    var grid_array = getGridChangedRows(GridObj, "SELECTED");
    var cols_ids = "<%=grid_col_id%>";
    var params;
    
    params = "?mode=setBidDelete";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    
    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_lis3" + params);
    
    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}

function doCopy(){
	
	if( !checkRows() ) return;
	
    var wise = GridObj;
    var iRowCount = GridObj.GetRowCount();
    var iCheckedCount = 0;
	
    var pr_no = "";
    
    for(var i=0;i<iRowCount;i++){
        if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) == "false"){
        	continue;
        }
            
        pr_no = GD_GetCellValueIndex(GridObj,i, INDEX_PR_NO);
        
        iCheckedCount++;
    }
	
    if(iCheckedCount < 1){
        alert(G_MSS1_SELECT);
        
        return;
    }
	
    if(!confirm("선택한 구매요청을 복사하시겠습니까?")){
    	return;
    }
	
    var grid_array = getGridChangedRows(GridObj, "SELECTED");
    var cols_ids = "<%=grid_col_id%>";
    var params;
    
    params = "?mode=setPRCopy";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    
    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_lis3" + params);
    
    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function settleHistory(){
	var pr_no 		= "";
	var pr_seq 		= "";
	var checkCnt 	= 0;
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			pr_no 	= GridObj.GetCellValue("PR_NO", i);
			pr_seq 	= GridObj.GetCellValue("PR_SEQ", i);
			checkCnt++;
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		return;
	}

	if(checkCnt > 1){
		alert("한건만 선택해주십시요.");
		return;
	}

	document.form1.pr_no.value = pr_no;
	document.form1.pr_seq.value = pr_seq;
	
	var url = "/kr/dt/pr/vendor_settle_history.jsp";
	
	window.open( "", "vendorSettleHistory", "left=30, top=30, width=700, height=500, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no");
	
	document.form1.action = url;
	document.form1.method = "POST";
	document.form1.target = "vendorSettleHistory";
	document.form1.submit();
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
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var prNo       = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_NO);
		var prType     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_TYPE);
		var page       = null;
		
		if(prType == "I"){
			page = "pr1_bd_dis1I.jsp";
		}
		else{
			page = "pr1_bd_dis1NotI.jsp";
		}
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}
	else if(cellInd == GridObj.getColIndexById("ITEM_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var itemNo     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	}
	
	else if(cellInd == GridObj.getColIndexById("RETURN_REASON")) {
		var selectedId 		= GridObj.getSelectedId();
		var rowIndex   		= GridObj.getRowIndex(selectedId);
		var returnReason    = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_RETURN_REASON_TEXT);
		var proceedingFlag  = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_PROCEEDING_FLAG);
		
		if(returnReason == ""){
			return;
		}
	
		var left = 150;
		var top = 150;
	
		var ReasonWin = window.open('/kr/dt/pr/pr_pp_dis1.jsp?pRow='+rowIndex+'&pCol=RETURN_REASON_TEXT&pFlag=' + proceedingFlag,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=600,height=300,left="+left+",top="+top);
		
		ReasonWin.focus();
	}
}

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

    if(status == "true") {
        alert(messsage);
        doSelect();
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
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "demand_dept" ) {
    	document.forms[0].demand_dept.value = "";
        document.forms[0].demand_dept_name.value = "";
    }  
    if( type == "add_user_id" ) {
    	document.forms[0].add_user_id.value = "";
        document.forms[0].add_user_name.value = "";
    }
}
--></script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">
		<input type="hidden" name="pr_type" id="pr_type" value="">		<%--요청구분--%>
		<input type="hidden" name="sales_type" id="sales_type" value="">	<%--매출구분--%>
		<input type="hidden" name="sign_status" id="sign_status" value="">	<%--결재상태--%>
		<input type="hidden" name="order_no" id="order_no" value="">	<%--관리코드(수주번호)--%>
	  	<input type="hidden" name="pr_no" id="pr_no">
	  	<input type="hidden" name="pr_seq" id="pr_seq">
	  	<input type="hidden" name="maching_code" value="">
	  	
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td width="35%" class="data_td">
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), -1))%>" format="%Y/%m/%d"/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="demand_dept" id="demand_dept" style="ime-mode:inactive" size="10" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>' >
											<a href="javascript:PopupManager('DEMAND_DEPT');">
            									<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
        									</a>
        									<a href="javascript:doRemove('demand_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="10" maxlength="15" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>' readOnly>
										</td> 
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청담당자</td>
										<td class="data_td">
											<input type="text" name="add_user_id" id="add_user_id" style="ime-mode:disabled" size="15" maxlength="10" onkeydown="JavaScript: entKeyDown();" class="inputsubmit" value='<%=info.getSession("ID")%>' >
											<a href="javascript:PopupManager('ADD_USER_ID');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('add_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="add_user_name" id="add_user_name" size="20" onkeydown='entKeyDown()' readonly value='<%=info.getSession("NAME_LOC")%>'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
										<td class="data_td" width="35%">
											<select name="pr_status" id="pr_status" class="inputsubmit" onkeydown='entKeyDown()'>
												<option value="" selected>전체</option>
												<%=LB_PR_PROCEEDING_FLAG%>
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
	</form>
	<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
		<TR>
			<TD height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:doModify()","수 정");
</script>
						</TD>
						<TD>
<script language="javascript">
btn("javascript:doDelete()","삭 제");
</script>
						</TD>
<!-- btn("javascript:doCopy()","구매요청복사"); -->
<!-- 						<TD> -->
<%-- <script language="javascript"> --%>
<%-- </script> --%>
<!-- 						</TD> -->
						<TD style="display: none;">
<script language="javascript">
btn("javascript:settleHistory()","업체선정이력");
</script>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>