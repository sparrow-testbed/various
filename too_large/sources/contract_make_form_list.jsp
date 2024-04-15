<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_010";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	String cont_no	     = JSPUtil.nullToEmpty(request.getParameter("cont_no")).trim();
	String cont_gl_seq   = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")).trim();
	String cont  	     = JSPUtil.nullToEmpty(request.getParameter("cont")).trim();
	String ele_cont_flag = JSPUtil.nullToEmpty(request.getParameter("ele_cont_flag")); // 전자계약서작성여부 ( Y : 전자계약 , N : 오프라인계약 )
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_make_form_list";

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
			doQuery();
		} else {
			alert(messsage);
		}

		return false;
	}

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if( header_name == "CONT_FORM_NAME")
		{
			var	cont_form_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FORM_NO")).getValue());	
				
			if(cont_form_no != ''){
				
//				contract_form_regist_detail.jsp
				
				popUpOpen("contract_form_regist_detail.jsp?view=Y&flag=Y&cont_form_no="+cont_form_no, 'PR_REQ_DETAIL', '1000', '800');
			}
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
			return true;
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
		var param  = "&cont="  + encodeUrl("<%=cont%>");
		
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=doQuery&grid_col_id="+grid_col_id + param;
		GridObj.post(SERVLETURL);
		GridObj.clearAll(false);
	}

	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택해 주세요.");
		return false;
	}
	
	function doChoice() {
		var cont_form_no = "";
		var checked_count = 0;
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++)
		{
			checked_count++;
			
			cont_form_no   = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_FORM_NO")).getValue()));
		}
		
        if(checked_count > 1){
            alert(G_MSS2_SELECT);
            return;
        }
		
		location.href = "contract_make_insert.jsp?flag=Y&cont_form_no=" + cont_form_no + "&cont_no=" + "<%=cont_no%>" + "&ele_cont_flag=" + "<%=ele_cont_flag%>" + "&cont_gl_seq=" + "<%=cont_gl_seq%>";	

		//if (confirm("선택한 목록으로 전자계약서를 작성하시겠습니까?")){
		//	opener.location.href = "contract_make_insert.jsp?cont_form_no="+ cont_form_no +"&cont_no="+ "<%=cont_no%>";
		//	window.close();
		//}
	}

	function goPage() {
		location.href = "contract_create_list.jsp";
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();doQuery();">
<s:header>
<form name="form">
    <%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			  <TR>
				<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doChoice()","선택")</script></td>
					  	  <td><script language="javascript">btn("javascript:goPage()","목록")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			</td>
		  </tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="CT_010" grid_box="gridbox" grid_obj="GridObj"/>
<s:footer/>	
</body>