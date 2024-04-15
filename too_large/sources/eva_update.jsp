<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_022");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_022";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<!--
 Title:        	업체평가 수정 <p>
 Description:  	업체평가 수정 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       업체평가 수정
!-->


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

	String nickName= "p0080";
	String conType = "CONNECTION";
	if(!eval_refitem.equals(""))
	{
		String MethodName = "getEvalProperty";
		Map<String, String> data = new HashMap<String, String>();
		data.put("eval_refitem", eval_refitem);
		Object[] obj = { data };
	
		try 
		{
			value = ServiceConnector.doService(info, "SR_022", "CONNECTION", "getEvaDetailList", obj);
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
			fromdate = SepoaString.getDateSlashFormat(wf.getValue("EVAL_FROM_DATE", 0));
			todate = SepoaString.getDateSlashFormat(wf.getValue("EVAL_TO_DATE", 0));
			evaltemp = wf.getValue("TEMPLATE_NAME", 0);
		}
	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

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

// 	var servletUrl = "/servlets/master.evaluation.eva_bd_upd1";
// 	GridObj.SetParam("eval_refitem", eval_refitem);
// 	GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
// 	GridObj.SendData(servletUrl);	
		
// 	GridObj.strHDClickAction="sortmulti";
	//////////////////////////////////////////////////////////////////////////////////////
	
	document.form1.fromdate.value = del_Slash(document.form1.fromdate.value );
	document.form1.todate.value   = del_Slash(document.form1.todate.value   );
	
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_update";
	var grid_col_id = "<%=grid_col_id%>";
	var param = "mode=getEvaList&grid_col_id="+grid_col_id;
	param += dataOutput();
	GridObj.post(servletUrl, param);
	GridObj.clearAll(false);
}

function entKeyDown() 
{
	if(event.keyCode==13) 
	{
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Query();
	}
}

function from_date(year,month,day,week) 
{
	document.form1.fromdate.value=year+month+day;
}

function to_date(year,month,day,week) 
{
	document.form1.todate.value=year+month+day;
}

// function JavaCall(msg1,msg2,msg3,msg4,msg5)
// {
// 	if(msg3 == INDEX_VALUER)
// 	{
// 		var qty_yn = GD_GetCellValueIndex(GridObj,msg2, INDEX_QTY_YN);	

<%-- 		if(qty_yn == "N") 정량평가만 있는 경우 --%>
// 		{
// 			alert("정량평가 항목만 있는 평가템플릿은 평가자를 지정 할 수 없습니다.");
// 			return;
// 		}

// 		var url = "eva_pp_ins1.jsp?i_row=" + msg2;
// 		window.open(url ,"windowopenPP","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=800,height=450,left=0,top=0");
// 	}

// 	if(msg1 == "doData")
// 	{
// 		//alert(GD_GetParam(GridObj,0));

// 		var result = GD_GetParam(GridObj,1);
		
// 		if(result == "S")
// 		{
// 			var eval_refitem = document.form1.eval_refitem.value;
// 			var eval_name = document.form1.eval_name.value;

//             location.href = "eva_bd_upd1.jsp?eval_refitem=" + eval_refitem +
// 					       "&eval_name=" + eval_name;
// 		}
// 	}
// }

function getCompany(szRow) 
{
	if ("Y" == GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUER)) 
	{
		return com_data = GD_GetCellValueIndex(GridObj,szRow, INDEX_VALUE_ID);
	}
	return;
}

function valuerInsert(szRow, SELECTED, SELECTED_COUNT) 
{
	if(confirm("전체 업체에 대해 지정하시겠습니까 ?") == 1) 
	{
		for(row=0; row<=GridObj.GetRowCount(); row++) 
		{
			GridObj.cells(row+1, GridObj.getColIndexById("valuer")).setValue(SELECTED_COUNT);
			GridObj.cells(row+1, GridObj.getColIndexById("value_id")).setValue(SELECTED);
		}
	}
	else
	{
		GridObj.cells(szRow, GridObj.getColIndexById("valuer")).setValue(SELECTED_COUNT);
		GridObj.cells(szRow, GridObj.getColIndexById("value_id")).setValue(SELECTED);
	}
}

function itemDelete()
{
	var grid_array = getGridChangedRows(GridObj, "sel");
   	var rowcount = grid_array.length;
   	GridObj.enableSmartRendering(false);

   	for(var row = rowcount - 1; row >= 0; row--) {
		if("1" == GridObj.cells(grid_array[row], 0).getValue()) {
			GridObj.deleteRow2(grid_array[row]);
       	}
    }
}

function update_item(flag)
{
	var chk_cnt = 0;
	for(var i=0;i<GridObj.GetRowCount();i++){
		if(GD_GetCellValueIndex(GridObj,i,INDEX_SEL) == true){
			//GD_SetCellValueIndex(GridObj,row, GridObj.getColIndexById("sel"),"true&", "&");
				qty_yn = GD_GetCellValueIndex(GridObj,i, INDEX_QTY_YN);	//GridObj.cells(i, GridObj.getColIndexById("qty_yn")).getValue();
		
				if(qty_yn == "Y")
				{
					value_yn = GD_GetCellValueIndex(GridObj,i, INDEX_VALUER);	//GridObj.cells(i, GridObj.getColIndexById("valuer")).getValue();
		
					if(value_yn == null || value_yn == "")
					{
						alert("정성평가항목이 있는 평가건에 대해서는 평가자를 지정하셔야 합니다.");
						return;
					}
				}
				
			chk_cnt++;
		}
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
	
	if(fromdate > todate ) 
	{
		alert("평가 시작일자가 종료일자보다 큽니다. 다시 입력해 주세요.");
		return;
	}

	if(document.form1.selectedSg.length == 0) 
	{
  		alert("선택된 소싱그룹이 없습니다.");
  		return;
	}


	Message = "";
	if(flag == "1") Message = "저장 하시겠습니까?";
	if(flag == "2") Message = "실행 하시겠습니까?";
	
	if(confirm(Message) == 1) 
	{
		/////////////////////////////////////////////////////////////
		
		document.form1.fromdate.value = del_Slash(document.form1.fromdate.value);
		document.form1.todate.value = del_Slash(document.form1.todate.value);
		
		var grid_array = getGridChangedRows(GridObj, "sel");
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_update";
		var cols_ids = "<%=grid_col_id%>";
		var param = "mode=getEvaInsert&cols_ids="+grid_col_id;
		param +="&flag="+flag;
		param += dataOutput();
		myDataProcessor = new dataProcessor(servletUrl, param);
		sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
	}
}

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
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%> 
var header_name = GridObj.getColumnId(cellInd);
if(header_name == "valuer") {
	var url = "<%=POASRM_CONTEXT_NAME%>/procure/evaluator_list.jsp";
	var param = "";
	param += "?popup_flag_header=true";
	param += "&i_row="+rowId;
	PopupGeneral(url+param, "valuer", "", "", "800", "640");
}
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
        location.href = "eva_list.jsp"
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	//JavaCall("doData");
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.form1.fromdate.value = add_Slash( document.form1.fromdate.value );
    document.form1.todate.value   = add_Slash( document.form1.todate.value   );
    
     if("undefined" != typeof JavaCall) {
    	//JavaCall("doQuery");
    }  
    return true;
}

//-->
</script>

</head>
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>

<s:header>
<!--내용시작-->
<form name="form1" method="post" action="">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr> 
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type="text" size="40" maxlength="40" class="inputsubmit" name="eval_name" id="eval_name" readonly >
		<input type="hidden" size="20" maxlength="20" class="input_data0" name="eval_refitem" id="eval_refitem" >
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"></div>
	</td>
	<td class="c_data_1">
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<td><script language="javascript">btn("javascript:getQuery()","조 회")</script></td>
			<td><script language="javascript">btn("javascript:itemDelete()","삭 제")</script></td>
			<td><script language="javascript">btn("javascript:update_item('1')","저 장")</script></td>
			<td><script language="javascript">btn("javascript:update_item('2')","실 행")</script></td>
		</TR>
		</TABLE>
	</td>		
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr> 
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가기간</div>
	</td>
	<td width="35%" class="c_data_1">
		<s:calendar id_from="fromdate"  default_from="<%=fromdate %>" id_to="todate" default_to="<%=todate %>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가템플릿</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type="text" size="20" maxlength="20" class="input_data0" value = "<%=evaltemp%>" name="evaltemp" id="evaltemp" readonly >
	</td>
</tr>
<tr> 
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9"> 평가소싱그룹</div>
	</td>
	<td class="c_data_1" colspan="3">
		<table><tr><td height="1"></td></tr></table>
		<SELECT style="width:150px; height:150px"  class="input_re"  NAME="selectedSg" ID="selectedSg" MULTIPLE SIZE=5>
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
		<table><tr><td height="1"></td></tr></table>
	</td>
</tr>
</table>

<br>

</form>

</s:header>
<s:grid screen_id="SR_022" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


