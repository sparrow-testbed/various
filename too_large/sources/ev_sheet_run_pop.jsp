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
	String eval_id   	    = JSPUtil.nullToEmpty(request.getParameter("eval_id"));
	
	
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
<title>우리은행 전자구매시스템</title>
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
    		
    		var TYPE       = "EV";
    		var attach_key = SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_TXT"); 
			var view_type  = "";

// 			attach_file(attach_key, 'EV');
			
    		win = window.open("<%=POASRM_CONTEXT_NAME%>/sepoafw/filelob/file_attach.jsp?rowId="+rowId+"&type="+TYPE+"&attach_key="+attach_key+"&view_type="+view_type,"fileattach",'left=' + w_left + ',top=' + w_top + ', width=620, height=400,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');
    		
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
			if( dhtmlx_last_row_id > 4 ){
				var name = GridObj.cells( 5 , GridObj.getColIndexById("EV_M_ITEM") ).getValue();
	
				if( name == "기술평가" ){
					realScore = GridObj.cells( 5 , GridObj.getColIndexById("SCORE") ).getValue();
				}
			}
		}
		else if( stage == 2 ){
			if( GridObj.cells(rowId, GridObj.getColIndexById("EV_TYPE")).getValue() == '정량'  ){
				if( GridObj.cells(rowId, GridObj.getColIndexById("ITEM_CHECK_CK")).getValue() != '' ){
					GridObj.cells(rowId, GridObj.getColIndexById("selected")).setValue("0");
					alert("실적에만 입력이 가능합니다.");
					return;
				}
				if(GridObj.getColumnId(cellInd) == "REAL_SCORE"){
					if(!IsNumber2(LRTrim(GridObj.cells(rowId, cellInd).getValue()))){
						alert("숫자만 입력 가능합니다.");
						return;
					}
				}	
	
			}else if( GridObj.cells(rowId, GridObj.getColIndexById("EV_TYPE")).getValue() == '정성' ){
				if( GridObj.cells(rowId, GridObj.getColIndexById("REAL_SCORE")).getValue() != '0' && GridObj.cells(rowId, GridObj.getColIndexById("REAL_SCORE")).getValue() != '' ){
					GridObj.cells(rowId, GridObj.getColIndexById("selected")).setValue("0");
					alert("실적1에만 입력이 가능합니다.");
					return;
				}
				//16 = 실적비고
				if(cellInd != '16' && cellInd != '19'){
					var checkSEQ = GridObj.cells(rowId, GridObj.getColIndexById("EV_SEQ")).getValue();
					
					for( var i = 1; i <= dhtmlx_last_row_id; i++ ){
						if( checkSEQ == GridObj.cells(i, GridObj.getColIndexById("EV_SEQ")).getValue() ){
							if( i != rowId ){
								GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK")).setValue("0");
								GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).setValue("0");
							}
						}
					}					
				}
				
				if(GridObj.getColumnId(cellInd) == "SCORE"){
					if(!IsNumber2(LRTrim(GridObj.cells(rowId, cellInd).getValue()))){
						alert("숫자만 입력 가능합니다.");
						return;
					}
				}					
			}
			
			// 점수 (score)
			if( cellInd == '19' ){
				if( totalScore == 0 ){
				    totalScore = GridObj.cells( dhtmlx_last_row_id, GridObj.getColIndexById("SCORE") ).getValue();
				    totalScore = parseFloat( totalScore ) - parseFloat( realScore );
				}
				var score      = GridObj.cells( 5 , GridObj.getColIndexById("SCORE") ).getValue();
				GridObj.cells( dhtmlx_last_row_id, GridObj.getColIndexById("SCORE") ).setValue( parseFloat(totalScore) + parseFloat(score) )
				for( var i = 5; i < 10; i++ ){
					if( GridObj.cells( i, GridObj.getColIndexById("ITEM_CHECK") ).getValue() == '1' ){
						GridObj.cells( i, GridObj.getColIndexById("EV_POINT_REL") ).setValue( parseFloat(score) );
						break;
					}
				}
				document.form.score_total.value = parseFloat(totalScore) + parseFloat(score);
			}
			else{
				cal_flag = false;	
			}
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
	
	function doInsert(){

		if(!cal_flag){
		alert("점수계산을 먼저 하신후에 평가결과등록을 할 수 있습니다.");
			return;
		}

		<%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum()-1; row++)// 가장 마지막줄이 합계라서 제외하고 처리한다.
		{
			//<%=grid_obj%>.cells(row, cInd).setValue("1");
			//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
			<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		}
		
		var grid_array = getGridChangedRows(GridObj, "selected");	
		
		var f = document.forms[0];
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
		var seller_code = "<%=seller_code%>";
		var sg_regitem	= "<%=sg_regitem%>";
		var item_score_total = f.item_score_total.value;  // 업체배점합계
		var score_total	= f.score_total.value;  // 점수합계
		var eval_id     = "<%=eval_id%>";
		
		var param = "";
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
		param += "&seller_code="+seller_code;
		param += "&sg_regitem="+sg_regitem;
		param += "&item_score_total="+item_score_total;
		param += "&score_total="+score_total;
		param += "&eval_id="+eval_id;
		
	    if (confirm("평가결과등록을 하시겠습니까?")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_run?cols_ids="+cols_ids+"&mode=insert"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }else{
        	<%=grid_obj%>.setCheckedRows(0, "false");
        }
	}
	
	function doScore_Cal(){
		GridObj.enableSmartRendering(true);
		var tempEV_SEQ    = "";

		for( var i = 1; i <= dhtmlx_last_row_id-1; i++ ){ // 가장 마지막줄이 합계라서 제외하고 처리한다.
			GridObj.selectRowById(i, false, true);
			GridObj.cells(i, GridObj.getColIndexById("selected")).cell.wasChanged = true;
			
			if( GridObj.cells(i, GridObj.getColIndexById("EV_TYPE")).getValue() == '정량' ){
				var EV_SEQ  = GridObj.cells(i, GridObj.getColIndexById("EV_SEQ")).getValue();
				
				if( tempEV_SEQ != EV_SEQ ){
					GridObj.cells(i, GridObj.getColIndexById("selected")).setValue("1");
					tempEV_SEQ = EV_SEQ;
				}
			}
			else{
				var EV_REQSEQ = GridObj.cells(i, GridObj.getColIndexById("EV_REQSEQ")).getValue();
				var numVal    = 0; 
				for( var j = 1; j <= dhtmlx_last_row_id-1; j++ ){
					if( numVal > 1 ){
						var EV_D_ITEM = GridObj.cells(i, GridObj.getColIndexById("EV_D_ITEM")).getValue();
						alert( EV_D_ITEM + "의 실적(정성)에 1개이상 평가요소가 체크 되어 있습니다." );
						return;
					}
					var tempEV_REQSEQ = GridObj.cells(j, GridObj.getColIndexById("EV_REQSEQ")).getValue();
					var checkVal      = GridObj.cells(j, GridObj.getColIndexById("ITEM_CHECK_CK")).getValue();
					
					if( EV_REQSEQ == tempEV_REQSEQ && checkVal == 1 ){
						numVal++;
					}
				}
				
				GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK")).setValue(GridObj.cells(i, GridObj.getColIndexById("ITEM_CHECK_CK")).getValue());
				GridObj.cells(i, GridObj.getColIndexById("selected")).setValue("1");
			}
		}
		
		var grid_array = getGridChangedRows(GridObj, "selected");		
		
		var f = document.forms[0];
		
	    var ev_no		= f.ev_no.value;  
		var ev_year 	= f.ev_year.value;
		var seller_code = "<%=seller_code%>";
		var eval_id     = "<%=eval_id%>";
		var param = "";
		param += "&ev_no="       + ev_no;
		param += "&ev_year="     + ev_year;
		param += "&seller_code=" + seller_code;
		param += "&eval_id="     + eval_id;
		
	    if (confirm("점수계산 하시겠습니까?")) {
	        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_run?cols_ids="+cols_ids+"&mode=doScore_Cal"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
        GridObj.enableSmartRendering(false);
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
				 	GridObj.cells(i, GridObj.getColIndexById("REAL_SCORE")).setBgColor("#ffff63");
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
    	doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M221' ,'sheet_status', '<%=sheet_status%>' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M216' ,'sheet_kind', '<%=sg_kind%>' );
	}
	
    function setAttach(attach_key, arrAttrach, rowId, attach_count){
		
	    var attachfilename  = arrAttrach + "";
	    var result 			="";
	
		var attach_info 	= attachfilename.split(",");
		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var src_file_name 	= attach_info[3+(i*7)];
			var file_size 		= attach_info[4+(i*7)];
			var add_user_id 	= attach_info[5+(i*7)];
	
			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}
		
		if(attach_count == 0){
			GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_IMG")).setValue("/poasrm/images/icon/icon_disk_a.gif");
		}else{
			GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_IMG")).setValue("/poasrm/images/icon/icon_disk_b.gif");
		}
		
		GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_TXT")).setValue(attach_key);
    }
	
	function reload(){
		opener.doQuery();
	}
	
	function IsNumber2(num){
		var i;
		pcnt = 0;
		var tcnt = 0;

		for(i=0;i<num.length;i++){
			if (num.charAt(0) == '.'){
				return false;
			}
			if (num.charAt(i) == '.'){
				pcnt ++;
			}
			if(num.charAt(0) == '-'){
				if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1) && i > 0){
					return false;
				}
			}else{
				if((num.charAt(i) < '0' || num.charAt(i) > '9') && (num.charAt(i) != '.' ||  pcnt>1)){
					return false;
				}
			}
		}
		return true;
	}	
	
	
	function grid_rowspan(col_num,col_name){
	    var cnt = 0;
	    var temp1 = "";
	    var temp2 = "";
	    var col_num_cnt = col_num.split(",");
	    var col_name_cnt = col_name.split(",");
	    
	    for(var i = 1; i < dhtmlx_last_row_id+1; i++){
			cnt = 0;
			temp1 = "";

			for( var k = 0 ; k < col_name_cnt.length ; k++){
				temp1 += LRTrim(GridObj.cells(i, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
			}

			//해당 필드의 똑같은 데이타를 가지고 있는 로우의 갯수를 셈.
			for(var j = i; j < dhtmlx_last_row_id+1; j++){
				temp2 = "";
				
				for( var k = 0 ; k < col_name_cnt.length ; k++){
					temp2 += LRTrim(GridObj.cells(j, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
				}

				if(temp1 == temp2){
					cnt = cnt + 1;
					
					if(temp1 == "" && temp2 == ""){
						cnt = 1;
					}
				}
				//alert("["+temp1 + "=" + temp2 + "] : " + cnt);
			}

			//그 row수만 큼 span. 
			for(var m = 0; m<col_num_cnt.length; m++){
				for(var n = Number(col_num_cnt[m].split("-")[0]); n <= Number(col_num_cnt[m].split("-")[1]); n++){
					
					GridObj.setRowspan(i,n,cnt);// 줄 / 칸 / 갯수
				} 
			}

			i = i + cnt - 1;
	    }
	}		
	    
</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="initAjax();setGridDraw();" onunload="reload();">
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
					<input type="text" id="vendor_code" name="vendor_code"  size="40" maxlength="40" class="input_empty" value="<%=seller_code %>" readonly="readonly">
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
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						<td >
							<script language="javascript">btn("doInsert()", "평가결과등록")</script>
						</td>
						<td >
							<script language="javascript">btn("window.close()", "닫기")</script>
						</td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>
		   	<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="15%" height="24" class="se_cell_title">
					배점합계
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="basic_total" name="basic_total"  size="15" maxlength="15" class="input_empty" value="100" readonly="readonly">
				 </td>
				<td width="15%" height="24" class="se_cell_title">
					점수합계
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="score_total" name="score_total" value="" size="15" maxlength="15" class="input_empty" readonly="readonly"/>
				</td>
				<td width="10%" height="24" class="se_cell_data">
					<script language="javascript">btn("doScore_Cal()", "점수계산")</script>
				</td>
			</tr>
					<input type="hidden" id="item_score_total" name="item_score_total" value="" size="15" maxlength="15" class="input_empty" readonly="readonly"/> <!-- 업체배점합계  -->
		    																	
			</table>
		</td>
	</tr>
</table>
</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<%-- <s:grid screen_id="WO_009" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>
