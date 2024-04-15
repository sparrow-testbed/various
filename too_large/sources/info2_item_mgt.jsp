<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%


	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_015";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%

    String transaction_id     = "";
    
    int trtn = 0;
    SepoaOut wo = DocumentUtil.getDocNumber(info, "MTDS");
	if (wo.status == 1){// 성공
		transaction_id = wo.result[0];
		Logger.debug.println(info.getSession("ID"), this,"채번번호====>" + transaction_id);
	} else {// 실패
		Logger.debug.println(info.getSession("ID"), this,"Message====>" + wo.message);
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<script language="javascript">
// window.resizeTo("1024","768");
</script>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/order.info.info2_item_mgt";
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;
var INDEX_SELECTED;
var INDEX_ITEM_NO;
var INDEX_VENDOR_CODE;
var INDEX_BASIC_UNIT;
var INDEX_VALID_FROM_DATE;
var INDEX_VALID_TO_DATE;
var INDEX_UNIT_PRICE;
var INDEX_REMARK;

function init() {
	setGridDraw();
	setHeader();
	doQuery();
}

function setHeader() {
    /* INDEX_SELECTED			= GridObj.GetColHDIndex("SELECTED");
    INDEX_ITEM_NO			= GridObj.GetColHDIndex("ITEM_NO");
    INDEX_VENDOR_CODE		= GridObj.GetColHDIndex("VENDOR_CODE");
    INDEX_BASIC_UNIT    	= GRIDOBJ.GETCOLHDINDEX("BASIC_UNIT");
    INDEX_VALID_FROM_DATE 	= GRIDOBJ.GETCOLHDINDEX("VALID_FROM_DATE");
    INDEX_VALID_TO_DATE		= GRIDOBJ.GETCOLHDINDEX("VALID_TO_DATE");
    INDEX_UNIT_PRICE		= GRIDOBJ.GETCOLHDINDEX("UNIT_PRICE");
    INDEX_REMARK			= GRIDOBJ.GETCOLHDINDEX("REMARK"); */
}

function doQuery(){	
	var cols_ids = "<%=grid_col_id%>";
	var param = "mode=getInfo2ItemMgt";
	param     += "&cols_ids=" + cols_ids;
    param     += dataOutput();
	GridObj.post( G_SERVLETURL, param );
	GridObj.clearAll(false);
}
	
function setGridDraw(){
  	GridObj_setGridDraw();
   	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var header_name = GridObj.getColumnId(cellInd);
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd); 
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
        window.close();
    } else {
        alert(messsage);
    }
    return false;
}

<%-- 액셀양식 템플릿 다운로드 --%>
function doTemplate()
{
	location.href = "/template/Excel_Template_02.xls";
}

function doUpload(){
	
	var rowcount    = GridObj.GetRowCount();
	
    var up_file   = LRTrim(document.form1.uploadFile.value);
    var file_tpye = up_file.substring(up_file.lastIndexOf(".")+1).toUpperCase();
    
    if(up_file != null && up_file != '' && rowcount > 0) {
    	alert('기존에 저장된 데이터가 있어서 처리할 수 없습니다.\n기존 데이터를 우선 삭제해야 액셀업로드 처리 가능합니다.');
    	return;
    }
    
    if(up_file == "")
    {
        alert("업로드 파일을 선택하여 주십시오.");
        return;
    }

    if(file_tpye.indexOf("XLS") < 0)
    {
        alert("업로드는 엑셀파일만 업로드 가능합니다.");
        return;
    }

    doQueryDuring();
    document.form1.action = "info2_item_mgt_excel_upload.jsp?transaction_id=<%=transaction_id%>";
    document.form1.target = "actionFrame";
    document.form1.submit();
}

function doUploadModalEnd()
{
    if(dhxWins == null) {
        dhxWins = new dhtmlXWindows();
        dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dthmlx/dhtmlxWindows/codebase/imgs/");
    }

    if(prg_win == null) {
        var top = BwindowWidth()/2 - 180;
        var left  = BwindowHeight()/2 - 73;

        prg_win = dhxWins.createWindow("prg_win", top, left, 180, 73);
        prg_win.setText("Please wait for a moment.");
        prg_win.button("close").hide();
        prg_win.button("minmax1").hide();
        prg_win.button("minmax2").hide();
        prg_win.button("park").hide();
        dhxWins.window("prg_win").setModal(true);
        prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm", true);
    }

    dhxWins.window("prg_win").setModal(false);
    dhxWins.window("prg_win").hide();
}

function doQueryEnd() {
	if(status == "0") alert(msg);

	var idx_remark = GridObj.getColIndexById('REMARK');
	var idx_select =  GridObj.getColIndexById("SELECTED");
	
    for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++){
    	
    	var remark = GridObj.cells( j+1, idx_remark ).getValue();
    	//alert(remark);
    	if(remark == '기등록') {
    		GridObj.cells(j+1, idx_select).cell.wasChanged = false;
			GridObj.cells(j+1, idx_select).setValue("0");
		}else{
			GridObj.cells(j+1, idx_select).cell.wasChanged = true;
			GridObj.cells(j+1,idx_select).setValue("1");	
		}
		 
	}
    
    return true;
}
	
 
 /*
 팝업 관련 코드
 */
function PopupManager(part){
	 
	var url = "";
	var f = document.forms[0];
	var wise = GridObj;

 }
 
// 상세품목등록 저장 : ITEM_STATUS를 E로 저장/수정
function doSave() {
	var grid_array = getGridChangedRows(GridObj, "SELECTED");     
	var rowcount    = GridObj.GetRowCount();
	var tot_item_amt = 0;
	var remark = "";
	
	//기등록건 체크
	for(var i = 0; i < grid_array.length; i++) {
		remark = GridObj.cells( grid_array[i], GridObj.getColIndexById('REMARK') ).getValue();	
		if(remark == '기등록') {
			alert('이미 등록된 품목은 다시 등록할 수 없습니다.');
			return;
		}
	}
	
	var cols_ids = "<%=grid_col_id%>";                                    
	var params;                                                           
	                                                                      
	params = "?mode=doSaveInfo2ItemMgt";                                                   
	params += "&cols_ids=" + cols_ids;                                    
	params += dataOutput();
	                                                                      
	myDataProcessor = new dataProcessor(G_SERVLETURL + params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doDelete() {
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");   
	
	var item_seq = "";
	
	if( confirm('그리드를 초기화 하시겠습니까?') ) {
		
		
		var nickName    = "p2004";
		var conType     = "CONNECTION";//TRANSACTION
		var methodName  = "doDeleteInfo2ItemMgt";
		var SepoaOut    = doServiceAjax( nickName, conType, methodName );
		if( SepoaOut.status == "1" ) { // 성공
			alert('그리드가 초기화 되었습니다.');
			doQuery();
		}else{
			alert("처리시 오류가 발생하였습니다.");
    		return;
		}
		
		
		/*
		var cols_ids = "<%=grid_col_id%>";                                    
		var params;                                                           
		                                                                      
		params = "?mode=doDeleteInfo2ItemMgt";                                                   
		params += "&cols_ids=" + cols_ids;                                    
		params += dataOutput();    
		myDataProcessor = new dataProcessor(G_SERVLETURL + params);           
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		*/
	}
}


function doDeleteRow() {
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");   
	var rowcount = grid_array.length;
// 	GridObj.enableSmartRendering(false);
	
	for(var row = rowcount - 1; row >= 0; row--){
		if("1" == GridObj.cells(grid_array[row], 0).getValue()){
			GridObj.deleteRow(grid_array[row]);
    	}
    }
	
}


</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" encType="multipart/form-data" name="form" method="post">
		<input type="hidden" name="h_po_no">
		<input type="hidden" name="set_company_code">
		<input type="hidden" name="SHIPPER_TYPE" value = "D">

		<input type="hidden" name="attach_gubun" value="body">
		<input type="hidden" name="attach_no" value="">
		<input type="hidden" name="attach_count" value="">
		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		<input type="hidden" name="transaction_id" id="transaction_id" value="<%=transaction_id%>">

		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>연단가등록</span>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
    			<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
		      			<TR>
							<TD>
								<input type="file" name="uploadFile" id="uploadFile" size="10">
							</TD>
		      				<TD>
								<script language="javascript">
								btn("javascript:doUpload()","액셀업로드");
								</script>
							</TD>
		      				<TD>
								<script language="javascript">
								btn("javascript:doTemplate()","템플릿다운로드");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
      			<td height="30" align="right">
					<TABLE cellpadding="0" border="0">
		      			<TR>
		      				<TD><script language="javascript">btn("javascript:doQuery()","조회");</script></TD>
		      				<TD><script language="javascript">btn("javascript:doDelete()","초기화");</script></TD>
							<%-- <TD><script language="javascript">btn("javascript:doDeleteRow()","행삭제");</script></TD> --%>
		      				<TD><script language="javascript">btn("javascript:doSave()","저 장");</script></TD>
						</TR>
					</TABLE>
					
				</td>
			</tr>
		</table>
	</form>
</s:header>
<iframe name="actionFrame" width="0" height="0" border="0" scrolling="no" frameborder="0"></iframe>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>