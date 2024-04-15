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
	multilang_id.addElement("I_RQ_442");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_RQ_442";
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

<% String WISEHUB_PROCESS_ID="I_RQ_442";%>

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

var INDEX_SELECTED        ;
var INDEX_BIZ_NO          ;
var INDEX_BIZ_NM          ;
var INDEX_BIZ_STATUS      ;
var INDEX_ADD_USER_ID     ;
var INDEX_ADD_USER_NAME   ;
var INDEX_ADD_DATE        ;
var INDEX_ADD_TIME        ;
var INDEX_CHANGE_USER_ID  ;
var INDEX_CHANGE_USER_NAME;
var INDEX_CHANGE_DATE     ;
var INDEX_CHANGE_TIME     ;
var INDEX_BIZ_STATUS_OLD  ;

function Init()
{
	setGridDraw();
	setHeader();

	// GridObj.setColHidden("0|1|2|3|4",false);
	
	
    // 2011.3.28 정민석  기본 조회 조건을 대분류-상품으로 조회
    //form1.MATERIAL_TYPE.value = "HW";
    //doSelect();
    var dept = "<%=dept%>";
    /*
    if(dept == "CBE"){
    	document.form1.ITEM_GROUP.value = "2";
	} else if(dept == "CBD"){
    	document.form1.ITEM_GROUP.value = "1";
	} else {
    	document.form1.ITEM_GROUP.value = "3";
	}
	*/	
<%--    INTEGRATED_BUY_change(); --%>
}

function setHeader()
{
	INDEX_SELECTED                                =   GridObj.GetColHDIndex("SELECTED");
	INDEX_BIZ_NO                                  =   GridObj.GetColHDIndex("BIZ_NO");
	INDEX_BIZ_NM                                  =   GridObj.GetColHDIndex("BIZ_NM");
	INDEX_BIZ_STATUS                              =   GridObj.GetColHDIndex("BIZ_STATUS");
	INDEX_ADD_USER_ID                             =   GridObj.GetColHDIndex("ADD_USER_ID");
	INDEX_ADD_USER_NAME                           =   GridObj.GetColHDIndex("ADD_USER_NAME");
	INDEX_ADD_DATE                                =   GridObj.GetColHDIndex("ADD_DATE");
	INDEX_ADD_TIME                                =   GridObj.GetColHDIndex("ADD_TIME");
	INDEX_CHANGE_USER_ID                          =   GridObj.GetColHDIndex("CHANGE_USER_ID");
	INDEX_CHANGE_USER_NAME                        =   GridObj.GetColHDIndex("CHANGE_USER_NAME");
	INDEX_CHANGE_DATE                             =   GridObj.GetColHDIndex("CHANGE_DATE");
	INDEX_CHANGE_TIME                             =   GridObj.GetColHDIndex("CHANGE_TIME");	
	INDEX_BIZ_STATUS_OLD                          =   GridObj.GetColHDIndex("BIZ_STATUS");
}

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.dt.rfq.rfq_bz_ins_ict";

function doSelect()
{
	var add_date_start      = LRTrim(form1.add_date_start.value);
	var add_date_end        = LRTrim(form1.add_date_end.value);
/*
	if (add_date_start != "" || add_date_end != "") {
		if ((add_date_start == "") || (add_date_end == "")) {
			alert("생성일자를 확인하세요.");
			return;
		}
	}
*/
<%--     servletUrl =  "<%=getWiseServletPath("master.pbc.real_bd_lis1") %>"; --%>
   
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getRfqBzList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
    
   /*  GridObj.SetParam("ITEM_NO", ITEM_NO);
    GridObj.SetParam("MATERIAL_TYPE", MATERIAL_TYPE);
    GridObj.SetParam("MATERIAL_CTRL_TYPE", MATERIAL_CTRL_TYPE);
    GridObj.SetParam("MATERIAL_CLASS1", MATERIAL_CLASS1);
    GridObj.SetParam("MATERIAL_CLASS2", MATERIAL_CLASS2);
    GridObj.SetParam("MAKER_CODE", MAKER_CODE);
    GridObj.SetParam("MODEL_NO", MODEL_NO);
    GridObj.SetParam("INTEGRATED_BUY_FLAG", "");
    GridObj.SetParam("COMPANY_CODE", "");
    GridObj.SetParam("CERTIFICATION", CERTIFICATION);
    GridObj.SetParam("SYNONYM_NAME", "");
	GridObj.SetParam("UNIT_PRICE", "");
	GridObj.SetParam("ITEM_BLOCK_FLAG", ITEM_BLOCK_FLAG);
	GridObj.SetParam("DESCRIPTION_LOC", DESCRIPTION_LOC);
	GridObj.SetParam("add_date_start",  add_date_start);
	GridObj.SetParam("add_date_end",    add_date_end);

    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl);
    GridObj.strHDClickAction="sortmulti"; */
    
    

}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
	var max_row = GridObj.GetRowCount();
	var maxcol  = GridObj.GetColCount();

    if(msg3 == INDEX_SELECTED)
    {
        oneSelect(max_row, msg1, msg2);
    }
}

function oneSelect(max_row, msg1, msg2)
{
    var noSelect = "";
    if(msg1 != "t_header" && GD_GetCellValueIndex(GridObj,msg2,INDEX_SELECTED) == "false") noSelect = "Y";
    for(var i=0;i<max_row;i++)  {
        GD_SetCellValueIndex(GridObj,i,INDEX_SELECTED,"false", "&");
    }
    if(msg1 != "t_header" && noSelect != "Y") GD_SetCellValueIndex(GridObj,msg2,INDEX_SELECTED,"true", "&");
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

function add_date_start(year,month,day,week) {
  		document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
  		document.form1.add_date_end.value=year+month+day;
}



<%-- 
function SP9053_Popup() {
	var left = 0;
	var top = 0;
	var width = 540;
	var height = 500;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'yes';
	var scrollbars = 'no';
	var resizable = 'no';
	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0278&function=selectCode&values=<%=info.getSession("HOUSE_CODE")%>&values=M199&values=&values=/&desc=코드&desc=이름";
	//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	CodeSearchCommon(url, 'doc', left, top, width, height);

    //var url = "/s_kr/admin/info/hico_code_search_pop.jsp?title=제조사 Code 검색&type=M199";
	//window.open( url, 'Category', 'left=50, top=100, width=500, height=450, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=no');
}
function selectCode( maker_code, maker_name) {
	document.form1.maker_name.value 	= maker_name;
	document.form1.maker_code.value 	= maker_code;
}
--%>

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
	
var gRowId;

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
    
    /*
    if(cellInd == INDEX_ITEM_NO) {
    	var ITEM_NO = GridObj.cells(rowId, INDEX_ITEM_NO).getValue()		//GD_GetCellValueIndex(GridObj,rowId,INDEX_ITEM_NO);
        width = 750;
        height = 550;
        
        if("C" == GridObj.cells(rowId, GridObj.getColIndexById("CRUD")).getValue() && ITEM_NO == ""){
        	var url = "/kr/catalog/cat_pp_lis_main.jsp?isSingle=Y";
        	gRowId = rowId;
        } else {
        	var MATERIAL_TYPE      = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_TYPE")).getValue();
        	var MATERIAL_CTRL_TYPE = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CTRL_TYPE")).getValue();
        	var MATERIAL_CLASS1    = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CLASS1")).getValue();
        	var MATERIAL_CLASS2    = GridObj.cells(rowId, GridObj.getColIndexById("MATERIAL_CLASS2")).getValue();
        	
        	var url;
        	        	
        	if( MATERIAL_TYPE == "03"){ //홍보물
        		if( MATERIAL_CTRL_TYPE == "03091" ){ // 안내장
        			url = "http://barcode.woorifg.com/StckMgr/SRU/SRIF0001_PopImage.aspx?Name=" + ITEM_NO 
        		}else if( MATERIAL_CTRL_TYPE == "03092" ){ // e-홍보물
        			//자동화기기홍모물
        			if( MATERIAL_CLASS1 == "03092099" ){
        				url = "http://wpms.woorifg.com/PR/Common/a_CommDownload.aspx?Name=" + ITEM_NO 
        			}else{
        				url = "http://wpms.woorifg.com/PR/Common/CommImgWriter.aspx?FLAG=2&Name=" + ITEM_NO
        			}
        		}       		
        	}        	
        }
        
        var PoDisWin =window.open(url, 'ItemCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
        PoDisWin.focus();
        
        
    }else
    */
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
        //doQuery();
        doSelect();
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


function doSave()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
	{
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BIZ_NM")).getValue()))
		{
			alert("사업명을 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BIZ_STATUS")).getValue()))
		{
			alert("진행상태를 선택하세요.");
			return;
		}
	}

    if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "<%=grid_col_id%>";
        
        var params;
    	params = "?mode=save";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
    }
}


function doDelete()
{
	if(!checkRows())
			return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);
	
	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			alert("행삭제를 하세요.");
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
    	params = "?mode=delete";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
   }
}

//행추가 이벤트 입니다.
function doAddRow()
{
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRUD")).setValue("C");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("DEPARTMENT"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DEPT_NAME_LOC")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("DEPARTMENT_NAME_LOC"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ITEM_NO")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRE_GB_TXT")).setValue("수기입력");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CRE_GB")).setValue("2");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("DSTR_GB")).setValue("2");
    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_USER_ID")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("ID"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_USER_NAME_LOC")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("NAME_LOC"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_DATE")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("STK_TIME")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("NTC_YN")).setValue("N");    
    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("NTC_YN")).setValue("N");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ABOL_YN")).setValue("N");
	
	dhtmlx_before_row_id = nMaxRow2;
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRow()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	var rowcount = grid_array.length;
	GridObj.enableSmartRendering(false);

	for(var row = rowcount - 1; row >= 0; row--)
	{		
		if("1" == GridObj.cells(grid_array[row], 0).getValue() && "C" == GridObj.cells(grid_array[row], GridObj.getColIndexById("CRUD")).getValue())
		{
			GridObj.deleteRow(grid_array[row]);
    	}
    }
}

function  setBIZNO(biz_no, biz_nm) {
    document.forms[0].biz_no.value = biz_no;
    document.forms[0].biz_nm.value = biz_nm;
}

function getBIZ_pop() {
    var url = "/ict/kr/dt/rfq/rfq_bzNo_pop_main.jsp";
    Code_Search(url,'사업명','0','0','500','500');
    
    //url, title, left, top, width, height
}

function doRemove( type ){
    if( type == "biz_no" ) {
    	document.forms[0].biz_no.value = "";
        document.forms[0].biz_nm.value = "";
    }  
}

function getCtrlBiz(code, text) {
	document.forms[0].biz_no.value = code;
    document.forms[0].biz_nm.value = text;
}

function PopupManager(part){
	var wise = GridObj;
	var url  = "";
	
	if(part == "biz_no") {
		//window.open("/common/CO_017_ict.jsp?callback=getCtrlBiz", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		
		url    = '/common/CO_017_ict.jsp';
		var title  = '사업명조회';
		var param  = 'popup=Y';
		param     += '&callback=getCtrlBiz';
		popUpOpen01(url, title, '450', '550', param);	
		
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
		<input type="hidden" name="item_no" id="item_no">
		
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등록일자</td>
										<td width="35%" class="data_td" >
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>    						
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상태</td>
    									<td width="35%" class="data_td">
        									<select name="biz_status" id="biz_status" class="inputsubmit">
                                            <option value="" selected="selected">전체</option>
<%
	String listbox1 = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M660_ICT", "");
	out.println(listbox1);
%>          										     										
        									</select>
    									</td>    									    									    									    								
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>		
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명 / 사업번호</td>
										<td width="35%" class="data_td" colspan="3">
											<input type="text" name="txt_biz_nm" id="biz_nm" size="20">
											<a href="javascript:PopupManager('biz_no');">
												<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
											</a>
											<a href="javascript:doRemove('biz_no')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>	
											<input type="text" name="txt_biz_no" id="biz_no" size="20">											
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
				<TD height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
<script language="javascript">
btn("javascript:doSelect()","조 회");
</script>
							</TD>
<td><script language="javascript">btn("javascript:doSave()","저장")</script></td>
<td><script language="javascript">btn("javascript:doDelete()","삭제")</script></td>
<td><script language="javascript">btn("javascript:doAddRow()","행삽입")</script></td>
<td><script language="javascript">btn("javascript:doDeleteRow()","행삭제")</script></td>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_RQ_442" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
<iframe name="xWork" width="0" height="0" border="0"></iframe>
<iframe name="getDescframe" width="0" height="0" border="0"></iframe>
</body>
</html>