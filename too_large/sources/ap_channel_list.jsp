<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>



<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	String flag 		= JSPUtil.nullToEmpty(request.getParameter("flag"));
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	String TITLE = "결재경로현황";
%>

<html>
	<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		
		
<%@ include file="/include/include_css.jsp"%>

<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
		
<script language="javascript" type="text/javascript">

<%-- var G_SERVLETURL = "<%=getWiseServletPath("admin.basic.approval2.ap2_bd_lis1")%>"; --%>

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";
var flag = "<%=flag%>";

var INDEX_SELECTED        = "" ;
var INDEX_SIGN_PATH_NAME  = "" ;
var INDEX_SIGN_PATH_NO    = "" ;
var INDEX_SIGN_PATH       = "" ;
var INDEX_SIGN_REMARK     = "" ;
var INDEX_FALG			  = "" ;


function Init() {
setGridDraw();
setHeader();
	
}

function setHeader() {
	
	
	
	
	GridObj.SetDateFormat("ADD_DATE",   "yyyy/MM/dd");
	GridObj.SetDateFormat("CHANGE_DATE",   "yyyy/MM/dd");


	INDEX_SELECTED        = GridObj.GetColHDIndex("SELECTED");
	INDEX_SIGN_PATH_NAME  = GridObj.GetColHDIndex("SIGN_PATH_NAME");
	INDEX_SIGN_PATH_NO    = GridObj.GetColHDIndex("SIGN_PATH_NO");
	INDEX_SIGN_PATH       = GridObj.GetColHDIndex("SIGN_PATH");
	INDEX_SIGN_REMARK     = GridObj.GetColHDIndex("SIGN_REMARK");
	INDEX_FLAG			  = GridObj.GetColHDIndex("FLAG") ;
	if(flag=="D"){
		GridObj.setColumnExcellType( GridObj.getColIndexById( "SIGN_PATH_NAME" ), "ro" );
	}
	// 2011.3.24 solarb 결제경로관리메뉴를 선택시 디폴트로 기본조회 되도록 doSelect(); 메소드 추가
	doSelect();
}


function doSelect() {
	
	var wise = GridObj;
	var F = document.forms[0];
	F.insert_flag.value = "off";
	
	/* SIGN_PATH_NO = F.SIGN_PATH_NO.value;
	SIGN_PATH_NAME = F.SIGN_PATH_NAME.value;

	GridObj.SetParam("mode", "getMaintain");
	GridObj.SetParam("flag", flag);
	GridObj.SetParam("SIGN_PATH_NO", SIGN_PATH_NO);
	GridObj.SetParam("SIGN_PATH_NAME", SIGN_PATH_NAME);
	
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; */
	
	
	
	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getChannelList&grid_col_id="+grid_col_id;
		param += "&flag="+flag;
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_list";

	
	GridObj.post(url, param);
	GridObj.clearAll(false);	 
}

/* JTable 에서 생성할 수 있도록 화면 전환이 된다.*/
function Line_insert() {
	var wise = GridObj;
	var insert_flag = document.forms[0].insert_flag.value;

	for(var i=0; i<GridObj.GetRowCount();i++) {
		GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&"); 
	}

	if(insert_flag == "off") {
		/* GridObj.AddRow();
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, 	"true&", 						"&"); 
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SIGN_PATH, 	"/kr/images/button/query.gif&", "&");
		GridObj.AddImageList("SIGN_PATH","/images/icon/icon_data_a.gif");	
		GridObj.SetCellImage("SIGN_PATH",GridObj.GetRowCount()-1,0);
		GridObj.SetCellValueIndex(INDEX_SIGN_PATH,GridObj.GetRowCount()-1,'');
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SIGN_REMARK, 	"/kr/images/button/query.gif&", "&");
		GridObj.AddImageList("SIGN_REMARK","/images/icon/icon_data_a.gif");	
		GridObj.SetCellImage("SIGN_REMARK",GridObj.GetRowCount()-1,0);
		GridObj.SetCellValueIndex(INDEX_SIGN_REMARK,GridObj.GetRowCount()-1,''); */
		dhtmlx_last_row_id++;
		var nMaxRow2 = dhtmlx_last_row_id;
		var row_data = "<%=grid_col_id%>";
		
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SIGN_PATH_IMG")).setValue("/images/icon/icon_data_a.gif");
		dhtmlx_before_row_id = nMaxRow2;
		document.forms[0].insert_flag.value = "on";
	}else {
		alert("한줄씩만 생성 가능합니다.");
		GridObj.cells(dhtmlx_last_row_id, GridObj.getColIndexById("SELECTED")).setValue("1");
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, "true&", "&"); 
	}
	;
}

function doInsert() {
	
	var wise = GridObj;
	var grid_array = GridObj.GetRowCount();
	var cnt=0;
	var row_idx=0;
	/* var row_idx = checkedOneRow(INDEX_SELECTED);
	if (row_idx < 0) return; */
	for(var i=0; i<grid_array;i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == "1")
		{
			row_idx=row_idx+i;
			cnt = cnt+1;
		}
	}
	if (cnt < 1) {
		alert("선택된 항목이 없습니다.");	
		return;
	}
	if (cnt > 1) {
		alert("하나의 항목만 선택할 수 있습니다.");	
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_FLAG)=="Y"){
		alert("행삽입후 등록한 결재경로가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,GridObj.GetRowCount()-1,INDEX_SIGN_PATH_NAME).length < 1) {
		alert("결재경로명은 필수 입력입니다.");
		return;
	}

	/* GridObj.SetParam("mode", "setInsert");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelInsert&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_list",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doUpdate() {
	
	var wise = GridObj;

	/* var row_idx = checkedOneRow(INDEX_SELECTED);
	if (row_idx < 0) return; */
	var grid_array = GridObj.GetRowCount();
	var cnt=0;
	var row_idx=0;
	for(var i=0; i<grid_array;i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == "1")
		{
			row_idx=row_idx+i;
			cnt = cnt+1;
		}
	}
	if (cnt < 1) {
		alert("선택된 항목이 없습니다.");	
		return;
	}
	if (cnt > 1) {
		alert("하나의 항목만 선택할 수 있습니다.");	
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_FLAG)!="Y"){
		alert("등록된  결재경로가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,GridObj.GetRowCount()-1,INDEX_SIGN_PATH_NAME).length < 1) {
		alert("결재경로명은 필수 입력입니다.");
		return;
	}

	/* GridObj.SetParam("mode", "setUpdate");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelUpdate&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_list",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doDelete() {
	var wise = GridObj;
	var grid_array = GridObj.GetRowCount();
	var cnt=0;
	for(var i=0; i<grid_array;i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == "1")
		{
			cnt = cnt+1;
		}
	}
	if (cnt < 1) {
		alert("선택된 항목이 없습니다.");	
		return;
	}
	/* var row_idx = checkedDataRow(INDEX_SELECTED);
	if (row_idx < 1) return; */
	
	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;

	/* GridObj.SetParam("mode", "setDelete");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelDelete&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_list",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function JavaCall(msg1,msg2, msg3, msg4,msg5) {

	var wise = GridObj;
	
    for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	}
		
	if(msg1=="doData"){
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);
		
		if(mode == "setInsert")
		{
			alert(GridObj.GetMessage());
		}else if(mode == "setUpdate")
		{
			alert(GridObj.GetMessage());
		}else if(mode == "setDelete")
		{
			alert(GridObj.GetMessage());
		}  
		doSelect();
	}
	if(msg1 == "doQuery"){
	}
	if( msg1 == "t_imagetext" ) {

		if (msg3 == INDEX_SIGN_PATH){
			SIGN_PATH_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_SIGN_PATH_NO);
			if (SIGN_PATH_NO == ""){
				alert("결재경로 번호가 지정 되어 있어야지만 결재 경로를 만들수 있습니다.");
				return;
			}
			<%  
			if ( !flag.equals("S")) { //이화면이 팝업화면으로 쓰일경우 결재순서 상세정보 화면은 조회 용도로 쓴다. gubun=S (select) 를 사용
			%>
				var url = "/kr/admin/basic/approval2/ap2_pp_lis1.jsp?SIGN_PATH_NO="+SIGN_PATH_NO+"&GUBUN=S";
			<% 
			} else { 
			%>
				var url = "/kr/admin/basic/approval2/ap2_pp_lis1.jsp?SIGN_PATH_NO="+SIGN_PATH_NO;
			<% 
			} 
			%>
			CodeSearchCommon(url,'BKWin','550','800','800','460');
		}

		if (msg3 == INDEX_SIGN_REMARK)
		{
			var SIGN_REMARK = GD_GetCellValueIndex(GridObj,msg2,INDEX_SIGN_REMARK);
			<%  
			if ( flag.equals("P")) { //이화면이 팝업화면으로 쓰일경우 결재상신 화면은 조회 용도로 쓴다. gubun=O (Only select) 를 사용
			%>
				var url = "/kr/admin/basic/approval2/ap2_pp_lis2.jsp?ROW="+msg2+"&SIGN_REMARK="+SIGN_REMARK+"&GUBUN=O";
			<% 
			} else { 
			%>
				var url = "/kr/admin/basic/approval2/ap2_pp_lis2.jsp?ROW="+msg2+"&SIGN_REMARK="+SIGN_REMARK;
			<% 
			} 
			%>
			CodeSearchCommon(url,'BKWin','250','600','600','160');
		}
	}

	<%  
	if ( flag.equals("P")) { 
	%>
		if(msg3 == INDEX_SELECTED){
			max_row = GridObj.GetRowCount();
			oneSelect(max_row, msg2);
		}
	<% 
	} 
	%>
}

function oneSelect(max_row, msg2)
{
	for(var i=0;i<max_row;i++)
	{
		if ( i != msg2 ) {
			GD_SetCellValueIndex(GridObj,i,INDEX_SELECTED,"false", "&");
		}
	}
}

function Select()
{
	var row_idx = checkedOneRow(INDEX_SELECTED);
	if (row_idx < 0) return;

	var SIGN_PATH_NO 	= GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_PATH_NO);
	var SIGN_REMARK 	= GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_REMARK);

	parent.opener.Query(SIGN_PATH_NO, SIGN_REMARK);

	window.close();
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}
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

function doOnRowSelected(rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
    if(header_name=="SIGN_PATH_IMG"){
		//var flag1 = GridObj.cells(rowId, GridObj.getColIndexById("flag1")).getValue();
		var SIGN_PATH_NO = GD_GetCellValueIndex(GridObj,rowId-1,INDEX_SIGN_PATH_NO);
		if (SIGN_PATH_NO == ""){
			alert("등록한 후 결재경로를 지정할 수 있습니다.");
			return;
		}
		<%  
		if ( !flag.equals("S")) { //이화면이 팝업화면으로 쓰일경우 결재순서 상세정보 화면은 조회 용도로 쓴다. gubun=S (select) 를 사용
		%>
			var url = "/approval/ap_channel_insert.jsp?SIGN_PATH_NO="+SIGN_PATH_NO+"&GUBUN=S&HIDDEN_FLAG="+flag;
		<% 
		} else { 
		%>
			var url = "/approval/ap_channel_insert.jsp?SIGN_PATH_NO="+SIGN_PATH_NO+"&HIDDEN_FLAG="+flag;
		<% 
		} 
		%>
		CodeSearchCommon(url,'BKWin','550','800','800','460');
    }
}


function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
   
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}


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

    if(status == "true") {
        alert(messsage);
        doSelect();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
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

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

  
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onkeydown='entKeyDown()'>

<s:header>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<%  if (! flag.equals("P")) { %>
	  		<td class="cell_title1" width="78%" align="left">
	  			<%@ include file="/include/sepoa_milestone.jsp" %>
	  		</td>
		<% } else { %>
			<td class="cell_title1" width="78%" align="left">
				<%@ include file="/include/sepoa_milestone.jsp" %>
			</td>
		<% } %>
		</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
  	<form name="form1" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">  	
  	<input type="hidden" name="insert_flag" id="insert_flag"  value="off">
		<tr>
	  		<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재경로번호</td>
	  		<td class="data_td" width="35%">
				<input type="text" size="20" value="" name="SIGN_PATH_NO" id="SIGN_PATH_NO" style="ime-mode:inactive" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 결재경로명</td>
	  		<td class="data_td" width="35%">
				<input type="text" size="20" value="" name="SIGN_PATH_NAME" id="SIGN_PATH_NAME" class="inputsubmit">
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
   					<TD><script language="javascript">btn("javascript:doSelect()","조회")</script></TD>
				<%  if ( flag.equals("S")) { %>    	  			
   					<TD><script language="javascript">btn("javascript:Line_insert()","행삽입")</script></TD>
   					<TD><script language="javascript">btn("javascript:doInsert()","등 록")</script></TD>
   					<TD><script language="javascript">btn("javascript:doUpdate()","수 정")</script></TD>
   					<TD><script language="javascript">btn("javascript:doDelete()","삭 제")</script></TD>
    	  		<% } else if (flag.equals("P")){  %>
   					<TD><script language="javascript">btn("javascript:Select()","선 택")</script></TD>
		   		<% } %>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>				
  	
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="AP_006" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
<iframe name="cws" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</html>


