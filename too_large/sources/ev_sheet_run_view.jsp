<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa" %>

<%
    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);

	String language         = info.getSession("LANGUAGE");
	String ev_no 		    = JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		    = JSPUtil.nullToEmpty(request.getParameter("ev_year"));
	String seller_code 		= JSPUtil.nullToEmpty(request.getParameter("seller_code"));
	String seller_name_loc 	= JSPUtil.nullToEmpty(request.getParameter("seller_name_loc"));
	String sg_regitem 		= JSPUtil.nullToEmpty(request.getParameter("sg_regitem"));
	String ev_date 		    = JSPUtil.nullToEmpty(request.getParameter("ev_date"));
	String reg_date_2	    = JSPUtil.nullToEmpty(request.getParameter("reg_date_2"));
	String eval_id	        = JSPUtil.nullToEmpty(request.getParameter("eval_id"));
	
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_009";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = true;
	
	dhtmlx_head_merge_cols_vec.addElement("ITEM_CHECK_CK=입력사항");
	dhtmlx_head_merge_cols_vec.addElement("REAL_SCORE=#cspan");
	dhtmlx_head_merge_cols_vec.addElement("ITEM_REMARK=#cspan");
	
	String sg_kind     	= "";
	String sheet_status	= "";
	String subject     	= "";
	
			 
	    Object[] obj = {ev_no,ev_year};
	    SepoaOut value = ServiceConnector.doService(info, "WO_024", "CONNECTION","getEvaluation_header", obj);
	    
	    
	    SepoaFormater wf = null;
	
		wf = new SepoaFormater(value.result[0]);
    
	
		 int iRowCount = wf.getRowCount(); 
		    
		    if(iRowCount>0)
		    {
				sg_kind               = wf.getValue("SG_KIND",0);
				sheet_status          = wf.getValue("SHEET_STATUS",0);
				ev_year               = wf.getValue("EV_YEAR",0);
				subject               = wf.getValue("SUBJECT",0);
			}
	 
	
	
	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;
	var cal_flag		= false;
	var totalScore      = 0;
	var realScore       = 0;
	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
		<%if(iRowCount>0){%>
		doQuery();
		<%}%>
	}
	
	function doOnRowSelected(rowId,cellInd)
	{
		if(GridObj.getColIndexById("ATTACH_IMG") == cellInd && rowId != dhtmlx_last_row_id)
    	{
    		var w_dim  = new Array(2);
			    w_dim  = ToCenter(400, 640);
			var w_top  = w_dim[0];
			var w_left = w_dim[1];
    		
    		var TYPE       = "NOT";
    		var attach_key = SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_TXT"); 
			var view_type  = "VI";

    		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/file/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=200,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
    		
    		//FileAttach(rowId, SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_TXT") );
    	}
	}
	
	function doOnCellChange(stage,rowId,cellInd)
	{
		var max_value = GridObj.cells(rowId, cellInd).getValue();
	   	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	   	if( stage == 0 ){
			return true;
		} 
		else if( stage == 1 ){
		}
		else if( stage == 2 ){
		    return true;
		}
		return false;
	}
	
	//그리드의 선택된 행의 존재 여부를 리턴
	function checkRows(){
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		if(grid_array.length > 0)	return true;
		
		alert("평가항목을 등록하신후에 등록 할 수 있습니다.");
		return false;
	}
	
	//조회
	function doQuery(){
	
		var grid_col_id = "<%=grid_col_id%>";
		var f = document.forms[0];
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
		var seller_code = "<%=seller_code%>";
		var sg_regitem	= "<%=sg_regitem%>";
		var ev_date	    = "<%=ev_date%>";
		var reg_date_2  = "<%=reg_date_2%>";
		var eval_id     = "<%=eval_id%>";
		var param = "";
		
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
		param += "&seller_code="+seller_code;
		param += "&sg_regitem="+sg_regitem;
		param += "&ev_date="+ev_date;
		param += "&reg_date_2="+reg_date_2;
		param += "&eval_id="+eval_id;
		
		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_run?mode=query_pop&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);

	}

	//조회후 뒷처리
    function doQueryEnd(GridObj, RowCnt){
		var msg    = GridObj.getUserData("", "message");
		var status = GridObj.getUserData("", "status");
		var basic_total = GridObj.getUserData("", "basic_total");
		var item_score_total = GridObj.getUserData("", "item_score_total");
		var score_total = GridObj.getUserData("", "score_total");

		if(status == "false")	alert(msg);
		
		//document.forms[0].basic_total.value = basic_total;
		document.forms[0].item_score_total.value = item_score_total;
		document.forms[0].score_total.value = score_total;
		
		for( var i = 1; i <= dhtmlx_last_row_id; i++ ){
			if(i != dhtmlx_last_row_id){
				if(!cal_flag){
					//alert("점수계산을 먼저 하신후에 평가결과등록을 할 수 있습니다.");
					//return;
				}			
			
				if( GridObj.cells(i, GridObj.getColIndexById("EV_TYPE")).getValue() == '정량'  ){
				 	GridObj.setCellExcellType(i, GridObj.getColIndexById("ITEM_CHECK_CK"), "ro");
				 	GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).setValue("");
				 	
				}else if(GridObj.cells(i, GridObj.getColIndexById("EV_TYPE")).getValue() == '정성'){
					GridObj.setCellExcellType(i, GridObj.getColIndexById("REAL_SCORE"), "ro");
				 	GridObj.cells(i, GridObj.getColIndexById("REAL_SCORE")).setValue("");
				 	if( i == 5 ){
						if ( GridObj.cells(i, GridObj.getColIndexById("EV_M_ITEM")).getValue() == "기술평가" ){
							if(cal_flag){
						 		GridObj.setCellExcellType(i, GridObj.getColIndexById("SCORE"), "ed");
								GridObj.cells(i, GridObj.getColIndexById("SCORE")).setBgColor("#ffff63");						 		
							}
						}
				 	}
				}
			
				if(GridObj.cells(i, GridObj.getColIndexById("AUTO_CAL")).getValue() == 'Y'){
				GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).setDisabled(true);
				GridObj.cells(i, GridObj.getColIndexById("REAL_SCORE")).setDisabled(true);
				}
			}else{  // 가장 마지막줄이 합계라서 제외하고 처리한다.
				GridObj.setCellExcellType(i, GridObj.getColIndexById("ITEM_CHECK_CK"), "ro");
				GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).setValue("");
				GridObj.setCellExcellType(i, GridObj.getColIndexById("ATTACH_IMG"), "ro");
				GridObj.cells(i, GridObj.getColIndexById("ATTACH_IMG")).setValue("");
				GridObj.setRowColor(i, "#ceeeff");
				GridObj.cells(i, GridObj.getColIndexById("ITEM_POINT_SCORE")).setValue("점수합계");
				GridObj.cells(i, GridObj.getColIndexById("SCORE")).setValue(score_total);
				GridObj.cells(i, GridObj.getColIndexById("ITEM_REMARK")).setDisabled(true);
				GridObj.cells(i, GridObj.getColIndexById("REAL_SCORE")).setDisabled(true);
				
			}
			GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("REAL_SCORE")).setDisabled(true);
			GridObj.cells(i, GridObj.getColIndexById("ITEM_REMARK")).setDisabled(true);			
		}
		return true;
    }
    			
	
	//저장후 뒷처리
	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;
		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}
		
		if(status == "true"){	
			alert(messsage);
			doQuery();
			if(mode == "doScore_Cal"){
				cal_flag = true;
			}
		}else{
			alert(messsage);
		}

		return false;
	}

	//삭제
	function doDelete(){

	}

	//행삽입
	function doAddRow(){

	}
    
    //행삭제
    function doDeleteRow(){

    }
    
    //닫기
    function doClose(){
    
    }
    
    //선택
    function doSelect(){
    
    }
    
    function initAjax(){
<%-- 		doRequestUsingPOST( 'SL0018', 'M220' ,'sheet_status', '<%=sheet_status%>' ); --%>
<%-- 		doRequestUsingPOST( 'SL0018', 'M216' ,'sheet_kind', '<%=sg_kind%>' ); --%>

		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M221' ,'sheet_status', '<%=sheet_status%>' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M216' ,'sheet_kind', '<%=sg_kind%>' );
	}

</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="initAjax();setGridDraw();">
<s:header popup="true">
<form id="form" name="form" method="post" action="">
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "평가실행";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
    </tr>
    <tr>
    	<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="20%" height="24" class="se_cell_title">
					업체코드
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="vendor_code" name="vendor_code" size="40" maxlength="40" class="input_empty" value="<%=seller_code %>" readonly="readonly">
				 </td>
				<td width="20%" height="24" class="se_cell_title">
					업체명
				</td>
				<td width="30%" height="24" class="se_cell_data"><%=seller_name_loc%></td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="se_cell_title">
					심사표번호
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="ev_no" name="ev_no" value="<%=ev_no %>" size="40" maxlength="40" class="input_empty" readonly="readonly"/>
				</td>
				<td width="20%" height="24" class="se_cell_title">
					심사표제목
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="subject" name="subject" value="<%=subject%>" size="60" maxlength="60" class="input_empty" readonly="readonly"/>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="se_cell_title">
					평가년도
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="ev_year" name="ev_year" value="<%=ev_year %>" size="15" maxlength="15" class="input_empty" readonly="readonly"/>
				</td>
				<td width="20%" height="24" class="se_cell_title">
					평가그룹
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<select id="sheet_kind" name="sheet_kind" class="inputsubmit" disabled>
					</select>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="se_cell_title">
					진행상태
				</td>
				<td width="30%" height="24" class="se_cell_data" colspan="3">
					<select id="sheet_status" name="sheet_status" class="inputsubmit" disabled>
					</select>					
				</td>
			</tr>
		    																	
			</table>
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td height="30"></td>
		   	</tr>
		   	</table>
		   	<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="20%" height="24" class="se_cell_title">
					배점합계
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="basic_total" name="basic_total"  size="15" maxlength="15" class="input_empty" value="100" readonly="readonly">
				 </td>
				<td width="20%" height="24" class="se_cell_title">
					점수합계
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="score_total" name="score_total" value="" size="15" maxlength="15" class="input_empty" readonly="readonly"/>
				</td>
			</tr>
					<input type="hidden" id="item_score_total" name="item_score_total" value="" size="15" maxlength="15" class="input_empty" readonly="readonly"/> <!-- 업체배점합계  -->
		    																	
			</table>
<!--             <div id="pagingArea"></div> -->
<%--             <%@ include file="/include/include_bottom.jsp"%> --%>
		</td>
	</tr>
</table>
</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp" > --%>
<%-- <jsp:param name="grid_object_name_height" value="gridbox=200"/> --%>
<%-- </jsp:include> --%>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>
</html>
