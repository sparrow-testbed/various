<%
/**
 * @파일명   : send_sms_mgt.jsp
 * @생성일자 : 2009. 03. 26
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : SMS/Mail전송
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
	multilang_id.addElement("AD_049");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_049";
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
	 * @메소드 설명 : SMS/Mail전송 > 조회
	 */
	%>
	function doQuery()
	{

		var vendor_code = LRTrim(document.forms[0].vendor_code.value);
		var user_type = LRTrim(document.forms[0].user_type.value);
		var user_name = encodeUrl(LRTrim(document.forms[0].user_name.value));

		var grid_col_id = "<%=grid_col_id%>";

		var param = "vendor_code="+vendor_code+"&user_type="+user_type+"&user_name="+user_name+"&mode=query&grid_col_id="+grid_col_id;
		//alert(param);
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.send_sms_mgt";

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
	 * @메소드명 : doSend
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : SMS 전송
	 */
	%>
	function doSend()
	{
		if(!checkRows()) return;

		url = "/admin/send_sms_contents.jsp?opener_function_name=sendSmsContents";
		window_title = "SMS";
		openPopupWindow(url, window_title, 500, 400);
	}
	<%
	/**
	 * @메소드명 : sendSmsContents
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doSend() 팝업에서 호출 SMS 전송
	 */
	%>
	function sendSmsContents(content,senderPhoneno)
	{
	/*
		GridObj.SetParam("mode", "insert");
		GridObj.SetParam("content", content);
		GridObj.SetParam("senderPhoneno", senderPhoneno);
		GridObj.DoQuery("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.send_sms_mgt", "sel", true, true);
	*/
		var grid_array = getGridChangedRows(GridObj, "selected");

		var cols_ids = "<%=grid_col_id%>";

		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.send_sms_mgt";//서블릿 경로
		var param = "?content="+encodeUrl(LRTrim(content))+"&senderPhoneno="+encodeUrl(LRTrim(senderPhoneno))+"&cols_ids="+cols_ids+"&mode=insert";//파라미터

	    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
		sendTransactionGrid(GridObj, myDataProcessor, "selected",grid_array);
	}

	<%
	/**
	 * @메소드명 : doSendMail()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : Mail 전송
	 */
	%>
	function doSendMail()
	{
		if(!checkRows()) return;

		url = "/admin/send_mail_contents.jsp?opener_function_name=sendMailContents";
		window_title = "MAIL";
		openPopupWindow(url, window_title, 640, 480);
	}

	<%
	/**
	 * @메소드명 : sendMailContents
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doSendMail() 팝업에서 호출 Mail 전송
	 */
	%>
	function sendMailContents(subject, content)
	{
	/*
		GridObj.SetParam("mode", "mail_send");
		GridObj.SetParam("content", content);
		GridObj.SetParam("subject", subject);
		GridObj.DoQuery("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.send_sms_mgt", "sel", true, true);
	*/
		var grid_array = getGridChangedRows(GridObj, "selected");

		var cols_ids = "<%=grid_col_id%>";

		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.send_sms_mgt";//서블릿 경로
		var param = "?content="+encodeUrl(LRTrim(content))+"&subject="+encodeUrl(LRTrim(subject))+"&cols_ids="+cols_ids+"&mode=mail_send";//파라미터

	    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
	    sendTransactionGrid(GridObj, myDataProcessor, "selected",grid_array);

	}

	function PopupManager(objForm, name)
	{
		if(name =="vendor_code")
		{
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	function SP0054_getCode(code, text1, text2) {
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_code_name.value = text1;
	}







	<%
	/**
	 * @메소드명 : doSaveEnd
	 * @생성일자 : 2009. 03. 26
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
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 저장시 선택필드에 체크된 로우 확인
	 */
	%>
	function checkRows()
	{

		var grid_array = getGridChangedRows(GridObj, "selected");
		//alert("grid_array.length==>"+grid_array.length);
		if(grid_array.length > 0)
		{
			return true;
		}

		//alert("<%=text.get("AD_049.msg_0001")%>");
		return false;
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
    		// 2009.06.05
    		// "selected" 이외의 체크박스는 readonly로 하기
    		// 기존값을 저장
    		if(cellInd != GridObj.getColIndexById("selected"))
			{
    			check_value = max_value;
    		}

			return true;
		} else if(stage==1) {
			// "selected" 이외의 체크박스는 readonly로 하기
			// 저장된 기존값으로 다시 설정하기
			if(cellInd != GridObj.getColIndexById("selected"))
			{
				GridObj.cells(rowId, cellInd).setValue(check_value);
				GridObj.cells(rowId, GridObj.getColIndexById("selected")).setValue("0");
			}
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



	var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
	function selectAll(){

		if(selectAllFlag == 0)
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("selected")).setValue("1");

			}
			selectAllFlag = 1;
		}
		else
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{

				GridObj.cells(j+1, GridObj.getColIndexById("selected")).setValue("0");

			}
			selectAllFlag = 0;
		}

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
							<%=text.get("AD_049.seller_code")%> <!-- 업체코드 -->
						</td>
						<td height="24" class="se_cell_data">
							<input type="text" name="vendor_code" size="10" maxlength="10" class="inputsubmit">
							<a href="javascript:PopupManager(document.forms[0],'vendor_code')"><img src="../images/button/query.gif" align="absmiddle" border="0" alt=""></a>
							<input type="hidden" name="vendor_code_name" size="20" class="input_data1">
        				</td>
						<td height="24" align="right" class="se_cell_title">
							<%=text.get("AD_049.master")%> <!--  담당자 -->
						</td>
						<td height="24" class="se_cell_data">
							<select name="user_type" id="user_type" class="inputsubmit">
						          <option value="0"><%=text.get("AD_049.cmb_0001")%></option>
						          <option value="1"><%=text.get("AD_049.sales_top_pic_flag")%></option>
						          <option value="2"><%=text.get("AD_049.sales_pic_flag")%></option>
						          <option value="3"><%=text.get("AD_049.pp_pic_flag")%></option>
						          <option value="4"><%=text.get("AD_049.foreign_pic_flag")%></option>
						          <option value="5"><%=text.get("AD_049.qm_pic_flag")%></option>
						          <option value="6"><%=text.get("AD_049.tax_pic_flag")%></option>
						     </select>
						</td>
						<td height="24" align="right" class="se_cell_title">
							<%=text.get("AD_049.user_name")%> <!--  담당자명 -->
						</td>
						<td height="24" class="se_cell_data">
						     <input type="text" name="user_name" size="10" class="inputsubmit" maxlength="50">
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
									<td><script language="javascript">btn("javascript:selectAll()",		"<%=text.get("AD_049.btn_select_all")%>")		</script></td>
									<td><script language="javascript">btn("javascript:doSend()",		"<%=text.get("AD_049.btn_sms_carry")%>")	</script></td>
									<td><script language="javascript">btn("javascript:doSendMail()",	"<%=text.get("AD_049.btn_mail_carry")%>")</script></td>
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