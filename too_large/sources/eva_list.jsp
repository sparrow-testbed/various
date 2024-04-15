<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_021");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	String house_code = info.getSession("HOUSE_CODE");
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_021";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%><%-- Ajax SelectBox용 JSP--%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
<!--
 	var INDEX_SEL;
 	var INDEX_EVAL_NAME;
 	var INDEX_STATUS;
 	var INDEX_EVAL_TEMP;
 	var INDEX_INTERVAL;
 	
 	var INDEX_UPDATED;
 	var INDEX_OPERATOR;
 	var INDEX_EVAL_REFITEM;
 	var INDEX_EVAL_STATUS;
 	var INDEX_E_TEMPLATE_REFITEM;
 	var INDEX_COMP_CNT;

	function setHeader() 
	{

		GridObj.SetDateFormat("updated",		"yyyy/MM/dd");
		GridObj.SetNumberFormat("assi_cnt",	"###,##0");
		GridObj.SetNumberFormat("comp_cnt",	"###,##0");
		
		
		INDEX_SEL 					= GridObj.GetColHDIndex("sel");
	 	INDEX_EVAL_NAME 			= GridObj.GetColHDIndex("eval_name");
	 	INDEX_STATUS 				= GridObj.GetColHDIndex("status");
	 	INDEX_EVAL_TEMP 			= GridObj.GetColHDIndex("eval_temp");
	 	INDEX_INTERVAL 				= GridObj.GetColHDIndex("interval");
	 	                			
	 	INDEX_UPDATED 				= GridObj.GetColHDIndex("updated");
	 	INDEX_OPERATOR 				= GridObj.GetColHDIndex("operator");
	 	INDEX_EVAL_REFITEM 			= GridObj.GetColHDIndex("eval_refitem");
	 	INDEX_EVAL_STATUS 			= GridObj.GetColHDIndex("eval_status");
	 	INDEX_E_TEMPLATE_REFITEM 	= GridObj.GetColHDIndex("e_template_refitem");
	 	INDEX_COMP_CNT 				= GridObj.GetColHDIndex("comp_cnt");

		//조회된 화면을 View한다.
		<%--getQuery(); --%>
	}

	function START_SIGN_DATE(year,month,day,week) 
	{
   		document.form1.from_date.value=year+month+day;
	}
	
	function END_SIGN_DATE(year,month,day,week) 
	{
   		document.form1.to_date.value=year+month+day;
	}

	//Data Query해서 가져오기
	function getQuery() 
	{
		
		form1.from_date.value = del_Slash( form1.from_date.value );
		form1.to_date.value   = del_Slash( form1.to_date.value   );
		
		if(LRTrim(form1.from_date.value) == "" || LRTrim(form1.to_date.value) == "" ) 
		{
			alert("평가작성일을 입력하셔야 합니다.");
			return;
		}

		if(!checkDate(form1.from_date.value)) 
		{
			alert("평가작성일을 확인하세요.");
			form1.from_date.select();
			return;
		}
		
		if(!checkDate(form1.to_date.value)) 
		{
			alert("평가작성일을 확인하세요.");
			form1.to_date.select();
			return;
		}

		var servletUrl = "/servlets/sepoa.svl.procure.eva_list";
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getEvaList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		GridObj.post(servletUrl, param);
	 	GridObj.clearAll(false);	
	}

	function tmp_pop(no) 
	{
		var left = 0;
		var top = 0;
		var width = 1100;
		var height = 700;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var url = "eva_template_list1.jsp?e_template_refitem=" + no;
		var win = window.open( url, 'win', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function tmp_pop1(no, name) 
	{
		var left = 0;
		var top = 0;
		var width = 800;
		var height = 600;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var url = "eva_pp_lis2.jsp?eval_refitem=" + no + "&eval_name=" + name;
		var win = window.open( url, 'win', 'left=200, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
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
			if(msg3 == INDEX_EVAL_TEMP) 
			{
				var e_template_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_E_TEMPLATE_REFITEM);
	    		tmp_pop(e_template_refitem);
			}

			if(msg3 == INDEX_EVAL_NAME) 
			{
				var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_REFITEM);
				var eval_name = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_NAME);
	    		tmp_pop1(eval_refitem, eval_name);
			}
		}

		if(msg1 == "doData")
		{
			//alert(GD_GetParam(GridObj,0));
			alert("성공적으로 작업을 수행하였습니다.");
	
			var result = GD_GetParam(GridObj,1);
			
			if(result == "S")
			{
	            getQuery();
			}
		}
<%--
		if(msg3 == INDEX_eval_name) {
			var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_refitem);
			var evalname = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_name);
			var eval_status = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_status);
			
			if(eval_status == "2") {
				alert("평가진행중에는 수정하실수 없습니다.");
				return;
			}else if(eval_status == "3") {
				alert("완료된 평가는 수정할수 없습니다.");
				return;
			}
			url = "eva_reg_lis2.jsp?eval_refitem=" + eval_refitem +
					       "&evalname=" + evalname + 
					       "&mode=update";
			location.href=url;
		}else if(msg3 == INDEX_status){
			var mode;
			var flag = "";
			var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_refitem);
			var evalname = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_name);
			
			var interval = GD_GetCellValueIndex(GridObj,msg2, INDEX_interval);
			var status = GD_GetCellValueIndex(GridObj,msg2, INDEX_eval_status);

			var url;
			//if(status == '2') {	//평가 대상업체목록
			//
			//	url = "eva_list_lis2.jsp?eval_refitem=" + eval_refitem +
			//				"&evalname=" + evalname +
			//				"&interval=" + interval;
			//	location.href=url;
			//}
			if(status == '3') {	//평가 결과업체 목록
				url = "eva_list_lis3.jsp?eval_refitem=" + eval_refitem +
							"&evalname=" + evalname +
							"&interval=" + interval;
				location.href=url;
			}

		}
		
		if( msg1 == "doQuery" ){
			var eval_status;
			var count = GridObj.GetRowCount();
			for(i=0; i < count; i++) {
				eval_status = GD_GetCellValueIndex(GridObj,i, INDEX_eval_status);
				if(eval_status == "1" || eval_status == "2"){
					GridObj.setCellfgColor(i, INDEX_status, "black");
				}
			}
		
		}
--%>
	}

	//enter를 눌렀을때 event발생
	function entKeyDown()
	{
		if(event.keyCode==13) {
			window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
			getQuery();
		}
	}

	function doComplete() 
	{
		var Sepoa =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var eval_refitem = "";

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			var temp = GridObj.cells(i+1, GridObj.getColIndexById("sel")).getValue();
			var status = GridObj.cells(i+1, GridObj.getColIndexById("eval_status")).getValue();
			var grid_array = getGridChangedRows(GridObj, "sel");

			if(temp == "1" ) 
			{
				if(status != "2") 
				{
					alert("진행중인 평가만 완료가능합니다.");
					return;
				}
				sel_row++;
				eval_refitem = GridObj.cells(i+1, GridObj.getColIndexById("eval_refitem")).getValue();
			}

			if(sel_row > 1) 
			{
				alert("평가완료는 한건씩 가능합니다.");
				return;
			}

		}

		if(sel_row == 0) 
		{
			alert("항목을 선택해주세요.");
			return;
		}

		var value = confirm("평가완료 하시겠습니까 ?");
		
		if(value)
		{
			servletUrl = "/servlets/master.evaluation.eva_bd_lis1"; 
			var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL = "<%=POASRM_CONTEXT_NAME %>/servlets/sepoa.svl.procure.eva_list";
			var params = "mode=setEvaComplete&cols_ids="+cols_ids;
				params += dataOutput();
		    myDataProcessor = new dataProcessor(SERVLETURL, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
		}

	}
	
	function doDelete() 
	{
		var Sepoa =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var eval_refitem = "";

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			var grid_array = getGridChangedRows(GridObj, "sel");
			var temp = GridObj.cells(i+1, GridObj.getColIndexById("sel")).getValue();
			var status = GridObj.cells(i+1, GridObj.getColIndexById("eval_status")).getValue();

			if(temp == "1" ) 
			{
				if(status != "1") 
				{
					alert("작성중 인 평가만 삭제가능합니다.");
					//return;
				}
				sel_row++;
			}
		}
		
		if(sel_row == 0) 
		{
			alert("삭제 하실 평가를 선택해주세요.");
			return;
		}

		var value = confirm("삭제 하시겠습니까 ?");
		
		if(value)
		{
			var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL = "<%=POASRM_CONTEXT_NAME %>/servlets/sepoa.svl.procure.eva_list";
			var params = "mode=setEvaDelete&cols_ids="+cols_ids;
				params += dataOutput();
		    myDataProcessor = new dataProcessor(SERVLETURL, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
		
		}
	}

	function doModify()
	{
		var Sepoa =  GridObj;
		var sel_row = 0;
		var cnt = 0;

		var eval_refitem = "";
		var eval_name 	= "";

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			var temp = GridObj.cells(i+1, GridObj.getColIndexById("sel")).getValue();
			var status = GridObj.cells(i+1, GridObj.getColIndexById("eval_status")).getValue();
			var comp_cnt = GridObj.cells(i+1, GridObj.getColIndexById("comp_cnt")).getValue();

			if(temp == "1" ) 
			{
				if(comp_cnt ==0 && status != "3"){
					alert("지정된 평가자가 평가를 수행중일 수 있으니 지정된 평가자를 삭제하지 말고 평가자를 추가 해주세요.\n만약 평가자를 변경하려면 '지정된 평가자'의 '변경 확인' 후 변경하시기 바랍니다.");
				}else{
					if(status != "1") 
					{
						alert("상태가 '작성중' 또는 평가자가 평가를 수행하지 않은  평가만 수정가능합니다.");
						return;
					}
				}
				eval_refitem = GridObj.cells(i+1, GridObj.getColIndexById("eval_refitem")).getValue();
				eval_name = GridObj.cells(i+1, GridObj.getColIndexById("eval_name")).getValue();

				sel_row++;
			}
		}
		
		if(sel_row == 0) 
		{
			alert("수정 하실 평가를 선택해주세요.");
			return;
		}

		if(sel_row >= 2) 
		{
			alert("수정은 한 건 씩 가능합니다.");
			return;
		}

		var value = confirm("수정 하시겠습니까 ?");
		
		if(value)
		{
			url = "eva_update.jsp?eval_refitem=" + eval_refitem +
					       "&eval_name=" + eval_name;
			location.href=url;
		}
	}
//-->
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

var setrow="0";
var setcol="0";

var header_name = GridObj.getColumnId(cellInd);

if(header_name == "eval_temp") {
	
var e_template_refitem = GridObj.cells(rowId, GridObj.getColIndexById("e_template_refitem")).getValue();	


window.open("eva_list_temp_detail.jsp?e_template_refitem=" +e_template_refitem, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
	
} 

else if(header_name == "eval_name") {
	
	var eval_refitem = GridObj.cells(rowId, GridObj.getColIndexById("eval_refitem")).getValue();	
	var eval_name = GridObj.cells(rowId, GridObj.getColIndexById("eval_name")).getValue();	
	
	
	window.open("eva_detail.jsp?eval_refitem=" +eval_refitem + "&eval_name=" +eval_name, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
		
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
        getQuery();
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    document.form1.from_date.value = add_Slash(document.form1.from_date.value);
    document.form1.to_date.value = add_Slash(document.form1.to_date.value);
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
function initAjax(){
	setGridDraw();
	doRequestUsingPOST('SL0018','<%=house_code%>'+'#M126','status_sel','');
}
</script>

</head>
<body onload="initAjax();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<form name="form1" method="post">

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

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가작성일</td>
	<td class="c_data_1" width="35%">
		<s:calendar id_from="from_date"  default_from="<%=SepoaString.getDateSlashFormat(SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1))%>" id_to="to_date" default_to="<%=SepoaString.getDataSlashFormat(SepoaDate.getShortDateString())%>" format="%Y/%m/%d"/>
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type=text size="20" maxlength="25" class="inputsubmit" name="evalname" id="evalname">
	</td>
</tr>
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 진행상태</div>
	</td>
	<td width="35%" class="c_data_1" colspan="3">
		<SELECT class="input_re"  name="status_sel" id="status_sel">
		<option value=''>전체</option>
		</SELECT>
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:getQuery()","조 회")</script></TD>
			<TD><script language="javascript">btn("javascript:doComplete()","평가완료")</script></TD>
			<TD><script language="javascript">btn("javascript:doModify()","수 정")</script></TD>
			<TD><script language="javascript">btn("javascript:doDelete()","삭 제")</script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

</form>

</s:header>
<s:grid screen_id="SR_021" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>




