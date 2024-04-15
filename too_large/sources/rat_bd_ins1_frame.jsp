<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
// 	Vector multilang_id = new Vector();
// 	multilang_id.addElement("AU_005_1");
// 	multilang_id.addElement("BUTTON");
// 	multilang_id.addElement("MESSAGE");
	
// 	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
// 	String screen_id = "AU_005_1";
// 	String grid_obj  = "GridObj";
// 	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rat_bd_upd1_frame.jsp -->
<!--
 Title:        역경매입찰프레임  <p>
 Description:  역경매입찰화면을 프레임으로 나눈부분 <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      
!-->


<% //PROCESS ID 선언 %>
<%-- <% String WISEHUB_PROCESS_ID="AU_005_1";%> --%>
<%-- <% String WISEHUB_LANG_TYPE="KR";%> --%>
<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>
<%-- <%@ include file="/include/wisetable_scripts.jsp"%> --%>

<%
    String ra_no		= JSPUtil.nullToEmpty(request.getParameter("ra_no"));
    String ra_count		= JSPUtil.nullToEmpty(request.getParameter("ra_count"));
    String irs_no		= JSPUtil.nullToEmpty(request.getParameter("irs_no"));
    String vendor_code  = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
    String endDate      = JSPUtil.nullToEmpty(request.getParameter("endDate"));
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%-- <%@ include file="/include/sepoa_grid_common.jsp"%> --%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<frameset rows="100%,0" frameborder="NO" border="0" framespacing="0" cols="*"> 

  <frame name="topFrame" noresize src="rat_bd_ins1.jsp?ra_no=<%=ra_no%>&ra_count=<%=ra_count%>&irs_no=<%=irs_no%>&vendor_code=<%=vendor_code%>&endDate=<%=endDate%>">
  <frame name="bottomFrame">
</frameset>
<noframes> 
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
        doQuery();
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" text="#000000">

<s:header popup="true">
<!--내용시작-->
</body>
</noframes> 
</html>

</s:header>
<%-- <s:grid screen_id="AU_005_1" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>


