<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
	thisWindowPopupScreenName = "입찰생성";

	Config conf = new Configuration();
	boolean dev_flag = false;
	String ssn = ""; // 사업자등록번호

	String sign_use_module = "";// 전자결재 사용모듈
	boolean sign_use_yn = true;
	
    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateDay( to_day, -30 );
    String  to_date     = to_day;
 
	String PR_DATA = JSPUtil.nullToRef(request.getParameter("PR_DATA"),""); 
 
	String SUBJECT		= JSPUtil.nullToRef(request.getParameter("T_SUBJECT"), "");	
	String pr_type = JSPUtil.nullToEmpty(request.getParameter("PR_TYPE"));
	String req_type = JSPUtil.nullToEmpty(request.getParameter("REQ_TYPE"));  
	String BID_STATUS = JSPUtil.nullToEmpty(request.getParameter("BID_STATUS")); 
	String BID_NO = JSPUtil.nullToEmpty(request.getParameter("BID_NO")); // 생성/수정/확정/상세조회
	String BID_COUNT = JSPUtil.nullToEmpty(request.getParameter("BID_COUNT")); // 생성/수정/확정/상세조회 

	String BID_TYPE = JSPUtil.nullToRef(request.getParameter("BID_TYPE"), "D");
	String CTRL_AMT = JSPUtil.nullToRef(request.getParameter("CTRL_AMT"), "0"); // 통제금액
	String SCR_FLAG = JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "I"); // 생성/수정/확정/상세조회 flag 
					 
	String HOUSE_CODE = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String USER_ID = info.getSession("ID");

	String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	///////////////////////////////

	String script = "";
	String abled = "";
	String script_c = "";
	String abled_c = "";

	if (SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script = "readonly";
		abled = "disabled";
	}

	if (SCR_FLAG.equals("C")) { // 확정(공고)일때 변경 가능한 항목 설정
		script_c = "";
		abled_c = "";
	}

	///////////////////////////////
	String CONT_TYPE1 = "";
	String CONT_TYPE2 = "";
	String ANN_TITLE = "";
	String ANN_NO = "";
	String ANN_DATE = "";
	String ANN_ITEM = SUBJECT;
	String RD_DATE = "";
	String DELY_PLACE = "";
	String LIMIT_CRIT = "";
	String PROM_CRIT = "";
	String APP_BEGIN_DATE = "";
	String APP_BEGIN_TIME = "";
	String APP_END_DATE = "";
	String APP_END_TIME = "";
	String APP_PLACE = "";
	String APP_ETC = "";
	String ATTACH_NO = "";
	String ATTACH_CNT = "0";
	String VENDOR_CNT = "0";
	String VENDOR_VALUES = "";
	String LOCATION_CNT = "0";
	String LOCATION_VALUES = "";
	String LOC_CODE = "";
	String LOC_CNT = "0";
	String ANNOUNCE_DATE = "";
	String ANNOUNCE_TIME_FROM = "";
	String ANNOUNCE_TIME_TO = "";
	String ANNOUNCE_AREA = "";
	String ANNOUNCE_PLACE = "";
	String ANNOUNCE_NOTIFIER = "";
	String ANNOUNCE_RESP = "";
	String DOC_FRW_DATE = "";
	String ANNOUNCE_COMMENT = "";
	String ANNOUNCE_FLAG = "";
	String ANNOUNCE_TEL = "";
	String ESTM_FLAG = "";
	String COST_STATUS = "";
	String BID_BEGIN_DATE = "";
	String BID_BEGIN_TIME = "";
	String BID_END_DATE = "";
	String BID_END_TIME = "";
	String BID_PLACE = "";
	String BID_ETC = "";
	String OPEN_DATE = "";
	String OPEN_TIME = "";
	String REPORT_ETC = "";

	/*
	String APP_BEGIN_TIME_HOUR    	= "00";
	String APP_BEGIN_TIME_MINUTE  	= "00";
	String APP_END_TIME_HOUR   		= "00";
	String APP_END_TIME_MINUTE    	= "00";
	String BID_BEGIN_TIME_HOUR     	= "00";
	String BID_BEGIN_TIME_MINUTE  	= "00";
	String BID_END_TIME_HOUR   		= "00";
	String BID_END_TIME_MINUTE    	= "00";
	String OPEN_TIME_HOUR          	= "00";
	String OPEN_TIME_MINUTE       	= "00";
	 */

	String APP_BEGIN_TIME_HOUR_MINUTE = "0000";
	String APP_END_TIME_HOUR_MINUTE = "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE = "0000";
	String BID_END_TIME_HOUR_MINUTE = "0000";
	String OPEN_TIME_HOUR_MINUTE = "0000";

	String origin_bid_status = SCR_FLAG + BID_STATUS;

	String ESTM_KIND = "";
	String ESTM_RATE = "";
	String ESTM_MAX = "";
	String ESTM_VOTE = "";
	String FROM_CONT = "";
	String FROM_CONT_TEXT = "";
	String FROM_LOWER_BND = "";
	String ASUMTN_OPEN_YN = "";

	String CONT_TYPE_TEXT = "";
	String CONT_PLACE = "";
	String BID_PAY_TEXT = "";
	String BID_CANCEL_TEXT = "";
	String BID_JOIN_TEXT = "";
	String REMARK = "";
	String ESTM_MAX_VOTE = "";

	String STANDARD_POINT = "";
	String TECH_DQ = "";
	String AMT_DQ = "";
	String BID_EVAL_SCORE = ""; 
	String PR_NO = "";
 
	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPrHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]); 

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	
    if(wf.getRowCount() > 0) {

		if (!(origin_bid_status).equals("IAR")) { // 입찰공고 작성을 하려는 경우외에는 기존에 data를 조회해 온다.
			CONT_TYPE1 = wf.getValue("CONT_TYPE1", 0);
			CONT_TYPE2 = wf.getValue("CONT_TYPE2", 0);
			ANN_TITLE = wf.getValue("ANN_TITLE", 0);
			ANN_NO = wf.getValue("ANN_NO", 0);
			ANN_DATE = wf.getValue("ANN_DATE", 0);
			ANN_ITEM = wf.getValue("ANN_ITEM", 0);
			RD_DATE = wf.getValue("RD_DATE", 0);
			DELY_PLACE = wf.getValue("DELY_PLACE", 0);
			LIMIT_CRIT = wf.getValue("LIMIT_CRIT", 0);
			PROM_CRIT = wf.getValue("PROM_CRIT", 0);
			APP_BEGIN_DATE = wf.getValue("APP_BEGIN_DATE", 0);
			APP_BEGIN_TIME = wf.getValue("APP_BEGIN_TIME", 0);
			APP_END_DATE = wf.getValue("APP_END_DATE", 0);
			APP_END_TIME = wf.getValue("APP_END_TIME", 0);
			APP_PLACE = wf.getValue("APP_PLACE", 0);
			APP_ETC = wf.getValue("APP_ETC", 0);
			ATTACH_NO = wf.getValue("ATTACH_NO", 0);
			ATTACH_CNT = wf.getValue("ATTACH_CNT", 0);
			VENDOR_CNT = wf.getValue("VENDOR_CNT", 0);
			LOCATION_CNT = wf.getValue("LOCATION_CNT", 0);
			VENDOR_VALUES = wf.getValue("VENDOR_VALUES", 0);
			LOCATION_VALUES = wf.getValue("LOCATION_VALUES", 0);
			LOC_CODE = wf.getValue("LOC_CODE", 0);
			LOC_CNT = wf.getValue("LOC_CNT", 0);
			ANNOUNCE_DATE = wf.getValue("ANNOUNCE_DATE", 0);
			ANNOUNCE_TIME_FROM = wf.getValue("ANNOUNCE_TIME_FROM", 0);
			ANNOUNCE_TIME_TO = wf.getValue("ANNOUNCE_TIME_TO", 0);
			ANNOUNCE_AREA = wf.getValue("ANNOUNCE_AREA", 0);
			ANNOUNCE_PLACE = wf.getValue("ANNOUNCE_PLACE", 0);
			ANNOUNCE_NOTIFIER = wf.getValue("ANNOUNCE_NOTIFIER", 0);
			ANNOUNCE_RESP = wf.getValue("ANNOUNCE_RESP", 0);
			DOC_FRW_DATE = wf.getValue("DOC_FRW_DATE", 0);
			ANNOUNCE_COMMENT = wf.getValue("ANNOUNCE_COMMENT", 0);
			ANNOUNCE_FLAG = wf.getValue("ANNOUNCE_FLAG", 0);
			ANNOUNCE_TEL = wf.getValue("ANNOUNCE_TEL", 0);
			BID_STATUS = wf.getValue("BID_STATUS", 0);
			ESTM_FLAG = wf.getValue("ESTM_FLAG", 0);
			COST_STATUS = wf.getValue("COST_STATUS", 0);
			BID_BEGIN_DATE = wf.getValue("BID_BEGIN_DATE", 0);
			BID_BEGIN_TIME = wf.getValue("BID_BEGIN_TIME", 0);
			BID_END_DATE = wf.getValue("BID_END_DATE", 0);
			BID_END_TIME = wf.getValue("BID_END_TIME", 0);
			BID_PLACE = wf.getValue("BID_PLACE", 0);
			BID_ETC = wf.getValue("BID_ETC", 0);
			OPEN_DATE = wf.getValue("OPEN_DATE", 0);
			OPEN_TIME = wf.getValue("OPEN_TIME", 0);

			APP_BEGIN_TIME_HOUR_MINUTE = wf.getValue( "APP_BEGIN_TIME_HOUR", 0) + wf.getValue("APP_BEGIN_TIME_MINUTE", 0);
			APP_END_TIME_HOUR_MINUTE = wf.getValue("APP_END_TIME_HOUR", 0) + wf.getValue("APP_END_TIME_MINUTE", 0);
			BID_BEGIN_TIME_HOUR_MINUTE = wf.getValue( "BID_BEGIN_TIME_HOUR", 0) + wf.getValue("BID_BEGIN_TIME_MINUTE", 0);
			BID_END_TIME_HOUR_MINUTE = wf.getValue("BID_END_TIME_HOUR", 0) + wf.getValue("BID_END_TIME_MINUTE", 0);
			OPEN_TIME_HOUR_MINUTE = wf.getValue("OPEN_TIME_HOUR", 0) + wf.getValue("OPEN_TIME_MINUTE", 0);

			PR_NO = wf.getValue("PR_NO", 0);
			BID_TYPE = wf.getValue("BID_TYPE", 0);

			ESTM_KIND = wf.getValue("ESTM_KIND", 0);
			ESTM_RATE = wf.getValue("ESTM_RATE", 0);
			ESTM_MAX = wf.getValue("ESTM_MAX", 0);
			ESTM_VOTE = wf.getValue("ESTM_VOTE", 0);
			FROM_CONT = wf.getValue("FROM_CONT", 0);
			FROM_CONT_TEXT = wf.getValue("FROM_CONT_TEXT", 0);
			FROM_LOWER_BND = wf.getValue("FROM_LOWER_BND", 0);
			ASUMTN_OPEN_YN = wf.getValue("ASUMTN_OPEN_YN", 0);

			CONT_TYPE_TEXT = wf.getValue("CONT_TYPE_TEXT", 0);
			CONT_PLACE = wf.getValue("CONT_PLACE", 0);
			BID_PAY_TEXT = wf.getValue("BID_PAY_TEXT", 0);
			BID_CANCEL_TEXT = wf.getValue("BID_CANCEL_TEXT", 0);
			BID_JOIN_TEXT = wf.getValue("BID_JOIN_TEXT", 0);

			REMARK = wf.getValue("REMARK", 0);
			ESTM_MAX_VOTE = wf.getValue("ESTM_MAX_VOTE", 0);

			STANDARD_POINT = wf.getValue("STANDARD_POINT", 0);
			TECH_DQ = wf.getValue("TECH_DQ", 0);
			AMT_DQ = wf.getValue("AMT_DQ", 0);
			BID_EVAL_SCORE = wf.getValue("BID_EVAL_SCORE", 0);
			REPORT_ETC = wf.getValue("REPORT_ETC", 0);
		}
	 
	}  

	if (origin_bid_status.equals("IUR")) // 정정공고 작성 대상건일 경우에는 BID_STATUS = 'UR' 로 확정한다.
		BID_STATUS = "UR";
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
<script language="javascript" type="text/javascript">

var explanation_modify_flag = "false";
var button_flag 	= false;
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_ann";

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var j=0;

function init() {
	//생성시 디폴트값 세팅
	<%if (SCR_FLAG.equals("I") && !BID_STATUS.equals("UR")) {%>
		document.form.LIMIT_CRIT.value = "o 참가 자격을 구비한 업체로 소정 기일내에 입찰참가 등록을 필하여야 함.";
		document.form.LIMIT_CRIT.value = document.form.LIMIT_CRIT.value + "\no 입찰 설명회에 참석한 자에 한함";
		document.form.BID_PAY_TEXT.value = "";
		document.form.BID_CANCEL_TEXT.value = "";
		document.form.BID_JOIN_TEXT.value = "";
		document.form.REMARK.value = "<%//=questtel%>";
	    document.form.FROM_LOWER_BND.value = 80;
	    document.form.TECH_DQ.value = 0; // 기술점수 비율
	    document.form.AMT_DQ.value = 100; // 가격점수 비율
	    document.form.BID_EVAL_SCORE.value = 1;
	<%}%>
	document.forms[0].CONT_TYPE2.value = "LP";

	if ("<%=SCR_FLAG%>" == "I") {
		document.form.ANN_DATE.value = current_date;
	}
	setGridDraw();
}

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();
	doQuery();
	setVisibleVendor(); // 업체지정
	//checkExplanation();
}
 
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{ 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue(); 
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명

    var filter          = /[a-zA-Z-]/;
    var PR_QTY         = GridObj.cells( rowId, GridObj.getColIndexById( "QTY" )        ).getValue();   // 수량 
    var UNIT_PRICE    = GridObj.cells( rowId, GridObj.getColIndexById( "UNIT_PRICE" )   ).getValue();   // 단가 
    var PR_AMT      = GridObj.cells( rowId, GridObj.getColIndexById( "AMT" )   ).getValue();   // 금액
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
    	
        if( header_name == "QTY" ) {
            PR_AMT  = PR_QTY * UNIT_PRICE;   
            GridObj.cells(rowId, GridObj.getColIndexById( "AMT" )    ).setValue( PR_AMT      );  
             
        }
        if( header_name == "UNIT_PRICE" ) {
            PR_AMT  = PR_QTY * UNIT_PRICE;    
            GridObj.cells(rowId, GridObj.getColIndexById( "AMT" )    ).setValue( PR_AMT      );  
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
	var bid_no = obj.getAttribute("bid_no");
	var bid_count = obj.getAttribute("bid_count");
	var pflag = obj.getAttribute("pflag");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") { 
		document.forms[0].bid_no.value = bid_no;
		document.forms[0].bid_count.value  = bid_count;
		
		if(mode == "setAnnCreate" || mode == "setGonggoModify" || mode == "setUGonggoCreate") {
			//alert("[입찰공고번호 : "+bid_no + " ]"+ messsage);
			alert("입찰공고가 "+ messsage);
			if(pflag == "P"){
					poApproval();
			}else{
				// opener 페이지 견적요청시 저장되는 input  클리어(조회조건과 겹치게 된다)
				opener.doSelect();
				window.close();
				//setSubimt(rfq_number); 
			} 
		}else if(mode == "setGonggoConfirm") {
			alert(messsage);
			opener.doQuery();
			window.close();
			//setSubimt(rfq_number);
		}else{
	        alert(messsage);
			opener.doQuery();
			window.close();
		}
    } else {
        alert(messsage);
    } 
    return false;
}

function poApproval(){ 

	var grid_array 		= getGridChangedRows(GridObj, "SELECTED");
	
	var url = "<%=POASRM_CONTEXT_NAME%>/sourcing/app_approval.jsp";
	doOpenPopup(url, '600', '600','app_pop_up'); 
}

/**
 * 결재요청 결제선 popup 에서 결제재선을 return 받아.
 * 상신 로직을 호출한다. 
 */
function return_app_line( app_line_id , app_line_seq , app_auto_flag) {

	var app_line = app_line_id + "##" + app_line_seq + "##" + app_auto_flag;
	
	document.forms[0].app_line_id.value  = app_line_id;
	document.forms[0].app_line_seq.value = app_line_seq;
	document.forms[0].app_auto_flag.value = app_auto_flag;
	
	document.forms[0].app_line.value     = app_line;
    
    getApproval( app_line );
    
} // end of function return_app_line



/**
 * 결재요청 결제선 popup 에서 결제재선을 return 받아.
 * 상신 로직을 호출한다. 
 */
function getApproval( Approval_str ) {
    if (Approval_str == "") {
        alert( "<%=text.get("PR_001.MSG_0002")%>" ); // 결재자를 지정해 주세요.
        return;

    } // end if

    var grid_array = getGridChangedRows( GridObj, "SELECTED" );
    var cols_ids   = grid_col_id;
	
    var params  =       "mode"         + "=" + "setApprovalRequest";
        params += "&" + "APPROVAL_STR" + "=" + encodeUrl(Approval_str); // 결재요청건의 결재선
        params += "&" + "cols_ids"     + "=" + cols_ids;
        params += dataOutput();
        
    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
    
} // end of function getApproval
/**
 * 저장 = 'T', 결재요청='P', 확정= 'C'
 */
function Approval(sign_status)
{
	//alert(document.form.vendor_count.value);
	if (LRTrim(document.form.RD_DATE.value) != "")
	{ 
		if(eval(del_Slash(document.forms[0].RD_DATE.value)) < eval(del_Slash(document.forms[0].ANN_DATE.value)))
		{
			document.forms[0].RD_DATE.select();
			alert("납기일자는 공고일자보다 이후일자여야 합니다.");
			return;
		}
		else if(eval(del_Slash(document.forms[0].RD_DATE.value)) < eval(del_Slash(document.forms[0].APP_END_DATE.value))) {
			document.forms[0].RD_DATE.select();
			alert("납기일자는 참가신청일시보다 이후일자여야 합니다.");
			return;
		}
		else if(eval(del_Slash(document.forms[0].RD_DATE.value)) < eval(del_Slash(document.forms[0].OPEN_DATE.value))) {
			document.forms[0].RD_DATE.select();
			alert("납기일자는 개찰일시보다 이후일자여야 합니다.");
			return;
		}
		else if(eval(del_Slash(document.forms[0].RD_DATE.value)) < eval(del_Slash(document.forms[0].BID_END_DATE.value))) {
			document.forms[0].RD_DATE.select();
			alert("납기일자는 입찰서제출일시보다 이후일자여야 합니다.");
			return;
		}
	}
	// 저장 = 'T', 결재요청='P', 작성완료='E', 입찰공고='C'
	G_FLAG = sign_status;
	if(button_flag == true) {
		//alert("작업이 진행중입니다.");
		//return;
	}
	button_flag = true;
	if (checkData() == false) {
		button_flag = false;
		return;
	} 
		goSave(sign_status); 
}
 
function doQuery() {
	 
	var SCR_FLAG = "<%=SCR_FLAG%>";
	var BID_STATUS = "<%=BID_STATUS%>";
	
	if(SCR_FLAG == "I" && BID_STATUS == "AR"){  //신규
	   
	        var cols_ids = "<%=grid_col_id%>";
	        var params = "mode=getPrItemDetail";
	        params += "&cols_ids=" + cols_ids;
	        params += dataOutput(); 
	        GridObj.post( G_SERVLETURL, params );
	        GridObj.clearAll(false);
	}else{

        var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getBdItemDetail";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params );
        GridObj.clearAll(false);
	}
	 
}
function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
	}	
    if( GridObj.getRowsNum() > 0 ) {

        supiFlame.rfq_no = "<%=BID_NO%>";
        supiFlame.rfq_count = "<%=BID_COUNT%>"; 

		var	SELLER_SELECTED = LRTrim(GridObj.cells(1, GridObj.getColIndexById("SELLER_SELECTED")).getValue());
		var SELLER = SELLER_SELECTED.split("#");
		var seller_codes = "";
		for (var i = 0 ; i < SELLER.length ; i++){
			seller_codes += SELLER[i].split("@")[0] + "@";
		}
        supiFlame.doSelect(seller_codes,null,null,"BID");
    }
    
    document.forms[0].ANN_DATE.value          = add_Slash( document.forms[0].ANN_DATE.value          );
    document.forms[0].X_DOC_SUBMIT_DATE.value = add_Slash( document.forms[0].X_DOC_SUBMIT_DATE.value );
    document.forms[0].APP_BEGIN_DATE.value    = add_Slash( document.forms[0].APP_BEGIN_DATE.value    );
    document.forms[0].APP_END_DATE.value      = add_Slash( document.forms[0].APP_END_DATE.value      );
    document.forms[0].BID_BEGIN_DATE.value    = add_Slash( document.forms[0].BID_BEGIN_DATE.value    );
    document.forms[0].BID_END_DATE.value      = add_Slash( document.forms[0].BID_END_DATE.value      );
    document.forms[0].OPEN_DATE.value         = add_Slash( document.forms[0].OPEN_DATE.value         );
    document.forms[0].RD_DATE.value           = add_Slash( document.forms[0].RD_DATE.value           );

	setVisiblePeriod(); // 
	setVisibleESTM(); // 단일예가/복수예가
    return true;
}

function initAjax()
{ 
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M974' ,'CONT_TYPE1', '<%=CONT_TYPE1%>' );  
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M973' ,'CONT_TYPE2', '<%=CONT_TYPE2%>' );  
		doRequestUsingPOST( 'SL0018', '<%=HOUSE_CODE%>'+'#M930' ,'PROM_CRIT', '<%=PROM_CRIT%>' );  
}
/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
function setVisibleVendor() {
	var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value; // 입찰방법
	
	if ( CONT_TYPE1 == "NC" ) { // 지명경쟁
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).hide();
			//document.all["h1"+m].style.visibility = "hidden";
		}
		document.forms[0].LOC_CNT.value = "0";
		//document.forms[0].location_count.value = "0";
	}
	else if ( CONT_TYPE1 == "LC" ) { // 지역공개경쟁
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).show();
			//document.all["h1"+m].style.visibility = "visible";
		}
		for(n=1;n<=4;n++) { // 업체지정
			$('#h' + m).hide();
			//document.all["h"+n].style.visibility = "hidden";
		}
		document.forms[0].vendor_values.value = "";
		document.forms[0].seller_cnt.value = "0";
	}
	else { // 일반경쟁
		/*for(n=1;n<=4;n++) { // 업체지정
			document.all["h"+n].style.visibility = "hidden";
		}*/
		document.forms[0].vendor_values.value = "";
		document.forms[0].vendor_count.value = "0";
		
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).hide();
			//document.all["h1"+m].style.visibility = "hidden";
		}
		//document.forms[0].location_count.value = "0";
		document.forms[0].LOC_CNT.value = "0";
	}
}

/**
 * 입찰방법(총액, 2단계경쟁, 수의계약)
 */
function setVisiblePeriod() {
	var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;
	
	if ( CONT_TYPE2 == "LP" ) { // 총액입찰
		for(n=1;n<=22;n++) {
// 			document.all["g"+n].style.display = ""; // 입찰서 제출일시, 개찰일시
			$("#g"+n).show();
// 			$("#contDiv1").show();
		}
		for(m=1;m<=13;m++) {
// 			document.all["i"+m].style.display = "none"; // 입찰참가 신청일시
			$("#i"+m).hide();
// 			$("#contDiv1").hide();
		}
	    //document.form1.TECH_DQ.value = 80; // 기술점수 비율
	    //document.form1.AMT_DQ.value = 20; // 가격점수 비율
		for(x=1;x<=12;x++) {
// 			document.all["q"+x].style.display = ""; // 기준점수(1~6), 점수비율(7~12)
			$("#q"+x).show();
// 			$("#contDiv1").show();
		}
		$("#contDiv1").hide();
	} else { // 2단계 및 협상에 의한 계약
		for(n=1;n<=22;n++) {
// 			document.all["g"+n].style.display = "none"; // 입찰서 제출일시, 개찰일시
			$("#g"+n).hide();
			$("#contDiv1").hide();
		}
		for(m=1;m<=13;m++) {
// 			document.all["i"+m].style.display = ""; // 입찰참가 신청일시
			$("#i"+m).show();
			$("#contDiv1").show();
		}
		for(x=1;x<=6;x++) {
// 			document.all["q"+x].style.display = ""; // 기준점수(1~6)
			$("#q"+x).show();
			$("#contDiv1").show();
		}
		if (( CONT_TYPE2 == "TE" ) || ( CONT_TYPE2 == "NE" )){ // 2단계 및 협상에 의한 계약
			for(x=1;x<=12;x++) { // 기준점수(1~6), 점수비율(7~12)
// 				document.all["q"+x].style.display = "";
				$("#q"+x).show();
// 				$("#contDiv1").show();
			}
		}else{
			for(x=1;x<=12;x++) {
// 				document.all["q"+x].style.display = "none";
				$("#q"+x).hide();
// 				$("#contDiv1").hide();
			}
		}
		$("#contDiv1").show();
	}
	
	// IBKS 총액도 2단계, 협상에 의한 계약과 같게 프로세스를 진행시킨다. 입찰참가신청 프로세스 추가되기 때문에.
	/*for(n=1;n<=22;n++) {
		document.all["g"+n].style.display = "none";
	}
	for(m=1;m<=13;m++) {
		document.all["i"+m].style.display = "";
	}
	for(x=1;x<=6;x++) {
		document.all["q"+x].style.display = "";
	}
	for(x=1;x<=12;x++) {
		document.all["q"+x].style.display = "";
	}
	document.all.q5.style.display = "none";
	*/
}
/**
 * 단일예가/복수예가 체크
 */
function setVisibleESTM()   {
	var ESTM_KIND = document.forms[0].ESTM_KIND.value;

	if ( ESTM_KIND  == "M"  ) { // 복수예가
		for(n=1;n<=1;n++) {
			document.all["e"+n].style.display = "";
		}
		//생성시 디폴트값 세팅
		<%if (SCR_FLAG.equals("I")) {%>
			document.form.ESTM_RATE.value = 2;
		<%}%>
	} else { // 단일예가
		for(n=1;n<=1;n++) {
			document.all["e"+n].style.display = "none";
		}
		document.forms[0].ESTM_VOTE.value = "2";
		document.forms[0].ESTM_MAX.value = "";
		document.forms[0].ESTM_RATE.value = "";
	}
}
//업체지정
 	 function vendor_Select() {	 
	 
	 	document.form.vendor_each_flag.value = "0";
		
		load_type = 0;
		var cnt = 0;
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var MATERIAL_NUMBER = "";
		var SOURCING_GROUP = "";
		var DESCRIPTION_LOC = "";
		var selller_selected = "";
		for(var i = 0; i < grid_array.length; i++){
			var selected_count = GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED_CNT")).getValue();
			//alert("selected_count=="+selected_count);
			selller_selected = GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED")).getValue();	
			//alert("selller_selected=="+selller_selected);
			MATERIAL_NUMBER += GridObj.cells(grid_array[i], GridObj.getColIndexById("ITEM_NO")).getValue()+"@@";
			 
			if( 0 < parseInt(selected_count)){
			  	cnt++;
			}
		} 	

		if(cnt == 0) {
			getVenderList("-1", "E", selller_selected,MATERIAL_NUMBER);
		} else if(cnt > 0) {
			getVenderList("-1", "A", selller_selected,MATERIAL_NUMBER);
		}
	}
	
	function getVenderList(szRow, mode,selller_selected,MATERIAL_NUMBER) {
		var shipper_type = 'D';
		var company_code = "<%=COMPANY_CODE%>";
		var param        = "&mode=" + encodeUrl(mode) + "&szRow=" + encodeUrl(szRow);//+"&selller_selected="+selller_selected;
		
		if(document.form.vendor_each_flag.value != "1"){ //버튼클릭하여 업체지정시
			param += "&type=button";
		}
		
		param +=  "&shipper_type="+encodeUrl(shipper_type)+"&MATERIAL_NUMBER="+MATERIAL_NUMBER+"&company_code="+company_code;		
		popUpOpen("rfq_req_sellerselframe.jsp?popup_flag=true"+param, 'RFQ_REQ_SELLERSELFRAME', '880', '660');
		//window.open('/kr/dt/rfq/rfq_pp_ins2.jsp?mode=' + mode + '&szRow=' + szRow + '&shipper_type='+shipper_type+"&SG_REFITEM="+MATERIAL_NUMBER, "rfq_pp_ins2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1000,height=580,left=0,top=0");
	}
	
	function vendor_Select_Each() {
		load_type = 0;
		var cnt = 0;
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		var seller_cnt = GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SELLER_SELECTED_CNT")).getValue();
		var MATERIAL_NUMBER = GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("ITEM_NO")).getValue();
		var	DESCRIPTION_LOC = GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
		var	SOURCING_GROUP = GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SOURCING_GROUP")).getValue();
					
		if( 0 < parseInt(seller_cnt)){
		  	cnt++;
		}

		if(cnt == 0) {
			getVenderList("-1", "E",'',MATERIAL_NUMBER,DESCRIPTION_LOC,SOURCING_GROUP);

		} else if(cnt > 0) {
			getVenderList("-1", "A",'',MATERIAL_NUMBER,DESCRIPTION_LOC,SOURCING_GROUP);
			
		}
	}	
	
	function vendorInsert(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
		setVendorList(szRow, VANDOR_SELECTED, SELECTED_COUNT);
	}

	function setVendorList(szRow, VANDOR_SELECTED, SELECTED_COUNT) {
		 
		dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";   	

		if(document.form.vendor_each_flag.value != "1"){//헤더의 업체선택 버튼을 클릭한 경우
    		document.form.seller_cnt.value = SELECTED_COUNT;
			var grid_array = getGridChangedRows(GridObj, "SELECTED");
			
			for(var i = 0; i < grid_array.length; i++){
				GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED")).setValue(VANDOR_SELECTED);
				GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED_CNT")).setValue(SELECTED_COUNT);
			}
		}
		else{//그리드의  업체선택 버튼을 클릭한 경우
			GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SELLER_SELECTED")).setValue(VANDOR_SELECTED);
			GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SELLER_SELECTED_CNT")).setValue(SELECTED_COUNT);
		}
		document.form.seller_choice.value="1";
		document.form.vendor_values.value=VANDOR_SELECTED;
	}
	
	function getCompany(szRow) {
					
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		for(var i = 0; i < grid_array.length; i++){
		
			GridObj.cells(szRow, GridObj.getColIndexById("SELLER_SELECTED")).getValue();
			GridObj.cells(szRow, GridObj.getColIndexById("SELLER_SELECTED_CNT")).getValue();
		}
		return;
	}
	
	//그리드에서 업체지정 했을때 호출하는 펑션
	function getAllCompany() 
	{
		var value = "";
		var com_data = "";
		var F_VENDOR_CODE = "";
		var S_VENDOR_CODE = "";
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		if(document.form.rownum.value == ""){
			rows = "1";
		}
		else{
			rows = document.form.rownum.value;		
		}
		
		value += GridObj.cells(rows, GridObj.getColIndexById("SELLER_SELECTED")).getValue();

		var m_values = value.split("#"); 
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
	
	//업체지정 버튼 을 눌렀을때 호출하는 펑션
	function getAllCompanyTotal() 
	{
		var value = "";
		var com_data = "";
		var F_VENDOR_CODE = "";
		var S_VENDOR_CODE = "";
		var rows          = "";
		
		
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		
		if(document.form.rownum.value == ""){
			rows = "1";
		}
		else{
			rows = document.form.rownum.value;		
		}
		
		value = GridObj.cells(rows, GridObj.getColIndexById("SELLER_SELECTED")).getValue();
				
		var m_values = value.split("#");
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
  
 
    // 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	/**
	 * 기준점수 체크
	 */
	function check_STANDARD_POINT()
	{
		if(!IsNumber(document.form.STANDARD_POINT.value)){
			alert("기준 점수는 숫자만 입력 가능합니다.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}
		var check = parseFloat(document.form.STANDARD_POINT.value);
		if(check > 100){
			alert("기준 점수는 100을 넘을수 없습니다.");
			document.forms[0].STANDARD_POINT.focus();
			return;
		}
	}
	
	/**
	 * 점수비율 체크
	 */
	function check_AMT_DQ(){
		if(!IsNumber(document.form.AMT_DQ.value)||!IsNumber(document.form.TECH_DQ.value)){
			alert("점수비율은 숫자만 입력 가능합니다.");
			//document.forms[0].STANDARD_POINT.focus();
			return;
		}

		var AMT_DQ = parseFloat(document.form.AMT_DQ.value);
		var TECH_DQ = parseFloat(document.form.TECH_DQ.value);
		var BID_EVAL_SCORE = parseFloat(document.form.BID_EVAL_SCORE.value);
		if(TECH_DQ+AMT_DQ != 100 && document.form.TECH_DQ.value != "" && document.form.AMT_DQ.value != ""){
			alert("점수비율은 100% 입니다.");
			//document.forms[0].AMT_DQ.focus();
			return;
		}
	}
	
	/**
	 * 입찰서 제출일시 체크
	 */
	function bin_end_time_event()
	{
		var bid_end_time = document.form.BID_END_TIME_HOUR_MINUTE.value;
		var hh,modifyhh;
	
		if(!checkDateCommon(document.form.BID_END_DATE.value)){
			document.form.BID_END_DATE.focus();
			alert("입찰서 제출일를 확인하세요.");
			return false;
		}
		if(!TimeCheck(bid_end_time)){
			document.form.BID_END_TIME_HOUR_MINUTE.focus();
			alert("입찰서 제출일시 확인하세요.");
			return false;
		}
	}
	
	/**
	 * 시간 체크
	 */
	function TimeCheck(str)
	{
		var hh,mm;
		
	  	if(str.length == 0)
			return true;
		
	  	if(IsNumber1(str)==false || str.length !=4 )
			return false;
		
	  	hh=str.substring(0,2);
	  	mm=str.substring(2,4);
		
	  	if(parseInt(hh)<0 || parseInt(hh)>23)
			return false;
		
	  	if(parseInt(mm)<0 || parseInt(mm)>59)
			return false;
		
	  	return true;
	}

	function checkData()
	{
		if("<%=BID_TYPE%>" == "O") {
			if(LRTrim(document.form.ANN_NO.value) == "") {
				alert("공고번호를 입력하세요. ");
				document.forms[0].ANN_NO.focus();
				return false;
			}
		}

		if(LRTrim(document.form.ANN_DATE.value) == "") {
			alert("공고일자를 입력하세요. ");
			document.forms[0].ANN_DATE.focus();
			return false;
		}
<%--
		if(!checkDateCommon(document.form.ANN_DATE.value)){
			document.forms[0].ANN_DATE.select();
			alert("공고일자를 확인하세요.");
			return false;
		}
--%>
		if("<%=SCR_FLAG%>" == "C") {
			if(parseFloat(del_Slash(document.form.ANN_DATE.value)) < parseFloat(current_date)) {
				alert("공고일자가 지난 건은 확정할 수 없습니다.");
				return false;
			}
		}

		if(LRTrim(document.form.ANN_ITEM.value) == "") {
			alert("입찰건명을 입력하세요. ");
			document.forms[0].ANN_ITEM.focus();
			return false;
		}
		
		// 지명경쟁인 경우
		if(LRTrim(document.form.CONT_TYPE1.value) == "NC") {
			if("<%=SCR_FLAG%>" == "I" && LRTrim(document.form.seller_cnt.value) == "0")  {
				alert("업체지정을 하셔야 합니다.");
				return false;
			}
		} else { // 일반경쟁인 경우
			if(eval(LRTrim(document.form.seller_cnt.value)) > 0)  {
				alert("업체지정을 하실수 없습니다.");
				return false;
			}
		}
		
		// 지역경쟁인 경우 지역지정
// 		if(LRTrim(document.form.CONT_TYPE1.value) == "LC") {
// 			if(LRTrim(document.form.location_count.value) == "0")  {
// 				alert("지역지정을 하셔야 합니다.");
// 				return false;
// 			}
// 		} else { // 지역경쟁이 아닌경우 지역지정 안함
// 			if(eval(LRTrim(document.form.location_count.value)) > 0)    {
// 				alert("지역지정을 하실수 없습니다.");
// 				return false;
// 			}
// 		}
		
		if(LRTrim(document.form.PROM_CRIT.value) == "C" && (document.form.TECH_DQ.value == 0 || !IsNumber(document.form.TECH_DQ.value))) {
			alert("낙찰자 선정기준이 종합평가(가격/기술)입니다.\n기술제안서 점수비율을 입력해야 합니다.");
			document.forms[0].TECH_DQ.focus();
			return false;
		}
				
		if(LRTrim(document.form.CONT_TYPE2.value) != "LP") { // 최저가 아닐경우...
			if(LRTrim(document.form.APP_BEGIN_DATE.value) == "") {
				alert("참가신청일시를 입력하세요. ");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			}
<%--
			if(!checkDateCommon(document.form.APP_BEGIN_DATE.value)){
				document.forms[0].APP_BEGIN_DATE.select();
				alert("참가신청일시를 확인하세요.");
				return false;
			}
--%>
			if(LRTrim(document.form.APP_END_DATE.value) == "") {
				alert("참가신청일시를 입력하세요. ");
				document.forms[0].APP_END_DATE.focus();
				return false;
			}
<%--
			if(!checkDateCommon(document.form.APP_END_DATE.value)){
				document.forms[0].APP_END_DATE.select();
				alert("참가신청일시를 확인하세요.");
				return false;
			}
			--%>
		}
		
		if(LRTrim(document.form.CONT_TYPE2.value) == "LP") { // 최저가 일경우...
			if(LRTrim(document.form.BID_BEGIN_DATE.value) == "")  {
				alert("입찰서 제출일시를 입력하셔야 합니다.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			}
<%--
			if(!checkDateCommon(document.form.BID_BEGIN_DATE.value)){
				document.forms[0].BID_BEGIN_DATE.select();
				alert("입찰서 제출일시를 확인하세요.");
				return false;
			}
--%>
			if(LRTrim(document.form.BID_END_DATE.value) == "")  {
				alert("입찰서 제출일시를 입력하셔야 합니다.");
				document.forms[0].BID_END_DATE.focus();
				return false;
			}
			<%--
			if(!checkDateCommon(document.form.BID_END_DATE.value)){
				document.forms[0].BID_END_DATE.select();
				alert("입찰서 제출일시를 확인하세요.");
				return false;
			}
--%>
			if(LRTrim(document.form.OPEN_DATE.value) == "")  {
				alert("개찰일시를 입력하셔야 합니다.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			}
			<%--
			if(!checkDateCommon(document.form.OPEN_DATE.value)){
				document.forms[0].OPEN_DATE.select();
				alert("개찰일시를 확인하세요.");
				return false;
			}
			--%>
		}
		
		if(LRTrim(document.form.LIMIT_CRIT.value) == "") {
			alert("입찰참가 자격을 입력하세요. ");
			document.forms[0].LIMIT_CRIT.focus();
			return false;
		}

		if(LRTrim(document.form.ESTM_KIND.value) == "M")   { // 복수예가인 경우
			if(LRTrim(document.form.ESTM_RATE.value) == "") {
				alert("예비가격 범위를 입력하세요. ");
				document.forms[0].ESTM_RATE.focus();
				return false;
			}
			if(LRTrim(document.form.ESTM_MAX.value) == "") {
				alert("사용예비 가격수를 입력하세요. ");
				document.forms[0].ESTM_MAX.focus();
				return false;
			}
			if(LRTrim(document.form.ESTM_VOTE.value) == "") {
				alert("추첨수를 입력하세요. ");
				document.forms[0].ESTM_VOTE.focus();
				return false;
			}
		}
		
		if(LRTrim(document.form.PROM_CRIT.value) == "") {
			alert("낙찰자선정 기준을 입력하세요.    ");
			document.forms[0].PROM_CRIT.focus();
			return false;
		}		
		
		if(LRTrim(document.form.FROM_LOWER_BND.value) == "") {
			alert("낙찰하한율을 입력하세요. ");
			document.forms[0].FROM_LOWER_BND.focus();
			return false;
		}
<%--		
		if(!checkDateCommon(document.form.RD_DATE.value)){
			document.forms[0].RD_DATE.select();
			alert("납기일자를 확인하세요.");
			return false;
		}
--%>
		var cur_hh   = current_time.substring(0,2);
		var cur_mm   = current_time.substring(2,4);

		var ANN_DATE                		= del_Slash(document.forms[0].ANN_DATE.value); // 공고일자
		
		var APP_BEGIN_DATE          		= del_Slash(document.forms[0].APP_BEGIN_DATE.value); // 참가신청일시 (from)
		var APP_BEGIN_TIME_HOUR_MINUTE      = document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.value; // 참가신청일시 (fromhour)
		var APP_END_DATE            		= del_Slash(document.forms[0].APP_END_DATE.value); // 참가신청일시   (to)
		var APP_END_TIME_HOUR_MINUTE        = document.forms[0].APP_END_TIME_HOUR_MINUTE.value; //  참가신청일시 (tohour)

		var BID_BEGIN_DATE          		= del_Slash(document.forms[0].BID_BEGIN_DATE.value); // 입찰서제출일시 (from)
		var BID_BEGIN_TIME_HOUR_MINUTE      = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value; // 입찰서제출일시 (fromhour)
		var BID_END_DATE            		= del_Slash(document.forms[0].BID_END_DATE.value); // 입찰서제출일시 (to)
		var BID_END_TIME_HOUR_MINUTE        = document.forms[0].BID_END_TIME_HOUR_MINUTE.value; //  입찰서제출일시 (tohour)

		var OPEN_DATE               		= del_Slash(document.forms[0].OPEN_DATE.value); // 개찰일시 (from)
		var OPEN_TIME_HOUR_MINUTE           = document.forms[0].OPEN_TIME_HOUR_MINUTE.value; // 개찰일시 (tohour)

		var ANNOUNCE_DATE					= del_Slash(document.forms[0].szdate.value); // 설명회 일자

		if (eval(ANN_DATE) < eval(current_date)) {
			alert ("공고일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].ANN_DATE.focus();
			return false;
		}
		
		if(LRTrim(document.form.CONT_TYPE2.value) != "LP") { // 최저가 아닐경우...
			if(document.form.APP_BEGIN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("참가신청일시를 입력하세요.");
				return false;
			}

			if(!TimeCheck(document.form.APP_BEGIN_TIME_HOUR_MINUTE.value)){
				document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("참가신청일시를 확인하세요.");
				return false;
			}

			if(document.form.APP_END_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
				alert("참가신청일시를 입력하세요.");
				return false;
			}

			if(!TimeCheck(document.form.APP_END_TIME_HOUR_MINUTE.value)){
				document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
				alert("참가신청일시를 확인하세요.");
				return false;
			}

			// 참가신청일시
			if (eval(APP_BEGIN_DATE) < eval(current_date)) {
				alert ("참가신청일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			} else if (eval(APP_BEGIN_DATE) == eval(current_date)) {
				if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
					alert ("참가신청일시의 시작시간은 현재시간보다 이후여야   합니다.");
					document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("참가신청일시의 시작시간 설정이 잘못되었습니다.");
						document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(APP_END_DATE) < eval(current_date)) {
				alert ("참가신청일시의 종료일자는 오늘보다 이후   날짜이어야 합니다.");
				document.forms[0].APP_END_DATE.focus();
				return false;
			} else if (eval(APP_END_DATE) == eval(current_date)) {
				if (eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))   < eval(cur_hh)) {
					alert ("참가신청일시의 종료시간은 현재시간보다 이후여야   합니다.");
					document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_END_TIME_HOUR_MINUTE.substring(0,2)) == eval(cur_hh))   {
					if (eval(APP_END_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert (" 참가신청일시의   종료시간 설정이 잘못되었습니다.");
						document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(APP_BEGIN_DATE) > eval(APP_END_DATE)) {
				alert ("참가신청일시의 종료일자는 시작일자보다 커야합니다.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			} else if (eval(APP_BEGIN_DATE) == eval(APP_END_DATE)) {
				if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) >   eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("참가신청일시의 종료시간은 시작시간보다 커야합니다.");
					document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(APP_END_TIME_HOUR_MINUTE.substring(0,2))) {
					if (eval(APP_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) >= eval(APP_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("참가신청일시의 종료시간   설정이 잘못되었습니다.");
						document.forms[0].APP_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// 공고일자
			if (eval(APP_BEGIN_DATE) < eval(ANN_DATE)) {
				alert ("참가신청일시 시작일자는 공고일자보다 이후 날짜이어야 합니다.");
				document.forms[0].APP_BEGIN_DATE.focus();
				return false;
			}

			// 제안설명회일자
			if (eval(APP_BEGIN_DATE) < eval(ANNOUNCE_DATE)) {
				alert ("제안설명회 개최일은 제안서 제출일보다 이전 날짜이어야 합니다.");
				return false;
			}

			if(LRTrim(document.form.CONT_TYPE2.value) == "NE") {
				/*
				if(document.form.STANDARD_POINT.value == ""){
					document.forms[0].STANDARD_POINT.focus();
					alert ("기준점수를 입력하세요.");
					return false;
				}

				if(!IsNumber(document.form.STANDARD_POINT.value)){
					alert("기준 점수는 숫자만 입력 가능합니다.");
					document.forms[0].STANDARD_POINT.focus();
					return;
				}
				*/

				if(!IsNumber(document.form.AMT_DQ.value)||!IsNumber(document.form.TECH_DQ.value)||!IsNumber(document.form.BID_EVAL_SCORE.value)){
					alert("점수비율, 평가배점은 숫자만 입력 가능합니다.");
					return;
				}

				if(LRTrim(document.form.CONT_TYPE2.value) == "PQ" || LRTrim(document.form.CONT_TYPE2.value) == "NE"){ 
					if(document.form.AMT_DQ.value == "" || document.form.TECH_DQ.value == "" || document.form.BID_EVAL_SCORE.value == ""){
						alert ("점수비율, 평가배점을 입력하세요.");
						return false;
					}
				}
			}

		}
		
		if(LRTrim(document.form.CONT_TYPE2.value) == "LP") { // 최저가 일경우...
<%--
			if(document.form.BID_BEGIN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("입찰서제출일시를 입력하세요.");
				return false;
			}

			if(!TimeCheck(document.form.BID_BEGIN_TIME_HOUR_MINUTE.value)){
				document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
				alert("입찰서제출일시를 확인하세요.");
				return false;
			}

			if(document.form.BID_END_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				alert("입찰서제출일시를 입력하세요.");
				return false;
			}

			if(!TimeCheck(document.form.BID_END_TIME_HOUR_MINUTE.value)){
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				alert("입찰서제출일시를 확인하세요.");
				return false;
			}

			if(document.form.OPEN_TIME_HOUR_MINUTE.value == ""){
				document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
				alert("개찰일시를 입력하세요.");
				return false;
			}

			if(!TimeCheck(document.form.OPEN_TIME_HOUR_MINUTE.value)){
				document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
				alert("개찰일시를 확인하세요.");
				return false;
			}

--%>
			// 입찰서제출일시
			if (eval(BID_BEGIN_DATE) < eval(current_date)) {
				alert ("입찰서제출일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			} else if (eval(BID_BEGIN_DATE) == eval(current_date)) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
					alert ("입찰서제출일시의 시작시간은 현재시간보다 이후여야 합니다.");
					document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
					if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("입찰서제출일시의 시작시간 설정이 잘못되었습니다.");
						document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(BID_END_DATE) < eval(current_date)) {
				alert ("입찰서제출일시의 종료일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].BID_END_DATE.focus();
				return false;
			} else if (eval(BID_END_DATE) == eval(current_date)) {
				if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))   < eval(cur_hh)) {
					alert ("입찰서제출일시의 종료시간은 현재시간보다 이후여야 합니다.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)) == eval(cur_hh))   {
					if (eval(BID_END_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("입찰서제출일시의 종료 시간 설정이 잘못되었습니다.");
						document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			if (eval(BID_BEGIN_DATE) > eval(BID_END_DATE)) {
				alert ("입찰서제출일시의 종료일자는 시작일자보다 커야합니다.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			} else if (eval(BID_BEGIN_DATE) == eval(BID_END_DATE)) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) >   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("입찰서제출일시의 종료시간은 시작시간보다 커야합니다.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) >= eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("입찰서제출일시의 종료시간 설정이 잘못되었습니다.");
						document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// 개찰일시
			if (eval(OPEN_DATE) < eval(current_date)) {
				alert ("개찰일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			} else if (eval(OPEN_DATE) == eval(current_date)) {
				if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2)) < eval(cur_hh)) {
					alert ("개찰일시의 시작시간은 현재시간보다 이후여야 합니다.");
					document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2))   == eval(cur_hh)) {
					if (eval(OPEN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
						alert ("개찰일시시간 설정이 잘못되었습니다.");
						document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// 공고일시 ~ 입찰서제출일시
			if (eval(ANN_DATE) > eval(BID_BEGIN_DATE)) {
				alert ("입찰서제출일시 시작일자는 공고등록일시보다  커야합니다.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			}

			// 입찰서제출일시 ~ 개찰일시
			if (eval(OPEN_DATE) < eval(BID_END_DATE)) {
				alert ("개찰일시는 입찰서제출일시 종료일자보다 커야합니다.");
				document.forms[0].OPEN_DATE.focus();
				return false;
			} else if (eval(OPEN_DATE) == eval(BID_END_DATE)) {
				if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2)) < eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
					alert ("개찰일시는 입찰서제출일시 종료시간보다 이후여야 합니다.");
					document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
					return false;
				} else if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2))   == eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)))   {
					if (eval(OPEN_TIME_HOUR_MINUTE.substring(2,4)) < eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
						alert ("개찰일시는 입찰서제출일시 종료시간보다 이후여야 합니다.");
						document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
						return false;
					}
				}
			}

			// 제안설명회일자
			if (eval(BID_BEGIN_DATE) < eval(ANNOUNCE_DATE)) {
				alert ("제안설명회 개최일은 입찰서제출일보다 이전 날짜이어야 합니다.");
				return false;
			}
		}

		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var rowcount = grid_array.length;
		 
		var TOT_AMT = 0;

		for(var i = 0; i < grid_array.length; i++)
		{
				
				var DESCRIPTION_LOC = GridObj.cells(grid_array[i], GridObj.getColIndexById("DESCRIPTION_LOC")).getValue();
				var UNIT_MEASURE    = GridObj.cells(grid_array[i], GridObj.getColIndexById("UNIT_MEASURE")).getValue();
				var QTY             = GridObj.cells(grid_array[i], GridObj.getColIndexById("QTY")).getValue();
				var CUR             = GridObj.cells(grid_array[i], GridObj.getColIndexById("CUR")).getValue();
				var UNIT_PRICE      = GridObj.cells(grid_array[i], GridObj.getColIndexById("UNIT_PRICE")).getValue();
				var AMT             = GridObj.cells(grid_array[i], GridObj.getColIndexById("AMT")).getValue();
				
				// 구매요청을 기준으로 입찰을 진행할 경우
				<%if ("P".equals(req_type)) {%>
					if (DESCRIPTION_LOC == "") {
						alert("품목명이 입력되지 않았습니다.");
						return false;
					}
	
					if (UNIT_MEASURE == "") {
						alert("단위가 입력되지 않았습니다.");
						return false;
					}
	
					if( "KRW" != CUR) {
						alert("통화는 KRW만 가능 합니다.");
						return false;
					}
	
					if (QTY == "" || QTY == "0") {
						alert("수량이 입력되지 않았습니다.");
						return false;
					}
	
					if (UNIT_PRICE == "" || UNIT_PRICE == "0") {
						alert("예상단가가 입력되지 않았습니다.");
						return false;
					}
				<%}%>
				TOT_AMT += parseFloat(AMT);
			 
		}
		 
		return true;
	}
	/**
	 * 저장 = 'T', 결재요청='P', 확정= 'C'
	 */
	function goSave(pflag)
	{
		var cert_result;
		//var pflag = document.forms[0].sign_status.value;

		if(!checkRows()) return;

        var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
		var rowcount = grid_array.length;
		
		if(pflag == "T") {
			if(confirm(rowcount+" 건의 품목을 선택하셨습니다.\n\n저장 하시겠습니까?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "P") {
			if(confirm(rowcount+" 건의 품목을 선택하셨습니다.\n\n결재완료 후 공고확정을 해야 입찰이 진행됩니다.\n\n결재상신 하시겠습니까?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "E") {
			if(confirm(rowcount+" 건의 품목을 선택하셨습니다.\n\n작성완료 후 공고확정을 해야 입찰이 진행됩니다.\n\n작성완료 하시겠습니까?") != 1) {
				button_flag = false;
				return;
			}
		} else if(pflag == "C") {
			if(confirm("입찰공고를 진행하시겠습니까?") != 1) {
				button_flag = false;
				return;
			}
		}

		if("<%=SCR_FLAG%>" == "I") { // 입찰공고 생성
			if ("<%=BID_STATUS%>" == "UR") {
				mode = "setUGonggoCreate"; // 정정공고 작성
			} else {
				mode = "setAnnCreate"; // 입찰공고 작성
			}
		} else if("<%=SCR_FLAG%>" == "U") { // 입찰공고 수정
			mode = "setGonggoModify";
		} else if("<%=SCR_FLAG%>" == "C") { // 입찰공고 확정
			mode = "setGonggoConfirm";
		}

		var ANN_DATE                	= del_Slash(document.forms[0].ANN_DATE.value);  
		
		var APP_BEGIN_DATE          	= del_Slash(document.forms[0].APP_BEGIN_DATE.value);
		var APP_BEGIN_TIME_HOUR_MINUTE  = document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.value;
		var APP_BEGIN_TIME          	= APP_BEGIN_TIME_HOUR_MINUTE +  "00";

		var APP_END_DATE            	= del_Slash(document.forms[0].APP_END_DATE.value);
		var APP_END_TIME_HOUR_MINUTE    = document.forms[0].APP_END_TIME_HOUR_MINUTE.value;
		var APP_END_TIME            	= APP_END_TIME_HOUR_MINUTE +    "00";

		var BID_BEGIN_DATE          	= del_Slash(document.forms[0].BID_BEGIN_DATE.value);
		var BID_BEGIN_TIME_HOUR_MINUTE  = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value;
		var BID_BEGIN_TIME          	= BID_BEGIN_TIME_HOUR_MINUTE +  "00";

		var BID_END_DATE            	= del_Slash(document.forms[0].BID_END_DATE.value);
		var BID_END_TIME_HOUR_MINUTE    = document.forms[0].BID_END_TIME_HOUR_MINUTE.value;
		var BID_END_TIME            	= BID_END_TIME_HOUR_MINUTE +    "00";

		var OPEN_DATE               	= del_Slash(document.forms[0].OPEN_DATE.value);
		var OPEN_TIME_HOUR_MINUTE       = document.forms[0].OPEN_TIME_HOUR_MINUTE.value;
		var OPEN_TIME               	= OPEN_TIME_HOUR_MINUTE + "00";

		var RD_DATE					= del_Slash(document.forms[0].RD_DATE.value); 
		var CONT_TYPE2				= document.forms[0].CONT_TYPE2.value; 
		// 최저가가 아닌것은, '입찰서제출일'과 '개찰일자'를 생성할 수없다.
		if(CONT_TYPE2 != "LP") {
			BID_BEGIN_DATE       = "";
			BID_BEGIN_TIME       = "";
			BID_END_DATE         = "";
			BID_END_TIME         = "";
			OPEN_DATE            = "";
			OPEN_TIME            = "";
		}

		var STANDARD_POINT         	= document.forms[0].STANDARD_POINT.value;
		var TECH_DQ              	= document.forms[0].TECH_DQ.value;
		var AMT_DQ           		= document.forms[0].AMT_DQ.value;
		var BID_EVAL_SCORE			= document.forms[0].BID_EVAL_SCORE.value;
		var REPORT_ETC				= document.forms[0].REPORT_ETC.value;

		// 기준점수, 점수비율을 생성할 수없다.
		if(CONT_TYPE2 != "LP" && CONT_TYPE2 != "TE" && CONT_TYPE2 != "NE") {
			STANDARD_POINT      = "";
			TECH_DQ       		= "";
			AMT_DQ         		= "";
			BID_EVAL_SCORE		= "";
		}

		//Header 
		document.forms[0].ANN_DATE.value  		      = ANN_DATE         ;       	
		                                                                                 
		document.forms[0].APP_BEGIN_DATE.value                = APP_BEGIN_DATE   ;       	
		document.forms[0].APP_BEGIN_TIME_HOUR_MINUTE.value    = APP_BEGIN_TIME   ;        	
                                                                                                
		document.forms[0].APP_END_DATE.value                  = APP_END_DATE     ;       	
		document.forms[0].APP_END_TIME_HOUR_MINUTE.value      = APP_END_TIME     ;        	
                                                                                                 
		document.forms[0].BID_BEGIN_DATE.value                = BID_BEGIN_DATE   ;       	
		document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value    = BID_BEGIN_TIME   ;       	
                                                                                              
		document.forms[0].BID_END_DATE.value                  = BID_END_DATE     ;       	
		document.forms[0].BID_END_TIME_HOUR_MINUTE.value      = BID_END_TIME     ;       	
                                                                                            
		document.forms[0].OPEN_DATE.value                     = OPEN_DATE        ;       	
		document.forms[0].OPEN_TIME_HOUR_MINUTE.value         = OPEN_TIME        ;        	
                                                                                             
		document.forms[0].RD_DATE.value       = RD_DATE			         ;
		  
		if(CONT_TYPE2 == "LP") { // 최저가인 경우
	    		document.forms[0].APP_BEGIN_DATE.value       = BID_BEGIN_DATE   ;    
	    		document.forms[0].APP_BEGIN_TIME.value       = BID_BEGIN_TIME   ;    
	    		document.forms[0].APP_END_DATE.value         = BID_END_DATE     ;  
	    		document.forms[0].APP_END_TIME.value         = BID_END_TIME     ;   
		} else {
	    		document.forms[0].APP_BEGIN_DATE.value       = APP_BEGIN_DATE   ;    
	    		document.forms[0].APP_BEGIN_TIME.value       = APP_BEGIN_TIME   ;    
	    		document.forms[0].APP_END_DATE.value         = APP_END_DATE     ;  
	    		document.forms[0].APP_END_TIME.value         = APP_END_TIME     ;   
		} 
		
		document.forms[0].pflag.value         = pflag ;                  // 저장, 결재요청
    	//document.forms[0].approval_str.value  = approval_str  ;  
		
		document.forms[0].ANN_DATE.value          = del_Slash( document.forms[0].ANN_DATE.value          );
		document.forms[0].X_DOC_SUBMIT_DATE.value = del_Slash( document.forms[0].X_DOC_SUBMIT_DATE.value );
		document.forms[0].APP_BEGIN_DATE.value    = del_Slash( document.forms[0].APP_BEGIN_DATE.value    );
		document.forms[0].APP_END_DATE.value      = del_Slash( document.forms[0].APP_END_DATE.value      );
		document.forms[0].BID_BEGIN_DATE.value    = del_Slash( document.forms[0].BID_BEGIN_DATE.value    );
		document.forms[0].BID_END_DATE.value      = del_Slash( document.forms[0].BID_END_DATE.value      );
		document.forms[0].OPEN_DATE.value         = del_Slash( document.forms[0].OPEN_DATE.value         );
		document.forms[0].RD_DATE.value           = del_Slash( document.forms[0].RD_DATE.value           );


        var cols_ids = "<%=grid_col_id%>";
        var params = "mode="+mode;
     
	    params += "&cols_ids=" + cols_ids;
	    params += dataOutput();
	    myDataProcessor = new dataProcessor( G_SERVLETURL, params );
	    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
     
	}
	// 첨부파일
	function setAttach(attach_key, arrAttrach, attach_count) {
		if(document.forms[0].isGridAttach.value == "true"){
			setAttach_Grid(attach_key, arrAttrach, attach_count);
			return;
		}
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
		document.forms[0].attach_no.value     	= attach_key;
		document.forms[0].attach_cnt.value     	= attach_count;
        document.getElementById("attach_no_text").innerHTML = "";
        document.forms[0].only_attach.value = "attach_no";
        //setAttach1();
    }
    
    function setAttach1() {
        var nickName        = "SIF_001";
        var conType         = "TRANSACTION";
        var methodName      = "getFileNames";
        var SepoaOut        = doServiceAjax( nickName, conType, methodName );
        
        if( SepoaOut.status == "1" ) { // 성공
            //alert("성공적으로 처리 하였습니다.");
            var test = (SepoaOut.result[0]).split("<%=conf.getString( "sepoa.separator.line" )%>");
            var test1 = test[1].split("<%=conf.getString( "sepoa.separator.field" )%>");
            
            setAttach2(test1[0]);
            
        } else { // 실패
<%--             alert("<%=text.get("MESSAGE.1002")%>"); --%>
        }
    }

    function setAttach2(result){
        var text  = result.split("||");
        var text1 = "";
    
        for( var i = 0; i < text.length ; i++ ){
            
            text1  += text[i] + "<br/>";
        }
        
        document.getElementById("attach_no_text").innerHTML = text1;
    }
	
	
	//그리드 파일첨부
	function setAttach_Grid(attach_key, arrAttrach, attach_count) {
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
		GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO")).setValue(attach_key);
		GridObj.cells(document.form.attachrow.value, GridObj.getColIndexById("ATTACH_NO_CNT")).setValue(attach_count);
		document.forms[0].isGridAttach.value = "false";
	}
	/**
	 * 행삭제
	 */
	function  LineDelete()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		if(grid_array.length == 0){
			alert("삭제할 대상이 없습니다.");
			return;
		}
		
		var rowcount = grid_array.length;
		GridObj.enableSmartRendering(false);
		
		if(rowcount > 0) {
			if(confirm("삭제 하시겠습니까?") == 1) { 
		    	for(var row = rowcount - 1; row >= 0; row--) {
					if("1" == GridObj.cells(grid_array[row], 0).getValue()) {
						GridObj.deleteRow(grid_array[row]);
		        	}
			    }
			}
		}
	}
	function getLocList(){
		var param = "";
		
		param += "?callback=setLoc";
		param += "&sLoc=<%=LOC_CODE%>";
		
		popUpOpen("bd_loc_list.jsp" + param, 'RFQ_REQ_SELLERSELFRAME', '430', '410');
	}
	
	function setLoc(rtnStr){
		
		var rtnArr = rtnStr.split("#");
		
		var loc_cnt 	= rtnArr[0];
		var loc_code 	= rtnArr[1];
		var loc_name	= rtnArr[2];
		
		$("#LOC_CNT").val(loc_cnt);
		$("#LOC_CODE").val(loc_code);
	}
	<%--
	$(window).load(function () {
	  	// run code
	  	init();
	  	initAjax();
	  	avengerkim();
	});--%>
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init();initAjax();avengerkim();">
<s:header popup="true">
	<!--내용시작-->
	<form name="form">
		<input type="hidden" name="PR_NO" id="PR_NO" value="<%=PR_NO%>"/>
		<input type="hidden" name="BID_TYPE" id="BID_TYPE" value="<%=BID_TYPE%>"/>
		<input type="hidden" name="APP_BEGIN_TIME" id="APP_BEGIN_TIME" />
		<input type="hidden" name="APP_END_TIME" id="APP_END_TIME" /> 
		<input type="hidden" name="BID_STATUS" id="BID_STATUS" value="<%=BID_STATUS%>"/>
		<input type="hidden" name="CTRL_AMT" id="CTRL_AMT" value="<%=CTRL_AMT%>"/>
		<input type="hidden" name="pflag" id="pflag" />
		<input type="hidden" name="approval_str" id="approval_str" />

		<input type="hidden" name="PR_DATA" id="PR_DATA" value="<%=PR_DATA%>"/>
		<!-- 업체수 hidden으로 바꿈 -->                                                    
		<input type="hidden" name="vendor_count" id="vendor_count" value="0">                         
		                                                            
		<input type="hidden" name="sign_status" id="sign_status" value="N">                          
		<!-- 저장,결재를 구분하는 플래그 -->                                        
		<input type="hidden" name="bid_amt" id="bid_amt" value="">                               
		<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>">       
		<input type="hidden" name="location_values" id="location_values" value="<%=LOCATION_VALUES%>">   
		
		<!-- 제안경쟁에 의한 추가 -->
		<input type="hidden" name="LOC_CODE" id="LOC_CODE" value="<%=LOC_CODE%>">   
                                                            
		<!-- hidden(제안설명회) //-->                                               
		<input type="hidden" name="bid_no" 	  id="bid_no" 	         value="<%=BID_NO%>">                     
		<input type="hidden" name="bid_count" 	  id="bid_count" 	 value="<%=BID_COUNT%>">              
		<input type="hidden" name="start_time" 	  id="start_time" 	 value="<%=ANNOUNCE_TIME_FROM%>">    
		<input type="hidden" name="end_time" 	  id="end_time" 	 value="<%=ANNOUNCE_TIME_TO%>">         
		<input type="hidden" name="ANNOUNCE_FLAG" id="ANNOUNCE_FLAG"     value="<%=ANNOUNCE_FLAG%>">       
		<input type="hidden" name="ANNOUNCE_TEL"  id="ANNOUNCE_TEL"      value="<%=ANNOUNCE_TEL%>">         
		<input type="hidden" name="area" 	  id="area" 	         value="<%=ANNOUNCE_AREA%>">                
		<input type="hidden" name="place" 	  id="place" 	         value="<%=ANNOUNCE_PLACE%>">              
		<input type="hidden" name="notifier" 	  id="notifier" 	 value="<%=ANNOUNCE_NOTIFIER%>">
		<input type="hidden" name="doc_frw_date"  id="doc_frw_date"      value="<%=DOC_FRW_DATE%>">         
		<input type="hidden" name="resp" 	  id="resp" 	         value="<%=ANNOUNCE_RESP%>">                
		<input type="hidden" name="comment" 	  id="comment" 	         value="<%=ANNOUNCE_COMMENT%>">          
		<input type="hidden" name="data1" 	  id="data1" 	         value="">                         
		<input type="hidden" name="attach_gubun"  id="attach_gubun"      value="body">        
		<input type="hidden" name="att_mode" 	  id="att_mode" 	 value="">                      
		<input type="hidden" name="view_type" 	  id="view_type" 	 value="">                     
		<input type="hidden" name="file_type" 	  id="file_type" 	 value="">                     
		<input type="hidden" name="tmp_att_no" 	  id="tmp_att_no" 	 value="">                    
		<input type="hidden" name="BID_EVAL_SCORE" id="BID_EVAL_SCORE"  value="<%=BID_EVAL_SCORE%>"/>   
 
		<input type="hidden" name="seller_change_flag" id="seller_change_flag" value= "Y"><!-- 업체선택여부 -->
		<input type="hidden" name="vendor_each_flag">
		<input type="hidden" name="rownum">
		<input type="hidden" name="seller_cnt" value="<%=VENDOR_CNT%>">
		<input type="hidden" name="seller_choice">
 
		<input type="hidden" name="p_approval_flag" id="p_approval_flag"> 

		<input type="hidden" name="app_line_id"  id="app_line_id"  />
		<input type="hidden" name="app_line_seq" id="app_line_seq" />
		<input type="hidden" name="app_auto_flag" id="app_auto_flag" />
		<input type="hidden" name="app_line"     id="app_line"     />
		<input type="hidden" name="Approval_str" id="Approval_str" />
		<input type="hidden" name="att_show_flag">
		<input type="hidden" name="attach_seq">	
		<input type="hidden" name="isGridAttach">
		<input type="hidden" name="only_attach" id="only_attach" value="">
		    
		<%@ include file="/include/sepoa_milestone.jsp"%>

		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5"> </td>
			</tr>
			<tr>
				<td width="100%" valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tr>
							<td width="20%" class="title_td">공고번호</td>
							<td class="data_td_input" width="35%">
								<input type="text"	name="ANN_NO" id="ANN_NO" value="<%=ANN_NO%>" class="input_data2" readonly>
							</td>
							<td width="15%" class="title_td">공고일자</td>
							<td width="35%" class="data_td_input">
								<s:calendar id="ANN_DATE" default_value="<%=SepoaString.getDateSlashFormat(to_date)%>"  format="%Y/%m/%d"/>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰건명</td>
							<td class="data_td_input"  colspan="3">
								<input type="text" name="ANN_ITEM" id="ANN_ITEM" size="40" style="ime-mode: active" value="<%=SUBJECT.equals("")?ANN_ITEM.replaceAll("\"", "&quot;"):SUBJECT%>" class="input_re" <%=script%> onKeyUp="return chkMaxByte(300, this, '입찰건명');">
							</td>
						</tr>
						<tr>				
							<td width="15%" class="title_td">입찰방법</td>
							<td class="data_td_input" width="35%">
								<b>
									<select name="CONT_TYPE1" id="CONT_TYPE1" class="inputsubmit" onChange="setVisibleVendor()" <%=abled%>></select>
									&nbsp; 
									<select name="CONT_TYPE2" id="CONT_TYPE2" class="inputsubmit" onChange="setVisiblePeriod()" <%=abled%>> </select>
								</b>
							</td>
							<td width="15%" class="title_td">낙찰자 선정기준</td>
							<td width="35%" class="data_td_input">
								<select name="PROM_CRIT" id="PROM_CRIT" class="inputsubmit" onChange="avengerkim()" <%=abled%>></select> 
<script>
function avengerkim() {
	f = document.forms[0];
	if(f.PROM_CRIT.value=='A' || f.PROM_CRIT.value=='D'){
		$("#contDiv2").hide();
	}else if (f.PROM_CRIT.value=='B') { //낙찰하한가이면
		$("#contDiv2").show();
		f.FROM_LOWER_BND.value='80';
		f.FROM_LOWER_BND.readOnly = '';
	}else if (f.PROM_CRIT.value=='C'){
		$("#contDiv2").hide();
		f.FROM_LOWER_BND.value='0';
		f.FROM_LOWER_BND.readOnly = '';
	}
}
</script>
								<input type="hidden" name="FROM_CONT_TEXT" id="FROM_CONT_TEXT" value="<%=FROM_CONT_TEXT%>">
								<input type="hidden" name="FROM_CONT" id="FROM_CONT" value="<%=FROM_CONT%>">
								<!--input type="hidden" name="FROM_LOWER_BND" value="<//%=FROM_LOWER_BND%>"-->
							</td>
						</tr>
						<tr id="q1" style="display: none;">
							<td class="title_td" width="15%"></td>
							<td class="data_td_input" colspan="3">
								<div id="contDiv1" style="display: none;">
									점수비율 [ 기술제안서
									<span>
										<input type="text" name="TECH_DQ" id="TECH_DQ" size="4" maxlength="3" class="input_re" onblur="check_AMT_DQ()" value="<%=TECH_DQ%>" <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">% : 가격 
										<input type="text" name="AMT_DQ" id="AMT_DQ" value="<%=AMT_DQ%>" size="4" maxlength="4" onblur="check_AMT_DQ()" class="input_re" <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">%]&nbsp;&nbsp;&nbsp;&nbsp;
										기준점수
										<input type="text" name="STANDARD_POINT" id="STANDARD_POINT" size="4" maxlength="3" class="input_re" onblur="check_STANDARD_POINT()" value="<%=STANDARD_POINT%>" <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
									</span>
								</div>
								<div id="contDiv2" style="display: none;">
									&nbsp;&nbsp;낙찰하한율
									<b>
										<input type="text" name="FROM_LOWER_BND" id="FROM_LOWER_BND" size="3" maxlength="2" value="<%=FROM_LOWER_BND%>" <%=script%> style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]');">%
									</b>
								</div>								
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">세부입찰방법</td>
							<td width="35%" class="data_td_input" colspan="3">
								<input type="text" name="CONT_TYPE_TEXT" id="CONT_TYPE_TEXT" value="<%=CONT_TYPE_TEXT%>" class="inputsubmit" size="95" <%=script%> onKeyUp="return chkMaxByte(50, this, '입찰방법상세');">

								<span id="h1">
									<span id="h11">
										지역지정
										<a href="javascript:getLocList()" id=h12>
											<img src="/images/button/query.gif" align="absmiddle" border="0" id=h13>
										</a>

									<input type="text" name="LOC_CNT" id="LOC_CNT" size="3" value="<%=LOC_CNT%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly id=h14>
								</span>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰장소</td>
							<td class="data_td_input" width="35%" colspan="3">
								<input type="text" name="CONT_PLACE" id="CONT_PLACE" size="95" style="ime-mode: active" class="inputsubmit" value="<%=CONT_PLACE%>" <%=script%> onKeyUp="return chkMaxByte(200, this, '입찰장소');">
							</td>
						</tr>
						<tr id="i1">
							<td class="title_td" width="15%">입찰참가 신청일시</td>
							<td class="data_td_input" width="35%" colspan="3">
								<s:calendar id="APP_BEGIN_DATE" default_value="<%=APP_BEGIN_DATE %>"  format="%Y/%m/%d"/>
								일 
								<input type="text" name="APP_BEGIN_TIME_HOUR_MINUTE" id="APP_BEGIN_TIME_HOUR_MINUTE" size="4" value="<%=APP_BEGIN_TIME_HOUR_MINUTE%>" maxlength="4" class="input_re" <%=script_c%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
								&nbsp;&nbsp;~&nbsp;&nbsp; 
								<s:calendar id="APP_END_DATE" default_value="<%=APP_END_DATE %>"  format="%Y/%m/%d"/>
								일
								<input type="text" name="APP_END_TIME_HOUR_MINUTE" id="APP_END_TIME_HOUR_MINUTE" value="<%=APP_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4" class="input_re" <%=script_c%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');"> 
								ex) 오후3시 21분 --> 1521
							</td>
						</tr>
						<tr  id="g1">
							<td class="title_td" width="15%">입찰서 제출일시</td>
							<td class="data_td_input" width="35%" colspan="3"  >
								<s:calendar id="BID_BEGIN_DATE" default_value="<%=BID_BEGIN_DATE %>"  format="%Y/%m/%d"/>
								일 
								<input type="text" name="BID_BEGIN_TIME_HOUR_MINUTE" id="BID_BEGIN_TIME_HOUR_MINUTE" value="<%=BID_BEGIN_TIME_HOUR_MINUTE%>" size="4" maxlength="4" class="input_re" <%=script_c%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
								&nbsp;&nbsp;~&nbsp;&nbsp; 
								<s:calendar id="BID_END_DATE" default_value="<%=BID_END_DATE %>"  format="%Y/%m/%d"/>
								일 
								<input type="text" name="BID_END_TIME_HOUR_MINUTE" id="BID_END_TIME_HOUR_MINUTE" value="<%=BID_END_TIME_HOUR_MINUTE%>" size="4" maxlength="4" class="input_re" <%=script_c%> onBlur="bin_end_time_event()" style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
								ex) 오후3시 21분 --> 1521
							</td>
						</tr>
						<tr  id="g2">
							<td class="title_td" width="15%">개찰일시</td>
							<td class="data_td_input" width="35%" colspan="3">
								<s:calendar id="OPEN_DATE" default_value="<%=OPEN_DATE %>"  format="%Y/%m/%d"/>
								일
								<input type="text" name="OPEN_TIME_HOUR_MINUTE" id="OPEN_TIME_HOUR_MINUTE" value="<%=OPEN_TIME_HOUR_MINUTE%>" size="4" maxlength="4" class="input_re" <%=script_c%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
								ex) 오후3시 21분 --> 1521
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰참가 자격</td>
							<td width="35%" class="data_td_input" colspan="3"> 
								<textarea name="LIMIT_CRIT" id="LIMIT_CRIT" cols="95" rows="3"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '입찰참가자격');"><%=LIMIT_CRIT%></textarea>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰보증금 납부 및 귀속</td>
							<td class="data_td_input" width="35%" colspan="3">
								<input
									type="text"
									name="BID_PAY_TEXT"
									id="BID_PAY_TEXT"
									size="95"
									class="inputsubmit"
									value="<%=BID_PAY_TEXT%>"
									<%=script%>
									onKeyUp="return chkMaxByte(200, this, '입찰보증금 납부 및 귀속');"
								>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰무효</td>
							<td class="data_td_input" width="35%" colspan="3">
								<input
									type="text"
									name="BID_CANCEL_TEXT" 
									id="BID_CANCEL_TEXT" 
									size="95" 
									class="inputsubmit"
									value="<%=BID_CANCEL_TEXT%>" 
									<%=script%> 
									onKeyUp="return chkMaxByte(200, this, '입찰무효');"
								>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">입찰참가 등록</td>
							<td class="data_td_input" width="35%" colspan="3">
								<input
									type="text"
									name="BID_JOIN_TEXT"
									id="BID_JOIN_TEXT" 
									size="95" 
									class="inputsubmit"
									value="<%=BID_JOIN_TEXT%>" 
									<%=script%> 
									onKeyUp="return chkMaxByte(200, this, '입찰참가 등록서류');"
								>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">문의사항</td>
							<td class="data_td_input" width="35%" colspan="3">
								<input 
									type="text" 
									name="REMARK" 
									id="REMARK" 
									size="95" 
									class="inputsubmit" value="<%=REMARK%>"
									<%=script%> 
									onKeyUp="return chkMaxByte(200, this, '문의사항');"
								>
							</td>
						</tr>
						<tr style="display: none;">
							<td width="15%" class="title_td">예정가격</td>
							<td class="data_td_input" width="35%">
								<b> 
									<select name="ESTM_KIND" id="ESTM_KIND" class="inputsubmit" onChange="setVisibleESTM()"<%=abled%>>
										<option value="U" selected>단일예가</option>
										<option value="M">복수예가</option>
									</select> 
								</b>
							</td>
							<td width="50%" class="title_td" colspan="2">예비가격범위 
								<input 
									type="text" 
									name="ESTM_RATE" 
									id="ESTM_RATE" 
									size="3" 
									maxlength="2" 
									value="<%=ESTM_RATE%>"
									<%=script%>
								>
								%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<span id="e1">
									사용예비가격/추첨수 
									<input type="hidden" name="ESTM_MAX_VOTE" id="ESTM_MAX_VOTE"> 
									<input type="text" name="ESTM_MAX" id="ESTM_MAX" size="3" maxlength="2" value="<%=ESTM_MAX%>" onblur="check_ESTM_MAX()" <%=script%> > 
									<input type="text" name="ESTM_VOTE" id="ESTM_VOTE" size="2" maxlength="1" readOnly value="<%=ESTM_VOTE%>" onblur="check_ESTM_VOTE()" <%=script%>>
								</span>
							</td>
						</tr>
						<tr>
							<td class="title_td" width="15%">납기일자</td>
							<td class="data_td_input" width="35%">
								<s:calendar id="RD_DATE" default_value="<%=RD_DATE %>"  format="%Y/%m/%d"/>일 
							</td>
							<td class="title_td" width="15%">납품장소</td>
							<td class="data_td_input" width="35%">
								<input 
									type="text" 
									style="ime-mode: active" 
									name="DELY_PLACE" 
									id="DELY_PLACE" 
									size="40" 
									class="inputsubmit" 
									value="<%=DELY_PLACE%>" 
									<%=script%>
									onKeyUp="return chkMaxByte(300, this, '납기장소');"
								>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">기타사항</td>
							<td width="35%" class="data_td_input" colspan="3">
								<textarea name="BID_ETC" id="BID_ETC" style="ime-mode: active" rows="3" cols="95"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '기타사항');"><%=BID_ETC%></textarea>
							</td>
						</tr>
						<tr>
							<td width="15%" class="title_td">보고사항</td>
							<td width="35%" class="data_td_input" colspan="3">
								<textarea name="REPORT_ETC" id="REPORT_ETC" style="ime-mode: active" rows="3" cols="95"  <%=script%> onKeyUp="return chkMaxByte(1000, this, '기타사항');"><%=REPORT_ETC%></textarea>
							</td>
						</tr>
<%
	if (SCR_FLAG.equals("C")) { // 공고확정시 트위터 공고
%>
						<tr style="display: none;">
							<td width="15%" class="title_td">
								<img src="/images/<//%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 
								트위터 공고(140 BYTE) 
								<br>
								<br> 
								현재 : 
								<input type="text" name="TWIT_LEN" style="text-align: right" readOnly size="4" /> 
								BYTE
							</td>
							<td class="data_td_input" colspan="3" height="200">
								<textarea name="TWIT" style="ime-mode: active" rows="5" cols="95" rows="2" class="inputsubmit" onKeyUp="cal_length(this)"></textarea>
							</td>
						</tr>
<%
	}
%>
						<tr>
							<td width="15%" class="title_td"> 첨부파일</td>
							<td class="data_td_input" id="attach_td_id" colspan="3"> &nbsp;
								<TABLE>
									<TR>
										<td>
											<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
										</td>
										<td>
<script language="javascript">
	btn("javascript:attach_file(document.forms[0].attach_no.value,'BD');document.forms[0].attach_seq.value=1","파일첨부")
</script>
										</td>
										<td>
											<input type="text" name="attach_cnt" id="attach_cnt" size="3" class="div_empty_num_no" readonly value="<%=ATTACH_CNT%>">
											<input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
										</td>
										<td width="170">
											<div id="attach_no_text"></div>
										</td>
									</TR>
								</TABLE>
							</td>
						</tr>
					</table>
					<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
						<TR>
							<TD height="30" align="right">
								<TABLE cellpadding="0">
									<TR>
										<td>
<script language="javascript">
	btn("javascript:vendor_Select()", "업체지정");
</script>
<!-- 
										<td>
<script language="javascript">
	btn("javascript:doExplanation()", "제안설명회");
</script> 
-->
											<input type="hidden" name="szdate" size="8" value="<%=ANNOUNCE_DATE%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly>
										</td>
<%
	if (SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
%>
										<td>
<script language="javascript">
	btn("javascript:Approval('T')", "임시저장");
</script>
										</td>
<%
		if (sign_use_yn) {
%>
<%-- 
										<TD>
<script language="javascript">
	btn("javascript:Approval('P')", "결재요청");
</script>
										</TD>
--%>
										<TD>
<script language="javascript">
	btn("javascript:Approval('E')", "작성완료");
</script>
										</TD>
<%
		}
		else {
%>
										<TD>
<script language="javascript">
	btn("javascript:Approval('E')", "작성완료");
</script>
										</TD>
<%
		}

	}

	if (SCR_FLAG.equals("C")) {
%>
										<td>
<script language="javascript">
	btn("javascript:Approval('C')", "입찰공고");
</script>
										</td>
<%
	}
	
	if (SCR_FLAG.equals("D")) {
%>
										<td>
<script language="javascript">
	btn("javascript:history.back(-1)", "취 소");
</script>
										</td>
<%
	}
	
	if (SCR_FLAG.equals("I") || SCR_FLAG.equals("U")) {
%>
										<td>
<script language="javascript">
	btn("javascript:LineDelete()", "행삭제");
</script>
										</td>
<%
	}
%>
										<td>
<script language="javascript">
	btn("javascript:window.close()", "닫 기");
</script>
										</td>
									</TR>
								</TABLE>
							</TD>
						</TR>
					</TABLE>
					<div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv">
						<iframe src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
					</div>
				</td>
			</tr>
		</table>
	</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="BD_001" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html> 