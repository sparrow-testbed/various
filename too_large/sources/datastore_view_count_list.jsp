<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp" %>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ taglib prefix="s" uri="/sepoa"%>
<%
    String seq = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("seq")));

	String language = info.getSession("LANGUAGE") ;
 	Vector multilang_id = new Vector();
 	multilang_id.addElement("BUTTON");
	multilang_id.addElement("BULLETIN2");
	multilang_id.addElement("BULLETIN");
	HashMap text = MessageUtil.getMessage(info, multilang_id);

	// Dthmlx Grid 전역변수들..
	String screen_id = "BULLETIN2";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
 %>

<html>
<head>



<%@ include file="/include/sepoa_scripts.jsp"%>
<link rel="stylesheet" href="../css/sec.css" type="text/css">

<style type="text/css">
.input_empty_file2 { background-color:#FFFFFF; border-bottom:solid #FFFFFF 0px;border-left:solid #FFFFFF 0px;border-right:solid #FFFFFF 0px;border-top:solid #FFFFFF 0px;font-size:12px; font-family:돋움; height:19px;color:555555;}
.input_empty_file3 { background-color:#FFFFFF; border-bottom:solid #FFFFFF 0px;border-left:solid #FFFFFF 0px;border-right:solid #FFFFFF 0px;border-top:solid #FFFFFF 0px;font-size:12px; font-family:돋움; height:19px;color:555555; text-align:right}
.radio_file {border: 0px}
</style>


<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>

<%@ include file="/include/include_css.jsp"%>
<script language=javascript src="../js/lib/sec.js"></script>


<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language="JavaScript">
<!--
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

    	//20번 Column By Formatting DateFormat의 경우 최초 데이터 가지고 오는 시점에도 2008/01/01로 가지고 와야만 포맷작업이 됩니다.
    	//2008010로 값을 가지고 오면 포맷작업이 안 이루어 지네요 ㅋㅋ..
    	//GridObj.setNumberFormat(nfCaseQty, GridObj.getColIndexById("add_amt"));
    	//GridObj.setDateFormat("%Y/%m/%d");

	    //GridObj.attachHeader("<div id='all_check_flt'></div>,#rspan,#rspan,#rspan,<div id='title_flt'></div>,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
	    //document.getElementById("title_flt").appendChild(document.getElementById("title_flt_box").childNodes[0]);
		//document.getElementById("all_check_flt").appendChild(document.getElementById("all_check_flt_box").childNodes[0]);
		GridObj.setSizes();
		//24번 Grid 합계 기능
		//GridObj.attachFooter("Total quantity,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,<div id='add_amt'>0</div>,#cspan,#cspan,",["text-align:left;"]);

		//18번 Column Visible Hidden, true, false 로 결정.
		//21번 Column Name By Index GridObj.getColIndexById("add_date") 인덱스 값이 리턴됩니다.
		// GridObj.setColumnHidden(GridObj.getColIndexById("status"), true);

		//23번 컬럼이동
		//GridObj.enableMultiline(true);
		//GridObj.enableColumnMove(true);

		//24번 Grid 중계 기능
		//GridObj.enableCollSpan(true);
		//GridObj.enableSmartRendering(true, 500);
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
    	//24번 Grid 소계, 중계, 합계 기능
    	//var sum_add_amt = document.getElementById("add_amt");
		//sum_add_amt.innerHTML = sumColumn(GridObj.getColIndexById("add_amt"));
		var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");
		//alert("msg]"+msg);

		if(status == "false") alert(msg);
		return true;
    }

function doQuery()
{
		var seq = "<%=seq%>";
		var user_name = encodeUrl(LRTrim(document.form1.user_name.value));
		var company_name = encodeUrl(LRTrim(document.form1.company_name.value));
		var user_gubun = encodeUrl(LRTrim(document.form1.user_gubun.value));
		var user_ip = encodeUrl(LRTrim(document.form1.user_ip.value));
		var grid_col_id = "<%=grid_col_id%>";
		var language = "<%=info.getSession("LANGUAGE")%>";

		<%-- GridObj.loadXML("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.bulletin_view_count_list?seq="+seq+"&user_name="+user_name+"&company_name="+company_name+"&user_gubun="+user_gubun+"&user_ip="+user_ip+"&mode=query&grid_col_id="+grid_col_id+"&language="+language); --%>
		GridObj.post("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.bulletin_view_count_list","seq="+seq+"&user_name="+user_name+"&company_name="+company_name+"&user_gubun="+user_gubun+"&user_ip="+user_ip+"&mode=dataStore_query&grid_col_id="+grid_col_id+"&language="+language);
		GridObj.clearAll(false);
}

function doOnRowSelected(rowId,cellInd)
   {
   	//alert(GridObj.cells(rowId, cellInd).getValue());
   	//alert(GridObj.getColumnId(cellInd));

   	var header_name = GridObj.getColumnId(cellInd);
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

function initAjax(){
	doRequestUsingPOST( 'SL5001', 'M726' ,'user_gubun', '' );
}

//-->
</script>
</head>

<body leftmargin="15" topmargin="6"  onload="initAjax();setGridDraw();doQuery();">
<s:header popup="true">
<form name="form1">
<input type="hidden" name="seq">
<%
	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("BULLETIN.TXT_001");
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
        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("BULLETIN.TXT_002")%></td>
        		<td width="30%" height="24" class="se_cell_data"><input type="text" name="user_name" value="" size="15"></td>
        		<td width="20%" height="24" align="right" class="se_cell_title"><%=text.get("BULLETIN.TXT_003")%></td>
        		<td width="35%" height="24" class="se_cell_data">
					<input type="text" name="company_name" value="" size="15">
				</td>
			  </tr>
		      <tr>
		        <td width="20%" height="24" align="right" class="se_cell_title">
					<%=text.get("BULLETIN.TXT_005")%>
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<select name="user_gubun" id="user_gubun" class="inputsubmit">
						<option value=""><%=text.get("BULLETIN.all")%></option>
					</select>
				</td>
				<td width="20%" height="24" align="right" class="se_cell_title">
					IP Address
				</td>
				<td width="30%" height="24" class="se_cell_data">
					<input type="text" name="user_ip" value="" size="15">
				</td>
			  </tr>
			  </table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
							<td><script language="javascript">btn("javascript:window.close()","<%=text.get("BUTTON.close")%>")</script></td>
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

<!-- <iframe name="childFrame" WIDTH="0" Height="0" border="0" scrolling="no" frameborder="0"></iframe> -->
<!--
<jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=170"/>
</jsp:include>
-->

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>