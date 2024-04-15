<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

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

<!-- 폼작업만 했기때문에 틀을 제외한 함수 차후 변경 및 적용 -->
<%
	String inv_no		= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
	String inv_seq		= JSPUtil.nullToEmpty(request.getParameter("inv_seq"));
	String gubun		= JSPUtil.nullToEmpty(request.getParameter("gubun"));
	String tax_no		= JSPUtil.nullToEmpty(request.getParameter("tax_no"));
	String status		= JSPUtil.nullToEmpty(request.getParameter("status"));
	String disStr		= "";
	
	if(!"".equals(status)){
		disStr		= "disabled";
	}
	
	String gubun_flag = null;
	String inv_data = null;
	String inv_no_str = null;
	Map<String, String> param = new HashMap<String, String>();
	
	boolean isAdmin		= this.isAdmin(info);
	
	
	boolean modifyFlag = true;
	if(!"".equals(tax_no)){
		Map<String, String> invMap = new HashMap<String, String>();
		invMap.put("tax_no", tax_no);
		Object[] obj1 		= { invMap };
	    SepoaOut value1 	= ServiceConnector.doService(info, "TX_001", "CONNECTION", "getInvNo", obj1);
		SepoaFormater wf1 	= new SepoaFormater(value1.result[0]);		
		
		
		if(wf1.getRowCount() > 0){
			for(int i = 0 ; i < wf1.getRowCount(); i++){
				inv_no += wf1.getValue("INV_NO", i) + ","; 
				inv_seq += wf1.getValue("INV_SEQ", i) + ","; 
			}
			modifyFlag = false;
		}
	}	
	
	String[] invNoArr 	= inv_no.split("\\,");
	String[] invSeqArr 	= inv_seq.split("\\,");
	
	int invNoCnt = 0;
	
	for(String invNo : invNoArr){
		if(invNoCnt == 0){
			inv_data = invNo + invSeqArr[invNoCnt];
			inv_no_str = invNo;
		}else{
			inv_data += "','" + invNo + invSeqArr[invNoCnt];
			inv_no_str += "','" + invNo;
		}
		invNoCnt++;
	}
	
	//StringTokenizer st = new StringTokenizer(pay_no, ",");
	//StringTokenizer st1 = new StringTokenizer(pay_seq, ",");
	if(gubun.equals("P")){
		gubun_flag = "영수";
	}else{
		gubun_flag = "청구";		
	}

	
	param.put("inv_data", inv_data);
	param.put("inv_no_str", inv_no_str);
	param.put("gubun", gubun);

	String user_id         	= info.getSession("ID");
	String company_code    	= info.getSession("COMPANY_CODE");
	String house_code      	= info.getSession("HOUSE_CODE");
	String taxt_app_no1		= "";
	String taxt_app_no2		= "";
	String taxt_app_no3		= "";
	String taxt_app_no4		= "";
	
	// 거래명세서 헤더 등록정보
	Object[] obj 		= { param };
    SepoaOut value 		= ServiceConnector.doService(info, "TX_003", "CONNECTION", "getTxHD", obj);
	SepoaFormater wf 	= new SepoaFormater(value.result[0]);
	
	// 거래명세서 pi정보
	
	String 			addPiCombo 	= "";
	SepoaOut 		value1		= null;
	SepoaFormater 	wf1			= null;
	if(wf != null && wf.getRowCount() > 0){
		Object[] obj1 = { wf.getValue("VENDOR_CODE",0) };
	    value1 	= ServiceConnector.doService(info, "TX_003", "CONNECTION", "getPiInfo", obj1);
		wf1 	= new SepoaFormater(value1.result[0]);
	}
	
	// 승인번호
	if("P".equals(gubun)){
		if(wf.getValue("TAX_APP_NO",0).length() == 16){
		
			if(!wf.getValue("TAX_APP_NO",0).substring(0, 4).equals("")){
				taxt_app_no1 = wf.getValue("TAX_APP_NO",0).substring(0, 4);
			}
			if(!wf.getValue("TAX_APP_NO",0).substring(4, 8).equals("")){
				taxt_app_no2 = wf.getValue("TAX_APP_NO",0).substring(4, 8);
			}
			if(!wf.getValue("TAX_APP_NO",0).substring(8, 12).equals("")){
				taxt_app_no3 = wf.getValue("TAX_APP_NO",0).substring(8, 12);
			}
			if(!wf.getValue("TAX_APP_NO",0).substring(12, 16).equals("")){
				taxt_app_no4 = wf.getValue("TAX_APP_NO",0).substring(12, 16);
			}
		}
	}
	
	
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<!--
	var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.tax_pub_list";

	var IDX_SEL;
	var IDX_PO_NO;
	var IDX_PNT_STATUS;
	var IDX_VENDOR_CODE;

	function setHeader() {
		var f0 = document.forms[0];





// 		GridObj.SetDateFormat("DATE"			,"yyyy-MM-dd");
		
		GridObj.SetNumberFormat("QTY"				,G_format_amt);
		GridObj.SetNumberFormat("PRICE"			,G_format_amt);
		GridObj.SetNumberFormat("SUPPLIER_PRICE"	,G_format_amt);
		GridObj.SetNumberFormat("TAX_PRICE"		,G_format_etc);


	}

	function doSelect()
	{
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getTxList&grid_col_id="+grid_col_id;
		param += "&inv_data=<%=inv_data%>";
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var tax_no = "";
		
		if(msg1 == "doQuery"){

		}
// 		if(msg1 == "doData"){
			
// 			var mode  = GD_GetParam(GridObj,0);

// 			if(mode == "setTaxAppNo")
// 	      	{
// 	        	alert(GridObj.GetMessage());

// 	        	location.href="/s_kr/ordering/ivtx/tx1_bd_lis2.jsp";
// 	      	}
// 		}
		if(msg1 == "t_imagetext") {
		}
	}

	//************************************************** Date Set *************************************
	function valid_date(year,month,day,week) {
		var f0 = document.forms[0];
		f0.tax_date.value=year+month+day;
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
		if(part == "REQ_DEPT") {
			window.open("/common/CO_009.jsp?callback=getReqDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
	}
	function getReqDept(code, text) {
		document.forms[0].req_dept_name.value = text;
		document.forms[0].req_dept.value = code;
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
	
	function setAttach(attach_key, arrAttrach, rowId, attach_count) {

	    var attachfilename  = arrAttrach + "";
	    var result 			="";

		var attach_info 	= attachfilename.split(",");

		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var des_file_name 	= attach_info[3+(i*7)];
			var src_file_name 	= attach_info[4+(i*7)];
			var file_size 		= attach_info[5+(i*7)];
			var add_user_id 	= attach_info[6+(i*7)];

			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}

		document.forms[0].ATTACH_NO.value = attach_key;
		document.forms[0].FILE_NAME.value = result;

	}
	
	function getApprovalSend(){
		
		var f0 = document.forms[0];
		//보류
// 		if(f0.attach_no.value == "") {
// 			alert("첨부파일이 없습니다. 세금계산서를 스캔하여 첨부해주세요.");
// 			return;
// 		}
		
		document.forms[0].tax_date.value = del_Slash( document.forms[0].tax_date.value );
		
		var grid_array = getGridChangedRows(GridObj, "SEL");
    	var cols_ids = "<%=grid_col_id%>";
		var params = "mode=setTxData&cols_ids="+cols_ids;
			params += dataOutput();
	    myDataProcessor = new dataProcessor(servletUrl, params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
	}
	
	function doSave(progress_code){
		var f0 = document.forms[0];
		var message = "";
		if("P" == "<%=gubun%>"){
			for(var i  = 0 ; i < f0.tax_app_no_ar.length ; i++  ){
			if(f0.tax_app_no_ar[i].value == "" ) {
				alert("승인번호를 입력해 주세요.");
				f0.tax_app_no_ar[i].focus();
				return;
	    	}
			if(f0.tax_app_no_ar[i].value.length != 4){
					alert("승인번호가 16자리인지 확인해주세요.");
					f0.tax_app_no_ar[i].focus();
					return;
				}
			}
			f0.tax_app_no.value = f0.tax_app_no_ar[0].value
								+ f0.tax_app_no_ar[1].value
								+ f0.tax_app_no_ar[2].value
								+ f0.tax_app_no_ar[3].value;
		}
				
		if($.trim($("#ktgrm").val()) == ''){
			alert("대금지급 구분을 선택해 주세요.");
			$("#ktgrm").focus();
			return;
		}else if($.trim($("#ktgrm").val()) == '02' && $.trim($("#req_dept").val()) == ''){					
			alert("지급결의 담당부서를 지정해 주세요.");
			$("#req_dept").focus();
			return;
		}else{
			if(!isKtgrm){
				if(!confirm("품목승인 계정그룹이 서로 다릅니다.\n계속 진행하시겠습니까?"))return;
			}else{
				if(ktgrmVal != $.trim($("#ktgrm").val())){
					if(!confirm("품목승인 계정그룹과 대금지급구분이 다릅니다.\n계속 진행하시겠습니까?")){
						$("#ktgrm").focus();
						return;
					}
				}
			}
			
			if($.trim($("#ktgrm").val()) == "03"){
				for(var i = 0 ; i < GridObj.GetRowCount()-1 ; i++){
					if(!(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("MATERIAL_TYPE")).getValue() == "02" || GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("MATERIAL_TYPE")).getValue() == "04")){
						alert((i+1) + "번째 행의 [" + GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_NAME")).getValue() + "] 품목은\n자본예산을 처리할수 있는 품목이 아닙니다.");
						return;
					}
					/*
					if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("MATERIAL_TYPE")).getValue() == "02"){
						if( !IsNumber1(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_CODE")).getValue()) || GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_CODE")).getValue().length != 6 ){							
							alert((i+1) + "번째 행의 [" + GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_NAME")).getValue() + "] 품목은\n자본예산을 처리할수 있는 품목이 아닙니다.");
							return;
						}
					}
					*/
				}
			}
		}
		
				//보류			
// 		if(!checkDateCommon(f0.tax_date.value.replaceAll("-",""))) {
// 			alert(" 발행일자를 확인 하세요. ");
// 			f0.tax_date.focus();
// 			return;
// 		}
		
		if(progress_code == "D"){
			message = "저장 하시겠습니까?";
		}else if(progress_code == "I"){
			message = "전송 하시겠습니까?";
		}else if(progress_code == "F"){
			message = "파기 하시겠습니까?";
		}
		
			
		if(!confirm(message)) {
			return;
		}
		f0.progress_code.value = progress_code;
		getApprovalSend();
		//document.attachSFrame.setData();	//startUpload			
	}
	
	function getSumData(flag){
		var sum_SUP_AMT = 0;
		var sum_VAT_AMT = 0;
		var count = GridObj.getRowsNum();
		for(var i = 1 ; i<=count; i++){
			sum_SUP_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("SUPPLIER_PRICE")).getValue());
			sum_VAT_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("TAX_PRICE")).getValue());
		}
		if(flag == "1"){
			var nextRowId = GridObj.getRowsNum()+1;
			GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
		}
		GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_NAME")).setValue("합계");
		GridObj.cells(nextRowId,GridObj.getColIndexById("SUPPLIER_PRICE")).setValue(sum_SUP_AMT);
		GridObj.cells(nextRowId,GridObj.getColIndexById("TAX_PRICE")).setValue(sum_VAT_AMT);
		GridObj.cells(nextRowId,GridObj.getColIndexById("TOT_PRICE")).setValue(sum_VAT_AMT + sum_SUP_AMT);
		
		$("#table_sample1").val(add_comma(sum_SUP_AMT, 0));
		$("#table_sample2").val(add_comma(sum_VAT_AMT, 0));
		$("#table_sample3").val(add_comma(sum_VAT_AMT + sum_SUP_AMT, 0));
		
	}
	
	// 세금계산서 출력물 
	function doPrint(){
    	
		param = new Array();
		param[0] = "<%=house_code%>";
<%-- 		param[1] = "<%=tax_no%>"; --%>
		fnOpen("/tx/SUP_TX_REPORT", param);
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
<%--         location.href = "tax_pub_ins.jsp?inv_no=<%=inv_no%>&inv_seq=<%=inv_seq%>&gubun=" + $("#tax_type").val(); --%>
		topMenuClick("/kr/tax/tax_list.jsp", "MUO141000004" , 4, '');
        //doSelect();
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

var isKtgrm = true;
var ktgrmVal = "";
function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
   
    for(var i = 0; i < GridObj.GetRowCount(); i++){
   		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		
   	}
    
    for(var i = 0; i < GridObj.GetRowCount(); i++){
    	for(var j = i; j < GridObj.GetRowCount(); j++){
			var ktgrm_i = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("KTGRM")).getValue();
			var ktgrm_j = GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("KTGRM")).getValue();
			
			if(ktgrm_i != ktgrm_j){
				isKtgrm = false;
				break;
			}
    	}
    	ktgrmVal = ktgrm_i;
    }
    if(isKtgrm && ktgrmVal == "03"){
    	$("#ktgrm").val("03");
    }
    
   	getSumData(1);
   	
   	document.forms[0].tax_date.value = add_Slash( document.forms[0].tax_date.value );
    	//JavaCall("doQuery");
    return true;
}
function init(){
	setGridDraw();
	doSelect();
	fnChangePi();
}

function fnTaxTypeChange(){
	location.href = "tax_pub_ins.jsp?inv_no=<%=inv_no%>&inv_seq=<%=inv_seq%>&gubun=" + $("#tax_type").val();
}

function fnChangePi(){
	var valArr = $("#company_admin_sel").val().split("§");
	
	$("#company_email1").val(valArr[0] + " / " + valArr[1]);
	$("#company_admin1").val(valArr[2]);
	$("#s_tel").val(valArr[0]);
	$("#s_email").val(valArr[1]);
	$("#s_mobile_no").val(valArr[3]);		
}

//지우기
function doRemove( type ){
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value = "";
        document.forms[0].req_dept_name.value = "";
    }
}
</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->

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
<form id="form1" name="form1">
	<input type="hidden" id="status" name="status" value="<%=status%>">
	<input type="hidden" id="h_tax_no" name="h_tax_no" value="<%=wf.getValue("TAX_NO",0)%>">
	<input type="hidden" id="kind" name="kind">
	<input type="hidden" id="type_tmp" name="type_tmp" value="">
	<input type="hidden" id="attach_no" name="attach_no" value="<%=wf.getValue("ATTACH_NO",0)%>">
	<input type="hidden" id="att_mode" name="att_mode"  value="">
	<input type="hidden" id="view_type" name="view_type"  value="">
	<input type="hidden" id="file_type" name="file_type"  value="">
	<input type="hidden" id="tmp_att_no" name="tmp_att_no" value="">
	<input type="hidden" id="attach_count" name="attach_count" value="">
	<input type="hidden" id="approval_str" name="approval_str" value="">
	<input type="hidden" id="progress_code" name="progress_code" >
	<input type="hidden" id="tax_app_no" name="tax_app_no">
	<input type="hidden" id="inv_data" name="inv_data" value="<%=inv_data%>">
	<input type="hidden" id="inv_no" name="inv_no" value="<%=inv_no%>">
	<input type="hidden" id="inv_seq" name="inv_seq" value="<%=inv_seq%>">
	<input type="hidden" id="vendor_code" name="vendor_code" value="<%=wf.getValue("VENDOR_CODE",0)%>">
	
    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 세금계산서 구분</td>
      <td class="data_td" width="30%">
      	<select id="tax_type" name="tax_type" onchange="javascript:fnTaxTypeChange();" <%=disStr %> >
      		<option value="RP" <%if("RP".equals(gubun)){%>selected<%}%>>역발행</option>
      		<option value="P"  <%if("P".equals(gubun)) {%>selected<%}%>>정발행</option>
      	</select>
      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 		<input type="text" name="tax_no" id="tax_no" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("TAX_NO",0)%>" readonly="readonly">
      </td>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발행일자</td>
      <td class="data_td" width="30%">

 		<s:calendar id="tax_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" format="%Y/%m/%d" />
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <%if("P".equals(gubun)){%>
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 승인번호</td>
      <td class="data_td" width="35%" colspan="3">
 		<input type="text" name="tax_app_no_ar" id="tax_app_no_ar1" size="5" class="input_re" maxlength="4" value="<%=taxt_app_no1%>" <%=disStr %> >  &nbsp;
 		<input type="text" name="tax_app_no_ar" id="tax_app_no_ar2" size="5" class="input_re" maxlength="4" value="<%=taxt_app_no2%>" <%=disStr %> >  &nbsp;
 		<input type="text" name="tax_app_no_ar" id="tax_app_no_ar3" size="5" class="input_re" maxlength="4" value="<%=taxt_app_no3%>" <%=disStr %> >  &nbsp;
 		<input type="text" name="tax_app_no_ar" id="tax_app_no_ar4" size="5" class="input_re" maxlength="4" value="<%=taxt_app_no4%>" <%=disStr %> >
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <%}%> 
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대금지급 구분</td>
		<td class="data_td" height="150">
      		<select id="ktgrm" name="ktgrm" <%=disStr %> >
				<option value="" selected="selected">선택</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M346", wf.getValue("KTGRM",0));
	out.println(listbox1);
%>      			
      			
      		</select>
		</td>
		<%-- <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
		<td class="data_td" height="150">
			<table>
				<tr>
					<td>
						<input type="text" name="FILE_NAME" id="FILE_NAME" size="30" readonly" style="height: 14px;">
						<input type="hidden" name="ATTACH_NO" id="ATTACH_NO" ><!--  attach_key     -->
					</td>
					<td>
						<script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'TEMP')","<%=text.get("BUTTON.add-file")%>")</script>
					</td>
				</tr>
			</table>
		</td> --%>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급결의 담당부서</td>
		<td width="35%" class="data_td">
			<input type="text" name="req_dept" id="req_dept" style="ime-mode:inactive" size="15" maxlength="6"  readonly  value='' >
			<a href="javascript:PopupManager('REQ_DEPT');">
				<img src="/images/ico_zoom.gif" align="absmiddle" border="0" alt="">
			</a>
			<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
			<input type="text" name="req_dept_name" id="req_dept_name" size="20" readonly value='' >
		</td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
<br>
 <table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 	<tr>
 		<td width="15%" class="title_td" colspan="2" align="center"> 공급자</td>
 		<td width="15%" class="title_td" colspan="2" align="center"> 공급받는자</td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사업자등록번호</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_dept1" name="company_dept1" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("SUP_COM_CODE",0)%>"  readonly="readonly">
      </td>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 사업자등록번호</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_dept2" name="company_dept2" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("BUYER_IRS_NO",0)%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사명</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_name1" name="company_name1" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("SUP_COM_NAME",0)%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사명</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_name2" name="company_name2" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("BUYER_COM_NAME",0)%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대표자</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_ceo1" name="company_ceo1" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("SUP_CEO_USER_NAME",0)%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 대표자</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_ceo2" name="company_ceo2" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("BUYER_CEO_USER_NAME",0)%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
  	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업태/업종</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_type1" name="company_type1" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("SUP_BUSINESS_TYPE",0)%> / <%=wf.getValue("SUP_INDUSTRY_TYPE",0)%>" readonly="readonly">
 		<input type="hidden" id="s_biz_type" name="s_biz_type" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("SUP_BUSINESS_TYPE",0)%>" readonly="readonly">
 		<input type="hidden" id="s_ind_type" name="s_ind_type" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("SUP_INDUSTRY_TYPE",0)%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업태/업종</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" name="company_type2" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("BUYER_BUSINESS_TYPE",0)%> / <%=wf.getValue("BUYER_INDUSTRY_TYPE",0)%>" readonly="readonly">
 		<input type="hidden" id="b_biz_type" name="b_biz_type" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("BUYER_BUSINESS_TYPE",0)%>" readonly="readonly">
 		<input type="hidden" id="b_ind_type" name="b_ind_type" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("BUYER_INDUSTRY_TYPE",0)%>" readonly="readonly"> 		
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_addr1" name="company_addr1" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("SUP_ADDRESS",0).trim()%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 주소</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_addr2" name="company_addr2" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("BUYER_ADDRESS",0).trim()%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 담당자</td>
      <td class="data_td" width="35%" colspan="1">
      	<select id="company_admin_sel" name="company_admin_sel" onchange="javascript:fnChangePi();">
<%
		for(int i = 0 ; i < wf1.getRowCount() ; i++){
%>
			<option value="<%=wf1.getValue("PHONE_NO", i) + "§" + wf1.getValue("EMAIL", i) + "§" + wf1.getValue("USER_NAME", i) + "§" + wf1.getValue("MOBILE_NO", i)%>"><%=wf1.getValue("USER_NAME", i) %></option>
<%			
		}
%>      	
      	</select>
 		<input type="hidden" id="company_admin1" name="company_admin1" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("SUP_USER_ID",0)%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;  담당자</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_admin2" name="company_admin2" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=info.getSession("NAME_LOC")%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 연락처 / e-mail </td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_email1" name="company_email1" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="" readonly="readonly">
 		<input type="hidden" id="s_tel" name="s_tel" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("S_PHONE_NO",0)%>" readonly="readonly">
 		<input type="hidden" id="s_email" name="s_email" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("S_EMAIL",0)%>" readonly="readonly">
 		<input type="hidden" id="s_mobile_no" name="s_mobile_no" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("S_EMAIL",0)%>" readonly="readonly"> 		
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 연락처 / e-mail </td>
      <td class="data_td" width="35%" colspan="1">
      <%
      	String tmpTelNo = info.getSession("TEL") ;
      	if(tmpTelNo.startsWith("80002")){
      		tmpTelNo = tmpTelNo.replaceAll("80002", "3151");
      	}
      %>
      
 		<input type="text" name="company_email2" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=tmpTelNo%> / <%=info.getSession("EMAIL")%>" readonly="readonly">
 		<input type="hidden" id="b_tel" name="b_tel" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=tmpTelNo%>" readonly="readonly">
 		<input type="hidden" id="b_email" name="b_email" size="60" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="30" value="<%=wf.getValue("B_EMAIL",0)%>" readonly="readonly"> 		
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 작성일자</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_reg_date" name="company_reg_date" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("ADD_DATE",0)%>" readonly="readonly">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 과세</td>
      <td class="data_td" width="35%" colspan="1">
 		<input type="text" id="company_reg_tax" name="company_reg_tax" size="30" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="10" value="<%=wf.getValue("TAX_DIV_TXT",0)%>" readonly="readonly">
      </td>
 	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
 	<tr>
 	  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
      <td class="data_td" width="35%" colspan="3">
 		<input type="text" id="remark" name="remark" size="50" style="border: 0px; height: 14px;" maxlength="50" value="<%=wf.getValue("REMARK",0)%>">
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
<%-- 	  	  			<TD><script language="javascript">btn("javascript:doPrint();","세금계산서 인쇄")</script></TD> --%>
	  	  			
	  	  			
<%
	if(isAdmin){
		if(modifyFlag){
%>
<%-- 	 	  			<TD><script language="javascript">btn("javascript:doSave('D');","저 장")</script></TD> --%>
	 	  			<TD><script language="javascript">btn("javascript:doSave('I');","전 송")</script></TD>
<%		
		}else{
			if("-1".equals(status) || "60".equals(status) || "99".equals(status) || "-50".equals(status)){
%>
	 	  			<TD><script language="javascript">btn("javascript:doSave('F');","파 기")</script></TD>
<%		
			}
		}
	}
%>	  	  			
	  	  		</TR>
   			</TABLE>
   		</td>
 	</tr>
</table>

<s:grid screen_id="TX_003" grid_obj="GridObj" grid_box="gridbox"/>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 	<tr>
 		<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급가액</td>
      	<td class="data_td" width="15%" colspan="1">
 			<input type="text" id="table_sample1" name="table_sample1" size="15" style="background-color:#f6f6f6;border: 0px;height: 14px;" maxlength="50" value="" readonly="readonly">
      	</td>
      	<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 세액</td>
      	<td class="data_td" width="15%" colspan="1">
 			<input type="text" id="table_sample2" name="table_sample2" size="15" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="50"  value="" readonly="readonly">
      	</td>
      	<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 합계금액</td>
      	<td class="data_td" width="15%" colspan="1">
 			<input type="text" id="table_sample3" name="table_sample3" size="15" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="50"  value="" readonly="readonly">
      	</td>
      	<td width="10%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 영수/청구</td>
      	<td class="data_td" width="15%" colspan="1">
 			<input type="text" id="table_sample4" name="table_sample4" size="15" style="background-color:#f6f6f6;border: 0px; height: 14px;" maxlength="50"  value="<%=gubun_flag %>" readonly="readonly">
      	</td>
 	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</td></tr>
</table>
</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','C','TX',form1.attach_no.value,'S');</script> --%>