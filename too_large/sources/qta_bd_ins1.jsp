<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_233");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_233";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
%>
<% String WISEHUB_PROCESS_ID="RQ_233";%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript" type="text/javascript">
<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");

    String flag         = JSPUtil.nullToEmpty(request.getParameter("flag"));
    String Next         = JSPUtil.nullToEmpty(request.getParameter("Next"));
    String RFQ_NO       = JSPUtil.nullToEmpty(request.getParameter("st_rfq_no"));
    String RFQ_COUNT    = JSPUtil.nullToEmpty(request.getParameter("st_rfq_count"));

    String VENDOR_CODE  = JSPUtil.nullToEmpty(request.getParameter("st_vendor_code"));
    String VENDOR_NAME  = JSPUtil.nullToEmpty(request.getParameter("st_vendor_name"));

    String nu_num       = JSPUtil.nullToEmpty(request.getParameter("nu_num"));
    String max_row      = JSPUtil.nullToEmpty(request.getParameter("max_row"));
    String cur_count    = JSPUtil.nullToEmpty(request.getParameter("cur_count"));

    String current_date = SepoaDate.getShortDateString();   // 오늘날짜 ex)yyyymmdd
    String current_time = SepoaDate.getShortTimeString();   // 오늘시간 ex)HHmmss
    String current_hour = current_time.substring(0,2);

    String date_time    = current_date + current_hour;

	String SUBJECT                = "";
	String COMPANY_CODE           = "";
	String RFQ_CLOSE_DATE_VIEW    = "";
	String RFQ_CLOSE_DATE         = "";
	String RFQ_CLOSE_TIME         = "";
	String DELY_TERMS             = "";
	String DELY_TERMS_TEXT        = "";
	String PAY_TERMS              = "";
	String PAY_TERMS_TEXT         = "";
	String CUR                    = "";
	String SETTLE_TYPE            = "";
	String SETTLE_TYPE_TEXT       = "";
	String TERM_CHANGE_FLAG       = "";
	String VALID_FROM_DATE_VIEW   = "";
	String VALID_TO_DATE_VIEW     = "";
	String RFQ_TYPE               = "";
	String RFQ_TYPE_TEXT          = "";
	String SPRICE_TYPE             = "";
	String PRICE_TYPE_TEXT        = "";
	String SHIPPING_METHOD        = "";
	String SHIPPING_METHOD_TEXT   = "";
	String USANCE_DAYS            = "";
	String USANCE_DAYS_TEXT       = "";
	String DEPART_PORT            = "";
	String DEPART_PORT_NAME       = "";
	String ARRIVAL_PORT           = "";
	String ARRIVAL_PORT_NAME      = "";
	String DOM_EXP_FLAG           = "";
	String DOM_EXP_FLAG_TEXT      = "";
	String SHIPPER_TYPE           = "D";
	String SHIPPER_TYPE_TEXT      = "";
	String QTA_VAL_DATE           = "";
	String RFQ_REMARK             = "";
	String REMARK                 = "";
	String RQAN_CNT               = "";
	String BEFORE_QTA_NO          = "";
	String QTA_NO                 = "";

	String Z_SMS_SEND_FLAG        = "";
	String Z_RESULT_OPEN_FLAG     = "";


    int rw_cnt = -1;

    String msg = "";

	String ADD_USER_NAME	 	= "";
	String CREATE_TYPE			= "";
	String BID_REQ_TYPE    		= "";
	String GROUP_YN = "N";
	String RFQ_ATT_COUNT		= "";
	String QTA_ATTACH_CNT		= "";
	String RFQ_ATTACH_NO		= "";
	String QTA_ATTACH_NO		= "";

	//다음 업체 버튼을 눌렀을때
    if (Next.equals("Y")) {
        Object[] obj = {RFQ_NO,RFQ_COUNT,nu_num, max_row};
        SepoaOut value = ServiceConnector.doService(info, "p1071", "CONNECTION", "getQuery_RFQVENDOR_NEXT", obj);

        SepoaFormater wf = new SepoaFormater(value.result[0]);

        rw_cnt = wf.getRowCount();

        VENDOR_CODE         = wf.getValue("VENDOR_CODE",0);
        VENDOR_NAME         = wf.getValue("NAME",0);
        nu_num              = wf.getValue("R_NUM",0);
    }

	//조회 버튼을 눌렀을때..
    if(flag.equals("Y")) {
        Object[] obj = {RFQ_NO, RFQ_COUNT, VENDOR_CODE};
        SepoaOut value = ServiceConnector.doService(info, "p1071", "TRANSACTION", "getQtaCreateHD", obj);
        /*
        	자동견적요청 재생성을 하기 위해 TRANSACTION 사용 했음.
        */
        SepoaFormater wf = new SepoaFormater(value.result[0]);
        rw_cnt = wf.getRowCount();
		 if(rw_cnt == 1) {
            SUBJECT                   = wf.getValue("SUBJECT", 0);
            COMPANY_CODE              = wf.getValue("COMPANY_CODE        ", 0);
            RFQ_CLOSE_DATE_VIEW       = wf.getValue("RFQ_CLOSE_DATE_VIEW ", 0);
            RFQ_CLOSE_DATE            = wf.getValue("RFQ_CLOSE_DATE      ", 0);
            RFQ_CLOSE_TIME            = wf.getValue("RFQ_CLOSE_TIME      ", 0);
            DELY_TERMS                = wf.getValue("DELY_TERMS          ", 0);
            DELY_TERMS_TEXT           = wf.getValue("DELY_TERMS_TEXT     ", 0);
            PAY_TERMS                 = wf.getValue("PAY_TERMS           ", 0);
            PAY_TERMS_TEXT            = wf.getValue("PAY_TERMS_TEXT      ", 0);
            CUR                       = wf.getValue("CUR                 ", 0);
            SETTLE_TYPE               = wf.getValue("SETTLE_TYPE         ", 0);
            SETTLE_TYPE_TEXT          = wf.getValue("SETTLE_TYPE_TEXT    ", 0);
            TERM_CHANGE_FLAG          = wf.getValue("TERM_CHANGE_FLAG    ", 0);
            VALID_FROM_DATE_VIEW      = wf.getValue("VALID_FROM_DATE_VIEW", 0);
            VALID_TO_DATE_VIEW        = wf.getValue("VALID_TO_DATE_VIEW  ", 0);
            RFQ_TYPE                  = wf.getValue("RFQ_TYPE            ", 0);
            RFQ_TYPE_TEXT             = wf.getValue("RFQ_TYPE_TEXT       ", 0);
            SPRICE_TYPE                = wf.getValue("PRICE_TYPE          ", 0);
            PRICE_TYPE_TEXT           = wf.getValue("PRICE_TYPE_TEXT     ", 0);
            SHIPPING_METHOD           = wf.getValue("SHIPPING_METHOD     ", 0);
            SHIPPING_METHOD_TEXT      = wf.getValue("SHIPPING_METHOD_TEXT", 0);
            USANCE_DAYS               = wf.getValue("USANCE_DAYS         ", 0);
            USANCE_DAYS_TEXT          = wf.getValue("USANCE_DAYS_TEXT    ", 0);
            DEPART_PORT               = wf.getValue("DEPART_PORT         ", 0);
            DEPART_PORT_NAME          = wf.getValue("DEPART_PORT_NAME    ", 0);
            ARRIVAL_PORT              = wf.getValue("ARRIVAL_PORT        ", 0);
            ARRIVAL_PORT_NAME         = wf.getValue("ARRIVAL_PORT_NAME   ", 0);
            DOM_EXP_FLAG              = wf.getValue("DOM_EXP_FLAG        ", 0);
            DOM_EXP_FLAG_TEXT         = wf.getValue("DOM_EXP_FLAG_TEXT   ", 0);
            SHIPPER_TYPE              = JSPUtil.nullToRef(wf.getValue("SHIPPER_TYPE        ", 0), "D");
            SHIPPER_TYPE_TEXT         = wf.getValue("SHIPPER_TYPE_TEXT   ", 0);
            QTA_VAL_DATE              = JSPUtil.nullToRef(wf.getValue("QTA_VAL_DATE        ", 0), SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),+1));
            RFQ_REMARK                = wf.getValue("RFQ_REMARK          ", 0);
            REMARK                    = wf.getValue("REMARK              ", 0);
            RQAN_CNT                  = wf.getValue("RQAN_CNT            ", 0);
            BEFORE_QTA_NO             = wf.getValue("BEFORE_QTA_NO       ", 0);
            QTA_NO                    = wf.getValue("QTA_NO              ", 0);
            Z_SMS_SEND_FLAG           = wf.getValue("Z_SMS_SEND_FLAG", 0);
            Z_RESULT_OPEN_FLAG        = wf.getValue("Z_RESULT_OPEN_FLAG", 0);
    		ADD_USER_NAME	 			= wf.getValue("ADD_USER_NAME", 0);
			CREATE_TYPE					= wf.getValue("CREATE_TYPE", 0);
			BID_REQ_TYPE    			= wf.getValue("BID_REQ_TYPE", 0);
			RFQ_ATT_COUNT				= wf.getValue("RFQ_ATT_COUNT", 0);
			QTA_ATTACH_CNT		 		= wf.getValue("QTA_ATTACH_CNT", 0);
			RFQ_ATTACH_NO			 	= wf.getValue("RFQ_ATTACH_NO", 0);
			QTA_ATTACH_NO		 		= wf.getValue("QTA_ATTACH_NO", 0);
        }
		 
	       
    }

    String pay_terms = ListBox(request, "SL0127",  HOUSE_CODE+"#M010#"+SHIPPER_TYPE+"#", PAY_TERMS);
    Configuration con = new Configuration();
	String buyer_code = "";//con.get("sepoa.company.code");
%>

		<!-- 사용자 정의 Script -->
		<!-- HEADER START (JavaScript here)-->
<!--
	var mode;
    var G_Pos= -1;
    var Arow;
    var summaryCnt = 0;

	var INDEX_SELECTED        ;
	var INDEX_ITEM_NO         ;
	var INDEX_DESCRIPTION_LOC ;
	var INDEX_SPECIFICATION   ;
	var INDEX_RFQ_QTY         ;
	var INDEX_ITEM_QTY        ;
	var INDEX_VENDOR_ITEM_NO  ;
	var INDEX_UNIT_MEASURE    ;
	var INDEX_UNIT_PRICE      ;
	var INDEX_UNIT_PRICE_IMG  ;
	var INDEX_BEFORE_PRICE    ;
	var INDEX_ITEM_AMT        ;
	var INDEX_DELIVERY_LT     ;
	var INDEX_RD_DATE         ;
	var INDEX_DELY_TO_LOCATION_NAME ;
	var INDEX_YEAR_QTY        ;
	var INDEX_RFQ_ATTACH_NO   ;
	var INDEX_QTA_ATTACH_NO   ;
	var INDEX_PRICE_DOC       ;
	var INDEX_MOLDING_CHARGE  ;
	var INDEX_PURCHASER       ;
	var INDEX_PURCHASER_PHONE ;
	var INDEX_RFQ_SEQ         ;
	var INDEX_MAKER_CODE      ;
	var INDEX_MAKER_NAME      ;
	var INDEX_EP_FROM_DATE    ;
	var INDEX_EP_TO_DATE      ;
	var INDEX_EP_FROM_QTY     ;
	var INDEX_EP_TO_QTY       ;
	var INDEX_EP_UNIT_PRICE   ;
	var INDEX_DELY_TO_LOCATION;
	var INDEX_SHIPPER_TYPE    ;
	var INDEX_MOLDING_FLAG    ;
	var INDEX_MOLDING_PROSPECTIVE_QTY;
	var INDEX_CUSTOMER_PRICE					;
	var INDEX_CUSTOMER_AMT						;
	var INDEX_SUPPLY_PRICE						;
	var INDEX_SUPPLY_AMT						;
	var INDEX_HUMAN_NAME_LOC	;
	var INDEX_CONTRACT_DIV		;
	var INDEX_ITEM_GBN		;
	//var INDEX_SEC_VENDOR_CODE_TEXT	;
	var INDEX_SEC_VENDOR_CODE	;
	var INDEX_MATERIAL_CTRL_TYPE		;
	var INDEX_RATE		;
	
	function init() {
		setGridDraw();
		setHeader();
<%
        if(rw_cnt == 0 ) {
%>
            alert("견적서 입력대행한 업체입니다.");
<%
        } else if(rw_cnt > 0 ){
%>
            //document.forms[0].st_rfq_count.value = "2";
<%
        }
%>
    }

    function setHeader() {

		//GridObj.bHDSwapping = false;
		//GridObj.bHDMoving = false;
		//GridObj.nHDLineSize  = 32;

		var frm = document.forms[0];

/* 
        GridObj.AddHeader("UNIT_PRICE_IMG"   			,""					,"t_imagetext"	,1000,0,false);
        //GridObj.AddHeader("SEC_VENDOR_CODE_TEXT"   	,"재하도급업체명" 			,"t_imagetext"	,100	,90	,false);
		

	    GridObj.AddGroup("CUSTOMER_PRICE", "List Price");
 		GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_PRICE");
  		GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_AMT");
	    GridObj.AddGroup("SUPPLY_PRICE", "공급가");
 		GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_PRICE");
  		GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_AMT");

		GridObj.SetColCellSortEnable("DESCRIPTION_LOC",false);
		GridObj.SetColCellSortEnable("SPECIFICATION",false);
		GridObj.SetNumberFormat("RFQ_QTY",G_format_qty);
		GridObj.SetNumberFormat("RATE",G_format_qty);
		GridObj.SetColCellSortEnable("RFQ_QTY",false);
		GridObj.SetNumberFormat("ITEM_QTY",G_format_qty);
		GridObj.SetColCellSortEnable("ITEM_QTY",false);
		GridObj.SetColCellSortEnable("UNIT_MEASURE",false);
		GridObj.SetNumberFormat("CUSTOMER_PRICE",G_format_unit);
		GridObj.SetNumberFormat("SUPPLY_PRICE",G_format_unit);
		GridObj.SetNumberFormat("CUSTOMER_AMT",G_format_unit);
		GridObj.SetNumberFormat("SUPPLY_AMT",G_format_unit);
		GridObj.SetNumberFormat("BEFORE_PRICE",G_format_unit);
		GridObj.SetNumberFormat("ITEM_AMT",G_format_amt);
		GridObj.SetDateFormat("DELIVERY_LT","yyyy/MM/dd");
		GridObj.SetDateFormat("RD_DATE","yyyy/MM/dd");
		GridObj.SetColCellSortEnable("RD_DATE",false);
		GridObj.SetNumberFormat("YEAR_QTY",G_format_qty);
		GridObj.SetColCellSortEnable("YEAR_QTY",false);
		GridObj.SetNumberFormat("MOLDING_PROSPECTIVE_QTY",G_format_unit);
		GridObj.SetNumberFormat("MOLDING_CHARGE",G_format_unit);
		GridObj.SetColCellSortEnable("EP_FROM_DATE",false);
		GridObj.SetColCellSortEnable("EP_TO_DATE",false);
		GridObj.SetColCellSortEnable("EP_FROM_QTY",false);
		GridObj.SetColCellSortEnable("EP_TO_QTY",false);
		GridObj.SetColCellSortEnable("EP_UNIT_PRICE",false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION",false);
		GridObj.SetColCellSortEnable("SHIPPER_TYPE",false);
		GridObj.SetColCellSortEnable("MOLDING_FLAG",false);
		GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd");
		GridObj.SetNumberFormat("DISCOUNT",       G_format_pctg); 
		
		*/


		INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
		INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
		INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
		INDEX_RFQ_QTY               = GridObj.GetColHDIndex("RFQ_QTY");

		INDEX_ITEM_QTY              = GridObj.GetColHDIndex("ITEM_QTY");
		INDEX_VENDOR_ITEM_NO        = GridObj.GetColHDIndex("VENDOR_ITEM_NO");
		INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("CUSTOMER_PRICE");
		INDEX_UNIT_PRICE_IMG        = GridObj.GetColHDIndex("UNIT_PRICE_IMG");

		INDEX_BEFORE_PRICE          = GridObj.GetColHDIndex("BEFORE_PRICE");
		INDEX_ITEM_AMT              = GridObj.GetColHDIndex("ITEM_AMT");
		INDEX_DELIVERY_LT           = GridObj.GetColHDIndex("DELIVERY_LT");
		INDEX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
		INDEX_DELY_TO_LOCATION_NAME = GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME");

		INDEX_YEAR_QTY              = GridObj.GetColHDIndex("YEAR_QTY");
		INDEX_RFQ_ATTACH_NO         = GridObj.GetColHDIndex("RFQ_ATTACH_NO");
		INDEX_QTA_ATTACH_NO         = GridObj.GetColHDIndex("QTA_ATTACH_NO");
		INDEX_PRICE_DOC             = GridObj.GetColHDIndex("PRICE_DOC");
		INDEX_MOLDING_CHARGE        = GridObj.GetColHDIndex("MOLDING_CHARGE");

		INDEX_PURCHASER             = GridObj.GetColHDIndex("PURCHASER");
		INDEX_PURCHASER_PHONE       = GridObj.GetColHDIndex("PURCHASER_PHONE");
		INDEX_RFQ_SEQ               = GridObj.GetColHDIndex("RFQ_SEQ");
		INDEX_MAKER_CODE            = GridObj.GetColHDIndex("MAKER_CODE");
		INDEX_MAKER_NAME            = GridObj.GetColHDIndex("MAKER_NAME");

		INDEX_EP_FROM_DATE           = GridObj.GetColHDIndex("EP_FROM_DATE");
		INDEX_EP_TO_DATE             = GridObj.GetColHDIndex("EP_TO_DATE");
		INDEX_EP_FROM_QTY            = GridObj.GetColHDIndex("EP_FROM_QTY");
		INDEX_EP_TO_QTY              = GridObj.GetColHDIndex("EP_TO_QTY");
		INDEX_EP_UNIT_PRICE          = GridObj.GetColHDIndex("EP_UNIT_PRICE");

		INDEX_DELY_TO_LOCATION       = GridObj.GetColHDIndex("DELY_TO_LOCATION");
		INDEX_SHIPPER_TYPE           = GridObj.GetColHDIndex("SHIPPER_TYPE");
		INDEX_MOLDING_FLAG           = GridObj.GetColHDIndex("MOLDING_FLAG");
		INDEX_MOLDING_PROSPECTIVE_QTY= GridObj.GetColHDIndex("MOLDING_PROSPECTIVE_QTY");

		INDEX_CUSTOMER_PRICE        = GridObj.GetColHDIndex("CUSTOMER_PRICE" );
		INDEX_CUSTOMER_AMT        	= GridObj.GetColHDIndex("CUSTOMER_AMT" );
		INDEX_SUPPLY_PRICE          = GridObj.GetColHDIndex("SUPPLY_PRICE" );
		INDEX_SUPPLY_AMT          	= GridObj.GetColHDIndex("SUPPLY_AMT" );
		INDEX_DISCOUNT				= GridObj.GetColHDIndex("DISCOUNT" );
		INDEX_HUMAN_NAME_LOC		= GridObj.GetColHDIndex("HUMAN_NAME_LOC");
		INDEX_CONTRACT_DIV         	= GridObj.GetColHDIndex("CONTRACT_DIV");
		INDEX_ITEM_GBN	         	= GridObj.GetColHDIndex("ITEM_GBN");
		
		//INDEX_SEC_VENDOR_CODE_TEXT     	= GridObj.GetColHDIndex("SEC_VENDOR_CODE_TEXT");
		INDEX_SEC_VENDOR_CODE     	= GridObj.GetColHDIndex("SEC_VENDOR_CODE");
		INDEX_MATERIAL_CTRL_TYPE   	= GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE");
		INDEX_RATE   	= GridObj.GetColHDIndex("RATE");

		if (("<%=RFQ_NO%>" != "") && ("<%=RFQ_COUNT%>" != "") && ("<%=VENDOR_CODE%>" != "") && (parseInt("<%=rw_cnt%>") > 0) )  {
        	getList();
        }
   }

    /*  조회
    */
    function getList() {
    	//alert("getList()381");
       <%--  GridObj.SetParam("VENDOR_CODE","<%=VENDOR_CODE%>");
        GridObj.SetParam("RFQ_NO","<%=RFQ_NO%>");
        GridObj.SetParam("RFQ_COUNT","<%=RFQ_COUNT%>");
        GridObj.SetParam("GROUP_YN","<%=GROUP_YN%>"); --%>

        
		$("#vendor_code").val("<%=VENDOR_CODE%>");
		$("#rfq_no").val("<%=RFQ_NO%>");
		$("#rfq_count").val("<%=RFQ_COUNT%>");
		$("#group_yn").val("<%=GROUP_YN%>");
		
		
 		<%-- var servletUrl = "<%=POASRM_CONTEXT_NAME %>/servlets/dt.rfq.qta_bd_ins1"; --%>
        //GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		//GridObj.SendData(servletUrl);
        
 		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins1";
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getQuery_Upd_Qta_Detail_Qta&grid_col_id="+grid_col_id;
		    param += dataOutput();
		GridObj.post(url, param);
		GridObj.clearAll(false);   
		
	
    } 

    function doSelect() {
        var frm             = document.forms[0];

        var st_rfq_no       = frm.st_rfq_no.value;
        var st_rfq_count    = frm.st_rfq_count.value;
        var st_vendor_code  = frm.st_vendor_code.value;

        if(LRTrim(st_rfq_no) == "" && LRTrim(st_rfq_count) == "") {
            alert("조회할 '견적요청번호'를 넣으셔야 합니다.");
            return;
        }

        if(LRTrim(st_rfq_no) == "" && LRTrim(st_rfq_count) == "") {
            alert("'견적요청번호' 와 '견적요청차수'는 반드시 같이 넣으셔야 합니다.");
            return;
        }

        if ((LRTrim(st_rfq_no) != "" && LRTrim(st_rfq_count) == "") ||
            (LRTrim(st_rfq_no) == "" && LRTrim(st_rfq_count) != "")) {
            alert("'견적요청번호' 와 '견적요청차수'는 반드시 같이 넣으셔야 합니다.");
            return;
        }

        if(st_rfq_count != "") {
            if(IsNumber(st_rfq_count) == false){
                alert("'견적요청차수'는 반드시 숫자를 넣으셔야 합니다.");
                return;
            }
        }


        if(st_vendor_code == "") {
            alert("'견적업체'를 반드시 입력하셔야 합니다.");
            return;
        }

        frm.cur_count.value = "1";

        frm.st_vendor_code.value = frm.st_vendor_code.value.toUpperCase();
        frm.st_rfq_no.value = frm.st_rfq_no.value.toUpperCase();

        frm.flag.value = "Y";

        document.forms[0].target = "_self";
        document.forms[0].action = "qta_bd_ins1.jsp";
        document.forms[0].method = "post";
        document.forms[0].submit();  
        
     	<%-- var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getQuery_Upd_Qta_Detail_Qta&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins1";
		GridObj.post(url, param);
		GridObj.clearAll(false);    --%>
    }
    
    function doSave() {
        var maxRow = GridObj.GetRowCount();

        var NET_AMT = 0;
        var ITEM_AMT_VALUE = 0;
        var checked_count = 0;
        
        var grid_array = getGridChangedRows(GridObj, "SELECTED");
		if (grid_array.length == 0 )
		{
			alert("견적 대상이 없습니다.");
			return;
		}
        
        if(LRTrim(form1.qta_val_date.value) == "")
        {
            alert("유효기간을 입력하세요.");
            form1.qta_val_date.focus();
            return;
        }

        if(eval(del_Slash(LRTrim(form1.qta_val_date.value))) < eval("<%=SepoaDate.getShortDateString()%>"))
        {
            alert("유효기간은 오늘날짜보다 커야합니다.");
            form1.qta_val_date.focus();
            return;
        }
        
        for(var i=0; i<maxRow; i++) {

            if( true == GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED)) {
                checked_count++;

                VENDOR_ITEM_NO_VALUE = GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_ITEM_NO);
                CUSTOMER_PRICE_VALUE = GD_GetCellValueIndex(GridObj,i,INDEX_CUSTOMER_PRICE);
                SUPPLY_PRICE_VALUE   = GD_GetCellValueIndex(GridObj,i,INDEX_SUPPLY_PRICE);
                BEFORE_PRICE         = GD_GetCellValueIndex(GridObj,i,INDEX_BEFORE_PRICE);
                DELIVERY_LT_VALUE    = GD_GetCellValueIndex(GridObj,i,INDEX_DELIVERY_LT);
                RD_DATE    			 = GD_GetCellValueIndex(GridObj,i,INDEX_RD_DATE);
                ITEM_QTY_VALUE       = GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_QTY);
                ITEM_AMT_VALUE       = GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_AMT);
                QTA_ATTACH_NO_VALUE  = GD_GetCellValueIndex(GridObj,i,INDEX_QTA_ATTACH_NO);
                PRICE_DOC_VALUE      = GD_GetCellValueIndex(GridObj,i,INDEX_PRICE_DOC);
                PRICE_DOC_TEXT       = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_PRICE_DOC),i);

				MOLDING_PROSPECTIVE_QTY= GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_MOLDING_PROSPECTIVE_QTY),i);
				MOLDING_CHARGE= GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_MOLDING_CHARGE),i);
				
				MATERIAL_CTRL_TYPE_VALUE      = GD_GetCellValueIndex(GridObj,i,INDEX_MATERIAL_CTRL_TYPE);
				RATE_VALUE      = GD_GetCellValueIndex(GridObj,i,INDEX_RATE);

				/* if (MOLDING_CHARGE!='' && MOLDING_PROSPECTIVE_QTY=='') {
					alert('금형비가 입력되어 있습니다. 금형예정소요량을 입력하여 주세요.');
					return;
				}
				if (MOLDING_PROSPECTIVE_QTY!='' && MOLDING_CHARGE=='') {
					alert(' 금형예정소요량가 입력되어 있습니다. 금형비을 입력하여 주세요.');
					return;
				} */

	<%if(BID_REQ_TYPE.equals("I")){	//입찰구분%>

                /* if(LRTrim(CUSTOMER_PRICE_VALUE) == ""){
                    alert(++i +"번째 줄에 LIST PRICE를 반드시 입력해야 합니다.");
                    return;
                }
                if(eval(CUSTOMER_PRICE_VALUE) <= 0 ){
                    alert(++i +"번째 줄에 LIST PRICE를 반드시 입력해야 합니다.");
                    return;
                } */

                if(LRTrim(SUPPLY_PRICE_VALUE) == ""){
                    alert(++i +"번째 줄에 공급가를 반드시 입력해야 합니다.");
                    return;
                }
                if(eval(SUPPLY_PRICE_VALUE) < 0 ){
                    alert(++i +"번째 줄에 공급가를 반드시 입력해야 합니다.");
                    return;
                }

                if(LRTrim(DELIVERY_LT_VALUE) == ""){
                    alert(++i +"번째 줄에 납기가능일을 반드시 입력해야 합니다.");
                    return;
                }
               
                if( eval(del_Slash(DELIVERY_LT_VALUE)) > eval(del_Slash(RD_DATE))){
                    alert(++i +"번째 줄에 납기가능일은 납기요청일 이전이어야 합니다.");
                    return;
                }
	<%}%>
               if(LRTrim(BEFORE_PRICE) != ""){
                   if(parseFloat(BEFORE_PRICE) < parseFloat(SUPPLY_PRICE) )
                         if(confirm((i+1) +"번째 줄에 견적단가가 이전 제시단가보다 높습니다. 생성하시겠습니까? ") == 0)
                             return;
               }

                if(parseInt(PRICE_DOC_TEXT) > 0) {
                    if(PRICE_DOC_VALUE.indexOf("$") < 0)
                    {
                        alert(++i +"번째 줄에 상세원가내역 단가를 반드시 입력해야 합니다.");
                        return;
                    }
                }
                
                if(MATERIAL_CTRL_TYPE_VALUE == "OS003"){
                	if(LRTrim(RATE_VALUE) == ""){
                		alert(++i +"번째 줄에 유지보수요율(%)을 반드시 입력해야 합니다.");
                        return;
                    }
                }

                if(ITEM_AMT_VALUE == "") ITEM_AMT_VALUE = 0;
                NET_AMT += eval(ITEM_AMT_VALUE);

            }
        }

        if(checked_count == 0)  {
            alert(G_MSS1_SELECT);
            return;
        }

        if("<%=SETTLE_TYPE%>" == "DOC") {
            if(parseInt(maxRow) != checked_count) {
                alert("Settle Type이 '품목별' 일 경우에는 품목을 모두 선택 하셔야 합니다. ");
                return;
            }
        }

		if(!confirm("제출하시겠습니까?")){
			return;
		}

		document.forms[0].net_amt.value = NET_AMT;
		
		
		//document.attachSFrame.setData();	//startUpload
		//첨부파일저장 기능 생략 바로 저장
		getApprovalSend();
    }

	function getApprovalSend() {
		var wForm = document.forms[0];

        var PAY_TERMS      = "";
        var TTL_CHARGE     = 0;

        var NET_AMT		   = wForm.net_amt.value;
        var REMARK         = wForm.remark.value;
        var QTA_VAL_DATE   = del_Slash(wForm.qta_val_date.value);
        var QTA_ATTACH_NO  = wForm.qta_attach_no.value;

         
		if("<%=QTA_NO%>" == ""){
			mode = "setQtInsert";
		}else {
			mode = "setQtUpdate";
		}

        <%-- GridObj.SetParam("mode",mode);
        GridObj.SetParam("QTA_NO","<%=QTA_NO%>");
        GridObj.SetParam("TTL_CHARGE",TTL_CHARGE);
        GridObj.SetParam("net_amt",NET_AMT);
        GridObj.SetParam("HOUSE_CODE","<%=HOUSE_CODE%>");
        GridObj.SetParam("VENDOR_CODE","<%=VENDOR_CODE%>");
        GridObj.SetParam("SUBJECT","<%=SUBJECT%>");
        GridObj.SetParam("RFQ_NO","<%=RFQ_NO%>");
        GridObj.SetParam("RFQ_COUNT","<%=RFQ_COUNT%>");
        GridObj.SetParam("PAY_TERMS",PAY_TERMS);
        GridObj.SetParam("PRICE_TYPE","<%=SPRICE_TYPE%>");
        GridObj.SetParam("COMPANY_CODE","<%=COMPANY_CODE%>");
        GridObj.SetParam("REMARK",REMARK);
        GridObj.SetParam("QTA_VAL_DATE",QTA_VAL_DATE);
        GridObj.SetParam("BID_REQ_TYPE","<%=BID_REQ_TYPE%>");
        GridObj.SetParam("qta_attach_no",		qta_attach_no); --%>

       // GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		//GridObj.SendData(servletUrl, "ALL", "ALL");
       
		$("#qta_no").val("<%=QTA_NO%>");
		$("#ttl_charge").val(TTL_CHARGE);
		$("#net_amt").val(NET_AMT);
		$("#vendor_code").val("<%=VENDOR_CODE%>");
		$("#subject").val("<%=SUBJECT%>");
		$("#rfq_no").val("<%=RFQ_NO%>");
		$("#rfq_count").val("<%=RFQ_COUNT%>");
		
		$("#pay_terms").val(PAY_TERMS);
		$("#price_type").val("<%=SPRICE_TYPE%>");
		$("#company_code").val("<%=COMPANY_CODE%>");
		$("#remark").val(REMARK);
		$("#qta_val_date").val(QTA_VAL_DATE);
		$("#bid_req_type").val("<%=BID_REQ_TYPE%>");
		$("#qta_attach_no").val(QTA_ATTACH_NO);
		
		
		<%-- servletUrl = "<%=getWiseServletPath("dt.rfq.qta_bd_ins1")%>"; --%>
        G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins1";
        
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
        var cols_ids = "<%=grid_col_id%>";
        var params;
        params = "?mode="+mode;
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        myDataProcessor = new dataProcessor(G_SERVLETURL+params);
        //myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
        sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
		
		
		
	}

	function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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
			if (company == "B") {			// Buyer
				f.target = "attachBFrame";
			} else if (company == "S") {	// Supplier
				f.target = "attachSFrame";
			}
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}

	<%-- //Supplier 만 첨부가능 --%>
	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj, Arow, INDEX_QTA_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.qta_attach_no.value    = attach_key;
		    f.qta_attach_count.value = attach_count;

		    getApprovalSend();
		}
	}

    function setAttach(attach_key, arrAttrach, attach_count) {
//        GD_SetCellValueIndex(GridObj,Arow, IDX_QTA_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
		if(document.form1.attach_gubun.value == "wise"){
        	GD_SetCellValueIndex(GridObj,Arow, INDEX_QTA_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
        }else{
			var f = document.forms[0];
		    f.qta_attach_no.value = attach_key;
		    f.qta_attach_count.value = attach_count;
		}
		document.form1.attach_gubun.value="body";
    }

    function POPUP_Open(url, title, left, top, width, height) {
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'no';
        var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        code_search.focus();
    }

    function setPriceInfo(comp_s_date, comp_e_date, comp_s_qty, comp_e_qty, comp_unit_price, max_unitprice)
    {
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_EP_FROM_DATE, comp_s_date);
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_EP_TO_DATE,comp_e_date);
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_EP_FROM_QTY,comp_s_qty);
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_EP_TO_QTY,comp_e_qty);
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_UNIT_PRICE,max_unitprice);
        GD_SetCellValueIndex(GridObj,G_Pos,IDX_EP_UNIT_PRICE,comp_unit_price);

        document.forms[0].t_from_date.value =  GD_GetCellValueIndex(GridObj,G_Pos, IDX_EP_FROM_DATE);
        document.forms[0].t_to_date.value =    GD_GetCellValueIndex(GridObj,G_Pos, IDX_EP_TO_DATE);
        document.forms[0].t_from_qty.value =   GD_GetCellValueIndex(GridObj,G_Pos, IDX_EP_FROM_QTY);
        document.forms[0].t_to_qty.value =     GD_GetCellValueIndex(GridObj,G_Pos, IDX_EP_TO_QTY);
        document.forms[0].t_unit_price.value = GD_GetCellValueIndex(GridObj,G_Pos, IDX_UNIT_PRICE);

    }

    function setCost(sendData)
    {
        var text = GridObj.GetCellValue(GridObj.GetColHDKey(IDX_PRICE_DOC),G_Pos);

        var temp = G_IMG_ICON + "&" + text + "&" +sendData;

        GD_SetCellValueIndex(GridObj,G_Pos,IDX_PRICE_DOC, temp, "&");

    }

    function searchProfile(fc) {

        var shipper_type = document.forms[0].SHIPPER_TYPE.value;
        if (fc == 'pay_method' ) {
            var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
            PopupCommonArr("SP9134", "getpay_method", arrv, "" );
        } else if(fc == "dely_terms" ) {
            var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
            PopupCommonArr("SP0232", "getdely_terms", arrv, "" );
        } else if(fc == "DEPART_PORT" ) {

            var ship_meth = "";

            if("<%=TERM_CHANGE_FLAG%>" == "N") {
                ship_meth = "<%=SHIPPING_METHOD%>";
            } else {
                ship_meth = document.forms[0].SHIPPING_METHOD.value;
            }

            var type = "";

            if(ship_meth != ""){
                if(ship_meth == "VSL") {
                    type = "S";
                } else if(ship_meth == "AIR"){
                    type = "A";
                } else if(ship_meth == "COM"){
                    type = "C";
                }

                var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", "M006", type);
                PopupCommonArr("SP0160", "getdely_terms", arrv, "" );
            } else {
                alert("내자건에 대해서는 출발항을 선택하실 수 없습니다.");
                return;
            }
        }
    }

	function getpay_method(code, text2) {
		document.forms[0].PAY_TERMS.value = code;
		document.forms[0].PAY_TERMS_TEXT.value = text2;
	}

    function  getdely_terms(nation_code, city_code, code, text1) {
        document.forms[0].DEPART_PORT.value = code;
        document.forms[0].DEPART_PORT_NAME.value = text1;
    }

    function  setRFQNO(rfq_no, rfq_count) {
        document.forms[0].st_rfq_no.value = rfq_no;
        document.forms[0].st_rfq_count.value = rfq_count;
    }

    function getRFQ_pop() {
        var url = "/kr/dt/rfq/rfq_no_pop_main.jsp";
        Code_Search(url,'','','','','');
    }

    function  setRFQvendor(num, vendor_code, vendor_name, max_row) {
        document.forms[0].nu_num.value = num;
        document.forms[0].st_vendor_code.value = vendor_code;
        document.forms[0].st_vendor_name.value = vendor_name;
        document.forms[0].max_row.value        = max_row;
    }

    function getRFQvendor_pop() {
        if(document.forms[0].st_rfq_no.value == "")	{
            alert("견적요청번호를 먼저 선택하셔야 합니다.");
            return;
        }

        if(document.forms[0].st_rfq_count.value == "") {
            alert("견적요청번호차수를 먼저 선택하셔야 합니다.");
            return;
        }

        var RFQ_NO = document.forms[0].st_rfq_no.value;
        var RFQ_COUNT = document.forms[0].st_rfq_count.value;

        var url = "/kr/dt/rfq/rfq_vendor_pop_main.jsp?RFQ_NO="+RFQ_NO+"&RFQ_COUNT="+RFQ_COUNT;

        Code_Search(url,'','','','','');
    }

    function QTA_VAL_DATE(year,month,day,week) {
        document.forms[0].qta_val_date.value=year+month+day;
    }

    function doNext() {
        var frm = document.forms[0];

        frm.st_vendor_code.value = frm.st_vendor_code.value.toUpperCase();
        frm.st_rfq_no.value = frm.st_rfq_no.value.toUpperCase();

        var st_rfq_no = frm.st_rfq_no.value;
        var st_rfq_count = frm.st_rfq_count.value;
        var st_vendor_code = frm.st_vendor_code.value;

        if(LRTrim(st_rfq_no) == "" && LRTrim(st_rfq_count) == "") {
            alert("'견적요청번호' 와 '견적요청차수'는 반드시 같이 넣으셔야 합니다.");
            return;
        }

        if ((LRTrim(st_rfq_no) != "" && LRTrim(st_rfq_count) == "") ||
            (LRTrim(st_rfq_no) == "" && LRTrim(st_rfq_count) != "")) {
            alert("'견적요청번호' 와 '견적요청차수'는 반드시 같이 넣으셔야 합니다.");
            return;
        }

        if(st_rfq_count != "") {
            if(IsNumber(st_rfq_count) == false){
                alert("'견적요청차수'는 반드시 숫자를 넣으셔야 합니다.");
                return;
            }
        }

        if(st_vendor_code == "") {
            alert("'견적업체'를 반드시 입력하셔야 합니다.");
            return;
        }

        var max_row = frm.max_row.value;

        if(parseInt(frm.cur_count.value) < parseInt(max_row)) {
            frm.flag.value = "Y";
            frm.Next.value = "Y";

            var ccc = parseInt(frm.cur_count.value);
            var tmp_count = ccc + 1;
            frm.cur_count.value = tmp_count;

            document.forms[0].target = "_self";
            document.forms[0].action = "qta_bd_ins1.jsp";
            document.forms[0].method = "post";
            document.forms[0].submit();
        } else {
            alert("다음 업체가 없습니다.");
            frm.cur_count.value = "";
            return;
        }
    }
    
	function setVendorCode( code, desc1, desc2) {
		
		GD_SetCellValueIndex(GridObj,document.forms[0].selected_Row.value,INDEX_SEC_VENDOR_CODE_TEXT,desc1);
		GD_SetCellValueIndex(GridObj,document.forms[0].selected_Row.value,INDEX_SEC_VENDOR_CODE,code);
		
	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    	var maxRow = GridObj.GetRowCount();
    	//alert("work:875=>"+msg1+"|"+maxRow+"|"+GridObj.GetRowCount()); 
    	
    	if(msg1 == "doQuery") {

            var wt = GridObj;
            var frm = document.forms[0];
            var row = wt.GetRowCount();
            var tmp_camt = 0;
            var tmp_samt = 0;
            var c_amt = 0;
            var s_amt = 0;
            var tmp_discount = 0;

            var maxRow = GridObj.GetRowCount();

            for(i=0; i<maxRow; i++) {
            	///alert("INDEX_SELECTED"+INDEX_SELECTED);
                /* GD_SetCellValueIndex(GridObj, i, INDEX_SELECTED, "true&", "&");

				customer_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE));
				supply_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE));

				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                tmp_camt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);

                GD_SetCellValueIndex(GridObj,i, INDEX_CUSTOMER_AMT, tmp_camt);
                c_amt = c_amt +  tmp_camt;

				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                tmp_samt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj,i, INDEX_SUPPLY_AMT, tmp_samt);

                if(eval(supply_unitPrice) == 0){
                	s_amt = s_amt + eval(GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_AMT));
                }else{
                	s_amt = s_amt +  tmp_samt;
                } */
            }

				form1.attach_count.value = "<%=RFQ_ATT_COUNT%>";
                form1.qta_attach_count.value = "<%=QTA_ATTACH_CNT%>";
				/* if(summaryCnt == 0) {
					GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'RFQ_QTY,CUSTOMER_AMT,SUPPLY_AMT,ITEM_AMT');
					GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
					summaryCnt++;
				} */
        }  // if 문끝
    	
    	
    	<%-- if(msg1 == "doQuery") {

             var wt = GridObj;
             var frm = document.forms[0];
             var row = wt.getRowCount();
             var tmp_camt = 0;
             var tmp_samt = 0;
             var c_amt = 0;
             var s_amt = 0;
             var tmp_discount = 0;

             var maxRow = GridObj.GetRowCount();

             for(i=0; i<maxRow; i++) {
                 GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "true&", "&");

 				customer_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE));
 				supply_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE));

 				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                 tmp_camt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);

                 GD_SetCellValueIndex(GridObj,i, INDEX_CUSTOMER_AMT, tmp_camt);
                 c_amt = c_amt +  tmp_camt;

 				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                 tmp_samt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
                 GD_SetCellValueIndex(GridObj,i, INDEX_SUPPLY_AMT, tmp_samt);

                 if(eval(supply_unitPrice) == 0){
                 	s_amt = s_amt + eval(GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_AMT));
                 }else{
                 	s_amt = s_amt +  tmp_samt;
                 }
             }

 				form1.attach_count.value = "<%=RFQ_ATT_COUNT%>";
                 form1.qta_attach_count.value = "<%=QTA_ATTACH_CNT%>";
 				if(summaryCnt == 0) {
 					GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'RFQ_QTY,CUSTOMER_AMT,SUPPLY_AMT,ITEM_AMT');
 					GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
 					summaryCnt++;
 				}
         }  // if 문끝 --%>


        var maxRow = GridObj.GetRowCount();

        if(msg1 == "doSave") {

            if(mode =="setQtUpdate" || mode =="setQtInsert"){
                alert(GD_GetParam(GridObj,0));
                if(GridObj.GetStatus() == "0") {
                    return;
                } else {
                    document.forms[0].flag.value = "";
                	document.forms[0].method="post";
					document.forms[0].target="_self";
					document.forms[0].action="qta_bd_ins1.jsp";
					document.forms[0].submit();
                }
            }
        }
        <%-- 
        if(msg1 == "doQuery") {

            var wt = GridObj;
            var frm = document.forms[0];
            var row = wt.getRowCount();
            var tmp_camt = 0;
            var tmp_samt = 0;
            var c_amt = 0;
            var s_amt = 0;
            var tmp_discount = 0;

            var maxRow = GridObj.GetRowCount();

            for(i=0; i<maxRow; i++) {
                GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "true&", "&");

				customer_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE));
				supply_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE));

				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                tmp_camt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);

                GD_SetCellValueIndex(GridObj,i, INDEX_CUSTOMER_AMT, tmp_camt);
                c_amt = c_amt +  tmp_camt;

				itemQty = parseFloat(GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY));
                tmp_samt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj,i, INDEX_SUPPLY_AMT, tmp_samt);

                if(eval(supply_unitPrice) == 0){
                	s_amt = s_amt + eval(GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_AMT));
                }else{
                	s_amt = s_amt +  tmp_samt;
                }
            }

				form1.attach_count.value = "<%=RFQ_ATT_COUNT%>";
                form1.qta_attach_count.value = "<%=QTA_ATTACH_CNT%>";
				if(summaryCnt == 0) {
					GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'RFQ_QTY,CUSTOMER_AMT,SUPPLY_AMT,ITEM_AMT');
					GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
					summaryCnt++;
				}
        }  // if 문끝

        var wt = GridObj;
        var frm = document.forms[0];
        var row = wt.getRowCount();

        if(msg3 == INDEX_UNIT_PRICE)
        {
        	if("<%=SPRICE_TYPE%>"== "Q" ){
	            G_Pos = msg2;
	            alert("가격조건이 물량차등가격일때는 수량별 가격정보를 확인하셔야 합니다.")
	            var loc2 = "qta_bd_ins1_q.jsp?XPosition="+ msg2 + "&FLAG=C";
	            window.open(loc2  , "qta_bd_ins1_q","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
	        } else if("<%=SPRICE_TYPE%>"== "P" ){
	            G_Pos = msg2;
	            alert("가격조건이 기간차등가격일때는 기간별 가격정보를 확인하셔야 합니다.")
	            var loc2 = "qta_bd_ins1_p.jsp?XPosition="+ msg2 + "&FLAG=C";
	            window.open(loc2  , "qta_bd_ins1_p","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
	        }
        }

        if(msg1 == "t_imagetext") {
            if(msg3 == INDEX_ITEM_NO)
            {
                var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
                POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
            }

            if(msg3 == INDEX_QTA_ATTACH_NO)
            {
				document.form1.attach_gubun.value = "wise";
                var QTA_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_QTA_ATTACH_NO));

                Arow = msg2;
                if("N" == QTA_ATTACH_NO_VALUE){
                	return;
                }

	<%if(BID_REQ_TYPE.equals("I")){%>
				rMateFileAttach('P','C','QTA',QTA_ATTACH_NO_VALUE,'S');
	<%}else{%>
                Arow = msg2;
	            var loc2 = "qta_pp_ins1.jsp?XPosition="+ msg2 + "&QTA_ATTACH_NO="+QTA_ATTACH_NO_VALUE;
	            window.open(loc2  , "qta_pp_ins1","left=0,top=0,width=1030,height=400,resizable=no,scrollbars=no");
	<%}%>
            }
            
//             if(msg3 == INDEX_SEC_VENDOR_CODE_TEXT) {
//             	frm.selected_Row.value = msg2;
//              	var SEC_VENDOR_CODE_TEXT = GD_GetCellValueIndex(GridObj, msg2, INDEX_SEC_VENDOR_CODE_TEXT);
				var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0087&function=setVendorCode&values=<%=info.getSession("HOUSE_CODE")%>&values=&values=/&desc=업체코드&desc=업체";
// 				CodeSearchCommon(url,'itemNoWin','50','100','570','530');
				
//             }

            if(msg3 == INDEX_RFQ_ATTACH_NO)
            {

                var RFQ_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_ATTACH_NO));
                if("N" != RFQ_ATTACH_NO_VALUE) {
					rMateFileAttach('P','R','RFQ',RFQ_ATTACH_NO_VALUE,'B');
                }
            }

			if(msg3 == INDEX_HUMAN_NAME_LOC) {
                var ITEM_NO_SUB = GridObj.GetCellValue("ITEM_GBN", msg2);

                if (ITEM_NO_SUB == "I" || ITEM_NO_SUB == "S") {
            	}else {
            		G_Pos = msg2;
            		SP0272_Popup()
            	}
            }

            if(msg3 == INDEX_PRICE_DOC)
            {
                var PRICE_DOC_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_PRICE_DOC));

                var wt = GridObj;

                var RFQ_SEQ = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_SEQ);
                var unitPrice = GD_GetCellValueIndex(GridObj,msg2, INDEX_UNIT_PRICE);
                var VENDOR_CODE = document.forms[0].st_vendor_code.value;

                G_Pos = msg2;

                if(  "0" == unitPrice || "" == unitPrice ) {
                    alert("먼저 단가를 입력하시기 바랍니다.");
                }else{
                    if( "0" != PRICE_DOC_VALUE ) {
                        window.open('qta_pp_ins7.jsp?XPosition='+ msg2 + '&RFQ_NO=<%=RFQ_NO%>&RFQ_COUNT=<%=RFQ_COUNT%>&RFQ_SEQ=' + RFQ_SEQ +'&PRICE_DOC=' +PRICE_DOC_VALUE + '&VENDOR_CODE=' + VENDOR_CODE + '&unitPrice=' + unitPrice,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=465,height=300,left=0,top=0");
                    }
                }
            }

	        if(msg3 == INDEX_UNIT_PRICE_IMG)
	        {
	            var wt = GridObj;
	            var row = wt.getRowCount();
	            G_Pos = msg2;

	            var qta_price = GD_GetCellValueIndex(GridObj,msg2,INDEX_UNIT_PRICE);

	            for(var i=0; i<row; i++)
	            {
	                 if("<%=SPRICE_TYPE%>" == "N")
	                {
	                    alert("직접 입력하시면 됩니다.");
	                    return;
	                } else if("<%=SPRICE_TYPE%>" == "P")
	                {
	                    if(qta_price == "") {
	                        alert("먼저 견적단가를 입력하세요.");
	                        return;
	                    }
	                    var loc2 = "qta_bd_ins1_p.jsp?XPosition="+ msg2 + "&FLAG=C";
	                    window.open(loc2  , "qta_bd_ins1_p","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
	                } else if("<%=SPRICE_TYPE%>" == "Q")
	                {
	                    if(qta_price == "") {
	                        alert("먼저 견적단가를 입력하세요.");
	                        return;
	                    }
	                    var loc2 = "qta_bd_ins1_q.jsp?XPosition="+ msg2 + "&FLAG=C";
	                    window.open(loc2  , "qta_bd_ins1_q","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
	                } else if("<%=SPRICE_TYPE%>" == "V")
	                {
	                    if(qta_price == "") {
	                        alert("먼저 견적단가를 입력하세요.");
	                        return;
	                    }
	                    var loc2 = "qta_bd_ins1_v.jsp?XPosition="+ msg2 + "&FLAG=C";
	                    window.open(loc2  , "qta_bd_ins1_v","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
	                }
	            }

	        }
        } // t_imagetext

        if(msg1 == "t_insert") {
            if(msg3 == INDEX_UNIT_PRICE || msg3 == INDEX_ITEM_QTY) {

					unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,msg2, INDEX_UNIT_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,msg2, INDEX_UNIT_PRICE));
					itemQty 	= parseFloat(GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_QTY) 	== "" ? "0" : GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_QTY));

                    var tmp_amt = RoundEx(eval(unitPrice) * eval(itemQty), 3);
                    GD_SetCellValueIndex(GridObj,msg2, INDEX_ITEM_AMT, tmp_amt);

            		var row = GridObj.GetRowCount();

            }
        }

        if(msg1 == "t_insert") {

            if(msg3 == INDEX_CUSTOMER_PRICE) {
 						setSum(msg2);
            }
            if(msg3 == INDEX_SUPPLY_PRICE) {
 						setSum(msg2);
            }
        } --%>
    }  // JAVACALL 끝

    function setSum(msg2) {
		var tmp_discount = 0;
		var customer_unitPrice = 0;
		var supply_unitPrice = 0;
		var itemQty = 0;

		customer_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,msg2, INDEX_CUSTOMER_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,msg2, INDEX_CUSTOMER_PRICE));
		itemQty 			= parseFloat(GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_QTY));
		supply_unitPrice    = parseFloat(GD_GetCellValueIndex(GridObj,msg2, INDEX_SUPPLY_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,msg2, INDEX_SUPPLY_PRICE));
		//alert("setSum="+customer_unitPrice);
        var tmp_amt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);
        GD_SetCellValueIndex(GridObj,msg2, INDEX_CUSTOMER_AMT, tmp_amt);

        //alert("setSum="+supply_unitPrice);
        var tmp_amt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
	    GD_SetCellValueIndex(GridObj,msg2, INDEX_SUPPLY_AMT, tmp_amt);

		if( customer_unitPrice > 0 && supply_unitPrice > 0) {
			tmp_discount = customer_unitPrice== "0" ? "0.00" : (eval(customer_unitPrice) - eval(supply_unitPrice))/ eval(customer_unitPrice);
			tmp_discount = RoundEx( (tmp_discount * 100) ,3) ;
		} else {
			tmp_discount = "0.00";
		}

        if( eval(tmp_discount) == 100) tmp_discount = "0.00";
        	GD_SetCellValueIndex(GridObj,msg2, INDEX_DISCOUNT, tmp_discount);

	}

	//개발자 이름
	function SP0272_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';

		var st_vendor_code = document.forms[0].st_vendor_code.value;

        if (st_vendor_code == "") {
            alert("'견적업체'를 반드시 입력하셔야 합니다.");
            return;
        }

//		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0272&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=buyer_code%>&values=<%=info.getSession("COMPANY_CODE")%>";
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0272&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=buyer_code%>&values="+st_vendor_code;
		//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		CodeSearchCommon(url, 'doc', left, top, width, height);
	}

	function  SP0272_getCode(ls_human_no, ls_name_loc) {
		GD_SetCellValueIndex(GridObj, G_Pos, INDEX_HUMAN_NAME_LOC, G_IMG_ICON + "&" + ls_name_loc + "&" + ls_human_no, "&");
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
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
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

function changeMoney(mon)
{
	var money = del_comma(mon);

	if(money == 0){
		alert("값을 입력하세요");
		return false;
	}
	if(isNaN(Number(del_comma(mon)))){
		alert("숫자로 입력하세요");
		
		return false;
	}
	if(money.length>13){
		alert("가용한 금액의 크기를 넘었습니다.");		
		return false;
	}
	if(money.indexOf(".")>=0){
		alert("정수로 입력하십시오");
		return false;
	}
	if(money.indexOf("-")>=0){
		alert("양수로 입력하십시오");
		return false;
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
    	
    	var INDEX_RFQ_QTY            	= GridObj.getColIndexById("RFQ_QTY");			//수량
    	var INDEX_CUSTOMER_PRICE 		= GridObj.getColIndexById("CUSTOMER_PRICE");	//ListPrice 단가
    	var INDEX_CUSTOMER_AMT          = GridObj.getColIndexById("CUSTOMER_AMT");		//ListPrice 금액
    	
    	var INDEX_SUPPLY_PRICE 		    = GridObj.getColIndexById("SUPPLY_PRICE");			//공급가 단가
    	var INDEX_SUPPLY_AMT            = GridObj.getColIndexById("SUPPLY_AMT");			//공급가 금액

    	var rowIndex                    = GridObj.getRowIndex(GridObj.getSelectedId());
		    	
    	var customer_unitPrice          = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_CUSTOMER_PRICE);
    	var supply_unitPrice            = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_SUPPLY_PRICE);
    	var tmp_discount = 0;
    	
		var header_name = GridObj.getColumnId(cellInd);
		
		if(header_name == "SUPPLY_PRICE"){ 
    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
	    		GridObj.cells(rowId, cellInd).setValue("");
				return true;
			}
    	}
		
    	
    	if(cellInd == INDEX_CUSTOMER_PRICE){
	   		calculate_grid_amt(GridObj, rowIndex, INDEX_RFQ_QTY, INDEX_CUSTOMER_PRICE, "1", "CUSTOMER_AMT");
    	}else if(cellInd == INDEX_SUPPLY_PRICE){
    		calculate_grid_amt(GridObj, rowIndex, INDEX_RFQ_QTY, INDEX_SUPPLY_PRICE, "1", "SUPPLY_AMT");
    	}
    	

		if( customer_unitPrice > 0 && supply_unitPrice > 0) {
			tmp_discount = customer_unitPrice== "0" ? "0.00" : (eval(customer_unitPrice) - eval(supply_unitPrice))/ eval(customer_unitPrice);
			tmp_discount = RoundEx( (tmp_discount * 100) ,3) ;
		} else {
			tmp_discount = "0.00";
		}

		if( eval(tmp_discount) == 100) tmp_discount = "0.00";
     	
		GridObj.cells(GridObj.getSelectedId(), INDEX_DISCOUNT).setValue(tmp_discount);
        
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
   /*  if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    }  */

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
    
    document.form1.qta_val_date.value = add_Slash( document.form1.qta_val_date.value );
    gridSelectAll();
    return true;
}

/* 파일 업로드 */
function goAttach(attach_no){
	attach_file(attach_no,"FILE");
}

function setAttach(attach_key, arrAttrach, attach_count) {
	document.form1.sign_attach_no2.value = attach_key;
	document.form1.sign_attach_no2_count.value = attach_count;
}


var selectAllFlag = 0;

/*
첫번째 행의 납기가능일 모든 행에 일괄적용
*/
function setDeliveryData() {
	
	var DELIVERY_LT = '';
	
	var iRowCount = GridObj.GetRowCount();
	
	for(var i = 0; i < iRowCount; i++) {
		if(i == 0) {
			DELIVERY_LT = GD_GetCellValueIndex(GridObj, i, INDEX_DELIVERY_LT);
			
		} else {
			if(isEmpty(DELIVERY_LT)){
				alert('첫번째 행의 납기가능일을 입력하십시오.');
				return;
			} else {
				GD_SetCellValueIndex(GridObj,i, INDEX_DELIVERY_LT, DELIVERY_LT);				
			}
		}
	}
	
}



</script>
</head>
	<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
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
<form name="form1" action="">
	
	<input type="hidden" name="qta_no" id="qta_no" value="<%=QTA_NO%>">
	<input type="hidden" name="ttl_charge" id="ttl_charge" value="">
	<input type="hidden" name="vendor_code" id="vendor_code" value="<%=VENDOR_CODE%>">
	<input type="hidden" name="subject" id="subject" value="<%=SUBJECT%>">
	<input type="hidden" name="price_type" id="price_type" value="<%=PRICE_TYPE%>">
	<input type="hidden" name="bid_req_type" id="bid_req_type" value="<%=BID_REQ_TYPE%>">
	
	<input type="hidden" name="flag" id="flag">
	<input type="hidden" name="Next" id="Next">
	<input type="hidden" name="h_rfq_close_date" id="h_rfq_close_date" value="<%=RFQ_CLOSE_DATE%>">
	<input type="hidden" name="h_rfq_close_time" id="h_rfq_close_time" value="<%=RFQ_CLOSE_TIME%>">
	<input type="hidden" name="t_from_date" id="t_from_date">
	<input type="hidden" name="t_to_date" id="t_to_date">
	<input type="hidden" name="t_from_qty" id="t_from_qty">
	<input type="hidden" name="t_to_qty" id="t_to_qty">
	<input type="hidden" name="t_unit_price" id="t_unit_price">
	<input type="hidden" name="nu_num"  id="nu_num" value="<%=nu_num%>">
	<input type="hidden" name="max_row"  id="max_row" value="<%=max_row%>">
	<input type="hidden" name="cur_count"  id="cur_count" value="<%=cur_count%>">
	<input type="hidden" name="shipper_type"  id="shipper_type" value="<%=SHIPPER_TYPE%>">

	<input type="hidden" name="attach_no"  id="attach_no" value="<%=RFQ_ATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="attach_gubun"  id="attach_gubun" value="body">
	<input type="hidden" name="net_amt"  id="net_amt" >
	<input type="hidden" name="qta_attach_no"  id="qta_attach_no" value="<%=QTA_ATTACH_NO%>">
	<input type="hidden" name="qta_attach_count"  id="qta_attach_count" >

	<input type="hidden" name="att_mode"   id="att_mode"  value="">
	<input type="hidden" name="view_type"   id="view_type"  value="">
	<input type="hidden" name="file_type"  id="file_type"  value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
	<input type="hidden" name="attach_count"  id="attach_count" value="">
	
	<input type="hidden" name="selected_Row" id="selected_Row" value="">

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
	<td width="35%" class="data_td" width="28%">
		<input type="text" name="st_rfq_no" id="st_rfq_no" size="20" maxlength="14" value="<%=RFQ_NO%>" readOnly>
		<a href="javascript:getRFQ_pop();">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
		</a>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청차수</td>
	<td width="35%" class="data_td" width="39%">
		<input type="text" name="st_rfq_count" id="st_rfq_count" size="2" maxlength="3" value="<%=RFQ_COUNT%>" readOnly>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적업체</td>
	<td class="data_td" width="39%" colspan="3">
		<input type="text" name="st_vendor_code" id="st_vendor_code" size="10" value="<%=VENDOR_CODE%>" readonly>
		<a href="javascript:getRFQvendor_pop();">
			<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
		</a>
		<input type="text" name="st_vendor_name" id="st_vendor_name" size="30" value="<%=VENDOR_NAME%>" readonly>
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
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
			<% if(rw_cnt > 0 ) {%>		
			<TD><script language="javascript">btn("javascript:doSave()","제 출")    </script></TD>
			<% } %>
			<TD><script language="javascript">btn("javascript:doNext()","다음업체")   </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr style="display:none;">
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
	<td width="50%" class="data_td">
		<input type="text" name="rfq_no" id="rfq_no" size="20" value="<%=RFQ_NO%>" class="input_data2">
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
	<td width="20%" class="data_td">
		<input type="text" name="rfq_count" id="rfq_count" size="5" value="<%=RFQ_COUNT%>" class="input_data2">
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
	<td width="35%" class="data_td">
		<%=SUBJECT%>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
	<td width="35%" class="data_td"><%=ADD_USER_NAME%>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
<% if(CREATE_TYPE.equals("PC")){%>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건</td>
	<td colspan="3" class="data_td">
    <select name="PAY_TERMS" id="pay_terms" class="inputsubmit" disabled>
		<%=pay_terms%>
    </select>
	</td>
<%}else{%>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건</td>
	<td colspan="3" class="data_td">
    <select name="PAY_TERMS" id="pay_terms"  class="inputsubmit" disabled colspan=3>
		<%=pay_terms%>
    </select>
	</td>
<%}%>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유효일자</td>
	<td class="data_td" width="35%" >
		<s:calendar id="qta_val_date" default_value="<%=SepoaString.getDateSlashFormat(QTA_VAL_DATE)%>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일자</td>
	<td width="35%" class="data_td">
		<%=RFQ_CLOSE_DATE_VIEW%>
		&nbsp;
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사 특기사항</td>
	<td width="35%" class="data_td" colspan="3">
     	<table>
      	<tr>
      		<td>
	        	<textarea name="rfq_remark" id="rfq_remark" cols="97" rows="5" readonly><%=RFQ_REMARK %></textarea></td><td>
			</td>
		</tr>
		</table>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
	<td class="data_td" colspan="3" height="160">
		<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=RFQ_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사  특기사항</td>
	<td width="35%" class="data_td" colspan="3">
      <textarea name="remark" id="remark" cols="97" rows="5" onKeyUp="return chkMaxByte(4000, this, '특기사항');"><%=REMARK%></textarea>
	</td>
</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
	<td width="35%" class="data_td" colspan="3">
		<table><tr><td>
		<script language="javascript">
		function setAttach(attach_key, arrAttrach, rowId, attach_count) {
			document.getElementById("qta_attach_no").value            = attach_key;
			document.getElementById("qta_attach_no_count").value      = attach_count;
		}
			btn("javascript:attach_file(document.getElementById('qta_attach_no').value, 'TEMP');", "파일등록");
		</script>
		</td><td>
		<input type="text" size="3" readOnly class="input_empty" name="qta_attach_no_count" id="qta_attach_no_count" value="0" />
		<input type="hidden" name="qta_attach_no" id="qta_attach_no">
		</td></tr></table>
		
	</td>
</tr>

</table>

</td>
</tr>
</table>
</td>
</tr>
</table>

<script language="JavaScript" >
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR style="display:none;">

			<%if(!RQAN_CNT.equals("0")){ %>
			   <td><script language="javascript">btn("javascript:openPopup1()","제안설명회")</script></td>
	    	<%}%>

			<td><script language="javascript">btn("javascript:doSave()","전 송")</script></td>
		</TR>
		</TABLE>
	</td>
	<td height="30" align="left">
						<TABLE cellpadding="0" border="0">
							<TR>
								<TD><script language="javascript">
btn("javascript:setDeliveryData()", "납기가능일 일괄적용");
</script></TD>
								<TD><font color="red" style="font-size: 10px">&nbsp;*
										납기가능일<br>&nbsp;&nbsp;&nbsp;&nbsp;첫번째 행 기준으로
										일괄적용합니다.
								</font></TD>
							</TR>
						</TABLE>
					</td>
</tr>
</table>

</form>
<!--
<script language="javascript">rMateFileAttach('S','R','RFQ',form1.attach_no.value,'B');</script>
<script language="javascript">rMateFileAttach('S','C','QTA',form1.qta_attach_no.value,'S');</script>
<iframe name=magic src="qta_bd_ins_hidden.jsp?RFQ_NO=<%=RFQ_NO%>&RFQ_COUNT=<%=RFQ_COUNT%>" width="0" height="0">
-->

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="RQ_233" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>



