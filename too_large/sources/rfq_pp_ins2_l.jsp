<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_243_l");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_243_l";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;


	String SG_REFITEM = JSPUtil.nullToEmpty(request.getParameter("SG_REFITEM"));
	String WISEHUB_PROCESS_ID="RQ_243_l";
	String G_IMG_ICON = "/images/ico_zoom.gif";
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
<script language="javascript" type="text/javascript">
var mode;
var IDX_SEL	       			;
var IDX_VENDOR_CODE         ;
var IDX_VENDOR_NAME_LOC     ;
var IDX_SITE_NAME    		;
var IDX_PHONE_NO1       	;
var IDX_SEARCH_KEY   		;
var IDX_PURCHASE_BLOCK_FLAG ;
var IDX_VENDOR_COND  		;
var IDX_IRS_NO       		;
var IDX_SALES_PERSON 		;


function setHeader() {
	IDX_SEL	       			  = GridObj.GetColHDIndex("SEL");
	IDX_VENDOR_CODE           = GridObj.GetColHDIndex("VENDOR_CODE");
	IDX_VENDOR_NAME_LOC       = GridObj.GetColHDIndex("VENDOR_NAME_LOC");
	IDX_SITE_NAME    		  = GridObj.GetColHDIndex("SITE_NAME");
	IDX_PHONE_NO1       	  = GridObj.GetColHDIndex("PHONE_NO1");
	IDX_SEARCH_KEY   		  = GridObj.GetColHDIndex("SEARCH_KEY");
	IDX_PURCHASE_BLOCK_FLAG   = GridObj.GetColHDIndex("PURCHASE_BLOCK_FLAG");
	IDX_VENDOR_COND  		  = GridObj.GetColHDIndex("VENDOR_COND");
	IDX_IRS_NO       		  = GridObj.GetColHDIndex("IRS_NO");
	IDX_SALES_PERSON 		  = GridObj.GetColHDIndex("SALES_PERSON");
}

//rfq_pp_ins2_t.jsp에서 호출합니다.
function doSelect(VENDOR_CODE, MAKER_NAME, materialType, materialCtrlType, materialClass1, vendorType, creditRating) {
	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/dt.rfq.rfq_pp_ins2_l";

	document.getElementById("VENDOR_CODE").value      = VENDOR_CODE;
	document.getElementById("MAKER_NAME").value       = MAKER_NAME;
	document.getElementById("materialType").value     = materialType;
	document.getElementById("materialCtrlType").value = materialCtrlType;
	document.getElementById("materialClass1").value   = materialClass1;
	document.getElementById("vendorType").value       = vendorType;
	document.getElementById("creditRating").value     = creditRating;

	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getRfqVedorList";
	
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post(servletUrl, params);
	
	GridObj.clearAll(false);
}

function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
  if(msg1 == "t_insert"){
     var flag = GD_GetCellValueIndex(GridObj,msg2,IDX_PURCHASE_BLOCK_FLAG);
    if(flag == "Y"){
      alert("거래정지된 업체입니다.");
      GD_SetCellValueIndex(GridObj,msg2, IDX_SEL, "false&" , "&");
      return;
    }

  }
}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
	GridObj_setGridDraw();
	GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    }
    else if(stage==1) {
    	return false;
    }
    else if(stage==2) {
        return true;
    }
}

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
    }
    else {
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
    
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }
    
    return true;
}
</script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" method="post" action="">
		<input type="hidden" name="VENDOR_CODE" id="VENDOR_CODE" value="">
		<input type="hidden" name="MAKER_NAME" id="MAKER_NAME" value="">
		<input type="hidden" name="materialType" id="materialType" value="">
		<input type="hidden" name="materialCtrlType" id="materialCtrlType" value="">
		<input type="hidden" name="materialClass1" id="materialClass1" value="">
		<input type="hidden" name="vendorType" id="vendorType" value="">
		<input type="hidden" name="creditRating" id="creditRating" value="">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="left" class="title_page">전체업체</td>
			</tr>
		</table>
	</form>
	<s:grid screen_id="RQ_243_l" grid_obj="GridObj" grid_box="gridbox" height="200" />
</s:header>
<s:footer/>
</body>
</html>