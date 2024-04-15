<%--
    Title                            :          rfq_bd_dis1.jsp  <p>
    Description                      :          견적요청 상세조회 <p>
    Copyright                        :          Copyright (c) <p>
    Company                          :          SEPOASOFT <p>
    @author                          :          WKHONG(2014.10.06)<p>
    @version                         :          1.0
    @Comment                         :          견적요청 상세내용을 조회하는 화면이다.
    @SCREEN_ID                       :          RQ_232
--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<style type="text/css">
body{
overflow-y:hidden;
}
</style>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_232");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_232";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_232";%>

<%
	String house_code	= info.getSession("HOUSE_CODE");
	String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String doc_status   = JSPUtil.nullToEmpty(request.getParameter("doc_status"));//결재화면에서 넘어오는 데이터

	//String[] args = {rfq_no, rfq_count};
	//Object[] obj = {args};
	Object[] obj = {rfq_no, rfq_count};
	SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqHDDisplay", obj);
	SepoaOut value1= ServiceConnector.doService(info, "p1004", "CONNECTION", "getVendorCode"  , obj);
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj);
	
	Map map = new HashMap();
	map.put("rfq_no"		, rfq_no);
	map.put("rfq_count"		, rfq_count);
	Map<String, Object> data = new HashMap();
	data.put("headerData"		, map);

	Object[] obj2 = {data};
	SepoaOut value3= ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqDTDisplay", obj2);
	
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
	String PRICE_TYPE_DIS1       = "";// /include/sepoa_grid_common.jsp 중복 변수 있어 수정
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
	String Z_RESULT_OPEN_FLAG    = "";
	String BID_REQ_TYPE			 = "";
	String CREATE_TYPE			 = "";
	String ATTACH_NO			 = "";
	String ATTACH_COUNT			 = "";
	String PC_REASON			 = "";
	String PC_FLAG			 	 = "";
	String RPT_GETFILENAMES      = "";


	SepoaFormater wf = new SepoaFormater(value.result[0]);
	SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]); 
	SepoaFormater wf3 = new SepoaFormater(value3.result[0]); 
	
	int vendor_cnt = wf1==null?0:wf1.getRowCount();

	String[] VENDOR_CODE = new String[vendor_cnt];

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이타가 있는 경우

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
			PRICE_TYPE_DIS1               =  wf.getValue("PRICE_TYPE          ", 0); // /include/sepoa_grid_common.jsp 중복 변수 있어 수정
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
			SMS_YN                   =  wf.getValue("Z_SMS_SEND_FLAG", 0);
			Z_RESULT_OPEN_FLAG       =  wf.getValue("Z_RESULT_OPEN_FLAG", 0);
			BID_REQ_TYPE			 =  wf.getValue("BID_REQ_TYPE", 0);
			CREATE_TYPE			 	 =  wf.getValue("CREATE_TYPE", 0);
			ATTACH_NO			 	 =  wf.getValue("ATTACH_NO", 0);
			ATTACH_COUNT			 =  wf.getValue("ATT_COUNT", 0);
			PC_REASON				 =  wf.getValue("PC_REASON", 0);
			PC_FLAG			 		 =  wf.getValue("PC_FLAG", 0);
			RPT_GETFILENAMES         =  wf.getValue("RPT_GETFILENAMES", 0);
		}
	}

	for(int i=0;i<vendor_cnt;i++){
		VENDOR_CODE[i] = wf1.getValue("VENDOR_CODE",i);
	}
	int wf2_cnt = wf2.getRowCount();
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_rfq_bd_dis11"; //리포트명
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
	if(!PC_REASON.equals("")){
		_rptData.append("사유 : ");
		_rptData.append(PC_REASON);
	}
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
				_rptData.append(wf3.getValue("ITEM_NO", i));
				_rptData.append(_RF);			
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
				_rptData.append(wf3.getValue("VENDOR_CNT", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("DELY_TO_ADDRESS", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("REC_VENDOR_NAME", i));
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

<%@ include file="/include/include_css.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
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
    var IDX_PURCHASE_PRE_PRICE    ;
    var IDX_RFQ_AMT               ;
    var IDX_RD_DATE               ;
    var IDX_ATTACH_NO             ;
    var IDX_ATT_COUNT             ;
    var IDX_PLANT_CODE            ;
    var IDX_DELY_TO_LOCATION      ;
    var IDX_PR_CHANGE_USER_NAME   ;
    var IDX_PR_NO                 ;
    var IDX_PR_SEQ                ;
    var IDX_COST_COUNT            ;
    var IDX_VENDOR_CNT    ;
    var IDX_RFQ_SEQ;
    var IDX_PURCHASE_LOCATION;
    var IDX_CTRL_CODE;

    function Init() {	//화면 초기설정 
		setGridDraw();
		setHeader();
				<%
					String FLAG			= JSPUtil.nullToRef(request.getParameter("FLAG"),""); // 에러 발생하여 임시 작업
				
					if(FLAG != null && !FLAG.equals("")){
						if(FLAG.equals("P")){
							%>document.forms.form1.rfq_flag.value = 'G'<%
						}
					}
				%>
		doSelect();
	}

    
    
	function setHeader() {

		<%if(BID_REQ_TYPE.equals("I")){%>

		<%}else{
			if(wf2_cnt > 0 ) {
		%>
	
		  <%}else{%>
	
		  <%} 
		}%>
	

/* 
			GridObj.SetColCellSortEnable("DESCRIPTION_LOC",false);
			GridObj.SetColCellSortEnable("SPECIFICATION",false);
			GridObj.SetNumberFormat("RFQ_QTY",G_format_qty);
			GridObj.SetNumberFormat("YEAR_QTY",G_format_qty);
			GridObj.SetColCellSortEnable("UNIT_MEASURE",false);
			GridObj.SetNumberFormat("PURCHASE_PRE_PRICE",G_format_unit);
			GridObj.SetNumberFormat("RFQ_AMT",G_format_amt);
			GridObj.SetDateFormat("RD_DATE",    "yyyy/MM/dd");
			GridObj.SetColCellSortEnable("PR_CHANGE_USER_NAME",false);
			GridObj.SetColCellSortEnable("PR_NO",false);
			GridObj.SetColCellSortEnable("PR_SEQ",false);
			GridObj.SetColCellSortEnable("PURCHASE_LOCATION",false);
			GridObj.SetColCellSortEnable("CTRL_CODE",false);
			GridObj.SetColCellSortEnable("RFQ_SEQ",false);
			GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
			GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd");
 */

			IDX_ITEM_NO                  = GridObj.GetColHDIndex("ITEM_NO");
			IDX_DESCRIPTION_LOC          = GridObj.GetColHDIndex("DESCRIPTION_LOC");
			IDX_SPECIFICATION            = GridObj.GetColHDIndex("SPECIFICATION");
			IDX_RFQ_QTY                  = GridObj.GetColHDIndex("RFQ_QTY");

			IDX_YEAR_QTY                 = GridObj.GetColHDIndex("YEAR_QTY");
			IDX_UNIT_MEASURE             = GridObj.GetColHDIndex("UNIT_MEASURE");
			IDX_PURCHASE_PRE_PRICE       = GridObj.GetColHDIndex("PURCHASE_PRE_PRICE");
			IDX_GISUL_RFQ				 = GridObj.GetColHDIndex("GISUL_RFQ");
			IDX_RFQ_AMT                  = GridObj.GetColHDIndex("RFQ_AMT");
			IDX_RD_DATE                  = GridObj.GetColHDIndex("RD_DATE");

			IDX_ATTACH_NO                = GridObj.GetColHDIndex("ATTACH_NO");
			IDX_ATT_COUNT                = GridObj.GetColHDIndex("ATT_COUNT");
			IDX_PLANT_CODE               = GridObj.GetColHDIndex("PLANT_CODE");
			IDX_DELY_TO_LOCATION         = GridObj.GetColHDIndex("DELY_TO_LOCATION");

			IDX_PR_CHANGE_USER_NAME      = GridObj.GetColHDIndex("PR_CHANGE_USER_NAME");
			IDX_PR_NO                    = GridObj.GetColHDIndex("PR_NO");
			IDX_PR_SEQ                   = GridObj.GetColHDIndex("PR_SEQ");
			IDX_COST_COUNT               = GridObj.GetColHDIndex("COST_COUNT");
			IDX_VENDOR_CNT               = GridObj.GetColHDIndex("VENDOR_CNT");
			IDX_PURCHASE_LOCATION        = GridObj.GetColHDIndex("PURCHASE_LOCATION");
			IDX_CTRL_CODE	             = GridObj.GetColHDIndex("CTRL_CODE");
			IDX_RFQ_SEQ                  = GridObj.GetColHDIndex("RFQ_SEQ");

			//doSelect();

		}

	function doSelect() {
		<%-- servletUrl = "<%=getWiseServletPath("dt.rfq.rfq_bd_dis1")%>";
		GridObj.SetParam("mode", "getRfqDTDisplay");
		GridObj.SetParam("rfq_no", "<%=rfq_no%>");
		GridObj.SetParam("rfq_count", "<%=rfq_count%>");
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl); --%>
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getRfqDTDisplay&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_bd_dis1";

		GridObj.post(url, param);
		GridObj.clearAll(false);	 
	}


//사양설명회
	function openPopup2() {
		if("<%=RQAN_CNT%>" == "0") {
			alert("등록된 제안설명회가 없습니다.");
			return;
		}

		rfq_no = "<%=rfq_no%>";
		rfq_count = "<%=rfq_count%>";
		count = GridObj.GetRowCount();
		if(count > 0) window.open('rfq_pp_dis5.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count+'&count='+count ,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=350,left=0,top=0");
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
			<%-- if(msg3 == IDX_ITEM_NO) { //품목번호
				var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, IDX_ITEM_NO);
				POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
			} else if(msg3 == IDX_ATTACH_NO) { //파일
				var ATTACH_NO = GD_GetCellValueIndex(GridObj,msg2, IDX_ATTACH_NO);
//				if(ATTACH_NO != "N") FileAttach('RFQ',ATTACH_NO,'VI');

				if(ATTACH_NO != "N") {
					rMateFileAttach('P','R','RFQ',ATTACH_NO);
				}
			} else if(msg3 == IDX_COST_COUNT) { //원가
				if(GD_GetCellValueIndex(GridObj,msg2, IDX_COST_COUNT) > 0 ) {
					rfq_no = "<%=rfq_no%>";
					rfq_count = "<%=rfq_count%>";
					rfq_seq = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_SEQ);
					window.open('rfq_pp_dis8.jsp?rfq_no=' + rfq_no + '&rfq_count=' + rfq_count + '&rfq_seq=' + rfq_seq,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=600,height=350,left=0,top=0");
				}
			} else if(msg3 == IDX_GISUL_RFQ) { //기술견적내역
				openPopup7(msg2);
			} --%>

		}
		else if(msg1 == "doQuery") { // 전송/저장시 Row삭제
				 form1.attach_count.value = "<%=ATTACH_COUNT%>";
		}
	}

	function openPopup7(row) {
		var tRfq_no = GD_GetCellValueIndex(GridObj,row, IDX_GISUL_RFQ);
		window.open('rfq_pp_ins8.jsp?tRfq_no='+tRfq_no+"&view=VI" ,"windowopen7","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=500,height=380,left=0,top=0");
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


//승인
    function EndApp3()
    {
        var doc_no = "<%=rfq_no%>";
        var doc_seq = "<%=rfq_count%>";

        opener.sign_Close_RFQ(doc_no,doc_seq,"E");
        window.close();
    }

//반려
    function RefundApp()
    {
        var doc_no = "<%=rfq_no%>";
        var doc_seq = "<%=rfq_count%>";

        opener.sign_Close_RFQ(doc_no,doc_seq,"R");
        window.close();
    }
	function ozCall(){
		<%for(int i=0;i<vendor_cnt;i++){%>
			url = '/oz/oz_rfq_genjuk.jsp';
	   		url += '?house_code=<%=house_code%>';
    		url += '&rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>';
    		url += '&qta_no=1&vendor_code=<%=VENDOR_CODE[i]%>';
    		//alert(url);
    		window.open( url,"ozCall<%=i%>","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=800,height=600,left=100,top=100");
    	<%}%>
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
function doOnRowSelected(rowId,cellInd){
    //alert(GridObj.cells(rowId, cellInd).getValue());
    var url = "";
    if(cellInd == GridObj.getColIndexById("ITEM_NO")) {
		var itemNo    = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
	        url       = '/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+encodeUrl(itemNo) + '&screen_flag=search&popup_flag=true';
		popUpOpen(url, 'GridCellClick', '800', '700');
		//window.open("rfq_bd_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=650,left=0,top=0");
	}else if(cellInd == GridObj.getColIndexById("VENDOR_CNT")) {
    	var rfqNo    = "<%=rfq_no%>";
	    var rfqCount = "<%=rfq_count%>";
	    var rfqSeq   = SepoaGridGetCellValueId(GridObj, rowId, "RFQ_SEQ");
	    if("OP" != "<%=RFQ_TYPE%>" ){	
	    	//견적업체 선택
    	    url      = '/kr/dt/rfq/rfq_pp_dis7.jsp?rfq_no='+rfqNo + '&rfq_count='+rfqCount+'&rfq_seq='+rfqSeq+'&screen_flag=search&popup_flag=true';
    		popUpOpen(url, 'GridCellClick', '650', '350');
	    }else{
	    	alert("공개견적은 업체가 없습니다.");
	    }
    
    }else if(cellInd == IDX_ATT_COUNT) { //파일
		var ATTACH_NO = SepoaGridGetCellValueId(GridObj, rowId, "ATTACH_NO");		//GD_GetCellValueIndex(document.WiseGrid,msg2, IDX_ATTACH_NO);
//		if(ATTACH_NO != "N") FileAttach('RFQ',ATTACH_NO,'VI');

		if(ATTACH_NO != "") {
			FileAttach_Grid('RFQ',ATTACH_NO,'VI','');
			
			//rMateFileAttach('P','R','RFQ',ATTACH_NO);
		}
	} 
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

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<form name="form1" action="">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">
	<%--ClipReport4 hidden 태그 끝--%>	
	
	<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="attach_gubun" value="body">

	<input type="hidden" id="rfq_no"  	name="rfq_no"  		value="<%=rfq_no%>">
	<input type="hidden" id="rfq_count" name="rfq_count"  	value="<%=rfq_count%>">

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="PC_REASON" value="<%=PC_REASON %>">
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
			<%=rfq_no%>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수
		</td>
		<td class="data_td">
			<%=rfq_count%>
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
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청형태</td>
		<td class="data_td" colspan="3">
			<%=RFQ_TYPE_TEXT%><BR>
			<% if(!PC_REASON.equals("")){%>
			사유 : <%=PC_REASON%>
			<% }%>		
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비교방식
		</td>
		<td width="35%" class="data_td">
		<%=SETTLE_TYPE_TEXT%>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건
		</td>
		<td width="35%" class="data_td">
			<%=DELY_TERMS_TEXT%>
		</td>
	
	</tr>	
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>	
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건
		</td>
		<td width="35%" class="data_td" colspan="3">
			<%=PAY_TERMS_TEXT%>
		</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항
		</td>
		<td width="35%" class="data_td" colspan="3">
          <%=REMARK.replaceAll("\n", "<br/>") %>
        </td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
	<td class="data_td" colspan="3" height="150">
		<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
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
		      			<%if(!RQAN_CNT.equals("0")){ %>
	    	  			<TD><script language="javascript">btn("javascript:openPopup2()","제안설명회")    </script></TD>
	    	  			<%}%>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>
<%-- <script language="javascript">rMateFileAttach('S','R','RFQ',form1.attach_no.value);</script> --%>

</s:header>
<s:grid screen_id="RQ_232" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


