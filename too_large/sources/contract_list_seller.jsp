<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
 <%@ taglib prefix="s" uri="/sepoa"%>
<%
	String to_day 	 = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date 	 = to_day;	
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CTS_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	String summary		 = JSPUtil.paramCheck(request.getParameter("summary"));	

	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String user_type    = info.getSession("USER_TYPE");
	String company_code = info.getSession("COMPANY_CODE");
	String company_name = info.getSession("COMPANY_NAME");
	String CTRL_CODE   	  = info.getSession("CTRL_CODE");
	
	//String CTRL_TYPE      = CTRL_CODE.substring(0, 2);
	String CTRL_TYPE      = "";
	String USER_ID        = info.getSession("ID"); 
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "CTS_001";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<!-- <script src="../js/cal.js" language="javascript"></script> -->

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list_seller";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
		<%
		if(summary.equals("new") || summary.equals("old")){ %>
    		setTimeout("doQuery();",500);
    	<% } %>
    	doQuery();
    }

	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
 		if(status == "false") alert(msg);

		//if(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).getValue() !="0")
		//{
			//GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("BD_SELLER_CNT")).setValue("yellow");
		//}
		return true;
    }
    
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);

    	if( header_name == "CONT_NO")
		{
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
	 		/* 
			var url = "contract_insert.jsp?doc_type=SA&view=VI&cont_no="+encodeUrl(cont_no)+"&cont_gl_seq="+encodeUrl(cont_gl_seq);
			var width = "1040";
			var height = "700";
			
			doOpenPopup(url, width, height);
			*/
		 	contractPopup( cont_no , cont_gl_seq , "VI" , "SA" );
		}
		
    	if( header_name == "REJECT_REASON")
		{
			var cont_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());
			var cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
			var reject_reason  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("REJECT_REASON_TEXT")).getValue()); 
			var ct_flag  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CT_FLAG")).getValue()); 
			
			if(ct_flag == "CE"){   
				var url = "contract_reject_popup.jsp?update_flag=D&reject_reason="+encodeUrl(reject_reason);
				var width = "700";
				var height = "150";
				
				doOpenPopup(url, width, height);
			}
		}
    }
 	function setSelectGrid(){
		
		for(var row = 0; row < GridObj.getRowsNum(); row++) 
		{
			GridObj.enableSmartRendering(true);
	    	GridObj.selectRowById(GridObj.getRowId(row), false, true);
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).setValue("1");
		}
	}
	
 	function setReTender(param) {
		//setSelectGrid();
		//alert("param=="+param);
		var grid_array = getGridChangedRows(GridObj, "SELECTED");	

		myDataProcessor = new dataProcessor(param);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
    
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
		} else if(stage==2) {
			
			
			return true;
		}
		return false;
    }
    
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("CTS_001.0001")%>");
		return false;
	}
    function initAjax()
	{ 
    }
     	
    // 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var rewo_number = "";
		var rewo_seq = "";
		
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
  
	/**
	 * @Function Name  : getContractListSeller
	 * @작성일         : 2009. 07. 06
	 * @변경이력       :
	 * @Function 설명  :  조회
	 */		
	function doQuery()
	{
		var from_cont_date	= encodeUrl(LRTrim(del_Slash(document.form.from_cont_date.value)));
		var to_cont_date  	= encodeUrl(LRTrim(del_Slash(document.form.to_cont_date.value))); 
		 
			if(LRTrim(from_cont_date) == "" || LRTrim(from_cont_date) == "" ) { 
	            alert("<%=text.get("CTS_001.0002")%>");
	            return;
	        }
	
	        if(!checkDate(from_cont_date)) { 
	             alert("<%=text.get("CTS_001.0003")%>");
	            document.form.from_cont_date.select();
	            return;
	        }
	        
	        if(!checkDate(to_cont_date)) { 
	             alert("<%=text.get("CTS_001.0003")%>");
	            document.form.to_cont_date.select();
	            return;
	        } 
	    //document.form.from_cont_date.value = from_cont_date;
	    //document.form.to_cont_date.value   = to_cont_date;
	    
	    var cols_ids = "<%=grid_col_id%>";
        var param = "&mode=query";
        param += "&cols_ids="    + cols_ids;
        param += dataOutput();
        GridObj.post(G_SERVLETURL, param);
        GridObj.clearAll(false);
	}
	/**
	 * @Function Name  : doInsert
	 * @작성일         : 2009. 07. 10
	 * @변경이력       :
	 * @Function 설명  : 계약생성
	 */	
	function doInsert(){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CTS_001.0004")%>");
			return;
		}
		 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		 var cont_no = "";
		 var cont_gl_seq = "";
		 var ct_flag  = ""; 
		
		for(var i = 0; i < grid_array.length; i++)
		{
		   
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()); 
		    
		}
		if(ct_flag == "CE"){
			alert("<%=text.get("CTS_001.0005")%>"); // 이미 변경요청된 건입니다.
			return;
		}
		/* 
 		var param = "?doc_type=SA&view=VI&cont_no=" + encodeUrl(cont_no) + "&cont_gl_seq=" + encodeUrl(cont_gl_seq);
 		popUpOpen("contract_insert.jsp"+param, 'cont_ins_pops', '1040', '700');  
		*/
	 	contractPopup( cont_no , cont_gl_seq , "VI" , "SA" );
	}
	
	function doRejectConfirm(reject_reason){
		if(!checkRows()) return;
		
		var check_count = getCheckedCount(GridObj, 'SELECTED'); //그리드의 체크된 갯수 반환
		
		if(check_count > 1){
			//alert("하나만 선택해주십시오.");
			alert("<%=text.get("CTS_001.0004")%>");
			return;
		}
		 
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		  
		var ct_status = ""; 
		var cont_gl_seq  = ""; 
		
		for(var i = 0; i < grid_array.length; i++)
		{ 
		   cont_no = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue());
		   cont_gl_seq = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()); 
		   ct_flag = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG")).getValue()); 
		}
		
		if(ct_flag == "CE"){
			alert("<%=text.get("CTS_001.0005")%>"); // 이미 변경요청된 건입니다.
			return;
		}
		 
	   	if (confirm("<%=text.get("CTS_001.0006")%>")) // 계약변경요청 하시겠습니까?
	   	{
			var cols_ids = "<%=grid_col_id%>";
            var params="mode=reject";
            params += "&cols_ids=" + cols_ids;
            params += dataOutput();
            myDataProcessor = new dataProcessor(G_SERVLETURL,params);
            sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	    }
	}	
	
	function doOpenPopup(url, width, height)
	{
	  	document.form.action = url;
	  	document.form.method = "post";
	  	
	  	//화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		var top = dim[0];
		var left = dim[1];
	
	    var toolbar = 'no';
	    var menubar = 'no';
	    var status = 'yes';
	    var scrollbars = 'yes';
	    var resizable = 'yes';
	  	
	  	var setValue  = "left="+left+", top="+top+",width="+width+",height="+height+", toolbar="+toolbar+", menubar="+menubar+", status="+status+", scrollbars="+scrollbars+", resizable="+resizable ;
	
	 	var newWin = window.open('','EX', setValue);
	  	document.form.target = "EX";
	  	document.form.submit();
	}
	
	function contractPopup(cont_no,cont_gl_seq,view,doc_type){

        if(cont_no != ''){
            document.forms[0].cont_no.value     = cont_no;
            document.forms[0].cont_gl_seq.value = cont_gl_seq;
            document.forms[0].view.value        = view;            
            document.forms[0].doc_type.value    = doc_type; 
            var url = "contract_detail_print.jsp?cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq + "&cont_form_no=" + cont_no;
//             var url = "contract_detail.jsp";
            doOpenPopup( url, '1000', '750' );
        }
    }
	
	
	function doSend() {
		var cont_no       = "";
		var cont_gl_seq   = "";
		var cont_form_no  = ""; 
		var checked_count = 0;
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
			
			cont_no      = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
			cont_gl_seq  = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()));
			cont_form_no = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue()));
		}
		
        if(checked_count > 1)  {
            alert(G_MSS2_SELECT);
            return;
        }

<%--        if("<%=info.getSession("LOGIN_FLAG")%>" == "Y") {--%>
<%--        	alert("공인인증서로 로그인 하지 않았습니다. \n등록된 인증서로 로그인하여 주세요.");--%>
<%--        	return;--%>
<%--        }--%>

		if (confirm("계약서를 작성하시겠습니까?")) {
			location.href = "contract_list_seller_create.jsp?cont_no="+ cont_no + "&cont_form_no="+ cont_form_no + "&cont_gl_seq=" + cont_gl_seq;
		}
	}
	
	var delete_confirm_pop;
	
	function doDelete_reject(){
		document.form.delete_confirm.value="";
		
		if(!checkRows()) return;
		
<%--         if("<%=info.getSession("LOGIN_FLAG")%>" == "Y") { --%>
//         	alert("공인인증서로 로그인 하지 않았습니다. \n등록된 인증서로 로그인하여 주세요.");
//         	return;
//         }
        var width = 700;
    	var height = 180;
        var left = "";
		var top = "";
	
	    //화면 가운데로 배치
	    var dim = new Array(2);
	
		dim = ToCenter(height,width);
		top = dim[0];
		left = dim[1];
	
	    var toolbar = 'no'; 
	    var menubar = 'no';
	    var status = 'no';
	    var scrollbars = 'no';
	    var resizable = 'no';
	    delete_confirm_pop = window.open("contract_delete_confirm.jsp", 'DELETE_CONFIRM', 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	    delete_confirm_pop.focus();
        
	}	


	function doDelete_confirm(delete_confirm){
	
		document.form.delete_confirm.value = delete_confirm;
		delete_confirm_pop.window.close();
		doDelete();
	}
	
	function doDelete() {
	
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var CT_FLAG_TEXT = "";
		var delete_confirm = document.form.delete_confirm.value;
		
		for(var i = 0; i < grid_array.length; i++)
		{
			CT_FLAG_TEXT   = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CT_FLAG_TEXT")).getValue());
			
			alert(CT_FLAG_TEXT);
			
			if(CT_FLAG_TEXT != "업체전송") {
				alert("업체전송인 건에 대해서만 거부 가능합니다.");
				return;
			}
		}
		
		
		
		
	   	if (confirm("계약서를 변경요청 하시겠습니까?")){
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+ cols_ids+ "&delete_confirm="+encodeUrl(delete_confirm);
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	   }
	}
 
</script>
</head>

<body leftmargin="10" topmargin="6" onload="initAjax();setGridDraw();">
<s:header>
<form name="form">  
	<input type="hidden" id="cont_no" 		name="cont_no"/>
	<input type="hidden" id="cont_gl_seq" 	name="cont_gl_seq"/>
	<input type="hidden" id="view" 			name="view"/>
	<input type="hidden" id="doc_type" 		name="doc_type"/>
	<input type="hidden" id="delete_confirm"name="delete_confirm"/>
<%
// 	thisWindowPopupFlag = "true";
// 	thisWindowPopupScreenName = "전자계약접수현황"; 
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
              <colgroup>
                <col width="10%" />
                <col width="35%" />
                <col width="10%" />
                <col width="35%" />
              </colgroup>
		      <tr>
		        <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("CTS_001.T_CONT_ADD_DATE")%></td><%-- 계약작성일자 --%>
        		<td class="data_td">
        			<s:calendar id_from="from_cont_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" id_to="to_cont_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d" />
        		</td>
        		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("CTS_001.T_SUBJECT")%></td> <%-- 계약명 --%>
        		<td class="data_td">
        			<input type="text" name="subject" id="subject" size="20" class="inputsubmit" value="" style="width : 98%">
        		</td>
			  </tr>
		      </table>
	</table>
</td>
</tr>
</table>
</td>
</tr>
</table>		      
		      
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td> <%-- 조회 --%>
					<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td> 
					<td><script language="javascript">btn("javascript:doSend()","계약서작성")</script></td>
					<td><script language="javascript">btn("javascript:doDelete_reject()","계약서변경요청")</script></td>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
		
</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>