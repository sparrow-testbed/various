<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_020");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_020";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<%
	String szRow = JSPUtil.nullToEmpty(request.getParameter("i_row"));

	String data = "szRow=" + szRow;
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="SR_020"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

function doSelect(USER_ID, USER_NAME) 
{

	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.evaluator_list";
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=getEvaluatorList&grid_col_id="+grid_col_id;
	param += dataOutput();
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
	
}

function leftArrow() 
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	GridObj.enableSmartRendering(false);
	for(var i = 0; i < grid_array.length; i++) {
		var code = GridObj.cells(grid_array[i], GridObj.getColIndexById("CODE")).getValue();
		var name = GridObj.cells(grid_array[i], GridObj.getColIndexById("NAME")).getValue();
		var code1 = GridObj.cells(grid_array[i], GridObj.getColIndexById("CODE1")).getValue();
		var name1 = GridObj.cells(grid_array[i], GridObj.getColIndexById("NAME1")).getValue();
		GridObj.deleteRow2(grid_array[i]);
		var flag = "true";
		for(var j=1; j <= GridObj_1_dhtmlx_last_row_id; j++) 
 		{
 			try{
	 			if(code1 == GridObj_1.cells(j, GridObj_1.getColIndexById("CODE1")).getValue())
	 			{
	 				flag = "false";
	 				break;
	 			}
 			}catch(e){
 				// 그리드 없는 부분 무시
 			}
 		}
		if(flag == "true"){
			
		GridObj_1_dhtmlx_last_row_id++;
		var nMaxRow2 = GridObj_1_dhtmlx_last_row_id;
		GridObj_1.enableSmartRendering(true);
		GridObj_1.addRow(nMaxRow2, "", GridObj_1.getRowIndex(nMaxRow2));
		GridObj_1.selectRowById(nMaxRow2, false, true);
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("SELECTED")).setValue("1");
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("CODE")).setValue(code);  
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("NAME")).setValue(name);
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("CODE1")).setValue(code1);  
		GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("NAME1")).setValue(name1);

		}
// 		dhtmlx_before_row_id = nMaxRow2;
	}
	/*
	var left_grid_array = getGridChangedRows(GridObj, "SELECTED");
	//leftrowcount = GridObj.GetRowCount();
	for(var row = left_grid_array.length; row > 0; row--) 
	{
		if( "1" == GridObj.cells(left_grid_array[row-1], GridObj.getColIndexById("SELECTED")).getValue()) 
		{
			CODE = GridObj.cells(left_grid_array[row-1], GridObj.getColIndexById("CODE")).getValue();
			NAME = GridObj.cells(left_grid_array[row-1], GridObj.getColIndexById("NAME")).getValue();
			CODE1 = GridObj.cells(left_grid_array[row-1], GridObj.getColIndexById("CODE1")).getValue();
			NAME1 = GridObj.cells(left_grid_array[row-1], GridObj.getColIndexById("NAME1")).getValue();

			var flag = "true";

// 			for(i=0; i<GridObj_1.GetRowCount(); i++) 
// 			{
// 				if(CODE1 == GridObj_1.cells(i+1, GridObj_1.getColIndexById("CODE1")).getValue())
// 				{
// 					flag = "false";
// 					break;
// 				}
// 			}

			if("true" == flag) {
				AddRow_1();
				rightrowcount = getGridChangedRows(GridObj_1, "SELECTED");
				var row2 = rightrowcount.length;
				GridObj_1.cells(rightrowcount[row2-1], GridObj_1.getColIndexById("CODE")).setValue(CODE);  
				GridObj_1.cells(rightrowcount[row2-1], GridObj_1.getColIndexById("NAME")).setValue(NAME);  
				GridObj_1.cells(rightrowcount[row2-1], GridObj_1.getColIndexById("CODE1")).setValue(CODE1);
				GridObj_1.cells(rightrowcount[row2-1], GridObj_1.getColIndexById("NAME1")).setValue(NAME1);
			}

			GridObj.deleteRow2(left_grid_array[row-1]);
			}
	}
	*/
} 

function rightArrow() 
{
	
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
	GridObj_1.enableSmartRendering(false);
	for(var i = 0; i < grid_array.length; i++) {
		var code = GridObj_1.cells(grid_array[i], GridObj_1.getColIndexById("CODE")).getValue();
		var name = GridObj_1.cells(grid_array[i], GridObj_1.getColIndexById("NAME")).getValue();
		var code1 = GridObj_1.cells(grid_array[i], GridObj_1.getColIndexById("CODE1")).getValue();
		var name1 = GridObj_1.cells(grid_array[i], GridObj_1.getColIndexById("NAME1")).getValue();

		GridObj_1.deleteRow2(grid_array[i]);
		var flag = "true";
		for(var j=1; j <= dhtmlx_last_row_id; j++) 
 		{
 			try{
	 			if(code1 == GridObj.cells(j, GridObj.getColIndexById("CODE1")).getValue())
	 			{
	 				flag = "false";
	 				break;
	 			}
 			}catch(e){
 				// 그리드 없는 부분 무시
 			}
 		}
		if(flag == "true"){
		
		dhtmlx_last_row_id++;
		var nMaxRow2 = dhtmlx_last_row_id;
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("CODE")).setValue(code);  
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("NAME")).setValue(name);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("CODE1")).setValue(code1);  
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("NAME1")).setValue(name1);
// 		dhtmlx_before_row_id = nMaxRow2;
		}
	}
	
	/*
	var right_grid_array = getGridChangedRows(GridObj_1, "SELECTED");

	for(var row = right_grid_array.length; row > 0; row--) 
	{
		if( "1" == GridObj_1.cells(right_grid_array[row-1], GridObj_1.getColIndexById("SELECTED")).getValue() 
		{
			CODE = GridObj_1.cells(right_grid_array[row-1], GridObj_1.getColIndexById("CODE")).getValue();
			NAME = GridObj_1.cells(right_grid_array[row-1], GridObj_1.getColIndexById("NAME")).getValue();
			CODE1 = GridObj_1.cells(right_grid_array[row-1], GridOb_1.getColIndexById("CODE1")).getValue();
			NAME1 = GridObj_1.cells(right_grid_array[row-1], GridObj_1.getColIndexById("NAME1")).getValue();

			var flag = "true";
// 			for(i=0; i<GridObj.GetRowCount(); i++) 
// 			{
// 				if(CODE1 == GridObj.cells(i+1, GridObj.getColIndexById("CODE1")).getValue())
// 				{
// 					flag = "false";
// 					break;
// 				}
// 			}

			if("true" == flag) {
				AddRow();
				leftrowcount = getGridChangedRows(GridObj, "SELECTED");
				var row2 = leftrowcount.length;
				GridObj.cells(leftrowcount[row2-1], GridObj.getColIndexById("CODE")).setValue(CODE);  
				GridObj.cells(leftrowcount[row2-1], GridObj.getColIndexById("NAME")).setValue(NAME);  
				GridObj.cells(leftrowcount[row2-1], GridObj.getColIndexById("CODE1")).setValue(CODE1);
				GridObj.cells(leftrowcount[row2-1], GridObj.getColIndexById("NAME1")).setValue(NAME1);
			}

			GridObj_1.deleteRow2(right_grid_array[row-1]);
		}
	}

	//parent.leftFrame.;
	*/
} 

function AddRow_1() {
	GridObj_1_dhtmlx_last_row_id++;
	var nMaxRow2 = GridObj_1_dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	  	
	GridObj_1.enableSmartRendering(true);
	GridObj_1.addRow(nMaxRow2, "", GridObj_1.getRowIndex(nMaxRow2));
	GridObj_1.selectRowById(nMaxRow2, false, true);
	GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj_1.cells(nMaxRow2, GridObj_1.getColIndexById("SELECTED")).setValue("1");
	
	GridObj_1_dhtmlx_before_row_id = nMaxRow2;
}

function AddRow() {
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	  	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	
	dhtmlx_before_row_id = nMaxRow2;
}

// function DeleteRow(row) {
//    	var grid_array = getGridChangedRows(GridObj, "SELECTED");
//    	var rowcount = grid_array.length;
//    	GridObj.enableSmartRendering(false);

//    	for(var row = rowcount - 1; row >= 0; row--) {
// 		if("1" == GridObj.cells(grid_array[row], 0).getValue()) {
// 			GridObj.deleteRow2(row);
//        	}
//     }
// }

// function DeleteRow_1() {
//    	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");
//    	var rowcount = grid_array.length;
//    	GridObj_1.enableSmartRendering(false);

//    	for(var row = rowcount - 1; row >= 0; row--) {
// 		if("1" == GridObj_1.cells(grid_array[row], 0).getValue()) {
// 			GridObj_1.deleteRow2(grid_array[row]);
//        	}
//     }
// }

function doSave() 
{
	linecount = 0;
	SELECTED = "";
	rightrowcount = GridObj_1.GetRowCount();

	for(row = rightrowcount; row > 0; row--) 
	{
		linecount++;

		CODE = GridObj_1.cells(row, GridObj_1.getColIndexById("CODE")).getValue();
		NAME = GridObj_1.cells(row, GridObj_1.getColIndexById("NAME")).getValue();
		CODE1 = GridObj_1.cells(row, GridObj_1.getColIndexById("CODE1")).getValue();
		NAME1 = GridObj_1.cells(row, GridObj_1.getColIndexById("NAME1")).getValue();

		SELECTED += CODE + " @";
		SELECTED += NAME + " @";
		SELECTED += NAME1 + " @";
		SELECTED += CODE1 + " @";
		SELECTED += "#";
	}

	parent.opener.valuerInsert("<%=szRow%>", SELECTED, linecount);
	window.close();
}




var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}


function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

///////////////////////////////////////////////////////////////////////////////////
 
var GridObj_1 = null;
var GridObj_1_grid_col_id  = "";
var num = "";

function setGridDraw_1()
{
	GridObj_1_setGridDraw();
	GridObj_1.setSizes();
}
    
function GridObj_1_doOnRowSelected(rowId,cellInd) {
	//alert(GridObj_1.cells(rowId, cellInd).getValue());
	<%--    
		
	    
	    if("undefined" != typeof JavaCall) {
	    	type = "";
	    	if(GridObj_1.getColType(cellInd) == 'img') {
	    		type = "t_imagetext";
	    	}
	    	JavaCall(type, "", cellInd);
	    }
	--%> 
}

function GridObj_1_doOnCellChange(stage,rowId,cellInd) {
   	
	 var max_value = GridObj_1.cells(rowId, cellInd).getValue();
	    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	    if(stage==0) {
	        return true;
	    } else if(stage==1) {
	    } else if(stage==2) {
	        return true;
	    }
	    
	    return false;
}

function checkRows_1() {
	var grid_array = getGridChangedRows(GridObj_1, "SELECTED");

	if(grid_array.length > 0) {
		return true;
	}
	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}

function doSaveEnd_1(obj)
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
 if("undefined" != typeof JavaCall) {
 	JavaCall("doData");
 } 

 return false;
}

function GridObj_1_doQueryEnd(GridObj_1, RowCnt) {
    var msg        = GridObj_1.getUserData("", "message");
    var status     = GridObj_1.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
 
function init() {
	
	setGridDraw();
	setGridDraw_1();
	
	var	value = opener.getCompany("<%=szRow%>");

	if(value != null) 
	{
		if(LRTrim(value) != "") 
		{
			var m_values = value.split("#");

			for(i=0; i<m_values.length; i++) 
			{
				if(m_values[i] != "") 
				{
					var m_data = m_values[i].split("@");

					CODE = m_data[0];
					NAME = m_data[1];
					NAME1 = m_data[2];
					CODE1 = m_data[3];
					
					
					var newId = (new Date()).valueOf();
					GridObj_1.addRow(newId,"");

					rightrowcount = GridObj_1.GetRowCount() - 1;
					
					GridObj_1.cells(GridObj_1.getRowId(rightrowcount), GridObj_1.getColIndexById("CODE")).setValue(CODE);
					GridObj_1.cells(GridObj_1.getRowId(rightrowcount), GridObj_1.getColIndexById("NAME")).setValue(NAME);
					GridObj_1.cells(GridObj_1.getRowId(rightrowcount), GridObj_1.getColIndexById("CODE1")).setValue(CODE1);
					GridObj_1.cells(GridObj_1.getRowId(rightrowcount), GridObj_1.getColIndexById("NAME1")).setValue(NAME1);

// 					GD_SetCellValueIndex(GridObj_1,rightrowcount, INDEX_CODE, CODE);
// 					GD_SetCellValueIndex(GridObj_1,rightrowcount, INDEX_NAME, NAME);
// 					GD_SetCellValueIndex(GridObj_1,rightrowcount, INDEX_NAME1, NAME1);
// 					GD_SetCellValueIndex(GridObj_1,rightrowcount, INDEX_CODE1, CODE1);
				}
			}

			;
		}
	}	
	
	
	
}
</script>
</head>
<body onload="javascript:init();" topmargin="0" marginwidth="0" leftmargin="0">
<s:header>
<form name="form1" method="post">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;평가자 선정
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr style="display:none;">
	<td width="20%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 부서코드</td>
	<td width="30%" class="c_data_1">
		<input type="text" name="vendor_code" id="vendor_code" maxlength="10" size="10" class="inputsubmit">
		<a href="javascript:Vendor_Search()"><img src="image" border="0" align="absmiddle"></a>
	</td>
	<td width="20%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 부서명</td>
	<td width="30%" class="c_data_1" >
		<input type="text" name="MAKER_NAME" id="MAKER_NAME" size="20" class="inputsubmit">
	</td>
</tr>
<tr>
	<td width="20%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가자아이디</td>
	<td width="30%" class="c_data_1">
		<input type="text" name="user_id" id="user_id" maxlength="10" size="20" class="inputsubmit">
	</td>
	<td width="20%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가자명</td>
	<td width="30%" class="c_data_1" >
		<input type="text" name="user_name" id="user_name" size="20" class="inputsubmit">
	</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" width="50%" valign="bottom">
	</td>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td colspan="2"><b>[평가자]</b></td>
	<td></td>
	<td colspan="2"><b>[지정평가자]</b></td>
</tr>
<tr>
<td colspan="2" width="45%">
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
</td>
<td width="10%" align="center">
	<a href="javascript:leftArrow();"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/butt_arrow1_.gif" border=0></a>&nbsp;&nbsp;&nbsp;<br>
		<br>
	<a href="javascript:rightArrow();"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/butt_arrow2_.gif" border=0></a>&nbsp;&nbsp;&nbsp;
</td>

<td colspan="2" width="45%">
<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
</td>
</tr>
</table>
</form>

	<table cellpadding="2" cellspacing="0" align="right">
		<td><script language="javascript">btn("javascript:doSave()","저 장")</script></td>
			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
	</table>
	</s:header>
<s:footer/>
</body>
</html>



