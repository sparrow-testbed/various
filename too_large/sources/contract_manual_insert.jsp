<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	
	String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,30);
	String to_date   = to_day;

	String cont_date = SepoaString.getDateSlashFormat(to_date);
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_007_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	String G_IMG_ICON = "/images/ico_zoom.gif";

	Config conf = new Configuration();
	String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	String house_code 		  = info.getSession("HOUSE_CODE");
	String sign_person_id     = info.getSession("ID");
	String sign_person_name   = info.getSession("NAME_LOC");
	String dept               = info.getSession("DEPARTMENT");
	
	String rfq_number	    = JSPUtil.nullToEmpty(request.getParameter("contract_number")).trim();
	String rfq_count	    = JSPUtil.nullToEmpty(request.getParameter("contract_count")).trim();
	String seller_code	    = JSPUtil.nullToEmpty(request.getParameter("cont_seller_code")).trim();
	String seller_name	    = JSPUtil.nullToEmpty(request.getParameter("cont_seller_name")).trim();
	String bd_amt		    = JSPUtil.nullToEmpty(request.getParameter("contract_amt")).trim();
	
	String rfq_type		    = JSPUtil.nullToEmpty(request.getParameter("rfq_type")).trim();
	String bd_kind          = JSPUtil.nullToEmpty(request.getParameter("bd_kind")).trim();
	String ctrl_person_id   = JSPUtil.nullToEmpty(request.getParameter("ctrl_person_id")).trim();
	String ctrl_person_name = JSPUtil.nullToEmpty(request.getParameter("ctrl_person_name")).trim();
	String pr_no 		    = JSPUtil.nullToEmpty(request.getParameter("pr_no")).trim();
	
	if( "".equals(rfq_type) ) rfq_type = "MA";
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_007_1";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	if(ctrl_person_id.equals("")){
		ctrl_person_id 	 = sign_person_id;
		ctrl_person_name = sign_person_name;
	}
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
	
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    }

	function initAjax(){
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type'			, '' 	);
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag'		, 'Y'	);//전자계약작성여부
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag'			, ''	);//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, 'FU' 	);//계약방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '' 	);//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '' 	);//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun'	, 'T'	);//계약단가
		
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );		
		
	}
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    
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
				
				var item_amt     = floor_number(eval(rfq_qty) * eval(unit_price), 0);
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
	
	function doQueryEnd(GridObj, RowCnt)
    {
    
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

			alert("[ 계약번호 : "+ cont_no + " ]"+ messsage);
			location.href = "contract_create_list_update.jsp?cont_no="+cont_no;
			
		} else {
			alert(messsage);
		}

		return false;
	}

	function YearChangeMonth( fault_ins_term, fault_ins_term_mon ){
		if( fault_ins_term == "" )     fault_ins_term = 0;
		if( fault_ins_term_mon == "" ) fault_ins_term_mon = 0;
	
		var month = 0;
		    month = (parseInt(fault_ins_term) * 12) + parseInt(fault_ins_term_mon);
		
		return month;
	}

    function doSave() {
		var subject					= LRTrim(document.form.subject.value);                   // 계약명
//		var cont_gubun				= LRTrim(document.form.cont_gubun.value);                // 계약구분
		var sg_type1                = LRTrim(document.form.sg_type1.value);  //소싱그룹 대분류
		var sg_type2                = LRTrim(document.form.sg_type2.value);  //소싱그룹 중분류
		var sg_type3                = LRTrim(document.form.sg_type3.value);  //소싱그룹 소분류

		var seller_code				= LRTrim(document.form.seller_code.value);               // 업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);               // 업체명
		var sign_person_id			= LRTrim(document.form.sign_person_id.value);            // 계약담당자 id
		var sign_person_name		= LRTrim(document.form.sign_person_name.value);          // 계약담당자 name
		var cont_from				= LRTrim(del_Slash(document.form.cont_from.value));      // 계약기간 from
		var cont_to					= LRTrim(del_Slash(document.form.cont_to.value));        // 계약기간 to
		var cont_date				= LRTrim(del_Slash(document.form.cont_date.value));      // 작성일자
		var cont_add_date			= LRTrim(del_Slash(document.form.cont_add_date.value));  // 계약일자
		var cont_type				= LRTrim(document.form.cont_type.value);                 // 계약종류
		var ele_cont_flag			= LRTrim(document.form.ele_cont_flag.value);             // 전자계약작성여부
		var assure_flag				= LRTrim(document.form.assure_flag.value);               // 보증구분
		var cont_process_flag		= LRTrim(document.form.cont_process_flag.value);         // 계약방법
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));       // 계약금액
		var add_tax_flag = "";
		if( document.form.add_tax_flag[0].checked == true ) add_tax_flag	= document.form.add_tax_flag[0].value;// 부가세포함여부
		if( document.form.add_tax_flag[1].checked == true ) add_tax_flag	= document.form.add_tax_flag[1].value;// 부가세포함여부

		var cont_assure_percent		= LRTrim(document.form.cont_assure_percent.value);       // 계약보증금(%)
		var cont_assure_amt			= LRTrim(del_comma(document.form.cont_assure_amt.value));// 계약보증금(원)
		var fault_ins_percent		= LRTrim(document.form.fault_ins_percent.value);         // 하자보증금(%)
		var fault_ins_amt			= LRTrim(del_comma(document.form.fault_ins_amt.value));  // 하자보증금(원)

		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);            // 하자보증기간
		var fault_ins_term_mon 	    = LRTrim(document.form.fault_ins_term_mon.value);        //하자보증기간 (월)
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		fault_ins_term = fault_ins_term = YearChangeMonth( fault_ins_term, fault_ins_term_mon );		
		
		var bd_no					= LRTrim(document.form.bd_no.value);                     // 입찰/견적서번호
		var bd_count				= LRTrim(document.form.bd_count.value);                  // 입찰/견적서차수		
		var text_number				= LRTrim(document.form.text_number.value);               // 문서번호
		var delay_charge			= LRTrim(document.form.delay_charge.value);              // 지체상금율
		var remark					= LRTrim(document.form.remark.value);                    // 비고
		var ctrl_demand_dept		= LRTrim(document.form.ctrl_demand_dept.value);          // 계약담당자부서
		var rfq_type				= "<%=rfq_type%>";                                       // MA, BD(구매입찰)
		var pr_no		            = "<%=pr_no%>";
		var cont_type1_text		    = LRTrim(document.form.cont_type1_text.value);           // 입찰방법
		var cont_type2_text		    = LRTrim(document.form.cont_type2_text.value);           // 낙찰방법
		var x_purchase_qty          = "1"; // 구매수량
		var delv_place              = LRTrim(document.form.delv_place.value);//납품장소
		var item_type              	= LRTrim(document.form.item_type.value);//물품종류
		var rd_date              	= LRTrim(LRTrim(del_Slash(document.form.rd_date.value)));//납품기한
		var cont_total_gubun		= LRTrim(document.form.cont_total_gubun.value);//계약단가구분
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
			alert("업체코드을 입력 하세요.");
			return;
		}
		
		if( sign_person_id == "" ) {
			alert("계약담당자를 입력 하세요.");
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
			alert("계약종류를 입력하세요.");
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
// 		if(cont_total_gubun == "C" && (cont_price == "" ||cont_price == "0")){
// 			alert("계약단가를 입력하세요.");
// 			document.form.cont_price.focus();
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
		var param   = "&subject="				+ encodeUrl(subject);
//			param  += "&cont_gubun="			+ encodeUrl(cont_gubun);
			param  += "&sg_type1="				+ encodeUrl(sg_type1);
			param  += "&sg_type2="				+ encodeUrl(sg_type2);
			param  += "&sg_type3="				+ encodeUrl(sg_type3);
			
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
			param  += "&cont_process_flag="		+ encodeUrl(cont_process_flag);
			param  += "&cont_amt="				+ encodeUrl(cont_amt);
			param  += "&add_tax_flag="			+ encodeUrl(add_tax_flag);			
			param  += "&cont_assure_percent="	+ encodeUrl(cont_assure_percent);
			param  += "&cont_assure_amt="		+ encodeUrl(cont_assure_amt);
			param  += "&fault_ins_percent="		+ encodeUrl(fault_ins_percent);
			param  += "&fault_ins_amt="			+ encodeUrl(fault_ins_amt);
			param  += "&fault_ins_term="		+ encodeUrl(fault_ins_term);
			param  += "&bd_no="					+ encodeUrl(bd_no);
			param  += "&bd_count="				+ encodeUrl(bd_count);			
			param  += "&text_number="			+ encodeUrl(text_number);
			param  += "&delay_charge="			+ encodeUrl(delay_charge);
			param  += "&remark="				+ encodeUrl(remark);
			param  += "&ctrl_demand_dept="		+ encodeUrl(ctrl_demand_dept);
			param  += "&rfq_type="				+ encodeUrl(rfq_type);
			param  += "&pr_no="		            + encodeUrl(pr_no);	
			param  += "&cont_type1_text="	    + encodeUrl(cont_type1_text);	
			param  += "&cont_type2_text="		+ encodeUrl(cont_type2_text);	
			param  += "&x_purchase_qty="		+ encodeUrl(x_purchase_qty);	
			param  += "&delv_place="		    + encodeUrl(delv_place);		
			param  += "&item_type="		    	+ encodeUrl(item_type);		
			param  += "&rd_date="		    	+ encodeUrl(rd_date);	
			param  += "&cont_total_gubun="		+ encodeUrl(cont_total_gubun);
			param  += "&cont_price="			+ encodeUrl(cont_price);
			
		var msg = "저장 하시겠습니까?";
		
		
		
	    if (confirm(msg)) {
	   		dhtmlx_last_row_id++;
	    	var nMaxRow2 = dhtmlx_last_row_id;
	    	var row_data = "<%=grid_col_id%>";
	    	GridObj.enableSmartRendering(true);
	    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	    	GridObj.selectRowById(nMaxRow2, false, true);
	
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("ANN_ITEM")).setValue(subject);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("delv_place")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("DLVRYDSREDATE")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("bid_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ee_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("join_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("VENDOR_NAME")).setValue(seller_name);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ASUMTNAMT")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ESTM_PRICE")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("FINAL_ESTM_PRICE_ENC")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("SUM_AMT")).setValue(cont_amt);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("CUR")).setValue("WON");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("VENDOR_CODE")).setValue(seller_code);	    
	    
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
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
	
	/* 
	function getSellerCode() {
		PopupCommon2( "SP5001", "SP5001_getCode",  "", "", "업체코드", "업체명" );//업체코드,업체명
	}
	
	function SP5001_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text1;
	}
	*/
	
	function getAmtPercent(percent, name)
	{
		if( document.form.cont_amt.value == "" ){
			alert("계약금액을 먼저 입력하셔야 합니다.");
			document.form.cont_assure_percent.value = "";
			document.form.fault_ins_percent.value   = "";
			document.form.fault_ins_amt.value       = "";
			document.form.cont_assure_amt.value     = "";

			document.form.cont_amt.focus();
			return;
		}		
			
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
			document.form.cont_add_date.readOnly = true;
		} else if(ele_cont_flag == "N") {
			document.form.cont_add_date.readOnly = false;
		}
	}

	function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
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
//			sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
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
	
	function change(){
		var fault_ins_percent   = document.form.fault_ins_percent.value;   // 하자보증금
		var cont_assure_percent = document.form.cont_assure_percent.value; // 계약보증금
		
		$("#cont_amt").val(add_comma($("#cont_amt").val(),0));
		
		if( fault_ins_percent != "" ){
			document.form.fault_ins_percent.value = "";
			document.form.fault_ins_amt.value     = "";
		}
		
		if( cont_assure_percent != "" ){
			document.form.cont_assure_percent.value = "";
			document.form.cont_assure_amt.value     = "";
		}
	}
	
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

	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].sign_person_id.value         = ls_ctrl_person_id;
		document.forms[0].sign_person_name.value       = ls_ctrl_person_name;
	}	
	
	function onlyNumber(obj){
		if(isNaN(obj.value)){
			var regExt = /\D/g;
			obj.value = obj.value.replace(regExt, '');
		}
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
	function doRemove( type ){
	    if( type == "sign_person_id" ) {
	    	document.forms[0].sign_person_id.value = "";
	        document.forms[0].sign_person_name.value = "";
	    } 
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }
	}
	
	function searchProfile(fc) {
		if(fc =="seller_code"){
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	function SP0054_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text1;
	}

	//지우기
	function doRemove( type ){
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }  
	}
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
<form name="form">
<input type="hidden" name="setTemp"          value="" />
<input type="hidden" name="ctrl_demand_dept" value="<%=dept%>" />

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
        							<input type="text" id="subject" name="subject" size="35">
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
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_process_flag" name="cont_process_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							업체명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							
<input type="text" onkeydown='entKeyDown()'  name="seller_code" id="seller_code" style="width:80px;ime-mode:inactive" class="inputsubmit" maxlength="10" >
<a href="javascript:searchProfile('seller_code')">
	<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
</a>
<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
<input type="text" onkeydown='entKeyDown()'  name="seller_name" id="seller_name" style="width:120px" class="inputsubmit">
        							<%-- 
									<input type="text" id="seller_code" name="seller_code" size="8" class="inputsubmit" readonly>
									<a href="javascript:getSellerCode()"> 
										<img src="../images/button/query.gif" align="absmiddle" name="p_seller_code" border="0" alt="">
									</a>
									<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text" id="seller_name" name="seller_name" size="30" class="input_empty" readonly>
									--%>
        						</td>
       							<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							입찰방법
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_type1_text" name="cont_type1_text">
        								<option value="">선택</option>
        							</select><!-- M994 -->&nbsp;&nbsp;
        							<select id="cont_type2_text" name="cont_type2_text">
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
        							<s:calendar id_from="cont_from" id_to="cont_to" default_from="" default_to="" format="%Y/%m/%d" />
         						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약담당자<font color='red'><b>*</b></font>
        						</td>
        						
   								<td class="data_td" width="35%">
       								<b><input type="text" name="sign_person_id" id="sign_person_id" style="ime-mode:inactive"  value="<%=info.getSession("ID") %>" size="15" class="inputsubmit">
       								<a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
       								<a href="javascript:doRemove('sign_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
       								<input type="text" name="sign_person_name" id="sign_person_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly ></b>
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
       								<input type="text" size="15" maxlength="50" id="cont_amt"      name="cont_amt"      dir="rtl" value="" onchange="change();" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        							&nbsp;<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" checked>부가세포함&nbsp;
        							&nbsp;<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" >면세       				
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							보증구분<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="assure_flag" name="assure_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>        		
			  				</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							하자보증금
        						</td>
        						<td width="30%" height="24" class="data_td" >
        							<input type="text" id="fault_ins_percent" name="fault_ins_percent" dir="rtl" size="3" onkeyup="onlyNumber(this)" onchange="getAmtPercent('form.fault_ins_percent.value', 'fault_ins_amt')" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" >(%)
        							&nbsp;
		       						<input type="text" id="fault_ins_amt" name="fault_ins_amt" dir="rtl" size="12" maxlength="12" class="input_empty"  readonly="readonly">(원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약보증금
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="cont_assure_percent" name="cont_assure_percent" dir="rtl" size="3" onchange="getAmtPercent('form.cont_assure_percent.value', 'cont_assure_amt')" onkeyup="onlyNumber(this)">(%)
        							&nbsp;
		       						<input type="text" id="cont_assure_amt" name="cont_assure_amt" dir="rtl" size="12" maxlength="12" class="input_empty"  readonly="readonly">(원)
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
        							<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term" name="fault_ins_term" onkeyup="onlyNumber(this)" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive"> 년
        							<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term_mon" name="fault_ins_term_mon" onkeyup="onlyNumber(this)" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive"> 개월        			
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							소싱번호
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="bd_no" name="bd_no" style="ime-mode:inactive"  value="<%=rfq_number%>">
        							<input type="hidden" size="10" id="bd_count" name="bd_count" value="<%=rfq_count%>">
        						</td>       		        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							지체상금율
        						</td>
        						<td width="30%" height="24" class="data_td">
        							1000 분의 &nbsp;&nbsp;<input type="text" size="3" id="delay_charge" name="delay_charge" dir="rtl" value="" onkeyup="onlyNumber(this)">
        						</td>
         						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							문서번호
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="text_number" name="text_number" style="ime-mode:inactive"  value="">
        						</td>
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							물품종류
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="item_type" name="item_type" value="">
        						</td>
         						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							납품기한
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
        							납품장소
        						</td>
        						<td width="30%" height="24" class="data_td" >
        							<input type="text" id="delv_place" name="delv_place" size="40">
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약단가
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_total_gubun" name="cont_total_gubun">
        								<option value="">선택</option>
        							</select><!-- M813 -->&nbsp;<input type="text" name="cont_price" style="ime-mode:disabled" onkeypress="checkNumberFormat('[0-9]', this)" onkeyup="chkMaxByte(22, this, '계약단가')" onfocus="setOnFocus(this)" onblur="setOnBlur(this)">
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
        							<textarea id="remark" name="remark" class="inputsubmit" style="width: 98%;" rows="3"></textarea>
        						</td>
			  				</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
						
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<td><script language="javascript">btn("javascript:doSave()","저장")</script></td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>		
		
<div style="display:none">
	<table cellpadding="0" cellspacing="0" border="0" width="99%">
		<tr>
			<td style="text-decoration: underline; font-weight: bold" height="12px" align="right">
				(단위 : 원, 부가세 포함)
			</td>
		</tr>
		<tr>
			<td height="3px"></td>
		</tr>
	</table>
	<div id="gridbox" name="gridbox" width="100%"  height="200px" style="background-color:white;"></div>
</div>		
</form>
</s:header>
<s:footer/>	
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>