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
	
	String cont_no	    = JSPUtil.nullToEmpty(request.getParameter("cont_no")).trim();
	String cont_gl_seq	= JSPUtil.nullToEmpty(request.getParameter("cont_gl_seq")).trim();
	String button	    = JSPUtil.nullToEmpty(request.getParameter("button")).trim();
	String house_code	= info.getSession("HOUSE_CODE");
	
	if( "".equals(cont_gl_seq) ) cont_gl_seq = "001";

	String CONT_NO				= "";
	String CONT_GL_SEQ          = "";  
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
	
	
	String CONT_TYPE1_TEXT      = "";
	String CONT_TYPE2_TEXT      = "";


	String SG_LEV1				= "";
	String SG_LEV2				= "";
	String SG_LEV3				= "";
	String ADD_TAX_FLAG			= "";
	String ITEM_TYPE			= "";
	String RD_DATE				= "";
	String CONT_TOTAL_GUBUN		= "";
	String CONT_PRICE			= "";
	
	String EXEC_NO				= "";
	
	String REQ_DEPT= "";
	String REQ_DEPT_NAME= "";
	String APP_DATE= "";
	String PREV_SIGN_PERSON_ID= "";
	String PREV_SIGN_PERSON_NAME= "";
	String APP_AMT= "";
	String PR_DATE= "";
	String BUDGET_AMT= "";
	String PAY_DATE= "";
	String IN_PRICE_AMT= "";
	String BE_PRICE_AMT= "";
	String APP_REMARK= "";
	String AUTO_EXTEND_FLAG= "";
	String ITEM_QTY= "";
	String IN_ATTACH_NO= "";
	String IN_ATTACH_CNT= "";
	//String CONFIRM_USER_ID		= "";
	//String CONFIRM_USER_NAME		= "";	
	
	Object[] obj = {cont_no, cont_gl_seq};
	//SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","getContractUpdateSelect", obj);
	SepoaOut value = ServiceConnector.doService(info, "MAN_001", "TRANSACTION","getContractUpdateSelect", obj);
	SepoaFormater wf  = new SepoaFormater(value.result[0]);
	
	//DB에서 받아올값들 초기화
    if(wf.getRowCount() > 0) {
    	CONT_NO					= JSPUtil.nullToEmpty(wf.getValue("CONT_NO",				0));
    	CONT_GL_SEQ				= JSPUtil.nullToEmpty(wf.getValue("CONT_GL_SEQ",			0));
    	SUBJECT					= JSPUtil.nullToEmpty(wf.getValue("SUBJECT",				0));
//    	CONT_GUBUN     			= JSPUtil.nullToEmpty(wf.getValue("CONT_GUBUN",				0));
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
    	TEXT_NUMBER				= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",				0));
    	DELAY_CHARGE			= JSPUtil.nullToEmpty(wf.getValue("DELAY_CHARGE",			0));
    	DELV_PLACE				= JSPUtil.nullToEmpty(wf.getValue("DELV_PLACE",				0));
    	
    	REMARK					= JSPUtil.nullToEmpty(wf.getValue("REMARK",					0));
	   	CTRL_DEMAND_DEPT		= JSPUtil.nullToEmpty(wf.getValue("CTRL_DEMAND_DEPT",		0));     
	   	CT_FLAG_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG_TEXT",			0));   
	   	CT_FLAG					= JSPUtil.nullToEmpty(wf.getValue("CT_FLAG",				0));   
    	CTRL_CODE				= JSPUtil.nullToEmpty(wf.getValue("CTRL_CODE",				0));
    	COMPANY_CODE			= JSPUtil.nullToEmpty(wf.getValue("COMPANY_CODE",			0));  
    	RFQ_TYPE				= JSPUtil.nullToEmpty(wf.getValue("RFQ_TYPE",				0));  
    	REJECT_REASON			= JSPUtil.nullToEmpty(wf.getValue("REJECT_REASON",			0));  
    	//CONFIRM_USER_ID			= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_ID",	0));  
    	//CONFIRM_USER_NAME		= JSPUtil.nullToEmpty(wf.getValue("CONFIRM_USER_NAME",		0));
    	CONT_TYPE1_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE1_TEXT",		0));  
    	CONT_TYPE2_TEXT			= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE2_TEXT",		0)); 

	    SG_LEV1					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV1",				0)); 
		SG_LEV2					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV2",				0)); 
		ADD_TAX_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ADD_TAX_FLAG",			0));  
		ITEM_TYPE				= JSPUtil.nullToEmpty(wf.getValue("ITEM_TYPE",				0));  
		RD_DATE					= JSPUtil.nullToEmpty(wf.getValue("RD_DATE",				0));  
		CONT_TOTAL_GUBUN		= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN",		0));  
		CONT_PRICE				= JSPUtil.nullToEmpty(wf.getValue("CONT_PRICE",				0));     	 
		EXEC_NO					= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",				0));
		
		REQ_DEPT                = JSPUtil.nullToEmpty(wf.getValue("REQ_DEPT",				0));
		REQ_DEPT_NAME           = JSPUtil.nullToEmpty(wf.getValue("REQ_DEPT_NAME",			0));
		APP_DATE                = JSPUtil.nullToEmpty(wf.getValue("APP_DATE",				0));
		PREV_SIGN_PERSON_ID     = JSPUtil.nullToEmpty(wf.getValue("PREV_SIGN_PERSON_ID",	0));
		PREV_SIGN_PERSON_NAME   = JSPUtil.nullToEmpty(wf.getValue("PREV_SIGN_PERSON_NAME",	0));
		APP_AMT                 = JSPUtil.nullToEmpty(wf.getValue("APP_AMT",				0));
		PR_DATE                 = JSPUtil.nullToEmpty(wf.getValue("PR_DATE",				0));
		BUDGET_AMT              = JSPUtil.nullToEmpty(wf.getValue("BUDGET_AMT",				0));
		PAY_DATE                = JSPUtil.nullToEmpty(wf.getValue("PAY_DATE",				0));
		IN_PRICE_AMT            = JSPUtil.nullToEmpty(wf.getValue("IN_PRICE_AMT",			0));
		BE_PRICE_AMT            = JSPUtil.nullToEmpty(wf.getValue("BE_PRICE_AMT",			0));
		APP_REMARK              = JSPUtil.nullToEmpty(wf.getValue("APP_REMARK",				0));
		AUTO_EXTEND_FLAG        = JSPUtil.nullToEmpty(wf.getValue("AUTO_EXTEND_FLAG",		0));
		ITEM_QTY                = JSPUtil.nullToEmpty(wf.getValue("ITEM_QTY",				0));
		IN_ATTACH_NO            = JSPUtil.nullToEmpty(wf.getValue("IN_ATTACH_NO",			0));
		IN_ATTACH_CNT           = JSPUtil.nullToEmpty(wf.getValue("IN_ATTACH_CNT",			0));
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
    
    
	String tmpId = "AR_001_1";
	String tmpId2 = "";
	if("".equals(EXEC_NO)){ tmpId = "CT_007_1"; tmpId2 = "none"; }
    
	Vector multilang_id = new Vector();
// 	multilang_id.addElement("CT_007_2");
	multilang_id.addElement(tmpId);
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);

	// Dthmlx Grid 전역변수들..
// 	String screen_id = "CT_007_2";
	String screen_id = tmpId;
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;    
    
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"                         %><!-- CSS  -->
<%-- <%@ include file="/include/sepoa_grid_common.jsp"                   %><!-- 그리드COMMON  --> --%>
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

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw(){
		return true;
	}

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp(){
		return true;
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown(){
    	return true;
    }
    
    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt){
  		return true;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	return true;
    }
    
    // 그리드 셀 ChangeEvent 시점에 호출 됩니다.
    // stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    function doOnCellChange(stage,rowId,cellInd)
    {
    	var max_value = GridObj.cells(rowId, cellInd).getValue();
    	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    	if(stage==0) {
    	
			return true;
			
		} else if(stage==2) {
	    	var header_name = GridObj.getColumnId(cellInd);
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
				var cont_gl_seq = "<%=CONT_GL_SEQ%>";
				location.href = "contract_create_list.jsp";
			}else{
				var cont_no     = "<%=CONT_NO%>";
				var cont_gl_seq = "<%=CONT_GL_SEQ%>";
				location.href = "contract_create_list.jsp";;
			}
			
		} else {
			alert(messsage);
		}

		return false;
	}
	
	function YearChangeMonth( fault_ins_term, fault_ins_term_mon ){
		if( fault_ins_term == "" )     fault_ins_term = 0;
		if( fault_ins_term_mon == "" ) fault_ins_term_mon = 0;
	
		var month = 0;
		    month = (parseInt(fault_ins_term) * 12) + parseInt(fault_ins_term_mon);
		
		return month;
	}
	
	function doSave() {
		var sg_type1 = document.forms[0].sg_type1.value;
		var sg_type2 = document.forms[0].sg_type2.value;
		var req_dept = document.forms[0].req_dept.value;
		var subject = document.forms[0].subject.value;
		var cont_process_flag = document.forms[0].cont_process_flag.value;
		var seller_code = document.forms[0].seller_code.value;
		var cont_type1_text = document.forms[0].cont_type1_text.value;
		var cont_type2_text = document.forms[0].cont_type2_text.value;
		var cont_from = document.forms[0].cont_from.value;
		var cont_to = document.forms[0].cont_to.value;
		var app_date = document.forms[0].app_date.value;
		var cont_add_date = document.forms[0].cont_add_date.value;
		var sign_person_id = document.forms[0].sign_person_id.value;
		var cont_amt = document.forms[0].cont_amt.value;
		var prev_sign_person_id = document.forms[0].prev_sign_person_id.value;
		var cont_date = document.forms[0].cont_date.value;
		var cont_type = document.forms[0].cont_type.value;
		var assure_flag = document.forms[0].assure_flag.value;
		
		if(sg_type1 == "") { alert("계약구분을 선택하세요."); return; }
		if(sg_type2 == "") { alert("계약구분을 선택하세요."); return; }
		if(req_dept == "") { alert("요청부서(계약부서)를 입력하세요."); return; }
		if(subject == "") { alert("계약명을 입력하세요."); return; }
		if(cont_process_flag == "") { alert("계약방법을 선택하세요."); return; }
		if(seller_code == "") { alert("업체명을 입력하세요."); return; }
		//if(cont_type1_text == "") { alert("입찰방법을 선택하세요."); return; }
		//if(cont_type2_text == "") { alert("입찰방법을 선택하세요."); return; }
		if(cont_from == "") { alert("계약기간을 입력하세요."); return; }
		if(cont_to == "") { alert("계약기간을 입력하세요."); return; }
		if(app_date == "") { alert("품의일자를 입력하세요."); return; }
		if(cont_add_date == "") { alert("계약일자를 입력하세요."); return; }
		if(sign_person_id == "") { alert("계약담당자를 입력하세요."); return; }
		if(cont_amt == "") { alert("계약금액을 입력하세요."); return; }
		if(prev_sign_person_id == "") { alert("전결권자를 입력하세요."); return; }
		if(cont_date == "") { alert("작성일자를 입력하세요."); return; }
		if(cont_type == "") { alert("계약서를 선택하세요."); return; }
		if(assure_flag == "") { alert("보증구분을 선택하세요."); return; }
		 
		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);//하자보증기간 (년)
		var fault_ins_term_mon 	= LRTrim(document.form.fault_ins_term_mon.value);//하자보증기간 (월)
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		document.form.hdn_fault_ins_term.value = YearChangeMonth( fault_ins_term, fault_ins_term_mon );
		
		var nickName = "MAN_001";
		var conType = "CONNECTION";
		var methodName = "getContractUpdate";
		var SepoaOut = doServiceAjax( nickName, conType, methodName );
		
		alert(SepoaOut.message);
		if(SepoaOut.status == '1') {
			location.href = "contract_man_update.jsp?cont_no="+SepoaOut.result[0];
		}
		return;
	   
	}
	
        
   function getCtrlPersonId() {
   		window.open("/common/CO_008.jsp?callback=setCtrlPerson", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
   }

   function setCtrlPerson(code, text1) {
	    document.forms[0].sign_person_id.value = code  ;
	    document.forms[0].sign_person_name.value = text1 ;
   }
	
   function getCtrlPersonId2() {
  		window.open("/common/CO_008.jsp?callback=setCtrlPerson2", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
   }

   function setCtrlPerson2(code, text1) {
	    document.forms[0].prev_sign_person_id.value = code  ;
	    document.forms[0].prev_sign_person_name.value = text1 ;
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
		document.forms[0].seller_name.value = text1;
	
	}
	
	function initAjax(){
		document.form.cont_add_date.readOnly = true;
		
		//doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag'		, '<%=ELE_CONT_FLAG%>');//전자계약작성여부
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type'			, '<%=CONT_TYPE%>' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag'			, '<%=ASSURE_FLAG%>');//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, '<%=CONT_PROCESS_FLAG%>' );//계약방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '<%=CONT_TYPE1_TEXT%>' );//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '<%=CONT_TYPE2_TEXT%>' );//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun'	, '<%=CONT_TOTAL_GUBUN%>' );//계약단가
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'auto_extend_flag'		, '<%=AUTO_EXTEND_FLAG%>');//전자계약작성여부
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M900' ,'sg_type1'			,  '<%=SG_LEV1%>'	);//계약구분(대)
		doRequestUsingPOST( 'SL0149', '<%=house_code%>#<%=SG_LEV1%>','sg_type2'			, '<%=SG_LEV2%>'	);//계약구분(중)
		
		// 3자리 콤마 
		document.form.cont_assure_amt.value  = add_comma(document.form.cont_assure_amt.value, "0");
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
	
	function getAmtPercent(percent, name)
	{
		if( document.form.cont_amt.value == "" ){
			alert("계약금액을 먼저 입력하셔야 합니다.");
			document.form.cont_assure_percent.value = "";
			document.form.fault_ins_percent.value   = "";
			document.form.fault_ins_amt.value       = "";
			document.form.cont_assure_amt.value     = "";

			document.form.cont_amt.focus();
			return;
		}		
	
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
		
		if(!checkDate(strValue)) {
            alert(message + "을(를) 확인하세요.");
            return false;
        }
	
	}
	
	function doConfrim()
	{
		
		var subject					= LRTrim(document.form.subject.value);//계약명
		var seller_code				= LRTrim(document.form.seller_code.value);//업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);//업체명
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));//계약금액		
	 		
		
		var cont_no		= "<%=CONT_NO%>";//계약번호
		var cont_gl_seq	= "<%=CONT_GL_SEQ%>";		
		var cont_date	= document.form.cont_date.value;
			
		if("<%=CT_FLAG%>" == "CW") {
			alert("확정된 건입니다.");
			return
		}

		if("<%=CT_FLAG%>" == "CD") {
			alert("이미 발주완료된 건입니다.");
			return
		}
				
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var param  = "&cont_no="     + encodeUrl(cont_no);
		    param += "&cont_date="   + encodeUrl(cont_date);
		    param += "&cont_gl_seq=" + encodeUrl(cont_gl_seq);
		
		if (confirm("확정 하시겠습니까?")) {
			
			var SERVLETURL  = G_SERVLETURL + "?mode=setConfirm&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
	}


	
	
	//지우기
	function doRemove( type ){
	    if( type == "sign_person_id" ) { 
	    	document.forms[0].sign_person_id.value = "";
	        document.forms[0].sign_person_name.value = "";
	    } 
	    if( type == "seller_code" ) {
	    	document.forms[0].seller_code.value = "";
	        document.forms[0].seller_name.value = "";
	    }
	    if( type == "req_dept" ) {
	    	document.forms[0].req_dept.value = "";
	        document.forms[0].req_dept_name.value = "";
	    }
	}
	
	function PopupManager(part) {
		var url = "";
		var f = document.forms[0];

		if(part == "REQ_DEPT") {
			window.open("/common/CO_009.jsp?callback=getReqDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "SALES_DEPT") {
			window.open("/common/CO_009.jsp?callback=getSalesDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "DEMAND_DEPT") {
			window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		} else if(part == "ADD_USER_ID") {
			window.open("/common/CO_008.jsp?callback=getAddUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		else if(part == "ctrl_person_id")
		{
			window.open("/common/CO_008.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		//구매담당직무
		if(part == "CTRL_CODE")
		{
			PopupCommon2("SP0216","getCtrlManager","<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>","직무코드","직무명");
		}
	}
	
	function getCtrlUser(code, text) {
		document.form1.ctrl_person_id.value = code;
		document.form1.ctrl_person_name.value = text;
	}

	//구매담당직무
	function getCtrlManager(code, text)
	{
		document.form1.ctrl_code.value = code;
		document.form1.ctrl_name.value = text;
	}

	function getDemand(code, text) {
		document.forms[0].demand_dept_name.value = text;
		document.forms[0].demand_dept.value = code;
	}

	function getAddUser(code, text) {
		document.forms[0].add_user_name.value = text;
		document.forms[0].add_user_id.value = code;
	}
	
	function getCtrlPerson(code, text ,code1, text1)
	{
		document.forms[0].ctrl_person_name.value = text1;
		document.forms[0].ctrl_person_id.value = code1;
	}

	function getReqDept(code, text) {
		document.forms[0].req_dept_name.value = text;
		document.forms[0].req_dept.value = code;
	}

	function getSalesDept(code, text) {
		document.forms[0].sales_dept_name.value = text;
		document.forms[0].sales_dept.value = code;
	}	
	
	function doAmtGubunChange() {
	/*
		var amt_gubun = document.form.amt_gubun.value;
		
		if(amt_gubun == "T") {
			for(var i= dhtmlx_start_row_id ; i < dhtmlx_last_row_id; i++) {
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("UNIT_PRICE")).setValue("0");
				GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("ITEM_AMT")).setValue("0");
			}
		
		}	
	*/	
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
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				//doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
				doRequestUsingPOST( 'SL0149', '<%=house_code%>#'+sg_refitem ,'sg_type2'			, ''	);//계약구분(중)
			}
			else{
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
			}
		}
	}
	
	function onlyNumber(keycode){
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}
	
	//INPUTBOX 입력시 콤마 제거
	function setOnFocus(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    target.value = del_comma(target.value);
	}
	
	//INPUTBOX 입력 후 콤마 추가
	function setOnBlur(obj) {
	    var target = eval("document.forms[0]." + obj.name);
	    if(IsNumber(target.value) == false) {
	        alert("숫자를 입력하세요.");
	        return;
	    }
	    target.value = add_comma(target.value,0);
	}
	
	//INPUTBOX 입력 후 커서아웃시 소수점1자리까지만 유효
	function checkDelayCharge(obj) {
		obj.value = add_comma(obj.value, 1);
	}
	
</Script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();">
<s:header>
<form name="form">
<input type="hidden" id="hdn_fault_ins_term" 		name="hdn_fault_ins_term" >
<input type="hidden" id="exec_no" 		name="exec_no" 		value="<%=EXEC_NO %>">
<input type="hidden" id="pay_div_cnt"	name="pay_div_cnt"	>
<input type="hidden" id="cont_no" 		name="cont_no" 		value="<%=cont_no%>">
<input type="hidden" id="flag" 			name="flag" 		value="U">
<input type="hidden" id="dilv_term"		name="dilv_term"	>
<input type="hidden" id="po_cont_flag"	name="po_cont_flag"	>
<input type="hidden" id="pay_div_count"	name="pay_div_count">

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
						 		<td height="24" width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 계약번호</td>
						 		<td height="24" width="30%" class="data_td"><%=CONT_NO%></td>
						 		<td height="24" width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 차수</td>
						 		<td height="24" width="30%" class="data_td"><%=CONT_GL_SEQ%></td>	  				
						 	</tr>
						</table>
					</td>
				</tr>
			</table>
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
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약구분<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
						    		<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');">
						    			<option value="">--------</option>
						    		</select>
						    	
						    		<select id="sg_type2" name="sg_type2" class="inputsubmit" >
						    			<option value="">--------</option>
						    		</select>
						    							    			
			        			</td>
			        			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							요청부서(계약부서)<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">        							
									<input type="text" name="req_dept" id="req_dept" style="ime-mode:inactive" size="15" maxlength="6" value='<%=REQ_DEPT%>'  readonly>
									<a href="javascript:PopupManager('REQ_DEPT');">
										<img src="/images/ico_zoom.gif" align="absmiddle" border="0" alt="">
									</a>
									<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text"  name="req_dept_name" id="req_dept_name" size="20" readonly value='<%=REQ_DEPT_NAME%>'  readonly>
        						</td>       		
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약명<font color='red'><b>*</b></font>
			        			</td>
			        			<td width="30%" height="24" class="data_td">
			        				<input type="text" id="subject"  name="subject" size="35" value="<%=SUBJECT%>">
			        			</td>
			        			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약방법<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="cont_process_flag" name="cont_process_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>   
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				업체명<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="hidden" id="seller_code" name="seller_code" value="<%=SELLER_CODE%>">
			        				<input type="text"   id="seller_name" name="seller_name" value="<%=SELLER_NAME%>" readonly>
			        			</td>
			       				<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				입찰방법
			        			</td>
			        			<td height="24" class="data_td">
			        				<select id="cont_type1_text" name="cont_type1_text" disabled="disabled">
			        					<option value="">선택</option>
			        				</select><!-- M994 -->&nbsp;&nbsp;
			        				<select id="cont_type2_text" name="cont_type2_text" disabled="disabled">
			        					<option value="">선택</option>
			        				</select><!-- M993 -->        			
			        			</td>        		
						  	</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약기간<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
			        				<%if( !"N".equals(button) ){ %>
			        				<s:calendar id_from="cont_from" id_to="cont_to" default_from="<%=SepoaString.getDateSlashFormat(CONT_FROM)%>" default_to="<%=SepoaString.getDateSlashFormat(CONT_TO)%>" format="%Y/%m/%d" />
							    	<%}else{ %>
							    	<input type="text" id="cont_from" name="cont_from" size="10" maxlength="10" value="">~&nbsp;&nbsp;
							    	<input type="text" id="cont_to" name="cont_to" size="10" maxlength="10" value="">
							    	<%} %>	
			         			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				품의일자<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				                	<input type="text" id="app_date" name="app_date" size="8" maxlength="8" value="<%=APP_DATE %>" readonly="readonly">
			        			</td>        		
							</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약일자<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
									<%if( !"N".equals(button) ){ %>
			        				<s:calendar id="cont_add_date" default_value="<%=SepoaString.getDateSlashFormat(CONT_ADD_DATE)%>" format="%Y/%m/%d" />
			        				<%}else{ %>
			        				<input type="text" id="cont_add_date" name="cont_add_date" size="8" maxlength="8" value="<%=SepoaString.getDateSlashFormat(CONT_ADD_DATE)%>" readonly="readonly">
			        				<%} %>
			        			</td>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약담당자<font color='red'><b>*</b></font>
			        			</td>
			        			<% if(!info.getSession("USER_TYPE").equals("S")) { %>
			        			<td height="24" class="data_td">
			        				<input type="text" id="sign_person_id" name="sign_person_id" value="<%=SIGN_PERSON_ID%>"  readonly size="10">
			        			<%if( !"N".equals(button) ){ %>
			        			<%if( !"BD".equals( RFQ_TYPE ) ){ %>
									<a href="javascript:getCtrlPersonId()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
								<%} %>
								<%} %>
						        	<input type="text" id="sign_person_name" name="sign_person_name" value="<%=SIGN_PERSON_NAME%>" size="10" readonly class="input_empty">
			        			</td>
			        			<% } else { %>
				        		<td height="24" class="data_td">
				        			<input type="hidden" id="sign_person_id" name="sign_person_id" value="<%=SIGN_PERSON_ID%>" onkeyup="delInputEmpty('sign_person_id', 'sign_person_name')" size="10">
							        <input type="text" ID="sign_person_name" name="sign_person_name" value="<%=SIGN_PERSON_NAME%>" size="10" readonly class="input_empty">
			        			</td>
			        			<% } %>      		
							</tr>
			        	  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약금액<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" size="15" maxlength="50" id="cont_amt" name="cont_amt" dir="rtl" value="<%=CONT_AMT%>"> (원)
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
			        				&nbsp;<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" <%=checkY%> disabled="disabled">부가세포함&nbsp;
			        				&nbsp;<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" <%=checkX%> disabled="disabled">면세        			        			
			        				<%} %>
			        			</td>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				전결권자<font color='red'><b>*</b></font>
			        			</td>
			        			<% if(!info.getSession("USER_TYPE").equals("S")) { %>
			        			<td height="24" class="data_td">
			        				<input type="text" id="prev_sign_person_id" name="prev_sign_person_id" value="<%=PREV_SIGN_PERSON_ID%>" readonly size="10">
			        			<%if( !"N".equals(button) ){ %>
			        			<%if( !"BD".equals( RFQ_TYPE ) ){ %>
									<a href="javascript:getCtrlPersonId2()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
								<%} %>
								<%} %>
						        	<input type="text" id="prev_sign_person_name" name="prev_sign_person_name" value="<%=PREV_SIGN_PERSON_NAME%>" size="10" readonly class="input_empty">
			        			</td>
			        			<% } else { %>
				        		<td height="24" class="data_td">
				        			<input type="hidden" id="prev_sign_person_id" name="prev_sign_person_id" value="<%=PREV_SIGN_PERSON_ID%>" onkeyup="delInputEmpty('prev_sign_person_id', 'prev_sign_person_name')" size="10">
							        <input type="text" ID="prev_sign_person_name" name="prev_sign_person_name" value="<%=PREV_SIGN_PERSON_NAME%>" size="10" readonly class="input_empty">
			        			</td>
			        			<% } %> 
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							결재금액
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="app_amt"      name="app_amt"   value="<%=APP_AMT%>"   dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							대금청구일
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="pr_date" default_value="<%=SepoaString.getDateSlashFormat(PR_DATE) %>" format="%Y/%m/%d" />
        						</td>        		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							사업예산
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="budget_amt"      name="budget_amt"  value="<%=BUDGET_AMT%>"    dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							대금지급일
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<s:calendar id="pay_date" default_value="<%=SepoaString.getDateSlashFormat(PAY_DATE) %>" format="%Y/%m/%d" />
        						</td>        		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>	
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							내정가격
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="in_price_amt"      name="in_price_amt"    value="<%=IN_PRICE_AMT%>"   dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				작성일자<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				                	<input type="text" id="cont_date" name="cont_date" size="8" maxlength="8" value="<%=CONT_DATE %>" readonly="readonly">
			        			</td>           		
			  				</tr>
			  				<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>
							<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							예정가격
        						</td>
        						<td width="30%" height="24" class="data_td">
       								<input type="text" size="15" maxlength="50" id="be_price_amt"      name="be_price_amt"  value="<%=BE_PRICE_AMT%>"    dir="rtl" value="" onKeyPress="checkNumberFormat('[0-9]', this)" style="ime-mode:inactive" > (원)
        						</td>
        						<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약서<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				                	<select id="cont_type" name="cont_type" class="inputsubmit"><!-- M800 -->
										<option value="">----------------</option>
									</select>
			        			</td>          		
			  				</tr>
							<tr><td colspan="6" height="1" bgcolor="#dedede"></td></tr>	
			  				<tr>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							계약근거
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" id="app_remark" name="app_remark" value="<%=APP_REMARK %>" size="35">
        						</td>
        						<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							자동연장유무
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="auto_extend_flag" name="auto_extend_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>   
			  				</tr>
							<tr>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				하자보증금
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" id="fault_ins_percent" name="fault_ins_percent" dir="rtl" size="3" value="<%=FAULT_INS_PERCENT%>" onchange="getAmtPercent('form.fault_ins_percent.value', 'fault_ins_amt')">(%)
			        				&nbsp;
					       			<input type="text" id="fault_ins_amt" name="fault_ins_amt" dir="rtl" size="12" value="<%=FAULT_INS_AMT%>" maxlength="12" class="input_empty"  readonly="readonly">(원)
			        			</td>
			        			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							보증구분<font color='red'><b>*</b></font>
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<select id="assure_flag" name="assure_flag">
        								<option value="">선택</option>
        							</select><!-- M809 -->
        						</td>   
			        			      		
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				하자보증기간
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term" name="fault_ins_term" value="<%=FAULT_INS_TERM%>"> 년
									<input type="text" size="3" dir="rtl" maxlength="3" id="fault_ins_term_mon" name="fault_ins_term_mon" value="<%=FAULT_INS_TERM_MON%>"> 개월
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약보증금
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" id="cont_assure_percent" name="cont_assure_percent" dir="rtl" size="3" value="<%=CONT_ASSURE_PERCENT%>" onchange="getAmtPercent('form.cont_assure_percent.value', 'cont_assure_amt')">(%)
			        				&nbsp;
					       			<input type="text" id="cont_assure_amt" name="cont_assure_amt" dir="rtl" size="12" value="<%=CONT_ASSURE_AMT%>" maxlength="12" class="input_empty"  readonly="readonly">(원)
					       		</td>  
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				지체상금율(%)
			        			</td>
				        		<td height="24" class="data_td">
				        			1000 분의 &nbsp;&nbsp;<input type="text" size="10" id="delay_charge" name="delay_charge" dir="rtl" value="<%=DELAY_CHARGE%>" onKeyPress="checkNumberFormat('[0-9.]', this)" onKeyUp="chkMaxByte(100, this, '지체상금율')" onfocus="setOnFocus(this)" onblur="checkDelayCharge(this)" style="ime-mode:disabled">
				        		</td>
				        		<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				납품기한
			        			</td>
			        			<td height="24" class="data_td">
				                	<%if( !"N".equals(button) ){ %>
				                	<s:calendar id="rd_date" default_value="<%=SepoaString.getDateSlashFormat(RD_DATE) %>" format="%Y/%m/%d" />
							    	<%}else{ %>
				                	<input type="text" id="rd_date" name="rd_date" size="8" maxlength="8" value="<%=SepoaString.getDateSlashFormat(RD_DATE) %>" readonly="readonly">
							    	<%} %>
			        			</td> 
						  	</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				물품종류(모델명)
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" size="20" id="item_type" name="item_type" value="<%=ITEM_TYPE %>">
			        			</td>
			         			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        							수량
        						</td>
        						<td width="30%" height="24" class="data_td">
        							<input type="text" size="20" id="item_qty" name="item_qty" value="<%=ITEM_QTY%>">
        						</td>
						  	</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
						  	<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				납품장소
			        			</td>
			        			<td height="24" class="data_td">
			        				<input type="text" id="delv_place" name="delv_place" value="<%=DELV_PLACE%>" size="40">
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약단가
			        			</td>
			        			<td height="24" class="data_td">
			        				<select id="cont_total_gubun"name="cont_total_gubun">
			        					<option value=""></option>
			        				</select><!-- M813 -->&nbsp;<input type="text" id="cont_price"  name="cont_price" value="<%=CONT_PRICE %>">
			        			</td>
						  	</tr>		 
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr> 
							<tr>
			        			<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				비고
			        			</td>
			        			<td height="24" class="data_td" colspan="3">
			        				<textarea id="remark" name="remark" class="inputsubmit" style="width: 98%;" rows="3"><%=REMARK%></textarea>
			        			</td>
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>							
								<td width="30%" class="data_td" colspan=3>
									<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="15%">
											<script language="javascript">
											function setAttach(attach_key, arrAttrach, rowid, attach_count) {
												document.getElementById("in_attach_no").value = attach_key;
												document.getElementById("attach_no_count").value = attach_count;
											}
											btn("javascript:attach_file(document.getElementById('in_attach_no').value, 'TEMP');", "파일등록");
											</script>
											</td>
											<td>
												<input type="text" size="3" readOnly class="input_empty" name="attach_no_count" id="attach_no_count" value="<%=IN_ATTACH_CNT%>"/>
												<input type="hidden" value="<%=IN_ATTACH_NO%>" name="in_attach_no" id="in_attach_no">
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
		
<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
	<TR>
		<td></td>
		<td style="padding:5 5 5 0" align="right">
			<TABLE cellpadding="2" cellspacing="0">
				<TR>
					<% if(button.equals("N")) { %>
					<td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
					<% } else { %>
					<td><script language="javascript">btn("javascript:doSave()","수정")</script></td>
					<% } %>
				</TR>
			</TABLE>
		</td>
	</TR>
</TABLE>
</form>
</body>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
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
</div>	
</s:header>
<s:footer/>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>