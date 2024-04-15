<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>


<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_102");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
%>

<%!
	public String getNodeInfo(SepoaInfo info, String sg_refitem)
	{
	    String nickName= "SR_001";
	    String conType = "CONNECTION";
	    String MethodName = "getNodeInfo";
	    sepoa.fw.srv.SepoaOut value = null; 
	    Object[] obj = {sg_refitem};
	    sepoa.fw.util.SepoaRemote ws = null;
	
	    try {
	        ws = new sepoa.fw.util.SepoaRemote(nickName,conType,info);
	        value = ws.lookup(MethodName,obj);
	        
	    }catch(Exception e) {
	    
	    } finally{
	        ws.Release();
	    }	
	    return value.result[0];
	}
%>


<%
    	String ret = "";
    	
    	String sg_name = "";
    	String sg_def = "";
    	String remark = "";
    	String notice = "";
    	String s_temp = "";
    	String c_temp = "";
    	String condition = "";
    	String charge = "";
    	String st_num = "";
    	String ct_num = "";
    	String user_id = "";
    	String type = "";
    	String mode = JSPUtil.CheckInjection(request.getParameter("mode"))==null?"":JSPUtil.CheckInjection(request.getParameter("mode"));
    	String sg_refitem = JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));
    	
    	if(mode.equals("view")) 
    	{
    		ret = getNodeInfo(info, sg_refitem);
    		SepoaFormater wf =  new SepoaFormater(ret);

    		if(wf.getRowCount() > 0) 
    		{
		    	sg_name = wf.getValue("SG_NAME", 0);
		    	sg_def = wf.getValue("DEFINITION", 0);
		    	remark = wf.getValue("SPECIAL_REMARK", 0);
		    	notice = wf.getValue("IS_NOTICE", 0);
		    	s_temp = wf.getValue("S_TEMP", 0);
		    	c_temp = wf.getValue("C_TEMP", 0);
		    	condition = wf.getValue("PURCHASE_CONDITION", 0);
		    	charge = wf.getValue("USER_NAME_LOC", 0);
		    	st_num = wf.getValue("S_TEMPLATE_REFITEM", 0);
		    	ct_num = wf.getValue("C_TEMPLATE_REFITEM", 0);
		    	user_id = wf.getValue("USER_ID", 0);
		    	type = wf.getValue("TYPE", 0);
			}
    	}

	String this_image_folder_name = "";
	String this_session_user_type = "";
	String this_request_language = JSPUtil.nullChk(request.getParameter("language")).toUpperCase();
	String this_menu_order = "0";
    	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%-- <%@ include file="/include/include_css.jsp"%> --%>
<link rel="stylesheet" href="/css/sec_pop.css" type="text/css">
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>

<Script language="javascript">
    
	function tmp_pop(mode) {
		var left = 0;
		var top = 0;
		var width = 600;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'no';
		var resizable = 'no';
<%--		var url = "sou_stmp_pop.jsp?mode=" + mode; --%>
		var url = "scg_meaning_temple.jsp?mode=" + mode;
		var doc = window.open( url, 'doc', 'left=0, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		
	}
	
	function s_select(mode, no, name) {
		f = document.form1;
		if(mode == 's_tmp') {
			f.st.value = name;
			f.st_num.value = no;
		}else{
			f.ct.value = name;
			f.ct_num.value = no;
		}
	}
	
	function searchCharge() {
		
		PopupCommon1("SP5004", "user_select", "", "ID", "사용자명");
//		var left = 0;
//		var top = 0;
//		var width = 600;
//		var height = 500;
//		var toolbar = 'no';
//		var menubar = 'no';
//		var status = 'yes';
//		var scrollbars = 'no';
//		var resizable = 'no';
<%--		var url = "sou_pp_lis2.jsp"; --%>
//		var url = "scg_meaning_user.jsp";
//		var doc = window.open( url, 'doc', 'left=0, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		
	}

	function user_select(user_id, user_name) {
		f = document.form1;
		f.user_id.value = user_id;
		f.username.value = user_name;
		
	}
		
	function sg_update() {
		f = document.form1;
		
		if(f.sgname.value == '') { // 소싱그룹명
			alert('소싱그룹이름을 입력하십시요.');
			//alert("<%=text.get("소싱그룹이름을 입력하십시요.")%>");
			return;
		}
		/**
		if(f.st_num.value == ''){
			if(f.noticedivision[0].checked){
				//alert("Screening AUCA¸´AC °ªAI ¾øA¸¸e °O½ACO ¼o ¾ø½A´I´U.");
				alert("<%=text.get("SR_102.MSG_0101")%>");
				return;
			}
		}
		**/
		if(f.noticedivision[0].checked) {
			f.is_notice.value = "Y";
		}else{
			f.is_notice.value = "N";
		}
		if(f.user_id.value == '') { // 담당자명
			//alert('담당자명을 입력하세요.');
			alert("담당자명을 입력하세요.");
			return;
		}
		
		f.target = "hiddenframe";
		
		f.action = "scg_meaning_menu.jsp";
		f.submit();
	}
	-->
	</SCRIPT>

	
</head>
	
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">

<form name="form1" action="" method="post" >
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>
	<%@ include file="/include/include_top.jsp"%>
	<tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0">
		
		
			<tr>
				<%@ include file="/include/include_menu.jsp"%>

				<td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">

						<table width="97%" height="80%" border="0" cellspacing="1" cellpadding="0" bgcolor="#DBDBDB" >
							<tr> 
								<td style="font-family: 'Arial'; background-image: url(../images/div_colm_re.gif);background-repeat: no-repeat;background-position: right;background-color: F6F6F6;font-size: 12px;height: 25px;letter-spacing: -1px;padding-top: 2px;color: black;padding-left: 0px;text-align: center;" class="div_input"   nowrap><%--<%=text.get("SR_102.TEXT_0102")%>--%>
								소싱그룹명
								</td>
								<td class="div_data" nowrap> 
									<input type="hidden" name="sgrefitem" value="<%=sg_refitem%>">
									<input type="text" class="text" size="50" name="sgname" value="<%=sg_name%>">
                            	</td>
                         	</tr> 
				 			<tr> 
								<td class="div_input"   nowrap>소싱그룹정의 <%-- <%=text.get("SR_102.TEXT_0104")%>--%></td>
								<td class="div_data" nowrap> 
								  <textarea class="textarea" rows="4" cols="45" name="definition"><%=sg_def%></textarea>
                                </td>
                            </tr> 
							<tr> 
								<td class="div_input"   nowrap>소싱그룹사용여부<%--<%=text.get("SR_102.TEXT_0105")%>--%></td>
								<td class="div_data" nowrap> 
                                	사용<%--<%=text.get("SR_102.TEXT_0201")%> --%><input type=radio name="noticedivision" checked value="1" class=radio <%if(notice.equals("Y")) {%>checked<%}%>>
									미사용<%--<%=text.get("SR_102.TEXT_0202")%> --%><input type=radio name="noticedivision" value="2" class=radio <%if(notice.equals("N")) {%>checked<%}%>>
									<input type="hidden" name="is_notice">
                                </td>
                           	</tr> 
							<%--
							<tr> 
								<td class="div_input"   nowrap><%=text.get("SR_102.TEXT_0106")%></td>
								<td class="div_data" nowrap> 
									<input type="text" size=30 name="st" readonly class="readonly_text" value="<%=s_temp%>">
									 --%>
									<%--<input type=button class=button_1 value="¼±AA"  onClick="javascript:tmp_pop('s_tmp');" style="cursor:hand">--%>
									<%--
				 					<a href="javascript:tmp_pop('s_tmp');"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/icon_con_gla.gif" border="0" align="absmiddle"></a>
									<input type="hidden" name="st_num" value="<%=st_num%>">
                                </td>
                            </tr> 
							 -- %>
							  <%--
							 <tr> 
						        <td class="div_input"  nowrap><%=text.get("SR_102.TEXT_0200")%></td>
						        <td class="div_data" nowrap> 
								  	<input type="text" size=30 name="ct" readonly class="readonly_text" value="<%=c_temp%>">
								  	--%>
								 	<%-- <input type=button class=button_1 value="¼±AA"  onClick="javascript:tmp_pop('c_tmp');" style="cursor:hand" >--%>
								 	<%-- 
                                	<a href="javascript:tmp_pop('c_tmp');"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/icon_con_gla.gif" border="0" align="absmiddle"></a>
                                	<input type="hidden" name="ct_num" value="<%=ct_num%>">
                                </td>
                             </tr>
                             --%> 
							 <tr> 
						        <td class="div_input"  nowrap>공급사 구비조건<%--<%=text.get("SR_102.TEXT_0107")%>--%></td>
						        <td class="div_data" nowrap> 
								  	<textarea class="textarea" rows="4" cols="45" name="condition"><%=condition%></textarea>
                                </td>
                             </tr> 
							 <tr>
							 	<td style="font-family: 'Arial'; background-image: url(../images/div_colm_re.gif);background-repeat: no-repeat;background-position: right;background-color: F6F6F6;font-size: 12px;height: 25px;letter-spacing: -1px;padding-top: 2px;color: black;padding-left: 0px;text-align: center;" class="div_input"   nowrap>담당자명 <%--<%=text.get("SR_102.TEXT_0108")%>--%></td>
							 	<td class="div_data" nowrap>
							 		<input type="text" name="user_id" value="<%=user_id%>">
							 		<input type="text" size=12 name="username" value="<%=charge%>"  class="readonly_text">
                             						<input type="hidden" name="urefitem" value="">
									<a href="javascript:searchCharge();"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/icon_con_gla.gif" border="0" align="absmiddle"></a>
							 	</td>
							 </tr> 
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr> 
	</table>
	<iframe name="hiddenframe" src="empty.htm" width="0" height="0"></iframe>
</form>
<!---- END OF USER SOURCE CODE ---->
</body>
</html>


