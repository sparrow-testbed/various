<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("MA_017");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "MA_017";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
var vendorSelectedRowIndex = -1;
var attachType             = "";
var attachSelectedRowIndex = -1;

function fnBodyOnLoad(){
	fnGetSosglInfo();
	setGridDraw();
	doSelect();
}

function fnGetSosglInfo(){
	<%-- 웹취약점 발견에 따른 조치로 번호가 없는 경우는 접근불가 : 2015.09.25 --%>

	var getOSQ_NO = "";
	getOSQ_NO = document.getElementById("osqNo").value;
	//alert(getOSQ_NO);
	if (getOSQ_NO == "null" || getOSQ_NO == "" || "<%=request.getMethod()%>" == "GET"){
		alert("잘못된 접근방법을 사용하였습니다.");
		sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
	}
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/os.sos_bd_dis1",
		{
			OSQ_NO    : document.getElementById("osqNo").value,
			OSQ_COUNT : document.getElementById("osqCount").value,
			mode      : "getSosglInfo"
		},
		function(arg){
			var result = arg.split("@@");
			
			if(result.length == 1){
				alert(result[0]);
			}
			else{
				document.getElementById("subject").value    = result[0];
				document.getElementById("osqDate").value    = result[1];
				document.getElementById("attach_key").value = result[2];
				document.getElementById("remark").value     = result[4];
				
				document.getElementById("fileAttachDownloadViewFrm").submit();
			}
		}
	);
}

function doSelect(){
	var param = "";
	
	param = "mode=ma012SelectSoslnList&cols_ids=<%=grid_col_id%>";
	param = param + dataOutput();

	GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/bom.ma_012", param);
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
function doOnRowSelected(rowId, cellInd){
	var rowIndex            = GridObj.getRowIndex(rowId);
	var attachCountColIndex = GridObj.getColIndexById("ATTACH_COUNT");
	var header_name = GridObj.getColumnId(cellInd);
	
	if(cellInd == attachCountColIndex) {
		var attachNoColIndex    = GridObj.getColIndexById("ATTACH_NO");
		var attachCountColValue = GD_GetCellValueIndex(GridObj, rowIndex, attachCountColIndex);
		var attachNoColValue    = GD_GetCellValueIndex(GridObj, rowIndex, attachNoColIndex);
		
		if(attachCountColValue > 0){
			//FileAttach('FILE', attachNoColValue, 'VI');
     		fnFiledown(attachNoColValue);
		}
	} else if(header_name == "VENDOR_NAME") {
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
				
		var url    = '/s_kr/admin/info/ven_bd_con.jsp';
		var title  = '업체상세조회';
		var param  = 'popup=Y';
		param     += '&mode=irs_no';
		param     += '&vendor_code=' + vendor_code;
		popUpOpen01(url, title, '900', '700', param);
	} else if( header_name == "ITEM_NO" ) {
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}
	
	
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
    
    if(status == "true") {
    	opener.doSelect();
    	window.close();
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

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}


</script>
</head>
<body bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:fnBodyOnLoad();">
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">실사요청 상세화면</td>
		</tr>
	</table>
	<form name="form1" id="form1" action="">
		<input type="hidden" id="osqNo"    name="osqNo"    value="<%=request.getParameter("OSQ_NO") %>"    />
		<input type="hidden" id="osqCount" name="osqCount" value="<%=request.getParameter("OSQ_COUNT") %>" />
		
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청명</td>
										<td width="35%"  class="data_td">
											<input type="text" name="subject" id="subject" style="width:95%" readonly="readonly">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청일자</td>
										<td width="35%"  class="data_td">
											<input type="text" name="osqDate" id="osqDate" style="width:95%" readonly="readonly">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특이사항</td>
										<td class="data_td" colspan="3">
											<input type="text" name="remark" id="remark" style="width:95%" value="" readonly="readonly">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>			
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3">
											<table width="100%" >
												<tr>
													<td height="3"></td>
												</tr>
												<tr>
													<td>
														<iframe id="attachFrm" name="attachFrm" src="" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
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
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" bgcolor="#ffffff"  align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD >
<script language="javascript">
btn("javascript:window.print()", "인  쇄");
</script>
							</TD>
							<TD >
<script language="javascript">
btn("javascript:window.close()", "닫  기");
</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>	
		<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
	</form>
	<form name="fileAttachDownloadViewFrm" id="fileAttachDownloadViewFrm" action="/sepoafw/filelob/file_attach_downloadView.jsp" target="attachFrm">
		<input type="hidden" id="attach_key" name="attach_key" value="">
		<input type="hidden" id="view_type" name="view_type" value="VI">
	</form>	
</s:header>
<s:grid screen_id="MA_017" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>