<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
 
	String WISEHUB_LANG_TYPE="KR";
	String WISEHUB_PROCESS_ID="MA_001";
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String Attach_Index = "";
    SepoaListBox lb = new SepoaListBox();
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");

    //단위결정기준
    String make_amt_codes = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M799", "07");

    
    String Z_CHARACTER_CLASS1 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS1"));
    
    if(Z_CHARACTER_CLASS1 == null ){
    	Z_CHARACTER_CLASS1 = "";
    }
    
    String Z_CHARACTER_CLASS2 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS2"));
    
    if(Z_CHARACTER_CLASS2 == null ){
    	Z_CHARACTER_CLASS2 = "";
    }
    
    String Z_CHARACTER_CLASS3 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS3"));
    
    if(Z_CHARACTER_CLASS3 == null ){
    	Z_CHARACTER_CLASS3 = "";
    }

    String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
    
    String G_IMG_ICON = "/images/ico_zoom.gif"; 
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-kr">
<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
function goSubmit() {
	document.form1.method="post";
	document.form1.action = "req_bd_ins1.jsp";
	document.form1.submit();
}

function PreSave() {
	Check();
}

function Check() {
	if("" == document.forms[0].DESCRIPTION_LOC.value){
		alert("품목명은 필수 입력 입니다.");
		
		return;
	}
	
	/* if("" == document.forms[0].REMARK.value){
		alert("요청내역은 필수 입력 입니다.");
		
		return;
	} */

	if(!confirm("요청 하시겠습니까?")) {
			return;
	}
	else{
		setrMateFileAttach();
	}
}

function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function setrMateFileAttach() {
	var makerFlag      = document.getElementById("MAKER_FLAG");
	var makerFlagValue = "";
	
	if(makerFlag.checked){
		makerFlagValue = "Y";
	}
	else{
		makerFlagValue = "N";
	}
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/master.new_material.req_bd_ins1",
		{
			DESCRIPTION_LOC    : document.getElementById("DESCRIPTION_LOC").value,
	    	SPECIFICATION      : document.getElementById("SPECIFICATION").value,
	    	MAKER_FLAG         : makerFlagValue,
	    	MAKER_CODE         : document.getElementById("MAKER_CODE").value,
	    	MAKER_NAME         : document.getElementById("MAKER_NAME").value,
	    	Z_ITEM_DESC        : document.getElementById("Z_ITEM_DESC").value,
	    	REMARK             : document.getElementById("REMARK").value,
	    	MATERIAL_TYPE      : document.getElementById("MATERIAL_TYPE").value,
	    	MATERIAL_CTRL_TYPE : document.getElementById("MATERIAL_CTRL_TYPE").value,
	    	MATERIAL_CLASS1    : document.getElementById("MATERIAL_CLASS1").value,
	    	MATERIAL_CLASS2    : document.getElementById("MATERIAL_CLASS2").value,
	    	ITEM_ABBREVIATION  : document.getElementById("ITEM_ABBREVIATION").value,
	    	BASIC_UNIT         : document.getElementById("BASIC_UNIT").value,
	    	APP_TAX_CODE       : document.getElementById("APP_TAX_CODE").value,
	    	ITEM_BLOCK_FLAG    : document.getElementById("ITEM_BLOCK_FLAG").value,
	    	MODEL_FLAG         : document.getElementById("MODEL_FLAG").value,
	    	MODEL_NO           : document.getElementById("MODEL_NO").value,
	    	REQ_USER_ID        : document.getElementById("REQ_USER_ID").value,
	    	ATTACH_NO          : document.getElementById("ATTACH_NO").value,
	    	//MAKE_AMT_CODE      : document.getElementById("MAKE_AMT_CODE").value,
	    	mode               : "doData"
		},
		function(arg){
			doSave(arg, "");
		}
	);
}

function doSave(message, v_status){
	alert(message);
	
	location.href="req_bd_ins1.jsp";
}

function SP9053_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);
}

function selectCode( maker_code, maker_name) {
	document.form1.MAKER_NAME.value 	= maker_name;
	document.form1.MAKER_CODE.value 	= maker_code;
}

function checkFlag(){
	var makerFlag = document.getElementById("MAKER_FLAG");
	
	if (makerFlag.checked == true) {
		$("#IMG_SEARCH").hide();
		
		document.getElementById("MAKER_CODE").value = '';
		document.getElementById("MAKER_NAME").value = '';
	}
	else {
		$("#IMG_SEARCH").show();
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

//지우기
function doRemove( type ){
    if( type == "MAKER_FLAG" ) {
    	document.getElementById("MAKER_CODE").value        ="";
		document.getElementById("MAKER_NAME").value            = "";
    }  
}
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
<%
	if("".equals(gate)){
%>
	<%@ include file="/include/sepoa_milestone.jsp" %>
<%
	}
%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" method="post" action="">
		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="REQ_USER_ID" id="REQ_USER_ID" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" value="PR">
		<input type="hidden" name="fnc_name" value="getApproval">
		<input type="hidden" name="ctrl_dept" value="">
		<input type="hidden" name="ctrl_flag" value="">
		<input type="hidden" value="off" name="query_flag" >
		<input type="hidden" name="MODEL_FLAG" id="MODEL_FLAG" >
		<input type="hidden" name="MODEL_NO" id="MODEL_NO" >

		<input type="hidden"  name="MATERIAL_TYPE" id="MATERIAL_TYPE"		value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_TYPE"))%>">
		<input type="hidden"  name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE"	value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CTRL_TYPE"))%>">
		<input type="hidden"  name="MATERIAL_CLASS1" id="MATERIAL_CLASS1"	value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS1"))%>">
		<input type="hidden"  name="MATERIAL_CLASS2" id="MATERIAL_CLASS2" 	value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS2"))%>">
		<input type="hidden"  name="PR_FLAG"			value="<%=JSPUtil.nullToEmpty(request.getParameter("PR_FLAG"))%>">
		<input type="hidden"  name="MATERIAL_CLASS2_NAME" >
		<input type="hidden"  name="BASIC_UNIT" id="BASIC_UNIT"  >
		<input type="hidden"  name="ITEM_ABBREVIATION" id="ITEM_ABBREVIATION"  >
		<input type="hidden"  name="APP_TAX_CODE" id="APP_TAX_CODE"  >
		<input type="hidden"  name="ITEM_BLOCK_FLAG" id="ITEM_BLOCK_FLAG" >
		

		<input type="hidden" name="att_mode"   value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr style="display: none;">
										<td width="13%" class="se_cell_title">단위결정기준</td>
										<td  class="c_data_1">
											<select name = "MAKE_AMT_CODE" id="MAKE_AMT_CODE" class="inputsubmit" >
												<%=make_amt_codes%>
				    						</select>
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td class="data_td">
											<input type="text" name="DESCRIPTION_LOC" id="DESCRIPTION_LOC" value="<%=JSPUtil.nullToEmpty(request.getParameter("DESCRIPTION_LOC"))%>"  size="52" class="inputsubmit" maxlength="500" onKeyUp="return chkMaxByte(500, this, '품목명');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사양</td>
										<td class="data_td">
											<input type="text" name="SPECIFICATION" id="SPECIFICATION" value="<%=JSPUtil.nullToEmpty(request.getParameter("SPECIFICATION"))%>"  size="106" class="inputsubmit" maxlength="256" onKeyUp="return chkMaxByte(256, this, '사양');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td class="data_td">
											<input type="checkbox" name="MAKER_FLAG" id="MAKER_FLAG" onclick="javascript:checkFlag();">해당없음
											<input type="text" name="MAKER_CODE" id="MAKER_CODE" size="13" maxlength="10" class="inputsubmit" readOnly>
											<a href="javascript:SP9053_Popup()">
												<img name="IMG_SEARCH" id="IMG_SEARCH" src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('MAKER_FLAG')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="MAKER_NAME" id="MAKER_NAME" size="20" maxlength="50" class="inputsubmit" readOnly>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목설명</td>
										<td  class="data_td" height="150">
											<textarea name="Z_ITEM_DESC" id="Z_ITEM_DESC" value="" rows="5" maxlength="3000" cols="107" class="inputsubmit" style="overflow=hidden;width: 98%; height: 130px" onKeyUp="return chkMaxByte(3000, this, '품목설명');"></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청내역</td>
										<td  class="data_td" height="150">
											<textarea name="REMARK" id="REMARK" value="" rows="5" cols="107" maxlength="500" class="inputsubmit" style="overflow=hidden;width: 98%; height: 130px" onKeyUp="return chkMaxByte(500, this, '요청내역');"></textarea>
										</td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" >
											<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="15%">
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowid, attach_count) {
	document.getElementById("ATTACH_NO").value = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}

btn("javascript:attach_file(document.getElementById('ATTACH_NO').value, 'TEMP');", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="0" name="sign_attach_no_count" id="sign_attach_no_count"/>
														<input type="hidden" value="" name="ATTACH_NO" id="ATTACH_NO">
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
	btn("javascript:PreSave()", "등록요청");
</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
	<iframe name="childFrame" src="" frameborder="1" width="0" height="50" marginwidth="0" marginheight="0" scrolling="yes"> </iframe>
</s:header>
<s:footer/>
</body>
</html>