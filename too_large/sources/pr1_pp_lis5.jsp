<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("PR_002");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "PR_002";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String WISEHUB_PROCESS_ID="PR_002";
	
	//## 2003.04.09.(신병곤) 나의 카타로그 조회시 경우에 따라 icommtsl.str_bin 조회 추가를 위하여 str_bin_flag, company_code 추가 (icoyprdt.dely_to_location2 = icommtsl.str_bin)
	String INDEX    = JSPUtil.nullToEmpty(request.getParameter("INDEX"));
	String manual   = JSPUtil.nullToEmpty(request.getParameter("manual"));
	String pjt_code	= JSPUtil.nullToEmpty(request.getParameter("pjt_code")); 
	String prePjtCode	= JSPUtil.nullToEmpty(request.getParameter("pre_pjt_code")); 
	String gubun	= JSPUtil.nullToEmpty(request.getParameter("gubun"));
	
	Object[] args     = new Object[1];
	args[0] = pjt_code;
	
	SepoaOut value = ServiceConnector.doService(info, "t0002", "CONNECTION","getPjtCodeList", args);
	SepoaFormater wf = new SepoaFormater(value.result[0]);
	String PRE_PJT_CODE ="";
	
	for ( int i = 0; i<wf.getRowCount(); i++) {
		PRE_PJT_CODE    = wf.getValue("PRE_PJT_CODE"     		,   i);
	}       
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<jsp:include page="/include/sepoa_multi_grid_common.jsp" >
  			<jsp:param name="screen_id" value="PR_002_1"/>  
 			<jsp:param name="grid_obj" value="GridObj_1"/>
 			<jsp:param name="grid_box" value="gridbox_1"/>
 			<jsp:param name="grid_cnt" value="2"/>
</jsp:include>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
var mode;
var G_INDEXES    = "<%=INDEX%>".split(":");
var TOTAL_CUR;
var G_COMPANY_CODE = "<%=info.getSession("COMPANY_CODE")%>";
var INDEX_SEL                   ;
var INDEX_PR_NO                 ;
var INDEX_SUBJECT               ;
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
var INDEX_PR_QTY;  	 		 	 
var INDEX_EXCHANGE_RATE;  	 	 
var INDEX_PR_AMT;  	 	
var INDEX_REC_VENDOR_NAME;  	 
var INDEX_CONTRACT_DIV;  	 	
var INDEX_RD_DATE;  	 	
var INDEX_WARRANTY;
var INDEX_KTGRM;
var INDEX_PR_NO_HEADER                 ;
var INDEX_SUBJECT_HEADER               ;
var INDEX_SEL_HEADER;
var INDEX_HEADERS = new Array(
		"SEL"      				 , "MATERIAL_TYPE"    		, "MATERIAL_CTRL_TYPE"  , "MATERIAL_CLASS1"	  	, "ITEM_NO"
	  , "DESCRIPTION_LOC"        , "DESCRIPTION_ENG"  		, "SPECIFICATION"  	  	, "PURCHASE_DEPT_NAME"  , "PURCHASER_NAME"
	  , "CTRL_PERSON_ID"		 , "PURCHASE_DEPT" 	  		, "ITEM_BLOCK_FLAG"     , "BASIC_UNIT"          , "CTRL_CODE"
	  , "PURCHASE_LOCATION"      , "PURCHASE_LOCATION_NAME" , "PREV_UNIT_PRICE"     , "SG_REFITEM"
	  , "MAKER_NAME"			 , "MAKER_CODE"  			, "ITEM_GROUP"			, "ITEMFLAG"			, "DELY_TO_ADDRESS"
	  , "PR_QTY"			     , "CUR"  			        , "UNIT_PRICE"			, "EXCHANGE_RATE"		, "PR_AMT"
	  , "REC_VENDOR_NAME"	     , "CONTRACT_DIV"  			, "RD_DATE"			    , "WARRANTY"			, "KTGRM"
	);

function setHeader(){
	INDEX_SEL_HEADER     = GridObj.GetColHDIndex("SEL") ;
	INDEX_PR_NO_HEADER   = GridObj.GetColHDIndex("PR_NO_HEADER") ;
	INDEX_SUBJECT_HEADER = GridObj.GetColHDIndex("SUBJECT_HEADER") ;
	
	doSelect();
}

function setHeader2(){
	INDEX_SEL                    = GridObj_1.GetColHDIndex("SEL") ;
	INDEX_PR_NO                  = GridObj_1.GetColHDIndex("PR_NO") ;
	INDEX_SUBJECT                = GridObj_1.GetColHDIndex("SUBJECT") ;	
	INDEX_MATERIAL_TYPE          = GridObj_1.GetColHDIndex("MATERIAL_TYPE") ;
	INDEX_MATERIAL_CTRL_TYPE     = GridObj_1.GetColHDIndex("MATERIAL_CTRL_TYPE") ;
	INDEX_MATERIAL_CLASS1        = GridObj_1.GetColHDIndex("MATERIAL_CLASS1") ;
	INDEX_ITEM_NO                = GridObj_1.GetColHDIndex("BUYER_ITEM_NO") ;
	INDEX_DESCRIPTION_LOC        = GridObj_1.GetColHDIndex("DESCRIPTION_LOC") ;
	INDEX_DESCRIPTION_ENG        = GridObj_1.GetColHDIndex("DESCRIPTION_ENG") ;
	INDEX_SPECIFICATION          = GridObj_1.GetColHDIndex("SPECIFICATION") ;
	INDEX_PURCHASE_DEPT_NAME     = GridObj_1.GetColHDIndex("PURCHASE_DEPT_NAME") ;
	INDEX_PURCHASER_NAME         = GridObj_1.GetColHDIndex("PURCHASER_NAME") ;
	INDEX_CTRL_PERSON_ID         = GridObj_1.GetColHDIndex("CTRL_PERSON_ID") ;
	INDEX_PURCHASE_DEPT          = GridObj_1.GetColHDIndex("PURCHASE_DEPT") ;
	INDEX_ITEM_BLOCK_FLAG        = GridObj_1.GetColHDIndex("ITEM_BLOCK_FLAG") ;
	INDEX_BASIC_UNIT             = GridObj_1.GetColHDIndex("BASIC_UNIT") ;
	INDEX_CTRL_CODE              = GridObj_1.GetColHDIndex("CTRL_CODE") ;
	INDEX_PURCHASE_LOCATION      = GridObj_1.GetColHDIndex("PURCHASE_LOCATION") ;
	INDEX_PURCHASE_LOCATION_NAME = GridObj_1.GetColHDIndex("PURCHASE_LOCATION_NAME") ;
	INDEX_PREV_UNIT_PRICE        = GridObj_1.GetColHDIndex("PREV_UNIT_PRICE") ;
	INDEX_MENU_FIELD_CODE        = GridObj_1.GetColHDIndex("MENU_FIELD_CODE") ;
	INDEX_SG_REFITEM             = GridObj_1.GetColHDIndex("SG_REFITEM") ;
	INDEX_UNIT_PRICE             = GridObj_1.GetColHDIndex("UNIT_PRICE");
  	INDEX_VENDER_CODE            = GridObj_1.GetColHDIndex("VENDER_CODE");
  	INDEX_VENDER_NAME            = GridObj_1.GetColHDIndex("VENDER_NAME");
  	INDEX_VENDER_COUNT           = GridObj_1.GetColHDIndex("VENDER_COUNT");
  	INDEX_CUR                    = GridObj_1.GetColHDIndex("CUR");
  	INDEX_MAKER_CODE             = GridObj_1.GetColHDIndex("MAKER_CODE");
  	INDEX_MAKER_NAME             = GridObj_1.GetColHDIndex("MAKER_NAME");
  	INDEX_ITEM_GROUP             = GridObj_1.GetColHDIndex("ITEM_GROUP");
  	INDEX_ITEMFLAG               = GridObj_1.GetColHDIndex("ITEMFLAG");
	INDEX_DELY_TO_ADDRESS        = GridObj_1.GetColHDIndex("DELY_TO_ADDRESS") ;
	INDEX_PR_QTY                 = GridObj_1.GetColHDIndex("PR_QTY") ;
	INDEX_EXCHANGE_RATE          = GridObj_1.GetColHDIndex("EXCHANGE_RATE") ;
	INDEX_PR_AMT                 = GridObj_1.GetColHDIndex("PR_AMT") ;
	INDEX_REC_VENDOR_NAME        = GridObj_1.GetColHDIndex("REC_VENDOR_NAME") ;
	INDEX_CONTRACT_DIV           = GridObj_1.GetColHDIndex("CONTRACT_DIV") ;
	INDEX_RD_DATE                = GridObj_1.GetColHDIndex("RD_DATE") ;
	INDEX_WARRANTY               = GridObj_1.GetColHDIndex("WARRANTY") ;
	INDEX_KTGRM                  = GridObj_1.GetColHDIndex("KTGRM") ;
}

function doSelect2(){
	mode ='select2';
	
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.register.vendor_reg_lis_prepjtcd";
	var params     = "mode=select1";
	
	params += "&cols_ids=" + GridObj_1_getColIds();
	params += dataOutput();
	
	GridObj_1.post(servletUrl, params );
	GridObj_1.clearAll(false);
	
	
}

function doSelect(){
	mode ='select1';
	
	var servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/master.register.vendor_reg_lis_header";
	var params     = "mode=select2";
	
	params += "&cols_ids=<%=grid_col_id%>";
	params += dataOutput();
	
	GridObj.post( servletUrl, params );
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
    }
    else { // RFQ에서는 종가가 필요없으므로, 그냥 값을 조회된것들에서만 가져온다.
        doInsert();
    }

}

function doInsert(){
	opener.PrdeleteWiseTable();
	
	var iRowCount2   = GridObj.GetRowCount();
	var iRowCount1   = GridObj_1.GetRowCount();
	var gIndexLength = G_INDEXES.length;
  	var arr          = new Array(G_INDEXES.length);
    var arr_cnt      = 0;
    var prno_cnt     = 0;
    var sPrNo        = "";
    var addPrNo      = "";
    var addPrNm      = "";
    var gubun        = '<%=gubun%>';
    var i            = 0;
    var v            = 0;
    var prNoHeader   = null;
    var prNo         = null;
    var dup_flag     = false;
    var mat          = null;
    var j            = 0;
    var k            = 0;
    
    for(i = 0; i < iRowCount2; i++){
    	if(GD_GetCellValueIndex(GridObj, i, INDEX_SEL_HEADER) == true){
			var sPrNo = GD_GetCellValueIndex(GridObj, i, INDEX_PR_NO_HEADER) + ':';
			var sPrNm = GD_GetCellValueIndex(GridObj, i, INDEX_SUBJECT_HEADER) + ':';
			
	        addPrNo += sPrNo;
	        addPrNm += sPrNm;
	        
	        prno_cnt++;
	        
        	for(v = 0; v < iRowCount1; v++){
        		prNoHeader = GD_GetCellValueIndex(GridObj,   i, INDEX_PR_NO_HEADER);
				prNo       = GD_GetCellValueIndex(GridObj_1, v, INDEX_PR_NO);
				
        		if(prNoHeader == prNo){
        			for(j = 0; j < gIndexLength; j++){
                		for(k = 0; k < INDEX_HEADERS.length; k++){
        	        		if(G_INDEXES[j] == INDEX_HEADERS[k]){
        	        			var VAR_INDEX = eval("INDEX_"+G_INDEXES[j]);
        	        			
        	        			arr[arr_cnt++] = GD_GetCellValueIndex(GridObj_1, v, VAR_INDEX);
        	        		}
                		}
                	}

                	arr_cnt  = 0;
                    dup_flag = false;
                    mat      = arr[opener.getCatalogIndex("MATERIAL_TYPE")];
                    
                    for(j = 0;j<opener.GridObj.GetRowCount();j++) {
                        if(mat == "SI" ) {
                        	if(opener.GridObj.GetCellValue("MATERIAL_TYPE", j) != "SI" ) {
                        		dup_flag = true;
                        		
                                break;
                        	}
                        }
                        else{
                        	if(opener.GridObj.GetCellValue("MATERIAL_TYPE", j) == "SI" ) {
                        		dup_flag = true;
                        		
                                break;
                        	}
                        }
                    }     
                    
                    if(dup_flag == false){
                        opener.setCatalogPrBr(arr);                 
                    }
                    else{
           	        	alert("용역과 IT품목은 동시 구매요청 할 수 없습니다");
           	        	opener.GridObj.height = 250;
           	        	
           	        	return;
                    }
                    
        		}
        	}
        	
        	if(gubun == '1'){
        		opener.setPrNo(addPrNo,addPrNm,prno_cnt);
        	}else{
        		opener.setPrNo(addPrNo,prno_cnt);	
        	}
        }
    }
    
	if(confirm ("선택되었습니다.\n\사전지원 검색창을 닫으시겠습니까?")){
		window.close();
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

                opener.lineInsert(BUYER_ITEM_NO, DESCRIPTION_LOC,SPECIFICATION, BASIC_UNIT, CUR,UNIT_PRICE,VENDER_NAME,VENDER_CODE,SG_REFITEM);
            }
        }
    }


    if(checked_count == 0)  {
        alert("하나 선택하셔야죠!");
        return;
    }
}
function doDelete()
{
    row = GridObj.GetRowCount();
    var sendRow="";
    var sendcnt = 0;

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

    servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.mycat_pp_lis";
    mode = "deletemyCatalog";
    GridObj.SetParam("mode", mode);
    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, sendRow, "ALL");
    GridObj.strHDClickAction="sortmulti";
}

function JavaCall(msg1, msg2, msg3, msg4, msg5) {
    if(msg1 == "doQuery") {
        if(mode == "getCatalog") {
            TOTAL_CUR = "";
            TMP_CUR = "";
            if("1" == GridObj.GetStatus()) {
                objSize = GridObj.GetParamCount();
                for(i=0; i<objSize; i++) {
                    TOTAL_CUR += GD_GetParam(GridObj,i) + "@" + GD_GetParam(GridObj,i) + "$";
                }
            }
        }
        //select() 조회된 후 조회 처리.
        if(mode == 'select1'){
        	doSelect2();
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
    var servletUrl = "<%//=getWiseServletPath("catalog.mycat_pp_lis")%>";<%-- 변환 작업 중 에러가 발생하여 주석처리 --%>
    servletUrl = "<%=POASRM_CONTEXT_NAME%>/servlets/catalog.mycat_pp_lis";
    GridObj.SetParam("mode", mode);

    GridObj.SetParam("MENU_FIELD_CODE", MENU_FIELD_CODE);
    GridObj.SetParam("update", update);

    GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
		GridObj.SendData(servletUrl, "ALL", "ALL");
    GridObj.strHDClickAction="sortmulti";

}

var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
    	GridObj_1_setGridDraw();
    	GridObj_1.setSizes();
    }
// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid2,strColumnKey, nRow);

    
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

//그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
//이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function GridObj_1_doOnRowSelected(rowId,cellInd){}

//그리드 셀 ChangeEvent 시점에 호출 됩니다.
//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function GridObj_1_doOnCellChange(stage,rowId,cellInd){
	var max_value = GridObj.cells(rowId, cellInd).getValue();
	
	//stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
	if(stage==0) {
		return true;
	}
	else if(stage==1) {
		return false;
	}
	else if(stage==2) {
		return true;
	}
}

//서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
//서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function GridObj_1_doSaveEnd(obj){
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
	}
	else {
		alert(messsage);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doData");
	} 

	return false;
}

//엑셀 업로드 샘플 소스 입니다. 엑셀에서 복사후에 버튼이벤트를 doExcelUpload 호출할 시점에
//복사한 데이터가 그리드에 Load 됩니다.
//!!!! 크롬,파이어폭스,사파리,오페라 브라우저에서는 클립보드에 대한 접근 권한이 막혀있어서 doExcelUpload 실행시 에러 발생 
function GridObj_1_doExcelUpload() {
	var bufferData = window.clipboardData.getData("Text");
	
	if(bufferData.length > 0) {
		GridObj.clearAll();
		GridObj.setCSVDelimiter("\t");
		GridObj.loadCSVString(bufferData);
	}
	
	return;
}

function GridObj_1_doQueryEnd() {
	var msg        = GridObj.getUserData("", "message");
	var status     = GridObj.getUserData("", "status");

	// Wise그리드에서는 오류발생시 status에 0을 세팅한다.
	if(status == "0"){
		alert(msg);
	}
	
	if("undefined" != typeof JavaCall) {
		JavaCall("doQuery");
	}
	
	return true;
}

function bodyOnLoad(){
	setGridDraw();
	setHeader();
	setHeader2();
}
</script>
</head>
<body onload="javascript:bodyOnLoad();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
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
				<span class='location_end'>사전지원 검색</span>
			</td>
		</tr>
	</table>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" >
		<input type="hidden" name="field_code" id="field_code"     value="">
		<input type="hidden" name="pjt_code"   id="pjt_code"       value="<%=pjt_code%>">
		<input type="hidden" name="PRE_PJT_CODE" id="PRE_PJT_CODE" value="<%=PRE_PJT_CODE%>">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
						<tr>
							<td width="100%">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사전지원요청번호</td>
										<td width="35%" class="data_td">
											<input type="text" name="PR_NO" id="PR_NO" style="width:40%" class="inputsubmit" maxlength=18>
										</td>
										<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;요청명</td>
										<td width="35%" class="data_td">
											<input type="text" name="SUBJECT" id="SUBJECT" style="width:40%" class="inputsubmit" maxlength=18>
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
<s:grid screen_id="PR_002_2" grid_obj="GridObj" grid_box="gridbox"/>
<div id="gridbox_1" name="gridbox_1" width="100%" style="background-color:white; display: none;"></div>
<s:footer/>
</body>
</html>