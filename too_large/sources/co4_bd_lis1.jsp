<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("VR_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "VR_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String house_code =info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<link rel="stylesheet" href="../../../css/body.css" type="text/css">

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script type="text/javascript">
function Init() {
setGridDraw();
setHeader();
	Query();
}

function setHeader() {
	 
}

function Query() {
 
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.code.co4_lis1";
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getBdAnnVersion";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( servletUrl, params );
	GridObj.clearAll(false);
}
 
   
/* 어떤 항목을 수정하고 체크한뒤 수정버튼을 누르면 DB에 반영된다.*/
function Change() {
	var wise = GridObj;
	var chg_row = "";

	for(var i=0; i<GridObj.GetRowCount();i++) {
		var temp = GD_GetCellValueIndex(GridObj,i,0);
		if(temp == true) chg_row += i + "&" ;
	}

	if(chg_row == "") alert("선택된 로우가 없습니다.");
	else {
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/admin.basic.code.co4_lis1";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setBdAnnVersion";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);		
	}
}
 

function JavaCall(msg1,msg2, msg3, msg4,msg5) {
	if(msg1=="doData") Query();
 
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Query();
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
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
        Query();
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
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<form name="form1" method="post" action="">
<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td></td>
    </tr>
</table>  
<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR> 
	      			<TD><script language="javascript">btn("javascript:Change()","수 정")</script></TD> 
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2">
	<tr>
		<td height="30" align="center">
			<s:grid screen_id="VR_001" grid_obj="GridObj" grid_box="gridbox"/>
		</td>
    </tr>
    <tr>
	    <td height="30" align="left">
	    <br>
		  <b><font color=red>*공고문버전 수정시 주의사항*</font><br>
		  1.&nbsp;Admin > 공고문관리 >구매/공사공고문화면에서 copy로 복사본을 생성합니다.<br>
		  2.&nbsp;새로 생성된 공고문을 수정합니다.<br>  
		  &nbsp;&nbsp;&nbsp;소스위치>입찰공고문<br>
		  &nbsp;&nbsp;&nbsp;kr/dt/bidd/ebd_bd_ins1_버전.jsp<br>
		  &nbsp;&nbsp;&nbsp;s_kr/bidding/bidd/ebd_bd_dis2_버전.jsp<br>
		  &nbsp;&nbsp;&nbsp;소스위치>공사공고문<br> 
		  &nbsp;&nbsp;&nbsp;s_kr/bidding/bidc/ebd_bd_dis2_버전.jsp<br>
		  3.&nbsp;수정된 공고문의 버전(ex 001,002...)을 확인후 코드값에 입력합니다.<br>
		</td>
    </tr>
</table>
</form>
</s:header>
<s:footer/>
</body>
</html>


