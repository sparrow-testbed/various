<%--
    Title                            :          rfq_bd_lis2.jsp  <p>
    Description                      :          견적요청 수정 <p>
    Copyright                        :          Copyright (c) <p>
    Company                          :          SEPOASOFT <p>
    @author                          :          WKHONG(2014.09.30)<p>
    @version                         :          1.0
    @Comment                         :          견적요청현황 상세 내용을 수정하는 화면이다.
    @SCREEN_ID                       :          RQ_239
--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_239");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_239";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_239";%>

<%


	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String create_type  = JSPUtil.nullToEmpty(request.getParameter("create_type"));
	String rfq_state    = JSPUtil.nullToEmpty(request.getParameter("rfq_state"));
	String disabled		= Integer.parseInt(rfq_count) > 1 ? "disabled" : "";

	Object[] obj = {rfq_no, rfq_count};
	SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqHDDisplay", obj);
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj);

    String rtn_announce_flag     = "";
	String SUBJECT               = "";
	String RFQ_CLOSE_DATE_VIEW   = "";
	String RFQ_CLOSE_DATE        = "";
	String RFQ_CLOSE_TIME        = "";
	String DELY_TERMS            = "";
	String DELY_TERMS_TEXT       = "";
	String PAY_TERMS             = "";
	String PAY_TERMS_TEXT        = "";
	String CUR                   = "";
	String SETTLE_TYPE           = "";
	String SETTLE_TYPE_TEXT      = "";
	String TERM_CHANGE_FLAG      = "";
	String VALID_FROM_DATE       = "";
	String VALID_TO_DATE         = "";
	String RFQ_TYPE              = "";
	String RFQ_TYPE_TEXT         = "";
	String SPRICE_TYPE            = "";
	String PRICE_TYPE_TEXT       = "";
	String SHIPPING_METHOD       = "";
	String SHIPPING_METHOD_TEXT  = "";
	String USANCE_DAYS           = "";
	String DOM_EXP_FLAG          = "";
	String DOM_EXP_FLAG_TEXT     = "";
	String ARRIVAL_PORT          = "";
	String ARRIVAL_PORT_NAME     = "";
	String SHIPPER_TYPE          = "";
	String SHIPPER_TYPE_TEXT     = "";
	String REMARK                = "";
	String RQAN_CNT              = "";
	String SMS_YN                = "";
	String BID_REQ_TYPE			 = "";
	String CREATE_TYPE			 = "";
	String CTRL_CODE			 = "";
	String ADD_USER_ID			 = "";
	String HATTACH_NO			 = "";
	String HATTACH_NO_CNT			 = "";
	String PR_TYPE				 = "";
	String REQ_TYPE				 = "";
	String PC_REASON			 = "";

	SepoaFormater wf = new SepoaFormater(value.result[0]);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이?린? 있는 경우

			SUBJECT                  =  wf.getValue("SUBJECT             ", 0);
			RFQ_CLOSE_DATE_VIEW      =  wf.getValue("RFQ_CLOSE_DATE_VIEW ", 0);
			RFQ_CLOSE_DATE           =  wf.getValue("RFQ_CLOSE_DATE      ", 0);
			RFQ_CLOSE_TIME           =  wf.getValue("RFQ_CLOSE_TIME      ", 0);
			DELY_TERMS               =  wf.getValue("DELY_TERMS          ", 0);
			DELY_TERMS_TEXT          =  wf.getValue("DELY_TERMS_TEXT     ", 0);
			PAY_TERMS                =  wf.getValue("PAY_TERMS           ", 0);
			PAY_TERMS_TEXT           =  wf.getValue("PAY_TERMS_TEXT      ", 0);
			CUR                      =  wf.getValue("CUR                 ", 0);
			SETTLE_TYPE              =  wf.getValue("SETTLE_TYPE         ", 0);
			SETTLE_TYPE_TEXT         =  wf.getValue("SETTLE_TYPE_TEXT    ", 0);
			TERM_CHANGE_FLAG         =  wf.getValue("TERM_CHANGE_FLAG    ", 0);
			VALID_FROM_DATE          =  wf.getValue("VALID_FROM_DATE     ", 0);
			VALID_TO_DATE            =  wf.getValue("VALID_TO_DATE       ", 0);
			RFQ_TYPE                 =  wf.getValue("RFQ_TYPE            ", 0);
			RFQ_TYPE_TEXT            =  wf.getValue("RFQ_TYPE_TEXT       ", 0);
			SPRICE_TYPE               =  wf.getValue("PRICE_TYPE          ", 0);
			PRICE_TYPE_TEXT          =  wf.getValue("PRICE_TYPE_TEXT     ", 0);
			SHIPPING_METHOD          =  wf.getValue("SHIPPING_METHOD     ", 0);
			SHIPPING_METHOD_TEXT     =  wf.getValue("SHIPPING_METHOD_TEXT", 0);
			USANCE_DAYS              =  wf.getValue("USANCE_DAYS         ", 0);
			DOM_EXP_FLAG             =  wf.getValue("DOM_EXP_FLAG        ", 0);
			DOM_EXP_FLAG_TEXT        =  wf.getValue("DOM_EXP_FLAG_TEXT   ", 0);
			ARRIVAL_PORT             =  wf.getValue("ARRIVAL_PORT        ", 0);
			ARRIVAL_PORT_NAME        =  wf.getValue("ARRIVAL_PORT_NAME   ", 0);
			SHIPPER_TYPE             =  wf.getValue("SHIPPER_TYPE        ", 0);
			SHIPPER_TYPE_TEXT        =  wf.getValue("SHIPPER_TYPE_TEXT   ", 0);
			REMARK                   =  wf.getValue("REMARK              ", 0);
			RQAN_CNT                 =  wf.getValue("RQAN_CNT            ", 0);
			SMS_YN					 =  wf.getValue("Z_SMS_SEND_FLAG", 0);
			BID_REQ_TYPE			 =  wf.getValue("BID_REQ_TYPE", 0);
			CREATE_TYPE			 	 =  wf.getValue("CREATE_TYPE", 0);
			CTRL_CODE			 	 =  wf.getValue("CTRL_CODE", 0);
			ADD_USER_ID			 	 =  wf.getValue("ADD_USER_ID", 0);
			HATTACH_NO			 	 =  wf.getValue("ATTACH_NO", 0);
			HATTACH_NO_CNT			 =  wf.getValue("ATTACH_NO_CNT", 0);
			PR_TYPE					 =  wf.getValue("PR_TYPE", 0);
			REQ_TYPE			 	 =  wf.getValue("REQ_TYPE", 0);
			PC_REASON                =  wf.getValue("PC_REASON", 0);
		}
	}

    if(RQAN_CNT.equals("0")) {
        rtn_announce_flag = "N";
    } else {
        rtn_announce_flag = "Y";
    }
	String rfq_close_hour      = RFQ_CLOSE_TIME != null && RFQ_CLOSE_TIME.length() >= 2 ? RFQ_CLOSE_TIME.substring(0,2) : "";
	String rfq_close_min       = RFQ_CLOSE_TIME != null && RFQ_CLOSE_TIME.length() >= 3 ? RFQ_CLOSE_TIME.substring(2,4) : "";

	String sl_pay_terms = "SL0002"; // 내자지급조건
	if (SHIPPER_TYPE.equals("O")) {
		sl_pay_terms 	= "SL0005"; // 외자지급조건
	}
	String pay_terms 	= ListBox(request, sl_pay_terms,  HOUSE_CODE+"#", PAY_TERMS);
	
	String sl_dely_terms = "SL0018"; // 내자인도조건
	if (SHIPPER_TYPE.equals("O")) {
		sl_dely_terms 	= "SL0018"; // 외자인도조건
	}
	String dely_terms 	= ListBox(request, sl_dely_terms,  HOUSE_CODE+"#M009", DELY_TERMS);
	
	int wf2_cnt = wf2.getRowCount();
%>

<%
	/**
	 * 전자결재 사용여부
	 */
	Config signConf = new Configuration();
	String sign_use_module = "";// 전자결재 사용모듈
	String pc_reasonDisable = "";
	boolean sign_use_yn = false;
	try {
		sign_use_module = CommonUtil.getConfig("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
// 		sign_use_module = CommonUtil.getConfig("wise.all_admin.profile_code."+info.getSession("HOUSE_CODE"));
	} catch(Exception e) {
		
		out.println("에러 발생:" + e.getMessage() + "<br>");
		
		sign_use_module	= "";
	}
// 	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	
	//wise.sign.use.module sign_module 값에 따라 전자결재 사용여부 수정.
	String sign_module = "";
// 	while (st.hasMoreTokens()) {
// 		sign_module = st.nextToken();
// 		if (create_type.equals("MA")) {
// 			if (sign_module.equals("MRQ")) {
// 				sign_use_yn = true;
// 			}
// 		} else {
// 			if (sign_module.equals("RQ")) {
// 				sign_use_yn = true;
// 			}
// 		}
// 	}

	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	String tmp = "";
	while (st.hasMoreTokens()) {
		if ("RFQ".equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
	
	System.out.println("sign_use_yn : " + sign_use_yn);
	
	if(!RFQ_TYPE.equals("PC")){
		pc_reasonDisable = "disable";
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<script language="javascript">
//<!--
	var mode;
	var load = "first";

	var deletedata = "";
	var rfq_flag;

	var Current_Row;

    var INDEX_SELECTED               ;
    var INDEX_ITEM_NO                ;
    var INDEX_DESCRIPTION_LOC        ;
    var INDEX_SPECIFICATION          ;
    var INDEX_RFQ_QTY                ;
    var INDEX_YEAR_QTY               ;
    var INDEX_UNIT_MEASURE           ;
    var INDEX_PURCHASE_PRE_PRICE     ;
    var INDEX_RFQ_AMT                ;
    var INDEX_RD_DATE                ;
    var INDEX_ATTACH_NO              ;
    var INDEX_ATTACH_NO_CNT          ;
    var INDEX_VENDOR_SELECTED        ;
    var INDEX_PRICE_DOC              ;
    var INDEX_PLANT_CODE             ;
    var INDEX_CHANGE_USER_NAME       ;
    var INDEX_PR_NO                  ;
    var INDEX_PR_SEQ                 ;
    var INDEX_VENDOR_SELECTED_REASON ;
    var INDEX_COST_COUNT             ;
    var INDEX_VENDOR_CNT             ;
    var INDEX_DELY_TO_ADDRESS        ;
    var INDEX_PURCHASE_LOCATION      ;

    var INDEX_RFQ_SEQ                ;
    var INDEX_MODE                   ;
    var INDEX_DELY_TO_LOCATION       ;
    var INDEX_STR_FLAG               ;
	var INDEX_INPUT_FROM_DATE    	;
	var INDEX_INPUT_TO_DATE  	 	;
	var pc_flag						;

	var GB_CTRL_CODE = "";

	window.onload = function(){
		if(document.forms[0].rfq_type.value == "OP"){
			setShowTwit(document.forms[0].rfq_type);
		}
	}

	function Init() {	//화면 초기설정 
		setApprovalButton(<%=HATTACH_NO_CNT%>);
		setGridDraw();
		setHeader();
		doSelect();
	}	
	
	
function setHeader() {


	<%if(BID_REQ_TYPE.equals("I")){%>


//    GridObj.AddHeader("HUMAN_NO"              ,"HUMAN_NO"         ,"t_text"      ,200  ,0   ,false);
//    GridObj.AddHeader("HUMAN_VENDOR_CODE"     ,"소속업체코드"      ,"t_text"      ,50   ,0   ,false);
//    GridObj.AddHeader("HUMAN_VENDOR_NAME"     ,"소속회사"          ,"t_text"      ,50   ,0   ,false);

	<%}else{
		if(wf2_cnt > 0 ) {
	%>

	<%}else{%>

	<%} }%>

//    GridObj.AddHeader("GISUL_RFQ"             ,"기술견적내역"      ,"t_imagetext" ,10   ,0   ,false);
//    GridObj.AddHeader("Z_CODE1"               ,"프로젝트"          ,"t_text"      ,100  ,0   ,false);
//    GridObj.AddHeader("DELY_TO_LOCATION_NAME" ,"납품요청장소"      ,"t_text"      ,100  ,0   ,false);
//    GridObj.AddHeader("SG_REFITEM"            ,"SG_REFITEM"        ,"t_text"      ,20   ,0   ,false);
	



/* 
	GridObj.SetColCellSortEnable( "DESCRIPTION_LOC"		,false			);
	GridObj.SetColCellSortEnable( "SPECIFICATION"			,false			);
	GridObj.SetNumberFormat(      "RFQ_QTY"				,G_format_qty);
	GridObj.SetNumberFormat(      "YEAR_QTY"				,G_format_qty	);
	GridObj.SetColCellSortEnable( "UNIT_MEASURE"			,false			);
	GridObj.SetNumberFormat(      "PURCHASE_PRE_PRICE"	,G_format_unit	);
	GridObj.SetColCellSortEnable( "PURCHASE_PRE_PRICE"	,false			);
	GridObj.SetNumberFormat(      "RFQ_AMT"				,G_format_qty	);
	GridObj.SetColCellSortEnable( "RFQ_AMT"				,false			);
	GridObj.SetColCellSortEnable( "RD_DATE"				,false			);
	GridObj.SetColCellSortEnable( "PLANT_CODE"			,false			);
//	GridObj.SetColCellSortEnable( "DELY_TO_LOCATION_NAME"	,false			);
//	GridObj.SetColCellSortEnable( "Z_CODE1"				,false			);
	GridObj.SetColCellSortEnable( "CHANGE_USER_NAME"		,false			);
	GridObj.SetColCellSortEnable( "PR_NO"					,false			);
	GridObj.SetColCellSortEnable( "PR_SEQ"				,false			);
	GridObj.SetColCellSortEnable( "VENDOR_SELECTED_REASON",false			);
	GridObj.SetColCellSortEnable( "COST_COUNT"			,false			);
	GridObj.SetColCellSortEnable( "VENDOR_CNT"			,false			);
	GridObj.SetColCellSortEnable( "DELY_TO_ADDRESS"		,false			);
	GridObj.SetColCellSortEnable( "DELY_TO_LOCATION"		,false			);
	GridObj.SetColCellSortEnable( "STR_FLAG"				,false			);
	GridObj.SetColCellSortEnable( "PURCHASE_LOCATION"		,false			);
	GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
	GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd");
 */

	if(document.form1.shipper_type.value == "O"){
//		GridObj.SetColHide("EXCHANGE_RATE", false);
//    	GridObj.SetColHide("RFQ_KRW_AMT", false);
    }else{
//		GridObj.SetColHide("EXCHANGE_RATE", true);
//		GridObj.SetColHide("RFQ_KRW_AMT", true);
	}
	<% if(BID_REQ_TYPE.equals("S") && (wf2_cnt > 0) ) {%>
		GridObj.SetColHide("VENDOR_SELECTED", true);
	<%}%>


        INDEX_SELECTED                 	= GridObj.GetColHDIndex("SELECTED");
        INDEX_ITEM_NO                  	= GridObj.GetColHDIndex("ITEM_NO");
        INDEX_DESCRIPTION_LOC          	= GridObj.GetColHDIndex("DESCRIPTION_LOC");
        INDEX_SPECIFICATION            	= GridObj.GetColHDIndex("SPECIFICATION");
        INDEX_RFQ_QTY                  	= GridObj.GetColHDIndex("RFQ_QTY");

        INDEX_YEAR_QTY                 	= GridObj.GetColHDIndex("YEAR_QTY");
        INDEX_UNIT_MEASURE             	= GridObj.GetColHDIndex("UNIT_MEASURE");
        INDEX_PURCHASE_PRE_PRICE       	= GridObj.GetColHDIndex("PURCHASE_PRE_PRICE");
        INDEX_RFQ_AMT                  	= GridObj.GetColHDIndex("RFQ_AMT");
        INDEX_RD_DATE                  	= GridObj.GetColHDIndex("RD_DATE");

        INDEX_ATTACH_NO                	= GridObj.GetColHDIndex("ATTACH_NO");
        INDEX_ATTACH_NO_CNT           	= GridObj.GetColHDIndex("ATTACH_NO_CNT");
        INDEX_VENDOR_SELECTED          	= GridObj.GetColHDIndex("VENDOR_SELECTED");
        INDEX_PRICE_DOC                	= GridObj.GetColHDIndex("PRICE_DOC");
        INDEX_PLANT_CODE               	= GridObj.GetColHDIndex("PLANT_CODE");

        INDEX_CHANGE_USER_NAME         	= GridObj.GetColHDIndex("CHANGE_USER_NAME");
        INDEX_PR_NO                    	= GridObj.GetColHDIndex("PR_NO");
        INDEX_PR_SEQ                   	= GridObj.GetColHDIndex("PR_SEQ");
        INDEX_VENDOR_SELECTED_REASON   	= GridObj.GetColHDIndex("VENDOR_SELECTED_REASON");
        INDEX_COST_COUNT               	= GridObj.GetColHDIndex("COST_COUNT");

        INDEX_VENDOR_CNT               	= GridObj.GetColHDIndex("VENDOR_CNT");
        INDEX_DELY_TO_ADDRESS          	= GridObj.GetColHDIndex("DELY_TO_ADDRESS");
        INDEX_PURCHASE_LOCATION			= GridObj.GetColHDIndex("PURCHASE_LOCATION");
        INDEX_RFQ_SEQ					= GridObj.GetColHDIndex("RFQ_SEQ");
        INDEX_MODE						= GridObj.GetColHDIndex("MODE");

        INDEX_DELY_TO_LOCATION			= GridObj.GetColHDIndex("DELY_TO_LOCATION");
        INDEX_STR_FLAG					= GridObj.GetColHDIndex("STR_FLAG");
		INDEX_INPUT_FROM_DATE			= GridObj.GetColHDIndex("INPUT_FROM_DATE"	);
		INDEX_INPUT_TO_DATE				= GridObj.GetColHDIndex("INPUT_TO_DATE"	);

		init_two();
		//doSelect();
	}

	function init_two() {

		rfq_close_hour = "<%=rfq_close_hour%>";
		for(i=0; i<form1.rfq_close_time.length; i++) {
			if(form1.rfq_close_time.options[i].value == rfq_close_hour)
			{
				form1.rfq_close_time.options[i].selected = true;
			}
		}

		settle_type = "<%=SETTLE_TYPE%>";
		for(i=0; i<form1.settle_type.length; i++) {
			if(form1.settle_type.options[i].value == settle_type) {
				form1.settle_type.options[i].selected = true;
			}
		}

	}
	
	function reason(obj){
		if(obj.value != "PC"){ // 수의계약이 아닐 경우
			document.forms[0].pc_reason.value = "";
		 	document.forms[0].pc_reason.disabled = true;
		}else{
			document.forms[0].pc_reason.value = pc_reason;
			document.forms[0].pc_reason.disabled = false;
		}
	}

	function doSelect() {
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_ins2";

		<%-- GridObj.SetParam("mode", "getRfqDTDisplay");
		GridObj.SetParam("rfq_no", "<%=rfq_no%>");
		GridObj.SetParam("rfq_count", "<%=rfq_count%>");

		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);  --%>
		
		var grid_col_id = "<%=grid_col_id%>";
		var params   = "mode=getRfqDTDisplay";
		params += "&grid_col_id=" + grid_col_id;
		params += dataOutput();
		GridObj.post(servletUrl, params);
		GridObj.clearAll(false);
	}

	function jf_rfq_close_date(year,month,day,week) {
		document.form1.rfq_close_date.value=year+month+day;
	}

	function announce_click() {

		cnt = GridObj.GetRowCount();
		if(form1.announce_flag.value == "Y" ) // 내용이 있습니다.-- 수정...(MODE = "M")
		{
			if(cnt > 0) window.open('rfq_pp_ins1.jsp?mode=M&rfq_no=' + form1.rfq_no.value + '&rfq_count=' + form1.rfq_count.value ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
		}
		else if(form1.announce_flag.value == "N" ) // 내용이 없습니다. -- 입력 (MODE = "I")
		{
			Message = "제안설명회 내용이 없습니다.\n입력하시겠습니까 ?";
			if(confirm(Message) == 1) {
				szurl = 'rfq_pp_ins1.jsp?mode=I&subject=' + form1.subject.value + '&rfq_no=' + form1.rfq_no.value + '&rfq_count=' + form1.rfq_count.value + '&cnt=' + cnt;
				if(cnt > 0) window.open(szurl,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
			}
		}
		else if(form1.announce_flag.value == "S" ) // 수정된 내용이 있습니다.. -- 입력후 수정 (MODE = "IM")
		{
			szurl  = 'rfq_pp_ins1.jsp?mode=IM&RFQ_NO='+ form1.rfq_no.value;
			szurl += '&SUBJECT=' + form1.subject_hidden.value;
			szurl += '&RFQ_COUNT=' + form1.rfq_count.value;
			szurl += '&SZDATE=' + form1.szdate.value;
			szurl += '&START_TIME=' + form1.start_time.value;
			szurl += '&END_TIME=' + form1.end_time.value;
			szurl += '&HOST=' + form1.host.value;
			szurl += '&AREA=' + form1.area.value;
			szurl += '&PLACE=' + form1.place.value;
			szurl += '&notifier=' + form1.notifier.value;
			szurl += '&doc_frw_date=' + form1.doc_frw_date.value;
			szurl += '&resp=' + form1.resp.value;
			szurl += '&comment=' + form1.comment.value;

			if(cnt > 0) window.open(szurl,"doExplanationIM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");

		}
	}

	function setExplanation(rfq_no, subject, rfq_count, szdate, start_time,
                            end_time, host, area, place, notifier,
                            doc_frw_date, resp, comment)
	{
		form1.subject_hidden.value   = subject;
		form1.szdate.value           = szdate;
		form1.start_time.value       = start_time;
		form1.end_time.value         = end_time;
		form1.host.value             = host;

		form1.area.value             = area;
		form1.place.value            = place;
		form1.notifier.value         = notifier;
		form1.doc_frw_date.value     = doc_frw_date;
		form1.resp.value             = resp;

		form1.comment.value          = comment;
		form1.announce_flag.value    = "S";
	}

	//원가내역서
	function getPriceDoc(row) {
		eprow = row;

		var rfq_no = "<%=rfq_no%>";
		var rfq_count = "<%=rfq_count%>" ;
		var rfq_seq = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_SEQ);
		var value   = GD_GetCellValueIndex(GridObj,row, INDEX_PRICE_DOC);

		window.open('rfq_pp_ins5.jsp?rfq_no='+ rfq_no + '&rfq_count='+rfq_count+'&rfq_seq='+rfq_seq+'&value='+value ,"windowopen5","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=500,height=380,left=0,top=0");
	}

	function setep(recvdata,cnt) {
		GD_SetCellValueIndex(GridObj,eprow, INDEX_PRICE_DOC, G_IMG_ICON + "&"+cnt+"&"+recvdata, "&");
		GD_SetCellValueIndex(GridObj,eprow, INDEX_COST_COUNT, cnt);
	}

/* 	function setAttach(attach_key, arrAttrach, attach_count) {
		if(document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		}else{
			var f = document.forms[0];
		    f.attach_no.value = attach_key;
		    f.attach_count.value = attach_count;
		}
		document.form1.attach_gubun.value="body";
	} */

	function JavaCall(msg1, msg2, msg3, msg4, msg5)	{
		if(msg1 == "doQuery") {
				 //form1.attach_count.value = "<%=HATTACH_NO_CNT%>";
				 pc_reason=form1.pc_reason.value;
				 pc_flag = form1.rfq_type.value;
				 if(pc_flag=="PC"){
					 for(var i = 0 ; i < form1.rfq_type.length ; i++){
							if(form1.rfq_type.options[i].value == 'PC'){
								form1.rfq_type.options[i].selected = true ;
							}
					 }
						form1.pc_reason.value = pc_reason;
						form1.pc_reason.disabled = false;
				}
			selectAll();		 
		}
		if(msg1 == "t_imagetext") {
		/*
			if(msg3 == INDEX_VENDOR_SELECTED) { //업체선택

				if(GridObj.GetRowCount() == 0) return;
					if(form1.rfq_type.value == "OP") {
						alert("공개견적에선 업체를 선정할 수 없습니다.");
						return;
				}

			    var settleType = form1.settle_type.value;
			    if(settleType == "DOC"){   //견적건별이라면 모든품목에 대해 동일한 업체가 선택되어야 한다.
			        vendor_Select();
			    }else{
			    	
				    INDEX_mode = GD_GetCellValueIndex(GridObj,msg2, INDEX_MODE);
                    if (INDEX_mode == "N") {
    				    doBuyerSelect_popup(msg2, "S");
    				} else {
    				    doBuyerSelect_popup(msg2, "I");
    				}
    				
    				INDEX_mode = GD_GetCellValueIndex(GridObj,msg2, INDEX_MODE);
                    if (INDEX_mode == "N") {
    				    openPopup(msg2, "S", "");
    				} else {
    				    openPopup(msg2, "I", "");
    				}


			    }
			} else if(msg3 == INDEX_PRICE_DOC) { // 원가내역서
				if(form1.rfq_type.value == "OP") {
					alert("공개견적에서는 원가내역을 입력할 수 없습니다.");
					return;
				}

				getPriceDoc(msg2);
			} else if(msg3 == INDEX_ITEM_NO) { //품목
				var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);

				POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
			} else if(msg3 == INDEX_ATTACH_NO) {
				var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
				Arow = msg2;
				document.form1.attach_gubun.value = "wise";


				if("" == ATTACH_NO_VALUE || "N" == ATTACH_NO_VALUE) {
					FileAttach('RFQ','','');
				} else {
					FileAttachChange('RFQ', ATTACH_NO_VALUE);
				}

				rMateFileAttach('P','C','RFQ',ATTACH_NO_VALUE);
			} */
		}
		if(msg1 == "t_insert") { // 전송/저장시 Row삭제
			if(msg3 == INDEX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
				var  rfq_close_date_val = del_Slash(form1.rfq_close_date.value);
				if(rfq_close_date_val == "") {
					alert("견적마감일을 먼저 입력하세요");
					return;
				}
				if(se_rd_date <= rfq_close_date_val ) {
					alert("납기요청일은 견적마감일 이후여야 합니다.");
					GD_SetCellValueIndex(GridObj,msg2, INDEX_RD_DATE, msg4);
				}
			}
            if(msg3 == INDEX_PURCHASE_PRE_PRICE || msg3 == INDEX_RFQ_QTY) {

                for(var x=0; x<GridObj.GetRowCount(); x++) {
                    var tmp_amt = GD_GetCellValueIndex(GridObj,x, INDEX_PURCHASE_PRE_PRICE);
                    var tmp_qty = GD_GetCellValueIndex(GridObj,x, INDEX_RFQ_QTY);

                    if(isNull(tmp_amt)) tmp_amt = 0;
                    if(isNull(tmp_qty)) tmp_qty = 0;
                    GD_SetCellValueIndex(GridObj,x, INDEX_RFQ_AMT, fixed_number( (eval(tmp_amt) * eval(tmp_qty)) + '' ));
                }
            }
		}
		if(msg1 == "t_header") {
			if(msg3 == INDEX_RD_DATE) {
                copyCell(SepoaTable, INDEX_RD_DATE, "t_date");
			}
		}
		if(msg1 == "doData") { //
			//if(mode == "setRfqChange") {

				/*
					------------ 트위터 글등록 시작 ------------
					일반경쟁이고 전송일 경우에만!
				*/
				/*
				if(document.forms[0].rfq_flag.value=="P" && document.forms[0].rfq_type.value == "OP"){
					if(document.forms[0].TWIT.value!="" && document.forms[0].TWIT.value !=" "){
						var rmsg = setTwit(document.forms[0].TWIT.value);
    					if(rmsg.indexOf("Y")==-1){
	    					alert("트위터 작성 시 오류가 발생했습니다.\n\n트위터 등록 관련사항은  시스템 담당자를 통해 확인 하시 기 바랍니다.\n\n오류메세지["+rmsg+"]");
    					}
    				}
    			}
				/* ------------ 트위터 글등록 종료 ------------ */

				//alert(GD_GetParam(GridObj,"0"));

				//if("1" == GridObj.GetStatus()) {
					opener.doSelect();
					window.close();
				//}

			//}else if(mode == "setRfqItemDelete"){
				//alert(GD_GetParam(GridObj,"0"));

				//if("1" == GridObj.GetStatus()) {
					//opener.doSelect();
					//window.close();
				//}
			//}
		}
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

	function checkData() {
		rowcount = GridObj.GetRowCount();
		checked_count = 0;
		return true;
	}

	function doSave(rfq_flag) {
	    form1.rfq_flag.value = rfq_flag;

		if(GridObj.GetRowCount() == 0){
			alert("품목을 모두 삭제하셨습니다.");
			return;
		}

		if( LRTrim(form1.subject.value) == "") {
			alert("견적명을 입력하셔야 합니다. ");
			return;
		}
		if(LRTrim(form1.rfq_close_date.value) == "") {
			alert("견적마감일을 입력하셔야 합니다. ");
			return;
		}
		if(LRTrim(form1.DELY_TERMS.value) == "") {
			alert("인도조건을 선택하셔야 합니다. ");
			return;
		}
		if(LRTrim(form1.PAY_TERMS.value) == "") {
			alert("결제조건을 선택하셔야 합니다. ");
			return;
		}

		//if(LRTrim(form1.VALID_FROM_DATE.value) == "") {
		//    alert("단가시작일이 유효하지 않습니다.");
		//    return;
		//}
		//if(LRTrim(form1.VALID_TO_DATE.value) == "") {
		//    alert("단가종료일이 유효하지 않습니다.");
		//    return;
		//}

		var TIME = <%=SepoaDate.getShortTimeString().substring(0,4)%>;
		var HOUR = <%=SepoaDate.getShortTimeString().substring(0,2)%>;

		if(eval(LRTrim(del_Slash(form1.rfq_close_date.value))) < eval("<%=SepoaDate.getShortDateString()%>")) {
			alert("견적마감일이 유효하지 않습니다. ");
			return;
		}

		if(eval(LRTrim(del_Slash(form1.rfq_close_date.value))) == eval("<%=SepoaDate.getShortDateString()%>")) {
			if(HOUR < '10')// patch 판
			HOUR = "0"+HOUR.toString();// patch 판
			if(eval(LRTrim(form1.rfq_close_time.value)) < eval(HOUR)) {
				alert("견적마감일이 유효하지 않습니다. ");
				return;
			}

			if(!IsNumber(IsTrimStr(form1.szMin.value)) || IsTrimStr(form1.szMin.value).length != 2) {
				alert("견적마감일이 유효하지 않습니다. ");
				form1.szMin.select();
				return;
			}

			if(parseInt(form1.szMin.value) > 59) {
				alert("견적마감일이 유효하지 않습니다. ");
				form1.szMin.select();
				return;
			}
		}

		if(!IsNumber(IsTrimStr(form1.szMin.value)) || IsTrimStr(form1.szMin.value).length != 2) {
			alert("견적마감일이 유효하지 않습니다. ");
			form1.szMin.select();
			return;
		}

		if(eval(form1.szMin.value) > 59) {
			alert("견적마감일이 유효하지 않습니다. ");
			form1.szMin.select();
			return;
		}

		if( form1.announce_flag.value == "S") //사양설명회를 입력한경우
		{
			if(eval(del_Slash(form1.rfq_close_date.value)) <= eval(form1.szdate.value)) {
				alert("제안설명회의 개최일은 견적마감일 이전이어야 합니다.");
				return;
			}

			var today = "<%=SepoaDate.getShortDateString()%>";

	   		if(eval(form1.szdate.value) < eval(today)) {
				alert("개최일은 오늘날짜 이후여야 합니다.");
				return;
			}
			/*
			if(form1.doc_frw_date.value == "") {
				alert("문서발송일을 반드시 입력하셔야 합니다.");
				return;
			}
	   		if(eval(form1.szdate.value) < eval(form1.doc_frw_date.value)) {
				alert("문서발송일은 개최일자 보다 이전이거나 같은 날이어야 합니다.");
				return;
			}
			*/
		}

		checked_count = 0;
		var totUnitAmt = 0;
		var tempVendor = "";
		
		var rfq_close_date = "";
		var index_rd_date = "";
		
		for(row=GridObj.GetRowCount()-1; row>=0; row--)
		{
			rqf_close_date = LRTrim(del_Slash(form1.rfq_close_date.value));
			index_rd_date  = GD_GetCellValueIndex(GridObj,row, INDEX_RD_DATE).replace(/\//gi,"").replace(/-/gi,"");
			if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED))
			{
				checked_count++;

				<%if(PR_TYPE.equals("I")){%>
				if("" == index_rd_date){
					alert("납기일자는 반드시 존재하여야 합니다..");
					return;
				}
				if(rqf_close_date >= index_rd_date){
					alert("납기일자는 반드시 견적마감일 이후여야 합니다.");
					return;
				}
				<%}%>
				if(form1.rfq_type.value != "OP")
				{
					/* if(0 == parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_SELECTED),row))) {
						alert("업체선정을 반드시 해야합니다.");
						return;
					} */
					if("" == GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED)){
						alert("업체선정을 반드시 해야합니다.");
						
						return;
					}

					//견적건별일 경우 견적대상업체가 모두 동일해야 함
    				if( form1.settle_type.value == "DOC" ){
    				    if( checked_count == 1 ){
    				        tempVendor = GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
    				    }else if( checked_count > 1 ){
    				        tempVendor2 = GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
    				        if( tempVendor != tempVendor2 ){
    				            alert("견적건별일 경우 견적대상업체가 모두 동일해야 합니다.");
    				            return;
    				        }
    				    }
    				}
				}

				rfqQty = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_QTY);
				if(rfqQty == "")
				{
					alert("견적요청수량이 입력되지 않았습니다");
					return;
				}

<%
	if (REQ_TYPE.equals("P")) { // 구매요청시 ( --> 사전지원인 경우는 수량 0 허용)
%>
				var irfqQty = eval(rfqQty);
				if(irfqQty <= 0)
				{
					alert("견적요청수량이 0이거나 적습니다");
					return;
				}
<%
	}
%>
				rfqAmt = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_AMT);

				totUnitAmt += eval(rfqAmt);
			}
		}

		Message = "";

		 if(checked_count == 0)  {
			//GridObj.SetParam("i_onlyheader", "Y");// Header만 전송
			$('#i_onlyheader').val('Y');
			Message = "품목사항 수정없이 ";
			if(rfq_flag == "P") Message += "결재요청 하시겠습니까?";
			if(rfq_flag == "T") Message += "임시저장 하시겠습니까?";
			if(rfq_flag == "E") Message += "업체전송 하시겠습니까?";
		} else { 
			$('#i_onlyheader').val('N');
			//GridObj.SetParam("i_onlyheader", "N");
			Message = "수정사항을 ";
			if(rfq_flag == "P") Message += "결재요청 하시겠습니까?";
			if(rfq_flag == "T") Message += "임시저장 하시겠습니까?";
			if(rfq_flag == "E") Message += "업체전송 하시겠습니까?";
		}

		/*
		if(rfq_flag=="P"){
			if(document.forms[0].rfq_type.value == "OP"){
				if(document.forms[0].TWIT.value==""||document.forms[0].TWIT.value==" "){
					if(!confirm("트위터에 올릴 견적공고를 작성하지 않으셨습니다.\n\n계속 진행하시겠습니까?")){
						return ;
					}
				}
			}
		}
		*/
		Approval(rfq_flag);
	}

	function Approval(sign_status) { // 결재요청='P'
		if (checkData() == false) return;
	
		document.forms[0].rfq_close_date.value = del_Slash(document.forms[0].rfq_close_date.value);
	
		if (sign_status == "P") {
            document.forms[0].target = "childframe";
            document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
            document.forms[0].method = "POST";
            document.forms[0].submit();
		} else {
			getApproval(sign_status);
			return;
		}
	}

    function getApproval(approval_str) {
		if (approval_str == "") {
			alert("결재자를 지정해 주세요");
			return;
		}
		if(confirm(Message) != 1) {
			return;
		}

		form1.approval_str.value = approval_str;
		//document.attachFrame.setData();	//startUpload
		getApprovalSend(approval_str);
	}

	function getApprovalSend(approval_str) {


		//pr_no, pr_seq 초기값 설정.
		//$(pr_no).val('');
		//그리드 전체선텍
		//if("Y" == $('#i_onlyheader').val()){		//그리드 수정이 없으면 전체 체크를 통해 파라미터를 넘긴다. 체크가 없으면 Submit 가 안됨. 초기 설정함.
		//	selectAll();
		//}
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_ins2";
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		//var cols_ids = "<%=grid_col_id%>";
		var params     = getApprovalSendParam(approval_str);
	   
		myDataProcessor = new dataProcessor(servletUrl + params);
		//alert(servletUrl + params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		
		
	}
	
	function getApprovalSendParam(approvalStr){
		
		//alert(document.getElementById("rfq_flag").value);
		
		var inputParam = "&I_CREATE_TYPE=<%=create_type%>";
		var body       = document.getElementsByTagName("body")[0];
		var cols_ids   = "<%=grid_col_id%>";
		var params;
		
		inputParam = inputParam + "&I_RFQ_FLAG=" + document.getElementById("rfq_flag").value;
		inputParam = inputParam + "&I_ONLYHEADER=" + document.getElementById("i_onlyheader").value;
		inputParam = inputParam + "&I_PFLAG=" + approvalStr;
		inputParam = inputParam + "&I_PR_NO=" + document.getElementById("pr_no").value;
		inputParam = inputParam + "&I_PR_SEQ=" + document.getElementById("pr_seq").value;
		inputParam = inputParam + "&I_RFQ_NO=" + document.getElementById("rfq_no").value;
		inputParam = inputParam + "&I_RFQ_COUNT=" + document.getElementById("rfq_count").value;
		inputParam = inputParam + "&I_RFQ_TYPE=" + document.getElementById("rfq_type").value;
		inputParam = inputParam + "&I_SUBJECT=" + document.getElementById("subject").value;
		inputParam = inputParam + "&I_RFQ_CLOSE_DATE=" + del_Slash(document.getElementById("rfq_close_date").value);
		inputParam = inputParam + "&I_RFQ_CLOSE_TIME=" + document.getElementById("rfq_close_time").value + document.getElementById("szMin").value;
		inputParam = inputParam + "&I_PAY_TERMS=" + document.getElementById("pay_terms").value;
		inputParam = inputParam + "&I_DELY_TERMS=" + document.getElementById("dely_terms").value;
		inputParam = inputParam + "&I_SETTLE_TYPE=" + document.getElementById("settle_type").value;
		inputParam = inputParam + "&I_PC_REASON=" + document.getElementById("pc_reason").value;
		inputParam = inputParam + "&I_REMARK=" + urlEncode(document.getElementById("remark").value);
		inputParam = inputParam + "&I_CTRL_CODE=<%=CTRL_CODE%>";
		inputParam = inputParam + "&I_SZDATE=" + document.getElementById("szdate").value;
		inputParam = inputParam + "&I_START_TIME=" + document.getElementById("start_time").value;
		inputParam = inputParam + "&I_END_TIME=" + document.getElementById("end_time").value;
		inputParam = inputParam + "&I_HOST=" + document.getElementById("host").value;
		inputParam = inputParam + "&I_AREA=" + document.getElementById("area").value;
		inputParam = inputParam + "&I_PLACE=" + document.getElementById("place").value;
		inputParam = inputParam + "&I_NOTIFIER=" + document.getElementById("notifier").value;
		inputParam = inputParam + "&I_DOC_FRW_DATE=" + document.getElementById("doc_frw_date").value;
		inputParam = inputParam + "&I_RESP=" + document.getElementById("resp").value;
		inputParam = inputParam + "&I_COMMENT=" + document.getElementById("comment").value;
		inputParam = inputParam + "&I_SHIPPER_TYPE=" + document.getElementById("shipper_type").value;
		inputParam = inputParam + "&I_ATTACH_NO=" + document.getElementById("attach_no").value;
		inputParam = inputParam + "&I_DELETE_DATA=" + deletedata;
		inputParam = inputParam + "&I_PR_TYPE=<%=BID_REQ_TYPE%>";
		inputParam = inputParam + "&I_ADD_USER_ID=<%=ADD_USER_ID%>";
		
		var form = fnGetDynamicForm("", inputParam, null);
		
		body.appendChild(form);
		
		var cols_ids = "<%=grid_col_id%>";
		params = "?mode=setRfqChange";
		params += "&cols_ids=" + cols_ids;
		params += inputParam;
		params += dataOutput();
		
		body.removeChild(form);
		
		return params;
	}

	
	/**
	 * 동적 form을 생성하여 반환하는 메소드
	 *
	 * @param url
	 * @param param
	 * @param target
	 * @return form
	 */
	function fnGetDynamicForm(url, param, target){
		var form           = document.createElement("form");
		var paramArray     = param.split("&");
		var i              = 0;
		var paramInfoArray = null;

		if((target == null) || (target == "")){
			target = "_self";
		}

		for(i = 0; i < paramArray.length; i++){
			paramInfoArray = paramArray[i].split("=");
			
			var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

			form.appendChild(input);
		}

		form.action = url;
		form.target = target;
		form.method = "post";

		return form;
	}	
	
	/**
	 * Form 에 Input Name과 Value를 Hidden Type으로 세팅하여 되돌려줌
	 * @param frm 
	 * @param inputName
	 * @param inputValue
	 * @returns
	 */
	function fnFormInputSet(frm, inputName, inputValue) {
		var input = document.createElement("input");
		
		input.type  = "hidden";
		input.name  = inputName;
		input.id    = inputName;
		input.value = inputValue;
		
//		frm.appendChild(input);
		
		return input;
	}	
	/* function rMateFileAttach(att_mode, view_type, file_type, att_no) {
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
	} */

	/* function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
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
	} */

	function doBuyerSelect_popup(szRow, mode) {

		if(GridObj.GetRowCount() == 0) return;
		if(form1.rfq_type.value == "OP") {
			alert("공개견적에선 업체를 선정할 수 없습니다.");
			return;
		}

		var shipper_type = document.forms[0].shipper_type.value;

		if("S" == mode) { //select
			rfq_no = form1.rfq_no.value;
			rfq_count = form1.rfq_count.value;
			rfq_seq = GD_GetCellValueIndex(GridObj,szRow, INDEX_RFQ_SEQ);

			data   = "rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow;
			data += "&rfq_no=" + rfq_no + "&rfq_count=" + rfq_count;
			data += "&rfq_seq=" + rfq_seq+ "&shipper_type="+shipper_type;

			window.open(data, "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
		} else if("M" == mode) {
			rfq_no = form1.rfq_no.value;
			rfq_count = form1.rfq_count.value;
			window.open('rfq_pp_ins2.jsp?mode=' + mode + '&szRow=' + szRow + '&rfq_no=' + rfq_no + '&rfq_count=' + rfq_count + '&shipper_type='+shipper_type, "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
		} else {
			window.open('rfq_pp_ins2.jsp?mode=' + mode + '&szRow=' + szRow + '&shipper_type='+shipper_type, "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
		}

	}

	function getCompany(szRow) {

		if("Y" == GD_GetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED)) {
			return com_data = GD_GetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED_REASON);
		}

		return;
	}

	function vendorInsert(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
		if(szRow == "-1") {
    		load = "second";
			for(row=0; row<GridObj.GetRowCount(); row++) {
				if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED,  SELECTED_COUNT + ""); //G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&"
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
    				GD_SetCellValueIndex(GridObj,row, INDEX_MODE, "I");
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_CNT, SELECTED_COUNT+"");
					
				}
			}
		} else {
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED,  SELECTED_COUNT + ""); //G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&"
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
			GD_SetCellValueIndex(GridObj,szRow, INDEX_MODE, "I");
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_CNT, SELECTED_COUNT+"");
		}
	}

	function rfq_type_Changed()
	{
		if(form1.rfq_type.value == "OP") {
			alert("공개견적에서는 견적건별 만 가능합니다.");
			form1.settle_type.selectedIndex = 1;
		}
	}

	function getAllCompany() {
		if(GridObj.GetRowCount() == 0) return;

		var rowselected = 0;
		var value = "";
		var com_data = "";

		if(GridObj.GetRowCount() > 0) {
			for(row=0; row<GridObj.GetRowCount(); row++) {
				if(true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) { // 선택한 아이템중에서
					rowselected++;

					if("Y" == GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED)) { // 업체가 선택된넘 중에서
						if(GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED) == value) {
							return;
						} else {
							value += GD_GetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON);
						}
					}
				}
			}
/////////////////////////////////////////////
			var m_values = value.split("#"); // ex) BS57@우석정보@N@#BS58@바보정보@N@#BS59@등신정보@N@#BS58@바보정보@N@#
			var temp ="";

			for(i=0; i<m_values.length; i++) {
				if(m_values[i] != ""){
					var m_data_f = m_values[i].split("@");
					F_VENDOR_CODE = m_data_f[0];

					for(j=i+1; j<m_values.length; j++) {

						var m_data_s = m_values[j].split("@");
						S_VENDOR_CODE = m_data_s[0];

						if(LRTrim(F_VENDOR_CODE) == LRTrim(S_VENDOR_CODE)){
							m_values[j] = "";
						}
					}
				}
			}

			for(i=0; i<m_values.length; i++) {
				if(m_values[i] != ""){
					temp = temp + m_values[i] + "#";
				}
			}

			return temp;
		}

	}

	function vendor_Select() {
		if(GridObj.GetRowCount() == 0) return;
		rowselected=0;
		var cnt = 0;

		for(row=0; row<GridObj.GetRowCount(); row++) {
			if(true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				rowselected++;

				if(0 < parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_CNT),row))) {
					cnt++;
				}
			}
		}

		if(rowselected < 1)	{
			alert(G_MSS1_SELECT);
			return;
		}

		
		if(cnt == 0) {
			doBuyerSelect_popup("-1", "E");
		} else if(cnt > 0 && load != "first") {
			doBuyerSelect_popup("-1", "A");
		} else if(cnt > 0 && load == "first") {
			doBuyerSelect_popup("-1", "M");
		}
	}

	function searchProfile(fc) {
		var shipper_type = document.forms[0].shipper_type.value;
		if (fc == 'pay_method' ) {
            var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
            PopupCommonArr("SP9134", "getpay_method", arrv, "" );
		} else if(fc == "dely_terms" ) {
            var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
            PopupCommonArr("SP0232", "getdely_terms", arrv, "" );
        }
	}

	function getpay_method(code, text2) {
		document.forms[0].PAY_TERMS.value = code;
		document.forms[0].PAY_TERMS_TEXT.value = text2;
	}

	function checkMin(sFilter) {
		var sKey = String.fromCharCode(event.keyCode);
		var re = new RegExp(sFilter);

        // Enter는 키검사를 하지 않는다.
        if(sKey != "\r" && !re.test(sKey)) {
        	event.returnValue = false;
        }

    	if (form1.szMin.value.length == 0) {
	  		if (parseInt(sKey) > 5) event.returnValue = false;
	  	}
    }

    function valid_from_date(year,month,day,week) {
		document.form1.valid_from_date.value=year+month+day;
	}

	function valid_to_date(year,month,day,week) {
		document.form1.valid_to_date.value=year+month+day;
	}

function doDelete() {

	checked_count = 0;

	var rfq_no = form1.rfq_no.value;
	var rfq_count = form1.rfq_count.value;

	rowcount = GridObj.GetRowCount();
	for(row=rowcount-1; row>=0; row--) {
		if( true == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {

			checked_count++;
		}
	}

    if(checked_count < 1)  {
            alert(G_MSS1_SELECT);
            return;
    }
	Message = "삭제하시겠습니까?";

	if(confirm(Message) == 1) {

		/* mode = "setRfqItemDelete";
		GridObj.SetParam("mode", mode);
		GridObj.SetParam("rfq_no", rfq_no);
		GridObj.SetParam("rfq_count", rfq_count);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL","ALL"); */

		servletUrl = "<%=POASRM_CONTEXT_NAME%>/serlvets/dt.rfq.rfq_bd_ins2";
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=setRfqItemDelete";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		
	}

}//doDelete

	function openPopup(szRow, mode,SG_REFITEM) {
		if(GridObj.GetRowCount() == 0) return;
		var shipper_type = document.forms[0].shipper_type.value;
		window.open('rfq_pp_ins2.jsp?mode=' + mode + '&szRow=' + szRow + '&shipper_type='+shipper_type+"&SG_REFITEM="+SG_REFITEM + "&rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>&rfq_seq=" + GridObj.GetCellValue("RFQ_SEQ", szRow), "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
	}


	function setShowTwit(obj){
		return;
		if(obj.value=="OP"){
			document.all.TWIT_YN.style.display="inline" ;
		}else{
			document.all.TWIT_YN.style.display="none" 	;
		}
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
    var INDEX_RFQ_QTY            = GridObj.getColIndexById("RFQ_QTY");				//파일첨부
    var INDEX_PURCHASE_PRE_PRICE = GridObj.getColIndexById("PURCHASE_PRE_PRICE");	//업체선택
    
    
    if(cellInd == INDEX_VENDOR_CNT){		//업체선택

		if(GridObj.GetRowCount() == 0) return;
			if(form1.rfq_type.value == "OP") {
				alert("공개견적에선 업체를 선정할 수 없습니다.");
				return;
		}

	    var settleType = form1.settle_type.value;
	    if(settleType == "DOC"){   //견적건별이라면 모든품목에 대해 동일한 업체가 선택되어야 한다.
	        vendor_Select();
	    }else{
	    	/*
		    INDEX_mode = GD_GetCellValueIndex(GridObj,msg2, INDEX_MODE);
            if (INDEX_mode == "N") {
			    doBuyerSelect_popup(msg2, "S");
			} else {
			    doBuyerSelect_popup(msg2, "I");
			}
			*/
			var rowIndex   = GridObj.getRowIndex(rowId);
			INDEX_mode = GridObj.cells(rowId, INDEX_MODE).getValue();	//GD_GetCellValueIndex(GridObj,rowId, INDEX_MODE);
			//alert("b:"+INDEX_mode);
			if (INDEX_mode == "N") {
			    openPopup(rowIndex, "S", "");
			} else {
			    openPopup(rowIndex, "I", "");
			}


	    }
	/* } else if(cellInd == INDEX_PRICE_DOC) { // 원가내역서
		if(form1.rfq_type.value == "OP") {
			alert("공개견적에서는 원가내역을 입력할 수 없습니다.");
			return;
		}
 	*/
		//getPriceDoc(msg2);
	} else if(cellInd == INDEX_ITEM_NO) { //품목
		var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue();	//GD_GetCellValueIndex(GridObj,rowId, INDEX_ITEM_NO);

		//var ITEM_NO = GD_GetCellValueIndex(GridObj,rowId, INDEX_ITEM_NO);

		POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
	} else if(cellInd == INDEX_ATTACH_NO_CNT) {	//파일 첨부
		//var ATTACH_NO_VALUE = GridObj.cells(rowId, INDEX_ATTACH_NO).getValue();			//LRTrim(GD_GetCellValueIndex(GridObj,rowId, INDEX_ATTACH_NO));
				
		//Arow = rowId;
		//document.form1.attach_gubun.value = "wise";
		
		//goAttach(ATTACH_NO_VALUE);

/*
		if("" == ATTACH_NO_VALUE || "N" == ATTACH_NO_VALUE) {
			FileAttach('RFQ','','');
		} else {
			FileAttachChange('RFQ', ATTACH_NO_VALUE);
		}
*/
		//rMateFileAttach('P','C','RFQ',ATTACH_NO_VALUE);
	}
    
<%--    
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
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
    	var INDEX_RFQ_QTY            = GridObj.getColIndexById("RFQ_QTY");				//요청수량
    	var INDEX_PURCHASE_PRE_PRICE = GridObj.getColIndexById("PURCHASE_PRE_PRICE");	//요청단가
    	var INDEX_RFQ_AMT            = GridObj.getColIndexById("RFQ_AMT");				//요청금액
    	
    	var rowIndex                 = GridObj.getRowIndex(GridObj.getSelectedId());
        
        if((cellInd == INDEX_RFQ_QTY) || (cellInd == INDEX_PURCHASE_PRE_PRICE)){
    		calculate_grid_amt(GridObj, rowIndex, INDEX_RFQ_QTY, INDEX_PURCHASE_PRE_PRICE, "1", "RFQ_AMT");
    	}
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
        doSelect();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

    return false;
}




var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
function selectAll(){
	if(selectAllFlag == 0)
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
		}
		selectAllFlag = 1;
	}
	else
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
		}
	}
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
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


/* 파일 업로드 */
/* function goAttach(attach_no){
	attach_file(attach_no,"RFQ");
}

function setAttach(attach_key, arrAttrach, attach_count) {

	if(document.form1.attach_gubun.value == "wise"){
		GridObj.cells(Arow, INDEX_ATTACH_NO).setValue(attach_key);
		GridObj.cells(Arow, INDEX_ATTACH_NO_CNT).setValue(attach_count);
		
		
	} else {
		var f = document.forms[0];
	    f.attach_no.value    = attach_key;
	    f.attach_count.value = attach_count;
	}
	document.form1.attach_gubun.value="body";

} */

</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="title_page">견적요청 수정
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

<form name="form1" >
	<input type="hidden" name="announce_flag" value="<%=rtn_announce_flag %>">
	
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
	<input type="hidden" name="house_code"    id="house_code"    value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code"  id="company_code"  value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code"     id="dept_code"     value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id"   id="req_user_id"   value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type"      id="doc_type"      value="RQ">
	<input type="hidden" name="fnc_name"      id="fnc_name"      value="getApproval">
	<input type="hidden" name="i_onlyheader"  id="i_onlyheader"  value="Y">
	<input type="hidden" name="pr_no"         id="pr_no"         value="">
	<input type="hidden" name="pr_seq"        id="pr_seq"        value="">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>
	
	<!-- hidden(사양설명회) //-->
	<input type="hidden" name="szdate" id="szdate">
	<input type="hidden" name="start_time" id="start_time">    
                                                                       
	<input type="hidden" name="end_time" id="end_time">      
	<input type="hidden" name="host" id="host">          
	<input type="hidden" name="area" id="area">          
	<input type="hidden" name="place" id="place">         
	<input type="hidden" name="notifier" id="notifier">      
                                                                       
	<input type="hidden" name="doc_frw_date" id="doc_frw_date">  
	<input type="hidden" name="resp" id="resp">          
	<input type="hidden" name="comment" id="comment">       
	<input type="hidden" name="subject_hidden" id="subject_hidden">

    <!-- hidden(rfq_flag) //-->
    <input type="hidden" name="rfq_flag" id="rfq_flag" value="">
	<input type="hidden" name="shipper_type" id="shipper_type" value="<%=SHIPPER_TYPE%>">
	<%-- <input type="hidden" name="attach_no" id="attach_no" value="<%=HATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.--> --%>
	<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">

	<input type="hidden" name="att_mode"  id="att_mode" value="">
	<input type="hidden" name="view_type"  id="view_type" value="">
	<input type="hidden" name="file_type"  id="file_type" value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
	<!-- <input type="hidden" name="attach_count" id="attach_count" value=""> -->
	<input type="hidden" name="approval_str" id="approval_str" value="">

<tr>
	<td width="15%" class="title_td">
		 견적요청번호
	</td>
	<td width="35%"  class="data_td">
		<input type="text" name="rfq_no" id="rfq_no" size="30" class="input_re" value="<%=rfq_no%>" readonly>
	</td>
	<td width="15%" class="title_td">
		 차수
	</td>
	<td class="data_td">
		<input type="text" name="rfq_count" id="rfq_count" size="5" value="<%=rfq_count%>" class="input_re" readonly>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td">
		 견적요청명
	</td>
	<td width="35%" class="data_td">
		<input type="text" name="subject" id="subject" size="40" class="input_re" value='<%=SUBJECT%>' onKeyUp="return chkMaxByte(500, this, '견적요청명');">
	</td>
	<td width="15%" class="title_td">
		 견적마감일
	</td>
	<td width="35%" class="data_td">
		<%-- <input type="text" name="rfq_close_date" size="8" class="input_re" maxlength=8 value="<%=RFQ_CLOSE_DATE%>" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]');">
		<a href="javascript:Calendar_Open('jf_rfq_close_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> --%>
		<s:calendar id="rfq_close_date" format="%Y/%m/%d" default_value="<%=SepoaString.getDateSlashFormat(RFQ_CLOSE_DATE)%>" />
		<select name="rfq_close_time" id="rfq_close_time" class="linksite" >
		<option value="01">01</option>
		<option value="02">02</option>
		<option value="03">03</option>
		<option value="04">04</option>
		<option value="05">05</option>
		<option value="06">06</option>
		<option value="07">07</option>
		<option value="08">08</option>
		<option value="09">09</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="13">13</option>
		<option value="14">14</option>
		<option value="15">15</option>
		<option value="16">16</option>
		<option value="17">17</option>
		<option value="18">18</option>
		<option value="19">19</option>
		<option value="20">20</option>
		<option value="21">21</option>
		<option value="22">22</option>
		<option value="23">23</option>
		</select>
		시
		<input type="text" name="szMin" id="szMin" size="2" maxLength="2" value = "<%=rfq_close_min%>" style="ime-mode:disabled" onKeyPress="checkMin('[0-9]')"> 분</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td"> 견적요청형태</td>
	<td class="data_td" colspan="3">
		<table>
			<tr>
				<td><select name="rfq_type" id="rfq_type" <%=disabled%> onChange="reason(this)">
					<option value="">-----</option>
				<%
					String lb_rfq_type = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M112", RFQ_TYPE);
					out.println(lb_rfq_type);
				%>
					</select>
				</td>
			</tr>
			<tr>
				<td><!-- &nbsp;사유 :  --><input type="hidden" name="pc_reason" id="pc_reason" size="100" class="input_data" value="<%=PC_REASON%>" disabled="<%=pc_reasonDisable%>"/></td>
			</tr>
		</table>
	</td>
</tr>	
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>	
	<td width="15%" class="title_td">
		 지급조건
	</td>
	<td width="35%" class="data_td">
		<select name="PAY_TERMS" id="pay_terms" class="input_re">
			<%=pay_terms%>
		</select>
	</td>	
	<td width="15%" class="title_td">
		 인도조건
	</td>	
	<td width="35%" class="data_td">
		<select name="DELY_TERMS" id="dely_terms" class="input_re">
			<%=dely_terms%>
		</select>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr style="display:none">	
	<td width="15%" class="title_td"> 비교방식</td>
	<td width="35%" class="data_td" colspan="3">
		<select name="settle_type" id="settle_type" class="inputsubmit"  <%=disabled%>>
	<%
		String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M149", SETTLE_TYPE);
		out.println(settle);
	%>
		</select>
	</td>
</tr>
<tr>
	<td width="15%" class="title_td"> 특기사항</td>
	<td class="data_td" colspan="3">
		<table width="98%">
		<tr>
			<td>
				<textarea name="remark" id="remark" style="width: 100%;" rows="6" onKeyUp="return chkMaxByte(4000, this, '특기사항');"><%=REMARK %></textarea></td><td>
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td"> 첨부파일</td>
	<td class="data_td" colspan="3" height="150">
		<table><tr></tr><td>
		<script language="javascript">
		function setAttach(attach_key, arrAttrach, rowId, attach_count) {
			setApprovalButton(attach_count);
			document.getElementById("attach_no").value            = attach_key;
			document.getElementById("attach_no_count").value      = attach_count;
		}
			btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
		</script>
		</td><td>
		<input type="text" size="3" readOnly class="input_empty" name="attach_no_count" id="attach_no_count" value="<%=HATTACH_NO_CNT %>" />
		<input type="hidden" name="attach_no" id="attach_no" value="<%=HATTACH_NO%>" />
		</td></table>
	</td>
</tr>
<tr id="TWIT_YN" style="display:none">
	<td width="15%" class="title_td"> 트위터 공고<br>(140 BYTE)
		<br><br>
		현재 : <input type="text" name="TWIT_LEN" id="twit_len" style="text-align:right" readOnly size="4" /> BYTE
	</td>
	<td class="data_td" colspan="3" height="200">
		<textarea name="TWIT" id="twit" style="ime-mode:active" rows="5" cols="95" rows="2" class="inputsubmit" onKeyUp="cal_length(this)"></textarea>
	</td>
</tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
  	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="left">
				<TABLE cellpadding="0">
		      		<TR>
	    	  		</TR>
      			</TABLE>
      		</td>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:announce_click()","제안설명회");</script></TD>
					<%
					if( !BID_REQ_TYPE.equals("S") && (wf2_cnt == 0) ) {
					%>
	    	            <TD><script language="javascript">btn("javascript:vendor_Select()","견적업체")    </script></TD>
					<%
					}
					%>
    	  			<TD><script language="javascript">btn("javascript:doSave('T')","임시저장")    </script></TD>
					<%if (sign_use_yn) {%>
					<TD id="approvalButton1"><script language="javascript">btn("javascript:doSave('P')","결재요청") </script></TD>
					<TD id="approvalButton2"><script language="javascript">btn("javascript:doSave('E')","업체전송") </script></TD>
					<%} else {%>
					<TD><script language="javascript">btn("javascript:doSave('E')","업체전송") </script></TD>
					<%}%>
    	  			<TD><script language="javascript">btn("javascript:parent.window.close()","닫 기")    </script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

  	<script language="JavaScript" >
	</script>



<script language="JavaScript" ></script>
</form>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<s:grid screen_id="RQ_239" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


