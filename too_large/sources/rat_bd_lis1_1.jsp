<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/s_kr/bidding/rat/rat_bd_lis1.jsp -->
<!--
Title:         서플라이어역경매내역  <p>
 Description:  서플라이어역경매내역  <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->

<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_005";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>
<%-- <%@ include file="/include/wisehub_auth.jsp" %> --%>
<%-- <%@ include file="/include/wisetable_scripts.jsp"%> --%>
<%-- <%@ include file="/include/code_common.jsp"%> --%>

<!--
-------------------------------------------------------------------------------
FUNCTION       DESCRIPTION     서플라이어
-------------------------------------------------------------------------------
doSelect()     역경매내역조회
doBid()        입찰화면으로 이동
-------------------------------------------------------------------------------
-->
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<!--
	DWR은 클라이언트가 서버단의 서비스 객체를 호출하기 위한 일종의 
	스텁 스크립트를 자동으로 생성해준다. dwr/interface/*는 서버단의 
	서비스 객체를 호출하기 위한 자바스크립트를 만들어주는 URL이다. 
	그렇기 때문에 ApartmentDAO객체를 클라이언트 쪽에서 사용하기 위해서는 
	미리 DWR1이 정의 되어 있는 자바스크립트를 소스에 포함시켜야 한다. 
	-->
	
	<script type='text/javascript' src='/dwr/interface/DWR1.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>


<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

<%
	String today = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(today,-15);
	String to_date = SepoaDate.addSepoaDateDay(today,15);
	
	String vendor_code = info.getSession("COMPANY_CODE");
	
	
	
%>

<script language="javascript">
<!--
    var mode;
	var vendor_code = "<%=vendor_code%>";
    var server_time;
    var diff_time;

    var gl_server_datetime;

    var INDEX_SELECTED;
    var INDEX_ANN_NO;
    var INDEX_SUBJECT;
    var INDEX_ATTACH_NO;
    var INDEX_START_TEXT;
    var INDEX_END_TEXT;
    var INDEX_BID_COUNT;
    var INDEX_CUR;
    var INDEX_BID_PRICE;
    var INDEX_CURRENT_PRICE;
    var INDEX_RESERVE_PRICE;
    var INDEX_RA_NO;
    var INDEX_RA_COUNT;
    var INDEX_START_DATETIME;
    var INDEX_END_DATETIME;
    var INDEX_IRS_NO;
	var INDEX_RA_FLAG;
	var INDEX_JOIN_FLAG;
	var INDEX_REG_FLAG;
	var amt_Array = new Array();
	var data="";
	var endDate;
	var current_date;
	
	var INDEX_RA_TYPE1;
	var INDEX_CHANGE_USER_ID;
	
	var INDEX_OPEN_REQ_FROM_DATE;
    var INDEX_OPEN_REQ_TO_DATE;
	
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


    	
		
		
		

//     	GridObj.strHDClickAction="sortmulti";
// 		GridObj.SetColCellSortEnable("SUBJECT"        ,false);
// 		GridObj.SetColCellSortEnable("START_TEXT"       ,false);
// 		GridObj.SetColCellSortEnable("END_TEXT"         ,false);
// 		GridObj.SetColCellSortEnable("BID_COUNT"        ,false);
// 		GridObj.SetNumberFormat("BID_PRICE"        ,G_format_amt);
// 		GridObj.SetColCellSortEnable("BID_PRICE"        ,false);
// 		GridObj.SetNumberFormat("CURRENT_PRICE"    ,G_format_amt);
// 		GridObj.SetColCellSortEnable("CURRENT_PRICE"    ,false);
// 		GridObj.SetNumberFormat("RESERVE_PRICE"    ,G_format_amt);
// 		GridObj.SetColCellSortEnable("RESERVE_PRICE"    ,false);
// 		GridObj.SetColCellSortEnable("CUR"              ,false);
// 		GridObj.SetColCellSortEnable("RA_NO"            ,false);
// 		GridObj.SetColCellSortEnable("RA_COUNT"         ,false);
// 		GridObj.SetColCellSortEnable("STATUS"           ,false);
// 		GridObj.SetColCellSortEnable("START_DATETIME"   ,false);
// 		GridObj.SetColCellSortEnable("END_DATETIME"     ,false);
// 		GridObj.SetColCellSortEnable("IRS_NO"     ,false);
// 		GridObj.SetColCellSortEnable("RA_FLAG"				,false);
// 		GridObj.SetColCellSortEnable("JOIN_FLAG"				,false);
		
        INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
        INDEX_ANN_NO            = GridObj.GetColHDIndex("ANN_NO");
        INDEX_SUBJECT           = GridObj.GetColHDIndex("SUBJECT");
        INDEX_ATTACH_NO         = GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_START_TEXT        = GridObj.GetColHDIndex("START_TEXT");
        INDEX_END_TEXT          = GridObj.GetColHDIndex("END_TEXT");
        INDEX_BID_COUNT         = GridObj.GetColHDIndex("BID_COUNT");
        INDEX_CUR               = GridObj.GetColHDIndex("CUR");
        INDEX_BID_PRICE         = GridObj.GetColHDIndex("BID_PRICE");
        INDEX_CURRENT_PRICE     = GridObj.GetColHDIndex("CURRENT_PRICE");
        INDEX_RESERVE_PRICE     = GridObj.GetColHDIndex("RESERVE_PRICE");
        INDEX_RA_NO             = GridObj.GetColHDIndex("RA_NO");
        INDEX_RA_COUNT          = GridObj.GetColHDIndex("RA_COUNT");
        INDEX_STATUS            = GridObj.GetColHDIndex("STATUS");
        INDEX_START_DATETIME    = GridObj.GetColHDIndex("START_DATETIME");
        INDEX_END_DATETIME      = GridObj.GetColHDIndex("END_DATETIME");
        INDEX_IRS_NO			= GridObj.GetColHDIndex("IRS_NO");
		INDEX_RA_FLAG			= GridObj.GetColHDIndex("RA_FLAG");
		INDEX_JOIN_FLAG			= GridObj.GetColHDIndex("JOIN_FLAG");
		INDEX_REG_FLAG			= GridObj.GetColHDIndex("REG_FLAG");
		
		INDEX_RA_TYPE1			= GridObj.GetColHDIndex("RA_TYPE1");
		INDEX_CHANGE_USER_ID			= GridObj.GetColHDIndex("CHANGE_USER_ID");
		
		INDEX_OPEN_REQ_FROM_DATE    =    GridObj.GetColHDIndex("OPEN_REQ_FROM_DATE");
        INDEX_OPEN_REQ_TO_DATE      =    GridObj.GetColHDIndex("OPEN_REQ_TO_DATE");
		
    }

function from_date(year,month,day,week) {
	document.form1.from_date.value=year+month+day;
}

function to_date(year,month,day,week) {
	document.form1.to_date.value=year+month+day;
}

//조회버튼을 클릭
function doSelect()
{
	var from_date		= LRTrim( del_Slash( form1.from_date.value ) );
	var to_date			= LRTrim( del_Slash( form1.to_date.value ) );
	var ann_no			= LRTrim(form1.ann_no.value);

	if(from_date == "" || to_date == "" ) {
		alert("마감일자를 입력하셔야 합니다.");
		return;
	}

    if(!checkDateCommon(from_date))
    {
    	alert("마감일자를 확인하세요.");
    	document.forms[0].from_date.select();
    	return;

    }
    if(!checkDateCommon(to_date))
    {
    	alert("마감일자를 확인하세요.");
    	document.forms[0].to_date.select();
    	return;

    }
    
    

    var mode   = "getratbdlis1_1";
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_lis1";
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=" + mode;
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( servletUrl, params );
	GridObj.clearAll(false);
}

//doBid
function doBid() {
	var checked_count = 0;
	var rowcount = GridObj.GetRowCount();

	var ra_no       = "";
	var ra_count    = "";
	var start_date  = "";
	var end_date    = "";
	var ra_flag     = "";
	var irs_no      = "";
	var join_flag   = "";
	var reg_flag   = "";

	for(var row = rowcount - 1; row >= 0; row--){

		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			checked_count++;

			ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_NO),row);
			ra_count	= GD_GetCellValueIndex(GridObj,row, INDEX_RA_COUNT);
			start_date	= Number(GD_GetCellValueIndex(GridObj,row, INDEX_START_DATETIME) + "00");
			end_date	= Number(GD_GetCellValueIndex(GridObj,row, INDEX_END_DATETIME) + "00");
			ra_flag   	= GD_GetCellValueIndex(GridObj,row, INDEX_RA_FLAG);
			irs_no   	= GD_GetCellValueIndex(GridObj,row, INDEX_IRS_NO);
			join_flag   = GD_GetCellValueIndex(GridObj,row, INDEX_JOIN_FLAG);
			reg_flag   = GD_GetCellValueIndex(GridObj,row, INDEX_REG_FLAG);
		}
	}
	
	gl_server_datetime = Number($("#h_server_date").val());

	if(checked_count == 0)  {
		alert("선택된 로우가 없습니다.");
		return;
	}

	if(checked_count > 1)  {
		alert("하나의 로우만 선택할 수 있습니다.");
		return;
	}

    if (ra_flag == "D") {
		alert("입찰취소하신 건입니다.");
		return;
    }
    
    if (gl_server_datetime < start_date) {
		alert("역경매 입찰이 시작되지 않았습니다.");
		return;
    }
    
	if (end_date < gl_server_datetime) {
		alert("역경매가 종료되었습니다.");
		return;
    }

	if(reg_flag == 'N'){
		alert("이 역경매건에 대해 참가신청을 하지 않았습니다.");
		return;
	}
	
	if(join_flag != 'Y'){
		alert("이 역경매건에 대해 적합 판정을  받지 못하여 역경매에 참여 할 수 없습니다.");
		return;
	}

	for(var i = 0; i < GridObj.GetRowCount(); i++){
		var temp = GridObj.GetCellValue("SELECTED",i);
		if(temp == 1){
			endDate = GridObj.GetCellValue("END_DATETIME",i);
		}
	}
	
	url  = "rat_bd_ins1_frame.jsp?";
	url += "ra_no=" + ra_no;
	url += "&ra_count=" + ra_count;
	url += "&irs_no=" + irs_no;
	url += "&vendor_code="+vendor_code;
	url += "&endDate="+endDate;
	

	window.open(url,"rat_bd_lis1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1200,height=500,left=0,top=0");
}

    // javacall 
    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
        if(msg1 == "doQuery"){
      	    
      	    //server_time = GD_GetParam(GridObj,0);
      	    
//             var currentDate = new Date();
//             var client_time = currentDate.getTime();
// 			server_time = client_time;
//        	    clock("s");
       	    
       	    
       	    /*
       	    for(var i = 0; i < GridObj.GetRowCount(); i++){
        		if(i != GridObj.GetRowCount()-1){
        			data += GridObj.GetCellValue("CURRENT_PRICE",i)+"-";	
        		}else{
        			data += GridObj.GetCellValue("CURRENT_PRICE",i);
        		}
        	}
        	dwr_rat_SetAmt();
        	dwr_rat_GetAmt();
        	*/
       	    
	    }else if(msg1 == "doData"){
	    	//alert(GridObj.GetMessage());
	    	//doSelect();

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
        }else if(msg1 == "t_imagetext") {
    		var ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_NO),msg2);
    		var ra_count	= GD_GetCellValueIndex(GridObj,msg2, INDEX_RA_COUNT);
			var RA_FLAG       = GD_GetCellValueIndex(GridObj,msg2,INDEX_RA_FLAG);

		    if(msg3 == INDEX_ANN_NO) { //공고번호
				if(RA_FLAG != "D") { // 입찰공고, 정정공고
                   window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");

                } else {//취소공고
                   window.open("/s_kr/bidding/rat/rat_pp_dis3.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
                }
    			//window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");
		    } else if(msg3 == INDEX_ATTACH_NO) { //펌부파일
				var attach_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_ATTACH_NO);
				if (attach_no != "") {
                	rMateFileAttach('P','R','RA',attach_no);
                }
		    } else if(msg3 == INDEX_BID_COUNT){//입찰수

			    bid_count	= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_COUNT),msg2);

			    ra_no		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_NO),msg2);
			    ra_count	= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_COUNT),msg2);
			    ra_seq 		= GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RA_SEQ),msg2);

			    url  = "/kr/dt/rfq/rat_pp_lis2.jsp?";
			    url += "ra_no="+ra_no;
			    url += "&ra_count="+ra_count;
			    url += "&ra_seq="+ra_seq;
			    url += "&ra_type2="+ra_type2;

			    window.open(url,"rat_pp_lis2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=660,height=300,left=0,top=0");
		    }	
	    }
    }

//     var tmpSec = 1000;
// 	function clock(flag) {
		
// 		if("undefined" != typeof server_time) {
// 			curDate = new Date(server_time + tmpSec);
// 			yyyy    = curDate.getYear();
// 			mm      = curDate.getMonth();
// 			dd      = curDate.getDate();
// 			hh      = curDate.getHours();
// 			mi      = curDate.getMinutes();
// 			ss      = curDate.getSeconds();
	
// 	        if (mm < 10) mm = "0" + mm;
// 	        if (dd < 10) dd = "0" + dd;
// 	        if (hh < 10) hh = "0" + hh;
// 	        if (mi < 10) mi = "0" + mi;
// 	        if (ss < 10) ss = "0" + ss;
// 	        current_time = yyyy+""+mm+""+dd;
	
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
			
// 			gl_server_datetime = "" + yyyy + mm + dd + hh + mi;
			
// 			document.form1.server_date.value = yyyy + "년" + mm + "월" + dd + "일(" + day + ") " + hh + "시" + mi + "분" + ss + "초";
// 		}
// 		tmpSec = tmpSec + 1000;
//  		setTimeout('clock("c")', 1000);
// 	}

	function rMateFileAttach(att_mode, view_type, file_type, att_no) {
		var f = document.forms[0];
	
		f.att_mode.value   = att_mode;
		f.view_type.value  = view_type;
		f.file_type.value  = file_type;
		f.tmp_att_no.value = att_no;

		if (att_mode == "P") {
			var protocol = location.protocol;
			var host     = location.host;
			var addr     = protocol +"//" +host;

			var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

			f.method = "POST";
			f.target = "fileattach";
			f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
			f.submit();
		}
	}
	
	
    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if (true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
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
	
	function checkPeriod(){
		
		
		var current_date = $("#h_server_date").val().substring(0,8);
		var current_time = $("#h_server_date").val().substring(8);
		var wise = GridObj;
		var OPEN_REQ_FROM_DATE;
		var OPEN_REQ_TO_DATE;
		
		for(i = 0 ; i < wise.GetRowCount(); i ++){
			var temp = wise.GetCellValue("SELECTED",i);
			if(temp == 1){
				OPEN_REQ_FROM_DATE = wise.GetCellValue("OPEN_REQ_FROM_DATE",i);
				OPEN_REQ_TO_DATE = wise.GetCellValue("OPEN_REQ_TO_DATE",i);
			}
		}
		
		if(OPEN_REQ_FROM_DATE == "" && OPEN_REQ_TO_DATE == ""){
			return true;
		}else {
			if(OPEN_REQ_FROM_DATE == "" ){
				
				if(OPEN_REQ_TO_DATE < current_time){
					alert("참가신청 기간이 종료하였습니다.");
					return;
				}
			}else if(OPEN_REQ_TO_DATE == ""){
				
				if(OPEN_REQ_FROM_DATE > current_time){
					alert("참가신청 기간 전입니다.");
					return;
				}
			}else if(!OPEN_REQ_TO_DATE == "" && !OPEN_REQ_FROM_DATE == ""){
				
				if(OPEN_REQ_FROM_DATE > current_date || current_date > OPEN_REQ_TO_DATE){
					alert("참가신청 기간이 아닙니다.");
					return;	
				}
			}
		}
		return true;
		
	}
	
	function doRatReg(){
		
		var wise = GridObj;

		var row_idx = checkedRow();
        
        if (row_idx == -1) return;
	
		for(i = 0 ; i < wise.GetRowCount(); i ++){
			var temp = wise.GetCellValue("SELECTED",i);
			if(temp == 1){
				RA_TYPE1 = wise.GetCellValue("RA_TYPE1",i);
				RA_FLAG = wise.GetCellValue("RA_FLAG",i);
				REG_FLAG = wise.GetCellValue("REG_FLAG",i);
			}
		}
		
		//RA_FLAG D 취소
		if("D" == RA_FLAG){
			alert("취소된건은 참가신청을 할 수 없습니다.");
			return;
		}
		
		if(!checkPeriod()) return;
		
		if("Y" == REG_FLAG){
			alert("이미 참가신청을 했습니다.");
			return;
		}
				
		if(!confirm("참가신청을 하시겠습니까?")) return;

		$("#RA_TYPE1").val(RA_TYPE1);
		$("#vendor_code").val(vendor_code);
		
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_lis1";
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setJoinVendorReg";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);		
	}

//-->
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
    if(GridObj.getColIndexById("ANN_NO") == cellInd){
		var RA_FLAG 	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_FLAG")).getValue());
		var ra_no		= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_NO")).getValue());
		var ra_count	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("RA_COUNT")).getValue());
		
		if(RA_FLAG != "D") { // 입찰공고, 정정공고
            window.open("/ebid_doc/reveracution.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=900,height=740,left=0,top=0");

         } else {//취소공고
//             window.open("/s_kr/bidding/rat/rat_pp_dis3.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
            window.open("/kr/dt/rat/rat_bd_ins2.jsp?RA_NO="+ra_no+"&RA_COUNT="+ra_count+"&SCR_FLAG=V","windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=550,left=0,top=0");
         }    	
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
        //doQuery();
        doSelect();
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
    
    document.form1.from_date.value = add_Slash( document.form1.from_date.value );
    document.form1.to_date.value   = add_Slash( document.form1.to_date.value   );
    
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

<!-- <table width="100%" border="0" cellspacing="0" cellpadding="0"> -->
<!-- 	<tr> -->
<!-- 		<td class="cell_title1" width="78%" align="left">&nbsp; -->
<%-- 	  	<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" align="absmiddle" width="12" height="12"> --%>
<%-- 	  	<!-- <%@ include file="/include/sepoa_milestone.jsp" %> --> --%>
<!-- 	  	입찰견적 > 역경매관리 > 역경매현황  -->
<!-- 	  	</td> -->
<!-- 	</tr> -->
<!-- </table> -->
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
  	<form name="form1" >
	<input type="hidden" id="att_mode"  	name="att_mode"  	value="">
	<input type="hidden" id="view_type" 	name="view_type"  	value="">
	<input type="hidden" id="file_type" 	name="file_type"  	value="">
	<input type="hidden" id="tmp_att_no" 	name="tmp_att_no" 	value="">
	<input type="hidden" id="RA_TYPE1" 		name="RA_TYPE1" 	value="">
	<input type="hidden" id="vendor_code" 	name="vendor_code" 	value="">

    <tr>
      <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 마감일자</td>
      <td width="20%" height="24" class="data_td">
      	<s:calendar id="from_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" 	format="%Y/%m/%d"/>~
      	<s:calendar id="to_date"   default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(), 1) )%>" 									format="%Y/%m/%d"/>
      </td>
      <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      <td width="20%" height="24" class="data_td">
        <input type="text" id="ann_no" name="ann_no" style="ime-mode:inactive" size="20" maxlength="14" class="inputsubmit" >
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
  		<td height="30" align="right">
			<TABLE cellpadding="0">
    			<TR>
					<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
					<TD><script language="javascript">btn("javascript:doRatReg()","참가신청")</script></TD>
					<TD><script language="javascript">btn("javascript:doBid()","입 찰")</script></TD>
  	  			</TR>
   			</TABLE>
   		</td>
 	</tr>
</table>
</form>

<!---- END OF USER SOURCE CODE ---->


</s:header>
<s:grid screen_id="AU_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


