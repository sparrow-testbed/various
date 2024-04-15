
<%
    /**
 * @파일명   : profilepop_mgt_left.jsp
 * @생성일자 : 2009. 03. 26
 * @작성자   : 전선경
 * @변경이력 :
 * @프로그램 설명 : 프로파일 팝업
 */
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>

<script type="text/javascript" src="../js/lib/jquery-1.10.2.min.js"></script>

<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	String user_id = info.getSession("ID");

	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_023");
	multilang_id.addElement("AD_031");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

    HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_023";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	isRowsMergeable = false;// 화면에 행머지기능을 사용할지 여부의 구분(true = 사용, false = 미사용)
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<style type="text/css">
#html,body {
    height: 100%;
}
#condition_area {
    padding-top: 15px;
}

</style>
<script language=javascript src="../js/lib/sec.js"></script>

<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<Script language="javascript">
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var nfCaseQty = "0,000.000";
var myDataProcessor = null;

var message1005 = '<%=text.get("AD_036.1005")%>';//이미 등록 되었습니다.\n 수정이나 삭제를 하세요..
var message1004 = '<%=text.get("AD_036.1006")%>';//선택된 데이터가 없습니다..
var message1006 = '<%=text.get("AD_036.1007")%>';//하나이상 선택할 수 없습니다.
var message1007 = '<%=text.get("AD_036.1008")%>';//등록을 먼저 하셔야 합니다.

var strUserId 	= '<%=user_id%>';
var strToday	= '<%=to_day%>';

	function setGridDraw()
    {

    	<%=grid_obj%>_setGridDraw();

    	<%--사용여부 컬럼은 체크 못하도록 처리--%>
		GridObj.attachEvent("onRowCreated",function(id){
			var cell = GridObj.cells(id, GridObj.getColIndexById("use_flag")); //checkbox cell
			cell.setDisabled(true);
		})

		GridObj.setSizes();
		doQuery(0);

    }

	<%/**
	 * @메소드명 : doQuery
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 프로파일관리 > 조회
	 */%>
	function doQuery(flag)
	{
		var menuName = encodeUrl(LRTrim(document.form.menu_name.value));
		var moduleType = LRTrim(document.form.module_type.value.toUpperCase());
		document.form.menu_name.value = document.form.menu_name.value.toUpperCase();

		var st_menu_object_code = "";

		if(flag == 1)
			st_menu_object_code="";
		else
			st_menu_object_code='<%=JSPUtil.CheckInjection(request.getParameter("MENU_CODE"))%>';

		/*
		wisegrid.SetParam("st_menu_name",	menuName);
		wisegrid.SetParam("st_module_type",	moduleType);
		wisegrid.SetParam("st_menu_object_code", "");
		wisegrid.SetParam("mode",			"query");
		*/

		var grid_col_id = "<%=grid_col_id%>";

		var param = "?st_menu_name="+menuName+"&st_module_type="+moduleType+"&st_menu_object_code="+st_menu_object_code+"&mode=query&grid_col_id="+grid_col_id;
		var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.menu_mgt";

		GridObj.loadXML(G_SERVLETURL+param);
		GridObj.clearAll(false);
	}


	<%/**
	 * @메소드명 : doQueryEnd
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doQuery() 로 결과조회 후 처리가 필요한 경우 사용하는 함수
	 */%>
    function doQueryEnd(GridObj, RowCnt)
    {
		var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");

		return true;
    }



 	<%/**
	 * @메소드명 : doInsert
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 프로파일관리 > 저장
	 */%>
    function doInsert()
	{
		var str="";

		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var i = 0; i < grid_array.length; i++)
		{
			if(CheckModule( GridObj.cells(grid_array[i], GridObj.getColIndexById("module_type")).getValue() , i ) == false){
				alert("<%=text.get("AD_023.MSG_0101")%>");
				return;
			}
			else
				str = str + (GridObj.cells(grid_array[i], GridObj.getColIndexById("menu_object_code") ).getValue() +"$");
		}

		parent.opener.GridObj.cells(parent.opener.setrow, parent.opener.GridObj.getColIndexById("menu_object_code")).setValue(str);
		parent.window.close();
	}



 	<%/**
	 * @메소드명 : CheckModule()
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 프로파일관리 > 주메뉴코드 체크
	 */%>
	function CheckModule(name,idx)
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		for(var j = 0; j < grid_array.length; j++)
		{
			if(j != idx)
			{
				<%-- 주메뉴코드가 같은 것은 선택할 수 없습니다.--%>
				if(GridObj.cells(grid_array[j], GridObj.getColIndexById("module_type")).getValue() == name)
				{
					return false;
				}
			}
		}

		return true;
	}

 	<%/**
	 * @메소드명 : doUpdate
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 프로파일관리 > 수정
	 */%>
    function doUpdate()
	{
		if(!checkRows()) return;

		for(i = dhtmlx_start_row_id; i < dhtmlx_end_row_id; i++)
		{
						<%-- 필수값 체크--%>
			if(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("selected")).getValue() == 1)
			{

				<%-- 메뉴명은 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("menu_name")).getValue()) == "")
				{
					alert('<%=text.get("AD_021.0101")%>');
					return;
				}
				<%-- 주메뉴코드는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("module_type")).getValue()) == "")
				{
					alert('<%=text.get("AD_021.0102")%>');
					return;
				}
				<%-- 메뉴코드는 필수 입력으로 처리한다.--%>
				if(LRTrim(GridObj.cells(GridObj.getRowId(i), GridObj.getColIndexById("menu_object_code")).getValue()) == "")
				{
					alert('<%=text.get("AD_021.0104")%>');
					return;
				}
			}

		}

	    if (confirm("<%=text.get("MESSAGE.1016")%>")){
            var cols_ids = "<%=grid_col_id%>";

            G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.menu_mgt";//서블릿 경로
            param = "?cols_ids="+cols_ids+"&mode=update";//파라미터
		    myDataProcessor = new dataProcessor(G_SERVLETURL + param);
			sendTransactionGrid(GridObj, myDataProcessor, "selected");
        }
	}

	<%/**
	 * @메소드명 : doSaveEnd
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : doInsert() 로 저장 후 처리가 필요한 경우 사용하는 함수
	 */%>
	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;

		//alert("status==="+status);

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true")
		{
			doQuery();
		}
		else alert(messsage);

		return false;
	}

 	<%/**
	 * @메소드명 : checkRows
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 저장시 선택필드에 체크된 로우 확인
	 */%>
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "selected");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("AD_023.norows")%>");
		return false;
	}

 	<%/**
	 * @메소드명 : doAddRow
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 행삽입
	 */%>
	function doAddRow()
    {
    	dhtmlx_last_row_id++;
    	var nMaxRow2 = dhtmlx_last_row_id;
    	var row_data = "<%=grid_col_id%>";

    	GridObj.enableSmartRendering(true);
    	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
    	GridObj.selectRowById(nMaxRow2, false, true);
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).cell.wasChanged = true;

		GridObj.cells(nMaxRow2, GridObj.getColIndexById("selected")).setValue("1");
   		GridObj.cells(nMaxRow2, GridObj.getColIndexById("use_flag")).setValue("1");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_user_id")).setValue("<%=info.getSession("ID")%>");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("add_date")).setValue("<%=to_date%>");
		GridObj.cells(nMaxRow2, GridObj.getColIndexById("flag")).setValue("N");

	}

 	<%/**
	 * @메소드명 : doOnRowSelected
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 그리드 셀 클릭 이벤트
	 */%>

	var setrow="0";
	var setcol="0";

	function doOnRowSelected(rowId,cellInd)
    {

		if(cellInd == GridObj.getColIndexById("menu_object_code") ){

			var obj_code = GridObj.cells(rowId, GridObj.getColIndexById("menu_object_code")).getValue();
			$('#menu_object_code').val(obj_code);
			if(dhtmlxTree != null) {
			    dhtmlxTree.destructor();
			}
		    setTreeDraw();
			loadTree(obj_code);
		}
    }

	<%/**
	 * @메소드명 : setModuleCode
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 주메뉴코드 선택
	 */%>
	function setModuleCode(text,value,arg1,arg2){
		document.forms[0].module_type.value = text;
	}

	<%/**
	 * @메소드명 : setScreenCode
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 초기화면 선택
	 */%>
	function setScreenCode(text,value,arg1,arg2){
		//alert("text=="+text +"value=="+value );
		if(checkval == "Y")
			GridObj.cells(setrow, GridObj.getColIndexById("init_screen_id")).setValue(text);
		else
			document.form.INIT_SCREEN_ID.value = text;
	}


	<%/**
	 * @메소드명 : doOnCellChange
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 그리드 셀 클릭변경  이벤트
	 */%>

    function doOnCellChange(stage,rowId,cellInd)
    {
    	//alert("doOnCellChange===" + stage + "  " +rowId +" " + cellInd);

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

	<%/**
	 * @메소드명 : initAjax
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 조회조건 콤보박스 생성
	 */%>
	function initAjax(){
		//doRequestUsingPOST( 'SL5001', 'M998' ,'module_type' );

	}

	<%/**
	 * @메소드명 : doDelete
	 * @생성일자 : 2009. 03. 26
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 프로파일관리 > 삭제
	 */%>
	function doDelete()
	{
		if(!checkRows())
				return;

	   if (confirm("<%=text.get("MESSAGE.1015")%>")){
            var cols_ids = "<%=grid_col_id%>";

            G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.menu_mgt";//서블릿 경로
            param = "?cols_ids="+cols_ids+"&mode=delete";//파라미터

			myDataProcessor = new dataProcessor(G_SERVLETURL + param);
		    sendTransactionGrid(GridObj, myDataProcessor, "selected");
	   }
	}




	function getModule() {

	  	popupcode("M998","setModuleCode");
	}
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


	//23번 행이동
    function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }
    //23번 행이동
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }



    function sumColumn(ind) {
		var out = 0;
		for(var dhtmlx_start_row_id=0; i< dhtmlx_end_row_id;i++) {
			out += parseFloat(GridObj.cells2(i, ind).getValue())
		}
		return out;
	}





    function doDeleteRow()
    {
    	//GridObj.enableSmartRendering(false);
    	var rowcount = dhtmlx_end_row_id;

    	for(var row = rowcount - 1; row >= dhtmlx_start_row_id; row--)
		{
			if("1" == GridObj.cells(GridObj.getRowId(row), 0).getValue())
			{
				GridObj.deleteRow(GridObj.getRowId(row));
        	}
	    }
    }

    function doExcelDown()
    {
    	GridObj.setCSVDelimiter("\t");
    	var csvNew = GridObj.serializeToCSV();
		GridObj.loadCSVString(csvNew);
    }

    function filterBy() {
		var tVal = document.getElementById("title_flt").childNodes[0].value.toLowerCase();

		for(var i=dhtmlx_start_row_id; i < dhtmlx_end_row_id; i++){
			var tStr = GridObj.cells2(i,4).getValue().toString().toLowerCase();
			if(tVal=="" || tStr.indexOf(tVal)==0)
				GridObj.setRowHidden(GridObj.getRowId(i),false)
			else
				GridObj.setRowHidden(GridObj.getRowId(i),true)
		}
	}

	function myErrorHandler(obj) {
		alert("Error occured.\n"+obj.firstChild.nodeValue);
		myDataProcessor.stopOnError = true;
		return false;
	}

	function doSerial()
	{
		GridObj.setSerializationLevel(true,true);
		var myXmlStr = GridObj.serialize();
	}



	function doExcelUpload() {
		var bufferData = window.clipboardData.getData("Text");
		if(bufferData.length > 0) {
			GridObj.clearAll();
			GridObj.setCSVDelimiter("\t");
    		GridObj.loadCSVString(bufferData);
		}
		return;
	}




    function getAddRowValues(col_id, set_value, row_data)
    {
    	row_data = row_data.replace(col_id, set_value);
		return row_data;
    }

	function doFilterBy()
	{
		var screen_id = document.form.screen_id.value;
		alert(GridObj.getColIndexById("screen_id"));
		GridObj.filterBy(GridObj.getColIndexById("screen_id"), screen_id);
		alert("Daum");
	}

	function CheckNode(arg) {
	    var menu_object_code = $('#menu_object_code').val();
	    var menu_field_code = $('#menu_field_code').val();
	    var menu_parent_field_code = $('#menu_parent_field_code').val();
	    var menu_name = $('#menu_name').val(); 
	    var screen_id = $('#screen_id').val(); 
	    var menu_link_flag = 'Y';
	    var child_flag = $("input:radio[name=child_flag]:checked").val();
	    var order_seq = $('#order_seq').val(); 
	    var use_flag = $('#use_flag').val(); 
	    if(arg == null) arg = '';
	    var status = arg;
	    var sub_flag = $("input:radio[name=sub_flag]:checked").val();
	    var folder_flag = $('#folder_flag').val(); 

	    if(menu_name == ''){    
	        alert('<%=text.get("AD_031.0102")%>');
	        return;
	    }
	    if(status != 'C' && menu_field_code == ''){
	        alert('<%=text.get("AD_031.0103")%>');
	        return;
	    }
	    if(menu_parent_field_code == ''){
	            menu_parent_field_code = '*';
	            order_seq = '0';        
	    }
	    var params = 'menu_object_code='+menu_object_code+'&menu_field_code='+menu_field_code+ '&menu_parent_field_code='+ menu_parent_field_code+ 
	    '&menu_name='+ encodeUrl(menu_name) + '&screen_id='+ screen_id+ '&menu_link_flag='+ menu_link_flag+ '&child_flag='+ child_flag+ 
	    '&order_seq='+ order_seq+ '&use_flag='+ use_flag+ '&status='+ status+ '&sub_flag='+ sub_flag+ '&folder_flag='+ folder_flag;
	    
	    var loadXMLUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.Menupop_tree?" + params;
	    dhtmlxTree.destructor();
	    setTreeDraw();
	    dhtmlxTree.loadXML(loadXMLUrl);
	}   
	
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
	<%
	    String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
								if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	%>
	<s:header popup="true">
		<div id="left" style="width: 60%; float: left;">
				<div id="head_area">
					<!--타이틀시작-->
					<div id="title">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="1" valign="top"><img src="../images/page/title_left.gif"></td>
								<td style="background-image: url(../images/page/title_mid.gif); background-repeat: repeat-x" class="se_title"><%=text.get("AD_023.TITLE")%></td>
							</tr>
						</table>
					</div>
					<!--//타이틀끝-->
<div id="profile_grid_mode">
					<!--내용시작-->
			<form name="form">
					<div id="condition_area">
						<%-- 조회조건 START --%>
						<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
							<tr>
								<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
									<%=text.get("AD_023.0201")%> <!-- 주메뉴코드 -->
								</td>
								<td width="30%" height="24" class="data_td">
								    <input type="text" name='module_type' size="15" class="inputsubmit" onKeyUp='module_type.value = module_type.value.toUpperCase();'>
									<a href="javascript:getModule();"><img src="../images/ico_zoom.gif" align="absmiddle" border=0></a>
								</td>
								<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
									<%=text.get("AD_023.0202")%> <!--  메뉴명 -->
								</td>
								<td width="30%" height="24" class="data_td">
								    <input type="text" name='menu_name' size="15" class="inputsubmit">
								</td>
							</tr>
						</table>
						</td>
					</tr>
			  		</table>
					</div>
			</form>

					<%-- 조회조건 END --%>
					<%-- 버튼 START --%>
					<div id="btn_area">
						<TABLE cellpadding="2" cellspacing="0">
							<TR>
								<td><script language="javascript">btn("javascript:doQuery(1)",			 "<%=text.get("BUTTON.search")%>")	</script></td>
								<td><script language="javascript">btn("javascript:doInsert()",			 "<%=text.get("BUTTON.save")%>")	</script></td>
								<td><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%> ") </script></td>
							</TR>
						</TABLE>
					</div>
					<%-- 버튼 END --%>
</div>
<div id="menu_mode">
                <!-- JSP내용 추가 start _____________________________________________________________________________________________ -->
                <!-- ______________________________________________________________________________________________________________ -->
                <form name="form0">
                    <input type='hidden' id='menu_field_code' name='menu_field_code' >
                    <input type='hidden' id='menu_parent_field_code' name='menu_parent_field_code' >
                    <input type='hidden' id='menu_link_flag' name='menu_link_flag' value='Y'>
                    <input type='hidden' id='folder_flag' name='folder_flag'>
                    <input type='hidden' id='order_seq' name='order_seq'>
                    <div id="condition_area">
                        <div class="title_sub" style="padding-top: 20px;"><%=text.get("AD_031.LB_01")%></div>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
                        <table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
                            <tr>
                                <td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_02")%></td>
                                <td class="data_td" width="25%">
                                    &nbsp;<input type='text' id='menu_object_code' name='menu_object_code' size='16' readOnly>
                                </td>
                                <td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_03")%>
                                </td>
                                <td class="data_td" width="25%"><select
                                    name="use_flag" id="use_flag" class="inputsubmit">
                                        <OPTION VALUE='Y'>Y</OPTION>
                                        <OPTION VALUE='N'>N</OPTION>
                                </select></td>
                            </tr>
                            <tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
                            <tr>
                                <td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_04")%></td>
                                <td class="data_td" width="75%" colspan="3">&nbsp;
                                    <input type="text" class="inputsubmit" name="menu_name" id="menu_name" size="40">
                                </td>
                            </tr>
                            <tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
                            <tr>
                                <td width="25%" height="25" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_05")%></td>
                                <td class="data_td" width="75%" colspan="3">
                                    &nbsp;<input type="text" class="inputsubmit" name="screen_id" id="screen_id" size="40">
                                </td>
                            </tr>
                        </table>
                        </td>
				</tr>
		  		</table>
                        <div class="title_sub" style="padding-top: 20px;"><%=text.get("AD_031.LB_06")%></div>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
                        <table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
                            <tr>
                                <td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_07")%></td>
                                <td class="data_td"><input name="child_flag" id="child_flag"
                                    type="radio" class="radio" value="Y" CHECKED></td>
                            </tr>
                            <tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
                            <tr>
                                <td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_08")%></td>
                                <td class="data_td"><input name="child_flag" id="child_flag"
                                    type="radio" class="radio" value="N"></td>
                            </tr>
                        </table>
                        </td>
				</tr>
		  		</table>
                        <div class="title_sub" style="padding-top: 5px;"><%=text.get("AD_031.LB_09")%></div>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
                        <table width="100%" border="0" cellspacing="0" bgcolor="#DBDBDB">
                            <tr>
                                <td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_10")%></td>
                                <td class="data_td"><input name="sub_flag" id="sub_flag"
                                    type="radio" class="radio" value="N" CHECKED></td>
                            </tr>
                            <tr>
								<td colspan="4" height="1" bgcolor="#dedede"></td>
							</tr>
                            <tr>
                                <td class="title_td" width="25%"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_031.LB_11")%></td>
                                <td class="data_td"><input name="sub_flag" id="sub_flag"
                                    type="radio" class="radio" value="Y"></td>
                            </tr>
                        </table>
                        </td>
				</tr>
		  		</table>
                    </div>
                    <div id="btn_area">
                        <table border="0" cellspacing="3" cellpadding="0" align=right>
                            <tr>
                                <td align><script language="javascript">btn("javascript:CheckNode('C')",    "<%=text.get("BUTTON.insert")%>");</script>
                                </td>
                                <td><script language="javascript">btn("javascript:CheckNode('R')",  "<%=text.get("BUTTON.update")%>");</script>
                                </td>
                                <td><script language="javascript">btn("javascript:CheckNode('D')",  "<%=text.get("BUTTON.deleted")%>");</script>
                                </td>
                                <td><script language="javascript">btn("javascript:window.close();",  "<%=text.get("BUTTON.close")%>");</script>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
</div>
				</div>
				<div id="gridbox" name="gridbox" width="100%" style="background-color: white;"></div>
		</div>
		<div id="right" style="width: 37%; height: 350px; float: left; padding: 0px 0px 0px 15px;">
			<div id="right_inner" style="background-color: #F1F2F6; width: 100%; height: 100%;">
				<div id="right_tree" style="background-color: #F1F2F6; padding: 5px 5px 5px 5px;">
				                    <script>
                        var dhtmlxTree = null;
                        function setTreeDraw() {
                            dhtmlxTree = new dhtmlXTreeObject("right_tree", "100%", "100%", 0);
                            dhtmlxTree.setSkin('dhx_skyblue');
                            dhtmlxTree.setImagePath("../dhtmlx/dhtmlx_full_version/imgs/csh_bluefolders/");
                            dhtmlxTree.setLockedIcons("lock.gif","lock.gif","lock.gif");
                            dhtmlxTree.enableHighlighting(false);
                            dhtmlxTree.attachEvent(
                                            "onClick",
                                            function(id) {
                                                $('#profile_grid_mode').css('display', 'none');
                                                $('#gridbox').css('display', 'none');
                                                $('#menu_mode').css('display', 'block');

                                                var use_flag = dhtmlxTree.getUserData(id, "useflag");
                                                var screen_id = dhtmlxTree.getUserData(id, "screenid");
                                                var menu_name = dhtmlxTree.getUserData(id, "menuname");
                                                var child_flag = dhtmlxTree.getUserData(id, "childflag");
                                                var menu_field_code = dhtmlxTree.getUserData(id, "menufieldcode");
                                                var menu_parent_field_code = dhtmlxTree.getUserData(id, "menuparentfieldcode");
                                                var order_seq = dhtmlxTree.getUserData(id, "orderseq");
                                                
                                                $("#use_flag").val(use_flag);
                                                $("#screen_id").val(screen_id);
                                                $("#menu_name").val(menu_name);
                                                $("#child_flag").val(child_flag);
                                                $("#folder_flag").val(child_flag);
                                                $("#menu_field_code").val(menu_field_code);
                                                $("#menu_parent_field_code").val(menu_parent_field_code);
                                                $("#order_seq").val(order_seq);
                                                $("input:radio[name=child_flag]").filter("[value="+child_flag+"]").prop("checked", true);
                                            });
                        }
                        function loadTree(menu_object_code) {
                            var loadXMLUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.Menupop_tree?menu_object_code=" + menu_object_code;
                            dhtmlxTree.loadXML(loadXMLUrl);
                        }
                    </script>
				</div>
			</div>
		</div>
	</s:header>
	<s:footer auto_resize='false'/>
      <script>
          $('#profile_grid_mode').css('display', 'block');
          $('#menu_mode').css('display', 'none');
          function recal() {
              $('#gridbox').css('height', ($(window).height() - $('#header').height() - 150) + 'px');
              $('#right_tree').css('height', ($(window).height() - $('#header').height() - 50) + 'px');
          }
          $(window).resize(recal);
          $(recal);
      </script>
</body>
</html>
