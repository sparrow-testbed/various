<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SU_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SU_003";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
 Title:                 hico_bd_lis3.jsp <p>
 Description:           SUPPLY / ADMIN / 회사정보 / 인허가및자격사항 <p>
--%>
<% String WISEHUB_PROCESS_ID="I_SU_003";%>
<%-- 사용 언어 설정 --%>
<% String WISEHUB_LANG_TYPE="KR";%>
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
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript">
<!--
	var G_SERVLETURL         = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.supply.admin.info.ven_bd_ins10_ict";
    var idx_sel;
    var idx_title;
    var idx_desc1;
    var idx_desc2;
    var idx_date1;
    var idx_date2;
    var idx_remark;
    var idx_vendor_code;
    var idx_seq;
    var idx_flag_h;

    function Init()
    {
		setGridDraw();
		setHeader();
    	setQuery();
    }

    function setHeader()
    {

		idx_sel         = GridObj.GetColHDIndex("sel");
	    idx_title       = GridObj.GetColHDIndex("title");
	    idx_desc1       = GridObj.GetColHDIndex("desc1");
	    idx_desc2       = GridObj.GetColHDIndex("desc2");
	    idx_date1       = GridObj.GetColHDIndex("date1");
	    idx_date2       = GridObj.GetColHDIndex("date2");
		idx_remark      = GridObj.GetColHDIndex("remark");
	    idx_vendor_code = GridObj.GetColHDIndex("vendor_code");
	    idx_seq         = GridObj.GetColHDIndex("seq");
	    idx_flag_h      = GridObj.GetColHDIndex("flag_h");
    }

    function setQuery()
    {
    	
    	
    	var cols_ids = "<%=grid_col_id%>";
    	var params = "mode=getHicoBdLis3";
    	params += "&cols_ids=" + cols_ids;
    	params += dataOutput();
    	GridObj.post( G_SERVLETURL, params );
    	GridObj.clearAll(false);
    }

    //check된 row 중에서 column 을 보낸다.
    function setData()
    {
    	var count = 0;
		for(var i=0;i<GridObj.GetRowCount();i++)
		{
			if(GD_GetCellValueIndex(GridObj,i,idx_sel)==true)
			{
				count++;
			}
		}
		if(count==0){
			alert("원하는 행을 선택해 주세요.");
			return;
		}
    	//입력항목 check
        if ( ! checkData() )    return;

		if(!confirm("저장하시겠습니까?"))
		return;
		
		var grid_array = getGridChangedRows(GridObj, "sel");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=insertHicoBdLis3";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor( G_SERVLETURL+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "sel",grid_array);
    }

    function checkRow()
    {
        var rtn = "false"
        addrow = GridObj.GetRowCount();

        for( i = 0 ; i < addrow ; i++ ){
            if ( GD_GetCellValueIndex(GridObj, i, "0" ) == true ) return true;
        }

        return rtn;
    }

    function checkData()
    {
        var rtn = true;
        addrow = GridObj.GetRowCount();

        for( i = 0 ; i < addrow ; i++ )
        {
            if ( GD_GetCellValueIndex(GridObj, i, idx_sel ) == "false" ) continue;

            if ( LRTrim( GD_GetCellValueIndex(GridObj, i, idx_title ) ) == "" ){
                alert( "품질인증명을 입력하시기 바랍니다." );
                return false;
            }
            if ( LRTrim( GD_GetCellValueIndex(GridObj, i, idx_desc2 ) ) == "" ){
                alert( "인증기관을 입력하시기 바랍니다." );
                return false;
            }
            if ( LRTrim( GD_GetCellValueIndex(GridObj, i, idx_date1 ) ) == "" ){
                alert( "획득일자를 입력하시기 바랍니다." );
                return false;
            }
        }

        return rtn;
    }

    function setDelete(){

        if ( checkRow() == "false" )
        {
            alert( "원하는 행을 선택하세요" );
            return;
        }

        if ( ! confirm( "정말로 삭제하시겠습니까?" ) ) return;
        
        var grid_array = getGridChangedRows(GridObj, "sel");
		var cols_ids = "<%=grid_col_id%>";
		var params;
		params = "?mode=deleteHicoBdLis3";
		params += "&cols_ids=" + cols_ids;
		params += dataOutput();
		myDataProcessor = new dataProcessor( G_SERVLETURL+params);
		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
		sendTransactionGrid(GridObj, myDataProcessor, "sel",grid_array);

    }
var nextFlag = false ;
/*
	WiseTable에서 발생하는 Event메세지 Function
	POPUP Image Click시 이벤트 처리....
	JavaCall(event, row, column, previousValue, currentValue) {

	event : 발생한 event를 나타낸다.
		doQuery		: 조회시 발생
		doData 		: 입력, 수정, 삭제시 발생
		t_imagetext : imagetext type의 cell click시 발생
		t_header 	: header click시 발생
		rowcopy 	: 열복사시
		t_insert 	: cell 입력시 발생

	row : event가 발생한 row를 나타낸다.
		조회시 : "undefine"
		입력, 수정, 삭제시 : "undefine"
		cell입력시 : 입력한 row index
		imagetext type의 cell click시 : 입력한 row index
		header click시 : "undefine"
		열복사시 : copy된 row index

	column : event가 발생한 column 나타낸다.
		조회시 : "undefine"
		입력, 수정, 삭제시 : "undefine"
		cell입력시 : 입력한 column index
		imagetext type의 cell click시 : 입력한 column index
		header click시 : "t_header";
		열복사시 : "-1";

	previousValue : event가 발생전의 cell값을 나타낸다.
		조회시 : "undefine"
		입력, 수정, 삭제시 : "undefine"
		cell입력시 : 새로운 값을 입력하기 이전의 cell값
		imagetext type의 cell click시 : "undefine"
		header click시 : "undefine";
		열복사시 : "undefine";

	currentValue : event가 발생후의 cell값을 나타낸다.
		조회시 : "undefine"
		입력, 수정, 삭제시 : "undefine"
		cell입력시 : 현재 입력된 cell값
		imagetext type의 cell click시 : "undefine"
		header click시 : "undefine";
		열복사시 : "undefine";

WiseTable Event 종류

	doQuery		: 조회시 발생
	doData 		: 입력, 수정, 삭제시 발생
	t_imagetext : imagetext click시 발생
	t_header 	: header click시 발생
	rowcopy 	: 열복사후 열붙여넣기시 발생
	t_insert 	: 셀입력시 발생
*/
	function JavaCall(msg1, msg2, msg3, msg4, msg5)
    {
        if ( msg1 == "doData" )
        {
//             rtn = GD_GetParam(GridObj, 0 );
//             if( rtn > "" ){
//                 alert( rtn );
//             }else{
//             	alert(GridObj.GetMessage());
//                 setQuery();

//             }
//             return;
        }
        else if ( msg1 == "doQuery" )
        {
        	var wise = GridObj;
			var rowCount = wise.GetRowCount();

			if(rowCount < 2){
				nextFlag = false;
			}else{
				nextFlag = true;
			}
//             rtn = GD_GetParam(GridObj, 0 );
//     		if ( rtn > "" ){
//       			alert( rtn );
//       			return;
//     		}
    		flag = "<%=flag%>";
    		var trow = GridObj.GetRowCount();
    		if( flag == "popup" && trow == 0 ){
    		    LineInsert('1');
    		}
        }
	}

    function LineInsert(count)
    {
    	
    	var newId = (new Date()).valueOf();
    	GridObj.addRow(newId,"");
    	var row = GridObj.GetRowCount();
    	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("sel")).cell.wasChanged = true;
    	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("sel")).setValue("1");
    	GridObj.cells(GridObj.getRowId(row-1), GridObj.getColIndexById("FLAG")).setValue("I");
    }

    function InsertRows(count)
    {
        maxrow = GridObj.GetRowCount();

        for ( i = 0; i < count; i++ )
        {
            GridObj.insertRow(maxrow);//빈 로우를 마지막에 추가한다.
            GD_SetCellValueIndex(GridObj,maxrow, idx_sel, "true&", "&");//삽입한 Row를 Check - true로 Set
        }

        ;
        GridObj.setSelectedRow( GridObj.GetRowCount() );
    }
	function NextPage()
	{
		parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','show','m4','','show','m5','','hide','m6','','show','m11','','hide','m22','','hide','m33','','hide','m44','','hide','m55','','hide','m66','','hide');
		parent.up.goPage('sc');
	}
	

	function BackPage()
	{
		parent.up.MM_showHideLayers('m1','','show','m2','','show','m3','','hide','m4','','show','m5','','hide','m6','','show','m7','','show','m11','','hide','m22','','hide','m33','','show','m44','','hide','m55','','hide','m66','','hide','m77','','hide');
		parent.up.goPage('pj');
	}

	//-->
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
        setQuery();
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

<form name="form">
<input type="hidden" id="vendor_code" 		name="vendor_code" 			value="<%=vendor_code%>">
<input type="hidden" id="sg_refitem" 		name="sg_refitem" 			value="<%=sg_refitem%>">
<input type="hidden" id="mode" 				name="mode" 				value="<%=mode%>">
<input type="hidden" id="irs_no" 			name="irs_no" 				value="<%=irs_no%>">
<input type="hidden" id="status" 			name="status" 				value="<%=status%>">
<input type="hidden" id="flag" 				name="flag" 				value="<%=flag%>">
<input type="hidden" id="buyer_house_code" 	name="buyer_house_code" 	value="<%=buyer_house_code%>">

<TABLE width="98%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD height="30" align="right">

<%if (popup==null||"".equals(popup)||popup.equals("U")||popup.equals("T")) {%>
	<TABLE cellpadding="0">
		<TR>
  			<td><script language="javascript">btn("javascript:LineInsert('1')","행삽입")</script></td>
			<TD><script language="javascript">btn("javascript:setData()","저 장")</script></TD>
  			<TD><script language="javascript">btn("javascript:setDelete()","삭 제")</script></TD>
  			<TD><script language="javascript">btn("javascript:BackPage()","이 전")</script></TD>
  			<!--<TD><script language="javascript">btn("javascript:NextPage()","다 음")</script></TD>-->
		</TR>
	</TABLE>
<%}%>
	</TD>
</TR>
</TABLE>
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SU_003" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


