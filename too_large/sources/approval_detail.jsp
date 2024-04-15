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

	String house_code   	= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String ID           	= info.getSession("ID");
	String DEPARTMENT   	= info.getSession("DEPARTMENT");
	String CTRL_CODE		= info.getSession("CTRL_CODE");
    String doc_type			= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
    String doc_no			= JSPUtil.nullToEmpty(request.getParameter("doc_no"));
	String doc_seq			= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));		// BID_COUNT
	String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
	String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)
    String doc_status   	= JSPUtil.nullToEmpty(request.getParameter("doc_status"));
	String sign_enable 		= JSPUtil.nullToEmpty(request.getParameter("sign_enable"));
	String attach_no 		= JSPUtil.nullToEmpty(request.getParameter("attach_no"));

	String PR_NO          = JSPUtil.nullToEmpty(request.getParameter("doc_no"));

    String USER_ID        = info.getSession("ID");
    String HOUSE_CODE     = info.getSession("HOUSE_CODE") ;

    String subject            	= JSPUtil.nullToEmpty(request.getParameter("subject"));
    String ORDER_NO           	= "";
    String ORDER_COUNT			= "";
    String ORDER_NAME         	= "";
    String RECEIVE_TERM       	= "";
    String add_date        = JSPUtil.nullToEmpty(request.getParameter("add_date"));
    String DEMAND_DEPT_NAME   	= "";
    String DEMAND_DEPT        	= "";
    String add_user_name      	= JSPUtil.nullToEmpty(request.getParameter("add_user_name"));
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
    String EXPECT_AMT			= "";
	String REQ_TYPE				= "";
	String wbs		= "";
	String wbs_name		= "";
	String PROCEEDING_FLAG = "";

   /*  String[] args = {PR_NO };
    WiseOut value = ServiceConnector.doService(info, "p1001", "CONNECTION","prHDQueryDisplay", args);

    WiseFormater wf = new WiseFormater(value.result[0]);
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
        EXPECT_AMT				= wf.getValue("EXPECT_AMT",0);
        REQ_TYPE				= wf.getValue("REQ_TYPE",0);
        wbs						= wf.getValue("WBS",0);
        wbs_name				= wf.getValue("WBS_NAME",0);
        PROCEEDING_FLAG			= wf.getValue("PROCEEDING_FLAG",0);
        
    } */
%>


<html>
<head>

<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
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

var pr_type = "<%=PR_TYPE%>";
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
//	orderChange('<%=SALES_TYPE%>');
}


function setHeader_1()
{
    var wise = GridObj;


    <%if(PR_TYPE.equals("I")){%>



    <% }else { %>
 
    


    <%}%>



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
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=COMPANY_CODE%>&vendor_code="+vendor_code+"&user_type=<%=info.getSession("COMPANY_CODE")%>","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
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
	<input type="hidden" name="CONTRACT_DEPOSIT">
	<input type="hidden" name="MENGEL_DEPOSIT">
	<input type="hidden" name="dp_remark">

  
   
     <%
       		if(doc_type.equals("PR")) { //기안
    %>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		구 매 요 청 품 의
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="29%" valign="top" >
    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
	  <tr>
        <td class="title">구&nbsp;매&nbsp;요&nbsp;청&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">의&nbsp;&nbsp;&nbsp;&nbsp;뢰&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">의&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;뢰&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">구&nbsp;&nbsp;매&nbsp;&nbsp;의&nbsp;&nbsp;뢰&nbsp;&nbsp;명&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
    </table>
    </td>
    
     <%
       	} else if(doc_type.equals("EX")) { //기안
    %>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		구 매 기 안
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
   </table>
     <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="29%" valign="top" >
    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
	  <tr>
        <td class="title">기&nbsp;안&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
    </table>
    </td>
    <%
       	} else if(doc_type.equals("BID")) { //기안
    %>
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		입 찰 공 고 
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
    <td width="29%" valign="top" >
    	<table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
	  		<tr>
        		<td class="title">공&nbsp;고&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">공&nbsp;고&nbsp;일&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">공&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title">입&nbsp;찰&nbsp;건&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
    	</table>
    	</td>
    
    	 <%
       			} else if(doc_type.equals("RA")){
   		 %>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
   		   <tr>
		     <td  height="20"></td>
		   </tr>
		   <tr>
		     <td align="center" class="style1">
				역 경 매 공 고 
		     </td>
		   </tr>
		   <tr>
		     <td  height="20">&nbsp;</td>
		  </tr>
		  </table>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
		  <tr>
		    <td width="29%" valign="top" >
		    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
			  <tr>
		        <td class="title">공&nbsp;고&nbsp;번&nbsp;호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">공&nbsp;고&nbsp;일&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">역&nbsp;경&nbsp;매&nbsp;건&nbsp;명&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">공&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		  </table>
		  </td>
   		 
   		 <%
       			} else if(doc_type.equals("CT")){
   		 %>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
   		   <tr>
		     <td  height="20"></td>
		   </tr>
		   <tr>
		     <td align="center" class="style1">
				계 약 기 안
		     </td>
		   </tr>
		   <tr>
		     <td  height="20">&nbsp;</td>
		  </tr>
		     </table>			 	
   		 	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			  <tr>
			    <td width="29%" valign="top" >
			    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
				  <tr>
			        <td class="title">기&nbsp;안&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			      <tr>
			        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			      <tr>
			        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			      <tr>
			        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			    </table> 
			    </td> 		 
   		 <%
       			} else if(doc_type.equals("POD")){
   		 %>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
   		   <tr>
		     <td  height="20"></td>
		   </tr>
		   <tr>
		     <td align="center" class="style1">
				발 주 기 안
		     </td>
		   </tr>
		   <tr>
		     <td  height="20">&nbsp;</td>
		  </tr>
		   </table>  		 
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
	  <tr>
	    <td width="29%" valign="top" >
	    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
		  <tr>
	        <td class="title">기&nbsp;안&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
	      </tr>
	      <tr>
	        <td height="1" bgcolor="#000000"></td>
	      </tr>
	      <tr>
	        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
	      </tr>
	      <tr>
	        <td height="1" bgcolor="#000000"></td>
	      </tr>
	      <tr>
	        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
	      </tr>
	      <tr>
	        <td height="1" bgcolor="#000000"></td>
	      </tr>
	      <tr>
	        <td class="title">기&nbsp;&nbsp;&nbsp;안&nbsp;&nbsp;&nbsp;&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
	      </tr>
	      <tr>
	        <td height="1" bgcolor="#000000"></td>
	      </tr>
	    </table>
	    	   
        </td>
   		 <%
       			} else if(doc_type.equals("INV")){
   		 %>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		     <td  height="20"></td>
		   </tr>
		   <tr>
		     <td align="center" class="style1">
				검 수 요 청 품 의
		     </td>
		   </tr>
		   <tr>
		     <td  height="20">&nbsp;</td>
		  </tr>   		 
   		 </table>
   		 <table width="100%" border="0" cellspacing="0" cellpadding="0" >
		  <tr>
		    <td width="29%" valign="top" >
		    <table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
			  <tr>
		        <td class="title">검&nbsp;수&nbsp;요&nbsp;청&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">상&nbsp;&nbsp;&nbsp;&nbsp;신&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      <tr>
		        <td class="title">검&nbsp;&nbsp;수&nbsp;&nbsp;요&nbsp;&nbsp;청&nbsp;&nbsp;명&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
		      </tr>
		      <tr>
		        <td height="1" bgcolor="#000000"></td>
		      </tr>
		      	    </table>
        </td>
		       <%
       			} else if(doc_type.equals("TAX")){
   			   %>
   			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
   			   <tr>
				     <td  height="20"></td>
				   </tr>
				   <tr>
				     <td align="center" class="style1">
						세 금 계 산 서
				     </td>
				   </tr>
				   <tr>
				     <td  height="20">&nbsp;</td>
				  </tr>  
				  </table>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
		  		<tr>
				  <td width="29%" valign="top" >
		     	<table width="40%" height="92" border="0" cellpadding="0" cellspacing="0">
				  <tr>
			        <td class="title">세&nbsp;&nbsp;금&nbsp;&nbsp;계&nbsp;&nbsp;산&nbsp;&nbsp;서&nbsp;&nbsp;번&nbsp;&nbsp;호&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no %></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			      <tr>
			        <td class="title">발&nbsp;&nbsp;&nbsp;&nbsp;급&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			      <tr>
			        <td class="title">발&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;급&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
			      </tr>
			      <tr>
			        <td height="1" bgcolor="#000000"></td>
			      </tr>
			    </table>
			 
        </td>
       		   <%
       			} else if(doc_type.equals("VM")){
   			   %>
   		 	  	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   			   <tr>
				     <td  height="20"></td>
				   </tr>
				   <tr>
				     <td align="center" class="style1">
						신규협력업체 등록품의
				     </td>
				   </tr>
				   <tr>
				     <td  height="20">&nbsp;</td>
				  </tr>  
				  </table>
   		 	  <%
       				} 
   		 	  %>
		    
    <td width="*" colspan="2" align="right" >
<!-- 결재라인 시작 -->
    	<table border="1" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      		<tr bgcolor="#FFFFFF">
        		<td width="32" align="center" bgcolor="#CCCCCC" class="c_title_1" >결<br>재</td>
<%
    Object[] obj_sign = {doc_no,doc_type,doc_seq};	//기안자 + 결재자
    SepoaOut value_sign = ServiceConnector.doService(info,"AP_001","CONNECTION","getSignPath",obj_sign);
    SepoaFormater wf_sign = new SepoaFormater(value_sign.result[0]);

    Object[] obj_agree = {doc_no,doc_type,doc_seq}; //합의자
    SepoaOut value_agree = ServiceConnector.doService(info,"AP_001","CONNECTION","getSignAgree",obj_agree);
    SepoaFormater wf_agree = new SepoaFormater(value_agree.result[0]);

    int approvalCnt = wf_sign.getRowCount()-wf_agree.getRowCount() > 0 ?  wf_sign.getRowCount() : wf_sign.getRowCount()-wf_agree.getRowCount() == 0 ? wf_sign.getRowCount() :  wf_agree.getRowCount();   //결재라인수

 	String app_attach_no = "";
 	String POSITION_TEXT = "";
 	String USER_NAME_LOC = "";
 	String SIGN_DATE     = "";
 	String SIGN_TIME     = "";
 	String APP_STATUS    = "";

    for(int i = 0 ; i<approvalCnt; i++) {
		if (i == 0) {
			app_attach_no = wf_sign.getValue("ATTACH_NO"		, i);
		}

		if(i < wf_sign.getRowCount()){
			POSITION_TEXT 	=	wf_sign.getValue("POSITION_TEXT"		, i);
			USER_NAME_LOC 	=	wf_sign.getValue("USER_NAME_LOC"		, i);
			SIGN_DATE 	    =	wf_sign.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_sign.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_sign.getValue("APP_STATUS"			, i);

%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=USER_NAME_LOC%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
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
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	  <tr bgcolor="#FFFFFF" style="display:none">
      	<td width="32" align="center" bgcolor="#CCCCCC" class="c_title_1" >합<br>의</td>
<%

 	POSITION_TEXT = "";
 	USER_NAME_LOC = "";
 	SIGN_DATE = "";
 	SIGN_TIME = "";
 	APP_STATUS = "";

    for(int i = 0 ; i<approvalCnt; i++)
	{
		if(i < wf_agree.getRowCount()){
			POSITION_TEXT 	=	wf_agree.getValue("POSITION_TEXT"			, i);
			USER_NAME_LOC 	=	wf_agree.getValue("USER_NAME_LOC"			, i);
			SIGN_DATE 	    =	wf_agree.getValue("SIGN_DATE"			, i);
			SIGN_TIME 	    =	wf_agree.getValue("SIGN_TIME"			, i);
			APP_STATUS 	    =	wf_agree.getValue("APP_STATUS"			, i);

%>
	        <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center"><%=POSITION_TEXT%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">
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
              			<td height="20" class="input_data2" align="center"><%=SIGN_DATE%></td>
            		</tr>
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="input_data2" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="input_data2" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
	</table>
<!-- 결재라인 끝-->
</td>
</tr>
</table>

<%-- <br>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">

</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
	<input type="hidden" name="attach_no" value="<%=ATTACH_NO%>">
	<input type="hidden" name="bsart" value="<%=BSART%>">			문서유형
	<input type="hidden" name="sales_type" value="<%=SALES_TYPE%>">	구매요청구분
	<input type="hidden" name="order_no" value="<%=ORDER_NO%>">		수주번호
	<input type="hidden" name="wbs_no" value="<%=WBS_NO%>">			프로젝트번호
	<input type="hidden" name="wbs_txt" value="<%=WBS_TXT%>">
	<input type="hidden" name="wbs_sub_no" value="<%=WBS_SUB_NO%>">

	<input type="hidden" name="att_mode"   value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">
	<input type="hidden" name="attach_count" value="">
	<input type="hidden" name="approval_str" value="">

<tr style="display: none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;프로젝트</td>
    <td width="35%" class="c_data_1_p" colspan="3">
    <input type="text" style="width:98%;" class="input_data2" value="<%=WBS_NO + " / " + WBS_NAME%>" onClick="javascript:openSCMS('project', '<%=WBS_NO%>')" readOnly>
    <!-- <a href="javascript:openSCMSProject('<%=WBS_NO%>', '<%=ORDER_NO%>', '<%=ORDER_COUNT%>', '<%=CUST_CODE%>')" style="text-decoration:none;"><%=WBS_NO%> / <%=WBS_NAME%></a> -->
    <input type="text" name="" value="<%=WBS_NO%> / <%=WBS_NAME%>" style="width:100%;color:#0000ff;cursor:;" class="input_data2" readOnly onClick="openSCMSProject('<%=WBS_NO%>', '<%=ORDER_NO%>', '<%=ORDER_COUNT%>', '<%=CUST_CODE%>')">
    </td>
</tr>

<tr>
	<td id="t_cls01" class="c_data_1_p"></td>
	<td id="t_cls02" class="c_data_1_p">
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

<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;요청부서</td>
	<td width="35%" class="c_data_1_p" ><%=DEMAND_DEPT_NAME%></td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;요청자</td>
	<td width="35%" class="c_data_1_p" ><%=ADD_USER_NAME%></td>
</tr>
<tr style="display: none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;영업부서</td>
	<td width="35%" class="c_data_1_p" ><%=SALES_DEPT_NAME%>&nbsp;</td>
</tr>
<tr style="display: none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;검수자</td>
	<td width="35%" class="c_data_1_p" colspan="3"><%=SALES_USER_NAME%>&nbsp;</td>
</tr>
</table>

	<input type="hidden" name="pr_type" value="<%=PR_TYPE%>">							요청구분
회신희망일
	<input type="hidden" name="hard_maintance_term" value="<%=HARD_MAINTANCE_TERM%>">	하자보증기간 H/W
	<input type="hidden" name="soft_maintance_term" value="<%=SOFT_MAINTANCE_TERM%>">	하자보증기간 S/W
	<input type="hidden" name="shipper_type" value="<%=SHIPPER_TYPE%>">					내외자구분
	<input type="hidden" name="compute_reason" value="<%=COMPUTE_REASON%>">				금액산정근거
	<input type="hidden" name="rec_reason" value="<%=REC_REASON%>">						업체추천사유


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="3"></td>
</tr>
<tr>
	<td align="left" class="cell_title1">&nbsp;◆ 등록정보</td>
</tr>
</table>


<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr style="display:none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;프로젝트코드</td>
	<td width="35%" class="c_data_1_p" colspan=""><%=wbs%></td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;프로젝트명</td>
	<td width="35%" class="c_data_1_p" colspan=""><%=wbs_name%></td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;구매요청번호</td>
	<td width="35%" class="c_data_1_p" ><%=PR_NO%></td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;요청명</td>
	<td width="35%" class="c_data_1_p" ><%=SUBJECT%></td>
</tr>
<tr style="display: none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;고객사</td>
	<td width="35%" class="c_data_1_p" ><%=CUST_NAME%></td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;요청일자</td>
	<td width="35%" class="c_data_1_p"><%=ADD_DATE_VIEW%></td>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;요청금액</td>
	<td width="35%" class="c_data_1_p" ><%=WiseMath.WiseNumberType(PR_TOT_AMT,"###,###,###,###.00")%></td>

</tr>
<tr style="display:none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;매출계약예상일</td>
	<td width="35%" class="c_data_1_p" colspan="3"><%=CONTRACT_HOPE_DAY_VIEW%></td>
</tr>
<tr style="display: none">
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;선투입여부</td>
	<td width="35%" class="c_data_1_p" ><%=AHEAD_FLAG%></td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;특기사항</td>
	<td width="35%" class="c_data_1_p" colspan="3"><textarea name="remark" rows="6" style="width:98%;" readonly><%=REMARK%></textarea></td>
</tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 첨부파일</td>
	<td class="c_data_1" colspan="3" height="150">
		<iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
		<br>&nbsp;
	</td>
</tr>
</table> --%>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      		<% if ("Y".equals(doc_status)) { %>
	      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=doc_no%>','')","승 인")</script></TD>
		      		<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=doc_no%>','')","반 려")</script></TD>
<%-- 		      		<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')",21,"결재선추가")</script></TD> --%>
		      	<% } %>
		     	 	<TD style="display: none;"><script language="javascript">btn("javascript:RFQComparison()","소싱비교")</script></TD>
	      			<TD style="display: none;"><script language="javascript">btn("javascript:goIReport()","인 쇄")</script></TD>
	      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")   </script></TD>
	      		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>

<iframe src="" name="childFrame" WIDTH="300" Height="300" border="0" scrolling="no" frameborder="0"></iframe>
<%-- 결재자 의견 --%>

<%
	if(!doc_type.equals("TAX")){
%>
<jsp:include page="/include/approvalOpinion.jsp" >
<jsp:param name="doc_no" 	value="<%=doc_no%>"/>
<jsp:param name="doc_seq" 	value="<%=doc_seq%>"/>
<jsp:param name="doc_type" 	value="<%=doc_type%>"/>
</jsp:include>
<%
	}
%>


</form>

<%-- <script language="javascript">rMateFileAttach('S','R','PR',form1.attach_no.value);</script> --%>
</body>
</html>




<s:footer/>


