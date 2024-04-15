<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>


<%--<%@page import="sepoa.svl.procure.forecast_list"%>	--%>

<%-- <jsp:directive.page import="com.sun.org.apache.bcel.internal.generic.IREM"/> --%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>







<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_PU_112_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "I_PU_112_2";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	String mode 			= JSPUtil.nullToEmpty(request.getParameter("mode"));
	String szRow 			= JSPUtil.nullToEmpty(request.getParameter("szRow"));
	String type				= JSPUtil.nullToEmpty(request.getParameter("type"));
	
	// 이전에 선택된 업체의 정보가 있으면 넘어오는 parameter(사용안되는것 같음.)
	String strVendor_info	= JSPUtil.nullToEmpty(request.getParameter("material_number").replaceAll ( "&#64;" , "@" ));

	String[] VENDOR_CODE = null;
	String[] VENDOR_NAME = null;
	String[] PHONE_NO1 = null;
	String[] PURCHASE_BLOCK_FLAG = null;
	String[] SUPI_SEQ = null;
	
	String[] DIS = null;
	String[] NO = null;
	String[] NAME = null;
	String[] IRS_NO = null;

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language="javascript" src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.pr_investigate_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";
var mode = null;
var SUPI_SEQ = null;
	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	
    	setTimeout("getVenderList()" , 500 );
    }



	function getVenderList()
	{
			if("E" == "<%=mode%>") { //입력
				
			} else if("I" == "<%=mode%>") { //입력후 수정 (품목번호별로 가져오기)
	
				//value = parent.opener.getCompany();
                //
				//if(value != null) 
				//{
				//	if(LRTrim(value) != "") 
				//	{
				//		var m_values = value.split("#");
		        //
				//		for(i=0; i<m_values.length; i++) 
				//		{
				//			if(m_values[i] != "") {
				//				var m_data = m_values[i].split("@");
		        //
				//				VENDOR_CODE = m_data[0];
				//				VENDOR_NAME = m_data[1];
				//				IRS_NO      = m_data[2];
				//				PHONE_NO1 	= m_data[3];
				//				PURCHASE_BLOCK_FLAG = m_data[4];
				//				SUPI_SEQ    = m_data[5];
				//				
		        //
				//				dhtmlx_last_row_id++;
				//			   	var nMaxRow2 = dhtmlx_last_row_id;
				//			
				//			   	GridObj.enableSmartRendering(true);
				//			   	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
				//			   	GridObj.selectRowById(nMaxRow2, false, true);
				//				GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
				//				GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
				//			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_CODE")).setValue(VENDOR_CODE);
				//			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_NAME_LOC")).setValue(VENDOR_NAME);
				//			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("IRS_NO")).setValue(IRS_NO);
				//			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PHONE_NO1")).setValue(PHONE_NO1);
				//			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).setValue(PURCHASE_BLOCK_FLAG);
				//			   	
				//			   	dhtmlx_before_row_id = nMaxRow2;
				//			}
				//		}
				//		;
				//	}
				//}
			} else if("A" == "<%=mode%>" || "M" == "<%=mode%>") {
				
				//value = parent.opener.getAllCompany();
				
				//if("<%=type%>" == "button"){//헤더에서 호출한 업체선택 버튼
				//	value = parent.opener.getAllCompanyTotal();
				//}
				//else{
				//	value = parent.opener.getAllCompany();
				//}
				var value = parent.opener.document.forms[0].vendor_info.value;

				if(value != null) {
					if(LRTrim(value) != "") {
						var m_values = value.split("#");
                
						for(i=0; i<m_values.length; i++) {
							if(m_values[i] != "") {
								var m_data = m_values[i].split("@");
								/* 
								VENDOR_SELECTED += SELLER_CODE + " @";
								VENDOR_SELECTED += SELLER_NAME_LOC + " @";
								VENDOR_SELECTED += IRS_NO + " @";
								VENDOR_SELECTED += PHONE_NO1 + " @";
								VENDOR_SELECTED += PURCHASE_BLOCK_FLAG + " @";
								VENDOR_SELECTED += supiSelected + " @";
								 */
								VENDOR_CODE = m_data[0];
								VENDOR_NAME = m_data[1];
								IRS_NO      = m_data[2];
								PHONE_NO1 	= m_data[3];
								PURCHASE_BLOCK_FLAG = m_data[4];
								SUPI_SEQ    += m_data[5];
								
								dhtmlx_last_row_id++;
							   	var nMaxRow2 = dhtmlx_last_row_id;
                
								GridObj.enableSmartRendering(true);
							   	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
							   	GridObj.selectRowById(nMaxRow2, false, true);
								GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
					
								GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
							   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_CODE")).setValue(VENDOR_CODE);
							   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_NAME_LOC")).setValue(VENDOR_NAME);
							   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("IRS_NO")).setValue(IRS_NO);
							   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PHONE_NO1")).setValue(PHONE_NO1);
							   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).setValue(PURCHASE_BLOCK_FLAG);
							   	
						   		dhtmlx_before_row_id = nMaxRow2;
							}
						}
					}
				}
			}

			if(SUPI_SEQ == undefined || SUPI_SEQ == "undefined"){
				getSupiSelect();
			}else{
				getSupiSelect("Y");
			}	
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
		
		return true;
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
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
		} else if(stage==2) {
			
			
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

		alert("<%=text.get("I_PU_112_2.0001")%>");
		return false;
	}
	
	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'SELECTED') return;
		GridObj.SetCellValue("SELECTED", nRow, "1");
	}
	
    // 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var rewo_number = "";
		var rewo_seq = "";
		
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			
		} else {
			alert(messsage);
		}

		return false;
	}
	
	
	function leftArrow()
	{
		var right_grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var left_grid_array = parent.leftFrame.getCheckCount();
		var left_seller_code  = "";
		for(row = left_grid_array.length-1; row >= 0; row--) 
		{
			var LEFT_SELLER_CODE         = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("SELLER_CODE")).getValue(); // 업체코드
			var LEFT_SELLER_NAME_LOC	 = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("SELLER_NAME_LOC")).getValue(); //업체명
			var LEFT_IRS_NO 			 = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("IRS_NO")).getValue(); //사업자번호
			var LEFT_PHONE_NO1 			 = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PHONE_NO1")).getValue(); //전화번호
			var LEFT_PURCHASE_BLOCK_FLAG = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).getValue(); //거래정지
			var LEFT_PO_NUMBER			 = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PO_NUMBER")).getValue(); //PO번호
			var LEFT_PO_CREATE_DATE      = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PO_CREATE_DATE")).getValue(); //PO일자
			var LEFT_UNIT_PRICE          = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("UNIT_PRICE")).getValue(); //단가
			
			var LEFT_BANKRUPTCY_NM            = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("BANKRUPTCY_NM")).getValue(); //부도여부
			var LEFT_PURCHASE_BLOCK_FLAG      = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).getValue(); //거래상태			
			var LEFT_PURCHASE_BLOCK_FLAG_NAME = parent.leftFrame.GridObj.cells(left_grid_array[row], parent.leftFrame.GridObj.getColIndexById("PURCHASE_BLOCK_FLAG_NAME")).getValue(); //거래상태
			
			if(LEFT_PURCHASE_BLOCK_FLAG == "Y"){
				alert(LEFT_SELLER_NAME_LOC + " 업체는 거래중지 상태 입니다.\r\n업체지정 불가합니다.");
				continue;
			}
			
			if(LEFT_PURCHASE_BLOCK_FLAG == "R"){
				alert(LEFT_SELLER_NAME_LOC + " 업체는 탈퇴요청 상태 입니다.\r\n업체지정 불가합니다.");
				continue;
			}
			
			var flag = "true";
			for(var i= 0; i < GridObj.getRowsNum(); i++) {
				var SELLER_CODE = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELLER_CODE")).getValue();
				if(LRTrim(LEFT_SELLER_CODE) == LRTrim(SELLER_CODE)){
				  	flag = "false";
				  	alert("<%=text.get("I_PU_112_2.0003")%>");
					return;
				}
			}
			
			if("true" == flag) {
				
				dhtmlx_last_row_id++;
		    	var nMaxRow2 = dhtmlx_last_row_id;
		    	var row_data = "<%=grid_col_id%>";
		    	
				GridObj.enableSmartRendering(true);
				GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		    	GridObj.selectRowById(nMaxRow2, false, true);
			    GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
				
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_CODE")).setValue(LEFT_SELLER_CODE);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELLER_NAME_LOC")).setValue(LEFT_SELLER_NAME_LOC);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("IRS_NO")).setValue(LEFT_IRS_NO);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PHONE_NO1")).setValue(LEFT_PHONE_NO1);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).setValue(LEFT_PURCHASE_BLOCK_FLAG);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PO_NUMBER")).setValue(LEFT_PO_NUMBER);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PO_CREATE_DATE")).setValue(LEFT_PO_CREATE_DATE);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("UNIT_PRICE")).setValue(LEFT_UNIT_PRICE);
			   	
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("BANKRUPTCY_NM")).setValue(LEFT_BANKRUPTCY_NM);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).setValue(LEFT_PURCHASE_BLOCK_FLAG);
			   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("PURCHASE_BLOCK_FLAG_NAME")).setValue(LEFT_PURCHASE_BLOCK_FLAG_NAME);
			   				   				
			   	dhtmlx_before_row_id = nMaxRow2;
		   	}
		   		   	
		   	parent.leftFrame.GridObj.deleteRow(left_grid_array[row]);
		}
		getSupiSelect("Y");
	}
	
	function all_grid_data(gridobj)
	{
		var changed_array = new Array();
		var grid_array = new Array();
		var grid_index = 0;
		var changed_row = gridobj.getChangedRows();
		changed_array = changed_row.split(",");

		for(var i = 0; i < changed_array.length; i++)
		{
			if(changed_array[i].length > 0)
			{
				grid_array[grid_index] = changed_array[i];
				grid_index++;
			}
		}

		return grid_array;
	}
	
	function rightArrow() 
	{
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var rowcount = grid_array.length;
    	
    	GridObj.enableSmartRendering(false);
    	
    	for(var row = rowcount - 1; row >= dhtmlx_start_row_id; row--)
		{
			if("1" == GridObj.cells(grid_array[row], 0).getValue())
			{
				GridObj.deleteRow(grid_array[row]);
        	}
	    }
    	var allGridData = all_grid_data(GridObj);
    	
    	for (var i = 0  ; i < allGridData.length ; i++ ){
   		    GridObj.cells(allGridData[i], GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
   	    	GridObj.cells(allGridData[i], GridObj.getColIndexById("SELECTED")).setValue("1");
    	}
    	getSupiSelect("Y");
	}
	function getSupiSelect(RESET_FLAG){
		var selectGrid = getGridChangedRows(GridObj, "SELECTED");
		var left_seller_code = "";
		for(var i = 0 ; i < selectGrid.length ; i++){
			var TEMP_SELLER_CODE         = GridObj.cells(selectGrid[i], GridObj.getColIndexById("SELLER_CODE")).getValue(); // 업체코드
		   	left_seller_code += TEMP_SELLER_CODE + "@";
		}
		parent.bottomFrame.doSelect(left_seller_code, SUPI_SEQ,RESET_FLAG);
	   	parent.opener.supiFlame.doSelect(left_seller_code, SUPI_SEQ,RESET_FLAG);
	}

	
	
	function doSave(flag)
	{
		var selectGrid = getGridChangedRows(parent.bottomFrame.GridObj, "SELECTED");
		var centerGrid = getGridChangedRows(parent.mainFrame.GridObj  , "SELECTED");
		var message = "<%=text.get("I_PU_112_2.0002")%>";
		if(flag == 2){
			message = "업체지정을 완료하시겠습니까?";
		}

		if (confirm(message)) {
			var linecount = 0;
			var SELLER_CODE      	= "";
			var SELLER_NAME_LOC 	= "";
			var PHONE_NO1 	 		= "";
			var PURCHASE_BLOCK_FLAG	= "";
		    var IRS_NO              = "";
	 
			var VENDOR_SELECTED = "";
			var VENDOR_INFO     = "";
	
			var rowcount = GridObj.getRowsNum();
	
			var supiSelected = "";
		
			if(typeof parent.opener.supiFlame != "undefined"){
				for(var k = 0 ; k < parent.opener.supiFlame.GridObj.getRowsNum() ; k++){
		
		   		    parent.opener.supiFlame.GridObj.cells(k+1, parent.opener.supiFlame.GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		   	    	parent.opener.supiFlame.GridObj.cells(k+1, parent.opener.supiFlame.GridObj.getColIndexById("SELECTED")).setValue("0");
		   	    	
				}
			}

		
			for(var i =0; i < rowcount; i++ )
			{
			 	linecount++;
			 	SELLER_CODE      	= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELLER_CODE")).getValue();	// 업체코드
				SELLER_NAME_LOC 	= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELLER_NAME_LOC")).getValue(); //업체명
				IRS_NO 				= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("IRS_NO")).getValue(); // 사업자번호
				PHONE_NO1 	 		= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("PHONE_NO1")).getValue(); //전화번호
				PURCHASE_BLOCK_FLAG	= GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("PURCHASE_BLOCK_FLAG")).getValue(); //거래정지
				
				VENDOR_INFO += SELLER_CODE + " @";
				VENDOR_INFO += SELLER_NAME_LOC + " @";
				VENDOR_INFO += IRS_NO + " @";
				VENDOR_INFO += PHONE_NO1 + " @";
				VENDOR_INFO += PURCHASE_BLOCK_FLAG + " @";
				VENDOR_INFO += supiSelected + " @";
				VENDOR_INFO += "#";
				
				VENDOR_SELECTED += SELLER_CODE + "@";
				
			}
		
		
			parent.opener.document.forms[0].seller_change_flag.value = "Y";
			
			if("A" == "<%=mode%>")
			{
    	    	parent.opener.document.forms[0].vendor_each_flag.value="-1";
    	    }
			
			
			//alert("flag:"+flag);	//==> 1
			//alert("VENDOR_SELECTED:"+VENDOR_SELECTED);
			//alert("linecount:"+linecount);
			
    	    parent.opener.setVendorList("<%=szRow%>", VENDOR_INFO, VENDOR_SELECTED, linecount);
    	    
			//parent.opener.vendor_Select();
			if(flag==1){
	            parent.window.close();	
			}
       	}
	   	//parent.opener.supiFlame.noSelectDelete ();
	}
	
</script>
</head>

<body leftmargin="5" topmargin="6" onload="setGridDraw();" style="overflow:hidden;">
<s:header popup="true">
<form name="form">
	
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="center">
				<a href="javascript:leftArrow();"><img src="<%=POASRM_CONTEXT_NAME%>/images/icon_next.gif" width="15" height="15" border="0" alt=""></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<br><br>
				<a href="javascript:rightArrow();"> <img src="<%=POASRM_CONTEXT_NAME%>/images/icon_next2.gif" width="15" height="15" border="0" alt=""></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td>
			<table width="100" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td width="78%" >&nbsp;&nbsp;&nbsp;<b><%-- 지정업체 --%><%=text.get("I_PU_112_2.TEXT_0002")%></b>
			  		</td>
				</tr>
				<tr>
			  		<td height="10" bgcolor="FFFFFF"></td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="jtable_bgcolor">
				<tr>
					<TD>
						<%-- START GRID BOX 그리기 --%>
				        		<div id="gridbox" name="gridbox" height="212px" width="342px" style="background-color:white;"></div>
			            	  	<div id="pagingArea"></div>
				        <%-- END GRID BOX 그리기 --%>
					</TD>
			   	</tr>
			</table>
			</td>
		</tr>
	</table>
</form>
</s:header>
 		
<s:footer/>
</body>
</html>