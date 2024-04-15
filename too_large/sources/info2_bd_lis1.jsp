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
	multilang_id.addElement("MA_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_007";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
	String WISEHUB_PROCESS_ID="MA_007";
    String house_code        = info.getSession("HOUSE_CODE");
    String company_code      = info.getSession("COMPANY_CODE");
    String user_id           = info.getSession("ID");
    String ctrl_code         = info.getSession("CTRL_CODE");
    String user_type         = info.getSession("USER_TYPE");
    
    boolean isAdmin = isAdmin(info);

    String to_date = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_date,-150);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
//<!--
var mode;
var url1;
var IDX_VENDOR_CODE;
var IDX_VENDOR_NAME;
var IDX_PURCHASE_LOCATION_NAME;
var IDX_ITEM_NO;
var IDX_DESCRIPTION_LOC;
var IDX_MDLMDLNM;
var IDX_SPECIFICATION;
var IDX_VALID_FROM_DATE;
var IDX_VALID_TO_DATE;
var IDX_UNIT_PRICE;
var IDX_CUR;
var IDX_QUOTA_PERCENT;
var IDX_CTRL_NAME;
var IDX_AUTO_PO_FLAG;
var IDX_ADD_DATE;
var IDX_EXEC_NO;
var IDX_PRICE_TYPE;
var IDX_SHIPPER_TYPE;
var IDX_DELY_TERMS;
var IDX_PAY_TERMS;
var IDX_CUM_PO_QTY;
var IDX_BASIC_UNIT;
var IDX_CTRL_CODE;
var IDX_PURCHASE_LOCATION;
var IDX_COMPANY_CODE;
var IDX_DOC_TYPE;
var IDX_DOC_SEQ;

function Init(){
	setGridDraw();
	setHeader();
}

function setHeader(){
	IDX_VENDOR_CODE            = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME            = GridObj.GetColHDIndex("VENDOR_NAME");
	IDX_PURCHASE_LOCATION_NAME = GridObj.GetColHDIndex("PURCHASE_LOCATION_NAME");
	IDX_ITEM_NO                = GridObj.GetColHDIndex("ITEM_NO");
	IDX_DESCRIPTION_LOC        = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	IDX_MDLMDLNM               = GridObj.GetColHDIndex("MDLMDLNM");
	IDX_SPECIFICATION          = GridObj.GetColHDIndex("SPECIFICATION");
	IDX_VALID_FROM_DATE        = GridObj.GetColHDIndex("VALID_FROM_DATE");
	IDX_VALID_TO_DATE          = GridObj.GetColHDIndex("VALID_TO_DATE");
	IDX_UNIT_PRICE             = GridObj.GetColHDIndex("UNIT_PRICE");
	IDX_CUR                    = GridObj.GetColHDIndex("CUR");
	IDX_QUOTA_PERCENT          = GridObj.GetColHDIndex("QUOTA_PERCENT");
	IDX_CTRL_NAME              = GridObj.GetColHDIndex("CTRL_NAME");
	IDX_AUTO_PO_FLAG           = GridObj.GetColHDIndex("AUTO_PO_FLAG");
	IDX_ADD_DATE               = GridObj.GetColHDIndex("ADD_DATE");
	IDX_EXEC_NO                = GridObj.GetColHDIndex("EXEC_NO");
	IDX_PRICE_TYPE             = GridObj.GetColHDIndex("PRICE_TYPE");
	IDX_H_PRICE_TYPE           = GridObj.GetColHDIndex("H_PRICE_TYPE");
	IDX_SHIPPER_TYPE           = GridObj.GetColHDIndex("SHIPPER_TYPE");
	IDX_DELY_TERMS             = GridObj.GetColHDIndex("DELY_TERMS");
	IDX_PAY_TERMS              = GridObj.GetColHDIndex("PAY_TERMS");
	IDX_CUM_PO_QTY             = GridObj.GetColHDIndex("CUM_PO_QTY");
	IDX_BASIC_UNIT             = GridObj.GetColHDIndex("BASIC_UNIT");
	IDX_CTRL_CODE              = GridObj.GetColHDIndex("CTRL_CODE");
	IDX_PURCHASE_LOCATION      = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	IDX_COMPANY_CODE           = GridObj.GetColHDIndex("COMPANY_CODE");
	IDX_DOC_TYPE               = GridObj.GetColHDIndex("DOC_TYPE");
	IDX_DOC_SEQ                = GridObj.GetColHDIndex("DOC_SEQ");
}

function doSelect(){
	var f0 = document.forms[0];
	f0.item_no.value        = f0.item_no.value != "" ? f0.item_no.value.toUpperCase() : "";
	f0.vendor_code.value    = f0.vendor_code.value != "" ? f0.vendor_code.value.toUpperCase() : "";
	f0.cont_seq.value    	= f0.cont_seq.value != "" ? f0.cont_seq.value.toUpperCase() : "";

	if(LRTrim(f0.po_from_date.value) != "" && LRTrim(f0.po_to_date.value) == "") {
		alert("계약일자를 확인하세요.");
		f0.po_to_date.focus();
            
		return;
	}

	if(LRTrim(f0.po_from_date.value) == "" && LRTrim(f0.po_to_date.value) != "") {
		alert("계약일자를 확인하세요.");
		f0.po_from_date.focus();
		
		return;
	}

	if(LRTrim(f0.po_from_date.value) != "") {
		if(!checkDate(del_Slash( f0.po_from_date.value ))) {
			alert("계약일자를 확인하세요.");
			f0.po_from_date.focus();
			
			return;
		}
	}

	if(LRTrim(f0.po_to_date.value) != "") {
		if(!checkDate(del_Slash( f0.po_to_date.value ))) {
			alert("계약일자를 확인하세요.");
			f0.po_to_date.focus();
			
			return;
		}
	}

	if(LRTrim(f0.po_from_date.value) != "" && LRTrim(f0.po_to_date.value) != "") {
		if(eval(del_Slash( f0.po_from_date.value )) > eval(del_Slash( f0.po_to_date.value ))) {
			alert("계약일자를 확인하세요.");
			f0.po_from_date.focus();
			
			return;
		}
	}
	
	document.forms[0].po_from_date.value = del_Slash( document.forms[0].po_from_date.value );
	document.forms[0].po_to_date.value   = del_Slash( document.forms[0].po_to_date.value   );

	G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/order.info.info2_bd_lis1";    // order/info/p2004.java
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getInfoList";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}
    
function doInsert(){
	window.open("/kr/order/info/info2_reg_ins2.jsp","info2_reg_ins2","left=100,top=100,width=800,height=450,resizable=yes,scrollbars=yes");
}

function doUpdate(){
	if(!checkRow()){
		alert("선택한 데이터가 없습니다");
		
		return;
	}
	
	for(var i = 0; i < GridObj.GetRowCount(); i ++ ){
		if(GridObj.GetCellValue("SELECTED",i) == 1){
			if(GridObj.GetCellValue("REMARK",i) == ""){
				alert("변경사유가 입력되지 않았습니다");
				
				return;
			}
		}
	}
	
	if(!confirm("계약단가 또는 계약종료일자를 변경 하시겠습니까?")) {
		return;
	}
	
	var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/order.info.info2_bd_lis1";    
    var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setUpdateInfo";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}
    
function doDelete(){
	if(!checkRow()){
		alert("선택한 데이터가 없습니다");
		
		return;
	}
	
	if(!confirm("계약단가를 삭제하면, 다시 계약을 체결해야 합니다.\n\n계약단가를 삭제 하시겠습니까?")) {
		return;
	}
    	
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/order.info.info2_bd_lis1";    
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setDeleteInfo";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function checkRow(){
	var rtn = false;
	addrow = GridObj.GetRowCount();

	for( i = 0 ; i < addrow ; i++ ){
		if ( GD_GetCellValueIndex(GridObj, i, "0" ) == true ) return true;
	}

	return rtn;
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	var f0  = document.forms[0];
	var row = GridObj.GetRowCount();
	var rowCnt = 0;

	if(msg1 == "doData") {
		doSelect();
	}

	if(msg1 == "t_imagetext") {
		if(msg3 == IDX_EXEC_NO){//품의번호
			var doc_type = GD_GetCellValueIndex(GridObj,msg2, IDX_DOC_TYPE);
			var doc_seq = GD_GetCellValueIndex(GridObj,msg2, IDX_DOC_SEQ);
			var exec_no = GD_GetCellValueIndex(GridObj,msg2, IDX_EXEC_NO);

			if(doc_type == "BS"){
				var bd_url = "/kr/dt/ebd/ebd_pp_dis9.jsp?doc_no="+exec_no+"&doc_seq="+doc_seq+"&doc_type="+doc_type;
			}
			else{
				var sign_status = "E";
				var edit = "N";
			}
		}
	}
}

function PO_FROM_DATE(year,month,day,week) {
	document.form1.PO_FROM_DATE.value=year+month+day;
}

function PO_TO_DATE(year,month,day,week) {
	document.form1.PO_TO_DATE.value=year+month+day;
}
    
function INFO_STAND_DATE(year,month,day,week) {
	document.form1.INFO_STAND_DATE.value=year+month+day;
}

// ******************************* POPUP SET ************************************

function searchProfile(fc) {
	if(fc =="vendor_code"){
		window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}

function SP0054_getCode(code, text1, text2) {
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = text1;
}

function getItem_no(item_no, desc) {
	document.forms[0].item_no.value = item_no;
	document.forms[0].description_loc.value = desc;
}

function POPUP_Open(url, title, left, top, width, height) {
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'yes';
	var resizable = 'no';
	var dim = new Array(2);

	dim = ToCenter(height,width);
	top = dim[0];
	left = dim[1];

	var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	code_search.focus();
}

function SP0149_Popup() {
// 	var left = 0;
// 	var top = 0;
// 	var width = 570;
// 	var height = 500;
// 	var toolbar = 'no';
// 	var menubar = 'no';
// 	var status = 'yes';
// 	var scrollbars = 'no';
// 	var resizable = 'no';
<%-- 	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0149&function=SP0149_Popup_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=&desc="; --%>
// 	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
	CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	$("#item_no").val(itemNo);
	$("#description_loc").val(descriptionLoc);
	
	return true;
}

function SP0149_Popup_getCode(code, text) {
	document.form1.item_no.value = code;
	document.form1.description_loc.value = text;
}
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
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name == "ITEM_NO") {	//품목코드
		var BUYER_ITEM_NO = GridObj.cells(rowId, IDX_ITEM_NO).getValue();	//GD_GetCellValueIndex(GridObj, rowId, IDX_ITEM_NO);
        PopupGeneral('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, '품목_일반정보', '0', '0', '800', '550');
    }

    if(header_name == "VENDOR_NAME") { //업체명
        var vendor_code = GridObj.cells(rowId, IDX_VENDOR_CODE).getValue();

        PopupGeneral("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=S", "ven_bd_con", '0', '0', '950', '700');
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
    }
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
        //doSelect();
    }
    else {
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
    
    document.forms[0].po_from_date.value = add_Slash( document.forms[0].po_from_date.value );
    document.forms[0].po_to_date.value   = add_Slash( document.forms[0].po_to_date.value   );
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name.value = "";
    }
    if( type == "item_no" ) {
    	document.forms[0].item_no.value = "";
        document.forms[0].description_loc.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

function doAdd(){
	window.open("info2_bd_ins1.jsp", "infoins", " width=880, height=350,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
}

<%-- 대분류 클릭 이벤트시 호출 함수 --%>
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

function clearMATERIAL_CLASS1() {
    if(form1.material_class1.length > 0) {
        for(i=form1.material_class1.length-1; i>=0;  i--) {
            form1.material_class1.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS2() {
    if(form1.material_class2.length > 0) {
        for(i=form1.material_class2.length-1; i>=0;  i--) {
            form1.material_class2.options[i] = null;
        }
    }
}

function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class1.options[form1.material_class1.length] = option1;
}

function setMATERIAL_CLASS1(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class1.options[form1.material_class1.length] = option1;
}

function setMATERIAL_CLASS2(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_class2.options[form1.material_class2.length] = option1;
}

function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.material_ctrl_type.options[form1.material_ctrl_type.length] = option1;
}

function doUploadXsl(){
	var url    = '/kr/order/info/info2_item_mgt.jsp';
	var title  = '연간단가품목등록';
	var param  = 'popup=Y';
	popUpOpen01(url, title, '700', '600', param);
}

</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000">
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
	<form name="form1" >
		<input type="hidden" name="kind"               id="kind"              />
		<input type="hidden" name="cont_seq"           id="cont_seq"          />
		<input type="hidden" name="info_stand_date"    id="info_stand_date"   />
		
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
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;생성일자</td>
										<td class="data_td" colspan="3">
											<s:calendar id="po_from_date" default_value="<%=SepoaString.getDateSlashFormat( from_date ) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="po_to_date" default_value="<%=SepoaString.getDateSlashFormat( to_date ) %>" format="%Y/%m/%d"/>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="12%" class="title_td">
											<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약업체</div>
										</td>
										<td class="data_td" width="38%">
<%
	if (!info.getSession("USER_TYPE").equals("S")) {
%>
											<input type="text" onkeydown='entKeyDown()'  name="vendor_code" id="vendor_code" style="width:30%;ime-mode:inactive" class="inputsubmit" maxlength="10" >
											<a href="javascript:searchProfile('vendor_code')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" onkeydown='entKeyDown()'  name="vendor_name" id="vendor_name" style="width:54%" class="inputsubmit">
<%
	}
	else{
%>
											<input type="text" onkeydown='entKeyDown()'  name="vendor_code" id="vendor_code" style="width:30%;ime-mode:inactive" class="inputsubmit" maxlength="10" >
											<a href="javascript:searchProfile('vendor_code')">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" onkeydown='entKeyDown()'  name="vendor_name" id="vendor_name" style="width:54%" class="inputsubmit">
<%
	}
%>
										</td>
										<td width="12%" class="title_td">
											<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</div>
										</td>
										<td class="data_td" width="38%">
											<input type="text" onkeydown='entKeyDown()'  name="item_no" id="item_no" style="width:30%;ime-mode:inactive" class="inputsubmit" >
											<a href="javascript:SP0149_Popup()">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('item_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" onkeydown='entKeyDown()'  name="description_loc" id="description_loc" style="width:54%" maxlength="20" class="inputsubmit" value="">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<%-- 대분류 --%>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
										<td class="data_td">
											<select name="material_type" id="material_type" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
												<option value="" selected="selected">전체</option>
										<%
										String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
										out.println(listbox1);
										%>
											</select>
										</td>
										<%-- 중분류 --%>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
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
									<%-- 소분류 --%>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
									<td class="data_td">
										<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
											<option value=''>전체</option>
										</select>
									</td>
									
									<%-- 세분류 --%>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
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
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
		      			<TR>
		      				<TD><script language="javascript">btn("javascript:doUploadXsl()","일괄업로드");</script></TD>
						</TR>
					</TABLE>
				</td>
      			<td height="30" align="right">
					<TABLE cellpadding="0" border="0">
		      			<TR>
							<TD><script language="javascript">btn("javascript:doSelect()","조 회");</script></TD>
							<%
								if(isAdmin){
							%>     
							<TD><script language="javascript">btn("javascript:doAdd()","단가생성");</script></TD>
							<TD><script language="javascript">btn("javascript:doUpdate()","단가변경");</script></TD>
							<TD><script language="javascript">btn("javascript:doDelete()","단가삭제");</script></TD>
							<%
							}
							%>
						</TR>
					</TABLE>
				</td>
			</tr>
		</TABLE>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="MA_007" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="xWork" width="0" height="0" border="0"></iframe>
</body>
</html>