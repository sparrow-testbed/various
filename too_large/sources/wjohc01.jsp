<%@ page language="java" contentType="text/html; charset=euc-kr" %>   
     
<%--    
/*******************************************************************************
 ** 프로그램명 : WJOHC01.jsp
 ** 내      용 : 출력(파일, 장표, 센터)
 ** 사  용  법 : 
 **              
 ** 작  성  자 : 양 보 승
 ** 작  성  일 : 2002.05.03 
 ******************************************************************************* 
 ** 수  정  일 :
 ** 수  정  자 :
 ** 수정  내용 :
 *******************************************************************************/
--%>

<%@ page info="거래명세조회 : 출력(파일, 장표, 센터)" %>

<%@ include file="WJOGT71.jsp" %> <%-- 공통 클래스 --%>
<%@ include file="WJOGT21.jsp" %> <%-- 공통 라이브러리 --%>
<%@ include file="WJOGT72.jsp" %> <%-- 공통 전역변수 --%>

<%
	/************************************************************************************/	
	strJspStep = "공통 전역변수(초기화)";
	strJspName = "WJOHC01.jsp";
	strJspInfo = "출력(파일, 장표, 센터)";
	INT_DEBUG_LEVEL = 10;  //값이 클수록 자세한 디버그 결과 기록...	
	/************************************************************************************/	
%>
<%  
	/************************************************************************************/	
try 
{ 
	/************************************************************************************/	
%>                     

<%@ include file="WJOGT24.jsp" %> <%-- 시작시각 출력하기 --%>
<%@ include file="WJOGT25.jsp" %> <%-- 세션정보 확인하기, 세션정보 읽어오기 --%>
<%@ include file="WJOGT26.jsp" %> <%-- 데이터베이스 연결 --%>

<%
	/************************************************************************************/	
	strJspStep = "변수 선언 및 초기화"; 

	if (INT_DEBUG_LEVEL >= 1) //System.out.println(strJspName + ":" + strJspStep);
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep);

	strPtyGubunCd = (request.getParameter("forPtyGubunCd") == null) ? "" : request.getParameter("forPtyGubunCd");	//출력구분코드	
	strPftGubunCd = (request.getParameter("forPftGubunCd") == null) ? "" : request.getParameter("forPftGubunCd");	//형식구분코드

	String strRequestDate = (request.getParameter("forRequestDate") == null) ? "" : request.getParameter("forRequestDate");	//요청일자
	String strJumBankCd = (request.getParameter("forJumBankCd") == null) ? "" : request.getParameter("forJumBankCd");		//요청자 은행코드
	String strJiJumCd = (request.getParameter("forJiJumCd") == null) ? "" : request.getParameter("forJiJumCd");				//지점코드
	String strSeqNo = (request.getParameter("forSeqNo") == null) ? "" : request.getParameter("forSeqNo");					//일련번호
	strPortNumber = (request.getParameter("forPortNumber") == null) ? "" : request.getParameter("forPortNumber");	//출력포트번호	
	String strTgQry_Date = (request.getParameter("forTgQry_Date") == null) ? "" : request.getParameter("forTgQry_Date");	//출력포트번호
	
	String strQryGbn = (request.getParameter("forQryGbn") == null) ? "" : request.getParameter("forQryGbn"); 				//감사자료
	String strQryDay = (request.getParameter("forQryDay") == null) ? "" : request.getParameter("forQryDay"); 				//감사자료, 통계자료
	String strQryCdt = (request.getParameter("forQryCdt") == null) ? "" : request.getParameter("forQryCdt");
	String strQryBnk = (request.getParameter("forQryBnk") == null) ? "" : request.getParameter("forQryBnk");
	String strQryBnk1 = (request.getParameter("forQryBnk1") == null) ? "" : request.getParameter("forQryBnk1");
	String strShJobGubun = (request.getParameter("forShJobGubun") == null) ? "" : request.getParameter("forShJobGubun"); 	//개설상황
	String strShBnkGubun = (request.getParameter("forShBnkGubun") == null) ? "" : request.getParameter("forShBnkGubun"); 	//개설상황
	String strShJuminNum = (request.getParameter("forShJuminNum") == null) ? "" : request.getParameter("forShJuminNum"); 	//개설상황
	String strShOwnerNme = (request.getParameter("forShOwnerNme") == null) ? "" : request.getParameter("forShOwnerNme"); 	//개설상황
	String strShGogakNum = (request.getParameter("forShGogakNum") == null) ? "" : request.getParameter("forShGogakNum"); 	//개설상황
	String strShAccntNum = (request.getParameter("forShAccntNum") == null) ? "" : request.getParameter("forShAccntNum"); 	//개설상황
	String strTbQrySelect = (request.getParameter("forTbQrySelect") == null) ? "" : request.getParameter("forTbQrySelect"); //사실통보
	
	String strSearchDate = (request.getParameter("forSearchDate") == null) ? "" : request.getParameter("forSearchDate"); 
	String strQueryDateFm = (request.getParameter("forQueryDateFm") == null) ? "" : request.getParameter("forQueryDateFm").trim();
	String strQueryDateTo = (request.getParameter("forQueryDateTo") == null) ? "" : request.getParameter("forQueryDateTo").trim();	
	
	String strReqBankCd = (request.getParameter("forReqBankCd") == null) ? "" : request.getParameter("forReqBankCd");	// 조회요청 은행코드
	String strReqBranchCd = (request.getParameter("forReqBranchCd") == null) ? "" : request.getParameter("forReqBranchCd");	// 조회요청 지점 코드
	String strReqUserID = (request.getParameter("forUserID") == null) ? strUserID : request.getParameter("forUserID");	// 요청자 ID 
	String strReqDate = (request.getParameter("forReqDate") == null) ? "" : request.getParameter("forReqDate");		// 조회요청일자

	String strBankJj = (request.getParameter("forBankJj") == null) ? "20" : request.getParameter("forBankJj");
	String strBbUserJj = (request.getParameter("forBbUserJj") == null) ? "700" : request.getParameter("forBbUserJj");
	String strBbUserNo = (request.getParameter("forBbUserNo") == null) ? "" : request.getParameter("forBbUserNo");
	String strBbUserNm = (request.getParameter("forBbUserNm") == null) ? "" : request.getParameter("forBbUserNm");
	String strDownGbn = (request.getParameter("forDownGbn") == null) ? "" : request.getParameter("forDownGbn");
	String strTeamNm = (request.getParameter("forTeamNm") == null) ? "" : request.getParameter("forTeamNm");
	String strPermitGbn = (request.getParameter("forPermitGbn") == null) ? "1" : request.getParameter("forPermitGbn");
	String strJobGubunCd = (request.getParameter("forJobGubunCd") == null) ? "1" : request.getParameter("forJobGubunCd");	//이행결과 내역조회
	
	String strFaxNum = (request.getParameter("forFaxNum ") == null) ? "" : request.getParameter("forFaxNum ");
	String strIBGbn = (request.getParameter("forIBGbn") == null) ? " " : request.getParameter("forIBGbn");	//요구불 입지구분
	String strSearchText = (request.getParameter("forSearchText") == null) ? " " : request.getParameter("forSearchText");	//요구불 검색문자
	String strSchGbn = (request.getParameter("forSchGbn") == null) ? " " : request.getParameter("forSchGbn");	//요구불 검색문자
	String strSearchBlank = "";
	String strBonbuGbn = "";
	
	String strMultiCnt = (request.getParameter("forMultiCnt") == null) ? " " : request.getParameter("forMultiCnt");	//대량계좌 선택 건수
	String strMultiVal = (request.getParameter("forMultiVal") == null) ? " " : request.getParameter("forMultiVal");	//대량계좌 순번 묶음
	String strBankJumSeqVal = (request.getParameter("forBankJumSeqVal") == null) ? " " : request.getParameter("forBankJumSeqVal");	//선택된 항목들의 의뢰은행코드+의뢰점코드+일련번호의 나열,,,  2010012345678(하나 선택시 13자리, 두개 선택시 26자리.....)
	String strQryBnkJjm = (request.getParameter("forQryBnkJjm") == null) ? " " : request.getParameter("forQryBnkJjm");	//감사자료조회의 검색지점 묶음(5자리씩)

	String strDmno = (request.getParameter("forDmno") == null) ? " " : request.getParameter("forDmno");	//단말번호
	String strTlno = (request.getParameter("forTlno") == null) ? " " : request.getParameter("forTlno");	//텔러번호

	String strSsr_Gb = (request.getParameter("Ssr_Gb") == null) ? " " : request.getParameter("Ssr_Gb");	//수수료면제구분
	String strSoonabGb = (request.getParameter("SelectSoonabGb") == null) ? " " : request.getParameter("SelectSoonabGb");	//포인트구분내용
	String strMynjeGb = (request.getParameter("SelectMynjeGb") == null) ? " " : request.getParameter("SelectMynjeGb");	//수수료감면코드
	String strSsr_Am = (request.getParameter("forSsr_Am") == null) ? " " : request.getParameter("forSsr_Am");	//수수료금액
  String strSucFal_gb = (request.getParameter("forSucFal_gb") == null) ? " " : request.getParameter("forSucFal_gb");	//출력성공여부


/*	System.err.println("strUserBankCd  (" + strUserBankCd  + ")");		
	System.err.println("strSosokJumCd  (" + strSosokJumCd  + ")");		
	System.err.println("strSeqNo       (" + strSeqNo       + ")");		
	System.err.println("strRequestDate (" + strRequestDate + ")");		
	System.err.println("strUserID      (" + strUserID      + ")");		*/

  String strOutseqno     = "";
  String strBsccd        = "";
  String strTicticno     = "";
  String strTellerno     = "";
  String strPnt_Clss     = "";
  String strFerdu_Rsn_Cd = "";
  String strSsrssram     = "";
  String strFcst_Fee_Am  = "";
  String strTmnseqno     = "";
  String Strjobjobgb     = "";
  String strRefbnkcd     = "";
  String strRefchkno     = "";
  String strIngfdtdt     = "";
  String strIngfshdt     = "";
  String strIngcltnm     = "";
  String strDmddmdny     = "";
  String strStsstscd     = "";
  String strJmdjmdno     = "";
  String strOutouttm     = "";
  String strOutfmtgb     = "";
  String strOutrptct     = "";
  String strSumyungb     = ""; 
  String strOutoutgb     = "0";
  String strBelbrnnm     = "";
  String strBelhvbnm     = "";
 	int    iBeforeCnt      = 0;
 	String strDdu_Mb_Pnt_Am= "";
 	String strMb_Pnt_Rdu_Cd= "";
 	String strAdd_Rdu_Cd   = "";
 	String strAdd_Rdu_Am   = "";
 	String strHjmb_Pnt     = "";
 	

  String strCurrentdt    = "";
  String strRtnMsg       = "";
	int iMsglen = 0;
  String retCd           = "";
  int iPointGb = 0;
	
  strQuery1 = "{call SUOJS08 (?, ?, ?, ?, ?)}"; 
  intParCnt = 5;
  strParData[0] = "Q";
  strParData[1] = strUserBankCd;
  strParData[2] = strSosokJumCd;
  strParData[3] = strSeqNo;
  strParData[4] = strRequestDate;
  strParData[5] = strUserID;
    
    	/************************************************************************************/	
%>
    
<%@ include file="WJOGT51.jsp" %> <%-- 데이터베이스 조회 --%>
     
<%
    
  if (rset1 != null){
      rset1.next(); 
  
      strOutseqno     = rset1.getString( 1);  /* 감사순번 */
      strBsccd        = rset1.getString( 2);  /* BSC코드  */
      strTicticno     = rset1.getString( 3);  /* 전표번호 */
      strTellerno     = rset1.getString( 4);  /* 텔러번호 */
      strPnt_Clss     = rset1.getString( 5);  /* 수납방법 1:현금 2:포인트 */
      strFerdu_Rsn_Cd = rset1.getString( 6);  /* 수수료면제여부 0:수납 1:공통면제 2:소관부서승인 5:100%면제대상 */
      strSsrssram     = rset1.getString( 7);  /* 수수료금액 */
      strFcst_Fee_Am  = rset1.getString( 8);  /* 원수수료   */
      strTmnseqno     = rset1.getString( 9);  /* 단말번호   */
      Strjobjobgb     = rset1.getString(10);  /* 업무구분   */
      strRefbnkcd     = rset1.getString(11);  /* 계좌은행코드 */
      strRefchkno     = rset1.getString(12);  /* 출력계좌번호 */
      strIngfdtdt     = rset1.getString(13);  /* 조회시작     */
      strIngfshdt     = rset1.getString(14);  /* 조회종료     */
      strIngcltnm     = rset1.getString(15);  /* 의뢰인       */
      strDmddmdny     = rset1.getString(16);  /* 의뢰코드     */
      strStsstscd     = rset1.getString(17);  /* 상태코드 (파일저장완료 : 10) */
      strJmdjmdno     = rset1.getString(18);  /* 계좌주민번호 */
      strOutouttm     = rset1.getString(19);  /* 출력시간     */
      strOutfmtgb     = rset1.getString(20);  /* 출력구분     */
      strOutrptct     = rset1.getString(21);  /* 출력매수     */
      strSumyungb     = rset1.getString(22);  /* 수수료수납여부 */
      strOutoutgb     = rset1.getString(23);  /* 정상출력완료여부 */
      strBelbrnnm     = rset1.getString(24);  /* 점명             */
      strBelhvbnm     = rset1.getString(25);  /* 출력조작자명     */
    	iBeforeCnt      = Integer.parseInt(rset1.getString(26));  /* 전에 출력한 사실여부 */
      strDdu_Mb_Pnt_Am= rset1.getString(27);  /* 차감멤버스포인트금액 */
      strMb_Pnt_Rdu_Cd= rset1.getString(28);  /* 멤버스포인트감면코드 */
      strAdd_Rdu_Cd   = rset1.getString(29);  /* 추가감면코드      */   
      strAdd_Rdu_Am   = rset1.getString(30);  /* 추가감면금액      */   
      strHjmb_Pnt     = rset1.getString(31);  /* 현재멤버스포인트  */   
      strCurrentdt    = getCurrentDate("yyyyMMdd");
  }
  
	if (INT_DEBUG_LEVEL >= 2) 
	{
	    System.err.println("strOutseqno     : " + strOutseqno    );		
	    System.err.println("strBsccd        : " + strBsccd       );		
	    System.err.println("strTicticno     : " + strTicticno    );		
	    System.err.println("strTellerno     : " + strTellerno    );		
	    System.err.println("strPnt_Clss     : " + strPnt_Clss    );		
	    System.err.println("strFerdu_Rsn_Cd : " + strFerdu_Rsn_Cd);		
	    System.err.println("strSsrssram     : " + strSsrssram    );		
	    System.err.println("strFcst_Fee_Am  : " + strFcst_Fee_Am );		
	    System.err.println("strTmnseqno     : " + strTmnseqno    );		
	    System.err.println("Strjobjobgb     : " + Strjobjobgb    );		
	    System.err.println("strRefbnkcd     : " + strRefbnkcd    );		
	    System.err.println("strRefchkno     : " + strRefchkno    );		
	    System.err.println("strIngfdtdt     : " + strIngfdtdt    );		
	    System.err.println("strIngfshdt     : " + strIngfshdt    );		
	    System.err.println("strIngcltnm     : " + strIngcltnm    );		
	    System.err.println("strDmddmdny     : " + strDmddmdny    );		
	    System.err.println("strStsstscd     : " + strStsstscd    );		
	    System.err.println("strJmdjmdno     : " + strJmdjmdno    );		
	    System.err.println("strOutouttm     : " + strOutouttm    );		
	    System.err.println("strOutfmtgb     : " + strOutfmtgb    );		
	    System.err.println("strOutrptct     : " + strOutrptct    );		
	    System.err.println("strSumyungb     : " + strSumyungb    );		
	    System.err.println("strOutoutgb     : " + strOutoutgb    );		      
	    System.err.println("strBelbrnnm     : " + strBelbrnnm    );		      
	    System.err.println("strBelhvbnm     : " + strBelhvbnm    );		 
	    System.err.println("iBeforeCnt      : " + iBeforeCnt     );		 
	    System.err.println("strDdu_Mb_Pnt_Am: " + strDdu_Mb_Pnt_Am);		
	    System.err.println("strMb_Pnt_Rdu_Cd: " + strMb_Pnt_Rdu_Cd);		
	    System.err.println("strAdd_Rdu_Cd   : " + strAdd_Rdu_Cd   );		
	    System.err.println("strAdd_Rdu_Am   : " + strAdd_Rdu_Am   );		
	    System.err.println("strHjmb_Pnt     : " + strHjmb_Pnt     );		

      System.err.println( getCurrentDate("yyyyMMdd"));
	    System.err.println("strPtyGubunCd   : " + strPtyGubunCd    );		
	    System.err.println("strSucFal_gb   : " + strSucFal_gb    );		
	          

	}

/* 
   1. 전표레이아웃
   
      1라인(76)                       2라인(70)                   3라인(개별부)
   
       화면번호         6               과목코드           3
       입지구분        10               공백               1
       거래일          10               계좌번호          17
       공백             1               공백               1
       거래시분         5               유무통구분         1
       계정모드         6               공백               1
       점코드           5               수수료감면코드     3
       공백             1               공백               1
       단말번호         4               NET여부            1
       조작자성명      10               고객성명          16 
       텔러번호         4               책임자번호         8
       공백             1               거래금액          17
       전표구분         1               
       공백             1               
       전표번호         5               
       복수결재         6               
   
*/
/*
 strSumyungb = "Y";
 strFerdu_Rsn_Cd = "0";
 strPnt_Clss = "1";
*/
%>
 	<HTML>
 	<HEAD>
  <SCRIPT LANGUAGE="JavaScript">	
  function fn_sleep(msecs){
  	var start = new Date().getTime();
  	var cur = start;
  	while(cur-start<msecs){
  	   cur=new Date().getTime();
  	}
  }
  	
	function PrintPBPR()
	{
		
		var strData = "";
		var strDmno = "";
		var strTlno = "";
		var strJmno = "";
		var iGeri   = 0;

<% 
 /* 단말번호길이가 9보다 적으면 공백으로 처리한다 */
if (strTmnseqno.length() < 9){
     strTmnseqno = "";
}

%>

/*  정상적으로 출력 저장완료 된것만 로직구현 */
/*  현금 대체 수납일때만 전표발생한다. (제증명서발급의뢰서,영수증 포함)*/		
<%	if( strSucFal_gb.equals("0") && strSumyungb.equals("Y") && strFerdu_Rsn_Cd.equals("0") && (strPnt_Clss.equals("1") || strPnt_Clss.equals("2"))){ %>

/*      작업이 성공적으로 완료 되었을때만 후속작업 진행한다 */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>

            /* WEB에서 계리를 발생시킨다 (처음에는 DB에서 계리 발생했으나 취소분에 대해 구현불가라서 WEB으로 변경) */
<%
		        /* 전표번호가 세팅되어서 들어오면 에러처리한다 */
		        if( !strTicticno.trim().equals("")){
	               strBsccd = "기존처리내용을 확인하세요"; /* 에러메세지 */
                 
	               /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	               /*strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}";       */
	               /*intParCnt = 4;                                   */
	               /*strParData[0] = "U";                             */
	               /*strParData[1] = strUserBankCd+strSosokJumCd;     */
	               /*strParData[2] = strUserID;                       */
	               /*strParData[3] = strOutseqno;                     */
	               /*strParData[4] = "U";                             */
		        
		        }else{
		             strSendString =  WVOGT04.padding("0", 1);		/* 요청 구분  (0 수수료 실행 , 1 수수료취소)  */
		             strSendString += WVOGT04.padding(strUserBankCd, 2)/* 접속자은행코드    */                                                            
		             			   + WVOGT04.padding(strSosokJumCd, 3)       /* 접속자지점코드    */                                                            
		             			   + WVOGT04.padding(strTmnseqno, 9) 		/* 단말번호          */                                                            
		             			   + WVOGT04.padding(strUserID, 8)    	/* 접속자 행번       */                                                            
		             			   + WVOGT04.padding(strRefchkno, 21) 	/* 계좌번호          */                                                            
		             			   + WVOGT04.padding(strSsrssram, 7) 		/* 금액              */    
		             			   + WVOGT04.padding(strPnt_Clss, 1) 		/* 1:현금 2:대체     */    
		             			   + WVOGT04.padding("1", 1) 				    /* 실행1, 취소2      */                                                            
		             			   + WVOGT04.padding(strJmdjmdno, 13); 	/* 주민번호          */                                                            
                 
		             WVOGT02 sc = new WVOGT02(6000);		
		             strRtnMsg = sc.commMessage(strSendString);		

	    System.err.println("strSendString     : " + strSendString    );		 
	    System.err.println("strRtnMsg         : " + strRtnMsg     );		 

                 
		             iMsglen = strRtnMsg.length();
		             if(iMsglen > 0){
		                 retCd  = strRtnMsg.substring(0,1);
		                 
		                 /* 정상처리 되었으면 */
		                 if(retCd.equals("0")){
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%4==1){
                                   stk.nextToken(); 
                             }else if(t%4==2){ 
	                                 strTicticno = stk.nextToken();  /* 전표번호 */
                             }else if(t%4==3){ 
	                                 strOutouttm = stk.nextToken();  /* 전표시간 */
                             }else if (t%4==0){ 
	                                 strBsccd = stk.nextToken(); /* BSC코드 */
                             } 
                         }
                         
                         /* 전표번호가 공백이면 에러처리 */
             		         if( strTicticno.trim().equals("")){

	                           strBsccd = "전표번호 오류"; /* 에러메세지 */

	                           /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	                           strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                           intParCnt = 4;
	                           strParData[0] = "U";
	                           strParData[1] = strUserBankCd+strSosokJumCd;
	                           strParData[2] = strUserID;
	                           strParData[3] = strOutseqno;
	                           strParData[4] = "U";
             		         }else{
	                           
	                           /* 이상찬:추가감면금액이 존재한다면 추가감면 처리 발생시킨다 */
	                           if(Integer.parseInt(strAdd_Rdu_Am) > 0){
	                               
	                               strSendString =  WVOGT04.padding("1", 1);		       /* 요청 구분  (0 포인트 조회 , 1 포인트 실행, 2  포인트 취소, 4 강제메세지, 5 지문데이터전송)  */
	                               strSendString += WVOGT04.padding(strTmnseqno, 9)    /* 이네이블러사용단말번호 (조회시에는 20900만 세팅)    */ 
	                                             +  WVOGT04.padding(strUserID, 8)      /* 이네이블러사용행번                                  */ 
	                                             +  WVOGT04.padding(strJmdjmdno, 13)   /* 주민번호          */ 
	                                             +  WVOGT04.padding("1058", 4)         /* 수수료종류코드    */
	                                             +  WVOGT04.padding(strFcst_Fee_Am, 9) /* 수수료금액(반드시원금액)        */ 
	                                             +  WVOGT04.padding("", 3)             /* 멤버스포인트감면코드      1: 지급/면제, 2: 지급/면제 취소일때만 조립 */              
	                                             +  WVOGT04.padding("", 9)             /* 멤버스차감포인트          1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                                             +  WVOGT04.padding("2", 1)            /* 멤버스차감여부            1: 포인트차감 2: 포인트거부                */
	                                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)  /* 추가감면코드              1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)  /* 추가감면수수료금액        1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                                             +  WVOGT04.padding("", 1)             /* 센터메세지구분            1: 책임자에게 2: 조작자에게                */
	                                             +  WVOGT04.padding("", 8)             /* 센터메시지조작자　행번    4: 센터메시지일때만 조립                   */
	                                             +  WVOGT04.padding("", 8)             /* 조작자　행번              5: 지문인식일때만 조립                     */
	                                             +  WVOGT04.padding("", 9)             /* 단말번호                  5: 지문인식일때만 조립                     */
	                                             +  WVOGT04.padding("", 669);          /* 지문인식데이터            5: 지문인식일때만 조립                     */
	                                                                                          
	                               sc = new WVOGT02(8000);		
	                               strRtnMsg = sc.commMessage(strSendString);		
                                 /* 이상찬:리턴처리 구현해야 함 */

	                           }
	                           
	                           /* 정상처리 업데이트 */
	                           strQuery1 = "{call SUOCK03 (?, ?, ?, ?, ?, ?, ?)}"; 
	                           intParCnt = 7;
	                           strParData[0] = "U";
	                           strParData[1] = strUserBankCd+strSosokJumCd;
	                           strParData[2] = strUserID;
	                           strParData[3] = strOutseqno;
	                           strParData[4] = strTicticno;
	                           strParData[5] = strOutouttm;
	                           strParData[6] = strBsccd;
	                           strParData[7] = "N";
	                       }
                 
		                 /* 에러처리 되었으면 */
                     }else if(retCd.equals("1")){
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* 에러메세지 */
                             } 
                         }
                         
	                       /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
                     }else{
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* 에러메세지 */
                             } 
                         }
                 
	                       /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
                     }
                 }else{

	                  System.err.println(" 계리리턴로그 접속자은행코드  : " + strUserBankCd );		
	                  System.err.println(" 계리리턴로그 접속자지점코드  : " + strSosokJumCd );		
	                  System.err.println(" 계리리턴로그 단말번호        : " + strTmnseqno   );		
	                  System.err.println(" 계리리턴로그 접속자 행번     : " + strUserID     );		
	                  System.err.println(" 계리리턴로그 계좌번호        : " + strRefchkno   );		
	                  System.err.println(" 계리리턴로그 금액            : " + strSsrssram   );		
	                  System.err.println(" 계리리턴로그 1:현금 2:대체   : " + strPnt_Clss   );		
	                  System.err.println(" 계리리턴로그 실행1, 취소2    : " + "1"           );		
	                  System.err.println(" 계리리턴로그 주민번호        : " + strJmdjmdno   );		
                 }
             }
%>               
<%@ include file="WJOGT51.jsp" %> <%-- 데이터베이스 조회 --%>
<%
	           /* 정상적으로 업데이트 되었으면 후속작업을 진행한다 */
	           if(retCd.equals("0") && intRVal == 1){
%>            
	    	         /* 조작자등록여부 먼저 판단 */
	    	         if(OP_RegGb()==1){
	     		          /* 전표출력 */
             
             
	     		          if(confirm("전표를 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		              if(Tic_Print()==1){
	     		              	
	     		              	  fn_sleep(3000);
                        
	     		                  if(confirm("제증명서발급의뢰서에 출력사항을 기재하시기 원하시면 \n제증명서발급의뢰서를 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		                      Jesingo_Print();
	     		                  }
	     		              	  fn_sleep(3000);
	     		              	  
	     		                  if(confirm("영수증을 출력하시기 원하시면 \n공용영수증을 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		                      YoungSoo_Print();
	     		                  }
	     		              }
	     		          }
	    	         }
	    	         
	    	         /* 대체입금했을경우 122001 거래 호출 */
<%    	         if(strPnt_Clss.equals("2")){ %>
	    	             SendMQ();
<%    	         }%>
             
<%           }else{ %>
	                alert("[<%=strBsccd%>]\n\n\n위와 같은 오류로 계리처리오류가 발생했습니다.");
	             	 return;
<%           }%>

<%       }else{ %>
	     		  alert("작업 오류가 발생하여 추가 진행이 불가합니다.");
	      	  return;
<%       }  %>


/*  포인트수납일때는 제증명서발급의뢰서,영수증만 출력 진행한다 */
<%   }else if(strSucFal_gb.equals("0") && strSumyungb.equals("Y") && strFerdu_Rsn_Cd.equals("0") && strPnt_Clss.equals("3")){ %>

/*      작업이 성공적으로 완료 되었을때만 후속작업 진행한다 */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>
<%	               
		        /* 단말번호가 공백으로 들어오면 에러처리한다 */
		        if( strTmnseqno.trim().equals("")){
	               strBsccd = "단말번호 오류"; /* 에러메세지 */
                 
	               /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	               strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	               intParCnt = 4;
	               strParData[0] = "U";
	               strParData[1] = strUserBankCd+strSosokJumCd;
	               strParData[2] = strUserID;
	               strParData[3] = strOutseqno;
	               strParData[4] = "U";
	               
	               iPointGb = 1;
		         
		        }else{
	               strSendString =  WVOGT04.padding("1", 1);		        /* 요청 구분  (0 포인트 조회 , 1 포인트 실행, 2  포인트 취소, 4 강제메세지, 5 지문데이터전송)  */
	               strSendString += WVOGT04.padding(strTmnseqno, 9)     /* 이네이블러사용단말번호 (조회시에는 20900만 세팅)    */ 
	                             +  WVOGT04.padding(strUserID, 8)       /* 이네이블러사용행번                                  */ 
	                             +  WVOGT04.padding(strJmdjmdno, 13)    /* 주민번호          */ 
	                             +  WVOGT04.padding("1058", 4)          /* 수수료종류코드    */
	                             +  WVOGT04.padding(strFcst_Fee_Am, 9)  /* 수수료금액(반드시원금액)        */ 
	                             +  WVOGT04.padding(strMb_Pnt_Rdu_Cd, 3)/* 멤버스포인트감면코드      1: 지급/면제, 2: 지급/면제 취소일때만 조립 */              
	                             +  WVOGT04.padding(strSsrssram, 9)     /* 멤버스차감포인트          1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding("1", 1)             /* 멤버스차감여부            1: 포인트차감 2: 포인트거부                */
	                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)   /* 추가감면코드              1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)   /* 추가감면수수료금액        1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding("", 1)              /* 센터메세지구분            1: 책임자에게 2: 조작자에게                */
	                             +  WVOGT04.padding("", 8)              /* 센터메시지조작자　행번    4: 센터메시지일때만 조립                   */
	                             +  WVOGT04.padding("", 8)              /* 조작자　행번              5: 지문인식일때만 조립                     */
	                             +  WVOGT04.padding("", 9)              /* 단말번호                  5: 지문인식일때만 조립                     */
	                             +  WVOGT04.padding("", 669);           /* 지문인식데이터            5: 지문인식일때만 조립                     */
	                                                                          
	               WVOGT02 sc = new WVOGT02(8000);		
	               strRtnMsg = sc.commMessage(strSendString);		
	               
		             iMsglen = strRtnMsg.length();
		             if(iMsglen > 0){
		                 retCd  = strRtnMsg.substring(0,1);
		                 
		                 /* 정상처리 되었으면 */
		                 if(retCd.equals("0")){
	               
	                       iPointGb = 0;

	                       /* 정상처리 업데이트 */
	                       strQuery1 = "{call SUOCK03 (?, ?, ?, ?, ?, ?, ?)}"; 
	                       intParCnt = 7;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "";
	                       strParData[5] = strOutouttm;
	                       strParData[6] = "";
	                       strParData[7] = "N";

                 
		                 /* 에러처리 되었으면 */
                     }else{
                 
                         StringTokenizer stk = new StringTokenizer(strRtnMsg, ";"); 
                         int t = 0;
                         
                         while(stk.hasMoreTokens()){
                             t++;
                             if(t%2==1){
                                   stk.nextToken(); 
                             }else if (t%2==0){ 
	                                 strBsccd = stk.nextToken(); /* 에러메세지 */
                             } 
                         }
                 
	                       /* 비정상처리 업데이트 :계리처리 오류시 감사자료에 오류사항 업데이트 한다*/
	                       strQuery1 = "{call SUOCK04 (?, ?, ?, ?)}"; 
	                       intParCnt = 4;
	                       strParData[0] = "U";
	                       strParData[1] = strUserBankCd+strSosokJumCd;
	                       strParData[2] = strUserID;
	                       strParData[3] = strOutseqno;
	                       strParData[4] = "U";
        
        	               iPointGb = 1;

                     }
                 }else{
        	           iPointGb = 1;
                 }
             }	           
%>
<%@ include file="WJOGT51.jsp" %> <%-- 데이터베이스 조회 --%>
<%
    	         
	           /* 정상적으로 업데이트 되었으면 후속작업을 진행한다 */
	           if(retCd.equals("0") && iPointGb ==0){ %>
	    	         /* 조작자등록여부 먼저 판단 */
	    	         if(OP_RegGb()==1){
                        
	     		           if(confirm("제증명서발급의뢰서에 출력사항을 기재하시기 원하시면 \n제증명서발급의뢰서를 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		               Jesingo_Print();
	     		           }
	     		           fn_sleep(3000);
	     		                  	  
	     		           if(confirm("영수증을 출력하시기 원하시면 \n공용영수증을 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		               YoungSoo_Print();
	     		           }
	    	         }
<%    	     }else{%>
	    	     	   alert("[<%=strBsccd%>]\n\n\n위와 같은 오류로 포인트차감오류가 발생했습니다.");
	             	 return;
<%	         }

         }else{ %>
	     		  //alert("작업 오류로 진행이 불가합니다.");
	      	  return;
<%       }  %>
/*  처음출력이면서 수수료면제일때는 제증명서발급의뢰서만 출력 진행한다 */
<%   }else if(iBeforeCnt ==1 && strSucFal_gb.equals("0") && strSumyungb.equals("N") && !strFerdu_Rsn_Cd.equals("0")){ %>
/*      작업이 성공적으로 완료 되었을때만 후속작업 진행한다 */		
<%    	if(  (((strPtyGubunCd.equals("2")) || (strPtyGubunCd.equals("7"))) && strStsstscd.equals("06")) ||
             (((strPtyGubunCd.equals("1")) || (strPtyGubunCd.equals("4"))) && strStsstscd.equals("10")) ){ %>

<%
             /* 100%면제대상이면 감면금액을 로그조립해서 올린다 */
             if(strFerdu_Rsn_Cd.equals("5")){

	               strSendString =  WVOGT04.padding("1", 1);		        /* 요청 구분  (0 포인트 조회 , 1 포인트 실행, 2  포인트 취소, 4 강제메세지, 5 지문데이터전송)  */
	               strSendString += WVOGT04.padding(strTmnseqno, 9)     /* 이네이블러사용단말번호 (조회시에는 20900만 세팅)    */ 
	                             +  WVOGT04.padding(strUserID, 8)       /* 이네이블러사용행번                                  */ 
	                             +  WVOGT04.padding(strJmdjmdno, 13)    /* 주민번호          */ 
	                             +  WVOGT04.padding("1058", 4)          /* 수수료종류코드    */
	                             +  WVOGT04.padding(strFcst_Fee_Am, 9)  /* 수수료금액(반드시원금액)        */ 
	                             +  WVOGT04.padding("", 3)              /* 멤버스포인트감면코드      1: 지급/면제, 2: 지급/면제 취소일때만 조립 */              
	                             +  WVOGT04.padding("", 9)              /* 멤버스차감포인트          1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding("2", 1)             /* 멤버스차감여부            1: 포인트차감 2: 포인트거부                */
	                             +  WVOGT04.padding(strAdd_Rdu_Cd, 3)   /* 추가감면코드              1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding(strAdd_Rdu_Am, 9)   /* 추가감면수수료금액        1: 지급/면제, 2: 지급/면제 취소일때만 조립 */
	                             +  WVOGT04.padding("", 1)              /* 센터메세지구분            1: 책임자에게 2: 조작자에게                */
	                             +  WVOGT04.padding("", 8)              /* 센터메시지조작자　행번    4: 센터메시지일때만 조립                   */
	                             +  WVOGT04.padding("", 8)              /* 조작자　행번              5: 지문인식일때만 조립                     */
	                             +  WVOGT04.padding("", 9)              /* 단말번호                  5: 지문인식일때만 조립                     */
	                             +  WVOGT04.padding("", 669);           /* 지문인식데이터            5: 지문인식일때만 조립                     */
                 
	               WVOGT02 sc = new WVOGT02(8000);		
	               strRtnMsg = sc.commMessage(strSendString);		
             }
%>
	    	     /* 조작자등록여부 먼저 판단 */
	    	     if(OP_RegGb()==1){
                    
	     		       if(confirm("제증명서발급의뢰서에 출력사항을 기재하시기 원하시면 \n제증명서발급의뢰서를 통장프린터에 넣어주시고 확인을 클릭하세요")){
	     		           Jesingo_Print();
	     		       } 
	    	     }

<%       }else{ %>
	     		  //alert("작업 오류로 진행이 불가합니다.");
	      	  return;
<%       }  %>
<%   }  %>
	}

  /************************ 조작자 등록여부 확인 함수 *******************************/
	function OP_RegGb()
	{
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
      	    ret = WooriDeviceForOcx.GetTerminalInfo(30);
      	    if( ret == 0 )		
      	    {
      	        msg = WooriDeviceForOcx.GetResult();
      	        
      	        var array_data = msg.split("");
                
      	        strDmno = array_data[0].substring(5,9);
      	        strTlno = array_data[2];
      	        strJmno = array_data[3];
      	        
      	        if (strTlno == ""){
      	        	  alert("조작자등록이 되어 있지 않아 전표출력이 중단되었습니다");
                    WooriDeviceForOcx.CloseDevice();
                    return 0;
      	        }
      	    }
      	    else
      	    {
      	    	   msg = WooriDeviceForOcx.GetErrorMsg(ret);
      	    	   alert(msg);
                 WooriDeviceForOcx.CloseDevice();
      	    	   return 0;
      	    }
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
	}
	
  /************************ 전표 인자 함수 *******************************/
	function Tic_Print()
	{

<%
      /* BSC 코드 뒤 공백계산 */
      String strSpace = "";
      for(int k=0 ; k < (60 - strBsccd.trim().length()) ; k++){
          strSpace = strSpace + " ";
      }

      /*  조작자성명 뒤 공백계산 */
      String strSpace2 = "";
      for(int j=0 ; j < (8 - strUserName.trim().length()) ; j++){
          strSpace2 = strSpace2 + " ";
      }

      /*  계좌번호 - 추가 */
      String strAc_no = AccountDash(strRefbnkcd,strRefchkno);
      /*  계좌번호 뒤 공백계산 */
      String strSpace3 = "";
      for(int j=0 ; j < (17 - strAc_no.trim().length()) ; j++){
          strSpace3 = strSpace3 + " ";
      }

      /*  의뢰인명 뒤 공백계산 */
      String strSpace4 = "";
      for(int j=0 ; j < (16 - strIngcltnm.trim().length()) ; j++){
          strSpace4 = strSpace4 + " ";
      }

      /*  수수료금액 , 추가 */
      String strSsrcomAm = NumberToMoney(strSsrssram);
      /*  수수료금액 앞 공백계산 */
      String strSpace5 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace5 = strSpace5 + " ";
      }
      strSpace5 = strSpace5 + "￦";
      
      
      /* 현금대체 구분 */
      String strCsDc_gb = "";
      if(strPnt_Clss.equals("1")){
          strCsDc_gb = "현금입금";
      }else{
          strCsDc_gb = "대체입금";
    	}


if (strTmnseqno.length() < 9){
     strTmnseqno = "         ";
}
      
%>

      strData =              "\n\n\n\n\n\n\n\n\n\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n         <%=strBsccd%><%=strSpace%><%=strTellerno%><%=strTicticno%>";
      strData = strData + "\n         652000 <%=strCsDc_gb%> <%=strCurrentdt%> <%=strOutouttm.substring(0,2)%><%=strOutouttm.substring(3,5)%> 당일 <%=strUserBankCd%><%=strSosokJumCd%> <%=strTmnseqno.substring(5,9)%> <%=strUserName%><%=strSpace2%><%=strTellerno%> 1 <%=strTicticno%>";
      strData = strData + "\n             <%=strAc_no%><%=strSpace3%>        <%=strIngcltnm%><%=strSpace4%>        <%=strSpace5%><%=strSsrcomAm%>";
      strData = strData + "\n         제증명 발급수수료<%=strSpace5%><%=strSsrcomAm%>";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR(strData,2,5,12,10,51);
              if( ret != 0 )		
              {
              	alert("전표출력오류가 발생하였습니다. \n기타조회 > 증명서발급조회에서 전표 재인자 처리바랍니다.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }

  /************************ 제신고서 인자 함수 *******************************/
	function Jesingo_Print()
	{
<% 
      String strTrn_No = "";
      if (strPnt_Clss.equals("3")){
          strTrn_No = "02F800";
      }else{
      	  strTrn_No = "652000";
    	}

		  strSendString =  WVOGT04.padding("1", 1);			/* 요청 구분  (1 BSC조회)  */
		  strSendString += WVOGT04.padding(strRefchkno, strRefchkno.trim().length()) /* 계좌번호  */                                                            
		  			   + WVOGT04.padding("", 1)          
		  			   + WVOGT04.padding(strCurrentdt, 8)           /* 출력일자  */                                                            
		  			   + WVOGT04.padding("", 1)          
		  			   + WVOGT04.padding(strUserBankCd, 2) 		      /* 접속자은행코드  */                                                            
		  			   + WVOGT04.padding(strSosokJumCd, 3) 		      /* 접속자단말번호  */                                                            
		  			   + WVOGT04.padding("", 1)           
		  			   + WVOGT04.padding(strTrn_No, 6) 	            /* 거래번호        */                                                            
		  			   + WVOGT04.padding("", 1)           
		  			   + WVOGT04.padding(strOutouttm.substring(0,2), 2) 	/* 거래시간          */                                                            
		  			   + WVOGT04.padding(strOutouttm.substring(3,5), 2) 	/* 거래시간          */                                                            
		  			   + WVOGT04.padding(strOutouttm.substring(6,8), 2); 	/* 거래시간          */                                                            
      
		  WVOGT02 sc = new WVOGT02(6001);		
		  strRtnMsg = sc.commMessage(strSendString);		

      /*  조작자성명 뒤 공백계산 */
      strSpace2 = "";
      for(int j=0 ; j < (8 - strUserName.trim().length()) ; j++){
          strSpace2 = strSpace2 + " ";
      }

      /*  계좌번호 - 추가 */
      strAc_no = AccountDash(strRefbnkcd,strRefchkno);
      /*  계좌번호 뒤 공백계산 */
      strSpace3 = "";
      for(int j=0 ; j < (17 - strAc_no.trim().length()) ; j++){
          strSpace3 = strSpace3 + " ";
      }

      /*  수수료금액 , 추가 */
      strSsrcomAm = NumberToMoney(strSsrssram);
      /*  수수료금액 앞 공백계산 */
      strSpace5 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace5 = strSpace5 + " ";
      }
      strSpace5 = strSpace5 + "￦";

      /*  수수료금액 앞 공백계산 */
      String strSpace6 = "";
      for(int j=0 ; j < (11 - strSsrcomAm.trim().length()) ; j++){
          strSpace6 = strSpace6 + " ";
      }
      strSpace6 = strSpace6 + "  ";
%>

      strData =              " <%=strRtnMsg%>\n\n\n\n\n\n\n\n\n\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n         <%=strTrn_No%> <%=strUserBankCd%><%=strSosokJumCd%> <%=strTmnseqno%> <%=strUserName%><%=strSpace2%> <%=strCurrentdt%>    <%=strOutouttm%>";
      strData = strData + "\n         계좌번호 : <%=strAc_no%><%=strSpace3%>      의뢰인명 : <%=strIngcltnm%>";
<%    if (strPnt_Clss.equals("3")){%>
          strData = strData + "\n         제증명 발급수수료<%=strSpace6%><%=strSsrcomAm%> 포인트 차감";
<%    }else{%>
          strData = strData + "\n         제증명 발급수수료<%=strSpace5%><%=strSsrcomAm%>";
<%    }%>
      strData = strData + "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
      strData = strData + "\n                                                                               사전확인대상";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR2(strData,"57",5,12,10,51);
              if( ret != 0 )		
              {
              	alert("제신고서출력오류가 발생하였습니다. \n기타조회 > 증명서발급조회에서 제신고서 재인자 처리바랍니다.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }


  /************************ 영수증 인자 함수 *******************************/
	function YoungSoo_Print()
	{
<%

      /*  의뢰인길이 */
      strSpace = "";
      for(int k=0 ; k < (42 - strIngcltnm.trim().length()) ; k++){
          strSpace = strSpace + " ";
      }

      /*  계좌번호길이 */
      strSpace3 = "";
      for(int k=0 ; k < (45 - strAc_no.trim().length()) ; k++){
          strSpace3 = strSpace3 + " ";
      }

      /*  점명길이길이 */
      strSpace5 = "";
      for(int k=0 ; k < (41 - strBelbrnnm.trim().length()) ; k++){
          strSpace5 = strSpace5 + " ";
      }


%>
      strData =              "\n\n\n";
//    strData = strData + "\n 0        1         2         3         4         5         6";
//    strData = strData + "\n 1234567890123456789012345678901234567890123456789012345678901234567890";
      strData = strData + "\n                   <%=strIngcltnm%><%=strSpace%><%=strCurrentdt.substring(0,4)%>년 <%=strCurrentdt.substring(4,6)%>월 <%=strCurrentdt.substring(6,8)%>일";
      strData = strData + "\n                   <%=strAc_no%><%=strSpace3%>제증명 발급수수료";
      strData = strData + "\n";
<%    if (strPnt_Clss.equals("3")){%>
          strData = strData + "\n       금 <%=strSsrcomAm%> 포인트";
          strData = strData + "\n";
          strData = strData + "\n       위 포인트를 정히 영수합니다";
<%    }else{%>
          strData = strData + "\n       금 ￦<%=strSsrcomAm%> 원정";
          strData = strData + "\n";
          strData = strData + "\n       위 금액을 정히 영수합니다";
<%    }%>
      strData = strData + "\n\n\n\n\n\n\n\n\n\n\n\n";
      strData = strData + "\n                        <%=strBelbrnnm%><%=strSpace5%><%=strUserName%>";
      
      ret = WooriDeviceForOcx.OpenDevice();
      if( ret == 0 )
      {	
          //ret = WooriDeviceForOcx.GetAccountPrintControl();
			    //if( ret == 0 )
			    //{		
              ret = WooriDeviceForOcx.PrintPBPR(strData,5,5,12,10,51);
              if( ret != 0 )		
              {
              	alert("영수증출력오류가 발생하였습니다. \n기타조회 > 증명서발급조회에서 영수증 재인자 처리바랍니다.");
              	//msg = WooriDeviceForOcx.GetErrorMsg(ret);
              	//alert(msg);
               	//WooriDeviceForOcx.ReleaseAccountPrintControl();
              	WooriDeviceForOcx.CloseDevice();
              	return 0;
              }             
          //}
          //WooriDeviceForOcx.ReleaseAccountPrintControl();
      }
      WooriDeviceForOcx.CloseDevice();
      return 1;
  }
              
 	</script> 
 	
<script language="VBScript">

	Dim WQueue: WQueue = "gmstonbs" '연결시스템 이름 WQueue
	Dim RQueue: RQueue = "nbstogms" '연결시스템 이름 RQueue

'GWBS

	Sub window_onLoad
		Call objQueue.OpenReadQueue("", RQueue)
		
	End Sub
			
	Sub SendMQ()
		Call objQueue.Clear				' 우선적으로 데이터를 클리어한다

		'공통부의 데이터를 채운다
		Call objQueue.CommonManager.AddStr("8BFC3350075F11EE90E000246E28251C034315  A1610001  122001    ", "00", "1")
    '데이터부의 데이터를 채운다
    Call objQueue.DataManager.AddStr  ("0003", "0", "<%=strSsrcomAm%>") 
    Call objQueue.DataManager.AddStr  ("0004", "0", "<%=strSsrcomAm%>") 


		'실제로 해당 큐를 열고, 기록한다.
		Call objQueue.OpenWriteQueue("", WQueue)
		Call objQueue.Send(WQueue)
	End Sub

</script>
 	
 	
 	  
 	</HEAD>     
 	<body onLoad="javascript:PrintPBPR();">
   <OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
   </OBJECT>
    <OBJECT id="objQueue"  classid="CLSID:0982F296-66BF-42DF-AD01-0BD01D0F0EE0"></OBJECT>
		<br>      
		<!--	codebase="http://10.250.19.118/ocx/WooriBank.cab#version=2,2,2,2">	
-->         	
		<br> 	</body>
 	</HTML>					
            	
<%          	
}           	
catch (IOException e)
{
	//System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep + ":Exception:" + e.toString());		
	
	strTemp = "WJOER01.jsp"
			+ "?field_error_code=" 
			+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_04")
			+ "&field_error_msg="
			+ java.net.URLEncoder.encode(e.toString())
			+ "&field_error_action=window.close()";		
 	response.sendRedirect(strTemp);									
}
catch (Exception e) 
{	
	//System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());
	System.err.println(getCurrentDate("yyyy-MM-dd hh:mm:ss") + " >" + strJspName + ":" + strJspStep + ":Exception:" + e.toString());		
	
	strTemp = "WJOER01.jsp"
			+ "?field_error_code=" 
			+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_05")
			+ "&field_error_msg="
			+ java.net.URLEncoder.encode(e.toString())
			+ "&field_error_action=window.close()";		
 	response.sendRedirect(strTemp);												
}
finally
{	
	strJspStep = "external block";
	
	try
	{ 	
		if (rset1 != null)
		{
			rset1.close();
		}
		
		if (stmt1 != null)
		{
			stmt1.close();
		}
		
		if (conn != null)
		{
			conn.close();
		}					
	} 
	catch (SQLException e) 
	{
		System.err.println(strJspName + ":" + strJspStep + ":" + e.toString());		

		if (conn != null)
		{
			conn.close();
		}							
		
		strTemp = "WJOER01.jsp"
				+ "?field_error_code=" 
				+ java.net.URLEncoder.encode(strJspName + ":" + strJspStep + ":" + "ERR_FINALLY")
				+ "&field_error_msg="  
				+ java.net.URLEncoder.encode(e.toString());
	 	response.sendRedirect(strTemp);			
	}
}   
%>