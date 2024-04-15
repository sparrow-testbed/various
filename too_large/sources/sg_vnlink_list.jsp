<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        	소싱그룹/협력업체 연결 현황 <p>
 Description:  	소싱그룹/협력업체 연결 현황 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       소싱그룹/협력업체 연결 현황
--%>

<% String WISEHUB_PROCESS_ID="SR_006";%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
%>
<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/wisehub_scripts.jsp"%>
<script language="javascript" src="../../jscomm/crypto.js" type="text/javascript"></script> --%>
<script language="javascript" type="text/javascript">

var INDEX_vendor_code;
var INDEX_credit_grade;
var INDEX_irs_no;

function Init()
{
	doRequestUsingPOST( 'SL0116', '1#'+"<%=house_code%>" ,'s_type1', '' );
setGridDraw();
setHeader();
}

function setHeader()
{


	


	INDEX_vendor_code 	= GridObj.GetColHDIndex("vendor_code");
	INDEX_credit_grade 	= GridObj.GetColHDIndex("credit_grade");
	INDEX_irs_no		= GridObj.GetColHDIndex("irs_no");
}

function Query()
{
	var s_type1 = document.form1.s_type1.value;
	var s_type2 = document.form1.s_type2.value;
	var s_type3 = document.form1.s_type3.value;
	var vendor_code = document.form1.vendor_code.value;

	if(s_type1 == "" && vendor_code == "")
	{
		/* alert("[대분류/업체코드] 중 한 값은 선택해야 합니다.");
		return; */
	}
	
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_vnlink_list";
	var params ="mode=getSgVnLinkList&grid_col_id="+grid_col_id;
	params += dataOutput();
	GridObj.post(url, params);
 	GridObj.clearAll(false);
}

function entKeyDown()
{
	if(event.keyCode==13)
	{
		window.focus();
		Query();
	}
}

function MATERIAL_TYPE_Changed()
{
	clearMATERIAL_CTRL_TYPE();
	clearMATERIAL_CLASS1();
	var house_code = "<%=house_code%>";
	var code = "2";
	var value = form1.s_type1.value;
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	document.form1.s_type2.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'s_type2','' );
}

function clearMATERIAL_CTRL_TYPE()
{
	if(form1.s_type2.length > 0)
	{
		for(i=form1.s_type2.length-1; i>=0;  i--) {
			form1.s_type2.options[i] = null;
		}
	}
}

function clearMATERIAL_CLASS1()
{
	if(form1.s_type3.length > 0)
	{
		for(i=form1.s_type3.length-1; i>=0;  i--)
		{
			form1.s_type3.options[i] = null;
		}
	}
}

function setMATERIAL_CLASS1(name, value)
{
	var option1 = new Option(name, value, true);
	form1.s_type2.options[form1.s_type2.length] = option1;
}

function setMATERIAL_CTRL_TYPE(name, value)
{
	var option1 = new Option(name, value, true);
	form1.s_type3.options[form1.s_type3.length] = option1;
}

function MATERIAL_CTRL_TYPE_Changed()
{
	clearMATERIAL_CLASS1();

	var code = "3";
	var house_code = "<%=house_code%>";
	var value = form1.s_type2.value;
	//target = "MATERIAL_TYPE";
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	document.form1.s_type3.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'s_type3','' );
	
	/* var id = "SL0121";
	var code = "3";

	var value = form1.s_type2.value;
	target = "MATERIAL_TYPE";

	data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data; */
}

function VendorCode()
{
	var f0 = document.form1;

	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0218&function=setVendor&values=<%=house_code%>&values=&values=";
	var left = 50;  var top = 100;  var width = 550;        var height = 450;       var toolbar = 'no';     var menubar = 'no';     var status = 'yes';     var scrollbars = 'no';    var resizable = 'no';
	var agentCodeWin = window.open( url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function PopupManager()
{
	var f0 = document.form1;
	var value = f0.vendor_code.value;
	PopupCommon2("SP0218","setVendor","<%=info.getSession("HOUSE_CODE")%>","&values=&values","코드","설명");
}

function setVendor(code, text1, text2)
{
	 document.form1.vendor_code.value = code;
	 document.form1.vendor_code_name.value = text1;
}

function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(i%2 == 1){
			for (var j = 0;	j<GridObj.GetColCount(); j++){
				//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
			}
		}
	}

	if(msg1 == "t_imagetext")
	{
		if(msg3 == INDEX_vendor_code)
		{
			var vendor_code = GD_GetCellValueIndex(GridObj,msg2,INDEX_vendor_code);
			var irs_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_irs_no);
			window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
			//window.open("/kr/master/vendor/ven_pp_dis1.jsp?vendor_code="+vendor_code+"&flag=popup","windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=530,left=0,top=0") ;
		}else if (msg3 == INDEX_credit_grade){
			var irs_no = GD_GetCellValueIndex(GridObj,msg2,INDEX_irs_no);
			var credit_grade = GD_GetCellValueIndex(GridObj,msg2,INDEX_credit_grade);
			if(credit_grade == ""){
				alert("신용등급이 없습니다."); 
				return;
			} 
			var url = "http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_ibk.jsp?bz_ins_no="+irs_no; 
			var credit_eval = window.open(url,"credit","left=0,top=0,width=900,height=780,resizable=yes,scrollbars=yes");
			credit_eval.focus();			
		}
	}
}
</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
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
	if(cellInd == GridObj.getColIndexById("vendor_code"))
	{
		var vendor_code = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId),INDEX_vendor_code);
		var irs_no = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId),INDEX_irs_no);
		window.open("/s_kr/admin/info/ven_bd_con.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
		//window.open("/kr/master/vendor/ven_pp_dis1.jsp?vendor_code="+vendor_code+"&flag=popup","windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=530,left=0,top=0") ;
	}else if (cellInd == GridObj.getColIndexById("credit_grade")){
		var irs_no = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId),INDEX_irs_no);
		var credit_grade = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId),INDEX_credit_grade);
		if(credit_grade == ""){
			alert("신용등급이 없습니다."); 
			return;
		} 
		var url = "http://clip.nice.co.kr/rep_nclip/rep_DLink/rep_Link_ibk.jsp?bz_ins_no="+irs_no; 
		var credit_eval = window.open(url,"credit","left=0,top=0,width=900,height=780,resizable=yes,scrollbars=yes");
		credit_eval.focus();			
	}	
	
	
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
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
    var messsage = obj.getAttribute("message");
    var mode     = obj.getAttribute("mode");
    var status   = obj.getAttribute("status");

    document.getElementById("message").innerHTML = messsage;

    myDataProcessor.stopOnError = true;

    if(dhxWins != null) {
        dhxWins.window("prg_win").hide();
        dhxWins.window("prg_win").setModal(false);
    }

    if(status == "true") {
        alert(messsage);
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    } 

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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>

<s:header>
<!--내용시작-->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<%-- <script language="javascript">rdtable_top1()</script> --%>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">

<form name="form1" method="post" action="">
	<tr>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 소싱그룹 대분류</td>
		<td width="35%" class="c_data_1">
			<select name="s_type1" id="s_type1" class="inputsubmit" onChange="javacsript:MATERIAL_TYPE_Changed();">
				<option value=''>선택</option>
			</select>
		</td>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 소싱그룹 중분류</td>
		<td width="35%" class="c_data_1">
			<select name="s_type2" id="s_type2" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
				<option value=''>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 소싱그룹 소분류</td>
		<td width="35%" class="c_data_1">
			<select name="s_type3" id="s_type3" class="inputsubmit">
				<option value=''>선택</option>
			</select>
		</td>
		<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 업체코드</td>
		<td class="c_data_1" width="35%">
			<input type="text" name="vendor_code" id="vendor_code" size="15" class="inputsubmit" maxlength="10" >
			<a href="javascript:PopupManager()">
				<img src="/images/icon/icon_search.gif" align="absmiddle" border="0" alt="">
			</a>
			<input type="text" name="vendor_code_name" id="vendor_code_name" size="20" class="input_data2">
		</td>
	</tr>
</table>
<%-- <script language="javascript">rdtable_bot1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
    	  			<td><script language="javascript">btn("javascript:Query()","조 회")</script></td>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>

<%-- <table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","360")%>
	</td>
</tr>
</table> --%>

	</form>
	<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

</s:header>
<s:grid screen_id="SR_006" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
<iframe name = "getDescframe" src=""  width="0" height="0" border="no" frameborder="no"></iframe>


