<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_026");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_026";
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
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
<!--
 	var INDEX_EVAL_NAME;
 	var INDEX_EVAL_TEMP;
 	var INDEX_INTERVAL;
 	var INDEX_SG_NAME;
 	var INDEX_VENDOR_NAME;
 	
 	var INDEX_SCORE;
 	var INDEX_EVAL_REFITEM;
 	var INDEX_E_TEMPLATE_REFITEM;
 	var INDEX_EVAL_ITEM_REFITEM;
	var INDEX_TEMPLATE_TYPE;
	
	var INDEX_QNT_N_SCORE;
	var INDEX_QNT_Y_SCORE;

	function setHeader() 
	{

		INDEX_EVAL_NAME         	= GridObj.GetColHDIndex("eval_name");
	 	INDEX_EVAL_TEMP         	= GridObj.GetColHDIndex("eval_temp");
	 	INDEX_INTERVAL          	= GridObj.GetColHDIndex("interval");
	 	INDEX_SG_NAME           	= GridObj.GetColHDIndex("sg_name");
	 	INDEX_VENDOR_NAME       	= GridObj.GetColHDIndex("vendor_name");
	 	                         	
	 	INDEX_SCORE            		= GridObj.GetColHDIndex("score");
	 	INDEX_EVAL_REFITEM      	= GridObj.GetColHDIndex("eval_refitem");
	 	INDEX_E_TEMPLATE_REFITEM 	= GridObj.GetColHDIndex("e_template_refitem");
 		INDEX_EVAL_ITEM_REFITEM		= GridObj.GetColHDIndex("eval_item_refitem");
 		INDEX_TEMPLATE_TYPE			= GridObj.GetColHDIndex("template_type");
 		
 		INDEX_QNT_N_SCORE			= GridObj.GetColHDIndex("QNT_N_SCORE");
 		INDEX_QNT_Y_SCORE			= GridObj.GetColHDIndex("QNT_Y_SCORE");
 		
 		

		//조회된 화면을 View한다.
		<%--getQuery();--%>
	}

	//Data Query해서 가져오기
	function getQuery() 
	{

		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_vnresult_list";
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

	function tmp_pop2(vendor_name, sg_name, total_score, e_template_refitem, template_type, eval_item_refitem, eval_refitem, qnt_n_score, qnt_score) 
	{
		var left = 0;
		var top = 0;
		var width = 800;
		var height = 700;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';
		var url = "eva_list_pop2.jsp?e_template_refitem=" + e_template_refitem + "&template_type=" + template_type+ "&eval_item_refitem=" + eval_item_refitem+ "&vendor_name=" + vendor_name;
		url = url + "&sg_name=" + sg_name + "&total_score=" + total_score + "&eval_refitem=" + eval_refitem + "&qnt_n_score=" + qnt_n_score + "&qnt_score=" + qnt_score;
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

			if(msg3 == INDEX_SCORE) 
			{
				var vendor_name = GD_GetCellValueIndex(GridObj,msg2, INDEX_VENDOR_NAME);
				var sg_name = GD_GetCellValueIndex(GridObj,msg2, INDEX_SG_NAME);
				var total_score = GD_GetCellValueIndex(GridObj,msg2, INDEX_SCORE);
				var e_template_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_E_TEMPLATE_REFITEM);
				var template_type = GD_GetCellValueIndex(GridObj,msg2, INDEX_TEMPLATE_TYPE);

				var eval_item_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_ITEM_REFITEM);
				var eval_refitem = GD_GetCellValueIndex(GridObj,msg2, INDEX_EVAL_REFITEM);
				
				var qnt_n_score = GD_GetCellValueIndex(GridObj,msg2, INDEX_QNT_N_SCORE);
				var qnt_score = GD_GetCellValueIndex(GridObj,msg2, INDEX_QNT_Y_SCORE);

    			tmp_pop2(vendor_name, sg_name, total_score, e_template_refitem, template_type, eval_item_refitem, eval_refitem, qnt_n_score, qnt_score);
			}
		}

	}

	function getVendorCode()
	{
	    var f0 = document.form1;	    
	    var arrValue = new Array();
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		arrValue[2] = "";
		var arrDesc = new Array();
		arrDesc[0] = "코드";
		arrDesc[1] = "설명";
		PopupCommonArr("SP0218","setVendorCode",arrValue,arrDesc);
	}
	
	function setVendorCode( code, desc1, desc2)
	{
		document.forms[0].vendor_code.value = code;
		document.forms[0].vendor_name.value = desc1;
	}

//-->

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
		setHeader();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	JavaCall("t_imagetext", GridObj.getRowIndex(rowId), cellInd);
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
	<td width="15%" class="c_title_1" >
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가업체</div>
	</td>
	<td class="c_data_1">
		<input type="text" name="vendor_code" id="vendor_code" size="15" maxlength="10" class="inputsubmit">
		<a href="javascript:getVendorCode()">
			<img src="/images/icon/icon_search.gif" align="absmiddle" name=p_vendor_code border="0"></a>
		<input type="text" name="vendor_name" id="vendor_name" size="20" class="input_data2" >
	</td>
	<td width="15%" class="c_title_1">
		<div align="left"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 평가명</div>
	</td>
	<td width="35%" class="c_data_1">
		<input type=text size="20" maxlength="20" class="input_submit" name="eval_name" id="eval_name">
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
<s:grid screen_id="SR_026" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>




