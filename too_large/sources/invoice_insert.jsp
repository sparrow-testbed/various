<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("IV_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "IV_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
	String user_id         		= info.getSession("ID");
	String company_code    		= info.getSession("COMPANY_CODE");
	String house_code      		= info.getSession("HOUSE_CODE");
	String toDays          		= SepoaDate.getShortDateString();
	String toDays_1        		= SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name   	   		= info.getSession("NAME_LOC");
	String ctrl_code       		= info.getSession("CTRL_CODE");
	String po_no		   		= JSPUtil.nullToEmpty(request.getParameter("po_no"));
	String po_seq		   		= JSPUtil.nullToEmpty(request.getParameter("po_seq"));
	String iv_no		   		= JSPUtil.nullToEmpty(request.getParameter("iv_no"));
	String inv_no		   		= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
	String sign_status	   		= JSPUtil.nullToEmpty(request.getParameter("sign_status"));
	String add_user_id	   		= JSPUtil.nullToEmpty(request.getParameter("add_user_id"));
	String exec_no	   			= JSPUtil.nullToEmpty(request.getParameter("exec_no"));
	String dp_seq	   			= JSPUtil.nullToEmpty(request.getParameter("dp_seq"));
	String dp_code	   			= JSPUtil.nullToEmpty(request.getParameter("dp_code"));
	String last_flag   			= JSPUtil.nullToEmpty(request.getParameter("last_flag"));
	String dp_div   			= JSPUtil.nullToEmpty(request.getParameter("dp_div"));
	String SUBJECT				= "";	//수주명
	String DP_TYPE				= "";	//지급방법
	String DP_PAY_TERMS			= "";	//지급조건
	String DP_TYPE_DESC			= "";	//지급방법
	String DP_PAY_TERMS_DESC	= "";	//지급조건
    String IV_SEQ				= "";	//지급차수
	String DP_AMT				= "";	//지급요청금액
	String PO_TTL_AMT			= "";	//수주총금액
	String ADD_USER_ID			= "";	//검수자
	String USER_NAME			= "";	//검수자
	String INV_DATE				= "";	//검수요청일자
	String REMARK				= "";	//비고
	String DP_PAY_TERMS_TEXT	= "";	//조건
	String PO_CREATE_DATE		= "";	//수주생성일자
	String DP_PERCENT			= "";
	String DP_TEXT				= "";
	String INV_AMT				= "";
	String PR_TYPE				= "";
	String CTRL_CODE			= "";
	String AMT_INSU_NUM 		= "";
	String CONT_INSU_NUM    	= "";
	String AS_INSU_NUM      	= "";
	String CUR 					= "";
	String PO_AMT_KRW			= "";
	String EXCHANGE_RATE		= "";
	String CONTRACT_FLAG		= "";
	String GR_AMT				= JSPUtil.nullToEmpty(request.getParameter("gr_amt")); //검수완료금액

	String FIRST_DEPOSIT        = "";
	String INSU_FIRST_STATUS    = "";
	String CONTRACT_DEPOSIT     = "";
	String INSU_CONTRACT_STATUS = "";
	String MENGEL_DEPOSIT       = "";
	String INSU_MENGEL_STATUS   = "";
	
	String PAY_DP_AMT      		= "";   //총금액-검수요청금액합계
	String LAST_YN      		= "";   //검수요청 마지막 차수 여부
	
	//전자계약정보
	String IS_OFF_LINE      	= "";
	String CONT_ATTACH_NO      	= "";
	String FIRST_ATTACH_NO      = "";
	String MENGEL_ATTACH_NO     = "";
	String INV_OFF_CONT_FLAG	= "";
    String INV_OFF_FIRST_FLAG	= "";
    String INV_OFF_MENGEL_FLAG  = "";
    String CASH_GRADE			= "";
    String CREDIT_RATING		= "";
    
    String dev_flag             = "N";	//개발자투입기간 입력 여부
    /* to_do
    *  개발자투입기간을 입력해야하는지 여부를 가져온다.
    */
	
    /**
	 * 2010.05.06 이성우 BUYER가 매입예정대상을 등록하지 않고 SUPPLIER가 검수요청등록함.
	 * Object[] obj = {po_no,iv_no,inv_no,sign_status};
     */
    Object[] obj = {po_no, exec_no, dp_seq, inv_no, sign_status, dp_div};
	SepoaOut value = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getIvPoHeader", obj);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	if(wf.getRowCount() > 0) {
		SUBJECT			    = wf.getValue("SUBJECT"		 		, 0);
		DP_TYPE			    = wf.getValue("DP_TYPE"		 		, 0);
		DP_PAY_TERMS		= wf.getValue("DP_PAY_TERMS" 		, 0);
		IV_SEQ			    = wf.getValue("IV_SEQ"		 		, 0);
		DP_AMT			    = wf.getValue("DP_AMT"		 		, 0);
		PO_TTL_AMT		    = wf.getValue("PO_TTL_AMT"			, 0);
		ADD_USER_ID		    = wf.getValue("ADD_USER_ID"	 		, 0);
		INV_DATE			= SepoaString.getDateSlashFormat(wf.getValue("INV_DATE"    		, 0));
		REMARK			    = wf.getValue("REMARK"				, 0);
		DP_TYPE_DESC		= wf.getValue("DP_TYPE_DESC"		, 0);
		DP_PAY_TERMS_DESC	= wf.getValue("DP_PAY_TERMS_DESC"	, 0);
		USER_NAME			= wf.getValue("USER_NAME"			, 0);
		DP_PAY_TERMS_TEXT	= wf.getValue("DP_PAY_TERMS_TEXT"	, 0);
		PO_CREATE_DATE		= wf.getValue("PO_CREATE_DATE"		, 0);
		DP_PERCENT			= wf.getValue("DP_PERCENT"			, 0);
		DP_TEXT				= wf.getValue("DP_TEXT"				, 0);
		INV_AMT				= wf.getValue("INV_AMT"				, 0);
		PR_TYPE				= wf.getValue("PR_TYPE"				, 0);
		CTRL_CODE			= wf.getValue("CTRL_CODE"			, 0);
		AMT_INSU_NUM  		= wf.getValue("AMT_INSU_NUM"        , 0);
		CONT_INSU_NUM       = wf.getValue("CONT_INSU_NUM"       , 0);
		AS_INSU_NUM         = wf.getValue("AS_INSU_NUM"			, 0);
		CUR					= wf.getValue("CUR" 				, 0);
		PO_AMT_KRW		    = wf.getValue("PO_AMT_KRW"		    , 0);
		EXCHANGE_RATE	    = wf.getValue("EXCHANGE_RATE"		, 0);
		CONTRACT_FLAG		= wf.getValue("CONTRACT_FLAG"		, 0);

		FIRST_DEPOSIT  		= wf.getValue("FIRST_DEPOSIT"        , 0);
		INSU_FIRST_STATUS   = wf.getValue("INSU_FIRST_STATUS"    , 0);
		CONTRACT_DEPOSIT    = wf.getValue("CONTRACT_DEPOSIT"	 , 0);
		INSU_CONTRACT_STATUS= wf.getValue("INSU_CONTRACT_STATUS" , 0);
		MENGEL_DEPOSIT      = wf.getValue("MENGEL_DEPOSIT"       , 0);
		INSU_MENGEL_STATUS  = wf.getValue("INSU_MENGEL_STATUS"	 , 0);

		IS_OFF_LINE  		= wf.getValue("IS_OFF_LINE"	 		 , 0);
		CONT_ATTACH_NO  	= wf.getValue("CONT_ATTACH_NO"	 	 , 0);
		FIRST_ATTACH_NO  	= wf.getValue("FIRST_ATTACH_NO"	 	 , 0);
		MENGEL_ATTACH_NO  	= wf.getValue("MENGEL_ATTACH_NO"	 , 0);
		INV_OFF_CONT_FLAG  	= wf.getValue("INV_OFF_CONT_FLAG"	 , 0);
		INV_OFF_FIRST_FLAG  = wf.getValue("INV_OFF_FIRST_FLAG"	 , 0);
		INV_OFF_MENGEL_FLAG = wf.getValue("INV_OFF_MENGEL_FLAG"	 , 0);

		PAY_DP_AMT  		= wf.getValue("PAY_DP_AMT"	 		 , 0);
		CASH_GRADE			= wf.getValue("CASH_GRADE"	 		 , 0);
		CREDIT_RATING		= wf.getValue("CREDIT_RATING"	 	 , 0);
		LAST_YN				= wf.getValue("LAST_YN"	 			 , 0);
		dev_flag			= wf.getValue("DEV_FLAG"	 		 , 0);
	}
	
	Object[] obj1 = {po_no};
	SepoaOut value1 = ServiceConnector.doService(info, "IV_001", "CONNECTION", "getInvAddUserList", obj1);
	SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
	
	int 	userCnt = 0;
	String 	innerHtmlStr = "";
	
	if(wf1.getRowCount() > 0){
		if(wf1.getRowCount() > 1){
			innerHtmlStr = "<select id='INV_USER_ID' name='INV_USER_ID'>";
			for(int i = 0 ; i < wf1.getRowCount() ; i++){
				innerHtmlStr += "<option value='"+wf1.getValue("USER_ID", i)+"'";
				/* 
				if(i==(wf1.getRowCount()-1)){
					innerHtmlStr += "selected>"+wf1.getValue("USER_NAME", i)+"</option>";
				}else{
					innerHtmlStr += ">"+wf1.getValue("USER_NAME", i)+"</option>";
				}
				*/
				innerHtmlStr += ">"+wf1.getValue("USER_NAME", i)+"</option>";				
 			}
			innerHtmlStr += "</select>";
		}else{
			innerHtmlStr = wf1.getValue("USER_NAME", 0);
			innerHtmlStr += "<input type='hidden' id='INV_USER_ID' name='INV_USER_ID' value='"+wf1.getValue("USER_ID", 0)+"'/>";
		}
	}
%>

<%
    //********검수요청시 기성등록정보 사용여부 시작**********************************************
    //2011.09.15 HMCHOI
    //기성정보를 사용하지 않을 경우 : 검수요청은 수주수량을 기준으로 잔량에서 검수요청을 진행한다.
    Configuration Sepoa_conf = new Configuration();
    boolean ivso_use_flag = false;
    try {
    	ivso_use_flag = Sepoa_conf.getBoolean("Sepoa.ivso.use."+info.getSession("HOUSE_CODE")); //기성정보 사용여부
    } catch (Exception e) {
    	ivso_use_flag = false;
    }
    //********검수요청시 기성등록정보 사용여부 종료**********************************************
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript">
	var	servletUrl = "supply.ordering.ivdp.iv1_bd_ins1";

	var EXEC_AMT_KRW   	= <%=(PO_TTL_AMT == null||PO_TTL_AMT.equals("")?"0":PO_TTL_AMT)%>;
	var DP_CODE        	= "<%=dp_code%>";
	var LAST_FLAG      	= "<%=last_flag%>";
	var mode;
	var checked_count = 0;
	var pr_type = "<%=PR_TYPE%>";
	var IDX_SEL				;
	var IDX_ITEM_NO			;
	var IDX_DESCRIPTION_LOC	;
	var IDX_TECHNIQUE_GRADE ;
	var IDX_INPUT_FROM_DATE ;
	var IDX_INPUT_TO_DATE   ;
	var IDX_RD_DATE			;
	var IDX_UNIT_MEASURE	;
	var IDX_ITEM_QTY		;
	var IDX_UNIT_PRICE		;
	var IDX_GR_QTY			;
	var IDX_INV_QTY			;
	var IDX_ITEM_AMT		;
	var IDX_INV_AMT			;
	var IDX_GR_AMT			;
	var IDX_PO_SEQ			;
	var IDX_INV_AMT			;
	var IDX_INV_QTY_ORGINAL	;

	var chkrow;

	   function setHeader() {
		
		// 검수담당자

// 		GridObj.SetDateFormat("RD_DATE"			,"yyyy/MM/dd");
// 		GridObj.SetDateFormat("INPUT_FROM_DATE"	,"yyyy/MM/dd");
// 		GridObj.SetDateFormat("INPUT_TO_DATE"		,"yyyy/MM/dd");
// 		GridObj.SetNumberFormat("ITEM_QTY"	,G_format_qty);
// 		GridObj.SetNumberFormat("UNIT_PRICE"	,G_format_amt);
// 		GridObj.SetNumberFormat("ITEM_AMT"	,G_format_amt);
// 		GridObj.SetNumberFormat("INV_AMT"		,G_format_amt);
// 		GridObj.SetNumberFormat("GR_AMT"		,G_format_amt);
// 		GridObj.SetNumberFormat("GR_QTY"		,G_format_qty);
// 		GridObj.SetNumberFormat("INV_QTY"		,G_format_qty);
// 		GridObj.SetNumberFormat("ITEM_AMT_KRW",G_format_amt);
// 		GridObj.SetNumberFormat("INV_AMT"		,G_format_amt);
// 		GridObj.SetNumberFormat("INV_AMT_SUM"	,G_format_amt);



		IDX_SEL				= GridObj.GetColHDIndex("SEL"				);
		IDX_ITEM_NO			= GridObj.GetColHDIndex("ITEM_NO"			);
		IDX_DESCRIPTION_LOC	= GridObj.GetColHDIndex("DESCRIPTION_LOC"	);
		IDX_TECHNIQUE_GRADE = GridObj.GetColHDIndex("TECHNIQUE_GRADE" );
		IDX_INPUT_FROM_DATE = GridObj.GetColHDIndex("INPUT_FROM_DATE" );
		IDX_INPUT_TO_DATE   = GridObj.GetColHDIndex("INPUT_TO_DATE"   );
		IDX_RD_DATE			= GridObj.GetColHDIndex("RD_DATE"			);
		IDX_UNIT_MEASURE	= GridObj.GetColHDIndex("UNIT_MEASURE"	);
		IDX_ITEM_QTY		= GridObj.GetColHDIndex("ITEM_QTY"		);
		IDX_UNIT_PRICE		= GridObj.GetColHDIndex("UNIT_PRICE"		);
		IDX_GR_QTY			= GridObj.GetColHDIndex("GR_QTY"			);
		IDX_INV_QTY			= GridObj.GetColHDIndex("INV_QTY"			);
		IDX_ITEM_AMT		= GridObj.GetColHDIndex("ITEM_AMT"		);
		IDX_INV_AMT			= GridObj.GetColHDIndex("INV_AMT"			);
		IDX_GR_AMT			= GridObj.GetColHDIndex("GR_AMT"			);
		IDX_PO_SEQ			= GridObj.GetColHDIndex("PO_SEQ"			);
		IDX_INV_QTY_ORGINAL	= GridObj.GetColHDIndex("INV_QTY_ORGINAL"	);
		
		$("#inv_user").html("<%=innerHtmlStr%>");

		doSelect();
	} 

	function doSelect()
	{
		<%-- GridObj.SetParam("po_no","<%=po_no%>");
		GridObj.SetParam("po_seq","<%=po_seq%>");
		GridObj.SetParam("inv_no","<%=inv_no%>");
		GridObj.SetParam("dp_type","<%=dp_div%>");
		GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; --%>
		
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getPoDetail&grid_col_id="+grid_col_id;
		param += dataOutput();
		var url = "../servlets/sepoa.svl.procure.invoice_insert";
		GridObj.post(url, param);
		GridObj.clearAll(false);
	}
	function getSumData(flag){
		var sum_INV_QTY = 0;
		//var sum_UNIT_PRICE = 0;
		var sum_INV_AMT = 0;
		var count = GridObj.getRowsNum();
		if(flag =="2"){
			count--;
		}
		for(var i = 1 ; i<=count; i++){
			sum_INV_QTY += Number(GridObj.cells(i,GridObj.getColIndexById("INV_QTY")).getValue());
			sum_INV_AMT += Number(GridObj.cells(i,GridObj.getColIndexById("INV_AMT")).getValue());
		}
		if(flag == "1"){
			var nextRowId = GridObj.getRowsNum()+1;
			GridObj.addRow(nextRowId, "", GridObj.getRowIndex(nextRowId));
		}else if(flag == "2"){
			var nextRowId = GridObj.getRowsNum();
		}
		GridObj.cells(nextRowId,GridObj.getColIndexById("ITEM_NO")).setValue("합계");
		GridObj.cells(nextRowId,GridObj.getColIndexById("INV_QTY")).setValue(sum_INV_QTY);
		GridObj.cells(nextRowId,GridObj.getColIndexById("INV_AMT")).setValue(sum_INV_AMT);
	}

	var summaryCnt = 0;
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{
		var Sepoa 		= GridObj;
		var f0          = document.forms[0];
		var row         = GridObj.GetRowCount();
		var po_no       = "";
		var shipper     = "";
		var sign_flag   = "";
		
		if(msg1 == "doQuery"){
			// 기성등록정보를 활용하지 않을 경우
			<%if (!ivso_use_flag) {%>
			    calculate_inv_tot_amt(Sepoa);
		    <%}%>
		    
		}

		if(msg1 == "doData"){
			alert(GD_GetParam(GridObj,"0"));
			location.href = 'iv1_bd_lis2.jsp';
		}

		if(msg1 == "t_imagetext")
		{
			if(msg3==IDX_PO_NO) {
				po_no            = GD_GetCellValueIndex(GridObj,msg2,IDX_PO_NO);
			    window.open("po3_pp_dis1.jsp"+"?po_no="+po_no,"newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
		    } else if(msg3==IDX_VENDOR_CODE) {
				window.open("/kr/master/vendor/ven_pp_dis1.jsp?vendor_code="+GD_GetCellValueIndex(GridObj,msg2,IDX_VENDOR_CODE)+"&flag=popup","newWin","width=800,height=600,resizable=YES, scrollbars=YES, status=yes, top=60, left=20");
		    }
		}
		
		if(msg1 == "t_insert")
		{
			if(msg3==IDX_INV_QTY){
		        calculate_inv_amt(Sepoa, msg2);
			} else if(msg3==IDX_INV_AMT) {
				// 기성등록정보를 활용할 경우
				<%if (ivso_use_flag) {%>
					if(msg5 <= 0 || msg5 > EXEC_AMT_KRW){
					    alert("금액이 0원 이거나 전체 품의금액을 넘을수 없습니다.");
					    GridObj.SetCellValueIndex(msg3,msg2,msg4);
				    	return;
					}
				<%}%>
		        //calculate_inv_qty(Sepoa, msg2);
            }
		}
	}
	
	
	// 검수요청금액 계산
	function calculate_inv_amt(Sepoa, row)
	{
	    var INV_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_INV_QTY)) *  getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
	    GD_SetCellValueIndex(GridObj,row, IDX_INV_AMT, setAmt(INV_AMT));

		// 기성등록정보를 활용하지 않을 경우
		<%if (!ivso_use_flag) {%>
		    calculate_inv_tot_amt(Sepoa);
	    <%}%>
	}

	// 검수요청수량 계산
	function calculate_inv_qty(Sepoa, row)
	{
	    GD_SetCellValueIndex(GridObj, row, IDX_INV_AMT, setAmt(GD_GetCellValueIndex(GridObj,row,IDX_INV_AMT)));
        var INV_QTY = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_INV_AMT)) / getCalculEval(GD_GetCellValueIndex(GridObj,row,IDX_UNIT_PRICE)), 3);
	    GD_SetCellValueIndex(GridObj,row, IDX_INV_QTY, INV_QTY.toFixed(2));

		// 기성등록정보를 활용하지 않을 경우
		<%if (!ivso_use_flag) {%>
		    calculate_inv_tot_amt(Sepoa);
	    <%}%>
	}

	// 검수요청금액 계산
	function calculate_inv_tot_amt(Sepoa)
	{
	    var f = document.forms[0];
	    var inv_tot_amt = 0;

	    for(var i=0;i<GridObj.GetRowCount();i++)
	    {
	      	var inv_amt = getCalculEval(GD_GetCellValueIndex(GridObj,i,IDX_INV_AMT));
	      	inv_tot_amt = inv_tot_amt + inv_amt;
	    }
	    f.DP_AMT.value = add_comma(inv_tot_amt, 2);
	}

	function doInsert(){
		//if("<//%=CREDIT_RATING%>" == ""){
			//alert("신용평가수검이 완료되지 않은경우 검수요청이 불가합니다.");
			//return;
		//}
		var AMT_INSU_NUM    	= "<%=AMT_INSU_NUM %>";
		var CONT_INSU_NUM   	= "<%=CONT_INSU_NUM%>";
		var AS_INSU_NUM  		= "<%=AS_INSU_NUM  %>";
		var CONTRACT_FLAG		= "<%=CONTRACT_FLAG%>";		//ICOYPOHD - 계약상태
		var IS_OFF_LINE			= "<%=IS_OFF_LINE%>";		//오프라인보증여부
		var CONT_ATTACH_NO		= "<%=CONT_ATTACH_NO%>";	//오프라인 계약보증서 첨부번호
		var FIRST_ATTACH_NO		= "<%=FIRST_ATTACH_NO%>";	//오프라인 선급보증서 첨부번호
		var MENGEL_ATTACH_NO 	= "<%=MENGEL_ATTACH_NO%>";	//오프라인 하자보증서 첨부번호

		var INV_OFF_CONT_FLAG 	= "<%=INV_OFF_CONT_FLAG%>";	//오프라인 계약보증서 첨부여부
		var INV_OFF_FIRST_FLAG 	= "<%=INV_OFF_FIRST_FLAG%>";	//오프라인 선급보증서 첨부여부
		var INV_OFF_MENGEL_FLAG = "<%=INV_OFF_MENGEL_FLAG%>";	//오프라인 하자보증서 첨부여부

		var IV_SEQ			= parseInt("<%=IV_SEQ%>");	//지급차수
		var Sepoa 			= GridObj;
		var iRowCount 		= GridObj.GetRowCount();
		var cnt = 0;
		var sum_amt = 0;
		var total_sum_amt = 0;
		var sign_status = document.main.sign_status.value;
		var sum_inv_qty = 0;
		var sum_inv_qty_original = 0;

		//if(CONTRACT_FLAG == "Y" && IV_SEQ == 1 && AMT_INSU_NUM == "" && CONT_INSU_NUM == ""){
		if(CONTRACT_FLAG == "Y"){
			if(IS_OFF_LINE == "Y" ){
				if(IS_OFF_LINE == "Y" && INV_OFF_CONT_FLAG == "" && INV_OFF_FIRST_FLAG == ""){
					alert("오프라인으로 보증서를 제출하셨습니까?\n보증서를 제출한 경우 구매담당자에게 문의해 주세요.");
					return;
				}
			}
			/*
			보증처리를 하지 않습니다.
			else if(IS_OFF_LINE == "" && AMT_INSU_NUM == "" && CONT_INSU_NUM == "" && INV_OFF_FIRST_FLAG == "" && INV_OFF_CONT_FLAG ==""){
				alert("선급금보증번호와 계약이행보증번호가 모두 있어야 검수요청이 가능합니다.");
				return;
			}else{
				if(AMT_INSU_NUM == "" && CONT_INSU_NUM == ""){
					if(INV_OFF_FIRST_FLAG == "Y" && INV_OFF_CONT_FLAG =="Y"){ // 오프라인으로 보증신청후 구매담당자가 보증현황에서 선급, 계약이행 보증서를 첨부한경우
					}else {
						alert("온라인으로 선급금 보증서 및 계약 보증서를 요청 후 승인받아야 합니다. 확인해 주세요.");
						return;
					}
				}
			}
			*/
		}

		/*****************************************************************************************************************
		   DP_CODE=3[잔금] && last_flag="Y"일 경우
		      1. 검수요청수량 == (수량-누적검수수량) && 검수요청금액 == (지급금액-누적검수요청금액)
		      2. 1.이 아닐 경우
		         2.1 조건 충족 :: 검수요청수량 < (수량-누적검수수량) && 검수요청금액 < (지급금액-누적검수요청금액)
		             ==> ICOYCNDP에 데이터 추가(STATUS='T', DP_CODE='3')
		******************************************************************************************************************/
		for(var i=0;i<iRowCount-1;i++)
		{
			
			var maxqty = setQty(new Number(GridObj.GetCellValue("ITEM_QTY",i))-new Number(GridObj.GetCellValue("INV_QTY_SUM",i)));

			// 기성등록정보를 활용할 경우
			<%if (ivso_use_flag) {%>
				if(DP_CODE == '3' && LAST_FLAG=='Y'){
					/* #전자보증처리를 하지 않습니다.
					if(CONTRACT_FLAG == "Y" && AS_INSU_NUM == ""){
						alert("하자이행보증번호가 없으면 검수요청을 하실수 없습니다.");
						return;
					} 
					*/
				}
			<%}%>
			if(maxqty < new Number(GridObj.GetCellValue("INV_QTY",i))){
				alert("검수요청 수량의 합이 총수량을 넘을 수 없습니다.\n\n"+GridObj.GetCellValue("DESCRIPTION_LOC",i)+"의 잔여수량 : "+maxqty);
				return;
			}

			if(GridObj.GetCellValue("INV_QTY",i)=="0")
				GD_SetCellValueIndex(GridObj, i, IDX_SEL, "false&", "&");
			else {
// 				GD_SetCellValueIndex(GridObj, i, IDX_SEL, "true&", "&");
				GridObj.cells(i+1, GridObj.getColIndexById("SEL")).setValue("1");
				GridObj.cells(i+1, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
				cnt++;
			}
			sum_amt       += parseFloat(GridObj.GetCellValue("INV_AMT",i));       //검수요청금액
			total_sum_amt += parseFloat(GridObj.GetCellValue("INV_AMT_SUM",i));   //누적검수요청금액

			sum_inv_qty  		 += parseFloat(GridObj.GetCellValue("INV_QTY",i));
			sum_inv_qty_original += parseFloat(GridObj.GetCellValue("INV_QTY_ORGINAL",i));
		}
		if (cnt == 0)
		{	alert("검수 요청 수량이 한건도 입력되지 않았습니다.");
			return;
		}
		if(parseFloat(EXEC_AMT_KRW) < parseFloat(total_sum_amt) + sum_amt){
            alert("검수요청금액 총합이 전체 품의금액을 넘을 수 없습니다.");
            return;
        }
		
		// 기성등록정보를 활용할 경우
		<%if (ivso_use_flag) {%>
	        var compareDP_AMT 	= "<%=DP_AMT%>";
	        var compareDP_CODE 	= "<%=dp_code%>";
			
	        if(parseFloat(compareDP_AMT) < sum_amt ){
	        	alert("검수요청금액["+add_comma(sum_amt, 0)+"]이 지급요청금액["+add_comma(compareDP_AMT, 0)+"]을 넘을 수 없습니다.");
	            return;
	        }
	        if(compareDP_CODE != "3"  && parseFloat(compareDP_AMT) != sum_amt ){
	        	alert("검수요청금액["+add_comma(sum_amt, 0)+"]이 지급요청금액["+add_comma(compareDP_AMT, 0)+"]과 같지 않습니다.");
	            return;
	        }
	        if(compareDP_CODE == "3"  && parseFloat(compareDP_AMT) != sum_amt){
	        	//if(!confirm("검수요청금액["+add_comma(sum_amt, 0)+"]이 지급요청금액["+add_comma(compareDP_AMT, 0)+"]과 같지 않습니다. 계속 진행 하시겠습니까?"))
	        	//20120811 : 이익수 과장 요청사항
	        	if(!confirm("검수요청금액["+add_comma(sum_amt, 0)+"]이 지급요청금액["+add_comma(compareDP_AMT, 0)+"]보다 작습니다. 기성분 수량으로 검수를 요청하겠습니다."))
	    			return;
	        }
		<%} else {%>
			if( parseFloat(EXEC_AMT_KRW) == (parseFloat(total_sum_amt)+sum_amt) ) {
		        DP_CODE		= "3"; // 잔금
		        DP_TEXT		= "잔금"; // 잔금
		        LAST_FLAG 	= "Y"; // 최종 검수요청여부
	        } else {
		        DP_CODE		= "2"; // 중도금
		        DP_TEXT		= "중도금"; // 중도금
	        	LAST_FLAG 	= "N"; // 최종 검수요청여부
	        }
		<%}%>
        //반려일 경우 반려전에 등록한
        if(sign_status=="R"){
        	if(sum_inv_qty_original < sum_inv_qty){
        		alert("검수요청 등록수량이 검수요청 예정수량보다 큽니다");
        		return;
        	}
        }
        
        <%if("S".equals(dp_div) && "3".equals(dp_code)){%>
              if(document.getElementById("start_change_date").value == ""){
            	  alert("개발자투입기간 시작일자를 입력해주세요.");
            	  return;
              }
              
              if(document.getElementById("end_change_date").value == ""){
            	  alert("개발자투입기간 종료일자를 입력해주세요.");
            	  return;
              }
        <%}%>
        
        if (!confirm('검수요청 하시겠습니까?')) {
        	return;
        }
        
//      getApprovalSend();
// 		document.attachSFrame.setData();

		
		$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_insert",
    			{
    				po_no : document.main.po_no.value,
    				inv_user_id : document.form1.INV_USER_ID.value,
    				mode  : "chkInvUserId"
    			},
    			function(arg){
    				if(IsTel(arg)){
    					if(arg == "0" || arg == "-1"){ // 0:소속점변동없음,-1:구매요청자
        					getApprovalSend();        					
        				}else if(arg == "-999"){
        					alert("검수자 부서테크중 오류발생");
        				}else{
        					alert("검수자가 인사이동으로 원소속점이 변경되어 총무부(구매담당자)에게 검수요청 해주시기 바랍니다.");
        					//document.form1.INV_USER_ID.focus();
        				}
    				}else{
    					alert("검수자 부서테크중 오류발생");
    				}
    				
    				
    			}
			);
		
		
		
    }
	function setQty(value) {
		rlt = 0;
		if(value == "" || value == 0) return 0;

		rlt = Math.round(new Number(value) * 1000000) / 1000000;

		return rlt;
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

	}
	
	function getApprovalSend()
	{
		// 기성등록정보를 활용할 경우
		<%if (ivso_use_flag) {%>
				document.form1.DP_AMT.value = <%=DP_AMT%>;
		<%} else {%>
			// 기성정보 미활용시 지급율을 계산하기 위해
				document.form1.DP_AMT.value = <%=PO_TTL_AMT%>;
		<%}%>
		// 기성등록정보를 활용할 경우
		<%if (ivso_use_flag) {%>
				document.form1.DP_SEQ.value = dp_seq;
		<%} else {%>
				document.form1.DP_SEQ.value = "<%=IV_SEQ%>";

		<%}%>
		var grid_array = getGridChangedRows(GridObj, "SEL");

    	var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_insert";
		var params = "mode=setIvInsert&cols_ids="+cols_ids;
			params += dataOutput();
	    myDataProcessor = new dataProcessor(SERVLETURL, params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
		
	}
	
	function getApprovalSend_20160903_bak()
	{
<%-- 		GridObj.SetParam("inv_no"				,"<%=inv_no%>"				); --%>
<%-- 		GridObj.SetParam("po_no"				,"<%=po_no%>"         		); --%>
<%-- 		GridObj.SetParam("iv_no"				,"<%=iv_no%>"				); --%>
<%-- 		GridObj.SetParam("SUBJECT"			,"<%=SUBJECT%>"			    ); --%>
<%-- 		GridObj.SetParam("DP_TYPE"			,"<%=DP_TYPE%>"			    ); --%>
<%-- 		GridObj.SetParam("DP_PAY_TERMS"		,"<%=DP_PAY_TERMS%>"		); --%>
<%-- 		GridObj.SetParam("IV_SEQ"				,"<%=IV_SEQ%>"				); --%>
		// 기성등록정보를 활용할 경우
		<%if (ivso_use_flag) {%>
<%-- 			GridObj.SetParam("DP_AMT"			,"<%=DP_AMT%>"				); --%>
				document.form1.DP_AMT.value = <%=DP_AMT%>;
		<%} else {%>
			// 기성정보 미활용시 지급율을 계산하기 위해
<%-- 			GridObj.SetParam("DP_AMT"			,"<%=PO_TTL_AMT%>"			); --%>
				document.form1.DP_AMT.value = <%=PO_TTL_AMT%>;
		<%}%>
<%-- 		GridObj.SetParam("PO_TTL_AMT"			,"<%=PO_TTL_AMT%>"			); --%>
<%-- 		GridObj.SetParam("ADD_USER_ID"		,"<%=ADD_USER_ID%>"		    ); --%>
<%-- 		GridObj.SetParam("INV_DATE"			,"<%=INV_DATE%>"			); --%>
// 		GridObj.SetParam("REMARK"				,document.forms[0].REMARK.value );
<%-- 		GridObj.SetParam("DP_PAY_TERMS_TEXT"  ,"<%=DP_PAY_TERMS_TEXT%>"   ); --%>
<%--         GridObj.SetParam("PO_CREATE_DATE"		,"<%=PO_CREATE_DATE%>"		); --%>
<%-- 		GridObj.SetParam("DP_PERCENT"		    ,"<%=DP_PERCENT%>"		    ); --%>
<%--         GridObj.SetParam("DP_TEXT"		    ,"<%=DP_TEXT%>"		    	); --%>
<%--         GridObj.SetParam("add_user_id"	    ,"<%=add_user_id%>"	    	); --%>
<%--         GridObj.SetParam("CTRL_CODE"	    	,"<%=CTRL_CODE%>"	    	); --%>
<%--         <%if("S".equals(dp_div) && "3".equals(dp_code)){%> --%>
//         GridObj.SetParam("start_change_date"	,document.forms[0].start_change_date.value	);
//         GridObj.SetParam("end_change_date"	,document.forms[0].end_change_date.value	);
// 		   document.form1.start_change_date.value = "";
// 		   document.form1.end_change_date.value = "";
<%--         <%}%> --%>
//        else{
//         GridObj.SetParam("start_change_date"	,""	);
//         GridObj.SetParam("end_change_date"	,""	);
//         }
//         GridObj.SetParam("ATTACH_NO"	    	,document.forms[0].attach_no.value	);
<%--         GridObj.SetParam("EXEC_NO"    	    ,"<%=exec_no%>"	    		); --%>
		// 기성등록정보를 활용할 경우
		<%if (ivso_use_flag) {%>
<%--   	      	GridObj.SetParam("DP_SEQ"	   	    ,"<%=dp_seq%>"	    		); --%>
				document.form1.DP_SEQ.value = dp_seq;
		<%} else {%>
<%--     	    GridObj.SetParam("DP_SEQ"	   	    ,"<%=IV_SEQ%>"	    		); --%>
				document.form1.DP_SEQ.value = "<%=IV_SEQ%>";

		<%}%>
//         GridObj.SetParam("DP_CODE"	    	,DP_CODE	    			);
//         GridObj.SetParam("LAST_FLAG"	    	,LAST_FLAG	    			);
<%--         GridObj.SetParam("DP_DIV"	    	    ,"<%=dp_div%>"	    		); --%>
// 		GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
// 		GridObj.SendData(servletUrl, "ALL", "ALL");

// 	document.form1.start_change_date.value = del_Slash( document.form1.start_change_date.value );
// 	document.form1.end_change_date.value   = del_Slash( document.form1.end_change_date.value   );

	var grid_array = getGridChangedRows(GridObj, "SEL");

    	var cols_ids = "<%=grid_col_id%>";
		var SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.invoice_insert";
		var params = "mode=setIvInsert&cols_ids="+cols_ids;
			params += dataOutput();
	    myDataProcessor = new dataProcessor(SERVLETURL, params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "SEL", grid_array);
		
	}
	<%-- function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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

	//Supplier 만 첨부가능
	function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
		var attach_key   = att_no;
		var attach_count = att_cnt;

		if (document.form1.attach_gubun.value == "Sepoa"){
			GD_SetCellValueIndex(GridObj, Arow, INDEX_QTA_ATTACH_NO, G_IMG_ICON + "&" + attach_count + "&" + attach_key, "&");

			document.form1.attach_gubun.value="body";
		} else {
			var f = document.forms[0];
		    f.attach_no.value    = attach_key;
		    f.attach_count.value = attach_count;

		    getApprovalSend();
		}
	} --%>

	// 서울보증보험에 통보서 전송
	function go_insu(guarantee_flag){
		document.main.target = 'hiddenFrame';
		document.main.guarantee_flag.value=guarantee_flag;
		//document.main.target = '_popup';
		document.main._action.value = "HANDLE";
       	document.main._param.value = "CONTRACT_GUARANTEE_HANDLER";
       	document.main._page.value = "CONTRACT_GUARANTEE_RESULT";

       	document.main.submit();
	}

	function go_reload(){
		var po_no 		= document.main.po_no.value;
		var iv_no 		= document.main.iv_no.value;
		var inv_no 		= document.main.inv_no.value;
		var sign_status = document.main.sign_status.value;
		var add_user_id = document.main.add_user_id.value;
		var t_url 	 = "iv1_bd_ins1.jsp?po_no="+po_no+"&iv_no="+iv_no+"&sign_status="+sign_status+"&inv_no="+inv_no+"&add_user_id="+add_user_id;
		location.href = t_url;
	}

	function go_insu_menual(){
		var menual_url = "/bohum//iv1_bd_bohum_menual.jsp";
		window.open( menual_url, 'menual', 'left=100, top=200, width=900, height=700, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
	}

	function go_insu_search(){
	 	var search_url = "http://egis.sgic.co.kr";
	 	window.open( search_url, 'search', 'left=100, top=200, width=900, height=700, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
	}
	
    function start_change_date(year,month,day,week) {
    	document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
    	document.forms[0].end_change_date.value=year+month+day;
    }
    
    
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
        	var header_name = GridObj.getColumnId(cellInd);
        	if( header_name == "INV_QTY"){
    			var ivn_qty = GridObj.cells(rowId, GridObj.getColIndexById("INV_QTY")).getValue();
    			var unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
    			GridObj.cells(rowId, GridObj.getColIndexById("INV_AMT")).setValue(ivn_qty * unit_price);
    			getSumData(2);
    		}
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

        if(status == "1") {
            alert(messsage);
        } else {
            alert(messsage);
        }
        if("undefined" != typeof JavaCall) {
            location.href='invoice_target_list.jsp';
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
        
//         document.form1.start_change_date.value = add_Slash( document.form1.start_change_date.value );
//         document.form1.end_change_date.value   = add_Slash( document.form1.end_change_date.value   );
        
        if("undefined" != typeof JavaCall) {
        	JavaCall("doQuery");
        } 
        getSumData(1);
        return true;
    }
</script>

</head>
<body onload="javascript:setGridDraw(); javascript:setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<s:header>
<!--내용시작-->
<form id="form1" name="form1" >
	<input type="hidden" name="REMARK" id="REMARK" value="<%=REMARK%>">
	<input type="hidden" name="kind" id="kind">
	<input type="hidden" name="attach_count" id="attach_count" value="">
	<input type="hidden" name="SUBJECT" id="SUBJECT" value="<%=SUBJECT%>">
	<input type="hidden" name="DP_PAY_TERMS" id="DP_PAY_TERMS" value="<%=DP_PAY_TERMS%>">
	<input type="hidden" name="DP_TYPE" id="DP_TYPE" value="<%=DP_TYPE%>">
	<input type="hidden" name="IV_SEQ" id="IV_SEQ" value="<%=IV_SEQ%>">
	<input type="hidden" name="PO_TTL_AMT" id="PO_TTL_AMT" value="<%=PO_TTL_AMT%>">
	<input type="hidden" name="ADD_USER_ID" id="ADD_USER_ID" value="<%=add_user_id%>">
	<input type="hidden" name="INV_DATE" id="INV_DATE" value="<%=INV_DATE%>">
	<input type="hidden" name="DP_PAY_TERMS_TEXT" id="DP_PAY_TERMS_TEXT" value="<%=DP_PAY_TERMS_TEXT%>">
	<input type="hidden" name="PO_CREATE_DATE" id="PO_CREATE_DATE" value="<%=PO_CREATE_DATE%>">
	<input type="hidden" name="DP_PERCENT" id="DP_PERCENT" value="<%=DP_PERCENT%>">
	<input type="hidden" name="DP_TEXT" id="DP_TEXT" value="<%=DP_TEXT%>">
	<input type="hidden" name="CTRL_CODE" id="CTRL_CODE" value="<%=CTRL_CODE%>">
	<input type="hidden" name="EXEC_NO" id="EXEC_NO" value="<%=exec_no%>">
	<input type="hidden" name="DP_SEQ" id="DP_SEQ" value="">
	<input type="hidden" name="DP_CODE" id="DP_CODE" value="<%=dp_code%>">
	<input type="hidden" name="LAST_FLAG" id="LAST_FLAG" value="<%=last_flag%>">

	<input type="hidden" name="attach_gubun" id="attach_gubun" value="body">
	<input type="hidden" name="att_mode" id="att_mode"  value="">
	<input type="hidden" name="view_type" id="view_type"  value="">
	<input type="hidden" name="file_type" id="file_type"  value="">
	<input type="hidden" name="tmp_att_no" id="tmp_att_no" value="">
<%-- 	<input type="hidden" name="INV_USER_ID" id="INV_USER_ID" value="<%=ADD_USER_ID%>"> --%>
	
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
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주번호</td>
      <td width="30%" class="data_td"><%=po_no%></td>
      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주명</td>
      <td width="40%" class="data_td"><%=SUBJECT%></td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>    
	<!--기성등록정보를 사용하는 경우 기성정보를 가져와서 수정이 불가능하도록 한다.-->
	<%if (ivso_use_flag) {%>
	    <tr>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급방식</td>
	      <td class="data_td"><%=DP_TYPE_DESC%></td>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급방법</td>
	      <td class="data_td"><%=DP_PAY_TERMS_DESC%></td>
	    </tr>
	    <tr>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급차수</td>
	      <td class="data_td"><%=IV_SEQ%></td>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급요청금액</td>
	      <td class="data_td"><%=SepoaMath.SepoaNumberType(DP_AMT,"###,###,###,###,###,###")%></td>
	    </tr>
	<%} else {%>
	    <tr>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 통화</td>
	      <td class="data_td"><%=CUR%></td>
	      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 지급요청금액</td>
	      <td class="data_td"><input type="text" name="DP_AMT" id="DP_AMT" style="width:30%" class="input_data2_right" readonly></td>
	    </tr>
	<%}%>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 수주총금액<BR>&nbsp;&nbsp;&nbsp;(VAT 포함)</td>
      <td class="data_td"><%=SepoaMath.SepoaNumberType(PO_TTL_AMT,"###,###,###,###,###,###")%></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수완료금액</td>
      <td class="data_td"><%=SepoaMath.SepoaNumberType(GR_AMT,"###,###,###,###,###,###")%></td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수담당자</td>
      <td class="data_td" id="inv_user" ></td>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 검수요청일자</td>
      <td class="data_td"><%=INV_DATE%></td>
    </tr>
    
	<%if (ivso_use_flag) {%>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 통화</td>
      <td class="data_td" colspan="3"><%=CUR%></td>
    </tr>
	<%}%>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>	
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 비고</td>
      <td class="data_td" colspan="3"><%=REMARK%></td>
    </tr>
    <% if("S".equals(dp_div) && "3".equals(dp_code)){ %>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
      <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 개발자투입기간</td>
      <td class="data_td" colspan="3">
        <s:calendar id_from="start_change_date" default_from="" default_to="" id_to="end_change_date" format="%Y/%m/%d" />   
      </td>
    </tr>
    <%} %>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 첨부파일</td>
		<td class="data_td" colspan="3" height="150">
			<table>
				<tr>
					<td>
						<input type="text" name="FILE_NAME" id="FILE_NAME" class="inputsubmit" size="80" readonly">
					</td>
					<td>
						<input type="hidden" name="ATTACH_NO" id="ATTACH_NO"><!--  attach_key     -->
						<script language="javascript">btn("javascript:attach_file(document.forms[0].ATTACH_NO.value,'TEMP')","<%=text.get("BUTTON.add-file")%>")</script>
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
      		<!--
      		<TABLE cellpadding="0">
      			<TR>
      			 <td><script language="javascript">btn("javascript:go_insu_menual()",2,"보증보험메뉴얼")</script></td>
				 <td><script language="javascript">btn("javascript:go_insu_search()",2,"보증보험조회")</script></td>
      			</TR>
      		</TABLE>
      		-->
      		기성으로 검수요청 시에는 기성 수량을 입력하여 주세요.
      		</td>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>
	    	  			<TD><script language="javascript">btn("javascript:doInsert()","검수요청")</script></TD>
	    	  			<TD><script language="javascript">btn("javascript:history.back(-1)","취 소")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>

<iframe name = "getDescframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<div id="message" style="position:absolute; left:1px; top:1px; width:176px; height:45px; z-index:1; border-width:1px; visibility:hidden; border-style:none;">
	<iframe name="hiddenFrame" src="" width=176 height=45 frameborder=0 scrolling=no></iframe>
</div>

<form name="main" method="post" action="/s_kr/ctr/Main.jsp">
<input type="hidden" name="_action" id="_action" value="HANDLE">
<input type="hidden" name="_param" id="_param" value="">
<input type="hidden" name="_page" id="_page" value="">
<input type="hidden" name="guarantee_flag" id="guarantee_flag">
<input type="hidden" name="cont_seq" id="cont_seq" value="">
<input type="hidden" name="po_no" id="po_no" value="<%=po_no%>">
<input type="hidden" name="po_seq" id="po_seq" value="<%=po_seq%>">
<input type="hidden" name="dp_type" id="dp_type" value="<%=dp_div%>">
<input type="hidden" name="iv_no" id="iv_no" value="<%=iv_no%>">
<input type="hidden" name="inv_no" id="inv_no" value="<%=inv_no%>">
<input type="hidden" name="sign_status" id="sign_status" value="<%=sign_status%>">
<input type="hidden" name="add_user_id" id="add_user_id" value="<%=add_user_id%>">
</form>

</s:header>
<s:grid screen_id="IV_003" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<%-- <script language="javascript">rMateFileAttach('S','C','IV',form1.attach_no.value,'S');</script> --%>



