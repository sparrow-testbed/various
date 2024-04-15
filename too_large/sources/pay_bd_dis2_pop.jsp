<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<Script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/loadingLayer.js"></Script>
<%-- TOBE 2017-07-01 점코드 글로벌 상수 --%>
<%@  page import="sepoa.svc.common.constants" %>
<%! String gam_jum_cd = constants.DEFAULT_GAM_JUMCD; %>
<%! String ict_jum_cd = constants.DEFAULT_ICT_JUMCD; %>
<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
<%! String acc_jum_cd = constants.DEFAULT_ACC_JUMCD; %>
<% 

    /* TOBE 2017-07-01 사용자 ID , 점코드 추가 */
    String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
    String user_jumcd	= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));

	Vector multilang_id = new Vector();

	multilang_id.addElement("TX_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap			text            = MessageUtil.getMessage(info, multilang_id);
	String      	screen_id       = "TX_003";
	String       	grid_obj        = "GridObj";
	boolean      	isSelectScreen  = false;
	String       	company_code    = info.getSession("COMPANY_CODE");
	String 		 	vendor_code	  	= JSPUtil.nullToRef(request.getParameter("vendor_code")	, "");
	String       	house_code      = info.getSession("HOUSE_CODE");
	String       	userID             = info.getSession("ID");
	String       	LB_DEAL_KIND    = ListBox(request, "SL0014", house_code + "#M803", ""); //거래구분
	String       	LB_USE_KIND     = ListBox(request, "SL0014", house_code + "#M804", ""); //용도구분(존속기간)복구충당부채사용기간
	String       	LB_BUDGET_DEPT  = ListBox(request, "SL0014", house_code + "#M805", ""); //소관부서
	String       	LB_PAY_KIND_BUD = ListBox(request, "SL0018", house_code + "#M800", "");
	String     	 	doc_no          = JSPUtil.nullToRef(request.getParameter("doc_no")	, "");
	String     	 	viewType        = JSPUtil.nullToRef(request.getParameter("viewType")	, "");
	//String     	 	statusCd        = JSPUtil.nullToRef(request.getParameter("status_cd")	, "0");
	StringBuffer 	stringBuffer    = new StringBuffer();
	
	String			VENDOR_NAME_LOC = "";
	String			IRS_NO 			= "";
	String			TOT_AMT			= "";
	String			SUP_AMT			= "";
	String			VAT_AMT 		= "";
	String			BANK_ACCT		= "";
	String          BANK_CODE       = "";
	String          DEPOSITOR_NAME  = "";
	String          userTrmNo       = "";
	String          userTrmNoFront  = null;
	String          cancleAble      = null; //TOBE 2017-07-01 추가 당일구분 'T' 당일
	
    /* 	
    AS-IS 2017-07-01
     책임자 승인 1명 : 5천만원 이상 ~ 1억원 미만 
     책임자 승인 2명 : 1억원 이상
 
    TO-BE 2017-07-01
     책임자 승인 1명 : 5천만원 이상 ~ 2억원 미만 
     책임자 승인 2명 : 2억원 이상 */

	//ASIS 2017-07-01
	//String      paySigner1 = "50000000";		//1차책임자 지정 		signerStatus:1
	//String      paySigner2 = "100000000";		//2차책임자 지정		signerStatus:2

	//TOBE 2017-07-01
	String      paySigner1    = "50000000";		//1차책임자 지정 		signerStatus:1
	String      paySigner2    = "200000000";	//2차책임자 지정		signerStatus:2
	
	String      signerStatus  = "0";		            //책임자 지정 여부    signerStatus:0
	String      totAmt        = null;
	long        totAmtInt     = 0;
	String      statusCd      = "0";
	String      statusNm      = "";
	String      app_status_cd = "10";
	String      addUserId     = "";
	String      signer1_no    = "";
	String      signer2_no    = "";
	
	String      execute_nm    = "";
	String      signer1_nm    = "";
	String      signer2_nm    = "";
	
	Object[] args = {doc_no};
	
	SepoaOut value = null;
	SepoaRemote wr = null;
	String nickName   = "TX_012";
	String conType    = "CONNECTION";
	String MethodName = "getOperateExpenseDetail";
	SepoaFormater wf = null;	
	
	try {
		wr = new SepoaRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);

		wf = new SepoaFormater(value.result[0]);
		
		//wf.getValue("TOT_AMT", 0);
		
		totAmt      = wf.getValue("TOT_AMT", 0);
		totAmtInt  = Long.parseLong(totAmt);
		
		statusCd    = wf.getValue("STATUS_CD", 0);
		statusNm    = wf.getValue("STATUS_NM", 0);
		app_status_cd = wf.getValue("APP_STATUS_CD", 0);
		addUserId  = wf.getValue("ADD_USER_ID", 0);
		signer1_no = wf.getValue("SIGNER1_NO", 0);
		signer2_no = wf.getValue("SIGNER2_NO", 0);
		userTrmNo  = wf.getValue("USER_TRM_NO", 0);
		cancleAble = wf.getValue("CANCLE_ABLE", 0);  //TOBE 2017-07-01 추가 당일구분 'T' 당일
		
		/* 2018-03-16 책임자승인시 책임자 단말번호로 수정함
		   아래 로직은 더이상 불필요함
		userTrmNoFront = userTrmNo.substring(0, 12); //TOBE 2017-07-01  9->12
		*/
		
		if( totAmtInt >= Long.parseLong(paySigner2)){		//1,2차책임자 지정
			signerStatus = "2";
		}else if(totAmtInt >= Long.parseLong(paySigner1) && totAmtInt < Long.parseLong(paySigner2) ){		//1차책임자 지정
			signerStatus = "1";
		}
		
		execute_nm    = wf.getValue("EXECUTE_NM", 0);
		signer1_nm    = wf.getValue("SIGNER1_NM", 0);
		signer2_nm    = wf.getValue("SIGNER2_NM", 0);
	
	} catch (Exception e) {
		//e.printStackTrace();
		user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));
	}
	
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_pay_bd_dis2_pop"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

Map map = new HashMap();
map.put("vendor_code"		, vendor_code);
map.put("tax_no"		, wf.getValue("TAX_NO"	, 0));
//Map<String, Object> data = new HashMap();
//data.put("header"		, map);

Object[] obj2 = {map};
SepoaOut value2= ServiceConnector.doService(info, "TX_012", "CONNECTION", "getItemList", obj2);
SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
		_rptData.append(wf.getValue("NTS_APP_NO"	, 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("ACC_TAX_DATE"	, 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("ACC_TAX_SEQ"	, 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("VENDOR_NAME"   , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("IRS_NO"   , 0));
		_rptData.append(_RF);
		_rptData.append(statusNm);
		_rptData.append(_RF);
		_rptData.append(wf.getValue("TOT_AMT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("SUPPLY_AMT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("TAX_AMT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("BANK_CODE_TEXT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("BANK_ACCT"     , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("DEPOSITOR_NAME", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("BMSBMSYY"      , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("BUGUMCD"       , 0));
		_rptData.append(" ");
		_rptData.append(wf.getValue("BUGUMNM"       , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("ACT_DATE"      , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("EXPENSECD_TEXT", 0));		
		_rptData.append(_RF);
		_rptData.append(wf.getValue("SEMOKCD_TEXT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("SEBUCD_TEXT", 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("ZIPHANGCD_TEXT", 0));
		_rptData.append(" ");
		_rptData.append(wf.getValue("DOC_TYPE", 0));
		_rptData.append("-전자세금계산서");
		_rptData.append(_RF);
		_rptData.append(wf.getValue("PAY_TYPE", 0));
		_rptData.append("-대체");
		_rptData.append(_RF);
		_rptData.append(wf.getValue("SAUPCD"        , 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("PAY_REASON"		, 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("PYDTM_APV_NO"		, 0));
		_rptData.append(_RF);
		_rptData.append(wf.getValue("SLIP_NO"		, 0));
		
		_rptData.append(_RF);
		if(!"".equals(wf.getValue("EXECUTE_NO", 0)) && !"".equals(wf.getValue("SIGNER1_NO", 0))  && !"".equals(wf.getValue("SIGNER2_NO", 0))){
			_rptData.append(execute_nm);
			_rptData.append("<BR>");
			_rptData.append(wf.getValue("EXECUTE_NO", 0));	
			_rptData.append(_RF);
			_rptData.append(signer1_nm);
			_rptData.append("<BR>");
			_rptData.append(wf.getValue("SIGNER1_NO", 0));
			_rptData.append(_RF);
			_rptData.append(signer2_nm);
			_rptData.append("<BR>");
			_rptData.append(wf.getValue("SIGNER2_NO", 0));
		}else{
			if(!"".equals(wf.getValue("EXECUTE_NO", 0))){
				_rptData.append(execute_nm);
				_rptData.append(" (");
				_rptData.append(wf.getValue("EXECUTE_NO", 0));
				_rptData.append(")");
			}	
			_rptData.append(_RF);
			if(!"".equals(wf.getValue("SIGNER1_NO", 0))){
				_rptData.append(signer1_nm);
				_rptData.append(" (");
				_rptData.append(wf.getValue("SIGNER1_NO", 0));
				_rptData.append(")");
			}		
			_rptData.append(_RF);
			if(!"".equals(wf.getValue("SIGNER2_NO", 0))){
				_rptData.append(signer2_nm);
				_rptData.append(" (");
				_rptData.append(wf.getValue("SIGNER2_NO", 0));
				_rptData.append(")");
			}	
		}
		_rptData.append(_RD);			
		if(wf2 != null) {
			if(wf2.getRowCount() > 0) { //데이타가 있는 경우
				for(int i = 0 ; i < wf2.getRowCount() ; i++){
					_rptData.append(wf2.getValue("ITEM_NAME", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("SPEC", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("QTY", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("PRICE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("SUPPLIER_PRICE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("TAX_PRICE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("TOT_PRICE", i));
					_rptData.append(_RF);			
					//_rptData.append(wf2.getValue("ACCOUNT_TYPE", i));
					//_rptData.append(_RF);			
					_rptData.append(wf2.getValue("REMARK", i));
					_rptData.append(_RL);			
				}
			}
		}		
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////			
	
	
%>
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%-- <jsp:include page="/include/sepoa_multi_grid_common.jsp" > --%>
<%--   			<jsp:param name="screen_id" value="TX_003"/>   --%>
<%--  			<jsp:param name="grid_obj" value="GridObj_1"/> --%>
<%--  			<jsp:param name="grid_box" value="gridbox_1"/> --%>
<%--  			<jsp:param name="grid_cnt" value="2"/> --%>
<%-- </jsp:include> --%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
	var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_ins2";
	var GridObj = null;
	var MenuObj = null;
	var myDataProcessor = null;

 
	/* TOBE 2017-07-01 통합단말 관련 변수 */
	var strSourceSystem = "EPS";	// 송신 시스템 코드
	var strTargetSystem = "UTM";    // 수신 시스템 코드 //- (통합단말) UTM(리얼), UTM_D(개발), UTM_T(테스트), UTM_Y(연수) 
	var isApvRncd       = null;     //TOBE 2017-07-01 책임자 승인 사유 코드
	var bioCallPoint    = null;     //지문호출위치
	
	function Init() {	//화면 초기설정 
		
	
	    /* TOBE 2017-07-01 추가 */
	    var nResult = XFramePLUS.StartCopyData(true, strSourceSystem);// WM_COPYDATA 메시지를 수신하기 위한 윈도우 생성{필수}
	    if(nResult != 1) {alert("수신 윈도우 생성 시 오류 발생");}

		setGridDraw();
		//ASIS 2017-07-01 아래로 이동 GetBrowserInfo(document.form1);
		doSelect2();
		

		var pydtm_apv_no = $('#pydtm_apv_no').val();
		var slip_no            = $('#slip_no').val();
		//var pay_signer1     = $('#pay_signer1').val();
		//var pay_signer2     = $('#pay_signer2').val();
		var tot_amt           = $('#tot_amt').val();
		
		/*
  		경상비 처리 코드(statudCd)
		10 : 저장
		20 : 지급결의승인
		30 : 책임자지정
		40 : 1차책임자 승인
		90 : 경비집행완료
		99 : 폐기
 		*/
 		var statusCd = '<%=statusCd%>';
 		var app_status_cd = '<%=app_status_cd%>';//E:결재완료,M:지급결의완료
 		var totAmtInt = '<%=totAmtInt%>'*1;
 		var paySigner1 = '<%=paySigner1%>'*1;
 		var paySigner2 = '<%=paySigner2%>'*1;
 		
 		var userID     = '<%=userID%>';
 		var signer1_no     = '<%=signer1_no%>';
 		var signer2_no     = '<%=signer2_no%>';
 		var cancleAble     = '<%=cancleAble%>'; //TOBE 2017-07-01 추가 당일구분 'T' 당일
 		
 		 $('#app_status_cd').val(app_status_cd); //TOBE 2017-07-01 추가 상태코드 (서블릿에 코드값을 넘기기 위해)
 		 
 		 
 		//지급결의완료여부
 		if(app_status_cd=='M' || //결재완료
 		   (("T"==cancleAble) && (app_status_cd=='A' )) ){ //TOBE 2017-07-01 추가 당일이면서 경비집행 인건
 			//지급결의했음
 			$('#tdBEB00730T02').hide();//경비지급결의 버튼
 			
 			//5천미만일경우 총무부의 경우 무조건 경비집행 가능하다
 			if(totAmtInt < paySigner1){
 				//5천만원 미만일때
 				$('#tdSignerSet').hide();//책임자지정 버튼
 			    $('#tdSignerApp1').hide();//1차책임자승인 버튼
 				$('#tdBEB00730T03').show();//경비집행 버튼
 			}else{
 				//5천만원이상일때
 				
 				//책임자 지정 여부
 				if(statusCd=='20'){ //지급결의완료상태(책임자지정 안했음)
 					$('#tdSignerSet').show();//책임자지정 버튼
 					$('#tdSignerApp1').hide();//1차책임자승인 버튼
 	 				$('#tdBEB00730T03').hide();//경비집행 버튼
 				}
 				//책임자지정완료상태
 				if(statusCd=='30'){
 					$('#tdSignerSet').hide();//책임자지정 버튼
 					$('#tdSignerApp1').hide();//1차책임자승인 버튼
 					$('#tdBEB00730T03').hide();//경비집행 버튼
 					
 					//2억미만의경우
 					if(totAmtInt < paySigner2){
 						if(userID==signer1_no){
 							$('#tdBEB00730T03').show();//경비집행 버튼	
 						}
 					}
 					//2억 이상인경우
					if(totAmtInt >= paySigner2){
						if(userID==signer1_no){
							$('#tdSignerApp1').show();//1차책임자승인 버튼	
 						}					
					}
 				}
 				//1차책임자승인완료상태
 				if(statusCd=='40'){
 					$('#tdSignerSet').hide();//책임자지정 버튼
 					$('#tdSignerApp1').hide();//1차책임자승인 버튼
 					$('#tdBEB00730T03').hide();//경비집행 버튼 					
 					//로그인한사람이 지정된 책임자일경우 ( [C202111160039] [2021-12-17] (변원상)전자구매 중요거래 중복실행 로직 보강 )
 					if(userID==signer2_no){
						$('#tdBEB00730T03').show();//경비집행 버튼
					}
 				}
 				
 			}
 		}else if(app_status_cd=='A' ) {
 			//TOBE 2017-07-01 추가 경비집행 (당일이 지나면 더이상 집행할수 없다(책임자승인명세))
 			$('#tdBEB00730T02').hide();//경비지급결의 버튼
 			$('#tdSignerSet').hide();//책임자지정 버튼
 			$('#tdSignerApp1').hide();//1차책임자승인 버튼
 			$('#tdBEB00730T03').hide();//경비집행 버튼
 		}else{
 			//지급결의안했음
 			$('#tdBEB00730T02').show();//경비지급결의 버튼
 			$('#tdSignerSet').hide();//책임자지정 버튼
 			$('#tdSignerApp1').hide();//1차책임자승인 버튼
 			$('#tdBEB00730T03').hide();//경비집행 버튼
 		}
 		
 		
 		<%--
 		//TOBE 2017-07-01 총무부가 아닐경우 버튼 숨김
 		if("<%=user_jumcd%>" != "<%=gam_jum_cd%>") {
 			$('#tdBEB00730T03').hide();//경비집행 버튼
 			$('#tdSignerSet').hide();//책임자지정 버튼
 		}
 		--%>
 		<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
 		if("<%=user_jumcd%>" != "<%=acc_jum_cd%>") {
 			$('#tdBEB00730T03').hide();//경비집행 버튼
 			$('#tdSignerApp1').hide();//1차책임자승인 버튼
 			$('#tdSignerSet').hide();//책임자지정 버튼
 		}
 		
				
				
 		/*
		if(LTrim(pydtm_apv_no).length > 0){//지급결의번호가 있으면 경비지급결의 버튼히든
			$('#tdBEB00730T02').hide();
		}else{
			$('#tdBEB00730T02').show();
		}
		if(LTrim(slip_no).length > 0){//전표번호가 있으면
			$('#tdBEB00730T03').hide();
		}else{
			$('#tdBEB00730T03').show();
		}
		*/

		//ASIS 2017-07-01 금액 5000만원 이상 1억 미만 1차책임자 지정, 금액 1억 이상 2차 책임자 지정
		//TOBE 2017-07-01 금액 5000만원 이상 2억 미만 1차책임자 지정, 금액 2억 이상 2차 책임자 지정
		<% if("2".equals(signerStatus) && Integer.parseInt(statusCd) > 10){ %>
			
		     $('#signer_status').val("2");
			<!--%if(userID.equals(addUserId)){%-->
			<%if (Integer.parseInt(statusCd) == 20){ %>
			    //TOBE 2017-07-01 통합단말 이벤트 수신후 처리로 변경 getSigner1Select();
				//TOBE 2017-07-01 통합단말 이벤트 수신후 처리로 변경 getSigner2Select();
				isApvRncd = "BOCOM00520"; //TOBE 2017-07-01 책임자 승인 사유 코드 (2억원 이상)
				//$("#tdSignerSet").show();
			<%}else{%>
		
			$('#signer1_no').append("<option value='<%=wf.getValue("SIGNER1_NO", 0)%>'><%=wf.getValue("SIGNER1_NO", 0)%></option>");
			$('#signer2_no').append("<option value='<%=wf.getValue("SIGNER2_NO", 0)%>'><%=wf.getValue("SIGNER2_NO", 0)%></option>");
			//$("#tdSignerSet").hide();
				
			<%}%>
			//tdSignerApp1.style.display = "";

		<%}else if("1".equals(signerStatus) && Integer.parseInt(statusCd) > 10){ %>
			$('#signer_status').val("1");
			//$("#tdSignerApp1").hide();
			
			<!--%if(userID.equals(addUserId)){%-->
			<%if (Integer.parseInt(statusCd) == 20){ %>
			//TOBE 2017-07-01 통합단말 이벤트 수신후 처리로 변경 getSigner1Select();
			isApvRncd = "BOCOM00014"; //TOBE 2017-07-01 책임자 승인 사유 코드 (5천만원 이상)
			//$("#tdSignerSet").show();
			<%}else{%>
			$('#signer1_no').append("<option value='<%=wf.getValue("SIGNER1_NO", 0)%>'><%=wf.getValue("SIGNER1_NO", 0)%></option>");
			//$("#tdSignerSet").hide();
			<%}%>
			//tdSignerApp1.style.display = "";
			//$("#tdSignerSet").show();
			
		<%}else{%>
			$('#signer_status').val("0");
			//$("#tdSignerApp1").hide();
			//$("#tdSignerSet").hide();

		<%}%>
		
		
		//TOBE 2017-07-01 이전화면에서 집행실행일때만 단말체크 (그외 그리드 지급번호로 호출시 단말체크 패스)
		<%if("E".equals(viewType)){%>
			GetBrowserInfo(document.form1); //TOBE 2017-07-01 통합단말정보 
			//(책임자승인목록시에도 필요하며 1,2차책임자 관련 변수선언후  단말정보가 필요하므로 단말정보 수신이벤트 처리후 책임자승인목록을 가져온다 )	
		<%}%>
		
	}


	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
	
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");
    var rtn      = "";
    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }
    if(status == "true") {
        if("ERR" == message.innerHTML.substring(0,3)){
        	rtn = message.innerHTML;
        	alert(rtn);
        }
        else if(mode == "beb00730t02"){
        	rtn = message.innerHTML.substring(0,7);
        	$('#pydtm_apv_no').val(rtn);
        	alert(messsage);
        	window.close();
        }else if(mode == "beb00730t03"){
        	rtn = message.innerHTML.substring(0,5);
        	$('#slip_no').val(rtn);
        	alert(messsage);
	        opener.doSelect();
	    	window.close();
        }else if(mode == "ICAA9010200"){  //TOBE 2017-07-01 추가 책임자승인명세
        	rtn = message.innerHTML.substring(0,5);
        	alert(messsage);
	        opener.doSelect();
	    	window.close();
        }else if(mode == "setSignerUpdate"){
        	rtn = message.innerHTML;
        	alert(messsage);
	        opener.doSelect();
	    	window.close();
        }else{
        	rtn = message.innerHTML;
        	alert("Exception:"+rtn);
        }
    } else {        
    	alert(messsage);
    	fnReload();
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    selectAll();
    return true;
}

function doSelect2()
{
	var grid_col_id = '<%=grid_col_id%>';
	
	var params = "mode=getItemList";
	params += "&cols_ids=" + grid_col_id;
	params += dataOutput();	
	
	GridObj.post(servletUrl, params);
	GridObj.clearAll(false);
}

//경비지급결의
function doSaveBEB00730T02(){

	var pydtm_apv_no = $('#pydtm_apv_no').val();
	
	if(LRTrim(pydtm_apv_no).length > 0){
		alert("경비지급결의가 이미 완료되었습니다.");
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setBEB00730T02";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(servletUrl+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
	
} 

//책임자 지정
function doSaveSignerSet(){

	var pydtm_apv_no = $('#pydtm_apv_no').val();
	var slip_no            = $('#slip_no').val();
	var signer1_no      = $('#signer1_no').val();
	var signer2_no      = $('#signer2_no').val();
	
	if(LRTrim(pydtm_apv_no).length == 0){
		alert("책임자 지정 전에 경비지급결의를 먼저 처리하셔야 합니다.");
		return;
	}
	if(LRTrim(slip_no).length > 0){
		alert("이미 경비집행이 완료되었습니다.");
		return;
	}
	
	<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
	if("<%=user_jumcd%>" != "<%=acc_jum_cd%>") {
		alert("권한이 없습니다.");
		return;
	}
	
	//금액 5000만원 이상 2억 미만 1차책임자 지정, 금액 2억 이상 2차 책임자 지정
	<% if("2".equals(signerStatus)){ %>
		if(signer1_no == ""){
			alert("1차 책임자를 선택해 주세요.");
			return;
		}
		if(signer2_no == ""){
			alert("2차 책임자를 선택해 주세요.");
			return;
		}
		//TOBE 2017-07-01 추가 1,2차 책임자 동일인 체크
		if(signer1_no == signer2_no){
			alert("책임자를 다른 사용자로 지정해 주시기 바랍니다.");
			
			return;
		}
	<%}%>
		
	<%if("1".equals(signerStatus)){ %>
			if(signer1_no == ""){
				alert("1차 책임자를 선택해 주세요.");
				return;
			}

	<%}%>
	
	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
		{
			mode        : "isHldy"
		},
		function(arg){
			
			var result  = eval("(" + arg + ")"); 
			var code    = result.code;
			var message = result.message;
			
			if(result != "0" ){
				alert("휴일거래 불가합니다.");
			}else if(result == "0" ){ 
				var grid_array = getGridChangedRows(GridObj, "SEL");
				var cols_ids = "<%=grid_col_id%>";
				var params;
				params = "?mode=setSignerUpdate";
				params += "&cols_ids=" + cols_ids;
				params += dataOutput();
				myDataProcessor = new dataProcessor(servletUrl+params);
				//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
				sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
	
} 


<%-- ASIS 2017-07-01
//1차 책임자 승인
function doSaveSigneApp1(){
	fnValidation();

	//2차 책임자 승인이 없을 경우 경비집행
<% if("1".equals(signerStatus)){ %>
		
 	if(confirm("경비집행을 실행하시겠습니까?")){
 		doSaveBEB00730T03();
 	}

<%}else if("2".equals(signerStatus)){ %>

	<% if("40".equals(statusCd)){ %>
		alert("1차 책임자 승인이 이미 완료되었습니다.");
		return;
	<%}%>


//2차 책임자 승인이 있을 경우 1차 지문 승인
		var PAY_ACT_NO = document.getElementById("pay_act_no").value;
		
		
		if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
			var frm = document.forms[0];
			
			CallBio(frm);
			
			var bio = frm.pay_act_bio.value;
			
			if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
					var PAY_ACT_BIO  = document.getElementById("pay_act_bio").value;
//					var USER_TRM_NO   = document.getElementById("user_trm_no").value;
//					USER_TRM_NO         =USER_TRM_NO.substring(0,9);
					
					$("#tdSignerApp1").hide();
					
					$.post(
						servletUrl,
						{
							mode         : "updateSpy2glSigner1",
							PAY_ACT_NO  : PAY_ACT_NO,
							PAY_ACT_BIO : PAY_ACT_BIO,
							//TXT_MNNO      : USER_TRM_NO
							TXT_MNNO      : "<%=userTrmNoFront %>"
							
						},
						function(arg){
							var result  = eval("(" + arg + ")");
							var code    = result.code;
							var message = result.message;
							
							if(code == "000"){
								alert("승인처리가 정상적으로 완료되었습니다.");
								window.close();
							}
							else{
								if(message == ""){
									message = "승인 처리에 실패하였습니다.";
								}
								
								alert(message);
								
								$("#tdSignerApp1").show();
							}
						}
					);
				}
			}
		}
<%}else{%>
	alert("책임자 승인이 필요하지 않습니다.");
	return;

<%}%>
	
}

--%>


//TOBE 2017-07-01 지문 수신 이벤트 후 처리로 변경
//1차 책임자 승인
function doSaveSigneApp1(){
	if(!fnValidation()){ fnReload(); return; }
	
	<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
	if("<%=user_jumcd%>" != "<%=acc_jum_cd%>") {
		alert("권한이 없습니다.");
		return;
	}

	//2차 책임자 승인이 없을 경우 경비집행
<% if("1".equals(signerStatus)){ %>
		
 	if(confirm("경비집행을 실행하시겠습니까?")){
 		doSaveBEB00730T03();
 	}

<%}else if("2".equals(signerStatus)){ %>

	<% if("40".equals(statusCd)){ %>
		alert("1차 책임자 승인이 이미 완료되었습니다.");
		return;
	<%}%>


//2차 책임자 승인이 있을 경우 1차 지문 승인
		$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
			{
				mode        : "isHldy"
			},
			function(arg){
				
				var result  = eval("(" + arg + ")"); 
				var code    = result.code;
				var message = result.message;
				
				if(result != "0" ){
					alert("휴일거래 불가합니다.");
				}else if(result == "0" ){ 
					if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
						var frm = document.forms[0];
						
						bioCallPoint = "doSaveSigneApp1";
						CallBio(frm);
					}
				}else if(result == "-1" ){ 
					alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
				}else{
					alert("휴일 체크중 알 수 없는 오류발생");
				}				
			}
		);
<%}else{%>
	alert("책임자 승인이 필요하지 않습니다.");
	return;

<%}%>
	
}



//1차 책임자 승인
function doSaveSigneApp1_2(){

	        var PAY_ACT_NO = document.getElementById("pay_act_no").value;
			var bio        = document.getElementById("pay_act_bio").value;
			var TXT_MNNO   = document.getElementById("txtBrowserInfo").value;
			
			if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
					var PAY_ACT_BIO  = document.getElementById("pay_act_bio").value;
//					var USER_TRM_NO   = document.getElementById("user_trm_no").value;
//					USER_TRM_NO         =USER_TRM_NO.substring(0,9);
					
					$("#tdSignerApp1").hide();
					
					$.post(
						servletUrl,
						{
							mode         : "updateSpy2glSigner1",
							PAY_ACT_NO  : PAY_ACT_NO,
							PAY_ACT_BIO : PAY_ACT_BIO,
							//TXT_MNNO      : USER_TRM_NO
							/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO      : "<%=userTrmNoFront %>" */
							TXT_MNNO    : TXT_MNNO
						},
						function(arg){
							var result  = eval("(" + arg + ")");
							var code    = result.code;
							var message = result.message;
							
							if(code == "000"){
								alert("승인처리가 정상적으로 완료되었습니다.");
								window.close();
							}
							else{
								if(message == ""){
									message = "승인 처리에 실패하였습니다.";
								}
								
								alert(message);
								
								$("#tdSignerApp1").show();
							}
						}
					);
				}
			}
	
}








//TOBE 2017-07-01 책임자 지문 승인후 실행
function doSaveSigneApp1_3(){

	        var PAY_ACT_NO = document.getElementById("pay_act_no").value;
			var bio        = document.getElementById("pay_act_bio").value;
			var TXT_MNNO   = document.getElementById("txtBrowserInfo").value;
			
			if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n승인을 진행하시겠습니까?")){	
					var PAY_ACT_BIO  = document.getElementById("pay_act_bio").value;
//					var USER_TRM_NO   = document.getElementById("user_trm_no").value;
//					USER_TRM_NO         =USER_TRM_NO.substring(0,9);
					
					//$("#tdSignerApp1").hide();
					
					$.post(
						servletUrl,
						{
							mode         : "updateSpy2glSigner1",
							PAY_ACT_NO  : PAY_ACT_NO,
							PAY_ACT_BIO : PAY_ACT_BIO,
							//TXT_MNNO      : USER_TRM_NO
							/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO      : "<%=userTrmNoFront %>" */
							TXT_MNNO    : TXT_MNNO
							
						},
						function(arg){
							var result  = eval("(" + arg + ")");
							var code    = result.code;
							var message = result.message;
							
							if(code == "000"){
								fnBioApp2();
							}
							else{
								if(message == ""){
									message = "승인 처리에 실패하였습니다.";fnReload();									
								}
								
								alert(message);
								//$("#tdSignerApp1").show();
							}
						}
					);
				}else{fnReload();}
			}else{fnReload();}
	
}











//2차 책임자 승인
function doSaveSigneApp2(){
	if(!fnValidation()){ fnReload(); return; }

}
function fnBtnShow(){
	/*
	$('#tdBEB00730T02').hide();
	$('#tdSignerSet').hide();
	$('#tdSignerApp1').hide();
	$('#tdBEB00730T03').show();
	*/
	closeLoadingLayer();	
}
function fnReload(){
	<%if("E".equals(viewType)){%>
	window.location.href = '/kr/tax/pay_bd_dis2_pop.jsp?vendor_code=<%=request.getParameter("vendor_code")%>&doc_no=<%=request.getParameter("doc_no")%>&viewType=<%=request.getParameter("viewType")%>';
	<% } %>
}
function fnBtnHide(){
	$('#tdBEB00730T02').hide();//경비지급결의 버튼
	$('#tdSignerSet').hide();//책임자지정 버튼
	$('#tdSignerApp1').hide();//1차책임자승인 버튼
	$('#tdBEB00730T03').hide();//경비집행 버튼
	showLoadingLayer();	
}
//경비집행(전표번호)
function doSaveBEB00730T03(){
	fnBtnHide();
	if(!fnValidation()){ fnReload(); return; }
	
	<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
	if("<%=user_jumcd%>" != "<%=acc_jum_cd%>") {
		alert("권한이 없습니다.");
		return;
	}
	
	var pydtm_apv_no = $('#pydtm_apv_no').val();
	var slip_no = $('#slip_no').val();
	var app_status_cd = '<%=app_status_cd%>'; //TOBE 2017-07-01 추가
	
	if(LRTrim(pydtm_apv_no).length == 0){
		alert("경비집행 전에 경비지급결의를 먼저 처리하셔야 합니다.");fnReload();
		return;
	}
	
	//ASIS 2017-07-01
	//if(LRTrim(slip_no).length > 0){
	//	alert("이미 경비집행이 완료되었습니다.");
	//	return;
	//}
	
	//TOBE 2017-07-01
	if(app_status_cd == "F"){
		alert("이미 집행완료가 되었습니다.");fnReload();
		return;
	}
	
	var PAY_ACT_NO      = document.getElementById("pay_act_no").value;
	var SIGNER_STATUS = document.getElementById("signer_status").value;
	
	$.post(
			"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svc.common.HldyInfoServlet",
		{
			mode        : "isHldy"
		},
		function(arg){
			
			var result  = eval("(" + arg + ")"); 
			var code    = result.code;
			var message = result.message;
			
			if(result != "0" ){
				alert("휴일거래 불가합니다.");fnReload();
			}else if(result == "0" ){ 
				if(SIGNER_STATUS == "1" || SIGNER_STATUS == "2"){	//책임자 이체
					if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
						fnBioApp();
					}else{fnReload();}
				}
				else{					//일반이체
					if(confirm("경비집행을 실행하시겠습니까?")){							
						fnSendAppProcess();
					}else{fnReload();}
				}
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");fnReload();			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");fnReload();
			}				
		}
	);
}


<%--ASIS 2017-07-01 //지문승인
function fnBioApp(){
	var frm = document.forms[0];
	
	CallBio(frm);
	
	var bio = frm.pay_act_bio.value;
	
	if(bio.length> 0){
		if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
			fnSendAppProcess();
		}
	}
}
--%>

//TOBE 2017-07-01 지문 수신 이벤트 후 처리로 변경
<%--//지문승인--%>
function fnBioApp(){
	var frm = document.forms[0];
	
	bioCallPoint = "fnBioApp";
	CallBio(frm);
}

<%--//지문승인--%>
function fnBioApp2(){
	
	var bio = document.getElementById("pay_act_bio").value;
	
	if(bio.length> 0){
		if(confirm("승인처리가 정상적으로 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	//ASIS 2017-07-01 "지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?"
			fnSendAppProcess();
		}else{fnReload();}
	}else{fnReload();}
}








<%--//경비집행실행--%>
function fnSendAppProcess(){
	var d = new Date();
    var HHMMSS = d.getMinutes() + ":" + d.getSeconds() + ":" + d.getMilliseconds();
	$('#HHMMSS').val(HHMMSS);	
// 	var PAY_ACT_NO   = document.getElementById("pay_act_no").value;
 	var PAY_ACT_BIO  = document.getElementById("pay_act_bio").value;
// 	var TXT_MNNO      = document.getElementById("txtMnno").value;
	
// 	$("#tdBEB00730T03").hide();

	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setBEB00730T03";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	//alert(params);
	//return;
	myDataProcessor = new dataProcessor(servletUrl+params);
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
	
	
	
}	

// validation 경비집행 
function fnValidation(){
	
	<% if("20".equals(statusCd) && !"0".equals(signerStatus)){ %>
	alert("금액이 5천만원 이상인 경우 책임자 지정이 필요합니다.");	
	return false;

	<% }else if("40".equals(statusCd) && !"2".equals(signerStatus)){ %>
		alert("경비집행 전에 1차 책임자 승인이 필요합니다.");		
		return false;
	<%}%>
	
	return true;
}

var selectAllFlag = 0;

function selectAll(){
	if(selectAllFlag == 0)
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SEL")).cell.wasChanged = true;
			GridObj.cells(j+1, GridObj.getColIndexById("SEL")).setValue("1"); 
		}
		selectAllFlag = 1;
	}
	else
	{
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			GridObj.cells(j+1, GridObj.getColIndexById("SEL")).setValue("0");
		}
	}
}


//책임자 선택

function getSigner1Select(){
	//ASIS 2017-07-01 GetManagerList(document.form1);
<%--
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:A6440019:직원명:차장:CHUNGJIHOON:10,";
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:19116877:직원명:차장:CHUNGJIHOON:10,";
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,";
	//document.getElementById("txtManagerList").value = "3 정의된 Error Message가 없습니다.0";
--%>

//TOBE 2017-07-01 책임자 승인 목록
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_app",
	{
		mode           : "getCMT90020100",
		apvrncd        : isApvRncd,
		user_trm_no    : document.getElementById("user_trm_no").value,
		txtBrowserInfo : document.getElementById("txtBrowserInfo").value
	},
	function(arg){
		var result = eval("(" + arg + ")");
		
		getSigner1SelectCallback(result);
	}
);

//TOBE 2017-08-01 바로위 pay_bd_app 에서 계정계공통에서 책임자 승인목록을 가져오면서 아래 로직까지 처리하는 것으로 변경함
<%-- 	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.CO_008_Servlet",
		{
			mode           : "selectDeviceUserJsonList",
			deviceUserInfo : document.getElementById("txtManagerList").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			getSigner1SelectCallback(result);
		}
	); --%>
}

function getSigner1SelectCallback(result){
	var signer1_no = document.getElementById("signer1_no");
	var i            = 0;
	var resultLength = result.length;
	var resultInfo   = null;
	
	try{
		if(resultLength == 0){
			alert("결재자 정보가 없습니다.");
			
			window.close();
		}
		else{
			for(i = 0; i < resultLength; i++){
				resultInfo   = result[i];
				option       = document.createElement("option");
				option.text  = resultInfo.managerName;
				option.value = resultInfo.managerNo;
				
				signer1_no.add(option, i);
			}
			
			option       = document.createElement("option");
			option.text  = "선택";
			option.value = "";
			
			signer1_no.add(option, 0);
			signer1_no.value = "<%=wf.getValue("SIGNER1_NO", 0)%>";

		}
	}
	catch(e){
		alert("결재자 정보가 없습니다.");
		
		window.close();
	}
}

function getSigner2Select(){
	//ASIS 2017-07-01 GetManagerList(document.form1);
 	<%--
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:A6440019:직원명:차장:CHUNGJIHOON:10,";
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:19116877:직원명:차장:CHUNGJIHOON:10,";
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,";
		//document.getElementById("txtManagerList").value = "3 정의된 Error Message가 없습니다.0";
	--%>
	//document.getElementById("txtManagerList").value = "31020644|0:18910407:직원명:차장:김형우3740_3:10,0:19116877:직원명:차장:장태준:10,";
	
	//TOBE 2017-07-01 책임자 승인 목록
   	$.post(
 		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_app",
		{
			mode           : "getCMT90020100",
			apvrncd        : isApvRncd,
			user_trm_no    : document.getElementById("user_trm_no").value,
			txtBrowserInfo : document.getElementById("txtBrowserInfo").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			getSigner2SelectCallback(result);
		}
	);
	
//TOBE 2017-08-01 바로위 pay_bd_app 에서 계정계공통에서 책임자 승인목록을 가져오면서 아래 로직까지 처리하는 것으로 변경함
	
<%-- 	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.CO_008_Servlet",
		{
			mode           : "selectDeviceUserJsonList",
			deviceUserInfo : document.getElementById("txtManagerList").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			getSigner2SelectCallback(result);
		}
	); --%>
}

function getSigner2SelectCallback(result){
	var signer2_no = document.getElementById("signer2_no");
	var i            = 0;
	var resultLength = result.length;
	var resultInfo   = null;
	
	try{
		if(resultLength == 0){
			alert("결재자 정보가 없습니다.");
			window.close();
		}
		else{
			for(i = 0; i < resultLength; i++){
				resultInfo   = result[i];
				option       = document.createElement("option");
				option.text  = resultInfo.managerName;
				option.value = resultInfo.managerNo;
				
				signer2_no.add(option, i);
			}
			
			option       = document.createElement("option");
			option.text  = "선택";
			option.value = "";
			
			signer2_no.add(option, 0);
			signer2_no.value = "<%=wf.getValue("SIGNER2_NO", 0)%>";
			
		}
	}
	catch(e){
		alert("결재자 정보가 없습니다.");
		window.close();
	}
}

<%-- ASIS 2017-07-01
function GetBrowserInfo(form){
	try{
		var ret = WooriDeviceForOcx.OpenDevice();
		var msg;
		
		if( ret == 0 ){
			ret = WooriDeviceForOcx.GetTerminalInfo(30);
			
			if( ret == 0 ){
				msg = WooriDeviceForOcx.GetResult();
				var arr = msg.split('');
				
				if(arr.length > 0 && arr[0].length==10){
					if(arr[1] == ""){
						alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
						window.close();
					}
					$('#bk_cd').val(arr[0].substr(0,5));
					$('#br_cd').val(arr[0].substr(5,1));
					$('#trm_bno').val(arr[0].substr(6,3));
					$('#user_trm_no').val(arr[0].substr(0,10) + arr[1]);
					$('#txtBrowserInfo').val(arr[0]);
					$('#execute_no').val(arr[1]);
					$("#txtMnno").val(arr[1]);
				}
				else{
					alert("통합 단말 정보가 올바르지 않습니다.");
					window.close();
					
				}
			}
			else{
				msg = WooriDeviceForOcx.GetErrorMsg(ret);
				
				alert(msg);
				window.close();
			}
			
			WooriDeviceForOcx.CloseDevice();
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
			
			window.close();
		}
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}
--%>

<%-- ASIS 2017-07-01
function GetManagerList(form){
	var ret = WooriDeviceForOcx.OpenDevice();
	var msg;
	
	if(ret == 0){
		var nLevel = form.txtLevel.value;
		
		ret = WooriDeviceForOcx.GetManagerList(nLevel,30);
		if(ret == 0){
			msg = WooriDeviceForOcx.GetResult();
			
			form.txtManagerList.value = msg;
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
			
			window.close();
		}
	
		WooriDeviceForOcx.CloseDevice();
	}
	else{
		msg = WooriDeviceForOcx.GetErrorMsg(ret);
		
		alert(msg);
		
		window.close();
	}
}
--%>

<%-- ASIS 2017-07-01
function CallBio(form){
	ret = WooriDeviceForOcx.OpenDevice();
	
	if(ret == 0){	
		var nWaitTime      = form.txtWait.value;
		var nPos              = form.txtPos.value;
		//var user_trm_no   = document.getElementById("user_trm_no").value;
		
		//user_trm_no         =user_trm_no.substring(0,9);
		
		ret       = WooriDeviceForOcx.GetBioControl();
		if(ret == 0){
			//ret = WooriDeviceForOcx.GetBioVerifyPos(nWaitTime, user_trm_no, nPos);
			ret = WooriDeviceForOcx.GetBioVerifyPos(nWaitTime, "<%=userTrmNoFront %>", nPos);
			
			if(ret == 0){
				msg = WooriDeviceForOcx.GetResult();
				
				form.pay_act_bio.value = msg;
			}
			else{					
				alert("지문정보 획득에 실패하였습니다.");
			}

			WooriDeviceForOcx.ReleaseBioControl();
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
		}
		
		WooriDeviceForOcx.CloseDevice();
	}
	else{
		msg = WooriDeviceForOcx.GetErrorMsg(ret);
		
		alert(msg);
	}
}
--%>









/* TOBE 2017-07-01 통합단말 사용자정보 */
function GetBrowserInfo(form){
	try{	
		// 우선적으로 데이터를 클리어한다
		XFramePLUS.clear(key);
		var key = XFramePLUS.GetQueueKeyIndex(strSourceSystem, "ZZZZZ");
		
		// 공통부(헤더)의 데이터를 채운다
		XFramePLUS.AddStr(key, "SOURCE_SYS"    , strSourceSystem ); // 송신하는 시스템코드 {필수}
		XFramePLUS.AddStr(key, "USER_ID"       , '<%=user_id%>'  ); // 행번 {필수}
 		XFramePLUS.AddStr(key, "BROWSER_INFO"  , "TRUE"          ); // 단말정보
		
		//메모리에 누적된 데이터를 확인
 		//alert(XFramePLUS.Command(key)); // 테스트 확인용 오픈시 제거
		//alert(XFramePLUS.Data(key));    // 테스트 확인용 오픈시 제거
		
 		// 송신
		var nResult = XFramePLUS.QMergeSend(strTargetSystem, key); //연결 시스템 코드 (수신대상)
		if(nResult != 1) {
			alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
			window.close();
		}
		
		// 송신 후  데이터를 클리어한다
		XFramePLUS.clear(key);
		
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}



//TOBE 2017-07-01 지문인식
function CallBio(form)
{
	// 우선적으로 데이터를 클리어한다
	XFramePLUS.clear(key);
	var key = XFramePLUS.GetQueueKeyIndex(strSourceSystem, "ZZZZZ");
	// 공통부(헤더)의 데이터를 채운다
	XFramePLUS.AddStr(key, "SOURCE_SYS"    , strSourceSystem ); // 송신하는 시스템코드 {필수}
	XFramePLUS.AddStr(key, "USER_ID"       , '<%=user_id%>'  ); // 행번 {필수}
	XFramePLUS.AddStr(key, "FINGER_PRINT"  , "TRUE"          );

	//메모리에 누적된 데이터를 확인
	//alert(XFramePLUS.Command(key)); // 테스트 확인용 오픈시 제거
	//alert(XFramePLUS.Data(key));    // 테스트 확인용 오픈시 제거
	
	// 송신
	var nResult = XFramePLUS.QMergeSend(strTargetSystem, key); //연결 시스템 코드 (수신대상)
	if(nResult != 1) {	alert("통합단말 데이터 송신 시 오류 발생");	}
	
	// 송신 후  데이터를 클리어한다
	XFramePLUS.clear(key);
}




//TOBE 2017-07-01 통합단말 수신 이벤트 발생시 호출
function recvLinkData(strQueueKeyIndex)
{
		
		/*통합단말에서 받은 DATA 담을 변수*/
		var strTargetSystem, userId, strScreenNo;
		var arrSendSeq    = new Array();
		var arrSendData   = new Array();
		
		/*통합단말에서 받은 DATA 변수에 set*/
		var nCnt = XFramePLUS.RCount(strQueueKeyIndex);
		var strCmd  = "", strData = "", strCmdAll  = "", strDataAll = "", strBrowserInfo = "", strFingerPrint = "";
		var strTRM_NO = "", strOPR_NO = "";
		
		for(var i = 0; i < nCnt ; i++){
			
			strCmd  = XFramePLUS.RCommand(strQueueKeyIndex, i); //수신 받은 데이터의 항목명
			strData = XFramePLUS.RData(strQueueKeyIndex, i);    //수신 받은 데이터의 값
			
			strCmdAll  += strCmd +"|";                          //수신항목명   확인용 ROW조립
			strDataAll += strData +"|";                         //수신데이터값 확인용 ROW조립
			
			if(strCmd == "SOURCE_SYS"){                         //시스템코드
				strTargetSystem = strData;
			}
			else if(strCmd == "USER_ID"){                       //사용자행번
				userId = strData;
			}
			else if(strCmd == "SCREEN_NO"){                     //거래화면일련번호
				strScreenNo = strData;
			}
			else if(strCmd == "BROWSER_INFO"){                  // 단말정보 (단말번호,사용자ID,텔러번호,지점번호(혹은대행점))
				
				strBrowserInfo = strData;
				//alert("단말정보 : " + strBrowserInfo ); // 테스트 확인용 오픈시 제거
				
				strTRM_NO = strBrowserInfo.substr(7,12); //단말번호
				strOPR_NO = strBrowserInfo.substr(27,8); //사용자ID
					
				$('#user_trm_no').val(strTRM_NO+strOPR_NO);  //020644DD008919010045
				$('#txtBrowserInfo').val(strTRM_NO);         //020644DD0089
				$('#execute_no').val(strOPR_NO);
			}
			else if(strCmd == "FINGER_PRINT"){  // 지문정보
				strFingerPrint = strData;
				//alert("지문인식 1: " + strFingerPrint ); // 테스트 확인용 오픈시 제거
				
				$('#pay_act_bio').val("");
				$('#pay_act_bio').val(strFingerPrint);
				//$('#pay_act_bio').val("5DFB42EAC39AA569B871878AE6F2FDBDE58470FC737AC478A0A1C612A065560AF4102851FC711248A835D7FE973C1FD2E85B4D219ADEAE33E26B1EB531E23475D48D38E42F6B0811CAF5C537C2AC85519A4BBF1CF3F3463F020E01559A2BD080E3F716EFA84D1F58A90A0B0B8CA2DC946F98B40C691EE023EE265BE8E619188FDCB472037727E1487BEAA370C52187965810129E887BA5B191F060BE1714D807F57F61A35F3BAFCD7DF1C286B32A2AF430DD78F539FDE1A24DC316ACA3DD32B11AEC5598125F71C5C281DD774CD9357CA956AA2961985B8327CC72283349EE09781ED0E43310E70A6F475B600228F46230935A6DBFB83C53F750CBE073E598C92EF8E88D815822BC87A57B85D343C6DF135EE54D7B9D8BD2B481EAA16F7A0D168610826B5DB21FA03AB7B3B1B35B81F4152BED63D897C14BC5B15F9BC373011D12C76077D495AFF38955D63C711D2E079A08B705F92D77B2EDF97EC709991E4E2024B1C4C0E0A94CD1E6C0C9DE790B2F3591AB0E95AC243278A29F33060934FD254E1D5CFF0FAE4D8C8FD2B9BF7DEBEF484E2E8B5A70B2187C077CD099C899155F861E55114B6B95A60FC4185A1DF4F29D01682DC057A0429D89807246EFE10D339BAA892AD31E8E83CB9443F4CC0BA99105325C52485A51686B4F2AF0A93AC3B9D72AA0A48175BD3E55BB97EF4FF2BB056D2FEC5DD941893742B0494603DC78DC590AA90C2410ED4109EBF60477D28DFAC9A6F1CC4DC9659FD281CEF6A88D443CB5E6039383D05AD7D2C2F131D96609EA76A9C1B8C1C87D5DC28B9150EA091EFB80ABC63CABC44ECB1EF342C0C1C1A9604C2413BC2785006799755274A7011F64CCC496C5BB9CC8214FBD7B5F1632BAB1E9F31FFD21D286012FAFA02C4A9C94F206348E07996E83F825FB3941C477F4796B2D43C748B8FF7B21030F26756029");
			}
			else if(strCmd.substr(0,1) == "S"){
				arrSendSeq.push( strCmd.substr(1,4) );
				arrSendData.push( strData );
			}
		}
		
	 if(strCmd == "BROWSER_INFO" && strOPR_NO != "<%=info.getSession("ID") %>"){
			alert("통합 단말과 로그인 사용자 정보가 일치하지 않습니다.");
			window.close();
	 }
	 else if(strCmd == "BROWSER_INFO") {
	        
	        if(isApvRncd == "BOCOM00014"){ //승인사유코드 (5천만원 이상)
	        	getSigner1Select(); //1차 책임자승인목록
			}
	        else if(isApvRncd == "BOCOM00520"){ //승인사유코드 (2억원 이상)
	        	getSigner1Select(); //1차 책임자승인목록
				getSigner2Select(); //2차 책임자승인목록
			}
	        
     }
	 else if(strCmd == "FINGER_PRINT" ) {      //지문정보
		 
		 //alert("지문인식2 : " + $('#pay_act_bio').val() );           // 테스트 확인용 오픈시 제거
		 if(bioCallPoint == "doSaveSigneApp1") {   
			 doSaveSigneApp1_2();
		 }
		 else if(bioCallPoint == "fnBioApp") {   
			 doSaveSigneApp1_3(); //책임자 지문 승인후 실행
			 //fnBioApp2();         //경비집행  //TOBE 2017-08-24 오픈시 주석 처리해야함
		 }
	 }

     //alert(strQueueKeyIndex); // 테스트 확인용 오픈시 제거
     //alert(strCmdAll);        // 테스트 확인용 오픈시 제거
     //alert(strDataAll);       // 테스트 확인용 오픈시 제거

     XFramePLUS.RClear(strQueueKeyIndex); // 수신 받은 데이터 삭제
     bioCallPoint = null;
     
}
<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	if(typeof(rptAprvData) != "undefined"){
		document.form1.rptAprvUsed.value = "Y";
		document.form1.rptAprvCnt.value = approvalCnt;
		document.form1.rptAprv.value = rptAprvData;
    }
    var url = "/ClipReport4/ClipViewer.jsp";
	//url = url + "?BID_TYPE=" + bid_type;	
    var cwin = window.open("","ClipReport4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=0,top=0");
	document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "ClipReport4";
	document.form1.submit();
	cwin.focus();
}
</script>

</script>

<!-- TOBE 2017-07-01 통합단말 수신 이벤트 -->
<script language="JavaScript" for=XFramePLUS event="onqrecvcopydata(strQueueKeyIndex)">
	recvLinkData(strQueueKeyIndex);
</script>


</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">
<form id="form1" name="form1" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>	
	<input type="hidden"    id="tax_no"             name="tax_no"           value="<%=wf.getValue("TAX_NO"	, 0) %>" />
	<input type="hidden"    id="pay_act_no"        name="pay_act_no"     value="<%=doc_no%>" />
	<input type="hidden"    id="msg_dscd"          name="msg_dscd"       value="020" />

	<INPUT type="hidden" id="txtWait"              name="txtWait"        size="10" value="30" /> 
	<INPUT type="hidden" id="txtPos"               name="txtPos"          size="10" value="5"	/>
	<INPUT type="hidden" id="txtMnno"            name = "txtMnno" />
	
	<input type="hidden"    id="signer_status"     name="signer_status"    value="0" />
	<input type="hidden"    id="execute_no"        name="execute_no"     value="" />
	<input type="hidden"    id="tot_amt"           name="tot_amt"           value="<%=wf.getValue("TOT_AMT", 0)%>" />

	<input type="hidden"    id="bk_cd"              name="bk_cd"            value="">
	<input type="hidden"    id="br_cd"              name="br_cd"            value="">
	<input type="hidden"    id="trm_bno"          name="trm_bno"          value="">
	<input type="hidden"    id="user_trm_no"      name="user_trm_no"      value="">
	<input type="hidden"    id="txtBrowserInfo"   name="txtBrowserInfo"   value="">
	<INPUT type="hidden"  id="txtLevel"            name="txtLevel"         value="10">
	<INPUT type="hidden"  id="txtManagerList"   name="txtManagerList"   value="">
	<INPUT type="hidden"  id="app_status_cd"   name="app_status_cd"   value=""> <!-- TOBE 2017-07-01 추가 상태코드 -->
	<INPUT type="hidden"  id="HHMMSS"   name="HHMMSS"   value="">
	
	<INPUT type="hidden"  id="BANK_ACCT"        name="BANK_ACCT"         value="<%=wf.getValue("BANK_ACCT"     , 0)%>">
	<INPUT type="hidden"  id="VENDOR_NAME_LOC"  name="VENDOR_NAME_LOC"   value="<%=wf.getValue("DEPOSITOR_NAME", 0)%>">
	
	<TEXTAREA style="display:none" name="pay_act_bio" id="pay_act_bio" rows="10" cols="10"></TEXTAREA>
<%
	if("D".equals(viewType)){
%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">
				경상비지급 상세
			</td>
			<TABLE	align="right" id="tdPrint">
			<td>
				<script language="javascript">btn("javascript:clipPrint();", "출 력");</script>
			</td>
			<td>
				<script language="javascript">btn("javascript:window.close()","닫 기");</script>
			</td>
			</TABLE>
		</tr>
	</table>
<%		
	}
%>
	
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;
			<%-- statusCd = '<%=statusCd%>'  app_status_cd = '<%=app_status_cd%>' totAmtInt = '<%=totAmtInt%>' signer1_no = '<%=signer1_no%>' signer2_no = '<%=signer2_no%>' userId = <%=userID%> --%>
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
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;국세청승인번호</td>
									<td width="20%" class="data_td"><%=wf.getValue("NTS_APP_NO"	, 0) %></td>
 									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계산서등록일자</td>
 									<td width="20%" class="data_td"><%=wf.getValue("ACC_TAX_DATE"	, 0) %></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계산서등록일련번호</td>
									<td width="20%" class="data_td"><%=wf.getValue("ACC_TAX_SEQ"	, 0) %></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
	<br />
	
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체명</td>
									<td class="data_td" width="20%"><%=wf.getValue("VENDOR_NAME"   , 0) %></td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;주민사업자번호</td>
									<td class="data_td" width="20%"><%=wf.getValue("IRS_NO"   , 0)%>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
									<td class="data_td" width="20%"><%=wf.getValue("STATUS_NM"   , 0)%>
									</td>
								</tr>
						    	<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;집행금액</td>
									<td class="data_td" width="20%"><%=SepoaMath.SepoaNumberType(wf.getValue("TOT_AMT", 0), "###,###,###,###,###,###") %>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급가액</td>
									<td class="data_td" width="20%"><%=SepoaMath.SepoaNumberType(wf.getValue("SUPPLY_AMT", 0), "###,###,###,###,###,###") %>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세액</td>
									<td class="data_td" width="20%"><%=SepoaMath.SepoaNumberType(wf.getValue("TAX_AMT", 0), "###,###,###,###,###,###") %>
									</td>
								</tr>
						    	<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금은행</td>
									<td class="data_td" width="20%">
										<select id="bank_code" name="bank_code" disabled="disabled">
											<option value="">선택</option>
											<%
												String comstr = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M349", wf.getValue("BANK_CODE"     , 0));
												out.print(comstr);
											%>
										</select> 
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금은행계좌번호</td>
									<td class="data_td" width="20%" ><%=wf.getValue("BANK_ACCT"     , 0)%>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예금주명</td>
									<td class="data_td" width="20%" ><%=wf.getValue("DEPOSITOR_NAME", 0)%>
									</td>
								</tr>								
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예산년도</td>
									<td class="data_td" width="20%"><%=wf.getValue("BMSBMSYY"      , 0) %></td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부점코드</td>
									<td class="data_td" width="20%"><%=wf.getValue("BUGUMCD"       , 0) + "  " +  wf.getValue("BUGUMNM"       , 0)%>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결의일자</td>
									<td class="data_td" width="20%"><%=wf.getValue("ACT_DATE"      , 0) %></td>
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;경비코드</td>
									<td class="data_td" width="20%">
										<select id="expensecd" name="expensecd" disabled="disabled">
											<%
												String comstr1 = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M810", wf.getValue("EXPENSECD"     , 0));
												out.print(comstr1);
											%>
										</select> 									
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세목코드</td>
									<td class="data_td" width="20%">
											<%
											if(wf.getValue("SEMOKCD"     , 0).length()>0){
												out.print("<select id='semokcd' name='semokcd' disabled='disabled'>");
												String comstr2 = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M811", wf.getValue("SEMOKCD"     , 0));
												out.print(comstr2);
												out.print("</select> ");
											}
											%>
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세부코드<br />&nbsp;&nbsp;&nbsp;&nbsp;/집행대상장소코드</td>
									<td class="data_td" width="20%">&nbsp; 
											<%
											if(wf.getValue("SEBUCD"     , 0).length()>0){
												out.print("<select id='sebucd' name='sebucd' disabled='disabled'>");
												String comstr3 = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M812", wf.getValue("SEBUCD"     , 0));
												out.print(comstr3);
												out.print("</select> ");
											}
											%>
										<br />		
										&nbsp; 
											<%
											if(wf.getValue("ZIPHANGCD"     , 0).length() > 0){
												out.print("<input type='hidden' id='ziphangcd' name='ziphangcd' value='"+ wf.getValue("ZIPHANGCD"     , 0) +"'/>");
												out.print(wf.getValue("ZIPHANGNM"     , 0));
												/* out.print("<select id='ziphangcd' name='ziphangcd' disabled='disabled'>");
												String comstr4 = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M813", wf.getValue("ZIPHANGCD"     , 0));
												out.print(comstr4);
												out.print("</select> "); */
											}
											%>
									</td>
								</tr>
						    	<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;증빙구분</td>
									<td class="data_td" width="20%"><%=wf.getValue("DOC_TYPE", 0) %>-전자세금계산서</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;금액구분</td>
									<td class="data_td" width="20%"><%=wf.getValue("PAY_TYPE", 0) %>-대체</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업코드</td>
									<td class="data_td" width="20%"><%=wf.getValue("SAUPCD"        , 0) %></td>
								</tr>									
						    	<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급사유</td>
									<td class="data_td" width="20%" colspan="5"><%=wf.getValue("PAY_REASON"		, 0) %></td>
								</tr>									
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>	
	</br>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급결의승인번호</td>
									<td width="20%" class="data_td"><input type="text" name="pydtm_apv_no" id="pydtm_apv_no" value="<%=wf.getValue("PYDTM_APV_NO"		, 0) %>" readonly /></td>
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  			
								<% if("1".equals(signerStatus)  && Integer.parseInt(statusCd) > 10){ %>					
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;1차책임자</td>
									<td width="20%" class="data_td"><select id="signer1_no"></select></td>
									<td width="13%" class="title_td">&nbsp;</td>
									<td width="20%" class="data_td"></td>
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
								</tr>
								<tr >
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								
								<%}else if("2".equals(signerStatus)  && Integer.parseInt(statusCd) > 10){ %>
								<tr>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;1차책임자</td>
									<td width="20%" class="data_td"><select id="signer1_no"></select></td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;2차책임자</td>
									<td width="20%" class="data_td"><select id="signer2_no"></select></td>
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
								</tr>
								<tr >
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>  								
								<%} %>
								<tr >
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전표번호</td>
									<td width="20%" class="data_td"><input type="text" name="slip_no" id="slip_no" value="<%=wf.getValue("SLIP_NO"		, 0) %>" readonly /></td>
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
									<td width="15%" class="title_td">&nbsp;
									<td width="20%" class="data_td">&nbsp;
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
    		<td height="30" align="right">
    		<%
				if(! "D".equals(viewType)){
			%>
            	<TABLE cellpadding="0">
                	<TR>                	
                        <TD id="tdBEB00730T02" style="display:none"><script language="javascript">btn("javascript:doSaveBEB00730T02();" ,"경비지급결의")   		</script></TD> 
                        <TD id="tdSignerSet" style="display:none"><script language="javascript">btn("javascript:doSaveSignerSet();" ,"책임자지정")   		</script></TD> 
                        <TD id="tdSignerApp1" style="display:none"><script language="javascript">btn("javascript:doSaveSigneApp1();" ,"1차책임자승인")   		</script></TD> 
                        <%-- <TD id="tdSignerApp2"><script language="javascript">btn("javascript:doSaveSignerApp2();" ,"2차책임자승인")   		</script></TD> --%> 
                        <TD id="tdBEB00730T03" style="display:none"><script language="javascript">btn("javascript:doSaveBEB00730T03();"    ,"경비집행")   		</script></TD>
                    </TR>
                </TABLE>
            <%
				}
            %>
            </td>
        </tr>
    </table>
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_003" grid_obj="GridObj" grid_box="gridbox" height="200" /> --%>

<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>


<!-- ASIS 2017-07-01
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
 -->
<!-- TOBE 2017-07-01 -->
<object ID="XFramePLUS" CLASSID="CLSID:D6091B5A-D59C-454b-83A4-FA489E94BE0B" width=0 height=0 VIEWASTEXT></object>
 
</body>
</html>