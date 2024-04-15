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
	String dis_view  = "";
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("WO_033");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text        = MessageUtil.getMessage(info,multilang_id);
	String language     = info.getSession("LANGUAGE");
	String company_code = info.getSession("COMPANY_CODE");
	String user_id      = info.getSession("ID");
	String user_dept    = info.getSession("DEPARTMENT");


	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_033";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = false;
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
<%-- 	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.ev_vendor_choice"; --%>
	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_vendor_choice";
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;

	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
	}

	function initAjax(){
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '' );
<%-- 		doRequestUsingPOST( 'SL0116', '1#<%=info.getSession("HOUSE_CODE")%>' ,'sg_type1', '' ); --%>
	}
		
	function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
            $(sg_type2_id).trigger("onchange");
			
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
<%-- 				doRequestUsingPOST( 'SL0121', '<%=info.getSession("HOUSE_CODE")%>#2'+'#'+sg_refitem ,'sg_type2','' ); --%>
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
		else if( type == '3' ){
			var sg_refitem  = f.sg_type2.value;
			var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
			
			sg_type3_id.options.length = 0;     //길이 0으로
//			sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
            $(sg_type3_id).trigger("onchange");
			
			if( sg_refitem.valueOf().length > 0 ) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'sg_type3', '' );
<%-- 				doRequestUsingPOST( 'SL0121','<%=info.getSession("HOUSE_CODE")%>#3'+'#'+sg_refitem ,'sg_type3','' ); --%>
			}
			else{
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}

	function doOnRowSelected(rowId,cellInd){
		//alert("doOnRowSelected");
		if(GridObj.getColumnId(cellInd) == "ev_no"){
    		var ev_no = GridObj.cells(rowId, cellInd).getValue();
    		var ev_year = GridObj.cells(rowId, GridObj.getColIndexById("ev_year")).getValue();
    			var url = "ev_sheet_view.jsp?ev_no="+ev_no+"&ev_year="+ev_year+"&flag=I" ;
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
		var grid_col_id     = "<%=grid_col_id%>";
		var form            = document.forms[0];
	    var sg_type1        = LRTrim(form.sg_type1.value);
	    var sg_type2        = LRTrim(form.sg_type2.value);
	    var sg_type3        = LRTrim(form.sg_type3.value);
		var seller_code     = LRTrim(form.seller_code.value);
		var ev_flag         = LRTrim(form.ev_flag.value);
		var ev_no           = LRTrim(form.ev_no.value);
		
		if( ev_no == "" ){
			alert("심사표번호를 입력하세요");
			return;
		}
				
	    var param    = "?mode=query&grid_col_id="+grid_col_id;
            param   += "&sg_type1="        + sg_type1;
            param   += "&sg_type2="        + sg_type2;
            param   += "&sg_type3="        + sg_type3;
            param   += "&seller_code="     + seller_code;
            param   += "&ev_flag="         + ev_flag;
			param   += "&ev_no="           + ev_no;

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

    //작성자지정
	function doApproval(){  
	   	var grid_array      = getGridChangedRows(GridObj, "selected");
		var form            = document.forms[0];
	    var p_start_setting = LRTrim(del_Slash(form.p_start_setting.value));
	    var p_ends_setting  = LRTrim(del_Slash(form.p_ends_setting.value));

		for( var i = 0; i < grid_array.length; i++ ){
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ev_flag")).getValue()) == ""){
				alert('대상여부를 선택하여 주십시요.');
				return;
			}
			// 정기(P), 수시(S)
			if(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PERIOD")).getValue()) == "P" ){
			    if( p_start_setting == "" ){
			    	alert("업체입력기간 FROM을 입력하세요.");
			    	form.p_start_setting.focus();
			    	return;
			    }	    
			    if( p_ends_setting == "" ){
			    	alert("업체입력기간 TO를 입력하세요.");
			    	form.p_ends_setting.focus();
			    	return;
			    }
			    if( p_start_setting >= p_ends_setting ){
			    	alert("업체입력기간을 확인해주십시요.");
			    	form.p_start_setting.focus();
			    	return;
			    }
			}			
		}	    	 
		var param = "";
	
		param += "company_code="+'<%=company_code%>';
		param += "&dept_code="+'<%=user_dept%>';
		param += "&req_user_id="+'<%=user_id%>';
		param += "&doc_type=CT";
		param += "&fnc_name=getApproval"; 
		param += "&from=P";

		childFrame.location.href="app_approval4.jsp?"+param; 
	}
	
	//작성자 지정 후 저장함수(app_aproval_list4.jsp에서 넘어옴)
	function getApproval(Approval_str) {
	   	var grid_array      = getGridChangedRows(GridObj, "selected");
		var form            = document.forms[0];
	    var p_start_setting = LRTrim(del_Slash(form.p_start_setting.value));
	    var p_ends_setting  = LRTrim(del_Slash(form.p_ends_setting.value));
 
		if (Approval_str == "") {
			alert("작성자를 지정해 주세요");
			return;
		}
	   
	    if(confirm("<%=text.get("MESSAGE.1018")%>")){
            var cols_ids = "<%=grid_col_id%>";
            var param    = "?mode=insert&cols_ids=" + cols_ids;
                param   += "&p_start_setting="      + p_start_setting;
                param   += "&p_ends_setting="       + p_ends_setting;
				param   += "&APPROVAL_STR="         + encodeUrl(Approval_str);
			
		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
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
		
		if(status == "true")	doQuery();
		else{
			alert(messsage);
		}

		return false;
	}

	
	function getVendor_code(code,text) {
		document.forms[0].seller_code.value = code;
		document.forms[0].seller_name.value = text;
	}

	function searchProfile( part ){
		var f = document.forms[0];
	
		if( part == "sheet_no" ){
			PopupCommon1("SP5002", "getSheet_no", "", "심사표번호", "심사표제목");
		}
		if( part == "seller_code" ){
			PopupCommon1("SP5001", "getVendor_code", "", "업체코드", "업체명");
		}
	}
	
	function getSheet_no(code,text) {
		document.forms[0].ev_no.value = code;
		document.forms[0].subject.value = text;
	}
	function getSheet_no_reset(){
		document.forms[0].seller_code.value = "";
		document.forms[0].seller_name.value = "";
	}
	
	function doSMS(){  
		var ev_no       = LRTrim(form.ev_no.value);
		
		if( ev_no == "" ){
			alert("심사표번호를 입력하세요");
			return;
		}
		var strParm  = "?ev_no=" + ev_no;
				
		popUpOpen("ev_vendor_choice_sms_list.jsp"+strParm, 'SMS_LIST', '700', '500');
        
	}
	
	//지우기
	function doRemove( type ){
	    if( type == "ev_no" ) {
	    	document.forms[0].ev_no.value = "";
	        document.forms[0].subject.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        getQuery();
	    }
	}
		
</Script>
</head>

<s:header>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="initAjax();setGridDraw();">
<form name="form" method="post" action="">
<input type="hidden" name="seller_code">
<input type="hidden" name="subject">

<%@ include file="/include/include_top.jsp"%>
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "적격업체대상선정";
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
				<td width="13%" class="se_cell_title"><%=text.get("WO_033.parent1")%></td>
			    <td width="20%" class="se_cell_data" > 
			    	<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');" <%=dis_view%>>
			    		<option value="">--------</option>
			    	</select>
			    </td>
				<td width="13%" class="se_cell_title"><%=text.get("WO_033.parent2")%></td>
				<td width="20%" class="se_cell_data">
					<select id="sg_type2" name="sg_type2" class="inputsubmit" onchange="nextAjax('3');">
			    		<option value="">--------</option>
			    	</select>
				</td>
				 <td width="13%" class="se_cell_title"><%=text.get("WO_033.sg_refitem")%></td>
			    <td width="20%" class="se_cell_data"> 
			    	<select id="sg_type3" name="sg_type3" class="inputsubmit">
			    		<option value="">--------</option>
			    	</select>
			    </td>								
			</tr>
		    <tr>
				<td class="se_cell_title">심사표번호</td>
				<td class="se_cell_data">
					<input type="text" name="ev_no" class="inputsubmit" readonly="readonly" onkeydown='entKeyDown()'>
					<a href="javascript:searchProfile('sheet_no')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<a href="javascript:doRemove('ev_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
				</td>		    
        		<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_033.seller_name")%></td>
				<td height="24" class="se_cell_data">
					<input id="seller_name" name="seller_name" type="text" class="input_submit" onkeydown='entKeyDown()'>
					<a href="javascript:searchProfile('seller_code')">
						<img src="<%=POASRM_CONTEXT_NAME%>/images/button/butt_query.gif" align="absmiddle" border="0" alt="">
					</a>
					<a href="javascript:getSheet_no_reset()">
							<img src="<%=POASRM_CONTEXT_NAME%>/images/ico_x2.gif" align="absmiddle" border="0" alt="">
					</a>	
				</td>
        		<td width="15%" height="24" class="se_cell_title"><%=text.get("WO_033.ev_flag")%></td>
				<td height="24" class="se_cell_data">
			    	<select id="ev_flag" name="ev_flag" class="inputsubmit">
			    		<option value="">전체</option>
			    		<option value="Y">Yes</option>
			    		<option value="N">No</option>
			    	</select>
				</td>				
			</tr>
			</table>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td height="24" class="se_cell_data" colspan="6">&nbsp;</td>
			</tr>			
			</table>
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		    <tr>
        		<td width="15%" height="24" class="div_input_re"><%=text.get("WO_033.input_setting")%></td>
				<td height="24" class="se_cell_data" colspan="5">
					<s:calendar id="p_start_setting" default_value="" 	format="%Y/%m/%d"/>
					&nbsp;~&nbsp;
					<s:calendar id="p_ends_setting" default_value="" 	format="%Y/%m/%d"/>
				</td>
			</tr>			
			</table>
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr> 
						<td><script language="javascript">btn("doQuery()", "조회")</script></td>
						<td><script language="javascript">btn("doApproval()", "적격업체대상등록")</script></td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>
            <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
            <div id="pagingArea"></div>
            <%@ include file="/include/include_bottom.jsp"%>
		</td>
	</tr>
</table>
</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp" > --%>
<%-- <jsp:param name="grid_object_name_height" value="gridbox=180"/> --%>
<%-- </jsp:include> --%>
</body>
</s:header>
<s:footer/>
<iframe id="childFrame" name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>
