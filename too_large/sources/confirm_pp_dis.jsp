<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_248");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_248";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_248";%>
<%--
 Title:        		mat_pp_inv1.jsp <p>
 Description:  	코드 POPUP<p>
 Copyright:    	Copyright (c) <p>
 Company:     ICOMPIA <p>
 @author       	DEV.Team Hong Sun Hee<p>
 @version      1.0.0<p>
 @Comment    Code Search<p>
--%>

 
<%
		String mode			= JSPUtil.nullToEmpty(request.getParameter("mode"));		// 저장기능인지 읽기기능인지 	update/""
		String from 		= JSPUtil.nullToEmpty(request.getParameter("from"));		// 어느 화면에서 온것인지.		화면명
		String row 			= JSPUtil.nullToEmpty(request.getParameter("row"));			// 그리드 로우 인덱스			1
		String function 	= JSPUtil.nullToEmpty(request.getParameter("function"));	// 리턴할 함수					setReason
		String column		= JSPUtil.nullToEmpty(request.getParameter("column")) ;		// WiseGridm 헤더컬럼명			REASON
		String columnType	= JSPUtil.nullToEmpty(request.getParameter("columnType")); 	// 								t_text, t_imagetext
		String title		= JSPUtil.nullToEmpty(request.getParameter("title")); 		// 								 								
		String useAttach	= JSPUtil.nullToEmpty(request.getParameter("useAttach")); 	// 첨부파일 사용유무			Y,N
		String attach_no	= JSPUtil.nullToEmpty(request.getParameter("attach_no")); 	// 첨부파일 		
		String maxByte		= JSPUtil.nullToEmpty(request.getParameter("maxByte")); 	// maxByte
%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">

function save() {
<%
	if(!"".equals(function)){
		if ("Y".equals(useAttach)) {
%>	
			document.attachFrame.setData();	//startUpload
<%		
		} else {
%>
			doEnd();
<%	
		}	
	}
%>	
}
    function doEnd() {
		var value  = document.form1.REASON.value;
		var row    = "<%=row%>";
		var att_no = document.form1.attach_no.value;
		opener.<%=function%>(value, row, att_no);	
		self.close();
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
	
	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;
		
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;
		    
	    doEnd();
	}

function Init() {

var maxByte = 0;
   
<%
if(!"".equals(column)){
%>
	
<%	
	if("t_imagetext".equals(columnType)){
%>	
		maxByte = opener.GridObj.GetColMaxLength("<%=column%>");
		document.form1.maxByte.value = maxByte;
   		document.form1.REASON.value = opener.GridObj.GetCellHiddenValue("<%=column%>", "<%=row%>");
<%
	}else if("t_text".equals(columnType)){
%>
		maxByte = opener.GridObj.GetColMaxLength("<%=column%>");
		document.form1.maxByte.value = maxByte;
   		document.form1.REASON.value = opener.GridObj.GetCellValue("<%=column%>", "<%=row%>");
<%	
	}else if("".equals(columnType)){	//  그리드가 아닌 일반 html의 input, textarea
%>	
		maxByte = "<%=maxByte%>" == "" ? "250" : "<%=maxByte%>";
		document.form1.maxByte.value = maxByte;
		document.form1.REASON.value = opener.document.forms[0].<%=column%>.value;
<%		
	}
}	 
%>
    
}

</script>



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
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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
<body onload="Init();">

<s:header>
<!--내용시작-->
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">
		<%=title%>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="100%" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
<%
		if("update".equals(mode)){
%>		      			
			<TD><script language="javascript">btn("javascript:save()","저 장")</script></TD>
<%
		}
%>						
			<TD><script language="javascript">btn("javascript:self.close()","닫 기")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<form name="form1">
	<input type="hidden" name="maxByte" value="">
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_no" value="<%=attach_no%>">
	<input type="hidden" name="attach_count" value="">
    
<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 사유</td>
	<td width="85%" class="c_data_1" >
		<textarea name="REASON" value="" rows = "10" cols = "80" class="inputsubmit" <%--style="overflow=hidden"--%> onKeyUp="return chkMaxByte(document.form1.maxByte.value, this, '<%=title%>');"><%//=Z_REMARK%></textarea>
	</td>
</tr>
<%
	if("Y".equals(useAttach)){
%>	    
<tr>
	<td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 첨부파일</td>
	<td class="c_data_1" height="200">
		<iframe name="attachFrame" width="520" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
		<br>&nbsp;
	</td>
</tr>
<%
	} else {
%>	    
		<iframe name="attachFrame" width="0" height="0" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
<%
	}
%>	    
</table>

</form>


</s:header>
<s:grid screen_id="RQ_248" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<script language="javascript">rMateFileAttach('S','C','RFQ',form1.attach_no.value);</script>


