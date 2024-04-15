<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SRQ_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SRQ_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SRQ_002";%>

<%
	String house_code	= info.getSession("HOUSE_CODE");
	String user_type	= info.getSession("USER_TYPE");

	String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String vendor_code	= info.getSession("COMPANY_CODE");

	Object[] obj = {rfq_no, rfq_count};

	SepoaOut value = ServiceConnector.doService(info, "s2011", "CONNECTION", "getRfqHDDisplay_TYPE", obj);

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
	String SPRICE_TYPE           = "";
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
    String Z_RESULT_OPEN_FLAG    = "";
    String BID_REQ_TYPE    		 = "";
	String CREATE_TYPE			 = "";
	String ATTACH_NO			 = "";
	String ATT_COUNT			 = "";
	String CUST_NAME			 = "";
	String getVENDOR_CODE        = "";
	String RPT_GETFILENAMES      = "";
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이타가 있는 경우

			// 웹취약점으로 해당 업체이거나 내부사용자인 경우만 조회되도록 수정 : 2015.09.24
			getVENDOR_CODE =  wf.getValue("VENDOR_CODE", 0);
			if ("S".equals(user_type) && !getVENDOR_CODE.equals(vendor_code)) {
				%>
				<script>
					sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
				</script>
				<%
			}
			
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
			SPRICE_TYPE              =  wf.getValue("PRICE_TYPE          ", 0);
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
			Z_RESULT_OPEN_FLAG       =  wf.getValue("Z_RESULT_OPEN_FLAG  ", 0);
			BID_REQ_TYPE       		 =  wf.getValue("BID_REQ_TYPE        ", 0);
			CREATE_TYPE			 	 =  wf.getValue("CREATE_TYPE         ", 0);
			ATTACH_NO			 	 =  wf.getValue("ATTACH_NO           ", 0);
			ATT_COUNT			 	 =  wf.getValue("ATT_COUNT           ", 0);
			CUST_NAME			 	 =  wf.getValue("CUST_NAME           ", 0);
			RPT_GETFILENAMES         =  wf.getValue("RPT_GETFILENAMES    ", 0);

		}
	}

	Object[] obj2 = {rfq_no ,rfq_count };
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
	
	int wf2_cnt = wf2.getRowCount();

	String group_yn = "N";
	if(BID_REQ_TYPE.equals("I")) group_yn = "Y";
	
	
	Map<String, String> data = new HashMap();
	data.put("st_rfq_no"		, rfq_no);
	data.put("st_rfq_count"		, rfq_count);
	data.put("group_yn"		    , group_yn);
	data.put("bid_req_type"		, BID_REQ_TYPE);
	Object[] obj3 = {data};
	
	SepoaOut value3 = ServiceConnector.doService(info, "s2011", "CONNECTION", "getRfqDTDisplay_TYPE", obj3);
	SepoaFormater wf3 = new SepoaFormater(value3.result[0]); 
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_rfq_pp_dis1"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(rfq_no);
	_rptData.append(_RF);
	_rptData.append(rfq_count);
	_rptData.append(_RF);
	_rptData.append(SUBJECT);
	_rptData.append(_RF);
	_rptData.append(RFQ_CLOSE_DATE_VIEW);
	_rptData.append(_RF);
	_rptData.append(RFQ_TYPE_TEXT);
	_rptData.append(_RF);
	_rptData.append(SETTLE_TYPE_TEXT);
	_rptData.append(_RF);
	_rptData.append(DELY_TERMS_TEXT);
	_rptData.append(_RF);
	_rptData.append(PAY_TERMS_TEXT);
	_rptData.append(_RF);
	_rptData.append(REMARK);
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES);
	
	_rptData.append(_RD);	
	if(wf3 != null) {
		if(wf3.getRowCount() > 0) { //데이타가 있는 경우
			for(int i = 0 ; i < wf3.getRowCount() ; i++){
				_rptData.append(wf3.getValue("DESCRIPTION_LOC", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("SPECIFICATION", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("UNIT_MEASURE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("RFQ_QTY", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("CUR", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("PURCHASE_PRE_PRICE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("RFQ_AMT", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("RD_DATE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("DELY_TO_ADDRESS", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("REMARK", i));
				_rptData.append(_RL);			
			}
		}
	}
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" type="text/javascript">
//<!--
	var mode;


    var IDX_ITEM_NO               ;
    var IDX_DESCRIPTION_LOC       ;
    var IDX_SPECIFICATION         ;
    var IDX_RFQ_QTY               ;
    var IDX_YEAR_QTY              ;
    var IDX_UNIT_MEASURE          ;
    var IDX_RD_DATE               ;
    var IDX_ATTACH_NO             ;
    var IDX_COST_COUNT            ;
    var IDX_PLANT_CODE            ;
    var IDX_DELY_TO_LOCATION_NAME ;
    var IDX_PURCHASE_USER_NAME    ;
    var IDX_RFQ_SEQ;

	function Init()
    {
		setGridDraw();
		setHeader();
        doSelect();
        
    }
 
    
	function setHeader() {
        IDX_ITEM_NO                  = GridObj.GetColHDIndex("ITEM_NO");
        IDX_DESCRIPTION_LOC          = GridObj.GetColHDIndex("DESCRIPTION_LOC");
        IDX_SPECIFICATION            = GridObj.GetColHDIndex("SPECIFICATION");
        IDX_RFQ_QTY                  = GridObj.GetColHDIndex("RFQ_QTY");
        IDX_YEAR_QTY                 = GridObj.GetColHDIndex("YEAR_QTY");

        IDX_UNIT_MEASURE             = GridObj.GetColHDIndex("UNIT_MEASURE");
        IDX_RD_DATE                  = GridObj.GetColHDIndex("RD_DATE");
        IDX_ATTACH_NO                = GridObj.GetColHDIndex("ATTACH_NO");
        IDX_COST_COUNT               = GridObj.GetColHDIndex("COST_COUNT");
        IDX_PLANT_CODE               = GridObj.GetColHDIndex("PLANT_CODE");

        IDX_DELY_TO_LOCATION_NAME    = GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME");
        IDX_PURCHASE_USER_NAME       = GridObj.GetColHDIndex("PURCHASE_USER_NAME");
        IDX_RFQ_SEQ                  = GridObj.GetColHDIndex("RFQ_SEQ");

	}

	function doSelect() {
		<%-- servletUrl = "";
		GridObj.SetParam("mode", "getRfqDTDisplay_TYPE");
		GridObj.SetParam("rfq_no", "<%=rfq_no%>");
		GridObj.SetParam("rfq_count", "<%=rfq_count%>");
		GridObj.SetParam("group_yn", "<%=group_yn%>");
		GridObj.SetParam("bid_req_type", "<%=BID_REQ_TYPE%>");
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl); --%>
		
		$('#st_rfq_no').val("<%=rfq_no%>");
		$('#st_rfq_count').val("<%=rfq_count%>");
		$('#group_yn').val("<%=group_yn%>");
		$('#bid_req_type').val("<%=BID_REQ_TYPE%>");
				
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rfq.rfq_pp_dis1";
		var cols_ids = "<%=grid_col_id%>";
        var param = "mode=getRfqDTDisplay_TYPE&cols_ids="+cols_ids;
		    param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false); 
		
	}


//사양
	function openPopup2() {
		if("<%=RQAN_CNT%>" == "0") {
			alert("등록된 제안설명회정보가 없습니다.");
			return;
		}

		rfq_no = "<%=rfq_no%>";
		rfq_count = "<%=rfq_count%>";
		count = GridObj.GetRowCount();
		if(count > 0)
			window.open('/kr/dt/rfq/rfq_pp_dis5.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count+'&count='+count ,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=720,height=350,left=0,top=0");
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {

	    for(var i=0;i<GridObj.GetRowCount();i++) {
	           if(i%2 == 1){
			    for (var j = 0;	j<GridObj.GetColCount(); j++){
			        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
		        }
	           }
		}
		if(msg1 == "t_imagetext") {
			if(msg3 == IDX_ITEM_NO) { //품목번호
				var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, IDX_ITEM_NO);
				POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "품목_일반정보", '0', '0', '800', '400');
			} else if(msg3 == IDX_ATTACH_NO) { //파일
				var ATTACH_NO = GD_GetCellValueIndex(GridObj,msg2, IDX_ATTACH_NO);
				rMateFileAttach('P','R','RFQ',ATTACH_NO);
			} else if(msg3 == IDX_COST_COUNT) { //원가
				if(GD_GetCellValueIndex(GridObj,msg2, IDX_COST_COUNT) > 0 ) {
					rfq_no = "<%=rfq_no%>";
					rfq_count = "<%=rfq_count%>";
					rfq_seq = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_SEQ);
					window.open('/kr/dt/rfq/rfq_pp_dis8.jsp?rfq_no=' + rfq_no + '&rfq_count=' + rfq_count + '&rfq_seq=' + rfq_seq,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=350,left=0,top=0");
				}
			}
		}
		if(msg1 == "doQuery") {
//			form1.attach_count.value = "<%=ATT_COUNT%>";
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
	function ozCall(){
		url = "/oz/oz_rfq_genjuk.jsp?";
		url += "house_code=<%=house_code%>&rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>&vendor_code=<%=vendor_code%>";
		//alert(url);
		window.open(url,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=600,left=0,top=0");
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData) {
	if(typeof(rptAprvData) != "undefined"){
		alert(rptAprvData);
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit(); 
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" >
<s:header popup="true">

<form name="form1" action="">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
	<%--ClipReport4 hidden 태그 끝--%>	
	<input type="hidden" name="att_count" value="<%=ATT_COUNT%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="attach_gubun" value="body">
	
	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="st_rfq_no"    id="st_rfq_no"     value="">
	<input type="hidden" name="st_rfq_count" id="st_rfq_count"  value="">
	<input type="hidden" name="group_yn"     id="group_yn"      value="">
	<input type="hidden" name="bid_req_type" id="bid_req_type"  value="">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class='title_page'>견적요청 상세조회</td>
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
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호
									</td>
									<td width="35%" class="data_td">
										<input type="text" name="RFQ_NO" size="20" value="<%=rfq_no%>" class="input_data2">
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수
									</td>
									<td class="data_td">
										<input type="text" name="rfq_count" size="5" value="<%=rfq_count%>" class="input_data2">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명
									</td>
									<td width="35%" class="data_td">
										<%=SUBJECT%>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일
									</td>
									<td width="35%" class="data_td">
										<%=RFQ_CLOSE_DATE_VIEW%>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청형태
									</td>
									<td width="35%" class="data_td">
										<%=RFQ_TYPE_TEXT%>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비교방식
									</td>
									<td width="35%" class="data_td">
										<%=SETTLE_TYPE_TEXT%>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건
									</td>
									<td width="35%" class="data_td">
										<%=DELY_TERMS_TEXT%>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건
									</td>
									<td width="35%" class="data_td">
										<%=PAY_TERMS_TEXT%>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 특기사항
									</td>
									<td width="35%" class="data_td" colspan="3"><textarea name="REMARK" style="width:98%" rows="5" readonly><%=REMARK %></textarea></td><td>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
									<td class="data_td" colspan="3" height="150">
										<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
										<!-- 		<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
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
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<%if(!CREATE_TYPE.equals("PR")&& !CREATE_TYPE.equals("DR")){%>
							<%if(!RQAN_CNT.equals("0")){ %>
								<td><script language="javascript">btn("javascript:openPopup2()","제안설명회")</script></td>
							<%}%>
						<%}%>
						<TD><script language="javascript">btn("javascript:clipPrint()","인 쇄")</script></TD>
	    	  			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
					</TR>
				</TABLE>
			</td>
		
		</tr>
	</table>
																				
</form>

</s:header>
<s:grid screen_id="SRQ_002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


