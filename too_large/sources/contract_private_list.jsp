<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%
	String user_id         	= info.getSession("ID");
	String company_code    	= info.getSession("COMPANY_CODE");
	String house_code      	= info.getSession("HOUSE_CODE");

    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("CT_015");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "CT_015";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	// 화면에 행머지기능을 사용할지 여부의 구분
	//boolean isRowsMergeable = false;
	
	// 한 화면 SCREEN_ID 기준으로 Buyer 화면일 경우에는 컬럼이 ReadOnly 이고 
	// Supplier 화면일 경우에 edit 일 경우에는 아래의 벡터 클래스에다가 컬럼명을 addElement 하시면 됩니다. 
	// 변환되는 컬럼타입 기준은 아래와 같습니다.
	// ed -> ro(EditBox -> ReadOnlyBox), 
	// edn, -> ron(NumberEditBox -> NumberReadOnlyBox), 
	// dhxCalendar -> ro(CalendarBox -> ReadOnlyBox), 
	// txt -> ro(TextBox -> ReadOnlyBox)
	// sepoa_grid_common.jsp 에서 컬럼타입을 변경 시켜 줍니다.
	// 참고로 Vector dhtmlx_read_cols_vec 객체는 sepoa_common.jsp에서 생성 시켜 줍니다.
	//dhtmlx_read_cols_vec.addElement("screen_id=ED");
	//dhtmlx_read_cols_vec.addElement("col_width");
	//dhtmlx_read_cols_vec.addElement("col_max_len");
	//dhtmlx_read_cols_vec.addElement("contents");
	//dhtmlx_back_cols_vec.addElement("code=rcolor");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script type="text/javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.contract.contract_form_list";
var G_HOUSE_CODE   = "<%=house_code%>";
var G_COMPANY_CODE = "<%=company_code%>";
var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

 	// Body Onload 시점에 setGridDraw 호출시점에 sepoa_grid_common.jsp에서 SLANG 테이블 SCREEN_ID 기준으로 모든 컬럼을 Draw 해주고
	// 이벤트 처리 및 마우스 우측 이벤트 처리까지 해줍니다.
	function setGridDraw()
    {
    	<%=grid_obj%>_setGridDraw();
    	GridObj.setSizes();
    }
	<%--
	// 위로 행이동 시점에 이벤트 처리해 줍니다.
	function doMoveRowUp()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"up");
    }



    // 아래로 행이동 시점에 이벤트 처리해 줍니다.
    function doMoveRowDown()
    {
    	GridObj.moveRow(GridObj.getSelectedId(),"down");
    } --%>

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
			doQuery();
		} else {
			alert(messsage);
		}

		return false;
	}

    // 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
    // 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("SELECTED") == cellInd 이렇게 처리하시면 됩니다.
    function doOnRowSelected(rowId,cellInd)
    {
    	//alert(GridObj.cells(rowId, cellInd).getValue());
    	var header_name = GridObj.getColumnId(cellInd);
    	
    	if( header_name == "CONT_FORM_NAME")
		{
			var	cont_form_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CONT_FORM_NO")).getValue());	
				
			if(cont_form_no != ''){
				location.href = "contract_form_regist_update.jsp?flag=Y&cont_form_no="+cont_form_no;
			}
		}
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
    
    // 데이터 조회시점에 호출되는 함수입니다.
    // 조회조건은 encodeUrl() 함수로 다 전환하신 후에 loadXML 해 주십시요
    // 그렇지 않으면 다국어 지원이 안됩니다.
    function doQuery()
	{
		var cont_type   	  = LRTrim(document.form.cont_type.value);
		var cont_status 	  = LRTrim(document.form.cont_status.value);
		var use_flag          = LRTrim(document.form.use_flag.value);
		var cont_private_flag = LRTrim(document.form.cont_private_flag.value);
		var cont_form_name    = LRTrim(document.form.cont_form_name.value);
		
		var param  = "&use_flag="          + encodeUrl(use_flag);
		    param += "&cont_type="   	   + encodeUrl(cont_type);
		    param += "&cont_status=" 	   + encodeUrl(cont_status);
		    param += "&cont_private_flag=" + encodeUrl(cont_private_flag);
			param += "&cont_form_name="    + encodeUrl(cont_form_name);
			param += "&from_date="         + "";
			param += "&to_date="           + "";
			param += "&ctrl_person_id="    + "";
			
			
		var grid_col_id = "<%=grid_col_id%>";
		var SERVLETURL  = G_SERVLETURL + "?mode=doQuery&grid_col_id="+grid_col_id + param;
		GridObj.post(SERVLETURL);
		GridObj.clearAll(false);
	}
    
    function getCtrlPersonId() {
    	window.open("/common/CO_008.jsp?callback=setCtrlPerson", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
	}

	function setCtrlPerson(code, text1) {
	    document.forms[0].ctrl_person_id.value = code  ;
	    document.forms[0].ctrl_person_name.value = text1 ;
	}
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

		if(grid_array.length > 0)
		{
			return true;
		}

		alert("항목을 선택해 주세요.");
		return false;
	}

	function doDelete(){
		if(!checkRows()) return;
		
		var grid_array = getGridChangedRows(GridObj, "SELECTED");

	   	if (confirm("<%=text.get("MESSAGE.1015")%>")){
	        var cols_ids = "<%=grid_col_id%>";
			var SERVLETURL  = G_SERVLETURL + "?mode=delete&cols_ids="+ cols_ids;
			myDataProcessor = new dataProcessor(SERVLETURL);
		    sendTransactionGrid(GridObj, myDataProcessor, "SELECTED", grid_array);
	   }		
	}

	function initAjax(){
		doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M899' ,'cont_type', '' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M898' ,'use_flag' , '' );
		doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M897' ,'cont_status' , '' );
	}

	//지우기
	function doRemove( type ){
	    if( type == "ctrl_person_id" ) {
	    	document.forms[0].ctrl_person_id.value = "";
	        document.forms[0].ctrl_person_name.value = "";
	    }  
	}

	function entKeyDown(){
	    if(event.keyCode==13) {
	        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
	        
	        doQuery();
	    }
	}
</script>
</head>

<body leftmargin="15" topmargin="6" onload="setGridDraw();initAjax();">
<s:header>
	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
<form name="form">
<input type="hidden" name="cont_private_flag" value="PV">
<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr>
<td>
<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
<td width="100%">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
        		<td width="13%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약서종류</td>
        		<td width="20%" class="data_td">
	                <select name="cont_type" id="cont_type" class="inputsubmit">
						<option value="">전체</option>
					</select>
				</td>
        		<td width="13%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;서식상태</td>
        		<td width="20%" class="data_td">
	                <select name="cont_status" id="cont_status" class="inputsubmit">
						<option value="">전체</option>
					</select>
        		</td>					      
        		<td width="14%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사용여부</td>
        		<td width="20%" class="data_td">
	                <select name="use_flag" id="use_flag" class="inputsubmit">
						<option value="">전체</option>
					</select>
        		</td>
			  </tr>
			  <tr>
				<td colspan="6" height="1" bgcolor="#dedede"></td>
			</tr>
			  <tr>
				<td width="13%"  class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;계약서식이름
        		</td>
        		<td width="20%" class="data_td">
        			<input type="text" name="cont_form_name" id="cont_form_name" value="" style="width: 98%;" onkeydown='entKeyDown()'>
        		</td>
					      
        		<td width="14%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;작성자</td>
        		<td width="20%" class="data_td" colspan="3">
        			<input type="text" name="ctrl_person_id"  id="ctrl_person_id"  size="10" style="ime-mode:inactive" maxlength="30" value='<%=info.getSession("ID")%>'  onkeydown='entKeyDown()' onkeyup="delInputEmpty('ctrl_person_id', 'ctrl_person_name')">
					<a href="javascript:getCtrlPersonId();"><img src="../images/button/butt_query.gif" align="absmiddle" border="0"></a>
			       <a href="javascript:doRemove('ctrl_person_id')"><img src="<%=POASRM_CONTEXT_NAME %>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>
			        <input type="text" name="ctrl_person_name" size="10" readonly class="input_empty" value='<%=info.getSession("NAME_LOC")%>' onkeydown='entKeyDown()'>
			        
			        <%-- <input type="text" name="ctrl_person_id" id="ctrl_person_id" size="13" class="input_re"  value='<%=info.getSession("ID")%>' readOnly >
					<a href="javascript:PopupManager('ADD_USER_ID')">
						<img src="<%=G_IMG_ICON%>" align="absmiddle" border="0" alt="">
					</a>
					<input type="text" name="ctrl_person_name" id="ctrl_person_name" size="20" class="input_data2"  value='<%=info.getSession("NAME_LOC")%>'> --%>
        		</td>        		
			  </tr>
			</table>
			</td>
			</tr>
			</table>
			</td>
			</tr>
			</table>
			
			
			<TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
			  <TR>
				<td style="padding:5 5 5 0" align="right">
					<%-- <TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>")</script></td>
					  	  <td><script language="javascript">btn("javascript:doDelete()","<%=text.get("BUTTON.deleted")%>")</script></td>
					  </TR>
				    </TABLE> --%>
				    <TABLE cellpadding="0">
						<TR>
							<TD><script language="javascript">btn("javascript:doQuery()", "조 회");</script></TD>
							<td><script language="javascript">btn("javascript:doDelete()", "삭 제");</script></td>
						</TR>
					</TABLE>
				  </td>
			    </TR>
			  </TABLE>
			</td>
		  </tr>
		</table>
	</form>
</s:header>
<s:grid screen_id="CT_015" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>