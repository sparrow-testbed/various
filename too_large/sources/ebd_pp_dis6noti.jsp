<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%-- 화면만 컨버젼만 되어 있습니다. 구매요청에서 데이터 없어서 컨버젼만 하고 넘어갑니다. tytolee --%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_033_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_033_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
    카탈로그를 사용하기 위한 /include/catalog.js를 import한다.
    결재가 필요없을 경우 결재버튼을 없애고
    G_SAVE_STATUS = 'E'로 바꿔준다.
--%>
<% String WISEHUB_PROCESS_ID="PR_033_1";%>
<%
    String PR_NO          = JSPUtil.nullToEmpty(request.getParameter("pr_no"));

    String USER_ID        = info.getSession("ID");
    String HOUSE_CODE     = info.getSession("HOUSE_CODE") ;
    String COMPANY_CODE   = info.getSession("COMPANY_CODE") ;

    String SUBJECT                  = "";
    String ORDER_NO                 = "";
    String ORDER_NAME               = "";
    String RECEIVE_TERM             = "";
    String ADD_DATE                 = "";
    String DEMAND_DEPT_NAME         = "";
    String DEMAND_DEPT              = "";
    String ADD_USER_ID              = "";
    String ADD_USER_NAME            = "";
    String CONTRACT_HOPE_DAY        = "";
    String SALES_DEPT               = "";
    String SALES_DEPT_NAME          = "";
    String SALES_USER_ID            = "";
    String SALES_USER_NAME          = "";
    String PR_TYPE                  = "";
    String SALES_TYPE               = "";
    String CUST_CODE                = "";
    String EXPECT_AMT               = "";
    String REMARK                   = "";
    String RETURN_HOPE_DAY          = "";
    String ATTACH_NO                = "";
    String ATT_COUNT                = "";
    String HARD_MAINTANCE_TERM      = "";
    String SOFT_MAINTANCE_TERM      = "";
    String CREATE_TYPE              = "";
    String CREATE_TYPE_TEXT			= "";
    String CUST_NAME                = "";
    String ADD_DATE_VIEW            = "";
    String CONTRACT_HOPE_DAY_VIEW   = "";
    String RETURN_HOPE_DAY_VIEW     = "";
    String BSART              		= "";
    String WBS              		= "";
    String WBS_NO             		= "";
    String WBS_SUB_NO         		= "";
    String WBS_TXT            		= "";
    String PR_TOT_AMT				= "";

    String[] args = {PR_NO };
    SepoaOut value = ServiceConnector.doService(info, "p1015", "CONNECTION","ReqBidHDQueryDisplay", args);

    SepoaFormater wf = new SepoaFormater(value.result[0]);
    int iRowCount = wf.getRowCount();
    if(iRowCount>0)
    {
        SUBJECT                     = wf.getValue("SUBJECT",0);
        ORDER_NO                    = wf.getValue("ORDER_NO",0);
        ORDER_NAME                  = wf.getValue("ORDER_NAME",0);
        ADD_DATE                    = wf.getValue("ADD_DATE",0);
        DEMAND_DEPT_NAME            = wf.getValue("DEMAND_DEPT_NAME",0);
        DEMAND_DEPT                 = wf.getValue("DEMAND_DEPT",0);
        ADD_USER_ID                 = wf.getValue("ADD_USER_ID",0);
        ADD_USER_NAME               = wf.getValue("ADD_USER_NAME",0);
        CONTRACT_HOPE_DAY           = wf.getValue("CONTRACT_HOPE_DAY",0);
        SALES_DEPT_NAME             = wf.getValue("SALES_USER_DEPT_NAME",0);
        SALES_USER_NAME             = wf.getValue("SALES_USER_NAME",0);
        PR_TYPE                     = wf.getValue("PR_TYPE",0);
        SALES_TYPE                  = wf.getValue("SALES_TYPE",0);
        EXPECT_AMT                  = wf.getValue("EXPECT_AMT",0);
        REMARK                      = wf.getValue("REMARK",0);
        RETURN_HOPE_DAY             = wf.getValue("RETURN_HOPE_DAY",0);
        ATTACH_NO                   = wf.getValue("ATTACH_NO",0);
        ATT_COUNT                   = wf.getValue("ATT_COUNT",0);
        HARD_MAINTANCE_TERM         = wf.getValue("HARD_MAINTANCE_TERM",0);
        SOFT_MAINTANCE_TERM         = wf.getValue("SOFT_MAINTANCE_TERM",0);
        CREATE_TYPE                 = wf.getValue("CREATE_TYPE",0);
        CREATE_TYPE_TEXT			= wf.getValue("CREATE_TYPE_TEXT",0);
        //CUST_CODE                     = wf.getValue("CUST_CODE",0);
        CUST_NAME                   = wf.getValue("CUST_NAME",0);
        ADD_DATE_VIEW               = wf.getValue("ADD_DATE_VIEW",0);
        CONTRACT_HOPE_DAY_VIEW      = wf.getValue("CONTRACT_HOPE_DAY_VIEW",0);
        RETURN_HOPE_DAY_VIEW        = wf.getValue("RETURN_HOPE_DAY_VIEW",0);
        BSART                       = wf.getValue("BSART",0);
        WBS                         = wf.getValue("WBS",0);
        WBS_NO                      = wf.getValue("WBS_NO",0);
        WBS_SUB_NO                  = wf.getValue("WBS_SUB_NO",0);
        WBS_TXT                     = wf.getValue("WBS_TXT",0);
        PR_TOT_AMT					= wf.getValue("PR_TOT_AMT",0);
    }

    //LISTBOX VALUE

    
    String LB_PR_TYPE       = ListBox(request, "SL0018",  HOUSE_CODE+"#M138#", PR_TYPE);
    String LB_SALES_TYPE = "";
    
    if(PR_TYPE.equals("I")){
      LB_SALES_TYPE     = ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", SALES_TYPE);
    }
    else{
      LB_SALES_TYPE     = ListBox(request, "SL0018",  HOUSE_CODE+"#M372#", SALES_TYPE);
    }
    String LB_HARD_MAINTANCE_TERM = "";//ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", HARD_MAINTANCE_TERM);
    String LB_SOFT_MAINTANCE_TERM = "";//ListBox(request, "SL0018",  HOUSE_CODE+"#M165#", SOFT_MAINTANCE_TERM);
    String LB_CREATE_TYPE = ListBox(request, "SL9997",  HOUSE_CODE+"#M113#B#", CREATE_TYPE);
    String LB_BSART = "";//ListBox(request, "SL0018",  HOUSE_CODE+"#M371#", BSART);
    
    SepoaListBox LB = new SepoaListBox();
%>

<html>
    <head>
	<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/script/catalog/catalog.js" type="text/javascript"></script>
<Script language="javascript" type="text/javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.ebd.ebd_bd_ins4_main";
var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
var G_SAVE_STATUS  = "T";
var G_CUR_ROW;//팝업 관련해서 씀..
var G_PR_NO        = "<%=PR_NO%>";
var summaryCnt  = 0;

var INDEX_SELECTED;
var INDEX_ITEM_NO;
var INDEX_DESCRIPTION_LOC;
var INDEX_UNIT_MEASURE;
var INDEX_PR_QTY;
var INDEX_CUR;
var INDEX_UNIT_PRICE;
var INDEX_RD_DATE;
var INDEX_PR_AMT;
var INDEX_ATTACH_NO;
var INDEX_REC_VENDOR_CODE   ;
var INDEX_REC_VENDOR_NAME   ;
var INDEX_REMARK;
var INDEX_DELY_TO_LOCATION  ;
var INDEX_PURCHASE_LOCATION ;
var INDEX_PURCHASER_ID      ;
var INDEX_PURCHASER_NAME    ;
var INDEX_PURCHASE_DEPT_NAME;
var INDEX_PURCHASE_DEPT     ;
var INDEX_WBS_NO            ;
var INDEX_WBS_SUB_NO        ;
var INDEX_WBS_TXT           ;

function init(){
	setGridDraw();
    setHeader_1();
    orderChange('<%=SALES_TYPE%>');
}

function init_1(){}

function setHeader_1(){
    var wise = GridObj;

    INDEX_SELECTED              = GridObj.GetColHDIndex("SELECTED");
    INDEX_ITEM_NO               = GridObj.GetColHDIndex("ITEM_NO");
    INDEX_DESCRIPTION_LOC       = GridObj.GetColHDIndex("DESCRIPTION_LOC");
    INDEX_UNIT_MEASURE          = GridObj.GetColHDIndex("UNIT_MEASURE");
    INDEX_PR_QTY                = GridObj.GetColHDIndex("PR_QTY");
    INDEX_CUR                   = GridObj.GetColHDIndex("CUR");
    INDEX_UNIT_PRICE            = GridObj.GetColHDIndex("UNIT_PRICE");

    INDEX_RD_DATE               = GridObj.GetColHDIndex("RD_DATE");
    INDEX_PR_AMT                = GridObj.GetColHDIndex("PR_AMT");
    INDEX_REC_VENDOR_CODE       = GridObj.GetColHDIndex("REC_VENDOR_CODE");
    INDEX_REC_VENDOR_NAME       = GridObj.GetColHDIndex("REC_VENDOR_NAME");
    INDEX_ATTACH_NO             = GridObj.GetColHDIndex("ATTACH_NO");
    INDEX_REMARK                = GridObj.GetColHDIndex("REMARK");
    INDEX_PURCHASE_LOCATION     = GridObj.GetColHDIndex("PURCHASE_LOCATION");
    INDEX_PURCHASER_ID          = GridObj.GetColHDIndex("PURCHASER_ID");
    INDEX_PURCHASER_NAME        = GridObj.GetColHDIndex("PURCHASER_NAME");
    INDEX_PURCHASE_DEPT_NAME    = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME");
    INDEX_PURCHASE_DEPT         = GridObj.GetColHDIndex("PURCHASE_DEPT");
    INDEX_WBS_NO                = GridObj.GetColHDIndex("WBS_NO");
    INDEX_WBS_SUB_NO            = GridObj.GetColHDIndex("WBS_SUB_NO");
    INDEX_WBS_TXT               = GridObj.GetColHDIndex("WBS_TXT");
    INDEX_ORDER_SEQ             = GridObj.GetColHDIndex("ORDER_SEQ");

    GridObj.strHDClickAction="select";

    doSelect();
}

function doSelect(){
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getReqBidDTDisplayChange";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5){
    var wise = GridObj;
    
    var f = document.forms[0];
    
    if(msg1 == "doQuery"){
        var expect_amt = eval(f.expect_amt.value);
        
        f.expect_amt.value = add_comma(expect_amt,2);
        f.attach_count.value = "<%=ATT_COUNT%>";
        
        //if(summaryCnt == 0) {
        //    GridObj.AddSummaryBar('SUMMARY1', '합계', 'summaryall', 'sum', 'PR_QTY,PR_AMT');
        //    GridObj.SetSummaryBarColor('SUMMARY1', '0|0|0', '241|231|221');
        //    summaryCnt++;
        //}
    }

    if(msg1 == "t_imagetext") {
        var left = 30;
        var top = 30;
        var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'no';
        var width = "";
        var height = "";

    	if(msg3 == INDEX_ATTACH_NO){
        	var ATTACH_NO_VALUE = LRTrim(GD_GetCellValueIndex(GridObj,msg2, INDEX_ATTACH_NO));
            Arow = msg2;
            document.form1.attach_gubun.value = "wise";
            FileAttach('PR',ATTACH_NO_VALUE,'VI');
		}
    	else if(msg3 == INDEX_ITEM_NO) {
            var ITEM_NO = GD_GetCellValueIndex(GridObj,msg2,INDEX_ITEM_NO);
            width = 750;
            height = 550;
            var url = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+ITEM_NO+"&BUY=";
            var PoDisWin =window.open(url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
            PoDisWin.focus();
		}
    	else if(msg3 == INDEX_REC_VENDOR_NAME){
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_REC_VENDOR_CODE);
			if(vendor_code == ""){
				return;
			}
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=COMPANY_CODE%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		}
	}

}

function AttachView(){
    var attach_no = document.form1.attach_no.value;
    FileAttach('PR',attach_no,'VI');
}
/*
    파일첨부 팝업에서 받아오는 화면
*/
function setAttach(attach_key, arrAttrach, attach_count){
    var f = document.forms[0];
    
    f.attach_no.value = attach_key;
    f.attach_count.value = attach_count;
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
			<td align="left" class="title_page">사전지원요청 상세현황</td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="760" height="2" bgcolor="#0072bc"></td>
		</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left" class="cell_title1">&nbsp;◆ 관리정보</td>
		</tr>
	</table>

	<form name="form1" action="">
		<input type="hidden" name="sign_status" value="N"> <!-- 저장,결재를 구분하는 플래그 -->

		<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
		<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
		<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
		<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
		<input type="hidden" name="req_user_id" value="<%=info.getSession("ID")%>">
		<input type="hidden" name="doc_type" value="PR">
		<input type="hidden" name="fnc_name" value="getApproval">
		<input type="hidden" name="pr_tot_amt">
		<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
		<input type="hidden" name="attach_gubun" value="body">
		<input type="hidden" name="prNo" id="prNo" value="<%=PR_NO%>">
	
		<input type="hidden" name="att_mode"   value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		<input type="hidden" name="attach_count" value="">
		<input type="hidden" name="approval_str" value="">
		
		<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
			<tr style="display:none;">
				<td width="15%" class="se_cell_title">문서유형</td>
				<td class="c_data_1" colspan="3">
					<select name="bsart" class="inputsubmit" disabled>
						<option value="">-----</option>
					</select>
				</td>
			</tr>
			<tr style="display:none;">
				<td class="se_cell_title">구매요청구분</td>
				<td class="c_data_1" >
					<select name="sales_type" class="inputsubmit" disabled>
						<option value="">-----</option>
						<%=LB_SALES_TYPE%>
					</select>
				</td>
				<td id="t_cls01" class="c_data_1"></td>
				<td id="t_cls02" class="c_data_1">
					<div id="_div01" style="display:none;">
						<input type="text" name="order_no" size="15" maxlength="10" class="input_data2" value="" readonly>
					</div>
					<div id="_div02" style="display:none;">
						<input type="hidden" name="wbs_txt">
						<input type="text" name="wbs_no" size="15" maxlength="10" class="input_data2" value="" readonly> /
						<input type="text" name="wbs_sub_no" size="20" class="input_data2" maxlength="15" style="border:0">
					</div>
				</td>
			</tr>
			<tr style="display: none;">
				<td width="15%" class="se_cell_title">프로젝트</td>
				<td class="c_data_1" colspan="3">
					<%=WBS%>&nbsp;
				</td>
			</tr>
			<tr>
				<td width="15%"  class="se_cell_title">요청부서</td>
				<td width="35%"  class="c_data_1">
					<%=DEMAND_DEPT_NAME%>&nbsp;
				</td>
				<td width="15%"  class="se_cell_title" >요청자</td>
				<td class="c_data_1" >
					<%=ADD_USER_NAME%>&nbsp;
				</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="3"></td>
			</tr>
			<tr>
				<td align="left" class="cell_title1">&nbsp;◆ 등록정보</td>
			</tr>
		</table>
		<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
			<tr>
				<td width="15%" class="se_cell_title">사전지원요청번호</td>
				<td width="35%" class="c_data_1" >
					<%=PR_NO%>
				</td>
				<td width="15%" class="se_cell_title">요청명</td>
				<td class="c_data_1" >
					<%=SUBJECT%>
				</td>
			</tr>
			<tr>
				<td  class="se_cell_title"  style="display: none;">고객사</td>
				<td  class="c_data_1"  style="display: none;">
					<select name="pr_type" class="inputsubmit" disabled style="display:none;">
						<%=LB_PR_TYPE%>
					</select>
					<%=CUST_NAME%>
				</td>
				<td class="se_cell_title" >요청구분</td>
				<td class="c_data_1" colspan="3">
					<select name="create_type" class="inputsubmit" disabled style="display:none;">
						<%=LB_CREATE_TYPE%>
					</select>
					<%=CREATE_TYPE_TEXT%>
				</td>
			</tr>
			<tr>
				<td class="se_cell_title">요청일자</td>
				<td class="c_data_1" >
					<%=ADD_DATE_VIEW%>
				</td>
				<td class="se_cell_title">예상금액</td>
				<td class="c_data_1" >
					<input type="text" name="expect_amt" size="20" class="input_data2" value="<%=PR_TOT_AMT%>" style="border:0" >
				</td>
			</tr>
			<tr  style="display: none;">
				<td class="se_cell_title">매출계약예상일</td>
				<td class="c_data_1" colspan="3">
					<%=CONTRACT_HOPE_DAY_VIEW%>
				</td>
			</tr>
			<tr style="display:none;">
				<td class="se_cell_title">하자보증기간</td>
				<td class="c_data_1" > H/W
					<select name="hard_maintance_term" class="inputsubmit" disabled>
						<option value="" >
							<b>-----</b>
						</option>
					</select>
					&nbsp;&nbsp;&nbsp;S/W
					<select name="soft_maintance_term" class="inputsubmit" disabled>
						<option value="" >
							<b>-----</b>
						</option>
					</select>
				</td>
				<td class="se_cell_title">회신희망일</td>
				<td class="c_data_1" >
					<%=RETURN_HOPE_DAY_VIEW%>
				</td>
			</tr>
			<tr>
				<td  class="se_cell_title" >특기사항</td>
				<td  class="c_data_1" colspan="3">
					<textarea name="REMARK" class="inputsubmit" cols="85" rows="10" readonly style="width: 98%;"><%=REMARK%></textarea>
				</td>
			</tr>
			<tr>
				<td width="15%" class="se_cell_title">첨부파일</td>
				<td class="c_data_1" colspan="3" height="200">
<script language="javascript">
btn("javascript:FileAttach('FILE',$('#sign_attach_no').val(),'VI')", "파일보기");
</script>
					<input type="text" size="3" readOnly class="input_empty" value="<%=ATT_COUNT %>" name="sign_attach_no_count" id="sign_attach_no_count" />
					<input type="hidden" value="<%=ATTACH_NO %>" name="sign_attach_no" id="sign_attach_no">
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
									btn("javascript:parent.window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="PR_033_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>