<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("STA043");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "STA043";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";
	

%>
<%
//bidding Approval 사용여부
String bd_approval = CommonUtil.getConfig("wise.bd_approval.use");
%>


<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String VENDOR_CODE = JSPUtil.getString(request.getParameter("vendor_code"), "");
    String PO_NO = JSPUtil.getString(request.getParameter("po_no"), "");
    String LB_BID_STATUS 	= ListBox(request, "SL0102", HOUSE_CODE + "#"+"M137", "");
    String LB_PR_TYPE       = ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", "");
    
    if(!"".equals(PO_NO) && PO_NO.length() > 1){
    	PO_NO = PO_NO.substring(1);
    }
%>

<% String WISEHUB_PROCESS_ID="STA043";%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/statistics.sta_bd_lis43";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;

var INDEX_SELECTED;
var INDEX_SUBJECT; 
var INDEX_PO_NO; 
var INDEX_PO_SEQ;
var INDEX_ITEM_NO;
var INDEX_DESCRIPTION_LOC;
var INDEX_CONTRACT_TO_DATE;
var INDEX_UNIT_MEASURE;
var INDEX_ITEM_QTY;
var INDEX_PO_AMT;
var INDEX_YN;
var INDEX_ADD_DATE;
var INDEX_ADD_TIME;
var INDEX_ADD_USER_ID;
var INDEX_CHANGE_DATE;
var INDEX_CHANGE_TIME;
var INDEX_CHANGE_USER_ID;  
var INDEX_TAX_NO;  

var mode = "";
function setHeader() 
{
    var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
    GridObj.strHDClickAction="sortmulti";


    
    INDEX_SELECTED          	= GridObj.GetColHDIndex("SELECTED");
    INDEX_SUBJECT            	= GridObj.GetColHDIndex("SUBJECT");   
    INDEX_PO_NO       	= GridObj.GetColHDIndex("PO_NO");   
    INDEX_PO_SEQ       	= GridObj.GetColHDIndex("PO_SEQ");
    INDEX_ITEM_NO        	= GridObj.GetColHDIndex("ITEM_NO");
    INDEX_DESCRIPTION_LOC	= GridObj.GetColHDIndex("DESCRIPTION_LOC");    
    INDEX_CONTRACT_TO_DATE    			= GridObj.GetColHDIndex("CONTRACT_TO_DATE");
    INDEX_UNIT_MEASURE			= GridObj.GetColHDIndex("UNIT_MEASURE");
    INDEX_ITEM_QTY				= GridObj.GetColHDIndex("ITEM_QTY");
    INDEX_PO_AMT              = GridObj.GetColHDIndex("PO_AMT");  
    INDEX_YN              = GridObj.GetColHDIndex("YN");
    INDEX_ADD_DATE              = GridObj.GetColHDIndex("ADD_DATE");
    INDEX_ADD_TIME              = GridObj.GetColHDIndex("ADD_TIME");
    INDEX_ADD_USER_ID              = GridObj.GetColHDIndex("ADD_USER_ID");
    INDEX_CHANGE_DATE              = GridObj.GetColHDIndex("CHANGE_DATE");
    INDEX_CHANGE_TIME              = GridObj.GetColHDIndex("CHANGE_TIME");
    INDEX_CHANGE_USER_ID              = GridObj.GetColHDIndex("CHANGE_USER_ID");    
    INDEX_TAX_NO              = GridObj.GetColHDIndex("TAX_NO");    
     
    
    

}

function init()
{
	setGridDraw();
	setHeader();
    doSelect();
    
}

function doSelect()
{
    var f = document.forms[0];
    var wise = GridObj;
    
    var from_date       = LRTrim(f.add_date.value);
//     var to_date         = LRTrim(f.end_add_date.value); 
//     var pr_type         = LRTrim(f.pr_type.value); 
//     var demand_dept     = LRTrim(f.demand_dept.value); 
//     var add_user_id     = LRTrim(f.add_user_id.value);  
//     var pr_status       = LRTrim(f.pr_status.value);
//     var sign_status     = LRTrim(f.sign_status.value); 
//     var order_no        = LRTrim(f.order_no.value);
 
    
   // alert("add_date = "+f.add_date.value);
//     if(from_date == "")
//     {
//         alert("생성일자를 입력하셔야 합니다.");
//         return;
//     }
//     if(!checkDate(from_date)) {
//         alert("생성일자를 확인하세요.");
//         f.start_add_date.select();
//         return;
//     }
//     if(!checkDate(from_date)) {
//         alert("생성일자를 확인하세요.");
//         f.end_add_date.select();
//         return;
//     }
    
    
<%-- 	var cols_ids = "<%=grid_col_id%>"; --%>
// 	var params = "mode=prItemsList";
	
// 	params += "&cols_ids=" + cols_ids;
// 	params += dataOutput();    

	document.forms[0].add_date.value = del_Slash( document.forms[0].add_date.value );
	document.forms[0].end_date.value = del_Slash( document.forms[0].end_date.value );
	
	var cols_ids = "<%=grid_col_id%>";
    mode = "getStaOrdList";//dt.rfq.ebd_bd_lis3

    var params = "mode=" + mode;
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);    
}
 
function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
    if(msg1 == "doQuery") {
        //var server_time1 = GD_GetParam(GridObj,1);
    }
    
    if(msg1 == "doData") {
    	doSelect();
    }
    
    if (msg1 == "t_imagetext") {
        G_CUR_ROW   = msg2;
        
        if(msg3 == INDEX_PR_NO) { 
		    var pr_no = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_PR_NO), msg2); 
            window.open("ebd_pp_dis6.jsp?pr_no="+pr_no,"win1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");     
        } else if(msg3 == INDEX_RETURN_REASON) {
        	if(GridObj.GetCellValue("RETURN_REASON", msg2) == ""){
        		return;
        	}

			var left = 150;
			var top = 150;

			var ReasonWin = window.open('/kr/dt/pr/pr_pp_dis1.jsp?pRow='+G_CUR_ROW+'&pCol=RETURN_REASON',"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=600,height=300,left="+left+",top="+top);
			ReasonWin.focus();
       }
    }
}

function checkUser() 
{
    //var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
    var add_user_id = "<%=info.getSession("ID")%>";
    var flag = true;
    var rowcount = GridObj.GetRowCount();
    
    for (var row = 0; row < rowcount; row++) 
    {
        if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) 
        {
            //for(i=0; i < ctrl_code.length; i++ ) 
            //{
                if (add_user_id == GD_GetCellValueIndex(GridObj,row, INDEX_ADD_USER_ID)) 
                {
                    flag = true;
                    //break;
                } else {
                    flag = false;
                }
            //}
        }
    }
    return flag;
}
function doInsert(){
	var wise          = GridObj;
	var iRowCount     = GridObj.GetRowCount();
	
	var iCheckedCount = getCheckedCount(wise, "SELECTED");
	//var arr           = new Array(G_INDEXES.length);

	
	if(iCheckedCount == 0){
		alert(G_MSS1_SELECT);
		
		return;
    }

    //var arr_cnt = 0;
    //alert("..........iRowCount="+iRowCount + ",  iCheckedCount="+iCheckedCount);
    var iCount = 0;
    for(var i=0; i<iRowCount; i++){
      //  alert(".........i="+i + " iCheckedCount="+iCheckedCount+ ", iCount ="+iCount);

        if(iCount >= iCheckedCount) break;
        if( GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED) == true){

        	iCount++;
			    //parent.opener.pStaOrdList();
            	parent.opener.setCatalog(

       				GD_GetCellValueIndex(GridObj, i, INDEX_SUBJECT),
       				GD_GetCellValueIndex(GridObj, i, INDEX_PO_NO),
       				GD_GetCellValueIndex(GridObj, i, INDEX_PO_SEQ),
       				GD_GetCellValueIndex(GridObj, i, INDEX_ITEM_NO),
       				GD_GetCellValueIndex(GridObj, i, INDEX_DESCRIPTION_LOC),
       				GD_GetCellValueIndex(GridObj, i, INDEX_CONTRACT_TO_DATE),
       				GD_GetCellValueIndex(GridObj, i, INDEX_UNIT_MEASURE),
       				GD_GetCellValueIndex(GridObj, i, INDEX_ITEM_QTY),
       				GD_GetCellValueIndex(GridObj, i, INDEX_PO_AMT),
       				GD_GetCellValueIndex(GridObj, i, INDEX_YN),
       				GD_GetCellValueIndex(GridObj, i, INDEX_ADD_DATE),
       				GD_GetCellValueIndex(GridObj, i, INDEX_ADD_TIME),
       				GD_GetCellValueIndex(GridObj, i, INDEX_ADD_USER_ID),
       				GD_GetCellValueIndex(GridObj, i, INDEX_CHANGE_DATE),
       				GD_GetCellValueIndex(GridObj, i, INDEX_CHANGE_TIME),
       				GD_GetCellValueIndex(GridObj, i, INDEX_CHANGE_USER_ID),      				
       				GD_GetCellValueIndex(GridObj, i, INDEX_TAX_NO)      				
       				 				
       			);

        }

    }
    //parent.opener.getItemValue();
	if (confirm ("선택되었습니다.\n\n발주정보 검색창을 닫으시겠습니까?")) {
		parent.window.close();
	}
}   
/**
* 담당자이거나 작성중이거나 예정 경우가 수정 가능합니다.
*/
// function doModify(){
//     if(!checkUser() == true){
//         alert("담당자만 수정 가능합니다.");
        
//         return;
//     }
        
//     var pass_flag = false;
// 	var checkCnt = 0;
// 	var iCheckedRow = 0;

// 	for(iCheckedRow = 0; iCheckedRow < GridObj.GetRowCount(); iCheckedRow++){
// 		if(GridObj.GetCellValue("SELECTED", iCheckedRow) == true){
// 			checkCnt ++;
// 		}
// 	}

// 	if(checkCnt == 0){
// 		alert("선택하신 항목이 없습니다.");
// 		return;
// 	}

// 	if(checkCnt > 1){
// 		alert("수정은 한건씩만 가능합니다");
// 		return;
// 	}
	
// 	for(iCheckedRow = 0; iCheckedRow < GridObj.GetRowCount(); iCheckedRow++){
// 		if(GridObj.GetCellValue("SELECTED", iCheckedRow) == true){
// 			break;
// 		}
// 	}
    
//     var SIGN_STATUS 		= GD_GetCellValueIndex(GridObj,iCheckedRow, INDEX_SIGN_STATUS);
//     var PR_PROCEEDING_FLAG 	= GD_GetCellValueIndex(GridObj,iCheckedRow, INDEX_PR_PROCEEDING_FLAG);
//     var ADD_USER_ID 		= GD_GetCellValueIndex(GridObj,iCheckedRow, INDEX_ADD_USER_ID);
//     var modify_flag = "Y";
    
//     if(PR_PROCEEDING_FLAG == "P"){
//     	if(SIGN_STATUS == "T"){}
//     	else if(SIGN_STATUS == "E"){
//     		modify_flag = "N";
//     	}
//     	else {}
//     }
//     else if(PR_PROCEEDING_FLAG == "R"){
//     	//modify_flag = "N";
//     }
//     else {
//     	modify_flag = "N";
//     }
    
//     if(modify_flag == "N"){
//         alert("수정은 진행상태가 작성중인 경우에 가능합니다.");
        
//         return;
//     }
    
//     var pr_no     = GD_GetCellValueIndex(GridObj,iCheckedRow, INDEX_PR_NO); 
//     var prType     = GD_GetCellValueIndex(GridObj, iCheckedRow, INDEX_PR_TYPE);
// 	var url  = null;
	
// 	if(prType == "I"){
// 		url  = "/kr/dt/ebd/ebd_bd_ins4_1_mainI.jsp?pr_no="+pr_no;
// 	}
// 	else{
// 		url  = "/kr/dt/ebd/ebd_bd_ins4_1_mainNotI.jsp?pr_no="+pr_no;
// 	}
    
//     var ebd_pop_id = window.open(url,"ebd_pop_id","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1012,height=650,left=0,top=0");
//     ebd_pop_id.focus();
// }

// function doDelete(){
//     if(!checkUser() == true){
//         alert("담당자만 삭제 가능합니다.");
        
//         return;
//     }
    
//     var f = document.forms[0];
//     var wise = GridObj;
//     var iRowCount = GridObj.GetRowCount();
//     var iCheckedCount = 0;
//     var delete_flag = "";
    
//     for(var i=0;i<iRowCount;i++){
//     	delete_flag = "Y";
    	
//         if(GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED) != true){
//         	continue;
//         }
            
//         var SIGN_STATUS 		= GD_GetCellValueIndex(GridObj,i, INDEX_SIGN_STATUS);
//         var PR_PROCEEDING_FLAG 	= GD_GetCellValueIndex(GridObj,i, INDEX_PR_PROCEEDING_FLAG);

// 		if(PR_PROCEEDING_FLAG == "P"){
//     		if(SIGN_STATUS == "T"){
    	
//     		}
//     		else if(SIGN_STATUS == "E"){
//     			delete_flag = "N";
//     		}
//     		else {}
//     	}
// 		else if(PR_PROCEEDING_FLAG == "R"){
//     		//delete_flag = "N";
//     	}
// 		else {
//     		delete_flag = "N";
//     	}
		
// 		if(delete_flag == "N"){
// 			alert("삭제는 진행상태가 작성/반려 중인 경우에 가능합니다.");
			
// 			return;
// 		}        
         
//         iCheckedCount++;
//     }
    
//     if(iCheckedCount<1){
//         alert(G_MSS1_SELECT);
        
//         return;
//     }
    
//     if(!confirm("선택된 사전지원요청번호를 모두 삭제하시겠습니까?")){
//     	return;
//     }
    
//     var grid_array = getGridChangedRows(GridObj, "SELECTED");
<%--     var cols_ids = "<%=grid_col_id%>"; --%>
//     var params;
//     params = "?mode=setBidDelete";
//     params += "&cols_ids=" + cols_ids;
//     params += dataOutput();
//     myDataProcessor = new dataProcessor(G_SERVLETURL+params);
//     sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
// }

/* 팝업관련코드 */
function PopupManager(part)
{
    var wise = GridObj;
    var url = "";
    if(part == "CTRL_CODE")
    {
        PopupCommon2("SP0216","get_CtrlCode",G_HOUSE_CODE, G_COMPANY_CODE, "", "");
    }
    else if(part=="DEMAND_DEPT")
    { 
        window.open("/common/CO_009.jsp?callback=getDeptUser", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "BID_COUNT")
    {
        var rfq_no    = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_PR_NO);
        var rfq_count = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_RFQ_COUNT);
        url = '/kr/dt/ebd/ebd_pp_dis2.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count+'&call_pgm=ebd_bd_lis1';
        PopupGeneral(url, "", "", "", "1012", "650");   
        
    }
    else if(part == "ADD_USER_ID")
    { 
        window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    } 
}

/* 오프너로부터 얻어오는 부분 */

function start_add_date(year,month,day,week) 
{
    document.form1.start_add_date.value = year+month+day;
}
function end_add_date(year,month,day,week) 
{
    document.form1.end_add_date.value = year+month+day;
}
function get_CtrlCode(ls_ctrl_code, ls_ctrl_name)
{
    document.form1.ctrl_code.value = ls_ctrl_code;
    document.form1.txtpurchaserUser.value = ls_ctrl_name;
}
function getDeptUser(code, text)
{
    document.form1.demand_dept_name.value = text;
    document.form1.demand_dept.value = code; 
}
function getAddUser(code, text)
{
    document.form1.add_user_name.value = text;
    document.form1.add_user_id.value = code; 
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
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var prNo       = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_NO);
		var prType     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_TYPE);
		var page       = null;
		
		if(prType == "I"){
			page = "ebd_pp_dis6I.jsp";
		}
		else{
			page = "ebd_pp_dis6NotI.jsp";
		}
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
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
    
    document.forms[0].add_date.value = add_Slash( document.forms[0].add_date.value );
    document.forms[0].end_date.value = add_Slash( document.forms[0].end_date.value );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
<!--내용시작-->
<table>
	<tr>
		<td height="20" align="left" class="title_page" vAlign="bottom">
		세금계산서 정보 조회
		</td>
	</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<form name="form1" action="">
	<input type="hidden" id="h_rfq_no" 		name="h_rfq_no">
  	<input type="hidden" id="h_rfq_count" 	name="h_rfq_count">
  	<input type="hidden" id="ctrl_code" 	name="ctrl_code">
  	<input type="hidden" id="pr_no" 		name="pr_no">
  	<input type="hidden" id="pr_seq" 		name="pr_seq">


 
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
        	<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급업체 코드</td>
            <td class="data_td"><%=VENDOR_CODE%>
				<input type="hidden" id="vendor_code" name="vendor_code" value="<%=VENDOR_CODE%>" readonly="readonly">
				<input type="hidden" id="po_no" name="po_no" value="<%=PO_NO%>" readonly="readonly">
			</td>
        	<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주일자</td>
            <td class="data_td">
            	<s:calendar id="add_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" format="%Y/%m/%d"/> ~
            	<s:calendar id="end_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 0) )%>" format="%Y/%m/%d"/>
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
                        <TD><script language="javascript">btn("javascript:doSelect()","조 회")    			</script></TD>
                        <TD><script language="javascript">btn("javascript:doInsert()","선택완료")   			</script></TD> 
                        <TD><script language="javascript">btn("javascript:window.close()","닫 기")   		</script></TD> 
                    </TR>
                </TABLE>
            </td>
        </tr>
    </table>
</form>
</s:header>
<s:grid screen_id="STA043" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>