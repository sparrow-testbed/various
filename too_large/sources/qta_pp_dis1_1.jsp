<%--
    Title                            :          qta_pp_dis1.jsp  <p>
    Description                      :          견적현황 <p>
    Copyright                        :          Copyright (c) <p>
    Company                          :          SEPOASOFT <p>
    @author                          :          WKHONG(2014.10.06)<p>
    @version                         :          1.0
    @Comment                         :          견적내용을 조회하는 화면이다.
    @SCREEN_ID                       :          RQ_245
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
	multilang_id.addElement("RQ_245");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_245";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_245";%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

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
	String SPRICE_TYPE            = "";
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
	String BID_REQ_TYPE			  = "";
	String CREATE_TYPE		 	  = "";
	String QTA_ATTACH_NO	 	  = "";
	String QTA_ATTACH_CNT		 = "";
	String RFQ_ATTACH_NO			 = "";
	String RFQ_ATT_COUNT			 = "";

	String Z_SMS_SEND_FLAG        = "";
	String Z_RESULT_OPEN_FLAG     = "";
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
		BID_REQ_TYPE              = wf.getValue("BID_REQ_TYPE        ", 0);
		CREATE_TYPE         	  = wf.getValue("CREATE_TYPE  	  	", 0);
		QTA_ATTACH_NO			  = wf.getValue("ATTACH_NO  	  	", 0);
		QTA_ATTACH_CNT			  = wf.getValue("ATTACH_CNT  	  	", 0);
		RFQ_ATTACH_NO         	  = wf.getValue("RFQ_ATTACH_NO  	  ", 0);
		RFQ_ATT_COUNT			  = wf.getValue("RFQ_ATT_COUNT  	  ", 0);

		Z_SMS_SEND_FLAG           = wf.getValue("Z_SMS_SEND_FLAG	", 0);
		Z_RESULT_OPEN_FLAG        = wf.getValue("Z_RESULT_OPEN_FLAG	", 0);
		
		RPT_GETFILENAMES1		  = wf.getValue("RPT_GETFILENAMES1	  ", 0);
		RPT_GETFILENAMES2		  = wf.getValue("RPT_GETFILENAMES2 	  ", 0);

	}
	Object[] obj2 = {RFQ_NO,RFQ_COUNT};
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
	int wf2_cnt = wf2.getRowCount();
	
	Map<String, String> data = new HashMap();
	data.put("vendor_code"	, VENDOR_CODE);
	data.put("qta_no"		, QTA_NO);
	Object[] obj3 = {data};
	SepoaOut value3 = ServiceConnector.doService(info, "p1071", "CONNECTION", "getQtaDispDT", obj3);
	SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
			
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_qta_pp_dis1_kr"; //리포트명
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
	_rptData.append(VENDOR_CODE);	//견적업체1
	_rptData.append(_RF);
	_rptData.append(VENDOR_NAME);	//견적업체2
	_rptData.append(_RF);
	_rptData.append(SUBJECT);	//견적요청명
	_rptData.append(_RF);
	_rptData.append(RFQ_CLOSE_DATE_VIEW);	//견적마감일
	_rptData.append(_RF);
	_rptData.append(DELY_TERMS_TEXT);	//인도조건
	_rptData.append(_RF);
	_rptData.append(PAY_TERMS_TEXT);	//지급조건
	_rptData.append(_RF);
	_rptData.append(SETTLE_TYPE_TEXT);	//비교방식
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
				_rptData.append(wf3.getValue("SUPPLY_PRICE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue(i,13));
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

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
//<!--
    var mode;
    var G_Pos= -1;
    var Arow;
    var summaryCnt = 0;

	var IDX_SEL             ;
	var IDX_ITEM_NO         ;
	var IDX_DESCRIPTION_LOC ;
	var IDX_SPECIFICATION   ;
	var IDX_RFQ_QTY         ;
	var IDX_ITEM_QTY        ;
	var IDX_VENDOR_ITEM_NO  ;
	var IDX_UNIT_MEASURE    ;
	var IDX_UNIT_PRICE      ;
	var IDX_UNIT_PRICE_IMG  ;
	var IDX_BEFORE_PRICE    ;
	var IDX_ITEM_AMT        ;
	var IDX_DELIVERY_LT     ;
	var IDX_RD_DATE         ;
	var IDX_DELY_TO_LOCATION_NAME ;
	var IDX_YEAR_QTY        ;
	var IDX_RFQ_ATTACH_NO   ;
	var IDX_QTA_ATTACH_NO   ;
	var IDX_PRICE_DOC       ;
	var IDX_MOLDING_CHARGE  ;
	var IDX_PURCHASER       ;
	var IDX_PURCHASER_PHONE ;
	var IDX_RFQ_SEQ         ;
	var IDX_MAKER_CODE      ;
	var IDX_MAKER_NAME      ;
	var IDX_EP_FROM_DATE    ;
	var IDX_EP_TO_DATE      ;
	var IDX_EP_FROM_QTY     ;
	var IDX_EP_TO_QTY       ;
	var IDX_EP_UNIT_PRICE   ;
	var IDX_DELY_TO_LOCATION;
	var IDX_SHIPPER_TYPE    ;
	var IDX_MOLDING_FLAG    ;
	var IDX_SEC_VENDOR_CODE ;
	var IDX_SEC_VENDOR_CODE_TEXT ;


    function Init()
    {
		setGridDraw();
		setHeader();
    }

    function setHeader() {

        var frm = document.forms[0];

		IDX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
		IDX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
		IDX_SPECIFICATION         = GridObj.GetColHDIndex("SPECIFICATION");
		IDX_RFQ_QTY               = GridObj.GetColHDIndex("RFQ_QTY");
		IDX_ITEM_QTY              = GridObj.GetColHDIndex("ITEM_QTY");

		INDEX_ITEM_AMT              = GridObj.GetColHDIndex("ITEM_AMT");
		IDX_VENDOR_ITEM_NO        = GridObj.GetColHDIndex("VENDOR_ITEM_NO");
		IDX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
		IDX_BEFORE_PRICE          = GridObj.GetColHDIndex("BEFORE_PRICE");

		IDX_ITEM_AMT              = GridObj.GetColHDIndex("ITEM_AMT");
		IDX_DELIVERY_LT           = GridObj.GetColHDIndex("DELIVERY_LT");
		IDX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
		IDX_DELY_TO_LOCATION_NAME = GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME");
		IDX_YEAR_QTY              = GridObj.GetColHDIndex("YEAR_QTY");

		IDX_RFQ_ATTACH_NO         = GridObj.GetColHDIndex("RFQ_ATTACH_NO");
		IDX_QTA_ATTACH_NO         = GridObj.GetColHDIndex("QTA_ATTACH_NO");
		IDX_PRICE_DOC             = GridObj.GetColHDIndex("PRICE_DOC");
		IDX_MOLDING_CHARGE        = GridObj.GetColHDIndex("MOLDING_CHARGE");
		IDX_PURCHASER             = GridObj.GetColHDIndex("PURCHASER");

		IDX_PURCHASER_PHONE       = GridObj.GetColHDIndex("PURCHASER_PHONE");
		IDX_RFQ_SEQ               = GridObj.GetColHDIndex("RFQ_SEQ");
		IDX_MAKER_CODE            = GridObj.GetColHDIndex("MAKER_CODE");
		IDX_MAKER_NAME            = GridObj.GetColHDIndex("MAKER_NAME");
		IDX_EP_FROM_DATE          = GridObj.GetColHDIndex("EP_FROM_DATE");

		IDX_EP_TO_DATE            = GridObj.GetColHDIndex("EP_TO_DATE");
		IDX_EP_FROM_QTY           = GridObj.GetColHDIndex("EP_FROM_QTY");
		IDX_EP_TO_QTY             = GridObj.GetColHDIndex("EP_TO_QTY");
		IDX_EP_UNIT_PRICE         = GridObj.GetColHDIndex("EP_UNIT_PRICE");
		IDX_DELY_TO_LOCATION      = GridObj.GetColHDIndex("DELY_TO_LOCATION");

		IDX_SHIPPER_TYPE          = GridObj.GetColHDIndex("SHIPPER_TYPE");
		IDX_MOLDING_FLAG          = GridObj.GetColHDIndex("MOLDING_FLAG");
		IDX_CUSTOMER_PRICE        = GridObj.GetColHDIndex("CUSTOMER_PRICE" );
		IDX_CUSTOMER_AMT          = GridObj.GetColHDIndex("CUSTOMER_AMT" );
		IDX_SUPPLY_PRICE          = GridObj.GetColHDIndex("SUPPLY_PRICE" );
		IDX_SUPPLY_AMT            = GridObj.GetColHDIndex("SUPPLY_AMT" );

		
		IDX_HUMAN_COMPANY_CODE    = GridObj.GetColHDIndex("HUMAN_COMPANY_CODE" );
		IDX_HUMAN_VENDOR_CODE     = GridObj.GetColHDIndex("HUMAN_VENDOR_CODE" );	
		IDX_HUMAN_NO        	  = GridObj.GetColHDIndex("HUMAN_NO" );
		IDX_HUMAN_NAME_LOC        = GridObj.GetColHDIndex("HUMAN_NAME_LOC" );
		
        doSelect();
    }

    function doSelect()
    {
        
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_pp_dis1";
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getQtaDispDT&grid_col_id="+grid_col_id;
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

        window.open('/kr/dt/rfq/rfq_pp_dis5.jsp?rfq_no='+rfq_no+'&rfq_count='+rfq_count ,"windowopen_rfq1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=350,left=0,top=0");
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {

        var maxRow = GridObj.GetRowCount();

        if(msg1 == "doQuery") {

            var maxRow = GridObj.GetRowCount();
            var tmp_camt = 0;
            var tmp_samt = 0;
            var tmp_amt = 0;
            var c_amt = 0;
            var s_amt = 0;
            var i_amt = 0;
            var tmp_discount = 0;

            for(i=0; i<maxRow; i++) {

            	customer_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE));
            	supply_unitPrice 	= parseFloat(GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE));
            	itemQty          	= parseFloat(GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY) == "" ? "0" : GD_GetCellValueIndex(GridObj,i, IDX_RFQ_QTY));
        		
                tmp_camt = RoundEx(eval(customer_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj, i, IDX_CUSTOMER_AMT, tmp_camt+"");

                c_amt = c_amt +  tmp_camt;
                tmp_samt = RoundEx(eval(supply_unitPrice) * eval(itemQty), 3);
                GD_SetCellValueIndex(GridObj,i, IDX_SUPPLY_AMT, tmp_samt+"");
                
                s_amt = s_amt +  tmp_samt;
				tmp_amt = GD_GetCellValueIndex(GridObj,i, INDEX_ITEM_AMT);
                i_amt = eval(i_amt) +  eval(tmp_amt); 
            }

			form1.attach_count.value = "<%=RFQ_ATT_COUNT%>";
            form1.QTA_ATTACH_COUNT.value = "<%=QTA_ATTACH_CNT%>";
			//if(summaryCnt == 0) {
				//GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'RFQ_QTY,CUSTOMER_AMT,SUPPLY_AMT');
				//GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
				//summaryCnt++;
			//}
        }  // if 문끝
        else if(msg1 == "t_imagetext")
        {
            if(msg3 == IDX_UNIT_PRICE_IMG)
            {
                var wt = GridObj;
                var row = wt.getRowCount();
                G_Pos = msg2;

                var qta_price = GD_GetCellValueIndex(GridObj,msg2,IDX_UNIT_PRICE);

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

            if(msg3 == IDX_ITEM_NO)
            {
                var wt = GridObj;
                var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, IDX_ITEM_NO);
                POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
            }
            if(msg3 == IDX_QTA_ATTACH_NO)
            {
                var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_QTA_ATTACH_NO));
// 				rMateFileAttach('P','R','QTA',ATTACH_NO_VALUE,'S');
            }

            if(msg3 == IDX_RFQ_ATTACH_NO)
            {
                var RFQ_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_ATTACH_NO));

                if("N" != RFQ_ATTACH_NO_VALUE) {
// 					rMateFileAttach('P','R','RFQ',RFQ_ATTACH_NO_VALUE,'B');
                }
            }

            if(msg3 == IDX_PRICE_DOC)
            {
                var PRICE_DOC_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_PRICE_DOC));
                var wt = GridObj;

                var RFQ_NO      = "<%=RFQ_NO%>";
                var RFQ_COUNT   = "<%=RFQ_COUNT%>";
                var RFQ_SEQ     = GD_GetCellValueIndex(GridObj,msg2, IDX_RFQ_SEQ);
                var VENDOR_CODE = document.forms[0].st_vendor_code.value;

                G_Pos = msg2;

                if("0" != PRICE_DOC_VALUE) {
                    window.open('qta_pp_dis7.jsp?XPosition='+ msg2 + '&RFQ_NO=' + RFQ_NO + '&RFQ_COUNT=' + RFQ_COUNT +'&RFQ_SEQ=' + RFQ_SEQ +'&PRICE_DOC=' +PRICE_DOC_VALUE + '&VENDOR_CODE=' + VENDOR_CODE,"win_cost","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=465,height=300,left=0,top=0");
                }
            }
			if(msg3 == IDX_HUMAN_NAME_LOC) {
				
				human_no 		= GD_GetCellValueIndex(GridObj,msg2,IDX_HUMAN_NO);
				vendor_code 	= GD_GetCellValueIndex(GridObj,msg2,IDX_HUMAN_VENDOR_CODE);
				company_code 	= GD_GetCellValueIndex(GridObj,msg2,IDX_HUMAN_COMPANY_CODE);
				
				if(human_no == ""){
					alert("개발자가 존재하지 않습니다.");
					return;
				}
				window.open("/s_kr/master/human/hum_bd_con.jsp?popup=Y&mode=human_search&human_no="+human_no+"&vendor_code="+vendor_code+"&company_code="+company_code,"hum_bd_con","left=0,top=0,width=900,height=670,resizable=yes,scrollbars=yes");
	   
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

	
//-->
</script>



<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
//    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
    	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,합계,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
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
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<form name="form1" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<%--ClipReport4 hidden 태그 끝--%>	
	<input type="hidden" name="t_from_date">
	<input type="hidden" name="t_to_date">
	<input type="hidden" name="t_from_qty">
	<input type="hidden" name="t_to_qty">
	<input type="hidden" name="t_unit_price">
	<input type="hidden" name="attach_no" value="<%=RFQ_ATTACH_NO%>"> <!-- 첨부파일을 위해서 이용한다.-->
	<input type="hidden" name="QTA_ATTACH_NO" value="<%=QTA_ATTACH_NO%>">
	<input type="hidden" name="QTA_ATTACH_COUNT" size="5" class="input_data2" readonly>

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="vendor_code" id="vendor_code" value="<%=VENDOR_CODE%>">
	<input type="hidden" name="qta_no" id="qta_no" value="<%=QTA_NO%>">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>견적서 상세조회</span>
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
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
									<td width="35%" class="data_td"><%=RFQ_NO%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
									<td width="35%" class="data_td"><%=RFQ_COUNT%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적서번호</td>
									<td width="35%" class="data_td"><%=QTA_NO%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적업체</td>
									<td width="35%" class="data_td"><%=VENDOR_CODE%> <%=VENDOR_NAME%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명</td>
									<td width="35%" class="data_td"><%=SUBJECT%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일</td>
									<td width="35%" class="data_td"><%=RFQ_CLOSE_DATE_VIEW%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건</td>
									<td width="35%" class="data_td"><%=DELY_TERMS_TEXT%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건</td>
									<td width="35%" class="data_td"><%=PAY_TERMS_TEXT%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비교방식</td>
									<td width="35%" class="data_td"><%=SETTLE_TYPE_TEXT%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;유효일자</td>
									<td width="35%" class="data_td"><%=QTA_VAL_DATE_VIEW%></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사 특기사항</td>
									<td colspan="3" class="data_td">
										<textarea name="RFQ_REMARK" style="width:96%;" rows="5" readonly><%=RFQ_REMARK %></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매사 첨부파일</td>
									<td colspan="3" class="data_td" height="150">
										<input type="hidden" value="<%=RFQ_ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
										<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=RFQ_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사 특기사항</td>
									<td colspan="3" class="data_td">	
										<textarea name="REMARK" style="width:96%;"  rows="5" readonly><%=REMARK %></textarea>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급사 첨부파일</td>
									<td colspan="3" class="data_td" height="150">
																				<input type="hidden" value="<%=QTA_ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
										<iframe id="attachSFrm" name="attachSFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=QTA_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>

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
<%
	if(!CREATE_TYPE.equals("PR")){
		if(!RQAN_CNT.equals("0")){
%>
						<td>
<script language="javascript">
btn("javascript:openPopup1()","제안설명회")
</script>
						</td>
<%
		}
	}
%>

						<td>
<script language="javascript">
btn("javascript:clipPrint()","인 쇄")
</script>
						</td>

						<td>
<script language="javascript">
btn("javascript:window.close()","닫 기")
</script>
						</td>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="RQ_245" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>




