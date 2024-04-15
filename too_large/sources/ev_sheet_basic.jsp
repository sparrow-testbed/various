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
	String to_year = SepoaDate.getYear()+"";
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");

	String dis_view 	= "";
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));

	Vector multilang_id = new Vector();	
	multilang_id.addElement("WO_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_005";
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
	
	String EV_YEAR     = JSPUtil.nullToEmpty(request.getParameter("ev_year")).equals("")?to_year:JSPUtil.nullToEmpty(request.getParameter("ev_year"));
	String SUBJECT     = "";
	String SHEET_KIND  = "";
	String SG_KIND     = "";
	String PERIOD      = "";
	String USE_FLAG    = "";
	String ACCEPT_VALUE= "";
	String ST_DATE     = to_day;
	String END_DATE    = to_year+"1231";
	String SHEET_STATUS = "";
	
	// ev_no가 존재할 경우만 탄다.
	if(!ev_no.equals("")) {
		dis_view = "disabled"; 
		
			 
	    Object[] obj = {ev_no,EV_YEAR};
	    SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getsevgl_list", obj);
	    
	    
	    SepoaFormater wf = null;
	
		wf = new SepoaFormater(value.result[0]);
    
	
		 int iRowCount = wf.getRowCount(); 
		    
		    if(iRowCount>0)
		    {
				EV_YEAR         = wf.getValue("EV_YEAR",0);
				SUBJECT      	= wf.getValue("SUBJECT",0);
				SHEET_KIND   	= wf.getValue("SHEET_KIND",0);
				SG_KIND      	= wf.getValue("SG_KIND",0);
				PERIOD       	= wf.getValue("PERIOD",0);
				USE_FLAG      	= wf.getValue("USE_FLAG" , 0).equals("Y")?"checked":"";
				ACCEPT_VALUE 	= wf.getValue("ACCEPT_VALUE",0);  
				ST_DATE      	= wf.getValue("ST_DATE",0);  
				END_DATE     	= wf.getValue("END_DATE",0);
				SHEET_STATUS	= wf.getValue("SHEET_STATUS",0);
			}
	 
	}
	

	
	//String LB_SHEET_KIND = ListBox(request, "SL0018", HOUSE_CODE + "#"+"M216", SHEET_KIND);
	//String LB_BIZ_TYPE = ListBox(request, "SL0018", HOUSE_CODE + "#"+"M217", BIZ_TYPE);
	//String LB_PERIOD = ListBox(request, "SL0018", HOUSE_CODE + "#"+"M218", PERIOD);
	String LB_SHEET_KIND = ListBox(request, "SL0018",house_code+"#M216#", SHEET_KIND);
	String LB_PERIOD = ListBox(request, "SL0018", house_code+"#M218#", PERIOD);
	
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
	
	function Init(){
		setGridObj(GridObj);
		setGridDraw();
		//setHeader();
		
	}
	
	function setGridObj(arg) {
		GridObj = arg;
	}
	
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	<%if(!"".equals(ev_no)){%>
    		doQuery();
    	<%}%>
    	
	
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

		if(status == "false"){
		 alert(msg);
		 }
		 rock_ck();
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
    
    // 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var ev_no   = obj.getAttribute("ev_no");

		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert("정상적으로 처리되었습니다.");
			pass_pass(messsage);
		} else {
			alert(messsage);
		}

		return false;
	}
    
     function doQuery()
	{
		
		var grid_col_id = "<%=grid_col_id%>";
		var f = document.forms[0];
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
	
		
		var param = "";
		
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
	
		

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_basic?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);
	}
	
	function doInsert()
	 { 

	    <%=grid_obj%>.setCheckedRows(0, true);
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		    }
   		
   		
		if(!checkRows())return;
		
		var f = document.forms[0];
		var sheet_kind = f.sheet_kind.value;
		var sg_kind = f.sg_kind.value;
		var period = f.period.value;
		var use_flag = (true == f.use_flag.checked)?"Y":"N";  
		f.use_flag.value = use_flag; 
		
		var ev_year = f.ev_year.value;
		var accept_value = f.accept_value.value;
		var st_date = del_Slash(f.st_date.value);
		var end_date = del_Slash(f.end_date.value);
		var subject = f.subject.value;
		var ev_no	= f.ev_no.value;
		var sheet_status = f.sheet_status.value;
		
	   	if(sheet_kind == ""){
	   		alert("평가종류를 선택하세요.");
	   		return;
	   	}
	   	if(sg_kind == ""){
	   		alert("평가그룹을 선택하세요.");
	   		return;
	   	}
	   	if(period == ""){
	   		alert("평가시기를 선택하세요.");
	   		return;
	   	}
	   	if(ev_year == ""){
	   		alert("평가년도를 입력하세요.");
	   		return;
	   	}
	   	if(accept_value == ""){
	   		alert("적격점수를 입력하세요.");
	   		return;
	   	}
	   	if(!IsNumber1(accept_value)){
	   		alert("적격점수는 숫자만 입력 가능 합니다.");
	   		f.accept_value.focus();
	   		return;
	   	}
	   	if(accept_value > 100){
	   		alert("적격점수는 100점 이하 이여야 합니다.");
	   		f.accept_value.focus();
	   		return;
	   	}
	   	
	   	if(st_date == ""){
	   		alert("평가적용시작일을 입력하세요.");
	   		return;
	   	}
	   	if(end_date == ""){
	   		alert("평가적용종료일을 입력하세요.");
	   		return;
	   	}
	   	if(eval(st_date) > eval(end_date)){
	   		alert("평가적용일을 다시 입력하세요.");
	   		return;
	   	}
	   	if(subject == ""){
	   		alert("평가제목을 입력하세요.");
	   		f.subject.focus();
	   		return;
	   	}
	   	
	   	//var grid_array = getGridChangedRows(GridObj, "selected");
		
	   	
	   	
		var paramhd = "";
		
		/* paramhd += "&ev_no= "+ev_no;
		paramhd += "&sheet_kind= "+sheet_kind;
		paramhd += "&sg_kind= "+sg_kind;
		paramhd += "&period= "+period;
		paramhd += "&use_flag= "+use_flag;
		paramhd += "&ev_year= "+ev_year;
		paramhd += "&accept_value= "+accept_value;
		paramhd += "&st_date= "+st_date;
		paramhd += "&end_date= "+end_date;
		paramhd += "&subject= "+encodeUrl(subject);
		paramhd += "&sheet_status= "+sheet_status; */
		
		
		
	    if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            //var cols_ids = "<%=grid_col_id%>";
		    // myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_basic?cols_ids="+cols_ids+"&mode=insert"+param);
		    //sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
		    
		    var G_SERVLETURL =  "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_basic";
		    var grid_array = getGridChangedRows(GridObj, "SELECTED");
		    var cols_ids = "<%=grid_col_id%>";
		    var params;
		    params = "?mode=setInsert";
		    params += paramhd;
		    params += "&cols_ids=" + cols_ids;
		    params += dataOutput();
		    myDataProcessor = new dataProcessor(G_SERVLETURL+params);
		    //myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
        }
	}

	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
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

	
	
	function pass_pass(ev_no){
		document.form1.ev_no.value=ev_no;
	    parent.up.form1.save_flag.value = "true";
	    parent.up.form1.ev_no.value = ev_no;
	    parent.up.form1.ev_year.value = document.forms[0].ev_year.value;
	   
	}

	function initAjax(){
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '<%=SG_KIND%>' );
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '<%=SG_KIND%>' );		
		<%if(!"".equals(SG_KIND)){ %>
			var sg_refitem="<%=SG_KIND%>";
				
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
			}
		<%}%>
		
		 
	} 

	
	function nextAjax(type){
		
		var f = document.forms[0];
		var house_code = "<%=house_code%>";
		
		
			if(type == '2'){
				
				var sg_refitem=f.sg_kind.value;
				
				f.sg_type1.value = sg_refitem;
				
				var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
				sg_type2_id.options.length = 0; //길이 0으로
//				sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
				$(sg_type2_id).trigger("onchange");
				var nodePath = document.getElementById("sg_type2");
				var ooption = document.createElement("option");
				
				if(sg_refitem.valueOf().length > 0) {
					// 공백인 option 하나 추가(전체 검색위해서)
					
					ooption.text = "--------";
					ooption.value = "";
					nodePath.add(ooption);
					
					doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
// 					doRequestUsingPOST( 'SL0121', house_code+'#2'+'#'+sg_refitem ,'sg_type2','' );
				}else {
					
					ooption.text = "--------";
					ooption.value = "";
					nodePath.add(ooption);
				
				}
				
			}else if(type == '3'){
				var sg_refitem=f.sg_type2.value;
				
				var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
				sg_type3_id.options.length = 0; //길이 0으로
//				sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
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
	

	function doAddRow()
    {
    	var f = document.forms[0];
    	
    	var sg_type1=f.sg_type1.value;
    	var sg_type2=f.sg_type2.value;
    	var sg_type3=f.sg_type3.value;
    	
    	if(sg_type1=="" || sg_type2=="" || sg_type3==""){
    		alert("대,중,소 분류를 입력하십시요.");
    		return;
    	}
		 <%=grid_obj%>.setCheckedRows(0, true);
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		    }
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	for(var i=0; i<grid_array.length; i++){
    		var sg_type1_p = GridObj.cells(grid_array[i], GridObj.getColIndexById("SG_TYPE1")).getValue(sg_type1);
			var sg_type2_p = GridObj.cells(grid_array[i], GridObj.getColIndexById("SG_TYPE2")).getValue(sg_type2);
			var sg_type3_p = GridObj.cells(grid_array[i], GridObj.getColIndexById("SG_TYPE3")).getValue(sg_type3);
			
			if(sg_type1_p == sg_type1 && sg_type2_p == sg_type2 && sg_type3_p == sg_type3){
				alert("이미 선택된 소싱그룹입니다.");
				return;
			}
    	
    	} 
    	
    	dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";
    	
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;

		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE1")).setValue(sg_type1);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE2")).setValue(sg_type2);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE3")).setValue(sg_type3);
		
		//}
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE1")).setDisabled(true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE2")).setDisabled(true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SG_TYPE3")).setDisabled(true);
		dhtmlx_before_row_id = nMaxRow2;
		
		document.form1.sg_type1.disabled=true;
		document.form1.sg_kind.disabled=true;
    }
    
    // 행삭제시 호출 되는 함수 입니다.
    function doDeleteRow()
    {
    	
    	var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);

    	for(var row = rowcount - 1; row >= 0; row--)
		{
			if("1" == GridObj.cells(grid_array[row], 0).getValue())
			{
				GridObj.deleteRow(grid_array[row]);
        	}
	    }
    }
    
    function rock_ck(){
    	for(var i=1; i<=dhtmlx_last_row_id; i++){
	    	GridObj.cells(i, GridObj.getColIndexById("SG_TYPE1")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("SG_TYPE2")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("SG_TYPE3")).setDisabled(true);
		}
    
    }
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="Init();initAjax();">
<s:header popup="true">
<form name="form1" action=""> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  	<tr>
 		<td height="5">
 		<input type="hidden" name="attach_no" id="attach_no" value="">
 		</td>
	</tr>
	<tr>
		<td width="100%" valign="top">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
		    		<td width="15%" class="div_input" align="left">심사표번호 </td>
		    		<td  width="75%" class="se_cell_data" colspan="3">
		    			<input type="text" name="ev_no" id="ev_no" value="<%=ev_no%>"class="input_empty" readonly>
		    			<input type="hidden" name="sheet_status" id="sheet_status" value="<%=SHEET_STATUS %>" readonly="readonly">
		    		</td>
	    		</tr>
				<tr>
					<td width="15%" class="div_input_re">
						평가종류
					</td>
					<td width="35%" class="se_cell_data">
						<select name="sheet_kind" id="sheet_kind" class="inputsubmit" <%=dis_view%>>
							<option value="">
								전체
							</option>
							 <%=LB_SHEET_KIND%> 
						</select>
					</td>
					<td width="15%" class="div_input_re">
						평가그룹
					</td>
					<td width="35%" class="se_cell_data">
						<select name="sg_kind" id="sg_kind" class="inputsubmit"  onchange="nextAjax('2');" <%=dis_view%>>
							<option value="">
								--------
							</option>
							
						</select>
					</td>
				</tr>
				<tr> 
					<td width="15%" class="div_input_re">
						평가시기
					</td>
					<td width="35%" class="se_cell_data">
						<select name="period" id="period" class="inputsubmit">
							<option value="">
								전체
							</option>
							<%=LB_PERIOD%>
						</select>
					</td>
					<td width="15%" class="div_input_re">
						적용여부
					</td>
					<td width="35%" class="se_cell_data">
					 <input type="checkbox" name="use_flag" id="use_flag"  value="Y" <%=USE_FLAG%>  />  
					</td>
				</tr>
				<tr> 
					<td width="15%" class="div_input_re">
						평가년도
					</td>
					<td width="35%" class="se_cell_data">
						<input type="text" name="ev_year" id="ev_year" readonly="readonly" size="8" maxlength="8" class="inputsubmit" value="<%=EV_YEAR%>">
						
					</td>
					<td width="15%" class="div_input_re">
						적격점수
					</td>
					<td width="35%" class="se_cell_data">
						<input type="text" name="accept_value" id="accept_value" size="8" maxlength="8" class="inputsubmit" value="<%=ACCEPT_VALUE %>"  style="ime-mode:disabled;" onKeyPress="checkNumberFormat('[0-9]', this)" onKeyUp="return chkMaxByte(18, this, '적격점수');">
					</td>
				</tr>
				<tr>
					<td width="15%" class="div_input_re">
			        	<div align="left">평가적용시작일</div>
			      	</td>
			      	<td width="35%" class="se_cell_data" > 
			      		<%-- <input type="text" name="st_date" size="8" maxlength="8" class="inputsubmit" value="<%=ST_DATE %>">
						<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, st_date , 'yyyymmdd')"> --%>
						<s:calendar id="st_date" default_value="<%=SepoaString.getDateSlashFormat(ST_DATE) %>" format="%Y/%m/%d"/>
			        </td>
			        <td width="15%" class="div_input_re">
			        	<div align="left">평가적용종료일</div>
			      	</td>
			      	<td width="35%" class="se_cell_data" > 
			      		<%-- <input type="text" name="end_date" size="8" maxlength="8" class="inputsubmit" value="<%=END_DATE %>">
						<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, end_date , 'yyyymmdd')"> --%>
						<s:calendar id="end_date" default_value="<%=SepoaString.getDateSlashFormat(END_DATE) %>" format="%Y/%m/%d"/>
			        </td>
				</tr> 
			    <tr>
			      	<td width="15%" class="div_input_re">
			        	<div align="left">심사표제목</div>
			      	</td>
			      	<td width="35%" class="se_cell_data" colspan="3"> 
			      		<input type="text" name="subject" id="subject" class="inputsubmit" value="<%=SUBJECT%>" size="45" maxlength="100" onKeyUp="return chkMaxByte(200, this, '심사표제목');">
			        </td> 
					
			    </tr> 
			</table>
			
			<table width="98%" border="0" cellspacing="0" cellpadding="0">
				<tr>
						<td height="30" class="se_cell_data">
						</td>
				</tr>
			</table>
			
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
						<td width="13%" class="div_input_re">
				        	<div align="left">소싱그룹 대분류</div>
					    </td>
					    <td width="20%" class="se_cell_data" > 
					    	<select name="sg_type1" id="sg_type1" class="inputsubmit" onchange="nextAjax('2');" disabled>
					    		<option value="">--------
					    		</option>
					    	</select>
					    </td>
						<td width="13%" class="div_input_re">
							소싱그룹 중분류
						</td>
						<td width="20%" class="se_cell_data">
							<select name="sg_type2" id="sg_type2" class="inputsubmit" onchange="nextAjax('3');">
					    		<option value="">--------
					    		</option>
					    	</select>
						</td>
						 <td width="13%" class="div_input_re">
				        <div align="left">소싱그룹 소분류</div>
					    </td>
					    <td width="20%" class="se_cell_data" colspan="3"> 
					    	<select name="sg_type3" id="sg_type3" class="inputsubmit">
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
			    	  			   <td><script language="javascript">btn("javascript:doInsert()","심사표일반사항저장")</script></td>
			    	  		<%--	  <td><script language="javascript">btn("javascript:doModify()","삭제")</script></td>
			    	  			  <td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
			    	  		   		<TD><script language="javascript">btn("javascript:doInsert()",7,"추 가")    </script></TD>
									<TD><script language="javascript">btn("javascript:doModify()",12,"수 정")   </script></TD> 
									<TD><script language="javascript">btn("javascript:doDelete()",3,"삭 제")   </script></TD>   
				    	  			<TD><script language="javascript">btn("javascript:window.close()",1,"닫 기")    </script></TD>
								--%>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
			
		</td>
	</tr>
</table>
</form>	
</s:header>
<s:grid screen_id="WO_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
