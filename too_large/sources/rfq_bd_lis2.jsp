<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_235");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_235";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif"; // 이미지 

	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;

%>
<% String WISEHUB_PROCESS_ID="RQ_235";%>

<%
    String HOUSE_CODE 	= info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    String CTRL_CODE 	= info.getSession("CTRL_CODE");
    String dNameLoc 	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"));
    String depart 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));

	Config conf1 = new Configuration();
	String all_admin_profile_code = "";
	String admin_profile_code = "";
	String session_profile_code = info.getSession("MENU_TYPE");
	try {
		all_admin_profile_code = conf1.get("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
		admin_profile_code = conf1.get("wise.admin.profile_code."+info.getSession("HOUSE_CODE"));
	} catch (Exception e1) {
		
		all_admin_profile_code = "";
		admin_profile_code = "";
	}
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_rfq_bd_lis2"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
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
		<!-- 사용자 정의 Script -->
		<!-- HEADER START (JavaScript here)-->


		<script language="javascript" type="text/javascript">
//<!--
	var mode;

	var IDX_SELECTED              ;
	var IDX_RFQ_NO                ;
	var IDX_RFQ_COUNT             ;
	var IDX_RFQ_FLAG              ;
	var IDX_RFQ_FLAG_TEXT         ;
	var IDX_ITEM_CNT              ;
	var IDX_CHANGE_DATE           ;
	var IDX_SUBJECT               ;
	var IDX_RFQ_CLOSE_TIME        ;
	var IDX_VIEW_CNT              ;
	var IDX_BID_COUNT             ;
	var IDX_VENDOR_CNT	          ;
	var IDX_ANNOUNCE_DATE         ;
	var IDX_DEPT_NAME             ;
	var IDX_CHANGE_USER_NAME_LOC  ;
	var IDX_CTRL_CODE_NAME        ;
	var IDX_CHANGE_USER_ID        ;
	var IDX_CHANGE_DEPT_CODE      ;
	var IDX_CREATE_TYPE           ;
	var IDX_RFQ_TYPE              ;
	var IDX_CTRL_CODE 			  ;
	var IDX_PR_NO 			  	  ;
	var IDX_PR_TYPE			  	  ;
	var IDX_ITEM_NO				  ;
	var IDX_PRINT_NO              ;

	
	function Init(){
		
		setGridDraw();
		setHeader();	
		
		//GridObj.setHeader("List Price,CUSTOMER_PRICE,CUSTOMER_AMT");
	}
	
	
	function setHeader() {

		IDX_SELECTED                    = GridObj.GetColHDIndex("SELECTED");
		IDX_RFQ_NO                      = GridObj.GetColHDIndex("RFQ_NO");
		IDX_RFQ_COUNT                   = GridObj.GetColHDIndex("RFQ_COUNT");
		IDX_VENDOR_CODE                 = GridObj.GetColHDIndex("VENDOR_CODE");
		IDX_SETTLE_FLAG                 = GridObj.GetColHDIndex("SETTLE_FLAG");
		IDX_RFQ_QTY                  	= GridObj.GetColHDIndex("RFQ_QTY");
		IDX_CUSTOMER_PRICE              = GridObj.GetColHDIndex("CUSTOMER_PRICE");
		IDX_CUSTOMER_AMT                = GridObj.GetColHDIndex("CUSTOMER_AMT");
		IDX_SUPPLY_AMT                  = GridObj.GetColHDIndex("SUPPLY_AMT");
		IDX_SIGN_STATUS                 = GridObj.GetColHDIndex("SIGN_STATUS");
		IDX_QTA_NO                 		= GridObj.GetColHDIndex("QTA_NO");
		IDX_PR_NO 			          	= GridObj.GetColHDIndex("PR_NO");
		IDX_PR_TYPE			          	= GridObj.GetColHDIndex("PR_TYPE");
		IDX_ITEM_NO						= GridObj.GetColHDIndex("ITEM_NO");
		IDX_PRINT_NO					= GridObj.GetColHDIndex("PRINT_NO");
		IDX_CTRL_CODE					= GridObj.GetColHDIndex("CTRL_CODE");

		 doSelect();
	}

	function doSelect() {

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

		change_user = LRTrim(form1.change_user.value).toUpperCase();

		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis2";
		
		var grid_col_id = "<%=grid_col_id%>";
		var params = "mode=getRfqResultList";
		params += "&grid_col_id=" + grid_col_id;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {

		for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
	    if(msg1 == "doQuery")
	    {
	       // GridObj.SetGroupMerge("RFQ_NO,RFQ_COUNT,SUBJECT,QTA_NO,VENDOR_NAME,SIGN_STATUS_TEXT,CHANGE_USER_NAME_LOC");

            var maxRow = GridObj.GetRowCount();
			//alert(maxRow);
            for(i=0; i<maxRow; i++) {

				customer_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE);
				//supply_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE);

				if(eval(customer_unitPrice) > 0){
					itemQty = GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY);
                	var tmp_amt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);
                	GD_SetCellValueIndex(GridObj, i, IDX_CUSTOMER_AMT, String(setAmt(tmp_amt))); 
//                	GD_SetCellValueIndex(GridObj, i, IDX_CUSTOMER_AMT, "555"); 
                }
				//itemQty = GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY);
                //var tmp_amt = eval(supply_unitPrice) * eval(itemQty);
                //GD_SetCellValueIndex(GridObj,i, IDX_SUPPLY_AMT, tmp_amt);
            }
	    }
		else if(msg1 == "doData") {

    		//alert(GridObj.GetMessage());
			if(mode == "setRfqDelete") {
				if("1" == GD_GetParam(GridObj,1)) doSelect();
			}
			if(mode == "setRFQClose") {
				if("1" == GD_GetParam(GridObj,1)) doSelect();
			}
			if(mode == "setReturnToSettle") {
				if("1" == GD_GetParam(GridObj,1)) doSelect();
			}
		}
		if(msg1 == "t_imagetext") { //견적요청번호 click
			rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
			rfq_count = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

			if(msg3 == IDX_RFQ_NO) {
				window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=850,height=600,left=0,top=0");
            }
			else if(msg3 == IDX_QTA_NO) { //견적서번호
				st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_QTA_NO),msg2);

				if(LRTrim(st_qta_no) == "")
					return;

				st_vendor_code 	= GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);
				st_rfq_no 		= GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_NO),msg2);
				st_rfq_count 	= GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_COUNT);

				send_url = "qta_pp_dis1.jsp?st_vendor_code=" + st_vendor_code + "&st_qta_no=" + st_qta_no + "&t_flag=Y";
				send_url += "&st_rfq_no=" + st_rfq_no + "&st_rfq_count=" + st_rfq_count + "&st_close_data=" ;
				CodeSearchCommon(send_url,'qta_win1','0','0','1012','650');
            }
            else if(msg3 == IDX_PR_NO) { //구매요청번호
				pr_no = GD_GetCellValueIndex(GridObj,msg2,IDX_PR_NO);
				window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+pr_no ,"pr_pp","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
			}
            else if(msg3 == IDX_PRINT_NO){
            	 st_qta_no = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_QTA_NO),msg2);
            	 rfq_count = GridObj.GetCellValue(GridObj.GetColHDKey( IDX_RFQ_COUNT),msg2);
            	
            	  var param = new Array();
            	  param[0] = "<%=HOUSE_CODE%>";
            	  param[1] = st_qta_no;
            	  param[2] = rfq_count;
            	  fnOpen("/qt/QT_REPORT", param);
            }
		}
		if(msg1 == "t_insert") {
			if(msg3 == IDX_SELECTED)
			{
				selectCond(GridObj, msg2);
			}
		}
	}

	/*
	결재, 저장
	*/
	function Approval(sign_status)
	{
		var sepoa = GridObj;
		var f = document.forms[0];
		var sign_flag;
		var settle_flag;

		var iRowCount = sepoa.GetRowCount();
		var iCheckedCount =0;

		for(i=0;i<iRowCount;i++){

			if("true"==GD_GetCellValueIndex(sepoa, i, IDX_SELECTED)){
				iCheckedCount++;
				sign_flag=GD_GetCellValueIndex(sepoa,i,IDX_SIGN_STATUS);
				if(sign_flag == "E" || sign_flag == "P"){
					alert("결재중이거나 결재완료된 건에 대해서는 결재요청을 하실 수 없습니다.");
					return;
				}
				settle_flag=GD_GetCellValueIndex(sepoa,i,IDX_SETTLE_FLAG);
				if(settle_flag != "Y"){
					alert("업체가 선정되지 않은된 건에 대해서는 결재요청을 하실 수 없습니다.");
					return;
				}
			}
		}
		if(iCheckedCount<1)
		{
			alert(G_MSS1_SELECT);
			return;
		}

		if(sign_status == "P")
		{
			f.method = "POST";
			f.target = "childFrame";
			f.action = "/kr/admin/basic/approval/approval.jsp";
			f.submit();
		}
		else if(sign_status == G_SAVE_STATUS)
		{
			getApproval(sign_status);
		}
	}//Approval End

	function getApproval(str) {

		var supply_amt=0;
		var ttl_amt=0;
		var item_cnt=0;
		for(i=0;i<GridObj.GetRowCount();i++){

			if("true"==GD_GetCellValueIndex(GridObj, i, IDX_SELECTED)){
				settle_flag=GD_GetCellValueIndex(GridObj,i,IDX_SETTLE_FLAG);
				if(settle_flag == "Y"){
					supply_amt = GD_GetCellValueIndex(GridObj,i,IDX_SUPPLY_AMT);
	                ttl_amt += eval(supply_amt);
	                item_cnt++;
				}
			}
		}
		if(str == ""){
			alert("결재자를 지정해 주세요");
			return;
		}

		Message = "결재요청을 하시겠습니까";

		if(confirm(Message) == 1) {
			cancel_flag = true;
<%-- 			servletUrl = "<%=getWiseServletPath("dt.rfq.rfq_bd_lis2")%>"; --%>
			servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis2";
			mode = "setApprovalCreate";			//p2016.setApprovalCreate
			GridObj.SetParam("mode", mode);
			GridObj.SetParam("param", "");
			GridObj.SetParam("APPROVAL", str);
			GridObj.SetParam("SIGN_FLAG", "P");
			GridObj.SetParam("ITEM_CNT", item_cnt);
			GridObj.SetParam("TTL_AMT", ttl_amt);
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL","ALL");
		}
	}

    //구매담당
	function SP0023_Popup() {
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
	CodeSearchCommon(url,'doc','0','0','570','530');
	}


	function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
   		document.form1.change_user.value = USER_ID;
   		document.form1.txtchange_user.value = USER_NAME_LOC;
	}

	function checkUser() {
		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = true;

  		for(var row=0; row<GridObj.GetRowCount(); row++) {
  			if("true" == GD_GetCellValueIndex(GridObj,row, IDX_SELECTED)) {
  				for( i=0; i<ctrl_code.length; i++ )
				{
  					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, IDX_CTRL_CODE)) {
  						flag = true;
  						break;
  					} else flag = false;
  				}
  			}
  		}
		if (!flag)
			alert("작업을 수행할 권한이 없습니다.");

  		return flag;
  	}

	function getVendorCode(setMethod) {
		window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
	function SP0054_getCode(code, text1, text2) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = text1;
	}
	function setVendorCode( code, desc1, desc2) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}
	function SP0149_Popup() {
		var left = 0;
		var top = 0;
		var width = 570;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0149&function=SP0149_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=&desc=";
		//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		CodeSearchCommon(url, 'doc', left, top, width, height);
		}

	function SP0149_Popup_getCode(code, text) {
		document.form1.item_no.value = code;
		document.form1.item_name.value = text;
	}
    function start_change_date(year,month,day,week) {
           document.form1.start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
           document.form1.end_change_date.value=year+month+day;
    }

	function selectCond(sepoa, selectedRow)
	{
		var sepoa = GridObj;
		var cur_vendor_code  = GD_GetCellValueIndex(sepoa,selectedRow, IDX_VENDOR_CODE);
		var cur_rfq_no  	 = GD_GetCellValueIndex(sepoa,selectedRow, IDX_RFQ_NO);
		var cur_rfq_count  	 = GD_GetCellValueIndex(sepoa,selectedRow, IDX_RFQ_COUNT);
		var iRowCount   	 = sepoa.GetRowCount();

		for(var i=0;i<iRowCount;i++)
		{
			if(i==selectedRow)
				continue;
			if(cur_rfq_no == GD_GetCellValueIndex(sepoa,i,IDX_RFQ_NO)&&cur_rfq_count == GD_GetCellValueIndex(sepoa,i,IDX_RFQ_COUNT))
			{
				var flag = "true";
				if(GD_GetCellValueIndex(sepoa,i,IDX_SELECTED) == "true")
					flag = "false";

				GD_SetCellValueIndex(sepoa,i,IDX_SELECTED,flag + "&","&");

			}else{
				var flag = "false";
				GD_SetCellValueIndex(sepoa,i,IDX_SELECTED,flag + "&","&");
			}
		}
	}

function doReturn(flag)
{
	if(!checkUser()) return;
	
	var checked_count = 0;
	var rfq_no
	var rfq_count;
	var rowcount = GridObj.GetRowCount();

	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, IDX_SELECTED)) {

		    rfq_no = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_NO);
		    rfq_count = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_COUNT);
		    pr_no = GD_GetCellValueIndex(GridObj,row, IDX_PR_NO);
		    item_no = GD_GetCellValueIndex(GridObj,row, IDX_ITEM_NO);

			sign_flag=GD_GetCellValueIndex(GridObj,row,IDX_SIGN_STATUS);
			//if(sign_flag == "E" || sign_flag == "P"){
			//	alert("결재중이거나 결재완료된 건에 대해서는 선정취소를 하실 수 없습니다.");
			//	return;
			//}
			checked_count++;

			if(GridObj.GetCellValue("SETTLE_FLAG", row) == "N"){
    			alert("선정이 되지 않은 업체입니다.");
    			return;
    		}
			
			if(GridObj.GetCellValue("CAN_CANCEL_BIDDING", row) == "N"){
    			alert("품의가 진행되어서 낙찰취소 하실 수 없습니다.");
    			return;
    		}
		}
	}

	if(checked_count == 0)  {
		alert("견적요청번호를 선택하십시요.");
		return;
	}

	Message = "선택하신 견적의 업체선정을 취소하시겠습니까?";

	if(confirm(Message) == 1) {
		
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis2";
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
	    var cols_ids = "<%=grid_col_id%>";
	    var params;
	    
	    params = "?mode=setReturnToSettle";
	    params += "&cols_ids=" + cols_ids;
	    params += dataOutput();
	    
	    myDataProcessor = new dataProcessor(servletUrl + params);
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		
	}

}//doReturn End

function doQtDelete()
{
	if(!checkUser()) return;
	
	var checked_count = 0;
	var rfq_no
	var rfq_count;
	var rowcount = GridObj.GetRowCount();

	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, IDX_SELECTED)) {

		    rfq_no = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_NO);
		    rfq_count = GD_GetCellValueIndex(GridObj,row, IDX_RFQ_COUNT);
		    pr_no = GD_GetCellValueIndex(GridObj,row, IDX_PR_NO);
		    item_no = GD_GetCellValueIndex(GridObj,row, IDX_ITEM_NO);

			sign_flag=GD_GetCellValueIndex(GridObj,row,IDX_SIGN_STATUS);
			//if(sign_flag == "E" || sign_flag == "P"){
			//	alert("결재중이거나 결재완료된 건에 대해서는 선정취소를 하실 수 없습니다.");
			//	return;
			//}
			checked_count++;
			
			if(GridObj.GetCellValue("SETTLE_FLAG", row) == "Y"){
    			alert("업체선정 취소후 삭제 가능합니다.");
    			return;
    		}

			if(GridObj.GetCellValue("RFQ_TYPE", row) != "MA"){
    			alert("입력대행만 삭제 가능합니다.");
    			return;
    		}
			
			
			if(GridObj.GetCellValue("CAN_CANCEL_BIDDING", row) == "N"){
    			alert("품의가 진행되어서 낙찰취소 하실 수 없습니다.");
    			return;
    		}
		}
	}

	if(checked_count == 0)  {
		alert("견적서번호를 선택하십시요.");
		return;
	}

	Message = "선택하신 입력대행건을 삭제하시겠습니까?";

	if(confirm(Message) == 1) {
		
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_lis2";
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
	    var cols_ids = "<%=grid_col_id%>";
	    var params;
	    
	    params = "?mode=setReturnToSettle";
	    params += "&cols_ids=" + cols_ids;
	    params += dataOutput();
	    
	    myDataProcessor = new dataProcessor(servletUrl + params);
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		
	}

}//doQtDelete End


//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
//     	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
    	GridObj.setSizes();
    	
    	//GridObj.setHeader("Sales,Book Title and Author,#cspan,Price,In Store,Shipping,Bestseller and Date of Publication,#cspan");

    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}
    
	if(cellInd == GridObj.getColIndexById("RFQ_NO")) {
		var rfqNo    = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
		var rfqCount = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
	    var url = 'rfq_bd_dis1.jsp?rfq_no=' + encodeUrl(rfqNo) + '&rfq_count=' + encodeUrl(rfqCount) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '850', '600');
		//window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
	}else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
		
		if(GridObj.getColIndexById("QTA_NO") == "")
			return;

		var vendorCode 	= SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		var qtaNo     	= SepoaGridGetCellValueId(GridObj, rowId, "QTA_NO");
		
		var rfqNo       = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_NO");
		var rfqCount    = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_COUNT");
	    var url = "qta_pp_dis1.jsp?st_vendor_code=" + vendorCode + "&st_qta_no=" + qtaNo + "&st_rfq_no=" + encodeUrl(rfqNo) + "&st_rfq_count=" + encodeUrl(rfqCount) + "&screen_flag=search&popup_flag=true";
		popUpOpen(url, 'GridCellClick', '1012', '650');
		
		//window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
	}else if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var prNo       = GD_GetCellValueIndex(GridObj, rowIndex, IDX_PR_NO);
		var prType     = GD_GetCellValueIndex(GridObj, rowIndex, IDX_PR_TYPE);
		var page       = null;
		
		page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		
		/* 
		if(prType == "I"){
			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		}
		else{
			page = "/kr/dt/pr/pr1_bd_dis1NotI.jsp";
		}
		*/
		
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

    if(status == "true") {
        alert(messsage);
        doSelect();
    } else {
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
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }  
    if( type == "item_no" ) {
    	document.forms[0].item_no.value = "";
        document.forms[0].item_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

function doPrint(){
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	if(grid_array.length > 1){
		alert("하나의 항목만 선택해 주세요.");
		return;
	}
	
	var rfq_no 		= GridObj.cells(grid_array[0], GridObj.getColIndexById("RFQ_NO")).getValue();
	var rfq_count 	= GridObj.cells(grid_array[0], GridObj.getColIndexById("RFQ_COUNT")).getValue();
	
	popUpOpen("/kr/dt/rfq/rfq_price.jsp?rfq_no="+rfq_no+"&rfq_count="+rfq_count, 'rfqPrice', '1012', '650');
	
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.start_change_date.value;	//견적요청일 from
	sRptData += " ~ ";
	sRptData += document.form1.end_change_date.value;	//견적요청일 to
	sRptData += rf;
	sRptData += document.form1.vendor_code.value;	//업체코드1
	sRptData += rf;
	sRptData += document.form1.vendor_code_name.value;	//업체코드2
	sRptData += rf;
	sRptData += document.form1.change_user.value;	//견적담당자1
	sRptData += rf;
	sRptData += document.form1.txtchange_user.value;	//견적담당자2
	sRptData += rf;
	sRptData += document.form1.rfq_no.value;	//견적요청번호
	sRptData += rf;
	sRptData += document.form1.settle_flag.options[document.form1.settle_flag.selectedIndex].text;	//선정여부
	sRptData += rf;
	sRptData += document.form1.pr_no.value;	//구매요청번호
	sRptData += rf;
	sRptData += document.form1.item_no.value;	//품목명1
	sRptData += rf;
	sRptData += document.form1.item_name.value;	//품목명2
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("RFQ_NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("RFQ_COUNT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SUBJECT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("QTA_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SETTLE_FLAG",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("ITEM_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("DESCRIPTION_LOC",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("UNIT_MEASURE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("RFQ_QTY",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("CUR",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("SUPPLY_PRICE",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("SUPPLY_AMT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("RD_DATE",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("PR_NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("CHANGE_USER_NAME_LOC",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("RFQ_TYPE_NAME",i);
		sRptData += rl;				
	}	

	document.form1.rptData.value = sRptData;
	
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}

</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<form name="form1" action="">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
<input type="hidden" name="h_rfq_no">
<input type="hidden" name="h_rfq_count">
<input type="hidden" name="doc_type" value="RQ">
<input type="hidden" name="fnc_name" value="getApproval">
<input type="hidden" name="sign_status" value="">
<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
<input type="hidden" name="req_user_id" value="<%=info.getSession("ID")%>">
<input type="hidden" name="bid_req_type" value="">

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
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적요청일
	</td>
	<td width="35%" class="data_td">
		<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
		~
		<s:calendar id="end_change_date" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
	</td>
    <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체코드</td>
    <td class="data_td" width="35%">
      <input type="text" name="vendor_code" id="vendor_code" size="13" style="ime-mode:inactive" class="inputsubmit" maxlength="10" onkeydown='entKeyDown()'>
      <a href="javascript:getVendorCode('setVendorCode')"><img src="<%=G_IMG_ICON%>" width="19" height="19" align="absmiddle" border="0"></a>
      <a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
      <input type="text" name="vendor_code_name" size="20" class="input_data2" onkeydown='entKeyDown()'>
    </td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적담당자
	</td>
	<td class="data_td">
<% if (session_profile_code.equals(all_admin_profile_code) || session_profile_code.equals(admin_profile_code)) {%>                        		
		<input type="text" name="change_user" id="change_user" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>"  onkeydown='entKeyDown()'>
		<a href="javascript:SP0023_Popup()">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
		</a>
<% } else{%> 
		<input type="text" name="change_user" id="change_user" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>" onkeydown='entKeyDown()' readonly>	
<%} %>		
		<input type="text" name="txtchange_user" id="txtchange_user" size="20" class="input_data2" onkeydown='entKeyDown()' readonly value='<%=info.getSession("NAME_LOC")%>'>
		
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 견적요청번호
	</td>
	<td width="35%" class="data_td">
		<input type="text" name="rfq_no" id="rfq_no" style="width:95%;ime-mode:inactive;" class="inputsubmit" maxlength="20" onkeydown='entKeyDown()'>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 선정여부
	</td>
	<td class="data_td">
		<select name="settle_flag" id="settle_flag" class="inputsubmit">
		<option value="">
			전체
		</option>
		<option value="Y">Y</option>
		<option value="N">N</option>
		</select>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
		 구매요청번호
	</td>
	<td width="35%" class="data_td">
		<input type="text" name="pr_no" id="pr_no" style="width:95%;ime-mode:inactive;" class="inputsubmit" maxlength="20" onkeydown='entKeyDown()'>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 품목명</td>
	<td class="data_td" colspan="3">
		<input type="text" name="item_no" id="item_no" size="15" class="inputsubmit" style="ime-mode:inactive;" onkeydown='entKeyDown()'>
		<a href="javascript:SP0149_Popup()">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
		</a>
		<a href="javascript:doRemove('item_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
		<input type="text" name="item_name" id="item_name" size="20" class="input_data2" value="" onkeydown='entKeyDown()'>
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
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    		</script></TD>
			<TD><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></TD>
<%if(!"MUP110300005".equals(info.getSession("MENU_TYPE"))){ %>
			<TD><script language="javascript">btn("javascript:doReturn('D')","선정취소")	</script></TD>
			<TD><script language="javascript">btn("javascript:doQtDelete()","견적서 입력대행 삭제")	</script></TD>			
			<TD><script language="javascript">btn("javascript:doPrint()","가격조사서")	</script></TD>
<%} %>
		</TR>
		</TABLE>
	</td>
</tr>
</table>



<iframe name = "childFrame" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="RQ_235" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>


