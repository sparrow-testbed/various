<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SBD_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SBD_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) );
    String  to_date     = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1) );

%> 
<!--
title_tdle:         입찰결과  <p>
 Description:  입찰결과<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!--> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<%
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)--> 
<script language="javascript">
<!--
    var mode;
 
    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
			for (var i = 0; i < GridObj.GetRowCount(); i++) {
				if( "Yes" == GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_SETTLE_FLAG),i)) {
        			for (var j = 0; j < GridObj.GetColCount(); j++) {
    					//GridObj.SetCellBgColor(GridObj.GetColHDKey( j),i, "254|251|226");
        			}
				}
			}

	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click

            BID_NO          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT       = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            VOTE_COUNT      = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);
            ANN_NO          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_NO),msg2);
            ANN_ITEM        = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_ITEM),msg2);
            STATUS          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),msg2);
            SETTLE_FLAG     = GD_GetCellValueIndex(GridObj,msg2, INDEX_SETTLE_FLAG);

            var front_status = STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            }
            if(msg3 == INDEX_ANN_ITEM) {
				/*            
                if(STATUS == "SB" && SETTLE_FLAG == "Y") { // 입찰공고, 정정공고
                    window.open('/s_kr/bidding/bidd/ebd_pp_ins4.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT+'&VOTE_COUNT='+VOTE_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                }else{
                	alert("낙찰되지 않은 건 입니다.");
                	return;
                }
				*/
            }
        }
    }
 
//-->
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
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_result_list_seller";
 
function init() {
	setGridDraw(); 
    doQuery();
}
	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if( header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());      
<%--         var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/bd_ann_detail.jsp";	 --%>

		var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
		
		var url = "/sourcing/bd_ann_d_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'1100','700');
    }else if(header_name == "ANN_ITEM"){
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());     
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());     
        //url =  "bd_open_compare_pop.jsp?BID_NO="+bid_no+"&BID_COUNT="+bid_count+"&VOTE_COUNT="+vote_count;
        //doOpenPopup(url,'1100','700');            
        var url    = '/sourcing/bd_open_compare_pop.jsp';
		var title  = '개찰결과';
		var param  = 'popup=Y';
		param     += '&BID_NO=' + bid_no;
		param     += '&BID_COUNT=' + bid_count;
		param     += '&VOTE_COUNT=' + vote_count;
		popUpOpen01(url, title, '1100', '700', param);   
    }
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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdResultListSeller";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}
function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.forms[0].start_change_date.value = add_Slash( document.forms[0].start_change_date.value );
    document.forms[0].end_change_date.value   = add_Slash( document.forms[0].end_change_date.value   );
   
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<form name="form1" >
<input type="hidden" name="BID_NO" >
<input type="hidden" name="BID_COUNT" >
<input type="hidden" name="SCR_FLAG" value="">
<input type="hidden" name="ctrl_code" value="">

<%@ include file="/include/sepoa_milestone.jsp"%>
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
    <td width="100%" valign="top">
        <table width="100%" class="board-search"border="0" cellpadding="0" cellspacing="0">
            <colgroup>
                <col width="15%" />
                <col width="35%" />
                <col width="15%" />
                <col width="35%" />
            </colgroup> 
 
    <tr>
      <td width="15%" class="title_td">
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;가격입찰일자
      </td>
      <td width="35%" class="data_td">
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;낙찰여부</td>
      <td width="35%" class="data_td">
        <select name="bid_flag" id="bid_flag" class="inputsubmit">
          <option value="">전체</option>
          <option value="SB">낙찰</option>
          <option value="NE">미선정</option>
          <option value="NB">유찰</option>
        </select>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공고번호
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_no" id="ann_no" style="ime-mode:inactive" size="20" maxlength="20" class="inputsubmit">
      </td>
      <td width="15%" class="title_td">
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_item" id="ann_item" size="50"  class="inputsubmit">
      </td>
    </tr>
    
    <tr style="display:none;">
      <td width="15%" class="title_td">
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;낙찰업체
      </td>
      <td width="35%" class="data_td" colspan="3">
        <input type="text" name="settle_vendor" id="settle_vendor" class="inputsubmit" size="20">
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
      <td height="30">
        <div align="right">        
        <table><tr>
          <td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
          <td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
		  </tr></table>  
        </div>
      </td>
    </tr>
  </table> 
      </td>
    </tr>
  </table>
</form>

<!---- END OF USER SOURCE CODE ---->

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SBD_005" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


