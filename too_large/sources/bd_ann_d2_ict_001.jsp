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

	Config conf 			= new Configuration();
	boolean dev_flag		= false;
	String ssn 				= ""; // 사업자등록번호

	String sign_use_module	= "";// 전자결재 사용모듈
	boolean sign_use_yn 	= true;
	
    String  to_day      	= SepoaDate.getShortDateString();
    String  from_date   	= SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateDay( to_day, -30 ) );
    String  to_date     	= SepoaString.getDateSlashFormat( to_day );
 
	String PR_DATA 			= JSPUtil.nullToRef(request.getParameter("PR_DATA"),""); 
	String popup 			= JSPUtil.nullToRef(request.getParameter("popup_flag"),"true"); 
 
	String ANN_VERSION		= JSPUtil.nullToRef(request.getParameter("ANN_VERSION"), "");	//입찰서 버젼
	String VIEW_TYPE		= JSPUtil.nullToRef(request.getParameter("VIEW_TYPE"), "");	
	String VIEW_KIND		= JSPUtil.nullToRef(request.getParameter("VIEW_KIND"), "");		// 업체화면에서의 조회 여부
	
	String SUBJECT			= JSPUtil.nullToRef(request.getParameter("T_SUBJECT"), "");	
	String pr_type 			= JSPUtil.nullToEmpty(request.getParameter("PR_TYPE"));
	String req_type 		= JSPUtil.nullToEmpty(request.getParameter("REQ_TYPE"));  
	String ANN_STATUS 		= JSPUtil.nullToEmpty(request.getParameter("ANN_STATUS")); 
	String ANN_NO 			= JSPUtil.nullToEmpty(request.getParameter("ANN_NO")); // 생성/수정/확정/상세조회
	String ANN_COUNT 		= JSPUtil.nullToEmpty(request.getParameter("ANN_COUNT")); // 생성/수정/확정/상세조회 
	String view_content 	= JSPUtil.nullToEmpty(request.getParameter("view_content")); //View용 화면인지 확인 flag

	String BID_TYPE 		= JSPUtil.nullToRef(request.getParameter("BID_TYPE"), "D");
	String CTRL_AMT 		= JSPUtil.nullToRef(request.getParameter("CTRL_AMT"), "0"); // 통제금액
	String SCR_FLAG 		= JSPUtil.nullToRef(request.getParameter("SCR_FLAG"), "I"); // 생성/수정/확정/상세조회 flag 
					 
	String HOUSE_CODE 		= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String USER_ID 			= info.getSession("ID");

	String current_date 	= SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time 	= SepoaDate.getShortTimeString();//현재 시스템 시간
	///////////////////////////////

	
	// 웹취약점 진단 조치로 생성이 아니면 공고번호가 없는 경우 표시 안되도록 조치 : 2015.09.24
	if (!"I".equals(SCR_FLAG) && "".equals(ANN_NO)) {
		%>
		<script>
			sessionCloseF("/errorPage/no_autho_en.jsp?flag=e1");
		</script>
		<%
	}
	
	boolean isAdmin = this.isAdmin(info);

	String script 	= "";
	String abled 	= "";
	String script_c = "";
	String abled_c 	= "";
	String isEdit 	= "false";

	if (SCR_FLAG.equals("C") || SCR_FLAG.equals("D")) {
		script 	= "readonly";
		abled 	= "disabled";
		isEdit 	= "true";
	}

	if (SCR_FLAG.equals("C")) { // 확정(공고)일때 변경 가능한 항목 설정
	
		script_c= "";
		abled_c	= "";
	}
	
	String subSubject = "";
	

	///////////////////////////////
	String CONT_TYPE1 						= "";
	String CONT_TYPE2 						= "";
	String ANN_TITLE 						= "";
	String ANN_DATE 						= "";
	String ANN_ITEM 						= subSubject + SUBJECT;
	String RD_DATE 							= "";
	String DELY_PLACE 						= "";
	String LIMIT_CRIT 						= "";
	String PROM_CRIT 						= "";
	String APP_BEGIN_DATE 					= "";
	String APP_BEGIN_TIME 					= "";
	String APP_END_DATE 					= "";
	String APP_END_TIME 					= "";
	String APP_PLACE 						= "";
	String APP_ETC 							= "";
	String ATTACH_NO 						= "";
	String ATTACH_CNT 						= "0";
	String VENDOR_CNT 						= "0";
	String VENDOR_VALUES 					= "";
	String VENDOR_INFO	 					= "";
	String LOCATION_CNT 					= "0";
	String LOCATION_VALUES 					= "";
	String LOC_CODE 						= "";
	String LOC_CNT	 						= "0";
	String ANNOUNCE_DATE 					= "";
	String ANNOUNCE_TIME_FROM	 			= "";
	String ANNOUNCE_TIME_TO 				= "";
	String ANNOUNCE_AREA 					= "";
	String ANNOUNCE_PLACE 					= "";
	String ANNOUNCE_NOTIFIER 				= "";
	String ANNOUNCE_RESP 					= "";
	String DOC_FRW_DATE 					= "";
	String ANNOUNCE_COMMENT 				= "";
	String ANNOUNCE_FLAG 					= "";
	String ANNOUNCE_TEL 					= "";
	String ESTM_FLAG 						= "";
	String COST_STATUS 						= "";
	String BID_BEGIN_DATE 					= "";
	String BID_BEGIN_TIME 					= "";
	String BID_END_DATE 					= "";
	String BID_END_TIME 					= "";
	String BID_PLACE 						= "";
	String BID_ETC 							= "";
	String OPEN_DATE 						= "";
	String OPEN_TIME	 					= "";
	String REPORT_ETC 						= "";
	String X_AUTO_FLAG 						= "";

	String APP_BEGIN_TIME_HOUR_MINUTE 		= "0000";
	String APP_END_TIME_HOUR_MINUTE 		= "0000";
	String BID_BEGIN_TIME_HOUR_MINUTE 		= "0000";
	String BID_END_TIME_HOUR_MINUTE 		= "0000";
	String OPEN_TIME_HOUR_MINUTE 			= "0000";
	String origin_bid_status 				= SCR_FLAG + ANN_STATUS;
	String ESTM_KIND 						= "";
	String ESTM_RATE 						= "";
	String ESTM_MAX 						= "";
	String ESTM_VOTE 						= "";
	String FROM_CONT 						= "";
	String FROM_CONT_TEXT 					= "";
	String FROM_LOWER_BND 					= "";
	String ASUMTN_OPEN_YN 					= "";
	String CONT_TYPE_TEXT 					= "";
	String CONT_PLACE 						= "";
	String BID_PAY_TEXT 					= "";
	String BID_CANCEL_TEXT 					= "";
	String BID_JOIN_TEXT 					= "";
	String REMARK 							= "";
	String ESTM_MAX_VOTE 					= "";
	String STANDARD_POINT 					= "";
	String TECH_DQ				 			= "";
	String AMT_DQ 							= "";
	String BID_EVAL_SCORE 					= ""; 
	String PR_NO 							= "";
	//as-is column 추가
	String LIMIT_CRIT_CD					= "";
	String OPEN_GB         					= "";  	// 개찰구분
	String ITEM_TYPE       					= "";  	// 품목구분 코드
	String COST_SETTLE_TERMS				= "";	// 대금결제조건
	String REJECT_OPINION   				= "";	// 반려의견
	String APPV_STATUS      				= "";	// 문서 결재 상태
	String NEXT_AUTH_ID      				= request.getParameter("NEXT_AUTH_ID");	// 다음결재자
	String GUBUN     	     				= JSPUtil.nullToRef(request.getParameter("GUBUN"), "C");			// 공고문 관리에서는 'C' 나머지는 의미 없음.
	String X_MAKE_SPEC        				= "";
	String X_BASIC_ADD        				= "";
	String X_PURCHASE_QTY     				= "";
	String X_ESTM_CHECK       				= "";
	String X_PERSON_IN_CHARGE 				= "";
	String X_QUALIFICATION					= "";
	String X_RELATIVE_ADD					= "";
	String X_DOC_SUBMIT_TIME_HOUR_MINUTE	= "0000";
	String X_DOC_SUBMIT_DATE				= "";
	String BID_BEGIN_TIME_TEXT				= "00:00";
	String BID_END_TIME_TEXT				= "00:00";
	String OPEN_TIME_TEXT					= "00:00";
	String X_DOC_SUBMIT_TIME_TEXT			= "00:00";
	
	String CONT_TYPE1_TEXT_D				= "";
	String CONT_TYPE2_TEXT_D				= "";
	String CONT_TYPE2_TEXT_O				= "";
	
	String PROM_CRIT_NAME					= "";
	String ITEM_TYPE_TEXT_D					= "";
	String X_ESTM_AMT				    	= "0";
	String CHANGE_USER_NAME_LOC             = "";
	
	String ES_FLAG                          = "";
	String ES_FLAG_TEXT_D                   = "";
	
	String SING_STATUS                      = "";			
	
	
	Map map = new HashMap();
	map.put("ANN_NO"		, ANN_NO);
	map.put("ANN_COUNT"		, ANN_COUNT);

	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "I_BD_020", "CONNECTION","getPrHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]); 

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	
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
					
								
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%> 
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
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
	if("<%=VIEW_KIND%>" != "SUPPLY" && "<%=VENDOR_CNT%>" != "0"){
		document.getElementById("supiFlameDiv").style.display = "block";		
	}else{
		//document.getElementById("vendorTopDiv").style.display = "block";			
	}
	
	<%-- 내부결재 완료건에 한해 ICT센터장 표시 --%>
	if("<%=SING_STATUS%>" == "C"){
		document.getElementById("vendorDiv").style.display = "block";				
	}
	
	setGridDraw();
}

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();

    <%if(!"".equals(VENDOR_VALUES)){%>
		//parent.supiFlame.doSelect("<%=VENDOR_VALUES%>",null,null);
		supiFlame.doSelect("<%=VENDOR_VALUES%>",null,null);
	<%}%>
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
}
 
function doQuery() {
	 
	 
}
function doQueryEnd() {

}

/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
 
function setVisibleVendor() {

}

function delVendorRow(){

}







</script>

<script language="javascript" type="text/javascript">
function fnHtmlDown(){
	
	var print = "";
	var not_print_01 = $("#not_print_td_01").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_02 = $("#not_print_td_02").html();//출력물에는 보여주지 않을 요소 제거
//	var not_print_03 = $("#not_print_td_03").html();//출력물에는 보여주지 않을 요소 제거
//	var not_print_04 = $("#not_print_td_04").html();//출력물에는 보여주지 않을 요소 제거
//	
	$("#not_print_td_01").remove();
	$("#not_print_td_02").remove();
//	$("#not_print_td_03").remove();
//	$("#not_print_td_04").remove();
//	
	print = $("#print_div").html();//출력물에 보여줄 요소 저장
// 	var tmp = $("#btn_td").html();
// 	$("#btn_td").html("");
 	
	Some.document.open("text/html","replace");
 	Some.document.write(print);
//  Some.document.write(document.documentElement.outerHTML) ;
 	
 	$("#not_print_td_01").html(not_print_01);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_02").html(not_print_02);//출력물에는 보여주지 않을 요소를 다시 복구
// 	$("#not_print_td_03").html(not_print_03);//출력물에는 보여주지 않을 요소를 다시 복구
// 	$("#not_print_td_04").html(not_print_04);//출력물에는 보여주지 않을 요소를 다시 복구
// 	$("#btn_td").html(tmp);
 	
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
	
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init();">
<s:header popup="true">
	<!--내용시작-->
<div id="print_div">
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
	<input type="hidden" id="hidCOST_SETTLE_TERMS" name="hidCOST_SETTLE_TERMS" value="">
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
	<input type="hidden" name="sign_status" id="sign_status" value="N">                          
	<!-- 저장,결재를 구분하는 플래그 -->                                        
	<input type="hidden" name="bid_amt" id="bid_amt" value="">                               
	<input type="hidden" name="vendor_values"   id="vendor_values"  value="<%=VENDOR_VALUES%>">       
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



<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="left" class='title_page'>입찰공고</td>
	</tr>
</table>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
<!-- div width="100%" height="250" id="vendorTopDiv" name="vendorTopDiv" style="display:none" -->	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" style="display:none;">
		<tr>
			<td style="font-size:10px; font-family: "verdana", "�뗭�"; color: 717171">
				※ 당행 계약사무지침 제4장에 의거 귀사를 다음의 건에 입찰대상자로 지명하고 입찰관련 사항에
				대하여 통지하오니 적극 참여해주시기 바랍니다.
			</td>
		</tr>
	</table>
<!--  /div -->
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td width="20%" class="title_td" height="15px">1. 공고일자</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<%=SepoaString.getDateSlashFormat(ANN_DATE) %>
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

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td width="20%" class="title_td" height="15px">2. 공고번호</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<%=ANN_NO%>
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

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td width="20%" class="title_td" height="15px">3. 공고명</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<%=ANN_ITEM.replaceAll("\"", "&quot;")%>
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
									<td width="20%" class="title_td" height="15px">4. 입찰구분</td>
									<td width="80%" class="data_td">
										<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
											<tr>
												<td class="data_td">
													<%=ES_FLAG_TEXT_D.replaceAll("\"", "&quot;")%>
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
								<td width="20%" class="title_td" height="15px">5. 입찰 대상품목 및 수량</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<%=X_MAKE_SPEC.replaceAll("\"", "&quot;")%>
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
								<td width="20%" class="title_td" height="15px">6. 입찰방법</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td"><%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %>&nbsp;&nbsp;<%=CONT_TYPE2_TEXT_O%></td>
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
								<td width="20%" class="title_td" height="15px">7. 입찰일시</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
		  										<span id="g5">
													<%=SepoaString.getDateSlashFormat( BID_BEGIN_DATE )%>&nbsp;<%=BID_BEGIN_TIME_TEXT%>&nbsp;(시작일시)
													&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
													<%=SepoaString.getDateSlashFormat( BID_END_DATE ) %>&nbsp;<%=BID_END_TIME_TEXT%>&nbsp;(종료일시)
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
										<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
											<tr>
												<td class="data_td">
													<%=BID_PLACE.replaceAll("\"", "&quot;")%>
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
	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td width="20%" class="title_td" height="15px">4. 서류제출 마감일시</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<%=SepoaString.getDateSlashFormat( X_DOC_SUBMIT_DATE )%>&nbsp;<%=X_DOC_SUBMIT_TIME_HOUR_MINUTE%>
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

<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td width="20%" class="title_td" height="15px">5. 제출서류</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<pre><%=BID_JOIN_TEXT%></pre> 
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
								<td width="20%" class="title_td" height="15px">11. 기타</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<pre><%=BID_ETC%></pre>
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
								<td width="20%" class="title_td" height="20px">12. 첨부서류</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td">
												<pre><%=APP_ETC%></pre>
											</td>
										</tr>
										<tr id="not_print_td_01">
											<td class="data_td">
												<br>
												<script language="javascript">
													btn("","파일첨부")
												</script>
											</td>
										</tr>
							    		<tr id="not_print_td_02">
							    			<td class="data_td">
												<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
												<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width:450px; height: 50px; border: 0px;" frameborder="0" ></iframe>
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
								<td width="20%" class="title_td" height="20px">12. 구매담당자</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td class="data_td"><%=CHANGE_USER_NAME_LOC%></td>
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
<div width="100%" height="250" id="vendorDiv" name="vendorDiv" style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
	<tr>
		<td style="font-size:20px; font-weight:bold; text-align:right;">우리은행 IT지원센터장</td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
</div>
</div>
<%-- 인쇄, 내PC에저장, 닫기 버튼 --%>
<table height="10" width="99%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td align="right" id="btn_td">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="btnTable">
				<tr>
					<td height="10">&nbsp;</td>
			      	<td height="10" align="right">
						<table>
							<tr align="right">
								<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:window.print()"></td>
								<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:fnHtmlDown()"></td>
								<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>			
		</td>
	</tr>
</table>

<div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv" style="display:none">
	<iframe src="<%=POASRM_CONTEXT_NAME%>/ict/sourcing/rfq_req_sellersel_bottom_vi_ict.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
</div>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;display:none"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html> 