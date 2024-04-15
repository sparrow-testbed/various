<%
/**
 * @파일명   : service_admin_mgt.jsp
 * @생성일자 : 2009. 03. 23
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : 서비스관리
 */
%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String add_date = SepoaString.getDateSlashFormat(to_date);
	String user_id = info.getSession("ID");

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_036");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_036";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	isRowsMergeable = false;// 화면에 행머지기능을 사용할지 여부의 구분(true = 사용, false = 미사용)
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
var nfCaseQty = "0,000.000";
var myDataProcessor = null;

var message1005 = '<%=text.get("AD_036.1005")%>';//이미 등록 되었습니다.\n 수정이나 삭제를 하세요..
var message1004 = '<%=text.get("AD_036.1006")%>';//선택된 데이터가 없습니다..
var message1006 = '<%=text.get("AD_036.1007")%>';//하나이상 선택할 수 없습니다.
var message1007 = '<%=text.get("AD_036.1008")%>';//등록을 먼저 하셔야 합니다.

var strUserId 	= '<%= user_id %>';
var strToday	= '<%= to_day %>';

	function setGridDraw()
    {

    	<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();

    }

	<%
	/**
	 * @메소드명 : doQuery
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 서비스관리 > 조회
	 */
	%>
	function doQuery()
	{

		var process		= LRTrim(document.form.process.value);
		var prc_value	= encodeUrl(LRTrim(document.form.prc_value.value));
		var house_code = encodeUrl(LRTrim(document.form.house_code.value));

	    if (process != null && process.length > 0) {
	    	if(prc_value == null || prc_value.length < 1 || prc_value == '') {
	    		alert("<%=text.get("AD_036.0104")%>"); // 이미 등록된 메뉴입니다.\n 수정이나 삭제를 하세요.
	    		return;
	    	}
	    }

		var grid_col_id = "<%=grid_col_id%>";

		var param = "process="+process+"&prc_value="+prc_value+"&house_code="+house_code+"&mode=query&grid_col_id="+grid_col_id;
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.service_admin_mgt";

		GridObj.post(G_SERVLETURL,param);
		GridObj.clearAll(false);
	}


	<%
	/**
	 * @메소드명 : doQueryEnd
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doQuery() 로 결과조회 후 처리가 필요한 경우 사용하는 함수
	 */
	%>
    function doQueryEnd(GridObj, RowCnt)
    {
    	//24번 Grid 소계, 중계, 합계 기능
    	//var sum_add_amt = document.getElementById("add_amt");
		//sum_add_amt.innerHTML = sumColumn(GridObj.getColIndexById("add_amt"));
		var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");
		//alert("msg]"+msg);

		//if(status == "false") alert(msg);
		//else alert(msg);
		return true;
    }



 	<%
	/**
	 * @메소드명 : doInsert
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 서비스관리 > 저장
	 */
	%>
    function doInsert()
	{
		if(!checkRows()) return;

		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var i = 0; i < grid_array.length; i++)
		{
			<%-- 필수값 체크--%>
			if(GridObj.cells(grid_array[i], GridObj.getColIndexById("selected")).getValue() == 1)
			{

				<%-- HOUSE_CODE는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("house_code")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0100")%>');
					return;
				}
				<%-- PROCESS ID는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("process_id")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0101")%>');
					return;
				}
				<%-- METHOD는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("method")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0102")%>');
					return;
				}
				<%-- URL은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("url")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0104")%>');
					return;
				}
				<%-- Service Class 은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("service_class")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0105")%>');
					return;
				}
				<%-- 설명은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("description")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0103")%>');
					return;
				}

			}

		}

	    if (confirm("<%=text.get("MESSAGE.1018")%>")){
            var cols_ids = "<%=grid_col_id%>";

            G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.service_admin_mgt";//서블릿 경로
            param = "?cols_ids="+cols_ids+"&mode=insert";//파라미터

		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			sendTransactionGrid(GridObj, myDataProcessor, "selected",grid_array);
        }
	}


 	<%
	/**
	 * @메소드명 : doUpdate
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 서비스관리 > 수정
	 */
	%>
    function doUpdate()
	{
		if(!checkRows()) return;

		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var i = 0; i < grid_array.length; i++)
		{
			<%-- 필수값 체크--%>
			if(GridObj.cells(grid_array[i], GridObj.getColIndexById("selected")).getValue() == 1)
			{

				<%-- PROCESS ID는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("process_id")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0101")%>');
					return;
				}
				<%-- METHOD는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("method")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0102")%>');
					return;
				}
				<%-- URL은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("url")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0104")%>');
					return;
				}
				<%-- Service Class 은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("service_class")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0105")%>');
					return;
				}
				<%-- 설명은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("description")).getValue()) == "")
				{
					alert('<%=text.get("AD_036.0103")%>');
					return;
				}

			}

		}

	    if (confirm("<%=text.get("MESSAGE.1016")%>")){
            var cols_ids = "<%=grid_col_id%>";

            G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.service_admin_mgt";//서블릿 경로
            param = "?cols_ids="+cols_ids+"&mode=update";//파라미터
		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
	}


	<%
	/**
	 * @메소드명 : doDelete
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 화면관리 > 삭제
	 */
	%>
	function doDelete()
	{
		if(!checkRows()) return;

		var grid_array = getGridChangedRows(GridObj, "selected");

	   if (confirm("<%=text.get("MESSAGE.1015")%>")){
            var cols_ids = "<%=grid_col_id%>";

            G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.service_admin_mgt";//서블릿 경로
            param = "?cols_ids="+cols_ids+"&mode=delete";//파라미터

			myDataProcessor = new dataProcessor(G_SERVLETURL + param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected",grid_array);
	   }
	}

	<%
	/**
	 * @메소드명 : doSaveEnd
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doInsert() 로 저장 후 처리가 필요한 경우 사용하는 함수
	 */
	%>
	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;

		//alert("status==="+status);

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true")
		{
			doQuery();
		}
		else alert(messsage);

		return false;
	}

 	<%
	/**
	 * @메소드명 : checkRows
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 저장시 선택필드에 체크된 로우 확인
	 */
	%>
	function checkRows()
	{

		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("AD_036.1006")%>");
		return false;
	}



 	<%
	/**
	 * @메소드명 : doAddRow
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 행삽입
	 */
	%>
	function doAddRow()
    {
    	dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";

    	GridObj.enableSmartRendering(true);
    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).cell.wasChanged = true;

		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).setValue("1");
   		GridObj.cells(nMaxRow2, GridObj.getColIndexById("use_flag")).setValue("1");
  		GridObj.cells(nMaxRow2, GridObj.getColIndexById("autho_apply_flag")).setValue("1");
  		//GridObj.cells(nMaxRow2, GridObj.getColIndexById("start_date")).setValue("<%=add_date%>");
  		//GridObj.cells(nMaxRow2, GridObj.getColIndexById("end_date")).setValue("<%=add_date%>");
  	 	GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_date")).setValue("<%=to_date%>");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_user_name")).setValue("<%=user_id%>");

    }

 	<%
	/**
	 * @메소드명 : doOnRowSelected
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 그리드 셀 클릭 이벤트
	 */
	%>
	function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    }

	<%
	/**
	 * @메소드명 : doOnCellChange
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 그리드 셀 클릭변경  이벤트
	 */
	%>

    function doOnCellChange(stage,rowId,cellInd)
    {
    	//alert("doOnCellChange===" + stage + "  " +rowId +" " + cellInd);

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

	<%
	/**
	 * @메소드명 : initAjax
	 * @생성일자 : 2009. 03. 18
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 조회조건 콤보박스 생성
	 */
	%>
	function initAjax(){
		//doRequestUsingPOST( 'SL5001', 'M998' ,'module_type' );

	}

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


	//23번 행이동
    function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }
    //23번 행이동
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }



    function sumColumn(ind) {
		var out = 0;
		for(var dhtmlx_start_row_id=0; i< dhtmlx_end_row_id;i++) {
			out += parseFloat(GridObj.cells2(i, ind).getValue())
		}
		return out;
	}

    function doDeleteRow()
    {
    	//GridObj.enableSmartRendering(false);
    	var rowcount = dhtmlx_end_row_id;

    	for(var row = rowcount - 1; row >= dhtmlx_start_row_id; row--)
		{
			if("1" == GridObj.cells(GridObj.getRowId(row), 0).getValue())
			{
				GridObj.deleteRow(GridObj.getRowId(row));
        	}
	    }
    }

    function doExcelDown()
    {
    	GridObj.setCSVDelimiter("\t");
    	var csvNew = GridObj.serializeToCSV();
		GridObj.loadCSVString(csvNew);
    }

    function filterBy() {
		var tVal = document.getElementById("title_flt").childNodes[0].value.toLowerCase();

		for(var i=dhtmlx_start_row_id; i < dhtmlx_end_row_id; i++){
			var tStr = GridObj.cells2(i,4).getValue().toString().toLowerCase();
			if(tVal=="" || tStr.indexOf(tVal)==0)
				GridObj.setRowHidden(GridObj.getRowId(i),false)
			else
				GridObj.setRowHidden(GridObj.getRowId(i),true)
		}
	}

	function myErrorHandler(obj) {
		alert("Error occured.\n"+obj.firstChild.nodeValue);
		myDataProcessor.stopOnError = true;
		return false;
	}

	function doSerial()
	{
		GridObj.setSerializationLevel(true,true);
		var myXmlStr = GridObj.serialize();
	}



	function doExcelUpload() {
		var bufferData = window.clipboardData.getData("Text");
		if(bufferData.length > 0) {
			GridObj.clearAll();
			GridObj.setCSVDelimiter("\t");
    		GridObj.loadCSVString(bufferData);
		}
		return;
	}

    function getAddRowValues(col_id, set_value, row_data)
    {
    	row_data = row_data.replace(col_id, set_value);
		return row_data;
    }

	function doFilterBy()
	{
		var screen_id = document.form.screen_id.value;
		alert(GridObj.getColIndexById("screen_id"));
		GridObj.filterBy(GridObj.getColIndexById("screen_id"), screen_id);
		alert("Daum");
	}
	function initAjax(){
		doRequestUsingPOST( 'SL5001', 'HSCD' ,'house_code', '' );
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
<form name="form">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5"> </td>
		</tr>
		<tr>
			<td width="100%" align="left" valign="top">
			<%/* 조회조건 START */ %>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
					<tr>
						<td width="15%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
							<select name='process'>
											<option value=''><%=text.get("AD_036.TXT_01")%></option>
											<option value='PID'><%=text.get("AD_036.TXT_02")%></option>
											<option value='MTD'><%=text.get("AD_036.TXT_03")%></option>
											<option value='DSC'><%=text.get("AD_036.TXT_04")%></option>
											<option value='POW'><%=text.get("AD_036.TXT_05")%></option>
											<option value='USR'><%=text.get("AD_036.TXT_06")%></option>
							</select>
						</td>
						<td width="35%" height="24" class="data_td">
							<input type="text" name="prc_value" value="" length="13">
						</td>
                        <td width="20%" height="24"  class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_036.house_code")%></td>
                        <td width="30%" height="24" class="data_td">
                            <select name="house_code" id="house_code" class="inputsubmit">
                                <option value=""><%=text.get("AD_036.TXT_01")%></option>
                            </select>
                        </td>
					</tr>
				</table>
				</td>
                		</tr>
            		</table>
				<%/* 조회조건 END */ %>

				<%/* 버튼 START */ %>
				<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
					<TR>
						<td style="padding:5 5 5 0">
							<TABLE cellpadding="2" cellspacing="0">
								<TR>
									<td><script language="javascript">btn("javascript:doQuery()",		"<%=text.get("BUTTON.search")%>")	</script></td>
									<td><script language="javascript">btn("javascript:doInsert()",		"<%=text.get("BUTTON.insert")%>")		</script></td>
									<td><script language="javascript">btn("javascript:doUpdate()",		"<%=text.get("BUTTON.update")%>")	</script></td>
									<td><script language="javascript">btn("javascript:doDelete()",		"<%=text.get("BUTTON.deleted")%>")	</script></td>
									<td><script language="javascript">btn("javascript:doAddRow()",		"<%=text.get("BUTTON.rowinsert")%>")</script></td>

					<!--
										<td><script language="javascript">btn("javascript:doSelect()",	"<%=text.get("BUTTON.search")%>")</script></td>
										<td><script language="javascript">btn("javascript:doInsert()",	"<%=text.get("BUTTON.insert")%>")</script></td>
										<td><script language="javascript">btn("javascript:doUpdate()",	"<%=text.get("BUTTON.update")%>")</script></td>
										<td><script language="javascript">btn("javascript:doDelete()",	"<%=text.get("BUTTON.deleted")%>")</script></td>
										<td><script language="javascript">btn("javascript:insertLine()",	"<%=text.get("BUTTON.rowinsert")%>")</script></td>
										<td><script language="javascript">btn("javascript:excelDown()",	"<%=text.get("BUTTON.excel")%>")</script></td>

					 -->

								</TR>
							</TABLE>
				  		</td>
					</TR>
				</TABLE>
				<%/* 버튼 END */ %>
<%-- 				
				<%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		</tr>
	</table>
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=180"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>