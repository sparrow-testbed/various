<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SBD_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SBD_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) );
    String  to_date     = SepoaString.getDateSlashFormat( SepoaDate.getShortDateString());

    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String purchase_block_flag = info.getSession("PURCHASE_BLOCK_FLAG");	
%> 
<!--
title_tdle:         가격입찰  <p>
 Description:  가격입찰<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!--> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)--> 
<script language="javascript">
<!--
    var mode;
 
    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    server_time = GD_GetParam(GridObj,0);

       	    clock("s");
	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click

            BID_NO              = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT           = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            BID_STATUS          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);
            BID                 = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID);
            PARTICIPATE_FLAG    = GD_GetCellValueIndex(GridObj,msg2, INDEX_PARTICIPATE_FLAG);
            VOTE_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_FLAG);
            FINAL_FLAG          = GD_GetCellValueIndex(GridObj,msg2, INDEX_FINAL_FLAG);
            SPEC_FLAG           = GD_GetCellValueIndex(GridObj,msg2, INDEX_SPEC_FLAG);
            BID_CANCEL          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_CANCEL);
            CONT_TYPE2          = GD_GetCellValueIndex(GridObj,msg2, INDEX_CONT_TYPE2);

            VOTE_COUNT          = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_ATTACH_VIEW) {
                var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_VIEW));

                if("" != ATTACH_VIEW_VALUE) {
                    rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
                }
            } else if(msg3 == INDEX_BID) {
                var ENABLE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ENABLE_YN));
                var ANNOUNCE_FLAG = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_FLAG));
                var ANNOUNCE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_YN));

				if(ENABLE_YN == "N") {
                    alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
                    return;
                }
                if(BID == "F") {
                    alert("아직 진행중인 건이 아닙니다.");
                    return;
                }
                if(BID == "C") {
                    alert("이미 종료된 건입니다.");
                    return;
                }
                if(BID_CANCEL == "Y"){
                    alert("입찰 취소하신 건입니다.");
                    return;
                }
                if(VOTE_FLAG != "0") {
                    alert("이미 제출을 하신 건입니다.");
                    return;
                }
				if(FINAL_FLAG == "N") {
					alert("적합업체로 선정되지 못한 업체는 가격입찰을 하실수 없습니다.");
					return;
				}
                if(CONT_TYPE2 != "LP") {
                	if(PARTICIPATE_FLAG == "0"){
						alert("참가신청을 하지 않거나 입찰 취소하신 건입니다.");
						return;
					}
                    if(SPEC_FLAG != "Y") {
                        alert("1차평가에서 부적합업체로 선정되어 가격입찰을 하실수 없습니다.");
                        return;
                    }
					if(BID_STATUS == "RC" || BID_STATUS == "SC" || BID_STATUS == "QC") {
					} else {
						alert("아직 마감되지 않은 건입니다.");
						return;
					}
                }
                if(ANNOUNCE_FLAG == "Y"){
                	if(ANNOUNCE_YN == "N"){
	                	alert("제안설명회 미참석 업체는 신청하실 수 없습니다.");
	                    return;
                	}
                }
                location.href="ebd_pp_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_price_list_seller";

function init() {
	$("#bid_flag").val("P");
	setGridDraw();
    doQuery();
	setInterval(doQuery,180000);
	printDate();
	<% if("B".equals(purchase_block_flag) || "Y".equals(purchase_block_flag)) { %>
		alert("입찰금지\r\n\r\n-우리은행 총무부-");
		history.back();		
	<% } %>
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
    var params = "mode=getBdPriceList";
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

function doBid() { 
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 
    
	

    for( var i = 0; i < grid_array.length; i++ ) {
            chkcnt++; 
			
            BID_NO              = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
            BID_COUNT           = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
            BID_STATUS          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
            BID                 = GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue();
            PARTICIPATE_FLAG    = GridObj.cells(grid_array[i], GridObj.getColIndexById("PARTICIPATE_FLAG")).getValue();
            VOTE_FLAG           = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_FLAG")).getValue();
            FINAL_FLAG          = GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue();
            SPEC_FLAG           = GridObj.cells(grid_array[i], GridObj.getColIndexById("SPEC_FLAG")).getValue();
            BID_CANCEL          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_CANCEL")).getValue();
            CONT_TYPE2          = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2")).getValue();
            VOTE_COUNT          = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
            ENABLE_YN 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ENABLE_YN")).getValue());
            ANNOUNCE_FLAG 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_FLAG")).getValue());  
            ANNOUNCE_YN 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_YN")).getValue());   
            COST_STATUS 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue());   
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
	if(ENABLE_YN == "N") {
        alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
        return;
    }
	if(COST_STATUS != "EC") {
        alert("입찰조건이 갖추어지지 않았습니다.\n총무부 전자입찰 시스템 담당자에게 문의하시기 바랍니다.");
        return;
    }
    if(BID == "F") {
        alert("아직 진행중인 건이 아닙니다.");
        return;
    }
    if(BID == "C") {
        alert("이미 종료된 건입니다.");
        return;
    }
    if(BID_CANCEL == "Y"){
        alert("입찰 취소하신 건입니다.");
        return;
    }
    if(VOTE_FLAG != "0") {
        alert("이미 입찰서를 제출하신 건입니다.");
        return;
    }
	if(FINAL_FLAG != "Y") {
		alert("적합업체로 선정되지 못한 업체는 가격입찰을 하실수 없습니다.");
		return;
	}
	// 총액 입찰이 아닌 경우에는 참가신청 후 합격을 해야한다.
    if(CONT_TYPE2 != "LP") {
    	if(PARTICIPATE_FLAG == "0"){
			alert("참가신청을 하지 않거나 입찰 취소하신 건입니다.");
			return;
		}
        if(SPEC_FLAG != "Y") {
            alert("평가에서 부적합 업체로 선정되어 가격입찰을 하실수 없습니다.");
            return;
        }
        //가격입찰, 2단계가격입찰, 적격심사가격입찰
		if(BID_STATUS == "RC" || BID_STATUS == "SC" || BID_STATUS == "QC") {
		} else {
			alert("아직 마감되지 않은 건입니다.");
			return;
		}
    }
    if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN == "N") {
       	alert("제안설명회 미참석 업체는 입찰에 참여하실 수 없습니다.");
		return;
    }
    //location.href="ebd_pp_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;

	var f = document.forms[0];
	f.BID_NO.value            = BID_NO;
	f.BID_COUNT.value		   = BID_COUNT; 
	f.VOTE_COUNT.value		   = VOTE_COUNT; 
	f.target                   = "_self"; 
	f.method                   = "post";   
	f.action = "bd_price_seller_insert.jsp";
	f.submit();
}

function doBidCancel(){
	
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 

    for( var i = 0; i < grid_array.length; i++ ) {
		chkcnt++; 
			
		BID_NO              = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        BID_COUNT           = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        BID_STATUS          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        BID                 = GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue();
        PARTICIPATE_FLAG    = GridObj.cells(grid_array[i], GridObj.getColIndexById("PARTICIPATE_FLAG")).getValue();
        VOTE_FLAG           = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_FLAG")).getValue();
        FINAL_FLAG          = GridObj.cells(grid_array[i], GridObj.getColIndexById("FINAL_FLAG")).getValue();
        SPEC_FLAG           = GridObj.cells(grid_array[i], GridObj.getColIndexById("SPEC_FLAG")).getValue();
        BID_CANCEL          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_CANCEL")).getValue();
        CONT_TYPE2          = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2")).getValue();
        VOTE_COUNT          = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
        ENABLE_YN 			= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ENABLE_YN")).getValue());
        ANNOUNCE_FLAG 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_FLAG")).getValue());  
        ANNOUNCE_YN 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_YN")).getValue());   
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
	if(ENABLE_YN == "N") {
        alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
        return;
    }
    if(BID == "F") {
        alert("아직 진행중인 건이 아닙니다.");
        return;
    }
    if(BID == "C") {
        alert("이미 종료된 건입니다.");
        return;
    }
    if(BID_CANCEL == "Y"){
        alert("이미 입찰 취소하신 건입니다.");
        return;
    }
    if(VOTE_FLAG == "0") {
        alert("입찰여부가 'Y' 인 상태만 취소할 수 있습니다.");
        return;
    }
    
    if(!confirm("입찰취소 시 다시 입찰할 수 없습니다. \n입찰을 취소하시겠습니까?")) return;
    
    var grid_array = getGridChangedRows(GridObj, "SELECTED");
    var cols_ids = "<%=grid_col_id%>";
    var params;
    params = "?mode=setBidCancel";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    //myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);

}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
 
<form name="form" >
	<input type="hidden" name="ctrl_code" id="ctrl_code" value=""> 
	<input type="hidden" name="att_mode"  id="att_mode"  value="">
	<input type="hidden" name="view_type"  id="view_type"  value="">
	<input type="hidden" name="file_type"  id="file_type"value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no"value="">

	<input type="hidden" name="BID_NO" id="BID_NO" value="">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT" value="">
	<input type="hidden" name="SCR_FLAG" >

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
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰일자
      </td>
      <td width="35%" class="data_td"> 
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
         
	  </td> 
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
      <td width="35%" class="data_td">
        <select name="bid_flag" id="bid_flag" class="inputsubmit">
          <option value="">전체</option>
          <option value="P">입찰진행중</option>
          <option value="F">입찰대기</option>
          <option value="C">입찰종료</option>

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
        <input type="text" name="ann_item" id="ann_item" style="width:95%" class="inputsubmit">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">
        &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;현재시간
      </td>
      <td width="35%" colspan="3" class="data_td">
        			<div id="id1"></div>
			        <input type="hidden" name="h_server_date" class="input_empty" size="50" readonly> 
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
          <% if(!"B".equals(purchase_block_flag) && !"Y".equals(purchase_block_flag)) { %>
          <td><script language="javascript">btn("javascript:doBid()", "입 찰")</script></td>
          <td><script language="javascript">btn("javascript:doBidCancel()", "입찰취소")</script></td>
          <% } %>
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
<%-- <s:grid screen_id="SBD_003" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


