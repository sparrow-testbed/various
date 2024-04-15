<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;
	String init_flag = JSPUtil.paramCheck(request.getParameter("init_flag"));

	if(init_flag.equals("true"))
	{
		from_date = JSPUtil.paramCheck(request.getParameter("from_date"));
		to_date = JSPUtil.paramCheck(request.getParameter("to_date"));
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement("EM_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "EM_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
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

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();

		GridObj.setSizes();

//		GridObj.setColumnHidden(GridObj.getColIndexById("SELECTED"), true);
    }

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
		//alert("status="+status);

		if(status == "false") alert(msg);
		return true;
    }

    function sumColumn(ind) {
		var out = 0;
		for(var dhtmlx_start_row_id=0; i< dhtmlx_end_row_id;i++) {
			out += parseFloat(GridObj.cells2(i, ind).getValue())
		}
		return out;
	}


	function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	//alert(GridObj.getColumnId(cellInd));

    	var header_name = GridObj.getColumnId(cellInd);

		if(header_name == "SUBJECT")
		{
			var doc_no       = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue());
			var confirm_date = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONFIRM_DATE")).getValue());
			var text1 		 = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("TEXT1")).getValue());
			var subject		 = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("SUBJECT")).getValue());
			openReadMail(doc_no, confirm_date, text1, subject);
		}

		if( header_name == "ATTACH_CNT")
		{
			var ATTACH_NO_VALUE = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());
			var ATTACH_NO = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());
       		if(ATTACH_NO != "") FileAttach('MAIL',ATTACH_NO_VALUE,'VI');
		}
	}


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

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("EM_003.2006")%>");
		return false;
	}


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
			getData();
		} else {
			alert(messsage);
		}

		return false;
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


	function rowinsert()
	{
	}

	function doAddRow()
    {
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


function getData()
{
		var from_date = encodeUrl(LRTrim(document.form1.from_date.value));//
		var to_date = encodeUrl(LRTrim(document.form1.to_date.value));//
		var conf_yn = encodeUrl(LRTrim(document.form1.conf_yn.value));//
		var send_comp = encodeUrl(LRTrim(document.form1.send_comp.value));
		var send_user = encodeUrl(LRTrim(document.form1.send_user.value));
		var case_no = "100";//수신함조회
		var grid_col_id = "<%=grid_col_id%>";
		var language = "<%=info.getSession("LANGUAGE")%>";

		if(!checkDateCommon(from_date) || from_date == "") {
//			alert(" 작성일(From)를 확인 하세요 ");
			alert("<%=text.get("EM_003.2007")%>");
			document.form1.from_date.focus();
			return;
		}

		if(!checkDateCommon(to_date) || to_date == "") {
//			alert(" 작성일(To)를 확인 하세요 ");
			alert("<%=text.get("EM_003.2008")%>");
			document.form1.to_date.focus();
			return;
		}

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1","from_date="+from_date+"&to_date="+to_date+"&conf_yn="+conf_yn+"&send_comp="+send_comp+"&send_user="+send_user+"&case_no="+case_no+"&grid_col_id="+grid_col_id+"&language="+language);
		GridObj.clearAll(false);

}


function popup(doc_no)
{
		var url = "pop_mail.jsp?doc_no="+doc_no;
		var width = 600;
		var height = 330;
		var left = 0;
		var top = 0;

		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';
		//var help = window.open( url, 'help', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}


function companyDelete()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(!checkRows())	return;
	if (confirm("<%=text.get("EM_003.CONFIRM_DELETE")%>")){
	    var cols_ids = "<%=grid_col_id%>";
	    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1?cols_ids="+cols_ids+"&case_no=100");//발신함삭제
 		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}

function from_date(year,month,day,week)
{
    document.form1.from_date.value=year+month+day;
}

function to_date(year,month,day,week)
{
    document.form1.to_date.value=year+month+day;
}

	function initAjax(){
	}
</script>

</head>

<body leftmargin="15" topmargin="6"  onload="initAjax();setGridDraw();getData();">
<s:header>
<form name="form1" method="post" action="">
		<input type="hidden" name="opcode">
		<input type="hidden" name="subject">
		<input type="hidden" name="contents">
		<input type="hidden" name="user_name_loc">
		<input type="hidden" name="user_type">
		<input type="hidden" name="dept_name_loc">
		<input type="hidden" name="dept">
		<input type="hidden" name="user_id">
		<input type="hidden" name="to_company_code">
		<input type="hidden" name="to_company_name">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td height="24" class="se_cell_title"><%=text.get("EM_003.2001")%></td><%--작성일--%>
				<td height="24" class="se_cell_data">
					<s:calendar id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"  
	        						default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" id_to="to_date" 
	        						format="%Y/%m/%d"/>

					<input type="hidden" name="send_comp" value="" length="0">
				</td>
				<td height="24" class="se_cell_title"><%=text.get("EM_003.2004")%></td><%--작성자 --%>
				<td height="24" class="se_cell_data">
					<input type="text" name="send_user" value="" length="15">
				</td>

				<td height="24" class="se_cell_title"><%=text.get("EM_003.2002")%></td><%----확인여부----%>
				<td height="24" class="se_cell_data">
						<select name="conf_yn" class="inputsubmit">
							<option value =""><%=text.get("EM_003.2005")%></option>
							<%
							String lb = ListBox(request, "SL0007",  "M721", (init_flag.equals("true") ? "N" : ""));
							out.println(lb);
							%>
						</select>
				</td>
			</tr>

			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>

										<td><script language="javascript">btn("javascript:getData()","<%=text.get("BUTTON.search")%>")</script></td>
										<td><script language="javascript">btn("javascript:companyDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
								</TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
<%--               
             <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>

</form>

<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=220"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
