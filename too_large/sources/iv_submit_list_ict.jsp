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
	multilang_id.addElement("I_IV_001");
	multilang_id.addElement("I_IV_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_IV_001";
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

<% String WISEHUB_PROCESS_ID="I_IV_001";%>

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
	GridObj2_setGridDraw();
	GridObj.setSizes();
	GridObj2.setSizes();
}

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.ct_submit_list_ict";

function doSelect()
{
	var add_date_start      = LRTrim(form1.add_date_start.value);
	var add_date_end        = LRTrim(form1.add_date_end.value);
   
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getCtBzList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.postGrid( G_SERVLETURL, params );
    GridObj.clearAll(false);	
    
    click_rowId = null;
    click_rowId2 = null;
}

function doSaveBZ()
{
	if(!checkRows()) return;
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	for(var i = 0; i < grid_array.length; i++)
	{
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PUM_NO")).getValue()))
		{
			alert("품의번호를 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BIZ_NM")).getValue()))
		{
			alert("사업명을 입력하세요.");
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
    	params = "?mode=saveBZ";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	    
	    ACT_GB = "BZ_S";
	    click_rowId = null;
	    click_rowId2 = null;
    }
}

function doDeleteBZ()
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
    	params = "?mode=deleteBZ";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
		 
		ACT_GB = "BZ_D";
		click_rowId = null;
		click_rowId2 = null;
   }
}

//행추가 이벤트 입니다.
function doAddRowBZ()
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
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("PUM_NO")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_NO")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_NM")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CT_USER_ID")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("CT_USER_NAME")).setValue("");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("BIZ_STATUS")).setValue("E");
    SepoaGridSetCellValueId(GridObj, nMaxRow2, "CT_USER", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADD_USER_ID")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("ID"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADD_USER_NAME")).setValue("<%=JSPUtil.nullToEmpty(info.getSession("NAME_LOC"))%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADD_DATE")).setValue("<%=SepoaDate.getShortDateString()%>");
    GridObj.cells(nMaxRow2, GridObj.getColIndexById("ADD_TIME")).setValue("<%=SepoaDate.getShortTimeString()%>");
    
    dhtmlx_before_row_id = nMaxRow2;
    
	click_rowId = nMaxRow2;
	GridObj2.clearAll();
	
	
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRowBZ()
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

function add_date_start(year,month,day,week) {
  		document.form1.add_date_start.value=year+month+day;
}

function add_date_end(year,month,day,week) {
  		document.form1.add_date_end.value=year+month+day;
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
    /*
    if(click_rowId != rowId && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() != "C"){
	    var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
	    document.forms[0].BIZ_NO.value = biz_no;
		var params = "mode=getCtResultList";
		params += "&biz_no=" + biz_no;
		var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj2.postGrid( G_SERVLETURL, params );
		GridObj2.clearAll(false); 	   	 	   	 
    }
    */
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
    
	if( GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		GridObj2.clearAll(); 	 
    }
	
    if( click_rowId != rowId && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() != "C"){
	    var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
	    document.forms[0].BIZ_NO.value = biz_no;
		var params = "mode=getIvResultList";
		params += "&biz_no=" + biz_no;
		var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,IV_ATTACH_NO,IV_DATE_TIME,IV_ATTACH_VIEW,IV_ATTACH_CNT,IV_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		GridObj2.postGrid( G_SERVLETURL, params );
		GridObj2.clearAll(false);
		
		var f = document.forms[0];
		f.CT_USER_ID.value                = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
		f.CT_USER_NAME.value              = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();		
    }
	click_rowId = rowId;
    if(header_name == "CT_USER") {
		//var i_company_code = "WOORI";
       	
		//var i_company_code = SepoaGridGetCellValueId(GridObj, rowId, "COMPANY_CODE");
       	//var gubun          = SepoaGridGetCellValueId(GridObj, rowId, "GUBUN");

       	//if(gubun == "U") {
	    //  alert("생성시에만 하실 수 있습니다.");
		//	return false;
		//}
       	
		//window.open("duty_user_transform.jsp?popup_flag=true&i_company_code="+i_company_code, "pop_up","status=yes, resizable=yes width=800 height=470");
		
		
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

function getCtrlUser(code, text) {
    GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	GridObj.cells(click_rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_ID")).setValue(code);
	GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_NAME")).setValue(text);
	//doOnCellChange(1,click_rowId,GridObj.getColIndexById("SELECTED"));
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
    	/*
    	if(header_name == "SELECTED" && GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).getValue() == "1" && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() != "C"){
    	    var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, rowId, "BIZ_NO")));
    	    document.forms[0].BIZ_NO.value = biz_no;
    		var params = "mode=getCtResultList";
    		params += "&biz_no=" + biz_no;
    		var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
    		params += "&cols_ids=" + cols_ids;
    		params += dataOutput();
    		GridObj2.postGrid( G_SERVLETURL, params );
    		GridObj2.clearAll(false); 	    	
    		click_rowId = rowId;
    		
    		var f = document.forms[0];
    		f.CT_USER_ID.value                = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
    		f.CT_USER_NAME.value              = GridObj.cells(rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();    		    	
        }
    	
    	if(header_name == "SELECTED" && GridObj.cells(rowId, GridObj.getColIndexById("SELECTED")).getValue() == "1" && GridObj.cells(rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
    		GridObj2.clearAll(); 	 
        }
    	*/
    	
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
		if(ACT_GB == "BZ_S" || ACT_GB == "BZ_D"){
			doSelect();	
		}else if(ACT_GB == "CT_S" || ACT_GB == "CT_D"){
			var biz_no = encodeUrl(LRTrim(SepoaGridGetCellValueId(GridObj, click_rowId, "BIZ_NO")));
		    document.forms[0].BIZ_NO.value = biz_no;
			var params = "mode=getIvResultList";
			params += "&biz_no=" + biz_no;
			var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,IV_ATTACH_NO,IV_DATE_TIME,IV_ATTACH_VIEW,IV_ATTACH_CNT,IV_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
			params += "&cols_ids=" + cols_ids;
			params += dataOutput();
			GridObj2.postGrid( G_SERVLETURL, params );
			GridObj2.clearAll(false);
			
			var f = document.forms[0];
			f.CT_USER_ID.value                = GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_ID")).getValue();
			f.CT_USER_NAME.value              = GridObj.cells(click_rowId, GridObj.getColIndexById("CT_USER_NAME")).getValue();		
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

function doSaveCT()
{
	if(!checkRows2()) return;
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");

	for(var i = 0; i < grid_array2.length; i++)
	{
		if("" == LRTrim(GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("CT_NM")).getValue()))
		{
			alert("계약명을 입력하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("VENDOR_CODE")).getValue()))
		{
			alert("계약업체를 선택하세요.");
			return;
		}
		/*
		if("" == LRTrim(GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("MATERIAL_CLASS1")).getValue()))
		{
			alert("품목군(대)를 선택하세요.");
			return;
		}
		
		if("" == LRTrim(GridObj2.cells(grid_array2[i], GridObj2.getColIndexById("MATERIAL_CLASS2")).getValue()))
		{
			alert("품목군(중)을  선택하세요.");
			return;
		}
		*/
	}

	if (confirm("저장 하시겠습니까?")) {
        // dataProcess를 생성 시점에는 반드시 col_ids값을 보내야마 하며 다국어 지원으로 인하여
        // encodeUrl() 함수를 사용 하셔야 합니다.
    	// sepoa_scripts.jsp에서 공통함수를 호출 합니다.
	    // 인자값은 그리드객체, 데이터프로세스객체, SELECTED 필드아이디 값입니다.
        var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,IV_ATTACH_NO,IV_DATE_TIME,IV_ATTACH_VIEW,IV_ATTACH_CNT,IV_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
		
        var params;
    	params = "?mode=saveCT";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
	    sendTransactionGrid(GridObj2, myDataProcessor, "SELECTED", grid_array2);
	    
	    ACT_GB = "CT_S";
	    //click_rowId = null;
	    click_rowId2 = null;
	    
    }
}

var click_rowId2 = null;

function GridObj2_doOnRowSelected(rowId,cellInd) {
	
	click_rowId2 = rowId;
	var header_name = GridObj2.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if(header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());      
		var ann_version = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_TYPE")).getValue());
		
		var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'800','900');
    }else if(header_name == "ANN_ITEM"){
    	
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());     
        var vote_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VOTE_COUNT")).getValue());     
        //url =  "bd_open_compare_pop_ict.jsp?BID_NO="+bid_no+"&BID_COUNT="+bid_count+"&VOTE_COUNT="+vote_count;
        //doOpenPopup(url,'1100','700');
        
        var url    = '/ict/sourcing/bd_open_compare_pop_ict.jsp';
		var title  = '개찰결과';
		var param  = 'popup=Y';
		param     += '&BID_NO=' + bid_no;
		param     += '&BID_COUNT=' + bid_count;
		param     += '&VOTE_COUNT=' + vote_count;
		popUpOpen01(url, title, '1100', '700', param);   
        
    } else if(header_name == "VENDOR_NAME") {
    	
		var vendor_code = SepoaGridGetCellValueId(GridObj2, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/ict/s_kr/admin/info/ven_bd_con_ict.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
    }else if( GridObj2.getColIndexById("VENDOR_COUNT") == cellInd || GridObj2.getColIndexById("VENDOR_COUNT2") == cellInd || GridObj2.getColIndexById("VENDOR_COUNT3") == cellInd){
        var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_COUNT")).getValue());          	
        var vote_count = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("VOTE_COUNT")).getValue());          	
        
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].VOTE_COUNT.value = vote_count; 
	
        var url = "bd_pp_dis_ict.jsp?BID_NO=" + bid_no + "&BID_COUNT=" + bid_count + "&VOTE_COUNT=" + vote_count ;
		doOpenPopup(url,'800','350');
	}else if(header_name == "VENDOR") {
		//var i_company_code = "WOORI";
       	
		//var i_company_code = SepoaGridGetCellValueId(GridObj, rowId, "COMPANY_CODE");
       	//var gubun          = SepoaGridGetCellValueId(GridObj, rowId, "GUBUN");

       	//if(gubun == "U") {
	    //  alert("생성시에만 하실 수 있습니다.");
		//	return false;
		//}
       	
		//window.open("duty_user_transform.jsp?popup_flag=true&i_company_code="+i_company_code, "pop_up","status=yes, resizable=yes width=800 height=470");
		
		var bid_no = LRTrim(GridObj2.cells(rowId, GridObj2.getColIndexById("BID_NO")).getValue());   
        
		if( bid_no == ""){
			var url  = '';
			var title  = '';
			var param  = '';
			//window.open("/common/CO_008_ict.jsp?callback=getCtrlUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");		
			url    = '/common/CO_014_ict.jsp';
			title  = '계약업체조회';
		    param  = 'popup=Y';
			param  += '&callback=getVendorCode';
			popUpOpen01(url, title, '450', '550', param);
		}
	}else if(header_name == "CT_ATTACH_NO"){
   	 	var attach_no = GridObj2.cells(rowId, GridObj2.getColIndexById("CT_ATTACH_NO_H")).getValue();
   	    //var attach_cnt = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_CNT")).getValue();
   	 	if(attach_no != ""){
   			var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
       	 	var b = "fileDown";
       	 	var c = "300";
       	 	var d = "100";
       	 
       	 	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
   	 	}
    }else if(header_name == "IV_ATTACH_NO"){
   	 	var attach_no = GridObj2.cells(rowId, GridObj2.getColIndexById("IV_ATTACH_NO_H")).getValue();
   	    //var attach_cnt = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_CNT")).getValue();
   	 	if(attach_no != ""){
   			var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
       	 	var b = "fileDown";
       	 	var c = "300";
       	 	var d = "100";
       	 
       	 	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
   	 	}
    }

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
// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
function GridObj2_doOnCellChange(stage,rowId,cellInd) {
	var max_value = GridObj2.cells(rowId, cellInd).getValue();
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	} else if(stage==1) {
	} else if(stage==2) {
	    return true;
	}
	
	return false;    
}

//행추가 이벤트 입니다.
function doAddRowCT()
{
	if(click_rowId == null){
		alert("사업명을 지정후 행추가 하세요.");
		return;
	}
	   
	if(GridObj.cells(click_rowId, GridObj.getColIndexById("CU")).getValue() == "C"){
		alert("사업명을 저장후 행추가 하세요.");
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
    GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("PUM_NO")).setValue(LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("PUM_NO")).getValue()));
    GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("CT_NM")).setValue("");
    SepoaGridSetCellValueId(GridObj2, nMaxRow2, "VENDOR", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    GridObj2.cells(nMaxRow2, GridObj2.getColIndexById("BIZ_NO")).setValue(LRTrim(GridObj.cells(click_rowId, GridObj.getColIndexById("BIZ_NO")).getValue()));
    
    dhtmlx_before_row_id = nMaxRow2;
}

//행삭제시 호출 되는 함수 입니다.
function doDeleteRowCT()
{
	if(!checkRows2()) return;
	
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");
	var rowcount2 = grid_array2.length;
	GridObj2.enableSmartRendering(false);

	for(var row2 = rowcount2 - 1; row2 >= 0; row2--)
	{		
		if("1" == GridObj2.cells(grid_array2[row2], 0).getValue() && "C" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("CU")).getValue() && "" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("BID_NO")).getValue())
		{
			GridObj2.deleteRow(grid_array2[row2]);
    	}
    }	
}

function doDeleteCT()
{
	if(!checkRows2())
			return;
	var grid_array2 = getGridChangedRows(GridObj2, "SELECTED");
	
	
	var rowcount2 = grid_array2.length;
	GridObj2.enableSmartRendering(false);
	
	for(var row2 = rowcount2 - 1; row2 >= 0; row2--)
	{		
		if("C" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("CU")).getValue() && "" == GridObj2.cells(grid_array2[row2], GridObj2.getColIndexById("BID_NO")).getValue())
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
	    var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,IV_ATTACH_NO,IV_DATE_TIME,IV_ATTACH_VIEW,IV_ATTACH_CNT,IV_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
		
        var params;
    	params = "?mode=deleteCT";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    	
		sendTransactionGrid(GridObj2, myDataProcessor, "SELECTED", grid_array2);
		
		ACT_GB = "CT_D";
	    //click_rowId = null;
	    click_rowId2 = null;
   }
}

function doSubmitIV() { 
    var chkcnt = 0;

    var grid_array = getGridChangedRows( GridObj2, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
    var cols_ids = "SELECTED,CU,PUM_NO,ANN_NO,VOTE_COUNT,CT_NM,VENDOR_CODE,VENDOR,VENDOR_NAME,SETTLE_AMT,CT_ATTACH_NO,CT_DATE_TIME,CT_ATTACH_VIEW,CT_ATTACH_CNT,CT_ATTACH_NO_H,IV_ATTACH_NO,IV_DATE_TIME,IV_ATTACH_VIEW,IV_ATTACH_CNT,IV_ATTACH_NO_H,BID_NO,BID_COUNT,ANN_VERSION,BID_TYPE,BIZ_NO,BIZ_SEQ,MATERIAL_CLASS1,MATERIAL_CLASS2";
	
    for( var i = 0; i < grid_array.length; i++ ) {
            chkcnt++; 
			
            CU                  = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("CU")).getValue();
            BIZ_NO              = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("BIZ_NO")).getValue();
            BIZ_SEQ             = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("BIZ_SEQ")).getValue();
            BID_NO              = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("BID_NO")).getValue();            
            BID_COUNT           = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("BID_COUNT")).getValue();
            VOTE_COUNT          = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("VOTE_COUNT")).getValue();            
            PUM_NO              = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("PUM_NO")).getValue();
            ANN_NO              = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("ANN_NO")).getValue();
            CT_NM               = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("CT_NM")).getValue();
            VENDOR_CODE         = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("VENDOR_CODE")).getValue();
            VENDOR_NAME         = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("VENDOR_NAME")).getValue();
            MATERIAL_CLASS1     = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("MATERIAL_CLASS1")).getValue();
            MATERIAL_CLASS2     = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("MATERIAL_CLASS2")).getValue();    
            MATERIAL_CLASS1_LOC = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("MATERIAL_CLASS1")).getText();
            MATERIAL_CLASS2_LOC = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("MATERIAL_CLASS2")).getText();
            
            CT_ATTACH_NO_H      = GridObj2.cells(grid_array[i], GridObj2.getColIndexById("CT_ATTACH_NO_H")).getValue();        
	} // for문끝
	if(chkcnt == 0){
	    alert(G_MSS1_SELECT);
	    return;
	}
	if(chkcnt != 1){
	    alert(G_MSS2_SELECT);
	    return;
	}
	
	if("C" == CU)
	{
		alert("계약서 업로드 후 진행바랍니다.");
		return;
	}
	if("" == CT_ATTACH_NO_H)
	{
		alert("계약서 업로드 후 진행바랍니다.");
		return;
	}
	
	/*
	if("" == CT_NM)
	{
		alert("계약명을 입력하세요.");
		return;
	}
	
	if("" == VENDOR_CODE)
	{
		alert("계약업체를 선택하세요.");
		return;
	}
	*/
	
	/*
	if("" == MATERIAL_CLASS1)
	{
		alert("품목군(대)를 선택하세요.");
		return;
	}
	
	if("" == MATERIAL_CLASS2)
	{
		alert("품목군(중)을  선택하세요.");
		return;
	}
	*/

	var f = document.forms[0];
	f.CU.value                = CU             ;
	f.BIZ_NO.value            = BIZ_NO         ;
	f.BIZ_SEQ.value           = BIZ_SEQ        ;
	f.BID_NO.value            = BID_NO         ;
	f.BID_COUNT.value         = BID_COUNT      ;
	f.VOTE_COUNT.value        = VOTE_COUNT     ;
	f.PUM_NO.value            = LRTrim(PUM_NO)         ;
	f.ANN_NO.value            = ANN_NO         ;
	f.CT_NM.value             = LRTrim(CT_NM)          ;
	f.VENDOR_CODE.value       = VENDOR_CODE    ;
	f.VENDOR_NAME.value   = VENDOR_NAME;
	f.MATERIAL_CLASS1.value   = MATERIAL_CLASS1;
	f.MATERIAL_CLASS2.value   = MATERIAL_CLASS2;
	f.MATERIAL_CLASS1_LOC.value   = MATERIAL_CLASS1_LOC;
	f.MATERIAL_CLASS2_LOC.value   = MATERIAL_CLASS2_LOC;
	
	
	f.target                   = "_self"; 
	f.method                   = "post";   
	f.action = "iv_submit_insert_ict.jsp";
	f.submit();
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
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;등록일자</td>
										<td width="35%" class="data_td" >
											<s:calendar id="add_date_start" default_value="<%=SepoaString.getDateSlashFormat(from_date) %>" format="%Y/%m/%d"/>
											~
											<s:calendar id="add_date_end" default_value="<%=SepoaString.getDateSlashFormat(to_date) %>" format="%Y/%m/%d"/>
										</td>    						
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품의번호</td>
    									<td width="35%" class="data_td">
        									<input type="text" name="txt_pum_no" id="pum_no" size="20">
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
				<TD height="10"></TD>
			</TR>
		</TABLE>	
		<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
			<TR>
				<TD height="15" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD><script language="javascript">btn("javascript:doSelect()","조 회 (사업)");</script></TD>
							<%--
							<td><script language="javascript">btn("javascript:doSaveBZ()","저장 (사업)")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteBZ()","삭제 (사업)")</script></td>
							<td><script language="javascript">btn("javascript:doAddRowBZ()","행삽입")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteRowBZ()","행삭제")</script></td>
							--%>							
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>	
<s:grid screen_id="I_IV_001" height="350px"/>
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
							<td><script language="javascript">btn("javascript:doSubmitIV()", "검수확인서 업로드")</script></td>		 							
						</TR>
					</TABLE>
				</TD>
				<%--
				<TD height="15" align="right">
					<TABLE cellpadding="0">
						<TR>
							<td><script language="javascript">btn("javascript:doSaveCT()","저장 (계약)")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteCT()","삭제 (계약)")</script></td>
							<td><script language="javascript">btn("javascript:doAddRowCT()","행삽입")</script></td>
							<td><script language="javascript">btn("javascript:doDeleteRowCT()","행삭제")</script></td>
						</TR>
					</TABLE>
				</TD>
				 --%>
			</TR>
		</TABLE>	
<s:grid screen_id="I_IV_002" grid_obj="GridObj2" grid_box="gridbox2" grid_cnt="2" height="300px"/>
</form>
</s:header>

<s:footer/>
</body>
</html>