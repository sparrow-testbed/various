<%--
    Title                            :          rfq_bd_lis1.jsp  <p>
    Description                      :          견적요청현황 <p>
    Copyright                        :          Copyright (c) <p>
    Company                          :          SEPOASOFT <p>
    @author                          :          WKHONG(2014.09.30)<p>
    @version                         :          1.0
    @Comment                         :          견적요청현황을 조회하는 화면이다.
    @SCREEN_ID                       :          RQ_231
--%>
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
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_231");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_231";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	String WISEHUB_PROCESS_ID="RQ_231";
    String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String CTRL_CODE 	= info.getSession("CTRL_CODE");
    String dNameLoc 	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"));
    String depart 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
    String FLAG			= JSPUtil.nullToRef(request.getParameter("FLAG"),"");
%>
<html>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
//<!--
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var mode;
var IDX_SEL;
var IDX_RFQ_NO;
var IDX_RFQ_COUNT;
var IDX_RFQ_FLAG;
var IDX_RFQ_FLAG_TEXT;
var IDX_ITEM_CNT;
var IDX_CHANGE_DATE;
var IDX_SUBJECT;
var IDX_RFQ_CLOSE_TIME;
var IDX_VIEW_CNT;
var IDX_BID_COUNT;
var IDX_VENDOR_CNT;
var IDX_ANNOUNCE_DATE;
var IDX_DEPT_NAME;
var IDX_CHANGE_USER_NAME_LOC;
var IDX_CTRL_CODE_NAME;
var IDX_CHANGE_USER_ID;
var IDX_CHANGE_DEPT_CODE;
var IDX_CREATE_TYPE;
var IDX_RFQ_TYPE;
var IDX_CTRL_CODE;
var IDX_RFQ_EXTENDS_DATE;
var IDX_RFQ_EXTENDS_TIME;
var IDX_RFQ_TYPE_CODE;
var IDX_CAN_CANCEL_BIDDING;
	
function Init() {	//화면 초기설정 
	setGridDraw();
	setHeader();
<%
	if(FLAG != null && !FLAG.equals("")){
		if(FLAG.equals("P")){
%>
	document.forms.form1.rfq_flag.value = 'G'
<%
		}
	}
%>
	doSelect();
}

function setHeader() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	
	GridObj.strHDClickAction="sortmulti";
	
	IDX_SEL                  = GridObj.GetColHDIndex("SEL");
	IDX_RFQ_NO               = GridObj.GetColHDIndex("RFQ_NO");
	IDX_RFQ_COUNT            = GridObj.GetColHDIndex("RFQ_COUNT");
	IDX_RFQ_FLAG_TEXT        = GridObj.GetColHDIndex("RFQ_FLAG_TEXT");
	IDX_RFQ_TYPE             = GridObj.GetColHDIndex("RFQ_TYPE");
	IDX_ITEM_CNT             = GridObj.GetColHDIndex("ITEM_CNT");
	IDX_CHANGE_DATE          = GridObj.GetColHDIndex("CHANGE_DATE");
	IDX_SUBJECT              = GridObj.GetColHDIndex("SUBJECT");
	IDX_RFQ_CLOSE_TIME       = GridObj.GetColHDIndex("RFQ_CLOSE_TIME");
	IDX_VIEW_CNT             = GridObj.GetColHDIndex("VIEW_CNT");
	IDX_BID_COUNT            = GridObj.GetColHDIndex("BID_COUNT");
	IDX_VENDOR_CNT	         = GridObj.GetColHDIndex("VENDOR_CNT");
	IDX_ANNOUNCE_DATE        = GridObj.GetColHDIndex("ANNOUNCE_DATE");
	IDX_DEPT_NAME            = GridObj.GetColHDIndex("DEPT_NAME");
	IDX_CHANGE_USER_NAME_LOC = GridObj.GetColHDIndex("CHANGE_USER_NAME_LOC");
	IDX_CTRL_CODE_NAME		 = GridObj.GetColHDIndex("CTRL_CODE_NAME");
	IDX_CHANGE_USER_ID       = GridObj.GetColHDIndex("CHANGE_USER_ID");
	IDX_CHANGE_DEPT_CODE     = GridObj.GetColHDIndex("CHANGE_DEPT_CODE");
	IDX_CREATE_TYPE          = GridObj.GetColHDIndex("CREATE_TYPE");
	IDX_RFQ_FLAG             = GridObj.GetColHDIndex("RFQ_FLAG");
	IDX_CTRL_CODE 			 = GridObj.GetColHDIndex("CTRL_CODE");
	IDX_RFQ_EXTENDS_DATE	 = GridObj.GetColHDIndex("RFQ_EXTENDS_DATE");
	IDX_RFQ_EXTENDS_TIME	 = GridObj.GetColHDIndex("RFQ_EXTENDS_TIME");
	IDX_RFQ_TYPE_CODE        = GridObj.GetColHDIndex("RFQ_TYPE_CODE");
	IDX_CAN_CANCEL_BIDDING   = GridObj.GetColHDIndex("CAN_CANCEL_BIDDING");
}

function doSelect(){
	if(LRTrim(form1.start_change_date.value) == "" || LRTrim(form1.end_change_date.value) == "" ) {
		alert("요청일자를 입력하셔야 합니다.");
		
		return;
	}
	
	if(!checkDate(del_Slash(form1.start_change_date.value))) {
		alert("요청일자를 확인하세요.");
		
		form1.start_change_date.select();
		
		return;
	}
	
	if(!checkDate(del_Slash(form1.end_change_date.value))) {
		alert("요청일자를 확인하세요.");
		
		form1.end_change_date.select();
		
		return;
	}
	
	change_user = LRTrim(form1.ctrl_person_id.value);
	change_user = change_user.toUpperCase();
		
 	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getRfqList&grid_col_id="+grid_col_id;
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis1";

	GridObj.post(url, param);
	GridObj.clearAll(false);	 
}

function doModify(){
	if(!checkUser()){
		return;
	}
		
	checked_count = 0;
	rowcount      = GridObj.GetRowCount();
	rfq_no        = "";
	rfq_count     = "";
       	
	var rfq_state = "write";
	var rfq_flag = "";

	for(row=rowcount-1; row>=0; row--){
		if( true != GD_GetCellValueIndex(GridObj,row, IDX_SEL)){
			continue;
		}
			
		checked_count++;
			
		if( GD_GetCellValueIndex(GridObj,row, IDX_RFQ_FLAG) != "T" ) { // 진행상태에 따라 견적 수정불가(작성중)
			alert("진행상태가 [작성중] 인 경우에만 수정이 가능합니다.");
		
			return;
		}
			
		if("0" != GD_GetCellValueIndex(GridObj,row, IDX_BID_COUNT)) { // 견적서를 제출한 업체가 있는 경우 수정불가
			alert("견적서를 제출한 업체가 있는 경우 수정할 수 없습니다.");
		
			return;
		}
		
		rfq_no      = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),row);
		rfq_count   = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_COUNT);
		create_type = GD_GetCellValueIndex(GridObj,row, IDX_CREATE_TYPE);

		if(("G" == GD_GetCellValueIndex(GridObj,row, IDX_RFQ_FLAG))&&(0 == GD_GetCellValueIndex(GridObj,row, IDX_BID_COUNT))) {
			rfq_state = "send";
		}
	}
	
	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(checked_count > 1)  {
		alert(G_MSS2_SELECT);
		
		return;
	}
	
	settle_type = "";
		
	var url="rfq_bd_ins2.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count+ "&create_type=" + create_type + "&rfq_state=" + rfq_state;
	
	window.open(url,"rfq_bd_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
}

function doDelete(){
	if(!checkUser()){
		return;
	}
		
	checked_count = 0;
	rowcount      = GridObj.GetRowCount();

	for(row=rowcount-1; row>=0; row--){
		if( true == GD_GetCellValueIndex(GridObj,row, IDX_SEL)){
			checked_count++;
				
			RFQ_FLAG = LRTrim(GD_GetCellValueIndex(GridObj,row, IDX_RFQ_FLAG));
			BID_COUNT = parseInt(LRTrim(GD_GetCellValueIndex(GridObj,row, IDX_BID_COUNT)));
			RFQ_TYPE_CODE   = LRTrim(GD_GetCellValueIndex(GridObj,row, IDX_RFQ_TYPE_CODE));
			CAN_CANCEL_BIDDING = LRTrim(GD_GetCellValueIndex(GridObj,row, IDX_CAN_CANCEL_BIDDING));
			
			if( CAN_CANCEL_BIDDING == "N" ){
    			alert("품의가 진행되어서 삭제할 수 없습니다.");
    			return;
    		}
			
			//RFQ_FLAG == "G"
			if(!( (RFQ_FLAG == "P" &&  BID_COUNT == "0") || RFQ_FLAG == "T" || RFQ_FLAG == "R" || (RFQ_FLAG == "G" && BID_COUNT == "0")  || (RFQ_FLAG == "P" && RFQ_TYPE_CODE == "MA")  || (RFQ_FLAG == "G" && RFQ_TYPE_CODE == "MA") )) {				
				alert("진행상태가 맞지 않아 삭제할 수 없습니다.");
				
				return;
			}
		}
	}

	if(checked_count == 0)  {
		alert(G_MSS1_SELECT);
		
		return;
	}
		
	Message = "삭제 하시겠습니까?";

	if(confirm(Message) == 1) {
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis1";
		var grid_array = getGridChangedRows(GridObj, "SEL");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		    
		params = "?mode=setRfqDelete";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		    
		myDataProcessor = new dataProcessor(servletUrl + params);
		sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
	}
}
	
function checkUser() { // 직무권한 체크
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

	for(var row=0; row<GridObj.GetRowCount(); row++) {
		if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			for( i=0; i<ctrl_code.length; i++ ){
				if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, IDX_CTRL_CODE)) {
					flag = true;
					
					break;
				}
				else{
					flag = false;
				}
			}
		}
	}

	if(!flag){
		alert("작업을 수행할 권한이 없습니다.");
	}

	return flag;
}

function start_change_date(year,month,day,week) {
	document.form1.start_change_date.value=year+month+day;
}

function end_change_date(year,month,day,week) {
	document.form1.end_change_date.value=year+month+day;
}
	
function setRFQClose(){ // 견적마감
	rowcount = GridObj.GetRowCount() -1;
	
	if(rowcount < 0){
		return;
	}

	checked_count = 0;
	selected_row  = -1;

	for(row=rowcount; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			checked_count++;
			
			selected_row = row;
			
			if(!("G" == GD_GetCellValueIndex(GridObj,row, IDX_RFQ_FLAG))) {
				alert("견적중인 경우에만 마감할 수 있습니다.");
				
				return;
			}

			if(GD_GetCellValueIndex(GridObj,row, IDX_BID_COUNT) == 0){
				alert("입찰서를 제출한 업체가  없습니다. 견적마감은 입찰 업체가 있어야 합니다.");
				
				return;
			}
		}
	}

	if(checked_count == 0) {
		alert(G_MSS1_SELECT);
		
		return;
	}
	
	if(checked_count != 1){
		alert(G_MSS2_SELECT);
		
		return;
	}
	
	if(!confirm("견적 마감 하시겠습니까?")) {
		return;
	}

	var servletUrl  = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis1";
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	
	params = "?mode=setRFQClose";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(servletUrl+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
}
    
function setRFQExtends(){ // 견적기간 연장
	var current_date = "<%=current_date%>";
	var current_time = "<%=current_time%>";
    	
	rowcount = GridObj.GetRowCount() -1;
    	
	if(rowcount < 0){
		return;
	}

	checked_count = 0;
	selected_row = -1;
        
	for(row=rowcount; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			checked_count++;
			
			selected_row = row;
                
			var close_date   = GridObj.GetCellValue("RFQ_CLOSE_TIME", row).replace(/[^\d|A-Z|a-z]/g,"").substring(0,8);
			var close_time   = GridObj.GetCellValue("RFQ_CLOSE_TIME", row).replace(/[^\d|A-Z|a-z]/g,"").substring(8,12);
			var extends_date =  GridObj.GetCellValue("RFQ_EXTENDS_DATE", row).replace(/[^\d|A-Z|a-z]/g,"").substring(0,8);
			var extends_time =  GridObj.GetCellValue("RFQ_EXTENDS_TIME", row).replace(/[^\d|A-Z|a-z]/g,"").substring(0,4);
                
			if(extends_date == "" || extends_time == ""){
				alert("연장마감일자와 연장마감시간을 입력해주십시요.");
				
				return;
			}
    	        
			if(close_date > extends_date){
				alert("연장일자가 연장마감일보다 이후여야 합니다.");
				
				return;
			}
    	        
			if( close_date == extends_date && extends_time <= close_time){
				alert("연장시간이 연장마감시간보다 이후여야 합니다.");
				
				return;
			}    	        

			var re = new RegExp("[^0-9]");
			
			if(re.test(GridObj.GetCellValue("RFQ_EXTENDS_TIME", row))){
				alert("연장마감시간은 숫자만 입력가능합니다.");
				
				return;
			}

			if(GridObj.GetCellValue("RFQ_EXTENDS_TIME", row).length != 4){
				alert("연장마감시간은 시분 4자리로 입력해주십시요.");
				
				return;
			}
			
			if (eval(extends_date||extends_time) < eval(current_date||current_time)) {
				alert ("견적기간연장 일자는 오늘보다 이후 날짜이어야 합니다.");
				
				return;
			}
		}
	}

	if(checked_count == 0){
		alert(G_MSS1_SELECT);
		
		return;
	}

	if(!confirm("견적기간을 연장하시겠습니까?")) {
		return;
	}

	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis1";
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	
	params = "?mode=setRFQExtends";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(url+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
}
    
function SP0216_Popup() { //구매담당
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=HOUSE_CODE%>&values=<%=COMPANY_CODE%>&values=&values=";
	
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {
	document.form1.change_user.value = ls_ctrl_code;
	document.form1.txtchange_user.value = ls_ctrl_name;
}
	
function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "t_imagetext") { //견적요청번호 click
		rfq_no    = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
		rfq_count = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

		if(msg3 == IDX_RFQ_NO) {
			window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
		}
		else if(msg3 == IDX_ANNOUNCE_DATE) {
			ivalue     = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_ANNOUNCE_DATE));
			ITEM_COUNT = GD_GetCellValueIndex(GridObj,msg2, IDX_ITEM_CNT);

			if(ivalue  == "Y") {
				window.open("rfq_pp_dis5.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count + "&count=" + ITEM_COUNT,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=350,left=0,top=0")
			}
		}
	}
	else if (msg1 == "t_insert") {
		rfd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_EXTENDS_DATE);
			
		if(msg3 == IDX_RFQ_EXTENDS_DATE) {
			if(rfd_date < eval("<%=SepoaDate.getShortDateString()%>") ) {
				alert("연장마감일은 현재날짜 이후여야 합니다."  );
				
				GD_SetCellValueIndex(GridObj,msg2, IDX_RFQ_EXTENDS_DATE, msg4);
			}	
		}
	}
	else if(msg1 == "doData") {
		if(mode == "setRfqDelete") {
			if("1" == GridObj.GetStatus()){
				doSelect();
			}
		}
		
		if(mode == "setRFQClose") {
			if("1" == GridObj.GetStatus()){
				doSelect();
			}
		}
		
		if(mode == "setRFQExtends") {
			if("1" == GridObj.GetStatus()){
				doSelect();
			}
		}
	}
	else if(msg1 == "t_insert"){
		if(msg3==IDX_RFQ_EXTENDS_TIME){
			var regExp       = new RegExp("[0-2][0-9][0-6][0-9]");
			var regExp1      = new RegExp("[0-9]");
			var regExp2      = new RegExp(".*[:].*");
			var extendedTime = GridObj.GetCellValue("RFQ_EXTENDS_TIME", msg2);

			if(!regExp1.test(extendedTime) || regExp2.test(extendedTime)){
				alert("숫자만 입력 가능합니다.(ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
				
				return;
			}

			if(extendedTime.length != 4){
				alert("시간 형식에 맞게 입력 해주세요. (ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
				
				return;
			}

			if(!regExp.test(extendedTime) || Number(extendedTime) > 2359){
				alert("0000~2359 사이의 시간값을 입력 해주세요. (ex.1800)");
				
				GridObj.SetCellValue("RFQ_EXTENDS_TIME", msg2, "");
			}
		}
	}
}

function PopupManager(part){
	var wise = GridObj;
	var url  = "";
	
	if(part == "ctrl_person_id") {
		window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	/* 
	if(part=="ADD_USER_ID"){
		PopupCommon2("SP0023","getAddUser",G_HOUSE_CODE, G_COMPANY_CODE,"담당자ID","담당자명");
	}
	*/
}

function getCtrlUser(code, text) {
	document.form1.ctrl_person_id.value = code;
	document.form1.ctrl_person_id_name.value = text;
}

//지우기
function doRemove( type ){
    if( type == "ctrl_person_id" ) {
    	document.forms[0].ctrl_person_id.value = "";
        document.forms[0].ctrl_person_id_name.value = "";
    }  
}

/* 
function getAddUser(user_id, user_name, dept_name, position){
	document.form1.ctrl_person_id.value = user_id;
	document.form1.ctrl_person_id_name.value = user_name;
}
*/

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
	var rfqType    = "";
	var rfqNo      = "";
	var rfqCount   = "";
	var url        = "";
	var vendorType = "";
	
    rfqType   = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_TYPE");
	rfqNo     = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
    rfqCount  = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
    
	if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
	    url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '1024', '650');
	}
	else if(cellInd == GridObj.getColIndexById("VENDOR_CNT")) {	//지정업체수
	     if("OP" != rfqType){	//견적업체 선택
	    	url = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true'; 
	    	
    		popUpOpen(url, 'GridCellClick', '650', '350');
	    }
    }
	else if(cellInd == GridObj.getColIndexById("BID_COUNT")) {	//제안업체수
		if("OP" != rfqType){ //견적업체 선택	
			url      = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true';
		
			popUpOpen(url, 'GridCellClick', '650', '350');
	    }
	}
	else if(cellInd == GridObj.getColIndexById("RFQ_GIVEUP_CNT")) {		//견적포기수
		if("OP" != rfqType){ //견적업체 선택	
			url      = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&screen_flag=search&popup_flag=true';
		
			popUpOpen(url, 'GridCellClick', '650', '350');
		}
	}   
}

function doOnMouseOver(rowId,cellInd){}

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

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:Init();"  bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">
		<input type="hidden" name="h_rfq_no">
		<input type="hidden" name="h_rfq_count">
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
											<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="end_change_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
										<td width="35%" class="data_td">
											<input type="text" id="rfq_no" name="rfq_no" style="width:95%;ime-mode:inactive;" class="inputsubmit" maxlength="20"  onkeydown='entKeyDown()' >
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
										<td class="data_td">
											<input type="text" id="subject" name="subject" style="width:95%" class="inputsubmit" maxlength="20"  onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
										<td class="data_td">
											<select id="rfq_flag" name="rfq_flag" class="inputsubmit">
		                        				<option value="" selected>
		                        					<b>전체</b>
                                				</option>
                                				<option value="T">작성중</option>
                                				<option value="G">견적중</option>
                                				<option value="P">견적마감</option>
                                				<option value="C">견적종료</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적담당자</td>
										<td class="data_td" colspan="3">
<%
	if(this.isAdmin(info)) {
%>                        
											
<input type="text" name="ctrl_person_id" id="ctrl_person_id" size="20" style="ime-mode:inactive"  value="<%=info.getSession("ID")%>" class="inputsubmit"  onkeydown='entKeyDown()' >
<a href="javascript:PopupManager('ctrl_person_id')">
	<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
</a>
<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											
											<%-- 
											<input type="text" id="ctrl_person_id" name="ctrl_person_id" size="16" maxlength="10" class="inputsubmit" value='<%=info.getSession("ID")%>'  onkeydown='entKeyDown()' >
											<a href="javascript:PopupManager('ADD_USER_ID');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											--%>
<%
	}
	else{
%> 
											<input type="text" id="ctrl_person_id" name="ctrl_person_id" size="16" maxlength="10" class="inputsubmit" value='<%=info.getSession("ID")%>'  onkeydown='entKeyDown()' readonly>
<%
	}
%>
											<input type="text" id="ctrl_person_id_name" name="ctrl_person_id_name" size="25" class="input_data2" readonly value='<%=info.getSession("NAME_LOC")%>'  onkeydown='entKeyDown()' >
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
						<TR></TR>
					</TABLE>
				</td>
				<td height="30" align="right">
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
							<TD>
<script language="javascript">
btn("javascript:setRFQExtends()","견적기간연장");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:setRFQClose()","견적마감");
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
<%-- <s:grid screen_id="RQ_231" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>