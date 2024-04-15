<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_027");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_027";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<%
	String gate = JSPUtil.nullToRef(request.getParameter("gate"),"");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
<!--

 	var INDEX_SEL;
 	var INDEX_EVAL_NAME;
 	var INDEX_EVAL_TEMP;
 	var INDEX_INTERVAL;
 	var INDEX_EVAL_VENDOR;
 	
 	var INDEX_OPERATOR;
 	var INDEX_EVAL_REFITEM;
 	var INDEX_E_TEMPLATE_REFITEM;

	function setHeader() 
	{

		INDEX_SEL 					= GridObj.GetColHDIndex("sel");
	 	INDEX_EVAL_NAME 			= GridObj.GetColHDIndex("eval_name");
	 	INDEX_EVAL_TEMP 			= GridObj.GetColHDIndex("eval_temp");
	 	INDEX_INTERVAL 				= GridObj.GetColHDIndex("interval");
	 	INDEX_EVAL_VENDOR 			= GridObj.GetColHDIndex("eval_vendor");

	 	INDEX_OPERATOR 				= GridObj.GetColHDIndex("operator");
	 	INDEX_EVAL_REFITEM 			= GridObj.GetColHDIndex("eval_refitem");
	 	INDEX_E_TEMPLATE_REFITEM 	= GridObj.GetColHDIndex("e_template_refitem");

		//조회된 화면을 View한다.
		getQuery();
	}

	//Data Query해서 가져오기
	function getQuery() 
	{
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_wait_list";
		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getEvaList&grid_col_id="+grid_col_id;
		param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);
	}

	function tmp_pop(no) 
	{
		var left = 0;
		var top = 0;
		var width = 1000;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		//var url = "eva_template_list1.jsp?e_template_refitem=" + no;
		var url = "eva_list_temp_detail.jsp?e_template_refitem=" + no;
		var win = window.open( url, 'win', 'left=200, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
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
		//var url = "eva_pp_lis2.jsp?eval_refitem=" + no + "&eval_name=" + name;
		var url = "eva_detail.jsp?eval_refitem=" + no + "&eval_name=" + name;
		var win = window.open( url, 'win', 'left=200, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	function tmp_pop2(no) 
	{
		var left = 0;
		var top = 0;
		var width = 400;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var url = "eva_list_pop4.jsp?eval_refitem=" + no ;
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
			}else if (msg3 == INDEX_EVAL_VENDOR){
				var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_REFITEM);
				tmp_pop2(eval_refitem);
				
			}
		}
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
		var evalname = "";
		var interval = "";

		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			var temp = GridObj.cells(i+1, GridObj.getColIndexById("sel")).getValue();

			if(temp == "1" ) 
			{
				sel_row++;
				eval_refitem = GridObj.cells(i+1, GridObj.getColIndexById("eval_refitem")).getValue();
				evalname = GridObj.cells(i+1, GridObj.getColIndexById("eval_name")).getValue();
				interval = GridObj.cells(i+1, GridObj.getColIndexById("interval")).getValue();
			}

			if(sel_row > 1) 
			{
				alert("평가실행은 한건씩 가능합니다.");
				return;
			}

		}

		if(sel_row == 0) 
		{
			alert("항목을 선택해주세요.");
			return;
		}

		var value = confirm("평가 작성 하시겠습니까?");
		
		if(value)
		{
			var t_url 	 = "eva_action_list.jsp?eval_refitem="+eval_refitem+"&evalname="+evalname+"&interval="+interval;
			location.href = t_url;
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
			var temp = GD_GetCellValueIndex(GridObj,i, INDEX_SEL);
			var status = GD_GetCellValueIndex(GridObj,i, INDEX_EVAL_STATUS);

			if(temp == "true" ) 
			{
				if(status != "1") 
				{
					alert("작성중 인 평가만 삭제가능합니다.");
					return;
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
			servletUrl = "/servlets/master.evaluation.eva_bd_lis1"; 
		
			GridObj.SetParam("mode", "Delete");
			GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
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
			var temp = GD_GetCellValueIndex(GridObj,i, INDEX_SEL);
			var status = GD_GetCellValueIndex(GridObj,i, INDEX_EVAL_STATUS);

			if(temp == "true" ) 
			{
				if(status != "1") 
				{
					alert("작성중 인 평가만 수정가능합니다.");
					return;
				}

				eval_refitem = GD_GetCellValueIndex(GridObj,i, INDEX_EVAL_REFITEM);
				eval_name = GD_GetCellValueIndex(GridObj,i, INDEX_EVAL_NAME);

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
			url = "eva_bd_upd1.jsp?eval_refitem=" + eval_refitem +
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
	if( GridObj.getColIndexById("eval_temp") == cellInd) 
	{	
		var e_template_refitem = GridObj.cells(rowId, GridObj.getColIndexById("e_template_refitem")).getValue();
		tmp_pop(e_template_refitem);
	}else if (GridObj.getColIndexById("eval_vendor") == cellInd){
		var eval_refitem = GridObj.cells(rowId, GridObj.getColIndexById("eval_refitem")).getValue();
		tmp_pop2(eval_refitem);
		
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>

</head>
<body onload="setGridDraw();getQuery();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<form name="form1" method="post">
<%if("".equals(gate)){%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">
		<%@ include file="/include/sepoa_milestone.jsp" %>
	</td>
</tr>
</table> 
<%
}
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<tr>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="85%" class="c_data_1" colspan="3">
		<input type=text size="20" maxlength="20" class="inputsubmit" name="evalname" id="evalname">
	</td>		
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:getQuery()","조 회")  </script></TD>
			<TD><script language="javascript">btn("javascript:doComplete()","실 행")  </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>


</form>

</s:header>
<s:grid screen_id="SR_027" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>




