<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_032");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_032";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;


	String WISEHUB_PROCESS_ID="PR_032";
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
	
	String RPT_GETFILENAMES     = "";
	
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
    	
    	RPT_GETFILENAMES	 = wf.getValue("RPT_GETFILENAMES  ", 0);
    }
    //LISTBOX VALUE
	
    
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

<%
/*
Map map = new HashMap();
//map.put("HOUSE_CODE"			, HOUSE_CODE);        
map.put("prNo"				, PR_NO);
map.put("prProceedingFlag"				, "");
Map<String, Object> data = new HashMap();
data.put("header"		, map);


Object[] obj3 = {data};
SepoaOut value3 = ServiceConnector.doService(info, "p1001", "CONNECTION", "prDTQueryDisplay_Change", obj3);
SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
*/

	Map<String, String> data = new HashMap();
	data.put("prNo"				, PR_NO);
	Object[] obj3 = {data};
	SepoaOut value3 = ServiceConnector.doService(info, "p1001", "CONNECTION", "prDTQueryDisplay_Change", obj3);
	SepoaFormater wf3 = new SepoaFormater(value3.result[0]);
	
	//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
	String _rptName          = "020644/rpt_pr1_bd_dis1I"; //리포트명
	StringBuilder _rptData = new StringBuilder();//리포트 제공 데이타
	String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
	String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
	String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
	//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////
	
 	//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
  	_rptData.append(PR_NO);	//구매요청번호
	_rptData.append(_RF);
	_rptData.append(SUBJECT);	//요청명
	_rptData.append(_RF);	
	_rptData.append(ADD_DATE_VIEW);	//요청일자
	_rptData.append(_RF);
	_rptData.append(PR_TOT_AMT);	//예상금액
	_rptData.append(_RF);
	_rptData.append(PC_FLAG);	//수의여부
	_rptData.append(_RF);
	_rptData.append(PC_REASON);	//사유
	_rptData.append(_RF);
	_rptData.append(DEMAND_DEPT_NAME);	//요청부서
	_rptData.append(_RF);
	_rptData.append(ADD_USER_NAME);	//요청자
	_rptData.append(_RF);
	_rptData.append(REMARK);	//특기사항
	_rptData.append(_RF);
	_rptData.append(RPT_GETFILENAMES);	//첨부파일 
	
	
	_rptData.append(_RD);	
	if(wf3 != null) {
		if(wf3.getRowCount() > 0) { //데이타가 있는 경우
			for(int i = 0 ; i < wf3.getRowCount() ; i++){
				_rptData.append(wf3.getValue("DESCRIPTION_LOC", i));
				_rptData.append(_RF);
				_rptData.append(wf3.getValue("SPECIFICATION", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("UNIT_MEASURE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("PR_QTY", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("CUR", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("UNIT_PRICE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("RD_DATE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("DELY_TO_ADDRESS",i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("REC_VENDOR_NAME", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("ACCOUNT_TYPE", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("APP_DIV", i));
				_rptData.append(_RF);			
				_rptData.append(wf3.getValue("OSQ_NO", i));
				_rptData.append(_RL);			
			}
		}
	}
	
	
	//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////

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
var INDEX_OSQ_NO           ;
var INDEX_OSQ_COUNT    ;
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
	INDEX_OSQ_NO			 = GridObj.GetColHDIndex("OSQ_NO");
	INDEX_OSQ_COUNT    = GridObj.GetColHDIndex("OSQ_COUNT");
	
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
	
	//frm.appendChild(input);
	
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
	
	if( header_name == "OSQ_NO" ) {
		
	    var osq_no    = SepoaGridGetCellValueId( GridObj, rowId, "OSQ_NO" );
	    var osq_count = SepoaGridGetCellValueId( GridObj, rowId, "OSQ_COUNT" );
	    
	    var url    = '/kr/so/sos_bd_dis1.jsp';
	    var title  = '실사요청상세조회';
	    var param  = 'OSQ_NO=' + osq_no;
	    param     += '&OSQ_COUNT=' + osq_count;
	    
	    popUpOpen01(url, title, '1024', '650', param);
    
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

<%-- ClipReport4 리포터 호출 스크립트 --%>
function clipPrint(rptAprvData) {
	if(typeof(rptAprvData) != "undefined"){
		alert(rptAprvData);
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
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>구매요청 상세현황</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" action="">
		<%--ClipReport4 hidden 태그 시작--%>
		<input type="hidden" name="rptName" id="rptName" value="<%=_rptName%>">
		<input type="hidden" name="rptData" id="rptData" value="<%=_rptData.toString().replaceAll("\"", "&quot")%>">	
		<input type="hidden" name="WDTH_YN" id="WDTH_YN" value="Y">
		<%--ClipReport4 hidden 태그 끝--%>
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
	
		<table width="100%" border="0" cellspacing="0" cellpadding="1" style="display: none;">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
									<tr>
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
							</td>
						</tr>
					</table>
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
									<tr style="display: none;">
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사전지원</td>
										<td class="data_td" colspan="3"><%=addPrNo %></td>
									</tr>
									<tr style="display: none;">
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;구매요청번호</td>
										<td width="35%" class="data_td" ><%=PR_NO%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청명</td>
										<td width="35%" class="data_td" ><%=SUBJECT%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청일자</td>
										<td class="data_td" colspan="3"><%=ADD_DATE_VIEW%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td class="se_cell_title" style="display: none;">매출계약예상일</td>
										<td class="c_data_1" style="display: none;"><%=CONTRACT_HOPE_DAY_VIEW%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예상금액</td>
										<td class="data_td"  colspan="3"><%=PR_TOT_AMT%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수의여부</td>
										<td width="35%" class="data_td" ><%=PC_FLAG%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사유</td>
										<td width="35%" class="data_td" ><%=PC_REASON%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청부서</td>
										<td width="35%" class="data_td" ><%=DEMAND_DEPT_NAME%></td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청자</td>
										<td width="35%" class="data_td" ><%=ADD_USER_NAME%></td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특기사항</td>
										<td class="data_td" colspan="3">
											<textarea name="remark" rows="5" style="width:98%" class="input_data1" readonly><%=REMARK%></textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;첨부파일</td>
										<td class="data_td" colspan="3" height="150">
											<iframe id="attachFrm" name="attachFrm" src="/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=<%=ATTACH_NO%>&view_type=VI" style="width: 98%;height: 115px; border: 0px;" frameborder="0" ></iframe>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
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
									btn("javascript:clipPrint()","출 력")
								</script>
							</TD>
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

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_032" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>