<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_007";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.nullToEmpty(info.getSession("COMPANY_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	String SIGN_PATH_NO = JSPUtil.nullToEmpty(request.getParameter("SIGN_PATH_NO"));
	String GUBUN        = JSPUtil.nullToEmpty(request.getParameter("GUBUN"));  //이화면이 조회용도로만 쓰일지 아닐지 구분한다.
	String HIDDEN_FLAG  = JSPUtil.nullToEmpty(request.getParameter("HIDDEN_FLAG"));//돋보기이미지 보일지 구분하는 값
	
	
	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	String TITLE = "결재경로 상세정보";

%>

<%
	
	//String COMBO_M002     = LB.Table_ListBox(request, "SL0022", info.getSession("HOUSE_CODE") + "#M119" , "#" , "@");
	/* SepoaListBox LB = new SepoaListBox();
	String COMBO_M002     = LB.Table_ListBox(request, "SL0022", info.getSession("HOUSE_CODE") + "#M119" , "#" , "@"); */
	/* SepoaFormater sf = new SepoaFormater(value.result[0]); 
	for (int i = 0; i < sf.getRowCount(); i++) {
		
	} */
%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<html>
	<head>
		<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		<Script language="javascript" type="text/javascript">

<%-- var G_SERVLETURL = "<%=getWiseServletPath("admin.basic.approval2.ap2_pp_lis1")%>"; --%>

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";
var HIDDEN_FLAG	 = "<%=HIDDEN_FLAG%>";

var INDEX_SELECTED                = "" ;
var INDEX_SIGN_PATH_SEQ           = "" ;
var INDEX_USER_NAME_LOC           = "" ;
var INDEX_USER_POP                = "" ;
var INDEX_DEPT_NAME               = "" ;
var INDEX_POSITION                = "" ;
var INDEX_MANAGER_POSITION_NAME   = "" ;
var INDEX_PROCEEDING_FLAG         = "" ;
var INDEX_SIGN_USER_ID            = "" ;
var INDEX_SIGN_PATH_NO            = "" ;
var INDEX_POSITION                = "" ;
var INDEX_MANAGER_POSITION        = "" ;
var INDEX_FALG			          = "" ;
var INDEX_USER_ID				  = "" ;

function Init() {
setGridDraw();
setHeader();
	doSelect();
}

function setHeader() {

	/* GridObj.AddHeader(             "SIGN_PATH_NO"         ,    "","t_text",1010,0,false);
	GridObj.AddHeader(             "POSITION"             ,    "","t_text",1010,0,false);
	GridObj.AddHeader(             "MANAGER_POSITION"     ,    "","t_text",1010,0,false);
	GridObj.AddHeader(             "FLAG"     			   ,    "","t_text",1010,0,false); */
	

	INDEX_SELECTED                = GridObj.GetColHDIndex("SELECTED"        		) ;
	INDEX_SIGN_PATH_SEQ           = GridObj.GetColHDIndex("SIGN_PATH_SEQ"   		) ;
	INDEX_USER_NAME_LOC           = GridObj.GetColHDIndex("USER_NAME_LOC"   		) ;
	INDEX_USER_POP                = GridObj.GetColHDIndex("USER_POP"        		) ;
	INDEX_DEPT_NAME               = GridObj.GetColHDIndex("DEPT_NAME"       		) ;
	INDEX_POSITION_NAME           = GridObj.GetColHDIndex("POSITION_NAME"        ) ;
	INDEX_MANAGER_POSITION_NAME   = GridObj.GetColHDIndex("MANAGER_POSITION_NAME") ;
	INDEX_PROCEEDING_FLAG         = GridObj.GetColHDIndex("PROCEEDING_FLAG" 		) ;
	INDEX_SIGN_USER_ID            = GridObj.GetColHDIndex("SIGN_USER_ID"    		) ;
	INDEX_SIGN_PATH_NO            = GridObj.GetColHDIndex("SIGN_PATH_NO"    		) ;
	INDEX_POSITION                = GridObj.GetColHDIndex("POSITION"        		) ;
	INDEX_MANAGER_POSITION        = GridObj.GetColHDIndex("MANAGER_POSITION"		) ;
	INDEX_FLAG				      = GridObj.GetColHDIndex("FLAG"					) ;
	INDEX_USER_ID				  = GridObj.GetColHDIndex("USER_ID"				) ;
	if(HIDDEN_FLAG=="D"){
		GridObj.setColumnHidden( GridObj.getColIndexById( "USER_POP" ), true );
	}
	
}


function doSelect() {
	var wise = GridObj;
	var F = document.forms[0];
	F.insert_flag.value = "off";
	
	<%-- GridObj.SetParam("mode", "getMaintain");
	GridObj.SetParam("SIGN_PATH_NO", "<%=SIGN_PATH_NO%>");
	
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti";

	opener.doSelect(); --%>
	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getChannelList&grid_col_id="+grid_col_id;
		param += "&SIGN_PATH_NO=<%=SIGN_PATH_NO%>";
	    param += dataOutput();
	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_insert";
	GridObj.post(url, param);
	GridObj.clearAll(false);	 
}

function Line_insert() {
	var wise = GridObj;
	var insert_flag = document.forms[0].insert_flag.value;

	if (GridObj.GetRowCount() > 13)
	{
		alert("결재경로는 14단계 까지 입니다.");
		return;
	}

	for(var i=0; i<GridObj.GetRowCount();i++) {
		GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&");
	}

	if(insert_flag == "off") {
		<%-- GridObj.AddRow();
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, "true&", "&");
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_USER_POP, "/kr/images/button/query.gif&&", "&");
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_PROCEEDING_FLAG, "<%= COMBO_M002 %>", "#", "@", 0);
	
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SIGN_PATH_NO, "<%=SIGN_PATH_NO%>"); --%>
		dhtmlx_last_row_id++;
		
		var nMaxRow2 = dhtmlx_last_row_id;
		var row_data = "<%=grid_col_id%>";
		
		GridObj.enableSmartRendering(true);
		GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
		GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("USER_POP")).setValue("/images/icon/icon_data_a.gif");
		<%-- GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_PROCEEDING_FLAG, "<%= COMBO_M002 %>", "#", "@", 0); --%>
		<%-- GridObj.cells(nMaxRow2, GridObj.getColIndexById("PROCEEDING_FLAG")).setValue("<%= COMBO_M002 %>"); --%>
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("PROCEEDING_FLAG")).setValue("P");
		dhtmlx_before_row_id = nMaxRow2;
		
		document.forms[0].insert_flag.value = "on";
	}else {
		alert("한줄씩만 생성 가능합니다.");
		GridObj.cells(dhtmlx_last_row_id, GridObj.getColIndexById("SELECTED")).setValue("1");
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, "true&", "&");
	}

}

function Line_Delete() {
	
	var wise = GridObj;
  	var cnt=0;
  	//if (!checkedDataRow(INDEX_SELECTED)) return;
  	var grid_array_1 = GridObj.GetRowCount();
  	
  	for(var i=0; i<grid_array_1;i++)
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
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	for(var i=0; i < grid_array.length;i++) {
	
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
			
				GridObj.deleteRow2(grid_array[i]);
				//GridObj.DeleteRow(i);
			
	}
	document.forms[0].insert_flag.value = "off";
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}

function doInsert() {
	
	if( !checkRows() ) return;
	
	var wise = GridObj;

	var cnt=0;
	var row_idx=0;
  	//if (!checkedDataRow(INDEX_SELECTED)) return;
  	var grid_array = GridObj.GetRowCount();
  	var rowCount = GridObj.GetRowCount();
  	for(var i=0; i<grid_array;i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED);
		if(temp == "1")
		{
			row_idx=row_idx+i;
			cnt = cnt+1;
		}
	}
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_FLAG)=="Y"){
		alert("행삽입후 등록한 결재자가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,GridObj.GetRowCount()-1,INDEX_USER_NAME_LOC).length < 1) {
		alert("결재자를 선택하여야 합니다.");
		return;
	}

	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_PROCEEDING_FLAG)==""){
		alert("요청상태를 선택하여 주세요.");
		return;
	}
	
	for(var i=0; i<GridObj.GetRowCount(); i++) {
		if(row_idx != i && GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_USER_ID) == GD_GetCellValueIndex(GridObj,row_idx-1,INDEX_SIGN_USER_ID) ) {
			alert("같은 결재자가 존재합니다.");
			return;
		}
	}
	/* GridObj.SetParam("mode", "setInsertSignPath");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelInsert&cols_ids="+grid_col_id+"&sign_path_no="+<%=SIGN_PATH_NO%>;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doUpdate() {
	var wise = GridObj;
	
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
		alert("등록된  결재자가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_USER_NAME_LOC).length < 1) {
		alert("결재자를 선택하여야 합니다.");
		return;
	}
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_USER_ID) != "<%=user_id%>" ){
		alert("작성자가 다르면 수정할수 없습니다");
		return;
	}
	for(var i=0; i<GridObj.GetRowCount(); i++) {
		if(row_idx != i && GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_USER_ID) == GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_USER_ID) ) {
			alert("같은 결재자가 존재합니다.");
			return;
		}
	}	
	for(var i=0; i<GridObj.GetRowCount(); i++) {
		if(row_idx != i && GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_PATH_SEQ) == GD_GetCellValueIndex(GridObj,i,INDEX_SIGN_PATH_SEQ) ) {
			alert("같은 차수가 존재합니다.");
			return;
		}
	}
	
	/* GridObj.SetParam("mode", "setUpdateSignPath");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelUpdate&cols_ids="+grid_col_id+"&sign_path_no=<%=SIGN_PATH_NO%>";
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doDelete() {
	var wise = GridObj;

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
	
	// 결재순서 값을 체크해서 없으면 알림창 메세지 띄움
	if( GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_PATH_SEQ) == null || GD_GetCellValueIndex(GridObj,row_idx,INDEX_SIGN_PATH_SEQ) == "" ) {
		alert('등록되지 않은 건은 삭제 대신 결재자삭제를 하셔야 합니다.');
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_USER_ID) != "<%=user_id%>" ){
		alert("작성자가 다르면 삭제할수 없습니다");
		return;
	}	
	
	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;

	/* GridObj.SetParam("mode", "setDeleteSignPath");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(G_SERVLETURL, "ALL", "ALL"); */
	var params ="mode=setChannelDelete&cols_ids="+grid_col_id+"&sign_path_no=<%=SIGN_PATH_NO%>";
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_channel_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function JavaCall(msg1,msg2, msg3, msg4,msg5) {
	document.forms[0].row.value = msg2;
	var wise = GridObj;
	if(msg1=="doData"){
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);
		
		if(mode == "setInsertSignPath")
		{
			alert(GridObj.GetMessage());
		}else if(mode == "setUpdateSignPath")
		{
			alert(GridObj.GetMessage());
		}else if(mode == "setDeleteSignPath")
		{
			alert(GridObj.GetMessage());
		}  
		doSelect();
	}
	if( msg1 == "t_imagetext" ) {

<%      if ("".equals(GUBUN)){   %>
		document.forms[0].row.value = msg2;
		url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0210&function=getUser&values=<%=house_code%>&values=<%=company_code%>&values=&values=/&desc=ID&desc=이름";
		CodeSearchCommon(url,'getUser','','','','');
		//Code_Search
<%						}	%>
	}
}

function getUser(user_id , user_name, dept, posi, manage_posi,posi_code, manage_posi_code){
	row = document.forms[0].row.value;
	
	var count = 0;
	var wise = GridObj;
	
	if('<%=info.getSession("ID")%>' == user_id) {
		alert("본인은 결재경로에 추가할 수 없습니다.");
		
		return;
	}

	for(var i=0; i<GridObj.GetRowCount();i++) {

		var temp = GD_GetCellValueIndex(GridObj,i,GridObj.getColIndexById("SIGN_USER_ID"));

		if(temp == user_id) {
			alert("이미 지정되어있는 차기결재자 입니다.");
			
			return;
		}
	}
	
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("USER_NAME_LOC"),         user_name);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("DEPT_NAME"),             dept);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("POSITION_NAME"),         posi);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("MANAGER_POSITION_NAME"), manage_posi);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("SIGN_USER_ID"),          user_id);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("POSITION"),              posi_code);
	GD_SetCellValueIndex(GridObj, row, GridObj.getColIndexById("MANAGER_POSITION"),      manage_posi_code);
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}
</script>




<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
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
function doOnRowSelected(rowId, cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
    if(header_name=="USER_POP"){
    	document.forms[0].row.value = GridObj.getRowIndex(rowId);
    	
    	window.open("/common/CO_008.jsp?callback=getUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>
<s:header popup="true">
<!--내용시작-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>결재자 목록
	</td>
</tr>
</table>

<form name="form1" method="post" action="">
  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
		      			<!-- 2011.3.24 solarb 조회 버튼 삭제  display:none -->
	    	  			<TD style="display:none"><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
				<% 
				if ("".equals(GUBUN))  { 
				%>
						<TD><script language="javascript">btn("javascript:Line_insert()","결재자추가")   </script></TD>
						<TD><script language="javascript">btn("javascript:Line_Delete()","결재자삭제")</script></TD>
						<TD><script language="javascript">btn("javascript:doInsert()","등 록")   </script></TD>
						<TD style="display:none;"><script language="javascript">btn("javascript:doUpdate()","수 정")   </script></TD>												
						<TD><script language="javascript">btn("javascript:doDelete()","삭 제")   </script></TD>																		
				<%
				} 
				%>						
		      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
   	<input type="hidden" name="insert_flag" id="insert_flag" value="">
   	<input type="hidden" name="row" id="row" value="">
	
</form>
</s:header>
<s:grid screen_id="AP_007" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


