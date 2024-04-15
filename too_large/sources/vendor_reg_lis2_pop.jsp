<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_103_01");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_103_01";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<% String WISEHUB_PROCESS_ID="SU_103_01";%>

<%
    String house_code   = info.getSession("HOUSE_CODE");
    String company_code = info.getSession("COMPANY_CODE");
    String vendor_code	= JSPUtil.nullToEmpty(request.getParameter("vendor_code")); 
    
    String Attach_Index = "";
    SepoaListBox lb = new SepoaListBox();
    String result = lb.Table_ListBox( request, "SL0200", house_code, "#", "@");

    String Z_CHARACTER_CLASS1 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS1"));
    if(Z_CHARACTER_CLASS1 == null ) Z_CHARACTER_CLASS1 = "";
    String Z_CHARACTER_CLASS2 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS2"));
    if(Z_CHARACTER_CLASS2 == null ) Z_CHARACTER_CLASS2 = "";
    String Z_CHARACTER_CLASS3 = JSPUtil.CheckInjection(request.getParameter("Z_CHARACTER_CLASS3"));
    if(Z_CHARACTER_CLASS3 == null ) Z_CHARACTER_CLASS3 = "";

    String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
	Object[] args     = new Object[1];
	         args[0] = vendor_code;
	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","req_ins_getVnglList", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	String ATTACH_NO 					="";
	String ATTACH_CNT 					="";
	String CREDIT_RATING 				="";
	
	for ( int i = 0; i<wf.getRowCount(); i++) {
		CREDIT_RATING      		 	    = wf.getValue("CREDIT_RATING"     		,   i);
	  	ATTACH_NO						= wf.getValue("ATTACH_NO"   	    	,   i);
	  	ATTACH_CNT						= wf.getValue("ATTACH_CNT"   	    	,   i);
    }                                                    
%>
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
			attach_no 		     : $('#attach_no 		    ').val(),
			vendor_code 		 : $('#vendor_code 		    ').val(),   
			att_mode             : $('#att_mode             ').val(), 
			view_type            : $('#view_type            ').val(), 
			file_type            : $('#file_type            ').val(), 
			tmp_att_no           : $('#tmp_att_no           ').val(),
			credit_rating        : $('#credit_rating        ').val(),

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
	if(""==document.forms[0].credit_rating.value  ){
		alert("신용등급은 필수 입력 입니다.");
		return;
	}
	//if(true == document.forms[0].MAKER_FLAG.checked && (document.forms[0].MAKER_NAME.value )) {
	//	alert("Maker 해당없음을 선택하셨습니다.");
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

function rMateFileAttach(att_mode, view_type, file_type, att_no) {
	var f = document.forms[0];

	f.att_mode.value   = att_mode;
	f.view_type.value  = view_type;
	f.file_type.value  = file_type;
	f.tmp_att_no.value = att_no;

	if (att_mode == "S") {
		f.method = "POST";
		f.target = "attachFrame";
		f.action = "/rMateFM/rMate_file_attach.jsp";
		f.submit();
	}
}

function setrMateFileAttach(att_no, att_cnt, att_data, att_del_data) {
	var attach_key   = att_no;
	var attach_count = att_cnt;

	var f = document.forms[0];
	f.ATTACH_NO.value    = attach_key;
   	//document.forms[0].MAKER_FLAG.value = (true == document.forms[0].MAKER_FLAG.checked)?"Y":"N";
	form1.method = "POST";
	form1.target = "childFrame";
	form1.action = "vendor_reg_lis2_ins2.jsp";
	form1.submit();
}

function doSave(message, v_status){
		alert(message);
		//location.href="vendor_reg_lis2_pop.jsp";
		goSubmit();
}


function setAttach(attach_key, arrAttrach, attach_count) {
		var f = document.forms[0];
		f.ATTACH_NO.value = attach_key;
		f.attach_count.value = attach_count;
}

</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">
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
</script>
</head>
<body onload="" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header popup="true">
<!--내용시작-->
<% if("".equals(gate)){%>
<%@ include file="/include/sepoa_milestone.jsp" %>
<%}%>
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
	<input type="hidden" name="doc_type"             id="doc_type"               value="PR">
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
	<input type="hidden" name="attach_no" 		     id="attach_no" 		       value="<%=ATTACH_NO%>">
	<input type="hidden" name="vendor_code" 		 id="vendor_code" 		     value="<%=vendor_code%>">
                                                                            
	<input type="hidden" name="att_mode"             id="att_mode"               value="">
	<input type="hidden" name="view_type"            id="view_type"              value="">
	<input type="hidden" name="file_type"            id="file_type"              value="">
	<input type="hidden" name="tmp_att_no"           id="tmp_att_no"             value="">

    <tr>
      <td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;신용등급</td>
      <td  class="data_td" colspan="3">
        <input type="text" name="credit_rating" id="credit_rating"  value="<%=CREDIT_RATING%>"  size="81" class="inputsubmit" onKeyUp="return chkMaxByte(500, this, '신용등급');">
      </td>
    </tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>   
    <!--
    <tr>
      	<td width="13%" class="title_td">파일첨부</td>
      	<td class="data_td" colspan="3">
			<script language="javascript">btn_file("javascript:attach_file(form1.ATTACH_NO.value,'ITEM')",15,"첨부파일")</script>
	  	</td>
    </tr>
    -->
	<tr>
		<td width="20%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;파일첨부</td>
		<td class="data_td" colspan="3" height="50">
			<!-- <iframe name="attachFrame" width="620" height="150" marginwidth="0" marginheight="0" frameborder="0" scrolling="no"></iframe>
			<br>&nbsp; -->
			<script language="javascript">
			 btn("javascript:attach_file(document.getElementById('sign_attach_no').value, 'FILE');", "파일등록");
			</script>
			<input type="text" size="3" readOnly class="input_empty" value="0" name="attach_no_count" id="attach_no_count"/>
			<input type="hidden" value="" name="attach_no" id="attach_no">
			
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
			<TD><script language="javascript">btn("javascript:PreSave()","저 장")</script></TD>
			<td><script language="javascript">btn("javascript:window.close()","닫기")</script></td>
		</TR>
		</TABLE>
</TR>
</TABLE>

</form>
<iframe name="childFrame" src="" frameborder="1" width="0" height="50" marginwidth="0" marginheight="0" scrolling="yes"> </iframe>
<%-- <script language="javascript">rMateFileAttach('S','C','VNGL',form1.ATTACH_NO.value);</script> --%>

</s:header>
<%-- <s:grid screen_id="SU_104" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>


