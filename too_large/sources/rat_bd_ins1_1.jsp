<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String tmp = "AR_001_3";
%>

<%

	Vector multilang_id = new Vector();
	multilang_id.addElement(tmp);
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AR_001_3";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON 	= "";
	String G_IMG		= "";

%>
<!--
 Title:        역경매등록 <p>
 Description:  역경매내역을 등록한다. <p>
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
<% String WISEHUB_PROCESS_ID="AR_001_3";%>
<% String WISEHUB_LANG_TYPE="KR";%>


<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>
<%-- <%@ include file="/include/wisehub_auth.jsp" %> --%>
<%-- <%@ include file="/include/wisetable_scripts.jsp"%> --%>
<%-- <%@ include file="/include/code_common.jsp"%> --%>
<%-- <%@ include file="/include/wisehub_scripts.jsp"%> --%>
<%!
	public String[] parseValue(String value) {
		String token = "@";
		if(value == null) return null;

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue);
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}

	public String[] parseValueOp(String value) {
		String token = "@";
		if(value == null) return null;

		Vector v = new Vector();

		String subvalue;
		boolean token_flag = true;
		int start_token_count = 0;
		int end_token_count = 0;

		while(token_flag) {
			end_token_count = value.indexOf(token, end_token_count);

			if(end_token_count == -1) token_flag = false;
			else {
				subvalue = value.substring(start_token_count, end_token_count);
				end_token_count += token.length();
				start_token_count = end_token_count;
				v.addElement(subvalue.replaceAll("#","@"));
			}
		}

		String[] szvalue = new String[v.size()];
		v.copyInto(szvalue);

		return szvalue;
	}
%>
<%
	String PR_NO        = JSPUtil.nullToRef(request.getParameter("PR_NO"), "");
// 	String PR_NO        = JSPUtil.nullToRef(request.getParameter("REQ_PR_NO"), "");
	String shipper_type = JSPUtil.nullToRef(request.getParameter("BID_TYPE"), "");
	String BID_STATUS   = JSPUtil.nullToRef(request.getParameter("BID_STATUS"), "");
	String CTRL_AMT     = JSPUtil.nullToRef(request.getParameter("CTRL_AMT"), "");      // 통제금액
	String ITEM_NAME    = JSPUtil.nullToRef(request.getParameter("ITEM_NAME"), "");

	String RA_NO        = JSPUtil.nullToRef(request.getParameter("RA_NO"), "");         // 수정/확정/상세조회
	String RA_COUNT     = JSPUtil.nullToRef(request.getParameter("RA_COUNT"), "");      // 수정/확정/상세조회
	String SCR_FLAG     = JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "");     	//I:생성  U:수정  C:확정 D:취소
	String REQ_PR_SEQ   = JSPUtil.nullToRef(request.getParameter("PR_DATA"), "");       // PR_NO $@$- PR_SEQ $#$,request.getParameter("REQ_PR_SEQ");
	String RA_FLAG      = JSPUtil.nullToRef(request.getParameter("RA_FLAG"), "");

	String req_type 	= JSPUtil.nullToEmpty(request.getParameter("REQ_TYPE"));
	String pr_name		= JSPUtil.nullToRef(request.getParameter("PR_NAME"), "");
	
	if("".equals(shipper_type)) shipper_type ="D";
	if("".equals(CTRL_AMT))    CTRL_AMT      = "0";
	if("".equals(SCR_FLAG))    SCR_FLAG      = "I";

	if(SCR_FLAG.equals("C") ) RA_FLAG = "P";
	if(SCR_FLAG.equals("D") ) RA_FLAG = "D";


	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String CREATE_TYPE   = "PR"; //PR:구매검토목록에서 넘어온 경우, MA:직접입력
	String PR_TYPE2      = "T";


	String current_date = SepoaString.getDateSlashFormat(SepoaDate.getShortDateString());//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

	//////////////////////////////////////////////////////////////////////////////////////////////////////사전견적건으로 추가 기존로직으로 돌아갈시 삭제
	if("I".equals(SCR_FLAG)){
		Object[] prObj = {hashMap};
		SepoaOut prValue = ServiceConnector.doService(info, "BD_001", "CONNECTION","getDefaultPrData", prObj);
	
		if(prValue.flag){
		SepoaFormater prSf = new SepoaFormater(prValue.result[0]);
			if(prSf != null && prSf.getRowCount() > 0) {
				PR_NO        = ""; //데이타 초기화
				REQ_PR_SEQ   = ""; //데이타 초기화
				req_type     = ""; //데이타 초기화
				CREATE_TYPE  = ""; //데이타 초기화
				shipper_type = ""; //데이타 초기화
				pr_name      = ""; //데이타 초기화
				
				for(int i = 0 ; i < prSf.getRowCount() ; i++ ){
					if(i == prSf.getRowCount()-1){
						REQ_PR_SEQ += prSf.getValue("PR_NO", i) + "-" + prSf.getValue("PR_SEQ", i);
					}
					else {
						REQ_PR_SEQ += prSf.getValue("PR_NO", i) + "-" + prSf.getValue("PR_SEQ", i) + ",";
					}
				}
				PR_NO        = prSf.getValue("PR_NO"       , 0);
				req_type     = prSf.getValue("REQ_TYPE"    , 0);
				CREATE_TYPE  = prSf.getValue("CREATE_TYPE" , 0);
				shipper_type = prSf.getValue("SHIPPER_TYPE", 0);
				pr_name      = prSf.getValue("SUBJECT"     , 0);
			}
		} else {
			out.print("<script>");
			out.print("alert('"+prValue.message+"');window.close();");
			out.print("</script>");
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////사전견적건으로 추가 기존로직으로 돌아갈시 삭제

	String script = "";
	String abled = "";

	if(SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script  = "readonly";
		abled   = "disabled";
	}

	String ANN_NO        = "";
	String ANN_DATE      = "";
	String SUBJECT       = "";
	String RA_TYPE1      = "";   //역경매타입1 (O:공개,C:지명)
	String VENDOR_CNT    = "0";
	String VENDOR_VALUES = "";
	String LOCATION_CNT  = "0";
	String LOCATION_VALUES = "";
	String START_DATE    = "";
	String END_DATE      = "";
	String CUR           = "";
	String RESERVE_PRICE = "0";
	String BID_DEC_AMT   = "1000";  //default
	String LIMIT_CRIT    = "";
	String PROM_CRIT     = "";   //default
	String REMARK        = "";
	String ATTACH_NO     = "";
	String START_TIME_HOUR_MINUTE = "0000";
	String END_TIME_HOUR_MINUTE   = "0000";
	String ATTACH_CNT             = "0";


	String CONT_TYPE_TEXT  = "";
	String CONT_PLACE      = "";
	String BID_PAY_TEXT    = "";
	String BID_CANCEL_TEXT = "";
	String BID_JOIN_TEXT   = "";
	String RA_ETC          = "";
	String FROM_LOWER_BND  = "";

	String RD_DATE            = "";
	String DELY_PLACE         = "";
	String OPEN_REQ_FROM_DATE = "";
	String OPEN_REQ_TO_DATE = "";
	String PROM_CRIT_TYPE = "";

	String origin_bid_status = SCR_FLAG+BID_STATUS;

	Object[] args = {HOUSE_CODE,RA_NO, RA_COUNT};
%>

<%

	SepoaOut value = null;
	SepoaRemote wr = null;
	String nickName   = "p1008";
	String conType    = "CONNECTION";
	String MethodName = "getratbdupd1_1";
	SepoaFormater wf = null;

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	try {
		wr = new SepoaRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);

		wf = new SepoaFormater(value.result[0]);

		int rw_cnt = wf.getRowCount();

		if(!(origin_bid_status).equals("IAR")) { // 경매신규 작성을 하려는 경우외 에는 기존에 data를 조회해 온다.
			ANN_NO        = wf.getValue("ANN_NO"        , 0);
			ANN_DATE      = wf.getValue("ANN_DATE"      , 0);
			SUBJECT       = wf.getValue("SUBJECT"       , 0);
			RA_TYPE1      = wf.getValue("RA_TYPE1"      , 0);
			VENDOR_CNT	  = wf.getValue("VENDOR_COUNT"  , 0);
			VENDOR_VALUES = wf.getValue("VENDOR_SELECT" , 0);
			LOCATION_CNT    = wf.getValue("LOCATION_CNT"          ,0);
			LOCATION_VALUES = wf.getValue("LOCATION_VALUES"       ,0);
			START_DATE      = wf.getValue("START_DATE"    , 0);
			START_TIME_HOUR_MINUTE = wf.getValue("APP_BEGIN_TIME_HOUR"   ,0)+wf.getValue("APP_BEGIN_TIME_MINUTE" ,0);
			END_DATE      	= wf.getValue("END_DATE"      , 0);
			END_TIME_HOUR_MINUTE   = wf.getValue("APP_END_TIME_HOUR"   ,0)+wf.getValue("APP_END_TIME_MINUTE" ,0);
			CUR           = wf.getValue("CUR"           , 0);
			RESERVE_PRICE = wf.getValue("RESERVE_PRICE" , 0);
			BID_DEC_AMT   = wf.getValue("BID_DEC_AMT"   , 0);
			LIMIT_CRIT    = wf.getValue("LIMIT_CRIT"    , 0);
			PROM_CRIT     = wf.getValue("PROM_CRIT"     , 0);
			REMARK        = wf.getValue("REMARK"        , 0);
			ATTACH_CNT	  = wf.getValue("ATTACH_COUNT"  , 0);
			ATTACH_NO     = wf.getValue("ATTACH_NO"     , 0);

			CONT_TYPE_TEXT               = wf.getValue("CONT_TYPE_TEXT"     ,0);
			CONT_PLACE                   = wf.getValue("CONT_PLACE"         ,0);
			BID_PAY_TEXT                 = wf.getValue("BID_PAY_TEXT"       ,0);
			BID_CANCEL_TEXT              = wf.getValue("BID_CANCEL_TEXT"    ,0);
			BID_JOIN_TEXT                = wf.getValue("BID_JOIN_TEXT"      ,0);
			RA_ETC                       = wf.getValue("RA_ETC"             ,0);
			FROM_LOWER_BND               = wf.getValue("FROM_LOWER_BND"     ,0);
			RD_DATE                      = wf.getValue("RD_DATE"            ,0);
			DELY_PLACE                   = wf.getValue("DELY_PLACE"         ,0);
			OPEN_REQ_FROM_DATE           = wf.getValue("OPEN_REQ_FROM_DATE" ,0);
			OPEN_REQ_TO_DATE             = wf.getValue("OPEN_REQ_TO_DATE"   ,0);
			PROM_CRIT_TYPE               = wf.getValue("PROM_CRIT_TYPE"     ,0);

			wf = new SepoaFormater(value.result[1]);
	}

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
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
<!--
	var button_flag = false;
	var G_FLAG = "N";

	var mode;
	var Vendor_values   = "<%=VENDOR_VALUES%>";       // 업체 Data
	var Location_values = "";       // 지역 Data
	var Bid_Location    = "";       // 복수낙찰 Data

	var date_flag;
	var Current_Row;
	var TOT_OPERATING;              // /kr/dt/pr/pr1_pp_lis5_frame.jsp 에서 사용...
	var TOT_CUR;

	var current_date = "<%=current_date%>";
	var current_time = "<%=current_time%>";
	var INDEX_ITEM_NO  		   ;
	var INDEX_SELECTED         ;
	var INDEX_DESCRIPTION_LOC  ;
	var INDEX_UNIT_MEASURE     ;
	var INDEX_QTY              ;
	var INDEX_CUR              ;
	var INDEX_UNIT_PRICE       ;
	var INDEX_AMT              ;
	var INDEX_PR_NO       		;
	var INDEX_PR_SEQ            ;
	var INDEX_RD_DATE;
	var INDEX_VENDOR_SELECTED        			;

	window.onload = function(){
		if("<%=SCR_FLAG%>"=="C"){
			if(document.forms[0].RA_TYPE1.value == "GC"){
				document.all.TWIT_YN.style.display="inline" ;
			}else{
				document.all.TWIT_YN.style.display="none" ;
			}
		}
	}

	function setHeader() {
<%
	if(SCR_FLAG.equals("C")) {
%>
<%
	}else{
%>
<%
	}
%>
		INDEX_SELECTED          = GridObj.GetColHDIndex("SELECTED");
		INDEX_DESCRIPTION_LOC   = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_UNIT_MEASURE      = GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_QTY               = GridObj.GetColHDIndex("QTY");
		INDEX_CUR               = GridObj.GetColHDIndex("CUR");
		INDEX_ITEM_NO           = GridObj.GetColHDIndex("ITEM_NO");
		INDEX_UNIT_PRICE        = GridObj.GetColHDIndex("UNIT_PRICE");
		INDEX_AMT               = GridObj.GetColHDIndex("AMT");
		INDEX_PR_NO        		= GridObj.GetColHDIndex("PR_NO");
		INDEX_PR_SEQ            = GridObj.GetColHDIndex("PR_SEQ");
		INDEX_RD_DATE           = GridObj.GetColHDIndex("RD_DATE");
		INDEX_VENDOR_SELECTED   = GridObj.GetColHDIndex("VENDOR_SELECTED"		);

		document.forms[0].RA_NO.value = "<%=RA_NO%>";
		document.forms[0].RA_COUNT.value = "<%=RA_COUNT%>";
	}

	var thistime    = "<%=current_time%>".substring(0,2);
	var thisminute    = "<%=current_time%>".substring(2,4);

	function init() {

		//생성시 디폴트값 세팅
		<% if ( SCR_FLAG.equals("I") && !BID_STATUS.equals("UR")) { %>
    	   document.form1.FROM_LOWER_BND.value = 0;
    	   document.form1.ANN_DATE.value = current_date;
		<% } %>
		setGridDraw();
		setHeader();
		doSelect();

		//역경매방법 Setting
		var idx = 0;
		var ls_ra_type1 = "<%=RA_TYPE1%>";
		if (ls_ra_type1 != "") {
			for( var i = 0; i <= document.form1.RA_TYPE1.length; i++ ) {
					if (ls_ra_type1 == document.form1.RA_TYPE1[i].value) {
							idx = i;
							break;
						}
				}
				document.form1.RA_TYPE1.selectedIndex = idx;
		}
		setVisibleVendor();
		setApprovalButton(<%=ATTACH_CNT%>);
	}

	function doSelect() {
		
		if("<%=SCR_FLAG%>" == "U") {// //I:생성  U:수정  C:확정 D:취소
			mode = "getRADTDisplay";
		} else if("<%=SCR_FLAG%>" == "C") {
			mode = "getRADTDisplay";
		} else if("<%=SCR_FLAG%>" == "D") {
			mode = "getRADTDisplay";
		} else {
			mode = "getPrDTDisplay_VAT";
		}
    	
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins1";
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);
	}

	function doSelect2(REQ_PR_SEQ) {
		mode = "getPrDTDisplay_VAT";

		var basic_pr_no_seq = "";

		for(row=0; row<GridObj.GetRowCount();	row++) {
			basic_pr_no_seq += GD_GetCellValueIndex(GridObj,row,	INDEX_PR_NO) + "$@$" + GD_GetCellValueIndex(GridObj,row,	INDEX_PR_SEQ) + "^#^";
		}
		servletUrl = "/servlets/dt.rat.rat_bd_ins1";

		GridObj.SetParam("mode", mode);
		GridObj.SetParam("PR_NO", "<%=PR_NO%>");
		GridObj.SetParam("REQ_PR_SEQ", basic_pr_no_seq+REQ_PR_SEQ);
		GridObj.SetParam("RA_NO", "<%=RA_NO%>");
		GridObj.SetParam("RA_COUNT", "<%=RA_COUNT%>");
		GridObj.SetParam("ITEM_FIND", "ITEM_FIND");

		GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti";
	}

	function cal_length(obj){

		document.forms[0].TWIT_LEN.value = obj.value.length ;

		if( obj.value.length > 140) {
			alert("트위터 등록은 140 BYTE를 초과 할 수 없습니다");
			document.forms[0].TWIT.value = obj.value.substring(0,138);
		}
	}

	function setTwit(tmsg){
		var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
		xmlHTTP.open("POST", "/kr/dt/bidd/twitter.jsp?TWIT=" + tmsg, false);

		xmlHTTP.send();

		if (xmlHTTP.status == 200 && xmlHTTP.responseXml.text == "1"){

		}else{
			return xmlHTTP.responseText;
		}
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		var wise = GridObj;
		
		if(msg1 == "t_imagetext") {
			if(msg3 == INDEX_ITEM_NO) { //품목
				var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
                var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
				if ( BUYER_ITEM_NO != "") {
					POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "mat_pp_ger1", '0', '0', '800', '700');
				}
			}else if(msg3 == INDEX_PR_NO){
				pr_no = GridObj.GetCellValue(GridObj.GetColHDKey( msg3),msg2);
				window.open('/kr/dt/ebd/ebd_pp_dis6.jsp?pr_no='+pr_no ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
			}else if(msg3 == INDEX_VENDOR_SELECTED) { //업체선택

				if(GridObj.GetRowCount() == 0) return;
				
				if (form1.RA_TYPE1.value == "GC" ) {
		    		
		    		alert('일반경쟁에선 업체를 선택할 수 없습니다.');
		    		return;
		    	}

				getVendor();
			}
		}
		if(msg1 == "t_insert") {
			if(msg3 == INDEX_UNIT_PRICE) {
        		calculate_pr_amt(wise, msg2);
      		}
		}

		if(msg1 == "doQuery") {
			for(row=0; row<GridObj.GetRowCount(); row++) {
				GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED,  G_IMG_ICON + "&" + <%=VENDOR_CNT%>  + "&Y", "&");
			}
			if (mode == "getBidPRDisplay") {
			}

			if("<%=SCR_FLAG%>" == "I"){
				changeSumAmt();
			}
		} else if(msg1 == "doData") { // 전송/저장시

			/*
				------------ 트위터 글등록 시작 ------------
				일반경쟁이고  확정 일 경우에만!
			*/
			if(document.forms[0].approval_str.value=="C" && document.forms[0].RA_TYPE1.value == "GC"){
				if(document.forms[0].TWIT.value!="" && document.forms[0].TWIT.value !=" "){
					//var rmsg = setTwit(document.forms[0].TWIT.value);
    				//if(rmsg.indexOf("Y")==-1){
	    			//	alert("트위터 작성 시 오류가 발생했습니다.\n\n트위터 등록 관련사항은  시스템 담당자를 통해 확인 하시 기 바랍니다.\n\n오류메세지["+rmsg+"]");
    				//}
    			}
    		}
			/* ------------ 트위터 글등록 종료 ------------ */

			//alert(GridObj.GetMessage());
			opener.doSelect();
			window.close();
		}
	}

	function setSignStatus() {
		mode = "setSignStatus";
		servletUrl = "/servlets/dt.bidd.ebd_bd_ins1"; //p1009

		GridObj.SetParam("mode", mode);
		GridObj.SetParam("BID_NO", document.forms[0].bid_no.value);
		GridObj.SetParam("BID_COUNT", document.forms[0].bid_count.value);
		GridObj.SetParam("SIGN_STATUS", "P"); // 결재요청 상태('P')로 UPDATE한다.

		GridObj.bSendDataFuncDefaultValidate=false;
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
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

    function setVisibleVendor() {
		var ra_type1 = document.forms[0].RA_TYPE1.value;
		
		if ( ra_type1 == "NC" ) {
			for(n=1;n<=4;n++) {
				$("#h"+n).show();
// 				document.all["h"+n].style.visibility = "visible";
			}

			for(m=1;m<=4;m++) {
				$("#h1"+n).hide();
// 				document.all["h1"+m].style.visibility = "hidden";
			}

// 			document.forms[0].vendor_count.value = "0";

		} else if ( ra_type1 == "LC" ) {
			for(m=1;m<=4;m++) {
				$("#h1"+n).show();
// 				document.all["h1"+m].style.visibility = "visible";
			}

			for(n=1;n<=4;n++) {
				$("#h"+n).hide();
// 				document.all["h"+n].style.visibility = "hidden";
			}

			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";
		}else {
			for(n=1;n<=4;n++) {
				$("#h"+n).hide();
// 				document.all["h"+n].style.visibility = "hidden";
			}

			document.forms[0].vendor_values.value = "";
			document.forms[0].vendor_count.value = "0";

			for(m=1;m<=4;m++) {
				$("#h1"+n).hide();
// 				document.all["h1"+m].style.visibility = "hidden";
			}

			//document.forms[0].location_values.value = "";
			document.forms[0].vendor_count.value = "0";
		}
	}

    //달력----------------------------------------
    function ann_date(year,month,day,week) {
    	document.form1.ANN_DATE.value=year+month+day;
    }

    function START_DATE(year,month,day,week) {
    	document.form1.START_DATE.value=year+month+day;
    }

    function END_DATE(year,month,day,week) {
    	document.form1.END_DATE.value=year+month+day;
    }

    //참가신청기간
    function open_req_from_date(year,month,day,week) {
    	document.form1.open_req_from_date.value=year+month+day;
    }

    function open_req_to_date(year,month,day,week) {
    	document.form1.open_req_to_date.value=year+month+day;
    }

    //업체지정------------------------------------
	function getVendor() {      //업체지정
    	
		var ra_type1 = form1.RA_TYPE1.value;

		if ( ra_type1 == "GC" ) {
    		
    		alert('일반경쟁에선 업체를 선택할 수 없습니다.');
    		return;
    	}
    	
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.vendor_count.value;

		var url;
		
		
		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "/kr/dt/rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "/kr/dt/rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}
<%-- 		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // 정정공고건의 경우에도 기존 데이터를 가져온다. --%>
// 			mode = "BID";
<%-- 			url = "/kr/dt/rfq/rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=RA_NO%>&BID_COUNT=<%=RA_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>"; --%>
// 		}
		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
	}

	function vendorInsert(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
		Vendor_values = VANDOR_SELECTED;
		document.form1.vendor_values.value = Vendor_values;
		document.form1.vendor_count.value = SELECTED_COUNT;
		
		if(szRow == "-1") {
			for(row=0; row<GridObj.GetRowCount(); row++) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED,  G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&");
				}
			}
		} else {
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED,  G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&");
		}
	}

	function getCompany(szRow) {
		return Vendor_values;
	}

	function setVendor(values, count) {
		Bid_Vendors = values;

		for(var i = 0; i < document.form1.bid_vendor.length; i++) {
			if (count == document.form1.bid_vendor.options(i).value) {
				document.form1.bid_vendor.selectedIndex = i;
				break;
			}
		}
	}

	function getLocation() {      //제한조건
		var mode;
		var shipper_type = "KR";
		var szRow = "-1";
		var cnt = document.form1.location_count.value;

		var url;

		if( cnt == "" || cnt == 0 ) {
			mode = "E";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		} else {
			mode = "I";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&SCR_FLAG=<%=SCR_FLAG%>&shipper_type="+shipper_type;
		}

		if("<%=SCR_FLAG%>" == "U" || "<%=SCR_FLAG%>" == "C" || "<%=SCR_FLAG%>" == "D" || ( "<%=SCR_FLAG%>" == "I" && "<%=BID_STATUS%>" == "UR" )) { // 정정공고건의 경우에도 기존 데이터를 가져온다.
			mode = "BID";
			url = "../rfq/rfq_pp_ins11.jsp?mode=" + mode + "&szRow=" + szRow + "&shipper_type="+shipper_type+"&BID_NO=<%=RA_NO%>&BID_COUNT=<%=RA_COUNT%>&SCR_FLAG=<%=SCR_FLAG%>";
		}

		window.open( url , "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=650,height=400,left=0,top=0");
	}

	function locationInsert(szRow, LOCATION_SELECTED, SELECTED_COUNT) {
		Location_values = LOCATION_SELECTED;
		document.form1.location_values.value = Location_values;
		document.form1.location_count.value = SELECTED_COUNT;
	}

	function getLocation_value(szRow) {
		return Location_values;
	}

	function setLocation(values, count) {
		Bid_Location = values;

		for(var i = 0; i < document.form1.bid_location.length; i++) {
			if (count == document.form1.bid_location.options(i).value) {
				document.form1.bid_location.selectedIndex = i;
				break;
			}
		}
	}

	function TimeCheck(str) {
		var hh,mm;

		if(str.length == 0) return true;

		if(IsNumber1(str)==false || str.length !=4 ) return false;

		hh=str.substring(0,2);
		mm=str.substring(2,4);

		if(parseInt(hh)<0 || parseInt(hh)>23) return false;

		if(parseInt(mm)<0 || parseInt(mm)>59) return false;

		return true;
	}

    //저장----------------------------------------
    function checkData() {
        var today   = "<%=current_date%>";
    	var rtn     = false;

		var cur_hh   = current_time.substring(0,2);
		var cur_mm   = current_time.substring(2,4);

		var ANN_DATE					= del_Slash(document.forms[0].ANN_DATE.value);
		var START_DATE					= del_Slash(document.forms[0].START_DATE.value);
		var START_TIME_HOUR_MINUTE      = del_Slash(document.forms[0].START_TIME_HOUR_MINUTE.value);
		var END_DATE					= del_Slash(document.forms[0].END_DATE.value);
		var END_TIME_HOUR_MINUTE		= document.forms[0].END_TIME_HOUR_MINUTE.value;
		var PROM_CRIT 					= document.forms[0].PROM_CRIT_TYPE.value;

    	//필수입력사항
    	if(LRTrim(form1.ANN_DATE.value) == "") {
    		alert("공고일자를 입력해야 합니다. ");
    		form1.ANN_DATE.focus();
    		return rtn;
    	}
    	if(LRTrim(form1.SUBJECT.value) == "") {
    		alert("제목을 입력해야 합니다. ");
    		form1.SUBJECT.focus();
    		return rtn;
    	}

    	if(checkDate(form1.START_DATE.value.replaceAll("/", "")) == "") {
    		alert("시작일을 확인하세요. ");
    		form1.START_DATE.focus();
    		form1.START_DATE.select();
    		return rtn;
    	}

    	if(checkDate(form1.END_DATE.value.replaceAll("/", "")) == "") {
    		alert("마감일을 확인하세요. ");
    		form1.END_DATE.focus();
    		form1.END_DATE.select();
    		return rtn;
    	}

//     	alert(eval(ANN_DATE) + " : " + eval(current_date));
    	
        if (eval(ANN_DATE) < eval(current_date)) {
        	alert ("공고일자는 오늘 이거나 오늘보다 이후 날짜이어야 합니다.");
            return false;
        }

        if (eval(START_DATE) < eval(current_date)) {
            alert ("역경매일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
            return false;
        } else if (eval(START_DATE) == eval(current_date)) {
            if (eval(START_TIME_HOUR_MINUTE) < eval(current_time.substring(0,4))) {
                alert ("역경매일시의 시작시간은 현재시간보다 이후여야 합니다.");
                return false;
            }
        }

        if (eval(END_DATE) < eval(current_date)) {
            alert ("역경매일시의 종료일자는 오늘보다 이후 날짜이어야 합니다.");
            return false;
        } else if (eval(END_DATE) == eval(current_date)) {
            if (eval(END_TIME_HOUR_MINUTE) < eval(current_time.substring(0,4))) {
                alert ("역경매일시의 종료시간은 현재시간보다 이후여야 합니다.");
                return false;
            }
        }

        if (eval(START_DATE) > eval(END_DATE)) {
            alert ("역경매일시의 종료일자는 시작일자보다 커야합니다.");
            return false;
        } else if (eval(START_DATE) == eval(END_DATE)) {
            if (eval(START_TIME_HOUR_MINUTE) > eval(END_TIME_HOUR_MINUTE)) {
                alert ("역경매일시의 종료시간은 시작시간보다 커야합니다.");
                return false;
            }
        }

		// 공고일자
		if (eval(START_DATE) < eval(ANN_DATE)) {
			alert ("역경매일시 시작일자는 공고일자보다 이후 날짜이어야 합니다.");
			document.forms[0].START_DATE.focus();
			return false;
		}

        var ls_reserve_price = del_comma(form1.RESERVE_PRICE.value);
        var ls_bid_dec_amt   = del_comma(form1.BID_DEC_AMT.value);

        var curAmt = Number(GridObj.cells(GridObj.getRowId(0), INDEX_AMT).getValue());
        
        if(Number(ls_reserve_price) < curAmt){
        	alert("시작가는 예상금액보다 클 수 없습니다.");
    		form1.RESERVE_PRICE.focus();
    		form1.RESERVE_PRICE.select();
        	return rtn;
        }

    	if(IsNumber1(ls_bid_dec_amt) == "") {
    		alert("투찰단위금액을 확인하세요");
    		form1.BID_DEC_AMT.focus();
    		form1.BID_DEC_AMT.select();
    		return rtn;
    	}
    	if(parseFloat(ls_bid_dec_amt) <= 0 ) {
    		alert("투찰단위금액은 0보다 커야합니다.");
    		form1.BID_DEC_AMT.focus();
    		form1.BID_DEC_AMT.select();
    		return rtn;
    	}

    	//내자일때 입력사항
    	if( "D" == "<%=shipper_type%>" || form1.shipper_type.value == "D") {
    		if(LRTrim(form1.CUR.value) != "KRW") {
    			alert("내자에서는 KRW 만 사용할 수 있습니다.");
        		return rtn;
    		}
    	}

    	//역경매방식이 지명일때 업체선정 필수
    	var ra_type1 = form1.RA_TYPE1.value;
    	if ( ra_type1 == "NC" ) {
    	    var cnt = form1.vendor_count.value;
//     	    alert(cnt);

    	    if ( cnt == "" || cnt == 0 ) {
    		    alert( "업체선정을 해야합니다.");
        		return rtn;
    	    }
    	}
/*
		if(LRTrim(document.form1.RD_DATE.value) != "") {
			if(!checkDateCommon(document.form1.RD_DATE.value)){
				document.forms[0].RD_DATE.select();
				alert("납기일자를 확인하세요.");
				return false;
			}
		}
*/
        // comma 제거값
        if (ls_reserve_price == "") ls_reserve_price = "0";
        form1.RESERVE_PRICE.value = ls_reserve_price;
        form1.BID_DEC_AMT.value   = ls_bid_dec_amt;

		rowcount = GridObj.GetRowCount();

		checked_count = 0;
		var TOT_AMT = 0;

		for(row = rowcount - 1; row >= 0; row--) {
			if(GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED) == true) {

				var DESCRIPTION_LOC = GD_GetCellValueIndex(GridObj,row, INDEX_DESCRIPTION_LOC);
				var UNIT_MEASURE    = GD_GetCellValueIndex(GridObj,row, INDEX_UNIT_MEASURE);
				var QTY             = GD_GetCellValueIndex(GridObj,row, INDEX_QTY);
				var CUR             = GD_GetCellValueIndex(GridObj,row, INDEX_CUR);
				var UNIT_PRICE      = GD_GetCellValueIndex(GridObj,row, INDEX_UNIT_PRICE);
				var AMT             = GD_GetCellValueIndex(GridObj,row, INDEX_AMT);
<%
	if("P".equals(req_type)){
%>
				if (DESCRIPTION_LOC == "") {
					alert("품목명이 입력되지 않았습니다.");
					return false;
				}

				if (UNIT_MEASURE == "") {
					alert("단위가 입력되지 않았습니다.");
					return false;
				}

				if( "KRW" != CUR) {
					alert("통화는 KRW만 가능 합니다.");
					return false;
				}

				if (QTY == "" || QTY == "0") {
					alert("수량이 입력되지 않았습니다.");
					return false;
				}

				if (UNIT_PRICE == "" || UNIT_PRICE == "0") {
					alert("예상단가가 입력되지 않았습니다.");
					return false;
				}
<%
	}
%>
				TOT_AMT += parseFloat(AMT);
				checked_count++;
			}
		}

		if(checked_count == 0) {
			alert("선택된 물품이 없습니다.");
			return false;
		}

        rtn = true;

  		return rtn;
    }

	function Approval(pflag) {       // 저장 = 'T', 결재요청='P', 확정= 'C', S = 결재없이 바로 확정.
		var f = document.form1;
	
		<%-- 날짜 슬래시 제거 --%>
		document.getElementById("ANN_DATE").value = LRTrim(del_Slash(document.getElementById("ANN_DATE").value));
		document.getElementById("START_DATE").value = LRTrim(del_Slash(document.getElementById("START_DATE").value));
		document.getElementById("END_DATE").value = LRTrim(del_Slash(document.getElementById("END_DATE").value));
		document.getElementById("open_req_from_date").value = LRTrim(del_Slash(document.getElementById("open_req_from_date").value));
		document.getElementById("open_req_to_date").value = LRTrim(del_Slash(document.getElementById("open_req_to_date").value));

		G_FLAG = pflag;
		f.SIGN_STATUS.value = pflag;
		if(button_flag == true) {
//            alert("작업이 진행중입니다.");
//            return;
		}

		button_flag = true;

		if (checkData() == false) {
			button_flag = false;
			return;
		}

		var rowcount = GridObj.GetRowCount();

		var checked_count = 0;
		for(row = rowcount - 1; row >= 0; row--) {
			if(GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED) == true) {
				checked_count++;
			}
		}

		var rowcount = GridObj.GetRowCount();

		var checked_count = 0;
		for(row = rowcount - 1; row >= 0; row--) {
			if(GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED) == true) {
				checked_count++;
			}
		}

		var rowcount = GridObj.GetRowCount();
		if(pflag == "T") {
			if(confirm(checked_count+"건의 물품을 선택하셨습니다. \n 역경매를 저장 하시겠습니까?") == 1) {
				mode = "setGonggoCreate";
				getApproval(pflag);
				//button_flag = false;
				//return;
			}
		} else if(pflag == "P") {
			if(confirm(checked_count+"건의 물품을 선택하셨습니다. \n 결재상신 하시겠습니까?") == 1) {
				mode = "setGonggoCreate";
				document.form1.method = "POST";
      			document.form1.target = "childFrame";
      			document.form1.action = "/kr/admin/basic/approval/approval.jsp";
      			document.form1.submit();
				//button_flag = false;
				//return;
			}
		} else if(pflag == "C") {
			if(confirm("역경매를 확정 하시겠습니까?") == 1) {
				//button_flag = false;

				if(document.forms[0].RA_TYPE1.value == "GC"){
					//if(document.forms[0].TWIT.value==""||document.forms[0].TWIT.value==" "){
						//if(!confirm("트위터에 올릴 견적공고를 작성하지 않으셨습니다.\n\n계속 진행하시겠습니까?")){
						//	return ;
						//}
					//}
				}

				mode = "setGonggoConfirm";
				getApproval(pflag);
			}

		}if(pflag == "S") {
			if(confirm(checked_count+"건의 물품을 선택하셨습니다. \n 역경매를 확정 하시겠습니까?") == 1) {
				mode = "setGonggoCreate";
				getApproval(pflag);
				//button_flag = false;
				//return;
			}
		}
	}

	function getApproval(approval_str) {
	  
// 		alert(approval_str);
	  
		var f = document.forms[0];

		if(approval_str == "") {
			alert("결재자를 지정해 주세요");
			return;
   		}

		var RA_NO				= document.forms[0].RA_NO.value;

		// 바로 결재상신상태와 저장후 결재 상태 두가지를 분기한다.
		if(RA_NO != ""){
// 			GridObj.SetParam("ModifyFlag","M");  // 저장 후, 추후에 공고화면에서 수정으로 결재상신
			$("#ModifyFlag").val("M");
		}else{
// 			GridObj.SetParam("ModifyFlag","P");  // 작성후 바로 결재 상신
			$("#ModifyFlag").val("P");
		}
		if(approval_str == "S"){
			$("#ModifyFlag").val("S");
		}

/*
    	var Message = "";
    	if(f.SIGN_STATUS.value == "P") {
      		Message = "결재하시겠습니까?";
    	} else {
      		Message = "저장 하시겠습니까?";
    	}

    	if(!confirm(Message)) return;
*/

		form1.approval_str.value = approval_str;
		
		getApprovalSend(approval_str);

// 		document.attachFrame.setData();	//startUpload
	}//getApproval End

	function getApprovalSend(approval_str) {
    	var f = document.forms[0];

		//servletUrl = "/servlets/dt.rat.rat_bd_ins1"; //p1008

		//Approval 함수에서 mode값 지정
		//mode = "setGonggoCreate";

		GridObj.SetParam("mode", mode);
		
    	var type             = "R";          //R:역경매
    	var msg              = "";

		var RA_NO				= document.forms[0].RA_NO.value;
		var RA_COUNT			= document.forms[0].RA_COUNT.value;
		var ANN_NO				= RA_NO;
		var ANN_DATE			= document.forms[0].ANN_DATE.value;
		var SUBJECT				= document.forms[0].SUBJECT.value;
		var START_DATE			= document.forms[0].START_DATE.value;
		var START_TIME_HOUR_MINUTE = document.forms[0].START_TIME_HOUR_MINUTE.value;
		var END_DATE			= document.forms[0].END_DATE.value;
		var END_TIME_HOUR_MINUTE = document.forms[0].END_TIME_HOUR_MINUTE.value;
		var CUR					= document.forms[0].CUR.value;
		var RESERVE_PRICE		= document.forms[0].RESERVE_PRICE.value;
		var BID_DEC_AMT			= document.forms[0].BID_DEC_AMT.value;
		var LIMIT_CRIT			= document.forms[0].LIMIT_CRIT.value;
		var PROM_CRIT			= document.forms[0].PROM_CRIT.value; // 낙찰자 직접입력
		var PROM_CRIT_TYPE 	    = document.forms[0].PROM_CRIT_TYPE.value; // 낙찰자 콤보박스
		var REMARK				= document.forms[0].REMARK.value;
		var ATTACH_NO			= document.forms[0].attach_no.value;
		var OPEN_REQ_FROM_DATE  = document.forms[0].open_req_from_date.value;
		var OPEN_REQ_TO_DATE    = document.forms[0].open_req_to_date.value;
		var RA_TYPE1			= document.forms[0].RA_TYPE1.value;

		//NC = 지명경쟁    LC = 일반경쟁 ==> GC
		var VENDOR_VALUES = "";
		if(RA_TYPE1 == "NC"){
			VENDOR_VALUES	= document.forms[0].vendor_values.value;
		}

		var LOCATION_VALUES = "";
		if(RA_TYPE1 == "GC"){
			LOCATION_VALUES	= document.forms[0].location_values.value;
		}
		var CTRL_CODE	    = document.forms[0].CTRL_CODE.value;
		var RA_TYPE2		= document.forms[0].RA_TYPE2.value;
    	var CREATE_TYPE	    = document.forms[0].CREATE_TYPE.value;
    	var SHIPPER_TYPE	= document.forms[0].shipper_type.value;
    	var CREATE_FLAG		= document.forms[0].SCR_FLAG.value;      // [I:생성, U:수정, C:확정]
 		var CONT_TYPE_TEXT 	= document.forms[0].CONT_TYPE_TEXT.value;
		var CONT_PLACE      = document.forms[0].CONT_PLACE.value;
		var BID_PAY_TEXT    = document.forms[0].BID_PAY_TEXT.value;
		var BID_CANCEL_TEXT = document.forms[0].BID_CANCEL_TEXT.value;
		var BID_JOIN_TEXT   = document.forms[0].BID_JOIN_TEXT.value;
		var RA_ETC          = document.forms[0].RA_ETC.value;
		var FROM_LOWER_BND  = document.forms[0].FROM_LOWER_BND.value;
		var DELY_PLACE      = document.forms[0].DELY_PLACE.value;
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rat.rat_bd_ins1";
		
    	var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var cols_ids = "<%=grid_col_id%>";
    	var params;
    	params = "?mode=" + mode;
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(servletUrl+params);
    	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);  		
	}

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
		} else if (att_mode == "S") {
			f.method = "POST";
			f.target = "attachFrame";
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    var approval_str = f.approval_str.value;
		    getApprovalSend(approval_str);
		}
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

	function ItemInsert() {
		window.open('rat_pp_ins15.jsp?' ,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=900,height=450,left=0,top=0");
	}

	function  LineDelete() {
		rowcount = GridObj.GetRowCount();
		if(rowcount == 0) {
			alert("삭제할 대상이 없습니다.");
			return;
		}
		if(rowcount > 0) {
			if(confirm("삭제 하시겠습니까?") == 1) {
				for(row=rowcount-1; row>=0; row--) {
					if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
						GridObj.DeleteRow(row);

						changeSumAmt();
					}
				}
			}
		}
	}


	/*
	최저가 : 01  -- 낙찰율 0%   0원까지 낙찰가능 낙찰율을 0로 만들고 readOnly로 상태변경
	하한가 : 02  -- default 80% 시작가에서 낙찰율을 곱한 값의 이하로는 투찰 못함
	*/
	function changeEvent(){
		var value = document.form1.PROM_CRIT_TYPE.value;
		if(value == "01"){
			document.form1.FROM_LOWER_BND.value = 0;
		}else if(value == "02"){
			document.form1.FROM_LOWER_BND.value = 80;
		}
	}

	function check_FROM_LOWER(){
		var value = document.form1.PROM_CRIT_TYPE.value;
		var from_lower = document.form1.FROM_LOWER_BND.value
		if(value == "01"){
			if(from_lower != 0){
				alert("최저가일경우 낙찰율을 변경할 수 없습니다.");
				document.form1.FROM_LOWER_BND.value = 0;
				return;
			}
		}
	}

    function changeSumAmt(){
       var t_amt = 0;
       for (k = 0; k < GridObj.GetRowCount() ; k++){
         t_amt += Number(del_comma(GD_GetCellValueIndex(GridObj, k , GridObj.GetColHDIndex("AMT"))));
       }

	   document.form1.RESERVE_PRICE.value = add_comma(t_amt,"0");
    }
    
    function calculate_pr_amt(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	var PR_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,INDEX_QTY)) *  getCalculEval(GD_GetCellValueIndex(GridObj,row,INDEX_UNIT_PRICE)), 3);
  		
  		GD_SetCellValueIndex(GridObj,row, INDEX_AMT, setAmt(PR_AMT));
    	calculate_pr_tot_amt(wise);
  	}

  /*
    총금액을 계산한다.
    calculate_pr_amt에서 호출한다.
  */
  function calculate_pr_tot_amt(wise)
  {
    var f = document.forms[0];
    var pr_tot_amt = 0;

    for(var i=0;i<GridObj.GetRowCount();i++)
    {
      var pr_amt = getCalculEval(GD_GetCellValueIndex(GridObj,i,INDEX_AMT));
      pr_tot_amt = pr_tot_amt + pr_amt;
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
	
	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name == "PR_NO") {
		
		var prNo   = SepoaGridGetCellValueId( GridObj, rowId, "PR_NO" );
		var prType = SepoaGridGetCellValueId( GridObj, rowId, "PR_TYPE" );
		var page   = null;
		
		if(prType == "I"){
			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		}
		else{
			page = "/kr/dt/pr/pr1_bd_dis1NotI.jsp";
		}
		
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
		
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
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명

    var filter          = /[a-zA-Z-]/;
    var PR_QTY         = GridObj.cells( rowId, GridObj.getColIndexById( "QTY" )        ).getValue();   // 수량 
    var UNIT_PRICE    = GridObj.cells( rowId, GridObj.getColIndexById( "UNIT_PRICE" )   ).getValue();   // 단가 
    var PR_AMT      = GridObj.cells( rowId, GridObj.getColIndexById( "AMT" )   ).getValue();   // 금액
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
    	
        if( header_name == "QTY" || header_name == "UNIT_PRICE" ) {
            PR_AMT  = PR_QTY * UNIT_PRICE;   
            GridObj.cells(rowId, GridObj.getColIndexById( "AMT" )    ).setValue( PR_AMT      );  
            return true;
        }
        
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
        opener.doSelect();
        window.close();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
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
    	//JavaCall("doQuery");
    }
    
    <%-- 날짜 슬래시 추가 --%>
    document.getElementById("ANN_DATE").value = add_Slash(document.getElementById("ANN_DATE").value);
	document.getElementById("START_DATE").value = add_Slash(document.getElementById("START_DATE").value);
	document.getElementById("END_DATE").value = add_Slash(document.getElementById("END_DATE").value);
	document.getElementById("open_req_from_date").value = add_Slash(document.getElementById("open_req_from_date").value);
	document.getElementById("open_req_to_date").value = add_Slash(document.getElementById("open_req_to_date").value);
	    
    GridObj.cells(GridObj.getRowId(0), INDEX_SELECTED).cell.wasChanged = true;
    GridObj.cells(GridObj.getRowId(0), INDEX_SELECTED).setValue("1");
    
    
    var price 	= Number(GridObj.cells(GridObj.getRowId(0), INDEX_UNIT_PRICE).getValue());
    var qty		= Number(GridObj.cells(GridObj.getRowId(0), INDEX_QTY).getValue());
    
    GridObj.cells(GridObj.getRowId(0), INDEX_AMT).setValue(qty*price);
    $("#RESERVE_PRICE").val(add_comma(qty*price, 0));

    return true;
}

function goAttach(attach_no){
	attach_file(attach_no,"TEMP");
}

function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.form1.attach_no.value = attach_key;
	document.form1.attach_no_count.value = attach_count;
	setApprovalButton(attach_count);
}

function setApprovalButton(attach_count){
	try{
		if(attach_count>0){
			document.getElementById("approvalButton1").style.display = "";
			document.getElementById("approvalButton2").style.display = "none";
		}else{
			document.getElementById("approvalButton1").style.display = "none";     
			document.getElementById("approvalButton2").style.display = "";
		}
	}catch(e){
		
	}
}

</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">

<s:header popup="true">
<!--내용시작-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
<!-- 		<td class="cell_title1" width="78%" align="left"> -->
	  	<td height="20" align="left" class="title_page" vAlign="bottom">
	  	역경매 공고
	  	</td>
	</tr>
</table>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<form id="form1" name="form1" >
	<input type="hidden" id="ModifyFlag"        name="ModifyFlag"       value="">
	<input type="hidden" id="RA_NO"         	name="RA_NO"         	value="<%=RA_NO%>">
	<input type="hidden" id="RA_COUNT"      	name="RA_COUNT"      	value="<%=RA_COUNT%>">
	<input type="hidden" id="SCR_FLAG"			name="SCR_FLAG"			value="<%=SCR_FLAG%>">
	<input type="hidden" id="SIGN_STATUS"   	name="SIGN_STATUS"   	value="">
	<input type="hidden" id="PR_NO" 			name="PR_NO" 			value="<%=PR_NO%>">
	<input type="hidden" id="REQ_PR_SEQ" 		name="REQ_PR_SEQ" 		value="<%=REQ_PR_SEQ%>">
	<input type="hidden" id="CREATE_TYPE" 		name="CREATE_TYPE" 		value="<%=CREATE_TYPE%>">
	<input type="hidden" id="shipper_type" 		name="shipper_type" 	value="<%=shipper_type%>">
	<input type="hidden" id="PR_TYPE2" 			name="PR_TYPE2" 		value="<%=PR_TYPE2%>">
	<input type="hidden" id="CTRL_CODE" 		name="CTRL_CODE" 		value="<%=info.getSession("CTRL_CODE").split("&")[0]%>">
	<input type="hidden" id="vendor_values" 	name="vendor_values" 	value="<%=VENDOR_VALUES%>">
	<input type="hidden" id="RA_TYPE2"			name="RA_TYPE2"		> 		<!-- R:자동 -->
	<input type="hidden" id="location_values" 	name="location_values" 	value="<%=LOCATION_VALUES%>">
	<input type="hidden" id="house_code" 		name="house_code" 		value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" id="company_code" 		name="company_code" 	value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" id="dept_code" 		name="dept_code" 		value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" id="req_user_id" 		name="req_user_id" 		value="<%=info.getSession("ID")%>">
	<input type="hidden" id="doc_type" 			name="doc_type" 		value="RA">
	<input type="hidden" id="fnc_name" 			name="fnc_name" 		value="getApproval">
	<input type="hidden" id="CONT_TYPE_TEXT"  	name="CONT_TYPE_TEXT"  	value="">
	<input type="hidden" id="CONT_PLACE" 		name="CONT_PLACE" 		size="90" class="inputsubmit" value="" >
	<input type="hidden" id="BID_PAY_TEXT" 		name="BID_PAY_TEXT" 	size="80" class="inputsubmit" value="" >
	<input type="hidden" id="BID_CANCEL_TEXT" 	name="BID_CANCEL_TEXT" 	size="80" class="inputsubmit" value="" >
	<input type="hidden" id="BID_JOIN_TEXT" 	name="BID_JOIN_TEXT" 	size="80" class="inputsubmit" value="" >
	<input type="hidden" id="RA_FLAG" 			name="RA_FLAG" 			size="80" class="inputsubmit" value="<%=RA_FLAG %>" >

	<input type="hidden" id="attach_gubun"	name="attach_gubun" 	value="body">
<%-- 	<input type="hidden" id="attach_no" 	name="attach_no" 		value="<%=ATTACH_NO%>"> --%>
<!-- 	<input type="hidden" id="attach_count"	name="attach_count" 	value=""> -->
	<input type="hidden" id="att_mode"   	name="att_mode"   		value="">
	<input type="hidden" id="view_type"  	name="view_type"  		value="">
	<input type="hidden" id="file_type"  	name="file_type"  		value="">
	<input type="hidden" id="tmp_att_no" 	name="tmp_att_no" 		value="">
	<input type="hidden" id="approval_str"	name="approval_str" 	value="">
	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td class="data_td">
        		<input type="text" id="ANN_NO" name="ANN_NO" value="<%=ANN_NO%>" class="inputsubmit" readonly>
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고일자</td>
      		<td class="data_td" colspan="2">
      			<s:calendar id="ANN_DATE" default_value="<%=SepoaString.getDateSlashFormat(SepoaString.getDateSlashFormat(ANN_DATE))%>" 	format="%Y/%m/%d"/>
      		</td>
    	</tr>
    	<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매건명</td>
      		<td class="data_td" colspan="4">
        		<input type="text" id="SUBJECT" name="SUBJECT" style="ime-mode:active" value="<%=pr_name.equals("")?SUBJECT.replaceAll("\"", "&quot;"):pr_name%>" size="95" class="input_re" <%=script%> onKeyUp="return chkMaxByte(400, this, '역경매건명');">
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매방법</td>
      		<td class="data_td">
      			<b>
        			<select id="RA_TYPE1" name="RA_TYPE1" class="inputsubmit" onChange="setVisibleVendor()" <%=abled%>>
<%
		String com1 = ListBox(request, "SL0018", HOUSE_CODE + "#" +"M936", "");
		out.println(com1);
%>
        			</select>&nbsp;
      			</b>
      		</td>
	  		<td colspan="3" class="title_td"><span id="h1">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 업체지정
				<a href="javascript:getVendor()" id="h2"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"   id="h3" ></a>
				<input type="text" id="vendor_count" name="vendor_count" size="3" value="<%=VENDOR_CNT%>" readonly  id="h4">
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 역경매일시</td>
      		<td class="data_td" colspan="4">
        		<s:calendar id="START_DATE" default_value="<%=SepoaString.getDateSlashFormat(START_DATE)%>" 	format="%Y/%m/%d"/>일
				<input type="text" id="START_TIME_HOUR_MINUTE" name="START_TIME_HOUR_MINUTE" size="4"  value="<%=START_TIME_HOUR_MINUTE%>" maxlength="4"  class="input_re" id=i6>
				&nbsp;&nbsp;~&nbsp;&nbsp;
				<s:calendar id="END_DATE" default_value="<%=SepoaString.getDateSlashFormat(END_DATE)%>" 	format="%Y/%m/%d"/>
				<input type="text" id="END_TIME_HOUR_MINUTE" name="END_TIME_HOUR_MINUTE" size="4"  value="<%=END_TIME_HOUR_MINUTE%>" maxlength="4"  class="input_re" id=i6>
				ex) 오후3시 21분 --> 1521
			</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 시작가(VAT포함)</td>
      		<td class="data_td">
      			<b>
        			<select id="CUR" name="CUR" class="inputsubmit" disabled=true >
<%
		String listbox9 = ListBox(request, "SL0014", HOUSE_CODE + "#"+"M002", "WON");
		out.println(listbox9);
%>
        			</select>&nbsp;
        			<input type="text" id="RESERVE_PRICE" name="RESERVE_PRICE" size="20" maxlength="20" value="<%=SepoaString.formatNum(Long.parseLong(RESERVE_PRICE))%>" <%=script%> class="inputsubmit_right" onfocus="javascript:setOnFocus(this);" onblur="javascript:setOnBlur(this);" onKeyUp="return chkMaxByte(22, this, '시작가(VAT포함)');" style="text-align: right;">
      			</b>원
      		</td>
      		<td width="15%" class="title_td" colspan="2"><font color="red"><b>※ 시작가는 예상금액보다 높은 금액을 책정하여야 합니다.</b></font></td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
   		<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 참가신청기간</td>
      		<td class="data_td">
        		<s:calendar id="open_req_from_date" default_value="<%=SepoaString.getDateSlashFormat(OPEN_REQ_FROM_DATE)%>" 	format="%Y/%m/%d"/>
        			~
        		<s:calendar id="open_req_to_date" default_value="<%=SepoaString.getDateSlashFormat(OPEN_REQ_TO_DATE)%>" 	format="%Y/%m/%d"/>
      		</td>

      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 투찰단위금액</td>
      		<td class="data_td">
      			<input type="text" size="20" id="BID_DEC_AMT" name="BID_DEC_AMT"  <%=script%> value="<%=SepoaString.formatNum(Long.parseLong(BID_DEC_AMT))%>" class="input_re_right" onfocus="javascript:setOnFocus(this);" onblur="javascript:setOnBlur(this);" onKeyUp="return chkMaxByte(22, this, '투찰단위금액');" style="text-align: right;">원
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰참가자격</td>
      		<td class="data_td" colspan="4">
        		<textarea id="LIMIT_CRIT" name="LIMIT_CRIT" cols="95" class="inputsubmit" rows="3" maxlength="500" <%=script%> onKeyUp="return chkMaxByte(1000, this, '입찰참가자격');"><%=LIMIT_CRIT%></textarea>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
		<tr>
	  		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle" style="text-align: right;">&nbsp;&nbsp; 낙찰하한율</td>
	  		<td class="data_td" colspan="4">
	  			<b>
	  				<input type="text" id="FROM_LOWER_BND" name="FROM_LOWER_BND" size="3" maxlength="2" value="<%=FROM_LOWER_BND%>" <%=script%> onBlur="check_FROM_LOWER()">
					%
	  			</b>
	  		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  		
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 낙찰자선정</td>
      		<td class="data_td" colspan="4">
      			<b>
        			<select id="PROM_CRIT_TYPE" name="PROM_CRIT_TYPE" class="inputsubmit" onChange="changeEvent()" <%=abled%>>
<%
		String com2 = ListBox(request, "SL0018", HOUSE_CODE + "#" +"M937", "");
		out.println(com2);
%>
        			</select>&nbsp;
      			</b>
      			<input type="text" id="PROM_CRIT" name="PROM_CRIT"  value="<%=PROM_CRIT%>" <%=script%> class="inputsubmit" size="74" onKeyUp="return chkMaxByte(100, this, '낙찰자선정비고');" >
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
		<tr>
	  		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 납기장소</td>
	  		<td class="data_td" colspan="4">
				<input type="text" id="DELY_PLACE" name="DELY_PLACE" size="95"   style="ime-mode:active" class="inputsubmit"   value="<%=DELY_PLACE%>"  <%=script%> onKeyUp="return chkMaxByte(300, this, '납기장소');">
	  		</td>
		</tr>
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 기타사항</td>
      		<td class="data_td" colspan="4">
        		<textarea id="REMARK" name="REMARK" cols="95" class="inputsubmit" style="ime-mode:active" rows="10" <%=script%> onKeyUp="return chkMaxByte(4000, this, '기타사항');"><%=REMARK%></textarea>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 보고사항</td>
      		<td class="data_td" colspan="4">
        		<textarea id="RA_ETC" name="RA_ETC" cols="95" class="inputsubmit" style="ime-mode:active" rows="10" <%=script%> onKeyUp="return chkMaxByte(4000, this, '특이사항');"><%=RA_ETC%></textarea>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
		<tr>
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
			<td class="data_td" colspan="4">
				<table>
					<tr>
						<td>
							<script language="javascript">btn("javascript:goAttach($('#attach_no').val())", "파일등록")</script>
						</td>
						<td>
							<input type="text" size="3" readOnly class="input_empty" value="<%=ATTACH_CNT %>" name="attach_no_count" id="attach_no_count"/>
							<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
						</td>
					</tr>
				</table>
			
			</td>
		</tr>      
      
    <%
    	if(SCR_FLAG.equals("C")) {
    %>
    	<tr id="TWIT_YN" style="display:none">
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 트위터 공고<br>(140 BYTE)
				<br><br>
					현재 : <input type="text" name="TWIT_LEN" style="text-align:right" readOnly size="4" /> BYTE
			</td>
			<td class="data_td" colspan="4" height="200">
				<textarea id="TWIT" name="TWIT" style="ime-mode:active" rows="5" cols="95" rows="2" class="inputsubmit" onKeyUp="cal_length(this)"></textarea>
			</td>
		</tr>
	<%
		}
	%>
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
<%
	if(SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
%>
<%-- 							<TD><script language="javascript">btn("javascript:getVendor()","견적업체") </script></TD> --%>
							<td> <script language="javascript">btn("javascript:Approval('T')","임시저장")</script></td>
		 <td id="approvalButton1" style="display: none;"> <script language="javascript">btn("javascript:Approval('P')","결재요청")</script></td>
		 <td id="approvalButton2" > <script language="javascript">btn("javascript:Approval('S')","확 정")</script></td>
<%-- 							<td> <script language="javascript">btn("javascript:Approval('C')","결재요청")</script></td> --%>


<!-- 결재상신 버튼 -->
<!--          <a href="javascript:Approval('P')"><img src="../../images//button/butt_app_req.gif" align="absmiddle" border="0"></a> -->
<%
	}
%>

<%
	if(SCR_FLAG.equals("C")) {
%>
			 				<td> <script language="javascript">btn("javascript:Approval('C')","확 정")</script></td>
<%
	}
%>
<%
	if(SCR_FLAG.equals("D")) {
%>
			  				<td> <script language="javascript">btn("javascript:history.back(-1)","확 인")</script></td>
<%
	}
%>
							<td> <script language="javascript">btn("javascript:window.close()","닫 기")</script></td>

						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<s:grid screen_id="<%=tmp %>" grid_obj="GridObj" grid_box="gridbox"/>

<s:footer/>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</body>
</html>