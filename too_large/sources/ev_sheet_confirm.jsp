<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa" %>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String to_year = SepoaDate.getYear()+"";
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_007";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	// 화면에 행머지기능을 사용할지 여부의 구분
	//boolean isRowsMergeable = false;
	
	// 한 화면 SCREEN_ID 기준으로 Buyer 화면일 경우에는 컬럼이 ReadOnly 이고 
	// Supplier 화면일 경우에 edit 일 경우에는 아래의 벡터 클래스에다가 컬럼명을 addElement 하시면 됩니다. 
	// 변환되는 컬럼타입 기준은 아래와 같습니다.
	// ed -> ro(EditBox -> ReadOnlyBox), 
	// edn, -> ron(NumberEditBox -> NumberReadOnlyBox), 
	// dhxCalendar -> ro(CalendarBox -> ReadOnlyBox), 
	// txt -> ro(TextBox -> ReadOnlyBox)
	// sepoa_grid_common.jsp 에서 컬럼타입을 변경 시켜 줍니다.
	// 참고로 Vector dhtmlx_read_cols_vec 객체는 sepoa_common.jsp에서 생성 시켜 줍니다.
	//dhtmlx_read_cols_vec.addElement("screen_id=ED");
	//dhtmlx_read_cols_vec.addElement("col_width");
	//dhtmlx_read_cols_vec.addElement("col_max_len");
	//dhtmlx_read_cols_vec.addElement("contents");
	//dhtmlx_back_cols_vec.addElement("code=rcolor");
	
	String sheet_status = ListBox(request, "SL0018", "M222", "");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

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
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");

		if(status == "false") alert(msg);
		
		return true;
    }

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	if(GridObj.getColumnId(cellInd) == "EV_NO"){
    		var ev_no = GridObj.cells(rowId, cellInd).getValue();
    		var ev_year = GridObj.cells(rowId, GridObj.getColIndexById("EV_YEAR")).getValue();
    			var url = "ev_sheet_view.jsp?ev_no="+ev_no+"&ev_year="+ev_year+"&flag=I" ;
			    var left = 50;
			    var top = 100;
			    var width = 900;
			    var height = 600;
			    var toolbar = 'no';
			    var menubar = 'no';
			    var status = 'yes';
			    var scrollbars = 'no';
			    var resizable = 'no';
			    var doc = window.open( url, 'ev_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			    doc.focus();
    	}
    }

    // 그리드 셀 ChangeEvent 시점에 호출 됩니다.
    // stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    function doOnCellChange(stage,rowId,cellInd)
    {
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
    
    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		
		var grid_col_id = "<%=grid_col_id%>";
		var f = document.forms[0];
		
	    var ev_year	= LRTrim(f.ev_year.value);
	    var sg_kind	= LRTrim(f.sg_kind.value);
	    var sheet_status	= LRTrim(f.sheet_status.value);
	    
	    
	    var param ="";
	    param +="&ev_year="+ev_year ;
	    param +="&sg_kind="+sg_kind ;
	    param +="&sheet_status="+sheet_status ;

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_confirm?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
	}
	
	// 확정 ////////////////////////////////////////
	function doDecide()
	{ 	
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		var sheet_status    = "";
		var ev_year         = "";
		
		for(var i = 0; i < grid_array.length; i++){
			sheet_status    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_STATUS")).getValue());
			ev_year         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
		 	
			if(ev_year != "<%=to_year%>"){
				alert("현재년도의 심사표만 확정 할 수 있습니다.");
				return;
			}
			
			if(sheet_status != "R"){
				alert("등록인 데이터만 확정 할 수 있습니다.");
				return;
			}
		}
		
		
	    if (confirm("해당 심사표를 확정 하시겠습니까?")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_confirm?cols_ids="+cols_ids+"&mode=decide");
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	
	
	// 확정취소  ////////////////////////////////////////
	function doCancel()
	{ 	
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		var sheet_status = "";
		var ev_year = "";
		var sheet_start_cnt = "";
		var vendor_cnt      = "";
		
		for(var i = 0; i < grid_array.length; i++){
			sheet_status    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_STATUS")).getValue());
			ev_year         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
		 	sheet_start_cnt = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_START_CNT")).getValue());
		 	vendor_cnt      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("VENDOR_CNT")).getValue());
		 	
			if(ev_year != "<%=to_year%>"){
				alert("현재년도의 심사표만 확정 할 수 있습니다.");
				return;
			}
			
			if(sheet_status != "C"){
				alert("확정인 데이터만 확정취소 할 수 있습니다.");
				return;
			}
			
			if(sheet_start_cnt != "0"){
				alert("평가를 실시한업체가 있어 확정취소를 할 수 없습니다.");
				return;
			}

			if(vendor_cnt == "Y"){
				alert("적격업체대상이 선정되어 있기 때문에 확정취소를 할 수 없습니다.");
				return;
			}							
		}
		
		
	    if (confirm("해당 심사표를 확정취소 하시겠습니까?")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_confirm?cols_ids="+cols_ids+"&mode=cancel");
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length >= 1)
		{
			return true;
		}else if(grid_array.length == 0)
		{
			alert("<%=text.get("MESSAGE.1004")%>");
			return false;
		}
		
		alert("<%=text.get("MESSAGE.1006")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'selected') return;
		GridObj.SetCellValue("selected", nRow, "1");
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

		return false;
	}

	function initAjax(){
		
		doRequestUsingPOST( 'SL0116', '1#<%=info.getSession("HOUSE_CODE")%>' 		,'sg_kind', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M222' 	,'sheet_status', '' );		
<%-- 		doRequestUsingPOST( 'SL0116', '1#<%=info.getSession("HOUSE_CODE")%>' ,'sg_kind', '' ); --%>
// 		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '' );
		//doRequestUsingPOST( 'SL0018', 'M222' ,'sheet_status', '' );
		doRequestUsingPOST( 'WO100', '' ,'ev_year', '' );
	}
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>

		<form name="form1" action=""> 
		<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "심사표확정/취소";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr>
 		<td height="5"> </td>
	</tr>
	<tr>
		<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
					<td width="13%" class="se_cell_title">
						평가년도
					</td>
					<td width="20%" class="se_cell_data">
						<select id="ev_year"name="ev_year">
							<option value="">전체</option>
						</select>
					</td>
					<td width="13%" class="se_cell_title">
						평가그룹
					</td>
					<td width="20%" class="se_cell_data">
						<select id="sg_kind" name="sg_kind" class="inputsubmit">
							<option value="">
								전체
							</option>
							
						</select>
					</td>
				
					<td width="13%" class="se_cell_title">
						심사표상태
					</td>
					<td width="20%" class="se_cell_data">
						<select id="sheet_status" name="sheet_status" class="inputsubmit">
						<option value="">전체</option>
						<%=sheet_status %>
						</select> 
					</td>
					
				</tr> 
				 
			</table>
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			  <td><script language="javascript">btn("javascript:doQuery()","조회")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doDecide()","확정")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doCancel()","확정취소")</script></td>
			    	  		<%--   	<TD><script language="javascript">btn("javascript:doSelect()",2,"조 회")    </script></TD>
								<TD><script language="javascript">btn("javascript:doCreate()",7,"신 규")   </script></TD>  
								<TD><script language="javascript">btn("javascript:doModify()",12,"수 정")   </script></TD>  
								--%>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
<!-- 		  	  <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div> -->
<!--               <div id="pagingArea"></div> -->
<%--              <%@ include file="/include/include_bottom.jsp"%> --%>
		</td>
	</tr>
</table>
</form>	

<%-- <jsp:include page="/include/window_height_resize_event.jsp" > --%>
<%-- <jsp:param name="grid_object_name_height" value="gridbox=180"/> --%>
<%-- </jsp:include> --%>

<form id="ex_form" name="ex_form">
	<input type="hidden" name="flag">
	<input type="hidden" name="ev_no">
	<input type="hidden" name="ev_year">
	
</form>
</s:header>
<s:grid screen_id="WO_007" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
</html>
