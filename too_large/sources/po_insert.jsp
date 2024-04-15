<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%-- <%@ include file="/include/wisehub_common.jsp"%> --%>
<%-- <% String WISEHUB_PROCESS_ID="PO_004";%> --%>
<!-- 2011-03-08 solarb 발주 생성-->

<%-- <%@ include file="/include/wisehub_session.jsp" %> --%>


<!-- 2011-03-09 계약일반 사항 data 가져오는 부분 -->
<%
    String inv_no 	= JSPUtil.nullToEmpty(request.getParameter("EXEC_NO"));
	
    Object[] obj 	= {inv_no};
    SepoaOut value 	= ServiceConnector.doService(info, "PO_001", "CONNECTION", "getPoInsertInfo", obj);
    SepoaFormater wf = new SepoaFormater(value.result[0]);
    String dely_terms_name = "";
    String dely_terms = "";
    String delay_remark = "";
    String warranty_month = "";
    String first_percent = "";
    String contract_percent = "";
    String mengel_percent = "";
    if(wf.getRowCount() > 0) {
    	dely_terms_name = wf.getValue("DELY_TERMS_NAME", 0);
    	dely_terms = wf.getValue("DELY_TERMS", 0);
    	delay_remark = wf.getValue("DELAY_REMARK", 0);
    	warranty_month = wf.getValue("WARRANTY_MONTH", 0);
    	first_percent = wf.getValue("FIRST_PERCENT", 0);
    	contract_percent = wf.getValue("CONTRACT_PERCENT", 0);
    	mengel_percent = wf.getValue("MENGEL_PERCENT", 0);
    }
%>

<%
    String user_id        		= info.getSession("ID");
    String house_code     		= info.getSession("HOUSE_CODE");
    String company_code   		= info.getSession("COMPANY_CODE");
    String ctrl_code      		= info.getSession("CTRL_CODE");
    String user_name	 		= info.getSession("NAME_LOC");
    String toDaysSo       		= SepoaDate.getShortDateString();
    String toDays         		= SepoaDate.getFormatString("yyyy/MM/dd");
	String VENDOR_CODE			= JSPUtil.nullToEmpty(request.getParameter("VENDOR_CODE"		));
	String VENDOR_NAME			= JSPUtil.nullToEmpty(request.getParameter("VENDOR_NAME"		));
	String SUBJECT				= JSPUtil.nullToEmpty(request.getParameter("SUBJECT"			));
	String CTRL_CODE			= JSPUtil.nullToEmpty(request.getParameter("CTRL_CODE"			));
	String PAY_TERMS			= JSPUtil.nullToEmpty(request.getParameter("PAY_TERMS"			));
	String PAY_TERMS_DESC		= JSPUtil.nullToEmpty(request.getParameter("PAY_TERMS_DESC"		));
	String PR_TYPE				= JSPUtil.nullToEmpty(request.getParameter("PR_TYPE"			));
	String PR_TYPE_CODE			= JSPUtil.nullToEmpty(request.getParameter("PR_TYPE_CODE"		));
	String ORDER_NO				= JSPUtil.nullToEmpty(request.getParameter("ORDER_NO"			));
	String ORDER_NAME			= JSPUtil.nullToEmpty(request.getParameter("ORDER_NAME"			));
	String CUR					= JSPUtil.nullToEmpty(request.getParameter("CUR"				));
	String EXEC_AMT_KRW			= JSPUtil.nullToEmpty(request.getParameter("EXEC_AMT_KRW"		));
	String TAKE_USER_NAME		= JSPUtil.nullToEmpty(request.getParameter("TAKE_USER_NAME"		));
	String TAKE_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("TAKE_USER_ID"		));
	String CTR_DATE				= JSPUtil.nullToEmpty(request.getParameter("CTR_DATE"			));
	String TAKE_TEL				= JSPUtil.nullToEmpty(request.getParameter("TAKE_TEL"			));
	String REMARK				= JSPUtil.nullToEmpty(request.getParameter("REMARK"				));
	String EXEC_NO				= JSPUtil.nullToEmpty(request.getParameter("EXEC_NO"			));
	String CTR_NO				= JSPUtil.nullToEmpty(request.getParameter("CTR_NO"				));
	String CONTRACT_FROM_DATE	= JSPUtil.nullToEmpty(request.getParameter("CONTRACT_FROM_DATE"	));
	String CONTRACT_TO_DATE		= JSPUtil.nullToEmpty(request.getParameter("CONTRACT_TO_DATE"	));
	String SIGN_PERSON_ID		= JSPUtil.nullToEmpty(request.getParameter("SIGN_PERSON_ID"		));
	String PO_TYPE				= JSPUtil.nullToEmpty(request.getParameter("PO_TYPE"			));
	String SHIPPER_TYPE			= JSPUtil.nullToEmpty(request.getParameter("SHIPPER_TYPE"		));
	String DP_PAY_TERMS			= JSPUtil.nullToEmpty(request.getParameter("DP_PAY_TERMS"		));
	String PO_DIV_FLAG			= JSPUtil.nullToEmpty(request.getParameter("PO_DIV_FLAG"		));
	String ADD_USER_ID			= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_ID"		));
	String ADD_USER_NAME		= JSPUtil.nullToEmpty(request.getParameter("ADD_USER_NAME"		));	

	String vncp_user_name		= JSPUtil.nullToEmpty(request.getParameter("vncp_user_name"		));
	String vncp_mobile_no		= JSPUtil.nullToEmpty(request.getParameter("vncp_mobile_no"		).replaceAll("-",""));
	String vncp_email			= JSPUtil.nullToEmpty(request.getParameter("vncp_email"		));
	String EXEC_SEQ			    = JSPUtil.nullToEmpty(request.getParameter("EXEC_SEQ"		));
	String EXEC_NUMBER			= JSPUtil.nullToEmpty(request.getParameter("EXEC_NUMBER"			));
    //Logger.debug.println("-----------------> " + EXEC_SEQ);
	String PURCHASER_ID = JSPUtil.nullToEmpty(request.getParameter("PURCHASER_ID"));
	String PURCHASER_NAME = JSPUtil.nullToEmpty(request.getParameter("PURCHASER_NAME"));
    
    String POPUP_FLAG		= JSPUtil.nullToEmpty(request.getParameter("POPUP_FLAG"		));
	String strShipperType = "";

	SepoaListBox LB = new SepoaListBox();
	String COMBO_M004     	= LB.Table_ListBox(request, "SL0022", house_code+"#M187#", "&" , "#");


	if ((SHIPPER_TYPE.equals(""))) {
		SHIPPER_TYPE = "D";
	}

    String LB_I_PAY_TERMS 	= ListBox(request, "SL0127",  house_code+"#M010#"+SHIPPER_TYPE+"#", DP_PAY_TERMS);

	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 번호를 가져와서 작성/수정여부판단
	String cont_seq 	= ""; // 전자계약번호
	String cont_count 	= ""; // 전자계약차수
	String form_seq 	= "0"; // 서식번호
	
	// 2011.07.28 HMCHOI 작성
	// 발주서 생성 및 수정시 전자계약서 작성 사용여부
	// wise.properties의 wise.po.contract.use.#HOUSE_CODE# = true/false 에 따라 옵션으로 진행한다.
	Config wise_conf = new Configuration();
	boolean po_contract_use_flag = false;
	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = false;
	try {
		po_contract_use_flag = wise_conf.getBoolean("sepoa.po.contract.use." + info.getSession("HOUSE_CODE")); //발주 전자계약 사용여부
		form_seq = wise_conf.getString("sepoa.po.contract.form." + info.getSession("HOUSE_CODE")); //발주 전자계약 DEFAULT FORM_SEQ
		sign_use_module = wise_conf.get("sepoa.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch (Exception e) {
		po_contract_use_flag = false;
		form_seq = "0";
		sign_use_module	= "";
	}
	
	String sign_po_type = "";
	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	
	//PR;MEX;BD;BREX;EEX;MPO;DPO;IV;CT
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
			} else if (sign_po_type.equals("EPO")||sign_po_type.equals("FPO")) { // 기안/종가발주
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
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

var pr_type = "<%=PR_TYPE_CODE%>";
var G_CUR_ROW = -1;

var mode;
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";

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
var IDX_DELY_TO_ADDRESS		;
var IDX_ORDER_NO;
var IDX_ORDER_SEQ;
var IDX_ORDER_COUNT;

	function init() {
		document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
		setGridDraw();
		setHeader();
	}

	function setHeader() {
		bCellPasteDownMenuVisible = true;
		var itemsize 	= 100;
		var servicesize = 0;
		var item_no			 = "품목";
		var description_loc  = "품목명";
		var po_qty           = "수량";
		var dely_to_location = "납품장소";


		
		//GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
		//GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd");
		//GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
		
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
	    IDX_DELY_TO_ADDRESS		= GridObj.GetColHDIndex("DELY_TO_ADDRESS");
	    IDX_EXEC_NO				= GridObj.GetColHDIndex("EXEC_NO"			);
	    IDX_ORDER_NO 			= GridObj.GetColHDIndex("ORDER_NO");
	    IDX_ORDER_SEQ 			= GridObj.GetColHDIndex("ORDER_SEQ");
	    IDX_ORDER_COUNT			= GridObj.GetColHDIndex("ORDER_COUNT");
	    IDX_WBS_NO 				= GridObj.GetColHDIndex("WBS_NO");
	    IDX_WBS_SUB_NO 			= GridObj.GetColHDIndex("WBS_SUB_NO");
	    IDX_WBS_TXT 			= GridObj.GetColHDIndex("WBS_TXT");
	    /*
	    IDX_INVEST_NO = GridObj.GetColHDIndex("INVEST_NO");
	    IDX_INVEST_NO_TEXT = GridObj.GetColHDIndex("INVEST_NO_TEXT");
	    IDX_INVEST_SUB_NO = GridObj.GetColHDIndex("INVEST_SUB_NO");
	    IDX_KTOGR = GridObj.GetColHDIndex("KTOGR");
	    IDX_AKTIV = GridObj.GetColHDIndex("AKTIV");
	    IDX_TXT50 = GridObj.GetColHDIndex("TXT50");
	    GridObj.AddComboListValue('MWSKZ', '선택', '');
	    IDX_BSART = GridObj.GetColHDIndex("BSART");
	    IDX_KNTTP = GridObj.GetColHDIndex("KNTTP");
	    IDX_KNTTP_TEXT = GridObj.GetColHDIndex("KNTTP_TEXT");
	    IDX_MWSKZ = GridObj.GetColHDIndex("MWSKZ");
	    IDX_ZEXKN = GridObj.GetColHDIndex("ZEXKN");
	    */
	    doQuery();
	}
	function doQuery()
	{
		var url ="<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert";
		var param ="mode=getPoInsert&grid_col_id="+grid_col_id;
		/* mode = "getPoInsert";
		GridObj.SetParam("mode", mode); */
		<%-- GridObj.SetParam("VENDOR_CODE", "<%=VENDOR_CODE%>");
		GridObj.SetParam("exec_no","<%=EXEC_NO%>");
		GridObj.SetParam("exec_no","<%=EXEC_NO%>");
		GridObj.SetParam("PO_DIV_FLAG","<%=PO_DIV_FLAG%>"); --%>
		GridObj.SetParam("combo", "<%=COMBO_M004%>");
		GridObj.SetParam("PR_TYPE_CODE","<%=PR_TYPE_CODE%>");
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		/* var exec_no= */
		/* GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; */
		param+="&exec_no=<%=EXEC_NO%>";
		param+="&VENDOR_CODE=<%=VENDOR_CODE%>";
		param+="&PO_DIV_FLAG=<%=PO_DIV_FLAG%>";
		param+="&exec_seq=<%=EXEC_SEQ%>";
		param+="&exec_number=<%=EXEC_NUMBER%>";
		param += dataOutput();
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
				if (mode == "P" && status == "1" && new_po_no != "") {
			    	location.href = "po1_bd_upd1.jsp?po_no="+new_po_no+"&isNewPage=Y";
				}
				// 임시저장(T) 및 업체발송(E)이 완료되면 발주대기로 화면이동
				if ((mode == "T" || mode == "E") && status == "1") {
					alert(GridObj.GetMessage());
					location.href="po7_bd_lis1.jsp";
				}
        	} else {
// 				var mode 	= GD_GetParam(GridObj,0);
// 				var status 	= GD_GetParam(GridObj,1);
				
// 				alert(GridObj.GetMessage());
// 				if(status != "0") {
// 					location.href = "po7_bd_lis1.jsp";
// 				}
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
                window.open("/kr/dt/app/app_bd_ins1.jsp?exec_no="+msg5+ "&pr_type=I&editable=N&req_type=P","execwin","left=0,top=0,width=1024,height=768,resizable=yes,scrollbars=yes, status=yes");
			//}else if(msg3 == IDX_INVEST_NO_TEXT) {
			//    var exec_no = GD_GetCellValueIndex(GridObj,msg2, IDX_EXEC_NO);
			//	window.open("/kr/order/bpo/po1_invest_pp_lis1.jsp?cur_row="+G_CUR_ROW,"execwin","left=0,top=0,width=1024,height=500,resizable=yes,scrollbars=yes, status=yes");
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
				GD_SetCellValueIndex(GridObj,msg2,IDX_ITEM_AMT, setAmt(ttl_amt)); // 절삭
				setTotalAmount();
            }
		} else if(msg1 == "t_header") {
			if(msg3 == IDX_RD_DATE) {
				copyCell(GridObj, IDX_RD_DATE, "t_date");
			}
		} else if(msg1 == "doQuery") {
			var rowCount = GridObj.GetRowCount();
			var exec_amt_krw = 0;
			var po_amt_kwr = 0;
			
			if(msg3 == IDX_UNIT_PRICE||msg3 == IDX_PO_QTY) {
        		calculate_po_qty(GridObj, msg2);
				calculate_po_amt(GridObj, msg2);
			}
			/* if(summaryCnt == 0) {
				GridObj.AddSummaryBar('SUMMARY1', '합 계', 'summaryall', 'sum', 'PO_QTY,ITEM_AMT');
                GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
                summaryCnt++;
			} */
			for( i = 0 ; i < rowCount ; i++){
				if("KRW" != GridObj.GetCellValue("CUR",i)){
					exec_amt_krw = parseInt(GridObj.GetCellValue("ITEM_AMT",i)*100)*parseInt(GridObj.GetCellValue("EXCHANGE_RATE"	,i))/100;
					GridObj.SetCellValue("EXEC_AMT_KRW", i, exec_amt_krw);
					po_amt_kwr += exec_amt_krw;
				}else{
					po_amt_kwr += parseInt(GridObj.GetCellValue("ITEM_AMT",i));
				}

			}
			document.forms[0].PO_AMT_KRW.value = po_amt_kwr;
		}
	}
	
	/**
	 * 품목별 발주 수량을 계산한다.
     */
	function calculate_po_qty(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	GD_SetCellValueIndex(GridObj,row, IDX_PO_QTY, RoundEx(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY), 3));
    	//GD_SetCellValueIndex(GridObj,row, IDX_PO_QTY, setAmt(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)));
  	}
	
	/**
	 * 품목별 발주 금액을 계산한다.
     */
	function calculate_po_amt(wise, row)
  	{
  		// 소숫점 두자리까지 계산
    	var ITEM_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)) *  getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
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

	function approval(set) {
	    divStatus = set;
	    var f0 = document.forms[0];

	    var rowcount = GridObj.GetRowCount();
	    var knttp;
	    var invest_no;
	    var invest_sub_no;
	    
	    if(f0.SUBJECT.value == ""){
	    	alert("발주명은 필수입력사항입니다.");
	    	return;
	    }
	    if(f0.ctrl_code.value == ""){
	    	alert("구매담당직무는 필수 입력사항입니다.");
	    	return;
	    }
	    if(f0.TAKE_USER_ID.value == ""){
	    	alert("검수담당자는 필수 입력사항입니다.");
	    	return;
	    }
	    if(f0.pay_terms.value == ""){
	    	alert("지급 조건은 필수 입력사항입니다.");
	    	return;
	    }
	    if(chkMaxByte(30, f0.TAKE_TEL, "검수자연락처", "") == false){
	    	return;
	    }
	    f0.VENDOR_CODE.value = f0.VENDOR_CODE.value.toUpperCase();
	    f0.PO_NO.value       = f0.PO_NO.value.toUpperCase();
        var vendor_person_name = f0.vendor_person_name.value;
        var vendor_person_mobil= f0.vendor_person_mobil.value;
        var vendor_person_email= f0.vendor_person_email.value;

        if(vendor_person_mobil == "" || vendor_person_name == "" || vendor_person_email == ""){
        	alert("발주업체담당자를 입력해 주세요.");
        	return;
        }
        var re = /[^0-9]/i;
        if(re.test(vendor_person_mobil)){
        	alert("핸드폰은 숫자만 입력가능합니다.");
        	return;
        }
        re=/^[0-9a-z]([-_\.]?[0-9a-z])*@[0-9a-z]([-_\.]?[0-9a-z])*\.[a-z]{2,3}$/i;
	    if(!re.test(vendor_person_email)) {
			alert("이메일이 잘못되었습니다.");
            return;
	    }
	    if(set != "COMP" && saveRock==true){
	        alert("해당하는 품목코드에 대해 이미 발주가 생성되었습니다");
			return;
	    }
		/*
	    if(saveRock == true){
	        alert("해당하는 품번에 대해 이미 발주가 생성되었습니다.");
	        return;
	    }
		*/
	    if(chkMaxByte(500, f0.REMARK, "비고", "") == false){
	    	return;
	    }
	    var checked_count = 0;
	    var qtyChk = true;
	    var rdChk = true;
	    var unitPriceChk = true;
	    var orderNO = true;
	    var orderSeq = true;
	    var orderCnt = true;
	    var delyCnt = true;
	    var delyCdCnt = true;

	    var tmp_ctrl_code = "";
	    for(row=0; row < rowcount; row++) {
	        if("1" == GD_GetCellValueIndex(GridObj,row, IDX_SEL)) {
	            checked_count ++;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_PO_QTY)=="")
	                qtyChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_RD_DATE)=="")
	                rdChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)=="")
	                unitPriceChk = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_ORDER_NO)=="")
	                orderNO = false;
	            if(GD_GetCellValueIndex(GridObj,row,IDX_ORDER_SEQ)=="")
                    orderSeq = false;
                if(GD_GetCellValueIndex(GridObj,row,IDX_ORDER_COUNT)=="")
                    orderCnt = false;
                if(GD_GetCellValueIndex(GridObj,row,IDX_DELY_TO_ADDRESS)=="")
                	delyCnt = false;
                if(GD_GetCellValueIndex(GridObj,row,IDX_DELY_TO_LOCATION)==""){
                	delyCdCnt = false;
                }
	        }
	    }
	    
	    if(checked_count < 1){
	        alert(G_MSS1_SELECT);
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
	    if(!rdChk && pr_type=="I"){
	        alert("납기요청일은 필수입력사항입니다.");
	        return;
	    }
	    if(!delyCnt){
	        alert("납품장소는 필수입력사항입니다.");
	        return;
	    }
	    if(!delyCdCnt){
	        alert("납품장소를 선택하여 주세요.");
	        return;
	    }
	    if(f0.PO_TYPE.value == ""){
	    	alert("발주구분을 선택해주세요.");
	    	return;
	    }
	    var setCnt = 0;
	    for(var c=0; c<rowcount; c++)
	        if("true" == GD_GetCellValueIndex(GridObj,c, IDX_SEL))
	            setCnt ++;

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

	function getApproval(approval_str){
	    if(approval_str == '') return;

	    saveRock = true;

		document.forms[0].approval_str.value = approval_str;
		getApprovalSend(approval_str);
		/* document.attachFrame.setData(); */	//startUpload
	}

	function getApprovalSend(approval_str) {
	    var f0 = document.forms[0];
	    
	    var VENDOR_CODE =  f0.VENDOR_CODE.value;
	    var PO_NO       =  f0.PO_NO.value;
	    var CUR         =  f0.CUR.value;
	    var TTL_AMT     =  del_comma(f0.EXEC_AMT_KRW.value);
	    var REMARK		=  f0.REMARK.value;
	    f0.CTRL_CODE.value="<%=CTRL_CODE%>";
	    if (PO_NO == "") PO_NO="xp";
	    f0.PO_NO.value=PO_NO;
	    f0.CONTRACT_FLAG.value=GridObj.GetCellValue("CONTRACT_FLAG", 0);
	    f0.TTL_AMT.value=TTL_AMT;
	    f0.DELY_TERMS.value="<%=dely_terms%>";
	    f0.SIGN_PERSON_ID.value="<%=SIGN_PERSON_ID%>";
	    
	    
		<%-- 
		GridObj.SetParam("PO_NO"          	,PO_NO							);
	    GridObj.SetParam("VENDOR_CODE"		,VENDOR_CODE					);
	    GridObj.SetParam("CUR"            	,CUR							);
	    GridObj.SetParam("TTL_AMT"        	,TTL_AMT						);
	    GridObj.SetParam("REMARK"         	,f0.REMARK.value				);
	    GridObj.SetParam("COMPANY_CODE"   	,"<%=company_code%>"			);
	    GridObj.SetParam("DELY_TERMS"     	,"<%=dely_terms%>"				);
	    GridObj.SetParam("PAY_TERMS"      	,f0.pay_terms.value				);
   	    GridObj.SetParam("ACCOUNT_TYPE"   	," "							);
   	    GridObj.SetParam("ORDER_NO"   		,f0.ORDER_NO.value				);
   	    GridObj.SetParam("ORDER_NAME"   		,"<%=ORDER_NAME%>"				);
		GridObj.SetParam("PR_TYPE"			,"<%=PR_TYPE%>"					);
		GridObj.SetParam("ctrl_code"			,f0.ctrl_code.value				);
		GridObj.SetParam("SUBJECT"			,f0.SUBJECT.value				);
		GridObj.SetParam("ctrl_person_id"		,f0.ctrl_person_id.value		);
		GridObj.SetParam("TAKE_USER_NAME" 	,f0.TAKE_USER_NAME.value			);
		GridObj.SetParam("TAKE_USER_ID" 		,f0.TAKE_USER_ID.value			);
		GridObj.SetParam("TAKE_TEL"			,f0.TAKE_TEL.value				);
		GridObj.SetParam("VENDOR_CP_NAME"  	,f0.vendor_person_name.value	);
		GridObj.SetParam("VENDOR_MOBILE_NO"	,f0.vendor_person_mobil.value	);
		GridObj.SetParam("VENDOR_EMAIL"		,f0.vendor_person_email.value	);
		GridObj.SetParam("PO_TYPE"			,f0.PO_TYPE.value				);
		GridObj.SetParam("CONTRACT_FROM_DATE" ,"<%=CONTRACT_FROM_DATE%>"		);
		GridObj.SetParam("CONTRACT_TO_DATE"	,"<%=CONTRACT_TO_DATE%>"		);
		GridObj.SetParam("SIGN_PERSON_ID"		,"<%=SIGN_PERSON_ID%>"			);
		GridObj.SetParam("PO_AMT_KRW"			,f0.PO_AMT_KRW.value			);
		GridObj.SetParam("ADD_USER_ID"		,"<%=ADD_USER_ID%>"				);	
		GridObj.SetParam("ADD_USER_NAME"		,"<%=ADD_USER_NAME%>"			);
		GridObj.SetParam("CTR_NO"				,""				);
		GridObj.SetParam("CTR_DATE"			,""				);
		GridObj.SetParam("attach_no"			,f0.attach_no.value				);
		GridObj.SetParam("CONTRACT_FLAG"		,GridObj.GetCellValue("CONTRACT_FLAG", 0)); --%>
	

	    var sign_flag = "";
	    // 2011.07.28 HMCHOI 추가
	    // 계약서 팝업을 보여주는 경우에는 화면을 임시저장 후 계약서 팝업을 보여주도록 한다.
	    // 계약서 팝업에서 서명완료가 되면 parent.getApproval("SEND");를 호출하여 발송처리
	    if (approval_str == "SAVE"){
	        sign_flag = "T";   // 저장
	    }else if(approval_str == "CONT"){
	    	sign_flag = "P";   // 계약서 서명은 발주서 임시저장 후 계약서 전자서명
	    }else if(approval_str == "SEND"){
	    	sign_flag = "E";   // 발송
	    }else{
	        sign_flag = "P";   // 결재중(결재상신)
	    }
	    f0.SIGN_FLAG.value=sign_flag;
	    
	    
	    <%-- GridObj.SetParam("SIGN_FLAG",	sign_flag);
	    GridObj.SetParam("APPROVAL",	approval_str);
		GridObj.SetParam("CTRL_CODE",	"<%=CTRL_CODE%>"); --%>
		var params ="mode=setPoInsert&cols_ids="+grid_col_id;
		params+=dataOutput();
		<%-- var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert";
		params += dataOutput();
		GridObj.post(url, params);
	 	GridObj.clearAll(false); --%>
		/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); */
	 	<%-- var cols_ids = "<%=grid_col_id%>";--%>
	 	for(var i = 1; i <= GridObj.getRowsNum(); i++)
		{
			GridObj.cells(i, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
		}
	 	var grid_array = getGridChangedRows(GridObj, "SEL");
	 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.po_insert",params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
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
   	}
	 
	function clearRow() {
        GridObj.RemoveAllData();
	}
	
	function PopupManager(part) {
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
		if(part=="vendor"){
			var arrValue = new Array();
			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = "<%=VENDOR_CODE%>";
			PopupCommonArr("SP0273","SP0273_getCode",arrValue,"");
		}
		if(part == "CTRL_PERSON")
		{
			var arrValue = new Array();
			var arrDesc = new Array();

			arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
			arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
			arrValue[2] = "";
			arrValue[3] = "";
			
			arrDesc[0] = "코드";
			arrDesc[1] = "설명";

			PopupCommonArr("SP9114","SP9114_getCode",arrValue,arrDesc);
		}
		if(part == "DELY_TO_ADDRESS_GRID"){
	    	window.open("/common/CO_009.jsp?callback=getDemandGrid", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=750,height=550,left=0,top=0");
		}
	}
	function  SP9114_getCode(code, text1, text2, text3, text4) {
		document.form1.TAKE_USER_ID.value = code;
		document.form1.TAKE_USER_NAME.value = text1;
		document.form1.TAKE_TEL.value = text2;
		
		if ( confirm("검수자의 배송지 주소로 납품주소를 변경하시겠습니까?") ) {
			for(var i=0;i<document.GridObj.GetRowCount();i++) {
				GD_SetCellValueIndex(document.GridObj,i, IDX_DELY_TO_ADDRESS, text3);
				GD_SetCellValueIndex(document.GridObj,i, IDX_DELY_TO_ADDRESS, text3);
			}
		}	
	}
	
	function  SP0273_getCode(ls_vendor_person_name, ls_vendor_person_mobil, ls_email) {
		document.forms[0].vendor_person_mobil.value	= ls_vendor_person_mobil;
		document.forms[0].vendor_person_email.value = ls_email;
		document.forms[0].vendor_person_name.value  = ls_vendor_person_name;
	}
	
	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.form1.ctrl_code.value = code;
		document.form1.ctrl_name.value = text;
	}
	
	function getDemandGrid(code, text, addr){
		GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("DELY_TO_LOCATION"), code);
		//GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("DELY_TO_ADDRESS"), text);
		GD_SetCellValueIndex(GridObj, G_CUR_ROW, GridObj.getColIndexById("DELY_TO_ADDRESS"),"["+ text + "] " + addr);
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
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP9114&function=D&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function  SP9114_getCode(code, text1, text2, text3, text4) {
	document.form1.TAKE_USER_ID.value = code;
	document.form1.TAKE_USER_NAME.value = text1;
	document.form1.TAKE_TEL.value = text2;
	
	if ( confirm("검수자의 배송지 주소로 납품주소를 변경하시겠습니까?") ) {
		for(var i=0;i<GridObj.GetRowCount();i++) {
				GD_SetCellValueIndex(GridObj,i, IDX_DELY_TO_ADDRESS , text3);
				GD_SetCellValueIndex(GridObj,i, IDX_DELY_TO_LOCATION, text4);
			}
		}	
	//form1.ctrl_code.value = ls_ctrl_code;
	//form1.ctrl_name.value = ls_ctrl_name;
	//form1.ctrl_person_id.value = ls_ctrl_person_id;
	//form1.ctrl_person_name.value = ls_ctrl_person_name;
}
//발주업체 담당자
<%-- function SP0273_Popup() {
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
} --%>

/* function  SP0273_getCode(ls_vendor_person_name, ls_vendor_person_mobil, ls_email) {
	document.forms[0].vendor_person_mobil.value	= ls_vendor_person_mobil;
	document.forms[0].vendor_person_email.value = ls_email;
	document.forms[0].vendor_person_name.value  = ls_vendor_person_name;
} */

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

	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "wise"){
			GD_SetCellValueIndex(GridObj, Arow, INDEX_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    var approval_str = f.approval_str.value;
		    getApprovalSend(approval_str);
		}
	}
	function save(){
		alert("준비중입니다");
	}
	function getSumData(){
		var i_PO_QTY = 0;
		var i_UNIT_PRICE = 0;
		var i_ITEM_AMT = 0; 
		var sum_PO_QTY = 0;
		var sum_UNIT_PRICE = 0;
		var sum_ITEM_AMT = 0; 
		//alert(GridObj.getRowsNum())
		for(var i = 1 ; i<=GridObj.getRowsNum() ; i++){
			
			i_PO_QTY = Number(GridObj.cells(i,GridObj.getColIndexById("PO_QTY")).getValue());
			i_UNIT_PRICE = Number(GridObj.cells(i,GridObj.getColIndexById("UNIT_PRICE")).getValue());
			i_ITEM_AMT = i_PO_QTY * i_UNIT_PRICE;
			sum_ITEM_AMT += i_PO_QTY * i_UNIT_PRICE;
			GridObj.cells(i,GridObj.getColIndexById("ITEM_AMT")).setValue(i_ITEM_AMT);
		}
		document.forms[0].EXEC_AMT_KRW.value = add_comma(sum_ITEM_AMT);
	}
	
	function checkNumberFormat(sFilter, obj) {

		var sKey = String.fromCharCode(event.keyCode);
		var re = new RegExp(sFilter);

		if(sKey != "\r" && !re.test(sKey)) {
			event.returnValue = false;
		}
	}

	function add_comma(input, num)
	{
	    var output = "";
	    var output1 = "";
	    var output2 = "";
	    var temp1 = IsTrimStr(input);

	    if(temp1 != "") {
	        var temp = fixed_number(temp1);

	        i = temp.length ;

	        var k = i / 3 ;
	        var m = i % 3 ;
	        var n= 0;
	        if(m==0) {
	            for(j = 0; j < k-1; j++) {
	                output1 += temp.substring(n, j*3+3)+",";
	                n=j*3+3;
	            }
	        } else {
	            for(j = 0; j < k-1; j++){
	                output1 += temp.substring(n, j*3+m)+",";
	                n=j*3+m;
	            }
	        }

	        output1 += temp.substring(n,temp.length);
	        var h = searchDot(temp1);
	        if(num != "0") {
	            //output2 += "." ;
	        }
	        if(h == ""){
	            for(p=0; p < num; p++){
	                //output2 += "0" ;
	            }
	        } else {
	            var temp2 = decimal_number(temp1,num)+"" ;
	            temp2 = temp2.substring(1,temp2.length);
	            output2 = temp2;
	        }
	        output = output1 + output2 ;

	    } else if(temp1 == "") {
	        if(num == "0"){
	            output += "" ;
	        }else{
	            output += "0." ;
	        }

	        for(p=0; p < num; p++){
	            output += "0" ;
	        }
	    }
	    var tmp1 = "";

	    if(output.charAt(0)=="-"){
	        if(output.charAt(1)==",") {
	            tmp1 = output.substring(2, output.length);
	            output = "-"+tmp1;
	        }
	    }
	    return output;
	}
	function setAttach(attach_key, arrAttrach, rowId, attach_count) {

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

		document.all["tdSIGN"].style.display = "block";
		document.all["tdSEND"].style.display = "none";		
	}


</script>



<script language="javascript" type="text/javascript">

function setGridDraw(){	
	GridObj_setGridDraw();
   	GridObj.setSizes();
   	GridObj.setColumnHidden(GridObj.getColIndexById("SEL"), false);
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	if(cellInd == GridObj.getColIndexById("DELY_TO_ADDRESS_C")) {
		G_CUR_ROW = GridObj.getRowIndex(GridObj.getSelectedId());
		//if(GridObj.getRowIndex(GridObj.getRowId(GridObj.GetRowCount()-1)) == G_CUR_ROW){
		//	return;
		//}
		PopupManager('DELY_TO_ADDRESS_GRID');
	} 
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
    	//if(rowId == GridObj.getRowId(GridObj.GetRowCount())){
	    //	GridObj.cells(rowId, GridObj.getColIndexById("SEL")).cell.wasChange=false;
	    //	GridObj.cells(rowId, GridObj.getColIndexById("SEL")).setValue("0");
	    //	GridObj.cells(rowId, GridObj.getColIndexById("DELY_TO_ADDRESS")).setValue("");
    	//}else{
    	//	if(GridObj.cells(rowId, GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue() == ""){
    	//		GridObj.cells(rowId, GridObj.getColIndexById("DELY_TO_LOCATION")).setValue("");
    	//	}
    	//}
    	
		var header_name = GridObj.getColumnId(cellInd);
				
		if(header_name == "PO_QTY" || header_name == "UNIT_PRICE")   { 
    		if(changeMoney(GridObj.cells(rowId, cellInd).getValue() + "") == false){
	    		GridObj.cells(rowId, cellInd).setValue("");
				return true;
			}
    	}
		
    	getSumData();
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
        //doQuery();
        location.href="po_target_list.jsp"
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
    
    for(var i = 0 ; i < GridObj.GetRowCount(); i++){
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DELY_TO_ADDRESS_C")).setValue("<img src='/images/ico_zoom.gif'/>");
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DELY_TO_ADDRESS")).setValue(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue());
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("DELY_TO_LOCATION")).setValue(GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_LOCATION")).getValue());
    }
    
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    //getSumData();
    return true;
}

function setVendorAll(){
	var address 	= GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_ADDRESS")).getValue();
	var location 	= GridObj.cells(GridObj.getRowId(0), GridObj.getColIndexById("DELY_TO_LOCATION")).getValue();
	
	if(address == "" || location == ""){
		alert("첫번째 행의 납품주소를 선택해주세요.");
		return;
	}else{
		for(var i = 1 ; i < GridObj.GetRowCount(); i++){
			GD_SetCellValueIndex(GridObj,i,GridObj.getColIndexById("DELY_TO_ADDRESS")	,address);
			GD_SetCellValueIndex(GridObj,i,GridObj.getColIndexById("DELY_TO_LOCATION")	,location);
		}
	}
	
	return true;	
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<form name="form1" method="post">
	<input type="hidden" name="h_po_no" id="h_po_no">
	<input type="hidden" name="set_company_code"id="set_company_code">
	<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value = "D">
	<input type="hidden" name="PO_AMT_KRW" id="PO_AMT_KRW" value = "0">

	<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
	<!-- <input type="hidden" name="attach_no" id="attach_no"> -->
	<input type="hidden" name="attach_count" id="attach_count" value="">
	<input type="hidden" name="att_mode" id="att_mode" value="">
	<input type="hidden" name="view_type" id="view_type" value="">
	<input type="hidden" name="file_type" id="file_type" value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
	<input type="hidden" name="approval_str" id="approval_str" value="">
	
	<input type="hidden" name="COMPANY_CODE" id="COMPANY_CODE" value="">
	<input type="hidden" name="DELY_TERMS" id="DELY_TERMS" value="">
	<input type="hidden" name="ORDER_NAME" id="ORDER_NAME" value="">
	<!-- <input type="hidden" name="PR_TYPE" id="PR_TYPE" value=""> -->
	<input type="hidden" name="CONTRACT_FROM_DATE" id="CONTRACT_FROM_DATE" value="">
	<input type="hidden" name="CONTRACT_TO_DATE" id="CONTRACT_TO_DATE" value="">
	<input type="hidden" name="SIGN_PERSON_ID" id="SIGN_PERSON_ID" value="">
	<input type="hidden" name="ADD_USER_ID" id="ADD_USER_ID" value="">
	<input type="hidden" name="ADD_USER_NAME" id="ADD_USER_NAME" value="">
	<input type="hidden" name="CTRL_CODE" id="CTRL_CODE">
	<input type="hidden" name="CONTRACT_FLAG" id="CONTRACT_FLAG" value="">
	<input type="hidden" name="SIGN_FLAG" id="SIGN_FLAG" value="">
	<input type="hidden" name="TTL_AMT" id="TTL_AMT" value="">
	<input type="hidden" name="APPROVAL" id="APPROVAL" value="">
	<input type="hidden" name="PURCHASER_ID" id="PURCHASER_ID" value="<%=PURCHASER_ID%>">
	<input type="hidden" name="PURCHASER_NAME" id="PURCHASER_NAME" value="<%=PURCHASER_NAME%>">
	
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
    <tr>
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주번호</td>
      	<td width="30%" class="data_td">
      		<input type="text" name="PO_NO" id="PO_NO" style="width:92%" value="" readOnly  style="border:0">
      	</td>
      	<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주명</td>
      	<td width="30%" class="data_td" >
      		<input type="text" name="SUBJECT" id="SUBJECT" style="width:92%" value="<%=SUBJECT%>" class="input_re">
      	</td>
    </tr>
    <!--
    <tr>
      <td width="20%" class="title_td">계약번호</td>
      <td width="30%" class="data_td">
      <input type="text" name="CTR_NO" style="width:92%" value="<//%=CTR_NO%>" readOnly  style="border:0">
      </td>
      <td width="20%" class="title_td">계약일자
      </td>
      <td width="30%" class="data_td">
      <input type="text" name="CTR_DATE" style="width:92%" value="<//%=CTR_DATE%>" >
      </td>
    </tr>
    -->
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주업체</td>
      	<td class="data_td">
      		<input type="text" name="VENDOR_CODE" id="VENDOR_CODE" style="width:30%" value="<%=VENDOR_CODE%>" readOnly  style="border:0">
      		<input type="text" name="VENDOR_NAME" id="VENDOR_NAME" style="width:60%" value="<%=VENDOR_NAME%>" readOnly  style="border:0">
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주일자</td>
      	<td class="data_td">
      		<input type="text" name="PO_CREATE_DATE" id="PO_CREATE_DATE" style="width:92%" value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" readOnly  style="border:0">
      	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
	<tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 발주업체담당자</td>
      	<td class="data_td">
      		담당자 : <input type="text" name="vendor_person_name" size="20" id="vendor_person_name" size="30" value="<%=vncp_user_name%>" class="input_re"  value="이름" nKeyUp="return chkMaxByte(40, this, '이름');">
         	<a href="javascript:PopupManager('vendor');"><img src="/images/ico_zoom.gif"></a>
        	<br>핸드폰 : <input type="text" name="vendor_person_mobil" size="20" id="vendor_person_mobil" size="30" value="<%=vncp_mobile_no%>" class="input_re"  style="ime-mode:disabled" onkeypress="checkNumberFormat('[0-9]', this)" onkeyup="chkMaxByte(30, this, '핸드폰')">
        	<br>이메일 : <input type="text" name="vendor_person_email" size="20" id="vendor_person_email" size="30" value="<%=vncp_email%>" class="input_re" onblur="checkMail(this)">
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
      	<td class="data_td">
      		<select name="pay_terms" id="pay_terms" class="input_re"  style="width:160px" >
				<option value="">-----</option>
				<%=LB_I_PAY_TERMS %>
			</select>
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 인도조건</td>
      	<td class="data_td"><%=dely_terms_name%></td>
      	<!--
      	<td class="title_td"><img src="/images/<//%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 통화</td>
      	<td class="data_td">
      		<input type="text" name="CUR" style="width:92%" value="<//%=CUR%>" readOnly  style="border:0">
      	</td>
      	-->
      	<input type="hidden" name="CUR" id="CUR" value="<%=CUR%>">
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
	<tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수담당자</td>
      	<td class="data_td">
			<input type="text" name="TAKE_USER_ID" id="TAKE_USER_ID" style="width:25%" value="<%=TAKE_USER_ID%>" class="input_re" readOnly >
			<a href="javascript:PopupManager('CTRL_PERSON');"><img src="/images/ico_zoom.gif"></a>
			<input type="text" name="TAKE_USER_NAME" id="TAKE_USER_NAME" style="width:52%"  value="<%=TAKE_USER_NAME%>" readOnly>
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수자연락처</td>
      	<td class="data_td">
      		<input type="text" name="TAKE_TEL" id="TAKE_TEL" style="width:92%; ime-mode:disabled;" value="<%=TAKE_TEL%>" class="inputsubmit" onKeyPress="checkNumberFormat('[0-9]', this);" onKeyUp="return chkMaxByte(30, this, '검수자연락처');">
      	</td>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr> 	
	<tr style="display:none;">
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 계약기간</td>
      	<td class="data_td">
      		<input type="text" name="CONTRACT_FROM_DATE" id="CONTRACT_FROM_DATE" size="10" value="<%=CONTRACT_FROM_DATE%>" >~
      		<input type="text" name="CONTRACT_TO_DATE" id="CONTRACT_TO_DATE" size="10" value="<%=CONTRACT_TO_DATE%>" >
			<input type="hidden" name="PO_TYPE" id="PO_TYPE" size="15" value="<%=PO_TYPE%>" >
      	</td>
      	<input type="hidden" name="PR_TYPE" id="PR_TYPE" size="15"  value="<%=PR_TYPE%>">
      	<input type="hidden" name="ORDER_NO" id="ORDER_NO" size="15"  value="<%=ORDER_NO%>" >
	  	<input type="hidden" name="ORDER_NAME" id="ORDER_NAME" size="15" value="<%=ORDER_NAME%>" >
    </tr>
    <tr>
     	<td class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 구매담당직무</td>
      	<td class="data_td" style="display:none;">
			<input type="text" name="ctrl_code" id="ctrl_code" style="width:32%" readOnly value="parsingCtrlCode(info.getSession("CTRL_CODE"))%>" class="input_re" onBlur="javascript:param1=form1.ctrl_code.value;get_Wisedesc('SP0216','form1',this,'ctrl_name','values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values='+param1+'&values=','1');">
			<a href="javascript:PopupManager('CTRL_CODE')"><img src="IMG"></a>
			<input type="text" name="ctrl_name" id="ctrl_name" style="width:52%"  value="" readOnly>
	        <input type="hidden" name="ctrl_person_id" id="ctrl_person_id">
    	    <input type="hidden" name="ctrl_person_name" id="ctrl_person_name">
      	</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지체상금율</td>
      	<td class="data_td"><%=delay_remark %></td>
      	<td class="data_td" colspan="2"> </td>
<!--       	<td class="title_td"> </td> -->
<%--       	<td class="data_td"><%=TAKE_USER_ID %><%=TAKE_USER_NAME %></td> --%>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 하자이행 보증기간</td>
      	<td class="data_td">검수일로부터 ( <%=warranty_month%> )개월</td>
      	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 계약일반사항</td>
		<td class="data_td">
			선급금보증 <%=first_percent%>%<br>
			계약이행보증 <%=contract_percent%>%<br>
			하자이행보증 <%=mengel_percent%>%<br>
      	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
    	<td class="data_td" colspan="3">
			<textarea name="REMARK" id="REMARK" style="width:98%" rows="5" class="inputsubmit" onKeyUp="return chkMaxByte(500, this, '비고');"></textarea>
    	</td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>     
    <tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
    	<td class="data_td" colspan="3">
    		<TABLE >
      			<TR>
      				<td><input type="text" name="FILE_NAME" id="FILE_NAME" class="inputsubmit" size="80" readonly></td>
					<td><input type="hidden" name="ATTACH_NO" id="ATTACH_NO"><!--  attach_key     --></td>
			        <td><script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'TEMP')","<%=text.get("BUTTON.add-file")%>")</script></td>
   	  			</TR>
			</TABLE>
			<!-- <iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe> -->
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
			
    			<!-- TD><script language="javascript">btn("javascript:approval('SAVE')","임시저장")</script></TD-->
				<%if (sign_use_yn) {%>
				<TD id='tdSIGN' name='tdSIGN'><script language="javascript">btn("javascript:approval('SIGN')","결재요청") </script></TD>
				<TD id='tdVendorAll'  name='dVendorAll' style='display:none' ><script language="javascript">btn("javascript:setVendorAll()","납품장소 일괄적용") </script></TD>
				<TD id='tdSEND'  name='tdSEND' style='display:none'><script language="javascript">btn("javascript:approval('SEND')","업체발송") </script></TD>
				<%} else {%>
				<TD id='tdSIGN'  name='tdSIGN' style='display:none'><script language="javascript">btn("javascript:approval('SIGN')","결재요청") </script></TD>
				<TD id='tdVendorAll'  name='tdVendorAll'><script language="javascript">btn("javascript:setVendorAll()","납품장소 일괄적용") </script></TD>
				<TD id='tdSEND'  name='tdSEND'><script language="javascript">btn("javascript:approval('SEND')","업체발송") </script></TD>
				<%}%>
				<%if(!POPUP_FLAG.equals("N")){ %>
    			<TD><script language="javascript">btn("javascript:self.close();","닫기")</script></TD>
    			<%} %>
    			<!-- 발주서에 대한 전자계약여부가 Y인 경우 [발송]을 하면 전자계약서 화면이 팝업되도록 한다.-->
<%--     		<%if(po_contract_use_flag){%> --%>
<!-- 		      	<TD><script language="javascript">btn("javascript:approval('CONT')",21,"업체발송")</script></TD> -->
<%--     		<%} else {%> --%>
<%-- 				<%if (sign_use_yn) {%> --%>
<!-- 				<TD><script language="javascript">btn("javascript:approval('SIGN')",21,"결재요청") </script></TD> -->
<%-- 				<%} else {%> --%>
<!-- 				<TD><script language="javascript">btn("javascript:approval('SEND')",21,"업체발송") </script></TD> -->
<%-- 				<%}%> --%>
<%--     		<%}%> --%>
<!--     			<TD><script language="javascript">btn("javascript:history.back(-1)",1,"취소")</script></TD> -->
			</TR>
		</TABLE>
      	</td>
	</tr>
</table>
</form>

<form>
   <input type="hidden" name="po_no" id="po_no">
</form>

<!-- 전자계약 화면이동 시작 -->
<form name="main" method="post">
	<input type="hidden" name="_page" id="_page">
	<input type="hidden" name="_action" id="_action">
	<input type="hidden" name="_param" id="_param">
	
	<input type="hidden" name="is_offline" id="is_offline">
	<input type="hidden" name="form_type" id="form_type">
	<input type="hidden" name="reg_type" id="reg_type">
	<input type="hidden" name="form_seq" id="form_seq" value="<%=form_seq%>">
	
	<!-- 발주 및 업체번호 -->
	<input type="hidden" name="bid_no" id="bid_no">
	<input type="hidden" name="vendor_code" id="vendor_code" value="<%=VENDOR_CODE%>">
	
	<!-- 계약번호 및 계약차수 -->
	<input type="hidden" name="cont_seq" id="cont_seq">
	<input type="hidden" name="cont_count" id="cont_count">
</form>
<!-- 전자계약 화면이동 종료 -->

<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<%-- <script language="javascript">rMateFileAttach('S','C','PO',form1.attach_no.value);</script> --%>

</s:header>
<s:grid screen_id="PO_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>