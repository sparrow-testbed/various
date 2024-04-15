<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("BD_006");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "BD_006";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateDay( to_day, -30 );
    String  to_date     = to_day;
    
    String buyer_manager_id = CommonUtil.getConfig("sepoa.buyer_manager_id");
%>
<!--  /home/user/wisehub/wisehub_package/myserver/V1.0.0/wisedoc/kr/dt/bidd/ebd_bd_lis4.jsp -->
<!--
Title:         입찰자적격확인  <p>
 Description:  입찰자적격확인<p>
 Copyright:    Copyright (c) <p>
 Company:      ICOMPIA <p>
 @author       JUN.S.K<p>
 @version      1.0
 @Comment      현재 모듈에 대한 이력 사항 기술
!-->
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
	String USER_NAME 	= info.getSession("NAME_LOC");
%>

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)--> 
<script language="javascript">
<!--
    var mode;

    var server_time;
    var diff_time;
 

    function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	    if(msg1 == "doQuery"){
       	    server_time = GD_GetParam(GridObj,0);
 
	    } else if(msg1 == "doData") {

	    } else if(msg1 == "t_imagetext") { //공고번호 click

            BID_NO      = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_NO);
            BID_COUNT   = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_COUNT);
            PR_NO       = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_PR_NO),msg2);
            BID_STATUS  = GD_GetCellValueIndex(GridObj,msg2, INDEX_BID_STATUS);

            var front_status = BID_STATUS.substring(0, 1);

            if(msg3 == INDEX_ANN_NO) {
                if(front_status != "C") { // 입찰공고, 정정공고
                    window.open('/ebid_doc/inchaldetail.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=600,left=0,top=0");
                } else {
                    window.open('/ebid_doc/inchalcancel.jsp?BID_NO='+BID_NO+'&BID_COUNT='+BID_COUNT,"ebd_bd_dis3","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=850,height=240,left=0,top=0");
                }
            } else if(msg3 == INDEX_PR_NO) {
                window.open('../pr/pr3_pp_dis1.jsp?PR_NO='+PR_NO,"windowopen2","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=840,height=680,left=0,top=0");
            }
        }
    }
 
 

     //enter를 눌렀을때 event발생
    function entKeyDown()
    {
        if(event.keyCode==13) {
            window.focus();   // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
            doSelect();
        }
    }
//-->
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doQuery();
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
var row_id = 0;
var filter_idx = 0;
var combobox = null;
var myDataProcessor = null;

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/sepoa.svl.sourcing.bd_confirm_list";

function init() {
    setGridDraw(); 
    doQuery();
	printDate();
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
		
		var url = "/sourcing/bd_ann_d_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&BID_TYPE="+bid_type+"&ANN_VERSION="+ ann_version;
		
		document.forms[0].BID_NO.value = bid_no;
		document.forms[0].BID_COUNT.value = bid_count; 
		document.forms[0].SCR_FLAG .value = "D"; 
		
		doOpenPopup(url,'1100','700');
    }
	else if(header_name == "VENDOR_COUNT" || header_name == "VENDOR_COUNT2" || header_name == "VENDOR_COUNT3"){

		var house_code       = "<%=house_code%>";
		var user_id          = "<%=user_id%>";
		var buyer_manager_id = "<%=buyer_manager_id%>";
		
		var BID_NO      	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_NO")).getValue());
		var BID_COUNT   	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("BID_COUNT")).getValue());
		var VOTE_COUNT  	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("VOTE_COUNT")).getValue());
		var PR_NO       	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("PR_NO")).getValue());
	    var change_user_id 	= LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
	    
	    if (user_id == change_user_id || user_id == buyer_manager_id) {
	    }else{
	        alert("담당자만 작업 가능합니다.");
	        return false;
	    }
		
		document.form.BID_NO.value = BID_NO;
		document.form.BID_COUNT.value = BID_COUNT;
		document.form.PR_NO.value = PR_NO;

    	url =  "bd_confirm_popup.jsp";
    	url += "?BID_NO=" + BID_NO + "&BID_COUNT=" + BID_COUNT + "&VOTE_COUNT=" + VOTE_COUNT + "&house_code=" + house_code;
	    window.open( url , "bd_confirm_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=800,height=500,left=0,top=0");
		
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
    var params = "mode=getBdConfrimList";
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
 


// ★GRID CHECK BOX가 체크되었는지 체크해주는 공통 함수[필수]
function checkRows() {

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    if( grid_array.length > 0 ) {
        return true;
    }

    alert("<%=text.get("MESSAGE.MSG_1001")%>");<%-- 대상건을 선택하십시오.--%>
    return false;

}

/*
하나만 선택했는지 체크
*/
function checkOneRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	if(grid_array.length > 0 && grid_array.length == 1)
	{
		return true;
	}

	alert("하나만 선택할 수 있습니다.");
	return false;
}

//마감
function doClose() {

    if(!checkRows()) return;
    
    if(!checkOneRows()) return;
 
//	var status = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_STATUS),row_idx);
/*
    if (status != "BT") {
       	alert("진행상황이 시간종료인 경우만 마감할 수 있습니다.");
       	return;
    }
*/
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

    var user_id        = "<%=user_id%>";
	var buyer_manager_id = "<%=buyer_manager_id%>";
	var house_code = "<%=house_code%>";
	
	for(var i = 0; i < grid_array.length; i++)
	{ 
		var BID_NO      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue());
		var BID_COUNT   = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		var VOTE_COUNT  = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("VOTE_COUNT")).getValue());
		var PR_NO       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("PR_NO")).getValue());
	    var change_user_id = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
	    <% /* MUP150200001 내부 - 총무부장 , MUP210200001 내부 - 총무팀장 , MUP150400001 WFIS관리자 */
	    if( !"MUP150200001".equals(info.getSession("MENU_PROFILE_CODE")) && 
	        !"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")) &&
	        !"MUP150400001".equals(info.getSession("MENU_PROFILE_CODE"))	  ){ 
	    %>
		    if (user_id == change_user_id || user_id == buyer_manager_id) {
		    }else{
		        alert("담당자만 작업 가능합니다.");
		        return false;
		    }
	    <% } %>
	}

	document.form.BID_NO.value = BID_NO;
	document.form.BID_COUNT.value = BID_COUNT;
	document.form.PR_NO.value = PR_NO;

// 	var Message = "마감하시겠습니까?";
	
// 	alert("BID_NO : " + BID_NO + "\n" + "BID_COUNT : " + BID_COUNT);

// 	if(confirm(Message) == 1){
    	url =  "bd_confirm_popup.jsp";
    	url += "?BID_NO=" + BID_NO + "&BID_COUNT=" + BID_COUNT + "&VOTE_COUNT=" + VOTE_COUNT + "&house_code=" + house_code;
	    window.open( url , "bd_confirm_popup","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=800,height=500,left=0,top=0");
// 	} 
// 		document.form.method = "POST";
// 		document.form.action = url;
// 		document.form.target = "bd_confirm_popup";
// 		document.form.submit();
}

</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" topmargin="0">
<s:header>
<form name="form" >
<input type="hidden" name="BID_NO" id="BID_NO" value="">
<input type="hidden" name="BID_COUNT" id="BID_COUNT" value="">
<input type="hidden" name="PR_NO" id="PR_NO" value="">
<input type="hidden" name="SCR_FLAG" value="">
<input type="hidden" name="ctrl_code" value="">
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
      		<td width="15%" class="title_td" style="display:none;">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰진행일자</td>
			<td width="35%" style="display:none;" class="data_td">
      			<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
        		id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰담당자</td>
      		<td  width="35%" class="data_td">
        		<input type="text" name="CHANGE_USER_NAME" id="CHANGE_USER_NAME"   value='<%=(!"MUP210200001".equals(info.getSession("MENU_PROFILE_CODE")))?USER_NAME:""%>' onkeydown='entKeyDown()' size="10" maxlength="10" >
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공고번호</td>
      		<td width="35%" class="data_td">
        		<input type="text" name="ann_no" id="ann_no" style="ime-mode:inactive" size="20" maxlength="20" onkeydown='entKeyDown()'>
      		</td>
    	</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>    	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명</td>
      		<td width="35%" class="data_td">
        		<input type="text" style="ime-mode:active;width:95%" onkeydown='entKeyDown()' name="ann_item" id="ann_item" >
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰구분</td>
      		<td width="35%" class="data_td">
		        <select id="BID_TYPE" name="BID_TYPE">
		        	<option value="">전체</option>
		        	<option value="D">구매입찰</option>
		        	<option value="C">공사입찰</option>
		        </select>	
      		</td>
		</tr>
		<tr>
			<td colspan="4" height="1" bgcolor="#dedede"></td>
		</tr>    	
    	<tr>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 현재시간</td>
      		<td width="35%" class="data_td">
        		<div id="id1"></div>
			    <input type="hidden" name="h_server_date" class="input_empty" size="50" readonly> 
      		</td>
      		<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 진행구분</td>
      		<td width="35%" class="data_td">
		        <select id="PROGRESS_TYPE" name="PROGRESS_TYPE">
		        	<option value="1">개찰 전</option>
		        	<option value="2">개찰 후</option>
		        	<option value="">전체</option>
		        </select>	
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
			    		<TD> <script language="javascript">btn("javascript:doQuery()", "조 회")</script></TD>
						<TD><script language="javascript">btn("javascript:doClose()", "입찰적격확인")</script></TD>
					</TR>
				</TABLE>
			</td>
		</tr>
	</table>
</form>
</s:header>
<!---- END OF USER SOURCE CODE ----> 

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="BD_006" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html> 