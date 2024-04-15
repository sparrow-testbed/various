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
	multilang_id.addElement("MA_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_009";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="MA_009";
	String WISEHUB_LANG_TYPE="KR";
    String house_code           = info.getSession("HOUSE_CODE");
    String company_code       	= info.getSession("COMPANY_CODE");
    String user_id              = info.getSession("ID");
    String name_loc             = info.getSession("NAME_LOC");
    String department           = info.getSession("DEPARTMENT");
    String ctrl_code            = info.getSession("CTRL_CODE");

    String create_date_to      	= SepoaDate.getShortDateString();
    String create_date_from   	= SepoaDate.addSepoaDateMonth(create_date_to, -1);
    String       G_IMG_ICON              = "/images/ico_zoom.gif";
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
var INDEX_SELECTED					;
var INDEX_REQ_ITEM_NO				;
var INDEX_ITEM_NO					;
var INDEX_REQ_DATE					;
var INDEX_DESCRIPTION_LOC			;
var INDEX_SPECIFICATION				;
var INDEX_BASIC_UNIT				;
var INDEX_REQ_NAME_LOC				;
var INDEX_REQ_TYPE					;
var INDEX_DATA_TYPE					;
var INDEX_CONFIRM_DATE				;
var INDEX_CONFIRM_NAME_LOC			;
var INDEX_CONFIRM_STATUS			;
var INDEX_VENDOR_NAME				;
var INDEX_DATA_OCCUR_NAME			;
var INDEX_Z_PURCHASE_TYPE  			;
var INDEX_DELIVERY_LT       		;
var INDEX_QI_FLAG        			;
var INDEX_DO_FLAG        			;
var INDEX_Z_WORK_STAGE_FLAG         ;
var INDEX_Z_DELIVERY_CONFIRM_FLAG   ;

var INDEX_REQ_CODE					;
var INDEX_CONFIRM_CODE				;
var INDEX_CONTRACT_FROM_DATE		;
var INDEX_CONTRACT_TO_DATE			;
var INDEX_DATA_OCCUR_TYPE			;
var INDEX_IMAGE						;

var INDEX_ITEM_GROUP				;
var INDEX_Z_REMARK					;
var INDEX_Z_PURCHASE_TYPE_COLOR		;
var servletUrl;

function Init(){
	setGridDraw();
	setHeader();
	getQuery();
}

function setHeader(){
	GridObj.SetDateFormat("REQ_DATE", "yyyy/MM/dd");
	GridObj.SetDateFormat("CONFIRM_DATE", "yyyy/MM/dd");

	INDEX_SELECTED                        =   GridObj.GetColHDIndex("SELECTED"					);
	INDEX_REQ_ITEM_NO                     =   GridObj.GetColHDIndex("REQ_ITEM_NO"				);
	INDEX_ITEM_NO                         =   GridObj.GetColHDIndex("ITEM_NO"					);
	INDEX_REQ_DATE                        =   GridObj.GetColHDIndex("REQ_DATE"					);
	INDEX_DESCRIPTION_LOC                 =   GridObj.GetColHDIndex("DESCRIPTION_LOC"			);
	INDEX_SPECIFICATION                   =   GridObj.GetColHDIndex("SPECIFICATION"				);
	INDEX_BASIC_UNIT                      =   GridObj.GetColHDIndex("BASIC_UNIT"					);
	INDEX_Z_PURCHASE_TYPE  				  =	  GridObj.GetColHDIndex("Z_PURCHASE_TYPE"  	  		);
	INDEX_DELIVERY_LT       		      =	  GridObj.GetColHDIndex("DELIVERY_LT"       	  		);
	INDEX_QI_FLAG        			      =	  GridObj.GetColHDIndex("QI_FLAG"        		  	);
	INDEX_DO_FLAG        			      =	  GridObj.GetColHDIndex("DO_FLAG"        		  	);
	INDEX_Z_WORK_STAGE_FLAG               =	  GridObj.GetColHDIndex("Z_WORK_STAGE_FLAG"	  		);
	INDEX_Z_DELIVERY_CONFIRM_FLAG         =	  GridObj.GetColHDIndex("Z_DELIVERY_CONFIRM_FLAG"	);

	INDEX_REQ_NAME_LOC                    =   GridObj.GetColHDIndex("REQ_NAME_LOC"				);
	INDEX_REQ_TYPE                        =   GridObj.GetColHDIndex("REQ_TYPE"					);
	INDEX_DATA_TYPE                       =   GridObj.GetColHDIndex("DATA_TYPE"					);
	INDEX_CONFIRM_DATE                    =   GridObj.GetColHDIndex("CONFIRM_DATE"				);
	INDEX_CONFIRM_NAME_LOC                =   GridObj.GetColHDIndex("CONFIRM_NAME_LOC"			);
	INDEX_CONFIRM_STATUS                  =   GridObj.GetColHDIndex("CONFIRM_STATUS"				);
	INDEX_VENDOR_NAME                     =   GridObj.GetColHDIndex("VENDOR_NAME"				);
	INDEX_DATA_OCCUR_NAME                 =   GridObj.GetColHDIndex("DATA_OCCUR_NAME"			);

	INDEX_REQ_CODE                        =   GridObj.GetColHDIndex("REQ_CODE"					);
	INDEX_CONFIRM_CODE                    =   GridObj.GetColHDIndex("CONFIRM_CODE"				);
	INDEX_DATA_OCCUR_TYPE                 =   GridObj.GetColHDIndex("DATA_OCCUR_TYPE"	  		);
	INDEX_IMAGE                           =   GridObj.GetColHDIndex("IMAGE"				  		);

	INDEX_ITEM_GROUP                      =   GridObj.GetColHDIndex("ITEM_GROUP"			  		);
	INDEX_Z_REMARK                        =   GridObj.GetColHDIndex("REMARK"				  		);
	INDEX_REJECT_REMARK                   =   GridObj.GetColHDIndex("REJECT_REMARK"				);
	INDEX_Z_PURCHASE_TYPE_COLOR			  =	  GridObj.GetColHDIndex("Z_PURCHASE_TYPE_COLOR"		);
}

function getQuery(){
	var create_date_from    = LRTrim(del_Slash(form1.create_date_from.value));
	var create_date_to      = LRTrim(del_Slash(form1.create_date_to.value));
	var req_name_loc		= LRTrim(form1.req_name_loc.value);
	var description			= LRTrim(form1.description.value);
	var sel_proceeding_flag = form1.sel_proceeding_type.options[form1.sel_proceeding_type.selectedIndex].value;
	var sel_data_flag = "";
	var sel_data_occur_type = "";

	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.new_material.confirm_bd_lis1";
	
	var params = "mode=getQuery";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	GridObj.post( servletUrl, params );
	GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	max_row = GridObj.GetRowCount();
	
	var maxcol  = GridObj.GetColCount();
	
	if(msg1 == "t_insert") {
		if(msg3 == INDEX_SELECTED){
			selectCond(GridObj, msg2);
		}
	}

	if(msg1 == "t_imagetext"){
		var left = 50;
		var top = 100;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var width = "";
		var height = "";

		if(msg3 == GridObj.GetColHDIndex("DESCRIPTION_LOC")){
			var data_occur_type = GD_GetCellValueIndex(GridObj,msg2,INDEX_DATA_OCCUR_TYPE);
			var temp_item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_REQ_ITEM_NO);
			var item_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);

			width = 750;
			height = 580;

			if(data_occur_type == "L"){
				var url = 'req_pp_ins1_3.jsp?REQ_ITEM_NO='+temp_item_no+"&item_no="+item_no+"&BUY=";
			}
			else{
				var url = 'confirm_pp_vew3.jsp?REQ_ITEM_NO='+temp_item_no;
			}
			
			var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			
			PoDisWin.focus();

		}
		
		if(msg3 == INDEX_REJECT_REMARK){
			var Z_REMARK = GD_GetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK);
			var mode = "update";
			var url = "/kr/master/new_material/confirm_pp_dis1.jsp?Z_REMARK="+Z_REMARK+"&msg2="+msg2+"&mode="+mode;
			var left = 150;
			var top = 150;
			var width = 600;
			var height = 300;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'yes';
			var scrollbars = 'yes';
			var resizable = 'no';
			var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			
			SpecCodeWin.focus();
		}
	}
	
	if(msg1 == "doData"){
		var sflag = GD_GetParam(GridObj,0);
		
		if ( sflag == "OK" ){
			alert(" 정상적으로 수행하였습니다.");
			
			getQuery();
		}
		else if (sflag == "DOUBLE"){
			alert("이전 요청건수가 있습니다.");
		}
		else if (sflag == "CHKERR"){
			alert("처리완료된 항목입니다.");
			
			getQuery();
		}
		else{
			alert(" 에러가 발생되었습니다.");
		}
	}
	
	if(msg3 == "0"){
		oneSelect(max_row, msg1, msg2);
	}
}

function selectCond(wise, selectedRow){
	var wise = GridObj;
	var cur_vbeln_code  = GD_GetCellValueIndex(wise,selectedRow, INDEX_REQ_ITEM_NO);
	var iRowCount   	 = wise.GetRowCount();

	for(var i=0;i<iRowCount;i++){
		if(i==selectedRow){
			continue;
		}
		
		if(cur_vbeln_code == GD_GetCellValueIndex(wise,i,INDEX_REQ_ITEM_NO)){
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

function getZ_REMARK(value, msg2) {
	var wise = GridObj;
	
	if(value.length < 1 || value == null){
		GD_SetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK  , "");
	}
	else {
		GD_SetCellValueIndex(GridObj,msg2, INDEX_REJECT_REMARK, value);
	}
			
	Change('rej');
}

function create_date_to(year,month,day,week) {
	form1.create_date_to.value=year+month+day;
}

function create_date_from(year,month,day,week) {
	form1.create_date_from.value=year+month+day;
}

function oneSelect(max_row, msg1, msg2) {
	var noSelect = "";

	if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj,msg2,"0") == "false"){
		noSelect = "Y";
	}

	for(var i=0;i<max_row;i++)  {
		GD_SetCellValueIndex(GridObj,i,"0","false", "&");
	}

	if(msg1 != "t_header" && noSelect != "Y"){
		GD_SetCellValueIndex(GridObj,msg2,"0","true", "&");
	}
}

function changeCon(rowIndex){
	var req_code    = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REQ_CODE);
	var data_type   = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_DATA_TYPE);
	var ITEM_NO 	= "";
	var left 		= 30;
	var top 		= 30;
	var toolbar 	= 'no';
	var menubar 	= 'no';
	var status 		= 'yes';
	var scrollbars 	= 'yes';
	var resizable 	= 'no';
	var width 		= "";
	var height 		= "";
	var wise 		= GridObj;
	var max_row 	= GridObj.GetRowCount();
	var BUY 		= "";
	width 			= 750;
	height 			= 650;
	var url 		= "";

	var REQ_ITEM_NO 	= GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REQ_ITEM_NO);
	var ITEM_NO 		= GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
	
	url = "real_pp_upd1.jsp?REQ_ITEM_NO="+REQ_ITEM_NO+"&ITEM_NO="+ITEM_NO;
	
	var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function changeRej(rowIndex){
	if(GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REJECT_REMARK) == ""){
		var Z_REMARK = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REJECT_REMARK);
		var msg2 = rowIndex;
		var mode = "update";
		var url = "/kr/master/new_material/confirm_pp_dis1.jsp?Z_REMARK="+Z_REMARK+"&msg2="+msg2+"&mode="+mode;
		var left = 150;
		var top = 150;
		var width = 600;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		
		SpecCodeWin.focus();
		
		return;
	}

	if(confirm("반려 하시겠습니까?")){
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.new_material.confirm_bd_upd2";

		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var params;
		
		params = "?mode=doData";
		params += "&cols_ids=<%=grid_col_id%>";
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(servletUrl+params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}

function Change(flag){
	var	wise = GridObj;
	var	sel_row	= -1;
	var selectedCnt = 0;

	for(var	i=0; i<GridObj.GetRowCount();i++){
		var	temp = GD_GetCellValueIndex(GridObj,i,0);
		
		if(temp	== true){
			sel_row = i;
			
			var confirm_code = GD_GetCellValueIndex(GridObj,sel_row,INDEX_CONFIRM_CODE);
			
			if(confirm_code == "E"){
				alert("이미 승인됐습니다.");
				
				return;
			}
			
			selectedCnt ++;
		}
	}
	
	if(selectedCnt == 0){
		alert("항목을 선택해주세요.");
		
		return;
	}
	else if(selectedCnt > 1){
		alert("한개의 행만 선택해주세요.");
		
		return;
	}
	
	if(flag == "con"){
		changeCon(sel_row);
	}
	else if(flag == "rej") {
		changeRej(sel_row);
	}
}

function PopupManager(part){
	if(part == "ADD_USER_ID"){
    	window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
    }
}

function getAddUser(code, text){
	var reqUserId  = document.getElementById("req_user_id");
	var reqNameLoc = document.getElementById("req_name_loc");
	
	reqUserId.value = code;
	reqNameLoc.value = text;
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
	var selectedId   = GridObj.getSelectedId();
	var rowIndex     = GridObj.getRowIndex(selectedId);
	
	if(cellInd == GridObj.getColIndexById("DESCRIPTION_LOC")) {
		var temp_item_no = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REQ_ITEM_NO);
		var url          = 'req_pp_ins1_3.jsp?REQ_ITEM_NO='+temp_item_no+"&BUY=";
		
		window.open(url ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=750,height=580,left=0,top=0");
	}
	else if(cellInd == GridObj.getColIndexById("REJECT_REMARK")) {
		var rejectRemark = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REJECT_REMARK);
		var confirmCode  = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_CONFIRM_CODE);
		var mode         = "";
		
		if(confirmCode == "P"){
			var mode = "update";
		}
		else if(confirmCode == "R"){
			var mode = "read";
		}
		else{
			return;
		}
		
		if(rejectRemark != ""){
			var url = "/kr/master/new_material/confirm_pp_dis1.jsp?msg2="+rowIndex+"&mode=" + mode;
			var left = 150;
			var top = 150;
			var width = 600;
			var height = 300;
			var toolbar = 'no';
			var menubar = 'no';
			var status = 'yes';
			var scrollbars = 'yes';
			var resizable = 'no';
			var SpecCodeWin = window.open( url, 'Category', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			
			SpecCodeWin.focus();
		}
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
    
    alert(messsage);
    
    if(status == "true") {
    	getQuery();
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

function getRejectRemark(rowIndex){
	return GD_GetCellValueIndex(GridObj, rowIndex, INDEX_REJECT_REMARK);
}

//지우기
function doRemove( type ){
    if( type == "req_user_id" ) {
    	document.forms[0].req_user_id.value = "";
        document.forms[0].req_name_loc.value = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        getQuery();
    }
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td class="data_td" width="35%">
											<s:calendar id="create_date_from" default_value="<%=SepoaString.getDateSlashFormat(create_date_from)%>" format="%Y/%m/%d"/>
											~
											<s:calendar id="create_date_to" default_value="<%=SepoaString.getDateSlashFormat(create_date_to)%>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자</td>
										<td class="data_td" width="35%">
											<input type="text"  onkeydown='entKeyDown()' name="req_user_id" id="req_user_id" size="13" class="input_data2"  value='' readOnly>
											<a href="javascript:PopupManager('ADD_USER_ID')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('req_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text"  onkeydown='entKeyDown()' name="req_name_loc" id="req_name_loc" size="20" class="input_data2"  value=''>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td class="data_td" width="35%">
											<input type="text"  onkeydown='entKeyDown()' name="description" id="description" value="" style="width:95%" class="inputsubmit">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;처리상태</td>
										<td class="data_td" width="35%">
											<select name="sel_proceeding_type" id="sel_proceeding_type" class="inputsubmit">
												<option value="" selected>전체</option>
<%
		String listbox2 = ListBox(request, "SL0018", house_code + "#M185", "P");
		out.println(listbox2);
%>
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
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
	btn("javascript:getQuery()", "조 회");
</script>
							</TD>
							<TD>
<script language="javascript">
	btn("javascript:Change('con')", "승 인");
</script>
							</TD>
							<TD>
<script language="javascript">
	btn("javascript:Change('rej')", "반 려");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="MA_009" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>