<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%> 
<%@ taglib prefix="s" uri="/sepoa"%>
 
<%
// WO_203 = 집기류
// WO_204 = 인쇄물
// WO_205 = 간판류
// WO_206 = 사무기기
// WO_207 = 용도품
// WO_208 = 시설동산
// WO_209 = 공사
// WO_210 = 통장류
// WO_211 = 카드류
// WO_212 = 금융IC카드 


    String to_day    = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date   = to_day;
	
	String gubun     = JSPUtil.nullToEmpty(request.getParameter("gubun"));
	String ev_year   = JSPUtil.nullToEmpty(request.getParameter("ev_year")); 
	String sg_kind   = JSPUtil.nullToEmpty(request.getParameter("sg_kind")); 
	String sg_kind_1 = JSPUtil.nullToEmpty(request.getParameter("sg_kind_1")); 
	String sg_kind_2 = JSPUtil.nullToEmpty(request.getParameter("sg_kind_2")); 
	
	
	// 집기류
	String S_ID      = "WO_203"; 
	// 인쇄물
	if( gubun.equals("4") ){
		S_ID = "WO_204";
	}
	// 간판류
	else if( gubun.equals("6") ){
		S_ID = "WO_205";
	}
	// 사무기기
	else if( gubun.equals("21") ){
		S_ID = "WO_206";
	}	
	// 용도품
	else if( gubun.equals("34") ){
		S_ID = "WO_207";
	}
	// 시설동산
	else if( gubun.equals("8") ){
		S_ID = "WO_208";
	}
	// 공사
	else if( gubun.equals("62") ){
		S_ID = "WO_209";
	}
	// 통장류
	else if( gubun.equals("242") ){
		S_ID = "WO_210";
	}
	// 카드류
	else if( gubun.equals("243") ){
		S_ID = "WO_211";
	}
	// 금융IC카드
	else if( gubun.equals("262") ){
		S_ID = "WO_212";
	}			
	
	
	
	
	if( ev_year.equals("") ) ev_year = ""+SepoaDate.getYear();
	if( sg_kind.equals("") ) {
		sg_kind   = "1";
		sg_kind_1 = "2";
		sg_kind_2 = "2";
	}

	Vector multilang_id = new Vector();
	multilang_id.addElement(S_ID);
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text    = MessageUtil.getMessage(info,multilang_id);

	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = S_ID;
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;

	// 집기류	
	if( gubun.equals("") || gubun.equals("2") ){ 
		
// 		System.out.println("======================================");
		
		isRowsMergeable = true;

//   		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");

		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE1=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=기술능력(30점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("15SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("STORAGE=#cspan@창고보유");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@기업체");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("AS=품질관리(5점)@사후관리");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("4SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
		gubun = "2";
	}
	// 인쇄물
 	else if( gubun.equals("4") ){ 
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");

		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE1=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=기술능력(30점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("8SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN1=#cspan@시설보유");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN2=#cspan@조합가입여부");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
				
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@기업체");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN3=품질관리(5점)@품질관리");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("4SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE1=#cspan@#cspan");
	}	
	// 간판류
 	else if( gubun.equals("6") ){ 
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");
		
		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE1=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=기술능력(30점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("8SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN1=#cspan@소유(차량)기구");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN2=#cspan@기술보유");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
				
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@기업체");
		dhtmlx_head_merge_cols_vec.addElement("8SCORE1=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN3=품질관리(5점)@품질관리");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("AS=#cspan@사후관리");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE1=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("4SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE2=#cspan@#cspan");
	}
	// 사무기기
 	else if( gubun.equals("21") ){ 
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");
		
		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=회사규모(10점)@자산규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=#cspan@사업년수");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(9점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE2=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR1=기술능력(13점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_SIZE=#cspan@기술보유");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE3=#cspan@#cspan");
				
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=이행실적(28점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=#cspan@금융권");
		dhtmlx_head_merge_cols_vec.addElement("18SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=품질관리(20점)@A/S조직");
		dhtmlx_head_merge_cols_vec.addElement("20SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("4SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY6=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE1=#cspan@#cspan");
	}		
	// 용도품
	else if( gubun.equals("34") ){
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");
		
		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("8SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=기술능력(25점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("15SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GOOD=#cspan@생산시설");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan@#cspan");	
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(25점)@기업체");
		dhtmlx_head_merge_cols_vec.addElement("25SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("4SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
		
	}
	// 시설동산
	else if( gubun.equals("8") ){
		isRowsMergeable = true;
		
		dhtmlx_head_merge_cols_vec.addElement("BUSI_YEAR=기술능력(45)");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan");	
		dhtmlx_head_merge_cols_vec.addElement("SPECIAL=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("SKILL=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("AS20=#cspan");
	
		dhtmlx_head_merge_cols_vec.addElement("CADE=당행기여도(20)");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YERSOSIN=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan");				
		dhtmlx_head_merge_cols_vec.addElement("RAR=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("15SCORE=#cspan");	
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE4=#cspan");
		
	}
	// 공사
	else if( gubun.equals("62") ){
		isRowsMergeable = true;
		
		dhtmlx_head_merge_cols_vec.addElement("TEXT4=당행기여도(20)");
		dhtmlx_head_merge_cols_vec.addElement("SCORE7=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("TEXT5=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("SCORE8=#cspan");				
		dhtmlx_head_merge_cols_vec.addElement("TEXT6=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("SCORE9=#cspan");	
		dhtmlx_head_merge_cols_vec.addElement("TEXT7=#cspan");
		dhtmlx_head_merge_cols_vec.addElement("SCORE10=#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("SCORE11=감점");
	}
	// 통장류
	else if( gubun.equals("242") ){
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");	

		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR1=기술능력(25점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("8SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN=#cspan@시설보유");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN1=#cspan@조합가입여부");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");		
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE5=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@금융권");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN2=품질평가(10점)@품질관리");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("AS=#cspan@사후관리");		
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");

		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE6=#cspan@#cspan");		
	}	
	// 카드류
	else if( gubun.equals("243") ){
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");	

		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(15점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR1=기술능력(25점)@공장등록");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=#cspan@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN=#cspan@시설보유");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN1=#cspan@조합가입여부");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");		
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@금융권");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN2=품질평가(10점)@품질관리");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("AS=#cspan@사후관리");		
		dhtmlx_head_merge_cols_vec.addElement("3SCORE1=#cspan@#cspan");

		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE5=#cspan@#cspan");		
	}
	// 금융IC카드
	else if( gubun.equals("262") ){
		isRowsMergeable = true;

// 		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@#rspan");
// 		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#rspan");
		
		dhtmlx_head_merge_cols_vec.addElement("NO=대상업체@업체정보");
		dhtmlx_head_merge_cols_vec.addElement("VENDOR_NAME=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_YEAR=회사규모(15점)@사업연수");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY=#cspan@매출규모");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER=재무상태(20점)@부채비율");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER1=#cspan@유동비율");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE1=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER2=#cspan@매출액영업이익율");
		dhtmlx_head_merge_cols_vec.addElement("6SCORE=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_NUM=기술능력(10점)@인원현황");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE1=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY1=이행실적(15점)@당행");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY2=#cspan@금융권");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE2=#cspan@#cspan");
		
		dhtmlx_head_merge_cols_vec.addElement("YN=품질평가(20점)@품질관리");
		dhtmlx_head_merge_cols_vec.addElement("7SCORE2=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("YN1=#cspan@금융IC카드품질인증");		
		dhtmlx_head_merge_cols_vec.addElement("10SCORE3=#cspan@#cspan");		
		dhtmlx_head_merge_cols_vec.addElement("AS=#cspan@사후관리");		
		dhtmlx_head_merge_cols_vec.addElement("3SCORE=#cspan@#cspan");

		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY3=당행기여도(20점)@RAR실적");
		dhtmlx_head_merge_cols_vec.addElement("10SCORE4=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY4=#cspan@신용카드");
		dhtmlx_head_merge_cols_vec.addElement("3SCORE1=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_PER3=#cspan@급여이체");
		dhtmlx_head_merge_cols_vec.addElement("2SCORE=#cspan@#cspan");
		dhtmlx_head_merge_cols_vec.addElement("GIVE_MONEY5=#cspan@퇴직연금");
		dhtmlx_head_merge_cols_vec.addElement("5SCORE2=#cspan@#cspan");		
	}			
	else{
		isRowsMergeable = false;
	}
	
	System.out.println(S_ID + " : " + gubun + " : " + isRowsMergeable );
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<Script language="javascript">
	var G_SERVLETURL    = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.ev_vendor_result";
	var GridObj         = null;
	var MenuObj         = null;
	var myDataProcessor = null;
	var select_ck		= false;
	
	function initAjax(){
		doRequestUsingPOST( 'W001' , '1'   , 'sg_kind'  , '<%=sg_kind%>' );
		<%if( sg_kind.equals("1") ){ %>
		doRequestUsingPOST( 'W002' , '2#1' , 'sg_kind_1', '<%=sg_kind_1%>' );
		var nodePath    = document.getElementById("sg_kind_1");
		var ooption     = document.createElement("option");
		ooption.text    = "<%=text.get("MESSAGE.1017")%>";
		ooption.value   = "";
		nodePath.add(ooption);
		<%}else if( sg_kind.equals("8") ){%>
			var nodePath    = document.getElementById("sg_kind_1");
			var ooption     = document.createElement("option");
			var ooption_1   = document.createElement("option");
			
			ooption.text    = "<%=text.get("MESSAGE.1017")%>";
			ooption.value   = "";
			ooption_1.text  = "시설동산";
			ooption_1.value = "8";
			
			nodePath.add(ooption);
			nodePath.add(ooption_1);
			nodePath.selectedIndex = '1'
			
		<%}else if( sg_kind.equals("62") ){%>
			var nodePath    = document.getElementById("sg_kind_1");
			var ooption     = document.createElement("option");
			var ooption_1   = document.createElement("option");
			
			ooption.text    = "<%=text.get("MESSAGE.1017")%>";
			ooption.value   = "";
			ooption_1.text  = "공사";
			ooption_1.value = "62";
			
			nodePath.add(ooption);
			nodePath.add(ooption_1);
			nodePath.selectedIndex = '1'
			
		<%}%>
		
		//집기류, 인쇄물, 간판류, 사무기기, 용도품	
		<%if( sg_kind_1.equals("2") || sg_kind_1.equals("4") || sg_kind_1.equals("6") || sg_kind_1.equals("21") || sg_kind_1.equals("34") ){ %>
			var nodePath    = document.getElementById("sg_kind_2");
			var ooption     = document.createElement("option");
			var ooption_1   = document.createElement("option");
			
			var text        = ""; 
			<%if( sg_kind_1.equals("2") ){%>  text = "집기류";  <%}%>
			<%if( sg_kind_1.equals("4") ){%>  text = "인쇄물";   <%}%>
			<%if( sg_kind_1.equals("6") ){%>  text = "간판류";   <%}%>
			<%if( sg_kind_1.equals("21") ){%> text = "사무기기"; <%}%>
			<%if( sg_kind_1.equals("34") ){%> text = "용도품";   <%}%>
			
			ooption.text    = "<%=text.get("MESSAGE.1017")%>";
			ooption.value   = "";
			ooption_1.text  = text;
			ooption_1.value = "<%=sg_kind_1%>";
			
			nodePath.add(ooption);
			nodePath.add(ooption_1);
			nodePath.selectedIndex = '1'	

		//중요증서
		<%}else if( sg_kind_1.equals("241") ){%>
			doRequestUsingPOST( 'W002' , '3#'+"<%=sg_kind_1%>" , 'sg_kind_2', '<%=sg_kind_2%>' );
			var nodePath    = document.getElementById("sg_kind_2");
			var ooption     = document.createElement("option");
			ooption.text    = "<%=text.get("MESSAGE.1017")%>";
			ooption.value   = "";
			nodePath.add(ooption);
		
		// 시설동산	8	
		// 공사     62	
		<%}else if( sg_kind_1.equals("8") || sg_kind_1.equals("62") ){%>
			var f = document.forms[0];
			var sg_refitem = f.sg_kind_1.value;
			var text        = ""; 
			if( sg_refitem == "8" )   text = "시설동산";
			if( sg_refitem == "62" )  text = "공사";
					 				
			var nodePath    = document.getElementById("sg_kind_2");
			var ooption     = document.createElement("option");
			var ooption_1   = document.createElement("option");
			
			ooption.text    = "<%=text.get("MESSAGE.1017")%>";
			ooption.value   = "";
			ooption_1.text  = text;
			ooption_1.value = sg_refitem;
			
			nodePath.add(ooption);
			nodePath.add(ooption_1);
			nodePath.selectedIndex = '1'		
		
		<%}%>
		doRequestUsingPOST( 'WO100', ''    , 'ev_year'  , '<%=ev_year%>' );
	}
	
	function setGridDraw()
	{
		<%=grid_obj%>_setGridDraw();
		GridObj.setSizes();
	}
	
	function doOnRowSelected(rowId,cellInd)
	{
    	if(GridObj.getColumnId(cellInd) == "VENDOR_NAME"){
    	
    		var ev_no           = GridObj.cells(rowId, GridObj.getColIndexById("EV_NO")).getValue();
    		var ev_year         = GridObj.cells(rowId, GridObj.getColIndexById("EV_YEAR")).getValue();
    		var seller_code     = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_CODE")).getValue();
    		var seller_name_loc = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_NAME_LOC")).getValue();
    		var sg_regitem      = GridObj.cells(rowId, GridObj.getColIndexById("SG_REGITEM")).getValue();

			url = "ev_sheet_run_view.jsp";
	     	document.ex_form.ev_no.value           = ev_no;
	     	document.ex_form.ev_year.value         = ev_year;
	     	document.ex_form.seller_code.value     = seller_code;
	     	document.ex_form.seller_name_loc.value = seller_name_loc;
	     	document.ex_form.sg_regitem.value      = sg_regitem;
			document.ex_form.action                = url;
			document.ex_form.method                = "POST";
	
			var newWin_pop = window.open(url,"view_pop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1200,height=700,left=0,top=0");
			document.ex_form.target = "view_pop";  
			document.ex_form.submit();  
			newWin_pop.focus();	
			
		}  
	}
	
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
	
	//그리드의 선택된 행의 존재 여부를 리턴
	function checkRows(){
		var grid_array = getGridChangedRows(GridObj, "selected");
		
		if(grid_array.length > 0)	return true;
		
		alert("<%=text.get("MESSAGE.1004")%>");
		return false;
	}
	
	//조회
	function doQuery(){
		var form      = document.forms[0];
	    var ev_year   = form.ev_year.value;
	    var sg_kind   = form.sg_kind.value;	
	    var sg_kind_1 = form.sg_kind_1.value;
	    var sg_kind_2 = form.sg_kind_2.value;
	    
	    if( sg_kind_1 == '' || sg_kind_2 == '' ){
	    	alert("평가그룹을 선택하여 주십시요.");
	    	return;
		}
		var grid_col_id = "<%=grid_col_id%>";

	    var param    = "?mode=<%=S_ID%>&grid_col_id="+grid_col_id;
		    param   += "&ev_year="+ev_year;
		    param   += "&sg_kind="+sg_kind;
		    param   += "&sg_kind_1="+sg_kind_1;
		    param   += "&sg_kind_2="+sg_kind_2;
		    
		GridObj.post(G_SERVLETURL+param);
		GridObj.clearAll(false);
		select_ck = true;
	}
	
	//조회후 뒷처리
    function doQueryEnd(GridObj, RowCnt){
		var msg    = GridObj.getUserData("", "message");
		var status = GridObj.getUserData("", "status");

		if(status == "false")	alert(msg);
		
		return true;
    }
    			
	//저장
	function doInsert(){
		
	}
	
	//저장후 뒷처리
	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;
		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}
		
		if(status == "true")	doQuery();
		else{
			alert(messsage);
		}

		return false;
	}
	
	function doOnChange( gubun ){
		var f = document.forms[0];

		if( gubun == '1' ){
			var sg_refitem = f.sg_kind.value;
			var sg_kind_1  = eval(document.getElementById('sg_kind_1'));  //id값 얻기
			sg_kind_1.options.length = 0; //길이 0으로
			
			if( sg_refitem == '8' ){
				var nodePath    = document.getElementById("sg_kind_1");
				var ooption     = document.createElement("option");
				var ooption_1   = document.createElement("option");
				
				ooption.text    = "<%=text.get("MESSAGE.1017")%>";
				ooption.value   = "";
				ooption_1.text  = "시설동산";
				ooption_1.value = "8";
				
				nodePath.add(ooption);
				nodePath.add(ooption_1);	
			}else if(sg_refitem == '62'){
				var nodePath    = document.getElementById("sg_kind_1");
				var ooption     = document.createElement("option");
				var ooption_1   = document.createElement("option");
				
				ooption.text    = "<%=text.get("MESSAGE.1017")%>";
				ooption.value   = "";
				ooption_1.text  = "공사";
				ooption_1.value = "62";
				
				nodePath.add(ooption);
				nodePath.add(ooption_1);	
			}else{
				doRequestUsingPOST( 'W002', '2'+'#'+sg_refitem ,'sg_kind_1', '<%=sg_kind_1%>' );
				var nodePath    = document.getElementById("sg_kind_1");
				var ooption     = document.createElement("option");
				
				ooption.text    = "<%=text.get("MESSAGE.1017")%>";
				ooption.value   = "";
				
				nodePath.add(ooption);
			}
		}
		else if( gubun == '2' ){
			var sg_refitem = f.sg_kind_1.value;
			var sg_kind_2  = eval(document.getElementById('sg_kind_2'));  //id값 얻기
			sg_kind_2.options.length = 0; //길이 0으로			
			
			if( sg_refitem == "241" ){
				doRequestUsingPOST( 'W002' , '3#'+sg_refitem , 'sg_kind_2', '<%=sg_kind_2%>' );
				var nodePath    = document.getElementById("sg_kind_2");
				var ooption     = document.createElement("option");
				
				ooption.text    = "<%=text.get("MESSAGE.1017")%>";
				ooption.value   = "";
				
				nodePath.add(ooption);		
			}else{
				var text        = ""; 
				if( sg_refitem == "2" )   text = "집기류";  
				if( sg_refitem == "4" )   text = "인쇄물";  
				if( sg_refitem == "6" )   text = "간판류";  
				if( sg_refitem == "21" )  text = "사무기기";
				if( sg_refitem == "34" )  text = "용도품";
				if( sg_refitem == "8" )   text = "시설동산";
				if( sg_refitem == "62" )  text = "공사";
						 				
				var nodePath    = document.getElementById("sg_kind_2");
				var ooption     = document.createElement("option");
				var ooption_1   = document.createElement("option");
				
				ooption.text    = "<%=text.get("MESSAGE.1017")%>";
				ooption.value   = "";
				ooption_1.text  = text;
				ooption_1.value = sg_refitem;
				
				nodePath.add(ooption);
				nodePath.add(ooption_1);		
			}
		}
		else if( gubun == '3' ){
			var form      = document.forms[0];
		    var ev_year   = encodeUrl(form.ev_year.value);
		    var sg_kind   = encodeUrl(form.sg_kind.value);
		    var sg_kind_1 = encodeUrl(form.sg_kind_1.value);
		    var sg_kind_2 = encodeUrl(form.sg_kind_2.value);
		    
		    if( sg_kind_1 == "" )	return;		
		    if( sg_kind_2 == "" )	return;
		    
			var param  = "?gubun="     + sg_kind_2;
			    param += "&ev_year="   + ev_year;
			    param += "&sg_kind="   + sg_kind;
			    param += "&sg_kind_1=" + sg_kind_1;
			    param += "&sg_kind_2=" + sg_kind_2;
			
			document.location.href = "ev_vendor_result.jsp"+param;				
		}
	}
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	//--------------------------
// 기본적인 사용 예
//--------------------------
function fnOpen()
{

	if(select_ck == false){
		alert("조회를 하신 후 인쇄 할 수 있습니다.");
		return;
	}
	// 필수 - 레포트 생성 객체
	var oReport = GetfnParamSet();
	// 여러 iframe에 레포트를 보여주기 위해 레포트객체id 명시할 수 있음.
	//var oReport = GetfnParamSet("0");

	// 필수 - 레포트 파일명

	<%if(gubun.equals("2")){ %>
	//oReport.rptname = "../../RexServer/WO_203";
	oReport.rptname = "WO_203";
	<%}else if(gubun.equals("4")){ %>
	oReport.rptname = "WO_204";
	<%}else if(gubun.equals("6")){ %>
	oReport.rptname = "WO_205";
	<%}else if(gubun.equals("21")){ %>
	oReport.rptname = "WO_206";
	<%}else if(gubun.equals("34")){ %>
	oReport.rptname = "WO_207";
	<%}else if(gubun.equals("8")){ %>
	oReport.rptname = "WO_208";
	<%}else if(gubun.equals("62")){ %>
	oReport.rptname = "WO_209";
	<%}else if(gubun.equals("242")){ %>
	oReport.rptname = "WO_210";	
	<%}else if(gubun.equals("243")){ %>
	oReport.rptname = "WO_211";	
	<%}else if(gubun.equals("262")){ %>
	oReport.rptname = "WO_212";			
	<%}else{%>
		return;
	<%}%>


	oReport.connectname= "ORACLE";

	oReport.open();
	
}

// event handler 
function fnReportEvent(oRexCtl, sEvent, oArgs) {
	//alert(sEvent);

	if (sEvent == "init") {
		oRexCtl.SetCSS("appearance.canvas.offsetx=0");
		oRexCtl.SetCSS("appearance.canvas.offsety=0");
		oRexCtl.SetCSS("appearance.pagemargin.visible=0");

		
		oRexCtl.SetCSS("appearance.toolbar.button.open.visible=0");
		oRexCtl.SetCSS("appearance.toolbar.button.export.visible=0");
		oRexCtl.SetCSS("appearance.toolbar.button.refresh.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.movefirst.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.moveprev.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.pagenumber.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.pagecount.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.movenext.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.movelast.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.zoom.visible=1");
		oRexCtl.SetCSS("appearance.toolbar.button.exportxls.visible=0");
		oRexCtl.SetCSS("appearance.toolbar.button.exportpdf.visible=0");
		oRexCtl.SetCSS("appearance.toolbar.button.exporthwp.visible=0");
		oRexCtl.SetCSS("appearance.toolbar.button.about.visible=0");
		
		//oRexCtl.SetCSS("appearance.pane.toc.visible=0");

		oRexCtl.UpdateCSS();
	} else if (sEvent == "finishdocument") {
		
	} else if (sEvent == "finishprint") {
		
	} else if (sEvent == "finishexport") {
		//alert(oArgs.filename);
	}

	//window.close();
}


</Script>
<%-- <script language="javascript" src="../RexServer/rexscript/rexpert.min.js"></script> --%>
<%-- <script language="javascript" src="../RexServer/rexscript/rexpert_properties.js"></script> --%>
</head>
<body leftmargin="15" topmargin="6" marginwidth="0" marginheight="0" onload="setGridDraw();initAjax();">
<s:header>
<form id="form" name="form" method="post" action="">
<%@ include file="/include/include_top.jsp"%>
<%
	 thisWindowPopupFlag = "true";
	 thisWindowPopupScreenName = "평가결과표조회";
	//if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "true";
%>
<%@ include file="/include/sepoa_milestone.jsp"%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
    </tr>
    <tr>
    	<td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
					<td width="14%" class="se_cell_title">
						평가년도
					</td>
					<td width="86%" class="se_cell_data" colspan="5">
						<select id="ev_year" name="ev_year">
							<option value="">전체</option>
						</select>
					</td>				
				</tr>
				<tr>
					<td width="14%" class="se_cell_title">
						소싱그룹 대분류
					</td>
					<td width="20%" class="se_cell_data">
						<select id="sg_kind" name="sg_kind" class="inputsubmit" onchange="doOnChange('1');">
						</select>
					</td>
					<td width="13%" class="se_cell_title">
						소싱그룹 중분류
					</td>
					<td width="20%" class="se_cell_data">
						<select id="sg_kind_1" name="sg_kind_1" class="inputsubmit" onchange="doOnChange('2');">
						</select>
					</td>	
					<td width="13%" class="se_cell_title">
						소싱그룹 소분류
					</td>
					<td width="20%" class="se_cell_data">
						<select id="sg_kind_2" name="sg_kind_2" class="inputsubmit" onchange="doOnChange('3');">
						</select>
					</td>										
				</tr>
			</table>    	
		  	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		  	<tr>
				<td style="padding:5 5 5 0" align="right">
				<table cellpadding="2" cellspacing="0">
				    <tr>
						<td><script language="javascript">btn("doQuery()", "<%=text.get("BUTTON.search")%>")</script></td>
						<td><script language="javascript">btn("fnOpen()", "인쇄")</script></td>
					</tr>
			    </table>
			    </td>
		   	</tr>
		   	</table>    	
		</td>
	</tr>
</table>

</form>
<form id="ex_form" name="ex_form">
	<input type="hidden" id="ev_no"           name="ev_no">           
	<input type="hidden" id="ev_year"         name="ev_year">         
	<input type="hidden" id="seller_code"     name="seller_code">     
	<input type="hidden" id="seller_name_loc" name="seller_name_loc"> 
	<input type="hidden" id="sg_regitem"      name="sg_regitem">      
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>
</html>
