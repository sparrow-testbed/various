<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>

<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_contract_detail"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

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
	
	String IN_ATTACH_NO         = "";
	
	String SG_LEV1_TEXT             = "";
	String SG_LEV2_TEXT             = "";
	String SG_LEV3_TEXT             = "";
	String CONT_PROCESS_FLAG_TEXT   = "";
	String CONT_TYPE1_TEXT_TEXT	    = "";
	String CONT_TYPE2_TEXT_TEXT     = "";
	String ELE_CONT_FLAG_TEXT       = "";
	String CONT_TYPE_TEXT           = "";
	String ASSURE_FLAG_TEXT         = "";
	String CONT_TOTAL_GUBUN_TEXT    = "";
	
	//String CONFIRM_USER_ID		= "";
	//String CONFIRM_USER_NAME		= "";	
	
	Object[] obj = {cont_no, cont_gl_seq};
	SepoaOut value = ServiceConnector.doService(info, "CT_020", "TRANSACTION","getContractUpdateSelect", obj);
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
		SG_LEV3					= JSPUtil.nullToEmpty(wf.getValue("SG_LEV3",				0)); 
		ADD_TAX_FLAG			= JSPUtil.nullToEmpty(wf.getValue("ADD_TAX_FLAG",			0));  
		ITEM_TYPE				= JSPUtil.nullToEmpty(wf.getValue("ITEM_TYPE",				0));  
		RD_DATE					= JSPUtil.nullToEmpty(wf.getValue("RD_DATE",				0));  
		CONT_TOTAL_GUBUN		= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN",		0));  
		CONT_PRICE				= JSPUtil.nullToEmpty(wf.getValue("CONT_PRICE",				0));     	 
		EXEC_NO					= JSPUtil.nullToEmpty(wf.getValue("EXEC_NO",				0));     	 
		
		IN_ATTACH_NO            = JSPUtil.nullToEmpty(wf.getValue("IN_ATTACH_NO",				0));
		
		SG_LEV1_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV1_TEXT",				0));     	 
		SG_LEV2_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV2_TEXT",				0));     	 
		SG_LEV3_TEXT          	= JSPUtil.nullToEmpty(wf.getValue("SG_LEV3_TEXT",				0));     	 
		CONT_PROCESS_FLAG_TEXT	= JSPUtil.nullToEmpty(wf.getValue("CONT_PROCESS_FLAG_TEXT",				0));     	 
		CONT_TYPE1_TEXT_TEXT	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE1_TEXT_TEXT",				0));     	 
		CONT_TYPE2_TEXT_TEXT  	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE2_TEXT_TEXT  ",				0));     	 
		ELE_CONT_FLAG_TEXT    	= JSPUtil.nullToEmpty(wf.getValue("ELE_CONT_FLAG_TEXT",				0));     	 
		CONT_TYPE_TEXT        	= JSPUtil.nullToEmpty(wf.getValue("CONT_TYPE_TEXT",				0));     	 
		ASSURE_FLAG_TEXT      	= JSPUtil.nullToEmpty(wf.getValue("ASSURE_FLAG_TEXT",				0));     	 
		CONT_TOTAL_GUBUN_TEXT 	= JSPUtil.nullToEmpty(wf.getValue("CONT_TOTAL_GUBUN_TEXT",				0));     	 
		
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

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
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

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }
    
    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
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
//    		document.form.cont_gubun.value = "<%=CONT_GUBUN%>";
		}
		
		if("<%=button%>" == "N") {
			doDefault();
		}

		if("<%=RFQ_TYPE%>" == "BD" || "<%=RFQ_TYPE%>" == "MA") {
			doDefault();
		}		
		
		/*
		if("<%=AMT_GUBUN%>" == "C") {
			document.form.amt_gubun.disabled = true;//select
		}
		*/
<%-- 		document.form.cont_amt.value = add_comma("<%=CONT_AMT %>", 0); --%>
		
  		return true;
    }
    
    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if(header_name == "PR_NO") {
    		var prNo   = SepoaGridGetCellValueId( GridObj, rowId, "PR_NO" );
    		var prType = SepoaGridGetCellValueId( GridObj, rowId, "PR_TYPE" );
    		
    		alert(prNo);
    		alert(prType);
    		
    		var page   = null;
    		
    		if(prType == "I"){
    			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
    		}
    		else{
    			page = "/kr/dt/pr/pr1_bd_dis1NotI.jsp";
    		}
    		
    		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
    		
    	} else if( header_name == "VENDOR_NAME" ) {
    		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
    		
    		if(vendor_code != null && vendor_code != "") {
    		
    			var url    = '/s_kr/admin/info/ven_bd_con.jsp';
    			var title  = '업체상세조회';
    			var param  = 'popup=Y';
    			param     += '&mode=irs_no';
    			param     += '&vendor_code=' + vendor_code;
    			popUpOpen01(url, title, '900', '700', param);
    			
    		}
    		
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
				var cont_gl_seq = "<%=CONT_GL_SEQ%>";
				location.href = "contract_create_list.jsp";
			}else{
				var cont_no     = "<%=CONT_NO%>";
				var cont_gl_seq = "<%=CONT_GL_SEQ%>";
				location.href = "contract_create_list_update.jsp?cont_no="+cont_no+"&cont_gl_seq="+cont_gl_seq;
			}
			
		} else {
			alert(messsage);
		}

		return false;
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
	
    function doUpdate() {
    	
		var subject					= LRTrim(document.form.subject.value);//계약명
		var sg_type1				= LRTrim(document.form.sg_type1.value);  //소싱그룹대분류
		var sg_type2				= LRTrim(document.form.sg_type2.value);  //소싱그룹중분류
		var sg_type3				= LRTrim(document.form.sg_type3.value);  //소싱그룹소분류

		var seller_code				= LRTrim(document.form.seller_code.value);//업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);//업체명
		var sign_person_id			= LRTrim(document.form.sign_person_id.value);//계약담당자 id
		var sign_person_name		= LRTrim(document.form.sign_person_name.value);//계약담당자 name
		var cont_from				= LRTrim(del_Slash(document.form.cont_from.value));//계약기간 from
		var cont_to					= LRTrim(del_Slash(document.form.cont_to.value));//계약기간 to
		var cont_date				= LRTrim(del_Slash(document.form.cont_date.value));//작성일자
		var cont_add_date			= LRTrim(del_Slash(document.form.cont_add_date.value));//계약일자
		var cont_type				= LRTrim(document.form.cont_type.value);//계약종류
		var ele_cont_flag			= LRTrim(document.form.ele_cont_flag.value);//전자계약작성여부
		var assure_flag				= LRTrim(document.form.assure_flag.value);//보증구분
		var cont_process_flag		= LRTrim(document.form.cont_process_flag.value);//계약방법
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));//계약금액
		var add_tax_flag = "";
		if( document.form.add_tax_flag[0].checked == true ) add_tax_flag	= document.form.add_tax_flag[0].value;// 부가세포함여부
		if( document.form.add_tax_flag[1].checked == true ) add_tax_flag	= document.form.add_tax_flag[1].value;// 부가세포함여부

		var cont_assure_percent		= LRTrim(document.form.cont_assure_percent.value);//계약보증금(%)
		var cont_assure_amt			= LRTrim(del_comma(document.form.cont_assure_amt.value));//계약보증금(원)
		var fault_ins_percent		= LRTrim(document.form.fault_ins_percent.value);//하자보증금(%)
		var fault_ins_amt			= LRTrim(del_comma(document.form.fault_ins_amt.value));//하자보증금(원)
		
		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);//하자보증기간
		var fault_ins_term_mon 	    = LRTrim(document.form.fault_ins_term_mon.value);//하자보증기간 (월)
		
		//년을 개월로 바꾼후 + 하자보증기간(월) -> fault_ins_term에 월로 담는다.
		fault_ins_term = fault_ins_term = YearChangeMonth( fault_ins_term, fault_ins_term_mon );
		
		var bd_no					= LRTrim(document.form.bd_no.value);//입찰/견적서번호
		var bd_count				= LRTrim(document.form.bd_count.value);//입찰/견적서차수
		var text_number				= LRTrim(document.form.text_number.value);//문서번호
		var delay_charge			= LRTrim(document.form.delay_charge.value);//지체상금율

		var remark					= LRTrim(document.form.remark.value);//비고
		var cont_no					= "<%=CONT_NO%>";
		var cont_gl_seq				= "<%=CONT_GL_SEQ%>";
		var cont_type1_text			= LRTrim(document.form.cont_type1_text.value);
		var cont_type2_text			= LRTrim(document.form.cont_type2_text.value);
		var delv_place			    = LRTrim(document.form.delv_place.value);
		var item_type				= LRTrim(del_Slash(document.form.item_type.value));//물품종류
		var rd_date					= LRTrim(del_Slash(document.form.rd_date.value));//납품기한
		var cont_total_gubun		= LRTrim(document.form.cont_total_gubun.value);//계약단가
		var cont_price				= LRTrim(document.form.cont_price.value);//계약단가    	
    	
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
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		
		if("<%=CT_FLAG%>" == "CW") {
			alert("확정된 건에 대해서는 수정 할 수 없습니다.");
			return
		}

		if("<%=CT_FLAG%>" == "CD") {
			alert("발주된 건에 대해서는 수정 할 수 없습니다.");
			return
		}
				
		if( subject == "" ) {
			alert("계약명을 입력하세요.");
			document.form.subject.select();
			return;
		}

		if( sg_type1 == "" || sg_type2 == "" || sg_type3 == "") {
			alert("계약구분을을 선택하세요.");
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
		
        if( !checkDate(cont_from) ) {
            alert("계약기간을 확인하세요.");
			document.form.cont_from.select();
            return;
        }
        
        if( !checkDate(cont_to) ) {
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
        
        if( cont_add_date != "" && !checkDate(cont_add_date) ) {
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
		
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);
		
		var param   = "&subject="				+ encodeUrl(subject);
			param  += "&sg_type1="				+ encodeUrl(sg_type1);
			param  += "&sg_type2="				+ encodeUrl(sg_type2);
			param  += "&sg_type3="				+ encodeUrl(sg_type3);
			param  += "&seller_code="			+ encodeUrl(seller_code);
			param  += "&seller_name="			+ encodeUrl(seller_name);
			param  += "&sign_person_id="		+ encodeUrl(sign_person_id);
			param  += "&sign_person_name="		+ encodeUrl(sign_person_name);
			param  += "&cont_from="				+ encodeUrl(cont_from);
			param  += "&cont_to="				+ encodeUrl(cont_to);
			param  += "&cont_date="				+ encodeUrl(cont_date);
			param  += "&cont_add_date="			+ encodeUrl(cont_add_date);
			param  += "&cont_type="				+ encodeUrl(cont_type);
			param  += "&ele_cont_flag="			+ encodeUrl(ele_cont_flag);
			param  += "&assure_flag="			+ encodeUrl(assure_flag);
			param  += "&cont_process_flag="		+ encodeUrl(cont_process_flag);
			param  += "&cont_amt="				+ encodeUrl(cont_amt);
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
			param  += "&cont_no="				+ encodeUrl(cont_no);
			
			param  += "&cont_gl_seq="			+ encodeUrl(cont_gl_seq);
			param  += "&cont_type1_text="		+ encodeUrl(cont_type1_text);
			param  += "&cont_type2_text="		+ encodeUrl(cont_type2_text);
			param  += "&delv_place="		    + encodeUrl(delv_place);
			param  += "&item_type="		    	+ encodeUrl(item_type);
			param  += "&rd_date="		    	+ encodeUrl(rd_date);
			param  += "&cont_total_gubun="		+ encodeUrl(cont_total_gubun);
			param  += "&cont_price="			+ encodeUrl(cont_price);
			
			var msg = "수정 하시겠습니까?";
		   
	    if (confirm(msg)) {
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=update&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
    }
    
   function getCtrlPersonId() {
   		PopupCommon1("SP5004", "setCtrlPerson", "", "ID", "사용자명");
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
		document.forms[0].seller_name.value = text1;
	
	}
	
	function initAjax(){
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M223' ,'ele_cont_flag'		, '<%=ELE_CONT_FLAG%>');//전자계약작성여부
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M899' ,'cont_type'			, '<%=CONT_TYPE%>' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M355' ,'assure_flag'			, '<%=ASSURE_FLAG%>');//보증구분
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M809' ,'cont_process_flag'	, '<%=CONT_PROCESS_FLAG%>' );//계약방법
		
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M989' ,'cont_type1_text'		, '<%=CONT_TYPE1_TEXT%>' );//입찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M930' ,'cont_type2_text'		, '<%=CONT_TYPE2_TEXT%>' );//낙찰방법
		doRequestUsingPOST( 'SL0018', '<%=house_code%>#M204' ,'cont_total_gubun'	, '<%=CONT_TOTAL_GUBUN%>' );//계약단가
		
		doRequestUsingPOST( 'W001', '1' ,'sg_type1', '<%=SG_LEV1%>' );
		doRequestUsingPOST( 'W001', '2' ,'sg_type2', '<%=SG_LEV2%>' );
		doRequestUsingPOST( 'W001', '3' ,'sg_type3', '<%=SG_LEV3%>' );		
		
		// 3자리 콤마 
// 		document.form.cont_assure_amt.value  = add_comma(document.form.cont_assure_amt.value, "0");
// 		document.form.fault_ins_amt.value    = add_comma(document.form.fault_ins_amt.value, "0");
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
			
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=setConfirm&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
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
	
	function poCreate() {
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		var subject					= LRTrim(document.form.subject.value);//계약명
//		var cont_gubun				= LRTrim(document.form.cont_gubun.value);//계약구분
	//	var property_yn				= LRTrim(document.form.property_yn.value);//자산등제
		var seller_code				= LRTrim(document.form.seller_code.value);//업체코드
		var seller_name				= LRTrim(document.form.seller_name.value);//업체명
		var sign_person_id			= LRTrim(document.form.sign_person_id.value);//계약담당자 id
		var sign_person_name		= LRTrim(document.form.sign_person_name.value);//계약담당자 name
		var cont_from				= LRTrim(del_Slash(document.form.cont_from.value));//계약기간 from
		var cont_to					= LRTrim(del_Slash(document.form.cont_to.value));//계약기간 to
		var cont_date				= LRTrim(del_Slash(document.form.cont_date.value));//작성일자
		var cont_add_date			= LRTrim(del_Slash(document.form.cont_add_date.value));//계약일자
		var cont_type				= LRTrim(document.form.cont_type.value);//계약종류
		var ele_cont_flag			= LRTrim(document.form.ele_cont_flag.value);//전자계약작성여부
		var assure_flag				= LRTrim(document.form.assure_flag.value);//보증구분
	//	var start_start_ins_flag	= LRTrim(document.form.start_start_ins_flag.value);//선지급금
		var cont_process_flag		= LRTrim(document.form.cont_process_flag.value);//계약방법
		var cont_amt				= LRTrim(del_comma(document.form.cont_amt.value));//계약금액
		var cont_assure_percent		= LRTrim(document.form.cont_assure_percent.value);//계약보증금(%)
		var cont_assure_amt			= LRTrim(del_comma(document.form.cont_assure_amt.value));//계약보증금(원)
		var fault_ins_percent		= LRTrim(document.form.fault_ins_percent.value);//하자보증금(%)
		var fault_ins_amt			= LRTrim(del_comma(document.form.fault_ins_amt.value));//하자보증금(원)
	//	var pay_div_flag			= LRTrim(document.form.pay_div_flag.value);//지급구분
		var fault_ins_term			= LRTrim(document.form.fault_ins_term.value);//하자보증기간
		var bd_no					= LRTrim(document.form.bd_no.value);//입찰/견적서번호
		var bd_count				= LRTrim(document.form.bd_count.value);//입찰/견적서차수
		//var amt_gubun				= LRTrim(document.form.amt_gubun.value);//금액구분
		var text_number				= LRTrim(document.form.text_number.value);//문서번호
		var delay_charge			= LRTrim(document.form.delay_charge.value);//지체상금율
	//	var delv_place				= LRTrim(document.form.delv_place.value);//납품장소
		var remark					= LRTrim(document.form.remark.value);//비고
		var CTRL_DEMAND_DEPT		= "<%=CTRL_DEMAND_DEPT%>";
		var cont_no					= "<%=CONT_NO%>";
		
		if(subject == "") {
			alert("계약명을 입력하세요.");
			document.form.subject.select();
			return;
		}
		
		if(cont_from == "" || cont_to == "") {
			alert("계약기간을 입력하세요.");
			document.form.cont_from.select();
			return;
		}
		
        if(!checkDate(cont_from)) {
            alert("계약기간을 확인하세요.");
			document.form.cont_from.select();
            return;
        }
        
        if(!checkDate(cont_to)) {
            alert("계약기간을 확인하세요.");
			document.form.cont_to.select();
            return;
        }
      
        if(cont_from > cont_to) {
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
        
        if(cont_add_date != "" && !checkDate(cont_add_date)) {
        	alert("계약일자를  확인하세요.");
			document.form.cont_add_date.select();
            return;
        }
        
		if(cont_type ==  "") {
			alert("계약종류를 입력하세요.");
			return;
		}
<%-- 
        if(dilv_term == "") {
        	alert("납품기한을 확인하세요.");
			document.form.dilv_term.select();
        	return;
        }
        
        if(!checkDate(dilv_term)) {
            alert("납품기한을 확인하세요.");
			document.form.dilv_term.select();
            return;
        }
--%>        
        if(cont_amt == "") {
        	alert("계약금액을 입력하세요.");
			document.form.cont_amt.select();
        	return;
        }
		
		if(cont_assure_amt == "") {
			alert("계약보증금을 입력하세요.");
			document.form.cont_assure_percent.select();
			return;
		}
		
		if(document.form.ele_cont_flag.value == "N") {
			if(document.form.cont_add_date.value == "") {
				alert("계약일자를 입력하세요.");
				return;
			}
		}
		
		if(parseInt(document.form.cont_assure_percent.value) > 100) {
			alert("계약보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if(parseInt(document.form.fault_ins_percent.value) > 100) {
			alert("하자보증금은 100을 넘을 수 없습니다.");
			return;
		}
		
		if(parseInt(document.form.delay_charge.value) > 100) {
			alert("지체상금율은 100을 넘을 수 없습니다.");
			return;
		}
		
//		if(delv_place.length > 50) {
//			alert("납품 장소는 25글자를 넘을 수 없습니다.");
//			return;
//		}
		
		if(remark.length > 750) {
			alert("비고는 350글자를 넘을 수 없습니다.");
			return;
		}
		
		if(text_number == "") {
			alert("문서번호를 입력하세요.");
			return;
		}
		
    	var rowcount = grid_array.length;
    	GridObj.enableSmartRendering(false);

//    	for(var row = 0; row < rowcount; row++)
//		{
//			if(parseInt(GridObj.cells(grid_array[row], 4).getValue()) < 1)
//			{
//				alert("계약수량은 1이상이 되어야 합니다.");
//				return;
//       	}
        	
//        	var unit_price = GridObj.cells(grid_array[row], GridObj.getColIndexById("UNIT_PRICE")).getValue();
        	
//        	if( unit_price == "" || unit_price == "0"  )
//        	{
//        		alert("계약단가를 입력하세요.");
//        		return;
//        	}
//        	else{
//        		var	rfq_qty    = GridObj.cells(grid_array[row], GridObj.getColIndexById("SETTLE_QTY")).getValue();
//				var	unit_price = GridObj.cells(grid_array[row], GridObj.getColIndexById("UNIT_PRICE")).getValue();
				
//				var item_amt     = floor_number(eval(rfq_qty) * eval(unit_price), 2);
//				var supply_amt   = item_amt;
//				var supertax_amt = 0;
				
//				GridObj.cells(grid_array[row], GridObj.getColIndexById("ITEM_AMT")).setValue(item_amt);
//				GridObj.cells(grid_array[row], GridObj.getColIndexById("SUPPLY_AMT")).setValue(supply_amt);
//				GridObj.cells(grid_array[row], GridObj.getColIndexById("SUPERTAX_AMT")).setValue(supertax_amt);
			
//        	}
//	    }
	    
		
		var param   = "&subject="				+ encodeUrl(subject);
//			param  += "&cont_gubun="			+ encodeUrl(cont_gubun);
	//		param  += "&property_yn="			+ encodeUrl(property_yn);
			param  += "&seller_code="			+ encodeUrl(seller_code);
			param  += "&seller_name="			+ encodeUrl(seller_name);
			param  += "&sign_person_id="		+ encodeUrl(sign_person_id);
			param  += "&sign_person_name="		+ encodeUrl(sign_person_name);
			param  += "&cont_from="				+ encodeUrl(cont_from);
			param  += "&cont_to="				+ encodeUrl(cont_to);
			param  += "&cont_date="				+ encodeUrl(cont_date);
			param  += "&cont_add_date="			+ encodeUrl(cont_add_date);
			param  += "&cont_type="				+ encodeUrl(cont_type);
			param  += "&ele_cont_flag="			+ encodeUrl(ele_cont_flag);
			param  += "&assure_flag="			+ encodeUrl(assure_flag);
	//		param  += "&start_start_ins_flag="	+ encodeUrl(start_start_ins_flag);
			param  += "&cont_process_flag="		+ encodeUrl(cont_process_flag);
			param  += "&cont_amt="				+ encodeUrl(cont_amt);
			param  += "&cont_assure_percent="	+ encodeUrl(cont_assure_percent);
			param  += "&cont_assure_amt="		+ encodeUrl(cont_assure_amt);
			param  += "&fault_ins_percent="		+ encodeUrl(fault_ins_percent);
			param  += "&fault_ins_amt="			+ encodeUrl(fault_ins_amt);
	//		param  += "&pay_div_flag="			+ encodeUrl(pay_div_flag);
			param  += "&fault_ins_term="		+ encodeUrl(fault_ins_term);
			param  += "&bd_no="					+ encodeUrl(bd_no);
			param  += "&bd_count="				+ encodeUrl(bd_count);
			//param  += "&amt_gubun="				+ encodeUrl(amt_gubun);
			param  += "&text_number="			+ encodeUrl(text_number);
			param  += "&delay_charge="			+ encodeUrl(delay_charge);
	//		param  += "&delv_place="			+ encodeUrl(delv_place);
			param  += "&remark="				+ encodeUrl(remark);
			param  += "&cont_no="				+ encodeUrl(cont_no);
		   
	    if (confirm("발주작성 하시겠습니까?")) {
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=poCreate&cols_ids="+ cols_ids + param;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		}
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
	
	function doDefault() {
		if("<%=button%>" == "N") {
			document.form.subject.readOnly  = true;
			document.form.subject.className = "input_empty";
			
//			document.form.cont_gubun.disabled = true;//select
			//document.form.property_yn.disabled = true;//select
			
			document.form.sg_type1.disabled = true;//select
			document.form.sg_type2.disabled = true;//select
			document.form.sg_type3.disabled = true;//select
			
			document.form.seller_name.readOnly  = true;
			document.form.seller_name.className = "input_empty";
			
			document.form.sign_person_id.readOnly  = true;
			document.form.sign_person_id.className = "input_empty";
			
			document.form.sign_person_name.readOnly  = true;
			document.form.sign_person_name.className = "input_empty";
						
			document.form.cont_from.readOnly  = true;
			document.form.cont_from.value = add_Slash2("<%=CONT_FROM%>");
			document.form.cont_from.className = "input_empty";
			
			document.form.cont_to.readOnly  = true;
			document.form.cont_to.value     = add_Slash2("<%=CONT_TO%>");
			document.form.cont_to.className = "input_empty";
			
			document.form.cont_date.readOnly  = true;
			document.form.cont_date.value     = add_Slash2("<%=CONT_DATE%>");
			document.form.cont_date.className = "input_empty";

			document.form.cont_add_date.readOnly  = true;
			document.form.cont_add_date.value     = add_Slash2("<%=CONT_ADD_DATE%>");
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
			
			document.form.delv_place.readOnly = true;
			document.form.delv_place.className = "input_empty";
			document.form.ele_cont_flag.disabled = true;//select
			
			GridObj.setColumnExcellType(5,"ro");
			GridObj.setColumnExcellType(6,"ro");
			
			document.form.cont_type1_text.disabled = true;//select
			document.form.cont_type2_text.disabled = true;//select
			
			document.form.item_type.readOnly  = true;
			document.form.item_type.className = "input_empty";
			document.form.rd_date.value     = add_Slash2("<%=RD_DATE%>");
			document.form.rd_date.className = "input_empty";
			
		}
		// 계약대기현황
		else if("<%=RFQ_TYPE%>" == "BD") {
			document.form.seller_name.readOnly  = true;          		// 업체명
			document.form.seller_name.className = "input_empty";			
			
			document.form.sign_person_id.readOnly  = true;              // 계약담당자아이디
			document.form.sign_person_id.className = "input_empty";
			
			document.form.sign_person_name.readOnly  = true;		    // 계약담당자이름
			document.form.sign_person_name.className = "input_empty";	
			
			document.form.cont_amt.readOnly  = true;				 	// 계약금액
			document.form.cont_amt.className = "input_empty";
			
			document.form.bd_no.readOnly  = true;						// 입찰/견적서번호
			document.form.bd_no.className = "input_empty";	
			
			document.form.text_number.readOnly  = true;					// 문서번호
			document.form.text_number.className = "input_empty";					
		}
		// 수기계약생성
		else if("<%=RFQ_TYPE%>" == "MA"){
			
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
//			sg_type2_id.fireEvent("onchange"); //onchange 이벤트발생
			$(sg_type2_id).trigger("onchange");
			if( sg_refitem.valueOf().length > 0 ){
				// 공백인 option 하나 추가(전체 검색위해서)
				var nodePath  = document.getElementById("sg_type2");
				var ooption   = document.createElement("option");
				ooption.text  = "--------";
				ooption.value = "";
				nodePath.add(ooption);
				
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_type2', '' );
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
//			sg_type3_id.fireEvent("onchange"); //onchange 이벤트발생
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
	
	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData,approvalCnt) {
		//alert(document.form.rptData.value);
		if(typeof(rptAprvData) != "undefined"){
			document.form.rptAprvUsed.value = "Y";
			document.form.rptAprvCnt.value = approvalCnt;
			document.form.rptAprv.value = rptAprvData;
	    }
	    var url = "/ClipReport4/ClipViewer.jsp";
		//url = url + "?BID_TYPE=" + bid_type;	
	    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
		document.form.method = "POST";
		document.form.action = url;
		document.form.target = "ClipReport4";
		document.form.submit();
		cwin.focus();
	}
</Script>
</head>
<%
String cont_from_str= "";
String cont_to_str 	= "";
if(!"".equals(CONT_FROM) && CONT_FROM.length() == 8)cont_from_str = CONT_FROM.substring(0, 4) + "/" + CONT_FROM.substring(4, 6) + "/" + CONT_FROM.substring(6);  
if(!"".equals(CONT_TO) && CONT_TO.length() == 8)cont_to_str = CONT_TO.substring(0, 4) + "/" + CONT_TO.substring(4, 6) + "/" + CONT_TO.substring(6);  

String cont_add_date_str = "";
if(!"".equals(CONT_ADD_DATE) && CONT_ADD_DATE.length() == 8)cont_add_date_str = CONT_ADD_DATE.substring(0, 4) + "/" + CONT_ADD_DATE.substring(4, 6) + "/" + CONT_ADD_DATE.substring(6);  

String cont_date_str = "";
if(!"".equals(CONT_DATE) && CONT_DATE.length() == 8)cont_date_str = CONT_DATE.substring(0, 4) + "/" + CONT_DATE.substring(4, 6) + "/" + CONT_DATE.substring(6);  

String sNo = "";
if(!"".equals(BD_NO))	sNo = BD_NO + " / " + BD_COUNT;

String rd_date_str = "";
if(!"".equals(RD_DATE) && RD_DATE.length() == 8)rd_date_str = RD_DATE.substring(0, 4) + "/" + RD_DATE.substring(4, 6) + "/" + RD_DATE.substring(6);  

//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
_rptData.append(CONT_NO);
_rptData.append(_RF);
_rptData.append(CONT_GL_SEQ);
_rptData.append(_RF);
_rptData.append(SUBJECT);
_rptData.append(_RF);
_rptData.append(CT_FLAG_TEXT);
_rptData.append(_RF);
_rptData.append(SG_LEV1_TEXT);
_rptData.append("    ");
_rptData.append(SG_LEV2_TEXT);
_rptData.append("    ");
_rptData.append(SG_LEV3_TEXT);
_rptData.append(_RF);
_rptData.append(CONT_PROCESS_FLAG_TEXT);
_rptData.append(_RF);
_rptData.append(SELLER_NAME);
_rptData.append(_RF);
_rptData.append(CONT_TYPE1_TEXT_TEXT);
_rptData.append(_RF);
_rptData.append(CONT_TYPE2_TEXT_TEXT);
_rptData.append(_RF);
_rptData.append(cont_from_str);
_rptData.append(" ~ ");
_rptData.append(cont_to_str);
_rptData.append(_RF);
_rptData.append(SIGN_PERSON_NAME);
_rptData.append(_RF);
_rptData.append(cont_add_date_str);
_rptData.append(_RF);
_rptData.append(cont_date_str);
_rptData.append(_RF);
_rptData.append(ELE_CONT_FLAG_TEXT);
_rptData.append(_RF);
_rptData.append(CONT_TYPE_TEXT);
_rptData.append(_RF);
_rptData.append(SepoaMath.SepoaNumberType(CONT_AMT, "###,###,###,###,###,###,###,###"));
_rptData.append("(원)");
if( "Y".equals( ADD_TAX_FLAG ) ){_rptData.append("    부가세포함");}else{_rptData.append("    면세");}
_rptData.append(_RF);
_rptData.append(ASSURE_FLAG_TEXT);
_rptData.append(_RF);
_rptData.append(FAULT_INS_PERCENT);
_rptData.append(_RF);
_rptData.append(FAULT_INS_AMT);
_rptData.append(_RF);
_rptData.append(CONT_ASSURE_PERCENT);
_rptData.append(_RF);
_rptData.append(CONT_ASSURE_AMT);
_rptData.append(_RF);
_rptData.append(FAULT_INS_TERM);
_rptData.append(_RF);
_rptData.append(FAULT_INS_TERM_MON);
_rptData.append(_RF);
_rptData.append(sNo);
_rptData.append(_RF);
_rptData.append(DELAY_CHARGE);
_rptData.append(_RF);
_rptData.append(TEXT_NUMBER);
_rptData.append(_RF);
_rptData.append(ITEM_TYPE);
_rptData.append(_RF);
_rptData.append(rd_date_str);
_rptData.append(_RF);
_rptData.append(DELV_PLACE);
_rptData.append(_RF);
_rptData.append(CONT_TOTAL_GUBUN_TEXT);
_rptData.append(_RF);
_rptData.append(CONT_PRICE);
_rptData.append(_RF);
_rptData.append(REMARK);


Map map = new HashMap();
map.put("mode"		, "query");
map.put("exec_no"   , EXEC_NO);
//Map<String, Object> data = new HashMap();
//data.put("header"		, map);

Object[] obj2 = {map};
SepoaOut value2= ServiceConnector.doService(info, "p1062", "CONNECTION","getEXDTInfo", obj2);
SepoaFormater wf2 = new SepoaFormater(value2.result[0]);
_rptData.append(_RD);			
if(wf2 != null) {
	if(wf2.getRowCount() > 0) { //데이타가 있는 경우
		for(int i = 0 ; i < wf2.getRowCount() ; i++){
			_rptData.append(wf2.getValue("ITEM_NO", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("DESCRIPTION_LOC", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("SPECIFICATION", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("UNIT_MEASURE", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("PR_QTY", i));              //QTY
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("CUR", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("PO_UNIT_PRICE", i));       //UNIT_PRICE
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("PO_ITEM_AMT", i));         //ITEM_AMT
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("RD_DATE", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("PR_NO", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("SOURCING_NO", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("VENDOR_NAME", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("SAVE_ITEM_DETAIL", i));
			_rptData.append(_RF);
			_rptData.append(wf2.getValue("DETAIL_DOC_NO", i));		
			_rptData.append(_RL);			
		}
	}
}
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////	
%>
<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();doSelect111();doAmtGubunChange();">
<s:header popup="true">
<form name="form" id="form">
<input type="hidden" id="exec_no" 		name="exec_no" 		value="<%=EXEC_NO %>">
<input type="hidden" id="pay_div_cnt"	name="pay_div_cnt"	>
<input type="hidden" id="cont_no" 		name="cont_no" 		value="<%=cont_no%>">
<input type="hidden" id="flag" 			name="flag" 		value="U">
<input type="hidden" id="dilv_term"		name="dilv_term"	>
<input type="hidden" id="po_cont_flag"	name="po_cont_flag"	>
<input type="hidden" id="pay_div_count"	name="pay_div_count">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
<%@ include file="/include/sepoa_milestone.jsp"%>
<div style="display:<%=tmpId2%>">
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
    		<td height="30" align="right">
				<TABLE cellpadding="0">
	      			<TR>
    					<TD>
							<script language="javascript">btn("javascript:clipPrint()","출 력");</script>
						</TD>
						<TD>
							<script language="javascript">btn("javascript:window.close()","닫 기");</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</div>
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
			        			<td width="20%" height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약명<font color='red'><b>*</b></font>
			        			</td>
			        			<td width="30%" height="24" class="data_td">
			        				<input type="text" name="subject" size="35" value="<%=SUBJECT%>">
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약상태
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=CT_FLAG_TEXT%>
			        			</td>
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
						  	<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약구분<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
						    		<select id="sg_type1" name="sg_type1" class="inputsubmit" onchange="nextAjax('2');" disabled="disabled">
						    			<option value="">--------</option>
						    		</select>
						    	
						    		<select id="sg_type2" name="sg_type2" class="inputsubmit" onchange="nextAjax('3');" disabled="disabled">
						    			<option value="">--------</option>
						    		</select>
						    	
						    		<select id="sg_type3" name="sg_type3" class="inputsubmit" disabled="disabled">
						    			<option value="">--------</option>
						    		</select>        			
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약방법<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
			        				<select id="cont_process_flag" name="cont_process_flag" disabled="disabled"></select><!-- M809 -->
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
			        				<%=SELLER_NAME%>
			        			</td>
			       				<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				입찰방법
			        			</td>
			        			<td height="24" class="data_td">
			        				<select id="cont_type1_text" name="cont_type1_text" disabled="disabled">
			        					<option value=""></option>
			        				</select><!-- M994 -->&nbsp;&nbsp;
			        				<select id="cont_type2_text" name="cont_type2_text" disabled="disabled">
			        					<option value=""></option>
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
			        				<%=cont_from_str%> ~ <%=cont_to_str%>
			         			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약담당자<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
						        	<%=SIGN_PERSON_NAME%>
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
									<%=cont_add_date_str%>
			        			</td>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				작성일자<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">			        				
				                	<%=cont_date_str %>
			        			</td>        		
							</tr>
			        	  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
			        	  	<tr>
								<td height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				전자계약서작성 여부<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				               		<select id="ele_cont_flag" name="ele_cont_flag" onchange="chele_cont_flag()" disabled="disabled"></select><!-- M806 -->
			        			</td>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약서<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				                	<select id="cont_type" name="cont_type" class="inputsubmit" disabled="disabled"><!-- M800 -->
										<option value="">----------------</option>
									</select>
			        			</td>        		
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약금액<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=SepoaMath.SepoaNumberType(CONT_AMT, "###,###,###,###,###,###,###,###") %> (원)
			        				&nbsp;<input type="radio" id="add_tax_flag1" name="add_tax_flag" value="Y" class="radio" <%=checkY%>  disabled="disabled">부가세포함&nbsp;
			        				&nbsp;<input type="radio" id="add_tax_flag2" name="add_tax_flag" value="N" class="radio" <%=checkX%>  disabled="disabled">면세        			        			
			        			</td>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약이행 보증구분<font color='red'><b>*</b></font>
			        			</td>
			        			<td height="24" class="data_td">
				               		<select id="assure_flag" name="assure_flag" disabled="disabled"></select><!-- M807 -->
			        			</td>
						  	</tr>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
						  	<tr>
								<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				하자보증금
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=FAULT_INS_PERCENT%> (%)
			        				&nbsp;
			        				<%=SepoaMath.SepoaNumberType(FAULT_INS_AMT, "###,###,###,###,###,###,###,###")%> (원)
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약보증금
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=CONT_ASSURE_PERCENT%> (%)
			        				&nbsp;
			        				<%=SepoaMath.SepoaNumberType(CONT_ASSURE_AMT, "###,###,###,###,###,###,###,###")%> (원)					       			
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
			        				<%=FAULT_INS_TERM%> 년
									<%=FAULT_INS_TERM_MON%> 개월
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				소싱번호
			        			</td>
			        			<td height="24" class="data_td">			        				
			        				<%=sNo%>
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
				        			1000 분의 &nbsp;&nbsp;<%=DELAY_CHARGE%>
				        		</td> 
				        		<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			    	    			구매결의번호
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=TEXT_NUMBER%>
			        			</td>
						  	</tr>
							<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
						  	<tr>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				물품종류
			        			</td>
			        			<td height="24" class="data_td">
			        				<%=ITEM_TYPE %>
			        			</td>
			         			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				납품기한
			        			</td>
			        			<td height="24" class="data_td">			        						        		
				                	<%=rd_date_str %>
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
			        				<%=DELV_PLACE%>
			        			</td>
			        			<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
			        				계약단가
			        			</td>
			        			<td height="24" class="data_td">
			        				<select id="cont_total_gubun"name="cont_total_gubun" disabled="disabled">
			        					<option value=""></option>
			        				</select><!-- M813 -->&nbsp;
			        				<%=CONT_PRICE %>
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
			        				<%=REMARK%>
			        			</td>
						  	</tr>
						  	<%if("CE".equals(CT_FLAG)){ %>
						  	<tr>
								<td colspan="6" height="1" bgcolor="#dedede"></td>
							</tr>
						  	<tr>
						  		<td height="24"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
						  			변경요청사유
						  		</td>
						  		<td height="24" class="data_td" colspan="3">
						  			<%=REJECT_REASON %>
						  		</td>
						  	</tr>
							<%} %>
							<%if(!"".equals(IN_ATTACH_NO)){ %>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
						    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일
								</td>
								<td width="85%" class="data_td" colspan="3">
									<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=IN_ATTACH_NO%>&view_type=VI" style="width: 98%;height: 102px; border: 0px;" frameborder="0" ></iframe>
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
	<div id="gridbox" name="gridbox" width="100%"  height="200px" style="background-color:white;"></div>
</div>	
</s:header>
<s:footer/>
<iframe name="childFrame" src="empty.htm" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>