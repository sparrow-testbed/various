<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_T03");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_T03";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP --%>
<%@ include file="/include/sepoa_grid_common.jsp"              %><!-- 그리드COMMON  -->
<%@ include file="/include/jslb_ajax_selectbox.jsp"                 %><!-- AJAX SELECTBOX -->
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>

<%
//## 2003.04.09.(신병곤) 나의 카타로그 조회시 경우에 따라 icommtsl.str_bin 조회 추가를 위하여 str_bin_flag, company_code 추가 (icoyprdt.dely_to_location2 = icommtsl.str_bin)
String INDEX    = JSPUtil.nullToEmpty(request.getParameter("INDEX"));
String manual   = JSPUtil.nullToEmpty(request.getParameter("manual"));
String WISEHUB_PROCESS_ID="PR_T03";
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<!-- Wisehub Common Scripts -->

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
<script language="javascript">
var mode;
var G_INDEXES    = "<%=INDEX%>".split(":");

var TOTAL_CUR;
var G_COMPANY_CODE = "<%=info.getSession("COMPANY_CODE")%>";

var INDEX_SEL                   ;
var INDEX_MATERIAL_TYPE         ;
var INDEX_MATERIAL_CTRL_TYPE    ;
var INDEX_MATERIAL_CLASS1       ;
var INDEX_ITEM_NO         		;
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
var INDEX_PREV_UNIT_PRICE       ;
var INDEX_MENU_FIELD_CODE       ;

var INDEX_UNIT_PRICE			;
var INDEX_VENDER_CODE			;
var INDEX_VENDER_NAME			;
var INDEX_VENDER_COUNT			;
var INDEX_CUR					;
var INDEX_ITEM_GROUP			;
var INDEX_ITEMFLAG				;
var INDEX_DELY_TO_ADDRESS		;
var INDEX_KTGRM		;
var INDEX_IMAGE_FILE_PATH		;

var INDEX_HEADERS = new Array(
		"SEL"      				 , "MATERIAL_TYPE"    		, "MATERIAL_CTRL_TYPE"  , "MATERIAL_CLASS1"	  	, "ITEM_NO"
	  , "DESCRIPTION_LOC"        , "DESCRIPTION_ENG"  		, "SPECIFICATION"  	  	, "PURCHASE_DEPT_NAME"  , "PURCHASER_NAME"
	  , "CTRL_PERSON_ID"		 , "PURCHASE_DEPT" 	  		, "ITEM_BLOCK_FLAG"     , "BASIC_UNIT"          , "CTRL_CODE"
	  , "PURCHASE_LOCATION"      , "PURCHASE_LOCATION_NAME" , "PREV_UNIT_PRICE"     , "SG_REFITEM"
	  , "MAKER_NAME"			 , "MAKER_CODE"  			, "ITEM_GROUP"			, "ITEMFLAG"			, "DELY_TO_ADDRESS"
	  , "KTGRM"
	);

function setHeader(){
	INDEX_SEL                    	= GridObj.GetColHDIndex("SEL") ;
	INDEX_MATERIAL_TYPE          	= GridObj.GetColHDIndex("MATERIAL_TYPE") ;
	INDEX_MATERIAL_CTRL_TYPE     	= GridObj.GetColHDIndex("MATERIAL_CTRL_TYPE") ;
	INDEX_MATERIAL_CLASS1        	= GridObj.GetColHDIndex("MATERIAL_CLASS1") ;
	INDEX_ITEM_NO           		= GridObj.GetColHDIndex("BUYER_ITEM_NO") ;
	INDEX_DESCRIPTION_LOC        	= GridObj.GetColHDIndex("DESCRIPTION_LOC") ;
	INDEX_DESCRIPTION_ENG        	= GridObj.GetColHDIndex("DESCRIPTION_ENG") ;
	INDEX_SPECIFICATION          	= GridObj.GetColHDIndex("SPECIFICATION") ;
	INDEX_PURCHASE_DEPT_NAME     	= GridObj.GetColHDIndex("PURCHASE_DEPT_NAME") ;
	INDEX_PURCHASER_NAME         	= GridObj.GetColHDIndex("PURCHASER_NAME") ;
	INDEX_CTRL_PERSON_ID         	= GridObj.GetColHDIndex("CTRL_PERSON_ID") ;
	INDEX_PURCHASE_DEPT          	= GridObj.GetColHDIndex("PURCHASE_DEPT") ;
	INDEX_ITEM_BLOCK_FLAG        	= GridObj.GetColHDIndex("ITEM_BLOCK_FLAG") ;
	INDEX_BASIC_UNIT             	= GridObj.GetColHDIndex("BASIC_UNIT") ;
	INDEX_CTRL_CODE              	= GridObj.GetColHDIndex("CTRL_CODE") ;
	INDEX_PURCHASE_LOCATION      	= GridObj.GetColHDIndex("PURCHASE_LOCATION") ;
	INDEX_PURCHASE_LOCATION_NAME 	= GridObj.GetColHDIndex("PURCHASE_LOCATION_NAME") ;
	INDEX_PREV_UNIT_PRICE        	= GridObj.GetColHDIndex("PREV_UNIT_PRICE") ;
	INDEX_MENU_FIELD_CODE        	= GridObj.GetColHDIndex("MENU_FIELD_CODE") ;
	INDEX_SG_REFITEM   			 	= GridObj.GetColHDIndex("SG_REFITEM") ;
	INDEX_UNIT_PRICE        			= GridObj.GetColHDIndex("UNIT_PRICE");
  	INDEX_VENDER_CODE       			= GridObj.GetColHDIndex("VENDER_CODE");
  	INDEX_VENDER_NAME       			= GridObj.GetColHDIndex("VENDER_NAME");
  	INDEX_VENDER_COUNT      			= GridObj.GetColHDIndex("VENDER_COUNT");
  	INDEX_CUR               			= GridObj.GetColHDIndex("CUR");
  	INDEX_MAKER_CODE               		= GridObj.GetColHDIndex("MAKER_CODE");
  	INDEX_MAKER_NAME               		= GridObj.GetColHDIndex("MAKER_NAME");
  	INDEX_ITEM_GROUP               		= GridObj.GetColHDIndex("ITEM_GROUP");
  	INDEX_ITEMFLAG               		= GridObj.GetColHDIndex("ITEMFLAG");
	INDEX_DELY_TO_ADDRESS  	 	 = GridObj.GetColHDIndex("DELY_TO_ADDRESS") ;
	INDEX_KTGRM  	 	 		 = GridObj.GetColHDIndex("KTGRM") ;
	INDEX_IMAGE_FILE_PATH		= GridObj.GetColHDIndex("IMAGE_FILE_PATH") ;
}

function doSelect(){
	form1.BUYER_ITEM_NO.value = form1.BUYER_ITEM_NO.value.toUpperCase() ;

    servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.mycat_pp_lis";
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getmyCatalog";
	params += "&cols_ids=" + cols_ids;
	params += dataOutput();
	
	GridObj.post(servletUrl, params );
	GridObj.clearAll(false);
}

function doData() {
    var selected = "";
    rowcount = GridObj.GetRowCount();

    for(row=0; row<rowcount; row++) {
        if( "true" == GD_GetCellValueIndex(GridObj,row, "0")) {
            selected += row + "&";
        }
    }

    if(selected == "" && selected != "0") {
        alert("하나 선택하셔야죠!");
        return;
    }
    if("<%=manual%>" == "M"){ //품의일 경우는 종가를 가져오기위한 작업이 필요하다.
        servletUrl = "/servlets/dt.pr.pr1_bd_lis3";

        GridObj.SetParam("mode", "getDivision");
        GridObj.SetParam("selected", selected);
        GridObj.SetParam("shipper_type", "D");

        mode = "getDivision";
        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");
    } else { // RFQ에서는 종가가 필요없으므로, 그냥 값을 조회된것들에서만 가져온다.
        doInsert();
    }
}

function doInsert(){
	var wise          = GridObj;
	var iRowCount     = GridObj.GetRowCount();
	//var iCheckedCount = getCheckedCount(wise, INDEX_SEL); // 인덱스가 아닌 칼럼명으로 가지고 와야함
	var iCheckedCount = getCheckedCount(wise, "SEL");
	var arr           = new Array(G_INDEXES.length);

	if(iCheckedCount == 0){
		alert(G_MSS1_SELECT);
		
		return;
    }

    var arr_cnt = 0;

    for(var i=0; i<iRowCount; i++){
        //if( GD_GetCellValueIndex(GridObj,i, INDEX_SEL) == "true"){ // 문자열에서 boolean으로 변경
        if( GD_GetCellValueIndex(GridObj,i, INDEX_SEL) == true){
        	for(var j=0;j<G_INDEXES.length;j++){
        		for(var k=0;k<INDEX_HEADERS.length;k++){
	        		if(G_INDEXES[j] == INDEX_HEADERS[k]){
	        			var VAR_INDEX = eval("INDEX_"+G_INDEXES[j]);
	        			
	        			arr[arr_cnt++] = GD_GetCellValueIndex(GridObj,i, VAR_INDEX);
	        		}
        		}
        	}

        	arr_cnt = 0;

            var dup_flag = false;
            var mat      = arr[parent.opener.getCatalogIndex("MATERIAL_TYPE")]
            
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
                //parent.opener.setCatalog(arr); // 부모창에서 값을 제대로 받지 못해변경
            	parent.opener.setCatalog(
       				GD_GetCellValueIndex(GridObj, i, INDEX_ITEM_NO),
       				GD_GetCellValueIndex(GridObj, i, INDEX_DESCRIPTION_LOC),
       				GD_GetCellValueIndex(GridObj, i, INDEX_SPECIFICATION),
       				GD_GetCellValueIndex(GridObj, i, INDEX_MAKER_CODE),
       				GD_GetCellValueIndex(GridObj, i, INDEX_CTRL_CODE),
       				"",
       				GD_GetCellValueIndex(GridObj, i, INDEX_ITEM_GROUP),
       				GD_GetCellValueIndex(GridObj, i, INDEX_DELY_TO_ADDRESS),
       				"",
       				GD_GetCellValueIndex(GridObj, i, INDEX_KTGRM),
       				GD_GetCellValueIndex(GridObj, i, INDEX_MAKER_NAME),
       				GD_GetCellValueIndex(GridObj, i, INDEX_BASIC_UNIT),
       				GD_GetCellValueIndex(GridObj, i, INDEX_MATERIAL_TYPE),
       				"",
       				"",
       				"",
       				"",
       				"",
       				"",
       				"",
       				"",
       				GD_GetCellValueIndex(GridObj, i, INDEX_IMAGE_FILE_PATH)
       			);
            }
            else{
   	        	alert("용역과 IT품목은 동시 구매요청 할 수 없습니다");
   	        	parent.opener.GridObj.height = 250;
   	        	return;
            }
        }
    }
    //parent.opener.getItemValue();
	if (confirm ("선택되었습니다.\n\n카탈로그 검색창을 닫으시겠습니까?")) {
		parent.window.close();
	}
}
function doInsertM()
{
    checked_count = 0;
    rowcount = GridObj.GetRowCount();
    var manual = "<%=manual%>";

    var s_item_no = "";
    var s_des_loc = "";
    var s_unit_mea = "";

    for(row=0; row<rowcount; row++)
    {
        if(manual = "M")   //기존루틴(RFQ등등..에서 호출)
        {
            if( "true" == GD_GetCellValueIndex(GridObj,row, "0"))
            {
                checked_count++;

                BUYER_ITEM_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ITEM_NO),row); //BUYER_ITEM_NO
                DESCRIPTION_LOC     = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_DESCRIPTION_LOC),row); //DESCRIPTION_LOC
                SPECIFICATION       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_SPECIFICATION),row); //SPECIFICATION
                BASIC_UNIT          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BASIC_UNIT),row); //BASIC_UNIT
                UNIT_PRICE          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_UNIT_PRICE),row); //UNIT_PRICE

                VENDER_CODE         = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDER_CODE),row); //VENDER_CODE
                VENDER_NAME         = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDER_NAME),row); //VENDER_NAME
                VENDER_COUNT        = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_VENDER_COUNT),row); //VENDER_COUNT
                CUR                 = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CUR),row); //CUR
                SG_REFITEM          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_SG_REFITEM),row); //DRAWING_NO

                parent.opener.lineInsert(BUYER_ITEM_NO, DESCRIPTION_LOC,SPECIFICATION, BASIC_UNIT, CUR,UNIT_PRICE,VENDER_NAME,VENDER_CODE,SG_REFITEM);
            }
        }
    }


    if(checked_count == 0)  {
        alert("하나 선택하셔야죠!");
        return;
    }
}

function doDelete(){
    row = GridObj.GetRowCount();
    
    var sendRow="";
    var sendcnt = 0;

    for(var i = 0;i < row;i++){
    	var check = GD_GetCellValueIndex(GridObj,i,INDEX_SEL);
    	    	
        //if(check == "true"){ // boolena 비교로 변경
        if(check == true){
            sendcnt++;
            sendRow += (i+"&");
        }
    }

    if(sendcnt == 0) {
        alert(G_MSS1_SELECT);
        
        return;
    }
    
    var grid_array = getGridChangedRows(GridObj, "SEL");
    var cols_ids = "<%=grid_col_id%>";
    var params = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.mycat_pp_lis?mode=deletemyCatalog";
    params = params + "&cols_ids=" + cols_ids;
    params = params + dataOutput();
    
    myDataProcessor = new dataProcessor(params);
    
    sendTransactionGrid(GridObj, myDataProcessor, "SEL", grid_array);
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    if(msg1 == "doQuery") {
        if(mode == "getCatalog") {
            TOTAL_CUR = "";
            TMP_CUR = "";
            /* GetStatus 메소드에서 Uncaught TypeError: undefined is not a function 발생하여 주석처리
            if("1" == GridObj.GetStatus()) {
                objSize = GridObj.GetParamCount();
                for(i=0; i<objSize; i++) {
                    TOTAL_CUR += GD_GetParam(GridObj,i) + "@" + GD_GetParam(GridObj,i) + "$";
                }
            }
            */
        }
    }
    else if(msg1 == "doData"){
        if(mode =="deletemyCatalog"){
            var onair = GD_GetParam(GridObj,1);
            if(onair == "success") doSelect();
        } else if(mode == "setAssign_group_item") { // 그룹할당 했을 때...
            alert(GD_GetParam(GridObj,0));
            var onair = GD_GetParam(GridObj,1);
            if(onair == "success") doSelect();
        }else if(mode == "getDivision"){
            var szData = GD_GetParam(GridObj,0);
            var szColumn = GD_GetParam(GridObj,1);

            var szRowData = szData.split("???");
            var addColumn = szColumn.split("&");

            var k=0;

            for(var i=0; i<szRowData.length-1; i++) {
                var szColData = szRowData[i].split("@");

                if("null" == szColData[0]) szColData[0] = "";
                if("null" == szColData[1]) szColData[1] = "";
                if("null" == szColData[2]) szColData[2] = "";
                if("null" == szColData[3]) szColData[3] = "";
                if("null" == szColData[4]) szColData[4] = "";

                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_UNIT_PRICE, szColData[0]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_CODE, szColData[1]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_COUNT, szColData[2]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_VENDER_NAME, szColData[3]);
                GD_SetCellValueIndex(GridObj,addColumn[k], INDEX_CUR, szColData[4]);

                k++;
            }

            doInsertM();
        }

    } // doData

    else if(msg1 == "t_imagetext") {
        if(msg3 == INDEX_ITEM_NO)
        { //품번
            var BUYER_ITEM_NO = GD_GetCellValueIndex(GridObj,msg2, INDEX_ITEM_NO);
            POPUP_Open('/kr/master/material/mat_pp_ger1.jsp?type=S&flag=T&item_no='+BUYER_ITEM_NO, "품목_일반정보", '0', '0', '800', '550');
        }
    }
}

function POPUP_Open(url, title, left, top, width, height) {
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
    var code_search = window.open(url, title, 'left='+left+', top='+top+',width='+width+',height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
    code_search.focus();
}


function open_assign_group() {// 그룹할당을 위해서 팝업이 뜨게끔한다.
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

    var assign_vigr_no = "";
    var temp_vigr_no   = "";
    for(var row=0; row<GridObj.GetRowCount(); row++)
    {
        if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL))
        {
            assign_vigr_no = GD_GetCellValueIndex(GridObj,row, INDEX_MENU_FIELD_CODE);
            if(temp_vigr_no == "") temp_vigr_no = assign_vigr_no;
            if(temp_vigr_no != assign_vigr_no) {
                alert("서로다른 그룹을 한꺼번에 할당할 수 없습니다."); return;
            }
        }
    }

    var url = "../assign/assign_group_frame.jsp";
    var width = 450;
    var height = 300;
    var left = 200;
    var top = 100;

    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
    var assign = window.open( url, 'assign_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', location=no, menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function assign_group(MENU_FIELD_CODE, update) {

    for(var row=0; row<GridObj.GetRowCount(); row++) {
        if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SEL)) {
            if(MENU_FIELD_CODE == GD_GetCellValueIndex(GridObj,row, INDEX_MENU_FIELD_CODE)) {
                alert("같은 그룹에 할당할 수 없습니다.");
                return;
            }
        }
    }

    mode = "setAssign_group_item";
    var servletUrl = "<%//=getWiseServletPath("catalog.mycat_pp_lis")%>";
    var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.mycat_pp_lis";
    GridObj.SetParam("mode", mode);

    GridObj.SetParam("MENU_FIELD_CODE", MENU_FIELD_CODE);
    GridObj.SetParam("update", update);

    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    GridObj.strHDClickAction="sortmulti";

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
	if(cellInd == GridObj.getColIndexById("BUYER_ITEM_NO")) {
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		var itemNo     = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
		
		var url        = "/kr/master/new_material/real_pp_lis1.jsp?ITEM_NO=" + itemNo + "&BUY=";
		var PoDisWin   = window.open(url, 'agentCodeWin', 'left=0, top=0, width=750, height=550, toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes');
		
		PoDisWin.focus();
	}
	
	if(cellInd == GridObj.getColIndexById("IMAGE_FILE")) {
		
		var selectedId = GridObj.getSelectedId();
		var rowIndex   = GridObj.getRowIndex(selectedId);
		
		var item_no         = GD_GetCellValueIndex(GridObj, rowIndex, INDEX_ITEM_NO);
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
<body onload="javascript:setGridDraw();setHeader();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<%
	String this_window_popup_flag = JSPUtil.nullChk(JSPUtil.CheckInjection(request.getParameter("popup_flag")));

	if(this_window_popup_flag.trim().length() <= 0){
		this_window_popup_flag = "false";
	}
%>
<s:header popup="true">
	<table width="99%" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td class='title_page' height="20" align="left" valign="bottom">
				<span class='location_end'>나의카탈로그 검색</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	
	<form name="form1" >
		<input type="hidden" name="field_code" id="field_code" value="">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목명</td>
										<td width="35%" class="data_td">
											<input type="hidden" name="DESCRIPTION" id="DESCRIPTION" value="LOC" >
											<input type="text" name="DESCRIPTION_TEXT" id="DESCRIPTION_TEXT" style="width:95%" >
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;품목코드</td>
										<td width="35%" class="data_td">
											<input type="text" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO" style="width:95%;ime-mode:inactive" maxlength=18>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="1" bgcolor="#dedede"></td>
									</tr>
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사</td>
										<td class="data_td" colspan="3">
											<input type="text" name="MAKER_NAME" id="MAKER_NAME" style="width:98%" >
										</td>
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
									btn("javascript:doDelete()", "삭 제");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:doInsert()", "선 택");
								</script>
							</TD>
							<TD>
								<script language="javascript">
									btn("javascript:top.window.close()", "닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>
	</form>
</s:header>
<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="PR_T03" grid_obj="GridObj" grid_box="gridbox"/> --%>
<s:footer/>
</body>
</html>