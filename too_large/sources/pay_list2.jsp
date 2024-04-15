<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String  screen_id      = "TX_014";
	String  grid_obj       = "GridObj";
	String  G_IMG_ICON     = "/images/ico_zoom.gif";
    String  HOUSE_CODE     = info.getSession("HOUSE_CODE");
    String  COMPANY_CODE   = info.getSession("COMPANY_CODE");
    boolean isSelectScreen = false;

        
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_pay_list2"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script type="text/javascript">
//<!--
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_list2";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;
var mode = "";

function init(){
	setGridDraw();
    doSelect();
}

function doSelect(){
	document.forms[0].inv_start_date.value = del_Slash( document.forms[0].inv_start_date.value );
	document.forms[0].inv_end_date.value   = del_Slash( document.forms[0].inv_end_date.value   );
	
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getPayList";
    
    params += "&grid_col_id=" + cols_ids;
    params += dataOutput();
    
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);    
}


function getVendorCode(setMethod) {
	window.open("/common/CO_014.jsp?callback=" + setMethod, "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}

function setVendorCode( code, desc1, desc2 , desc3) {
	$("#vendor_code").val(code);
	$("#vendor_code_name").val(desc1);
}

function doGive(){
	alert("지급 : 준비중");
}

function doCreateDoc(){
	var chkCnt = 0 ;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			chkCnt++;
		}
	}
	
	if(chkCnt == 0){
		alert("지급문서를 생성할 대상을 선택해 주세요.");
		return;
	}
	
	var params = "";
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++ ){
		if(GridObj.GetCellValue("SELECTED", i) == "1"){
			
			if(i==0){
				params += "tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i);		
			}else{
				params += "&tax_no="+GridObj.GetCellValue("TAX_NO", i)+"&tax_seq="+GridObj.GetCellValue("TAX_SEQ", i)+"&vendor_code="+GridObj.GetCellValue("VENDOR_CODE", i);
			}
		}
	}
	
	var url = "pay_bd_ins2_pop.jsp?" + params;
	
	window.open(url, "payPop", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=1024,height=550,left=0,top=0");
}

function doModify(){
	alert("계정과목수정 : 준비중");
}

function doExcelDown(){
	alert("엑셀다운로드 : 양식준비중");
}

function doManPayEnd(){
	var isChecked 	= false;
	var chkCnt		= 0;
	var rowId;
	
	for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
		if($.trim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue()) == "1"){
			rowId		= GridObj.getRowId(i);
			isChecked 	= true;
			chkCnt++;
		}
	}
	
	if(!isChecked){
		alert("완료 처리할 데이터를 선택해 주세요.");
		return;
	}
	
	if(!confirm("완료처리를 진행 하시겠습니까?"))return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	
	params = "?mode=setManPayEnd";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
	
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
}

function SP9113_Popup() {
	window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function  SP9113_getCode(id, name) {
	form1.purchase_id.value		= id;
	form1.purchase_name.value   = name;
}
//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var header_name = GridObj.getColumnId(cellInd);
	
	if( header_name == "VENDOR_NAME" ) {
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		var url         = '/s_kr/admin/info/ven_bd_con.jsp';
		var title       = '업체상세조회';
		var param       = 'popup=Y';
		
		param     += '&mode=irs_no';
		param     += '&vendor_code=' + vendor_code;
		
		popUpOpen01(url, title, '900', '700', param);
	}
	
	if( header_name == "ITEM_NO" ) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
		
	}
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {}
    else if(stage==2) {
        return true;
    }
    
    return false;
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
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    document.forms[0].inv_start_date.value = add_Slash( document.forms[0].inv_start_date.value );
    document.forms[0].inv_end_date.value   = add_Slash( document.forms[0].inv_end_date.value   );
    
    return true;
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
    if(msg1 == "doData") {
    	doSelect();
    }
}

//지우기
function doRemove( type ){
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_code_name.value = "";
    }
    if( type == "purchase_id" ) {
    	document.forms[0].purchase_id.value = "";
        document.forms[0].purchase_name.value = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

	<%-- ClipReport4 리포터 호출 스크립트 --%>
	function clipPrint(rptAprvData,approvalCnt) {
		var sRptData = "";
		var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
		var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
		var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
		
		sRptData += document.form1.inv_start_date.value;	//세금계산서 발행일자 from
		sRptData += " ~ ";
		sRptData += document.form1.inv_end_date.value;	//세금계산서 발행일자 to
		sRptData += rf;
		sRptData += document.form1.vendor_code.value;	//공급업체1
		sRptData += rf;
		sRptData += document.form1.vendor_code_name.value;	//공급업체2
		sRptData += rf;
		sRptData += document.form1.tax_no.value;	//세금계산서번호
		sRptData += rf;
		sRptData += document.form1.purchase_id.value;	//구매담당자1
		sRptData += rf;
		sRptData += document.form1.purchase_name.value;	//구매담당자2
		sRptData += rf;
		sRptData += document.form1.PROGRESS_CODE.options[document.form1.PROGRESS_CODE.selectedIndex].text;	//상태
		sRptData += rd;
				
		for(var i = 0; i < GridObj.GetRowCount(); i++){	
			sRptData += GridObj.GetCellValue("PROGRESS_CODE",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("TAX_NO",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("DELY_TO_LOCATION",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("DELY_TO_LOCATION_NM",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("ITEM_NO",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("ITEM_NM",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("AMT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("VAT_AMT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("TOT_AMT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("VENDOR_NAME",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("SUBJECT",i);
			sRptData += rf;		
			sRptData += GridObj.GetCellValue("PURCHASE_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("PR_USER_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("RD_DATE",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("LG_ATT_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("MD_ATT_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("SM_ATT_NAME",i);
			sRptData += rf;
			sRptData += GridObj.GetCellValue("ATTRIBUTE_NAME",i);	
			sRptData += rl;				
		}	

		document.form1.rptData.value = sRptData;
		
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
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header>
	<form id="form1" name="form1" action="">
	<%--ClipReport4 hidden 태그 시작--%>
	<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
	<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
	<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
	<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
	<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
	<input type="hidden" name="rptAprv" id="rptAprv">		
	<%--ClipReport4 hidden 태그 끝--%>	
  		<%@ include file="/include/sepoa_milestone.jsp"%>
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
        								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서 발행일자</td>
            							<td class="data_td">
            								<s:calendar id="inv_start_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateDay(SepoaDate.getShortDateString(),-7))%>" format="%Y/%m/%d" cssClass=" "/>
                							~
                							<s:calendar id="inv_end_date" default_value="<%=SepoaString.getDateSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d" cssClass=" "/>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
										<td class="data_td">
											<input type="text" name="vendor_code" id="vendor_code" style="ime-mode:inactive"  size="12" class="inputsubmit" maxlength="10" readonly="readonly" onkeydown='entKeyDown()'>
											<a href="javascript:getVendorCode('setVendorCode')">
												<img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="vendor_code_name" id="vendor_code_name" size="20"  onkeydown='entKeyDown()'>			
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세금계산서번호</td>
										<td width="35%" class="data_td">
            								<input type="text" id="tax_no" name="tax_no" style="ime-mode:inactive" size="10" value=''  onkeydown='entKeyDown()'>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
										<td class="data_td" width="35%" colspan="3">
											<input type="text" name="purchase_id" id="purchase_id" style="ime-mode:inactive"  value="<%=info.getSession("ID")%>" size="15" class="inputsubmit" onkeydown='entKeyDown()'>
											<a href="javascript:SP9113_Popup();">
												<img src="/images/ico_zoom.gif" align="absmiddle" border="0">
											</a>
											<a href="javascript:doRemove('purchase_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
											<input type="text" name="purchase_name" id="purchase_name" size="20" value="<%=info.getSession("NAME_LOC")%>" readOnly  onkeydown='entKeyDown()'>
										</td>
									</tr> 
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;상태</td>
										<td width="35%" class="data_td" COLSPAN=3>
            								<SELECT style=width:150  ID="PROGRESS_CODE" NAME="PROGRESS_CODE">
			            						<option value="">전체</option>
												<option value="E">완료</option>
												<option value="P" SELECTED>미완료</option>
            								</SELECT>
										</td>										
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
            		<TABLE cellpadding="0">
                		<TR>
                        	<TD>
<script language="javascript">
btn("javascript:doSelect();"	,"조 회");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:clipPrint()","출 력")
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:doManPayEnd();"	,"완료처리");
</script>
							</TD>
                		
                									
<%-- 
							<TD>
<script language="javascript">
btn("javascript:doExcelDown();"	,"엑셀다운로드");
</script>
							</TD>
							<TD>
<script language="javascript">
btn("javascript:doCreateDoc()","지급결의생성");
</script>
							</TD> 
							<TD>
<script language="javascript">
btn("javascript:doModify()"	,"계정과목수정");
</script>
							</TD>
--%>
						</TR>
                	</TABLE>
            	</td>
        	</tr>
    	</table>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="TX_014" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</body>
</html>