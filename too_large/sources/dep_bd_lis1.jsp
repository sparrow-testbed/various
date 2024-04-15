<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_103");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "AD_103";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% %>
<%--
화면명  : 부서단위 (/kr/admin/organization/depart/dep_bd_lis1.jsp)
내  용  : 조회/등록/수정/삭제/상세정보 처리
작성자  : 신병곤
작성일  : 2006.01.19.
비  고  :
--%>
<%
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
%>
<% String WISEHUB_PROCESS_ID="AD_103";%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/admin.organization.depart.dep_bd_lis1";

var IDX_SEL                 = "" ;
var IDX_DEPT                = "" ;
var IDX_NAME_LOC            = "" ;
var IDX_NAME_ENG            = "" ;
var IDX_PR_LOCATION_NAME    = "" ;
var IDX_PR_LOCATION         = "" ;
var IDX_HIGH_DEPT	        = "" ;
var IDX_HIGH_DEPT_TEXT      = "" ;
var IDX_DEPT_LEVEL          = "" ;
var titleName = "부서단위";
var url = document.location.pathname;

function Init() {
	setGridDraw();
	setHeader();
	doSelect();
}

function setHeader() 
{
// 	GridObj.AddHeader( "PR_LOCATION"     ,   "","t_text",100,0,false);
	
	//GridObj.SetColCellBgColor(    "DEPT"            ,G_COL1_ESS);
		

	IDX_SEL                 = GridObj.GetColHDIndex("SEL");
	IDX_DEPT                = GridObj.GetColHDIndex("DEPT");
	IDX_NAME_LOC            = GridObj.GetColHDIndex("DEPT_NAME_LOC");
	IDX_NAME_ENG            = GridObj.GetColHDIndex("DEPT_NAME_ENG");
	IDX_PR_LOCATION_NAME    = GridObj.GetColHDIndex("PR_LOCATION_NAME");
	IDX_PR_LOCATION         = GridObj.GetColHDIndex("PR_LOCATION");
	IDX_HIGH_DEPT	        = GridObj.GetColHDIndex("HIGH_DEPT");
	IDX_HIGH_DEPT_TEXT      = GridObj.GetColHDIndex("HIGH_DEPT_TEXT");
	IDX_DEPT_LEVEL          = GridObj.GetColHDIndex("DEPT_LEVEL");
}

//Query 조건의 데이타 Check.
function queryDataCheck(check) {
	if (check != null && check.length != 0) return true;
	else return false;
}

function checkedRow() {
	var sendRow = "";
	var row = GridObj.GetRowCount();

	for (var i = 0; i<row; i++) {
		var check = GD_GetCellValueIndex(GridObj,i,IDX_SEL);
		if (check == true) sendRow += (i+"&");
	}
	return sendRow;
}
 
function getTopSelectedRow(SelectedRow) {
	var selected = SelectedRow.substring(0, SelectedRow.indexOf("&"));
	return selected;
}

function doSelect() 
{
	var FormName = document.forms[0];
	
	var check = FormName.I_COMPANY_CODE.value;
	if (queryDataCheck(check)) 
	{
		var I_COMPANY_CODE    = FormName.I_COMPANY_CODE.value;
		FormName.I_DEPT.value = FormName.I_DEPT.value.toUpperCase();

		var I_DEPT        = FormName.I_DEPT.value;
		var I_DEPT_NAME   = FormName.I_DEPT_NAME.value;
		var I_PR_LOCATION = FormName.I_PR_LOCATION.value;

		//var servletUrl = "/servlet/admin.organization.depart.dep_lis1";

		
		var cols_ids = "<%=grid_col_id%>";
		var params = "mode=getMainternace";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj.post( G_SERVLETURL, params );
		GridObj.clearAll(false);
		
<%-- 		GridObj.SetParam("I_HOUSE_CODE","<%=house_code%>"); --%>
// 		GridObj.SetParam("I_COMPANY_CODE",I_COMPANY_CODE);
// 		GridObj.SetParam("I_DEPT",I_DEPT);
// 		GridObj.SetParam("I_DEPT_NAME",I_DEPT_NAME);
// 		GridObj.SetParam("I_PR_LOCATION",I_PR_LOCATION);

// 		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(G_SERVLETURL);
// 		GridObj.strHDClickAction="sortmulti";
// 		FormName.query_flag.value = "2";
	} else {
		alert("Company code를 입력해 주십시요.");
	}
}

function doInsert()
{
	var I_COMPANY_CODE = document.form.I_COMPANY_CODE.value;
	if(I_COMPANY_CODE.length < 1 || document.form.query_flag.value != "2" )
	{
		alert("데이터 조회 후 생성하세요.");
		return;
	}
	location.href = "/kr/admin/organization/depart/dep_bd_ins1.jsp?I_COMPANY_CODE="+I_COMPANY_CODE;
}

function doUpdate() 
{
	
	var sepoa = GridObj;
	var FormName = document.forms[0];
	var iCheckedCount = getCheckedCount(sepoa, IDX_SEL);
	
	if(iCheckedCount<1)
	{
		alert("선택한 내역이 없습니다.");
		return;
	}
	if(iCheckedCount>1)
	{
		alert("하나의 항목만 선택하여 주십시오.");
		return;
	}

	var selected       = checkedOneRow(IDX_SEL);
	var I_DEPT         = GD_GetCellValueIndex(GridObj,selected,IDX_DEPT);
	var I_PR_LOCATION  = GD_GetCellValueIndex(GridObj,selected,IDX_PR_LOCATION);
	var I_COMPANY_CODE = FormName.I_COMPANY_CODE.value;
	location.href = "/kr/admin/organization/depart/dep_bd_upd1.jsp?I_DEPT="+I_DEPT+"&I_COMPANY_CODE="+I_COMPANY_CODE+"&I_PR_LOCATION="+I_PR_LOCATION+"&url="+url+"&titleName="+titleName;
	
}

function doDelete() 
{
	var sepoa = GridObj;
	var FormName = document.forms[0];
	var iCheckedCount = getCheckedCount(sepoa, IDX_SEL);
	
	if(iCheckedCount<1)
	{
		alert("행을 선택하세요");
		return;
	}
	
	var I_COMPANY_CODE = document.form.I_COMPANY_CODE.value;
	//var servletUrl = "/servlet/admin.organization.depart.dep_del1";
	GridObj.SetParam("I_COMPANY_CODE",I_COMPANY_CODE);
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
	GridObj.strHDClickAction="sortmulti";

}

function doDisplay() {
	var checked = checkedRow();
	if (checked.length != 0) {
		var selected		= getTopSelectedRow(checked);
		var dept			= GD_GetCellValueIndex(GridObj,selected,IDX_DEPT);
		var pr_location		= GD_GetCellValueIndex(GridObj,selected,IDX_PR_LOCATION);
		var I_COMPANY_CODE	= document.form.I_COMPANY_CODE.value;
		
		location.href = "/kr/admin/organization/depart/dep_bd_dis1.jsp?I_DEPT="+dept+"&I_COMPANY_CODE="+I_COMPANY_CODE+"&I_PR_LOCATION="+pr_location+"&url="+url+"&titleName="+titleName;
	}
	else {
		alert("조회할 Row를 선택해 주세요.");
	}
}


function entKeyDown()
{
	if(event.keyCode==13) {
		window.focus();
		doSelect();
	}
}


function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doData")
	{
		doSelect();
	}
}
</script>

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
    $("#query_flag").val("2");
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" text="#000000"  >

<s:header>
<!--내용시작-->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
	  		<td class="cell_title1" width="78%" align="left">&nbsp;
	  		<%@ include file="/include/sepoa_milestone.jsp" %>
	  		</td>
	</tr>
	<tr>
    	 	<td height="10"> </td>
	  </tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="760" height="2" bgcolor="#0072bc"></td>
	</tr>
</table>
  <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#ccd5de">
 <form id="form" name="form" >
 <input type="hidden" id="query_flag" name="query_flag" value="1" class="inputsubmit">
	<tr>
	  <td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 회사코드</td>
	  <td width="35%" class="data_td" colspan="3">
		 <select id="I_COMPANY_CODE" name="I_COMPANY_CODE" class="input_re">
		 <option value=""></option>
		 <%
		 String lb = ListBox(request, "SL0006" ,house_code+"#", company_code);
		 out.println(lb);
		 %>
		</select>
		
		<input type="hidden" id="I_PR_LOCATION" name="I_PR_LOCATION" />
	  </td>
	 <%--  <td width="15%" class="c_title_1"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 청구지역</td>
	  <td width="35%" class="c_data_1">
		<select id="I_PR_LOCATION" name="I_PR_LOCATION" class="inputsubmit">
			<option value=""></option>
		 <%
		 String pr_location = ListBox(request, "SL0018" ,house_code+"#M062#", "");
		 out.println(pr_location);
		 %>
		</select>
	  </td> --%>
	</tr>
	<tr>
		<td colspan="4" height="1" bgcolor="#dedede"></td>
	</tr>
	
	<tr>
	  <td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부서코드</td>
	  <td width="35%" class="data_td">
		<input type="text" id="I_DEPT" name="I_DEPT" maxlength="10" class="inputsubmit" style="width:95%">
	  </td>
	  <td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;부서명</td>
	  <td width="35%" class="data_td">
		<input type="text" id="I_DEPT_NAME" name="I_DEPT_NAME" maxlength="10" class="inputsubmit" style="width:95%">
	  </td>
	</tr>
  </table>
  </td>
                		</tr>
            		</table>
<%-- <script language="javascript">rdtable_bot1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
	      		<TD><script language="javascript">btn("javascript:doSelect()","조 회")</script></TD>
				<%-- <TD><script language="javascript">btn("javascript:doInsert()","등 록")</script></TD>
				<TD><script language="javascript">btn("javascript:doUpdate()","수 정")</script></TD>
				<TD><script language="javascript">btn("javascript:doDelete()","삭 제")</script></TD> --%>
<%-- 				<TD><script language="javascript">btn("javascript:doDisplay()","상세정보")</script></TD> --%>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>  
<!--   <table width="100%" border="0" cellpadding="0" cellspacing="0" > -->
<!-- 	<tr> -->
<!-- 		<td height="1" class="cell"></td> -->
<!-- 	<!-- sepoagrid 상단 bar --> 
<!-- 	</tr> -->
<!-- 	<tr> -->
<!-- 		<td align="center"> -->
<%-- 		  <%=WiseTable_Scripts("100%","320")%></td> --%>
<!-- 	</tr> -->
<!-- 	</table> -->
</form>

</s:header>
<s:grid screen_id="AD_103" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>


