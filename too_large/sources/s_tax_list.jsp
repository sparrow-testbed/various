<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_001_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	isRowsMergeable = true;
	
%>

<!-- 폼작업만 했기때문에 틀을 제외한 함수 차후 변경 및 적용 -->
<%
	String user_id         	= info.getSession("ID");
	String company_code    	= info.getSession("COMPANY_CODE");
	String house_code      	= info.getSession("HOUSE_CODE");
	String toDays          	= SepoaDate.getShortDateString();
	String toDays_1        	= SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   	= info.getSession("NAME_LOC");
	String ctrl_code       	= info.getSession("CTRL_CODE");
	String to_date          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	String from_date        = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),-7));

	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");

%>


<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<!--
	var	servletUrl = "";
	
	var IDX_SEL;
	var IDX_TAX_NO;
	var IDX_PAY_NO;
	var IDX_INV_NO;
	var IDX_PO_NO;
	var IDX_VENDOR_CODE;

	function setHeader() {
// 		var f0 = document.forms[0];

<%-- 		f0.from_date.value = "<%=toDays_1%>"; --%>
<%-- 		f0.to_date.value   = "<%=toDays%>"; --%>

// //		GridObj.SetColCellBgColor("PAY_END_DATE"  ,G_COL1_ESS);
// // 		GridObj.SetColCellBgColor("SUM_PRICE"		,G_COL1_ESS);

// 		GridObj.SetDateFormat("ADD_DATE"			,"yyyy-MM-dd");
// 		GridObj.SetDateFormat("TAX_DATE"			,"yyyy-MM-dd");
// 		GridObj.SetDateFormat("PAY_DEMAND_DATE"	,"yyyy-MM-dd");
// 		GridObj.SetDateFormat("PAY_END_DATE"		,"yyyy-MM-dd");
		
// 		GridObj.SetNumberFormat("SUP_AMT"			,G_format_amt);
// 		GridObj.SetNumberFormat("TAX_AMT"			,G_format_amt);
// 		GridObj.SetNumberFormat("TOT_AMT"			,G_format_amt);

     	

// 		/*
// 		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);

// 		*/
		
		IDX_SEL				= GridObj.GetColHDIndex("SEL");
		IDX_TAX_NO			= GridObj.GetColHDIndex("TAX_NO");
		IDX_PAY_NO			= GridObj.GetColHDIndex("PAY_NO");
		IDX_INV_NO			= GridObj.GetColHDIndex("INV_NO");
		IDX_PO_NO			= GridObj.GetColHDIndex("PO_NO");
		IDX_VENDOR_CODE		= GridObj.GetColHDIndex("VENDOR_CODE");
		IDX_VENDOR_NAME		= GridObj.GetColHDIndex("VENDOR_NAME");
		GridObj.setColumnHidden(GridObj.getColIndexById("SEL"), true);
	}

	function doSelect()
	{
		var f0 = document.forms[0];

		if(!checkDateCommon(del_Slash(f0.from_date.value))) {
			alert(" 작성일자(From)를 확인 하세요 ");
			f0.from_date.focus();
			return;
		}

		if(!checkDateCommon(del_Slash(f0.to_date.value))) {
			alert(" 작성일자(To)를 확인 하세요 ");
			f0.to_date.focus();
			return;
		}
		
		/* $("#from_date").val(del_Slash(f0.from_date.value));
		$("#to_date").val(del_Slash(f0.to_date.value)); */
		
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getTaxList&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.s_tax_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var tax_no = "";
		var pay_no = "";
		var inv_no = "";
		var iv_no = "";
		var po_no = "";
		var vendor_code = "";
		
		
		if(msg1 == "doQuery"){
// 			for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
// 				if(GridObj.GetCellValue("PROGRESS_CODE", i) == "I" && GridObj.GetCellValue("SIGN_STATUS", i) == "T"){
// 					GridObj.SetCellActivation('PAY_END_DATE', i, 'edit');
// 					GridObj.SetCellBgColor('PAY_END_DATE', i, G_COL1_ESS);
// 				}else if(GridObj.GetCellValue("PROGRESS_CODE", i) == "R" && GridObj.GetCellValue("SIGN_STATUS", i) == "R"){
// 					GridObj.SetCellActivation('PAY_END_DATE', i, 'edit');
// 					GridObj.SetCellBgColor('PAY_END_DATE', i, G_COL1_ESS);
// 				}else if(GridObj.GetCellValue("PROGRESS_CODE", i) == "R" && GridObj.GetCellValue("SIGN_STATUS", i) == "T"){
// 					GridObj.SetCellActivation('PAY_END_DATE', i, 'edit');
// 					GridObj.SetCellBgColor('PAY_END_DATE', i, G_COL1_ESS);
// 				}
// 			}
		}
		if(msg1 == "doData"){
						
			var mode = GD_GetParam(GridObj,"0");
			var progress_code = GD_GetParam(GridObj,"1");
			
			if(mode == "setProgressCode"){
				if(progress_code == "C"){
					alert("승인 되었습니다.");
				}else if (progress_code == "R"){
					alert("반려 되었습니다.");
				}
				doSelect();
			}
		}
		if(msg1 == "t_imagetext") {
			
			if(msg3==IDX_TAX_NO){
				tax_no		= GD_GetCellValueIndex(GridObj,msg2,IDX_TAX_NO);
				window.open("tx1_bd_dis1.jsp"+"?tax_no="+tax_no,"newWin","width=1100,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			} else if(msg3==IDX_PAY_NO) {
				pay_no		= GD_GetCellValueIndex(GridObj,msg2,IDX_PAY_NO);
				window.open("/kr/order/ivtr/tr1_bd_dis1.jsp"+"?pay_no="+pay_no,"newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		    } else if(msg3==IDX_INV_NO){
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				inv_no           = GD_GetCellValueIndex(GridObj,msg2,IDX_INV_NO);
				iv_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_INV_NO);
				window.open("/kr/order/ivdp/inv1_bd_dis1.jsp"+"?inv_no="+inv_no+"&po_no="+po_no+"&iv_no="+iv_no+"&gubun=noamt","newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			} else if(msg3==IDX_VENDOR_NAME) {
				vendor_code = GD_GetCellValueIndex(GridObj,msg2,IDX_VENDOR_CODE);
				window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
	    	}
		}
	}
	
	//************************************************** Date Set *************************************
	function valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.from_date.value=year+month+day;
	}
	function valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.to_date.value=year+month+day;
	}
	function tax_valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.tax_from_date.value=year+month+day;
	}
	function tax_valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.tax_to_date.value=year+month+day;
	}
	
  	function Approval(sign_status)
  	{
	    var Sepoa = GridObj;
	    var f = document.forms[0];

		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var tax_no 			= "";
		var sel_sign_status	  = "";
		var cur_progress_code = "";
		var purcharse_id	= ""; 
		
		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
			{
				iCheckedCount++;
				iSelectedRow = i;
				tax_no = GridObj.GetCellValue("TAX_NO", i);
				
				sel_sign_status = GridObj.GetCellValue("SIGN_STATUS", i);
				cur_progress_code = GridObj.GetCellValue("PROGRESS_CODE", i);
				purcharse_id = GridObj.GetCellValue("PURCHARSE_ID", i);
// 				일단보류
// 				if(sel_sign_status == "T" ){
// 					// 지불일 입력 여부 확인
// 					if(GridObj.GetCellValue("PAY_END_DATE", i) == "" ||
// 					   GridObj.GetCellValue("PAY_END_DATE", i) == null ){
// 						alert("지불일을 입력하셔야 합니다.");
// 						return;
// 					}
<%-- 					if(GridObj.GetCellValue("PAY_END_DATE", i) <= eval("<%=SepoaDate.getShortDateString()%>")){ --%>
// 		  				alert("지불일을 현재일 이후여야 합니다.");
// 		  				return;
// 		  			}										
// 				}else if(sel_sign_status == "R" && cur_progress_code == "R"){
// 					// 지불일 입력 여부 확인
// 					if(GridObj.GetCellValue("PAY_END_DATE", i) == "" ||
// 					   GridObj.GetCellValue("PAY_END_DATE", i) == null ){
// 						alert("지불일을 입력하셔야 합니다.");
// 						return;
// 					}
<%-- 					if(GridObj.GetCellValue("PAY_END_DATE", i) <= eval("<%=SepoaDate.getShortDateString()%>")){ --%>
// 		  				alert("지불일을 현재일 이후여야 합니다.");
// 		  				return;
// 		  			}					
// 				}
				
				if(!(cur_progress_code == "R")){
		        	if(cur_progress_code != "I"){
		    			alert("발행건만 승인 가능합니다.");
		    			return;    		
		        	}   	
		    	}
			}			
		}

		if(iCheckedCount < 1)
		{
			alert(G_MSS1_SELECT);
			return;
		}

    	if(iCheckedCount > 1)
		{
			alert("하나의 항목만 선택해주세요");
			return;
		} 
    	
	    // 결재상태 변경
// 	    f.h_sign_status.value = sign_status;
	    // 세금계산서번호 
	    f.tax_no.value = tax_no;
	    // 프로젝트명 
// 	    f.project.value = project;
	    getApproval(sign_status);
// 	    if(sign_status == "P") {
			
// 	      	f.method = "POST";
// 	      	f.target = "childFrame";
// 	      	f.action = "/kr/admin/basic/approval/approval.jsp";
// 	      	f.submit();

// 	    } 
  	}
  	
	function getApproval(approval_str) {
    	var f = document.forms[0];
    	f.approval_str.value = approval_str;
    	var grid_array = getGridChangedRows(GridObj, "SEL");
    	var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.s_tax_list";
		var params = "mode=setTxApp&cols_ids="+cols_ids;
			params += dataOutput();
	    myDataProcessor = new dataProcessor(SERVLETURL, params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
	}

	function SetProgress(sign_status){
		
	    var Sepoa = GridObj;
	    var f = document.forms[0];

		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var tax_no 			= "";
		var sel_sign_status	= "";
		var cur_progress_code = "";
		var purcharse_id	= "";       
		var message			= "";
    	
    	if(sign_status == "R" ){
 
    		for(var i=0;i<iRowCount;i++)
    		{
    			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
    			{
    				iCheckedCount++;
    				iSelectedRow = i;
    				tax_no = GridObj.GetCellValue("TAX_NO", i);
    				sel_sign_status = GridObj.GetCellValue("SIGN_STATUS", i);
    				cur_progress_code = GridObj.GetCellValue("PROGRESS_CODE", i);
    			}
    		}

    		if(iCheckedCount < 1)
    		{
    			alert(G_MSS1_SELECT);
    			return;
    		}

        	if(iCheckedCount > 1)
    		{
    			alert("하나의 항목만 선택해주세요");
    			return;
    		}
        		
        	if(!(cur_progress_code == "I" && ( sel_sign_status == "T" || sel_sign_status == "R" ))){
    			alert("미상신,반려 건만 반려 할 수 있습니다.");
    			return;    		
        	}else{
        		if(cur_progress_code == "R"){
        			alert("이미 반려 되었습니다.");
        			return ;
        		}
        	}
        	message = "반려 하시겠습니까?";
		
    	if(!confirm(message)){
    		return;
    	}
    	
    	if(sign_status == "R" ){
    		f.approval_str.value = sign_status;
    	    f.tax_no.value = tax_no;
    		window.open("tx1_pp_lis1.jsp"+"?tax_no="+tax_no,"newWin","width=600,height=300,resizable=NO, scrollbars=NO, status=yes, top=0, left=0");
	}
    	}
	}
	function SetReject_Reamrk(buyer_reject_Remark){	
	    var f = document.forms[0];
	    f.buyer_reject_Remark.value = buyer_reject_Remark;
	    var grid_array = getGridChangedRows(GridObj, "SEL");
    	var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.s_tax_list";
		var params = "mode=setProgressCode&cols_ids="+cols_ids;
			params += dataOutput();
	    myDataProcessor = new dataProcessor(SERVLETURL, params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
	}
	
	// 출력물 테스트 
	function doPrint(){
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var tax_no 			= "";
		var progress_code 	= "";
		
		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "true")
			{
				iCheckedCount++;
				iSelectedRow = i;

				tax_no = GridObj.GetCellValue("TAX_NO", i);
			}
		}

		if(iCheckedCount < 1)
		{
			alert(G_MSS1_SELECT);
			return;
		}

    	if(iCheckedCount > 1)
		{
			alert("하나의 항목만 선택해주세요");
			return;
		}
    	
		param = new Array();
		param[0] = "<%=house_code%>";
		param[1] = tax_no;
		fnOpen("/tx/TX_REPORT", param);
	}
	
	function grid_rowspan(col_num,col_name){
	    var cnt = 0;
	    var temp1 = "";
	    var temp2 = "";
	    var col_num_cnt = col_num.split(",");
	    var col_name_cnt = col_name.split(",");
	    var col_ids = new Array();

	    for( var k = 0 ; k < col_name_cnt.length ; k++){
		col_ids.push(GridObj.getColIndexById(col_name_cnt[k]));
	    } 
	    for(var i = 1; i < dhtmlx_last_row_id+1; i++){
			cnt = 0;
			temp1 = "";

			for( var k = 0 ; k < col_ids.length ; k++){
				temp1 += (GridObj.cells(i, col_ids[k]).getValue());
			}

			if(temp1 == "") {
				continue;
			}

			//해당 필드의 똑같은 데이타를 가지고 있는 로우의 갯수를 셈.
			for(var j = i; j < dhtmlx_last_row_id+1; j++){
				temp2 = "";
				
				for( var k = 0 ; k < col_ids.length ; k++){
					temp2 += (GridObj.cells(j, col_ids[k]).getValue());
				}

				if(temp1 == temp2){
					cnt = cnt + 1;
				} else {
					break;
				}
				//alert("["+temp1 + "=" + temp2 + "] : " + cnt);
			}

			//그 row수만 큼 span. 
			for(var m = 0; m<col_num_cnt.length; m++){
				spld = col_num_cnt[m].split("-");
				start_num = Number(spld[0]);
				end_num = Number(spld[1]);
				for(var n = start_num; n <= end_num; n++){
					GridObj.setRowspan(i,n,cnt);// 줄 / 칸 / 갯수
				} 
			}

			i = i + cnt - 1;
	    }
	}	
	
	function goTrusbil(){
		window.open('http://www.trusbill.or.kr', '_blank');
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
function doOnRowSelected(rowId,cellInd)
{
	if( GridObj.getColIndexById("TAX_NO") == cellInd ){
		if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
	  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
			location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&status=" + status + "&gubun=P";	
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
			document.taxListForm.userType.value="R"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
			document.taxListForm.target="taxInvoice";
			document.taxListForm.submit();		
		}
	}
	else if(GridObj.getColIndexById("INV_NO") == cellInd) {
		var url = "/procure/invoice_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		param += "&inv_no="+SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		PopupGeneral(url+param, "IvDetailPop", "", "", "1000", "600");
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
    	//JavaCall("doData");
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

//     grid_rowspan("7-7", "INV_NO");
    grid_rowspan("0-5,10-27","SEL,PROGRESS_CODE_TXT,ADD_DATE,TAX_DATE,TAX_NO,VENDOR_NAME,SUP_IRS_NO,TAX_APP_NO,TAX_DIV_TXT,PURCHARSE_NAME,SUP_AMT,TAX_AMT,TOT_AMT,PAY_DEMAND_DATE,PAY_END_DATE");
    
    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
	$("#from_date").val(add_Slash($("#from_date").val()));
	$("#to_date").val(add_Slash($("#to_date").val()));
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<%if("".equals(gate)){%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<%
}
%>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form1" >
	<input type="hidden" id="h_sign_status" name="h_sign_status" value="N">
	<input type="hidden" id="kind" name="kind">
	<input type="hidden" id="type_tmp" name="type_tmp" value="">
	<input type="hidden" id="att_mode" name="att_mode"  value="">
	<input type="hidden" id="view_type" name="view_type"  value="">
	<input type="hidden" id="file_type" name="file_type"  value="">
	<input type="hidden" id="tmp_att_no" name="tmp_att_no" value="">
	<input type="hidden" id="house_code" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" id="company_code" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" id="dept_code" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" id="req_user_id" name="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" id="doc_type" name="doc_type" value="TAX">
	<input type="hidden" id="fnc_name" name="fnc_name" value="getApproval">
	<input type="hidden" id="tax_no" name="tax_no"/>
	<input type="hidden" id="project" name="project"/>
	<input type="hidden" id="buyer_reject_Remark" name="buyer_reject_Remark" />
	<input type="hidden" id="vendor_code" name="vendor_code" value="<%=info.getSession("COMPANY_CODE")%>">
    <input type="hidden" id="approval_str" name="approval_str" value="">
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 작성일자</td>
      <td class="data_td" width="35%">
        <s:calendar id_from="from_date" default_from="<%=from_date %>" default_to="<%=to_date %>" id_to="to_date" format="%Y/%m/%d" />
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발행일자</td>
      <td class="data_td" width="35%">
      	<s:calendar id_from="tax_from_date" default_from="" default_to="" id_to="tax_to_date" format="%Y/%m/%d" />
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 승인번호 </td>
      <td colspan="3" class="data_td" width="35%">
      	<input type="text" id="tax_app_no" name="tax_app_no" style="ime-mode:inactive" size="20" class="inputsubmit" >
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
	    	  			<TD><script language="javascript">btn("javascript:goTrusbil();","트러스빌 신규회원가입")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doSelect();","조 회")</script></TD>
<%-- 	    	  			<TD><script language="javascript">btn("javascript:Approval('C')","승 인")</script></TD> --%>
<%-- 	    	  			<TD><script language="javascript">btn("javascript:SetProgress('R');","반 려")</script></TD> --%>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>

<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
</form>

<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_001_1" grid_obj="GridObj" grid_box="gridbox" row_mergeable="true"/> --%>

<s:footer/>
</body>
</html>


