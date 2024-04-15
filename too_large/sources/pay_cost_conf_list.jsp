<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("TX_019");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "TX_019";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON = "/images/ico_zoom.gif";

%>

<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
   
    //String LB_PAY_TARGET 		= ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M400", ""); //지급대상
    
    //////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_pay_cost_conf_list"; //리포트명
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
var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_audit_list";

var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;

var mode = "";

function init()
{
	setGridDraw();
    doSelect();
}

function doSelect()
{
	
	document.forms[0].act_from_date.value = del_Slash( document.forms[0].act_from_date.value );
	document.forms[0].act_to_date.value   = del_Slash( document.forms[0].act_to_date.value   );
	
    mode = "getPayCostList";
    
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=" + mode;
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

function fncDeCode(param){
    var sb  = '';
    var pos = 0;
    var flg = true;

    if(param != null){
        if(param.length>1){
            while(flg){
                var sLen = param.substring(pos,++pos);
                var nLen = 0;

                try{
                    nLen = parseInt(sLen);
                }
                catch(e){
                    nLen = 0;
                }

                var code = '';

                if((pos+nLen)>param.length){
                	code = param.substring(pos);
                }
                else{
                	code = param.substring(pos,(pos+nLen));
                }

                pos  += nLen;
                sb += String.fromCharCode(code);

                if(pos >= param.length){
                	flg = false;
                }
            }
        }
    }

    return sb;
}

function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	
	if(part == "PURCHASER_ID"){
		window.open("/common/CO_008.jsp?callback=getPurUser&userId="+$("#purchaser_id").val()+"&userName="+$("#purchaser_name").val(), "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
	
	if(part == "DEMAND_DEPT"){
		window.open("/common/CO_009.jsp?callback=getDemand", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}	
}

function getPurUser(code, text){
	document.form1.purchaser_name.value = text;
	document.form1.purchaser_id.value = code;
}

function getDemand(code, text){
	document.form1.demand_dept_name.value = text;
	document.form1.demand_dept.value = code;
}

//지우기
function doRemove( type ){
	if( type == "demand_dept" ) {
  		document.form1.demand_dept.value = "";
      	document.form1.demand_dept_name.value = "";
  	}  
  	if( type == "purchaser_id" ) {
	  	document.form1.purchaser_id.value = "";
      	document.form1.purchaser_name.value = "";
  	}
	if( type == "vendor_code" ) {
		document.forms[0].vendor_code.value = "";
		document.forms[0].vendor_code_name.value = "";
  	}  
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
	var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(rowId);
	
	if( GridObj.getColIndexById("TAX_NO") == cellInd ){
		if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
	  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
	  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
	  		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&status=" + status + "&gubun=P";			
		}else{
			var pubCode = GridObj.cells(rowId, GridObj.GetColHDIndex("PUBCODE")).getValue();
			
			var iMyHeight;
			width = (window.screen.width-635)/2
			if(width<0)width=0;
			iMyWidth = width;
			height = 0;
			if(height<0)height=0;
			iMyHeight = height;
			var taxInvoice = window.open("about:blank", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
			document.taxListForm.action="<%=CommonUtil.getConfig("sepoa.trus.server")%>/jsp/directTax/TaxViewIndex.jsp";
			document.taxListForm.method="post";
			document.taxListForm.pubCode.value=pubCode;
			document.taxListForm.docType.value= "T"; //세금계산서
			document.taxListForm.userType.value="S"; // S=보내는쪽 처리화면, R= 받는쪽 처리화면
			document.taxListForm.target="taxInvoice";
			document.taxListForm.submit();		
		}
	}
	else if(GridObj.getColIndexById("INV_NO") == cellInd) {
		var url = "/procure/invoice_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+SepoaGridGetCellValueId(GridObj, rowId, "PO_NO");
		param += "&inv_no="+SepoaGridGetCellValueId(GridObj, rowId, "INV_NO");
		PopupGeneral(url+param, "IvDetailPop", "", "", "1000", "600");
	}
	else if(GridObj.getColIndexById("VENDOR_NAME") == cellInd) {
		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
	    var url    = '/s_kr/admin/info/ven_bd_con.jsp';
	    var title  = "업체상세조회";
	    var param  = 'popup=Y';
	    param     += '&mode=irs_no';
	    param     += '&vendor_code=' + vendor_code;
	    popUpOpen01(url, title, '900', '700', param);
	    
	}
	else if(cellInd == GridObj.getColIndexById("PR_NO")) {
		var prNo = GD_GetCellValueIndex(GridObj, rowIndex, GridObj.getColIndexById("PR_NO"));
		var page = "/kr/dt/pr/pr1_bd_dis1I.jsp";
		
		window.open(page + '?pr_no=' + prNo ,"windowopen1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=650,left=0,top=0");
	}
	else if(cellInd == GridObj.getColIndexById("ITEM_NO")) {//품목상세
		
		var itemNo	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO") ).getValue()); 

		var url    = '/kr/master/new_material/real_pp_lis1.jsp';
		var title  = '품목상세조회';        
		var param  = 'ITEM_NO=' + itemNo;
		param     += '&BUY=';
		popUpOpen01(url, title, '750', '550', param);
	}
	else if( cellInd == GridObj.getColIndexById("CONT_NO")) {
		var	cont_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_NO")).getValue());	
		var	cont_gl_seq  = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_GL_SEQ")).getValue());
		
		if(cont_no != '') {
			var strParm = "cont_no=" + cont_no + "&cont_gl_seq=" + cont_gl_seq + "&cont_form_no=" + cont_no;
		 	popUpOpen("/contract/contract_detail_print.jsp?"+strParm, 'CONT_NO_DETAIL', '1080', '700');
		}
	}
	else if( cellInd == GridObj.getColIndexById("GW_STATUS") || cellInd == GridObj.getColIndexById("GW_INF_NO") ) {
		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS");
		var gwInfNoColIndex = GridObj.getColIndexById("GW_INF_NO");
		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
		var gwInfNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwInfNoColIndex);
		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
		var x                = 900;
		var y                = window.screen.height - 90;
		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
		
		if( gwInfNoColValue != null && gwInfNoColValue != "" && "O" == gwStatusColValue ){
			$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
				{
					mode  : "gwPop",
					prNo  : prNoValue,
					prSeq : prSeqValue,
					type  : "P"
				},
				function(arg){
					var result     = eval('(' + arg + ')');
					var resultCode = result.code;
					var gwPopUrl   = null;
					
					if(resultCode == "200"){
						gwPopUrl = result.gwPopUrl;
						gwPopUrl = fncDeCode(gwPopUrl);
						
						window.open(gwPopUrl, "gwPop", status);
					}
					else{
						alert(result.message);
					}
				}
			);
		}		
	}
	else if( cellInd == GridObj.getColIndexById("GW_STATUS2") || cellInd == GridObj.getColIndexById("GW_INF_NO2") ) {
		var gwStatusColIndex = GridObj.getColIndexById("GW_STATUS2");
		var gwInfNoColIndex = GridObj.getColIndexById("GW_INF_NO2");
		var prNoColIndex     = GridObj.getColIndexById("PR_NO");
		var prSeqColIndex    = GridObj.getColIndexById("PR_SEQ");
		var gwStatusColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwStatusColIndex);
		var gwInfNoColValue = GD_GetCellValueIndex(GridObj, rowIndex, gwInfNoColIndex);
		var prNoValue        = GD_GetCellValueIndex(GridObj, rowIndex, prNoColIndex);
		var prSeqValue       = GD_GetCellValueIndex(GridObj, rowIndex, prSeqColIndex);
		var x                = 900;
		var y                = window.screen.height - 90;
		var status           = "toolbar=no, directories=no, scrollbars=no, resizable=no, status=no, memubar=no, width=" + x + ", height=" + y + ", top=0, left=20";
		
		if( gwInfNoColValue != null && gwInfNoColValue != "" && "O" == gwStatusColValue){
			$.post(
				"<%=POASRM_CONTEXT_NAME%>/servlets/dt.app.app_bd_lis1",
				{
					mode  : "gwPop",
					prNo  : prNoValue,
					prSeq : prSeqValue,
					type  : "G"
				},
				function(arg){
					var result     = eval('(' + arg + ')');
					var resultCode = result.code;
					var gwPopUrl   = null;
					
					if(resultCode == "200"){
						gwPopUrl = result.gwPopUrl;
						gwPopUrl = fncDeCode(gwPopUrl);
						
						window.open(gwPopUrl, "gwPop", status);
					}
					else{
						alert(result.message);
					}
				}
			);
		}
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
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

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{
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
    if(status == "0") alert(msg);
    
    document.forms[0].act_from_date.value = add_Slash( document.forms[0].act_from_date.value );
    document.forms[0].act_to_date.value   = add_Slash( document.forms[0].act_to_date.value   );

    return true;
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
	
	sRptData += document.form1.act_from_date.value;	//결의일자 from
	sRptData += " ~ ";
	sRptData += document.form1.act_to_date.value;	//결의일자 to
	sRptData += rf;
	sRptData += document.form1.vendor_code.value;	//공급업체1
	sRptData += rf;
	sRptData += document.form1.vendor_code_name.value;	//공급업체2
	sRptData += rf;
	sRptData += document.form1.purchaser_id.value;	//구매담당자1
	sRptData += rf;
	sRptData += document.form1.purchaser_name.value;	//구매담당자2
	sRptData += rf;
	sRptData += document.form1.demand_dept.value;	//결의부서1
	sRptData += rf;
	sRptData += document.form1.demand_dept_name.value;	//결의부서2
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){	
		sRptData += GridObj.GetCellValue("PAY_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("PAY_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BANK_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("BANK_ACCT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("EXCD",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("TAX_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("PR_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("GW_INF_NO_H",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("GW_INF_NO2_H",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CONT_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("INV_NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("DEPT_NAME_LOC",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("PURCHASER_NAME",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("COST_USER_ID",i);
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
<!--내용시작-->
<form id="form1" name="form1" action="">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>	
<input type="hidden" id="audit_status" name="audit_status" value="E">
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
        						<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결의일자</td>
            					<td class="data_td">
            						<s:calendar id="act_from_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) )%>" format="%Y/%m/%d" cssClass=" "/>
                					~
                					<s:calendar id="act_to_date" default_value="<%=SepoaString.getDateSlashFormat( SepoaDate.getShortDateString() )%>" format="%Y/%m/%d" cssClass=" "/>
								</td>
								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공급업체</td>
								<td class="data_td">
									<input type="text" name="vendor_code" id="vendor_code" size="20" class="inputsubmit" maxlength="10" style="ime-mode:inactive" onkeydown='entKeyDown()'>
									<a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
									<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text" name="vendor_code_name" id="vendor_code_name" size="20"  onkeydown='entKeyDown()'>			
								</td>
							</tr>
							<tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
							<tr>
								<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매담당자</td>
								<td class="data_td">
									<input type="text" name="purchaser_id" id="purchaser_id" size="20" value="" onkeydown="JavaScript: entKeyDown();" style="ime-mode:disabled;" maxlength="10">
									<a href="javascript:PopupManager('PURCHASER_ID')">
										<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0">
									</a>
									<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text" name="purchaser_name" id="purchaser_name" size="20" value=""  onkeydown="JavaScript: entKeyDown();" >
								</td>	
								<td width="15%" class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;결의부서</td>
								<td class="data_td">
									<input type="text" name="demand_dept" style="ime-mode:inactive"  id="demand_dept" size="20" maxlength="6" value='' onkeydown="JavaScript: entKeyDown();">
									<a href="javascript:PopupManager('DEMAND_DEPT');">
										<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
									</a>
									<a href="javascript:doRemove('demand_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									<input type="text" name="demand_dept_name" id="demand_dept_name" size="20" onkeydown="JavaScript: entKeyDown();" readonly value=''>
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
                	<TD><script language="javascript">btn("javascript:doSelect()"	,"조 회")    	</script></TD>
                	<TD><script language="javascript">btn("javascript:clipPrint()"	,"출 력")		</script></TD>
				</TR>
			</TABLE>
		</td>
	</tr>
</table>
</form>

<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
</form>

<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</s:header>
<s:grid screen_id="TX_019" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>
</body>
</html>