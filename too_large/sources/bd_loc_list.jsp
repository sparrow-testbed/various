<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_001_2");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_001_2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String HOUSE_CODE = info.getSession("HOUSE_CODE");
	String USER_NAME  = info.getSession("NAME_LOC");
	
	String callback = request.getParameter("callback");
	String sLoc 	= request.getParameter("sLoc");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_ann_list";

function init() {
	setGridDraw();
	doQuery();
}

function setGridDraw() {
	GridObj_setGridDraw();
	GridObj.setSizes();
}
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{ 

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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getLocList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}
function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    
    var sLoc 		= "<%=sLoc%>";
    
    var locArr = sLoc.split(",");
    
    for(var i = 0 ; i < GridObj.GetRowCount() ; i++){
    	for(var j = 0 ; j < locArr.length ; j++){
	    	if(GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("LOC_CODE")).getValue() == locArr[j]){
	    		GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
		    	GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).setValue("1");
	    	}
    	}
    }
    
    return true;
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}

function setLocCode(){
	if(!checkRows()) return;
		
	var callback 	= "<%=callback%>";
	var rtnStr 		= "";
	var getLocCode	= "";
	var getLocName	= "";
	
	//카운트#업체코드
	var selCnt = 0;
	for(var i = 0 ; i < GridObj.GetRowCount(); i++){
		if(GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("SELECTED")).getValue() == "1"){
			
			if(i == 0){
				getLocCode = GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("LOC_CODE")).getValue();
				getLocName = GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("LOC_NAME")).getValue();
			}else{
				getLocCode += ","+GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("LOC_CODE")).getValue();
				getLocName += ","+GridObj.cells( GridObj.getRowId(i), GridObj.getColIndexById("LOC_NAME")).getValue();
			}
			
			selCnt++;
		}
	}
	rtnStr = selCnt + "#" + getLocCode+"#"+getLocName;
	opener.eval(callback+"('"+rtnStr+"')");
	window.close();
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header  popup="true">
<!--내용시작--> 
<form name="form" > 
<table width="100%" height="3" border="0" cellspacing="0" cellpadding="0"><tr><td><b>지역선택</b></td></tr></table>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td height="5"> </td>
    </tr>
    <tr>
        <td width="100%" valign="top">
            <table width="100%" class="board-search" border="0" cellpadding="0" cellspacing="0">
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>  
    			<tr>
     				<td width="15%" class="tit">
        				<div align="left">지역명</div>
					</td>
					<td width="35%">
						<input type="text" name="loc_name" id="loc_name" size="20" maxlength="20" class="inputsubmit" >
					</td>
				</tr>
  			</table>

  			<table width="100%" border="0" cellspacing="0" cellpadding="0">
    			<tr>
      				<td height="30">
        				<div align="right">
							<table cellpadding="0">
								<tr>
									<td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
									<td><script language="javascript">btn("javascript:setLocCode()", "선 택")</script></td>
								</tr>
							</table>
						</div>
      				</td>
    			</tr>
  			</table>
        </td>
    </tr>
</table>
</form>
<!---- END OF USER SOURCE CODE ---->
</s:header>
<s:grid screen_id="BD_001_2" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
