<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_010";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
	
	String PR_NO	= JSPUtil.nullToEmpty(request.getParameter("PR_NO"));
	String PR_SEQ 	= JSPUtil.nullToEmpty(request.getParameter("PR_SEQ"));

	if (PR_NO.equals(""))  PR_NO  = JSPUtil.nullToEmpty(request.getParameter("pr_no"));
	if (PR_SEQ.equals("")) PR_SEQ = JSPUtil.nullToEmpty(request.getParameter("pr_seq"));
	
	String G_IMG_ICON = "/images/ico_zoom.gif";
%>
<% String WISEHUB_PROCESS_ID="PR_010";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">
var mode;
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.vendor_settle_history";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";

function init(){
	setGridDraw();
	setHeader();
}

function setHeader(){
	GridObj.strHDClickAction="sortmulti";
	GridObj.SetDateFormat("SOURCING_DATE","yyyy/MM/dd");

	doSelect();
}

function doQeury(){
	doSelect();
}

function doSelect(){
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=vendorSettleHistory";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	if(msg1 == "doQuery" ){}
	else if(msg1 == "t_imagetext"){ 
		var left = 30;
		var top = 30;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var width = "";
		var height = "";
        	
		if(msg3 == INDEX_PR_NO){
			pr_no = msg4;
			
			window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+pr_no ,"pr_pp","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
		}
                 
		if(msg3 == INDEX_ITEM_NO) {
			var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
			width = 750;
			height = 550;
			var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
			var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			PoDisWin.focus();
		}
	}	
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
    }
    else {
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

    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" action="">
		<input type="hidden" name="PR_NO"  id="PR_NO"  value="<%=PR_NO %>" />
		<input type="hidden" name="PR_SEQ" id="PR_SEQ" value="<%=PR_SEQ %>" />
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class="title_page">업체선정 History</td>
			</tr>
		</table>
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="760" height="2" bgcolor="#0072bc"></td>
			</tr>
		</table>
		<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:parent.window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
</form>
</s:header>
<s:grid screen_id="PR_010" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>