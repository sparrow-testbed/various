<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>




<%
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("PU_112_5");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	String rfq_no    = JSPUtil.nullToEmpty ( request.getParameter ( "rfq_no"  ) );
	String rfq_count = JSPUtil.nullToEmpty ( request.getParameter ( "rfq_count" ) );
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "PU_112_5";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
		
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.rfq_req_sellersel_left";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
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
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		if(SUPI_SEQ != null){
			for (var i = 1 ; i <= GridObj.getRowsNum() ; i++){
				var user_seq = GridObj.cells(i, GridObj.getColIndexById("USER_SEQ")).getValue();
				if(SUPI_SEQ.toString().indexOf(user_seq) != -1){
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("1");
				}else{
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("0");
				}
			}
		}else{
			for (var i = 1 ; i <= GridObj.getRowsNum() ; i++){
				if(GridObj.cells(i, GridObj.getColIndexById("SELECTED")).getValue() == "1"){
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("1");
				}else{
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
					GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("0");
				}
			}
		}
		//noSelectDelete ()
		if(status == "false") //alert(msg);
		
		return true;
    }
    function noSelectDelete () {
		var gridAllselect = getGridAllRowsId(GridObj);
		for(var i = 0 ; i < gridAllselect.length ; i ++) {
			if(GridObj.cells(gridAllselect[i], GridObj.getColIndexById("SELECTED")).getValue() == "0"){
				GridObj.deleteRow(gridAllselect[i]);
			}
		}
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
    	var header_name = GridObj.getColumnId(cellInd);
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
			return true;
		} else if(stage==1) {

			
//			한업체의 여러 담당자 중 한명의 담당자만 선택할 수 있게하는 소스
//			주석처리 2013.11.22  최숙현
// 			if(header_name == "SELECTED"){
// 				var selected = GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).getValue();
// 				if(selected == "1"){
// 					var selectUserSeq    = GridObj.cells(rowId, GridObj.getColIndexById("USER_SEQ")).getValue();
// 					var selectSellerCode = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_CODE")).getValue();
// 					for(var i = 1 ; i <= GridObj.getRowsNum() ; i++){
// 						var forUserSeq    = GridObj.cells(i, GridObj.getColIndexById("USER_SEQ")).getValue();
// 						var forSellerCode = GridObj.cells(i, GridObj.getColIndexById("SELLER_CODE")).getValue();
// 						if(selectSellerCode == forSellerCode){
// 							if(selectUserSeq == forUserSeq){
// 								GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
// 								GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("1");
// 							}else{
// 								GridObj.cells(i, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
// 								GridObj.cells(i, GridObj.getColIndexById("SELECTED")).setValue("0");
// 							}
// 						}
// 					}
// 				}
// 			}
			return true;
		}else if(stage==2) {
			
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

		alert("<%=text.get("PU_112_5.0001")%>");
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
			
			getPersonAssignList();
			
		} else {
			alert(messsage);
		}

		return false;
	}
    
	/**
	 * @Function Name  : doSelect
	 * @작성일         : 2009. 05. 29
	 * @변경이력       : 2011.08.18
	 * @Function 설명  : vendor(업체) 조회
	 */		
	function doQuery(VENDOR)
	{
		var param = "&vendor_code="+VENDOR;
		var row = "";
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=bottom_query&grid_col_id="+grid_col_id + param;
		GridObj.loadXML(SERVLETURL);
		GridObj.clearAll(false);
	}
	
	function SetUserInfo(){
		if(!checkRows()) return false; //선택한 행이 있는지 체크
		
		var linecount 	= 0;
		var VENDOR_NAME = "";
		var USER_NAME   = "";
		var EMAIL 		= "";
		var USER_ID		= "";
		var VENDOR_CODE = "";
		var PHONE_NO	= "";
		var BR_NUMBER   = "";
		
		var VENDOR		= "";
		var NAME 		= "";
		var MAIL 		= "";
		var USER		= "";
		var VENDOR_C	= "";
		var PHONE		= "";
		var BR_NUMBERS  = "";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		for(var i = 0; i < grid_array.length; i++ )
		{
		 	linecount++;
		 	VENDOR_NAME = GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_NAME")).getValue();	// 업체명
		 	USER_NAME   = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_NAME")).getValue();	// 담당자명
		 	USER_ID   	= GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_ID")).getValue();		// 담당자 ID
		 	VENDOR_CODE = GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_CODE")).getValue();	// 업체 코드
		 	EMAIL 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("EMAIL")).getValue(); 		// 담당자 메일명
		 	PHONE		= GridObj.cells(grid_array[i], GridObj.getColIndexById("PHONE_NO")).getValue(); 		// 전화번호
		 	BR_NUMBER	= GridObj.cells(grid_array[i], GridObj.getColIndexById("BUSINESS_REG_NUMBER")).getValue(); 		// 전화번호
		 	
		 	USER		+= USER_ID 	+ "@";
			VENDOR 		+= VENDOR_NAME 	+ "@";
			NAME 		+= USER_NAME 	+ "@";
			MAIL 		+= EMAIL 		+ "$";
			VENDOR_C	+= VENDOR_CODE	+ "@";
			PHONE_NO	+= PHONE	+ "@";
			BR_NUMBERS	+= BR_NUMBER	+ "@";
			
		}
		
		parent.opener.document.form.vendor_each_flag.value="-1";
		parent.opener.setVenderUser("", NAME, MAIL, VENDOR, USER, VENDOR_C, PHONE_NO, BR_NUMBERS, linecount);
		
		return true;
	}
	function doDeleteRow()
    {
    	var rowcount = dhtmlx_end_row_id;

    	for(var row = rowcount - 1; row >= dhtmlx_start_row_id; row--)
		{
			if("1" == GridObj.cells(GridObj.getRowId(row), 0).getValue())
			{
				GridObj.deleteRow(GridObj.getRowId(row));
        	}
	    }
    }
    
    function getCheckCount()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		return grid_array;
	}
    
    var SUPI_SEQ = null;
    var rfq_no = "<%=rfq_no%>";
    var rfq_count = "<%=rfq_count%>";
    
    function doSelect(seller_code, SUPI_SEQ_P, RESET_FLAG){
    	SUPI_SEQ = SUPI_SEQ_P;
		var grid_col_id = "<%=grid_col_id%>";
	    var param = "";
	    if(RESET_FLAG == "<%=sepoa.fw.util.CommonUtil.Flag.Yes.getValue()%>"){
	    	rfq_no = "";
	    	rfq_count = "";
	    }
	    param += "&rfq_no="       + rfq_no;
	    param += "&rfq_count="    + rfq_count;
	    param += "&seller_code="  + seller_code;
	    param += "&grid_col_id="  + grid_col_id;
	    param += "&mode=bottomQuery";
		GridObj.post(G_SERVLETURL,param);
		GridObj.clearAll(false);
    }
    
    function SetUserCheck(flag){
        //if(!checkRows()) return false; //선택한 행이 있는지 체크
        
        parent.mainFrame.doSave(flag);
    }
    
</script>
</head>

<body leftmargin="15" topmargin="1" onload="setGridDraw();">

<s:header popup="true">

<form name="form">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td style="padding:5 0 5 0" align="right">
				<TABLE cellpadding="0">
		      		<TR>
						<TD><script language="javascript">btn("javascript:SetUserCheck(1)","<%=text.get("BUTTON.save")%>");</script></TD>
		      			<TD><script language="javascript">btn("javascript:parent.window.close()","<%=text.get("BUTTON.close")%>");</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>
</s:header>
<s:grid screen_id="PU_112_5" grid_box="gridbox" grid_obj="GridObj" height="130"/>
<s:footer/>
 			<%-- START GRID BOX 그리기 --%>
<!--         <div id="gridbox" name="gridbox" width="100%" style="background-color:white; display: none;"></div> -->
        <%-- END GRID BOX 그리기 --%>
</body>
</html>
