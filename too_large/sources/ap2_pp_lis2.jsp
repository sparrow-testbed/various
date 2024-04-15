<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_026");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_026";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/wisehub_common.jsp"%>
<% String WISEHUB_PROCESS_ID="AP_026";%>
<%@ include file="/include/wisehub_session.jsp" %>

<%
	String SIGN_REMARK    	= JSPUtil.nullToEmpty(request.getParameter("SIGN_REMARK"));
	String GUBUN  			= JSPUtil.nullToEmpty(request.getParameter("GUBUN"));
	String ROW  			= JSPUtil.nullToEmpty(request.getParameter("ROW"));
	
	String TITLE = "결재상신 화면";
%>

<html>
	<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
		<%@ include file="/include/wisehub_scripts.jsp" %>
		<script language="javascript">

function init() {
	var row = "<%=ROW%>";
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	//var SIGN_REMARK2  = opener.GridObj.GetColHDIndex("SIGN_REMARK2");
	document.forms[0].remark.value = opener.parent.body.GridObj.GD_GetCellValueIndex(GridObj,row, SIGN_REMARK);
}

function doInsert() {
	var remark = document.forms[0].remark.value;

<% 
	if ( GUBUN.equals("M") ) { 
%>
	var row = "<%=ROW%>";
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	opener.GridObj.AddImageList("SIGN_REMARK","/kr/images/button/query.gif");	
	opener.GridObj.SetCellImage("SIGN_REMARK",row,0);
	opener.GridObj.SetCellValueIndex("SIGN_REMARK",row,remark);
<% 
	} else { 
%>
	var row = "<%=ROW%>";
	var SIGN_REMARK  = opener.GridObj.GetColHDIndex("SIGN_REMARK");
	var SIGN_REMARK_HIDDEN  = opener.GridObj.GetColHDIndex("SIGN_REMARK_HIDDEN");
	//alert( "SIGN_REMARK: " + SIGN_REMARK + "SIGN_REMARK_HIDDEN: " + SIGN_REMARK_HIDDEN );
	opener.GridObj.AddImageList("SIGN_REMARK","/kr/images/button/query.gif");	
	opener.GridObj.SetCellImage("SIGN_REMARK",row,0);
	opener.GridObj.SetCellValueIndex(SIGN_REMARK,row,remark);
	opener.GridObj.SetCellValueIndex(SIGN_REMARK_HIDDEN,row,remark);
<% 	 
	}   
%>
	window.close();
}
</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
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
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
<body onload="init();GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<form name="form1">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="cell_title1" width="78%" align="left">&nbsp;
		<% 
		if (GUBUN.equals("") || GUBUN.equals("O") || GUBUN.equals("M")) { 
		%>
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12"> 결재요청
		<% 
		} else { 
		%>		
		<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12"> 결재의견조회
		<%
		}
		%>
  		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="1" cellpadding="1" bgcolor="#ccd5de">
		<tr>
	   		<td width="15%" class="c_title_1" >
	  		<% 
	  		if (GUBUN.equals("") || GUBUN.equals("O") || GUBUN.equals("M")) { 
	  		%>
	  			<div align="center">상신의견</div>
	  		<% 
	  		} else { 
	  		%>
		 		<div align="center">결재의견</div>
	  		<% 
	  		} 
	  		%>
	  		</td>
	   		<td class="c_data_1" colspan="3">
	  			<textarea name="remark" class="inputsubmit" value="" cols="70" rows="5"><%=SIGN_REMARK%></textarea>
		</tr>
  	</table>
	<script language="JavaScript" ></script> 
  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
				<% 
				if (GUBUN.equals("") || GUBUN.equals("M") ) { 
				%>
						<TD><script language="javascript">btn("javascript:doInsert()",7,"확 인")   </script></TD>
				<% 
				} 
				%>
		      			<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")</script></TD>
	    	  		
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
 </form>

</s:header>
<s:grid screen_id="AP_026" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


