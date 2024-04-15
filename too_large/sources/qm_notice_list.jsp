<%@ page contentType = "text/html; charset=UTF-8" %>

<%@ page import="sepoa.fw.ses.SepoaInfo"%>
<%@ page import="sepoa.fw.ses.SepoaSession"%>
<%@ page import="java.util.Vector"%>
<%@ page import="java.util.HashMap"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("QM_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	HashMap text = MessageUtil.getMessage(info, multilang_id);

	String language = info.getSession("LANGUAGE");
	String user_type = info.getSession("USER_TYPE");
	String default_date = SepoaDate.getShortDateString();
	String default_finish_date = SepoaDate.addSepoaDateMonth(default_date, 1);
    String default_start_date = SepoaDate.addSepoaDateMonth(default_date, -1);
    String init_flag = JSPUtil.paramCheck(request.getParameter("init_flag"));

	if(init_flag.equals("true") && JSPUtil.paramCheck(request.getParameter("from_date")).length() > 0
	                            && JSPUtil.paramCheck(request.getParameter("to_date")).length() > 0)
	{
		default_start_date = JSPUtil.paramCheck(request.getParameter("from_date"));
		default_finish_date = JSPUtil.paramCheck(request.getParameter("to_date"));
	}
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "QM_001";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = true;
	
	if(!user_type.equals("S")){
		dhtmlx_back_cols_vec.addElement("seller_code=LColor");
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

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

var current_row_number = null;
var language = '<%=info.getSession("LANGUAGE")%>';

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    	
    <% if(info.getSession("USER_TYPE").equals("S")) {%>
    	GridObj.setColumnHidden(GridObj.getColIndexById("seller_code"), true);
		GridObj.setColumnHidden(GridObj.getColIndexById("SELLER_NAME_LOC"), true);	
    <% }%>
    	
   	<%	if(init_flag.equals("true") && JSPUtil.paramCheck(request.getParameter("from_date")).length() > 0
	                                && JSPUtil.paramCheck(request.getParameter("to_date")).length() > 0)
		{	%>
			doQuery();
	<%	}	%>
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
    	
    	if(cellInd == GridObj.getColIndexById("qm_number"))
		{
			var qm_number = SepoaGridGetCellValueId(GridObj, rowId, "qm_number");
			var url = "/qm/qm_notice_mgt.jsp?qm_number="+ encodeUrl(qm_number);
	    	var window_title = "qm_notice_mgt";
	    	openPopupWindow(url, window_title, 850, 730);
		}else if(cellInd == GridObj.getColIndexById("seller_code"))
		{
			var user_type  = "<%=user_type%>";
			if (user_type != "S")
	        {
	            var seller_code = SepoaGridGetCellValueId(GridObj, rowId, "seller_code");
				openSellerInfo(encodeUrl(seller_code));
	        }
		}
/*
		else if(cellInd == GridObj.getColIndexById("DRAWING_URL_INFO"))
		{
			var drawing_url_info = SepoaGridGetCellValueId(GridObj, rowId, "DRAWING_URL_INFO");

			if(LRTrim(drawing_url_info) == '')
			{
				alert("<%=text.get("QM_001.DRAWING_MSG_02")%>"); //도면정보가 존재하지 않습니다.
				return;
			}

			popUpOpen(drawing_url_info, "drawing_info", 400, 300);
		}
*/
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
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.qm.qm_notice_list";
		
		var from_date 			= encodeUrl(LRTrim(document.form.from_date.value.toUpperCase()));
		var to_date 			= encodeUrl(LRTrim(document.form.to_date.value.toUpperCase()));
		var MATERIAL_NUMBER 	= encodeUrl(LRTrim(document.form.MATERIAL_NUMBER.value.toUpperCase()));
		var qm_user_id 			= encodeUrl(LRTrim(document.form.qm_user_id.value.toUpperCase()));
		var PROGRESS_STATUS 	= encodeUrl(LRTrim(document.form.PROGRESS_STATUS.value.toUpperCase()));
		var Z_CODE1 			= encodeUrl(LRTrim(document.form.Z_CODE1.value.toUpperCase()));
		var seller_code 		= encodeUrl(LRTrim(document.form.seller_code.value.toUpperCase()));
		var notice_type 		= encodeUrl(LRTrim(document.form.notice_type.value.toUpperCase()));
		var grid_col_id = "<%=grid_col_id%>";
		
		if(from_date == "" || to_date == "") {
			alert("<%=text.get("QM_001.TEXT1")%>");
			return;
		}
		if(!checkDateCommon(from_date)) {
			alert("<%=text.get("QM_001.TEXT2")%>");
			document.form.from_date.focus();
			return;
		}
	
	 	if(!checkDateCommon(to_date)) {
	  		alert("<%=text.get("QM_001.TEXT2")%>");
	  		document.form.to_date.focus();
	  		return;
	 	}
	 	
	 	var url = servletUrl + "?from_date=" + from_date + "&to_date=" + to_date + "&MATERIAL_NUMBER=" + MATERIAL_NUMBER + "&qm_user_id=" + qm_user_id +
	 			  "&PROGRESS_STATUS=" + PROGRESS_STATUS + "&Z_CODE1=" + Z_CODE1 + "&seller_code=" + seller_code + "&notice_type=" + notice_type +
	 			  "&mode=query&grid_col_id=" + grid_col_id;

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
		
		var statement;
		var not_accept=0;
		var end_accept=0;
		var ing=0;
		var serson_end=0;
		var end=0;
		var sum=0;
		var progress_status = "";
		
		if(status == "false") alert(msg);
		else 
		{
			/*
			for(i = dhtmlx_start_row_id; i < dhtmlx_end_row_id; i++)
			{
				progress_status = SepoaGridGetCellValueIndex(GridObj, i, "PROGRESS_STATUS");

				if(progress_status == "A" ){
					not_accept++;
				}else if(progress_status == "B" ){
					end_accept++;
				}else if(progress_status == "C" ){
					ing++;
				}else if(progress_status == "D" ){
					serson_end++;
				}else if(progress_status == "E" ){
					end++;
				}else if(progress_status == "F" ){
					sum++;
				}
	
			}
			*/
			
			document.getElementById("test").innerHTML = GridObj.getUserData("", "PROGRESS_STATUS");
			
		 	//document.getElementById("test").innerHTML = "*<%=text.get("QM_001.001")%> "+not_accept+"<%=text.get("QM_001.unit_001")%>, <%=text.get("QM_001.002")%> "+end_accept+
		 	//"<%=text.get("QM_001.unit_001")%>,<%=text.get("QM_001.003")%> "+ing+" <%=text.get("QM_001.unit_001")%>,<%=text.get("QM_001.004")%> "+serson_end+
		 	//" <%=text.get("QM_001.unit_001")%>,<%=text.get("QM_001.005")%> "+end+" <%=text.get("QM_001.unit_001")%>,<%=text.get("QM_001.006")%> "+sum+"<%=text.get("QM_001.unit_001")%>";
		}
	
		return true;
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
	
	function PopupManager(objForm, name)
	{
		if(name == "seller_code")
		{
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}
	
	function SP0054_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
	}
</script>
<link rel="stylesheet" href="../../css/body.css" type="text/css">
</head>
<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<form name="form">
<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
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
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.notice_date")%></td>
        		<td height="24" class="se_cell_data">
        			<input type="text" name="from_date" size="8"  value="<%=default_start_date%>" maxlength="8" class="input_re">
					<img src="../images/ico_cal.gif" width="21" height="20" hspace="0" align="absmiddle" style="cursor:hand" onClick="popUpCalendar(this, from_date, 'yyyy/mm/dd')">
					~
					<input type="text" name="to_date" size="8" value="<%=default_finish_date%>" maxlength="8" class="input_re">
					<img src="../images/ico_cal.gif" width="21" height="20" hspace="0" align="absmiddle" style="cursor:hand" onClick="popUpCalendar(this, to_date, 'yyyy/mm/dd')">
        		</td>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.item_code")%></td>
        		<td height="24" class="se_cell_data">
					<input type="text" name="MATERIAL_NUMBER" class="inputsubmit" size="12">
				</td>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.quality_master")%></td>
        		<td height="24" class="se_cell_data">
					<input type="text" name="qm_user_id" class="inputsubmit" size="12">
				</td>
			  </tr>
			  
		      <tr>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.statement")%></td>
        		<td height="24" class="se_cell_data">
        			<select name="PROGRESS_STATUS" class="inputsubmit" >
						<option value=""><%=text.get("QM_001.all")%></option>
						<%
							String PROGRESS_STATUS = ListBox(request, "SL0018" , "M214", "");
							out.println(PROGRESS_STATUS);
						%>
					</select>
        		</td>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.project_code")%></td>
        		<td height="24" class="se_cell_data">
					<input type="text" name="Z_CODE1"  class="inputsubmit" size="12">
				</td>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.cm_code")%></td>
        		<td height="24" class="se_cell_data">
					<%  if(!user_type.equals("S")){ %>
						<input type="text" name="seller_code" size="10" class="inputsubmit" maxlength="10">
				        <a href="javascript:PopupManager(document.forms[0],'seller_code')"><img src="../images/button/query.gif" align="absmiddle" border="0" alt=""></a>
					<% } else {%>
						<input type="text" name="seller_code" value="<%=info.getSession("COMPANY_CODE")%>" size="10" class="inputsubmit" maxlength="10" readonly>
					<% } %>
				</td>
			  </tr>
			  
		      <tr>
        		<td height="24" align="right" class="se_cell_title"><%=text.get("QM_001.notice_type")%></td>
        		<td height="24" class="se_cell_data" colspan="5">
        			<select name="notice_type" class="inputsubmit" >
						<option value=""><%=text.get("QM_001.all")%></option>
							<%
								String notice_type = ListBox(request, "SL0018" , "M213", "");
								out.println(notice_type);
							%>
					</select>
        		</td>
			  </tr>
			  <talbe>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
						<td><script language="javascript">btn("javascript:doQuery()","<%=text.get("QM_001.btn_query")%>")</script></td>
						<td><DIV ID="test"></DIV></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			  <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              <div id="pagingArea"></div>
             <%@ include file="/include/include_bottom.jsp"%>
			</td>
		  </tr>
		</table>
	</form>
<iframe name="work" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
<jsp:include page="/include/window_height_resize_event.jsp" >
	<jsp:param name="grid_object_name_height" value="gridbox=190"/>
</jsp:include>

</body>
</html>
