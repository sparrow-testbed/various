<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>

<%@ taglib prefix="s" uri="/sepoa"%>

<%
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateDay(to_day,-365);
	String to_date = to_day;
	
	String house_code = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String user_type = info.getSession("USER_TYPE");
	
	Vector multilang_id = new Vector();
	multilang_id.addElement("EM_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	String language = info.getSession("LANGUAGE");

	// Dthmlx Grid 전역변수들..
	String screen_id = "EM_002";
	String grid_obj  = "GridObj";
	// 조회용 화면인지 데이터 저장화면인지의 구분
	boolean isSelectScreen = false;
	
	// 화면에 행머지기능을 사용할지 여부의 구분
	//boolean isRowsMergeable = false;
	
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>

<script language=javascript src="../js/lib/sec.js"></script>



<script language="javascript" src="../js/lib/jslb_ajax.js"></script>

<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>



<Script language="javascript">
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
    	
    	setTimeout(doQuery,500);
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
    	//alert(GridObj.cells(rowId, cellInd).getValue());
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
		var mode = encodeUrl(LRTrim(""));
		var case_no = encodeUrl(LRTrim("200")); //vendor_select

    	var USER_TYPE 	= encodeUrl(LRTrim(document.forms[0].user_type.value.toUpperCase()));
        var company     = encodeUrl(LRTrim(document.forms[0].company.value.toUpperCase()));
    	var USER_ID	  	= encodeUrl(LRTrim(document.forms[0].user.value.toUpperCase()));
    	var USER_NM	  	= encodeUrl(LRTrim(document.forms[0].user_nm.value.toUpperCase()));
    	var DEPT	  	= encodeUrl(LRTrim(document.forms[0].dept.value.toUpperCase()));
    	var DEPT_NM_LOC	= encodeUrl(LRTrim(document.forms[0].dept_nm_loc.value.toUpperCase()));		
		
		var grid_col_id = "<%=grid_col_id%>";
		
		
		var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.admin.mat_get1";
		var params = "mode=" + mode + "&case_no="+case_no+"&USER_TYPE="+USER_TYPE+"&company="+company+"&USER_ID=" + USER_ID + 
		  "&USER_NM="+USER_NM+"&DEPT="+DEPT+"&DEPT_NM_LOC="+DEPT_NM_LOC+"&grid_col_id="+grid_col_id;
		
		GridObj.post(servletUrl,params);
		GridObj.clearAll(false);
	}

	// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
	function checkRows()
	{
		var grid_array = getGridChangedRows(GridObj, "SELECT");

		if(grid_array.length > 0)
		{
			return true;
		}

		<%-- alert("<%=text.get("AD_018.0006")%>"); --%>
		return false;
	}

	function CheckBoxSelect(strColumnKey, nRow)
	{

	}

	function initAjax(){
	}

	function doInsert()
	{

	}
	
	function doConfirm(){
		if(!checkRows()) return;
		var grid_array = getGridChangedRows(GridObj, "SELECT");
		
		DEPT_SELECTED		= "";
		DEPT_NAME_SELECTED	= "";
		COMPANY_SELECTED    = "";
		USER_SELECTED		= "";
		USER_NAME_SELECTED	= "";
		USER_TYPE_SELECTED	= "";
		USER_TYPE_SELECTED1	= "";
		COMPANY_CODE_SELECTED = "";
		COMPANY_NAME_SELECTED = "";
		DEPTDATA 			= "";
		
 		for(var i =0; i < grid_array.length; i++ )
		{
			COMPANY      = GridObj.cells(grid_array[i], GridObj.getColIndexById("company")).getValue();
			USER 		 = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER")).getValue(); //사용자
			USER_NAME 	 = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_NAME")).getValue(); //사용자명
			USER_TYPE 	 = GridObj.cells(grid_array[i], GridObj.getColIndexById("USER_TYPE")).getValue(); //사용자구분
			DEPT 		 = GridObj.cells(grid_array[i], GridObj.getColIndexById("DEPT")).getValue(); //부서
			DEPT_NAME 	 = GridObj.cells(grid_array[i], GridObj.getColIndexById("DEPT_NAME")).getValue(); //부서명
			COMPANY_CODE = GridObj.cells(grid_array[i], GridObj.getColIndexById("COMPANY_CODE")).getValue(); //회사코드
			COMPANY_NAME = GridObj.cells(grid_array[i], GridObj.getColIndexById("COMPANY_NAME")).getValue(); //회사명
/*
            alert("USER         : " + USER         );
            alert("USER_NAME    : " + USER_NAME    );
            alert("USER_TYPE    : " + USER_TYPE    );
            alert("DEPT         : " + DEPT         );
            alert("DEPT_NAME    : " + DEPT_NAME    );
            alert("COMPANY_CODE : " + COMPANY_CODE );
            alert("COMPANY_NAME : " + COMPANY_NAME );
*/
			if(DEPT == ""){
				DEPT = " ";
			}

			USER_TYPE_SELECTED1 += USER_TYPE + ";";
			DEPTDATA += COMPANY_CODE + ";" + USER + ";"  + DEPT +";" + USER_NAME + ";" ;
			DEPTDATA += "@";
			USER_SELECTED += USER + ";";
			USER_NAME_SELECTED += USER_NAME + ";";
			USER_TYPE_SELECTED += USER_TYPE + ";";
			DEPT_SELECTED += DEPT + ";";
			DEPT_NAME_SELECTED += DEPT_NAME + ";";
			COMPANY_CODE_SELECTED += COMPANY_CODE + ";";
			COMPANY_NAME_SELECTED += COMPANY_NAME + ";";
		}
 		opener.SetMailRecevingUser(USER_SELECTED,DEPTDATA,USER_NAME_SELECTED,USER_TYPE_SELECTED1,DEPT_SELECTED,DEPT_NAME_SELECTED,COMPANY_CODE_SELECTED,COMPANY_NAME_SELECTED);
		window.close();		
	}
	// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
	// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
	function doSaveEnd(obj)
	{
	}

	// 엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
	// 복사한 데이터가 그리드에 Load 됩니다.
	function doExcelUpload() {
	}

	function doDelete()
	{
	}

	function rowinsert()
	{
	}

	// 행추가 이벤트 입니다.
	function doAddRow()
    {
    }
    
    // 행삭제시 호출 되는 함수 입니다.
    function doDeleteRow()
    {
    }
	function onRowDblClicked(){
	}
    //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13)
        {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            //doQuery();
        }
    }
</script>
</head>

<body leftmargin="15" topmargin="6" onload="initAjax();setGridDraw();">
<s:header popup="true">
<form name="form">
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));
	if(this_window_popup_flag.trim().length() <= 0) this_window_popup_flag = "false";

	thisWindowPopupFlag = "true";
	thisWindowPopupScreenName = (String) text.get("EM_002.MESSAGE_RECEIVE1"); //수신처지정
%>

    <%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	  <tr>
    	 	<td height="5"> </td>
	  </tr>
	  <tr>
	    <td width="100%" valign="top">
			<table width="98%" border="0" cellpadding="0" cellspacing="1" bgcolor="#DBDBDB">
				<tr>
        		  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.2001")%></td>
        		  <td height="24" class="se_cell_data">
        			<select name="user_type" id="user_type" class="input_re" onkeydown='entKeyDown()' <%if(user_type.equals("S")){ %>disabled<%} %>>
        		<%	
        			if(user_type.equals("S")){ 
        					String select_user_type = ListBox(request, "SL0006", "#", "");
							out.println(select_user_type);
					} else {
				%>									
						<option value=""><%=text.get("EM_002.all")%></option>
				<%
							String select_user_type = ListBox(request, "SL0081", "#", "");
							out.println(select_user_type);
					}
				%>
					</select>
        		  </td>
        		  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.2002")%></td>
        		  <td height="24" class="se_cell_data">
					  <input type="text" size="12" name="user" class="inputsubmit" onkeydown='entKeyDown()'>
				  </td>
				  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.2003")%></td>
        		  <td height="24" class="se_cell_data">
					  <input type="text" size="12" name="user_nm" class="inputsubmit" onkeydown='entKeyDown()'>
				  </td>
			    </tr>
			    
			    <tr>
        		  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.2004")%></td>
        		  <td height="24" class="se_cell_data">
        			  <input type="text" size="12" name="dept" class="inputsubmit" onkeydown='entKeyDown()'>
        		  </td>
        		  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.2005")%></td>
        		  <td height="24" class="se_cell_data">
					  <input type="text" size="12" name="dept_nm_loc" class="inputsubmit" onkeydown='entKeyDown()'>
				  </td>
				  <td height="24" align="right" class="se_cell_title"><%=text.get("EM_002.company")%></td>
        		  <td height="24" class="se_cell_data">
					  <input type="text" size="12" name="company" class="inputsubmit" onkeydown='entKeyDown()'>
				  </td>
			    </tr>
			</table>
			  <TABLE cellpadding="0" cellspacing="0" border="0" width="100%">
				  <TR>
					<td style="padding:5 5 5 0">
					<TABLE cellpadding="2" cellspacing="0">
					  <TR>
					  	  <td><script language="javascript">btn("javascript:doQuery()","<%=text.get("BUTTON.search")%>");</script></td>
					 	  <td><script language="javascript">btn("javascript:doConfirm()","<%=text.get("BUTTON.insert")%>");</script></td>
		      			  <td><script language="javascript">btn("javascript:parent.close()","<%=text.get("BUTTON.cancel")%>");</script></td>
					  </TR>
				    </TABLE>
				  </td>
			    </TR>
			  </TABLE>
			</td>
		  </tr>
		</table>
	</form>
<%-- <%@ include file="/include/include_bottom.jsp"%> --%>

<jsp:include page="/include/window_height_resize_event.jsp">
<jsp:param name="grid_object_name_height" value="gridbox=150"/>
</jsp:include>

</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<s:footer/>
</body>
</html>