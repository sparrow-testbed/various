<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SSO_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SSO_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String WISEHUB_PROCESS_ID="SSO_004";
	
    String HOUSE_CODE = info.getSession("HOUSE_CODE");
    String VENDOR_CODE = info.getSession("COMPANY_CODE");

    String OSQ_NO		= JSPUtil.nullToEmpty(request.getParameter("OSQ_NO"));
    String OSQ_COUNT	= JSPUtil.nullToEmpty(request.getParameter("OSQ_COUNT"));
    String SOR_NO    	= JSPUtil.nullToEmpty(request.getParameter("OR_NO"));
    String REDIRECT		= JSPUtil.nullToEmpty(request.getParameter("REDIRECT"));

	String SUBJECT               = "";
	String OSQ_CLOSE_DATE_VIEW   = "";
	String OSQ_CLOSE_DATE        = "";
	String OSQ_CLOSE_TIME        = "";
	String TERM_CHANGE_FLAG      = "";
	String DOM_EXP_FLAG          = "";
	String DOM_EXP_FLAG_TEXT     = "";
	String DELY_TERMS            = "";
	String PAY_TERMS             = "";
	String CUR                   = "";
	String OSQ_TYPE              = "";
	String OSQ_TYPE_TEXT         = "";
	String SHIPPING_METHOD       = "";
	String SPRICE_TYPE            = "";
	String USANCE_DAYS           = "";
	String USANCE_DAYS_TEXT      = "";
	String ARRIVAL_PORT          = "";
	String ARRIVAL_PORT_NAME     = "";
	String OSQ_REMARK            = "";
	String OR_REMARK            = "";
	String SHIPPER_TYPE          = "";
	String SHIPPER_TYPE_TEXT     = "";
	String DELY_TERMS_TEXT       = "";
	String PAY_TERMS_TEXT        = "";
	String COMPANY_CODE          = "";
	String SHIPPING_METHOD_TEXT  = "";
	String DEPART_PORT           = "";
	String DEPART_PORT_NAME      = "";
	String RQAN_CNT              = "";
	String SETTLE_TYPE           = "";
	String SETTLE_TYPE_TEXT      = "";
	String QTA_VAL_DATE          = "";
	String VENDOR_NAME           = "";
	String PRICE_TYPE_TEXT       = "";
	String VALID_FROM_DATE       = "";
	String VALID_TO_DATE         = "";
	String VALID_FROM_DATE_VIEW  = "";
	String VALID_TO_DATE_VIEW    = "";
	String BID_REQ_TYPE    		= "";
	String ADD_USER_NAME	 	= "";
	String CREATE_TYPE			= "";
	String OS_ATTACH_NO		    = "";
	String OS_ATT_COUNT		    = "";
	String OR_ATTACH_NO		    = "";
	String OR_ATT_COUNT		    = "";
	String GROUP_YN             = "N";
	String PURCHASE_BLOCK_FLAG	= "";
	String OSQ_DATE	            = "";
	String OSQ_TIME         	= "";
	String OR_NO	            = "";
	String MAX_PR_SEQ   = "";
	String real_pr_no	            = "";
	//String DELIVERY_LT	        = "";
	//String DELY_TO_LOCATION     = "";

    Object[] obj = {OSQ_NO ,OSQ_COUNT ,VENDOR_CODE};
    SepoaOut value = ServiceConnector.doService(info, "s2041", "CONNECTION", "getOsqReqHeader", obj);

    SepoaFormater wf =  new SepoaFormater(value.result[0]);
    int rw_cnt = 0;

    rw_cnt = wf.getRowCount();

    if(rw_cnt > 0) {
		SUBJECT                    = wf.getValue("SUBJECT", 0);
		OSQ_CLOSE_DATE_VIEW        = wf.getValue("OSQ_CLOSE_DATE_VIEW", 0);
		OSQ_CLOSE_DATE             = wf.getValue("OSQ_CLOSE_DATE", 0);
		OSQ_CLOSE_TIME             = wf.getValue("OSQ_CLOSE_TIME", 0);
		TERM_CHANGE_FLAG           = wf.getValue("TERM_CHANGE_FLAG", 0);
		DOM_EXP_FLAG               = wf.getValue("DOM_EXP_FLAG", 0);
		DOM_EXP_FLAG_TEXT          = wf.getValue("DOM_EXP_FLAG_TEXT", 0);
		DELY_TERMS                 = wf.getValue("DELY_TERMS", 0);
		PAY_TERMS                  = wf.getValue("PAY_TERMS", 0);
		CUR                        = wf.getValue("CUR", 0);
		OSQ_TYPE                   = wf.getValue("OSQ_TYPE", 0);
		OSQ_TYPE_TEXT              = wf.getValue("OSQ_TYPE_TEXT", 0);
		SHIPPING_METHOD            = wf.getValue("SHIPPING_METHOD", 0);
		SPRICE_TYPE                 = wf.getValue("PRICE_TYPE", 0);
		USANCE_DAYS                = wf.getValue("USANCE_DAYS", 0);
		USANCE_DAYS_TEXT           = wf.getValue("USANCE_DAYS_TEXT", 0);
		ARRIVAL_PORT               = wf.getValue("ARRIVAL_PORT", 0);
		ARRIVAL_PORT_NAME          = wf.getValue("ARRIVAL_PORT_NAME", 0);
		OSQ_REMARK                 = wf.getValue("OSQ_REMARK", 0);
		OR_REMARK                 = wf.getValue("OR_REMARK", 0);
		SHIPPER_TYPE               = wf.getValue("SHIPPER_TYPE", 0);
		SHIPPER_TYPE_TEXT          = wf.getValue("SHIPPER_TYPE_TEXT", 0);
		DELY_TERMS_TEXT            = wf.getValue("DELY_TERMS_TEXT", 0);
		PAY_TERMS_TEXT             = wf.getValue("PAY_TERMS_TEXT", 0);
		COMPANY_CODE               = wf.getValue("COMPANY_CODE", 0);
		SHIPPING_METHOD_TEXT       = wf.getValue("SHIPPING_METHOD_TEXT", 0);
		DEPART_PORT                = wf.getValue("DEPART_PORT", 0);
		DEPART_PORT_NAME           = wf.getValue("DEPART_PORT_NAME", 0);
		RQAN_CNT                   = wf.getValue("RQAN_CNT", 0);
		SETTLE_TYPE_TEXT           = wf.getValue("SETTLE_TYPE_TEXT", 0);
		SETTLE_TYPE                = wf.getValue("SETTLE_TYPE", 0);
		QTA_VAL_DATE               = wf.getValue("QTA_VAL_DATE", 0);
		VENDOR_NAME                = wf.getValue("VENDOR_NAME", 0);
		PRICE_TYPE_TEXT            = wf.getValue("PRICE_TYPE_TEXT", 0);
		VALID_FROM_DATE            = wf.getValue("VALID_FROM_DATE", 0);
		VALID_TO_DATE              = wf.getValue("VALID_TO_DATE", 0);
		VALID_FROM_DATE_VIEW       = wf.getValue("VALID_FROM_DATE_VIEW", 0);
		VALID_TO_DATE_VIEW         = wf.getValue("VALID_TO_DATE_VIEW", 0);
		BID_REQ_TYPE			   = wf.getValue("BID_REQ_TYPE", 0);
		ADD_USER_NAME			   = wf.getValue("ADD_USER_NAME", 0);
		CREATE_TYPE			 	   = wf.getValue("CREATE_TYPE", 0);
		OS_ATTACH_NO         	   = wf.getValue("OS_ATTACH_NO", 0);
		OS_ATT_COUNT			   = wf.getValue("OS_ATT_COUNT", 0);
		OR_ATTACH_NO         	   = wf.getValue("OR_ATTACH_NO", 0);
		OR_ATT_COUNT			   = wf.getValue("OR_ATT_COUNT", 0);
		
		OSQ_TYPE				   = wf.getValue("OSQ_TYPE", 0);
		PURCHASE_BLOCK_FLAG		   = wf.getValue("PURCHASE_BLOCK_FLAG", 0);
		OSQ_DATE				   = wf.getValue("OSQ_DATE", 0);
		OSQ_TIME				   = wf.getValue("OSQ_TIME", 0);
		OR_NO				       = wf.getValue("OR_NO", 0);
		MAX_PR_SEQ           = wf.getValue("MAX_PR_SEQ", 0);
		real_pr_no				   = wf.getValue("REAL_PR_NO", 0);
		//DELIVERY_LT			       = wf.getValue("DELIVERY_LT", 0);
		//DELY_TO_LOCATION           = wf.getValue("DELY_TO_LOCATION", 0);

		
	    if(QTA_VAL_DATE == null || QTA_VAL_DATE.equals("")) QTA_VAL_DATE = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),+1);
	}

    /* Object[] obj2 = {OSQ_NO ,OSQ_COUNT};
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
	int wf2_cnt = wf2.getRowCount(); */

	String pay_terms 	= ListBox(request, "SL0127",  HOUSE_CODE+"#M010#"+SHIPPER_TYPE+"#", PAY_TERMS);
	String dely_terms 	= ListBox(request, "SL0018",  HOUSE_CODE+"#M009#", DELY_TERMS);

	Configuration con = new Configuration();
	String buyer_code = con.get("sepoa.company.code");
%>
<html>
<head>	
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<%
	if("Y".equals(PURCHASE_BLOCK_FLAG)){
%>
<script language="javascript" type="text/javascript">
	alert("거래가 중지되었습니다.\n담당자에게 문의하십시요.");
	history.back();
</script>
<%
	}
%>
<script language="javascript" type="text/javascript">
var mode;
var G_Pos= -1;
var Arow;
var summaryCnt = 0;
var INDEX_SELECTED;
var INDEX_ITEM_NO;
var INDEX_PR_NO;
var INDEX_PR_SEQ;
var INDEX_DESCRIPTION_LOC;
var INDEX_SPECIFICATION;
var INDEX_OSQ_QTY;
var INDEX_ITEM_QTY;
var INDEX_VENDOR_ITEM_NO;
var INDEX_UNIT_MEASURE;
var INDEX_UNIT_PRICE;
var INDEX_UNIT_PRICE_IMG;
var INDEX_BEFORE_PRICE;
var INDEX_ITEM_AMT;
var INDEX_DELIVERY_LT;
var INDEX_RD_DATE;
var INDEX_YEAR_QTY;
var INDEX_ATTACH_NO;
var INDEX_ATT_COUNT;
var INDEX_PRICE_DOC;
var INDEX_MOLDING_CHARGE;
var INDEX_PURCHASER;
var INDEX_PURCHASER_PHONE;
var INDEX_OSQ_SEQ;
var INDEX_MAKER_CODE;
var INDEX_MAKER_NAME;
var INDEX_EP_FROM_DATE;
var INDEX_EP_TO_DATE;
var INDEX_EP_FROM_QTY;
var INDEX_EP_TO_QTY;
var INDEX_EP_UNIT_PRICE;
var INDEX_DELY_TO_LOCATION;
var INDEX_SHIPPER_TYPE;
var INDEX_MOLDING_FLAG;
var INDEX_CUSTOMER_PRICE;
var INDEX_CUSTOMER_AMT;
var INDEX_SUPPLY_PRICE;
var INDEX_SUPPLY_AMT;
var INDEX_HUMAN_NAME_LOC;
var INDEX_CONTRACT_DIV;
var INDEX_ITEM_GBN;
var INDEX_SEC_VENDOR_CODE_TEXT;
var INDEX_SEC_VENDOR_CODE;
var INDEX_RATE;
var INDEX_MATERIAL_CTRL_TYPE;
var INDEX_KTGRM;
var INDEX_ITEM_WIDTH;
var INDEX_ITEM_HEIGHT;
var INDEX_ITEM_AMT;
var INDEX_MAKE_AMT_NAME;
var INDEX_MAKE_AMT_UNIT;
var INDEX_OR_NO;
var INDEX_P_ITEM_NO;
var INDEX_P_SEQ;
var INDEX_MAKE_AMT_CODE;
var INDEX_P_DESCRIPTION_LOC;
var INDEX_P_BOM_NAME;

var INDEX_DELY_TO_LOCATION;	 
var INDEX_DELY_TO_DEPT;

var INDEX_WID;
var INDEX_HGT;

var INDEX_PR_ITEM_QTY;


function Init(){
	setGridDraw();
	setHeader();
	doSelect();
}
	
function setHeader() {
	GridObj.bHDSwapping = false;
	GridObj.bHDMoving = false;
	GridObj.nHDLineSize  = 32;

	var frm = document.forms[0];

	INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
	INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_PR_NO                     = GridObj.GetColHDIndex("PR_NO");
	INDEX_PR_SEQ                   = GridObj.GetColHDIndex("PR_SEQ");
	INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_OSQ_QTY               = GridObj.GetColHDIndex("OSQ_QTY");
	INDEX_ITEM_QTY              = GridObj.GetColHDIndex("ITEM_QTY");
	INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_UNIT_PRICE_IMG        = GridObj.GetColHDIndex("UNIT_PRICE_IMG");
	INDEX_ITEM_AMT              = GridObj.GetColHDIndex("ITEM_AMT");
	INDEX_DELIVERY_LT           = GridObj.GetColHDIndex("DELIVERY_LT");
	INDEX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
	INDEX_ATTACH_NO             = GridObj.GetColHDIndex("ATTACH_NO");
	INDEX_ATT_COUNT             = GridObj.GetColHDIndex("ATT_COUNT");
	INDEX_PRICE_DOC             = GridObj.GetColHDIndex("PRICE_DOC");
	INDEX_VENDOR_ITEM_NO        = GridObj.GetColHDIndex("VENDOR_ITEM_NO");
	INDEX_BEFORE_PRICE          = GridObj.GetColHDIndex("BEFORE_PRICE");
	INDEX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
	INDEX_YEAR_QTY              = GridObj.GetColHDIndex("YEAR_QTY");
	INDEX_MOLDING_CHARGE        = GridObj.GetColHDIndex("MOLDING_CHARGE");
	INDEX_PURCHASER             = GridObj.GetColHDIndex("PURCHASER");
	INDEX_PURCHASER_PHONE       = GridObj.GetColHDIndex("PURCHASER_PHONE");
	INDEX_OSQ_SEQ               = GridObj.GetColHDIndex("OSQ_SEQ");
	INDEX_ITEM_AMT              = GridObj.GetColHDIndex("ITEM_AMT");
	INDEX_MAKER_CODE            = GridObj.GetColHDIndex("MAKER_CODE");
	INDEX_MAKER_NAME            = GridObj.GetColHDIndex("MAKER_NAME");
	INDEX_EP_FROM_DATE          = GridObj.GetColHDIndex("EP_FROM_DATE");
	INDEX_EP_TO_DATE            = GridObj.GetColHDIndex("EP_TO_DATE");
	INDEX_EP_FROM_QTY           = GridObj.GetColHDIndex("EP_FROM_QTY");
	INDEX_EP_TO_QTY             = GridObj.GetColHDIndex("EP_TO_QTY");
	INDEX_EP_UNIT_PRICE         = GridObj.GetColHDIndex("EP_UNIT_PRICE");
	INDEX_DELY_TO_LOCATION      = GridObj.GetColHDIndex("DELY_TO_LOCATION");
	INDEX_DELY_TO_DEPT      = GridObj.GetColHDIndex("DELY_TO_DEPT");
	INDEX_SHIPPER_TYPE          = GridObj.GetColHDIndex("SHIPPER_TYPE");
	INDEX_MOLDING_FLAG          = GridObj.GetColHDIndex("MOLDING_FLAG");
	INDEX_CUSTOMER_PRICE        = GridObj.GetColHDIndex("CUSTOMER_PRICE");
	INDEX_CUSTOMER_AMT        	= GridObj.GetColHDIndex("CUSTOMER_AMT");
	INDEX_SUPPLY_PRICE          = GridObj.GetColHDIndex("SUPPLY_PRICE");
	INDEX_SUPPLY_AMT          	= GridObj.GetColHDIndex("SUPPLY_AMT");
	INDEX_DISCOUNT				= GridObj.GetColHDIndex("DISCOUNT");
	INDEX_HUMAN_NAME_LOC		= GridObj.GetColHDIndex("HUMAN_NAME_LOC");
	INDEX_CONTRACT_DIV         	= GridObj.GetColHDIndex("CONTRACT_DIV");
	INDEX_ITEM_GBN	         	= GridObj.GetColHDIndex("ITEM_GBN");
	INDEX_KTGRM	         		= GridObj.GetColHDIndex("KTGRM");		
	INDEX_SEC_VENDOR_CODE_TEXT  = GridObj.GetColHDIndex("SEC_VENDOR_CODE_TEXT");
	INDEX_SEC_VENDOR_CODE     	= GridObj.GetColHDIndex("SEC_VENDOR_CODE");
	INDEX_RATE     	            = GridObj.GetColHDIndex("RATE");
	INDEX_MATERIAL_CTRL_TYPE   	= GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE");
	INDEX_ITEM_WIDTH        	= GridObj.GetColHDIndex("ITEM_WIDTH");
	INDEX_ITEM_HEIGHT        	= GridObj.GetColHDIndex("ITEM_HEIGHT");
	INDEX_MAKE_AMT_NAME         = GridObj.GetColHDIndex("MAKE_AMT_NAME");
	INDEX_MAKE_AMT_UNIT         = GridObj.GetColHDIndex("MAKE_AMT_UNIT");
	INDEX_OR_NO                 = GridObj.GetColHDIndex("OR_NO");
	INDEX_P_ITEM_NO                 = GridObj.GetColHDIndex("P_ITEM_NO");
	INDEX_P_SEQ                        = GridObj.GetColHDIndex("P_SEQ");
	INDEX_MAKE_AMT_CODE                 = GridObj.GetColHDIndex("MAKE_AMT_CODE");
	INDEX_P_DESCRIPTION_LOC                 = GridObj.GetColHDIndex("P_DESCRIPTION_LOC");
	INDEX_P_BOM_NAME                 = GridObj.GetColHDIndex("P_BOM_NAME");
	
	INDEX_DELY_TO_LOCATION		= GridObj.GetColHDIndex("DELY_TO_LOCATION");	 
	INDEX_DELY_TO_DEPT			= GridObj.GetColHDIndex("DELY_TO_DEPT");
	
	INDEX_WID  = GridObj.GetColHDIndex("WID");
	INDEX_HGT = GridObj.GetColHDIndex("HGT");
	
	INDEX_PR_ITEM_QTY = GridObj.GetColHDIndex("PR_ITEM_QTY");
	
}

function doSelect(){
	var settle_type = "<%=SETTLE_TYPE%>";
	var osq_type	= "<%=OSQ_TYPE%>";

	vendor_code = "<%=VENDOR_CODE%>"
		
	$('#st_vendor_code').val("<%=VENDOR_CODE%>");
	$('#st_osq_no').val("<%=OSQ_NO%>");
	$('#st_osq_count').val("<%=OSQ_COUNT%>");
	$('#group_yn').val("<%=GROUP_YN%>");
				
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.so.sor_bd_ins";
	var grid_col_id     = "<%=grid_col_id%>";
	var param = "mode=getSoslnList&grid_col_id="+grid_col_id;
	
	param += dataOutput();
	
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);   
}

function doSave(send_flag) { //전송(P),저장(N)
	var maxRow = GridObj.GetRowCount();
	var wt = GridObj;
	var ITEM_AMT_VALUE = 0;
	var NET_AMT = 0;
	var  checked_count = 0;
	selectAll_new();
	
	for(var i=0; i<maxRow; i++) {
		if( true == GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED)) {
			checked_count++;
			
			j = GridObj.getRowId(i);
			
			var ITEM_WIDTH       = GridObj.cells(j, INDEX_ITEM_WIDTH).getValue();
			var ITEM_HEIGHT      = GridObj.cells(j, INDEX_ITEM_HEIGHT).getValue();
			var DELIVERY_LT      = GridObj.cells(j, INDEX_DELIVERY_LT).getValue();
			var DELY_TO_LOCATION = GridObj.cells(j, INDEX_DELY_TO_LOCATION).getValue();
			var ITEM_AMT         = GridObj.cells(j, INDEX_ITEM_AMT).getValue();
			var ITEM_QTY         = GridObj.cells(j, INDEX_ITEM_QTY).getValue();
			var MAKE_AMT_CODE         = GridObj.cells(j, INDEX_MAKE_AMT_CODE).getValue();
			var PR_NO                    = GridObj.cells(j, INDEX_PR_NO).getValue();
			var PR_ITEM_QTY         = GridObj.cells(j, INDEX_PR_ITEM_QTY).getValue();
			               
			if(LRTrim(ITEM_QTY) == "" || Number(LRTrim(ITEM_QTY)) <= 0){
				alert(++i +"번째 줄에 수량이 없습니다.");
				return;
			}			
			
			if(LRTrim(PR_NO) != "" ){				
				if(ITEM_QTY != PR_ITEM_QTY) {
					alert(++i +"번째 줄의 수량은 정정불가 합니다.\r\n영업점 구매요청에 의한 품목은 수량 정정불가\r\n\r\n구매요청수량 : " + PR_ITEM_QTY);
					return;
				}
			}
						
			if(LRTrim(ITEM_WIDTH) == ""){
				ITEM_WIDTH = "0";
				GridObj.cells(j, INDEX_ITEM_WIDTH).setValue("0");
			}
                
			if(LRTrim(ITEM_HEIGHT) == ""){
				ITEM_HEIGHT = "0";
				GridObj.cells(j, INDEX_ITEM_HEIGHT).setValue("0");
			}
			
			if(MAKE_AMT_CODE == "01") {
				if(Number(ITEM_WIDTH) <= 0 || Number(ITEM_HEIGHT) <= 0) {
					alert(++i +"번째 줄의 가로, 세로 값을 확인해 주십시오.");
					return;
				}
			} else if(MAKE_AMT_CODE == "03") {
				if(Number(ITEM_HEIGHT) <= 0) {
					alert(++i +"번째 줄의 세로 값을 확인해 주십시오.");
					return;
				}
				if(Number(ITEM_WIDTH) != 0) {
					alert(++i +"번째 줄의 가로 값을 확인해 주십시오.");
					return;
				}
			} else if(MAKE_AMT_CODE == "02") {
				if(Number(ITEM_HEIGHT) != 0) {
					alert(++i +"번째 줄의 세로 값을 확인해 주십시오.");
					return;
				}
				if(Number(ITEM_WIDTH) <= 0) {
					alert(++i +"번째 줄의 가로 값을 확인해 주십시오.");
					return;
				}	
			} else {
				if(Number(ITEM_WIDTH) != 0) {
					alert(++i +"번째 줄의 가로 값을 확인해 주십시오.");
					return;
				}
				if(Number(ITEM_HEIGHT) != 0) {
					alert(++i +"번째 줄의 세로 값을 확인해 주십시오.");
					return;
				}
			}
			                
			if(LRTrim(DELIVERY_LT) == ""){
				alert(++i +"번째 줄의 납기가능일을 반드시 입력해야 합니다.");
				
				return;
			}
                
			if(LRTrim(DELY_TO_LOCATION) == ""){
				alert(++i +"번째 줄의 납품장소를 반드시 입력해야 합니다.");
				
				return;
			}
                
			if(eval(ITEM_AMT) <= 0 || eval(ITEM_AMT) == ""){
				alert(++i +"번째 줄의 금액을 확인하여 주시기 바랍니다.");
				
				return;
			}
		}
	}

	if(checked_count == 0)  {
		alert("항목을 체크하여 주시기 바랍니다.");
		
		return;
	}

	var msg = "제출하시겠습니까?";
	
	if (send_flag == "N") {
		msg = "저장하시겠습니까?\n\n ※.실사서 저장후 실사서 제출을 위해서는 반드시 전송버튼을 눌러야 합니다!     ";
	}
	
	if(!confirm(msg)){
		return;
	}

	document.forms[0].send_flag.value = send_flag;
		
	getApprovalSend();
}

function getApprovalSend() {
	var wForm = document.forms[0];
	var PAY_TERMS      = "";
	var TTL_CHARGE     = 0;

	mode = "setSorInsert";	//서블릿에서 OR번호를 판별하여 생성인지 수정인지 체크한다.
<%-- 	if("<%=SOR_NO%>" == ""){ --%>
// 	}
// 	else {
// 		mode = "setSorUpdate";
// 	}

	$("#osq_no"       ).val("<%=OSQ_NO%>");
	$("#ttl_charge"   ).val(TTL_CHARGE);
	$("#vendor_code"  ).val("<%=VENDOR_CODE%>");
	$("#subject"      ).val("<%=SUBJECT%>");
	$("#osq_no"       ).val("<%=OSQ_NO%>");
	$("#osq_count"    ).val("<%=OSQ_COUNT%>");
	$("#pay_terms"    ).val(PAY_TERMS);
	$("#price_type"   ).val("<%=SPRICE_TYPE%>");
	$("#company_code" ).val("<%=COMPANY_CODE%>");
	$("#bid_req_type" ).val("<%=BID_REQ_TYPE%>");
	$("#osq_attach_no" ).val(document.form1.osq_attach_no.value);
	
	G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.so.sor_bd_ins";
		
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids   = "<%=grid_col_id%>";
	var params;
	
	params = "?mode="+mode;
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
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

function setPriceInfo(comp_s_date, comp_e_date, comp_s_qty, comp_e_qty, comp_unit_price, max_unitprice){
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_EP_FROM_DATE,  comp_s_date);
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_EP_TO_DATE,    comp_e_date);
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_EP_FROM_QTY,   comp_s_qty);
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_EP_TO_QTY,     comp_e_qty);
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_UNIT_PRICE,    max_unitprice);
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_EP_UNIT_PRICE, comp_unit_price);

	document.forms[0].t_from_date.value =  GetCellValueIndex(GridObj,G_Pos, INDEX_EP_FROM_DATE);
	document.forms[0].t_to_date.value =    GetCellValueIndex(GridObj,G_Pos, INDEX_EP_TO_DATE);
	document.forms[0].t_from_qty.value =   GetCellValueIndex(GridObj,G_Pos, INDEX_EP_FROM_QTY);
	document.forms[0].t_to_qty.value =     GetCellValueIndex(GridObj,G_Pos, INDEX_EP_TO_QTY);
	document.forms[0].t_unit_price.value = GetCellValueIndex(GridObj,G_Pos, INDEX_UNIT_PRICE);
}

function setCost(sendData, cnt){
	var text = GridObj.GetCellValue("PRICE_DOC",G_Pos);
	var temp = G_IMG_ICON + "&" + cnt + "&" +sendData;

	GD_SetCellValueIndex(GridObj,G_Pos,INDEX_PRICE_DOC, temp, "&");
}

function getpay_method(code, text2) {
	document.forms[0].PAY_TERMS.value = code;
	document.forms[0].PAY_TERMS_TEXT.value = text2;
}

function getdely_terms(nation_code, city_code, code, text1) {
	document.forms[0].DEPART_PORT.value = code;
	document.forms[0].DEPART_PORT_NAME.value = text1;
}

function searchProfile(fc) {
	var shipper_type = document.forms[0].SHIPPER_TYPE.value;
	
	if(fc == 'pay_method'){
		var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
		
		PopupCommonArr("SP9134", "getpay_method", arrv, "" );
	}
	else if(fc == "dely_terms" ) {
		var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", shipper_type);
		
		PopupCommonArr("SP0232", "getdely_terms", arrv, "" );
	}
	else if(fc == "DEPART_PORT" ) {
		var ship_meth = "";

		if("<%=TERM_CHANGE_FLAG%>" == "N") {
			ship_meth = "<%=SHIPPING_METHOD%>";
		}
		else{
			ship_meth = document.forms[0].SHIPPING_METHOD.value;
		}

		var type = "";

		if(ship_meth != ""){
			if(ship_meth == "VSL") {
				type = "S";
			}
			else if(ship_meth == "AIR"){
				type = "A";
			}
			else if(ship_meth == "COM"){
				type = "C";
			}

			var arrv = new Array("<%=info.getSession("HOUSE_CODE")%>", "M006", type);
			
			PopupCommonArr("SP0160", "getdely_terms", arrv, "" );
		}
		else{
			alert("내자건에 대해서는 출발항을 선택하실 수 없습니다.");
			
			return;
		}
	}
}
    
function setVendorCode( code, desc1, desc2) {
	GD_SetCellValueIndex(GridObj,document.forms[0].selected_Row.value,INDEX_SEC_VENDOR_CODE_TEXT,desc1);
	GD_SetCellValueIndex(GridObj,document.forms[0].selected_Row.value,INDEX_SEC_VENDOR_CODE,code);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	var maxRow = GridObj.GetRowCount();
        
	if(msg1 == "doData") {
		selectAll();
	}
	
	if(msg1 == "doQuery") {
		selectAll();
	}  // if 문끝
}  // JAVACALL 끝
   
function calculate_tot_amt(){
	var tmp_camt     = 0;
    var tmp_samt     = 0;
    var c_amt        = 0;
    var s_amt        = 0;
    var tmp_discount = 0;

	for(var i=0;i<GridObj.GetRowCount();i++){
		var tmp_camt = getCalculEval(GD_GetCellValueIndex(GridObj,i,INDEX_CUSTOMER_AMT));
		
		c_amt = c_amt +  tmp_camt;
		
		var tmp_samt = getCalculEval(GD_GetCellValueIndex(GridObj,i,INDEX_SUPPLY_AMT));
		
		s_amt = s_amt +  tmp_samt;
	}

	if( c_amt > 0 && s_amt > 0 )  {
		t_discount = (eval(c_amt) - eval(s_amt))/ eval(c_amt);
		t_discount = RoundEx( (t_discount * 100) ,3) ;
	}
	else {
		t_discount = 0;
	}
	
    if( eval(t_discount) == 100){
    	t_discount = 0;
    }

    form1.customer_sumAmt.value = add_comma(c_amt,0);
    form1.supply_sumAmt.value 	= add_comma(s_amt,0);
    form1.t_discount.value 		= t_discount;
}

function SP0272_Popup() {
	var left       = 0;
	var top        = 0;
	var width      = 540;
	var height     = 500;
	var toolbar    = 'no';
	var menubar    = 'no';
	var status     = 'yes';
	var scrollbars = 'no';
	var resizable  = 'no';
	var url        = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0272&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=buyer_code%>&values=<%=info.getSession("COMPANY_CODE")%>";
	var doc        = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP0272_getCode(ls_human_no, ls_name_loc) {
	GD_SetCellValueIndex(GridObj, G_Pos, INDEX_HUMAN_NAME_LOC, G_IMG_ICON + "&" + ls_name_loc + "&" + ls_human_no, "&");
}

function goAttach(attach_no){
	attach_file(attach_no,"FILE");
}

function setAttach(attach_key, arrAttrach,rowId, attach_count) {
	document.form1.osq_attach_no.value = attach_key;
	document.form1.osq_attach_no_count.value = attach_count;
}

function selectAll(){
	var selectedColIndex = GridObj.getColIndexById("SELECTED");
	
	for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++){
		GridObj.cells(j+1, selectedColIndex).cell.wasChanged = true;
		
		GridObj.cells(j+1, selectedColIndex).setValue("1"); 
	}
	
	selectAllFlag = 1;
}

function selectAll_new() {
	for(var row = 0; row < <%=grid_obj%>.getRowsNum(); row++)
	{
		<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).setValue("1");
		<%=grid_obj%>.cells(<%=grid_obj%>.getRowId(row), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    }
}

var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

var G_CUR_ROW;//팝업 관련해서 씀..
var G_HOUSE_CODE                 = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE               = "<%=COMPANY_CODE%>";

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var header_name = GridObj.getColumnId(cellInd);
	if(header_name == "DELY_TO_LOCATION") {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		window.open("/common/CO_009.jsp?callback=getDemandGrid&vendor_serch=Y", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	} 
	
}

function getDemandGrid(code, text){
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_DEPT, code);
	GD_SetCellValueIndex(GridObj, G_CUR_ROW, INDEX_DELY_TO_LOCATION, text);
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj.cells(rowId, cellInd).getValue();
	
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0){
        return true;
    }
    else if(stage==1){}
    else if(stage==2){
    	/*
    	var specification = GridObj.cells(rowId, INDEX_SPECIFICATION).getValue();									//규격
    	var unit_arr      = specification.split("*");
    	var unit_width    = "";
    	var unit_height   = "";
    	
    	if(unit_arr.length == 2){
    		//unit_width  = isNumberCommon(LRTrim(unit_arr[0])) == true ? LRTrim(unit_arr[0]) : "0";
    		//unit_height = isNumberCommon(LRTrim(unit_arr[1])) == true ? LRTrim(unit_arr[1]) : "0";
    		unit_width  = "100";
    		unit_height = "100";
    	}
    	else{
    		unit_width  = specification;
    		unit_height = specification;
    	}
    	*/
    	
    	var unit_width    = Number(GridObj.cells(rowId, INDEX_WID).getValue());	
    	var unit_height   = Number(GridObj.cells(rowId, INDEX_HGT).getValue());	
    	
        if((cellInd == INDEX_ITEM_WIDTH) || (cellInd == INDEX_ITEM_HEIGHT) || (cellInd == GridObj.getColIndexById("ITEM_QTY"))){
	    	var v_width         = "0";	
	    	var v_height        = "0";
	    	var v_make_amt_unit = "0";
	    	var v_item_qty      = GridObj.cells(rowId, GridObj.getColIndexById("ITEM_QTY")).getValue();
    
	    	v_width         = Number(GridObj.cells(rowId, INDEX_ITEM_WIDTH).getValue());	
        	v_height        = Number(GridObj.cells(rowId, INDEX_ITEM_HEIGHT).getValue());	
        	v_make_amt_unit = Number(GridObj.cells(rowId, INDEX_MAKE_AMT_UNIT).getValue());	
        	v_unit_price    = Number(GridObj.cells(rowId, INDEX_UNIT_PRICE).getValue());
        	        	
        	if(eval(v_unit_price) > 0){ 
        		
	        	if(v_make_amt_unit == "1"){	//환산계수가 1 가로 계산
	        		v_item_amt = (v_width/unit_width)*v_unit_price;
	        	}
	        	else if(v_make_amt_unit == "2"){	//환산계수가 2 세로 계산
	        		v_item_amt = (v_height/unit_height)*v_unit_price;
	        	}
	        	else if(v_make_amt_unit == "3"){	//환산계수가 3 가로/세로 계산
	        		v_item_amt = (v_width/unit_width)*(v_height/unit_height)*v_unit_price;
	        	}
	        	else{	
	        		//v_item_amt = v_width*v_unit_price;
	        		v_item_amt = v_unit_price;
	        	}
	        	v_item_amt = v_item_amt * v_item_qty
        	}        	
        	GridObj.cells(rowId, INDEX_ITEM_AMT).setValue(RoundEx(v_item_amt, 3));	
    	}
        
    	return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }
    
    alert(messsage);

    if(status == "true") {
    	location.href = "/s_kr/bidding/so/sor_bd_lis1.jsp";
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
    if(status == "0"){
    	alert(msg);
    }
    
    for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
    	var makeAmtCode = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("MAKE_AMT_CODE")).getValue();
    	
    	if(!(makeAmtCode == "01" || makeAmtCode == "02" || makeAmtCode == "03")){
    		var qty = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_QTY")).getValue();
    		
//     		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_WIDTH")).setValue(1);
    		
    		var itemAmt = Number(qty) * Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("UNIT_PRICE")).getValue());
    		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_AMT")).setValue(itemAmt);
    	}
    }
    
    selectAll();
    
    if("<%=SOR_NO %>" == "") {
	    doSettingPr_no();
    }
    return true;
}

//PR번호 세팅(나중에 데이터 세로만들때, GL에 넣고 승인 시, 해당 번호의 PR데이터를 지워야 한다.)
function doSettingPr_no() {
	var grid_array       = getGridChangedRows(GridObj, "SELECTED");
	
	var real_pr_no = "";
	for(var i = 0; i < grid_array.length; i++) {
		var pr_no 		= GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue();
		
		if(pr_no.length > 0) {
			real_pr_no = pr_no;
		}
	}
	
	document.form1.real_pr_no.value = real_pr_no;
}

//BOM선택
function fnMa014Pop(){
	
	var inputParam = "?type=&pItemNo=&seq=&gate=gate_a&vendor_code=<%=VENDOR_CODE%>";
	var url = "/kr/bom/ma_014.jsp"+inputParam
	
	window.open(url,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
}

function fnMa014_1Pop(){
	
	var rowCount = GridObj.GetRowCount();
	var selected = false;
	var rowid    = "";
	var cnt = 0;
	
	var P_ITEM_NO = "";
	var PR_SEQ = "";
	
	
	for(var i = (rowCount - 1); i >= 0; i--){
		selected   = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
		
		if(selected == true){
			
			P_ITEM_NO = GD_GetCellValueIndex(GridObj,i, INDEX_P_ITEM_NO);
			P_SEQ = GD_GetCellValueIndex(GridObj,i, INDEX_P_SEQ);
			PR_SEQ = GD_GetCellValueIndex(GridObj,i, INDEX_PR_SEQ);
			
			if(P_ITEM_NO != ""){
				cnt ++;			
			}
			
			//rowid = GridObj.getRowId(i);
			
			//GridObj.deleteRow(rowid);
		}
	}
	
	if(cnt == 0){
		alert("모품을 선택하세요.");
		return;
	}
	
	if(cnt > 1){
		alert("모품을 하나만 선택하세요.");
		return;
	}
	
	
	
	var inputParam = "?type=&pItemNo=" + P_ITEM_NO + "&seq=" + P_SEQ + "&prSeq="+ PR_SEQ + "&gate=gate_a&vendor_code=<%=VENDOR_CODE%>";
	var url = "/kr/bom/ma_014_1.jsp"+inputParam
	
	window.open(url,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
}

var _openFlag = false;
var _ItemNoColValue = "";

function getMaxPR_SEQ(){
	var s_PR_SEQ = "";
	var i_PR_SEQ = 0;
	var PR_SEQ = 0;
	var s_MAX_PR_SEQ = "<%=MAX_PR_SEQ%>";
	var i_MAX_PR_SEQ = 0;
	
	if(s_MAX_PR_SEQ == ""){
		for(var i=0;i<GridObj.GetRowCount();i++) {	
			s_PR_SEQ = GD_GetCellValueIndex(GridObj,i,INDEX_PR_SEQ).substring(0,4);
			i_PR_SEQ = parseFloat(s_PR_SEQ);
			
			if( i_PR_SEQ > PR_SEQ ){
				PR_SEQ = i_PR_SEQ;
			}
		}		
	}else{			
		for(var i=0;i<GridObj.GetRowCount();i++) {	
			s_PR_SEQ = GD_GetCellValueIndex(GridObj,i,INDEX_PR_SEQ).substring(0,4);
			i_PR_SEQ = parseFloat(s_PR_SEQ);
				
			if( i_PR_SEQ > PR_SEQ ){
				PR_SEQ = i_PR_SEQ;
			}
		}
		
		i_MAX_PR_SEQ = parseFloat(s_MAX_PR_SEQ.substring(0,4));		
		if( i_MAX_PR_SEQ >= PR_SEQ){			
			PR_SEQ = i_MAX_PR_SEQ;
		}		
	}
		
	return PR_SEQ;
}

function prSeqFormat(i_PR_SEQ){
	var s_PR_SEQ
	if(i_PR_SEQ < 10){
		s_PR_SEQ = "000" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 100){
		s_PR_SEQ = "00" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 1000){
		s_PR_SEQ = "0" + i_PR_SEQ + "0";
	}else if(i_PR_SEQ < 10000){
		s_PR_SEQ =  i_PR_SEQ + "0";
	}
	
	return 	s_PR_SEQ;
}

function chk_cItemDup(p_prSeq,p_itemNo){
	var rowCount = GridObj.GetRowCount();
	
	var dup_flag   = false;
	
	var PR_SEQ = "";
	var ITEM_NO = "";
	var DESCRIPTION_LOC = "";
	var P_DESCRIPTION_LOC = "";
	//var P_ITEM_NO = "";
	//var P_SEQ = "";
	for(var i = (rowCount - 1); i >= 0; i--){
		PR_SEQ = GD_GetCellValueIndex(GridObj,i, INDEX_PR_SEQ);
		ITEM_NO = GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_NO);
		
		
		P_DESCRIPTION_LOC = GD_GetCellValueIndex(GridObj,i, INDEX_P_DESCRIPTION_LOC);
		DESCRIPTION_LOC = GD_GetCellValueIndex(GridObj,i, INDEX_DESCRIPTION_LOC);
		
		
		//P_ITEM_NO = GD_GetCellValueIndex(GridObj,i, INDEX_P_ITEM_NO);
		//P_SEQ = GD_GetCellValueIndex(GridObj,i, INDEX_P_SEQ);
	
		/* 
		if(p_prSeq == PR_SEQ && p_itemNo == ITEM_NO){
			alert("중복된 BOM 자품을 추가 불가합니다.\r\n\r\n모단품ID : "+ PR_SEQ +"\r\n모품명 : "+ P_DESCRIPTION_LOC +"\r\n중복자품명 : " + DESCRIPTION_LOC);
			dup_flag = true;
			break;
		} 
		*/
	}
	
	return dup_flag;
}


//리턴
function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode
		, qty, itemGroup, delyToAddress, unitPrice, ktgrm
		, makerName, basicUnit, materialType, pItemNoColValue, c_unit_price_value
		, make_amt_code_value, p_description_loc_value, p_bom_name_value, make_amt_name_value, make_amt_unit_value
		, imgPath, tmp6, wid, hgt){
	
	var dup_flag   = false;
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	GridObj.addRow(newId,"");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	     "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	     itemNo);
	
	var PR_SEQ = 0;

	if(pItemNoColValue != ""){
		if(_ItemNoColValue != pItemNoColValue){
			PR_SEQ = getMaxPR_SEQ() + 1;
			_ItemNoColValue = pItemNoColValue;
		}else{
			if(_openFlag){
				PR_SEQ = getMaxPR_SEQ() + 1;				
			}else{
				PR_SEQ = getMaxPR_SEQ();	
			}
		}
	}else{
		PR_SEQ = getMaxPR_SEQ() + 1;
	}
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_SEQ,   prSeqFormat(PR_SEQ));	
	
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,      specification);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,         makerCode);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,          ctrlCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_QTY,             qty);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,         itemGroup);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         unitPrice);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_EXCHANGE_RATE,      "1");
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,              ktgrm);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,         makerName);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,       basicUnit);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,      materialType);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,                "KRW");
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS,    "");
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS_CD, "");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_ITEM_NO,      	     pItemNoColValue);
	
	if(pItemNoColValue != ""){
		GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_SEQ,      	     tmp6);	
	}
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,      	     c_unit_price_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_CODE,      	     make_amt_code_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_DESCRIPTION_LOC,      	     p_description_loc_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_BOM_NAME,      	     p_bom_name_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_NAME,      	     make_amt_name_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_UNIT,      	     make_amt_unit_value);
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_WID,      	     wid);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_HGT,      	 hgt);
	
	return true;
}

function setCatalog2(itemNo, descriptionLoc, specification, makerCode, ctrlCode
		, qty, itemGroup, delyToAddress, unitPrice, ktgrm
		, makerName, basicUnit, materialType, pItemNoColValue, c_unit_price_value
		, make_amt_code_value, p_description_loc_value, p_bom_name_value, make_amt_name_value, make_amt_unit_value
		, imgPath, tmp6, prSeq, wid, hgt){
	
	if(chk_cItemDup(prSeq,itemNo)){
		return;
	}
	
	var i          = 0;
	var iMaxRow    = GridObj.GetRowCount();
	var newId      = (new Date()).valueOf();
	GridObj.addRow(newId,"");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SELECTED,     	     "true");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_NO,      	     itemNo);
	
	/*
	var PR_SEQ = 0;

	if(pItemNoColValue != ""){
		if(_ItemNoColValue != pItemNoColValue){
			PR_SEQ = getMaxPR_SEQ() + 1;
			_ItemNoColValue = pItemNoColValue;
		}else{
			if(_openFlag){
				PR_SEQ = getMaxPR_SEQ() + 1;				
			}else{
				PR_SEQ = getMaxPR_SEQ();	
			}
		}
	}else{
		PR_SEQ = getMaxPR_SEQ() + 1;
	}
	*/
	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_PR_SEQ,   prSeq);	
		
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DESCRIPTION_LOC,    descriptionLoc);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_SPECIFICATION,      specification);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_CODE,         makerCode);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CTRL_CODE,          ctrlCode);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_QTY,             qty);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_ITEM_GROUP,         itemGroup);
// 	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,         unitPrice);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_EXCHANGE_RATE,      "1");
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_KTGRM,              ktgrm);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKER_NAME,         makerName);
    GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_MEASURE,       basicUnit);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MATERIAL_TYPE,      materialType);
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_CUR,                "KRW");
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS,    "");
//     GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_DELY_TO_ADDRESS_CD, "");
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_ITEM_NO,      	     pItemNoColValue);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_UNIT_PRICE,      	     c_unit_price_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_CODE,      	     make_amt_code_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_DESCRIPTION_LOC,      	     p_description_loc_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_BOM_NAME,      	     p_bom_name_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_NAME,      	     make_amt_name_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_MAKE_AMT_UNIT,      	     make_amt_unit_value);
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_P_SEQ,      	     tmp6);	

	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_WID,      	     wid);	
	GD_SetCellValueIndex(GridObj, iMaxRow, INDEX_HGT,      	 hgt);	

	return true;
}

//Catalog 팝업
function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	var wise = GridObj;

	if(part == "CATALOG"){ //카탈로그
		
		url = "/kr/catalog/cat_pp_lis_main_so.jsp?INDEX=&gate=gate_a&VENDOR_CODE=<%=VENDOR_CODE%>";	
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}
}

//행삭제시 호출 되는 함수 입니다.
// function doDeleteRow()
// {
// 	var grid_array = getGridChangedRows(GridObj, "SEL");
// 	var rowcount = grid_array.length;
// 	GridObj.enableSmartRendering(false);

// 	for(var row = rowcount - 1; row >= 0; row--)
// 	{
// 		if("1" == GridObj.cells(grid_array[row], 0).getValue())
// 		{
// 			GridObj.deleteRow(grid_array[row]);
//     	}
//     }
// }

function doDeleteRow() {
	var rowCount = GridObj.GetRowCount();
	var selected = false;
	var pr_no = "";
	var pr_seq = "";
	var rowid    = "";
	
	for(var i = (rowCount - 1); i >= 0; i--){
		selected   = GD_GetCellValueIndex(GridObj, i, INDEX_SELECTED);
		pr_no = GD_GetCellValueIndex(GridObj, i, INDEX_PR_NO); 
		pr_seq = GD_GetCellValueIndex(GridObj, i, INDEX_PR_SEQ); 
		
		if(selected == true){
			
			if(pr_no != ""){
				alert("구매요청 실사품목은 삭제불가 합니다.");
				break;
			}
		
			rowid = GridObj.getRowId(i);
			
			GridObj.deleteRow(rowid);
		}
	}
}

/*
첫번째 행의 납품요청일자/납품일자 모든 행에 일괄적용
*/
function setDeliveryData() {
	var RD_DATE = '';
	var DELY_TO_ADDRESS = '';
	var DELY_TO_ADDRESS_CD = '';
	
	var iRowCount = GridObj.GetRowCount();
	
	for(var i = 0; i < iRowCount; i++) {
		if(i == 0) {
			RD_DATE = GD_GetCellValueIndex(GridObj,i, INDEX_DELIVERY_LT);
			DELY_TO_ADDRESS = GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION);
			DELY_TO_ADDRESS_CD = GD_GetCellValueIndex(GridObj,i, INDEX_DELY_TO_DEPT);
		} else {
			if(isEmpty(RD_DATE) || isEmpty(DELY_TO_ADDRESS)){
				alert('첫번째 행의 납기가능일자/납품장소를 입력하십시오.');
				return;
			} else {
				GD_SetCellValueIndex(GridObj,i, INDEX_DELIVERY_LT		, RD_DATE);
				GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_LOCATION	, DELY_TO_ADDRESS);
				GD_SetCellValueIndex(GridObj,i, INDEX_DELY_TO_DEPT		, DELY_TO_ADDRESS_CD);
			}
		}
	}
}
// // 행삭제시 호출 되는 함수 입니다.
// function doDeleteRow()
// {
// 	var grid_array = getGridChangedRows(GridObj, "SELECTED");
// 	var rowcount = grid_array.length;
// 	GridObj.enableSmartRendering(false);

// 	for(var row = rowcount - 1; row >= 0; row--)
// 	{
// 		if("1" == GridObj.cells(grid_array[row], 0).getValue())
// 		{
// 			GridObj.deleteRow(grid_array[row]);
//     	}
//     }
// }

</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" text="#000000" >
<s:header>
	<form name="form1" action="">
		<input type="hidden" name="osq_no"          id="osq_no"             value="<%=OSQ_NO%>">
		<input type="hidden" name="ttl_charge"      id="ttl_charge"         value="">
		<input type="hidden" name="vendor_code"     id="vendor_code"        value="<%=VENDOR_CODE%>">
		<input type="hidden" name="subject"         id="subject"            value="<%=SUBJECT%>">
		<input type="hidden" name="price_type"      id="price_type"         value="<%=PRICE_TYPE%>">
		<input type="hidden" name="bid_req_type"    id="bid_req_type"       value="<%=BID_REQ_TYPE%>">
		<input type="hidden" name="flag"             id="flag">
		<input type="hidden" name="Next"             id="Next">
		<input type="hidden" name="osq_close_date"   id="osq_close_date"  value="<%=OSQ_CLOSE_DATE%>">
		<input type="hidden" name="osq_close_time"   id="osq_close_time"  value="<%=OSQ_CLOSE_TIME%>">
		<input type="hidden" name="t_from_date"      id="t_from_date">      
		<input type="hidden" name="t_to_date"        id="t_to_date">        
		<input type="hidden" name="t_from_qty"       id="t_from_qty">       
		<input type="hidden" name="t_to_qty"         id="t_to_qty">         
		<input type="hidden" name="t_unit_price"     id="t_unit_price">     
		<input type="hidden" name="osq_no"           id="osq_no"          size="20" class="inputsubmit" value="<%=OSQ_NO%>">
		<input type="hidden" name="osq_count"        id="osq_count"       size="2" class="inputsubmit" value="<%=OSQ_COUNT%>">
		<input type="hidden" name="vendor_code"      id="st_vendor_code"     size="10" class="input_re" value="<%=VENDOR_CODE%>">
		<input type="hidden" name="group_yn"         id="group_yn"           size="10" class="input_re" value="<%=GROUP_YN%>">
		<input type="hidden" name="st_vendor_id"     id="st_vendor_name"     size="30" class="input_data1" value="<%=VENDOR_NAME%>">
		<input type="hidden" name="shipper_type"     id="shipper_type"       value="<%=SHIPPER_TYPE%>">
		<input type="hidden" name="send_flag"        id="send_flag"          >
		<input type="hidden" name="net_amt"          id="net_amt"            >
		<input type="hidden" name="attach_gubun"     id="attach_gubun"       value="body">
		<input type="hidden" name="att_mode"         id="att_mode"           value="">
		<input type="hidden" name="view_type"        id="view_type"          value="">
		<input type="hidden" name="file_type"        id="file_type"          value="">
		<input type="hidden" name="selected_Row"     id="selected_Row"       value="">
		<input type="hidden" name="real_or_no"     id="real_or_no"       value="<%=SOR_NO%>">
		<input type="hidden" name="real_pr_no"     id="real_pr_no"       value="<%=real_pr_no%>">
		
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
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청번호</td>
										<td width="50%" class="data_td">
											<input type="text" name="osq_no" id="osq_no" size="20" value="<%=OSQ_NO%>" class="input_data2">
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
										<td width="20%" class="data_td">
											<input type="text" name="osq_count" id="osq_count" size="5" value="<%=OSQ_COUNT%>" class="input_data2">
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청명</td>
										<td width="35%" class="data_td">
											<%=SUBJECT%>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;실사요청일자</td>
										<td width="35%" class="data_td">
											<%=OSQ_DATE%>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사특기사항</td>
										<td width="35%" class="data_td" colspan="3">
	     									<table>
	      										<tr>
	      											<td>
		        										<textarea name="osq_remark" id="osq_remark"  cols="120" rows="5" readonly><%=OSQ_REMARK %></textarea>
		        									</td>
		        									<td>&nbsp;</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매사첨부파일</td>
										<td class="data_td" colspan="3" height="150">
											<input type="hidden" value="<%=OS_ATTACH_NO %>" name="os_attach_no" id="os_attach_no">
											<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=OS_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>			
										</td>		
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사특기사항</td>
										<td width="35%" class="data_td" colspan="3">
	     									<table>
	      										<tr>
	      											<td>	
	     			 									<textarea name="remark" id="remark"  cols="120" rows="5" onKeyUp="return chkMaxByte(500, this, '특기사항');"><%=OR_REMARK %></textarea>
	      											</td>
	      										</tr>
	      									</table>	
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>	
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공급사첨부파일</td>
										<td class="data_td" colspan="3" height="150">
											<table>
												<tr>
													<td>
<script language="javascript">
btn("javascript:goAttach($('#osq_attach_no').val(),'SO')", "파일등록");
</script>
													</td>
													<td>
														<input type="text" size="3" readOnly class="input_empty" value="0" name="osq_attach_no_count" id="osq_attach_no_count"/>
														<input type="hidden" value="" name="osq_attach_no" id="osq_attach_no"/>
													</td>
												</tr>
											</table>		
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

				<td height="30" align="left">
					<TABLE cellpadding="0" border="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:setDeliveryData()", "납기가능일/납품장소 일괄적용");
</script>
							</TD>
							<TD>
								<font color="red" style="font-size:10px">&nbsp;* 납기가능일과 납품장소를<br>&nbsp;&nbsp;&nbsp;&nbsp;첫번째 행 기준으로 일괄적용합니다.</font>
							</TD>
						</TR>
					</TABLE>
				</td>
				<td height="30" align="left">
					<table cellpadding="0" border="0">
						<tr>
							<td>
								<script language="javascript"> btn("javascript:fnMa014Pop()", "BOM품목"); </script>
							</td>
							<td>
								<script language="javascript"> btn("javascript:fnMa014_1Pop()", "BOM자품추가"); </script>
							</td>
							<td>
								<script language="javascript"> btn("javascript:PopupManager('CATALOG')", "품목카탈로그"); </script>
							</td>
						</tr>
					</table>
				</td>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<td>
								<script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script>
							</td>
							<td style="display:none">
								<script language="javascript"> btn("javascript:doSave('N')", "임시저장"); </script>
							</td>
							<td>
								<script language="javascript"> btn("javascript:doSave('Y')", "제 출"); </script>
							</td>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="SSO_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<iframe name="magic" src="" width="0" height="0">
</body>
</html>