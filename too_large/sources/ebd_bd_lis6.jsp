<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}

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
	multilang_id.addElement("PR_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="PR_004";

	//bidding Approval 사용여부
	String bd_approval = CommonUtil.getConfig("wise.bd_approval.use");

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String REQ_TYPE = request.getParameter("REQ_TYPE");
    
    if(REQ_TYPE == null){
    	REQ_TYPE = "P";
    }
    
	boolean isAdmin = this.isAdmin(info);	
	
    String LB_BID_STATUS = ListBox(request, "SL0102", HOUSE_CODE + "#"+"M137", "");
    String LB_PR_TYPE       = ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", "");
    String LB_BID_RFQ_TYPE      = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", "");
    
    String G_IMG_ICON = "/images/ico_zoom.gif";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME %>/servlets/dt.ebd.ebd_bd_lis6";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_REQ_TYPE = "<%=REQ_TYPE%>";
var G_CUR_ROW;
var INDEX_SELECTED;
var INDEX_PR_NO;
var INDEX_SIGN_STATUS;
var INDEX_CTRL_CODE;
var INDEX_PR_TYPE;
var INDEX_VOTE_COUNT;

function setHeader(){
	GridObj.strHDClickAction="sortmulti";
	
    INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
    INDEX_PR_NO             = GridObj.GetColHDIndex("PR_NO");
    INDEX_RFQ_NO            = GridObj.GetColHDIndex("RFQ_NO");
    INDEX_RFQ_COUNT         = GridObj.GetColHDIndex("RFQ_COUNT");
    INDEX_VOTE_COUNT         = GridObj.GetColHDIndex("VOTE_COUNT");
    INDEX_QTA_NO            = GridObj.GetColHDIndex("QTA_NO");
    INDEX_VENDOR_CODE       = GridObj.GetColHDIndex("VENDOR_CODE");
    INDEX_BID_TYPE          = GridObj.GetColHDIndex("BID_TYPE");
    INDEX_SETTLE_REMARK     = GridObj.GetColHDIndex("SETTLE_REMARK");
    INDEX_PR_TYPE = GridObj.GetColHDIndex("PR_TYPE");
}

function init(){
	setGridDraw();
	setHeader();
   // doSelect();
}

function doSelect(){
    var f = document.forms[0];
    
    var from_date = LRTrim(f.start_add_date.value);
    var to_date   = LRTrim(f.end_add_date.value);
    
    if(from_date == "" || to_date == "" ){
        alert("요청일자를 입력하셔야 합니다.");
        
        return;
    }
    
    var params = "mode=getReqBidRlt";
    
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    
    GridObj.post( G_SERVLETURL, params );
    
    GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
    if(msg1 == "doQuery"){
    	GridObj.bHDMoving             = false;
    	GridObj.bHDSwapping           = false;
    	GridObj.bRowSelectorVisible   = false;
    	GridObj.strRowBorderStyle     = "none";
    	GridObj.nRowSpacing           = 0 ;
	    GridObj.strHDClickAction      = "select";
    }
    
    if(msg1 == "doData"){
        var mode = GD_GetParam(GridObj,0);
        var status = GD_GetParam(GridObj,1);
    }
    
    if (msg1 == "t_imagetext"){ //PopupGeneral(url, title, left, top, width, height)
        var pr_no      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),msg2);
    
        G_CUR_ROW   = msg2;
        
        if(msg3 == INDEX_PR_NO){
        	if(G_REQ_TYPE=="B"){
        		var url1 = "ebd_pp_dis6.jsp?pr_no="+pr_no;
        		
                window.open(url1 ,"url1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
        	}
        	else if(G_REQ_TYPE=="P"){
        		var url1 = "pr1_bd_dis2.jsp?pr_no="+pr_no;
        		
                window.open(url1 ,"url1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
        	}
            
        }
        if(msg3 == INDEX_QTA_NO) { //견적서번호
            st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_QTA_NO),msg2);
            st_bid_type = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_BID_TYPE),msg2);

            if(LRTrim(st_qta_no) == ""){
            	return;
            }
                
            st_vendor_code  = GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_CODE);
            st_rfq_no       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),msg2);
            st_rfq_count    = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_COUNT);
            st_close_data   = "";
       
            if(st_bid_type == "RQ"){
                send_url = "/kr/dt/rfq/qta_pp_dis1.jsp?st_vendor_code=" + st_vendor_code + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
                send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count + "&st_close_data=" + st_close_data;

                if (st_qta_no=="견적포기"){
                    alert("견적포기입니다.");
                    return;
                }
            }
            else{
                send_url = "/kr/dt/ebd/ebd_pp_dis2.jsp?vendor_code=" + st_vendor_code + "&qta_no=" + st_qta_no + "&view=dis";
                send_url += "&rfq_no=" + st_rfq_no + "&rfq_count=" + st_rfq_count;

                if (st_qta_no=="입찰포기"){
                    alert("입찰포기입니다.");
                    return;
                }
            }
            
            window.open(send_url ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
        }
        else if(msg3 == INDEX_SETTLE_REMARK){ // 선정사유
        	if(GridObj.GetCellValue("SETTLE_REMARK", msg2) == ""){
        		return;
        	}

            var mode = "";
            var url = "/kr/confirm_pp_dis.jsp?title=선정사유&columnType=t_imagetext&column=SETTLE_REMARK&row="+ msg2;
			var left = 150;
			var top = 150;
			var width = 600;
			var height = 300;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'yes';
			var scrollbars = 'yes';
			var resizable = 'no';
			var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			ReasonWin.focus();
        }
        else {}
    }
}

function checkUser(){
    var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
    var flag = true;
    var rowcount = GridObj.GetRowCount();

    for (var row = 0; row < rowcount; row++){
        if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
            for(i=0; i < ctrl_code.length; i++ ){
                if (ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)){
                    flag = true;
                    
                    break;
                }
                else{
                    flag = false;
                }
            }
        }
    }
    
    return flag;
}

/* 팝업관련코드 */
function PopupManager(part){
    var wise = GridObj;
    var url = "";
    
    if(part == "CTRL_CODE"){
        PopupCommon2("SP0216","get_CtrlCode",G_HOUSE_CODE, G_COMPANY_CODE, "", "");
    }
    else if(part == "DEMAND_DEPT"){
        window.open("/common/CO_009.jsp?callback=getDeptUser", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
    else if(part == "BID_COUNT"){
        var rfq_no    = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_PR_NO);
        var rfq_count = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_RFQ_COUNT);
        
        url = '/kr/dt/ebd/ebd_pp_dis2.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count+'&call_pgm=ebd_bd_lis1';
        
        PopupGeneral(url, "", "", "", "540", "380");
    }
    else if(part == "ADD_USER_ID"){
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

function doPr() {

	var row = checkedOneRow(0);
	var pr_no = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO), row);
	var f = document.form1;
	f.target = "_self";
	f.method = "post";
	f.action = "/kr/dt/pr/pr1_bd_ins1.jsp?pr_no="+ pr_no;
	f.submit();
}

//***** Enter Key를 눌렀을때 Event발생 *****//
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
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
	var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(selectedId);
	
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var prNo   = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_NO);
		var prType = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_TYPE);
		var page   = null;
		
		if(prType == "I"){
			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		}
		else{
			page = "/kr/dt/pr/pr1_bd_dis1NotI.jsp";
		}
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}
	
	else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
		var st_qta_no      = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_QTA_NO);
		var st_bid_type    = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_BID_TYPE);
		var st_vendor_code = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_VENDOR_CODE);
	    var st_rfq_no      = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_RFQ_NO);
	    var st_rfq_count   = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_RFQ_COUNT);
	    var st_vote_count   = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_VOTE_COUNT);
	    var st_close_data  = "";
	    
	    
	    if(LRTrim(st_qta_no) == ""){
	    	return;
	    }
	    
	    if(st_bid_type == "RQ"){
	        send_url = "/kr/dt/rfq/qta_pp_dis1.jsp?st_vendor_code=" + st_vendor_code + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
	        send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count + "&st_close_data=" + st_close_data;

	        if (st_qta_no=="견적포기"){
	            alert("견적포기입니다.");
	            
	            return;
	        }
	    
    }else if(st_bid_type == "BD"){
    
    	send_url =  "/sourcing/bd_open_compare_pop.jsp?BID_NO="+st_qta_no+"&BID_COUNT="+st_rfq_count+"&VOTE_COUNT="+st_vote_count;

    }
	
	
	    else{
	        send_url = "/kr/dt/ebd/ebd_pp_dis2.jsp?vendor_code=" + st_vendor_code + "&qta_no=" + st_qta_no + "&view=dis";
	        send_url += "&rfq_no=" + st_rfq_no + "&rfq_count=" + st_rfq_count;

	        if (st_qta_no=="입찰포기"){
	            alert("입찰포기입니다.");
	            
	            return;
	        }
	    }
	    
	    window.open(send_url ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
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
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp"%>	  	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>	 
	<form name="form1" action="">
		<input type="hidden" name="h_rfq_no" id="h_rfq_no">
		<input type="hidden" name="h_rfq_count" id="h_rfq_count">
		<input type="hidden" name="req_type" id="req_type" value="<%=REQ_TYPE%>">
		
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
											<s:calendar id="start_add_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), -1))%>" format="%Y/%m/%d"/>
											~
											<s:calendar id="end_add_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청담당자</td>
										<td width="35%" class="data_td">
<%
	if(isAdmin){
%>
											<input type="text" name="add_user_id" id="add_user_id" size="15" maxlength="10" onkeydown='entKeyDown()' class="inputsubmit" value='' >
											<a href="javascript:PopupManager('ADD_USER_ID');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('add_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="add_user_name" id="add_user_name" size="20" onkeydown='entKeyDown()' class="input_data2" readonly value=''>                    
<%
	}
	else{
%>
											<input type="text" name="add_user_id" id="add_user_id" size="15" class="input_data2"  value='<%=info.getSession("ID")%>' readOnly>                   
											<input type="text" name="add_user_name" id="add_user_name" size="20" readonly class="input_data2" value='<%=info.getSession("NAME_LOC")%>'>
<%
	}
%>  
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td class="data_td" colspan="3">
<%
	if(isAdmin){ 
%>
											<input type="text" name="demand_dept" id="demand_dept" size="15" onkeydown='entKeyDown()'  class="inputsubmit" value='' >
											<a href="javascript:PopupManager('DEMAND_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('demand_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" class="input_data2" onkeydown='entKeyDown()' maxlength="15" value='' style="border:0">
<%
	}
	else{
%>
											<input type="text" name="demand_dept" id="demand_dept" size="15" class="input_data2"  value='<%=info.getSession("DEPARTMENT")%>' readOnly>
											<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" readonly class="input_data2" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>'> 
<%
	}
%>  
										</td>
										<td width="15%" class="title_td" style="display: none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청구분</td>
										<td width="35%" class="data_td"  style="display: none;">
											<select name="bid_rfq_type" id="bid_rfq_type" class="inputsubmit" >
												<option value=''>전체</option>
												<%=LB_BID_RFQ_TYPE%>
											</select>
										</td>
									</tr>
									<tr style="display:none;">                    
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;관리코드</td>
										<td class="data_td" >
											<input type="text" name="order_no" id="order_no" style="width:95%" class="inputsubmit"   >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청구분</td>
										<td width="35%" class="data_td">
											<select name="pr_type" id="pr_type" class="inputsubmit" >
												<option value=''>전체</option>
												<%=LB_PR_TYPE%>
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
btn("javascript:doSelect()","조 회");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</body>
</html>