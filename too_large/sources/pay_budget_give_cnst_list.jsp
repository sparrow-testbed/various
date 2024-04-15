<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("ST_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "ST_012";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
	String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	
	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	

%>
<% //PROCESS ID 선언%>
<% String WISEHUB_PROCESS_ID="ST_012";%>

<% //사용 언어 설정%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%

//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
String _rptName          = "020644/rpt_pay_budget_give_cnst_list"; //리포트명
StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

%>

<html>
<head>
    <title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/include/include_css.jsp"%>
	<%@ include file="/include/sepoa_grid_common.jsp"%>
	<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
	<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
	<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>    
    <%
    String house_code       = info.getSession("HOUSE_CODE");
    String user_id		    = info.getSession("ID");
    String ctrl_code		= info.getSession("CTRL_CODE");
    //String gubun        	= request.getParameter("gubun") == null || request.getParameter("gubun").equals("") ? "D" : request.getParameter("gubun");
//     String bidType         = ListBox(request, "SL0018",  house_code+"#M410#", "");
    String bidType  = ListBox(request, "SL0018",  info.getSession("HOUSE_CODE")+"#M410#", "");
    
    %>
    
<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
    var mode;
    
    var INDEX_SELECTED                ;
    var INDEX_PAY_SEND_NO             ;
    var INDEX_PO_SUBJECT              ;
    var INDEX_PO_NO                   ;
    var INDEX_VENDOR_NAME             ;
    var INDEX_VENDOR_CODE             ;
    var INDEX_JUMJUJMNM               ;
    var INDEX_JUMJUJMCD               ;
    var INDEX_PAY_AMT                 ;
    var INDEX_SIGNER_NM               ;
    var INDEX_SIGNER_ID                 ;
    var INDEX_CHANGE_DATE             ;
    var INDEX_PMKPMKNM              ;  
    var INDEX_TAX_NO              ;
    var INDEX_TAX_DATE              ;
    var INDEX_PUBCODE              ;
    var INDEX_TAX_GUBUN              ;
    
    
    
    function init() {
		setGridDraw();
		setHeader();
       // doSelect();
    }

    function setHeader() {

		GridObj.bHDMoving 			= false;
		GridObj.bHDSwapping 		= false;
		GridObj.bRowSelectorVisible = false;
		GridObj.strRowBorderStyle 	= "none";
		GridObj.nRowSpacing 		= 0 ;
		GridObj.strHDClickAction 	= "select";
		GridObj.nHDLineSize  		= 40; 

        
// 		GridObj.AddGroup("GUBUN", "내정가격");
		
// 		GridObj.AppendHeader("GUBUN", "ESTM_PRICE");
// 		GridObj.AppendHeader("GUBUN", "RATE");
// 		GridObj.AppendHeader("GUBUN", "FINAL_ESTM_PRICE_ENC");
// 		GridObj.AppendHeader("GUBUN", "AVERAGEPRICE");


// 		GridObj.SetNumberFormat("BASIC_AMT"            ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("ESTM_PRICE"           ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("RATE"                 ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("FINAL_ESTM_PRICE_ENC" ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("AVERAGEPRICE"         ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("BID_AMT"              ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("SETTLEAVERAGEPRICE"   ,"#,###,###,###,###,###");
// 		GridObj.SetNumberFormat("CONTRAST"             ,"#,###,###,###,###,###");

        INDEX_SELECTED                 = GridObj.GetColHDIndex("SELECTED");
		INDEX_PAY_SEND_NO              = GridObj.GetColHDIndex("PAY_SEND_NO");
		INDEX_PO_SUBJECT               = GridObj.GetColHDIndex("PO_SUBJECT");
		INDEX_PO_NO                    = GridObj.GetColHDIndex("PO_NO");
		INDEX_VENDOR_NAME              = GridObj.GetColHDIndex("VENDOR_NAME");
		INDEX_VENDOR_CODE              = GridObj.GetColHDIndex("VENDOR_CODE");
		INDEX_JUMJUJMNM                = GridObj.GetColHDIndex("JUMJUJMNM");
		INDEX_JUMJUJMCD                = GridObj.GetColHDIndex("JUMJUJMCD");
		INDEX_PAY_AMT                  = GridObj.GetColHDIndex("PAY_AMT");
		INDEX_SIGNER_NM                = GridObj.GetColHDIndex("SIGNER_NM");
		INDEX_SIGNER_ID                   = GridObj.GetColHDIndex("SIGNER_ID");
		INDEX_CHANGE_DATE              = GridObj.GetColHDIndex("CHANGE_DATE");
		INDEX_PMKPMKNM              = GridObj.GetColHDIndex("PMKPMKNM");
		INDEX_PMKPMKCD              = GridObj.GetColHDIndex("PMKPMKCD");				
		INDEX_TAX_NO                 = GridObj.GetColHDIndex("TAX_NO");		
		INDEX_TAX_DATE               = GridObj.GetColHDIndex("TAX_DATE");		
		INDEX_PUBCODE                = GridObj.GetColHDIndex("PUBCODE");		
		INDEX_TAX_GUBUN              = GridObj.GetColHDIndex("TAX_GUBUN");				
	}

    //조회버튼을 클릭
    function doSelect()
    {
    	/*
    	form1.start_change_date.value   = del_Slash(form1.start_change_date.value);
    	form1.end_change_date.value     = del_Slash(form1.end_change_date.value);
		var from_date	   = LRTrim(form1.start_change_date.value);
		var to_date	       = LRTrim(form1.end_change_date.value);
		var bid_type       = $("#bid_type").val();

		if(from_date == "" || to_date == "" ) {
			alert("입찰마감일자를 입력하셔야 합니다.");
			return;
		}
		
		if(!checkDate(from_date)) {
			alert("입찰마감일자를 확인하세요.");
			form1.start_change_date.select();
			return;
		}
		
		if(!checkDate(to_date)) {
			alert("입찰마감일자를 확인하세요.");
			form1.end_change_date.select();
			return;
		}

		if(eval(del_Slash(document.forms[0].end_change_date.value)) < eval(del_Slash(document.forms[0].start_change_date.value)))
		{
			alert("입찰마감일자를 확인하세요.");
			return;
		}
		*/
		
        //service : p1014
        var mode   = "getPayBudgetGiveCnstList";
        servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.tax.pay_budget_give_cnst_list";

        var cols_ids = "<%=grid_col_id%>";
		var params = "mode=" + mode;
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( servletUrl, params );
		GridObj.clearAll(false);

//         GridObj.SetParam("mode"      , mode);
//         GridObj.SetParam("from_date" , from_date);
//         GridObj.SetParam("to_date"   , to_date);

//         GridObj.bSendDataFuncDefaultValidate=false;
// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }

	function JavaCall(msg1, msg2, msg3, msg4, msg5){
	    if(msg1 == "doQuery"){

	    }
	}
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	
    	//GridObj.attachHeader("#rspan,#rspan,#rspan,#rspan,#rspan,예비내정가격,사정율,확정,유효중(평균가),#rspan,#rspan,#rspan");
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 

	var selectedId = GridObj.getSelectedId();
	var rowIndex   = GridObj.getRowIndex(selectedId);

	if(cellInd==INDEX_PO_SUBJECT) {
		var po_no	= LRTrim(GridObj.cells(rowIndex, INDEX_PO_NO).getValue());   
		var url = "/procure/po_detail.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&po_no="+po_no;
		PopupGeneral(url+param, "PoDetailPop", "", "", "1000", "600");	    
	}
	
	 if (cellInd==INDEX_VENDOR_NAME) {
	   		var vendor_code = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_VENDOR_CODE);	//GridObj.GetCellValue("VENDOR_CODE",msg2);
			if(vendor_code ==""){
				alert("업체가 없습니다.");
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&vendor_code="+vendor_code,"ven_bd_con","left=0,top=0,width=900,height=600,resizable=yes,scrollbars=yes");
	 }
	 
	 if( cellInd == INDEX_TAX_NO ){
			if($.trim(GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_GUBUN")).getValue()) != "RP"){
		  		var tax_no 	= GridObj.cells(rowId, GridObj.GetColHDIndex("TAX_NO")).getValue();
		  		var status 	= GridObj.cells(rowId, GridObj.GetColHDIndex("PROGRESS_CODE")).getValue(); 
		  		location.href = "tax_pub_ins.jsp?tax_no=" + tax_no + "&gubun=" + status + "&gubun=P";
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

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
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
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    
    document.form1.from_date.value = add_Slash( document.form1.from_date.value );
    document.form1.to_date.value   = add_Slash( document.form1.to_date.value   );
    
    return true;
}


function SP9113_Popup() {
	/*
	var arrValue = new Array();
	arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
	arrValue[1] = "<%=info.getSession("COMPANY_CODE")%>";
	arrValue[2] = "";
	arrValue[3] = "";
	var arrDesc = new Array();
	arrDesc[0] = "아이디";
	arrDesc[1] = "이름";
	PopupCommonArr("SP9113","SP9113_getCode",arrValue,arrDesc);
	*/
	window.open("/common/CO_008.jsp?callback=SP9113_getCode", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
}

function  SP9113_getCode(ls_purchaser_id, ls_ctrl_person_name) {
	document.forms[0].purchaser_id.value         = ls_purchaser_id;
	document.forms[0].ctrl_person_name.value       = ls_ctrl_person_name;
}

function getVendorCode(setMethod) { popupvendor(setMethod); }
function setVendorCode( code, desc1, desc2 , desc3) {
	document.forms[0].vendor_code.value = code;
	document.forms[0].vendor_name.value = desc1;
}

function popupvendor( fun )
{
    window.open("/common/CO_014.jsp?callback=setVendorCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
}	
//지우기
function doRemove( type ){
    if( type == "purchaser_id" ) {
    	document.forms[0].purchaser_id.value = "";
        document.forms[0].ctrl_person_name.value = "";
    }  
    if( type == "vendor_code" ) {
    	document.forms[0].vendor_code.value = "";
        document.forms[0].vendor_name.value = "";
    }
    if( type == "req_dept" ) {
    	document.forms[0].req_dept.value      = "";
    	document.forms[0].req_dept_name.value = "";
    }
}

function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "REQ_DEPT"){
	    window.open("/common/CO_009.jsp?callback=getReq_dept", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function getReq_dept(code,text){
    document.forms[0].req_dept.value      = code;
	document.forms[0].req_dept_name.value = text;
}

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData,approvalCnt) {
	var sRptData = "";
	var rf = "<%=CommonUtil.getConfig("clipreport4.separator.field")%>";
	var rl = "<%=CommonUtil.getConfig("clipreport4.separator.line")%>";
	var rd = "<%=CommonUtil.getConfig("clipreport4.separator.data")%>";
	
	sRptData += document.form1.from_date.value;	//지급일자 from
	sRptData += " ~ ";
	sRptData += document.form1.to_date.value;	//지급일자 to
	sRptData += rf;
	sRptData += document.form1.purchaser_id.value;	//조작자1
	sRptData += rf;
	sRptData += document.form1.ctrl_person_name.value;	//조작자2
	sRptData += rf;
	sRptData += document.form1.pay_send_no.value;	//지급번호
	sRptData += rf;
	sRptData += document.form1.vendor_code.value;	//공급업체1
	sRptData += rf;
	sRptData += document.form1.vendor_name.value;	//공급업체2
	sRptData += rf;
	sRptData += document.form1.po_subject.value;	//발주명
	sRptData += rf;
	sRptData += document.form1.req_dept.value;	//배치점1
	sRptData += rf;
	sRptData += document.form1.req_dept_name.value;	//배치점2
	sRptData += rd;
			
	for(var i = 0; i < GridObj.GetRowCount(); i++){
		sRptData += GridObj.GetCellValue("PAY_SEND_NO",i);
		sRptData += rf;
		sRptData += GridObj.GetCellValue("PO_SUBJECT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("VENDOR_NAME",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("JUMJUJMNM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("PAY_AMT",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("SIGNER_NM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("CHANGE_DATE",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("PMKPMKNM",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("TAX_NO",i);
		sRptData += rf;		
		sRptData += GridObj.GetCellValue("TAX_DATE",i);
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
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<%@ include file="/include/sepoa_milestone.jsp" %>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
<form id="form1" name="form1">
<%--ClipReport4 hidden 태그 시작--%>
<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">
<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
<input type="hidden" name="rptAprvUsed" id="rptAprvUsed">	
<input type="hidden" name="rptAprvCnt" id="rptAprvCnt">
<input type="hidden" name="rptAprv" id="rptAprv">		
<%--ClipReport4 hidden 태그 끝--%>
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
<input type="hidden" id="ctrl_code" name="ctrl_code" 	value="">

<%-- <%@ include file="/include/include_top.jsp"%> --%>

   	<tr>
						<td width="100%">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
		      					<tr>
	       							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
	       								지급일자
	       							</td>
	       							<td width="30%"  class="data_td">
	       								<s:calendar id_from="from_date" id_to="to_date" default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d" />
        							</td>
        							<td width="15%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								조작자
        							</td>        						
      								<td class="data_td" width="35%">
        								<b><input type="text" name="purchaser_id" id="purchaser_id" value="<%=info.getSession("ID") %>" size="15" class="inputsubmit" readonly="readonly"  onkeydown='entKeyDown()' >
        								<a href="javascript:SP9113_Popup();"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
        								<a href="javascript:doRemove('purchaser_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
        								<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" value="<%=info.getSession("NAME_LOC")%>" class="input_data2" readonly  onkeydown='entKeyDown()' ></b>
      								</td>        							
			  					</tr>
				  				<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>			  					
			  					<tr>
        							<td width="20%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								지급번호
        							</td>
        							<td width="30%"  class="data_td">
        								<input type="text" id="pay_send_no" name="pay_send_no" style="ime-mode:inactive"  onkeydown='entKeyDown()'  >
        							</td>
        							<td width="15%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								공급업체
        							</td>        							
							      	<td class="data_td" width="35%">
							      		<input type="text" name="vendor_code" id="vendor_code" size="15" class="inputsubmit" maxlength="10" readonly="readonly" onkeydown='entKeyDown()' >
							        	<a href="javascript:getVendorCode('setVendorCode')"><img src="/images/ico_zoom.gif" width="19" height="19" align="absmiddle" border="0"></a>
							        	<a href="javascript:doRemove('vendor_code')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
							        	<input type="text" name="vendor_name" id="vendor_name" size="20" class="input_data2" readonly onkeydown='entKeyDown()' >
							      	</td>        							
        		     		
			  					</tr>
			  					<tr>
									<td colspan="6" height="1" bgcolor="#dedede"></td>
								</tr>
			  					<tr>
        	    					<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        								발주명
        							</td>
        							<td width="30%" class="data_td">
				    					<input type="text" id="po_subject" name="po_subject" style="width:150px;"  onkeydown='entKeyDown()' />
        							</td>	
        	    					<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
        	    						배치점
									</td>
									<td width="35%" class="data_td">
										<input type="text" name="req_dept" id="req_dept" style="ime-mode:inactive"  size="16" class="inputsubmit" value='' onkeydown='entKeyDown()'>
										<a href="javascript:PopupManager('REQ_DEPT');"><img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt=""></a>
										<a href="javascript:doRemove('req_dept')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
										<input type="text" name="req_dept_name" id="req_dept_name" size="25" class="input_data2" readonly value=''  onkeydown='entKeyDown()'>
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

<table width="98%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td height="10">
            <div align="right">
                <table><tr>
                        <td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
                        <%-- <td><script language="javascript">btn("javascript:SaveFileCommon('ALL')","다운로드")</script></td> --%>
                        <td><script language="javascript">btn("javascript:clipPrint()","출 력")		</script></td>
                </tr></table>
            </div>
        </td>
    </tr>
</table>
</form>
<form id="taxListForm" name="taxListForm" method="get">
	<input type="hidden" id="pubCode"  name="pubCode" >
	<input type="hidden" id="docType"  name="docType" >
	<input type="hidden" id="userType" name="userType" >
</form>
<!---- END OF USER SOURCE CODE ---->
<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="ST_012" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


