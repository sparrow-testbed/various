<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_032_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_032_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
	구매요청 수정화면
	- 카탈로그를 사용하기 위한 /include/catalog.js를 import한다.
	- 결재가 필요없을 경우 결재버튼을 없애고
	- G_SAVE_STATUS = 'E'로 바꿔준다.

	* 구매요청 생성과의 다른점
	- 삭제 버튼 - 정말로 DB에서 삭제해야한다.
	- 카탈로그에서(setCatalog) WiseTable의 IU_FLAG를 'I'로 셋팅하여 입력한다. - 조회시에는 'U'로 셋팅되어 온다.


--%>
<% 
	String WISEHUB_PROCESS_ID="PR_032_1";
    String USER_ID      = info.getSession("ID");
    String HOUSE_CODE   = info.getSession("HOUSE_CODE") ;
    String COMPANY_CODE = info.getSession("COMPANY_CODE") ;
    String USER_TYPE	= info.getSession("USER_TYPE") ;

	String PR_NO        = JSPUtil.nullToEmpty(request.getParameter("pr_no"));
    String SUBJECT            	= "";
    String ORDER_NO           	= "";
    String ORDER_COUNT			= "";
    String ORDER_NAME         	= "";
    String RECEIVE_TERM       	= "";
    String ADD_DATE_VIEW        = "";
    String DEMAND_DEPT_NAME   	= "";
    String DEMAND_DEPT        	= "";
    String ADD_USER_NAME      	= "";
    String CONTRACT_HOPE_DAY_VIEW  = "";
    String SALES_USER_DEPT 	  = "";
    String SALES_DEPT_NAME 	  = "";
    String SALES_USER_ID      = "";
    String SALES_USER_NAME      = "";
    String SHIPPER_TYPE       	= "";
    String SHIPPER_TYPE_TEXT  	= "";
    String PR_TYPE            	= "";
    String SALES_TYPE         	= "";
    String HARD_MAINTANCE_TERM  = "";
    String SOFT_MAINTANCE_TERM  = "";
    String DELY_TO_CONDITION  	= "";
    String TAKE_USER_NAME     	= "";	//인수자
    String TAKE_TEL           	= "";	//연락처
    String COMPUTE_REASON     	= "";	//금액산정근거
    String AHEAD_FLAG         	= "";	//선투입
    String REC_REASON         	= "";	//업체추천사유
    String CUST_CODE          	= "";
    String CUST_NAME          	= "";
    String SALES_AMT          	= "";
    String CONTRACT_VIEW 	  	= "";
    String REMARK             	= "";
    String BID_PR_NO          	= "";
    String ATTACH_NO          	= "";
    String ATT_COUNT          	= "";
    String BSART          		= "";
    String WBS_NO          		= "";
    String WBS_SUB_NO          	= "";
    String WBS_TXT          	= "";

    String WBS_NAME        		= "";
    String PR_TOT_AMT      		= "";
	String REQ_TYPE				= "";
	String wbs				= "";
	String wbs_name				= "";

	String DELY_TO_LOCATION     = "";
	String DELY_TO_ADDRESS      = "";
	String DELY_TO_USER         = "";
	String DELY_TO_PHONE        = "";
	
	String PC_FLAG              = "";
	String PC_REASON            = "";
	
	Map<String, String> svcParam = new HashMap<String, String>();
	
	svcParam.put("PR_NO", PR_NO);
	svcParam.put("HOUSE_CODE", HOUSE_CODE);
	
    Object[] args = {svcParam };
    String sPrNo    = "";
	String addPrNo  = "";
    SepoaOut valuePrBr = ServiceConnector.doService(info, "p1015", "CONNECTION","PrBrDisplay", args);

    SepoaFormater wfvaluePrBr = new SepoaFormater(valuePrBr.result[0]);
    int iRowCountPrBr = wfvaluePrBr.getRowCount();
    
    for(int i=0; i<iRowCountPrBr; i++)
    {
    	sPrNo = wfvaluePrBr.getValue("BR_NO",i)+':';
    	addPrNo += sPrNo;
    }
    
    String[] args2 = new String[1];
    args2[0] = PR_NO;
    
    SepoaOut value = ServiceConnector.doService(info, "p1001", "CONNECTION","prHDQueryDisplay", args2);


    SepoaFormater wf = new SepoaFormater(value.result[0]);
    int iRowCount = wf.getRowCount();
    if(iRowCount>0)
    {
    	SUBJECT             	= wf.getValue("SUBJECT",0);
    	ORDER_NO            	= wf.getValue("ORDER_NO",0);
    	ORDER_COUNT				= wf.getValue("ORDER_COUNT",0);
    	ORDER_NAME          	= wf.getValue("ORDER_NAME",0);
    	RECEIVE_TERM        	= wf.getValue("RECEIVE_TERM",0);
    	ADD_DATE_VIEW           = wf.getValue("ADD_DATE_VIEW",0);
    	DEMAND_DEPT_NAME    	= wf.getValue("DEMAND_DEPT_NAME",0);
    	DEMAND_DEPT         	= wf.getValue("DEMAND_DEPT",0);
    	ADD_USER_NAME         	= wf.getValue("ADD_USER_NAME",0);
    	CONTRACT_HOPE_DAY_VIEW  = wf.getValue("CONTRACT_HOPE_DAY_VIEW",0);
    	SALES_USER_DEPT     	= wf.getValue("SALES_USER_DEPT",0);
    	SALES_DEPT_NAME     	= wf.getValue("SALES_USER_DEPT_NAME",0);
    	SALES_USER_NAME       	= wf.getValue("SALES_USER_NAME",0);
    	SALES_USER_ID       	= wf.getValue("SALES_USER_ID",0);
    	SHIPPER_TYPE        	= wf.getValue("SHIPPER_TYPE",0);
    	SHIPPER_TYPE_TEXT   	= wf.getValue("SHIPPER_TYPE_TEXT",0);
    	PR_TYPE             	= wf.getValue("PR_TYPE",0);
    	SALES_TYPE          	= wf.getValue("SALES_TYPE",0);
    	HARD_MAINTANCE_TERM    	= wf.getValue("HARD_MAINTANCE_TERM",0);
    	SOFT_MAINTANCE_TERM    	= wf.getValue("SOFT_MAINTANCE_TERM",0);
        DELY_TO_CONDITION   	= wf.getValue("DELY_TO_CONDITION",0);
        TAKE_USER_NAME      	= wf.getValue("TAKE_USER_NAME",0);
        TAKE_TEL            	= wf.getValue("TAKE_TEL",0);
        COMPUTE_REASON      	= wf.getValue("COMPUTE_REASON",0);
        AHEAD_FLAG          	= wf.getValue("AHEAD_FLAG",0);
        REC_REASON          	= wf.getValue("REC_REASON",0);
        CUST_CODE           	= wf.getValue("CUST_CODE",0);
        CUST_NAME 				= wf.getValue("CUST_NAME",0);
        SALES_AMT           	= wf.getValue("SALES_AMT",0);
        CONTRACT_VIEW  			= wf.getValue("CONTRACT_VIEW",0);
        REMARK              	= wf.getValue("REMARK",0);
        BID_PR_NO           	= wf.getValue("BID_PR_NO",0);
        ATTACH_NO           	= wf.getValue("ATTACH_NO",0);
        ATT_COUNT           	= wf.getValue("ATT_COUNT",0);
        BSART					= wf.getValue("BSART",0);
        WBS_NO					= wf.getValue("WBS_NO",0);
        WBS_SUB_NO				= wf.getValue("WBS_SUB_NO",0);
        WBS_TXT					= wf.getValue("WBS_TXT",0);

        WBS_NAME				= wf.getValue("WBS_TXT",0);
        PR_TOT_AMT				= wf.getValue("PR_TOT_AMT",0);
        REQ_TYPE				= wf.getValue("REQ_TYPE",0);
        wbs				= wf.getValue("WBS",0);
        wbs_name				= wf.getValue("WBS_NAME",0);
        
    	DELY_TO_LOCATION		= wf.getValue("DELY_TO_LOCATION",0);
    	DELY_TO_ADDRESS			= wf.getValue("DELY_TO_ADDRESS",0);
    	DELY_TO_USER			= wf.getValue("DELY_TO_USER",0);
    	DELY_TO_PHONE			= wf.getValue("DELY_TO_PHONE",0);
    	
    	PC_FLAG			     = wf.getValue("PC_FLAG",0);
    	PC_REASON			 = wf.getValue("PC_REASON",0);
    }
    
    String jspPage = null;

	if("B".equals(REQ_TYPE)){
		if("I".equals(PR_TYPE)){
			jspPage = "ebd_pp_dis6I";
		}
		else{
			jspPage = "ebd_pp_dis6NotI";
		}
%>
	<script>
		location.href = "/kr/dt/ebd/<%=jspPage %>.jsp?pr_no=<%=PR_NO%>";
	</script>
<%
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.pr.pr1_bd_dis1";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_CUR_ROW;//팝업 관련해서 씀..
var G_PR_NO        = "<%=PR_NO%>";

var INDEX_SELECTED          ;
var INDEX_ITEM_NO           ;
var INDEX_DESCRIPTION_LOC   ;
var INDEX_PR_QTY            ;
var INDEX_UNIT_MEASURE      ;
var INDEX_UNIT_PRICE        ;
var INDEX_PR_AMT            ;
var INDEX_CUR               ;
var INDEX_RD_DATE           ;
var INDEX_REC_VENDOR_CODE   ;
var INDEX_REC_VENDOR_NAME   ;
var INDEX_DELY_TO_LOCATION  ;
var INDEX_DELY_TO_ADDRESS   ;
var INDEX_ATTACH_NO         ;
var INDEX_PURCHASE_LOCATION ;
var INDEX_PURCHASER_ID      ;
var INDEX_PURCHASER_NAME    ;
var INDEX_PURCHASE_DEPT_NAME;
var INDEX_PURCHASE_DEPT     ;
var INDEX_IU_FLAG			;
var INDEX_WBS_NO     		;
var INDEX_WBS_SUB_NO     	;
var INDEX_WBS_TXT     		;
var INDEX_ORDER_SEQ     	;

var CONTRACT_DIV_TXT		;
var WARRANTY				;

function init(){
	setGridDraw();
	setHeader_1();
}

function setHeader_1(){
    INDEX_SELECTED           = GridObj.GetColHDIndex("SELECTED");
	INDEX_ITEM_NO            = GridObj.GetColHDIndex("ITEM_NO");
	INDEX_DESCRIPTION_LOC    = GridObj.GetColHDIndex("DESCRIPTION_LOC");
	INDEX_PR_QTY             = GridObj.GetColHDIndex("PR_QTY");
	INDEX_UNIT_MEASURE       = GridObj.GetColHDIndex("UNIT_MEASURE");
	INDEX_UNIT_PRICE         = GridObj.GetColHDIndex("UNIT_PRICE");
	INDEX_PR_AMT             = GridObj.GetColHDIndex("PR_AMT");
	INDEX_CUR                = GridObj.GetColHDIndex("CUR");
	INDEX_RD_DATE            = GridObj.GetColHDIndex("RD_DATE");
	INDEX_REC_VENDOR_CODE    = GridObj.GetColHDIndex("REC_VENDOR_CODE");
	INDEX_REC_VENDOR_NAME    = GridObj.GetColHDIndex("REC_VENDOR_NAME");
	INDEX_DELY_TO_LOCATION   = GridObj.GetColHDIndex("DELY_TO_LOCATION");
	INDEX_DELY_TO_ADDRESS    = GridObj.GetColHDIndex("DELY_TO_ADDRESS");
	INDEX_ATTACH_NO          = GridObj.GetColHDIndex("ATTACH_NO");
	INDEX_PURCHASE_LOCATION  = GridObj.GetColHDIndex("PURCHASE_LOCATION");
	INDEX_PURCHASER_ID       = GridObj.GetColHDIndex("PURCHASER_ID");
	INDEX_PURCHASER_NAME     = GridObj.GetColHDIndex("PURCHASER_NAME");
	INDEX_PURCHASE_DEPT_NAME = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME");
	INDEX_PURCHASE_DEPT      = GridObj.GetColHDIndex("PURCHASE_DEPT");
	INDEX_IU_FLAG      		 = GridObj.GetColHDIndex("IU_FLAG");
	INDEX_WBS_NO 		 	 = GridObj.GetColHDIndex("WBS_NO");
	INDEX_WBS_SUB_NO 		 = GridObj.GetColHDIndex("WBS_SUB_NO");
	INDEX_WBS_TXT 		 	 = GridObj.GetColHDIndex("WBS_TXT");
	INDEX_ORDER_SEQ			 = GridObj.GetColHDIndex("ORDER_SEQ");

	GridObj.strHDClickAction="select";

	doSelect();
}


/**
 * Form 에 Input Name과 Value를 Hidden Type으로 세팅하여 되돌려줌
 * @param frm 
 * @param inputName
 * @param inputValue
 * @returns
 */
function fnFormInputSet(frm, inputName, inputValue) {
	var input = document.createElement("input");
	
	input.type  = "hidden";
	input.name  = inputName;
	input.id    = inputName;
	input.value = inputValue;
	
//	frm.appendChild(input);
	
	return input;
}

/**
 * 동적 form을 생성하여 반환하는 메소드
 *
 * @param url
 * @param param
 * @param target
 * @return form
 */
function fnGetDynamicForm(url, param, target){
	var form           = document.createElement("form");
	var paramArray     = param.split("&");
	var i              = 0;
	var paramInfoArray = null;

	if((target == null) || (target == "")){
		target = "_self";
	}

	for(i = 0; i < paramArray.length; i++){
		paramInfoArray = paramArray[i].split("=");
		
		var input = fnFormInputSet(form, paramInfoArray[0], paramInfoArray[1]);

		form.appendChild(input);
	}

	form.action = url;
	form.target = target;
	form.method = "post";

	return form;
}

function getSearchParam(){
	var inputParam = "";
	var body       = document.getElementsByTagName("body")[0];
	var params     = "";
	
	inputParam = "prNo=" + G_PR_NO;
	inputParam = inputParam + "&prProceedingFlag=";
	
	var form = fnGetDynamicForm("", inputParam, null);
	
	body.appendChild(form);
	
	params = "mode=prDTQueryDisplay";
	params = params + "&cols_ids=<%=grid_col_id%>";
	params = params + dataOutput();
	
	body.removeChild(form);
	
	return params;
}

function doSelect(){
	var params = getSearchParam();
	
	GridObj.post( G_SERVLETURL, params );
	
	GridObj.clearAll(false);
}

var summaryCnt = 0;

function JavaCall(msg1, msg2, msg3, msg4, msg5){
	var wise = GridObj;
	
	var f = document.forms[0];

	if(msg1 == "t_insert"){
		if(msg3 == INDEX_PR_QTY){
			calculate_pr_amt(wise, msg2);
		}
		
		if(msg3 == INDEX_UNIT_PRICE){
			calculate_pr_amt(wise, msg2);
		}
	}

	if(msg1 == "t_imagetext"){
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'no';
		G_CUR_ROW = msg2;

		if(msg3 == INDEX_ATTACH_NO){
			PopupManager("ATTACH_FILE");
		}

		if(msg3 == INDEX_ITEM_NO) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            var PoDisWin =window.open(url, 'agentCodeWin', 'left=30, top=30, width=750, height=550, toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
        }

		if(msg3 == INDEX_REC_VENDOR_NAME) {
        	var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_REC_VENDOR_CODE);
        	
			if(vendor_code == ""){
				return;
			}
			
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=COMPANY_CODE%>&vendor_code="+vendor_code+"&user_type=<%=USER_TYPE%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		}
	}

	if(msg1 == "doData"){
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);

		if(mode == "setPrChange"){
			alert(GridObj.GetMessage());
			
			if(status != "0"){
				GridObj.RemoveAllData();
				window.href = "/kr/dt/pr/pr1_bd_lis1.jsp";
			}
		}
		else if(mode == "deletePrdt"){
			alert(GridObj.GetMessage());
			
			doSelect();
		}
	}
	
	if(msg1 == "doQuery"){
    	if(msg3 == INDEX_PR_QTY) {
    		calculate_pr_qty(GridObj, msg2);
			//calculate_pr_amt(GridObj, msg2);
		}
    	
		//if(summaryCnt == 0) {
		//	GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
		//	GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
		//	summaryCnt++;
		//}
	}
}

/**
 * 품목별 발주 수량을 계산한다.
 */
function calculate_pr_qty(wise, row){
	// 소숫점 두자리까지 계산
	GD_SetCellValueIndex(GridObj,row, INDEX_PR_QTY, RoundEx(GD_GetCellValueIndex(GridObj,row,INDEX_PR_QTY), 3));
}

/**
 * 품목별 발주 금액을 계산한다.
 */
function calculate_po_amt(wise, row){
	// 소숫점 두자리까지 계산
	var PR_AMT = RoundEx(getCalculEval(GD_GetCellValueIndex(GridObj,row,INDEX_PO_QTY))*getCalculEval(GD_GetCellValueIndex(GridObj,row,INDEX_UNIT_PRICE)), 3);
	GD_SetCellValueIndex(GridObj,row, IDX_PR_AMT, setAmt(PR_AMT));
}

/*
	팝업 관련 코드
*/
function PopupManager(part){
	var url = "";
	var f = document.forms[0];
	var wise = GridObj;
	
 	if(part == "ATTACH_FILE"){
		var attach_no = GD_GetCellValueIndex(GridObj,G_CUR_ROW, INDEX_ATTACH_NO);

		FileAttach('PR',attach_no,'VI')
	}
}

function orderChange(cd){
 	if(cd == "M"){
 		document.form1.order_no.value = "<%=ORDER_NO %>";
 		document.getElementById("t_cls01").className = "se_cell_title";
 		document.all["t_cls01"].innerHTML = "Sales Order";
 		document.all["_div01"].style.display="block";
 		document.all["_div02"].style.display="none";
 	}
 	else if(cd == "P"){
 		document.form1.wbs_no.value = "<%=WBS_NO %>";
 		document.form1.wbs_sub_no.value = "<%=WBS_SUB_NO %>";
 		document.form1.wbs_txt.value = "<%=WBS_TXT %>";
 		document.getElementById("t_cls01").className = "se_cell_title";
 		document.all["t_cls01"].innerHTML = "WBS요소";
 		document.all["_div01"].style.display="none";
 		document.all["_div02"].style.display="block";
 	}
 	else{
 		document.getElementById("t_cls01").className = "c_data_1";
 		document.all["t_cls01"].innerHTML = "&nbsp;";
 		document.all["_div01"].style.display="none";
 		document.all["_div02"].style.display="none";
 	}
}

function download(url){
 	location.href = url;
}

function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "P") {
		var protocol = location.protocol;
		var host     = location.host;
		var addr     = protocol +"//" +host;

		var win = window.open("","fileattach",'left=0,top=0, width=620, height=300,toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no');

		f.method = "POST";
		f.target = "fileattach";
		f.action = addr + "/rMateFM/rMate_file_attach_pop.jsp";
		f.submit();
	}
	else if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function openSCMSProject(PJT_CODE, CON_NO, CON_DGR, CUST_CODE){
	return;
}
</Script>

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

    if(status == "true") {
        alert(messsage);
        
        doQuery();
    }
    else {
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
    if(status == "0"){
    	alert(msg);
    }
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="title_page">구매요청 상세현황</td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="760" height="2" bgcolor="#0072bc"></td>
		</tr>
	</table>
	<form name="form1" action="">
		<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
		<input type="hidden" name="bsart" value="<%=BSART%>">			<%--문서유형--%>
		<input type="hidden" name="sales_type" value="<%=SALES_TYPE%>">	<%--구매요청구분--%>
		<input type="hidden" name="order_no" value="<%=ORDER_NO%>">		<%--수주번호--%>
		<input type="hidden" name="wbs_no" value="<%=WBS_NO%>">			<%--프로젝트번호--%>
		<input type="hidden" name="wbs_txt" value="<%=WBS_TXT%>">
		<input type="hidden" name="wbs_sub_no" value="<%=WBS_SUB_NO%>">
	
		<input type="hidden" name="att_mode"   value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		<input type="hidden" name="attach_count" value="">
		<input type="hidden" name="approval_str" value="">
	
		<input type="hidden" name="pr_type" value="<%=PR_TYPE%>">							<%--요청구분--%>
		<input type="hidden" name="hard_maintance_term" value="<%=HARD_MAINTANCE_TERM%>">	<%--하자보증기간 H/W--%>
		<input type="hidden" name="soft_maintance_term" value="<%=SOFT_MAINTANCE_TERM%>">	<%--하자보증기간 S/W--%>
		<input type="hidden" name="shipper_type" value="<%=SHIPPER_TYPE%>">					<%--내외자구분--%>
		<input type="hidden" name="compute_reason" value="<%=COMPUTE_REASON%>">				<%--금액산정근거--%>
		<input type="hidden" name="rec_reason" value="<%=REC_REASON%>">						<%--업체추천사유--%>
	
		<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
			<tr style="display: none">
				<td width="15%" class="se_cell_title">프로젝트코드</td>
				<td width="35%" class="c_data_1" colspan="">
					<%=wbs%>
				</td>
				<td width="15%" class="se_cell_title">프로젝트명</td>
				<td width="35%" class="c_data_1" colspan="">
					<%=wbs_name%>
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">프로젝트</td>
				<td width="35%" class="c_data_1" colspan="3">
					<input type="text" name="" value="<%=WBS_NO%> / <%=WBS_NAME%>" style="width:100%;color:#0000ff;cursor:;" class="input_data2" readOnly onClick="openSCMSProject('<%=WBS_NO%>', '<%=ORDER_NO%>', '<%=ORDER_COUNT%>', '<%=CUST_CODE%>')">
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">요청부서</td>
				<td width="35%" class="c_data_1" >
					<%=DEMAND_DEPT_NAME%>
				</td>
				<td width="15%" class="se_cell_title">요청자</td>
				<td width="35%" class="c_data_1" >
					<%=ADD_USER_NAME%>
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">영업부서</td>
				<td width="35%" class="c_data_1" >
					<%=SALES_DEPT_NAME%>&nbsp;
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">검수자</td>
				<td width="35%" class="c_data_1" colspan="3">
					<%=SALES_USER_NAME%>&nbsp;
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
			<tr style="display: none">
				<td width="15%" class="se_cell_title">고객사</td>
				<td width="35%" class="c_data_1" >
					<%=CUST_NAME%>
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">매출계약예상일자</td>
				<td width="35%" class="c_data_1" colspan="3">
					<%=CONTRACT_HOPE_DAY_VIEW%>
				</td>
			</tr>
			<tr style="display: none">
				<td width="15%" class="se_cell_title">선투입여부</td>
				<td width="35%" class="c_data_1" >
					<%=AHEAD_FLAG%>
				</td>
			</tr>
			<tr style="display:none;">
				<td width="15%" class="se_cell_title">납품장소</td>
				<td width="35%" class="c_data_1" >
					<%=DELY_TO_LOCATION%>
				</td>
				<td width="15%" class="se_cell_title">납품주소</td>
				<td width="35%" class="c_data_1" >
					<%=DELY_TO_ADDRESS%>
				</td>
			</tr>
			<tr>
<%--
				<td class="se_cell_title" width="15%">프로젝트명</td>
				<td class="c_data_1" width="35%">
					<%=wbs_name%>
				</td>
 --%>
				<td class="se_cell_title" width="15%">사전지원</td>
				<td class="c_data_1"  width="35%" colspan="3">
					<%=addPrNo %>
				</td>
			</tr>
			<tr>
				<td class="se_cell_title">구매요청번호</td>
				<td class="c_data_1">
					<%=PR_NO%>
				</td>
				<td class="se_cell_title">요청명</td>
				<td class="c_data_1">
					<%=SUBJECT%>
				</td>
			</tr>
			<tr>
<%--
				<td class="se_cell_title">고객사</td>
				<td class="c_data_1">
					<%=CUST_NAME%>
				</td>
 --%>
				<td class="se_cell_title">요청일자</td>
				<td class="c_data_1" colspan="3">
					<%=ADD_DATE_VIEW%>
				</td>
			</tr>
			<tr>
				<td class="se_cell_title" style="display: none;">매출계약예상일</td>
				<td class="c_data_1" style="display: none;">
					<%=CONTRACT_HOPE_DAY_VIEW%>
				</td>
				<td class="se_cell_title">예상금액</td>
				<td class="c_data_1" colspan="3">
					<%=PR_TOT_AMT%>
				</td>
			</tr>
			<tr>
				<td class="se_cell_title">수의여부</td>
				<td class="c_data_1" >
					<%=PC_FLAG%>
				</td>
				<td class="se_cell_title">사유</td>
				<td class="c_data_1" >
					<%=PC_REASON%>
				</td>
			</tr>
			<tr>
				<td width="15%" class="se_cell_title">특기사항</td>
				<td width="35%" class="c_data_1" colspan="3">
					<textarea name="remark" rows="5" style="width:98%" class="input_data1" readonly><%=REMARK%></textarea>
				</td>
			</tr>
			<tr>
				<td width="15%" class="se_cell_title">첨부파일</td>
				<td class="c_data_1" colspan="3" height="150">
<script language="javascript">
btn("javascript:FileAttach('FILE',$('#sign_attach_no').val(),'VI')", "파일보기");
</script>
					<input type="text" size="3" readOnly class="input_empty" value="<%=ATT_COUNT %>" name="sign_attach_no_count" id="sign_attach_no_count"/>
					<input type="hidden" value="<%=ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>
<s:grid screen_id="PR_032_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>