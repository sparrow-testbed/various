<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_139");
	multilang_id.addElement("MESSAGE");
	
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
    // Dthmlx Grid 전역변수들..
	String screen_id = "AD_139";
	String grid_obj  = "GridObj";
	
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;	
    
	String language = info.getSession("LANGUAGE"); 
	String user_type = info.getSession("USER_TYPE");
	
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	String DEPT 			= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("DEPT")));
	String DEPT_NAME 		= JSPUtil.CheckInjection(JSPUtil.nullToEmpty(request.getParameter("DEPT_NAME")));
	 
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    }

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }

    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");
		
		if(status == "false") alert(msg);
		return true;
    }

	// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
		var header_name = GridObj.getColumnId(cellInd);
		
		
	
			var user_id = GridObj.cells(rowId, GridObj.getColIndexById("USER_ID")).getValue();	//사번
			var user_name = GridObj.cells(rowId, GridObj.getColIndexById("USER_NAME_LOC")).getValue();	//이름
			
			//var posi = GridObj.cells(rowId, GridObj.getColIndexById("POSITION_NAME")).getValue();	//직위
			//var posi_code = GridObj.cells(rowId, GridObj.getColIndexById("POSITION")).getValue();	//직위코드
			
			//var manage_posi = GridObj.cells(rowId, GridObj.getColIndexById("MANAGER_POSITION_NAME")).getValue();	//직책
			//var manage_posi_code = GridObj.cells(rowId, GridObj.getColIndexById("MANAGER_POSITION")).getValue();	//직책코드
			
			//parent.getUser( user_id , user_name, "<%=DEPT%>","<%=DEPT_NAME%>",posi, posi_code, manage_posi, manage_posi_code );
			parent.getUser( user_id , user_name, "<%=DEPT%>","<%=DEPT_NAME%>"  );
			
		
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

	// 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{	 
		var grid_col_id = "<%=grid_col_id%>";
		
		var user_id = form.user_id.value;
		var user_name = form.user_name.value;
		var param = ""; 
		    param += "&user_id="		+ encodeUrl(user_id);
		    param += "&user_name="		+ encodeUrl(user_name);
		 
		GridObj.loadXML("<%=POASRM_CONTEXT_NAME%>/servlets/contract.approval_user?mode=query&grid_col_id="+grid_col_id+param);																						
  		GridObj.clearAll(false);	 
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

	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		
		//document.getElementById("message").innerHTML = messsage;

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
	 
</script>
</head>
<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<s:header popup="true">
<form id="form" name="form">
	<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%"  class="se_cell_title">사번</td>
        		<td width="30%"  class="se_cell_data">
        			<input type="text" name="user_id"  size="10" maxlength="30"> 
        		</td> 
        		<td width="20%"  class="se_cell_title">이름</td>
        		<td width="30%"  class="se_cell_data">
        			<input type="text" name="user_name"  size="10" maxlength="30" style="ime-mode:active"> 
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
					  	  <td><script language="javascript">btn("javascript:doQuery()","조회")</script></td> 
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE> 
			  <s:grid screen_id="AD_139" grid_box="gridbox" grid_obj="GridObj"/>
<!-- 		<div id="gridbox" name="gridbox" width="100%" style="background-color:white;overflow:hidden"></div> -->
<!--         <div id="pagingArea"></div> -->
<%--         <%@ include file="/include/include_bottom.jsp"%>  --%>
</form>
</s:header>
<s:footer/>
</body>
</html>
