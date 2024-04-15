<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String house_code      = info.getSession("HOUSE_CODE");
	String toDays          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	String toDays_1        = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1));
	String user_name   	   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	
/*     Object[] obj = {info.getSession("COMPANY_CODE")};
    SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getSmartBillEmail", obj);
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    String smartbill_email = "";
    
    if(wf.getRowCount() > 0)
    {
		smartbill_email = wf.getValue("SMARTBILL_EMAIL", 0);
    } */
%>


<%
    //********검수요청시 기성등록정보 사용여부 시작**********************************************
    //기성정보를 사용하지 않을 경우 : 검수요청은 수주수량을 기준으로 잔량에서 검수요청을 진행한다.
    //Configuration Sepoa_conf = new Configuration();
    boolean ivso_use_flag = false;
    try {
//     	Boolean.parseBoolean(CommonUtil.getConfig("sepoa.ivso.use."+info.getSession("HOUSE_CODE")));
//     	ivso_use_flag = Sepoa_conf.getBoolean("sepoa.ivso.use."+info.getSession("HOUSE_CODE")); //기성정보 사용여부
    	ivso_use_flag = Boolean.parseBoolean(CommonUtil.getConfig("sepoa.ivso.use."+info.getSession("HOUSE_CODE")));
    } catch (Exception e) {
    	ivso_use_flag = false;
    }
    //********검수요청시 기성등록정보 사용여부 종료**********************************************
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<%-- 	var	servletUrl = "<%=getSepoaServletPath("supply.ordering.ivdp.iv1_bd_lis2")%>"; --%>
	var mode;
	var checked_count = 0;

	var IDX_SEL				;
	var IDX_PO_NO			;
	var IDX_SUBJECT			;
	var IDX_PO_CREATE_DATE	;
	var IDX_PO_TTL_AMT		;
	var IDX_ADD_USER_ID		;
	var IDX_IV_NO			;
	var IDX_DP_TEXT			;
	var IDX_DP_PAY_TERMS	;
	var IDX_IV_SEQ			;
	var IDX_DP_PERCENT		;
	var IDX_DP_AMT			;
	var IDX_PAY_FLAG		;
	var IDX_SIGN_STATUS		;
	var IDX_SIGN_REMARK		;
	var IDX_INV_NO			;
	var IDX_EXEC_NO			;
	var IDX_DP_SEQ			;
	var IDX_DP_CODE			;
	var IDX_DP_DIV			;
	var IDX_PO_SEQ			;
	var IDX_TOT_INV_AMT		;
	var IDX_REJECT_AMT		;
	var chkrow;

	function doSelect()
	{
		var f0 = document.forms[0];
		
		var po_from_date = del_Slash(f0.po_from_date.value);
		var po_to_date = del_Slash(f0.po_to_date.value);
		
		if(f0.po_from_date.value != "") {
			if(!checkDateCommon(po_from_date)) {
				alert(" 수주일자(From)를 확인 하세요 ");
				f0.po_from_date.focus();
				return;
			}
		}

		if(f0.po_to_date.value != "") {
			if(!checkDateCommon(po_to_date)) {
				alert(" 수주일자(To)를 확인 하세요 ");
				f0.po_to_date.focus();
				return;
			}
		}
		
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getInvoiceTargetList&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "../servlets/sepoa.svl.procure.invoice_target_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var f0              = document.forms[0];
		var row             = GridObj.GetRowCount();
		var po_no           = "";
		var shipper         = "";
		var sign_flag       = "";

        for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	   }

		if(msg1 == "doData"){
// 			var mode = GD_GetParam(GridObj,"0");
// 			if(mode == "doCancel" ){
// 				alert("검수요청이 철회 되었습니다.");
// 				doSelect();
// 			}	
		}
		if(msg1 == "doQuery"){
			// 데이터 Row Merge
			//GridObj.SetGroupMerge("PO_NO,SUBJECT,PO_CREATE_DATE,PO_TTL_AMT,ADD_USER_ID");
		}
		if(msg1 == "t_imagetext")
		{
			if(msg3==IDX_PO_NO) {
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
			    window.open("/s_kr/ordering/po/po3_pp_dis1.jsp"+"?po_no="+po_no,"newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			} else if(msg3==IDX_SIGN_REMARK){
				window.open("iv1_pp_dis2.jsp"+"?sign_remark="+msg4,"newWin","width=550,height=270,resizable=NO, scrollbars=YES, status=yes, top=0, left=0");
			}else if(msg3==IDX_INV_NO){
				po_no  = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
				inv_no = GD_GetCellValueIndex(GridObj,msg2,IDX_INV_NO);
				if(inv_no==""){
					alert("검수서번호가 없습니다.");
					return;
				}
				window.open("/kr/order/ivdp/inv1_bd_dis1.jsp"+"?inv_no="+msg4+"&po_no="+po_no,"newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			}
		}
	}
	
	//************************************************** Date Set *************************************
	function valid_from_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.po_from_date.value=year+month+day;
	}

	function valid_to_date(year,month,day,week) {
	    var f0 = document.forms[0];
	    f0.po_to_date.value=year+month+day;
	}
	
	function doInv(mode)
	{
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var last_flag 		= "";
		IDX_SEL				= GridObj.GetColHDIndex("SEL");
		IDX_PO_NO			= GridObj.GetColHDIndex("PO_NO");
		for(var i=0;i<iRowCount;i++)
		{
			if(GridObj.GetCellValue("SEL", i) == "1")
			{
				iCheckedCount++;
				iSelectedRow = i;
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
    	
    	// 등록된 기성정보를 활용할 경우 최종 검수요청여부 관리
    	// 기성정보를 활용하지 않을 경우 검수요청시 수주금액과 [검수누적금액+검수요청금액]이 같은 경우 Y로 세팅하도록 한다.
		<%if (ivso_use_flag) {%>
			if(iRowCount==iSelectedRow+1) last_flag='Y';
		<%} else {%>
			last_flag='';
		<%}%>

		var po_no 			= GridObj.GetCellValue("PO_NO", iSelectedRow);
		var po_seq 			= GridObj.GetCellValue("PO_SEQ", iSelectedRow);
		var inv_no 			= GridObj.GetCellValue("INV_NO", iSelectedRow);
		var sign_status 	= GridObj.GetCellValue("SIGN_STATUS", iSelectedRow);
		var add_user_id 	= GridObj.GetCellValue("ADD_USER_ID", iSelectedRow);
		var exec_no 		= GridObj.GetCellValue("EXEC_NO", iSelectedRow);
		var dp_seq 			= GridObj.GetCellValue("DP_SEQ", iSelectedRow);
		var dp_code 		= GridObj.GetCellValue("DP_CODE", iSelectedRow);
		//var dp_div 			= GridObj.GetCellValue("DP_DIV", iSelectedRow);
		var dp_div 			= "I";
		var po_ttl_amt		= GridObj.GetCellValue("PO_TTL_AMT", iSelectedRow); // 발주수량
		var inv_ttl_amt		= GridObj.GetCellValue("DP_AMT", iSelectedRow); // 검수요청수량
		var reject_amt		= GridObj.GetCellValue("REJECT_AMT", iSelectedRow); // 검수반려수량
		var complete_mark 	= GridObj.GetCellValue("COMPLETE_MARK", iSelectedRow);
		var gr_amt			= GridObj.GetCellValue("TOT_INV_AMT", iSelectedRow);
		<%if (ivso_use_flag) {%>
			if(sign_status == 'P') {
				alert("이미 요청중 입니다.");
				return;
			} else if(sign_status == 'E1') {
				alert("이미 검수가 완료되었습니다.");
				return;
			}
		<%} else {%>
			// 2011.09.19 HMCHOI
			// 수주금액과 검수진행중이거나 검수완료된 금액의 합이 같은 경우 검수요청 안됨.
// 			alert(complete_mark + "\n" + po_ttl_amt + "\n" + inv_ttl_amt + "\n" + reject_amt);
			if( complete_mark != 'Y' && (eval(po_ttl_amt) <= eval(inv_ttl_amt)-eval(reject_amt))) {
				alert("수주한 금액과 이미 검수 요청한 금액이 동일합니다.\n\n더이상 검수 요청할 수 없습니다.");
				return;
			}
		<%}%>
		
		if(sign_status == 'R' && mode == 'insert'){
			alert("반려된 건은 수정만 가능합니다.");
			return;
		}else if(sign_status == '' && mode == 'update'){
			alert("반려된 건만 수정이 가능합니다.");
			return;
		}
		if(complete_mark == 'Y'){
			alert("이미 검수가 완료되었습니다.");
			return;
		}
		if(complete_mark == 'YY'){
			alert("'발주중도종결' 되어 검수요청 할 수 없습니다.");
			return;
		}
		// 2011.09.19 HMCHOI : 검수요청인 경우에는 검수요청 신규추가
		if (mode == "insert") inv_no = "";
		//var t_url 	 = "iv1_bd_ins1.jsp?po_no="+po_no+"&iv_no="+iv_no+"&sign_status="+sign_status+"&inv_no="+inv_no+"&add_user_id="+add_user_id;
		var t_url 	 = "invoice_insert.jsp?po_no="+po_no+"&po_seq="+po_seq+"&sign_status="+sign_status+"&inv_no="+inv_no+"&add_user_id="+add_user_id+"&exec_no="+exec_no+"&dp_seq="+dp_seq+"&dp_code="+dp_code+"&gr_amt="+gr_amt+"&last_flag="+last_flag+"&dp_div="+dp_div;
		location.href = t_url;
	}
	
	function doSmartBill()
	{
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var last_flag = "";

		for(var i=0;i<iRowCount;i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "true")
			{
				iCheckedCount++;
				iSelectedRow = i;
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

		if(iRowCount==iSelectedRow+1) last_flag = 'Y';

		var po_no 		= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_PO_NO);
		var po_seq 		= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_PO_SEQ);
		var inv_no 		= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_INV_NO);
		var sign_status = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_SIGN_STATUS);
		var add_user_id = GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_ADD_USER_ID);
		var exec_no 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_EXEC_NO);
		var dp_seq 		= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_DP_SEQ);
		var dp_code 	= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_DP_CODE);
		var dp_div 		= GD_GetCellValueIndex(GridObj,iSelectedRow, IDX_DP_DIV);
		var confirm_date1 = LRTrim(Sepoa.GetCellValue("CONFIRM_DATE1", iSelectedRow));
		var dp_amt 		= add_comma(LRTrim(Sepoa.GetCellValue("DP_AMT", iSelectedRow)), 2);
		var subject 	= LRTrim(Sepoa.GetCellValue("SUBJECT", iSelectedRow));

		if(sign_status != "E1")
		{
			alert("검수 승인된 내역만 처리 가능 합니다.");
			return;
		}

		if(confirm_date1 == "")
		{
			alert("검수 승인된 내역만 처리 가능 합니다.");
			return;
		}

		var smartbill_email = LRTrim(document.form1.smartbill_email.value);
		
		if(!isMail(smartbill_email))
		{
			alert("스마트빌 Email 이 올바르지 않습니다.");
			document.form1.smartbill_email.focus();
			return;
		}

		if(! confirm("세금계산서를 발행하시겠습니까? 발행금액은 " + dp_amt + " 원 입니다."))
		{
			return;
		}
		
		var left = 100;
		var top = 100;
		var width = 540;
		var height = 250;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url_1 = "/s_kr/ordering/ivdp/notice_smartbill_info.jsp?po_no=" + po_no + 
        												"&subject=" + urlEncode(subject) + 
												        "&dp_amt=" + encodeURI(dp_amt) +
												        "&smartbill_email=" + encodeURI(smartbill_email);

		var doc = window.open( url_1, 'smartbill', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		
		document.smartbillform.po_no.value=po_no;
		document.smartbillform.subject.value=encodeURI(subject);
		document.smartbillform.dp_amt.value=encodeURI(dp_amt);
		document.smartbillform.smartbill_email.value=encodeURI(smartbill_email);
		
		document.smartbillform.action = "/s_kr/ordering/ivdp/issue_smartbill.jsp";
		document.smartbillform.submit();
		/*
		var url = "/s_kr/ordering/ivdp/issue_smartbill.jsp?po_no=" + po_no + 
        "&subject=" + encodeURI(subject) + 
        "&dp_amt=" + encodeURI(dp_amt) +
        "&smartbill_email=" + encodeURI(smartbill_email);
		getDescframe.location.href = url;
		*/
	}

	//담당자
	function SP0071_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function  SP0071_getCode(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {

		form1.ctrl_code.value = ls_ctrl_code;
		form1.ctrl_name.value = ls_ctrl_name;
		form1.ctrl_person_id.value = ls_ctrl_person_id;
		form1.ctrl_person_name.value = ls_ctrl_person_name;
	}
	// 검수요청한 건에 대해서 '검수요청철회' 버튼 추가 요청
	function doCancel(){
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var iCheckedCount 	= 0;
		var iSelectedRow  	= -1;
		var last_flag = "";
		
		for(var i=0;i<iRowCount;i++)
		{
			if(GridObj.GetCellValue("SEL", i) == "1")
			{
				iCheckedCount++;
				iSelectedRow = i;
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
    	
    	// 등록된 기성정보를 활용할 경우 최종 검수요청여부 관리
    	// 기성정보를 활용하지 않을 경우 검수요청시 수주금액과 [검수누적금액+검수요청금액]이 같은 경우 Y로 세팅하도록 한다.
		<%if (ivso_use_flag) {%>
			if(iRowCount==iSelectedRow+1) last_flag='Y';
		<%} else {%>
			last_flag='';
		<%}%>   	
		
		var po_no 			= GridObj.GetCellValue("PO_NO", iSelectedRow);
		var po_seq 			= GridObj.GetCellValue("PO_SEQ", iSelectedRow);
		var inv_no 			= GridObj.GetCellValue("INV_NO", iSelectedRow);
		var sign_status 	= GridObj.GetCellValue("SIGN_STATUS", iSelectedRow);
		var add_user_id 	= GridObj.GetCellValue("ADD_USER_ID", iSelectedRow);
		var exec_no 		= GridObj.GetCellValue("EXEC_NO", iSelectedRow);
		var dp_seq 			= GridObj.GetCellValue("DP_SEQ", iSelectedRow);
		var dp_code 		= GridObj.GetCellValue("DP_CODE", iSelectedRow);
		var dp_div 			= GridObj.GetCellValue("DP_DIV", iSelectedRow);
		var po_ttl_amt		= GridObj.GetCellValue("PO_TTL_AMT", iSelectedRow); // 발주수량
		var inv_ttl_amt		= GridObj.GetCellValue("DP_AMT", iSelectedRow); // 검수요청수량
		var reject_amt		= GridObj.GetCellValue("REJECT_AMT", iSelectedRow); // 검수반려수량
		var complete_mark 	= GridObj.GetCellValue("COMPLETE_MARK", iSelectedRow);
		var gr_amt			= GridObj.GetCellValue("TOT_INV_AMT", iSelectedRow);		
		
		if(sign_status == 'E1') {
			alert("이미 검수가 완료되었습니다.");
			return;
		}else if (sign_status != 'P'){
			alert("요청건만 철회 가능합니다");
			return;
		}				
		if(sign_status == 'R' && mode == 'insert'){
			alert("반려된 건은 수정만 가능합니다.");
			return;
		}else if(sign_status == '' && mode == 'update'){
			alert("반려된 건만 수정이 가능합니다.");
			return;
		}
		if(complete_mark == 'Y'){
			alert("이미 검수가 완료되었습니다.");
			return;
		}
		if(complete_mark == 'YY'){
			alert("'발주중도종결' 되어 검수요청 할 수 없습니다.");
			return;
		}
		
		if(confirm("검수요청철회 하시겠습니까?")){
			$("#inv_no").val(inv_no);
			var grid_array = getGridChangedRows(GridObj, "SEL");
			var cols_ids = "<%=grid_col_id%>";
			var params;
			params = "?mode=doCancel";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			myDataProcessor = new dataProcessor("../servlets/sepoa.svl.procure.invoice_target_list"+params);
			//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
			sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);			
		}
	}
	
	var GridObj = null;
	var MenuObj = null;
	var myDataProcessor = null;

		function setGridDraw()
	    {
	    	GridObj_setGridDraw();
	    	GridObj.setSizes();
	    	doSelect();
	    }
	// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
	// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
	function doOnRowSelected(rowId,cellInd)
	{
	    //alert(GridObj.cells(rowId, cellInd).getValue());
	<%--    
			GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

	    
	    if("undefined" != typeof JavaCall) {
	    	type = "";
	    	if(GridObj.getColType(cellInd) == 'img') {
	    		type = "t_imagetext";
	    	}
	    	JavaCall(type, "", cellInd);
	    }
	--%> 
		var header_name = GridObj.getColumnId(cellInd);
		var po_no = SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		var inv_no = SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		
		
		if(header_name == "INV_NO") {
			if(inv_no == ""){
				return;
			}else{
				var url = "../procure/invoice_detail.jsp";
				var param = "";
				param += "?popup_flag_header=true";
				param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
				param += "&inv_no="+SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
				PopupGeneral(url+param, "IvDetailPop", "", "", "1000", "600");
			}
		}
		
		if(header_name=="PO_NO") {
			var po_no	= LRTrim(GridObj.cells(rowId, GridObj.GetColHDIndex("PO_NO")).getValue());   //GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
		    //window.open("/kr/order/bpo/po3_pp_dis1.jsp"+"?po_no="+po_no ,"newWin","width=1024,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
			var url              = "/kr/order/bpo/po3_pp_dis1.jsp";
			var title            = '발주화면상세조회';
			var param = "";
			param = param + "po_no=" + po_no;

			if (po_no != "") {
			    popUpOpen01(url, title, '1024', '600', param);
			}
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
	    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
	    if(status == "0") alert(msg);
	    
// 	    document.form1.po_from_date.value = add_Slash( document.form1.po_from_date.value );
// 	    document.form1.po_to_date.value   = add_Slash( document.form1.po_to_date.value   );
	    
	    if("undefined" != typeof JavaCall) {
	    	JavaCall("doQuery");
	    } 
	    return true;
	}
</script>

</head>
<body onload="javascript:setGridDraw();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<form name="form1" >
<input type="hidden" name="kind" id="kind">
<input type="hidden" name="inv_no" id="inv_no">
<input type="hidden" name=vendor_code id="vendor_code" value="<%=company_code%>">

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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주일자</td>
      <td class="data_td" width="35%">
		<s:calendar id_from="po_from_date" default_from="<%=toDays_1%>" default_to="<%=toDays%>" id_to="po_to_date" format="%Y/%m/%d" />
      </td>
<!--       <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행상태</td> -->
<!--       <td class="data_td" width="35%"> -->
<%--         <select name="sign_status" id="sign_status" class="inputsubmit"> --%>
<!--           <option value="">:::전체:::</option> -->
<!--           <option value="W">대기</option> -->
<!--           <option value="P">요청</option> -->
<!--           <option value="R">반려</option> -->
<!--           <option value="E">완료</option> -->
<%--         </select> --%>
<!--       </td> -->
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 완료여부</td>
      <td class="data_td" width="35%">
        <select name="sign_status" id="sign_status" class="inputsubmit">
          <option value="">:::전체:::</option>
          <option value="Y">완료</option>
          <option value="N">미완료</option>
          <option value="YY">중도종결</option>
        </select>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr style="display:none;">
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
      <td class="data_td" width="35%">
      	<b><input type="text" name="ctrl_person_id" id="ctrl_person_id" size="10" class="inputsubmit" readOnly >
        <a href="javascript:SP0071_Popup();"><img src="image" align="absmiddle" border="0"></a>
        <input type="text" name="ctrl_person_name" id="ctrl_person_name" size="25" class="input_data2" readOnly ></b>
        <input type="hidden" name="ctrl_name" id="ctrl_name" size="25" class="input_data0" readOnly >
        <input type="hidden" name="ctrl_code" id="ctrl_code" size="5" maxlength="5" class="inputsubmit" readOnly >
      </td>
    </tr>
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주명</td>
      <td class="data_td" colspan="3">
        <input type="text" name="subject" id="subject" size="40" class="inputsubmit">
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
	    	  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
	    	  			<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
	    	  			<TD><script language="javascript">btn("javascript:doInv('insert')","검수요청")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:doCancel()","검수요청철회")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

</form>
<!-- 스마트빌 연동 FORM -->
<!-- <form name="smartbillform" method="post" target="getDescframe">
	<input type="hidden" name="po_no" value>
	<input type="hidden" name="subject" value>
	<input type="hidden" name="dp_amt" value>
	<input type="hidden" name="smartbill_email" value>
</form> -->
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="IV_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


