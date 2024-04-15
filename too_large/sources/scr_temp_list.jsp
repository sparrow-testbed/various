<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_009");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_009";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        	SR_009  <p>
 Description:  	템플릿관리/템플릿항목<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	chan-gon Moon<p>
 @version      	1.0.0<p>
 @Comment       템플릿관리/템플릿항목<p>
--%>


<%@ page import="java.util.*"%>

<%
	String company_code = info.getSession("COMPANY_CODE");
%>
<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>


<script language="javascript" type="text/javascript">

	var INDEX_choose;
	var INDEX_num;
	var INDEX_template_name;
	var INDEX_change_date;
	var INDEX_user_name_loc;
	var INDEX_s_template_refitem;

	function setHeader() {


		/* GridObj.AddHeader( "s_template_refitem",	""		   ,"t_text",1020,0,false);
		
		GridObj.SetDateFormat(		"change_date",		"yyyy/MM/dd");
		
 */
		INDEX_choose = GridObj.GetColHDIndex("choose");
		INDEX_num = GridObj.GetColHDIndex("num");
		INDEX_template_name = GridObj.GetColHDIndex("template_name");
		INDEX_change_date = GridObj.GetColHDIndex("change_date");
		INDEX_user_name_loc = GridObj.GetColHDIndex("user_name_loc");
		INDEX_s_template_refitem = GridObj.GetColHDIndex("s_template_refitem");
		INDEX_apply_flag = GridObj.GetColHDIndex("apply_flag");

		getQuery();
	}

	function getQuery(){

		<%-- var item_name = document.form.item_name.value;
		var operator = document.form.operator.value;
		var company_code = "<%= company_code %>";

		var servletUrl = "<%=getWiseServletPath("master.template.scr_template_lst")%>";

		GridObj.SetParam("item_name",item_name);
		GridObj.SetParam("operator",operator);
		GridObj.SetParam("company_code",company_code);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; --%>
		
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getTempList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.scr_temp_list";
	
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	

	}

	function addTemplate() {
		var url = "scr_temp_insert.jsp";
		popup(url);
	}

	function templateUpdate() {

		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var s_templater_refitem;


		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_choose);
			if(temp == "1") {
				sel_row++;
				cnt = i;
			}
		}
		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return;
		}
		if(parseInt(sel_row) > 1) {
			alert('한행만 선택하십시요.');
			return;
		}

		s_template_refitem = GD_GetCellValueIndex(GridObj,cnt,INDEX_s_template_refitem);

		var url = "scr_temp_insert.jsp?mode=update&s_template_refitem=" + s_template_refitem;
		popup(url);
	}

	function templateDelete(){
		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var s_template_refitem = "";
		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_choose);
			if(temp == "1") {				
				var apply_flag = GD_GetCellValueIndex(GridObj,i,INDEX_apply_flag);
				if(apply_flag == "N" ){
					alert("이미 사용된 템플릿은 삭제할 수 없습니다.");
					return;
				}
					
				sel_row++;
				s_template_refitem = s_template_refitem + "," + GD_GetCellValueIndex(GridObj,i,INDEX_s_template_refitem);
			}
		}
		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return;
		}
		s_template_refitem = s_template_refitem.substring(1);

		var value = confirm('삭제 하시겠습니까?');
		if(value){
		/* 	this.hiddenframe.location.href = "scr_template_ins.jsp?mode=delete&s_template_refitem=" + s_template_refitem;
	 */	
	 	
			var cols_ids = "<%=grid_col_id%>";
	    	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.scr_temp_list";
			var params = "mode=setTempDelete&cols_ids="+cols_ids;
				params += dataOutput();
			var grid_array = getGridChangedRows(GridObj, "choose");
		    myDataProcessor = new dataProcessor(url, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "choose", grid_array);
	 
		
		}
	}

	function popup(url) {
		var left = 0;
		var top = 0;
		var width = 1000;
		var height = 700;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'no';
		var scrollbars = 'yes';
		var resizable = 'no';

		var doc = window.open( url, 'doc', 'left=150, top=150, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	function entKeyDown()
	{
  		if(event.keyCode==13) {
   			window.focus();
   			getQuery();
  		}
  	}

  	function onRefresh() {
setGridDraw();
setHeader();
  	}

  	function JavaCall(msg1,msg2,msg3,msg4,msg5){
		for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
		if(msg3 == INDEX_template_name)
		{
			var s_template_refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_s_template_refitem);
			var url = "scr_template_pop1.jsp?mode=view&s_template_refitem=" + s_template_refitem;
			popup(url);
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

var setrow="0";
var setcol="0";

var header_name = GridObj.getColumnId(cellInd);

if(header_name == "template_name") {
	
var s_template_refitem = GridObj.cells(rowId, GridObj.getColIndexById("s_template_refitem")).getValue();	

window.open("scr_temp_detail.jsp?mode=view&s_template_refitem=" +s_template_refitem, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
	
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
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" text="#000000" >

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

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<form name="form" method="post" action="">
	<tr>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 템플릿명</td>
		<td class="c_data_1" width="35%">
			<input type="text" size="30" value="" name="item_name" id="item_name" class="inputsubmit" onkeydown='entKeyDown()'>

		</td>
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 작성자</td>
		<td class="c_data_1" width="35%">
			<input type="text" name="operator" id="operator" size="20" class="inputsubmit" onkeydown='entKeyDown()'>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
					<td><script language="javascript">btn("javascript:getQuery()","조 회")</script></td>
    	  			<td><script language="javascript">btn("javascript:addTemplate()","등 록")</script></td>
    	  			<td><script language="javascript">btn("javascript:templateUpdate()","수 정")</script></td>
    	  			<td><script language="javascript">btn("javascript:templateDelete()","삭 제")</script></td>
				</TR>
  			</TABLE>
  		</td>
	</tr>
</table>


<iframe name="hiddenframe" src="scr_template_ins.jsp" width="0" height="0"></iframe>
</form>

</s:header>
<s:grid screen_id="SR_009" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


