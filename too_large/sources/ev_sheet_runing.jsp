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
	multilang_id.addElement("WO_029");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_029";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;
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
	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_runing";
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;

	function initAjax(){
		doRequestUsingPOST( 'W001', '1' ,'sg_kind', '' );
		doRequestUsingPOST( 'WO100', '' ,'p_year', '' );
	}
	
	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
	}
	
	function doOnRowSelected(rowId,cellInd)
	{
		
		var header_name = GridObj.getColumnId(cellInd);
		
		if( header_name == "vendor_name_loc" ) {//업체상세
			
		    var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "seller_code");
		    
		    if(vendor_code != null && vendor_code != "") {
		    
		      var url    = '/s_kr/admin/info/ven_bd_con.jsp';
		      var title  = '업체상세조회';
		      var param  = 'popup=Y';
		      param     += '&mode=irs_no';
		      param     += '&vendor_code=' + vendor_code;
		      popUpOpen01(url, title, '900', '700', param);
		    
		    }
				
		}
		
    	if(GridObj.getColumnId(cellInd) == "ev_no"){
    		var ev_no = GridObj.cells(rowId, cellInd).getValue();
    		var ev_year = GridObj.cells(rowId, GridObj.getColIndexById("EV_YEAR")).getValue();
   			var url = "/kr/ev/ev_sheet_view.jsp?ev_no="+ev_no+"&ev_year="+ev_year+"&flag=I" ;
		    var left = 50;
		    var top = 100;
		    var width = 900;
		    var height = 600;
		    var toolbar = 'no';
		    var menubar = 'no';
		    var status = 'yes';
		    var scrollbars = 'no';
		    var resizable = 'no';
		    var doc = window.open( url, 'ev_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		    doc.focus();
    	}
    	
    	if(GridObj.getColumnId(cellInd) == "TOTAL_SCORE"){
    		var vn_score = GridObj.cells(rowId, GridObj.getColIndexById("vn_score")).getValue();
    		var ev_no = GridObj.cells(rowId, GridObj.getColIndexById("ev_no")).getValue();
    		var ev_year = GridObj.cells(rowId, GridObj.getColIndexById("EV_YEAR")).getValue();
    		var seller_code = GridObj.cells(rowId, GridObj.getColIndexById("seller_code")).getValue();
    		var seller_name_loc = GridObj.cells(rowId, GridObj.getColIndexById("vendor_name_loc")).getValue();
    		var sg_regitem = GridObj.cells(rowId, GridObj.getColIndexById("sg_regitem")).getValue();
    		var eval_id = GridObj.cells(rowId, GridObj.getColIndexById("EVAL_ID")).getValue();

			 url = "ev_sheet_run_view.jsp";
	     	document.ex_form.ev_no.value = ev_no;
	     	document.ex_form.ev_year.value = ev_year;
	     	document.ex_form.seller_code.value = seller_code;
	     	document.ex_form.seller_name_loc.value = seller_name_loc;
	     	document.ex_form.sg_regitem.value = sg_regitem;
	     	document.ex_form.eval_id.value    = eval_id;
			document.ex_form.action = url;
			document.ex_form.method = "POST";
	
			var newWin_pop = window.open(url,"view_pop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
			document.ex_form.target = "view_pop";  
			document.ex_form.submit();  
			newWin_pop.focus();	
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
		
		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	
	//조회
	function doQuery(){
		var grid_col_id    = "<%=grid_col_id%>";
		var form        = document.forms[0];
	    var p_year      = LRTrim(form.p_year.value);
	    var ev_no       = LRTrim(form.ev_no.value);
	    var subject     = LRTrim(form.subject.value);
	    var sg_kind     = LRTrim(form.sg_kind.value);
	    var seller_code = LRTrim(form.seller_code.value);
	    var vn_status   = LRTrim(form.vn_status.value);
		
	    var param    = "?mode=query&grid_col_id="+ grid_col_id;
            param   += "&p_year="             + p_year;
            param   += "&ev_no="              + ev_no;
            param   += "&subject="            + encodeURIComponent(subject);
            param   += "&sg_kind="            + sg_kind;
            param   += "&seller_code="        + seller_code;
            param   += "&vn_status="          + vn_status;

		GridObj.post(G_SERVLETURL+param);
		GridObj.clearAll(false);
	}
	
	//조회후 뒷처리
    function doQueryEnd(GridObj, RowCnt){
		var msg    = GridObj.getUserData("", "message");
		var status = GridObj.getUserData("", "status");
		if(status == "false")	alert(msg);

		return true;
    }
    			
	//저장
	function doInsert(){
		
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
		
		if(status == "true")	doQuery();
		else{
			alert(messsage);
		}

		return false;
	}

	function searchProfile( part ){
		if( part == "seller_code" ){
			PopupCommon1("SP5001", "getVendor_code", "", "업체코드", "업체명");
		}
		else if( part == "sheet_no" ){
			PopupCommon1("SP5005", "getSheet_no", "", "심사표번호", "심사표제목");
		}
	}

	function getSheet_no(code,text) {
		document.forms[0].ev_no.value   = code;
		document.forms[0].subject.value = text;
	}
		
	function getVendor_code(code,text) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text;
	}
	
	function realSearch(){
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		if( grid_array.length > 1 ){
			alert("하나의 SHEET만 선택 가능합니다.");
			return;
		}
		
		var form    = document.forms[0];
		var left    = (screen.width/2)  - 860/2;
	    var top     = (screen.height/2) - 600/2-50;
	    
		for( var i = 0; i < grid_array.length; i++ ){
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("vn_status")).getValue()) == "평가미실행"){
				alert('평가를 실시하지 않아 현장실사를 등록할 수 없습니다.');
				return;
			}
		   	form.g_ev_no.value           = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ev_no")).getValue());
		   	form.g_subject.value         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("subject")).getValue());
	   		form.g_seller_code.value     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("seller_code")).getValue());
		   	form.g_vendor_name_loc.value = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("vendor_name_loc")).getValue());
		   	form.g_ev_year.value         = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EV_YEAR")).getValue());
		   	form.g_sg_regitem.value      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("sg_regitem")).getValue());			
	    }	
	
	   	window.open( "", "real", "width=900,height=600,top="+top+",left="+left+",resizable=yes,toolbar=no,status=no,scrollbars=yes");
		
		form.action  = "ev_sheet_runing_pop.jsp";
	   	form.target  = "real";
	   	form.submit();		
	}	   	
	
	
	//지우기
	function doRemove( type ){
	    if( type == "ev_no" ) {
	    	document.forms[0].ev_no.value = "";
	        document.forms[0].subject.value = "";
	    }  
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();initAjax();">
<s:header>
<form id="form" name="form" method="post" action="">
<input type="hidden" id="g_ev_no"           name="g_ev_no">           
<input type="hidden" id="g_subject"         name="g_subject">         
<input type="hidden" id="g_seller_code"     name="g_seller_code">     
<input type="hidden" id="g_vendor_name_loc" name="g_vendor_name_loc"> 
<input type="hidden" id="g_ev_year"         name="g_ev_year">         
<input type="hidden" id="g_sg_regitem"      name="g_sg_regitem">      
<input type="hidden" id="g_seller_name"     name="g_seller_name">     
<input type="hidden" id="seller_name"       name="seller_name">       
<%@ include file="/include/include_top.jsp"%>
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "평가진행현황";
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
        		<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_029.EV_YEAR")%></td>
				<td width="18%" height="24" class="se_cell_data">
					<select id="p_year" name="p_year">
						<option value="">전체</option>
					</select>
				</td>
				<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_029.SG_KIND")%></td>
				<td width="15%" height="24" class="se_cell_data">
					<select id="sg_kind" name="sg_kind" class="input_submit">
						<option value="">전체</option> 
					</select> 				
				</td>
				<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_029.vn_status")%></td>
				<td width="21%" height="24" class="se_cell_data">
					<select id="vn_status" name="vn_status" class="input_submit">
						<option value="">전체</option>
						<option value="WE">평가확정</option>
						<option value="WG">평가실행(적격)</option> 
						<option value="WC">평가실행(부적격)</option> 
						<option value="N">평가미실행</option>
					</select>			
				</td>				
			</tr>
		    <tr>
				<td width="13%" height="24" class="se_cell_title"><%=text.get("WO_029.ev_no")%></td>
				<td width="20%" height="24" class="se_cell_data">
					<input id="ev_no" name="ev_no" type="text" style="ime-mode:inactive"  class="input_submit" onkeydown='entKeyDown()'>
					<a href="javascript:searchProfile('sheet_no')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<a href="javascript:doRemove('ev_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
				</td>		  
	        	<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_029.subject")%></td>
				<td width="15%" height="24" class="se_cell_data">
					<input id="subject" name="subject" type="text" class="input_submit" style="width:200px;" onkeydown='entKeyDown()'>
				</td>				  
				<td width="12%" height="24" class="se_cell_title"><%=text.get("WO_029.seller_code")%></td>
				<td width="23%" height="24" class="se_cell_data">
					<input id="seller_code" name="seller_code" type="text" style="ime-mode:inactive"  class="input_submit" onkeydown='entKeyDown()'>
					<a href="javascript:searchProfile('seller_code')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>		
					<a href="javascript:doRemove('seller_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>			
				</td>
			</tr>							
			</table>
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						<td><script language="javascript">btn("doQuery()", "<%=text.get("BUTTON.search")%>")</script></td>
						<!-- <td><script language="javascript">btn("realSearch()", "<%=text.get("BUTTON.real_search")%>")</script></td>  -->
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>
		</td>
	</tr>
</table>
</form>

<form id="ex_form" name="ex_form">
	<input type="hidden" id="ev_no"              name="ev_no">              
	<input type="hidden" id="ev_year"            name="ev_year">            
	<input type="hidden" id="seller_code"        name="seller_code">        
	<input type="hidden" id="seller_name_loc"    name="seller_name_loc">    
	<input type="hidden" id="sg_regitem"         name="sg_regitem">         
	<input type="hidden" id="eval_id"            name="eval_id">            
</form>
</s:header>
<s:grid screen_id="WO_029" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
