<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "";

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/rfq/rat_bd_lis1.jsp -->
<!--
Title:         역경매참가신청등록  <p>
 Description:  역경매참가신청등록<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_002";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 		= info.getSession("NAME_LOC");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

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
    var INDEX_RA_TYPE1        ;
    //var INDEX_BID_STATUS        ;
    //var INDEX_BID_NO        ;
    //var INDEX_BID_COUNT        ;
    var INDEX_VOTE_COUNT;
    var INDEX_CHANGE_USER_ID;
    var INDEX_STATUS;
    var INDEX_PR_NO;
    //var INDEX_CONT_TYPE2;
    var INDEX_BID_END_DATE_VALUE;
    var INDEX_CTRL_CODE;
    
    var INDEX_OPEN_REQ_FROM_DATE;
    var INDEX_OPEN_REQ_TO_DATE;

    function init() {
//     	$.post(
<%--    			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1", --%>
//    	 		{ mode : "getServerTime"},
//    	 		function(arg){
   	 			
//    	 			var yy = eval(arg.substring(0, 4));
//    	 			var mm = eval(arg.substring(4, 6));
//    	 			var dd = eval(arg.substring(6, 8));
//    	 			var hh = eval(arg.substring(8, 10));
//    	 			var mi = eval(arg.substring(10, 12));
//    	 			var ss = eval(arg.substring(12, 14));
   	 			
//    	 			var tmp = new Date(yy, mm, dd, hh, mi, ss);
//    	 			server_time = tmp.getTime();
//    	 		}
//    	 	);	    	    	
    	
		setGridDraw();
		setHeader();
        doSelect();
        printDate();
    }

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
        INDEX_RA_TYPE1              =	 GridObj.GetColHDIndex("RA_TYPE1");
        INDEX_VOTE_COUNT            =    GridObj.GetColHDIndex("VOTE_COUNT");
        INDEX_CHANGE_USER_ID        =    GridObj.GetColHDIndex("CHANGE_USER_ID");
        INDEX_STATUS                =    GridObj.GetColHDIndex("STATUS");
        INDEX_PR_NO                 =    GridObj.GetColHDIndex("PR_NO");
        INDEX_BID_END_DATE_VALUE    =    GridObj.GetColHDIndex("BID_END_DATE_VALUE");
        INDEX_CTRL_CODE             =    GridObj.GetColHDIndex("CTRL_CODE");
        
        INDEX_OPEN_REQ_FROM_DATE    =    GridObj.GetColHDIndex("OPEN_REQ_FROM_DATE");
        INDEX_OPEN_REQ_TO_DATE      =    GridObj.GetColHDIndex("OPEN_REQ_TO_DATE");

    }

    //조회버튼을 클릭
    function doSelect() {
        var from_date			= LRTrim(del_Slash(form1.start_change_date.value));
        var to_date	    		= LRTrim(del_Slash(form1.end_change_date.value));
        var bid_flag			= form1.bid_flag.value;
        var ann_no	    		= LRTrim(form1.ann_no.value).toUpperCase();
        var ann_item    		= LRTrim(form1.ann_item.value);
        var CHANGE_USER_NAME	= LRTrim(form1.CHANGE_USER_NAME.value);


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
		
		if(eval(to_date) < eval(from_date))
		{
			alert("제출마감일자를 확인하세요.");
			return;
		}
		
        /*
         service : p1008.java
           query : p1008.xml
        */
        
        var mode   = "getratbdRegList";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis3";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);        
    }

    //참가자 등록
    function doReverseRegReq() {
        var row_idx = checkedRow();

        if (row_idx == -1) return;

        if (checkUserId(row_idx) == false) return;
	
		document.form2.ra_no.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_NO),row_idx);
		document.form2.ann_item.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_ITEM),row_idx);
		document.form2.ra_type1.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_TYPE1),row_idx);
		document.form2.ra_count.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VOTE_COUNT),row_idx);
		document.form2.change_user_name_loc.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CHANGE_USER_NAME_LOC),row_idx);
		document.form2.change_user_id.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CHANGE_USER_ID),row_idx);
		document.form2.OPEN_REQ_FROM_DATE.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_OPEN_REQ_FROM_DATE),row_idx);
		document.form2.OPEN_REQ_TO_DATE.value = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_OPEN_REQ_TO_DATE),row_idx);
		
		var Message = "결과등록을 하시겠습니까?";
		if(confirm(Message) == 1){
			url =  "/kr/dt/rat/rat_bd_ins3.jsp";
    	   	window.open( "", "doReverseRegReq","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=700,height=500,left=0,top=0");
    	   	document.form2.method = "POST";
		   	document.form2.action = url;
		   	document.form2.target = "doReverseRegReq";
		   	document.form2.submit();
		}
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
                    alert("1단계평가를 먼저 하셔야 합니다.");
                    return false;
                }
            }
        } else {
            alert("입찰서제출마감후, 입찰진행을 하실 수 있습니다.");
            return false;
        }

        alert("입찰진행을 하실 수 없습니다.");
        return false;
    }

    //입찰진행
    function doBidProgress() {
/*
    bdpg.bid_end_date    이후 날짜 이면서,
        cont_type2 = 'LP' (최저가) 이면,
                입찰진행 가능
        cont_type2 != 'LP' (2단계, 종합낙찰제) 이면,
                bid_status = 'SC' 이면,
                    입찰진행 가능
*/
        var row_idx = checkedRow();

        if (row_idx == -1) return;

        if (checkUserId(row_idx) == false) return;
        if (chkData(row_idx) == false) return;

        var status          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);
        var bid_end_date    = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_END_DATE_VALUE),row_idx);
        //var cont_type2      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CONT_TYPE2),row_idx);
        var h_server_date   = document.forms[0].h_server_date.value;

		//var BID_NO      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_NO),row_idx);
		//var BID_COUNT   = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_COUNT),row_idx);
		var PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),row_idx);
		var VOTE_COUNT  = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VOTE_COUNT),row_idx);

		var Message = "입찰진행 하시겠습니까?";

		if(confirm(Message) == 1){
            //location.href = "/kr/dt/bidd/ebd_bd_dis4.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&PR_NO="+PR_NO+"&VOTE_COUNT="+VOTE_COUNT;
		}
	}

    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if ("1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
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
	    var change_user_id = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CHANGE_USER_ID);

        if (user_id != change_user_id) {
   	        alert("구매담당자만 작업 가능합니다.");
   	        return false;
        }

 		return true;
  	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
//        	    clock("s");
	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click
			
			var ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_ANN_NO),msg2);
    		var ra_count	= GD_GetCellValueIndex(GridObj,msg2,INDEX_VOTE_COUNT);
			
			if(msg3 == INDEX_ANN_NO) {
				window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
			}
            /*
            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),msg2);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);

            var front_status = BID_STATUS.substring(0, 1);
			
            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
                    //window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_PR_NO) {
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+PR_NO,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
            }
            */
        }else if(msg1 == "t_insert") {
            if(msg3 == INDEX_SELECTED) {
                for(i=0; i<GridObj.GetRowCount(); i++) {
                    if("true" == GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED)) {
                        if(i != msg2) {
                            GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "false&", "&");
                        }
                    }
                }
            }
        }  
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }

//     var tmpSec = 1000;
// 	function clock(flag) {
		
// 		if("undefined" != typeof server_time) {
// 			curDate = new Date(server_time + tmpSec);
// 			yyyy    = curDate.getYear();
// 			mm      = curDate.getMonth()+1;
// 			dd      = curDate.getDate();
// 			hh      = curDate.getHours();
// 			mi      = curDate.getMinutes();
// 			ss      = curDate.getSeconds();
	
// 	        if (mm < 10) mm = "0" + mm;
// 	        if (dd < 10) dd = "0" + dd;
// 	        if (hh < 10) hh = "0" + hh;
// 	        if (mi < 10) mi = "0" + mi;
// 	        if (ss < 10) ss = "0" + ss;
	
// 	        var day = "";
	        
// 			switch(curDate.getDay()) {
// 				case 0: day = "일"; break;
// 				case 1: day = "월"; break;
// 				case 2: day = "화"; break;
// 				case 3: day = "수"; break;
// 				case 4: day = "목"; break;
// 				case 5: day = "금"; break;
// 				case 6: day = "토"; break;
// 			}
// 			document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일(" + day + ") " + hh + "시" + mi + "분" + ss + "초";
// 		}
// 		tmpSec = tmpSec + 1000;
//  		setTimeout('clock("c")', 1000);
// 	}

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }

//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
   	GridObj.setSizes();
}
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "ANN_NO" ){
		var RA_FLAG 	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_FLAG")).getValue());
		var ra_no		= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());
// 		var ra_count	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_COUNT")).getValue());
		var pr_no       = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PR_NO")).getValue());
		
		if(RA_FLAG != "D") { // 입찰공고, 정정공고
            window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
         } else {//취소공고
            window.open("/kr/dt/rat/rat_bd_ins2.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&SCR_FLAG=V","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
         }    	
    }
	
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
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<form id="form1" name="form1" >
	<input type="hidden" id="ctrl_code" name="ctrl_code" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 제출마감일자</td>
      		<td width="20%" height="24" class="data_td">
      			<s:calendar id="start_change_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
      			<s:calendar id="end_change_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1))%>" 									format="%Y/%m/%d"/>
      		</td>      
      
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행상황</td>
      		<td width="20%" height="24" class="data_td">
        		<select id="bid_flag" name="bid_flag" class="inputsubmit">
          			<option value="">전체</option>
					<!--
					<option value="RT">작성중</option>
			        <option value="RP">결재중</option>
			        <option value="RC	">결재완료</option>
			        <option value="RF">역경매종료</option>
			        -->
          			<option value="RC">결재완료</option>
          			<option value="CC">공고확정</option>
          			<option value="RA">공고중</option>
          			<option value="BP">역경매진행</option>
        		</select>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td width="20%" height="24" class="data_td">
        		<input type="text" id="ann_no" name="ann_no" style="ime-mode:inactive" size="20" maxlength="20" class="inputsubmit" onkeydown='entKeyDown()'>
      		</td>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명</td>
      		<td width="20%" height="24" class="data_td">
        		<input type="text" style="ime-mode:active" id="ann_item" name="ann_item" size="20"  class="inputsubmit" onkeydown='entKeyDown()'>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
      		<td width="20%" height="24" class="data_td" colspan="3">
      			<b>
        			<input type="text" id="CHANGE_USER_NAME" name="CHANGE_USER_NAME"  value="<%=USER_NAME%>" size="10" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()'>
        		</b>
        	</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  	    	
    	<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 현재시간</td>
      		<td class="data_td" colspan="3">
				<div id="id1"></div>
			    <input type="hidden" id="h_server_date" name="h_server_date" class="input_empty" size="50" readonly>      		
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
					<table>
						<tr>
							<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
							<td><script language="javascript">btn("javascript:doReverseRegReq()","결과등록")</script></td>
						</tr>
					</table>
				</div>
      		</td>
    	</tr>
  	</table>
</form>
<form id="form2" name="form2">
	<input type="hidden" id="ra_no" 			 	name="ra_no" 					value="">
	<input type="hidden" id="ra_count" 			 	name="ra_count" 				value="">
	<input type="hidden" id="ra_type1" 			 	name="ra_type1" 				value="">
	<input type="hidden" id="ann_item" 			 	name="ann_item" 				value="">
	<input type="hidden" id="change_user_name_loc" 	name="change_user_name_loc" 	value="">
	<input type="hidden" id="change_user_id" 		name="change_user_id" 			value="">
	<input type="hidden" id="OPEN_REQ_FROM_DATE" 	name="OPEN_REQ_FROM_DATE" 		value="">
	<input type="hidden" id="OPEN_REQ_TO_DATE" 	 	name="OPEN_REQ_TO_DATE" 		value="">
</form>
<!---- END OF USER SOURCE CODE ---->
<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="AU_002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


