<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        간판설치현황 출력 <p>
 Description:  재산관리 -- 간판설치관련 등록 사항 <p>
 Copyright:     <p>
 Company:     SepoaSoft <p>
 @author       next1210 <p>
 @version      1.0
 @Comment   
!-->
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	boolean isSelectScreen = false;

    String mode       = JSPUtil.nullToEmpty(request.getParameter("mode"));

    String house_code   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    
    String branches_from_code = JSPUtil.nullToEmpty(request.getParameter("branches_from_code"));
    String branches_from_name = JSPUtil.nullToEmpty(request.getParameter("branches_from_name"));
    String branches_to_code = JSPUtil.nullToEmpty(request.getParameter("branches_to_code"));
    String branches_to_name = JSPUtil.nullToEmpty(request.getParameter("branches_to_name"));
    String confirm_from_date_sr = JSPUtil.nullToEmpty(request.getParameter("confirm_from_date"));
    String confirm_to_date_sr = JSPUtil.nullToEmpty(request.getParameter("confirm_to_date"));
    String item_no_sr = JSPUtil.nullToEmpty(request.getParameter("item_no"));
    String item_name_sr = JSPUtil.nullToEmpty(request.getParameter("item_name"));
    String install_store_sr = JSPUtil.nullToEmpty(request.getParameter("install_store"));
    String install_store_name_sr = JSPUtil.nullToEmpty(request.getParameter("install_store_name"));
    String signform_sr = JSPUtil.nullToEmpty(request.getParameter("signform"));
    String remove_flag_sr = JSPUtil.nullToEmpty(request.getParameter("remove_flag"));
    
    String branches_from_text = "";
    String branches_to_text = "";
    String item_text = "";
    String install_store_text = "";
    String signform_text = "";
    String remove_flag_text_sr = "";
    
    if(branches_from_code.length() > 0) {
    	branches_from_text = "[" + branches_from_code + "] " + branches_from_name;
    }
    if(branches_to_code.length() > 0) {
    	branches_to_text = "[" + branches_to_code + "] " + branches_to_name;
    }
    if(item_no_sr.length() > 0) {
    	item_text = "[" + item_no_sr + "] " + item_name_sr;
    }
    if(install_store_sr.length() > 0) {
    	install_store_text = "[" + install_store_sr + "] " + install_store_name_sr;
    }
    if(signform_sr.length() > 0) {
    	if("10".equals(signform_sr)) {
    		signform_text = "일반형";
    	} else if("20".equals(signform_sr)) {
    		signform_text = "파사트형";
    	} else if("30".equals(signform_sr)) {
    		signform_text = "거치대형(구형)";
    	} else if("40".equals(signform_sr)) {
    		signform_text = "거치대형(신형)";
    	}
    }
    if(remove_flag_sr.length() > 0) {
    	if("Y".equals(remove_flag_sr)) {
    		remove_flag_text_sr = "설치중";
    	} else if("N".equals(remove_flag_sr)) {
    		remove_flag_text_sr = "철거완료";
    	}
    }

    String io_number         		= "";
    String key_no         			= "";
    String branches_code       	= "";
    String branches_name  		= "";
    String item_no          		= "";
    String item_name         	= "";
    String specification       	= "";
    String install_date           	= "";
    String confirm_from_date 	= "";
    String confirm_to_date		= "";
    String install_store	  		= "";
    String install_store_name  	= "";
    String stick_location  		= "";
    String signform					= "";
    String signform_name		= "";
    String remove_flag			= "";
    String remove_flag_text		= "";
    
    String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
  
    Map map = new HashMap();
   	map.put("branches_from_code"		, branches_from_code);
   	map.put("branches_to_code"			, branches_to_code);
   	map.put("confirm_from_date"			, confirm_from_date_sr);
   	map.put("confirm_to_date"				, confirm_to_date_sr);
   	map.put("item_no"				, item_no_sr);
   	map.put("install_store"			, install_store_sr);
   	map.put("signform"				, signform_sr);

   	Object[] obj = {map};
   	SepoaOut value = ServiceConnector.doService(info, "p7009", "CONNECTION","getSmaglList", obj);
   	
   	SepoaFormater wf = new SepoaFormater(value.result[0]); 

%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%-- <%@ include file="/include/sepoa_grid_common.jsp"%> --%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var G_C_INDEX     = "MATERIAL_TYPE:MATERIAL_CTRL_TYPE:MATERIAL_CLASS1:ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME:PREV_UNIT_PRICE:DELIVERY_IT:MAKER_NAME:MAKER_CODE:ITEM_GROUP:DELY_TO_ADDRESS:KTGRM";

function init() {
	
<%-- 	var signform = "<%=signform %>"; --%>
<%-- 	var remove_flag = "<%=remove_flag %>"; --%>
// 	if(remove_flag == "Y") {
// 		document.form.remove_radio_y.checked = true;
// 		document.form.remove_radio_n.checked = false;
// 	} else if(remove_flag == "N") {
// 		document.form.remove_radio_y.checked = false;
// 		document.form.remove_radio_n.checked = true;
// 	}
	
// 	document.form.signform.value = signform;
	
	
<%-- 	document.forms[0].confirm_from_date.value = add_Slash("<%=confirm_from_date %>"); --%>
<%-- 	document.forms[0].confirm_to_date.value   = add_Slash("<%=confirm_to_date%>"); --%>
<%-- 	document.forms[0].install_date.value   = add_Slash("<%=install_date%>"); --%>
	
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작--> 

<form name="form" >
<input type="hidden" name="save_flag" id="save_flag" value="">
<input type="hidden" name="remove_flag" id="remove_flag" value="">
<%  
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "간판설치현황상세";
%>
    
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>    
    
<table width="100%">
		<tr>
			<td style="width: 100%; height: 30px; text-align: center;font-size: 20px;font-weight: bold;">간판 설치 현황</td>
		</tr>
</table>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>      
    
<table width="100%" border="0" cellspacing="1" cellpadding="1"  >
	<tr>
		<td>소속점(From) : <%=branches_from_text %> ~ 소속점(To) : <%=branches_to_text %></td>
	</tr>
	<tr>
		<td>허기기일(시작) : <%=SepoaString.getDateSlashFormat(confirm_from_date_sr) %> ~ 허가기일(만기) : <%=SepoaString.getDateSlashFormat(confirm_to_date_sr) %></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="1"  >
	<tr>
		<td style="width: 20%; font-size: 11px;">품목 :  <%=item_text %></td>
		<td style="width: 20%; font-size: 11px;">간판형태 :  <%=signform_text %></td>
		<td style="width: 20%; font-size: 11px;">관리업체 :  <%=install_store_text %></td>
		<td style="width: 20%; font-size: 11px;">철거여부 :  <%=remove_flag_text %></td>
		<td style="width: 40%; font-size: 11px;"></td>
	</tr>
</table>

<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="2">&nbsp;</td>
	</tr>
</table>
  
<table width="100%" >
<tr>
<td width="100%">

<table width="100%" border="1" cellspacing="0" cellpadding="1"  >
		<tr bgcolor="#BDBDBD">
			<td style="width: 2%;text-align: center; word-break: break-all; font-size: 11px;">No</td>
			<td style="width: 7%;text-align: center; word-break: break-all; font-size: 11px;">고유번호</td>
			<td style="width: 10%;text-align: center; word-break: break-all; font-size: 11px;">점포명</td>
			<td style="width: 10%;text-align: center; word-break: break-all; font-size: 11px;">품목명</td>
			<td style="width: 7%;text-align: center; word-break: break-all; font-size: 11px;">품목코드</td>
			<td style="width: 9%;text-align: center; word-break: break-all; font-size: 11px;">규격</td>
			<td style="width: 7%;text-align: center; word-break: break-all; font-size: 11px;">설치일</td>
			<td style="width: 8%;text-align: center; word-break: break-all; font-size: 11px;">허가일(시작)</td>
			<td style="width: 8%;text-align: center; word-break: break-all; font-size: 11px;">허가일(만기)</td>
			<td style="width: 9%;text-align: center; word-break: break-all; font-size: 11px;">관리업체</td>
			<td style="width: 9%;text-align: center; word-break: break-all; font-size: 11px;">부착위치</td>
			<td style="width: 7%;text-align: center; word-break: break-all; font-size: 11px;">간판형태</td>
			<td style="width: 7%;text-align: center; word-break: break-all; font-size: 11px;">철거형태</td>
		</tr>
<% if(wf.getRowCount() > 0) { %>
<% for(int i = 0; i < wf.getRowCount(); i++) { %>
		<tr>
			<td style="width: 2%;text-align: center; word-break: break-all;"><%= wf.getValue("IO_NUMBER", i) %></td>
			<td style="width: 7%;text-align: center; word-break: break-all;"><%= wf.getValue("KEY_NO", i) %></td>
			<td style="width: 10%;text-align: left; word-break: break-all;"><%= wf.getValue("BRANCHES_NAME", i) %></td>
			<td style="width: 10%;text-align: left; word-break: break-all;"><%= wf.getValue("ITEM_NAME", i) %></td>
			<td style="width: 7%;text-align: center; word-break: break-all;"><%= wf.getValue("ITEM_CODE", i) %></td>
			<td style="width: 9%;text-align: left; word-break: break-all;"><%= wf.getValue("SPECIFICATION", i) %></td>
			<td style="width: 7%;text-align: center; word-break: break-all;"><%= wf.getValue("INSTALL_DATE", i) %></td>
			<td style="width: 8%;text-align: center; word-break: break-all;"><%= wf.getValue("CONFIRM_DATE_FROM", i) %></td>
			<td style="width: 8%;text-align: center; word-break: break-all;"><%= wf.getValue("CONFIRM_DATE_TO", i) %></td>
			<td style="width: 9%;text-align: left; word-break: break-all;"><%= wf.getValue("INSTALL_STORE_NAME", i) %></td>
			<td style="width: 9%;text-align: left; word-break: break-all;"><%= wf.getValue("STICK_LOCATION", i) %></td>
			<td style="width: 7%;text-align: center; word-break: break-all;"><%= wf.getValue("SIGNFORM_NAME", i) %></td>
			<td style="width: 7%;text-align: center; word-break: break-all;";><%= wf.getValue("REMOVE_FLAG_TEXT", i) %></td>
		</tr>
<% } %>	
<% } %>	
</table>
<table width="100%">
</table>

</td>
</tr>
</table>


</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>
<s:footer/>
</body>
</html>


