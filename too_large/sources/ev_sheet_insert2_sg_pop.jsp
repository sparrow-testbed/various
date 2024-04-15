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
	multilang_id.addElement("WO_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");
	String ev_no 		= JSPUtil.nullToEmpty(request.getParameter("ev_no"));
	String ev_year 		= JSPUtil.nullToEmpty(request.getParameter("ev_year"));

	// Dthmlx Grid 전역변수들..
	String screen_id = "WO_005";
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
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.MyJsp27"; //바꿔
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;

	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
		doQuery();
	
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
		
		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	
	//조회
	function doQuery(){
	
		var grid_col_id = "<%=grid_col_id%>";
		
		var param = "";
		
		param += "&ev_no="+"<%=ev_no%>";
		param += "&ev_year="+"<%=ev_year%>";
	
		

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_sheet_basic?mode=query&grid_col_id="+grid_col_id+ param);
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
		
		if(status == "true") {
			alert(messsage);
			doQuery();
		} else {
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
   
    	
</Script>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();">
<s:header popup="true">
<form id="form" name="form" method="post" action="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
		<input type="hidden" id="ev_year_p" name="ev_year_p"  size="15" readonly="readonly" class="input_empty" value="<%=ev_year%>" >
    </tr>
    <tr>
    	<td width="100%" valign="top">
			
		</td>
	</tr>
</table>
</form>
</s:header>
<s:grid screen_id="WO_005" grid_obj="GridObj" grid_box="gridbox" />
<s:footer/>
</body>
</html>
