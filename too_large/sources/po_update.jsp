<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>




<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

 <%
     String inv_no = JSPUtil.nullToEmpty(request.getParameter("po_no"));
	 String isNewPage = JSPUtil.nullToRef(request.getParameter("isNewPage"),"N");

    Object[] obj1 = {inv_no};
    SepoaOut value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoCreateInfo_2", obj1);
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    String dely_terms = "";
    String delay_remark = "";
    String warranty_month = "";
    String first_percent = "";
    String contract_percent = "";
    String mengel_percent = "";
    if(wf.getRowCount() > 0) {
    	dely_terms = wf.getValue("dely_terms", 0);
    	delay_remark = wf.getValue("DELAY_REMARK", 0);
    	warranty_month = wf.getValue("WARRANTY_MONTH", 0);
    	first_percent = wf.getValue("FIRST_PERCENT", 0);
    	contract_percent = wf.getValue("CONTRACT_PERCENT", 0);
    	mengel_percent = wf.getValue("MENGEL_PERCENT", 0);
    } 
%> 


<%
	String G_IMG_ICON="";
   	String user_id        		= info.getSession("ID");
    String house_code     		= info.getSession("HOUSE_CODE");
    String company_code   		= info.getSession("COMPANY_CODE");
    String ctrl_code      		= info.getSession("CTRL_CODE");
    String user_name	 		= info.getSession("NAME_LOC");
    String toDaysSo       		= SepoaDate.getShortDateString();
    String toDays         		= SepoaDate.getFormatString("yyyy/MM/dd");
	String VENDOR_CODE			= "";
	String VENDOR_NAME			= "";
	String SUBJECT				= "";
	String CTRL_CODE			= "";
	String PAY_TERMS			= "";
	String PAY_TERMS_DESC		= "";
	String PR_TYPE				= "";
	String PR_TYPE_DESC			= "";
	String ORDER_NO				= "";
	String ORDER_NAME			= "";
	String CUR					= "";
	String EXEC_AMT_KRW			= "";
	String TAKE_USER_NAME		= "";
	String TAKE_USER_ID			= "";
	String CTR_DATE				= "";
	String TAKE_TEL				= "";
	String REMARK				= "";
	String EXEC_NO				= "";
	String CTR_NO				= "";
	String VENDOR_CP_NAME		= "";
    String VENDOR_MOBILE_NO 	= "";
    String CONTRACT_FROM_DATE	= "";
	String CONTRACT_TO_DATE		= "";
	String SIGN_PERSON_ID		= "";
	String SIGN_DATE			= "";
	String ADD_TIME				= "";
	String ADD_DATE				= "";
	String ADD_USER_ID			= "";
	String PO_TYPE				= "";
	String PO_AMT_KRW			= "";
	String BSART_DESC			= "";
	String ATTACH_NO			= "";
	String VENDOR_EMAIL			= "";
	String ORIGINAL_SIGN_STATUS	= "";
	String FILE_NAME = "";

    String po_no          		= JSPUtil.nullToEmpty(request.getParameter("po_no"));
    String pr_type          	= JSPUtil.nullToEmpty(request.getParameter("pr_type"));
	if ("".equals(po_no)) po_no = JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	
	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 번호를 가져와서 작성/수정여부판단
	String cont_seq 	= ""; // 전자계약번호
	String cont_count 	= ""; // 전자계약차수
	String form_seq 	= "0"; // 서식번호
	
   	Object[] obj = {po_no};
   	value = ServiceConnector.doService(info, "PO_002", "CONNECTION", "getPoDetailHeader", obj);
   	wf = new SepoaFormater(value.result[0]);
   
	if(wf.getRowCount() > 0) {
		VENDOR_CODE		    = wf.getValue("VENDOR_CODE"	 		, 0);
		VENDOR_NAME		    = wf.getValue("VENDOR_NAME"	 		, 0);
		SUBJECT			    = wf.getValue("SUBJECT"	 			, 0);
		CTRL_CODE		    = wf.getValue("CTRL_CODE"    		, 0);
		PAY_TERMS		    = wf.getValue("PAY_TERMS"    		, 0);
		PAY_TERMS_DESC		= wf.getValue("PAY_TERMS_DESC"    	, 0);
		PR_TYPE			    = wf.getValue("PR_TYPE"				, 0);
		PR_TYPE_DESC	    = wf.getValue("PR_TYPE_DESC"		, 0);
		ORDER_NO			= wf.getValue("ORDER_NO"	 		, 0);
		ORDER_NAME			= wf.getValue("ORDER_NAME"	 		, 0);
		CUR				    = wf.getValue("CUR"	 				, 0);
		EXEC_AMT_KRW		= wf.getValue("PO_TTL_AMT"			, 0);
		TAKE_USER_NAME	    = wf.getValue("TAKE_USER_NAME"  	, 0);
		TAKE_USER_ID	    = JSPUtil.nullToEmpty(wf.getValue("TAKE_USER_ID"  	, 0));
		CTR_DATE			= wf.getValue("CTR_DATE"	 		, 0);
		TAKE_TEL			= wf.getValue("TAKE_TEL"	 		, 0);
		REMARK			    = wf.getValue("REMARK"    			, 0);
		EXEC_NO			    = wf.getValue("EXEC_NO"	 			, 0);
		CTR_NO			    = wf.getValue("CTR_NO"    			, 0);
		VENDOR_CP_NAME		= wf.getValue("VENDOR_CP_NAME"		, 0);
		VENDOR_MOBILE_NO    = wf.getValue("VENDOR_MOBILE_NO"	, 0);
		CONTRACT_FROM_DATE	= wf.getValue("CONTRACT_FROM_DATE"	, 0);
		CONTRACT_TO_DATE    = wf.getValue("CONTRACT_TO_DATE"	, 0);
		SIGN_PERSON_ID		= wf.getValue("SIGN_PERSON_ID"		, 0);
		SIGN_DATE    		= wf.getValue("SIGN_DATE"			, 0);
		ADD_DATE    		= wf.getValue("ADD_DATE"			, 0);
		ADD_TIME    		= wf.getValue("ADD_TIME"			, 0);
		ADD_USER_ID    		= wf.getValue("ADD_USER_ID"			, 0);
		PO_TYPE    			= wf.getValue("PO_TYPE"				, 0);
		PO_AMT_KRW    		= wf.getValue("PO_AMT_KRW"			, 0);
		BSART_DESC    		= wf.getValue("BSART_DESC"			, 0);
		ATTACH_NO    		= wf.getValue("ATTACH_NO"			, 0);
		VENDOR_EMAIL		= wf.getValue("VENDOR_EMAIL"		, 0);
		ORIGINAL_SIGN_STATUS= wf.getValue("ORIGINAL_SIGN_STATUS", 0);
		FILE_NAME		= wf.getValue("SRC_FILE_NAME", 0);
		
		// 2011.07.28 HMCHOI 작성
		// 발주서 생성 및 수정시 전자계약서 번호를 가져와서 작성/수정여부판단
		cont_seq			= JSPUtil.nullToEmpty(wf.getValue("CONT_SEQ"	, 0));
		cont_count			= JSPUtil.nullToEmpty(wf.getValue("CONT_COUNT"	, 0));
		form_seq			= JSPUtil.nullToRef(wf.getValue("FORM_SEQ"		, 0),"1");
	}
	/* WiseListBox LB = new WiseListBox();
	String COMBO_M004     = LB.Table_ListBox(request, "SL0022", house_code+"#M187#", "&" , "#");
	 */
	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// wise.properties의 wise.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.
	Config wise_conf = new Configuration();
	boolean po_contract_use_flag = false;
	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = false;
	try {
		po_contract_use_flag = wise_conf.getBoolean("wise.po.contract.use." + info.getSession("HOUSE_CODE")); //발주 전자계약 사용여부
		form_seq = wise_conf.getString("wise.po.contract.form." + info.getSession("HOUSE_CODE")); //발주 전자계약 DEFAULT FORM_SEQ
		sign_use_module = wise_conf.get("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch (Exception e) {
		po_contract_use_flag = false;
		form_seq = "0";
		sign_use_module	= "";
	}
	
	String sign_po_type = "";
	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	while (st.hasMoreTokens()) {
		sign_po_type = st.nextToken();
		if (sign_po_type.equals("APO")) {
			sign_use_yn = true;
			break;
		} else {
			if (PO_TYPE.equals("D") && sign_po_type.equals("DPO")) { // 직발주
				sign_use_yn = true;
				break;
			} else if (PO_TYPE.equals("M") && sign_po_type.equals("MPO")) { // 메뉴얼발주
				sign_use_yn = true;
				break;
			} else if (sign_po_type.equals("EPO")||sign_po_type.equals("FPO")) { // 품의/종가발주
				if (!PO_TYPE.equals("D")&&!PO_TYPE.equals("M")) {
					sign_use_yn = true;
					break;
				}
			}
		}
	} 
%>

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

<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>

<script language="javascript">
<!--
	var G_CUR_ROW = -1;
	
	var mode;
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
	var pr_type = "<%=PR_TYPE%>";
	var IDX_SEL					;
	var IDX_ITEM_NO				;
	var IDX_DESCRIPTION_LOC		;
	var IDX_RD_DATE				;
	var IDX_UNIT_MEASURE		;
	var IDX_PO_QTY			    ;
	var IDX_UNIT_PRICE		    ;
	var IDX_ITEM_AMT			;
	var IDX_PR_UNIT_PRICE	    ;
	var IDX_PR_AMT			    ;
	var IDX_DOWN_AMT			;
	var IDX_PR_NO			    ;
	var IDX_CUST_NAME		    ;
	var IDX_CUR					;
	var IDX_EXCHANGE_RATE	    ;
	var IDX_EXEC_AMT_KRW		;
	var IDX_DELY_TO_LOCATION	;

	function init() {
		document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
setGridDraw();
setHeader();
	}
	
	function setAttach(attach_key, arrAttrach, attach_count) {


	    var attachfilename  = arrAttrach + "";
	    var result 			="";

		var attach_info 	= attachfilename.split(",");

		for (var i =0;  i <  attach_count; i ++)
	    {
		    var doc_no 			= attach_info[0+(i*7)];
			var doc_seq 		= attach_info[1+(i*7)];
			var type 			= attach_info[2+(i*7)];
			var des_file_name 	= attach_info[3+(i*7)];
			var src_file_name 	= attach_info[4+(i*7)];
			var file_size 		= attach_info[5+(i*7)];
			var add_user_id 	= attach_info[6+(i*7)];

			if (i == attach_count-1)
				result = result + src_file_name;
			else
				result = result + src_file_name + ",";
		}

		document.forms[0].ATTACH_NO.value = attach_key;
		document.forms[0].FILE_NAME.value = result;

	}

	function setHeader() {

		var itemsize 	= 100;
		var servicesize = 0;
		var item_no			 = "품목";
		var description_loc  = "품목명";
		var po_qty           = "수량";
		var dely_to_location = "납품장소";
		if(pr_type=="S"){
			item_no			= "인력코드";
			description_loc = "성명";
			po_qty          = "공수";
			dely_to_location= "근무장소";
			itemsize 	= 0;
			servicesize = 120;
		}
		
		//GridObj.SetColCellBgColor("UNIT_PRICE"		,G_COL1_OPT);
		//GridObj.SetColCellBgColor("PO_QTY"			,G_COL1_OPT);



	    IDX_SEL					= GridObj.GetColHDIndex("SEL"				);
	    IDX_ITEM_NO				= GridObj.GetColHDIndex("ITEM_NO"			);
	    IDX_DESCRIPTION_LOC		= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
	    IDX_RD_DATE				= GridObj.GetColHDIndex("RD_DATE"			);
	    IDX_UNIT_MEASURE		= GridObj.GetColHDIndex("UNIT_MEASURE"	);
	    IDX_PO_QTY			    = GridObj.GetColHDIndex("PO_QTY"			);
	    IDX_UNIT_PRICE		    = GridObj.GetColHDIndex("UNIT_PRICE"		);
	    IDX_ITEM_AMT			= GridObj.GetColHDIndex("ITEM_AMT"		);
	    IDX_PR_UNIT_PRICE	    = GridObj.GetColHDIndex("PR_UNIT_PRICE"	);
	    IDX_PR_AMT			    = GridObj.GetColHDIndex("PR_AMT"			);
	    IDX_DOWN_AMT			= GridObj.GetColHDIndex("DOWN_AMT"		);
	    IDX_PR_NO			    = GridObj.GetColHDIndex("PR_NO"			);
	    IDX_CUST_NAME		    = GridObj.GetColHDIndex("CUST_NAME"		);
	    IDX_CUR					= GridObj.GetColHDIndex("CUR"				);
	    IDX_EXCHANGE_RATE	    = GridObj.GetColHDIndex("EXCHANGE_RATE"	);
	    IDX_EXEC_AMT_KRW		= GridObj.GetColHDIndex("EXEC_AMT_KRW"	);
	    IDX_DELY_TO_LOCATION	= GridObj.GetColHDIndex("DELY_TO_LOCATION");
	    IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO");

	    IDX_ORDER_NO = GridObj.GetColHDIndex("ORDER_NO");
	    IDX_ORDER_SEQ = GridObj.GetColHDIndex("ORDER_SEQ");
	    IDX_WBS_NO = GridObj.GetColHDIndex("WBS_NO");
	    IDX_WBS_SUB_NO = GridObj.GetColHDIndex("WBS_SUB_NO");
	    IDX_WBS_TXT = GridObj.GetColHDIndex("WBS_TXT");

	    /*
	    IDX_KNTTP = GridObj.GetColHDIndex("KNTTP");
	    IDX_KNTTP_TEXT = GridObj.GetColHDIndex("KNTTP_TEXT");
	    IDX_MWSKZ = GridObj.GetColHDIndex("MWSKZ");
	    IDX_ZEXKN = GridObj.GetColHDIndex("ZEXKN");
	    IDX_INVEST_NO = GridObj.GetColHDIndex("INVEST_NO");
	    IDX_INVEST_NO_TEXT = GridObj.GetColHDIndex("INVEST_NO_TEXT");
	    IDX_INVEST_SUB_NO = GridObj.GetColHDIndex("INVEST_SUB_NO");
	    IDX_KTOGR = GridObj.GetColHDIndex("KTOGR");
	    IDX_AKTIV = GridObj.GetColHDIndex("AKTIV");
	    IDX_TXT50 = GridObj.GetColHDIndex("TXT50");
	    */
		

	    doQuery();
	}
	function doQuery()
	{
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getPoDetail&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_update";
		
		GridObj.post(url, param);
	 	GridObj.clearAll(false);	
	}
	
	// 2011.07.28 HMCHOI
	// 발주에서 전자계약을 진행할 경우 단계 (po_contract_use_flag = true)
	// 발주서 임시저장 -> 계약서 서명완료 -> 발주서 업체전송 -> 발주현황
   	var summaryCnt = 0;
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		// 발주단계 전자계약 여부(Y/N)
		var po_contract_use_flag = "<%=po_contract_use_flag%>";
        if(msg1 == "doData") { // 전송/저장시 Row삭제
    		// 발주단계 전자계약 여부 = Y
        	if (po_contract_use_flag == "true") {
        		var mode 		= GD_GetParam(GridObj,0);
				var status 		= GD_GetParam(GridObj,1);
				var new_po_no 	= GD_GetParam(GridObj,2);
				
				// 2011.08.18 HMCHOI
				// 발주서의 계약서 작성(P)시 계약서 화면 POP-UP
				if (mode == "P" && status == "1") {
					if (document.main.bid_no.value == "") {
						document.main.bid_no.value = new_po_no;
					}
					if(document.main.bid_no.value == "" || document.main.vendor_code.value == "") {
						alert("생성된 발주서가 없거나, 발주업체가 올바르지 않습니다.\n\n관리자에게 문의하세요.");
						return;
					}
					if ("<%=cont_seq%>" == "") {
						new_cont(); // 계약서작성
					} else {
	            		modify_cont(); // 계약서수정
					}
				}
				// 임시저장(T) 및 업체발송(E)이 완료되면 발주현황으로 화면이동
				if ((mode == "T" || mode == "E") && status == "1") {
					alert(GridObj.GetMessage());
					location.href="po_list.jsp";
				}
        	} else {
        		var mode 	= GD_GetParam(GridObj,0);
				var status 	= GD_GetParam(GridObj,1);
				
				alert(GridObj.GetMessage());
				location.href="po_list.jsp";
        	}
		} else if (msg1 == "t_imagetext") {
			G_CUR_ROW = msg2;

			if(msg3 == IDX_ITEM_NO){
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+msg4,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_DESCRIPTION_LOC){
				var item_no = GridObj.GetCellValue("ITEM_NO",msg2);
				//if(pr_type=="I")
					window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
				//else
				//	window.open("/s_kr/master/human/hum1_bd_dis1.jsp?human_no="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_PR_NO){
				window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+msg4,"pr1_bd_dis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
			}else if(msg3 == IDX_EXEC_NO) {
				//window.open("/kr/dt/app/app_pp_dis2.jsp?exec_no="+msg5,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
				window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+msg5+"&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
			}else if(msg3 == IDX_INVEST_NO_TEXT) {
			    var exec_no = GD_GetCellValueIndex(GridObj,msg2, IDX_EXEC_NO);
				window.open("/kr/order/bpo/po1_invest_pp_lis1.jsp?cur_row="+G_CUR_ROW,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
			}
		} else if (msg1 == "t_insert") {
            if(msg3 == IDX_RD_DATE) {
				se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, IDX_RD_DATE);

				if(se_rd_date <= eval("<%=SepoaDate.getShortDateString()%>") ) {
					alert("납기요청일은 현재날짜 이후여야 합니다."  );
					GD_SetCellValueIndex(GridObj,msg2, IDX_RD_DATE, msg4);
				}
            }else if(msg3 == IDX_UNIT_PRICE||msg3 == IDX_PO_QTY) {
				var ttl_amt = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_QTY)*GD_GetCellValueIndex(GridObj,msg2,IDX_UNIT_PRICE);
				GD_SetCellValueIndex(GridObj,msg2,IDX_ITEM_AMT,ttl_amt);
				setTotalAmount();
            }
		} else if(msg1 == "t_header") {
			if(msg3 == IDX_RD_DATE) {
				copyCell(WiseTable, IDX_RD_DATE, "t_date");
			}
		} else if(msg1 == "doQuery") {
        	if(msg3 == IDX_PO_QTY) {
        		calculate_po_qty(GridObj, msg2);
				calculate_po_amt(GridObj, msg2);
			}
			/* if(summaryCnt == 0) {
				GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PO_QTY,ITEM_AMT');
                GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
                summaryCnt++;
			} */
		}
	}
	
	/**
	 * 품목별 발주 수량을 계산한다.
     */
	function calculate_po_qty(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	GD_SetCellValueIndex(GridObj,row, IDX_PO_QTY, RoundEx(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY), 3));
  	}
	
	/**
	 * 품목별 발주 금액을 계산한다.
     */
	function calculate_po_amt(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	var ITEM_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
    	GD_SetCellValueIndex(GridObj,row, IDX_ITEM_AMT, setAmt(ITEM_AMT));
  	}
	
	function setTotalAmount(){
		var rowCount = GridObj.GetRowCount();
		var totalAmt = 0;
		for( i = 0; i < rowCount ; i++){
			totalAmt += parseInt(GD_GetCellValueIndex(GridObj, i, IDX_ITEM_AMT));
		}
		document.forms[0].EXEC_AMT_KRW.value = add_comma(totalAmt,0);
	}
	
	function approvalSign(){
		<!-- alert("approvalSign---------------start"); -->
	    childframe.location.href='/kr/admin/basic/approval/approval.jsp?house_code=<%=info.getSession("HOUSE_CODE")%>&company_code=<%=info.getSession("COMPANY_CODE")%>&dept_code=<%=info.getSession("DEPARTMENT")%>&req_user_id=<%=info.getSession("ID")%>&doc_type=POD&fnc_name=getApproval';
	}

	var saveRock  = false;
	var divStatus = "";

	function approval(set){

	    var wise = GridObj;

	    divStatus = set;
	    var f0 = document.forms[0];

	    f0.VENDOR_CODE.value = f0.VENDOR_CODE.value.toUpperCase();
	    f0.PO_NO.value       = f0.PO_NO.value.toUpperCase();

	    if(set != "COMP" && saveRock==true){
	        if (!confirm("해당하는 품번에 대해 이미 발주가 생성되었습니다.\n\n발주현황에서 변경할 발주서를 선택 후 다시 작성하세요.\n\n발주현황으로 이동하시겠습니까?")) {
	        	return;
	        }
			location.href="po_list.jsp";
			return;
	    }

	    var checked_count = 0;
	    var rowcount = GridObj.GetRowCount();
	    var qtyChk = true;
	    var rdChk = true;
	    var unitPriceChk = true;

	    var tmp_ctrl_code = "";

	    for(row=0; row<rowcount; row++) {
	    	
	        if("1" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
			
	            checked_count ++;

	            if(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)=="")
	                qtyChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_RD_DATE)=="")
	                rdChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)=="")
	                unitPriceChk = false;
	        }
	    }

	    if(checked_count == 0){
	        alert(G_MSS1_SELECT);
	        return;
	    }

	    if(f0.SUBJECT.value == ""){
	    	alert("발주명은 필수입력사항입니다.");
	    	return;
	    }
	    if(f0.TAKE_USER_ID.value == ""){
	    	alert("검수담당자는 필수입력사항입니다.");
	    	return;
	    }
	    if(!qtyChk){
	        alert("발주 수량은 필수입력사항입니다.");
	        return;
	    }
	    if(!unitPriceChk){
	        alert("단가는 필수입력사항입니다.");
	        return;
	    }

	    if(!rdChk ){
	        alert("납기요청일은 필수입력사항입니다.");
	        return;
	    }
	    if(f0.PO_TYPE.value == ""){
	    	alert("발주구분을 선택해주세요.");
	    	return;
	    }

	    var setCnt = 0;
	    for(var c=0; c<rowcount; c++)
	        if("1" == GD_GetCellValueIndex(GridObj,c, IDX_SEL))
	            setCnt ++;

	    var VENDOR_CODE =  f0.VENDOR_CODE.value;
	    var PO_NO       =  f0.PO_NO.value;
	    var CUR         =  f0.CUR.value;
	    var TTL_AMT     =  del_comma(f0.EXEC_AMT_KRW.value);
	    if(PO_NO=="") PO_NO="xp";
	   
	  <%--   
		GridObj.SetParam("VENDOR_CODE"	,VENDOR_CODE			);
	    GridObj.SetParam("PO_NO"          ,PO_NO					);
	    GridObj.SetParam("CUR"            ,CUR					);
	    GridObj.SetParam("TTL_AMT"        ,TTL_AMT				);
	    GridObj.SetParam("REMARK"         ,f0.REMARK.value		);
	    GridObj.SetParam("COMPANY_CODE"   ,"<%=company_code%>"	);
	    GridObj.SetParam("DELY_TERMS"     ," "					);
	    GridObj.SetParam("PAY_TERMS"      ,"<%=PAY_TERMS%>"		);
   	    GridObj.SetParam("ACCOUNT_TYPE"   ," "					);
   	    GridObj.SetParam("ORDER_NO"   	,f0.ORDER_NO.value		);
   	    GridObj.SetParam("ORDER_NAME"   	,"<%=ORDER_NAME%>"		);
		GridObj.SetParam("CTR_NO"			,""		);
		GridObj.SetParam("CTR_DATE"		,""		);
		GridObj.SetParam("PR_TYPE"		,"<%=PR_TYPE%>"	);
		GridObj.SetParam("ctrl_code"		,f0.ctrl_code.value		);
		GridObj.SetParam("SUBJECT"		,f0.SUBJECT.value		);
		GridObj.SetParam("ctrl_person_id"	,f0.ctrl_person_id.value);
		GridObj.SetParam("TAKE_USER_NAME" ,f0.TAKE_USER_NAME.value);
		GridObj.SetParam("TAKE_USER_ID" ,f0.TAKE_USER_ID.value);
		GridObj.SetParam("TAKE_TEL"		,f0.TAKE_TEL.value		);
		GridObj.SetParam("VENDOR_CP_NAME"  	,f0.vendor_person_name.value	);
		GridObj.SetParam("VENDOR_MOBILE_NO"	,f0.vendor_person_mobil.value	);
		GridObj.SetParam("VENDOR_EMAIL"		,f0.vendor_person_email.value	);
		GridObj.SetParam("PO_TYPE"			,f0.PO_TYPE.value				);
		GridObj.SetParam("CONTRACT_FROM_DATE" ,"<%=CONTRACT_FROM_DATE%>"		);
		GridObj.SetParam("CONTRACT_TO_DATE"	,"<%=CONTRACT_TO_DATE%>"		);
		GridObj.SetParam("SIGN_DATE" 			,"<%=SIGN_DATE%>"				);
		GridObj.SetParam("SIGN_PERSON_ID"		,"<%=SIGN_PERSON_ID%>"			);
		GridObj.SetParam("ADD_DATE" 			,"<%=ADD_DATE%>"				);
		GridObj.SetParam("ADD_TIME" 			,"<%=ADD_TIME%>"				);
		GridObj.SetParam("ADD_USER_ID" 		,"<%=ADD_USER_ID%>"				);
		GridObj.SetParam("PO_AMT_KRW"			,"<%=PO_AMT_KRW%>"				);
 --%>
	    // 2011.07.28 HMCHOI 추가
	    // 계약서 팝업을 보여주는 경우에는 화면을 임시저장 후 계약서 팝업을 보여주도록 한다.
	    // 계약서 팝업에서 서명완료가 되면 parent.getApproval("SEND");를 호출하여 발송처리
	    if(set=="SAVE"){
	    	if(!confirm("저장 하시겠습니까?")) return;
	        getApproval("SAVE");
	    }else if(set=="SEND"){
	    	if(!confirm("발주 하시겠습니까?")) return;
	        getApproval("SEND");
	    }else if(set=="CONT"){
	    	if(!confirm("발주 하시겠습니까?")) return;
    		getApproval("CONT");
	    }else if(set=="COMP"){
    		getApproval("SEND");
	    }else{
	    	if(!confirm("결재요청 하시겠습니까?")) return;
	        approvalSign();
		}
	}

	function getApproval(str){
		for(var i = 1; i <= GridObj.getRowsNum(); i++)
		{
			GridObj.cells(i, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SEL");
		var f0 = document.forms[0];
			
		if(str == '') return;

	    var sign_flag = "";
	    saveRock = true;
		
	    // 2011.07.28 HMCHOI 추가
	    // 계약서 팝업을 보여주는 경우에는 화면을 임시저장 후 계약서 팝업을 보여주도록 한다.
	    // 계약서 팝업에서 서명완료가 되면 parent.getApproval("SEND");를 호출하여 발송처리
	   	if (str == "SAVE"){
	        sign_flag = "T";   // 저장
	    }else if(str == "CONT"){
	    	sign_flag = "P";   // 계약서 서명은 발주서 임시저장 후 계약서 전자서명
	    }else if(str == "SEND"){
	    	sign_flag = "E";   // 발송
	    }else{
	        sign_flag = "P";   // 결재중(결재상신)
	    }
	
		f0.SIGN_FLAG.value=sign_flag;
		
	
	    var cols_ids = "<%=grid_col_id%>";
	 	var params = "mode=setPoUpdate";
	    params += "&cols_ids="+cols_ids;
	 	params += dataOutput();
	 	
	    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_update" , params);
	   
	    sendTransactionGridPost( GridObj, myDataProcessor, "SEL", grid_array );
	}

	 /**
	  * 계약서 신규작성
	  */
	 function new_cont()
	 {
		window.open("","contractwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
	    
	    document.main.target = 'contractwin';
	    document.main.form_type.value = 'A';
	    document.main.reg_type.value = 'B';
	    document.main.is_offline.value = 'N';
	    document.main._page.value = "";
	    document.main._action.value = "HANDLE";
	    document.main._param.value = "BASIC_CONTRACT_FORM_FILL_HANDLER";
	    
	    document.main.action = "/kr/ctr/pages/selectedRelationFormPopUp.jsp";
	    document.main.submit();
		/*
        window.open("","contractwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
    	document.main.target = 'contractwin';
    	document.main.form_type.value = 'A';
    	document.main.reg_type.value = 'B';
    	document.main.is_offline.value = 'N';
    	//document.main._page.value = "CONTRACT_REGIST";
    	document.main._page.value = "";
    	document.main._action.value = "HANDLE";
       	//document.main._param.value = "ADD_CONTRACT_FORM_FILL_HANDLER";
       	document.main._param.value = "BASIC_CONTRACT_FORM_FILL_HANDLER";
    	
    	document.main.action = "/kr/ctr/Main.jsp";
    	document.main.submit();
    	*/
    }
	
	/**
	 * 계약서 수정
	 */
	function modify_cont()
	{
        window.open("","contractwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
        
    	document.main.target = 'contractwin';
    	document.main.form_type.value = 'A';
    	document.main.is_offline.value = 'N';
    	document.main._page.value = "CONTRACT_READ";//GO_READ
    	document.main._action.value = "HANDLE";
    	document.main._param.value = "CONTRACT_READ_HANDLER";
    	
    	document.main.action = "/kr/ctr/Main.jsp";
    	document.main.submit();
    }

	function clearRow() {
        GridObj.RemoveAllData();
	}

	function PopupManager(part) {
		var url = "";
		var f = document.forms[0];
		//구매담당직무
			
		if(part == "CP_NAME")
		{
			var arrValue = new Array();
			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = "<%=VENDOR_CODE%>";
			PopupCommonArr("SP0273","SP0273_getCode",arrValue,"");
		}
		
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
		//검수담당자
		if(part == "INVOICE_CODE")
		{
			
			var arrValue = new Array();
			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
			arrValue[2] = "P";

			PopupCommonArr("SP0071","getCtrlPerson",arrValue,"");

		}
	}

	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.form1.ctrl_code.value = code;
		document.form1.ctrl_name.value = text;
	}

	//검수담당자
	function getInvoiceManager(code, text)
	{
		document.form1.TAKE_USER_ID.value = code;
		document.form1.TAKE_USER_NAME.value = text;
	}

	//담당자
	function SP0071_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0071&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=P";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function  getCtrlPerson(ls_ctrl_code, ls_ctrl_name, ls_ctrl_person_id, ls_ctrl_person_name) {
		document.forms[0].TAKE_USER_ID.value = ls_ctrl_person_id;
		document.forms[0].TAKE_USER_NAME.value = ls_ctrl_person_name;
	
	}
	
	//공급업체 담당자
	function SP0273_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0273&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=VENDOR_CODE%>";
		var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function  SP0273_getCode(ls_vendor_person_name, ls_vendor_person_mobil, ls_email, ls_dept) {	
		document.forms[0].vendor_person_mobil.value	= ls_vendor_person_mobil;
		document.forms[0].vendor_person_email.value	= ls_email;
		document.forms[0].vendor_person_name.value  = ls_vendor_person_name;
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
	
	// 2011.08.29 HMCHOI
	// 발주서 신규저장 페이지에서 수정페이지를 호출하면 전자계약 수정화면을 POP-UP한다.
<%-- 	function isNewPage() {
		if ("<%=isNewPage%>" == "Y") {
			new_cont();
		}
	} --%>
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
        location.href="po_list.jsp";
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
}function getSumData(){
	var sum_PO_QTY = 0;
	var sum_UNIT_PRICE = 0;
	var sum_ITEM_AMT = 0;
	for(var i = 1 ; i<=GridObj.getRowsNum() ; i++){
		sum_PO_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("PO_QTY")).getValue());
		sum_UNIT_PRICE += Number(GridObj.cells(i,GridObj.getColIndexById("UNIT_PRICE")).getValue());
		sum_ITEM_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("ITEM_AMT")).getValue());
	}
	var nextRowId = GridObj.getRowsNum()+1;
	GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
	GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_NO")).setValue("합계");
	GridObj.cells(nextRowId,GridObj.getColIndexById("PO_QTY")).setValue(sum_PO_QTY);
	GridObj.cells(nextRowId,GridObj.getColIndexById("UNIT_PRICE")).setValue(sum_UNIT_PRICE);
	GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_AMT")).setValue(sum_ITEM_AMT);
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
    
    getSumData();
    return true;
}


</script>
</head>
<body topmargin="0" marginwidth="0" leftmargin="0" onload="javascript:init();">

<s:header>
<!--내용시작-->
<form id="form1" name="form1" method="post">
	<input type="hidden" name="h_po_no"				id="h_po_no">
	<input type="hidden" name="set_company_code" 	id="set_company_code">
	<input type="hidden" name="SHIPPER_TYPE" 		id="SHIPPER_TYPE" 			value="D">
	<input type="hidden" name="po_no" 				id="po_no" 					value="<%=po_no%>">
	<input type="hidden" name="attach_gubun" 		id="attach_gubun" 			value="body">
	<!-- <input type="hidden" name="attach_no" id="ATTACH_NO" > -->
	<input type="hidden" name="attach_count" 		id="attach_count" 			value="">
	<input type="hidden" name="att_mode" 			id="att_mode"  				value="">
	<input type="hidden" name="view_type" 			id="view_type"  			value="">
	<input type="hidden" name="file_type" 			id="file_type"  			value="">
	<input type="hidden" name="PR_TYPE" 			id="PR_TYPE" 				value="<%=PR_TYPE%>">
    <input type="hidden" name="PO_TYPE" 			id="PO_TYPE" 				value="<%=PO_TYPE%>">
    <input type="hidden" name="ORDER_NO"		 	id="ORDER_NO" 				value="<%=ORDER_NO%>" >
	<input type="hidden" name="ORDER_NAME" 			id="ORDER_NAME" 			value="<%=ORDER_NAME%>" >
	<input type="hidden" name="CUR" 				id="CUR" 					value="<%=CUR%>" >
	<input type="hidden" name="PAY_TERMS" 			id="PAY_TERMS" 				value="<%=PAY_TERMS%>" >
	<input type="hidden" name="tmp_att_no" 			id="tmp_att_no" 			value="">
	<input type="hidden" name="CONTRACT_FROM_DATE" 	id="CONTRACT_FROM_DATE" 	value="<%=CONTRACT_FROM_DATE%>" >
	<input type="hidden" name="PAY_TERMS" 			id="PAY_TERMS"  			value="<%=PAY_TERMS%>" >
	<input type="hidden" name="CONTRACT_TO_DATE" 	id="CONTRACT_TO_DATE"  		value="<%=CONTRACT_TO_DATE%>" >
	<input type="hidden" name="SIGN_DATE" 			id="SIGN_DATE"  			value="<%=SIGN_DATE%>" >
	<input type="hidden" name="SIGN_PERSON_ID" 		id="SIGN_PERSON_ID"  		value="<%=SIGN_PERSON_ID%>" >
	<input type="hidden" name="ADD_DATE" 			id="ADD_DATE"  				value="<%=ADD_DATE%>" >
	<input type="hidden" name="ADD_TIME" 			id="ADD_TIME"  				value="<%=ADD_TIME%>" >
	<input type="hidden" name="ADD_USER_ID" 		id="ADD_USER_ID"  			value="<%=ADD_USER_ID%>" >
	<input type="hidden" name="ORIGINAL_SIGN_STATUS"id="ORIGINAL_SIGN_STATUS"	value="<%=ORIGINAL_SIGN_STATUS%>" >
	<input type="hidden" name="CTRL_CODE" 			id="CTRL_CODE"  			value="<%=CTRL_CODE%>" >
	<input type="hidden" name="VENDOR_EMAIL" 		id="VENDOR_EMAIL"  			value="<%=VENDOR_EMAIL%>" >
	<input type="hidden" name="SIGN_FLAG" 			id="SIGN_FLAG" 				value=""  >
	
	<input type="hidden" name="VENDOR_CODE" 		id="VENDOR_CODE"  			value="<%=VENDOR_CODE%>" >
	<input type="hidden" name="REMARK" 				id="REMARK"  				value="<%=REMARK%>" >
	
	<input type="hidden" name="dely_terms" 			id="dely_terms"  			value="" >
 	<input type="hidden" name="PAY_TERMS" 			id="PAY_TERMS"  			value="<%=PAY_TERMS%>" >
	<input type="hidden" name="CTR_NO" 				id="CTR_NO"  				value="<%=CTR_NO%>" >
	<input type="hidden" name="CTR_DATE" 			id="CTR_DATE"  				value="<%=CTR_DATE%>" >
	<input type="hidden" name="PR_TYPE" 			id="PR_TYPE"  				value="<%=PR_TYPE%>" >

	<input type="hidden" name="PO_AMT_KRW" 			id="PO_AMT_KRW"  			value="<%=PO_AMT_KRW%>" >
	

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
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주번호</td>
      							<td width="30%" class="data_td">
      								<input type="text" id="PO_NO" name="PO_NO" style="width:92%" value="<%=po_no%>" readOnly  style="width:92%; border:0">
      							</td>
      							<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주명</td>
      							<td width="30%" class="data_td" >
      								<input type="text" name="SUBJECT" id="SUBJECT" style="width:92%" value="<%=SUBJECT%>" class="input_re" style="ime-mode:disabled" onkeyup="chkMaxByte(500, this, '발주명')" >
      							</td>
    						</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>  	     						
    						<tr>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주업체</td>
      							<td class="data_td">
      								<%=VENDOR_CODE%> / <%=VENDOR_NAME%>
      							</td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주일자</td>
        						<td class="data_td"><%=SepoaString.getDateSlashFormat(ADD_DATE)%></td>  
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주업체담당자</td>
      							<td class="data_td">
            						담당자 : <input type="text" name="vendor_person_name" size="20" id="VENDOR_CP_NAME" class="input_re"  value="<%=VENDOR_CP_NAME%>" 	>
        							<a href="javascript:PopupManager('CP_NAME')" readOnly ><img src="/images/icon/icon_search.gif" align="absmiddle" border="0" ></a>
        							<br>핸드폰 : <input type="text" name="vendor_person_mobil" size="20" id="VENDOR_MOBILE_NO" class="input_re" value="<%=VENDOR_MOBILE_NO%>" style="ime-mode:disabled" onkeypress="checkNumberFormat('[0-9]', this)" onkeyup="chkMaxByte(30, this, '핸드폰')">
        							<br>이메일 : <input type="text" name="vendor_person_email" size="20" 	class="input_re" value="<%=VENDOR_EMAIL%>" onblur="checkMail(this)" >
      							</td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주금액(VAT 포함)</td>
      							<td class="data_td">
      								<input type="text" name="EXEC_AMT_KRW" id="EXEC_AMT_KRW" style="width:92%" value="<%=EXEC_AMT_KRW%>" readOnly  style="border:0">
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급조건</td>
      							<td class="data_td"><%=PAY_TERMS_DESC%></td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인도조건</td>
      	 						<td class="data_td"><%=dely_terms %></td> 
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr> 
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수담당자</td>
      							<td class="data_td">
									<input type="text" name="TAKE_USER_ID" id="TAKE_USER_ID" style="width:25%" value="<%=TAKE_USER_ID%>" class="input_re" readOnly >
									<a href="javascript:PopupManager('INVOICE_CODE')"><img src="/images/icon/icon_search.gif" align="absmiddle" border="0"></a>
									<input type="text" name="TAKE_USER_NAME" id="TAKE_USER_NAME" style="width:52%"  value="<%=TAKE_USER_NAME%>" readOnly>
      							</td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수자연락처</td>
      							<td class="data_td">
      								<input type="text" name="TAKE_TEL" id="TAKE_TEL" style="width:40%; ime-mode:disabled" value="<%=TAKE_TEL%>" class="inputsubmit" onkeypress="checkNumberFormat('[0-9]', this)" onkeyup="chkMaxByte(30, this, '검수자연락처')" >
      							</td>	
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당직무 </td>
      							<td class="data_td" >
									<input type="text" name="ctrl_code" id="ctrl_code" size="10"   readOnly value="<%=info.getSession("CTRL_CODE")%>"  class="input_re" >
									<a href="javascript:PopupManager('CTRL_CODE')"><img src="/images/icon/icon_search.gif" align="absmiddle" border="0"></a>
									<input type="text" name="ctrl_name" id="ctrl_name" size="20"  value="" readOnly>
	        						<input type="hidden" name="ctrl_person_id" id="ctrl_person_id">
    	    						<input type="hidden" name="ctrl_person_name" id="ctrl_person_name">
      							</td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지체상금율</td>
      	 						<td class="data_td"><%=delay_remark  %></td> 
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 하자이행 보증기간</td>
      							<td class="data_td">검수일로부터 ( <%=warranty_month%> )개월</td>
      							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 계약일반사항</td>
      							<td class="data_td">
		 							선급금보증&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=first_percent%>%<br>
									계약이행보증&nbsp;&nbsp;<%=contract_percent%>%<br>
									하자이행보증&nbsp;&nbsp;<%=mengel_percent%>%<br> 
      							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
    						<tr>
    							<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
    							<td class="data_td" colspan="3">
									<textarea name="REMARK" style="width:97%" rows="5"  class="inputsubmit"><%=REMARK%></textarea>
    							</td>
    						</tr>
    						<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
								<td class="data_td" colspan="3" height="150">
									<table border="0" style="padding-top: 10px; width: 100%;">
										<tr>
											<td>
												<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 90px; border: 0px;" frameborder="0" ></iframe>
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

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td height="30" align="right">
			<TABLE cellpadding="0">
		    	<TR>
    				<%if(!"E".equals(ORIGINAL_SIGN_STATUS)){%>
    				<TD><script language="javascript">btn("javascript:approval('SAVE')","임시저장")</script></TD>
    				<%}%>
    				<!-- 발주서에 대한 전자계약여부가 Y인 경우 [발송]을 하면 전자계약서 화면이 팝업되도록 한다.-->
    				<%if(po_contract_use_flag){%>
		      		<TD><script language="javascript">btn("javascript:approval('CONT')","업체발송")</script></TD>
    				<%} else {%>
					<%if (sign_use_yn) {%>
					<TD><script language="javascript">btn("javascript:approval('SIGN')","결재요청") </script></TD>
					<%} else {%>
					<TD><script language="javascript">btn("javascript:approval('SEND')","업체발송") </script></TD>
					<%}%>
    				<%}%>
    				<TD><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></TD>
				</TR>
      		</TABLE>
      	</td>
    </tr>
</table>
	


</form>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>

</s:header>
<s:grid screen_id="PO_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','R','PO',form1.attach_no.value);</script>
 --%>
<!-- 전자계약 화면이동 시작 -->
<form name="main" method="post">
	<input type="hidden" name="_page">
	<input type="hidden" name="_action">
	<input type="hidden" name="_param">
	
	<input type="hidden" name="is_offline">
	<input type="hidden" name="form_type">
	<input type="hidden" name="reg_type">
	<input type="hidden" name="form_seq" value="<%=form_seq%>">
	
	<!-- 발주 및 업체번호 -->
	<input type="hidden" name="bid_no" value="<%=po_no%>">
	<input type="hidden" name="vendor_code" value="<%=VENDOR_CODE%>">
	
	<!-- 계약번호 및 계약차수 -->
	<input type="hidden" name="cont_seq" value="<%=cont_seq%>">
	<input type="hidden" name="cont_count" value="<%=cont_count%>">
</form>
<!-- 전자계약 화면이동 종료 -->




