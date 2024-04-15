<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<Script type="text/javascript" src="<%=POASRM_CONTEXT_NAME%>/js/loadingLayer.js"></Script>
<%
    /* TOBE 2017-07-01 사용자 ID 추가 */
    String user_id 		= JSPUtil.nullToEmpty(info.getSession("ID"));

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
	String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
	
	String btnFlag = "";
	if("20161230".equals(current_date)){ btnFlag = "style='display:none;'"; }
	
	
	Vector multilang_id = new Vector();

	multilang_id.addElement("TX_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap             text               = MessageUtil.getMessage(info,multilang_id);
	Map<String, String> objInfo            = new HashMap<String, String>();
	String              screen_id          = "TX_011";
	String              grid_obj           = "GridObj";
	String              houseCode          = info.getSession("HOUSE_CODE");
	String              id                 = info.getSession("ID");
	String              company_code       = info.getSession("COMPANY_CODE");
	String              paySendNo          = request.getParameter("pay_send_no");
	String              sepoaOutResultInfo = null;
	String              vendorCode         = null;
	String              depositorName      = null;
	String              bankCode           = null;
	String              bankAcct           = null;
	String              payAmt             = null;
	String              signerFlag         = null;
	String              signerNo           = null;
	String              signerBio          = null;
	String              workKind           = null;
	String              bmsbmsyy           = null;
	String              sogsogcd           = null;
	String              astastgb           = null;
	String              mngmngno           = null;
	String              bssbssno           = null;
	String              appappyy           = null;
	String              bmssrlno           = null;
	String              appappno           = null;
	String              appappam           = null;
	String              jumjumCd           = null;
	String              igjmCd             = null;
	String              bdsbdscd           = null;
	String              bdsbdsnm           = null;
	String              useKind            = null;
	String              dealArea           = null;
	String              durableYear        = null;
	String              dealDebt           = null;
	String              dealDebtComma      = null;
	String              accountkind        = null;
	String              dealKind           = null;
	String              trmRtnSqno         = null;
	String              userTrmNo          = null;
	String              statusCd           = null;
	String              addDate            = null;
	String              addTime            = null;
	String              addUserId          = null;
	String              changeDate         = null;
	String              changeTime         = null;
	String              changeUserId       = null;
	String              tcpState           = null;
	String              webState           = null;
	String              statusNm           = null;
	String              vendorNameLoc      = null;
	String              irsNo              = null;
	String              bankName           = null;
	String              payAmtComma        = null;
	String              workKindName       = null;
	String              sogsognm           = null;
	String              astastnm           = null;
	String              mngmngnm           = null;
	String              bssbssnm           = null;
	String              appappamComma      = null;
	String              jumjumNm           = null;
	String              useKindNm          = null;
	String              accountkindNm      = null;
	String              dealKindNm         = null;
	String              manualAccountKind  = null;
	String              userNameLoc        = null;
	String              cancleAble         = null;
	String              rtnSignerNo        = null;
	String              beforeSignNo       = null;
	String              beforeSignName     = null;
	String              userTrmNoFront     = null;
	String[]            sepoaOutResult     = null;
	SepoaOut            sepoaOut           = null;
	SepoaFormater       sepoaFormater      = null;
	Object[]            obj                = new Object[1];
	boolean             isSelectScreen     = false;
	boolean             sepoaOutFlag       = false;
	boolean             isAccessFlag       = false;
	
	String              signStatus         = null;
	
	String              signer_nm          = null;
	
	String              ccltRsnDscd        = null;
	String              ccltRsnDscdNm      = null;
	String              ccltRsnCntn        = null;
	String              oldUserTrmNo       = null; //회수불가 : NULL , 회수가능 : Y
	
	objInfo.put("HOUSE_CODE",  houseCode);
	objInfo.put("PAY_SEND_NO", paySendNo);
	
	obj[0]       = objInfo;
	sepoaOut     = ServiceConnector.doService(info, "TX_009", "CONNECTION", "selectSpy1glInfo", obj);
	sepoaOutFlag = sepoaOut.flag;
	
	if(sepoaOutFlag){
		sepoaOutResult     = sepoaOut.result;
		sepoaOutResultInfo = sepoaOutResult[0];
		
		sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
		
		vendorCode        = sepoaFormater.getValue("VENDOR_CODE",         0);
		depositorName     = sepoaFormater.getValue("DEPOSITOR_NAME",      0);
		bankCode          = sepoaFormater.getValue("BANK_CODE",           0);
		bankAcct          = sepoaFormater.getValue("BANK_ACCT",           0);
		payAmt            = sepoaFormater.getValue("PAY_AMT",             0);
		signerFlag        = sepoaFormater.getValue("SIGNER_FLAG",         0);
		signerNo          = sepoaFormater.getValue("SIGNER_NO",           0);
		signerBio         = sepoaFormater.getValue("SIGNER_BIO",          0);
		workKind          = sepoaFormater.getValue("WORK_KIND",           0);
		bmsbmsyy          = sepoaFormater.getValue("BMSBMSYY",            0);
		sogsogcd          = sepoaFormater.getValue("SOGSOGCD",            0);
		astastgb          = sepoaFormater.getValue("ASTASTGB",            0);
		mngmngno          = sepoaFormater.getValue("MNGMNGNO",            0);
		bssbssno          = sepoaFormater.getValue("BSSBSSNO",            0);
		appappyy          = sepoaFormater.getValue("APPAPPYY",            0);
		bmssrlno          = sepoaFormater.getValue("BMSSRLNO",            0);
		appappno          = sepoaFormater.getValue("APPAPPNO",            0);
		appappam          = sepoaFormater.getValue("APPAPPAM",            0);
		jumjumCd          = sepoaFormater.getValue("JUMJUM_CD",           0);
		igjmCd            = sepoaFormater.getValue("IGJM_CD",             0);
		bdsbdscd          = sepoaFormater.getValue("BDSBDSCD",            0);
		bdsbdsnm          = sepoaFormater.getValue("BDSBDSNM",            0);
		useKind           = sepoaFormater.getValue("USE_KIND",            0);
		dealArea          = sepoaFormater.getValue("DEAL_AREA",           0);
		durableYear       = sepoaFormater.getValue("DURABLE_YEAR",        0);
		dealDebt          = sepoaFormater.getValue("DEAL_DEBT",           0);
		accountkind       = sepoaFormater.getValue("ACCOUNTKIND",         0);
		dealKind          = sepoaFormater.getValue("DEAL_KIND",           0);
		trmRtnSqno        = sepoaFormater.getValue("TRM_RTN_SQNO",        0);
		userTrmNo         = sepoaFormater.getValue("USER_TRM_NO",         0);
		statusCd          = sepoaFormater.getValue("STATUS_CD",           0); 
		addDate           = sepoaFormater.getValue("ADD_DATE",            0);
		addTime           = sepoaFormater.getValue("ADD_TIME",            0);
		addUserId         = sepoaFormater.getValue("ADD_USER_ID",         0);
		changeDate        = sepoaFormater.getValue("CHANGE_DATE",         0);
		changeTime        = sepoaFormater.getValue("CHANGE_TIME",         0);
		changeUserId      = sepoaFormater.getValue("CHANGE_USER_ID",      0);
		tcpState          = sepoaFormater.getValue("TCP_STATE",           0);
		webState          = sepoaFormater.getValue("WEB_STATE",           0);
		manualAccountKind = sepoaFormater.getValue("MANUAL_ACCOUNT_KIND", 0);
		statusNm          = sepoaFormater.getValue("STATUS_NM",           0);
		vendorNameLoc     = sepoaFormater.getValue("VENDOR_NAME_LOC",     0);
		irsNo             = sepoaFormater.getValue("IRS_NO",              0);
		bankName          = sepoaFormater.getValue("BANK_NAME",           0);
		userNameLoc       = sepoaFormater.getValue("USER_NAME_LOC",       0);
		sogsognm          = sepoaFormater.getValue("SOGSOGNM",            0);
		astastnm          = sepoaFormater.getValue("ASTASTNM",            0);
		mngmngnm          = sepoaFormater.getValue("MNGMNGNM",            0);
		bssbssnm          = sepoaFormater.getValue("BSSBSSNM",            0);
		jumjumNm          = sepoaFormater.getValue("JUMJUM_NM",           0);
		useKindNm         = sepoaFormater.getValue("USE_KIND_NM",         0);
		dealKindNm        = sepoaFormater.getValue("DEAL_KIND_NM",        0);
		cancleAble        = sepoaFormater.getValue("CANCLE_ABLE",         0);
		rtnSignerNo       = sepoaFormater.getValue("RTN_SIGNER_NO",       0);
		beforeSignNo      = sepoaFormater.getValue("BEFORE_SIGN_NO",      0);
		beforeSignName    = sepoaFormater.getValue("BEFORE_SIGN_NAME",    0);
		payAmtComma       = SepoaString.dFormat((Object) payAmt);
		appappamComma     = SepoaString.dFormat((Object) appappam);
		
		
		if(dealDebt == null){
			dealDebt = "";
		}
		
		if(beforeSignName == null){
			beforeSignName = "";
		}
		
		if(beforeSignNo == null){
			beforeSignNo = "";
		}
		
		dealDebtComma     = SepoaString.dFormat((Object) dealDebt);
		
		if("1".equals(workKind)){
			workKindName = "1.동산 신규";
		}
		else if("2".equals(workKind)){
			workKindName = "2.동산 원가";
		}
		else if("3".equals(workKind)){
			workKindName = "3.건물 자본적지출";
		}
		else if("4".equals(workKind)){
			workKindName = "4.임차점포시설물 자본적지출";
		}
		
		if("1".equals(accountkind)){
			accountkindNm = "계좌이체";
		}
		else if("2".equals(accountkind)){
			accountkindNm = "계좌이체 안함";
		}
		
		if(
			(id.equals(addUserId))     ||
			(id.equals(beforeSignNo))  ||
			(id.equals(signerNo))      ||
			(id.equals(rtnSignerNo))
		){
			isAccessFlag = true;
		}
		
		/* 2018-03-16 책임자승인시 책임자 단말번호로 수정함
		   아래 로직은 더이상 불필요함 
		userTrmNoFront = userTrmNo.substring(0, 12); //TOBE 2017-07-01  9->12 
		*/
		
		signStatus = sepoaFormater.getValue("SIGN_STATUS",    0);		
	    signer_nm  = sepoaFormater.getValue("SIGNER_NM",    0);
	    
	    ccltRsnDscd        = sepoaFormater.getValue("CCLT_RSN_DSCD",      0);
		ccltRsnDscdNm      = sepoaFormater.getValue("CCLT_RSN_DSCD_NM",      0);
		ccltRsnCntn        = sepoaFormater.getValue("CCLT_RSN_CNTN",      0);
		oldUserTrmNo       = sepoaFormater.getValue("OLD_USER_TRM_NO",      0); //회수불가 : NULL , 회수가능 : Y
	}
	

//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_pay_bd_app"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

	Map map = new HashMap();
	map.put("HOUSE_CODE"		, houseCode);
	map.put("PAY_SEND_NO"		, paySendNo);
	//Map<String, Object> data = new HashMap();
	//data.put("header"		, map);
	
	Object[] obj2 = {map};
	//SepoaOut value2= ServiceConnector.doService(info, "TX_005", "CONNECTION", "getPayList2", obj2);
	SepoaOut value2= ServiceConnector.doService(info, "TX_009", "CONNECTION", "selectSpy1lnList", obj2);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
	_rptData.append(paySendNo);
	_rptData.append(_RF);
	_rptData.append(statusNm);
	_rptData.append(_RF);
	_rptData.append(vendorNameLoc);
	_rptData.append(_RF);
	_rptData.append(irsNo);
	_rptData.append(_RF);
	_rptData.append(depositorName);
	_rptData.append(_RF);
	_rptData.append(bankName);
	_rptData.append(_RF);
	_rptData.append(bankAcct);
	_rptData.append(_RF);
	_rptData.append(payAmtComma);
	
	_rptData.append(_RF);
	_rptData.append(workKind);
	
	_rptData.append(_RF);	
	if(accountkind.equals("1")){
		_rptData.append("계좌이체");
	}else if(accountkind.equals("2")){
		_rptData.append("계좌이체 안함");
	}		
	_rptData.append(_RF);
	if("3".equals(workKind) || "4".equals(workKind)){
		_rptData.append(dealKindNm);
	}
	
	_rptData.append(_RF);
	if(!"".equals(addUserId)){
		_rptData.append(signer_nm);
		_rptData.append(" (");
		_rptData.append(addUserId);
		_rptData.append(")");		
	}			
	_rptData.append(_RF);
	
	if("Y".equals(signerFlag)){
		if(!"".equals(beforeSignNo)){
			_rptData.append(beforeSignName);
			_rptData.append(" (");
			_rptData.append(beforeSignNo);
			_rptData.append(")");				
		}
		_rptData.append(_RF);
		if(!"".equals(signerNo)){
			_rptData.append(userNameLoc);
			_rptData.append(" (");
			_rptData.append(signerNo);
			_rptData.append(")");				
		}					
	}else{
		_rptData.append(_RF);
	}
	
	_rptData.append(_RF);
	_rptData.append(bmsbmsyy);
	_rptData.append(_RF);	
	_rptData.append(sogsognm);
	_rptData.append(" (");	
	_rptData.append(sogsogcd);
	_rptData.append(")");		
	_rptData.append(_RF);
	_rptData.append(astastnm);
	_rptData.append(_RF);
	_rptData.append(mngmngnm);
	_rptData.append(_RF);
	_rptData.append(bssbssnm);
	_rptData.append(_RF);
	_rptData.append(appappyy);
	_rptData.append(" / ");
	_rptData.append(bmssrlno);
	_rptData.append(_RF);
	_rptData.append(appappno);
	_rptData.append(_RF);
	_rptData.append(appappam);
	_rptData.append(_RF);	
	
	if("3".equals(workKind) || "4".equals(workKind)){
		_rptData.append(jumjumCd);
		_rptData.append(" / ");
		_rptData.append(jumjumNm);
		_rptData.append(_RF);
		_rptData.append(bdsbdscd);
		_rptData.append(_RF);
		_rptData.append(bdsbdsnm);		
	}else{
		_rptData.append(_RF);
		_rptData.append(_RF);				
	}
	_rptData.append(_RF);
	
	if("4".equals(workKind)){
		_rptData.append(dealArea);
		_rptData.append(_RF);
		_rptData.append(useKindNm);
		_rptData.append(_RF);
		_rptData.append(dealDebtComma);
	}else{
		_rptData.append(_RF);
		_rptData.append(_RF);				
	}
	
	_rptData.append(_RD);			
	if(wf2 != null) {
		if(wf2.getRowCount() > 0) { //데이타가 있는 경우
			for(int i = 0 ; i < wf2.getRowCount() ; i++){
				_rptData.append(wf2.getValue("TAX_NO", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("DEPT_NAME_LOC", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("IGJM_CD", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("PMKPMKCD", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("DESCRIPTION_LOC", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("SPECIFICATION", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("CNT", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("AMT", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("APPAPPAM", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("DOSUNQNO", i));
				_rptData.append(_RF);			
				_rptData.append(wf2.getValue("REMARK", i));
				_rptData.append(_RL);
			}
		}
	}		
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////		
	

	
	
%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language=javascript >
/* TOBE 2017-07-01 추가 결재상태가 결재완료(내부결재)가 아니면 버튼 숨김 */
$(document).ready(function(){
	<%if(!"E".equals(signStatus)) {%> /* E:결재완료 */
		fnBtnHide();
	<%}%>
	<%if("R".equals(signStatus)) {%>  /* R:결재반려 */
		$("#tdDelete").show();
	<%}%>

	//TOBE 2017-11-23 추가 결재 취소시 삭제 버튼 활성화 
	<%if("D".equals(signStatus)) {%>  /* D:결재취소 */
	$("#tdDelete").show();
<%}%>
});
</script>

<html>
<head>
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=ks_c_5601-1987">
<script language="javascript">
//TOBE 2017-07-01 불필요 주석 에러를 유발시킴 <!--
var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_app";

/* TOBE 2017-07-01 통합단말 관련 변수 */
var strSourceSystem = "EPS";	// 송신 시스템 코드
var strTargetSystem = "UTM";    // 수신 시스템 코드 //- (통합단말) UTM(리얼), UTM_D(개발), UTM_T(테스트), UTM_Y(연수) 
var isApvRncd       = null;     //TOBE 2017-07-01 책임자 승인 사유 코드
var bioCallPoint    = null;     //지문호출위치

function Init(){

	/* TOBE 2017-07-01 통합단말 추가 */
    var nResult = XFramePLUS.StartCopyData(true, strSourceSystem);// WM_COPYDATA 메시지를 수신하기 위한 윈도우 생성{필수}
    if(nResult != 1) {alert("수신 윈도우 생성 시 오류 발생");}

    
<%
	if(isAccessFlag){
		if(
			("T".equals(cancleAble)) &&
			("30".equals(statusCd))  &&
			(id.equals(addUserId))  
		){
%>
	//TOBE 2017-07-01 통합단말 이벤트 수신후 처리로 변경 getSignSelect();
	isApvRncd = "BOCOM00001"; //TOBE 2017-07-01 책임자 승인 사유 코드 (취소)
<%
		}
		else{
%>
	$("#rtnSignerSelect").hide();
<%
		}
%>

    GetBrowserInfo();
	setGridDraw();
	doSelect();

<%
	}
	else{
%>
	alert("접근 권한이 없습니다.");
	
	fnList();
<%
	}
%>
}

var calByte = {
		getByteLength : function(s) {
			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
			}
			return size;
		},		
		cutByteLength : function(s, len) {
			if (s == null || s.length == 0) {
				return 0;
			}
			var size = 0;
			var rIndex = s.length;
			for ( var i = 0; i < s.length; i++) {
				size += this.charByteSize(s.charAt(i));
				if( size == len ) {
					rIndex = i + 1;
					break;
				} else if( size > len ) {
					rIndex = i;
					break;
				}
			}
			return s.substring(0, rIndex);
		},
		charByteSize : function(ch) {
			if (ch == null || ch.length == 0) {
				return 0;
			}
			var charCode = ch.charCodeAt(0);
			if (charCode <= 0x00007F) {
				return 1;
			} else if (charCode <= 0x0007FF) {
				return 2;
			} else if (charCode <= 0x00FFFF) {
				return 3;
			} else {
				return 4;
			}
		}
	};

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
				//alert("단말정보 : " + strBrowserInfo );           // 테스트 확인용 오픈시 제거
				
				strTRM_NO = strBrowserInfo.substr(7,12); //단말번호
				strOPR_NO = strBrowserInfo.substr(27,8); //사용자ID
					
				$('#user_trm_no').val(strTRM_NO+strOPR_NO);  //020644DD008919010045
				$('#txtBrowserInfo').val(strTRM_NO);         //020644DD0089
				$('#txtMnno').val(strOPR_NO);                //19010045
			}
			else if(strCmd == "FINGER_PRINT"){                  // 지문정보
				strFingerPrint = strData;
				//alert("지문인식1 : " + strFingerPrint );           // 테스트 확인용 오픈시 제거
				
				$('#PAY_SEND_BIO').val("");
				$('#PAY_SEND_BIO').val(strFingerPrint);
				
				//alert("지문인식2 : " + $('#PAY_SEND_BIO').val() );           // 테스트 확인용 오픈시 제거
				//$('#PAY_SEND_BIO').val("5DFB42EAC39AA569B871878AE6F2FDBDE58470FC737AC478A0A1C612A065560AF4102851FC711248A835D7FE973C1FD2E85B4D219ADEAE33E26B1EB531E23475D48D38E42F6B0811CAF5C537C2AC85519A4BBF1CF3F3463F020E01559A2BD080E3F716EFA84D1F58A90A0B0B8CA2DC946F98B40C691EE023EE265BE8E619188FDCB472037727E1487BEAA370C52187965810129E887BA5B191F060BE1714D807F57F61A35F3BAFCD7DF1C286B32A2AF430DD78F539FDE1A24DC316ACA3DD32B11AEC5598125F71C5C281DD774CD9357CA956AA2961985B8327CC72283349EE09781ED0E43310E70A6F475B600228F46230935A6DBFB83C53F750CBE073E598C92EF8E88D815822BC87A57B85D343C6DF135EE54D7B9D8BD2B481EAA16F7A0D168610826B5DB21FA03AB7B3B1B35B81F4152BED63D897C14BC5B15F9BC373011D12C76077D495AFF38955D63C711D2E079A08B705F92D77B2EDF97EC709991E4E2024B1C4C0E0A94CD1E6C0C9DE790B2F3591AB0E95AC243278A29F33060934FD254E1D5CFF0FAE4D8C8FD2B9BF7DEBEF484E2E8B5A70B2187C077CD099C899155F861E55114B6B95A60FC4185A1DF4F29D01682DC057A0429D89807246EFE10D339BAA892AD31E8E83CB9443F4CC0BA99105325C52485A51686B4F2AF0A93AC3B9D72AA0A48175BD3E55BB97EF4FF2BB056D2FEC5DD941893742B0494603DC78DC590AA90C2410ED4109EBF60477D28DFAC9A6F1CC4DC9659FD281CEF6A88D443CB5E6039383D05AD7D2C2F131D96609EA76A9C1B8C1C87D5DC28B9150EA091EFB80ABC63CABC44ECB1EF342C0C1C1A9604C2413BC2785006799755274A7011F64CCC496C5BB9CC8214FBD7B5F1632BAB1E9F31FFD21D286012FAFA02C4A9C94F206348E07996E83F825FB3941C477F4796B2D43C748B8FF7B21030F26756029");
			}
			else if(strCmd.substr(0,1) == "S"){
				arrSendSeq.push( strCmd.substr(1,4) );
				arrSendData.push( strData );
			}
		}
		 
	 if(strCmd == "BROWSER_INFO" && strOPR_NO != "<%=info.getSession("ID") %>"){
			alert("통합 단말과 로그인 사용자 정보가 일치하지 않습니다.");
			fnList();
	 }
	 else if(strCmd == "BROWSER_INFO") {
	        
	        if(isApvRncd == "BOCOM00001"){ //승인사유코드 취소
	        	getSignSelect(); //책임자승인목록
			}
     }
	 else if(strCmd == "FINGER_PRINT" ) {      //지문정보
		 if(bioCallPoint == "fnBioApp") {
			 fnBeforeSign3(); //지문인증 승인후 실행
			 //fnBioApp2();     //실행  //TOBE 2017-08-24 오픈시 주석 처리해야함
		 }
		 else if(bioCallPoint == "fnBioAppCancel") {   
			 fnBioAppCancel2();
		 }
		 else if(bioCallPoint == "fnCancleBioApp") {   
			 fnCancleBioApp2();
		 }
		 else if(bioCallPoint == "fnBeforeSign") {   
			 fnBeforeSign2(); //지문인증승인
		 }
	 }
	 
     //alert(strQueueKeyIndex); // 테스트 확인용 오픈시 제거
     //alert(strCmdAll);        // 테스트 확인용 오픈시 제거
     //alert(strDataAll);       // 테스트 확인용 오픈시 제거

     XFramePLUS.RClear(strQueueKeyIndex); // 수신 받은 데이터 삭제
     bioCallPoint = null;
	
}

function doSelect(){
	var param = "mode=selectSpy1lnList&cols_ids=<%=grid_col_id%>";
	
	param = param + dataOutput();
	
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
}

function fnList(){
	topMenuClick("/kr/tax/pay_budget_give_list.jsp", "MUO141000004", "4", '');
}

function fnDelete(){
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
				var PAY_SEND_NO = document.getElementById("PAY_SEND_NO");
				
				//$("#tdDelete").hide();
				fnBtnHide();
				
				if(confirm("문서파기 하시겠습니까?")){
					$.post(
						servletUrl,
						{
							mode        : "updateSpy1glDelYn",
							PAY_SEND_NO : PAY_SEND_NO.value,
							BMSBMSYY : "<%=bmsbmsyy %>",
							BMSSRLNO : "<%=bmssrlno %>",
							APPAPPNO : "<%=appappno %>"
						},
						function(arg){
							var result = eval("(" + arg + ")");
							
							fnDeleteCallback(result);
						}
					);
				}else{
					fnReload();
				}
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function fnDeleteCallback(result){
	var code = result.code;
	
	if(code == "000"){
		alert("문서파기 되었습니다.");
		
		fnList();
	}
	else{
		alert("문서파기에 실패하였습니다.");
		
		//$("#tdDelete").show();
		fnReload();
	}
}

function fnEpsResult(){
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO");
	
	if(confirm("자산등재 하시겠습니까?")){
		$.post(
			servletUrl,
			{
				mode        : "epsResult",
				PAY_SEND_NO : PAY_SEND_NO.value
			},
			function(arg){
				var result = eval("(" + arg + ")");
				
				fnEpsResultCallback(result);
			}
		);
	}
}

function fnEpsResultCallback(result){
	var code = result.code;
	
	if(code == "200"){
		alert("자산등재 처리되었습니다.");
		
		fnList();
	}
	else{
		alert(result.message);
	}
}

<%--
//이체실행
//5,000만원 이상 책임자 지문승인 필요
--%>
function fnSendResult(){
	fnBtnHide();
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
				var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
				var SIGNER_NO   = document.getElementById("SIGNER_NO").value;
				
				if(SIGNER_NO.length>0){	//책임자 이체
					$('#PAY_SEND_TYPE').val("Y");
				
					if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
						fnBioApp();
					}else{fnReload();}
				}
				else{					//일반이체
					if(confirm("실행을 진행하시겠습니까?")){	
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
	
	bioCallPoint = "fnBioApp";
	CallBio(frm);
	
	var bio = frm.PAY_SEND_BIO.value;
	
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

function fnBioApp2(){
	
	var bio = document.getElementById("PAY_SEND_BIO").value;
	
	if(bio.length> 0){
		if(confirm("승인처리가 정상적으로 완료되었습니다. \r\n실행을 진행하시겠습니까?")){ //ASIS 2017-07-01 "지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?"	
			fnSendAppProcess();
		}else{fnReload();}
	}else{fnReload();}
}


<%--//이체실행--%>
function fnSendAppProcess(){
	var PAY_SEND_NO   = document.getElementById("PAY_SEND_NO").value;
	var PAY_SEND_TYPE = document.getElementById("PAY_SEND_TYPE").value;
	var PAY_SEND_BIO  = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO      = document.getElementById("txtMnno").value;
	var d = new Date();
    var HHMMSS = d.getMinutes() + ":" + d.getSeconds() + ":" + d.getMilliseconds();
	
	//$("#tdSendResult").hide();
	//fnBtnHide();
	//이체실행
	$.post(
		servletUrl,
		{
			mode          : "paySendApp",
			PAY_SEND_NO   : PAY_SEND_NO,
			PAY_SEND_TYPE : PAY_SEND_TYPE,
			PAY_SEND_BIO  : PAY_SEND_BIO,
			TXT_MNNO      : TXT_MNNO,
			HHMMSS        : HHMMSS
		},
		function(arg){
			var result = eval("(" + arg + ")");
			fnSendAppProcessCallback(result);
		}
	);
}	

<%--//이체실행Callback--%>
function fnSendAppProcessCallback(result){
	var code = result.code;
	
	if(code == "000"){
		alert("실행이 정상적으로 완료되었습니다.");
		
		fnList();
	}
	else{
		alert(result.message);
		
		//$("#tdSendResult").show();
		//fnReload();
		fnList();
	}
}

function fnReload(){
	window.location.href = "/kr/tax/pay_bd_app.jsp?pay_send_no=<%=paySendNo%>"; 
}

function fnBtnHide(){
	$("#tdSendResultCancle").hide();
	$("#tdSendResult").hide();
	$("#tdCencelRequest").hide();
	$("#tdCancelResult").hide();
	$("#tdCencelBack").hide();
	$("#tdAppReject").hide();
	$("#tdBeforeSign").hide();
	$("#tdBeforeReject").hide();
	$("#tdDelete").hide();
	showLoadingLayer();	
}

function fnBtnShow(){
	closeLoadingLayer();	
}

<%--
//이체취소
//모든 취소에 대해 책임자 지문승인 필요
--%>
function fnCancelResult(){
	fnBtnHide();
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
				var PAY_SEND_NO     = document.getElementById("PAY_SEND_NO").value;
				var RTN_SIGNER_NO   = document.getElementById("RTN_SIGNER_NO").value;
				
				if(RTN_SIGNER_NO.length>0){	//책임자 이체
					$('#PAY_SEND_TYPE').val("Y");
				
					if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
						fnBioAppCancel();
					}else{fnReload();}
				}
				else{					//일반이체
					if(confirm("실행취소를 진행하시겠습니까?")){	
						fnCancelAppProcess();
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




<%--ASIS 2017-07-01  //지문승인 
function fnBioAppCancel(){
	var frm = document.forms[0];
	
	CallBio(frm);
	
	var bio = frm.PAY_SEND_BIO.value;
	
	if(bio.length> 0){
		if(confirm("지문등록이 완료되었습니다. \r\n실행취소를 진행하시겠습니까?")){	
			fnCancelAppProcess();
		}
	}
}
--%>


//TOBE 2017-07-01 지문 수신 이벤트 후 처리로 변경
<%--//지문승인--%>
function fnBioAppCancel(){
	var frm = document.forms[0];
	
	bioCallPoint = "fnBioAppCancel";
	CallBio(frm);
	
}

<%--//지문승인 2017-11-21 주석처리함 로직을 아래로 변경함 (취소 실행자 지문승인)
function fnBioAppCancel2(){
	
	var bio = document.getElementById("PAY_SEND_BIO").value;
	
	if(bio.length> 0){
		if(confirm("지문등록이 완료되었습니다. \r\n실행취소를 진행하시겠습니까?")){	
			fnCancelAppProcess();
		}
	}
}
--%>

//TOBE 2017-07-01 취소 실행자 지문승인
function fnBioAppCancel2(){
	
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	var bio         = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO    = document.getElementById("txtBrowserInfo").value;
		
		if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n실행취소를 진행하시겠습니까?")){
				var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
				
				//$("#tdBeforeSign").hide();
				//fnBtnHide();

				$.post(
					servletUrl,
					{
						mode         : "updateSpy1gInfoBeforeSign",
						PAY_SEND_NO  : PAY_SEND_NO,
						PAY_SEND_BIO : PAY_SEND_BIO,
						/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO     : "<%=userTrmNoFront %>", */
						TXT_MNNO     : TXT_MNNO,
						LAST_SIGN_YN : "Y"
					},
					function(arg){
						var result  = eval("(" + arg + ")"); 
						var code    = result.code;
						var message = result.message;
						
						if(code == "000"){
							
							fnCancelAppProcess();     //취소
							
						}
						else{
							if(message == ""){
								message = "승인 처리에 실패하였습니다.";
							}
							
							alert(message);
							
							//$("#tdBeforeSign").show();
							fnReload();
						}
					}
				);
			}else{fnReload();}
		}else{fnReload();}
	
}






<%--//이체실행취소--%>
function fnCancelAppProcess(){
	var PAY_SEND_NO   = document.getElementById("PAY_SEND_NO").value;
	var PAY_SEND_TYPE = document.getElementById("PAY_SEND_TYPE").value;
	var PAY_SEND_BIO  = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO      = document.getElementById("txtMnno").value;
	var d = new Date();
    var HHMMSS = d.getMinutes() + ":" + d.getSeconds() + ":" + d.getMilliseconds();
	//$("#tdCancelResult").hide();
	//fnBtnHide();
	
	//이체실행
	$.post(
		servletUrl,
		{
			mode          : "payCancelApp",
			PAY_SEND_NO   : PAY_SEND_NO,
			PAY_SEND_TYPE : PAY_SEND_TYPE,
			PAY_SEND_BIO  : PAY_SEND_BIO,
			TXT_MNNO      : TXT_MNNO,
			HHMMSS        : HHMMSS
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			fnCancelAppProcessCallback(result);
		}
	);
}	
<%--//이체실행Callback--%>
function fnCancelAppProcessCallback(result){
	var code = result.code;
	
	if(code == "000"){
		alert("실행취소가 정상적으로 완료되었습니다.");
		
		fnList();
	}
	else{
		alert(result.message);
		
		//$("#tdCancelResult").show();
		//fnReload();
		fnList();
	}
}


<%-- ASIS 2017-07-01
function CallBio(form){
	ret = WooriDeviceForOcx.OpenDevice();
	
	if(ret == 0){	
		nWaitTime = form.txtWait.value;
		nPos      = form.txtPos.value;
		ret       = WooriDeviceForOcx.GetBioControl();
		
		if(ret == 0){
			ret = WooriDeviceForOcx.GetBioVerifyPos(nWaitTime, "<%=userTrmNoFront %>", nPos);
			
			if(ret == 0){
				msg = WooriDeviceForOcx.GetResult();
				
				form.PAY_SEND_BIO.value = msg;
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

// TOBE 2017-07-01 지문인식
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

function fnAppReject(){
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
				var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
				
				if(confirm("반려하시겠습니까?") == false){
					return;
				}
				
				//$("#tdAppReject").hide();
				fnBtnHide();
				
				$.post(
					servletUrl,
					{
						mode        : "updateSpy1glStatusCd03",
						PAY_SEND_NO : PAY_SEND_NO
					},
					function(arg){
						var result = eval("(" + arg + ")");
						var code   = result.code;
						
						if(code == "000"){
							alert("승인반려가 정상적으로 완료되었습니다.");
							
							fnList();
						}
						else{
							alert("승인반려에 실패하였습니다.");
							
							//$("#tdAppReject").show();
							fnReload();
						}
					}
				);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function doManualConfirm(){
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	
	if(confirm("수동완료 하시겠습니까?") == false){
		return;
	}
	
	$.post(
		servletUrl,
		{
			mode        : "updateSpy1glManualAccountKind",
			PAY_SEND_NO : PAY_SEND_NO
		},
		function(arg){
			var result = eval("(" + arg + ")");
			var code   = result.code;
			
			if(code == "000"){
				alert("수동완료가 정상적으로 완료되었습니다.");
				
				fnList();
			}
			else{
				alert("수동완료에 실패하였습니다.");				
			}
		}
	);
}

function doManualConfirmCancle(){
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	
	if(confirm("수동취소 하시겠습니까?") == false){
		return;
	}
	
	$.post(
		servletUrl,
		{
			mode        : "updateSpy1glManualAccountKindCancle",
			PAY_SEND_NO : PAY_SEND_NO
		},
		function(arg){
			var result = eval("(" + arg + ")");
			var code   = result.code;
			
			if(code == "000"){
				alert("수동취소가 정상적으로 완료되었습니다.");
				
				fnList();
			}
			else{
				alert("수동취소에 실패하였습니다.");
			}
		}
	);
}

function fnSendResultCancle(){
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
				var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
				var SIGNER_NO   = document.getElementById("SIGNER_NO").value;
				
				if(SIGNER_NO.length>0){	//책임자 이체
					$('#PAY_SEND_TYPE').val("Y");
				
					if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
						fnCancleBioApp();
					}
				}
				else{					//일반이체
					if(confirm("회수를 진행하시겠습니까?")){	
						fnSendResultCancleProcess();
					}
				}
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

<%--ASIS 2017-07-01 //지문승인
function fnCancleBioApp(){
	var frm = document.forms[0];
	
	CallBio(frm);
	
	var bio = frm.PAY_SEND_BIO.value;
	
	if(bio.length> 0){
		if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
			fnSendResultCancleProcess();
		}
	}
}
--%>

//TOBE 2017-07-01 지문 수신 이벤트 후 처리로 변경
<%--//지문승인--%>
function fnCancleBioApp(){
	var frm = document.forms[0];
	
	bioCallPoint = "fnCancleBioApp";
	CallBio(frm);
}

<%--//지문승인--%>
/* 20171128 변원상 주석처리 
function fnCancleBioApp2(){
	
	var bio = document.getElementById("PAY_SEND_BIO").value;
	
	if(bio.length> 0){
		if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
			fnSendResultCancleProcess();
		}
	}
}
*/

function fnCancleBioApp2(){
	
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	var bio         = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO    = document.getElementById("txtBrowserInfo").value;
		
		if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n회수를 진행하시겠습니까?")){
				var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
				
				//$("#tdBeforeSign").hide();
				fnBtnHide();

				$.post(
					servletUrl,
					{
						mode         : "updateSpy1gInfoBeforeSign",
						PAY_SEND_NO  : PAY_SEND_NO,
						PAY_SEND_BIO : PAY_SEND_BIO,
						/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO     : "<%=userTrmNoFront %>", */
						TXT_MNNO     : TXT_MNNO,
						LAST_SIGN_YN : "Y"
					},
					function(arg){
						var result  = eval("(" + arg + ")"); 
						var code    = result.code;
						var message = result.message;
						
						if(code == "000"){
							
							fnSendResultCancleProcess();     //회수
							
						}
						else{
							if(message == ""){
								message = "회수 처리에 실패하였습니다.";
							}
							
							alert(message);
							
							//$("#tdBeforeSign").show();
							fnReload();
						}
					}
				);
			}
		}
	
}


function fnSendResultCancleProcess(){
	var PAY_SEND_NO  = document.getElementById("PAY_SEND_NO").value;
	var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO     = document.getElementById("txtMnno").value;
	
	/*
	if(confirm("회수 하시겠습니까?") == false){
		return;
	}
	*/
	
	//$("#tdSendResultCancle").hide();
	fnBtnHide();
	
	$.post(
		servletUrl,
		{
			mode         : "paySendAppCancle",
			PAY_SEND_NO  : PAY_SEND_NO,
			PAY_SEND_BIO : PAY_SEND_BIO,
			TXT_MNNO     : TXT_MNNO,
			BMSBMSYY : "<%=bmsbmsyy %>",
			BMSSRLNO : "<%=bmssrlno %>",
			APPAPPNO : "<%=appappno %>"
		},
		function(arg){
			//alert(arg);
			var result = eval("(" + arg + ")");
			var code   = result.code;
			
			if(code == "000"){
				alert("회수가 정상적으로 완료되었습니다.");
				
				fnList();
			}
			else{
				alert(result.message);
				
				//$("#tdSendResultCancle").show();
				fnReload();
			}
		}
	);
}

function getSignSelect(){
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
		
		getSignSelectCallback(result);
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
			
			getSignSelectCallback(result);
		}
	); --%>
}

function getSignSelectCallback(result){
	var signerSelect = document.getElementById("rtnSignerSelect");
	var i            = 0;
	var resultLength = result.length;
	var resultInfo   = null;
	
	try{
		if(resultLength == 0){
			alert("결재자 정보가 없습니다.");
			
			fnList();
		}
		else{
			for(i = 0; i < resultLength; i++){
				resultInfo   = result[i];
				option       = document.createElement("option");
				option.text  = resultInfo.managerName;
				option.value = resultInfo.managerNo;
				
				signerSelect.add(option, i);
			}
			
			option       = document.createElement("option");
			option.text  = "선택";
			option.value = "";
			
			signerSelect.add(option, 0);
			
			signerSelect.value = "";
		}
	}
	catch(e){
		alert("결재자 정보가 없습니다.");
		
		fnList();
	}
}

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
			
			fnList();
		}
	
		WooriDeviceForOcx.CloseDevice();
	}
	else{
		msg = WooriDeviceForOcx.GetErrorMsg(ret);
		
		alert(msg);
		
		fnList();
	}
}
--%>


//취소신청 책임자 등록
function fnCancelRequest(){
	var PAY_SEND_NO     = document.getElementById("PAY_SEND_NO").value;
	var rtnSignerSelect = document.getElementById("rtnSignerSelect").value;
	var ccltRsnDscd = document.getElementById("ccltRsnDscd").value;
	var ccltRsnCntn = document.getElementById("ccltRsnCntn").value;
	
	if(rtnSignerSelect == "" || rtnSignerSelect == null){
		alert("책임자를 선택해 주세요.");
		document.getElementById("rtnSignerSelect").focus();
		return;	
	}
	
	if(ccltRsnDscd == "" || ccltRsnDscd == null){
		alert("취소사유코드를 선택해 주세요.");
		document.getElementById("ccltRsnDscd").focus()
		return;	
	}
	
	if(ccltRsnCntn == "" || ccltRsnCntn == null){
		alert("취소사유를 입력해 주세요.(문자수 33자까지만 입력가능)");
		document.getElementById("ccltRsnCntn").focus();
		return;	
	}
	
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
				if(confirm("취소신청하시겠습니까?") == false){
					return;
				}
				
				//$("#tdCencelRequest").hide();
				fnBtnHide();
				$.post(
						servletUrl,
						{
							mode              : "updateSpy1glRtnSignerNo",
							PAY_SEND_NO       : PAY_SEND_NO,
							RTN_SIGNER_NO     : rtnSignerSelect,
							CCLT_RSN_DSCD     : ccltRsnDscd,
						    CCLT_RSN_CNTN	  : ccltRsnCntn
						},
						function(arg){
							var result = eval("(" + arg + ")");
							var code   = result.code;
							
							if(code == "000"){
								alert("취소책임자 등록이 정상적으로 완료되었습니다.");
								
								fnList();
							}
							else{
								alert("취소책임자 등록에 실패하였습니다.");
								
								//$("#tdCencelRequest").show();
								fnReload();
							}
						}
					);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function fnCancelBack(){
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	
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
				if(confirm("취소 반려하시겠습니까?") == false){
					return;
				}
				
				//$("#tdCencelBack").hide();
				fnBtnHide();
				
				$.post(
					servletUrl,
					{
						mode        : "updateSpy1glCancelback",
						PAY_SEND_NO : PAY_SEND_NO
					},
					function(arg){
						var result = eval("(" + arg + ")");
						var code   = result.code;
						
						if(code == "000"){
							alert("취소 반려가 정상적으로 완료되었습니다.");
							
							fnList();
						}
						else{
							alert("취소 반려에 실패하였습니다.");
							
							//$("#tdCencelBack").show();
							fnReload();
						}
					}
				);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

<%-- ASIS 2017-07-01
function fnBeforeSign(){
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	
	
	if(confirm("책임자 전송 지문등록이 필요합니다. \r\n지문등록을 진행하시겠습니까?")){
		var frm = document.forms[0];
		
		CallBio(frm);
		
		var bio = frm.PAY_SEND_BIO.value;
		
		if(bio.length> 0){
			if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){	
				var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
				
				//$("#tdBeforeSign").hide();
				fnBtnHide();
				
				$.post(
					servletUrl,
					{
						mode         : "updateSpy1gInfoBeforeSign",
						PAY_SEND_NO  : PAY_SEND_NO,
						PAY_SEND_BIO : PAY_SEND_BIO,
						TXT_MNNO     : "<%=userTrmNoFront %>"
					},
					function(arg){
						var result  = eval("(" + arg + ")"); 
						var code    = result.code;
						var message = result.message;
						
						if(code == "000"){
							alert("승인처리가 정상적으로 완료되었습니다.");
							
							fnList();
						}
						else{
							if(message == ""){
								message = "승인 처리에 실패하였습니다.";
							}
							
							alert(message);
							
							//$("#tdBeforeSign").show();
							fnReload();
						}
					}
				);
			}
		}
	}
}
--%>

//TOBE 2017-07-01 지문 수신 이벤트 후 처리로 변경
function fnBeforeSign(){
	
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
					
					bioCallPoint = "fnBeforeSign";
					CallBio(frm);
					
				}
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

function fnBeforeSign2(){
	
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	var bio         = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO    = document.getElementById("txtBrowserInfo").value;
		
		if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n실행을 진행하시겠습니까?")){  
				var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
				
				//$("#tdBeforeSign").hide();
				fnBtnHide();
				
				$.post(
					servletUrl,
					{
						mode         : "updateSpy1gInfoBeforeSign",
						PAY_SEND_NO  : PAY_SEND_NO,
						PAY_SEND_BIO : PAY_SEND_BIO,
						/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO     : "<%=userTrmNoFront %>" */
						TXT_MNNO     : TXT_MNNO
					},
					function(arg){
						var result  = eval("(" + arg + ")"); 
						var code    = result.code;
						var message = result.message;
						
						if(code == "000"){
							
							alert("승인처리가 정상적으로 완료되었습니다.");
							 
							fnList();
						}
						else{
							if(message == ""){
								message = "승인 처리에 실패하였습니다.";
							}
							
							alert(message);
							
							//$("#tdBeforeSign").show();
							fnReload();
						}
					}
				);
			}
		}
	
}




//TOBE 2017-07-01 마지막 실행자 지문승인 (최종 책임자)
function fnBeforeSign3(){
	
	var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
	var bio         = document.getElementById("PAY_SEND_BIO").value;
	var TXT_MNNO    = document.getElementById("txtBrowserInfo").value;
		
		if(bio.length> 0){
				if(confirm("지문등록이 완료되었습니다. \r\n승인을 진행하시겠습니까?")){
				var PAY_SEND_BIO = document.getElementById("PAY_SEND_BIO").value;
				
				//$("#tdBeforeSign").hide();
				
				$.post(
					servletUrl,
					{
						mode         : "updateSpy1gInfoBeforeSign",
						PAY_SEND_NO  : PAY_SEND_NO,
						PAY_SEND_BIO : PAY_SEND_BIO,
						/* 2018-03-16 책임자단말번호로 수정 TXT_MNNO     : "<%=userTrmNoFront %>", */
						TXT_MNNO     : TXT_MNNO,
						LAST_SIGN_YN : "Y"
					},
					function(arg){
						var result  = eval("(" + arg + ")"); 
						var code    = result.code;
						var message = result.message;
						
						if(code == "000"){
							
							fnBioApp2();     //실행
							
						}
						else{
							if(message == ""){
								message = "승인 처리에 실패하였습니다.";
							}
							
							alert(message);
							
							//$("#tdBeforeSign").show();
							fnReload();
						}
					}
				);
			}else{fnReload();}
		}else{fnReload();}
	
}



function fnBeforeReject(){
	
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
				var PAY_SEND_NO = document.getElementById("PAY_SEND_NO").value;
				
				if(confirm("1차 승인 반려 하시겠습니까?") == false){
					return;
				}
				
				//$("#tdBeforeReject").hide();
				fnBtnHide();
				
				$.post(
					servletUrl,
					{
						mode        : "updateSpy1gInfoBeforeSignReject",
						PAY_SEND_NO : PAY_SEND_NO
					},
					function(arg){
						var result = eval("(" + arg + ")");
						var code   = result.code;
						
						if(code == "000"){
							alert("승인 반려 처리가 정상적으로 완료되었습니다.");
							
							fnList();
						}
						else{
							alert("승인 반려 처리에 실패하였습니다.");
							
							//$("#tdBeforeReject").show();
							fnReload();
						}
					}
				);
			}else if(result == "-1" ){ 
				alert("휴일 체크중 휴일 데이타가 존재하지 않습니다. ");			
			}else{
				alert("휴일 체크중 알 수 없는 오류발생");
			}				
		}
	);
}

<%-- ASIS 2017-07-01
function GetBrowserInfo(){
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
						
						fnList();
					}
					else if(arr[1] != "<%=info.getSession("ID") %>"){
						alert("통합 단말과 로그인 사용자 정보가 일치하지 않습니다.");
						
						fnList();
					}
					
					document.getElementById("txtMnno").value = arr[1];
				}
				else{
					alert("통합 단말 정보가 올바르지 않습니다.");
					
					fnList();
				}
			}
			else{
				msg = WooriDeviceForOcx.GetErrorMsg(ret);
				
				alert(msg);
				
				fnList();
			}
			
			WooriDeviceForOcx.CloseDevice();
		}
		else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			
			alert(msg);
			
			fnList();
		}
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		fnList();
	}	
}
--%>



/* TOBE 2017-07-01 통합단말 사용자정보 */
function GetBrowserInfo(){
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
			fnList();
		}
		
		// 송신 후  데이터를 클리어한다
		XFramePLUS.clear(key);
		
	}
	catch(e){
		alert("Device정보가 올바르지 않습니다.");
		
		window.close();
	}	
}







//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    alert(messsage);
    
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

function setGridVal(){
	var rowCount    = GridObj.GetRowCount();
    var i           = 0;
    var modelNoColIndex = GridObj.getColIndexById("MODEL_NO");
    var modelNoColValue = null;
    
    var specificationColIndex = GridObj.getColIndexById("SPECIFICATION");
    var specificationColValue = null;
    
    var remarkColIndex = GridObj.getColIndexById("REMARK");
    var remarkColValue = null;
    
    for(i = 0; i < rowCount; i++){
    	modelNoColValue = GD_GetCellValueIndex(GridObj, i, modelNoColIndex);
    	if(calByte.getByteLength( modelNoColValue ) > 50){
    		GD_SetCellValueIndex(GridObj, i, modelNoColIndex, calByte.cutByteLength(  modelNoColValue, 50 ));    		
    	}
    	
    	specificationColValue = GD_GetCellValueIndex(GridObj, i, specificationColIndex);
    	if(calByte.getByteLength( specificationColValue ) > 150){
    		GD_SetCellValueIndex(GridObj, i, specificationColIndex, calByte.cutByteLength(  specificationColValue, 150 ));    		
    	}
    	
    	remarkColValue = GD_GetCellValueIndex(GridObj, i, remarkColIndex);
    	if(calByte.getByteLength( remarkColValue ) > 105){
    		GD_SetCellValueIndex(GridObj, i, remarkColIndex, calByte.cutByteLength(  remarkColValue, 105 ));    		
    	}
    }
}


function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    setGridVal();
    
    return true;
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
<!-- TOBE 2017-07-01 통합단말 수신 이벤트 -->
<script language="JavaScript" for=XFramePLUS event="onqrecvcopydata(strQueueKeyIndex)">
	recvLinkData(strQueueKeyIndex);
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp" %>
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
<!--tobe 2017-07-01 테스트확인용 
<td width="20%" class="title_td">&nbsp;
<input type="text" name="PAY_SEND_BIO_TEXT" id = "PAY_SEND_BIO_TEXT" ></td>
-->

									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급번호</td>
									<td class="data_td" width="30%"><%=paySendNo %></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상태</td>
									<td class="data_td" width="30%"><%=statusNm %></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
									<td class="data_td" width="30%"><%=vendorNameLoc %></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업자번호</td>
									<td class="data_td" width="30%"><%=irsNo %></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예금주명</td>
									<td class="data_td" width="30%"><%=depositorName %></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금은행명</td>
									<td class="data_td" width="30%"><%=bankName %></td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계좌번호</td>
									<td class="data_td" width="30%"><%=bankAcct %></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입금금액</td>
									<td class="data_td" width="30%"><%=payAmtComma %> 원</td>
								</tr>
<%
	if("Y".equals(signerFlag)){
%>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;1차책임자</td>
									<td class="data_td" width="30%"><%=beforeSignName %></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;책임자</td>
									<td class="data_td" width="30%"><%=userNameLoc %></td>
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
	<br />
	<p>STEP1. 업무</p>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="data_td"><%=workKindName %></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br />
	<p>공통예산 Check(EPS0019)</p>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
					<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예산년도</td>
									<td class="data_td" width="15%"><%=bmsbmsyy %></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소관부서</td>
									<td class="data_td" width="45%" colspan="3"><%=sogsognm %></td>
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;자산구분</td>
									<td width="15%" class="data_td"><%=astastnm %></td>
									<td  width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;관리구분</td>
									<td width="15%" class="data_td" ><%=mngmngnm %></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업구분</td>
									<td width="15%" class="data_td" ><%=bssbssnm %></td>
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의번호</td>
									<td class="data_td"><%=appappyy %> <%=bmssrlno %></td>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의승인번호</td>
									<td class="data_td" ><%=appappno %></td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의승인금액</td>
									<td class="data_td"><%=appappamComma %></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br />
<%
	if(("3".equals(workKind)) || ("4".equals(workKind))){
%>
	<div id="divRealEstate">
		<p>3+4 부동산조회(EPS0020)</p>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소속점코드</td>
										<td class="data_td" colspan="3" width="75%"><%=jumjumCd %> <%=jumjumNm %></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td  class="title_td"  width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고유번호</td>
										<td class="data_td" width="15%"><%=bdsbdscd %></td>
										<td  class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부동산명칭</td>
										<td class="data_td"   width="45%"><%=bdsbdsnm %></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
	</div>
<%
		if(("4".equals(workKind)) && ("".equals(dealDebt) == false)){
%>
	<div id="divDebt">
		<p>5 복구충당부채금액(EPS0021)</p>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="title_td" width="10%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전용면적</td>
										<td width="15%" class="data_td"><%=dealArea %>M<SUP>2</SUP></td>
										<td width="15%" class="title_td" style="align:center">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;용도구분(존속기간)</td>
										<td width="15%" class="data_td"><%=useKindNm %></td>
										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;복구충당부채금액</td>
										<td width="20%" class="data_td"><%=dealDebtComma %></td>
										<td width="10%" class="data_td" align="right">&nbsp;</td>
									</tr>   
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br />
	</div>
	<br/>
<%
		}
	}
%>	
	<p>실행</p>
	<table width="100%" border="0" cellspacing="0" cellpadding="1" <%=btnFlag%>>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="data_td" colspan="2"><%=accountkindNm %></td>
										<td width="60%" rowspan="3" class="data_td" align="right">
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
<%
	if(
		("T".equals(cancleAble)) &&
		(
			("10".equals(statusCd)) ||
			("20".equals(statusCd)) ||
			("24".equals(statusCd)) || //TOBE 2017-07-01 추가 책임자전송완료
			("27".equals(statusCd))    //TOBE 2017-07-01 추가 입지전송완료
		)
	){
		boolean isDisplay = false;
		
		if(("Y".equals(signerFlag)) && (id.equals(signerNo)) && ("Y".equals(oldUserTrmNo))){
			isDisplay = true;
		}
		else if(("N".equals(signerFlag)) && (id.equals(addUserId)) && ("Y".equals(oldUserTrmNo))){
			isDisplay = true;
		}
		
		if(isDisplay){
%>
													<td align="right" id="tdSendResultCancle">
<script language="javascript">
btn("javascript:fnSendResultCancle();","회 수");
</script>
													</td>
<%
		}
	}

	if(
		//  ASIS 2017-07-01
		//	("00".equals(statusCd)) ||
		//	("03".equals(statusCd)) ||
		//	("10".equals(statusCd)) ||
		//	("20".equals(statusCd)) ||
		//  ("70".equals(statusCd)) ||
		//	("85".equals(statusCd))	
		
		//TOBE 2017-07-01 저장 및 1차승인은 언제나 실행 가능
	    (  ("00".equals(statusCd)) || 
	       ("03".equals(statusCd)) 
	    ) ||
		//TOBE 2017-07-01 BS완료후 스텝은 당일 처리만 가능함
		(  ("T".equals(cancleAble)) &&  //당일이냐
		 ( ("10".equals(statusCd)) ||
		   ("20".equals(statusCd)) ||
		   //TOBE 2017-07-01 웹취소(모든취소 완료) 이후 단계는 실행버튼 숨김 ("70".equals(statusCd)) ||
		   ("24".equals(statusCd)) || //TOBE 2017-07-01 추가 책임자전송완료 (책임자승인명세)
		   ("27".equals(statusCd)) || //TOBE 2017-07-01 추가 입지전송완료(웹서비스)
		   ("85".equals(statusCd))
		 )
		)
	){
		boolean isDisplay = false;
		
		if(("Y".equals(signerFlag)) && (id.equals(signerNo))){
			if("00".equals(statusCd) == false){
				isDisplay = true;
			}
			else if("".equals(beforeSignNo)){
				isDisplay = true;
			}
		}
		else if(("N".equals(signerFlag)) && (id.equals(addUserId))){
			isDisplay = true;
		}
		
		
		
		if(isDisplay && signStatus.equals("E")){
%>
													<td align="right" id="tdSendResult">
<script language="javascript">
btn("javascript:fnSendResult();","실 행");
</script>
													</td>
<%
		}
	}
	
	if(
		("T".equals(cancleAble)) &&
		("30".equals(statusCd))  &&
		(id.equals(addUserId))
	){
%>
													<td align="left">
														<table style="border-style:solid;border-width:thin;border-color:red">
															<tr>
																<td>
																   	 책임자 : <br/>
																   	 취소사유코드 : <br/>
																   	 취소사유 (입력문자수 33자까지) : 
																</td>
																<td>
																	<select id="rtnSignerSelect"></select><br/>
																	<select id="ccltRsnDscd" name="ccltRsnDscd" class="inputsubmit" >
																		<option value="">선택</option>
																		<%
																			String lg = ListBox(request, "SL0018" ,info.getSession("HOUSE_CODE")+"#M816", "");
																			out.println(lg);
																		%>																								
																	</select><br>
																	<input type="text" name="ccltRsnCntn" id="ccltRsnCntn" size="33" maxlength="33" value="">
																</td>
																<td id="tdCencelRequest">
<script language="javascript">
btn("javascript:fnCancelRequest();","취소신청");
</script>
																</td>																													
															</tr>
														</table>
													</td>
<%
	}
	
	if(
		("T".equals(cancleAble)) &&
		(
			("40".equals(statusCd)) ||
			("50".equals(statusCd)) ||
			("60".equals(statusCd)) ||
			("64".equals(statusCd)) || //TOBE 2017-07-01 추가 책임자전송취소
			("67".equals(statusCd))    //TOBE 2017-07-01 추가 입지전송취소
		)
	){
		boolean isDisplay = false;
		
		if(id.equals(rtnSignerNo)){
			isDisplay = true;
		}
		
		if(isDisplay){
%>
													<td align="left" id="tdCancelResult">
													<table style="border-style:solid;border-width:thin;border-color:red">
															<tr>
																<td>
																   	취소사유코드 : <br/>
																   	취소사유 : 
																</td>																							
																<td>
																	<%= ccltRsnDscd + "-" + ccltRsnDscdNm%><br/>
																	<%= ccltRsnCntn%>
																</td>
																<td>
																		<script language="javascript">
																		btn("javascript:fnCancelResult();","취 소");
																		</script>
																</td>																													
															</tr>
														</table>
													</td>
<%
		}
	}
	
	if(
		("T".equals(cancleAble)) &&
		("40".equals(statusCd))  &&
		(id.equals(rtnSignerNo))
	){
%>
													<td align="right" id="tdCencelBack">
<script language="javascript">
btn("javascript:fnCancelBack();","요청반려");
</script>
													</td>
<%
	}
	
	if(
		("Y".equals(signerFlag))  &&
		(
			(
				(id.equals(signerNo))     &&
				("".equals(beforeSignNo)) &&
				("00".equals(statusCd))
			) ||
			(
				("03".equals(statusCd)) &&
				(id.equals(signerNo))
			)
		)
		
	){
%>
													<td align="right" id="tdAppReject">
<script language="javascript">
btn("javascript:fnAppReject();", "승인반려");
</script>
													</td>
<%
	}
	
	if(
		("Y".equals(signerFlag)) &&
		(id.equals(beforeSignNo))    &&
		("00".equals(statusCd))
	){
%>
													<td align="right" id="tdBeforeSign">
<script language="javascript">
btn("javascript:fnBeforeSign();", "1차승인");
</script>
													</td>
<%
	}
	
	if(
		("Y".equals(signerFlag)) &&
		(id.equals(beforeSignNo))    &&
		("00".equals(statusCd))
	){
%>
													<td align="right" id="tdBeforeReject">
<script language="javascript">
btn("javascript:fnBeforeReject();", "1차반려");
</script>
													</td>
<%
	}
%>
<%--
	if(
		("00".equals(statusCd)) ||
		("70".equals(statusCd)) ||
		("85".equals(statusCd))
	){
%>
													<td align="right">
<script language="javascript">
btn("javascript:doManualConfirm();", "수동완료");
</script>
													</td>
<%
	}
	
	if("80".equals(statusCd)){
%>
													<td align="right">
<script language="javascript">
btn("javascript:doManualConfirmCancle();", "수동취소");
</script>
													</td>
<%
	}
--%>
<%
	if("70".equals(statusCd)){
%>
													<td align="left">
														<table style="border-style:solid;border-width:thin;border-color:red">
															<tr>
																<td>
																   	취소사유코드 : <br/>
																   	취소사유 : 
																</td>																							
																<td>
																	<%= ccltRsnDscd + "-" + ccltRsnDscdNm%><br/>
																	<%= ccltRsnCntn%>
																</td>																																				
															</tr>
														</table>
													</td>
<%
	}
%>
<%
	if(
		(
			(
				("00".equals(statusCd)) ||
				("70".equals(statusCd)) ||
				("85".equals(statusCd)) ||
				("90".equals(statusCd)) || // TOBE 2017-07-01 추가 1차반려    (조작자만 삭제 할수 있게 변경)
				("95".equals(statusCd)) || // TOBE 2017-07-01 추가 책임자반려 (조작자만 삭제 할수 있게 변경)
				("97".equals(statusCd))    // TOBE 2017-07-01 추가 회수
				
			) &&
			(id.equals(addUserId))
		)
		
		//ASIS 2017-07-01 주석처러함 (책임자는 삭제를 못하게 변경)
		//||
		//(
		//	("90".equals(statusCd)) &&
		//	(id.equals(beforeSignNo))
		//) ||
		//(
		//	("95".equals(statusCd)) &&
		//	(id.equals(signerNo))
		//)
	){
%>
													<td align="right" id="tdDelete">
<script language="javascript">
btn("javascript:fnDelete();", "삭 제");
</script>
													</td>
<%
	}
%>
													<td align="right">
<script language="javascript">
btn("javascript:fnList();", "목 록");
</script>
													</td>
<% if("30".equals(statusCd) || "70".equals(statusCd) ){ %>													
													<td align="right" id="tdPrint">
<script language="javascript">
btn("javascript:clipPrint();", "출 력");
</script>
													</td>
<% } %>																																								
												</tr>
											</table> 
										</td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="data_td" width="10%">
<%
	if(("3".equals(workKind)) || ("4".equals(workKind))){
%>
											거래구분
<%
	}
	else{
%>
											&nbsp;
<%
	}
%>
										</td>
										<td class="data_td">
<%
	if(("3".equals(workKind)) || ("4".equals(workKind))){
%>
											<%=dealKindNm %>
<%
	}
	else{
%>
											&nbsp;
<%
	}
%>
										</td>
									</tr>   
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</s:header>
<form>
	<input type="hidden" name="PAY_SEND_NO"      id="PAY_SEND_NO"       value="<%=paySendNo %>" />
	<input type="hidden" name="PAY_SEND_TYPE"    id="PAY_SEND_TYPE"     value="N" />
	<input type="hidden" name="SIGNER_NO"        id="SIGNER_NO"         value="<%=signerNo%>" />
	<input type="hidden" name="RTN_SIGNER_NO"    id="RTN_SIGNER_NO"     value="<%=rtnSignerNo%>" />
	<INPUT type="hidden" name="txtWait" size="10" value="30" /> 
	<INPUT type="hidden" name="txtPos" size="10" value="5"	/>
	<INPUT type="hidden" name="txtMnno" id = "txtMnno" />
	
	<TEXTAREA style="display:none" name="PAY_SEND_BIO" id="PAY_SEND_BIO" rows="10" cols="10"></TEXTAREA>	
</form>
<form name="form1" >
	<input type="hidden" name="company_code"     id="company_code"     value="<%=company_code%>">
	<input type="hidden" name="bk_cd"            id="bk_cd"            value="">
	<input type="hidden" name="br_cd"            id="br_cd"            value="">
	<input type="hidden" name="trm_bno"          id="trm_bno"          value="">
	<input type="hidden" name="user_trm_no"      id="user_trm_no"      value="">
	<input type="hidden" name="txtBrowserInfo"   id="txtBrowserInfo"   value="">
	<INPUT type="hidden" name="txtLevel"         id="txtLevel"         value="10">
	<INPUT type="hidden" name="txtManagerList"   id="txtManagerList"   value="">
	<INPUT type="hidden" name="rdoWorkKindValue" id="rdoWorkKindValue" value="">
	<INPUT type="hidden" name="accountKindValue" id="accountKindValue" value="">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>		
</form>
<s:grid screen_id="TX_011" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<!-- ASIS 2017-07-01
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
 -->
<!-- TOBE 2017-07-01 -->
<object ID="XFramePLUS" CLASSID="CLSID:D6091B5A-D59C-454b-83A4-FA489E94BE0B" width=0 height=0 VIEWASTEXT></object>
 
</body>
</html>