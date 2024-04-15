<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
//////////////////ClipReport4 선언부 시작///////////////////////////////////////////////////////////
StringBuilder _rptAprvData = new StringBuilder();//리포트 제공 데이타
String _RF = CommonUtil.getConfig("clipreport4.separator.field"); //컬럼구분
String _RL = CommonUtil.getConfig("clipreport4.separator.line");  //개행구분
String _RD = CommonUtil.getConfig("clipreport4.separator.data");  //데이타구분
//////////////////ClipReport4 선언부 끝/////////////////////////////////////////////////////////////

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

	String ANN_VERSION  = "";
	String BID_NO		= JSPUtil.nullToRef(request.getParameter("doc_no"), "");
	String BID_COUNT	= JSPUtil.nullToRef(request.getParameter("doc_seq"), "");

	
    String USER_ID        = info.getSession("ID");
    String HOUSE_CODE     = info.getSession("HOUSE_CODE") ;

    String subject            	= JSPUtil.nullToEmpty(request.getParameter("subject"));
    String ORDER_NO           	= "";
    String ORDER_COUNT			= "";
    String ORDER_NAME         	= "";
    String RECEIVE_TERM       	= "";
    String add_date        		= JSPUtil.nullToEmpty(request.getParameter("add_date"));
    String DEMAND_DEPT_NAME   	= "";
    String DEMAND_DEPT        	= "";
    String add_user_name      	= JSPUtil.nullToEmpty(request.getParameter("add_user_name"));	
    String BID_TYPE      		= "";
    String view_content      	= JSPUtil.nullToEmpty(request.getParameter("view_content"));	
	
	Map map = new HashMap();
	map.put("BID_NO"		, BID_NO);
	map.put("BID_COUNT"		, BID_COUNT);
	
	Object[] obj = {map};
	SepoaOut value = ServiceConnector.doService(info, "BD_001", "CONNECTION","getPrHeaderDetail", obj);
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	if(wf.getRowCount() > 0) {
		ANN_VERSION = wf.getValue("ANN_VERSION"	,0);
		BID_TYPE	= wf.getValue("BID_TYPE"	,0);
	}
	
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

function init()
{

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
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
     <td  height="20"></td>
   </tr>
   <tr>
     <td align="center" class="style1">
		공급사 계좌번호 변경
     </td>
   </tr>
   <tr>
     <td  height="20">&nbsp;</td>
   </tr>
 </table> 
 
  <table width="98%" border="0" cellspacing="0" cellpadding="0" >
  <tr>
  <td width="1%" valign="top" ></td>
    <td width="29%" valign="top" ><table width="90%" height="92" border="0" cellpadding="0" cellspacing="0">
    
	  		<tr>
        		<td class="title"> 요&nbsp;청&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=doc_no%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title"> 요&nbsp;청&nbsp;일&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_date%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title"> 요&nbsp;&nbsp;&nbsp;청&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=add_user_name%></td>
      		</tr>
      		<tr>
        		<td height="1" bgcolor="#000000"></td>
      		</tr>
      		<tr>
        		<td class="title"> 요&nbsp;청&nbsp;건&nbsp;명&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=subject%></td>
      		</tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
    </table>
    	</td>
    <td width="*" colspan="2" align="right" >
<!-- 결재라인 시작 -->
    	<table border="0" cellspacing="1" cellpadding="0" bgcolor="#000000" align="right">
      		<tr bgcolor="#FFFFFF">
        		<td width="20" align="center" bgcolor="#CCCCCC" class="title1" >결<br>재</td>
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
              			<td height="20" class="data_td_c" align="center"><%=USER_NAME_LOC%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="data_td_c" align="center">
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
        		</table>
        	</td>
<%
		}else {
%>
			 <td width="110">
	        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            		<tr>
              			<td height="20" class="data_td_c" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="data_td_c" align="center">&nbsp;</td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="20" class="data_td_c" align="center">&nbsp;</td>
            		</tr>
        		</table>
        	</td>
<%
		}// end of if
	}//end of for
%>
      </tr>
      
	  <tr bgcolor="#FFFFFF" style="display:none">
      	<td width="32" align="center" bgcolor="#CCCCCC" class="title1" >합<br>의</td>
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
              			<td height="20" class="data_td_c" align="center"><%=POSITION_TEXT%></td>
            		</tr>
            		<tr>
              			<td height="1" bgcolor="#000000"></td>
            		</tr>
            		<tr>
              			<td height="30" class="data_td_c" align="center">
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
<%
app_attach_no = "";
POSITION_TEXT = "";
USER_NAME_LOC = "";
SIGN_DATE     = "";
SIGN_TIME     = "";
APP_STATUS    = "";
//////////////////ClipReport4 조립부 시작///////////////////////////////////////////////////////////
_rptAprvData.append("공급사 계좌번호 변경");

_rptAprvData.append(_RD);	

_rptAprvData.append("요 청 번 호");
_rptAprvData.append(_RF);
_rptAprvData.append(doc_no);
_rptAprvData.append(_RL);
_rptAprvData.append("요 청 일 자");
_rptAprvData.append(_RF);
_rptAprvData.append(add_date);
_rptAprvData.append(_RL);
_rptAprvData.append("요  청  자");
_rptAprvData.append(_RF);
_rptAprvData.append(add_user_name);
_rptAprvData.append(_RL);
_rptAprvData.append("요 청 건 명");
_rptAprvData.append(_RF);
_rptAprvData.append(subject);

_rptAprvData.append(_RD);	
for(int i = 0 ; i<approvalCnt; i++) {
	if(i < wf_sign.getRowCount()){
		POSITION_TEXT 	=	wf_sign.getValue("POSITION_TEXT"		, i);
		USER_NAME_LOC 	=	wf_sign.getValue("USER_NAME_LOC"		, i);
		SIGN_DATE 	    =	wf_sign.getValue("SIGN_DATE"			, i);
		SIGN_TIME 	    =	wf_sign.getValue("SIGN_TIME"			, i);
		APP_STATUS 	    =	wf_sign.getValue("APP_STATUS"			, i);
				
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
	}else {
		_rptAprvData.append(_RF);
		_rptAprvData.append(_RF);
	}// end of if
	_rptAprvData.append(_RL);
}//end of for
//////////////////ClipReport4 조립부 끝///////////////////////////////////////////////////////////
%>
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
		     	 	<TD><script language="javascript">btn("javascript:bidFrm.clipPrint('<%=_rptAprvData.toString().replaceAll("\"", "&quot")%>',<%=approvalCnt%>);","출 력")</script></TD>
					<TD style="display: none;"><script language="javascript">btn("javascript:RFQComparison()","소싱비교")</script></TD>
	      			<TD style="display: none;"><script language="javascript">btn("javascript:goIReport()","인 쇄")</script></TD>
	      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")   </script></TD>
	      		</TR>
  			</TABLE>
  		</td>
  		<td width="15"></td>
	</tr>
</table>
<%-- 결재자 의견 --%>
</form>

<iframe id="bidFrm" name="bidFrm" src="/kr/master/register/vendor_ar_view.jsp?AR_NO=<%=doc_no %>&SCR_FLAG=D&BID_STATUS=AR&VIEW_TYPE=P" style="width: 98%;height: 550px; border: 0px;" frameborder="0" scrolling="yes"></iframe>
<%-- <script language="javascript">rMateFileAttach('S','R','PR',form1.attach_no.value);</script> --%>
</body>
</html>
<s:footer/>


