<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_BD_023");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	String company_code = info.getSession("COMPANY_CODE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_BD_023";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

	String WISEHUB_PROCESS_ID="I_BD_023";
	String ANN_NO 		= JSPUtil.nullToEmpty(request.getParameter("ANN_NO"));
	String ANN_COUNT 	= JSPUtil.nullToEmpty(request.getParameter("ANN_COUNT"));	
	
	String currentDateTime		= SepoaDate.getShortDateString() + SepoaDate.getShortTimeString();
	String BID_OPEN_DATE_VALUE 	= JSPUtil.nullToRef(request.getParameter("BID_OPEN_DATE_VALUE"), currentDateTime);
	
	boolean isVendorView = false;
	
	if(Long.parseLong(BID_OPEN_DATE_VALUE) <= Long.parseLong(currentDateTime)){
		isVendorView = true;
	}
	
	
	
	
	
	String HOUSE_CODE   = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");

    String current_date = SepoaDate.getShortDateString();//현재 시스템 날짜
    String current_time = SepoaDate.getShortTimeString();//현재 시스템 시간
    
    String CONT_TYPE1         = "";
    String CONT_TYPE2         = "";
    String ANN_ITEM           = "";
    String CONT_TYPE1_TEXT_D  = "";
    String CONT_TYPE2_TEXT_D  = "";
    
    String X_DOC_SUBMIT_DATE  = "";
    String X_DOC_SUBMIT_TIME  = "";
  
   	Map map = new HashMap();
   	map.put("ANN_NO"		, ANN_NO);
   	map.put("ANN_COUNT"		, ANN_COUNT);

   	Object[] obj = {map};
   	SepoaOut value = ServiceConnector.doService(info, "I_BD_019", "CONNECTION","getBdHeaderDetail", obj);
   	
   	SepoaFormater wf = new SepoaFormater(value.result[0]); 

	CONT_TYPE1                   = wf.getValue("CONT_TYPE1"            ,0);
	CONT_TYPE2                   = wf.getValue("CONT_TYPE2"            ,0);
	ANN_NO                       = wf.getValue("ANN_NO"                ,0);
	ANN_ITEM                     = wf.getValue("ANN_ITEM"              ,0);
	CONT_TYPE1_TEXT_D            = wf.getValue("CONT_TYPE1_TEXT_D"     ,0);
	CONT_TYPE2_TEXT_D            = wf.getValue("CONT_TYPE2_TEXT_D"     ,0);
	
	X_DOC_SUBMIT_DATE            = wf.getValue("X_DOC_SUBMIT_DATE"     ,0);
	X_DOC_SUBMIT_TIME            = wf.getValue("X_DOC_SUBMIT_TIME"     ,0);
%>
<html>
<head>
<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/include/include_css.jsp"%>
<%-- Dhtmlx SepoaGrid용 JSP--%>
<%@ include file="/include/sepoa_grid_common.jsp"%>
<script language=javascript src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
<%-- Ajax SelectBox용 JSP--%>
<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<script language="javascript">
//<!--
var mode;

function Init(){
	setGridDraw();
	setHeader();;
	

	//GD_setProperty(document.WiseGrid);
}

function setHeader() {
	
	doSelect();
}

function doSelect() {
	G_SERVLETURL   = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.sepoa.svl.sourcing.bd_open_list2_ict";
		
	var grid_col_id = "<%=grid_col_id%>";
	var params = "mode=getVendor";
	params += "&cols_ids=" + grid_col_id;
	params += dataOutput();
	GridObj.post( G_SERVLETURL, params );
	GridObj.clearAll(false);
}
	
function JavaCall(msg1, msg2, msg3, msg4, msg5) {
	if(msg1 == "doQuery") {}
}
//-->
</script>
<script language="javascript" type="text/javascript">
var GridObj = null;
var MenuObj = null;
var myDataProcessor = null;

function setGridDraw(){
    GridObj_setGridDraw();
    GridObj.setSizes();
}

// 그리드 클릭 이벤트 시점에 호출 됩니다. rowId 는 행의 ID이며 cellInd 값은 컬럼 인덱스 값이며
// 이벤트 처리시 컬럼명 과 동일하게 처리하시려면 GridObj.getColIndexById("selected") == cellInd 이렇게 처리하시면 됩니다.
function doOnRowSelected(rowId,cellInd){
	var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
    if(GridObj.getColIndexById("ATTACH_NO") == cellInd){
   	 	var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
   	    //var attach_cnt = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_CNT")).getValue();
   	 	//alert(attach_cnt)
   	 	if(attach_no != ""){
   			var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
       	 	var b = "fileDown";
       	 	var c = "300";
       	 	var d = "100";
       	 
       	 	window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
   	 	}
    }
    
    if(GridObj.getColIndexById("VENDOR_NAME") == cellInd){
		var vendor_code = GridObj.cells(rowId, GridObj.getColIndexById("VENDOR_CODE")).getValue();
		var irs_no = "";//GridObj.cells(rowId, INDEX_IRS_NO).getValue();
		window.open("/ict/s_kr/admin/info/ven_bd_con_ict.jsp?popup=Y&mode=irs_no&CompanyCode=<%=company_code%>&vendor_code="+vendor_code+"&irs_no="+irs_no+"&user_type=","ven_bd_con","left=0,top=0,width=950,height=700,resizable=yes,scrollbars=yes");
	}
}

// 그리드 셀 ChangeEvent 시점에 호출 됩니다.
// stage = 0 현재상태, 1 = 수정이전상태, 2 = 수정후상태, true 수정후값이 적용되며 false 는 수정이전값으로 적용됩니다.
function doOnCellChange(stage,rowId,cellInd){
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

// 서블릿으로 데이터를 입력 및 수정 및 삭제 처리 종료후에 호출 되는 이벤트 입니다.
// 서블릿에서 message, status, mode 값을 셋팅하면 값을 읽어옵니다.
function doSaveEnd(obj){
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
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" >
		<input type = "hidden" name="ANN_NO" 		id="ANN_NO"       	value="<%=ANN_NO%>">
		<input type = "hidden" name="ANN_COUNT" 	id="ANN_COUNT" 		value="<%=ANN_COUNT%>">
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>참여업체</span>
				</td>
			</tr>
		</table>
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
									<tr>
										<td width="15%" class="title_td">
											&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
											&nbsp;&nbsp;공고번호
										</td>
										<td class="data_td">
											<b><%=ANN_NO%></b>
										</td>
									</tr>
									<tr>
										<td colspan="2" height="1" bgcolor="#dedede"></td>
									</tr>    
								    <tr>
								        <td width="15%" class="title_td">
								            &nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">
								        	&nbsp;&nbsp;공고명
								        </td>
								        <td class="data_td">
								            <b><%=ANN_ITEM%></b>
								        </td>
								    </tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="30" align="right">
					<TABLE cellpadding="0">
						<TR>
							<TD>
								<script language="javascript">
									btn("javascript:window.close()","닫 기");
								</script>
							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>	
	</form>
</s:header>
<s:grid screen_id="I_BD_023" grid_obj="GridObj" grid_box="gridbox"/>
<s:footer/>
</body>
</html>