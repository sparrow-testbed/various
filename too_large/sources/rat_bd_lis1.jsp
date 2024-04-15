<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG = "";

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

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_003";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 	= info.getSession("NAME_LOC");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
<!--
    var mode;

    var server_time;
    var diff_time;

    var INDEX_SELECTED;
    var INDEX_ANN_NO;
    var INDEX_STATUS_TEXT;
    var INDEX_SUBJECT;
    var INDEX_ATTACH_NO;
    var INDEX_END_DATETIME;
    var INDEX_BID_COUNT;
    var INDEX_CURRENT_PRICE;
    var INDEX_RESERVE_PRICE;
    var INDEX_PR_NO;
    var INDEX_RA_NO;
    var INDEX_RA_COUNT;
    var INDEX_CTRL_CODE;
    var INDEX_STATUS;
    var INDEX_CHANGE_USER_ID;
	var INDEX_RA_FLAG;
	var INDEX_EVAL_FLAG;
	var INDEX_EVAL_FLAG_DESC;
	var INDEX_EVAL_REFITEM;

    function init() {
// 		$.post(
<%-- 			"<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1", --%>
// 	 		{ mode : "getServerTime"},
// 	 		function(arg){
	 			
// 	 			var yy = eval(arg.substring(0, 4));
// 	 			var mm = eval(arg.substring(4, 6));
// 	 			var dd = eval(arg.substring(6, 8));
// 	 			var hh = eval(arg.substring(8, 10));
// 	 			var mi = eval(arg.substring(10, 12));
// 	 			var ss = eval(arg.substring(12, 14));
	 			
// 	 			var tmp = new Date(yy, mm, dd, hh, mi, ss);
// 	 			server_time = tmp.getTime();
// 	 		}
// 	 	);	    	
    	
		setGridDraw();
		setHeader();
        doSelect();
        printDate(); 
    }

    function setHeader() {

    	GridObj.strHDClickAction="sortmulti";

        INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO            = GridObj.GetColHDIndex("ANN_NO");
        INDEX_STATUS_TEXT       = GridObj.GetColHDIndex("STATUS_TEXT");
        INDEX_SUBJECT           = GridObj.GetColHDIndex("SUBJECT");
        INDEX_ATTACH_NO         = GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_END_DATETIME      = GridObj.GetColHDIndex("END_DATETIME");
        INDEX_BID_COUNT         = GridObj.GetColHDIndex("BID_COUNT");
        INDEX_CURRENT_PRICE     = GridObj.GetColHDIndex("CURRENT_PRICE");
        INDEX_RESERVE_PRICE     = GridObj.GetColHDIndex("RESERVE_PRICE");
        INDEX_PR_NO             = GridObj.GetColHDIndex("PR_NO");
        INDEX_RA_NO             = GridObj.GetColHDIndex("RA_NO");
        INDEX_RA_COUNT          = GridObj.GetColHDIndex("RA_COUNT");
        INDEX_CTRL_CODE         = GridObj.GetColHDIndex("CTRL_CODE");
        INDEX_STATUS            = GridObj.GetColHDIndex("STATUS");
        INDEX_CHANGE_USER_ID    = GridObj.GetColHDIndex("CHANGE_USER_ID");
		INDEX_RA_FLAG			= GridObj.GetColHDIndex("RA_FLAG");
		
		INDEX_EVAL_FLAG_DESC   	=    GridObj.GetColHDIndex("EVAL_FLAG_DESC");
		INDEX_EVAL_FLAG        	=    GridObj.GetColHDIndex("EVAL_FLAG");
        INDEX_EVAL_REFITEM      =    GridObj.GetColHDIndex("EVAL_REFITEM");
        
        INDEX_RA_TYPE1      	=    GridObj.GetColHDIndex("RA_TYPE1");
        INDEX_CHANGE_USER_NAME  =    GridObj.GetColHDIndex("CHANGE_USER_NAME");
		
    }

    //조회버튼을 클릭
    function doSelect() {
    	var from_date	= LRTrim(del_Slash(form1.from_date.value));
    	var to_date	    = LRTrim(del_Slash(form1.to_date.value));
    	var bid_flag	= form1.bid_flag.value;
    	var ann_no	    = LRTrim(form1.ann_no.value).toUpperCase();
		var CHANGE_USER_NAME	= LRTrim(form1.CHANGE_USER_NAME.value);

    	if(from_date == "" || to_date == "" ) {
    		alert("생성일자를 입력하셔야 합니다.");
    		return;
    	}
    	if(!checkDate(from_date)) {
    		alert("생성일자를 확인하세요.");
    		form1.from_date.select();
    		return;
    	}
    	if(!checkDate(to_date)) {
    		alert("생성일자를 확인하세요.");
    		form1.to_date.select();
    		return;
    	}

		if(eval(to_date) < eval(from_date))
		{
			alert("생성일자를 확인하세요.");
			return;
		}
		
        var mode   = "getratbdlis1_3";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }

    //수정
    function doModify() {
        var row_idx = checkedRow();

        if (row_idx == -1) return;

        //if (checkCtrlCode(row_idx) == false) return;
        if (checkUserId(row_idx) == false) return;

		var ra_status = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("STATUS")).getValue());

        if (ra_status != "RT") {
           	alert("진행상황이 작성중인 경우만 수정할 수 있습니다.");
           	return;
        }

		var ra_no    = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("RA_COUNT")).getValue());
		var pr_no    = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("PR_NO")).getValue());

		var Message = "수정하시겠습니까?";

		if(confirm(Message) == 1){
        	location.href = "/kr/dt/rfq/rat_bd_ins1.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&REQ_PR_NO="+pr_no;
		}
	}

    //삭제
    function doDelete() {
        var row_idx = checkedRow();

        if (row_idx == -1) return;

        //if (checkCtrlCode(row_idx) == false) return;
        if (checkUserId(row_idx) == false) return;

		var ra_status = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);

        if (ra_status != "RT") {
           	alert("진행상황이 작성중인 경우만 삭제할 수 있습니다.");
           	return;
        }

		Message = "삭제하시겠습니까?";

		if(confirm(Message) == 1){
			servletUrl = "/servlets/dt/rfq/rat_bd_lis1";
			GridObj.SetParam("mode", "setratbdlis1_1");
			GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
		}
    }

    //역경매진행
    function doProcess() {
        var row_idx = checkedRow();

        if (row_idx == -1) return;

        //if (checkCtrlCode(row_idx) == false) return;
        if (checkUserId(row_idx) == false) return;

        var ra_status 	= LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("STATUS")).getValue());
		var ra_flag 	= LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("RA_FLAG")).getValue());

        if (ra_status == "RT") {
           	alert("작성중인 역경매 입니다.");
           	return;
        }

		if (ra_flag == "D") {
           	alert("취소하신 공고 입니다.");
           	return;
        }

        if (ra_status != "RF") {
           	alert("진행상황이 역경매마감인 경우만 진행을 할 수 있습니다.");
           	return;
        }

		var ra_no    = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("RA_COUNT")).getValue());
		var pr_no    = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("PR_NO")).getValue());

		var eval_status     = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("EVAL_FLAG")).getValue());
		
		// 평가는 구매요청만 해당된다. 사전사전지원는 제외.
		var REQ_TYPE = GridObj.GetCellValue("REQ_TYPE", row_idx);
		if(REQ_TYPE == "P"){
			if(!(eval_status == "N" || eval_status == "C") ){
				alert("평가제외 또는 평가 완료된 건이 아니면 역경매마감 하실 수 없습니다.");
				return;
			}
		}
		
		Message = "역경매 개찰을 하시겠습니까?";

		if(confirm(Message) == 1){
        	location.href = "/kr/dt/rat/rat_bd_ins4.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&REQ_PR_NO="+pr_no;
		}
    }

    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if( "1" == LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("SELECTED")).getValue())) {
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

    function checkCtrlCode(row_idx) { //구매그룹 체크
	    var ctrl_code  = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CTRL_CODE);
	    var ctrl_codes = "<%=info.getSession("CTRL_CODE")%>".split("&");

	    for( i=0; i < ctrl_code.length; i++ )	{
  	        if (ctrl_code == ctrl_codes[i]) {
  	        	return true;
  	        }
        }

        alert("구매그룹이 동일한 경우만 작업 가능합니다.");
        return false;
  	}

    function checkUserId(row_idx) {
        var user_id        = "<%=user_id%>";
	    var change_user_id = LRTrim(GridObj.cells(GridObj.getRowId(row_idx), GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
        if (user_id != change_user_id) {
   	        alert("담당자만 작업 가능합니다.");
   	        return false;
        }

 		return true;
  	}
    
    function test(oj){
    	alert(oj.responseText);
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    //server_time = GD_GetParam(GridObj,0);
//             var currentDate = new Date();
//             var client_time = currentDate.getTime();
// 			server_time = client_time;

<%-- 			sendRequest(test,"mode=getServerTime",'POST','<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_lis1',false,false); --%>

//        	    clock("s");
	    } else if(msg1 == "doData") {
	    	alert(GD_GetParam(GridObj,1));
	    	doSelect();
	    	/* 2010.07.17
		    if("1" == GridObj.GetStatus()) {
			    alert( "역경매내역이 삭제되었습니다." );
			    doSelect();
		    }*/
	    } else if(msg1 == "t_imagetext") {
    		var ra_no		= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_NO")).getValue());
    		var ra_count	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_COUNT")).getValue());
    		var pr_no       = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("PR_NO")).getValue());
			var RA_FLAG     = LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_FLAG")).getValue());

		    if(msg3 == INDEX_ANN_NO){       //공고번호 click

				if(RA_FLAG != "D") { // 입찰공고, 정정공고
                   window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");

                } else {//취소공고
                   window.open("/s_kr/bidding/rat/rat_pp_dis3.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }



		    } else if(msg3 == INDEX_ATTACH_NO) { //첨부파일
				var attach_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);
                attach(attach_no);
			} else if(msg3 ==  INDEX_BID_COUNT){ // 참가업체수	
				var row_idx = msg2;

        		if (row_idx == -1) return;

				document.form1.ra_no.value 					= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_NO")).getValue());
				document.form1.ra_count.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_COUNT")).getValue());
				document.form1.ann_item.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("SUBJECT")).getValue());				
				document.form1.ra_type1.value 				= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("RA_TYPE1")).getValue());			
				document.form1.change_user_name_loc.value 	= LRTrim(GridObj.cells(msg2, GridObj.getColIndexById("CHANGE_USER_NAME")).getValue());		
				document.form1.editable.value 				= "N";
		
       			url =  "/kr/dt/rat/rat_bd_ins3.jsp";
  	   			window.open( "", "doReverseRegReq","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=700,height=500,left=0,top=0");
   	   			document.form1.method = "POST";
	   			document.form1.action = url;
	   			document.form1.target = "doReverseRegReq";
	   			document.form1.submit();
			
			}
						
		
		    /*} else if(msg3 == INDEX_PR_NO) { //청구번호
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+pr_no,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
		    }*/
	    }else if(msg1 == "t_insert") {
            if(msg3 == INDEX_SELECTED) {
                for(i=0; i<GridObj.GetRowCount(); i++) {
                    if("true" == GD_GetCellValueIndex(GridObj,i,INDEX_SELECTED)) {
                        if(i != msg2) {
                            GD_SetCellValueIndex(GridObj,i,INDEX_SELECTED, "false&", "&");
                        }
                    }
                }
            }
        }
    }

    function from_date(year,month,day,week) {
    	document.forms[0].from_date.value=year+month+day;
    }

    function to_date(year,month,day,week) {
    	document.forms[0].to_date.value=year+month+day;
    }
    var tmpSec = 1000;
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

    //첨부파일
    function attach(ATTACH_VALUE) {
		if("" != ATTACH_VALUE)
			FileAttach('RA',ATTACH_VALUE,'VI');
    }

	function doEval() {
        var checked_count = 0;
		var rowcount = GridObj.GetRowCount();
		var strStatus = "";
		var checkedIndex;
		
		for(row=rowcount-1; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			 	strStatus = GD_GetCellValueIndex(GridObj,row, INDEX_STATUS);
			 	vendor_count = GD_GetCellValueIndex(GridObj,row, INDEX_BID_COUNT);
				checked_count++;
				checkedIndex = row;
			}
		}

		if(checked_count == 0)  {
			alert("입찰내용을 선택하여주십시요!");
			return;
		}

		/*
		if(strStatus =="RF"){
			alert("역경매종료된 건은 평가를 생성할 수 없습니다!");
			return;
		}
		*/
		
		if(GridObj.GetCellValue("REQ_TYPE", checkedIndex) == "B"){
			alert("사전지원요청건은 평가등록을 하실 수 없습니다.");
			return;
		}
		
		if(vendor_count ==0){
			alert("참가업체수가 0인 건은 평가를 생성할 수 없습니다!");
			return;
		}
		
		var eval_id = form1.template_type.value;
		
		if(eval_id == "") {
			alert("평가대상을 등록하려면 평가를 선택해야  합니다.");
			return;
		}
		
		
		
		Message = "참여업체가 모두 입찰에 참여했을 경우 평가를 생성해 주시기 바랍니다. \n\n평가대상을 ["+document.form1.template_type.options[document.form1.template_type.options.selectedIndex].text+"] 으로 지정 하시겠습니까?";
		if(confirm(Message) == 1) {
			servletUrl = "/servlets/dt.rat.rat_bd_lis1";
			GridObj.SetParam("mode", "charge_eval");
			GridObj.SetParam("eval_id", eval_id);
			GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
			GridObj.SendData(servletUrl, "ALL", "ALL");
		}

	}//doEval End

//-->
</script>
<%-- Ajax SelectBox용 JSP--%>
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
--%> 

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall("t_imagetext", rowId, cellInd);
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
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
	
<form id="form1" name="form1" >
	<input type="hidden" id="ra_no"                	name="ra_no">
	<input type="hidden" id="ra_count"             	name="ra_count">
	<input type="hidden" id="ann_item"		        name="ann_item">		
	<input type="hidden" id="ra_type1"             	name="ra_type1">
	<input type="hidden" id="change_user_name_loc"	name="change_user_name_loc">
	<input type="hidden" id="editable"	            name="editable">
	<input type="hidden" id="ctrl_code"				name="ctrl_code" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
		<tr>
      		<td width="2%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성일자</td>
      		<td width="30%" height="24" class="data_td">
      			<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" 	format="%Y/%m/%d"/>~
      			<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1))%>" 									format="%Y/%m/%d"/>
      		</td>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행상황</td>
      		<td class="data_td">
        		<select id="bid_flag" name="bid_flag" class="inputsubmit">
          			<option value="">전체</option>
          			<option value="CC">공고확정</option>
          			<option value="RA">공고중</option>
          			<option value="BP">역경매진행</option>
          			<option value="RF">역경매종료</option>
		          	<!--  
					<option value="RT">작성중</option>
		          	<option value="RC">확정</option>
		          	<option value="RA">공고중</option>
		          	<option value="RP">역경매진행</option>
		          	<option value="RF">역경매종료</option>
		          	-->
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  			
		<tr>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td class="data_td">
        		<input type="text" id="ann_no" name="ann_no" size="20" maxlength="14" style="ime-mode:inactive" class="inputsubmit" onkeydown='entKeyDown()' >
      		</td>
      		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당자</td>
      		<td class="data_td">
         		<input type="text" id="CHANGE_USER_NAME" name="CHANGE_USER_NAME"  value="<%=USER_NAME%>" size="10" maxlength="10" class="inputsubmit" onkeydown='entKeyDown()' >
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
    		<td height="30" align="left" width="40%">
				<TABLE cellpadding="0"  border="0" >
					<TR style="display:none;">
						<td width="3%">&nbsp;</td>
						<td width="25%"> <img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가대상</td>
						<td > 
							<select name="template_type" class="inputsubmit">
								<option value="0">평가 제외</option>
					<%
    				//String template_type = ListBox(request, "SL0109", info.getSession("HOUSE_CODE") + "#M924"+ "#Y", "");
    				//out.println(template_type);
					%>
								</select>
						</td>
						<td width="20%"> 
							<script language="javascript">btn("javascript:doEval()","등록")</script>
						</td>	
					</TR>
				</TABLE>
			</td>
			<td height="30">
        		<div align="right">
		<!-- #새로 UI버튼추가함 -->
					<table cellpadding="0">
						<tr>
							<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
							<td><script language="javascript">btn("javascript:doProcess()","역경매개찰")</script></td>
						</tr>
					</table>
		<!-- # -->
				</div>
      		</td>
    	</tr>
	</table>
</form>
<!---- END OF USER SOURCE CODE ---->
<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="AU_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>