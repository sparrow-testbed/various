<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str) throws Exception{
	String result = null;
	
	result = this.nvl(str, "");
	
	return result;
}

private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}

private String getDateSlashFormat(String target) throws Exception{
	String       result       = null;
	StringBuffer stringBuffer = new StringBuffer();
	
	stringBuffer.append(target.subSequence(0, 4)).append("/").append(target.substring(4, 6)).append("/").append(target.substring(6, 8));
	
	result = stringBuffer.toString();
	
	return result;
}
%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("EV_006");
	multilang_id.addElement("EV_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "EV_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String G_IMG_ICON     = "/images/ico_zoom.gif"; // 이미지 
	
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
    String to_time = SepoaDate.getShortTimeString();
%>
<%--
 Title:        	t0002  <p>
 Description:  	품목  목록<p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	DEV.Team Echo<p>
 @version      	1.0.0<p>
 @Comment       실제 제조업체의 공장 단위를 의미.<p>
 				소요량 관리의 기준이 된다.<p>
 				하나의 PlantUnit은 하나의 Company에 종속되나,여러개의 Operating Unit에 연결되어 질 수 있으므로,<p>
 				Plant를 개별로 생성후 OperatingUnit에 연결해 주는 Assign부분이 별도로 존재한다.<p>
--%>

<% String WISEHUB_PROCESS_ID="EV_006";%>

<%
    String house_code      = info.getSession("HOUSE_CODE");
    String company_code    = info.getSession("COMPANY_CODE");
    String company_code_nm = info.getSession("COMPANY_NAME");
    String user_id         = info.getSession("ID");
    String name_loc        = info.getSession("NAME_LOC");
    String dept            = info.getSession("DEPARTMENT");
    String ctrl_code       = info.getSession("CTRL_CODE");


    //첨부파일 보기 PATH
	//Config conf = new Configuration();
	//String server_name = conf.get("wise.ip.info");
	//String attach_path = CommonUtil.getConfig("wisehub.attach.view.IMAGE");
	String attach_path = "";
	String gate         = JSPUtil.nullToRef(request.getParameter("gate"),""); // 외부에서 접근하였을 경우 flag
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
var GridObj = null;
var GridObj2 = null;
var ACT_GB = null;

function Init()
{
	GridObj_setGridDraw();
	GridObj.setSizes();
	
	GridObj2_setGridDraw();
	GridObj2.setSizes();
	initAjax();
}

function initAjax(){
	doRequestUsingPOST( 'SL0198', '' ,'p_year', '<%=SepoaDate.getYear()%>' );
}

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ev.te_ev_wait_list";

function doSelect()
{
	var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getEtplList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.postGrid( G_SERVLETURL, params );
    GridObj.clearAll(false);	
    
    click_rowId = null;
    click_rowId2 = null;
}

function doSaveEtpl()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	var rowcount = grid_array.length;
	
	for(var i = 0; i < grid_array.length; i++)
	{
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("EVAL_YY")).getValue()))
		{
			alert("평가년도를 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ETPL_NM")).getValue()))
		{
			alert("기술평가계획제목을 입력하세요.");
			return;
		}
		
		if("C" != LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CU")).getValue()))
		{
			if('<%=info.getSession("ID")%>' != GridObj.cells(grid_array[i], GridObj.getColIndexById("ADD_USER_ID")).getValue() 
			 		&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP210200001" 
					&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP150400001" ){
				alert("저장 권한이  없습니다.\r\n\r\n저장 권한자 ( 생성자 , 총무팀장 )");
				return;
			}
		}
	}
	
	if(rowcount > 1)  {
		alert(G_MSS2_SELECT);		
		return;
	}

    if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=saveEtplList";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	    
	    ACT_GB = "EPTL_S";
//	    click_rowId = null;
//	    click_rowId2 = null;
    }
}

function doDeleteEtpl()
{
	if(!checkRows())return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);
	
	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CU")).getValue())
		{
			alert("행삭제를 하세요.");
			return;
    	}
		
		if("T" != GridObj.cells(grid_array[row], GridObj.getColIndexById("PRG_STS_OLD")).getValue())
		{
			alert("진행상태가 평가대기만 삭제 가능합니다.");
			return;
    	}
		
		if('<%=info.getSession("ID")%>' != GridObj.cells(grid_array[row], GridObj.getColIndexById("ADD_USER_ID")).getValue() 
		 		&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP210200001" 
				&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP150400001" ){
			alert("삭제 권한이  없습니다.\r\n\r\n삭제권한자 ( 생성자 , 총무팀장 )");
			return;
		}
    }
	
	if(rowcount > 1)  {
		alert(G_MSS2_SELECT);		
		return;
	}
    
   	if (confirm("삭제하시겠습니까?")){
   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
	    var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=deleteEtpl";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		 
		ACT_GB = "EPTL_D";
//		click_rowId = null;
//		click_rowId2 = null;
   }
}

//행추가 이벤트 입니다.
function doAddRowEtpl()
{
	var rowCnt = parseInt(GridObj.getRowsNum());
	dhtmlx_last_row_id = rowCnt + 1;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CU")).setValue("C");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("EVAL_YY")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETPL_NO")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ETPL_NM")).setValue("");    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("IMPL_USER_NAME_LOC")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("IMPL_DATE")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("END_USER_NAME_LOC")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("END_DATE")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("PRG_STS")).setValue("T");
    
    dhtmlx_before_row_id = nMaxRow2;
    
	click_rowId = nMaxRow2;
	GridObj2.clearAll();
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRowEtpl()
{
	if(!checkRows())return;
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("1" == GridObj.cells(grid_array[row], 0).getValue() && "C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CU")).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
	
	click_rowId = null;
	click_rowId2 = null;
}

function viewImage(item_no, description_loc, specification, image_file_path) {
	var left = 187; var top = 134;
	var resizable = "yes";
	var toolbar = "no"; var menubar = "no"; var status = "no"; var scrollbars = "yes";
    var attachImageUrl = "<%=attach_path%>";

	var url = "mat_pp_dis3.jsp?source=" + attachImageUrl + "&doc_no=" + image_file_path + "&item_no=" + item_no + "&description_loc=" + description_loc + "&specification=" + specification;

	if(url != "") {
		var width = 100;
		var height = 100;

		var view = window.open(url, 'view', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		view.focus();
	}
}
</script>

<script language="javascript" type="text/javascript">
var MenuObj = null;
var myDataProcessor = null;

var click_rowId = null;
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
	var left = 30;
    var top = 30;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'yes';
    var scrollbars = 'yes';
    var resizable = 'no';
    var width = "";
    var height = "";
    
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
    
	if( GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		GridObj2.clearAll(); 	 
    }
	
    if( click_rowId != rowId && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() != "C"){
	    var etpl_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "ETPL_NO")));
	    document.forms[0].ETPL_NO.value = etpl_no;
		var params = "mode=getEtplDtList";
		params += "&etpl_no=" + etpl_no;
		var cols_ids = "SELECTED,CU,ETPL_NO,ETPL_SEQ,ES_CD_SEL,ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM,GROUP1_CODE,GROUP1_NAME_LOC,EVAL_USER_SEL,EVAL_USER_NAMES,EVAL_USER_IDS,EVAL_USER_CNT,STATUS,STATUS_TXT,EVAL_USER_NAMES_OLD,EVAL_USER_IDS_OLD,EVAL_USER_CNT_OLD";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj2.postGrid( G_SERVLETURL, params );
		GridObj2.clearAll(false);
		
		//var f = document.forms[0];
		//f.CT_USER_ID.value                = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
		//f.CT_USER_NAME.value              = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();		
    }
	click_rowId = rowId;
    if(header_name == "CT_USER") {
		var url  = '';
		var title  = '';
		var param  = '';
		//window.open("/common/CO_008_ict.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		url    = '/common/CO_008_ict.jsp';
		title  = '담당자조회';
	    param  = 'popup=Y';
		param  += '&callback=getCtrlUser';
		popUpOpen01(url, title, '450', '550', param);	
	}
    
    /*
   	var gg = getGridSelectedRows(GridObj, "SELECTED");
	if(gg !=0){
		
		for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
		{
			//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
			GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		}
	}
	
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	*/
	
	
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	//GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{
		if(GridObj.cells(grid_array[row], GridObj.getColIndexById("CU")).getValue() != "C"){
			GridObj.cells(grid_array[row], GridObj.getColIndexById("SELECTED")).setValue(0);
			GridObj.cells(grid_array[row], GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
		}
    }	
	
	
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
	var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
    	
    	return true;
    } else if(stage==1) {
    	
    	
    	return true;
    } else if(stage==2) {    	
    	return true;
    }
    
    return false;
}



// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj) {
	var messsage = obj.getAttribute("message");
	var mode     = obj.getAttribute("mode");
	var status   = obj.getAttribute("status");
	var data_type= obj.getAttribute("data_type");

	document.getElementById("message").innerHTML = messsage;

	myDataProcessor.stopOnError = true;

	if(dhxWins != null) {
		dhxWins.window("prg_win").hide();
		dhxWins.window("prg_win").setModal(false);
	}

	if(status == "true") {
		alert(messsage);
		if(ACT_GB == "EPTL_S" || ACT_GB == "EPTL_D"){
			click_rowId = null;
			click_rowId2 = null;
			doSelect();	
		}else if(ACT_GB == "EPTLDT_S" || ACT_GB == "EPTLDT_D"){
			click_rowId2 = null;
			var etpl_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, click_rowId, "ETPL_NO")));
		    document.forms[0].ETPL_NO.value = etpl_no;
			var params = "mode=getEtplDtList";
			params += "&etpl_no=" + etpl_no;
			var cols_ids = "SELECTED,CU,ETPL_NO,ETPL_SEQ,ES_CD_SEL,ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM,GROUP1_CODE,GROUP1_NAME_LOC,EVAL_USER_SEL,EVAL_USER_NAMES,EVAL_USER_IDS,EVAL_USER_CNT,STATUS,STATUS_TXT,EVAL_USER_NAMES_OLD,EVAL_USER_IDS_OLD,EVAL_USER_CNT_OLD";			
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			GridObj2.postGrid( G_SERVLETURL, params );
			GridObj2.clearAll(false);
			
			//var f = document.forms[0];
			//f.CT_USER_ID.value                = GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
			//f.CT_USER_NAME.value              = GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();		
		}
	} else {
		alert(messsage);
	}

	return false;
}

function reload_page()
{
	doSelect();
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

	if(status == "false") alert(msg);
	
	GridObj2.clearAll();
	document.forms[0].BIZ_NO.value = "";
	return true;
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}

//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}





/////////////////////////////////////////////
//그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows2()
{
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");

	if(grid_array2.length > 0)
	{
		return true;
	}

	alert("선택된 행이 없습니다.");
	return false;	
}

function doSaveEtplDt()
{
	if(click_rowId == null){
		alert("기숲평가계획을 지정후 저장(공종) 하세요.");
		return;
	}
	   
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		alert("기숲평가계획을 저장후 저장(공종) 하세요.");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS")).getValue() != "T"){
		alert("진행상태가 평가대기만 저장(공종) 가능합니다");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS_OLD")).getValue() != "T"){
		alert("진행상태가 평가대기만 저장(공종) 가능합니다");
		return;
	}
	
	var CU = "";             
	var ETPL_NO = "";        
	var ETPL_SEQ = "";       
	var ES_CD_SEL = "";      
	var ES_CD = "";          
	var ES_VER = "";         
	var ES_NM = "";          
	var CSKD_GB = "";        
	var CSKD_GB_NM = "";     
	var GROUP1_CODE = "";    
	var GROUP1_NAME_LOC = "";
	var EVAL_USER_SEL = "";  
	var EVAL_USER_NAMES = "";
	var EVAL_USER_IDS = "";  
	var EVAL_USER_CNT = "";  
	var STATUS = "";         
	var STATUS_TXT = ""; 
	
	var ES_CD2 = "";
	var ES_NM2 = "";
	
	var chkcnt = 0;
    
	if(!checkRows2()) return;
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");
	
	if("C" != LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue()))
	{
		if('<%=info.getSession("ID")%>' != GridObj.cells(click_rowId, GridObj.getColIndexById("ADD_USER_ID")).getValue() 
		 		&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP210200001" 
				&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP150400001" ){
			alert("저장 권한이  없습니다.\r\n\r\n저장 권한자 ( 생성자 , 총무팀장 )");
			return;
		}
	}

	for(var i = 0; i < grid_array2.length; i++)
	{
		chkcnt = 0;
		CU              = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("CU")).getValue();
        ETPL_NO         = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ETPL_NO")).getValue();
        ETPL_SEQ        = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ETPL_SEQ")).getValue();
        ES_CD_SEL       = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ES_CD_SEL")).getValue();
        ES_CD           = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ES_CD")).getValue();
        ES_VER          = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ES_VER")).getValue();
        ES_NM           = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("ES_NM")).getValue();
        CSKD_GB         = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("CSKD_GB")).getValue();
        CSKD_GB_NM      = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("CSKD_GB_NM")).getValue();
        GROUP1_CODE     = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("GROUP1_CODE")).getValue();
        GROUP1_NAME_LOC = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("GROUP1_NAME_LOC")).getValue();
        EVAL_USER_SEL   = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("EVAL_USER_SEL")).getValue();
        EVAL_USER_NAMES = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("EVAL_USER_NAMES")).getValue();
        EVAL_USER_IDS   = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("EVAL_USER_IDS")).getValue();
        EVAL_USER_CNT   = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("EVAL_USER_CNT")).getValue();
        STATUS          = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("STATUS")).getValue();
        STATUS_TXT      = GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("STATUS_TXT")).getValue();
                 
        if("" == ES_CD)
 		{
	 		alert("평가표를 선택하세요.");
	 		return;
 		}
        
        if("" == EVAL_USER_IDS)
 		{
	 		alert("평가자를 선택하세요.");
	 		return;
 		}
        
        for(var j = 1; j <= GridObj2.getRowsNum(); j++)
     	{
	         ES_CD2         = GridObj2.cells(j, GridObj2.getColIndexById("ES_CD")).getValue();        		 
	         ES_NM2         = GridObj2.cells(j, GridObj2.getColIndexById("ES_NM")).getValue();        		 
	    	 
	         if(ES_CD == ES_CD2){
	        	 chkcnt++; 
	         }
	         
	         if( chkcnt > 1){
	        	 alert("동일한 평가표를 저장 할 수 없습니다.\r\n평가표코드 : " + ES_CD2 + "\r\n평가표명 : " + ES_NM2);
	       		 return;
	         }
	        	 
	         /* 
	         if( i != j ){
	        	 ES_CD2         = GridObj2.cells(j, GridObj2.getColIndexById("ES_CD")).getValue();        		 
	        	 ES_NM2         = GridObj2.cells(j, GridObj2.getColIndexById("ES_NM")).getValue();        		 
	        	 if(ES_CD2 == ES_CD)
	         		 {
	         			alert("동일한 평가표를 저장 할 수 없습니다.\r\n평가표코드 : " + ES_CD2 + "\r\n평가표명 : " + ES_NM2);
	         			return;
	         		 }	 
	         }
	            */
     	}
	}

	if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "SELECTED,CU,ETPL_NO,ETPL_SEQ,ES_CD_SEL,ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM,GROUP1_CODE,GROUP1_NAME_LOC,EVAL_USER_SEL,EVAL_USER_NAMES,EVAL_USER_IDS,EVAL_USER_CNT,STATUS,STATUS_TXT,EVAL_USER_NAMES_OLD,EVAL_USER_IDS_OLD,EVAL_USER_CNT_OLD";
		
        var params;
    	params = "?mode=saveEtplDt";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj2, myDataProcessor, "SELECTED", grid_array2);
	    
	    ACT_GB = "EPTLDT_S";
//	    click_rowId2 = null;
	    
    }
}

var click_rowId2 = null;

function GridObj2_doOnRowSelected(rowId,cellInd) {
	var prg_sts_old = GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS_OLD")).getValue();   
	
	click_rowId2 = rowId;
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명	
	var es_cd = SepoaGridGetCellValueId(GridObj2, rowId, "ES_CD");   
	var cu = SepoaGridGetCellValueId(GridObj2, rowId, "CU");   
	
	if(header_name == "ES_CD_SEL" && prg_sts_old == "T" && cu == "C") {
		var url  = '';
		var title  = '';
		var param  = '';
		//window.open("/common/CO_008_ict.jsp?callback=getEvalUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		url    = '/common/CO_020.jsp';
		title  = '평가표선택';
	    param  = 'popup=Y';
		param  += '&callback=getEsCd';
		popUpOpen01(url, title, '650', '450', param);	
	}else if(header_name == "EVAL_USER_SEL" && prg_sts_old == "T") {
		var url  = '';
		var title  = '';
		var param  = '';
		//window.open("/common/CO_008_ict.jsp?callback=getEvalUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		url    = '/common/CO_019.jsp';
		title  = '평가자선택';
	    param  = 'popup=Y';
		param  += '&callback=getEvalUser';
		popUpOpen01(url, title, '450', '550', param);	
	}else if( header_name == "ES_CD" && es_cd != "") {
		var url = "/kr/ev/ts_sheet_view.jsp";
		var param = "";
		param += "?popup_flag_header=true";
		param += "&es_cd="+SepoaGridGetCellValueId(GridObj2, rowId, "ES_CD");
		param += "&es_ver="+SepoaGridGetCellValueId(GridObj2, rowId, "ES_VER");
		PopupGeneral(url+param, "평가상세", "", "", "925", "800");
	}
}

function getEsCd(ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM) {
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).setValue(1);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("ES_CD")).setValue(ES_CD);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("ES_VER")).setValue(ES_VER);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("ES_NM")).setValue(ES_NM);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("CSKD_GB")).setValue(CSKD_GB);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("CSKD_GB_NM")).setValue(CSKD_GB_NM);
}

function getEvalUser(EVAL_USER_IDS,EVAL_USER_NAMES,EVAL_USER_CNT) {
    GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).setValue(1);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("EVAL_USER_IDS")).setValue(EVAL_USER_IDS);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("EVAL_USER_NAMES")).setValue(EVAL_USER_NAMES);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("EVAL_USER_CNT")).setValue(EVAL_USER_CNT);
	//doOnCellChange(1,click_rowId,GridObj.getColIndexById("SELECTED"));
}

function getVendorCode(code, text) {
    GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).setValue(1);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("VENDOR_CODE")).setValue(code);
	GridObj2.cells(click_rowId2, GridObj2.getColIndexById("VENDOR_NAME")).setValue(text);
	
}


function GridObj2_doQueryEnd() {
	var msg        = GridObj2.getUserData("", "message");
	var status     = GridObj2.getUserData("", "status");

	if(status == "false") alert(msg);
	return true;
}

var VENDOR_NAME_ASIS = null;
// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd) {
	var max_value = GridObj2.cells(rowId, cellInd).getValue();
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	} else if(stage==1) {
		if(header_name == "VENDOR_NAME") {
			VENDOR_NAME_ASIS = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VENDOR_NAME")).getValue());
	    }
	} else if(stage==2) {
		if(header_name == "VENDOR_NAME") {
			if( LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VENDOR_NAME")).getValue()) != VENDOR_NAME_ASIS){
				GridObj2.cells(rowId, GridObj2.getColIndexById("VENDOR_CODE")).setValue("");		
			}
	    }
		
	    return true;
	}
	
	return false;    
}

//행추가 이벤트 입니다.
function doAddRowEtplDt()
{
	if(click_rowId == null){
		alert("기숲평가계획을 지정후 행추가 하세요.");
		return;
	}
	   
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		alert("기숲평가계획을 저장후 행추가 하세요.");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS")).getValue() != "T"){
		alert("진행상태가 평가대기만 행추가 가능합니다");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS_OLD")).getValue() != "T"){
		alert("진행상태가 평가대기만 행추가 가능합니다");
		return;
	}
	
	var rowCnt2 = parseInt(GridObj2.getRowsNum());
	dhtmlx_last_row_id = rowCnt2 + 1;
	var nMaxRow2 = dhtmlx_last_row_id;
	
	GridObj2.enableSmartRendering(true);
	GridObj2.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj2.selectRowById(nMaxRow2, false, true);
	GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("SELECTED")).setValue("1");
	GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("CU")).setValue("C");
    GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("ETPL_NO")).setValue(LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("ETPL_NO")).getValue()));
    //GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("CT_NM")).setValue("");
    SepoaGridSetCellValueId(GridObj2, nMaxRow2, "ES_CD_SEL", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    SepoaGridSetCellValueId(GridObj2, nMaxRow2, "EVAL_USER_SEL", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    //SepoaGridSetCellValueId(GridObj2, nMaxRow2, "EVAL_USER", "<img src='/images/icon/icon_search.gif'/>");
    
    
    dhtmlx_before_row_id = nMaxRow2;
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRowEtplDt()
{
	if(click_rowId == null){
		alert("행삭제 대상이 아닙니다.");
		return;
	}
	   
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		alert("행삭제 대상이 아닙니다.");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS")).getValue() != "T"){
		alert("진행상태가 평가대기만 행삭제 가능합니다");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS_OLD")).getValue() != "T"){
		alert("진행상태가 평가대기만 행삭제 가능합니다");
		return;
	}
	
	if(!checkRows2()) return;
	
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");
	var rowcount2 = grid_array2.length;
	GridObj2.enableSmartRendering(false);

	for(var row2 = rowcount2 - 1; row2 >= 0; row2--)
	{		
		if("1" == GridObj2.cells(grid_array2[row2], 0).getValue() && "C" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("CU")).getValue() && "" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("ETPL_SEQ")).getValue())
		{
			GridObj2.deleteRow(grid_array2[row2]);
    	}	
    }	
}

function doDeleteEtplDt()
{
	if(click_rowId == null){
		alert("삭제 대상이 아닙니다.");
		return;
	}
	   
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		alert("삭제 대상이 아닙니다.");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS")).getValue() != "T"){
		alert("진행상태가 평가대기만 삭제 가능합니다");
		return;
	}
	
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("PRG_STS_OLD")).getValue() != "T"){
		alert("진행상태가 평가대기만 삭제 가능합니다");
		return;
	}
	
	if('<%=info.getSession("ID")%>' != GridObj.cells(click_rowId, GridObj.getColIndexById("ADD_USER_ID")).getValue() 
	 		&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP210200001" 
			&& '<%=info.getSession("MENU_PROFILE_CODE")%>' !=  "MUP150400001" ){
		alert("삭제 권한이  없습니다.\r\n\r\n삭제권한자 ( 생성자 , 총무팀장 )");
		return;
	}
	
	if(!checkRows2()) return;
	
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");
	
	
	var rowcount2 = grid_array2.length;
	GridObj2.enableSmartRendering(false);
	
	for(var row2 = rowcount2 - 1; row2 >= 0; row2--)
	{		
		if("C" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("CU")).getValue() && "" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("ETPL_SEQ")).getValue())
		{
			alert("행삭제를 하세요.");
			return;
    	}
		
		if("C" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("CU")).getValue())
		{
			alert("삭제 대상이 아닙니다.");
			return;
    	}
    }
	
	if(rowcount2 > 1)  {
		alert(G_MSS2_SELECT);		
		return;
	}
	
   	if (confirm("삭제하시겠습니까?")){
   	    // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
	    var cols_ids = "SELECTED,CU,ETPL_NO,ETPL_SEQ,ES_CD_SEL,ES_CD,ES_VER,ES_NM,CSKD_GB,CSKD_GB_NM,GROUP1_CODE,GROUP1_NAME_LOC,EVAL_USER_SEL,EVAL_USER_NAMES,EVAL_USER_IDS,EVAL_USER_CNT,STATUS,STATUS_TXT,EVAL_USER_NAMES_OLD,EVAL_USER_IDS_OLD,EVAL_USER_CNT_OLD";
		
        var params;
    	params = "?mode=deleteEtck";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj2, myDataProcessor, "SELECTED", grid_array2);
		
		ACT_GB = "EPTLDT_D";
//	    click_rowId2 = null;
   }
}

function SP9113_Popup( type ) {
	if( type == "add_user_id" ) {
		window.open("/common/CO_008.jsp?callback=eval_callback", "SP9114", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}
}

function  eval_callback(id, name) {
	form1.add_user_id.value     = id;
	form1.add_user_name.value   = name;
}

//지우기
function doRemove( type ){
    if( type == "add_user_id" ) {
    	document.forms[0].add_user_id.value = "";
        document.forms[0].add_user_name.value = "";
    }
}

function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doSelect();
    }
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onload="Init();">
<s:header>
<%
	if("".equals(gate)){
%>
	<%@ include file="/include/sepoa_milestone.jsp" %>
<%
	}
%>
	<form name="form1">
	    <input type="hidden" name="ETPL_NO"		id="ETPL_NO">
		
	    
		<%-- input type="hidden" name="item_no" id="item_no" --%>		
		<input type="hidden" name="BIZ_NO"		id="BIZ_NO">
		<input type="hidden" name="BID_NO"		id="BID_NO">
		<input type="hidden" name="BID_COUNT"	id="BID_COUNT">
		<input type="hidden" name="VOTE_COUNT"	id="VOTE_COUNT">
		<input type="hidden" name="SCR_FLAG"					value="">
		<%-- input type="hidden" name="BID_TYPE_C"	id="BID_TYPE_C"	value="D" --%>
		
		<input type="hidden" name="CU"		        id="CU">
		<input type="hidden" name="PUM_NO"		    id="PUM_NO">
		<input type="hidden" name="ANN_NO"		    id="ANN_NO">
		<input type="hidden" name="CT_NM"	        id="CT_NM">
		<input type="hidden" name="VENDOR_CODE"	    id="VENDOR_CODE">
		<input type="hidden" name="VENDOR_NAME"	id="VENDOR_NAME">
		<input type="hidden" name="BIZ_SEQ"	        id="BIZ_SEQ">
		<input type="hidden" name="MATERIAL_CLASS1"	id="MATERIAL_CLASS1">
		<input type="hidden" name="MATERIAL_CLASS2"	id="MATERIAL_CLASS2">
		<input type="hidden" name="MATERIAL_CLASS1_LOC"	id="MATERIAL_CLASS1_LOC">
		<input type="hidden" name="MATERIAL_CLASS2_LOC"	id="MATERIAL_CLASS2_LOC">
		
		<input type="hidden" name="CT_USER_ID"	    id="CT_USER_ID">
		<input type="hidden" name="CT_USER_NAME"	id="CT_USER_NAME">		
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">									
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;평가년도</td>
										<td width="35%" class="data_td" >
											<select id="p_year" name="p_year_start">
												<option value="">전체</option>
											</select>																		
										</td>    						
										<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 생성자</td>      	
								      	<td class="data_td" >
									        <b><input type="text" name="add_user_id" id="add_user_id" style="ime-mode:inactive" size="15" class="inputsubmit" onkeydown='entKeyDown()'>
									        <a href="javascript:SP9113_Popup('add_user_id');"><img src="/images/ico_zoom.gif" align="absmiddle" border="0"></a>
									        <a href="javascript:doRemove('add_user_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
									        <input type="text" name="add_user_name" id="add_user_name" size="20" readOnly onkeydown='entKeyDown()'></b>
									    </td>								    									    									    								
									</tr>																								
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="10"></TD>
			</TR>
		</TABLE>	
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="15" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD><script language="javascript">btn("javascript:doSelect()","조회 (계획)");</script></TD>
							<td><script language="javascript">btn("javascript:doSaveEtpl()","저장 (계획)")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteEtpl()","삭제 (계획) ")</script></td>
							<td><script language="javascript">btn("javascript:doAddRowEtpl()","행삽입")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteRowEtpl()","행삭제")</script></td>							
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>	
<s:grid screen_id="EV_006" height="250px"/>
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="10"></TD>
	</TR>
</TABLE>	
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
			    <TD height="15" align="right">
					<TABLE cellpadding="0">
						<TR>
							<td><script language="javascript">btn("javascript:doSaveEtplDt()","저장 (공종)")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteEtplDt()","삭제 (공종)")</script></td>
							<td><script language="javascript">btn("javascript:doAddRowEtplDt()","행삽입")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteRowEtplDt()","행삭제")</script></td>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>	
<s:grid screen_id="EV_007" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="400px"/>
</form>
</s:header>

<s:footer/>
</body>
</html>