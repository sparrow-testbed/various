<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_014");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_014";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);
    String buyer_manager_id = CommonUtil.getConfig("sepoa.buyer_manager_id");
%>

<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> 

<%
    String house_code       = info.getSession("HOUSE_CODE");
	String company_code     = info.getSession("COMPANY_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 		= info.getSession("NAME_LOC");
	

	String eval_id_prop = "";	//제안평가
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

<script language="javascript">
<!--
	var G_HOUSE_CODE   = "<%=house_code%>";
	var G_COMPANY_CODE = "<%=company_code%>";
	var mode;
	
	var server_time;
	var diff_time;
	
	var INDEX_SELECTED				;
	var INDEX_ANN_NO				;
	var INDEX_ANN_ITEM				;
	var INDEX_BID_BEGIN_DATE		;
	var INDEX_BID_END_DATE			;
	var INDEX_BID_END_DATE_VALUE	;
	var INDEX_BID_OPEN_DATE			;
	var INDEX_BID_OPEN_DATE_VALUE	;
	var INDEX_CHANGE_USER_NAME_LOC	;
	var INDEX_STATUS_TEXT			;
	var INDEX_SIGN_PERSON_ID		;
	var INDEX_SIGN_STATUS			;
	var INDEX_BID_STATUS			;
	var INDEX_BID_NO				;
	var INDEX_BID_COUNT				;
	var INDEX_VOTE_COUNT			;
	var INDEX_CHANGE_USER_ID		;
	var INDEX_STATUS				;
	var INDEX_PR_NO					;
	var INDEX_CONT_TYPE2			;
	var INDEX_TECH_DQ				;
	var INDEX_CTRL_CODE				;
	var INDEX_COST_STATUS			;
	var INDEX_EVAL_FLAG				;
	var INDEX_EVAL_REFITEM			;
	var INDEX_EVAL_CODE				;
	var INDEX_CTRL_CODE				;
    
    
  
    function checkedRow() {
	    var checked_count = 0;
	    var checked_row   = -1;
	    var rowcount = GridObj.GetRowCount();

	    for (var row = 0; row < rowcount; row++) {
	    	if(GridObj.GetCellValue("SELECTED", row) == "1"){
   			    checked_row   = row;
        		checked_count++;
        	}
	    }
        if(checked_count == 0)  {
	    	alert("선택된 로우가 없습니다.");
	    	return -1;
	    }
        if(checked_count > 1)  {
	    	alert("하나의 로우만 선택할 수 있습니다.");
	    	return -1;
	    }

        return checked_row;
  	}

	function PopupManager(part)
	{
		
		if(part == "contact_user"){
			window.open("/common/CO_008_ict.jsp?callback=getConUser", "SP9113", "toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=450,height=550,left=0,top=0");
		}
		
	}
	
	function getConUser(code, text){
		document.form1.contact_user.value = code;
		document.form1.contact_user_name.value = text;
	}	
	
	function checkUserId(row_idx) {
        var user_id        = "<%=user_id%>";
	    var change_user_id = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CHANGE_USER_ID);

        if (user_id != change_user_id) {
   	        alert("구매담당자만 작업 가능합니다.");
   	        return false;
        }
 		return true;
  	}

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    server_time = GD_GetParam(GridObj,0);
 
	    } else if(msg1 == "doData") {
	        // 평가대상 등록
			alert(GD_GetParam(GridObj,1));
			doSelect();
	    } else if(msg1 == "t_imagetext") { //공문번호 click

            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            VOTE_COUNT  = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);
            PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),msg2);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공문, 정정공문
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_PR_NO) {
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+PR_NO,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
            } else if(msg3 ==  INDEX_VOTE_VENDOR_COUNT){ // 입찰참가업체 리스트
            	
            	url = "ebd_pp_dis4.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&VOTE_COUNT="+VOTE_COUNT;
        		window.open( url , "ebd_pp_dis4","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=no,width=600,height=430,left=0,top=0");
            }
        }
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }
 
     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doQuery();
        }
    }
	
	function doEval() {
		for(var i=0; i<GridObj.GetRowCount(); i++){
			if(GridObj.GetCellValue("SELECTED", i) == "1"){
				if(GridObj.GetCellValue("REQ_TYPE", i) == "B" && document.form1.template_type.value != "0"){
					alert("사전지원요청건은 평가등록을 하실 수 없습니다.");
					return;
				}		
			}
		}
		var eval_id = form1.template_type.value;
		
       	if(checkEval()){
			Message = "평가대상을 ["+document.form1.template_type.options[document.form1.template_type.options.selectedIndex].text+"] 으로 지정 하시겠습니까?";
			if(confirm(Message) == 1) {
				servletUrl = "/servlets/dt.bidd.ebd_bd_lis13";
				GridObj.SetParam("mode", "charge_eval");
				GridObj.SetParam("eval_id", eval_id);
				GridObj.SetParam("WISETABLE_DOQUERY_DODATA","1");
				GridObj.SendData(servletUrl, "ALL", "ALL");
            }
		}
	}//doEval End

	//제안평가[7]
	function doEvalProp(){
		var eval_id = "<%=eval_id_prop%>";
		
		if(checkEval()){
			Message = "제안평가를 수행 하시겠습니까?";
			if(confirm(Message) == 1) {
				var row_idx = checkedRow();

        		if (row_idx == -1) return;
        		
				tech_dq 	= parseFloat(GD_GetCellValueIndex(GridObj,row_idx, INDEX_TECH_DQ) == "" ? "0" : GD_GetCellValueIndex(GridObj,row_idx, INDEX_TECH_DQ));
			 	cont_type2  = GD_GetCellValueIndex(GridObj,row_idx, INDEX_CONT_TYPE2);
			 	if(tech_dq == 0){	// 입찰공문시 협상에 의한 입찰이면서 기술제안서 점수비율
					alert("입찰공문시 기술제안서 점수비율이 없습니다.");
					return;
				}			 	

       			var SUBJECT      = GD_GetCellValueIndex(GridObj,row_idx, INDEX_ANN_ITEM);
       			var BID_NO       = GD_GetCellValueIndex(GridObj,row_idx, INDEX_BID_NO);
           		var BID_COUNT    = GD_GetCellValueIndex(GridObj,row_idx, INDEX_BID_COUNT);
           		var EVAL_REFITEM = GD_GetCellValueIndex(GridObj,row_idx, INDEX_EVAL_REFITEM);
           		
				if(EVAL_REFITEM == '') EVAL_REFITEM = 0;
				window.open('/kr/master/evaluation/eval_bd_ins3.jsp?eval_refitem='+EVAL_REFITEM+'&EVAL_ID='+eval_id+'&BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT+'&evalname='+SUBJECT,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0", true);
			}
		}
	}
	
	function checkEval(){
		var checked_count = 0;
		var rowcount = GridObj.GetRowCount();
		var strStatus 	= "";
		var tech_dq		= 0; 
		var cont_type2	= "";
		
		for(row=rowcount-1; row>=0; row--) {
			
			if(GridObj.GetCellValue("SELECTED", row) == "1"){
			 	strStatus = LRTrim(GridObj.cells(GridObj.getRowId(row), GridObj.getColIndexById("STATUS")).getValue());
				checked_count++;
				
				if(GridObj.GetCellValue("VOTE_VENDOR_COUNT", row) == "0"){
					alert("입찰에 참여한 업체가 없습니다.");
					return;
				}
			}
		}
		if(checked_count == 0)  {
			alert("입찰내용을 선택하여주십시요!");
			return false;
		}		
		if(strStatus =="Y"){
			alert("개찰이 완료된 건은 평가를 생성할 수 없습니다!");
			return false;
		}
		var eval_id = form1.template_type.value;
		
		if(eval_id == "") {
			alert("평가대상을 등록하려면 평가를 선택해야  합니다.");
			return false;
		}
		return true;
	}
//-->
</script>



<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript" type="text/javascript">

var GridObj = null;
var MenuObj = null;
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_open_list_ict";

function init() {
	setGridDraw(); 
    doQuery();
    setInterval(doQuery,60000);
	printDate();	
}

function setGridDraw()
{
	GridObj_setGridDraw();
	GridObj.setSizes();
	
	INDEX_SELECTED              =    GridObj.GetColHDIndex("SELECTED");
	INDEX_ANN_NO                =    GridObj.GetColHDIndex("ANN_NO");
	INDEX_ANN_ITEM              =    GridObj.GetColHDIndex("ANN_ITEM");
	INDEX_BID_BEGIN_DATE        =    GridObj.GetColHDIndex("BID_BEGIN_DATE");
	INDEX_BID_END_DATE          =    GridObj.GetColHDIndex("BID_END_DATE");
	INDEX_BID_END_DATE_VALUE    =    GridObj.GetColHDIndex("BID_END_DATE_VALUE");
	INDEX_BID_OPEN_DATE       	=    GridObj.GetColHDIndex("BID_OPEN_DATE");
	INDEX_BID_OPEN_DATE_VALUE  	=    GridObj.GetColHDIndex("BID_OPEN_DATE_VALUE");
	INDEX_CHANGE_USER_NAME_LOC  =    GridObj.GetColHDIndex("CHANGE_USER_NAME_LOC");
	INDEX_STATUS_TEXT           =    GridObj.GetColHDIndex("STATUS_TEXT");
	INDEX_SIGN_PERSON_ID        =    GridObj.GetColHDIndex("SIGN_PERSON_ID");
	INDEX_SIGN_STATUS           =    GridObj.GetColHDIndex("SIGN_STATUS");
	INDEX_BID_STATUS            =    GridObj.GetColHDIndex("BID_STATUS");
	INDEX_BID_NO                =    GridObj.GetColHDIndex("BID_NO");
	INDEX_BID_COUNT             =    GridObj.GetColHDIndex("BID_COUNT");
	INDEX_VOTE_COUNT            =    GridObj.GetColHDIndex("VOTE_COUNT");
	INDEX_CHANGE_USER_ID        =    GridObj.GetColHDIndex("CHANGE_USER_ID");
	INDEX_STATUS                =    GridObj.GetColHDIndex("STATUS");
	INDEX_PR_NO                 =    GridObj.GetColHDIndex("PR_NO");
	INDEX_CONT_TYPE2            =    GridObj.GetColHDIndex("CONT_TYPE2");
	INDEX_TECH_DQ				=    GridObj.GetColHDIndex("TECH_DQ");
	INDEX_CTRL_CODE             =    GridObj.GetColHDIndex("CTRL_CODE");
	INDEX_COST_STATUS         	=    GridObj.GetColHDIndex("COST_STATUS");
	INDEX_EVAL_FLAG          	=    GridObj.GetColHDIndex("EVAL_FLAG");
	INDEX_EVAL_REFITEM          =    GridObj.GetColHDIndex("EVAL_REFITEM");
	INDEX_EVAL_CODE          	=    GridObj.GetColHDIndex("EVAL_CODE");
	INDEX_VOTE_VENDOR_COUNT		= 	 GridObj.GetColHDIndex("VOTE_VENDOR_COUNT");
	INDEX_REQ_TYPE				= 	 GridObj.GetColHDIndex("REQ_TYPE");

}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd)
{
    var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if( header_name == "ANN_NO")
    {
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());
        
        var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
        var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());
        
        var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;        
		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'1100','700');
    }else if( GridObj.getColIndexById("VENDOR_COUNT") == cellInd || GridObj.getColIndexById("VENDOR_COUNT2") == cellInd || GridObj.getColIndexById("VENDOR_COUNT3") == cellInd){
        var bid_no = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());   
        var bid_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());          	
        var vote_count = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());          	
        var open_date_time = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_OPEN_DATE_VALUE")).getValue());          	
        
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].VOTE_COUNT.value = vote_count; 
	
        var url = "bd_pp_dis_ict.jsp?BID_NO=" + bid_no + "&BID_COUNT=" + bid_count + "&VOTE_COUNT=" + vote_count + "&BID_OPEN_DATE_VALUE=" + open_date_time;
		doOpenPopup(url,'800','350');
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd)
{
	var header_name = GridObj.getColumnId(cellInd);
    var max_value = GridObj.cells(rowId, cellInd).getValue();
    //stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
    if(stage==0) {
        return true;
    } else if(stage==1) {
    	if( header_name == "SELECTED" ) {
    		var gg = getGridSelectedRows(GridObj, "SELECTED");
    		if(gg !=0){
    			
    			for(var j = dhtmlx_start_row_id; j < dhtmlx_end_row_id; j++)
    			{
    				//GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue("0");
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).setValue(0);
    				GridObj.cells(j+1, GridObj.getColIndexById("SELECTED")).cell.wasChanged = false;
    			}
    		}
    		
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).setValue(1);
	    	GridObj.cells( rowId, GridObj.getColIndexById("SELECTED")).cell.wasChanged = true;
	    	row_id = rowId;
	    	return true;
    	}
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

function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdOpenList";
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    GridObj.post( G_SERVLETURL, params );
    GridObj.clearAll(false);
}


function doQueryEnd() {
    var msg        = GridObj.getUserData("", "message");
    var status     = GridObj.getUserData("", "status");

    //if(status == "false") alert(msg);
    // Wise그리드에서는 오류발생시 status에 0을 세팅한다.
    if(status == "0") alert(msg);
   
    document.forms[0].start_change_date.value = add_Slash( document.forms[0].start_change_date.value );
    document.forms[0].end_change_date.value = add_Slash( document.forms[0].end_change_date.value );
    
    return true;
}

// ★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    if( grid_array.length > 0 ) {
        return true;
    }

    alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
    return false;

}
//재입찰진행
function doBidProgress() {
	
    if(!checkRows()) return;
 
    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    var status         ;
    var bid_end_date   ;
    var cont_type2     ;
    var eval_status    ;
    var h_server_date  ;
	
	
	var BID_NO       ;
	var BID_COUNT    ;
	var PR_NO        ;
	var VOTE_COUNT   ;
	var EVAL_REFITEM ;
	var EVAL_CODE  	 ;
	var COST_STATUS  ;
	var REQ_TYPE   ;
	var BID_OPEN_DATE ;
	
	var VOTE_VENDOR_COUNT ;
	var TECH_DQ;
	var BID_STATUS;
	var CHANGE_USER_ID;

    for(var i = 0; i < grid_array.length; i++)
	{
         status          = GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue();
         bid_end_date    = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_END_DATE_VALUE")).getValue();
         cont_type2      = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONT_TYPE2")).getValue();
         eval_status     = GridObj.cells(grid_array[i], GridObj.getColIndexById("EVAL_FLAG")).getValue();
         h_server_date   = document.forms[0].h_server_date.value;        
    	
    	
    	 BID_NO      = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue();
    	 BID_COUNT   = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue();
    	 PR_NO       = GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue();
    	 VOTE_COUNT  = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue();
    	 EVAL_REFITEM= GridObj.cells(grid_array[i], GridObj.getColIndexById("EVAL_REFITEM")).getValue();
    	 EVAL_CODE  	= GridObj.cells(grid_array[i], GridObj.getColIndexById("EVAL_CODE")).getValue();
    	 COST_STATUS = GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue();
    	 REQ_TYPE = GridObj.cells(grid_array[i], GridObj.getColIndexById("REQ_TYPE")).getValue();
    	 BID_OPEN_DATE = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_OPEN_DATE")).getValue() + "00";
    	
    	 VOTE_VENDOR_COUNT = GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_VENDOR_COUNT")).getValue();
    	 BID_STATUS = GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue();
    	 
    	 TECH_DQ = parseFloat(GridObj.cells(grid_array[i], GridObj.getColIndexById("TECH_DQ")).getValue()) == "" ? "0" : GridObj.cells(grid_array[i], GridObj.getColIndexById("TECH_DQ")).getValue();
    	 CHANGE_USER_ID = GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue();
	} 
    var user_id          = "<%=user_id%>";
    var buyer_manager_id = "<%=buyer_manager_id%>";
    if (user_id == CHANGE_USER_ID || user_id == buyer_manager_id) {
    }else{
        alert("담당자만 작업 가능합니다.");
        return false;
    }
    
    if("RR" != BID_STATUS){
    	alert("'재입찰대상' 건만 재입찰 하실 수 있습니다.");
    	return;
    }
    
	// 개찰 완료된 경우
	if (status == "Y"){
		alert("이미 개찰 완료되었습니다.");
		return;
	}    
 
	// 1단계 제안평가
	// 제안점수 비율이 있는경우 제안평가가 완료된 후 개찰해야 한다.
	
	if(!(eval_status == 'N')){
		if(REQ_TYPE == "P" && TECH_DQ > 0 && VOTE_VENDOR_COUNT > 0){
			if(!(eval_status == 'C' && EVAL_CODE == "<%=eval_id_prop%>")){
				alert("제안평가가 완료되지 않았습니다.\n\n제안평가 완료 후 진행하세요.");
				return;			
			}
		}
	}
	
	// 내정가격를 등록하지 않은 경우
	//if (COST_STATUS == 'N' && VOTE_VENDOR_COUNT > 0) { 
	//	alert("내정가격을 확정하지 않았습니다\n\n개찰전에 내정가격을 확정하세요.");
	//	return;
	//}
	
	if(Number(h_server_date) < Number(bid_end_date.replaceAll("/", "").replaceAll(":", "").replaceAll(" ", ""))){
		alert("개찰일시 이후에 개찰 하실 수 있습니다.");
		return;
	}
	
	// 평가는 구매요청만 해당된다. 사전지원는 제외. 
	if(REQ_TYPE == "P"){
		if(!(eval_status == "N" || eval_status == "C" || eval_status == "") ){
			alert("평가제외 또는 평가 완료된 건이 아니면 개찰 하실 수 없습니다.");
			return;
		}
	}
	 
	//if(confirm(Message) == 1){
    //    location.href = "/kr/dt/bidd/ebd_bd_dis4.jsp?BID_NO="+BID_NO+"&BID_COUNT="+BID_COUNT+"&PR_NO="+PR_NO+"&VOTE_COUNT="+VOTE_COUNT+"&EVAL_REFITEM="+EVAL_REFITEM+"&EVAL_CODE="+EVAL_CODE;
	//}

	document.form1.BID_NO.value = BID_NO;
	document.form1.BID_COUNT.value = BID_COUNT;
	document.form1.PR_NO.value = PR_NO;
	document.form1.VOTE_COUNT.value = VOTE_COUNT;
	document.form1.EVAL_REFITEM.value = EVAL_REFITEM;
	document.form1.EVAL_CODE.value = EVAL_CODE; 
	
	var Message = "재입찰 하시겠습니까?";
	if(confirm(Message) == 1){
        url =  "bd_open_compare_ict.jsp";
        document.form1.target = "_self";
        document.form1.method = "POST";
    	document.form1.action = url; 
    	document.form1.submit();  			

		
    	// 이전 한단계 거쳐서 call하는 화면 
    	//url =  "bd_open_ict.jsp";
    	//document.form1.target = "_self";
    	//document.form1.method = "POST";
		//document.form1.action = url; 
		//document.form1.submit();
	
	}





}

/**
 * 개찰 상태 검토
 */
function chkData(row_idx) {
    var status          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);
    var bid_end_date    = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_END_DATE_VALUE),row_idx);
    var bid_open_date   = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BID_OPEN_DATE_VALUE),row_idx);
    var cont_type2      = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_CONT_TYPE2),row_idx);
    var h_server_date   = document.forms[0].h_server_date.value;
    //alert("서버시간 : " + h_server_date + ", 개찰시간 : " + bid_open_date);
	
    if (bid_open_date=="") {
    	bid_open_date = bid_end_date;
    }
    if(parseFloat(h_server_date) > parseFloat(bid_open_date)) {
        //if(cont_type2 == "LP") {
		return true;
        //} else if(cont_type2 == "TE") {
           /*if(status == "SC") {
                return true;
            } else {
                alert("1단계평가를 먼저 하셔야 합니다.");
                return false;
            }*/
        //}
    } else {
        //alert("입찰서 제출이 마감된 후 개찰을 진행하실 수 있습니다.");
        alert("개찰시간 이후에 개찰을 진행하실 수 있습니다.");
        return false;
    }
    alert("개찰을 진행하실 수 없습니다.");
    return false;
}

// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var flag = true;

		for(var row=0; row<GridObj.GetRowCount(); row++) {
			if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
				for( i=0; i<ctrl_code.length; i++ )
			{
					if(ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) {
						flag = true;
						break;
					} else
						flag = false;
				}
			}
		}
	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");

		return flag;
	}

//지우기
function doRemove( type ){
	if( type == "contact_user" ) {
		document.form1.contact_user.value = "";
		document.form1.contact_user_name.value = "";
	}  
}
</script>
</head>


<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->
<form name="form1" >
	<input type="hidden" name="ctrl_code" value="">
	<input type="hidden" name="BID_NO" id="BID_NO">
	<input type="hidden" name="BID_COUNT" id=BID_COUNT>
	<input type="hidden" name="PR_NO" id="PR_NO">
	<input type="hidden" name="VOTE_COUNT" id="VOTE_COUNT">
	<input type="hidden" name="EVAL_REFITEM" id="EVAL_REFITEM">
	<input type="hidden" name="EVAL_CODE" id="EVAL_CODE">
	<input type="hidden" name="SCR_FLAG" value="">
	<input type="hidden" name="BID_TYPE_C" id="BID_TYPE_C" value="D">

	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
																				
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="100%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td>
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
								<tr>
									<td width="100%">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
											<colgroup>
												<col width="15%" />
												<col width="35%" />
												<col width="15%" />
												<col width="35%" />
											</colgroup>
											<tr>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰마감일자
												</td>
												<td width="35%" class="data_td">
													<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>"
														id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
												</td>

												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;개찰여부
												</td>
												<td width="35%" class="data_td" colspan="3">
													<select id="bid_status" name="bid_status">
														<option value="">전체</option>
														<option value="AC">입찰진행중</option>
														<option value="RR">재입찰대상</option>
													</select>
													<input type="hidden" name="BID_TYPE_C" id="BID_TYPE_C" value="D">

													<select name="bid_flag" id="bid_flag" style="display:none;">
														<option value="">전체</option>
														<option value="Y">개찰 완료</option>
														<option value="N" SELECTED>개찰 미완료</option>
													</select>
													<select name="auto_flag" id="auto_flag" style="display:none;">
														<option value="">자동/수동</option>
														<option value="Y" SELECTED>자동</option>
														<option value="N">수동</option>
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;공문번호
												</td>
												<td class="data_td">
													<input type="text" name="ANN_NO" id="ANN_NO" size="20" maxlength="20" onkeydown='entKeyDown()'>
												</td>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰건명
												</td>
												<td class="data_td">
													<input type="text" style="ime-mode:active;width:95%"  name="ANN_ITEM" id="ANN_ITEM" onkeydown='entKeyDown()'>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>
											<tr>
												<td width="15%" class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;현재시간
												</td>
												<td width="35%" class="data_td">
													<div id="id1"></div>
													<input type="hidden" name="h_server_date" size="50" readonly>
												</td>
												<td class="title_td">
													&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp;입찰담당자
												</td>
												<td class="data_td">
													<b>
													<input type="text" name="contact_user" id="contact_user" size="16" maxlength="10"  value='<%=info.getSession("ID") %>' >
													<a href="javascript:PopupManager('contact_user');">
														<img src="<%=POASRM_CONTEXT_NAME%>/images/button/query.gif" align="absmiddle" border="0" alt="">
													</a>
													<a href="javascript:doRemove('contact_user')">
														<img src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif" align="absmiddle" border="0">
													</a>
													<input type="text" name="contact_user_name" id="contact_user_name" size="25" onkeydown='entKeyDown()' readonly value='<%=info.getSession("NAME_LOC")%>'>
													</b>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
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
							<table cellpadding="0">
								<tr>
									<td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
									<td><script language="javascript">btn("javascript:doBidProgress()", "재입찰")</script></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

</form>

<!---- END OF USER SOURCE CODE ---->

</s:header>
<s:grid screen_id="I_BD_014" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/> 
</body>
</html>
 