<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_024");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_024";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%-- <%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_common.jsp"%>
<% String WISEHUB_PROCESS_ID="AP_024";%>
<%@ include file="/include/wisetable_scripts.jsp"%>
<%@ include file="/include/wisehub_scripts.jsp"%> --%>

<%
	String house_code 	= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));
	String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	String company_code = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String doc_type 	= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String doc_no 		= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	String doc_seq 		= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	String TITLE = "결재의견";
%>
<html>
	<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

		<script language="javascript">

//<!--

<%-- var G_SERVLETURL = "<%=getWiseServletPath("admin.basic.approval2.ap2_pp_lis5")%>"; --%>

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var INDEX_SIGN_PATH_SEQ		    = "";
var INDEX_PROCEEDING_FLAG_TEXT	    = "";
var INDEX_SIGN_USER_NAME	    = "";
var INDEX_APP_STATUS_TEXT       	= "";
var INDEX_SIGN_REMARK	        = "";

function Init() {
setGridDraw();
setHeader();
	Query();
}

function setHeader() {
    


	INDEX_SIGN_PATH_SEQ		= GridObj.GetColHDIndex("SIGN_PATH_SEQ");
	INDEX_PROCEEDING_FLAG	= GridObj.GetColHDIndex("PROCEEDING_FLAG_TEXT");
	INDEX_SIGN_USER_NAME	= GridObj.GetColHDIndex("SIGN_USER_NAME");
	INDEX_APP_STATUS_TEXT   = GridObj.GetColHDIndex("APP_STATUS_TEXT");
	INDEX_SIGN_REMARK	    = GridObj.GetColHDIndex("SIGN_REMARK");

}

function Query() {

	<%-- var wise = GridObj;
	
	GridObj.SetParam("mode",			"ViewSignPath");

	GridObj.SetParam("company_code",	"<%=company_code%>");
	GridObj.SetParam("doc_type",		"<%=doc_type%>");
	GridObj.SetParam("doc_no",			"<%=doc_no%>");
	GridObj.SetParam("doc_seq",		"<%=doc_seq%>");
	
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(G_SERVLETURL);
	GridObj.strHDClickAction="sortmulti"; --%>
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.approval.ap_opinion";
	var params ="mode=getOpinion&grid_col_id="+grid_col_id;
	params += "&company_code=<%=company_code%>";
	params += "&doc_type=<%=doc_type%>";
	params += "&doc_no=<%=doc_no%>";
	params += "&doc_seq=<%=doc_seq%>";
	params += dataOutput();
	GridObj.post(url, params);
 	GridObj.clearAll(false);
}

function JavaCall(msg1,msg2, msg3, msg4,msg5) {

	if(msg1=="doData") Query();
	if( msg1 == "t_imagetext" ) {
		sign_remark = GD_GetCellValueIndex(GridObj,msg2,INDEX_SIGN_REMARK);

		var url = "/kr/admin/basic/approval2/ap2_pp_lis2.jsp?ROW="+msg2+"&SIGN_REMARK="+sign_remark+"&GUBUN=S";
		CodeSearchCommon(url,'BKWin11','250','600','600','250');
    }  //밖에 if 문장 끝..
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Query();
	}
}

//-->
</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
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
function doOnRowSelected(rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
    if(header_name=="SIGN_REMARK_IMG"){
    	var left = 0;
		var top = 0;
		var width = 500;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';
    	var url = "/approval/ap_opinion_pop.jsp?ROW="+rowId+"&SIGN_REMARK="+GridObj.cells(rowId, GridObj.getColIndexById("SIGN_REMARK")).getValue()+"&GUBUN=S";
		//CodeSearchCommon(url,'BKWin11','250','600','600','250');
		window.open( url, 'doc', 'left=250, top=600, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
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
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>

	
  	
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="cell_title1" width="78%" align="left">&nbsp;
	  	<img src="/images/icon/icon_ti.gif" align="absmiddle" width="12" height="12">
	  	&nbsp;결재자 목록
	  	</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>	

<br>

  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
    		<TD align="right"><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
    	</tr>
  	</table>
  	
	</form>

<s:grid screen_id="AP_024" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


