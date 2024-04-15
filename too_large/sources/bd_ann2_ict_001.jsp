<%@page import="org.apache.commons.collections.MapUtils"%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}
%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_020");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_020";
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
	
    String  to_day			= SepoaDate.getShortDateString();
    String  from_date		= SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
    String  to_date			= SepoaString.getDateSlashFormat( to_day );
 
	String PR_DATA			= JSPUtil.nullToRef(request.getParameter("PR_DATA"),""); 
	String popup			= JSPUtil.nullToRef(request.getParameter("popup_flag"),"true"); 
 
	String ANN_VERSION		= JSPUtil.nullToRef(request.getParameter("ANN_VERSION"), "");	//입찰서 버젼
	String VIEW_TYPE		= JSPUtil.nullToRef(request.getParameter("VIEW_TYPE"), "");	
	String SUBJECT			= JSPUtil.nullToRef(request.getParameter("T_SUBJECT"), "");	
	String pr_type			= JSPUtil.nullToEmpty(request.getParameter("PR_TYPE"));
	String req_type			= JSPUtil.nullToEmpty(request.getParameter("REQ_TYPE"));  
	String ANN_STATUS		= JSPUtil.nullToEmpty(request.getParameter("ANN_STATUS")); 
	String ANN_NO			= JSPUtil.nullToEmpty(request.getParameter("ANN_NO")); // 생성/수정/확정/상세조회
	String ANN_COUNT		= JSPUtil.nullToEmpty(request.getParameter("ANN_COUNT")); // 생성/수정/확정/상세조회 
	String view_content		= JSPUtil.nullToEmpty(request.getParameter("view_content")); //View용 화면인지 확인 flag

	String BID_TYPE			= JSPUtil.nullToRef(request.getParameter("BID_TYPE"), "D");
	String CTRL_AMT			= JSPUtil.nullToRef(request.getParameter("CTRL_AMT"), "0"); // 통제금액
	String SCR_FLAG			= JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "I"); // 생성/수정/확정/상세조회 flag
				 
	String HOUSE_CODE		= info.getSession("HOUSE_CODE");
	String COMPANY_CODE		= info.getSession("COMPANY_CODE");
	String USER_ID			= info.getSession("ID");

	String current_date		= SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time		= SepoaDate.getShortTimeString();//현재 시스템 시간
	

	
	// SCR_FLAG : I(작성), U(수정)
	boolean isAdmin = this.isAdmin(info);

	String script = "";
	String abled = "";
	String script_c = "";
	String abled_c = "";
	String isEdit = "false";

	if (SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script = "readonly";
		abled = "disabled";
		isEdit = "true";
	}

	if (SCR_FLAG.equals("C")) { // 확정(공고)일때 변경 가능한 항목 설정
	
		script_c = "";
		abled_c = "";
	}
	
	String subSubject = "";
	
	String ES_FLAG = "";

	String CONT_TYPE1 = "";
	String CONT_TYPE2 = "";
	String TCO_PERIOD = "";
	String RA_TIME01  = "";
	String RA_TIME02  = "";

	String ANN_TITLE = "";
	String ANN_DATE = "";
	String ANN_ITEM = subSubject + SUBJECT;
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
	String VENDOR_INFO = "";
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
	String BID_PLACE = "IT전자구매시스템";
	String BID_ETC = "입찰시간 10분전까지 접속 바라며, 첨부서류 미 제출시\r\n응찰의사가 없는 것으로 간주함.";	// 기본값
	String OPEN_DATE = "";
	String OPEN_TIME = "";
	String REPORT_ETC = "";
	String X_AUTO_FLAG = "";
	String BID_INPUT_TYPE = "";

	String APP_BEGIN_TIME_HOUR_MINUTE = "0000";
	String APP_END_TIME_HOUR_MINUTE = "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE = "0000";
	String BID_END_TIME_HOUR_MINUTE = "0000";
	String OPEN_TIME_HOUR_MINUTE = "0000";

	// 최초작성 : IAT, 최초작성_수정:UAT, 정정공고_작성(IUT) 
	String origin_bid_status = SCR_FLAG + ANN_STATUS;

	
	String ESTM_KIND = "";
	String ESTM_RATE = "";
	String ESTM_MAX = "";
	String ESTM_VOTE = "";
	String FROM_CONT = "";
	String FROM_CONT_TEXT = "";
	String FROM_LOWER_BND = "";
	String ASUMTN_OPEN_YN = "";

	String CONT_TYPE_TEXT = "";
	String CONT_PLACE = "IT전자구매시스템 입찰실시 공고 내 입찰관련서류접수";
	String BID_PAY_TEXT = "";
	String BID_CANCEL_TEXT = "";
	String BID_JOIN_TEXT = "- 견적서는 가능하면 엑셀 파일, 나머지 서류는 하나의 PDF 파일로 업로드 부탁드립니다.\r\n- 입찰보증보험증권 기간\r\n   * 시작일 : 입찰서 제출 마감일과 같거나 마감일 이전 일 것\r\n   * 종료일 : 입찰서 제출 마감일 다음날로부터 30일 이후 일 것\r\n- 개인정보 보호를 위해 첨부 서류의 법인인감증명서/위임장/법인 등기부 등본 등 주민번호 \r\n   뒷자리, 개인 휴대폰 번호, 개인 집 주소 등 화이트 마킹 처리 바랍니다.\r\n- 반드시 제출일시까지 시스템 내 서류 업로드 후 원본 서류 발송 바랍니다.\r\n\r\nㅇ 제출처 : 우리은행 IT전자입찰시스템 및 서울특별시 중구 소공로48 우리금융디지털타워 19층 IT전략부 ";
	String REMARK = "";
	String ESTM_MAX_VOTE = "";

	String STANDARD_POINT = "";
	String TECH_DQ = "";
	String AMT_DQ = "";
	String BID_EVAL_SCORE = ""; 
	String PR_NO = "";
	
	//as-is column 추가
	String LIMIT_CRIT_CD		= "";
	String OPEN_GB         		= "";  	// 개찰구분
	String ITEM_TYPE       		= "";  	// 품목구분 코드
	String COST_SETTLE_TERMS	= "";	// 대금결제조건
	String REJECT_OPINION   	= "";	// 반려의견
	String APPV_STATUS      	= "";	// 문서 결재 상태
	String NEXT_AUTH_ID      	= request.getParameter("NEXT_AUTH_ID");	// 다음결재자
	String GUBUN     	     	= JSPUtil.nullToRef(request.getParameter("GUBUN"), "C");			// 공고문 관리에서는 'C' 나머지는 의미 없음.

	String X_MAKE_SPEC        	= "본건 관련 귀사 제출 견적서 참조";	// 기본값 설정후 사용자 수정
	String X_BASIC_ADD        	= "";
	String X_PURCHASE_QTY     	= "";
	String X_ESTM_CHECK       	= "";
	String X_PERSON_IN_CHARGE 	= "";
	String X_QUALIFICATION		= "";
	String X_RELATIVE_ADD		= "";
	String X_DOC_SUBMIT_TIME_HOUR_MINUTE	= "0000";
	String X_DOC_SUBMIT_DATE				= "";
		
	String INP_CNF              = "N";
	
	//SCR_FLAG : 최초생성(I), 수정(U), 정정(R)
	
	if(!SCR_FLAG.equals("V") ){
		
		if(!"".equals(ANN_NO)){
			Map map = new HashMap();
			map.put("ANN_NO"		, ANN_NO);
			map.put("ANN_COUNT"		, ANN_COUNT);

			Object[] obj = {map};
			SepoaOut value = ServiceConnector.doService(info, "I_BD_020", "CONNECTION","getPrHeaderDetail", obj);
			
			SepoaFormater wf = new SepoaFormater(value.result[0]); 

			//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
			
		    if(wf.getRowCount() > 0) {

				if (!(origin_bid_status).equals("IAR")) {
					ES_FLAG = wf.getValue("ES_FLAG", 0);
										
					ANN_TITLE =  wf.getValue("ANN_TITLE", 0);
					ANN_NO = wf.getValue("ANN_NO", 0);
					ANN_DATE = wf.getValue("ANN_DATE", 0);
					if(wf.getValue("ANN_ITEM", 0).indexOf(subSubject) != -1){
						subSubject = "";
					}
					ANN_ITEM = subSubject + wf.getValue("ANN_ITEM", 0);
					APP_ETC = wf.getValue("APP_ETC", 0);
					ATTACH_NO = wf.getValue("ATTACH_NO", 0);
					ATTACH_CNT = wf.getValue("ATTACH_CNT", 0);
					
					
					BID_JOIN_TEXT = wf.getValue("BID_JOIN_TEXT", 0);

					X_DOC_SUBMIT_DATE	= wf.getValue("X_DOC_SUBMIT_DATE", 0);
										
					X_DOC_SUBMIT_TIME_HOUR_MINUTE	= wf.getValue("X_DOC_SUBMIT_TIME_HOUR", 0) + wf.getValue("X_DOC_SUBMIT_TIME_MINUTE", 0);
					
					VENDOR_CNT = wf.getValue("VENDOR_CNT", 0);
					VENDOR_INFO = wf.getValue("VENDOR_INFO", 0);

					VENDOR_VALUES = "";
					String strTemp = JSPUtil.nullToEmpty(VENDOR_INFO.replaceAll ( "&#64;" , "@" ));
					String[] arrayVENDOR_CODE = SepoaString.parser( strTemp, "#" );
		            for( int j = 0; j < arrayVENDOR_CODE.length; j++ ) {
		            	VENDOR_VALUES += arrayVENDOR_CODE[j].substring(0,5) + "@";
		            }

					
				}
			}
		}
	}
	

	//if (origin_bid_status.equals("IUR")) // 정정공고 작성 대상건일 경우에는 ANN_STATUS = 'UR' 로 확정한다.
	//	ANN_STATUS = "UR";
	//
	//String displayMode = "display:inline";
	//if("S".equals(info.getSession("USER_TYPE")) ){		
	//	displayMode = "display:none";
	//}
	//
	//if("".equals(X_ESTM_CHECK)){
	//	X_ESTM_CHECK = "Y";
	//}
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%> 
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_ann2_ict";

var current_date = "<%=current_date%>";
var current_time = "<%=current_time%>";

var j=0;

function init() {

	if("<%=origin_bid_status%>" == "IAT") {
		document.form.ANN_NO.readOnly = "";
	}
	
	//생성시 디폴트값 세팅
	if ("<%=SCR_FLAG%>" == "I") {
		document.form.ANN_DATE.value = "<%=SepoaString.getDateSlashFormat(current_date)%>";	
		//document.form.BID_JOIN_TEXT.value = "(1)입찰보증서 : 서울보증보험(주) 및 기타 보증기관 발급 보증서\r\n(2)[입찰보증금 지급각서] 제출로 [입찰보증서] 생략 가능한 경우\r\n    (가)공사입찰 : 예정가격 3천만원 이하 입찰\r\n    (나)구매입찰 : 예정가격 1천만원 이하 입찰\r\n ※ 낙찰업체는 계약서 제출 시 [입찰보증서] 및 [입찰보증금 지급각서]\r\n    원본을 제출하여야 함\r\n";
	}
	
	<%if("D".equals(SCR_FLAG)){%>
		$("#comp_td").hide();
	<%}%>

	setGridDraw();
	
	<%if("S".equals(info.getSession("USER_TYPE")) ){%>
	$("#supiFlameDiv").hide();
	<%}%>

	fnMinute();
	
	<%if(!"".equals(VENDOR_VALUES)){%>
	parent.supiFlame.doSelect("<%=VENDOR_VALUES%>",null,null);
	<%}%>
}

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();

    setVisiblePeriod();
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

}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");
	var ann_no = obj.getAttribute("ann_no");
	var ann_count = obj.getAttribute("ann_count");
	var pflag = obj.getAttribute("pflag");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
		document.forms[0].ann_no.value = ann_no;
		document.forms[0].ann_count.value  = ann_count;
		
		if(mode == "setAnnCreate" || mode == "setGonggoModify" || mode == "setUGonggoCreate") {
 				alert("성공적으로 처리 되었습니다.");
				opener.doSelect();
				window.close();
		}else if(mode == "setGonggoConfirm") {
			alert(messsage);
			opener.doSelect();
			window.close();
		}else{
	        alert(messsage);
	        opener.doSelect();
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

<%-- 저장 = 'T', 입찰공고(확정)= 'C' , 결재요청 = 'P'--%>
 function Approval(sign_status)
{
	// 임시저장 = 'T', 입찰공고(확정)='C' , 결재요청 = 'P'
	G_FLAG = sign_status;
	button_flag = true;
	if (checkData() == false) {
		button_flag = false;
		return;
	} 
	
	$("#pflag").val(sign_status);
	
	if (sign_status == "P") {
		/* 
		document.forms[0].target = "childframe";
		document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
		document.forms[0].method = "POST";
		document.forms[0].submit();
		 */
		 
				
		$.post(
				G_SERVLETURL,
    			{
					ann_no : document.forms[0].ann_no.value,
					ann_count : document.forms[0].ann_count.value,
					mode  : "chkApprRep"
    			},
    			function(arg){
    				if(arg == "1" ){
    					var from            = "";
    					var house_code      = "<%=info.getSession("HOUSE_CODE")%>";
    					var company_code    = "<%=info.getSession("COMPANY_CODE")%>";
    					var dept_code       = "<%=info.getSession("DEPARTMENT")%>";
    					var req_user_id     = "<%=info.getSession("ID")%>";
    					var doc_type        = "RQ";
    					var doc_detail_type = "";
    					var fnc_name        = "getApproval";
    					var amt             = "";
    					var issue_type      = "";
    					var app_div         = "";
    					var asset_type      = "";

    					var url = "/ict/approval/ap2_pp_lis3_ict2.jsp?from="+from +"&doc_type="+doc_type+"&strategy=&req_user_id="+req_user_id+"&dept_code="+dept_code+"&company_code="+company_code+"&house_code="+house_code+"&issue_type="+issue_type+"&fnc_name="+fnc_name+"&app_div="+app_div+"&asset_type="+asset_type; 	
    					PopupGeneral(url,"pop_up","50","50","700","550");			
    				}else if(arg == "0" ){ 
    					alert("입력대상업체 입력확인을 하세요");        					
        			}else if(arg == "-999"){
        				alert("결재요청중 오류발생1");
        			}else{
        				alert("결재요청중 오류발생2");        				
        			}
    				    				
    				
    			}
		);
		
		
	} else {
		goSave(sign_status, "");
		return;
	} 
	
}
 
function getApproval(approval_str) {
	if (approval_str == "") {
		alert("결재자를 지정해 주세요");
			
		return;
	}
		
	$("#approval_str").val(approval_str);
	//document.attachFrame.setData();	//startUpload
	goSave($("#pflag").val(), approval_str);
}

/**
 * 임시저장 = 'T', 확정= 'C' : 결재요청-없음='P'
 */
function goSave(pflag, approval_str)
{
	 /*
	 alert(approval_str);
	 return;
	 */
	 if(pflag == "T") {
		if(confirm("저장 하시겠습니까?") != 1) {
			button_flag = false;
			return;
		}
	} else if(pflag == "C") {
		if(confirm("입찰공고를 확정하시겠습니까?") != 1) {
			button_flag = false;
			return;
		}
	} else if(pflag == "P") {
		if(confirm("결재상신 하시겠습니까?") != 1) {
			button_flag = false;
			return;
		}
	} 
	 
	<%--입찰공고 최초생성 저장--%>
	if("<%=origin_bid_status%>" == "IAT") {
		if (pflag == "T"){
			mode = "setAnnCreate";
			document.forms[0].ann_no.value="";
		}/*else if (pflag == "P"){
			mode = "setAnnCreate";
			document.forms[0].ann_no.value="";
		}*/
	}
	
	<%-- 입찰공고 생성후 수정 및 결재요청 --%>
	if("<%=origin_bid_status%>" == "UAT" || "<%=origin_bid_status%>" == "UAJ") {
		if (pflag == "T"){
			mode = "setGonggoModify";
		} else if (pflag == "C"){
			 //입찰공고 확정
			mode = "setGonggoConfirm";
		}/* else if (pflag == "P"){
			mode = "setGonggoModify";
		}*/
	}
	
	<%--정정공고_작성 --%>
	if("<%=origin_bid_status%>" == "IUT") {
		if (pflag == "T"){
			mode = "setUGonggoCreate";
			$("#ANN_STATUS").val("UT");
			<%--
			<input type="hidden" name="ANN_STATUS" id="ANN_STATUS" value="<%=ANN_STATUS%>"/>
			<input type="hidden" name="pflag" id="pflag" />
			--%>			
		}
		/*
		if (pflag == "C"){
			mode = "setUGonggoCreate";
		}
		*/
	}
	
	<%-- 정정공고 생성후 수정 및 결재요청 --%>
	if("<%=origin_bid_status%>" == "UUT" || "<%=origin_bid_status%>" == "UUJ") {
		if (pflag == "T"){
			mode = "setUGonggoModify";
			$("#ANN_STATUS").val("UT");
		} /*else if (pflag == "C"){
			 //입찰공고 확정
			mode = "setGonggoConfirm";
		}*/ else if (pflag == "P"){
			mode = "setUGonggoModify";
		}
	}

	//if("<%=SCR_FLAG%>" == "I") {
	//	 <%--입찰공고 생성--%>
	//	mode = "setAnnCreate";
	//	document.forms[0].ann_no.value="";
	//} else if("<%=SCR_FLAG%>" == "U") {
	//	if (pflag == "T"){
	//		 <%--입찰공고 수정--%>
	//		mode = "setGonggoModify";
	//	} else if (pflag == "C"){
	//		 <%--입찰공고 확정--%>
	//		mode = "setGonggoConfirm";
	//	}
	//}
	
	var ANN_NO                     = document.forms[0].ANN_NO.value;   
	var ANN_DATE					= del_Slash(document.forms[0].ANN_DATE.value);  
	
	var BID_BEGIN_DATE				= del_Slash(document.forms[0].BID_BEGIN_DATE.value);
	var BID_BEGIN_TIME_HOUR_MINUTE	= document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value;
	var BID_BEGIN_TIME				= BID_BEGIN_TIME_HOUR_MINUTE +  "00";

	var BID_END_DATE				= del_Slash(document.forms[0].BID_END_DATE.value);
	var BID_END_TIME_HOUR_MINUTE	= document.forms[0].BID_END_TIME_HOUR_MINUTE.value;
	var BID_END_TIME				= BID_END_TIME_HOUR_MINUTE +    "00";

	var OPEN_DATE					= del_Slash(document.forms[0].OPEN_DATE.value);
	var OPEN_TIME_HOUR_MINUTE		= document.forms[0].OPEN_TIME_HOUR_MINUTE.value;
	var OPEN_TIME					= OPEN_TIME_HOUR_MINUTE + "00";
	
	
	var X_DOC_SUBMIT_DATE			   = del_Slash(document.forms[0].X_DOC_SUBMIT_DATE.value);
	var X_DOC_SUBMIT_TIME_HOUR_MINUTE  = document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value;
	var X_DOC_SUBMIT_TIME			   = X_DOC_SUBMIT_TIME_HOUR_MINUTE + "00";
	
	
	
	

	var CONT_TYPE2					= document.forms[0].CONT_TYPE2.value; 
	
	//Header
	document.forms[0].ann_no.value                        = ANN_NO           ;
	//document.forms[0].ann_count.value                     = "1";
	document.forms[0].ANN_DATE.value  		              = ANN_DATE         ;       	

	document.forms[0].BID_BEGIN_DATE.value                = BID_BEGIN_DATE   ;       	
	document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value    = BID_BEGIN_TIME   ;       	
                                                                                          
	document.forms[0].BID_END_DATE.value                  = BID_END_DATE     ;       	
	document.forms[0].BID_END_TIME_HOUR_MINUTE.value      = BID_END_TIME     ;       	
                                                                                        
	document.forms[0].OPEN_DATE.value                     = OPEN_DATE        ;       	
	document.forms[0].OPEN_TIME_HOUR_MINUTE.value         = OPEN_TIME        ;   
	
	document.forms[0].X_DOC_SUBMIT_DATE.value                     = X_DOC_SUBMIT_DATE        ;       	
	document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value         = X_DOC_SUBMIT_TIME        ;   
	
	
	
	
	document.forms[0].pflag.value         = pflag ;                  	// 임시저장, 입찰공고(확정)
	document.forms[0].approval_str.value  = approval_str  ;  
	
	document.forms[0].ANN_DATE.value          = del_Slash( document.forms[0].ANN_DATE.value          );
	document.forms[0].BID_BEGIN_DATE.value    = del_Slash( document.forms[0].BID_BEGIN_DATE.value    );
	document.forms[0].BID_END_DATE.value      = del_Slash( document.forms[0].BID_END_DATE.value      );
	document.forms[0].OPEN_DATE.value         = del_Slash( document.forms[0].OPEN_DATE.value         );


	//var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	var cols_ids = "<%=grid_col_id%>";
    var params = "?mode="+mode;
 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    
    //alert("mode : "+mode);
    //myDataProcessor = new dataProcessor( G_SERVLETURL, params );
    //sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );

    var SERVLETURL  = G_SERVLETURL + params;

    GridObj.loadXML(SERVLETURL);
    GridObj.clearAll(false);
    
}

function doQuery() {
	
	var SCR_FLAG = "<%=SCR_FLAG%>";
	var ANN_STATUS = "<%=ANN_STATUS%>";
	
	if(SCR_FLAG == "I" && ANN_STATUS == "AR"){  //신규
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
    var msg			= GridObj.getUserData("", "message");
    var status		= GridObj.getUserData("", "status");
    var mode		= GridObj.getUserData("", "mode");
	var ann_no		= GridObj.getUserData("", "ann_no");
	var ann_count	= GridObj.getUserData("", "ann_count");
	var pflag		= GridObj.getUserData("", "pflag");

    if(status == "true") {
		document.forms[0].ann_no.value = ann_no;
		document.forms[0].ann_count.value  = ann_count;
		
		if(mode == "setAnnCreate" || mode == "setGonggoModify" || mode == "setUGonggoCreate") {
	 			//alert("성공적으로 처리 되었습니다.");
	 			alert(msg);				
				opener.doSelect();
				window.close();
		}else if(mode == "setGonggoConfirm") {
				alert(msg);
				opener.doSelect();
				window.close();
		}else{
		        alert(msg);
		        opener.doSelect();
				window.close();
		}
    } else {
    	<%--오류발생--%>
        alert(msg);
        
        document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value    = document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value.substring(0,4)   ;
        
        document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value    = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value.substring(0,4)   ;       	                                                                                             
		document.forms[0].BID_END_TIME_HOUR_MINUTE.value      = document.forms[0].BID_END_TIME_HOUR_MINUTE.value.substring(0,4)     ;       	                                                                                            
		document.forms[0].OPEN_TIME_HOUR_MINUTE.value         = document.forms[0].OPEN_TIME_HOUR_MINUTE.value.substring(0,4)        ;   
    } 

    
    return true;
}

function initAjax()
{
}

function delVendorRow(){
	$("#seller_cnt").val("0");
}

// 대금결제조건을 선택했을때..
function fnCostSettleTerms(strFlag)
{
}

/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
 
function setVisibleVendor() {
	// 무조건 업체지정을 하는 것으로 요청하여 변경
	//var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value; // 입찰방법
	//
	//if("" == CONT_TYPE1){
	//	CONT_TYPE1 = "NC";
	//}
	//
	//// 지명경쟁 선택시
	//if ( CONT_TYPE1 == "NC" ) {
	//	for(n=1;n<=4;n++) {
	//		$('#h' + n).show();
	//	}
	//}
	//else {
	//	// 일반경쟁
	//	document.forms[0].vendor_values.value = "";
	//	document.forms[0].vendor_count.value = "0";
	//	for(n=1;n<=4;n++) { // 업체지정
	//		$('#h' + n).hide();
	//	}		
	//	delVendorRow();
	//}
}

	<%--
	입찰방법2(총액, TCO, 역경매)
		LP : 총액(가격)입찰
		TA : TCO입찰
		RA : 역경매
	--%>
	
	function setVisiblePeriod() {
		var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;
				
		if ( CONT_TYPE2 == "LP" || CONT_TYPE2 == "UC" ) {
			document.forms[0].PROM_CRIT.value = 'A';
			// 총액입찰
			$("#h_TA").hide();
			$("#h_RA").hide();
			$("#BID_END_DATE").show();
		} 
		else if ( CONT_TYPE2 == "TA" ) {
			// TCO 입찰
			if (document.forms[0].TCO_PERIOD.value == ""){
				document.forms[0].TCO_PERIOD.value = "5";
			}
			
			document.forms[0].PROM_CRIT.value = 'D';

			$("#h_TA").show();
			$("#h_RA").hide();
			$("#BID_END_DATE").show();
		}
		else if ( CONT_TYPE2 == "RA" || CONT_TYPE2 == "RC" ) {
			document.forms[0].PROM_CRIT.value = 'A';
			// 역경매
			if (document.forms[0].RA_TIME01.value == ""){
				document.forms[0].RA_TIME01.value = "";
				document.forms[0].RA_TIME02.value = "";
			}
	
			$("#BID_END_DATE").hide();
			$("#h_TA").hide();
			$("#h_RA").show();
		}
	}


	<%--업체지정--%>
	function vendor_Select() {	 
		
		document.form.vendor_each_flag.value = "0";
		
		load_type = 0;
		var cnt = 0;
		
		//if(!checkRows()) return;
		
		//var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var strVendor_Codes  = "";
		var strVendor_Info   = "";
		var SOURCING_GROUP   = "";
		var DESCRIPTION_LOC  = "";
		var selller_selected = "";
		//getVenderList("-1", "E", selller_selected,MATERIAL_NUMBER);
		//return;
		

		cnt = document.form.vendor_count.value;
		strVendor_Codes = document.form.vendor_values.value;
		strVendor_Info = document.form.vendor_info.value;
		
		if(cnt == 0) {
			getVenderList("-1", "E", strVendor_Codes,strVendor_Info);
		} else if(cnt > 0) {
			getVenderList("-1", "A", strVendor_Codes,strVendor_Info);
		}
	}
	
	function getVenderList(szRow, mode,strVendor_Codes,strVendor_Info) {

		var shipper_type = 'D';
		var company_code = "<%=COMPANY_CODE%>";
		var param        = "&mode=" + encodeUrl(mode) + "&szRow=" + encodeUrl(szRow);//+"&selller_selected="+selller_selected;
		
		if(document.form.vendor_each_flag.value != "1"){ //버튼클릭하여 업체지정시
			param += "&type=button";
		}
		param +=  "&shipper_type="+encodeUrl(shipper_type)+"&MATERIAL_NUMBER="+strVendor_Info+"&company_code="+company_code;
		popUpOpen("rfq_req_sellerselframe_ict.jsp?popup_flag=true"+param, 'RFQ_REQ_SELLERSELFRAME', '880', '660');
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
		var VANDOR_INFO = "";
		setVendorList(szRow, VANDOR_INFO, VANDOR_SELECTED, SELECTED_COUNT);
	}

	<%--업체선택후 호출되는 Function--%>
	function setVendorList(szRow, VANDOR_INFO, VANDOR_SELECTED, SELECTED_COUNT) {
		
		//VENDOR_INFO     : 선택된 업체의 정보 : 업체코드@업체명@사업번호@PHONE_NO1@PURCHASE_BLOCK_FLAG@supiSelected@# -- 업체반복
		//VANDOR_SELECTED : 선택된 업체의 정보 : I0001 @I0002@
		//SELECTED_COUNT  : 선택된 업체의 수

		//dhtmlx_last_row_id++;
		//var nMaxRow2 = dhtmlx_last_row_id;
		//var row_data = "<%=grid_col_id%>";
		//
		//
		////document.form.vendor_each_flag.value : 0
		//if(document.form.vendor_each_flag.value != "1"){//헤더의 업체선택 버튼을 클릭한 경우
		//	document.form.seller_cnt.value = SELECTED_COUNT;
		//	document.form.vendor_count.value = SELECTED_COUNT;
		//	var grid_array = getGridChangedRows(GridObj, "SELECTED");
        //
		//	for(var i = 0; i < grid_array.length; i++){
		//		GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED")).setValue(VANDOR_SELECTED);
		//		GridObj.cells(grid_array[i], GridObj.getColIndexById("SELLER_SELECTED_CNT")).setValue(SELECTED_COUNT);
		//	}
		//}
		//else{//그리드의  업체선택 버튼을 클릭한 경우
		//	GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SELLER_SELECTED")).setValue(VANDOR_SELECTED);
		//	GridObj.cells(document.form.rownum.value, GridObj.getColIndexById("SELLER_SELECTED_CNT")).setValue(SELECTED_COUNT);
		//}

		document.form.seller_cnt.value = SELECTED_COUNT;
		document.form.vendor_count.value = SELECTED_COUNT;
		document.form.seller_choice.value="1";
		document.form.vendor_values.value=VANDOR_SELECTED;
		document.form.vendor_info.value=VANDOR_INFO;

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
		return true;
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
		if(!TimeCheck2(bid_end_time)){
			document.form.BID_END_TIME_HOUR_MINUTE.focus();
			alert("입찰서 제출일시 확인하세요.");
			return false;
		}
	}
	
	/**
	 * 시간 체크
	 */
	function TimeCheck2(str)
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
		if(LRTrim(document.form.ANN_DATE.value) == "") {
			alert("공고일자를 입력하십시오.");
			document.forms[0].ANN_DATE.focus();
			return false;
		}
		
		if(LRTrim(document.form.ANN_NO.value) == "") {
			alert("공고번호를 입력하십시오.");
			document.forms[0].ANN_DATE.focus();
			return false;
		}
        
		/*
		if(parseFloat(del_Slash(document.form.ANN_DATE.value)) < parseFloat(current_date)) {
			alert("금일보다 이전일자를 공고일자로 지정하였습니다.");
			return false;
		}
		*/
		
		if(LRTrim(document.form.ANN_ITEM.value) == "") {
			alert("공고명을 입력하십시오. ");
			document.forms[0].ANN_ITEM.focus();
			return false;
		}
		
				
		if(LRTrim(document.form.X_DOC_SUBMIT_DATE.value) == "") {
			alert("서류제출 마감일을 입력하세요. ");
			document.forms[0].X_DOC_SUBMIT_DATE.focus();
			return false;
		}
		
		var X_DOC_SUBMIT_TIME_HOUR_MINUTE   = document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value;
		var X_DOC_SUBMIT_HH = X_DOC_SUBMIT_TIME_HOUR_MINUTE.substr(0,2);
		var X_DOC_SUBMIT_MM = X_DOC_SUBMIT_TIME_HOUR_MINUTE.substr(2,2);
	
		if(!isNumberCommon(X_DOC_SUBMIT_TIME_HOUR_MINUTE)){
			alert("유효하지 않는 제출시각입니다. ");
			document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.select();
			return false;
		}
	
		if(parseInt(X_DOC_SUBMIT_HH) >= 24 || parseInt(X_DOC_SUBMIT_MM) >= 60){
			alert("유효하지 않는 제출시각입니다. ");
			document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.select();
			return false;
		}
				
		
		
		
		/* 
		if(LRTrim(document.form.CONT_TYPE2.value) == "LP") { // 최저가 일경우...
			if(LRTrim(document.form.BID_BEGIN_DATE.value) == "")  {
				alert("입찰일시(시작일자)를 입력하여 주십시오.");
				document.forms[0].BID_BEGIN_DATE.focus();
				return false;
			}

			if(LRTrim(document.form.BID_END_DATE.value) == "")  {
				alert("입찰일시(종료일자)를 입력하여 주십시오.");
				document.forms[0].BID_END_DATE.focus();
				return false;
			}

			if(LRTrim(document.form.OPEN_DATE.value) == "")  {
				alert("개찰일자를 입력하여 주십시오");
				document.forms[0].OPEN_DATE.focus();
				return false;
			}
		}

		
		
		
		var cur_hh   = current_time.substring(0,2);
		var cur_mm   = current_time.substring(2,4);

		var ANN_DATE                		= del_Slash(document.forms[0].ANN_DATE.value); // 공고일자
		
		var BID_BEGIN_DATE          		= del_Slash(document.forms[0].BID_BEGIN_DATE.value);	// 입찰시작일자
		var BID_BEGIN_TIME_HOUR_MINUTE      = document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.value;	// 입찰시작시간
		var BID_END_DATE            		= del_Slash(document.forms[0].BID_END_DATE.value);		// 입찰종료일자
		var BID_END_TIME_HOUR_MINUTE        = document.forms[0].BID_END_TIME_HOUR_MINUTE.value;		// 입찰종료시간
		var X_DOC_SUBMIT_DATE				= del_Slash(document.forms[0].X_DOC_SUBMIT_DATE.value);  // 서류제출 마감일자
		var X_DOC_SUBMIT_TIME_HOUR_MINUTE   = document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.value; // 서류제출 마감시간

		
		// 개발일시 및 시간은 일찰종료정보를 그대로 사용한다.(사용자 요구)
		document.forms[0].OPEN_DATE.value   = document.forms[0].BID_END_DATE.value;
		document.forms[0].OPEN_TIME_HOUR_MINUTE.value   = document.forms[0].BID_END_TIME_HOUR_MINUTE.value;
		
		
		var OPEN_DATE               		= del_Slash(document.forms[0].OPEN_DATE.value);			// 개찰일자
		var OPEN_TIME_HOUR_MINUTE           = document.forms[0].OPEN_TIME_HOUR_MINUTE.value;		// 개찰시간

		if (eval(ANN_DATE) < eval(current_date)) {
			alert ("공고일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].ANN_DATE.focus();
			return false;
		}
		
		// 입찰서제출일시
		if (eval(X_DOC_SUBMIT_DATE) < eval(current_date)) {
			alert ("제출일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].X_DOC_SUBMIT_DATE.focus();
			return false;
		} else if (eval(X_DOC_SUBMIT_DATE) == eval(current_date)) {
			if (eval(X_DOC_SUBMIT_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
				alert ("제출일시의 시작시간은 현재시간보다 이후여야 합니다.");
				document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.focus();
				return false;
			} else if (eval(X_DOC_SUBMIT_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
				if (eval(X_DOC_SUBMIT_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
					alert ("제출일시의 시작시간 설정이 잘못되었습니다.");
					document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.focus();
					return false;
				}
			}
		}	
		
		if (eval(BID_BEGIN_DATE) < eval(current_date)) {
			alert ("입찰일시의 시작일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].BID_BEGIN_DATE.focus();
			return false;
		} else if (eval(BID_BEGIN_DATE) == eval(current_date)) {
			if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) <   eval(cur_hh)) {
				alert ("입찰일시의 시작시간은 현재시간보다 이후여야 합니다.");
				document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
				return false;
			} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(cur_hh)) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
					alert ("입찰일시의 시작시간 설정이 잘못되었습니다.");
					document.forms[0].BID_BEGIN_TIME_HOUR_MINUTE.focus();
					return false;
				}
			}
		}

		if (eval(BID_END_DATE) < eval(current_date)) {
			alert ("입찰일시의 종료일자는 오늘보다 이후 날짜이어야 합니다.");
			document.forms[0].BID_END_DATE.focus();
			return false;
		} else if (eval(BID_END_DATE) == eval(current_date)) {
			if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))   < eval(cur_hh)) {
				alert ("입찰일시의 종료시간은 현재시간보다 이후여야 합니다.");
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				return false;
			} else if (eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)) == eval(cur_hh))   {
				if (eval(BID_END_TIME_HOUR_MINUTE.substring(2,4)) < eval(cur_mm)) {
					alert ("입찰일시의 종료 시간 설정이 잘못되었습니다.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				}
			}
		}

		if (eval(BID_BEGIN_DATE) > eval(BID_END_DATE)) {
			alert ("입찰일시의 종료일자는 시작일자보다 커야합니다.");
			document.forms[0].BID_BEGIN_DATE.focus();
			return false;
		} else if (eval(BID_BEGIN_DATE) == eval(BID_END_DATE)) {
			if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) >   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
				alert ("입찰일시의 종료시간은 시작시간보다 커야합니다.");
				document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
				return false;
			} else if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,2)) ==   eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
				if (eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(2,4)) >= eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
					alert ("입찰일시의 종료시간 설정이 잘못되었습니다.");
					document.forms[0].BID_END_TIME_HOUR_MINUTE.focus();
					return false;
				}
			}
		}
		
		if (eval(X_DOC_SUBMIT_DATE) > eval(BID_BEGIN_DATE)) {
			alert ("제출일시는 입찰서제출일 보다 이전 날짜이어야 합니다.");
			document.forms[0].X_DOC_SUBMIT_DATE.focus();
			return false;
		} else if (eval(X_DOC_SUBMIT_DATE) == eval(BID_BEGIN_DATE)) {
			if (eval(X_DOC_SUBMIT_TIME_HOUR_MINUTE.substring(0,4)) > eval(BID_BEGIN_TIME_HOUR_MINUTE.substring(0,4))) {
				alert ("제출일시는 입찰서제출시작 시간보다 이전이여야 합니다.");
				document.forms[0].X_DOC_SUBMIT_TIME_HOUR_MINUTE.focus();
				return false;
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
			alert ("입찰일시 시작일자는 공고등록일시보다 커야합니다.");
			document.forms[0].BID_BEGIN_DATE.focus();
			return false;
		}

		// 입찰서제출일시 ~ 개찰일시
		if (eval(OPEN_DATE) < eval(BID_END_DATE)) {
			alert ("개찰일시는 입찰일시 종료일자보다 커야합니다.");
			document.forms[0].OPEN_DATE.focus();
			return false;
		} else if (eval(OPEN_DATE) == eval(BID_END_DATE)) {
			if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2)) < eval(BID_END_TIME_HOUR_MINUTE.substring(0,2))) {
				alert ("개찰일시는 입찰일시 종료시간보다 이후여야 합니다.");
				document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
				return false;
			} else if (eval(OPEN_TIME_HOUR_MINUTE.substring(0,2))   == eval(BID_END_TIME_HOUR_MINUTE.substring(0,2)))   {
				if (eval(OPEN_TIME_HOUR_MINUTE.substring(2,4)) < eval(BID_END_TIME_HOUR_MINUTE.substring(2,4))) {
					alert ("개찰일시는 입찰일시 종료시간보다 이후여야 합니다.");
					document.forms[0].OPEN_TIME_HOUR_MINUTE.focus();
					return false;
				}
			}
		}
		
		if(LRTrim(document.form.attach_no.value) == ""){
			alert("첨부서류는 필수 입니다.");
			return false;
		}
		*/
 	}

	// 첨부파일
	function setAttach(attach_key, arrAttrach,rowId, attach_count) {
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
//         setApprovalButton(attach_count);
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
	
	
	

	
	function setCopy()  //2010.10.27 공고 버전관리를  위해 copy기능 추가
	{ 
		$.post(
			G_SERVLETURL,
			{
				curr_version:"<%=ANN_VERSION%>",
				mode:"setCopy"
			},
			function(arg){
// 				var rtn = eval(arg);
// 				alert(rtn);
				alert('복사된 공고문을 확인하기 위해서는 반드시 화면을 새로고침하십시오.');
// 				document.reload();
			}
		); 		
	}	

	
	function doExplanation()
	{

		mode= "I";
		if(true == explanation_modify_flag) mode= "IM";

// 		cnt = document.SepoaGrid.GetRowCount();
		cnt = GridObj.GetRowCount();
		if(cnt == 0 ) {
			alert("입찰공고대상건이 없습니다.");
			return;
		}

		if("I" == mode) {
			//alert(mode);
			if(cnt > 0) window.open('ebd_pp_ins1.jsp?mode=' + mode + '&SCR_FLAG=<%=SCR_FLAG%>&cnt=' + cnt ,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=760,height=300,left=0,top=0");

		} else if("IM" == mode) {

			ANN_NO = document.form.ann_no.value;
			ANN_COUNT = document.form.ann_count.value;
			SZDATE = document.form.szdate.value;
			START_TIME = document.form.start_time.value;

			END_TIME = document.form.end_time.value;
			PLACE = document.form.place.value;
			ANNOUNCE_FLAG = document.form.ANNOUNCE_FLAG.value;
			ANNOUNCE_TEL = document.form.ANNOUNCE_TEL.value;

			resp = document.form.resp.value;
			comment = document.form.comment.value;
			//alert(mode);

			szurl = 'ebd_pp_ins1.jsp?mode=' + mode + '&ANN_NO=' + ANN_NO;
			szurl += '&ANN_COUNT=' + ANN_COUNT + '&SZDATE=' + SZDATE;
			szurl += '&START_TIME=' + START_TIME + '&END_TIME=' + END_TIME;
			szurl += '&PLACE=' + PLACE + '&ANNOUNCE_FLAG=' + ANNOUNCE_FLAG + '&ANNOUNCE_TEL=' + ANNOUNCE_TEL;
			szurl += '&resp=' + resp + '&SCR_FLAG=<%=SCR_FLAG%>&comment=' + comment;

			if(cnt > 0) window.open(szurl,"ebd_pp_ins1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=760,height=200,left=0,top=0");
		}
	}

	function setExplanation(szdate, start_time, end_time, place)
	{

		document.form.szdate.value          = szdate;
		document.form.start_time.value      = start_time;

		document.form.end_time.value        = end_time;
		document.form.place.value           = place;
		//document.form.ANNOUNCE_FLAG.value           = ANNOUNCE_FLAG;
		//document.form.ANNOUNCE_TEL.value            = ANNOUNCE_TEL;

		//document.form.resp.value            = resp;
		//document.form.comment.value         = comment;

		explanation_modify_flag = "true";
		//checkExplanation();
	}

	function setApprovalButton(attach_count){
		try{
			if(attach_count>0){
				document.getElementById("approvalButton1").style.display = "";
				document.getElementById("approvalButton2").style.display = "none";
			}else{
				document.getElementById("approvalButton1").style.display = "none";     
				document.getElementById("approvalButton2").style.display = "";
			}
		}catch(e){
			
		}
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
	
	function onlyNumber(keycode){
		if(keycode >= 48 && keycode <= 57){
		}else {
			return false;
		}
		return true;
	}

	
	<%--쿼리 조회시 프로그레스바의 위치:Grid의 숨김으로 위치이상이 발생 --%>
	function doQueryDuring()
	{
		var dim  = new Array(2);
		var win_width = 190;	//프로그레스바의 너비
		var win_height = 80;	//프로그레스바의 높이
			var gridbox_temp = document.getElementById('gridbox');
			var content_temp = document.getElementById('content');
		var content_temp_height="";
			if(content_temp == null){	//popup일때 content가 없다.
				content_temp_height = BwindowHeight();	//content 대신 창 전체 높이
			}else{
				content_temp_height = content_temp.offsetHeight;	//content의 높이 
			}
			var left = (parseInt($(document).width()) - win_width)/2;	//gridbox_temp.style.width 값에서 'px'문자를 제거하기 위해 parseInt함수를 사용.
			var top = parseInt(content_temp_height) - parseInt(gridbox_temp.offsetHeight)/2 - win_height;
		if(dhxWins == null) {
	    	dhxWins = new dhtmlXWindows();
	    	//dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlxWindows/codebase/imgs/");
	    	dhxWins.setImagePath("<%=POASRM_CONTEXT_NAME%>/dhtmlx/dhtmlx_full_version/imgs/");
				dhxWins.enableAutoViewport(false);		//추가함
				if(content_temp != null){	//popup일때 content가 없다.
			    dhxWins.attachViewportTo("content");	//추가함 - div id가 content인 영역안에서 window 효과를 나타낸다. (setModal 효과를 JSP내용안으로만 한정하기 위해)
		 		}
	    }
		if(prg_win == null) {
			//prg_win = dhxWins.createWindow("prg_win", left, top, 180, 73);
			//prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			prg_win = dhxWins.createWindow("prg_win", left, top, win_width, win_height);
			
			prg_win.setText("Please wait for a moment.");
			prg_win.button("close").hide();
			prg_win.button("minmax1").hide();
			prg_win.button("minmax2").hide();
			prg_win.button("park").hide();
			dhxWins.window("prg_win").setModal(true);
			prg_win.attachURL("<%=POASRM_CONTEXT_NAME%>/common/progress_ing.htm");
		} else {
			dhxWins.window("prg_win").setPosition(left,top);		//위치 이동 추가함
			dhxWins.window("prg_win").setModal(true);
		    dhxWins.window("prg_win").show();
		}
		<% if(!isRowsMergeable) { %>
	    	<%=grid_obj%>.enableSmartRendering(true);
	    <% } %>
		return true;
	}
	
	function fnMinute(){
		var strBegin = document.form.BID_BEGIN_TIME_HOUR_MINUTE.value;
		var strEnd   = document.form.BID_END_TIME_HOUR_MINUTE.value;

		var iBeginHour = 0;
		var iBeginMin = 0;
		var iEndHour = 0;
		var iEndMin = 0;
		
	  	//hh=str.substring(0,2);
	  	//mm=str.substring(2,4);
		if (strBegin.length == 4 ){
			iBeginHour = parseFloat(strBegin.substring(0,2));
			iBeginMin  = parseFloat(strBegin.substring(2,4));
		}
		if (strEnd.length == 4 ){
			iEndHour = parseFloat(strEnd.substring(0,2));
			iEndMin  = parseFloat(strEnd.substring(2,4));
		}
		var diffTime = ((iEndHour - iBeginHour - 1) * 60) + ((iEndMin) + (60 - iBeginMin));

		document.getElementById("lblMin").innerHTML = "(" + diffTime + "분)";
	}
	
	function ES_FLAG_onchange(oES_FLAG){
		
		if(oES_FLAG.value == "E"){
			document.forms[0].BID_PLACE.value = "IT전자구매시스템";
			document.forms[0].CONT_PLACE.value = "IT전자구매시스템 입찰실시 공고 내 입찰관련서류접수";
			document.forms[0].BID_ETC.value = "입찰시간 10분전까지 접속 바라며, 첨부서류 미 제출시\r\n응찰의사가 없는 것으로 간주함.";		
		}else if(oES_FLAG.value == "S"){
			document.forms[0].BID_PLACE.value = "";
			document.forms[0].CONT_PLACE.value = "XXXX.XX.XX XX:XX까지 당행 ICT구매팀 제출";
			document.forms[0].BID_ETC.value = "입찰시간 10분전까지 입실 바라며, 첨부서류 미 제출시\r\n응찰의사가 없는 것으로 간주함.";		
		}
		
	}

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init();initAjax();">
<s:header popup="true">



	<!--내용시작-->
<form id="form" name="form">
	
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
	<input type="hidden" name="house_code" id="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" id="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" id="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type" id="doc_type" value="RQ">
	<input type="hidden" name="fnc_name" id="fnc_name" value="getApproval">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>	
	
	
	
	
	<input type="hidden" name="ANN_VERSION" id="ANN_VERSION" value="<%=ANN_VERSION%>">
	<%if("D".equals(BID_TYPE)) {%>
		<input type="hidden" id="hidCOST_SETTLE_TERMS" name="hidCOST_SETTLE_TERMS" value="">
	<%} %>
	<%--<input type="hidden" id="FROM_LOWER_BND" 	name="FROM_LOWER_BND" 	size="3" maxlength="2" value="<%=FROM_LOWER_BND%>" <%=script%> > --%>
	<input type="hidden" id="ESTM_KIND" 		name="ESTM_KIND" 		value="U">

	<input type="hidden" name="PR_NO" id="PR_NO" value="<%=PR_NO%>"/>
	<input type="hidden" name="BID_TYPE" id="BID_TYPE" value="<%=BID_TYPE%>"/>
	<input type="hidden" name="APP_BEGIN_TIME" id="APP_BEGIN_TIME" />
	<input type="hidden" name="APP_END_TIME" id="APP_END_TIME" /> 
	<input type="hidden" name="ANN_STATUS" id="ANN_STATUS" value="<%=ANN_STATUS%>"/>
	<input type="hidden" name="CTRL_AMT" id="CTRL_AMT" value="<%=CTRL_AMT%>"/>
	<input type="hidden" name="pflag" id="pflag" />
	<input type="hidden" name="approval_str" id="approval_str" />

	<input type="hidden" name="PR_DATA" id="PR_DATA" value="<%=PR_DATA%>"/>
	<!-- 업체수 hidden으로 바꿈 -->                                                    
	<!--<input type="hidden" name="vendor_count" id="vendor_count" value="0">                          -->
	                                                            
	<input type="hidden" name="sign_status" id="sign_status" value="N">                          
	<!-- 저장,결재를 구분하는 플래그 -->                                        
	<input type="hidden" name="bid_amt" id="bid_amt" value="">                               
	<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>"> 
	<input type="hidden" name="vendor_info"     id="vendor_info"    value="<%=VENDOR_INFO%>">
	      
	<input type="hidden" name="location_values" id="location_values" value="<%=LOCATION_VALUES%>">   
	
	<!-- 제안경쟁에 의한 추가 -->
	<input type="hidden" name="LOC_CODE" id="LOC_CODE" value="<%=LOC_CODE%>">   
                                                           
	<!-- hidden(제안설명회) //-->                                               
	<input type="hidden" name="ann_no" 	  			id="ann_no" 	        value="<%=ANN_NO%>">
	<input type="hidden" name="ann_count" 	  		id="ann_count" 	 		value="<%=ANN_COUNT%>">              
	<input type="hidden" name="start_time" 	  		id="start_time" 	 	value="<%=ANNOUNCE_TIME_FROM%>">    
	<input type="hidden" name="end_time" 	  		id="end_time" 	 		value="<%=ANNOUNCE_TIME_TO%>">         
	<input type="hidden" name="ANNOUNCE_FLAG" 		id="ANNOUNCE_FLAG"     	value="<%=ANNOUNCE_FLAG%>">       
	<input type="hidden" name="ANNOUNCE_TEL"  		id="ANNOUNCE_TEL"      	value="<%=ANNOUNCE_TEL%>">         
	<input type="hidden" name="area" 	  			id="area" 	         	value="<%=ANNOUNCE_AREA%>">                
	<input type="hidden" name="place" 	  			id="place" 	         	value="<%=ANNOUNCE_PLACE%>">              
	<input type="hidden" name="notifier" 	  		id="notifier" 	 		value="<%=ANNOUNCE_NOTIFIER%>">
	<input type="hidden" name="doc_frw_date"  		id="doc_frw_date"      	value="<%=DOC_FRW_DATE%>">         
	<input type="hidden" name="resp" 	  			id="resp" 	         	value="<%=ANNOUNCE_RESP%>">                
	<input type="hidden" name="comment" 	  		id="comment" 	        value="<%=ANNOUNCE_COMMENT%>">          
	<input type="hidden" name="data1" 	  			id="data1" 	         	value="">                         
	<input type="hidden" name="attach_gubun"  		id="attach_gubun"      	value="body">        
	<input type="hidden" name="att_mode" 	  		id="att_mode" 	 		value="">                      
	<input type="hidden" name="view_type" 	  		id="view_type" 	 		value="">                     
	<input type="hidden" name="file_type" 	  		id="file_type" 	 		value="">                     
	<input type="hidden" name="tmp_att_no" 	  		id="tmp_att_no" 	 	value="">                    
	<input type="hidden" name="BID_EVAL_SCORE" 		id="BID_EVAL_SCORE"  	value="<%=BID_EVAL_SCORE%>"/>   
	<input type="hidden" name="seller_change_flag" 	id="seller_change_flag" value= "Y"><!-- 업체선택여부 -->
	<input type="hidden" name="p_approval_flag" 	id="p_approval_flag"> 

	<input type="hidden" id="vendor_each_flag" 	name="vendor_each_flag">
	<input type="hidden" id="rownum" 			name="rownum">
	<input type="hidden" id="seller_cnt" 		name="seller_cnt" value="<%=VENDOR_CNT%>">
	<input type="hidden" id="seller_choice" 	name="seller_choice">

	<input type="hidden" name="app_line_id"  	id="app_line_id"  />
	<input type="hidden" name="app_line_seq" 	id="app_line_seq" />
	<input type="hidden" name="app_auto_flag" 	id="app_auto_flag" />
	<input type="hidden" name="app_line"     	id="app_line"     />
	<input type="hidden" name="Approval_str" 	id="Approval_str" />
	<input type="hidden" name="att_show_flag" 	id="att_show_flag">
	<input type="hidden" name="attach_seq"	  	id="attach_seq"	 >	
	<input type="hidden" name="isGridAttach"  	id="isGridAttach" >
	<input type="hidden" name="only_attach" 	id="only_attach" value="">
	
	
	<input type="hidden" name="BID_INPUT_TYPE" 	id="BID_INPUT_TYPE" value="">
	<input type="hidden" name="X_AUTO_FLAG" 	id="X_AUTO_FLAG"    value="Y">
	
	
	<input type="hidden" name="inp_cnf" 	id="inp_cnf"    value="<%=INP_CNF%>">
	
	
	
	<% if(!"Y".equals(view_content)) { %>
		<%if("I".equals(SCR_FLAG)) {%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" class='title_page'>입찰공고 생성</td>
				</tr>
			</table>
		<%}else if("D".equals(SCR_FLAG)) {%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" class='title_page'>입찰공고</td>
				</tr>
			</table>
		<%}else{%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" class='title_page'>입찰공고 확정(수정)</td>
				</tr>
			</table>
		<%}%>
	<%} %>

	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>

	<table width="98%" border="0" cellspacing="0" cellpadding="0" style="display:none;">
		<tr>
			<td>
				당행 계약사무지침 제4장에 의거 귀사를 다음의 건에 입찰대상자로 지명하고 입찰관련 사항에
				대하여 통지하오니 적극 참여해주시기 바랍니다.
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
									<td width="20%" class="title_td" height="15px">1. 공고일자</td>
									<td width="80%" class="data_td">
										<s:calendar id="ANN_DATE" default_value="<%=ANN_DATE %>"  format="%Y/%m/%d"  />
									</td>
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
									<td width="20%" class="title_td" height="15px">2. 공고번호</td>
									<td width="80%" class="data_td">
										<input type="text" id="ANN_NO" name="ANN_NO" value="<%=ANN_NO%>" class="input_re_2" readonly  style="background-color:white">
									</td>
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
									<td width="20%" class="title_td" height="15px">3. 공고명</td>
									<td width="80%" class="data_td">
										<input type="text" id="ANN_ITEM" name="ANN_ITEM" size="70" value="<%=ANN_ITEM.replaceAll("\"", "&quot;")%>" class="input_re_2" <%=script%> style="ime-mode:active" onKeyUp="return chkMaxByte(300,this,'공고명');" >
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" height="15px">4. 입찰구분</td>
									<td width="80%" class="data_td">
										<b>
											<span class="general_padding_left">
												<select id="ES_FLAG" name="ES_FLAG" onchange="javascript:ES_FLAG_onchange(this);" class="inputsubmit" <%=abled%>>
													<%
														String com0 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M966_ICT", ES_FLAG);
														out.println(com0);
													%>								
												</select>&nbsp;																
											</span>
										</b>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" height="15px">5. 입찰 대상품목 및 수량</td>
									<td width="80%" class="data_td">
										<%--구매입찰 제조사양 --%>
										<input type="text" id="X_MAKE_SPEC" name="X_MAKE_SPEC" size="70" value="<%=X_MAKE_SPEC%>" class="input_re_2" <%=script%> onKeyUp="return chkMaxByte(4000,this,'입찰 대상품목 및 수량사양')">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  width="20%" class="title_td">6. 입찰방법</td>
									<td  width="80%">
										<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
											<tr>
												<td width="60%" class="data_td" colspan="3">
													<table>
														<tr>
															<td>
																<b>
																<span class="general_padding_left">
																	<select id="CONT_TYPE1" name="CONT_TYPE1" class="inputsubmit"onChange="setVisibleVendor()" <%=abled%>>
																		<%
																		String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M974_ICT", CONT_TYPE1);
																		out.println(com1);
																		%>								
																	</select>&nbsp;
																	<select id="CONT_TYPE2" name="CONT_TYPE2" class="inputsubmit" onChange="setVisiblePeriod()" <%=abled%>>
																		<%
																		String com2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M973_ICT", CONT_TYPE2);
																		out.println(com2);
																		%>								
																	</select>&nbsp;
																	<select name="PROM_CRIT" id="PROM_CRIT" class="inputsubmit" <%=abled%>>
																		<%
																		String com5 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M930_ICT", PROM_CRIT);
																		out.println(com5);
																		%>								
																	</select>
																</span>
																</b>
															</td>																			  	
														</tr>
														<tr id="h_TA" style="display:none">
															<td colspan="2">
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																<input type="text" name="TCO_PERIOD" id="TCO_PERIOD" value="<%=TCO_PERIOD %>" size="4" maxlength="2" class="input_re"  <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">년 TCO
															</td>
														</tr>
														<tr id="h_RA" style="display:none">
															<td colspan="2">
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
																마감시간
																<input type="text" name="RA_TIME01" id="RA_TIME01" value="<%=RA_TIME01 %>" size="4" maxlength="2" class="input_re"  <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
																분안에 1순위가 변동 시
																<input type="text" name="RA_TIME02" id="RA_TIME02" value="<%=RA_TIME02 %>" size="4" maxlength="2" class="input_re"  <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
																분 연장
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
			</td>
		</tr>
	</table>

	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" style="height:60px">7. 입찰일시</td>
					  				<td width="80%" colspan="2" class="data_td">
		  								<span id="g18">
											<s:calendar id="BID_BEGIN_DATE" default_value="<%=SepoaString.getDateSlashFormat( BID_BEGIN_DATE )%>" format="%Y/%m/%d" disabled="<%=isEdit%>"/>일
											<input type="text" name="BID_BEGIN_TIME_HOUR_MINUTE" id="BID_BEGIN_TIME_HOUR_MINUTE" value="<%=BID_BEGIN_TIME_HOUR_MINUTE%>" size="8" maxlength="4" class="input_re"  <%=script%> onBlur="javascript:fnMinute();" style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
											&nbsp;&nbsp;~&nbsp;&nbsp;
											<s:calendar id="BID_END_DATE" default_value="<%=SepoaString.getDateSlashFormat( BID_END_DATE ) %>"  format="%Y/%m/%d" disabled="<%=isEdit%>"/>일 
											<input type="text" name="BID_END_TIME_HOUR_MINUTE" id="BID_END_TIME_HOUR_MINUTE" value="<%=BID_END_TIME_HOUR_MINUTE%>" size="8" maxlength="4" class="input_re" <%=script%> onBlur="javascript:fnMinute();" style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">
											&nbsp;<label id="lblMin"></label>
										</span>
										<br><br>
										※ 당행 사정에 따라 변경 될 수 있으며, 변경 시 유선 통지함<br>
										※ IT전자입찰시 상기의 입찰시간은 입찰 1회차의 시간임
		  							</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<%-- ICT에서는 개발일시 정보를 화면에 표시하지 않는다.(사용자 요구) --%>
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td  width="20%" class="title_td">7. 개찰일시</td>
					  				<td width="80%" colspan="2" class="data_td">
		  								<span id="g18">
											<s:calendar id="OPEN_DATE" default_value="<%=SepoaString.getDateSlashFormat( OPEN_DATE ) %>"  format="%Y/%m/%d" disabled="<%=isEdit%>"/>일
											<input type="text" name="OPEN_TIME_HOUR_MINUTE" id="OPEN_TIME_HOUR_MINUTE" value="<%=OPEN_TIME_HOUR_MINUTE%>" size="8" maxlength="4" class="input_re" <%=script%> style="ime-mode: disabled" onKeyPress="checkNumberFormat('[0-9]');">이후
										</span>
		  							</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" style="height:30px">8. 입찰장소</td>
									<td width="80%" class="data_td">
										<input type="text" id="BID_PLACE" name="BID_PLACE" size="70" class="input_re_2" value="<%=BID_PLACE%>" <%=script%> onKeyUp="return chkMaxByte(2000, this, '입찰장소');">										
									</td>
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
									<td width="20%" class="title_td">4. 서류제출 마감일시</td>
									<td width="30%" class="data_td">
										<s:calendar id="X_DOC_SUBMIT_DATE" default_value="<%=SepoaString.getDateSlashFormat( X_DOC_SUBMIT_DATE ) %>"  format="%Y/%m/%d" disabled="<%=isEdit%>"/>일
										<input type="text" id="X_DOC_SUBMIT_TIME_HOUR_MINUTE" name="X_DOC_SUBMIT_TIME_HOUR_MINUTE" size="4"  value="<%=X_DOC_SUBMIT_TIME_HOUR_MINUTE%>" maxlength="4"  class="input_re" <%=script%> onKeyPress="checkNumberFormat('[0-9]', this);" style="ime-mode:disabled;"> 까지
									</td>
									<td width="50%" class="data_td" id="comp_td">
										<span class="general_padding_left" id="h1">5. 제조사지정&nbsp;&nbsp;
											<a href="javascript:vendor_Select()" id="h2">
												<img src="../../images/button/butt_query.gif" align="absmiddle" border="0"   id="h3">
											</a>
											<input type="text" id="vendor_count" name="vendor_count" size="3" value="<%=VENDOR_CNT%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly  id=h4>
										</span>
									</td>			
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
									<td width="20%" class="title_td" style="height:60px">6. 제출서류</td>
									<td width="80%" class="data_td">
										<textarea id="BID_JOIN_TEXT" name="BID_JOIN_TEXT" cols="90" rows="7" maxlength="500" class="input_re_2" <%=script%> onKeyUp="return chkMaxByte(2000, this, '제출서류');"><%=BID_JOIN_TEXT%></textarea>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>		

	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" style="height:60px">5. 입찰신청서류제출</td>
									<td width="80%" class="data_td">
										<input type="text" id="CONT_PLACE" name="CONT_PLACE" size="70" class="input_re_2" value="<%=CONT_PLACE%>" <%=script%> onKeyUp="return chkMaxByte(4000, this, '제출방법');">
										<br><br>
										※ 첨부(입찰참가 신청서 내 붙임자료 포함)
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
						
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="title_td" rowspan="2" style="height:50px">11. 기타</td>
									<td width="80%" class="data_td">
						  				<textarea id="BID_ETC" name="BID_ETC" cols="80" rows="6" maxlength="500" class="input_re_2" <%=script%> onKeyUp="return chkMaxByte(4000, this, '내용');"><%=BID_ETC%></textarea>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display:none;">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr style="display:none">
									<td width="20%" class="title_td" rowspan="2" style="height:90px">11. 특이사항</td>
									<td width="80%" class="data_td">
						  				<textarea id="APP_ETC" name="APP_ETC" cols="80" rows="9" maxlength="2000" class="input_re_2" <%=script%> onKeyUp="return chkMaxByte(4000, this, '내용');"><%=APP_ETC%></textarea>
									</td>
								</tr>
								<tr>
									<td width="20%" class="title_td">12. 첨부서류</td>
									<td width="80%" class="data_td">
										<table>
											<tr>
												<td>
													<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
												</td>
												<td>
													<script language="javascript">
														btn("javascript:attach_file(document.forms[0].attach_no.value,'TEMP');document.forms[0].attach_seq.value=1","파일첨부")
													</script>
												</td>
												<td>
													<input type="text" name="attach_cnt" id="attach_cnt" size="3" class="div_empty_num_no" readonly value="<%=ATTACH_CNT%>">
													<input type="text" size="5" readOnly class="div_empty_no" value="<%=text.get("MESSAGE.file_count")%>" name="file_count">
												</td>
												<td width="170">
													<div id="attach_no_text"></div>
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
	<%--SCR_FLAG 값에 따라서 처리 --%>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<table cellpadding="0">
					<tr>
					    <%if ("I".equals(SCR_FLAG) || "U".equals(SCR_FLAG) ){%>
						<td>
							<script language="javascript">
								btn("javascript:Approval('T')", "저장");
							</script>
							
						</td>
						<%}%>
						<%if ("U".equals(SCR_FLAG) ){%>
							<td>
								<script language="javascript">
									btn("javascript:Approval('C')", "공고확정");
								</script>
							</td>
							<%--
							<td id="approvalButton1" >
								<script language="javascript">
									btn("javascript:Approval('P')", "결재요청");
								</script>
							</td>
							--%>
						<%}%>						
						<td>
							<script language="javascript">
								btn("javascript:window.close()", "닫 기");
							</script>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv">
		<iframe src="<%=POASRM_CONTEXT_NAME%>/ict/sourcing/rfq_req_sellersel_bottom_vi_ict.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
	</div>
	</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<%--사용하지 않지만 프로그램의 구조상 편의를 위하여 그리드를 그려준다. --%>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;display:none"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_BD_020" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html> 