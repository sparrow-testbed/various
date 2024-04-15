<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;

	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_017");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.nullToEmpty(request.getParameter("ev_year"));
	String flag 		= JSPUtil.nullToEmpty(request.getParameter("flag"));
	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_017";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = true;
	
	
	String sheet_kind  	= "";
	String sg_kind     	= "";
	String period      	= "";
	String use_flag    	= "";
	String sheet_status	= "";
	String accept_value	= "";
	String st_date     	= "";
	String end_date    	= "";
	String subject     	= "";
	String dis_view		= "";	
	
		dis_view = "disabled"; 
		
			 
	    Object[] obj = {ev_no,ev_year};
	    SepoaOut value = ServiceConnector.doService(info, "WO_001", "CONNECTION","getSEVGL_header", obj);
	    
	    
	    SepoaFormater wf = null;
	
		wf = new SepoaFormater(value.result[0]);
    
	
		 int iRowCount = wf.getRowCount(); 
		    
		    if(iRowCount>0)
		    {
				sheet_kind            = wf.getValue("SHEET_KIND",0);
				sg_kind               = wf.getValue("SG_KIND",0);
				period                = wf.getValue("PERIOD",0);
				use_flag              = wf.getValue("USE_FLAG",0).equals("Y")?"checked":"";
				sheet_status          = wf.getValue("SHEET_STATUS",0);
				accept_value          = wf.getValue("ACCEPT_VALUE",0);
				ev_year               = wf.getValue("EV_YEAR",0);
				st_date               = wf.getValue("ST_DATE",0);
				end_date              = wf.getValue("END_DATE",0);
				subject               = wf.getValue("SUBJECT",0);
			}
	 
	
	
	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;

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
		//alert("doOnRowSelected");
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
		
		var param = "";
		
		param += "&ev_no="+ev_no;
		param += "&ev_year="+ev_year;
	
		

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_insert2?mode=query&grid_col_id="+grid_col_id+ param);
		GridObj.clearAll(false);

	}
	
	//조회후 뒷처리
    function doQueryEnd(GridObj, RowCnt){
		var msg    = GridObj.getUserData("", "message");
		var status = GridObj.getUserData("", "status");

		grid_rowspan("1-3,6-6", "EV_M_ITEM,EV_D_ITEM");

		if(status == "false")	alert(msg);

		return true;
    }
    			
	//저장
	function doInsert(){
		
		<%=grid_obj%>.setCheckedRows(0, "true");
   		for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
			{
				//<%=grid_obj%>.cells(row, cInd).setValue("1");
				//<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), cInd).setValue("1");
				<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("selected")).cell.wasChanged = true;
		    }
		if(!checkRows())return;
		var f = document.forms[0];
		var ev_no = f.ev_no.value;
		var ev_year = f.ev_year.value;
		var sheet_status = f.sheet_status.value;
		if(sheet_status != "W" && sheet_status != "R"){
			alert("진행상태가 작성/등록 일때만 등록 가능합니다. \n 심사표일반사항을 저장하십시오.");
			return;
		}
		
		var param= "";
		param += "&ev_no=" + ev_no;
		param += "&ev_year="+ev_year;
		
		var grid_array = getGridChangedRows(GridObj, "selected");
		var grid_col_id = "<%=grid_col_id%>";
		
		 if (confirm("<%=text.get("MESSAGE.1018")%>")) {
	     	// dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
	        // encodeUrl() 함수를 사용 하셔야 합니다.
	    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
		    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
            var cols_ids = "<%=grid_col_id%>";
		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_insert2?cols_ids="+cols_ids+"&mode=insert"+param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected", grid_array);
        }
		
		
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
		
		if(status == "true")	
			alert(messsage);
		else{
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
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M216' ,'sheet_kind', '<%=sheet_kind%>' );
		doRequestUsingPOST( 'SL0018', '<%=info.getSession("HOUSE_CODE")%>#M218' ,'period', '<%=period%>' );
<%-- 		doRequestUsingPOST( 'SL0116', '1#<%=info.getSession("HOUSE_CODE")%>' ,'sg_kind', '<%=sg_kind%>' ); --%>
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '<%=sg_kind%>' );
	}
	
	function sg_pop(){
		var url = "ev_sheet_insert2_sg_pop.jsp";
		var left = (screen.width/2)  - 860/2;
	    var top  = (screen.height/2) - 600/2-50;
		document.forms[0].method = "POST";
		document.forms[0].action = url;
		var doc = window.open( url, 'sg_pop', "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=860,height=230,top="+top+",left="+left);
		document.forms[0].target = "sg_pop";
		document.forms[0].submit();
		doc.focus();
		
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
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="initAjax();setGridDraw();">
<s:header popup="true">
<form id="form" name="form" method="post" action="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
		<input type="hidden" id="ev_year_p" name="ev_year_p"  size="15" readonly="readonly" class="input_empty" value="<%=ev_year%>" >
    </tr>
    <tr>
    	<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.sheet_num")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="ev_no" name="ev_no"  size="15" maxlength="15" class="input_empty" value="<%=ev_no %>" readonly="readonly">
				 </td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.s_group")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="button" value="연결업체 소싱그룹팝업" class="input_btn" onclick="sg_pop();"/>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.kind")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<select id="sheet_kind" name="sheet_kind" class="inputsubmit" <%=dis_view%>>
					</select>	
				</td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.v_group")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<select id="sg_kind" name="sg_kind" class="inputsubmit" <%=dis_view%>>
					</select>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.time")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<select id="period" name="period" class="inputsubmit" <%=dis_view%>>
					</select>
				</td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.apply_yn")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="checkbox" id="use_flag" name="use_flag" class="inputsubmit"  <%=use_flag %> <%=dis_view%>>
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.status")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<select id="sheet_status" name="sheet_status" class="inputsubmit" <%=dis_view%>>
					</select>					
				</td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.conf_score")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="accept_value" name="accept_value"  size="15" maxlength="15" class="input_empty" value="<%=accept_value %>" >
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.year")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="ev_year" name="ev_year"  size="15" maxlength="15" class="input_empty" value="<%=ev_year %>" >
				</td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.exi_shheet_num")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="aaaaa" name="aaaaa"  size="15" maxlength="15" class="input_empty" value="" >
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.start_date")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="st_date" name="st_date"  size="15" maxlength="15" class="input_empty" value="<%=SepoaString.getDateSlashFormat(st_date) %>" >
				</td>
				<td width="20%" height="24" class="div_input"><%=text.get("WO_017.ends_date")%></td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" id="end_date" name="end_date"  size="15" maxlength="15" class="input_empty" value="<%=SepoaString.getDateSlashFormat(end_date) %>" >
				</td>
			</tr>
		    <tr>
        		<td width="20%" height="24" class="div_input"><%=text.get("WO_017.title")%></td>
				<td height="24" class="se_cell_data" colspan="3">
					<input type="text" id="subject" name="subject" style="width:500px;" class="input_empty" value="<%=subject %>" >
				</td>
			</tr>																		
			</table>
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						<td >
				    	<%if(!"I".equals(flag)){ %>
							<script language="javascript">btn("doInsert()", "심사표등록완료")</script>
						<%} %>
						</td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>
<!--             <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div> -->
<!--             <div id="pagingArea"></div> -->
<%--             <%@ include file="/include/include_bottom.jsp"%> --%>
		</td>
	</tr>
</table>
</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp" > --%>
<%-- <jsp:param name="grid_object_name_height" value="gridbox=250"/> --%>
<%-- </jsp:include> --%>
</s:header>
<s:grid screen_id="WO_017" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
