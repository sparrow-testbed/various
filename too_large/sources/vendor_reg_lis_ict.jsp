<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SU_101");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SU_101";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
%>
<% String WISEHUB_PROCESS_ID="I_SU_101";%>
<!-- 업체등록관리/등록업체목록-->

<%
	String company_code = info.getSession("COMPANY_CODE");
%>
<html>
<head>
<!-- META TAG 정의  -->
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" type="text/javascript">
//<!--

	var INDEX_SELECTED;
	var INDEX_NUM;
	var INDEX_NAME_LOC;
	var INDEX_SG_NAME;
	var INDEX_REQUEST_DATE;

	var INDEX_PROGRESS_STATUS;
	var INDEX_SCREENING_STATUS;
	var INDEX_CHECKLIST_STATUS;
	var INDEX_VENDOR_CODE;
	var INDEX_PROGRESS_STATUS_NAME;

	var INDEX_SG_REFITEM;
	var INDEX_VENDOR_SG_REFITEM;
	var INDEX_VNCP_CNT;
	
	var INDEX_GB_GJ;
	var INDEX_GB_GJ_NM;
	
	var mode = "";

	function Init(){
		setGridDraw();
		setHeader();
		doSelect();
	}
	
	function setHeader() {

		GridObj.SetDateFormat("request_date","yyyy/MM/dd");

		INDEX_SELECTED         = GridObj.GetColHDIndex("SELECTED");
		INDEX_NUM              = GridObj.GetColHDIndex("NUM");
		INDEX_NAME_LOC         = GridObj.GetColHDIndex("NAME_LOC");
		INDEX_SG_NAME          = GridObj.GetColHDIndex("SG_NAME");
		INDEX_REQUEST_DATE     = GridObj.GetColHDIndex("REQUEST_DATE");

		INDEX_PROGRESS_STATUS  = GridObj.GetColHDIndex("PROGRESS_STATUS");
		INDEX_SCREENING_STATUS = GridObj.GetColHDIndex("SCREENING_STATUS");
		INDEX_CHECKLIST_STATUS = GridObj.GetColHDIndex("CHECKLIST_STATUS");
		INDEX_VENDOR_CODE      = GridObj.GetColHDIndex("VENDOR_CODE");
		INDEX_PROGRESS_STATUS_NAME = GridObj.GetColHDIndex("PROGRESS_STATUS_NAME");

		INDEX_SG_REFITEM        = GridObj.GetColHDIndex("SG_REFITEM");
		INDEX_VENDOR_SG_REFITEM = GridObj.GetColHDIndex("VENDOR_SG_REFITEM");
		INDEX_VNCP_CNT          = GridObj.GetColHDIndex("VNCP_CNT");
		
		INDEX_GB_GJ             = GridObj.GetColHDIndex("GB_GJ");
		INDEX_GB_GJ_NM          = GridObj.GetColHDIndex("GB_GJ_NM");

		
	}

	//Data Query해서 가져오기
	function doSelect() {
		var vendor_name      = document.form.vendor_name.value;
		var progress_status  = document.form.progress_status.value;
		var screening_status = document.form.screening_status.value;
		var checklist_status = document.form.checklist_status.value;
		var company_code = "<%= company_code %>";

		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.master.register.vendor_reg_lis_ict";
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getVendorSgLst";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
	}

	function progress_Changed() {

		f= document.form;
		f.progress_status.value = f.progress_sel.options[f.progress_sel.selectedIndex].value;

	}

	function screening_Changed() {
		f= document.form;
		f.screening_status.value = f.screening_sel.options[f.screening_sel.selectedIndex].value;

	}

	function checklist_Changed() {
		f= document.form;
		f.checklist_status.value = f.checklist_sel.options[f.checklist_sel.selectedIndex].value;
	}

	function popup(url, flag) {
		var left = 0;
		var top = 0;
		var width = 800;
		var height = 230;

		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'yes';

		if(flag == 2){
			width = 700;
			height = 230;
			scrollbars = 'yes';
			resizable = 'yes';
		}

		var doc = window.open( url, 'doc', 'left=250, top=50, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	//enter를 눌렀을때 event발생
	function entKeyDown(){
  		if(event.keyCode==13) {
   			window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
   			doSelect();
  		}
  	}


  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5){
		 for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					////GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}


		if(msg1 == "doData")
		{
			var status= GD_GetParam(GridObj,1);

			if(GridObj.GetStatus() == "1"){
				alert("작업이 정상적으로 수행되었습니다.\n\n[시스템관리>사용자관리>사용자현황]에서 접속가능여부 수정후 접속 가능합니다.");
				doSelect();
			}
			else{
				alert("처리 중 에러가 발생 하였습니다.");
			}
			return;

		}
	}

	function onRefresh() {
		setGridDraw();
		setHeader();
	}

	function check_sign(){
		var sel_row = 0;
		for(var i=0;i<GridObj.GetRowCount();i++) {
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			if(temp == "true") {
				sel_row++;

				if(GridObj.GetCellValue("REGISTRY_FLAG", i) != "P"){
					alert("신청현황이 '승인대기'가 아닙니다.");
					return false;
				}
			}
		}

		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return false;
		}

		return true;
	}

	/* 삭제 */
	function deleteVendor() {

		var rowCnt = 0;
		var rowId = -1;
		var vendor_code = "";
		
		for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
			if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
				rowCnt++;
				rowId = GridObj.getRowId(i);
				vendor_code = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();
			}
		}
		
		if(rowCnt == 0){
			alert("선택된 행이 없습니다.");
			return;
		}else if(rowCnt > 1){
			alert("하나의 행만 선택해주세요.");
			return;		
		}
		
		var value = confirm('해당정보가 모두 삭제됩니다. 계속하시겠습니까?');
		if(value){
			//this.hiddenframe.location.href = "vendor_reg_ins_ict.jsp?mode=delete";

			f = document.form;
			f.vendor_code.value = vendor_code;
			f.mode.value = "delete";
			f.flag.value = "";
			
			f.target="hiddenframe";
			f.action = "vendor_reg_ins_ict.jsp";
			//return;
			f.submit();
		
		
		}
	}

    function Vendor_Search()
	{
    	window.open("/common/CO_014.jsp?callback=getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}

    function getCode(v0,v1,v2)
	{
		document.forms[0].vendor_code.value = v0;
	}

	function approval(sign_status){
		mode = sign_status;
		if(!check_sign()) return;

		var value = "";
		if(sign_status == "E"){
			value = confirm('승인 하시겠습니까?');
		}
		else{
			value = confirm('반려 하시겠습니까?');
		}

		if(!value){
			return;
		}

	    servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_ins6";
	    
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


function approvalPop(){
	var rowCnt = 0;
	var rowId = -1;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowCnt++;
		}
	}
	
	if(rowCnt == 0){
		alert("선택된 행이 없습니다.");
		return;
	}else if(rowCnt > 1){
		alert("하나의 행만 선택해주세요.");
		return;		
	}
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowId = GridObj.getRowId(i);
		}
	}
	

	//if(GridObj.cells(rowId, GridObj.GetColHDIndex("REGISTRY_FLAG_NAME")).getValue() != "대기") {
	//	alert("대기 건만 승인할 수 있습니다.");
	//	return;
	//}
	
	doOnRowSelected(rowId, INDEX_PROGRESS_STATUS_NAME);
}

/*반려처리*/
function doReject(){
	var url = "/ict/kr/master/register/vendor_rej_pop_ict.jsp";
	var left = 150;
	var top = 150;
	var width = 600;
	var height = 300;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'yes';
	var resizable = 'no';
	var vendor_code = "";

	
	var rowCnt = 0;
	var rowId = -1;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowCnt++;
		}
	}
	
	if(rowCnt == 0){
		alert("선택된 행이 없습니다.");
		return;
	}else if(rowCnt > 1){
		alert("하나의 행만 선택해주세요.");
		return;		
	}
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if("1" == GridObj.cells(GridObj.getRowId(i), INDEX_SELECTED).getValue()){
			rowId = GridObj.getRowId(i);
			vendor_code       = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();
			url = url + "?vendor_code="+vendor_code;
		}
	}
	
	var Win = window.open( url, 'REJECT_REASON', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	Win.focus();
	return;	
	
}

/* 반려처리 */
function setREJECT_REASON(reject_reason, vendor_code){
	
	f = document.form;
	f.mode.value = "register";
	f.flag.value = "R";
	
	f.target="hiddenframe";
	f.action = "vendor_reg_ins_ict.jsp?reject_reason="+reject_reason + "&vendor_code="+vendor_code;
	f.submit();
}



function doOnRowSelected(rowId,cellInd)
{
	if(cellInd == INDEX_NAME_LOC){
		var vendor_code = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();
		var gb_gj = GridObj.cells(rowId, INDEX_GB_GJ).getValue();
		//var url = "/kr/master/vendor/ven_pp_dis1.jsp?vendor_code=" + vendor_code+"&flag=popup";
		if(gb_gj == "J"){
			window.open("/ict/s_kr/admin/info/ven_bd_con_j_ict.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=400,resizable=yes,scrollbars=yes");
		}else{
			window.open("/ict/s_kr/admin/info/ven_bd_con_ict.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");	
		}		
	} else if(cellInd == INDEX_PROGRESS_STATUS_NAME) {
		var vendor_code       = GridObj.cells(rowId, INDEX_VENDOR_CODE).getValue();	        
		var status            = GridObj.cells(rowId, INDEX_PROGRESS_STATUS).getValue();

		var sg_refitem        = GridObj.cells(rowId, INDEX_SG_REFITEM).getValue();	
		var vendor_sg_refitem = GridObj.cells(rowId, INDEX_VENDOR_SG_REFITEM).getValue();
		var vendor_vncp_enroll= GridObj.cells(rowId, INDEX_VNCP_CNT).getValue();
		
		
		if(status == '4') {	//실사통보
			var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
			popup(url, 2);
		} else if(status == '5') {	//실사완료
			var url = "vendor_reg_pop1.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code + "&vendor_sg_refitem=" + vendor_sg_refitem;
			popup(url, 2);
		} else {			//업체등록평가:승인
			if (vendor_vncp_enroll == 'N'){
				alert("영업담당정보가 입력되지 않았습니다. \n영업담당정보 입력후 승인처리하시기 바랍니다.");
				return;
			}

			var url = "vendor_reg_pop_ict.jsp?sg_refitem=" + sg_refitem + "&status=" + status + "&vendor_code=" + vendor_code;
			popup(url, 2);
		}
	}
}
	
//그리드 1건만 선택하도록 하는 소스
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    	if( header_name == "SELECTED" ) {
    		var gg = getGridSelectedRows(GridObj, "SELECTED");
    		if(gg !=0){
    			
    			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
    			{
    				//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
    			}
    		}
    		
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	row_id = rowId;
	    	return true;
    	}
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
        doQuery();
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
<form name="form" method="post" action="">
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
								<input type="hidden" name="mode"   id="mode">
								<input type="hidden" name="flag"   id="flag">
								<input type="hidden" name="reject_reason"     id="reject_reason">
								<input type="hidden" name="progress_status"   id="progress_status">
								<input type="hidden" name="screening_status"  id="screening_status">
								<input type="hidden" name="checklist_status"  id="checklist_status">
								<input type="hidden" name="vendor_code"       id="vendor_code">

								<tr>
									<td class="title_td" width="15%">
										&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;업체명
									</td>
									<td class="data_td" width="35%">
										<input type="text" size="30" value="" name="vendor_name" id="vendor_name" class="inputsubmit" onkeydown='entKeyDown()'>
									</td>
									<td width="15%" class="title_td">
              							&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
              							&nbsp;&nbsp;공급사/제조사
              						</td>
              						<td width="35%" class="data_td">
              							<select name="s_gb_gj" id="s_gb_gj" class="inputsubmit" onChange="">
											<option value="">전체</option>
											<option value="G">공급사</option>
											<option value="J">제조사</option>												
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
				<table cellpadding="0">
					<tr>
						<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
						<td><script language="javascript">btn("javascript:doReject()","반 려")</script></td>
						<td><script language="javascript">btn("javascript:deleteVendor()","삭 제")</script></td>
						<td><script language="javascript">btn("javascript:approvalPop()","승 인")</script></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>



<iframe name="hiddenframe" src="scr_item_ins.jsp" width="0" height="0"></iframe>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SU_101" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>




