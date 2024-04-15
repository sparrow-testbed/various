<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_243_t");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_243_t";
	String grid_obj  = "GridObj";
	String G_IMG_ICON = "/images/ico_zoom.gif";
	boolean isSelectScreen = false;
    String house_code   = info.getSession("HOUSE_CODE");
    String shipper_type = JSPUtil.nullToEmpty(request.getParameter("shipper_type"));

	String ret = null;

	SepoaFormater wf = null;
	SepoaOut value = null;
	SepoaRemote ws = null;

	String nickName= "p0070";
	String conType = "CONNECTION";

	String MethodName = "getSgContentsList";
	String sg_refitem = "";

	Object[] obj = { sg_refitem };

	try {
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
	} catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	} catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	} finally {
		try{
			ws.Release();
		} catch(Exception e) { }
	}
	String str = "";
	for(int i=0; i < wf.getRowCount(); i++) {
		str = str + "<option value='" + wf.getValue("SG_REFITEM", i) + "'>" + wf.getValue("SG_NAME", i) + "</option>\n";
	}

	String vendorTypeSelBox = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M076", "");
	String creditRating = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M934", "");

	String WISEHUB_PROCESS_ID="RQ_243_t";
	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">
var mode;
var house_code = "<%=house_code%>";

function doSelect() {
	
	
	
	
	VENDOR_CODE = form1.vendor_code.value;
	form1.vendor_code.value = VENDOR_CODE.toUpperCase();
	MAKER_NAME = form1.MAKER_NAME.value.toUpperCase();		// 업체명
	materialType =  form1.MATERIAL_TYPE.value;	// 대분류
	materialCtrlType = form1.MATERIAL_CTRL_TYPE.value;	// 중분류
	materialClass1 = form1.MATERIAL_CLASS1.value;		// 소분류
	vendorType = form1.vendorType.value;				// 업체유형
	creditRating = form1.creditRating.value;			// Class
	
	if((form1.vendor_code.value == '' && form1.MAKER_NAME.value == '' ) &&  form1.MATERIAL_TYPE.value == ''){
		alert("업체코드를 입력하지 않을 경우 소싱대분류 선택은 필수 입니다.");
		return;
	}

	parent.leftFrame.doSelect(VENDOR_CODE.toUpperCase(), MAKER_NAME, materialType, materialCtrlType, materialClass1, vendorType, creditRating);
}


function Vendor_Search(){
	var arrv = new Array("<%=house_code%>", "", "");
	PopupCommonArr("SP0054", "getCode", arrv, "" );
}

function getCode(v0,v1,v2){
	document.forms[0].vendor_code.value = v0;
	document.forms[0].MAKER_NAME.value = v1;
}

//주거래품목
function searchMainProduct() {
	var arrv = new Array("<%=house_code%>", "M086");
	
	PopupCommonNoCond("SP0053", "setMainProduct", arrv, "" );
}

function setMainProduct(code, text) {
	document.forms[0].search_key.value = code;
	document.forms[0].main_product_text.value = text;
}

function MATERIAL_CLASS1_Changed(){
	var sg_refitem = form1.MATERIAL_CLASS1.value;
	
	target = "MATERIAL_CLASS1";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	
	this.hiddenframe.location.href = data;
}

function clearMATERIAL_CLASS1(){
	if(form1.MATERIAL_CLASS1.length > 0){
		for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
			form1.MATERIAL_CLASS1.options[i] = null;
		}
	}
}

function setMATERIAL_CLASS1(name, value){
	var option1 = new Option(name, value, true);
	
	form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function MATERIAL_CTRL_TYPE_Changed(){
	clearMATERIAL_CLASS1();
	
	var sg_refitem = form1.MATERIAL_CTRL_TYPE.value;
	
	target = "MATERIAL_CTRL_TYPE";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	
	this.hiddenframe.location.href = data;
}

function clearMATERIAL_CTRL_TYPE(){
	if(form1.MATERIAL_CTRL_TYPE.length > 0) {
		for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
			form1.MATERIAL_CTRL_TYPE.options[i] = null;
		}
	}
}

function setMATERIAL_CTRL_TYPE(name, value){
	var option1 = new Option(name, value, true);
	form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function MATERIAL_TYPE_Changed(){
	clearMATERIAL_CTRL_TYPE();
	setMATERIAL_CTRL_TYPE("----------", "");
	clearMATERIAL_CLASS1();
	setMATERIAL_CLASS1("----------", "");
	var sg_refitem = form1.MATERIAL_TYPE.value;
	target = "MATERIAL_TYPE";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	this.hiddenframe.location.href = data;
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

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

function KeyFunction(temp) {
	if(temp == "Enter") {
		if(event.keyCode == 13) {
			doSelect();
		}
	}
}


</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">견적요청 대상업체 선정</td>
		</tr>
	</table>
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
	<form name="form1" method="post" action="">
		<input type="hidden" name="NO" size="20">
		<input type="hidden" name="DIS" size="20">
		<input type="hidden" name="SG_REFITEM" value="">
		<input type="hidden" name="vendorType" value="">
			
		<table width="100%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드</td>
				<td class="data_td" width="35%">
					<input type="text" name="vendor_code" style="ime-mode:disabled" maxlength="10" size="14" class="inputsubmit" onkeydown="JavaScript: KeyFunction('Enter');">
<%-- 					<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="" style="cursor: pointer;" onclick="javascript:Vendor_Search();"> --%>
				</td>
				<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명</td>
				<td class="data_td" width="35%">
					<input type="text" name="MAKER_NAME" size="35" onkeydown="JavaScript: KeyFunction('Enter');">
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱대분류</td>
				<td class="data_td" align="left">
					<select name="MATERIAL_TYPE" id="MATERIAL_TYPE" class="inputsubmit" onChange="javascript:MATERIAL_TYPE_Changed();">
						<option value=''>----------</option>
						<%=str%>
					</select>
				</td>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱중분류</td>
				<td class="data_td" align="left">
					<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" class="inputsubmit" onChange="javascript:MATERIAL_CTRL_TYPE_Changed();">
						<option value=''>----------</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>			<tr>
				<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱소분류</td>
				<td class="data_td" align="left" colspan="3">
					<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" class="inputsubmit" onChange="javascript:MATERIAL_CLASS1_Changed();">
						<option value=''>----------</option>
					</select>
					<input type="hidden" name="creditRating" id="creditRating" value="" />
				</td>
				<%-- <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등급</td>
				<td class="data_td" align="left">
					<select name="creditRating" class="inputsubmit">
						<option value="">전체</option>
						<%=creditRating%>
					</select>
				</td> --%>
			</tr>
		</table>
		</td>
</tr>
</table>
</td>
</tr>
</table>
		<input type="hidden" name="shipper_type" value="<%=shipper_type%>">
		
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:doSelect()", "조 회");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
	<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
</s:header>
<s:footer/>
</body>
</html>