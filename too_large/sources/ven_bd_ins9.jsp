<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        vendor icomvncp 담당자 생성
 Description:
 Copyright:    Copyright (c)
 Company:      ICOMPIA <p>
 @author       eun pyo ,Lee<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
--%>

<!-- PROCESS ID 선언 -->
<% String WISEHUB_PROCESS_ID="SU_002";%>

<!-- 사용 언어 설정 -->
<% String WISEHUB_LANG_TYPE="KR";%>

<!-- 개발자 정의 모듈 Import 부분 -->
<%
	String user_id 			= JSPUtil.nullToEmpty(info.getSession("ID"));
	String user_name_loc 	= JSPUtil.nullToEmpty(info.getSession("NAME_LOC"));
	String user_name_eng 	= JSPUtil.nullToEmpty(info.getSession("NAME_ENG"));
	String user_dept 		= JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"));
	String house_code 		= JSPUtil.nullToEmpty(info.getSession("HOUSE_CODE"));

	String vendor_code      = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
	String company_code     = JSPUtil.nullToEmpty(request.getParameter("company_code"));
	String flag             = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String popup             = JSPUtil.nullToEmpty(request.getParameter("popup"));
	int year = Integer.parseInt(SepoaDate.getShortDateString().substring(0,4));
    int count = 0;
    String combo_year = "";
    for(int i = year ; i > year-50 ; i--){
    	combo_year += i+"&";
    	combo_year += i+"#";
    	count++;
    }
//     SepoaListBox LB = new SepoaListBox();
// 	String COMBO_M002     = LB.Table_ListBox(info, "SL0014", house_code+"#M002#", "&" , "#"); //괌&GU#남아프리카&ZA#
// 	String COMBO_M138     = LB.Table_ListBox(info, "SL0048", house_code+"#M138#", "&" , "#"); //괌&GU#남아프리카&ZA#
// 	String COMBO_IDX_M002 = ""+CommonUtil.getComboIndex(COMBO_M002,"KRW","#");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<Script language="javascript" type="text/javascript">
<!--
var G_SERVLETURL         = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_ins9";
var G_QUERY_VENDOR_CODE  = "<%=vendor_code%>";
var G_QUERY_COMPANY_CODE = "<%=company_code%>";
var G_HOUSE_CODE         = "<%=house_code%>";
var G_FLAG               = "<%=flag%>";

var IDX_SEL				;
var IDX_PROJECT_NAME	;
var IDX_PROJECT_YEAR	;
var IDX_ENT_FROM_DATE   ;
var IDX_ENT_TO_DATE	    ;
var IDX_CUSTOMER_NAME   ;
var IDX_MAIN_CONT_NAME  ;
var IDX_CUR			    ;
var IDX_PROJECT_AMT	    ;
var IDX_HOUSE_CODE	    ;
var IDX_VENDOR_CODE	    ;
var IDX_SEQ			    ;
var IDX_FLAG			;
var IDX_PROJECT_TYPE	;
var WIDTH_SELECTED = "30";
function disableAll(wise)
{
	for(var i=0;i<GridObj.GetRowCount();i++)
	{
		for(var j=0;j<GridObj.GetColCount();j++)
		{
			GD_SetCellActivation(GridObj,i,j,false);
		}
	}
}
function setHeader()
{

// 	GridObj.SetNumberFormat("PROJECT_AMT"		,G_format_amt);

	IDX_SEL				= GridObj.GetColHDIndex("SEL"				);
    IDX_PROJECT_NAME	= GridObj.GetColHDIndex("PROJECT_NAME"	);
    IDX_PROJECT_YEAR	= GridObj.GetColHDIndex("PROJECT_YEAR"	);
    IDX_ENT_FROM_DATE   = GridObj.GetColHDIndex("ENT_FROM_DATE"   );
    IDX_ENT_TO_DATE	    = GridObj.GetColHDIndex("ENT_TO_DATE"	    );
    IDX_CUSTOMER_NAME   = GridObj.GetColHDIndex("CUSTOMER_NAME"   );
    IDX_MAIN_CONT_NAME  = GridObj.GetColHDIndex("MAIN_CONT_NAME"  );
    IDX_CUR			    = GridObj.GetColHDIndex("CUR"			    );
    IDX_PROJECT_AMT	    = GridObj.GetColHDIndex("PROJECT_AMT"	    );
    IDX_PROJECT_TYPE    = GridObj.GetColHDIndex("PROJECT_TYPE"    );
    IDX_HOUSE_CODE	    = GridObj.GetColHDIndex("HOUSE_CODE"	    );
    IDX_VENDOR_CODE	    = GridObj.GetColHDIndex("VENDOR_CODE"	    );
    IDX_SEQ			    = GridObj.GetColHDIndex("SEQ"			    );
    IDX_FLAG			= GridObj.GetColHDIndex("FLAG"			);

	doSelect();  //  업체코드,회사단위  참조시에는 참조 데이타가 들어감
}

// 헤더의 버튼이 눌려지면 참조시일 경우 참조 데이타가 뿌려진다.
function doSelect()
{
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getVendorProject";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
	
	
	//alert('doselect');
<%-- 	GridObj.SetParam("CUR"			,"<%=COMBO_M002%>"); --%>
<%-- 	GridObj.SetParam("PROJECT_TYPE"	,"<%=COMBO_M138%>"); --%>
//     GridObj.SetParam("vendor_code"	,G_QUERY_VENDOR_CODE);
// 	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 	GridObj.SendData(G_SERVLETURL);
// 	GridObj.strHDClickAction="sortmulti";

}

//Line Insert
function setLineInsert()
{
	var newId = (new Date()).valueOf();
	GridObj.addRow(newId,"");
	var row = GridObj.GetRowCount();
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("FLAG")).setValue("I");	
	
	
<%-- 	GD_SetCellValueIndex(GridObj,row, IDX_PROJECT_YEAR 	,"<%=combo_year%>", "&","#"); --%>
<%-- 	GD_SetCellValueIndex(GridObj,row, IDX_CUR 			,"<%=COMBO_M002%>", "&","#","<%=COMBO_IDX_M002%>"); --%>
<%-- 	GD_SetCellValueIndex(GridObj,row, IDX_PROJECT_TYPE	,"<%=COMBO_M138%>", "&","#"); --%>
}

//Data Save
function setSave()
{
	var wise = GridObj;
	var rowCount = wise.GetRowCount();
	var selectedRow = 0;
	for( i = 0 ; i < rowCount ; i++){
		if("1" == wise.GetCellValue("SELECTED",i)){
			selectedRow++;
			if(GD_GetCellValueIndex(GridObj,i,IDX_PROJECT_NAME	) == ""){
				alert("프로젝트명을 입력해주세요.");
				return;
			}
// 			if(GD_GetCellValueIndex(GridObj,i,IDX_PROJECT_YEAR	) == ""){
// 				alert("년도를 입력해 주십시요.");
// 				return;
// 			}
			if(GD_GetCellValueIndex(GridObj,i,IDX_ENT_FROM_DATE  	) == ""){
				alert("시작일을 입력해 주십시요.");
				return;
			}
			if(GD_GetCellValueIndex(GridObj,i,IDX_ENT_TO_DATE		) == ""){
				alert("종료일을 입력해 주십시요.");
				return;
			}
			if(GD_GetCellValueIndex(GridObj,i,IDX_CUSTOMER_NAME  	) == ""){
				alert("최종고객사를 입력해 주십시요.");
				return;
			}
			if(GD_GetCellValueIndex(GridObj,i,IDX_MAIN_CONT_NAME 	) == ""){
				alert("계약회사를 입력해 주십시요.");
				return;
			}

			if(GD_GetCellValueIndex(GridObj,i,IDX_CUR				) == ""){
// 			if(GridObj.GetCellHiddenValue("CUR", i) == ""){
				alert("통화를 입력해 주십시요.");
				return;
			}

			if(GD_GetCellValueIndex(GridObj,i,IDX_PROJECT_AMT		) == ""){
				alert("수주금액을 입력해 주십시요.");
				return;

			}
		}
	}

	if(selectedRow == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}


	if(!confirm("저장하시겠습니까?"))
		return;

	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=setVendorProject";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor( G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);	
}


/* 선택한 항목을 지운다. */
function Delete()
{
	var wise = GridObj;
	var rowCount = wise.GetRowCount();
	var selectedRow = 0;
	for( i = 0 ; i < rowCount ; i++){
		if("1" == wise.GetCellValue("SELECTED",i)){
			selectedRow++;
		}
	}
	if(selectedRow == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	if(!confirm("정말로 삭제하시겠습니까?"))
		return;
	
	
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var cols_ids = "<%=grid_col_id%>";
	var params;
	params = "?mode=delVendorProject";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	myDataProcessor = new dataProcessor( G_SERVLETURL+params);
	//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);		
}
var nextFlag = false;
/* 선택한 항목을 지운다. */
function NextPage()
{
/*
	if(!nextFlag){
		alert("수주실적은 2건 이상 입력하셔야 합니다..");
		return;
	}
*/
	parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide');
	parent.up.goPage('qr');
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	if(msg1 == "doQuery")
	{
		var wise = GridObj;
		var rowCount = wise.GetRowCount();
		/*
		if(rowCount < 2){
			nextFlag = false;
		}else{
			nextFlag = true;
		}
		*/
		if(G_FLAG == "D")
		{
			disableAll(GridObj);
		}
	}
	if(msg1 == "doData")
	{
		//rtn = GD_GetParam(GridObj,0);
	   	//alert(rtn);
	   	alert(GridObj.GetMessage());
		doSelect();
		return;
	}

	max_row = GridObj.GetRowCount();

	if(msg1 == "t_imagetext" )
	{
		document.forms[0].srow.value = msg2;

		if (msg3 == INDEX_POP1)
		{
			PopupCommon2("SP9053","getPosition",G_HOUSE_CODE,"M106","","");
		}

	}

}

function getPosition(code,name) {

	var row = document.forms[0].srow.value;

	GD_SetCellValueIndex(GridObj,row,INDEX_TEXT_POSITION,name);
	GD_SetCellValueIndex(GridObj,row,INDEX_POSITION,code);
}
function BackPage()
{
	parent.up.MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
	parent.up.goPage('cp');
}
//-->
</Script>
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
    	if(IDX_ENT_FROM_DATE == cellInd){
    		GridObj.cells(rowId, GridObj.getColIndexById("PROJECT_YEAR")).setValue(GridObj.cells(rowId, cellInd).getValue().split("/")[0]);
    	}
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
        doSelect();
    } else {
        alert(messsage);
    }
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
//     } 

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
<body onload="setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  style="margin-top: 20px;margin-left: 20px;">
<s:header popup="true">
<!--내용시작-->
<form id="form" name="form" method="post" action="">
	<input type="hidden" id="srow" name="srow" value="" ><%-- 팝업 로우를 기억하기 위함 --%>
	<input type="hidden" id="vendor_code" name="vendor_code" value="<%=vendor_code%>"><%-- 팝업 로우를 기억하기 위함 --%>
	<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
		<TR>
			<TD><font color='red'>최근 3년의 수주실적을 입력해 주시기 바랍니다.(타사 실적포함)</font></TD>
			<TD height="30" align="right">

<%if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) {%>
				<TABLE cellpadding="0">
					<TR>
  						<td><script language="javascript">btn("javascript:setLineInsert()","행삽입")</script></td>
						<TD><script language="javascript">btn("javascript:setSave()","저 장")</script></TD>
  						<TD><script language="javascript">btn("javascript:Delete()","삭 제")</script></TD>
  						<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
						<TD><script language="javascript">btn("javascript:NextPage()","다 음")</script></TD>
					</TR>
				</TABLE>
<%}%>
			</TD>
		</TR>
	</TABLE>
</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SU_002" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


