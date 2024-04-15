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
	multilang_id.addElement("MAN_001");
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
	String screen_id = "MAN_001";
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
		document.form.cont_add_date.readOnly = true;
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type'			, '' 	);
		<%-- //doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag'		, 'Y'	);//전자계약작성여부 --%>
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag'			, ''	);//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, 'FU' 	);//계약방법		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '' 	);//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '' 	);//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun'	, 'T'	);//계약단가		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'auto_extend_flag'	, 'Y'	);//자동연장여부
		
		//doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M900' ,'sg_type1'			, ''	);//계약구분(대)
		
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
			location.href = "contract_man_update.jsp?cont_no="+cont_no;
			
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
		var sg_type1 = document.forms[0].sg_type1.value;
		var sg_type2 = document.forms[0].sg_type2.value;
		var req_dept = document.forms[0].req_dept.value;
		var subject = document.forms[0].subject.value;
		var cont_process_flag = document.forms[0].cont_process_flag.value;
		var seller_code = document.forms[0].seller_code.value;
		var cont_type1_text = document.forms[0].cont_type1_text.value;
		var cont_type2_text = document.forms[0].cont_type2_text.value;
		var cont_from = document.forms[0].cont_from.value;
		var cont_to = document.forms[0].cont_to.value;
		var app_date = document.forms[0].app_date.value;
		var cont_add_date = document.forms[0].cont_add_date.value;
		var sign_person_id = document.forms[0].sign_person_id.value;
		var cont_amt = document.forms[0].cont_amt.value;
		var prev_sign_person_id = document.forms[0].prev_sign_person_id.value;
		var cont_date = document.forms[0].cont_date.value;
		var cont_type = document.forms[0].cont_type.value;
		var assure_flag = document.forms[0].assure_flag.value;
		if(sg_type1 == "") { alert("계약구분을 선택하세요."); return; }
		if(sg_type2 == "") { alert("계약구분을 선택하세요."); return; }
		if(req_dept == "") { alert("요청부서(계약부서)를 입력하세요."); return; }
		if(subject == "") { alert("계약명을 입력하세요."); return; }
		if(cont_process_flag == "") { alert("계약방법을 선택하세요."); return; }
		if(seller_code == "") { alert("업체명을 입력하세요."); return; }
		//if(cont_type1_text == "") { alert("입찰방법을 선택하세요."); return; }
		//if(cont_type2_text == "") { alert("입찰방법을 선택하세요."); return; }
		if(cont_from == "") { alert("계약기간을 입력하세요."); return; }
		if(cont_to == "") { alert("계약기간을 입력하세요."); return; }
		if(app_date == "") { alert("품의일자를 입력하세요."); return; }
		if(cont_add_date == "") { alert("계약일자를 입력하세요."); return; }
		if(sign_person_id == "") { alert("계약담당자를 입력하세요."); return; }
		if(cont_amt == "") { alert("계약금액을 입력하세요."); return; }
		if(prev_sign_person_id == "") { alert("전결권자를 입력하세요."); return; }
		if(cont_date == "") { alert("작성일자를 입력하세요."); return; }
		if(cont_type == "") { alert("계약서를 선택하세요."); return; }
		if(assure_flag == "") { alert("보증구분을 선택하세요."); return; }
		
		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);//하자보증기간 (년)
		var fault_ins_term_mon 	= LRTrim(document.form.fault_ins_term_mon.value);//하자보증기간 (월)
		
		
		var chk_add_tax_flag = document.getElementsByName("add_tax_flag");
		for(var i = 0; i < chk_add_tax_flag.length; i++){
			if(chk_add_tax_flag[i].checked == true){
				document.forms[0].add_tax_flag_value.value = chk_add_tax_flag[i].value;
			}
		}
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		document.form.hdn_fault_ins_term.value = YearChangeMonth( fault_ins_term, fault_ins_term_mon );
		
		var nickName = "MAN_001";
		var conType = "CONNECTION";
		var methodName = "getContractInsert";
		var SepoaOut = doServiceAjax( nickName, conType, methodName );
		
		alert(SepoaOut.message);
		if(SepoaOut.status == '1') {
			location.href = "contract_man_update.jsp?cont_no="+SepoaOut.result[0];
		}
		//alert(SepoaOut.message);
		return;
		<%-- 
		var grid_col_id     = "<%=grid_col_id%>";
		var params ="?mode=insert&cols_ids="+grid_col_id;
		params+=dataOutput();
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var SERVLETURL  = G_SERVLETURL + params;
	 	myDataProcessor = new dataProcessor(SERVLETURL);
	 	alert(SERVLETURL);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	     --%>
	   
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
				
				//doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				doRequestUsingPOST( 'SL0149', '<%=house_code%>#'+sg_refitem ,'sg_type2'			, ''	);//계약구분(중)
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
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
		window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function  SP9113_getCode(ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].sign_person_id.value         = ls_ctrl_person_id;
		document.forms[0].sign_person_name.value       = ls_ctrl_person_name;
	}	
	
	function SP9113_Popup2() {
		window.open("/common/CO_008.jsp?callback=SP9113_getCode2", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function  SP9113_getCode2(ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].prev_sign_person_id.value         = ls_ctrl_person_id;
		document.forms[0].prev_sign_person_name.value       = ls_ctrl_person_name;
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
	    if( type == "sign_person_id" ) { 
	    	document.forms[0].sign_person_id.value = "";
	        document.forms[0].sign_person_name.value = "";
	    } 
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }
	    if( type == "req_dept" ) {
	    	document.forms[0].req_dept.value = "";
	        document.forms[0].req_dept_name.value = "";
	    }
	}
	
	function PopupManager(part) {
		var url = "";
		var f = document.forms[0];

		if(part == "REQ_DEPT") {
			window.open("/common/CO_009.jsp?callback=getReqDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "SALES_DEPT") {
			window.open("/common/CO_009.jsp?callback=getSalesDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "DEMAND_DEPT") {
			window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "ADD_USER_ID") {
			window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		else if(part == "ctrl_person_id")
		{
			window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
	}
	
	function getCtrlUser(code, text) {
		document.form1.ctrl_person_id.value = code;
		document.form1.ctrl_person_name.value = text;
	}

	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.form1.ctrl_code.value = code;
		document.form1.ctrl_name.value = text;
	}

	function getDemand(code, text) {
		document.forms[0].demand_dept_name.value = text;
		document.forms[0].demand_dept.value = code;
	}

	function getAddUser(code, text) {
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
	}
	
	function getCtrlPerson(code, text ,code1, text1)
	{
		document.forms[0].ctrl_person_name.value = text1;
		document.forms[0].ctrl_person_id.value = code1;
	}

	function getReqDept(code, text) {
		document.forms[0].req_dept_name.value = text;
		document.forms[0].req_dept.value = code;
	}

	function getSalesDept(code, text) {
		document.forms[0].sales_dept_name.value = text;
		document.forms[0].sales_dept.value = code;
	}	
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
<form name="form">
<input type="hidden" name="hdn_fault_ins_term"  id="hdn_fault_ins_term"          value="" />

<input type="hidden" name="setTemp"          value="" />
<input type="hidden" name="ctrl_demand_dept" value="<%=dept%>" />
<input type="hidden"  name="add_tax_flag_value" id="add_tax_flag_value"/>


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
        							계약구분<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
			    					<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');">
			    						<option value="">--------</option>
			    					</select>
				    	
			    					<select id="sg_type2" name="sg_type2" class="inputsubmit" >
			    						<option value="">--------</option>
			    					</select>
			    	
			    					
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							요청부서(계약부서)<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">        							
									<input type="text"  readonly name="req_dept" id="req_dept" style="ime-mode:inactive" size="15" maxlength="6" value='' >
									<a href="javascript:PopupManager('REQ_DEPT');">
										<img src="/images/ico_zoom.gif" align="absmiddle" border="0" alt="">
									</a>
									<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text"  name="req_dept_name" id="req_dept_name" size="20" readonly value='' >
        						</td>
			  				</tr>
							<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>	
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="subject" name="subject" size="35">
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
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							업체명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
								<input type="text"  readonly  name="seller_code" id="seller_code" style="width:80px;ime-mode:inactive" class="inputsubmit" maxlength="10" >
								<a href="javascript:searchProfile('seller_code')">
									<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
								</a>
								<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
								<input type="text" readonly  name="seller_name" id="seller_name" style="width:120px" class="inputsubmit">
        						</td>
       							<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							입찰방법</font>
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
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약기간<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id_from="cont_from" id_to="cont_to" default_from="" default_to="" format="%Y/%m/%d" />
         						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							품의일자<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="app_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
        						</td>        						
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약일자<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="cont_add_date" format="%Y/%m/%d" />
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약담당자<font color='red'><b>*</b></font>
        						</td>
        						
   								<td class="data_td" width="35%">
       								<b><input type="text" name="sign_person_id" id="sign_person_id" style="ime-mode:inactive"  value="<%=info.getSession("ID") %>" size="15" class="inputsubmit" readonly>
       								<a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
       								<a href="javascript:doRemove('sign_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
       								<input type="text" name="sign_person_name" id="sign_person_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly ></b>
   								</td>    		
        	  				</tr>
        	  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
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
        							전결권자<font color='red'><b>*</b></font>
        						</td>
        						
   								<td class="data_td" width="35%">
       								<b><input type="text" name="prev_sign_person_id" id="prev_sign_person_id" style="ime-mode:inactive"  value="<%=info.getSession("ID") %>" size="15" class="inputsubmit" readonly>
       								<a href="javascript:SP9113_Popup2();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
       								<a href="javascript:doRemove('prev_sign_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
       								<input type="text" name="prev_sign_person_name" id="prev_sign_person_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly ></b>
   								</td>      		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							결재금액
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="app_amt"      name="app_amt"      dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							대금청구일
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="pr_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
        						</td>        		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							사업예산
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="budget_amt"      name="budget_amt"      dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							대금지급일
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="pay_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
        						</td>        		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							내정가격
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="in_price_amt"      name="in_price_amt"      dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							작성일자<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="cont_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
        						</td>          		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							예정가격
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="be_price_amt"      name="be_price_amt"      dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
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
			  				
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>	
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약근거
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="app_remark" name="app_remark" size="35">
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							자동연장유무
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="auto_extend_flag" name="auto_extend_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>   
			  				</tr>
			  				
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>	
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
        							보증구분<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="assure_flag" name="assure_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>      		
			  				</tr> 
			  				
				  		 	<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							하자보증기간
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term" name="fault_ins_term" onkeyup="onlyNumber(this)" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive"> 년
        							<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term_mon" name="fault_ins_term_mon" onkeyup="onlyNumber(this)" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive"> 개월        			
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
			  				
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							지체상금율
        						</td>
        						<td width="30%" height="24" class="data_td">
        							1000 분의 &nbsp;&nbsp;<input type="text" size="3" id="delay_charge" name="delay_charge" dir="rtl" value="" onkeyup="onlyNumber(this)">
        						</td>
         						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							납품기한
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="rd_date" format="%Y/%m/%d" />
        						</td>
			  				</tr>
			  				
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							물품종류(모델명)
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="item_type" name="item_type" value="">
        						</td>
         						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							수량
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="item_qty" name="item_qty" value="">
        						</td>
			  				</tr>

			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
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
        							</select><!-- M813 -->&nbsp;<input type="text"  id="cont_price"  name="cont_price" style="ime-mode:disabled" onkeypress="checkNumberFormat('[0-9]', this)" onkeyup="chkMaxByte(22, this, '계약단가')" onfocus="setOnFocus(this)" onblur="setOnBlur(this)">
        						</td>
			  				</tr>
							<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>					  
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							비고	
        						</td>
        						<td width="30%" height="24" class="data_td" colspan="3">
        							<textarea id="remark" name="remark" class="inputsubmit" style="width: 98%;" rows="3"></textarea>
        						</td>
			  				</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>	        	    		
							<tr>
								<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>							
								<td width="30%" class="data_td" colspan=3>
									<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="15%">
											<script language="javascript">
											function setAttach(attach_key, arrAttrach, rowid, attach_count) {
												document.getElementById("in_attach_no").value = attach_key;
												document.getElementById("attach_no_count").value = attach_count;
											}
											btn("javascript:attach_file(document.getElementById('in_attach_no').value, 'TEMP');", "파일등록");
											</script>
											</td>
											<td>
												<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
												<input type="hidden" value="" name="in_attach_no" id="in_attach_no">
											</td>
										</tr>
									</table>
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