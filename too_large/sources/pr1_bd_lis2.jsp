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
	multilang_id.addElement("PR_031");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_031";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";
	String WISEHUB_PROCESS_ID="PR_031";
    String HOUSE_CODE = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String LB_CODE_LB_PR_PROCEEDING_FLAG = "";
    String LB_CODE_CTRL_CODE             = CommonUtil.getConfig("wise.default.ctrl_code");
	String LB_CODE_SIGN_STATUS = "";
	String LB_SIGN_STATUS = ListBox(request, "SL0007",  HOUSE_CODE+"#M100#", LB_CODE_SIGN_STATUS);

	String LB_PR_PROCEEDING_FLAG = ListBox(request, "SL0007",  HOUSE_CODE+"#M157#", LB_CODE_LB_PR_PROCEEDING_FLAG);
	String LB_CTRL_CODE          = ListBox(request, "SL0106", HOUSE_CODE+"#"+COMPANY_CODE, LB_CODE_CTRL_CODE);
	String LB_PR_TYPE 		= ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", "");
	String LB_SALES_TYPE 	= ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", "");
	
	String ctrl_code = info.getSession("CTRL_CODE");
	
	String purchaser_id = "";
	String purchaser_nm = "";
	
	purchaser_id = info.getSession("ID");
	purchaser_nm = info.getSession("NAME_LOC");
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
<script language="javascript">
/*  대.중.소 분류 select 관련 함수  */
function MATERIAL_TYPE_Changed(){
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    
    setMATERIAL_CLASS1("전체", "");
    
    var id = "SL0009";
    var code = "M041";
    var value = form1.MATERIAL_TYPE.value;
    target = "MATERIAL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CTRL_TYPE_Changed(){
    clearMATERIAL_CLASS1();
    
    var id = "SL0019";
    var code = "M042";
    var value = form1.MATERIAL_CTRL_TYPE.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CLASS1_Changed(){
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";
    var value = form1.MATERIAL_CLASS1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function clearMATERIAL_CTRL_TYPE() {
    if(form1.MATERIAL_CTRL_TYPE.length > 0) {
        for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
            form1.MATERIAL_CTRL_TYPE.options[i] = null;
        }
    }
}

function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function clearMATERIAL_CLASS1() {
    if(form1.MATERIAL_CLASS1.length > 0) {
        for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS1.options[i] = null;
        }
    }
}

function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function clearMATERIAL_CLASS2() {
    if(form1.MATERIAL_CLASS2.length > 0) {
        for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS2.options[i] = null;
        }
    }
}

function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
}

var mode;
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr1_bd_lis2";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";

var INDEX_SELECTED        ;
var INDEX_ITEM_NO   	 ;
var INDEX_DESCRIPTION_LOC;
var INDEX_RD_DATE        ;
var INDEX_UNIT_MEASURE 	 ;
var INDEX_PR_QTY     	 ;
var INDEX_CUR        	 ;
var INDEX_UNIT_PRICE     ;
var INDEX_PR_AMT      	 ;
var INDEX_PR_KRW_AMT     ;
var INDEX_PR_NO   		 ;
var INDEX_PR_NO_1   	 ;
var INDEX_SUBJECT   	 ;
var INDEX_ADD_DATE       ;
var INDEX_DEMAND_DEPT_NAME;
var INDEX_DEMAND_DEPT	;
var INDEX_ADD_USER_ID  	;
var INDEX_ADD_USER_NAME  ;
var INDEX_PR_TYPE        ;
var INDEX_SALES_TYPE     ;
var INDEX_CTRL_DATE      ;
var INDEX_PURCHASER_NAME ;
var INDEX_SIGN_STATUS;

function init(){
	setGridDraw();
	setHeader();
}

function setHeader(){
	GridObj.SetDateFormat("RD_DATE","yyyy/MM/dd");
	GridObj.SetDateFormat("ADD_DATE","yyyy/MM/dd");
	GridObj.SetDateFormat("RD_DATE","yyyy/MM/dd");
	GridObj.SetDateFormat("PO_RD_DATE","yyyy/MM/dd");
	
	GridObj.strHDClickAction="sortmulti";
	
	INDEX_PR_NO   	= GridObj.GetColHDIndex("PR_NO");
	INDEX_ITEM_NO   = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_PO_NO		= GridObj.GetColHDIndex("PO_NO");

}

function doQeury(){
	doSelect();
}

function doSelect(){
	if(LRTrim(form1.add_date_start.value) == "" || LRTrim(form1.add_date_end.value) == "" ) {
		alert("생성일자를 입력하셔야 합니다.");
		
		return;
	}

	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=prProceedingList";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	if(msg1 == "doQuery" ){}
	else if(msg1 == "t_imagetext"){
		var left = 30;
		var top = 30;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var width = "";
		var height = "";

		if(msg3 == INDEX_PR_NO){
			pr_no = msg4;
			
			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+pr_no ,"pr_pp","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
		}
		
		if(msg3 == INDEX_ITEM_NO) {
			var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
			
			width = 750;
			height = 550;
			
			var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
			var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			
			PoDisWin.focus();
		}
		
		if(msg3 == INDEX_PO_NO) {
			po_no	= GD_GetCellValueIndex(GridObj,msg2,INDEX_PO_NO);
			
			//window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");

			var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
			var title            = '발주화면상세조회';
			var param = "";
			param = param + "po_no=" + po_no;

			if (po_no != "") {
			    popUpOpen01(url, title, '1024', '600', param);
			}
		}
	}
}

function POPUP_Open(url, title, left, top, width, height) {
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    code_search.focus();
}


function add_date_start(year,month,day,week){
    document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week){
    document.form1.add_date_end.value=year+month+day;
}

function PopupManager(part){
	var url = "";
	var f = document.forms[0];

	if(part == "SALES_DEPT"){
		window.open("/common/CO_009.jsp?callback=getSales_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "REQ_DEPT"){
	    window.open("/common/CO_009.jsp?callback=getReq_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "PR_USER"){
		PopupCommon2("SP0023","getPr_user","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","담당자ID","담당자명");
	}
	else if(part == "REQ_USER"){
		window.open("/common/CO_008.jsp?callback=getReq_user", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	else if(part == "CUST_CODE"){
		PopupCommon2("SP0120F","getCust","","","고객사코드","고객사명");
	}
	
	//구매담당자
	if(part == "CTRL_CODE"){
		PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
	}
	
	if(part == "PURCHASER_ID"){
		window.open("/common/CO_008.jsp?callback=getPurUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getPurUser(code, text){
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}

//구매담당자
function getCtrlManager(code, text){
	document.form1.ctrl_code.value = code;
	document.form1.ctrl_name.value = text;
}

function getSales_dept(code,text){
    document.forms[0].sales_dept.value      = code;
	document.forms[0].sales_dept_name.value = text;
}

function getReq_dept(code,text){
    document.forms[0].req_dept.value      = code;
	document.forms[0].req_dept_name.value = text;
}

function getPr_user(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION){
    document.forms[0].pr_user.value      = USER_ID;
	document.forms[0].pr_user_name.value = USER_NAME_LOC;
}

function getReq_user(code,text){
    document.forms[0].req_user.value      = code;
	document.forms[0].req_user_name.value = text;
}

function getCust(code, text, div) {
  	 document.forms[0].cust_type.value = div;
	 document.forms[0].cust_code.value = code;
	 document.forms[0].cust_name.value = text;
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
	var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(selectedId);
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var prNo = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_PR_NO);
		var page = "pr1_bd_dis1I.jsp";
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
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
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].purchaser_name.value = "";
    }  
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value = "";
        document.forms[0].req_dept_name.value = "";
    }
    if( type == "req_user" ) {
    	document.forms[0].req_user.value = "";
        document.forms[0].req_user_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">
		<input type="hidden" name="sign_status">
		<input type="hidden" name="pr_type" >
		<input type="hidden" name="pr_no" >
		<input type="hidden" name="pr_seq">
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
										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
										<td class="data_td">
				    						<select name="pr_proceeding_flag" id="pr_proceeding_flag" class="inputsubmit" >
												<option value="" selected>
													<b>전체</b>
												</option>
												<%=LB_PR_PROCEEDING_FLAG%>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목대분류</td>
										<td class="data_td">
											<select name="MATERIAL_TYPE" id="MATERIAL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
                           						<option value="">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");

	out.println(listbox1);
%>
                       						</select>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목중분류</td>
										<td class="data_td" width="35%">
				    						<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
                           						<option value=''>전체</option>
                       						</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목소분류</td>
										<td class="data_td">
											<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
                           						<option value=''>전체</option>
                       						</select>
										</td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
			    						<td class="data_td">
			        						<input type="text" name="purchaser_id" id="purchaser_id" size="20" style="ime-mode:inactive"  value="<%=purchaser_id%>" class="inputsubmit"  onkeydown='entKeyDown()' >
			        						<a href="javascript:PopupManager('PURCHASER_ID')">
			        							<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
			        						</a>
			        						<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
			        						<input type="text" name="purchaser_name" id="purchaser_name" size="20" class="input_data2" value="<%=purchaser_nm%>"  onkeydown='entKeyDown()'  readOnly>
		        						</td>
									<tr style="display: none">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고객사</td>
										<td class="data_td">
											<input type="text" name="cust_code" id="cust_code" size="10"  class="inputsubmit" value=''  onkeydown='entKeyDown()'>
           									<a href="javascript:PopupManager('CUST_CODE');">
             									<img src="<%=G_IMG_ICON%>" border="0" >
           									</a>
           									<input type="text"   name="cust_name" id="cust_name" size="30" class="input_data2" value='' style="border:0"  onkeydown='entKeyDown()' readonly>
           									<input type="hidden" name="cust_type" id="cust_type" size="30" class="input_data2" value='' style="border:0" readonly>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="sales_dept" id="sales_dept" size="16" class="inputsubmit" value=''  onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('SALES_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<input type="text" name="sales_dept_name" id="sales_dept_name" size="25" class="input_data2"  onkeydown='entKeyDown()'  readonly value='' readOnly>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr style="display:none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
										<td class="data_td">
											<select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS2_Changed();">
                           						<option value=''>전체</option>
                       						</select>
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td">
											<input type="text" name="req_dept" id="req_dept" size="16" style="ime-mode:inactive"  class="inputsubmit" value=''  onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('REQ_DEPT');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="req_dept_name" id="req_dept_name" size="25" class="input_data2"  onkeydown='entKeyDown()' readonly value='' readOnly>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자</td>
										<td class="data_td">
				    						<input type="text" name="req_user" id="req_user" size="15" style="ime-mode:inactive"  class="inputsubmit"   onkeydown='entKeyDown()'>
											<a href="javascript:PopupManager('REQ_USER')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('req_user')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="req_user_name" id="req_user_name" size="20" class="input_data2"  onkeydown='entKeyDown()' readOnly>
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
				<td height="30" align="left">
					<TABLE cellpadding="0">
						<TR>
						</TR>
					</TABLE>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:doQeury()","조 회");
								</script>
							</TD>
							<TD style="display: none;">
								<script language="javascript">
									btn("javascript:settleHistory()","업체선정이력");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<iframe name="xWork" width="0" height="0" border="0"></iframe>
	<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_031" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>