<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_023");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_023";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        	업체평가 상세 <p>
 Description:  	업체평가 상세 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       업체평가 상세
!-->

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="SR_023";%>
<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>

<!-- 사용자 인증 부분 (Option 부분) Login TimeOut 체크 -->
<!--  POP 화면 -->
<!-- JTable Scripts -->
<!--  Session 값 -->
<%
	String house_code 	= info.getSession("HOUSE_CODE");
	String eval_refitem = JSPUtil.nullToEmpty(request.getParameter("eval_refitem"));
	String eval_name 	= JSPUtil.nullToEmpty(request.getParameter("eval_name"));

	String fromdate 	= "";
	String todate 		= "";
	String evaltemp 	= "";

	String ret = null;
	SepoaFormater wf = null;
	SepoaOut value = null;
	SepoaRemote ws = null;

	String nickName= "SR_023";
	String conType = "CONNECTION";
	String MethodName = "getEvaDetailList";
	
	
	
	if(!eval_refitem.equals(""))
	{
		
		//SepoaOut value = doServiceAjax( nickName, conType, methodName ,params);
		/* String MethodName = "getEvalProperty";*/
		
		Object[] obj = { eval_refitem };
		
		try 
		{
			ws = new SepoaRemote(nickName, conType, info);
			value = ws.lookup(MethodName,obj);
			ret = value.result[0];
			wf =  new SepoaFormater(ret);
		}catch(SepoaServiceException wse) 
		{
			Logger.debug.println(info.getSession("ID"),request,"message = " + value.message);
			Logger.debug.println(info.getSession("ID"),request,"status = " + value.status);
		}catch(Exception e) 
		{
		    Logger.debug.println(info.getSession("ID"),request,"e = " + e.getMessage());
		    
		}finally
		{
			try
			{
				ws.Release();
			}catch(Exception e){}
		}

		if(wf != null && wf.getRowCount() > 0) 
		{
			fromdate = wf.getValue("EVAL_FROM_DATE", 0);
			todate = wf.getValue("EVAL_TO_DATE", 0);
			evaltemp = wf.getValue("TEMPLATE_NAME", 0);
		}
	}

%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->



<script language="javascript">
<!--	
var INDEX_SEL;
var INDEX_VALUER;
var INDEX_QTY_YN;
var INDEX_VALUE_ID;
var INDEX_SG_REFITEM;
var INDEX_EVAL_ITEM_REFITEM;

function Init() 
{
setGridDraw();
setHeader();

	var eval_refitem = "<%=eval_refitem%>";

	if(eval_refitem != "")
	{
		document.form1.eval_refitem.value = eval_refitem;		
		document.form1.eval_name.value = "<%=eval_name%>";		
		
		getQuery();
	}
}

function setHeader() 
{
								


	INDEX_SEL 			= GridObj.GetColHDIndex("sel");
	INDEX_VALUER 		= GridObj.GetColHDIndex("valuer");
	INDEX_QTY_YN 		= GridObj.GetColHDIndex("qty_yn");
	INDEX_VALUE_ID 		= GridObj.GetColHDIndex("value_id");
	INDEX_SG_REFITEM 	= GridObj.GetColHDIndex("sg_refitem");
	INDEX_EVAL_ITEM_REFITEM = GridObj.GetColHDIndex("eval_item_refitem");
}

function getQuery() 
{
	var eval_refitem = document.form1.eval_refitem.value;

	if(eval_refitem == "")
	{
		alert("평가명을 선택해야 합니다.");

		document.form1.eval_name.focus();
		return;
	}
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_detail";
	var params ="mode=getEvaList&grid_col_id="+grid_col_id;
	params += dataOutput();
	GridObj.post(url, params);
 	GridObj.clearAll(false);
	/* servletURL = "/servlets/master.evaluation.eva_bd_upd1";
	GridObj.SetParam("eval_refitem", eval_refitem);

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletURL);
	GridObj.strHDClickAction="sortmulti"; */
}

function from_date(year,month,day,week) 
{
	document.form1.fromdate.value=year+month+day;
}

function to_date(year,month,day,week) 
{
	document.form1.todate.value=year+month+day;
}

function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
	if(msg3 == INDEX_VALUER)
	{
		var qty_yn = GD_GetCellValueIndex(GridObj,msg2, INDEX_QTY_YN);	

		if(qty_yn == "N") <%--정량평가만 있는 경우 --%>
		{
			alert("정량평가 항목만 있는 평가템플릿은 평가자를 지정 할 수 없습니다.");
			return;
		}

		var url = "eva_pp_ins1.jsp?i_row=" + msg2;

		window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=450,left=0,top=0");
	}
}

function getCompany(szRow) 
{
	if (0 < parseInt(GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUER))) 
	{
		return com_data = GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUE_ID);
	}
	return;
}

function valuerInsert(szRow, SELECTED, SELECTED_COUNT) 
{
}

function itemDelete()
{
	rightrowcount = GridObj.GetRowCount();

	for(row = rightrowcount-1; row >= 0; row--) 
	{
		if( "true" == GD_GetCellValueIndex(GridObj,row, "0")) 
		{
			GridObj.DeleteRow(row);
		}
	}
}

function update_item(flag)
{
	var chk_cnt;
	for(row=GridObj.GetRowCount()-1; row>=0; row--) 
	{
		GD_SetCellValueIndex(GridObj,row, INDEX_SEL,"true&", "&");
		
		qty_yn = GD_GetCellValueIndex(GridObj,row, INDEX_QTY_YN);

		if(qty_yn == "Y")
		{
			value_yn = GD_GetCellValueIndex(GridObj,row, INDEX_VALUER);	

			if(value_yn != "Y")
			{
				alert("정성평가항목이 있는 평가건에 대해서는 평가자를 지정하셔야 합니다.");
				return;
			}
		}		
		chk_cnt++;
	}

	if(chk_cnt == 0)
	{
		alert("지정된 평가업체가 없습니다. 평가업체 지정 후 평가 생성 하십시요.");
		return;
	}
	
	f = document.form1;
	var eval_refitem = f.eval_refitem.value;	
	var fromdate = del_Slash(f.fromdate.value);	
	var todate = del_Slash(f.todate.value);	

	if(fromdate == "" || todate == "") 
	{
		alert("평가기간을 입력해 주세요.");
		return;
	}

	if(document.form1.selectedSg.length == 0) 
	{
  		alert("선택된 항목이 없습니다.");
  		return;
	}

	servletUrl = "/servlet/master.evaluation.eva_bd_upd1";; 

	GridObj.SetParam("eval_refitem", eval_refitem);
	GridObj.SetParam("fromdate", fromdate);
	GridObj.SetParam("todate", todate);
	GridObj.SetParam("flag", flag);

	Message = "";
	if(flag == "1") Message = "저장 하시겠습니까?";
	if(flag == "2") Message = "실행 하시겠습니까?";

	if(confirm(Message) == 1) 
	{
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
	}
}
//-->
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
	if(GridObj.getColIndexById("valuer") == cellInd )
	{
		var qty_yn = GD_GetCellValueIndex(GridObj,GridObj.getRowIndex(rowId), INDEX_QTY_YN);	

		if(qty_yn == "N") <%--정량평가만 있는 경우 --%>
		{
			alert("정량평가 항목만 있는 평가템플릿은 평가자를 지정 할 수 없습니다.");
			return;
		}
		
<%-- 		var url = "<%=POASRM_CONTEXT_NAME%>/procure/evaluator_list.jsp"; --%>
// 		var param = "";
// 		param += "?popup_flag_header=true";
// 		param += "&i_row="+rowId;
// 		PopupGeneral(url+param, "valuer", "", "", "800", "640");		
// 		var url = "eva_pp_ins1.jsp?i_row=" + getRowIndex(rowId);
		var url = "<%=POASRM_CONTEXT_NAME%>/procure/evaluator_list.jsp?popup_flag_header=true&i_row=" + GridObj.getRowIndex(rowId);
		window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=450,left=0,top=0");
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
    
    document.form1.fromdate.value = add_Slash(document.form1.fromdate.value); 
    document.form1.todate.value = add_Slash(document.form1.todate.value); 
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  >

<!--내용시작-->
<form name="form1" method="post" action="">

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;평가상세내역
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr> 
	<td width="10%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="90%" class="c_data_1" colspan="3">
		<input type="text" size="40" class="input_data0" name="eval_name" id="eval_name" readonly >
		<input type="hidden" size="20" maxlength="20" class="input_data0" name="eval_refitem" id="eval_refitem" >
	</td>
</tr>
<tr> 
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가기간</div>
	</td>
	<td width="35%" class="c_data_1">
		<s:calendar id_from="fromdate"  default_from="<%=SepoaString.getDateSlashFormat(fromdate)%>" id_to="todate" default_to="<%=SepoaString.getDateSlashFormat(todate)%>" format="%Y/%m/%d" />
		<%-- <input type="text" name="fromdate" value="<%=fromdate%>" class="input_re" size="10" maxlength="8" >
		<a href="javascript:Calendar_Open('from_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a>
		~
		<input type="text" name="todate" value="<%=todate%>" class="input_re" size="10" maxlength="8" >
		<a href="javascript:Calendar_Open('to_date');"><img src="../../images/button/butt_calender.gif" width="22" height="19" align="absmiddle" border="0"></a> --%>
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가템플릿</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type="text" size="20" maxlength="20" class="input_data0" value = "<%=evaltemp%>" name="evaltemp" readonly >
	</td>
</tr>
<tr> 
	<td width="10%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가소싱그룹</div>
	</td>
	<td class="c_data_1" colspan="3">
		<table><tr><td height="1"></td></tr></table>
        <SELECT style="width:250px; height:80px"  class="input_re"  NAME="selectedSg" MULTIPLE SIZE=5>
<%
	if(wf != null ) {
		for(int i=0; i < wf.getRowCount(); i++) {
%>
			<option value=''><%=wf.getValue("SG_NAME", i)%></option>
<%
		}
	}
%>
		</SELECT>
		<table ><tr><td height="1"></td></tr></table>
	</td>
</tr>
</table>

<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" width="50%" valign="bottom">
	</td>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:self.close()","닫 기")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

<%-- <table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","300")%>
	</td>
</tr>
</table> --%>
</form>

<s:grid screen_id="SR_023" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


