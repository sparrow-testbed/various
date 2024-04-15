<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%


	Vector multilang_id = new Vector();
	multilang_id.addElement("AR_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%

    String item_no          = JSPUtil.nullChk(request.getParameter("item_no"));
    String description_loc  = JSPUtil.nullChk(request.getParameter("description_loc"));
    String item_amt         = JSPUtil.nullChk(request.getParameter("item_amt"));
    String detail_doc_no    = JSPUtil.nullChk(request.getParameter("detail_doc_no"));
    String p_row_id         = JSPUtil.nullChk(request.getParameter("p_row_id"));
    
    
    int trtn = 0;
    
    
	//문서번호 채번이 안된 경우
	if( detail_doc_no == null || detail_doc_no.length() == 0  ){
		
		SepoaOut wo = DocumentUtil.getDocNumber(info, "MTDS");
		
		if (wo.status == 1)// 성공
		{
			detail_doc_no = wo.result[0];
			Logger.debug.println(info.getSession("ID"), this,"채번번호====>" + detail_doc_no);
		} else {// 실패
			Logger.debug.println(info.getSession("ID"), this,"Message====>" + wo.message);
			//rtn = 0;
			//return rtn;
		}
	
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

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_ins1";
// var G_C_INDEX                    = "ITEM_NO:DESCRIPTION_LOC:UNIT_MEASURE";
var G_C_INDEX                    = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";

var INDEX_SELECTED;
var INDEX_ITEM_SEQ;
var INDEX_ITEM_NO;
var INDEX_DESCRIPTION_LOC;
var INDEX_UNIT_MEASURE;
var INDEX_UNIT_MEASURE_NM;
var INDEX_ITEM_QTY;
var INDEX_UNIT_PRICE;
var INDEX_ITEM_AMT;

function init() {
	setGridDraw();
	setHeader();
	doQuery();
}

function setHeader() {
    
  //GridObj.AddHeader("INVEST_NO"			, "자산번호"			, "t_text", 500, 0, false);
  //GridObj.AddHeader("INVEST_SUB_NO"		, "자산하위번호"		, "t_text", 500, 0, false);

// 	GridObj.SetColCellSortEnable("DESCRIPTION_LOC"	,false);
// 	GridObj.SetColCellSortEnable("UNIT_MEASURE"		,false);
// 	GridObj.SetColCellSortEnable("ITEM_AMT"			,false);
// 	GridObj.SetColCellSortEnable("PR_AMT"				,false);
// 	GridObj.SetColCellSortEnable("DELY_TO_LOCATION"	,false);
// 	GridObj.SetNumberFormat("PO_QTY"			,G_format_qty);
// 	GridObj.SetNumberFormat("UNIT_PRICE"		,G_format_unit);
// 	GridObj.SetNumberFormat("PR_UNIT_PRICE"	,G_format_unit);
// 	GridObj.SetNumberFormat("ITEM_AMT"		,G_format_amt);
// 	GridObj.SetNumberFormat("PR_AMT"			,G_format_amt);
// 	GridObj.SetNumberFormat("EXEC_AMT_KRW"	,G_format_amt);
// 	GridObj.SetNumberFormat("DOWN_AMT"		,G_format_amt);
// 	GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
// 	GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
// 	GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd");

    INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
    INDEX_ITEM_SEQ		= GridObj.GetColHDIndex("ITEM_SEQ"		    );
    INDEX_ITEM_NO			= GridObj.GetColHDIndex("ITEM_NO"			);
    INDEX_DESCRIPTION_LOC	= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
    INDEX_UNIT_MEASURE    = GridObj.GetColHDIndex("UNIT_MEASURE"	   	);
    INDEX_UNIT_MEASURE_NM = GridObj.GetColHDIndex("UNIT_MEASURE_NM"  	);
    INDEX_ITEM_QTY		= GridObj.GetColHDIndex("ITEM_QTY"  		);
    INDEX_UNIT_PRICE		= GridObj.GetColHDIndex("UNIT_PRICE"		);
    INDEX_ITEM_AMT		= GridObj.GetColHDIndex("ITEM_AMT"		    );

}

function doQuery()
{
	var cols_ids = "<%=grid_col_id%>";
	var param = "mode=getDetailItem";
	param     += "&cols_ids=" + cols_ids;
    param     += dataOutput();
	GridObj.post( G_SERVLETURL, param );
	GridObj.clearAll(false);
}

	
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
    	
    	
    	if( header_name == 'ITEM_QTY' || header_name == 'UNIT_PRICE' ) {
    		
    		
    		var item_qty = GridObj.cells( rowId, GridObj.getColIndexById( 'ITEM_QTY' ) ).getValue();
    		var unit_price = GridObj.cells( rowId, GridObj.getColIndexById( 'UNIT_PRICE' ) ).getValue();
    		/*
    		if( item_qty == 0 || item_qty == "")
    		{
    			
    			alert("수량을 입력하세요.");
    			return;
    		
    		}
    		
    		
    		if( unit_price == 0 || unit_price == "" )
    		{
    			
    			alert("단가를 입력하세요.");
    			return;
    		
    		}
    		*/
    		
    		
    		var item_amt = Number( item_qty ) * Number( unit_price );
    		
    		//alert(item_qty + "   " +  unit_price + "     " + item_amt);
    		
    		
    		GridObj.cells(rowId, GridObj.getColIndexById( 'ITEM_AMT' ) ).setValue( item_amt );
    		setAmt();
    	}
    	
        return true;
    }
    
    return false;
}



function setAmt(){
	

	var checked_count = 0;
	var 	tot_amt = 0;
	
	for(row=GridObj.GetRowCount()-1; row>=0; row--) {
		//if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
		//	checked_count++;
		//}
		
		if( GD_GetCellValueIndex(GridObj,row, INDEX_ITEM_AMT) == 0 || GD_GetCellValueIndex(GridObj,row, INDEX_ITEM_AMT) == "" )
		{
			continue;		
		}
		else{
			item_amt = parseInt(GD_GetCellValueIndex(GridObj,row, INDEX_ITEM_AMT));
			//alert("item_amt=="+item_amt);
			tot_amt += item_amt;
			
		}
		
			
	}
	
	//alert("tot_amt=="+tot_amt);
	document.getElementById("tot_amt").value = add_comma(tot_amt,0);
	
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
        opener.setDetailDocNo('<%=p_row_id%>', document.getElementById('detail_doc_no').value);
        if(mode == "doSave") {
	        window.close();
        }
    } else {
        alert(messsage);
    }
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
//     } 

    return false;
}

<%-- 액셀양식 템플릿 다운로드 --%>
function doTemplate()
{
	location.href = "/template/Excel_Template_03.xls";
}

function doUpload()
{
	
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
    document.form1.action = "bd_item_mgt_excel_upload.jsp?detail_doc_no=<%=detail_doc_no%>";
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
    var msg           = GridObj.getUserData("", "message");
    var status        = GridObj.getUserData("", "status");
    var detail_doc_no = GridObj.getUserData("", "detail_doc_no");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.getElementById('detail_doc_no').value = detail_doc_no;
    document.getElementById('item_amt').value = add_comma( '<%=item_amt%>', 0 );
    
    for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
	{
		GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
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

	if(part == "CATALOG"){ //카탈로그
		
		setCatalogIndex(G_C_INDEX);
		
		url = "/kr/dt/app/cat_pp_lis_main_1.jsp?INDEX=" + getAllCatalogIndex() ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}

}
 

function setCatalog(itemNo, descriptionLoc, unitMeasure){
	
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	

	
	for(row=GridObj.GetRowCount()-1; row>=0; row--) {
		//if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)){
		//	checked_count++;
		//}
		
		if( GD_GetCellValueIndex(GridObj,row, INDEX_ITEM_NO) == itemNo )
		{
			alert(itemNo + " 와 동일한 품목코드가 존재합니다.");
			return false;	
		}
	}
	
	
	
	GridObj.addRow(newId,"");
// 	GridObj.addRow(iMaxRow,"");
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	   "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	   itemNo);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,       unitMeasure);

	return;
}

// 상세품목등록 저장 : ITEM_STATUS를 E로 저장/수정
function doSave() {
	var grid_array = getGridChangedRows(GridObj, "SELECTED");     
	var rowcount    = GridObj.GetRowCount();
	var tot_item_amt = 0;
	var item_amt = 0;
	
	for(var i = 0; i < grid_array.length; i++) {

		item_amt = GridObj.cells( grid_array[i], GridObj.getColIndexById('ITEM_AMT') ).getValue();
		
		
		
		if(item_amt == null || item_amt == '' || item_amt == 0) {
			alert('수량과 단가를 입력해주세요.');
			return;
		}
		
		tot_item_amt += Number( item_amt );
	}
	
	var p_item_amt = del_comma( document.getElementById( 'item_amt' ).value );
	if( Number( p_item_amt ) != Number( tot_item_amt ) ) {
		alert('선택된 전체 합계금액과 계약금액이 일치하지 않아 처리할 수 없습니다.');
		return;
	}
	
	var cols_ids = "<%=grid_col_id%>";                                    
	var params;                                                           
	                                                                      
	params = "?mode=doSaveDocNo";                                                   
	params += "&cols_ids=" + cols_ids;                                    
	params += dataOutput();
	                                                                      
	myDataProcessor = new dataProcessor(G_SERVLETURL + params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doDelete() {
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");   
	
	var item_seq = "";
	
	for( var i = 0; i < grid_array.length; i++ ) {
		item_seq = GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_SEQ")).getValue();
		if( item_seq == null || item_seq == "" ) {
			alert("순번이 없는 건은 삭제 처리할 수 없습니다.\n행삭제로 처리하십시오.");
			return;
		} 
	}
	
	if( confirm('삭제하시겠습니까?') ) {
		
		var cols_ids = "<%=grid_col_id%>";                                    
		var params;                                                           
		                                                                      
		params = "?mode=doDeleteDocNo";                                                   
		params += "&cols_ids=" + cols_ids;                                    
		params += dataOutput();    
		                                                                      
		myDataProcessor = new dataProcessor(G_SERVLETURL + params);           
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		
	}
	
	return;
	
}

function doDeleteRow() {
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");   
	var rowcount = grid_array.length;
// 	GridObj.enableSmartRendering(false);
	
	var item_seq = "";
	
	for( var i = 0; i < grid_array.length; i++ ) {
		item_seq = GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_SEQ")).getValue();
		if( item_seq != null && item_seq != "" ) {
			alert("순번이 있는 건은 행삭제 처리할 수 없습니다.\n삭제로 처리하십시오.");
			return;
		} 
	}
	
	for(var row = rowcount - 1; row >= 0; row--)
	{
		if("1" == GridObj.cells(grid_array[row], 0).getValue())
		{
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

		<input type="hidden" id="item_no"         name="item_no"         value="<%=item_no%>">
		<input type="hidden" id="detail_doc_no"   name="detail_doc_no"   value="<%=detail_doc_no%>">

		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>품목상세등록</span>
				</td>
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td width="35%" class="data_td">
											<input type="text" name="description_loc" id="description_loc" value="<%=description_loc%>" readOnly style="width:92%;border:0;background-color: #f6f6f6;">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약금액</td>
										<td width="35%" class="data_td">
											<input type="text" name="item_amt" id="item_amt" value="<%=item_amt%>" readOnly style="width:92%;border:0;background-color: #f6f6f6;">
										</td>
									</tr>
<!-- 									<tr> -->
<!-- 										<td colspan="4" height="1" bgcolor="#dedede"></td> -->
<!-- 									</tr> -->
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<br><br>
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
    			<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
		      			<TR>
		      				<%-- 
		      				<TD>
								<input type="text" size="10" readOnly class="input_empty" value="" name="FILE_NAME" id="FILE_NAME"/>
								<input type="hidden" value="" name="ATTACH_NO" id="ATTACH_NO">
							</TD>
							
							<TD>
			      				<script language="javascript">
								btn("javascript:attach_file(document.getElementById('ATTACH_NO').value, 'TEMP');", "파일찾기");
								</script>
							</TD>
							 --%>
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
		      				<TD>
								<script language="javascript">
								btn("javascript:doQuery()","조회");
								</script>
							</TD>
		      				<TD>
								<script language="javascript">
								btn("javascript:PopupManager('CATALOG')","품목카탈로그");
								</script>
							</TD>
							<TD>
								<script language="javascript">
								btn("javascript:doDeleteRow()","행삭제");
								</script>
							</TD>
		      				<TD>
								<script language="javascript">
								btn("javascript:doSave()","저 장");
								</script>
							</TD>
							<TD>
								<script language="javascript">
								btn("javascript:doDelete()","삭 제");
								</script>
							</TD>
						</TR>
					</TABLE>
					
				</td>
			</tr>
		</table>
				합계금액 : <input type="text" name="tot_amt" id="tot_amt" size="30" class="input_empty_white">
			
	</form>
</s:header>

<iframe name="actionFrame" width="0" height="0" border="0" scrolling="no" frameborder="0"></iframe>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>

<s:footer/>
</body>
</html>