<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
    String  to_date     = SepoaString.getDateSlashFormat( to_day );

    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 	= info.getSession("NAME_LOC");
%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rat_bd_lis1.jsp -->
<!--
Title:         역경매등록현황  <p>
 Description:  역경매등록현황<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->


<script language="javascript">
<!--
    var mode;
    var server_time;
    var diff_time;

    var INDEX_SELECTED      ;
    var INDEX_ANN_NO        ;
    var INDEX_ANN_ITEM      ;
    var INDEX_BID_BEGIN_DATE;
    var INDEX_BID_END_DATE  ;
    var INDEX_CHANGE_USER_NAME_LOC         ;
    var INDEX_STATUS_TEXT   ;
    var INDEX_SIGN_PERSON_ID        ;
    var INDEX_SIGN_STATUS        ;
    var INDEX_BID_STATUS        ;
    var INDEX_BID_NO        ;
    var INDEX_BID_COUNT        ;
    var INDEX_VOTE_COUNT;
    var INDEX_CHANGE_USER_ID;
    var INDEX_STATUS;
    var INDEX_PR_NO;
    var INDEX_CONT_TYPE2;
    var INDEX_BID_END_DATE_VALUE;
    var INDEX_CTRL_CODE;

    function setHeader() {



        GridObj.strHDClickAction="sortmulti";


        INDEX_SELECTED              =    GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO                =    GridObj.GetColHDIndex("ANN_NO");
        INDEX_ANN_ITEM              =    GridObj.GetColHDIndex("ANN_ITEM");
        INDEX_BID_BEGIN_DATE        =    GridObj.GetColHDIndex("BID_BEGIN_DATE");
        INDEX_BID_END_DATE          =    GridObj.GetColHDIndex("BID_END_DATE");
        INDEX_CHANGE_USER_NAME_LOC  =    GridObj.GetColHDIndex("CHANGE_USER_NAME_LOC");
        INDEX_STATUS_TEXT           =    GridObj.GetColHDIndex("STATUS_TEXT");
        INDEX_SIGN_PERSON_ID        =    GridObj.GetColHDIndex("SIGN_PERSON_ID");
        INDEX_SIGN_STATUS           =    GridObj.GetColHDIndex("SIGN_STATUS");
        INDEX_BID_STATUS            =    GridObj.GetColHDIndex("BID_STATUS");
        INDEX_BID_NO                =    GridObj.GetColHDIndex("BID_NO");
        INDEX_BID_COUNT             =    GridObj.GetColHDIndex("BID_COUNT");
        INDEX_VOTE_COUNT            =    GridObj.GetColHDIndex("VOTE_COUNT");
        INDEX_CHANGE_USER_ID        =    GridObj.GetColHDIndex("CHANGE_USER_ID");
        INDEX_STATUS                =    GridObj.GetColHDIndex("STATUS");
        INDEX_PR_NO                 =    GridObj.GetColHDIndex("PR_NO");
        INDEX_CONT_TYPE2            =    GridObj.GetColHDIndex("CONT_TYPE2");
        INDEX_BID_END_DATE_VALUE    =    GridObj.GetColHDIndex("BID_END_DATE_VALUE");
        INDEX_CTRL_CODE             =    GridObj.GetColHDIndex("CTRL_CODE");

    }

    //조회버튼을 클릭
    function doSelect() {
        var from_date		= LRTrim(del_Slash( form1.start_change_date.value ));
        var to_date	    	= LRTrim(del_Slash( form1.end_change_date.value ));
        var bid_flag		= form1.bid_flag.value;
        var ann_no	    	= LRTrim(form1.ann_no.value).toUpperCase();
        var ann_item    	= LRTrim(form1.ann_item.value);
        var CHANGE_USER_ID	= LRTrim(form1.CHANGE_USER.value);


        if(from_date == "" || to_date == "" ) {
            alert("제출마감일자를 입력하셔야 합니다.");
            return;
        }

        if(!checkDate(from_date)) {
            alert("제출마감일자를 확인하세요.");
            form1.start_change_date.select();
            return;
        }

        if(!checkDate(to_date)) {
            alert("제출마감일자를 확인하세요.");
            form1.end_change_date.select();
            return;
        }
		
		if(eval(document.forms[0].end_change_date.value) < eval(document.forms[0].start_change_date.value))
		{
			alert("제출마감일자를 확인하세요.");
			return;
		}
		
        //service : p1012
        var mode   = "getProgressList";
        servletUrl = "/servlets/dt.bidd.ebd_bd_lis1";

        GridObj.SetParam("mode", mode);

        GridObj.SetParam("ctrl_code",		"");        // 모든 사용자 조회
        GridObj.SetParam("from_date",		from_date);
        GridObj.SetParam("to_date",	    to_date);
        GridObj.SetParam("ann_no",	    ann_no);
        GridObj.SetParam("ann_item",	    ann_item);
        GridObj.SetParam("bid_flag",	    bid_flag);
        GridObj.SetParam("CHANGE_USER_ID",CHANGE_USER_ID);

        GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
    }


    function chkData(row_idx) {

        var status          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);
        var bid_end_date    = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_END_DATE_VALUE),row_idx);
        var cont_type2      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CONT_TYPE2),row_idx);
        var h_server_date   = document.forms[0].h_server_date.value;

        if(parseFloat(h_server_date) > parseFloat(bid_end_date)) {
            if(cont_type2 == "LP") {
                return true;
            } else if(cont_type2 == "TE") {
                if(status == "SC") {
                    return true;
                } else {
                    alert("1단계 평가를 먼저 하셔야 합니다.");
                    return false;
                }
            }
        } else {
            alert("입찰서 제출 마감후에 입찰진행을 하실 수 있습니다.");
            return false;
        }

        alert("입찰을 진행하실 수 없습니다.");
        return false;
    }

    //입찰진행
    function doBidProgress() {
		/*
    	bdpg.bid_end_date    이후 날짜 이면서,
        cont_type2 = 'LP' (최저가) 이면,
        ==> 입찰진행 가능
        
        cont_type2 != 'LP' (2단계, 종합낙찰제) 이면,
        bid_status = 'SC' 이면,
		==> 입찰진행 가능
		*/
        var row_idx = checkedRow();
        if (row_idx == -1) return;

        //if (checkUserId(row_idx) == false) return;
        if (checkUser() == false) return;
        if (chkData(row_idx) == false) return;

        var status          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);
        var bid_end_date    = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_END_DATE_VALUE),row_idx);
        var cont_type2      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CONT_TYPE2),row_idx);
        var h_server_date   = document.forms[0].h_server_date.value;

		var BID_NO      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_NO),row_idx);
		var BID_COUNT   = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_COUNT),row_idx);
		var PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),row_idx);
		var VOTE_COUNT  = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VOTE_COUNT),row_idx);

		var Message = "입찰을 진행 하시겠습니까?";
		if(confirm(Message) == 1){
            location.href = "/kr/dt/bidd/ebd_bd_dis4.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&PR_NO="+PR_NO+"&VOTE_COUNT="+VOTE_COUNT;
		}
	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    server_time = GD_GetParam(GridObj,0);

       	    clock("s");
	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click

            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),msg2);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_PR_NO) {
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+PR_NO,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
            }
        }
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }

    function clock(flag) {
        if (flag == "s") { // Server Call
            var currentDate = new Date();
            var client_time = currentDate.getTime();

            diff_time   = client_time - server_time;
        }

        curDate = new Date(Date.parse(Date())- diff_time);
        yyyy    = curDate.getYear();
        mm      = curDate.getMonth()+1;
        dd      = curDate.getDate();
        hh      = curDate.getHours();
        mi      = curDate.getMinutes();
        ss      = curDate.getSeconds();

        if (mm < 10) mm = "0" + mm;
        if (dd < 10) dd = "0" + dd;
        if (hh < 10) hh = "0" + hh;
        if (mi < 10) mi = "0" + mi;
        if (ss < 10) ss = "0" + ss;

        switch(curDate.getDay()) {
            case 0: day = "일"; break;
            case 1: day = "월"; break;
            case 2: day = "화"; break;
            case 3: day = "수"; break;
            case 4: day = "목"; break;
            case 5: day = "금"; break;
            case 6: day = "토"; break;
        }

        document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일(" + day + ") " + hh + "시" + mi + "분" + ss + "초";
        document.form1.h_server_date.value = "" + yyyy + mm + dd + hh + mi + ss;
        setTimeout('clock("c")', 1000);
    }

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }

    function SP0023_Popup() {
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0023&function=SP0023_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=/&desc=담당자ID&desc=담당자명";
		CodeSearchCommon(url,'doc','0','0','570','530');
	}
	
	function SP0023_getCode(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
   		document.form1.CHANGE_USER.value = USER_ID;
   		document.form1.CHANGE_USER_NAME.value = USER_NAME_LOC;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_price_list";

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
function checkedRow() {
    var checked_count = 0;
    var checked_row   = -1;
    var rowcount = GridObj.GetRowCount();

    for (var row = 0; row < rowcount; row++) {
    	if(GridObj.GetCellValue("SELECTED", i) == "1"){
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

function checkUserId(row_idx) {
    var user_id        = "<%=user_id%>";
    var change_user_id = GridObj.GetCellValue("CHANGE_USER_ID", row_idx);

    if (user_id != change_user_id) {
	        alert("구매담당자만 작업 가능합니다.");
	        return false;
    }

		return true;
	}

// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

		for(var row=0; row<GridObj.GetRowCount(); row++) {
	    	if(GridObj.GetCellValue("SELECTED", i) == "1"){
				for( i=0; i<ctrl_code.length; i++ )
			{
					if(ctrl_code[i] == GridObj.GetCellValue("CTRL_CODE", row)) {
						flag = true;
						break;
					} else
						flag = false;
				}
			}
		}
	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");

		return flag;
	}

//★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

 var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

 if( grid_array.length > 0 ) {
     return true;
 }

 alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
 return false;

}
//규격평가
function doSpecEstimate() {
 
	var own_ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	
    if(!checkRows()) return;
  
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
 
	
	for(var i = 0; i < grid_array.length; i++)
	{ 
		var BID_NO      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue());
		var BID_COUNT   = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		var PR_NO       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue());
	    var ctrl_code = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CTRL_CODE")).getValue());
	    var status = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue());
	    var cont_type2 = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2")).getValue());
	    var user_chk = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_NAME_LOC")).getValue());
	    for( i=0; i<ctrl_code.length; i++ )
		{
				if(ctrl_code[i] == ctrl_code) {
					flag = true;
					break;
				} else
					flag = false;
		}
	 
		if (!flag) 	alert("작업을 수행할 권한이 없습니다.");
	 
	    // 1단계 평가는 계약방법이 2단계 경쟁(TE)인 경우에만 적용한다.
	    if(cont_type2 != "TE" && cont_type2 != "NE") {
	     	alert("해당건은 1단계 평가건이 아닙니다.");
	     	return;
	    }
		
	    // 공고중(AC), 정정공고중(UC) 인 입찰건에 대해 현재 공고중(APP_BEGIN_DATE, APP_END_DATE)인 건만 1단계 평가 진행
	    // P : 입찰중, RC : 공고중, SC : 입찰대기, SR : 1단계평가
	    if (status != "SR") {
	       	alert("해당건은 1단계 평가건이 아닙니다.");
	       	return;
	    }

	} 

	document.form1.BID_NO.value = BID_NO;
	document.form1.BID_COUNT.value = BID_COUNT;
	document.form1.VOTE_COUNT.value = VOTE_COUNT;
	var Message = "1단계 평가결과를 등록하시겠습니까?";
	if(confirm(Message) == 1){
    	url =  "bd_price_popup.jsp";
	    window.open( url , "ebd_bd_ins6","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=900,height=500,left=20,top=50");
	    document.form1.method = "POST";
		document.form1.action = url;
		document.form1.target = "doBidding";
		document.form1.submit(); 
	}
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->

<form name="form1" >
<input type="hidden" name="ctrl_code" value="">
	<input type="hidden" name="BID_NO" id="BID_NO">
	<input type="hidden" name="BID_COUNT" id="BID_COUNT">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT">
<%@ include file="/include/sepoa_milestone.jsp" %>
 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="5"> </td>
    </tr>
    <tr>
        <td width="100%" valign="top"><table width="100%" height="3" border="0" cellspacing="0" cellpadding="0" bgcolor="#629DD9"><tr><td></td></tr></table>
            <table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>   
    <tr>
      <td width="15%" class="tit">
        <div align="left">제출마감일자</div>
      </td>
      <td width="35%">
      		<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        							id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
          
      </td>
      <td width="15%" class="tit">진행상황</td>
      <td width="35%">
        <select name="bid_flag" id="bid_flag" class="inputsubmit">
          <option value="">전체</option>
<%
		String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M978", "");
		out.println(com1);
%>
        </select>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">
        <div align="left">공고번호</div>
      </td>
      <td>
        <input type="text" name="ann_no" id="ann_no" size="20" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
      <td width="15%" class="tit">
        <div align="left">입찰건명</div>
      </td>
      <td>
        <input type="text" style="ime-mode:active" name="ann_item" id="ann_item" style="width:95%" class="inputsubmit" onkeydown='entKeyDown()'>
      </td>
    </tr>
    <tr>
      <td width="15%" class="tit">
        <div align="left">현재시간</div>
      </td>
      <td width="35%">
        <input type="text" name="server_date" class="input_data1" size="50" readonly>
        <input type="hidden" name="h_server_date" class="input_data1" size="50" readonly>
      </td>
      <td width="15%" class="tit">입찰담당자</td>
      <td  width="35%">
        <input type="text" name="CHANGE_USER" size="20" maxlength="10" class="inputsubmit" value="<%=info.getSession("ID")%>"  onkeydown='entKeyDown()'>
		<a href="javascript:SP0023_Popup()"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/query.gif" align="absmiddle" border="0" alt=""></a>
		<input type="text" name="CHANGE_USER_NAME" size="20" class="input_data2" readonly value='<%=info.getSession("NAME_LOC")%>'>
      </td>
    </tr>
  </table>
  
 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
		      		<td height="30" align="right">
						<TABLE cellpadding="0">
				      		<TR>
			    	  			<TD> <script language="javascript">btn("javascript:doQuery()", "조 회")</script></TD>
							<TD><script language="javascript">btn("javascript:doSpecEstimate()", "평가결과등록")</script></td>
			    	  		</TR>
		      			</TABLE>
		      		</td>
		    	</tr>
		  	</table>
 
  </form>

<!---- END OF USER SOURCE CODE ----> 

</s:header>
<s:grid screen_id="BD_008" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
 