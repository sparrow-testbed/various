<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html> 
 
<%--<%@page import="sepoa.svl.procure.forecast_list"%>	--%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>


<%	
	Vector multilang_id = new Vector();
	multilang_id.addElement("MT_059");
	multilang_id.addElement("PU_112_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	String house_code   = info.getSession("HOUSE_CODE");
	String shipper_type = JSPUtil.nullToEmpty(request.getParameter("shipper_type"));
	String MATERIAL_NUMBER = JSPUtil.nullToEmpty(request.getParameter("MATERIAL_NUMBER").replaceAll ( "&#64;" , "@" ));
    //System.out.println("MATERIAL_NUMBER Value ["+MATERIAL_NUMBER+"]"  );
    if(MATERIAL_NUMBER.length() > 0 )MATERIAL_NUMBER = MATERIAL_NUMBER.substring( 0, MATERIAL_NUMBER.length()-2 );
	//2011.07.06 R110620056건에서 재견적시 업체가 조회되지 않아서 DESCRIPTION_LOC부분 주석처리함.
	//String DESCRIPTION_LOC = JSPUtil.nullToEmpty(request.getParameter("DESCRIPTION_LOC"));
	String SOURCING_GROUP = JSPUtil.nullToEmpty(request.getParameter("SOURCING_GROUP"));	
	String company_code = JSPUtil.nullToEmpty(request.getParameter("company_code"));	
    
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	boolean isSupplier = false;
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	
	//소싱그룹가져오기
	String ret = null;
	
	SepoaFormater wf = null;
	SepoaOut value = null;
	SepoaRemote ws = null;

	String nickName= "p0070";
	String conType = "CONNECTION";

	String MethodName = "getSgContentsList";
	String sg_refitem = "";

	Object[] obj = { sg_refitem };

	try {
		ws = new SepoaRemote(nickName, conType, info);
		value = ws.lookup(MethodName,obj);
		ret = value.result[0];
		wf =  new SepoaFormater(ret);
	} catch(SepoaServiceException wse) {
		Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
		Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
	} catch(Exception e) {
	    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
	    
	} finally {
		try{
			ws.Release();
		} catch(Exception e) { }
	}
	String str = "";
	for(int i=0; i < wf.getRowCount(); i++) {
		str = str + "<option value='" + wf.getValue("SG_REFITEM", i) + "'>" + wf.getValue("SG_NAME", i) + "</option>\n";
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>
<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
function doSelect() {
	var seller_code = encodeUrl(LRTrim(document.form.seller_code.value).toUpperCase());
	var name_loc = encodeUrl(LRTrim(document.form.name_loc.value));
	var sg_code1 = document.form.material_type.value;
	var sg_code2 = document.form.material_ctrl_type.value;
	var sg_code3 = document.form.material_class1.value;
	var sg_code4 = document.form.material_class2.value;
	var sg_code5 = document.form.material_class3.value;
	
	var gp_code1 = document.form.g_material_type.value;
	var gp_code2 = document.form.g_material_ctrl_type.value;
		
	
	var arr = document.getElementsByName("group1");
	var type = "";
	var company_code = "<%=company_code%>";
	for ( var i = 0; i < arr.length; i++) {
		var temp = arr[i];
		if (temp.checked == true) {
			type = temp.value;
		}
	}
	
	
	parent.leftFrame.doSelect(seller_code, name_loc, type, sg_code1, sg_code2, sg_code3, sg_code4, sg_code5, gp_code1, gp_code2, company_code);
}

function setType(prop) {
	if (prop == "1") {
		document.getElementById("sourcingTr").style.display = "none";
		document.getElementById("groupTr").style.display = "none";
		parent.mainFrame.rows = "150,250,250";
	} else if(prop == "2") {
		document.getElementById("sourcingTr").style.display = "";
		document.getElementById("groupTr").style.display = "none";
		parent.mainFrame.rows = "210,250,250";
	} else if(prop == "3") {
		document.getElementById("sourcingTr").style.display = "none";
		document.getElementById("groupTr").style.display = "";
		parent.mainFrame.rows = "210,250,250";
	}
	document.forms[0].material_type.value = "";
	materialChange("MATERIAL_CTRL_TYPE");
}
// 셀렉트박스 선택시
function materialChange(target) {
	var id = "SL0009_1";
	var code = "M2000";	//"M2000";
	var value = "";
	if (target == "MATERIAL_CTRL_TYPE") {
		code = "M2001";	//"M2001";
		value = form.material_type.value;
	} else if (target == "MATERIAL_CLASS1") {
		code = "M2002";	//"M2002";
		value = form.material_ctrl_type.value;
	} else if (target == "MATERIAL_CLASS2") {
		code = "M2003";	//"M2003";
		value = form.material_class1.value;
	} else if (target == "MATERIAL_CLASS3") {
		code = "M2004";	//"M2004";
		value = form.material_class2.value;
	}

	data = "scg_item_list_create.jsp?target=" + target + "&id=" + id + "&code="
			+ code + "&value=" + value;
	document.childFrame.location.href = data;
}
function initAjax() {
	doRequestUsingPOST('SL0018', 'M2000', 'material_type', '');
	doRequestUsingPOST('SL0150', '0#1', 'g_material_type', '');
}

//콤보박스 변환에 따른 연계 Function
function MATERIAL_CLASS1_Changed(){
	var sg_refitem = form.material_class1.value;
	
	target = "MATERIAL_CLASS1";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	
	this.hiddenframe.location.href = data;
}

function clearMATERIAL_CLASS1(){
	if(form.material_class1.length > 0){
		for(i=form.material_class1.length-1; i>=0;  i--) {
			form.material_class1.options[i] = null;
		}
	}
}

function setMATERIAL_CLASS1(name, value){
	var option1 = new Option(name, value, true);
	
	form.material_class1.options[form.material_class1.length] = option1;
}

function MATERIAL_CTRL_TYPE_Changed(){
	clearMATERIAL_CLASS1();
	
	var sg_refitem = form.material_ctrl_type.value;
	
	target = "MATERIAL_CTRL_TYPE";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	
	this.hiddenframe.location.href = data;
}

function clearMATERIAL_CTRL_TYPE(){
	if(form.material_ctrl_type.length > 0) {
		for(i=form.material_ctrl_type.length-1; i>=0;  i--) {
			form.material_ctrl_type.options[i] = null;
		}
	}
}

function setMATERIAL_CTRL_TYPE(name, value){
	var option1 = new Option(name, value, true);
	form.material_ctrl_type.options[form.material_ctrl_type.length] = option1;
}

function MATERIAL_TYPE_Changed(){
	clearMATERIAL_CTRL_TYPE();
	setMATERIAL_CTRL_TYPE("----------", "");
	clearMATERIAL_CLASS1();
	setMATERIAL_CLASS1("----------", "");
	var sg_refitem = form.material_type.value;
	target = "MATERIAL_TYPE";
	data = "/kr/master/register/vendor_reg_hidden.jsp?target=" + target + "&sg_refitem=" + sg_refitem;
	this.hiddenframe.location.href = data;
}

function KeyFunction(temp) {
	if(temp == "Enter") {
		if(event.keyCode == 13) {
			doSelect();
		}
	}
}

function clear_g_MATERIAL_CTRL_TYPE(){
	if(form.g_material_ctrl_type.length > 0) {
		for(i=form.g_material_ctrl_type.length-1; i>=0;  i--) {
			form.g_material_ctrl_type.options[i] = null;
		}
	}
}

function set_g_MATERIAL_CTRL_TYPE(name, value){
	var option1 = new Option(name, value, true);
	form.g_material_ctrl_type.options[form.g_material_ctrl_type.length] = option1;
}

function g_MATERIAL_TYPE_Changed(){
	clear_g_MATERIAL_CTRL_TYPE();
	set_g_MATERIAL_CTRL_TYPE("----------", "");
	doRequestUsingPOST('SL0150', form.g_material_type.value+'#2', 'g_material_ctrl_type', '');
}


</script>
</head>

<body leftmargin="15" topmargin="6" onload="setType('1');initAjax()">
<s:header popup="true">
<form name="form">
<input type="hidden" name="material_class2" id="material_class2" value="">
<input type="hidden" name="material_class3" id="material_class2" value="">
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("PU_112_2.SUB_T_01"); //업체지정
%>


	<%@ include file="/include/sepoa_milestone.jsp"%>
    

		<table width="100%" border="0" cellpadding="0" cellspacing="0" >
		<tr>
    	 	<td height="5"> </td>
	  	</tr>
	  	<tr>
	    	<td width="100%" valign="top">
	    	
				    	
			<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
			<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
			<tr>
			<td width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>
				<tr>
        			<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;조회구분</td>
        			<td class="data_td" colspan="3">
        				<input type="radio" name="group1" value="SSUGL" style="border:0px;" onclick="setType('1');" checked >업체
						<input type="radio" name="group1" value="SPOGL" style="border:0px;" onclick="setType('1');">발주
						<input type="radio" name="group1" value="SRQGL" style="border:0px;" onclick="setType('1');">견적
                        <input type="radio" name="group1" value="SSGSL" style="border:0px;" onclick="setType('2');">소싱그룹	
                        <input type="radio" name="group1" value="SGGSL" style="border:0px;" onclick="setType('3');">사용자그룹	                                                			
        			</td>
				</tr>

				<tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>				
				<tr>
        			<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("PU_112_2.SELLER_CODE_S")%></td><%-- 업체코드 --%>
        			<td width="35%" height="24" class="data_td">
        				<input type="text" name="seller_code" size="20" class=inputsubmit maxlength="20" value="" style="ime-mode:inactive" onkeydown="JavaScript: KeyFunction('Enter');">
        			</td>
	        		<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("PU_112_2.NAME_LOC")%></td><%-- 업체명 --%>
	        		<td width="35%" height="24" class="data_td">
	        			<input type="text" name="name_loc" size="20" class=inputsubmit maxlength="20" value="" onkeydown="JavaScript: KeyFunction('Enter');">
	        		</td>
				</tr>
				
				<tr id="sourcingTr" style="display: none;">
					<td colspan="4" width="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
						<tr>
							<td colspan="4" height="1" bgcolor="#dedede"></td>
						</tr>			
<!-- 							<tr> -->
<%-- 								<td width="7%" class="title_td"><%=text.get("MT_059.MATERIAL_TYPE_S")%></td> --%>
<!-- 								1레벨 -->
<%-- 								<td width="26%" class="data_td"><select name="material_type" id="material_type" --%>
<%-- 									class="inputsubmit" --%>
<%-- 									onChange="javacsript:materialChange('MATERIAL_CTRL_TYPE');"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 								</select></td> --%>
<%-- 								<td width="7%" class="title_td"><%=text.get("MT_059.MATERIAL_CTRL_TYPE_S")%></td> --%>
<!-- 								2레벨 -->
<%-- 								<td width="26%" class="data_td"><select name="material_ctrl_type" --%>
<%-- 									id="material_ctrl_type" class="inputsubmit" --%>
<%-- 									onChange="javacsript:materialChange('MATERIAL_CLASS1');"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 								</select></td> --%>
<%-- 								<td width="8%" class="title_td"><%=text.get("MT_059.MATERIAL_CLASS1_S")%></td> --%>
<!-- 								3레벨 -->
<%-- 								<td width="26%" class="data_td"><select name="material_class1" --%>
<%-- 									id="material_class1" class="inputsubmit" --%>
<%-- 									onChange="javacsript:materialChange('MATERIAL_CLASS2');"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 								</select></td> --%>
<!-- 							</tr> -->
<!-- 							<tr> -->
<%-- 								<td class="title_td"><%=text.get("MT_059.MATERIAL_CLASS2_S")%></td> --%>
<!-- 								4레벨 -->
<%-- 								<td class="data_td"><select name="material_class2" --%>
<%-- 									id="material_class2" class="inputsubmit" --%>
<%-- 									onChange="javacsript:materialChange('MATERIAL_CLASS3');"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 								</select></td> --%>
<%-- 								<td class="title_td"><%=text.get("MT_059.MATERIAL_CLASS3_S")%></td> --%>
<!-- 								5레벨 -->
<%-- 								<td colspan="3" class="data_td"><select name="material_class3" --%>
<%-- 									id="material_class3" class="inputsubmit"> --%>
<!-- 										<option value="">선택</option> -->
<%-- 								</select></td> --%>
<!-- 							</tr> -->
								<tr>
									<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱대분류</td>
									<td width="35%" height="24" class="data_td" align="left">
										<select name="material_type" id="material_type" class="inputsubmit" onChange="javascript:MATERIAL_TYPE_Changed();">
											<option value=''>----------</option>
											<%=str%>
										</select>
									</td>
									<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱중분류</td>
									<td width="35%" height="24" class="data_td" align="left">
										<select name="material_ctrl_type" id="material_ctrl_type" class="inputsubmit" onChange="javascript:MATERIAL_CTRL_TYPE_Changed();">
											<option value=''>----------</option>
										</select>
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>			
								<tr>
									<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소싱소분류</td>
									<td width="35%" height="24" class="data_td" align="left" colspan="3">
										<select name="material_class1" id="material_class1" class="inputsubmit" onChange="javascript:MATERIAL_CLASS1_Changed();">
											<option value=''>----------</option>
										</select>
										<input type="hidden" name="creditRating" id="creditRating" value="" />
									</td>
									<%-- <td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등급</td>
									<td class="data_td" align="left">
										<select name="creditRating" class="inputsubmit">
											<option value="">전체</option>
											<%=creditRating%>
										</select>
									</td> --%>
								</tr>
						</table>
					</td>
					</tr>
					
					
					<tr id="groupTr" style="display: none;">
					<td colspan="4" width="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>			
								<tr>
									<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자그룹1</td>
									<td width="35%" height="24" class="data_td" align="left">
										<select name="g_material_type" id="g_material_type" class="inputsubmit" onChange="javascript:g_MATERIAL_TYPE_Changed();">
											<option value=''>----------</option>											
										</select>
									</td>
									<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용자그룹2</td>
									<td width="35%" height="24" class="data_td" align="left">
										<select name="g_material_ctrl_type" id="g_material_ctrl_type" class="inputsubmit" >
											<option value=''>----------</option>
										</select>
									</td>
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
</table>	
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				<TR>
					<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
						<TR>
					  	 	<td><script language="javascript">btn("javascript:doSelect()","<%=text.get("BUTTON.search")%>")</script></td>	<%-- 품목찾기  --%>
					  	</TR>
				    </TABLE>
				  	</td>
			 	</TR>
			</TABLE>
			</td>
		</tr>
	</table>
</form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>     
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
</body>


</s:header>
<s:footer/>
</body>
</html>
