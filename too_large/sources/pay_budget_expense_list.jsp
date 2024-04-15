<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();

	multilang_id.addElement("TX_021");
	multilang_id.addElement("TX_022");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text             = MessageUtil.getMessage(info,multilang_id);
	String  screen_id        = "TX_021";
	String  grid_obj         = "GridObj";
	String  G_IMG_ICON       = "/images/ico_zoom.gif";
    String  HOUSE_CODE       = info.getSession("HOUSE_CODE");
    String  COMPANY_CODE     = info.getSession("COMPANY_CODE");
    String  LB_MATERIAL_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
    boolean isSelectScreen   = false;
%>

<% String WISEHUB_PROCESS_ID="TX_021";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_budget_expense_list";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var mode           = "";
var G_CUR_ROW;

var click_rowId = null;
var click_rowId2 = null;

function init(){
	setGridDraw();
	setGridDraw2();
	doSelect();  
}

function doSelect(){
	document.forms[0].inv_start_date.value = del_Slash( document.forms[0].inv_start_date.value );
	document.forms[0].inv_end_date.value   = del_Slash( document.forms[0].inv_end_date.value   );
	
    mode = "getPayBugetExpense";
    
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=" + mode;
    
    params += "&grid_col_id=" + cols_ids;
    params += dataOutput();
    
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll();
    GridObj2.clearAll(); 	
    
    click_rowId = null;
    click_rowId2 = null;
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

function getVendorCode(setMethod) {
	window.open("/common/CO_014.jsp?callback=" + setMethod, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

function setVendorCode( code, desc1, desc2 , desc3) {
	$("#vendor_code").val(code);
	$("#vendor_code_name").val(desc1);
}

function doGive(){
	alert("지급 : 준비중");
}

function doCreateDoc(){
	var chkCnt      = 0;
	var params      = "";
	//var igjmCdValue = null;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			chkCnt++;
			
			if(chkCnt == 1){
				/* params      = "tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i); */
				params      = "tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq=";
			}
			else{
				/* params += "&tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i); */
				params += "&tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq=";
				
			}
		}
	}
	
	if(chkCnt == 0){
		alert("지급문서를 생성할 대상을 선택해 주세요.");
		
		return;
	}
	
	if(chkCnt > 1){
		alert("세금계산서번호를 하나만 선택해 주세요.");
		
		return;
	}

	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
		{
			mode        : "isHldy"
		},
		function(arg){
			
			var result  = eval("(" + arg + ")"); 
			var code    = result.code;
			var message = result.message;
			
			if(result != "0" ){
				alert("휴일거래 불가합니다.");
			}else if(result == "0" ){ 
				var url = "pay_bd_ins1.jsp?";				
				location.href = url + params;
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
	
}

function doModify(){
	alert("계정과목수정 : 준비중");
}

function clearMATERIAL_CTRL_TYPE() {
    if(form1.MATERIAL_CTRL_TYPE.length > 0) {
        for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
            form1.MATERIAL_CTRL_TYPE.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS1() {
    if(form1.MATERIAL_CLASS1.length > 0) {
        for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS1.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS2() {
    if(form1.MATERIAL_CLASS2.length > 0) {
        for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS2.options[i] = null;
        }
    }
}

function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function setMATERIAL_CLASS1(name, value){
    var option1 = new Option(name, value, true);
    
    form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function setMATERIAL_CLASS2(name, value){
    var option1 = new Option(name, value, true);
    
    form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
}

function MATERIAL_TYPE_Changed() {
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1(":::전체:::", "");
    setMATERIAL_CLASS2(":::전체:::", "");
 
  	var materialType     = document.getElementById("MATERIAL_TYPE");
  	var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M041";
  	param = param + "#" + materialType.value;
  
	doRequestUsingPOST( 'SL0009', param ,'MATERIAL_CTRL_TYPE', '', false);	//false:동기, true:비동기모드
	
	option.text  = ":::전체:::";
	option.value = "";
	
	materialCtrlType.add(option, 0);
	materialCtrlType.value = "";
}

function MATERIAL_CTRL_TYPE_Changed(){
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2(":::전체:::", "");
        
    var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
    var materialClass1   = document.getElementById("MATERIAL_CLASS1");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M042";
  	param = param + "#" + materialCtrlType.value;
    
    doRequestUsingPOST( 'SL0019', param ,'MATERIAL_CLASS1', '', false);
    
    option.text = ":::전체:::";
    option.value = "";
    
    materialClass1.add(option, 0);
    materialClass1.value = "";
}

function MATERIAL_CLASS1_Changed(){
    clearMATERIAL_CLASS2();
    
    var materialClass1 = document.getElementById("MATERIAL_CLASS1");
    var materialClass2 = document.getElementById("MATERIAL_CLASS2");
  	var param          = "<%=info.getSession("HOUSE_CODE")%>";
  	var option         = document.createElement("option");
  	
  	param = param + "#" + "M122";
  	param = param + "#" + materialClass1.value;
    
    doRequestUsingPOST( 'SL0089', param ,'MATERIAL_CLASS2', '', false);
    
	option.text = ":::전체:::";
	option.value = "";
    
    materialClass2.add(option, 0);
    materialClass2.value = "";
}

function SP9113_Popup() {
	window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function  SP9113_getCode(id, name) {
	//form1.purchase_id.value		= id;
	form1.purchase_name.value   = name;
}
//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var GridObj2 = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

function setGridDraw2(){
	GridObj2_setGridDraw();
	GridObj2.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected_20210626(rowId,cellInd){
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}else if(header_name == "PR_NO") {
		var prNo =  LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PR_NO") ).getValue());   
		var page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}	
}

function doOnRowSelected(rowId,cellInd)
{ 
	var left = 30;
    var top = 30;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var width = "";
    var height = "";
    /*
    if(click_rowId != rowId && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() != "C"){
	    var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
	    document.forms[0].BIZ_NO.value = biz_no;
		var params = "mode=getCtResultList";
		params += "&biz_no=" + biz_no;
		var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj2.postGrid( G_SERVLETURL, params );
		GridObj2.clearAll(false); 	   	 	   	 
    }
    */
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
    
    if( GridObj.getColIndexById("TAX_NO") == cellInd ){
		if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
	  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
	  		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&gubun=" + status + "&gubun=P";
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
	} else if( header_name == "VENDOR_NAME" ) {
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		var url    = '/s_kr/admin/info/ven_bd_con.jsp';
		var title  = '업체상세조회';
		var param  = 'popup=Y';
		param     += '&mode=irs_no';
		param     += '&vendor_code=' + vendor_code;
		popUpOpen01(url, title, '900', '700', param);
		
	}
    
    /*
	if( GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		GridObj2.clearAll(); 	 
    }
    */
    if( click_rowId != rowId){
    	GridObj2.clearAll(); 	
    	
    	var h_tax_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "TAX_NO")));
	    document.forms[0].h_tax_no.value = h_tax_no;
	    document.forms[0].inv_start_date.value = del_Slash( document.forms[0].inv_start_date.value );
		document.forms[0].inv_end_date.value   = del_Slash( document.forms[0].inv_end_date.value   );
		var params = "mode=getPayBugetExpenseList";
		//params += "&biz_no=" + biz_no;
		var cols_ids = "TAX_NO,TAX_DATE,DELY_TO_LOCATION,DELY_TO_LOCATION_NM,IGJM_CD,ACCOUNT_CODE,ACCOUNT_NM,ITEM_NO,ITEM_NM,SPECIFICATION,QTY,UNIT_PRICE,AMT,VENDOR_CODE,VENDOR_NAME,TAX_SEQ,SUBJECT,PR_NO";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj2.postGrid( G_SERVLETURL, params );
		GridObj2.clearAll(false);
		
		//var f = document.forms[0];
		//f.CT_USER_ID.value                = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
		//f.CT_USER_NAME.value              = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();		
    }
	click_rowId = rowId;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	//GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SELECTED")).setValue(0);
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
    }	
	
	
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1){
    	if(GridObj.getColIndexById("SELECTED") == cellInd){
			for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
				GridObj.cells(GridObj.getRowId(i), cellInd).setValue("0");			
			}
		}
    	GridObj.cells(rowId, cellInd).setValue("1");
    }
    else if(stage==2){
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

    alert(messsage);
    
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
    GridObj2.clearAll();
    document.forms[0].inv_start_date.value = add_Slash( document.forms[0].inv_start_date.value );
    document.forms[0].inv_end_date.value   = add_Slash( document.forms[0].inv_end_date.value   );
    
    //grid_rowspan("0-2,14-15","SELECTED,TAX_NO,TAX_DATE,VENDOR_CODE,VENDOR_NAME");
    
    return true;
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }
    else if( type == "purchase_id" ) {
    	//document.forms[0].purchase_id.value = "";
        document.forms[0].purchase_name.value = "";
    }
    else if( type == "purchase_name" ) {
    	document.forms[0].purchase_name.value = "";
    }
    
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}





function GridObj2_doQueryEnd() {
	var msg        = GridObj2.getUserData("", "message");
	var status     = GridObj2.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}



function GridObj2_doOnRowSelected(rowId,cellInd) {
	
	click_rowId2 = rowId;
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}else if(header_name == "PR_NO") {
		var prNo =  LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("PR_NO") ).getValue());   
		var page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}	
}


// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd) {
	var max_value = GridObj2.cells(rowId, cellInd).getValue();
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	} else if(stage==1) {
		
	} else if(stage==2) {
		
		
	    return true;
	}
	
	return false;    
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
<!--내용시작-->
<form id="form1" name="form1" action="">
	<input type="hidden" id="h_tax_no" name="h_tax_no"/>
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
        							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서 발행일자</td>
            						<td class="data_td">
            							<s:calendar id="inv_start_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" format="%Y/%m/%d" cssClass=" "/>
                						~
                						<s:calendar id="inv_end_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d" cssClass=" "/>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
									<td class="data_td">
										<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="12" class="inputsubmit" maxlength="10" style="ime-mode:inactive" onkeydown='entKeyDown()'>
										<a href="javascript:getVendorCode('setVendorCode')">
											<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
										</a>
										<a href="javascript:doRemove('vendor_code')">
											<img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0">
										</a>
										<input type="text" name="vendor_code_name" id="vendor_code_name" size="20" onkeydown='entKeyDown()'>			
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
									<td width="35%" class="data_td">
										<select name="MATERIAL_TYPE" onChange="javacsript:MATERIAL_TYPE_Changed();", id="MATERIAL_TYPE">
											<option value=''>:::전체:::</option>
											<%=LB_MATERIAL_TYPE%>
										</select>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
									<td width="35%" class="data_td">
										<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
											<option value=''>:::전체:::</option>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
									<td width="35%" class="data_td">
										<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" onChange="javacsript:MATERIAL_CLASS1_Changed();">
											<option value=''>:::전체:::</option>
										</select>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
									<td width="35%" class="data_td">
										<select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2">
											<option value=''>:::전체:::</option>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서번호</td>
									<td class="data_td">
            							<input type="text" id="tax_no" name="tax_no" style="ime-mode:disabled"  size="10" value='' onkeydown='entKeyDown()'>
									</td>
									<%--
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
									<td class="data_td" width="35%" colspan="3">
										<input type="text" name="purchase_id" id="purchase_id" style="ime-mode:disabled"  value="<%=info.getSession("ID")%>" size="15" class="inputsubmit" onkeydown='entKeyDown()'>
										<a href="javascript:SP9113_Popup();">
											<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
										</a>
										<a href="javascript:doRemove('purchase_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
										<input type="text" name="purchase_name" id="purchase_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly  onkeydown='entKeyDown()'>
									</td>
									--%>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서 발행자</td>
									<td class="data_td" width="35%" colspan="3">
										<input type="text" name="purchase_name" id="purchase_name" size="10" value="<%=info.getSession("NAME_LOC")%>"  onkeydown='entKeyDown()'>
										<a href="javascript:doRemove('purchase_name')">
											<img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0">
										</a>
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
    		    <font color="red" style="font-size:12px">
					* 세금계산서번호 1개만 선택 가능
				</font>	
			</td>	
    		<td height="30" align="right">
            	<TABLE cellpadding="0">
                	<TR>
                        <TD>
<script language="javascript">
btn("javascript:doSelect()"	,"조 회");
</script>
						</TD>
                        <TD>
<script language="javascript">
btn("javascript:doCreateDoc()","지급문서생성");
</script>
						</TD> 
                    </TR>
                </TABLE>
            </td>
        </tr>
    </table>
<s:grid screen_id="TX_021" grid_obj="GridObj" height="350px"/>
<s:grid screen_id="TX_022" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="450px"/>
</form>
<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
</form>
</s:header>
<%--
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
--%>
<s:footer/>
<%--
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
--%>
<%-- TOBE 2017-07-01 구 activeX 미사용 주석처리
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
--%>
</body>
</html>