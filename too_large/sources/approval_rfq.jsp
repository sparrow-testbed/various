<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_011");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_011";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
%>

<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
StringBuilder _rptAprvData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

	String house_code		= info.getSession("HOUSE_CODE");
	String company_code   	 = info.getSession("COMPANY_CODE");
	String ctrl_code      	 = info.getSession("CTRL_CODE");

	String rfq_no 			= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	String rfq_count    	= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));
	String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
	String doc_type			= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
	String doc_seq			= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));		// BID_COUNT
	String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)
	String doc_status   	= JSPUtil.nullToEmpty(request.getParameter("doc_status"));
	String sign_enable 		= JSPUtil.nullToEmpty(request.getParameter("sign_enable"));
	String attach_no 		= JSPUtil.nullToEmpty(request.getParameter("attach_no"));
	String doc_no 			= rfq_no;
	
	Object[] obj 	= {rfq_no, rfq_count};
	SepoaOut value 	= ServiceConnector.doService(info, "p1004", "CONNECTION", "getRfqHDDisplay", obj);
	SepoaOut value1	= ServiceConnector.doService(info, "p1004", "CONNECTION", "getVendorCode"  , obj);
	SepoaOut value2	= ServiceConnector.doService(info, "p1004", "CONNECTION", "getHumtCnt"  , obj);

	String ADD_DATE_VIEW         = "";
	String ADD_USER_NAME         = "";
	String SUBJECT               = "";
	String RFQ_CLOSE_DATE_VIEW   = "";
	String RFQ_CLOSE_DATE        = "";
	String RFQ_CLOSE_TIME        = "";
	String DELY_TERMS            = "";
	String DELY_TERMS_TEXT       = "";
	String PAY_TERMS             = "";
	String PAY_TERMS_TEXT        = "";
	String CUR                   = "";
	String SETTLE_TYPE           = "";
	String SETTLE_TYPE_TEXT      = "";
	String TERM_CHANGE_FLAG      = "";
	String VALID_FROM_DATE       = "";
	String VALID_TO_DATE         = "";
	String RFQ_TYPE              = "";
	String RFQ_TYPE_TEXT         = "";
	String PRICE_TYPE            = "";
	String PRICE_TYPE_TEXT       = "";
	String SHIPPING_METHOD       = "";
	String SHIPPING_METHOD_TEXT  = "";
	String USANCE_DAYS           = "";
	String DOM_EXP_FLAG          = "";
	String DOM_EXP_FLAG_TEXT     = "";
	String ARRIVAL_PORT          = "";
	String ARRIVAL_PORT_NAME     = "";
	String SHIPPER_TYPE          = "";
	String SHIPPER_TYPE_TEXT     = "";
	String REMARK                = "";
	String RQAN_CNT              = "";
	String SMS_YN                = "";
	String Z_RESULT_OPEN_FLAG    = "";
	String BID_REQ_TYPE			 = "";
	String CREATE_TYPE			 = "";
	String ATTACH_NO			 = "";
	String ATT_COUNT			 = "";

	SepoaFormater wf = new SepoaFormater(value.result[0]);
	SepoaFormater wf1 = new SepoaFormater(value1.result[0]);
	SepoaFormater wf2 = new SepoaFormater(value2.result[0]);

	int vendor_cnt = wf1==null?0:wf1.getRowCount();

	String[] VENDOR_CODE = new String[vendor_cnt];

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이타가 있는 경우

			ADD_DATE_VIEW            =  wf.getValue("ADD_DATE_VIEW       ", 0);
			ADD_USER_NAME            =  wf.getValue("ADD_USER_NAME       ", 0);
			SUBJECT                  =  wf.getValue("SUBJECT             ", 0);
			RFQ_CLOSE_DATE_VIEW      =  wf.getValue("RFQ_CLOSE_DATE_VIEW ", 0);
			RFQ_CLOSE_DATE           =  wf.getValue("RFQ_CLOSE_DATE      ", 0);
			RFQ_CLOSE_TIME           =  wf.getValue("RFQ_CLOSE_TIME      ", 0);
			DELY_TERMS               =  wf.getValue("DELY_TERMS          ", 0);
			DELY_TERMS_TEXT          =  wf.getValue("DELY_TERMS_TEXT     ", 0);
			PAY_TERMS                =  wf.getValue("PAY_TERMS           ", 0);
			PAY_TERMS_TEXT           =  wf.getValue("PAY_TERMS_TEXT      ", 0);
			CUR                      =  wf.getValue("CUR                 ", 0);
			SETTLE_TYPE              =  wf.getValue("SETTLE_TYPE         ", 0);
			SETTLE_TYPE_TEXT         =  wf.getValue("SETTLE_TYPE_TEXT    ", 0);
			TERM_CHANGE_FLAG         =  wf.getValue("TERM_CHANGE_FLAG    ", 0);
			VALID_FROM_DATE          =  wf.getValue("VALID_FROM_DATE     ", 0);
			VALID_TO_DATE            =  wf.getValue("VALID_TO_DATE       ", 0);
			RFQ_TYPE                 =  wf.getValue("RFQ_TYPE            ", 0);
			RFQ_TYPE_TEXT            =  wf.getValue("RFQ_TYPE_TEXT       ", 0);
			PRICE_TYPE               =  wf.getValue("PRICE_TYPE          ", 0);
			PRICE_TYPE_TEXT          =  wf.getValue("PRICE_TYPE_TEXT     ", 0);
			SHIPPING_METHOD          =  wf.getValue("SHIPPING_METHOD     ", 0);
			SHIPPING_METHOD_TEXT     =  wf.getValue("SHIPPING_METHOD_TEXT", 0);
			USANCE_DAYS              =  wf.getValue("USANCE_DAYS         ", 0);
			DOM_EXP_FLAG             =  wf.getValue("DOM_EXP_FLAG        ", 0);
			DOM_EXP_FLAG_TEXT        =  wf.getValue("DOM_EXP_FLAG_TEXT   ", 0);
			ARRIVAL_PORT             =  wf.getValue("ARRIVAL_PORT        ", 0);
			ARRIVAL_PORT_NAME        =  wf.getValue("ARRIVAL_PORT_NAME   ", 0);
			SHIPPER_TYPE             =  wf.getValue("SHIPPER_TYPE        ", 0);
			SHIPPER_TYPE_TEXT        =  wf.getValue("SHIPPER_TYPE_TEXT   ", 0);
			REMARK                   =  wf.getValue("REMARK              ", 0);
			RQAN_CNT                 =  wf.getValue("RQAN_CNT            ", 0);
			SMS_YN                   =  wf.getValue("Z_SMS_SEND_FLAG", 0);
			Z_RESULT_OPEN_FLAG       =  wf.getValue("Z_RESULT_OPEN_FLAG", 0);
			BID_REQ_TYPE			 =  wf.getValue("BID_REQ_TYPE", 0);
			CREATE_TYPE			 	 =  wf.getValue("CREATE_TYPE", 0);
			ATTACH_NO			 	 =  wf.getValue("ATTACH_NO", 0);
			ATT_COUNT			 	 =  wf.getValue("ATT_COUNT", 0);
		}
	}

	for(int i=0;i<vendor_cnt;i++){
		VENDOR_CODE[i] = wf1.getValue("VENDOR_CODE",i);
	}
	int wf2_cnt = wf2.getRowCount();
%>


<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>
<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<%-- 
<style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style> --%>
<Script language="javascript" type="text/javascript">
//<!--

<%-- var G_SERVLETURL = "<%=getWiseServletPath("dt.app.app_pp_dis4")%>"; --%>
var selectMode = "";

var INDEX_SELECTED			;
var INDEX_PR_NO			    ;
var INDEX_SUBJECT			;
var INDEX_ADD_USER_ID		;
var INDEX_PO_VENDOR_CODE	;
var INDEX_VENDOR_NAME		;
var INDEX_ITEM_NO			;
var INDEX_DESCRIPTION_LOC	;
var INDEX_QTY				;
var INDEX_UNIT_MEASURE		;
var INDEX_UNIT_PRICE		;
var INDEX_ITEM_AMT			;
var INDEX_S_UNIT_PRICE		;
var INDEX_S_ITEM_AMT		;
var INDEX_SALE_PER_1		;
var INDEX_SALE_PER_2		;
var INDEX_PR_UNIT_PRICE	    ;
var INDEX_PR_AMT			;
var INDEX_RD_DATE			;
var INDEX_PAY_TERMS		    ;
var INDEX_CONTRACT_FLAG	    ;
var INDEX_INSURANCE		    ;
var INDEX_VALID_FROM_DATE	;
var INDEX_VALID_TO_DATE		;
var INDEX_PAY_TERMS_HD_DESC ;
var INDEX_SALE_AMT			;
var INDEX_SOURCING_NO		;
var INDEX_QTA_NO		;

function init()
{
	setHeader_1();
}


function setHeader_1()
{
    var wise = GridObj;

	GridObj.SetNumberFormat("PR_QTY",		G_format_qty);
	GridObj.SetNumberFormat("UNIT_PRICE",	G_format_unit);
	GridObj.SetNumberFormat("PR_AMT",		G_format_amt);
	GridObj.SetColCellSortEnable("PR_AMT",	false);
	GridObj.SetNumberFormat("EXCHANGE_RATE",	G_format_unit);
	GridObj.SetNumberFormat("PR_KRW_AMT",		G_format_amt);
	GridObj.SetDateFormat("RD_DATE",		"yyyy/MM/dd");
	GridObj.SetColCellSortEnable("DELY_TO_ADDRESS",false);
	GridObj.SetDateFormat("INPUT_TO_DATE",		"yyyy/MM/dd");


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


function doSelect()
{
	var wise = GridObj;
	GridObj.SetParam("mode", "prDTQueryDisplay");
    GridObj.SetParam("pr_no", "<%=doc_no%>");
    GridObj.SetParam("pr_proceeding_flag", "");
    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	<%-- GridObj.SendData("<%=getWiseServletPath("dt.pr.pr1_bd_dis1")%>"); --%>
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var wise = GridObj;
	var f = document.forms[0];

	if(msg1 == "t_insert")
	{
		if(msg3 == INDEX_PR_QTY)
		{
			calculate_pr_amt(wise, msg2);
		}
		if(msg3 == INDEX_UNIT_PRICE)
		{
			calculate_pr_amt(wise, msg2);
		}
	}

	if(msg1 == "t_imagetext")
	{
		var toolbar = 'no';
        var menubar = 'no';
        var status = 'yes';
        var scrollbars = 'yes';
        var resizable = 'no';
		G_CUR_ROW = msg2;

		if(msg3 == INDEX_ATTACH_NO)
		{
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
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		}

	}


	if(msg1 == "doData")
	{
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);

		if(mode == "setPrChange")
		{
			alert(GridObj.GetMessage());
			if(status != "0")
			{
				GridObj.RemoveAllData();
				window.href = "/kr/dt/pr/pr1_bd_lis1.jsp";
			}
		}
		else if(mode == "deletePrdt")
		{
			alert(GridObj.GetMessage());
			doSelect();
		}
	}

	if(msg1 == "doQuery")
	{
		//if(document.form1.shipper_type.value == "O"){
		//	GridObj.SetColHide("EXCHANGE_RATE", false);
	    // 	GridObj.SetColHide("PR_KRW_AMT", false);
	    //}

		//document.form1.sales_amt.value = add_comma(document.form1.sales_amt.value,0);
	}
}

function getFormatDate(v_date){
	return v_date.substring(0,4)+"/"+v_date.substring(4,6)+"/"+v_date.substring(6);
}

function checkData()
{
	var wise = GridObj;
	var f = document.forms[0];
	var iRowCount = wise.getRowCount();

	for(var i=0;i<iRowCount;i++) {
	}
}


function Add_file(){
	var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
	FileAttach('APP',ATTACH_NO_VALUE,'VI');

}

/*
	파일첨부 팝업에서 받아오는 화면
*/
function setAttach(attach_key, arrAttrach, attach_count)
{
	var f = document.forms[0];
    f.attach_no.value = attach_key;
    f.attach_count.value = attach_count;
}
function searchProfile(fc)
{

	if (fc == 'pay_method' ){
	}
    if(fc == "jt_dp_pay_terms") {
	}

	Code_Search(url,'','','','','');
}

function getpay_method(code, text2)
{
	document.forms[0].ADD_PAY_TERMS.value = code;
	document.forms[0].ADD_PAY_TEXT.value = text2;
}
//구매담당
function SP0216_Popup()
{
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0216&function=SP0216_getCode&values=<%=info.getSession("HOUSE_CODE")%>&values=<%=info.getSession("COMPANY_CODE")%>&values=&values=";
	var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function SP0216_getCode(ls_ctrl_code, ls_ctrl_name)
{
	document.forms[0].ctrl_code.value = ls_ctrl_code;
	document.forms[0].user_name.value = ls_ctrl_name;
}
function openDPinfo(dp_div){
	var wise 		= GridObj;
    var item_amt 	= 0;
    var dp_type 	= ""//wise.GetCellValue("PAY_TERMS_HD"		,0);
	var rowCount 	= wise.getRowCount();
	var cur = "";
	var S_item_cnt = 0;	// 용역품목수
	var S_item_amt = 0; // 용역공급가액 합
	var I_item_cnt = 0;	// 물품품목수
	var I_item_amt = 0; // 물품공급가액 합
	var S_dp_type  = "";
	var I_dp_type  = "";
	var no_item_code_cnt = 0; // 품목코드가 없는 아이템 수

	var default_amt = 0;

	var sub_item = "";
	for( i = 0 ; i < rowCount ; i++ ){
		item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i));
		cur 	  	= wise.GetCellValue("CUR",i);
		if(wise.GetCellValue("ITEM_NO",i) == ""){
			no_item_code_cnt++;
			continue;
		}
		sub_item	= wise.GetCellValue("ITEM_GBN",i);
		if(sub_item == "I" || sub_item == "S" ){
			I_item_cnt++;
			I_item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i) == "" ? "0" : wise.GetCellValue("ITEM_AMT",i));
			for(var k=0; k<GridObj2.GetRowCount(); k++){
				if(GridObj2.GetCellValue("DP_DIV", k) == "I"){
					I_dp_type = GridObj2.GetCellValue("DP_TYPE", k);
					break;
				}
			}
		}else {
			S_item_cnt++;
			S_item_amt += parseInt(wise.GetCellValue("ITEM_AMT",i) == "" ? "0" : wise.GetCellValue("ITEM_AMT",i));
			for(var k=0; k<GridObj2.GetRowCount(); k++){
				if(GridObj2.GetCellValue("DP_DIV", k) == "S"){
					S_dp_type = GridObj2.GetCellValue("DP_TYPE", k);
					break;
				}

			}
		}
	}

	if(no_item_code_cnt == 0){
		if(dp_div == "S" && S_item_cnt ==0){
			alert("용역품목이 없습니다.");
			return;
		}

		if(dp_div == "I" && I_item_cnt ==0){
			alert("물품품목이 없습니다.");
			return;
		}
	}




	// 용역대금지불금액(S) + 	장비대금지불(I) = 품의금액
	var I_amt = 0;
	var S_amt = 0;
	for(var i = 0; i < GridObj2.GetRowCount(); i++){
		if(GridObj2.GetCellValue("DP_DIV", i) == "I"){
			I_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
		}else if(GridObj2.GetCellValue("DP_DIV", i) == "S"){
			S_amt += parseFloat(GridObj2.GetCellValue("DP_AMT", i));
		}
	}


	dp_type = dp_div == "I" ? I_dp_type :  S_dp_type;

    url = "/kr/dt/app/app_pp_ins3.jsp?exec_amt="+item_amt+"&dp_type="+dp_type+"&cur="+cur+"&dp_div="+dp_div+"&mode=popup";
    window.open(url,"app_pp_ins2","left=0,top=0,width=800,height=500,resizable=yes,scrollbars=yes");
}
function valid_from_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_from_date.value=year+month+day;
}
function valid_to_date(year,month,day,week) {
	var f0 = document.forms[0];
	f0.valid_to_date.value=year+month+day;
}
function changeContract(){
	var contract_flag = document.forms[0].contract_flag.value;
	var rowCount = GridObj.GetRowCount();
	for( i = 0 ; i < rowCount ; i++ )
		GridObj.SetComboSelectedHiddenValue("CONTRACT_FLAG", i, contract_flag);
}
function RFQComparison(){
	/*

	var rfq_no = "";
		var t_rowCount = GridObj.GetRowCount();
	for( i = 0 ; i < t_rowCount ; i++){
		if(rfq_no == ""){
			rfq_no = GridObj.GetCellValue("RFQ_NO",0);
		}
	}
	if(rfq_no == "" || rfq_no.substring(0,2) != "RQ"){
		alert("견적번호가 없습니다.");
		return;
	}
	var rfq_count = "1";
	*/
	var so_no 		= GridObj.GetCellValue("SOURCING_NO",0);
	var so_count 	= GridObj.GetCellValue("SOURCING_COUNT",0);
	var type 		= GridObj.GetCellValue("SOURCING_TYPE",0);
	var so_vote_count 	= GridObj.GetCellValue("SOURCING_VOTE_COUNT",0);
	var so_ann_flag 	= GridObj.GetCellValue("SOURCING_ANNOUNCE_FLAG",0);
	if(so_no == ""){
		alert("종가발주는 소싱비교가 존재하지 않습니다.");
		return;
	}


	//type  입찰 : BID   견적 RFQ  역경매 RAT
	childFrame.location.href = "/report/iReportPrint.jsp?flag=COM&so_no="+so_no+"&house_code=<%=house_code%>&type="+type+"&so_count="+so_count+"&vote_count="+so_vote_count+"&so_ann_flag="+so_ann_flag;
	//window.open("/kr/dt/rfq/ebd_bd_dis5.jsp?rfq_no="+rfq_no,"RFQComparison","left=0,top=0,width=1020,height=400,resizable=yes,scrollbars=yes,status=yes");
}


function goPrPage(){
	var img_pr_no = document.forms[0].pr_no.value;
    window.open("/kr/dt/pr/pr1_bd_dis1.jsp?pr_no="+img_pr_no,"pr1_bd_dis1","left=0,top=0,width=900,height=700,resizable=yes,scrollbars=yes");
}


function download(url)
{
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
	} else if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

	function openSCMSProject(PJT_CODE, CON_NO, CON_DGR, CUST_CODE){
		<%-- <%
			Configuration conf = new Configuration();
			String scmsUrl = conf.get("wise.scms.url");
		%>
		var vURL = "<%=scmsUrl%>/iFrame?Class=com.ibks.mn.SCMPjtDetail&PAGE_NAME=CONSULT_DETAIL&PJT_CODE=" + PJT_CODE + "&CON_NO=" + CON_NO + "&CON_DGR=" + CON_DGR + "&CUST_CODE=" + CUST_CODE;
  		window.open (vURL , "SCMSPjt", "left=0, top=0,width=900,height=600, toolbar=no, menubar=no, status=no, scrollbars=no, resizable=no"); --%>
	}

	function openPreExec() {
		var pre_exec_no = document.forms[0].pre_exec_no.value;
		if (pre_exec_no == "") return;

        var ex_url = "/kr/dt/app/app_pp_dis4_approval.jsp?exec_no="+pre_exec_no+"&doc_status=N&doc_no="+pre_exec_no+"&doc_type=EX&doc_seq=0&sign_enable=&attach_no=&sign_path_seq="
        window.open(ex_url ,"preExec","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1024,height=768,left=20,top=0");
	}

	// 결재선변경
	function changeApprovalLine(doc_type ,doc_no ,doc_seq, sign_path_seq){
		if("<%=proceeding_flag%>" != "P"){
			alert("결재선추가는 결재자만 가능합니다.");
			return;
		}
		CodeSearchCommon("/kr/admin/basic/approval2/ap2_pp_upd3.jsp?doc_type="+doc_type+"&doc_no="+doc_no+"&doc_seq="+doc_seq+ "&sign_path_seq="+sign_path_seq+"&issue_type=&fnc_name=getApproval","pop_up","","","700","320");
	}

//-->
</Script>



<body>
<form name="form1" method="post">
	<input type="hidden" name="attach_gubun" value="body">

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr><td  height="20"></td></tr>
   <tr><td align="center" class="style1"><b>견 적 요 청</b></td></tr>
   <tr><td  height="20">&nbsp;</td></tr>
</table>    

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
  <td width="1%" valign="top" ></td>
    <td width="50%" valign="top" ><table width="90%" height="92" border="0" cellpadding="0" cellspacing="0">
	  <tr>
        <td class="title">견&nbsp;&nbsp;&nbsp;&nbsp;적&nbsp;&nbsp;&nbsp;&nbsp;번&nbsp;&nbsp;&nbsp;&nbsp;호&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=rfq_no%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">요&nbsp;&nbsp;&nbsp;&nbsp;청&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ADD_DATE_VIEW%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">요&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;청&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=ADD_USER_NAME%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>            
      <tr>
        <td class="title">견&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;적&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp<%=SUBJECT%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
    </table></td>
    <td width="50%" colspan="2" align="right" ><table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      <tr bgcolor="#FFFFFF">
        <td width="32" align="center" bgcolor="#CCCCCC" class="title1" >결<br>
          재</td>
		<%  	
		    Object[] obj_sign = {doc_no,doc_type};
			SepoaOut value_sign = ServiceConnector.doService(info,"p6029","CONNECTION","getSignPath",obj_sign);
			SepoaFormater wf_sign = new SepoaFormater(value_sign.result[0]);
		 	String POSITION_TEXT = "";
		 	String USER_NAME_LOC = "";
		 	String SIGN_DATE = "";
		 	String SIGN_TIME = "";
		 	String APP_STATUS = ""; 
		 	
		 	int approvalCnt = wf_sign.getRowCount();   //결재라인수

		    for(int i = 0 ; i< wf_sign.getRowCount() ; i++)
			{
		    	POSITION_TEXT =	wf_sign.getValue("POSITION_TEXT", i);
				USER_NAME_LOC =	wf_sign.getValue("USER_NAME_LOC", i);
				SIGN_DATE =	wf_sign.getValue("SIGN_DATE", i);
				SIGN_TIME =	wf_sign.getValue("SIGN_TIME", i);
				APP_STATUS = wf_sign.getValue("APP_STATUS", i);		
				  
		%>
        <td width="90"><table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td height="20" class="data_td_c" align="center"><%=USER_NAME_LOC%></td>
            </tr>
            <tr>
              <td height="1" bgcolor="#000000"></td>
            </tr>
            <tr>
              <td height="40" align="center">
    	<%
       		if(APP_STATUS.equals("A")) { //기안
    	%>
              				기 안<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_2.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("E")) { // 승인 %>
              				승 인<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_1.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else if(APP_STATUS.equals("R")) { // 반려%>
              				반 려<%--<img src="/images/<%=info.getSession("HOUSE_CODE")%>/stamp_3.gif" height="35" border="0" align="absmiddle">--%>
    	<% }else { %>
              &nbsp;
    	<% } %>
              </td>
            </tr>
            <tr>
              <td height="1" bgcolor="#000000"></td>
            </tr>
            <tr>
              <td height="20" class="data_td_c" align="center"><%=SIGN_DATE%></td>
            </tr>
        </table></td>
<%    } %>                
      </tr>
    </table></td>
  </tr>
</table>
<br>
<%
POSITION_TEXT = "";
USER_NAME_LOC = "";
SIGN_DATE     = "";
SIGN_TIME     = "";
APP_STATUS    = "";	
//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
_rptAprvData.append("견 적 요 청");

_rptAprvData.append(_RD);

_rptAprvData.append("견적번호");
_rptAprvData.append(_RF);
_rptAprvData.append(rfq_no);
_rptAprvData.append(_RL);
_rptAprvData.append("요청일자");
_rptAprvData.append(_RF);
_rptAprvData.append(ADD_DATE_VIEW);
_rptAprvData.append(_RL);
_rptAprvData.append("요 청 자");
_rptAprvData.append(_RF);
_rptAprvData.append(ADD_USER_NAME);
_rptAprvData.append(_RL);
_rptAprvData.append("견 적 명");
_rptAprvData.append(_RF);
_rptAprvData.append(SUBJECT);

_rptAprvData.append(_RD);	
for(int i = 0 ; i<wf_sign.getRowCount(); i++) {
	POSITION_TEXT =	wf_sign.getValue("POSITION_TEXT", i);
	USER_NAME_LOC =	wf_sign.getValue("USER_NAME_LOC", i);
	SIGN_DATE =	wf_sign.getValue("SIGN_DATE", i);
	SIGN_TIME =	wf_sign.getValue("SIGN_TIME", i);
	APP_STATUS = wf_sign.getValue("APP_STATUS", i);		
	
	_rptAprvData.append(USER_NAME_LOC);
	_rptAprvData.append(_RF);
	if(APP_STATUS.equals("A")){
		_rptAprvData.append("기 안");	
	}else if(APP_STATUS.equals("E")){
		_rptAprvData.append("승 인");
	}else if(APP_STATUS.equals("R")){
		_rptAprvData.append("반 려");
	}
	_rptAprvData.append(_RF);
	_rptAprvData.append(SIGN_DATE);
	_rptAprvData.append(_RL);
}//end of for
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
%> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="35" align="right">
				<TABLE cellpadding="0">
		      		<TR>
		      		<% if ("Y".equals(doc_status)) { %>
		      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=rfq_no%>','<%=rfq_count%>')","승 인")</script></TD>
		      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=rfq_no%>','<%=rfq_count%>')","반 려")</script></TD>
<%-- 		      			<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')","결재선추가")</script></TD> --%>
		      		<% } %>
    					<TD><script language="javascript">btn("javascript:rfqFrm.clipPrint('<%=_rptAprvData.toString().replaceAll("\"", "&quot")%>',<%=approvalCnt%>);","출 력")</script></TD>
						<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>
</form>
<iframe id="rfqFrm" name="rfqFrm" src="/kr/dt/rfq/rfq_bd_dis11.jsp?rfq_no=<%=rfq_no%>&rfq_count=<%=rfq_count %>&screen_flag=search&popup_flag=true" style="width: 98%;height: 600px; border: 0px;" frameborder="0" scrolling="yes"></iframe>
</body>
</html>
<s:footer/>


