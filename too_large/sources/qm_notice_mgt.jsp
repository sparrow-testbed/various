<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%!
	public String deconvertDate(String dataData){
		if(dataData != null && dataData.length() ==10){
			dataData = dataData.replaceAll("/","");
			return dataData;
		}
		return dataData;
	}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("QM_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;

	String qm_number = JSPUtil.paramCheck(request.getParameter("qm_number"));
	String mode = JSPUtil.paramCheck(request.getParameter("mode"));

	String seller_code = "";
	String seller_name_loc = "";
	String progress_status = "";
	String progress_status_code = "";
	String notice_type = "";
	String qm_user_id = "";
	String z_code1 = "";
	String notice_date = "";
	String return_due_date = "";
	String subject = "";
	String bad_text = "";
	String material_number = "";
	String description_eng = "";
	String item_qty = "";
	String adjust_req_text = "";
	String plan_end_date = "";
	String finish_date = "";
	String temp_adjust_text = "";
	String re_prevent_end_date = "";
	String re_prevent_attach_no = "";
	String re_prevent_attach_no_count = "";
	String benefit_text = "";
	String re_prevent_text = "";
	String unit_measure = "";
	String temp_return_due_date = "";
	String temp_notice_date = "";
	String drawing_url_info = "";
	String temp_plan_end_date = "";
	String screen_message = "";
	SepoaOut value = null;
	String issue_number = "";
	String progress_point = "";
	String bad_qty = "";
	String lot_size = "";
	String aql_ma = "";
	String aql_mi = "";
	String notice_type_code = "";
	String rework_date = JSPUtil.paramCheck(request.getParameter("rework_date"));
	String rework_item_qty = JSPUtil.paramCheck(request.getParameter("rework_item_qty"));
	String rework_bad_qty = JSPUtil.paramCheck(request.getParameter("rework_bad_qty"));
	String recert_date = JSPUtil.paramCheck(request.getParameter("recert_date"));
	String recert_cert_qty = JSPUtil.paramCheck(request.getParameter("recert_cert_qty"));
	String recert_bad_qty = JSPUtil.paramCheck(request.getParameter("recert_bad_qty"));
	String accept_flag = JSPUtil.paramCheck(request.getParameter("accept_flag"));
	String seller_send_date = JSPUtil.paramCheck(request.getParameter("seller_send_date"));

	if(mode.equals("save") || mode.equals("save_re"))
    {
    	String plan_end_date_req = JSPUtil.paramCheck(request.getParameter("plan_end_date"));
    	String temp_adjust_text_req = JSPUtil.paramCheck(request.getParameter("temp_adjust_text"));

	    Object[] obj = {info , qm_number , plan_end_date_req , temp_adjust_text_req,
	    				rework_date, rework_item_qty, rework_bad_qty, recert_date, recert_cert_qty, recert_bad_qty, mode };
	    value = ServiceConnector.doService(info, "QM_002", "TRANSACTION", "saveQmDeatilInfoFirst", obj);

		if(! value.flag)
	    {
	    	mode = "";
	    	screen_message = SepoaString.replace(SepoaString.replace(SepoaString.replace(value.message, "\r", ""), "\n", ""), "\"", "\\\"");
	    }
	    else
	    {
			mode = "";
			screen_message = (String) text.get("QM_002.success_msg");
	    }
    }
    else if(mode.equals("save2") || mode.equals("send") || mode.equals("send_cancel") || mode.equals("confirm") || mode.equals("reject"))
    {
    	String benefit_text_req = JSPUtil.paramCheck(request.getParameter("benefit_text"));
    	String re_prevent_end_date_req = JSPUtil.paramCheck(request.getParameter("re_prevent_end_date"));
    	String re_prevent_text_req = JSPUtil.paramCheck(request.getParameter("re_prevent_text"));
    	String re_prevent_attach_no_req = JSPUtil.paramCheck(request.getParameter("re_prevent_attach_no"));

	    Object[] obj = {info , qm_number , benefit_text_req , re_prevent_end_date_req , re_prevent_text_req ,re_prevent_attach_no_req, mode};
	    value = ServiceConnector.doService(info, "QM_002", "TRANSACTION", "saveQmDeatilInfoSecond", obj);

		if(! value.flag)
	    {
	    	mode = "";
	    	screen_message = SepoaString.replace(SepoaString.replace(SepoaString.replace(value.message, "\r", ""), "\n", ""), "\"", "\\\"");
	    }
	    else
	    {
			mode = "";
			screen_message = (String) text.get("QM_002.success_msg");
	    }
    }

	if(mode.length() <= 0)
    {
	    Object[] obj = {info,qm_number};
	    value = ServiceConnector.doService(info, "QM_002", "TRANSACTION", "searchQmDeatilInfo", obj);

		if(! value.flag)
	    {
	    	mode = "";
	    	screen_message = SepoaString.replace(SepoaString.replace(SepoaString.replace(value.message, "\r", ""), "\n", ""), "\"", "\\\"");
	    }
	    else
	    {
	    	SepoaFormater wf = new SepoaFormater(value.result[0]);
			if(wf.getRowCount() > 0)
			{
				seller_code	= wf.getValue("seller_code", 	0);
				seller_name_loc	= wf.getValue("seller_name_loc", 	0);
				progress_status	= wf.getValue("progress_status", 	0);
				progress_status_code = wf.getValue("progress_status_code", 	0);
				notice_type	= wf.getValue("notice_type", 	0);
				qm_user_id = wf.getValue("qm_user_id", 	0);
				z_code1	= wf.getValue("z_code1", 	0);
				notice_date = wf.getValue("notice_date", 	0);
				temp_notice_date = deconvertDate(notice_date);
				return_due_date	= wf.getValue("return_due_date", 	0);
				temp_return_due_date = deconvertDate(return_due_date);
				subject = wf.getValue("subject", 	0);
				bad_text = wf.getValue("bad_text", 	0);
				material_number	= wf.getValue("material_number", 	0);
				description_eng	= wf.getValue("description_eng", 	0);
				item_qty = wf.getValue("item_qty", 	0);
				adjust_req_text	= wf.getValue("adjust_req_text", 	0);
				plan_end_date = wf.getValue("plan_end_date", 	0);
				temp_plan_end_date = wf.getValue("plan_end_date", 	0);
				finish_date	= wf.getValue("finish_date", 	0);
				temp_adjust_text = wf.getValue("temp_adjust_text", 	0);
				re_prevent_end_date	= wf.getValue("re_prevent_end_date", 	0);
				re_prevent_attach_no = wf.getValue("re_prevent_attach_no", 	0);
				re_prevent_attach_no_count = wf.getValue("re_prevent_attach_no_count", 	0);
				benefit_text = wf.getValue("benefit_text", 	0);
				re_prevent_text	= wf.getValue("re_prevent_text", 	0);
				unit_measure = wf.getValue("unit_measure", 	0);
				drawing_url_info = wf.getValue("drawing_url_info", 	0);
				issue_number = wf.getValue("issue_number", 	0);
				progress_point = wf.getValue("progress_point", 	0);
				bad_qty = wf.getValue("bad_qty", 	0);
				lot_size = wf.getValue("lot_size", 	0);
				aql_ma = wf.getValue("aql_ma", 	0);
				aql_mi = wf.getValue("aql_mi", 	0);
				rework_date = wf.getValue("rework_date", 	0);
				rework_item_qty = wf.getValue("rework_item_qty", 	0);
				rework_bad_qty = wf.getValue("rework_bad_qty", 	0);
				recert_date = wf.getValue("recert_date", 	0);
				recert_cert_qty = wf.getValue("recert_cert_qty", 	0);
				recert_bad_qty = wf.getValue("recert_bad_qty", 	0);
				accept_flag = wf.getValue("accept_flag", 	0);
				seller_send_date = wf.getValue("seller_send_date", 	0);
				notice_type_code = wf.getValue("notice_type_code", 	0);
			}
	    }
    }

    // Dthmlx Grid 전역변수들..
	String screen_id = "QM_002";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = true;
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

<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();

    	<%if(mode.length() <= 0){%>
			doGridQuery();
		<%}%>
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

    	if(cellInd == GridObj.getColIndexById("QMCA_CNT"))
		{
			var BAD_SEQ = SepoaGridGetCellValueId(GridObj, rowId, "BAD_SEQ");
			var QM_NUMBER = document.form.qm_number.value;

			popUpOpen('qm_notice_bad_mgt.jsp?qm_number='+encodeUrl(QM_NUMBER)+'&bad_seq=' + encodeUrl(BAD_SEQ), 'RFCLOG', '600', '500');

		}
		else if(cellInd == GridObj.getColIndexById("QMAD_CNT"))
		{
			var BAD_SEQ = SepoaGridGetCellValueId(GridObj, rowId, "BAD_SEQ");
			var QM_NUMBER = document.form.qm_number.value;

			popUpOpen('qm_notice_measure_mgt.jsp?qm_number='+encodeUrl(QM_NUMBER)+'&bad_seq=' + encodeUrl(BAD_SEQ), 'RFCLOG', '750', '500');
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

	function doExcelUpload() {
		var bufferData = window.clipboardData.getData("Text");
		if(bufferData.length > 0) {
			GridObj.clearAll();
			GridObj.setCSVDelimiter("\t");
    		GridObj.loadCSVString(bufferData);
		}
		return;
	}

	function doGridQuery()
	{
		var qm_number = encodeUrl(LRTrim(document.form.qm_number.value.toUpperCase()));
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.qm.qm_notice_mgt";
		var grid_col_id = "<%=grid_col_id%>";

		var url = servletUrl + "?qm_number=" + qm_number + "&mode=doGridQuery&grid_col_id=" + grid_col_id;

		GridObj.post(url);
		GridObj.clearAll(false);
	}

	function doQuery()
	{
		f = document.form;
		f.mode.value = '';
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
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

	function length_check3(obj, max_length)
	{
		var len = getLength2Bytes(obj.value);
		document.form.content_length3.value = len;
		if(len > max_length)
		{
			alert("<%=text.get("QM_002.msg_0001")%>");
			SubStrLen2Bytes(obj, max_length);
		}
	}
	function length_check(obj, max_length)
	{
		var len = getLength2Bytes(obj.value);
		document.form.content_length.value = len;
		if(len > max_length)
		{
			alert("<%=text.get("QM_002.msg_0001")%>");
			SubStrLen2Bytes(obj, max_length);
		}
	}

	function length_check2(obj, max_length)
	{
		var len = getLength2Bytes(obj.value);
		document.form.content_length2.value = len;

		if(len > max_length)
		{
			alert("<%=text.get("QM_002.msg_0001")%>");
			SubStrLen2Bytes(obj, max_length);
		}
	}

	function initContent()
	{
		length_check(document.form.benefit_text, 1000);
		//length_check2(document.form.re_prevent_text, 1000);
		length_check3(document.form.temp_adjust_text, 1000);
	}

	function SubStrLen2Bytes(obj, max_length)
	{
		obj.value = getSubStrLength2Bytes(obj.value, max_length);
		initContent();
		obj.focus();
		return;
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

		document.forms[0].re_prevent_attach_no.value = attach_key;
		document.forms[0].FILE_NAME.value = result;
		document.forms[0].re_prevent_attach_no_count.value = attach_count;
	}//End function

	function doSave()
	{
		f = document.form;

		if(! checkForm()) return;
		if(! confirm("<%=text.get("QM_002.msg_0004")%>")) return;

		if(f.plan_end_date.value > " ")
		{
			if(! checkDateCommon(f.plan_end_date.value))
			{
				//날짜형식으로 입력 하시기 바랍니다.
				alert("<%=text.get("QM_002.msg_date_type")%>" + "<%=text.get("QM_002.step_destine_date")%>");
				document.forms[0].plan_end_date.focus();
				return false;
			}
		}

		f.mode.value = 'save';
		f.plan_end_date.value = LRTrim(f.plan_end_date.value);
		f.temp_adjust_text.value = LRTrim(f.temp_adjust_text.value);
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function doSend()
	{
		f = document.form;

		if(! checkForm2()) return;
		if(! confirm("<%=text.get("QM_002.msg_confirm_send")%>")) return; //발송 하시겠습니까?

		f.mode.value = 'send';
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function doSendCancel()
	{
		f = document.form;
		if(! confirm("<%=text.get("QM_002.msg_cancel_send")%>")) return; //발송 취소하시겠습니까?
		f.mode.value = 'send_cancel';
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function doConfirm()
	{
		f = document.form;
		if(! confirm("<%=text.get("QM_002.msg_confirm")%>")) return; //승인하시겠습니까?
		f.mode.value = 'confirm';
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function doReject()
	{
		f = document.form;
		if(! confirm("<%=text.get("QM_002.msg_reject")%>")) return; //반려하시겠습니까?
		f.mode.value = 'reject';
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function doSaveRe()
	{
		f = document.form;

		if(! checkForm()) return;
		if(! confirm("<%=text.get("QM_002.msg_0004")%>")) return;

		if(f.plan_end_date.value > " ")
		{
			if(! checkDateCommon(f.plan_end_date.value))
			{
				//날짜형식으로 입력 하시기 바랍니다.
				alert("<%=text.get("QM_002.msg_date_type")%>" + "<%=text.get("QM_002.step_destine_date")%>");
				document.forms[0].plan_end_date.focus();
				return false;
			}
		}

		<%--출하검사일 경우 재검사와 재작업 중 하나는 입력 해야 함.--%>
		if("<%=notice_type_code%>" == "F5")
		{
			f.rework_date.value = LRTrim(f.rework_date.value);
			f.recert_date.value = LRTrim(f.recert_date.value);
			f.rework_item_qty.value = LRTrim(f.rework_item_qty.value);
			f.rework_bad_qty.value = LRTrim(f.rework_bad_qty.value);
			f.recert_cert_qty.value = LRTrim(f.recert_cert_qty.value);
			f.recert_bad_qty.value = LRTrim(f.recert_bad_qty.value);

			if(f.rework_item_qty.value == "")
			{
				f.rework_item_qty.value = "0";
			}

			if(f.rework_bad_qty.value == "")
			{
				f.rework_bad_qty.value = "0";
			}

			if(f.recert_cert_qty.value == "")
			{
				f.recert_cert_qty.value = "0";
			}

			if(f.recert_bad_qty.value == "")
			{
				f.recert_bad_qty.value = "0";
			}

			if(f.rework_date.value == "" && f.recert_date.value == "")
			{
				//출하검사일 경우 재작업/재검사 내역중 하나는 입력 하시기 바랍니다.
				alert("<%=text.get("QM_002.msg_1001")%>");
				return false;
			}

			if(f.rework_date.value > " ")
			{
				if(! checkDateCommon(f.rework_date.value))
				{
					//날짜형식으로 입력 하시기 바랍니다.
					alert("<%=text.get("QM_002.msg_date_type")%>" + "<%=text.get("QM_002.rework_date")%>");
					document.forms[0].rework_date.focus();
					return false;
				}
			}

			if(f.recert_date.value > " ")
			{
				if(! checkDateCommon(f.recert_date.value))
				{
					//날짜형식으로 입력 하시기 바랍니다.
					alert("<%=text.get("QM_002.msg_date_type")%>" + "<%=text.get("QM_002.recert_date")%>");
					document.forms[0].recert_date.focus();
					return false;
				}
			}
		}

		f.mode.value = 'save_re';
		f.plan_end_date.value = LRTrim(f.plan_end_date.value);
		f.temp_adjust_text.value = LRTrim(f.temp_adjust_text.value);
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function checkForm()
	{
		if(getLength(document.forms[0].plan_end_date.value) == 0)
		{
			alert("<%=text.get("QM_002.msg_0002")%>");
			document.forms[0].plan_end_date.focus();
			return false;
		}
		if(getLength(document.forms[0].temp_adjust_text.value) == 0)
		{
			alert("<%=text.get("QM_002.msg_0003")%>");
			document.forms[0].temp_adjust_text.focus();
			return false;
		}

		var temp_return_due_date = "<%=temp_return_due_date%>";
		if(temp_return_due_date == '') temp_return_due_date = 0;
		if( eval(temp_return_due_date) < eval(document.forms[0].plan_end_date.value)){
			alert("<%=text.get("QM_002.8889")%>");//조치예정일이 회신기일보다 미래일 수 없습니다.
			document.forms[0].plan_end_date.focus();
			return false;
		}

		var temp_notice_date = "<%=temp_notice_date%>";
		if(temp_notice_date == '') temp_notice_date = 0;
		if(eval(document.forms[0].plan_end_date.value) < eval(temp_notice_date)){
			alert("<%=text.get("QM_002.8887")%>");//조치예정일이 통지일보다 작을 수 없습니다.
			document.forms[0].plan_end_date.focus();
			return false;
		}

		return true;
	}

	function doSave2()
	{
		if(! checkForm2()) return;
		if(! confirm("<%=text.get("QM_002.msg_0004")%>")) return;

		if("<%=plan_end_date%>" == "")
		{
			//조치예정일과 임시조치내역을 먼저 저장하시기 바랍니다.
			alert("<%=text.get("QM_002.first_amd")%>");
			document.forms[0].plan_end_date.focus();
			return false;
		}

		f = document.form;
		f.mode.value = 'save2';
		f.benefit_text.value = LRTrim(f.benefit_text.value);
		f.re_prevent_end_date.value = LRTrim(f.re_prevent_end_date.value);
		f.re_prevent_text.value = LRTrim(f.re_prevent_text.value);
		f.action = 'qm_notice_mgt.jsp';
		f.method = 'POST';
		f.submit();
	}

	function checkForm2()
	{
		if(getLength(document.forms[0].benefit_text.value) == 0)
		{
			alert("<%=text.get("QM_002.msg_0005")%>");
			document.forms[0].benefit_text.focus();
			return false;
		}

		if(getLength(document.forms[0].re_prevent_end_date.value) == 0)
		{
			alert("<%=text.get("QM_002.msg_0006")%>");
			document.forms[0].re_prevent_end_date.focus();
			return false;
		}

		//if(getLength(document.forms[0].re_prevent_attach_no.value) == 0)
		//{
			//alert("<%=text.get("QM_002.msg_0007")%>");
			//document.forms[0].re_prevent_end_date.focus();
			//return false;
		//}

		return true;
	}

	function doOutput()
	{
		var QM_NUMBER = document.form.qm_number.value;
		popUpOpen('jel_qm_print.jsp?qm_number='+encodeUrl(QM_NUMBER), '', '1000', '700');
	}

	function go_drawing()
	{
		var drawing_url_info = "<%=drawing_url_info%>";
		popUpOpen(drawing_url_info, "drawing_info", 400, 300);
	}
</Script>
<link rel="stylesheet" href="../../css/body.css" type="text/css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="initContent();setGridDraw();">
<form name="form" method="post" action="">
<input type="hidden" name="mode">
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
			<tr valign="top" >

				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="98%" border="1" cellspacing="0" cellpadding="0">
				<%@ include file="/include/sepoa_milestone.jsp"%>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="5" colspan="2"></td>
						</tr>
					</TABLE>
					<!-- search start-->

					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB">
						<tr>
        					<td width="20%" height="30" align="left" class="div_input"><%=text.get("QM_002.notice_code")%></td>
        					<td height="30" class="se_cell_data">
        						<input type="text" name="qm_number" class="input_empty" size="30" value="<%=qm_number %>" readonly>
        					</td>
        					<td width="20%" height="30" align="left" class="div_input"><%=text.get("QM_002.statement")%></td>
        					<td height="30" class="se_cell_data">
        						<input type="text" name="progress_status" class="input_empty" value="<%=progress_status %>" readonly>
        					</td>
						</tr>
					</table>
					<!-- search end-->

					<!-- button end-->
					<table width="100%" border="0" cellspacing="0" cellpadding="0" >
						<tr>
							<td width="100%" height="40">
								<table border="0" cellspacing="3" cellpadding="0">
								<tr>
									<td><script language="javascript">btn("javascript:doQuery()","<%=text.get("QM_002.btn_query")%>")</script></td>

									<%	if(drawing_url_info.length() > 0)
 										{ %>
 											<td><script language="javascript">btn("javascript:go_drawing()","<%=text.get("QM_002.DRAWING_URL_INFO")%>")</script></td>
									<%	} %>

									<%	if(info.getSession("USER_TYPE").equals("S"))
										{ %>
											<% if(accept_flag.trim().length() <= 0)
											   { %>
												<% if(seller_send_date.length() > 0)
												   { %>
														<td><script language="javascript">btn("javascript:doSendCancel()","<%=text.get("QM_002.btn_send_cancel")%>")</script></td>
												<% }
												   else if(progress_status_code.equals("B") && re_prevent_end_date.trim().length() > 0)
												   { %>
												   		<td><script language="javascript">btn("javascript:doSend()","<%=text.get("QM_002.btn_send")%>")</script></td>
												<% } %>
											<% } %>
									<%	}
										else
										{ %>
											<% if(accept_flag.trim().length() <= 0)
											   { %>
													<td><script language="javascript">btn("javascript:doConfirm()","<%=text.get("QM_002.btn_confirm")%>")</script></td>
													<td><script language="javascript">btn("javascript:doReject()","<%=text.get("QM_002.btn_reject")%>")</script></td>
											<% } %>
									<%	} %>


    	  							<TD><script language="javascript">btn("javascript:doOutput()" , "<%=text.get("QM_002.btn_output")%>")</script></TD>
								</tr>
								</table>
							</td>
						</tr>
					</table>
					<!-- button end-->

					<tr align="center" valign="top">
						<td height="40" colspan="6">
							<table width="98%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB">
							<tr>
								<td bgcolor="#E0E0EF" colspan="6" class="inputsubmit" height="25">
								<table><tr><td><b><%=text.get("QM_002.comman_minutia")%></b></td>
								</tr></table>
								</td>
							</tr>

						  	<tr>
						  	 	<td width="16%" class="div_input"  ><%=text.get("QM_002.cm_code")%></td>
						     	<td width="17%" class="div_data">
									<input type="text" name="seller_code" class="input_empty" value="<%=seller_code %>" readonly>
								</td>
					     		<td width="16%" class="div_input"  ><%=text.get("QM_002.cm_name")%></td>
					     		<td width="17%" class="div_data">
									<input type="text" name="seller_name_loc" class="input_empty" value="<%=seller_name_loc %>" readonly>
								</td>
							    <td width="17%" class="div_input"  ><%=text.get("QM_002.quality_master")%></td>
							    <td width="17%" class="div_data">
									<input type="text" name="qm_user_id" class="input_empty" value="<%=qm_user_id %>" readonly>
							    </td>
				   	 		</tr>
				   	  		<tr>
							  	 <td  class="div_input"  ><%=text.get("QM_002.notice_type")%></td>
							     <td  class="div_data">
							     	<input type="text" name="notice_type" class="input_empty" value="<%=notice_type %>" readonly>
								 </td>
					     		 <td  class="div_input"  ><%=text.get("QM_002.project_no")%></td>
					     		 <td  class="div_data">
									<input type="text" name="z_code1" class="input_empty" value="<%=z_code1 %>" readonly>
								 </td>
							     <td  class="div_input"  ><%=text.get("QM_002.ISSUE_NUMBER")%></td>
							     <td  class="div_data">
									<input type="text" name="issue_number" class="input_empty" value="<%=issue_number %>" readonly>
							     </td>
				   	 		</tr>
					   	 	<tr>
							  	 <td class="div_input" ><%=text.get("QM_002.notice_date")%></td>
							     <td class="div_data">
							     	<input type="text" name="notice_date" class="input_empty" value="<%=notice_date %>" readonly>
								 </td>
					     		 <td class="div_input" ><%=text.get("QM_002.write_back_term")%></td>
					     		 <td class="div_data">
					     		 	<input type="text" name="return_due_date" class="input_empty" value="<%=return_due_date %>" readonly>
								 </td>
								 <td class="div_input" ><%=text.get("QM_002.notice_sum_date")%></td>
			 					 <td class="div_data"><input type="text" name="finish_date" class="input_empty" value="<%=finish_date %>" readonly>
								 </td>
						 	</tr>
					     	<tr>
						      	<td class="div_input"  ><%=text.get("QM_002.title")%></td>
						      	<td class="div_data" colspan="5"><%=SepoaString.nToBr(subject) %>
						      		<input type="hidden" name="subject" class="input_empty" value="<%=subject %>" readonly>
						      	</td>
					     	</tr>
						 	<tr>
							  	<td  class="div_input"  ><%=text.get("QM_002.bad_minutia")%></td>
						      	<td class="div_data" colspan="5"><%=SepoaString.nToBr(bad_text) %>
									<input type="hidden" name="bad_text" class="input_empty" value="<%=bad_text %>" readonly>
						      	</td>
					     	</tr>
						 	<tr>
								<td  class="div_input"  ><%=text.get("QM_002.step_demand_minutia")%></td>
							    <td class="div_data" colspan="5"><%=SepoaString.nToBr(adjust_req_text) %>
									<input type="hidden" name="adjust_req_text" class="input_empty" value="<%=adjust_req_text %>" readonly>
							    </td>
					     	</tr>
					     	<tr>
								<td class="div_input"  ><%=text.get("QM_002.item_code")%></td>
								<td  class="div_data" align="left">
								<input type="text" name="material_number" class="input_empty" value="<%=material_number %>" readonly>
								</td>
								<td class="div_input"  ><%=text.get("QM_002.item_name")%></td>
								<td  class="div_data" colspan="3" align="left"> <%=SepoaString.nToBr(description_eng) %>
								<input type="hidden" name="description_eng" class="input_empty" value="<%=description_eng %>" readonly>
								</td>
						 	</tr>
						 	<tr>
								<td class="div_input"  ><%=text.get("QM_002.bad_qty")%></td>
								<td  class="div_data" align="left">
								<input type="text" name="bad_qty" class="input_empty" value="<%if(bad_qty.length() > 0){%><%=SepoaString.formatNumNoZero(Double.parseDouble(bad_qty), 3) + " " + unit_measure%> <%} %>" readonly>
								</td>
								<td class="div_input"  ><%=text.get("QM_002.number")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="item_qty" class="input_empty" value="<%if(item_qty.length() > 0){%><%=SepoaString.formatNumNoZero(Double.parseDouble(item_qty), 3) + " " + unit_measure%> <%} %>" readonly>
								</td>
								<td class="div_input"  ><%=text.get("QM_002.lot_size")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="lot_size" class="input_empty" value="<%if(lot_size.length() > 0){%><%=SepoaString.formatNumNoZero(Double.parseDouble(lot_size), 3)%> <%} %>" readonly>
								</td>
						 	</tr>
						<%	if(! notice_type_code.equals("F5"))
							{	%>
							 	<tr>
									<td class="div_input"  ><%=text.get("QM_002.aql_ma")%></td>
									<td  class="div_data" align="left">
										<%=aql_ma %>
									</td>
									<td class="div_input"  ><%=text.get("QM_002.aql_mi")%></td>
									<td  class="div_data" align="left">
										<%=aql_mi %>
									</td>
									<td class="div_input"  ><%=text.get("QM_002.progress_point")%></td>
									<td  class="div_data" align="left">
										<%=progress_point %>
									</td>
							 	</tr>
						<%	} %>

						 	<% if(info.getSession("USER_TYPE").equals("S") && seller_send_date.equals("") ) { %>
						     	<tr>
				 					<td  class="div_data" colspan="6">
										<table border="0" cellspacing="3" cellpadding="0">
											<tr>
												<td><script language="javascript">btn("javascript:doSave()" , "<%=text.get("QM_002.btn_save")%>")</script></td>
											</tr>
										</table>
									</td>
								</tr>
							<% } %>

			 				<tr>
						  	 	<td class="div_input_re" align="center"><%=text.get("QM_002.step_destine_date")%></td>
						     	<td  class="div_data" align="left">
									<input type="text" name="plan_end_date" size="8" value="<%=plan_end_date %>">
									<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, plan_end_date , 'yyyy/mm/dd')">
								</td>

					     	 	<td  class="div_input_re" align="center"><%=text.get("QM_002.temporary_step")%><br>(<input type="text" name="content_length3" size="3" maxlength="3" class="inputsubmit"><%=text.get("QM_002.content_num")%>)</td>
					     	 	<td  class="div_data" colspan="3">
									<textarea cols="100" rows="5"  onkeyup="length_check3(this, 1000)" name="temp_adjust_text" style="width:100%"><%=temp_adjust_text %></textarea>
							 	</td>
			 				</tr>
					<%	/* 출하검사일 경우 재작업, 재검사 정보 입력 */
						if(notice_type_code.equals("F5") && info.getSession("USER_TYPE").equals("S") && seller_send_date.equals(""))
						{ %>
							<tr>
			 					<td  class="div_data" colspan="6">
									<table border="0" cellspacing="3" cellpadding="0">
										<tr>
											<td><script language="javascript">btn("javascript:doSaveRe()" , "<%=text.get("QM_002.btn_save")%>")</script></td>
										</tr>
									</table>
								</td>
							</tr>
						 	<tr>
								<td class="div_input"  ><%=text.get("QM_002.rework_date")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="rework_date" value="<%=rework_date %>" size="8">
									<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, rework_date , 'yyyy/mm/dd')">
								</td>
								<td class="div_input"  ><%=text.get("QM_002.rework_item_qty")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="rework_item_qty" value="<%=rework_item_qty %>" class="input_right" size="10">
								</td>
								<td class="div_input"  ><%=text.get("QM_002.rework_bad_qty")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="rework_bad_qty" value="<%=rework_bad_qty %>" class="input_right" size="10">
								</td>
						 	</tr>
						 	<tr>
								<td class="div_input"  ><%=text.get("QM_002.recert_date")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="recert_date" value="<%=recert_date %>" size="8">
									<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, recert_date , 'yyyy/mm/dd')">
								</td>
								<td class="div_input"  ><%=text.get("QM_002.recert_cert_qty")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="recert_cert_qty" value="<%=recert_cert_qty %>" class="input_right" size="10">
								</td>
								<td class="div_input"  ><%=text.get("QM_002.recert_bad_qty")%></td>
								<td  class="div_data" align="left">
									<input type="text" name="recert_bad_qty" value="<%=recert_bad_qty %>" class="input_right" size="10">
								</td>
						 	</tr>
					<%	}
						else
						{	%>
							<inpyt type="hidden" name="rework_date">
							<inpyt type="hidden" name="rework_item_qty">
							<inpyt type="hidden" name="rework_bad_qty">
							<inpyt type="hidden" name="recert_date">
							<inpyt type="hidden" name="recert_cert_qty">
							<inpyt type="hidden" name="recert_bad_qty">
					<%	} %>

		  					</table>
		  				</td>
		  			</tr>
			  		<tr align="center">
						<td height="40" colspan="2">
	  						<table width="98%" border="0" cellpadding="0" cellspacing="0">
	  							<tr>
									<td height="6" colspan="2"></td>
								</tr>
								<tr>
									<td bgcolor="#E0E0EF" class="inputsubmit" height="25">
										<b><%=text.get("QM_002.bad")%></b>
									</td>
								</tr>
			    				<tr>
			      					<td>
			        					<div id="gridbox" name="gridbox" height="150" width="100%" style="background-color:white;"></div>
              							<div id="pagingArea"></div>
			      					</td>
			    				</tr>
			  				</table>
			  			</td>
			  		</tr>
					<tr>
						<td height="10" colspan="2"></td>
					</tr>

		  			<tr align="center" valign="top">
						<td height="40" colspan="6">
							<table width="98%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB">
							<% if(info.getSession("USER_TYPE").equals("S") && seller_send_date.equals("") ) { %>
								<tr>
									<td bgcolor="#E0E0EF" colspan="6" class="inputsubmit" height="25">
									<table><tr><td></td>
											<td><script language="javascript">btn("javascript:doSave2()" , "<%=text.get("QM_002.btn_save")%>")</script></td>
									</tr></table>
									</td>
								</tr>
							<%} %>

							<tr>
				  				<td  class="div_input_re" align="center">
				  				<%=text.get("QM_002.effect")%>
				  				<br>(<input type="text" name="content_length" size="3" maxlength="3" class="inputsubmit"><%=text.get("QM_002.content_num")%>)
				  				</td>
			      				<td class="div_data" colspan="5">
									<textarea cols="100" rows="5"  name="benefit_text" style="width:100%" onkeyup="length_check(this, 1000)"><%=benefit_text %></textarea>
			      				</td>
		    				</tr>
		    				<tr>
				  				<td  class="div_input_re" align="center">
				  				<%=text.get("QM_002.end_date")%>
				  				</td>
			      				<td class="div_data">
									<input type="text" name="re_prevent_end_date" value="<%=re_prevent_end_date %>" class="inputsubmit" size="8">
									<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, re_prevent_end_date , 'yyyy/mm/dd')"></td>
			      				</td>
				  				<td  class="div_input"  >
				  				<%=text.get("QM_002.annex")%>
				  				</td>
			      				<td class="div_data" colspan=3>
									<input type="hidden" name="FILE_NAME">
									<input type="hidden" name="re_prevent_attach_no" value="<%=re_prevent_attach_no %>">
									<%if(info.getSession("USER_TYPE").equals("S") && (finish_date.equals(""))){ %>
									<a href="javascript:attach_file(document.forms[0].re_prevent_attach_no.value,'QM');"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
									<%}else{ %>
									<a href="javascript:FileAttach('QM',document.forms[0].re_prevent_attach_no.value,'VI');"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
									<%} %>
									&nbsp;<input type="text" readonly value="<%=re_prevent_attach_no_count %>" name="re_prevent_attach_no_count" size="3" class="input_empty" maxlength="20"><%=text.get("QM_002.files")%>
									<input type="hidden" name="re_prevent_text">
			      				</td>
		    				</tr>
					<%-- 재발방지대책 삭제 2009.04.28 이대규
							<tr>
								<td width="16%" class="div_input_re" align="center" rowspan="2">
								<%=text.get("QM_002.relapse_prevent")%>
								<br>(<input type="text" name="content_length2" size="3" maxlength="3" class="inputsubmit"><%=text.get("QM_002.content_num")%>)
								</td>
								<td width="17%" class="div_input"  ><%=text.get("QM_002.end_date")%></td>
								<td width="17%" class="div_data" align="left">
									<input type="text" name="re_prevent_end_date" value="<%=re_prevent_end_date %>" class="inputsubmit" size="8">
									<img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, re_prevent_end_date , 'yyyy/mm/dd')"></td>
								<td width="17%" class="div_input"  ><%=text.get("QM_002.annex")%></td>
								<td  width="33%" class="div_data" align="left" colspan="2">
								<!--	<a href="javascript:Code_Search();"><img src="../images/button/query.gif"  align="absmiddle" border="0"></a>	-->
									<table cellpadding="0">
										<tr>
											<td>
												<input type="hidden" name="FILE_NAME">
												<input type="hidden" name="re_prevent_attach_no" value="<%=re_prevent_attach_no %>">
												<%if(info.getSession("USER_TYPE").equals("S") && (finish_date.equals(""))){ %>
												<a href="javascript:attach_file(document.forms[0].re_prevent_attach_no.value,'QM');"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
												<%}else{ %>
												<a href="javascript:FileAttach('QM',document.forms[0].re_prevent_attach_no.value,'VI');"><img src="../images/button/query.gif" align="absmiddle" border="0"></a>
												<%} %>
												</td>
											<td>&nbsp;<input type="text" readonly value="<%=re_prevent_attach_no_count %>" name="re_prevent_attach_no_count" size="3" class="input_empty" maxlength="20"><%=text.get("QM_002.files")%></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td class="div_data" colspan="5" >
									<textarea cols="100" rows="4"  name="re_prevent_text" style="width:100%" onkeyup="length_check2(this, 1000)"><%=re_prevent_text %></textarea>
								</td>
							</tr>
					--%>
							</table>
						</td>
					</tr>

				<%@ include file="/include/include_bottom.jsp"%>

			</table>
			</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</form>
<% if(screen_message.length() > 0) { %>
	<script>
		alert("<%=screen_message%>");
	</script>
<% } %>

</body>
</html>
