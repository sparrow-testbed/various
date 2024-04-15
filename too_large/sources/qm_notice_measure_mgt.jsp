<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("QM_004");
    HashMap text 				= MessageUtil.getMessage(info,multilang_id);

    String qm_number = JSPUtil.paramCheck(request.getParameter("qm_number"));
    String bad_seq = JSPUtil.paramCheck(request.getParameter("bad_seq"));

    // Dthmlx Grid 전역변수들..
	String screen_id = "QM_004";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
%>

<html>
<head>

<%@ include file="/include/include_css.jsp"%>

<script language=javascript src="../js/sec.js"></script>

<script src="../js/cal.js" language="javascript"></script>

<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.qm.qm_notice_measure_mgt";

var attach_nRow = null;
var adjust_nRow = null;

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();

    	doQuery();
    }

	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }

    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());

    	if(cellInd == GridObj.getColIndexById("ADJUST_CODE_TEXT"))
		{
			adjust_nRow = rowId;
			getQMCode();
		}
		else if(cellInd == GridObj.getColIndexById("ATTACH_CNT"))
		{
			attach_nRow = rowId;

			<%if(info.getSession("USER_TYPE").equals("S")){ %>
				attach_file(SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_NO"),"QM");
			<%}else{ %>
				FileAttach("QM",SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_NO"),"VI");
			<%} %>
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

    function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("QM_004.msg_0004")%>"); // 선택된 Row 가 존재하지 않습니다.
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

	function doQuery()
	{
		var qm_number 	= encodeUrl(LRTrim(document.form.qm_number.value));
		var bad_seq 	= encodeUrl(LRTrim(document.form.bad_seq.value));
		var language	= encodeUrl(LRTrim("<%=info.getSession("LANGUAGE")%>"));
		var grid_col_id = "<%=grid_col_id%>";

		var url = servletUrl + "?qm_number=" + qm_number + "&bad_seq=" + bad_seq + "&language=" + language + "&mode=query&grid_col_id=" + grid_col_id;

		GridObj.post(url);
		GridObj.clearAll(false);
	}

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

    function doSave()
    {
		if(!checkRows())
				return;

		var grid_array = getGridChangedRows(GridObj, "selected");

		var message0101 = '<%=text.get("QM_004.msg_0001")%>'; // 기간은 필수입력사항 입니다.
		var message0102 = '<%=text.get("QM_004.msg_0002")%>'; // 화폐단위는 필수입력사항 입니다.
		var message1005 = '<%=text.get("QM_004.msg_0003")%>'; // 메뉴코드는 필수입력사항 입니다.
		var message1004 = '<%=text.get("QM_004.msg_0004")%>'; // 선택된 Row 가 존재하지 않습니다.

		for(var i = 0; i < grid_array.length; i++)
        {
        	if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ADJUST_NO")).getValue()) == "" )
        	{
        		alert(message0101);
				return;
        	}

        	//if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ADJUST_CODE_TEXT")).getValue()) == "" )
        	//{
        	//	alert(message0102);
			//	return;
        	//}

        	if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ADJUST_TEXT")).getValue()) == "" )
        	{
        		alert(message1005);
				return;
        	}
       	}

		if (confirm("<%=text.get("QM_004.msg_0005")%>")) {
		   	var qm_number 	= encodeUrl(LRTrim(document.form.qm_number.value));
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor(servletUrl + "?qm_number=" + qm_number + "&cols_ids="+cols_ids+"&mode=save");
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }

		//document.WiseGrid.SendData(servletUrl);
	}

	function doDelete()
	{
	    if(!checkRows())	return;

		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var i = 0; i < grid_array.length; i++)
        {
        	if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ADJUST_SEQ")).getValue()) == "" )
        	{
        		GridObj.enableSmartRendering(false);
        		GridObj.deleteRow(grid_array[i]);
        	}
        }

	    if (confirm("<%=text.get("QM_004.msg_0006")%>"))
	    {
		  	var qm_number 	= encodeUrl(LRTrim(document.form.qm_number.value));
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor(servletUrl + "?qm_number=" + qm_number + "&cols_ids="+cols_ids+"&mode=delete");
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
	    }
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
			doQuery();
		} else {
			alert(messsage);
		}

		return false;
	}

	function insertLine()
	{
	    dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";

    	GridObj.enableSmartRendering(true);
    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).cell.wasChanged = true;

		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("BAD_SEQ")).setValue("<%=bad_seq%>");
	    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADJUST_NO")).setValue(nMaxRow2);
	    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ATTACH_NO")).setValue("");
	    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ATTACH_CNT")).setValue("<%=POASRM_CONTEXT_NAME%>/images/icon/icon_disk_a.gif^0");

	}

	function getQMCode() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP3000&function=setQmCode&values=M221&values=&values=";
		Code_Search(url, 'getQmCodeList', '', '', '', '');
	}

	function setQmCode(adjust_code, adjust_code_text, adjust_code_group)
	{
		//alert("qm_code : " + adjust_code);
		//alert("qm_code_description : " + adjust_code_text);
		//alert("qm_code_group : " + adjust_code_group);

		SepoaGridSetCellValueId(GridObj, adjust_nRow, "ADJUST_CODE", adjust_code);
		SepoaGridSetCellValueId(GridObj, adjust_nRow, "ADJUST_CODE_TEXT", adjust_code_text);
		SepoaGridSetCellValueId(GridObj, adjust_nRow, "ADJUST_CODE_GROUP", adjust_code_group);
		SepoaGridSetCellValueId(GridObj, adjust_nRow, "selected", "1");
	}

	function ParentQuery(){
		opener.doGridQuery();
	}

	function setAttach(attach_key, arrAttrach, attach_count) {
	    var attachfilename  = arrAttrach + "";
	    var result    ="";
	    var attach_info  = attachfilename.split(",");

	    for (var i =0;  i <  attach_count; i ++)
	    {
			 var doc_no   = attach_info[0+(i*7)];
			 var doc_seq   = attach_info[1+(i*7)];
			 var type   = attach_info[2+(i*7)];
			 var des_file_name  = attach_info[3+(i*7)];
			 var src_file_name  = attach_info[4+(i*7)];
			 var file_size   = attach_info[5+(i*7)];
			 var add_user_id  = attach_info[6+(i*7)];

	 	if (i == attach_count-1)
	     	result = result + src_file_name;
	 	else
	     	result = result + src_file_name + ",";
	    }//End for

		if(attach_count > 0)
		{
			SepoaGridSetCellValueId(GridObj, attach_nRow, "ATTACH_CNT", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon_disk_b.gif^" + attach_count);
		}else{
			SepoaGridSetCellValueId(GridObj, attach_nRow, "ATTACH_CNT", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon_disk_a.gif^" + attach_count);
		}

		GridObj.cells(attach_nRow, GridObj.getColIndexById("selected")).cell.wasChanged = true;
		SepoaGridSetCellValueId(GridObj, attach_nRow, "ATTACH_NO", attach_key);
		SepoaGridSetCellValueId(GridObj, attach_nRow, "selected", "1");
		//document.forms[0].FILE_NAME.value = result;
		//document.forms[0].re_prevent_attach_no_count.value = attach_count;
	}//End function

<%--
function getFirstSelectRow(row_number)
{
	var selected_flag = false;

	for(i = row_number; i < GridObj.GetRowCount(); i++)
	{
		if(GridObj.GetCellValue("selected", i) == 1)
		{
			selected_flag = true;
			return i;
		}
	}

	if(! selected_flag)
	{
		return -1;
	}
}
--%>
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="setGridDraw();" onbeforeunload="ParentQuery();">
<form name="form">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<%@ include file="/include/include_menu.jsp"%>

				<td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="98%" border="0" cellspacing="0" cellpadding="0">

				<%@ include file="/include/sepoa_milestone.jsp"%>

						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="5" colspan="2"></td>
							</tr>
						</table>
						<!-- search start-->

						<table width="100%" border="0" cellspacing="1" cellpadding="0" height="35" bgcolor="#DBDBDB">
							<tr>
		        				<td width="20%" class="div_input" height="25"><%=text.get("QM_004.notice_num")%></td>
		        				<td class="div_data">
			        				 <input type="text"  value="<%=qm_number%>" name="qm_number" size="18" class="input_empty" readonly>
			        				 <input type="hidden" name="bad_seq" value="<%=bad_seq %>">
			        			</td>
							</tr>
						</table>
						<!-- search end-->
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="100%" height="40">
								<table border="0" cellspacing="3" cellpadding="0">
								<tr>
									<TD><script language="javascript">btn("javascript:doQuery()","<%=text.get("QM_004.btn_query")%>")</script></TD>
						      	<%if(info.getSession("USER_TYPE").equals("S")){ %>
						      		<TD><script language="javascript">btn("javascript:insertLine()","<%=text.get("QM_004.btn_insert")%>")</script></TD>
					      			<TD><script language="javascript">btn("javascript:doSave()","<%=text.get("QM_004.btn_save")%>")</script></TD>
					      			<TD><script language="javascript">btn("javascript:doDelete()","<%=text.get("QM_004.btn_delete")%>")</script></TD>
					      		<%} %>
								</tr>
								</table>
								</td>
							</tr>
							<tr align="left">
								<td>
									<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              						<div id="pagingArea"></div>
								</td>
							</tr>
						</table>
				</table>
				</td>
				<td width="11" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_right.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="11" height="100%"></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</form>

<jsp:include page="/include/window_height_resize_event.jsp" >
<jsp:param name="grid_object_name_height" value="gridbox=150"/>
</jsp:include>

</body>
</html>