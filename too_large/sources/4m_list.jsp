<%
/**
 * @파일명   : 4m_list.jsp
 * @생성일자 : 2009. 04. 24
 * @변경이력 :
 * @프로그램 설명 : 변경점사전신고서 현황
 */
%>

<%@ page contentType = "text/html; charset=UTF-8" %>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-30);
	String to_date = to_day;
	String req_flag = JSPUtil.nullToEmpty(request.getParameter("req_flag"));

	Vector multilang_id = new Vector();
	multilang_id.addElement("QM_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");

	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String company_code = info.getSession("COMPANY_CODE");
	String company_name = info.getSession("COMPANY_NAME");
	String user_type    = info.getSession("USER_TYPE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "QM_006";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;

	boolean isBuyer = false;
	boolean isSupplier = false;

	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";

	if(!user_type.equals("S")) {
		isBuyer = true;
		company_code = "";
	}
	else
		isSupplier = true;

	Config conf = new Configuration();
    String buyer_company_code = conf.getString("sepoa.buyer.company.code");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>

<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/sec.js"></script>

<script src="../js/cal.js" language="javascript"></script>

<script language="javascript" src="../ajaxlib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>



<Script language="javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.qm.m4m_list";

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;
var click_row = "";

	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();

    	<% if( isSupplier ){ %>
    		GridObj.setColumnHidden(GridObj.getColIndexById("SELLER_CODE"), true);
			GridObj.setColumnHidden(GridObj.getColIndexById("SELLER_NAME"), true);
    	<% } %>

    }

	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }

    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    }

    // doQuery 종료 시점에 호출 되는 이벤트 입니다. 인자값은 그리드객체 및 전체행숫자 입니다.
    // GridObj.getUserData 함수는 서블릿에서 message, status, data_type, setUserObject 시점에 값을 읽어오는 함수 입니다.
    // setUserObject Name 값은 0, 1, 2... 이렇게 읽어 주시면 됩니다.
    function doQueryEnd(GridObj, RowCnt)
    {
    	var msg        = GridObj.getUserData("", "message");
		var status     = GridObj.getUserData("", "status");
		//var data_type  = GridObj.getUserData("", "data_type");
		//var zero_value = GridObj.getUserData("", "0");
		//var one_value  = GridObj.getUserData("", "1");
		//var two_value  = GridObj.getUserData("", "2");

		if(status == "false") alert(msg);
		return true;
    }

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	var REQ_NUMBER  = "";
    	var SELLER_CODE = "";
    	var SELLER_NAME = "";
    	var REQ_DATE    = "";
    	var REQ_STATUS  = "";
    	var REQ_FLAG    = "";

    	if(GridObj.getColIndexById("CP_NUMBER") == cellInd) {
			click_row = rowId;
			CP_NUMBER  = GridObj.cells(rowId, cellInd).getValue();
	    	SELLER_CODE = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_CODE")).getValue();
	    	SELLER_NAME = GridObj.cells(rowId, GridObj.getColIndexById("SELLER_NAME")).getValue();

	    	//LOSS_REQ_STATUS  = "A";
	    	//LOSS_REQ_DATE  = GridObj.cells(rowId, GridObj.getColIndexById("LOSS_REQ_DATE")).getValue();

	    	var url = "/qm/4m_mgt.jsp?cp_number="+ encodeUrl(CP_NUMBER)+
	    	                                  "&popup_flag=true";

    		var window_title = "4m_mgt";
    		openPopupWindow(url, window_title, 900, 600);
		} else if(GridObj.getColIndexById("SELLER_CODE") == cellInd) {
			SELLER_CODE = GridObj.cells(rowId, cellInd).getValue();
			openSellerInfo(SELLER_CODE);
		}
    }

    function setVendorCode(code, text1, text2) {
		SepoaGridSetCellValueId(GridObj, click_row, "SELLER_NAME", text1);
	    SepoaGridSetCellValueId(GridObj, click_row, "SELLER_CODE", code);
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
			if(GridObj.getColIndexById("MATERIAL_NUMBER") == cellInd && max_value.length > 0) {
				GridCell_Material_doRequestUsingPOST('SL8892', max_value ,'DESCRIPTION_LOC', 'UNIT_MEASURE', rowId);
			}

			return true;
		}

		return false;
    }

    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{

		var cp_date_gubun	= LRTrim(document.forms[0].cp_date_gubun.value);
		var cp_from_date	= LRTrim(document.forms[0].cp_from_date.value);
		var cp_to_date	= LRTrim(document.forms[0].cp_to_date.value);

		var cp_status	= LRTrim(document.forms[0].cp_status.value);
		var cp_type	= LRTrim(document.forms[0].cp_type.value);
		var model	= LRTrim(document.forms[0].model.value);
		var ctrl_code	= LRTrim(document.forms[0].ctrl_code.value);

		var seller_code		= LRTrim(document.forms[0].seller_code.value);

		if(!checkDateCommon(cp_from_date)) {
			alert("<%=text.get("QM_006.0001")%>");
			document.forms[0].cp_from_date.focus();
			return;
		}

	 	if(!checkDateCommon(cp_to_date)) {
	  		alert("<%=text.get("QM_006.0002")%>");
	  		document.forms[0].cp_to_date.focus();
	  		return;
	 	}

		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=query&grid_col_id="+grid_col_id+
	                                     "&cp_date_gubun="+cp_date_gubun+
	                                     "&cp_from_date="+cp_from_date+
	                                     "&cp_to_date="+cp_to_date+
	                                     "&cp_status="+cp_status+
	                                     "&cp_type="+cp_type+
	                                     "&model="+model+
	                                     "&ctrl_code="+ctrl_code+
	                                     "&seller_code="+seller_code;

		GridObj.post(SERVLETURL);
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

		alert("<%=text.get("QM_006.0006")%>");
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{
		if(strColumnKey  == 'SELECTED') return;
		GridObj.SetCellValue("SELECTED", nRow, "1");
	}

	function initAjax() {
		doRequestUsingPOST( 'SL5001', 'M512' ,'cp_type', '' );
		doRequestUsingPOST( 'SL5001', 'M513' ,'cp_status', '' );
	}


	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
		var messsage = obj.getAttribute("message");
		var mode     = obj.getAttribute("mode");
		var status   = obj.getAttribute("status");
		var req_number = "";

		document.getElementById("message").innerHTML = messsage;

		myDataProcessor.stopOnError = true;

		if(dhxWins != null) {
			dhxWins.window("prg_win").hide();
			dhxWins.window("prg_win").setModal(false);
		}

		if(status == "true") {
			alert(messsage);
			doQuery();
		} else {
			alert(messsage);
		}

		return false;
	}


    function PopupManager(objForm, name)
	{
		if(name == "seller_code")
		{
			window.open("/common/CO_014.jsp?callback=SP0054_getCode", "SP0054", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=500,height=550,left=0,top=0");
		}
	}

	function SP0054_getCode(code, text1, text2) {
		document.forms[0].seller_code.value = code;
	}

		<%
	/**
	 * @메소드명 : SP0216_Popup
	 * @생성일자 : 2009. 05. 06
	 * @작성자   : 전선경
	 * @변경이력 :
	 * @메소드 설명 : 변경점사전신고서 등록 > 구매담당자 팝업
	 */
	%>
   function SP0216_Popup() {
		var left = 0;
		var top = 0;
		var width = 540;
		var height = 500;
		var toolbar = 'no';
		var menubar = 'no';
		var status = 'yes';
		var scrollbars = 'no';
		var resizable = 'no';
		var buyer_company_code = '<%=isSupplier ? buyer_company_code : info.getSession("COMPANY_CODE")%>';

		var url = "<%=POASRM_CONTEXT_NAME%>/common/cm_list1.jsp?code=SP0216&function=SP0216_getCode&values=<%=buyer_company_code%>&values=&values=";
		//var doc = window.open( url, 'doc', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
		Code_Search(url, 'sp0216', '', '', '', '');
	}

	function SP0216_getCode(ls_ctrl_code, ls_ctrl_name) {

		document.forms[0].ctrl_code.value = ls_ctrl_code;
		document.forms[0].ctrl_name.value = ls_ctrl_name;

	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<form name="form">
    <%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
		      <tr>
		      	<td height="24" class="se_cell_title">
		      		<select name="cp_date_gubun" class="inputsubmit">
						<option value="A" selected><%=text.get("QM_006.TXT_ADD_DATE")%></option>
						<option value="P" ><%=text.get("QM_006.TXT_APP_DATE")%></option>
					</select>
				</td>
        		<td height="24" class="se_cell_data">
					<input type="text" name="cp_from_date" size="8" class="inputsubmit" maxlength="8" value="<%=from_date%>">
				    <img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, cp_from_date , 'yyyy/mm/dd')">~
				    <input type="text" name="cp_to_date" size="8" class="inputsubmit" maxlength="8" value="<%=to_date%>">
				    <img src="../images/button/butt_calender.gif" width="19" height="19" align="absmiddle" border="0" style="cursor: hand" onClick="popUpCalendar(this, cp_to_date , 'yyyy/mm/dd')">
				</td>

				<td  height="24" class="se_cell_title">
        			<%=text.get("QM_006.TXT_COMPANY_CODE")%>
        		</td>
        		<td width="20%" height="24" class="se_cell_data">
        			<input type="text" name="seller_code" size="12" class="input_re" maxlength="20" value="<%=company_code%>" readonly>
        			<%if( isBuyer ){%>
        			<a href="javascript:PopupManager(document.forms[0],'seller_code')"><img src="../images/button/query.gif" align="absmiddle" border="0" alt=""></a>
        		    <%}%>
        		</td>

				<td  height="24" class="se_cell_title">
        			<%=text.get("QM_006.TXT_CTRL_CODE")%>
        		</td>
        		<td  height="24" class="se_cell_data">
        			<input type="text" name="ctrl_code" size="7" maxlength="15" class="inputsubmit">
					<a href="javascript:SP0216_Popup()"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
					<input type="hidden" name="ctrl_name" size="7" readonly class="input_empty" >

        		</td>

	          </tr>
	          <tr>
        		<td  height="24" class="se_cell_title"><%=text.get("QM_006.TXT_CP_STATUS")%></td>
        		<td  height="24" class="se_cell_data">
					<select name="cp_status" class="inputsubmit">
						<option><%=text.get("QM_006.all")%></option>
					</select>
				</td>
				<td  height="24" class="se_cell_title">
        			<%=text.get("QM_006.TXT_MODEL")%>
        		</td>
        		<td  height="24" class="se_cell_data">
        			<input type="text" name="model" size="12" class="inputsubmit" maxlength="20">
        		</td>
        		<td  height="24" class="se_cell_title"><%=text.get("QM_006.TXT_CP_TYPE")%></td>
        		<td  height="24" class="se_cell_data">
					<select name="cp_type" class="inputsubmit">
						<option><%=text.get("QM_006.all")%></option>
					</select>
				</td>
			  </tr>
		      </table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0" align="right">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
				  	      <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
              <div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
              <div id="pagingArea"></div>
             <%@ include file="/include/include_bottom.jsp"%>
			</td>
		  </tr>
		</table>
	</form>
<jsp:include page="/include/window_height_resize_event.jsp" >
<jsp:param name="grid_object_name_height" value="gridbox=180"/>
</jsp:include>
</body>