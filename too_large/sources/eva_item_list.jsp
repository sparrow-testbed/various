<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_015";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>


<!-- 개발자 정의 모듈 Import 부분 -->
<%@ page import="java.util.*"%>

<% 
	String company_code = info.getSession("COMPANY_CODE");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<script language="javascript">
//<!--

	var INDEX_choose;
	var INDEX_factor_name;
	var INDEX_SCALE_count;
	var INDEX_systime_updated;
	var INDEX_user_name_loc;
	var INDEX_factor_type;
	var INDEX_e_factor_refitem;

	function setHeader() 
	{
		
		
	 	
	/* 	GridObj.AddHeader("e_factor_refitem",	"","t_text",100,0,false);
		 */
		GridObj.SetDateFormat("systime_updated","yyyy/MM/dd");
		
	
		INDEX_choose 			= GridObj.GetColHDIndex("choose");
		INDEX_factor_name 		= GridObj.GetColHDIndex("factor_name");
		INDEX_SCALE_count 		= GridObj.GetColHDIndex("scale_count");
		INDEX_systime_updated 	= GridObj.GetColHDIndex("systime_updated");
		INDEX_user_name_loc	 	= GridObj.GetColHDIndex("user_name_loc");
		INDEX_factor_type 		= GridObj.GetColHDIndex("factor_type");
		INDEX_e_factor_refitem 	= GridObj.GetColHDIndex("e_factor_refitem"); 
			
		//조회된 화면을 View한다.
		getQuery();
	}
	
	//Data Query해서 가져오기
	function getQuery() {
		
		<%-- var item_name = document.form.item_name.value;
		var operator = document.form.operator.value;
		var company_code = "<%= company_code %>";
		
		var servletUrl = "/servlets/master.template.eva_item_lst";

		GridObj.SetParam("item_name",item_name);
		GridObj.SetParam("operator",operator);
		GridObj.SetParam("company_code",company_code);
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
		GridObj.strHDClickAction="sortmulti"; --%>
		
		
		var grid_col_id     = "<%=grid_col_id%>";
		var param = "mode=getEvaList&grid_col_id="+grid_col_id;
		    param += dataOutput();
		var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_item_list";
	
		
		GridObj.post(url, param);
		GridObj.clearAll(false);	
		
	}
	
	//항목 추가
	function addEvaItem() { 
		var url = "eva_item_insert.jsp";
		popup(url);
	}
	
	
	
	//선택된 Row 수정 or 삭제
	function updateEvaItem() {
	
		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var e_factor_refitem;
		
		
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
		
		e_factor_refitem = GD_GetCellValueIndex(GridObj,cnt,INDEX_e_factor_refitem);
		
		
		var url = "eva_item_insert.jsp?mode=update&e_factor_refitem=" + e_factor_refitem;
		popup(url);
	}
	
	function delEvaItem(){
		var wise =  GridObj;
		var sel_row = 0;
		var cnt = 0;
		var e_factor_refitem = "";
		for(var i=0;i<GridObj.GetRowCount();i++){
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_choose);
			if(temp == "1") {
				sel_row++;
				e_factor_refitem = e_factor_refitem + "," + GridObj.cells(i+1, GridObj.getColIndexById("e_factor_refitem")).getValue();
			}
		}
		if(sel_row == 0) {
			alert("항목을 선택해주세요.");
			return;
		}
		e_factor_refitem = e_factor_refitem.substring(1);
		
		var value = confirm('삭제 하시겠습니까?');
		if(value){
			/* this.hiddenframe.location.href = "eva_item_ins.jsp?mode=delete&e_factor_refitem=" + e_factor_refitem;
 */
 		
			var cols_ids = "<%=grid_col_id%>";
	    	var url = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.eva_item_list";
			var params = "mode=setEvaDelete&cols_ids="+cols_ids;
				params += dataOutput();
			var grid_array = getGridChangedRows(GridObj, "choose");
		    myDataProcessor = new dataProcessor(url, params);
		    sendTransactionGridPost(GridObj, myDataProcessor, "choose", grid_array);
		}
	}
	
	function popup(url) {
		var left = 0;
		var top = 0;
		var width = 600;
		var height = 450;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'yes';
		var resizable = 'no';
		
		var doc = window.open( url, 'doc', 'left=250, top=250, width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	}

	//enter를 눌렀을때 event발생
	function entKeyDown()
	{
  		if(event.keyCode==13) {
   			window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
   			getQuery();
  		}
  	}
  	
  	function onRefresh() {
setGridDraw();
setHeader();
  	}
  	
  	//1 - 이벤트종류, 2-행의 인덱스 3-열의인덱스, 4-이벤트 지정셀의 이전값, 5-현재값(변경된)
  	function JavaCall(msg1,msg2,msg3,msg4,msg5){
		for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					//GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
		
		//내용보기
		if(msg3 == INDEX_factor_name){
			var e_factor_refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_e_factor_refitem);
			var url = "eva_item_pop1.jsp?mode=view&e_factor_refitem=" + e_factor_refitem;
			
			popup(url);
			
		}	
	}
//-->

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

if(header_name == "factor_name") {
	
var e_factor_refitem = GridObj.cells(rowId, GridObj.getColIndexById("e_factor_refitem")).getValue();	

window.open("eva_item_detail.jsp?mode=view&e_factor_refitem=" +e_factor_refitem, "_blank", "width=800, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no" );
	
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
<form name="form" method="post" action="">

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
      <td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 항목명
      </td>
      <td class="c_data_1" width="35%">
        <input type="text" size="30" value="" name="item_name" id="item_name" class="inputsubmit" onkeydown='entKeyDown()' >
       
    </td>
      <td class="c_title_1" width="15%"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 작성자
      </td>
      <td class="c_data_1" width="35%">
        <input type="text" name="operator" id="operator" size="20" class="inputsubmit" onkeydown='entKeyDown()' ></td>
    </tr>
  </table>

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td height="30">
      <div align="right">
	  <TABLE cellpadding="0">
		<TR>
		  <td><script language="javascript">btn("javascript:getQuery()","조 회")</script></td>
		  <td><script language="javascript">btn("javascript:addEvaItem()","등 록")</script></td>
		  <td><script language="javascript">btn("javascript:updateEvaItem()","수 정")</script></td>
		  <td><script language="javascript">btn("javascript:delEvaItem()","삭 제")</script></td>
		</TR>
	  </TABLE>
	  </div>
    </td>
  </tr>
</table>


<iframe name="hiddenframe" src="eva_item_ins.jsp" width="0" height="0"></iframe>
</form>

</s:header>
<s:grid screen_id="SR_015" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


