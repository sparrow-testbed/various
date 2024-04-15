<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_115");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code = JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.paramCheck(info.getSession("COMPANY_CODE"));

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_115";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;
%>
<html>
<head>
<title>우리은행 전자구매시스템</title>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.duty_code_list";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;
var click_row = "";

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
	/*
	GridObj.attachEvent("onRowCreated",function(id){
		var cell = GridObj.cells(id, GridObj.getColIndexById("SELECTED")); //checkbox cell
		cell.setDisabled(true);
	})
	*/
}

<%--/* 입력한 company_code 에 대한 내용을 쿼리해 온다.*/--%>
function doSelect() {
	var i_company_code = encodeUrl(document.forms[0].i_company_code.value);
	var i_ctrl_type = encodeUrl(document.forms[0].i_ctrl_type.value);
	var i_ctrl_code = encodeUrl(document.forms[0].i_ctrl_code.value.toUpperCase());

	if(i_company_code == "") {
		//alert("회사코드를 입력해주세요.");
		alert("<%=text.get("AD_115.MSG_0109")%>");
		return;
	}

	document.forms[0].select_flag.value = "Y";
	document.forms[0].insert_flag.value = "off";

	var grid_col_id = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL;
	var params = "mode=query&grid_col_id="+grid_col_id+
	                                 "&i_company_code="+i_company_code+
	                                 "&i_ctrl_type="+encodeUrl(i_ctrl_type)+
	                                 "&i_ctrl_code="+encodeUrl(i_ctrl_code);
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);
}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}
function doOnRowSelected(rowId, cellInd)
{
	if(GridObj.getColIndexById("CTRL_TYPE_NAME") == cellInd) {
		if(document.forms[0].insert_flag.value == "off") {
			if(cellInd == GridObj.getColIndexById("CTRL_TYPE_NAME")) {
				//alert("Key 값은 수정할 수 없습니다.");
				alert("<%=text.get("AD_115.MSG_0107")%>");
				return false;
			} else if(cellInd == GridObj.getColIndexById("CTRL_CODE")) {
				//alert("Key 값은 수정할 수 없습니다.");
				alert("<%=text.get("AD_115.MSG_0107")%>");
				return false;
			}
		} else {
			searchProfile("i_ctrl_code");
			click_row = rowId;
		}
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
		if(document.forms[0].insert_flag.value == "off") {
			if(cellInd == GridObj.getColIndexById("CTRL_TYPE_NAME")) {
				//alert("Key 값은 수정할 수 없습니다.");
				alert("<%=text.get("AD_115.MSG_0107")%>");
				return false;
			} else if(cellInd == GridObj.getColIndexById("CTRL_CODE")) {
				//alert("Key 값은 수정할 수 없습니다.");
				alert("<%=text.get("AD_115.MSG_0107")%>");
				return false;
			}
		}

	    return true;
	}

	return false;
}

<%--/* JTable 에서 생성할 수 있도록 한 줄이 맨 밑에 추가된다.*/--%>
function Line_insert() {
	var i_company_code = document.forms[0].i_company_code.value;
	var select_flag = document.forms[0].select_flag.value;
	var insert_flag = document.forms[0].insert_flag.value;
	var reg_name = "<%=info.getSession("NAME_LOC")%>";

	if( select_flag == "" || i_company_code=="" )
	{
		//alert("조회먼저 하고 생성버튼을 누르세요.");
		alert("<%=text.get("AD_115.MSG_0100")%>");
		document.forms[0].i_company_code.focus();
	}
	else
	{
		if(insert_flag == "off")
		{
			dhtmlx_last_row_id++;
		   	var nMaxRow2 = dhtmlx_last_row_id;
		   	GridObj.enableSmartRendering(true);
			GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		   	GridObj.selectRowById(nMaxRow2, false, true);
		   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADD_USER_NAME_LOC")).setValue(reg_name);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("CHANGE_USER_NAME_LOC")).setValue("");
			document.forms[0].insert_flag.value = "on";
		} else {
			//alert("한줄씩만 생성 가능합니다.");
			alert("<%=text.get("AD_115.MSG_0101")%>");
			SepoaGridSetCellValueId(GridObj, dhtmlx_last_row_id, "SELECTED", "1"); <%--//check_box true 로 setting--%>
			SepoaGridSetCellValueId(GridObj, dhtmlx_last_row_id, "ADD_USER_NAME_LOC", reg_name);
			SepoaGridSetCellValueId(GridObj, dhtmlx_last_row_id, "CHANGE_USER_NAME_LOC", "");
		}
	}
}

<%--/* 생성을 누르게 되면 새로운 Data가 DB에 저장이 된다.*/--%>
function doInsert() {
	var wise = document.WiseGrid;
	var i_company_code = document.forms[0].i_company_code.value;
	var i_ctrl_type = "";
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");
	var last_row = chkLastOneRow("SELECTED");

	if(grid_array.length == 0)
	{
		//alert("등록할 항목이 없습니다.");
		alert("<%=text.get("AD_115.MSG_0102")%>");
		return;
	}
	else
	{
		if(SepoaGridGetCellValueId(GridObj, last_row, "CTRL_CODE").length < 1)
		{
			//alert("직무코드를 입력해야 합니다.");
			alert("<%=text.get("AD_115.MSG_0103")%>");
			return;
		}
		else
		{
			<%-- 신규등록시 직무형태 코드--%>
			i_ctrl_type = SepoaGridGetCellValueId(GridObj, last_row, "CTRL_TYPE");
		}

		if(SepoaGridGetCellValueId(GridObj, last_row, "CTRL_NAME_LOC").length < 1)
		{
			//alert("직무코드명을 입력해야 합니다.");
			alert("<%=text.get("AD_115.MSG_0108")%>");
			return;
		}

		var cols_ids    = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL +
		                  "?mode=setInsert&cols_ids="+cols_ids+
		                  "&i_company_code="+i_company_code+
		                  "&i_ctrl_type="+encodeUrl(i_ctrl_type);
	   	myDataProcessor = new dataProcessor(SERVLETURL);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);

		return;
	}
}

<%--/* 선택한 항목을 수정할 수 있는 화면으로 이동한다.*/--%>
function doUpdate() {
	var wise = document.WiseGrid;
	var i_company_code = document.forms[0].i_company_code.value;
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");

	<%--/* 청구담당코드 등록 화면이니까.. i_ctrl_type 은 "R" -- 잘못?瑛?  */
		수정화면에선 해당 로우의 ctrl_type값을 키로 잡는다.
	--%>
	var i_ctrl_type = "R";
	var i_ctrl_type = "";

	if(grid_array.length == 0)
	{
		//alert("항목을 선택해주세요.");
		alert("<%=text.get("AD_115.MSG_0104")%>");
	}
	else
	{
		var cols_ids    = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL +
		                  "?mode=setUpdate&cols_ids="+cols_ids+
		                  "&i_company_code="+i_company_code+
		                  "&i_ctrl_type="+encodeUrl(i_ctrl_type);
	   	myDataProcessor = new dataProcessor(SERVLETURL);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
}

<%--/* 선택한 항목을 지운다. */--%>
function doDelete() {
	var wise = document.WiseGrid;
	var i_company_code = document.forms[0].i_company_code.value;
	<%--/* 청구담당코드 등록 화면이니까.. i_ctrl_type 은 "R" --- 잘못된값 */--%>
	var i_ctrl_type = "R";
    var row_idx = checkedOneRow("SELECTED");
    if (row_idx == -1) return;

	if(SepoaGridGetCellValueId(GridObj, row_idx, "CTRL_CODE") == "" )
	{
		//if( confirm("정말로 삭제하시겠습니까?") )
		if( confirm("<%=text.get("AD_115.MSG_0105")%>") )
		{
			document.WiseGrid.DeleteRow(row_idx);
			document.forms[0].insert_flag.value = "off";
		}
		else
		{
			return;
		}
	}
	else
	{
		check_count(SepoaGridGetCellValueId(GridObj, row_idx, "CTRL_CODE"), SepoaGridGetCellValueId(GridObj, row_idx, "CTRL_TYPE"), i_company_code);
	}
}

function check_count(i_ctrl_code, i_ctrl_type, i_company_code) {
/* 	document.forms[0].target = "childframe";
	document.forms[0].action = "duty_code_delete.jsp?i_ctrl_code="+i_ctrl_code+"&i_ctrl_type="+i_ctrl_type+"&i_company_code="+i_company_code;
	document.method = "get";
	document.forms[0].submit(); */
	
	var jqa = new jQueryAjax();
	jqa.action = "duty_code_delete.jsp";
	jqa.data = "i_ctrl_code="+i_ctrl_code+"&i_ctrl_type="+i_ctrl_type+"&i_company_code="+i_company_code;
	jqa.submit(false);
}

function check_flag(result)
{
	var wise = document.WiseGrid;
	var i_company_code = document.forms[0].i_company_code.value;
	var i_ctrl_type = "R";   <%--/* 청구담당코드 등록 화면이니까.. i_ctrl_type 은 "R"  */--%>
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");

	if(result == "Y")
	{
		//if(confirm("정말로 삭제하시겠습니까?"))
		if( confirm("<%=text.get("AD_115.MSG_0105")%>") )
		{
			var cols_ids    = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL +
			                  "?mode=setDelete&cols_ids="+cols_ids+
			                  "&i_company_code="+encodeUrl(i_company_code)+
			                  "&i_ctrl_type="+encodeUrl(i_ctrl_type);
		   	myDataProcessor = new dataProcessor(SERVLETURL);
			sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
		else
		{
			return;
		}
	}
	else
	{
		//alert("담당자가 연결되어 있어서 삭제할 수 없습니다.");
		alert("<%=text.get("AD_115.MSG_0106")%>");
	}
}

function doSaveEnd(obj) {
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	var data_type= obj.getAttribute("data_type");

	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		doSelect();
	} else {
		alert(messsage);
	}

	return false;
}

function searchProfile(fc)
{
	var url = "";
	if(fc == "i_ctrl_code" ) {
       var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP9053&function=setCtrl_code&values=<%=house_code%>&values=M080&values=&values=&width=700";
       Code_Search(url3,'','','','720','500');
	}
}

function setCtrl_code(code, text2) {
	SepoaGridSetCellValueId(GridObj, click_row, "CTRL_TYPE_NAME", text2);
	SepoaGridSetCellValueId(GridObj, click_row, "CTRL_TYPE", code);
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();   <%--// Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..--%>
		doSelect();
	}
}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();"
	onkeydown='entKeyDown()'>
	<s:header>
		<form name="form1" method="post" action="">
			<input type="hidden" value="off" name="insert_flag"> <input
				type="hidden" value="" name="select_flag"> <input
				type="hidden" value="" name="row">
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
					<td height="5"></td>
				</tr>
				<tr>
					<td width="100%" valign="top">
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
							<tr>
								<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_115.COMPANY_CODE")%></td>
								<td width="30%" height="24" class="data_td"><select
									name="i_company_code" id="i_company_code" class="input_re">
										<%
											String lb = ListBox(request, "SL0006",info.getSession("HOUSE_CODE")+"#", company_code);
															out.println(lb);
										%>
								</select></td>
								<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_115.CTRL_TYPE_NAME")%></td>
								<td width="30%" height="24" class="data_td"><select
									name="i_ctrl_type" id="i_ctrl_type" class="inputsubmit">
										<option value=""></option>
										<%
											String com4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE")+ "#M080", "");
														out.println(com4);
										%>
								</select></td>
							</tr>
							<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
							<tr>
								<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_115.CTRL_CODE")%></td>
								<td width="30%" height="24" class="data_td" colspan="3">
									<input name="i_ctrl_code" type="text" class="inputsubmit"
									id="ins_com_code" value="" size="10">
								</td>
							</tr>
						</table>
						</td>
                		</tr>
            		</table>
						<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
							<TR>
								<td style="padding: 5 5 5 0">
									<TABLE cellpadding="2" cellspacing="0">
										<TR>
											<td><script language="javascript">btn("javascript:doSelect()","<%=text.get("BUTTON.search")%>")</script></td>
											<TD><script language="javascript">btn("javascript:Line_insert()","<%=text.get("BUTTON.rowinsert")%>")</script></TD>
											<TD><script language="javascript">btn("javascript:doInsert()","<%=text.get("BUTTON.insert")%>")</script></TD>
											<td><script language="javascript">btn("javascript:doUpdate()","<%=text.get("BUTTON.update")%>")</script></td>
											<TD><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></TD>
										</TR>
									</TABLE>
								</td>
							</TR>
						</TABLE>
<%-- 						
 --%>					</td>
				</tr>
			</table>
		</form>
<%-- 		<jsp:include page="/include/window_height_resize_event.jsp">
			<jsp:param name="grid_object_name_height" value="gridbox=240" />
		</jsp:include> --%>

	</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color: white;"></div>
<div id="pagingArea"></div> 
<s:footer/>
</body>
</html>
<!-- <iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe> -->