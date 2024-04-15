<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AU_005_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AU_005_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/s_kr/bidding/rat/rat_bd_ins1.jsp -->
<!--
 Title:        역경매입찰  <p>
 Description:  역경매입찰 <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment
!-->



<!-- FUNCTION LIST

-------------------------------------------------------------------------------------------------------
FUNCTION NAME      DESCRIPTION
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

-->
<% //PROCESS ID 선언 %>
<% String WISEHUB_PROCESS_ID="AU_005_2";%>

<% //사용 언어 설정  %>
<% String WISEHUB_LANG_TYPE="KR";%>
<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>
<%-- <%@ include file="/include/wisehub_auth.jsp" %> --%>
<%-- <%@ include file="/include/wisetable_scripts.jsp"%> --%>
<%-- <%@ include file="/include/code_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>

<%

    String house_code    = info.getSession("HOUSE_CODE");
    String vendor_code   = info.getSession("COMPANY_CODE");
    String user_id       = info.getSession("ID") ;

    String company_code  = "";
    String ann_no        = "";
    String subject       = "";
    String start_date    = "";
    String start_time    = "";
    String end_date      = "";
    String end_time      = "";
    String cur           = "";
    String bid_dec_amt   = "";
    String current_price = "";
    String vendor_price  = "";

    String ra_no		 = JSPUtil.nullToEmpty(request.getParameter("ra_no"));
    String ra_count	     = JSPUtil.nullToEmpty(request.getParameter("ra_count"));
    String IRS_NO	     = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
//    String key_no        = JSPUtil.nullToEmpty(request.getParameter("ra_no"))+"TIME";
//    String endDate       = JSPUtil.nullToEmpty(request.getParameter("endDate"));

    String PURCHASE_BLOCK_FLAG = "";
    //공급업체의 입찰이 첫번째인지 여부 결정   한번 입찰하였을 경우 : Y  처음입찰 : N S2031에서 입찰여부를 판단하여 처음인경우 bid_flag를 N으로 수정
    String bid_flag      = "Y";

    String FROM_LOWER_BND      = "";
	String SUM_AMT       	= "";

    String[] pData = {vendor_code, house_code, ra_no, ra_count};
    Object[] args  = {pData};

	SepoaOut value = null;
	SepoaRemote wr = null;
    String nickName = "s2031";
    String conType = "CONNECTION";
    String MethodName = "getratbdins1_1";

    SepoaFormater wf = null;

	try {
		wr = new SepoaRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);
		
		

		wf = new SepoaFormater(value.result[0]);

		int rw_cnt = wf.getRowCount();
		//ANN_NO        = wf.getValue("ANN_NO"        , 0);
		company_code 		= wf.getValue("COMPANY_CODE",0);
		ann_no 				= wf.getValue("ANN_NO",0);
		subject 			= wf.getValue("SUBJECT",0);
		start_date 			= wf.getValue("START_DATE",0);
		start_time 			= wf.getValue("START_TIME",0);
		end_date 			= wf.getValue("END_DATE",0);
		end_time 			= wf.getValue("END_TIME",0);
		cur 				= wf.getValue("CUR",0);
		bid_dec_amt 		= wf.getValue("BID_DEC_AMT",0);
		current_price 		= wf.getValue("CURRENT_PRICE",0);
		vendor_price 		= wf.getValue("VENDOR_PRICE",0);
		FROM_LOWER_BND 		= wf.getValue("FROM_LOWER_BND",0);
		SUM_AMT 			= wf.getValue("SUM_AMT",0);
		PURCHASE_BLOCK_FLAG = wf.getValue("PURCHASE_BLOCK_FLAG",0);

	}catch(Exception e) {
		
		Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
		Logger.dev.println(e.getMessage());
	}finally{
		wr.Release();
	} // finally 끝
%>


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

<%-- 	<script type='text/javascript' src='/dwr/interface/DWR3.js'></script> --%>
<%-- 	<script type='text/javascript' src='/dwr/util.js'></script> --%>
<%-- 	<script type='text/javascript' src='/dwr/engine.js'></script> --%>

		<%
			if("Y".equals(PURCHASE_BLOCK_FLAG)){
		%>
			<script language="javascript" type="text/javascript">
				alert("거래가 중지되었습니다.\n담당자에게 문의하십시요.");
				parent.close();
			</script>

		<%
				return;
			}
		%>

<script language="javascript">
<!--
	var ra_closed = false;

	var INDEX_SELECTED         ;
	var INDEX_ITEM_NO  		   ;
	var INDEX_DESCRIPTION_LOC  ;
	var INDEX_SPECIFICATION    ;
	var INDEX_MAKER_NAME       ;
	var INDEX_UNIT_MEASURE     ;
	var INDEX_QTY              ;
	var INDEX_CUR              ;
	var INDEX_UNIT_PRICE       ;
	var INDEX_AMT              ;
	var INDEX_RA_SEQ           ;
	var server_time;
	var count_day;
	var count_hh;
	var count_mi;
	var count_ss;
	var ra_flag;

    function init() {
		setGridDraw();
		setHeader();
        doSelect();

        /*
        	역경매 실시간 case 1+2번
        	화면 로딩시에 초당으로 DB에 접근해서 현재 가격을 가지고 온다.
        */

        getRaMinPrice();

    }

	 function getRaMinPrice(){
	 	if (ra_closed) return;

	 	
		$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_ins1",
	 			{ mode : "getRaMinPrice", ra_no : "<%=ra_no%>", ra_count : "<%=ra_count%>", vendor_code : "<%=vendor_code%>"},
	 			function(arg){
	 				var data = arg.split("&");
	 				getRaMinPrice_CallBack(data)
	 			}
	 		);
	 		 	
	 	

<%-- 		DWR3.getRaMinPrice("<%=ra_no%>", "<%=ra_count%>", "<%=vendor_code%>", { callback: getRaMinPrice_CallBack }); --%>
	}

	function getRaMinPrice_CallBack(data){
      	/*
      		data[0] : 역경매 현재가격
      		data[1] : 현재시간
      		data[2] : 역경매 종료시간
      		data[3] : 현재 ranking
      	*/
      	document.getElementById("<%=ra_no%>").innerHTML = add_comma(data[0],0);
      	document.form1.ranking.value = "Ranking : " + data[3];
      	clock(data[1],data[2]);

		setTimeout("getRaMinPrice()",1000);
	}

    function setHeader() {

//     	GridObj.strHDClickAction="sortmulti";

// 		GridObj.SetColCellSortEnable("DESCRIPTION_LOC",false);
// 		GridObj.SetColCellSortEnable("UNIT_MEASURE",false);
// 		GridObj.SetNumberFormat("QTY",G_format_qty);
// 		GridObj.SetNumberFormat("UNIT_PRICE",G_format_unit);
// 		GridObj.SetNumberFormat("AMT",G_format_amt);

		INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
		INDEX_ITEM_NO           = GridObj.GetColHDIndex("ITEM_NO");
		INDEX_DESCRIPTION_LOC   = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_UNIT_MEASURE      = GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_QTY               = GridObj.GetColHDIndex("QTY");
		INDEX_CUR               = GridObj.GetColHDIndex("CUR");
		INDEX_ITEM_NO           = GridObj.GetColHDIndex("ITEM_NO");
		INDEX_UNIT_PRICE        = GridObj.GetColHDIndex("UNIT_PRICE");
		INDEX_AMT               = GridObj.GetColHDIndex("AMT");
		INDEX_SPECIFICATION     = GridObj.GetColHDIndex("SPECIFICATION");
		INDEX_MAKER_NAME        = GridObj.GetColHDIndex("MAKER_NAME");
		INDEX_RA_SEQ        	= GridObj.GetColHDIndex("RA_SEQ");
    }

    // 품목 조회
    function doSelect(){
        var mode   = "getReAuctionList";
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_ins1";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
    }

    // 입찰하기
    function doSave() {

	    var bid_price       = del_comma(form1.bid_price.value); //신규입찰가
	    var current_price   = del_comma(document.getElementById("<%=ra_no%>").innerText); //현재가
	    var bid_dec_amt     = del_comma("<%=bid_dec_amt%>"); //투찰단위

		var FROM_LOWER_BND 	= parseFloat("<%=FROM_LOWER_BND%>"); //낙찰하한율
		var SUM_AMT 		= parseFloat("<%=SUM_AMT%>"); //총금액
		var FROM_LOWER_BND_AMT = ((SUM_AMT * FROM_LOWER_BND)/100) //

		if(count_ss < 0){
			alert("역경매가 종료되었습니다.");
			return;
		}

	    if ((bid_price == "") || (parseFloat(bid_price) <= 0 )) {
	    	alert( "입찰금액을 확인하세요." );
	    	form1.bid_price.focus();
	    	form1.bid_price.select();
	    	return;
	    }

		if (parseFloat(current_price) > 0) {
	    	if( parseFloat(bid_price) >= parseFloat(current_price))  {
	    		alert( "입찰가는 "+document.getElementById("<%=ra_no%>").innerText+" 미만이어야 합니다." );
	    		form1.bid_price.focus();
	    		form1.bid_price.select();
	    		return;
	    	}
	    }

	    if ((parseFloat(bid_price) % parseFloat(bid_dec_amt)) != 0 ) {
	    	alert( "입찰가는 투찰단위금액 ( <%=bid_dec_amt%> ) 만큼 감소해야합니다." );
	    	form1.bid_price.focus();
	    	form1.bid_price.select();
	    	return;
	    }
	    if( parseFloat(bid_price) < parseFloat(FROM_LOWER_BND_AMT))  {
	    	alert( "입찰가는 최저 하한가 이상이어야 합니다." );
	    	form1.bid_price.focus();
	    	form1.bid_price.select();
	    	return;
	    }

		if(count_day == "0" && count_hh == "00" && count_mi == "00" && count_ss == "00" ){
			alert("역경매가 종료되었습니다.");
			return;
		}


	    //Message = "입찰하시겠습니까?";

	    //if(!confirm(Message) ) return;
	    
	    var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rat.rat_bd_ins1";
	    $("#count_day").val(count_day);
	    $("#count_hh").val(count_hh);
	    $("#count_mi").val(count_mi);
	    $("#count_ss").val(count_ss);
	    
	    var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setReAuctioncreate";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	    

// 	    servletUrl = "/servlets/supply.bidding.rat.rat_bd_ins1";

// 		GridObj.SetParam("mode", "setReAuctioncreate");
// 		GridObj.SetParam("company_code", document.form1.company_code.value);
// 		GridObj.SetParam("ra_no", document.form1.ra_no.value);
// 		GridObj.SetParam("ra_count", document.form1.ra_count.value);
// 		GridObj.SetParam("cur", document.form1.cur.value);
// 		GridObj.SetParam("bid_flag", document.form1.bid_flag.value);
// 		GridObj.SetParam("bid_price", document.form1.bid_price.value);

// 		//마감 2분전 최저가가 변경되면 2분 연장 시켜줌~

// 		GridObj.SetParam("count_day",count_day);
// 		GridObj.SetParam("count_hh",count_hh);
// 		GridObj.SetParam("count_mi",count_mi);
// 		GridObj.SetParam("count_ss",count_ss);
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
// 		GridObj.SendData(servletUrl, "ALL", "ALL");

    }//doSave() End

    function doClose() {
    	 parent.close();
    	 parent.opener.doSelect();
    }

    function setOnFocus(obj) {
        var target = eval("document.forms[0]." + obj.name);
        target.value = del_comma(target.value);
    }

    function setOnBlur(obj) {
        var target = eval("document.forms[0]." + obj.name);
        if(IsNumber(target.value) == false) {
            alert("숫자를 입력하세요.");
            return;
        }

        target.value = add_comma(target.value,0);
    }

    function ChangeCell(strColumnKey,nRow,vtOldValue,vtNewValue){
    	var wise = GridObj;
    	var bid_price = 0;
    	var value = "";
    	if(strColumnKey == "UNIT_PRICE"){

			if (ra_closed) {
	    		wise.SetCellValue("UNIT_PRICE",nRow,vtOldValue);
	    		alert("입찰이 종료되어 단가를 입력할 수 없습니다. 시간을 다시 확인해 주세요");
	            return;
			}
			
    		var QTY = LRTrim(GridObj.cells(nRow, GridObj.getColIndexById("QTY")).getValue());
    		if( QTY == 0){QTY = 1;}
    		
    		GridObj.cells(nRow, GridObj.getColIndexById("AMT")).setValue(QTY*vtNewValue);

//     		wise.SetCellValue("AMT",nRow,QTY*vtNewValue);
    	}

    	for(var i = 0; i < wise.GetRowCount(); i++){
   			value = LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).getValue());
   			if(value != ""){
   				bid_price += parseFloat(value);
   			}
    	}
    	document.form1.bid_price.value = bid_price;

    	// 가격숫자에 콤마생성
    	setOnFocus(document.form1.bid_price);
    	setOnBlur(document.form1.bid_price);
    }

    function POPUP_Open(url, title, left, top, width, height) {
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		code_search.focus();
	}

    function clock(curDate, endDate) {
		/*
		마감시각을 역경매 화면에서 parameter로 가지고 온 뒤 Date 객체를 통해서
		현재시각과 마감시간의 차이를 계산한다.
		count 변수들은 전역변수로 선언.
		*/

		var curYear   = curDate.substring(0,4);
		var curMonth  = curDate.substring(4,6);
		var curDay    = curDate.substring(6,8);
		var curHour    = curDate.substring(8,10);
		var curMinute  = curDate.substring(10,12);
		var curSec     = curDate.substring(12,14);
		var todayTime  = new Date(curYear,curMonth,curDay,curHour,curMinute,curSec);

		var endYear  = endDate.substring(0,4);
		var endMonth = endDate.substring(4,6);
		var endDay   = endDate.substring(6,8);
		var hour     = endDate.substring(8,10);
		var minute   = endDate.substring(10,12);
		var sec      = endDate.substring(12,14);
		var countDown1 = new Date(endYear,endMonth,endDay,hour,minute,sec);

		var countDown2 = Math.floor((countDown1 - todayTime)/1000); // 밀리세컨이기 때문에 1000을 나누어준다.

		count_day = Math.floor(countDown2/(60*60*24)); // 일수를 구한다.
		countDown2 = countDown2%(60*60*24); // 일수를 제외한 나머지 초수

		count_hh = Math.floor(countDown2/(60*60)); // 시간을 구한다.
		countDown2 = countDown2%(60*60); // 시간을 제외한 나머지 초수

		count_mi = Math.floor(countDown2/60); // 분을 구한다.
		countDown2 = countDown2%(60); // 분을 제외한 나머지 초수

		count_ss = countDown2; // 나머지는 초수이다.

		if (count_day < 0 || count_hh < 0 || count_mi < 0 || count_ss < 0 ){
			document.form1.server_date.value = "0일 00시간 00분 00초";

//			if (count_mi < -2) {
				ra_closed = true;
//			}
		} else {
			if (count_hh < 10) count_hh = "0" + count_hh;
			if (count_mi < 10) count_mi = "0" + count_mi;
			if (count_ss < 10) count_ss = "0" + count_ss;

			document.form1.server_date.value = count_day + "일 " + count_hh + "시간 " + count_mi + "분 " + count_ss + "초";
		}
	}

    function JavaCall(msg1,msg2,msg3,msg4,msg5){

    	var wise = GridObj;

    	if(msg1 == "doQuery"){
    	}
    	if(msg1 == "doData"){
    	
    		var result = msg2;
    		if(result == ""){
    			alert("입찰이 완료되었습니다.");
 				document.form1.cur_price.value = document.form1.bid_price.value;
 				document.form1.bid_price.value = "";
    		}else if(result == "DUP"){
    			alert("더 작은 입찰가가 존재합니다.");
    			location.href = "rat_bd_ins1.jsp?ra_no=<%=ra_no%>&ra_count=<%=ra_count%>&irs_no=<%=IRS_NO%>&vendor_code=<%=vendor_code%>";

    		}else if(result == "EQU"){
    			alert("동일입찰가가 존재합니다.");
    			location.href = "rat_bd_ins1.jsp?ra_no=<%=ra_no%>&ra_count=<%=ra_count%>&vendor_code=<%=vendor_code%>";
    		}else if(result == "END"){
    			alert("역경매가 이미 종료되었습니다.");
    			doClose();
    		}
    	}

    	if(msg1 == "t_imagetext"){
    		if(msg3 == INDEX_ITEM_NO){
    			var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
				if ( BUYER_ITEM_NO != "") {
					POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "mat_pp_ger1", '0', '0', '800', '500');
				}
    		}
    	}
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
	var isReturn = false;
	
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    var orgVal  = 0;
    var currVal = 0;
    if(stage==0) {
    	if(GridObj.getColIndexById("UNIT_PRICE") == cellInd){
    		orgVal = GridObj.cells(rowId, cellInd).getValue();
    	}
    	isReturn = true;
    } else if(stage==1) {
    } else if(stage==2) {
    	if(GridObj.getColIndexById("UNIT_PRICE") == cellInd){
    		currVal = GridObj.cells(rowId, cellInd).getValue();
    	}
	    if(GridObj.getColIndexById("UNIT_PRICE") == cellInd){
		    ChangeCell("UNIT_PRICE",rowId,orgVal,currVal);
	    }
    	isReturn = true;
    }

    
    
    return isReturn;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");
    var rtnVal   = obj.getAttribute("rtnVal");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        //alert(messsage);
        doSelect();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData", rtnVal);
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

<s:header popup="true">
<!--내용시작-->
<form id="form1" name="form1">
	<input type="hidden" id="company_code" 	name="company_code" 	value="<%=company_code%>">
	<input type="hidden" id="ra_no" 		name="ra_no" 			value="<%=ra_no%>">
	<input type="hidden" id="ra_count" 	 	name="ra_count" 		value="<%=ra_count%>">
	<input type="hidden" id="cur" 		 	name="cur" 				value="<%=cur%>">
	<input type="hidden" id="bid_flag" 	 	name="bid_flag" 		value="<%=bid_flag%>">
	<input type="hidden" id="vendor_code" 	name="vendor_code" 		value="<%=vendor_code%>">

	<input type="hidden" id="count_day" 	name="count_day" 		value="">
	<input type="hidden" id="count_hh"  	name="count_hh"  		value="">
	<input type="hidden" id="count_mi"  	name="count_mi"  		value="">
	<input type="hidden" id="count_ss"  	name="count_ss"  		value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" align="left" class="title_page" vAlign="bottom">
	  	역경매 입찰서
	  	</td>
	</tr>
</table>

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
      	<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      	<td width="20%" height="24" class="data_td"><%=ann_no%></td>
    </tr>
	<tr>
		<td colspan="2" height="1" bgcolor="#dedede"></td>
	</tr>  	    
    <tr>
      	<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</td>
    	<td width="20%" height="24" class="data_td"><%=subject.replaceAll("\"", "&quot")%></td>
	</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	  

<br>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    <tr>
		<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 남은시간</td>
		<td width="20%" height="24" class="data_td" colspan="3">
        	<input type="text" id="server_date" name="server_date" size="50" style="background-color:#f6f6f6;border: 0px;" readonly>
      	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
        <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <b>현재가</b>&nbsp;(<%=cur%>)</td>
        <!-- RETURN 되는 값은 DIV 태그나 SPAN 태크로 화면에 직접 뿌려준다.<span id ="amt"></span>-->
        <td width="20%" height="24" class="data_td">&nbsp;<span id ="<%=ra_no%>" style="color:blue;width:100;text-align:right;"></span>&nbsp;&nbsp;<b>원 (VAT 포함)</b></td>
        <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <b>입찰단위</b>
        </td>
        <td width="20%" height="24" class="data_td">
        	<input type="text" id="bid_unit" name="bid_unit" value="<%=bid_dec_amt%>" size="14" style="text-align:right;background-color:#f6f6f6;border: 0px;" readOnly>&nbsp;<b>원</b>
        </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
        <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <b>나의 입찰가</b></td>
        <td width="20%" height="24" class="data_td">
        	<span id ="my_amt" style="color:blue;"></span>
        	<input type="text" id="cur_price" name="cur_price" value="<%=vendor_price%>" size="14" style="font-size:12px; font-weight:bold;text-align:right;background-color:#f6f6f6;border: 0px;" readOnly>&nbsp;<b>원 (VAT 포함)</b>
        	<input type="text" name="ranking" id="ranking" value="" size="20" style="font-size:12px; font-weight:bold;text-align:left;color:blue;background-color:#f6f6f6;border: 0px;" readOnly >
        </td>
        <td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; <b>신규입찰가</b> </td>
        <td width="20%" height="24" class="data_td">
	        <!-- onfocus="javascript:setOnFocus(this);" onblur="javascript:setOnBlur(this);" -->
			<input type="text" id="bid_price" name="bid_price"  value="" size="14" style="text-align:right;background-color:#f6f6f6;border: 0px;" readOnly>&nbsp;<b>원 (VAT 포함)</b>
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
			<TD><script language="javascript">btn("javascript:doSave()","입 찰")</script></TD>
			<TD><script language="javascript">btn("javascript:doClose()","닫 기")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="1" class="cell"></td>
			<!-- wisegrid 상단 bar -->
		</tr>
		<tr>
			 <td align="center">
<%--     			<%=WiseTable_Scripts("100%","250")%> --%>
    		</td>
    	</tr>
</table>

</form>
<iframe name="workFrm" frameborder="0" marginheight="0" marginwidth="0" width="0" height="0"></iframe>

</s:header>
<s:grid screen_id="AU_005_2" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


