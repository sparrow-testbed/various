<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%!
private String nvl(String str, String defaultValue) throws Exception{
	String result = null;
	
	if(str == null){
		str = "";
	}
	
	if(str.equals("")){
		result = defaultValue;
	}
	else{
		result = str;
	}
	
	return result;
}
%>
<%
	Vector  multilang_id       = new Vector();
	HashMap text               = null;
	String  screen_id          = "PR_003";
	String  grid_obj           = "GridObj";
	String  WISEHUB_PROCESS_ID = "PR_003";
	String  isSingle           = request.getParameter("isSingle");
	boolean isSelectScreen     = false;
	
	multilang_id.addElement("PR_003");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	text     = MessageUtil.getMessage(info, multilang_id);
	isSingle = this.nvl(isSingle, "N");
	
	String INDEX        = JSPUtil.nullToEmpty(request.getParameter("INDEX"));
	String gate         = JSPUtil.nullToEmpty(request.getParameter("gate")); // 외부에서 접근하였을 경우 flag
	String VENDOR_CODE = JSPUtil.nullToEmpty(request.getParameter("VENDOR_CODE"));

	String LB_MATERIAL_TYPE = ListBox(request, "SL0151", info.getSession("HOUSE_CODE") + "#M040", "");
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<script language="javascript" type="text/javascript">
var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.cat_pp_lis_main";
var G_INDEXES    = "<%=INDEX%>".split(":");
var mode;
var TOTAL_CUR;
var G_COMPANY_CODE = "<%=info.getSession("COMPANY_CODE")%>";
var INDEX_SEL = "SEL";
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
var INDEX_KTGRM		;
var INDEX_C_UNIT_PRICE		;
var INDEX_MAKE_AMT_CODE		;
var INDEX_MAKE_AMT_NAME		;
var INDEX_MAKE_AMT_UNIT		;
var INDEX_C_UNIT_PRICE		;
var INDEX_IMAGE_FILE_PATH		;
var INDEX_WID;
var INDEX_HGT;


var INDEX_HEADERS = new Array(
		"SEL"      				 , "MATERIAL_TYPE"    		, "MATERIAL_CTRL_TYPE"  , "MATERIAL_CLASS1"	  	, "ITEM_NO"
	  , "DESCRIPTION_LOC"        , "DESCRIPTION_ENG"  		, "SPECIFICATION"  	  	, "PURCHASE_DEPT_NAME"  , "PURCHASER_NAME"
	  , "CTRL_PERSON_ID"		 , "PURCHASE_DEPT" 	  		, "ITEM_BLOCK_FLAG"     , "BASIC_UNIT"          , "CTRL_CODE"
	  , "PURCHASE_LOCATION"      , "PURCHASE_LOCATION_NAME" , "PREV_UNIT_PRICE"     , "DELIVERY_IT" 		, "SG_REFITEM"
	  , "MAKER_NAME"			 , "MAKER_CODE"				, "ITEM_GROUP" 			, "ITEMFLAG"			, "DELY_TO_ADDRESS"
	  , "KTGRM"
	);

function setHeader(){
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
	INDEX_KTGRM  	 	 		 = GridObj.GetColHDIndex("KTGRM") ;
	INDEX_C_UNIT_PRICE = GridObj.GetColHDIndex("C_UNIT_PRICE") ;
	INDEX_MAKE_AMT_CODE = GridObj.GetColHDIndex("MAKE_AMT_CODE") ;
	INDEX_MAKE_AMT_NAME = GridObj.GetColHDIndex("MAKE_AMT_NAME") ;
	INDEX_MAKE_AMT_UNIT = GridObj.GetColHDIndex("MAKE_AMT_UNIT") ;
	INDEX_C_UNIT_PRICE = GridObj.GetColHDIndex("C_UNIT_PRICE") ;
	INDEX_IMAGE_FILE_PATH = GridObj.GetColHDIndex("IMAGE_FILE_PATH") ;
	
	INDEX_WID = GridObj.GetColHDIndex("WID") ;
	INDEX_HGT = GridObj.GetColHDIndex("HGT") ;
}

function doSelect(){
	if(
		(document.getElementById("DESCRIPTION_TEXT").value == "") &&
		(document.getElementById("MAKER_NAME").value == "") &&
		(document.getElementById("ITEM_NO").value == "")
	){
		if(form1.MATERIAL_TYPE.value == "") {
			
			alert("대분류와 중분류 카테고리 선택은 필수 입니다.");
			
			return;
		}
		
		if(form1.MATERIAL_CTRL_TYPE.value == "") {
			alert("중분류 카테고리 선택은 필수 입니다.");
			
			return;
		}
	}
	
	var params = "mode=getCatalogSo";
	
	params += "&cols_ids=" + "<%=grid_col_id%>";
	params += dataOutput();
	GridObj.post(G_SERVLETURL, params );
	GridObj.clearAll(false);
}

function doInsert(){
	var wise          = GridObj; // ???
	var iRowCount     = GridObj.GetRowCount(); // 품목마스터 그리드 조회 카운트
	var iCheckedCount = getCheckedCount(wise, "SEL"); // 선택된 로우 갯수
    var arr           = new Array(G_INDEXES.length); // 파라미터로 넘어온 인덱스 배열 크기 만큼...
    var arr_cnt       = 0;

	if(iCheckedCount == 0){ // 선택된 로우가 없을 경우
		alert(G_MSS1_SELECT);
		return;
    }
	
	var gate = "<%=gate%>";
	if(gate == "gate_a") {
		var grid_array = getGridChangedRows(GridObj, "SEL");
		for(var z = 0; z < grid_array.length; z++) {
			var c_unit_price = GridObj.cells(grid_array[z], GridObj.getColIndexById("C_UNIT_PRICE")).getValue();
			
			if(c_unit_price == "" || c_unit_price == "0") {
				alert("추가할 수 없는 품목 입니다.");
				return;
			}
		}
	}
	
<%
	if("Y".equals(isSingle)){
%>
	if(iCheckedCount > 1){
		alert("하나의 품목만 선택하여 주십시오.");
		
		return;
	}
<%
	}
%>
/*
    for(var i = 0; i < iRowCount; i++){
        if( GD_GetCellValueIndex(GridObj, i, INDEX_SEL) == true){
        	for(var j = 0;j < G_INDEXES.length; j++){
        		for(var k = 0; k < INDEX_HEADERS.length; k++){
        			if(G_INDEXES[j] == INDEX_HEADERS[k]){
	        			var VAR_INDEX = eval("INDEX_"+G_INDEXES[j]);
	        			
	        			arr[arr_cnt++] = GD_GetCellValueIndex(GridObj, i, VAR_INDEX);
	        		}
        		}
        	}
        	
        	arr     = new Array(G_INDEXES.length);
        	arr_cnt = 0;
        	*/
        	
        	parent.opener._openFlag = true;
        	
        	var grid_array = getGridChangedRows(GridObj, "SEL");
        	 for(var i = 0; i < grid_array.length; i++){
        		 
       			 var rowIndex   = GridObj.getRowIndex(grid_array[i]);
	           	parent.opener.setCatalog(
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_DESCRIPTION_LOC),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_SPECIFICATION),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MAKER_CODE),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_CTRL_CODE),
					"",
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_GROUP),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_DELY_TO_ADDRESS),
					"",
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_KTGRM),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MAKER_NAME),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_BASIC_UNIT),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MATERIAL_TYPE),
					"",
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_C_UNIT_PRICE),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MAKE_AMT_CODE),
					"",
					"",
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MAKE_AMT_NAME),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_MAKE_AMT_UNIT),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_C_UNIT_PRICE),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_IMAGE_FILE_PATH),
					
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_WID),
					GD_GetCellValueIndex(GridObj, rowIndex, INDEX_HGT)
				);	      
		    }
        	parent.opener._openFlag = false;	         	
		    
        	parent.window.close();
        	
        	/* 
			if(confirm ("선택되었습니다.\n\n카탈로그 검색창을 닫으시겠습니까?")) {
				parent.window.close();
			}
        	*/
}

function doInsertGate(){
	var wise = GridObj;
	var iRowCount = GridObj.GetRowCount();
	var iCheckedCount = getCheckedCount(wise, INDEX_SEL);
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
    setMATERIAL_CLASS1(":::전체:::", "");
    setMATERIAL_CLASS2(":::전체:::", "");
 
  	var materialType     = document.getElementById("MATERIAL_TYPE");
  	var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M041";
  	param = param + "#" + materialType.value;
  
	doRequestUsingPOST( 'SL0152', param ,'MATERIAL_CTRL_TYPE', '', false);	//false:동기, true:비동기모드
	
	option.text  = ":::전체:::";
	option.value = "";
	
	materialCtrlType.add(option, 0);
	materialCtrlType.value = "";
}

function MATERIAL_CTRL_TYPE_Changed()
{
    clearMATERIAL_CLASS1();
    clearMATERIAL_CLASS2();
    setMATERIAL_CLASS2(":::전체:::", "");
        
    var materialCtrlType = document.getElementById("MATERIAL_CTRL_TYPE");
    var materialClass1   = document.getElementById("MATERIAL_CLASS1");
  	var param            = "<%=info.getSession("HOUSE_CODE")%>";
  	var option           = document.createElement("option");
  	
  	param = param + "#" + "M042";
  	param = param + "#" + materialCtrlType.value;
    
    doRequestUsingPOST( 'SL0153', param ,'MATERIAL_CLASS1', '', false);
    
    option.text = ":::전체:::";
    option.value = "";
    
    materialClass1.add(option, 0);
    materialClass1.value = "";
}

function MATERIAL_CLASS1_Changed()
{
    clearMATERIAL_CLASS2();
    
    var materialClass1 = document.getElementById("MATERIAL_CLASS1");
    var materialClass2 = document.getElementById("MATERIAL_CLASS2");
  	var param          = "<%=info.getSession("HOUSE_CODE")%>";
  	var option         = document.createElement("option");
  	
  	param = param + "#" + "M122";
  	param = param + "#" + materialClass1.value;
    
    doRequestUsingPOST( 'SL0154', param ,'MATERIAL_CLASS2', '', false);
    
	option.text = ":::전체:::";
	option.value = "";
    
    materialClass2.add(option, 0);
    materialClass2.value = "";
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
        if(mode == "getCatalog")
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
            POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "품목_일반정보", '0', '0', '800', '550');
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
function doOnRowSelected(rowId,cellInd){
	if(cellInd == GridObj.getColIndexById("ITEM_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var itemNo     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	} 
	
	if(cellInd == GridObj.getColIndexById("IMAGE_FILE")) {
		
		var item_no         = SepoaGridGetCellValueId(GridObj, rowId, "ITEM_NO");
		var image_file_path = SepoaGridGetCellValueId(GridObj, rowId, "IMAGE_FILE_PATH");
		
		if(image_file_path != null && image_file_path != "") {
			
			var url    = "/common/image_view_popup.jsp";
// 			var title  = "이미지보기";
// 			var param  = "item_no=" + item_no;
			
// 			popUpOpen01(url, title, "850", "650", param);
			window.open(url + '?item_no=' + item_no ,"windowopen1","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=yes,width=850,height=650,left=0,top=0");
			
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
        doSelect();
    } else {
        alert(messsage);
    }
    /* if("undefined" != typeof JavaCall) {
    	JavaCall("doData");
    }  */

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
//     	JavaCall("doQuery");
    } 
    return true;
}

function entKeyDown(){
	if(event.keyCode==13) {
		doSelect();
	}
}
</script>
</head>
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<div>
		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>카테고리 조회</span>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		<form name="form1" action="">
			<input type="hidden" name="childwisemilestone" id="childwisemilestone" value="">
			<input type="hidden" name="VENDOR_CODE" id="VENDOR_CODE" value="<%=VENDOR_CODE%>">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
							<tr>
								<td width="100%">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;대분류</td>
											<td width="35%" class="data_td">
												<select name="MATERIAL_TYPE" class="input_re" onChange="javacsript:MATERIAL_TYPE_Changed();", id="MATERIAL_TYPE">
													<option value=''>:::전체:::</option>
													<%=LB_MATERIAL_TYPE%>
												</select>
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;중분류</td>
											<td width="35%" class="data_td">
												<select name="MATERIAL_CTRL_TYPE" id="MATERIAL_CTRL_TYPE" onChange="javacsript:MATERIAL_CTRL_TYPE_Changed();" class="input_re">
													<option value=''>:::전체:::</option>
												</select>
											</td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;소분류</td>
											<td width="35%" class="data_td">
												<select name="MATERIAL_CLASS1" id="MATERIAL_CLASS1" onChange="javacsript:MATERIAL_CLASS1_Changed();">
													<option value=''>:::전체:::</option>
												</select>
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;세분류</td>
											<td width="35%" class="data_td">
												<select name="MATERIAL_CLASS2" id="MATERIAL_CLASS2">
													<option value=''>:::전체:::</option>
												</select>
											</td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
											<td width="35%" class="data_td">
												<input type="hidden" name="DESCRIPTION" id="DESCRIPTION" value="LOC">
												<input type="text" name="DESCRIPTION_TEXT" id="DESCRIPTION_TEXT" style="width:90%" onkeydown="javascript:entKeyDown();">
											</td>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
											<td width="35%" class="data_td">
												<input type="text" name="MAKER_NAME" id="MAKER_NAME" style="width:90%" onkeydown="javascript:entKeyDown();" />
											</td>
										</tr>
										<tr>
											<td colspan="4" height="1" bgcolor="#dedede"></td>
										</tr>
										<tr>
											<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
											<td width="35%" class="data_td">
												<input type="text" name="ITEM_NO" id="ITEM_NO" style="width:90%;ime-mode:inactive" onkeydown="javascript:entKeyDown();">
											</td>
											<td class="data_td" colspan="2">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="30" align="right">
						<TABLE cellpadding="0">
							<TR>
								<TD>
									<script language="javascript">
										btn("javascript:doSelect()", "조 회");
									</script>
								</TD>
								<TD>
									<script language="javascript">
<%
	if(gate.equals("gate")){
%>
										btn("javascript:doInsertGate()", "선 택");
<%
	}
	else{
%>
										btn("javascript:doInsert()", "선 택");
<%
	}
%>
									</script>
								</TD>
				      			<TD>
				      				<script language="javascript">
				      					btn("javascript:parent.window.close()", "닫 기");
				      				</script>
				      			</TD>
							</TR>
						</TABLE>
		      		</td>
		    	</tr>
		  	</table>
	  	</form>
	</div>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_003" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>