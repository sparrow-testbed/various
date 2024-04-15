<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_005");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_005";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        	소싱그룹/협력업체 연결 생성 <p>
 Description:  	소싱그룹/협력업체 연결 생성 <p>
 Copyright:    	Copyright (c) <p>
 Company:      	ICOMPIA <p>
 @author       	SHYI<p>
 @version      	1.0.0<p>
 @Comment       소싱그룹/협력업체 연결 생성
--%>

<% String WISEHUB_PROCESS_ID="SR_005";%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%
	String house_code = info.getSession("HOUSE_CODE");
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
<%@ include file="/include/wisehub_scripts.jsp"%>
<script language="javascript" src="../../jscomm/crypto.js" type="text/javascript"></script> --%>
<script language="javascript" type="text/javascript">

var INDEX_SEL;
var INDEX_TYPE1_CODE;
var INDEX_TYPE2_CODE;
var INDEX_TYPE3_CODE;
var INDEX_VENDOR_CODE;

var INDEX_MAPPING_ID;
var INDEX_FLAG1;

function Init()
{
setGridDraw();
setHeader();
}

function setHeader()
{



	<%-- R : 조회건, I : 행삽입건 --%>

	INDEX_SEL 			= GridObj.GetColHDIndex("sel");
	INDEX_TYPE1_CODE 	= GridObj.GetColHDIndex("type1_code");
	INDEX_TYPE2_CODE 	= GridObj.GetColHDIndex("type2_code");
	INDEX_TYPE3_CODE 	= GridObj.GetColHDIndex("type3_code");
	INDEX_VENDOR_CODE 	= GridObj.GetColHDIndex("vendor_code");

	INDEX_MAPPING_ID	= GridObj.GetColHDIndex("mapping_id");
	INDEX_FLAG1 		= GridObj.GetColHDIndex("flag1");
}

function Query(flag)
{
	var vendor_code 		= document.form1.vendor_code.value;
	var vendor_code_name 	= document.form1.vendor_code_name.value;

	if(flag == "Y" && vendor_code == "" && vendor_code_name == "")
	{
		alert("[업체코드/업체명] 중 한 값은 필수입력 입니다.");
		return;
	}
	var url	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_vnlink_insert";
	var params ="mode=getSgVnLinkList&grid_col_id="+grid_col_id;
	params += dataOutput();
	GridObj.post(url, params);
 	GridObj.clearAll(false);
	/* servletURL = "/servlets/master.sg.sou_bd_lis3";
	GridObj.SetParam("vendor_code", vendor_code);
	GridObj.SetParam("vendor_code_name", vendor_code_name);

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletURL);
	GridObj.strHDClickAction="sortmulti"; */
}

function entKeyDown()
{
	if(event.keyCode==13)
	{
		window.focus();
		Query("Y");
	}
}

function VendorCode()
{
	var f0 = document.form1;

	var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0218&function=setVendor&values=<%=house_code%>&values=&values=";
	var left = 50;  var top = 100;  var width = 550;        var height = 450;       var toolbar = 'no';     var menubar = 'no';     var status = 'yes';     var scrollbars = 'no';    var resizable = 'no';
	var agentCodeWin = window.open( url, 'agentCodeWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
	
}
function PopupManager()
{
	PopupCommon2("SP0218","setVendor","<%=info.getSession("HOUSE_CODE")%>","&values=&values","코드","설명");
}

function setVendor(code, text1, text2)
{
	 document.form1.vendor_code.value = code;
	 document.form1.vendor_code_name.value = text1;
}

var i_row = "";
var i_col = "";



function JavaCall(msg1,msg2,msg3,msg4,msg5)
{
<%--
	for(var i=0;i<GridObj.GetRowCount();i++) {
		if(i%2 == 1){
			for (var j = 0;	j<GridObj.GetColCount(); j++){
				GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
			}
		}
	}
--%>
	if(msg1 == "t_imagetext")
	{
		if(msg3 == INDEX_TYPE1_CODE)
		{
			var flag1 = GD_GetCellValueIndex(GridObj,msg2,INDEX_FLAG1);
			if(flag1 == "R"){
				alert("행삽입 건 만 클릭 가능합니다.");
				return;
			}

			i_row = msg2;
			i_col = msg3;
			var LEVEL = "1";
			var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0238&function=D&values="+LEVEL+"&values=&values=";
			Code_Search(url,'','','','','');
		}

		if(msg3 == INDEX_TYPE2_CODE)
		{
			var flag1 = GD_GetCellValueIndex(GridObj,msg2,INDEX_FLAG1);
			var refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_TYPE1_CODE);
			if(flag1 == "R"){
				alert("행삽입 건 만 선택 가능합니다.");
				return;
			}

			if(refitem == ""){
				alert("소싱대분류 선택 후 선택 가능합니다.");
				return;
			}

			i_row = msg2;
			i_col = msg3;
			var LEVEL = "2";
			var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0239&function=getType2&values="+LEVEL+"&values="+refitem+"&values=&values=";
			Code_Search(url,'','','','','');
		}

		if(msg3 == INDEX_TYPE3_CODE)
		{
			var flag1 = GD_GetCellValueIndex(GridObj,msg2,INDEX_FLAG1);
			var refitem = GD_GetCellValueIndex(GridObj,msg2,INDEX_TYPE2_CODE);
			if(flag1 == "R"){
				alert("행삽입 건 만 선택 가능합니다.");
				return;
			}

			if(refitem == ""){
				alert("소싱중분류 선택 후 선택 가능합니다.");
				return;
			}

			i_row = msg2;
			i_col = msg3;
			var LEVEL = "3";
			var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0239&function=getType3&values="+LEVEL+"&values="+refitem+"&values=&values=";
			Code_Search(url,'','','','','');
		}

		if(msg3 == INDEX_VENDOR_CODE)
		{
			var flag1 = GD_GetCellValueIndex(GridObj,msg2,INDEX_FLAG1);
			if(flag1 == "R"){
				alert("행삽입 건 만 선택 가능합니다.");
				return;
			}

			i_row = msg2;
			i_col = msg3;
<%--     		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0218&function=D&values="+<%=info.getSession("HOUSE_CODE")%>+"&values=&values="; --%>
    		var url = "/kr/admin/wisepopup/cod_cm_lis1.jsp?code=SP0218&function=D&values=000&values=&values=";

    		Code_Search(url,'','','','','');
		}
	}

	if(msg1 == "doData")
	{
		/* var mode = GD_GetParam(GridObj,0);
        var msg = GD_GetParam(GridObj,1);
        alert(msg); */
        
        Query("N");
	}
}



function SP0238_getCode(code,name)
{
	var wise = GridObj;
	//GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("s_type1"), name);
	//GD_SetCellValueIndex(GridObj,i_row, INDEX_TYPE1_CODE, "/kr/images/button/query.gif&&"+code, "&");
	//GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("type1_code"), code);
	GridObj.cells(i_row, GridObj.getColIndexById("s_type1")).setValue(name);
	GridObj.cells(i_row, GridObj.getColIndexById("type1_code")).setValue(code);
}

function getType2(code,name,flag)
{
	var wise = GridObj;
	
	/* GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("s_type2"), name);
	GD_SetCellValueIndex(GridObj,i_row, INDEX_TYPE2_CODE, "/kr/images/button/query.gif&&"+code, "&"); */
	GridObj.cells(i_row, GridObj.getColIndexById("s_type2")).setValue(name);
	GridObj.cells(i_row, GridObj.getColIndexById("type2_code")).setValue(code);
}

function getType3(code,name,flag)
{
	var wise = GridObj;

	/* GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("s_type3"), name);
	GD_SetCellValueIndex(GridObj,i_row, INDEX_TYPE3_CODE, "/kr/images/button/query.gif&&"+code, "&");
	GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("annou_flag"), flag); */
	GridObj.cells(i_row, GridObj.getColIndexById("s_type3")).setValue(name);
	GridObj.cells(i_row, GridObj.getColIndexById("type3_code")).setValue(code);
	GridObj.cells(i_row, GridObj.getColIndexById("annou_flag")).setValue(flag);

}

function SP0218_getCode(code, name1, name2)
{
	var wise = GridObj;

	/* GD_SetCellValueIndex(GridObj,i_row, GridObj.GetColHDIndex("name_loc"), name1);
	GD_SetCellValueIndex(GridObj,i_row, INDEX_VENDOR_CODE, "/kr/images/button/query.gif&"+code+"&"+code, "&"); */
	GridObj.cells(i_row, GridObj.getColIndexById("name_loc")).setValue(name1);
	GridObj.cells(i_row, GridObj.getColIndexById("vendor_code")).setValue(code);
}

/* function Line_insert()
{
	var wise = GridObj;
	GridObj.AddRow();
	
	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_SEL, "true&", "&");
	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_TYPE1_CODE, G_IMG_ICON+"&null&null", "&");
	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_TYPE2_CODE, G_IMG_ICON+"&null&null", "&");
	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_TYPE3_CODE, G_IMG_ICON+"&null&null", "&");
	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_VENDOR_CODE,G_IMG_ICON+"&null&null", "&");

	GD_SetCellValueIndex(GridObj,GridObj.GetRowCount()-1, INDEX_FLAG1, "I");
}
 */
function doAddRow() {
	dhtmlx_last_row_id++;
	var nMaxRow2 = dhtmlx_last_row_id;
	var row_data = "<%=grid_col_id%>";
	  	
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
	GridObj.selectRowById(nMaxRow2, false, true);
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("sel")).cell.wasChanged = true;
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("sel")).setValue("1");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("flag1")).setValue("I");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("type1_img")).setValue("/images/icon/icon_search.gif");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("type2_img")).setValue("/images/icon/icon_search.gif");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("type3_img")).setValue("/images/icon/icon_search.gif");
	GridObj.cells(nMaxRow2, GridObj.getColIndexById("vendor_code")).setValue("<img src='/images/icon/icon_search.gif'/>");
	dhtmlx_before_row_id = nMaxRow2;
}


function Create()
{
	//var wise = GridObj;
	var chk_cnt = 0;
	var grid_array = GridObj.GetRowCount();
	/* for(var i = 1; i <= GridObj.getRowsNum(); i++)
	{
		GridObj.cells(i, GridObj.getColIndexById("sel")).cell.wasChanged = true;
	} */
	for(var i=0; i<grid_array;i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SEL);
		if(temp == "1")
		{
			var type3_code 	= GD_GetCellValueIndex(GridObj,i,INDEX_TYPE3_CODE);
			var vendor_code = GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE);
			var flag1 		= GD_GetCellValueIndex(GridObj,i,INDEX_FLAG1);
			if(flag1 == "R")
			{
				alert("행삽입 건 만 등록 가능합니다.");
				return;
			}

			if(type3_code == "")
			{
				alert("소싱소분류 선택 후 등록하십시요.");
				return;
			}

			if(vendor_code == "")
			{
				alert("업체코드 선택 후 등록하십시요.");
				return;
			}

			chk_cnt = chk_cnt+1;
		}
	}

	if(chk_cnt == 0)
	{
		alert("등록할 항목이 없습니다.");
		return;
	}
	var params ="mode=setSgVnLinkInsert&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "sel");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_vnlink_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
    
	/* var servletURL = "/servlets/master.sg.sou_bd_lis3";
    GridObj.SetParam("mode","setInsert");
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
	GridObj.SendData(servletURL, "ALL", "ALL"); */
}

function Delete()
{
	//var wise = GridObj;
	var chk_cnt = 0;
	
	for(var i=0; i<GridObj.GetRowCount();i++)
	{
		var temp = GD_GetCellValueIndex(GridObj,i,INDEX_SEL);

		if(temp == "1")
		{
			var type3_code 	= GD_GetCellValueIndex(GridObj,i,INDEX_TYPE3_CODE);
			var vendor_code = GD_GetCellValueIndex(GridObj,i,INDEX_VENDOR_CODE);
			var flag1 		= GD_GetCellValueIndex(GridObj,i,INDEX_FLAG1);

			if(flag1 == "I")
			{
				alert("등록 건 만 삭제 가능합니다.");
				return;
			}

			chk_cnt = chk_cnt+1;
		}
	}

	if(chk_cnt == 0)
	{
		alert("등록할 항목이 없습니다.");
		return;
	}
	var params ="mode=setSgVnLinkDelete&cols_ids="+grid_col_id;
	params+=dataOutput();
	var grid_array = getGridChangedRows(GridObj, "sel");
 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg_vnlink_insert",params);
    sendTransactionGridPost(GridObj, myDataProcessor, "sel", grid_array);
	/* var servletURL = "/servlets/master.sg.sou_bd_lis3";
    GridObj.SetParam("mode","setDelete");

	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletURL, "ALL", "ALL"); */
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
    var header_name = GridObj.getColumnId(cellInd);
    if(header_name=="type1_img"){
    	var arrValue = new Array();
		var arrDesc = new Array();
		var flag1 = GridObj.cells(rowId, GridObj.getColIndexById("flag1")).getValue();
		if(flag1 == "R"){
			alert("행삽입 건 만 클릭 가능합니다.");
			return;
		}
		i_row=rowId;
		arrValue[0] = "1";
		arrValue[1] = "";
		arrValue[2] = "";
		
		arrDesc[0] = "코드";
		arrDesc[1] = "설명";

		PopupCommonArr("SP0238","SP0238_getCode",arrValue,arrDesc);
    }
    if(header_name=="type2_img"){
    	var refitem = GridObj.cells(rowId, GridObj.getColIndexById("type1_code")).getValue();
    	var flag1 = GridObj.cells(rowId, GridObj.getColIndexById("flag1")).getValue();
    	
    	if(flag1 == "R"){
			alert("행삽입 건 만 선택 가능합니다.");
			return;
		}

		if(refitem == ""){
			alert("소싱대분류 선택 후 선택 가능합니다.");
			return;
		}
    	var arrValue = new Array();
		var arrDesc = new Array();
		i_row=rowId;
		arrValue[0] = "2";
		arrValue[1] = refitem;
		arrValue[2] = "";
		arrValue[3] = "";
		
		arrDesc[0] = "코드";
		arrDesc[1] = "설명";

		PopupCommonArr("SP0239","getType2",arrValue,arrDesc);
    }
	if(header_name=="type3_img"){
    	var refitem = GridObj.cells(rowId, GridObj.getColIndexById("type2_code")).getValue();
    	var flag1 = GridObj.cells(rowId, GridObj.getColIndexById("flag1")).getValue();
    	if(flag1 == "R"){
			alert("행삽입 건 만 선택 가능합니다.");
			return;
		}

		if(refitem == ""){
			alert("소싱중분류 선택 후 선택 가능합니다.");
			return;
		}
		var arrValue = new Array();
		var arrDesc = new Array();
		i_row=rowId;
		arrValue[0] = "3";
		arrValue[1] = refitem;
		arrValue[2] = "";
		arrValue[3] = "";
		
		arrDesc[0] = "코드";
		arrDesc[1] = "설명";

		PopupCommonArr("SP0239","getType3",arrValue,arrDesc);
    }
	if(header_name=="vendor_code"){
		var flag1 = GridObj.cells(rowId, GridObj.getColIndexById("flag1")).getValue();
		if(flag1 == "R"){
			alert("행삽입 건 만 선택 가능합니다.");
			return;
		}
		var arrValue = new Array();
		var arrDesc = new Array();
		i_row=rowId;
		arrValue[0] = "<%=info.getSession("HOUSE_CODE")%>";
		arrValue[1] = "";
		arrValue[2] = "";
		
		arrDesc[0] = "코드";
		arrDesc[1] = "설명";

		PopupCommonArr("SP0218","SP0218_getCode",arrValue,arrDesc);
		
	}
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
        Query();
    } else {
        alert(messsage);
    }
    if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    	//Query("N");
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
<body onload="Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0"  onkeydown='entKeyDown()'>

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

<%-- <script language="javascript">rdtable_top1()</script> --%>
<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">

<form name="form1" method="post" action="">
	<tr>
		<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 업체코드</td>
		<td class="c_data_1" width="35%">
			<input type="text" name="vendor_code" id="vendor_code" size="20" class="input_re" maxlength="10">
			<a href="javascript:PopupManager()">
				<img src="/images/icon/icon_search.gif" align="absmiddle" border="0" alt="">
			</a>
		</td>
		<td width="15%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 업체명</td>
		<td class="c_data_1" width="35%">
			<input type="text" name="vendor_code_name" id="vendor_code_name" size="25" class="input_re">
		</td>
	</tr>
</table>
<%-- <script language="javascript">rdtable_bot1()</script> --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30" align="right">
			<TABLE cellpadding="0">
	      		<TR>
    	  			<td><script language="javascript">btn("javascript:Query('Y')","조 회")</script></td>
    	  			<td><script language="javascript">btn("javascript:doAddRow()","행삽입")</script></td>
    	  			<td><script language="javascript">btn("javascript:Create()","생 성")</script></td>
    	  			<td><script language="javascript">btn("javascript:Delete()","삭 제")</script></td>
    	  		</TR>
  			</TABLE>
  		</td>
	</tr>
</table>

<%-- <table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","360")%>
	</td>
</tr>
</table>
 --%>

</form>

</s:header>
<s:grid screen_id="SR_005" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


