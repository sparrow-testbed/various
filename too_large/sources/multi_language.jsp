<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_018");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_018";
	String grid_obj  = "GridObj";
	// 조회 전용 화면인지 데이터 저장화면인지의 구분
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
<title><%=text.get("MESSAGE.MSG_9999")%></title>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script>



<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

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
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 post 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		var screen_id = encodeUrl(LRTrim(document.form.screen_id.value));
		var language = encodeUrl(LRTrim(document.form.language.value));
		var type = encodeUrl(LRTrim(document.form.type.value));
		var contents = encodeUrl(LRTrim(document.form.contents.value));
		var house_code = encodeUrl(LRTrim(document.form.house_code.value));
		var grid_col_id = "<%=grid_col_id%>";

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.multi_language","screen_id="+screen_id+"&language="+language+"&type="+type+"&contents="+contents+"&house_code=" + house_code + "&mode=query&grid_col_id="+grid_col_id);
		GridObj.clearAll(false);
	}

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("AD_018.0006")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'selected') return;
		GridObj.SetCellValue("selected", nRow, "1");
	}

	function initAjax(){
		doRequestUsingPOST( 'SL5001', 'M200' ,'type', '' );
		doRequestUsingPOST( 'SL5003', 'M013' ,'language', '' );
		doRequestUsingPOST( 'SL5001', 'HSCD' ,'house_code', '' );
	}

	function doInsert()
	{
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var i = 0; i < grid_array.length; i++)
		{
			<%-- 화면ID는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("screen_id")).getValue()) == "")
			{
				alert("<%=text.get("AD_018.0001")%>");
				return;
			}
			<%-- 언어는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("language")).getValue()) == "")
			{
				alert("<%=text.get("AD_018.0002")%>");
				return;
			}

			<%-- 코드는 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("code")).getValue()) == "")
			{
				alert("<%=text.get("AD_018.0003")%>");
				return;
			}
			<%-- Type은 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("type")).getValue()) == "")
			{
				alert("<%=text.get("AD_018.0004")%>");
				return;
			}
			<%-- 내용은 필수 입력으로 처리한다.--%>
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("contents")).getValue()) == "")
			{
				alert("<%=text.get("AD_018.0005")%>");
				return;
			}
		}

	    if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.multi_language?cols_ids="+cols_ids+"&mode=insert");
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
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

	// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
	// 복사한 데이터가 그리드에 Load 됩니다.
	function doExcelUpload() {
		var bufferData = window.clipboardData.getData("Text");
		if(bufferData.length > 0) {
			GridObj.clearAll();
			GridObj.setCSVDelimiter("\t");
    		GridObj.loadCSVString(bufferData);
		}
		return;
	}

	function doDelete()
	{
		if(!checkRows())
				return;
		var grid_array = getGridChangedRows(GridObj, "selected");

	   	if (confirm("<%=text.get("MESSAGE.1015")%>")){
	   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
			var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.multi_language?cols_ids="+cols_ids+"&mode=delete");
			sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
	   }
	}

	// 행추가 이벤트 입니다.
	function doAddRow()
    {
    	dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";
    	
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).cell.wasChanged = true;
    	
		/*
    	if(GridObj.getRowsNum() > 1)
		{
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).setValue("1");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("screen_id")).setValue(GridObj.cells(dhtmlx_before_row_id, GridObj.getColIndexById("screen_id")).getValue());
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_user_id")).setValue("<%=info.getSession("ID")%>");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_date")).setValue("<%=to_date%>");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("house_code")).setValue(GridObj.cells(dhtmlx_before_row_id, GridObj.getColIndexById("house_code")).getValue());
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("language")).setValue(GridObj.cells(dhtmlx_before_row_id, GridObj.getColIndexById("language")).getValue());
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("type")).setValue(GridObj.cells(dhtmlx_before_row_id, GridObj.getColIndexById("type")).getValue());
		}
		else
		{
		*/
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).setValue("1");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("screen_id")).setValue("");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_user_id")).setValue("<%=info.getSession("ID")%>");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_date")).setValue("<%=to_date%>");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("house_code")).setValue("000");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("language")).setValue("KO");
	    	GridObj.cells(nMaxRow2, GridObj.getColIndexById("type")).setValue("A");
		//}
		
		dhtmlx_before_row_id = nMaxRow2;
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
        	}
	    }
    }
	function onRowDblClicked(){
		alert("dbclicked");
	}
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>
<form name="form">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
        		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_018.screen_id")%></td>
        		<td width="30%" height="24" class="data_td"><input type="text" name="screen_id" value="" length="15"></td>
        		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_018.language")%></td>
        		<td width="30%" height="24" class="data_td">
					<select name="language" id="language" class="inputsubmit">
						<option value=""><%=text.get("AD_018.all")%></option>
					</select>
				</td>
			  </tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			  
		      <tr>
		        <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
					<select name="type" id="type" class="inputsubmit">
						<option value=""><%=text.get("AD_018.all")%></option>
				    </select>
				</td>
				<td width="30%" height="24" class="data_td">
					<input type="text" name="contents" value="" length="15">
				</td>
        		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_018.house_code")%></td>
        		<td width="30%" height="24" class="data_td">
					<select name="house_code" id="house_code" class="inputsubmit">
						<option value=""><%=text.get("AD_018.all")%></option>
					</select>
				</td>
			  </tr>
			  </table>
			  
<%--               
             <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>
</td>
</tr>
</table>
</td>
</tr>
</table>

<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
						  <td><script language="javascript">btn("javascript:doInsert()","<%=text.get("BUTTON.save")%>")</script></td>
						  <td><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
						  <td><script language="javascript">btn("javascript:doAddRow()","<%=text.get("BUTTON.rowinsert")%>")</script></td>
						  <td><script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>		
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=260"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>