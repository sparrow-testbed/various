<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SRQ_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SRQ_007";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SRQ_007";%>

		<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");

    String VENDOR_CODE  = JSPUtil.nullToEmpty(request.getParameter("st_vendor_code"));
    String QTA_NO       = JSPUtil.nullToEmpty(request.getParameter("st_qta_no"));
    String RFQ_NO       = JSPUtil.nullToEmpty(request.getParameter("st_rfq_no"));
    String RFQ_COUNT    = JSPUtil.nullToEmpty(request.getParameter("st_rfq_count"));

	String VENDOR_NAME            = "";
	String SUBJECT                = "";
	String RFQ_CLOSE_DATE_VIEW    = "";
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
	String SHIPPER_TYPE           = "";
	String SHIPPER_TYPE_TEXT      = "";
	String QTA_VAL_DATE_VIEW      = "";
	String RFQ_REMARK             = "";
	String REMARK                 = "";
	String RQAN_CNT               = "";
	String BID_REQ_TYPE           = "";
	String CREATE_TYPE		 	 = "";
	String QTA_ATTACH_NO		 = "";
	String QTA_ATTACH_CNT		 = "";
	String RFQ_ATTACH_NO		 = "";
	String RFQ_ATT_COUNT		 = "";
	String GROUP_YN 			  = "N";
	String RPT_GETFILENAMES1      = "";
	String RPT_GETFILENAMES2      = "";

    int rw_cnt = -1;

    Object[] obj = {RFQ_NO,RFQ_COUNT,VENDOR_CODE, QTA_NO};
	SepoaOut value = ServiceConnector.doService(info, "s2021", "CONNECTION", "getQuery_Upd_Qta_Header", obj);
    SepoaFormater wf = new SepoaFormater(value.result[0]);

	if(wf.getRowCount() > 0) {
		VENDOR_NAME               = wf.getValue("VENDOR_NAME         ", 0);
		SUBJECT                   = wf.getValue("SUBJECT             ", 0);
		RFQ_CLOSE_DATE_VIEW       = wf.getValue("RFQ_CLOSE_DATE_VIEW ", 0);
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
		SHIPPER_TYPE              = wf.getValue("SHIPPER_TYPE        ", 0);
		SHIPPER_TYPE_TEXT         = wf.getValue("SHIPPER_TYPE_TEXT   ", 0);
		QTA_VAL_DATE_VIEW         = wf.getValue("QTA_VAL_DATE_VIEW   ", 0);
		RFQ_REMARK                = wf.getValue("RFQ_REMARK          ", 0);
		REMARK                    = wf.getValue("REMARK              ", 0);
		RQAN_CNT                  = wf.getValue("RQAN_CNT            ", 0);
		BID_REQ_TYPE           	  = wf.getValue("BID_REQ_TYPE        ", 0);
		CREATE_TYPE         	  = wf.getValue("CREATE_TYPE  	  	", 0);
		QTA_ATTACH_NO         	  = wf.getValue("ATTACH_NO  	  	", 0);
		QTA_ATTACH_CNT			  = wf.getValue("ATTACH_CNT  	  	", 0);
		RFQ_ATTACH_NO         	  = wf.getValue("RFQ_ATTACH_NO  	  ", 0);
		RFQ_ATT_COUNT			  = wf.getValue("RFQ_ATT_COUNT  	  ", 0);
		RPT_GETFILENAMES1		  = wf.getValue("RPT_GETFILENAMES1	  ", 0);
		RPT_GETFILENAMES2		  = wf.getValue("RPT_GETFILENAMES2 	  ", 0);
	}
		    Object[] obj2 = {RFQ_NO ,RFQ_COUNT };
			SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj2);
			SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
			int wf2_cnt = wf2.getRowCount();

			//if(BID_REQ_TYPE.equals("I"))   GROUP_YN = "Y";
			//else    GROUP_YN = "N";

	
	Map<String, String> data = new HashMap();
	data.put("st_vendor_code"	, VENDOR_CODE);
	data.put("st_qta_no"		, QTA_NO);
	Object[] obj3 = {data};

	SepoaOut value3 = ServiceConnector.doService(info, "s2021", "CONNECTION", "getQuery_Upd_Qta_Detail_Qta", obj3);
	SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
				
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_qta_pp_dis1"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(RFQ_NO);	//견적요청번호
	_rptData.append(_RF);
	_rptData.append(RFQ_COUNT);	//차수
	_rptData.append(_RF);	
	_rptData.append(QTA_NO);	//견적서번호
	_rptData.append(_RF);
	_rptData.append(VENDOR_NAME);	//견적업체
	_rptData.append(_RF);
	_rptData.append(SUBJECT);	//견적요청명
	_rptData.append(_RF);
	_rptData.append(RFQ_CLOSE_DATE_VIEW);	//견적마감일
	_rptData.append(_RF);
	_rptData.append(DELY_TERMS_TEXT);	//인도조건
	_rptData.append(_RF);
	_rptData.append(PAY_TERMS_TEXT);	//지급조건
	_rptData.append(_RF);
	_rptData.append(QTA_VAL_DATE_VIEW);	//유효일자
	_rptData.append(_RF);
	_rptData.append(RFQ_REMARK);	//구매사 특기사항
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES1);		//구매사 첨부파일  
	_rptData.append(_RF);
	_rptData.append(REMARK);	//공급사 특기사항 
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES2);		//공급사 첨부파일
	
	
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
				_rptData.append(wf3.getValue("SUPPLY_PRICE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("SUPPLY_AMT", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("DELIVERY_LT", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("RD_DATE", i));
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
	<title>
		<%=text.get("MESSAGE.MSG_9999")%>
	</title> <%-- 우리은행 전자구매시스템 --%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
    var G_Pos= -1;
    var Arow;
    var summaryCnt = 0;

	var INDEX_SEL             ;
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
	var INDEX_CUSTOMER_PRICE					;
	var INDEX_CUSTOMER_AMT						;
	var INDEX_SUPPLY_PRICE						;
	var INDEX_SUPPLY_AMT						;
	var INDEX_SEC_VENDOR_CODE_TEXT	;
	var INDEX_SEC_VENDOR_CODE		;	


    function init()
    {
// 		GridObj.bHDSwapping = false;
// 		GridObj.bHDMoving = false;
// 		GridObj.nHDLineSize  = 32;

		setGridDraw();
		setHeader();
		doSelect();
    }

    function setHeader() {

        var frm = document.forms[0];

       /*  GridObj.AddHeader("UNIT_PRICE_IMG"   			,"" 			,"t_imagetext"	,100,0,false);


	    GridObj.AddGroup("CUSTOMER_PRICE", "List Price");
 		GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_PRICE");
  		GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_AMT");
	    GridObj.AddGroup("SUPPLY_PRICE", "공급가");
 		GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_PRICE");
  		GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_AMT");


		GridObj.SetColCellSortEnable("DESCRIPTION_LOC",false);
		GridObj.SetColCellSortEnable("SPECIFICATION",false);
		GridObj.SetNumberFormat("RFQ_QTY",G_format_qty);
		GridObj.SetColCellSortEnable("RFQ_QTY",false);
		GridObj.SetNumberFormat("ITEM_QTY",G_format_qty);
		GridObj.SetColCellSortEnable("ITEM_QTY",false);
		GridObj.SetColCellSortEnable("UNIT_MEASURE",false);
		GridObj.SetNumberFormat("CUSTOMER_PRICE",G_format_qty);
		GridObj.SetNumberFormat("SUPPLY_PRICE",G_format_qty);
		GridObj.SetNumberFormat("CUSTOMER_AMT",G_format_qty);
		GridObj.SetNumberFormat("SUPPLY_AMT",G_format_qty);
		GridObj.SetNumberFormat("BEFORE_PRICE",G_format_qty);
		GridObj.SetNumberFormat("ITEM_AMT",G_format_qty);
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
		GridObj.SetNumberFormat("DISCOUNT",       "###,###,###,###,###.###");
		GridObj.SetNumberFormat("RATE",       		G_format_qty);
 */
		
		INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
		INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		INDEX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
		INDEX_RFQ_QTY               = GridObj.GetColHDIndex("RFQ_QTY");
		INDEX_ITEM_QTY              = GridObj.GetColHDIndex("ITEM_QTY");

		INDEX_VENDOR_ITEM_NO        = GridObj.GetColHDIndex("VENDOR_ITEM_NO");
		INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
		INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("SUPPLY_PRICE");
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
		INDEX_EP_FROM_DATE          = GridObj.GetColHDIndex("EP_FROM_DATE");

		INDEX_EP_TO_DATE            = GridObj.GetColHDIndex("EP_TO_DATE");
		INDEX_EP_FROM_QTY           = GridObj.GetColHDIndex("EP_FROM_QTY");
		INDEX_EP_TO_QTY             = GridObj.GetColHDIndex("EP_TO_QTY");
		INDEX_EP_UNIT_PRICE         = GridObj.GetColHDIndex("EP_UNIT_PRICE");
		INDEX_DELY_TO_LOCATION      = GridObj.GetColHDIndex("DELY_TO_LOCATION");

		INDEX_SHIPPER_TYPE          = GridObj.GetColHDIndex("SHIPPER_TYPE");
		INDEX_MOLDING_FLAG          = GridObj.GetColHDIndex("MOLDING_FLAG");

		INDEX_CUSTOMER_PRICE        = GridObj.GetColHDIndex("CUSTOMER_PRICE" );
		INDEX_CUSTOMER_AMT        	= GridObj.GetColHDIndex("CUSTOMER_AMT" );
		INDEX_SUPPLY_PRICE          = GridObj.GetColHDIndex("SUPPLY_PRICE" );
		INDEX_SUPPLY_AMT          	= GridObj.GetColHDIndex("SUPPLY_AMT" );
		
		INDEX_SEC_VENDOR_CODE_TEXT	= GridObj.GetColHDIndex("SEC_VENDOR_CODE_TEXT");
		INDEX_SEC_VENDOR_CODE		= GridObj.GetColHDIndex("SEC_VENDOR_CODE");

        //doSelect();
    }

    function doSelect()
    {
//         var frm             = document.forms[0];
//         var mode            = "getQuery_Upd_Qta_Detail_Qta";

       <%--  GridObj.SetParam("VENDOR_CODE", "<%=VENDOR_CODE%>");
        GridObj.SetParam("QTA_NO", "<%=QTA_NO%>");
        GridObj.SetParam("GROUP_YN", "<%=GROUP_YN%>");
        GridObj.SetParam("mode",mode);

        var servletUrl = "supply.bidding.qta.qta_pp_dis1";

        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl); --%>
		//$('#st_qta_no').val("<%=QTA_NO%>");
		$('#st_group_yn').val("<%=GROUP_YN%>");
				
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.qta.qta_pp_dis1";
		var cols_ids = "<%=grid_col_id%>";
        var param = "mode=getQuery_Upd_Qta_Detail_Qta&cols_ids="+cols_ids;
		    param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false); 
		
		
		
    }

    function openPopup1() {
        if("<%=RQAN_CNT%>" == "0")
        {
            alert("해당 견적요청서에는 '제안설명회'에 대한 정보가 없습니다.");
            return;
        }

        var rfq_no      = "<%=RFQ_NO%>";
        var rfq_count   = "<%=RFQ_COUNT%>";

        window.open('/kr/dt/rfq/rfq_pp_dis5.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count ,"windowopen_rfq1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {

        var maxRow = GridObj.GetRowCount();

	    for(var i=0;i<GridObj.GetRowCount();i++) {
	           if(i%2 == 1){
			    for (var j = 0;	j<GridObj.GetColCount(); j++){
			        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
		        }
	           }
		}

        if(msg1 == "doQuery") {
            var maxRow = GridObj.GetRowCount();
            var tmp_camt = 0;
            var tmp_samt = 0;
            var tmp_amt = 0;
            var c_amt = 0;
            var s_amt = 0;
            var i_amt = 0;
            var tmp_discount = 0;

           /*  for(i=0; i<maxRow; i++) {

				customer_unitPrice = GD_GetCellValueIndex(GridObj,i, INDEX_CUSTOMER_PRICE);
				supply_unitPrice = GD_GetCellValueIndex(GridObj,i, INDEX_SUPPLY_PRICE);

				itemQty = GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY);
                tmp_camt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj,i, INDEX_CUSTOMER_AMT, setAmt(tmp_camt));
                c_amt = c_amt +  tmp_camt;
                
				itemQty = GD_GetCellValueIndex(GridObj,i, INDEX_RFQ_QTY);
                tmp_samt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj,i, INDEX_SUPPLY_AMT, setAmt(tmp_samt));
                s_amt = s_amt +  tmp_samt;

				tmp_amt = GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_AMT);
                i_amt = eval(i_amt) +  eval(tmp_amt);
            } 

			
				form1.attach_count.value = "<%=RFQ_ATT_COUNT%>";
                form1.QTA_ATTACH_COUNT.value = "<%=QTA_ATTACH_CNT%>";
				if(summaryCnt == 0) {
					GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'RFQ_QTY,CUSTOMER_AMT,SUPPLY_AMT,ITEM_AMT');
					GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
					summaryCnt++;
				}
			*/
        }  // if 문끝
        else if(msg1 == "t_imagetext")
        {
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
                          return;
                    } else if("<%=SPRICE_TYPE%>" == "P")
                    {
                        var loc2 = "qta_bd_ins1_p.jsp?XPosition="+ msg2 + "&FLAG=D";
                        window.open(loc2  , "newWin2","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
                    } else if("<%=SPRICE_TYPE%>" == "Q")
                    {
                        var loc2 = "qta_bd_ins1_q.jsp?XPosition="+ msg2 + "&FLAG=D";
                        window.open(loc2  , "newWin2","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
                    } else if("<%=SPRICE_TYPE%>" == "V")
                    {
                        var loc2 = "qta_bd_ins1_v.jsp?XPosition="+ msg2 + "&FLAG=D";
                        window.open(loc2  , "newWin2","left=0,top=0,width=530,height=290,resizable=no,scrollbars=no");
                    }
                }
            }

            if(msg3 == INDEX_ITEM_NO)
            {
                var wt = GridObj;
                var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
                POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
            }

            if(msg3 == INDEX_QTA_ATTACH_NO)
            {
                var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_QTA_ATTACH_NO));
 /*
                var QTA_NO    = "<%=QTA_NO%>";
                var RFQ_NO    = "<%=RFQ_NO%>";
                var RFQ_COUNT = "<%=RFQ_COUNT%>";
                var RFQ_SEQ = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_SEQ));
				if("PF" == ATTACH_NO_VALUE) {
	            	var loc2 = "qta_pp_dis4.jsp?XPosition="+ msg2 + "&QTA_NO="+QTA_NO+"&RFQ_NO="+RFQ_NO+"&RFQ_COUNT="+RFQ_COUNT+"&RFQ_SEQ="+RFQ_SEQ;
	            	window.open(loc2  , "qta_pp_dis4","left=0,top=0,width=730,height=400,resizable=no,scrollbars=no");
                }else{
	                if("N" != ATTACH_NO_VALUE) {
	                    FileAttach('QTA',ATTACH_NO_VALUE,'VI');
	                }
	            }
*/
				rMateFileAttach('P','R','QTA',ATTACH_NO_VALUE,'S');
            }

            if(msg3 == INDEX_RFQ_ATTACH_NO)
            {
                var RFQ_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_ATTACH_NO));

                if("N" != RFQ_ATTACH_NO_VALUE) {
//                    FileAttach('RFQ',RFQ_ATTACH_NO_VALUE,'VI');
					rMateFileAttach('P','R','RFQ',RFQ_ATTACH_NO_VALUE,'B');
                }
            }

            if(msg3 == INDEX_PRICE_DOC)
            {
                var PRICE_DOC_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_PRICE_DOC));
                var wt = GridObj;

                var RFQ_NO      = "<%=RFQ_NO%>";
                var RFQ_COUNT   = "<%=RFQ_COUNT%>";
                var RFQ_SEQ     = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_SEQ);
                var VENDOR_CODE = document.forms[0].st_vendor_code.value;

                G_Pos = msg2;

                if("0" != PRICE_DOC_VALUE) {
                    window.open('qta_pp_dis7.jsp?XPosition='+ msg2 + '&RFQ_NO=' + RFQ_NO + '&RFQ_COUNT=' + RFQ_COUNT +'&RFQ_SEQ=' + RFQ_SEQ +'&PRICE_DOC=' +PRICE_DOC_VALUE + '&VENDOR_CODE=' + VENDOR_CODE,"win_cost","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=465,height=300,left=0,top=0");
                }
            }
        }
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
	function ozCall(){
		url = "/oz/oz_rfq_genjuk.jsp?";
		url += "house_code=<%=HOUSE_CODE%>&rfq_no=<%=RFQ_NO%>&rfq_count=<%=RFQ_COUNT%>&vendor_code=<%=VENDOR_CODE%>&qta_no=<%=QTA_NO%>";
		window.open(url,"windowopen2","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=600,left=0,top=0");
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
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF">

<s:header popup="true">
<!--내용시작-->

<form name="form1" action="">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<%--ClipReport4 hidden 태그 끝--%>	
	<input type="hidden" name="t_from_date"         id="t_from_date"            >
	<input type="hidden" name="t_to_date"           id="t_to_date"              >
	<input type="hidden" name="t_from_qty"          id="t_from_qty"             >
	<input type="hidden" name="t_to_qty"            id="t_to_qty"               >
	<input type="hidden" name="t_unit_price"        id="t_unit_price"           >
	<input type="hidden" name="st_vendor_code"      id="st_vendor_code"         value="<%=VENDOR_CODE%>">
	<input type="hidden" name="st_qta_no"           id="st_qta_no"              value="<%=QTA_NO%>">
	<input type="hidden" name="st_group_yn"         id="st_group_yn"            value="">
	<input type="hidden" name="attach_no"           id="attach_no"              value="<%=RFQ_ATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="QTA_ATTACH_NO"       id="QTA_ATTACH_NO"          value="<%=QTA_ATTACH_NO%>">
	<input type="hidden" name="QTA_ATTACH_COUNT"    id="QTA_ATTACH_COUNT"       >
                                                                              
	<input type="hidden" name="att_mode"            id="att_mode"               value="">
	<input type="hidden" name="view_type"           id="view_type"              value="">
	<input type="hidden" name="file_type"           id="file_type"              value="">
	<input type="hidden" name="tmp_att_no"          id="tmp_att_no"             value="">
	<input type="hidden" name="attach_count"        id="attach_count"           value="">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>견적서 상세조회
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
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호
	</td>
	<td class="data_td" width="35%">
		<%=RFQ_NO%>
	</td>
	<td width="15%" class="title_td">
&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 차수
	</td>
	<td class="data_td" width="35%">
		<%=RFQ_COUNT%>
		&nbsp;
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적서번호
	</td>
	<td class="data_td" width="35%">
		<%=QTA_NO%>
		&nbsp;
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적업체
	</td>
	<td class="data_td" width="35%">
		<input type="text" name="st_vendor_name" size="20" class="input_data2" value="<%=VENDOR_NAME%>" readonly>
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
		&nbsp;
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
		&nbsp;
	</td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건
	</td>
	<td width="35%" class="data_td">
		<%=PAY_TERMS_TEXT%>
		&nbsp;
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유효일자
	</td>
	<td class="data_td" colspan="3">
		<%=QTA_VAL_DATE_VIEW%>
		&nbsp;
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사 특기사항
	</td>
	<td width="35%" class="data_td" colspan="3">
      <textarea name="RFQ_REMARK" class="inputsubmit" cols="120" rows="5" readonly><%=RFQ_REMARK %></textarea>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사 첨부파일</td>
	<td class="data_td" colspan="3" height="150">
		<iframe id="attachBFrame" name="attachBFrame" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=RFQ_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
		<br>&nbsp;
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>

<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사 특기사항
	</td>
	<td width="35%" class="data_td" colspan="3">
      <textarea name="REMARK" class="inputsubmit" cols="120" rows="5" readonly><%=REMARK %></textarea>
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">공급사 첨부파일</td>
	<td class="data_td" colspan="3" height="150">
<iframe id="attachSFrame" name="attachSFrame" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=QTA_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
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

		<%if(!RQAN_CNT.equals("0")){ %>
  			<td><script language="javascript">btn("javascript:openPopup1()","제안설명회")</script></td>
		<%}%>
			<TD><script language="javascript">btn("javascript:clipPrint()","출 력")</script></TD>
			<td><script language="javascript">btn("javascript:window.close()","닫 기")</script></td>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

</form>
</s:header>
<s:grid screen_id="SRQ_007" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


