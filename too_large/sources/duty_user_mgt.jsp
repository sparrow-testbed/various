<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_116");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
    HashMap text = MessageUtil.getMessage(info,multilang_id);

	String house_code = JSPUtil.paramCheck(info.getSession("HOUSE_CODE"));
	String company_code = JSPUtil.paramCheck(info.getSession("COMPANY_CODE"));

	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_116";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;

	// 화면에 행머지기능을 사용할지 여부의 구분
	isRowsMergeable = true;
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<Script language="javascript">

var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.duty_user_mgt";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;
var click_row = "";

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
}

<%--  /* 입력한 controll_code 에 대한 내용을 쿼리해 온다.*/ --%>
function Query() {
    var frm = document.forms[0];
	frm.i_ctrl_code.value      = LRTrim(frm.i_ctrl_code.value.toUpperCase());
	frm.i_ctrl_person_id.value = LRTrim(frm.i_ctrl_person_id.value.toUpperCase());

	var i_ctrl_code       = frm.i_ctrl_code.value;
	var i_company_code    = frm.i_company_code.value;
	var i_ctrl_type       = frm.i_ctrl_type.value;
	var i_ctrl_person_id  = frm.i_ctrl_person_id.value ;

	if( isNull(i_company_code) ) {
    	//alert("회사코드를 입력해주세요.");
    	alert("<%=text.get("AD_116.MSG_0100")%>");
    	return;
    }

	<%-- if( isNull(i_ctrl_person_id) && isNull(i_ctrl_type) ) {
		//alert("직무형태 또는 직무담당자를 입력해주세요.");
		alert("<%=text.get("AD_116.MSG_0101")%>");
		return ;
	}
 --%>
	frm.select_flag.value = "Y";
	frm.insert_flag.value = "off";
	frm.usedpopup.value = "off";

	var grid_col_id = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL;
	var params = "mode=query&grid_col_id="+grid_col_id+
	                                 "&i_company_code="+encodeUrl(i_company_code)+
	                                 "&i_ctrl_code="+encodeUrl(i_ctrl_code)+
	                                 "&i_ctrl_type="+encodeUrl(i_ctrl_type)+
	                                 "&i_ctrl_person_id="+encodeUrl(i_ctrl_person_id);
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);
}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	if(status == "false") alert(msg);

	if(LRTrim(document.forms[0].i_ctrl_code.value) == "") {
		document.forms[0].text_ctrl_code.value = "";
	}

	if(LRTrim(document.forms[0].i_ctrl_person_id.value) == "") {
		document.forms[0].text_ctrl_person_id.value = "";
	}

	return true;
}
function doOnRowSelected(rowId, cellInd)
{
	if(GridObj.getColIndexById("CTRL_PERSON") == cellInd) {
		click_row = rowId;

		var i_company_code = SepoaGridGetCellValueId(GridObj, rowId, "COMPANY_CODE");
       	var gubun          = SepoaGridGetCellValueId(GridObj, rowId, "GUBUN");

       	if(gubun == "U") {
			//alert("생성시에만 하실 수 있습니다.");
			alert("<%=text.get("AD_116.MSG_0111")%>");
			return false;
		}

		window.open("duty_user_transform.jsp?popup_flag=true&i_company_code="+i_company_code, "pop_up","status=yes, resizable=yes width=800 height=470");
	} else if(GridObj.getColIndexById("CTRL_TYPE_IMG") == cellInd) {
		click_row = rowId;

		if(SepoaGridGetCellValueId(GridObj, rowId, "GUBUN") != "I" ) {
        	return false;
    	}

    	var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0257&function=setCtrlType&values=<%=house_code%>&values=M080&values=&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
	} else if(GridObj.getColIndexById("CTRL_CODE_IMG") == cellInd) {
		click_row = rowId;

		var i_company_code = SepoaGridGetCellValueId(GridObj, rowId, "COMPANY_CODE");
        var i_ctrl_type    = SepoaGridGetCellValueId(GridObj, rowId, "CTRL_TYPE");

        if(SepoaGridGetCellValueId(GridObj, rowId, "GUBUN") != "I" ) {
        	return false;
    	}

    	if(isNull(i_ctrl_type)) {
       		//alert("직무형태를 선택해주세요.");
       		alert("<%=text.get("AD_116.MSG_0112")%>");
       		return;
        }
		var arrv = new Array('000' ,i_company_code, i_ctrl_type, "", "");
		PopupCommonArr("SP9013", "setWTCtrlCode", arrv, "" );
	}
}

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

function Line_insert() {
    var frm = document.forms[0] ;
	var i_company_code    = frm.i_company_code.value;
	var i_ctrl_type       = frm.i_ctrl_type.value;
	var ctrl_type_name    = frm.i_ctrl_type.options[frm.i_ctrl_type.selectedIndex].text;

	if( isNull(i_company_code) ) {
		//alert("회사코드를 선택해주세요.");
		alert("<%=text.get("AD_116.MSG_0102")%>");
		return;
	}

	var i_ctrl_code = frm.i_ctrl_code.value;
	var select_flag = frm.select_flag.value;
	var insert_flag = frm.insert_flag.value;

	if( isNull(select_flag) ) {
		//alert("조회먼저 하고 생성버튼을 누르세요.");
		alert("<%=text.get("AD_116.MSG_0103")%>");
		frm.i_ctrl_code.focus();
	}

	dhtmlx_last_row_id++;
   	var nMaxRow2 = dhtmlx_last_row_id;
	GridObj.enableSmartRendering(true);
	GridObj.addRow(nMaxRow2, "", GridObj.getRowIndex(nMaxRow2));
   	GridObj.selectRowById(nMaxRow2, false, true);
   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("SELECTED")).setValue("1");
   	GridObj.cells(nMaxRow2, GridObj.getColIndexById("COMPANY_CODE")).setValue(i_company_code);

	if(isNull(i_ctrl_type)) {
		SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_TYPE_IMG", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon_2.gif");
	} else {
    	SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_TYPE_NAME", ctrl_type_name);
    	SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_TYPE", i_ctrl_type);
    	SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_TYPE_IMG", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
	}

	SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_CODE_IMG", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon_2.gif");
	SepoaGridSetCellValueId(GridObj, nMaxRow2, "CTRL_PERSON", "<%=POASRM_CONTEXT_NAME%>/images/button/query.gif");
	SepoaGridSetCellValueId(GridObj, nMaxRow2, "GUBUN", "I");
	frm.insert_flag.value = "on";
}

function lineInsert(pp_next_id, pp_next_name, pp_next_tel) {
	var count = 0;
	if(count == 0) {
		SepoaGridSetCellValueId(GridObj, click_row, "CTRL_PERSON_ID", pp_next_id);
		SepoaGridSetCellValueId(GridObj, click_row, "CTRL_PERSON_NAME_LOC", pp_next_name);
		SepoaGridSetCellValueId(GridObj, click_row, "PHONE_NO", pp_next_tel);
		SepoaGridSetCellValueId(GridObj, click_row, "GUBUN", "I");
	}
}

function doInsert() {
	var sel_cnt = 0 ;
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");

	for(var i=0; i < grid_array.length; i++)
	{
		if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SELECTED") == "true" ) {
		    if(isNull(SepoaGridGetCellValueId(GridObj, grid_array[i], "CTRL_TYPE"))) {
    			//alert("직무형태를 선택해야 합니다.");
    			alert("<%=text.get("AD_116.MSG_0104")%>");
    			return;
		    }

		    if(isNull(SepoaGridGetCellValueId(GridObj, grid_array[i], "CTRL_CODE"))) {
    			//alert("직무코드를 선택해야 합니다.");
    			alert("<%=text.get("AD_116.MSG_0105")%>");
    			return;
		    }

		    if(isNull(SepoaGridGetCellValueId(GridObj, grid_array[i], "CTRL_PERSON_ID")) ) {
    			//alert("팝업화면을 뛰워서 담당자를 선택해야 합니다.");
    			alert("<%=text.get("AD_116.MSG_0106")%>");
    			return;
		    }

		    if(SepoaGridGetCellValueId(GridObj, grid_array[i], "GUBUN") != "I" ) {
		        //alert("행삽입건만 등록 가능합니다.") ;
		        alert("<%=text.get("AD_116.MSG_0107")%>");
		        return;
		    }

		    sel_cnt++;
		}
	}

	if ( sel_cnt <= 0 ) {
		//alert(sel_cnt);
		//alert("grid_array"+grid_array.length);
		//alert("등록할 항목이 없습니다.");
		alert("<%=text.get("AD_116.MSG_0108")%>");
		return;
	}

	var cols_ids    = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL +
	                  "?mode=setInsert&cols_ids="+cols_ids;
   	myDataProcessor = new dataProcessor(SERVLETURL);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

function doDelete() {
	var sel_cnt = 0 ;
	var grid_array  = getGridChangedRows(GridObj, "SELECTED");

	for(var i=0; i < grid_array.length; i++)
	{
		if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SELECTED") == "true" ) {
		    sel_cnt++ ;
		}
	}

	if ( sel_cnt <= 0 ) {
		//alert("항목을 선택해주세요.");
		alert("<%=text.get("AD_116.MSG_0109")%>");
		return;
	}

    var sel_del_cnt = 0 ;

    for(var i=grid_array.length-1; i >= 0; i--)
	{
		if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SELECTED") == "true" ) {
			if(SepoaGridGetCellValueId(GridObj, grid_array[i], "GUBUN") == "I" ) {
				GridObj.deleteRow(grid_array[i]);
				sel_del_cnt++ ;
			}
		}
	}

	if ( sel_cnt == sel_del_cnt ) {
	    return ;
	}

	//if ( !confirm("정말로 삭제하시겠습니까?") ) {
	if(!confirm("<%=text.get("AD_116.MSG_0110")%>")) {
	    return ;
	}

	var cols_ids    = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL +
	                  "?mode=setDelete1&cols_ids="+cols_ids;
   	myDataProcessor = new dataProcessor(SERVLETURL);
	sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
}

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
		Query();
	} else {
		alert(messsage);
	}

	return false;
}

<%--  /*팝업화면.*/ --%>
function SP9013_getCode(code, text, type) {
	document.forms[0].i_ctrl_code.value = code;
	document.forms[0].text_ctrl_code.value = text;
	document.forms[0].usedpopup.value = "on";
}

function searchProfile(fc) {
    var frm = document.forms[0] ;
    var url = "";
    if ( fc == "i_ctrl_code" ) {
    	var i_company_code    = frm.i_company_code.value;
    	if( isNull(i_company_code) ) {
    		//alert("회사코드를 선택해주세요.");
    		alert("<%=text.get("AD_116.MSG_0102")%>");
    		return;
    	}
        //PopupCommon2("SP0256", "setCtrlCode", "", i_company_code, "", "" );
        var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0256&function=setCtrlCode&values=&values=i_company_code&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }
    else if ( fc == "i_ctrl_person_id" ) {
    	var i_company_code = frm.i_company_code.value;
    	if( isNull(i_company_code) ) {
    		//alert("회사코드를 선택해주세요.");
    		alert("<%=text.get("AD_116.MSG_0102")%>");
    		return;
    	}
        //PopupCommon2("SP0255", "setCtrlPerson", "", i_company_code, "", "" );
        var url3 = "<%=POASRM_CONTEXT_NAME%>/common/grid_cm_list.jsp?code=SP0255&function=setCtrlPerson&values=&values=i_company_code&values=&width=700";
       	Code_Search(url3, '', '', '', '720', '500');
    }
}

function setCtrlType(code, text2) {
	SepoaGridSetCellValueId(GridObj, click_row, "CTRL_TYPE_IMG", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
    SepoaGridSetCellValueId(GridObj, click_row, "CTRL_TYPE_NAME", text2);
    SepoaGridSetCellValueId(GridObj, click_row, "CTRL_TYPE", code);
}

function setWTCtrlCode(code, text2) {
	SepoaGridSetCellValueId(GridObj, click_row, "CTRL_CODE_NAME", text2);
    SepoaGridSetCellValueId(GridObj, click_row, "CTRL_CODE", code);
    SepoaGridSetCellValueId(GridObj, click_row, "CTRL_CODE_IMG", "<%=POASRM_CONTEXT_NAME%>/images/icon/icon.gif");
}

function setCtrlCode(code, text1) {
    document.forms[0].i_ctrl_code.value = code  ;
    document.forms[0].text_ctrl_code.value = text1 ;
}

function setCtrlPerson(code, text1) {
    document.forms[0].i_ctrl_person_id.value = code  ;
    document.forms[0].text_ctrl_person_id.value = text1 ;
}

function entKeyDown() {
	if(event.keyCode==13) {
		window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
		Query();
	}
}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();">
<s:header>
<form name="form1" method="post" action="">
<input type="hidden" size="5" value="off" name="insert_flag">
<input type="hidden" size="12" value="" name="select_flag">
<input type="hidden" value="off" name="usedpopup">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<%
		//화면이 popup 으로 열릴 경우에 처리 합니다.
		//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
		String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
		if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	%>
	<%@ include file="/include/include_top.jsp"%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_116.TEXT1")%></td>
        		<td width="30%" height="24" class="data_td">
					<select name="i_company_code" class="input_re">
			        &nbsp;	<option value= ""><%=text.get("AD_116.SELECTED")%></option>
						<%
							String lb = ListBox(request, "SL0006",info.getSession("HOUSE_CODE")+"#", company_code);
						   	out.println(lb);
						%>
				    </select>
				    <input type="text" size="1" value="" name="i_ctrl_code" class="input_empty">
				    <input type="text" size="2" value="" name="text_ctrl_code" class="input_empty" readonly>
				</td>
			  	<td width="20%" height="24" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;<%=text.get("AD_116.CTRL_TYPE")%></td>
        		<td width="30%" height="24" class="data_td">
					<select name="i_ctrl_type" class="input_re">
			        &nbsp;  <option value= ""><%=text.get("AD_116.SELECTED")%></option>
					    <%
					    	String com4 = ListBox(request, "SL0018",info.getSession("HOUSE_CODE")+"#M080", "");
					        out.println(com4);
					    %>
			    	</select>
					

			    	<input type="text" size="1" value="" name="i_ctrl_person_id" class="input_empty" readonly>
				    <input type="text" size="1" value="" name="text_ctrl_person_id" class="input_empty" readonly> 
					</td>
			</tr>
			</table>
			</td>
                		</tr>
            		</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
							<td><script language="javascript">btn("javascript:Query()","<%=text.get("BUTTON.search")%>")</script></td>
							<TD><script language="javascript">btn("javascript:Line_insert()","<%=text.get("BUTTON.rowinsert")%>")</script></TD>
			    	  		<TD><script language="javascript">btn("javascript:doInsert()","<%=text.get("BUTTON.insert")%>")</script></TD>
							<TD><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></TD>
						</TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			  
             <%-- <%@ include file="/include/include_bottom.jsp"%> --%>
			</td>
		  </tr>
		</table>
	</form>
<%-- <jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=220"/>
</jsp:include> --%>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div> 
<s:footer/>
</body>
</html>
