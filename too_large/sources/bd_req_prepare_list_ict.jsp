<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_010");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_010";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);

    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 	= info.getSession("NAME_LOC");
%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->
 
<script language="javascript">
<!--
    var mode;
   
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

	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공문번호 click

            BID_NO          = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT       = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            VOTE_COUNT      = GD_GetCellValueIndex(GridObj,msg2, INDEX_VOTE_COUNT);
            ANN_NO          = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_NO),msg2);
            ANN_ITEM        = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_ANN_ITEM),msg2);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공문, 정정공문
                	if(GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_TYPE) == "C"){
	                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                    }else if(GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_TYPE) == "S"){
	                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                    }else if(GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_TYPE) == "DP"){
	                    window.open('/ebid_doc/suinchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                    }else if(GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_TYPE) == "M"){
	                    window.open('/s_kr/bidding/bidm/ebd_bd_dis2.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                    }else{
    	                window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                    }
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_ANN_ITEM) {
//                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+PR_NO,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
// 입찰화면....
            } else if(msg3 == INDEX_VENDOR_NAME) {
                window.open('ebd_bd_dis5.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT+'&VOTE_COUNT='+VOTE_COUNT,"ebd_bd_dis5","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
            }
        }
    }

    function start_change_date(year,month,day,week) {
        document.forms[0].start_change_date.value=year+month+day;
    }

    function end_change_date(year,month,day,week) {
        document.forms[0].end_change_date.value=year+month+day;
    }

	function chk_Ctrl_Code(ctrl_d, ctrl_o) { // function의 실행 권한 check (내/외자 담당자만 가능함.)

		var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
		var flag = false;

		for( i=0; i<ctrl_code.length; i++ )
		{
			if ((ctrl_code[i] == ctrl_d) || (ctrl_code[i] == ctrl_o)){
				flag = true;
				break;
			}
		}

		return flag;
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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_req_prepare_list_ict";


function init() {
	setGridDraw();
	printDate();
    doQuery();
}

	function setGridDraw()
    {
    	GridObj_setGridDraw();
    	GridObj.setSizes();
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
<%--         var url =  "<%=POASRM_CONTEXT_NAME%>/sourcing/bd_ann_detail.jsp";	 --%>
		var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
		var bid_type = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_TYPE")).getValue());

		var url = "/ict/sourcing/bd_ann_d_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;

		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'1100','700');
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
    var params = "mode=getBdReqPrepareList";
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
    document.forms[0].end_change_date.value   = add_Slash( document.forms[0].end_change_date.value   );
    
    return true;
}
// 콤보가져오기 위한 시작
function initAjax() {
	
    doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M975' ,'BID_FLAG', '' ); // 진행상태
<%--     doRequestUsingPOST( 'SL0018', '<%=house_code%>'+'#M968' ,'BID_TYPE', '' );   --%>
}

//★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	
	if( grid_array.length > 0 ) {
	   return true;
	}
	
	alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
	return false;

}

<%--내정가격 등록요청--%>
function doForecasting()
{
    var url;
    var checked_count = 0; 
    var index_flag = 0;
 
    if(!checkRows()) return;
  
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	
	for(var i = 0; i < grid_array.length; i++)
	{ 
        checked_count++;
		var BID_NO      	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue());
		var BID_COUNT   	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		var BID_STATUS      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue());
	    var COST_STATUS	 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue());
	    var ESTM_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ESTM_USER_ID")).getValue());
	    var BID_TYPE 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());
	    var CHANGE_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
	    var STATUS 			= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue());
	    var CHK_DATE 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHK_DATE")).getValue());
 
        if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
            alert("담당자만 요청할 권한이 있습니다.");
            return;
        }
        
        if(Number(CHK_DATE) < Number($("#h_server_date").val())){
        	<%--ICT는 입찰마감시간까지 내정가격 등록 가능--%>
        	alert("입찰이 마감되어 내정가격을 등록하실 수 없습니다.");
        	return;
        }

        if (STATUS == "R") {
        	<%--예정가격 상태  N:신규/저장, R:요청, C:확정--%>
            alert("내정가격 요청중인 건입니다.");
            return;
        } else if (STATUS == "C") {
            alert("확정건은 등록요청을 할 수 없습니다.");
            return;
        }

        if(COST_STATUS == "EC") { // 예정가격 '확정'인 경우.... (COST_STATUS == 'ET' ('저장'), COST_STATUS == '' ('신규'))
            alert("확정건은 등록요청을 할 수 없습니다.");
            return;
        }

        url = "bd_req_prepare_insert_ict.jsp";

       	document.form1.BID_NO.value = BID_NO;
       	document.form1.BID_COUNT.value = BID_COUNT;
       	document.form1.COST_STATUS.value = COST_STATUS;
       	document.form1.BID_TYPE.value = BID_TYPE;
       	document.form1.BID_STATUS.value = BID_STATUS;
    }
 
    if(checked_count > 1) {
        alert("한 건만 선택하실 수 있습니다.");
        return;
    }

   // location.href = url;
    document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "_self"; 
	document.form1.submit(); 
}
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doQuery();
    }
}
function Cancel()
{
    var url;
    var checked_count = 0; 
    var index_flag = 0;
 
    if(!checkRows()) return;
  
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	
	for(var i = 0; i < grid_array.length; i++)
	{ 
        checked_count++;
		var BID_NO      	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue());
		var BID_COUNT   	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		var BID_STATUS      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue());
	    var COST_STATUS	 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue());
	    var ESTM_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ESTM_USER_ID")).getValue());
	    var BID_TYPE 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());
	    var CHANGE_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
	    var STATUS 			= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("STATUS")).getValue());
	    var CHK_DATE 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHK_DATE")).getValue());
	    
	    if("<%=info.getSession("ID")%>" != CHANGE_USER_ID) {
            alert("처리할 권한이 없습니다.");
            return;
        }
        
        if(Number(CHK_DATE) < Number($("#h_server_date").val())){
        	alert("입찰이 진행되어 내정가격을 등록하실 수 없습니다.");
        	return;
        }
       
        if (STATUS == "N") { // 예정가격 상태  N:신규/저장, R:요청, C:확정
            alert("미요청은 회수 불가합니다.1");
            return;
        }
        
        /*
        if (STATUS == "R") { // 예정가격 상태  N:신규/저장, R:요청, C:확정
            alert("내정가격 요청중인 건입니다.");
            return;
        } else if (STATUS == "C") {
            alert("확정건은 등록요청을 할 수 없습니다.");
            return;
        }
        */
        
        if(STATUS == "N" && COST_STATUS == "") { // 예정가격 '확정'인 경우.... (COST_STATUS == 'ET' ('저장'), COST_STATUS == '' ('신규'))
            alert("미요청은 회수 불가합니다.2");
            return;
        }

        /*
        if(COST_STATUS == "EC") { // 예정가격 '확정'인 경우.... (COST_STATUS == 'ET' ('저장'), COST_STATUS == '' ('신규'))
            alert("확정건은 등록요청을 할 수 없습니다.");
            return;
        }
		*/		
		
        //url = "bd_req_prepare_update.jsp";

       	document.form1.BID_NO.value = BID_NO;
       	document.form1.BID_COUNT.value = BID_COUNT;
       	document.form1.COST_STATUS.value = COST_STATUS;
       	document.form1.BID_TYPE.value = BID_TYPE;
       	document.form1.BID_STATUS.value = BID_STATUS;
    }
 
    if(checked_count > 1) {
        alert("한 건만 선택하실 수 있습니다.");
        return;
    }

    if(!confirm("내정가 회수처리를 하시겠습니까?")) return;
    
    var params ="mode=setBdEsCancel&cols_ids="+grid_col_id;
	params+=dataOutput();	
	myDataProcessor = new dataProcessor( "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_req_prepare_list_ict",params);
	sendTransactionGridPost(GridObj, myDataProcessor, "SELECTED", grid_array);
	
	 
	
}
</script>
</head>
<body onload="init();initAjax();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form1" >
	<input type="hidden" name="ctrl_code"					value="">
	<input type="hidden" name="BID_TYPE"	id="BID_TYPE"	value="D">
	<input type="hidden" name="BID_NO"		id="BID_NO">
	<input type="hidden" name="BID_COUNT"	id="BID_COUNT">
	<input type="hidden" name="COST_STATUS"	id="COST_STATUS"> 
	<input type="hidden" name="BID_STATUS"	id="BID_STATUS">
	
	<input type="hidden" name="SCR_FLAG" >

	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	
	
	

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
        		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰일자
      		</td>
      		<td width="35%" class="data_td">
      			<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        		 			id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/> 
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;진행상황</td>
      		<td width="35%" class="data_td">
        		<select name="BID_FLAG" id="BID_FLAG">
          			<option value="">전체</option> 
        		</select>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>      	
    	<tr>
      		<td width="15%" class="title_td">
        		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;공문번호
      		</td>
      		<td class="data_td">
        		<input type="text" name="ANN_NO" id="ANN_NO" size="20" maxlength="20" style="ime-mode:inactive" onkeydown='entKeyDown()' >
      		</td>
     		<td width="15%" class="title_td">
        		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰건명
      		</td>
      		<td class="data_td">
        		<input type="text" name="ANN_ITEM" id="ANN_ITEM" size="20" onkeydown='entKeyDown()'  >
      		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>  		
		<tr>
			<td width="15%" class="title_td">
	        	<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;현재시간
	      	</td>
	      	<td width="35%" class="data_td">
	        	<div id="id1"></div>
				<input type="hidden" id="h_server_date" name="h_server_date" class="input_empty" size="50" readonly> 
	      	</td>		
	   		<td width="15%" class="title_td">
        		&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;입찰담당자
      		</td>
      		<td class="data_td">
        		<b><input type="text" name="CHANGE_USER_NAME"  id="CHANGE_USER_NAME" onkeydown='entKeyDown()'   value="<%=USER_NAME%>" size="20" maxlength="10" ></b>
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
				<TABLE cellpadding="0">
					<TR>
			    	  	<TD> <script language="javascript">btn("javascript:doQuery()", "조 회")</script></TD>
						<TD><script language="javascript">btn("javascript:doForecasting()","등록요청")</script></TD>
						<TD><script language="javascript">btn("javascript:Cancel()","회수")</script></TD>
			    	</TR>
				</TABLE>
			</td>
    	</tr>
	</table>
</form>
<!---- END OF USER SOURCE CODE ----> 

</s:header>
<s:grid screen_id="I_BD_010" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>
