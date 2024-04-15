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
	String gb_gj     = info.getSession("GB_GJ");
	
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


	SepoaFormater wf_Rfq_Sup  = null;
	SepoaFormater wf_Bid_Sup  = null;
	SepoaFormater wf_Rat_Sup  = null;
	SepoaFormater wf_Con_Sup  = null;
	SepoaFormater wf_Inv_Sup  = null;
	//----------------------------

	String rfq_sup_cnt      = "0";  //견적
	String bid_sup_cnt      = "0";	//입찰
	String rat_sup_cnt      = "0";	//역경매
	String con_sup_cnt      = "0";	//전자계약
	String inv_sup_cnt      = "0";	//수주현황
	
	//----------------------------

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	//try {
	//	int idx = 0;
	//	wr = new SepoaRemote(nickName, conType, info);
	//	value = wr.lookup(MethodName, args);
    //
	//	wf_Rfq_Sup = new SepoaFormater(value.result[idx++]);//견적
	//	if (wf_Rfq_Sup.getRowCount() > 0) {
	//		rfq_sup_cnt = wf_Rfq_Sup.getValue("RFQ_SUP_CNT", 0);
	//	}
    //
	//	wf_Bid_Sup = new SepoaFormater(value.result[idx++]);//입찰
	//	if (wf_Bid_Sup.getRowCount() > 0) {
	//		bid_sup_cnt = wf_Bid_Sup.getValue("BID_SUP_CNT", 0);
	//	}
	//	
	//	wf_Rat_Sup = new SepoaFormater(value.result[idx++]);//역경매
	//	if (wf_Rat_Sup.getRowCount() > 0) {
	//		rat_sup_cnt = wf_Rat_Sup.getValue("RAT_SUP_CNT", 0);
	//	}
	//	
	//	wf_Con_Sup = new SepoaFormater(value.result[idx++]);//계약
	//	if (wf_Con_Sup.getRowCount() > 0) {
	//		con_sup_cnt = wf_Con_Sup.getValue("CON_SUP_CNT", 0);
	//	}
	//	
	//	wf_Inv_Sup = new SepoaFormater(value.result[idx++]);//수주
	//	if (wf_Inv_Sup.getRowCount() > 0) {
	//		inv_sup_cnt = wf_Inv_Sup.getValue("INV_SUP_CNT", 0);
	//	} 
	//	
	//} catch (Exception e) {
	//	Logger.err.println(info.getSession("ID"), this,"e ================> " + e.getMessage());
	//	Logger.dev.println(e.getMessage());
	//} finally {
	//	wr.Release();
	//} // finally 끝
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
		alert("IT전자입찰시스템에 접속하였습니다.\r\n\r\n       -우리은행 IT지원센터-");		
    <%}%>
   
   //gongi_popup();
   
}

function gongi_popup() {
	
	var notice01 = getCookie("notice01");
 	var notice02 = getCookie("notice02");
	
	var url01 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_01.htm";
	var url02 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_02.htm";
	
	if(notice01 != "no") {
		window.open(url01, "", "top=2, left=2, width=500, height=300, resizable=no, scrollbars=no, status=no;");
	}
 	if(notice02 != "no") {
 		window.open(url02, "", "top=2, left=512, width=500, height=580, resizable=no, scrollbars=no, status=no;");
 	}
	
}

function getCookie(name) {
	var Found = false;
	var start, end;
	var i = 0;
	var cookieValue = document.cookie; 
	while( i <= cookieValue.length ) {
		start = i;
		end = start + name.length;
		
		if( cookieValue.substring( start, end ) == name ) {
			Found = true;
			break;
		}
		i++;
	}
	if( Found == true ) {
		start = end + 1;
		cookieValue = cookieValue.substring(start, cookieValue.length);
		end = cookieValue.indexOf( ";" );
		if(end == -1){
			end = cookieValue.length;
		}
		return cookieValue.substring( 0, end );
	}
}

function setCookie(name, value, expiredays) {
	var today = new Date();
	today.setDate( today.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + today.toGMTString() + ";";
}

function open_popup1()
{
	var notice06 = getCookie("notice06");
	
	if(notice06 != "no") {
		var width = 450;
	    var height = 300;
	    var dim = new Array(2);

	    //dim = ToCenter(height,width);
	    //var top = dim[0];
	    //var left = dim[1];
	    var top = 0;
	    var left = 0;
	 
	    
	 	document.getElementById("divPopup1").style.width = width+"px";
	    document.getElementById("divPopup1").style.height = height+"px";
	    document.getElementById("divPopup1").style.top = top+"px";
	    document.getElementById("divPopup1").style.left = left+"px";
	    //document.getElementById("divPopup2").style.top = "0px";
	    //document.getElementById("divPopup2").style.left = "0px";
	    document.getElementById("divPopup1").style.visibility = "visible";	
 	}	
}

function close_popup1(flag)
{	
	if( typeof(flag) != "undefined" && document.search.chkClose1.checked ) {
		setCookie("notice06", "no", 1);
	}
	document.getElementById('divPopup1').style.visibility = 'hidden';
}

</Script>
</head>
<body leftmargin="0" topmargin="20" onLoad="Init('<%=gw_menunum%>');open_popup1();">
<s:header>
	<form name="search" >
		<input type="hidden" name="btn_flg" value="">
		<input type="hidden" name="return_flag" value="">

		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		
		<div id="divPopup1" style="POSITION:absolute; WIDTH:450px; HEIGHT:300px; VISIBILITY:hidden; Z-INDEX:999999; BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid; ">
			<table style="BACKGROUND-COLOR: #004C99; BORDER-BOTTOM: black thin solid;" width="450px" height="40px">
				<tr>
					<td align="middle" width="475px">
						<span style="font-size:16px; font-weight:bold; color:white">■ 개인정보유출방지 안내</span>				
					</td>				
		            <td align="right" width="35px">
						<img src="/images/dhtml/sample_close.gif" onclick="javascript:close_popup1()">&nbsp;			
					</td>				            	
				</tr>		
			</table>	
			<div style="POSITION:absolute; WIDTH:450px; HEIGHT:260px; OVERFLOW:auto;">
				<table style="BACKGROUND-COLOR: #ffffff;" width="450px" height="260px">
				    <tr height="25">
						<td height="25"></td>
					</tr>
					<tr>
						<td>
							<span style="font-size:12px; color:black">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;개인정보보호법 제24조의 2(주민등록번호 처리의 제한)에 의거하여,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;입찰 또는 계약 시에 제출하는 모든 서류에 대해서 개인정보를 삭제 후<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제출 바랍니다. <br><br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;▶ 주민등록번호 : 뒷자리 삭제 <br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;▶ 주소 : 도로명 주소 기입(상세 주소 아파트명등 미기재) <br>
				</span>				
						</td>
					</tr>								
					<tr height="25">
						<td height="25">
						</td>
					</tr>
					<tr>
						<td align="center">
							 <img src="/images/top/logo.gif"  border="0"  width="100"  height="20">
						</td>
					</tr>		
					<tr height="25">
						<td height="25">
						</td>
					</tr>
					<tr>
						<td align="right">
							<input type="checkbox" name="chkClose1" id="chkClose1" onclick="javascript:close_popup1(1);" value="T" >&nbsp;&nbsp;<span style="font-size:12px; color:red">1일동안 열지 않음</span>&nbsp;			
						</td>				            	
					</tr>
					<tr>
						<td height="10px"></td>
					</tr>
				</table>								
			</div>
		</div>
	</form>

   
	<br>
	<% if(!"J".equals(gb_gj)){ %>
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
													<a href="javascript:linkto('/ict/sourcing/bd_ann_list_seller_ict.jsp','MUO15070800004','3')" class="summary_title">입찰공문조회</a>
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
													<a href="javascript:linkto('/ict/sourcing/bd_price_list_seller_ict.jsp','MUO15070800004','4')" class="summary_title">가격입찰</a>
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
													<a href="javascript:linkto('/ict/sourcing/bd_result_list_seller_ict.jsp','MUO15070800004','5')" class="summary_title">개찰결과</a>
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
									<td class="title_summary">기본정보</td>
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
													<a href="javascript:linkto('/ict/s_kr/admin/info/ven_bd_ref2_ict.jsp','MUO15070800005','2')" class="summary_title">회사정보</a>
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
													<a href="javascript:linkto('/ict/s_kr/admin/user/use_bd_ins1_ict.jsp','MUO15070800005','3')" class="summary_title">사용자등록</a>
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
													<a href="javascript:linkto('/ict/s_kr/admin/user/use_bd_lis2_ict.jsp','MUO15070800005','5')" class="summary_title">사용자현황</a>
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