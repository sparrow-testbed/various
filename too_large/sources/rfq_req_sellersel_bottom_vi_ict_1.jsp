<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	
	//20131209 sendakun
	HashMap text = MessageUtil.getMessageMap( info, "MESSAGE", "BUTTON", "I_PU_112_5" );
	
	String rfq_no    = JSPUtil.nullToEmpty ( request.getParameter ( "rfq_no"  ) );
	String rfq_count = JSPUtil.nullToEmpty ( request.getParameter ( "rfq_count" ) ); 
	String seller_codes = JSPUtil.nullToEmpty ( request.getParameter ( "seller_codes" ) ); 
	
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "I_PU_112_5";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
		
%>  
<html>
<head>
<title>우리은행 전자구매시스템</title>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language="javascript" src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.rfq_req_sellersel_left_ict";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";
var resetFlag = true;

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	
    	var seller_codes = "<%=seller_codes%>";
    	
    	if(seller_codes != ''){
    		doSelect(seller_codes, null,null, 'BID'); 
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
		if(resetFlag){
			//noSelectDelete ();
			resetFlag = false;
		}
		if(status == "false") //alert(msg);
		
		return true;
    }
    
    function doOnRowSelected(rowId,cellInd)
    {
    	
    	var header_name = GridObj.getColumnId(cellInd);
    	
    }
    function doOnCellChange(stage,rowId,cellInd)
    {
    	
    	var max_value = GridObj.cells(rowId, cellInd).getValue(); 
        var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명

        //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
        if(stage==0) {
            return true;
        } else if(stage==1) {
        } else if(stage==2) {
        } 
        
        return false;
    	
    }
    
	function checkRows()
	{
	}
	
	function doSaveEnd(obj)
	{
	}
    
    function getCheckCount()
	{
	}
    
	function doQuery(VENDOR)
	{
		var param = "&vendor_code="+VENDOR; 
		var row = "";
		var grid_col_id = "<%=grid_col_id%>";
		//var SERVLETURL  = G_SERVLETURL + "?mode=bottom_query&grid_col_id="+grid_col_id + param;
		var SERVLETURL  = G_SERVLETURL + "?mode=bottomQuery&grid_col_id="+grid_col_id + param;
		GridObj.loadXML(SERVLETURL);
		GridObj.clearAll(false);
	}
	
    var SUPI_SEQ = null;
    var rfq_no = "";
    var rfq_count = "";

    function doSelect(seller_code, SUPI_SEQ_P,RESET_FLAG, sel_flag){
    	SUPI_SEQ = SUPI_SEQ_P;
		var grid_col_id = "<%=grid_col_id%>";
	    var param = "";
	   
	    if(RESET_FLAG == "Y"){
	    	rfq_no = "";
	    	rfq_count = "";
	    }
	    param += "&rfq_no="       + rfq_no;
	    param += "&rfq_count="    + rfq_count;
	    param += "&seller_code="  + seller_code;
	    param += "&sel_flag="  + sel_flag;
	    param += "&grid_col_id="  + grid_col_id;
	    param += "&mode=bottomQuery";
		GridObj.post(G_SERVLETURL,param);
		GridObj.clearAll(false);
    }
    function noSelectDelete () {
		var gridAllselect = getGridAllRowsId(GridObj);
		for(var i = 0 ; i < gridAllselect.length ; i ++) {
			if(GridObj.cells(gridAllselect[i], GridObj.getColIndexById("SELECTED")).getValue() == "0"){
				GridObj.deleteRow(gridAllselect[i]);
			}
		}
    }
    
    // 행추가 이벤트 입니다.[선택 : 행삽입을 사용하는 페이지]
    function doAddRow() {

        var rowCnt = parseInt(GridObj.getRowsNum());
        var nMaxRow2 = rowCnt;

        GridObj.enableSmartRendering(true); // 필수로 구현해야한다
        GridObj.addRow( nMaxRow2, "", GridObj.getRowIndex(nMaxRow2) ); // 증가된 최종카운트에 1Row를 행삽입한다.
        GridObj.selectRowById( nMaxRow2, false, true );  // 필수로 구현해야한다
        GridObj.cells( nMaxRow2, GridObj.getColIndexById("SELECTED") ).cell.wasChanged = true; // 필수로 구현해야한다.
        GridObj.cells( nMaxRow2, GridObj.getColIndexById("SELECTED") ).setValue("1"); // 선택

        GridObj.cells( 0, GridObj.getColIndexById("SELLER_CODE")   ).setValue( "222271" );
        GridObj.cells( 0, GridObj.getColIndexById("SELLER_NAME")   ).setValue( "(주)동서식품" );
        GridObj.cells( 0, GridObj.getColIndexById("USER_NAME")   ).setValue( "최숙현님" );
        GridObj.cells( 0, GridObj.getColIndexById("EMAIL")   ).setValue( "Maxim@mail.net" );
        GridObj.cells( 0, GridObj.getColIndexById("MOBILE_NO")   ).setValue( "01078784545" );
        
        
    }
    
    
    
    function getGridData(){
    	alert( 4 );
    }
    
    function test(){
    	alert("1");
    }
</script>
</head>

<body leftmargin="0" topmargin="1" onload="setGridDraw();">

<style>
/* 현 화면은 다른 화면의 iframe으로 사용된다. 그래서 padding을 없애야 부모 화면과 좌우 정렬이 일치한다. */
div#wrap{
	margin:0px;
}
div#content{
	padding-left:0px;
	padding-right:0px;
}
</style>
<s:header popup="true">

 		<%-- START GRID BOX 그리기 --%>
        <div id="gridbox" name="gridbox" width="100%" height="140px" style="background-color:white;"></div>
        <div id="pagingArea"></div>
        <%-- END GRID BOX 그리기 --%>

</s:header>

<s:footer/>
</body>
</html>
