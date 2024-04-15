<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_250");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_250";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="RQ_250";%>

<%
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String rfq_no       = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count    = JSPUtil.nullToEmpty(request.getParameter("rfq_count")); 
	String rfq_state    = JSPUtil.nullToEmpty(request.getParameter("rfq_state"));

	Object[] obj = {rfq_no, rfq_count};	
	SepoaOut value = ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqHDDisplay", obj);
	//SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj);

    String rtn_announce_flag     = "N";
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
	String PR_TYPE				 = "";
	String REQ_TYPE				 = "";
	String HATTACH_NO			 = "";
	String HATTACH_NO_CNT		 = "";
	
	
	String PC_REASON = "";
	String pc_reasonDisable = "disable";

	SepoaFormater wf = new SepoaFormater(value.result[0]);
// 	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
// 	int wf2_cnt = wf2.getRowCount();

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
			SMS_YN                   =  wf.getValue("Z_SMS_SEND_FLAG", 0);
			BID_REQ_TYPE             =  wf.getValue("BID_REQ_TYPE", 0);
			CREATE_TYPE              =  wf.getValue("CREATE_TYPE", 0);
			PR_TYPE					 =  wf.getValue("PR_TYPE", 0);
			REQ_TYPE				 =  wf.getValue("REQ_TYPE", 0);
			HATTACH_NO				 =  wf.getValue("ATTACH_NO", 0);
			HATTACH_NO_CNT			 =  wf.getValue("ATTACH_NO_CNT", 0);
			PC_REASON				 =  wf.getValue("PC_REASON", 0);
		}
	}
 
	String rfq_close_hour      = RFQ_CLOSE_TIME != null && RFQ_CLOSE_TIME.length() >= 2 ? RFQ_CLOSE_TIME.substring(0,2) : "";
	String rfq_close_min       = RFQ_CLOSE_TIME != null && RFQ_CLOSE_TIME.length() >= 3 ? RFQ_CLOSE_TIME.substring(2,4) : "";
	
    SepoaFormater wf_rfq_count_info  = new SepoaFormater(value.result[1]);  //회차정보
    int iRowCount2 = wf_rfq_count_info.getRowCount();
    String RFQ_COUNT = "";
 
    if(iRowCount2>0)
    {
    	for(int i=0;i<iRowCount2;i++)
    	{
    		 RFQ_COUNT  = wf_rfq_count_info.getValue(0,i);    
    	}   
    }
	String pay_terms 	= ListBox(request, "SL0127",  HOUSE_CODE+"#M010#"+SHIPPER_TYPE+"#", PAY_TERMS);
	String dely_terms 	= ListBox(request, "SL0018",  HOUSE_CODE+"#M009#", DELY_TERMS);
%>

<html>
<head>
<title>재견적요청 생성</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
//<!--
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var mode;
	var load = "first";

	var idx_delete = "";

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
    var INDEX_VENDOR_SELECTED        ;
    var INDEX_PRICE_DOC              ;
    var INDEX_PLANT_CODE             ;
    var INDEX_DELY_TO_LOCATION_NAME  ;
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
    var INDEX_STATUS                 ;
    var INDEX_BID_COUNT              ;
    var INDEX_DELY_TO_LOCATION       ;
    var INDEX_STR_FLAG               ;
    
    
	var GB_CTRL_CODE = "";

	function Init(){
		setGridDraw();
		setHeader();
		doSelect();
	}
	
	function setHeader() {
	                                                                        	
        
      /*                                                                           	
		                                
		GridObj.SetColCellSortEnable("DESCRIPTION_LOC",false);
		GridObj.SetColCellSortEnable("SPECIFICATION",false);
		GridObj.SetNumberFormat("RFQ_QTY",G_format_qty);
		GridObj.SetNumberFormat("YEAR_QTY",G_format_qty);
		GridObj.SetColCellSortEnable("UNIT_MEASURE",false);
		GridObj.SetNumberFormat("PURCHASE_PRE_PRICE",G_format_unit);
		GridObj.SetColCellSortEnable("PURCHASE_PRE_PRICE",false);
		GridObj.SetNumberFormat("RFQ_AMT",G_format_amt);
		GridObj.SetColCellSortEnable("RFQ_AMT",false);
		GridObj.SetDateFormat("RD_DATE",    "yyyy/MM/dd");
		GridObj.SetColCellSortEnable("PLANT_CODE",false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION_NAME",false);
		GridObj.SetColCellSortEnable("CHANGE_USER_NAME",false);
		GridObj.SetColCellSortEnable("PR_NO",false);
		GridObj.SetColCellSortEnable("PR_SEQ",false);
		GridObj.SetColCellSortEnable("VENDOR_SELECTED_REASON",false);
		GridObj.SetColCellSortEnable("COST_COUNT",false);
		GridObj.SetColCellSortEnable("VENDOR_CNT",false);
		GridObj.SetColCellSortEnable("DELY_TO_ADDRESS",false);
		GridObj.SetColCellSortEnable("PURCHASE_LOCATION",false);
		GridObj.SetColCellSortEnable("RFQ_SEQ",false);
		GridObj.SetColCellSortEnable("MODE",false);
		GridObj.SetColCellSortEnable("STATUS",false);
		GridObj.SetColCellSortEnable("BID_COUNT",false);
		GridObj.SetColCellSortEnable("DELY_TO_LOCATION",false);
		GridObj.SetColCellSortEnable("STR_FLAG",false);
		GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
		GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd");
		 */
        
        <%//if( wf2_cnt > 0  ){%>
		//	GridObj.SetColHide("VENDOR_SELECTED", true); 
		<%//}%>
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
        INDEX_VENDOR_SELECTED          	= GridObj.GetColHDIndex("VENDOR_SELECTED");
        INDEX_PRICE_DOC                	= GridObj.GetColHDIndex("PRICE_DOC");
        INDEX_PLANT_CODE               	= GridObj.GetColHDIndex("PLANT_CODE");          
        INDEX_DELY_TO_LOCATION_NAME    	= GridObj.GetColHDIndex("DELY_TO_LOCATION_NAME");
                                       	
        INDEX_CHANGE_USER_NAME         	= GridObj.GetColHDIndex("CHANGE_USER_NAME");   
        INDEX_PR_NO                    	= GridObj.GetColHDIndex("PR_NO");
        INDEX_PR_SEQ                   	= GridObj.GetColHDIndex("PR_SEQ");
        INDEX_VENDOR_SELECTED_REASON   	= GridObj.GetColHDIndex("VENDOR_SELECTED_REASON");
        INDEX_COST_COUNT               	= GridObj.GetColHDIndex("COST_COUNT");
                                       	
        INDEX_VENDOR_CNT               	= GridObj.GetColHDIndex("VENDOR_CNT");
        INDEX_DELY_TO_ADDRESS          	= GridObj.GetColHDIndex("DELY_TO_ADDRESS");  
        INDEX_PURCHASE_LOCATION   	 	= GridObj.GetColHDIndex("PURCHASE_LOCATION");    
        INDEX_RFQ_SEQ                	= GridObj.GetColHDIndex("RFQ_SEQ");    
        INDEX_MODE                   	= GridObj.GetColHDIndex("MODE");    
        
        INDEX_STATUS                 	= GridObj.GetColHDIndex("STATUS");    
        INDEX_BID_COUNT              	= GridObj.GetColHDIndex("BID_COUNT");    
        INDEX_DELY_TO_LOCATION         	= GridObj.GetColHDIndex("DELY_TO_LOCATION");
        INDEX_STR_FLAG		         	= GridObj.GetColHDIndex("STR_FLAG");
         
		//doSelect();
	}
 
	function doSelect() {
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";
    <%-- 
		GridObj.SetParam("mode", "re_getRfqDTDisplay");
		GridObj.SetParam("rfq_no", "<%=rfq_no%>");
		GridObj.SetParam("rfq_count", "<%=rfq_count%>");
    
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		 --%>
		 var cols_ids = "<%=grid_col_id%>";
		 var params = "mode=re_getRfqDTDisplay";
		 params += "&cols_ids=" + cols_ids;
		 params += dataOutput();
		 GridObj.post( servletUrl, params );
		 GridObj.clearAll(false); 
		
	}

	function jf_rfq_close_date(year,month,day,week) {
		document.form1.rfq_close_date.value=year+month+day;
	}

	function announce_click() {
	
		cnt = GridObj.GetRowCount();
		if(form1.announce_flag.value == "Y" ) // 내용이 있습니다.-- 수정...(MODE = "M")
		{
			if(cnt > 0) window.open('rfq_pp_ins1.jsp?mode=M&rfq_no=' + form1.rfq_no.value + '&rfq_count=' + form1.re_rfq_count.value ,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
		}
		else if(form1.announce_flag.value == "N" ) // 내용이 없습니다. -- 입력 (MODE = "I")
		{
			//Message = "제안설명회 내용이 없습니다.\n입력하시겠습니까 ?";
			//if(confirm(Message) == 1) {
				szurl = 'rfq_pp_ins1.jsp?mode=I&rfq_no=' + form1.rfq_no.value + '&rfq_count=' + form1.re_rfq_count.value + '&subject=' + form1.subject.value + '&cnt=' + cnt;
				if(cnt > 0) window.open(szurl,"doExplanationM","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=720,height=400,left=0,top=0");
			//}
		}
		else if(form1.announce_flag.value == "S" ) // 수정된 내용이 있습니다.. -- 입력후 수정 (MODE = "IM")
		{
			szurl  = 'rfq_pp_ins1.jsp?mode=IM&RFQ_NO='+ form1.rfq_no.value;
			szurl += '&SUBJECT=' + form1.subject_hidden.value;
			szurl += '&RFQ_COUNT=' + form1.re_rfq_count.value;
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

	function doDelete() {
		rowcount = GridObj.GetRowCount()-1;
		rowdel = GridObj.GetRowCount();
		if(rowcount < 0) return;

		checked_count = 0;
		confirm_flag = true;

		for(row=rowcount; row>=0; row--) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				checked_count++;

				if(0 < parseInt(GD_GetCellValueIndex(GridObj,row, INDEX_BID_COUNT))) {
					alert("삭제할 수없는 항목이 있습니다.");
					return;
				}
			}
		}

		if(checked_count == 0)  {
			alert(G_MSS1_SELECT);
			return;
		}

		var checked_count1 = 0;
		for( row = 0; row< rowdel; row++) {
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) checked_count1++;
		}
		if(checked_count1 == rowdel) {
			alert("전체 품목을 삭제할 수 없습니다. 삭제하시려면 견적요청서를 삭제하세요.");
			return;
		}

		Message = "삭제 하시겠습니까?";

		if(confirm(Message) == 1) {
			for(row=rowcount; row>=0; row--) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					deletedata += GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_SEQ)+"&";
					GridObj.DeleteRow(row);
				}
			}
		}
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

	function setAttach(attach_key, arrAttrach, attach_count) {
		GD_SetCellValueIndex(GridObj,Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");
	}

	function JavaCall(msg1, msg2, msg3, msg4, msg5)	{
		if(msg1 == "doQuery") {

		}
		if(msg1 == "t_imagetext") {
			if(msg3 == INDEX_VENDOR_SELECTED) { //업체선택
				
				if(GridObj.GetRowCount() == 0) return;
					if(form1.RFQ_TYPE.value == "OP") {
						alert("일반견적에선 업체를 선정할 수 없습니다.");
						return;
				}
				
			    var settleType = form1.SETTLE_TYPE.value;
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
    				INDEX_mode = GD_GetCellValueIndex(GridObj,msg2, INDEX_MODE);
                    if (INDEX_mode == "N") {
    				    openPopup(msg2, "S", "");
    				} else {
    				    openPopup(msg2, "I", "");
    				}
    				
    				
			    }
			} else if(msg3 == INDEX_PRICE_DOC) { // 원가내역서
				if(form1.RFQ_TYPE.value == "OP") {
					alert("일반견적에서는 원가내역을 입력할 수 없습니다.");
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

				rMateFileAttach('P','C','RFQ',ATTACH_NO_VALUE);
			}
		}
		if(msg1 == "t_insert") { // 전송/저장시 Row삭제
			if(msg3 == INDEX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
				var  rfq_close_date_val = form1.rfq_close_date.value;
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

                    GD_SetCellValueIndex(GridObj,x, INDEX_RFQ_AMT, setAmt (eval(tmp_amt) * eval(tmp_qty)));
                }
            }			
		}
		if(msg1 == "t_header") {
			if(msg3 == INDEX_RD_DATE) {
                copyCell(SepoaTable, INDEX_RD_DATE, "t_date");
			}
		}
		if(msg1 == "doData") {
			if(mode == "re_setRfqCreate") {
				alert(GD_GetParam(GridObj,"0"));

				if("1" == GridObj.GetStatus()) {
					opener.doSelect();
					window.close();
				}

			}
			else if(mode == "ReturnToPR_DOC_ALL"){
				alert(GD_GetParam(GridObj,"0"));

				if("1" == GridObj.GetStatus()) {
					opener.doSelect();
					window.close();
				}
			}
			else if(mode == "ReturnToPR_ITEM"){
				alert(GD_GetParam(GridObj,"0"));

				if("1" == GridObj.GetStatus()) {
					for(var i=GridObj.GetRowCount()-1; i >= 0; i--){
						if(GridObj.GetCellValue("SELECTED", i) == "1"){
							GridObj.DeleteRow(i);
						}
						
					}
					
					if(GridObj.GetRowCount() == 0)
					{
						opener.doSelect();
						window.close();
					}
				}
			}
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

		if(eval(LRTrim(form1.rfq_close_date.value)) < eval("<%=SepoaDate.getShortDateString()%>")) {
			alert("견적마감일이 유효하지 않습니다. ");
			return;
		}

		if(eval(LRTrim(form1.rfq_close_date.value)) == eval("<%=SepoaDate.getShortDateString()%>")) {
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
			if(eval(form1.rfq_close_date.value) <= eval(form1.szdate.value)) {
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
		for(row=GridObj.GetRowCount()-1; row>=0; row--)
		{
			if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED))
			{
				checked_count++;

				<%if(true){%>
				if("" == GD_GetCellValueIndex(GridObj,row, INDEX_RD_DATE)){
					alert("납기일자는 반드시 존재하여야 합니다..");
					return;
				}
				if( LRTrim(form1.rfq_close_date.value) >= GD_GetCellValueIndex(GridObj,row, INDEX_RD_DATE)){
					alert("납기일자는 반드시 견적마감일 이후여야 합니다.");
					return;
				}
				<%}else{%>
				 	if(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_FROM_DATE) == ""){
						alert("투입시작일은 반드시 존재하여야 합니다..");
						return;
				 	}
				 	if(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_TO_DATE) == ""){
						alert("투입종료일은 반드시 존재하여야 합니다..");
						return;
				 	}
					if( eval(LRTrim(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_FROM_DATE))) >= eval(LRTrim(GD_GetCellValueIndex(GridObj,row, INDEX_INPUT_TO_DATE))) ){
						alert("투입종료일은 투입시작일 이후여야 합니다.");
						return;
					}
			     <%}%>	
				if(form1.RFQ_TYPE.value != "OP")
				{
					if(0 == parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_SELECTED),row))) {
						alert("업체선정을 반드시 해야합니다.");
						return;
					}

					//견적건별일 경우 견적대상업체가 모두 동일해야 함
    				if( form1.SETTLE_TYPE.value == "DOC" ){
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
	 
		if(rfq_flag == "P") Message = "전송 하시겠습니까?";
		if(rfq_flag == "T") Message = "저장 하시겠습니까?";

		if(confirm(Message) != 1) {
			return;
		}
		
        if( rfq_flag == "P" ){
			getApproval(rfq_flag);  //
        }else if( rfq_flag == "N" ){
            getApproval(rfq_flag);  //의미없는 값을 넘긴다.
        }
	}

    function Approval(pflag, amt) {

		if (pflag == "P") {
            document.forms[0].target = "childframe";
            document.forms[0].action = "/kr/admin/basic/approval/approval.jsp?house_code=<%=HOUSE_CODE%>&company_code=<%=COMPANY_CODE%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=RQ&fnc_name=getApproval&amt="+amt;
            document.forms[0].method = "get";
            document.forms[0].submit();
			cancel_flag = false;
		}
    }

    function getApproval(Approval_str) {
		if (Approval_str == "") {
			alert("결재자를 지정해 주세요");
			return;
		}
        rfq_flag = form1.rfq_flag.value;

        mode = "re_setRfqCreate";
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";

		GridObj.SetParam("mode", mode);
		GridObj.SetParam("I_RFQ_FLAG", rfq_flag);          //전송/저장
		GridObj.SetParam("I_PFLAG", Approval_str);         //결재

		//Header
		GridObj.SetParam("I_SUBJECT", form1.subject.value);
		GridObj.SetParam("I_RFQ_CLOSE_DATE", form1.rfq_close_date.value);
		GridObj.SetParam("I_RFQ_CLOSE_TIME", form1.rfq_close_time.value + form1.szMin.value);
		GridObj.SetParam("I_PAY_TERMS", form1.PAY_TERMS.value);
		GridObj.SetParam("I_DELY_TERMS", form1.DELY_TERMS.value);
		GridObj.SetParam("I_RFQ_TYPE", form1.RFQ_TYPE.value);
		GridObj.SetParam("I_REMARK", form1.REMARK.value);
		GridObj.SetParam("I_RFQ_TYPE", "<%=RFQ_TYPE%>");
		GridObj.SetParam("I_SETTLE_TYPE", "<%=SETTLE_TYPE%>");

		// 사양설명회
		GridObj.SetParam("I_SZDATE", form1.szdate.value);
		GridObj.SetParam("I_START_TIME", form1.start_time.value);
		GridObj.SetParam("I_END_TIME", form1.end_time.value);
		GridObj.SetParam("I_HOST", form1.host.value);
		GridObj.SetParam("I_AREA", form1.area.value);
		GridObj.SetParam("I_PLACE", form1.place.value);
		GridObj.SetParam("I_NOTIFIER", form1.notifier.value);
		GridObj.SetParam("I_DOC_FRW_DATE", form1.doc_frw_date.value);
		GridObj.SetParam("I_RESP", form1.resp.value);
		GridObj.SetParam("I_COMMENT", form1.comment.value);
		GridObj.SetParam("I_ANNOUNCE_FLAG", form1.announce_flag.value);
		GridObj.SetParam("I_RFQ_TYPE", form1.RFQ_TYPE.value);
		GridObj.SetParam("I_RFQ_NO", form1.rfq_no.value);
		GridObj.SetParam("I_RFQ_COUNT",form1.rfq_count.value);
		GridObj.SetParam("I_DELETE_DATA",deletedata);
		GridObj.SetParam("I_CREATE_TYPE","<%=CREATE_TYPE%>");
		GridObj.SetParam("I_SHIPPER_TYPE", form1.SHIPPER_TYPE.value);
		GridObj.SetParam("I_PR_TYPE"		, "<%=BID_REQ_TYPE%>");
		GridObj.SetParam("I_CTRL_CODE"	, ctrl_code[0]	);
		GridObj.SetParam("I_ATTACH_NO", form1.attach_no.value);

		document.attachFrame.setData();	//startUpload
	}
//ssjj0
	function getApprovalSend(Approval_str) {

		for(i=0; i<GridObj.GetRowCount(); i++) {
			GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "true&", "&");
		}		
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
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
		    
		    var Approval_str = f.approval_str.value;
		    getApprovalSend(Approval_str);
		}
	} */

	function doBuyerSelect_popup(szRow, mode) {

		if(GridObj.GetRowCount() == 0) return;
		if(form1.RFQ_TYPE.value == "OP") {
			alert("일반견적에선 업체를 선정할 수 없습니다.");
			return;
		}

		var shipper_type = document.forms[0].SHIPPER_TYPE.value;

		if("S" == mode) { //select
			rfq_no = form1.rfq_no.value;
			rfq_count = form1.rfq_count.value;
			rfq_seq = GD_GetCellValueIndex(GridObj,szRow, INDEX_RFQ_SEQ);

			data   = "rfq_pp_ins2.jsp?mode=" + mode + "&szRow=" + szRow;
			data += "&rfq_no=" + rfq_no + "&rfq_count=" + rfq_count;
			data += "&rfq_seq=" + rfq_seq+ "&shipper_type="+shipper_type;

			window.open(data, "doBuyerSelect_popup","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=500,left=0,top=0");
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
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED,  G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&");
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
    				GD_SetCellValueIndex(GridObj,row, INDEX_MODE, "I");
					GD_SetCellValueIndex(GridObj,row, INDEX_VENDOR_CNT, SELECTED_COUNT);
				}
			}
		} else {
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED,  G_IMG_ICON + "&" + SELECTED_COUNT + "&Y", "&");
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_SELECTED_REASON, VANDOR_SELECTED);
			GD_SetCellValueIndex(GridObj,szRow, INDEX_MODE, "I");
			GD_SetCellValueIndex(GridObj,szRow, INDEX_VENDOR_CNT, SELECTED_COUNT);			
		}
	}

	function rfq_type_Changed()
	{
		if(form1.RFQ_TYPE.value == "OP") {
			alert("일반견적에서는 견적건별 만 가능합니다.");
			form1.SETTLE_TYPE.selectedIndex = 1;
		}
	}

	function getAllCompany() {
		if(GridObj.GetRowCount() == 0) return;

		var rowselected = 0;
		var value = "";
		var com_data = "";

		if(GridObj.GetRowCount() > 0) {
			for(row=0; row<GridObj.GetRowCount(); row++) {
				if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) { // 선택한 아이템중에서
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

	function doBuyerSelect() {
		if(GridObj.GetRowCount() == 0) return;
		rowselected=0;
		var cnt = 0;

		for(row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				rowselected++;
			}
		}

		if(rowselected < 1)	{
			alert(G_MSS1_SELECT);
			return;
		}
		doBuyerSelect_popup("-1", "R");
	}

	function vendor_Select() {
		if(GridObj.GetRowCount() == 0) return;
		rowselected=0;
		var cnt = 0;

		for(row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				rowselected++;

				if(0 < parseInt(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDOR_SELECTED),row))) {
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
			doBuyerSelect_popup("-1", "M");  //M?
		}
	}

	function searchProfile(fc) {
		var shipper_type = document.forms[0].SHIPPER_TYPE.value;	
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
		document.form1.VALID_FROM_DATE.value=year+month+day;
	}

	function valid_to_date(year,month,day,week) {
		document.form1.VALID_TO_DATE.value=year+month+day;
	}
	//ssjj1
	function go_reset_bill_DOC(value, row, attachObj){
		for(i = 0 ; i < GridObj.GetRowCount(); i++) {
			GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "true&", "&");
		}
		var rfq_no = "<%=rfq_no%>";
		var rfq_count = "<%=rfq_count%>";
		
		document.forms[0].sr_reason.value = value;
    	document.forms[0].sr_attach_no.value = "";
    	
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";		
		mode = "ReturnToPR_DOC_ALL";
		GridObj.SetParam("mode", mode);
		GridObj.SetParam("rfq_no", rfq_no);
		GridObj.SetParam("rfq_count", rfq_count);
		GridObj.SetParam("sr_reason"		, document.forms[0].sr_reason.value);    	
    	GridObj.SetParam("sr_attach_no"	, document.forms[0].sr_attach_no.value);
		
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
		
	}
	
	//ssjj2
	function go_reset_bill_ITEM(value, row, attachObj){
		var rfq_no = "<%=rfq_no%>";
		var rfq_count = "<%=rfq_count%>";
		
		document.forms[0].sr_reason.value = value;
    	document.forms[0].sr_attach_no.value = "";
    	
		servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";
		mode = 	"ReturnToPR_ITEM";
		GridObj.SetParam("mode", mode);
		GridObj.SetParam("rfq_no", rfq_no);
		GridObj.SetParam("rfq_count", rfq_count);			
		GridObj.SetParam("sr_reason"		, document.forms[0].sr_reason.value);    	
    	GridObj.SetParam("sr_attach_no"	, document.forms[0].sr_attach_no.value);
		
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
		
	}
	
	function reset_bill() {
		var rfq_no = "<%=rfq_no%>";
		var rfq_count = "<%=rfq_count%>";
		
		var left = 150;
		var top = 150;
		var width = 600;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
			
		if("<%=SETTLE_TYPE%>" == "DOC") {
/*		
			mode = "ReturnToPR_DOC_ALL";
			servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";
*/
			for(i = 0 ; i < GridObj.GetRowCount(); i++) {
				GD_SetCellValueIndex(GridObj,i, INDEX_SELECTED, "true&", "&");
				if(0 < parseInt(GD_GetCellValueIndex(GridObj,i, INDEX_BID_COUNT)))
				{
					alert("견적서를 제출한 업체가 있습니다.\n견적비교에서 구매복구 하실 수 있습니다.");
					return;
				}
			}
/*
			GridObj.SetParam("mode", "ReturnToPR_DOC_ALL");
			GridObj.SetParam("rfq_no", rfq_no);
			GridObj.SetParam("rfq_count", rfq_count);
*/			
			Message = "";
			Message += "구매복구 하시겠습니까?";
			
			if(!confirm(Message)) {
        		return;            
        	}
        
       		// 구매복구 사유입력창
        	var url = "/kr/confirm_pp_dis.jsp?mode=update&function=go_reset_bill_DOC&title=구매복구사유&column=sr_reason&maxByte=4000&useAttach=Y&attach_no="+document.forms[0].sr_attach_no.value;			
			var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			ReasonWin.focus();
/*
			if(confirm(Message) == 1) {
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");
			}
*/			

		} else {
			rowcount = GridObj.GetRowCount();
			if(rowcount == 0) return;

			checked_count = 0;
			confirm_flag = true;

			for(row=0; row<GridObj.GetRowCount(); row++) {
				if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED))
				{
					if(0 < parseInt(GD_GetCellValueIndex(GridObj,row, INDEX_BID_COUNT)))
					{
						alert("견적서를 제출한 업체가 있습니다.\n견적비교에서 구매복구 하실 수 있습니다.");
						return;
					}
					item_no = GD_GetCellValueIndex(GridObj,row, INDEX_ITEM_NO);
					pr_no   = GD_GetCellValueIndex(GridObj,row, INDEX_PR_NO);
					pr_seq  = GD_GetCellValueIndex(GridObj,row, INDEX_PR_SEQ);
					rfq_seq = GD_GetCellValueIndex(GridObj,row, INDEX_RFQ_SEQ);
					INDEX_delete = row;
				}
			}

			for(row=rowcount-1; row>=0; row--) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					checked_count++;
				}
			}
/*
			if(checked_count != 1)  {
				alert("한건씩만 구매복구 하실 수 있습니다.");
				return;
			}
*/
/*	
			mode = "ReturnToPR_ITEM";
			servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins3";
			item_no = "";
			pr_no = "";
			pr_seq = "";
			rfq_seq = "";

			
			GridObj.SetParam("mode", "ReturnToPR_ITEM");

			GridObj.SetParam("rfq_no", rfq_no);
			GridObj.SetParam("rfq_count", rfq_count);
			
			GridObj.SetParam("item_no", item_no);
			GridObj.SetParam("pr_no", pr_no);
			GridObj.SetParam("pr_seq", pr_seq);

			GridObj.SetParam("rfq_seq", rfq_seq);
			GridObj.SetParam("rowcount", rowcount);
*/
			Message = "구매복구 하시겠습니까?";
			if(!confirm(Message)) {
        		return;            
        	}
        
       		// 구매복구 사유입력창
        	var url = "/kr/confirm_pp_dis.jsp?mode=update&function=go_reset_bill_ITEM&title=구매복구사유&column=sr_reason&maxByte=4000&useAttach=Y&attach_no="+document.forms[0].sr_attach_no.value;			
			var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
			ReasonWin.focus();
/*
			
			if(confirm(Message) == 1) {
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");
			}
*/			
		}
	}
	
	function openPopup(szRow, mode,SG_REFITEM) {
		if(GridObj.GetRowCount() == 0) return;
		var shipper_type = document.forms[0].SHIPPER_TYPE.value;
		window.open('rfq_pp_ins2.jsp?mode=' + mode + '&szRow=' + szRow + '&shipper_type='+shipper_type+"&SG_REFITEM="+SG_REFITEM + "&rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count%>&rfq_seq=" + GridObj.GetCellValue("RFQ_SEQ", szRow), "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
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
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<form name="form1" >
<!--	hidden 	--> 
<input type="hidden" name="announce_flag" value="<%=rtn_announce_flag %>">
<!-- hidden(사양설명회) //--> 
<input type="hidden" name="szdate"          id="szdate"                                                >
<input type="hidden" name="start_time"      id="start_time"                                            >
                                                                                                     
<input type="hidden" name="end_time"        id="end_time"                                              >
<input type="hidden" name="host"            id="host"                                                  >
<input type="hidden" name="area"            id="area"                                                  >
<input type="hidden" name="place"           id="place"                                                 >
<input type="hidden" name="notifier"        id="notifier"                                              >
                                                                                                     
<input type="hidden" name="doc_frw_date"    id="doc_frw_date"                                          >
<input type="hidden" name="resp"            id="resp"                                                  >
<input type="hidden" name="comment"         id="comment"                                               >
<input type="hidden" name="subject_hidden"  id="subject_hidden"                                        >
                                                                                                     
<!-- hidden(rfq_flag) //-->                                                                   
<input type="hidden" name="rfq_flag"        id="rfq_flag"                   value=""                                     >
<input type="hidden" name="rfq_count"       id="rfq_count"                  value="<%=rfq_count%>"                      >
<%-- <input type="hidden" name="attach_no"       id="attach_no"                  value="<%=HATTACH_NO%>"                      > --%>
<input type="hidden" name="SHIPPER_TYPE"    id="SHIPPER_TYPE"               value="<%=SHIPPER_TYPE%>"                >
<textarea name="sr_reason"   id="sr_reason"            style="display:none;"></textarea>
<input type="hidden" name="sr_attach_no"     id="sr_attach_no"                 >
                                                                  
<input type="hidden" name="attach_gubun"     id="attach_gubun"                 value="body"> 
<input type="hidden" name="att_mode"         id="att_mode"                     value="">
<input type="hidden" name="view_type"        id="view_type"                    value="">
<input type="hidden" name="file_type"        id="file_type"                    value="">
<input type="hidden" name="tmp_att_no"       id="tmp_att_no"                   value="">
<!-- <input type="hidden" name="attach_count"     id="attach_count"                 value=""> -->
<input type="hidden" name="approval_str"     id="approval_str"                 value="">
<input type="hidden" name="PC_REASON"        id="PC_REASON"  value="<%=PC_REASON %>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>재견적요청 생성
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
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호
	</td>
	<td width="35%"  class="data_td"> 
		<input type="text" name="rfq_no" id="rfq_no" style="width:95%" class="input_re" value="<%=rfq_no%>" readonly>
	</td>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수
	</td>
	<td class="data_td"><input type="text" name="re_rfq_count" id="re_rfq_count" size="5" value="<%=RFQ_COUNT%>" class="input_re" readonly>
	</td>
</tr>  
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명
	</td>
  <td width="35%" class="data_td">
  	<input type="text" name="subject" id="subject" style="width:95%" class="input_re" value='<%=SUBJECT%>' onKeyUp="return chkMaxByte(500, this, '견적요청명');">
  </td>
  <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일</td>
  <td width="35%" class="data_td">
    <s:calendar id="rfq_close_date" format="%Y/%m/%d" default_value="<%=RFQ_CLOSE_DATE%>" />
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
	</td>
</tr> 
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청형태</td>
	<td class="data_td" colspan="3">
		<select name="RFQ_TYPE" id="RFQ_TYPE" class="inputsubmit" disabled>
		<option value="">-----</option> 
	<% 
		String lb_rfq_type = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M112", RFQ_TYPE);
		out.println(lb_rfq_type);
	%>
		</select><br> 
		<% if(!PC_REASON.equals("")){%>
		&nbsp;사유 : <input type="text" name="pc_reason" id="pc_reason" size="100" class="input_data" value="<%=PC_REASON%>" disabled="<%=pc_reasonDisable%>"/>
		<% }%>	
	</td>
</tr>
<tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급조건
	</td>
	<td width="35%" class="data_td" >
	    <select name="PAY_TERMS" id="PAY_TERMS" class="input_re">
			<%=pay_terms%>
	    </select>
    </td> 
	<td width="15%" class="title_td">
		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;인도조건
	</td>
	<td width="35%" class="data_td">
	    <select name="DELY_TERMS" id="DELY_TERMS" class="input_re">
			<%=dely_terms%>
	    </select>
    </td>
 </tr> 
 <tr>
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
 <tr style="display:none;">   
	 <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비교방식</td>
    <td width="35%" class="data_td" colspan="3">
      <select name="SETTLE_TYPE" id="SETTLE_TYPE" class="inputsubmit" disabled>
		<% 
		        String settle = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#"+"M149", SETTLE_TYPE);
		        out.println(settle);
		%>
      </select>
 	</td> 
</tr>
<tr style="display:none;">   
	<td colspan="4" height="1" bgcolor="#dedede"></td>
</tr>
<tr>   
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
	<td class="data_td" colspan="3">
		<table>
		<tr>
			<td>
				<textarea name="REMARK" id="REMARK" class="inputsubmit" cols="120" rows="5" onKeyUp="return chkMaxByte(4000, this, '특기사항');"><%=REMARK%></textarea>  
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
			<TD><script language="javascript">btn("javascript:announce_click()","제안설명회");</script></TD>	    	  			
			<% if(!RFQ_TYPE.equals("OP")){   
				//if( wf2_cnt == 0  ){%>
				<TD><script language="javascript">btn("javascript:vendor_Select()","견적업체")    </script></TD>
			<% //} %>
			<% } %>	    	  			
			<%-- <TD><script language="javascript">btn("javascript:doSave('P')","업체전송")		</script></TD> --%>
			<% if(!CREATE_TYPE.equals("MA")) {%>   
			<%-- <TD><script language="javascript">btn("javascript:reset_bill()","구매복구")	</script></TD> --%>
			<% }%>	    	  			
			<TD><script language="javascript">btn("javascript:window.close()","닫 기")		</script></TD>	    	  				    	  				    	  			
		</TR>
		</TABLE>
	</td>      		
</tr>
</table>

</form>
<!-- <iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe> -->


</s:header>
<s:grid screen_id="RQ_250" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','C','RFQ',form1.attach_no.value);</script> --%>


