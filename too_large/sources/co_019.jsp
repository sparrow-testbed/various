<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("CO_019");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "CO_019";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	String  callback       = request.getParameter("callback");
	boolean isSelectScreen = false;
	
	String	userId		= request.getParameter("userId");			
	String	userName	= request.getParameter("userName");
	
	if(userId == null){
		userId = "";
	}
	
	if(userName == null){
		userName = "";
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
function fnBodyOnLoad(){
	setGridDraw();
	fnSelect();
}

function fnSelect(){
	var userId      = document.getElementById("userId");
	var userNameLoc = document.getElementById("userNameLoc");
	var deptCd      = document.getElementById("deptCd");
	var deptNm      = document.getElementById("deptNm");
	
	if(
		(userId.value == "") &&
		(userNameLoc.value == "") &&
		(deptCd.value == "") &&
		(deptNm.value == "") 
		){
		alert("조회 조건 중 하나는 입력하여 주시기 바랍니다.");
		
		return;
	}
	
    var params = "mode=selectUserList";
    params += "&cols_ids=<%=grid_col_id%>";
    params += dataOutput();
    GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.CO_008_Servlet", params );
    GridObj.clearAll(false);    
}

function entKeyDown(){
	if(event.keyCode==13) {
		fnSelect();
	}
}

var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId, cellInd){
	
}

/////////////////////////////////////////////
//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}

function doSelected()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	var EVAL_USER_IDS = "";
	var EVAL_USER_NAMES = "";

	for(var i = 0; i < grid_array.length; i++)
	{
		if(i == 0){
			EVAL_USER_IDS = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_ID")).getValue();
		}else{
			EVAL_USER_IDS = EVAL_USER_IDS + ",";
			EVAL_USER_IDS = EVAL_USER_IDS + GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_ID")).getValue();
		}	
		
		if(i == 0){
			EVAL_USER_NAMES = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_NAME_LOC")).getValue();
		}else{
			EVAL_USER_NAMES = EVAL_USER_NAMES + ",";
			EVAL_USER_NAMES = EVAL_USER_NAMES + GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_NAME_LOC")).getValue();
		}	
	}
	
	opener.<%=callback%>(
		EVAL_USER_IDS,EVAL_USER_NAMES,grid_array.length 
	);
	
	window.close();
}

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
    
    if(document.getElementById("type").value == "U"){
    	var pItemNoObject = document.getElementById("pItemNo");
    	var seqObject     = document.getElementById("seq");
    	
    	opener.doSelect();
    	opener.fnPIntemNoPopCallback(pItemNoObject.value, seqObject.value);
    }
    
    window.close();
    
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
    var msg    = GridObj.getUserData("", "message");
    var status = GridObj.getUserData("", "status");

    if(status == "0"){
    	alert(msg);
    }
    
    return true;
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();" >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">평가자 선택</td>
		</tr>
	</table>

	<form name="form1" action="">
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
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
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부서코드</td>
										<td class="data_td" width="30%">
											<input type="text" id="deptCd" name="deptCd" size="15" class="inputsubmit" value='<%=info.getSession("DEPARTMENT")%>' style="ime-mode:inactive" onkeydown="javascript:entKeyDown();">
										</td>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부서명</td>
										<td class="data_td" width="30%">
											<input type="text" name="deptNm" id="deptNm" size="20" maxlength="500" class="inputsubmit" value='<%=info.getSession("DEPARTMENT_NAME_LOC")%>' onkeydown="javascript:entKeyDown();">
										</td>
									</tr>	
									<tr>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;행번</td>
										<td class="data_td" width="30%">
											<input type="text" id="userId" name="userId" size="15" class="inputsubmit" value='<%=userId %>' style="ime-mode:inactive" onkeydown="javascript:entKeyDown();">
										</td>
										<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;이름</td>
										<td class="data_td" width="30%">
											<input type="text" name="userNameLoc" id="userNameLoc" size="20" maxlength="500" class="inputsubmit" value='<%=userName %>' onkeydown="javascript:entKeyDown();">
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
				<td height="30" align="right">
					<table cellpadding="0">
						<tr>
							<td>
<script language="javascript">
btn("javascript:fnSelect()", "조 회");
</script>
							</td>
							<td>
<script language="javascript">
btn("javascript:doSelected()", "선 택");
</script>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="CO_019" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>