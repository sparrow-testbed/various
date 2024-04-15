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
	String SUBJECT			= JSPUtil.nullToRef(request.getParameter("T_SUBJECT"), "");	
	String pr_type 			= JSPUtil.nullToEmpty(request.getParameter("PR_TYPE"));
	String req_type 		= JSPUtil.nullToEmpty(request.getParameter("REQ_TYPE"));  
	String BID_STATUS 		= JSPUtil.nullToEmpty(request.getParameter("BID_STATUS")); 
	String BID_NO 			= JSPUtil.nullToEmpty(request.getParameter("BID_NO"));
	String BID_COUNT 		= JSPUtil.nullToEmpty(request.getParameter("BID_COUNT")); // 생성/수정/확정/상세조회 
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
	if (!"I".equals(SCR_FLAG) && "".equals(BID_NO)) {
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
	if(!"".equals(MapUtils.getString(hashMap, "BID_NO" ,""))){
		hashMap.put("HOUSE_CODE", HOUSE_CODE);
		Object[] prObj = {hashMap};
		SepoaOut prValue = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPreBdCancelCheck", prObj);
		
		if("".equals(prValue.result[0])){
			subSubject = "";
			if("UR".equals(BID_STATUS)){
				subSubject = "[정정공고]";
			}
		}else{
			subSubject = "[정정공고]";
		}
	}
	if(SUBJECT.indexOf(subSubject) != -1){
		subSubject = "";
	}

	///////////////////////////////
	String CONT_TYPE1 						= "";
	String CONT_TYPE2 						= "";
	String ANN_TITLE 						= "";
	String ANN_NO 							= "";
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
	String origin_bid_status 				= SCR_FLAG + BID_STATUS;
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
	String PROM_CRIT_NAME					= "";
	String ITEM_TYPE_TEXT_D					= "";
	String X_ESTM_AMT				    	= "0";
	String CNST_BATCH_GB_TEXT               = "";
	String RPT_GETFILENAMES                 = "";
	String LIMIT_CRIT_TEXT                  = "";

	String [][] aAuthList   = new String[100][2];	// 결재자 목록을 미리 선언(100,2)
	
	// 배열 초기화
	for (int i = 0; i < 100 ; i++)
	{
		aAuthList[i][0] = "";
		aAuthList[i][1] = "";
	}	
	
	SepoaFormater wf2 = null;
	
	if(!SCR_FLAG.equals("V") ){
		
		if(!"".equals(BID_NO)){
			Map map = new HashMap();
			map.put("BID_NO"		, BID_NO);
			map.put("BID_COUNT"		, BID_COUNT);

			Object[] obj = {map};
			SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPrHeaderDetail", obj);
			
			SepoaFormater wf = new SepoaFormater(value.result[0]);
			wf2 = new SepoaFormater(value.result[1]);
			

			//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
			
		    if(wf.getRowCount() > 0) {

				if (!(origin_bid_status).equals("IAR")) { // 입찰공고 작성을 하려는 경우외에는 기존에 data를 조회해 온다.
					CONT_TYPE1 						= wf.getValue("CONT_TYPE1"				, 0);
					CONT_TYPE1_TEXT_D				= wf.getValue("CONT_TYPE1_TEXT_D"		, 0);
					CONT_TYPE2 						= wf.getValue("CONT_TYPE2"				, 0);
					CONT_TYPE2_TEXT_D				= wf.getValue("CONT_TYPE2_TEXT_D"		, 0);
					ANN_TITLE 						= wf.getValue("ANN_TITLE"				, 0);
					ANN_NO 							= wf.getValue("ANN_NO"					, 0);
					ANN_DATE 						= wf.getValue("ANN_DATE"				, 0);
					if(wf.getValue("ANN_ITEM", 0).indexOf(subSubject) != -1){
						subSubject = "";
					}
					ANN_ITEM 						= subSubject + wf.getValue("ANN_ITEM"	, 0);
					RD_DATE 						= wf.getValue("RD_DATE"					, 0);
					DELY_PLACE 						= wf.getValue("DELY_PLACE"				, 0);
					LIMIT_CRIT 						= wf.getValue("LIMIT_CRIT"				, 0);
					PROM_CRIT 						= wf.getValue("PROM_CRIT"				, 0);
					PROM_CRIT_NAME					= wf.getValue("PROM_CRIT_NAME"			, 0);
					APP_BEGIN_DATE 					= wf.getValue("APP_BEGIN_DATE"			, 0);
					APP_BEGIN_TIME 					= wf.getValue("APP_BEGIN_TIME"			, 0);
					APP_END_DATE 					= wf.getValue("APP_END_DATE"			, 0);
					APP_END_TIME 					= wf.getValue("APP_END_TIME"			, 0);
					APP_PLACE 						= wf.getValue("APP_PLACE"				, 0);
					APP_ETC 						= wf.getValue("APP_ETC"					, 0);
					ATTACH_NO 						= wf.getValue("ATTACH_NO"				, 0);
					ATTACH_CNT 						= wf.getValue("ATTACH_CNT"				, 0);
					VENDOR_CNT 						= wf.getValue("VENDOR_CNT"				, 0);
					LOCATION_CNT 					= wf.getValue("LOCATION_CNT"			, 0);
					VENDOR_VALUES 					= wf.getValue("VENDOR_VALUES"			, 0);
					LOCATION_VALUES 				= wf.getValue("LOCATION_VALUES"			, 0);
					LOC_CODE 						= wf.getValue("LOC_CODE"				, 0);
					LOC_CNT 						= wf.getValue("LOC_CNT"					, 0);
					ANNOUNCE_DATE 					= wf.getValue("ANNOUNCE_DATE"			, 0);
					ANNOUNCE_TIME_FROM 				= wf.getValue("ANNOUNCE_TIME_FROM"		, 0);
					ANNOUNCE_TIME_TO 				= wf.getValue("ANNOUNCE_TIME_TO"		, 0);
					ANNOUNCE_AREA 					= wf.getValue("ANNOUNCE_AREA"			, 0);
					ANNOUNCE_PLACE 					= wf.getValue("ANNOUNCE_PLACE"			, 0);
					ANNOUNCE_NOTIFIER 				= wf.getValue("ANNOUNCE_NOTIFIER"		, 0);
					ANNOUNCE_RESP 					= wf.getValue("ANNOUNCE_RESP"			, 0);
					DOC_FRW_DATE 					= wf.getValue("DOC_FRW_DATE"			, 0);
					ANNOUNCE_COMMENT 				= wf.getValue("ANNOUNCE_COMMENT"		, 0);
					ANNOUNCE_FLAG 					= wf.getValue("ANNOUNCE_FLAG"			, 0);
					ANNOUNCE_TEL 					= wf.getValue("ANNOUNCE_TEL"			, 0);
					BID_STATUS 						= wf.getValue("BID_STATUS"				, 0);
					ESTM_FLAG 						= wf.getValue("ESTM_FLAG"				, 0);
					COST_STATUS 					= wf.getValue("COST_STATUS"				, 0);
					BID_BEGIN_DATE 					= wf.getValue("BID_BEGIN_DATE"			, 0);
					BID_BEGIN_TIME 					= wf.getValue("BID_BEGIN_TIME"			, 0);
					BID_END_DATE 					= wf.getValue("BID_END_DATE"			, 0);
					BID_END_TIME 					= wf.getValue("BID_END_TIME"			, 0);
					BID_PLACE 						= wf.getValue("BID_PLACE"				, 0);
					BID_ETC 						= wf.getValue("BID_ETC"					, 0);
					OPEN_DATE 						= wf.getValue("OPEN_DATE"				, 0);
					OPEN_TIME 						= wf.getValue("OPEN_TIME"				, 0);
					APP_BEGIN_TIME_HOUR_MINUTE 		= wf.getValue("APP_BEGIN_TIME_HOUR"		, 0) + wf.getValue("APP_BEGIN_TIME_MINUTE"	, 0);
					APP_END_TIME_HOUR_MINUTE 		= wf.getValue("APP_END_TIME_HOUR"		, 0) + wf.getValue("APP_END_TIME_MINUTE"	, 0);
					BID_BEGIN_TIME_HOUR_MINUTE 		= wf.getValue("BID_BEGIN_TIME_HOUR"		, 0) + wf.getValue("BID_BEGIN_TIME_MINUTE"	, 0);
					BID_END_TIME_HOUR_MINUTE 		= wf.getValue("BID_END_TIME_HOUR"		, 0) + wf.getValue("BID_END_TIME_MINUTE"	, 0);
					OPEN_TIME_HOUR_MINUTE 			= wf.getValue("OPEN_TIME_HOUR"			, 0) + wf.getValue("OPEN_TIME_MINUTE"		, 0);
					PR_NO 							= wf.getValue("PR_NO"					, 0);
					BID_TYPE 						= wf.getValue("BID_TYPE"				, 0);
					ESTM_KIND 						= wf.getValue("ESTM_KIND"				, 0);
					ESTM_RATE 						= wf.getValue("ESTM_RATE"				, 0);
					ESTM_MAX 						= wf.getValue("ESTM_MAX"				, 0);
					ESTM_VOTE 						= wf.getValue("ESTM_VOTE"				, 0);
					FROM_CONT 						= wf.getValue("FROM_CONT"				, 0);
					FROM_CONT_TEXT 					= wf.getValue("FROM_CONT_TEXT"			, 0);
					FROM_LOWER_BND 					= wf.getValue("FROM_LOWER_BND"			, 0);
					ASUMTN_OPEN_YN 					= wf.getValue("ASUMTN_OPEN_YN"			, 0);
					CONT_TYPE_TEXT 					= wf.getValue("CONT_TYPE_TEXT"			, 0);
					CONT_PLACE 						= wf.getValue("CONT_PLACE"				, 0);
					BID_PAY_TEXT 					= wf.getValue("BID_PAY_TEXT"			, 0);
					BID_CANCEL_TEXT 				= wf.getValue("BID_CANCEL_TEXT"			, 0);
					BID_JOIN_TEXT 					= wf.getValue("BID_JOIN_TEXT"			, 0);
					REMARK 							= wf.getValue("REMARK"					, 0);
					ESTM_MAX_VOTE 					= wf.getValue("ESTM_MAX_VOTE"			, 0);
					STANDARD_POINT 					= wf.getValue("STANDARD_POINT"			, 0);
					TECH_DQ 						= wf.getValue("TECH_DQ"					, 0);
					AMT_DQ 							= wf.getValue("AMT_DQ"					, 0);
					BID_EVAL_SCORE 					= wf.getValue("BID_EVAL_SCORE"			, 0);
					REPORT_ETC 						= wf.getValue("REPORT_ETC"				, 0);
					LIMIT_CRIT_CD		            = wf.getValue("LIMIT_CRIT_CD"			, 0);
					OPEN_GB         	            = wf.getValue("OPEN_GB"					, 0);
					ITEM_TYPE       	            = wf.getValue("ITEM_TYPE"				, 0);
					COST_SETTLE_TERMS	            = wf.getValue("COST_SETTLE_TERMS"		, 0);
					REJECT_OPINION   	            = wf.getValue("REJECT_OPINION"			, 0);
					APPV_STATUS      	            = wf.getValue("APPV_STATUS"				, 0);
					X_MAKE_SPEC        	            = wf.getValue("X_MAKE_SPEC"				, 0);
					X_BASIC_ADD        	            = wf.getValue("X_BASIC_ADD"				, 0);
					X_PURCHASE_QTY     	            = wf.getValue("X_PURCHASE_QTY"			, 0);
					X_ESTM_CHECK       	            = wf.getValue("X_ESTM_CHECK"			, 0);
					X_PERSON_IN_CHARGE 	            = wf.getValue("X_PERSON_IN_CHARGE"		, 0);
					X_QUALIFICATION		            = wf.getValue("X_QUALIFICATION"			, 0);
					X_RELATIVE_ADD		            = wf.getValue("X_RELATIVE_ADD"			, 0);
					X_DOC_SUBMIT_DATE	            = wf.getValue("X_DOC_SUBMIT_DATE"		, 0);
					OPEN_TIME_HOUR_MINUTE 			= wf.getValue("OPEN_TIME_HOUR"			, 0) + wf.getValue("OPEN_TIME_MINUTE"			, 0);
					X_DOC_SUBMIT_TIME_HOUR_MINUTE	= wf.getValue("X_DOC_SUBMIT_TIME_HOUR"	, 0) + wf.getValue("X_DOC_SUBMIT_TIME_MINUTE"	, 0);
					X_AUTO_FLAG						= wf.getValue("X_AUTO_FLAG"				, 0);
					BID_BEGIN_TIME_TEXT				= wf.getValue("BID_BEGIN_TIME_HOUR"		, 0) + ":" + wf.getValue("BID_BEGIN_TIME_MINUTE"	, 0);
					BID_END_TIME_TEXT				= wf.getValue("BID_END_TIME_HOUR"		, 0) + ":" + wf.getValue("BID_END_TIME_MINUTE"	    , 0);
					OPEN_TIME_TEXT	    			= wf.getValue("OPEN_TIME_HOUR"			, 0) + ":" + wf.getValue("OPEN_TIME_MINUTE"			, 0);
					X_DOC_SUBMIT_TIME_TEXT			= wf.getValue("X_DOC_SUBMIT_TIME_HOUR"	, 0) + ":" + wf.getValue("X_DOC_SUBMIT_TIME_MINUTE"	, 0);
					ITEM_TYPE_TEXT_D       	        = wf.getValue("ITEM_TYPE_TEXT_D"		, 0);
					CNST_BATCH_GB_TEXT              = wf.getValue("CNST_BATCH_GB_TEXT"		, 0);
					try{
						X_ESTM_AMT =  SepoaMath.SepoaNumberType(wf.getValue("X_ESTM_AMT", 0), "#,###,###,###,###,###,###") ;	
					}catch (Exception e) {
						X_ESTM_AMT =  "0";
					}
					
					RPT_GETFILENAMES                 = wf.getValue("RPT_GETFILENAMES"		, 0);
					LIMIT_CRIT_TEXT                  = wf.getValue("LIMIT_CRIT_TEXT"		, 0);
				}
			}
		}
	}

	if (origin_bid_status.equals("IUR")) // 정정공고 작성 대상건일 경우에는 BID_STATUS = 'UR' 로 확정한다.
		BID_STATUS = "UR";
	
	// 대금결제조건을 선택하여 저장하는 것으로 변경
	// 장재영 차장 SR 요청(2007-12-31)
	String[] aRadioTitles = new String[3];
	String[] aRadioValues = new String[3];
	aRadioTitles[0]="납품 기일내 물품을 당행이 지정하는 장소에 납품 완료후 인수증<b>(검수조서)</b>을<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 첨부하여 대금 청구하면 당행에서 납품 확인 완료후 20일이내 <b>현금 결제함</b>";
	aRadioTitles[1]="납품 기일내 물품을 당행이 지정하는 장소에 납품 완료후 인수증<b>(검수조서)</b>을<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 첨부하여 대금 청구하면 당행에서 납품 확인 완료후 20일이내<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b>물품구매 전용카드(업종별수수료)로 결제함</b>";
	aRadioTitles[2]="우리에프아이에스 대금 지급 방법에 따름";
	aRadioValues[0]="납품 기일내 물품을 당행이 지정하는 장소에 납품 완료후 인수증<b>(검수조서)</b>을 첨부하여 대금 청구하면 당행에서 납품 확인 완료후 20일이내 <b>현금 결제함</b>";
	aRadioValues[1]="납품 기일내 물품을 당행이 지정하는 장소에 납품 완료후 인수증<b>(검수조서)</b>을 첨부하여 대금 청구하면 당행에서 납품 확인 완료후 20일이내 <b>물품구매 전용카드(업종별수수료)로 결제함</b>";
	aRadioValues[2]="우리에프아이에스 대금 지급 방법에 따름";	
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName = (BID_TYPE.equals("D"))?"020644/rpt_bd_ann_d_004_d":"020644/rpt_bd_ann_d_004_c";         //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

	if(!SCR_FLAG.equals("V") ){		
		if(!"".equals(BID_NO)){
			
			//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
			if ( BID_TYPE.equals("D")) {
				//_rptData.append("구매입찰공고 표준(안)");
				//_rptData.append(_RF);
				_rptData.append(SepoaString.getDateSlashFormat(ANN_DATE));
				_rptData.append(_RF);
				_rptData.append(ANN_NO);
				_rptData.append(_RF);
				//_rptData.append(ANN_ITEM);
				_rptData.append(ANN_ITEM);				
				_rptData.append(_RF);
				_rptData.append(SepoaMath.SepoaNumberType(X_PURCHASE_QTY, "###,###,###,###,###,###"));
				_rptData.append(_RF);
				_rptData.append(X_MAKE_SPEC);
				_rptData.append(_RF);
				_rptData.append(X_BASIC_ADD);
				_rptData.append(_RF);
				if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {
					_rptData.append(X_ESTM_AMT);
					_rptData.append(" 원");
				}else{
					_rptData.append("비공개");
				}
				_rptData.append(_RF);
				if(!ANNOUNCE_DATE.equals("")){
					_rptData.append("1.일시 ");
					_rptData.append(SepoaString.getDateSlashFormat(ANNOUNCE_DATE));
					_rptData.append(" ");
					_rptData.append(SepoaString.getTimeColonFormat(ANNOUNCE_TIME_FROM));
					_rptData.append(" ~ ");
					_rptData.append(SepoaString.getTimeColonFormat(ANNOUNCE_TIME_TO));
					_rptData.append("<BR>2.장소");
					_rptData.append(ANNOUNCE_PLACE);
				}else{
					_rptData.append("없음");		
				}
				_rptData.append(_RF);
				_rptData.append(LIMIT_CRIT);
				_rptData.append(_RF);
				_rptData.append(SepoaString.getDateSlashFormat( X_DOC_SUBMIT_DATE ));
				_rptData.append(" ");
				_rptData.append(X_DOC_SUBMIT_TIME_TEXT);
				_rptData.append(" 까지");
				_rptData.append(_RF);
				_rptData.append(CONT_PLACE);
				_rptData.append(_RF);
				_rptData.append(BID_JOIN_TEXT.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));
				_rptData.append(_RF);
				_rptData.append(BID_CANCEL_TEXT);
				_rptData.append(_RF);	
				_rptData.append(CONT_TYPE1_TEXT_D);
				_rptData.append(" / ");
				_rptData.append(CONT_TYPE2_TEXT_D);
				_rptData.append(" / ");
				_rptData.append(PROM_CRIT_NAME);		
				if("B".equals(PROM_CRIT)){
					_rptData.append("<BR>제한적최저율 : ");
					if("".equals(FROM_LOWER_BND)){
						_rptData.append("85 %");
					}else{
						_rptData.append(FROM_LOWER_BND);
						_rptData.append(" %");
				   }
				} 
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( BID_BEGIN_DATE ));
				_rptData.append(" ");
				_rptData.append(BID_BEGIN_TIME_TEXT);
				_rptData.append(" ~ ");
				_rptData.append(SepoaString.getDateSlashFormat( BID_END_DATE ));
				_rptData.append(" ");
				_rptData.append(BID_END_TIME_TEXT);
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( OPEN_DATE ));
				_rptData.append(" ");
				_rptData.append(OPEN_TIME_TEXT);
				_rptData.append(" 이후");
				_rptData.append(_RF);	
				_rptData.append(X_RELATIVE_ADD.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( BID_BEGIN_DATE ));
				_rptData.append(_RF);	
				_rptData.append(ANN_ITEM);
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( RD_DATE ));
				_rptData.append(_RF);	
				_rptData.append(DELY_PLACE);
				_rptData.append(_RF);	
				_rptData.append(SepoaMath.SepoaNumberType(X_PURCHASE_QTY, "###,###,###,###,###,###"));
				_rptData.append(_RF);
				for (int i = 0 ; i < aRadioValues.length ; i++) { 
					if( ( COST_SETTLE_TERMS == null || "".equals(COST_SETTLE_TERMS) ) && i == 0 ) {				
						_rptData.append(aRadioTitles[i].replaceAll("<b>", "<B>").replaceAll("</b>", "</B>"));
				   }
				}		
				_rptData.append(_RF);	
				_rptData.append(BID_ETC.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));
				_rptData.append(_RF);	
				_rptData.append(ITEM_TYPE_TEXT_D);
				_rptData.append(_RF);
				_rptData.append(RPT_GETFILENAMES);
			
			}else{			
				
				//_rptData.append("공사입찰공고 표준(안)");
				//_rptData.append(_RF);
				_rptData.append(SepoaString.getDateSlashFormat(ANN_DATE));
				_rptData.append(_RF);
				_rptData.append(ANN_NO);
				_rptData.append(_RF);
				
				_rptData.append(ANN_ITEM);
				_rptData.append(_RF);
				_rptData.append(X_PERSON_IN_CHARGE);
				_rptData.append(_RF);
				
				if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))){
					_rptData.append(X_ESTM_AMT);
					_rptData.append(" 원");			
				} else {
					_rptData.append("비공개");			
				}
				_rptData.append(_RF);
				if(!ANNOUNCE_DATE.equals("")){
					_rptData.append("1.일시 ");
					_rptData.append(SepoaString.getDateSlashFormat(ANNOUNCE_DATE));
					_rptData.append(" ");
					_rptData.append(SepoaString.getTimeColonFormat(ANNOUNCE_TIME_FROM));
					_rptData.append(" ~ ");
					_rptData.append(SepoaString.getTimeColonFormat(ANNOUNCE_TIME_TO));
					_rptData.append(" ");
					_rptData.append("<BR>2.장소 ");
					_rptData.append(ANNOUNCE_PLACE);			
				}else{
					_rptData.append("없음");
				}		
				_rptData.append(_RF);
				_rptData.append(LIMIT_CRIT_TEXT);
				_rptData.append(_RF);
				_rptData.append(X_QUALIFICATION);
				_rptData.append(_RF);
				_rptData.append(SepoaString.getDateSlashFormat( X_DOC_SUBMIT_DATE ));
				_rptData.append(" ");
				_rptData.append(X_DOC_SUBMIT_TIME_TEXT);
				_rptData.append(" 까지");
				_rptData.append(_RF);
				_rptData.append(CONT_PLACE);
				_rptData.append(_RF);
				_rptData.append(BID_JOIN_TEXT.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));
				_rptData.append(_RF);
				_rptData.append(BID_CANCEL_TEXT);
				_rptData.append(_RF);	
				_rptData.append(CONT_TYPE1_TEXT_D);
				_rptData.append(" / ");
				_rptData.append(CONT_TYPE2_TEXT_D);
				_rptData.append(" / ");
				_rptData.append(PROM_CRIT_NAME);		
				if("B".equals(PROM_CRIT)){
					_rptData.append("<BR>제한적최저율 : ");
					if("".equals(FROM_LOWER_BND)){
						_rptData.append("85 %");
					}else{
						_rptData.append(FROM_LOWER_BND);
						_rptData.append(" %");
				   }
				} 
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( BID_BEGIN_DATE ));
				_rptData.append(" ");
				_rptData.append(BID_BEGIN_TIME_TEXT);
				_rptData.append(" ~ ");
				_rptData.append(SepoaString.getDateSlashFormat( BID_END_DATE ));
				_rptData.append(" ");
				_rptData.append(BID_END_TIME_TEXT);
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( OPEN_DATE ));
				_rptData.append(" ");
				_rptData.append(OPEN_TIME_TEXT);
				_rptData.append(" 이후");
				_rptData.append(_RF);	
				_rptData.append(X_RELATIVE_ADD.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));
				_rptData.append(_RF);	
				_rptData.append(SepoaString.getDateSlashFormat( BID_BEGIN_DATE ));
				_rptData.append(_RF);	
				_rptData.append(ANN_ITEM);
				_rptData.append(_RF);	
				_rptData.append(COST_SETTLE_TERMS);	
				_rptData.append(_RF);	
				_rptData.append(BID_ETC.replaceAll("\n", "<BR>").replaceAll("\u0020", " "));	
				_rptData.append(_RF);	
				_rptData.append(ITEM_TYPE_TEXT_D);	
				_rptData.append(_RF);
				_rptData.append(RPT_GETFILENAMES);		
				_rptData.append(_RF);
				_rptData.append(CNST_BATCH_GB_TEXT);	
			}
			
			_rptData.append(_RD);			
			if(!"S".equals(info.getSession("USER_TYPE"))){
				//SepoaFormater wf2 = new SepoaFormater(value.result[1]);				
				for(int j=0; j<wf2.getRowCount(); j++) {
					_rptData.append(wf2.getValue(j,0));
					_rptData.append(_RF);
					_rptData.append(wf2.getValue(j,1));
					_rptData.append(_RF);
					_rptData.append(wf2.getValue(j,3));
					_rptData.append(_RF);
					_rptData.append(wf2.getValue(j,4));
					_rptData.append(_RF);
					_rptData.append(wf2.getValue(j,5));
					_rptData.append(_RL);			
			    }
			}
			
			Map map3 = new HashMap();
			map3.put("bid_no"		, BID_NO);
			map3.put("bid_count"		, BID_COUNT);
			Object[] obj3 = {map3};
			SepoaOut value3 = ServiceConnector.doService(info, "BD_002", "CONNECTION","getBdItemDetail", obj3);	
			SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
			_rptData.append(_RD);
			for(int j=0; j<wf3.getRowCount(); j++) {
				_rptData.append(wf3.getValue("PR_NO",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("ITEM_NO",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("DESCRIPTION_LOC",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("SPECIFICATION",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("UNIT_MEASURE",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("QTY",j));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("CUR",j));
				_rptData.append(_RF);
				if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {
					_rptData.append(wf3.getValue("UNIT_PRICE",j));
				}
				_rptData.append(_RF);
				if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {
					_rptData.append(wf3.getValue("AMT",j));
				}
				_rptData.append(_RF);
				if(!"S".equals(info.getSession("USER_TYPE")) ){
					_rptData.append(wf3.getValue("SELLER_SELECTED_CNT",j));
				}
				_rptData.append(_RL);
		    }
			//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
		}
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
	//생성시 디폴트값 세팅
	<%if(!isAdmin || "D".equals(SCR_FLAG)){%>$("#comp_td").hide();<%}%>
	
	setGridDraw();

	<%if("S".equals(info.getSession("USER_TYPE")) ){%>
	$("#supiFlameDiv").hide();
	<%}%>
	
	<% if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {%>
		GridObj.setColumnHidden(GridObj.getColIndexById("UNIT_PRICE"), false);
		GridObj.setColumnHidden(GridObj.getColIndexById("AMT"), false);
	<% } else { %>
		GridObj.setColumnHidden(GridObj.getColIndexById("UNIT_PRICE"), true);
		GridObj.setColumnHidden(GridObj.getColIndexById("AMT"), true);
	<% } %>
}

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();
    
    <%if("S".equals(info.getSession("USER_TYPE")) ){%>
    GridObj.setColumnHidden(GridObj.getColIndexById("SELLER_SELECTED_CNT"), true);
	<%}%>
    
	doQuery();
	setVisibleVendor(); // 업체지정
}
 
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{

	var header_name = GridObj.getColumnId(cellInd);
	
	if(header_name == "ITEM_NO") {
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	} else if(header_name == "PR_NO" ) {
		
		var prNo   = SepoaGridGetCellValueId( GridObj, rowId, "PR_NO" );
		var prType = SepoaGridGetCellValueId( GridObj, rowId, "PR_TYPE" );
		var prNoPopuFlag = SepoaGridGetCellValueId( GridObj, rowId, "PR_NO_POPUP_FLAG" );
		
		var page   = null;
		
		if(prNoPopuFlag == "Y") {
			
			page = "/kr/dt/pr/pr1_bd_dis1I.jsp";//pr1_bd_dis1I.jsp
			
			window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
			
		}
		
	}
	
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
        alert(messsage);
    } else {
        alert(messsage);
    } 
    return false;
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

    var qty = 0;
    var sum_amt = 0;
    var view_content = "<%=view_content %>";
	for(var i= dhtmlx_start_row_id; i< dhtmlx_end_row_id; i++) {
		GridObj.enableSmartRendering(true);
    	GridObj.selectRowById(GridObj.getRowId(i), false, true);
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");	
    	
    	qty += Number(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("QTY")).getValue());
    	var amt = GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("AMT")).getValue();
    	
    	sum_amt = Number(sum_amt) + Number(amt);
	}	
	
	if(view_content == "Y") {
		document.form.SUM_AMT.value = Comma(sum_amt);
	}
	
	if($.trim($("#X_PURCHASE_QTY").val()) == ""){
		$("#X_PURCHASE_QTY").val(qty);
	}
	
	if( GridObj.getRowsNum() > 0 ) {

		var	SELLER_SELECTED = LRTrim(GridObj.cells(1, GridObj.getColIndexById("SELLER_SELECTED")).getValue());
		var SELLER = SELLER_SELECTED.split("#");
		var seller_codes = "";
		for (var i = 0 ; i < SELLER.length ; i++){
			seller_codes += SELLER[i].split("@")[0] + "@";
		}
		
		$("#supiFlame").attr("src", "<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp?rfq_no=<%=BID_NO%>&rfq_count=<%=BID_COUNT%>&seller_codes="+seller_codes);
    }
	
	setVisiblePeriod(); // 
	setVisibleESTM(); // 단일예가/복수예가
	avengerkim();
    return true;
}

/**
 * 일반경쟁, 지명경쟁에 따른 업체지정
 */
 
function setVisibleVendor() {
	var CONT_TYPE1 = document.forms[0].CONT_TYPE1.value; // 입찰방법
	
	if("" == CONT_TYPE1){
		CONT_TYPE1 = "NC";
	}
	
	if ( CONT_TYPE1 == "NC" ) { // 지명경쟁
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).hide();
		}
		for(n=1;n<=4;n++) { // 업체지정
			$('#h' + n).show();
		}	
		document.forms[0].LOC_CNT.value = "0";
	}
	else if ( CONT_TYPE1 == "LC" ) { // 지역공개경쟁
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).show();
		}
		for(n=1;n<=4;n++) { // 업체지정
			$('#h' + n).hide();
		}
		document.forms[0].vendor_values.value = "";
		document.forms[0].seller_cnt.value = "0";
		delVendorRow();
	}
	else { // 일반경쟁
		document.forms[0].vendor_values.value = "";
		document.forms[0].vendor_count.value = "0";
		//$('#h1').hide();
		for(m=1;m<=4;m++) { // 지역지정
			$('#h1' + m).hide();
		}
		for(n=1;n<=4;n++) { // 업체지정
			$('#h' + n).hide();
		}		
		document.forms[0].LOC_CNT.value = "0";
		delVendorRow();
	}
}

function delVendorRow(){
	$("#seller_cnt").val("0");
	$("#supiFlame").attr("src", "<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp");
}

// 대금결제조건을 선택했을때..
function fnCostSettleTerms(strFlag)
{
	var strVal;
	if (strFlag == "0")
	{
		strVal = "<%=aRadioValues[0]%>";
	}
	else if (strFlag =="1")
	{
		strVal = "<%=aRadioValues[1]%>";
	}
	else if (strFlag = "2")
	{
		strVal = "<%=aRadioValues[2]%>";
	}
	document.form.hidCOST_SETTLE_TERMS.value = strVal;
	//alert(document.form1.hidCOST_SETTLE_TERMS.value);
}

/**
 * 입찰방법(총액, 2단계경쟁, 수의계약)
 */
function setVisiblePeriod() {
	var CONT_TYPE2 = document.forms[0].CONT_TYPE2.value;
	
	if ( CONT_TYPE2 == "LP" ) { // 총액입찰
		
		$("#bidTitle").show();
		$("#openTitle").show();
		$("#scoreTitle").hide();		
		
		for(n=1;n<=22;n++) {
			$("#g"+n).show();
		}
		for(m=1;m<=13;m++) {
			$("#i"+m).hide();
		}
		for(x=1;x<=12;x++) {
			$("#q"+x).show();
		}
		$("#contDiv1").hide();
		$("#scoreTItle").hide();
	} 
	else { // 2단계 및 협상에 의한 계약
		$("#scoreTitle").show();
		$("#bidTitle").hide();
		$("#openTitle").hide();
		for(n=1;n<=22;n++) {
			$("#g"+n).hide();
			$("#contDiv1").hide();
		}
		for(m=1;m<=13;m++) {
			$("#i"+m).show();
			$("#contDiv1").show();
		}
		for(x=1;x<=6;x++) {
			$("#q"+x).show();
			$("#contDiv1").show();
		}
		if (( CONT_TYPE2 == "TE" ) || ( CONT_TYPE2 == "NE" )){ // 2단계 및 협상에 의한 계약
			for(x=1;x<=12;x++) { // 기준점수(1~6), 점수비율(7~12)
				$("#q"+x).show();
			}
		}else{
			for(x=1;x<=12;x++) {
				$("#q"+x).hide();
			}
		}
		$("#contDiv1").show();
	}
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
function avengerkim() {
	f = document.forms[0];
	f.FROM_LOWER_BND.value='0';
	var from_lower_bnd = '<%=FROM_LOWER_BND%>';
	
	if( from_lower_bnd == '' ) from_lower_bnd = '85';
		
	if(f.PROM_CRIT.value=='A' || f.PROM_CRIT.value=='D'){
		$("#q1").hide();
		$("#contDiv1").hide();
	 	$("#contDiv2").hide();
		$("#X_AUTO_FLAG").val("Y");
	}else if (f.PROM_CRIT.value=='B') { //낙찰하한가이면
		$("#q1").show();
		$("#contDiv1").hide();
		$("#contDiv2").show();
		$("#X_AUTO_FLAG").val("Y");
		f.FROM_LOWER_BND.value=from_lower_bnd;
		f.FROM_LOWER_BND.readOnly = '';
	}else if (f.PROM_CRIT.value=='C'){
		$("#q1").show();
		$("#contDiv1").show();
		$("#contDiv2").hide();
		$("#X_AUTO_FLAG").val("N");
		f.FROM_LOWER_BND.readOnly = '';
	}
		
	if($.trim($("#PROM_CRIT").val()) == 'C' && $.trim($("#X_AUTO_FLAG").val()) == 'Y'){
		alert("종합평가일 경우에는 수동개찰만 가능합니다.");
		$("#X_AUTO_FLAG").val("N");
		return;
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

</script>

<script language="javascript" type="text/javascript">
function fnHtmlDown(){
	
	var print = "";
	var not_print_01 = $("#not_print_td_01").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_02 = $("#not_print_td_02").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_03 = $("#not_print_td_03").html();//출력물에는 보여주지 않을 요소 제거
	var not_print_04 = $("#not_print_td_04").html();//출력물에는 보여주지 않을 요소 제거
	
	$("#not_print_td_01").remove();
	$("#not_print_td_02").remove();
	$("#not_print_td_03").remove();
	$("#not_print_td_04").remove();
	
	print = $("#print_div").html();//출력물에 보여줄 요소 저장
// 	var tmp = $("#btn_td").html();
// 	$("#btn_td").html("");
 	
	Some.document.open("text/html","replace");
 	Some.document.write(print);
//  Some.document.write(document.documentElement.outerHTML) ;
 	
 	$("#not_print_td_01").html(not_print_01);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_02").html(not_print_02);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_03").html(not_print_03);//출력물에는 보여주지 않을 요소를 다시 복구
 	$("#not_print_td_04").html(not_print_04);//출력물에는 보여주지 않을 요소를 다시 복구
// 	$("#btn_td").html(tmp);
 	
	Some.document.close() ;
	Some.focus() ;
	Some.document.execCommand('SaveAs',false,'저장될 파일명');
	
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
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
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" onload="init();">
<s:header popup="true">
	<!--내용시작-->
<div id="print_div">
<form id="form" name="form">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">	
	<%--ClipReport4 hidden 태그 끝--%>
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
	<input type="hidden" name="BID_STATUS" id="BID_STATUS" value="<%=BID_STATUS%>"/>
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
	<input type="hidden" name="bid_no" 	  			id="bid_no" 	        value="<%=BID_NO%>">                     
	<input type="hidden" name="bid_count" 	  		id="bid_count" 	 		value="<%=BID_COUNT%>">              
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
<% if(!"Y".equals(view_content)) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class='title_page'>입찰공고 상세
	</td>
</tr>
</table>
<%} %>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<% if ( BID_TYPE.equals("D")) { %>구매입찰공고 표준(안) <% } else { %>공사입찰공고 표준(안) <%}%>
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
								<td width="20%" class="title_td" height="15px">1. 공고일자 및 번호</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>	
											<td  width="20%" height="15px" class="title_td">
												<span>가. 공고일자</span>
											</td>
											<td width="80%" class="data_td">
												<%=SepoaString.getDateSlashFormat(ANN_DATE) %>
											</td>
										</tr>
										<tr>	
											<td  width="20%" height="15px" class="title_td">
												<span>나. 공고번호</span>
											</td>
											<td width="80%" class="data_td">
												<%=ANN_NO%>
											</td>
										</tr>
										<tr style="display: none;"><!-- 777 -->
											<td  width="20%" height="15px" class="title_td">
												<span>다. 자동개찰여부</span>
											</td>
											<td width="80%" class="data_td">
												<select id="X_AUTO_FLAG" name="X_AUTO_FLAG" <%=abled%>>
													<option value="Y" <%if("Y".equals(X_AUTO_FLAG)){ %> selected <%} %> >자동</option>
													<option value="N" <%if("N".equals(X_AUTO_FLAG)){ %> selected <%} %> >수동</option>
												</select>
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
	
<% if(BID_TYPE.equals("D")) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">	
							<tr>
								<td  width="20%" class="title_td">2. 입찰에 부치는 사항</td>
								<td  width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td  width="20%" class="title_td">
												<span>가. 입찰건명</span>
											</td>
											<td width="80%" class="data_td">
												<%=ANN_ITEM.replaceAll("\"", "&quot;")%>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>나. 구매수량</span>
											</td>
											<td width="80%" class="data_td">
												<%=SepoaMath.SepoaNumberType(X_PURCHASE_QTY, "###,###,###,###,###,###") %>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>다. 제조사양</span>
											</td>
											<td width="80%" class="data_td">
												<%=X_MAKE_SPEC%>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>라. 유의사항</span>
											</td>
											<td width="80%" class="data_td">
												<%=X_BASIC_ADD%>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>마. 예정가격</span>
											</td>
											<td width="80%" class="data_td">
												<SPAN CLASS=".general_padding_left"><% if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {%><%=X_ESTM_AMT%> 원<%} else {%>비공개<%}%></SPAN>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>바. 현장설명회</span>
											</td>
											<td width="80%" class="data_td">
											    <% if(!ANNOUNCE_DATE.equals("")){ %>
												<SPAN CLASS=".general_padding_left">1.일시&nbsp;:&nbsp;<%=SepoaString.getDateSlashFormat(ANNOUNCE_DATE)%>&nbsp;&nbsp;<%=SepoaString.getTimeColonFormat(ANNOUNCE_TIME_FROM)%>&nbsp;~&nbsp;<%=SepoaString.getTimeColonFormat(ANNOUNCE_TIME_TO)%><br>2.장소&nbsp;:&nbsp;<%=ANNOUNCE_PLACE%></SPAN>
												<%}else{ %>
												<SPAN CLASS=".general_padding_left">없음</SPAN>												
												<%} %>																																		
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
<% } else {%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td  width="20%" class="title_td">2. 입찰에 부치는 사항</td>
								<td  width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td  width="20%" class="title_td">
												<span>가. 입찰건명</span>
											</td>
											<td width="80%" class="data_td">
												<%=ANN_ITEM.replaceAll("\"", "&quot;")%>
											</td>
										</tr>
										<tr>	
											<td width="20%" class="title_td">
												<span>나. 담당기술역</span>
											</td>
											<td width="80%" class="data_td">
												<%=X_PERSON_IN_CHARGE%>
											</td>
										</tr>							
										<tr>
											<td width="20%" class="title_td">
												<span>다. 예정가격</span>
											</td>
											<td width="80%" class="data_td">
												<SPAN CLASS=".general_padding_left"><% if (X_ESTM_CHECK.equals("Y") || !"S".equals(info.getSession("USER_TYPE"))) {%><%=X_ESTM_AMT%> 원<%} else {%>비공개<%}%></SPAN>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>라. 현장설명회</span>
											</td>
											<td width="80%" class="data_td">
											    <% if(!ANNOUNCE_DATE.equals("")){ %>
												<SPAN CLASS=".general_padding_left">1.일시&nbsp;:&nbsp;<%=SepoaString.getDateSlashFormat(ANNOUNCE_DATE)%>&nbsp;&nbsp;<%=SepoaString.getTimeColonFormat(ANNOUNCE_TIME_FROM)%>&nbsp;~&nbsp;<%=SepoaString.getTimeColonFormat(ANNOUNCE_TIME_TO)%><br>2.장소&nbsp;:&nbsp;<%=ANNOUNCE_PLACE%></SPAN>
												<%}else{ %>
												<SPAN CLASS=".general_padding_left">없음</SPAN>												
												<%} %>																																		
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
<% } %>		
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td  width="20%" class="title_td">3. 입찰참가자격</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
										<%
										if(BID_TYPE.equals("D")) {
										//구매입찰
										%>
										<tr>
											<td width="20%" class="title_td">
												<span>참가자격</span>
											</td>
											<td width="80%" class="data_td">
												<%=LIMIT_CRIT%>
											</td>
										</tr>
										<%
										} else {
										%>
										<tr>
											<td width="20%" class="title_td">
												<span>가. 참가자격</span>
											</td>
											<td width="80%" class="data_td" id="LIMIT_CRIT_TD">
												<select id="LIMIT_CRIT" name="LIMIT_CRIT" class="input_re_2" <%=script%> onKeyUp="return chkMaxByte(1000, this, '참가자격');">
													<%
													String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M948", LIMIT_CRIT);
													out.println(com1);
													%>
												</select>
												<script language="javascript">
													$("#LIMIT_CRIT_TD").html($("#LIMIT_CRIT option:selected").text());
												</script>
											</td>
										</tr>
										<tr>
											<td width="20%" class="title_td">
												<span>나. 기타</span>
											</td>
											<td width="80%" class="data_td">
												<%=X_QUALIFICATION%>
											</td>
										</tr>									
										<%
										}
										%>
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
		  						<td  width="20%" class="title_td">4. 제출서류 목록 및<br> 제출기일</td>
		  						<td  width="80%">
		  							<table  width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  								<tr>
		  									<td width="20%" class="title_td">
		  										<span>가. 제출기한</span>
		  									</td>
		  									<td width="80%" class="data_td">
												<%=SepoaString.getDateSlashFormat( X_DOC_SUBMIT_DATE ) %>&nbsp;<%=X_DOC_SUBMIT_TIME_TEXT%> 까지		  				
											</td>
										</tr>
										<tr>
		  									<td  width="20%" class="title_td">
		  										<span>나. 제출방법</span>
		  									</td>
		  									<td width="80%" class="data_td">
												<%=CONT_PLACE%>
											</td>
										</tr>
										<tr>
		  									<td  width="20%" class="title_td">
		  										<span>다. 제출서류</span>
		  									</td>
		  									<td width="80%" class="data_td">
												<%=BID_JOIN_TEXT.replaceAll("\n", "</br>").replaceAll("\u0020", "&nbsp;")%>
											</td>
										</tr>
										<tr>
		  									<td  width="20%" class="title_td">
		  										<span>라. 유의사항</span>
		  									</td>
		  									<td width="80%" class="data_td">
												<%=BID_CANCEL_TEXT%>
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
		  						<td  width="20%" class="title_td">5. 입찰관련사항</td>
		  						<td  width="80%">
		  							<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  								<tr>
		  									<td width="20%" class="title_td">
		  										<span>가. 입찰방법</span>
		  									</td>
		  									<td width="60%" class="data_td" colspan="3">
							  					<table>
							  						<tr>
							  							<td style="display: none;">
									  						<b>
										  						<span class="general_padding_left">
																	<select id="CONT_TYPE1" name="CONT_TYPE1" class="inputsubmit"onChange="setVisibleVendor()" <%=abled%>>
																		<%
																			String com1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M974", CONT_TYPE1);
																			out.println(com1);
																		%>								
																	</select>&nbsp;
																	<select id="CONT_TYPE2" name="CONT_TYPE2" class="inputsubmit" onChange="setVisiblePeriod()" <%=abled%>>
																		<%
																			String com2 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M973", CONT_TYPE2);
																			out.println(com2);
																		%>								
																	</select>&nbsp;
																	<select name="PROM_CRIT" id="PROM_CRIT" class="inputsubmit" onChange="avengerkim()" <%=abled%>>
																		<%
																			String com5 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M930", PROM_CRIT);
																			out.println(com5);
																		%>								
																	</select>
																	<input type="hidden" name="FROM_CONT_TEXT" id="FROM_CONT_TEXT" value="<%=FROM_CONT_TEXT%>">
																	<input type="hidden" name="FROM_CONT" id="FROM_CONT" value="<%=FROM_CONT%>">	
																</span>
									  						</b>	
							  							</td>
														<td width="40%" class="data_td" id="comp_td" style="display: none;">
									 						<span class="general_padding_left" id="h1">업체지정
																<a href="javascript:vendor_Select()" id=h2><img src="../../images/button/butt_query.gif" align="absmiddle" border="0"   id=h3 ></a>
																<input type="text" id="vendor_count" name="vendor_count" size="3" value="<%=VENDOR_CNT%>" style='border-style: none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly  id=h4>
									 						</span>
															<span id="h11" style="display:none; ">지역지정 
																<a href="javascript:getLocList()" id=h12><img src="../../images/button/butt_query.gif" align="absmiddle"   border="0" id=h13 ></a>
																<input type="text" id="LOC_CNT" name="LOC_CNT" size="3" value="<%=LOC_CNT%>" style='border-style:  none 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px' readonly  id=h14>
															</span>
						 								</td>	
							  							<td id="CONT_TYPE_TD"><%=CONT_TYPE1_TEXT_D%>&nbsp;/&nbsp;<%=CONT_TYPE2_TEXT_D%>&nbsp;/&nbsp;<%=PROM_CRIT_NAME %></td> 
							  							<%-- 
														<script language="javascript">
															var CONT_TYPE1_GET_TEXT = $("#CONT_TYPE1 option:selected").text();
															var CONT_TYPE2_GET_TEXT = $("#CONT_TYPE2 option:selected").text();
															var PROM_CRIT_GET_TEXT  = $("#PROM_CRIT option:selected").text();
															$("#CONT_TYPE_TD").html(CONT_TYPE1_GET_TEXT + " / " + CONT_TYPE2_GET_TEXT + " / " + PROM_CRIT_GET_TEXT);
														</script>
														--%>
							  						</tr>
							  					</table>
						 					</td>
										</tr>
										<tr id="q1">
		  									<td id="q2" width="20%" class="title_td">
		  										<span id="scoreTitle" >나. 점수비율</span>
		  									</td>						
											<td id="q4" colspan="3" class="data_td">
												<span id="contDiv1">
													점수비율 [ 기술제안서
													<span>
														<%=TECH_DQ%>% : 가격 
														<%=AMT_DQ%>%]&nbsp;&nbsp;&nbsp;&nbsp;
														기준점수
														<%=STANDARD_POINT%>
													</span>
												</span>
												<span id="contDiv2">
													&nbsp;&nbsp;제한적최저율
													<b>
														<input type="hidden" name="FROM_LOWER_BND" id="FROM_LOWER_BND" size="3" maxlength="2" value="<%=FROM_LOWER_BND%>" <%=script%> style="ime-mode:disabled" onKeyPress="checkNumberFormat('[0-9]', this);" <%=script%> >
														<%=FROM_LOWER_BND%>%
													</b>
												</span>								
											</td>
										</tr>	
										<tr id="i11">
											<td class="title_td" width="15%" id="i12"> <span id="i1">다. 평가서제출일시</span></td>
											<td class="data_td" width="35%" colspan="3"    id="i13">
												<span id="i5">
													<%=SepoaString.getDateSlashFormat( APP_BEGIN_DATE ) %>
													<span id="i6">&nbsp;<%=APP_BEGIN_TIME_HOUR_MINUTE%></span>
													&nbsp;&nbsp;~&nbsp;&nbsp;
													<%=SepoaString.getDateSlashFormat( APP_END_DATE ) %>
													<span id="i6">&nbsp;<%=APP_END_TIME_HOUR_MINUTE%></span>
												</span>
											</td>
										</tr>					
										<tr id="bidTitle">
		  									<td width="20%" class="title_td">
		  										<span>나. 입찰일시</span>
		  									</td>
		  									<td width="80%" colspan="2" class="data_td">
		  										<span id="g5">
													<%=SepoaString.getDateSlashFormat( BID_BEGIN_DATE )%>&nbsp;<%=BID_BEGIN_TIME_TEXT%>
													&nbsp;&nbsp;~&nbsp;&nbsp;
													<%=SepoaString.getDateSlashFormat( BID_END_DATE ) %>&nbsp;<%=BID_END_TIME_TEXT%>
												</span>
		  									</td>
										</tr>
										<tr id="openTitle">
		  									<td width="20%" class="title_td">
		  										<span>다. 개찰일시</span>
		  									</td>
		  									<td width="80%" colspan="2" class="data_td">
		  										<span id="g18">
													<%=SepoaString.getDateSlashFormat( OPEN_DATE ) %>&nbsp;<%=OPEN_TIME_TEXT%> 이후
												</span>
		  									</td>
										</tr>
										<tr>
		  									<td width="20%" class="title_td">
		  										<span>라. 낙찰방법</span>
		  									</td>
		  									<td width="80%" colspan="2" class="data_td">						
												<div>
													<!--[R200711270859]전자입찰시스템 화면 수정 요청-->
													<!--유차 를 유찰로 변경 -->
													(1) 입찰금액이 우리은행 내정가격 초과시 유찰로 간주하고 재입찰을 실시할 수 있음<br>
												    (2) 낙찰이 될 수 있는 동일가격으로 입찰한 자가 2인 이상일 때에는 즉시 추첨에 의하여 낙찰자를 결정함<br>
													<b><font color="red">※ 단, 전자입찰인 경우 전산시스템에 의해 자동(램덤)으로 낙찰자 결정</font></b>
												</div>
											</td>
										</tr>
										<tr>
		  									<td width="20%" class="title_td">
		  										<span>마. 유의사항</span>
		  									</td>
		  									<td width="80%" colspan="2" class="data_td">						
												<%=X_RELATIVE_ADD.replaceAll("\"", "&quot;").replaceAll("\n", "</br>").replaceAll("\u0020", "&nbsp;")%>
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
<%
	String pre01 = "";
	pre01 =   "<pre>\n"
			+ "(1) 입찰금액의 100분의 5이상 금액을 현금(체신관서 또는 은행법의 적용을 받는 \n"
			+ "    금융기관이 발행한 자기앞수표를 포함) \n"
			+ "    또는 다음 각 호의 보증서 등으로 우리은행에 납부하여야 함\n"
			+ "    (가) 금융기관이 발행한 지급보증서\n"
			+ "    (나) 증권업법시행령 제 84조의 16호에 규정된 유가증권\n"
			+ "    (다) 보험업법에 의한 보험사업자가 발행한 보증보험증권\n"
			+ "    (라) 금융기관 및 외국금융기관과 체신관서가 발행한 정기예금증서\n"
			+ "    (마) 건설공제조합법에 의한 건설공제조합, 전문건설공제조합법에 의한\n"
			+ "         전문건설공제조합·업종별공제조합, 신용보증기금법에 의한 신용보증\n"
			+ "         기금, 신기술사업금융지원에관한 법률에 의한 기술신용보증기금,\n"
			+ "         전기통신공사업에 의한 전기통신공제조합, 엔지니어링기술진흥법에\n"
			+ "         의한 엔진니어링공제조합 또는 공업발전법에 의한 공제사업단체,\n"
			+ "         소프트웨어개발촉진법에 의하여 정보통신부장관이 공고한 공제사업\n"
			+ "         기관, 전력기술관리법에 의한 한국전력기술인협회 또는 환경친화적\n"
			+ "         산업구조로의 전환촉진에 관한법률에 의하여 환경설비에 대하여\n"
			+ "         한국기계공업진흥회가 발행한 채무액 등의 지급을 보증하는 보증서\n"
			+ "(2) 입찰등록마감시한까지 입찰보증금을 납부한 업체만 본 입찰에 참여 가능함.\n"
			+ "(3) 입찰이행보증서 보증기간은 입찰일 이전부터 입찰일 30일 이후일 것.\n"
			+ "(4) 보증내용\n"
			+ "    (가) 피보험자: (주)우리은행\n"
			+ "    (나) 입찰일자: "+SepoaString.getDateSlashFormat( BID_BEGIN_DATE )+"\n"
			+ "    (다) 입찰건명: "+ANN_ITEM.replaceAll("\"", "&quot;")+"<br>\n"
			+ "(5) 입찰보증금 귀속: 낙찰자가 소정기일 내에 계약을 체결하지 아니할 경우\n"
			+ "    입찰보증금은 당행에 귀속 됨\n"
			+ "</pre>\n";
%>	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
			  					<td  width="20%" class="title_td">6. 입찰이행보증금</td>
			  					<td width="80%">
		  							<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  								<tr>
		  									<td width="20%" class="title_td">
		  										<span> 내용</span>
		  									</td>
		  									<td width="80%" class="data_td">
		  										<%=pre01%>
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
<%
	String pre02 = "";
	pre02 =   "<pre>\n"
			+ "낙찰자는 다음 각호의 경우에 해당하는 경우 현금 또는 보증서 등으로 차액보증금을 \n"
			+ "납부하여야 함\n"
			+ "(1) 입찰결과 당행 내정가격의 100분의 85미만으로 낙찰된 경우\n"
			+ "    (가) 현금으로 납부하고자 하는 경우에는 내정가격과 낙찰금액의 차액\n"
			+ "    (나) 보증서 등으로 납부하고자 하는 경우에는 내정가격과 낙찰금액의\n"
			+ "      차액에 상당하는 금액<br>\n"
			+ "(2) 입찰결과 당행 내정가격의 100분의 70미만으로 낙찰된 경우\n"
			+ "    - 내정가격과 낙찰금액의 차액을 현금 또는 차액의 2배에 해당하는 \n"
			+ "      보증서 등으로 납부하여야 함\n"
			+ "</pre>\n";
%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
			  					<td  width="20%" class="title_td">7. 차액보증금</td>
			  					<td width="80%">
		  							<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  								<tr>
		  									<td width="20%" class="title_td">
		  										<span> 내용</span>
		  									</td>
		  									<td width="80%" class="data_td">
		  										<%=pre02%>
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
<%
	String pre03 = "";
	pre03 =   "<pre>\n"
			+ " (1) 입찰결과 낙찰자는 계약체결시 계약금액의 100 분의 10 이상 금액을\n"
			+ "     현금 (체신관서 또는 은행법의 적용을 받는 금융기관이 발행하는 자기앞\n"
			+ "     수표를 포함) 또는 다음 각호의 보증서등으로 우리은행에 \n"
			+ "     납부함 (단, 공사계약에 있어서 연대 보증인이 없는 경우 100분의 20)\n"
			+ "     (가) 금융기관이 발행한 지급보증서\n"
			+ "     (나) 증권업법시행령 제84조의 16호에 규정된 유가증권\n"
			+ "     (다) 보험업법에 의한 보험사업자가 발행한 보증보험증권\n"
			+ "     (라) 금융기관 및 외국금융기관과 체신관서가 발행한 정기예금증서\n"
			+ "     (마) 건설공제조합법에 의한 건설공제조합, 전문건설공제조합법에 의한\n" 
			+ "          전문건설공제조합·업종별공제조합, 신용보증기금법에 의한 신용보증\n"
			+ "          기금, 신기술사업금융지원에관한 법률에 의한 기술신용보증기금,\n"
			+ "          전기통신공사업에 의한 전기통신공제조합, 엔지니어링기술진흥법에\n"
			+ "          의한 엔진니어링공제조합 또는 공업발전법에 의한 공제사업단체,\n"
			+ "          소프트웨어개발촉진법에 의하여 정보통신부장관이 공고한 공제사업\n"
			+ "          기관, 전력기술관리법에 의한 한국전력기술인협회 또는 환경친화적\n"
			+ "          산업구조로의 전환촉진에 관한법률에 의하여 환경설비에 대하여\n"
			+ "          한국기계공업진흥회가 발행한 채무액 등의 지급을 보증하는 보증서\n"
			+ "  \n"
			+ " (2) 계약상대자가 계약상의 의무를 이행하지 아니할 경우 계약이행\n"
			+ "     보증금은 당행에 귀속됨<br>\n"
			+ " (3) 계약이행기간은 계약기간에 60일 이상을 가산한 기간이어야 함\n"
			+ "</pre>\n";
%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
			  					<td  width="20%" class="title_td">8. 계약이행보증금</td>
			  					<td width="80%">
		  							<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
		  								<tr>
		  									<td width="20%" class="title_td">
		  										<span> 내용</span>
		  									</td>
		  									<td width="80%" class="data_td">
		  										<%=pre03%>
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
<%if (BID_TYPE.equals("D")) {%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
					  			<td  width="20%" class="title_td">9. 계약관련사항</td>
				  				<td width="80%">
			  						<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			  							<tr>
			  								<td width="20%" class="title_td">
			  									<span>가. 납품완료일자(납품기간)</span>  			
			  								</td>
			  								<td width="80%" class="data_td">
  												<%=SepoaString.getDateSlashFormat( RD_DATE )%>
											</td>
										</tr>
										<tr>
			  								<td width="20%" class="title_td">
			  									<span>나. 납품장소</span>
			  								</td>
			  								<td width="80%" class="data_td">
												<%=DELY_PLACE.replaceAll("\"", "&quot;")%>
											</td>
										</tr>
										<tr>
			  								<td width="20%" class="title_td">
			  									<span>다. 구매수량</span>
			  								</td>
			  								<td width="80%" class="data_td">
			  									<%=SepoaMath.SepoaNumberType(X_PURCHASE_QTY, "###,###,###,###,###,###") %>
												<%-- <span class="general_padding_left">자동셋팅</span> --%>
											</td>
										</tr>
										<tr>
			  								<td width="20%" class="title_td">
			  									<span>라. 대금결제조건</span>
			  								</td>
			  								<td width="80%" class="data_td">
												<% 
													for (int i = 0 ; i < aRadioValues.length ; i++) { 
														if( ( COST_SETTLE_TERMS == null || "".equals(COST_SETTLE_TERMS) ) && i == 0 ) { 
												%>
												<input type="radio" style="border: 0px;" id="COST_SETTLE_TERMS_<%=i %>" name="COST_SETTLE_TERMS" value="<%=i%>" checked onclick="javascript:fnCostSettleTerms(<%=i%>);" disabled="disabled"> <%=aRadioTitles[i]%>
												<br>
												<%
														} else {
												%>
												<input type="radio" style="border: 0px;" id="COST_SETTLE_TERMS_<%=i %>" name="COST_SETTLE_TERMS" value="<%=i%>" <%if ( COST_SETTLE_TERMS.equals(aRadioValues[i]) ) {%>checked<%}%> onclick="javascript:fnCostSettleTerms(<%=i%>);" disabled="disabled"> <%=aRadioTitles[i]%>
												<br>
												<%
														}
													}
												%>
											</td>
										</tr>
										<%
											String pre04 = "";
											pre04 =   "<pre>"
											+ "납품 기1일내 물품을 당행이 지정하는 장소에 납품하지 못하였을 때 \n"
											+ "지연일수 매 일마다 미납품대금의 1,000분의 1.5에 해당하는 지체상금을 \n"
											+ "당행에 납부하여야 함"
											+ "<pre>";
										%>
										<tr>
			  								<td width="20%" class="title_td">
			  									<span>마. 지체상금</span>
			  								</td>
			  								<td width="80%" class="data_td"><%=pre04%></td>
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
					    		<td  width="20%" class="title_td">10. 기타사항</td>
				  				<td width="80%">
			  						<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			  							<tr>
			  								<td width="20%" class="title_td">
			  									<span>가. 내용</span>
			  								</td>
				  							<td width="80%" class="data_td">
					  							<%=BID_ETC.replaceAll("\n", "</br>").replaceAll("\u0020", "&nbsp;")%>
					  						</td>
							    		</tr>
							    		<tr>
				  							<td width="20%" class="title_td">
				  								<span>나. 품목구분</span>
				  							</td>
				  							<td width="80%" class="data_td" id="ITEM_TYPE_TD">
				  								<%=ITEM_TYPE_TEXT_D%>
				  								<%-- 
					  							<select id="ITEM_TYPE" name="ITEM_TYPE" class="input_re" <%=abled%>>
													<option value=""></option>
													<%
														String com3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M550", ITEM_TYPE);
									    				out.println(com3);
													%>
												</select>
												--%>
					  						</td>
					  						<%-- 
	  										<script language="javascript">
												$("#ITEM_TYPE_TD").html($("#ITEM_TYPE option:selected").text());
											</script>
											--%>
							    		</tr>
							    		<tr>
				  							<td width="20%" class="title_td" id="not_print_td_01">
				  								<span>다. 파일첨부</span>
				  							</td>
				  							<td width="80%" class="data_td" id="not_print_td_02">
												<TABLE width="100%">
													<TR>
														<td>
															<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
														</td>
														<td>
															<table width="100%">
																<tr height="10">
																	<td></td>
																</tr>
																<tr>
																	<td>
																		<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 95px; border: 0px;" frameborder="0" ></iframe>
																	</td>
																</tr>
															</table>
														</td>
														<td width="170">
															<div id="attach_no_text"></div>
														</td>
													</TR>
												</TABLE>
					  						</td>
							    		</tr>
							    		<tr style="display:none;">
							    			<td width="20%" class="title_td">
							  					<span>다. 개찰구분</span>
							  				</td>
							  				<td width="80%">
								  				<select id="OPEN_GB" name="OPEN_GB" class="input_re" <%=abled%>>
													<%
														String com4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M152", OPEN_GB);
										    			out.println(com4);
													%>
												</select>
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
<%} else {%>
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
				  				<td  width="20%" class="title_td">9. 계약관련사항</td>
				  				<td width="80%">
			  						<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
			  							<tr>
			  								<td width="20%" class="title_td">
			  									<span> 대금지급방법</span>
			  								</td>
			  								<td width="80%" class="data_td">
			  									<%=COST_SETTLE_TERMS.replaceAll("\"", "&quot;")%>
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
								<td  width="20%" class="title_td">10. 기타사항</td>
								<td width="80%">
									<table width="100%" border="0" cellspacing="1" cellpadding="0" style="border-collapse: collapse">
										<tr>
											<td width="20%" class="title_td">
												<span>가. 내용</span>
											</td>
											<td width="80%" class="data_td">
												<%=BID_ETC.replaceAll("\n", "</br>").replaceAll("\u0020", "&nbsp;")%>
											</td>
										</tr>
										<tr>
					  						<td width="20%" class="title_td">
					  							<span>나. 품목구분</span>
					  						</td>
					  						<td width="80%" class="data_td" id="ITEM_TYPE_TD">
					  							<%=ITEM_TYPE_TEXT_D%>
					  							<%-- 
						  						<select id="ITEM_TYPE" name="ITEM_TYPE" class="input_re" <%=abled%>>
													<option value="0"></option>
													<%
														String com3 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M551", ITEM_TYPE);
								    					out.println(com3);
													%>
												</select>
												--%>
						  					</td>
						  					<%-- 
  											<script language="javascript">
												$("#ITEM_TYPE_TD").html($("#ITEM_TYPE option:selected").text());
											</script>
											--%>
										</tr>
										<tr>
						  					<td width="20%" class="title_td" id="not_print_td_03">
						  						<span>다. 파일첨부</span>
						  					</td>						
			  								<td width="80%" class="data_td" id="not_print_td_04">
												<TABLE width="100%">
													<TR>
														<td>
															<input type="hidden" name="attach_no" id="attach_no" value="<%=ATTACH_NO%>">
														</td>
														<td>
															<table width="100%">
																<tr height="10">
																	<td></td>
																</tr>
																<tr>
																	<td>
																		<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 95px; border: 0px;" frameborder="0" ></iframe>
																	</td>
																</tr>
															</table>
														</td>
														<td width="170">
															<div id="attach_no_text"></div>
														</td>
													</TR>
												</TABLE>
				  							</td>						
										</tr>
										<tr  style="display:none;">
											<td width="20%" class="title_td">
					  							<span>다. 개찰구분</span>
					  						</td>
					  						<td width="80%">
						  						<select id="OPEN_GB" name="OPEN_GB" class="input_re" <%=abled%>>
													<%
														String com4 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#" +"M552", OPEN_GB);
								    					out.println(com4);
													%>
												</select>
						  					</td>
										</tr>  	  				
										<tr>
											<td  width="20%" class="title_td">
					  							<span>라. 공사/배치구분</span>
					  						</td>
			  								<td width="80%" class="data_td">
			  									<%=CNST_BATCH_GB_TEXT%>
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
<%}%>	
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
				<tr>
					<td width="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr style="display: none;">
								<td  width="50%" class="title_td" colspan="2">
									<span    id="e1">예비가격범위
										<input type="text" id="ESTM_RATE" name="ESTM_RATE" size="3" maxlength="2" value="<%=ESTM_RATE%>" <%=script%>  id=e2>
										%&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<span id="e3">사용예비/추첨수
										
										<input type="hidden" id="ESTM_MAX_VOTE" name="ESTM_MAX_VOTE" >
										<!-- 2006-10-18 ESTM_MAX , ESTM_VOTE이 ESTM_MAX_VOTE으로 통합되었다. ESTM_MAX , ESTM_VOTE는 안씀
										 2006-10-19 원복된다.
										-->
										<input type="text" id="ESTM_MAX" name="ESTM_MAX" size="3" maxlength="2" value="<%=ESTM_MAX%>" onblur="check_ESTM_MAX()"   <%=script%>   id=e4>
										<input type="text" id="ESTM_VOTE" name="ESTM_VOTE" size="2" maxlength="1" value="<%=ESTM_VOTE%>" onblur="check_ESTM_VOTE()"    <%=script%>  id=e5>
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
<br>
<%if("Y".equals(view_content)) {%>
<table border="0" width="40%">
	<tr>
		<td width="20%">
			<input type="text" id="SUM_AMT_NAME" name="SUM_AMT_NAME"  value="예상금액합계 :" size="12"  style="font-size: 12px;border: 0px;font: bold;text-align: left;">
		</td>
		<td width="80%">
			\<input type="text" id="SUM_AMT" name="SUM_AMT" size="20" style="font-size:12px; font:bold; border:0px;">
		</td>
	</tr>
</table>
<%}%>

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
								<td><script language="javascript">btn("javascript:clipPrint()", "출 력")</script></td> 
								<td><script language="javascript">btn("javascript:window.close()", "닫 기")</script></td>
<!-- 							<td><input type="button" style="height: 20px;" value="인 쇄" 		onclick="javascript:clipPrint()"></td>
								<td><input type="button" style="height: 20px;" value="내PC에저장" 	onclick="javascript:fnHtmlDown()"></td>
								<td><input type="button" style="height: 20px;" value="닫 기" 		onclick="javascript:window.close()"></td> -->
							</tr>
						</table>
					</td>
				</tr>
			</table>			
		</td>
	</tr>
</table>

<div width="100%" height="250" id="supiFlameDiv" name="supiFlameDiv">
	<iframe src="<%=POASRM_CONTEXT_NAME%>/sourcing/rfq_req_sellersel_botton_vi.jsp" name="supiFlame" id="supiFlame" width="100%" height="170px" border="0" scrolling="no" frameborder="0"></iframe>
</div>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
<iframe id="Some" src="/sourcing/empty.htm"  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html> 