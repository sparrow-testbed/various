<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_007";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/master/template/scr_item_lst.jsp --%>
<%--
 Title:        	p0060  <p>
 Description:  	템플릿관리/스크리닝항목록<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	chan-gon Moon<p>
 @version      	1.0.0<p>
 @Comment       템플릿관리/스크리닝항목록<p>
--%>


<%@ page import="java.util.*"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<% 
	String company_code = info.getSession("COMPANY_CODE");
%>

<html>
<head>
<title>
	<%=text.get("MESSAGE.MSG_9999")%>
</title> <%-- 우리은행 전자구매시스템 --%>



<%-- Dhtmlx SepoaGrid용 JSP--%>

<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>


<script language="javascript" type="text/javascript">

	var INDEX_choose;
	var INDEX_num;
	var INDEX_factor_name;
	var INDEX_scale_count;
	var INDEX_systime_updated;
	
	var INDEX_user_name_loc;
	var INDEX_s_factor_refitem;

	function setHeader() {
		
		
		
		/* 
		GridObj.SetDateFormat(		"change_date",		"yyyy/MM/dd");
		
		 */
		INDEX_choose = GridObj.GetColHDIndex("choose");
		INDEX_num = GridObj.GetColHDIndex("num");
		INDEX_factor_name = GridObj.GetColHDIndex("factor_name");
		INDEX_scale_count = GridObj.GetColHDIndex("scale_count");
		INDEX_systime_updated = GridObj.GetColHDIndex("systime_updated");
		
		INDEX_user_name_loc = GridObj.GetColHDIndex("user_name_loc");
		INDEX_s_factor_refitem = GridObj.GetColHDIndex("s_factor_refitem");

	 	getQuery(); 
	}
	
	function getQuery() {
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getScrList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.scr_item_list";
	
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	 
		
	}
	
	function addItem() {
		var url = "scr_item_insert.jsp";
		popup(url);
	}	
	
	function itemUpdate() {
	
		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var s_factor_refitem;
		
		
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
		
		s_factor_refitem = GD_GetCellValueIndex(GridObj,cnt,INDEX_s_factor_refitem);		
		var url = "scr_item_insert.jsp?mode=update&s_factor_refitem=" + s_factor_refitem;
		popup(url);
	}
	
	function itemDelete(){
		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var s_factor_refitem = "";
		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_choose);
			if(temp == "1") {
				sel_row++;
				s_factor_refitem = s_factor_refitem + "," + GD_GetCellValueIndex(GridObj,i,INDEX_s_factor_refitem);
			}
		}
		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return;
		}
		
		s_factor_refitem = s_factor_refitem.substring(1);
		
		var value = confirm('삭제 하시겠습니까?');
		if(value){
	
			var cols_ids = "<%=grid_col_id%>";
	    	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.scr_item_list";
			var params = "mode=setScrDelete&cols_ids="+cols_ids;
				params += dataOutput();
			var grid_array = getGridChangedRows(GridObj, "choose");
		    myDataProcessor = new dataProcessor(url, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "choose", grid_array);	    
		    
		}
	}
	
	function popup(url) {
		var left = 0;
		var top = 0;
		var width = 650;
		var height = 300;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		
		var doc = window.open( url, 'doc', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
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
				
		if(msg3 == INDEX_factor_name){
			var s_factor_refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_s_factor_refitem);
			var url = "src_item_pop1.jsp?mode=view&s_factor_refitem=" + s_factor_refitem;
			popup(url);
			
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
   

var setrow="0";
var setcol="0";

var header_name = GridObj.getColumnId(cellInd);

if(header_name == "factor_name") {
	
var s_factor_refitem = GridObj.cells(rowId, GridObj.getColIndexById("s_factor_refitem")).getValue();	

window.open("scr_item_detail.jsp?mode=view&s_factor_refitem=" +s_factor_refitem, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
	
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
		<td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목명</td>
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
    	  			<td><script language="javascript">btn("javascript:addItem()","등 록")</script></td>
    	  			<td><script language="javascript">btn("javascript:itemUpdate()","수 정")</script></td>
    	  			<td><script language="javascript">btn("javascript:itemDelete()","삭 제")</script></td>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>



<iframe name="hiddenframe" src="scr_item_ins.jsp" width="0" height="0"></iframe>
</form>

</s:header>
<s:grid screen_id="SR_007" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


