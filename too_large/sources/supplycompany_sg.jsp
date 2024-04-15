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
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_101");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_101";
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
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><%-- Ajax SelectBox용 JSP--%>
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
		
		var nMaxRow2 = dhtmlx_last_row_id;

		for( var i = 1; i <= nMaxRow2; i++ ){
			GridObj.cells(i, GridObj.getColIndexById("sg_type1")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("sg_type2")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("sg_type3")).setDisabled(true);		
		}
		
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
		
	    var company_code	= LRTrim(f.company_code.value);
	   	
	   	if(company_code == ""){
	    	alert("업체코드를 선택하십시요.");
	    	return;
	    }
	    
	    var param ="";
	    param +="&company_code="+company_code ;

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/srm.supplycompany_sg?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
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


	function initAjax(){
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );
	}
	
	function nextAjax(type){
		
		var f = document.forms[0];
		if(type == '2'){
			
			var sg_refitem=f.sg_type1.value;
			
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			sg_type2_id.options.length = 0; //길이 0으로
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if(sg_refitem.valueOf().length > 0) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath = document.getElementById("sg_type2");
				var ooption = document.createElement("option");
				
				ooption.text = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				//doRequestUsingPOST( 'SP9196', account_type ,'account_code', '' );
			}else {
				var nodePath = document.getElementById("sg_type2");
				var ooption = document.createElement("option");
				
				ooption.text = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			
			}
			
		}else if(type == '3'){
			var sg_refitem=f.sg_type2.value;
			
			var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
			sg_type3_id.options.length = 0; //길이 0으로
//			sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type3_id).trigger("onchange");
			if(sg_refitem.valueOf().length > 0) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath = document.getElementById("sg_type3");
				var ooption = document.createElement("option");
				
				ooption.text = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'sg_type3', '' );
			}else{
				var nodePath = document.getElementById("sg_type3");
				var ooption = document.createElement("option");
				
				ooption.text = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	
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
	
	//  등록
	function doInsert()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");
		var f = document.forms[0];
		var company_code = f.company_code.value;
		
		if(company_code == ""){
	    	alert("업체코드를 선택하십시요.");
	    	return;
	    }
		
		if( !checkRows() ) return;
		
		for(var i = 0; i < grid_array.length; i++)
		{
			<%-- 적용상태는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("apply_flag")).getValue()) == "")
			{
				//alert("<%=text.get("적용상태를 체크 하십시요.")%>");
				alert(grid_array[i]+"번째 행에 적용상태를 체크 하십시요.");
				return;
			}
		}
		
		var param= "";
		param += "&company_code= "+company_code;
		
	    if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/srm.supplycompany_sg?cols_ids="+cols_ids+"&mode=insert"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}
	
	// 행추가 이벤트 입니다.
	function doAddRow()
    {
    	var f = document.forms[0];
    	
    	var sg_type1=f.sg_type1.value;
    	var sg_type2=f.sg_type2.value;
    	var sg_type3=f.sg_type3.value;
    	var company_code = f.company_code.value;
    	var company_name = f.company_name.value;
    	
    	if(company_code == ""){
	    	alert("업체코드를 선택하십시요.");
	    	return;
	    }
    	
    	if(sg_type1=="" || sg_type2=="" || sg_type3==""){
    		alert("대,중,소 분류를 입력하십시요.");
    		return;
    	}
    	
    	var param    = "?sg_type1="     + sg_type1;
		    param   += "&sg_type2="     + sg_type2;
		    param   += "&sg_type3="     + sg_type3;
		    param   += "&company_code=" + company_code;
		    param   += "&company_name=" + encodeURIComponent( company_name );
		
		f.method = "POST";
		f.target = "childFrame";
		f.action = "sg_addRowCheck.jsp" + param;
		f.submit();
    }
    
    function setdoAddRow( ischkNum, sg_type1, sg_type2, sg_type3, company_code, company_name ){
    	//ischkNum 0     : 등록가능(데이터가없다)
    	//ischkNum 1이상  : 등록되어있음(데이터가있다)
    	
    	//ischkNum2 0    : 행을 추가한다
    	//ischkNum2 1    : 추가된 행이있다
    	
    	
    	
    	var ischkNum2 = 0; 
    	var nMaxRow2  = dhtmlx_last_row_id;

    	if( ischkNum == 0 ){
    		for( var i = 1; i <= nMaxRow2; i++ ){
    			var data_sg_type1     = LRTrim(GridObj.cells(i, GridObj.getColIndexById("sg_type1")).getValue());
	    		var data_sg_type2     = LRTrim(GridObj.cells(i, GridObj.getColIndexById("sg_type2")).getValue());
	    		var data_sg_type3     = LRTrim(GridObj.cells(i, GridObj.getColIndexById("sg_type3")).getValue());
	 			
	 			if( data_sg_type1 == sg_type1 && data_sg_type2 == data_sg_type2 && data_sg_type3 == sg_type3 && data_company_code == company_code ){
	 				alert("등록하려고 추가한 데이터가 있습니다.");
	 				ischkNum2 = 1;
	 				return;
	 			}
    		}
    	
	    	if( ischkNum2 == 0 ){
		    	dhtmlx_last_row_id++;
		    	var nMaxRow2 = dhtmlx_last_row_id;
		    	var row_data = "<%=grid_col_id%>";
				GridObj.enableSmartRendering(true);
				GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		    	GridObj.selectRowById(nMaxRow2, false, true);
		    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).cell.wasChanged = true;
				
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")        ).setValue("1");
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type1")		   ).setValue(sg_type1);
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type2")        ).setValue(sg_type2);
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type3")        ).setValue(sg_type3);
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("apply_flag")).setValue("Y");
				
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type1")).setDisabled(true);
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type2")).setDisabled(true);
				GridObj.cells(nMaxRow2, GridObj.getColIndexById("sg_type3")).setDisabled(true);
				dhtmlx_before_row_id = nMaxRow2;    		
	    	}		
    	}
    	else{
    		alert("등록된 데이터가 있습니다.");
    	}
    }
    
    // 행삭제시 호출 되는 함수 입니다.
    function doDeleteRow()
    {
    	var grid_array = getGridChangedRows(GridObj, "selected");
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);

    	for(var row = rowcount - 1; row >= 0; row--)
		{
			if("1" == GridObj.cells(grid_array[row], 0).getValue())
			{
				GridObj.deleteRow(grid_array[row]);
				dhtmlx_last_row_id--;
        	}
	    }
    }
    
    function doDelete()
	{
    	if( !checkRows() ) return;
    	var f          = document.forms[0];
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		var vendor_code = "";
		var sg_type3     = "";
		
		for( var i = 0; i < grid_array.length; i++ ){
			sg_type3     = GridObj.cells(grid_array[i], GridObj.getColIndexById("sg_type3")).getValue();
			vendor_code = GridObj.cells(grid_array[i], GridObj.getColIndexById("vendor_code")).getValue();
			<%-- DB에 존재 하지 않는 값일경우--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("seller_sg_refitem")).getValue()) == ""){
				alert(grid_array[i]+"번째 행은 DB에 등록 되어 있지 않습니다.");
				return;
			}
		}
		
    	var param  = "?sg_type3="     + sg_type3;
    		param += "&vendor_code=" + vendor_code;

		f.method = "POST";
		f.target = "childFrame";
		f.action = "vendor_sg_delCheck.jsp" + param;
		f.submit();			
	}
	
	function setvendor_sgDelete( count ){
		if( count > 0 ){
			alert("심사표로 등록이 되어있는 항목입니다. 삭제할 수 없습니다.");
			return;
		}
		   	
	   	var grid_array = getGridChangedRows(GridObj, "selected");
	   	if (confirm("<%=text.get("MESSAGE.1015")%>")){
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/srm.supplycompany_sg?cols_ids="+cols_ids+"&mode=delete");
			sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
		}
	}	
	
	function searchProfile(part)
	{
		var f = document.forms[0];
	
		if( part == "company_code" )
		{
				//PopupCommon1("SP0054", "getVendor_code", "", "업체코드", "업체명");
				//PopupCommon1("SP5001", "getVendor_code", "", "업체코드", "업체명");
			window.open("/common/CO_014.jsp?callback=getVendor_code", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
			
		}

	}
	
	function getVendor_code(code,text) {
		document.forms[0].company_code.value = code;
		document.forms[0].company_name.value = text;
	}

	//지우기
	function doRemove( type ){
	    if( type == "company_code" ) {
	    	document.forms[0].company_code.value = "";
	        document.forms[0].company_name.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        getQuery();
	    }
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax()">
<s:header>

<form id="form1" name="form1" action=""> 
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "공급업체/소싱그룹연결등록";
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
					<td width="15%" class="se_cell_title">
						업체코드
					</td>
					<td width="35%" class="se_cell_data">
						<input type="text" id="company_code" name="company_code" class="inputsubmit" readonly="readonly" onkeydown='entKeyDown()'>
						<a href="javascript:searchProfile('company_code')">
							<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
						</a>
						<a href="javascript:doRemove('company_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
					</td>
					<td width="15%" class="se_cell_title">
			        <div align="left">업체명</div>
			      </td>
			      <td width="35%" class="se_cell_data" > 
			      	<input type="text" id="company_name" name="company_name" class="inputsubmit" onkeydown='entKeyDown()'>
			        </td>
				</tr>
			</table>
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			  <td><script language="javascript">btn("javascript:doQuery()","조회")</script></td>
			    	  			  
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
		  	
		  	<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
		  			<td width="15%" class="se_cell_title">
			        <div align="left">소싱그룹 대분류</div>
				    </td>
				    <td width="18%" class="se_cell_data" > 
				    	<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax(2);">
				    		<option value="">--------
				    		</option>
				    	</select>
				    </td>
				   
					<td width="15%" class="se_cell_title">
						소싱그룹 중분류
					</td>
					<td width="18%" class="se_cell_data">
						<select id="sg_type2" name="sg_type2" class="inputsubmit" onchange="nextAjax(3);">
				    		<option value="">--------
				    		</option>
				    	</select>
					</td>
				    
				    <td width="15%" class="se_cell_title">
			        <div align="left">소싱그룹 소분류</div>
				    </td>
				    <td width="18%" class="se_cell_data" > 
				    	<select id="sg_type3" name="sg_type3" class="inputsubmit">
				    		<option value="">--------
				    		</option>
				    	</select>
				    </td>
				 </tr>
			 </table>
			 
			 <table width="98%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
								<td><script language="javascript">btn("javascript:doAddRow()","행삽입")</script></td>
			    	  			<td><script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script></td>
			    	  			<td><script language="javascript">btn("javascript:doInsert()","등록")</script></td>
			    	  			<td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
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
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="WO_101" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>

