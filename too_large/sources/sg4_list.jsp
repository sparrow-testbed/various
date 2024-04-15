<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SR_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SR_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:        sou_pp_lis3.jsp  <p>
 Description:  <p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       H.S. An <p>
 @version      1.0.0
 @Comment      2005.08.22
--%>
<% String WISEHUB_PROCESS_ID="SR_002";%>
<% String WISEHUB_LANG_TYPE="KR";%>

<%
    String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
	String sg_refitem	= JSPUtil.CheckInjection(request.getParameter("sg_refitem"))==null?"":JSPUtil.CheckInjection(request.getParameter("sg_refitem"));
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<%-- <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<script language="javascript">
	var INDEX_T_SEQ         = "";
    var INDEX_T_NAME   		= "";
    var INDEX_T_ADD_DATE    = "";
    var INDEX_T_ID   		= "";

    function setHeader()
    {


		GridObj.SetDateFormat("T_ADD_DATE",  "yyyy/MM/dd");

        GridObj.strHDClickAction="sortmulti";

		INDEX_T_SEQ    = GridObj.GetColHDIndex("T_SEQ");
        INDEX_T_ADD_DATE    = GridObj.GetColHDIndex("T_ADD_DATE");
        INDEX_T_NAME   		= GridObj.GetColHDIndex("T_NAME");
        INDEX_T_ID   		= GridObj.GetColHDIndex("T_ID");

		doSelect();
    }

    function doSelect()
    {
        var fm = document.form1;
		var sg_refitem = "<%=sg_refitem%>";
		var temp_name = fm.temp_name.value;
		
        /* GridObj.SetParam("temp_name",   temp_name);
        GridObj.SetParam("sg_refitem",  sg_refitem);

        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti"; */
		var params ="mode=getSgList&grid_col_id="+grid_col_id;
        servletUrl	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg4_list";
        params += "&sg_refitem="+sg_refitem;
        params += "&temp_name="+temp_name;
		params += dataOutput();
		GridObj.post(servletUrl, params);
	 	GridObj.clearAll(false);
    }

	function se_del()
	{
        var fm = document.form1;
        <%-- servletUrl	= "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg4_list";
        //servletUrl = "/servlets/master.sg.sou_pp_lis3"; --%>

		var sel_row = "";
		for(var i=0; i<GridObj.GetRowCount();i++) {
			var temp = GD_GetCellValueIndex(GridObj,i,INDEX_T_SEQ);
			if(temp == "1") sel_row += i+"&" ;
		}


		if(sel_row == "")
		{
			alert('삭제할 세분류를 선택하세요.');
			return;
		}

		var value = confirm('선택한 세분류를 삭제 하시겠습니까?');

		if(!value) {
			return;
		}
		var params ="mode=setSgDelete&cols_ids="+grid_col_id;
		params+=dataOutput();
		var grid_array = getGridChangedRows(GridObj, "T_SEQ");
	 	myDataProcessor = new dataProcessor("<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.procure.sg4_list",params);
	    sendTransactionGridPost(GridObj, myDataProcessor, "T_SEQ", grid_array);
	    doSelect();
		/* GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL"); */
	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5)
    {
<%--
/*
		for(var i=0;i<GridObj.GetRowCount();i++) {
			if(i%2 == 1){
				for (var j = 0;	j<GridObj.GetColCount(); j++){
					GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
				}
			}
		}
%/		
--%>
        if(msg1 == "doData")
        {
			doSelect();
        }
    }

</script>


<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
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
        doQuery();
    } else {
        alert(messsage);
    }
    if("undefined" !=  JavaCall) {
    	JavaCall("doData");
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
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" text="#000000" >


<!--내용시작-->
<%-- <%@ include file="/include/us_template_start.jsp" flush="true" %> --%>
<table width="98%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/icon/icon_ti.gif" width="12" height="12" align="absmiddle">
		&nbsp;세분류 조회
	</td>
</tr>
</table> 

<table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="760" height="2" bgcolor="#0072bc"></td>
</tr>
</table>

<table width="98%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<form name="form1" >
 <div align="center">
  <%-- <script language="javascript">rdtable_top1()</script> --%>
    <tr>
      <td width="10%" class="c_title_1"><img src="/images/icon/icon_s_arr.gif" width="9" height="9"> 세분류명</td>
      <td width="35%" class="c_data_1" colspan="3">
        <input type="text" name="temp_name" size="25" class="input_submit" value="">
      </td>
    </tr>
  </table>
	<%-- <script language="javascript">rdtable_bot1()</script> --%>
    <table width="98%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
    			<TABLE cellpadding="0">
    	      		<TR>
        	  			<td><script language="javascript">btn("javascript:doSelect()","조 회")</script></td>
        	  			<td><script language="javascript">btn("javascript:se_del()","삭 제")</script></td>
	    	  			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>

        	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
    </table>

<%-- <table width="98%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td height="1" class="cell"></td>
	<!-- wisegrid 상단 bar -->
</tr>
<tr>
	<td>
		<%=WiseTable_Scripts("100%","180")%>
	</td>
</tr>
</table>
 --%>    
 </form>
<%-- <%@ include file="/include/us_template_end.jsp" flush="true" %> --%>


<s:grid screen_id="SR_002" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


