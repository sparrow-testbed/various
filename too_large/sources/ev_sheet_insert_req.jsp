<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String dis_view 	= "";
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.nullToEmpty(request.getParameter("ev_year"));
	String ev_seq 		= JSPUtil.nullToEmpty(request.getParameter("ev_seq"));
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_006";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	// 화면에 행머지기능을 사용할지 여부의 구분
	 isRowsMergeable = true;
	
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
	
	String SUBJECT = "";
	String USE_FLAG = "";
	String SHEET_KIND = "";
	String SG_KIND = "";
	String SHEET_STATUS = "";
	String ST_END_DATE = "";
	
	 Object[] obj = {ev_no,ev_year};// 평가sheet 팝업 일반사항저장이랑 동일 서비스
	    SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getsevgl_list", obj);
	    
	    
	    SepoaFormater wf = null;
	
		wf = new SepoaFormater(value.result[0]);
    
	
		 int iRowCount = wf.getRowCount(); 
		    
		    if(iRowCount>0)
		    {
				SUBJECT      	= wf.getValue("SUBJECT",0);
				SHEET_KIND   	= wf.getValue("SHEET_KIND",0);
				SG_KIND      	= wf.getValue("SG_KIND",0);
				USE_FLAG      	= wf.getValue("USE_FLAG" , 0).equals("Y")?"checked":"";
				ST_END_DATE    	= wf.getValue("ST_DATE",0)+"~"+wf.getValue("END_DATE",0);
			}
%>

<html>
	<head>
		<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/sec.js"></script>

<script src="../js/cal.js" language="javascript"></script>

<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

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
    	doQuery();
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
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
		var ev_seq 	= f.ev_seq.value;
		
		var param = "";
		
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
		param += "&ev_seq="+ev_seq;
		
		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.ev_sheet_insert_req?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
	}
	
	function doInsert() { 
   		
   		 <%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		    }
		if(!checkRows())return;
		var f = document.forms[0];
		var	ev_no	=	f.ev_no.value; 
		var ev_year	=	f.ev_year.value;
		var ev_seq	=	f.ev_seq.value;
	   	
	   	var grid_array = getGridChangedRows(GridObj, "selected");
		for(var i = 0; i < grid_array.length; i++)
		{
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_REQ_DESC")).getValue()) == "")
			{
				alert("질의항목을 입력하세요.");
				return;
			}
			
			
		}
		var param= "";
		param += "&ev_seq=" + ev_seq;
		param += "&ev_year="+ev_year;
		param += "&ev_no="+ev_no;
		
		
		
	    if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.ev_sheet_insert_req?cols_ids="+cols_ids+"&mode=insert"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	
	function doDelete(){
		
		 <%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		    }
		    
		var f = document.forms[0];
		var ev_no = f.ev_no.value;
		var ev_year = f.ev_year.value;
		var ev_seq = f.ev_seq.value;
		
		if(ev_seq == ""){
			alert("해당 평가항목은 데이터가 존재하지 않습니다.");
			return;
		}
		
		var param= "";
		param += "&ev_no=" + ev_no;
		param += "&ev_year="+ev_year;
		param += "&ev_seq="+ev_seq;
		
		var grid_array = getGridChangedRows(GridObj, "selected");
		
	    if (confirm("<%=text.get("MESSAGE.1015")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.ev_sheet_insert?cols_ids="+cols_ids+"&mode=delete"+param);
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


	function initAjax(){
		doRequestUsingPOST( 'SL0018', 'M216' ,'sheet_kind', '<%=SHEET_KIND%>' );
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '<%=SG_KIND%>' );
		doRequestUsingPOST( 'SL0018', 'M220' ,'sheet_status', '<%=SHEET_STATUS%>' );
	}


	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var ev_seq   = obj.getAttribute("ev_seq");
		var reset   = obj.getAttribute("reset");
		var del_flag   = obj.getAttribute("del_flag");

		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			if(del_flag == "Y"){
				opener.page_reset();
				window.close();
			}
		} else {
			alert(messsage);
		}

		return false;
	}
	
	
    
  
    
  

	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">

		<form name="form1" action=""> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr>
 		<td height="5"> </td>
		<input type="text"  name="ev_seq" value="<%=ev_seq%>" size="15" maxlength="15" readonly="readonly">
	</tr>
	<tr>
		<td width="100%" valign="top">
		
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
					<td width="15%" class="se_cell_title">
						평가Sheet번호
					</td>
					<td width="18%" class="se_cell_data">
						<input type="text" class="input_empty" name="ev_no" value="<%=ev_no%>" style="width:150px;">
					</td>
					<td width="15%" class="se_cell_title">
						평가Sheet제목
					</td>
					<td class="se_cell_data" colspan="3" >
						<input type="text" class="input_empty" name="subject" value="<%=SUBJECT%>" style="width:300px;">
					</td>
					
				</tr>
				<tr> 
					<td width="15%" class="se_cell_title">
						평가종류
					</td>
					<td width="18%" class="se_cell_data">
						<select name="sheet_kind" class="inputsubmit" disabled>
							
						</select>
					</td>
					<td width="15%" class="se_cell_title">
						평가그룹
					</td>
					<td width="18%" class="se_cell_data">
						<select name="sg_kind" class="inputsubmit" disabled>
							
						</select>
					</td>
					<td width="15%" class="se_cell_title">
						평가Sheet 진행상태
					</td>
					<td width="18%" class="se_cell_data">
						<select name="sheet_status" class="inputsubmit" disabled>
						</select>
					</td>
				</tr>
				<tr> 
					<td width="15%" class="se_cell_title">
						적용여부
					</td>
					<td width="18%" class="se_cell_data">
						 <input type="checkbox" name="use_flag" class="inputsubmit"  <%=USE_FLAG%> disabled>  
					</td>
					<td width="15%" class="se_cell_title">
						평가년도
					</td>
					<td width="18%" class="se_cell_data">
						<input type="text" name="ev_year"  size="15" maxlength="15" class="input_empty" value="<%=ev_year %>">
						
					</td>
					<td width="15%" class="se_cell_title">
						평가적용시작/종요일
					</td>
					<td width="18%" class="se_cell_data">
						<input type="text" name="st_end_date"  size="20" maxlength="20" class="input_empty" value="<%= ST_END_DATE%>">
						
					</td>
				</tr> 
			    
			</table>
			
		  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			   <td><script language="javascript">btn("javascript:doInsert()","등록")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
			    	  			  
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		  	  <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              <div id="pagingArea"></div>
             <%@ include file="/include/include_bottom.jsp"%>
		</td>
	</tr>
</table>
</form>	

<jsp:include page="/include/window_height_resize_event.jsp" >
<jsp:param name="grid_object_name_height" value="gridbox=280"/>
</jsp:include>

</body>
</html>
</html>
