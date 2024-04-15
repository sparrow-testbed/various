<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("I_RQ_446");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "I_RQ_446";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;
	String G_IMG_ICON     = "/images/ico_zoom.gif"; 
	
	String WISEHUB_PROCESS_ID="I_RQ_446";
	request.setCharacterEncoding("utf-8");
    String rfq_no = JSPUtil.nullToEmpty(request.getParameter("rfq_no"));
	String rfq_count = JSPUtil.nullToEmpty(request.getParameter("rfq_count"));
	
 	Object[] obj = {rfq_no, rfq_count};
	SepoaOut value = ServiceConnector.doService(info, "I_p1004", "CONNECTION", "getRfqHDDisplay", obj);
	
	String RFQ_NM            = "";
	String BIZ_NO            = "";
	String BIZ_NM            = "";
	String STATUS            = "";
	String RFQ_STATUS        = "";
	String ITEM_NO           = "";
	String ITEM_NM           = "";
	String ITEM_CN           = "";
	String MFCO_CODE         = "";
	String MFCO_NM           = "";
	String RFQ_DATE          = "";
	String RFQ_CLOSE_DATE    = "";
	String SZTIME            = "";
	String SZMIN             = "";
	String RMK_TXT           = "";
	String RFQ_ID            = "";
	String RFQ_NAME          = "";
	String VENDOR_CNT        = "0";
	String VENDOR_INFO       = "";
	String VENDOR_VALUES     = "";
	
	SepoaFormater wf = new SepoaFormater(value.result[0]);

	if(wf != null) {
		if(wf.getRowCount() > 0) { //데이?린? 있는 경우

			RFQ_NM            =  wf.getValue("RFQ_NM", 0);
			BIZ_NO            =  wf.getValue("BIZ_NO", 0);
			BIZ_NM            =  wf.getValue("BIZ_NM", 0);
			STATUS            =  wf.getValue("STATUS", 0);
			RFQ_STATUS        =  wf.getValue("RFQ_STATUS", 0);
			ITEM_NO           =  wf.getValue("ITEM_NO", 0);
			ITEM_NM           =  wf.getValue("ITEM_NM", 0);
			ITEM_CN           =  wf.getValue("ITEM_CN", 0);
			MFCO_CODE         =  wf.getValue("MFCO_CODE", 0);
			MFCO_NM           =  wf.getValue("MFCO_NM", 0);
			RFQ_DATE          =  wf.getValue("RFQ_DATE", 0);
			RFQ_CLOSE_DATE    =  wf.getValue("RFQ_CLOSE_DATE", 0);
			SZTIME            =  wf.getValue("SZTIME", 0);
			SZMIN             =  wf.getValue("SZMIN", 0);
			RMK_TXT           =  wf.getValue("RMK_TXT", 0);
			RFQ_ID            =  wf.getValue("RFQ_ID", 0);
			RFQ_NAME          =  wf.getValue("RFQ_NAME", 0);
			VENDOR_CNT        =  wf.getValue("VENDOR_CNT", 0);
			VENDOR_INFO       =  wf.getValue("VENDOR_INFO", 0);	
			
			VENDOR_VALUES     = "";
			String strTemp = JSPUtil.nullToEmpty(VENDOR_INFO.replaceAll ( "&#64;" , "@" ));
			String[] arrayVENDOR_CODE = SepoaString.parser( strTemp, "#" );
            for( int j = 0; j < arrayVENDOR_CODE.length; j++ ) {
            	VENDOR_VALUES += arrayVENDOR_CODE[j].substring(0,5) + "@";
            }
		}
	}
	
	
	
	
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
var button_flag = false;

function Init(){
	setGridDraw();
	setHeader();;
	//GD_setProperty(document.WiseGrid);
}

function setHeader() {
	/* GridObj.SetColCellSortEnable("VENDOR_CODE",false);
	GridObj.SetColCellSortEnable("VENDOR_NAME",false);
	GridObj.SetColCellSortEnable("BID_FLAG",false); */
	
	doSelect();
}

function doSelect() {
	<%-- servletUrl = "<%=getWiseServletPath("dt.rfq.rfq_pp_dis7")%>"; --%>
	G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/ict.dt.rfq.rfq_bd_upd2";
	<%-- GridObj.SetParam("mode", "getVendorDisplay");
	GridObj.SetParam("rfq_no", "<%=rfq_no%>");
	GridObj.SetParam("rfq_count", "<%=rfq_count%>");
	
	GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
	GridObj.SendData(servletUrl); --%>
	
	var cols_ids = "<%=grid_col_id%>";
	var params = "mode=getRfqConfirmDetail";
	params += "&cols_ids=" + cols_ids;
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
    //alert(GridObj.cells(rowId, cellInd).getValue());
<%--    
		GD_CellClick(document.WiseGrid,strColumnKey, nRow);

    
    if("undefined" != typeof JavaCall) {
    	type = "";
    	if(GridObj.getColType(cellInd) == 'img') {
    		type = "t_imagetext";
    	}
    	JavaCall(type, "", cellInd);
    }
--%>
	var header_name = GridObj.getColumnId( cellInd ); // 선택한 셀의 컬럼명
	if(header_name == "VENDOR_NAME") {		
		var vendor_code = SepoaGridGetCellValueId(GridObj, rowId, "VENDOR_CODE");
		
		if(vendor_code != null && vendor_code != "") {
		
			var url    = '/ict/s_kr/admin/info/ven_bd_con_ict.jsp';
			var title  = '업체상세조회';
			var param  = 'popup=Y';
			param     += '&mode=irs_no';
			param     += '&vendor_code=' + vendor_code;
			popUpOpen01(url, title, '900', '700', param);
			
		}
	}else if(cellInd == GridObj.getColIndexById("QTA_NO")) {
		var rfq_no      = GridObj.cells(rowId, GridObj.getColIndexById("RFQ_NO")).getValue();
		var rfq_count   = GridObj.cells(rowId, GridObj.getColIndexById("RFQ_COUNT")).getValue();
	    var rfq_seq     = GridObj.cells(rowId, GridObj.getColIndexById("RFQ_SEQ")).getValue();
		
		var item_no     = GridObj.cells(rowId, GridObj.getColIndexById("ITEM_NO")).getValue();	
	
		var qta_no = GridObj.cells(rowId, GridObj.getColIndexById("QTA_NO")).getValue();
		
		if(qta_no != null && qta_no != "") {
			url = '/ict/s_kr/bidding/rfq/rfq_bd_dis02_ict.jsp?rfq_no=' + encodeUrl(rfq_no) + '&rfq_count=' + encodeUrl(rfq_count) + '&rfq_seq=' + encodeUrl(rfq_seq) + "&item_no=" + encodeUrl(item_no);
			popUpOpen(url, 'GridCellClick', '1024', '650');	
		}
	}else  if(GridObj.getColIndexById("ATTACH_NO") == cellInd){
	   	 var attach_no = GridObj.cells(rowId, GridObj.getColIndexById("ATTACH_NO_H")).getValue();
		 
		 if(attach_no != ""){
			 var a = "/sepoafw/filelob/file_attach_downloadView.jsp?attach_key=" + attach_no + "&view_type=VI";
	    	 var b = "fileDown";
	    	 var c = "300";
	    	 var d = "100";
	    	 
	    	 window.open(a,b,'left=50, top=50, width='+c+', height='+d+', resizable=0,toolbar=0,location=0,directories=0,status=0,menubar=0');
		 }
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
    
    //alert(messsage);

    if(status == "true") {
        alert(messsage);
        button_flag = false;
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

function checkData() {
	var checked_count = 0;
	var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다

	for(var i = 0; i < grid_array.length; i++)
	{ 
		var CONFIRM_FLAG       = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_FLAG")).getValue());
		var CONFIRM_REASON     = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_REASON")).getValue());
		var SUBMIT_FLAG        = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("SUBMIT_FLAG")).getValue());
		var ATTACH_NO          = LRTrim(GridObj.cells(grid_array[i], GridObj.getColIndexById("ATTACH_NO")).getValue());
            // 최종결과 부적합 판정시 사유를 반드시 입력 
		 
             if (CONFIRM_FLAG == "R") {
                if(CONFIRM_REASON == "") {
                    alert("보완요청 사유를 반드시 입력해야 합니다.");
                    return false;
                }
            }
            
            if (CONFIRM_FLAG == "N") {
                if(CONFIRM_REASON == "") {
                    alert("확인결과가 부적합 시에는 사유를 반드시 입력해야 합니다.");
                    return false;
                }
            }
            
            if (CONFIRM_FLAG == "Y") {
                if(SUBMIT_FLAG != "Y" || ATTACH_NO == "") {
                    alert("업체가 견적서를 제출하여야 확인결과 적합이 가능합니다.");
                    return false;
                }
            }

            checked_count++; 
    }
	return true;
}

// 그리드의 선택된 행의 존재 여부를 리턴하는 함수 입니다.
function checkRows()
{
	var grid_array = getGridChangedRows(GridObj, "SELECTED");

	if(grid_array.length > 0)
	{
		return true;
	}

	alert("<%=text.get("MESSAGE.1004")%>");
	return false;
}

function doConfirm() {

    if(button_flag == true) {
        alert("작업이 진행중입니다.");
        return;
    }

    button_flag = true;
 
    if (checkData() == false) {
        button_flag = false;
        return;
    }

	if(!checkRows()) {
		button_flag = false;
        return; 
	}
	var grid_array = getGridChangedRows(GridObj, "SELECTED");
	
	for(var i = 0; i < grid_array.length; i++) {
		
		confirm_flag     = GridObj.cells(grid_array[i], GridObj.getColIndexById("CONFIRM_FLAG")).getValue();
		attach_cnt     = GridObj.cells(grid_array[i], GridObj.getColIndexById("ATTACH_CNT")).getValue();
		
		
		if( confirm_flag == "" ){
			alert("확인결과를 선택하세요.");
			button_flag = false;
			return;
		}
		
	}	
	
	if(confirm("확인 하시겠습니까?") != 1) {
        button_flag = false;
        return;
    }

    var grid_array = getGridChangedRows( GridObj, "SELECTED" ); // 선택 BOX에 체크된건을 가져온다
	var rowcount = grid_array.length;
 
    var cols_ids = "<%=grid_col_id%>";
    var params = "mode=doConfirm";
 
    params += "&cols_ids=" + cols_ids;
    params += dataOutput();
    myDataProcessor = new dataProcessor( G_SERVLETURL, params ); 
    sendTransactionGridPost( GridObj, myDataProcessor, "SELECTED", grid_array );
}
</script>
</head>
<body onload="javascript:Init();" bgcolor="#FFFFFF" topmargin="0" marginwidth="0" leftmargin="0" >
<s:header popup="true">
	<form name="form1" >
		<input type = "hidden" name="rfq_no" id="rfq_no"       value="<%=rfq_no%>">
		<input type = "hidden" name="rfq_count" id="rfq_count" value="<%=rfq_count%>">
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0" >
			<tr>
				<td class='title_page' height="20" align="left" valign="bottom">
					<span class='location_end'>견적서확인</span>
				</td>
			</tr>
		</table>
		<table width="99%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td height="5">&nbsp;</td>
			</tr>
		</table>
		
		
		
		<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="#dedede">
<tr>
	<td width="100%">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;사업명<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<%=BIZ_NM%> (<%=BIZ_NO%>)					
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청명<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
					<%=RFQ_NM%>
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적요청번호</td>
				<td width="35%"  class="data_td">
					<%=rfq_no%>
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;차수</td>
				<td width="35%"  class="data_td"><%=rfq_count%>
				</td>
			</tr>			
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적품목<font style="color: red;">*</font></td>
				<td class="data_td">
				    <%=ITEM_NM%>
					<select name="sel_item_no" id="sel_item_no" style="ime-mode:disabled;display:none;" disabled readonly class="inputsubmit">
									<option value="">선택</option>
<%
	String  lb_item_no = ListBox(request, "SL0019",info.getSession("HOUSE_CODE") + "#" + "M680_ICT" + "#" + "0", ITEM_NO);
	out.println(lb_item_no);
%>
					</select>
				</td>
				<td width="50%" class="title_td" colspan="2">
					<table>
						<tr>
							<td width="15%" class="title_td"><img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;제조사<font style="color: red;">*</font></td>
							<td width="55%"  class="data_td">&nbsp;&nbsp;&nbsp;&nbsp;
								<%=MFCO_NM%>
							</td>
							<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;수량
							<td width="15%"  class="data_td">&nbsp;&nbsp;&nbsp;&nbsp;
								<%=ITEM_CN%>
						    </td>
						</tr>
					</table>				
				</td>				
			</tr>											
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>	
			<tr>				
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적마감일<font style="color: red;">*</font></td>
				<td width="35%" class="data_td">
				    <%=RFQ_CLOSE_DATE%> <%=SZTIME%>시 <%=SZMIN%>분
				</td>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;견적담당자<font style="color: red;">*</font></td>
				<td width="85%" class="data_td" colspan=3>
				    <%=RFQ_NAME%> (<%=RFQ_ID%>)
				</td>
			</tr>
			<tr>
				<td colspan="4" height="1" bgcolor="#dedede"></td>
			</tr>
			<tr>
				<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;비고</td>
				<td class="data_td" colspan="3" height="150px">
					<table width="98%" >
						<tr>
							<td>
							    <pre><%=RMK_TXT%></pre>
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
							<TD><script language="javascript">btn("javascript:doConfirm();", "확 인")</script></TD>
							<TD><script language="javascript">btn("javascript:window.close()","닫 기");</script>							</TD>
						</TR>
					</TABLE>
				</td>
			</tr>
		</table>	
	</form>
</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="I_RQ_446" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>