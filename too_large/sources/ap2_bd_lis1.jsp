<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T05");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T05";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="PR_T05";%>

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
		<%-- Dhtmlx SepoaGrid용 JSP--%>
		<%@ include file="/include/sepoa_grid_common.jsp"%>
		<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
		<%-- Ajax SelectBox용 JSP--%>
		<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
		
		<Script language="javascript" type="text/javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.approval2.ap2_bd_lis1";

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
	doSelect();
}
	
function setHeader() {
	
	/* GridObj.AddHeader("FLAG"     		,   "","t_text",20,0,false);
	
	
	
	GridObj.SetDateFormat("ADD_DATE",   "yyyy/MM/dd");
	GridObj.SetDateFormat("CHANGE_DATE",   "yyyy/MM/dd"); */


	INDEX_SELECTED        = GridObj.GetColHDIndex("SELECTED");
	INDEX_SIGN_PATH_NAME  = GridObj.GetColHDIndex("SIGN_PATH_NAME");
	INDEX_SIGN_PATH_NO    = GridObj.GetColHDIndex("SIGN_PATH_NO");
	INDEX_SIGN_PATH       = GridObj.GetColHDIndex("SIGN_PATH");
	INDEX_SIGN_REMARK     = GridObj.GetColHDIndex("SIGN_REMARK");
	INDEX_FLAG			  = GridObj.GetColHDIndex("FLAG") ;
	
	// 2011.3.24 solarb 결제경로관리메뉴를 선택시 디폴트로 기본조회 되도록 doSelect(); 메소드 추가
	//doSelect();
}


function doSelect() {
	//var wise = GridObj;
	var F = document.forms[0];
	F.insert_flag.value = "off";
	
	sign_path_no = F.sign_path_no.value;
	sign_path_name = F.sign_path_name.value;

/* 	GridObj.SetParam("mode", "getMaintain");
	GridObj.SetParam("flag", flag);
	GridObj.SetParam("SIGN_PATH_NO", SIGN_PATH_NO);
	GridObj.SetParam("SIGN_PATH_NAME", SIGN_PATH_NAME);
	
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; */
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getMaintain";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
	
}

/* JTable 에서 생성할 수 있도록 화면 전환이 된다.*/
function Line_insert() {
	var wise = GridObj;
	var insert_flag = document.forms[0].insert_flag.value;

	for(var i=0; i<GridObj.GetRowCount();i++) {
		GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&"); //check_box true 로 setting
	}

	if(insert_flag == "off") {
		GridObj.AddRow();
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, 	"true&", 						"&"); //check_box true 로 setting
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SIGN_PATH, 	"/kr/images/button/query.gif&", "&");
		GridObj.AddImageList("SIGN_PATH","/kr/images/button/query.gif");	
		GridObj.SetCellImage("SIGN_PATH",GridObj.GetRowCount()-1,0);
		GridObj.SetCellValueIndex(INDEX_SIGN_PATH,GridObj.GetRowCount()-1,'');
		//GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SIGN_REMARK, 	"/kr/images/button/query.gif&", "&");
		GridObj.AddImageList("SIGN_REMARK","/kr/images/button/query.gif");	
		GridObj.SetCellImage("SIGN_REMARK",GridObj.GetRowCount()-1,0);
		GridObj.SetCellValueIndex(INDEX_SIGN_REMARK,GridObj.GetRowCount()-1,'');
		document.forms[0].insert_flag.value = "on";
	}else {
		alert("한줄씩만 생성 가능합니다.");
		GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SELECTED, "true&", "&"); //check_box true 로 setting
	}
	;
}

function doInsert() {
	
	var wise = GridObj;

	var row_idx = checkedOneRow(INDEX_SELECTED);
	if (row_idx < 0) return;

	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_FLAG)=="Y"){
		alert("행삽입후 등록한 결재경로가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,GridObj.GetRowCount()-1,INDEX_SIGN_PATH_NAME).length < 1) {
		alert("결재경로명은 필수 입력입니다.");
		return;
	}

	GridObj.SetParam("mode", "setInsert");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
}

function doUpdate() {
	
	var wise = GridObj;
	;

	var row_idx = checkedOneRow(INDEX_SELECTED);
	if (row_idx < 0) return;

	if(GD_GetCellValueIndex(GridObj,row_idx,INDEX_FLAG)!="Y"){
		alert("등록된  결재경로가 아닙니다.");
		return;
	}
	
	if(GD_GetCellValueIndex(GridObj,GridObj.GetRowCount()-1,INDEX_SIGN_PATH_NAME).length < 1) {
		alert("결재경로명은 필수 입력입니다.");
		return;
	}

	GridObj.SetParam("mode", "setUpdate");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
}

function doDelete() {
	var wise = GridObj;

	var row_idx = checkedDataRow(INDEX_SELECTED);
	if (row_idx < 1) return;
	
	var anw = confirm("삭제하시겠습니까?");
	if(anw == false) return;

	GridObj.SetParam("mode", "setDelete");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");	
}

function JavaCall(msg1,msg2, msg3, msg4,msg5) {

	var wise = GridObj;
	
    /* for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	} */
		
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
	var row_idx = checkedOneRow("SELECTED");
	if (row_idx < 0) return;
	
	var SIGN_PATH_NO 	= GD_GetCellValueIndex(GridObj,parseInt(row_idx)-1,INDEX_SIGN_PATH_NO);
	var SIGN_REMARK 	= GD_GetCellValueIndex(GridObj,parseInt(row_idx)-1,INDEX_SIGN_REMARK);

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
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
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
    	if(GridObj.getColIndexById("SELECTED") == cellInd){
	    	if(max_value == "1"){
	    		for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
	    			GridObj.cells(GridObj.getRowId(i), cellInd).wasChanged=false;
	    			GridObj.cells(GridObj.getRowId(i), cellInd).setValue("0");    			
	    		}
    			GridObj.cells(rowId, cellInd).wasChanged=true;
    			GridObj.cells(rowId, cellInd).setValue("1");    			
	    	}
    	}
    	
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>

<!--내용시작-->
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header popup="true">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<%  if (! flag.equals("P")) { %>
	  		<td class="cell_title1" width="78%" align="left">&nbsp;
	  			<%@ include file="/include/sepoa_milestone.jsp" %>
			</td>	  			
		<% } else { %>
			<td height="20" align="left" class="title_page" vAlign="bottom">결재관리 > 결재경로 > 결재경로현황</td>
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
  	<input type="hidden" name="insert_flag" id="insert_flag" value="off">
		<tr>
	  		<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재경로 번호</td>
	  		<td class="data_td" width="35%">
				<input type="text" size="20" value="" name="sign_path_no" id="sign_path_no" style="ime-mode:inactive" class="inputsubmit">
	  		</td>
	  		<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결재경로 명</td>
	  		<td class="data_td" width="35%">
				<input type="text" size="20" value="" name="sign_path_name" id="sign_path_name" class="inputsubmit">
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
	  		<td></td>
		</tr>
  	</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
   					<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
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
<s:grid screen_id="PR_T05" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
<iframe name="ibody" frameborder="0" marginheight="0" marginwidth="0"></iframe>
</html>


