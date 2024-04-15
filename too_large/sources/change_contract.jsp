<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Config conf = new Configuration();
	String buyer_company_code = conf.getString("sepoa.buyer.company.code");
	
	String cont_no	   = JSPUtil.nullToEmpty(request.getParameter("cont_no")).trim();
	String button	   = JSPUtil.nullToEmpty(request.getParameter("button")).trim();
	String cont_gl_seq = JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")).trim();
	String change_cont_flag = JSPUtil.nullToEmpty(request.getParameter("change_cont_flag")).trim();
	String house_code	= info.getSession("HOUSE_CODE");	
	
	String CONT_NO				= "";
	String CONT_GL_SEQ			= "";
	String SUBJECT				= "";
	String CONT_GUBUN      		= "";
	String PROPERTY_YN			= "";
	String SELLER_CODE			= "";
	String SELLER_NAME			= "";
	String SIGN_PERSON_ID		= "";
	String SIGN_PERSON_NAME		= "";
	String CONT_FROM			= "";
	String CONT_TO				= "";
	String CONT_DATE			= "";
	String CONT_ADD_DATE		= "";
	String CONT_TYPE			= "";
	String ELE_CONT_FLAG		= "";
	String ASSURE_FLAG			= "";
	String START_START_INS_FLAG	= "";
	String CONT_PROCESS_FLAG	= "";
	String CONT_AMT				= "";
	String CONT_ASSURE_PERCENT	= "";
	String CONT_ASSURE_AMT		= "";
	String FAULT_INS_PERCENT	= "";
	String FAULT_INS_AMT		= "";
	String PAY_DIV_FLAG			= "";
	String FAULT_INS_TERM		= "";
	String BD_NO				= "";
	String BD_COUNT				= "";
	String AMT_GUBUN			= "";
	String TEXT_NUMBER			= "";
	String DELAY_CHARGE			= "";
	String DELV_PLACE			= "";
	String REMARK				= "";
	String CTRL_DEMAND_DEPT		= "";
	String CT_FLAG_TEXT			= "";	
	String CT_FLAG				= "";	
	String CTRL_CODE			= "";
	String COMPANY_CODE			= "";
	String RFQ_TYPE				= "";
	String REJECT_REASON		= "";
	
	String ACCOUNT_CODE			= "";
	String ACCOUNT_NAME			= "";
	
	//String CONFIRM_USER_ID		= "";
	//String CONFIRM_USER_NAME		= "";	
	
	String CONT_TYPE1_TEXT 		= ""; 
	String CONT_TYPE2_TEXT 		= "";
	
	String MAX_CONT_GL_SEQ		= "";
	
	String ITEM_TYPE			= "";
	String RD_DATE				= "";
	String CONT_TOTAL_GUBUN		= "";
	String CONT_PRICE			= "";
	
	String SG_LEV1				= "";
	String SG_LEV2				= "";
	String SG_LEV3				= "";
	String ADD_TAX_FLAG			= ""; 
	String TTL_ITEM_QTY			= ""; 
	String EXEC_NO				= ""; 
	String rfq_no				= ""; 
	String rfq_count			= ""; 
	
	Object[] obj = {cont_no ,cont_gl_seq};
	SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","getContractUpdateSelect", obj);
	SepoaFormater wf  = new SepoaFormater(value.result[0]);
	
	//DB에서 받아올값들 초기화
    if(wf.getRowCount() > 0) {
    	CONT_NO					= JSPUtil.nullToEmpty(wf.getValue("CONT_NO",				0));
    	SUBJECT					= JSPUtil.nullToEmpty(wf.getValue("SUBJECT",				0));
    	CONT_GUBUN     			= JSPUtil.nullToEmpty(wf.getValue("CONT_GUBUN",				0));
    	PROPERTY_YN				= JSPUtil.nullToEmpty(wf.getValue("PROPERTY_YN",			0));
    	
    	
    	ACCOUNT_CODE			= JSPUtil.nullToEmpty(wf.getValue("ACCOUNT_CODE",			0));
    	ACCOUNT_NAME			= JSPUtil.nullToEmpty(wf.getValue("ACCOUNT_NAME",			0));
    	
    	SELLER_CODE				= JSPUtil.nullToEmpty(wf.getValue("SELLER_CODE",			0));
    	
    	SELLER_NAME				= JSPUtil.nullToEmpty(wf.getValue("SELLER_NAME",			0));
    	SIGN_PERSON_ID			= JSPUtil.nullToEmpty(wf.getValue("SIGN_PERSON_ID",			0));
    	SIGN_PERSON_NAME		= JSPUtil.nullToEmpty(wf.getValue("SIGN_PERSON_NAME",		0));
    	CONT_FROM				= JSPUtil.nullToEmpty(wf.getValue("CONT_FROM",				0));
    	CONT_TO					= JSPUtil.nullToEmpty(wf.getValue("CONT_TO",				0));
    	
    	CONT_DATE				= JSPUtil.nullToEmpty(wf.getValue("CONT_DATE",				0));
    	CONT_ADD_DATE			= JSPUtil.nullToEmpty(wf.getValue("CONT_ADD_DATE",			0));
    	CONT_TYPE				= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE",				0));
    	ELE_CONT_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ELE_CONT_FLAG",			0));
    	ASSURE_FLAG				= JSPUtil.nullToEmpty(wf.getValue("ASSURE_FLAG",			0));
    	
    	START_START_INS_FLAG	= JSPUtil.nullToEmpty(wf.getValue("START_START_INS_FLAG",	0));
    	CONT_PROCESS_FLAG		= JSPUtil.nullToEmpty(wf.getValue("CONT_PROCESS_FLAG",		0));
    	CONT_AMT				= JSPUtil.nullToEmpty(wf.getValue("CONT_AMT",				0));
    	CONT_ASSURE_PERCENT		= JSPUtil.nullToEmpty(wf.getValue("CONT_ASSURE_PERCENT",	0));
    	CONT_ASSURE_AMT			= JSPUtil.nullToEmpty(wf.getValue("CONT_ASSURE_AMT",		0));
    	
    	FAULT_INS_PERCENT		= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_PERCENT",		0));
    	FAULT_INS_AMT			= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_AMT",			0));
    	PAY_DIV_FLAG			= JSPUtil.nullToEmpty(wf.getValue("PAY_DIV_FLAG",			0));
    	FAULT_INS_TERM			= JSPUtil.nullToEmpty(wf.getValue("FAULT_INS_TERM",			0));
    	BD_NO					= JSPUtil.nullToEmpty(wf.getValue("BD_NO",					0));
    	
    	BD_COUNT				= JSPUtil.nullToEmpty(wf.getValue("BD_COUNT",				0));
    	AMT_GUBUN				= JSPUtil.nullToEmpty(wf.getValue("AMT_GUBUN",				0));
    	TEXT_NUMBER				= JSPUtil.nullToEmpty(wf.getValue("TEXT_NUMBER",			0));
    	DELAY_CHARGE			= JSPUtil.nullToEmpty(wf.getValue("DELAY_CHARGE",			0));
    	DELV_PLACE				= JSPUtil.nullToEmpty(wf.getValue("DELV_PLACE",				0));
    	
    	REMARK					= JSPUtil.nullToEmpty(wf.getValue("REMARK",					0));
	   	CTRL_DEMAND_DEPT		= JSPUtil.nullToEmpty(wf.getValue("CTRL_DEMAND_DEPT",		0));     
	   	CT_FLAG_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG_TEXT",			0));   
	   	CT_FLAG					= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG",				0));   
    	CTRL_CODE				= JSPUtil.nullToEmpty(wf.getValue("CTRL_CODE",				0));
    	COMPANY_CODE			= JSPUtil.nullToEmpty(wf.getValue("COMPANY_CODE",			0));  
    	RFQ_TYPE				= JSPUtil.nullToEmpty(wf.getValue("RFQ_TYPE",				0));  
    	REJECT_REASON			= JSPUtil.nullToEmpty(wf.getValue("REJECT_REASON",				0));  
    	//CONFIRM_USER_ID			= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_ID",		0));  
    	//CONFIRM_USER_NAME		= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_NAME",		0));
    	
    	
    	CONT_GL_SEQ     		= JSPUtil.nullToEmpty(wf.getValue("CONT_GL_SEQ",		0)); // 차수
    	CONT_TYPE1_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE1_TEXT",    0));
    	CONT_TYPE2_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE2_TEXT",	0));
    	
    	MAX_CONT_GL_SEQ         = JSPUtil.nullToEmpty(wf.getValue("MAX_CONT_GL_SEQ",	0));
    	
	    SG_LEV1					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV1",				0)); 
		SG_LEV2					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV2",				0)); 
		SG_LEV3					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV3",				0)); 
		ADD_TAX_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ADD_TAX_FLAG",			0));  
		ITEM_TYPE				= JSPUtil.nullToEmpty(wf.getValue("ITEM_TYPE",			0));  
		RD_DATE					= JSPUtil.nullToEmpty(wf.getValue("RD_DATE",			0));  
		CONT_TOTAL_GUBUN		= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN",			0));  
		CONT_PRICE				= JSPUtil.nullToEmpty(wf.getValue("CONT_PRICE",			0));    
		TTL_ITEM_QTY			= JSPUtil.nullToEmpty(wf.getValue("TTL_ITEM_QTY",			0));    
		EXEC_NO					= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",			0));    
		rfq_no					= JSPUtil.nullToEmpty(wf.getValue("RFQ_NO",			0));    
		rfq_count				= JSPUtil.nullToEmpty(wf.getValue("RFQ_COUNT",			0));    
		   
    }
	String tmpId = "AR_001_1";
	String tmpId2 = "";
	if("".equals(EXEC_NO)){ tmpId = "CT_007_1"; tmpId2 = "none"; }
	
	
	Vector multilang_id = new Vector();
	multilang_id.addElement(tmpId);
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	
	// Dthmlx Grid 전역변수들..
	String screen_id = tmpId;
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
 
   if( !"".equals(MAX_CONT_GL_SEQ) ){
    	MAX_CONT_GL_SEQ = "" + (Integer.parseInt(MAX_CONT_GL_SEQ) + 1);
    	if( MAX_CONT_GL_SEQ.length() == 1 )       MAX_CONT_GL_SEQ = "00" + MAX_CONT_GL_SEQ;
    	else if( MAX_CONT_GL_SEQ.length() == 2 )  MAX_CONT_GL_SEQ = "0"  + MAX_CONT_GL_SEQ;
   }
 
    // FAULT_INS_TERM 개월수로 입력되어있는 데이터를 ->  년, 월 로 구분 
    String FAULT_INS_TERM_MON = ""; // 개월
    
    Logger.sys.println("FAULT_INS_TERM1 = " + FAULT_INS_TERM);
    if( !"".equals( FAULT_INS_TERM ) && !"0".equals( FAULT_INS_TERM ) ){
	    
	    
	    FAULT_INS_TERM_MON = "" + Integer.parseInt(FAULT_INS_TERM) % 12;
	    Logger.sys.println("FAULT_INS_TERM_MON = " + FAULT_INS_TERM_MON);
	        
	    FAULT_INS_TERM  = "" + Integer.parseInt(FAULT_INS_TERM) / 12; 
	    Logger.sys.println("FAULT_INS_TERM2 = " + FAULT_INS_TERM);
	    
	    
		if(FAULT_INS_TERM.equals("0")) FAULT_INS_TERM = "";
    }else{
    	FAULT_INS_TERM = "";
    }
    
    // MA, BD(구매입찰)
    String divStyle = "";
    
    Logger.sys.println("@@@@@@@@@@@  RFQ_TYPE = " + RFQ_TYPE);
    
    if( "MA".equals(RFQ_TYPE) ){
    	divStyle = "display:none";
    }else{
    	divStyle = "display:inline";
    }
    
    // 부가세포함여부
    String checkY = "";
    String checkX = "";
    
    if( "Y".equals( ADD_TAX_FLAG ) ){
    	checkY = "checked";
    	checkX = "";
    }else{
    	checkY = "";
    	checkX = "checked";    	
    }
 
    
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>
<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_wait_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	<%
    	if(!"".equals(EXEC_NO)){
    	%>
        	GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,단가,금액,단가,금액,단가,금액,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
    	<%		
    	}
    	%>    	
    	
    	GridObj.setSizes();
    }

	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		
		if(status == "false") alert(msg);
		

		for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
			GridObj.enableSmartRendering(true);
			GridObj.selectRowById(GridObj.getRowId(i), false, true);
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
    		//document.form.cont_gubun.value = "<%=CONT_GUBUN%>";
		}

		document.form.cont_amt.value = add_comma("<%=CONT_AMT %>", 0);
		document.form.cont_date.value = add_Slash(document.form.cont_date.value);
		
  		return true;
    }
    
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);
    }
    
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
			
		} else if(stage==2) {
	    	var header_name = GridObj.getColumnId(cellInd);
	    	
	    	if( header_name == "SETTLE_QTY" || header_name == "UNIT_PRICE")
			{
				var	rfq_qty    = GridObj.cells(rowId, GridObj.getColIndexById("SETTLE_QTY")).getValue();
				var	unit_price = GridObj.cells(rowId, GridObj.getColIndexById("UNIT_PRICE")).getValue();
				
				var item_amt     = floor_number(eval(rfq_qty) * eval(unit_price), 2);
				var supply_amt   = item_amt;
				var supertax_amt = 0;
				
				GridObj.cells(rowId, GridObj.getColIndexById("ITEM_AMT")).setValue(item_amt);
				GridObj.cells(rowId, GridObj.getColIndexById("SUPPLY_AMT")).setValue(supply_amt);
				GridObj.cells(rowId, GridObj.getColIndexById("SUPERTAX_AMT")).setValue(supertax_amt);
				
				//getIvnAmtSum();
			}
			
			return true;
		}
		return false;
    }
    
    // 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택하세요.");
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
			
			if(mode == "setConfirm")
			{
				var cont_no     = "<%=CONT_NO%>";
				var cont_gl_seq = "<%=MAX_CONT_GL_SEQ%>";
				location.href   = "contract_create_list_update.jsp?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq;
			}else{
				var cont_no     = "<%=CONT_NO%>";
				var cont_gl_seq = "<%=MAX_CONT_GL_SEQ%>";
				location.href   = "contract_create_list_update.jsp?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq;
			}
			
		} else {
			alert(messsage);
		}

		return false;
	}
	
	function doSave(){
		
		
		
		var subject					= LRTrim(document.form.subject.value);    
//		var cont_gubun				= LRTrim(document.form.cont_gubun.value);//계약구분
		var sg_type1				= LRTrim(document.form.sg_type1.value);  //소싱그룹대분류
		var sg_type2				= LRTrim(document.form.sg_type2.value);  //소싱그룹중분류
		var sg_type3				= LRTrim(document.form.sg_type3.value);  //소싱그룹소분류					 
		var seller_code				= LRTrim(document.form.seller_code.value);						//업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);						//업체명
		var sign_person_id			= LRTrim(document.form.sign_person_id.value);					//계약담당자 id
		var sign_person_name		= LRTrim(document.form.sign_person_name.value);					//계약담당자 name
		var cont_from				= LRTrim(document.form.cont_from.value);				//계약기간 from
		var cont_to					= LRTrim(document.form.cont_to.value);  				//계약담당자 name
		var before_cont_from		= LRTrim(document.form.before_cont_from.value);				//계약기간 from
		var before_cont_to			= LRTrim(document.form.before_cont_to.value);               //계약기간 to
		var cont_date				= LRTrim(document.form.cont_date.value);             //작성일자
		var cont_add_date			= LRTrim(document.form.cont_add_date.value);         //계약일자
		var cont_type				= LRTrim(document.form.cont_type.value);                        //계약종류
		var ele_cont_flag			= LRTrim(document.form.ele_cont_flag.value);                    //전자계약작성여부
		var assure_flag				= LRTrim(document.form.assure_flag.value);                      //보증구분
		var cont_process_flag		= LRTrim(document.form.cont_process_flag.value);                //계약방법
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));               //계약방법
		var before_cont_amt			= LRTrim(del_comma(document.form.before_cont_amt.value));				//계약금액
		var add_tax_flag = "";
		if( document.form.add_tax_flag[0].checked == true ) add_tax_flag	= document.form.add_tax_flag[0].value;// 부가세포함여부
		if( document.form.add_tax_flag[1].checked == true ) add_tax_flag	= document.form.add_tax_flag[1].value;// 부가세포함여부
		var cont_assure_percent		= LRTrim(document.form.cont_assure_percent.value);				//계약보증금(%)
		var cont_assure_amt			= LRTrim(del_comma(document.form.cont_assure_amt.value));		//계약보증금(원)
		var fault_ins_percent		= LRTrim(document.form.fault_ins_percent.value);				//하자보증금(%)
		var fault_ins_amt			= LRTrim(del_comma(document.form.fault_ins_amt.value));			//하자보증금(원)
		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);                   //하자보증기간 (년)
		var fault_ins_term_mon 	    = LRTrim(document.form.fault_ins_term_mon.value);               //하자보증기간 (월)
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		fault_ins_term = fault_ins_term = YearChangeMonth( fault_ins_term, fault_ins_term_mon );
		
		var bd_no					= LRTrim(document.form.bd_no.value);                            //입찰/견적서번호
		var bd_count				= LRTrim(document.form.bd_count.value);							//입찰/견적서차수
		var text_number				= LRTrim(document.form.text_number.value);						//문서번호
		var delay_charge			= LRTrim(document.form.delay_charge.value);						//지체상금율
		var remark					= LRTrim(document.form.remark.value);							//비고
		var ctrl_demand_dept		= "<%=CTRL_DEMAND_DEPT%>";										//계약담당자부서
		var cont_no					= "<%=CONT_NO%>";
		var cont_gl_seq             = "<%=MAX_CONT_GL_SEQ%>";
		var rfq_type                = "<%=RFQ_TYPE%>";
		var cont_type1_text		    = LRTrim(document.form.cont_type1_text.value);//입찰방법
		var cont_type2_text		    = LRTrim(document.form.cont_type2_text.value);//낙찰방법		
		
		var delv_place			    = LRTrim(document.form.delv_place.value);
		var item_type				= LRTrim(del_Slash(document.form.item_type.value));//물품종류
		var before_item_type		= LRTrim(del_Slash(document.form.before_item_type.value));//물품종류
		var before_rd_date			= LRTrim(del_Slash(document.form.before_rd_date.value));//납품기한
		var rd_date					= LRTrim(del_Slash(document.form.rd_date.value));//납품기한
		var cont_total_gubun		= LRTrim(document.form.cont_total_gubun.value);//계약단가
		var cont_price				= LRTrim(document.form.cont_price.value);//계약단가
		var ttl_item_qty			= "<%=TTL_ITEM_QTY%>";
		var exec_no					= "<%=EXEC_NO%>";
		
		<%
		if("".equals(EXEC_NO)){
		%>
			dhtmlx_last_row_id++;
			var nMaxRow2 = dhtmlx_last_row_id;
			var row_data = "<%=grid_col_id%>";
			GridObj.enableSmartRendering(true);
			GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
			GridObj.selectRowById(nMaxRow2, false, true);
		
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ANN_ITEM")).setValue(subject);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("delv_place")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("DLVRYDSREDATE")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("bid_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ee_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("join_vendor_cnt")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("VENDOR_NAME")).setValue(seller_name);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ASUMTNAMT")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("ESTM_PRICE")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("FINAL_ESTM_PRICE_ENC")).setValue("");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("SUM_AMT")).setValue(cont_amt);
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("CUR")).setValue("WON");
			GridObj.cells(nMaxRow2, GridObj.getColIndexById("VENDOR_CODE")).setValue(seller_code);	 
		<%
		}
		%> 		
		
		if( subject == "" ) {
			alert("계약명을 입력하세요.");
			document.form.subject.select();
			return;
		}
		 
		if( seller_code == "" ) {
			alert("업체코드을 입력 하세요.");
			return;
		}
		
		if( sign_person_id == "" ) {
			alert("계약담당자를 입력 하세요.");
			return;
		}
		
		if( cont_from == "" || cont_to == "" ) {
			alert("계약기간을 입력하세요.");
			document.form.cont_from.select();
			return;
		}
		
        if( !checkDate(del_Slash(cont_from)) ) {
            alert("계약기간을 확인하세요.");
			document.form.cont_from.select();
            return;
        }
        
        if( !checkDate(del_Slash(cont_to)) ) {
            alert("계약기간을 확인하세요.");
			document.form.cont_to.select();
            return;
        }
        
        if( cont_from > cont_to ) {
            alert("계약시작일자가 종료일자보다 클 수는 없습니다.");
			document.form.cont_from.select();
            return;
        }
       
        if( document.form.ele_cont_flag.value == "Y" && cont_add_date != "" ) {
        	alert("전자계약서작성여부가 Yes인경우에는 계약일자를 작성하실 수 없습니다.");
        	document.form.cont_add_date.value = "";
        	return;
        }
       
        if( cont_add_date != "" && cont_add_date >= cont_from ){
        	alert("계약일자가 계약기간보다 클 수 없습니다.");
        	return;
        }
        
        if( cont_add_date != "" && !checkDate(del_Slash(cont_add_date)) ) {
        	alert("계약일자를  확인하세요.");
			document.form.cont_add_date.select();
            return;
        }
        
		if( cont_type ==  "" ) {
			alert("계약종류를 입력하세요.");
			return;
		}
		
		if( assure_flag ==  "" ) {
			alert("보증구분을 선택하세요.");
			return;
		}
		
		if( cont_process_flag == "" ) {
        	alert("계약방법을 선택하세요.");
        	return;
        }
		
        if( cont_amt == "" ) {
        	alert("계약금액을 입력하세요.");
			document.form.cont_amt.select();
        	return;
        }
        
		if( document.form.ele_cont_flag.value == "N" ) {
			if(document.form.cont_add_date.value == "") {
				alert("계약일자를 입력하세요.");
				document.form.cont_add_date.select();
				return;
			}
		}
		
		if( parseInt(document.form.cont_assure_percent.value) > 100 ) {
			alert("계약보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if( parseInt(document.form.fault_ins_percent.value) > 100 ) {
			alert("하자보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if( parseInt(fault_ins_term_mon) >= 12 ){
			alert("하자보증기간(개월)입력이 잘못되었습니다.");
			return;
		}
		
		if( parseInt(document.form.delay_charge.value) > 100 ) {
			alert("지체상금율은 100을 넘을 수 없습니다.");
			return;
		}
		
		if(cont_total_gubun == "C" && (cont_price == "" ||cont_price == "0")){
			alert("계약단가를 입력하세요.");
			document.form.cont_price.focus();
			return;
		}	
		
		if( remark.length > 750 ) {
			alert("비고는 350글자를 넘을 수 없습니다.");
			return;
		}
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);

		var param   = "&subject="				+ encodeUrl(subject);
//			param  += "&cont_gubun="			+ encodeUrl(cont_gubun);
			param  += "&sg_type1="				+ encodeUrl(sg_type1);
			param  += "&sg_type2="				+ encodeUrl(sg_type2);
			param  += "&sg_type3="				+ encodeUrl(sg_type3);
			param  += "&seller_code="			+ encodeUrl(seller_code);
			param  += "&seller_name="			+ encodeUrl(seller_name);
			param  += "&sign_person_id="		+ encodeUrl(sign_person_id);
			param  += "&sign_person_name="		+ encodeUrl(sign_person_name);
			param  += "&cont_from="				+ encodeUrl(cont_from);
			param  += "&cont_to="				+ encodeUrl(cont_to);
			param  += "&before_cont_from="		+ encodeUrl(before_cont_from);
			param  += "&before_cont_to="		+ encodeUrl(before_cont_to);
			param  += "&cont_date="				+ encodeUrl(cont_date);
			param  += "&cont_add_date="			+ encodeUrl(cont_add_date);
			param  += "&cont_type="				+ encodeUrl(cont_type);
			param  += "&ele_cont_flag="			+ encodeUrl(ele_cont_flag);
			param  += "&assure_flag="			+ encodeUrl(assure_flag);
			param  += "&cont_process_flag="		+ encodeUrl(cont_process_flag);
			param  += "&cont_amt="				+ encodeUrl(cont_amt);
			param  += "&before_cont_amt="		+ encodeUrl(before_cont_amt);
			param  += "&add_tax_flag="			+ encodeUrl(add_tax_flag);
			param  += "&cont_assure_percent="	+ encodeUrl(cont_assure_percent);
			param  += "&cont_assure_amt="		+ encodeUrl(cont_assure_amt);
			param  += "&fault_ins_percent="		+ encodeUrl(fault_ins_percent);
			param  += "&fault_ins_amt="			+ encodeUrl(fault_ins_amt);
			param  += "&fault_ins_term="		+ encodeUrl(fault_ins_term);
			param  += "&bd_no="					+ encodeUrl(bd_no);
			param  += "&bd_count="				+ encodeUrl(bd_count);
			param  += "&text_number="			+ encodeUrl(text_number);
			param  += "&delay_charge="			+ encodeUrl(delay_charge);
			param  += "&remark="				+ encodeUrl(remark);
			param  += "&ctrl_demand_dept="		+ encodeUrl(ctrl_demand_dept);
			param  += "&cont_no="				+ encodeUrl(cont_no);
			param  += "&cont_gl_seq="			+ encodeUrl(cont_gl_seq);
			param  += "&rfq_type="			    + encodeUrl(rfq_type);
			param  += "&cont_type1_text="		+ encodeUrl(cont_type1_text);	
			param  += "&cont_type2_text="		+ encodeUrl(cont_type2_text);	
			param  += "&delv_place="		    + encodeUrl(delv_place);		
			param  += "&item_type="		    	+ encodeUrl(item_type);			
			param  += "&before_item_type="		+ encodeUrl(before_item_type);	
			param  += "&before_rd_date="		+ encodeUrl(before_rd_date);		
			param  += "&rd_date="		    	+ encodeUrl(rd_date);	
			param  += "&cont_total_gubun="		+ encodeUrl(cont_total_gubun);
			param  += "&cont_price="			+ encodeUrl(cont_price);
			param  += "&ttl_item_qty="			+ encodeUrl(ttl_item_qty);		
			param  += "&exec_no="				+ encodeUrl(exec_no);		
			
		var msg = "저장 하시겠습니까?";
		/*
		var tot_amt = 0;  
		for( var i= dhtmlx_start_row_id ; i < dhtmlx_last_row_id; i++ ) {
			tot_amt += parseInt(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SUM_AMT")).getValue());
		}
		if(tot_amt != del_comma(document.form.cont_amt.value)) {
			msg = "계약금액이 맞지 않습니다. \n계속 하시겠습니까?";
		} else {
			msg = "저장 하시겠습니까?";
		}
		*/
	    if (confirm(msg)) {
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=changeinsert&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
	}	
	 
	function doSelect111() {
	<%
		if(!"".equals(EXEC_NO)){
	%>
			var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_ins1";
			
			var cols_ids = "<%=grid_col_id%>";
			var params = "mode=getEXDTInfo";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			GridObj.post( G_SERVLETURL, params );
			GridObj.clearAll(false);
	<%	
		}
	%>
	}

	function YearChangeMonth( fault_ins_term, fault_ins_term_mon ){
		if( fault_ins_term == "" )     fault_ins_term = 0;
		if( fault_ins_term_mon == "" ) fault_ins_term_mon = 0;
	
		var month = 0;
		    month = (parseInt(fault_ins_term) * 12) + parseInt(fault_ins_term_mon);
		
		return month;
	}
    
   function getCtrlPersonId() {
	   window.open("/common/CO_008.jsp?callback=setCtrlPerson", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	   //var buyer_company_code = '<%=info.getSession("USER_TYPE").equals("S") ? buyer_company_code : info.getSession("COMPANY_CODE")%>';
	   //var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0255&function=setCtrlPerson&values=<%=buyer_company_code%>&values=P&values=<%=info.getSession("CTRL_CODE")%>&values=&values=";
       //Code_Search(url, '', '', '', '600', '500');	   	  		
	}

	function setCtrlPerson(code, text1) {
	    document.forms[0].sign_person_id.value = code  ;
	    document.forms[0].sign_person_name.value = text1 ;
	}
	
	var com_flag = "";
	function setValue(setDate, flag) {
		document.form.setTemp.value = setDate;
		com_flag = flag;
	}
	
	function PopupManager(objForm, name)
	{
		if(name =="seller_code")
		{
			//PopupCommon1( "SP0054", "D",  "", "업체코드", "업체명" );//업체코드,업체명
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	function SP0054_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
		document.fobefore_seller_name.value = text1;
	
	}
	
	function initAjax(){
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type'			, '<%=CONT_TYPE%>' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag'		, '<%=ELE_CONT_FLAG%>');//전자계약작성여부
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag'			, '<%=ASSURE_FLAG%>');//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, '<%=CONT_PROCESS_FLAG%>' );//계약방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '<%=CONT_TYPE1_TEXT%>' );//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '<%=CONT_TYPE2_TEXT%>' );//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun'	, '<%=CONT_TOTAL_GUBUN%>' );//계약단가
		
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '<%=SG_LEV1%>' );
		doRequestUsingPOST( 'W001', '2' ,'sg_type2', '<%=SG_LEV2%>' );
		doRequestUsingPOST( 'W001', '3' ,'sg_type3', '<%=SG_LEV3%>' );		
		
		// 3자리 콤마 
		document.form.cont_assure_amt.value = add_comma(document.form.cont_assure_amt.value, "0");
		document.form.fault_ins_amt.value    = add_comma(document.form.fault_ins_amt.value, "0");
	}
	
	function getIvnAmtSum(){
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var item_amt = 0; 
		
		for(var i=0; i<grid_array.length;i++) {
			item_amt += eval(GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_AMT")).getValue());
		}
		
		if(item_amt == null) item_amt = 0;
		
		var item_amt_comma = add_comma(item_amt, "0");
		
		document.form.cont_amt.value = item_amt_comma;
		
		getAmtPercent(document.form.cont_assure_percent.value, 'cont_assure_amt');
    	getAmtPercent(document.form.fault_ins_percent.value, 'fault_ins_amt');
		
	}
	
	function getContAmt(){
		 
		getAmtPercent(document.form.cont_assure_percent.value, 'cont_assure_amt');
    	getAmtPercent(document.form.fault_ins_percent.value, 'fault_ins_amt');
		
	}
	
	function getAmtPercent(percent, name)
	{
		var cont_amt = del_comma(document.form.cont_amt.value);
		var percent_amt = 0;		
		
		document.getElementsByName(name)[0].value = "";
		
		if(cont_amt == "" || percent == "") 
		{
			document.getElementsByName(name)[0].value = "0";
			return;
		}
		
		percent_amt = eval(cont_amt) * ( eval(percent) / 100);
		
		document.getElementsByName(name)[0].value = add_comma( percent_amt);
	}
	
	
	function getCheckDate(strValue, message)
	{
		if(strValue == "") {
			alert(message + "을(를) 입력하세요.");
			return false;
		}
		
		if(!checkDate(del_Slash(strValue))) {
            alert(message + "을(를) 확인하세요.");
            return false;
        }
	
	}

	function chele_cont_flag() {
		var ele_cont_flag = document.form.ele_cont_flag.value;
		
		if(ele_cont_flag == "Y") {
			document.form.cont_add_date.value = "";
			document.form.cont_add_date.readOnly = true;
		} else if(ele_cont_flag == "N") {
			document.form.cont_add_date.readOnly = false;
		}
	}
	
	function doDefault() {
		if("<%=button%>" == "N") {
			document.form.subject.readOnly  = true;
			document.form.subject.className = "input_empty";
			
			//document.form.cont_gubun.disabled = true;//select
			//document.form.property_yn.disabled = true;//select
			
			document.form.seller_name.readOnly  = true;
			document.form.seller_name.className = "input_empty";
			
			document.form.sign_person_id.readOnly  = true;
			document.form.sign_person_id.className = "input_empty";
			
			document.form.sign_person_name.readOnly  = true;
			document.form.sign_person_name.className = "input_empty";
			
			document.form.cont_from.readOnly  = true;
			document.form.cont_from.value = add_Slash(document.form.cont_from.value);
			document.form.cont_from.className = "input_empty";
			
			document.form.cont_to.readOnly  = true;
			document.form.cont_to.value     = add_Slash(document.form.cont_to.value);
			document.form.cont_to.className = "input_empty";
			
			document.form.cont_date.readOnly  = true;
			document.form.cont_date.value     = add_Slash(document.form.cont_date.value);
			document.form.cont_date.className = "input_empty";
			
			document.form.cont_add_date.readOnly  = true;
			document.form.cont_add_date.value     = add_Slash(document.form.cont_add_date.value);
			document.form.cont_add_date.className = "input_empty";
			
			document.form.cont_type.disabled = true;//select
			
			document.form.ele_cont_flag.readOnly  = true;
			document.form.ele_cont_flag.className = "input_empty";
			
			document.form.assure_flag.disabled = true;//select
		//	document.form.start_start_ins_flag.disabled = true;//select
			document.form.cont_process_flag.disabled = true;//select
			
			document.form.cont_amt.readOnly  = true;
			document.form.cont_amt.className = "input_empty";
			
			document.form.cont_assure_percent.readOnly  = true;
			document.form.cont_assure_percent.className = "input_empty";
			
			document.form.cont_assure_amt.readOnly  = true;
			document.form.cont_assure_amt.className = "input_empty";
			
			document.form.fault_ins_percent.readOnly  = true;
			document.form.fault_ins_percent.className = "input_empty";
			
			document.form.fault_ins_amt.readOnly  = true;
			document.form.fault_ins_amt.className = "input_empty";
			
			//document.form.pay_div_flag.disabled = true;//select
			document.form.fault_ins_term.readOnly  = true;
			document.form.fault_ins_term.className = "input_empty";
			
			document.form.fault_ins_term_mon.readOnly  = true;
			document.form.fault_ins_term_mon.className = "input_empty";
			
			document.form.bd_no.readOnly  = true;
			document.form.bd_no.className = "input_empty";
			
			//document.form.amt_gubun.disabled = true;//select
			document.form.text_number.readOnly  = true;
			document.form.text_number.className = "input_empty";
			
			document.form.delay_charge.readOnly  = true;
			document.form.delay_charge.className = "input_empty";
			
			document.form.remark.readOnly  = true;
			
			//document.form.delv_place.readOnly = true;
			document.form.ele_cont_flag.disabled = true;//select
			
			GridObj.setColumnExcellType(5,"ro");
			GridObj.setColumnExcellType(6,"ro");
		}
	}
	
	//처리과목 팝업
	function doBudget()
    {
    	var flag = "";
    	popUpOpen("../sourcing/account_budget_list.jsp?popup_flag=true&flag=" + flag , 'ACCOUNT_BUDGET_LIST', '805', '600');
    }

	function setBudget(accounts_courses_code, accounts_courses_loc, accounts_budget_amt)
	{
		document.form.account_code.value = accounts_courses_code;
		document.form.account_name.value = accounts_courses_loc;

	}
	
	
	
	function getConfirmPersonId() {
   		var buyer_company_code = '<%=info.getSession("USER_TYPE").equals("S") ? buyer_company_code : info.getSession("COMPANY_CODE")%>';
		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP9114&function=setConfirmPerson&values=&values=";
       	Code_Search(url, '', '', '', '600', '500');
	}
	
	function setConfirmPerson(code, text1) {
	    document.forms[0].confirm_person_id.value = code;
	    document.forms[0].confirm_person_name.value = text1;
	}
	
	function nextAjax( type ){
		var f = document.forms[0];
		
		if( type == '2' ){
			var sg_refitem  = f.sg_type1.value;
			var sg_type2_id = eval(document.getElementById('sg_type2')); //id값 얻기
			
			sg_type2_id.options.length = 0;    //길이 0으로
			//sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				
				eval(document.getElementById('sg_type3')).options.length = 0;     //길이 0으로
				
				var nodePath3  = document.getElementById("sg_type3");
				var ooption3   = document.createElement("option");
				ooption3.text  = "--------";
				ooption3.value = "";
				nodePath3.add(ooption3);
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
		else if( type == '3' ){
			var sg_refitem  = f.sg_type2.value;
			var sg_type3_id = eval(document.getElementById('sg_type3')); //id값 얻기
			
			sg_type3_id.options.length = 0;     //길이 0으로
			//sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type3_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ) {
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '3'+'#'+sg_refitem ,'sg_type3', '' );
			}
			else{
				var nodePath  = document.getElementById("sg_type3");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}		
</Script>
</head>
<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();doSelect111();">
<s:header>
<form id="form" name="form">
<input type="hidden" id="exec_no" 			name="exec_no" 			value="<%=EXEC_NO%>">
<input type="hidden" id="pay_div_cnt"		name="pay_div_cnt"		>
<input type="hidden" id="cont_no" 			name="cont_no" 			value="<%=cont_no%>">
<input type="hidden" id="flag" value="U"	name="flag" value="U"	>
<input type="hidden" id="dilv_term"			name="dilv_term"		>
<input type="hidden" id="po_cont_flag"		name="po_cont_flag"		>
<input type="hidden" id="pay_div_count"		name="pay_div_count"	>

<%
    String title = "변경계약서 작성";
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = title;	
%>

    <%@ include file="/include/sepoa_milestone.jsp"%>
    
    
    
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  						<tr>
	  							<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약번호</td>
	  							<td width="30%" height="24" class="data_td"><%=CONT_NO%></td>
	  							<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
	  							<td width="30%" height="24" class="data_td"><%=MAX_CONT_GL_SEQ%></td>	  				
	  						</tr>
						</table>
					</td>
				</tr>
			</table>
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
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="subject" name="subject" size="35" value="<%=SUBJECT%>">
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약상태
        						</td>
        						<td width="30%" 	height="24" class="data_td">
        							<%=CT_FLAG_TEXT%>
        						</td>
			  				</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>				  		
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약구분<font color='red'><b>*</b></font>
        						</td>	
        						<td width="30%" height="24" class="data_td">
			    					<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');">
			    						<option value="">--------</option>
			    					</select>
			    	
			    					<select id="sg_type2" name="sg_type2" class="inputsubmit" onchange="nextAjax('3');">
			    						<option value="">--------</option>
			    					</select>
			    	
			    					<select id="sg_type3" name="sg_type3" class="inputsubmit">
			    						<option value="">--------</option>
			    					</select>        			
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약방법<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_process_flag" name="cont_process_flag"></select><!-- M809 -->
        						</td>        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							업체명<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="hidden" id="seller_code" name="seller_code" value="<%=SELLER_CODE%>">
        							<input type="text"   id="seller_name" name="seller_name" value="<%=SELLER_NAME%>" readonly>
        						</td>
       							<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							입찰방법
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_type1_text" name="cont_type1_text">
        								<option value=""></option>
        							</select><!-- M994 -->&nbsp;&nbsp;
        							<select id="cont_type2_text" name="cont_type2_text">
        								<option value=""></option>
        							</select><!-- M993 -->        			
        						</td>        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경전 계약기간
        						</td>
        						<td width="30%" height="24" class="data_td"><%=SepoaString.dateStr(CONT_FROM)%>&nbsp;~&nbsp;&nbsp;<%=SepoaString.dateStr(CONT_TO)%>
        							<input type="hidden" id="before_cont_from" name="before_cont_from" size="8" maxlength="8" value="<%=CONT_FROM%>" readonly>  
				    				<input type="hidden" id="before_cont_to"   name="before_cont_to"   size="10" maxlength="10" value="<%=CONT_TO%>" readonly> 
         						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약담당자<font color='red'><b>*</b></font>
        						</td>
        							<% if(!info.getSession("USER_TYPE").equals("S")) { %>
        							<td  width="30%" height="24" class="data_td">
        							<input type="text" id="sign_person_id" name="sign_person_id" value="<%=info.getSession("ID")%>" onkeyup="delInputEmpty('sign_person_id', 'sign_person_name')" size="10">
        							<%if( !"N".equals(button) ){ %>
									<a href="javascript:getCtrlPersonId()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
									<%} %>
			        				<input type="text" id="sign_person_name" name="sign_person_name" value="<%=info.getSession("NAME_LOC")%>" size="10" readonly class="input_empty">
        						</td>
        						<% } else { %>
	        					<td width="30%" height="24" class="data_td">
	        						<input type="hidden" id="sign_person_id"   name="sign_person_id"   value="<%=SIGN_PERSON_ID%>" onkeyup="delInputEmpty('sign_person_id', 'sign_person_name')" size="10">
				        			<input type="text"   id="sign_person_name" name="sign_person_name" value="<%=SIGN_PERSON_NAME%>" size="10" readonly class="input_empty">
        						</td>
        						<% } %>         		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경후 계약기간<font color='red'><b>*</b></font>
        						</td>
			        			<td height="24" class="data_td">
									<%if( !"N".equals(button) ){ %>
			        				<s:calendar id_from="cont_from" id_to="cont_to" default_from="<%=SepoaString.getDateSlashFormat(CONT_FROM)%>" default_to="<%=SepoaString.getDateSlashFormat(CONT_TO)%>" format="%Y/%m/%d" />
							    	<%}else{ %>
							    	<input type="text" id="cont_from" name="cont_from" size="10" maxlength="10" value="">~&nbsp;&nbsp;
							    	<input type="text" id="cont_to" name="cont_to" size="10" maxlength="10" value="">
							    	<%} %>	
			         			</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							작성일자<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
	                				<%--input type="text" name="cont_date" size="8" maxlength="8" value="<%=CONT_DATE %>"--%>
	                				<s:calendar id="cont_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString()) %>" format="%Y/%m/%d" />
        						</td>        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약일자<font color='red'><b>*</b></font>
        						</td>
			        			<td height="24" class="data_td">
									<%if( !"N".equals(button) ){ %>
			        				<s:calendar id="cont_add_date" default_value="<%=SepoaString.getDateSlashFormat(CONT_ADD_DATE)%>" format="%Y/%m/%d"/>
			        				<%}else{ %>
			        				<input type="text" id="cont_add_date" name="cont_add_date" size="8" maxlength="8" value="<%=SepoaString.getDateSlashFormat(CONT_ADD_DATE)%>" format="%Y/%m/%d" readonly="readonly">
			        				<%} %>
			        			</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약종류<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
	                				<select id="cont_type" name="cont_type" class="inputsubmit"><!-- M800 -->
										<option value="">----------------</option>
									</select>
        						</td>        		
        	  				</tr>
        	  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
        	  				<tr>
        						<td width="20%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							전자계약서작성 여부
        						</td>
        						<td width="30%" height="24" class="data_td">
	               					<select id="ele_cont_flag" name="ele_cont_flag" onchange="chele_cont_flag()"></select><!-- M806 -->
        						</td>
       							<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							보증구분<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
	               					<select id="assure_flag" name="assure_flag"></select><!-- M807 -->
        						</td>        		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경전 계약금액
        						</td>
        						<td width="30%" height="24" class="data_td"><%=SepoaString.formatNum(Double.parseDouble(CONT_AMT))%> (원) 
        							<input type="hidden" size="15" maxlength="50" name="before_cont_amt" value="<%=CONT_AMT%>" readonly>
        							<% if( "BD".equals( RFQ_TYPE ) ){%>
									<%if( "Y".equals( ADD_TAX_FLAG ) ){ %>
									부가세포함
									<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" <%=checkX%> style="display:none;">
									<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" <%=checkX%> style="display:none;">
									<%}else{ %>
									면세
									<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" <%=checkX%> style="display:none;">
									<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" <%=checkX%> style="display:none;">							
									<%} %>
        							<% }else{%>
        							&nbsp;<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" <%=checkY%> disabled>부가세포함&nbsp;
        							&nbsp;<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" <%=checkX%> disabled>면세        			        			
        							<%} %>
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약보증금
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="cont_assure_percent" name="cont_assure_percent" dir="rtl" size="3" value="<%=CONT_ASSURE_PERCENT%>" onchange="getAmtPercent('form.cont_assure_percent.value', 'cont_assure_amt')">(%)
        							&nbsp;
		       						<input type="text" id="cont_assure_amt" name="cont_assure_amt" dir="rtl" size="12" value="<%=CONT_ASSURE_AMT%>" maxlength="12" class="input_empty"  readonly="readonly">(원)
		       					</td>         		
			  				</tr>        	
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>	
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경후 계약금액<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="15" maxlength="50" name="cont_amt" dir="rtl" value="<%=CONT_AMT%>" onchange="getContAmt()">
        						</td>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							하자보증기간
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term" name="fault_ins_term" value="<%=FAULT_INS_TERM%>"> 년
									<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term_mon" name="fault_ins_term_mon" value="<%=FAULT_INS_TERM_MON%>"> 개월
        						</td>       		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
								<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							하자보증금
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="fault_ins_percent" name="fault_ins_percent" dir="rtl" size="3" value="<%=FAULT_INS_PERCENT%>" onchange="getAmtPercent('form.fault_ins_percent.value', 'fault_ins_amt')">(%)
        							&nbsp;
		       						<input type="text" id="fault_ins_amt" name="fault_ins_amt" dir="rtl" size="12" value="<%=FAULT_INS_AMT%>" maxlength="12" class="input_empty"  readonly="readonly">(원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							소싱번호
        						</td>
        						<td width="30%" height="24" class="data_td">
			        				<%
			        				String sNo = "";
			        				if(!"".equals(rfq_no))	sNo = rfq_no + " / " + rfq_count;
			        				%>
			        				<%=sNo %>				        			
				        			<input type="hidden" size="20" id="bd_no" name="bd_no" value="<%=rfq_no%>" readonly>
				        			<input type="hidden" size="10" id="bd_count" name="bd_count" value="<%=rfq_count%>">        							
        							
        						</td>   		
			  				</tr>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
	        					<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							지체상금율(%)
        						</td>
        						<td width="30%" height="24" class="data_td">
        							1000 분의 &nbsp;&nbsp;<input type="text" size="3" id="delay_charge" name="delay_charge" dir="rtl" value="<%=DELAY_CHARGE%>">
        						</td> 
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
    	    						구매결의번호
	        					</td>
        						<td width="30%" height="24" class="data_td">
        							<%=EXEC_NO%>
        							<input type="hidden" size="20" id="text_number" name="text_number" value="<%=TEXT_NUMBER%>" readonly="readonly">
        						</td>
			  				</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경전 품목
        						</td>
        						<td width="30%" height="24" class="data_td"><%=ITEM_TYPE %>
        							<input type="hidden" size="20" id="before_item_type" name="before_item_type" value="<%=ITEM_TYPE %>" readonly>
    	    					</td>
	         					<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경전 납품기한
        						</td>
        						<td width="30%" height="24" class="data_td"><%=SepoaString.dateStr(RD_DATE) %>
	            	    			<input type="hidden" id="before_rd_date" name="before_rd_date" size="8" maxlength="8" value="<%=RD_DATE %>"> 
        						</td>
				  			</tr>
				  			<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
				  			<tr>
	        					<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경후 품목
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="item_type" name="item_type" value="<%=ITEM_TYPE %>">
        						</td>
         						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경후 납품기한
        						</td>
        		
			        			<td height="24" class="data_td">
				                	<%if( !"N".equals(button) ){ %>
				                	<s:calendar id="rd_date" default_value="<%=SepoaString.getDateSlashFormat(RD_DATE) %>" format="%Y/%m/%d" />
							    	<%}else{ %>
				                	<input type="text" id="rd_date" name="rd_date" size="8" maxlength="8" value="<%=SepoaString.getDateSlashFormat(RD_DATE) %>" format="%Y/%m/%d" readonly="readonly">
							    	<%} %>
			        			</td>        		
			  				</tr>	
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							납품장소
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="delv_place" name="delv_place" value="<%=DELV_PLACE%>" size="40">
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약단가
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_total_gubun" name="cont_total_gubun">
        								<option value=""></option>
        							</select><!-- M813 -->&nbsp;<input type="text" name="cont_price" value="<%=CONT_PRICE %>">
        						</td>
			  				</tr>		
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>  
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							변경사유
        						</td>
        						<td width="30%" height="24" class="data_td" colspan="3">
        							<textarea id="remark" name="remark" class="inputsubmit" style="width: 98%;" rows="3"><%=REMARK%></textarea>
        						</td>
			  				</tr>
			  				<%if("CE".equals(CT_FLAG)){ %>
			  				<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			  					<td width="20%" height="24"  class="title_td">
			  						반려사유
			  					</td>
			  					<td width="30%" height="24" class="data_td" colspan="3">
			  						<input type="text" id="reject_reason" name="reject_reason" size="120" readonly="readonly" value="<%=REJECT_REASON %>">
			  					</td>
			  				</tr>
							<%} %>	
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</br>
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td>&nbsp;</td>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR> 
					<td><script language="javascript">btn("javascript:doSave()","저장")</script></td> 
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
</form>
<div style="display:<%=tmpId2%>">
	<table cellpadding="0" cellspacing="0" border="0" width="99%">
		<tr>
			<td style="text-decoration: underline; font-weight: bold" height="12px" align="right">
				(단위 : 원, 부가세 포함)
			</td>
		</tr>
		<tr>
			<td height="3px"></td>
		</tr>
	</table>
	<div id="gridbox" name="gridbox" width="100%"  height="200px" style="background-color:white;"></div>
</div>		
</s:header>
<s:footer/>
</body>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>