<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("RQ_247");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "RQ_247";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="RQ_247";
	String WISEHUB_LANG_TYPE="KR";

	String rfq_no    = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	String rfq_seq   = JSPUtil.nullToEmpty(request.getParameter("rfq_seq"));

	String qta_no    = JSPUtil.nullToEmpty(request.getParameter("qta_no"));
	String qta_seq   = JSPUtil.nullToEmpty(request.getParameter("qta_seq"));

	String item_no     = JSPUtil.nullToEmpty(request.getParameter("item_no"));
	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));

	String edit = "Y";

	String editflag = "true";

	Object[] args = {"M038"};
	SepoaOut value = null;  
	SepoaRemote wr = null;
	String nickName = "p1060";
	String MethodName = "getQuery_app210_1";
	String conType = "CONNECTION";
	String combo = "";
	String discr = "";
        
	//다음은 실행할 class을 loading하고 Method호출수 결과를 return하는 부분이다.
	try {
		wr = new SepoaRemote(nickName,conType,info);
		value = wr.lookup(MethodName,args);
		Logger.debug.println(info.getSession("ID"),request,value.result[0]);
	}
	catch(Exception e) {
		Logger.err.println(info.getSession("ID"),this,"e = " + e.getMessage());
		Logger.dev.println(e.getMessage());
	}
	finally{
		wr.Release();

		SepoaFormater wf = new SepoaFormater(value.result[0]);
		
		for(int i = 0 ; i < wf.getRowCount() ; i++){
			combo+=(discr+wf.getValue(i,1)+"^"+wf.getValue(i,0));
			discr = "$";
		}
	}
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="../../css/<%=info.getSession("HOUSE_CODE")%>/popup.css" type="text/css">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="JavaScript">
function init(){
	setGridDraw();
	setHeader();
	getQuery();
}

function getQuery() {
	var fr = document.form;

    var vendor_code = "<%=vendor_code%>";
    var qta_no = "<%=qta_no%>";
    var qta_seq = "<%=qta_seq%>";

    var servletUrl = "/servlet/dt.app.app_pp_ins1";
      
    GridObj.SetParam("vendor_code",vendor_code);
    GridObj.SetParam("qta_no",qta_no);
    GridObj.SetParam("qta_seq",qta_seq); 
    
    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl);
    GridObj.strHDClickAction="sortmulti";
}

//Line Insert
function setLineInsert() {
	if("<%=edit%>" != "Y"){
		alert("데이타를 변경할 수 없습니다.");
		
		return;
    }
	
	GridObj.AddRow();

    var row = GridObj.GetRowCount();
    GD_SetCellValueIndex(GridObj,row-1,1,"<%=combo%>","^","$");
} 

//선택된 정보를 삭제한다.
function delData() {
	if("<%=edit%>" != "Y"){
		alert("데이타를 변경할 수 없습니다.");
		
		return;
	}

    var row = GridObj.GetRowCount();
    var cnt = 0;
    var sendcnt = 0;
    var sendRow = "";

    for(var i = 0;i < row;i++){
		var check = GD_GetCellValueIndex(GridObj,i,"0");
		
		if(check == "true"){
			cnt++;
			var charge_code = GD_GetCellValueIndex(GridObj,i,"4");

			if(charge_code != ""){
				sendcnt++;
				sendRow += (i+"&");
			}//else GridObj.DeleteRow(i);
		}//end of if(true)
	}//end of for

	if(cnt == 0) {
		alert("선택하신 로우가 없습니다.");
		
		return;
    }

    if(sendcnt > 0){
		var servletUrl = "/servlet/dt.app.app_pp_ins1";
		
		GridObj.SetParam("mode","setQtChargeDelete");
		GridObj.SetParam("vendor_code","<%=vendor_code%>");
		GridObj.SetParam("qta_no","<%=qta_no%>");
		GridObj.SetParam("qta_seq","<%=qta_seq%>");
		GridObj.SetParam("rfq_no","<%=rfq_no%>");
		GridObj.SetParam("rfq_count","<%=rfq_count%>");
		GridObj.SetParam("rfq_seq","<%=rfq_seq%>");
		GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, sendRow, "1&2&3&4&5");
    }
    
    if(sendRow == ""){
		for(var j = (row-1);j >= 0 ; j--){
			var check = GD_GetCellValueIndex(GridObj,j,0);
			
			if(check =="true"){
				GridObj.DeleteRow(j);
			}
		}
	}
}

//선택된 정보를 변경/생성한다.
function setSave() {
	if("<%=edit%>" != "Y"){
		alert("데이타를 변경할 수 없습니다.");
		
		return;
	}
	
	var row = GridObj.GetRowCount();
	var cnt = 0;
    var sendRow = "";
    var gettext = "";

    for(var i = 0;i < row;i++){
		gettext = GridObj.GetCellValue(GridObj.GetColHDKey("1"),i);
		GD_SetCellValueIndex(GridObj,i,"5",gettext);
		GD_SetCellValueIndex(GridObj,i,"0","true&","&");
    }//end of for

	for(var a = 0;a < row;a++){
		var value = GD_GetCellValueIndex(GridObj,a,"1");
		
		for(var i = (a+1);i < row;i++){
			var combo = GD_GetCellValueIndex(GridObj,i,"1");
			
			if(combo == value){
				alert("Charge 명이 중복되었습니다.")
				
				return;
			}//end of if
		}//end of for
	}//end of for

	var servletUrl = "/servlet/dt.app.app_pp_ins1";
	
	GridObj.SetParam("mode","setQtChargeUpdate");
	GridObj.SetParam("vendor_code","<%=vendor_code%>");
	GridObj.SetParam("qta_no","<%=qta_no%>");
	GridObj.SetParam("qta_seq","<%=qta_seq%>");
	GridObj.SetParam("rfq_no","<%=rfq_no%>");
	GridObj.SetParam("rfq_count","<%=rfq_count%>");
	GridObj.SetParam("rfq_seq","<%=rfq_seq%>");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(servletUrl, sendRow, "1&2&3&4&5");
}

function JavaCall(msg1,msg2,msg3,msg4,msg5) {
	if(msg1 == "doData") {
		if(GD_GetParam(GridObj,0) == "1" && GD_GetParam(GridObj,1) == "setQtChargeDelete"){
			var row = GridObj.GetRowCount();
			
			for(var j = (row-1);j >= 0; j--){
				var check = GD_GetCellValueIndex(GridObj,j,0);
				
				if(check =="true"){
					GridObj.DeleteRow(j);
				}
			}
		}
		else{//insert
			getQuery();
		}
	}

	if(msg3 == '1'){
		var code = GD_GetCellValueIndex(GridObj,msg2,1);
    }
}
</script>

<script language="javascript" type="text/javascript">
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
<body onload="init();GD_setProperty(document.WiseGrid);" bgcolor="#FFFFFF" text="#000000" >
<s:header>
	<form name="form1" >
		<table width="98%" border="0" cellspacing="0" cellpadding="0" class="title_table_top" align="center">
			<tr > 
				<td class="title_table_top" ><b>CHARGE 정보입력</b></td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
				<td></td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
				<td width="20%" class="cell_title"> 
					<div align="left">
						견적요청번호
					</div>
				</td>
				<td class="cell_data" >
					<b>
						<%=rfq_no%>
					</b>
				</td>
				<td width="20%" class="cell_title"> 
					<div align="left">
						항번/품목번호
					</div>
				</td>
				<td class="cell_data" >
					<b>
						<%=rfq_seq%>
					</b>
					 / 
					<b>
						<%=item_no%>
					</b>
				</td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
				<td></td>
			</tr>
		</table>
		<div align="center">
			<script language="JavaScript" >
			</script>
		</div>
		<br>
		<div align="center"> 
			<s:grid screen_id="RQ_247" grid_obj="GridObj" grid_box="gridbox"/>  
		</div>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr> 
				<td width="20%"></td>
				<td width="80%" height="30"> 
					<div align="right">
						<a href = "javascript:setLineInsert();">
							<img src="../../images//button/lineinsert.gif" align="absmiddle" border=0>
						</a> 
						<a href = "javascript:setSave();">
							<img src="../../images//button/butt_save_kor.gif" align="absmiddle" border=0>
						</a>
						<a href = "javascript:delData();">
							<img src="../../images//button/butt_delete_kor.gif" align="absmiddle" border=0>
						</a>
						<a href = "javascript:top.close();">
							<img src="../../images//button/butt_close_kor.gif" align="absmiddle" border=0>
						</a>
					</div>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<s:footer/>
</body>
</html>