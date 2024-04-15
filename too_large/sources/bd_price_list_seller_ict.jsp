<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SBD_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SBD_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) );
    String  to_date     = SepoaString.getDateSlashFormat( SepoaDate.getShortDateString());

    String house_code   = info.getSession("HOUSE_CODE");
	String user_id		= info.getSession("ID");
	String ctrl_code	= info.getSession("CTRL_CODE");
%> 
<!--
 title_tdle:   가격입찰  <p>
!--> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)--> 

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_price_list_seller_ict";

function init() {
//	$("#bid_flag").val("P");
	setGridDraw();
    doQuery();
	setInterval(doQuery,60000);
	printDate();
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

		var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
		
		var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version+"&VIEW_KIND=SUPPLY";
		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'1100','700');
    }
}

//그리드 1건만 선택하도록 하는 소스
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    	if( header_name == "SELECTED" ) {
    		var gg = getGridSelectedRows(GridObj, "SELECTED");
    		if(gg !=0){
    			
    			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
    			{
    				//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
    			}
    		}
    		
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	row_id = rowId;
	    	return true;
    	}
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

<%--입찰(투찰)--%>
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

            ENABLE_YN 		    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ENABLE_YN")).getValue());
            ANNOUNCE_FLAG 	    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_FLAG")).getValue());  
            ANNOUNCE_YN 	    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_YN")).getValue());   
            COST_STATUS 	    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue());   
            
            RANK_FST_SME_YN 	    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("RANK_FST_SME_YN")).getValue());   
            RANK_FST_SME_YN2 	    = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("RANK_FST_SME_YN2")).getValue());
            
            BF_PTC_YN           = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BF_PTC_YN")).getValue());
	} // for문끝

	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}

	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
	
	if(BF_PTC_YN == "N"){
		alert("재입찰대상업체가 아닙니다.\r\n이전차수 참여업체만 입찰참여 가능합니다.");
	    return;
	}
	
	if(RANK_FST_SME_YN2 != "0" && RANK_FST_SME_YN != "Y"){
	    alert("재입찰대상업체가 아닙니다.");
	    return;
	}
	

	if(ENABLE_YN == "N") {
		<%--쿼리에서 모든 값이 'Y' --%>
        alert("제재기간중이므로 입찰에 참가할 수 없습니다.");
        return;
    }

	<%--내정가격확정:ICT는 입찰마감전까지 내정가격을 입력할수 있음.--%>
	if(COST_STATUS != "EC") {
        //alert("입찰조건이 갖추어지지 않았습니다.\nICT지원센터 시스템 담당자에게 문의하시기 바랍니다.");
        //return;
    }

	if(BID == "F") {
    	<%--P:진행중,F:예정중, C:종료 --%>
        alert("아직 진행중인 건이 아닙니다.");
        return;
    }
	
    if(BID == "C") {
        alert("이미 종료된 건입니다.");
        return;
    }
    
    if(BID_CANCEL == "Y"){
        alert("입찰 취소한 건입니다. 다음차수부터 입찰 참여가 가능합니다.");
        return;
    }    
    
    

    <%--역경매는 중복 투찰이 가능함.--%>
    if(CONT_TYPE2 != "RA" && CONT_TYPE2 != "RC" && VOTE_FLAG != "0") {
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
        <%--제한경쟁에 대한 제약:ICT 사용하지 않음.--%>
    	if(SPEC_FLAG != "Y") {
            alert("평가에서 부적합 업체로 선정되어 가격입찰을 하실수 없습니다.");
            return;
        }
        <%--가격입찰, 2단계가격입찰, 적격심사가격입찰 : 의미없음--%>
		if(BID_STATUS == "RC" || BID_STATUS == "SC" || BID_STATUS == "QC") {
		} else {
			//alert("아직 마감되지 않은 건입니다.");
			//return;
		}
    }
    if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN == "N") {
    	<%--사용하지 않음.--%>
       	//alert("제안설명회 미참석 업체는 입찰에 참여하실 수 없습니다.");
		//return;
    }
    //location.href="ebd_pp_ins1.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;

	var f = document.forms[0];
	f.BID_NO.value		= BID_NO;
	f.BID_COUNT.value	= BID_COUNT; 
	f.VOTE_COUNT.value	= VOTE_COUNT; 
	f.method			= "post";   
	f.action			= "bd_price_seller_insert_ict.jsp";
	f.target			= "_self";
	f.submit();

}

// 입찰취소
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
    
    if(!confirm("입찰취소 시 다음차수부터 입찰참여가 가능합니다. \n입찰을 취소하시겠습니까?")) return;        
    
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
													&nbsp;
													<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰일자
												</td>
												<td width="35%" class="data_td">
													<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"
													id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
												</td>
												<td width="15%" class="title_td">
													&nbsp;
													<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;진행상태
												</td>
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
													&nbsp;
													<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;공문번호
												</td>
												<td width="35%" class="data_td">
													<input type="text" name="ann_no" id="ann_no" style="ime-mode:inactive" size="20" maxlength="20" class="inputsubmit">
												</td>
												<td width="15%" class="title_td">
													&nbsp;
													<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰건명
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
													&nbsp;
													<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;현재시간
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
						<td align="left"><span style="font-size:15px">[※] 입찰시작일시 / 입찰마감일시 : 1회 투찰시간<br>[※] 입찰결과 : 입찰마감시간</span><span style="color:red;font-weight:bold;font-size:15px"> 1분 후 입찰결과</span> <span style="font-size:15px">에서 확인 가능</span>
							    </td>									
						<td height="50">							
							<div align="right">									
							<table>
								<tr>
									<td align="right"><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
									<td align="right"><script language="javascript">btn("javascript:doBid()", "입 찰")</script></td>
									<td align="right"><script language="javascript">btn("javascript:doBidCancel()", "입찰취소")</script></td>									
								</tr>
							</table>
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
<%-- <s:grid screen_id="I_SBD_003" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


