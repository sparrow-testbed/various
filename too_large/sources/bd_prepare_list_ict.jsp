<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_012");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_012";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
    String  to_date     = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1);

    String house_code       = info.getSession("HOUSE_CODE");
	String company_code     = info.getSession("COMPANY_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%> 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>  

<!-- 사용자 정의 Script -->
<!-- HEADER START (JavaScript here)-->

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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_prepare_list_ict";

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
    var params = "mode=getBdPrepareList";
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
function PopupManager(part)
{
	
	var wise = GridObj;
	var url = "";
	if(part=="CONTACT_USER")
	{
		//PopupCommon2("SP0023","getAddUser",G_HOUSE_CODE, G_COMPANY_CODE,"담당자ID","담당자명");
		PopupCommon2("SP0352","SP0352_getCode", "<%=info.getSession("HOUSE_CODE")%>", "<%=info.getSession("COMPANY_CODE")%>", "담당자ID", "담당자명");
	}
}
function getAddUser(USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION)
{
	document.form1.CONTACT_USER.value = USER_ID;
	document.form1.CONTACT_USER_NAME.value = USER_NAME_LOC;
}
function  SP0352_getCode(CTRL_NAME, CTRL_CODE, USER_ID, USER_NAME_LOC, DEPT_NAME_LOC, POSITION) {
	document.form1.CONTACT_USER.value = USER_ID;
	document.form1.CONTACT_USER_NAME.value = USER_NAME_LOC;
}

// 직무권한 체크
function checkUser() {
	var ctrl_code = "<%=info.getSession("CTRL_CODE")%>".split("&");
	var user_id = "<%=info.getSession("ID")%>";
	var flag = true;

	for(var row=0; row<GridObj.GetRowCount(); row++) {
		if("true" == GD_GetCellValueIndex(GridObj,row, INDEX_SELECTED)) {
			for( i=0; i<ctrl_code.length; i++ ){
				if((ctrl_code[i] == GD_GetCellValueIndex(GridObj,row, INDEX_CTRL_CODE)) || ( user_id == GD_GetCellValueIndex(GridObj,row, INDEX_ESTM_USER_ID))) {
					flag = true;
					break;
				} else {
					flag = false;
				}
			}
		}
	}

	if (!flag)
		alert("작업을 수행할 권한이 없습니다.");

		return flag;
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
function doForecasting() {
	//내정가격 담당자만 내가를 등록할 수 있는 권한이 있다.

	var url;

    var checked_count = 0;

    if(!checkRows()) return;
  
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
 
	
	for(var i = 0; i < grid_array.length; i++)
	{ 
        checked_count++;
		var BID_NO      	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_NO")).getValue()); 
		var BID_COUNT   	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_COUNT")).getValue());
		var BID_STATUS      = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_STATUS")).getValue());
	    var COST_STATUS 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("COST_STATUS")).getValue());
	    var ESTM_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ESTM_USER_ID")).getValue());
	    var ESTM_KIND 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ESTM_KIND")).getValue());
	    var BID_TYPE 		= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_TYPE")).getValue());
	    var CHANGE_USER_ID 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CHANGE_USER_ID")).getValue());
	    var BID_END_DATE 	= LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("BID_END_DATE")).getValue()).replaceAll("/", "").replaceAll(":", "").replaceAll(" ", "");

	    if("<%=info.getSession("ID")%>" != ESTM_USER_ID) {
           	alert("처리할 권한이 없습니다.");
               return;
           }
		
	    if(Number(BID_END_DATE + "00") < Number($("#h_server_date").val())){
	    	<%--입찰마감까지 내정가격 등록 가능 --%>
	    	alert("입찰이 종료되어 내정가격을 등록하실 수 없습니다.");
	    	return;
	    }
	    
 
    }

    if(checked_count == 0) {
        alert("선택된 로우가 없습니다.");
        return;
    }

    if(checked_count > 1) {
        alert("한 건만 선택하실 수 있습니다.");
        return;
    }

    url = "bd_prepare_insert_ict.jsp";

	document.form1.BID_NO.value = BID_NO;
	document.form1.BID_COUNT.value = BID_COUNT;
	document.form1.COST_STATUS.value = COST_STATUS;
	document.form1.BID_TYPE.value = BID_TYPE;
	document.form1.BID_STATUS.value = BID_STATUS;
    document.form1.method = "POST";
	document.form1.action = url;
	document.form1.target = "_self"; 
	document.form1.submit(); 
}



// 지우기
function doRemove( type ){
    if( type == "CONTACT_USER" ) {
    	document.forms[0].CONTACT_USER.value = "";
        document.forms[0].CONTACT_USER_NAME.value = "";
    }  
}
function entKeyDown(){
    if(event.keyCode==13) {
        window.focus(); // Key Down시 포커스 이동.. 쿼리후 세팅 값이 사라지는 것을 방지..
        
        doQuery();
    }
}
</script>
</head>
<body onload="init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작--> 
<form name="form1" >
	<input type="hidden" name="ctrl_code"	value="">
	<input type="hidden" name="BID_NO"		id="BID_NO">
	<input type="hidden" name="BID_COUNT"	id="BID_COUNT">
	<input type="hidden" name="COST_STATUS"	id="COST_STATUS">
	<input type="hidden" name="BID_TYPE"	id="BID_TYPE">
	<input type="hidden" name="BID_STATUS"	id="BID_STATUS">
	<input type="hidden" name="SCR_FLAG">
	<input type="hidden" name="BID_TYPE_C"	id="BID_TYPE_C" value ="D">
	

	<%@ include file="/include/sepoa_milestone.jsp"%>
	<table width="99%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5">&nbsp;</td>
		</tr>
	</table>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="5"> </td>
		</tr>
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
												<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 
												입찰일자
												</td>
												<td width="35%" class="data_td">
													<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
														id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>  
												</td>
												<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
													&nbsp;&nbsp; 진행상태</td>
												<td width="35%" class="data_td">
													<select name="BID_FLAG" id="BID_FLAG" >
														<option value="">전체</option>
														<option value="Y">확정</option>
														<option value="N" selected="selected">미확정</option>
													</select>
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>     
											<tr>
												<td width="15%" class="title_td">
													<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 공문번호
												</td>
												<td class="data_td">
													<input type="text" name="ANN_NO" id="ANN_NO" size="20" maxlength="20" style="ime-mode:inactive" onkeydown='entKeyDown()' >
												</td>
												<td width="15%" class="title_td">
													<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 입찰건명
												</td>
												<td class="data_td">
													<input type="text" style="width:95%" name="ANN_ITEM" id="ANN_ITEM" onkeydown='entKeyDown()' >
												</td>
											</tr>
											<tr>
												<td colspan="4" height="1" bgcolor="#dedede"></td>
											</tr>       
											<tr>
												<td width="15%" class="title_td">
													<div align="left">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 현재시간
												</td>
												<td width="35%" class="data_td">
													<div id="id1"></div>
													<input type="hidden" id="h_server_date" name="h_server_date" class="input_empty" size="50" readonly> 
												</td>
												<td class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp; 내정가격 담당자</td>
												<td class="data_td"><b>
													<input type="hidden" name="CONTACT_USER" id="CONTACT_USER" size="16" maxlength="10"  value='<%=info.getSession("ID")%>' >
													<input type="text" name="CONTACT_USER_NAME" id="CONTACT_USER_NAME" size="25"  readonly value='<%=info.getSession("NAME_LOC")%>' onkeydown='entKeyDown()' >
													<%--
													<a href="javascript:PopupManager('CONTACT_USER');">
														<img src="<%=POASRM_CONTEXT_NAME %>/images/button/query.gif" align="absmiddle" border="0" alt="">
													</a>
													 --%>
													<%--<a href="javascript:doRemove('CONTACT_USER')"><img src="<%=POASRM_CONTEXT_NAME%>/images/button/ico_x2.gif" align="absmiddle" border="0"></a>--%>
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
									<td><script language="javascript">btn("javascript:doForecasting()", "내정가격등록")</script></td>
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

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_BD_012" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>
 