<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_249");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_249";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
    String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 


%>
<% String WISEHUB_PROCESS_ID="RQ_249";%>
<%
    String rfq_no           = JSPUtil.nullToEmpty(request.getParameter("rfq_no"          ));
    String rfq_count        = JSPUtil.nullToEmpty(request.getParameter("rfq_count"       ));
    String bid_req_type     = JSPUtil.nullToEmpty(request.getParameter("bid_req_type"    ));
    String req_type     	= JSPUtil.nullToEmpty(request.getParameter("req_type"    ));

	/* Object[] obj = {rfq_no, rfq_count};
	SepoaOut value2= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
	int wf2_cnt = wf2.getRowCount(); */

    String qflag = JSPUtil.nullToEmpty(request.getParameter("qflag"));
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
<script language="javascript">
	var mode;
	var G_CUR_ROW;

	var IDX_SELECTED                 ;
	var IDX_IMG_SEL             ;
	var IDX_ITEM_NO             ;
	var IDX_DESCRIPTION_LOC     ;
	var IDX_SPECIFICATION       ;
	var IDX_ITEM_QTY            ;
	var IDX_UNIT_MEASURE        ;
	var IDX_SELECT_FLAG         ;
	var IDX_VENDOR_CODE         ;
	var IDX_VENDOR_NAME         ;
	var IDX_CUR                 ;
	var IDX_F_UNIT_PRICE        ;
	var IDX_L_UNIT_PRICE        ;
	var IDX_AMT                 ;
	var IDX_F_MOLDING_CHARGE    ;
	var IDX_L_MOLDING_CHARGE    ;
	var IDX_BID_FLAG            ;
	var IDX_DELIVERY_LT         ;
	var IDX_COST_COUNT          ;
	var IDX_PURCHASE_LOCATION   ;
	var IDX_QTA_NO              ;
	var IDX_CONTRACT_FLAG       ;
	var IDX_IMG_CONTRACT_FLAG   ;
	var IDX_AUTO_PO_FLAG        ;
	var IDX_IMG_AUTO_PO_FLAG    ;
	var IDX_QUOTA_PERCENT       ;
	var IDX_PR_NO               ;
	var IDX_PR_SEQ              ;
	var IDX_PURCHASE_PRE_PRICE  ;
	var IDX_H_ITEM_NO           ;
	var IDX_H_RFQ_NO            ;
	var IDX_H_RFQ_SEQ           ;
	var IDX_H_QTA_NO            ;
	var IDX_H_QTA_SEQ           ;
	var IDX_H_ITEM_QTY          ;
	var IDX_H_DESCRIPTION_LOC   ;
	var IDX_H_SPECIFICATION     ;
	var IDX_H_UNIT_MEASURE      ;
	var IDX_H_PURCHASE_LOCATION ;
	var IDX_H_PR_NO             ;
	var IDX_H_PR_SEQ            ;
	var IDX_H_PURCHASE_PRE_PRICE;
	var IDX_MOLDING_CHARGE		;
	var IDX_MOLDING_TYPE		;
	var IDX_GISUL_RFQ			;
	var IDX_SETTLE_REMARK		;
	var IDX_SETTLE_ATTACH_NO	;
   
	  function Init()
	    {
			
			setGridDraw();
			setHeader();
			doSelect();
	    }
	
	
	
	function setHeader()

    {
		/* GridObj.bHDMoving 			= false;
		GridObj.bHDSwapping 			= false;
		GridObj.bRowSelectorVisible 	= false;
		GridObj.strRowBorderStyle 	= "none";
		GridObj.nRowSpacing 			= 0 ;
		GridObj.strHDClickAction 		= "select";
		GridObj.nHDLineSize  = 32;

	 */







	//GridObj.AddHeader("INFH_VENDOR_NAME"   		,"기존업체"                ,"t_text"     	,500,0,false);
	//GridObj.AddHeader("INFH_UNIT_PRICE"    		,"기존금액"                ,"t_number"   	,17,0,false);






/* 

	GridObj.AddGroup("CUSTOMER_PRICE", "List Price");
 	GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_PRICE");
  	GridObj.AppendHeader("CUSTOMER_PRICE", "CUSTOMER_AMT");
	GridObj.AddGroup("SUPPLY_PRICE", "공급가");
 	GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_PRICE");
  	GridObj.AppendHeader("SUPPLY_PRICE", "SUPPLY_AMT");

	GridObj.SetColCellSortEnable("SEL"                ,false);
	GridObj.SetColCellSortEnable("DESCRIPTION_LOC"    ,false);
	GridObj.SetColCellSortEnable("SPECIFICATION"      ,false);
	GridObj.SetNumberFormat("ITEM_QTY"           ,G_format_qty);
	GridObj.SetColCellSortEnable("ITEM_QTY"           ,false);
	GridObj.SetColCellSortEnable("UNIT_MEASURE"       ,false);
	GridObj.SetColCellSortEnable("VENDOR_CODE"        ,false);
	GridObj.SetColCellSortEnable("VENDOR_NAME"        ,false);
	//GridObj.SetColCellSortEnable("INFH_VENDOR_NAME"   ,false);
	GridObj.SetColCellSortEnable("CUR"                ,false);
	GridObj.SetNumberFormat("F_UNIT_PRICE"       ,G_format_unit);
	GridObj.SetColCellSortEnable("F_UNIT_PRICE"       ,false);
	GridObj.SetNumberFormat("L_UNIT_PRICE"       ,G_format_unit);
	GridObj.SetColCellSortEnable("L_UNIT_PRICE"       ,false);
	GridObj.SetNumberFormat("AMT"                ,G_format_amt);
	//GridObj.SetNumberFormat("INFH_UNIT_PRICE"    ,G_format_amt);
	GridObj.SetColCellSortEnable("AMT"                ,false);
	GridObj.SetNumberFormat("F_MOLDING_CHARGE"   ,G_format_unit);
	GridObj.SetColCellSortEnable("F_MOLDING_CHARGE"   ,false);
	GridObj.SetNumberFormat("MOLDING_PROSPECTIVE_QTY"   ,G_format_unit);
	GridObj.SetColCellSortEnable("MOLDING_PROSPECTIVE_QTY"   ,false);
	GridObj.SetNumberFormat("MOLDING_CHARGE"   ,G_format_unit);
	GridObj.SetColCellSortEnable("MOLDING_CHARGE"   ,false);
	GridObj.SetNumberFormat("L_MOLDING_CHARGE"   ,G_format_unit);
	GridObj.SetColCellSortEnable("L_MOLDING_CHARGE"   ,false);
	GridObj.SetColCellSortEnable("BID_FLAG"           ,false);
	GridObj.SetColCellSortEnable("DELIVERY_LT"       ,false);

	GridObj.SetColCellSortEnable("CONTRACT_FLAG"     ,false);
	GridObj.SetColCellSortEnable("AUTO_PO_FLAG"      ,false);
	GridObj.SetNumberFormat("QUOTA_PERCENT"     ,G_format_pctg);
	GridObj.SetColCellSortEnable("QUOTA_PERCENT"     ,false);
	GridObj.SetColCellSortEnable("PR_NO"              ,false);
	GridObj.SetColCellSortEnable("PR_SEQ"             ,false);
	GridObj.SetNumberFormat("PURCHASE_PRE_PRICE" ,G_format_qty);
	GridObj.SetColCellSortEnable("PURCHASE_PRE_PRICE" ,false);
	GridObj.SetColCellSortEnable("MOLDING_TYPE"     ,false);
	GridObj.SetColCellSortEnable("H_ITEM_NO"          ,false);
	GridObj.SetColCellSortEnable("H_RFQ_NO"           ,false);
	GridObj.SetColCellSortEnable("H_RFQ_SEQ"          ,false);
	GridObj.SetColCellSortEnable("H_QTA_NO"           ,false);
	GridObj.SetColCellSortEnable("H_QTA_SEQ"          ,false);
	GridObj.SetColCellSortEnable("H_ITEM_QTY"         ,false);
	GridObj.SetColCellSortEnable("H_DESCRIPTION_LOC"  ,false);
	GridObj.SetColCellSortEnable("H_SPECIFICATION"    ,false);
	GridObj.SetColCellSortEnable("H_UNIT_MEASURE"     ,false);
	GridObj.SetColCellSortEnable("H_PURCHASE_LOCATION",false);
	GridObj.SetColCellSortEnable("H_PR_NO"            ,false);
	GridObj.SetColCellSortEnable("H_PR_SEQ"           ,false);
	GridObj.SetNumberFormat("CUSTOMER_PRICE"                ,G_format_qty);
	GridObj.SetNumberFormat("CUSTOMER_AMT"                ,G_format_qty);
	GridObj.SetNumberFormat("SUPPLY_PRICE"                ,G_format_qty);
	GridObj.SetNumberFormat("SUPPLY_AMT"                ,G_format_qty);
	GridObj.SetColCellSortEnable("H_PURCHASE_PRE_PRICE" ,false);
	GridObj.SetNumberFormat("DISCOUNT",       G_format_qty);
	GridObj.SetDateFormat("DELIVERY_LT",    "yyyy/MM/dd");
	GridObj.SetDateFormat("INPUT_FROM_DATE",    "yyyy/MM/dd");
	GridObj.SetDateFormat("INPUT_TO_DATE",    "yyyy/MM/dd"); */


	IDX_SELECTED                        = GridObj.GetColHDIndex("SELECTED");
	IDX_IMG_SEL                    = GridObj.GetColHDIndex("IMG_SEL");
	IDX_ITEM_NO                    = GridObj.GetColHDIndex("ITEM_NO");
	IDX_DESCRIPTION_LOC            = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	IDX_SPECIFICATION              = GridObj.GetColHDIndex("SPECIFICATION");
	IDX_ITEM_QTY                   = GridObj.GetColHDIndex("ITEM_QTY");
	IDX_UNIT_MEASURE               = GridObj.GetColHDIndex("UNIT_MEASURE");
	IDX_SELECT_FLAG                = GridObj.GetColHDIndex("SELECT_FLAG");
	IDX_VENDOR_CODE                = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME                = GridObj.GetColHDIndex("VENDOR_NAME");
	IDX_CUR                        = GridObj.GetColHDIndex("CUR");
	IDX_F_UNIT_PRICE               = GridObj.GetColHDIndex("F_UNIT_PRICE");
	IDX_L_UNIT_PRICE               = GridObj.GetColHDIndex("L_UNIT_PRICE");
	IDX_AMT                        = GridObj.GetColHDIndex("AMT");
	IDX_F_MOLDING_CHARGE           = GridObj.GetColHDIndex("F_MOLDING_CHARGE");
	IDX_L_MOLDING_CHARGE           = GridObj.GetColHDIndex("L_MOLDING_CHARGE");
	IDX_BID_FLAG                   = GridObj.GetColHDIndex("BID_FLAG");
	IDX_DELIVERY_LT                = GridObj.GetColHDIndex("DELIVERY_LT");
	IDX_COST_COUNT                 = GridObj.GetColHDIndex("COST_COUNT");
	IDX_PURCHASE_LOCATION          = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	IDX_QTA_NO                     = GridObj.GetColHDIndex("QTA_NO");
	IDX_CONTRACT_FLAG              = GridObj.GetColHDIndex("CONTRACT_FLAG");
	IDX_IMG_CONTRACT_FLAG          = GridObj.GetColHDIndex("IMG_CONTRACT_FLAG");
	IDX_AUTO_PO_FLAG               = GridObj.GetColHDIndex("AUTO_PO_FLAG");
	IDX_IMG_AUTO_PO_FLAG           = GridObj.GetColHDIndex("IMG_AUTO_PO_FLAG");
	IDX_QUOTA_PERCENT              = GridObj.GetColHDIndex("QUOTA_PERCENT");
	IDX_PR_NO                      = GridObj.GetColHDIndex("PR_NO");
	IDX_PR_SEQ                     = GridObj.GetColHDIndex("PR_SEQ");
	IDX_PURCHASE_PRE_PRICE         = GridObj.GetColHDIndex("PURCHASE_PRE_PRICE");
	IDX_H_ITEM_NO                  = GridObj.GetColHDIndex("H_ITEM_NO");
	IDX_H_RFQ_NO                   = GridObj.GetColHDIndex("H_RFQ_NO");
	IDX_H_RFQ_SEQ                  = GridObj.GetColHDIndex("H_RFQ_SEQ");
	IDX_H_QTA_NO                   = GridObj.GetColHDIndex("H_QTA_NO");
	IDX_H_QTA_SEQ                  = GridObj.GetColHDIndex("H_QTA_SEQ");
	IDX_H_ITEM_QTY                 = GridObj.GetColHDIndex("H_ITEM_QTY");
	IDX_H_DESCRIPTION_LOC          = GridObj.GetColHDIndex("H_DESCRIPTION_LOC");
	IDX_H_SPECIFICATION            = GridObj.GetColHDIndex("H_SPECIFICATION");
	IDX_H_UNIT_MEASURE             = GridObj.GetColHDIndex("H_UNIT_MEASURE");
	IDX_H_PURCHASE_LOCATION        = GridObj.GetColHDIndex("H_PURCHASE_LOCATION");
	IDX_H_PR_NO                    = GridObj.GetColHDIndex("H_PR_NO");
	IDX_H_PR_SEQ                   = GridObj.GetColHDIndex("H_PR_SEQ");
	IDX_H_PURCHASE_PRE_PRICE       = GridObj.GetColHDIndex("H_PURCHASE_PRE_PRICE");
	IDX_MOLDING_CHARGE 			   = GridObj.GetColHDIndex("MOLDING_CHARGE");
	IDX_MOLDING_TYPE               = GridObj.GetColHDIndex("MOLDING_TYPE");
	IDX_GISUL_RFQ 				   = GridObj.GetColHDIndex("GISUL_RFQ");
	IDX_QTA_ATTACH_NO 			   = GridObj.GetColHDIndex("QTA_ATTACH_NO");
	IDX_SUPPLY_PRICE               = GridObj.GetColHDIndex("SUPPLY_PRICE");
	IDX_SUPPLY_AMT                 = GridObj.GetColHDIndex("SUPPLY_AMT");
	IDX_CUSTOMER_PRICE             = GridObj.GetColHDIndex("CUSTOMER_PRICE");
	IDX_CUSTOMER_AMT               = GridObj.GetColHDIndex("CUSTOMER_AMT");
	IDX_DISCOUNT               	   = GridObj.GetColHDIndex("DISCOUNT");
	IDX_SETTLE_REMARK              = GridObj.GetColHDIndex("SETTLE_REMARK");
	IDX_SETTLE_ATTACH_NO           = GridObj.GetColHDIndex("SETTLE_ATTACH_NO");
	//doSelect();
    }

    function doSelect() {
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins3";
		
		//var mode = "getQtaCompareItem";
		<%-- GridObj.SetParam("mode"        , mode      );
		GridObj.SetParam("rfq_no"      , "<%= rfq_no           %>");
		GridObj.SetParam("rfq_count"   , "<%= rfq_count        %>");
	
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl); --%>

		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getQtaCompareItem";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);
    }

	function JavaCall(msg1, msg2, msg3, msg4, msg5) {
		if (msg1 == "doQuery") {
       		setInitRowCount();
			//setCellCombination();
			
<%
//			if(bid_req_type.equals("S")) {
%>
//    		 	GridObj.SetGroupMerge("TECHNIQUE_GRADE,TECHNIQUE_FLAG,TECHNIQUE_TYPE,INPUT_FROM_DATE,INPUT_TO_DATE,ITEM_QTY,UNIT_MEASURE,PR_NO");
<%
//			} else {
%>
//    		 	GridObj.SetGroupMerge("ITEM_NO,DESCRIPTION_LOC,SPECIFICATION,MAKER_NAME,UNIT_MEASURE,ITEM_QTY,PR_NO");
<%
//			}
%>
	   		for(var i=0; i<GridObj.GetRowCount(); i++) {
				var bid_flag   = GD_GetCellValueIndex(GridObj,i, IDX_BID_FLAG);
				if (bid_flag == "N" ){
// 					GridObj.SetCellActivation("SELECT_FLAG", i, 'edit') ;
					
				}

				customer_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_CUSTOMER_PRICE);
				if( customer_unitPrice == "" ) customer_unitPrice = "0";

				itemQty = GD_GetCellValueIndex(GridObj,i, IDX_ITEM_QTY);
				if( itemQty == "" ) itemQty = "1";

               	//var tmp_amt = eval(customer_unitPrice) * eval(itemQty);
               	//GD_SetCellValueIndex(GridObj,i, IDX_CUSTOMER_AMT, tmp_amt);
				supply_unitPrice = GD_GetCellValueIndex(GridObj,i, IDX_SUPPLY_PRICE);
				if( supply_unitPrice == "" ) supply_unitPrice = "0";
<%
// 				if(bid_req_type.equals("I")){
%>
// 					if ( eval(supply_unitPrice) > 0 ) {
// 						if(customer_unitPrice == "0"){
// 							tmp_discount = 0;
// 						}else {
// 							tmp_discount = (eval(customer_unitPrice) - eval(supply_unitPrice))/ eval(customer_unitPrice);
// 						}

//                 	} else {
//                 		tmp_discount = 0;
//                 	}

//                 	tmp_discount = RoundEx( (tmp_discount * 100) ,3) ;
//                 	if( eval(tmp_discount) == 100) tmp_discount = 0;
//                 	GD_SetCellValueIndex(GridObj,i, IDX_DISCOUNT, tmp_discount);
<%
// 				}
%>
			} // for
	 	} else if (msg1 == "doData" ) {
        	alert(GD_GetParam(GridObj,0));

	    	if ("1" == GridObj.GetStatus()) { // in case of success
	        	//removeRows(form1.deleteKeys.value.split(","));
	        	//backPage();
	        	opener.doSelect();
        		opener.window.focus();
				window.close();
	    	}

			form1.deleteKeys.value = "";

		} else if (msg1 == "t_imagetext") {
			
			if (msg3 == IDX_IMG_SELECTED          ) changeCheckBox    (msg2, msg3, "IDX_SELECTED");    // 체크박스 체인지
            else if (msg3 == IDX_IMG_CONTRACT_FLAG) changeCheckBox    (msg2, msg3, "IDX_CONTRACT_FLAG");    // 체크박스 체인지
            else if (msg3 == IDX_IMG_AUTO_PO_FLAG ) changeCheckBox    (msg2, msg3, "IDX_AUTO_PO_FLAG");    // 체크박스 체인지
            else if (msg3 == IDX_ITEM_NO          ) openItemInfo      (msg2);    // 자재정보 팝업
            else if (msg3 == IDX_PURCHASE_LOCATION) openSelectLocation(msg2);    // 구매지역선택 팝업
            else if (msg3 == IDX_COST_COUNT       ) {
            	if("0" != GD_GetCellValueIndex(GridObj,msg2, msg3) && "" != GD_GetCellValueIndex(GridObj,msg2, msg3)) {
            		var RFQ_NO        = "<%=rfq_no%>";
            		var RFQ_COUNT     = "<%=rfq_count%>";
            		var RFQ_SEQ       = GD_GetCellValueIndex(GridObj,msg2, IDX_H_RFQ_SEQ);
            		var VENDOR_CODE   = GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);

                    window.open('qta_pp_dis7.jsp?XPosition='+ msg2 + '&RFQ_NO=' + RFQ_NO + '&RFQ_COUNT=' + RFQ_COUNT +'&RFQ_SEQ=' + RFQ_SEQ +'&VENDOR_CODE=' + VENDOR_CODE,"win_cost","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=465,height=300,left=0,top=0");
                }
            }
            else if (msg3 == IDX_GISUL_RFQ)  { // 기술견적평가내역
              var r_rfq_no = GD_GetCellValueIndex(GridObj,msg2, IDX_H_RFQ_NO) ;
              var rfq_seq = GD_GetCellValueIndex(GridObj,msg2, IDX_H_RFQ_SEQ) ;
              var rfq_count     = "<%=rfq_count%>";
              var description_loc = GD_GetCellValueIndex(GridObj,msg2, IDX_H_DESCRIPTION_LOC) ;

              var file_name = "trfq_bd_lis3.jsp";

              if ("<%=qflag%>" == "ALL") file_name = "trfq_bd_lis4.jsp";

              window.open(file_name+"?r_rfq_no="+r_rfq_no+"&rfq_seq="+rfq_seq+"&rfq_count="+rfq_count+"&description_loc="+description_loc+"&pop_flag=Y","trfq_detail","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
          }

            else if(msg3 == IDX_QTA_NO) {//견적서번호
                if ("" == GD_GetCellValueIndex(GridObj,msg2, IDX_H_QTA_NO) || "입찰포기" == GD_GetCellValueIndex(GridObj,msg2, IDX_H_QTA_NO)) return;

                send_url  = "qta_pp_dis1.jsp";
    			send_url += "?st_vendor_code=" + GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);
    			send_url += "&st_qta_no=" + GD_GetCellValueIndex(GridObj,msg2, IDX_H_QTA_NO);

                window.open(send_url, "qta_win1", "toolbar=no, location=no, directories=no, status=yes, menubar=no, scrollbars=yes, resizable=no, width=840, height=640, left=0, top=0");
            }
            else if(msg3 == IDX_QTA_ATTACH_NO)
            {
                var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_QTA_ATTACH_NO));
/*
			        if(ATTACH_NO_VALUE == "PF"){
					    var QTA_NO		= GD_GetCellValueIndex(GridObj,msg2, IDX_QTA_NO);
					    var RFQ_NO		= "<%=rfq_no		%>";
					    var RFQ_COUNT	= "<%=rfq_count	%>";
					    var RFQ_SEQ = GD_GetCellValueIndex(GridObj,msg2, IDX_H_RFQ_SEQ) ;
            			var VENDOR_CODE   = GD_GetCellValueIndex(GridObj,msg2, IDX_VENDOR_CODE);
						var loc2 = "qta_pp_dis4.jsp?XPosition="+ msg2 + "&QTA_ATTACH_NO="+ATTACH_NO_VALUE+ "&QTA_NO="+QTA_NO+ "&RFQ_NO="+RFQ_NO+ "&RFQ_COUNT="+RFQ_COUNT+ "&RFQ_SEQ="+RFQ_SEQ+ "&VENDOR_CODE="+VENDOR_CODE;
						window.open(loc2  , "qta_pp_ins1","left=0,top=0,width=630,height=400,resizable=no,scrollbars=no");
			        }
*/
			        if ((ATTACH_NO_VALUE != "") && (ATTACH_NO_VALUE != "N")) {
						rMateFileAttach('P','R','QTA',ATTACH_NO_VALUE,'S');
					}
            }else if(msg3 == IDX_SETTLE_REMARK){
            	if(GridObj.GetCellValue("SELECT_FLAG", msg2) != "1"){
            		//return;
            	}

            	var SETTLE_ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, IDX_SETTLE_ATTACH_NO));

            	var mode = "";
            	var url = "/kr/confirm_pp_dis.jsp?mode=update&function=setSettleRemark&title=선정사유&columnType=t_imagetext&column=SETTLE_REMARK&useAttach=Y&row="+ msg2+"&attach_no="+SETTLE_ATTACH_NO_VALUE;
				var left = 150;
				var top = 150;
				var width = 680;
				var height = 480;
				var toolbar = 'no';
				var menubar = 'no';
				var status = 'yes';
				var scrollbars = 'yes';
				var resizable = 'no';
				var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
				ReasonWin.focus();
            }

        }
        else if (msg1 == "t_insert") {
        	m = GridObj.GetRowCount();
        	if (msg3 == IDX_SELECT_FLAG) {
            	alert("msg3:"+msg3);
            	if ("입찰포기" == GD_GetCellValueIndex(GridObj,msg2, IDX_H_QTA_NO)) {
            		alert('입찰하지 않은 업체를 선정하실 수 없습니다.');
					//GD_SetCellValueIndex(GridObj,msg2, IDX_SELECT_FLAG,"Y&Y#N&N","&","#","1");
					GD_SetCellValueIndex(GridObj,msg2, IDX_SELECT_FLAG,"0");
					var columkey = GridObj.GetColHDKey(IDX_SELECT_FLAG);
            		return;
            	}

            	//선정사유, 첨부파일 색상 변경
            	/* 
            	if(GridObj.GetCellValue("SELECT_FLAG", msg2) == "1"){
            		GridObj.SetCellBgColor("SETTLE_REMARK", msg2, G_COL1_OPT);
                	GridObj.SetCellBgColor("SETTLE_ATTACH_NO", msg2, G_COL1_OPT);
            	}else {
            		GridObj.SetCellBgColor("SETTLE_REMARK", msg2, "255|255|255");
                    GridObj.SetCellBgColor("SETTLE_ATTACH_NO", msg2, "255|255|255");
            	}
 				*/
            }
        }
        else if (msg1 == "t_header") {
            if (msg3 == IDX_IMG_SELECTED) checkAll();    // 전체선택
        }
    }

    function setInitRowCount() {
        form1.initRowCnt.value = GridObj.GetRowCount();
    }

    //= 셀초기화
    function initializeCell() {
    }

    function setCellCombination() {
        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            GD_SetCellValueIndex(GridObj,i, IDX_IMG_SEL           , "/kr/images/button/chkbox_false.gif##false","#");
            GD_SetCellValueIndex(GridObj,i, IDX_ITEM_NO           , "#" + GD_GetCellValueIndex(GridObj,i, IDX_H_ITEM_NO) + "#","#");
            GD_SetCellValueIndex(GridObj,i, IDX_DESCRIPTION_LOC   , GD_GetCellValueIndex(GridObj,i, IDX_H_DESCRIPTION_LOC   ));
            GD_SetCellValueIndex(GridObj,i, IDX_SPECIFICATION     , GD_GetCellValueIndex(GridObj,i, IDX_H_SPECIFICATION     ));
            GD_SetCellValueIndex(GridObj,i, IDX_ITEM_QTY          , GD_GetCellValueIndex(GridObj,i, IDX_H_ITEM_QTY          ));

            GD_SetCellValueIndex(GridObj,i, IDX_UNIT_MEASURE      , GD_GetCellValueIndex(GridObj,i, IDX_H_UNIT_MEASURE      ));
            GD_SetCellValueIndex(GridObj,i, IDX_PURCHASE_LOCATION , G_IMG_ICON + "#Y#","#"                                 );
            GD_SetCellValueIndex(GridObj,i, IDX_IMG_CONTRACT_FLAG , "/kr/images/button/chkbox_false.gif##false","#");
            GD_SetCellValueIndex(GridObj,i, IDX_IMG_AUTO_PO_FLAG  , "/kr/images/button/chkbox_false.gif##false","#");
            GD_SetCellValueIndex(GridObj,i, IDX_PR_NO             , GD_GetCellValueIndex(GridObj,i, IDX_H_PR_NO             ));
            GD_SetCellValueIndex(GridObj,i, IDX_PR_SEQ            , GD_GetCellValueIndex(GridObj,i, IDX_H_PR_SEQ            ));
            GD_SetCellValueIndex(GridObj,i, IDX_PURCHASE_PRE_PRICE, GD_GetCellValueIndex(GridObj,i, IDX_H_PURCHASE_PRE_PRICE));

            if(GD_GetCellValueIndex(GridObj,i, IDX_H_QTA_NO) == "") {
            	GD_SetCellActivation(GridObj,i, IDX_QUOTA_PERCENT , "false");
            	GD_SetCellActivation(GridObj,i, IDX_SELECT_FLAG   , "false");

            }
        }
    }

    //= 체크박스 체인지
    function changeCheckBox(selectedIndex, chkCol, CurVal) {
        var selectedRfqSeq = GD_GetCellValueIndex(GridObj,selectedIndex, IDX_H_RFQ_SEQ);

        var isChecked  = false;
        var startIndex = -1;
        var endIndex   = GridObj.GetRowCount();

        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            if (selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
                if (startIndex == -1)
                    startIndex = i;

                if (true == GD_GetCellValueIndex(GridObj,i, eval(chkCol)))
                    isChecked = true;

            }  else if (i > selectedIndex) {
                endIndex = i;
                break;
            }
        }

        for (var i = startIndex; i < endIndex; i++) {
            if (isChecked) {
                GD_SetCellValueIndex(GridObj,i, eval(CurVal)    , "false#","#");
                GD_SetCellValueIndex(GridObj,i, eval(chkCol), "/kr/images/button/chkbox_false.gif##false","#");

            } else {
                GD_SetCellValueIndex(GridObj,i, eval(CurVal)    , "true#","#");
                GD_SetCellValueIndex(GridObj,i, eval(chkCol), "/kr/images/button/chkbox_true.gif##true","#");
            }
        }

        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            if (i < startIndex || i >= endIndex) {
                if (GD_GetCellValueIndex(GridObj,selectedIndex, IDX_H_ITEM_NO) == GD_GetCellValueIndex(GridObj,i, IDX_H_ITEM_NO)) {
                    GD_SetCellValueIndex(GridObj,i, eval(CurVal)    , GD_GetCellValueIndex(GridObj,selectedIndex, eval(CurVal)) + "#","#");
                    GD_SetCellValueIndex(GridObj,i, eval(chkCol), "/kr/images/button/chkbox_" + GD_GetCellValueIndex(GridObj,selectedIndex, eval(CurVal)) + ".gif##" + GD_GetCellValueIndex(GridObj,selectedIndex, eval(CurVal)),"#");
                }
            }
        }
    }

    function openItemInfo(selectedIndex){
		var ITEM_NO = GD_GetCellValueIndex(GridObj,selectedIndex, IDX_H_ITEM_NO);
		POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+ITEM_NO, "품목_일반정보", '0', '0', '800', '400');
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

    function openSelectLocation(selectedIndex) {
    	G_CUR_ROW = selectedIndex;

		url = "/kr/dt/rfq/ebd_pp_ins7.jsp?PURCHASE_CODE="+GD_GetCellValueIndex(GridObj,selectedIndex, IDX_H_PURCHASE_LOCATION);
		PopupGeneral(url, "ebd_pp_ins7", "","","600","500");
    }

   	function called_ebd_pp_ins7(data) {

        var selectedRfqSeq = GD_GetCellValueIndex(GridObj,G_CUR_ROW, IDX_H_RFQ_SEQ);

        for (var i = 0; i < GridObj.GetRowCount(); i++) {
	        if(selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
		   		GD_SetCellValueIndex(GridObj,i, IDX_PURCHASE_LOCATION, G_IMG_ICON + "&Y&" + data, "&");
		   		GD_SetCellValueIndex(GridObj,i, IDX_H_PURCHASE_LOCATION, data);
	        }
	    }
   	}

    //= 전체선택
    function checkAll() {
        var isChecked = false;
        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            if ("true" == GD_GetCellValueIndex(GridObj,i, IDX_SELECTED)) {
                isChecked = true;
                break;
            }
        }

        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            if (isChecked) {
                GD_SetCellValueIndex(GridObj,i, IDX_SELECTED    , "false#","#");
                GD_SetCellValueIndex(GridObj,i, IDX_IMG_SEL, "/kr/images/button/chkbox_false.gif##false","#");

            } else {
                GD_SetCellValueIndex(GridObj,i, IDX_SELECTED    , "true#","#");
                GD_SetCellValueIndex(GridObj,i, IDX_IMG_SEL, "/kr/images/button/chkbox_true.gif##true","#");
            }
        }
    }

    function setQuotaPercent(selIndex) {
    	var chkCnt = 0;
    	var TotCnt = 0;

      var selectedRfqSeq = GD_GetCellValueIndex(GridObj,selIndex, IDX_H_RFQ_SEQ);
	    for (var i = 0; i < GridObj.GetRowCount(); i++) {
	        if(selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
	        	TotCnt++;
	        }
	    }

    	if(GridObj.GetComboHiddenValue("SELECT_FLAG",GridObj.GetComboSelectedIndex("SELECT_FLAG",selIndex)) == "Y") {
				GD_SetCellValueIndex(GridObj,selIndex, IDX_QUOTA_PERCENT, "100");

	  	      for (var i = 0; i < GridObj.GetRowCount(); i++) {
			        if(selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
	  	              GD_SetCellValueIndex(GridObj,i, IDX_SELECTED    , "true#","#");
	  	              GD_SetCellValueIndex(GridObj,i, IDX_IMG_SEL, "/kr/images/button/chkbox_true.gif##true","#");
			        }
			    }
			} else {
				GD_SetCellValueIndex(GridObj,selIndex, IDX_QUOTA_PERCENT, "");

	  	      for (var i = 0; i < GridObj.GetRowCount(); i++) {
			        if(selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
			        	if(GD_GetCellValueIndex(GridObj,i, IDX_SELECT_FLAG) == "N") chkCnt++;
			        }
			    }
			    if(TotCnt == chkCnt) {
			        for (var i = 0; i < GridObj.GetRowCount(); i++) {
				        if(selectedRfqSeq == GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
			                GD_SetCellValueIndex(GridObj,i, IDX_SEL    , "false#","#");
			                GD_SetCellValueIndex(GridObj,i, IDX_IMG_SEL, "/kr/images/button/chkbox_false.gif##false","#");
				        }
				    }

    	            chkCnt = 0;
			    }
			}
    }

	function selectCond(sepoa, selectedRow, flag )
	{
	/*
		var sepoa = GridObj;
		var cur_pr_no  	 	= GD_GetCellValueIndex(sepoa,selectedRow, IDX_PR_NO);
		var cur_pr_seq  	= GD_GetCellValueIndex(sepoa,selectedRow, IDX_PR_SEQ);
		var iRowCount   	= sepoa.GetRowCount();

		for(var i=0;i<iRowCount;i++) {
			if( cur_pr_seq == GD_GetCellValueIndex(sepoa,i,IDX_PR_SEQ) ) {
				GD_SetCellValueIndex(sepoa,i,IDX_SELECTED,flag+"&","&");
			}
		}
	*/


		for(var i=0; i<GridObj.GetRowCount(); i++){
			GridObj.SetCellValue("SELECTED", i, "0");
		}

		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECSELECTEDLAG", i) == "1"){
				var pr_no	=	GridObj.GetCellValue("PR_NO", i);
				var pr_seq 	=	GridObj.GetCellValue("PR_SEQ", i);
				for(var j=0; j<GridObj.GetRowCount(); j++){
					var pr_no2	=	GridObj.GetCellValue("PR_NO", j);
					var pr_seq2 	=	GridObj.GetCellValue("PR_SEQ", j);

					if(pr_no == pr_no2 && pr_seq == pr_seq2){
						GridObj.SetCellValue("SELECTED", j, "1");
					}
				}
			}
		}


	}

	var G_tmp_perc = 0.0;

        //= 업체선정
    function doSave() {

        if (GridObj.GetRowCount() == 0) return;

        var isChecked = false;
        var dIndex    = 0;
        var rfqSeqs   = new Array();
        var curRfqSeq = "";
        var G_tmp_perc   = 0.0;
        var perc      = 0.0;
        var cnt = 0;
		var item_no = "";
		var pr_seq = "";
		var f_pr_seq = "";
		var vendor_code = "";
		var TmpCurRfqSeq = "";

		var select_flag_cnt = 0;

		selectCond();
    	for (var i = 0; i < GridObj.GetRowCount(); i++) {

	    	if ("1" == GridObj.GetCellValue("SELECT_FLAG", i))	{
				 //var flag = "true";
				 //selectCond(GridObj, i, flag);

				 select_flag_cnt++;
			}

     		if (GD_GetCellValueIndex(GridObj,i,IDX_SELECT_FLAG) == true) {
		     	if (item_no != "" && item_no == GD_GetCellValueIndex(GridObj, i, IDX_H_ITEM_NO)) {
			     	if (pr_seq != "" && pr_seq == GD_GetCellValueIndex(GridObj, i, IDX_PR_SEQ)) {
						if (vendor_code != ""){
							if (vendor_code != GD_GetCellValueIndex(GridObj, i, IDX_VENDOR_CODE)){
								alert("동일한 품목에 대해서는 하나의 업체만 선택야 합니다.");
								return;
							}
						}
					}
				}

				item_no 	= GD_GetCellValueIndex(GridObj, i, IDX_H_ITEM_NO);
				vendor_code = GD_GetCellValueIndex(GridObj, i, IDX_VENDOR_CODE);
				pr_seq 		= GD_GetCellValueIndex(GridObj, i, IDX_PR_SEQ);
     		} else {
		     	if (pr_seq != "" && pr_seq != GD_GetCellValueIndex(GridObj, i, IDX_PR_SEQ)) {
			     	if (GD_GetCellValueIndex(GridObj, i, IDX_SELECT_FLAG) != "true") {
						 //var flag = "false";
						 //selectCond(GridObj, i, flag);
					 }
		     	}
				f_pr_seq = GD_GetCellValueIndex(GridObj, i, IDX_PR_SEQ);
     		}

	        cnt++;
        }

		var sendRow = getCheckedCount(GridObj, IDX_SELECTED) ;

		if ( sendRow == "" || sendRow.length == 0 ) {
			alert(G_MSS1_SELECT) ;
			return ;
		}

		if( cnt == 0 ) {
             alert("선정여부를 선택하여 주십시요.");
             return;
		}

		if( select_flag_cnt == 0 ) {
             alert("선정여부를 선택하여 주십시요.");
             return;
		}

	    var chk =nego_eval_data();

	    if( chk == false ) {
	    	if( !confirm("선정하신 업체가 최저금액업체가 아닙니다. 선정하시겠습니까?") ) {
				return;
			}else {
				//if(remarkData() == "" || attachData() == "") {
            	if(remarkData() == "") {
	           		alert("선정사유와 첨부파일을 입력하세요.");
	           		return;
	           	}
			}
	    }else {
        	if( !confirm("업체선정 하시겠습니까?") ){
        		return;
        	}
        }

        mode = "setItemDetailSave";
        form1.deleteKeys.value = rfqSeqs;

        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins3";

        GridObj.SetParam("mode"       , "setItemDetailSave"      );
        GridObj.SetParam("rfqNo"      , "<%= rfq_no           %>");
        GridObj.SetParam("rfqCount"   , "<%= rfq_count        %>");
        GridObj.SetParam("rfqSeqs"    , rfqSeqs                  );
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    }

    function nego_eval_data()
    {
        var row = GridObj.GetRowCount();
        var cnt = 0;
        var nego_eval = 0;
        var compare_nego_eval = 0;
        var tmp_nego_eval = 0;

        for(i = 0;i < row;i++){
            var s_yn = GD_GetCellValueIndex(GridObj,i,IDX_SELECTED);
            var yn = GD_GetCellValueIndex(GridObj,i,IDX_SELECT_FLAG);
            compare_nego_eval = GD_GetCellValueIndex(GridObj,i,IDX_SUPPLY_AMT);

            if(s_yn == "true" && yn == "true"){
                tmp_nego_eval = eval(GD_GetCellValueIndex(GridObj,i,IDX_SUPPLY_AMT));
                if ( nego_eval == 0 )
                    nego_eval = tmp_nego_eval;

                if ( eval(nego_eval) > eval(tmp_nego_eval) )
                    nego_eval = tmp_nego_eval;
            }
        }

        for(i = 0;i < row;i++){
            var s_yn = GD_GetCellValueIndex(GridObj,i,IDX_SELECTED);
            var yn = GD_GetCellValueIndex(GridObj,i,IDX_SELECT_FLAG);

            if(s_yn == "true" && yn != "true"){
                tmp_nego_eval = eval(GD_GetCellValueIndex(GridObj,i,IDX_SUPPLY_AMT));

                if( eval(nego_eval) > 0 && eval(nego_eval) > eval(tmp_nego_eval) )
                return false;
            }
        }
        return true;
    }

    function backPage() {
        if (GridObj.GetRowCount() == 0) {
        	opener.doSelect();
        	window.close();
        }
    }

    function removeRows(deleteKeys) {
        for (var i = GridObj.GetRowCount() - 1; i >= 0; i--) {
            var curRfqSeq = GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ);
            //var curRfqSeq = GetComboHiddenValue(GridObj.GetColHDKey(IDX_H_RFQ_SEQ),i);

            for (var j = 0; j < deleteKeys.length; j++) {
                if (curRfqSeq == deleteKeys[j]) {
                    GridObj.DeleteRow(i);
                    break;
                }
            }
        }

        initializeCell();
        setCellCombination();
    }

    //= 청구복구
    function setUpdate_pr_recovery() {
        if (GridObj.GetRowCount() == 0) return;

//Check --->		checkAll();

        var rfqNo       = "<%= rfq_no      %>";
        var rfqCount    = "<%= rfq_count   %>";

        var isChecked = false;
        var dIndex    = 0;
        var rfqSeqs   = new Array();
        var curRfqSeq = "";

        for (var i = 0; i < GridObj.GetRowCount(); i++) {
            if ("true" == GD_GetCellValueIndex(GridObj,i, IDX_SELECTED)) {

                if (curRfqSeq != GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ)) {
                    curRfqSeq = GD_GetCellValueIndex(GridObj,i, IDX_H_RFQ_SEQ);
                    rfqSeqs[dIndex] = curRfqSeq;
                    dIndex++;

                    isChecked = true;
                }
            }
        }

        if (! isChecked) {
            alert(G_MSS1_SELECT);
            return;
        }

		form1.deleteKeys.value = rfqSeqs;

        if (! confirm("구매복구 하시겠습니까?")) return;

		// 구매복구 사유입력창
        var url = "/kr/confirm_pp_dis.jsp?mode=update&function=go_setUpdate_pr_recovery&title=구매복구사유&column=sr_reason&maxByte=4000&useAttach=Y&attach_no="+document.forms[0].sr_attach_no.value;
		var left = 150;
		var top = 150;
		var width = 680;
		var height = 480;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		var ReasonWin = window.open( url, 'Reason', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		ReasonWin.focus();


	}

	function go_setUpdate_pr_recovery(value, row, att_no){

    	document.forms[0].sr_reason.value    = value;
    	document.forms[0].sr_attach_no.value = att_no;

        mode = "setReturnToPR_ItemBase";
        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.qta_bd_ins3";

        GridObj.SetParam("mode"       	, mode);
        GridObj.SetParam("rfqNo"      	, "<%=rfq_no%>"                  );
        GridObj.SetParam("rfqCount"   	, "<%=rfq_count%>"               );
		GridObj.SetParam("sr_reason"		, document.forms[0].sr_reason.value);
    	GridObj.SetParam("sr_attach_no"	, document.forms[0].sr_attach_no.value);
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    }

	function remarkData(){

    	var iRowCount = GridObj.GetRowCount();
		var iCheckedCount = 0;
		var remark = "";

    	for(var i=0;i<iRowCount;i++)
		{
  			if("true" == GD_GetCellValueIndex(GridObj,i, IDX_SELECT_FLAG)) {
  				GridObj.SetCellBgColor("SETTLE_REMARK", i, G_COL1_ESS);
                GridObj.SetCellBgColor("SETTLE_ATTACH_NO", i, G_COL1_ESS);
  				remark = GD_GetCellValueIndex(GridObj,i, IDX_SETTLE_REMARK);
  				if(remark == ""){
  					break;
  				}
				iCheckedCount++;
  			}
		}

		return remark;
    }

	function attachData(){
		var iRowCount = GridObj.GetRowCount();
		var iCheckedCount = 0;
		var attach_no = "";

    	for(var i=0;i<iRowCount;i++)
		{
  			if("true" == GD_GetCellValueIndex(GridObj,i, IDX_SELECTED)) {
  				attach_no = GD_GetCellValueIndex(GridObj,i, IDX_SETTLE_ATTACH_NO);
  				if(attach_no == ""){
  					break;
  				}
				iCheckedCount++;
  			}
		}

		return attach_no;
	}

	function setSettleRemark(value, row, att_no){
    	var img = value == "" ? "" : "<%=G_IMG_ICON%>";
    	GD_SetCellValueIndex(GridObj,row, IDX_SETTLE_REMARK,    img + "&null&" + value,"&");
    	GD_SetCellValueIndex(GridObj,row, IDX_SETTLE_ATTACH_NO, img + "&null&" + att_no,"&");
    }

	/* function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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
	} */

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
        doSelect();
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
  <input type="hidden" name="initRowCnt"       id="initRowCnt"       value="">
  <input type="hidden" name="deleteKeys"       id="deleteKeys"       value="">
  <textarea name="sr_reason"                   id="sr_reason"        style="display:none;"></textarea>
  <input type="hidden" name="sr_attach_no"     id="sr_attach_no">

	<input type="hidden" name="att_mode"       id="att_mode"         value="">
	<input type="hidden" name="view_type"      id="view_type"        value="">
	<input type="hidden" name="file_type"      id="file_type"        value="">
	<input type="hidden" name="tmp_att_no"     id="tmp_att_no"       value="">
	<input type="hidden" name="attach_count"   id="attach_count"     value="">

	<input type="hidden" name="rfq_no"      id="rfq_no"        value="<%= rfq_no %>">
	<input type="hidden" name="rfq_count"   id="rfq_count"     value="<%= rfq_count %>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>견적비교 (품목별)
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
	<td class="data_td" width="30%"><%= rfq_no %></td>
	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차 수</td>
	<td class="data_td" width="30%"><%= rfq_count %>&nbsp;차</td>
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
			<TD><script language="javascript">btn("javascript:doSave()","업체선정")                 </script></TD>
			<% if (!req_type.equals("M")) { %>
			<%-- <TD><script language="javascript">btn("javascript:setUpdate_pr_recovery()","구매복구") </script></TD> --%>
			<% } %>
			<TD><script language="javascript">btn("javascript:window.close()","닫 기")              </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

</form>

</s:header>
<s:grid screen_id="RQ_249" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


