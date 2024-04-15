<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_001_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_001_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String house_code = info.getSession("HOUSE_CODE");
    String inv_no	  = JSPUtil.nullToEmpty(request.getParameter("inv_no"));
    //String inv_seq    = JSPUtil.nullToEmpty(request.getParameter("inv_seq"));
    //String pr_no      = JSPUtil.nullToEmpty(request.getParameter("pr_no"));
    //String pr_seq     = JSPUtil.nullToEmpty(request.getParameter("pr_seq"));
    String prc_gb     = JSPUtil.nullToEmpty(request.getParameter("prc_gb"));
    String po_no      = JSPUtil.nullToEmpty(request.getParameter("po_no"));
	String toDays     = SepoaDate.getShortDateString();    
    String po_no11 = "";
    String po_name12 = "";
    String project_name21 = "";
    String iv_no31 = "";   //매입계산서번호
    String inv_no32 = "";
    String inv_seq41 = "";
    String app_status42 = "";
    String confirm_date1 = "";
    String po_ttl_amt51 = "";
    String inv_amt52 = "";
    String dp_amt = "";
    String vendor_name61 = "";
    String vendor_cp_name62 = "";
    String bb71 = "";
    String attach_no81 = "";
    String attach_no_1 = "";
    String inv_date98 = "";
    String inv_person_name99 = "";
    String invoice_status = "";
    String last_yn = "N";
    String exec_no = "";
    String dp_div = "";
    
    Object[] obj = {inv_no};
    SepoaOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getInvDisplay", obj);
	
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    wf.setFormat("INV_DATE","YYYY/MM/DD","DATE");
    if(wf.getRowCount() > 0) {
        po_no11           = wf.getValue("po_no11", 0);
        po_name12         = wf.getValue("po_name12", 0);
        project_name21    = wf.getValue("project_name21", 0);
        inv_no32          = wf.getValue("inv_no32", 0);
        inv_seq41         = wf.getValue("inv_seq41", 0);
        app_status42      = wf.getValue("app_status42", 0);
        confirm_date1     = wf.getValue("confirm_date1", 0);
        
        if(confirm_date1.equals("//")) {
        	confirm_date1 = "미완료";	
        }
        
        po_ttl_amt51      = wf.getValue("po_ttl_amt51", 0);
        inv_amt52         = wf.getValue("inv_amt52", 0);
        dp_amt            = wf.getValue("dp_amt", 0);
        vendor_name61     = wf.getValue("vendor_name61", 0);
        vendor_cp_name62  = wf.getValue("vendor_cp_name62", 0);
        bb71              = wf.getValue("bb71", 0);
        attach_no81       = wf.getValue("attach_no81", 0);
        attach_no_1       = wf.getValue("attach_no_1", 0);
        inv_date98        = wf.getValue("inv_date98", 0);
        inv_person_name99 = wf.getValue("inv_person_name99", 0);
        invoice_status	  = wf.getValue("sign_status", 0);
        last_yn			  = wf.getValue("LAST_YN", 0);
        exec_no	  		  = wf.getValue("EXEC_NO", 0);
        dp_div			  = wf.getValue("DP_DIV", 0);
    }
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
<!--
var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_dis1";
var mode;
var IDX_SEL;
var IDX_ITEM_NO;
var IDX_DESCRIPTION_LOC;
var IDX_UNIT_PRICE;
var IDX_INV_QTY;
var IDX_GR_QTY;
var IDX_GR_AMT;

function setHeader(){
	IDX_SEL = GridObj.GetColHDIndex("SEL");
	IDX_ITEM_NO = GridObj.GetColHDIndex("ITEM_NO");
	IDX_DESCRIPTION_LOC = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	IDX_UNIT_PRICE = GridObj.GetColHDIndex("UNIT_PRICE");
	IDX_INV_QTY = GridObj.GetColHDIndex("INV_QTY");
	IDX_GR_QTY = GridObj.GetColHDIndex("GR_QTY");
	IDX_GR_AMT = GridObj.GetColHDIndex("EXPECT_AMT");
		
	doSelect();
}

function doSelect(){
	var servletUrl2 = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_detail";
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=grid_top&grid_col_id="+grid_col_id;
	
	param += "&inv_no=<%=inv_no%>";
	param += dataOutput();
	
	GridObj.post(servletUrl2, param);
	GridObj.clearAll(false);
}

function calculate_gr_amt(wise, row){
	var GR_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_GR_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3); // 소숫점 두자리까지 계산
	
	GD_SetCellValueIndex(GridObj,row,IDX_GR_AMT,setAmt(GR_AMT));
}

var summaryCnt = 0;

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var f0              = document.forms[0];
	var row             = GridObj.GetRowCount();
	var po_no           = "";
	var shipper         = "";
	var sign_flag       = "";
        
	if(msg1 == "doQuery") {
		var tmp_camt = 0;
		var c_amt = 0;
		var maxRow = GridObj.GetRowCount();
	}
        
	if(msg1 == "doData") {
		window.close();
		opener.doSelect();
	}
    	
	// 검수수량이 변경될 경우 검수금액 계산
	if(msg1 == "t_insert") {
		if(msg3 == IDX_GR_QTY) {
			calculate_gr_amt(GridObj, msg2);
<%
	if(last_yn.equals("Y")){	//마지막 검수완료 차수일경우 수량이 안맞는 경우를 대비해 검수요청 수량만큼 금액을 보정해준다.
%>
			if(GridObj.GetCellValue("INV_QTY", msg2) == GridObj.GetCellValue("GR_QTY", msg2)){
				GridObj.SetCellValue("EXPECT_AMT", msg2, GridObj.GetCellValue("LAST_EXPECT_AMT", msg2));
			}
<%
	}
%>
		}
	}
		
	if(msg1 == "t_imagetext") {
		if(msg3 == IDX_ITEM_NO) {
			item_no = GD_GetCellValueIndex(GridObj,msg2,IDX_ITEM_NO);
			
			window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
		}
	}
}

function Add_file(){
	var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	
	FileAttach('INV',ATTACH_NO_VALUE,'VI');
}

/*
파일첨부 팝업에서 받아오는 화면
*/
function setAttach(attach_key, arrAttrach, rowId, attach_count){
	
	/* 
	var f = document.forms[0];
	
	f.attach_no.value = attach_key;
	f.attach_count.value = attach_count;
	 */
	
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
	
	document.forms[0].attach_no_1.value = attach_key;
	document.forms[0].FILE_NAME_1.value = result;
	
}

function valid_date(year,month,day,week) {
	var f0 = document.forms[0];
	
	f0.confirm_date1.value=year+month+day;
}

/**
 * 입고 및 검수 승인하기
 */
function Approval(sign_status){
	var iRowCount         = GridObj.GetRowCount();
	var iCheckedCount     = 0;
	var comfirm_date1_str = "";
	var gr_amt            = 0;
	var inv_qty           = 0;
	var gr_qty            = 0;
	var isMsg             = 0;  //합격수량이 납품수량 미달인 품목수
	var iGrZeroCount   = 0;  //합격수량이 0인 품목수
	var seCount           = "";
	var materialClass2    = "";
	var description_loc   = "";
	
	var confirm_date1 = del_Slash( document.forms[0].confirm_date1.value );
	
	if( !checkDateCommon( confirm_date1 ) ) {
		alert(" 검수완료일자를 확인 하세요. ");
		document.forms[0].confirm_date1.focus();
		
		return;
	}
	
	comfirm_date1_str = confirm_date1.substr(0,4) + "년" + confirm_date1.substr(4,2) + "월" + confirm_date1.substr(6,2) + "일";
	
	for(var i = 0; i < iRowCount-1; i++) {
		GridObj.enableSmartRendering(true);
		GridObj.selectRowById(GridObj.getRowId(i), false, true);
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
	    	
		if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1") {
			inv_qty        = GD_GetCellValueIndex(GridObj,i,IDX_INV_QTY);
			gr_qty         = GD_GetCellValueIndex(GridObj,i,IDX_GR_QTY);
			gr_amt         += parseInt(GD_GetCellValueIndex(GridObj,i,IDX_GR_AMT));
			materialClass2         = GD_GetCellValueIndex(GridObj,i,GridObj.getColIndexById("MATERIAL_CTRL_TYPE"));
			seCount         = GD_GetCellValueIndex(GridObj,i,GridObj.getColIndexById("SE_COUNT"));
			
			if (Number (inv_qty) < Number (gr_qty)) { // 합격수량이 납품수량보다 클수는 없다.
				alert('합격수량이 납품수량보다 클수는 없습니다.');
			
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = false;
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("0");
				
				return;
			}
			
			if (Number (inv_qty) > Number (gr_qty)) { // 납품수량이 합격수량보다 클경우 반송사유를 입력하도록 한다.
				if (document.forms[0].sign_remark.value == "") {
					alert('반송 품목이 존재합니다.\n\n반송을 하는 경우에는 반송사유를 입력해야 합니다.');
					
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = false;
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("0");
					
					return;
				}
			
				isMsg++;
			}
			
			if( Number (gr_qty) == 0 ){
				iGrZeroCount++;		
			}
			
// 			if((materialClass2 == "01020") && (seCount == "0") && (gr_qty != "0")){
// 				alert("중요증서 품목은 입고 정보를 입력하셔야 합니다.");
				
// 				return;
// 			}
		}
		
		if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "false") {
			iCheckedCount++;
		}
	}
		
	if(iCheckedCount > 1) {
		alert("선택되지 않은 항목이 있습니다.");
		
		return;
	}
	
	for(var j = 0; j < iRowCount; j++) {
		if(GD_GetCellValueIndex(GridObj,j,IDX_SEL) == "1") {
			description_loc         = GD_GetCellValueIndex(GridObj,j,GridObj.getColIndexById("DESCRIPTION_LOC"));
			if(description_loc == "합계"){
				GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("SEL")).cell.wasChanged = false;
				GridObj.cells(GridObj.getRowId(j), GridObj.getColIndexById("SEL")).setValue("0");
			}
		}
	}
	
	if( iGrZeroCount == (iRowCount-1) ){
	 	sign_status = "R";     //불합격	 	
	}else if( isMsg>0 ){
	    sign_status = "RE";   //일부합격	    
	}else{
	    sign_status = "E1";   //검수완료
	}

	var addStr = "";
		
	if(isMsg > 0){
		addStr = "합격되지 않은 수량은 공급업체로 반송됩니다. \n\n";
	}
		
	var Message = addStr + comfirm_date1_str+"로 입고("+  add_comma(gr_amt,0)+"원) 및 검수 완료하시겠습니까?";
	
	
	var cskd_gb = getCskdGb();
	if(cskd_gb == "01" || cskd_gb == "02" || cskd_gb == "03" || cskd_gb == "05"){
		if(sign_status == "E1"){
			if(document.forms[0].eval_user_id.value == ""){
				alert("공사평가자를 선택하세요.\r\n\r\n(입찰담당 기술역으로 지정)");
				document.forms[0].eval_user_id.focus();
				return;
			}
			document.form1.cskd_gb.value = cskd_gb;
		}
		        
	}
	
	if(confirm(Message)) {
		getApproval(sign_status);
	}
	
	return;
}

function getApproval(approval_str){
	document.form1.sign_status.value = approval_str;
	
	var tot_amt = 0;
	var rowcount = (GridObj.GetRowCount())-1;
	
	for(var i = 0; i < rowcount;i++) {
		tot_amt = tot_amt + new Number(GridObj.GetCellValue("EXPECT_AMT", i));
		document.form1.inv_tot_amt.value = tot_amt;
	}
	
	document.form1.confirm_date1.value = del_Slash(document.form1.confirm_date1.value);
	
	var f = document.forms[0];
	var servletUrl1 = "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_lis2";
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=approval";		

	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(servletUrl1, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}

/**
 * 검수 취소처리
 */
function Tly_Cancel(){
	var iRowCount = GridObj.GetRowCount();

	if(!confirm("검수취소처리를 하시겠습니까?")){
		return;
	}

	for(var i = 0; i < iRowCount-1; i++) {
		GridObj.enableSmartRendering(true);
		
		GridObj.selectRowById(GridObj.getRowId(i), false, true);
		
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
	}

	var f = document.forms[0];
	var servletUrl1 = "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_lis2";
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=Tly_Cancel";

	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(servletUrl1, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}

function File_Attach(){
	var iRowCount = GridObj.GetRowCount();

	if(!confirm("파일추가 하시겠습니까?")){
		return;
	}

	for(var i = 0; i < iRowCount-1; i++) {
		GridObj.enableSmartRendering(true);
		
		GridObj.selectRowById(GridObj.getRowId(i), false, true);
		
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
	}

	var f = document.forms[0];
	var servletUrl1 = "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_lis2";
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=attachFile";

	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(servletUrl1, params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
}

/**
 * 파일추가
 */
function File_Attach2(){
	var iRowCount         = GridObj.GetRowCount();
	var iCheckedCount     = 0;
	var comfirm_date1_str = "";
	var gr_amt            = 0;
	var inv_qty           = 0;
	var gr_qty            = 0;
	var isMsg             = 0;  //합격수량이 납품수량 미달인 품목수
	var iGrZeroCount   = 0;  //합격수량이 0인 품목수
	var seCount           = "";
	var materialClass2    = "";
	
	var confirm_date1 = del_Slash( document.forms[0].confirm_date1.value );
	
	if( !checkDateCommon( confirm_date1 ) ) {
		alert(" 검수완료일자를 확인 하세요. ");
		document.forms[0].confirm_date1.focus();
		
		return;
	}
	
	comfirm_date1_str = confirm_date1.substr(0,4) + "년" + confirm_date1.substr(4,2) + "월" + confirm_date1.substr(6,2) + "일";
	
	for(var i = 0; i < iRowCount-1; i++) {
		GridObj.enableSmartRendering(true);
		GridObj.selectRowById(GridObj.getRowId(i), false, true);
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("1");
	    	
		if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "1") {
			inv_qty        = GD_GetCellValueIndex(GridObj,i,IDX_INV_QTY);
			gr_qty         = GD_GetCellValueIndex(GridObj,i,IDX_GR_QTY);
			gr_amt         += parseInt(GD_GetCellValueIndex(GridObj,i,IDX_GR_AMT));
			materialClass2         = GD_GetCellValueIndex(GridObj,i,GridObj.getColIndexById("MATERIAL_CTRL_TYPE"));
			seCount         = GD_GetCellValueIndex(GridObj,i,GridObj.getColIndexById("SE_COUNT"));
			
			if (Number (inv_qty) < Number (gr_qty)) { // 합격수량이 납품수량보다 클수는 없다.
				alert('합격수량이 납품수량보다 클수는 없습니다.');
			
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = false;
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("0");
				
				return;
			}
			
			if (Number (inv_qty) > Number (gr_qty)) { // 납품수량이 합격수량보다 클경우 반송사유를 입력하도록 한다.
				if (document.forms[0].sign_remark.value == "") {
					alert('반송 품목이 존재합니다.\n\n반송을 하는 경우에는 반송사유를 입력해야 합니다.');
					
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).cell.wasChanged = false;
					GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SEL")).setValue("0");
					
					return;
				}
			
				isMsg++;
			}
			
			if( Number (gr_qty) == 0 ){
				iGrZeroCount++;		
			}
			
// 			if((materialClass2 == "01020") && (seCount == "0") && (gr_qty != "0")){
// 				alert("중요증서 품목은 입고 정보를 입력하셔야 합니다.");
				
// 				return;
// 			}
		}
		
		if(GD_GetCellValueIndex(GridObj,i,IDX_SEL) == "false") {
			iCheckedCount++;
		}
	}
		
	if(iCheckedCount > 1) {
		alert("선택되지 않은 항목이 있습니다.");
		
		return;
	}
	
	
	sign_status = "F";   //파일추가

	var addStr = "";
		
	if(isMsg > 0){
		addStr = "합격되지 않은 수량은 공급업체로 반송됩니다. \n\n";
	}
		
	var Message = addStr + comfirm_date1_str+"로 입고("+  add_comma(gr_amt,0)+"원) 및 검수 완료하시겠습니까?";
	
	if(confirm(Message)) {
		getApproval(sign_status);
	}
	
	return;
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
	if(GridObj.getColIndexById("INV_INFO") == cellInd){
		var inv_seq          = GridObj.cells(rowId, GridObj.getColIndexById("INV_SEQ")).getValue(); 
		var item_no          = GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO")).getValue();
		var item_nm          = GridObj.cells(rowId, GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
		var inv_qty          = GridObj.cells(rowId, GridObj.getColIndexById("GR_QTY")).getValue();
		var item_qty         = GridObj.cells(rowId, GridObj.getColIndexById("INV_QTY")).getValue();
		var unit_measure     = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_MEASURE")).getValue();
		var materialClass2   = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CLASS2")).getValue();
		var materialCtrlType = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CTRL_TYPE")).getValue();
		
		if(
			("01030" == materialCtrlType) ||
			("01020" == materialCtrlType) ||
			("03091" == materialCtrlType)
		){
			var params = "?inv_no=<%=inv_no%>";
			
			params = params + "&po_no=<%=po_no%>";
			params = params + "&inv_seq=" + inv_seq;
			params = params + "&item_no=" + item_no;
			params = params + "&item_nm=" + item_nm;
			params = params + "&inv_qty=" + inv_qty;
			params = params + "&unit_measure=" + unit_measure;
			params = params + "&materialClass2=" + materialClass2;
			params = params + "&materialCtrlType=" + materialCtrlType;
				
			if(Number(inv_qty) == 0){
				alert("합격수량을 입력해 주세요.");
				return;
			}
			
			if(Number(inv_qty) > Number(item_qty)){
				alert("합격수량은 납품수량을 넘을 수 없습니다.");
				return;
			}
				
			window.open("inv1_info.jsp" + params,"ivInfo","width=800,height=550,resizable=YES,scrollbars=YES,status=yes,top=0,left=0");
		}
		else{
			alert("물류입고 정보 입력 대상 품목이 아닙니다.");
			
			return;
		}
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
    else if(stage==1) {}
    else if(stage==2) {
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if( header_name == "GR_QTY"){
			var gr_qty = GridObj.cells(rowId, GridObj.getColIndexById("GR_QTY")).getValue();
			var unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
			GridObj.cells(rowId, GridObj.getColIndexById("EXPECT_AMT")).setValue(gr_qty * unit_price);
			getSumData(2);
		}
    	
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
        opener.doSelect();
        window.close();
    }
    else{
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

    if(status == "0"){
    	alert(msg);
    }
    
    document.form1.confirm_date1.value = add_Slash(document.form1.confirm_date1.value);
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    getSumData(1);
    var cskd_gb = getCskdGb();
    if(cskd_gb == "01" || cskd_gb == "02" || cskd_gb == "03" || cskd_gb == "05"){
    	setEval(true);
    }else{
    	setEval(false);
    }
    
    return true;
}

function getSumData(flag){
	var sum_INV_QTY = 0;
	var sum_GR_QTY = 0;
	var sum_EXPECT_AMT = 0;
	var count = GridObj.getRowsNum();
	
	if(flag =="2"){
		count--;
	}
	
	for(var i = 1 ; i<=count; i++){
		sum_INV_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("INV_QTY")).getValue());
		sum_GR_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("GR_QTY")).getValue());
		sum_EXPECT_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("EXPECT_AMT")).getValue());
	}
	
	if(flag == "1"){
		var nextRowId = GridObj.getRowsNum()+1;
		GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
	}
	else if(flag == "2"){
		var nextRowId = GridObj.getRowsNum();
	}
	
	GridObj.cells(nextRowId,GridObj.getColIndexById("DESCRIPTION_LOC")).setValue("합계");
	GridObj.cells(nextRowId,GridObj.getColIndexById("INV_QTY")).setValue(sum_INV_QTY);
	GridObj.cells(nextRowId,GridObj.getColIndexById("GR_QTY")).setValue(sum_GR_QTY);
	GridObj.cells(nextRowId,GridObj.getColIndexById("EXPECT_AMT")).setValue(sum_EXPECT_AMT);
}

//공사평가자
function eval_user_Popup(type_tmp) {
	window.open("/common/CO_008.jsp?callback=eval_user_callback", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function  eval_user_callback(ls_ctrl_person_id, ls_ctrl_person_name) {
	form1.eval_user_id.value         = ls_ctrl_person_id;
	form1.eval_user_name.value       = ls_ctrl_person_name;
}

function setEval(isDisplay){
	if(isDisplay){
		document.all("trEval1").style.display = "";
		document.all("trEval2").style.display = "";
	}else{
		document.all("trEval1").style.display = "none";
		document.all("trEval2").style.display = "none";
	}
	
}

//지우기
function doRemove(){
    document.forms[0].eval_user_id.value = "";
    document.forms[0].eval_user_name.value = "";
}

function getCskdGb(){
	var count = GridObj.getRowsNum();
	var item_no = "";
	var retCskdGb = "";
	if(count == 2){
		item_no = GridObj.cells(1,GridObj.getColIndexById("ITEM_NO")).getValue();
		if(item_no != null && item_no.length == 7 && item_no.substring(0,1) == "K"){
			retCskdGb = item_no.substring(5);
		}
	}
	return retCskdGb;
}

function init(){
	document.forms[0].attach_no_1.value = "<%=attach_no_1%>";
}

</script>
</head>
<body onload="javascript:setGridDraw();setHeader();init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">
	<form name="form1" >
		<input type="hidden" id="kind" name="kind">
		<input type="hidden" id="attach_no" name="attach_no" value="<%=attach_no81%>">
		<input type="hidden" id="attach_count" name="attach_count" value="">
		<input type="hidden" id="attach_count_1" name="attach_count_1" value="">
	                          
		<input type="hidden" id="att_mode" name="att_mode"  value="">
		<input type="hidden" id="view_type" name="view_type"  value="">
		<input type="hidden" id="file_type" name="file_type"  value="">
		<input type="hidden" id="tmp_att_no" name="tmp_att_no" value="">
	                        
		<input type="hidden" id="house_code" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" id="company_code" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" id="dept_code" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" id="req_user_id" name="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" id="fnc_name" name="fnc_name" value="getApproval">
		<input type="hidden" id="approval_str" name="approval_str" value="">
		<input type="hidden" id="sign_status" name="sign_status" value="N">
		<input type="hidden" id="doc_type" name="doc_type" value="INV">
		                    
		<input type="hidden" id="last_yn"     name="last_yn"     value="<%=last_yn%>">
		<input type="hidden" id="exec_no"     name="exec_no"     value="<%=exec_no%>">
		<input type="hidden" id="dp_div"      name="dp_div"      value="<%=dp_div%>">
		<input type="hidden" id="inv_no"      name="inv_no"      value="<%=inv_no%>">
		<input type="hidden" id="inv_tot_amt" name="inv_tot_amt" value="">
	
		<input type="hidden" id="cskd_gb"     name="cskd_gb"     value="">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<%
					if (prc_gb.equals("I")) {
				%>
				<td align="left" class='title_page'>입고 및 검수처리</td>
				<%
					}
				%>
				<%
					if (prc_gb.equals("D")) {
				%>
				<td align="left" class='title_page'>검수취소처리</td>
				<%
					}
				%>
				<%
					if (prc_gb.equals("F")) {
				%>
				<td align="left" class='title_page'>파일추가</td>
				<%
					}
				%>

			</tr>
		</table>
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주번호</td>
										<td width="35%" class="data_td"><%=po_no11%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주명</td>
										<td width="35%" class="data_td"><%=po_name12%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수요청일자</td>
										<td class="data_td"><%=app_status42%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수완료일자 <font color="red"><b>*</b></font></td>
										<td class="data_td">
											<s:calendar id="confirm_date1" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />   
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수요청번호</td>
										<td class="data_td"><%=inv_no32%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 요청차수</td>
										<td class="data_td"><%=inv_seq41%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주총금액<br>&nbsp;&nbsp;&nbsp;(VAT포함)</td>
										<td class="data_td"><%=po_ttl_amt51%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수후잔액<br>&nbsp;&nbsp;&nbsp;(VAT포함)</td>
										<td class="data_td"><%=inv_amt52%></td>
									</tr>  
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급업체</td>
										<td class="data_td"><%=vendor_name61%></td>
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급업체담당자</td>
										<td class="data_td"><%=vendor_cp_name62%></td>
									</tr>
									<tr style="display: none;">
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 보증보험증권</td>
										<td colspan="3" class="data_td"><%=bb71%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
								<%
									if (prc_gb.equals("I") || prc_gb.equals("F")) {
								%>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
										<td class="data_td" colspan="3" height="150" align="center">
											<table border="0" style="padding-top: 10px; width: 100%;">
												<tr>
													<td>
														<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no81%>&view_type=VI" style="width: 100%;height: 90px; border: 0px;" frameborder="0" ></iframe>
													</td>
												</tr>
											</table>
										</td>		
									</tr>									
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
								<%
									}
								%>										
								<%
									if (prc_gb.equals("F")) {
								%>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수자 첨부파일</td>
										<td class="data_td" colspan="3" height="150" align="center">
											<table border="0" style="padding-top: 10px; width: 100%;">
												<tr>
													<td>
														<iframe id="attachFrm2" name="attachFrm2" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=attach_no_1%>&view_type=VI" style="width: 100%;height: 90px; border: 0px;" frameborder="0" ></iframe>
													</td>
												</tr>
											</table>
										</td>		
									</tr>									
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
								<%
									}
								%>		
								
								<%
									if (prc_gb.equals("I") || prc_gb.equals("F")) {
								%>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;검수자 첨부파일</td>
										<td class="data_td" colspan="3">
								    		<TABLE >
								      			<TR>
								      				<td><input type="text" name="FILE_NAME_1" id="FILE_NAME_1" class="inputsubmit" size="80" readonly></td>
													<td><input type="hidden" name="attach_no_1" id="attach_no_1"><!--  attach_key     --></td>
											        <td><script language="javascript">btn("javascript:attach_file(document.forms[0].attach_no_1.value,'TEMP')","<%=text.get("BUTTON.add-file")%>")</script></td>
								   	  			</TR>
											</TABLE>
							    		</td>
									</tr>									
								<%
									}
								%>		
								
								<%
									if (prc_gb.equals("I")) {
								%>	
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 반송사유<br>(불합격 수량이 있는 경우 작성)</td>
										<td class="data_td" colspan="3">
											<textarea id="sign_remark" name="sign_remark" class="inputsubmit" rows="4" style="width:98%"></textarea>
										</td>
									</tr> 
								<%
									}
								%>	
								    <tr>
										<td id="trEval1" style="display:none" colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
								    <tr id="trEval2" style="display:none">								
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공사평가자</td>
										<td class="data_td" colspan="3">
								        	<b><input type="text" name="eval_user_id" id="eval_user_id" style="ime-mode:inactive" size="15" class="inputsubmit" onkeydown='entKeyDown()' >
									        <a href="javascript:eval_user_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
									        <a href="javascript:doRemove()"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
								       		<input type="text" name="eval_user_name" id="eval_user_name" size="10" class="input_data2" readOnly onkeydown='entKeyDown()' ></b>
								       		<font color="red" style="font-size:12px">
												* 입찰담당 기술역으로 지정
											</font>								        									        	
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
							<TD>
<script language="javascript">
<%
if (prc_gb.equals("I")) {
%>
btn("javascript:Approval('E1')","검수완료");
<%
}
%>
<%
if (prc_gb.equals("D")) {
%>
btn("javascript:Tly_Cancel()","검수취소");
<%
}
%>
<%
if (prc_gb.equals("F")) {
%>
btn("javascript:File_Attach()","파일추가");
<%
}
%>

</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:window.close()","닫 기");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
		<s:grid screen_id="IV_001_1" grid_obj="GridObj" grid_box="gridbox"/>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<iframe src="" name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>
</s:header>
<s:footer/>
</body>
</html>