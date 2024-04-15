<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_SBD_007");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_SBD_007";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	
    String  to_day      = SepoaDate.getShortDateString();
    String  from_date   = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1) );
    String  to_date     = SepoaString.getDateSlashFormat( SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),1) );
    
    //SUMMARY 에서 넘어온 경우 공고중 데이터만 조회
    String  bd_status_text = JSPUtil.nullToEmpty(request.getParameter("bd_status_text"));

    String selected = "";
    
    if(bd_status_text != "" ){
    
    	selected = "SELECTED";
    
    }
    
%>
<%-- 업체입찰공고 조회--%>
 
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> 
<%
    String house_code       = info.getSession("HOUSE_CODE");
	String user_id		    = info.getSession("ID");
	String ctrl_code	    = info.getSession("CTRL_CODE");
%>

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

var G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_ann_list_seller2_ict";

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
        var ann_no      = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_NO")).getValue());   
        var ann_count   = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_COUNT")).getValue());
		var ann_version = LRTrim(GridObj.cells(rowId, GridObj.getColIndexById("ANN_VERSION")).getValue());
		
		var url = "/ict/sourcing/bd_ann_d2_ict_"+ann_version+".jsp?SCR_FLAG=D&BID_STATUS=AR&ANN_VERSION="+ ann_version+"&VIEW_KIND=SUPPLY";
		
		document.forms[0].ANN_NO.value = ann_no;
		document.forms[0].ANN_COUNT.value = ann_count; 
		document.forms[0].SCR_FLAG.value = "D"; 
		
		doOpenPopup(url,'1100','700');
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
 
function doQuery() {

    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=getBdAnnListSeller";
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
    
    document.forms[0].start_change_date.value = add_Slash( document.forms[0].start_change_date.value );
    
    if(status == "0") alert(msg); 
    return true;
}
</script>
</head>
<body onload="javascript:init();" bgcolor="#FFFFFF" text="#000000" >

<s:header>
<!--내용시작-->

<form name="form1" >
	<input type="hidden" name="ctrl_code"	id="ctrl_code"	value=""> 
	<input type="hidden" name="att_mode"	id="att_mode"	value="">
	<input type="hidden" name="view_type"	id="view_type"	value="">
	<input type="hidden" name="file_type"	id="file_type"	value="">
	<input type="hidden" name="tmp_att_no"	id="tmp_att_no"	value="">
	<input type="hidden" name="SCR_FLAG"					value="">
	<input type="hidden" name="ANN_NO" >
	<input type="hidden" name="ANN_COUNT" >
	
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
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;공고일자
									</td>
									<td width="35%" class="data_td">
										<s:calendar id_from="start_change_date"  default_from="<%=SepoaString.getDateSlashFormat(from_date)%>" 
										id_to="end_change_date" default_to="<%=SepoaString.getDateSlashFormat(to_date)%>" format="%Y/%m/%d"/>
									</td> 
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;공고번호
									</td>
									<td width="35%" class="data_td">
										<input type="text" name="ann_no" id="ann_no" size="20" style="ime-mode:inactive" maxlength="20" class="inputsubmit">
									</td>
								</tr>
								<tr>
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>    
								<tr><td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;진행상태
									</td>
									<td width=35%" class="data_td">
										<select name="bd_status_text" id="bd_status_text" class="inputsubmit">
											<option value="">전체</option>
											<option value="ACUC" <%=selected %>>공고중</option>
											<%--<option value="CC">공고취소</option>--%>
										</select>
									</td>									
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;공고명
									</td>
									<td width="35%" class="data_td">
										<input type="text" name="ann_item" id="ann_item" style="width:95%" class="inputsubmit">
									</td>
								</tr>
								<tr style="display:none">
									<td colspan="4" height="1" bgcolor="#dedede"></td>
								</tr>  
								<tr style="display:none">
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;현재시간
									</td>
									<td width="35%" class="data_td">
										<div id="id1"></div>
										<input type="hidden" name="h_server_date" class="input_empty" size="50" readonly> 
									</td>									
									<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
										&nbsp;&nbsp;입찰구분
									</td>
									<td width=35%" class="data_td">
										<select name="ES_FLAG" id="ES_FLAG" class="inputsubmit">
											<option value="">전체</option>
											<option value="E" <%=selected %>>전자입찰</option>
											<option value="S">현장입찰</option>
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
			<td height="30">
				<div align="right">
					<table>
						<tr>
							<td><script language="javascript">btn("javascript:doQuery()", "조 회")</script></td>
							<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>

</form>
 
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_SBD_007" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


