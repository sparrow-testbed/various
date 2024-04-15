<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SU_004");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SU_004";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:                 hico_bd_lis3.jsp <p>
 Description:           SUPPLY / ADMIN / 협력업체상세 소싱그룹현황 탭<p>
 Copyright:             Copyright (c) <p>
 Company:               ICOMPIA <p>
 @author                SHYI<p>
 @version
 @Comment               ICOMVNIT.type = 'QR'

--%>
<%-- 사용 언어 설정 --%>
<% String WISEHUB_LANG_TYPE="KR";%>
<% String WISEHUB_PROCESS_ID="SU_004";%>

<%--  Session 정보 입니다. --%>
<%
	String flag        = JSPUtil.nullToEmpty(request.getParameter("flag"));
	String mode        = JSPUtil.nullToEmpty(request.getParameter("mode"));
  	String vendor_code = JSPUtil.nullToEmpty(request.getParameter("vendor_code"));
  	String sg_refitem  = JSPUtil.nullToEmpty(request.getParameter("sg_refitem")); //소싱 그룹 구분키
  	String irs_no      = JSPUtil.nullToEmpty(request.getParameter("irs_no"));
  	String status      = JSPUtil.nullToEmpty(request.getParameter("status"));
  	String buyer_house_code = JSPUtil.nullToRef(request.getParameter("buyer_house_code"),"100");

	String popup       = JSPUtil.nullToEmpty(request.getParameter("popup"));

 //   wise.ses.WiseInfo info = null;
 //   info = new WiseInfo("100","ID=YPP^@^LANGUAGE=KO^@^NAME_LOC=SUPPLY^@^NAME_ENG=SUPPLY^@^DEPT=ALL^@^");
	String house_code   = info.getSession("HOUSE_CODE");
	String company_code = info.getSession("COMPANY_CODE");
	String user_id      = info.getSession("ID");
	String language     = info.getSession("LANGUAGE");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">

<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<script language="javascript">
	
	var INDEX_vendor_code;

    function Init()
    {
		setGridDraw();
		setHeader();
    	setQuery();
    }

    function setHeader()
    {


    	INDEX_vendor_code 	= GridObj.GetColHDIndex("vendor_code");
    }

    function setQuery()
    {
    	
    	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_lis13";
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=getVendor_sourcing_list";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( servletUrl, params );
    	GridObj.clearAll(false);    	
    	
    	
//         var vendor_code = document.form.vendor_code.value;

//         GridObj.SetParam("vendor_code", vendor_code);
<%--         var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.admin.info.ven_bd_lis13"; --%>
//         //var servletUrl = "/servlets/master.vendor.sta_bd_lis2";
//         GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
// 		GridObj.SendData(servletUrl);
//         GridObj.strHDClickAction="sortmulti";
    }
    
    function JavaCall(msg1,msg2,msg3,msg4,msg5)
    {
    	
    }

    function NextPage()
	{
		parent.up.MM_showHideLayers('m1','','show','m2','','hide','m3','','show','m4','','show','m5','','show','m6','','show','m11','','hide','m22','','show','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
		parent.up.goPage('cp');
	}
	function BackPage()
	{
//		parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','show','m6','','hide','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','show','m77','','hide');
		parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','hide','m5','','show','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','hide','m44','','show','m55','','hide','m66','','hide','m77','','hide');
		parent.up.goPage('qr');
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
    if("undefined" != typeof JavaCall) {
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
<body onload="Init();" bgcolor="#FFFFFF" text="#000000" >

<s:header popup="true">
<!--내용시작-->
<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">

<form name="form">
<input type="hidden" id="vendor_code" 		name="vendor_code" 			value="<%=vendor_code%>">
<input type="hidden" id="sg_refitem" 		name="sg_refitem" 			value="<%=sg_refitem%>">
<input type="hidden" id="mode" 				name="mode" 				value="<%=mode%>">
<input type="hidden" id="irs_no" 			name="irs_no" 				value="<%=irs_no%>">
<input type="hidden" id="status" 			name="status" 				value="<%=status%>">
<input type="hidden" id="flag" 				name="flag" 				value="<%=flag%>">
<input type="hidden" id="buyer_house_code" 	name="buyer_house_code" 	value="<%=buyer_house_code%>">

<TR>
	<TD height="30" align="right">

<%if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) {%>
	<TABLE cellpadding="0">
		<TR>
  			<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
		</TR>
	</TABLE>
<%}%>
</TR>
</TABLE>

<!-- <table width="98%" border="0" cellpadding="0" cellspacing="0"> -->
<!-- <tr> -->
<!-- 	<td height="1" class="cell"></td> -->
<!-- 	<!-- wisegrid 상단 bar -->
<!-- </tr> -->
<!-- <tr> -->
<!-- 	<td> -->
<%-- 		<%=WiseTable_Scripts("100%","300")%> --%>
<!-- 	</td> -->
<!-- </tr> -->
<!-- </table> -->

</form>

</s:header>
<s:grid screen_id="SU_004" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>


