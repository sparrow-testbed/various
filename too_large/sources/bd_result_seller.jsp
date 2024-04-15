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

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/s_kr/bidding/bidd/ebd_bd_lis2.jsp -->
<!--
Title:         입찰결과  <p>
 Description:  입찰결과<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->
<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="SBD_005";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%@ include file="/include/wisehub_common.jsp"%>
<%@ include file="/include/wisehub_session.jsp" %>
<%@ include file="/include/wisehub_auth.jsp" %>
<%@ include file="/include/code_common.jsp" %>
<%@ include file="/include/wisetable_scripts.jsp"%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%@ include file="/include/wisehub_scripts.jsp"%>

<script language="javascript">
<!--
    var mode;

    var INDEX_SELECTED       ;
    var INDEX_ANN_NO         ;
    var INDEX_ANN_ITEM       ;
    var INDEX_BID_BEGIN_DATE ;
    var INDEX_BID_END_DATE   ;
    var INDEX_STATUS_TEXT    ;
    var INDEX_SETTLE_FLAG    ;
    var INDEX_CUR            ;
    var INDEX_SETTLE_AMT     ;
    var INDEX_BID_NO         ;
    var INDEX_BID_COUNT      ;
    var INDEX_VOTE_COUNT     ;
    var INDEX_STATUS         ;
    var INDEX_REMARK         ;

    function init() {
setGridDraw();
setHeader();
        doSelect();
    }

    function setHeader() {


        GridObj.strHDClickAction="sortmulti";
        
        

		GridObj.SetNumberFormat("SETTLE_AMT",G_format_amt);
		
		

        INDEX_SELECTED                   = GridObj.GetColHDIndex("SELECTED");

        INDEX_ANN_NO                     = GridObj.GetColHDIndex("ANN_NO");
        INDEX_ANN_ITEM                   = GridObj.GetColHDIndex("ANN_ITEM");
        INDEX_BID_BEGIN_DATE             = GridObj.GetColHDIndex("BID_BEGIN_DATE");
        INDEX_BID_END_DATE               = GridObj.GetColHDIndex("BID_END_DATE");
        INDEX_STATUS_TEXT                = GridObj.GetColHDIndex("STATUS_TEXT");

        INDEX_SETTLE_FLAG                = GridObj.GetColHDIndex("SETTLE_FLAG");
        INDEX_CUR                        = GridObj.GetColHDIndex("CUR");
        INDEX_SETTLE_AMT                 = GridObj.GetColHDIndex("SETTLE_AMT");
        INDEX_BID_NO                     = GridObj.GetColHDIndex("BID_NO");
        INDEX_BID_COUNT                  = GridObj.GetColHDIndex("BID_COUNT");

        INDEX_VOTE_COUNT                 = GridObj.GetColHDIndex("VOTE_COUNT");
        INDEX_STATUS                     = GridObj.GetColHDIndex("STATUS");

        INDEX_REMARK                     = GridObj.GetColHDIndex("REMARK");

    }

    //조회버튼을 클릭
    function doSelect() {
        var from_date	= LRTrim(form1.start_change_date.value);
        var to_date	    = LRTrim(form1.end_change_date.value);
        var bid_flag	= form1.bid_flag.value;
        var ann_no	    = LRTrim(form1.ann_no.value).toUpperCase();
        var ann_item    = LRTrim(form1.ann_item.value);
        var settle_vendor= LRTrim(form1.settle_vendor.value);

        if(from_date == "" || to_date == "" ) {
            alert("입찰일자를 입력하셔야 합니다.");
            return;
        }

        if(!checkDate(from_date)) {
            alert("입찰일자를 확인하세요.");
            form1.start_change_date.select();
            return;
        }

        if(!checkDate(to_date)) {
            alert("입찰일자를 확인하세요.");
            form1.end_change_date.select();
            return;
        }

        //service : s1009
        var mode   = "getResultList";
        servletUrl = "/servlets/supply.bidding.bidd.ebd_bd_lis2";

        GridObj.SetParam("mode", mode);

        GridObj.SetParam("ctrl_code",	"");        // 모든 사용자 조회
        GridObj.SetParam("from_date",	from_date);
        GridObj.SetParam("to_date",	    to_date);
        GridObj.SetParam("ann_no",	    ann_no);
        GridObj.SetParam("ann_item",	    ann_item);
        GridObj.SetParam("bid_flag",	    bid_flag);
        GridObj.SetParam("settle_vendor",	    settle_vendor);

        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
    }


    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if ("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
   			    checked_row   = row;
        		checked_count++;
        	}
	    }

        if(checked_count == 0)  {
	    	alert("선택된 로우가 없습니다.");
	    	return -1;
	    }

        if(checked_count > 1)  {
	    	alert("하나의 로우만 선택할 수 있습니다.");
	    	return -1;
	    }

        return checked_row;
  	}


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

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
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
<body onload="javascript:init();;GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<form name="form1" >
<input type="hidden" name="ctrl_code" value="">

    <tr>
      <td width="15%" class="c_title_1">
        <div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 가격입찰일자</div>
      </td>
      <td width="35%" class="c_data_1">
        <input type="text" name="start_change_date" size="10" maxlength="8" class="input_re" value="<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1)%>">
<!--         <a href="javascript:Calendar_Open('start_change_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
        ~
        <input type="text" name="end_change_date" size="10" maxlength="8" class="input_re" value="<%=SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),+1)%>">
<!--         <a href="javascript:Calendar_Open('end_change_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> -->
      </td>
      <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 낙찰여부</td>
      <td width="35%" class="c_data_1">
        <select name="bid_flag" class="inputsubmit">
          <option value="">전체</option>
          <option value="SB">낙찰</option>
          <option value="NB">유찰</option>
        </select>
      </td>
    </tr>
    <tr>
      <td width="15%" class="c_title_1">
        <div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공고번호</div>
      </td>
      <td width="35%" class="c_data_1">
        <input type="text" name="ann_no" size="20" maxlength="20" class="inputsubmit">
      </td>
      <td width="15%" class="c_title_1">
        <div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 입찰건명</div>
      </td>
      <td width="35%" class="c_data_1">
        <input type="text" name="ann_item" size="50"  class="inputsubmit">
      </td>
    <tr style="display:none;">
      <td width="15%" class="c_title_1">
        <div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 낙찰업체</div>
      </td>
      <td width="35%" class="c_data_1" colspan="3">
        <input type="text" name="settle_vendor" class="inputsubmit" size="20">
      </td>
    </tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
        <div align="right">        
        <table><tr>
          <td><script language="javascript">btn("javascript:doSelect()",2,"조 회")</script></td>
		  </tr></table>  
        </div>
      </td>
    </tr>
  </table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","300")%>
	</td>
</tr>
</table>

</form>

<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="SBD_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


