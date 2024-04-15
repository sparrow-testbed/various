<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;

	String user_id         = info.getSession("ID");
	String company_code    = info.getSession("COMPANY_CODE");
	String toDays          = SepoaDate.getShortDateString();
	String toDays_1        = SepoaDate.addSepoaDateMonth(toDays,-1);
	String user_name_loc   = info.getSession("NAME_LOC");
	String ctrl_code       = info.getSession("CTRL_CODE");
	String z_loi_flag = request.getParameter("z_loi_flag");
	String init_flag = JSPUtil.paramCheck(request.getParameter("init_flag"));
	String user_type = info.getSession("USER_TYPE");
    String is_admin_user = info.getSession("IS_ADMIN_USER");

	if(JSPUtil.paramCheck(request.getParameter("init_menu_object_code")).trim().length() > 0)
	{
		init_flag = "false";
	}

	Object[] obj =
	{
		company_code
	};

	 Vector multilang_id = new Vector();
	multilang_id.addElement("DS_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("BULLETIN");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info, multilang_id);
	HashMap msg = MessageUtil.getMessage(info, multilang_id);

	// Dthmlx Grid 전역변수들..
	String screen_id = "DS_002";//사용 페이지 : 공지사항목록, 자료실목록
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	if(info.getSession("USER_TYPE").equals("S"))
	{
		dhtmlx_back_cols_vec.addElement("VIEW_COUNT=Rcolor");

	}
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<style type="text/css">
.input_empty_file2 { background-color:#F6F6F6; border-bottom:solid #F6F6F6 0px;border-left:solid #F6F6F6 0px;border-right:solid #F6F6F6 0px;border-top:solid #F6F6F6 0px;font-size:12px; font-family:돋움; height:19px;color:555555;}
.input_empty_file3 { background-color:#F6F6F6; border-bottom:solid #F6F6F6 0px;border-left:solid #F6F6F6 0px;border-right:solid #F6F6F6 0px;border-top:solid #F6F6F6 0px;font-size:12px; font-family:돋움; height:19px;color:555555; text-align:right}
.radio_file {border: 0px}
</style>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/include_css.jsp"%>
<script language="javascript" src="/js/lib/sec.js"></script>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language="javascript">
var	servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.admin.bulletin_list_new_ict";

var user_type = "<%=user_type%>";
var is_admin_user = "<%=is_admin_user%>";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var nfCaseQty = "0,000.000";
var myDataProcessor = null;


	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();

		GridObj.setSizes();

 		if(user_type == 'S'){
			GridObj.setColumnHidden(GridObj.getColIndexById("SELECTED"), true);
		} 
    }


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

    function doQueryEnd(GridObj, RowCnt)
    {
		var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");

		if(status == "false") alert(msg);
		return true;
    }

    function sumColumn(ind) {
		var out = 0;
		for(var dhtmlx_start_row_id=0; i< dhtmlx_end_row_id;i++) {
			out += parseFloat(GridObj.cells2(i, ind).getValue())
		}
		return out;
	}

	function doOnRowSelected(rowId,cellInd)
    {

    	var header_name = GridObj.getColumnId(cellInd);

		if( header_name == "ATTACH_NAME")
		{
			
			var ATTACH_NO_VALUE = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO")).getValue());
       		if(ATTACH_NO_VALUE.length>0){ 
       			fnFiledown(ATTACH_NO_VALUE);
       		}
		}

		if(header_name == "SUBJECT"){
			var seq =  LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("SEQ")).getValue());
			//popup(seq);
			view_count(seq);
		}

		<%
		if(!user_type.equals("S") && is_admin_user.equals("true")){
		%>

			if( header_name == "VIEW_COUNT")
			{
				//var seq =  SepoaGridGetCellValueIndex(document.WiseGrid,msg2, INX_SEQ);
				var seq = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("SEQ")).getValue());
	
				//alert("seq="+seq);
	
	       		var url = "../admin/bulletin_view_count_list_ict.jsp?seq="+seq;
	
				CodeSearchCommon(url,'bulletin_view_count_list','0','0','700','600');
			}

		<%
		}
		%>

    }

	function doOnCellChange(stage,rowId,cellInd)
	{
		var header_name = GridObj.getColumnId(cellInd);
	    var max_value = GridObj.cells(rowId, cellInd).getValue();
	    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	    if(stage==0) {
	        return true;
	    } else if(stage==1) {
	    	if( header_name == "SELECTED" ) {
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
		    	row_id = rowId;
		    	return true;
	    	}
	    } else if(stage==2) {
	        return true;
	    }
	    
	    return false;
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


	function doSelect()
	{

		var gubun = encodeUrl(LRTrim(document.form1.gubun.value));
		var quest = encodeUrl(LRTrim(document.form1.quest.value));
		var company_code = encodeUrl(LRTrim(document.form1.company_code.value));
		var dept_type = encodeUrl(LRTrim(document.form1.dept_type.value));
		var view_user_type = encodeUrl(LRTrim(document.form1.view_user_type.value));
		
		if(view_user_type == null || view_user_type == "") {
			alert("사용자구분을 선택해주십시오.");
			document.form1.view_user_type.focus();
			return;
		}
		
		var grid_col_id = "<%=grid_col_id%>";
		var language = "<%=info.getSession("LANGUAGE")%>";

		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.admin.bulletin_list_new_ict","gubun="+gubun+"&quest="+quest+"&company_code="+company_code+"&dept_type="+dept_type+"&view_user_type="+view_user_type+"&language="+language+"&mode=getDataStore&grid_col_id="+grid_col_id);
		GridObj.clearAll(false);
	}

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("<%=text.get("DS_002.MSG_0101")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'SELECTED') return;
		GridObj.SetCellValue("SELECTED", nRow, "1");
	}

	function GridCellClick(strColumnKey ,nRow)
	{

	}

	function initAjax(){
	}

	function doUpdate()
	{
		var sel_row = 0;
		var cnt = 0;
		var c_factor_refitem;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		for(var i = 0; i < grid_array.length; i++)
		{
			sel_row++;
			cnt = grid_array[i];
		}

		if(sel_row == 0) {
			//alert("항목을 선택해주세요.");
			alert("<%=text.get("DS_002.MSG_0101")%>");
			return;
		}
		if(parseInt(sel_row) > 1) {
			//alert('한행만 선택하십시요.');
			alert("<%=text.get("DS_002.MSG_0102")%>");
			return;
		}

		var select_seq = LRTrim(GridObj.cells(cnt, GridObj.getColIndexById("SEQ")).getValue());

		location.href = "data_store_list_upd_ict.jsp?select_seq="+select_seq;
		//window.open("bulletin_list_upd"+"?select_seq=" + select_seq  + "&popup_flag=true","newWin","width="+screen.availWidth+",height=690,resizable=YES, scrollbars=YES, status=yes, top=0, left=0");


	}


	function doInsert()
	{

	}

	function doSaveEnd(obj) {
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		document.getElementById("message").innerHTML = messsage;
		alert(messsage);

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") doSelect();
		else alert(messsage);

		//alert(dhtmlx_start_row_id);
		//alert(dhtmlx_end_row_id);

		return false;
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

	function doDelete()
	{
		//alert("doDelete");

		var sel_row = 0;
		var cnt = 0;
		var c_factor_refitem;

		//if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		for(var i = 0; i < grid_array.length; i++)
		{
			sel_row++;
			cnt = grid_array[i];
		}

		if(sel_row == 0) {
			//alert("항목을 선택해주세요.");
			alert("<%=text.get("DS_002.MSG_0101")%>");
			return;
		}
		if(parseInt(sel_row) > 1) {
			//alert('한행만 선택하십시요.');
			alert("<%=text.get("DS_002.MSG_0102")%>");
			return;
		}



	   if (confirm("<%=text.get("DS_002.0001")%>")){
		    var cols_ids = "<%=grid_col_id%>";

		    myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.admin.bulletin_list_new_ict?cols_ids="+cols_ids+"&mode=setDataStoreDelete");
	 		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
	   }

	}

	function rowinsert()
	{
	}

	function doAddRow()
    {
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



function view_count(seq){

	document.form1.seq.value = seq;

	var jqa = new jQueryAjax();
	jqa.action = "data_store_view_count_update_ict.jsp";
	jqa.submit();
}

function popup(seq)
{
	var url = "data_store_list_popup_new_ict.jsp?seq="+seq;

	CodeSearchCommon(url,'data_store_list_popup_new','0','0','700','600');
	doSelect();
}

function fnFiledown(attach_no){
	var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	var b = "fileDown";
	var c = "300";
	var d = "100";
	 
	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
}



	//-->
	</script>

</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  onload="initAjax();setGridDraw();doSelect();">
<s:header>
<form name="form1" method="post" action="">
<input type="hidden" name="SHIPPER_TYPE" id="SHIPPER_TYPE" value = "D">
<input type="hidden" name="seq" id="seq">
<%	if(! init_flag.equals("true"))
	{ %>
		<%@ include file="/include/sepoa_milestone.jsp"%>
<%	} %>
<table width="99%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5">&nbsp;</td>
	</tr>
</table>
	<%
	//화면이 popup 으로 열릴 경우에 처리 합니다.
	//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
%>

<!-- header start -->   
<table width="100%" border="0" cellspacing="0" cellpadding="1">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
			<tr>
			<td width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<%	if(! init_flag.equals("true")){ %>
				<!--
				<tr><td height="4" colspan="2" bgcolor="51C3E8"></td></tr>
				<tr><td height="5" colspan="2" style="background-image:url(../images/bg_srch.gif); background-repeat:repeat-x"></td></tr>
				<tr><td height="1" colspan="2" bgcolor="E5E2DD"></td></tr>
				-->
			  <%	} %>
				<tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;
		        			       <select name="gubun">
		                                 <option value="S"><%=msg.get("BULLETIN.1002") %><%--제 목--%></option>
		                                 <option value="U"><%=msg.get("BULLETIN.1003") %><%--글쓴이--%></option>
		                                 <option value="D"><%=msg.get("BULLETIN.1004") %><%--작성일--%></option>
		                                 <option value="C"><%=msg.get("BULLETIN.0004") %><%--내용--%></option>
		                               </select>
		               </td>
		            <td width="35%" class="data_td">
			        <input type="text" name="quest" size="40">
			      </td>
			      <td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("DS_002.MSG_8801")%></td>
	              <td width="35%" class="data_td">
		          	<select name="view_user_type" id="view_user_type">
					  <option value=""></option>
						<%
							String VIEW_USER_TYPE = ListBox(request, "SL0018" , info.getSession("HOUSE_CODE")+"#"+"Z001", "X");
							out.println(VIEW_USER_TYPE);
						%>
					</select>
			      </td>
			    </tr>
			    <%-- <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>
				<tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("DS_002.COMPANY_NAME")%>
		               </td>
		            <td class="data_td">
			            <select name="company_code" class="input_re">
										<option value=""></option>
											<%
												String COMPANY_NAME = ListBox(request, "SL0006" , info.getSession("HOUSE_CODE")+"#", info.getSession("COMPANY_CODE"));
												out.println(COMPANY_NAME);
											%>
									</select>
			      </td>
			    </tr>
			    <tr>
					<td colspan="4" height="1" bgcolor="#dedede"></td>
				</tr>				   
				<tr>
		        	<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("DS_002.DEPT_TYPE")%>
		               </td>
		            <td class="data_td">
			            <select name="dept_type" class="input_re">
		                               	<option value=""></option>
											<%
												String DEPART_NAME = ListBox(request, "SL0018" , info.getSession("HOUSE_CODE")+"#M216","");
												out.println(DEPART_NAME);
											%>
									</select>
			      </td>
			    </tr> --%>
			    <input type="hidden" name="dept_type" id="dept_type" value="" />
			    <input type="hidden" name="company_code" id="company_code" value="<%=info.getSession("COMPANY_CODE") %>" />
		                              
		    </table>
			</td>
			</tr>
			</table>
		</td>
	</tr>
</table>
 <!-- header end  -->
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
		<td height="100%" valign="top">
		<table height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<%-- <td width="10" height="100%" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_left.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="10" height="100%"></td> --%>
				<td width="100%" align="center" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_top.gif); background-repeat:repeat-x; background-position:top; padding:5px;word-breakbreak-all">
	    
				    <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
						<TR>
							<td>
							<TABLE cellpadding="2" cellspacing="0">
							  <TR>
								<TD valign="center">
								
								<%-- <input type=button value="<%=msg.get("BULLETIN.1005")%>" onClick="javascript:doSelect()" name="button2"> --%>
			                    <script language="javascript">btn("javascript:doSelect()","<%=msg.get("BULLETIN.1005")%>")</script>
			                    </td>
			                    <%-- <%if(! info.getSession("USER_TYPE").equals("S") && info.getSession("IS_ADMIN_USER").equals("true")) { %> --%>
								<td><script language="javascript">btn("javascript:doUpdate()","<%=text.get("DS_002.button_update")%>")</script></td>
								<td><script language="javascript">btn("javascript:doDelete()","<%=text.get("DS_002.button_delete")%>")</script></td>			                            	
			                   <%--  <% } %>		 --%>			
							  </TR>
						    </TABLE>
						  </td>
					  	</TR>
					</TABLE>			                                
           
			</td>
		</tr>
		<%--
		<tr align="center">
				<td height="40" colspan="2">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
				              <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
				              <div id="pagingArea"></div>
						</td>
					</tr>
						<%@ include file="/include/include_bottom.jsp"%>
				
				</table> 
				</td>
			</tr>
		--%>
		</table>
	</td>
	<td width="11" valign="top" bgcolor="FFFFFF" style="background-image:url(../images<%=this_image_folder_name%>bg_main_right.gif); background-repeat:no-repeat; background-position:top;"><img src="../images/blank.gif" width="11" height="100%"></td>
</tr>
</table>

<input type="hidden" name="qu22est" class="input_empty_white" size="1">
</form>

<!-- <iframe name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe> -->

<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=300"/>
</jsp:include> --%>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>
