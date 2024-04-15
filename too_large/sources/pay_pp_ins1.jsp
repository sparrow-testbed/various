<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_008");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_008";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	
    request.setCharacterEncoding("utf-8");
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
	String COMPANY_CODE = info.getSession("COMPANY_CODE");

	String pr_type	 	= JSPUtil.nullToRef(request.getParameter("PR_TYPE"), "");
	String req_type 	= JSPUtil.nullToRef(request.getParameter("REQ_TYPE"), "");
	String create_type 	= JSPUtil.nullToRef(request.getParameter("CREATE_TYPE"), "");
	String shipper_type	= JSPUtil.nullToRef(request.getParameter("SHIPPER_TYPE"), "");
	String pr_name		= JSPUtil.nullToRef(request.getParameter("PR_NAME"), "");

	String PR_DATA     	= JSPUtil.nullToRef(request.getParameter("PR_DATA"), "");

	String re_pr_type  = pr_type;
	String SETTLE_TYPE = "DOC";

	if (pr_type.equals("S")) SETTLE_TYPE = "ITEM";
	if (pr_type.equals("S") && req_type.equals("P")) re_pr_type = "SS";

	String Subject = "";

    String LB_I_PAY_TERMS 	= ListBox(request, "SL0127", HOUSE_CODE+"#M010#"+shipper_type+"#", "");
	String LB_I_DELY_TERMS	= ListBox(request, "SL0018", HOUSE_CODE+"#M009", "");
	
	String PC_FLAG="";
	String pc_reason = "";
	
 	String WISEHUB_PROCESS_ID="TX_008";
 	
	/**
	 * 전자결재 사용여부
	 */
	Config signConf = new Configuration();
	String sign_use_module = "";// 전자결재 사용모듈
	String pc_reasonDisable = "";
	boolean sign_use_yn = false;
	try {
		sign_use_module = signConf.get("wise.sign.use.module." + info.getSession("HOUSE_CODE")); //전자결재 사용모듈
	} catch(Exception e) {
		
		//out.println("에러 발생:" + e.getMessage() + "<br>");
		
		sign_use_module	= "";
	}
	StringTokenizer st = new StringTokenizer(sign_use_module, ";");
	while (st.hasMoreTokens()) {
		if ("RFQ".equals(st.nextToken())) {
			sign_use_yn = true;
		}
	}
	
	
	if(!PC_FLAG.equals("Y")){
		pc_reasonDisable = "disable";
	}

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">

var mode									;
var explanation_modify_flag = "false"		;
var bid_Infor_modify_flag = "false"			;
var Current_Row								;
var poprow									;
var pc_reason                               ;
var pc_flag									;

var INDEX_SELECTED                 			;



	function Init() {	//화면 초기설정 
		setGridDraw();
		setHeader();
		//doSelect();
		
		//단말기 정보 조회
		GetBrowserInfo('form1');
	}
	
	function setHeader() {	
		var f0 = document.forms[0];
		
	INDEX_SELECTED                 	= GridObj.GetColHDIndex("SELECTED"			);

    }

	function doOnRowSelected(rowId,cellInd)
	{
		
	}
	
function doSelect() {
	var cols_ids = "<%=grid_col_id%>";
	var params   = "mode=getAccTransList";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post( "/servlets/dt.rfq.rfq_bd_ins1", params );
	
	GridObj.clearAll(false);
}


function checkData() {
	rowcount = GridObj.GetRowCount();
	checked_count = 0;
	
	return true;
}

//전송(P),저장(N)
function doSave(rfq_flag) {

}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery"){
		
		//전체 선택
		selectAll();
		
	}
	
	if(msg1 == "t_imagetext") {
		
		
	}
	else if(msg1 == "doData") { // 전송/저장시 Row삭제
		opener.doSelect();
		window.close();
		
		/*
		if("1" == GridObj.GetStatus()) {
			for(row=GridObj.GetRowCount()-1; row>=0; row--) {
				if( "true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
					GridObj.DeleteRow(row);
				}
			}
			
			opener.doSelect();
			window.close();
		}
		*/
	}
	else if(msg1 == "t_insert") { //
		if(msg3 == INDEX_RD_DATE) {
			se_rd_date  = GD_GetCellValueIndex(GridObj,msg2, INDEX_RD_DATE);
			
			var  rfq_close_date_val = form1.rfq_close_date.value;
			
			if(rfq_close_date_val == "") {
				alert("견적마감일을 먼저 입력하세요");
				
				return;
			}
			
			if(!checkDateCommon(form1.rfq_close_date.value)){
				document.forms[0].rfq_close_date.select();
				
				alert("견적마감일을 확인하세요.");
				
				return;
			}

			if(se_rd_date <= rfq_close_date_val ) {
				alert("납기요청일은 견적마감일 이후여야 합니다."  );
				
				GD_SetCellValueIndex(GridObj,msg2, INDEX_RD_DATE, msg4);
			}
		}
	
		if(msg3 == INDEX_PURCHASE_PRE_PRICE || msg3 == INDEX_RFQ_QTY) {
			for(var x=0; x<GridObj.GetRowCount(); x++) {
				var tmp_amt = GD_GetCellValueIndex(GridObj,x, INDEX_PURCHASE_PRE_PRICE);
				var tmp_qty = GD_GetCellValueIndex(GridObj,x, INDEX_RFQ_QTY);

				if(isNull(tmp_amt)){
					tmp_amt = 0;
				}
				
				if(isNull(tmp_qty)){
					tmp_qty = 0;
				}
                    
				GD_SetCellValueIndex(GridObj,x, INDEX_RFQ_AMT, setAmt( (eval(tmp_amt) * eval(tmp_qty)) + '' ));
			}
		}
	}
	else if(msg1 == "t_header") {
		if(msg3 == INDEX_RD_DATE) {
			copyCell(GridObj, INDEX_RD_DATE, "t_date");
		}
	}
}




var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}



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
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}

 var selectAllFlag = 0;
	<%
	/**
	 * @메소드명 : selectAll()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 전체선택 > 전체선택되어 있는 경우 클릭하면 전체선택 해제
	 */
	%>
 function selectAll(){
		if(selectAllFlag == 0)
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("1"); 
			}
			selectAllFlag = 1;
		}
		else
		{
			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
			{
				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			}
		}
	}
 
 /*단말정보요청함수  */
    function GetBrowserInfo(form){	
		
	  ret = WooriDeviceForOcx.OpenDevice();
		if( ret == 0 ){
			ret = WooriDeviceForOcx.GetTerminalInfo(30);
			if( ret == 0 ){
				msg = WooriDeviceForOcx.GetResult();
				//form.txtBrowserInfo.value = msg;
				var arr = msg.split('');
				if(arr.length > 0 && arr[0].length==10){
					$('#bk_cd').val(arr[0].substr(0,5));
					$('#br_cd').val(arr[0].substr(5,1));
					$('#trm_bno').val(arr[0].substr(6,3));
					$('#user_trm_no').val(arr[0].substr(9,1));
					$('#txtBrowserInfo').val(arr[0]);
				}else{
					alert("Device정보가 올바르지 않습니다.");
				}
			}else{
				msg = WooriDeviceForOcx.GetErrorMsg(ret);
				alert(msg);
			}
			WooriDeviceForOcx.CloseDevice();
		}else{
			msg = WooriDeviceForOcx.GetErrorMsg(ret);
			alert(msg);
		} 

		/* var msg = "20644C003120644";
		var arr = msg.split('');
		if(arr.length > 0 && arr[0].length==10){
			//alert(arr[0].substr(0,5)+"|"+arr[0].substr(5,1)+"|"+arr[0].substr(6,3)+"|"+arr[0].substr(9,1));
			$('#bk_cd').val(arr[0].substr(0,5));
			$('#br_cd').val(arr[0].substr(5,1));
			$('#trm_bno').val(arr[0].substr(6,3));
			$('#user_trm_no').val(arr[0].substr(9,1));
			$('#txtBrowserInfo').val(arr[0]);
			
		}
		 */
    }
 /*단말정보요청함수  */
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0">
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">견적요청생성</td>
		</tr>
	</table>
	<table width="98%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="760" height="2" bgcolor="#0072bc"></td>
		</tr>
	</table>
	<form name="form1" id="form1" action="">

	
		<input type="text" name="bk_cd"             id="bk_cd"              value="">
		<input type="text" name="br_cd"             id="br_cd"              value="">
		<input type="text" name="trm_bno"           id="trm_bno"            value="">
		<input type="text" name="user_trm_no"       id="user_trm_no"        value="">
		<input type="text" name="txtBrowserInfo"    id="txtBrowserInfo"     value="">
		<input type="hidden" name=""                  id=""                   value="">
		<input type="hidden" name=""                  id=""                   value=""/>
		
		<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
			<tr>
				<td width="15%" class="se_cell_title">실행내역</td>
				<td width="85%"  class="c_data_1" colspan="3"><input type="radio" name="rdo_work_kind" id="rdo_work_kind1"  class="input_data2" value="1" readonly> 
							계좌이체
							<input type="radio" name="rdo_work_kind" id="rdo_work_kind2"  class="input_data2" value="2" readonly> 
							계좌이체 안함
				</td>
			</tr>
			<tr>
				<td width="15%" class="se_cell_title">공급업체</td>
				<td width="85%" class="c_data_1" colspan="3">
					<input type="text" id="vendor_code" name="vendor_code" size="10" maxlength="10" class="inputsubmit">
					<input type="text" id="vendor_name" name="vendor_name" size="30" class="input_data2">
				</td>
			</tr>
		</table>
	</form>
	<table width="98%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="30" align="right">
				<TABLE cellpadding="0">
					<TR>
						<TD>
							<script language="javascript">
							btn("javascript:fnEpsResult();","계좌유효성체크");
							btn("javascript:fnTcpResult();","이체실행");
							</script>
						</TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
	<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</s:header>
<s:grid screen_id="TX_008" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<OBJECT ID=WooriDeviceForOcx WIDTH=1 HEIGHT=1 CLASSID="CLSID:AEB14039-7D0A-4ADD-AD93-45F0E4439871" codebase="/WooriDeviceForOcx.cab#version=1.0.0.5">
</OBJECT>
</body>
</html>