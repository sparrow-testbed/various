<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,30);
	String to_date = to_day;

	String cont_date = SepoaString.getDateSlashFormat(to_date);
	

	Vector multilang_id = new Vector();
// 	multilang_id.addElement("CT_007_1");
	multilang_id.addElement("AR_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);

	Config conf = new Configuration();
	String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	
	String house_code		= info.getSession("HOUSE_CODE");
	String sign_person_id   = info.getSession("ID");
	String sign_person_name = info.getSession("NAME_LOC");
	String dept = info.getSession("DEPARTMENT");
	
	String rfq_number	= JSPUtil.nullToEmpty(request.getParameter("contract_number")).trim();
// 	String rfq_count	= JSPUtil.nullToEmpty(request.getParameter("contract_count")).trim();
	String seller_code	= JSPUtil.nullToEmpty(request.getParameter("cont_seller_code")).trim();
	String seller_name	= JSPUtil.nullToEmpty(request.getParameter("cont_seller_name")).trim();
	String bd_amt		= JSPUtil.nullToEmpty(request.getParameter("contract_amt")).trim();
	String exec_no		= JSPUtil.nullToEmpty(request.getParameter("exec_no")).trim();
	
	String rfq_type			 = JSPUtil.nullToEmpty(request.getParameter("rfq_type")).trim();
	String bd_kind      	 = JSPUtil.nullToEmpty(request.getParameter("bd_kind")).trim();
	String ctrl_person_id    = JSPUtil.nullToEmpty(request.getParameter("ctrl_person_id")).trim();
	String ctrl_person_name  = JSPUtil.nullToEmpty(request.getParameter("ctrl_person_name")).trim();
	String pr_no 		     = JSPUtil.nullToEmpty(request.getParameter("pr_no")).trim();
	String cont_type1_text 	 = JSPUtil.nullToEmpty(request.getParameter("cont_type1_text")).trim();   //입찰방법
	String cont_type2_text 	 = JSPUtil.nullToEmpty(request.getParameter("cont_type2_text")).trim();   //낙찰방법
	String x_purchase_qty 	 = JSPUtil.nullToRef(request.getParameter("x_purchase_qty"), "1").trim(); //구매수량
	String delv_place 	     = JSPUtil.nullToEmpty(request.getParameter("delv_place")).trim();        //납품장소
	
	//수작업 계약
	String flag			= JSPUtil.nullToEmpty(request.getParameter("flag")).trim();
	String pr_number	= JSPUtil.nullToEmpty(request.getParameter("pr_number")).trim();
	String pr_seq		= JSPUtil.nullToEmpty(request.getParameter("pr_seq")).trim();
	
	// Dthmlx Grid 전역변수들..
// 	String screen_id = "CT_007_1";
	String screen_id = "AR_001_1";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	if(ctrl_person_id.equals("")){
		ctrl_person_id 	 = sign_person_id;
		ctrl_person_name = sign_person_name;
	}
	Map<String, String> params = new HashMap<String, String>();
	params.put("exec_no"	, exec_no);
	params.put("house_code"	, info.getSession("HOUSE_CODE"));
	Object[] obj = { params };
	SepoaOut value = ServiceConnector.doService(info, "p1062", "CONNECTION","getEXDTInfo", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	String subject 				= "";
	String contract_from_date 	= "";
	String contract_to_date	 	= "";
	String dely_to_location 	= "";
	String delay_remark 		= "";
	String warranty_year 		= "";
	String warranty_month 		= "";
	String mengel_deposit		= "";
	String mengel_percent		= "";
	String contract_deposit		= "";
	String contract_percent		= "";
	String contract_method		= "";
	String rfq_no				= "";
	String rfq_count			= "";
	String po_type				= "";
	String tax_div				= "";
	String cont_type			= "";
	String cont_type1			= "";
	String prom_crit			= "";
			
	SepoaOut 		value1 		= null;
	SepoaFormater 	wf1 		= null;
	
	
	if(wf.getRowCount() > 0){
		subject = wf.getValue("SUBJECT", 0);
		contract_from_date 	= wf.getValue("CONTRACT_FROM_DATE", 0);
		contract_to_date 	= wf.getValue("CONTRACT_TO_DATE", 0);
		dely_to_location 	= wf.getValue("DELY_TO_LOCATION", 0);
		delay_remark 		= wf.getValue("DELAY_REMARK", 0);
		warranty_month 		= wf.getValue("WARRANTY_MONTH", 0);
		rfq_no 				= wf.getValue("RFQ_NO", 0);
		rfq_count 			= wf.getValue("RFQ_COUNT", 0);
		po_type 			= wf.getValue("PO_TYPE", 0);
		tax_div 			= wf.getValue("TAX_DIV", 0);
		cont_type 			= wf.getValue("CONT_TYPE", 0);
		cont_type1			= wf.getValue("CONT_TYPE1", 0);
		prom_crit			= wf.getValue("PROM_CRIT", 0);
		
		
		
		if(!"".equals(warranty_month)){
			warranty_year 	= Integer.parseInt(warranty_month) / 12 + "";
			warranty_month 	= Integer.parseInt(warranty_month) % 12 + "";
		}
		
		value1 = ServiceConnector.doService(info, "p1062", "CONNECTION","getCNDPInfo", obj);
		wf1 = new SepoaFormater(value1.result[0]);
		
		if(wf1.getRowCount() > 0){
			mengel_deposit		= wf1.getValue("MENGEL_DEPOSIT", 0);
			mengel_percent		= wf1.getValue("MENGEL_PERCENT", 0);
			contract_deposit	= wf1.getValue("CONTRACT_DEPOSIT", 0);
			contract_percent	= wf1.getValue("CONTRACT_PERCENT", 0);
			contract_method		= wf1.getValue("CONTRACT_METHOD", 0);
		}
	}
	
	
%>


<%
	String ACCOUNT_CODE = "";
	String ACCOUNT_NAME = "";
 %>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";
	
	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,금액,단가,금액,단가,금액,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
    	GridObj.setSizes();
    	GridObj.setColumnExcellType( GridObj.getColIndexById( LRTrim( "QTY        " ) ), "ron" );
    	GridObj.setColumnExcellType( GridObj.getColIndexById( LRTrim( "UNIT_PRICE " ) ), "ron" );
    	GridObj.setColumnExcellType( GridObj.getColIndexById( LRTrim( "RD_DATE    " ) ), "ro" );
    }

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		
		if(status == "false") alert(msg);
		

		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
			GridObj.enableSmartRendering(true);
			GridObj.selectRowById(GridObj.getRowId(i), false, true);
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
		}
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
<%--		var item_amt = 0; --%>  //동현삭제
<%--		for(var i=0; i<grid_array.length;i++) {--%>
<%--			item_amt += parseInt(LRTrim(GridObj.cells(i+1, GridObj.getColIndexById("ITEM_AMT")).getValue()+""));--%>
<%--		}--%>
<%--		--%>
<%--		var item_amt_comma = add_comma(item_amt, "0");--%>
		if("<%=flag%>" == "PR_NUMBER"){
				for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("UNIT_PRICE")).setValue(0);
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_AMT")).setValue(0);
				}
			}
		
		
		/*
		if("<%=rfq_type%>" == "RF") {
			document.forms[0].cont_process_flag.value = "FU";
		} else if("<%=rfq_type%>" == "BD") {
			document.forms[0].cont_process_flag.value = "BD";
		}
		*/
		//document.form.cont_amt.value = item_amt_comma;
		
		/*
		if("<%=rfq_type%>" == "RF") {
			document.form.amt_gubun.value    = "T";
			document.form.amt_gubun.disabled = false;//select
		}
		*/
		
		/*
		if("<%=rfq_type%>" == "RF") {
			document.form.cont_process_flag.value = "FU";
		} else {
			if("<%=flag%>" != "PR_NUMBER"){
				document.form.cont_process_flag.value = "BD";
			}
		}
		*/
		
		if("<%=bd_amt %>" != ""){ 
			document.form.cont_amt.value = add_comma("<%=bd_amt %>", 0); //원래는 이부분만 있었던것 else if문은 동현 추가
		}
		else{
			getIvnAmtSum(); //윗부분에 계약금액 계산하는 부분을 빼고 함수를 사용 했습니다.
		}
		
		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
			GridObj.enableSmartRendering(true);
	    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
	    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
	    	
// 	    	document.form.subject.value = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ANN_ITEM")).getValue();

		}
		
		// 계약보증금 조회시 콤마 추가
		document.getElementById('cont_assure_amt').value = add_comma('<%=contract_deposit%>',0);
		
		document.getElementById('cont_price').value = add_comma(document.getElementById('cont_price').value, 0);
		
  		return true;
    }
    
    function fncDeCode(param){
        var sb  = '';
        var pos = 0;
        var flg = true;

        if(param != null){
            if(param.length>1){
                while(flg){
                    var sLen = param.substring(pos,++pos);
                    var nLen = 0;

                    try{
                        nLen = parseInt(sLen);
                    }
                    catch(e){
                        nLen = 0;
                    }

                    var code = '';

                    if((pos+nLen)>param.length){
                    	code = param.substring(pos);
                    }
                    else{
                    	code = param.substring(pos,(pos+nLen));
                    }

                    pos  += nLen;
                    sb += String.fromCharCode(code);

                    if(pos >= param.length){
                    	flg = false;
                    }
                }
            }
        }

        return sb;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);
    	var rowIndex   = GridObj.getRowIndex(rowId);
    	
    	if( cellInd == GridObj.getColIndexById("GW_STATUS") || cellInd == GridObj.getColIndexById("GW_INF_NO") ) {
    		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS");
    		var gwInfNoColIndex  = GridObj.getColIndexById("GW_INF_NO");
    		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
    		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
    		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
    		var gwInfNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwInfNoColIndex);
    		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
    		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
    		var x                = 900;
    		var y                = window.screen.height - 90;
    		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
    		
    		if( gwInfNoColValue != null && gwInfNoColValue != "" && "O" == gwStatusColValue ){
    			$.post(
    				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
    				{
    					mode  : "gwPop",
    					prNo  : prNoValue,
    					prSeq : prSeqValue,
    					type  : "P"
    				},
    				function(arg){
    					var result     = eval('(' + arg + ')');
    					var resultCode = result.code;
    					var gwPopUrl   = null;
    					
    					if(resultCode == "200"){
    						gwPopUrl = result.gwPopUrl;
    						gwPopUrl = fncDeCode(gwPopUrl);
    						window.open(gwPopUrl, "gwPop", status);
    					}
    					else{
    						alert(result.message);
    					}
    				}
    			);
    		}		
    		
    	} else if( cellInd == GridObj.getColIndexById("GW_STATUS2") || cellInd == GridObj.getColIndexById("GW_INF_NO2")) {
    		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS2");
    		var gwInfNoColIndex  = GridObj.getColIndexById("GW_INF_NO2");
    		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
    		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
    		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
    		var gwInfNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwInfNoColIndex);
    		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
    		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
    		var x                = 900;
    		var y                = window.screen.height - 90;
    		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
    		
    		if( gwInfNoColValue != null && gwInfNoColValue != "" && "O" == gwStatusColValue ){
    			$.post(
    				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
    				{
    					mode  : "gwPop",
    					prNo  : prNoValue,
    					prSeq : prSeqValue,
    					type  : "G"
    				},
    				function(arg){
    					var result     = eval('(' + arg + ')');
    					var resultCode = result.code;
    					var gwPopUrl   = null;
    					
    					if(resultCode == "200"){
    						gwPopUrl = result.gwPopUrl;
    						gwPopUrl = fncDeCode(gwPopUrl);
    						window.open(gwPopUrl, "gwPop", status);
    					}
    					else{
    						alert(result.message);
    					}
    				}
    			);
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
			
		} else if(stage==2) {
	    	var header_name = GridObj.getColumnId(cellInd);
	    	
	    	if( header_name == "SETTLE_QTY" || header_name == "UNIT_PRICE")
			{
				var	rfq_qty    = GridObj.cells(rowId, GridObj.getColIndexById("SETTLE_QTY")).getValue();
				var	unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
				
				var item_amt     = floor_number(eval(rfq_qty) * eval(unit_price), 2);
				var supply_amt   = item_amt;
				var supertax_amt = 0;
				
				GridObj.cells(rowId, GridObj.getColIndexById("ITEM_AMT")).setValue(item_amt);
				GridObj.cells(rowId, GridObj.getColIndexById("SUPPLY_AMT")).setValue(supply_amt);
				GridObj.cells(rowId, GridObj.getColIndexById("SUPERTAX_AMT")).setValue(supertax_amt);
			
				getIvnAmtSum();
			}
			
			return true;
		}
		return false;
    }
    
    // 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택해 주세요.");
		return false;
	}
	
    // 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		
		var cont_no = obj.getAttribute("CONT_NO");
		
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {

			alert("[계약번호 : "+ cont_no + "] "+ messsage);
			location.href = "contract_create_list_update.jsp?cont_no="+cont_no;
			
		} else {
			alert(messsage);
		}

		return false;
	}
	
	function doSelect11() {
		var flag		= "<%=flag%>";
		var pr_number	= "<%=pr_number%>";
		var pr_seq		= "<%=pr_seq%>";
		var rfq_number	= "<%=rfq_number%>";
		var rfq_count	= "<%=rfq_count%>";
		var seller_code	= "<%=seller_code%>";
		var rfq_type	= "<%=rfq_type%>";
		var bd_kind		= "<%=bd_kind%>";
		var pr_no		= "<%=pr_no%>";
		
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_ins1";
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getEXDTInfo";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		

// 		if(flag == "PR_NUMBER"){ 
// 			var param  = "&pr_number="		+ encodeUrl(pr_number);
<%-- 			var grid_col_id = "<%=grid_col_id%>"; --%>
<%-- 			SERVLETURL  = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list?mode=prquery&grid_col_id="+grid_col_id + param; --%>
// 			GridObj.post(SERVLETURL);
// 			GridObj.clearAll(false);
// 		} else if(flag == "PR_NUMBER_MT"){ 
// 			var param   = "&pr_number="	+ encodeUrl(pr_number);
// 			    param  += "&pr_seq="	+ encodeUrl(pr_seq);
			
<%-- 			var grid_col_id = "<%=grid_col_id%>"; --%>
<%-- 			SERVLETURL  = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list?mode=prmtquery&grid_col_id="+grid_col_id + param; --%>
// 			GridObj.post(SERVLETURL);
// 			GridObj.clearAll(false);
// 		}else {
// 			var param  = "&rfq_number="		+ encodeUrl(rfq_number);
// 			    param += "&rfq_count="		+ encodeUrl(rfq_count);
// 			    param += "&seller_code="	+ encodeUrl(seller_code);
// 			    param += "&rfq_type="		+ encodeUrl(rfq_type);
// 			    param += "&bd_kind="		+ encodeUrl(bd_kind);
// 			    param += "&pr_no="		+ encodeUrl(pr_no);
			
<%-- 			var grid_col_id = "<%=grid_col_id%>"; --%>
<%-- 			SERVLETURL  = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list?mode=squery&grid_col_id="+grid_col_id + param; --%>
// 			GridObj.post(SERVLETURL);
// 			GridObj.clearAll(false);
// 		}

	}
	
	function YearChangeMonth( fault_ins_term, fault_ins_term_mon ){
		if( fault_ins_term == "" )     fault_ins_term = 0;
		if( fault_ins_term_mon == "" ) fault_ins_term_mon = 0;
	
		var month = 0;
		    month = (parseInt(fault_ins_term) * 12) + parseInt(fault_ins_term_mon);
		
		return month;
	}
	
    function doSave() {
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var subject					= LRTrim(document.form.subject.value);//계약명
		//var cont_gubun				= LRTrim(document.form.cont_gubun.value);//계약구분
		var sg_type1                = LRTrim(document.form.sg_type1.value);  //소싱그룹 대분류
		var sg_type2                = LRTrim(document.form.sg_type2.value);  //소싱그룹 중분류
		var sg_type3                = LRTrim(document.form.sg_type3.value);  //소싱그룹 소분류

		//var property_yn				= LRTrim(document.form.property_yn.value);//자산등재
		
		//var account_code			= LRTrim(document.form.account_code.value);//계정코드
		//var account_name			= LRTrim(document.form.account_name.value);//계정명
		
		var seller_code				= LRTrim(document.form.seller_code.value);//업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);//업체명
		var sign_person_id			= LRTrim(document.form.sign_person_id.value);//계약담당자 id
		var sign_person_name		= LRTrim(document.form.sign_person_name.value);//계약담당자 name
		var cont_from				= LRTrim(del_Slash(document.form.cont_from.value));//계약기간 from
		var cont_to					= LRTrim(del_Slash(document.form.cont_to.value));//계약기간 to
		var cont_date				= LRTrim(del_Slash(document.form.cont_date.value));//작성일자
		var cont_add_date			= LRTrim(del_Slash(document.form.cont_add_date.value));//계약일자
		var cont_type				= LRTrim(document.form.cont_type.value);//계약종류
		var ele_cont_flag			= LRTrim(document.form.ele_cont_flag.value);//전자계약작성여부
		var assure_flag				= LRTrim(document.form.assure_flag.value);//보증구분
		//var start_start_ins_flag	= LRTrim(document.form.start_start_ins_flag.value);//선지급금
		var cont_process_flag		= LRTrim(document.form.cont_process_flag.value);//계약방법
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));//계약금액
		
		var add_tax_flag = "";
		if( document.form.add_tax_flag[0].checked == true ) add_tax_flag	= document.form.add_tax_flag[0].value;// 부가세포함여부
		if( document.form.add_tax_flag[1].checked == true ) add_tax_flag	= document.form.add_tax_flag[1].value;// 부가세포함여부
		
		var cont_assure_percent		= LRTrim(document.form.cont_assure_percent.value);//계약보증금(%)
		var cont_assure_amt			= LRTrim(del_comma(document.form.cont_assure_amt.value));//계약보증금(원)
		var fault_ins_percent		= LRTrim(document.form.fault_ins_percent.value);//하자보증금(%)
		var fault_ins_amt			= LRTrim(del_comma(document.form.fault_ins_amt.value));//하자보증금(원)
		//var pay_div_flag			= LRTrim(document.form.pay_div_flag.value);//지급구분
		var pay_div_flag            = LRTrim(document.form.pay_div_flag.value);//대금지급횟수
		

		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);//하자보증기간 (년)
		var fault_ins_term_mon 	    = LRTrim(document.form.fault_ins_term_mon.value);//하자보증기간 (월)
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		fault_ins_term = fault_ins_term = YearChangeMonth( fault_ins_term, fault_ins_term_mon );
		
		var bd_no					= LRTrim(document.form.bd_no.value);//입찰/견적서번호
		var bd_count				= LRTrim(document.form.bd_count.value);//입찰/견적서차수
		//var amt_gubun				= LRTrim(document.form.amt_gubun.value);//금액구분
		var text_number				= LRTrim(document.form.text_number.value);//문서번호
		var delay_charge			= LRTrim(del_comma(document.form.delay_charge.value));//지체상금율
		//var delv_place				= LRTrim(document.form.delv_place.value);//납품장소
		var remark					= LRTrim(document.form.remark.value);//비고
		var ctrl_demand_dept		= LRTrim(document.form.ctrl_demand_dept.value);//계약담당자부서
		//var confirm_user_id			= LRTrim(document.form.confirm_person_id.value);//검수담당자 아이디
		//var confirm_user_name		= LRTrim(document.form.confirm_person_name.value);//검수담당자 이름
		var rfq_type				= "<%=rfq_type%>";
		var pr_no		            = "<%=pr_no%>";
		var cont_type1_text		    = LRTrim(document.form.cont_type1_text.value);//입찰방법
		var cont_type2_text		    = LRTrim(document.form.cont_type2_text.value);//낙찰방법
		var x_purchase_qty          = "<%=x_purchase_qty%>"; // 구매수량
		var i_purchase_qty          = 0;
		var delv_place              = LRTrim(document.form.delv_place.value);//납품장소
		var item_type              	= LRTrim(document.form.item_type.value);//물품종류
		var rd_date					= LRTrim(del_Slash(document.form.rd_date.value));//납품기한
		var cont_total_gubun		= LRTrim(document.form.cont_total_gubun.value);//계약단가
		var cont_price				= LRTrim(del_comma(document.form.cont_price.value));//계약단가
		
		
		if( subject == "" ) {
			alert("계약명을 입력하세요.");
			document.form.subject.select();
			return;
		}
		/*
		if( cont_gubun == "" ) {
			alert("계약구분을 입력하세요.");
			return;
		}
		*/
		if( sg_type1 == "" || sg_type2 == "" || sg_type3 == "") {
			alert("계약구분을을 선택하세요.");
			return;
		}

		if( seller_code == "" ) {
			alert("업체코드를 입력하세요.");
			return;
		}
		
		if( sign_person_id == "" ) {
			alert("계약담당자를 입력하세요.");
			return;
		}
		
		if( cont_from == "" || cont_to == "" ) {
			alert("계약기간을 입력하세요.");
			document.form.cont_from.select();
			return;
		}
		
        if( !checkDate(cont_from) ) {
            alert("계약기간을 확인하세요.");
			document.form.cont_from.select();
            return;
        }
        
        if( !checkDate(cont_to) ) {
            alert("계약기간을 확인하세요.");
			document.form.cont_to.select();
            return;
        }
        
        if( cont_from > cont_to ) {
            alert("계약시작일자가 종료일자보다 클 수는 없습니다.");
			document.form.cont_from.select();
            return;
        }
       
        if( document.form.ele_cont_flag.value == "Y" && cont_add_date != "" ) {
        	alert("전자계약서작성여부가 Yes인경우에는 계약일자를 작성하실 수 없습니다.");
        	document.form.cont_add_date.value = "";
        	return;
        }
       
        if( cont_add_date != "" && cont_add_date >= cont_from ){
        	alert("계약일자가 계약기간보다 클 수 없습니다.");
        	return;
        }
        
        if( cont_add_date != "" && !checkDate(cont_add_date) ) {
        	alert("계약일자를  확인하세요.");
			document.form.cont_add_date.select();
            return;
        }
        
		if( cont_type ==  "" ) {
			alert("계약서를 선택하세요.");
			return;
		}
		
		if( assure_flag ==  "" ) {
			alert("보증구분을 선택하세요.");
			return;
		}
		
		if( cont_process_flag == "" ) {
        	alert("계약방법을 선택하세요.");
        	return;
        }
		
        if( cont_amt == "" ) {
        	alert("계약금액을 입력하세요.");
			document.form.cont_amt.select();
        	return;
        }
		/*
		if( cont_assure_amt == "" ) {
			alert("계약보증금을 입력하세요.");
			document.form.cont_assure_percent.select();
			return;
		}
		*/
		if( document.form.ele_cont_flag.value == "N" ) {
			if(document.form.cont_add_date.value == "") {
				alert("계약일자를 입력하세요.");
				document.form.cont_add_date.select();
				return;
			}
		}
		
		if( parseInt(document.form.cont_assure_percent.value) > 100 ) {
			alert("계약보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if( parseInt(document.form.fault_ins_percent.value) > 100 ) {
			alert("하자보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if( parseInt(fault_ins_term_mon) >= 12 ){
			alert("하자보증기간(개월)입력이 잘못되었습니다.");
			return;
		}
		
		if( parseInt(document.form.delay_charge.value) > 100 ) {
			alert("지체상금율은 100을 넘을 수 없습니다.");
			return;
		}

		/*
        if( cont_gubun == "X" && delv_place == "" ) {
        	alert("계약구분이 물품인경우에는 납품장소를 입력해야합니다.");
        	document.form.delv_place.focus();
        	return;
        }		
		*/		

		if(cont_total_gubun == "C" && (cont_price == "" ||cont_price == "0")){
			alert("계약단가를 입력하세요.");
			document.form.cont_price.focus();
			return;
		}
		
		if( isEmpty(item_type) ) {
			alert("물품종류를 입력하세요.");
			document.form.item_type.select();
			return;
		}
		
		if( isEmpty(rd_date) ) {
			alert("납품기한을 입력하세요.");
			document.form.rd_date.select();
			return;
		}
		
		if( isEmpty(delv_place) ) {
			alert("납품장소를 입력하세요.");
			document.form.delv_place.select();
			return;
		}
		
// 		if( isEmpty(cont_total_gubun) ) {
// 			alert("계약단가를 입력하세요.");
// 			document.form.cont_total_gubun.focus();
// 			return;
// 		}
		
// 		if( isEmpty(cont_price) ) {
// 			alert("계약단가를 입력하세요.");
// 			document.form.cont_price.select();
// 			return;
// 		}
		
		if( remark.length > 750 ) {
			alert("비고는 350글자를 넘을 수 없습니다.");
			return;
		}

		/*		
		if( text_number == "" ) {
			alert("문서번호를 입력하세요.");
			document.form.text_number.select();
			return;
		}
		*/
		
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);
    	for(var row = 0; row < rowcount; row++)
		{
			i_purchase_qty = i_purchase_qty + parseInt(GridObj.cells(grid_array[row], GridObj.getColIndexById("QTY")).getValue());			
		//	if(parseInt(GridObj.cells(grid_array[row], GridObj.getColIndexById("QTY")).getValue()) < 1)
		//	{
		//		alert("계약수량은 1이상이 되어야 합니다.");
		//		return;
		//	}
		//
		//	var unit_price = GridObj.cells(grid_array[row], GridObj.getColIndexById("UNIT_PRICE")).getValue();
		//	
		//	if( unit_price == "" || unit_price == "0"  )
		//	{
		//		alert("계약단가를 입력하세요.");
		//		return;
		//	}
		//	else
		//	{
		//		var	rfq_qty    = GridObj.cells(grid_array[row], GridObj.getColIndexById("SETTLE_QTY")).getValue();
		//		var	unit_price = GridObj.cells(grid_array[row], GridObj.getColIndexById("UNIT_PRICE")).getValue();
		//		
		//		var item_amt     = floor_number(eval(rfq_qty) * eval(unit_price), 2);
		//		var supply_amt   = item_amt;
		//		var supertax_amt = 0;
		//		
		//		GridObj.cells(grid_array[row], GridObj.getColIndexById("ITEM_AMT")).setValue(item_amt);
		//		GridObj.cells(grid_array[row], GridObj.getColIndexById("SUPPLY_AMT")).setValue(supply_amt);
		//		GridObj.cells(grid_array[row], GridObj.getColIndexById("SUPERTAX_AMT")).setValue(supertax_amt);
		//		
		//		getIvnAmtSum();
		//	}
		//
		}
		x_purchase_qty = "" + i_purchase_qty; 



        //우리은행에선 기안대기에서 넘어온 금액과 달라도 상관 없다 함니다.
        //혹시 수정필요시 이부분 주석제거 하세요.
        /*
	    var item_amt_temp = 0;
	
		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
			
			item_amt_temp += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "ITEM_AMT"));
		}
		if(item_amt_temp != del_comma(document.form.cont_amt.value)){
			alert("계약금액이 맞지 않습니다.");
			return;
		}
        */
		var param   = "&subject="				+ encodeUrl(subject);
		//	param  += "&cont_gubun="			+ encodeUrl(cont_gubun);
			param  += "&sg_type1="				+ encodeUrl(sg_type1);
			param  += "&sg_type2="				+ encodeUrl(sg_type2);
			param  += "&sg_type3="				+ encodeUrl(sg_type3);

		//	param  += "&property_yn="			+ encodeUrl(property_yn);
		//	param  += "&account_code="			+ encodeUrl(account_code);
		//	param  += "&account_name="			+ encodeUrl(account_name);
			param  += "&seller_code="			+ encodeUrl(seller_code);
			param  += "&seller_name="			+ encodeUrl(seller_name);
			param  += "&sign_person_id="		+ encodeUrl(sign_person_id);
			param  += "&sign_person_name="		+ encodeUrl(sign_person_name);
			param  += "&cont_from="				+ encodeUrl(cont_from);
			param  += "&cont_to="				+ encodeUrl(cont_to);
			param  += "&cont_date="				+ encodeUrl(cont_date);
			param  += "&cont_add_date="			+ encodeUrl(cont_add_date);
			param  += "&cont_type="				+ encodeUrl(cont_type);
			param  += "&ele_cont_flag="			+ encodeUrl(ele_cont_flag);
			param  += "&assure_flag="			+ encodeUrl(assure_flag);
		//	param  += "&start_start_ins_flag="	+ encodeUrl(start_start_ins_flag);
			param  += "&cont_process_flag="		+ encodeUrl(cont_process_flag);
			param  += "&cont_amt="				+ encodeUrl(cont_amt);
			param  += "&add_tax_flag="			+ encodeUrl(add_tax_flag);
			param  += "&cont_assure_percent="	+ encodeUrl(cont_assure_percent);
			param  += "&cont_assure_amt="		+ encodeUrl(cont_assure_amt);
			param  += "&fault_ins_percent="		+ encodeUrl(fault_ins_percent);
			param  += "&fault_ins_amt="			+ encodeUrl(fault_ins_amt);
		//	param  += "&pay_div_flag="			+ encodeUrl(pay_div_flag);
			param  += "&fault_ins_term="		+ encodeUrl(fault_ins_term);
			param  += "&bd_no="					+ encodeUrl(bd_no);
			param  += "&bd_count="				+ encodeUrl(bd_count);
		//  param  += "&amt_gubun="				+ encodeUrl(amt_gubun);
			param  += "&text_number="			+ encodeUrl(text_number);
			param  += "&delay_charge="			+ encodeUrl(delay_charge);
		//	param  += "&delv_place="			+ encodeUrl(delv_place);
			param  += "&remark="				+ encodeUrl(remark);
			param  += "&ctrl_demand_dept="		+ encodeUrl(ctrl_demand_dept);
			param  += "&rfq_type="				+ encodeUrl(rfq_type);
		//	param  += "&confirm_user_id="		+ encodeUrl(confirm_user_id);
		//	param  += "&confirm_user_name="		+ encodeUrl(confirm_user_name);			
			param  += "&pr_no="		            + encodeUrl(pr_no);	
			param  += "&cont_type1_text="		+ encodeUrl(cont_type1_text);	
			param  += "&cont_type2_text="		+ encodeUrl(cont_type2_text);
			param  += "&x_purchase_qty="		+ encodeUrl(x_purchase_qty);
			param  += "&delv_place="		    + encodeUrl(delv_place);
			param  += "&item_type="		    	+ encodeUrl(item_type);
			param  += "&rd_date="		    	+ encodeUrl(rd_date);
			param  += "&cont_total_gubun="		+ encodeUrl(cont_total_gubun);
			param  += "&cont_price="			+ encodeUrl(cont_price);
			param  += "&exec_no="				+ encodeUrl($.trim($('#exec_no').val()));
			param  += "&pay_div_flag="			+ encodeUrl(pay_div_flag);
			
			
			
			var msg = "저장 하시겠습니까?";
			
			//alert("amt_gubun=="+amt_gubun);
			
			//if(amt_gubun == "C") {
				var tot_amt = 0;  
				for(var i= dhtmlx_start_row_id ; i < dhtmlx_last_row_id; i++) {
					tot_amt += parseInt(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_AMT")).getValue());
				}
				if(tot_amt != del_comma(document.form.cont_amt.value)) {
					msg = "계약금액이 맞지 않습니다. \n계속 하시겠습니까?";
				} else {
					msg = "저장 하시겠습니까?";
				}
			//}	

	    if (confirm(msg)) {
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=insert&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
    }
    
    function getCtrlPersonId() {
       	PopupCommon1("SP5004", "setCtrlPerson", "", "ID", "사용자명");
	}

	function setCtrlPerson(code, text1) {
	    document.forms[0].sign_person_id.value   = code  ;
	    document.forms[0].sign_person_name.value = text1 ;
	}
	
	function setPayDivFlag() {
		var pay_div_flag = document.form.pay_div_flag.value;
		
		if(pay_div_flag == "Y") {
			document.form.pay_div_count.disabled = true;
			document.form.pay_div_count.value = "1";
		} else if(pay_div_flag == "P") {
			document.form.pay_div_count.disabled = false;
		} else if(pay_div_flag == "M") {
			document.form.pay_div_count.disabled = true;
			document.form.pay_div_count.value = "12";
		} else if(pay_div_flag == "V") {
			document.form.pay_div_count.disabled = true;
			document.form.pay_div_count.value = "1";
		}
	}
	
	function setPayDivCount() {
		var pay_div_cnt = 0;
		var pay_div_flag = document.form.pay_div_flag.value;
		var cont_amt = del_comma(document.form.cont_amt.value);
		
		if(pay_div_flag == "Y") {
			pay_div_cnt = 1;
		} 
		else if(pay_div_flag == "M") {
			pay_div_cnt = 12;
		} else if(pay_div_flag == "V") {
			pay_div_cnt = 1;
		}
		
		var strParm = "?pay_div_cnt="+ pay_div_cnt +"&pay_div_flag="+ pay_div_flag +"&cont_amt="+ cont_amt;
		popUpOpen("contract_wait_list_insert_pop.jsp"+strParm, 'PAY_DIV_FLAG', '800', '550');
	}
	
	
	var com_flag = "";
	function setValue(setDate, flag) {
		document.form.setTemp.value = setDate;
		com_flag = flag;
	}
	
	function getVendorCode(){
		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0087&function=setVendorCode&values=&values=/&desc="+encodeUrl("업체코드")+"&desc="+encodeUrl("업체명");
		CodeSearchCommon(url,'itemNoWin','50','100','650','450');
	}
	
	function setVendorCode( code, desc1, desc2)
	{
		document.form.seller_code.value = code;
		document.form.seller_name.value = desc1;
	}


	function initAjax(){
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag',			'Y');//전자계약작성여부
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type', '' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag', '<%=contract_method%>');//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag',		'<%=cont_type%>' );//계약방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text',		'<%=cont_type1%>' );//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text',		'<%=prom_crit%>' );//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun',		'<%=po_type%>' );//계약단가 //M204
		
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );
		
		var tax_div = document.getElementsByName('add_tax_flag');
		for(var i = 0 ; i < tax_div.length ; i++){
			if('<%=tax_div%>' == '1'){
				$("#add_tax_flag1").attr("checked", "true");
			}else{
				$("#add_tax_flag2").attr("checked", "true");
			}
		}
		
//===============================================================================================================================		
		
		//doRequestUsingPOST( 'SL5001', 'M808' ,'pay_div_flag',			'' );//지급구분
//		doRequestUsingPOST( 'SL5001', 'M811' ,'cont_gubun',				'' );//계약구분
		//doRequestUsingPOST( 'SL5001', 'M806' ,'start_start_ins_flag',	'N');//선급지급
		//doRequestUsingPOST( 'SL5001', 'M806' ,'property_yn',			'N');//자산등제
	}
	
	function getIvnAmtSum(){
	
		var item_amt = 0;
	
		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
			
			item_amt += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "ITEM_AMT"));
		}
		
		document.form.cont_amt.value = Comma(item_amt);
		
		getAmtPercent(document.form.cont_assure_percent.value, 'cont_assure_amt');
		getAmtPercent(document.form.fault_ins_percent.value, 'fault_ins_amt');
		
<%--		var grid_array = getGridChangedRows(GridObj, "SELECTED");--%>
<%--		--%>
<%--		var item_amt = 0; --%>
<%--		--%>
<%--		for(var i=0; i<grid_array.length;i++) {--%>
<%--			item_amt += eval(GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_AMT")).getValue());--%>
<%--		}--%>
<%--		--%>
<%--		if(item_amt == null) item_amt = 0;--%>
<%--		--%>
<%--		var item_amt_comma = add_comma(item_amt, "0");--%>
<%--		--%>
<%--		document.form.cont_amt.value = item_amt_comma;--%>
<%--		--%>
<%--		getAmtPercent(document.form.cont_assure_percent.value, 'cont_assure_amt');--%>
<%--    	getAmtPercent(document.form.fault_ins_percent.value, 'fault_ins_amt');--%>
	}
	
	
	
<%--	function getIvnAmtSum(){--%>
<%--		--%>
<%--		var F_AMT_CR = 0; // 대변 합계--%>
<%--		var F_AMT_DR = 0; // 차변 합계--%>
<%--		var AMT_CR = 0; // 대변 합계--%>
<%--		var AMT_DR = 0; // 차변 합계--%>
<%--		--%>
<%--		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {--%>
<%--			--%>
<%--			F_AMT_CR += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "FOREIGN_TOTAL_AMOUNT"));--%>
<%--			F_AMT_DR += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "FOREIGN_AMOUNT"));--%>
<%--			AMT_CR += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "KOR_TOTAL_AMOUNT"));--%>
<%--			AMT_DR += eval(SepoaGridGetCellValueId(GridObj, GridObj.getRowId(i), "KOR_AMOUNT"));--%>
<%--		}--%>
<%--			--%>
<%--		document.form.F_AMT_CR.value = Comma(Math.floor(F_AMT_CR * Math.pow(10,2)) / Math.pow(10,2));--%>
<%--		document.form.F_AMT_DR.value = Comma(Math.floor(F_AMT_DR * Math.pow(10,2)) / Math.pow(10,2));--%>
<%--		document.form.AMT_CR.value = Comma(AMT_CR);--%>
<%--		document.form.AMT_DR.value = Comma(AMT_DR);--%>
<%--	}--%>
	
	
	function getCheckDate(strValue, message)
	{
	
		if(strValue == "") {
			alert(message + "을(를) 입력하세요.");
			return false;
		}
		
		if(!checkDate(strValue)) {
            alert(message + "을(를) 확인하세요.");
            return false;
        }
	
	}
	
	
	function getAmtPercent(percent, name)
	{
		var cont_amt = del_comma(document.form.cont_amt.value);
		var percent_amt = 0;		
		
		document.getElementsByName(name)[0].value = "";
		
		if(cont_amt == "" || percent == "") 
		{
			document.getElementsByName(name)[0].value = "0";
			return;
		}
		
		percent_amt = eval(cont_amt) * ( eval(percent) / 100);
		
		document.getElementsByName(name)[0].value = add_comma( percent_amt, 0);
	}
	
	function chele_cont_flag() {
		var ele_cont_flag = document.form.ele_cont_flag.value;
		
		if(ele_cont_flag == "Y") {
			document.form.cont_add_date.value = "";
			document.form.cont_add_date.disabled = true;
// 			document.form.cont_add_date.readOnly = true;
		} else if(ele_cont_flag == "N") {
			document.form.cont_add_date.disabled = false;
// 			document.form.cont_add_date.readOnly = false;
		}
	}
	
	function load_chele_cont_flag() {
		document.form.cont_add_date.disabled = true;
// 		document.form.cont_add_date.readOnly = false;
	}
	
	function doAmtGubunChange() {

	}


    function doBudget()
    {
    	var flag = "";
    	popUpOpen("../sourcing/account_budget_list_contract.jsp?popup_flag=true&flag=" + flag , 'ACCOUNT_BUDGET_LIST', '805', '600');
    }

	function setBudget(accounts_courses_code, accounts_courses_loc, accounts_budget_amt)
	{
		document.form.account_code.value = accounts_courses_code;
		document.form.account_name.value = accounts_courses_loc;

	}
	
	function getConfirmPersonId() {
   		PopupCommon1("SP5004", "setConfirmPerson", "", "ID", "사용자명");
	}
	
	function setConfirmPerson(code, text1) {
	    document.forms[0].confirm_person_id.value = code;
	    document.forms[0].confirm_person_name.value = text1;
	}

	function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
			//sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				
				eval(document.getElementById('sg_type3')).options.length = 0;     //길이 0으로
				
				var nodePath3  = document.getElementById("sg_type3");
				var ooption3   = document.createElement("option");
				ooption3.text  = "--------";
				ooption3.value = "";
				nodePath3.add(ooption3);
			}
			else{				
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
		else if( type == '3' ){
			var sg_refitem  = f.sg_type2.value;
			var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
			
			sg_type3_id.options.length = 0;     //길이 0으로
			//sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type3_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'sg_type3', '' );
			}
			else{
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}	
	
// 	function onlyNumber(obj){
// 		if(isNaN(obj.value)){
// 			var regExt = /\D/g;
// 			obj.value = obj.value.replace(regExt, '');
// 		}
// 	}	
	
	function onlyNumber(keycode){
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}
	
	//INPUTBOX 입력시 콤마 제거
	function setOnFocus(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    target.value = del_comma(target.value);
	}
	
	//INPUTBOX 입력 후 콤마 추가
	function setOnBlur(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    if(IsNumber(target.value) == false) {
	        alert("숫자를 입력하세요.");
	        return;
	    }
	    target.value = add_comma(target.value,0);
	}
	
	//INPUTBOX 입력 후 커서아웃시 소수점1자리까지만 유효
	function checkDelayCharge(obj) {
		obj.value = add_comma(obj.value, 1);
	}
	
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();load_chele_cont_flag();doAmtGubunChange();doSelect11();">
<s:header>
<form id="form" name="form">
<input type="hidden" id="exec_no" name="exec_no" value="<%=exec_no%>">
<input type="hidden" id="setTemp" name="setTemp" value="">
<input type="hidden" id="ctrl_demand_dept" name="ctrl_demand_dept" value="<%=dept%>">
<input type="hidden" id="dilv_term" name="dilv_term" size="8" class="input_re" maxlength="8" value="">
<input type="hidden" id="po_cont_flag" name="po_cont_flag" size="8" class="input_re" maxlength="8" value="">
<input type="hidden" id="pay_div_count" name="pay_div_count" size="8" class="input_re" maxlength="8" value="">
<%
	
//  	String title = "계약생성";
// 	thisWindowPopupFlag = "true";
// 	thisWindowPopupScreenName = title;
%>

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
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="subject" name="subject" size="40" value="<%=subject%>">
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약상태
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        		</td>
							</tr>	
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>							
			  				<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약구분<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
							    	<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');">
							    		<option value="">--------</option>
							    	</select>
			    	
							    	<select id="sg_type2" name="sg_type2" class="inputsubmit" onchange="nextAjax('3');">
							    		<option value="">--------</option>
							    	</select>
			    	
							    	<select id="sg_type3" name="sg_type3" class="inputsubmit">
							    		<option value="">--------</option>
							    	</select>        			
        			
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약방법<font color='red'><b>*</b></font>
				        		</td>
				        		<% if(flag.equals("PR_NUMBER")){ %>
				        		<td width="30%" height="24" class="data_td">
				        			<select id="cont_process_flag" name="cont_process_flag" disabled="disabled">
				        				<option value="">선택</option>
				        			</select><!-- M809 -->
				        		</td>
				        		<% }else{ %>
				        		<td width="30%" height="24" class="data_td" >
				        			<select id="cont_process_flag" name="cont_process_flag" disabled="disabled">
				        				<option value="">선택</option>
				        			</select><!-- M809 -->
				        		</td>
				        		<% } %>        		
		  					</tr>
		  					<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			업체명<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<% if(flag.equals("PR_NUMBER")) { %>
									<input type="text" id="seller_code" name="seller_code" size="8" class="inputsubmit">
									<a href="javascript:getVendorCode('seller_code')"> 
										<img src="../images/button/query.gif" align="absmiddle" name="p_seller_code" border="0" alt="">
									</a>
									<input type="text" name="seller_name" size="30" class="input_empty" readonly>
				        			<% } else if(flag.equals("PR_NUMBER_MT")) { %>
									<input type="text" id="seller_code" name="seller_code" size="8" class="inputsubmit">
									<a href="javascript:getVendorCode('seller_code')"> 
										<img src="../images/button/query.gif" align="absmiddle" name="p_seller_code" border="0" alt="">
									</a>
									<input type="text" id="seller_name" name="seller_name" size="30" class="input_empty" readonly>
				        			<% } else { %>
				        			<input type="hidden" id="seller_code" name="seller_code" value="<%=seller_code%>">
				        			<input type="text"   id="seller_name" name="seller_name" value="<%=seller_name%>" readonly>
				        			<% } %>
				        		</td>
				       			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			입찰방법
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<select id="cont_type1_text" name="cont_type1_text" disabled="disabled">
				        				<option value="">선택</option>
				        			</select><!-- M994 -->&nbsp;&nbsp;
				        			<select id="cont_type2_text" name="cont_type2_text" disabled="disabled">
				        				<option value="">선택</option>
				        			</select><!-- M993 -->        			
				        		</td>
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>	
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약기간<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<s:calendar id_from="cont_from" id_to="cont_to" default_from="<%=SepoaString.getDateSlashFormat(contract_from_date) %>" default_to="<%=SepoaString.getDateSlashFormat(contract_to_date) %>" format="%Y/%m/%d" />
				         		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약담당자<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" id="sign_person_id" name="sign_person_id" value="<%=ctrl_person_id%>" onkeyup="delInputEmpty('sign_person_id', 'sign_person_name')" size="10" readonly="readonly">
									<a href="javascript:getCtrlPersonId()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
							        <input type="text" id="sign_person_name" name="sign_person_name" value="<%=ctrl_person_name%>" size="10" readonly class="input_empty">
				        		</td>         		
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약일자<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<s:calendar id="cont_add_date" format="%Y/%m/%d" />
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			작성일자<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<s:calendar id="cont_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
				        		</td>        		
	        	  			</tr>
	        	  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
	        	  			<tr>
				        		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			전자계약서작성 여부<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
					               <select id="ele_cont_flag" name="ele_cont_flag" onchange="chele_cont_flag()"></select><!-- M806 -->
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약서<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<select id="cont_type" name="cont_type">
				        				<option value="">선택</option>
				        			</select><!-- M809 -->
				        		</td>        		
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약금액<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<% if(flag.equals("PR_NUMBER")){ %>
				        				<input type="text" size="15" maxlength="50" name="cont_amt" dir="rtl" value="<%=bd_amt %>" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled;"> (원)&nbsp;
				        			<% }else{ %>
				        				<input type="text" size="15" maxlength="50" name="cont_amt" dir="rtl" value="<%=bd_amt %>" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled;"> (원)&nbsp;
				        				<!-- input type="text" size="15" maxlength="50" name="cont_amt" dir="rtl" readonly="readonly" value="<%=bd_amt %>"--> (원)
				        			<% } %>
				        			&nbsp;<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" disabled="disabled">부가세포함&nbsp;
				        			&nbsp;<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" disabled="disabled">면세
				        		</td>
				       			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약이행 보증구분<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<select id='assure_flag' name="assure_flag">
				        				<option value="">선택</option>
				        			</select><!-- M809 -->
				        		</td>        		
				 		 	</tr>
				 		 	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			대금지급횟수
				        		</td>
				        		<td width="30%" height="24" class="data_td" colspan="3">
				        			<input type="text" size="3" maxlength="1" id="pay_div_flag" name="pay_div_flag" dir="rtl" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled;">&nbsp;
				        		</td>				       			
				 		 	</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			하자보증금
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" id="fault_ins_percent" name="fault_ins_percent" dir="rtl" size="3" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled" onchange="getAmtPercent('form.fault_ins_percent.value', 'fault_ins_amt')" value="<%=mengel_percent %>">(%)
				        			&nbsp;
						       		<input type="text" id="fault_ins_amt" name="fault_ins_amt" dir="rtl" size="12" maxlength="12" class="input_empty"  readonly="readonly" value="<%=mengel_deposit%>">(원)
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약보증금
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" id="cont_assure_percent" name="cont_assure_percent" dir="rtl" size="3" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled" onchange="getAmtPercent('form.cont_assure_percent.value', 'cont_assure_amt')" value="<%=contract_percent%>">(%)
				        			&nbsp;
						       		<input type="text" id="cont_assure_amt" name="cont_assure_amt" dir="rtl" size="12" maxlength="12" class="input_empty"  readonly="readonly" value="">(원)
						       	</td>
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			하자보증기간
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" size="3" dir="rtl" maxlength="3" name="fault_ins_term"     value="<%=warranty_year%>" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled"> 년
				        			<input type="text" size="3" dir="rtl" maxlength="3" name="fault_ins_term_mon" value="<%=warranty_month%>" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled"> 개월
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			소싱번호
				        		</td>
				        		<td width="30%" height="24" class="data_td">
			        				<%
			        				String sNo = "";
			        				if(!"".equals(rfq_no))	sNo = rfq_no + " / " + rfq_count;
			        				%>
			        				<%=sNo %>				        			
				        			<input type="hidden" size="20" id="bd_no" name="bd_no" value="<%=rfq_no%>" readonly>
				        			<input type="hidden" size="10" id="bd_count" name="bd_count" value="<%=rfq_count%>">
				        		</td>
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle" onKeyPress="return onlyNumber(event.keyCode);" style="ime-mode:disabled">&nbsp;&nbsp;
				        			지체상금율
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			1000 분의 &nbsp;&nbsp;<input type="text" size="10" id="delay_charge" name="delay_charge" dir="rtl" value="<%=delay_remark%>" onKeyPress="checkNumberFormat('[0-9.]', this)" onKeyUp="chkMaxByte(100, this, '지체상금율')" onfocus="setOnFocus(this)" onblur="checkDelayCharge(this)" style="ime-mode:disabled">
				        		</td>
				        		        		
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			구매결의번호
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<%=exec_no%>
				        			<input type="hidden" size="20" id="text_number" name="text_number" value="<%=exec_no%>" readonly="readonly">
				        		</td>
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			물품종류<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" size="20" id="item_type" name="item_type" value="">
				        		</td>
				         		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			납품기한<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<s:calendar id="rd_date" format="%Y/%m/%d" />
				        		</td>
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			납품장소<font color='red'><b>*</b></font>
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<input type="text" id="delv_place" name="delv_place" size="40" value="<%=dely_to_location%>">
				        		</td>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			계약단가
				        		</td>
				        		<td width="30%" height="24" class="data_td">
				        			<select id="cont_total_gubun" name="cont_total_gubun">
				        				<option value="">선택</option>
				        			</select><!-- M813 -->&nbsp;
				        			<input type="text" id="cont_price" name="cont_price" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="chkMaxByte(22, this, '계약단가')" style="ime-mode:disabled;" onfocus="setOnFocus(this)" onblur="setOnBlur(this)">
				        		</td>
				 	 		</tr>
				 	 		<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>			  
				  			<tr>
				        		<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				        			비고
				        		</td>
				        		<td width="30%" height="24" class="data_td" colspan="3">
				        			<textarea id="remark" name="remark" class="inputsubmit" rows="3" style="width: 98%;"></textarea>
				        		</td>
				  			</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<TABLE cellpaddiㅇng="0" cellspacing="0" border="0" width="100%">
	<TR>
  		<td>&nbsp;</td>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
	  			<TR>
		  			<td><script language="javascript">btn("javascript:doSave()","저장")</script></td>
	  			</TR>
    		</TABLE>
  		</td>
   	</TR>
</TABLE>

</form>
</s:header>
<%-- <s:grid screen_id="CT_007_1" grid_box="gridbox" grid_obj="GridObj"></s:grid> --%>
<s:grid screen_id="AR_001_1" grid_box="gridbox" grid_obj="GridObj"></s:grid>
<s:footer/>	
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>