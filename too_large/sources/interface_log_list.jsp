<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector  multilang_id       = new Vector();
	HashMap text               = null;
	String  screen_id          = "AD_900";
	String  grid_obj           = "GridObj";
	String  G_IMG_ICON         = "/images/ico_zoom.gif";
	boolean isSelectScreen     = false;

	multilang_id.addElement("AD_900");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	String inf_date = JSPUtil.nullToRef(request.getParameter("inf_date"),SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()));

	String sTime   = JSPUtil.nullToRef(request.getParameter("sTime"),String.format("%02d", Integer.parseInt(SepoaDate.getShortTimeString().substring(0,2)) - 1));
	String sMin    = JSPUtil.nullToRef(request.getParameter("sMin"),SepoaDate.getShortTimeString().substring(2,4));	
	String eTime   = JSPUtil.nullToRef(request.getParameter("eTime"),SepoaDate.getShortTimeString().substring(0,2));
	String eMin    = JSPUtil.nullToRef(request.getParameter("eMin"),SepoaDate.getShortTimeString().substring(2,4));	
		
	text = MessageUtil.getMessage(info, multilang_id);
	
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
<script language="javascript" type="text/javascript">
function Init(){
	form1.sTime.value = "<%=sTime%>";
	form1.sMin.value = "<%=sMin%>";
	form1.eTime.value = "<%=eTime%>";
	form1.eMin.value = "<%=eMin%>";
	
	setGridDraw();
	
	doSelect();
}

function doSelect(){
	var params = "mode=selectSinfhdList";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/admin.interfaceLog.interface_log_list", params );
	GridObj.clearAll(false);
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
function doOnRowSelected(rowId,cellInd){
	var cartColIndex = GridObj.getColIndexById("GW");
	var rowIndex     = GridObj.getRowIndex(rowId);
	
	if(cartColIndex == cellInd){
		var infNoColIndex = GridObj.getColIndexById("INF_NO");
		var infNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, infNoColIndex);
		
		$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/admin.interfaceLog.interface_log_list",
			{
				INF_NO : infNoColValue,
				mode    : "gwClick"
			},
			function(arg){
				var result  = eval("(" + arg + ")");
				var code    = result.code;
				var message = null;
				
				if(code == "200"){
					message = "성공적으로 처리하였습니다.";
				}
				else{
					message = "처리에 실패하였습니다.";
				}
				
				alert(message);
			}
		);
	}
}

function doOnMouseOver(rowId,cellInd){}

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
    
    alert(messsage);

    if(status == "true") {
        doSelect();
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
    if(status == "0"){
    	alert(msg);
    }
    
    return true;
}
</script>
</head>
<body onload="javascript:Init();"  bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form name="form1" action="">
		<%@ include file="/include/sepoa_milestone.jsp" %>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="760" height="2" bgcolor="#0072bc"></td>
			</tr>
		</table>
		
		
		
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;거래일시<font style="color: red;">*</font></td>
				<td width="85%" class="data_td"  align="left">
					<s:calendar id="inf_date" default_value="<%=inf_date%>" format="%Y/%m/%d"/>&nbsp;&nbsp;
					<select name="sTime" id="sTime" class="inputsubmit">
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
					</select>
					시
					<input type="text" name="sMin" id="sMin" size="2" maxLength="2" value="<%=sMin%>" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]')">
					분
					&nbsp;&nbsp;~&nbsp;&nbsp;
					<select name="eTime" id="eTime" class="inputsubmit">
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
					</select>
					시
					<input type="text" name="eMin" id="eMin" size="2" maxLength="2" value="<%=sMin%>" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]')">
					분
					
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
				<td height="30" align="left">
					<TABLE cellpadding="0">
						<TR></TR>
					</TABLE>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>		
	</form>
</s:header>
<s:grid screen_id="AD_900" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>