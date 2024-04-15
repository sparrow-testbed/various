<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	String WISEHUB_PROCESS_ID = "s0010";
	String WISEHUB_LANG_TYPE = "KR";

	//Logger.debug.println("AAA", this,  "================ summary_t.jsp start ");
	//long start_time1 = System.currentTimeMillis ();
	//	Thread.sleep(2000);

	String dept_code = info.getSession("DEPARTMENT");
	String ctrl_code = info.getSession("CTRL_CODE");

	String menu_type = "";
	if (ctrl_code.startsWith("P01") || ctrl_code.startsWith("P02")) {
		menu_type = "ADMIN";
	} else {
		menu_type = "NORMAL";
	}
	
	String gw_menunum = JSPUtil.nullToEmpty(request.getParameter("gw_menunum"));

	String new_agreement = "0";
	String new_id = "0";
	String new_item = "0";

	Object[] args = null;
	SepoaOut value = null;
	SepoaRemote wr = null;

	String nickName = "p6011";
	String MethodName = "getCountMainProcess";
	String conType = "CONNECTION";

	SepoaFormater wf_App    = null;
	SepoaFormater wf_AppReq = null;
	SepoaFormater wf_BrPr   = null;
	SepoaFormater wf_Rfq    = null;
	SepoaFormater wf_Bid    = null;
	SepoaFormater wf_Ra     = null;
	SepoaFormater wf_Ex     = null;
	SepoaFormater wf_Po     = null;
	SepoaFormater wf_Ct     = null;
	SepoaFormater wf_Iv     = null;
	SepoaFormater wf_Vendor = null;
	SepoaFormater wf_Item   = null;
	SepoaFormater wf_CsEv   = null;
	SepoaFormater wf_Item2  = null;
	SepoaFormater wf_PayOperateExpense  = null;	
	SepoaFormater wf_PayOperate  = null;	
	
	//----------------------------
	String app_cnt          = "0";
	String appReq_cnt       = "0";
	String brNotReceipt_cnt = "0";
	String brWaiting_cnt    = "0";
	String prNotReceipt_cnt = "0";
	String prWaiting_cnt    = "0";
	//----------------------------
	String brRfq_cnt        = "0";
	String brBid_cnt        = "0";
	String brRa_cnt         = "0";
	String brEx_cnt         = "0";
	String prRfq_cnt        = "0";
	String prBid_cnt        = "0";
	String rfq_cnt          = "0";
	String prRa_cnt         = "0";
	String prEx_cnt         = "0";
	//----------------------------
	String poWaiting_cnt    = "0";
	String DpoWaiting_cnt   = "0";
	String ctWaiting_cnt    = "0";
	String ivWaiting_cnt    = "0";
	String vendorWaiting_cnt = "0";
	String itemWaiting_cnt  = "0";
	String CsEvWaiting_cnt    = "0";
	String itemWaiting_cnt2 = "0";
	String PayOperateExpense_cnt = "0";
    String PayOperate_cnt = "0";
	
	//----------------------------

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	try {
		int idx = 0;

		wr = new SepoaRemote(nickName, conType, info);
		value = wr.lookup(MethodName, args);
/* 전자결재 */
		wf_App = new SepoaFormater(value.result[idx++]);//결재요청
		if (wf_App.getRowCount() > 0) {
			app_cnt = wf_App.getValue("APP_CNT", 0);
		}

		wf_AppReq = new SepoaFormater(value.result[idx++]);//결재상신
		if (wf_AppReq.getRowCount() > 0) {
			appReq_cnt = wf_AppReq.getValue("APP_REQ_CNT", 0);
		}

/* 전자결재 END */


		wf_BrPr = new SepoaFormater(value.result[idx++]);//사전지원,구매요청
		if (wf_BrPr.getRowCount() > 0) {
			//brNotReceipt_cnt = wf_BrPr.getValue("BR_NOT_RECEIPT_CNT", 0);//미사용
			//brWaiting_cnt = wf_BrPr.getValue("BR_WAITING_CNT", 0);//미사용

			prNotReceipt_cnt = wf_BrPr.getValue("PR_NOT_RECEIPT_CNT", 0);
			prWaiting_cnt = wf_BrPr.getValue("PR_WAITING_CNT", 0);
		}

		wf_Rfq = new SepoaFormater(value.result[idx++]);//RFQ
		if (wf_Rfq.getRowCount() > 0) {
			//brRfq_cnt = wf_Rfq.getValue("BR_RFQ_CNT", 0);//미사용
			//prRfq_cnt = wf_Rfq.getValue("PR_RFQ_CNT", 0);//미사용
			
			rfq_cnt = wf_Rfq.getValue("RFQ_CNT", 0);
		}

		wf_Ex = new SepoaFormater(value.result[idx++]);//EX
		if (wf_Ex.getRowCount() > 0) {
			brEx_cnt = wf_Ex.getValue("BR_EX_CNT", 0);
			prEx_cnt = wf_Ex.getValue("PR_EX_CNT", 0);
		}

		wf_Po = new SepoaFormater(value.result[idx++]);//발주대상
		if (wf_Po.getRowCount() > 0) {
			poWaiting_cnt = wf_Po.getValue("PO_WAITING_CNT", 0);
			DpoWaiting_cnt = wf_Po.getValue("PO_WAITING_CNT2", 0);
		}
		

		wf_Iv = new SepoaFormater(value.result[idx++]);//검수대기
		if (wf_Iv.getRowCount() > 0) {
			ivWaiting_cnt = wf_Iv.getValue("IV_WAITING_CNT", 0);
		}

		wf_Vendor = new SepoaFormater(value.result[idx++]);//업체승인대기
		if (wf_Vendor.getRowCount() > 0) {
			vendorWaiting_cnt = wf_Vendor.getValue(
					"VENDOR_WAITING_CNT", 0);
		}

		wf_Item = new SepoaFormater(value.result[idx++]);//품목등록신청
		if (wf_Item.getRowCount() > 0) {
			itemWaiting_cnt = wf_Item.getValue("ITEM_WAITING_CNT", 0);
		}
		
		wf_CsEv = new SepoaFormater(value.result[idx++]);//공사평가대기
		if (wf_CsEv.getRowCount() > 0) {
			CsEvWaiting_cnt = wf_CsEv.getValue("CSEV_WAITING_CNT", 0);
		}
		
		wf_PayOperateExpense = new SepoaFormater(value.result[idx++]);//경상비결의대상
		if (wf_PayOperateExpense.getRowCount() > 0) {
			PayOperateExpense_cnt = wf_PayOperateExpense.getValue("PAYOPERATEEXPENSE_WAITING_CNT", 0);
		}
		
		wf_PayOperate = new SepoaFormater(value.result[idx++]);//경상비집행대기
		if (wf_PayOperate.getRowCount() > 0) {
			PayOperate_cnt = wf_PayOperate.getValue("PAYOPERATE_WAITING_CNT", 0);
		}
		
		
		
		
		/*
		
		wf_Bid = new SepoaFormater(value.result[idx++]);//BID
		if (wf_Bid.getRowCount() > 0) {
			brBid_cnt = wf_Bid.getValue("BR_BID_CNT", 0);
			prBid_cnt = wf_Bid.getValue("PR_BID_CNT", 0);
		}

		wf_Ra = new SepoaFormater(value.result[idx++]);//RA
		if (wf_Ra.getRowCount() > 0) {
			brRa_cnt = wf_Ra.getValue("BR_RA_CNT", 0);
			prRa_cnt = wf_Ra.getValue("PR_RA_CNT", 0);
		}

		

		wf_Ct = new SepoaFormater(value.result[idx++]);//계약대상
		if (wf_Ct.getRowCount() > 0) {
			ctWaiting_cnt = wf_Ct.getValue("CT_WAITING_CNT", 0);
		}

		
		wf_Item2 = new SepoaFormater(value.result[idx++]);//품목등록신청
		if (wf_Item2.getRowCount() > 0) {
			itemWaiting_cnt2 = wf_Item2.getValue("ITEM_WAITING_CNT2", 0);
		}
		*/
		
	} catch (Exception e) {
		Logger.err.println(info.getSession("ID"), this,
				"e ================> " + e.getMessage());
		Logger.dev.println(e.getMessage());
	} finally {
		wr.Release();
	} // finally 끝
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Main</title>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script type='text/javascript'>
function linkto(url, muo, topId){
	topMenuClick(url, muo, topId, '');
//  	document.forms[0].method = "post";
//   	document.forms[0].target = "_self";
// 	document.forms[0].action = url;
// 	document.forms[0].submit();
}
/*
function linkto(url, flag)
{
	document.forms[0].return_flag.value = flag;
 	document.forms[0].method = "post";
  	document.forms[0].target = "body";
	document.forms[0].action = url;
	document.forms[0].submit();
}
*/
/* function linkto(url, desc)
{
	top.MakeTabList(desc,url);
} */

function Init(gw_menunum)
{
   if(gw_menunum != null || gw_menunum != "0")
   {
      if(gw_menunum == "1")
      {
        linkto('/kr/admin/basic/approval2/ap2_bd_lis2.jsp','' );
      }else if(gw_menunum =="2")
      {
      	linkto('/kr/dt/app/app_bd_lis1.jsp','' );
      }else if(gw_menunum =="3")
      {
        linkto('/kr/order/bpo/po7_bd_lis1.jsp','' );
      }else if(gw_menunum =="4")
      {
      	linkto('/kr/order/ivdp/inv1_bd_lis1.jsp','' );
      }else if(gw_menunum =="5")
      {
      	linkto('/kr/master/vendor/sta_bd_lis1.jsp','' );
      }else if(gw_menunum =="6")
      {
      	linkto('/kr/master/new_material/confirm_bd_lis1.jsp','' );
      }
   }
   
   <%if ("1".equals(request.getParameter("f"))){%>
		<% if (!"0".equals(app_cnt)){ %>
				if(confirm("<%=info.getSession("NAME_LOC")%> 님\r\n\r\n<%=app_cnt%>건의 결재할 문서가 존재합니다.\r\n결재 거래로 이동 하시겠습니까?")) {	
					<%if ("MUP141000003".equals(info.getSession("MENU_PROFILE_CODE")) || "MUP221100001".equals(info.getSession("MENU_PROFILE_CODE"))) {%>
						topMenuClick('/approval/ap_wait_list.jsp','MUO141000015', '2','');								
					<%}else{%>
						topMenuClick('/approval/ap_wait_list.jsp','MUO141000005', '2',''); 
					<%}%>
				}
		<% }else{ %>
		   		if(!confirm("<%=info.getSession("NAME_LOC")%> 님\r\n\r\n <%=info.getSession("DEPARTMENT_NAME_LOC")%> 소속이 맞습니까?")) {		
					alert("인사이동시 포탈 부점 변경후 하루뒤 변경됩니다.");
		        	window.close();        	
				} else {
		        	alert("현재 <%=info.getSession("DEPARTMENT_NAME_LOC")%> 소속으로 접속중 입니다.");		
			    }
		   		
		   		<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>
				<% if ( "MUP221100001".equals(info.getSession("MENU_PROFILE_CODE")) ) {%>			   		
					topMenuClick('/kr/tax/pay_operate_give_list.jsp','MUO221100001', '3',''); 		   		  
				<% } %>   		
		<% } %>
   <%}%>
}
</Script>
</head>
<body leftmargin="0" topmargin="20" onLoad="Init('<%=gw_menunum%>');">
<s:header>
	<form name="search" >
		<input type="hidden" name="btn_flg" value="">
		<input type="hidden" name="return_flag" value="">

		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
	</form>
<%
	Configuration conf = new Configuration();
	String profile_code = "";
	//profile_code = conf.getBoolean("wise.development.flag") ? "MUP100800001" : "MUP100700002";
	String style = profile_code.equals(info.getSession("MENU_TYPE")) ? "style='display:none;'"
			: "";
%>
	<br>
<%
	if ("MUP141000001".equals(info.getSession("MENU_PROFILE_CODE")) || "MUP141200004".equals(info.getSession("MENU_PROFILE_CODE"))  || "MUP210200001".equals(info.getSession("MENU_PROFILE_CODE"))) {
%>	
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="20%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">전자결재</td>
								</tr>
								<tr>
									<td class="td_line" align="left" bgcolor="#d9d9d9"><img src="../images/line_summary.gif" width="48" height="3"></td>
								</tr>
								<tr>
									<td align="center" valign="top" style="background-color:#f8f8f8; padding:10px 20px 10px 10px" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000005', '2' )" class="summary_title">결재대상</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000005', '2' )" class="summary_no">
														<span class="summary_num">
															<%=app_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000005', '2')" class="summary_title">결재상신</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000005', '2' )" class="summary_no">
														<span class="summary_num">
															<%=appReq_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td width="20%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">구매관리</td>
								</tr>
								<tr>
									<td class="td_line" align="left" bgcolor="#d9d9d9">
										<img src="/images/line_summary.gif" width="48" height="3">
									</td>
								</tr>
								<tr>
									<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<tr style="display:none">
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp?REQ_TYPE=B','MUO141000002', '1' )" class="summary_title">사전지원 미접수</a>
<!-- 													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp?REQ_TYPE=B','MUO140800002', '1' )" class="summary_title">사전지원 미접수</a> -->
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp?REQ_TYPE=B','MUO141000002', '1' )" class="summary_no">
<!-- 													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp?REQ_TYPE=B','MUO140800002', '1' )" class="summary_no"> -->
														<span class="summary_num">
															<%=brNotReceipt_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr style="display:none">
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
<%
		if (menu_type.equals("ADMIN")) {
%>												
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/dt/pr/pr5_bd_lis2.jsp','MUO141000002', '1' )" class="summary_title">구매요청 미접수</a>
<!-- 													<a href="javascript:linkto('/kr/dt/pr/pr5_bd_lis2.jsp','MUO140800002', '1' )" class="summary_title">구매요청 미접수</a> -->
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/dt/pr/pr5_bd_lis2.jsp','MUO141000002', '1')" class="summary_no">
<!-- 													<a href="javascript:linkto('/kr/dt/pr/pr5_bd_lis2.jsp','MUO140800002', '1')" class="summary_no"> -->
														<span class="summary_num">
															<%=prNotReceipt_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<!-- 
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/dt/pr/pr1_bd_lis2.jsp','MUO140800002', '1' )" class="summary_title">구매요청 진행현황</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/dt/pr/pr1_bd_lis2.jsp','MUO140800002', '1' )" class="summary_no">
														<span class="summary_num">
															<%=prWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											 -->
<%
		}
%>	          

											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center"><img src="/images/blt_summary.gif" width="9" height="9"></td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/dt/rfq/rfq_bd_lis1.jsp?FLAG=P','MUO141000002', '1' )" class="summary_title">견적진행 </a>
<!-- 													<a href="javascript:linkto('/kr/dt/rfq/rfq_bd_lis1.jsp?FLAG=P','MUO140800002', '1' )" class="summary_title">견적진행 </a> -->
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/dt/rfq/rfq_bd_lis1.jsp?FLAG=P','MUO141000002', '1' )" class="summary_no">
<!-- 													<a href="javascript:linkto('/kr/dt/rfq/rfq_bd_lis1.jsp?FLAG=P','MUO140800002', '1' )" class="summary_no"> -->
														<span class="summary_num">
															<%=rfq_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
<%
		if (menu_type.equals("ADMIN")) {
%>													
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp','MUO141000002', '1' )" class="summary_title">기안대기 </a>
<!-- 													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp','MUO140800002', '1' )" class="summary_title">기안대기 </a> -->
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp','MUO141000002', '1' )" class="summary_no">
<!-- 													<a href="javascript:linkto('/kr/dt/app/app_bd_lis1.jsp','MUO140800002', '1' )" class="summary_no"> -->
														<span class="summary_num">
															<%=prEx_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
																						<tr>
												<td height="26" colspan="3" ></td>
											</tr>
											
<%
		}else{
%>	          
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
											

<%
		}
%>                
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td width="20%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">발주관리</td>
								</tr>
								<tr>
									<td class="td_line" align="left" bgcolor="#d9d9d9">
										<img src="/images/line_summary.gif" width="48" height="3">
									</td>
								</tr>
								<tr>
									<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
		if (menu_type.equals("ADMIN")) {
%>											
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/procure/po_target_list.jsp','MUO141000003', '3' )" class="summary_title">기안발주대상</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/procure/po_target_list.jsp','MUO141000003', '3' )" class="summary_no">
														<span class="summary_num">
															<%=poWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr style="display: none;">
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000003', '3' )" class="summary_title">직발주대상</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000003', '3' )" class="summary_no">
														<span class="summary_num">
															<%=DpoWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr style="display: none;">
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000004', '4' )" class="summary_title">검수대기</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000004', '4' )" class="summary_no">
														<span class="summary_num">
															<%=ivWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/ev/cs_ev_wait_list.jsp','MUO141000004','4' )" class="summary_title">공사평가대기</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/ev/cs_ev_wait_list.jsp','MUO141000004','4')" class="summary_no">
														<span class="summary_num">
															<%=CsEvWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>																		
<%
		}

		if (menu_type.equals("NORMAL")) {
%>	            
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000004', '4' )" class="summary_title">검수대기</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000004', '4' )" class="summary_no">
														<span class="summary_num">
															<%=ivWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>

<%
		}
		else{
%>                
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
<%
		}
%>                
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						
						
						
						<td width="20%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">마감</td>
								</tr>
								<tr>
									<td class="td_line" align="left" bgcolor="#d9d9d9">
										<img src="/images/line_summary.gif" width="48" height="3">
									</td>
								</tr>
								<tr>
									<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
		if (menu_type.equals("ADMIN")) {
%>											
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO141000003','3' )" class="summary_title">경상비결의대기</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO141000003','3')" class="summary_no">
														<span class="summary_num">
															<%=PayOperateExpense_cnt%>
														</span> 건
													</a>
												</td>
											</tr>																											

<%
		}
		else{
%>                
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
<%
		}
%>                
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						
						
						
						
						
						<td width="20%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">기본관리</td>
								</tr>
								<tr>
									<td class="td_line" align="left" bgcolor="#d9d9d9">
										<img src="/images/line_summary.gif" width="48" height="3">
									</td>
								</tr>
								<tr>
									<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
<%
		if (menu_type.equals("ADMIN")) {
%>											
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/master/register/vendor_reg_lis.jsp','MUO141000001', '8' )"  class="summary_title">업체승인대기</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/master/register/vendor_reg_lis.jsp','MUO141000001', '8'  )" class="summary_no">
														<span class="summary_num">
															<%=vendorWaiting_cnt%>
														</span> 건
													</a>
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
<%
		}
%>			
											<tr>
												<td width="15" align="center">
													<img src="/images/blt_summary.gif" width="9" height="9">
												</td>
												<td width="108" height="25" class="title_s_summary" style="text-align: left;">
													<a href="javascript:linkto('/kr/master/new_material/confirm_bd_lis1.jsp','MUO141000001', '8'  )"  class="summary_title">품목등록신청</a>
												</td>
												<td width="62" align="right">
													<a href="javascript:linkto('/kr/master/new_material/confirm_bd_lis1.jsp','MUO141000001' , '8' )" class="summary_no">
														<span class="summary_num">
<%
		if(menu_type.equals("ADMIN")){
			out.println(itemWaiting_cnt);
		}
		else{
			out.println(itemWaiting_cnt2);
		}
%>
														</span> 건
													</a>
												</td>
											</tr>
<%	if(!menu_type.equals("ADMIN")){ %>											
											<tr>
												<td align="center"></td>
												<td height="27" colspan="3" ></td>
											</tr>
<%} %>											
											<tr>
												<td align="center"></td>
												<td height="27" colspan="3" ></td>
											</tr>
											
											<tr>
												<td height="27" colspan="3" ></td>
											</tr>
											
											<tr>
												<td height="26" colspan="3" ></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
<%
	} else if ("MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) || "MUP150300001".equals(info.getSession("MENU_PROFILE_CODE")) ) {
%>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="25%">
										<table width="50%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title_summary">전자결재</td>
											</tr>
											<tr>
												<td class="td_line" align="left" bgcolor="#d9d9d9">
													<img src="/images/line_summary.gif" width="48" height="3">
												</td>
											</tr>
											<tr>
												<td align="center" valign="top" style="background-color:#f8f8f8; padding:10px 20px 10px 10px" >
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000005', '2' )" class="summary_title">결재대상</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000005', '2' )" class="summary_no">
																	<span class="summary_num">
																		<%=app_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000005', '2')" class="summary_title">결재상신</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000005', '2' )" class="summary_no">
																	<span class="summary_num">
																		<%=appReq_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
<%
	}
	else {
%>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="25%">
										<table width="95%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title_summary">전자결재</td>
											</tr>
											<tr>
												<td class="td_line" align="left" bgcolor="#d9d9d9">
													<img src="/images/line_summary.gif" width="48" height="3">
												</td>
											</tr>
											<tr>
												<td align="center" valign="top" style="background-color:#f8f8f8; padding:10px 20px 10px 10px" >
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
																<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000015','2')" class="summary_title">결재대상</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/approval/ap_wait_list.jsp','MUO141000015','2')" class="summary_no">
																	<span class="summary_num">
																		<%=app_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center"><img src="../images/blt_summary.gif" width="9" height="9"></td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000015','2')" class="summary_title">결재상신</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/approval/ap_report_list.jsp','MUO141000015','2')" class="summary_no">
																	<span class="summary_num">
																		<%=appReq_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>
														<tr>
															<td height="26" colspan="3" ></td>
														</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
									<td width="25%">
										<table width="95%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title_summary">검수/마감</td>
											</tr>
											<tr>
												<td class="td_line" align="left" bgcolor="#d9d9d9">
													<img src="/images/line_summary.gif" width="48" height="3">
												</td>
											</tr>
											<tr>
												<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr style="display:none">
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000014','3' )" class="summary_title">기안발주대상</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000014','3' )" class="summary_no">
																	<span class="summary_num">
																		<%=poWaiting_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr style="display:none">
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr style="display:none">
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000014','3' )" class="summary_title">직발주대상</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/procure/po_progress_list.jsp','MUO141000014','3' )" class="summary_no">
																	<span class="summary_num">
																		<%=DpoWaiting_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr style="display:none">
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>

<%-- [R102210241178][2022-12-30] (전자구매)총무부 경비팀의 결제지원센터 이전에 따른 일괄작업 SR요청 --%>														
<%
	if ( "MUP221100001".equals(info.getSession("MENU_PROFILE_CODE")) ) {
%>														
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO221100001','3' )" class="summary_title">검수대기</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO221100001','3')" class="summary_no">
																	<span class="summary_num">
																		<%=ivWaiting_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO221100001','3' )" class="summary_title">경상비결의대기</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO221100001','3')" class="summary_no">
																	<span class="summary_num">
																		<%=PayOperateExpense_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/kr/tax/pay_operate_give_list.jsp','MUO221100001','3' )" class="summary_title">경상비집행대기</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/kr/tax/pay_operate_give_list.jsp','MUO221100001','3')" class="summary_no">
																	<span class="summary_num">
																		<%=PayOperate_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>																
<%
	}else{
%>														
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000014','3' )" class="summary_title">검수대기</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/procure/invoice_list.jsp?sign_status=P','MUO141000014','3')" class="summary_no">
																	<span class="summary_num">
																		<%=ivWaiting_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO141000014','3' )" class="summary_title">경상비결의대기</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/kr/tax/pay_operate_expense_list.jsp','MUO141000014','3')" class="summary_no">
																	<span class="summary_num">
																		<%=PayOperateExpense_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>
														<tr>
															<td height="27" colspan="3" ></td>
														</tr>						

<%
	}
%>		
														
																										
													</table>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
<%
	}
%>
						</td>
					</tr>
					<tr>
						<td height="15">&nbsp;</td>
					</tr>
					<tr>
						<td>
<%@include file ="/s_kr/home/notice_list.jsp" %>
						</td>
					</tr>
					<tr>
						<td height="10" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td>
<%@include file ="/s_kr/home/dataStore_list.jsp" %>
						</td>
					</tr>
					<tr>
					<tr>
						<td height="10" align="center">&nbsp;</td>
					</tr>
						<td>
<%@include file ="/s_kr/home/faq_list.jsp" %>
						</td>
					</tr>
<%if ("MUP150200001".equals( info.getSession("MENU_PROFILE_CODE"))  || "1".equals( info.getSession("BD_ADMIN"))   ){%>
					<tr>
						<td height="10" align="center">&nbsp;</td>
					</tr>
						<td>
<%@include file ="/s_kr/home/rpt_list.jsp" %>
						</td>
					</tr>
<%} %>
 				</table>
 			</td>
 		</tr>
 	</table>
</s:header>
<s:footer/>
</body>
</html>