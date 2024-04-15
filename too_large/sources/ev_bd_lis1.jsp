<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String to_year = SepoaDate.getYear()+"";
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_001";
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
	
		
	//dhtmlx_head_merge_cols_vec.addElement("EV_NO=전체");
	//dhtmlx_head_merge_cols_vec.addElement("SUBJECT=#cspan");
	
%>
<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
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
var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_bd_lis1";

function Init() {
	setGridObj(GridObj);
	setGridDraw();
	setHeader();
	//setAlign();
	//setFormat();
}

function setGridObj(arg) {
	GridObj = arg;
}

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
	
	function setHeader() {
		//GD_setProperty(GridObj);
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
    function doSelect()
	{
		
		var grid_col_id = "<%=grid_col_id%>";
		var f = document.forms[0];
		
	    <%-- var sheet_kind	 = LRTrim(f.sheet_kind.value);
	    var sg_kind	     = LRTrim(f.sg_kind.value);
	    var use_flag	 = LRTrim(f.use_flag.value);
	    var ev_year	     = LRTrim(f.ev_year.value);
	    var subject		 = LRTrim(f.subject.value);
	    var sheet_status = LRTrim(f.sheet_status.value);
	    
	    
	    var param ="";
	    param +="&sheet_kind="+sheet_kind ;
	    param +="&sg_kind="+sg_kind ;
	    param +="&use_flag="+use_flag ;
	    param +="&ev_year="+ev_year ;
	    param +="&subject="+encodeURIComponent( subject ) ;
	    param +="&sheet_status="+sheet_status ;

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.ev_bd_lis1?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false); --%>
		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=ev_bd_lis1";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
		
	}
	
	// 수정 ////////////////////////////////////////
	function doModify()
	{ 	
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "selected");
		var eval_no          = "";
		var ev_year 	     = "";
		var sheet_status_loc = "";
		
		for(var i = 0; i < grid_array.length; i++){
			eval_no          = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_NO")).getValue());
			ev_year          = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
		 	sheet_status_loc = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_STATUS_LOC")).getValue());
		}
		
		if(ev_year != "<%=to_year%>"){
			alert("현재년도의 심사표만 수정 할 수 있습니다.");
			return;
		}
		
		//if(sheet_status_loc != "작성" && sheet_status_loc != "확정취소" && sheet_status_loc != "등록"){
		//	alert("심사표 수정은 작성, 등록, 확정취소 일때만 수정 가능 합니다.");
		//	return;
		//}
		
		//url = "ev_pp_ins1.jsp?flag=U&eval_no="+eval_no;
		url = "ev_sheet_frameset.jsp";
	     	document.ex_form.ev_no.value = eval_no;
	     	document.ex_form.ev_year.value = ev_year;
			document.ex_form.action = url;
			document.ex_form.method = "POST";

			var newWin = window.open(url,"doPop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
			document.ex_form.target = "doPop";  
			document.ex_form.submit();  
			 newWin.focus();	
	}
	
	// 신규 //
	function doCreate() { 
		
		var frm = document.ex_form;
		frm.ev_no.value = "";
		var url = "ev_sheet_frameset.jsp";
		
		//url = "ev_pp_ins1.jsp?flag=I";
	    
			/* document.ex_form.action = url;
			document.ex_form.ev_no.value = "";
			document.ex_form.method = "POST";

			var newWin = window.open(url,"doPop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
			document.ex_form.target = "doPop";  
			document.ex_form.submit();  
			newWin.focus();	 */

		//var win = window.open("","doPop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");

		frm.method = "POST";
		frm.target = "doPop";
		frm.action = url;
		frm.submit();
		//win.focus();	
	}

	// Copy
	function doCopy(){
		if( !checkRows() )	return;
		var grid_array = getGridChangedRows(GridObj, "selected");		
		if( grid_array.length > 1 ){
			alert("한개씩의 심사표만 선택 가능합니다.");
			return;
		}
		
		var form         = document.forms[0];
		var temp_ev_no   = "";
		var temp_ev_year = "";
		var temp_subject = "";
		var sheet_status_loc = "";
		
		for( var i = 0; i < grid_array.length; i++ ){
			temp_ev_no       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_NO")).getValue());
			temp_ev_year     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
			temp_subject     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SUBJECT")).getValue());
			sheet_status_loc = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_STATUS_LOC")).getValue());
			if( sheet_status_loc != "확정" ){
				alert("심사표상태가 확정인 경우에만 복사가 가능합니다.");
				return;
			}
		}
		
	    if (confirm("<%=text.get("MESSAGE.9872")%>")){
            var cols_ids = "<%=grid_col_id%>";
            var param    = "?mode=copy&cols_ids="+cols_ids;
                param   += "&temp_ev_no="        + temp_ev_no;
                param   += "&temp_ev_year="      + temp_ev_year;
                param   += "&temp_subject="      + temp_subject;

		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }		
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
		var pop      = obj.getAttribute("POP");
		var ev_no    = obj.getAttribute("ev_no");
		var ev_year  = obj.getAttribute("ev_year");

		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			doSelect();
			if( pop == "Y" ){
				url = "ev_sheet_frameset.jsp";
		     	document.ex_form.ev_no.value   = ev_no;
		     	document.ex_form.ev_year.value = ev_year;
				document.ex_form.action        = url;
				document.ex_form.method        = "POST";
				document.ex_form.target        = "doPop"; 
				 
				var newWin = window.open(url,"doPop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
				document.ex_form.submit();  
				newWin.focus();				
			}
		} else {
			alert(messsage);
		}

		return false;
	}

	function doDelete(){
		if( !checkRows() ) return;

		var grid_array = getGridChangedRows(GridObj, "selected");

		var ev_no        = "";
		var sheet_status = "";
		
		for( var i = 0; i < grid_array.length; i++ ){
			ev_no        = LRTrim( GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_NO")).getValue()      );
			sheet_status = LRTrim( GridObj.cells(grid_array[i], GridObj.getColIndexById("SHEET_STATUS")).getValue() );
			if( sheet_status != 'W' && sheet_status != 'R' ){
				alert("심사표의 진행상태가 작성,등록 일때에만 삭제가 가능합니다.");
				return;
			}
		}

		var grid_array = getGridChangedRows(GridObj, "selected");

	   	if (confirm("심사표를 삭제하시겠습니까?")){
	   		var cols_ids = "<%=grid_col_id%>";
	   		var params;
	   		params = "?mode=delete";
	   		params += "&cols_ids=" + cols_ids;
	   		params += dataOutput();
	   		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	   		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	   		sendTransactionGrid(GridObj, myDataProcessor, "selected",grid_array);	   		
	   	}
	}

	/* function initAjax(){
		doRequestUsingPOST( 'SL0018', 'M216' ,'sheet_kind', '' );
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '' );
		doRequestUsingPOST( 'SL0018', 'M220' ,'sheet_status', '' );
		doRequestUsingPOST( 'WO100', '' ,'ev_year', '' );
	} */
	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        getQuery();
	    }
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="Init();">
<s:header>
<%@ include file="/include/include_top.jsp"%>
<%@ include file="/include/sepoa_milestone.jsp"%>

<form name="form1" action="">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr>
 		<td height="5">
	</tr>
	<tr>
		<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
					<td width="15%" class="se_cell_title">
						평가년도
					</td>
					<td width="18%" class="se_cell_data">
						<select name="ev_year" id="ev_year">
							<option value="">전체</option>
							<%
							 String ly = ListBox(request, "WO100" ,house_code+"#", "");
							 out.println(ly);
							 %>	
						</select>
					</td>				
					
					<td width="15%" class="se_cell_title">
						평가그룹
					</td>
					<td width="18%" class="se_cell_data">
						<select name="sg_kind" id="sg_kind" class="inputsubmit">
							<option value="">
								전체
							</option>
							<%
							 String lg = ListBox(request, "W001" ,"1#", "");
							 out.println(lg);
							 %>
							
						</select>
					</td>
					<td width="15%" class="se_cell_title">
						적용여부
					</td>
					<td width="19%" class="se_cell_data">
						<select name="use_flag" id="use_flag" class="inputsubmit">
							<option value="">전체</option> 
							<option value="Y">Y</option> 
							<option value="N">N</option> 
						</select> 
					</td>					
				</tr>
				<tr>
					<td class="se_cell_title">
						평가종류
					</td>
					<td class="se_cell_data">
						<select name="sheet_kind" id="sheet_kind" class="inputsubmit">
							<option value="">
								전체
							</option>
							<%
							 String lk = ListBox(request, "SL0018" ,house_code+"#M216#", "");
							 out.println(lk);
							 %>
						</select>
					</td>
			    	<td class="se_cell_title">
						진행상태
					</td>
					<td class="se_cell_data" colspan="3">
						<select name="sheet_status" id="sheet_status" class="inputsubmit">
							<option value="">전체</option> 
							<%
							 String ls = ListBox(request, "SL0018" ,house_code+"#M220#", "");
							 out.println(ls);
							 %>
						</select> 
					</td>									
				</tr> 
				
			    <tr>
			     	<td class="se_cell_title">
			        	<div align="left">심사표제목</div>
			      	</td>
			      	<td class="se_cell_data" colspan="5"> 
			      		<input type="text" name="subject" id="subject" class="inputsubmit" style="width:360px;" onkeydown='entKeyDown()'>
			        </td> 
			    </tr> 
			</table>
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			  <td><script language="javascript">btn("javascript:doSelect()","조회")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doCreate()","신규생성")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doModify()","수정")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:doCopy()","COPY")</script></td>
			    	  			
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		</td>
	</tr>
</table>
<input type="text" style="visibility: hidden">

</form>

<form name="ex_form">
	<input type="hidden" name="flag"      id="flag"    />            
	<input type="hidden" name="ev_no"     id="ev_no"   />           
	<input type="hidden" name="ev_year"   id="ev_year" />         
	
</form>
</body>

</s:header>
<s:grid screen_id="WO_001" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>