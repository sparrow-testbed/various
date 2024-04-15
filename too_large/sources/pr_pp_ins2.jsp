<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_011";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String HOUSE_CODE = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String pMode 	= JSPUtil.nullToEmpty(request.getParameter("pMode"));
	String pMsg 	= JSPUtil.nullToEmpty(request.getParameter("pMsg"));
	String value 	= JSPUtil.nullToEmpty(request.getParameter("value"));
    String pr_name 	= JSPUtil.nullToEmpty(request.getParameter("add_user_name"));

	String[] data = new String[2];
	data[0] = ""; data[1] = "";

	if(value != null) {
		SepoaStringTokenizer wst = new SepoaStringTokenizer(value, "@");

		int i=0;

		while(wst.hasMoreElements()) {
			data[i++] = (String)wst.nextElement();
		}
	}
	
	String WISEHUB_PROCESS_ID="PR_011";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript">
function save(){
	if(document.form1.reason_code.value == ""){
		alert("사유코드는 필수입력사항입니다.");
		
		return;
	}
	
	if(document.form1.email.value == ""){
		alert("이메일은 필수입력사항입니다.");
		
		return;
	}
	
	if(document.form1.reason_code.value == "99" && document.form1.memo.value == ""){
		alert("사유코드가 기타일 경우 사유는 필수입력사항입니다.");
		
		return;
	}

<%
	if(pMode.equals("reason1")) {
%>
	if(confirm("반려 하시겠습니까?") == 1) {
		opener.setReason(document.form1.title.value, document.form1.memo.value);
	}
<%
	} else if(pMode.equals("reason2")) {
%>
	opener.setReason(document.form1.title.value, document.form1.memo.value, "<%=pMode%>", "<%=pMsg%>");
<%
	}
	else if(pMode.equals("doReturn_doc")) {
%>//pr3_bd_lis1.jsp / setReason(D) 반송
	if(confirm("반려 하시겠습니까?") == 1) {
		opener.setReason(document.form1.memo.value, "<%=pMode%>", document.form1.reason_code.value, document.form1.email.value, document.form1.pr_name.value);
	}
<%
	}
	else if(pMode.equals("reject")){
%>
	if(confirm("반려 하시겠습니까?") == 1) {
		opener.setReason(document.form1.memo.value, "<%=pMode%>", document.form1.reason_code.value, document.form1.email.value, document.form1.pr_name.value);
	}
<%
	}else if(pMode.equals("doDefer")){
%>
	if(confirm("보류 하시겠습니까?") == 1) {
		opener.setReason(document.form1.memo.value, "<%=pMode%>", document.form1.reason_code.value, document.form1.email.value, document.form1.pr_name.value);
	}
<%
	}
%>
	window.close();
}

function changeList() {
	for(i=0; i<form1.title.length; i++) {
		if(form1.title.options[i].text == "<%=data[0]%>") {
			form1.title.options[i].selected = true;
		}
	}
}

function searchProfile(fc) {
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0233&function=getEmail&values=<%=HOUSE_CODE%>&values=<%=COMPANY_CODE%>&values=&values=";

	Code_Search(url,'','','','','');
}

function getEmail(user_id, name_loc, email) {
	document.form1.email.value = email;
	document.form1.pr_name.value = name_loc;
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
function doOnCellChange(stage,rowId,cellInd){}

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
    else{
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
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:changeList();">
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>보류사유</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1">
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td"><img src="/images/dot_orange.gif" width="23" height="11" align="absmiddle">사유코드</td>
										<td class="data_td">
											<select name="reason_code" class="input_re">
												<option value=""></option>
<%
	String s_values = ListBox(request, "SL0018", HOUSE_CODE+"#M147", "");

	out.println(s_values);
%>
											</select>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:window.save()", "저 장");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>   
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center">
					<textarea name="memo" cols="85" rows="9"><%=data[1]%></textarea>
				</td>
			</tr>
		</table>
		<input type="hidden" name="email" value=" " >
		<input type="hidden" name="pr_name" value="<%=pr_name%>">
	</form>
</s:header>
<s:footer/>
</body>
</html>