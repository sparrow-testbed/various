<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("AD_117");
	multilang_id.addElement("BUTTON");
    HashMap text = MessageUtil.getMessage(info,multilang_id);
    
	String i_house_code = JSPUtil.paramCheck(request.getParameter("i_house_code"));
	String i_company_code = JSPUtil.paramCheck(request.getParameter("i_company_code"));
	String mode = JSPUtil.paramCheck(request.getParameter("mode"));
	
	// Dthmlx Grid 전역변수들..
	String screen_id = "AD_117";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = true;
%>

<html>
<head>
<title>우리은행 전자구매시스템</title>



<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>

<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.duty_user_transform";

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;
var click_row = "";

function setGridDraw()
{
	<%=grid_obj%>_setGridDraw();
	GridObj.setSizes();
	//document.form1.i_user_name_loc.focus();
}

function doSelect() {
	document.forms[0].i_user_id.value = document.forms[0].i_user_id.value.toUpperCase();
	var i_user_id = document.forms[0].i_user_id.value;
	var i_user_name_loc = document.forms[0].i_user_name_loc.value;
	document.forms[0].i_dept.value = document.forms[0].i_dept.value.toUpperCase();
	var i_dept = document.forms[0].i_dept.value;

	if(i_user_id == "" && i_user_name_loc == "" && i_dept == "") {
		alert("조회조건중 하나라도 입력해야 합니다.");
		<%-- alert("<%=text.get("AD_117.MSG_0100")%>"); --%>
		return;
	}
	
	var grid_col_id = "<%=grid_col_id%>";
	var SERVLETURL  = G_SERVLETURL;
	var params = "mode=query&grid_col_id="+grid_col_id+
	                                 "&i_house_code="+encodeUrl("<%=i_house_code%>")+
	                                 "&i_company_code="+encodeUrl("<%=i_company_code%>")+
	                                 "&i_user_id="+encodeUrl(i_user_id)+
	                                 "&i_user_name_loc="+encodeUrl(i_user_name_loc)+
	                                 "&i_dept="+encodeUrl(i_dept);
	GridObj.post(SERVLETURL,params);
	GridObj.clearAll(false);

}

function doQueryEnd(GridObj, RowCnt)
{
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");
	
	if(status == "false") alert(msg);
	
	return true;
}
function doOnRowSelected(rowId, cellInd)
{
	
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

function Confirm() {
	var sel_row = "";
	var grid_array  = getGridChangedRows(GridObj, "SEL");
	
	if("<%=i_company_code%>" == ""){
		for(var i=0; i < grid_array.length; i++) 
		{
			if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SEL") == "true" ) {
				sel_row += grid_array[i]+"&" ;
				pp_next_id = SepoaGridGetCellValueId(GridObj, grid_array[i], "USER_ID");
				pp_next_name = SepoaGridGetCellValueId(GridObj, grid_array[i], "USER_NAME_LOC");
				opener.setName(pp_next_name, pp_next_id);
			}
		}
	} else {
		for(var i=0; i < grid_array.length; i++) 
		{
			if(SepoaGridGetCellValueId(GridObj, grid_array[i], "SEL") == "true" ) {
				sel_row += grid_array[i]+"&" ;
				pp_next_id = SepoaGridGetCellValueId(GridObj, grid_array[i], "USER_ID");
				pp_next_name = SepoaGridGetCellValueId(GridObj, grid_array[i], "USER_NAME_LOC");
				pp_next_tel = SepoaGridGetCellValueId(GridObj, grid_array[i], "PHONE_NO");
				opener.lineInsert(pp_next_id,pp_next_name,pp_next_tel);
			}
		}
	}
	
	if(sel_row == "") {
		alert("항목을 선택해 주세요");
		<%-- alert("<%=text.get("AD_117.MSG_0101")%>"); --%>
		return;
	}
	
	window.close();
}

</script>
</head>

<body leftmargin="15" topmargin="6" onload='setGridDraw();'>
<s:header popup="true">
<form name="form1" method="post" action="">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<%
		//화면이 popup 으로 열릴 경우에 처리 합니다.
		//아래 this_window_popup_flag 변수는 꼭 선언해 주어야 합니다.
		String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
		if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";
	%>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
        		<td width="20%" height="24" class="se_cell_title">사용자ID</td>
        		<td width="30%" height="24" class="se_cell_data">
        			<input type="text" name="i_user_id" size="15" value="" class="input_submit">
        		</td>
			  	<td width="20%" height="24" class="se_cell_title">이름</td>
        		<td width="30%" height="24" class="se_cell_data">
	            	<input type="text" name="i_user_name_loc" size="15" value="" class="input_submit" style="ime-mode:active">
	    		</td>
	    	  </tr>
	    	  <tr>
	    	    <td width="20%" height="24" class="se_cell_title">부서코드</td>
	    	    <td width="30%" height="24" class="se_cell_data" colspan="3">
	            	<input type="text" name="i_dept" size="15" value="" class="input_submit" style="ime-mode:active">
	            </td>
	          </tr>
	          </table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					    <TR>
							<TD><script language="javascript">btn("javascript:doSelect()","<%=text.get("BUTTON.search")%>")</script></TD>
				        	<TD><script language="javascript">btn("javascript:Confirm()","<%=text.get("BUTTON.confirm")%>")</script></TD>
				   			<TD><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></TD>
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
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<s:footer/>
</body>
</html>