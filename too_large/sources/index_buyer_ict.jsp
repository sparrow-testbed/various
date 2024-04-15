<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private boolean isAdmin(SepoaInfo info){
	String  adminMenuProfileCode = null;
	String  menuProfileCode      = null;
	String  propertiesKey        = null;
	String  houseCode            = info.getSession("HOUSE_CODE");
	boolean result               = false;
	
	try {
		menuProfileCode      = info.getSession("MENU_PROFILE_CODE");
		menuProfileCode      = this.nvl(menuProfileCode);
		propertiesKey        = "wise.all_admin.profile_code." + houseCode;
		adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
   		if (menuProfileCode.equals(adminMenuProfileCode)){
   			result = true;
    	} else {
   			propertiesKey        = "wise.admin.profile_code." + houseCode;
			adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);
		
			if (menuProfileCode.equals(adminMenuProfileCode)){
    			result = true;
	    	} else {
				propertiesKey        = "wise.ict_admin.profile_code." + houseCode;
				adminMenuProfileCode = CommonUtil.getConfig(propertiesKey);

				if (menuProfileCode.equals(adminMenuProfileCode)){
	    			result = true;
			    }
			}
    	}
	} catch (Exception e) {
		result = false;
	}
	
	return result;
}
%>
<%
	String WISEHUB_PROCESS_ID = "s0010";
	String WISEHUB_LANG_TYPE = "KR";

	//Logger.debug.println("AAA", this,  "================ summary_t.jsp start ");
	//long start_time1 = System.currentTimeMillis ();
	//	Thread.sleep(2000);

	String dept_code = info.getSession("DEPARTMENT");	
	String ctrl_code = info.getSession("CTRL_CODE");
	String  menuProfileCode      = this.nvl(info.getSession("MENU_PROFILE_CODE"));

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
	SepoaFormater wf_Item2  = null;


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
	String itemWaiting_cnt2 = "0";

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Main</title>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language="javascript" src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script type='text/javascript'>
function linkto(url, muo, topId){
	topMenuClick(url, muo, topId, '');
}

function Init(gw_menunum)
{

//MUP150700001
//linkto('/ict/sourcing/bd_ann_list_ict.jsp','MUO15070800001','');
//topMenuClick(''/ict/sourcing/bd_ann_list_ict.jsp', 'MUO15070800001', '', '');
//return;
	if( "<%=menuProfileCode%>" != null && "<%=menuProfileCode%>" == "MUP220800001"){
		topMenuClick('/ict/sourcing/bd_ct_confirm_list_ict2.jsp', 'MUO22080400001', '', '');	
	}else if( "<%=menuProfileCode%>" != null && "<%=menuProfileCode%>" == "MUP180900001"){
		topMenuClick('/ict/kr/dt/rfq/rfq_bz_ins_ict.jsp', 'MUO18062700001', '', '');	
	}
	
	if(gw_menunum != null || gw_menunum != "0")
	{
		if(gw_menunum == "1") {
			linkto('/kr/admin/basic/approval2/ap2_bd_lis2.jsp','' );
		}else if(gw_menunum =="2") {
			linkto('/kr/dt/app/app_bd_lis1.jsp','' );
		}else if(gw_menunum =="3") {
			linkto('/kr/order/bpo/po7_bd_lis1.jsp','' );
		}else if(gw_menunum =="4") {
			linkto('/kr/order/ivdp/inv1_bd_lis1.jsp','' );
		}else if(gw_menunum =="5") {
			linkto('/kr/master/vendor/sta_bd_lis1.jsp','' );
		}else if(gw_menunum =="6") {
			linkto('/kr/master/new_material/confirm_bd_lis1.jsp','' );
		}
	}
}

</Script>
</head>
<body leftmargin="0" topmargin="20" onLoad="Init('<%=gw_menunum%>')">
<s:header>
    <% 
    	// ICT_내부사용자_주관부서(MUP150700001) , ICT_내부사용자(MUP180900002) , ICT_내부관리자_주관부서(MUP150700003)
    	if(menuProfileCode != null && ("MUP150700001".equals(menuProfileCode) || "MUP180900002".equals(menuProfileCode)  || "MUP150700003".equals(menuProfileCode))) {  
    
    %>
	<form name="search" >
		<input type="hidden" name="btn_flg" value="">
		<input type="hidden" name="return_flag" value="">

		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
	</form>


	<br>
 
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="25%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">입찰관리</td>
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
													<a href="javascript:linkto('/ict/sourcing/bd_ann_list_ict.jsp','MUO15070800001','2')" class="summary_title">입찰공문</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/sourcing/bd_confirm_list_ict.jsp','MUO15070800001','3')" class="summary_title">입찰자적격확인</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/sourcing/bd_req_prepare_list_ict.jsp','MUO15070800001','4')" class="summary_title">내정가격 등록요청</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/sourcing/bd_prepare_list_ict.jsp','MUO15070800001','5')" class="summary_title">내정가격 등록</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/sourcing/bd_open_list_ict.jsp','MUO15070800001','6')" class="summary_title">입찰현황/개찰</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/sourcing/bd_result_list_ict.jsp','MUO15070800001','7')" class="summary_title">개찰결과</a>
												</td>
											</tr>
											<tr>
												<td height="1" colspan="2"></td>
											</tr> 
											<tr>
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;" colspan="2">
													&nbsp;
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
						<td width="25%">
							<table width="95%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="title_summary">업체관리</td>
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
													<a href="javascript:linkto('/ict/kr/master/register/vendor_reg_lis_ict.jsp','MUO15070800002','2')" class="summary_title">등록 업체 진행 목록</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/kr/master/register/vendor_reg_lis2_ict.jsp','MUO15070800002','3')" class="summary_title">협력사 현황</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/ict/admin/user_status_ict.jsp?sign_status=A','MUO15070800002','5')" class="summary_title">사용자현황</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/admin/bulletin_write_new_ict.jsp','MUO15070800002','8')" class="summary_title">공지사항쓰기</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/admin/bulletin_list_new_ict.jsp','MUO15070800002','9')" class="summary_title">공지사항목록</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/admin/write_data_store_ict.jsp','MUO15070800002','11')" class="summary_title">자료실쓰기</a>
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
												<td width="108" height="25" class="title_s_summary" align="left" style="text-align: left;">
													<a href="javascript:linkto('/admin/data_store_list_ict.jsp','MUO15070800002','12')" class="summary_title">자료실목록</a>
												</td>
											</tr>
											<tr>
												<td align="center"></td>
												<td height="1" colspan="2" bgcolor="#dedede"></td>
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
		<tr>
			<td height="15">&nbsp;</td>
		</tr>
		<tr>
			<td height="15">&nbsp;</td>
		</tr>
		<tr>
			<td height="15">&nbsp;</td>
		</tr>
		<tr>
			<td height="15">&nbsp;</td>
		</tr>
		<tr> 
			<td height="15">&nbsp;</td>
		</tr>

	</table>
	<% } %>
</s:header>
<s:footer/>
</body>
</html>