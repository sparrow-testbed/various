<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        	소싱그룹/품목분류 연결 현황 <p>
 Description:  	소싱그룹/품목분류 연결 현황 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       소싱그룹/품목분류 연결 현황
--%>

<% String WISEHUB_PROCESS_ID="SR_004";%>
<% String WISEHUB_LANG_TYPE="KR";%>


<%
	String house_code = info.getSession("HOUSE_CODE");
%>

<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<script language="javascript" type="text/javascript">

function Init()
{
	doRequestUsingPOST( 'SL0116', '1#'+"<%=house_code%>" ,'s_type1', '' );
setGridDraw();
setHeader();
}

function setHeader()
{


}

function Query()
{
	var s_type1 = document.form1.s_type1.value;
	var s_type2 = document.form1.s_type2.value;
	var s_type3 = document.form1.s_type3.value;

	if(s_type1 == "")
	{
		alert("대분류을 선택해야 합니다.");
		return;
	}
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_link_list";
	var params ="mode=getSgLinkList&grid_col_id="+grid_col_id;
	params += dataOutput();
	GridObj.post(url, params);
 	GridObj.clearAll(false);
	/* params += "&s_type1="+document.form1.s_type1.value;
	params += "&s_type2="+document.form1.s_type2.value;
	params += "&s_type3="+document.form1.s_type3.value; */
	/* GridObj.SetParam("s_type1", s_type1);
	GridObj.SetParam("s_type2", s_type2);
	GridObj.SetParam("s_type3", s_type3);

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletURL);
	GridObj.strHDClickAction="sortmulti"; */
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
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	var house_code = "<%=house_code%>";
	var code = "2";
	var value = form1.s_type1.value;
	document.form1.s_type2.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'s_type2','' );
	/* var id = "SL0121";
	var code = "2";

	var value = form1.s_type1.value;
	target = "MATERIAL_CTRL_TYPE";

	data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data; */
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

	//var id = "SL0121";
	var code = "3";
	var house_code = "<%=house_code%>";
	var value = form1.s_type2.value;
	//target = "MATERIAL_TYPE";
	var newOption = document.createElement('OPTION');
	newOption.text="전체";
	newOption.value="";
	document.form1.s_type3.add(newOption, null);
	doRequestUsingPOST( 'SL0121', house_code+'#'+code+'#'+value ,'s_type3','' );
	/* data = "/kr/master/sg/sou_bd_lis1_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    document.childFrame.location.href = data; */
}
function JavaCall(msg1,msg2,msg3,msg4,msg5){
<%--
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(i%2 == 1){
			for (var j = 0;	j<GridObj.GetColCount(); j++){
				//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
			}
		}
	}
--%>	
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
			<select name="s_type1" id="s_type1" class="input_re" onChange="javacsript:MATERIAL_TYPE_Changed();">
				<option value=''>선택</option>
			</select>
		</td>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 소싱그룹 중분류</td>
		<td width="35%" class="c_data_1">
			<select name="s_type2" id="s_type2" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
				<option value=''>전체</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 소싱그룹 소분류</td>
		<td width="35%" class="c_data_1" colspan="3">
			<select name="s_type3" id="s_type3" class="inputsubmit">
				<option value=''>전체</option>
			</select>
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
<s:grid screen_id="SR_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
	</body>
</html>


