<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SBD_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SBD_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateDay( to_day, -30 );
    String  to_date     = SepoaDate.addSepoaDateDay( to_day, +30 );
    
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%>
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

            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);
            APPLY       = GD_GetCellValueIndex(GridObj,msg2, INDEX_APPLY);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_pp_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_ATTACH_VIEW) {
                var ATTACH_VIEW_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_VIEW));

                if("" != ATTACH_VIEW_VALUE) {
                    rMateFileAttach('P','R','BD',ATTACH_VIEW_VALUE);
                }
            } else if(msg3 == INDEX_ANNOUNCE) {
                var ANNOUNCE_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE));

                if("Y" == ANNOUNCE_VALUE) {
                    window.open('/kr/dt/bidd/ebd_pp_ins1.jsp?mode=D&BID_NO=' + BID_NO + '&BID_COUNT=' + BID_COUNT ,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=860,height=260,left=0,top=0");
                }
            } else if(msg3 == INDEX_APPLY) {
                var ENABLE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ENABLE_YN));
                var ANNOUNCE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE));
                var ANNOUNCE_FLAG = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_FLAG));
                var ANNOUNCE_YN = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ANNOUNCE_YN));
                var APP_BEGIN_DATE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_APP_BEGIN_DATE_VALUE));
                var APP_END_DATE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_APP_END_DATE_VALUE));
                var h_server_date   = document.forms[0].h_server_date.value;
				
                if(ENABLE_YN == "N") {
                    alert("제재 기간중이므로 입찰에 참가할 수 없습니다.");
                    return;
                }
				if(APPLY == "Y") {
                    alert("이미 신청한 건입니다.");
                    return;
                }
                if(front_status == "C") {
                    alert("입찰공고 취소건은 신청하실 수 없습니다.");
                    return;
                }
                if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN != "Y"){
                	alert("제안설명회 미참석 업체는 신청하실 수 없습니다.");
                    return;
                }
                if(parseFloat(h_server_date) < parseFloat(APP_BEGIN_DATE)) {
                    alert("입찰 참가 신청 기간이 아닙니다.\n\n신청 기간을 확인하세요.");
                    return false;
                } else if(parseFloat(h_server_date) > parseFloat(APP_END_DATE)) {
                    alert("입찰 참가 신청 기간이 지났습니다.\n\n참가 신청을 하실 수 없습니다.");
                    return false;
                }
                location.href="ebd_pp_ins2.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_accept_list";

function init() {
	setGridDraw(); 
	doQuery();
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
        var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/bd_ann_detail.jsp";	
		
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
    var params = "mode=getBdAcceptList";
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
    
    return true;
}

function doAcceptBid() { 
    var chkcnt = 0;
    
    var BID_NO      	= "";
    var BID_COUNT   	= "";
    var BID_STATUS  	= "";
    var APPLY       	= "";
    var ENABLE_YN 		= "";
    var ANNOUNCE 		= "";
    var ANNOUNCE_FLAG 	= "";
    var ANNOUNCE_YN 	= "";
    var front_status 	= "";
    var APP_BEGIN_DATE 	= "";
    var APP_END_DATE 	= "";
    var h_server_date 	= "";
 
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "<%=grid_col_id%>"; 

    for( var i = 0; i < grid_array.length; i++ ) {
        var BID_NO          = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
        var BID_COUNT       = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
        var BID_STATUS      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
        var APPLY  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("APPLY")).getValue();
        var ENABLE_YN  = GridObj.cells(grid_array[i], GridObj.getColIndexById("ENABLE_YN")).getValue();
        var ANNOUNCE  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE")).getValue();
        var ANNOUNCE_FLAG  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_FLAG")).getValue();
        var ANNOUNCE_YN  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("ANNOUNCE_YN")).getValue();
            chkcnt++;
			 
            front_status 	= BID_STATUS.substring(0, 1);

            APP_BEGIN_DATE 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_BEGIN_DATE_VALUE")).getValue());
            APP_END_DATE 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("APP_END_DATE_VALUE")).getValue());
            h_server_date   = document.forms[0].h_server_date.value; 
	}
    
	if(chkcnt < 1){
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
	if(APPLY == "Y") {
        alert("이미 신청한 입찰건입니다.");
        return;
    }
    if(front_status == "C") {
        alert("입찰공고 취소건은 신청하실 수 없습니다.");
        return;
    }
    if(ANNOUNCE_FLAG == "Y" && ANNOUNCE_YN != "Y"){
       	alert("제안설명회 미참석 업체는 신청하실 수 없습니다.");
		return;
    }
    if(parseFloat(h_server_date) < parseFloat(APP_BEGIN_DATE)) {
        alert("입찰 참가 신청 기간이 아닙니다.\n\n신청 기간을 확인하세요.");
        return;
    } else if(parseFloat(h_server_date) > parseFloat(APP_END_DATE)) {
        alert("입찰 참가 신청 기간이 지났습니다.\n\n참가 신청을 하실 수 없습니다.");
        return;
    }
    //location.href="bd_accept_popup.jsp";

	var f = document.forms[0];
	f.BID_NO.value            = BID_NO;
	f.BID_COUNT.value		   = BID_COUNT; 
	f.target                   = "_self"; 
	f.method                   = "post";   
	f.action = "bd_accept_popup.jsp";
	f.submit();
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
 
<form name="form1" > 
	<input type="hidden" name="ctrl_code" id="ctrl_code" value=""> 
	<input type="hidden" name="att_mode"  id="att_mode"  value="">
	<input type="hidden" name="view_type"  id="view_type"  value="">
	<input type="hidden" name="file_type"  id="file_type"value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no"value="">
	
	<input type="hidden" name="BID_NO" id="BID_NO"value="">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT"value="">
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
    <colgroup>
        <col width="15%" />
        <col width="35%" />
        <col width="15%" />
        <col width="35%" />
    </colgroup>
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        제출 마감일자
      </td>
      <td width="35%" class="data_td">
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/> 
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 제출여부</td>
      <td width="35%" class="data_td">
        <select name="bid_flag" id="bid_flag" class="inputsubmit">
          	<option value="">전체</option>
			<%
			String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M972", "");
			out.println(com1);
			%>
        </select>
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        공고번호
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_no" id="ann_no" size="20" maxlength="20" class="inputsubmit">
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        입찰건명
      </td>
      <td width="35%" class="data_td">
        <input type="text" name="ann_item" id="ann_item" size="20"  class="inputsubmit">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
    <tr>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        현재시간
      </td>
      <td width="35%" class="data_td">
        			<div id="id1"></div>
			        <input type="hidden" name="h_server_date" class="input_empty" size="50" readonly> 
      </td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        진행상태
      </td>
      <td width="35%" class="data_td">
        <select name="being_flag" id="being_flag" class="inputsubmit">
          <option value="Y">예정 및 신청중</option>
          <option value="N">신청마감</option>
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

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
        <div align="right">
        <table><tr>
          <td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
          <td><script language="javascript">btn("javascript:doAcceptBid()", "1단계입찰서제출")</script></td>
		  </tr></table>  
		</div>
      </td>
    </tr>
  </table>
  
</form>

<!---- END OF USER SOURCE CODE ----> 
</s:header>
<s:grid screen_id="SBD_002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


