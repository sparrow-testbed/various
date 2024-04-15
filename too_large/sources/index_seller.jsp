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
	
	String  to_day      = SepoaDate.getShortDateString();

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
	SepoaFormater wf_Not_Nml_Bid_Sup   = null;
	SepoaFormater wf_PurchaseBlockInfo = null;
	//----------------------------

	String rfq_sup_cnt      = "0";  //견적
	String bid_sup_cnt      = "0";	//입찰
	String rat_sup_cnt      = "0";	//역경매
	String con_sup_cnt      = "0";	//전자계약
	String inv_sup_cnt      = "0";	//수주현황	
	String not_nml_bid_sup_cnt      = "0";	//부적정입찰횟수(공사입찰)
	
	String purchase_block_flag = ""; //거래상태 코드
	String purchase_block_flag_name = ""; //거래상태 명
	String purchase_block_note = ""; //입찰경고,입찰금지,거래정지 사유
	
	//----------------------------

	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	try {
		//int idx = 13;
int idx = 0;
		wr = new SepoaRemote(nickName, conType, info);
		value = wr.lookup(MethodName, args);

		wf_Rfq_Sup = new SepoaFormater(value.result[idx++]);//견적
		if (wf_Rfq_Sup.getRowCount() > 0) {
			rfq_sup_cnt = wf_Rfq_Sup.getValue("RFQ_SUP_CNT", 0);
		}

		wf_Bid_Sup = new SepoaFormater(value.result[idx++]);//입찰
		if (wf_Bid_Sup.getRowCount() > 0) {
			bid_sup_cnt = wf_Bid_Sup.getValue("BID_SUP_CNT", 0);
		}
		
		wf_Rat_Sup = new SepoaFormater(value.result[idx++]);//역경매
		if (wf_Rat_Sup.getRowCount() > 0) {
			rat_sup_cnt = wf_Rat_Sup.getValue("RAT_SUP_CNT", 0);
		}
		
		wf_Con_Sup = new SepoaFormater(value.result[idx++]);//계약
		if (wf_Con_Sup.getRowCount() > 0) {
			con_sup_cnt = wf_Con_Sup.getValue("CON_SUP_CNT", 0);
		}
		
		wf_Inv_Sup = new SepoaFormater(value.result[idx++]);//수주
		if (wf_Inv_Sup.getRowCount() > 0) {
			inv_sup_cnt = wf_Inv_Sup.getValue("INV_SUP_CNT", 0);
		}
		
		wf_Not_Nml_Bid_Sup = new SepoaFormater(value.result[idx++]);//부적정입찰횟수(공사입찰)
		if (wf_Not_Nml_Bid_Sup.getRowCount() > 0) {
			not_nml_bid_sup_cnt = wf_Not_Nml_Bid_Sup.getValue("NOT_NML_BID_TCN_CNT", 0);
		}
		
		wf_PurchaseBlockInfo = new SepoaFormater(value.result[idx++]);//입찰경고 , 입찰금지 정보
		if (wf_PurchaseBlockInfo.getRowCount() > 0) {
			purchase_block_flag  = wf_PurchaseBlockInfo.getValue("PURCHASE_BLOCK_FLAG", 0);
			purchase_block_flag_name  = wf_PurchaseBlockInfo.getValue("PURCHASE_BLOCK_FLAG_NAME", 0);
			purchase_block_note  = wf_PurchaseBlockInfo.getValue("PURCHASE_BLOCK_NOTE", 0);            
		}
		
		
		
	} catch (Exception e) {
		Logger.err.println(info.getSession("ID"), this,"e ================> " + e.getMessage());
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
		<% if (!"N".equals(purchase_block_flag)){ %>
			alert("<%=purchase_block_flag_name%>\r\n\r\n사유 : <%=purchase_block_note%>\r\n\r\n-우리은행 총무부-");
		<% }else{ %>
			alert("전자구매시스템에 접속하였습니다.\r\n\r\n       -우리은행 총무부-");
		<% } %>
   <%}%>

   //gongi_popup();
   
}

function gongi_popup() {
	
	var notice01 = getCookie("notice01");
 	var notice02 = getCookie("notice02");
 	var notice05 = getCookie("notice02");
 	var notice07 = getCookie("notice07");
	
	var url01 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_01.htm";
	var url02 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_02.htm";
	var url05 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_05.htm";
	var url07 = "<%=POASRM_CONTEXT_NAME%>/Inform_pop_07.htm";
	
	if(<%=to_day%> < 20160116){	
		if(notice01 != "no") {
			window.open(url01, "", "top=2, left=2, width=400, height=260, resizable=no, scrollbars=no, status=no;");
		}
	}
	/*
	if(notice05 != "no") {
		window.open(url05, "", "top=2, left=2, width=400, height=260, resizable=no, scrollbars=no, status=no;");
 	}
 	*/
 	if(notice02 != "no") {
 		window.open(url02, "", "top=0, left=0, width=500, height=610, resizable=no, scrollbars=no, status=no;");
 	}
 	if(notice07 != "no") {
 		window.open(url07, "", "top=0, left=500, width=500, height=390, resizable=no, scrollbars=no, status=no;");
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
	var notice66 = getCookie("notice66");
	
	if(notice66 != "no") {
		var width = 510;
	    var height = 600;
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
		setCookie("notice66", "no", 1);
	}
	document.getElementById('divPopup1').style.visibility = 'hidden';
}

function open_popup2()
{
	var notice77 = getCookie("notice77");
	
	if(notice77 != "no") {
		var width = 510;
	    var height = 400;
	    var dim = new Array(2);

	    //dim = ToCenter(height,width);
	    //var top = dim[0];
	    //var left = dim[1];
	    var top = 0;
	    var left = 510;
	    
	 	document.getElementById("divPopup2").style.width = width+"px";
	    document.getElementById("divPopup2").style.height = height+"px";
	    document.getElementById("divPopup2").style.top = top+"px";
	    document.getElementById("divPopup2").style.left = left+"px";
	    //document.getElementById("divPopup2").style.top = "0px";
	    //document.getElementById("divPopup2").style.left = "0px";
	    document.getElementById("divPopup2").style.visibility = "visible";	
 	}	
}

function close_popup2(flag)
{	
	if( typeof(flag) != "undefined" && document.search.chkClose2.checked ) {
		setCookie("notice77", "no", 1);
	}
	document.getElementById('divPopup2').style.visibility = 'hidden';
}

function open_popup3()
{
	if(<%=to_day%> < 20221011){	
		var noti3 = getCookie("noti3");
		
		if(noti3 != "no") {
			var width = 510;
		    var height = 166;
		    var dim = new Array(2);
	
		    //dim = ToCenter(height,width);
		    //var top = dim[0];
		    //var left = dim[1];
		    var top = 200;
		    var left = 310;
		    
		 	document.getElementById("divPopup3").style.width = width+"px";
		    document.getElementById("divPopup3").style.height = height+"px";
		    document.getElementById("divPopup3").style.top = top+"px";
		    document.getElementById("divPopup3").style.left = left+"px";
		    //document.getElementById("divPopup3").style.top = "0px";
		    //document.getElementById("divPopup3").style.left = "0px";
		    document.getElementById("divPopup3").style.visibility = "visible";	
	 	}
	}
}

function close_popup3(flag)
{	
	if( typeof(flag) != "undefined" && document.search.chkClose3.checked ) {
		setCookie("noti3", "no", 1);
	}
	document.getElementById('divPopup3').style.visibility = 'hidden';
}

</Script>
</head>
<body leftmargin="0" topmargin="20" onLoad="Init('<%=gw_menunum%>');open_popup1();open_popup2();open_popup3();">
<s:header>
	<form name="search" >
		<input type="hidden" name="btn_flg" value="">
		<input type="hidden" name="return_flag" value="">

		<input type="hidden" name="att_mode"  value="">
		<input type="hidden" name="view_type"  value="">
		<input type="hidden" name="file_type"  value="">
		<input type="hidden" name="tmp_att_no" value="">
		
		<div id="divPopup1" style="POSITION:absolute; WIDTH:510px; HEIGHT:500px; VISIBILITY:hidden; Z-INDEX:999990; BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid; ">
			<table style="BACKGROUND-COLOR: #004C99; BORDER-BOTTOM: black thin solid;" width="510px" height="40px">
				<tr>
					<td align="middle" width="475px">
						<span style="font-size:16px; font-weight:bold; color:white">■ 『Clean계약제도』시행 안내문</span>				
					</td>				
		            <td align="right" width="35px">
						<img src="/images/dhtml/sample_close.gif" onclick="javascript:close_popup1()">&nbsp;			
					</td>				            	
				</tr>		
			</table>	
			<div style="POSITION:absolute; WIDTH:510px; HEIGHT:560px; OVERFLOW:auto;">
				<table style="BACKGROUND-COLOR: #ffffff;" width="510px" height="560px">
				    <tr height="25">
						<td height="25"></td>
					</tr>
					<tr>
						<td>
							<span style="font-size:12px; color:black">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;우리은행에서는 윤리경영을 경영전략의 중요한 축으로 채택하여 "우리윤리<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;강령"을 제정하는 등 정도경영을 위한 다양한 노력과 활동을 전개하고 있으며,<br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;투명한 은행경영 및 공정한 업무처리가 귀사와 우리은행간 상호이익 창출<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;은 물론,  사회발전과 기업경쟁력 향상의 중요한 관건임을 인식하고,  각종<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약부문의 투명성을 강화하기 위하여 Clean계약제를 시행하고 있습니다.<br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;우리은행의  계약 및 구매 관련  임직원은 은행에서 시행하는 모든 공사,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용역, 물품구매 등의 입찰, 계약체결 및 계약이행 과정에서 공정하고 투명<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하게 업무를 수행하겠으며, 계약체결 및 계약이행과 관련하여 어떠한 경우<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에도 금품, 향응, 사적금전대차(알선포함) 등을 요구하지도 않고 받지도 않겠습니다.<br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;은행 임직원이 계약 및 구매와  관련하여 금품, 향응, 사적금전대차<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(알선포함) 등의 제공을 요구하는 경우, 사이트 상단 '고객의소리'에 제보해 주시고,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이러한 제보와 관련하여 귀사에 어떠한 불이익도 없을 것을 약속 드립니다.<br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;또한 귀사에서 우리은행과 입찰, 계약체결 및 계약이행  과정에서  환경,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;인권, 회계 등 비윤리적인 문제가 발생하거나 계약 및 구매 관련 임직원에게<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;금품, 향응, 사적금전대차(알선포함) 등을 제공할 경우에는  입찰자격 제한,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계약해지 또는 거래중단 등 불이익 조치를 취할 것입니다.<br><br>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;우리은행은  경영의 투명성을 제고하기 위하여 더욱 노력할 것을 약속드리며,<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;귀사도 우리은행 윤리경영의 발전을 위해 적극 협조해 주시기 바랍니다.<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;감사합니다.<br><br>
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
		
		<div id="divPopup2" style="POSITION:absolute; WIDTH:510px; HEIGHT:400px; VISIBILITY:hidden; Z-INDEX:999991; BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid; ">
			<table style="BACKGROUND-COLOR: #004C99; BORDER-BOTTOM: black thin solid;" width="510px" height="40px">
				<tr>
					<td align="middle" width="475px">
						<span style="font-size:16px; font-weight:bold; color:white">▶ 계약 체결 시, 유의사항 안내 ◀</span>				
					</td>				
		            <td align="right" width="35px">
						<img src="/images/dhtml/sample_close.gif" onclick="javascript:close_popup2()">&nbsp;			
					</td>				            	
				</tr>		
			</table>	
			<div style="POSITION:absolute; WIDTH:510px; HEIGHT:360px; OVERFLOW:auto;">
				<table style="BACKGROUND-COLOR: #ffffff;" width="510px" height="325px">
				    <tr height="25">
						<td height="25"></td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; font-weight:bold; color:black">1. ‘시설공사계약 관련 제반서류 양식’ 이 개정되었으니,	</span>						
						</td>
					</tr>
					<tr>
						<td height="5px"></td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; color:black">자료실 內 게시물 확인 바랍니다.</span>
							</span>				
						</td>
					</tr>
					<tr>
						<td height="5px"></td>
					</tr>
					
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; font-weight:bold; color:black">2. 계약(이행)보증서 발행 시, ‘계약이행 기간(보증기간)’은</span>						
						</td>
					</tr>
					<tr>
						<td height="5px"></td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; color:black">계약기간(계약이행기일)에 60일 이상을 가산한 기간으로</span>
							</span>				
						</td>
					</tr>
					<tr>
						<td height="5px"></td>
					</tr>					
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; color:black">발행 바랍니다.</span><span style="font-size:13px; font-weight:bold; color:black">(입찰 공고문 참조)</span>						
						</td>
					</tr>
					<tr>
						<td height="25px"></td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; color:black">미이행시 반려 예정이오니, 해당 내용 숙지하시어 업무처리 바랍니다.</span>
							</span>				
						</td>
					</tr>
					<tr height="25">
						<td height="25">
						</td>
					</tr>
					<tr style="display:none;">
						<td align="center">
							 <a href="javascript:fnFiledown('1644830928688');" onfocus="this.blur()">
									<span style="font-size:15px; color:blue; font-weight:bold;">다운로드</span>
							</a>
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
							<input type="checkbox" name="chkClose2" id="chkClose2" onclick="javascript:close_popup2(1);" value="T" >&nbsp;&nbsp;<span style="font-size:12px; color:red">1일동안 열지 않음</span>&nbsp;			
						</td>				            	
					</tr>
					<tr>
						<td height="10px"></td>
					</tr>
				</table>								
			</div>
		</div>
		
		<div id="divPopup3" style="POSITION:absolute; WIDTH:510px; HEIGHT:400px; VISIBILITY:hidden; Z-INDEX:999992; BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid; ">
			<table style="BACKGROUND-COLOR: #FF0000; BORDER-BOTTOM: black thin solid;" width="510px" height="40px">
				<tr>
					<td align="middle" width="475px">
						<span style="font-size:16px; font-weight:bold; color:white">2023년 시설공사/동산 적격업체 선정을 위한 서류제출 안내</span>				
					</td>				
		            <td align="right" width="35px">
						<img src="/images/dhtml/sample_close.gif" onclick="javascript:close_popup3()">&nbsp;			
					</td>				            	
				</tr>		
			</table>	
			<div style="POSITION:absolute; WIDTH:510px; HEIGHT:125px; OVERFLOW:auto;">
				<table style="BACKGROUND-COLOR: #ffffff;" width="510px" height="125px">
				    <tr height="25">
						<td height="25"></td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:13px; font-weight:bold; color:black">자세한 내용은 공지사항을 확인 바랍니다.</span>						
						</td>
					</tr>
					<tr height="25">
						<td height="25">
						</td>
					</tr>
					<tr>
						<td align="right">
							<input type="checkbox" name="chkClose3" id="chkClose3" onclick="javascript:close_popup3(1);" value="T" >&nbsp;&nbsp;<span style="font-size:12px; color:red">1일동안 열지 않음</span>&nbsp;			
						</td>				            	
					</tr>
					<tr>
						<td height="10px"></td>
					</tr>
				</table>								
			</div>
		</div>
	</form>
<%
	Configuration conf = new Configuration();
	String profile_code = "";
	//profile_code = conf.getBoolean("wise.development.flag") ? "MUP100800001" : "MUP100700002";
	String style = profile_code.equals(info.getSession("MENU_TYPE")) ? "style='display:none;'"
			: "";
%>
	<br>
				<table width="99%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="25%">
										<table width="95%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title_summary">입찰/견적</td>
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
																<a href="javascript:linkto('/s_kr/bidding/rfq/rfq_bd_lis1.jsp','MUO141000009','1')" class="summary_title">견적요청</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/s_kr/bidding/rfq/rfq_bd_lis1.jsp','MUO141000009','1')" class="summary_no">
																	<span class="summary_num">
																		<%=rfq_sup_cnt%>
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
																<a href="javascript:linkto('/sourcing/bd_ann_list_seller.jsp','MUO141000009','1')" class="summary_title">입찰공문</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/sourcing/bd_ann_list_seller.jsp','MUO141000009','1')" class="summary_no">
																	<span class="summary_num">
																		<%=bid_sup_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<% if( 2021 != SepoaDate.getYear()){ %>
														<tr>
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center"><img src="../images/blt_summary.gif" width="9" height="9"></td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/sourcing/cs_bd_pn_list_seller.jsp','MUO141000009','1')" class="summary_title">부적정입찰횟수(공사입찰)</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/sourcing/cs_bd_pn_list_seller.jsp','MUO141000009','1')" class="summary_no">
																	<span class="summary_num">
																		<%=not_nml_bid_sup_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<% } %>														
														<!-- tr>
															<td width="15" align="center"><img src="../images/blt_summary.gif" width="9" height="9"></td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<!a href="javascript:linkto('/s_kr/bidding/rat/rat_bd_lis1.jsp','MUO141000009','1')" class="summary_title">역경매현황</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/s_kr/bidding/rat/rat_bd_lis1.jsp','MUO141000009','1')" class="summary_no">
																	<span class="summary_num">
																		<%=rat_sup_cnt%>
																	</span> 건
																</a>
															</td>
														</tr-->														 
													</table>
												</td>
											</tr>
										</table>
									</td>
									
									<% if(info.getSession("MENU_PROFILE_CODE").equals("MUP141000002")){ %>
									
									<td width="25%">
										<table width="95%" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="title_summary">수주/납품</td>
											</tr>
											<tr>
												<td class="td_line" align="left" bgcolor="#d9d9d9">
													<img src="/images/line_summary.gif" width="48" height="3">
												</td>
											</tr>
											<tr>
												<td align="center" valign="top" style="background-color:#f8f8f8; border-width:1px; border-color:#e3e3e3; padding:10px 20px 10px 10px" >
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/contract/contract_list_seller.jsp','MUO141000010','2')" class="summary_title">전자계약</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/contract/contract_list_seller.jsp','MUO141000010','2')" class="summary_no">
																	<span class="summary_num">
																		<%=con_sup_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<tr style="display:">
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td width="15" align="center">
																<img src="/images/blt_summary.gif" width="9" height="9">
															</td>
															<td width="108" height="25" class="title_s_summary" style="text-align: left;">
																<a href="javascript:linkto('/procure/order_state_list.jsp','MUO141000010','2')" class="summary_title">수주현황</a>
															</td>
															<td width="62" align="right">
																<a href="javascript:linkto('/procure/order_state_list.jsp','MUO141000010','2')" class="summary_no">
																	<span class="summary_num">
																		<%=inv_sup_cnt%>
																	</span> 건
																</a>
															</td>
														</tr>
														<% if( 2021 != SepoaDate.getYear()){ %>
														<tr style="display:">
															<td align="center"></td>
															<td height="1" colspan="2" bgcolor="#dedede"></td>
														</tr>
														<tr>
															<td height="26" colspan="3" ></td>
														</tr>
														<% } %>
													</table>
												</td>
											</tr>
										</table>
									</td>
									
									<% }  %>
									
								</tr>
							</table>

						</td>
					</tr>
					<tr>
						<td height="30">&nbsp;</td>
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
						<td height="10" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td>
<%@include file ="/s_kr/home/faq_list.jsp" %>
						</td>
					</tr>
 				</table>
 			</td>
 		</tr>
 	</table>
</s:header>
<s:footer/>
</body>
</html>