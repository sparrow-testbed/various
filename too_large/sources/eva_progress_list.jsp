<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_024");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_024";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>

<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<!-- META TAG 정의  -->
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">

<!--

 	var INDEX_EVAL_NAME;
 	var INDEX_EVAL_TEMP;
 	var INDEX_INTERVAL;
 	var INDEX_SG_NAME;
 	var INDEX_VENDOR_NAME;
 	
 	var INDEX_VALUER;
 	var INDEX_COMP_FLAG;
 	var INDEX_DETAIL;
 	var INDEX_EVAL_REFITEM;
 	var INDEX_E_TEMPLATE_REFITEM;

 	var INDEX_E_VALUER_ID;
 	var INDEX_EVAL_ITEM_REFITEM;
	var INDEX_TEMPLATE_TYPE;

<%-- 	function setHeader() 
	{
		INDEX_EVAL_NAME         	= GridObj.GetColHDIndex("eval_name");
	 	INDEX_EVAL_TEMP         	= GridObj.GetColHDIndex("eval_temp");
	 	INDEX_INTERVAL          	= GridObj.GetColHDIndex("interval");
	 	INDEX_SG_NAME           	= GridObj.GetColHDIndex("sg_name");
	 	INDEX_VENDOR_NAME       	= GridObj.GetColHDIndex("vendor_name");
	 	                         	
	 	INDEX_VALUER            	= GridObj.GetColHDIndex("valuer");
	 	INDEX_COMP_FLAG         	= GridObj.GetColHDIndex("comp_flag");
	 	INDEX_DETAIL            	= GridObj.GetColHDIndex("detail");
	 	INDEX_EVAL_REFITEM      	= GridObj.GetColHDIndex("eval_refitem");
	 	INDEX_E_TEMPLATE_REFITEM 	= GridObj.GetColHDIndex("e_template_refitem");

 		INDEX_E_VALUER_ID			= GridObj.GetColHDIndex("e_valuer_id");
 		INDEX_EVAL_ITEM_REFITEM		= GridObj.GetColHDIndex("eval_item_refitem");
 		INDEX_TEMPLATE_TYPE			= GridObj.GetColHDIndex("template_type");

		//조회된 화면을 View한다.
		getQuery();
	} --%>

	//Data Query해서 가져오기
	function getQuery() 
	{
		f = document.form1;
		var eval_refitem 	= f.eval_refitem.value;

		if(eval_refitem == "")
		{
			alert("평가명은 필수사항 입니다.");
			f.eval_name.select();
			return;
		}
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_progress_list";

		var grid_col_id = "<%=grid_col_id%>";
		var param = "mode=getEvaList&grid_col_id="+grid_col_id;
		param += dataOutput();
		GridObj.post(servletUrl, param);
		GridObj.clearAll(false);

		//GD_SetGroupMerge(GridObj,"true","0&1&2");	
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
// 		var url = "eva_template_list1.jsp?e_template_refitem=" + no;
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
		var url = "eva_detail.jsp?eval_refitem=" + no + "&eval_name=" + name;
// 		var url = "eva_pp_lis2.jsp?eval_refitem=" + no + "&eval_name=" + name;
		var win = window.open( url, 'win', 'left=200, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}
	function tmp_pop2(vendor_name, sg_name, user_id, eval_item_refitem, e_template_refitem, eval_refitem, template_type) 
	{
		
		var left = 0;
		var top = 0;
		var width = 1000;
		var height = 550;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var url = "eva_pp_lis3.jsp?eval_item_refitem=" + eval_item_refitem + "&vendor_name=" + vendor_name+ "&sg_name=" + sg_name+ "&user_id=" + user_id;
		url = url + "&e_template_refitem=" + e_template_refitem + "&template_type=" + template_type + "&eval_refitem=" + eval_refitem;
		var win = window.open( url, 'win', 'left=200, top=0, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

	}

	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
	{

		if(msg1 == "doQuery"){
		//	GD_SetGroupMerge(GridObj,"true","0&1&2");
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

			if(msg3 == INDEX_DETAIL) 
			{
				
				var comp_flag = GD_GetCellValueIndex(GridObj,msg2, INDEX_COMP_FLAG);
				var vendor_name = GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_NAME);
				var sg_name = GD_GetCellValueIndex(GridObj,msg2, INDEX_SG_NAME);
				var user_id = GD_GetCellValueIndex(GridObj,msg2, INDEX_E_VALUER_ID);
				var eval_item_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_ITEM_REFITEM);
				var e_template_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_E_TEMPLATE_REFITEM);
				var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_REFITEM);
				var template_type = GD_GetCellValueIndex(GridObj,msg2, INDEX_TEMPLATE_TYPE);

				if(comp_flag == "Y")
	    			tmp_pop2(vendor_name, sg_name, user_id, eval_item_refitem, e_template_refitem, eval_refitem, template_type);
			}
		}
	}

	function EvalCode()
	{
		var f0 = document.form1;
	
		var url = "/kr/admin/Sepoapopup/cod_cm_lis1.jsp?code=SP0243&function=setEval&values=&values=";
		var left = 50;  var top = 100;  var width = 550;        var height = 450;       var toolbar = 'no';     var menubar = 'no';     var status = 'yes';     var scrollbars = 'no';    var resizable = 'no';
		var agentCodeWin = window.open( url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}
	
	function setEval(code, text1)
	{
		 document.form1.eval_refitem.value = code;
		 document.form1.eval_name.value = text1;
	}
	function PopupManager(part)
	{
		var url = "";
		var f = document.forms[0];

		if(part == "EVAL_NAME")
		{
			PopupCommon1("SP0243","setEval","&values=&values=","코드","설명");
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
	if(GridObj.getColIndexById("eval_temp") == cellInd) 
	{
		var e_template_refitem = GridObj.cells(rowId, GridObj.getColIndexById("e_template_refitem")).getValue();
		tmp_pop(e_template_refitem);
	}

	if(GridObj.getColIndexById("eval_name") == cellInd) 
	{
		var eval_refitem = GridObj.cells(rowId, GridObj.getColIndexById("eval_refitem")).getValue();
		var eval_name	 = GridObj.cells(rowId, GridObj.getColIndexById("eval_name")).getValue();
		tmp_pop1(eval_refitem, eval_name);
		
		
	}

	if(GridObj.getColIndexById("detail") == cellInd) 
	{
		
		var comp_flag	 		= GridObj.cells(rowId, GridObj.getColIndexById("comp_flag")).getValue();
		var vendor_name	 		= GridObj.cells(rowId, GridObj.getColIndexById("vendor_name")).getValue();
		var sg_name		 		= GridObj.cells(rowId, GridObj.getColIndexById("sg_name")).getValue();
		var user_id		 		= GridObj.cells(rowId, GridObj.getColIndexById("e_valuer_id")).getValue();
		var eval_item_refitem	= GridObj.cells(rowId, GridObj.getColIndexById("eval_item_refitem")).getValue();
		var e_template_refitem	= GridObj.cells(rowId, GridObj.getColIndexById("e_template_refitem")).getValue();
		var eval_refitem	 	= GridObj.cells(rowId, GridObj.getColIndexById("eval_refitem")).getValue();
		var template_type	 	= GridObj.cells(rowId, GridObj.getColIndexById("template_type")).getValue();
		
		
		
		if(comp_flag == "Y")
			tmp_pop2(vendor_name, sg_name, user_id, eval_item_refitem, e_template_refitem, eval_refitem, template_type);
	}	
	
	
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

// 	JavaCall("t_imagetext", GridObj.getRowIndex(rowId), cellInd);
	
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
    if(status == "0"){
    	alert(msg);
    }
    
    grid_rowspan("0-2", "eval_name,eval_temp,interval");
    return true;
}

function grid_rowspan(col_num,col_name){
    var cnt = 0;
    var temp1 = "";
    var temp2 = "";
    var col_num_cnt = col_num.split(",");
    var col_name_cnt = col_name.split(",");
    for(var i = 1; i < dhtmlx_last_row_id+1; i++){
              cnt = 0;
              temp1 = "";
              for( var k = 0 ; k < col_name_cnt.length ; k++){
                         temp1 += LRTrim(GridObj.cells(i, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
              }
              //해당 필드의 똑같은 데이타를 가지고 있는 로우의 갯수를 셈.
              for(var j = i; j < dhtmlx_last_row_id+1; j++){
                         temp2 = "";
                         for( var k = 0 ; k < col_name_cnt.length ; k++){
                                   temp2 += LRTrim(GridObj.cells(j, GridObj.getColIndexById(col_name_cnt[k])).getValue()+"");
                         }
                         if(temp1 == temp2){
                                   cnt = cnt + 1;
                                   if(temp1 == "" && temp2 == "") cnt = 1;
                         }
              }
              //그 row수만 큼 span. 
              for(var m = 0; m<col_num_cnt.length; m++){
                         for(var n = Number(col_num_cnt[m].split("-")[0]); n <= Number(col_num_cnt[m].split("-")[1]); n++){
                                   GridObj.setRowspan(i,n,cnt);// 줄 / 칸 / 갯수
                         } 
              }
              i = i + cnt - 1;
              //alert(i + " " + n + " " + cnt);
    }
}

//지우기
function doRemove( type ){
    if( type == "eval_name" ) {
    	document.forms[0].eval_name.value = "";
        document.forms[0].eval_refitem.value = "";
    }  
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        getQuery();
    }
}
</script>
</head>
<body onload="setGridDraw();" bgcolor="#FFFFFF" text="#000000" >

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
	<td width="10%" class="c_title_1">
		<div align="left"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle"> 평가명</div>
	</td>
	<td width="90%" class="c_data_1">
		<input type=text size="40" class="input_re" name="eval_name" id="eval_name" readonly onkeydown='entKeyDown()'>
		<a href="javascript:PopupManager('EVAL_NAME')"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
			<a href="javascript:doRemove('eval_name')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
			<input type="hidden" name="eval_refitem" id="eval_refitem" size="20" class="input_submit" onkeydown='entKeyDown()'>
	</td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30">
		<TABLE cellpadding="0" align="right">
		<TR>
			<TD><script language="javascript">btn("javascript:getQuery()","조 회")  </script></TD>
		</TR>
		</TABLE>
	</td>
</tr>
</table>

</form>

</s:header>
<s:grid screen_id="SR_024" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>




