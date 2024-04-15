<%
/**
 * @파일명   : mail_send_history.jsp
 * @생성일자 : 2009. 03. 26
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : Mail전송내역
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
	String user_id = info.getSession("ID");

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_051");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_051";
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
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : Mail전송내역 > 조회
	 */
	%>
	function doQuery()
	{

		var start_sign_date = LRTrim(document.forms[0].START_SIGN_DATE.value);
		var end_sign_date = LRTrim(document.forms[0].END_SIGN_DATE.value);
		var mail_send_no = encodeUrl(LRTrim(document.forms[0].mail_send_no.value));
		var mail_send_search = LRTrim(document.forms[0].mail_send_search.value);
		var mail_send_search_word = encodeUrl(LRTrim(document.forms[0].mail_send_search_word.value).toUpperCase());


		if(!checkDateCommon(start_sign_date)) {
			alert("<%=text.get("AD_051.m001")%>");
			document.forms[0].start_sign_date.focus();
			return;
		}

		if(!checkDateCommon(end_sign_date)) {
			alert("<%=text.get("AD_051.m001")%>");
			document.forms[0].end_sign_date.focus();
			return;
		}

		if(mail_send_search == "" && mail_send_search_word != "" ) {
			alert("<%=text.get("AD_051.m003")%>");
			document.forms[0].mail_send_search.focus();
			return;
		}

		//날짜 검색에서 검색시작 날짜가 현재 날짜보다 크면 에러
		if(parseInt(start_sign_date, 10) > <%=to_day%>){
			alert("<%=text.get("AD_051.m002")%>");
			document.forms[0].end_sign_date.focus();
			return;
		}

		var grid_col_id = "<%=grid_col_id%>";

		var param = "start_sign_date="+start_sign_date+"&end_sign_date="+end_sign_date+"&mail_send_no="+mail_send_no+"&mail_send_search="+mail_send_search+"&mail_send_search_word="+mail_send_search_word+"&mode=query&grid_col_id="+grid_col_id;
		//alert(param);
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mail_send_history";

		GridObj.post(G_SERVLETURL,param);
		GridObj.clearAll(false);
	}


	<%
	/**
	 * @메소드명 : doQueryEnd
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doQuery() 로 결과조회 후 처리가 필요한 경우 사용하는 함수
	 */
	%>
    function doQueryEnd(GridObj, RowCnt)
    {
		var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");

		return true;
    }



 	<%
	/**
	 * @메소드명 : doOnRowSelected
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 그리드 셀 클릭 이벤트
	 */
	%>

	var setrow="0";
	var setcol="0";

	function doOnRowSelected(rowId,cellInd)
    {
//alert(GridObj.cells(rowId, cellInd).getValue());
//alert("rowId=="+rowId + "cellInd=="+cellInd);


		if( cellInd == GridObj.getColIndexById("mail_send_no") ) {
	        var mail_send_no = GridObj.cells(rowId, GridObj.getColIndexById("mail_send_no")).getValue();
			var url = "/admin/mail_send_history_detail.jsp?mail_send_no="+encodeUrl(LRTrim(mail_send_no));
			var window_title = ""
			var width = 800;
			var height = 600;
	        openPopupWindow(url, window_title, width, height);
	    }

    }



	<%
	/**
	 * @메소드명 : doOnCellChange
	 * @생성일자 : 2009. 03. 26
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
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 조회조건 콤보박스 생성
	 */
	%>
	function initAjax(){
		//doRequestUsingPOST( 'SL5001', 'M158' ,'manual_flag','' );

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

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5"> </td>
		</tr>
		<tr>
			<td width="100%" align="left" valign="top">
			<%/* 조회조건 START */ %>
				<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
					<tr>
						<td height="24" align="right" class="se_cell_title">
							<%=text.get("AD_051.0001")%> <!-- 전송일 -->
						</td>
						<td height="24" class="se_cell_data">
							<s:calendar id_from="START_SIGN_DATE" default_from="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(to_day, -3))%>"  
	        						default_to="<%=SepoaString.getDateSlashFormat(to_day)%>" id_to="END_SIGN_DATE" 
	        						format="%Y/%m/%d"/>
						</td>
						<td height="24" align="right" class="se_cell_title">
							<%=text.get("AD_051.0002")%> <!-- 전송번호 -->
						</td>
						<td height="24" class="se_cell_data">
							<input type="text" name="mail_send_no" size="12" class="inputsubmit" value="">
						</td>
						<td height="24" align="right" class="se_cell_title">
						<%=text.get("AD_051.gubun")%> <!-- 구분 -->
							<select name="mail_send_search" id="mail_send_search" class="inputsubmit">
										<option value=""><%=text.get("AD_051.all")%></option>
										<option value="mail_send_id"><%=text.get("AD_051.mail_send_id")%></option>
										<option value="mail_send_name"><%=text.get("AD_051.mail_send_name")%></option>
										<option value="mail_recv_name"><%=text.get("AD_051.mail_recv_name")%></option>
										<option value="send_email"><%=text.get("AD_051.send_email")%></option>
										<option value="receipt_email"><%=text.get("AD_051.receipt_email")%></option>
										<option value="mail_send_ref_no"><%=text.get("AD_051.mail_send_ref_no")%></option>
							</select>
						</td>
						<td height="24" class="se_cell_data">
							<input type="text" name="mail_send_search_word" size="12" class="inputsubmit" value="">
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
									<td><script language="javascript">btn("javascript:doQuery()",		"<%=text.get("BUTTON.search")%>")</script></td>
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
<jsp:param name="grid_object_name_height" value="gridbox=220"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>