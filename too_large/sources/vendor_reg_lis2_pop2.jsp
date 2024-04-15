<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_103_02");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_103_02";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="SU_103_02";%>

<%
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String popup = JSPUtil.nullToEmpty(request.getParameter("popup"));
	String vendor_code	= JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	
    
    Object[] args     = new Object[1];
    args[0] = vendor_code;
	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","req_ins_getVnglList2", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	
	
	String VENDOR_CODE      = "";
	String VENDOR_NAME_LOC  = "";
	String BANK_KEY        = "";
	String BANK_ACCT        = "";
	String DEPOSITOR_NAME   = "";
	String P_BANK_KEY      = "";
	String P_BANK_ACCT      = "";
	String P_DEPOSITOR_NAME = "";
	
	if(wf.getRowCount() > 0) {
		VENDOR_CODE          = wf.getValue("VENDOR_CODE"     		,   0);
		VENDOR_NAME_LOC  = wf.getValue("VENDOR_NAME_LOC"     		,   0);
		BANK_KEY                 = wf.getValue("BANK_KEY"     		,   0);
		BANK_ACCT              = wf.getValue("BANK_ACCT"     		,   0);
		DEPOSITOR_NAME     = wf.getValue("DEPOSITOR_NAME"     		,   0);
		P_BANK_KEY              = wf.getValue("P_BANK_CODE"     		,   0);
		P_BANK_ACCT           = wf.getValue("P_BANK_ACCT"     		,   0);
		P_DEPOSITOR_NAME  = wf.getValue("P_DEPOSITOR_NAME"     		,   0);
	}
	
	if(BANK_KEY.equals("") ||BANK_KEY == null ){
		BANK_KEY = "020";
	}
    
    
    String LB_BANK_KEY = ListBox(info, "SL0018", info.getSession("HOUSE_CODE") + "#M349",BANK_KEY);
	
    
    String readOnly_flag = "";
	if (popup.equals("Y")) {
		readOnly_flag = "readOnly";
		//flag = "update";
	}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript">


function goSubmit() {
/* 	document.form1.method="post";
	document.form1.action = "vendor_reg_lis2_pop.jsp";
	document.form1.submit();  */

	$.post(
		"<%=POASRM_CONTEXT_NAME%>/servlets/master.register.vendor_reg_lis2",
		{
			house_code           : $('#house_code           ').val(), 
			company_code         : $('#company_code         ').val(), 
			dept_code            : $('#dept_code            ').val(),
			req_user_id          : $('#req_user_id          ').val(),
			doc_type             : $('#doc_type             ').val(),
			fnc_name             : $('#fnc_name             ').val(),
			ctrl_dept            : $('#ctrl_dept            ').val(), 
			ctrl_flag            : $('#ctrl_flag            ').val(), 
			query_flag           : $('#query_flag           ').val(), 
			model_flag           : $('#model_flag           ').val(), 
			model_no             : $('#model_no             ').val(), 
			material_type		 : $('#material_type		').val(),   
			material_ctrl_type	 : $('#material_ctrl_type	').val(),
			material_class1	     : $('#material_class1	    ').val(),
			material_class2	     : $('#material_class2	    ').val(),
			pr_flag			     : $('#pr_flag			    ').val(),
			material_class2_name : $('#material_class2_name ').val(), 
			basic_unit           : $('#basic_unit           ').val(), 
			item_abbreviation    : $('#item_abbreviation    ').val(), 
			app_tax_code         : $('#app_tax_code         ').val(), 
			item_block_flag      : $('#item_block_flag      ').val(), 
			vendor_code 		 : $('#vendor_code 		    ').val(),   
			att_mode             : $('#att_mode             ').val(), 
			view_type            : $('#view_type            ').val(), 
			file_type            : $('#file_type            ').val(), 
			tmp_att_no           : $('#tmp_att_no           ').val(),
			
			mode               : "real_setUpdate_vngl"
		},
		function(arg){
			doSaveEnd(arg, "");
		}
	); 
	
}

function PreSave() {

	Check();
}

function Check() {
	//if(""==document.forms[0].credit_rating.value  ){
	//	alert("신용등급은 필수 입력 입니다.");
	//	return;
	//}
	if(!confirm("저장 하시겠습니까?")) {
			return;
	}else{
		//file attach start
		//document.attachFrame.setData();	//startUpload
		goSubmit();
	}
}

function doSave(message, v_status){
		alert(message);
		//location.href="vendor_reg_lis2_pop.jsp";
		goSubmit();
}


</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
var button_flag 	= false;


var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
	
    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    } else if(stage==2) {
        return true;
    }
    
    return false;
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj)
{

	 alert("성공적으로 저장되었습니다.");
     window.close();
     
     
    /* var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode"); 
    var status   = obj.getAttribute("status");
	
    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }
 */
    /* if(status == "true") {
        alert(messsage);
        //doQuery();
        window.close();
    } else {
        alert(messsage);
        window.close();
    } */
    
    return false;
}

// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
// 복사한 데이터가 그리드에 Load 됩니다.
// !!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function doExcelUpload() {
    var bufferData = window.clipboardData.getData("Text");
    if(bufferData.length > 0) {
        GridObj.clearAll();
        GridObj.setCSVDelimiter("\t");
        GridObj.loadCSVString(bufferData);
    }
    return;
}

function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}

function onlyNumber(keycode){
	/* alert(keycode); */
	if(keycode >= 48 && keycode <= 57){
	}else {
		return false;
	}
	return true;
}

/**
 * 저장 = 'T', 결재요청='P', 확정= 'C'
 */
function Approval(sign_status)
{
	// 저장 = 'T', 결재요청='P', 작성완료='E', 입찰공고='C'
	if(button_flag == true) {
		//alert("작업이 진행중입니다.");
		//return;
	}
	button_flag = true;
	if (checkData() == false) {
		button_flag = false;
		return;
	} 
	
	$("#pflag").val(sign_status);
	
	if (sign_status == "P") {
		document.forms[0].target = "childframe";
		document.forms[0].action = "/kr/admin/basic/approval/approval.jsp";
		document.forms[0].method = "POST";
		document.forms[0].submit();
	}
	else {
		//getApproval(sign_status);
		goSave(sign_status, ""); 
		return;
	}		
}

function checkData()
{	
	if(LRTrim(document.forms[0].DEPOSITOR_NAME.value) == "") {
		alert("예금주를 입력하세요. ");
		document.forms[0].DEPOSITOR_NAME.focus();
		return false;
	}
	
	if(LRTrim(document.forms[0].BANK_ACCT.value) == "") {
		alert("계좌번호를 입력하세요. ");
		document.forms[0].BANK_ACCT.focus();
		return false;
	}
	
	return true;	
}

function getApproval(approval_str) {
	if (approval_str == "") {
		alert("결재자를 지정해 주세요");
		
		return;
	}
	
	$("#approval_str").val(approval_str);
	//document.attachFrame.setData();	//startUpload
	goSave($("#pflag").val(), approval_str);
}

/**
 * 저장 = 'T', 결재요청='P', 확정= 'C'
 */
function goSave(pflag, approval_str)
{
	var cert_result;

    //var rowcount = grid_array.length;
    if(pflag == "P") {
		if(confirm("결재상신 하시겠습니까?") != 1) {
			button_flag = false;
			return;
		}
	}
    
    //document.form1.P_BANK_KEY.value = document.form1.BANK_KEY.vaue;
     
    var nickName       	= "t0002";
    var conType         	= "TRANSACTION";
    var methodName 		= "doApprovaAcctP";
    var SepoaOut        	= doServiceAjax( nickName, conType, methodName );
    
    
    if( SepoaOut.status == "1" ) { // 성공
     	alert(SepoaOut.message);    	
     	opener.doSelect();
     	self.close();

		/* var house_code 		= SepoaOut.result[0];
		var con_number 		= SepoaOut.result[1];
        
		var param = "";
		param += "?mode=update"
		param += "&house_code=" + house_code
		param += "&con_number=" + con_number
		
		location.href = "hw_con_popup.jsp"+param;
		opener.doSelect(); */
     } else {
         if(SepoaOut.message == "null"){
             alert("AjaxError");
         }else{
             alert(SepoaOut.message);
         }
     }
}

</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<%  
thisWindowPopupFlag = "true";
thisWindowPopupScreenName = "계좌번호변경";
%>
<!--내용시작-->
<%@ include file="/include/sepoa_milestone.jsp" %>
<form name="form1" method="post" action="">
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
	<%--APPROVAL INFO 생성을 위한 HIDDEN FIELD--%>
	<input type="hidden" name="house_code"           id="house_code"             value="<%=info.getSession("HOUSE_CODE")%>">
	<input type="hidden" name="company_code"         id="company_code"           value="<%=info.getSession("COMPANY_CODE")%>">
	<input type="hidden" name="dept_code"            id="dept_code"              value="<%=info.getSession("DEPARTMENT")%>">
	<input type="hidden" name="req_user_id"          id="req_user_id"            value="<%=info.getSession("ID")%>">
	<input type="hidden" name="doc_type"             id="doc_type"               value="AR">
	<input type="hidden" name="fnc_name"             id="fnc_name"               value="getApproval">
	<input type="hidden" name="ctrl_dept"            id="ctrl_dept"              value="">
	<input type="hidden" name="ctrl_flag"            id="ctrl_flag"              value="">
    <input type="hidden" name="query_flag"           id="query_flag"             value="off">
    <input type="hidden" name="model_flag"           id="model_flag"             >
    <input type="hidden" name="model_no"             id="model_no"               >
                                                                            
    <input type="hidden" name="material_type"		 id="material_type"		     value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_TYPE"))%>">
    <input type="hidden" name="material_ctrl_type"	 id="material_ctrl_type"	   value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CTRL_TYPE"))%>">
    <input type="hidden" name="material_class1"	     id="material_class1"	       value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS1"))%>">
    <input type="hidden" name="material_class2"	     id="material_class2"	       value="<%=JSPUtil.nullToEmpty(request.getParameter("MATERIAL_CLASS2"))%>">
    <input type="hidden" name="pr_flag"			     id="pr_flag"			       value="<%=JSPUtil.nullToEmpty(request.getParameter("PR_FLAG"))%>">
    <input type="hidden" name="material_class2_name" id="material_class2_name"   >
    <input type="hidden" name="basic_unit"           id="basic_unit"             >
    <input type="hidden" name="item_abbreviation"    id="item_abbreviation"      >
    <input type="hidden" name="app_tax_code"         id="app_tax_code"           >
    <input type="hidden" name="item_block_flag"      id="item_block_flag"        >
	<input type="hidden" name="vendor_code" 		 id="vendor_code" 		     value="<%=vendor_code%>">
                                                                            
	<input type="hidden" name="att_mode"             id="att_mode"               value="">
	<input type="hidden" name="view_type"            id="view_type"              value="">
	<input type="hidden" name="file_type"            id="file_type"              value="">
	<input type="hidden" name="tmp_att_no"           id="tmp_att_no"             value="">
	
	
	
	
	
	<input type="hidden" name="approval_str" id="approval_str" />
	<input type="hidden" name="pflag" id="pflag" />
    


    <tr>
    	<td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체코드
		</td>
		<td width="32%"  class="data_td" >
			<input type="text" 		id="VENDOR_CODE" name="VENDOR_CODE" value='<%=VENDOR_CODE %>'  size="10" maxlength="20" class="input_data2" readOnly>					
		</td>
       <td width="18%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;업체명
		</td>
		<td width="32%" class="data_td">
		    <input type="text" 		id="VENDOR_NAME_LOC" name="VENDOR_NAME_LOC" value='<%=VENDOR_NAME_LOC %>'  size="20" maxlength="50" class="input_data2" readOnly>							
		</td>     
    </tr>  
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
    	<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;거래은행</td>
		<td class="data_td" colspan="3" >
			<select id="BANK_KEY" name="BANK_KEY" class="input_re" <%=readOnly_flag%>>
				<%=LB_BANK_KEY%>
			</select>
		</td>
    </tr>  
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	<tr>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;예금주</td>
		<td class="data_td">
			<input type="text" id="DEPOSITOR_NAME" name="DEPOSITOR_NAME"  value='<%=DEPOSITOR_NAME %>'  size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(50, this, '예금주');" maxlength="50">			
		</td>
		<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계좌번호</td>
		<td class="data_td">
			<input type="text" id="BANK_ACCT" name="BANK_ACCT" value='<%=BANK_ACCT %>' size="20" class="input_re" <%=readOnly_flag%> onKeyUp="return chkMaxByte(30, this, '계좌번호');" onKeyPress="return onlyNumber(event.keyCode);"  data-dataType="n" maxlength="30" style="ime-mode:disabled;">			
		</td>
	</tr>   
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<%--<TD><script language="javascript">btn("javascript:PreSave()","결재요청")</script></TD>--%>
			<TD><script language="javascript">btn("javascript:Approval('P')", "결재요청")</script></TD>						  				
			<td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
		</TR>
		</TABLE>
</TR>
</TABLE>

</form>
<iframe name="childFrame" src="" frameborder="1" width="0" height="50" marginwidth="0" marginheight="0" scrolling="yes"> </iframe>

</s:header>
<%-- <s:grid screen_id="SU_104" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</body>
</html>


