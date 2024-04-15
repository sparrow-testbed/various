<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils, java.util.Calendar" %>
<%@ page import="java.util.Map" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%
	SepoaInfo info = sepoa.fw.ses.SepoaSession.getAllValue(request);

	String from_site = info.getSession("FROM_SITE");
	
	String os_gb = info.getSession("OS_GB");
	

%>
<script type="text/javascript">
function logout(){
	if(confirm("로그아웃 하시겠습니까?")){
		location.href = "<%=POASRM_CONTEXT_NAME%>/common/logout_process.jsp";
	}
}

/*
function doScss(){
	if(confirm("업체탈퇴 하시겠습니까?")){
		location.href = "<%=POASRM_CONTEXT_NAME%>/common/scss_process_ict2.jsp";
	}
}
*/

function doScss(){
	if(confirm("업체탈퇴 요청 하시겠습니까?")){
		location.href = "<%=POASRM_CONTEXT_NAME%>/common/scss_req_process_ict2.jsp";
	}
}

function os_select(event)
{
	 var width = 320;
     var height = 200;
//   var dim = new Array(2);

//   dim = ToCenter(height,width);
//   var top = dim[0];
//   var left = dim[1];
//   style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px"
 	
 	 var top = event.clientY;
     var left = event.clientX - width;
     
     document.getElementById("divOS").style.width = width+"px";
     document.getElementById("divOS").style.height = height+"px";
     document.getElementById("divOS").style.top = top+"px";
     document.getElementById("divOS").style.left = left+"px";
     document.getElementById("divOS").style.visibility = "visible";
     
//	MM_openBrWindow("common/idpwd.jsp", "login_idpwd", "440", "380");
	
}

function os_un_select()
{
	/*
	signform.rdoWin7.checked = false;
	signform.rdoWin10.checked = false;
	*/
	document.getElementById('rdoWin7').checked = false;
    document.getElementById('rdoWin10').checked = false;
	
	document.getElementById('divOS').style.visibility = 'hidden';
}

function goMyPage2()
{
	if (!document.getElementById('rdoWin7').checked && !document.getElementById('rdoWin10').checked)
	{
		alert("OS(운영체재)를 선택하세요.");
		return;
	}
	var os_gb = "";
	if(document.getElementById('rdoWin7').checked){
		os_gb = "win7";    
	}else{
		os_gb = "win10";
	}
	
	var width  = '840';
	var height = '600';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	
	
	<%if ("ICT".equals(from_site)){%>
		var url    = "/ict/s_kr/admin/user/use_bd_updf_ict.jsp?i_flag=N&user_flag=Y&user_id=<%=info.getSession("ID")%>&os_gb="+os_gb;
	<%}else{%>
		var url    = "/s_kr/admin/user/use_bd_updf.jsp?i_flag=N&user_flag=Y&user_id=<%=info.getSession("ID")%>&os_gb="+os_gb;
	<%}%>

	var name   = "BKWin";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}


function goMyPage(){
	var width  = '840';
	var height = '600';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	<%if ("ICT".equals(from_site)){%>
		var url    = "/ict/s_kr/admin/user/use_bd_updf_ict.jsp?i_flag=N&user_flag=Y&user_id=<%=info.getSession("ID")%>&os_gb=<%=os_gb%>";
	<%}else{%>
		var url    = "/s_kr/admin/user/use_bd_updf.jsp?i_flag=N&user_flag=Y&user_id=<%=info.getSession("ID")%>&os_gb=<%=os_gb%>";
	<%}%>

	var name   = "BKWin";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function fnNoticePop(strFlag){
	var width  = '650';
	var height = '450';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	var url    = "";
	if (strFlag == "ICT"){
		url = "/common/index_buyer_notice_pop_ict.jsp";
	}
	else
	{
		url = "/common/index_buyer_notice_pop.jsp";
	}

	var name   = "Notice";
	var option = "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function fnDataStorePop(strFlag) {
	var width  = '650';
	var height = '450';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];

	var url    = "";
	if (strFlag == "ICT"){
		url = "/common/index_buyer_dataStore_pop_ict.jsp";
	}
	else
	{
		url = "/common/index_buyer_dataStore_pop.jsp";
	}

	var name   = "Notice";
	var option = "top=" + top + ",left=" + left + ",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function fnFaqList(){
	var width  = '650';
	var height = '450';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	var url    = "/common/index_buyer_faq_pop.jsp";
	var name   = "FAQ";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function fnRptList(){
	var width  = '850';
	var height = '450';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	var url    = "/common/index_buyer_rpt_pop.jsp";
	var name   = "RPT";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=yes";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function doScssPopup()
{
	var width  = '300';
	var height = '140';
	var dim    = ToCenter(width, height);
	var top    = dim[0];
	var left   = dim[1];
	var url    = "/common/scss_popup_ict2.jsp";
	var name   = "SCSS";
	var option = "top="+top+",left="+left+",width=" + width + ",height=" + height + ",resizable=yes,status=yes,scrollbars=auto";
	var winobj = window.open(url, name, option);
	
	winobj.focus();
}

function sel_dept_onChange(dept){
	
	if(confirm("관리부점을 변경하시겠습니까?") != 1) {
		dept.value = '<%=info.getSession("DEPARTMENT")%>';
		return;
	}
	
	document.forms[0].action = '/common/info_change_process_ict.jsp?dept='+encodeUrl(dept.value)+'&deptnm='+encodeUrl(dept.options[dept.selectedIndex].text);
	document.forms[0].method = 'POST';
	document.forms[0].target = '_self';
	document.forms[0].submit();
	
}


</script>
<div id="wrap"> 
<%
	if("false".equals(request.getParameter("popup"))){
%>	
	<table width="100%" height="70" border="0" cellpadding="0" cellspacing="0" id="header">
		<tr>
			<td width="212px" rowspan="2" align="center" valign="middle">
				<%if ("ICT".equals(info.getSession("FROM_SITE")) ){%>
						<%if("WOORI".equals(info.getSession("USER_TYPE"))){%>
							<img src="/images/top/logo.gif" width="212" height="39" border="0" hspace="7" onclick="javascript:location.href='<%=POASRM_CONTEXT_NAME%>/common/index_buyer_ict.jsp';" />
						<%}else{%>
							<img src="/images/top/logo.gif" width="212" height="39" border="0" hspace="7" onclick="javascript:location.href='<%=POASRM_CONTEXT_NAME%>/common/index_seller_ict.jsp';" />
						<% } %>
				<%}else{ %>
						<%if("WOORI".equals(info.getSession("USER_TYPE"))){%>
							<img src="/images/top/logo.gif" width="212" height="39" border="0" hspace="7" onclick="javascript:location.href='<%=POASRM_CONTEXT_NAME%>/common/index_buyer.jsp';" />
						<%}else{%>
							<img src="/images/top/logo.gif" width="212" height="39" border="0" hspace="7" onclick="javascript:location.href='<%=POASRM_CONTEXT_NAME%>/common/index_seller.jsp';" />
						<% } %>
				<%} %>
			</td>
			<td height="29" colspan="2">
				<table width="100%" height="29" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="36%" align="left" valign="top" style="display: none;">
							<img src="/images/top/util_portal.gif" width="69" height="25" onclick="javascript:alert('준비중입니다.');" style="cursor: pointer;"/><img src="/images/top/util_wins.gif" width="62" height="25" onclick="javascript:alert('준비중입니다.');" style="cursor: pointer;"/>
						</td>
						<%if ("ICT".equals(info.getSession("FROM_SITE")) ){%>
								<%if ("WOORI".equals( info.getSession("COMPANY_CODE")) ){%>
										<%if ("MUP150700001".equals( info.getSession("MENU_PROFILE_CODE")) || "MUP150700003".equals( info.getSession("MENU_PROFILE_CODE")) ){%>
												<td width="64%" align="right">
													<table height="29" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="300" align="right">
																																																
																<span class="usergroup">																	
																	<select name="sel_dept" id="sel_dept" class="inputsubmit" onChange="javacsript:sel_dept_onChange(this);">													
																	<%
																		String  lb_item_no = ListBox(request, "SL0155","", info.getSession("DEPARTMENT"));
																		out.println(lb_item_no);
																	%>												
															     	</select>	
																 / </span>
																<span class="user"><%=info.getSession("NAME_LOC")%></span>
																<span class="usergroup">님</span>
																<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
																&nbsp;&nbsp;
															</td>
															<td width="*" valign="top">
																<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('ICT');" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('ICT');" style="cursor: pointer;"/>
															</td>
															<td width="5" valign="top">&nbsp;</td>
														</tr>
													</table>
												</td>
										<%}else{ %>	
												<td width="64%" align="right">
													<table height="29" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="300" align="right">
																<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
																<span class="user"><%=info.getSession("NAME_LOC")%></span>
																<span class="usergroup">님</span>
																<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
																&nbsp;&nbsp;
															</td>
															<td width="*" valign="top">
																<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('ICT');" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('ICT');" style="cursor: pointer;"/>
															</td>
															<td width="5" valign="top">&nbsp;</td>
														</tr>
													</table>
												</td>
										<%} %>		
								<%}else{ %>			
								<td width="64%" align="right">
									<table height="29" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="300" align="right">
												<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
												<span class="user"><%=info.getSession("NAME_LOC")%></span>
												<span class="usergroup">님</span>
												<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
												&nbsp;&nbsp;
											</td>
											<td width="*" valign="top">
												<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('ICT');" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('ICT');" style="cursor: pointer;"/>
											</td>
											<td width="5" valign="top">&nbsp;</td>
										</tr>
									</table>
								</td>
								<%} %>
						<%}else{ %>
						
								<%if ("WOORI".equals( info.getSession("COMPANY_CODE")) ){%>
										<%if ("MUP150200001".equals( info.getSession("MENU_PROFILE_CODE")) ){%>
												<td width="64%" align="right">
													<table height="29" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="300" align="right">
																<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
																<span class="user"><%=info.getSession("NAME_LOC")%></span>
																<span class="usergroup">님</span>
																<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
																&nbsp;&nbsp;
															</td>
															<td width="360" valign="top">
																<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('');" style="cursor: pointer;"/><img src="/images/top/util_pds.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('');" style="cursor: pointer;"/><img src="/images/top/util_rpt.gif"    width="60" height="25" onclick="javascript:fnRptList();" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="57" height="25" onclick="javascript:fnFaqList();" style="cursor: pointer;"/>																											
															</td>
															<td width="5" valign="top">&nbsp;</td>
														</tr>
													</table>
												</td>
										<%}else{ %>	
												<%if ("1".equals( info.getSession("BD_ADMIN")) ){%>			
														<td width="64%" align="right">
															<table height="29" border="0" cellspacing="0" cellpadding="0">
																<tr>
																	<td width="300" align="right">
																		<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
																		<span class="user"><%=info.getSession("NAME_LOC")%></span>
																		<span class="usergroup">님</span>
																		<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
																		&nbsp;&nbsp;
																	</td>
																	<td width="360" valign="top">
																		<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('');" style="cursor: pointer;"/><img src="/images/top/util_pds.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('');" style="cursor: pointer;"/><img src="/images/top/util_rpt.gif"    width="60" height="25" onclick="javascript:fnRptList();" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="57" height="25" onclick="javascript:fnFaqList();" style="cursor: pointer;"/>																											
																	</td>
																	<td width="5" valign="top">&nbsp;</td>
																</tr>
															</table>
														</td>
												<%}else{ %>	
														<td width="64%" align="right">
															<table height="29" border="0" cellspacing="0" cellpadding="0">
																<tr>
																	<td width="300" align="right">
																		<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
																		<span class="user"><%=info.getSession("NAME_LOC")%></span>
																		<span class="usergroup">님</span>
																		<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
																		&nbsp;&nbsp;
																	</td>
																	<td width="300" valign="top">
																		<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('');" style="cursor: pointer;"/><img src="/images/top/util_pds.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('');" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="57" height="25" onclick="javascript:fnFaqList();" style="cursor: pointer;"/>														
																	</td>
																	<td width="5" valign="top">&nbsp;</td>
																</tr>
															</table>
														</td>
												<%} %>
												
										<%} %>
									
								<%}else{ %>														
										<td width="64%" align="right">
											<table height="29" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="300" align="right">
														<span class="usergroup"><%=info.getSession("DEPARTMENT_NAME_LOC")%> / </span>
														<span class="user"><%=info.getSession("NAME_LOC")%></span>
														<span class="usergroup">님</span>
														<img src="/images/top/btn_logout.gif" width="47" height="20" align="absmiddle" onclick="javascript:logout();" style="cursor: pointer;"/>
														&nbsp;&nbsp;
													</td>
													<td width="360" valign="top">
														<img src="/images/top/util_mypage.gif" width="82" height="25" onclick="javascript:goMyPage();" style="cursor: pointer;"/><img src="/images/top/util_notice.gif" width="69" height="25" onclick="javascript:fnNoticePop('');" style="cursor: pointer;"/><img src="/images/top/util_pds.gif"    width="60" height="25" onclick="javascript:fnDataStorePop('');" style="cursor: pointer;"/><img src="/images/top/util_rpt.gif"    width="60" height="25" onclick="javascript:topMenuClick('/admin/rpt_write_new.jsp', 'MUO141000008', '4', '');" style="cursor: pointer;"/><img src="/images/top/util_faq.gif"    width="57" height="25" onclick="javascript:fnFaqList();" style="cursor: pointer;"/>
													</td>
													<td width="5" valign="top">&nbsp;</td>
												</tr>
											</table>
										</td>	
								<%} %>
								

						<%} %>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="45" width="100%"  style="background-image:url(/images/top/bg_menu.gif); background-repeat:repeat-x; background-position:left">
				<table height="45" width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table height="45" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<%=session.getAttribute("MENU_TOP") %>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td>
				<img src="/images/blank.gif" width="5" height="1" />
			</td>
		</tr>
	</table>
<%
	}
%>
	<div id="container">
		<div id="contents-box">
<%
	if("false".equals(request.getParameter("popup"))){
%>  
			<div id="snb" style="width:212px; background-color:#f5f5f5;border :0px;">
				<table width="212" border="0" cellspacing="0" cellpadding="0" height="100%">
					<tr>
						<td width="212" align="right" valign="top" style="padding-left:5">
							<table width="212" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<table width="212" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td style="height:49px; background:url(/images/menu/bg_category_title.gif) no-repeat;">
													<table style="height:37px;" width="212" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td style="padding-left:42px; font:14px 'dotum'; text-align: left;">
																<b style="color:#375a93">e-Procurement</b>
															</td>
															<td width="9">
																<img src="/images/menu/btn_hide.gif" width="11" height="48" onclick="javascript:hideAndShowMenu();"/>
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<tr>
												<td height="100%" valign="top" style="background:#f6f6f6; background:url(/images/menu/bg_menu.gif) repeat-y; text-align: left;">
													<div id="treeboxbox_tree" style="height:100%;background: -webkit-linear-gradient(left, #FFF, #F5F5F5); padding:5px 5px 5px 5px;"></div>
												</td>
											</tr>											
											<%if ("MUP150700002".equals(info.getSession("MENU_PROFILE_CODE"))) {%>
												<tr>
													<td valign="top" align="left">
														<font class="title_summary" color="black" style="font-size:15px">【담당자 연락처】</font>
													</td>
												</tr>
												<tr>
													<td valign="top" align="left" height="160">
														<br>
														<font color="black" style="font-size:12px">&nbsp; 차영주 부장대우 [02-2002-3176]</font><br>
														<font color="black" style="font-size:12px">&nbsp; 오승룡 차장 [02-2002-5709]</font><br>
														<font color="black" style="font-size:12px">&nbsp; 김안숙 과장 [02-2002-5161]</font><br>
														<font color="black" style="font-size:12px">&nbsp; 신은진 과장 [02-2002-5362]</font><br>
														<font color="black" style="font-size:12px">&nbsp; 김혜정 대리 [02-2002-3139]</font><br>
														<font color="black" style="font-size:12px">&nbsp; 송보람 계장 [02-2002-5375]</font>
																											
													</td>																					
												</tr>
												<tr>
												<td valign="top" align="left" height="35">
													<br>
													<font class="title_summary" color="black" style="font-size:15px"><a href="#" onclick="javascript:doScssPopup();">【업체탈퇴요청】</a></font><br>														
												</td>
											</tr>																																		
											<%}%>
											
											<%if ("MUP141000003".equals(info.getSession("MENU_PROFILE_CODE"))) {%>
												<tr>
													<td valign="top" align="left">
														<font class="title_summary" color="black" style="font-size:18px">신청문의<br><br></font>
														<font color="black" style="font-size:12px">&nbsp; 간판 홍보물 &nbsp; 80001-3568<br></font>
														<font color="black" style="font-size:12px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80001-3653<br></font>
														<font color="black" style="font-size:12px">&nbsp; 안내장 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80002-3277<br></font>
														<font color="black" style="font-size:12px">&nbsp; 안내장(카드) 02-6968-3061<br></font>
														<font color="black" style="font-size:12px">&nbsp; 집기류 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80001-3642<br></font>
														<font color="black" style="font-size:12px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80001-3624<br></font>
														<font color="black" style="font-size:12px">&nbsp; 시설물 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 80001-3983<br></font>
													</td>
												</tr>
											<%}%>


<%
		String recentMenuObjectCode = (String) session.getAttribute("RECENT_MENU_OBJECT_CODE");

		@SuppressWarnings("unchecked")
		Map<String, String> leftMenuMap = (Map<String, String>) session.getAttribute("LEFT_MENU");
		String leftMenu = leftMenuMap.get(recentMenuObjectCode);
%>
<script type="text/javascript">
$('#snb').css('height', ($(window).height() - $('#header').height() - 20) + 'px');

var dhtmlxTree = null;

function setTreeDraw(){
	dhtmlxTree = new dhtmlXTreeObject("treeboxbox_tree", "100%","100%", 0);
	
	dhtmlxTree.setSkin('dhx_skyblue');
	dhtmlxTree.setImagePath("<%=POASRM_CONTEXT_NAME %>/dhtmlx/dhtmlx_full_version/imgs/csh_bluefolders/");
	dhtmlxTree.enableHighlighting(true);
	dhtmlxTree.enableTreeImages(false);	
	dhtmlxTree.loadXMLString("<%=leftMenu%>");
	dhtmlxTree.attachEvent("onClick",leftMenuClick);
	
	var kids = dhtmlxTree.getAllChildless();
	var kidsArr = kids.split(",");
	
	for(var id in kidsArr){
		var text = dhtmlxTree.getItemText(kidsArr[id]);
		
		dhtmlxTree.setItemText(kidsArr[id],'<img src=<%=POASRM_CONTEXT_NAME %>/dhtmlx/dhtmlx_full_version/imgs2/ico_lm_noSelect.gif>&nbsp;'+text);
	}
		
<%
		String treeMenuId = (String)session.getAttribute("treeMenuId");
		StringBuffer sb = new StringBuffer();
						
		if(treeMenuId != null && !"".equals(treeMenuId) && !"null".equals(treeMenuId)){
			// 2015-12-21 : 소스스캔에서 취약점(XSS)으로 발견되었으나, 사용자의 입력값을 사용하지 않으므로 대상제외.
			out.println("dhtmlxTree.selectItem('"+treeMenuId+"',false,false); "); 
			out.println("dhtmlxTree.focusItem('"+treeMenuId+"'); ");
			out.println("dhtmlxTree.setItemText('"+treeMenuId+"',dhtmlxTree.getItemText('"+treeMenuId+"').replace('ico_lm_noSelect.gif','ico_lm_select.gif'));");
		}

		out.println("$('span.standartTreeRow').css('padding-left','0px');");
		out.println("$('span.selectedTreeRow').css('padding-left','0px');");		
%>
		
}
</script>

											<tr>
												<td height="1">
													<img src="/images/blank.gif" width="212" height="1" style="background:#e0e0e0;">
												</td>
											</tr>
											<tr>
												<td height="10">
													<img src="/images/blank.gif" width="212" height="7">
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
<%
	}
%> 

<div id="divOS" style="POSITION:absolute; WIDTH:320px; HEIGHT:200px; VISIBILITY:hidden; TOP:200px; LEFT:320px; z-index: 9999">
	<table style="BORDER-BOTTOM: black thin solid; BORDER-LEFT: black thin solid; BACKGROUND-COLOR: #ffffff; BORDER-TOP: black thin solid; BORDER-RIGHT: black thin solid">
		<tr>
			<td colspan="4" width="320px">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td align="middle">
		    	&nbsp;
			</td>	
			<td colspan="2" align="middle">
				<span style="font-size:18px; font-weight:bold; color:black">OS(운영체재) 구분</span>
			</td>
			<td align="middle">
		    	&nbsp;
			</td>	
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>		
		<tr>
		    <td align="middle">
		    	&nbsp;
			</td>		    			
			<td colspan="2" align="middle">
				<input value="win7" name="rdoWin" id="rdoWin7" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 7</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input value="win10" name="rdoWin" id="rdoWin10" type="radio"/>&nbsp;<span style="font-size:13px; font-weight:bold; color:black">WINDOW 10</span>
			</td>
			<td align="middle">
		    	&nbsp;
			</td>	
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>		
		<tr>
			<td align="middle">
		    	&nbsp;
			</td>	
			<td align="right">
				<script language="javascript">btn("javascript:goMyPage2()"		, "선 택")	</script>				
			</td>
			<td align="left">
				<script language="javascript">btn("javascript:os_un_select()"		, "닫 기")	</script>				
			</td>	
			<td align="middle">
		    	&nbsp;
			</td>			
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;<span style="font-size:12px; font-weight:bold; color:red">* OS(운영체재) - Window7 , 브라우저 - IE11</span><br>&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:12px; font-weight:bold; color:blue">에 최적화 되었습니다.</span>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				&nbsp;
			</td>
		</tr>	
	</table>
</div>     

			<%--<div style="position:relative;"></div> --%>
			<div id="content">
<%
	if("false".equals(request.getParameter("popup"))){
%>   
				<span id="leftHideid" class="leftHide" style="display: none;">
					<img src="<%=POASRM_CONTEXT_NAME%>/images/common/btn_leftOff.gif?type=w2" alt="click" id="click1" onclick="javascript:hideAndShowMenu();" style="cursor: pointer;">
				</span>
         
<%
	}
	else{
%>
<script type="text/javascript">
document.getElementById('content').style.marginLeft = '0px';
</script>
<%
	}
%>
				<div id="head_area">				