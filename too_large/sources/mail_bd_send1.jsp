<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@
	page import="
	sepoa.fw.srv.*,
	sepoa.fw.util.*,
	sepoa.fw.msg.*"
%>

<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(to_day,-1);
	String to_date = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("EM_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "EM_005";
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



<%
	String change_user_id    = info.getSession("ID");
	String change_user_name1 = info.getSession("ID");
	String change_user_name2 = info.getSession("NAME_ENG");
	String change_user_dept  = info.getSession("DEPARTMENT");
	String house_code        = info.getSession("HOUSE_CODE");
%>

<html>
<head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

	<script language="javascript">
	<!--

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

    	//20번 Column By Formatting DateFormat의 경우 최초 데이터 가지고 오는 시점에도 2008/01/01로 가지고 와야만 포맷작업이 됩니다.
    	//2008010로 값을 가지고 오면 포맷작업이 안 이루어 지네요 ㅋㅋ..
    	//GridObj.setNumberFormat(nfCaseQty, GridObj.getColIndexById("add_amt"));
    	//GridObj.setDateFormat("%Y/%m/%d");

	    //GridObj.attachHeader("<div id='all_check_flt'></div>,#rspan,#rspan,#rspan,<div id='title_flt'></div>,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
	    //document.getElementById("title_flt").appendChild(document.getElementById("title_flt_box").childNodes[0]);
		//document.getElementById("all_check_flt").appendChild(document.getElementById("all_check_flt_box").childNodes[0]);
		GridObj.setSizes();
		//24번 Grid 합계 기능
		//GridObj.attachFooter("Total quantity,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,<div id='add_amt'>0</div>,#cspan,#cspan,",["text-align:left;"]);

		//18번 Column Visible Hidden, true, false 로 결정.
		//21번 Column Name By Index GridObj.getColIndexById("add_date") 인덱스 값이 리턴됩니다.
		// GridObj.setColumnHidden(GridObj.getColIndexById("status"), true);

		//23번 컬럼이동
		//GridObj.enableMultiline(true);
		//GridObj.enableColumnMove(true);

		//24번 Grid 중계 기능
		//GridObj.enableCollSpan(true);
		//GridObj.enableSmartRendering(true, 500);
		
		setTimeout(doSelect,500);
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
			//var doc_no       = LRTrim(document.WiseGrid.GetCellValue("DOC_NO", nRow));
			var doc_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("DOC_NO")).getValue());
			openReadMail_Send(doc_no);
		}

		if( header_name == "ATTACH_CNT")
		{
			//var ATTACH_NO_VALUE = LRTrim(SepoaGridGetCellValueIndex(document.WiseGrid,msg2, INX_ATTACH_NO));
			var ATTACH_NO_VALUE = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());
       		FileAttach('NOT',ATTACH_NO_VALUE,'VI');
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

		alert("<%=text.get("EM_005.CHECK_ROW")%>");
		return false;
	}



	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;
		alert(messsage);

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") doSelect();
		else alert(messsage);

		//alert(dhtmlx_start_row_id);
		//alert(dhtmlx_end_row_id);

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






function ReadMail(i)
{

	var dim = new Array(2);

dim = ToCenter('250','600');
var top = dim[0];
var left = dim[1];
var rw_cnt = document.forms[0].row_count.value;

	text1 =  document.forms[0].text1.value;
	doc_no =  document.forms[0].doc_no.value;
	confirm_date =  document.forms[0].confirm_date.value;


window.open("readmail.jsp?text1="+text1+"&doc_no="+doc_no+"&confirm_date="+confirm_date,"BKWin","top="+top+",left="+left+",width=600,height=250,resizable=yes,status=yes,scrollbars = yes");

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






function doSelect()
{
		var from_date = encodeUrl(LRTrim(ocument.form1.from_date.value));//작성시작일
		var to_date = encodeUrl(LRTrim(document.form1.to_date.value));//작성종료일
		var rcv_comp = encodeUrl(LRTrim(document.form1.rcv_comp.value));//확인여부
		var rcv_user = encodeUrl(LRTrim(document.form1.rcv_user.value));
		var case_no = "300";//발신함조회
		var grid_col_id = "<%=grid_col_id%>";
		var language = "<%=info.getSession("LANGUAGE")%>";

		//alert("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1?from_date="+from_date+"&to_date="+to_date+"&rcv_comp="+rcv_comp+"&rcv_user="+rcv_user+"&case_no="+case_no+"&grid_col_id="+grid_col_id+"&language="+language);

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1","from_date="+from_date+"&to_date="+to_date+"&rcv_comp="+rcv_comp+"&rcv_user="+rcv_user+"&case_no="+case_no+"&grid_col_id="+grid_col_id+"&language="+language);
		GridObj.clearAll(false);
}


function companyDelete()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
   if(!checkRows())	return;

   if (confirm("<%=text.get("EM_005.CONFIRM_DELETE")%>")){
	    var cols_ids = "<%=grid_col_id%>";
	    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1?cols_ids="+cols_ids+"&case_no=200");//발신함삭제
 		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
   }
}



	function initAjax(){
	}
	//-->
	</script>

</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" bgcolor="#FFFFFF" text="#000000"  onload="initAjax();setGridDraw();">
<s:header>
<form name="form1" method="post" action="">

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
        		<td  height="24" class="se_cell_title"><%=text.get("EM_005.ADD_USER")%></td><%--작성일--%>
				<td  height="24" class="se_cell_data">
					<s:calendar id_from="from_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"  
	        						default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" id_to="to_date" 
	        						format="%Y/%m/%d"/>
				</td>
				<td  height="24" class="se_cell_title"><%=text.get("EM_005.RECV_COMPANY")%></td><%--수신회사--%>
				<td  height="24" class="se_cell_data">
					<input type="text" name="rcv_comp" value="" length="15">
				</td>

				<td  height="24" class="se_cell_title"><%=text.get("EM_005.RECV_USER")%></td><%----수신자----%>
				<td  height="24" class="se_cell_data">
					<input type="text" name="rcv_user" value="" length="15">
				</td>
			</tr>

			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
								<td><script language="javascript">btn("javascript:doSelect();","<%=text.get("BUTTON.search")%>")</script></td>
								<TD><script language="javascript">btn("javascript:companyDelete();","<%=text.get("BUTTON.deleted")%>")</script></TD>
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