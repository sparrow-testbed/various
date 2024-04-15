<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
	String  screen_id      = "MA_012";
	String  grid_obj       = "GridObj";
	boolean isSelectScreen = false;
	Vector  multilang_id   = new Vector();
	
	multilang_id.addElement("MA_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
function fnBodyOnLoad(){
	setGridDraw();
}

function fnPIntemNoPop(){ 
	var valueArraay = new Array();
	var descArray   = new Array();
	
	valueArraay[valueArraay.length] = "000";
	valueArraay[valueArraay.length] = "";
	valueArraay[valueArraay.length] = "";
	descArray[descArray.length]     = "모품번";
	descArray[descArray.length]     = "모품명";
	
	PopupCommonPost("MA0120", "fnPIntemNoPopCallback", valueArraay, descArray);
}

function fnPIntemNoPopCallback(code, text){ 
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012",
		{
			mode     : "ma012selectGl",
			cols_ids : "SEQ,BOM_NAME,DESCRIPTION_LOC,SPECIFICATION,BASIC_UNIT,ITEM_NO",
			pItemNo  : code,
			seq      : text
		},
		function(arg){
			var argArray       = arg.split(",");
			var argArrayLength = argArray.length;
			
			if(argArrayLength == 1){
				alert(arg);
				
				return;
			}
			else{
				document.getElementById("pItemNo").value        = code;
				document.getElementById("seq").value            = text;
				document.getElementById("bomName").value        = argArray[1];
				document.getElementById("desctiptionLoc").value = argArray[2];
				document.getElementById("specification").value  = argArray[3];
				document.getElementById("basicUnit").value      = argArray[4];
			}
		}
	);
}

function doSelect(){
	var pItemNo = document.getElementById("pItemNo");
	
	if(pItemNo.value == ""){
		alert("모품목을 선택하여 주십시오.");
		
		return;
	}
	
	var params = "mode=doSelect";
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012", params);
	
	GridObj.clearAll(false);
}

function fnNewBom(){
	fnMa013Pop("I", "", "");
}

function fnModifyBom(){
	var pItemNo = document.getElementById("pItemNo").value;
	var seq     = document.getElementById("seq").value;
	
	fnMa013Pop("U", pItemNo, seq);
}

function fnMa013Pop(type, pItemNo, seq){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	
	window.open("","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	inputParam = "type=" + type;
	inputParam = inputParam + "&pItemNo=" + pItemNo;
	inputParam = inputParam + "&seq=" + seq;
	
	var form = fnGetDynamicForm("/kr/bom/ma_013.jsp", inputParam, "windowopen1");
	
	body.appendChild(form);
	
	form.submit();
	
	body.removeChild(form);
}

function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
	//frm.appendChild(input);
	
	return input;
}

function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
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

    alert(messsage);
    
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
//지우기
function doRemove( type ){
    if( type == "pItemNo" ) {
    	document.getElementById("pItemNo").value        ="";
		document.getElementById("seq").value            = "";
		document.getElementById("bomName").value        = "";
		document.getElementById("desctiptionLoc").value = "";
		document.getElementById("specification").value  = "";
		document.getElementById("basicUnit").value      = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();">
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %> 
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
				<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품목</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  id="pItemNo" name="pItemNo" size="15" class="inputsubmit" value='' readonly="readonly">
					<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:fnPIntemNoPop();">
					<a href="javascript:doRemove('pItemNo')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;순번</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  name="seq" id="seq" size="20" class="input_data2" readonly value=''>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;BOM명</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  name="bomName" id="bomName" size="20" class="input_data2" readonly value=''>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;모품명</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  name="desctiptionLoc" id="desctiptionLoc" size="20" class="input_data2" readonly value=''>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  name="specification" id="specification" size="20" class="input_data2" readonly value=''>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;단위</td>
				<td class="data_td" width="35%">
					<input type="text" onkeydown='entKeyDown()'  name="basicUnit" id="basicUnit" size="20" class="input_data2" readonly value=''>
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
btn("javascript:doSelect()", "조 회");
</script>
							</td>
<td>
<script language="javascript">
btn("javascript:fnNewBom()", "신규등록");
</script>
							</td> 
							<td>
<script language="javascript">
btn("javascript:fnModifyBom()", "수 정");
</script>
							</td> 
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="MA_012" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>