<%--
    Title                            :          rfq_bd_lis1.jsp  <p>
    Description                      :          견적요청접수현황 <p>
    Copyright                        :          Copyright (c) <p>
    Company                          :          SEPOASOFT <p>
    @author                          :          WKHONG(2014.09.30)<p>
    @version                         :          1.0
    @Comment                         :          견적요청현황을 조회하는 화면이다.
    @SCREEN_ID                       :          SRQ_001
--%>
<%@ page contentType = "text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ taglib prefix="s" uri="/sepoa"%>
<%@ include file="/include/sepoa_common.jsp"%>
<%@ include file="/include/sepoa_session.jsp"%>
<%@ include file="/include/code_common.jsp"%>
<%@ include file="/include/sepoa_scripts.jsp"%>
<%
	Vector multilang_id = new Vector();
	multilang_id.addElement("SRQ_001");
	multilang_id.addElement("BUTTON");
	multilang_id.addElement("MESSAGE");
	
	HashMap text = MessageUtil.getMessage(info,multilang_id);
	
	String screen_id = "SRQ_001";
	String grid_obj  = "GridObj";
	boolean isSelectScreen = false;

%>
<% String WISEHUB_PROCESS_ID="SRQ_001";%>

<%
    String HOUSE_CODE = info.getSession("HOUSE_CODE");
    String COMPANY_CODE = info.getSession("COMPANY_CODE");
    
    String to_day = SepoaDate.getShortDateString();
	String from_date = SepoaDate.addSepoaDateMonth(SepoaDate.getShortDateString(),-1);
	String to_date = to_day;

%>

<html>
	<head>
		<title><%=text.get("MESSAGE.MSG_9999")%></title> <%-- 우리은행 전자구매시스템 --%> 
		<!-- META TAG 정의  -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<!-- 사용자 정의 Script -->
		<%@ include file="/include/include_css.jsp"%>
		<%-- Dhtmlx SepoaGrid용 JSP--%>
		<%@ include file="/include/sepoa_grid_common.jsp"%>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/sec.js"></script>
		<script language="javascript" src="<%=POASRM_CONTEXT_NAME %>/js/lib/jslb_ajax.js"></script>
		<%-- Ajax SelectBox용 JSP--%>
		<%@ include file="/include/jslb_ajax_selectbox.jsp"%>
<Script language="javascript" type="text/javascript">
//<!--
	var G_HOUSE_CODE   = "<%=HOUSE_CODE%>";
	var G_COMPANY_CODE = "<%=COMPANY_CODE%>";
	
var mode;

var INDEX_SELECTED;
var INDEX_BUYER_COMPANY_NAME;
var INDEX_BUYER_DEPT;
var INDEX_RFQ_NO;
var INDEX_RFQ_COUNT;
var INDEX_STATUS;
var INDEX_SUBJECT;
var INDEX_CLOSE_DATE;
var INDEX_BUYER_COMPANY_CODE;
var INDEX_RFQ_TYPE;

    function Init()
    {
		
		setGridDraw();
		setHeader();
        doSelect();
        
    }

    function setHeader() {

        INDEX_SELECTED				=         GridObj.GetColHDIndex("SELECTED");
        INDEX_BUYER_COMPANY_NAME   	=         GridObj.GetColHDIndex("BUYER_COMPANY_NAME");
        INDEX_RFQ_NO               	=         GridObj.GetColHDIndex("RFQ_NO");
        INDEX_RFQ_COUNT            	=         GridObj.GetColHDIndex("RFQ_COUNT");        
        INDEX_STATUS               	=         GridObj.GetColHDIndex("STATUS");

        INDEX_SUBJECT              	=         GridObj.GetColHDIndex("SUBJECT");
        INDEX_CLOSE_DATE           	=         GridObj.GetColHDIndex("CLOSE_DATE");
        INDEX_BUYER_USER_NAME		=         GridObj.GetColHDIndex("BUYER_USER_NAME");        
        INDEX_BUYER_COMPANY_CODE   	=         GridObj.GetColHDIndex("BUYER_COMPANY_CODE");    
        INDEX_RFQ_FLAG    	     	=         GridObj.GetColHDIndex("RFQ_FLAG");        

        INDEX_RFQ_CLOSE_DATE       	=         GridObj.GetColHDIndex("RFQ_CLOSE_DATE");        
        INDEX_BUYER_DEPT           	=         GridObj.GetColHDIndex("BUYER_DEPT");
        INDEX_RFQ_TYPE		     	=         GridObj.GetColHDIndex("RFQ_TYPE");        

    }

    function doSelect()
    {
         var fr = document.forms[0];
         
         var start_rfq_date = fr.start_rfq_date.value;
         var end_rfq_date   = fr.end_rfq_date.value;

        if(LRTrim(fr.start_rfq_date.value) == "" || LRTrim(fr.end_rfq_date.value) == "" ) {
            alert("생성일을 입력하셔야 합니다.");
            return;
        }

        if(!checkDateCommon(del_Slash(start_rfq_date))) {
            alert("생성일을 확인하세요.");
            document.forms[0].start_rfq_date.select();
            return;

        }

        if(!checkDateCommon(del_Slash(end_rfq_date))) {
            alert("생성일을 확인하세요.");
            document.forms[0].end_rfq_date.select();
            return;

        } 

       /*  var start_rfq_date = LRTrim(fr.start_rfq_date.value);
        var end_rfq_date   = LRTrim(fr.end_rfq_date.value);
        var status    = fr.status.options[fr.status.selectedIndex].value;     //진행상황 
        

        GridObj.SetParam("start_date", start_rfq_date);
        GridObj.SetParam("end_date", end_rfq_date); 
        GridObj.SetParam("status", status);  
        GridObj.SetParam("bid_rfq_type", "");  
        GridObj.SetParam("create_type", "PR");  

        GridObj.SetParam("WISETABLE_DOQUERY_DODATA","0");
		GridObj.SendData(servletUrl);
        GridObj.strHDClickAction="sortmulti"; */

        $('#bid_rfq_type').val("");
        $('#create_type').val("PR");
        //$('#str_status').val(fr.status.options[fr.status.selectedIndex].value);
        
        document.forms[0].start_rfq_date.value = del_Slash( document.forms[0].start_rfq_date.value );
        document.forms[0].end_rfq_date.value   = del_Slash( document.forms[0].end_rfq_date.value   );

        var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rfq.rfq_bd_lis1";
        var cols_ids = "<%=grid_col_id%>";
        var params = "mode=getQuery_New_Rfq_List";
        params += "&cols_ids=" + cols_ids;
        params += dataOutput();
        GridObj.post( G_SERVLETURL, params);
        GridObj.clearAll(false);
                
    }

    function setReject()
    {
        if(!confirm("견적포기를 하시겠습니까?")) {

        } else {
            var row = GridObj.GetRowCount();
            var chkcnt = 0;
			var rfq_no = "";
			var rfq_count = "";
			var rfq_type  = "";
						
            for(var i = 0;i < row;i++){
                var check = GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED);
                if(check == true){
                    chkcnt++;
                    rfq_no    = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_RFQ_NO),i);
                    rfq_count = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_RFQ_COUNT),i);
                    rfq_type  = GD_GetCellValueIndex(GridObj,i,INDEX_RFQ_TYPE);                    
                }
            }

            if(chkcnt == 0){
                alert(G_MSS1_SELECT);
                return;
            }
            //var sendRow="ALL";
            //var str = "";
            document.forms[0].start_rfq_date.value = del_Slash( document.forms[0].start_rfq_date.value );
            document.forms[0].end_rfq_date.value   = del_Slash( document.forms[0].end_rfq_date.value   );

            var G_SERVLETURL = "<%=POASRM_CONTEXT_NAME%>/servlets/supply.bidding.rfq.rfq_bd_lis1";
            var grid_array = getGridChangedRows(GridObj, "SELECTED");
    		var cols_ids = "<%=grid_col_id%>";
    		var params;
    		params = "?mode=setRejectRfq";
    		params += "&cols_ids=" + cols_ids;
    		params += dataOutput();
    		myDataProcessor = new dataProcessor(G_SERVLETURL+params);
    		//myDataProcessor.enableDebug("true");<!-- debugging 시 사용 -->
    		sendTransactionGrid(GridObj, myDataProcessor, "SELECTED",grid_array);
        
        }
    }

    function setQta()
    {
        var row = GridObj.GetRowCount();
        var chkcnt = 0;

        for(var i = 0;i < row;i++){
            var check = GD_GetCellValueIndex(GridObj,i, INDEX_SELECTED);
            if(check == true){
                chkcnt++;
                var rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_RFQ_NO),i);
                var rfq_count = GridObj.GetCellValue(GridObj.GetColHDKey(INDEX_RFQ_COUNT),i);
            }
        }

        if(chkcnt == 0){
            alert(G_MSS1_SELECT);
            return;
        }
        if(chkcnt > 1){
            alert(G_MSS2_SELECT);
            return;
        }

        document.forms[0].rfq_no.value = rfq_no;
        document.forms[0].rfq_count.value = rfq_count;
        
        document.forms[0].start_rfq_date.value = del_Slash( document.forms[0].start_rfq_date.value );
        document.forms[0].end_rfq_date.value   = del_Slash( document.forms[0].end_rfq_date.value   );
        

        if(confirm("견적서를 작성하시겠습니까?"))
        {
            //공개 입찰시 ICOYRQSE에 data 입력
            //if (document.forms[0].rfq_type.value == "OP")
            //{
            //    document.forms[0].method = "POST";
            //    document.forms[0].target = "childframe";
            //    document.forms[0].action = "rfq_wk_lis1.jsp";
            //    document.forms[0].submit();
            //
            //}else {
                var REDIRECT = "new";
                path = "../qta/qta_bd_ins.jsp?RFQ_NO="+rfq_no+"&RFQ_COUNT="+rfq_count+"&REDIRECT="+REDIRECT;
                document.location = path;
            //}
        }

    }


    function make_qta(rfq_no,rfq_count)
    {
        var REDIRECT = "new";
        path = "../qta/qta_bd_ins.jsp?RFQ_NO="+rfq_no+"&RFQ_COUNT="+rfq_count+"&REDIRECT="+REDIRECT;
        document.location = path;
    }

    function JavaCall(msg1,msg2,msg3,msg4,msg5)
    {

    for(var i=0;i<GridObj.GetRowCount();i++) {
           if(i%2 == 1){
		    for (var j = 0;	j<GridObj.GetColCount(); j++){
		        //GridObj.setCellbgColor(GridObj.GetColHDKey(j),i, "231|230|225");
	        }
           }
	}
	    
        if(msg1 == "t_imagetext"){
            if(msg3 == INDEX_RFQ_NO) { //견적요청번호
                rfq_no = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_RFQ_NO),msg2);
                rfq_count = GD_GetCellValueIndex(GridObj,msg2, INDEX_RFQ_COUNT);

                window.open("/s_kr/bidding/rfq/rfq_pp_dis1.jsp?rfq_no=" + rfq_no + "&rfq_count=" + rfq_count,"rfq_win1","toolbar=no, location=no, directories=no, status=yes,menubar=no,scrollbars=yes,resizable=yes,width=1050,height=600,left=0,top=0");
            } else if(msg3 == INDEX_BUYER_COMPANY_NAME) { // 구매업체
                company_code = GridObj.GetCellValue(GridObj.GetColHDKey( INDEX_BUYER_COMPANY_CODE),msg2);

                window.open("/s_kr/master/customer/cus_bd_dis1.jsp?flag=P&company_code=" + company_code,"companyWin","toolbar=no, location=no, directories=no, status=no,menubar=no,scrollbars=no,resizable=no,width=840,height=490,left=0,top=0");
            }
        }

        if(msg1 == "doData") {
            if(mode == "setReject") {

                var message = GD_GetParam(GridObj,0);
                alert(message);
                doSelect();
            }
        }
    }
    

//-->
</Script>

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
//     if("undefined" != typeof JavaCall) {
//     	JavaCall("doData");
//     } 

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
    /* if("undefined" != typeof JavaCall) {
    	JavaCall("doQuery");
    }  */
    
    document.forms[0].start_rfq_date.value = add_Slash( document.forms[0].start_rfq_date.value );
    document.forms[0].end_rfq_date.value   = add_Slash( document.forms[0].end_rfq_date.value   );
    
    return true;
}
</script>
</head>
<body onload="Init();" bgcolor="#FFFFFF" >

<s:header>
<!--내용시작-->

<form method="post" name="form" >
	<input type="hidden" name="rfq_no" value="">
	<input type="hidden" name="rfq_count" value="">
	<input type="hidden" name="str_status" id="str_status" value="">
	<input type="hidden" name="create_type" id="create_type" value="">
	<input type="hidden" name="bid_rfq_type" id="bid_rfq_type" value="">
	

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
		<tr>
			<td width="15%" class="title_td">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				 견적요청일자
			</td>
			<td class="data_td" colspan="3">
				
				<s:calendar id="start_rfq_date" default_value="<%=SepoaString.getDateSlashFormat( from_date ) %>" format="%Y/%m/%d"/>
				~
				<s:calendar id="end_rfq_date" default_value="<%=SepoaString.getDateSlashFormat( to_date ) %>" format="%Y/%m/%d"/>
			</td>
			<tr style="display:none;">
			<td class="title_td" width="15%">&nbsp;<img src="/images/blt_srch.gif" width="7" height="7" align="absmiddle">&nbsp;&nbsp;
				 진행상태
			</td>
			<td class="data_td" width="35%" colsapn="3">
				<select name="status" id="status" class="inputsubmit">
				<option value="">
					전체
				</option>
		<%
				String com1 = ListBox(request, "SL0018", HOUSE_CODE + "#"+"M640", "");
				out.println(com1);
		%>
				</select>
			</td>
			</tr>
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
	<td></td>
</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="30" align="left">
		<TABLE cellpadding="0">
		<TR>
		</TR>
		</TABLE>
	</td>
	<td height="30" align="right">
		<TABLE cellpadding="0">
		<TR>
			<TD><script language="javascript">btn("javascript:doSelect()","조 회")    </script></TD>
			<td><script language="javascript">btn("javascript:gridExport(<%=grid_obj%>);","엑셀다운")		</script></td>
			<TD><script language="javascript">btn("javascript:setQta()","견적서작성")   </script></TD>
			<TD><script language="javascript">btn("javascript:setReject()","견적포기")</script></TD> 
		</TR>
		</TABLE>
	</td>
</tr>
				
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td><b>※견적마감일자 또는 종료시간은 변동이 있을 수 있습니다.</b></td>
</tr>
</table>
<iframe name = "childframe" src=""  width="0%" height="0" border=0 frameborder=0></iframe>
</form>

</s:header>

<div id="gridbox" name="gridbox" width="100%" style="background-color:white;"></div>
<div id="pagingArea"></div>
<%-- <s:grid screen_id="SRQ_001" grid_obj="GridObj" grid_box="gridbox"/> --%>

<s:footer/>
</body>
</html>


