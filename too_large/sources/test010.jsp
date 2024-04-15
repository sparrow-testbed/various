<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PO_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PO_010";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%--
	카탈로그  개요
	1) 쿼리
     * 기본적으로 MTGL을 기본으로 한다.(구매지역은 OUTER JOIN)
     * 구매쪽 정보를 얻으려면
     * ICOMMCPM에 MATERIAL_CLASS1과 MTGL의 MATERIAL_CLASS1이 조인되어야한다.
     * ICOMBAPR.PR_LOCATION과 ICOMLUSR.PR_LOCATION을 조인하여 사용자와 연결된 구매지역을 가져온다.
     * ICOMMCPM의 PURCHASE_LOCATION과 ICOMBAPR.PURCHASE_LOCATION을 조인하여
     * 사용자와 연결된 구매지역과 품목 일반정보의 품목을 가져올 수 있다.

	2) 여러 화면에서 카탈로그를 이용할 수 있도록 한다.(/include/script/catalog/catalog.js참조)
	INDEX=MATERIAL_TYPE:MATERIAL_TYPE:MATERIAL_CTRL_TYPE
		-->setCatalog는 arr[0] :MATERIAL_TYPE의 값
		-->arr[1] :MATERIAL_CTRL_TYPE의 값

	3) 카탈로그 항목
	MATERIAL_TYPE
	MATERIAL_CTRL_TYPE
	MATERIAL_CLASS1
	ITEM_NO
	DESCRIPTION_LOC
	DESCRIPTION_ENG
	SPECIFICATION
	PURCHASE_DEPT_NAME
	PURCHASER_NAME
	CTRL_PERSON_ID
	PURCHASE_DEPT
	ITEM_BLOCK_FLAG
	BASIC_UNIT
	CTRL_CODE
	PURCHASE_LOCATION
	PURCHASE_LOCATION_NAME
	PREV_UNIT_PRICE
	: 항목이 추가될 ?嚥? INDEX_HEADERS값에 반드시 항목값을 추가하도록 한다.

	4) opener의 와이즈 테이블에 값을 셋팅해준다.
	 * 셋팅항목 - doInsert 참조
	 * doInsert() : opener의 setCatalog(arr) 스크립트 함수를 호출한다.

--%>
<%
	/*	필요한 인덱스를 받아온다. */
	String INDEX        = JSPUtil.nullToEmpty(request.getParameter("INDEX"));
	String gate         = JSPUtil.nullToEmpty(request.getParameter("gate")); // 외부에서 접근하였을 경우 flag
	String vendor_code  = JSPUtil.nullToEmpty(request.getParameter("vendor_code")); // 외부에서 접근하였을 경우 flag

	String LB_MATERIAL_TYPE = ListBox(request, "SL0018", info.getSession("HOUSE_CODE") + "#M040", "");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<script language="javascript" type="text/javascript">
var G_SERVLETURL = "<%//=getSepoaServletPath("catalog.cat_pp_lis_main")%><%=POASRM_CONTEXT_NAME%>/servlets/catalog.cat_pp_lis_main";
var G_INDEXES    = "<%=INDEX%>".split(":");
var mode;

var TOTAL_CUR;
var G_COMPANY_CODE = "<%=info.getSession("COMPANY_CODE")%>";

var INDEX_SEL                   ;
var INDEX_MATERIAL_TYPE         ;
var INDEX_MATERIAL_CTRL_TYPE    ;
var INDEX_MATERIAL_CLASS1       ;
var INDEX_ITEM_NO               ;
var INDEX_DESCRIPTION_LOC       ;
var INDEX_DESCRIPTION_ENG       ;
var INDEX_SPECIFICATION         ;
var INDEX_PURCHASE_DEPT_NAME    ;
var INDEX_PURCHASER_NAME        ;
var INDEX_CTRL_PERSON_ID        ;
var INDEX_PURCHASE_DEPT         ;
var INDEX_ITEM_BLOCK_FLAG       ;
var INDEX_BASIC_UNIT            ;
var INDEX_CTRL_CODE             ;
var INDEX_PURCHASE_LOCATION     ;
var INDEX_PURCHASE_LOCATION_NAME;
var INDEX_DELIVERY_IT           ;
var INDEX_PREV_UNIT_PRICE       ;
var INDEX_ITEM_GROUP       		;
var INDEX_ITEMFLAG				;
var INDEX_DELY_TO_ADDRESS		;

var INDEX_HEADERS = new Array(
		"SEL"      				 , "MATERIAL_TYPE"    		, "MATERIAL_CTRL_TYPE"  , "MATERIAL_CLASS1"	  	, "ITEM_NO"
	  , "DESCRIPTION_LOC"        , "DESCRIPTION_ENG"  		, "SPECIFICATION"  	  	, "PURCHASE_DEPT_NAME"  , "PURCHASER_NAME"
	  , "CTRL_PERSON_ID"		 , "PURCHASE_DEPT" 	  		, "ITEM_BLOCK_FLAG"     , "BASIC_UNIT"          , "CTRL_CODE"
	  , "PURCHASE_LOCATION"      , "PURCHASE_LOCATION_NAME" , "PREV_UNIT_PRICE"     , "DELIVERY_IT" 		, "SG_REFITEM"
	  ,  "MAKER_NAME"			 , "MAKER_CODE"				, "ITEM_GROUP" 			, "ITEMFLAG"			, "DELY_TO_ADDRESS"
	);
	//INDEX=ITEM_NO:DESCRIPTION_LOC:SPECIFICATION:BASIC_UNIT:CTRL_CODE:CTRL_PERSON_ID:PURCHASE_DEPT:PURCHASE_DEPT_NAME:PURCHASER_NAME:PURCHASE_LOCATION:PURCHASE_LOCATION_NAME

function setHeader()
{

	GridObj.SetColCellSortEnable(     	"SPECIFICATION",false);
	GridObj.SetColCellSortEnable(  	"PURCHASE_DEPT_NAME",false);
	GridObj.SetColCellSortEnable(	"PURCHASER_NAME",false);
	GridObj.SetColCellSortEnable(     "CTRL_PERSON_ID",false);
	GridObj.SetColCellSortEnable( "PURCHASE_DEPT",false);
	GridObj.SetColCellSortEnable(     "ITEM_BLOCK_FLAG",false);
	GridObj.SetColCellSortEnable(  	"BASIC_UNIT",false);
	GridObj.SetColCellSortEnable( "CTRL_CODE",false);
	GridObj.SetColCellSortEnable( "PURCHASE_LOCATION",false);
	GridObj.SetColCellSortEnable(  	"PURCHASE_LOCATION_NAME",false);
	GridObj.SetDateFormat(   "DELIVERY_IT","yyyy/MM/dd");
	GridObj.SetNumberFormat(  	"PREV_UNIT_PRICE", G_format_unit);

	INDEX_SEL                    = GridObj.GetColHDIndex("SEL") ;
	INDEX_MATERIAL_TYPE          = GridObj.GetColHDIndex("MATERIAL_TYPE") ;
	INDEX_MATERIAL_CTRL_TYPE     = GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE") ;
	INDEX_MATERIAL_CLASS1        = GridObj.GetColHDIndex("MATERIAL_CLASS1") ;
	INDEX_ITEM_NO                = GridObj.GetColHDIndex("ITEM_NO") ;
	INDEX_DESCRIPTION_LOC        = GridObj.GetColHDIndex("DESCRIPTION_LOC") ;
	INDEX_DESCRIPTION_ENG        = GridObj.GetColHDIndex("DESCRIPTION_ENG") ;
	INDEX_SPECIFICATION          = GridObj.GetColHDIndex("SPECIFICATION") ;
	INDEX_PURCHASE_DEPT_NAME     = GridObj.GetColHDIndex("PURCHASE_DEPT_NAME") ;
	INDEX_PURCHASER_NAME         = GridObj.GetColHDIndex("PURCHASER_NAME") ;
	INDEX_CTRL_PERSON_ID         = GridObj.GetColHDIndex("CTRL_PERSON_ID") ;
	INDEX_PURCHASE_DEPT          = GridObj.GetColHDIndex("PURCHASE_DEPT") ;
	INDEX_ITEM_BLOCK_FLAG        = GridObj.GetColHDIndex("ITEM_BLOCK_FLAG") ;
	INDEX_BASIC_UNIT             = GridObj.GetColHDIndex("BASIC_UNIT") ;
	INDEX_CTRL_CODE              = GridObj.GetColHDIndex("CTRL_CODE") ;
	INDEX_PURCHASE_LOCATION      = GridObj.GetColHDIndex("PURCHASE_LOCATION") ;
	INDEX_PURCHASE_LOCATION_NAME = GridObj.GetColHDIndex("PURCHASE_LOCATION_NAME") ;
	INDEX_DELIVERY_IT            = GridObj.GetColHDIndex("DELIVERY_IT") ;
	INDEX_PREV_UNIT_PRICE        = GridObj.GetColHDIndex("PREV_UNIT_PRICE") ;
	INDEX_SG_REFITEM        	 = GridObj.GetColHDIndex("SG_REFITEM") ;
	INDEX_MAKER_NAME        	 = GridObj.GetColHDIndex("MAKER_NAME") ;
	INDEX_MAKER_CODE        	 = GridObj.GetColHDIndex("MAKER_CODE") ;
	INDEX_ITEM_GROUP        	 = GridObj.GetColHDIndex("ITEM_GROUP") ;
	INDEX_ITEMFLAG        	 	 = GridObj.GetColHDIndex("ITEMFLAG") ;
	INDEX_DELY_TO_ADDRESS  	 	 = GridObj.GetColHDIndex("DELY_TO_ADDRESS") ;
}

function doSelect()
{
	/*
	if((LRTrim(form1.BUYER_ITEM_NO.value) == "") && (LRTrim(form1.DESCRIPTION_TEXT.value) == "") && (LRTrim(form1.MAKER_NAME.value) == ""))
	{
		if(form1.MATERIAL_TYPE.value == "" || form1.MATERIAL_CTRL_TYPE.value == "") {
			alert("대분류, 중분류를 선택하셔야 합니다.");
			return;
		}
	}
	form1.BUYER_ITEM_NO.value = form1.BUYER_ITEM_NO.value.toUpperCase() ;
	*/
	if(form1.MATERIAL_TYPE.value == "") {
		if (!confirm ("카테고리 대분류를 선택하지 않았습니다.\n\n분류를 선택하지 않을 경우 조회시간이 오래 걸릴 수 있습니다.\n\n조회하시겠습니까?")) {
			return;
		}
	}

	GridObj.SetParam("mode", "getCatalog2");
	GridObj.SetParam("MATERIAL_TYPE", 	form1.MATERIAL_TYPE.value);
	GridObj.SetParam("MATERIAL_CTRL_TYPE",form1.MATERIAL_CTRL_TYPE.value);
	GridObj.SetParam("MATERIAL_CLASS1", 	form1.MATERIAL_CLASS1.value);
	GridObj.SetParam("MATERIAL_CLASS2", 	form1.MATERIAL_CLASS2.value);
	GridObj.SetParam("MAKER_NAME", 		form1.MAKER_NAME.value);
	GridObj.SetParam("DESCRIPTION_LOC", 	form1.DESCRIPTION_TEXT.value);
	GridObj.SetParam("COMPANY_CODE", 		G_COMPANY_CODE);
	GridObj.SetParam("VENDOR_CODE", 		<%=vendor_code%>);
	GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","0");
	GridObj.SendData(G_SERVLETURL);
}

/*
	opener의 와이즈테이블에 값을 셋팅한다.
*/
function doInsert()
{
	var Sepoa = GridObj;
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = getCheckedCount(Sepoa, INDEX_SEL);
    var arr = new Array(G_INDEXES.length);

	if(iCheckedCount == 0)
    {
		alert(G_MSS1_SELECT);
		return;
    }

    var arr_cnt = 0;
	parent.opener.GridObj.height = 1;
    for(var i=0; i<iRowCount; i++)
    {
        if( GD_GetCellValueIndex(GridObj,i, INDEX_SEL) == "true")
        {
        	for(var j=0;j<G_INDEXES.length;j++)
        	{
        		for(var k=0;k<INDEX_HEADERS.length;k++)
        		{
	        		if(G_INDEXES[j] == INDEX_HEADERS[k])
	        		{
	        			var VAR_INDEX = eval("INDEX_"+G_INDEXES[j]);
	        			arr[arr_cnt++] = GD_GetCellValueIndex(GridObj,i, VAR_INDEX);
	        		}
        		}
        	}
        	arr_cnt = 0;
            /*
            var dup_flag = false;
            var mat = arr[parent.opener.getCatalogIndex("MATERIAL_TYPE")]
            for(var j=0;j<parent.opener.GridObj.GetRowCount();j++) {
                if(mat == "SI" ) {
                	if(parent.opener.GridObj.GetCellValue("MATERIAL_TYPE", j) != "SI" ) {
                		dup_flag = true;
                        break;
                	}
                }
                else{
                	if(parent.opener.GridObj.GetCellValue("MATERIAL_TYPE", j) == "SI" ) {
                		dup_flag = true;
                        break;
                	}
                }
            }

            if(!dup_flag){
                parent.opener.setCatalog(arr);
            }
            else{
   	        	alert("용역과 IT품목은 동시 구매요청 할 수 없습니다");
   	        	parent.opener.GridObj.height = 250;
   	        	return;
            }
            */
            parent.opener.setCatalog(arr);
        }
    }
    parent.opener.GridObj.height = 250;
	//parent.opener.getItemValue();
	if (confirm ("선택되었습니다.\n\n카탈로그 검색창을 닫으시겠습니까?")) {
		parent.window.close();
	}
}

function doInsertGate()
{
	var Sepoa = GridObj;
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = getCheckedCount(Sepoa, INDEX_SEL);
    var arr = new Array(G_INDEXES.length);

	if(iCheckedCount == 0)
    {
		alert(G_MSS1_SELECT);
		return;
    }

    var arr_cnt = 0;

    for(var i=0; i<iRowCount; i++)
    {
        if( GD_GetCellValueIndex(GridObj,i, INDEX_SEL) == "true")
        {
        	for(var j=0;j<G_INDEXES.length;j++)
        	{
        		for(var k=0;k<INDEX_HEADERS.length;k++)
        		{
	        		if(G_INDEXES[j] == INDEX_HEADERS[k])
	        		{
	        			var VAR_INDEX = eval("INDEX_"+G_INDEXES[j]);
	        			arr[arr_cnt++] = GD_GetCellValueIndex(GridObj,i, VAR_INDEX);
	        		}
        		}
        	}
        	arr_cnt = 0;
            parent.parent.setCatalog(arr);
        }
    }
}

function clearMATERIAL_CTRL_TYPE() {
    if(form1.MATERIAL_CTRL_TYPE.length > 0) {
        for(i=form1.MATERIAL_CTRL_TYPE.length-1; i>=0;  i--) {
            form1.MATERIAL_CTRL_TYPE.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS1() {
    if(form1.MATERIAL_CLASS1.length > 0) {
        for(i=form1.MATERIAL_CLASS1.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS1.options[i] = null;
        }
    }
}

function clearMATERIAL_CLASS2() {
    if(form1.MATERIAL_CLASS2.length > 0) {
        for(i=form1.MATERIAL_CLASS2.length-1; i>=0;  i--) {
            form1.MATERIAL_CLASS2.options[i] = null;
        }
    }
}

function setMATERIAL_CTRL_TYPE(name, value) {
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CTRL_TYPE.options[form1.MATERIAL_CTRL_TYPE.length] = option1;
}

function setMATERIAL_CLASS1(name, value)
{
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS1.options[form1.MATERIAL_CLASS1.length] = option1;
}

function setMATERIAL_CLASS2(name, value)
{
    var option1 = new Option(name, value, true);
    form1.MATERIAL_CLASS2.options[form1.MATERIAL_CLASS2.length] = option1;
}

function MATERIAL_TYPE_Changed() {
    clearMATERIAL_CTRL_TYPE();
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS1("----------", "");
    setMATERIAL_CLASS2("----------", "");

    var id = "SL0009";
    var code = "M041";

    var value = form1.MATERIAL_TYPE.value;
    target = "MATERIAL_TYPE";

    data = "/kr/dt/pr/pr1_pp_lis2_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    parent.mainFrame.location.href = data;
}

function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2("----------", "");
    var id = "SL0019";
    var code = "M042";

    var value = form1.MATERIAL_CTRL_TYPE.value;
    target = "MATERIAL_CTRL_TYPE";
    data = "/kr/dt/pr/pr1_pp_lis2_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    parent.mainFrame.location.href = data;
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    var id = "SL0089";
    var code = "M122";

    var value = form1.MATERIAL_CLASS1.value;
    target = "MATERIAL_CLASS1";
    data = "/kr/dt/pr/pr1_pp_lis2_hidden.jsp?target=" + target + "&id=" + id + "&code=" + code + "&value=" + value;

    parent.mainFrame.location.href = data;
}


function myCatalog() {
    row = GridObj.GetRowCount();
    var sendRow="";
    var sendcnt = 0;

    //체크된 거 있는지 여부조사하고 sendRow를 만들어 보낸다.
    //servlet을 작성한다.
    for(var i = 0;i < row;i++){
        var check = GD_GetCellValueIndex(GridObj,i,INDEX_SEL);
        if(check == "true"){
            sendcnt++;
            sendRow += (i+"&");
        }//end of if(true)
    }//end of for

    if(sendcnt == 0) {
        alert(G_MSS1_SELECT);
        return;
    }

	GridObj.SetParam("SepoaTABLE_DOQUERY_DODATA","1");
	GridObj.SendData(G_SERVLETURL, "ALL", "ALL");
}

function getItemSelect()
{
    var items = "";
    for(var i = 0;i < row;i++)
    {
        var check = GD_GetCellValueIndex(GridObj,i,INDEX_SEL);
        if(check == "true")
        {
            items += GD_GetCellValueIndex(GridObj,i,INDEX_ITEM_NO)+"||";
        }//end of if(true)
    }//end of for
    return items;
}

function goCatalog_SelectPop()
{
    var url = "/kr/catalog/mycat_pp_select_frame.jsp";
    var width = 201
    var height = 500;
    var dim = new Array(2);
    dim = CenterWindow(height,width);
    top = dim[0];
    left = dim[1];
    var left = left;
    var top = top;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'no';
    var resizable = 'no';
    var mycatalog_sel_pop = window.open( url, 'mycatalog_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    mycatalog_sel_pop.focus();
}

function JavaCall(msg1, msg2, msg3, msg4, msg5)
{
    if(msg1 == "doQuery") {
        if(mode == "getCatalog2")
        {
            TOTAL_CUR = "";
            TMP_CUR = "";
            if("1" == GridObj.GetStatus()) {
                objSize = GridObj.GetParamCount();
                for(i=0; i<objSize; i++) {
                    TOTAL_CUR += GD_GetParam(GridObj,i) + "@" + GD_GetParam(GridObj,i) + "$";
                }
            }
        }
    }

    if(msg1 == "doData")
    {
		var mode  = GD_GetParam(GridObj,0);
		var status= GD_GetParam(GridObj,1);

        if(mode == "insertmyCatalog")
        {
            alert("나의 카탈로그에 등록되었습니다.");
            return;
        }
        else if(mode == "getDivision")
        {
            var szData = GD_GetParam(GridObj,0);
            var szColumn = GD_GetParam(GridObj,1);
            var szRowData = szData.split("???");
            var addColumn = szColumn.split("&");
            var k=0;
            for(var i=0; i<szRowData.length-1; i++)
            {
                var szColData = szRowData[i].split("@");
                if("null" == szColData[0]) szColData[0] = "";
                if("null" == szColData[1]) szColData[1] = "";
                if("null" == szColData[2]) szColData[2] = "";
                if("null" == szColData[3]) szColData[3] = "";
                if("null" == szColData[4]) szColData[4] = "";
                if("null" == szColData[5]) szColData[5] = "";
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_UNIT_PRICE, szColData[0]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_CODE, szColData[1]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_COUNT, szColData[2]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_NAME, szColData[3]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_CUR, szColData[4]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_MOLDING_QTY, szColData[5]);
                k++;
            }
            doInsert();
        }
    }

    if(msg1 == "t_imagetext") {
        if(msg3 == INDEX_ITEM_NO) { //품번
            var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
            POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "품목_일반정보", '0', '0', '800', '700');
        }
    }

    if(msg1 == "t_insert") {
        if(msg3 == INDEX_SEL) {
            if(GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ITEM_BLOCK_FLAG),msg2) != "N"){
                alert(GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO)+" 품목코드는 거래가 일시정지된 품번입니다.");
                GD_SetCellValueIndex(GridObj,msg2, INDEX_SEL,"false&", "&");
            }
        }
    }
}

function POPUP_Open(url, title, left, top, width, height)
{
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    code_search.focus();
}
//-->

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
		GD_CellClick(document.SepoaGrid,strColumnKey, nRow);

    
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
    // Sepoa그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
    if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    } 
    return true;
}
</script>

</head>
<body onload="javascript:setGridDraw();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >

<s:header>
<!--내용시작-->
<div align="center">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="left" class="cell_title1">&nbsp;<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_arr02.gif" width="12" height="12" align="absmiddle">
		품목마스터 검색
	</td>
</tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td width="760" height="2" bgcolor="#0072bc"></td></tr>
</table>

<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#ccd5de">
<form name="form1" action="">
	<input type="hidden" name="childSepoamilestone" value="">

	<tr>
		<td width="15%" class="c_title_1">
			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;대분류
		</td>
		<td width="35%" class="c_data_1">
			<select name="MATERIAL_TYPE" class="input_re" onChange="javacsript:MATERIAL_TYPE_Changed();">
				<option value=''>:::전체:::</option>
				<%=LB_MATERIAL_TYPE%>
			</select>
		</td>
		<td width="15%" class="c_title_1">
			<div align="left">
				<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;중분류
			</div>
		</td>
		<td width="35%" class="c_data_1">
			<select name="MATERIAL_CTRL_TYPE" class="inputsubmit" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();">
				<option value=''>:::전체:::</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="c_title_1">
			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;소분류
		</td>
		<td class="c_data_1">
			<select name="MATERIAL_CLASS1" class="inputsubmit" onChange="javacsript:MATERIAL_CLASS1_Changed();">
				<option value=''>:::전체:::</option>
			</select>
		</td>
		<td class="c_title_1">
			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;세분류
		</td>
		<td class="c_data_1">
			<select name="MATERIAL_CLASS2" class="inputsubmit">
				<option value=''>:::전체:::</option>
			</select>
		</td>
	</tr>
	<tr>
		<td class="c_title_1">
			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;품목명
		</td>
		<td class="c_data_1">
			<input type="hidden" name="DESCRIPTION" value="LOC">
			<input type="text" name="DESCRIPTION_TEXT" style="width:90%" class="inputsubmit">
		</td>
		<td class="c_title_1">
			<img src="/images/<%=info.getSession("HOUSE_CODE")%>/ibk_s_arr.gif" width="9" height="9">&nbsp;제조사
		</td>
		<td class="c_data_1" colspan="3">
			<input type="text" name="MAKER_NAME" style="width:90%" class="inputsubmit">
		</td>
	</tr>
</table>

<script language="javascript">rdtable_bot1()</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
      		<td height="30" align="right">
				<TABLE cellpadding="0">
		      		<TR>

	    	  			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
<%if(gate.equals("")){%>
						<TD><script language="javascript">btn("javascript:myCatalog()","나의카탈로그담기")   </script></TD>
<%}%>
<%if(gate.equals("gate")){%>
		      			<TD><script language="javascript">btn("javascript:doInsertGate()","선 택")</script></TD>
		      			<TD><script language="javascript">btn("javascript:window.close()","닫 기")</script></TD>
<%}else {%>
						<TD><script language="javascript">btn("javascript:doInsert()","선 택")</script></TD>
						<TD><script language="javascript">btn("javascript:top.window.close()","닫 기")</script></TD>
<%}%>
	    	  		</TR>
      			</TABLE>
      		</td>
    	</tr>
  	</table>

</div>
</form>


</s:header>
<s:grid screen_id="PO_010" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
<iframe name="childFrame" src="" frameborder="0" width="0" height="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>
</html>




