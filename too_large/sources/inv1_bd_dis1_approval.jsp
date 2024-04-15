<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AP_104_1");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AP_104_1";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
품의 결제승인목록
--%>

<%

	String house_code   	= info.getSession("HOUSE_CODE");
	String COMPANY_CODE 	= info.getSession("COMPANY_CODE");
	String ID           	= info.getSession("ID");
	String DEPARTMENT   	= info.getSession("DEPARTMENT");
	String CTRL_CODE		= info.getSession("CTRL_CODE");
    String doc_type			= JSPUtil.nullToEmpty(request.getParameter("doc_type"));
    String doc_no			= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
	String doc_seq			= JSPUtil.nullToEmpty(request.getParameter("doc_seq"));		// BID_COUNT
	String sign_path_seq	= JSPUtil.nullToEmpty(request.getParameter("sign_path_seq"));//결재순번
	String proceeding_flag	= JSPUtil.nullToEmpty(request.getParameter("proceeding_flag"));//결재요청상태(합의, 결재)
    String doc_status   	= JSPUtil.nullToEmpty(request.getParameter("doc_status"));
	String sign_enable 		= JSPUtil.nullToEmpty(request.getParameter("sign_enable"));
	String attach_no 		= JSPUtil.nullToEmpty(request.getParameter("attach_no"));

	String add_user_name 	= JSPUtil.nullToEmpty(request.getParameter("add_user_name"));
	String add_date 		= JSPUtil.nullToEmpty(request.getParameter("add_date"));
	String subject 			= JSPUtil.nullToEmpty(request.getParameter("subject"));

	/*아래추가*/
    String inv_no          	= JSPUtil.nullToEmpty(request.getParameter("inv_no"));
    String po_no          	= JSPUtil.nullToEmpty(request.getParameter("po_no"));
    String gubun           	= JSPUtil.nullToEmpty(request.getParameter("gubun"));

    String po_no11 = "";
    String po_name12 = "";
    String project_name21 = "";
    String iv_no31 = "";   //매입계산서번호
    String inv_no32 = "";
    String inv_seq41 = "";
    String app_status42 = "";
    String confirm_date1 = "";
    String po_ttl_amt51 = "";
    String inv_amt52 = "";
    String vendor_name61 = "";
    String vendor_cp_name62 = "";
    String bb71 = "";
    String attach_no81 = "";
    String inv_date98 = "";
    String inv_person_name99 = "";
    Object[] obj = {inv_no};
    WiseOut value = ServiceConnector.doService(info, "p2050", "CONNECTION", "getInvDisplay", obj);

    WiseFormater wf = new WiseFormater(value.result[0]);
    wf.setFormat("INV_DATE","YYYY/MM/DD","DATE");
    if(wf.getRowCount() > 0) {
        po_no11           = wf.getValue("po_no11", 0);
        po_name12         = wf.getValue("po_name12", 0);
        project_name21    = wf.getValue("project_name21", 0);
        inv_no32          = wf.getValue("inv_no32", 0);
        inv_seq41         = wf.getValue("inv_seq41", 0);
        app_status42      = wf.getValue("app_status42", 0);
		confirm_date1     = wf.getValue("confirm_date1", 0);
        
        if(confirm_date1.equals("//"))
        {
        	confirm_date1 = "";	
        }
        
        po_ttl_amt51      = wf.getValue("po_ttl_amt51", 0);
        inv_amt52         = wf.getValue("inv_amt52", 0);
        vendor_name61     = wf.getValue("vendor_name61", 0);
        vendor_cp_name62  = wf.getValue("vendor_cp_name62", 0);
        bb71              = wf.getValue("bb71", 0);
        attach_no81       = wf.getValue("attach_no81", 0);
        inv_date98        = wf.getValue("inv_date98", 0);
        inv_person_name99 = wf.getValue("inv_person_name99", 0);
    }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<style type="text/css">
<!--
.style1 {
	color: #000000;
	font-size: 18px;
	font-weight: bold;
}
-->
</style>
<Script language="javascript" type="text/javascript">
//<!--
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/order.ivdp.inv1_bd_dis1";
    var mode;
    var checked_count = 0;

    var IDX_SEL             ;
    var IDX_DP_SEQ          ;
    var IDX_DP_TEXT         ;
    var IDX_PAY_TERMS       ;
    var IDX_PAY_TERMS_TEXT  ;
    var IDX_DP_PERCENT      ;
    var IDX_DP_AMT          ;
    var IDX_DP_PLAN_DATE    ;

    var chkrow;

    function setHeader() {
        //document.forms[0].EXEC_AMT_KRW.value = add_comma(document.forms[0].EXEC_AMT_KRW.value,0);
        var itemsize        = 100;
        var servicesize     = 0;
        var inv_qty         = "검수요청수량";
        var item_no         = "품목";
        var description_loc = "품목명";



        GridObj.SetNumberFormat("UNIT_PRICE"  ,G_format_amt);
        GridObj.SetNumberFormat("EXPECT_AMT"  ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_AMT"        ,G_format_amt);
        GridObj.SetNumberFormat("ITEM_QTY"        ,G_format_qty);

        doSelect();
    }

    function doSelect()
    {
        GridObj.SetParam("inv_no","<%=inv_no%>");
        GridObj.SetParam("grid_type","grid_top");
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
        GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti";
    }

    function setHeader2() {
        var itemsize        = 100;
        var servicesize     = 0;
        var inv_qty         = "검수요청수량";
        var item_no         = "품목";
        var description_loc = "품목명";


     // 2011-03-08 송장일자  hidden


        GridObj2.SetDateFormat("DATE1"     ,"yyyy/MM/dd");
        GridObj2.SetDateFormat("DATE2"    ,"yyyy/MM/dd");
        GridObj2.SetDateFormat("FLAG"     ,"yyyy/MM/dd");
        GridObj2.SetNumberFormat("AMT"    ,G_format_amt);

        //GridObj2.SetColCellAlign("DATE2","center");
        //doSelect2();
    }

    function doSelect2()
    {
        GridObj2.SetParam("po_no","<%=po_no%>");
        GridObj2.SetParam("inv_no","<%=inv_no%>");
        GridObj2.SetParam("grid_type","grid_bottom");
        GridObj2.SetParam("WISETABLE_DOQUERY_DODATA","0");
        GridObj2.SendData(servletUrl);
        GridObj2.strHDClickAction="sortmulti";
    }

    function JavaCall(msg1, msg2, msg3, msg4, msg5)
    {

        var GridObj = GridObj;
        var GridObj2 = GridObj2;
        GridObj.AddSummaryBar('SUMMARY1', '소계', 'summaryall', 'sum', 'EXPECT_AMT');
        GridObj2.AddSummaryBar('SUMMARY1', '소계', 'summaryall', 'sum', 'AMT');
        var f0              = document.forms[0];
        var row             = GridObj.GetRowCount();
        var po_no           = "";
        var shipper         = "";
        var sign_flag       = "";


        if(msg1 == "t_imagetext")
        {

        }

    	if(msg1 == "doData")
    	{
    		var mode  = GD_GetParam(GridObj,0);
    		var status= GD_GetParam(GridObj,1);

    		if(mode == "inv_app")
    		{
    			alert(GridObj.GetMessage());
    			if(status != "0")
    			{
    				//GridObj.RemoveAllData();
    				//f.pr_tot_amt.value = "";
    				window.close();
    				opener.doSelect();
    			}
    		}
    	}
    }
function Add_file(){
    var ATTACH_NO_VALUE = document.forms[0].attach_no.value;
    FileAttach('INV',ATTACH_NO_VALUE,'VI');

}
    function printOZ(){
        window.open("/oz/oz_inv_dis1.jsp?inv_no=<%=inv_no%>&house_code=<%=info.getSession("HOUSE_CODE")%>","newWin_oz","width=1000,height=600,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");
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

function download(url)
{
 	location.href = url;
}
function GD_CellClick(strColumnKey, nRow){
//	if (strColumnKey == ) {
		var item_no = GridObj.GetCellValue("ITEM_NO",nRow);
		window.open("/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO="+item_no,"real_pp_lis1","left=0,top=0,width=900,height=500,resizable=yes,scrollbars=yes");
//	}
}

	function rMateFileAttach(att_mode, view_type, file_type, att_no, company) {
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
			if (company == "B") {			// Buyer
				f.target = "attachBFrame";
			} else if (company == "S") {	// Supplier
				f.target = "attachSFrame";
			}
			f.action = "/rMateFM/rMate_file_attach.jsp";
			f.submit();
		}
	}


	function goIReport(){
		childFrame.location.href = "/report/iReportPrint.jsp?flag=DL&house_code=<%=house_code%>&so_no=<%=inv_no%>";
	}

	  function Approval(sign_status)
	  {
	    var wise = GridObj;
	    var f = document.forms[0];

	    var iRowCount = GridObj.GetRowCount();
	    //var iCheckedCount = getCheckedCount(wise, INDEX_SELECTED);
	    //if(iCheckedCount<1)
	    //{
	    //  alert(G_MSS1_SELECT);
	    //  return;
	    //}

		if(new Number(getCheckedCount) == 0){
			alert("검수 내역이 없습니다.");
			return;
		}
	    f.sign_status.value = sign_status;


	    if(sign_status == "P")
	    {
	      f.method = "POST";
	      f.target = "childFrame";
	      f.action = "/kr/admin/basic/approval/approval.jsp";
	      f.submit();
	    }
	    else if(sign_status == G_SAVE_STATUS)
	    {
	      //getApproval(sign_status);
	    }


		//getApproval(sign_status);

	  }//Approval End

	  function getApproval(approval_str){
		  var f = document.forms[0];
		  mode = "inv_app";

		  var tot_amt = 0;

		  for(var i = 0; i < GridObj.GetRowCount();i++)	{
			  tot_amt = tot_amt + new Number(GridObj.GetCellValue("EXPECT_AMT", i));
		  }

		  GridObj.SetParam("mode" , mode);
		  GridObj.SetParam("inv_no" , "<%=inv_no%>");
		  GridObj.SetParam("tot_amt" , tot_amt);
		  GridObj.SetParam("approval_str" , approval_str);
		  GridObj.SetParam("sign_status"  , f.sign_status.value);
		  GridObj.SetParam("doc_type"   	, f.doc_type.value);	//사전지원요청, 구매요청 구분
		  GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		  GridObj.SendData("<%=getWiseServletPath("order.ivdp.inv1_bd_dis1")%>", "ALL", "ALL");
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

	<input type="hidden" name="kind">
	<input type="hidden" name="attach_no" value="<%=attach_no81%>">
	<input type="hidden" name="attach_count" value="">

	<input type="hidden" name="att_mode"  value="">
	<input type="hidden" name="view_type"  value="">
	<input type="hidden" name="file_type"  value="">
	<input type="hidden" name="tmp_att_no" value="">

	<input type="hidden" name="house_code" value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code" value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code" value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id" value="<%=info.getSession("ID")%>">
	<input type="hidden" name="fnc_name" value="getApproval">
	<input type="hidden" name="approval_str" value="">
	<input type="hidden" name="sign_status" value="N">
	<input type="hidden" name="doc_type" value="INV">


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
    <td width="29%" valign="top" ><table width="90%" height="92" border="0" cellpadding="0" cellspacing="0">
	  <tr>
        <td class="title">검&nbsp;수&nbsp;요&nbsp;청&nbsp;번&nbsp;호&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=inv_no%></td>
      </tr>
      <tr>
        <td height="1" bgcolor="#000000"></td>
      </tr>
      <tr>
        <td class="title">상&nbsp;&nbsp;&nbsp;&nbsp;신&nbsp;&nbsp;&nbsp;&nbsp;일&nbsp;&nbsp;&nbsp;&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;<%=getFormatDate(add_date)%></td>
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
        <td class="title">검&nbsp;&nbsp;수&nbsp;&nbsp;요&nbsp;&nbsp;청&nbsp;&nbsp;명&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp<%=subject%></td>
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
        		<td width="32" align="center" bgcolor="#CCCCCC" class="c_title_1" >결<br>재</td>
<%
    Object[] obj_sign = {doc_no,doc_type};	//기안자 + 결재자
    WiseOut value_sign = ServiceConnector.doService(info,"p6029","CONNECTION","getSignPath",obj_sign);
    WiseFormater wf_sign = new WiseFormater(value_sign.result[0]);

    Object[] obj_agree = {doc_no,doc_type}; //합의자
    WiseOut value_agree = ServiceConnector.doService(info,"p6029","CONNECTION","getSignAgree",obj_agree);
    WiseFormater wf_agree = new WiseFormater(value_agree.result[0]);

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
	  <tr bgcolor="#FFFFFF" style="dispaly:none">
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

<br>
<script language="javascript">rdtable_top1()</script>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">

</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
    <tr>
      <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주번호</td>
      <td width="35%" class="c_data_1"><%=po_no11%></td>
      <td width="13%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주명</td>
      <td width="35%" class="c_data_1"><%=po_name12%></td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 프로젝트명</td>
      <td class="c_data_1"><%=project_name21%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수요청일자 / 검수완료일자</td>
      <td class="c_data_1"><%=app_status42%>&nbsp;<%=confirm_date1 %></td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수요청번호</td>
      <td class="c_data_1"><%=inv_no32%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수차수</td>
      <td class="c_data_1"><%=inv_seq41%></td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 발주총금액(VAT별도)</td>
      <td class="c_data_1"><%=po_ttl_amt51%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 검수 후 잔액(VAT별도)</td>
      <td class="c_data_1"><%=inv_amt52%></td>
    </tr>
    <tr>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공급업체</td>
      <td class="c_data_1"><%=vendor_name61%></td>
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 공급담당</td>
      <td class="c_data_1"><%=vendor_cp_name62%></td>
    </tr>
    <!-- 2011-03-08 solarb 검수요청현황 -->
    <!-- 2011-03-08 보증보험증권  hidden -->
    <tr style="display: none;">
      <td class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 보증보험증권</td>
      <td colspan="3" class="c_data_1"><%=bb71%></td>
    </tr>
<tr>
	<td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 첨부파일</td>
	<td class="c_data_1" colspan="3">
		<iframe name="attachSFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
		<br>&nbsp;
	</td>
</tr>
  </table>


<script language="javascript">rdtable_bot1()</script>

<script language="javascript">rdtable_top1()</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      		<% if ("Y".equals(doc_status)) { %>
	      			<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('2','1','<%=doc_no%>','')",13,"승 인")</script></TD>
		      		<TD><script language="javascript">btn("javascript:opener.btnApprovalAll('3','1','<%=doc_no%>','')",1,"반 려")</script></TD>
		      		<TD><script language="javascript">btn("javascript:changeApprovalLine('<%=doc_type%>','<%=doc_no%>','<%=doc_seq%>','<%=sign_path_seq%>')",21,"결재선추가")</script></TD>
		      	<% } %>
	      			<TD><script language="javascript">btn("javascript:window.close()",36,"닫 기")   </script></TD>
	      		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>
<b>검수내역</b>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","150","",  info.getSession("LANGUAGE") ,"WiseGrid")%>
	</td>
</tr>
</table>

<br>
<b>기검수내역</b>
    <!-- 하단 그리드 -->
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","150","",  info.getSession("LANGUAGE") ,"WiseGrid2")%>
	</td>
</tr>
</table>

<%-- 결재자 의견 --%>
<jsp:include page="/include/approvalOpinion.jsp" >
<jsp:param name="doc_no" 	value="<%=doc_no%>"/>
<jsp:param name="doc_seq" 	value="<%=doc_seq%>"/>
<jsp:param name="doc_type" 	value="<%=doc_type%>"/>
</jsp:include>



</form>
<iframe src="" name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe>
<script language="javascript">rMateFileAttach('S','R','IV',form1.attach_no.value,'S');</script>
</body>
</html>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	    GD_CellClick(strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
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
    return true;
}
</script>
</head>

<s:header>
<!--내용시작-->

</s:header>
<s:grid screen_id="AP_104_1" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>


