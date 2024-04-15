<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_242");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_242";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String mode = JSPUtil.nullToEmpty(request.getParameter("mode"));
	
   	String HOUSE_CODE = info.getSession("HOUSE_CODE");

	String RFQ_NO = "";
	String SUBJECT = "";
	String RFQ_COUNT = "";
	String SZDATE = "";
	String START_TIME = "";
	String END_TIME = "";
	String HOST = "";
	String AREA = "";
	String PLACE = "";
	String notifier = "";
	String doc_frw_date = "";
	String resp = "";
	String comment = "";

	if(mode.equals("I")) { //입력
		RFQ_NO = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
		RFQ_COUNT = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
		String subject 	= JSPUtil.nullToEmpty(request.getParameter("subject"));
		SUBJECT 		= subject;
	}

	else if(mode.equals("IM")) { //입력후 수정
		String m_RFQ_NO 	= JSPUtil.nullToEmpty(request.getParameter("RFQ_NO"));
		String m_SUBJECT 	= JSPUtil.nullToEmpty(request.getParameter("SUBJECT"));
		String m_RFQ_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("RFQ_COUNT"));
		String m_SZDATE 	= JSPUtil.nullToEmpty(request.getParameter("SZDATE"));
		String m_START_TIME = JSPUtil.nullToEmpty(request.getParameter("START_TIME"));
		String m_END_TIME 	= JSPUtil.nullToEmpty(request.getParameter("END_TIME"));
		String m_HOST 		= JSPUtil.nullToEmpty(request.getParameter("HOST"));
		String m_AREA 		= JSPUtil.nullToEmpty(request.getParameter("AREA"));
		String m_PLACE 		= JSPUtil.nullToEmpty(request.getParameter("PLACE"));
		String m_notifier 	= JSPUtil.nullToEmpty(request.getParameter("notifier"));

		String m_doc_frw_date 	= JSPUtil.nullToEmpty(request.getParameter("doc_frw_date"));
		String m_resp 			= JSPUtil.nullToEmpty(request.getParameter("resp"));
		String m_comment 		= JSPUtil.nullToEmpty(request.getParameter("comment"));

		RFQ_NO = m_RFQ_NO;
		SUBJECT = m_SUBJECT;
		RFQ_COUNT = m_RFQ_COUNT;
		SZDATE = m_SZDATE;
		START_TIME = m_START_TIME;
		END_TIME = m_END_TIME;
		HOST = m_HOST;
		AREA = m_AREA;
		PLACE = m_PLACE;
		notifier = m_notifier;

		doc_frw_date = m_doc_frw_date;
		resp = m_resp;
		comment = m_comment;
	}

	else if(mode.equals("M")) { //수정
		String rfq_no = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
		String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));

		Object[] obj = {rfq_no, rfq_count};
		
		SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqAnnounce", obj);
		
		SepoaFormater wf = new SepoaFormater(value.result[0]);

       	if(wf != null) {
       		if(wf.getRowCount() > 0) { //데이타가 있는 경우
       			int n = 0;

       			RFQ_NO 			= wf.getValue("RFQ_NO", 0);
       			SUBJECT 		= wf.getValue("SUBJECT", 0);
       			RFQ_COUNT 		= wf.getValue("RFQ_COUNT", 0);
       			SZDATE 			= wf.getValue("ANNOUNCE_DATE", 0);
       			START_TIME 		= wf.getValue("ANNOUNCE_TIME_FROM", 0);
       			END_TIME 		= wf.getValue("ANNOUNCE_TIME_TO", 0);
       			HOST 			= wf.getValue("ANNOUNCE_HOST", 0);
       			AREA 			= wf.getValue("ANNOUNCE_AREA", 0);
       			PLACE 			= wf.getValue("ANNOUNCE_PLACE", 0);
       			notifier 		= wf.getValue("ANNOUNCE_NOTIFIER", 0);

       			doc_frw_date 	= wf.getValue("DOC_FRW_DATE", 0);
       			resp 			= wf.getValue("ANNOUNCE_RESP", 0);
       			comment 		= wf.getValue("ANNOUNCE_COMMENT", 0);
       		}
		}


	}
	String WISEHUB_PROCESS_ID="RQ_242";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
var today = "<%=SepoaDate.getShortDateString()%>";
	
function doInsert() {
	var st_hour = (form1.start_time.value).substring(0,2);
	var st_min  = (form1.start_time.value).substring(2,4);
	var et_hour = (form1.end_time.value).substring(0,2);
	var et_min  = (form1.end_time.value).substring(2,4);
		
	var szdate = LRTrim(del_Slash(form1.date.value)); 
		
	if(szdate == "") {
		alert("개최일자를 반드시 입력하셔야 합니다.");
		
		form1.date.focus();
		
		return;
	}
		
	if(st_hour > 24) {
		alert("시간이 형식에 맞지 않습니다. ");
		
		form1.start_time.select();
		
		return;
	}
	
	if(st_min > 59) {
		alert("시간이 형식에 맞지 않습니다. ");
		
		form1.start_time.select();
		
		return;
	}
		
	if(et_hour > 24) {
		alert("시간이 형식에 맞지 않습니다. ");
		
		form1.end_time.select();
		
		return;
	}
	
	if(et_min > 59) {
		alert("시간이 형식에 맞지 않습니다. ");
		
		form1.end_time.select();
		
		return;
	}

	if(eval(szdate) < eval(today)) {
		alert("개최일은 오늘날짜 이후여야 합니다.");
		
		return;
	}

	opener.setExplanation(document.getElementById("RFQ_NO").value, "<%=SUBJECT%>", "<%=RFQ_COUNT%>",
			szdate, form1.start_time.value, form1.end_time.value,
			form1.host.value, form1.area.value, form1.place.value, form1.notifier.value,
			"", form1.resp.value, form1.comment.value);

	window.close();
}
	
function doDelete() {
	form1.date.value = "";
	form1.start_time.value = "";
	form1.end_time.value = "";
	form1.host.value = "";
	form1.area.value = "";
	form1.place.value = "";
	form1.notifier.value = ""; 
	form1.resp.value = "";
	form1.comment.value = "";
		
	opener.setExplanation(
			document.getElementById("RFQ_NO").value, "<%=SUBJECT%>", "<%=RFQ_COUNT%>",
			del_Slash(form1.date.value), form1.start_time.value, form1.end_time.value,
			form1.host.value, form1.area.value, form1.place.value, form1.notifier.value,
			"", form1.resp.value, form1.comment.value);

	window.close();
}
	
function date1(year,month,day,week) {
	document.form1.date.value=year+month+day;
}
	
function date2(year,month,day,week) {
    document.form1.doc_frw_date.value=year+month+day;
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
    var msg    = GridObj.getUserData("", "message");
    var status = GridObj.getUserData("", "status");

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
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true"> 
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>제안설명회 안내</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD>
	    	  				<script language="javascript">
	    	  					btn("javascript:doInsert()", "저 장");
	    	  				</script>
	    	  			</TD>
						<TD>
							<script language="javascript">
								btn("javascript:doDelete()", "삭 제");
							</script></TD>
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
	<form name="form1" >
		<input type="hidden" name="RFQ_NO" id="RFQ_NO" value="<%=RFQ_NO%>">
		<input type="hidden" name="host">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
										<td width="35%" class="data_td">
											<%=RFQ_NO%>&nbsp
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
										<td width="35%" class="data_td">
											<%=RFQ_COUNT%>&nbsp
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
										<td class="data_td" colspan="3">
											<%=SUBJECT%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;개최일자</td>
										<td width="35%" class="data_td">
											<s:calendar id="date" default_value="<%=SepoaString.getDateSlashFormat(SZDATE)%>" format="%Y/%m/%d"/>
											<br/>
											&nbsp&nbsp(ex : <b>2010/07/15</b>)
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;시간</td>
										<td width="35%" class="data_td">
											<input type="text" name="start_time" size="4" class="inputsubmit" maxlength=4 value="<%=START_TIME%>" style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]', this)">
	        								~
											<input type="text" name="end_time" size="4" class="inputsubmit" maxlength=4 value="<%=END_TIME%>" style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]', this)">
											<br/>
											&nbsp;&nbsp;(ex : <b>1330</b>)
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지역</td>
										<td width="35%" class="data_td">
											<input type="text" name="area" style="width:80%" class="inputsubmit" maxlength=10 value="<%=AREA%>" onKeyUp="return chkMaxByte(10, this, '지역');">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;장소</td>
										<td width="35%" class="data_td">
											<input type="text" name="place" style="width:80%" class="inputsubmit" maxlength=30 value="<%=PLACE%>" onKeyUp="return chkMaxByte(30, this, '장소');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고자</td>
										<td width="35%" class="data_td">
											<input type="text" name="notifier" style="width:80%" class="inputsubmit" maxlength=30 value="<%=notifier%>" onKeyUp="return chkMaxByte(30, this, '공고자');">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;담당자/문의처</td>
										<td width="35%" class="data_td">
											<input type="text" name="resp" style="width:80%;" class="inputsubmit" maxlength=30 value="<%=resp%>" onKeyPress="" onKeyUp="return chkMaxByte(30, this, '담당자/문의처');">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
										<td class="data_td" colspan="3" style="height: 80px">
											<textarea name="comment" cols="73" class="inputsubmit" style="width: 98%;height: 60px" maxlength=400 rows="5" onKeyUp="return chkMaxByte(4000, this, '특기사항');"><%=comment%></textarea>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
	  	</table>
	</form>
</s:header>
<s:footer/>
</body>
</html>