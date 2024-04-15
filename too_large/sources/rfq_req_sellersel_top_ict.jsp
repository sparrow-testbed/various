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
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="/js/lib/sec.js"></script>
<script language="javascript" src="/js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<Script language="javascript">
function doSelect() {
	var seller_code = encodeUrl(LRTrim(document.form.seller_code.value).toUpperCase());	// 업체코드
	var name_loc = encodeUrl(LRTrim(document.form.name_loc.value));	// 업체명
	//parent.leftFrame.doSelect(seller_code, name_loc, type, sg_code1, sg_code2, sg_code3, sg_code4, sg_code5, company_code);
	parent.leftFrame.doSelect(seller_code, name_loc);
}

function setType(prop) {
	if (prop == "1") {
		parent.mainFrame.rows = "150,250,250";
	} else {
		parent.mainFrame.rows = "210,250,250";
	}
}

function initAjax() {
	//doRequestUsingPOST('SL0018', 'M2000', 'material_type', '');
}


function KeyFunction(temp) {
	if(temp == "Enter") {
		if(event.keyCode == 13) {
			doSelect();
		}
	}
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
												<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("PU_112_2.SELLER_CODE_S")%></td><%-- 업체코드 --%>
												<td width="35%" height="24" class="data_td">
													<input type="text" name="seller_code" size="20" class=inputsubmit maxlength="20" value="" style="ime-mode:inactive" onkeydown="JavaScript: KeyFunction('Enter');">
												</td>
												<td width="15%" height="24" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("PU_112_2.NAME_LOC")%></td><%-- 업체명 --%>
												<td width="35%" height="24" class="data_td">
													<input type="text" name="name_loc" size="20" class=inputsubmit maxlength="20" value="" onkeydown="JavaScript: KeyFunction('Enter');">
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td style="padding:5 5 5 0" align="right">
										<table cellpadding="2" cellspacing="0">
											<tr>
												<td><script language="javascript">btn("javascript:doSelect()","<%=text.get("BUTTON.search")%>")</script></td>
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
</form>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>     
<iframe name="hiddenframe" src="" width="0" height="0"></iframe>
</body>


</s:header>
<s:footer/>
</body>
</html>
