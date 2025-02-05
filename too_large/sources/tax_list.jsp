<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

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
	String LB_PROGRESS_CODE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M401", "");
	String LB_TAX_DIV 		= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M400", "");
	String LB_SIGN_STATUS 	= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#P013", "");
	String to_date          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	String from_date        = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),-7));

	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");

	//그리드 커스텀태그에 row_mergeable="true" 부분이 있으면 필요
	isRowsMergeable = true;
		
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_tax_list"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
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
	var IDX_KTGRM;
	var IDX_PROC_DEPT;
	var IDX_PROC_DEPT_NM;
	
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
		IDX_KTGRM           = GridObj.GetColHDIndex("KTGRM");
		IDX_PROC_DEPT       = GridObj.GetColHDIndex("PROC_DEPT");
		IDX_PROC_DEPT_NM    = GridObj.GetColHDIndex("PROC_DEPT_NM");
		doSelect();
	}

	function doSelect()
	{
		var f0 = document.forms[0];

		if(!checkDateCommon(f0.from_date.value.replaceAll("/",""))) {
			alert(" 작성일자(From)를 확인 하세요 ");
			f0.from_date.focus();
			return;
		}

		if(!checkDateCommon(f0.to_date.value.replaceAll("/",""))) {
			alert(" 작성일자(To)를 확인 하세요 ");
			f0.to_date.focus();
			return;
		}
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getTaxList&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.tax_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
		
		/* GridObj.SetParam("mode"			,"getTaxList"			);
		GridObj.SetParam("from_date"		,f0.from_date.value		);
		GridObj.SetParam("to_date"		,f0.to_date.value		);
		GridObj.SetParam("tax_from_date"	,f0.tax_from_date.value	);
		GridObj.SetParam("tax_to_date"	,f0.tax_to_date.value	);		
		GridObj.SetParam("vendor_code"	,f0.vendor_code.value	);		
		GridObj.SetParam("progress_code"	,f0.progress_code.value	);
		GridObj.SetParam("tax_div"		,f0.tax_div.value 		);
		GridObj.SetParam("tax_app_no"		,f0.tax_app_no.value  	);
		GridObj.SetParam("sign_status"	,f0.sign_status.value  	);
		GridObj.SetParam("ctrl_person_id"	,f0.ctrl_person_id.value);	
		
		GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";		
		 */
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
						
// 			var mode = GD_GetParam(GridObj,"0");
// 			var progress_code = GD_GetParam(GridObj,"1");
			
// 			if(mode == "setProgressCode"){
// 				if(progress_code == "R"){
// 					alert("반려 되었습니다");
// 				}else if (progress_code == "P"){
// 					alert("지불요청 되었습니다");
// 				}
// 				doSelect();
// 			}else if(mode == "setApproval"){
// 				alert("결재요청 되었습니다.");
// 				doSelect();
// 			}else if(mode == "setPayFinish"){
// 				alert("지불요청 되었습니다");
// 				doSelect();
// 			}
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
		if(msg1 == "t_insert")
		{
			if(msg3==IDX_KTGRM){
				if(GridObj.cells(GridObj.getRowId(msg2), GridObj.getColIndexById("KTGRM")).getValue() != "02" ){
					GridObj.cells(GridObj.getRowId(msg2), GridObj.getColIndexById("PROC_DEPT")).setValue("");
					GridObj.cells(GridObj.getRowId(msg2), GridObj.getColIndexById("PROC_DEPT_NM")).setValue("");
				}
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
	function getVendorCode(setMethod) {
		popupvendor(setMethod);
	}
	
	function setVendorCode( code, desc1, desc2 , desc3) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = desc1;
	}

	function popupvendor( fun )
	{
	    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

	function PopupManager(part)
	{
		var url = "";
		var f = document.forms[0];
	
		if(part == "DEMAND_DEPT")
		{
			window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		if(part == "ADD_USER_ID")
		{
			window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
	}
	
	function getDemand(code, text)
	{
		document.forms[0].demand_dept_name.value = text;
		document.forms[0].demand_dept.value = code;
	}
	
	function getAddUser(code, text)
	{
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
	}
	
	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.forms[0].ctrl_code.value = code;
		document.forms[0].ctrl_name.value = text;
	}
	
	function setKtgrm(){
		
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
		
		var row_idx = checkedDataRow("SEL");
		
		
	    var grid_array = getGridChangedRows(GridObj, "SEL");

	    if(grid_array.length > 0)
	    {
	    	if(grid_array.length > 1){
	    		alert("하나의 항목만 선택해주세요");
	    		return;
	    	}
	    }

		if (!row_idx) {
			return;		
		}
		
		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
			{
	        	if(GridObj.cells(GridObj.getRowId(i), GridObj.GetColHDIndex("KTGRM")).getValue() == "02" && GridObj.cells(GridObj.getRowId(i), GridObj.GetColHDIndex("PROC_DEPT")).getValue() == ""){
				 	alert("경상비 지급결의부서를 지정하세요.")
				 	return;
	        	}
			}
		}
		
		/*
		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
			{
	        	if($.trim(GridObj.cells(GridObj.getRowId(i), GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
						if(Number(GridObj.GetCellValue("PROGRESS_CODE", i)) != "-1"){
		        			alert("[정발행] 승인건만 대금지급가능합니다.");
		        			return ;    						
						}						
	        	}else{
						if(GridObj.GetCellValue("PROGRESS_CODE", i) != "50"){
		        			alert("[역발행] 승인건만 대금지급가능합니다.");
		        			return ;    						
						}
	        	}
			}
		}
		*/
		
		message = "대금지급구분을 변경 하시겠습니까?";
		
		if(confirm(message)){
			var grid_array = getGridChangedRows(GridObj, "SEL");
			//f.approval_code.value = progress_code;
			var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.tax_list";
			var params = "mode=setKtgrm&cols_ids="+cols_ids;
				params += dataOutput();
		    myDataProcessor = new dataProcessor(SERVLETURL, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
		}
		
		
	}

	function SetProgress(progress_code){
		
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
    	
		if(progress_code == "P"){
    		
    		var row_idx = checkedDataRow("SEL");
    		
    		
    	    var grid_array = getGridChangedRows(GridObj, "SEL");

    	    if(grid_array.length > 0)
    	    {
    	    	if(grid_array.length > 1){
    	    		alert("하나의 항목만 선택해주세요");
    	    		return;
    	    	}
    	    }

    		if (!row_idx) {
    			return;		
    		}
    		
      		for(var i=0;i<iRowCount;i++)
    		{
    			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
    			{
    	        	// 구매담당자 여부 확인
    	        	/*
    	        	if(GridObj.GetCellValue("PURCHARSE_ID", i) != "<%=user_id%>"){
    	        		alert("구매담당자만 가능합니다");
    	        		return;
    	        	}
    	        	*/
    	        	
    	        	if($.trim(GridObj.cells(GridObj.getRowId(i), GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	   					if(Number(GridObj.GetCellValue("PROGRESS_CODE", i)) != "-1"){
	   	        			alert("[정발행] 승인건만 대금지급가능합니다.");
	   	        			return ;    						
	   					}						
    	        	}else{
	   					if(GridObj.GetCellValue("PROGRESS_CODE", i) != "50"){
	   	        			alert("[역발행] 승인건만 대금지급가능합니다.");
	   	        			return ;    						
	   					}
    	        	}
    			}
    		}   		
        	message = "대금지급 하시겠습니까?";
    	}
		
    	if(!confirm(message)){
    		return;
    	}
    	
    	if(progress_code == "P"){
    		var grid_array = getGridChangedRows(GridObj, "SEL");
    		f.approval_code.value = progress_code;
        	var cols_ids = "<%=grid_col_id%>";
    		var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.tax_list";
    		var params = "mode=setPayFinish&cols_ids="+cols_ids;
    			params += dataOutput();
    	    myDataProcessor = new dataProcessor(SERVLETURL, params);
    	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
    	}
	}
	
	function doModify(){
	    var grid_array = getGridChangedRows(GridObj, "SEL");

	    if(grid_array.length == 0){
	    	return;
	    }else if(grid_array.length > 0){
	    	if(grid_array.length > 1){
	    		alert("한 건의 세금계산서만 선택하실 수 있습니다.");
	    		return;
	    	}
	    }
	    
	    var setIdx = -1;
  		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
			{
				/*
				if(GridObj.GetCellValue("PROGRESS_CODE", i) != '-1'){
					if(!(GridObj.GetCellValue("PROGRESS_CODE", i) == "-50" || GridObj.GetCellValue("PROGRESS_CODE", i) == "60" || GridObj.GetCellValue("PROGRESS_CODE", i) == "99" || GridObj.GetCellValue("PROGRESS_CODE", i) == "")){
	        			alert("역발행의 경우 거부(반려) 또는 발급 취소 건만 파기 가능합니다.");
	        			return ;    						
					} 
				}
				*/
				if(GridObj.GetCellValue("PROGRESS_CODE", i) != '-1'){
					if(!(GridObj.GetCellValue("PROGRESS_CODE", i) == "60" || GridObj.GetCellValue("PROGRESS_CODE", i) == "99" || GridObj.GetCellValue("PROGRESS_CODE_TXT", i).indexOf("전송오류") != -1  || GridObj.GetCellValue("PROGRESS_CODE_TXT", i).indexOf("전송대기") != -1  )){
	        			alert("역발행의 경우 거부(반려) , 발급 취소 , 전송오류 , 전송대기 건만 파기 가능합니다.");
	        			return ;    						
					} 					 
				}
				setIdx = i;
			}
		} 
  		 
  		var tax_no 	= GridObj.GetCellValue("TAX_NO", setIdx);
  		var status 	= GridObj.GetCellValue("PROGRESS_CODE", setIdx); 
  		
  		if($.trim(status)=="")status="-1";
		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&status=" + status;
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
	// 검수담당자
	function SP9113_Popup() {
		/*
		var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
		arrValue[2] = "";
		arrValue[3] = "";
		var arrDesc = new Array();
		arrDesc[0] = "아이디";
		arrDesc[1] = "이름";
		PopupCommonArr("SP9113","SP9113_getCode",arrValue,arrDesc);
*/
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}

	function  SP9113_getCode(id, name) {
		form1.purchase_id.value		= id;
		form1.purchase_name.value   = name;
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

var G_CUR_ROW;//팝업 관련해서 씀..
function getDemandGrid(code, text, addrLoc, addrLoc, igjmCd){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("PROC_DEPT"), code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("PROC_DEPT_NM"), text);
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
			document.taxListForm.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
			document.taxListForm.target="taxInvoice";
			document.taxListForm.submit();		
		}
	} else if(GridObj.getColIndexById("INV_NO") == cellInd) {
		var url = "/procure/invoice_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		param += "&inv_no="+SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		PopupGeneral(url+param, "IvDetailPop", "", "", "1000", "600");
	} else if(GridObj.getColIndexById("VENDOR_NAME") == cellInd) {
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
	    var url    = '/s_kr/admin/info/ven_bd_con.jsp';
	    var title  = "업체상세조회";
	    var param  = 'popup=Y';
	    param     += '&mode=irs_no';
	    param     += '&vendor_code=' + vendor_code;
	    popUpOpen01(url, title, '900', '700', param);
	    
	} else if(GridObj.getColIndexById("PROC_DEPT_NM") == cellInd) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		if(GridObj.cells(rowId, GridObj.getColIndexById("KTGRM")).getValue() == "02" ){
			window.open("/common/CO_009.jsp?callback=getDemandGrid&vendor_serch=Y", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}			   
	}		
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
var tmpVal = 0;
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
    	var rowIndex = GridObj.getRowIndex(rowId);
	    tmpVal =  GridObj.cells(rowId, cellInd).getValue();
	    JavaCall('t_insert',rowIndex,cellInd,"",tmpVal);
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

    if(status == "1") {
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.forms[0].from_date.value = add_Slash( document.forms[0].from_date.value );
    document.forms[0].to_date.value   = add_Slash( document.forms[0].to_date.value   );
    
//     grid_rowspan("7-7", "INV_NO");
    grid_rowspan("0-5,10-29","SEL,PROGRESS_CODE_TXT,ADD_DATE,TAX_DATE,TAX_NO,VENDOR_NAME,SUP_IRS_NO,TAX_APP_NO,SUP_AMT,TAX_AMT,TOT_AMT,TAX_DIV_TXT,PURCHARSE_NAME,KTGRM");
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function SetMinus(){
	
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

		
	var row_idx = checkedDataRow("SEL");
	
	
    var grid_array = getGridChangedRows(GridObj, "SEL");

    if(grid_array.length > 0)
    {
    	if(grid_array.length > 1){
    		alert("하나의 항목만 선택해주세요");
    		return;
    	}
    }

	if (!row_idx) {
		return;		
	}
	
 		for(var i=0;i<iRowCount;i++)
	{
		if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1")
		{
        	// 구매담당자 여부 확인
        	/*if(GridObj.GetCellValue("PURCHARSE_ID", i) != "<%=user_id%>"){
        		alert("구매담당자만 가능합니다");
        		return;
        	}*/
        	
        	if($.trim(GridObj.cells(GridObj.getRowId(i), GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
  					if(GridObj.GetCellValue("PROGRESS_CODE", i) != "-1"){
  	        			alert("[정발행] 승인건만 세금계산서 취소발행이 가능합니다.");
  	        			return ;    						
  					}						
        	}else{
  					if(GridObj.GetCellValue("PROGRESS_CODE", i) != "50"){
  	        			alert("[역발행] 승인건만 세금계산서 취소발행이 가능합니다.");
  	        			return ;    						
  					}
        	}
		}
	}
	
	if(!confirm("해당 세금계산서를 취소발행(마이너스 세금계산서)하시겠습니까?"))return;
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
   	var cols_ids = "<%=grid_col_id%>";
	var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.tax_list";
	var params = "mode=setPayCancel&cols_ids="+cols_ids;
		params += dataOutput();
    myDataProcessor = new dataProcessor(SERVLETURL, params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}
//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }  
    if( type == "purchase_id" ) {
    	document.forms[0].purchase_id.value = "";
        document.forms[0].purchase_name.value = "";
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



function MATERIAL_TYPE_Changed()
{
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1("전체", "");
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0009";
    var code = "M041";
    var value = form1.material_type.value;
    target = "MATERIAL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}
function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2("전체", "");
    var id = "SL0019";
    var code = "M042";
    var value = form1.material_ctrl_type.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";
    var value = form1.material_class1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/admin/basic/material/msp2_bd_ins_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;
    xWork.location.href = data;
}

function clearMATERIAL_CTRL_TYPE() {
    if(form1.material_ctrl_type.length > 0) {
        for(i=form1.material_ctrl_type.length-1; i>=0;  i--) {
            form1.material_ctrl_type.options[i] = null;
        }
    }
}
function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
}
function clearMATERIAL_CLASS1() {
    if(form1.material_class1.length > 0) {
        for(i=form1.material_class1.length-1; i>=0;  i--) {
            form1.material_class1.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class1.options[form1.material_class1.length] = option1;
}
function clearMATERIAL_CLASS2() {
    if(form1.material_class2.length > 0) {
        for(i=form1.material_class2.length-1; i>=0;  i--) {
            form1.material_class2.options[i] = null;
        }
    }
}
function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class2.options[form1.material_class2.length] = option1;
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.from_date.value;	//작성일자 from
	sRptData += " ~ ";
	sRptData += document.form1.to_date.value;	//작성일자 to
	sRptData += rf;
	sRptData += document.form1.tax_from_date.value;	//발행일자 from
	sRptData += " ~ ";
	sRptData += document.form1.tax_to_date.value;	//발행일자 to
	sRptData += rf;
	sRptData += document.form1.vendor_code.value;	//업체코드1
	sRptData += rf;
	sRptData += document.form1.vendor_code_name.value;	//업체코드2
	sRptData += rf;
	sRptData += document.form1.progress_code.options[document.form1.progress_code.selectedIndex].text;	//상태 
	sRptData += rf;
	sRptData += document.form1.tax_div.options[document.form1.tax_div.selectedIndex].text;	//과세구분  
	sRptData += rf;
	sRptData += document.form1.tax_app_no.value;	//승인번호 
	sRptData += rf;
	sRptData += document.form1.purchase_id.value;	//구매담당자 1 
	sRptData += rf;
	sRptData += document.form1.purchase_name.value;	//구매담당자 2
	sRptData += rf;
	sRptData += document.form1.bid_type_c.options[document.form1.bid_type_c.selectedIndex].text;	//입찰구분
	sRptData += rf;
	sRptData += document.form1.material_type.options[document.form1.material_type.selectedIndex].text;	//대분류
	sRptData += rf;
	sRptData += document.form1.material_ctrl_type.options[document.form1.material_ctrl_type.selectedIndex].text; //중분류
	sRptData += rf;
	sRptData += document.form1.material_class1.options[document.form1.material_class1.selectedIndex].text;	//소분류
	sRptData += rf;
	sRptData += document.form1.material_class2.options[document.form1.material_class2.selectedIndex].text;	//세분류
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("H_PROGRESS_CODE_TXT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("H_ADD_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_TAX_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_TAX_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_INV_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_VENDOR_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_SUP_IRS_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_TAX_APP_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_SUP_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_TAX_AMT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("H_TOT_AMT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("H_TAX_DIV_TXT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_PURCHARSE_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("H_SUBJECT",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("H_PO_CREATE_DATE",i);
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
<form name="form1" >
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
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
<input type="hidden" id="project" name="project"/>
<input type="hidden" id="approval_code" name="approval_code" value="">
<input type="hidden" id="buyer_reject_Remark" name="buyer_reject_Remark" />

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
						        <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체코드</td>
						        <td class="data_td" width="35%">
						      		<input type="text" id="vendor_code" name="vendor_code" size="15" style="ime-mode:inactive"  class="inputsubmit" maxlength="10" onkeydown='entKeyDown()'>
						        	<a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
						        	<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
						        	<input type="text" id="vendor_code_name" name="vendor_code_name" size="20" onkeydown='entKeyDown()'>
						      	</td>
						    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 상태 </td>
						      	<td class="data_td" width="35%">
						      		<select id="progress_code" name="progress_code" class="inputsubmit" >
						      			<option value="">전체</option>
						      			<option value="30">미확인</option>
						      			<option value="35">미승인</option>
						      			<option value="50">승인</option>
						      			<option value="60">거부(반려)</option>
						      			<option value="65">수신 취소요청</option>
						      			<option value="66">발신 취소요청</option>
						      			<option value="99">발급취소</option>
						      		</select>
						      	</td>
						    </tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>       
						    <tr>
						    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 과세구분 </td>
						      	<td class="data_td" width="35%">
						      		<select id="tax_div" name="tax_div" class="inputsubmit" >
						      			<option value="">전체</option>
						      			<%=LB_TAX_DIV %>
						      		</select>
						      	</td>
						      	
						  		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 승인번호 </td>
						      	<td class="data_td" width="35%">
						      		<input type="text" id="tax_app_no" name="tax_app_no" style="ime-mode:inactive"  size="20" class="inputsubmit" onkeydown='entKeyDown()'>
						      	</td>
						    </tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>       
						    <tr>
						<!--       	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 결재상태 </td> -->
						<!--       	<td class="data_td" width="35%" colspan="3"> -->
						<%--       		<select id="sign_status" name="sign_status" class="inputsubmit" > --%>
						<!--       			<option value="" >전체</option> -->
						<%--       			<%=LB_SIGN_STATUS %> --%>
						<%--       		</select> --%>
						<!--       	</td>     -->
						   	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자      </td>
					      	<td class="data_td" width="35%">
					        	<b><input type="text" name="purchase_id" id="purchase_id" style="ime-mode:inactive"  value="<%=info.getSession("ID")%>" size="15" class="inputsubmit" onkeydown='entKeyDown()'>
					        	<a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
					        	<a href="javascript:doRemove('purchase_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
					        	<input type="text" name="purchase_name" id="purchase_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly onkeydown='entKeyDown()'></b>
					      	</td>       	
	  						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰구분</td>
	  						<td class="data_td" width="35%">
						      	<select id="bid_type_c" name="bid_type_c">
		  							<option value="">전체</option>
		  							<option value="D">구매입찰</option>
		  							<option value="C">공사입찰</option>
								</select>
	  						</td>
							</tr>
							
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>    
							<tr>
								<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대분류</td>
								<td class="data_td">
									<select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
										<option value="" selected="selected">전체</option>
						<%
							String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
							out.println(listbox1);
						%>
									</select>
								</td>
								<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 중분류</td>
								<td class="data_td">
									<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
										<option value=''>전체</option>
									</select>
								</td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
						    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 소분류</td>
						    	<td class="data_td">
						    		<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
						    			<option value=''>전체</option>
						    		</select>
						    	</td>
						    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 세분류</td>
						    	<td class="data_td">
						    		<select name="material_class2" id="material_class2" class="inputsubmit">
						    			<option value=''>전체</option>
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
	    	  		<TD><script language="javascript">btn("javascript:doSelect();"			,"조 회")</script></TD>
	    	  		<TD><script language="javascript">btn("javascript:clipPrint()"			,"출 력")</script></TD>
	    	  		<TD><script language="javascript">btn("javascript:doModify();"			,"파 기")</script></TD>	    	  		
	    	  		<TD><script language="javascript">btn("javascript:SetProgress('P');"	,"지급결의")</script></TD>
	    	  		<TD><script language="javascript">btn("javascript:setKtgrm();"			,"대금지급구분 변경")</script></TD>	    	  		
	    	  		<TD><script language="javascript">btn("javascript:SetMinus();"			,"세금계산서 취소발행")</script></TD>
<%-- 	    	  			<TD><script language="javascript">btn("javascript:doPrint();","인쇄")</script></TD>   	  			 --%>
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
<iframe name="xWork" width="0" height="0" border="0"></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_001" grid_obj="GridObj" grid_box="gridbox" row_mergeable="true"/> --%>

<s:footer/>
</body>
</html>


