<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>

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
			
			getPersonAssignList();
			
		} else {
			alert(messsage);
		}

		return false;
	}
    
	 /**
     * @Function Name  : doSelect
     * @작성일         : 2009. 05. 29
     * @변경이력       :
     * @Function 설명  : 구매요청목록(품목) > 조회
     */     
    //function doSelect(seller_code, name_loc, type, sg_code1, sg_code2, sg_code3, sg_code4, sg_code5, company_code)
    function doSelect(seller_code, name_loc)
    {
        var param = "";
        param    += "&seller_code=" + seller_code;
        param    += "&name_loc="    + name_loc   ;
        //param    += "&type="        + type       ;
        //param    += "&sg_code1="    + sg_code1   ;
        //param    += "&sg_code2="    + sg_code2   ;
        //param    += "&sg_code3="    + sg_code3   ;
        //param    += "&sg_code4="    + sg_code4   ;
        //param    += "&sg_code5="    + sg_code5   ; 
        //param    += "&company_code="    + company_code   ;
        var grid_col_id = "<%=grid_col_id%>";
        var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.rfq_req_sellersel_left_ict";
        var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id + param;
        GridObj.loadXML(SERVLETURL);
        GridObj.clearAll(false);
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
    
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();" style="overflow:hidden;">

<s:header popup="true">

<form name="form">
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
	  		<td width="78%" >&nbsp;&nbsp;&nbsp;<b><%-- 전체업체 --%><%=text.get("I_PU_112_2.TEXT_0001")%></b>
	  		</td>
		</tr>
		<tr>
	  		<td height="10" bgcolor="FFFFFF"></td>
		</tr>
	</table>
 	 <table width="98%" border="0" cellspacing="0" cellpadding="0" class="jtable_bgcolor">
		<tr border="1px">
			<TD>
			<%-- START GRID BOX 그리기 --%>
            <div id="gridbox" name="gridbox" height="212px" width="342px"  style="background-color:white;"></div>
            <div id="pagingArea"></div>
            <%-- END GRID BOX 그리기 --%>
			</TD>
	   	</tr>
	</table>  
</form>
</s:header>
 			
<s:footer/>
</body>
</html>
