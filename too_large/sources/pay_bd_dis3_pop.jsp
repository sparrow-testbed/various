<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
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
	String       	LB_DEAL_KIND    = ListBox(request, "SL0014", house_code + "#M803", ""); //거래구분
	String       	LB_USE_KIND     = ListBox(request, "SL0014", house_code + "#M804", ""); //용도구분(존속기간)복구충당부채사용기간
	String       	LB_BUDGET_DEPT  = ListBox(request, "SL0014", house_code + "#M805", ""); //소관부서
	String       	LB_PAY_KIND_BUD = ListBox(request, "SL0018", house_code + "#M800", "");
	String     	 	doc_no          = JSPUtil.nullToRef(request.getParameter("doc_no")	, "");
	String     	 	viewType        = JSPUtil.nullToRef(request.getParameter("viewType")	, "");
	String     	 	statusCd        = JSPUtil.nullToRef(request.getParameter("status_cd")	, "");
	StringBuffer 	stringBuffer    = new StringBuffer();
	
	String			VENDOR_NAME_LOC = "";
	String			IRS_NO 			= "";
	String			TOT_AMT			= "";
	String			SUP_AMT			= "";
	String			VAT_AMT 		= "";
	String			BANK_ACCT		= "";
	String          BANK_CODE       = "";
	String          DEPOSITOR_NAME  = "";
	
	
	
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
	
	} catch (Exception e) {
		//e.printStackTrace();
		isSelectScreen  = false;
	}
	
	
	
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_pay_bd_dis3_pop"; //리포트명
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
		_rptData.append(wf.getValue("ZIPHANGNM", 0));
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
		
	function Init() {	//화면 초기설정 
		setGridDraw();
		doSelect2();
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
        else if(mode == "ot8602"){
        	rtn = message.innerHTML.substring(0,7);
        	$('#pydtm_apv_no').val(rtn);
        	alert(messsage);
        }else if(mode == "ot8603"){
        	rtn = message.innerHTML.substring(0,5);
        	$('#slip_no').val(rtn);
        	alert(messsage);
	        opener.doSelect();
	    	window.close();
        }else{
        	rtn = message.innerHTML;
        	alert("Exception:"+rtn);
        }
    } else {
        alert(messsage);
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
function doSaveOT8602(){

	var pydtm_apv_no = $('#pydtm_apv_no').val();
	
	if(LRTrim(pydtm_apv_no).length > 0){
		alert("경비지급결의가 이미 완료되었습니다.");
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setOT8602";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(servletUrl+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
	
} 

//경비집행(전표번호)
function doSaveOT8603(){
	
	var pydtm_apv_no = $('#pydtm_apv_no').val();
	var slip_no = $('#slip_no').val();
	
	if(LRTrim(pydtm_apv_no).length == 0){
		alert("경비집행 전에 경비지급결의를 먼저 처리하셔야 합니다.");
		return;
	}
	if(LRTrim(slip_no).length > 0){
		alert("이미 경비집행이 완료되었습니다.");
		return;
	}
	
	var grid_array = getGridChangedRows(GridObj, "SEL");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setOT8603";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor(servletUrl+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SEL",grid_array);
	
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
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >
<s:header popup="true">

<%
	if("D".equals(viewType)){
%>
	<table>
		<tr>
			<td height="20" align="left" class="title_page" vAlign="bottom">
				경상비지급 상세
			</td>
		</tr>
	</table>
<%		
	}
%>

<form id="form1" name="form1" >
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="N">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>		
	<input type="hidden" id="tax_no" name="tax_no" value="<%=wf.getValue("TAX_NO"	, 0) %>" />
	<input type="hidden" id="pay_act_no" name="pay_act_no" value="<%=doc_no%>" />
	<input type="hidden" id="msg_dscd" name="msg_dscd" value="020" />
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
									<td class="data_td" width="20%" colspan="3"><%=wf.getValue("IRS_NO"   , 0)%>
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
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대체은행</td>
									<td class="data_td" width="20%">
										<select id="bank_code" name="bank_code" disabled="disabled">
											<option value="">선택</option>
											<%
												String comstr = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M349", wf.getValue("BANK_CODE"     , 0));
												out.print(comstr);
											%>
										</select> 
									</td>
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대체은행계좌번호</td>
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
									<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;전표번호</td>
									<td width="20%" class="data_td"><input type="text" name="slip_no" id="slip_no" value="<%=wf.getValue("SLIP_NO"		, 0) %>" readonly /></td>
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

</form>
</s:header>
<s:grid screen_id="TX_003" grid_obj="GridObj" grid_box="gridbox" height="200" />
<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>