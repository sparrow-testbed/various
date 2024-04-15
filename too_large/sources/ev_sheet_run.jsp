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
	multilang_id.addElement("WO_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");
	String id       = info.getSession("ID");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_008";
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
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_run";

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
		var sheet_kind     = GridObj.getUserData("", "SHEET_KIND")==null?"":GridObj.getUserData("", "SHEET_KIND");
		var sg_kind     = GridObj.getUserData("", "SG_KIND")==null?"":GridObj.getUserData("", "SG_KIND");
		var period     = GridObj.getUserData("", "PERIOD")==null?"":GridObj.getUserData("", "PERIOD");
		var use_flag     = GridObj.getUserData("", "USE_FLAG")==null?"":GridObj.getUserData("", "USE_FLAG");
		var ev_year     = GridObj.getUserData("", "EV_YEAR")==null?"":GridObj.getUserData("", "EV_YEAR");
		var sheet_status     = GridObj.getUserData("", "SHEET_STATUS")==null?"":GridObj.getUserData("", "SHEET_STATUS");
		var st_date     = GridObj.getUserData("", "ST_DATE")==null?"":GridObj.getUserData("", "ST_DATE");
		var end_date     = GridObj.getUserData("", "END_DATE")==null?"":GridObj.getUserData("", "END_DATE");
		var delete_flag     = GridObj.getUserData("", "DELETE");
		
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");
		if(status == "false") alert(msg);
		if(delete_flag == "true"){
			alert(msg);
		}else if(delete_flag == "false"){
			alert(msg);
		}
		
		document.form1.sheet_kind.value = sheet_kind;
		document.form1.sg_kind.value =  sg_kind;
		document.form1.period.value =  period;
		document.form1.ev_year.value =  ev_year;
		document.form1.sheet_status.value =  sheet_status;
		document.form1.st_date.value =  st_date;
		document.form1.end_date.value =  end_date;
		
		if(use_flag == "Y"){
			document.form1.use_flag.checked = true;
		}
		return true;
    }

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());

    	if(GridObj.getColumnId(cellInd) == "SELLER_CODE"){
    	
    		var ev_no = GridObj.cells(rowId, GridObj.getColIndexById("EV_NO")).getValue();
    		var ev_year = GridObj.cells(rowId, GridObj.getColIndexById("EV_YEAR")).getValue();
    		var seller_code = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_CODE")).getValue();
    		var seller_name_loc = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_NAME_LOC")).getValue();
    		var sg_regitem = GridObj.cells(rowId, GridObj.getColIndexById("SG_REGITEM_CODE")).getValue();
    		var eval_id = GridObj.cells(rowId, GridObj.getColIndexById("EVAL_ID")).getValue();
			 url = "ev_sheet_run_view.jsp";
	     	document.ex_form.ev_no.value = ev_no;
	     	document.ex_form.ev_year.value = ev_year;
	     	document.ex_form.seller_code.value = seller_code;
	     	document.ex_form.seller_name_loc.value = seller_name_loc;
	     	document.ex_form.sg_regitem.value = sg_regitem;
	     	document.ex_form.eval_id.value = eval_id;
			document.ex_form.action = url;
			document.ex_form.method = "POST";
	
			var newWin_pop = window.open(url,"view_pop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
			document.ex_form.target = "view_pop";  
			document.ex_form.submit();  
			newWin_pop.focus();	
			
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
		
	    var ev_no	= LRTrim(f.ev_no.value);
	    
// 	    if(ev_no == ""){
// 	    	alert("심사표를 선택하세요.");
// 	    	return;
// 	    }
	    
	    var param ="";
	    param +="&ev_no="+ev_no ;

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_run?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
	}
	
	// 평가실행 ////////////////////////////////////////
	function doEvaluation()
	{
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		var ev_no = "";
		var ev_year = "";
		var et_date = "";
		var confirm_flag = "";
		var seller_code = "";
		var seller_name_loc = "";
		var sg_regitem = "";
		var ev_date    = "";
		var reg_date_2 = "";
		var eval_id    = "";
		
		for(var i = 0; i < grid_array.length; i++){
			ev_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_NO")).getValue());
			ev_year = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
			et_date = del_Slash(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ET_DATE")).getValue()));
			confirm_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_FLAG")).getValue());
			seller_code = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_CODE")).getValue());
			seller_name_loc = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_NAME_LOC")).getValue());
			sg_regitem = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SG_REGITEM_CODE")).getValue());
			ev_date = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_DATE")).getValue());
			reg_date_2 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("REG_DATE_2")).getValue());
			eval_id    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EVAL_ID")).getValue());
			

			if( eval_id != "<%=id%>" ){
				alert("평가자만 평가 실행할 수 있습니다.");
				return;
			}
			
			if(parseInt(et_date) > parseInt("<%=to_day%>")){
				alert("평가실행은 업체입력종료일이 지난 후에 할 수 있습니다.");
				return;
			}
			
			if(confirm_flag != "평가중"){
				alert("평가실행은 진행상태가 평가중일때만 가능 합니다.");
				return;
			}
		}
		
		
	    url = "ev_sheet_run_pop.jsp";
     	document.ex_form.ev_no.value = ev_no;
     	document.ex_form.ev_year.value = ev_year;
     	document.ex_form.seller_code.value = seller_code;
     	document.ex_form.seller_name_loc.value = seller_name_loc;
     	document.ex_form.sg_regitem.value = sg_regitem;
     	document.ex_form.ev_date.value = ev_date;
     	document.ex_form.reg_date_2.value = reg_date_2;
     	document.ex_form.eval_id.value = eval_id;
     	
     	
		document.ex_form.action = url;
		document.ex_form.method = "POST";

		var newWin = window.open(url,"Evaluation","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
		document.ex_form.target = "Evaluation";  
		document.ex_form.submit();  
		newWin.focus();	
	}

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length == 1)
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

	
	function searchProfile(part)
	{
		var f = document.forms[0];
	
		if( part == "sheet_no" )
		{
				PopupCommon1("SP5002", "getSheet_no", "", "심사표번호", "심사표제목");
			
		}

	}
	
	function getSheet_no(code,text) {
		document.forms[0].ev_no.value = code;
		document.forms[0].subject.value = text;
	}
	
	function initAjax(){
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M216' ,'sheet_kind', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M218' ,'period', '' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M221' ,'sheet_status', '' );
	}
	
	//평가취소
	function doCancel(){
		var grid_array = getGridChangedRows(GridObj, "selected");
		var ev_no      = document.form1.ev_no.value;
		if( ev_no == "" ){
			alert("평가취소할 SHEET를 선택하여 주십시요.");
			return;
		}
		
		if (confirm("<%=to_year%>년도 적격업체평가를 취소하시겠습니까?")) {
            var cols_ids = "<%=grid_col_id%>";
            var param    = "?mode=cancel";
                param   += "&to_year=" + "<%=to_year%>";
                param   += "&ev_no="   + ev_no;
                param   += "&grid_col_id="   + cols_ids;
			
			GridObj.post(G_SERVLETURL + param);
			GridObj.clearAll(false);			
		}
	}
	//지우기
	function doRemove( type ){
	    if( type == "ev_no" ) {
	    	document.forms[0].ev_no.value = "";
	        document.forms[0].subject.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>

		<form id="form1" name="form1" action=""> 
		<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "평가실시";
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
					<td width="20%" class="se_cell_title">
						심사표번호
					</td>
					<td width="30%" class="se_cell_data">
						<input type="text" id="ev_no" name="ev_no" class="inputsubmit" readonly="readonly" value="" onkeydown='entKeyDown()'>
						<a href="javascript:searchProfile('sheet_no')">
							<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
						</a>
						<a href="javascript:doRemove('ev_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
					</td>
					<td width="20%" class="se_cell_title">
						심사표제목
					</td>
					<td width="30%" class="se_cell_data">
						<input type="text" id="subject" name="subject" class="input_empty" size="50" onkeydown='entKeyDown()' readonly="readonly" value="">
					</td>
				
				</tr>
				<tr>
	        		<td width="20%" height="24" class="se_cell_title">
	        			평가종류
					</td>
					<td width="30%" height="24" class="se_cell_data">
						<select id="sheet_kind" name="sheet_kind" class="inputsubmit"  disabled="disabled">
							<option value="">
							</option>
						</select>	
					</td>
					<td width="20%" height="24" class="se_cell_title">
						평가그룹
					</td>
					<td width="30%" height="24" class="se_cell_data">
						<select id="sg_kind" name="sg_kind" class="inputsubmit"  disabled="disabled">
							<option value="">
							</option>
						</select>
					</td>
				</tr>
			    <tr>
	        		<td width="20%" height="24" class="se_cell_title">
	        			평가시기
	        		</td>
					<td width="30%" height="24" class="se_cell_data">
						<select id="period" name="period" class="inputsubmit"  disabled="disabled">
							<option value="">
							</option>
						</select>
					</td>
					<td width="20%" height="24" class="se_cell_title">
						적용여부
					</td>
					<td width="30%" height="24" class="se_cell_data">
						<input type="checkbox" id="use_flag" name="use_flag" class="inputsubmit"   disabled="disabled">
					</td>
				</tr>
			    <tr>
	        		<td width="20%" height="24" class="se_cell_title">
						평가년도
					</td>
					<td width="30%" height="24" class="se_cell_data">
						<input type="text" id="ev_year"  name="ev_year"  size="15" maxlength="15" class="input_empty" value="" onkeydown='entKeyDown()'>
					</td>
					<td width="20%" height="24" class="se_cell_title">
						진행상태
					</td>
					<td width="30%" height="24" class="se_cell_data">
						<select id="sheet_status" name="sheet_status" class="inputsubmit"  disabled="disabled">
							<option value="">
							</option>
						</select>
					</td>
					
				</tr>
			    <tr>
	        		<td width="20%" height="24" class="se_cell_title">
	        			평가적용시작일
	        		</td>
					<td width="30%" height="24" class="se_cell_data">
<!-- 						<input type="text" id="st_date"  name="st_date"  size="15" maxlength="15" class="input_empty" value="" > -->
						<s:calendar id="st_date" default_value="" format="%Y/%m/%d"/>
					</td>
					<td width="20%" height="24" class="se_cell_title">
						평가적용종료일
					</td>
					<td width="30%" height="24" class="se_cell_data">
<!-- 						<input type="text" id="end_date"  name="end_date"  size="15" maxlength="15" class="input_empty" value="" > -->
						<s:calendar id="end_date" default_value="" format="%Y/%m/%d"/>
					</td>
				</tr>
			   
			</tr>	 
				 
			</table>
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			  <td><script language="javascript">btn("javascript:doQuery()","조회")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doEvaluation()","평가실행")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doCancel()","평가취소")</script></td>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		</td>
	</tr>
</table>
</form>	
<form id="ex_form" name="ex_form">
	<input type="hidden" id="ev_no"           name="ev_no">           
	<input type="hidden" id="ev_year"         name="ev_year">         
	<input type="hidden" id="seller_code"     name="seller_code">     
	<input type="hidden" id="seller_name_loc" name="seller_name_loc"> 
	<input type="hidden" id="sg_regitem"      name="sg_regitem">      
	<input type="hidden" id="ev_date"         name="ev_date">         
	<input type="hidden" id="reg_date_2"      name="reg_date_2">      
	<input type="hidden" id="eval_id"         name="eval_id">         
	
</form>
</s:header>
<s:grid screen_id="WO_008" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
</html>
