<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%-- TOBE 2017-07-01 점코드 글로벌 상수 --%>
<%@  page import="sepoa.svc.common.constants" %>
<%! String gam_jum_cd = constants.DEFAULT_GAM_JUMCD; %>
<%! String ict_jum_cd = constants.DEFAULT_ICT_JUMCD; %>

<% 
	Vector multilang_id = new Vector();

	multilang_id.addElement("TX_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap      text               = MessageUtil.getMessage(info, multilang_id);
	String       screen_id          = "TX_005";
	String       grid_obj           = "GridObj";
	boolean      isSelectScreen     = false;
	String       company_code       = info.getSession("COMPANY_CODE");
	String       house_code         = info.getSession("HOUSE_CODE");
	String       to_date            = SepoaDate.getShortDateString();
	int          nyear              = SepoaDate.getYear();
	String       now_year           = String.valueOf(nyear);
	String       pre_year           = String.valueOf(nyear - 1);
	String       next_year          = String.valueOf(nyear + 1);
	String       LB_DEAL_KIND       = ListBox(request, "SL0014", house_code + "#M803", ""); //거래구분
	String       LB_USE_KIND        = ListBox(request, "SL0014", house_code + "#M804", ""); //용도구분(존속기간)복구충당부채사용기간
	String       LB_BUDGET_DEPT     = ListBox(request, "SL0014", house_code + "#M805", ""); //소관부서
	String       LB_PAY_KIND_BUD    = ListBox(request, "SL0018", house_code + "#M800", "");
	String       vendorCode         = null;
	String       vendorNameLoc      = null;
	String       irsNo              = null;
	String       depositorName      = null;
	String       bankName           = null;
	String       bankAcct           = null;
	String       sumDelyAmt         = null;
	String       jumJumCd           = null;
	String       jumJumNm           = null;
	String       bankCode           = null;
	String       validPageMessage   = "유효하지 않은 접근입니다.";
	String[]     taxNo              = request.getParameterValues("tax_no");
	String[]     taxSeq             = request.getParameterValues("tax_seq");
	String       paySendNo          = request.getParameter("pay_send_no");
	StringBuffer stringBuffer       = new StringBuffer();
	int          taxNoLength        = 0;
	int          taxSeqLength       = 0;
	int          sumDelyAmtInt      = 0;
	boolean      isValidPage        = false;
	boolean      isSignedPage       = false;
	boolean      isBeforeSignedPage = false;
	
	String work_kind     = null;
	String bmsbmsyy      = null;
	String sogsogcd      = null;
	String astastgb      = null;
	String mngmngNo      = null;
	String bssbssno      = null;
	
	String appappyy      = null;
	String bmssrlno      = null;
	String appappno      = null;
	String appappam      = null;
	String accountkind   = null;
	String deal_kind     = null;
	String jumjum_cd     = null;
	String jumjum_nm     = null;
	String bdsbdscd      = null;
	String bdsbdsnm      = null;
	String deal_area     = null;
	String use_kind      = null;
	String deal_debt     = null;
	
	if(!"".equals(paySendNo)){
		if(paySendNo.length() != 0){
			Object[]            obj                = new Object[1];
			Map<String, Object> objInfo            = new HashMap<String, Object>();
			String              taxNoInfo          = null;
			String              taxSeqInfo         = null;
			String              taxNoSeq           = null;
			String              sepoaOutResultInfo = null;
			String[]            sepoaOutResult     = null;
			SepoaOut            sepoaOut           = null;
			SepoaFormater       sepoaFormater      = null;
			int                 i                  = 0;
			int                 taxNoLastIndex     = taxNoLength - 1;
			int                 rowCount           = 0;
			boolean             sepoaOutFlag       = false;
			
			for(i = 0; i < taxNoLength; i++){
				taxNoInfo  = taxNo[i];
				taxSeqInfo = taxSeq[i];
				
				stringBuffer.append("('").append(taxNoInfo).append("', '").append(taxSeqInfo).append("')");
				
				if(i != taxNoLastIndex){
					stringBuffer.append(", ");
				}
			}
			
			taxNoSeq = stringBuffer.toString();
			
			objInfo.put("taxNoSeq",   taxNoSeq);
			objInfo.put("HOUSE_CODE", house_code);
			objInfo.put("PAY_SEND_NO",paySendNo);
			
			obj[0]       = objInfo;
			sepoaOut     = ServiceConnector.doService(info, "TX_005", "CONNECTION", "selectValidVendor2", obj);
			sepoaOutFlag = sepoaOut.flag;
			
			if(sepoaOutFlag){
				sepoaOutResult     = sepoaOut.result;
				sepoaOutResultInfo = sepoaOutResult[0];
				
				sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
				
				rowCount = sepoaFormater.getRowCount();
				
				if(rowCount == 1){
					isValidPage        = true;
					vendorCode         = sepoaFormater.getValue("VENDOR_CODE",     0);
					vendorNameLoc      = sepoaFormater.getValue("VENDOR_NAME_LOC", 0);
					irsNo              = sepoaFormater.getValue("IRS_NO",          0);
					depositorName      = sepoaFormater.getValue("DEPOSITOR_NAME",  0);
					bankName           = sepoaFormater.getValue("BANK_NAME",       0);
					bankAcct           = sepoaFormater.getValue("BANK_ACCT",       0);
					bankCode           = sepoaFormater.getValue("BANK_CODE",       0);
					sepoaOut           = ServiceConnector.doService(info, "TX_005", "CONNECTION", "selectSumDelyAmt2", obj);
					sepoaOutResult     = sepoaOut.result;
					sepoaOutResultInfo = sepoaOutResult[0];
					
					sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
					
					sumDelyAmt    = sepoaFormater.getValue("AMT", 0);
					sumDelyAmtInt = Integer.parseInt(sumDelyAmt);
					
					if(sumDelyAmtInt >= 50000000){ //TOBE 2017-07-01 > 초과를 이상으로 변경 >=
						isSignedPage = true;
					}
					
					if(sumDelyAmtInt >= 200000000){ //TOBE 2107-07-01 1억초과를 2억 이상으로 변경
						isBeforeSignedPage = true;
					}
				}
				else{
					validPageMessage = "공급사 정보가 일치하지 않습니다.";
				}
			}
			
			sepoaOut     = ServiceConnector.doService(info, "TX_005", "CONNECTION", "selectSpy1gl", obj);
			sepoaOutFlag = sepoaOut.flag;
			
			if(sepoaOutFlag){
				sepoaOutResult     = sepoaOut.result;
				sepoaOutResultInfo = sepoaOutResult[0];
				
				sepoaFormater = new SepoaFormater(sepoaOutResultInfo);
				
				rowCount = sepoaFormater.getRowCount();
				
				if(rowCount == 1){
					isValidPage     = true;
					work_kind       = sepoaFormater.getValue("work_kind",   0);
					bmsbmsyy      	= sepoaFormater.getValue("bmsbmsyy", 	0);
					sogsogcd        = sepoaFormater.getValue("sogsogcd",    0);
					astastgb        = sepoaFormater.getValue("astastgb",    0);
					mngmngNo        = sepoaFormater.getValue("mngmngNo",    0);
					bssbssno        = sepoaFormater.getValue("bssbssno",    0);
					appappyy        = sepoaFormater.getValue("appappyy",    0);
					bmssrlno        = sepoaFormater.getValue("bmssrlno",    0);
					appappno        = sepoaFormater.getValue("appappno",    0);
					appappam        = sepoaFormater.getValue("appappam",    0);
					accountkind     = sepoaFormater.getValue("accountkind", 0);
					deal_kind       = sepoaFormater.getValue("deal_kind",   0);
					
					jumjum_cd     = sepoaFormater.getValue("jumjum_cd",   0);
					jumjum_nm     = sepoaFormater.getValue("jumjum_nm",   0);
					bdsbdscd      = sepoaFormater.getValue("bdsbdscd",   0);
					bdsbdsnm      = sepoaFormater.getValue("bdsbdsnm",   0);
					deal_area     = sepoaFormater.getValue("deal_area",   0);
					use_kind      = sepoaFormater.getValue("use_kind",   0);
					deal_debt     = sepoaFormater.getValue("deal_debt",   0);
				}
				else{
					validPageMessage = "공급사 정보가 일치하지 않습니다.2";
				}
			}
 
		}
	}
	
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_pay_bd_ins1_pop"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

Map map = new HashMap();
map.put("pay_send_no"		, paySendNo);
//Map<String, Object> data = new HashMap();
//data.put("header"		, map);

Object[] obj2 = {map};
SepoaOut value2= ServiceConnector.doService(info, "TX_005", "CONNECTION", "getPayList2", obj2);
SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
		_rptData.append(paySendNo);
		_rptData.append(_RF);
		_rptData.append("신규");
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
		_rptData.append(sumDelyAmt);
		
		_rptData.append(_RF);
		_rptData.append(work_kind);
		
		_rptData.append(_RF);	
		if(accountkind.equals("1")){
			_rptData.append("계좌이체");
		}else if(accountkind.equals("2")){
			_rptData.append("계좌이체 안함");
		}		
		_rptData.append(_RF);
		if("3".equals(work_kind) || "4".equals(work_kind)){
			_rptData.append(deal_kind);
		}
		
		_rptData.append(_RF);
		_rptData.append(bmsbmsyy);
		_rptData.append(_RF);
		_rptData.append(sogsogcd);
		_rptData.append(_RF);
		_rptData.append(astastgb);
		_rptData.append(_RF);
		_rptData.append(mngmngNo);
		_rptData.append(_RF);
		_rptData.append(bssbssno);
		_rptData.append(_RF);
		_rptData.append(appappyy);
		_rptData.append(" / ");
		_rptData.append(bmssrlno);
		_rptData.append(_RF);
		_rptData.append(appappno);
		_rptData.append(_RF);
		_rptData.append(appappam);
		_rptData.append(_RF);		
		if("3".equals(work_kind) || "4".equals(work_kind)){
			_rptData.append(jumjum_cd);
			_rptData.append(" / ");
			_rptData.append(jumjum_nm);
			_rptData.append(_RF);
			_rptData.append(bdsbdscd);
			_rptData.append(_RF);
			_rptData.append(bdsbdsnm);		
		}else{
			_rptData.append(_RF);
			_rptData.append(_RF);				
		}
		_rptData.append(_RF);
		
		if("4".equals(work_kind)){
			_rptData.append(deal_area);
			_rptData.append(_RF);
			_rptData.append(use_kind);
			_rptData.append(_RF);
			_rptData.append(deal_debt);
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
					_rptData.append(wf2.getValue("DELY_TO_LOCATION_NM", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("IGJM_CD", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("ITEM_NO", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("ITEM_NM", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("SPECIFICATION", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("QTY", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("UNIT_PRICE", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("AMT", i));
					_rptData.append(_RF);			
					_rptData.append(wf2.getValue("VENDOR_NAME", i));
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
<html>
<head>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
<!--
var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_bd_ins1";
		
function Init() {	//화면 초기설정 
	setGridDraw();
	doSelect();
	fnWorkKind();
}

function getSignSelect(){
	//TOBE 2017-07-01 미사용건 주석처리 GetManagerList(document.form1);
<%--
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:A6440019:직원명:차장:CHUNGJIHOON:10,";
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:19116877:직원명:차장:CHUNGJIHOON:10,";
	//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,";
	//document.getElementById("txtManagerList").value = "3 정의된 Error Message가 없습니다.0";
--%>
	
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.CO_008_Servlet",
		{
			mode           : "selectDeviceUserJsonList",
			deviceUserInfo : document.getElementById("txtManagerList").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			getSignSelectCallback(result);
		}
	);
}

function getSignSelectCallback(result){
	var signerSelect = document.getElementById("signerSelect");
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
<%
	if(isBeforeSignedPage == false){
%>
			document.getElementById("signerLineTr").style.display = "";
			document.getElementById("signerDataTr").style.display = "";
<%
	}
%>
		}
	}
	catch(e){
		alert("결재자 정보가 없습니다.");
		
		fnList();
	}
}

function getBeforeSignSelect(){
	//TOBE 2017-07-01 미사용건 주석처리 GetManagerList(document.form1);
	<%--
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:A6440019:직원명:차장:CHUNGJIHOON:10,";
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,0:19116877:직원명:차장:CHUNGJIHOON:10,";
		//document.getElementById("txtManagerList").value = "3120644|0:19611796:직원명:과장:박용범3740_3:10,";
		//document.getElementById("txtManagerList").value = "3 정의된 Error Message가 없습니다.0";
	--%>
		
	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.co.CO_008_Servlet",
		{
			mode           : "selectDeviceUserJsonList",
			deviceUserInfo : document.getElementById("txtManagerList").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			getBeforeSignSelectCallback(result);
		}
	);
}

function getBeforeSignSelectCallback(result){
	var signerSelect = document.getElementById("signerBeforeSelect");
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
			
			document.getElementById("signerBeforeLineTr").style.display = "";
			document.getElementById("signerBeforeDataTr").style.display = "";
		}
	}
	catch(e){
		alert("결재자 정보가 없습니다.");
		
		fnList();
	}
}

function fnList(){
	topMenuClick("/kr/tax/pay_budget_expense_list.jsp", "MUO141000004", "4", '');
}

function doSelect(){
	var param = "mode=getPayList2&cols_ids=<%=grid_col_id%>";
	param = param + dataOutput();
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
}

function fnPumpumamOnBlur(){
	var pumpumam      = document.getElementById("pumpumam");
	var pumpumamValue = pumpumam.value;
	
	pumpumamValue = del_comma(pumpumamValue);
	
	if(IsNumber(pumpumamValue) == false) {
        alert("숫자를 입력하세요.");
        
        pumpumam.value = "";
        pumpumam.focus();
    }
	else{
		pumpumamValue  = add_comma(pumpumamValue, 0);
		pumpumam.value = pumpumamValue;
	}	
}

function doSelectEps0019Valid(){
	var sogsogcd          = document.getElementById("sogsogcd").value;
	var astastgb          = document.getElementById("astastgb").value;
	var mngmngNo          = document.getElementById("mngmngNo").value;
	var bssbssno          = document.getElementById("bssbssno").value;
	var pumpumdt          = document.getElementById("pumpumdt").value;
	var pumpumam          = document.getElementById("pumpumam").value;
	var rdoWorkKind       = document.getElementsByName("rdo_work_kind");
	var i                 = 0;
	var rdoWorkKindLength = rdoWorkKind.length;
	var isChecked         = false;
	var rdoWorkKindInfo   = null;
	var rdoWorkKindValue  = null;
	
	for(i = 0; i < rdoWorkKindLength; i++){
		rdoWorkKindInfo = rdoWorkKind[i];
		
		if(rdoWorkKindInfo.checked){
			isChecked        = true;
			rdoWorkKindValue = rdoWorkKindInfo.value;
			
			break;
		}
	}
	
	if(isChecked == false){
		alert("업무를 선택하여 주십시오.");
		
		return false;
	}
	
	if(sogsogcd == ""){
		alert("소관부서를 선택하여 주십시오.");
		
		return false;
	}
	
	if(astastgb == ""){
		alert("자산구분을 선택하여 주십시오.");
		
		return false;
	}
	
	if(rdoWorkKindValue == "1"){
		if(
			(astastgb != "4") &&
			(astastgb != "5") &&
			(astastgb != "6") &&
			(astastgb != "7")
		){
			alert("자산구분 선택을 동산기구, 동산집기, 차량, 간판 중에 선택하여 주십시오.");
			
			return false;
		}
	}
	else if(rdoWorkKindValue == "2"){
		if(
			(astastgb != "4") &&
			(astastgb != "5") &&
			(astastgb != "6") &&
			(astastgb != "7")
		){
			alert("자산구분 선택을 동산기구, 동산집기, 차량, 간판 중에 선택하여 주십시오.");
			
			return false;
		}
	}
	else if(rdoWorkKindValue == "3"){
		if(
			(astastgb != "1") &&
			(astastgb != "2")
		){
			alert("자산구분 선택을 업무용건물, 업무용토지 중에 선택하여 주십시오.");
			
			return false;
		}
	}
	else if(rdoWorkKindValue == "4"){
		if(
			(astastgb != "2")
		){
			alert("자산구분 선택을 업무용건물로 선택하여 주십시오.");
			
			return false;
		}
	}
	
	if(mngmngNo == ""){
		alert("관리구분을 선택하여 주십시오.");
		
		return false;
	}
	
	if(bssbssno == ""){
		alert("사업구분을 선택하여 주십시오.");
		
		return false;
	}
	
	if(pumpumdt == ""){
		alert("품의일자를 선택하여 주십시오.");
		
		return false;
	}
	
	if(pumpumam == ""){
		alert("품의금액을 입력하여 주십시오.");
		
		return false;
	}
	
	return true;
}

function doSelectEps0019(){
	var bmsbmsyy = document.getElementById("bmsbmsyy").value;
	var sogsogcd = document.getElementById("sogsogcd").value;
	var astastgb = document.getElementById("astastgb").value;
	var mngmngNo = document.getElementById("mngmngNo").value;
	var bssbssno = document.getElementById("bssbssno").value;
	var pumpumdt = document.getElementById("pumpumdt").value;
	var pumpumam = document.getElementById("pumpumam").value;
	var isValid  = doSelectEps0019Valid();
	
	if(isValid == false){
		return;
	}
	
	$("#doSelectEps0019Div").hide();
	
	$.post(
		servletUrl,
		{
			mode     : "getEps0019",
			bmsbmsyy : bmsbmsyy,
			sogsogcd : sogsogcd,
			astastgb : astastgb,
			mngmngNo : mngmngNo,
			bssbssno : bssbssno,
			pumpumdt : pumpumdt,
			pumpumam : pumpumam
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			doSelectEps0019Callback(result);
		}
	);
}

function doSelectEps0019Callback(result){
	var code     = result.code;
	var appappyy = document.getElementById("appappyy");
	var bmssrlno = document.getElementById("bmssrlno");
	var appappno = document.getElementById("appappno");
	var appappam = document.getElementById("appappam");
	
	if(code == "200"){
		appappyy.value = result.year;
		bmssrlno.value = result.number;
		appappno.value = result.appNumber;
		appappam.value = result.appAmt;
		appappam.value = add_comma(appappam.value, 0);
	}
	else{
		alert(result.useMessage);
		
		$("#doSelectEps0019Div").show();
	}
}

//부동산조회 EPS0020 고유번호 부동산명칭 조회
function doSelectEps0020(){
	var frm = document.frmEps0020;
	var url = "pay_pp_lis1.jsp";
	
	frm.JUMJUMCD.value = $('#jumjum_cd').val();		//소속점
	frm.JUMJUMNM.value = $('#jumjum_nm').val();		//소속점명
	var rdo_val       = $("input:radio[name=rdo_work_kind]:checked").val();
	if(rdo_val == '3'){
		frm.ASTASTCD.value = '20';		//자산 구분
	}else if(rdo_val == '4'){
		frm.ASTASTCD.value = '30';		//자산 구분
	}
	
	if((frm.JUMJUMCD.value).length > 0){
		var win = window.open("","doPop","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=700,height=500,left=0,top=0");
	
		frm.method = "POST";
		frm.target = "doPop";
		frm.action = url;
		frm.submit();
		win.focus();
		
	}
	else{
		alert("소속점코드를 선택하셔야 합니다.");
	}
}

function doSelectEps0020Callback(bdsBdsCd, bdsBdsNm){
	document.getElementById("bdsBdsCd").value  = bdsBdsCd;
	document.getElementById("bdsBdsNm").value  = bdsBdsNm;
	document.getElementById("deal_debt").value = "";
}

function fnDealAreaOnBlur(){
	var dealArea = document.getElementById("deal_area");
	var dealAreaValue = dealArea.value;
	
	dealAreaValue = del_comma(dealAreaValue);
	
	if(IsNumber(dealAreaValue) == false) {
        alert("숫자를 입력하세요.");
        
        dealArea.value = "";
        dealArea.focus();
    }
	else{
		dealAreaValue  = add_comma(dealAreaValue, 0);
		dealArea.value = dealAreaValue;
	}
}

//예산체크 EPS0021
function doSelectEps0021(){
	var bdsBdsCd = document.getElementById("bdsBdsCd").value;
	var dealArea = document.getElementById("deal_area").value;
	
	if(bdsBdsCd == ""){
		alert("부동산 고유번호를 선택하셔야 합니다.");
		
		return;
	}
	
	if(dealArea == ""){
		alert("전용면적을 입력하셔야 합니다.");
		
		return;
	}
	
	$("#doSelectEps0021Div").hide();
	
	$.post(
		servletUrl,
		{
			mode     : "getEps0021",
			bdsBdsNo : bdsBdsCd,
			durtermy : document.getElementById("use_kind").value,
			useUseVl : dealArea
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			doSelectEps0021Callback(result);
		}
	);
}

function doSelectEps0021Callback(result){
	var code     = result.code;
	var dealDebt = "";
	
	if(code == "200"){
		dealDebt = add_comma(result.dealDebt, 0);
	}
	else{
		alert(result.useMessage);
	}
	
	document.getElementById("deal_debt").value = dealDebt;
	
	$("#doSelectEps0021Div").show();
}

function fnTcpResult(){
	var checkCnt            = 0;
	var account_type 	    = "";		//계정유형
	var buy_place 			= "";		//매입처
	var dely_to_location 	= "";		//배치(설치)점
	var dosunqno         	= "";		//고유번호(2)
	var jumjumcd         	= "";		//소속점코드
	var tx_data             = "";		//유일키자료
	
	for(var i=0; i<GridObj.GetRowCount(); i++){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			checkCnt ++;
			
			if(checkCnt == 1){
				account_type 		= GridObj.GetCellValue("ACCOUNT_TYPE"      , i);
				buy_place 			= GridObj.GetCellValue("BUY_PLACE"         , i);
				dely_to_location	= GridObj.GetCellValue("DELY_TO_LOCATION"  , i);
				dosunqno        	= GridObj.GetCellValue("DOSUNQNO"          , i);
				jumjumcd        	= GridObj.GetCellValue("JUMJUMCD"          , i);
			
				tx_data += GridObj.GetCellValue("ACCOUNT_TYPE", i) + "-" + GridObj.GetCellValue("JUMJUMCD", i);
			}
		}
	}

	if(checkCnt == 0){
		alert("선택하신 항목이 없습니다.");
		
		return;
	}

	
	if(!confirm("이체실행을 진행하시겠습니까?")){
		return;
	}

		
	document.frmOt8701.account_type.value       = account_type 	;
	document.frmOt8701.buy_place.value		    = buy_place 	;
	document.frmOt8701.dely_to_location.value	= dely_to_location;
	document.frmOt8701.dosunqno.value	        = dosunqno        ;
	document.frmOt8701.jumjumcd.value	        = jumjumcd        ;
		
	var url  = "/kr/tax/pay_pp_ins1.jsp";
	
	window.open("","doRequest","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	
	document.frmOt8701.method = "POST";
	document.frmOt8701.action = url;
	document.frmOt8701.target = "doRequest";
	document.frmOt8701.submit();
}

function fnEpsResult(){
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rdo_val    = $("input:radio[name=rdo_work_kind]:checked").val();
	var params;
	var mode;
	
	if(rdo_val == "1"){
		params = "?mode=getEps0015";
		params += "&cols_ids=<%=grid_col_id%>";
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(servletUrl + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
	else if(rdo_val == "2"){
		params = "?mode=getEps0016";
		params += "&cols_ids=<%=grid_col_id%>";
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(servletUrl + params);
		
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	}
	else if(rdo_val == "3"){
		fnEpsResult0017();
	}
	else if(rdo_val == "4"){
		var deal_debt = document.getElementById("deal_debt").value;
		
		if(deal_debt == ""){
			fnEpsResult0017();
		}
		else{
			fnEpsResult0018();
		}
	}
}

function fnEpsResult0017(){
	$.post(
		servletUrl,
		{
			mode      : "getEps0017",
			appappyy  : document.getElementById("appappyy").value,
			bmssrlno  : document.getElementById("bmssrlno").value,
			appappno  : document.getElementById("appappno").value,
			appappam  : document.getElementById("appappam").value,
			jumjum_cd : document.getElementById("jumjum_cd").value,
			bdsBdsCd  : document.getElementById("bdsBdsCd").value,
			deal_kind : document.getElementById("deal_kind").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			fnEpsResultCallback(result);
		}
	);	
}

function fnEpsResult0018(){
	$.post(
		servletUrl,
		{
			mode      : "getEps0018",
			appappyy  : document.getElementById("appappyy").value,
			bmssrlno  : document.getElementById("bmssrlno").value,
			appappno  : document.getElementById("appappno").value,
			appappam  : document.getElementById("appappam").value,
			jumjum_cd : document.getElementById("jumjum_cd").value,
			bdsBdsCd  : document.getElementById("bdsBdsCd").value,
			deal_kind : document.getElementById("deal_kind").value,
			use_kind  : document.getElementById("use_kind").value,
			deal_area : document.getElementById("deal_area").value,
			deal_debt : document.getElementById("deal_debt").value
		},
		function(arg){
			var result = eval("(" + arg + ")");
			
			fnEpsResultCallback(result);
		}
	);
}

function fnEpsResultCallback(result){
	var code = result.code;
	
	if(code != "200"){
		alert(result.message);
	}
}

/* //업무선택 후 부동산 조회 할성여부 */
function fnWorkKind(){
	var rdo_val       = $("input:radio[name=rdo_work_kind]:checked").val();
	var divRealEstate = document.getElementById("divRealEstate");
	var divDebt       = document.getElementById("divDebt");
	//var chkDebtLineTr = document.getElementById("chkDebtLineTr");
	//var chkDebtDataTr = document.getElementById("chkDebtDataTr");
		
	if(rdo_val == '3' || rdo_val == '4'){	//부동산 조회 활성
		divRealEstate.style.display = "";
		divDealKindText.style.display = "";
		//divDealKind.style.display = "";
		
		//부동산조회 구분 20:업무용부동산 30:임차전포시설물
		if(rdo_val == '3'){
			//$('#astast_cd').val('20');
			//chkDebtLineTr.style.display = "none";
			//chkDebtDataTr.style.display = "none";
			divDebt.style.display = "none";
		}else if(rdo_val == '4'){
			//$('#astast_cd').val('30');
			//chkDebtLineTr.style.display = "";
			//chkDebtDataTr.style.display = "";
			divDebt.style.display = "";
		}

	}else{									//부동산 조회 비활성
		divRealEstate.style.display = "none";
		divDebt.style.display = "none";
		//$("input[name=chk_debt]").attr("checked",$("input[name=chk_debt]").is(".checked"));
		divDealKindText.style.display = "none";
		//divDealKind.style.display = "none";
		
		//$('#astast_cd').val('');	
	}
	fnInitEps0019Input();
} 

function fnDebtChk(){
	//chk_debt
	var chk_debt = $("input[name=chk_debt]:checked").val();
	
	//document.getElementById("deal_area").value = "";
	//document.getElementById("deal_debt").value = "";
	
	//if(chk_debt == '1'){
	//	divDebt.style.display = "";
	//}
	//else{
	//	divDebt.style.display = "none";
	//}
}

//자산(대분류), 관리(중분류), 사업(소분류) 
function fnAstastgbOnChange() {
	fnChangeEps0019Input();
	fnMngmngNoInit();
	fnBssbssNoInit();
    setPayKindBus("----------", "");
 
  	var astastgb = document.getElementById("astastgb");
  	var mngmngNo = document.getElementById("mngmngNo");
  	var param    = "<%=house_code%>";
  	var option   = document.createElement("option");
  	
  	param = param + "#" + "M801";
  	param = param + "#" + astastgb.value;
  
	option.text  = ":::선택:::";
	option.value = "";
	
	mngmngNo.add(option, 0);
	
	doRequestUsingPOST( 'SL0009', param ,'mngmngNo', '', false);	//false:동기, true:비동기모드
}

//관리(중분류)
function fnPayKindMngChanged(){
	fnChangeEps0019Input();
	fnBssbssNoInit();
	        
    var mngmngNo = document.getElementById("mngmngNo");
    var bssbssno = document.getElementById("bssbssno");
  	var param    = "<%=house_code%>";
  	var option   = document.createElement("option");
  	
  	param = param + "#" + "M802";
  	param = param + "#" + mngmngNo.value;
    
    option.text = ":::선택:::";
    option.value = "";
    
    bssbssno.add(option, 0);
    
    doRequestUsingPOST( 'SL0019', param ,'bssbssno', '', false);
}


function fnMngmngNoInit() {
    if(form1.mngmngNo.length > 0) {
        for(i=form1.mngmngNo.length-1; i>=0;  i--) {
            form1.mngmngNo.options[i] = null;
        }
    }
}

function fnBssbssNoInit() {
    if(form1.bssbssno.length > 0) {
        for(i=form1.bssbssno.length-1; i>=0;  i--) {
            form1.bssbssno.options[i] = null;
        }
    }
}


function setPayKindMng(name, value) {
    var option1 = new Option(name, value, true);
    form1.pay_kind_mng.options[form1.pay_kind_mng.length] = option1;
}

function setPayKindBus(name, value){
    var option1 = new Option(name, value, true);
    
    form1.bssbssno.options[form1.bssbssno.length] = option1;
}

//소속점코드
function searchProfile(part)
{
	var f = document.forms[0];

    if(part == "jumjum")
	{
		alert(f.company_code.value)
		if(!checkEmpty(f.company_code, "회사단위를 먼저 선택해야 합니다.")) //"회사단위를 먼저 선택해야 합니다."
			return;
		window.open("/common/CO_009.jsp?callback=getDept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

}

function getDept(code, text) {
	document.forms[0].jumjum_cd.value = code;
	document.forms[0].jumjum_nm.value = text;
	
	document.getElementById("bdsBdsCd").value = "";
	document.getElementById("bdsBdsNm").value = "";
	document.getElementById("chk_debt").checked = false;
	fnDebtChk();
}

function eps0024Insert(szRow, COL_NAME, DOSUNQNO_VAL) {
	var selectedId    = GridObj.getSelectedId();
	var dosUnqNoIndex = GridObj.getColIndexById("DOSUNQNO");
	
	GridObj.cells(selectedId, dosUnqNoIndex).setValue(DOSUNQNO_VAL);
}

function fnInitEps0019Input(){
	//document.getElementById("bmsbmsyy").value = "<%=now_year%>";
	//document.getElementById("sogsogcd").value = "";
	//document.getElementById("astastgb").value = "";
	//document.getElementById("mngmngNo").value = "";
	//document.getElementById("bssbssno").value = "";
	//document.getElementById("pumpumdt").value = "<%=SepoaString.getDateSlashFormat(to_date) %>";
	//document.getElementById("appappyy").value = "";
	//document.getElementById("bmssrlno").value = "";
	//document.getElementById("appappno").value = "";
	//document.getElementById("appappam").value = "";
	
	$("#doSelectEps0019Div").show();
	
	fnInitEps0020Input();
}

function fnChangeEps0019Input(){
	document.getElementById("appappyy").value = "";
	document.getElementById("bmssrlno").value = "";
	document.getElementById("appappno").value = "";
	document.getElementById("appappam").value = "";
	
	$("#doSelectEps0019Div").show();
	
	fnInitEps0020Input();
}

function fnInitEps0020Input(){
	//document.getElementById("jumjum_cd").value = "";
	//document.getElementById("jumjum_nm").value = "";
	//document.getElementById("astast_cd").value = "";
	//document.getElementById("bdsBdsNm").value = "";
	//document.getElementById("bdsBdsCd").value = "";
	//document.getElementById("chk_debt").checked = false;
	//fnDebtChk();
}




var GridObj         = null;
var MenuObj         = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var rowIndex         = GridObj.getRowIndex(rowId);
	var dosunqNoColIndex = GridObj.getColIndexById("DOSUNQNO");
	
	if(cellInd == dosunqNoColIndex) {
		var pmkpmkCdColIndex = GridObj.getColIndexById("ITEM_NO");
		var pmkpmkNmColIndex = GridObj.getColIndexById("ITEM_NM");
		var jumjumCdColIndex = GridObj.getColIndexById("DELY_TO_LOCATION");
		var jumjumNmColIndex = GridObj.getColIndexById("DELY_TO_LOCATION_NM");
		var qtyColIndex      = GridObj.getColIndexById("QTY");
		var dosunqNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, dosunqNoColIndex);
		var pmkpmkCdColValue = GD_GetCellValueIndex(GridObj, rowIndex, pmkpmkCdColIndex);
		var pmkpmkNmColValue = GD_GetCellValueIndex(GridObj, rowIndex, pmkpmkNmColIndex);
		var jumjumCdColValue = GD_GetCellValueIndex(GridObj, rowIndex, jumjumCdColIndex);
		var jumjumNmColValue = GD_GetCellValueIndex(GridObj, rowIndex, jumjumNmColIndex);
		var qtyColValue      = Number(GD_GetCellValueIndex(GridObj, rowIndex, qtyColIndex));
		var url              = "pay_pp_lis2.jsp";
<%--
		//url = url + "?jumjumcd=" + "20644";
		//url = url + "&jumjumnm=" + encodeUrl("총무부");
		//url = url + "&pmkpmkcd=" + "153100";
		//url = url + "&pmkpmknm=" + encodeUrl("피아노");
--%>
		if(qtyColValue > 1){
			alert("여러 수량의 경우 고유번호를 조회할 수 없습니다.");
		}
		else{
			url = url + "?jumjumcd=" + jumjumCdColValue;
			url = url + "&jumjumnm=" + encodeUrl(jumjumNmColValue);
			url = url + "&pmkpmkcd=" + pmkpmkCdColValue;
			url = url + "&pmkpmknm=" + encodeUrl(pmkpmkNmColValue);
			
			popUpOpen(url, 'GridCellClick', '720', '650');
		}
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
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
    
    if(status == "true") {
    	topMenuClick("/kr/tax/pay_budget_give_list.jsp", "MUO141000004", "4", '');
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
    var msg    = GridObj.getUserData("", "message");
    var status = GridObj.getUserData("", "status");
    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    //tcpCheck();
    //setTotAmt();
     
    return true;
}

function setTotAmt(){
	var rowCount    = GridObj.GetRowCount();
    var i           = 0;
    var amtColIndex = GridObj.getColIndexById("AMT");
    var amtColValue = null;
    var pumpumam    = document.getElementById("pumpumam");
    var totAmt      = 0;
    
    for(i = 0; i < rowCount; i++){
    	amtColValue = GD_GetCellValueIndex(GridObj, i, amtColIndex);
    	totAmt      = totAmt + Number(amtColValue);
    }
    
    totAmt         = add_comma(totAmt, 0);
    pumpumam.value = totAmt;
}

function getGwCd(itemNo){
	var itemNoFirst = itemNo.substring(0, 1);
	var result      = null;
	
	if(
		(itemNo.length == 6) &&
		(itemNoFirst == "6")
	){
		result = "18351100000";
	}
	else{
		result = "18364100000";
	}
	
	return result;
}

function tcpCheck(){
	var rowCount             = GridObj.GetRowCount();
	var i                    = 0;
	var igjmCdColIndex       = GridObj.getColIndexById("IGJM_CD");
    var itemNoColIndex       = GridObj.getColIndexById("ITEM_NO");
    var materialTypeColIndex = GridObj.getColIndexById("MATERIAL_TYPE");
    var igjmCdArray          = new Array();
    var gwCdArray            = new Array();
    var igjmCdColValue       = null;
    var itemNoColValue       = null;
    var gwCdValue            = null;
    var j                    = 0;
    var igjmCdArrayValue     = null;
    var gwCdArrayValue       = null;
    var tcpCount             = 0;
    var materialTypeColValue = null;
    
    for(i = 0; i < rowCount; i++){
    	igjmCdColValue       = GD_GetCellValueIndex(GridObj, i, igjmCdColIndex);
    	itemNoColValue       = GD_GetCellValueIndex(GridObj, i, itemNoColIndex);
    	materialTypeColValue = GD_GetCellValueIndex(GridObj, i, materialTypeColIndex);
    	
    	if(materialTypeColValue == "02"){
    		gwCdValue = getGwCd(itemNoColValue);
        	
        	for(j = 0; j < igjmCdArray.length; j++){
        		igjmCdArrayValue = igjmCdArray[j];
        		gwCdArrayValue   = gwCdArray[j];
        		
        		if(
        			(igjmCdArrayValue == igjmCdColValue) &&
        			(gwCdArrayValue == gwCdValue)
        		){
        			break;
        		}
        	}
        	
        	if(igjmCdArray.length == j){
        		igjmCdArray[j] = igjmCdColValue;
        		gwCdArray[j]   = gwCdValue;
        	}
    	}
    }
    
    for(j = 0; j < igjmCdArray.length; j++){
    	igjmCdArrayValue = igjmCdArray[j];
    	
    	// ASIS 2017-07-01
    	//if(igjmCdArrayValue == "20644"){
    		
    	// TOBE 2017-07-01 총무부 점코드
    	if(igjmCdArrayValue == gam_jum_cd){	
    		tcpCount++;
    	}
    	else{
    		tcpCount = tcpCount + 3;
    	}
    }
    
    if(tcpCount > 30){
    	alert("전문 생성 가능 범위를 넘어갔습니다.");
    	
    	fnList();
    }
}

//TOBE 2017-07-01 미사용건 주석처리 
//function GetBrowserInfo(form){
//	try{
//		var ret = WooriDeviceForOcx.OpenDevice();
//		var msg;
//		
//		if( ret == 0 ){
//			ret = WooriDeviceForOcx.GetTerminalInfo(30);
//			
//			if( ret == 0 ){
//				msg = WooriDeviceForOcx.GetResult();
//				
//				var arr = msg.split('');
//				
//				if(arr.length > 0 && arr[0].length==10){
//					if(arr[1] == ""){
//						alert("통합 단말에서 사용자 정보를 조회할 수 없습니다.");
//						
//						fnList();
//					}
//					else if(arr[1] != "<%=info.getSession("ID") %>"){
//						alert("통합 단말과 로그인 사용자 정보가 일치하지 않습니다.");
//						
//						fnList();
//					}
//					
//					$('#bk_cd').val(arr[0].substr(0,5));
//					$('#br_cd').val(arr[0].substr(5,1));
//					$('#trm_bno').val(arr[0].substr(6,3));
//					$('#user_trm_no').val(arr[0].substr(0,10) + arr[1]);
//					$('#txtBrowserInfo').val(arr[0]);
//				}
//				else{
//					alert("통합 단말 정보가 올바르지 않습니다.");
//					
//					fnList();
//				}
//			}
//			else{
//				msg = WooriDeviceForOcx.GetErrorMsg(ret);
//				
//				alert(msg);
//				
//				fnList();
//			}
//			
//			WooriDeviceForOcx.CloseDevice();
//		}
//		else{
//			msg = WooriDeviceForOcx.GetErrorMsg(ret);
//			
//			alert(msg);
//			
//			fnList();
//		}
//	}
//	catch(e){
//		alert("Device정보가 올바르지 않습니다.");
//		
//		fnList();
//	}	
//}

//TOBE 2017-07-01 미사용건 주석처리 
//function GetManagerList(form){
//	var ret = WooriDeviceForOcx.OpenDevice();
//	var msg;
//	
//	if(ret == 0){
//		var nLevel = form.txtLevel.value;
//		
//		ret = WooriDeviceForOcx.GetManagerList(nLevel,30);
//		
//		if(ret == 0){
//			msg = WooriDeviceForOcx.GetResult();
//			
//			form.txtManagerList.value = msg;
//		}
//		else{
//			msg = WooriDeviceForOcx.GetErrorMsg(ret);
//			
//			alert(msg);
//			
//			fnList();
//		}
//	
//		WooriDeviceForOcx.CloseDevice();
//	}
//	else{
//		msg = WooriDeviceForOcx.GetErrorMsg(ret);
//		
//		alert(msg);
//		
//		fnList();
//	}
//}

//결재선지정
function doApproval(){  
<%
	if(isBeforeSignedPage){
%>
	var signerBeforeSelect = document.getElementById("signerBeforeSelect");
	
	if(signerBeforeSelect.value == ""){
		alert("1차 책임자를 선택하여 주십시오.");
		
		return;
	}
<%
	}

	if(isSignedPage){
%>
	var signerSelect = document.getElementById("signerSelect");
	
	if(signerSelect.value == ""){
		alert("책임자를 선택하여 주십시오.");
		
		return;
	}

	if (document.getElementById("signerBeforeSelect") != null){
		if(signerBeforeSelect.value == signerSelect.value){
			alert("책임자를 다른 사용자로 지정해 주시기 바랍니다.");
			
			return;
		}
	}
<%
	}
%>
	var rdoWorkKind          = document.getElementsByName("rdo_work_kind");
	var accountKind          = document.getElementsByName("accountKind");
	var rdoWorkKindLength    = rdoWorkKind.length;
	var i                    = 0;
	var rdoWorkKindInfo      = null;
	var rdoWorkKindIsChecked = false;
	var rdoWorkKindValue     = document.getElementById("rdoWorkKindValue");
	var dealDebt             = document.getElementById("deal_debt");
	var accountKindValue     = document.getElementById("accountKindValue");
	var isValid              = false;
	var rowCount             = GridObj.GetRowCount();
	var selectedIndex        = GridObj.getColIndexById("SELECTED");
	var rowid                = null;
	var accountKindLength    = accountKind.length;
	var accountKindInfo      = null;
	var accountKindIsChecked = false;
	
	for(i = 0; i < rdoWorkKindLength; i++){
		rdoWorkKindInfo = rdoWorkKind[i];
		
		if(rdoWorkKindInfo.checked){
			rdoWorkKindIsChecked   = true;
			rdoWorkKindValue.value = rdoWorkKindInfo.value;
			
			break;
		}
	}
	
	if(rdoWorkKindIsChecked == false){
		alert("업무를 선택하여 주십시오.");
		
		return;
	}
	
	for(i = 0; i < accountKindLength; i++){
		accountKindInfo = accountKind[i];
		
		if(accountKindInfo.checked){
			accountKindIsChecked   = true;
			accountKindValue.value = accountKindInfo.value;
		}
	}
	
	if(accountKindIsChecked == false){
		alert("이체여부를 선택하여 주십시오.");
		
		return;
	}
	
	if(accountKindValue.value == "1"){
<%
	if("020".equals(bankCode) == false){
%>
		alert("'계좌이체'는 우리은행 계좌만 가능합니다.");
		
		return;
<%
	}
%>
	}
	document.forms[0].target = "childframe";
	document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
	document.forms[0].method = "POST";
	document.forms[0].submit();	
	
}

//결재선 지정후 실제 결재요청하는 함수(app_aproval_list3.jsp에서 넘어옴)
function getApproval1(Approval_str) {

	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cont_no = "";
	var subject = "";
	var cont_amt = "";

	for(var i = 0; i < grid_array.length; i++)
	{ 
		cont_no   = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_NO")).getValue()));
	 	subject   = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SUBJECT")).getValue()));
	 	cont_amt  = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_AMT")).getValue();
		cont_gl_seq = encodeUrl(LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_GL_SEQ")).getValue()));
	}
	 
	if (Approval_str == "") {
		alert("<%=text.get("CT_014.MSG_001")%>");//결재자를 지정해 주세요.
		return;
	}
	  
	var param = "";
	param += "&APPROVAL_STR="+encodeUrl(Approval_str);		//결재요청건의 결재선
	param += "&CONT_NO="+cont_no;	 	
	param += "&CONT_GL_SEQ="+cont_gl_seq;	 	
	param += "&SUBJECT="+subject;	
	param += "&CONT_AMT="+cont_amt;	 
	
	if (confirm("<%=text.get("CT_014.MSG_002")%>")){	//결재요청 하시겠습니까?
   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
		var cols_ids = "<%=grid_col_id%>";
	    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_list?cols_ids="+cols_ids+"&mode=approval"+param);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
   }
}

function getApproval(Approval_str){
	
	if (Approval_str == "") {
		alert("<%=text.get("CT_014.MSG_001")%>");//결재자를 지정해 주세요.
		return;
	}
	
<%
	if(isBeforeSignedPage){
%>
	var signerBeforeSelect = document.getElementById("signerBeforeSelect");
	
	if(signerBeforeSelect.value == ""){
		alert("1차 책임자를 선택하여 주십시오.");
		
		return;
	}
<%
	}

	if(isSignedPage){
%>
	var signerSelect = document.getElementById("signerSelect");
	
	if(signerSelect.value == ""){
		alert("책임자를 선택하여 주십시오.");
		
		return;
	}

	if (document.getElementById("signerBeforeSelect") != null){
		if(signerBeforeSelect.value == signerSelect.value){
			alert("책임자를 다른 사용자로 지정해 주시기 바랍니다.");
			
			return;
		}
	}
<%
	}
%>
	var rdoWorkKind          = document.getElementsByName("rdo_work_kind");
	var accountKind          = document.getElementsByName("accountKind");
	var rdoWorkKindLength    = rdoWorkKind.length;
	var i                    = 0;
	var rdoWorkKindInfo      = null;
	var rdoWorkKindIsChecked = false;
	var rdoWorkKindValue     = document.getElementById("rdoWorkKindValue");
	var dealDebt             = document.getElementById("deal_debt");
	var accountKindValue     = document.getElementById("accountKindValue");
	var isValid              = false;
	var rowCount             = GridObj.GetRowCount();
	var selectedIndex        = GridObj.getColIndexById("SELECTED");
	var rowid                = null;
	var accountKindLength    = accountKind.length;
	var accountKindInfo      = null;
	var accountKindIsChecked = false;
	
	for(i = 0; i < rdoWorkKindLength; i++){
		rdoWorkKindInfo = rdoWorkKind[i];
		
		if(rdoWorkKindInfo.checked){
			rdoWorkKindIsChecked   = true;
			rdoWorkKindValue.value = rdoWorkKindInfo.value;
			
			break;
		}
	}
	
	if(rdoWorkKindIsChecked == false){
		alert("업무를 선택하여 주십시오.");
		
		return;
	}
	
	for(i = 0; i < accountKindLength; i++){
		accountKindInfo = accountKind[i];
		
		if(accountKindInfo.checked){
			accountKindIsChecked   = true;
			accountKindValue.value = accountKindInfo.value;
		}
	}
	
	if(accountKindIsChecked == false){
		alert("이체여부를 선택하여 주십시오.");
		
		return;
	}
	
	if(accountKindValue.value == "1"){
<%
	if("020".equals(bankCode) == false){
%>
		alert("'계좌이체'는 우리은행 계좌만 가능합니다.");
		
		return;
<%
	}
%>
	}
	
	if(rdoWorkKindValue.value == "1"){
		isValid = fnCreateEps0015Valid();
	}
	else if(rdoWorkKindValue.value == "2"){
		isValid = fnCreateEps0016Valid();
	}
	else if(rdoWorkKindValue.value == "3"){
		isValid = fnCreateEps0017Valid();
	}
	else if(rdoWorkKindValue.value == "4"){
		if(dealDebt.value == ""){
			rdoWorkKindValue.value = "3";
			isValid                = fnCreateEps0017Valid();
		}
		else{
			isValid = fnCreateEps0018Valid();
		}
	}
	
	if(isValid == false){
		return;
	}
	
	for(i = 0; i < rowCount; i++){
		rowid = GridObj.getRowId(i);
		
		GridObj.cells(rowid, selectedIndex).cell.wasChanged = true;
		GridObj.cells(rowid, selectedIndex).setValue("1");
	}
	
	if(confirm("결재요청 하시겠습니까?")){
		var grid_array = getGridChangedRows(GridObj, "SELECTED");
		var subject = "<%=vendorNameLoc%> 자본예산지급 결재요청건";
		var params;				
		params = "?mode=insetSpy1Info";
		params += "&cols_ids=<%=grid_col_id%>";
		params += "&APPROVAL_STR="+encodeUrl(Approval_str);		//결재요청건의 결재선
		params += "&SUBJECT="+subject;
		params += dataOutput();
		
		myDataProcessor = new dataProcessor(servletUrl + params);
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	}
}

function fnCreateEps0015Valid(){
	var appappam          = document.getElementById("appappam");
	var i                 = 0;
	var rowCount          = GridObj.GetRowCount();
	var materialTypeIndex = GridObj.getColIndexById("MATERIAL_TYPE");
	var materialTypeValue = null;
	
	if(appappam.value == ""){
		alert("공통예산을 조회하여 주십시오.");
		
		return false;
	}
	
	for(i = 0; i < rowCount; i++){
		materialTypeValue = GD_GetCellValueIndex(GridObj, i, materialTypeIndex);
		
		if(materialTypeValue != "02"){
			alert("재산관리 품목만 처리가 가능합니다.");
			
			return false;
		}
	}
	
	return true;
}

function fnCreateEps0016Valid(){
	var appappam            = document.getElementById("appappam");
	var rowCount            = GridObj.GetRowCount();
	var i                   = 0;
	var dosUnqNoIndex       = GridObj.getColIndexById("DOSUNQNO");
	var materialTypeIndex   = GridObj.getColIndexById("MATERIAL_TYPE");
	var delyToLocationIndex = GridObj.getColIndexById("DELY_TO_LOCATION");
	var dosUnqNoValue       = null;
	var materialTypeValue   = null;
	var delyToLocationValue = null;
	var delyToLocation      = null;
	
	if(appappam.value == ""){
		alert("공통예산을 조회하여 주십시오.");
		
		return false;
	}
	
	for(i = 0; i < rowCount; i++){
		dosUnqNoValue       = GD_GetCellValueIndex(GridObj, i, dosUnqNoIndex);
		materialTypeValue   = GD_GetCellValueIndex(GridObj, i, materialTypeIndex);
		delyToLocationValue = GD_GetCellValueIndex(GridObj, i, delyToLocationIndex);
		
		if(i == 0){
			delyToLocation = delyToLocationValue;
		}
		else{
			if(delyToLocation != delyToLocationValue){
				alert("동일한 배치(설치)점만 처리 가능합니다.");
				
				return false;
			}
		}
		
		if(materialTypeValue != "02"){
			alert("재산관리 품목만 처리가 가능합니다.");
			
			return false;
		}
		
		if(dosUnqNoValue == ""){
			alert("고유번호를 조회하여 주십시오.");
			
			return false;
		}
	}
	
	return true;
}

function fnCreateEps0017Valid(){
	var appappam          = document.getElementById("appappam");
	var bdsBdsCd          = document.getElementById("bdsBdsCd");
	var dealKind          = document.getElementById("deal_kind");
	var rowCount          = GridObj.GetRowCount();
	var i                 = 0;
	var materialTypeIndex = GridObj.getColIndexById("MATERIAL_TYPE");
	var materialTypeValue = null;
	
	if(appappam.value == ""){
		alert("공통예산을 조회하여 주십시오.");
		
		return false;
	}
	
	if(bdsBdsCd.value == ""){
		alert("부동산 정보를 조회하여 주십시오.");
		
		return false;
	}
	
	if(dealKind.value == ""){
		alert("거래 구분을 선택하여 주십시오.");
		
		return false;
	}
	
	for(i = 0; i < rowCount; i++){
		materialTypeValue = GD_GetCellValueIndex(GridObj, i, materialTypeIndex);
		
		if(materialTypeValue != "04"){
			alert("시설공사/재산관리 품목만 처리가 가능합니다.");
			
			return false;
		}
	}
	
	return true;
}

function fnCreateEps0018Valid(){
	var appappam          = document.getElementById("appappam");
	var bdsBdsCd          = document.getElementById("bdsBdsCd");
	var dealKind          = document.getElementById("deal_kind");
	var rowCount          = GridObj.GetRowCount();
	var i                 = 0;
	var materialTypeIndex = GridObj.getColIndexById("MATERIAL_TYPE");
	var materialTypeValue = null;
	
	if(appappam.value == ""){
		alert("공통예산을 조회하여 주십시오.");
		
		return false;
	}
	
	if(bdsBdsCd.value == ""){
		alert("부동산 정보를 조회하여 주십시오.");
		
		return false;
	}
	
	if(dealKind.value == ""){
		alert("거래 구분을 선택하여 주십시오.");
		
		return false;
	}
	
	for(i = 0; i < rowCount; i++){
		materialTypeValue = GD_GetCellValueIndex(GridObj, i, materialTypeIndex);
		
		if(materialTypeValue != "04"){
			alert("시설공사/재산관리 품목만 처리가 가능합니다.");
			
			return false;
		}
	}
	
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
//-->
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">

<form name="form1" >
<%
	if(taxNoLength > 0){
		String       taxNoParameter        = null;
		String       taxSeqParameter       = null;
		StringBuffer taxNoParameterBuffer  = new StringBuffer();
		StringBuffer taxSeqParameterBuffer = new StringBuffer();
		int          i                     = 0;
		int          taxLastIndex          = taxNoLength - 1;
		
		for(i = 0; i < taxNoLength; i++){
			taxNoParameterBuffer.append(taxNo[i]);
			taxSeqParameterBuffer.append(taxSeq[i]);
			
			if(i != taxLastIndex){
				taxNoParameterBuffer.append(",");
				taxSeqParameterBuffer.append(",");
			}
		}
		
		taxNoParameter  = taxNoParameterBuffer.toString();
		taxSeqParameter = taxSeqParameterBuffer.toString();
%>
	<input type="hidden" id="taxNoParameter"  name="taxNoParameter"  value="<%=taxNoParameter%>">
	<input type="hidden" id="taxSeqParameter" name="taxSeqParameter" value="<%=taxSeqParameter%>">
<%
	}
%>
    <input type="hidden" name="pay_send_no"      id="pay_send_no"      value="<%=paySendNo%>">
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
	
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 시작--%>
	<input type="hidden" name="house_code" 		id="house_code" 	value="<%=info.getSession("HOUSE_CODE")%>">	
	<input type="hidden" name="dept_code" 		id="dept_code" 		value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" 	id="req_user_id" 	value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type" 		id="doc_type" 		value="PSB">
	<input type="hidden" name="fnc_name" 		id="fnc_name" 		value="getApproval">
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD 종료--%>
	
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
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;지급번호</td>
									<td class="data_td" width="30%"><%=paySendNo%></td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상태</td>
									<td class="data_td" width="30%">신규</td>
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
									<td class="data_td" width="30%"><%=SepoaString.dFormat((Object) sumDelyAmt) %> 원</td>
								</tr>
<%
	if(isSignedPage && isBeforeSignedPage){
%>
								<tr id="signerBeforeLineTr" style="display: none;">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr id="signerBeforeDataTr" style="display: none;">
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;1차 책임자</td>
									<td class="data_td" width="30%">
										<select id="signerBeforeSelect"></select>
									</td>
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;책임자</td>
									<td class="data_td" width="30%">
										<select id="signerSelect"></select>
									</td>
								</tr>
<%
	}
	else if(isSignedPage){
%>
								<tr id="signerLineTr" style="display: none;">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr id="signerDataTr" style="display: none;">
									<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;책임자</td>
									<td class="data_td" width="30%" colspan="3">
										<select id="signerSelect"></select>
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
									<td width="24%" class="data_td">
				 						<input type="radio" disabled name="rdo_work_kind" id="rdo_work_kind1" value="1" <%if(work_kind.equals("1")) {%>checked<%}%>>1.동산 신규
									</td>
									<td width="24%" class="data_td">
										<input type="radio" disabled name="rdo_work_kind" id="rdo_work_kind2" value="2" <%if(work_kind.equals("2")) {%>checked<%}%>>2.동산 원가
									</td>
									<td width="24%" class="data_td">
										<input type="radio" disabled name="rdo_work_kind" id="rdo_work_kind3" value="3" <%if(work_kind.equals("3")) {%>checked<%}%>>3.건물 자본적지출
									</td>
									<td width="24%" class="data_td">
										<input type="radio" disabled name="rdo_work_kind" id="rdo_work_kind4" value="4" <%if(work_kind.equals("4")) {%>checked<%}%>>4.임차점포시설물 자본적지출
									</td>
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
									<td class="data_td" width="15%"><%=bmsbmsyy%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소관부서</td>
									<td class="data_td" width="45%" colspan="3"><%=sogsogcd%></td>
									<td class="data_td" width="10%" rowspan="5" align="right">
										<div id="doSelectEps0019Div">
<%-- <script language="javascript">
btn("javascript:doSelectEps0019();","조 회");
</script> --%>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;자산구분</td>
									<td width="15%" class="data_td"><%=astastgb%></td>
									<td  width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;관리구분</td>
									<td width="15%" class="data_td" ><%=mngmngNo%></td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업구분</td>
									<td width="15%" class="data_td" ><%=bssbssno%></td> 
								</tr>
								<%-- <tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의일자</td>
									<td width="15%" class="data_td" >
										<s:calendar id="pumpumdt" default_value="<%=SepoaString.getDateSlashFormat( to_date ) %>" format="%Y/%m/%d" cssClass=" "/>
									</td>
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의금액</td>
									<td class="data_td" colspan="3">
										<input type="text" name="pumpumam" id="pumpumam" size="20" maxlength="15" value="" style="text-align: right;" readonly="readonly">
									</td>
								</tr> --%>
								<tr>
									<td colspan="7" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의번호</td>
									<td class="data_td"><%=appappyy%> / <%=bmssrlno%></td>
									<td  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의승인번호</td>
									<td class="data_td" ><%=appappno%></td>
									<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의승인금액</td>
									<td class="data_td" colspan="2"><%=SepoaString.dFormat((Object) appappam) %> 원</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br />
	<div id="divRealEstate" style="display:none">
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
									<td class="data_td" colspan="5" width="75%"><%=jumjum_cd%> / <%=jumjum_nm%>
										<input type="hidden" id="astast_cd" name="astast_cd" value="">
									</td>									
								</tr>
								<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
								<tr>
									<td  class="title_td"  width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고유번호</td>
									<td class="data_td" width="15%"><%=bdsbdscd%></td>
									<td  class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부동산명칭</td>
									<td class="data_td"   width="45%" colspan="3"><%=bdsbdsnm%></td>
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
	<div id="divDebt" style="display:">
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
										<td width="15%" class="data_td"><%=deal_area%> M<SUP>2</SUP>
										</td>
										<td width="15%" class="title_td" style="align:center">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;용도구분(존속기간)</td>
										<td width="15%" class="data_td"><%=use_kind%></td>
										<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;복구충당부채금액</td>
										<td width="20%" class="data_td"><%=deal_debt%></td>
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
	<p>실행</p>
	<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="data_td" width="80%" colspan="2">
											<input type="radio" disabled name="accountKind" id="accountKind1"  class="input_data2" value="1" <%if(accountkind.equals("1")) {%>checked<%}%>>계좌이체
											<input type="radio" disabled name="accountKind" id="accountKind2"  class="input_data2" value="2" <%if(accountkind.equals("2")) {%>checked<%}%>>계좌이체 안함
										</td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="data_td" width="10%">
											<div id="divDealKindText" style="display:none">거래구분</div>
										</td>
										<td width="70%" class="data_td"><%=deal_kind%>
										</td>
									</tr>   
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>	
</form>
<form name="frmEps0020">
	<input type="hidden" name="JUMJUMCD" id="JUMJUMCD" value="">
	<input type="hidden" name="JUMJUMNM" id="JUMJUMNM" value="">
	<input type="hidden" name="ASTASTCD" id="ASTASTCD" value="">
	<input type="hidden" name="USRUSRID" id="USRUSRID" value="">
</form>
<form name="frmOt8701">
	<input type="hidden" name="account_type"       id="account_type"               value="">
	<input type="hidden" name="buy_place"          id="buy_place"                  value="">
	<input type="hidden" name="dely_to_location"   id="dely_to_location"           value="">
	<input type="hidden" name="dosunqno"           id="dosunqno"                   value="">
	<input type="hidden" name="jumjumcd"           id="jumjumcd"                   value="">
	<input type="hidden" name="vendor_code"        id="vendor_code"                value="">
	<input type="hidden" name="vendor_name"        id="vendor_name"                value="">
	<input type="hidden" name="rdo_work_kind"      id="rdo_work_kind"              value="">
</form>                                      
</s:header>
<s:grid screen_id="TX_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<%-- TOBE 2017-07-01 구 activeX 미사용 주석처리  
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
--%>
</body>
</html>