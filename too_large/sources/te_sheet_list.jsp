<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EV_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "EV_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- 폼작업만 했기때문에 틀을 제외한 함수 차후 변경 및 적용 -->
<%
	String user_id         	= info.getSession("ID");
	String company_code    	= info.getSession("COMPANY_CODE");
	String company_name    	= info.getSession("COMPANY_NAME");
	String house_code      	= info.getSession("HOUSE_CODE");
	String toDays          	= SepoaDate.getShortDateString();
	String toDays_1        	= SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   	= info.getSession("NAME_LOC");
	String ctrl_code       	= info.getSession("CTRL_CODE");
	String to_date          = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());
	//String from_date        = SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-36));
    String from_date        = "2021/07/01";

	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
<!--
	var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";
	
	var IDX_SEL;
	var IDX_ES_CD;
	var IDX_ES_VER;		
	
	function setHeader() {
		var f0 = document.forms[0];

		// 그리드 헤더 설정
		

// 		GridObj.SetColCellBgColor("ITEM_QTY"		,G_COL1_OPT);
// 		GridObj.SetColCellBgColor("TAX_PRICE"		,G_COL1_ESS);

		// 그리드 포맷 설정
// 		GridObj.SetDateFormat("PAY_DATE"			,"yyyy/MM/dd");	
// 		GridObj.SetNumberFormat("ITEM_COUNT"	,"###,###.00");
// 		GridObj.SetNumberFormat("ITEM_QTY"	,"###,###.00");
// 		GridObj.SetNumberFormat("PAY_AMT"		,G_format_amt);

		// 그리드 위치 설정

		/*
		GridObj.SetColCellSortEnable("PO_CREATE_DATE"		,false);
		
		GridObj.SetDateFormat("PO_CREATE_DATE"	,"yyyy/MM/dd");
		GridObj.SetNumberFormat("PO_TTL_AMT"		,G_format_amt);
		*/
		
		// 그리드 인덱스 설정
		IDX_SEL					= GridObj.GetColHDIndex("selected");
		IDX_ES_CD				= GridObj.GetColHDIndex("ES_CD");
		IDX_ES_VER				= GridObj.GetColHDIndex("ES_VER");
		doSelect();
	}

	function doSelect()
	{
		var f0 = document.forms[0];

		if(!checkDateCommon(del_Slash(f0.from_date.value))) {
			alert("생성일자(From)를 확인 하세요 ");
			f0.from_date.focus();
			return;
		}

		if(!checkDateCommon(del_Slash(f0.to_date.value))) {
			alert("생성일자(To)를 확인 하세요 ");
			f0.to_date.focus();
			return;
		}
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getEvalSheetList&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var po_no = "";
		var reject_reason_flag = "";
		
		if(msg1 == "doQuery"){
		}
		if(msg1 == "doData"){
			var mode  = GD_GetParam(GridObj,0);
			if(mode = "setTaxCheck"){

			}else{
				alert(GD_GetParam(GridObj,"0"));
				if(GridObj.GetStatus()==1) {
					doSelect();
				}				
			}
		}
		if(msg1 == "t_imagetext") {
			if(msg3==IDX_ES_CD) {			// 거래명세서 상세 페이지 팝업
				pay_no		= GD_GetCellValueIndex(GridObj,msg2,IDX_ES_CD);
				window.open("/kr/order/ivtr/tr1_bd_dis1.jsp"+"?pay_no="+pay_no,"newWin","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		    }
		}
	}
	
	//************************************************** Date Set *************************************
	
	
    function getAddUser(code, text)
	{
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
	}
	
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SEL");

		if(grid_array.length == 0)
		{
			alert("삭제할 행을 선택하세요");
			return false;
		}

		if(grid_array.length != 1)
		{
			alert("삭제할 행을 하나만 선택하세요");
			return false;
		}
		
		return true;
	}
//-->
</script>

<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	var url = '';
	var param = '';
	
	if( header_name == "ES_CD" ) {
		var url = "/kr/ev/ts_sheet_view.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&es_cd="+SepoaGridGetCellValueId(GridObj, rowId, "ES_CD");
		param += "&es_ver="+SepoaGridGetCellValueId(GridObj, rowId, "ES_VER");
		PopupGeneral(url+param, "평가상세", "", "", "925", "800");
	}  
	
	
	
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var rowcount = grid_array.length;
	//GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SEL")).setValue(0);
		GridObj.cells(grid_array[row], GridObj.getColIndexById("SEL")).cell.wasChanged = false;
    }	
	
	
	GridObj.cells( rowId, GridObj.getColIndexById("SEL")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SEL")).cell.wasChanged = true;

    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.sepoaGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    	if(GridObj.getColIndexById("SEL") == cellInd){
			for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
				GridObj.cells(GridObj.getRowId(i), cellInd).setValue("0");			
			}
		}
    	GridObj.cells(rowId, cellInd).setValue("1");
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
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

 	alert(messsage);
    
    doSelect();
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function SP9113_Popup( type ) {
	if( type == "add_user_id" ) {
		window.open("/common/CO_008.jsp?callback=eval_callback", "SP9114", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function  eval_callback(id, name) {
	form1.add_user_id.value     = id;
	form1.add_user_name.value   = name;
}

//지우기
function doRemove( type ){
    if( type == "add_user_id" ) {
    	document.forms[0].add_user_id.value = "";
        document.forms[0].add_user_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:setGridDraw();javascript:setHeader()" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<%if("".equals(gate)){%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<%
}
%>


<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name="form1" >
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 평가구분</td>      	
		<td class="data_td" width="35%" >
				<select name="ev_gb" id="ev_gb" class="inputsubmit">
					<option value="">전체</option>				
	<%
		String listbox8 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M902", "");
		out.println(listbox8);
	%>
				</select>
		 </td>      	 
       <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공종</td>      	
		<td class="data_td" width="35%" >
				<select name="cskd_gb" id="cskd_gb" class="inputsubmit">
					<option value="">전체</option>				
	<%
		String listbox9 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M903", "");
		out.println(listbox9);
	%>
				</select>
		 </td>      	      	
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성일자</td>
	    <td class="data_td">
	       <s:calendar id_from="from_date" default_from="<%=from_date %>" default_to="<%=to_date %>" id_to="to_date" format="%Y/%m/%d" />
	    </td>
  		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성자</td>      	
      	<td class="data_td" >
	        <b><input type="text" name="add_user_id" id="add_user_id" style="ime-mode:inactive" size="15" class="inputsubmit" onkeydown='entKeyDown()'>
	        <a href="javascript:SP9113_Popup('add_user_id');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
	        <a href="javascript:doRemove('add_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
	        <input type="text" name="add_user_name" id="add_user_name" size="20" readOnly onkeydown='entKeyDown()'></b>
	    </td>	    	            
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>  
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>	    	  					 
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>
<%-- <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div> --%>
<div id="pagingArea"></div>
<s:grid screen_id="EV_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


