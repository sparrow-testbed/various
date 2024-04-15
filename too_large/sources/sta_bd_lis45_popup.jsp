<!--  /t_system1/wise/vaatz_package/myserver/V1.0.0/wisedoc/kr/dt/bid/ebd_bd_ins1.jsp -->
<!--
Title:        간판설치현황 등록 및 수정  <p>
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
    
    String branches_code = JSPUtil.nullToEmpty(request.getParameter("branches_code"));
    String item_no = JSPUtil.nullToEmpty(request.getParameter("item_no"));
    String key_no = JSPUtil.nullToEmpty(request.getParameter("key_no"));
    String io_number = JSPUtil.nullToEmpty(request.getParameter("io_number"));
    
    String signform_list	= ListBox(request, "SL0018",  house_code+"#M659#", "");
    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간

    String branches_name         		= "";
    String item_name         			= "";
    String specificaion       				= "";
    String signform  						= "";
    String install_date          			= "";
    String confirm_from_date         	= "";
    String confirm_to_date       		= "";
    String stick_location           		= "";
    String install_store          			= "";
    String install_store_name			= "";
    String install_store_phone	  		= "";
    String attach_no         				= "";
    String remove_flag  					= "";
    String remark							= "";
    
    String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
  
    if("update".equals(mode)) {
	   	Map map = new HashMap();
	   	map.put("house_code"		, house_code);
	   	map.put("branches_code"		, branches_code);
	   	map.put("item_no"				, item_no);
	   	map.put("key_no"					, key_no);
	   	map.put("io_number"				, io_number);
	
	   	Object[] obj = {map};
	   	SepoaOut value = ServiceConnector.doService(info, "p7009", "CONNECTION","getSignDate", obj);
	   	
	   	SepoaFormater wf = new SepoaFormater(value.result[0]); 
	
	   	branches_name       	= wf.getValue("BRANCHES_NAME",0);
	   	item_name             	= wf.getValue("ITEM_NAME",0);
	   	specificaion            	= wf.getValue("SPECIFICATION",0);
	   	signform                	= wf.getValue("SIGNFORM",0);
	   	install_date            	= wf.getValue("INSTALL_DATE",0);
	   	confirm_from_date   	= wf.getValue("CONFIRM_DATE_FROM",0);
	   	confirm_to_date		= wf.getValue("CONFIRM_DATE_TO",0);
	   	stick_location         	= wf.getValue("STICK_LOCATION",0);
	   	install_store           	= wf.getValue("INSTALL_STORE",0);
	   	install_store_name   	= wf.getValue("INSTALL_STORE_NAME",0);
	   	install_store_phone  	= wf.getValue("INSTALL_STORE_PHONE",0);
	   	attach_no            	= wf.getValue("ATTACH_NO",0);
	   	remove_flag            = wf.getValue("REMOVE_FLAG",0);
	   	remark            		= wf.getValue("REMARK",0);
    }
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
	
	var mode = "<%=mode %>";
	var signform = "<%=signform %>";
	var remove_flag = "<%=remove_flag %>";
	if(remove_flag == "Y") {
		document.form.remove_radio_y.checked = true;
		document.form.remove_radio_n.checked = false;
	} else if(remove_flag == "N") {
		document.form.remove_radio_y.checked = false;
		document.form.remove_radio_n.checked = true;
	}
	
	document.form.signform.value = signform;
	
	
	document.forms[0].confirm_from_date.value = add_Slash("<%=confirm_from_date %>");
	document.forms[0].confirm_to_date.value   = add_Slash("<%=confirm_to_date%>");
	document.forms[0].install_date.value   = add_Slash("<%=install_date%>");
	
	if(mode == "update") {
		document.form.signform.disabled = true;
		document.form.key_no.disabled = true;
// 		document.form.remove_radio_y.disabled = true;
// 		document.form.remove_radio_n.disabled = true;
	} else {
		document.form.signform.disabled = false;
		document.form.key_no.disabled = false;
// 		document.form.remove_radio_y.disabled = false;
// 		document.form.remove_radio_n.disabled = false;
	}
	
}

function doQuery() {

    var cols_ids = "";
    var params = "mode=getBdItemDetail";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
//     GridObj.post( G_SERVLETURL, params );
//     GridObj.clearAll(false);
}

function doSave(temp) {
	var branches_code = document.forms[0].branches_code.value;
	var install_date = document.forms[0].install_date.value;
	var item_no = document.forms[0].install_date.value;
	var confirm_from_date = document.forms[0].confirm_from_date.value;
	var confirm_to_date = document.forms[0].confirm_to_date.value;
	var signform = document.forms[0].signform.value;
	var install_store = document.forms[0].install_store.value;
	var key_no = document.forms[0].key_no.value;
	var remove_flag = document.forms[0].remove_flag.value;
	
	if(branches_code == "") { alert("영업점이 없습니다."); return; }
	if(del_Slash(install_date) == "") { alert("설치일자가 없습니다."); return; }
	if(item_no == "") { alert("품목이 없습니다."); return; }
	if(del_Slash(confirm_from_date) == "") { alert("허가기간이 없습니다."); return; }
	if(del_Slash(confirm_to_date) == "") { alert("허가기간이 없습니다."); return; }
	if(signform == "") { alert("간판형태가 없습니다."); return; }
	if(install_store == "") { alert("설치업체가 없습니다."); return; }
	if(key_no == "") { alert("고유번호가 없습니다."); return; }
	if(remove_flag == "") { alert("철거유형이 없습니다."); return; }
	
	 var nickName       	= "p7009";
     var conType         	= "TRANSACTION";
     var methodName 	= "doSaveSign";
     var SepoaOut        	= doServiceAjax( nickName, conType, methodName );
     // SepoaOut.result[0] << setValue
     
     if( SepoaOut.status == "1" ) { // 성공
     	alert(SepoaOut.message);
//          opener.getQuery();

		var house_code 		= SepoaOut.result[0];
		var key_no 			= SepoaOut.result[1];
		var branches_code 	= SepoaOut.result[2];
		var item_no 			= SepoaOut.result[3];
		var io_number 		= SepoaOut.result[4];
        
		var param = "";
		param += "?mode=update"
		param += "&house_code=" + house_code
		param += "&key_no=" + key_no
		param += "&branches_code=" + branches_code
		param += "&item_no=" + item_no
		param += "&io_number=" + io_number
		
		location.href = "sta_bd_lis45_popup.jsp"+param;
		opener.doSelect();
     } else {
         if(SepoaOut.message == "null"){
             alert("AjaxError");
         }else{
             alert(SepoaOut.message);
         }
     }
}

//팝업호출 공통
function PopupManager(part)
{
	var url = "";
	var f = document.forms[0];

	if(part == "BRANCHES"){	//영업점
		window.open("/common/CO_009.jsp?callback=return_branches", "SP0073", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}else if(part == "ITEM"){	//품목
		setCatalogIndex(G_C_INDEX);
		
		url = "/kr/catalog/cat_pp_lis_main.jsp?INDEX=" + getAllCatalogIndex() ;
		
		CodeSearchCommon(url,"INVEST_NO",0,0,"950","530");
	}else if(part == "STORE"){	//공급업체
		window.open("/common/CO_014.jsp?callback=return_vendor", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
	}
}

function return_branches(code,text){
    document.forms[0].branches_code.value	= code;
	document.forms[0].branches_name.value 	= text;
}

function setCatalog(itemNo, descriptionLoc, specification, makerCode, ctrlCode, qty, itemGroup, delyToAddress, unitPrice, ktgrm, makerName, basicUnit, materialType){
	document.forms[0].item_no.value 	= itemNo;
	document.forms[0].item_name.value = descriptionLoc;
}

function return_vendor(code, desc1, desc2 , desc3) {
	document.forms[0].install_store.value = code;
	document.forms[0].install_store_name.value = desc1;
}

function chkRadio(temp) {
	if(temp == "Y") {
		if(document.form.remove_radio_y.checked == true) {
			document.form.remove_radio_y.checked = true;
			document.form.remove_radio_n.checked = false;
			document.forms[0].remove_flag.value = "Y";
		}
	} else if(temp == "N") {
		if(document.form.remove_radio_n.checked == true) {
			document.form.remove_radio_y.checked = false;
			document.form.remove_radio_n.checked = true;
			document.forms[0].remove_flag.value = "N";
		}
	}
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작--> 

<form name="form" >
<input type="hidden" name="save_flag" id="save_flag" value="<%=mode %>">
<input type="hidden" name="remove_flag" id="remove_flag" value="<%=remove_flag%>">
<%  
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "간판설치현황상세";
%>
    <%@ include file="/include/sepoa_milestone.jsp"%>
    
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>    
    

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;영업점
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="branches_code" id="branches_code" size="16" class="inputsubmit" readonly value='<%=branches_code %>' readOnly>
			<% if("insert".equals(mode)) { %>
			<a href="javascript:PopupManager('BRANCHES');">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<% } %>
			<input type="text" name="branches_name" id="branches_name" size="25" class="input_data2" readonly value='<%=branches_name %>' readOnly>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;설치일자
		</td>
		<td width="35%" class="data_td">
			<s:calendar id="install_date" default_value="" format="%Y/%m/%d"/>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목
		</td>
		<td width="35%" class="data_td">
			<input type="text" name="item_no" id="item_no" size="16" class="inputsubmit" readonly value='<%=item_no %>' readOnly >
			<% if("insert".equals(mode)) { %>
			<a href="javascript:PopupManager('ITEM');">
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<% } %>
			<input type="text" name="item_name" id="item_name" size="25" class="input_data2" readonly value='<%=item_name %>' readOnly>
		</td>
		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;허가일자
		</td>
		<td width="35%" class="data_td">
			<s:calendar id="confirm_from_date" default_value="" format="%Y/%m/%d"/>
			~
			<s:calendar id="confirm_to_date" default_value="" format="%Y/%m/%d"/>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;규격
		</td>
		<td class="data_td" width="35%">
			<input type="text" name="specification" id="specification" style="width:95%" class="inputsubmit" maxlength="100" value="<%=specificaion%>">
		</td>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부착위치
		</td>
		<td class="data_td" width="35%">
			<input type="text" name="stick_location" id="stick_location" style="width:95%" class="inputsubmit" maxlength="100" value="<%=stick_location%>">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;간판형태
		</td>
		<td width="35%" class="data_td">
			<select name="signform" id="signform" class="inputsubmit">
			<option>전체</option>
			<%=signform_list %>
		    </select>
		</td>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;이미지등록
		</td>
		<td width="35%" class="data_td" >
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<input type="text" size="3" readOnly class="input_empty" value="0" name="sign_attach_no_count" id="sign_attach_no_count"/>
						<input type="hidden" value="<%=attach_no %>" name="attach_no" id="attach_no">&nbsp;&nbsp;
					</td>
					<td>
<script language="javascript">
function setAttach(attach_key, arrAttrach, rowId, attach_count) {
	document.getElementById("attach_no").value = attach_key;
	document.getElementById("sign_attach_no_count").value = attach_count;
}
btn("javascript:attach_file(document.getElementById('attach_no').value, 'TEMP');", "파일등록");
</script>
					</td>
				</tr>
			</table>
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;설치업체
		</td>
		<td class="data_td" width="35%" >
<%-- 			<input type="text" name="install_store" id="install_store" style="width:95%" class="inputsubmit" maxlength="100" value="<%=install_store%>"> --%>
			<input type="text" name="install_store" id="install_store" size="16" class="inputsubmit" readonly value='<%=install_store %>' readOnly>
			<a href="javascript:PopupManager('STORE');" >
				<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="install_store_name" id="install_store_name" size="25" class="input_data2" readonly value='<%=install_store_name %>' readOnly>
		</td>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;설치업체전화번호
		</td>
		<td class="data_td" width="35%">
			<input type="text" name="install_store_phone" id="install_store_phone" style="ime-mode:active;width:95%;" class="inputsubmit" maxlength="100" value="<%=install_store_phone%>" onkeypress="checkNumberFormat('[0-9]', this);">
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;고유번호
		</td>
		<td class="data_td" width="35%">
			<input type="text" name="key_no" id="key_no" style="ime-mode:disabled; width:95%;" class="inputsubmit" maxlength="100" value="<%=key_no%>" onkeypress="checkNumberFormat('[0-9]', this);">
		</td>
    	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;간판상태
		</td>
		<td class="data_td" width="35%">	
			<input type="radio" name="remove_radio_y" style="border: none;" onclick="chkRadio('Y')">설치중
			<input type="radio" name="remove_radio_n" style="border: none;" onclick="chkRadio('N')">철거완료
		</td>
    </tr>
    <tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
    <tr>
    	<td width="15%"  class="title_td" >&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;특이사항</td>
		<td  class="data_td" width="85%" colspan="3" height="200">
			<textarea name="remark" id="remark" class="inputsubmit" cols="85" rows="10" onKeyUp="return chkMaxByte(2000, this, '특이사항');" style="height: 180px; width: 98%"><%=remark %></textarea>
		</td>
    </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>	

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSave()", "저장")</script></TD>
			<TD><script language="javascript">btn("javascript:window.close();", "닫기")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table> 

</form>
<!---- END OF USER SOURCE CODE ----> 
</s:header>
<s:footer/>
</body>
</html>


